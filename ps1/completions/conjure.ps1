Register-ArgumentCompleter -Native -CommandName conjure -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev.ToString()

  @(switch ($prev) {
      '-debug' { '' }
      Default { @('-monitor', '-quiet', '-regard-warnings', '-seed', '-verbose', '-debug', '-help', '-list', '-log', '-version') }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
