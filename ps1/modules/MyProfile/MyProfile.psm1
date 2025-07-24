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
  if ($MyInvocation.ExpectingInput) {
    return $input | bat -plhelp
  }
  $info = Get-Command $Command -TotalCount 1
  if ($info.CommandType -eq 'Alias') {
    $info = $info.ResolvedCommand
  }
  switch ([string]$info.CommandType) {
    Cmdlet {
      return help $Command -Category Cmdlet
    }
    Configuration {
      return $Command
    }
    { 'Filter,Function'.Contains($_) } {
      return $info.Definition | bat -plps1
    }
    { 'Application,ExternalScript'.Contains($_) } {
      return bat -p $info.Path
    }
  }
}

function Invoke-Less {
  if ($MyInvocation.Statement -eq '& $pagerCommand $pagerArgs') {
    return $input | bat -plman
  }
  $cmd = $IsWindows ? 'C:\Program Files\Git\usr\bin\less.exe' : '/usr/bin/less'
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd @args
  }
  else {
    & $cmd @args
  }
}

function Invoke-Npm {
  $npm = switch ($true) {
    # use npm as a cli, pipe output
    ($MyInvocation.PipelineLength -ne 1) { 'npm'; break }
    (Test-Path bun.lock?) { 'bun' ; break }
    (Test-Path deno.json) { 'deno'; break }
    (Test-Path pnpm-lock.yaml) { 'pnpm'; break }
    (Test-Path yarn.lock) { 'yarn'; break }
    default { 'npm'; break }
  }
  if ((Get-Alias -Definition Invoke-Npm).Name.Contains($npm)) {
    $npm = (Get-Command $npm -Type Application -TotalCount 1 -ea Stop).Path
  }
  if ($MyInvocation.ExpectingInput) {
    $input | & $npm @args
  }
  else {
    & $npm @args
  }
}

function Invoke-Npx {
  if (Get-ChildItem -LiteralPath node_modules/.bin -ea Ignore | Where-Object BaseName -EQ $args[0]) {
    if ($MyInvocation.ExpectingInput) {
      $input | & "node_modules/.bin/$($args[0])" $args[1..($args.Length)]
    }
    else {
      & "node_modules/.bin/$($args[0])" $args[1..($args.Length)]
    }
    return
  }
  $npx, $arguments = switch ($true) {
    (Test-Path bun.lockb) { 'bun', 'x' + $args; break }
    (Test-Path deno.json) { 'deno', 'run' + $args; break }
    (Test-Path pnpm-lock.yaml) { 'pnpx', $args; break }
    (Test-Path yarn.lock) { 'yarn', 'dlx' + $args; break }
    default { 'npx', $args; break }
  }
  if ((Get-Alias -Definition Invoke-Npx).Name.Contains($npx)) {
    $npx = (Get-Command $npx -Type Application -TotalCount 1 -ea Stop).Path
  }
  if ($MyInvocation.ExpectingInput) {
    $input | & $npx @arguments
  }
  else {
    & $npx @arguments
  }
}

#region sudo
$sudoExe = (Get-Command sudo -CommandType Application -TotalCount 1 -ea Ignore).Path
$pwshExe = [System.Environment]::ProcessPath
if ((Split-Path -LeafBase $pwshExe) -ne 'pwsh') {
  $pwshExe = (Get-Command pwsh -CommandType Application -TotalCount 1 -ea Ignore).Path ?? 'pwsh'
}
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
      $InputObject | & $sudoExe -- @ags
    }
    else {
      & $sudoExe -- @ags
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
  (Get-Item (Get-Command -Type Application -TotalCount ($All ? 9999 : 1) $Name).Path).ResolvedTarget
}
