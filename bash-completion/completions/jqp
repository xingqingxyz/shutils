_jqp() {
  mapfile -t COMPREPLY < <({
    case "$3" in
      -t | --theme)
        compgen -W 'auto dark light' -- "$2"
        ;;
      *) false ;;
    esac || compgen -W '--config -f --file -h --help -t --theme -v --version' -- "$2"
  })
}

complete -o default -F _jqp jqp
