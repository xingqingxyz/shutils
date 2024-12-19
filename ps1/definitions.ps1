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

function vh {
  param([string]$cmd, [switch]$NoViewSource)
  if ($MyInvocation.ExpectingInput) {
    $input | bat -lhelp
    return
  }
  if ($cmd -eq '') {
    help h
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

function vi {
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
  $cmd = $IsWindows ? 'C:\Program Files\Git\usr\bin\less.exe' : '/usr/bin/less'
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $args
  }
  else {
    & $cmd $args
  }
}

& {
  $hook = {
    $npm = switch ($true) {
      (Test-Path package-lock.json) { 'npm'; break }
      (Test-Path pnpm-lock.yaml) { 'pnpm'; break }
      (Test-Path bun.lockb) { 'bun' ; break }
      (Test-Path yarn.lock) { 'yarn'; break }
      (Test-Path deno.json) { 'deno'; break }
      Default { 'npm' }
    }
    Set-Alias -Scope Global _npm (Get-Command -Type Application -TotalCount 1 $npm).Path
  }
  # init search
  & $hook
  $action = $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction
  $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction = if ($action) {
    [Delegate]::Combine($action, $hook)
  }
  else {
    $hook
  }
}
function npm {
  if ($MyInvocation.ExpectingInput) {
    $input | _npm @args
    return
  }
  if ($args.Contains('--help')) {
    _npm @args | vh
  }
  elseif (@('i', 'install', 'a', 'add').Contains($args[0])) {
    if (!$args.Contains('-D')) {
      $argStr = "$($args | Select-Object -Skip 1)"
      $types = [regex]::Replace($argStr, '\b(?<!@types/).*?\b', '')
      if ($types.Length) {
        $noTypes = [regex]::Replace($argStr, '\b@types/.*?\b', '')
        $argStr = "_npm $($args[0]) $types -D"
        Write-Information $argStr
        Invoke-Expression $argStr
        $argStr = "_npm $($args[0]) $noTypes"
        Write-Information $argStr
        Invoke-Expression $argStr
      }
    }
  }
  else {
    _npm @args
  }
}

if (!$IsWindows) {
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

function sudo {
  Start-Process -FilePath (Get-Command $args[0] -Type Application -TotalCount 1).Path -ArgumentList $args[1..($args.Length)] -Verb RunAs
}

function _runResolved {
  $cmd = (Get-Item (Get-Command $MyInvocation.InvocationName -Type Application -TotalCount 1).Source).ResolvedTarget
  Start-Process -WorkingDirectory $cmd/.. -ArgumentList $args -FilePath $cmd -Wait -NoNewWindow
}

@('adb', 'fastboot', 'lua-language-server') | ForEach-Object { Set-Alias $_ _runResolved }
