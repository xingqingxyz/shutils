Register-ArgumentCompleter -Native -CommandName gcov-dump -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help', '-l', '--long', '-p', '--positions', '-r', '--raw', '-s', '--stable', '-v', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
