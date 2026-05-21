# data dirs for GithubRelease
New-Item -ItemType Directory -Force @(
  "$env:LOCALAPPDATA\prefix\bin"
  "$env:LOCALAPPDATA\prefix\share\jar"
  1..8 | ForEach-Object { "$env:LOCALAPPDATA\prefix\share\man\man$_" }
)
# windows terminal settings
Copy-Item -LiteralPath $PSScriptRoot/data/windows-terminal-settings.json $env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json, $env:LOCALAPPDATA/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState/settings.json -Force
