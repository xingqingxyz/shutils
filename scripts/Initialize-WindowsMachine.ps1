#Requires -RunAsAdministrator
#region env
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
#endregion
# data dirs for GithubRelease
[string[]]$dirs = @(
  "$env:ProgramData\prefix\bin"
  "$env:ProgramData\prefix\share\jar"
  1..8 | ForEach-Object { "$env:ProgramData\prefix\share\man\man$_" }
)
New-Item -ItemType Directory $dirs -Force
# ssh default shell
New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value ([System.Environment]::ProcessPath) -PropertyType String -Force
# wsl
Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform, Microsoft-Windows-Subsystem-Linux -Online -NoRestart
# winget
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
winget.exe upgrade -r --accept-package-agreements --accept-source-agreements
