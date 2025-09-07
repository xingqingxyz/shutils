# envs
setenv -Scope User "SHUTILS_ROOT=$PWD" "LESSOPEN=||'${env:SHUTILS_ROOT}\scripts\lesspipe.sh' %s"
# shutils scripts
$userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
if (!";$userPath;".Contains(";${env:SHUTILS_ROOT}\scripts;")) {
  [System.Environment]::SetEnvironmentVariable('Path', ($userPath, "${env:SHUTILS_ROOT}\scripts" -join ';') , 'User')
}
# pwsh PSRepository
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
# pwsh modules
Install-Module powershell-yaml, PSToml, Pester
# pwsh scripts
Install-Script Refresh-EnvironmentVariables
# alacritty startup
$null = New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Alacritty' -Value 'C:\Program Files\Alacritty\alacritty.exe' -PropertyType String -Force
