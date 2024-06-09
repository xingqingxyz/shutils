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
    Default { @('-authenticate', '-colorspace', '-compress', '-define', '-density', '-depth', '-extract', '-identify', '-interlace', '-interpolate', '-limit', '-map', '-monitor', '-quantize', '-quiet', '-regard-warnings', '-respect-parentheses', '-sampling-factor', '-seed', '-set', '-size', '-storage-type', '-synchronize', '-taint', '-transparent-color', '-verbose', '-virtual-pixel', '-channel', '-debug', '-help', '-list', '-log', '-version') }
  }) | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
