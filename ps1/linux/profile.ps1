function Invoke-ExecutableAlias {
  Write-Debug "/usr/bin/env -- $($_executableAliasMap[$MyInvocation.InvocationName]) $args"
  if ($MyInvocation.ExpectingInput) {
    $input | /usr/bin/env -- $_executableAliasMap[$MyInvocation.InvocationName] @args
  }
  else {
    /usr/bin/env -- $_executableAliasMap[$MyInvocation.InvocationName] @args
  }
}

function man {
  if (!$args.Length) {
    return man -k . | fzf -m --reverse --wrap | ForEach-Object {
      $keyword, $section = $_.Split(' - ', 2)[0].TrimEnd().Split(' ', 2)
      $section = [int]$section.SubString(1, $section.Length - 2)
      Invoke-Application -Environment @{MANROFFOPT = '-c'; MANPAGER = "${env:SHUTILS_ROOT}/scripts/man.sh" } man $section $keyword
    }
  }

  Invoke-Application -Environment @{MANROFFOPT = '-c'; MANPAGER = "${env:SHUTILS_ROOT}/scripts/man.sh" } man $args
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
