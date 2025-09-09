#Requires -RunAsAdministrator

# PATHEXT
if (!$env:PATHEXT.Split(';').Contains('.JAR')) {
  [System.Environment]::SetEnvironmentVariable('PATHEXT', $env:PATHEXT + ';.JAR', 'Machine')
}
# ssh default shell
New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value ([System.Environment]::ProcessPath) -PropertyType String -Force
# wsl
Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform, Microsoft-Windows-Subsystem-Linux -Online -NoRestart
# winget
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
# winget dsc
winget.exe upgrade -r --accept-package-agreements
winget.exe configure --enable
winget.exe configure --accept-package-agreements --accept-configuration-agreements -f $PSScriptRoot/../configurations/win11-apps.dsc.yml
winget.exe configure --accept-package-agreements --accept-configuration-agreements -f $PSScriptRoot/../configurations/win11-configs.dsc.yml
