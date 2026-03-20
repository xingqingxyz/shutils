Register-ArgumentCompleter -Native -CommandName wireplumber -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help', '-v', '--version', '-c', '--config-file=', '-p', '--profile='
    }).Where{ $_ -like "$wordToComplete*" }
}
