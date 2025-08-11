using namespace System.Runtime.InteropServices

function goenv {
  if (Get-Command go -Type Application -ea Ignore) {
    return go env GOOS GOARCH
  }
  $os = switch ($true) {
    $IsWindows { 'windows'; break }
    $IsMacOS { 'darwin'; break }
    $IsLinux {
      if ([RuntimeInformation]::IsOSPlatform([OSPlatform]::FreeBSD)) {
        'freebsd'
        break
      }
      switch (uname -o) {
        'Android' { 'android'; break }
        'GNU/Linux' { 'linux'; break }
        default { $_; break }
      }
      break
    }
  }
  $arch = switch ([string][RuntimeInformation]::OSArchitecture) {
    'X64' { 'amd64'; break }
    'Arm64' { 'arm64'; break }
    'Arm' { 'armv7'; break }
    'LoongArch64' { 'loong64'; break }
    default { throw "not implemented arch $_" }
  }
  $os, $arch
}

function rustenv {
  if (Get-Command rustc -Type Application -ea Ignore) {
    return (rustc -vV | Select-String -Raw host:).Split(' ', 2)[1]
  }
  $arch = switch ([string][RuntimeInformation]::OSArchitecture) {
    'X64' { 'x86_64'; break }
    'Arm64' { 'aarch64'; break }
    'Arm' { 'armv7'; break }
    'LoongArch64' { 'loongarch64'; break }
    default { throw "not implemented arch $_" }
  }
  $platform = switch ($true) {
    $IsWindows { 'pc'; break }
    $IsLinux { 'unknown'; break }
    default { throw "not implemented platform $_" }
  }
  $os = switch ($true) {
    $IsWindows { 'windows-msvc'; break }
    $IsMacOS { 'darwin'; break }
    $IsLinux {
      if ([RuntimeInformation]::IsOSPlatform([OSPlatform]::FreeBSD)) {
        'freebsd'
        break
      }
      switch (uname -o) {
        'Android' {
          $platform = 'linux'
          'android'
          break
        }
        'GNU/Linux' { 'linux-gnu'; break }
        default { $_; break }
      }
      break
    }
  }
  "$arch-$platform-$os"
}
