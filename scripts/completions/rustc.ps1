using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
@('-h', '--help', '--cfg', '--crate-type', '--crate-name', '--edition', '--emit', '--print', '--out-dir', '--explain', '--test', '--target', '-A', '--allow', '-W', '--warn', '--force-warn', '-D', '--deny', '-F', '--forbid', '--cap-lints', '-C', '--codegen', '-V', '--version', '-v', '--verbose', '--help') | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
