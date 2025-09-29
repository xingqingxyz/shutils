Register-ArgumentCompleter -Native -CommandName composite -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()

  @(switch ($prev) {
      '-alpha' { @('on', 'activate', 'off', 'deactivate', 'set', 'opaque', 'copy', 'transparent', 'extract', 'background', 'shape'); break }
      default {
        if ($wordToComplete.StartsWith('-')) {
          @('-alpha', '-authenticate', '-background', '-colorspace', '-compose', '-compress', '-decipher', '-define', '-density', '-depth', '-dissimilarity-threshold', '-encipher', '-extract', '-format', '-fuzz', '-gravity', '-highlight-color', '-identify', '-interlace', '-limit', '-lowlight-color', '-metric', '-monitor', '-negate', '-passphrase', '-precision', '-profile', '-quality', '-quiet', '-quantize', '-read-mask', '-regard-warnings', '-respect-parentheses', '-sampling-factor', '-seed', '-set', '-quality', '-repage', '-similarity-threshold', '-size', '-subimage-search', '-synchronize', '-taint', '-transparent-color', '-type', '-verbose', '-version', '-virtual-pixel', '-write-mask', '-auto-orient', '-brightness-contrast', '-distort', '-level', '-resize', '-rotate', '-sigmoidal-contrast', '-trim', '-write', '-separate', '-crop', '-delete', '-channel', '-debug', '-help', '-list', '-log')
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
