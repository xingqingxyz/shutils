[CmdletBinding()]
param (
  [Parameter()]
  [switch]
  $Force
)
try {
  git diff-index --quiet HEAD
}
catch {
  if (!$Force) {
    throw 'has staged changes'
  }
}
git ls-files -s | ForEach-Object {
  [int]$mode, $item = $_ -split '\s+', 4
  if ($mode -ne 120000) {
    return
  }
  $item = $item[2].TrimStart()
  try {
    $item = Get-Item -LiteralPath $item -Force
  }
  catch {
    return Write-Warning "staged symlink not found: $item"
  }
  if ($item.LinkType -cne 'SymbolicLink') {
    $target = Get-Content -Raw -LiteralPath $item
    if ($target.StartsWith('.' + [System.IO.Path]::DirectorySeparatorChar)) {
      $target = $target.Substring(2)
    }
    New-Item -ItemType SymbolicLink -Force -Target $target $item
  }
  elseif ($item.Target.StartsWith('.' + [System.IO.Path]::DirectorySeparatorChar)) {
    New-Item -ItemType SymbolicLink -Force -Target $item.Target.Substring(2) $item
  }
}
