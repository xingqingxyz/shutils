function vw {
  param([string]$Path = $PWD)
  if (!(Test-Path $Path)) {
    throw "path not found: $Path"
  }
  switch ((Get-Item $Path).GetType()) {
    ([System.IO.DirectoryInfo]) {
      $Path = fzf --scheme=path
      if ($LASTEXITCODE -ne 0) {
        Get-ChildItem $Path
      }
      else {
        vw $Path
      }
    }
    ([System.IO.FileInfo]) {
      bat $Path
    }
  }
}

function h {
  param([Parameter(Mandatory)][string]$cmd, [switch]$NoViewSource)
  if ($MyInvocation.ExpectingInput) {
    bat -lhelp
    return
  }
  $cmd = (Get-Alias $cmd -ErrorAction Ignore).Definition ?? $cmd
  $info = Get-Command $cmd -TotalCount 1
  switch ([string]$info.CommandType) {
    Application {
      & $cmd --help | bat -lhelp
    }
    Cmdlet {
      help $cmd
    }
    Configuration {
      $cmd
    }
    { @('Filter', 'Function', 'Script', 'ExternalScript').Contains($_) } {
      if ($NoViewSource) {
        help $cmd
      }
      else {
        $info.Definition | bat -lps1
      }
    }
  }
}

function v {
  if ($MyInvocation.ExpectingInput) {
    $input | nvim -u NORC $args
  }
  else {
    nvim -u NORC $args
  }
}

function less {
  if ($MyInvocation.Statement -eq '& $pagerCommand $pagerArgs') {
    $input | bat -lman
    return
  }
  # $cmd = (Get-Command less -CommandType Application -TotalCount 1).Source
  $cmd = 'C:\Program Files\Git\usr\bin\less.exe'
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $args
  }
  else {
    & $cmd $args
  }
}

if (!$isWindows) {
  return
}

function bat {
  if ($MyInvocation.ExpectingInput) {
    $input | bat.exe --color=always $args | & $env:PAGER
  }
  else {
    bat.exe --color=always $args | & $env:PAGER
  }
}

function winget {
  if ($args.Length -gt 1 -and
    @('install', 'upgrade', 'update', 'import', 'uninstall', 'pin').Contains($args[0]) -and
    ![System.Security.Principal.WindowsPrincipal]::new([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'needs to be run as administrator'
  }
  winget.exe $args
}

function _runResolved {
  $cmd = (Get-Item (Get-Command $MyInvocation.InvocationName -Type Application -TotalCount 1).Source).ResolvedTarget
  Start-Process -WorkingDirectory $cmd/.. -ArgumentList $args -FilePath $cmd -Wait -NoNewWindow
}

@('adb', 'fastboot', 'lua-language-server') | ForEach-Object { Set-Alias $_ _runResolved }
