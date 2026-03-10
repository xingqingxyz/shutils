using namespace System.Runtime.InteropServices

if ((id -u) -cne '0') {
  throw 'needs sudo'
}
# data dirs for GithubRelease
New-Item -ItemType Directory /usr/local/share/jar -Force
if ($PSVersionTable.OS.StartsWith('Ubuntu')) {
  $label = (Get-Content -LiteralPath /etc/os-release | Select-String -Raw -SimpleMatch UBUNTU_CODENAME=).Split('=', 2)[1]
  # ubuntu
  New-Item /etc/apt/sources.list.d/ubuntu.sources -Value @"
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
Suites: $label $label-updates $label-backports $label-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
"@ -Force
  # llvm
  Invoke-RestMethod 'https://apt.llvm.org/llvm-snapshot.gpg.key' -OutFile /etc/apt/trusted.gpg.d/apt.llvm.org.asc/etc/apt/trusted.gpg.d/apt.llvm.org.asc
  New-Item /etc/apt/sources.list.d/llvm-toolchain.sources -Value @"
Types: deb
URIs: http://apt.llvm.org/$label
Suites: llvm-toolchain-$label-22
Components: main
Signed-By: /etc/apt/trusted.gpg.d/apt.llvm.org.asc
"@ -Force
  # microsoft
  New-Item /etc/apt/sources.list.d/microsoft.sources -Value @'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Signed-By: /usr/share/keyrings/microsoft.gpg

Types: deb
URIs: https://packages.microsoft.com/repos/edge
Suites: stable
Components: main
Signed-By: /usr/share/keyrings/microsoft.gpg
'@ -Force
  # add python symlink
  ln -sf python3 /usr/bin/python
  # remove some packages
  $pkgs = @(
    'evince'
    'gnome-calculator'
    'gnome-startup-applications'
    'gnome-text-editor'
    'ibus'
    'nano'
    'tree'
    'update-manager-core'
    'vim*'
  )
  apt purge -y --auto-remove $pkgs
  snap remove --purge firmware-updater snap-store
  snap refresh
}
elseif ($PSVersionTable.OS.StartsWith('Fedora')) {
  # auto update
  dnf install -y dnf-automatic
  systemctl enable --now dnf-automatic.timer
  systemctl status dnf-automatic.timer
  # remove some packages
  $pkgs = @(
    'evince'
    'gnome-calculator'
    'gnome-text-editor'
    'ibus'
    'nano'
    'ptyxis'
    'tree'
    'vim-minimal'
    'wcurl'
  )
  dnf remove -y $pkgs
}
elseif ($PSVersionTable.OS.StartsWith('Debian') -and
  [RuntimeInformation]::OSArchitecture -eq [Architecture]::Arm64) {
  $label = (Get-Content -LiteralPath /etc/os-release | Select-String -Raw -SimpleMatch DEBIAN_CODENAME=).Split('=', 2)[1]
  # llvm
  Invoke-RestMethod 'https://apt.llvm.org/llvm-snapshot.gpg.key' -OutFile /etc/apt/trusted.gpg.d/apt.llvm.org.asc/etc/apt/trusted.gpg.d/apt.llvm.org.asc
  New-Item /etc/apt/sources.list.d/llvm-toolchain.sources -Value @"
Types: deb
URIs: http://apt.llvm.org/$label
Suites: llvm-toolchain-$label-22
Components: main
Signed-By: /etc/apt/trusted.gpg.d/apt.llvm.org.asc
"@ -Force
  # remove some packages
  $pkgs = @(
    'nano'
    'phony'
    'vim-tiny'
  )
  apt purge -y --auto-remove $pkgs
}
