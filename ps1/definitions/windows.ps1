using namespace System.Management.Automation
using namespace System.Management.Automation.Language

function bat {
  $color = $MyInvocation.PipelinePosition -eq $MyInvocation.PipelineLength ? 'always' : 'never'
  if ($MyInvocation.ExpectingInput) {
    $input | bat.exe "--color=$color" @args | & $env:PAGER
  }
  else {
    bat.exe "--color=$color" @args | & $env:PAGER
  }
}

function copyq {
  if ($MyInvocation.ExpectingInput) {
    $input | copyq.exe @args | Write-Output
  }
  else {
    copyq.exe @args | Write-Output
  }
}

function winget {
  if ($args.Length -gt 1 -and
    @('install', 'upgrade', 'update', 'import', 'uninstall', 'pin').Contains($args[0]) -and
    ![System.Security.Principal.WindowsPrincipal]::new([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'needs to be run as administrator'
  }
  winget.exe @args
}

if (Test-Path C:\Windows\System32\sudo.exe) {
  function sudo {
    $sudoExe = 'C:\Windows\System32\sudo.exe'
    if (!$args.Length) {
      & $sudoExe
      return
    }
    $commandLine = $MyInvocation.Line.Substring($MyInvocation.OffsetInLine + $MyInvocation.InvocationName.Length)
    $sudoOpts = @()
    $commandName = ''
    $isScriptBlock = $false
    foreach ($i in $args) {
      if ($i -is [string] -and $i.StartsWith('-')) {
        $sudoOpts += $i
        continue
      }
      $isScriptBlock = $i -is [scriptblock]
      $commandName = $i.ToString()
      break
    }
    if ($isScriptBlock) {
      $pwshExe = (Get-Process -Id $PID).Path
      $cwa = $args[$sudoOpts.Length..($args.Length - 1)]
      $cwa[0] = $commandName
      Write-Debug "$sudoExe $sudoOpts run $pwshExe -nop -nol -cwa $cwa"
      if ($MyInvocation.ExpectingInput) {
        $input | & $sudoExe @sudoOpts run $pwshExe -nop -nol -cwa @cwa
      }
      else {
        & $sudoExe @sudoOpts run $pwshExe -nop -nol -cwa @cwa
      }
    }
    elseif ($commandName -eq 'run' -or (Get-Command $commandName -Type Application -TotalCount 1 -ErrorAction Ignore)) {
      Write-Debug "$sudoExe $sudoOpts $args"
      if ($MyInvocation.ExpectingInput) {
        $input | & $sudoExe @sudoOpts @args
      }
      else {
        & $sudoExe @sudoOpts @args
      }
    }
    elseif (Get-Command $commandName -Type Cmdlet, ExternalScript -TotalCount 1 -ErrorAction Ignore) {
      $pwshExe = (Get-Process -Id $PID).Path
      $commandLine = "$($args[$sudoOpts.Length..($args.Length - 1)])"
      $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($commandLine))
      Write-Debug "$sudoExe $sudoOpts run $pwshExe -nop -nol -e $encodedCommand{$commandLine}"
      if ($MyInvocation.ExpectingInput) {
        $input | & $sudoExe @sudoOpts run $pwshExe -nop -nol -e $encodedCommand
      }
      else {
        & $sudoExe @sudoOpts run $pwshExe -nop -nol -e $encodedCommand
      }
    }
    else {
      throw "can't resolve command $commandLine $commandName $sudoOpts"
    }
  }
}
else {
  function sudo {
    $filePath = ''
    $argumentList = $null
    if ($args[0] -is [scriptblock]) {
      $filePath = (Get-Process -Id $PID).Path
      $argumentList = @('-nop', '-nol', '-cwa') + $args
    }
    elseif (Get-Command $args[0] -Type Application -TotalCount 1 -ErrorAction Ignore) {
      $filePath, $argumentList = $args
    }
    elseif (Get-Command $args[0] -Type Cmdlet, ExternalScript -TotalCount 1 -ErrorAction Ignore) {
      $filePath = (Get-Process -Id $PID).Path
      $argumentList = @('-nop', '-nol', '-c') + $args
    }
    else {
      throw "can't resolve command $args"
    }
    Write-Debug "$filePath $argumentList"
    Start-Process -FilePath $filePath -ArgumentList $argumentList -Verb RunAs
  }
}

function _runResolved {
  $cmd = (Get-Item (Get-Command $MyInvocation.InvocationName -Type Application -TotalCount 1).Path).ResolvedTarget
  Start-Process -FilePath $cmd -ArgumentList $args -WorkingDirectory $cmd/.. -Wait -NoNewWindow
}

@('adb', 'fastboot', 'lua-language-server') | ForEach-Object { Set-Alias $_ _runResolved }
