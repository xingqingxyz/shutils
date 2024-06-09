_pan() {
  mapfile -t COMPREPLY < <(compgen -W '-h --help -v --version --verbose --debug --debug-ssl --nzb -o --output --no-gui' -- "$2")
}

complete -o default -F _pan pan
