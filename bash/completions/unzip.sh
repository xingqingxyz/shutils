_unzip() {
  mapfile -t COMPREPLY < <(compgen -W '-p -f -u -v -x -n -o -j -U -C -X -K -l -t -z -T -d -q -a -aa -UU -L -V -M' -- "$2")
}

complete -o default -F _unzip unzip
