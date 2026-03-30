using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName apt-file -ScriptBlock {
  param ([string]$wordToComplete, [CommandAst]$commandAst, [int]$cursorPosition)
  $command = @(foreach ($i in $commandAst.CommandElements) {
      if ($i.Extent.StartOffset -eq $commandAst.Extent.StartOffset -or $i.Extent.EndOffset -eq $cursorPosition) {
        continue
      }
      if ($i -isnot [StringConstantExpressionAst] -or
        $i.StringConstantType -ne [StringConstantType]::BareWord -or
        $i.Value.StartsWith('-')) {
        break
      }
      $i.Value
    }) -join ' '

  @(if ($wordToComplete.StartsWith('-')) {
      '-a', '--architecture=amd64', '--architecture=arm64', '--architecture=loongarch64', '-c', '--config-file=', '-D', '--from-deb', '-f', '--from-file', '--filter-origins=', '--filter-suites=unstable', '--filter-suites=noble', '--filter-suites=', '-F', '--fixed-string', '--index-names=deb', '--index-names=dsc', '--index-names=udeb', '-I', '-i', '--ignore-case', '-l', '--package-only', '--stream-results', '-o', '--option=APT', '--substring-match', '-v', '--verbose', '-x', '--regexp', '-h', '--help'
    }
    switch ($command) {
      '' {
        if ($wordToComplete.StartsWith('-')) {
          break
        }
        'find', 'list', 'list-indices', 'search', 'show', 'update'
        break
      }
    }
  ).Where{ $_ -like "$wordToComplete*" }
}
