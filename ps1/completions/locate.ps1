Register-ArgumentCompleter -Native -CommandName locate, plocate -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-b', '--basename', '-c', '--count', '-d', '--database=', '-i', '--ignore-case', '-l', '--limit=1', '--limit=10', '--limit=20', '--limit=30', '-0', '--null', '-N', '--literal', '-r', '--regexp', '--regex', '-w', '--wholename', '--help', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
