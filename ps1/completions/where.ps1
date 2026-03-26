Register-ArgumentCompleter -Native -CommandName 'where' -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  if ($wordToComplete.StartsWith('/')) {
    return @('/R', '/Q', '/F', '/T', '/?').Where{ $_ -like "$wordToComplete*" }
  }
  [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
}
