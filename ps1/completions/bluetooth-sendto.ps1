Register-ArgumentCompleter -Native -CommandName bluetooth-sendto -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help', '--device=', '--name='
    }).Where{ $_ -like "$wordToComplete*" }
}
