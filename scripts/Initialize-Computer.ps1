$ErrorActionPreference = 'Stop'
# env
. $PSScriptRoot/Export-EnvrionmentVariables.ps1
# dotfiles
. $PSScriptRoot/Initialize-Dotfiles.ps1
# tasks
. $PSScriptRoot/Initialize-Tasks.ps1
# powershell
Set-PSRepository PSGallery -InstallationPolicy Trusted
# restore project
git submodule init ./alacritty-theme
git submodule update --depth 1 ./alacritty-theme
Install-Module PSToml, Yayaml
Update-Release dotnet, uv
dotnet build -c Release
uv sync --upgrade

if ($IsWindows) {
  sudo pwsh -nop $PSScriptRoot/Initialize-WindowsMachine.ps1
  . $PSScriptRoot/Initialize-WindowsUser.ps1
  . $PSScriptRoot/Initialize-GitMsys.ps1
}
elseif ($IsLinux) {
  sudo pwsh -nop $PSScriptRoot/Initialize-LinuxMachine.ps1
  . $PSScriptRoot/Initialize-LinuxUser.ps1
  if ($env:XDG_CURRENT_DESKTOP -clike '*GNOME' -or $env:GDMSESSION -ceq 'gnome') {
    . $PSScriptRoot/Initialize-Gnome.ps1
  }
}

# merge history files
$dir = Split-Path (Get-PSReadLineOption).HistorySavePath
Out-File -InputObject (Get-Content $dir/* | Select-Object -Unique) -LiteralPath $dir/ConsoleHost_history.txt
New-Item -ItemType HardLink -Force -Target $dir/ConsoleHost_history.txt "$dir/Visual Studio Code Host_history.txt"
# update help
Update-Help -UICulture en-US -ea Ignore
# system pkgs
Update-System
