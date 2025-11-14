_fzf_file_widget() {
  local query items out args=(
    -m
    --reverse
    '--scheme=path'
    "--query=$query"
    "--height=${FZF_CTRL_T_HEIGHT:-40%}"
    '--bind=ctrl-z:ignore'
  )
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  mapfile -t items < <(eval "${FZF_CTRL_T_COMMAND:-rg --files}" \
    | FZF_DEFAULT_OPTS+=" $FZF_CTRL_T_OPTS" fzf "${args[@]}") || return
  out=${items[*]@Q}' '
  READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}$out${READLINE_LINE:READLINE_POINT}
  ((READLINE_POINT += ${#out}))
}

_fzf_history() {
  local out args=(
    +m
    --read0
    --wrap
    --reverse
    '--scheme=history'
    "--query=${READLINE_LINE:0:READLINE_POINT}"
    "--height=${FZF_CTRL_R_HEIGHT:-40%}"
    '--bind=ctrl-r:toggle-sort'
    '--bind=ctrl-z:ignore'
  )
  out=$(fc -lr | awk '
    /^[0-9]+\t \S/ {
      if (NR > 1) {
        items[i++] = item
      }
      item = $0
      next
    }
    {
      item = item RS $0
    }
    END {
      items[i] = item
      for (i in items) {
        printf "%s\0", items[i]
      }
    }' | FZF_DEFAULT_OPTS+=" $FZF_CTRL_R_OPTS" fzf "${args[@]}") || return
  out=${out#*$'\t'}
  READLINE_LINE=$out${READLINE_LINE:READLINE_POINT}
  READLINE_POINT=${#out}
}

_fzf_ident() {
  local query out start args=(
    -m
    --reverse
    "--query=^$query"
    "--height=${FZF_BIND_HEIGHT:-40%}"
    '--bind=ctrl-z:ignore'
  )
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  start=$((READLINE_POINT - ${#query}))
  query=${query%% }
  if [ ${#query} = 0 ]; then
    echo 'no pre query impact performance heavily' >&2
    return 1
  fi
  # alias builtin command keyword variable
  out=$(compgen -abckv -A function -- "$query" | uniq \
    | FZF_DEFAULT_OPTS+=" $FZF_CTRL_O_OPTS" fzf "${args[@]}") || return
  READLINE_LINE=${READLINE_LINE:0:start}$out${READLINE_LINE:READLINE_POINT}
  ((READLINE_POINT = start + ${#out}))
}

_fzf_cd() {
  local query out args=(
    +m
    --reverse
    '--walker=dir,hidden'
    '--scheme=path'
    "--query=$query"
    "--height=${FZF_BIND_HEIGHT:-40%}"
    '--bind=ctrl-z:ignore'
  )
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  out=$(FZF_DEFAULT_OPTS+=" $FZF_ALT_C_OPTS" fzf "${args[@]}") || return
  cd -- "$out"
}

_fzf_z() {
  local query out args=(
    +m
    --reverse
    '--scheme=path'
    "--query=$query"
    "--height=${FZF_BIND_HEIGHT:-40%}"
    '--bind=ctrl-z:ignore'
  )
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  out=$(_z -L | FZF_DEFAULT_OPTS+=" $FZF_ALT_Z_OPTS" fzf "${args[@]}") || return
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
