#Requires -PSEdition Core
# PSModulePath
$env:PSModulePath += [System.IO.Path]::PathSeparator + "${env:SHUTILS_ROOT}/ps1/modules"
# init scripts
Get-ChildItem -LiteralPath ${env:SHUTILS_ROOT}/ps1 -File -ea Ignore | ForEach-Object { . $_.FullName }
# platform code
if ($IsWindows) {
  . ${env:SHUTILS_ROOT}/ps1/windows/profile.ps1
}
else {
  . ${env:SHUTILS_ROOT}/ps1/linux/profile.ps1
}
# aliases overrides exist commands must be explicitly set, due to module lazy
Set-Alias less Invoke-Less
Set-Alias sudo Invoke-Sudo
Set-Alias which Invoke-Which

