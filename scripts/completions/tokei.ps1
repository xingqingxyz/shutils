using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
@('-C', '--compact', '-f', '--files', '-h', '--help', '--hidden', '-l', '--languages', '--no-ignore', '--no-ignore-dot', '--no-ignore-dot', '--no-ignore-parent', '--no-ignore-vcs', '-V', '--version', '-v', '--verbose', '-c', '--columns', '-e', '--exclude', '-i', '--input', '-n', '--num-format', '-o', '--output', '-s', '--sort', '-t', '--type') | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
