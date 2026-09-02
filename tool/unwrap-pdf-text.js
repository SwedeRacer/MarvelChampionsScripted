#!/usr/bin/env node
/**
 * Heuristically unwrap PDF-copied text while preserving likely paragraphs.
 *
 * Usage:
 *   node tool/unwrap-pdf-text.js <inputFile> [outputFile]
 */

const fs = require('fs');
const path = require('path');

function usageAndExit() {
  console.error('Usage: node tool/unwrap-pdf-text.js <inputFile> [outputFile]');
  process.exit(1);
}

function median(values) {
  if (values.length === 0) return 72;
  const sorted = [...values].sort((a, b) => a - b);
  const mid = Math.floor(sorted.length / 2);
  if (sorted.length % 2 === 0) return Math.round((sorted[mid - 1] + sorted[mid]) / 2);
  return sorted[mid];
}

function hasLetters(text) {
  return /[A-Za-z]/.test(text);
}

const SMALL_WORDS = new Set([
  'a', 'an', 'the', 'and', 'but', 'or', 'nor', 'for', 'so', 'yet',
  'at', 'by', 'in', 'of', 'on', 'to', 'up', 'as', 'vs', 'via'
]);

function toTitleCaseHeader(text) {
  const pieces = text.split(/(\s+|\/|[-()])/);
  let wordIndex = 0;

  return pieces
    .map((part) => {
      if (!/^[A-Za-z][A-Za-z']*$/.test(part)) return part;

      const lower = part.toLowerCase();
      const isFirstWord = wordIndex === 0;
      wordIndex += 1;

      if (!isFirstWord && SMALL_WORDS.has(lower)) {
        return lower;
      }

      return lower.charAt(0).toUpperCase() + lower.slice(1);
    })
    .join('')
    .replace(/\s*\/\s*/g, ' / ')
    .replace(/\s{2,}/g, ' ')
    .trim();
}

function repairBrokenHeader(line) {
  const normalized = line
    .replace(/\s*\/\s*/g, ' / ')
    .replace(/\s+/g, ' ')
    .trim();

  // Only run aggressive repair on all-caps style headers where OCR splits are common.
  if (!isAllCapsHeading(normalized)) {
    return normalized;
  }

  let tokens = normalized.split(' ');
  let changed = true;

  while (changed) {
    changed = false;
    const merged = [];

    for (let i = 0; i < tokens.length; i++) {
      const token = tokens[i];

      if (token === '/') {
        merged.push(token);
        continue;
      }

      if (!/^[A-Za-z]+$/.test(token) || i === tokens.length - 1) {
        merged.push(token);
        continue;
      }

      const next = tokens[i + 1];
      if (!/^[A-Za-z]+$/.test(next)) {
        merged.push(token);
        continue;
      }

      const lenA = token.length;
      const lenB = next.length;
      const lowerA = token.toLowerCase();
      const lowerB = next.toLowerCase();

      const stopwordLikeA = SMALL_WORDS.has(lowerA);
      const stopwordLikeB = SMALL_WORDS.has(lowerB);

      // Keep real short words (A, THE, TO, etc.) separate unless they strongly
      // look like OCR-split fragments (e.g., OR + DER -> ORDER).
      const allowStopwordMergeA = stopwordLikeA && lenA <= 2 && lenB <= 3;
      const allowStopwordMergeB = false;

      if ((stopwordLikeA && !allowStopwordMergeA) || (stopwordLikeB && !allowStopwordMergeB)) {
        merged.push(token);
        continue;
      }

      const looksLikeSuffixFragment = /^(?:ION|ING|IVE|ISM|IST|EST|ERS|ER|ED|AL|IC|LY|TY|ARY|ORY|NESS)$/i.test(next);

      const shouldMerge =
        // Tiny fragments are usually OCR splits.
        lenA <= 2 ||
        lenB <= 2 ||
        // Common 3+3 split like ACT ION.
        (lenA === 3 && lenB === 3) ||
        // Common 4+4 split like PARA DIGM.
        (lenA <= 4 && lenB === 4) ||
        // Long prefix + short suffix fragment like INITIAT IVE.
        (lenA >= 5 && lenB <= 3 && looksLikeSuffixFragment) ||
        // 3+5 split like SUR PRISE.
        (lenA === 3 && lenB >= 5);

      if (shouldMerge) {
        merged.push(token + next);
        i += 1;
        changed = true;
      } else {
        merged.push(token);
      }
    }

    tokens = merged;
  }

  return tokens.join(' ').replace(/\s+\//g, ' /').replace(/\/\s+/g, '/ ').trim();
}

function isAllCapsHeading(line) {
  if (!line || line.length > 80 || !hasLetters(line)) return false;
  const letters = line.replace(/[^A-Za-z]/g, '');
  if (letters.length < 3) return false;
  const lower = (letters.match(/[a-z]/g) || []).length;
  return lower === 0;
}

function isTitleHeading(line) {
  if (!line || line.length > 42 || !hasLetters(line)) return false;
  if (/[.!?;:]$/.test(line)) return false;
  const words = line.trim().split(/\s+/);
  if (words.length < 1 || words.length > 5) return false;
  const titleCaseWords = words.filter((w, idx) => {
    if (/^[A-Z][a-z]+(?:['-][A-Za-z]+)?$/.test(w)) return true;
    if (idx > 0 && SMALL_WORDS.has(w.toLowerCase())) return true;
    return false;
  });
  return titleCaseWords.length === words.length;
}

function isHeading(line) {
  return isAllCapsHeading(line) || isTitleHeading(line);
}

function formatHeading(line) {
  const repaired = repairBrokenHeader(line);
  const titled = toTitleCaseHeader(repaired);
  return `# ${titled} #`;
}

function normalize(input) {
  let text = input.replace(/\r\n?/g, '\n');
  text = text.replace(/\u00AD/g, '');
  text = text.replace(/[\t\f\v]+/g, ' ');
  text = text.replace(/[ ]+\n/g, '\n');
  text = text.replace(/\n{3,}/g, '\n\n');

  // De-hyphenate wrapped words: exam-\nple -> example
  text = text.replace(/([A-Za-z])-\n([a-z])/g, '$1$2');

  // Join line-broken numeric ranges: 10-\n200 -> 10-200
  text = text.replace(/(\d)\s*[\u2013-]\s*\n\s*(\d)/g, '$1-$2');
  return text;
}

function unwrap(text) {
  const lines = text.split('\n').map((l) => l.replace(/\s+$/g, ''));
  const bodyLengths = [];

  for (const line of lines) {
    const trimmed = line.trim();
    if (!trimmed) continue;
    if (isHeading(trimmed)) continue;
    if (trimmed.length >= 20 && trimmed.length <= 140) bodyLengths.push(trimmed.length);
  }

  const wrapWidth = median(bodyLengths);
  const shortLineThreshold = Math.max(35, Math.floor(wrapWidth * 0.72));

  const out = [];
  let paragraph = [];

  function flushParagraph() {
    if (paragraph.length === 0) return;
    const joined = paragraph.join(' ').replace(/\s{2,}/g, ' ').trim();
    if (joined) out.push(joined);
    paragraph = [];
  }

  for (let i = 0; i < lines.length; i++) {
    const raw = lines[i];
    const line = raw.trim();
    const next = i + 1 < lines.length ? lines[i + 1].trim() : '';

    if (!line) {
      flushParagraph();
      continue;
    }

    if (isHeading(line)) {
      flushParagraph();

      // Merge a single stacked title-case heading line like "Starting a" + "Cinematic".
      let combined = line;
      while (
        i + 1 < lines.length &&
        isHeading(lines[i + 1].trim()) &&
        !isAllCapsHeading(combined) &&
        !isAllCapsHeading(lines[i + 1].trim())
      ) {
        combined += ` ${lines[i + 1].trim()}`;
        i += 1;
      }

      out.push(formatHeading(combined));
      out.push('');
      continue;
    }

    paragraph.push(line);

    const lineEndsSentence = /[.!?)](?:["'])?$/.test(line);
    const nextIsHeading = next && isHeading(next);
    const likelyParagraphEnd = lineEndsSentence && line.length <= shortLineThreshold;

    if (nextIsHeading || likelyParagraphEnd) {
      flushParagraph();
      out.push('');
    }
  }

  flushParagraph();

  // Collapse excess blank lines while preserving a single blank between blocks.
  const compact = [];
  for (const line of out) {
    if (line === '' && compact[compact.length - 1] === '') continue;
    compact.push(line);
  }

  return compact.join('\n').replace(/\n{3,}/g, '\n\n').trim() + '\n';
}

const inputFile = process.argv[2];
const outputFile = process.argv[3];

if (!inputFile) usageAndExit();

const inPath = path.resolve(process.cwd(), inputFile);
if (!fs.existsSync(inPath)) {
  console.error(`Input file not found: ${inPath}`);
  process.exit(1);
}

const outPath = outputFile
  ? path.resolve(process.cwd(), outputFile)
  : inPath.replace(/(\.[^.]+)?$/, '.cleaned.txt');

const inputText = fs.readFileSync(inPath, 'utf8');
const normalized = normalize(inputText);
const cleaned = unwrap(normalized);

fs.writeFileSync(outPath, cleaned, 'utf8');

console.log(`Input:  ${inPath}`);
console.log(`Output: ${outPath}`);
console.log('Done.');