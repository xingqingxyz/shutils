Register-ArgumentCompleter -Native -CommandName etc1tool -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--encode', '--encodeNoHeader', '--decode', '--showDifference'
    }).Where{ $_ -like "$wordToComplete*" }
}
