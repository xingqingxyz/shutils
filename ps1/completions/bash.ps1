Register-ArgumentCompleter -Native -CommandName bash -ScriptBlock {
  param ([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '--debug', '--debugger', '--dump-po-strings', '--dump-strings', '--help', '--init-file', '--login', '--noediting', '--noprofile', '--norc', '--posix', '--pretty-print', '--rcfile', '--restricted', '--verbose', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
