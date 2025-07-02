_fzf_file_widget() {
  local query items out
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  mapfile -t items < <(eval "${FZF_CTRL_T_COMMAND:-rg -H --files}" \
    | FZF_DEFAULT_OPTS+=" $FZF_CTRL_T_OPTS --height=${FZF_CTRL_T_HEIGHT:-40%} -m --reverse --scheme=path --bind=ctrl-z:ignore" \
      fzf -q "$query") || return
  out=${items[*]@Q}' '
  READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}$out${READLINE_LINE:READLINE_POINT}
  ((READLINE_POINT += ${#out}))
}

_fzf_history() {
  local out
  out=$(
    fc -lr | awk -f "${BASH_SOURCE[0]%/*}/fzf-hist.awk" \
      | FZF_DEFAULT_OPTS+=" ${FZF_CTRL_R_OPTS} --height=${FZF_CTRL_R_HEIGHT:-40%} +m --reverse --wrap --read0 --scheme=history --bind=ctrl-r:toggle-sort --bind=ctrl-z:ignore" \
        fzf -q "${READLINE_LINE:0:READLINE_POINT}"
  ) || return
  out=${out#*$'\t'}
  READLINE_LINE=$out${READLINE_LINE:READLINE_POINT}
  READLINE_POINT=${#out}
}

_fzf_ident() {
  local query out start
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  start=$((READLINE_POINT - ${#query}))
  query=${query%% }
  if [ ${#query} = 0 ]; then
    echo 'no pre query impact performance heavily' >&2
    return 1
  fi
  # alias builtin command keyword variable
  out=$(compgen -abckv -A function -- "$query" \
    | uniq \
    | FZF_DEFAULT_OPTS+=" $FZF_CTRL_O_OPTS --height=${FZF_BIND_HEIGHT:-40%} -m --reverse --bind=ctrl-z:ignore" \
      fzf -q "^$query") || return
  READLINE_LINE=${READLINE_LINE:0:start}$out${READLINE_LINE:READLINE_POINT}
  ((READLINE_POINT = start + ${#out}))
}

_fzf_cd() {
  local query out
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  out=$(eval "${FZF_ALT_C_COMMAND:-fd -Htd}" \
    | FZF_DEFAULT_OPTS+=" ${FZF_ALT_C_OPTS} --height=${FZF_BIND_HEIGHT:-40%} +m --reverse --scheme=path --bind=ctrl-z:ignore" \
      fzf -q "$query") || return
  cd -- "$out"
}

_fzf_z() {
  local query out
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  out=$(_z -L | FZF_DEFAULT_OPTS+=" ${FZF_ALT_Z_OPTS} --height=${FZF_BIND_HEIGHT:-40%} +m --reverse --scheme=path --bind=ctrl-z:ignore" \
    fzf -q "$query") || return
  cd -- "$out"
}

# CTRL-T - Paste the selected file path into the command line
# CTRL-R - Paste the selected command from history into the command line
# CTRL-O - Select any shell ident
# ALT-C  - Change to sub directory
bind -x '"\C-t": _fzf_file_widget'
bind -x '"\C-r": _fzf_history'
bind -x '"\C-o": _fzf_ident'
bind -x '"\ec": _fzf_cd'
bind -x '"\ez": _fzf_z'
