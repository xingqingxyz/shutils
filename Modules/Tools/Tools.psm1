using namespace System.Collections.Generic

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
    [ValidateSet('archwiki', 'baidu', 'bing', 'bing-en', 'cargo', 'docker', 'dotnetapi', 'flutter', 'go', 'google', 'jsdelivr', 'jsr', 'maven', 'npm', 'nuget', 'psgallery', 'psm1', 'pypi', 'vcpkg')]
    [string]
    $Category,
    [Parameter(Mandatory, Position = 1, ValueFromRemainingArguments)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $Name
  )
  $prefix = switch ($Category) {
    archwiki { 'https://wiki.archlinux.org/index.php?search='; break }
    baidu { 'https://www.baidu.com/s?wd='; break }
    bing { 'https://www.bing.com/search?q='; break }
    bing-en { 'https://www.bing.com/search?ensearch=1&q='; break }
    cargo { 'https://crates.io/search?q='; break }
    docker { 'https://hub.docker.com/search?q='; break }
    dotnetapi { 'https://learn.microsoft.com/zh-cn/dotnet/api/?term='; break }
    flutter { 'https://pub-web.flutter-io.cn/packages?q='; break }
    go { 'https://pkg.go.dev/search?q='; break }
    google { 'https://www.google.com/search?q='; break }
    jsdelivr { 'https://www.jsdelivr.com/?query='; break }
    jsr { 'https://jsr.io/packages?search='; break }
    maven { 'https://central.sonatype.com/search?q='; break }
    npm { 'https://www.npmjs.com/search?q='; break }
    nuget { 'https://www.nuget.org/packages?q='; break }
    psgallery { 'https://www.powershellgallery.com/packages?q='; break }
    psm1 { 'https://learn.microsoft.com/zh-cn/powershell/module/?term='; break }
    pypi { 'https://pypi.org/search/?q='; break }
    vcpkg { 'https://vcpkg.io/en/packages?query='; break }
    # no default
  }
  Start-Process "$prefix$Name"
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
  if ($Off) {
    Set-EnvironmentVariable -Scope User http_proxy https_proxy all_proxy
  }
  else {
    Set-EnvironmentVariable -Scope User http_proxy=http://${hostName}:1234 https_proxy=http://${hostName}:1234 all_proxy=http://${hostName}:1235
  }
  if ($Local) {
    return
  }
  if ($IsWindows) {
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value ([int]!$Off) -Type DWord
    if (!$Off) {
      Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyServer -Value ${hostName}:1234 -Type String
      if ($env:no_proxy) {
        Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyOverride -Value (@($env:no_proxy.Split(',').ForEach{ "https://$_" }; '<local>') -join ';') -Type String
      }
    }
  }
  elseif ($IsLinux -and ($env:XDG_SESSION_DESKTOP -ceq 'gnome' -or $env:XDG_SESSION_DESKTOP -ceq 'ubuntu')) {
    $mode = $Off ? 'none' : 'manual'
    gsettings set org.gnome.system.proxy mode $mode
    if (!$Off -and (gsettings get org.gnome.system.proxy.http host).Trim("'") -cne $hostName) {
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
  $ArgumentList.ForEach{ $_.Contains('*') ? (Convert-Path Env:$_ -ea Ignore) : $_ } | ForEach-Object {
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
        (Convert-Path Env:$WordToComplete*).ForEach{ "`"$_=" }
      })]
    [Parameter(Mandatory, Position = 0, ValueFromRemainingArguments)]
    [ValidateNotNullOrEmpty()]
    [string[]]
    $ArgumentList,
    [Parameter()]
    [System.EnvironmentVariableTarget]
    $Scope = 'Process',
    [Parameter()]
    [switch]
    $PassThru,
    [Parameter(ValueFromPipeline)]
    [System.Object]
    $InputObject
  )
  $envMap = @{}
  $ArgumentList.ForEach{
    # note: VAR= sets to '' but VAR sets to $null (delete)
    $key, $value = $_.Split('=')
    $envMap[$key] = $value
    Set-Item -LiteralPath Env:$key $value
  }
  if ($Scope -ceq 'Process') {
    if ($PassThru) {
      return $envMap
    }
    return
  }
  elseif ($Scope -ceq 'Machine' -and !(Test-Administrator)) {
    return Write-Error 'need admin permission to set machine env'
  }
  if ($IsWindows) {
    # reg faster than [Environment]
    $regPath = $Scope -ceq 'Machine' ? 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' : 'HKCU:\Environment\'
    $envMap.GetEnumerator().ForEach{
      if ($null -eq $_.Value) {
        Write-Debug "remove $($_.Key) on $regPath"
        Remove-ItemProperty -LiteralPath $regPath $_.Key
      }
      else {
        Set-ItemProperty -LiteralPath $regPath $_.Key $_.Value
      }
    }
  }
  elseif ($IsMacOS) {
    throw [System.NotImplementedException]::new()
  }
  elseif ($IsLinux) {
    $envFilePath = $Scope -ceq 'Machine' ? '/etc/environment' : "$HOME/.env"
    $savedEnvironment = $envMap
    $envMap = @{}
    Get-Content -LiteralPath $envFilePath | ForEach-Object {
      $key, $value = $_.Split('=', 2)
      $envMap[$key] = $value
    }
    $savedEnvironment.GetEnumerator().ForEach{
      if ($null -eq $_.Value) {
        $envMap.Remove($_.Key)
      }
      else {
        $envMap[$_.Key] = $_.Value
      }
    }
    $lines = $envMap.GetEnumerator().ForEach{ $_.Key + '=' + $_.Value }
    $lines > $envFilePath
  }
  else {
    throw [System.NotImplementedException]::new()
  }
  if ($PassThru) {
    $envMap
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
  $value = ($Prepend +
    [System.Environment]::GetEnvironmentVariable($Name, $Scope).Split(
      [System.IO.Path]::PathSeparator).Where{ $_ -and !${Delete}?.Contains($_) } +
    $Append | Select-Object -Unique) -join [System.IO.Path]::PathSeparator
  Set-EnvironmentVariable -Scope $Scope $Name=$value
  if ($PassThru) {
    $value
  }
}

