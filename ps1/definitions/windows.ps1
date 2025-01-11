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

function sudo {
  Start-Process -FilePath (Get-Command $args[0] -Type Application -TotalCount 1).Path -ArgumentList $args[1..($args.Length)] -Verb RunAs
}

function _runResolved {
  $cmd = (Get-Item (Get-Command $MyInvocation.InvocationName -Type Application -TotalCount 1).Path).ResolvedTarget
  Start-Process -FilePath $cmd -ArgumentList $args -WorkingDirectory $cmd/.. -Wait -NoNewWindow
}

@('adb', 'fastboot', 'lua-language-server') | ForEach-Object { Set-Alias $_ _runResolved }
