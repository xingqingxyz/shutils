#Requires -RunAsAdministrator
using namespace System.Security.Principal

# ssh default shell
New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value ([System.Environment]::ProcessPath) -PropertyType String -Force
# winget
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
# wsl
if ($false) {
  Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform, Microsoft-Windows-Subsystem-Linux -Online -NoRestart
}
winget.exe upgrade -r --accept-package-agreements
winget.exe configure --enable
winget.exe configure --accept-package-agreements --accept-configuration-agreements -f $PSScriptRoot/../configurations/win11-apps.dsc.yml
winget.exe configure --accept-package-agreements --accept-configuration-agreements -f $PSScriptRoot/../configurations/win11-configs.dsc.yml
# DSC v2
Install-Module PSDesiredStateConfiguration
# PATHEXT
if (!$env:PATHEXT.Split(';').Contains('.JAR')) {
  [System.Environment]::SetEnvironmentVariable('PATHEXT', $env:PATHEXT + ';.JAR', 'Machine')
}
