_fzy() {
  mapfile -t COMPREPLY < <(compgen -W '-l --lines -p --prompt -q --query -e --show-matches -t --tty -s --show-scores -j --workers -h --help -v --version' -- "$2")
}

complete -o default -F _fzy fzy
