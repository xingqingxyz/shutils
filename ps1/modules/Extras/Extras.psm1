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
    $MagicDigit = 1
  )
  $hostName = '192.168.0.10' + $MagicDigit
  if ($IsWindows) {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value ([int]$On.IsPresent) -Type DWord
    if ($On) {
      Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyServer -Value ${hostName}:1234 -Type String
      Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyOverride -Value (@($env:no_proxy.Split(',').ForEach{ "https://$_" }; '<local>') -join ';') -Type String
    }
  }
  elseif ($IsLinux -and $env:XDG_CURRENT_DESKTOP -ceq 'GNOME') {
    $mode = $On ? 'manual' : 'none'
    gsettings set org.gnome.system.proxy mode $mode
    if ($On -and (gsettings get org.gnome.system.proxy.http host).Trim("'") -ne $hostName) {
      gsettings set org.gnome.system.proxy.http host $hostName
      gsettings set org.gnome.system.proxy.http port 1234
      gsettings set org.gnome.system.proxy.https host $hostName
      gsettings set org.gnome.system.proxy.https port 1234
      gsettings set org.gnome.system.proxy.socks host $hostName
      gsettings set org.gnome.system.proxy.socks port 1235
    }
  }
  if ($On) {
    Set-EnvironmentVariable -Scope User http_proxy=http://${hostName}:1234 https_proxy=http://${hostName}:1234 all_proxy=http://${hostName}:1235
  }
  else {
    Set-EnvironmentVariable -Scope User http_proxy= https_proxy= all_proxy=
  }
}

