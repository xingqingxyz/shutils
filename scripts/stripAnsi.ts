import stripAnsi from 'strip-ansi'

import { readFileSync } from 'fs'

const text = readFileSync(process.stdin.fd, { encoding: 'utf8' })
console.log(stripAnsi(text))
