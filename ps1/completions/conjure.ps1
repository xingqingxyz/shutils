Register-ArgumentCompleter -Native -CommandName conjure -ScriptBlock {
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
      '-debug' { @(''); break }
      default {
        if ($wordToComplete.StartsWith('-')) {
          @('-monitor', '-quiet', '-regard-warnings', '-seed', '-verbose', '-debug', '-help', '-list', '-log', '-version')
        }
        break
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
