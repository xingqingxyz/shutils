#!/usr/bin/env bash
set -e
# only run on linux
case "$OSTYPE" in
  *linux*) ;;
  *) false ;;
esac
if [ ! -v WISH_ROOT ]; then
  echo 'setup repo' >&2
  if type -aP aptt &> /dev/null; then
    sudo apt install -y git aria2
  elif type -aP dnft &> /dev/null; then
    sudo dnf install -y git aria2
  else
    echo 'unknown pkg manager' >&2
    exit 2
  fi
  mkdir ~/p
  git -C ~/p clone https://github.com/xingqingxyz/wish
  export WISH_ROOT=$HOME/p/wish
fi
echo 'setup pwsh' >&2
case "$(arch)" in
  x86_64) arch=x64 ;;
  aarch64) arch=arm64 ;;
  *) false ;;
esac
tag=$(gh release list -R PowerShell/PowerShell --exclude-drafts -L5 --json 'tagName,isPrerelease' -q 'first(.[] | select(.isPrerelease)) | .tagName')
file="powershell-${tag:1}-linux-$arch.tar.gz"
gh release download -R PowerShell/PowerShell -p "$file" -D /tmp "$tag"
baseDir='/opt/PowerShell/powershell/7'
sudo rm -rf "$baseDir"
sudo mkdir -p "$baseDir"
sudo tar -xf /tmp/"$file" -C "$baseDir"
sudo chmod +x "$baseDir"/pwsh
sudo ln -sf "$baseDir"/pwsh /usr/bin
# run
cd "$WISH_ROOT"
echo 'runing pwsh' >&2
pwsh -nop ./scripts/Initialize-Computer.ps1
