#Requires -PSEdition Core
# let user select dotnet tools path order while pwsh run as a dotnet tool
$env:PATH = $env:PATH.Replace("$HOME/.dotnet/tools$([System.IO.Path]::PathSeparator)", '')
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
Set-Alias npm Invoke-Npm
Set-Alias npx Invoke-Npx
Set-Alias sudo Invoke-Sudo
Set-Alias which Invoke-Which
$exe = $IsWindows ? '.exe' : ''
Set-Alias ruff ~/.vscode/extensions/charliermarsh.ruff-*/bundled/libs/bin/ruff$exe
Set-Alias clang-format ~/.vscode/extensions/ms-vscode.cpptools-*/LLVM/bin/clang-format$exe
Remove-Variable exe
