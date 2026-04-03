using namespace System.Collections.Generic

$ErrorActionPreference = 'Stop'

#region exports
function Get-MemoryInfo {
  if ($IsWindows) {
    $os = Get-CimInstance Win32_OperatingSystem
    # Win32_OperatingSystem 中的内存单位为 KB
    $total = $os.TotalVisibleMemorySize / 1MB
    $free = $os.FreePhysicalMemory / 1MB
  }
  elseif ($IsMacOS) {
    # 总内存字节数
    [long]$totalBytes = sysctl -n hw.memsize
    # vm_stat 输出各类页数
    $vmStats = @{}
    vm_stat | ForEach-Object {
      if ($_ -cmatch '^(?<name>.+):\s+(?<count>\d+)') {
        $vmStats[$Matches.name.Trim()] = [int]$Matches.count
      }
    }
    [long]$pageSize = sysctl -n hw.pagesize
    $freeBytes = ($vmStats['Pages free'] + $vmStats['Pages inactive']) * $pageSize
    # 统一以 GB 为单位 (1MB*1024 == 1GB)
    $total = $totalBytes / 1GB
    $free = $freeBytes / 1GB
  }
  elseif ($IsLinux) {
    # /proc/meminfo 中的内存单位为 KB
    $info = @{}
    Get-Content -LiteralPath /proc/meminfo | ForEach-Object {
      if ($_ -cmatch '^(?<k>\w+):\s+(?<v>\d+)') {
        $info[$Matches.k] = [long]$Matches.v
      }
    }
    $freeKb = if ($info.ContainsKey('MemAvailable')) {
      $info.MemAvailable
    }
    else {
      $info.MemFree + $info.Buffers + $info.Cached
    }
    $total = $info.MemTotal / 1MB
    $free = $freeKb / 1MB
  }
  else {
    throw [System.NotImplementedException]::new('unsupported platform')
  }

  $used = $total - $free
  $percent = ($used / $total) * 100
  [pscustomobject]@{
    'Total(GB)' = $total
    'Used(GB)'  = $used
    'Free(GB)'  = $free
    'Used%'     = $percent
  }
}

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
    [ValidateNotNull()]
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
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Name = '*',
    [Parameter()]
    [Alias('Type')]
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

function Search-Web {
  [CmdletBinding()]
  [Alias('sw')]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateSet('archwiki', 'baidu', 'bing', 'bing-en', 'cargo', 'docker', 'dotnetapi', 'flutter', 'go', 'google', 'jsdelivr', 'jsr', 'maven', 'npm', 'nuget', 'psgallery', 'pypi', 'vcpkg')]
    [string]
    $Category,
    [Parameter(Mandatory, Position = 1)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name
  )
  switch ($Category) {
    archwiki { Start-Process "https://wiki.archlinux.org/index.php?search=$Name"; break }
    baidu { Start-Process "https://www.baidu.com/s?wd=$Name"; break }
    bing { Start-Process "https://www.bing.com/search?q=$Name"; break }
    bing-en { Start-Process "https://www.bing.com/search?ensearch=1&q=$Name"; break }
    cargo { Start-Process "https://crates.io/search?q=$Name"; break }
    docker { Start-Process "https://hub.docker.com/search?q=$Name"; break }
    dotnetapi { Start-Process "https://learn.microsoft.com/zh-cn/dotnet/api/?term=$Name"; break }
    flutter { Start-Process "https://pub-web.flutter-io.cn/packages?q=$Name"; break }
    go { Start-Process "https://pkg.go.dev/search?q=$Name"; break }
    google { Start-Process "https://www.google.com/search?q=$Name"; break }
    jsdelivr { Start-Process "https://www.jsdelivr.com/?query=$Name"; break }
    jsr { Start-Process "https://jsr.io/packages?search=$Name"; break }
    maven { Start-Process "https://central.sonatype.com/search?q=$Name"; break }
    npm { Start-Process "https://www.npmjs.com/search?q=$Name"; break }
    nuget { Start-Process "https://www.nuget.org/packages?q=$Name"; break }
    psgallery { Start-Process "https://www.powershellgallery.com/packages?q=$Name"; break }
    pypi { Start-Process "https://pypi.org/search/?q=$Name"; break }
    vcpkg { Start-Process "https://vcpkg.io/en/packages?query=$Name"; break }
  }
}