function Set-Region {
  [CmdletBinding()]
  [OutputType([string])]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Name,
    [Parameter(Mandatory, Position = 1)]
    [AllowNull()]
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
      $newLines = @(
        $lines
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

function getParser ([string]$Extension, [switch]$Inplace) {
  switch -CaseSensitive -Regex ($Extension.Substring(1)) {
    '^(?:c|m|mm|cpp|cc|cp|cxx|c\+\+|h|hh|hpp|hxx|h\+\+|inl|ipp)$' {
      if ($Inplace) {
        { clang-format -i --style=LLVM '--' $args[0] }
      }
      else {
        { clang-format --style=LLVM '--' $args[0] }
      }
      break
    }
    '^(?:dart)$' {
      if ($Inplace) {
        { dart format '--' $args[0] }
      }
      else {
        { dart format -o show --show none --summary none '--' $args[0] }
      }
      break
    }
    '^(?:cs|csx|fs|fsi|fsx|vb)$' {
      if ($Inplace) {
        { dotnet format }
      }
      else {
        { <# dotnet format; #> Get-Content -AsByteStream -LiteralPath $args[0] }
      }
      break
    }
    '^(?:go)$' {
      if ($Inplace) {
        { gofmt -w '--' $args[0] }
      }
      else {
        { gofmt '--' $args[0] }
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
        { pnpx prettier -w --ignore-path= '--' $args[0] }
      }
      else {
        { pnpx prettier --ignore-path= '--' $args[0] }
      }
      break
    }
    '^(?:ps1|psm1|psd1)$' {
      if ($Inplace) {
        { PSScriptAnalyzer\Invoke-Formatter (Get-Content -Raw -LiteralPath $args[0]) -Settings $env:SHUTILS_ROOT/CodeFormatting.psd1 > $args[0] }
      }
      else {
        { PSScriptAnalyzer\Invoke-Formatter (Get-Content -Raw -LiteralPath $args[0]) -Settings $env:SHUTILS_ROOT/CodeFormatting.psd1 }
      }
      break
    }
    '^(?:py|pyi|pyw|pyx|pxd|gyp|gypi)$' {
      if ($Inplace) {
        { ruff format -n '--' $args[0] }
      }
      else {
        { Get-Content -AsByteStream -LiteralPath $args[0] | ruff format -n --stdin-filename $args[0] }
      }
      break
    }
    '^(?:rs)$' {
      if ($Inplace) {
        { rustfmt '--' $args[0] }
      }
      else {
        { rustfmt --emit stdout '--' $args[0] }
      }
      break
    }
    '^(?:sh|bash|zsh|ash)$' {
      if ($Inplace) {
        { shfmt -i 2 -bn -ci -sr '--' $args[0] }
      }
      else {
        { Get-Content -AsByteStream -LiteralPath $args[0] | shfmt -i 2 -bn -ci -sr --filename $args[0] }
      }
      break
    }
    '^(?:lua)$' {
      if ($Inplace) {
        { stylua '--' $args[0] }
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
    & (getParser $_.Extension -Inplace) $_.FullName
  }
}

function batf {
  if ($MyInvocation.PipelinePosition -lt $MyInvocation.PipelineLength) {
    return Get-Item -Force $args | ForEach-Object {
      & (getParser $_.Extension) $_.FullName
    }
  }
  Get-Item -Force $args | ForEach-Object {
    & (getParser $_.Extension) $_.FullName | bat -p --color=always --file-name=$_
  } | & $env:PAGER
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
    identify '--' $_
  }
}

function Import-EnvironmentVariable {
  param (
    [string[]]
    $Path = '.env'
  )
  Get-Content $Path | ForEach-Object {
    $name, $value = $_.Split('=', 2)
    Set-Item -LiteralPath env:$name $value
  }
}

function Set-EnvironmentVariable {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]]
    $ExtraArgs,
    [Parameter()]
    [System.EnvironmentVariableTarget]
    $Scope = 'Process',
    [Parameter()]
    [string]
    $RegionName = "${Scope}Env"
  )
  if ($Scope -eq 'Machine' -and !(Test-Administrator)) {
    return Invoke-Sudo Set-EnvironmentVariable @PSBoundParameters
  }
  $environment = @{}
  foreach ($arg in $ExtraArgs) {
    if ($arg -notmatch '^(\w+)(?:(=|\+=)(.+)?)?$') {
      return Write-Error "unknown format $arg"
    }
    $key = $Matches[1]
    $value = switch ($Matches[2]) {
      '=' { $Matches[3]; break }
      '+=' { [System.Environment]::GetEnvironmentVariable($key, $Scope) + $Matches[3]; break }
      default { '1'; break }
    }
    $environment.$key = $value
    [System.Environment]::SetEnvironmentVariable($key, $value)
  }
  Write-Debug "setting env $($environment.GetEnumerator())"
  if ($Scope -eq 'Process') {
    return
  }
  if ($IsWindows) {
    $environment.GetEnumerator().ForEach{
      if ($_.Value) {
        [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value, $Scope)
      }
      else {
        $path = $Scope -eq 'Machine' ? 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' : 'HKCU:\Environment\'
        Write-Debug "remove $($_.Key) on $path"
        Remove-ItemProperty -LiteralPath $path $_.Key
      }
    }
  }
  elseif ($IsLinux) {
    $lines = $environment.GetEnumerator().Where{ $_.Value } | ForEach-Object {
      "export $($_.Key)='$($_.Value.Replace("'", "'\''"))'"
    }
    switch ($Scope) {
      'User' {
        Set-Region $RegionName $lines $(if (Test-Path ~/.bash_profile) {
            "$HOME/.bash_profile"
          }
          else {
            "$HOME/.profile"
          }) -Inplace
        break
      }
      'Machine' {
        Set-Region $RegionName $lines /etc/profile.d/sh.local -Inplace
        break
      }
    }
  }
  elseif ($IsMacOS) {
    $environment.GetEnumerator().ForEach{
      if ($_.Value) {
        [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value, $Scope)
      }
    }
  }
  else {
    throw 'not implemented'
  }
}

Set-Alias gtm Get-TypeMember
Set-Alias icf Invoke-CodeFormatter
Set-Alias senv Set-EnvironmentVariable
