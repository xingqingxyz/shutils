# package manager cache
switch ((Get-Command flutter, pnpm, uv -CommandType Application -TotalCount 1 -ea Ignore).Name) {
  flutter { flutter pub cache gc -f; continue }
  pnpm { pnpm store prune; continue }
  uv { uv cache prune; continue }
}
