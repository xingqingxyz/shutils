# ensure niri
if ($PSVersionTable.OS.StartsWith('Fedora ')) {
  if (!(Get-Command niri -CommandType Application -TotalCount 1 -ea Ignore)) {
    sudo dnf install -y niri dms brightnessctl playerctl '--exclude=fuzzel,waybar'
    systemctl --user add-wants niri.service dms
  }
}
else {
  throw [System.NotImplementedException]::new()
}
# vscode
yq -i '.password-store = "gnome-libsecret"' ~/.config/Code/User/argv.json
