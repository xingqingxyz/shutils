# env
. $PSScriptRoot/Export-EnvrionmentVariables.ps1
# dotfiles
. $PSScriptRoot/Initialize-Dotfiles.ps1
# tasks
. $PSScriptRoot/Initialize-Tasks.ps1

if ($IsWindows) {
  sudo pwsh -nop $PSScriptRoot/Initialize-WindowsMachine.ps1
  . $PSScriptRoot/Initialize-WindowsUser.ps1
  . $PSScriptRoot/Initialize-GitMsys.ps1 -All
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
New-Item -ItemType SymbolicLink -Force -Target ConsoleHost_history.txt "$dir/Visual Studio Code Host_history.txt"
# update help
Update-Help -UICulture en-US -ea Ignore
#region gpg
# gnu
Invoke-RestMethod 'https://mirrors.ustc.edu.cn/gnu/gnu-keyring.gpg' -OutFile Temp:/gnu-keyring.gpg
gpg --import (Convert-Path Temp:/gnu-keyring.gpg)
# oven-sh/bun
gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys F3DCC08A8572C0749B3E18888EAB4D40A7B22B59
# plantuml/plantuml
gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys 019586D44BD80213
# xingqingxyz
gpg --import $PSScriptRoot/data/pubkey.asc
#endregion
# system pkgs
Set-PSRepository PSGallery -InstallationPolicy Trusted
Install-Module PSToml, Yayaml
Update-System -Force
# build
. $PSScriptRoot/../make.ps1 -Init
