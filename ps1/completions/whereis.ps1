Register-ArgumentCompleter -Native -CommandName whereis -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-b', '-B', '-m', '-M', '-s', '-S', '-f', '-u', '-g', '-l', '-h', '--help', '-V', '--version'
    }
    else {
      (Get-Command $wordToComplete* -Type Application).Name | Sort-Object -Unique
    }).Where{ $_ -like "$wordToComplete*" }
}
