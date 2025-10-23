function Get-TypeMember {
  [CmdletBinding()]
  [Alias('gtm')]
  [OutputType([System.Reflection.MemberInfo[]])]
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
        (([type]$FakeBoundParameters.InputObject).GetMembers() | Where-Object Name -Like $WordToComplete*).Name
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
    $InputObject.GetMembers() | Where-Object {
      $MemberType.HasFlag($_.MemberType) -and $_.Name -like $Name -and
      ($_.MemberType -cne 'Method' -or !$_.IsSpecialName)
    }
  }
}

function Set-SystemProxy {
  <#
  .SYNOPSIS
  Simple impl for surfboard localnet network proxy.
   #>
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
    [Parameter(Mandatory, Position = 2, ParameterSetName = 'LiteralPath')]
    [string]
    $LiteralPath,
    [Parameter(ParameterSetName = 'LiteralPath')]
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
    if ($LiteralPath) {
      $lines = Get-Content -LiteralPath $LiteralPath -ea Stop
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
      $newLines > $LiteralPath
    }
    else {
      $newLines
    }
  }
}

function Test-Administrator {
  $IsWindows ? [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) : ((id -u) -ceq '0')
}

function getParser ([string]$Path, [switch]$Inplace, [switch]$Stdin) {
  switch -CaseSensitive -Regex ([System.IO.Path]::GetExtension($Path).Substring(1)) {
    '^(?:c|m|mm|cpp|cc|cp|cxx|c\+\+|h|hh|hpp|hxx|h\+\+|inl|ipp)$' {
      if ($Inplace) {
        { clang-format -i --style=LLVM `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | clang-format --style=LLVM --assume-filename=$args[0] }
      }
      else {
        { clang-format --style=LLVM `-- $args[0] }
      }
      break
    }
    '^(?:dart)$' {
      if ($Inplace) {
        { dart format `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | dart format }
      }
      else {
        { dart format -o show --show none --summary none `-- $args[0] }
      }
      break
    }
    '^(?:cs|csx|fs|fsi|fsx|vb)$' {
      if ($Inplace) {
        { dotnet format }
      }
      elseif ($Stdin) {
        { $input | dotnet format }
      }
      else {
        { <# dotnet format; #> Get-Content -AsByteStream -LiteralPath $args[0] }
      }
      break
    }
    '^(?:go)$' {
      if ($Inplace) {
        { gofmt -w `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | gofmt }
      }
      else {
        { gofmt `-- $args[0] }
      }
      break
    }
    '^(?:java)$' {
      if ($Inplace) {
        {}
      }
      elseif ($Stdin) {
        { $input }
      }
      else {
        {}
      }
      break
    }
    '^(?:js|cjs|mjs|jsx|tsx|ts|cts|mts|json|jsonc|json5|yml|yaml|htm|html|xhtml|shtml|vue|gql|graphql|css|scss|sass|less|hbs|md|markdown)$' {
      if ($Inplace) {
        { prettier -w --ignore-path= `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | prettier --ignore-path= --stdin-filepath=$args[0] }
      }
      else {
        { prettier --ignore-path= `-- $args[0] }
      }
      break
    }
    '^(?:ps1|psm1|psd1)$' {
      if ($Inplace) {
        { PSScriptAnalyzer\Invoke-Formatter (Get-Content -Raw -LiteralPath $args[0]) -Settings $env:SHUTILS_ROOT/CodeFormatting.psd1 | Out-File -NoNewline $args[0] }
      }
      elseif ($Stdin) {
        { PSScriptAnalyzer\Invoke-Formatter $input -Settings $env:SHUTILS_ROOT/CodeFormatting.psd1 }
      }
      else {
        { PSScriptAnalyzer\Invoke-Formatter (Get-Content -Raw -LiteralPath $args[0]) -Settings $env:SHUTILS_ROOT/CodeFormatting.psd1 }
      }
      break
    }
    '^(?:py|pyi|pyw|pyx|pxd|gyp|gypi)$' {
      if ($Inplace) {
        { ruff format -n `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | ruff format -n --stdin-filename $args[0] }
      }
      else {
        { Get-Content -AsByteStream -LiteralPath $args[0] | ruff format -n --stdin-filename $args[0] }
      }
      break
    }
    '^(?:rs)$' {
      if ($Inplace) {
        { rustfmt `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | rustfmt --emit stdout }
      }
      else {
        { rustfmt --emit stdout `-- $args[0] }
      }
      break
    }
    '^(?:sh|bash|zsh|ash)$' {
      if ($Inplace) {
        { shfmt -i 2 -bn -ci -sr `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | shfmt -i 2 -bn -ci -sr --filename $args[0] }
      }
      else {
        { Get-Content -AsByteStream -LiteralPath $args[0] | shfmt -i 2 -bn -ci -sr --filename $args[0] }
      }
      break
    }
    '^(?:lua)$' {
      if ($Inplace) {
        { stylua `-- $args[0] }
      }
      elseif ($Stdin) {
        { $input | stylua }
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
      elseif ($Stdin) {
        { $input }
      }
      else {
        {}
      }
      break
    }
    default {
      if ($Stdin) {
        { $input }
      }
      else {
        { Get-Content -AsByteStream -LiteralPath $args[0] }
      }
      break
    }
  }
}

function Invoke-CodeFormatter {
  [CmdletBinding(DefaultParameterSetName = 'Path')]
  [Alias('icf')]
  param (
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'Path')]
    [ValidateNotNullOrEmpty()]
    [SupportsWildcards()]
    [string[]]
    $Path,
    [Parameter(Mandatory, ParameterSetName = 'LiteralPath')]
    [Alias('PSPath')]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $LiteralPath
  )
  $Path + $LiteralPath | ForEach-Object { & (getParser $_ -Inplace) $_ }
}

function batf {
  if ($MyInvocation.ExpectingInput) {
    $name = $args[0]
    if ($MyInvocation.PipelinePosition -lt $MyInvocation.PipelineLength) {
      return $input | & (getParser $name -Stdin) $name
    }
    return $input | & (getParser $name -Stdin) $name | bat -p --file-name=$name
  }
  if ($MyInvocation.PipelinePosition -lt $MyInvocation.PipelineLength) {
    return Convert-Path -Force $args | ForEach-Object { & (getParser $_) $_ }
  }
  Convert-Path -Force $args | ForEach-Object {
    & (getParser $_) $_ | bat -p --color=always --file-name=$_
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
    identify `-- $_
  }
}

function Get-EnvironmentVariable {
  [CmdletBinding()]
  [Alias('gev')]
  [OutputType([System.Collections.DictionaryEntry[]])]
  param (
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        Convert-Path env:$WordToComplete*
      })]
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]]
    $ExtraArgs,
    [Parameter()]
    [System.EnvironmentVariableTarget]
    $Scope = 'Process',
    [Parameter(ValueFromPipeline)]
    [string]
    $InputObject
  )
  if ($MyInvocation.ExpectingInput) {
    $ExtraArgs += $input
  }
  if ($Scope -eq 'Process') {
    return Get-Item $ExtraArgs.ForEach{ "env:$_" }
  }
  Convert-Path $ExtraArgs.ForEach{ "env:$_" } | ForEach-Object {
    $value = [System.Environment]::GetEnvironmentVariable($_, $Scope)
    if ($null -ne $value) {
      [System.Collections.DictionaryEntry]::new($_, $value)
    }
  }
}

