Register-ArgumentCompleter -Native -CommandName clang-include-fixer -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--help-list', '--version', '--db=fixed', '--db=yaml', '--db=fuzzyYaml', '--extra-arg=', '--extra-arg-before=', '--input=', '--insert-header=', '--minimize-paths', '--output-headers', '-p', '-q', '--query-symbol=', '--stdin', '--style=', '--style=LLVM', '--style=GNU', '--style=Google', '--style=Chromium', '--style=Mozilla', '--style=WebKit', '--style=file:'
    }).Where{ $_ -like "$wordToComplete*" }
}
