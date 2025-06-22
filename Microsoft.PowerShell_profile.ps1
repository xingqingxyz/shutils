#Requires -PSEdition Core
# PSModulePath
$env:PSModulePath += [System.IO.Path]::PathSeparator + "$PSScriptRoot/ps1/modules"
# shutils
Get-ChildItem -LiteralPath $PSScriptRoot/ps1 -File -ea Ignore | ForEach-Object { . $_.FullName }
# platform code
if ($IsWindows) {
  . $PSScriptRoot/ps1/windows/profile.ps1
}
else {
  . $PSScriptRoot/ps1/linux/profile.ps1
}
