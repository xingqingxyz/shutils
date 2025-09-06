$os, $arch = goenv

[DscResource()]
class GoReleaseDSC {
  [DscProperty(Key)]
  [string]
  $id

  [DscProperty(Mandatory)]
  [string]
  $name

  [DscProperty()]
  [version]
  $version

  [GoReleaseDSC] Get() {
    $this.version = getVersion $this.name
    return $this
  }

  [void] Set() {}

  [bool] Test() {
    return $false
  }
}

class _Internal {
  [DscProperty(NotConfigurable)]
  [ValidateSet(
    'android',
    'darwin',
    'freebsd',
    'linux',
    'windows'
  )]
  [string]
  $os

  [DscProperty(NotConfigurable)]
  [ValidateSet(
    'amd64',
    'arm64',
    'armv7',
    'loong64'
  )]
  [string]
  $arch
}
