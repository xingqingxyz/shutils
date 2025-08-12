$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

if ($IsWindows) {
  Write-Error 'please use winget instead'
}
$version = gh release list -R junegunn/fzf -L1 -q '.[].name' --json name
if ((Get-Command fzf -Type Application -ea Ignore) -and
  [version](fzf --version).Split(' ', 2)[0] -ge [version]$version) {
  return Write-Warning 'new version fzf already installed'
}
$os, $arch = goenv
$archive = "fzf-$version-${os}_$arch.tar.gz"
$buildDir = "${env:SHUTILS_ROOT}/build"
try {
  Set-Location $buildDir
  gh release download -R junegunn/fzf --skip-existing -p $archive
  tar -xf $archive
  Copy-Item fzf ~/.local/bin
}
finally {
  Set-Location -
}
