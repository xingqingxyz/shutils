Register-ArgumentCompleter -Native -CommandName clang-query -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--help-list', '--version', '-c', '--extra-arg=', '--extra-arg-before=', '-f', '-p', '--preload=', '--use-color'
    }).Where{ $_ -like "$wordToComplete*" }
}
