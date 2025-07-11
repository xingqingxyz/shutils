_lazygit() {
  if [[ $COMP_CWORD == 1 || $2 == -* ]]; then
    mapfile -t COMPREPLY < <(compgen -W '-h --help -p --path -f --filter -v --version -d --debug -l --logs -c --config -cd --print-config-dir -ucd --use-config-dir -w --work-tree -g --git-dir -ucf --use-config-file status branch log stash' -- "$2")
  fi
}

complete -o default -F _lazygit lazygit
