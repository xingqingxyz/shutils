Register-ArgumentCompleter -Native -CommandName ssh -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev.ToString()

  @(switch ($prev) {
      Default {
        if ($wordToComplete.StartsWith('-')) {
          @()
        }
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
