Register-ArgumentCompleter -Native -CommandName javac -ScriptBlock {
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
      '-Akey', '-Akey=', '--add-modules', '--add-modules=ALL-MODULE-PATH', '--boot-class-path', '-bootclasspath', '--class-path', '-classpath', '-cp', '-d', '-deprecation', '--enable-preview', '-encoding', '-endorseddirs', '-extdirs', '-g', '-g:lines', '-g:lines`,vars', '-g:lines`,source', '-g:vars', '-g:vars`,lines', '-g:vars`,source', '-g:source', '-g:source`,lines', '-g:source`,vars', '-g:none', '-h', '--help', '-help', '-?', '--help-extra', '-X', '-implicit:none', '-implicit:class', '-J', '--limit-modules', '--module', '-m', '--module-path', '-p', '--module-source-path', '--module-version', '-nowarn', '-parameters', '-proc:none', '-proc:only', '-proc:full', '-processor', '--processor-module-path', '--processor-path', '-processorpath', '-profile', '--release', '-s', '--source', '-source', '--source-path', '-sourcepath', '--system', '--system=none', '--target', '-target', '--upgrade-module-path', '-verbose', '--version', '-version', '-Werror'
    }
    else {
      switch -CaseSensitive -Regex ($prev) {
        '^(--add-modules|--limit-modules|--module|-m)$' { @(java --list-modules) -creplace '@.+$', ''; break }
        '^encoding$' { 'UTF-8', 'ASCII', 'GBK'; break }
      }
    }).Where{ $_ -like "$wordToComplete*" }
}
