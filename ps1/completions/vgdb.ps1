Register-ArgumentCompleter -Native -CommandName vgdb -ScriptBlock {
  param ([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '-c', '--pid=', '--vgdb-prefix=', '--wait=', '--max-invoke-ms=', '--port=', '--cmd-time-out=', '--multi', '--valgrind=', '--vargs', '-l', '-T', '-D', '-d', '-h', '--help'
    }
    else {
      'v.set', 'v.get', 'leak_check'
    }).Where{ $_ -like "$wordToComplete*" }
}
