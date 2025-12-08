# env
. $PSScriptRoot/Export-EnvrionmentVariable.ps1
# dotfiles
. $PSScriptRoot/dotfiles.ps1
# powershell
Set-PSRepository PSGallery -InstallationPolicy Trusted
Update-Help -UICulture en-US
# merge history files
$dir = Split-Path (Get-PSReadLineOption).HistorySavePath
Out-File -InputObject (Get-Content $dir/* | Select-Object -Unique) -LiteralPath $dir/ConsoleHost_history.txt
New-Item -ItemType HardLink -Force -Target $dir/ConsoleHost_history.txt "$dir/Visual Studio Code Host_history.txt"

if ($IsWindows) {
  sudo pwsh -nop $PSScriptRoot/Setup-WindowsMachine.ps1
  . $PSScriptRoot/Setup-WindowsUser.ps1
  . $PSScriptRoot/Setup-GitMsys.ps1
}
elseif ($IsLinux) {
  sudo pwsh -nop $PSScriptRoot/Setup-LinuxMachine.ps1
  . $PSScriptRoot/Setup-LinuxUser.ps1
  if ($env:XDG_CURRENT_DESKTOP -clike 'GNOME*' -or $env:GDMSESSION -ceq 'gnome') {
    . $PSScriptRoot/Setup-Gnome.ps1
  }
}
