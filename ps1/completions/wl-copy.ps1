Register-ArgumentCompleter -Native -CommandName wl-copy -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-o', '--paste-once', '-f', '--foreground', '-c', '--clear', '-p', '--primary', '-n', '--trim-newline', '-t', '--type=', '-s', '--seat=', '-v', '--version', '-h', '--help'
    }).Where{ $_ -like "$wordToComplete*" }
}
