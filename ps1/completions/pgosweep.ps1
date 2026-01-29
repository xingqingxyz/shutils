Register-ArgumentCompleter -Native -CommandName pgosweep -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('/')) {
      '/?', '/help', '/reset', '/pid:n', '/wait', '/onlyzero', '/pause', '/resume', '/noreset'
    }).Where{ $_ -like "$wordToComplete*" }
}
