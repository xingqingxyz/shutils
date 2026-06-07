using namespace System.Runtime.InteropServices

if ((id -u) -cne '0') {
  throw 'needs sudo'
}
# data dirs for GithubRelease
New-Item -ItemType Directory /usr/local/share/jar -Force
# init machine env
Set-Region 'LoadMachineEnv' @'
if [ -f /etc/.env ]; then
  while read -r line; do
    export "$line"
  done < /etc/.env
fi
'@ /etc/profile.d/sh.local -Force
# flatpak
if (Get-Command flatpak -CommandType Application -TotalCount 1 -ea Ignore) {
  if ((flatpak remotes --columns=name).Contains('flathub')) {
    sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub --signature-lookaside=https://mirror.sjtu.edu.cn/flathub
  }
  else {
    sudo flatpak remote-add flathub https://mirror.sjtu.edu.cn/flathub --signature-lookaside=https://mirror.sjtu.edu.cn/flathub
  }
}
if ($PSVersionTable.OS.StartsWith('Fedora ')) {
  # note: google chrome is fedora configured
  # microsoft edge
  New-Item /etc/yum.repos.d/microsoft-edge.repo -Value @'
[microsoft-edge]
name=Microsoft Edge
baseurl=https://packages.microsoft.com/yumrepos/edge
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
'@ -Force
  # vscode
  New-Item /etc/yum.repos.d/vscode.repo -Value @'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
'@ -Force
  # dnf copr
  $coprs = @(
    'avengemedia/dms'
    'scottames/ghostty'
  )
  dnf copr enable -y $coprs
  # remove some packages
  $pkgs = @(
    'evince'
    'gnome-text-editor'
    'ibus'
    'nano'
    'ptyxis'
    'tmux'
    'tree'
    'vim-minimal'
    'wcurl'
  )
  dnf remove -y $pkgs
  # msedit
  ln -sf msedit /usr/bin/edit
}
elseif ($PSVersionTable.OS.StartsWith('Ubuntu ')) {
  $label = (Get-Content -LiteralPath /etc/os-release | Select-String -Raw -SimpleMatch UBUNTU_CODENAME=).Split('=', 2)[1]
  # ubuntu
  New-Item /etc/apt/sources.list.d/ubuntu.sources -Value @"
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
Suites: $label $label-updates $label-backports $label-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: $label-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
"@ -Force
  # google chrome
  New-Item /etc/apt/sources.list.d/google-chrome.sources -Value @'
X-Repolib-Name: Google Chrome
Types: deb
URIs: https://dl.google.com/linux/chrome-stable/deb/
Suites: stable
Components: main
Signed-By: /usr/share/keyrings/google-chrome.gpg
'@ -Force
  # microsoft edge
  New-Item /etc/apt/sources.list.d/microsoft-edge.sources -Value @'
Types: deb
URIs: https://packages.microsoft.com/repos/edge
Suites: stable
Components: main
Signed-By: /usr/share/keyrings/microsoft.gpg
'@ -Force
  # vscode
  New-Item /etc/apt/sources.list.d/vscode.sources -Value @'
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Signed-By: /usr/share/keyrings/microsoft.gpg
'@ -Force
  # add python symlink
  ln -sf python3 /usr/bin/python
  # remove some packages
  $pkgs = @(
    'gnome-text-editor'
    'ibus'
    'nano'
    'ptyxis'
  )
  apt purge -y --auto-remove $pkgs
}
elseif ($PSVersionTable.OS.StartsWith('Debian ') -and
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
