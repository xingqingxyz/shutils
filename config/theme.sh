if [ "$0" != "$BASH" ]; then
  echo "Usage: source ${BASH_SOURCE[0]} ...<set_theme args>" >&2
  exit 1
fi

export_bat_theme() {
  case "$1" in
    dark)
      export -n BAT_THEME
      ;;
    light)
      export BAT_THEME=GitHub
      ;;
    *)
      export BAT_THEME=$1
      ;;
  esac
}

export_posh_theme() {
  local theme
  case "$1" in
    dark)
      theme='1_shell'
      ;;
    light)
      theme=if_tea
      ;;
    *) theme=$1 ;;
  esac
  export POSH_THEME="$HOME/.config/oh-my-posh/$theme.omp.json"
}

set_nvim_theme() {
  local theme
  case "$1" in
    dark)
      theme=material-deep-ocean
      ;;
    light)
      theme=material-lighter
      ;;
    *) theme=$1 ;;
  esac
  if pgrep nvim > /dev/null; then
    # nvim --remote-send "<Cmd>colo $theme<CR>"
    echo
  fi
}

set_posh_theme() {
  local theme
  case "$1" in
    dark)
      theme='1_shell'
      ;;
    light)
      theme=if_tea
      ;;
    *) theme=$1 ;;
  esac
  local pat="s|/oh-my-posh/.+\.omp\.json|/oh-my-posh/$theme"
  sed -i -E "$pat" ~/.bashrc
}

set_alacritty_theme() {
  local theme dir conf_file
  dir=$(fd -t d -d 1 -F -I -1 alacritty-theme /nix/store) || return 1
  case "$1" in
    dark)
      theme=dracula
      ;;
    light)
      theme=ayu_light
      ;;
    *)
      theme=$1
      ;;
  esac
  if [ ! -e "$dir$theme.toml" ]; then
    echo "config not found: $theme.toml" >&2
    ls "$dir" >&2
    return 1
  fi
  conf_file=~/.config/alacritty/alacritty.toml
  {
    printf 'import = [ "%s" ]\n' "$dir$theme.toml"
  } | tee "$conf_file" > /dev/null
}

set_theme() {
  local theme
  case "$1" in
    dark | light) theme=$1 ;;
    *)
      read -r < <(date +%-H)
      if ((REPLY >= 8 && REPLY < 16)); then
        theme=light
      else
        theme=dark
      fi
      ;;
  esac
  case "$XDG_SESSION_DESKTOP" in
    plasma*)
      plasma-apply-colorscheme "Breeze${theme@u}"
      ;;
    gnome*)
      gsettings set org.freedesktop.interface color-theme "prefer-$theme"
      ;;
  esac
  set_alacritty_theme "$theme"
  # for i in alacritty posh; do
  #   eval "set_${i}_theme" "$theme"
  # done
}

export_theme() {
  local theme i
  case "$1" in
    dark | light) theme=$1 ;;
    *)
      read -r < <(date +%-H)
      if ((REPLY >= 8 && REPLY < 16)); then
        theme=light
      else
        theme=dark
      fi
      ;;
  esac
  for i in bat posh; do
    eval "export_${i}_theme" "$theme"
  done
}
