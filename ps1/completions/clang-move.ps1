Register-ArgumentCompleter -Native -CommandName clang-move -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--help-list', '--version', '--dump_decls', '--extra-arg=', '--extra-arg-before=', '--names=', '--new_cc=', '--new_depend_on_old', '--new_header=', '--old_cc=', '--old_depend_on_new', '--old_header=', '-p', '--style=', '--style=LLVM', '--style=GNU', '--style=Google', '--style=Chromium', '--style=Mozilla', '--style=WebKit', '--style=file:'
    }).Where{ $_ -like "$wordToComplete*" }
}
