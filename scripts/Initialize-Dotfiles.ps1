[CmdletBinding()]
param (
  [Parameter()]
  [SupportsWildcards()]
  [string[]]
  $Install,
  [Parameter()]
  [SupportsWildcards()]
  [string[]]
  $Uninstall
)

$ErrorActionPreference = 'Stop'
$root = [System.IO.Path]::GetDirectoryName($PSScriptRoot)
$root = switch ($true) {
  $IsWindows { "$root\_\windows"; break }
  $IsMacOS { "$root/_/macos"; break }
  default { "$root/_"; break }
}

if ($Install) {
  Convert-Path $Install | ForEach-Object {
    $path = $_.Replace($HOME, $root)
    Copy-Item -LiteralPath $_ (New-Item $path -Force) -Force
    New-Item -ItemType SymbolicLink -Force -Target $path $_
  }
  return
}
elseif ($Uninstall) {
  Convert-Path $Uninstall | ForEach-Object {
    $path = $_.Replace($root, $HOME)
    Remove-Item -LiteralPath $_, $path -Force -ea Ignore
  }
  return
}

@(
  if ($IsWindows) {
    Repair-GitSymlinks
    Get-ChildItem -LiteralPath $root -Recurse -File -ea Ignore
  }
  elseif ($IsMacOS) {
    Get-ChildItem -LiteralPath $root -Recurse -File -Force -ea Ignore
  }
  else {
    Get-ChildItem -LiteralPath $root -Exclude windows, macos -Force -ea Ignore |
      Get-ChildItem -Recurse -File -Force -ea Ignore
  }
).ForEach{
  $path = $_.FullName.Replace($root, $HOME)
  if ((Get-Item -LiteralPath $path -Force -ea Ignore).Target -cne $_.FullName) {
    New-Item -Type SymbolicLink -Force -Target $_.FullName $path
  }
}
