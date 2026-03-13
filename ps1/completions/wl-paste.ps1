Register-ArgumentCompleter -Native -CommandName wl-paste -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-n', '--no-newline', '-l', '--list-types', '-p', '--primary', '-w', '--watch=', '-t', '--type=', '-s', '--seat=', '-v', '--version', '-h', '--help'
    }).Where{ $_ -like "$wordToComplete*" }
}
