function Get-TypeMember {
  [CmdletBinding()]
  param (
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        [System.Management.Automation.CompletionCompleters]::CompleteType($WordToComplete)
      })]
    [Parameter(Mandatory, ValueFromPipeline)]
    [type]
    $InputObject,
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete,
          [System.Management.Automation.Language.CommandAst]$CommandAst,
          [System.Collections.IDictionary]$FakeBoundParameters
        )
        (([type]$FakeBoundParameters.InputObject).GetMembers() | Where-Object Name -Like "$WordToComplete*").Name
      })]
    [Parameter(Position = 0)]
    [string[]]
    $Name = '*',
    [Alias('Type')]
    [Parameter()]
    [System.Reflection.MemberTypes]
    $MemberType = 'All'
  )
  process {
    $InputObject.GetMembers().Where{
      $item = $_
      $(switch ($_.MemberType) {
          Method { !$item.IsSpecialName; break }
          Constructor { $false; break }
          default { $MemberType.HasFlag($_); break }
        }) -and $_.Name -like $Name
    }.ForEach{ [Microsoft.PowerShell.Commands.MemberDefinition]::new($InputObject.FullName, $_.Name, $_.MemberType, $_.ToString()) }
  }
}

function yq {
  [CmdletBinding()]
  [OutputType([string])]
  param (
    [Parameter()]
    [string]
    $Path,
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]]
    $Query
  )
  $(if ($MyInvocation.ExpectingInput) {
      $input
    }
    else {
      Get-Content -Raw $Path
    }) | ConvertFrom-Yaml | ConvertTo-Json -Depth 99 | jq $Query
}

function tq {
  [CmdletBinding()]
  [OutputType([string])]
  param (
    [Parameter()]
    [string]
    $Path,
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]]
    $Query
  )
  $(if ($MyInvocation.ExpectingInput) {
      $input
    }
    else {
      Get-Content -Raw $Path
    }) | ConvertFrom-Toml | ConvertTo-Json -Depth 99 | jq $Query
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
  param (
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
      default {
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

function setenv {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromRemainingArguments)]
    [string[]]
    $ExtraArgs,
    [Parameter()]
    [System.EnvironmentVariableTarget]
    $Scope = 'Process'
  )
  if ($Scope -eq 'Machine' -and !(Test-Administrator)) {
    return Invoke-Sudo setenv -Scope $Scope @ExtraArgs
  }
  $Environment = @{}
  $ExtraArgs.ForEach{
    $value = "$_"
    $index = $value.IndexOf('=')
    if ($index -eq -1) {
      $key = $value
      $value = '1'
    }
    elseif ($index -and $value.IndexOf('+') -eq $index - 1) {
      $key = $value.Substring(0, $index - 1)
      $value = [System.Environment]::GetEnvironmentVariable($key) + $value.Substring($index + 1)
    }
    else {
      $key = $value.Substring(0, $index)
      $value = $value.Substring($index + 1)
    }
    if (!$key) {
      return Write-Error "use empty key to set env value: $value"
    }
    $Environment.$key = $value
  }
  $Environment.GetEnumerator().ForEach{
    if (!$_.Value) {
      Remove-Item -LiteralPath env:$($_.Key) -ea Ignore
    }
    else {
      Set-Item -LiteralPath env:$($_.Key) $_.Value
    }
  }
  if ($Scope -eq 'Process' -or !$Environment.Count) {
    return
  }
  if ($IsWindows) {
    $Environment.GetEnumerator().ForEach{
      if (!$_.Value) {
        $path = $Scope -eq 'Machine' ? 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' : 'HKCU:\Environment\'
        Write-Debug "remove $($_.Key) on $path"
        Remove-ItemProperty -LiteralPath $path $_.Key
      }
      else {
        Write-Debug "$($_.Key)=$($_.Value)"
        [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value, $Scope)
      }
    }
  }
  elseif ($IsLinux) {
    $text = $Environment.GetEnumerator().ForEach{
      "$($_.Key)='$($_.Value.Replace("'", "'\''"))'"
    } | Join-String -OutputPrefix 'export ' -Separator " \`n"
    switch ($Scope) {
      'User' {
        Set-Region UserEnv $text $(if (Test-Path ~/.bash_profile) {
            "$HOME/.bash_profile"
          }
          else {
            "$HOME/.profile"
          }) -Inplace
        break
      }
      'Machine' {
        Set-Region SysEnv $text /etc/profile.d/sh.local -Inplace
        break
      }
    }
  }
  elseif ($IsMacOS) {
    $Environment.GetEnumerator().ForEach{
      Write-Debug "$($_.Key)=$($_.Value)"
      [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value, $Scope)
    }
  }
  else {
    throw 'not implemented'
  }
}

