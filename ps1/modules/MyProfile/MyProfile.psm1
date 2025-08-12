<#
.SYNOPSIS
View command source.
 #>
function vw {
  param(
    [ArgumentCompleter({
        [OutputType([System.Management.Automation.CompletionResult])]
        param(
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete,
          [System.Management.Automation.Language.CommandAst]$CommandAst,
          [System.Collections.IDictionary]$FakeBoundParameters
        )
        # note: using namespace not effects, this executed likes background job
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

<#
.SYNOPSIS
Edit command source.
 #>
function edc {
  [CmdletBinding()]
  param(
    [ArgumentCompleter({
        [OutputType([System.Management.Automation.CompletionResult])]
        param(
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete,
          [System.Management.Automation.Language.CommandAst]$CommandAst,
          [System.Collections.IDictionary]$FakeBoundParameters
        )
        # note: using namespace not effects, this executed likes background job
        $results = @([System.Management.Automation.CompletionCompleters]::CompleteFilename($wordToComplete))
        if ($results.Length) { $results } else {
          [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
        }
      })]
    [Alias('FullName')]
    [Parameter(Position = 0, ValueFromPipelineByPropertyName)]
    [string]
    $Path,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $ExtraArgs,
    [ArgumentCompleter({
        param(
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
      })]
    [Parameter()]
    [string]
    $Editor = $env:EDITOR,
    [Parameter(ValueFromPipeline)]
    [string]
    $InputObject
  )
  if ($InputObject) {
    Write-Debug "| $Editor $Path $ExtraArgs"
    return $InputObject | & $Editor $Path $ExtraArgs
  }
  $info = Get-Command $Path -TotalCount 1 -ea Stop
  if ($info.CommandType -eq 'Alias') {
    $info = $info.ResolvedCommand
  }
  if ('Cmdlet,Configuration,Filter,Function'.Contains([string]$info.CommandType)) {
    if ($info.Module) {
      Write-Debug "$Editor $($info.Module.Path) $ExtraArgs"
      & $Editor $info.Module.Path $ExtraArgs
    }
    else {
      vw $info.Name $ExtraArgs
    }
  }
  elseif ('ExternalScript'.Contains([string]$info.CommandType)) {
    Write-Debug "$Editor $($info.Path) $ExtraArgs"
    & $Editor $info.Path $ExtraArgs
  }
  elseif ($info.CommandType -eq 'Application') {
    if (shouldEdit $info.Path) {
      Write-Debug "$Editor $($info.Path) $ExtraArgs"
      & $Editor $info.Path $ExtraArgs
    }
    else {
      Write-Warning "skip to edit binary $($info.Path)"
    }
  }
}

function shouldEdit ([string]$LiteralPath) {
  end {
    $item = Get-Item -LiteralPath $LiteralPath -Force
    $s = $item.OpenRead()
    if ($s.Length -gt 0x300000) {
      return $false # gt 3M
    }
    $buffer = [byte[]]::new(0xff)
    $Len = $s.Read($buffer, 0, 0xff)
    for ($i = 0; $i -lt $Len; $i++) {
      if (!$buffer[$i]) {
        return $false
      }
    }
    return $true
  }
  clean {
    $s.Close()
  }
}

function Invoke-Less {
  if ($MyInvocation.Statement -eq '& $pagerCommand $pagerArgs') {
    return $input | bat -plman
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

$pwshExe, $sudoExe = (Get-Command pwsh, sudo -CommandType Application -TotalCount 1 -ea Ignore).Path
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
  if ($sudoExe) {
    $ags = $extraArgs + $args
    Write-Debug "$sudoExe -- $ags"
    if ($MyInvocation.ExpectingInput) {
      $input | & $sudoExe -- $ags
    }
    else {
      & $sudoExe -- $ags
    }
  }
  else {
    $cmd, $ags = $extraArgs + $args
    Write-Debug "$cmd $ags"
    if ($MyInvocation.ExpectingInput) {
      Write-Warning 'ignored stdin'
    }
    Start-Process -FilePath $cmd -ArgumentList $ags -Verb RunAs -WorkingDirectory $PWD.Path
  }
}

function Invoke-Which {
  param(
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Name,
    [switch]
    $All
  )
  (Get-Item (Get-Command $Name -Type Application -TotalCount ($All ? 9999 : 1) -ea Stop).Path).ResolvedTarget
}
