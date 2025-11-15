Register-ArgumentCompleter -Native -CommandName clang-check -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--help-list', '--version', '--analyze', '--analyzer-output-path=', '--ast-dump', '--ast-dump-filter=', '--ast-print', '--extra-arg=', '--extra-arg-before=', '--fix-what-you-can', '--fixit', '-p', '--syntax-tree-dump', '--tokens-dump'
    }).Where{ $_ -like "$wordToComplete*" }
}
