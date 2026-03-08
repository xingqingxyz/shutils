using namespace System.Runtime.InteropServices

if ((id -u) -cne '0') {
  throw 'needs sudo'
}
$osRelease = Get-Content -Raw -LiteralPath /etc/os-release
if ($osRelease.Contains('ID=ubuntu')) {
  # add python symlink
  ln -sf python3 /usr/bin/python
  # remove some packages
  apt purge -y --auto-remove nano vim-minmal wcurl tree
}
elseif ($osRelease.Contains('ID=fedora')) {
  # auto update
  dnf install -y dnf-automatic
  systemctl enable --now dnf-automatic.timer
  systemctl status dnf-automatic.timer
  # remove some packages
  dnf remove -y nano vim-minmal wcurl tree
}
elseif ($osRelease.Contains('ID=debian') -and
  [RuntimeInformation]::OSArchitecture -eq [Architecture]::Arm64) {
  # remove some packages
  apt purge -y --auto-remove nano vim-tiny
}
