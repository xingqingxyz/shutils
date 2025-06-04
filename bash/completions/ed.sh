_ed() {
  mapfile -t COMPREPLY < <({
    if [[ $2 == !* ]]; then
      compgen -P ! -cf -- "${2:1}"
    else
      compgen -W '+ +/ +? -h --help -V --version -E --extend-regexp -G -traditional -l --loose-exit-status -p --prompt -q --quiet --silent -r --restricted -s --script -v --verbose --strip-trailing-cr --unsafe-names' -- "$2" || compgen -cf -- "$2"
    fi
  })
}

complete -o default -F _ed ed
