eval "$(ast-grep completions bash)"

if alias sg 2> /dev/null | grep -qF ast-grep; then
  _sg() {
    _ast-grep "$@"
    if [ "${#COMPREPLY[@]}" = 0 ]; then
      mapfile -t COMPREPLY < <(compgen -W '-v --version -h --help' -- "$2")
    fi
  }
  complete -o default -F _sg sg
fi
