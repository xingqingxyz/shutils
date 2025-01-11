import { readFileSync } from 'fs'
import stripAnsi from 'strip-ansi'

const text = await readFileSync(process.stdin.fd, { encoding: 'utf8' })
console.log(stripAnsi(text))
