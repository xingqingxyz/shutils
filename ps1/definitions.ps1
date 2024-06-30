function vv {
  param([string]$Path = $PWD, [switch]$Select)
  switch ((Get-Item $Path).GetType()) {
    ([System.IO.DirectoryInfo]) {
      if ($Select) {
        $Path = fzf --scheme=path --walker-root=$Path
        if ($LASTEXITCODE -ne 0) {
          Write-Error "fzf exited with code $LASTEXITCODE"
          return
        }
        return vv $Path
      }
    }
    ([System.IO.FileInfo]) {
      bat $Path
    }
    default { $item }
  }
}

function pp {
  param([switch]$PSDoc)
  if ($MyInvocation.ExpectingInput) {
    bat -l help
    return
  }
  $cmd = (Get-Alias $args[0] -ErrorAction Ignore).Definition ?? $args[0]
  switch ((Get-Command $cmd -TotalCount 1).CommandType) {
    Application {
      Invoke-Expression "$args --help" | bat -l help
    }
    Cmdlet {
      help $cmd
    }
    Configuration {
      $cmd
    }
    { $_ -eq 'Filter' -or $_ -eq 'Function' } {
      if ($PSDoc) {
        help $cmd
      }
      else {
        (Get-Item Function:$cmd).ScriptBlock.ToString() | bat -l ps1
      }
    }
    { $_ -eq 'Script' -or $_ -eq 'ExternalScript' } {
      if ($PSDoc) {
        help $cmd
      }
      else {
        bat (Get-Command $cmd -TotalCount 1).Source -l ps1
      }
    }
  }
}

function less {
  if ($MyInvocation.Statement -eq '& $pagerCommand $pagerArgs') {
    $input | bat -lman
    return
  }
  $cmd = (Get-Command less -CommandType Application -TotalCount 1).Source
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $args
  }
  else {
    & $cmd $args
  }
}

function ll {
  eza -lah $args
}

function tree {
  eza --tree $args
}

function v {
  nvim -u NORC $args
}

if (!$isWindows10) {
  return
}

function winget {
  if ($args.Length -gt 1 -and
    @('install', 'upgrade', 'update', 'import', 'uninstall', 'pin').Contains($args[0]) -and
    ![WindowsPrincipal]::new([WindowsIdentity]::GetCurrent()).IsInRole([WindowsBuiltInRole]::Administrator)) {
    throw 'user is not administrator'
  }
  winget.exe $args
}

function _runResolved {
  $cmd = (Get-Item (Get-Command -Type Application $MyInvocation.InvocationName)[0].Source).ResolvedTarget
  Start-Process -WorkingDirectory $cmd/.. -ArgumentList $args -FilePath $cmd -Wait -NoNewWindow
}

@('adb', 'fastboot', 'lua-language-server') | ForEach-Object { Set-Alias $_ _runResolved }
