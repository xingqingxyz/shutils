_fzf_file_widget() {
  local query items out args=(
    -m
    --reverse
    '--scheme=path'
    '--walker=file,follow,hidden'
    "--query=$query"
    "--height=${FZF_CTRL_T_HEIGHT:-40%}"
    '--bind=ctrl-z:ignore'
    '--preview="bat -p --color=always {}"'
  )
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  mapfile -t items < <(fzf "${args[@]}") || return
  out=${items[*]@Q}' '
  READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}$out${READLINE_LINE:READLINE_POINT}
  ((READLINE_POINT += ${#out}))
}

_fzf_history() {
  local out args=(
    +m
    --wrap
    --reverse
    '--scheme=history'
    "--query=${READLINE_LINE:0:READLINE_POINT}"
    "--height=${FZF_CTRL_R_HEIGHT:-40%}"
    '--bind=ctrl-r:toggle-sort'
    '--bind=ctrl-z:ignore'
  )
  out=$(fzf "${args[@]}" < ~/.bash_history) || return
  out=${out#*$'\t'}
  READLINE_LINE=$out${READLINE_LINE:READLINE_POINT}
  READLINE_POINT=${#out}
}

_fzf_ident() {
  local query out start args
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  start=$((READLINE_POINT - ${#query}))
  query=${query%% }
  if [ ${#query} = 0 ]; then
    echo 'no pre query impact performance heavily' >&2
    return 1
  fi
  args=(
    -1
    -m
    --reverse
    "--query=^$query"
    "--height=${FZF_BIND_HEIGHT:-40%}"
    '--bind=ctrl-z:ignore'
  )
  # alias builtin command keyword variable
  out=$(compgen -abckv -A function -- "$query" | uniq | fzf "${args[@]}") || return
  READLINE_LINE=${READLINE_LINE:0:start}$out${READLINE_LINE:READLINE_POINT}
  ((READLINE_POINT = start + ${#out}))
}

_fzf_cd() {
  local query out args=(
    +m
    --reverse
    '--walker=dir,follow,hidden'
    '--scheme=path'
    "--query=$query"
    "--height=${FZF_BIND_HEIGHT:-40%}"
    '--bind=ctrl-z:ignore'
  )
  query=${READLINE_LINE:0:READLINE_POINT}
  query=${query##* }
  out=$(fzf "${args[@]}") || return
  cd -- "$out"
  echo -e "\\n$out"
}

_fzf_stars() {
  local query out args=(
    +m
    --reverse
    '--scheme=path'
    "--query=$query"
    "--height=${FZF_BIND_HEIGHT:-40%}"
    '--bind=ctrl-z:ignore'
  )
  out=$(fzf "${args[@]}" < "$WISH_ROOT/scripts/data/stars.txt") || return
  READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}$out${READLINE_LINE:READLINE_POINT}
  ((READLINE_POINT += ${#out}))
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
  out=$(_z -L | fzf "${args[@]}") || return
  cd -- "$out"
}

_man_first_word() {
  local word
  word=${READLINE_LINE##+( )}
  word=${word%% *}
  if [ ! "$word" ]; then
    echo 'no first word' >&2
    return 1
  fi
  man "$word"
}

_toggle_venv() {
  if declare -Fp deactivate &> /dev/null; then
    deactivate
    return
  fi
  local root=$PWD venv_path
  while [[ $root != / ]]; do
    venv_path=$root/.venv
    if [[ -d $venv_path ]]; then
      case "$OSTYPE" in
        msys | cygwin)
          . "$venv_path/Scripts/activate"
          ;;
        *)
          . "$venv_path/bin/activate"
          ;;
      esac
      break
    fi
    root=${root%/*}
  done
}

# F1     - Man first word
# Ctrl-T - Paste the selected file path into the command line
# Ctrl-R - Paste the selected command from history into the command line
# Ctrl-O - Select any shell ident
# Alt-c  - Change to sub directory
# Alt-S  - Select github stared repo
# Alt-z  - Change to directory from z history
# Alt-v  - Toggle .venv environment
# Alt-d  - Prepend delay to readline and accept
# Alt-s  - Prepend sudo to readline and accept
# Alt-x  - Prepend x to readline and accept
bind -x '"\e[11~": _man_first_word'
bind -x '"\eOP": _man_first_word'
bind -x '"\C-t": _fzf_file_widget'
bind -x '"\C-r": _fzf_history'
bind -x '"\C-o": _fzf_ident'
bind -x '"\ec": _fzf_cd'
bind -x '"\eS": _fzf_stars'
bind -x '"\ez": _fzf_z'
bind -x '"\ev": _toggle_venv'
# bind -x calcs code by utf8.getbytes(code).sum().mod(0xff); if ret < 0x80: ret = 0xff - ret
bind -x '"\e\250": READLINE_LINE="delay 12m $READLINE_LINE &"'
bind '"\ed": "\e\250\C-j"'
bind -x '"\e\337": READLINE_LINE="sudo $READLINE_LINE"'
bind '"\es": "\e\337\C-j"'
bind -x '"\e\333": READLINE_LINE="x $READLINE_LINE"'
bind '"\ex": "\e\333\C-j"'
