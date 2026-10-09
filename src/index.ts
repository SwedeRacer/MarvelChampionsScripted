import TTS, { OutgoingJsonObject } from "@matanlurey/tts-editor";
import * as expander from "@matanlurey/tts-expander";
import * as steam from "@matanlurey/tts-runner/steam_finder";
import { ObjectState } from "@matanlurey/tts-save-files";
import fs from "fs-extra";
import os from "os";
import path from "path";

function getWindowsTtsHomeDirs(env: NodeJS.ProcessEnv): string[] {
  const dirs: string[] = [];
  const primary = steam.homeDir.win32(env);
  if (primary) {
    dirs.push(primary);
  }
  const oneDriveBase = env.OneDrive || env.OneDriveConsumer;
  if (oneDriveBase) {
    dirs.push(path.join(oneDriveBase, "Documents", "My Games", "Tabletop Simulator"));
  }
  return [...new Set(dirs.map((dir) => path.resolve(dir)))];
}

async function replaceWithSymlink(linkPath: string): Promise<void> {
  if (!(await fs.pathExists(linkPath))) {
    return;
  }
  const stats = await fs.lstat(linkPath);
  if (stats.isSymbolicLink()) {
    await fs.remove(linkPath);
    return;
  }
  const backupPath = `${linkPath}.backup.${Date.now()}`;
  await fs.move(linkPath, backupPath);
  console.warn(`Moved existing non-link path to \"${backupPath}\" before creating symlink.`);
}

/**
 * Reads a `{TTS-SAVE-FILE}.json`, and replaces the contents of a directory.
 */
export async function extractSaveFile(
  source: string,
  output: string
): Promise<void> {
  if (!fs.pathExists(source)) {
    throw new Error(`No source file "${source}".`);
  }
  if (!fs.pathExists(output)) {
    console.info(`Creating output directory "${output}"`);
    await fs.mkdirp(output);
  } else {
    const baseName = path.basename(source).split(".")[0];
    const modOutput = path.join(output, baseName);
    console.info(`Clearing output directory "${modOutput}"`);
    await fs.remove(modOutput);
    await fs.mkdirp(modOutput);
    console.info(`Cleared "${modOutput}"`);
  }
  const splitter = new expander.SplitIO();
  const modTree = await splitter.readSaveAndSplit(source);
  await splitter.writeSplit(output, modTree);
  console.info(`Wrote "${output}"...`);
}

function concatAllObjectScripts(
  states: ObjectState[],
  buffer?: OutgoingJsonObject[]
): OutgoingJsonObject[] {
  const writeBuffer = buffer || [];
  states.forEach((state) => {
    const { GUID } = state;
    if (!GUID) {
      return;
    }
    writeBuffer.push({
      guid: GUID,
      script: state.LuaScript,
      ui: state.XmlUI,
    });
    if (state.ContainedObjects) {
      concatAllObjectScripts(state.ContainedObjects, writeBuffer);
    }
  });
  return writeBuffer;
}

export async function compileSaveFile(
  source: string,
  output: string,
  options?: { reload: boolean }
): Promise<void> {
  if (!fs.pathExists(source)) {
    throw new Error(`No source directory "${source}".`);
  }
  const outputDir = path.dirname(output);
  if (!fs.pathExists(outputDir)) {
    console.info(`Creating output directory "${outputDir}"`);
    await fs.mkdirp(outputDir);
  } else {
    console.info(`Clearing output directory "${outputDir}"`);
    await fs.remove(outputDir);
    await fs.mkdirp(outputDir);
  }
  await generateFiles();
  // await buildDeckSchemaLua(
  //     path.join('contrib', 'cards', 'official.json'),
  //     path.join('mod', 'src', 'includes', 'generated', 'cards.ttslua'),
  // );
  console.info(`Reading "${source}"...`);
  const splitter = new expander.SplitIO();
  const saveFile = await splitter.readAndCollapse(source);
  console.info(`Writing "${output}"...`);
  await fs.writeJson(output, saveFile);
  console.info(`Wrote "${output}"...`);
  if (options?.reload) {
    const api = new TTS();
    const json: OutgoingJsonObject[] = [
      {
        guid: "-1",
        script: saveFile.LuaScript,
        ui: saveFile.XmlUI,
      },
      ...concatAllObjectScripts(saveFile.ObjectStates),
    ];
    try {
      await api.saveAndPlay(json);
      console.info(`Sent reload command!`);
    } catch (e) {
      console.warn(`Could not reload. Is TTS currently running?`, e);
    }
  }
}

export async function destroySymlink(homeDir?: string): Promise<void> {
  // TODO: Add non-win32 support.
  if (os.platform() !== "win32") {
    throw new Error(`Unsupported platform: ${os.platform()}`);
  }
  const homeDirs = homeDir ? [homeDir] : getWindowsTtsHomeDirs(process.env);
  for (const dir of homeDirs) {
    const from = path.join(dir, "Saves", "TTSDevLink");
    if (!(await fs.pathExists(from))) {
      continue;
    }
    const stats = await fs.lstat(from);
    if (stats.isSymbolicLink()) {
      await fs.remove(from);
    }
  }
}

export async function createSymlink(homeDir?: string): Promise<string> {
  // TODO: Add non-win32 support.
  if (os.platform() !== "win32") {
    throw new Error(`Unsupported platform: ${os.platform()}`);
  }
  const homeDirs = homeDir ? [homeDir] : getWindowsTtsHomeDirs(process.env);
  const target = path.resolve("dist");
  let createdPath = "";
  for (const dir of homeDirs) {
    const from = path.join(dir, "Saves", "TTSDevLink");
    await fs.mkdirp(path.dirname(from));
    await replaceWithSymlink(from);
    await fs.symlink(target, from, "junction");
    if (!createdPath) {
      createdPath = from;
    }
  }
  if (!createdPath) {
    throw new Error("Could not determine a Tabletop Simulator save path.");
  }
  return createdPath;
}

export async function generateFiles(): Promise<void> {
  return Promise.resolve();
  // console.info(`Generating additional files...`);
  // await buildDeckSchemaLua(
  //     path.join('contrib', 'cards', 'official.json'),
  //     path.join('mod', 'src', 'includes', 'generated', 'cards.ttslua'),
  // );
}
