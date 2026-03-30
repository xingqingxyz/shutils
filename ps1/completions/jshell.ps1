Register-ArgumentCompleter -Native -CommandName jshell -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  $cursorPosition -= $wordToComplete.Length
  foreach ($i in $commandAst.CommandElements) {
    if ($i.Extent.StartOffset -ge $cursorPosition) {
      break
    }
    $prev = $i
  }
  $prev = $prev -is [System.Management.Automation.Language.StringConstantExpressionAst] ? $prev.Value : $prev.ToString()
  @(if ($wordToComplete.StartsWith('-')) {
      '--class-path', '--module-path', '--add-modules', '--enable-native-access', '--enable-preview', '--startup', '--no-startup', '--feedback=silent', '--feedback=concise', '--feedback=normal', '--feedback=verbose', '-q', '-s', '-v', '-J', '-R', '-C', '--version', '--show-version', '--help', '-?', '-h', '--help-extra', '-X', '--add-exports', '--execution', '--execution=local'
    }
    else {
      switch -CaseSensitive -Regex ($prev) {
        '^(--add-modules|--add-exports)$' { @(java --list-modules) -creplace '@.+$', ''; break }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
