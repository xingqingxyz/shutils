Register-ArgumentCompleter -Native -CommandName stream -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev.ToString()) {
      Default { @('-authenticate', '-colorspace', '-compress', '-define', '-density', '-depth', '-extract', '-identify', '-interlace', '-interpolate', '-limit', '-map', '-monitor', '-quantize', '-quiet', '-regard-warnings', '-respect-parentheses', '-sampling-factor', '-seed', '-set', '-size', '-storage-type', '-synchronize', '-taint', '-transparent-color', '-verbose', '-virtual-pixel', '-channel', '-debug', '-help', '-list', '-log', '-version') }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
