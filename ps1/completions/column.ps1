Register-ArgumentCompleter -Native -CommandName column -ScriptBlock {
  param ([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '-t', '--table', '-n', '--table-name=', '-O', '--table-order=', '-C', '--table-column=', '-N', '--table-columns=', '-l', '--table-columns-limit=', '-E', '--table-noextreme=', '-d', '--table-noheadings', '-m', '--table-maxout', '-e', '--table-header-repeat', '-H', '--table-hide=', '-R', '--table-right=', '-T', '--table-truncate=', '-W', '--table-wrap=', '-L', '--keep-empty-lines', '-J', '--json', '-r', '--tree=', '-i', '--tree-id=', '-p', '--tree-parent=', '-c', '--output-width=', '-o', '--output-separator=', '-s', '--separator=', '-x', '--fillrows', '-S', '--use-spaces=', '-h', '--help', '-V', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
