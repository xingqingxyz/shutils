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
    '-thinlinemode' { 'none', 'solid', 'shape' }
    { $_.StartsWith('-aa') -or $_ -eq '-freetype' } { 'yes', 'no' }
    Default { @('-f', '-l', '-o', '-e', '-singlefile', '-scale-dimension-before-rotation', '-r', '-rx', '-ry', '-scale-to', '-scale-to-x', '-scale-to-y', '-x', '-y', '-W', '-H', '-sz', '-cropbox', '-hide-annotations', '-mono', '-gray', '-sep', '-forcenum', '-png', '-jpeg', '-jpegcmyk', '-jpegopt', '-overprint', '-freetype', '-thinlinemode', '-aa', '-aaVector', '-opw', '-upw', '-q', '-progress', '-v', '-h', '-help', '--help') }
  }) | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
