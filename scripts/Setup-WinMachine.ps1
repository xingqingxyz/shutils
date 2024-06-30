using namespace System.Security.Principal

if (![WindowsPrincipal]::new([WindowsIdentity]::GetCurrent()).IsInRole([WindowsBuiltInRole]::Administrator)) {
  return Start-Process -FilePath ([System.Environment]::ProcessPath) -ArgumentList $PSCommandPath -Verb RunAs
}

# ssh default shell
New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value ([System.Environment]::ProcessPath) -PropertyType String -Force
# winget
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
# wsl
if ($false) {
  Enable-WindowsOptionalFeature -FeatureName VirtualMachinePlatform, Microsoft-Windows-Subsystem-Linux -Online -NoRestart
}
winget.exe upgrade -r -h --accept-package-agreements
winget.exe import -i data/winget-exports.json --disable-interactivity --accept-package-agreements
winget.exe export -o data/winget-exports.json --disable-interactivity
