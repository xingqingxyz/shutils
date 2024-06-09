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
    '-enc' { 'ASCII7', 'Latin1', 'Symbol', 'UTF-16', 'UTF-8' }
    '-fmt' { 'png', 'jpg' }
    Default { @('-f', '-l', '-q', '-h', '-help', '--help', '-p', '-c', '-s', '-i', '-noframes', '-stdout', '-zoom', '-xml', '-noroundcoord', '-hidden', '-nomerge', '-enc', '-fmt', '-v', '-opw', '-upw', '-nodrm', '-wbt', '-fontfullname') }
  }) | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