function Set-SystemProxy {
  <#
  .SYNOPSIS
  Simple impl for surfboard localnet network proxy.
   #>
  [CmdletBinding(DefaultParameterSetName = 'On')]
  [Alias('ssp')]
  param (
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'On')]
    [ValidateNotNullOrEmpty()]
    [string]
    $HostName,
    [Parameter(ParameterSetName = 'Off')]
    [switch]
    $Off,
    [Parameter()]
    [switch]
    $Local
  )
  $On = !$Off
  if ($On) {
    Set-EnvironmentVariable -Scope User http_proxy=http://${hostName}:1234 https_proxy=http://${hostName}:1234 all_proxy=http://${hostName}:1235
  }
  else {
    Set-EnvironmentVariable -Scope User http_proxy= https_proxy= all_proxy=
  }
  if ($Local) {
    return
  }
  if ($IsWindows) {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value ([int]$On) -Type DWord
    if ($On) {
      Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyServer -Value ${hostName}:1234 -Type String
      Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyOverride -Value (@($env:no_proxy.Split(',').ForEach{ "https://$_" }; '<local>') -join ';') -Type String
    }
  }
  elseif ($IsLinux -and ($env:XDG_SESSION_DESKTOP -ceq 'gnome' -or $env:XDG_SESSION_DESKTOP -ceq 'ubuntu')) {
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
}

function Test-Administrator {
  $IsWindows ? [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) : ((id -u) -ceq '0')
}

