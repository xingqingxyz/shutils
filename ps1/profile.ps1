#region common
function .. {
  Set-Location -LiteralPath ..
}

function ... {
  Set-Location -LiteralPath ../..
}

function .... {
  Set-Location -LiteralPath ../../..
}
#endregion

#region windows
if ($IsWindows) {
  Set-Variable -Option ReadOnly -Force _executableAliasMap @{
    grep = 'grep', '--color=auto'
    rg   = 'rg', '--hyperlink-format=vscode'
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
    $cmd, $ags = @($_executableAliasMap[$cmd]) + $args.ForEach{ if ($null -ne $_) { $_ } }
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
  # note: stdout and stderr are ignored in this scriptblock
  $ExecutionContext.InvokeCommand.CommandNotFoundAction = {
    [System.Management.Automation.CommandLookupEventArgs]$e = $args[1]
    if ($e.CommandOrigin -ceq 'Runspace' -and !$e.CommandName.StartsWith('get-')) {
      $lines = winget search -s winget -n 1 --no-vt (Split-Path -LeafBase $e.CommandName)
      if (!$?) {
        return
      }
      $id = [regex]::Match($lines[2], '(?<= )[-\w]+\.[-\w]+(?= )').Value
      if (!$id) {
        throw "cannot find winget package ($($lines[2]))"
      }
      winget show -s winget --id $id | Out-Host
      if (!$?) {
        throw "cannot show winget package ($id)"
      }
      $ok = Read-Host "Install $id`? (Y/N)"
      if ($ok -eq 'y') {
        sudo winget install -s winget --accept-package-agreements --no-vt --id $id
        if ($?) {
          $e.CommandScriptBlock = [scriptblock]::Create('Update-SessionEnvironment; & ' + $e.CommandName)
          $e.StopSearch = $true
        }
      }
    }
  }
  return
}
#endregion

#region linux
function md {
  <#
  .FORWARDHELPTARGETNAME New-Item
  .FORWARDHELPCATEGORY Cmdlet
  #>
  New-Item @args -Type Directory -Force
}

Remove-Alias md
Set-Alias ls Get-ChildItem
Set-Variable -Option ReadOnly -Force _executableAliasMap @{
  egrep   = 'egrep', '--color=auto'
  grep    = 'grep', '--color=auto'
  xzegrep = 'xzegrep', '--color=auto'
  xzfgrep = 'xzfgrep', '--color=auto'
  xzgrep  = 'xzgrep', '--color=auto'
  zegrep  = 'zegrep', '--color=auto'
  zfgrep  = 'zfgrep', '--color=auto'
  zgrep   = 'zgrep', '--color=auto'
  rg      = 'rg', '--hyperlink-format=vscode'
}
if ($env:WSL_DISTRO_NAME) {
  $_executableAliasMap.rg = 'rg', "--hyperlink-format=vscode://file//wsl.localhost/$env:WSL_DISTRO_NAME{path}:{line}:{column}"
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
  [string[]]$ags = @('--') + $_executableAliasMap[$commandName] + $args.ForEach{ if ($null -ne $_) { $_ } }
  Write-CommandDebug /usr/bin/env $ags
  if ($MyInvocation.ExpectingInput) {
    $input | /usr/bin/env $ags
  }
  else {
    /usr/bin/env $ags
  }
}
# command-not-found
# note: stdout and stderr are ignored in the scriptblock
$ExecutionContext.InvokeCommand.CommandNotFoundAction = switch ((Get-Command apt, dnf -CommandType Application -TotalCount 1 -ea Ignore).Name) {
  apt {
    {
      [System.Management.Automation.CommandLookupEventArgs]$e = $args[1]
      if ($e.CommandOrigin -ceq 'Runspace' -and !$e.CommandName.StartsWith('get-')) {
        if (Test-Path -LiteralPath /usr/lib/command-not-found) {
          /usr/lib/command-not-found --ignore-installed --no-failure-msg $e.CommandName
        }
        elseif (Test-Path -LiteralPath /usr/libexec/pk-command-not-found) {
          /usr/libexec/pk-command-not-found $e.CommandName
        }
        else {
          return
        }
        if ($?) {
          $e.CommandScriptBlock = [scriptblock]::Create('& ' + $e.CommandName)
          $e.StopSearch = $true
        }
      }
    }
    break
  }
  dnf {
    {
      [System.Management.Automation.CommandLookupEventArgs]$e = $args[1]
      if ($e.CommandOrigin -ceq 'Runspace' -and !$e.CommandName.StartsWith('get-')) {
        $name = dnf repoquery --file=/usr/bin/$($e.CommandName) 2>$null | Select-Object -Index 0
        if (!$name) {
          return
        }
        dnf info --cacheonly $name 2>$null | Out-Host
        $ok = Read-Host "Install $name`? (Y/N)"
        if ($ok -eq 'y') {
          sudo dnf install -y $name
          if ($?) {
            $e.CommandScriptBlock = [scriptblock]::Create('& ' + $e.CommandName)
            $e.StopSearch = $true
          }
        }
      }
    }
    break
  }
  default { break }
}
#endregion
