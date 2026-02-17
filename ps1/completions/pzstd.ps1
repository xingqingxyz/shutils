Register-ArgumentCompleter -Native -CommandName pzstd -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-p', '--processes', '-1', '-9', '-19', '-d', '--decompress', '-o', '-f', '--force', '--rm', '-k', '--keep', '-h', '--help', '-V', '--version', '-v', '--verbose', '-q', '--quiet', '-c', '--stdout', '-r', '--ultra', '-C', '--check', '--no-check', '-t', '--test'
    }).Where{ $_ -like "$wordToComplete*" }
}
