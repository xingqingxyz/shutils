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
    $commandLine = $MyInvocation.Line.Substring($MyInvocation.OffsetInLine + $MyInvocation.InvocationName.Length)
    $lineAst = [Parser]::ParseInput($commandLine, [ref]$null, [ref]$null)
    $sudoOpts = @()
    $commandAst = $lineAst.Find({
        param($ast)
        if ($ast -is [CommandAst] -or $ast -is [ScriptBlockAst]) {
          $true
        }
        else {
          $sudoOpts += $ast.ToString()
          $false
        }
      }, $false)
    if ($commandAst -is [ScriptBlockAst]) {
      $pwshExe = (Get-Process -Id $PID).Path
      $cwa = $args[$sudoOpts.Length..($args.Length - 1)]
      $cwa[0] = $cwa[0].ToString()
      if ($MyInvocation.ExpectingInput) {
        $input | & $sudoExe @$sudoOpts run $pwshExe -nop -nol -cwa @cwa
      }
      else {
        & $sudoExe @$sudoOpts run $pwshExe -nop -nol -cwa @cwa
      }
      return
    }
    $commandName = $commandAst.GetCommandName()
    if ($commandName -eq 'run' -or
        (Get-Command $commandName -Type Application -TotalCount 1 -ErrorAction Ignore)) {
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
      $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($commandLine))
      Write-Debug "$sudoExe $sudoOpts run $pwshExe -nop -nol -e $encodedCommand"
      if ($MyInvocation.ExpectingInput) {
        $input | & $sudoExe @$sudoOpts run $pwshExe -nop -nol -e $encodedCommand
      }
      else {
        & $sudoExe @$sudoOpts run $pwshExe -nop -nol -e $encodedCommand
      }
    }
  }
}
else {
  function sudo {
    $pwshExe = (Get-Process -Id $PID).Path
    $ArgumentList = @(if ($args[0] -is [scriptblock]) {
        @('-nop', '-nol', '-cwa')
      }
      else {
        @('-nop', '-nol', '-c')
      }) + $args
    Write-Debug "$pwshExe $ArgumentList"
    Start-Process -FilePath $pwshExe -ArgumentList $ArgumentList -Verb RunAs
  }
}

function _runResolved {
  $cmd = (Get-Item (Get-Command $MyInvocation.InvocationName -Type Application -TotalCount 1).Path).ResolvedTarget
  Start-Process -FilePath $cmd -ArgumentList $args -WorkingDirectory $cmd/.. -Wait -NoNewWindow
}

@('adb', 'fastboot', 'lua-language-server') | ForEach-Object { Set-Alias $_ _runResolved }
