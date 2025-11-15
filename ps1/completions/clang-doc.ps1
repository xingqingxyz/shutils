Register-ArgumentCompleter -Native -CommandName clang-doc -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--help-list', '--version', '--asset=', '--base=', '--doxygen', '--extra-arg=', '--extra-arg-before=', '--format=yaml', '--format=md', '--format=html', '--format=mustache', '--format=json', '--ftime-trace', '--ignore-map-errors', '--output=', '-p', '--project-name=', '--public', '--repository=', '--repository-line-prefix=', '--source-root=', '--stylesheets='
    }).Where{ $_ -like "$wordToComplete*" }
}
