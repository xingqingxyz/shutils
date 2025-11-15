Register-ArgumentCompleter -Native -CommandName ldd -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--version', '-d', '--data-relocs', '-r', '--function-relocs', '-u', '--unused', '-v', '--verbose'
    }).Where{ $_ -like "$wordToComplete*" }
}
