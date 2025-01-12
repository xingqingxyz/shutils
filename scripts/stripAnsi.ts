import { readFileSync } from 'fs'
import stripAnsi from 'strip-ansi'

const text = readFileSync(process.stdin.fd, { encoding: 'utf8' })
console.log(stripAnsi(text))
