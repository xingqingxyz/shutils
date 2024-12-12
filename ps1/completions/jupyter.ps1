Register-ArgumentCompleter -Native -CommandName jupyter -ScriptBlock {
  param([string]$wordToComplete)
  if ($wordToComplete.StartsWith('-')) {
    @('-h', '--help', '--version', '--config-dir', '--data-dir', '--runtime-dir', '--paths', '--json', '--debug')
  }
}
