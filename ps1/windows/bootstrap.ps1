#Requires -PSEdition Desktop
# winget
if (-not (Get-Command winget.exe -Type Application -ea Ignore)) {
  Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
}
# intial upgrade
winget.exe upgrade -r --accept-package-agreements --accept-source-agreements
# PSGallery
Set-PSRepository PSGallery -InstallationPolicy Trusted
