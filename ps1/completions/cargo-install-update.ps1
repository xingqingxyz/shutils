Register-ArgumentCompleter -Native -CommandName cargo-install-update -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-a', '--all', '-c', '--cargo-dir=', '-d', '--downdate', '-f', '--force', '-g', '--git', '-h', '--help', '-i', '--allow-no-update', '-j', '--jobs=32', '-l', '--list', '--locked', '-q', '--quiet', '-r', '--install-cargo=', '-s', '--filter=', '-t', '--temp-dir=', '-V', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
