#!/usr/bin/env bash
set -e
# only run on linux
case "$OSTYPE" in
  *linux*) ;;
  *) false ;;
esac
if [ -v WSL_DISTRO_NAME -a "$FORCE" != 1 ]; then
  echo "please update wsl kernel first, then use FORCE=1 $0 ..." >&2
  wsl.exe -l -v
  echo wsl.exe --shutdown >&2
  echo wsl.exe --update >&2
  exit 1
fi
if [ "$1" = post ]; then
  cat /etc/os-release
  echo 'running post upgrade commands' >&2
  if type -aP apt &> /dev/null; then
    systemctl --failed
    sudo apt install --fix-broken
    sudo apt update
    sudo apt dist-upgrade -y
  elif type -aP dnf &> /dev/null; then
    sudo dnf system-upgrade clean
    sudo dnf distro-sync
  fi
  exit
fi
if type -aP apt &> /dev/null; then
  echo 'installing tools and patches' >&2
  sudo apt update
  sudo apt install -y update-manager
  sudo apt dist-upgrade -y
  sudo apt autoremove --purge -y
  sudo apt autoclean
  echo 'doing release upgrade' >&2
  sudo do-release-upgrade
elif type -aP dnf &> /dev/null; then
  echo 'installing tools' >&2
  sudo dnf upgrade --refresh
  sudo dnf install -y dnf-plugin-system-upgrade
  echo 'downloading system updates' >&2
  sudo dnf system-upgrade download
  if [ ! -v WSL_DISTRO_NAME ]; then
    echo 'doing release upgrade' >&2
    sudo dnf system-upgrade reboot
  fi
fi
