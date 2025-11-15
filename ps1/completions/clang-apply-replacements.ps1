Register-ArgumentCompleter -Native -CommandName clang-apply-replacements -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--format','--style=',  '--style=LLVM', '--style=GNU', '--style=Google', '--style=Chromium', '--style=Mozilla', '--style=WebKit', '--style=file:', '--style-config=', '--help', '--help-list', '--version', '--ignore-insert-conflict', '--remove-change-desc-files'
    }).Where{ $_ -like "$wordToComplete*" }
}
