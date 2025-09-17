Register-ArgumentCompleter -Native -CommandName brotli -ScriptBlock {
  param ([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '-0', '-9', '-c', '--stdout', '-d', '--decompress', '-f', '--force', '-h', '--help', '-j', '--rm', '-s', '--squash', '-k', '--keep', '-n', '--no-copy-stat', '-o', '--output=', '-q', '--quality=0', '--quality=11', '-t', '--test', '-v', '--verbose', '-w', '--lgwin=0', '--lgwin=10', '--lgwin=24', '--large_window=0', '--large_window=10', '--large_window=30', '-D', '--dictionary=', '-S', '--suffix=', '-V', '--version', '-Z', '--best'
    }).Where{ $_ -like "$wordToComplete*" }
}
