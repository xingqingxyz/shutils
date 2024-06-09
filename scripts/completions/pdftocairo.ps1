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
    '-paper' { 'letter', 'legal', 'A4', 'A3', 'match' }
    Default { @('-png', '-jpeg', '-jpegopt', '-ps', '-eps', '-pdf', '-svg', '-print', '-printdlg', '-printer', '-printopt', '-setupdlg', '-f', '-l', '-o', '-e', '-singlefile', '-r', '-rx', '-ry', '-scale-to', '-scale-to-x', '-scale-to-y', '-x', '-y', '-W', '-H', '-sz', '-cropbox', '-mono', '-gray', '-transp', '-antialias', '-level2', '-level3', '-origpagesizes', '-paper', '-paperw', '-paperh', '-nocrop', '-expand', '-noshrink', '-nocenter', '-duplex', '-struct', '-opw', '-upw', '-q', '-v', '-h', '-help', '--help') }
  }) | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
