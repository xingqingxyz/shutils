function Invoke-ExecutableAlias {
  if (!$_executableAliasMap.Contains($MyInvocation.InvocationName)) {
    return Write-Error "alias not set $($MyInvocation.InvocationName)"
  }
  # flat iterator args for native passing
  $command = @($_executableAliasMap[$MyInvocation.InvocationName]; $args.ForEach{ $_ })
  Write-Debug "/usr/bin/env -- $command"
  if ($MyInvocation.ExpectingInput) {
    $input | /usr/bin/env -- $command
  }
  else {
    /usr/bin/env -- $command
  }
}

Set-Variable -Option ReadOnly -Force _executableAliasMap @{
  egrep    = 'egrep', '--color=auto'
  grep     = 'grep', '--color=auto'
  xzegrep  = 'xzegrep', '--color=auto'
  xzfgrep  = 'xzfgrep', '--color=auto'
  xzgrep   = 'xzgrep', '--color=auto'
  zegrep   = 'zegrep', '--color=auto'
  zfgrep   = 'zfgrep', '--color=auto'
  zgrep    = 'zgrep', '--color=auto'
  ls       = 'ls', '-A', '--color=auto', '--hyperlink=auto'
  tree     = 'tree', '-C', '--gitignore', '--hyperlink'
  plantuml = 'java', '-jar', "$HOME/.local/bin/plantuml.jar"
}
if ($env:TERM_PROGRAM -notlike 'vscode*') {
  $_executableAliasMap.fd = 'fd', '--hyperlink=auto'
  $_executableAliasMap.rg = 'rg', ($env:WSL_DISTRO_NAME ? '--hyperlink-format=file://{wslprefix}{path}' : '--hyperlink-format=default')
}
$_executableAliasMap.Keys.ForEach{ Set-Alias $_ Invoke-ExecutableAlias }
