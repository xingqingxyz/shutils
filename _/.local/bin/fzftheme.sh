#!/bin/bash
if [ $# = 0 ]; then
  if [ -v ALACRITTY_WINDOW_ID ]; then
    ls ~/p/alacritty-theme/themes | fzf --preview="$0 --preview {}"
  fi
elif [ "$1" = --preview ]; then
  sed -i 's|^import =.*$|import = ["~/p/alacritty-theme/themes/'"$2\"]|" ~/.config/alacritty/alacritty.toml
  echo "current theme: $2"
  for ((i = 30; i <= 36; i++)); do
    printf '\e[%smhello world\e[0m\n' "$i"
  done
  for ((i = 40; i <= 46; i++)); do
    printf '\e[%smhello world\e[0m\n' "$i"
  done
  exit
elif [ "$1" = bat ]; then
  declare name out
  if [ $(gsettings get org.gnome.desktop.interface color-scheme) = "'prefer-dark'" ]; then
    name=BAT_THEME_DARK
  else
    name=BAT_THEME_LIGHT
  fi
  out=$(bat --list-themes | fzf --preview='bat --theme={} -lsh -p --color=always /etc/bashrc') \
    && echo "export $name='$out'"$'\n$env:'"$name = '$out'"
fi
