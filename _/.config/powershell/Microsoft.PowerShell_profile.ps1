#Requires -Version 7.5.2
& {
  # let user select dotnet tools path order while pwsh run as a dotnet tool
  $first, $second = $env:PATH.Split([System.IO.Path]::PathSeparator, 2)
  if ((Join-Path $HOME .dotnet/tools) -eq $first) {
    $env:PATH = $second
  }
  $exe = $IsWindows ? '.exe' : ''
  Set-Alias ruff ~/.vscode/extensions/charliermarsh.ruff-*/bundled/libs/bin/ruff$exe
  Set-Alias clang-format ~/.vscode/extensions/ms-vscode.cpptools-*/LLVM/bin/clang-format$exe
}
# init scripts
Get-ChildItem -LiteralPath ${env:SHUTILS_ROOT}/ps1 -File -ea Ignore | ForEach-Object { . $_.FullName }
# platform code
. ${env:SHUTILS_ROOT}/ps1/$($IsWindows ? 'windows' : 'linux')/profile.ps1
# aliases overrides exist commands must be explicitly set, due to module lazy
Set-Alias less Invoke-Less
Set-Alias npm Invoke-Npm
Set-Alias npx Invoke-Npx
Set-Alias sudo Invoke-Sudo
Set-Alias which Invoke-Which
