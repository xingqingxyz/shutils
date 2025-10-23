Register-ArgumentCompleter -Native -CommandName cargo-generate -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--test', '--list-favorites', '-v', '--verbose', '-q', '--quiet', '--continue-on-error', '-s', '--silent', '-c', '--config', '-h', '--help', '-V', '--version', '-g', '--git', '-p', '--path', '--favorite', '-b', '--branch=main', '--branch=master', '-t', '--tag', '-r', '--revision', '-i', '--identity', '--gitconfig', '--skip-submodules', '-n', '--name', '-f', '--force', '--values-file', '--vcs', '--lib', '--bin', '-d', '--define', '--init', '--destination', '--force-git-init', '-a', '--allow-commands', '-o', '--overwrite'
    }).Where{ $_ -like "$wordToComplete*" }
}