function Update-SessionEnvironment {
  <#
  .SYNOPSIS
  Updates environment variables from registry to current powershell session.
  #>
  [CmdletBinding()]
  param (
    [Parameter()]
    [switch]
    $Force
  )
  if (!$IsWindows) {
    throw [System.NotImplementedException]::new()
  }
  $envMap = @{}
  [Microsoft.Win32.RegistryKey]$regEnv = Get-Item -LiteralPath 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\'
  $regEnv.GetValueNames().ForEach{
    $envMap[$_] = $regEnv.GetValue($_)
  }
  $machinePath = $envMap['Path']
  $machinePSMPath = $envMap['PSModulePath']
  $regEnv = Get-Item -LiteralPath 'HKCU:\Environment\'
  $regEnv.GetValueNames().ForEach{
    $envMap[$_] = $regEnv.GetValue($_)
  }
  if ($Force) {
    $envMap['Path'] = $machinePath + ';' + $envMap['Path']
    $envMap['PSModulePath'] = $machinePSMPath + ';' + $envMap['PSModulePath']
  }
  else {
    # try to find the prepended or appended paths e.g. $PSHOME or venv paths
    $path = [System.Environment]::GetEnvironmentVariable('Path', 'User')
    $idx = $env:Path.LastIndexOf($path + ';')
    $path = $idx -lt 0 ? '' : $env:Path.Substring($idx + $path.Length)
    $idx = $env:Path.IndexOf(';' + [System.Environment]::GetEnvironmentVariable('Path', 'Machine')) + 1
    $envMap['Path'] = $env:Path.Substring(0, $idx) + $machinePath + ';' + $envMap['Path'] + $path
    # keep common prosess vars
    $envMap['PSModulePath'] = $env:PSModulePath
  }
  $envMap.GetEnumerator().ForEach{
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
  }
}

function Use-DevelopmentEnvironment {
  [CmdletBinding()]
  [Alias('ude')]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateSet('AndroidStudio', 'GitBash', 'VisualStudio')]
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
    GitBash {
      if (!$IsWindows) {
        throw [System.NotImplementedException]::new()
      }
      $env:PATH = @(
        $env:PATH
        'C:\Program Files\Git\usr\bin'
        'C:\Program Files\Git\mingw64\bin'
      ) -join [System.IO.Path]::PathSeparator
      break
    }
    VisualStudio {
      if (!$IsWindows) {
        throw [System.NotImplementedException]::new()
      }
      Import-Module 'C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll'
      Enter-VsDevShell 4c1b6954 -SkipAutomaticLocation -DevCmdArguments '-arch=x64 -host_arch=x64'
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
  $onlyKitty = $env:TERM -ceq 'xterm-ghostty' -or $env:TERM -ceq 'xterm-kitty'
  if ($MyInvocation.ExpectingInput) {
    if ($onlyKitty) {
      $input | kitten icat
    }
    else {
      $input | magick -density 3000 -background transparent "${Format}:-" -resize "${Size}x" -define sixel:diffuse=true @ArgumentList sixel:- 2>$null
    }
    return
  }
  if ($Path) {
    $LiteralPath = Convert-Path $Path -Force
  }
  if ($onlyKitty) {
    kitten icat $LiteralPath
  }
  else {
    $LiteralPath.ForEach{
      magick -density 3000 -background transparent $_ -resize "${Size}x" -define sixel:diffuse=true @ArgumentList sixel:- 2>$null
      magick identify $_
    }
  }
}
#endregion
