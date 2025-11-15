Register-ArgumentCompleter -Native -CommandName gjs -ScriptBlock {
  param ([string]$wordToComplete)
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help', '--version', '--jsversion', '-c', '--command=', '-C', '--coverage-prefix=', '--coverage-output=', '-I', '--include-path=', '-m', '--module', '--profile=', '-d', '--debugger'
    }).Where{ $_ -like "$wordToComplete*" }
}
