Register-ArgumentCompleter -Native -CommandName xargs -ScriptBlock {
  param ([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '-0', '--null', '-a', '--arg-file=', '-d', '--delimiter=', '-E', '-e', '--eof', '-I', '-i', '--replace', '--replace=', '-L', '--max-lines=', '-l', '-n', '--max-args=', '-o', '--open-tty', '-P', '--max-procs=', '-p', '--interactive', '--process-slot-var=', '-r', '--no-run-if-empty', '-s', '--max-chars=', '--show-limits', '-t', '--verbose', '-x', '--exit', '--help', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
