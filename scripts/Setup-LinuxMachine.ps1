if ((id -u) -cne '0') {
  throw 'needs sudo'
}
if ($env:XDG_SESSION_DESKTOP -ceq 'ubuntu') {
  ln -sf python3 /usr/bin/python
}
if ((Get-Content -Raw -LiteralPath /etc/os-release).Contains('ID=fedora')) {
  # auto update
  dnf install -y dnf-automatic
  systemctl enable --now dnf-automatic.timer
  systemctl status dnf-automatic.timer
}
