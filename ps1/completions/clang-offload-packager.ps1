Register-ArgumentCompleter -Native -CommandName clang-offload-packager -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--help-list', '--version', '--archive', '--image=file=', '--image=triple=', '-o'
    }).Where{ $_ -like "$wordToComplete*" }
}
