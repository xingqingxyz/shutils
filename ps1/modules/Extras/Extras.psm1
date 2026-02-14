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
    $InputObject.GetMembers().Where{
      $MemberType.HasFlag($_.MemberType) -and $_.Name -like $Name -and
      ($_.MemberType -cne 'Method' -or !$_.IsSpecialName)
    }
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
    [AllowEmptyCollection()]
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
    [string[]]$lines = @()
  }
  process {
    $lines += $InputObject
  }
  end {
    if ($LiteralPath) {
      $lines = (Get-Content -LiteralPath $LiteralPath -ea Ignore) ?? ''
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

function Get-EnvironmentVariable {
  [CmdletBinding()]
  [Alias('gev')]
  [OutputType([string[]])]
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
  Convert-Path $ExtraArgs.ForEach{ "env:$_" } | ForEach-Object {
    [System.Environment]::GetEnvironmentVariable($_, $Scope)
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
  if ($Scope -ceq 'Machine' -and !(Test-Administrator)) {
    return Invoke-Sudo Set-EnvironmentVariable @PSBoundParameters
  }
  $environment = @{}
  foreach ($arg in $ExtraArgs) {
    if ($arg -cnotmatch '^(\w+)(?:(=|\+=)(.+)?)?$') {
      return Write-Error "unknown format $arg"
    }
    $key = $Matches[1]
    $value = switch ($Matches[2]) {
      '=' { $Matches[3]; break }
      '+=' { [System.Environment]::GetEnvironmentVariable($key, $Scope) + $Matches[3]; break }
      default { [System.Environment]::GetEnvironmentVariable($key) ?? '1'; break }
    }
    $environment[$key] = $value
    if ($IsWindows) {
      if ($Scope -ceq 'User') {
        $value = [System.Environment]::GetEnvironmentVariable($key, 'Machine') + $value
      }
      elseif ($Scope -ceq 'Machine') {
        $value += [System.Environment]::GetEnvironmentVariable($key, 'User')
      }
    }
    Set-Item -LiteralPath env:$key $value
  }
  Write-Debug "setting env $($environment.GetEnumerator())"
  if ($Scope -ceq 'Process') {
    return
  }
  if ($IsWindows) {
    # reg faster than [Environment]
    $regPath = $Scope -ceq 'Machine' ? 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' : 'HKCU:\Environment\'
    $environment.GetEnumerator().ForEach{
      if ($_.Value) {
        Set-ItemProperty -LiteralPath $regPath $_.Key $_.Value
      }
      else {
        Write-Debug "remove $($_.Key) on $regPath"
        Remove-ItemProperty -LiteralPath $regPath $_.Key -ea Ignore
      }
    }
  }
  elseif ($IsLinux) {
    $lines = $environment.GetEnumerator().ForEach{
      if ($_.Value) {
        "export $($_.Key)='$($_.Value.Replace("'", "'\''"))'"
      }
    }
    switch ($Scope) {
      'User' {
        Set-Region $RegionName $lines ~/.bashrc -Inplace
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
    $Delete = @(),
    [Parameter()]
    [switch]
    $PassThru
  )
  [string]$value = [System.Environment]::GetEnvironmentVariable($Name, $Scope)
  [string]$sep = [System.IO.Path]::PathSeparator
  $value = $Prepend + $value.Split($sep).Where{ $_ -and !$Delete.Contains($_) } + $Append | Select-Object -Unique | Join-String -Separator $sep -OutputSuffix $sep
  [System.Environment]::SetEnvironmentVariable($Name, $value, $Scope)
  if ($PassThru) {
    $value
  }
}

Set-Alias uev Use-EnvironmentVariable
function Use-EnvironmentVariable {
  $environment = @{}
  [regex]$reEnv = [regex]::new('^\w+\+?=')
  # flat iterator args for native passing
  # note: replace token -- with `-- to escape function passing
  [string[]]$ags = foreach ($arg in [string[]]$args.ForEach{
      if ($null -ne $_) {
        $_
      }
    }) {
    if (!$reEnv.IsMatch($arg)) {
      $arg
      $foreach
      break
    }
    [string]$key, [string]$value = $arg.Split('=', 2)
    if ($key.EndsWith('+')) {
      $key = $key.TrimEnd('+')
      $value = [System.Environment]::GetEnvironmentVariable($key) + $value
    }
    $environment[$key] = $value
  }
  $ags[0] = (Get-Command $ags[0] -Type Application -TotalCount 1 -ea Stop).Source
  $saveEnvironment = @{}
  $environment.GetEnumerator().ForEach{
    $saveEnvironment[$_.Key] = [System.Environment]::GetEnvironmentVariable($_.Key)
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
  }
  try {
    [string]$cmd, $ags = $ags
    Write-CommandDebug -Environment $environment.GetEnumerator() $cmd $ags
    if ($MyInvocation.ExpectingInput) {
      $input | & $cmd $ags
    }
    else {
      & $cmd $ags
    }
  }
  finally {
    $saveEnvironment.GetEnumerator().ForEach{
      Set-Item -LiteralPath env:$($_.Key) $_.Value
    }
  }
}

function Update-SessionEnvironment {
  <#
  .SYNOPSIS
  Updates environment variables from registry to current powershell session.
  #>
  if (!$IsWindows) {
    throw [System.SystemException]::new('only supports windows')
  }
  $envMap = @{}
  [Microsoft.Win32.RegistryKey]$reg = Get-Item -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\'
  $reg.GetValueNames().ForEach{
    $envMap[$_] = $reg.GetValue($_)
  }
  $machinePath = $envMap['Path']
  $reg = Get-Item -LiteralPath 'HKCU:\Environment\'
  $reg.GetValueNames().ForEach{
    $envMap[$_] = $reg.GetValue($_)
  }
  # try to find the prepended or appended paths e.g. $PSHOME or venv paths
  [string]$path = [System.Environment]::GetEnvironmentVariable('Path', 'User')
  [int]$idx = $env:Path.LastIndexOf($path)
  $path = $idx -lt 0 ? '' : $env:Path.Substring($idx + $path.Length)
  $path = $env:Path.Substring(0, [System.Math]::Max(0, $env:Path.IndexOf([System.Environment]::GetEnvironmentVariable('Path', 'Machine')))) + $machinePath + ';' + $envMap['Path'] + $path
  $envMap['Path'] = $path.Split(';').Where{ $_ } | Join-String -Separator ';' -OutputSuffix ';'
  # keep common process vars (non-null only)
  $envMap['PSModulePath'] = $env:PSModulePath
  $envMap.GetEnumerator().ForEach{
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
  }
}

function Repair-GitSymlinks {
  git ls-files -s | ForEach-Object {
    [int]$mode, $item = $_ -split '\s+', 4
    if ($mode -ne 120000) {
      return
    }
    $item = $item[2].TrimStart()
    try {
      $item = Get-Item -LiteralPath $item -Force -ea Stop
    }
    catch {
      return Write-Warning "staged symlink not found: $item"
    }
    if ($item.LinkType -cne 'SymbolicLink') {
      $target = Get-Content -Raw -LiteralPath $item
      if ($target.StartsWith('.' + [System.IO.Path]::DirectorySeparatorChar)) {
        $target = $target.Substring(2)
      }
      New-Item -ItemType SymbolicLink -Force -Target $target $item
    }
    elseif ($item.Target.StartsWith('.' + [System.IO.Path]::DirectorySeparatorChar)) {
      New-Item -ItemType SymbolicLink -Force -Target $item.Target.Substring(2) $item
    }
  }
}

function ConvertTo-RelativeSymlink {
  <#
.SYNOPSIS
Make absolute links to relative symbolic links, returns created link info.
 #>
  [CmdletBinding()]
  [OutputType([System.IO.FileInfo[]])]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string[]]
    $Path
  )
  Get-Item $Path -Force -ea Ignore | ForEach-Object {
    if ($_.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint) -and [System.IO.Path]::IsPathRooted($_.Target)) {
      New-Item -Type SymbolicLink -Target ([System.IO.Path]::GetRelativePath($_.DirectoryName, $_.Target)) $_.FullName -Force
    }
  }
}
