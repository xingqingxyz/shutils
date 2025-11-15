Register-ArgumentCompleter -Native -CommandName valgrind-di-server, valgrind-listener -ScriptBlock {
  param ([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '-e', '--exit-at-zero', '--max-connect='
    }).Where{ $_ -like "$wordToComplete*" }
}
