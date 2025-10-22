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
# ssh default shell
$null = New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value ([System.Environment]::ProcessPath) -PropertyType String -Force
# wsl
# Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform, Microsoft-Windows-Subsystem-Linux -Online -NoRestart
# winget
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
# winget dsc
winget.exe upgrade -r --accept-package-agreements
winget.exe configure --enable
winget.exe configure --accept-package-agreements --accept-configuration-agreements -f $env:SHUTILS_ROOT\configurations\win11-apps.dsc.yml
winget.exe configure --accept-package-agreements --accept-configuration-agreements -f $env:SHUTILS_ROOT\configurations\win11-configs.dsc.yml
