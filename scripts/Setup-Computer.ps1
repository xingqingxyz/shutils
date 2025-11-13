# env
. $PSScriptRoot/Export-EnvrionmentVariable.ps1
# powershell
Set-PSRepository PSGallery -InstallationPolicy Trusted
# merge history files
$historyPath = (Get-PSReadLineOption).HistorySavePath
$dir = Split-Path $historyPath
$lines = Get-Content $dir/* | Select-Object -Unique
$lines > $historyPath
New-Item -ItemType HardLink -Force -Target $dir/ConsoleHost_history.txt "$(Split-Path $historyPath)/Visual Studio Code Host_history.txt"

if ($IsWindows) {
  sudo pwsh -nop $PSScriptRoot/Setup-WindowsMachine.ps1
  . $PSScriptRoot/Setup-WindowsUser.ps1
  . $PSScriptRoot/Setup-GitMsys.ps1
}
elseif ($IsLinux) {
  sudo pwsh -nop $PSScriptRoot/Setup-LinuxMachine.ps1
  . $PSScriptRoot/Setup-LinuxUser.ps1
  if ($env:XDG_CURRENT_DESKTOP.StartsWith('GNOME') -or $env:GDMSESSION -ceq 'gnome') {
    . $PSScriptRoot/Setup-Gnome.ps1
  }
}
