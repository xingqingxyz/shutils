using namespace System.Management.Automation

function vw {
  param([Parameter(ValueFromPipeline)][string]$Path = $PWD)
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
      break
    }
    ([System.IO.FileInfo]) {
      bat $Path
      break
    }
  }
}

function vh {
  param([string]$Command, [switch]$Source)
  if ($MyInvocation.ExpectingInput) {
    $input | bat -lhelp
    return
  }
  elseif ($Command -eq '') {
    vh vh -Source:$Source
    return
  }
  $info = Get-Command $Command -TotalCount 1
  switch ($info.CommandType) {
    ([CommandTypes]::Alias) {
      vh $info.Definition -Source:$Source
      break
    }
    ([CommandTypes]::Application) {
      if ($Source) {
        bat $info.Path
      }
      else {
        & $Command --help | bat -lhelp
      }
      break
    }
    ([CommandTypes]::Cmdlet) {
      help $Command -Category Cmdlet
      break
    }
    ([CommandTypes]::Configuration) {
      $Command
      break
    }
    ([CommandTypes]::Filter) {
      if ($Source) {
        $info.Definition | bat -lps1
      }
      else {
        help $Command -Category Filter
      }
      break
    }
    ([CommandTypes]::Function) {
      if ($Source) {
        $info.Definition | bat -lps1
      }
      else {
        help $Command -Category Function
      }
      break
    }
    ([CommandTypes]::Script) {
      if ($Source) {
        bat $info.Path
      }
      else {
        help $Command -Category ScriptCommand
      }
      break
    }
    ([CommandTypes]::ExternalScript) {
      if ($Source) {
        bat $info.Path
      }
      else {
        help $Command -Category ExternalScript
      }
      break
    }
  }
}

function vi {
  if ($MyInvocation.ExpectingInput) {
    $input | nvim -u NORC @args
  }
  else {
    nvim -u NORC @args
  }
}

function less {
  if ($MyInvocation.Statement -eq '& $pagerCommand $pagerArgs') {
    $input | bat -lman
    return
  }
  $cmd = $IsWindows ? 'C:\Program Files\Git\usr\bin\less.exe' : '/usr/bin/less'
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd @args
  }
  else {
    & $cmd @args
  }
}

function packageJSON {
  $dir = Get-Item .
  $rootName = $dir.Root.Name
  while (!(Test-Path "$dir/package.json")) {
    if ($dir.Name -eq $rootName) {
      return
    }
    $dir = $dir.Parent
  }
  Get-Content -Raw "$dir/package.json" | ConvertFrom-Json -AsHashtable
}

& {
  $hook = {
    $npm = switch ($true) {
      (Test-Path package-lock.json) { 'npm'; break }
      (Test-Path pnpm-lock.yaml) { 'pnpm'; break }
      (Test-Path bun.lockb) { 'bun' ; break }
      (Test-Path yarn.lock) { 'yarn'; break }
      (Test-Path deno.json) { 'deno'; break }
      Default { (Get-Command npm -Type Application -TotalCount 1).Path }
    }
    Set-Alias -Scope Global _npm $npm
  }
  # init search
  & $hook
  $action = $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction
  $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction = if ($action) {
    [Delegate]::Combine($action, [System.EventHandler[System.Management.Automation.LocationChangedEventArgs]]$hook)
  }
  else {
    $hook
  }
}
function npm {
  if ($MyInvocation.PipelineLength -ne 1) {
    Set-Alias _npm (Get-Command npm -Type Application -TotalCount 1).Path
    if ($MyInvocation.ExpectingInput) {
      $input | _npm @args
    }
    else {
      _npm @args
    }
    return
  }
  if ($args.Contains('--help')) {
    _npm @args | vh
    return
  }
  $command, $rest = $args
  if (@('i', 'install', 'a', 'add').Contains($command) -and !$rest.Contains('-D')) {
    $types = @()
    $noTypes = @()
    foreach ($arg in $rest) {
      if ($arg.StartsWith('-')) {
        continue
      }
      if ($arg.StartsWith('@types/')) {
        $types += $arg
      }
      else {
        $noTypes += $arg
      }
    }
    if ($types.Length) {
      _npm $command @types
    }
    if ($noTypes.Length) {
      _npm $command @noTypes
    }
    return
  }
  _npm @args
}

if (!$IsWindows) {
  return
}

function bat {
  if ($MyInvocation.ExpectingInput) {
    $input | bat.exe --color=always @args | & $env:PAGER
  }
  else {
    bat.exe --color=always @args | & $env:PAGER
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
