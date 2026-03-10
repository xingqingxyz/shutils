Set-Item Function:claude, Function:codebuddy, Function:codex, Function:copilot, Function:qwen, Function:qodercli {
  # prevent . invoke variable add
  if ($MyInvocation.InvocationName -ceq '.') {
    return & $MyInvocation.MyCommand $args
  }
  $cmd = (Get-Command $MyInvocation.MyCommand.Name -Type Application -TotalCount 1 -ea Stop).Source
  [string[]]$ags = $args.ForEach{ if ($null -ne $_) { $_ } }
  if ($ags.Contains('-p')) {
    $ags += $MyInvocation.InvocationName -ceq 'codebuddy' ? '-y' : '--yolo'
    if ($MyInvocation.ExpectingInput) {
      $input | & $cmd $ags | glow
    }
    else {
      & $cmd $ags | glow
    }
    return
  }
  if ($MyInvocation.ExpectingInput) {
    $input | & $cmd $ags
  }
  else {
    & $cmd $ags
  }
}

function androidEnv {
  if (!$env:ANDROID_HOME) {
    throw 'ANDROID_HOME environment variable is not set'
  }
  $env:PATH += '', "$env:ANDROID_HOME\cmdline-tools\latest\bin", "$env:ANDROID_HOME\emulator", "$env:ANDROID_HOME\platform-tools" -join [System.IO.Path]::PathSeparator
}

function vsdev {
  Import-Module 'C:\Program Files\Microsoft Visual Studio\18\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll'
  Enter-VsDevShell 1da1aa76 -SkipAutomaticLocation -DevCmdArguments '-arch=x64 -host_arch=x64'
}

function delay {
  [CmdletBinding(DefaultParameterSetName = 'Base')]
  param (
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'Base')]
    [string]
    $Command,
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'ScriptBlock')]
    [scriptblock]
    $ScriptBlock,
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [System.Object[]]
    $ArgumentList,
    [Parameter()]
    [timespan]
    $Delay = '0:12'
  )
  $PSNativeCommandUseErrorActionPreference = $true
  Write-Debug "Sleeping $Delay"
  Start-Sleep $Delay
  $description = if ($Command) {
    $ScriptBlock = { &$Command @args }
    "$Command $ArgumentList"
  }
  else {
    "{$ScriptBlock}"
  }
  & $ScriptBlock @ArgumentList
  $status = $?
  $statusText = $status ? 'completed' : 'failed'
  $message = "PowerShell job $statusText`: $description"

  if ($IsWindows) {
    Add-Type -AssemblyName System.Windows.Forms
    $notify = [System.Windows.Forms.NotifyIcon]::new()
    $notify.BalloonTipIcon = $status ? [System.Windows.Forms.ToolTipIcon]::Info : [System.Windows.Forms.ToolTipIcon]::Warning
    $notify.BalloonTipTitle = $statusText
    $notify.BalloonTipText = $message
    $notify.Icon = [System.Drawing.SystemIcons]::Application
    $notify.Text = 'delayCheck'
    $notify.Visible = $true
    $notify.ShowBalloonTip(1000)
    $null = Register-ObjectEvent $notify -EventName BalloonTipClosed -MaxTriggerCount 1 -Action { $args[0].Dispose() }
    Start-Sleep 1 # prevent pwsh free BalloonTipIcon
  }
  elseif ($IsLinux) {
    notify-send $statusText $message
  }
  else {
    throw [System.NotImplementedException]::new()
  }
}

function icat {
  <#
  .SYNOPSIS
  Image cat using sixels protocol.
  .NOTES
  When passing data from stdin, please use `gc -AsByteStream` or byte[] directly.
   #>
  [CmdletBinding(DefaultParameterSetName = 'Path')]
  param (
    [Parameter(Position = 0, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')]
    [SupportsWildcards()]
    [string[]]
    $Path = $ExecutionContext.SessionState.Path.CurrentFileSystemLocation,
    [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Stdin')]
    [byte]
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
  if ($MyInvocation.ExpectingInput) {
    return $input | magick -density 3000 -background transparent "${Format}:-" -resize "${Size}x" -define sixel:diffuse=true @ArgumentList sixel:- 2>$null
  }
  $Path.ForEach{
    magick -density 3000 -background transparent $_ -resize "${Size}x" -define sixel:diffuse=true @ArgumentList sixel:- 2>$null
    magick identify `-- $_
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

function Search-Web {
  [CmdletBinding()]
  [Alias('sw')]
  param (
    [Parameter(Mandatory, Position = 0)]
    [ValidateSet('baidu', 'bing', 'bing-en', 'cargo', 'docker', 'dotnetapi', 'flutter', 'go', 'google', 'jsdelivr', 'jsr', 'maven', 'npm', 'nuget', 'psgallery', 'pypi', 'vcpkg')]
    [string]
    $Category,
    [Parameter(Mandatory, Position = 1)]
    [string]
    $Name
  )
  switch ($Category) {
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
  param (
    [Parameter(Mandatory, Position = 0, ParameterSetName = 'On')]
    [string]
    $HostName,
    [Parameter(ParameterSetName = 'Off')]
    [switch]
    $Off,
    [Parameter()]
    [switch]
    $NoSystem
  )
  $On = !$Off.IsPresent
  if ($On) {
    Set-EnvironmentVariable -Scope User http_proxy=http://${hostName}:1234 https_proxy=http://${hostName}:1234 all_proxy=http://${hostName}:1235
  }
  else {
    Set-EnvironmentVariable -Scope User http_proxy= https_proxy= all_proxy=
  }
  if ($NoSystem) {
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
  elseif ($Scope -ceq 'Machine' -and !(Test-Administrator)) {
    return Invoke-Sudo Set-EnvironmentVariable @PSBoundParameters
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

function Test-Administrator {
  $IsWindows ? [Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) : ((id -u) -ceq '0')
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
