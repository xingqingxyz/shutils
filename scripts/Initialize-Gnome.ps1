# ui no_proxy
gsettings set org.gnome.system.proxy ignore-hosts ($env:no_proxy.Split(',') | ConvertTo-Json)
# gnome-shell
gsettings set org.gnome.shell favorite-apps "['microsoft-edge.desktop', 'Alacritty.desktop', 'org.gnome.Nautilus.desktop']"
# gnome-shell-extensions
# dash-to-dock
gsettings set org.gnome.shell.extensions.dash-to-dock always-center-icons true
gsettings set org.gnome.shell.extensions.dash-to-dock animation-time 0.05
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock hide-delay 0.050000000000000003
gsettings set org.gnome.shell.extensions.dash-to-dock pressure-threshold 0.0
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts true
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-network true
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted true
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash true
gsettings set org.gnome.shell.extensions.dash-to-dock.background-opacity 0.80000000000000004
gsettings set org.gnome.shell.extensions.dash-to-dock.click-action 'focus-minimize-or-previews'
gsettings set org.gnome.shell.extensions.dash-to-dock.height-fraction 0.90000000000000002
gsettings set org.gnome.shell.extensions.dash-to-dock.hide-delay 0.15000000000000002
gsettings set org.gnome.shell.extensions.dash-to-dock.intellihide false
gsettings set org.gnome.shell.extensions.dash-to-dock.intellihide-mode 'ALL_WINDOWS'
gsettings set org.gnome.shell.extensions.dash-to-dock.require-pressure-to-show false
gsettings set org.gnome.shell.extensions.dash-to-dock.shortcut-timeout 0.29999999999999999
gsettings set org.gnome.shell.extensions.dash-to-dock.show-delay 0.15000000000000002
gsettings set org.gnome.shell.extensions.dash-to-dock.show-dock-urgent-notify false
# clipboard-indicator
gsettings set org.gnome.shell.extensions.clipboard-indicator.cache-only-favorites false
gsettings set org.gnome.shell.extensions.clipboard-indicator.cache-size 20
gsettings set org.gnome.shell.extensions.clipboard-indicator.clear-history []
gsettings set org.gnome.shell.extensions.clipboard-indicator.confirm-clear false
gsettings set org.gnome.shell.extensions.clipboard-indicator.disable-down-arrow true
gsettings set org.gnome.shell.extensions.clipboard-indicator.enable-keybindings true
gsettings set org.gnome.shell.extensions.clipboard-indicator.history-size 100
gsettings set org.gnome.shell.extensions.clipboard-indicator.move-item-first true
gsettings set org.gnome.shell.extensions.clipboard-indicator.next-entry []
gsettings set org.gnome.shell.extensions.clipboard-indicator.next-history-clear -1
gsettings set org.gnome.shell.extensions.clipboard-indicator.notify-on-copy false
gsettings set org.gnome.shell.extensions.clipboard-indicator.notify-on-cycle false
gsettings set org.gnome.shell.extensions.clipboard-indicator.paste-button false
gsettings set org.gnome.shell.extensions.clipboard-indicator.paste-on-select true
gsettings set org.gnome.shell.extensions.clipboard-indicator.prev-entry []
gsettings set org.gnome.shell.extensions.clipboard-indicator.preview-size 30
gsettings set org.gnome.shell.extensions.clipboard-indicator.private-mode-binding []
gsettings set org.gnome.shell.extensions.clipboard-indicator.strip-text true
gsettings set org.gnome.shell.extensions.clipboard-indicator.toggle-menu "['<Super>v']"
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
gsettings set org.gnome.desktop.wm.keybindings begin-move []
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
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,close'
# keyboard
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
gsettings set org.gnome.desktop.peripherals.touchpad send-events 'disabled'
# autostart
New-Item -ItemType Directory ~/.config/autostart -Force
New-Item -ItemType SymbolicLink -Force -Target $HOME/.local/share/applications/Alacritty.desktop ~/.config/autostart/Alacritty.desktop
New-Item -ItemType SymbolicLink -Force -Target /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/org.fcitx.Fcitx5.desktop
