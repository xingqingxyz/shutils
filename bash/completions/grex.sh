_grex() {
  case "$3" in
    -f | --file) return ;;
  esac
  mapfile -t COMPREPLY < <(compgen -W '-f --file -d --digits -D --non-digits -s --spaces -S --non-spaces -w --words -W --non-words -r --repetitions --min-repetitions --min-substring-length --no-start-anchor --no-end-anchor --no-anchors -x --verbose -c --colorize -i --ignore-case -g --capture-groups -h --help -v --version' -- "$2")
}

complete -o default -F _grex grex
