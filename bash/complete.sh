if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi

# overrides bash_completion/_completion_loader
_completion_loader() {
  if declare -Fp _comp_complete_load &> /dev/null; then
    _comp_complete_load "$@"
    if [ $? = 124 ]; then
      return 124
    fi
  fi
  local name
  name=$(basename -- "$1")
  if [ -f "$BASH_SOURCE/completions/$name.sh" ]; then
    . "$BASH_SOURCE/completions/$name.sh"
    return 124
  fi
  return 1
}

_idefault_complete() {
  mapfile -t COMPREPLY < <(
    compgen -v -S = -- "$2"
    compgen -abckv -A function -- "$2"
  )
}
complete -o bashdefault -o default -o nospace -F _idefault_complete -I
