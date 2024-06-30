Register-ArgumentCompleter -Native -CommandName rustfmt -ScriptBlock {
  param([string]$wordToComplete)
  @('--check', '--emit', '--backup', '--config-path', '--edition', '--color', '--print-config', '-l', '--files-with-diff', '--config', '-v', '--verbose', '-q', '--quiet', '-V', '--version', '-h', '--help') | Where-Object { $_ -like "$wordToComplete*" }
}
