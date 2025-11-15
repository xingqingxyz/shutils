Register-ArgumentCompleter -Native -CommandName clang-format -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--Werror', '--Wno-error=', '--Wno-error=unknown', '--assume-filename=', '--cursor=', '--dry-run', '--dump-config', '--fail-on-incomplete-format', '--fallback-style=', '--ferror-limit=', '--files=', '-i', '--length=', '--lines=', '-n', '--offset=', '--output-replacements-xml', '--qualifier-alignment=', '--sort-includes', '--style=', '--style=LLVM', '--style=GNU', '--style=Google', '--style=Chromium', '--style=Mozilla', '--style=WebKit', '--style=file:', '--verbose', '--help', '--help-list', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
