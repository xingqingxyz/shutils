Register-ArgumentCompleter -Native -CommandName debugpy -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--listen=', '--connect=', '--wait-for-client', '--configure-', '--log-to=', '--log-to-stderr', '--parent-session-pid=', '--adapter-access-token=', '--disable-sys-remote-exec', '-m', '-c', '--pid='
    }).Where{ $_ -like "$wordToComplete*" }
}
