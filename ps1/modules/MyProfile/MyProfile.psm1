using namespace System.Management.Automation

function vh {
  param([string]$Command = 'vh', [switch]$Source)
  if ($MyInvocation.ExpectingInput) {
    return $input | bat -lhelp
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
  param([string[]]$Path)
  $files = @()
  $dirs = @()
  @($input; $Path) | ForEach-Object {
    if ($null -eq $_) {
      return
    }
    $item = $_ -is [string] ? (Get-Item $_) : $_
    switch ($item.GetType()) {
      ([System.IO.DirectoryInfo]) {
        $dirs += $item.FullName
        break
      }
      ([System.IO.FileInfo]) {
        $files += $item.FullName
        break
      }
    }
  }
  if ($files) {
    bat @files
  }
  if ($dirs) {
    $dirs | ForEach-Object {
      "`e[36m- ${_}`e[0m" # cyan
      fd -tf --base-directory $_
    }
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
    }) |
    bat --strip-ansi=always --plain
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

function loadEnv {
  param([string]$Path = $PWD.Path + '/.env')
  if (Test-Path $Path) {
    Get-Content $Path | ForEach-Object {
      $name, $value = $_.Split('=', 2)
      Set-Item Env:$name $value
    }
  }
}

function icat {
  [CmdletBinding(DefaultParameterSetName = 'Path')]
  param(
    [Parameter(ValueFromPipelineByPropertyName, ParameterSetName = 'Path', Position = 0)]
    [string[]]$Path = $PWD,
    [Parameter(ValueFromPipeline, ParameterSetName = 'Stdin')]
    [string]$Content,
    [Parameter()]
    [string]$Format,
    [Parameter()]
    [string]$Size = [System.Console]::WindowHeight * 20,
    [Parameter(ValueFromRemainingArguments)]
    [System.Object[]]$Remains
  )
  if ($Content) {
    $Content | magick -density 3000 -background transparent "${Format}:-" -resize "${Size}x" -define sixel:diffuse=true @Remains sixel:- 2>$null
    return
  }
  $Path | ForEach-Object {
    if ($Format) {
      $Format += ':'
    }
    Get-ChildItem $_ | ForEach-Object {
      magick -density 3000 -background transparent ($Format + $_.FullName) -resize "${Size}x" -define sixel:diffuse=true @Remains sixel:- 2>$null
      $_.FullName
    }
  }
}

function Set-Region {
  [CmdletBinding(DefaultParameterSetName = 'Path')]
  param(
    [Parameter(Mandatory, Position = 0)][string]$ID,
    [Parameter(Mandatory, Position = 1)][string[]]$Content,
    [Parameter(Mandatory, Position = 2, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')][string]$Path,
    [Parameter(ParameterSetName = 'Path')][switch]$Inplace,
    [Parameter(Mandatory, Position = 2, ValueFromPipeline, ParameterSetName = 'Source')][string[]]$Source
  )

  $found = 0
  $Source = @(if ($PSCmdlet.ParameterSetName -eq 'Path') {
      Get-Content $Path
    }
    else {
      $Source.Split("`n")
    }).ForEach{
    if ($found -eq 0 -and $_.TrimStart().StartsWith('#region ' + $ID)) {
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
    $Source += @("#region $ID", $Content, '#endregion')
  }
  if ($Inplace) {
    $Source > $Path
  }
  else {
    $Source
  }
}

function Update-Env {
  param(
    [Parameter(Mandatory)]
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
        $value = $processEnv.$key
        if (!$prevEnv.ContainsKey($key) -or $prevEnv.$key -ne $value) {
          [System.Environment]::SetEnvironmentVariable($key, $value, $Scope)
        }
      }
      break
    }
    $IsLinux {
      $Description = $Description.Replace("`n", ' ')
      $cmd = $processEnv.GetEnumerator() | ForEach-Object {
        if (!$prevEnv.ContainsKey($_.Name) -or $prevEnv.($_.Name) -ne $_.Value) {
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

function which([string]$Exe) {
  (Get-Item (Get-Command -Type Application -TotalCount 1 $Exe).Path).ResolvedTarget
}

function env {
  $envMap = @{}
  for ($i = 0; $i -lt $args.Length; $i++) {
    $name, $value = $args[$i].Split('=')
    if ($null -ne $value -and $name -match '^\w+$') {
      $envMap.Add($name, $value)
    }
    else {
      break
    }
  }
  $cmd, $ags = $args[$i], $args[($i + 1)..($args.Length)]
  $envMap.GetEnumerator().ForEach{ Set-Item env:$($_.Key) $_.Value }
  try {
    if ($MyInvocation.ExpectingInput) {
      $input | & $cmd @ags
    }
    else {
      & $cmd @ags
    }
  }
  finally {
    $envMap.Keys.ForEach{ Remove-Item env:$_ }
  }
}

function Invoke-Less {
  if ($MyInvocation.Statement -eq '& $pagerCommand $pagerArgs') {
    return $input | bat -lman
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
    if (!$args.Length) {
      return & $sudoExe
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
      $cwa = $args[$sudoOpts.Length..($args.Length - 1)]
      $cwa[0] = $commandName
      Write-Debug "$sudoExe $sudoOpts -- $pwshExe -nop -nol -cwa $cwa"
      if ($MyInvocation.ExpectingInput) {
        $input | & $sudoExe @sudoOpts -- $pwshExe -nop -nol -cwa @cwa
      }
      else {
        & $sudoExe @sudoOpts -- $pwshExe -nop -nol -cwa @cwa
      }
    }
    elseif (Get-Command $commandName -Type Application -TotalCount 1 -ea Ignore) {
      $argumentList = $args[$sudoOpts.Length..($args.Length - 1)]
      Write-Debug "$sudoExe $sudoOpts -- $argumentList"
      if ($MyInvocation.ExpectingInput) {
        $input | & $sudoExe @sudoOpts -- @argumentList
      }
      else {
        & $sudoExe @sudoOpts -- @argumentList
      }
    }
    else {
      $info = Get-Command $commandName -TotalCount 1 -ea Ignore
      switch ($info.CommandType) {
        ([CommandTypes]::Alias) {
          $args[$sudoOpts.Length] = $info.Definition
          return sudo @args
        }
        ([CommandTypes]::Cmdlet) {
          break
        }
        ([CommandTypes]::ExternalScript) {
          break
        }
        ([CommandTypes]::Function) {
          if ($info.Module -or $info.ScriptBlock.File.StartsWith([System.IO.Path]::GetFullPath($PSScriptRoot + '/../..'))) {
            break
          }
          throw "function $commandName is not found in the profile workspace"
        }
        Default {
          throw "can't resolve command $commandLine $commandName $sudoOpts"
        }
      }
      $commandLine = "$($args[$sudoOpts.Length..($args.Length - 1)])"
      $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($commandLine))
      Write-Debug "$sudoExe $sudoOpts -- $pwshExe -nop -nol -e $encodedCommand{$commandLine}"
      if ($MyInvocation.ExpectingInput) {
        $input | & $sudoExe @sudoOpts -- $pwshExe -nop -nol -e $encodedCommand
      }
      else {
        & $sudoExe @sudoOpts -- $pwshExe -nop -nol -e $encodedCommand
      }
    }
  }
}
elseif ($IsWindows) {
  function Invoke-Sudo {
    $filePath = $null
    $argumentList = $null
    if (!$args.Length) {
      return $MyInvocation.MyCommand.Definition | bat -lps1
    }
    elseif ($args[0] -isnot [scriptblock]) {
      $info = Get-Command $args[0] -TotalCount 1 -ea Ignore
      switch ($info.CommandType) {
        ([CommandTypes]::Alias) {
          $args[0] = $info.Definition
          return sudo @args
        }
        ([CommandTypes]::Application) {
          $filePath, $argumentList = $args
          break
        }
        ([CommandTypes]::Cmdlet) {
          break
        }
        ([CommandTypes]::ExternalScript) {
          break
        }
        ([CommandTypes]::Function) {
          if ($info.Module -or $info.ScriptBlock.File.StartsWith([System.IO.Path]::GetFullPath($PSScriptRoot + '/../..'))) {
            break
          }
          throw "function $commandName is not found in the profile workspace"
        }
        Default {
          throw "can't resolve command $args"
        }
      }
    }
    if ($null -eq $filePath) {
      $filePath = $pwshExe
      $argumentList = @('-nop', '-nol', '-cwa') + $args
    }
    # TODO: can't handle stdin $MyInvocation.ExpectingInput
    Write-Debug "$filePath $argumentList"
    Start-Process -FilePath $filePath -ArgumentList $argumentList -Verb RunAs -WorkingDirectory $PWD.Path
  }
}
