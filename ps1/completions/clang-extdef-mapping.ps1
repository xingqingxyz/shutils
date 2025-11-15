Register-ArgumentCompleter -Native -CommandName clang-extdef-mapping -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--help-list', '--version', '--extra-arg=', '--extra-arg-before=', '-p'
    }).Where{ $_ -like "$wordToComplete*" }
}
