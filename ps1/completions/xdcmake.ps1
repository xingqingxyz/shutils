Register-ArgumentCompleter -Native -CommandName xdcmake -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('/')) {
      '/old', '/?', '/nologo', '/assembly:', '/out:'
    }).Where{ $_ -like "$wordToComplete*" }
}
