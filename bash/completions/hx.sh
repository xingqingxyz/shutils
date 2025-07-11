_hx() {
  case "$3" in
    -g | --grammar)
      mapfile -t COMPREPLY < <(compgen -W 'fetch build' -- "$2")
      ;;
    --health)
      mapfile -t COMPREPLY < <(
        read -r _ cols < <(stty size)
        stty columns 300
        hx --health | awk -v q="$2" '/^[a-z]/ {if (index($1, q) == 1) print $1}'
        stty columns "$cols"
      )
      ;;
    *)
      [[ $2 == -* ]] || return
      mapfile -t COMPREPLY < <(
        compgen -W "-h --help --tutor -V --version -v -vv -vvv --health -g --grammar --vsplit --hsplit -c --config --log" -- "$2"
      )
      ;;
  esac
}

complete -o default -F _hx hx
