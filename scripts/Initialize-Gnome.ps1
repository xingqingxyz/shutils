# ui no_proxy
gsettings set org.gnome.system.proxy ignore-hosts ($env:no_proxy.Split(',') | ConvertTo-Json)
# gnome-shell
gsettings set org.gnome.shell favorite-apps "['microsoft-edge.desktop', 'Alacritty.desktop', 'org.gnome.Nautilus.desktop']"
# gnome-shell keybindings
gsettings set org.gnome.shell.keybindings focus-active-notification []
gsettings set org.gnome.shell.keybindings toggle-message-tray []
gsettings set org.gnome.shell.keybindings toggle-quick-settings []
# nautilus
gsettings set org.gnome.nautilus.preferences click-policy 'single'
gsettings set org.gnome.nautilus.preferences show-create-link true
gsettings set org.gnome.nautilus.preferences show-delete-permanently true
gsettings set org.gnome.nautilus.preferences show-hidden-files true
# interface
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.interface enable-hot-corners false
# wm
gsettings set org.gnome.desktop.wm.keybindings activate-window-menu []
gsettings set org.gnome.desktop.wm.keybindings begin-move "['<Shift><Super>s']"
gsettings set org.gnome.desktop.wm.keybindings begin-resize []
gsettings set org.gnome.desktop.wm.keybindings cycle-group []
gsettings set org.gnome.desktop.wm.keybindings cycle-group-backward []
gsettings set org.gnome.desktop.wm.keybindings cycle-panels []
gsettings set org.gnome.desktop.wm.keybindings cycle-panels-backward []
gsettings set org.gnome.desktop.wm.keybindings cycle-windows []
gsettings set org.gnome.desktop.wm.keybindings cycle-windows-backward []
gsettings set org.gnome.desktop.wm.keybindings minimize []
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source []
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward []
gsettings set org.gnome.desktop.wm.keybindings switch-panels []
gsettings set org.gnome.desktop.wm.keybindings switch-panels-backward []
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>F11']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized []
# wm preferences
gsettings set org.gnome.desktop.wm.preferences button-layout ':close'
# keyboard
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
gsettings set org.gnome.desktop.peripherals.touchpad send-events 'disabled'
# autostart
New-Item -ItemType Directory ~/.config/autostart -Force
New-Item -ItemType SymbolicLink -Force -Target /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/org.fcitx.Fcitx5.desktop
$term = (Get-Command ghostty, alacritty -CommandType Application -TotalCount 1 -ea Ignore)[0].Name
if ($term) {
  $desktop = @(locate -i $term`.desktop)[0]
  New-Item -ItemType SymbolicLink -Force -Target $desktop $HOME/.config/autostart/$([System.IO.Path]::GetFileName($desktop))
}
