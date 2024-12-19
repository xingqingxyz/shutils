#requires -Version 7.4
using namespace System
using namespace System.Runtime.InteropServices

# template: https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-pc-windows-msvc.zip

$downloadFile = "$name-$tag-$arch-$platform-$compiler.$ext"

function uname {
  @{
    arch     = [RuntimeInformation]::OSArchitecture
    platform = [Environment]::OSVersion.Platform
  }
}

$collection = @{
  'fd'      = @{
    repo          = 'sharkdp/fd'
    name          = 'fd'
    type          = 'archive'
    nested        = $true
    arch          = '{rust}'
    platform      = '{rust}'
    format        = '{name}-{tag}-{arch}-{platform}-{compiler}.{ext}'
    files         = @(
      'bin/fd',
      'autocomplete/fd'
    )
    windows_files = @(
      'bin/fd.exe',
      'autocomplete/fd.ps1'
    )
  }
  'ripgrep' = @{
    repo          = 'BurntSushi/ripgrep'
    name          = 'ripgrep'
    nested        = $true
    type          = 'archive'
    arch          = '{rust}'
    platform      = '{rust}'
    format        = '{name}-{tag}-{arch}-{platform}-{compiler}.{ext}'
    files         = @(
      'bin/rg',
      'autocomplete/rg.bash'
    )
    windows_files = @(
      'bin/rg.exe',
      'autocomplete/rg.ps1'
    )
  }
  'gh'      = @{
    repo   = 'cli/cli'
    name   = 'gh'
    type   = 'standalone'
    format = '{name}-{tag}-{arch}-{platform}-{compiler}.{ext}'
  }
}

$paths = @{
  [PlatformID]::Win32NT = @{
    prefix     = $env:LOCALAPPDATA
    completion = 'completion'
  }
  [PlatformID]::Unix    = @{
    prefix     = "$HOME/.local"
    completion = 'share/bash-completion/completions'
  }
}

$RustMap = @{
  [Architecture]::Arm64 = 'aarch64'
  [Architecture]::X64   = 'x86_64'
  [Architecture]::X86   = 'i686'
  [PlatformID]::Win32NT = 'pc-windows'
  [PlatformID]::Unix    = 'linux'
  [PlatformID]::MacOSX  = 'osx'
  [PlatformID]::Other   = 'android'
}

function install {
    
  $url = ''
  $file = ''
  $filetype = ''
  $files = @()
  $dir = ''
  $version = ''
  $branch = ''
  $repo = ''
  $arch = @{
    rust = & {
      if ($IsWindows) {
        
      }
    }
  }
  $platform = ''
  $name = ''
  $query = makeQuery $repo $branch $version $arch $platform
  switch ($type) {
    'standalone' { 

    }
    Default {}
  }
}

function curlParallel {
  param (
    [Parameter(Mandatory)]
    [string[]]
    $urls
  )
  $urls | ForEach-Object -ThrottleLimit $env:NUMBER_OF_PROCESSORS -Parallel {
    $tries = 3
    while ($tries--) {
      curl -fsLO $_ --output-dir $env:TEMP && break || Start-Sleep 1
    }
    if ($LASTEXITCODE -ne 0) {
      throw 'failed to download ' + $_
    }
  }
}

function aria2cFast {
  param (
    [Parameter(Mandatory)]
    [string[]]
    $urls
  )
  aria2c -x4 -s4 -j $env:NUMBER_OF_PROCESSORS -d $env:TEMP $urls
  if ($LASTEXITCODE -ne 0) {
    $tries = 3
    while ($tries--) {
      Start-Sleep 1
      aria2c && break
    }
  }
}

function update {
  param (
    $pkgs
  )
  uninstallArchives $pkgs
  install $pkgs
}

function dumpLocked {
  param (
    $items
  )
  $items | ConvertTo-Json | Out-File -FilePath $lockFile
}

function queryGitHubByCurl {
  param (
    [Parameter(Mandatory)]
    [string]
    $query,
    [string]
    $jq,
    [Parameter(Mandatory)]
    [string]
    $token
  )
  $json = @{ query = $query } | ConvertTo-Json
  $out = curl -H "Authorization: $token" -X POST -d $json 'https://api.github.com/graphql'
  if ($LASTEXITCODE -ne 0) {
    throw 'failed to query github api: ' + $query
  }
  $out | jq -r $jq
  if ($LASTEXITCODE -ne 0) {
    throw 'failed to execute jq: ' + $jq
  }
}

function queryGitHubByCli {
  param (
    [Parameter(Mandatory)]
    [string]
    $query,
    [string]
    $jq
  )
  $out = gh api graphql -F "query=$query" -q $jq
  if ($LASTEXITCODE -ne 0) {
    Write-Error $out
    throw 'failed to query github api: ' + $query
  }
  $out
}

function downloadGitHubRelease {
  param (
    [Parameter(Mandatory)]
    [string]
    $url
  )
  $tries = 3
  while ($tries--) {
    aria2c -x 16 -s 16 -j 16 -d $env:TEMP $url && break || Start-Sleep 1
  }
  if ($LASTEXITCODE -ne 0) {
    throw 'failed to download: ' + $url
  }
}
