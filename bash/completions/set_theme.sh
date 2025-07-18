_set_theme() {
  case "$COMP_CWORD" in
    1)
      mapfile -t COMPREPLY < <(compgen -W 'alacritty bat posh wezterm dark light' -- "$2")
      ;;
    2)
      case "$3" in
        alacritty)
          mapfile -t COMPREPLY < <(compgen -W "$(
            cd ~/github/alacritty-theme/themes && fd -tf -Id1 | sed 's/\.toml$//'
          )" -- "$2")
          ;;
        bat)
          mapfile -t COMPREPLY < <(compgen -W "$(bat --list-themes)" -- "$2")
          ;;
        posh)
          mapfile -t COMPREPLY < <(compgen -W "$(
            cd ~/.config/oh-my-posh && fd -tf -Id1 | sed 's/\.omp\.json$//'
          )" -- "$2")
          ;;
        wezterm)
          mapfile -t COMPREPLY < <(grep -F "$2" ~/.cache/wezterm/themes)
          COMPREPLY=("${COMP_CWORD[@]@Q}")
          ;;
      esac
      ;;
  esac
}

complete -F _set_theme set_theme
