_sad() {
  mapfile -t COMPREPLY < <({
    case "$3" in
      -f | --flags)
        compgen -P "$2" -W 'i m s u x I M S U X'
        ;;
      -p | --pager | --fzf)
        compgen -W 'disable' -- "$2"
        ;;
      *)
        false
        ;;
    esac || compgen -W '-0 --read0 -k --commit -e --exact -f --flags -p --pager --fzf -u --unified -h --help -V --version' -- "$2"
  })
}

complete -o default -F _sad sad
