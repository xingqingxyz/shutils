# shutils scripts
$userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
if (!";$userPath;".Contains(";$env:SHUTILS_ROOT\scripts;")) {
  [System.Environment]::SetEnvironmentVariable('Path', ($userPath, "$env:SHUTILS_ROOT\scripts" -join ';') , 'User')
}
# pwsh PSRepository
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
# pwsh modules
Install-Module powershell-yaml, PSToml, Pester
# pwsh scripts
Install-Script Refresh-EnvironmentVariables
# alacritty startup
$null = New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Alacritty' -Value 'C:\Program Files\Alacritty\alacritty.exe' -PropertyType String -Force

function Set-DarkMode ([switch]$On) {
  Set-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -Value (1 - $On.IsPresent) -Type DWord
  Set-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value (1 - $On.IsPresent) -Type DWord
  Stop-Process explorer
}
