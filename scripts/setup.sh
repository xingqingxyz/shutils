#!/usr/bin/env bash
set -e
# only run on linux
case "$OSTYPE" in
  *linux*) ;;
  *) false ;;
esac
if [ ! -v SHUTILS_ROOT ]; then
  echo 'setup repo' >&2
  sudo apt install -y gh git curl aria2
  mkdir ~/p
  cp ~/p
  gh repo clone xinqqingxyz/shutils
  cp shutils
  export SHUTILS_ROOT=$HOME/p/shutils
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
echo 'runing pwsh' >&2
pwsh -nop "$SHUTILS_ROOT"/scripts/Initialize-Computer.ps1
