function mkdir {
  New-Item -ItemType Directory $args
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
  ls       = 'ls', '-Ah', '--color=auto', '--hyperlink=auto'
  rg       = 'rg', ($env:WSL_DISTRO_NAME ? '--hyperlink-format=vscode://file{wslprefix}{path}' : '--hyperlink-format=vscode')
  tree     = 'tree', '-C', '--gitignore', '--hyperlink'
  plantuml = 'java', '-jar', "$HOME/.local/bin/plantuml.jar"
  tracexec = 'bash', '-ic', 'tracexec "$0" "$@"'
}
if ($env:TERM_PROGRAM -cnotlike 'vscode*') {
  $_executableAliasMap.fd = 'fd', '--hyperlink=auto'
}
Set-Item -LiteralPath $_executableAliasMap.Keys.ForEach{ "Function:$_" } {
  # prevent . invoke variable add
  if ($MyInvocation.InvocationName -eq '.') {
    return & $MyInvocation.MyCommand $args
  }
  $command = $MyInvocation.MyCommand.Name
  if (!$_executableAliasMap.Contains($command)) {
    return Write-Error "alias not set $command"
  }
  # flat iterator args for native passing
  $command = @('--', $_executableAliasMap.$command; $args.ForEach{ $_ })
  Write-CommandDebug /usr/bin/env $command
  if ($MyInvocation.ExpectingInput) {
    $input | /usr/bin/env $command
  }
  else {
    /usr/bin/env $command
  }
}
# PackageKit command-not-found
$ExecutionContext.InvokeCommand.CommandNotFoundAction = {
  [System.Management.Automation.CommandLookupEventArgs]$e = $args[1]
  if ($e.CommandOrigin -ceq 'Runspace' -and !$e.CommandName.StartsWith('get-')) {
    /usr/libexec/pk-command-not-found $e.CommandName 2>$null
  }
}
