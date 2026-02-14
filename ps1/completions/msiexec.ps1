Register-ArgumentCompleter -Native -CommandName msiexec -ScriptBlock {
  param ([string]$wordToComplete, [System.Management.Automation.Language.CommandAst]$commandAst, [int]$cursorPosition)
  @(if ($wordToComplete.StartsWith('/')) {
      '/a', '/fa', '/fc', '/fd', '/fe', '/fm', '/fo', '/forcerestart', '/fp', '/fs', '/fu', '/fv', '/g', '/help', '/i', '/jm', '/ju', '/l!', '/l*', '/l+', '/la', '/lc', '/le', '/li', '/lm', '/lo', '/log', '/lp', '/lr', '/lu', '/lv', '/lw', '/lx', '/norestart', '/package', '/passive', '/promptrestart', '/qb', '/qf', '/qn', '/qr', '/quiet', '/t', '/uninstall', '/update', '/x'
    }).Where{ $_ -like "$wordToComplete*" }
}

