Register-ArgumentCompleter -Native -CommandName awk, gawk -ScriptBlock {
  param ([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '-f', '--file=', '-F', '--field-separator=', '-v', '--assign=', '-b', '--characters-as-bytes', '-c', '--traditional', '-C', '--copyright', '-d', '--dump-variables', '--dump-variables=', '-D', '--debug', '--debug=', '-e', '--source=', '-E', '--exec=', '-g', '--gen-pot', '-h', '--help', '-i', '--include=', '-I', '--trace', '-k', '--csv', '-l', '--load=', '-Lfatal', '--lint=fatal', '-Linvalid', '--lint=invalid', '-Lno-ext', '--lint=no-ext', '-M', '--bignum', '-N', '--use-lc-numeric', '-n', '--non-decimal-data', '-o', '--pretty-print', '--pretty-print=', '-O', '--optimize', '-p', '--profile', '--profile=', '-P', '--posix', '-r', '--re-interval', '-s', '--no-optimize', '-S', '--sandbox', '-t', '--lint-old', '-V', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
