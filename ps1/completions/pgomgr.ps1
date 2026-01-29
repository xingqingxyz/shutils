Register-ArgumentCompleter -Native -CommandName pgomgr -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('/')) {
      '/?', '/help', '/clear', '/detail', '/merge', '/merge:2', '/summary', '/unique', '/name:'
    }).Where{ $_ -like "$wordToComplete*" }
}
