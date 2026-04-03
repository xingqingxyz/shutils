Register-ArgumentCompleter -Native -CommandName which -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--version', '-v', '-V', '--help', '--skip-dot', '--skip-tilde', '--show-dot', '--show-tilde', '--tty-only', '--all', '-a', '--read-alias', '-i', '--skip-alias', '--read-functions', '--skip-functions'
    }
    else {
      (Get-Command $wordToComplete* -Type Application).Name | Sort-Object -Unique
    }).Where{ $_ -like "$wordToComplete*" }
}
