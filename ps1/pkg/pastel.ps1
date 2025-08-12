$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

$owner = 'sharkdp'
$name = 'pastel'
$version = gh release list -R $owner/$name -L1 -q '.[].name' --json name
if ((Get-Command $name -Type Application -ea Ignore) -and
  [version](& $name -V).Split(' ', 3)[1] -ge [version]$version) {
  return Write-Warning "new version $name already installed"
}
$target = rustenv
$dir = "$name-$version-$target"
$archive = $IsWindows ? "$dir.zip": "$dir.tar.gz"
$buildDir = "${env:SHUTILS_ROOT}/build"
try {
  Push-Location
  Set-Location $buildDir
  gh release download -R $owner/$name --skip-existing -p $archive
  if ($IsWindows) {
    Expand-Archive $archive
  }
  else {
    tar -xf $archive
  }
  Set-Location $dir/$dir
  Copy-Item $name ~/.local/bin
}
finally {
  Pop-Location
}
