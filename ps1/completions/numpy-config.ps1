Register-ArgumentCompleter -Native -CommandName numpy-config -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '-h', '--help', '--version', '--cflags=', '--pkgconfigdir='
    }).Where{ $_ -like "$wordToComplete*" }
}
