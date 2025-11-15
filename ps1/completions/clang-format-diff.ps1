Register-ArgumentCompleter -Native -CommandName clang-format-diff -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help', '-i', '-p', '-regex', '-iregex', '-sort-includes', '-v', '--verbose', '-style=', '--style=LLVM', '--style=GNU', '--style=Google', '--style=Chromium', '--style=Mozilla', '--style=WebKit', '--style=file:', '-fallback-style=', '--fallback-style=LLVM', '--fallback-style=GNU', '--fallback-style=Google', '--fallback-style=Chromium', '--fallback-style=Mozilla', '--fallback-style=WebKit', '--fallback-style=file:', '-binary'
    }).Where{ $_ -like "$wordToComplete*" }
}
