using namespace System.Management.Automation

function vw {
  param([Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)][string]$Path = $PWD)
  if (!(Test-Path $Path)) {
    try {
      vh $Path -Source
      return
    }
    catch {
      throw "path not found: $Path"
    }
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

Register-ArgumentCompleter -CommandName vw -ParameterName Path -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  if (!(Test-Path "$wordToComplete*")) {
    Get-Command "$wordToComplete*"
  }
}

function vh {
  param([string]$Command = 'vh', [switch]$Source)
  if ($MyInvocation.ExpectingInput) {
    $input | bat -lhelp
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
Register-ArgumentCompleter -CommandName vh -ParameterName Command -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  Get-Command "$wordToComplete*"
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

function yq {
  #Requires -Modules Yayaml
  $input | ConvertFrom-Yaml | ConvertTo-Json -Depth 100 | jq @args
}

function tq {
  #Requires -Modules PSToml
  $input | ConvertFrom-Toml | ConvertTo-Json -Depth 100 | jq @args
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

if ($IsWindows) {
  . $PSScriptRoot/definitions/windows.ps1
}
else {
  . $PSScriptRoot/definitions/linux.ps1
}
