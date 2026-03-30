Register-ArgumentCompleter -Native -CommandName java, javaw -ScriptBlock {
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
      '-cp', '-classpath', '--class-path', '-p', '--module-path', '--upgrade-module-path', '--add-modules', '--add-modules=ALL-DEFAULT', '--add-modules=ALL-SYSTEM', '--add-modules=ALL-MODULE-PATH', '--enable-native-access', '--illegal-native-access=warn', '--illegal-native-access=deny', '--illegal-native-access=allow', '--list-modules', '-d', '--describe-module', '--dry-run', '--validate-modules', '-D', '-verbose:class', '-verbose:module', '-verbose:gc', '-verbose:jni', '-version', '--version', '-showversion', '--show-version', '--show-module-resolution', '-?', '-h', '-help', '--help', '-X', '--help-extra', '-ea', '-ea:', '-enableassertions', '-enableassertions:', '-da', '-da:', '-disableassertions', '-disableassertions:', '-esa', '-enablesystemassertions', '-dsa', '-disablesystemassertions', '-agentlib:', '-agentpath:', '-javaagent:', '-splash:', '--disable-@files', '--enable-preview'
    }
    else {
      switch -CaseSensitive -Regex ($prev) {
        '^(--add-modules|--enable-native-access|-d|--describe-module)$' { @(java --list-modules) -creplace '@.+$', ''; break }
        default { '`@argument'; break }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
