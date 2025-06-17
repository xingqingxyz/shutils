$npm = 'npm'

function Invoke-Npm {
  if ($MyInvocation.PipelineLength -ne 1) {
    $npm = 'npm'
  }
  Set-Alias npm (Get-Command $npm -Type Application, ExternalScript -TotalCount 1 -ea Stop).Path
  if ($MyInvocation.PipelineLength -ne 1) {
    if ($MyInvocation.ExpectingInput) {
      $input | npm @args
    }
    else {
      npm @args
    }
    return
  }
  if ($args.Contains('--help')) {
    return npm @args | bat -lhelp
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
      npm $command @types
    }
    if ($noTypes.Length) {
      npm $command @noTypes
    }
    return
  }
  npm @args
}

function Invoke-Npx {
  if (Get-ChildItem node_modules/.bin -ea Ignore | Where-Object BaseName -EQ $args[0]) {
    if ($MyInvocation.ExpectingInput) {
      $input | & "node_modules/.bin/$($args[0])" $args[1..($args.Length)]
    }
    else {
      & "node_modules/.bin/$($args[0])" $args[1..($args.Length)]
    }
    return
  }
  $npx, $arguments = switch ($npm) {
    'npm' { 'npx', $args; break }
    'pnpm' { 'pnpx', $args; break }
    'yarn' { 'yarn', 'dlx' + $args; break }
    'bun' { 'bun', 'x' + $args; break }
    'deno' { 'deno', 'run' + $args; break }
    Default { throw 'not supported package manager: ' + $npm }
  }
  if ($MyInvocation.ExpectingInput) {
    $input | & $npx @arguments
  }
  else {
    & $npx @arguments
  }
}

$hook = {
  $Script:npm = $(switch ($true) {
      (Test-Path pnpm-lock.yaml) { 'pnpm'; break }
      (Test-Path bun.lockb) { 'bun' ; break }
      (Test-Path yarn.lock) { 'yarn'; break }
      (Test-Path deno.json) { 'deno'; break }
      Default { 'npm' }
    })
}
& $hook
$action = $ExecutionContext.SessionState.InvokeCommand.LocationChangedAction
$ExecutionContext.SessionState.InvokeCommand.LocationChangedAction = if ($action) {
  [Delegate]::Combine($action.Target.Constants.Where{ $_.Module.Name -ne $MyInvocation.MyCommand.ModuleName } + [System.EventHandler[System.Management.Automation.LocationChangedEventArgs]]$hook)
}
else {
  $hook
}
Set-Alias npm Invoke-Npm
Set-Alias npx Invoke-Npx
