#Requires -RunAsAdministrator
# PATH like envs
@{
  PATHEXT = '.JAR'
}.GetEnumerator().ForEach{
  $value = @(
    [System.Environment]::GetEnvironmentVariable($_.Key, 'Machine').Split(';')
    $_.Value.Split(';')
  ) | Select-Object -Unique | Join-String -Separator ';'
  [System.Environment]::SetEnvironmentVariable($_.Key, $value, 'Machine')
}
# data dirs for GithubRelease
New-Item -ItemType Directory -Force @(
  "$env:ProgramData\prefix\bin"
  "$env:ProgramData\prefix\share\jar"
  1..8 | ForEach-Object { "$env:ProgramData\prefix\share\man\man$_" }
)
# Windows Defender Exclusions
Defender\Add-MpPreference -ExclusionPath @(
  # apps
  "${env:ProgramFiles(x86)}\Microsoft Visual Studio"
  "$env:LOCALAPPDATA\prefix\flutter"
  "$env:ProgramFiles\Android\Android Studio"
  "$HOME\.rustup\toolchains"
  $env:ANDROID_HOME
  # caches
  "$(go env GOPATH)\pkg"
  "$env:LOCALAPPDATA\Pub\Cache"
  "$HOME\.bun\install\cache"
  "$HOME\.cargo\registry\cache"
  "$HOME\.gradle\caches"
  "$HOME\.nuget\packages"
  "$HOME\p"
  (deno info --json | ConvertFrom-Json).denoDir
  go env GOCACHE
  npm c get cache
  pnpm store path
  uv cache dir
) -ExclusionProcess (Get-Command go -CommandType Application -TotalCount 1).Source
# alacritty shortcut
if (Test-Path -LiteralPath 'C:\Program Files\Alacritty\alacritty.exe') {
  $shell = New-Object -ComObject WScript.Shell
  $shortcut = $shell.CreateShortcut('C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Alacritty\Alacritty.lnk')
  $shortcut.TargetPath = 'C:\Windows\System32\conhost.exe'
  $shortcut.Arguments = 'C:\Program Files\Alacritty\alacritty.exe'
  $shortcut.IconLocation = 'C:\Program Files\Alacritty\alacritty.exe,0'
  $shortcut.WorkingDirectory = $HOME
  $shortcut.Save()
  $null = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($shell)
}
# ssh default shell
New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value ([System.Environment]::ProcessPath) -PropertyType String -Force
# wsl
Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform, Microsoft-Windows-Subsystem-Linux -Online -NoRestart
# winget
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
winget.exe upgrade -r --accept-package-agreements --accept-source-agreements
# services
# vmware
if (Test-Path -LiteralPath 'C:\Program Files (x86)\VMware\VMware Workstation\vmware.exe') {
  ('VMAuthdService', 'VMnetDHCP', 'VMUSBArbService', 'VMware NAT Service', 'VmwareAutostartService').ForEach{
    Set-Service $_ -Status Stopped -StartupType Manual
  }
}
