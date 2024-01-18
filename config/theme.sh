set-theme() {
  gsettings set org.gnome.desktop.interface color-scheme "prefer-$1"
  file=~/.config/alacritty/alacritty.toml
  if [ "$1" = light ]; then
    sed -i -e 's/"Dark"/"Light"/g;s/_dark/_light/g' $file
    export BAT_THEME=base16
  else
    sed -i -e 's/"Light"/"Dark"/g;s/_light/_dark/g' $file
    unset BAT_THEME
  fi
}

hour=$(date +%-H)
if [[ hour -ge 8 && hour -lt 16 ]]; then
  set-theme light
else
  set-theme dark
fi
unset hour

export -f set-theme
