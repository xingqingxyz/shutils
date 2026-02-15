Register-ArgumentCompleter -Native -CommandName debugpy-adapter -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help', '--port=', '--host=', '--access-token=', '--server-access-token=', '--log-dir=', '--log-stderr'
    }).Where{ $_ -like "$wordToComplete*" }
}
