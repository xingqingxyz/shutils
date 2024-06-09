# winget
if (-not (Get-Command winget.exe -CommandType Application -ErrorAction Ignore)) {
  Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
}
# intial upgrade
winget.exe upgrade -r --accept-package-agreements --accept-source-agreements
# PSGallery
Set-PSRepository PSGallery -InstallationPolicy Trusted
# import winget module
Install-Module Microsoft.WinGet.Client
Import-Module Microsoft.WinGet.Client
Assert-WinGetPackageManager
# modify winget settings
Set-WinGetUserSettings -UserSettings $settings
# install winget packages parallel
$pkgs = ConvertFrom-Json $file
$pkgs | ForEach-Object -ThrottleLimit $env:PROCESSOR_LEVEL -Parallel {
  Install-WinGetPackage -Mode Silent $_
}
