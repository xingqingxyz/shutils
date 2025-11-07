Register-ArgumentCompleter -Native -CommandName cargo-install-update-config -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-a', '--any-version', '--build-profile=', '-c', '--cargo-dir=', '-d', '--default-features=', '--debug', '-e', '--environment=', '-E', '--clear-environment=', '--enforce-lock', '-f', '--feature=', '-h', '--help', '--inherit-environment=', '--install-prereleases', '-n', '--no-feature=', '--no-enforce-lock', '--no-install-prereleases', '--no-respect-binaries', '-r', '--reset', '--release', '--respect-binaries', '-t', '--toolchain=', '-v', '--version='
    }).Where{ $_ -like "$wordToComplete*" }
}
