#Requires -Version 7.5.2
& {
  # let user select dotnet tools path order while pwsh run as a dotnet tool
  $first, $second = $env:PATH.Split([System.IO.Path]::PathSeparator, 2)
  if ((Convert-Path -LiteralPath ~/.dotnet/tools -ea Ignore) -ceq $first) {
    $env:PATH = $second
  }
  $exe = $IsWindows ? '.exe' : ''
  Set-Alias ruff ~/.vscode/extensions/charliermarsh.ruff-*/bundled/libs/bin/ruff$exe
  Set-Alias clang-format ~/.vscode/extensions/ms-vscode.cpptools-*/LLVM/bin/clang-format$exe
}
# add scripts to PATH
if ($PSGetPath) {
  $env:PATH = @($env:PATH, $PSGetPath.AllUsersScripts, $PSGetPath.CurrentUserScripts) -join [System.IO.Path]::PathSeparator
}
# init scripts
Get-ChildItem -LiteralPath $env:SHUTILS_ROOT/ps1 -File -ea Ignore | ForEach-Object { . $_.FullName }
# platform code
. $env:SHUTILS_ROOT/ps1/$($IsWindow ? 'windows' : 'linux')/profile.ps1
# aliases overrides exist commands must be explicitly set, due to module lazy
Set-Alias npm Invoke-Npm
Set-Alias npx Invoke-Npx
Set-Alias sudo Invoke-Sudo
