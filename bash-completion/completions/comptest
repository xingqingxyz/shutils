_comptest() {
  local out
  out=$(compgen -W 'hello world --help --version -v -h' | fzf --height 40% --reverse -m)
  # mapfile -t COMPREPLY < <(compgen -W 'hello world --help --version -v -h' | fzf --height 40% --reverse -m)
  COMPREPLY=("$out")
  printf '\e[5n'
}

complete -F _comptest comptest

alias comptest=:
