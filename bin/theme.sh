if [[ $- != *i* ]]; then
  echo "Usage: source ${BASH_SOURCE[0]} ...<set_theme args>" >&2
  exit 1
fi

set_alacritty_theme() {
  [ -v ALACRITTY_LOG ] || return
  # dir=$(fd -td -d1 -FI1 alacritty-theme /nix/store) || return
  local conf_file=${XDG_CONFIG_HOME:-$HOME/.config}/alacritty/alacritty.toml
  [ -f "$conf_file" ] || return
  local theme_file=~/github/alacritty-theme/themes/$1.toml
  [ -f "$theme_file" ] || if [ -t 1 ]; then
    (cd ~/github/alacritty-theme/themes && fd -Id1 -tf) | sed 's/\.toml$//' | fzf --preview="
      sed -i '1c import = [ \"~/github/alacritty-theme/themes/'{}'.toml\" ]' ${conf_file@Q}
      bat --plain --color=always --no-pager ~/.bashrc"
    return
  else
    echo "alacritty theme not found: ${theme_file@Q}" >&2
    return 1
  fi
  echo "$1"
  sed -i "1c import = [ \"~/github/alacritty-theme/themes/$1.toml\" ]" "$conf_file"
}

set_bat_theme() {
  export BAT_THEME=$1
  bat --list-themes | while read -r line; do
    [ "$line" = "$1" ] && break
  done || if [ -t 1 ]; then
    # fzf error exits empty
    BAT_THEME=$(bat --list-themes \
      | fzf --preview='bat --theme {} --plain --color=always --no-pager ~/.bashrc')
  else
    echo "bat theme not found: ${1@Q}" >&2
    BAT_THEME=''
  fi
  [ -f ~/.bashrc ] || return
  echo "$BAT_THEME"
  sed -i "/^export BAT_THEME=/c export BAT_THEME=${BAT_THEME@Q}" ~/.bashrc
}

set_posh_theme() {
  [ -v POSH_PID ] || return
  local theme=$1 theme_file=~/.config/oh-my-posh/$1.omp.json
  [ -f "$theme_file" ] || if [ -t 1 ]; then
    theme=$(
      cd ~/.config/oh-my-posh && fd -Id1 -tf | sed 's/\.omp\.json$//' | fzf --preview='
        bat --plain --color=always --no-pager ~/.config/oh-my-posh/{}.omp.json'
    ) || return
  else
    echo "posh theme not found: ${theme_file@Q}" >&2
    return 1
  fi
  export POSH_THEME=~/.config/oh-my-posh/$theme.omp.json
  [ -f ~/.bashrc ] || return
  echo "$theme"
  sed -i "/^\s*export POSH_THEME=/c\
    export POSH_THEME=\"$HOME/.config/oh-my-posh/$theme.omp.json\"" ~/.bashrc
}

set_wezterm_theme() {
  [ "$TERM_PROGRAM" = WezTerm ] || return

  local conf_file themes_file line theme=$1
  conf_file=${XDG_CONFIG_HOME:-$HOME/.config}/wezterm/wezterm.lua
  [[ ! -f $conf_file && -f ~/.wezterm.lua ]] && conf_file=~/.wezterm.lua || return

  themes_file=~/.cache/wezterm/themes
  [ -f "$themes_file" ] || if [ -f ~/github.com/wez/wezterm/docs/colorschemes/data.json ]; then
    jq -r '.[].metadata.name' < ~/github.com/wez/wezterm/docs/colorschemes/data.json > "$themes_file"
  else
    mkdir -p ~/github.com/wez/wezterm/docs/colorschemes
    curl -fL https://kkgithub.com/wez/wezterm/raw/docs/colorschemes/data.json \
      -o ~/github.com/wez/wezterm/docs/colorschemes/data.json
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
  echo "$theme"
  sed -i "/^config\.color_scheme\s*=/c config.color_scheme = [[$theme]]" "$conf_file"
}

# $1 ? 'alacritty' | 'bat' | 'posh' | 'wezterm' | 'dark' | 'light'
# $2 ? string
set_theme() {
  local theme out theme_file=${THEME_FILE:-$HOME/.config/$USER/theme.json}
  case "$1" in
    alacritty | bat | posh | wezterm)
      out=$("set_${1}_theme" "$2") \
        && out=$(
          jq '.themes[$name][.theme]=$theme' \
            --arg name "$1" --arg theme "$out" < "$theme_file"
        ) && cat <<< "$out" > "$theme_file"
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
      .themes as $themes | reduce $ARGS.positional[] as $name
      (""; . + "set_\($name)_theme \(@sh "\($themes[$name][$theme])") || echo\n")
    end' -r --arg theme "$theme" --args bat posh alacritty wezterm < "$theme_file"
  ); then
    # change and set each theme, ignore non active process errors
    out=$(eval "$out")
    out=$(
      jq '.theme = $theme |
         ($values | split("\n")) as $values |
         $ARGS.positional as $args |
         .themes |= reduce ($args | keys[]) as $i
         (.; if $values[$i] != "" then .[$args[$i]][$theme] = $values[$i] end)' \
        --arg theme "$theme" --arg values "$out" --args bat posh alacritty wezterm < "$theme_file"
    ) && cat <<< "$out" > "$theme_file"
  fi
}

set_theme "$@"
