#!/usr/bin/env node
/**
 * Sanitizes the Cardpool_Data file to remove control characters and replace Unicode with ASCII equivalents
 * Usage: node sanitize-text.js
 */

const fs = require('fs');
const path = require('path');

// Always sanitize the Cardpool_Data file
const inputFile = path.join(__dirname, '..', 'mod', 'src', 'MarvelChampionsLCG', 'Cardpool_Data.843931.lua');
const outputFile = inputFile;

// Character replacement map
const replacements = {
  // Dashes
  '\u2014': '-',    // Em dash —
  '\u2013': '-',    // En dash –
  '\u2212': '-',    // Minus sign −
  
  // Quotes
  '\u2018': "'",    // Left single quote '
  '\u2019': "'",    // Right single quote '
  '\u201C': '"',    // Left double quote "
  '\u201D': '"',    // Right double quote "
  
  // Other punctuation
  '\u2026': '...',  // Ellipsis …
  '\u2022': '*',    // Bullet •
  '\u00B7': '*',    // Middle dot ·
  
  // Arrows
  '\u2192': '->',   // Rightward arrow →
  '\u2190': '<-',   // Leftward arrow ←
  
  // Musical notes
  '\u266B': '[music]',  // Beamed eighth notes ♫
  '\u266A': '[music]',  // Eighth note ♪
};

console.log(`Sanitizing: ${inputFile}`);

// Read the file
let content = fs.readFileSync(inputFile, 'utf8');

console.log(`Original length: ${content.length} characters`);

// Remove BOM if present
if (content.charCodeAt(0) === 0xFEFF) {
  content = content.slice(1);
}

// Replace Unicode characters
let replaceCount = 0;
for (const [unicode, ascii] of Object.entries(replacements)) {
  const regex = new RegExp(unicode, 'g');
  const matches = content.match(regex);
  if (matches) {
    console.log(`  Replacing ${matches.length} instance(s) of '${unicode}' with '${ascii}'`);
    content = content.replace(regex, ascii);
    replaceCount += matches.length;
  }
}

// Remove control characters (bytes 1-31) except tab (9), LF (10), and CR (13)
const buffer = Buffer.from(content, 'utf8');
const cleanBuffer = [];
let removedCount = 0;

for (let i = 0; i < buffer.length; i++) {
  const byte = buffer[i];
  
  // Keep all normal characters and allowed control chars
  if (byte >= 32 || byte === 9 || byte === 10 || byte === 13) {
    cleanBuffer.push(byte);
  } else {
    // Skip control character
    removedCount++;
  }
}

if (removedCount > 0) {
  console.log(`  Removed ${removedCount} control character(s)`);
  content = Buffer.from(cleanBuffer).toString('utf8');
}

console.log(`Sanitized length: ${content.length} characters`);

// Write the file (UTF-8 without BOM)
fs.writeFileSync(outputFile, content, 'utf8');

console.log(`Saved to: ${outputFile}`);
console.log('Done!');
