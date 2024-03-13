_fzf_file_widget() {
  local query items out
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  mapfile -t items < <(eval "${FZF_CTRL_T_COMMAND:-fd -H}" \
    | FZF_DEFAULT_OPTS+=" $FZF_CTRL_T_OPTS --height ${FZF_CTRL_T_HEIGHT:-40%}
      --bind=ctrl-z:ignore --reverse -m --scheme=path" fzf -q "$query")
  out=${items[*]@Q}' '
  READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}$out${READLINE_LINE:READLINE_POINT}
  ((READLINE_POINT += ${#out}))
}

_fzf_history() {
  local awk=awk name ver dat opts out
  read -r name ver dat < <(mawk -W version 2> /dev/null)
  if [[ $name == mawk && $(sort -VC <<< $'1.3.4\n'"$ver") && dat -ge 20230302 ]]; then
    awk=mawk
  fi
  opts="${FZF_DEFAULT_OPTS} ${FZF_CTRL_R_OPTS}
    --height ${FZF_CTRL_R_HEIGHT:-40%} --reverse +m --read0 -n2..,..
    --scheme=history --bind=ctrl-r:toggle-sort --bind=ctrl-z:ignore"
  out=$(
    # prevent the time str
    HISTTIMEFORMAT='' fc -lr $((-1 << 31)) 2> /dev/null \
      |
      # TODO: consider HISTCONTROL and not use awk or simplify it
      "$awk" -v hist_cnt="$HISTCMD" -f "${BASH_SOURCE[0]%/*}/fzf-hist.awk" \
      | FZF_DEFAULT_OPTS=$opts fzf -q "${READLINE_LINE:0:$READLINE_POINT}"
  ) || return
  out=${out#*$'\t'}
  READLINE_LINE=$out${READLINE_LINE:READLINE_POINT}
  READLINE_POINT=${#out}
}

_fzf_z() {
  local query out
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  out=$(eval "${FZF_ALT_C_COMMAND:-fd -Htd}" \
    | FZF_DEFAULT_OPTS+=" ${FZF_ALT_C_OPTS} --height ${FZF_BIND_HEIGHT:-40%}
      --bind=ctrl-z:ignore --reverse --scheme=path +m" fzf -q "$query") || return
  echo "cd -- ${out@Q}"
}

_fzf_ident() {
  local query out
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  # alias builtin command keyword variable
  out=$(compgen -abckv -A function \
    | FZF_DEFAULT_OPTS+=" $FZF_CTRL_K_OPTS --height ${FZF_BIND_HEIGHT:-40%}
      --bind=ctrl-z:ignore +m --reverse" fzf -q "$query") || return
  READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}$out${READLINE_LINE:READLINE_POINT}
  ((READLINE_POINT += ${#out}))
}

if ((BASH_VERSINFO[0] < 4)); then
  echo 'bash version < 4 : has not bind ctrl-t ctrl-r' >&2
else
  # CTRL-T - Paste the selected file path into the command line
  bind -m emacs-standard -x '"\C-t": _fzf_file_widget'
  bind -m vi-command -x '"\C-t": _fzf_file_widget'
  bind -m vi-insert -x '"\C-t": _fzf_file_widget'

  # CTRL-R - Paste the selected command from history into the command line
  bind -m emacs-standard -x '"\C-r": _fzf_history'
  bind -m vi-command -x '"\C-r": _fzf_history'
  bind -m vi-insert -x '"\C-r": _fzf_history'

  # CTRL-K Select any shell ident
  bind -m emacs-standard -x '"\C-o": _fzf_ident'
  bind -m vi-command -x '"\C-o": _fzf_ident'
  bind -m vi-insert -x '"\C-o": _fzf_ident'
fi

# Required to refresh the prompt after fzf
bind -m emacs-standard '"\er": redraw-current-line'

# Required by ALT-C
bind -m vi-command '"\C-z": emacs-editing-mode'
bind -m vi-insert '"\C-z": emacs-editing-mode'
bind -m emacs-standard '"\C-z": vi-editing-mode'

# ALT-C - cd into the selected directory
bind -m emacs-standard '"\ec": " \C-b\C-k \C-u$(_fzf_z)\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
bind -m vi-command '"\ec": "\C-z\ec\C-z"'
bind -m vi-insert '"\ec": "\C-z\ec\C-z"'
