# pnpm store
if (Get-Command pnpm -CommandType Application -TotalCount 1 -ea Ignore) {
  pnpm store prune
}
# Temp:
if ($IsWindows) {
  Remove-Item Temp:/* -Recurse -Force -ea Ignore
}
