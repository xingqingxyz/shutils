if ($IsWindows) {
  function vsdev {
    Import-Module 'C:\Program Files\Microsoft Visual Studio\18\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll'
    Enter-VsDevShell 1da1aa76 -SkipAutomaticLocation -DevCmdArguments '-arch=x64 -host_arch=x64'
  }

  Set-Variable -Option ReadOnly -Force _executableAliasMap @{
    grep     = 'grep', '--color=auto'
    plantuml = 'java', '-jar', "$HOME\tools\plantuml.jar"
    rg       = 'rg', '--hyperlink-format=vscode'
  }
  if ($env:TERM_PROGRAM -cnotlike 'vscode*') {
    $_executableAliasMap.fd = 'fd', '--hyperlink=auto'
  }
  Set-Item -LiteralPath $_executableAliasMap.Keys.ForEach{ "Function:$_" } {
    # prevent . invoke variable add
    if ($MyInvocation.InvocationName -ceq '.') {
      return & $MyInvocation.MyCommand $args
    }
    $cmd = $MyInvocation.MyCommand.Name
    if (!$_executableAliasMap.Contains($cmd)) {
      return Write-Error "alias not set $cmd"
    }
    # flat iterator args for native passing
    $cmd, $ags = @($_executableAliasMap[$cmd]) + $args.ForEach{
      if ($null -ne $_) {
        $_
      }
    }
    $cmd = (Get-Command $cmd -Type Application -TotalCount 1 -ea Stop).Source
    Write-CommandDebug $cmd $ags
    if ($MyInvocation.ExpectingInput) {
      $input | & $cmd $ags
    }
    else {
      & $cmd $ags
    }
  }
  # winget command-not-found
  # note: stdout, stderr are ignored in the scriptblock
  $ExecutionContext.InvokeCommand.CommandNotFoundAction = {
    [System.Management.Automation.CommandLookupEventArgs]$e = $args[1]
    if ($e.CommandOrigin -ceq 'Runspace' -and !$e.CommandName.StartsWith('get-')) {
      [string[]]$lines = winget search -s winget -n 1 --no-vt --cmd (Split-Path -LeafBase $e.CommandName)
      if ($lines.Count -ne 3) {
        return
      }
      $add = switch ((Get-Culture).Name) {
        en-US { 0; break }
        zh-CN { 2; break }
        default { return }
      }
      $id = $lines[2].Substring($lines[0].IndexOf('ID') + $add).Split(' ', 2)[0]
      winget show -s winget --id $id | Out-Host
      $ok = Read-Host "Install? (Y/N)"
      if ($ok -eq 'y') {
        sudo winget install -s winget --accept-package-agreements --no-vt --id $id
      }
    }
  }
  return
}

#region linux
function mkdir {
  New-Item -ItemType Directory $args
}

Set-Alias ls Get-ChildItem
Set-Variable -Option ReadOnly -Force _executableAliasMap @{
  egrep    = 'egrep', '--color=auto'
  grep     = 'grep', '--color=auto'
  xzegrep  = 'xzegrep', '--color=auto'
  xzfgrep  = 'xzfgrep', '--color=auto'
  xzgrep   = 'xzgrep', '--color=auto'
  zegrep   = 'zegrep', '--color=auto'
  zfgrep   = 'zfgrep', '--color=auto'
  zgrep    = 'zgrep', '--color=auto'
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
  if ($MyInvocation.InvocationName -ceq '.') {
    return & $MyInvocation.MyCommand $args
  }
  [string]$commandName = $MyInvocation.MyCommand.Name
  if (!$_executableAliasMap.Contains($commandName)) {
    return Write-Error "alias not set $commandName"
  }
  # flat iterator args for native passing
  [string[]]$ags = @('--') + $_executableAliasMap[$commandName] + $args.ForEach{
    if ($null -ne $_) {
      $_
    }
  }
  Write-CommandDebug /usr/bin/env $ags
  if ($MyInvocation.ExpectingInput) {
    $input | /usr/bin/env $ags
  }
  else {
    /usr/bin/env $ags
  }
}
# command-not-found
$ExecutionContext.InvokeCommand.CommandNotFoundAction = {
  [System.Management.Automation.CommandLookupEventArgs]$e = $args[1]
  if ($e.CommandOrigin -ceq 'Runspace' -and !$e.CommandName.StartsWith('get-')) {
    if (Test-Path -LiteralPath /usr/lib/command-not-found) {
      /usr/lib/command-not-found --ignore-installed --no-failure-msg $e.CommandName
    }
    elseif (Test-Path -LiteralPath /usr/libexec/pk-command-not-found) {
      /usr/libexec/pk-command-not-found $e.CommandName
    }
  }
}
#endregion
