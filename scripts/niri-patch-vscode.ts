#!/usr/bin/env node
import JSONC from 'jsonc-parser'
import { accessSync, constants, readFileSync, writeFileSync } from 'node:fs'
import os from 'node:os'

const HOME = os.homedir()
for (let i = 2; i < process.argv.length; i++) {
  const name = process.argv[i].toLowerCase()
  if (name.startsWith('-')) {
    console.error(`Usage: ${process.argv[1]} <name>..`)
    process.exit(1)
  }
  const argvFile = `${HOME}/.${name}/argv.json`
  try {
    accessSync(argvFile, constants.F_OK | constants.R_OK)
  } catch {
    console.error(`No argv.json file: ${argvFile}`)
    continue
  }
  const text = readFileSync(argvFile, 'utf-8')
  const edits = JSONC.modify(text, ['password-store'], 'gnome-libsecret', {
    formattingOptions: {
      insertFinalNewline: true,
      insertSpaces: true,
      tabSize: 2,
    },
  })
  const newText = JSONC.applyEdits(text, edits)
  writeFileSync(argvFile, newText, 'utf-8')
  console.log(`Updated argv.json file: ${argvFile}`)
}
