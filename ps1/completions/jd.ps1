Register-ArgumentCompleter -Native -CommandName jd -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-color', '-color-words', '-f=jd', '-f=patch', '-f=merge', '-git-diff-driver', '-mset', '-o=', '-opts=', '-p', '-port=', '-precision=0.01', '-precision=0.01', '-set', '-setkeys=', '-t=jd2patch', '-t=jd2merge', '-t=jd2json', '-t=jd2yaml', '-t=patch2jd', '-t=patch2merge', '-t=patch2json', '-t=patch2yaml', '-t=merge2jd', '-t=merge2patch', '-t=merge2yaml', '-t=merge2json', '-t=json2jd', '-t=json2patch', '-t=json2merge', '-t=json2yaml', '-t=yaml2jd', '-t=yaml2patch', '-t=yaml2merge', '-t=yaml2json', '-v2', '-version', '-yaml'
    }).Where{ $_ -like "$wordToComplete*" }
}
