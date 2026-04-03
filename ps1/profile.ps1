#Requires -Version 7.6

#region common
$root = [System.IO.Path]::GetDirectoryName((Get-Item -LiteralPath $PSCommandPath).ResolvedTarget)
# PSES
if (Get-Module PowerShellEditorServices.Commands -ea Ignore) {
  . $root/../scripts/Initialize-PSES.ps1
}
# load
. $root/complete.ps1
. $root/keybindings.ps1
. $root/z.ps1
Remove-Variable root
# the wish shell
Import-Module LSColors, Profile -ea Ignore
# excutable alias
Set-Variable -Option ReadOnly -Force _executableAliasMap @{
  grep = 'grep', '--color=auto'
  rg   = 'rg', '--hyperlink-format=vscode'
}
if ($env:TERM_PROGRAM -cnotlike 'vscode*') {
  $_executableAliasMap.fd = 'fd', '--hyperlink=auto'
}
#endregion

#region windows
if ($IsWindows) {
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
    $cmd, $ags = $_executableAliasMap[$cmd] + $args.Where{ $null -ne $_ }
    $cmd = (Get-Command $cmd -Type Application -TotalCount 1 -ea Stop).Source
    if ($MyInvocation.ExpectingInput) {
      Write-Debug "| $cmd $ags"
      $input | & $cmd $ags
    }
    else {
      Write-Debug "$cmd $ags"
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
      winget show -s winget --id $id
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

Remove-Alias md -ea Ignore
Set-Alias ls Get-ChildItem
if ($env:WSL_DISTRO_NAME) {
  $_executableAliasMap.rg = 'rg', "--hyperlink-format=vscode://file//wsl.localhost/$env:WSL_DISTRO_NAME{path}:{line}:{column}"
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
  $ags = , '--' + $_executableAliasMap[$cmd] + $args.Where{ $null -ne $_ }
  if ($MyInvocation.ExpectingInput) {
    Write-Debug "| /usr/bin/env $ags"
    $input | /usr/bin/env $ags
  }
  else {
    Write-Debug "/usr/bin/env $ags"
    /usr/bin/env $ags
  }
}
# command-not-found
$ExecutionContext.InvokeCommand.CommandNotFoundAction =
switch ((Get-Command apt, dnf -CommandType Application -TotalCount 1 -ea Ignore).Name) {
  apt {
    {
      [System.Management.Automation.CommandLookupEventArgs]$e = $args[1]
      if ($e.CommandOrigin -ceq 'Runspace' -and !$e.CommandName.StartsWith('get-')) {
        [string]$name = @(apt-file search -Fil /usr/bin/$($e.CommandName) 2>$null)[0]
        if (!$name) {
          return
        }
        # note: stdout and stderr are ignored unless sudo
        apt info $name | Out-Host
        $ok = Read-Host "Install $name`? (Y/N)"
        if ($ok -ne 'y') {
          return
        }
        # disable unstable interface warning
        sudo apt install -y $name 2>$null
        if ($?) {
          $e.CommandScriptBlock = [scriptblock]::Create("if (`$MyInvocation.ExpectingInput) { `$input | & $($e.CommandName) `$args } else { & $($e.CommandName) `$args }")
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
        [string]$name = @(dnf repoquery --file=/usr/bin/$($e.CommandName) --arch=$(arch) 2>$null)[0]
        if (!$name) {
          return
        }
        # note: stdout and stderr are ignored unless sudo
        dnf info $name | Out-Host
        $ok = Read-Host "Install $name`? (Y/N)"
        if ($ok -ne 'y') {
          return
        }
        sudo dnf install -y $name
        if ($?) {
          $e.CommandScriptBlock = [scriptblock]::Create("if (`$MyInvocation.ExpectingInput) { `$input | & $($e.CommandName) `$args } else { & $($e.CommandName) `$args }")
          $e.StopSearch = $true
        }
      }
    }
    break
  }
}
#endregion
