using namespace System.Management.Automation
using namespace System.Management.Automation.Language


param([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
$cursorPosition -= $wordToComplete.Length
foreach ($i in $commandAst.CommandElements) {
  if ($i.Extent.StartOffset -eq $cursorPosition) {
    break
  }
  $prev = $i
}
@(switch ($prev.Extent.Text) {
    '-debug' { '' }
    Default { @('-monitor', '-quiet', '-regard-warnings', '-seed', '-verbose', '-debug', '-help', '-list', '-log', '-version') }
  }) | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
