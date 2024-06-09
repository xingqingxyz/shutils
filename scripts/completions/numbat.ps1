using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
@('-e', '--expression', '-i', '--inspect-interactively', '--no-config', '--no-prelude', '--no-init', '--pretty-print', '--intro-banner', '--generate-config', '-h', '--help', '-V', '--version') | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
