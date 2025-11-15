Register-ArgumentCompleter -Native -CommandName clang-reorder-fields -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--help-list', '--version', '--extra-arg=', '--extra-arg-before=', '--fields-order=', '-i', '-p', '--record-name='
    }).Where{ $_ -like "$wordToComplete*" }
}
