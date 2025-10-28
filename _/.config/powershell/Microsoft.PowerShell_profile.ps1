#Requires -Version 7.5
function Import-EnvironmentVariable {
  [CmdletBinding()]
  [Alias('ipev')]
  param (
    [Parameter(Position = 0)]
    [SupportsWildcards()]
    [string[]]
    $Path = '.env'
  )
  Get-Content -LiteralPath $Path | ForEach-Object {
    $name, $value = $_.Split('=', 2)
    [System.Environment]::SetEnvironmentVariable($name, $value)
  }
}

# $env:SHUTILS_ROOT
Import-EnvironmentVariable ~/.env
# $env:PSModulePath
$env:PSModulePath += [System.IO.Path]::PathSeparator + "$env:SHUTILS_ROOT/ps1/modules"
# platform init
if ($IsWindows) {
  . $env:SHUTILS_ROOT/ps1/windows/profile.ps1
  Set-Alias ruff ~/.vscode/extensions/charliermarsh.ruff-*/bundled/libs/bin/ruff.exe
  Set-Alias clang-format ~/.vscode/extensions/ms-vscode.cpptools-*/LLVM/bin/clang-format.exe
}
elseif ($IsLinux) {
  . $env:SHUTILS_ROOT/ps1/linux/profile.ps1
  Set-Alias ruff ~/.vscode/extensions/charliermarsh.ruff-*/bundled/libs/bin/ruff
  Set-Alias clang-format ~/.vscode/extensions/ms-vscode.cpptools-*/LLVM/bin/clang-format
}
# init scripts
Convert-Path -Force $env:SHUTILS_ROOT/ps1/*.ps1 | ForEach-Object { . $_ }
# aliases overrides exist commands must be explicitly set, due to module lazy
Set-Alias npm Invoke-Npm
Set-Alias npx Invoke-Npx
Set-Alias sudo Invoke-Sudo
