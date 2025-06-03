_ngnix() {
  mapfile -t COMPREPLY < <({
    case "$3" in
      -s)
        compgen -W 'stop quit reopen reload' -- "$2"
        ;;
      *)
        false
        ;;
    esac || compgen -W '-? -h -v -V -t -T -q -s -p -e -c -g' -- "$2"
  })
}

complete -o default -F _ngnix ngnix
