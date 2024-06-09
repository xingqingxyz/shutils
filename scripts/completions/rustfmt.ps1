using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
@('--check', '--emit', '--backup', '--config-path', '--edition', '--color', '--print-config', '-l', '--files-with-diff', '--config', '-v', '--verbose', '-q', '--quiet', '-V', '--version', '-h', '--help') | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
