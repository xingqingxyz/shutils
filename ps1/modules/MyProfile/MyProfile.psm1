using namespace System.Management.Automation

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
    if ($input[0] -is [System.IO.FileInfo]) {
      return bat @input
    }
    return $input | bat -plhelp
  }
  $info = Get-Command $Command -TotalCount 1
  if ($info.CommandType -eq 'Alias') {
    $info = $info.ResolvedCommand
  }
  switch ($info.CommandType) {
    ([CommandTypes]::Cmdlet) {
      return help $Command -Category Cmdlet
    }
    ([CommandTypes]::Configuration) {
      return $Command
    }
    { ([CommandTypes]::Filter + [CommandTypes]::Function).HasFlag($_) } {
      return $info.Definition | bat -plps1
    }
    { ([CommandTypes]::Application + [CommandTypes]::Script + [CommandTypes]::ExternalScript).HasFlag($_) } {
      return bat $info.Path
    }
  }
}

function Invoke-Application {
  $environment = @{}
  for ($i = 0; $i -lt $args.Length; $i++) {
    $name, $value = $args[$i].Split('=', 2)
    if ($null -eq $value) {
      break
    }
    $environment.$name = $value
  }
  $Command = (Get-Command -Type Application -TotalCount 1 -ea Stop $args[$i]).Path
  $ArgumentList = $args[($i + 1)..($args.Length)]
  $saveEnvironment = @{}
  $environment.GetEnumerator().ForEach{
    # ignore non exist
    $saveEnvironment[$_.Key] = (Get-Item -LiteralPath Env:$($_.Key)).Value
    Set-Item -LiteralPath Env:$($_.Key) $_.Value
  }
  try {
    Write-Debug "$Command $ArgumentList"
    if ($InputObject) {
      $InputObject | & $Command @ArgumentList
    }
    else {
      & $Command @ArgumentList
    }
  }
  finally {
    foreach ($key in $environment.Keys) {
      if ($saveEnvironment.Contains($key)) {
        Set-Item -LiteralPath Env:$key $saveEnvironment.$key
      }
      else {
        Remove-Item -LiteralPath Env:$key -ea Ignore
      }
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
    ($MyInvocation.PipelineLength -ne 1) { 'npm'; break }
    (Test-Path bun.lock?) { 'bun' ; break }
    (Test-Path deno.json) { 'deno'; break }
    (Test-Path pnpm-lock.yaml) { 'pnpm'; break }
    (Test-Path yarn.lock) { 'yarn'; break }
    default { 'npm'; break }
  }
  if ((Get-Alias -Definition Invoke-Npm).Name.Contains($npm)) {
    $npm = (Get-Command $npm -Type Application, ExternalScript -TotalCount 1 -ea Stop).Path
  }
  if ($MyInvocation.PipelineLength -ne 1) {
    if ($MyInvocation.ExpectingInput) {
      $input | & $npm @args
    }
    else {
      & $npm @args
    }
    return
  }
  if ($args.Contains('--help')) {
    return & $npm @args | bat -lhelp
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
      & $npm $command @types
    }
    if ($noTypes.Length) {
      & $npm $command @noTypes
    }
    return
  }
  & $npm @args
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
    $npx = (Get-Command $npx -Type Application, ExternalScript -TotalCount 1 -ea Stop).Path
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
    [CmdletBinding()]
    param(
      [Parameter(Position = 0, Mandatory, ParameterSetName = 'ScriptBlock')]
      [scriptblock]
      $ScriptBlock,
      [Parameter(Position = 0, Mandatory, ParameterSetName = 'Command')]
      [ArgumentCompleter({
          [OutputType([System.Management.Automation.CompletionResult])]
          param (
            [string]$commandName,
            [string]$parameterName,
            [string]$wordToComplete,
            [System.Management.Automation.Language.CommandAst]$commandAst,
            [System.Collections.IDictionary]$fakeBoundParameters
          )
          [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
        })]
      [string]
      $Command,
      [Parameter(ValueFromPipeline)]
      [System.Object]
      $InputObject,
      [Parameter(Position = 1, ValueFromRemainingArguments)]
      [ArgumentCompleter({
          [OutputType([System.Management.Automation.CompletionResult])]
          param (
            [string]$commandName,
            [string]$parameterName,
            [string]$wordToComplete,
            [System.Management.Automation.Language.CommandAst]$commandAst,
            [System.Collections.IDictionary]$fakeBoundParameters
          )
          $astList = $commandAst.CommandElements | Select-Object -Skip 1 |
            Where-Object { $_ -isnot [System.Management.Automation.Language.ParameterAst] }
          $commandName = Split-Path -LeafBase $astList[0].Value
          $line = "$astList"
          $cursorPosition = $line.Length
          [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$cursorPosition)
          $cursorPosition -= $astList[0].Extent.StartOffset
          $tuple = [System.Management.Automation.CommandCompletion]::MapStringInputToParsedInput($line, $cursorPosition)
          $commandAst = $tuple.Item1.EndBlock.Statements[0].PipelineElements[0]
          & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
        })]
      [string[]]
      $ArgumentList
    )
    [string[]]$extraArgs = if ($ScriptBlock) {
      $Command = $ScriptBlock.ToString()
      @($pwshExe, '-nop', '-cwa')
    }
    else {
      $info = Get-Command $Command -TotalCount 1 -ea Ignore
      if ($info.CommandType -eq 'Alias') {
        $info = $info.ResolvedCommand
      }
      if ($null -eq $info) {
        return
      }
      elseif ($info.CommandType -eq 'Application') {
      }
      elseif (([CommandTypes]::Function + [CommandTypes]::Filter).HasFlag($info.CommandType)) {
        if ($null -eq $info.Module) {
          return
        }
        @($pwshExe, '-nop')
      }
      elseif (([CommandTypes]::Script + [CommandTypes]::ExternalScript).HasFlag($info.CommandType)) {
        @($pwshExe, '-nop')
      }
      else {
        @($pwshExe, '-nop', '-c')
      }
    }
    $ArgumentList = $extraArgs + @($Command) + $ArgumentList
    Write-Debug "$sudoExe -- $ArgumentList"
    if ($InputObject) {
      $InputObject | & $sudoExe -- @ArgumentList
    }
    else {
      & $sudoExe -- @ArgumentList
    }
  }
}
elseif ($IsWindows) {
  function Invoke-Sudo {
    [CmdletBinding()]
    param(
      [Parameter(Position = 0, Mandatory, ParameterSetName = 'ScriptBlock')]
      [scriptblock]
      $ScriptBlock,
      [Parameter(Position = 0, Mandatory, ParameterSetName = 'Command')]
      [ArgumentCompleter({
          [OutputType([System.Management.Automation.CompletionResult])]
          param (
            [string]$commandName,
            [string]$parameterName,
            [string]$wordToComplete,
            [System.Management.Automation.Language.CommandAst]$commandAst,
            [System.Collections.IDictionary]$fakeBoundParameters
          )
          [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
        })]
      [string]
      $Command,
      [Parameter(ValueFromPipeline)]
      [System.Object]
      $InputObject,
      [Parameter(Position = 1, ValueFromRemainingArguments)]
      [ArgumentCompleter({
          [OutputType([System.Management.Automation.CompletionResult])]
          param (
            [string]$commandName,
            [string]$parameterName,
            [string]$wordToComplete,
            [System.Management.Automation.Language.CommandAst]$commandAst,
            [System.Collections.IDictionary]$fakeBoundParameters
          )
          $astList = $commandAst.CommandElements | Select-Object -Skip 1 |
            Where-Object { $_ -isnot [System.Management.Automation.Language.ParameterAst] }
          $commandName = Split-Path -LeafBase $astList[0].Value
          $line = "$astList"
          $cursorPosition = $line.Length
          [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$cursorPosition)
          $cursorPosition -= $astList[0].Extent.StartOffset
          $tuple = [System.Management.Automation.CommandCompletion]::MapStringInputToParsedInput($line, $cursorPosition)
          $commandAst = $tuple.Item1.EndBlock.Statements[0].PipelineElements[0]
          & (Get-ArgumentCompleter $commandName) $wordToComplete $commandAst $cursorPosition
        })]
      [string[]]
      $ArgumentList,
      [Parameter()]
      [string]
      $WorkingDirectory = $ExecutionContext.SessionState.Path.CurrentFileSystemLocation
    )
    [string[]]$extraArgs = if ($ScriptBlock) {
      $Command = $ScriptBlock.ToString()
      @($pwshExe, '-nop', '-cwa')
    }
    else {
      $info = Get-Command $Command -TotalCount 1 -ea Ignore
      if ($info.CommandType -eq 'Alias') {
        $info = $info.ResolvedCommand
      }
      if ($null -eq $info) {
        return
      }
      elseif ($info.CommandType -eq 'Application') {
      }
      elseif (([CommandTypes]::Function + [CommandTypes]::Filter).HasFlag($info.CommandType)) {
        if ($null -eq $info.Module) {
          return
        }
        @($pwshExe, '-nop')
      }
      elseif (([CommandTypes]::Script + [CommandTypes]::ExternalScript).HasFlag($info.CommandType)) {
        @($pwshExe, '-nop')
      }
      else {
        @($pwshExe, '-nop', '-c')
      }
    }
    $Command, $ArgumentList = $extraArgs + @($Command) + $ArgumentList
    Write-Debug "$Command $ArgumentList"
    Start-Process -FilePath $Command -ArgumentList $ArgumentList -Verb RunAs -WorkingDirectory $WorkingDirectory
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
  (Get-Item (Get-Command -Type Application -All:$All $Name).Path).ResolvedTarget
}

Set-Alias ia Invoke-Application
