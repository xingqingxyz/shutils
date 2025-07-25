_pp() {
  if [ "$COMP_CWORD" = 1 ]; then
    mapfile -t COMPREPLY < <(compgen -cv \
      | FZF_DEFAULT_OPTS+=" --height ${FZF_BIND_HEIGHT:-40%}
        --bind=ctrl-z:ignore -m -0 -1 --reverse -q '$2'" fzf) || return
    COMPREPLY=("${COMPREPLY[*]}")
    printf '\e[5n'
  else
    mapfile -t COMPREPLY < <(compgen -cv -- "$2")
  fi
}

complete -o bashdefault -F _pp pp
