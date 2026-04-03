[CmdletBinding()]
param (
  [Parameter(Mandatory, Position = 0)]
  [string[]]
  $Name,
  [Parameter()]
  [switch]
  $Force
)
$ErrorActionPreference = 'Stop'
$configDir = switch ($true) {
  $IsWindows { $env:APPDATA; break }
  $IsMacOS { "$HOME/Library/Application Support"; break }
  $IsLinux { "$HOME/.config"; break }
  default { throw [System.NotImplementedException]::new() }
}
$Name.ForEach{
  $name = $_.ToLowerInvariant()
  $appName = $_.Substring(0, 1).ToUpperInvariant() + $_.Substring(1)
  Copy-Item -LiteralPath $configDir/Code/User/settings.json, $configDir/Code/User/keybindings.json $configDir/$appName/User/ -Force
  if ($Force) {
    Remove-Item -LiteralPath $configDir/$appName/User/snippets, ~/.$name/extensions -Recurse -Force
  }
  $null = New-Item -ItemType SymbolicLink -Target $configDir/Code/User/snippets $configDir/$appName/User/snippets -Force
  $null = New-Item -ItemType SymbolicLink -Target $HOME/.vscode/extensions ~/.$name/extensions -Force
}
if ($IsLinux -and (Get-Command gnome-keyring -CommandType Application -TotalCount 1 -ea Ignore)) {
  node $PSScriptRoot/niri-patch-vscode.ts $name
}
