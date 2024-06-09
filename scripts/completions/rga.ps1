using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
@('--rga-accurate', '--rga-no-cache', '-h', '--help', '--rga-list-adapters', '--rga-no-prefix-filenames', '--rga-print-config-schema', '--rg-help', '--rg-version', '-V', '--version', '--rga-adapters', '--rga-cache-compression-level', '--rga-config-file', '--rga-max-archive-recursion', '--rga-cache-max-blob-len', '--rga-cache-path') | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
