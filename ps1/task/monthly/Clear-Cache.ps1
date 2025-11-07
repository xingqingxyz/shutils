if (Get-Command pnpm -CommandType Application -TotalCount 1 -ea Ignore) {
  pnpm store prune
}
