#Requires -Version 7.5
if ($IsWindows) {
  Set-Alias ruff ~/.vscode/extensions/charliermarsh.ruff-*/bundled/libs/bin/ruff.exe
  Set-Alias clang-format ~/.vscode/extensions/ms-vscode.cpptools-*/LLVM/bin/clang-format.exe
}
else {
  Set-Alias ruff ~/.vscode/extensions/charliermarsh.ruff-*/bundled/libs/bin/ruff
  Set-Alias clang-format ~/.vscode/extensions/ms-vscode.cpptools-*/LLVM/bin/clang-format
}
# init scripts
Convert-Path -Force $env:SHUTILS_ROOT/ps1/*.ps1 | ForEach-Object { . $_ }
# platform code
. $env:SHUTILS_ROOT/ps1/$($IsWindows ? 'windows' : 'linux')/profile.ps1
# aliases overrides exist commands must be explicitly set, due to module lazy
Set-Alias npm Invoke-Npm
Set-Alias npx Invoke-Npx
Set-Alias sudo Invoke-Sudo
