Register-ArgumentCompleter -Native -CommandName conjure -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev.ToString()) {
      '-debug' { '' }
      Default { @('-monitor', '-quiet', '-regard-warnings', '-seed', '-verbose', '-debug', '-help', '-list', '-log', '-version') }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
