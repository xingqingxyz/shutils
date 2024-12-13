Register-ArgumentCompleter -Native -CommandName ssh -ScriptBlock {
  param([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($key in $commandAst.CommandElements) {
    if ($key.Extent.StartOffset -eq $cursorPosition) {
      break
    }
    $prev = $key
  }
  @(switch ($prev.ToString()) {
      Default { 
        if ($wordToComplete.StartsWith('-')) {
          @()
        }
      }
    }) | Where-Object { $_ -like "$wordToComplete*" }
}
