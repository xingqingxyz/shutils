import { readFile } from 'fs/promises'
import stripAnsi from 'strip-ansi'

const text = await readFile(process.stdin.fd, { encoding: 'utf8' })
console.log(stripAnsi(text))
