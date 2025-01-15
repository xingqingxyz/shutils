#Requires -Version 7.4.6
using namespace System.Management.Automation

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
  if ($MyInvocation.ExpectingInput) {
    $input | ConvertFrom-Yaml | ConvertTo-Json -Depth 100 | jq @args
  }
  else {
    ConvertFrom-Yaml | ConvertTo-Json -Depth 100 | jq @args
  }
}

function tq {
  if ($MyInvocation.ExpectingInput) {
    $input | ConvertFrom-Toml | ConvertTo-Json -Depth 100 | jq @args
  }
  else {
    ConvertFrom-Toml | ConvertTo-Json -Depth 100 | jq @args
  }
}

function packageJSON {
  $dir = Get-Item .
  $rootName = $dir.Root.Name
  while (!(Test-Path "$dir/package.json")) {
    if ($dir.Name -eq $rootName) {
      throw 'package.json not found'
    }
    $dir = $dir.Parent
  }
  Get-Content -Raw "$dir/package.json" | ConvertFrom-Json -AsHashtable
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

<#
.SYNOPSIS
Strip ANSI escape codes from input or all args text.
 #>
function stripAnsi {
  @(if ($MyInvocation.ExpectingInput) {
      $input
    }
    else {
      $args
    }) | bat --strip-ansi=always --plain
}

<#
.PARAMETER Filter
A sequence of 'Query/Key' pairs.
#>
function sortJSON {
  param(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]]$Path,
    [Parameter(Mandatory)]
    [string[]]$Filter,
    [System.Text.Encoding]$Encoding = [System.Text.Encoding]::UTF8,
    [switch]$WhatIf
  )

  Get-ChildItem $Path -File | ForEach-Object {
    $cur = $_
    $ext = switch ($cur.Extension.ToLower().Substring(1)) {
      'jsonc' { 'json'; break }
      'yml' { 'yaml'; break }
      Default { $_ }
    }
    $content = Get-Content -Raw -Encoding $Encoding $cur
    $content = switch ($ext) {
      'json' {
        $content | jq (($Filter | ForEach-Object {
              $Query, $Key = $_.Split('/', 2)
              $Key ??= '.'
              "$Query |= sort_by($Key)"
            }) -join '|empty,')
        break
      }
      'yaml' {
        $content = $content | ConvertFrom-Yaml
        Invoke-Expression ($Filter | ForEach-Object {
            $Query, $Key = $_.Split('/', 2)
            $Key ??= '.'
            "`$content$Query = `$content$Query | sort { `$_$Key } -CaseSensitive"
          } | Out-String)
        $content | ConvertTo-Yaml -Depth 100
        break
      }
      'toml' {
        $content = $content | ConvertFrom-Toml
        Invoke-Expression ($Filter | ForEach-Object {
            $Query, $Key = $_.Split('/', 2)
            $Key ??= '.'
            "`$content$Query = `$content$Query | sort { `$_$Key } -CaseSensitive"
          } | Out-String)
        $content | ConvertTo-Toml -Depth 100
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

if ($IsWindows -and (Test-Path C:\Windows\System32\sudo.exe)) {
  function sudo {
    $sudoExe = 'C:\Windows\System32\sudo.exe'
    if (!$args.Length) {
      & $sudoExe
      return
    }
    $commandLine = $MyInvocation.Line.Substring($MyInvocation.OffsetInLine + $MyInvocation.InvocationName.Length)
    $sudoOpts = @()
    $commandName = ''
    $isScriptBlock = $false
    foreach ($i in $args) {
      if ($i -is [string] -and $i.StartsWith('-')) {
        $sudoOpts += $i
        continue
      }
      $isScriptBlock = $i -is [scriptblock]
      $commandName = $i.ToString()
      break
    }
    if ($isScriptBlock) {
      $pwshExe = (Get-Process -Id $PID).Path
      $cwa = $args[$sudoOpts.Length..($args.Length - 1)]
      $cwa[0] = $commandName
      Write-Debug "$sudoExe $sudoOpts run $pwshExe -nop -nol -cwa $cwa"
      if ($MyInvocation.ExpectingInput) {
        $input | & $sudoExe @sudoOpts run $pwshExe -nop -nol -cwa @cwa
      }
      else {
        & $sudoExe @sudoOpts run $pwshExe -nop -nol -cwa @cwa
      }
    }
    elseif ($commandName -eq 'run' -or (Get-Command $commandName -Type Application -TotalCount 1 -ErrorAction Ignore)) {
      Write-Debug "$sudoExe $sudoOpts $args"
      if ($MyInvocation.ExpectingInput) {
        $input | & $sudoExe @sudoOpts @args
      }
      else {
        & $sudoExe @sudoOpts @args
      }
    }
    elseif (Get-Command $commandName -Type Cmdlet, ExternalScript -TotalCount 1 -ErrorAction Ignore) {
      $pwshExe = (Get-Process -Id $PID).Path
      $commandLine = "$($args[$sudoOpts.Length..($args.Length - 1)])"
      $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($commandLine))
      Write-Debug "$sudoExe $sudoOpts run $pwshExe -nop -nol -e $encodedCommand{$commandLine}"
      if ($MyInvocation.ExpectingInput) {
        $input | & $sudoExe @sudoOpts run $pwshExe -nop -nol -e $encodedCommand
      }
      else {
        & $sudoExe @sudoOpts run $pwshExe -nop -nol -e $encodedCommand
      }
    }
    else {
      throw "can't resolve command $commandLine $commandName $sudoOpts"
    }
  }
}
else {
  function sudo {
    $filePath = ''
    $argumentList = $null
    if (!$args.Length) {
      vh sudo -Source
      return
    }
    elseif ($args[0] -is [scriptblock]) {
      $filePath = (Get-Process -Id $PID).Path
      $argumentList = @('-nop', '-nol', '-cwa') + $args
    }
    elseif (Get-Command $args[0] -Type Application -TotalCount 1 -ErrorAction Ignore) {
      $filePath, $argumentList = $args
    }
    elseif (Get-Command $args[0] -Type Cmdlet, ExternalScript -TotalCount 1 -ErrorAction Ignore) {
      $filePath = (Get-Process -Id $PID).Path
      $argumentList = @('-nop', '-nol', '-c') + $args
    }
    else {
      throw "can't resolve command $args"
    }
    Write-Debug "$filePath $argumentList"
    Start-Process -FilePath $filePath -ArgumentList $argumentList -Verb RunAs
  }
}
