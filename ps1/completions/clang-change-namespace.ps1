Register-ArgumentCompleter -Native -CommandName clang-change-namespace -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--allowed_file=', '--dump_result', '--extra-arg=', '--extra-arg-before=', '--file_pattern=', '-i', '--new_namespace=', '--old_namespace=', '-p', '--style=', '--style=LLVM', '--style=GNU', '--style=Google', '--style=Chromium', '--style=Mozilla', '--style=WebKit', '--style=file:', '--help', '--help-list', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
