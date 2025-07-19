function Invoke-ExecutableAlias {
  $command = $MyInvocation.InvocationName
  if ($command -eq '&') {
    $command = ($MyInvocation.Statement -split '\s+', 3)[1]
  }
  Write-Debug "/usr/bin/env -- $($_executableAliasMap.$command) $args"
  if ($MyInvocation.ExpectingInput) {
    $input | /usr/bin/env -- $_executableAliasMap.$command @args
  }
  else {
    /usr/bin/env -- $_executableAliasMap.$command @args
  }
}

$_executableAliasMap = @{
  egrep   = 'egrep', '--color=auto'
  grep    = 'grep', '--color=auto'
  xzegrep = 'xzegrep', '--color=auto'
  xzfgrep = 'xzfgrep', '--color=auto'
  xzgrep  = 'xzgrep', '--color=auto'
  zegrep  = 'zegrep', '--color=auto'
  zfgrep  = 'zfgrep', '--color=auto'
  zgrep   = 'zgrep', '--color=auto'
  l       = 'ls', '--color=auto', '--hyperlink=auto'
  ls      = 'ls', '--color=auto', '--hyperlink=auto', '-lah'
  tree    = 'tree', '-C', '--hyperlink', '--gitignore'
}
if ($env:TERM_PROGRAM -notlike 'vscode*') {
  $_executableAliasMap += @{
    fd = 'fd', '--hyperlink=auto'
    rg = 'rg', ($env:WSL_DISTRO_NAME ? '--hyperlink-format=file://${wslprefix}${path}' : '--hyperlink-format=default')
  }
}
$_executableAliasMap.Keys.ForEach{ Set-Alias $_ Invoke-ExecutableAlias }
