Register-ArgumentCompleter -Native -CommandName clang-include-cleaner -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--help-list', '--version', '--disable-insert', '--disable-remove', '--edit', '--extra-arg=', '--extra-arg-before=', '--html=', '--ignore-headers=', '--insert', '--only-headers=', '-p', '--print', '--print=', '--print=changes', '--remove'
    }).Where{ $_ -like "$wordToComplete*" }
}
