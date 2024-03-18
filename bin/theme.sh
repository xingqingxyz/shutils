if [[ $- != *i* ]]; then
  echo "Usage: source ${BASH_SOURCE[0]} ...<set_theme args>" >&2
  exit 1
fi

set_alacritty_theme() {
  [ -v ALACRITTY_LOG ] || return
  # dir=$(fd -td -d1 -FI1 alacritty-theme /nix/store) || return
  local conf_file=${XDG_CONFIG_HOME:-$HOME/.config}/alacritty/alacritty.toml
  [ -f "$conf_file" ] || return
  local theme=$1 theme_file=~/github/alacritty-theme/themes/$1.toml
  if [ -f "$theme_file" ]; then
    sed -i "1c import = [ \"~/github/alacritty-theme/themes/$theme.toml\" ]" "$conf_file"
  elif [ -t 1 ]; then
    theme=$(cd ~/github/alacritty-theme/themes && fd -Id1 -tf | sed 's/\.toml$//' \
      | fzf --preview="sed -i '1c import = [ \"~/github/alacritty-theme/themes/'{}'.toml\" ]' ${conf_file@Q}
        bat --plain --color=always --no-pager ~/.bashrc") || return
  else
    echo "alacritty theme not found: ${theme_file@Q}" >&2
    return 1
  fi
  set_theme alacritty "$theme"
}

set_bat_theme() {
  local theme=$1
  bat --list-themes | while read -r line; do
    [ "$line" = "$theme" ] && break
  done || if [ -t 1 ]; then
    theme=$(
      bat --list-themes \
        | fzf --preview='bat --theme {} --plain --color=always --no-pager ~/.bashrc'
    ) || return
  else
    echo "bat theme not found: ${theme@Q}" >&2
    return 1
  fi
  export BAT_THEME=$theme
  set_theme bat "$theme"
  [ -f ~/.bashrc ] \
    && sed -i "/^export BAT_THEME=/c export BAT_THEME=${theme@Q}" ~/.bashrc
}

set_posh_theme() {
  [ -v POSH_PID ] || return
  local theme=$1 theme_file=~/.config/oh-my-posh/$1.omp.json
  [[ $theme == '' || -f $theme_file ]] || if [ -t 1 ]; then
    theme=$(
      cd ~/.config/oh-my-posh && fd -Id1 -tf | sed 's/\.omp\.json$//' | fzf --preview='
        bat --plain --color=always --no-pager ~/.config/oh-my-posh/{}.omp.json'
    ) || return
  else
    echo "posh theme not found: ${theme_file@Q}" >&2
    return 1
  fi
  export POSH_THEME=~/.config/oh-my-posh/$theme.omp.json
  set_theme posh "$theme"
  [ -f ~/.bashrc ] \
    && sed -i "/^\s*export POSH_THEME=/c\
    export POSH_THEME=\"\$HOME/.config/oh-my-posh/$theme.omp.json\"" ~/.bashrc
}

set_wezterm_theme() {
  [ "$TERM_PROGRAM" = WezTerm ] || return

  local conf_file=${XDG_CONFIG_HOME:-$HOME/.config}/wezterm/wezterm.lua
  if [ ! -f "$conf_file" ]; then
    [ -f ~/.wezterm.lua ] || return
    conf_file=~/.wezterm.lua
  fi

  local line theme=$1 themes_file=~/.cache/wezterm/themes
  if [ ! -f "$themes_file" ]; then
    if [ ! -f ~/github.com/wez/wezterm/docs/colorschemes/data.json ]; then
      mkdir -p ~/github.com/wez/wezterm/docs/colorschemes
      curl -fL https://kkgithub.com/wez/wezterm/raw/docs/colorschemes/data.json \
        -o ~/github.com/wez/wezterm/docs/colorschemes/data.json
    fi || return
    jq -r '.[].metadata.name' < ~/github.com/wez/wezterm/docs/colorschemes/data.json > "$themes_file"
  fi || return

  while read -r line; do
    [ "$line" = "$theme" ] && break
  done < "$themes_file" || if [ -t 1 ]; then
    theme=$(
      fzf --preview="
        sed -i \"/^config\.color_scheme\s*=/c config.color_scheme = {}\" ${conf_file@Q}
        bat --plain --color=always --no-pager ~/.bashrc" < "$themes_file"
    ) || return
  else
    echo "wezterm theme not valid: ${theme@Q}" >&2
    return 1
  fi
  set_theme wezterm "$theme"
  sed -i "/^config\.color_scheme\s*=/c config.color_scheme = [[$theme]]" "$conf_file"
}

# $1 ? 'alacritty' | 'bat' | 'posh' | 'wezterm' | 'dark' | 'light'
# $2 ? string
set_theme() {
  local out theme theme_file=${THEME_FILE:-$HOME/.config/$USER/theme.json}
  case "$1" in
    alacritty | bat | posh | wezterm)
      # implies user calls
      if [ ${#FUNCNAME[@]} = 1 ]; then
        "set_${1}_theme" "$2"
      else
        out=$(
          jq '.themes[$name][.theme]=$theme' \
            --arg name "$1" --arg theme "$2" < "$theme_file"
        ) && cat <<< "$out" > "$theme_file"
      fi
      return
      ;;
    dark | light) theme=$1 ;;
    '')
      out=$(date +%-H)
      if ((out >= 8 && out < 17)); then
        theme=light
      else
        theme=dark
      fi
      ;;
    *)
      echo "invalid theme target: ${1@Q}" >&2
      return 1
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

  if out=$(
    jq 'if .theme == $theme then
      "all themes already set to \($theme)\n" | stderr | empty | halt_error
    else
      .theme = $theme
    end' --arg theme "$theme" < "$theme_file"
  ); then
    out=$(
      tee "$theme_file" <<< "$out" | jq -r --arg theme "$theme" \
        '.themes | to_entries | map("set_\(.key)_theme \(@sh "\(.value[$theme])")") | join("\n")'
    )
    # set themes and ignore non active program errors
    eval "$out"
    return 0
  fi
}

set_theme "$@"
