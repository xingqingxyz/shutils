Register-ArgumentCompleter -Native -CommandName llvm-symbolizer -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--addresses', '--adjust-vma=', '-a', '--basenames', '--build-id=', '--cache-size=', '--color=', '--color', '-C', '--debug-file-directory=', '--debuginfod', '-demangle=false', '-demangle=true', '--demangle', '--dia', '--dwp=', '-e=', '--exe=', '--exe', '-e', '-f=', '--fallback-debug-path=', '--filter-markup', '--functions=', '--functions', '-f', '--help', '--inlines', '--inlining=false', '--inlining=true', '--inlining', '-i', '--no-debuginfod', '--no-demangle', '--no-inlines', '--no-untag-addresses', '--obj=', '--output-style=LLVM', '--output-style=GNU', '--output-style=JSON', '--pretty-print', '--print-address', '--print-source-context-lines=', '-p', '--relative-address', '--relativenames', '--skip-line-zero', '-s', '--verbose', '--version', '-v', '--disable-gsym', '--gsym-file-directory=', '--default-arch=', '--dsym-hint='
    }).Where{ $_ -like "$wordToComplete*" }
}
