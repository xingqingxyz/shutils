Register-ArgumentCompleter -Native -CommandName identify -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev.ToString()) {
      '-alpha' { 'on', 'activate', 'off', 'deactivate', 'set', 'opaque', 'copy', 'transparent', 'extract', 'background', 'shape' }
      '-endian' { 'MSB' , 'LSB' }
      '-features' { 'contrast', 'correlation' }
      Default { @('-alpha', '-antialias', '-authenticate', '-clip', '-clip-mask', '-clip-path', '-colorspace', '-crop', '-define', '-density', '-depth', '-endian', '-extract', '-features', '-format', '-fuzz', '-gamma', '-interlace', '-interpolate', '-limit', '-matte', '-moments', '-monitor', '-ping', '-precision', '-quiet', '-regard-warnings', '-respect-parentheses', '-sampling-factor', '-seed', '-set', '-size', '-strip', '-unique', '-units', '-verbose', '-virtual-pixel', '-auto-orient', '-channel', '-grayscale', '-negate', '-debug', '-help', '-list', '-log', '-version') }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