function icat {
  [CmdletBinding(DefaultParameterSetName = 'Path')]
  param (
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

<#
.SYNOPSIS
Simple impl for surfboard localnet network proxy.
 #>
function Set-SystemProxy {
  [CmdletBinding()]
  param (
    [Parameter()]
    [switch]
    $On,
    [Parameter()]
    [ValidateRange(0, 9)]
    [int]
    $MagicDigit = 2
  )
  $hostName = '192.168.0.10' + $MagicDigit
  if ($IsWindows) {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value ([int]$On.IsPresent) -Type DWord
    if ($On) {
      Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyServer -Value ${hostName}:1234 -Type String
      Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyOverride -Value (@($env:no_proxy.Split(',').ForEach{ "https://$_" }; '<local>') -join ';') -Type String
    }
  }
  elseif ($IsLinux -and $env:XDG_CURRENT_DESKTOP.Contains('gnome')) {
    $mode = $On ? 'manual' : 'none'
    gsettings set org.gnome.system.proxy mode $mode
    if ($On -and (gsettings get org.gnome.system.proxy.http host) -ne $hostName) {
      gsettings set org.gnome.system.proxy.http host $hostName
      gsettings set org.gnome.system.proxy.http port 1234
      gsettings set org.gnome.system.proxy.https host $hostName
      gsettings set org.gnome.system.proxy.https port 1234
      gsettings set org.gnome.system.proxy.socks host $hostName
      gsettings set org.gnome.system.proxy.socks port 1235
    }
  }
  if ($On) {
    setenv -Scope User http_proxy=https://${hostName}:1234 https_proxy=https://${hostName}:1234 all_proxy=socks5://${hostName}:1235
  }
  else {
    setenv -Scope User http_proxy= https_proxy= all_proxy=
  }
}

function Set-Region {
  [CmdletBinding()]
  [OutputType([string], [void], ParameterSetName = 'Path')]
  [OutputType([string], ParameterSetName = 'Stdin')]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Name,
    [Parameter(Mandatory, Position = 1)]
    [string[]]
    $Value,
    [Parameter(Mandatory, Position = 2, ParameterSetName = 'Path')]
    [string]
    $Path,
    [Parameter(ParameterSetName = 'Path')]
    [switch]
    $Inplace,
    [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Stdin')]
    [string]
    $InputObject,
    [Parameter()]
    [string]
    $LineComment
  )
  begin {
    $lines = @()
  }
  process {
    $lines += $InputObject
  }
  end {
    if ($Path) {
      $lines = Get-Content $Path -ea Stop
    }
    $found = 0
    $newLines = $lines.ForEach{
      if (!$found -and $_.Trim() -ceq "$LineComment#region $Name") {
        $found = 1
        $_
      }
      elseif ($found -eq 1) {
        if ($_.Trim() -ceq "$LineComment#endregion") {
          $found = 2
          $Value
          $_
        }
      }
      else {
        $_
      }
    }
    if ($found -lt 2) {
      if ($found -eq 1) {
        Write-Warning 'not found #endregion mark'
      }
      $newLines = $lines + @(
        "$LineComment#region $Name"
        $Value
        "$LineComment#endregion"
      )
    }
    if ($Inplace) {
      $newLines > $Path
    }
    else {
      $newLines
    }
  }
}

function Test-Administrator {
  $IsWindows ? [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) : (id -u).Equals('0')
}

function Enable-EnvironmentFile {
  param (
    [string[]]
    $Path = '.env'
  )
  Get-Content $Path | ForEach-Object {
    $name, $value = $_.Split('=', 2)
    Set-Item -LiteralPath env:$name $value
  }
}

function getParser ([string]$Extension, [switch]$Inplace) {
  switch -CaseSensitive -Regex ($Extension.Substring(1)) {
    '^(?:c|m|mm|cpp|cc|cp|cxx|c++|h|hh|hpp|hxx|h++|inl|ipp)$' {
      if ($Inplace) {
        { clang-format -i --style=LLVM $args[0] }
      }
      else {
        { clang-format --style=LLVM $args[0] }
      }
      break
    }
    '^(?:dart)$' {
      if ($Inplace) {
        { dart format $args[0] }
      }
      else {
        { dart format -o show --show none --summary none $args[0] }
      }
      break
    }
    '^(?:cs|csx|fs|fsi|fsx|vb)$' {
      if ($Inplace) {
        { dotnet format }
      }
      else {
        { <# dotnet format; #> Get-Content -Raw -LiteralPath $args[0] }
      }
      break
    }
    '^(?:go)$' {
      if ($Inplace) {
        { gofmt -w $args[0] }
      }
      else {
        { gofmt $args[0] }
      }
      break
    }
    '^(?:java)$' {
      if ($Inplace) {
        {}
      }
      else {
        {}
      }
      break
    }
    '^(?:js|cjs|mjs|jsx|tsx|ts|cts|mts|json|jsonc|json5|yml|yaml|htm|html|xhtml|shtml|vue|gql|graphql|css|scss|sass|less|hbs|md|markdown)$' {
      if ($Inplace) {
        { pnpx prettier -w --ignore-path= $args[0] }
      }
      else {
        { pnpx prettier --ignore-path= $args[0] }
      }
      break
    }
    '^(?:ps1|psm1|psd1)$' {
      if ($Inplace) {
        { PSScriptAnalyzer\Invoke-Formatter (Get-Content -Raw -LiteralPath $args[0]) -Settings ${env:SHUTILS_ROOT}/CodeFormatting.psd1 > $args[0] }
      }
      else {
        { PSScriptAnalyzer\Invoke-Formatter (Get-Content -Raw -LiteralPath $args[0]) -Settings ${env:SHUTILS_ROOT}/CodeFormatting.psd1 }
      }
      break
    }
    '^(?:py|pyi|pyw|pyx|pxd|gyp|gypi)$' {
      if ($Inplace) {
        { ruff format -n $args[0] }
      }
      else {
        { Get-Content -Raw -LiteralPath $args[0] | ruff format -n --stdin-filename $args[0] }
      }
      break
    }
    '^(?:rs)$' {
      if ($Inplace) {
        { rustfmt $args[0] }
      }
      else {
        { rustfmt --emit stdout $args[0] }
      }
      break
    }
    '^(?:sh|bash|zsh|ash)$' {
      if ($Inplace) {
        { shfmt -i 2 -bn -ci -sr $args[0] }
      }
      else {
        { Get-Content -AsByteStream -LiteralPath $args[0] | shfmt -i 2 -bn -ci -sr --filename $args[0] }
      }
      break
    }
    '^(?:lua)$' {
      if ($Inplace) {
        { stylua $args[0] }
      }
      else {
        { Get-Content -AsByteStream -LiteralPath $args[0] | stylua }
      }
      break
    }
    '^(?:zig)$' {
      if ($Inplace) {
        {}
      }
      else {
        {}
      }
      break
    }
    default {
      Get-Content -AsByteStream -LiteralPath $args[0]
      break
    }
  }
}

function Invoke-CodeFormatter {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string[]]
    $Path
  )
  Get-Item -Force $Path | ForEach-Object {
    & (getParser $_ -Inplace) $_.FullName
  }
}

function batf {
  if ($MyInvocation.PipelinePosition -lt $MyInvocation.PipelineLength) {
    return Get-Item -Force $args | ForEach-Object {
      & (getParser $_ -Inplace) $_.FullName
    }
  }
  Get-Item -Force $args | ForEach-Object {
    & (getParser $_) $_.FullName | bat --color=always --file-name $_.Name
  } | bat
}

Set-Alias gtm Get-TypeMember
Set-Alias icf Invoke-CodeFormatter
