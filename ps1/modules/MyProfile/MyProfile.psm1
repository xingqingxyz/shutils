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

function yq {
  param(
    [Parameter(ParameterSetName = 'Path')]
    [string]
    $Path,
    [Parameter(ValueFromPipeline, ParameterSetName = 'Stdin')]
    [string]
    $InputObject = (Get-Content -Raw $Path),
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]]
    $Query
  )
  ConvertFrom-Yaml -InputObject $InputObject | ConvertTo-Json -Depth 99 | jq $Query
}

function tq {
  param(
    [Parameter(ParameterSetName = 'Path')]
    [string]
    $Path,
    [Parameter(ValueFromPipeline, ParameterSetName = 'Stdin')]
    [string]
    $InputObject = (Get-Content -Raw $Path),
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]]
    $Query
  )
  ConvertFrom-Toml -InputObject $InputObject | ConvertTo-Json -Depth 99 | jq $Query
}

function packageJSON {
  $dir = Get-Item $ExecutionContext.SessionState.Path.CurrentFileSystemLocation
  $rootName = $dir.Root.Name
  while (!(Test-Path "$dir/package.json")) {
    if ($dir.Name -eq $rootName) {
      throw 'package.json not found'
    }
    $dir = $dir.Parent
  }
  Get-Content -Raw "$dir/package.json" | ConvertFrom-Json -AsHashtable
}

<#
.PARAMETER Filter
A sequence of 'Query/Key' pairs.
#>
function sortJSON {
  [CmdletBinding()]
  [OutputType([string])]
  param(
    [Parameter(Position = 0, Mandatory, ValueFromPipelineByPropertyName)]
    [string[]]
    $Path,
    [Parameter(Position = 1, Mandatory)]
    [string[]]
    $Filter,
    [Parameter()]
    [System.Text.Encoding]
    $Encoding = [System.Text.Encoding]::UTF8,
    [switch]
    $WhatIf
  )

  Get-ChildItem $Path -File | ForEach-Object {
    $cur = $_
    $ext = switch ($cur.Extension.ToLower().Substring(1)) {
      'jsonc' {
        'json'; break
      }
      'yml' {
        'yaml'; break
      }
      Default {
        $_
      }
    }
    $content = Get-Content -Raw -Encoding $Encoding $cur
    $content = switch ($ext) {
      'json' {
        $Query = ($Filter.ForEach{
            $Query, $Key = $_.Split('/', 2)
            $Key ??= '.'
            "$Query |= sort_by($Key)"
          }) -join '|empty,'
        Write-Debug "jq $Query"
        $content | jq $Query
        break
      }
      'yaml' {
        $content = $content | ConvertFrom-Yaml
        $Command = $Filter.ForEach{
          $Query, $Key = $_.Split('/', 2)
          $Key ??= '.'
          "`$content$Query = `$content$Query | Sort-Object { `$_$Key } -CaseSensitive"
        } | Out-String
        Write-Debug "sort yaml using expression: $Command"
        Invoke-Expression $Command
        $content | ConvertTo-Yaml -Depth 99
        break
      }
      'toml' {
        $content = $content | ConvertFrom-Toml
        $Command = $Filter.ForEach{
          $Query, $Key = $_.Split('/', 2)
          $Key ??= '.'
          "`$content$Query = `$content$Query | Sort-Object { `$_$Key } -CaseSensitive"
        } | Out-String
        Write-Debug "sort toml using expression: $Command"
        Invoke-Expression $Command
        $content | ConvertTo-Toml -Depth 99
        break
      }
    }
    if ($WhatIf) {
      $content | bat -l $ext
    }
    else {
      $content | Out-File -Encoding $Encoding $cur
    }
  }
}

<#
.SYNOPSIS
Strip ANSI escape codes from input or all args text.
 #>
function stripAnsi {
  ($MyInvocation.ExpectingInput ? $input : $args) |
    bat --strip-ansi=always --plain
}

