Register-ArgumentCompleter -Native -CommandName jd -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-color', '-color-words', '-f=jd', '-f=patch', '-f=merge', '-git-diff-driver', '-mset', '-o=', '-opts=', '-p', '-port=', '-precision=', '-set', '-setkeys=', '-t=', '-v2', '-version', '-yaml'
    }).Where{ $_ -like "$wordToComplete*" }
}