function Set-EnvironmentVariable {
  [CmdletBinding()]
  [Alias('sev')]
  param (
    [ArgumentCompleter({
        param (
          [string]$CommandName,
          [string]$ParameterName,
          [string]$WordToComplete
        )
        (Get-Item env:$wordToComplete* -ea Ignore).Name.ForEach{ "$_=" }
      })]
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]]
    $ExtraArgs,
    [Parameter()]
    [System.EnvironmentVariableTarget]
    $Scope = 'Process',
    [Parameter()]
    [string]
    $RegionName = "${Scope}Env",
    [Parameter(ValueFromPipeline)]
    [string]
    $InputObject
  )
  if ($MyInvocation.ExpectingInput) {
    $PSBoundParameters.ExtraArgs = $ExtraArgs += $input
  }
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
    $environment[$key] = $value
    Set-Item -LiteralPath env:$key $value
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
        Remove-ItemProperty -LiteralPath $path $_.Key -ea Ignore
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
      else {
        throw [System.NotImplementedException]::new()
      }
    }
  }
  else {
    throw [System.NotImplementedException]::new()
  }
}

function Set-EnvironmentVariablePath {
  <#
  .SYNOPSIS
  Creates a new environment seperator seperated path based on the actual env value, then set it back.
   #>
  [CmdletBinding()]
  [OutputType([string])]
  [Alias('sevp')]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]
    $Name,
    [Parameter()]
    [System.EnvironmentVariableTarget]
    $Scope = 'Process',
    [Parameter()]
    [string[]]
    $Prepend,
    [Parameter()]
    [string[]]
    $Append,
    [Parameter()]
    [string[]]
    $Delete,
    [Parameter()]
    [switch]
    $PassThru
  )
  [string]$value = [System.Environment]::GetEnvironmentVariable($Name, $Scope)
  $value = $Prepend + $value.Split([System.IO.Path]::PathSeparator).Where{ !$Delete.Contains($_) } + $Append | Select-Object -Unique | Join-String -Separator ([System.IO.Path]::PathSeparator)
  [System.Environment]::SetEnvironmentVariable($Name, $value, $Scope)
  if ($PassThru) {
    $value
  }
}

function Import-EnvironmentVariable {
  [CmdletBinding()]
  [Alias('ipev')]
  param (
    [Parameter(Position = 0)]
    [SupportsWildcards()]
    [string[]]
    $Path = '.env'
  )
  Get-Content -LiteralPath $Path | ForEach-Object {
    $name, $value = $_.Split('=', 2)
    [System.Environment]::SetEnvironmentVariable($name, $value)
  }
}
