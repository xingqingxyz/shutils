_prettierd() {
  if [ "$COMP_CWORD" = 1 ]; then
    mapfile -t COMPREPLY < <(compgen -W 'start stop restart status invoke' -- "$2")
  elif [[ $2 == -* ]]; then
    mapfile -t COMPREPLY < <(compgen -W '--help --version --ignore-path --no-color --debug-info' -- "$2")
  fi
}

complete -o default -F _prettierd prettierd
