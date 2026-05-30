# ensure niri
if (!(Get-Command niri -CommandType Application -TotalCount 1 -ea Ignore)) {
  if ($PSVersionTable.OS.StartsWith('Fedora ')) {
    sudo dnf copr enable -y avengemedia/dms
    sudo dnf install -y niri dms brightnessctl playerctl '--exclude=fuzzel,swaylock,waybar'
    sudo systemctl --user --global add-wants niri dms
  }
  elseif ($PSVersionTable.OS.StartsWith('Ubuntu ')) {
    sudo add-apt-repository -y ppa:avengemedia/danklinux
    sudo add-apt-repository -y ppa:avengemedia/dms
    sudo apt install -y niri dms
    sudo systemctl disable --user --global dms
    sudo systemctl --user --global add-wants niri dms
  }
  else {
    throw [System.NotImplementedException]::new()
  }
}
# vscode
& $PSScriptRoot/niri-patch-vscode.ts vscode
