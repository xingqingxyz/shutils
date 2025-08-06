function vw {
  param(
    [ArgumentCompleter({
        # note: using namespace not effects, this executed likes background job
        [OutputType([System.Management.Automation.CompletionResult])]
        param(
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete,
          [System.Management.Automation.Language.CommandAst]$CommandAst,
          [System.Collections.IDictionary]$FakeBoundParameters
        )
        $results = @([System.Management.Automation.CompletionCompleters]::CompleteFilename($wordToComplete))
        if ($results.Length) { $results } else {
          [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
        }
      })]
    [string]
    $Command = 'vw'
  )
  $extraArgs = $args[1..($args.Length - 1)]
  if ($MyInvocation.ExpectingInput) {
    return $input | bat -plhelp $extraArgs
  }
  $info = Get-Command $Command -TotalCount 1
  if ($info.CommandType -eq 'Alias') {
    $info = $info.ResolvedCommand
  }
  switch ([string]$info.CommandType) {
    Cmdlet {
      return help $Command -Category Cmdlet @extraArgs
    }
    Configuration {
      return $Command
    }
    { 'Filter,Function'.Contains($_) } {
      return $info.Definition | bat -plps1 $extraArgs
    }
    { 'Application,ExternalScript'.Contains($_) } {
      return bat $info.Path -p $extraArgs
    }
  }
}

function Invoke-Less {
  if ($MyInvocation.Statement -eq '& $pagerCommand $pagerArgs') {
    return $input | bat -plman $args
  }
  $cmd = $IsWindows ? 'C:\Program Files\Git\usr\bin\less.exe' : '/usr/bin/less'
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $args
  }
  else {
    & $cmd $args
  }
}

function Invoke-Npm {
  $npm = switch ($true) {
    # use npm as a cli, pipe output
    ($MyInvocation.PipelineLength -ne 1) { 'npm'; break }
    (Test-Path pnpm-lock.yaml) { 'pnpm'; break }
    (Test-Path bun.lock?) { 'bun' ; break }
    (Test-Path yarn.lock) { 'yarn'; break }
    (Test-Path deno.json) { 'deno'; break }
    default { 'npm'; break }
  }
  $npm = (Get-Command $npm -Type Application -TotalCount 1 -ea Stop).Path
  if ($MyInvocation.ExpectingInput) {
    $input | & $npm $args
  }
  else {
    & $npm $args
  }
}

function Invoke-Npx {
  $cmd, $ags = $args
  $cmd = (Get-Command ./node_modules/.bin/$cmd -Type Application -TotalCount 1 -ea Ignore).Path
  if (!$cmd) {
    $cmd, $ags = switch ($true) {
      (Test-Path pnpm-lock.yaml) { @('pnpm', 'dlx', '--') + $args; break }
      (Test-Path yarn.lock) { @('yarn', 'dlx', '--') + $args; break }
      (Test-Path bun.lock?) { @('bun', 'x') + $args; break }
      default { @('npx') + $args; break }
    }
    $cmd = (Get-Command $cmd -Type Application -TotalCount 1 -ea Stop).Path
  }
  Write-Debug "$cmd $ags"
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $ags
  }
  else {
    & $cmd $ags
  }
}

#region sudo
$sudoExe, $pwshExe = (Get-Command sudo, pwsh -CommandType Application -TotalCount 1 -ea Ignore).Path
if ($sudoExe) {
  function Invoke-Sudo {
    [string[]]$extraArgs = if ($args[0] -is [scriptblock]) {
      $args[0] = $args[0].ToString()
      @($pwshExe, '-nop', '-cwa')
    }
    else {
      $info = Get-Command $args[0] -TotalCount 1 -ea Ignore
      if ($info.CommandType -eq 'Alias') {
        $info = $info.ResolvedCommand
      }
      if ($null -eq $info) {
        return
      }
      elseif ($info.CommandType -eq 'Application') {
      }
      elseif ('Function,Filter'.Contains([string]$info.CommandType)) {
        if ($null -eq $info.Module) {
          return
        }
        @($pwshExe, '-nop')
      }
      elseif ('ExternalScript'.Contains([string]$info.CommandType)) {
        @($pwshExe, '-nop')
      }
      else {
        @($pwshExe, '-nop', '-c')
      }
    }
    $ags = $extraArgs + $args
    Write-Debug "$sudoExe -- $ags"
    if ($InputObject) {
      $InputObject | & $sudoExe -- $ags
    }
    else {
      & $sudoExe -- $ags
    }
  }
}
elseif ($IsWindows) {
  function Invoke-Sudo {
    [string[]]$extraArgs = if ($args[0] -is [scriptblock]) {
      $args[0] = $args[0].ToString()
      @($pwshExe, '-nop', '-cwa')
    }
    else {
      $info = Get-Command $args[0] -TotalCount 1 -ea Ignore
      if ($info.CommandType -eq 'Alias') {
        $info = $info.ResolvedCommand
      }
      if ($null -eq $info) {
        return
      }
      elseif ($info.CommandType -eq 'Application') {
      }
      elseif ('Function,Filter'.Contains([string]$info.CommandType)) {
        if ($null -eq $info.Module) {
          return
        }
        @($pwshExe, '-nop')
      }
      elseif ('ExternalScript'.Contains([string]$info.CommandType)) {
        @($pwshExe, '-nop')
      }
      else {
        @($pwshExe, '-nop', '-c')
      }
    }
    $command, $ags = $extraArgs + $args
    Write-Debug "$command $ags"
    Start-Process -FilePath $command -ArgumentList $ags -Verb RunAs -WorkingDirectory $WorkingDirectory
  }
}
#endregion

function Invoke-Which {
  param(
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Name,
    [switch]
    $All
  )
  (Get-Item (Get-Command -Type Application -TotalCount ($All ? 9999 : 1) -ea Stop $Name).Path).ResolvedTarget
}
