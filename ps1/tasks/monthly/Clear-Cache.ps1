# Temp:
if ($IsWindows) {
  Remove-Item Temp:/* -Recurse -Force -ea Ignore
}
# package managers
switch ((Get-Command bun, pnpm, uv -CommandType Application -TotalCount 1 -ea Ignore).Name) {
  bun { bun pm cache rm -g; continue }
  pnpm { pnpm store prune; continue }
  uv { uv cache prune; continue }
}
