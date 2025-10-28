# ui no_proxy
gsettings set org.gnome.system.proxy ignore-hosts ($env:no_proxy.Split(',') | ConvertTo-Json)
# gnome-shell
gsettings set org.gnome.shell favorite-apps "['microsoft-edge.desktop', 'org.gnome.Nautilus.desktop', 'Alacritty.desktop']"
# gnome-shell-extensions
# dash-to-dock
gsettings set org.gnome.shell.extensions.dash-to-dock always-center-icons true
gsettings set org.gnome.shell.extensions.dash-to-dock animation-time 0.0
gsettings set org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM'
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
gsettings set org.gnome.shell.extensions.dash-to-dock hide-delay 0.050000000000000003
gsettings set org.gnome.shell.extensions.dash-to-dock pressure-threshold 0.0
gsettings set org.gnome.shell.extensions.dash-to-dock shortcut-timeout 0.29999999999999999
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
gsettings set org.gnome.shell.extensions.dash-to-dock show-delay 0.050000000000000003
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts true
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-network true
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts-only-mounted true
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash true
# ding
gsettings set org.gnome.shell.extensions.ding arrangeorder 'NAME'
gsettings set org.gnome.shell.extensions.ding keep-arranged true
gsettings set org.gnome.shell.extensions.ding keep-stacked true
gsettings set org.gnome.shell.extensions.ding show-home false
gsettings set org.gnome.shell.extensions.ding show-trash true
gsettings set org.gnome.shell.extensions.ding sort-special-folders true
# gnome-shell keybindings
gsettings set org.gnome.shell.keybindings toggle-message-tray []
gsettings set org.gnome.shell.keybindings toggle-quick-settings []
# nautilus
gsettings set org.gnome.nautilus.preferences click-policy 'single'
gsettings set org.gnome.nautilus.preferences show-create-link true
gsettings set org.gnome.nautilus.preferences show-delete-permanently true
gsettings set org.gnome.nautilus.preferences show-hidden-files true
# textEditor
gsettings set org.gnome.TextEditor enable-snippets true
gsettings set org.gnome.TextEditor highlight-current-line true
gsettings set org.gnome.TextEditor indent-style 'space'
gsettings set org.gnome.TextEditor indent-width 2
gsettings set org.gnome.TextEditor restore-session false
gsettings set org.gnome.TextEditor right-margin-position 120
gsettings set org.gnome.TextEditor show-right-margin true
gsettings set org.gnome.TextEditor tab-width 4
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
gsettings set org.gnome.desktop.wm.keybindings minimize []
gsettings set org.gnome.desktop.wm.keybindings show-desktop []
gsettings set org.gnome.desktop.wm.keybindings switch-applications []
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward []
gsettings set org.gnome.desktop.wm.keybindings switch-panels []
gsettings set org.gnome.desktop.wm.keybindings switch-panels-backward []
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen ['<Super>F11']
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized []
# gnome-software
if ($env:XDG_SESSION_TYPE -ceq 'ubuntu') {
  gsettings set com.ubuntu.update-manager first-run false
  gsettings set com.ubuntu.update-manager show-details true
  gsettings set com.ubuntu.update-notifier no-show-notifications true
  gsettings set com.ubuntu.update-notifier notify-ubuntu-advantage-available false
  gsettings set com.ubuntu.update-notifier regular-auto-launch-interval 14
}
# apps folder
gsettings set org.gnome.desktop.app-folders folder-children ['Utilities', 'YaST', 'Pardus']
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ apps ['gnome-abrt.desktop', 'gnome-system-log.desktop', 'nm-connection-editor.desktop', 'org.gnome.baobab.desktop', 'org.gnome.Connections.desktop', 'org.gnome.DejaDup.desktop', 'org.gnome.Dictionary.desktop', 'org.gnome.DiskUtility.desktop', 'org.gnome.Evince.desktop', 'org.gnome.FileRoller.desktop', 'org.gnome.fonts.desktop', 'org.gnome.Loupe.desktop', 'org.gnome.seahorse.Application.desktop', 'org.gnome.tweaks.desktop', 'org.gnome.Usage.desktop', 'vinagre.desktop', 'software-properties-gtk.desktop', 'update-manager.desktop', 'nvidia-settings.desktop', 'org.gnome.SystemMonitor.desktop', 'org.gnome.Settings.desktop', 'firmware-updater_firmware-updater.desktop', 'gnome-language-selector.desktop', 'org.gnome.Calculator.desktop', 'org.gnome.PowerStats.desktop', 'software-properties-drivers.desktop', 'org.gnome.TextEditor.desktop', 'org.gnome.eog.desktop', 'org.gnome.clocks.desktop', 'yelp.desktop', 'snap-store_snap-store.desktop', 'gnome-session-properties.desktop', 'org.gnome.Terminal.desktop', 'firefox_firefox.desktop', 'code.desktop', 'ca.desrt.dconf-editor.desktop']
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ categories ['X-GNOME-Utilities']
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ name 'X-GNOME-Utilities.directory'
gsettings set org.gnome.desktop.app-folders.folder:/org/gnome/desktop/app-folders/folders/Utilities/ translate true
# keyboard
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
gsettings set org.gnome.desktop.peripherals.touchpad send-events 'disabled'
