using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
@('-f', '--file', '-d', '--digits', '-D', '--non-digits', '-s', '--spaces', '-S', '--non-spaces', '-w', '--words', '-W', '--non-words', '-e', '--escape', '--with-surrogates', '-r', '--repetitions', '--min-repetitions', '--min-substring-length', '--no-start-anchor', '--no-end-anchor', '--no-anchors', '-x', '--verbose', '-c', '--colorize', '-i', '--ignore-case', '-g', '--capture-groups', '-h', '--help', '-v', '--version') | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
