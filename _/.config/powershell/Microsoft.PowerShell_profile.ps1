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

# platform init
if ($IsWindows) {
  . $env:SHUTILS_ROOT/ps1/windows/profile.ps1
}
elseif ($IsLinux) {
  # $env:SHUTILS_ROOT
  Import-EnvironmentVariable ~/.env
  . $env:SHUTILS_ROOT/ps1/linux/profile.ps1
}
# init scripts
Convert-Path -Force $env:SHUTILS_ROOT/ps1/*.ps1 | ForEach-Object { . $_ }
# aliases overrides exist commands must be explicitly set, due to module lazy
Set-Alias npm Invoke-Npm
Set-Alias npx Invoke-Npx
Set-Alias sudo Invoke-Sudo
