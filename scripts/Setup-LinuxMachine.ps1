if ((id -u) -cne '0') {
  throw 'needs sudo'
}
if ($env:XDG_SESSION_DESKTOP -ceq 'ubuntu') {
  ln -sf /usr/bin/python3 /usr/bin/python
}
