Register-ArgumentCompleter -Native -CommandName clangd -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--help-list', '--version', '--compile-commands-dir=', '--query-driver=', '--all-scopes-completion', '--background-index', '--background-index-priority=background', '--background-index-priority=low', '--background-index-priority=normal', '--clang-tidy', '--completion-style=detailed', '--completion-style=bundled', '--experimental-modules-support', '--fallback-style=', '--function-arg-placeholders=', '--header-insertion=iwyu', '--header-insertion=never', '--header-insertion-decorators', '--import-insertions', '--limit-references=', '--limit-results=', '--rename-file-limit=', '--check', '--check=', '--enable-config', '-j', '--malloc-trim', '--pch-storage=disk', '--pch-storage=memory', '--log=error', '--log=info', '--log=verbose', '--offset-encoding=utf-8', '--offset-encoding=utf-16', '--offset-encoding=utf-32', '--path-mappings=', '--pretty'
    }).Where{ $_ -like "$wordToComplete*" }
}
