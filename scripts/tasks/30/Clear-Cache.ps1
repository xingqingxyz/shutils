# Temp:
if ($IsWindows) {
  Remove-Item Temp:/* -Recurse -Force -ea Ignore
}
# package manager cache
switch ((Get-Command flutter, pnpm, uv -CommandType Application -TotalCount 1 -ea Ignore).Name) {
  flutter { flutter pub cache gc -f; continue }
  pnpm { pnpm store prune; continue }
  uv { uv cache prune; continue }
}
# remove older modules
Get-InstalledModule | Group-Object Name | Where-Object Count -GT 1 | ForEach-Object {
  $_.Group | Sort-Object -Descending { [version]$_.Version } | Select-Object -Skip 1
} | ForEach-Object { Uninstall-Module $_.Name -MaximumVersion $_.Version }
