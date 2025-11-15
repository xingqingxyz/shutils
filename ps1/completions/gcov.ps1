Register-ArgumentCompleter -Native -CommandName gcov -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-a', '--all-blocks', '-b', '--branch-probabilities', '-c', '--branch-counts', '-g', '--conditions', '-e', '--prime-paths', '--prime-paths-lines', '--prime-paths-lines=covered', '--prime-paths-lines=uncovered', '--prime-paths-lines=both', '--prime-paths-source', '--prime-paths-source=covered', '--prime-paths-source=uncovered', '--prime-paths-source=both', '-d', '--display-progress', '-D', '--debug', '-f', '--function-summaries', '--include', '--exclude', '-h', '--help', '-j', '--json-format', '-H', '--human-readable', '-k', '--use-colors', '-l', '--long-file-names', '-m', '--demangled-names', '-M', '--filter-on-demangled', '-n', '--no-output', '-o', '--object-directory', '-p', '--preserve-paths', '-q', '--use-hotness-colors', '-r', '--relative-only', '-s', '--source-prefix', '-t', '--stdout', '-u', '--unconditional-branches', '-v', '--version', '-w', '--verbose', '-x', '--hash-filenames'
    }).Where{ $_ -like "$wordToComplete*" }
}
