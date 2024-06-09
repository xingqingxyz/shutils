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
    '-alpha' { 'on', 'activate', 'off', 'deactivate', 'set', 'opaque', 'copy', 'transparent', 'extract', 'background', 'shape' }
    Default { @('-alpha', '-authenticate', '-background', '-colorspace', '-compose', '-compress', '-decipher', '-define', '-density', '-depth', '-dissimilarity-threshold', '-encipher', '-extract', '-format', '-fuzz', '-gravity', '-highlight-color', '-identify', '-interlace', '-limit', '-lowlight-color', '-metric', '-monitor', '-negate', '-passphrase', '-precision', '-profile', '-quality', '-quiet', '-quantize', '-read-mask', '-regard-warnings', '-respect-parentheses', '-sampling-factor', '-seed', '-set', '-quality', '-repage', '-similarity-threshold', '-size', '-subimage-search', '-synchronize', '-taint', '-transparent-color', '-type', '-verbose', '-version', '-virtual-pixel', '-write-mask', '-auto-orient', '-brightness-contrast', '-distort', '-level', '-resize', '-rotate', '-sigmoidal-contrast', '-trim', '-write', '-separate', '-crop', '-delete', '-channel', '-debug', '-help', '-list', '-log') }
  }) | Where-Object { $_.StartsWith($wordToComplete) } | ForEach-Object {
  [CompletionResult]::new($_)
}
