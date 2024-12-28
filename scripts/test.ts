import { execSync } from 'child_process'

const items = Array.from($0.children)
const options = []
let args = []
for (const i of items) {
  if (i.tagName === 'DT') {
    args.push(i.textContent.split(' ')[0])
  } else if (i.tagName === 'DD') {
    const a = {
      args: args,
      value: i.textContent.split('.')[0].trim().replaceAll('\n', ' '),
    }
    for (const arg of a.args) {
      options.push(
        `[CompletionResult]::new('${arg}', '${arg}', [CompletionResultType]::ParameterName, '${
          a.value ?? 'unknown'
        }')`
      )
    }
    args = []
  }
}
options.join('\n')

execSync('clip', {
  input: options.join('\n'),
  stdio: 'pipe',
})
