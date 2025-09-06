Register-ArgumentCompleter -Native -CommandName stream -ScriptBlock {
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
      Default {
        if ($wordToComplete.StartsWith('-')) {
          @('-authenticate', '-colorspace', '-compress', '-define', '-density', '-depth', '-extract', '-identify', '-interlace', '-interpolate', '-limit', '-map', '-monitor', '-quantize', '-quiet', '-regard-warnings', '-respect-parentheses', '-sampling-factor', '-seed', '-set', '-size', '-storage-type', '-synchronize', '-taint', '-transparent-color', '-verbose', '-virtual-pixel', '-channel', '-debug', '-help', '-list', '-log', '-version')
        }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
