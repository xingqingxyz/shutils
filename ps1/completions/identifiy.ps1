Register-ArgumentCompleter -Native -CommandName identify -ScriptBlock {
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
      '-alpha' { 'on', 'activate', 'off', 'deactivate', 'set', 'opaque', 'copy', 'transparent', 'extract', 'background', 'shape' }
      '-endian' { 'MSB' , 'LSB' }
      '-features' { 'contrast', 'correlation' }
      default { @('-alpha', '-antialias', '-authenticate', '-clip', '-clip-mask', '-clip-path', '-colorspace', '-crop', '-define', '-density', '-depth', '-endian', '-extract', '-features', '-format', '-fuzz', '-gamma', '-interlace', '-interpolate', '-limit', '-matte', '-moments', '-monitor', '-ping', '-precision', '-quiet', '-regard-warnings', '-respect-parentheses', '-sampling-factor', '-seed', '-set', '-size', '-strip', '-unique', '-units', '-verbose', '-virtual-pixel', '-auto-orient', '-channel', '-grayscale', '-negate', '-debug', '-help', '-list', '-log', '-version') }
    }).Where{ $_ -like "$wordToComplete*" }
}
