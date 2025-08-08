Register-ArgumentCompleter -Native -CommandName sed -ScriptBlock {
  param([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '-n', '--quiet', '--silent', '--debug', '-e', '--expression=', '-f', '--file=', '--follow-symlinks', '-i', '--in-place=', '-c', '--copy', '-b', '--binary', '-l', '--line-length=', '--posix', '-E', '-r', '--regexp-extended', '-s', '--separate', '--sandbox', '-u', '--unbuffered', '-z', '--null-data', '--help', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
