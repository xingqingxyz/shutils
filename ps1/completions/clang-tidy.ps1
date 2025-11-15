Register-ArgumentCompleter -Native -CommandName clang-tidy -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--help', '--help-list', '--version', '--allow-no-checks', '--checks=', '--config=', '--config-file=', '--dump-config', '--enable-check-profile', '--enable-module-headers-parsing', '--exclude-header-filter=', '--explain-config', '--export-fixes=', '--extra-arg=', '--extra-arg-before=', '--fix', '--fix-errors', '--fix-notes', '--format-style=', '--format-style=none', '--format-style=file', '--format-style=llvm', '--format-style=google', '--format-style=webkit', '--format-style=mozilla', '--header-filter=', '--line-filter=', '--list-checks', '--load=', '-p', '--quiet', '--store-check-profile=', '--system-headers', '--use-color', '--verify-config', '--vfsoverlay=', '--warnings-as-errors='
    }).Where{ $_ -like "$wordToComplete*" }
}
