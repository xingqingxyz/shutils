_mlr() {
  case "$3" in
    --finder)
      mapfile -t COMPREPLY < <(compgen -W 'fzf skim' -- "$2")
      return
      ;;
  esac
  if [[ $COMP_CWORD == 1 || $2 == -* ]]; then
    mapfile -t COMPREPLY < <(compgen -W 'help -h --help -V --version' -- "$2")
  fi
}

complete -o default -F _mlr mlr
