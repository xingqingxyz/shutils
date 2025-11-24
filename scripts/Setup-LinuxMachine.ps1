if ((id -u) -cne '0') {
  throw 'needs sudo'
}
if ($env:XDG_SESSION_DESKTOP -ceq 'ubuntu') {
  # add python symlink
  ln -sf python3 /usr/bin/python
  # remove some packages
  apt uninstall -y --auto-remove nano vim-minmal wcurl tree
}
if ((Get-Content -Raw -LiteralPath /etc/os-release).Contains('ID=fedora')) {
  # auto update
  dnf install -y dnf-automatic
  systemctl enable --now dnf-automatic.timer
  systemctl status dnf-automatic.timer
  # remove some packages
  dnf remove -y nano vim-minmal wcurl tree
}
