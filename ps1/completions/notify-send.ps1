Register-ArgumentCompleter -Native -CommandName notify-send -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '-u', '--urgency=low', '--urgency=normal', '--urgency=critical', '-t', '--expire-time=', '-a', '--app-name=', '-i', '--icon=', '-n', '--app-icon=', '-c', '--category=', '-e', '--transient', '-h', '--hint=boolean', '--hint=int', '--hint=double', '--hint=string', '--hint=byte', '--hint=variant', '-p', '--print-id', '--id-fd', '-r', '--replace-id=', '-w', '--wait', '-A', '--action=Yes', '--action=No', '--action=OK', '--action=Cancel', '--selected-action-fd', '--activation-token-fd', '-v', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