function icat {
  [CmdletBinding(DefaultParameterSetName = 'Path')]
  param(
    [Parameter(Position = 0, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')]
    [string[]]
    $Path = $ExecutionContext.SessionState.Path.CurrentFileSystemLocation,
    [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Stdin')]
    [System.Object]
    $InputObject,
    [Parameter(Mandatory, ParameterSetName = 'Stdin')]
    [string]
    $Format,
    [Parameter()]
    [string]
    $Size = [System.Console]::WindowHeight * 20,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $ArgumentList
  )
  if ($InputObject) {
    if (!$IsWindows) {
      Write-Warning 'icat from stdin pipe is unsupported on unix due to pwsh pipe restrictions'
    }
    return $InputObject | magick -density 3000 -background transparent "${Format}:-" -resize "${Size}x" -define sixel:diffuse=true @ArgumentList sixel:- 2>$null
  }
  (Get-Item $Path).FullName.ForEach{
    magick -density 3000 -background transparent $_ -resize "${Size}x" -define sixel:diffuse=true @ArgumentList sixel:- 2>$null
    $_
  }
}

function Set-Region {
  [CmdletBinding()]
  [OutputType([string])]
  param(
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Name,
    [Parameter(Mandatory, Position = 1)]
    [string[]]
    $Content,
    [Parameter(Position = 2, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')]
    [string]
    $Path,
    [Parameter(ParameterSetName = 'Path')]
    [switch]
    $Inplace,
    [Parameter(ValueFromPipeline, ParameterSetName = 'Stdin')]
    [string[]]
    $InputObject = (Get-Content $Path)
  )

  $found = 0
  $InputObject = $InputObject.ForEach{
    if ($found -eq 0 -and $_.TrimStart().StartsWith('#region ' + $Name)) {
      $found = 1
      $_
      return
    }
    elseif ($found -eq 1) {
      if ($_.Trim() -eq '#endregion') {
        $found = 2
        $Content
        $_
      }
      return
    }
    $_
  }
  if ($found -eq 0) {
    $InputObject += @("#region $Name", $Content, '#endregion')
  }
  if ($Inplace) {
    try {
      $InputObject > $Path
    }
    catch {
      $InputObject
    }
  }
  else {
    $InputObject
  }
}

function Enable-Env {
  param(
    [string]
    $Path = $ExecutionContext.SessionState.Path.CurrentFileSystemLocation + '/.env'
  )
  Get-Content $Path | ForEach-Object {
    $name, $value = $_.Split('=', 2)
    Set-Item Env:$name $value
  }
}

function Update-Env {
  param(
    [Parameter(Position = 0, Mandatory)]
    [scriptblock]
    $ScriptBlock,
    [System.EnvironmentVariableTarget]
    $Scope = 'User',
    [string]
    $Description = (Get-Date).ToString()
  )
  if ($Scope -eq [System.EnvironmentVariableTarget]::Process) {
    return & $ScriptBlock
  }

  $prevEnv = [System.Environment]::GetEnvironmentVariables()
  & $ScriptBlock
  $processEnv = [System.Environment]::GetEnvironmentVariables()

  switch ($true) {
    $IsWindows {
      foreach ($key in $processEnv.Keys) {
        if ($prevEnv.$key -ne $processEnv.$key) {
          if ($key -eq 'Path') {
            Write-Information "overwriting $Scope Path by all process env updates"
            $processEnv.Path = [System.Collections.Generic.HashSet[string]]::new(
              $processEnv.Path.Split(';')).ExceptWith(
              [System.Environment]::GetEnvironmentVariable('Path', $Scope -eq 'User' ? 'Machine' : 'User').Split(';')
            ) -join ';'
          }
          [System.Environment]::SetEnvironmentVariable($key, $processEnv.$key, $Scope)
        }
      }
      break
    }
    $IsLinux {
      $Description = $Description.Replace("`n", ' ')
      $cmd = $processEnv.GetEnumerator().ForEach{
        # Cannot handle PATH change on Linux
        if ($_.Name -eq 'PATH') {
          return
        }
        if ($prevEnv.($_.Name) -ne $_.Value) {
          $_.Name + '=' + $_.Value
        }
      } | Join-String -OutputPrefix "`n`# $Description`nexport " -Separator " \`n"
      switch ($Scope) {
        ([System.EnvironmentVariableTarget]::User) {
          return Set-Region UserEnv $cmd $(if (Test-Path ~/.bash_profile) {
              "$HOME/.bash_profile"
            }
            else {
              "$HOME/.profile"
            })
        }
        ([System.EnvironmentVariableTarget]::Machine) {
          return Invoke-Sudo Set-Region SysEnv $cmd /etc/profile.d/sh.local
        }
      }
      break
    }
    Default {
      throw 'not implemented'
    }
  }
}

function Invoke-Application {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Command,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $ArgumentList,
    [Parameter()]
    [string]
    $WorkingDirectory,
    [Parameter()]
    [hashtable]
    $Environment = @{},
    [Parameter(ValueFromPipeline)]
    [System.Object]
    $InputObject
  )
  $Command = (Get-Command -Type Application -TotalCount 1 -ea Stop $Command).Path
  Push-Location -StackName 'Invoke-Application' -LiteralPath $WorkingDirectory
  $saveEnvironment = @{}
  $Environment.GetEnumerator().ForEach{
    try {
      $saveEnvironment.($_.Key) = (Get-Item -LiteralPath env:$($_.Key) -ea Stop).Value
    }
    catch { }
    Set-Item -LiteralPath env:$($_.Key) $_.Value -ea Stop
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
    Pop-Location -StackName 'Invoke-Application'
    foreach ($key in $Environment.Keys) {
      if ($saveEnvironment.Contains($key)) {
        Set-Item -LiteralPath env:$($key) $saveEnvironment.$key
      }
      else {
        Remove-Item -LiteralPath env:$key -ea Ignore
      }
    }
  }
}

function Invoke-Which([string]$Name) {
  (Get-Item (Get-Command -Type Application -TotalCount 1 $Name).Path).ResolvedTarget
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
          if (!$_completionFuncMap.Contains($commandName)) {
            try {
              . ${env:SHUTILS_ROOT}/ps1/completions/$commandName.ps1
              if (!$_completionFuncMap.Contains($commandName)) {
                throw 'not found'
              }
            }
            catch {
              return Write-Debug "no completions found for $commandName in ${env:SHUTILS_ROOT}/ps1/completions"
            }
          }
          $line = "$astList"
          $cursorPosition = $line.Length
          [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$cursorPosition)
          $cursorPosition -= $astList[0].Extent.StartOffset
          $tuple = [System.Management.Automation.CommandCompletion]::MapStringInputToParsedInput($line, $cursorPosition)
          $commandAst = $tuple.Item1.EndBlock.Statements[0].PipelineElements[0]
          & $_completionFuncMap.$commandName $wordToComplete $commandAst $cursorPosition
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
          if (!$_completionFuncMap.Contains($commandName)) {
            try {
              . ${env:SHUTILS_ROOT}/ps1/completions/$commandName.ps1
              if (!$_completionFuncMap.Contains($commandName)) {
                throw 'not found'
              }
            }
            catch {
              return Write-Debug "no completions found for $commandName in ${env:SHUTILS_ROOT}/ps1/completions"
            }
          }
          $line = "$astList"
          $cursorPosition = $line.Length
          [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$cursorPosition)
          $cursorPosition -= $astList[0].Extent.StartOffset
          $tuple = [System.Management.Automation.CommandCompletion]::MapStringInputToParsedInput($line, $cursorPosition)
          $commandAst = $tuple.Item1.EndBlock.Statements[0].PipelineElements[0]
          & $_completionFuncMap.$commandName $wordToComplete $commandAst $cursorPosition
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

Set-Alias ia Invoke-Application
