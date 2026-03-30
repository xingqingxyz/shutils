# ui no_proxy
gsettings set org.gnome.system.proxy ignore-hosts ($env:no_proxy.Split(',') | ConvertTo-Json)
# gnome-shell
gsettings set org.gnome.shell app-picker-layout "[{'Utilities': <{'position': <0>}>, 'org.gnome.DiskUtility.desktop': <{'position': <1>}>, 'org.gnome.Logs.desktop': <{'position': <2>}>, 'org.gnome.Software.desktop': <{'position': <3>}>, 'org.gnome.Settings.desktop': <{'position': <4>}>, 'org.gnome.Loupe.desktop': <{'position': <5>}>, 'wechat.desktop': <{'position': <6>}>, 'org.gnome.SystemMonitor.desktop': <{'position': <7>}>, 'org.gnome.Snapshot.desktop': <{'position': <8>}>, 'org.gnome.Characters.desktop': <{'position': <9>}>, 'org.gnome.font-viewer.desktop': <{'position': <10>}>, 'jetbrains-studio-81c8899a-0a4a-40b0-8ff0-9bebcd8d0f3f.desktop': <{'position': <11>}>, 'vncviewer.desktop': <{'position': <12>}>, 'ca.desrt.dconf-editor.desktop': <{'position': <13>}>, 'fcitx5-configtool.desktop': <{'position': <14>}>, 'org.mozilla.firefox.desktop': <{'position': <15>}>, 'jetbrains-idea-ce-322ed6ea-37ea-4883-812c-1b29dc093750.desktop': <{'position': <16>}>, 'jetbrains-toolbox.desktop': <{'position': <17>}>, 'localsend.desktop': <{'position': <18>}>, 'wps-office-prometheus.desktop': <{'position': <19>}>, 'code.desktop': <{'position': <20>}>, 'vlc.desktop': <{'position': <21>}>, 'kitty.desktop': <{'position': <22>}>, 'com.mitchellh.ghostty.desktop': <{'position': <23>}>}, {'wps-office-et.desktop': <{'position': <0>}>, 'wps-office-wps.desktop': <{'position': <1>}>, 'wps-office-wpp.desktop': <{'position': <2>}>, 'wps-office-pdf.desktop': <{'position': <3>}>}]"
gsettings set org.gnome.shell enabled-extensions "['appindicatorsupport@rgcjonas.gmail.com', 'blur-my-shell@aunetx', 'clipboard-indicator@tudmotu.com', 'dash-to-dock@micxgx.gmail.com', 'kimpanel@kde.org']"
gsettings set org.gnome.shell favorite-apps "['microsoft-edge.desktop', 'Alacritty.desktop']"
# gnome-shell extensions
<#
dconf dump /org/gnome/shell/extensions/ > $env:SHUTILS_ROOT/data/gnome-shell-extensions.dconf.ini
 #>
Get-Content -LiteralPath $env:SHUTILS_ROOT/data/gnome-shell-extensions.dconf.ini | dconf load /org/gnome/shell/extensions/
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
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>F']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized []
# wm preferences
gsettings set org.gnome.desktop.wm.preferences button-layout ':close'
# keyboard
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state true
gsettings set org.gnome.desktop.peripherals.touchpad send-events 'disabled'
# terminal
gsettings set org.gnome.desktop.default-applications.terminal exec alacritty
gsettings set org.gnome.desktop.default-applications.terminal exec-arg '-e'
# autostart
New-Item -ItemType Directory ~/.config/autostart -Force
New-Item -ItemType SymbolicLink -Force -Target /usr/share/applications/org.fcitx.Fcitx5.desktop ~/.config/autostart/org.fcitx.Fcitx5.desktop
$term = (Get-Command alacritty, ghostty, kitty -CommandType Application -TotalCount 1 -ea Ignore)[0].Name
if ($term) {
  $desktop = @(locate -i $term.desktop)[0]
  New-Item -ItemType SymbolicLink -Force -Target $desktop $HOME/.config/autostart/$([System.IO.Path]::GetFileName($desktop))
}
