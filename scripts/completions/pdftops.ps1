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
    '-aaRaster' { 'yes', 'no' }
    '-rasterize' { 'always', 'never', 'whenneeded' }
    '-paper' { 'letter', 'legal', 'A4', 'A3', 'match' }
    '-processcolorformat' { 'MONO8', 'RGB8', 'CMYK8' }
    Default { @('-f', '-l', '-level1', '-level1sep', '-level2', '-level2sep', '-level3', '-level3sep', '-origpagesizes', '-eps', '-form', '-opi', '-r', '-binary', '-noembt1', '-noembtt', '-noembcidps', '-noembcidtt', '-passfonts', '-aaRaster', '-rasterize', '-processcolorformat', '-optimizecolorspace', '-passlevel1customcolor', '-preload', '-paper', '-paperw', '-paperh', '-nocrop', '-expand', '-noshrink', '-nocenter', '-duplex', '-opw', '-upw', '-overprint', '-q', '-v', '-h', '-help', '--help') }
  }) | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
