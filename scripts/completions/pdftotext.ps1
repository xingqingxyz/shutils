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
    '-enc' { pdftotext -listenc }
    '-eol' { @('unix', 'dos', 'mac') }
    Default { @('-f', '-l', '-r', '-x', '-y', '-W', '-H', '-layout', '-fixed', '-raw', '-nodiag', '-htmlmeta', '-tsv', '-enc', '-listenc', '-eol', '-nopgbrk', '-bbox', '-bbox-layout', '-cropbox', '-colspacing', '-opw', '-upw', '-q', '-v', '-h', '-help', '--help') }
  }) | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
