#!/bin/bash
if [ $# = 0 ]; then
  if [ -v ALACRITTY_WINDOW_ID ]; then
    ls ~/p/alacritty-theme/themes | fzf --preview="$0 --preview {}"
  fi
elif [ "$1" = -p -o "$1" = --preview ]; then
  if [ "$2" ]; then
    cp ~/p/alacritty-theme/themes/"$2" ~/.config/alacritty/theme_dark.toml
  fi
  for ((i = 30; i <= 36; i++)); do
    printf '\e[%sm%s.hello world\e[0m\n' "$i" "$i"
  done
  for ((i = 40; i <= 46; i++)); do
    printf '\e[%sm%s.hello world\e[0m\n' "$i" "$i"
  done
elif [ "$1" = bat ]; then
  if [ $(gsettings get org.gnome.desktop.interface color-scheme) = "'prefer-dark'" ]; then
    name=BAT_THEME_DARK
  else
    name=BAT_THEME_LIGHT
  fi
  out=$(bat --list-themes | fzf --preview='bat --theme={} -plsh --color=always /etc/bashrc') \
    && echo "export $name='$out'"$'\n$env:'"$name = '$out'"
fi
