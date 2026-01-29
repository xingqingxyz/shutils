Register-ArgumentCompleter -Native -CommandName mspdbcmf -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('/')) {
      '/?', '/NOLOGO', '/OUT:', '/MACHINE:', '/VERBOSE'
    }).Where{ $_ -like "$wordToComplete*" }
}
