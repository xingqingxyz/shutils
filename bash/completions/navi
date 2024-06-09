_navi() {
  case "$3" in
    --finder)
      mapfile -t COMPREPLY < <(compgen -W 'fzf skim' -- "$2")
      return
      ;;
  esac
  if [[ $COMP_CWORD = 1 || $2 = -* ]]; then
    mapfile -t COMPREPLY < <(compgen -W 'fn repo widget info help -p --path --print --best-match --prevent-interpolation --tldr --tag-rules --cheatsh -q --query --fzf-overrides --fzf-overrides-var --finder -h --help -V --version' -- "$2")
  fi
}

complete -o default -F _navi navi
