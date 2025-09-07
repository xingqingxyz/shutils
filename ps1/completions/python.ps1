Register-ArgumentCompleter -Native -CommandName python, py -ScriptBlock {
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
      '-m' {
        pip list | Select-Object -Skip 2 | ForEach-Object { $_.Split(' ',2)[0] }
        break
      }
      Default {
        if ($wordToComplete.StartsWith('-')) {
          if (!$commandAst.GetCommandName().StartsWith('python')) {
            @('-0', '-2', '-3', '-V:', '--list', '-0p', '--list-paths')
          }
          @('--check-hash-based-pycs', '--help-env', '--help-xoptions', '--help-all', '-X', '-b', '-B', '-c', '-d', '-E', '-h', '-i', '-I', '-m', '-O', '-OO', '-P', '-q', '-s', '-S', '-u', '-v', '-V', '-W', '-x', '-X', '--check-hash-based-pycs', '--help-env', '--help-xoptions', '--help-all')
        }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