#region EnvironmentVariable
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
        Convert-Path Env:$WordToComplete*
      })]
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [SupportsWildcards()]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $ArgumentList,
    [Parameter()]
    [System.EnvironmentVariableTarget]
    $Scope = 'Process',
    [Parameter(ValueFromPipeline)]
    [System.Object]
    $InputObject
  )
  if ($MyInvocation.ExpectingInput) {
    $ArgumentList += $input
  }
  Convert-Path $ArgumentList.ForEach{ "Env:$_" } | ForEach-Object {
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
        (Get-Item Env:$wordToComplete* -ea Ignore).Name.ForEach{ "$_=" }
      })]
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $ArgumentList,
    [Parameter()]
    [System.EnvironmentVariableTarget]
    $Scope = 'Process',
    [Parameter()]
    [string]
    $RegionName = "${Scope}Env",
    [Parameter(ValueFromPipeline)]
    [System.Object]
    $InputObject
  )
  if ($MyInvocation.ExpectingInput) {
    $PSBoundParameters.ArgumentList = $ArgumentList += $input
  }
  $envMap = [Dictionary[string, string]]::new()
  foreach ($arg in $ArgumentList) {
    if ($arg -cnotmatch '^(\w+)(?:(=|\+=)(.+)?)?$') {
      return Write-Error "unknown format $arg"
    }
    $key = $Matches[1]
    $value = switch ($Matches[2]) {
      '=' { $Matches[3]; break }
      '+=' { [System.Environment]::GetEnvironmentVariable($key, $Scope) + $Matches[3]; break }
      default { [System.Environment]::GetEnvironmentVariable($key) ?? '1'; break }
    }
    $envMap[$key] = $value
    if ($IsWindows -and ($key -eq 'Path' -or $key -eq 'PSModulePath')) {
      if ($Scope -ceq 'User') {
        $value = [System.Environment]::GetEnvironmentVariable($key, 'Machine') + $value
      }
      elseif ($Scope -ceq 'Machine') {
        $value += [System.Environment]::GetEnvironmentVariable($key, 'User')
      }
    }
    Set-Item -LiteralPath Env:$key $value
  }
  Write-Debug "setting env $($envMap.GetEnumerator())"
  if ($Scope -ceq 'Process') {
    return
  }
  elseif ($Scope -ceq 'Machine' -and !(Test-Administrator)) {
    return Invoke-Sudo Set-EnvironmentVariable @PSBoundParameters
  }
  if ($IsWindows) {
    # reg faster than [Environment]
    $regPath = $Scope -ceq 'Machine' ? 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' : 'HKCU:\Environment\'
    $envMap.GetEnumerator().ForEach{
      if ($_.Value) {
        Set-ItemProperty -LiteralPath $regPath $_.Key $_.Value
      }
      else {
        Write-Debug "remove $($_.Key) on $regPath"
        Remove-ItemProperty -LiteralPath $regPath $_.Key -ea Ignore
      }
    }
  }
  elseif ($IsMacOS) {
    $envMap.GetEnumerator().ForEach{
      if ($_.Value) {
        [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value, $Scope)
      }
      else {
        throw [System.NotImplementedException]::new()
      }
    }
  }
  elseif ($IsLinux) {
    $lines = $envMap.GetEnumerator().ForEach{
      if ($_.Value) {
        "export '$($_.Key)=$($_.Value.Replace("'", "'\''"))'"
      }
    }
    switch ($Scope) {
      'User' {
        Set-Region $RegionName $lines ~/.bash_profile -Inplace
        break
      }
      'Machine' {
        Set-Region $RegionName $lines /etc/profile.d/sh.local -Inplace
        break
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
  [Alias('sevp')]
  [OutputType([string])]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $Name,
    [Parameter()]
    [System.EnvironmentVariableTarget]
    $Scope = 'Process',
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Prepend,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Append,
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Delete,
    [Parameter()]
    [switch]
    $PassThru
  )
  $value = [System.Environment]::GetEnvironmentVariable($Name, $Scope)
  $sep = [System.IO.Path]::PathSeparator
  $value = $Prepend + $value.Split($sep).Where{ $_ -and !${Delete}?.Contains($_) } + $Append | Select-Object -Unique | Join-String -Separator $sep -OutputSuffix $sep
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
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Path = '.env'
  )
  $envMap = [Dictionary[string, string]]::new()
  Convert-Path $Path | ForEach-Object {
    switch -Regex -File $_ {
      '^\s*(?:#|$)' { continue }
      '^\s*[a-z_]\w*=' {
        $key, $value = $Matches[0].Split('=', 2)
        $key = $key.TrimStart()
        $value = if ($value.StartsWith('"')) {
          if ($value -cmatch '^(?<=").*(?=(?<!\\)")') {
            $value = $Matches[0]
          }
          else {
            $value = $value.Substring(1)
            switch ($switch) {
              '^.*(?=(?<!\\)")' { $value += "`n" + $Matches[0]; break }
              default { $value += "`n" + $_; continue }
            }
          }
          $value.Replace('\"', '"')
        }
        else {
          $value.TrimEnd()
        }
        $envMap[$key] = $value
        continue
      }
      default { Write-Debug "ignore $_"; continue }
    }
    Write-Debug "sourced env file $_"
  }
  $envMap.GetEnumerator().ForEach{
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
  }
}

function Update-SessionEnvironment {
  <#
  .SYNOPSIS
  Updates environment variables from registry to current powershell session.
  #>
  if (!$IsWindows) {
    throw 'only supports windows'
  }
  $envMap = [Dictionary[string, string]]::new()
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
  $path = [System.Environment]::GetEnvironmentVariable('Path', 'User')
  $idx = $env:Path.LastIndexOf($path)
  $path = $idx -lt 0 ? '' : $env:Path.Substring($idx + $path.Length)
  $path = $env:Path.Substring(0, [System.Math]::Max(0, $env:Path.IndexOf([System.Environment]::GetEnvironmentVariable('Path', 'Machine')))) + $machinePath + ';' + $envMap['Path'] + $path
  $envMap['Path'] = $path.Split(';').Where{ $_ } | Join-String -Separator ';' -OutputSuffix ';'
  # keep common process vars (non-null only)
  $envMap['PSModulePath'] = $env:PSModulePath
  $envMap.GetEnumerator().ForEach{
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
  }
}

