<#
.SYNOPSIS
View command source.
 #>
function Show-Command {
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
        if ($results) { $results } else {
          [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
        }
      })]
    [Alias('Path', 'Name')]
    [Parameter(Position = 0, ValueFromPipelineByPropertyName)]
    [string]
    $FullName,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $ExtraArgs,
    [Parameter(ValueFromPipeline)]
    [string]
    $InputObject
  )
  begin {
    $lines = @()
  }
  process {
    $lines += $InputObject
  }
  end {
    if ($MyInvocation.ExpectingInput) {
      if (!$FullName) {
        return $lines | bat -plhelp $ExtraArgs
      }
      elseif ($PSBoundParameters.BoundPositionally.Contains('FullName')) {
        return $lines | bat $FullName $ExtraArgs
      }
    }
    if (!$FullName) {
      $FullName = '.'
    }
    if (Test-Path $FullName) {
      return less $FullName $ExtraArgs # use LESSOPEN to handle any path, e.g. $PWD
    }
    $info = Get-Command $FullName -TotalCount 1 -ea Ignore
    if (!$info) {
      return Write-Warning 'not found'
    }
    if ($info.CommandType -eq 'Alias') {
      $info = $info.ResolvedCommand
    }
    switch ([string]$info.CommandType) {
      Cmdlet {
        return help $info.Name -Category Cmdlet
      }
      Configuration {
        return & $info.Name
      }
      { 'Filter,Function'.Contains($_) } {
        return $info.Definition | bat -plps1 $ExtraArgs
      }
      { 'Application,ExternalScript'.Contains($_) } {
        return less $info.Path $ExtraArgs # to handle any excutable
      }
    }
  }
}

Set-Alias l Show-Command

<#
.SYNOPSIS
Edit command source.
 #>
function Edit-Command {
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
    [Alias('Path', 'Name')]
    [Parameter(Position = 0, ValueFromPipelineByPropertyName)]
    [string]
    $FullName,
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
  begin {
    $lines = @()
  }
  process {
    $lines += $InputObject
  }
  end {
    if ($MyInvocation.ExpectingInput -and (!$FullName -or
        $PSBoundParameters.BoundPositionally.Contains('FullName'))) {
      Write-Debug "| $Editor $FullName $ExtraArgs"
      return $lines | & $Editor $FullName $ExtraArgs
    }
    if (!$FullName) {
      $FullName = $MyInvocation.InvocationName
    }
    if (Test-Path $FullName) {
      return & $Editor $FullName $ExtraArgs
    }
    $info = Get-Command $FullName -TotalCount 1 -ea Ignore
    if (!$info) {
      return & $Editor $FullName $ExtraArgs # fallback, e.g. code --help
    }
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
}

Set-Alias e Edit-Command

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
    if (!$info) {
      # fallback to handle sudo options
      return & (Get-Command -Type Application -TotalCount 1 -ea Stop sudo).Path $args
    }
    if ($info.CommandType -eq 'Application') {
      $args[0] = $info.Source
    }
    elseif ($info.CommandType -eq 'ExternalScript') {
      $args[0] = $info.Source
      @($pwshExe, '-nop')
    }
    else {
      if ($info.Module) {
        $args[0] = $info.Source + '\' + $info.Name
      }
      else {
        Write-Warning "running a no module $($info.CommandType) $info"
      }
      @($pwshExe, '-nop', '-c')
    }
  }
  if ($sudoExe) {
    $ags = $extraArgs + $args
    $sudoArgs = @(if ($IsLinux) { '-E' })
    Write-Debug "$sudoExe $sudoArgs -- $ags"
    if ($MyInvocation.ExpectingInput) {
      $input | & $sudoExe $sudoArgs -- $ags
    }
    else {
      & $sudoExe $sudoArgs -- $ags
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
