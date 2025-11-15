Register-ArgumentCompleter -Native -CommandName eu-stack -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--core=', '--debuginfo-path=', '-e', '--executable=', '-p', '--pid=', '-1', '-a', '--activation', '-b', '--build-id', '-c', '--cfi-type', '-d', '--debugname', '-i', '--inlines', '-l', '--list-modules', '-m', '--module', '-n', '-q', '--quiet', '-r', '--raw', '-s', '--source', '-S', '--sysroot=', '-v', '--verbose', '--help', '--usage', '-V', '--version'
    }).Where{ $_ -like "$wordToComplete*" }
}