function Use-DevelopmentEnvironment {
  [CmdletBinding()]
  [Alias('ude')]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateSet('AndroidStudio', 'VisualStudio')]
    [string]
    $Name
  )
  switch ($Name) {
    AndroidStudio {
      if (!$env:ANDROID_HOME) {
        throw 'ANDROID_HOME not found'
      }
      $env:PATH = @(
        $env:PATH
        [System.IO.Path]::Join($env:ANDROID_HOME, 'cmdline-tools/latest/bin')
        [System.IO.Path]::Join($env:ANDROID_HOME, 'emulator')
        [System.IO.Path]::Join($env:ANDROID_HOME, 'platform-tools')
      ) -join [System.IO.Path]::PathSeparator
      break
    }
    VisualStudio {
      if ($IsWindows) {
        Import-Module 'C:\Program Files\Microsoft Visual Studio\18\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll'
        Enter-VsDevShell 1da1aa76 -SkipAutomaticLocation -DevCmdArguments '-arch=x64 -host_arch=x64'
      }
      else {
        throw [System.NotImplementedException]::new()
      }
      break
    }
  }
}
#endregion

function delay {
  $ErrorActionPreference = 'Continue'
  [timespan]$delay, $cmd, [System.Object[]]$ags = $args
  Start-Sleep $delay
  if ($MyInvocation.ExpectingInput) {
    Write-Debug "| $cmd $ags"
    $input | & $cmd @ags
  }
  else {
    Write-Debug "$cmd $ags"
    & $cmd @ags
  }
  $status = $?
  Send-Notify "$($status ? 'Completed' : "Failed($LASTEXITCODE)") PS> $cmd $ags" -Title delay -Severity ($status ? 'Information' : 'Error')
}

function icat {
  <#
  .SYNOPSIS
  Image cat using sixel / kitty protocol.
  .NOTES
  When passing data from stdin, please use `gc -Raw -AsByteStream` or byte[] directly.
   #>
  [CmdletBinding(DefaultParameterSetName = 'Path')]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')]
    [ValidateNotNullOrEmpty()]
    [SupportsWildcards()]
    [string[]]
    $Path,
    [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, ParameterSetName = 'LiteralPath')]
    [Alias('LP')]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $LiteralPath,
    [Parameter(ParameterSetName = 'Stdin')]
    [ValidateNotNullOrEmpty()]
    [string]
    $Format = 'jpg',
    [Parameter()]
    [string]
    $Size = [System.Console]::WindowHeight * 20,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $ArgumentList,
    [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Stdin')]
    [System.Object]
    $InputObject
  )
  $supportsKitty = $env:TERM -ceq 'xterm-ghostty' -or $env:TERM -ceq 'xterm-kitty'
  if ($MyInvocation.ExpectingInput) {
    if ($supportsKitty) {
      return $input | kitten icat
    }
    return $input | magick -density 3000 -background transparent "${Format}:-" -resize "${Size}x" -define sixel:diffuse=true @ArgumentList sixel:- 2>$null
  }
  if ($Path) {
    $LiteralPath = Convert-Path $Path -Force
  }
  $LiteralPath.ForEach{
    if ($supportsKitty) {
      kitten icat `-- $_
    }
    else {
      magick -density 3000 -background transparent $_ -resize "${Size}x" -define sixel:diffuse=true @ArgumentList sixel:- 2>$null
    }
    magick identify `-- $_
  }
}
#endregion
