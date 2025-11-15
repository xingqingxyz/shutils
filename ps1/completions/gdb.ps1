Register-ArgumentCompleter -Native -CommandName gdb, rust-gdb -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('-')) {
      '--args', '--core=', '--exec=', '--pid=', '--directory=', '--se=', '--symbols=', '--readnow', '--readnever', '--write', '--command=', '-x', '--init-command=', '-ix', '--eval-command=', '-ex', '--init-eval-command=', '--nh', '--nx', '--fullname', '--interpreter=', '--tty=', '-w', '--nw', '--tui', '-q', '--quiet', '--silent', '--batch', '--batch-silent', '--return-child-result', '--configuration', '--help', '--version', '-b', '-l', '--cd=', '--data-directory=', '-D'
    }).Where{ $_ -like "$wordToComplete*" }
}
