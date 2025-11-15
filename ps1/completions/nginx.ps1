Register-ArgumentCompleter -Native -CommandName nginx -ScriptBlock {
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
      '-s' { 'stop', 'quit', 'reopen', 'reload'; break }
      default {
        if ($wordToComplete.StartsWith('-')) {
          '-?', '-h', '-v', '-V', '-t', '-T', '-q', '-s', '-p', '-e', '-c', '-g'
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
