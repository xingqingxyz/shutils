# -- FZF_COMP_TRIGGER (default: '*')
# -- FZF_COMP_HEIGHT  (default: 40%)
# -A FZF_COMP_OPTS    ...
# -A FZF_COMP_TYPEMAP ...

# $1 = 'path'|'dir'
# ... comp args
_fzf_complete_path() {
  # fallback
  [[ $3 == *"${FZF_COMP_TRIGGER:-*}" ]] || return

  local dir=${3%"${FZF_COMP_TRIGGER:-*}"} query fd_flag

  # expands after remove trigger
  # shellcheck disable=SC2086
  printf -v dir %s $3

  [[ $dir != */* ]] && dir=./$dir
  # ./abc => ./; /abc => /
  dir=${dir%/*}/

  case "$1" in
    dir | gen_dir) fd_flag=-Htd ;;
    path | gen_path) fd_flag=-H ;;
  esac
  if [[ $1 == gen_* ]]; then
    # compgen must be called in subshell
    cd -- "$dir" && fd "$fd_flag"
    return
  fi

  query=${3:${#dir}}
  mapfile -t COMPREPLY < <(cd -- "$dir" && fd "$fd_flag" | fzf -q "$query")

  # cancels from tui and no need to fallback
  [ ${#COMPREPLY} = 0 ] && return
  # quote $dir to prevent erasing '&'
  COMPREPLY=("${COMPREPLY[@]/#/"$dir"}")
  # only produce one result for multi select
  COMPREPLY=("${COMPREPLY[*]@Q}")
}

_fzf_compgen_host() {
  {
    # ssh_config
    sed -En 's/^\s*host(name)?\s+([^*?%]+).*/\2/p' ~/.ssh/config ~/.ssh/config.d/* /etc/ssh/ssh_config
    # ssh_known_hosts
    sed -En 's/^([[:alnum:].,:[-]+).*/\1/;T;s/\[//g;y/,/\n/;p' ~/.ssh/known_hosts /etc/ssh/ssh_known_hosts
    # hosts
    sed -En '/^\s*[^#$]/s/^\s*[[:digit:].]+\s+(\S+).*/\1/p' /etc/hosts
  } 2> /dev/null | sort -u
}

_fzf_compgen_ssh() {
  case "$3" in
    -i | -F | -E)
      _fzf_complete_path gen_path "$@"
      ;;
    *)
      local user=${2%@*}
      _fzf_compgen_host | while read -r line; do
        echo "$user@$line"
      done
      ;;
  esac
}

_fzf_compgen_variable() {
  compgen -v
}

_fzf_compgen_alias() {
  compgen -a
}

_fzf_compgen_proc() {
  ps -eo user,pid,ppid,start,time,command
}

_fzf_complete_proc_host() {
  COMPREPLY=("${COMPREPLY[@]#* }")
  COMPREPLY=("${COMPREPLY[@]%% *}")
}

_fzf_complete() {
  local typ=${_FZF_COMP_TYPEMAP[$1]-path}
  if case "$typ" in
    path | dir) _fzf_complete_path "$typ" "$@" ;;
    *)
      mapfile -t COMPREPLY < <(
        FZF_DEFAULT_OPTS+=" --height ${FZF_COMP_HEIGHT:-40%} --reverse ${FZF_COMP_OPTS[$1]}" \
          "_fzf_compgen_$typ" "$@" | fzf -q "$2"
      )
      # some completer need set compopt, must not be subshell
      if declare -Fp "_fzf_complete_${typ}_post" &> /dev/null; then
        "_fzf_complete_${typ}_post" "$@"
      fi
      # conduct to one
      COMPREPLY=("${COMPREPLY[*]}")
      ;;
  esac then
    printf '\e[5n'
  else
    # fallback
    "${_FZF_COMP_BACKUP[$1]-:}" "$@"
  fi
}

_fzf_setup_completion() {
  local -A types=(
    [dir]='cd pushd rmdir mkdir tree z'
    [alias]='alias unalias'
    [variable]='export unset let declare readonly local'
    [host]='telnet'
    [ssh]='ssh'
    [proc]='kill'
  )
  declare -gA _FZF_COMP_TYPEMAP _FZF_COMP_BACKUP FZF_COMP_OPTS=(
    [dir]='-m --scheme=path --preview="tree -C {} | head -200"'
    [path]='-m --scheme=path --preview="bat --plain --color=always {}"'
    [alias]='-m'
    [variable]='-m'
    [ssh]='+m --preview="dig {}"'
    [host]='+m'
    [proc]='-m --header-lines=1 --preview "echo {}" --preview-window down:3:wrap --min-height 15'
  )
  eval "_FZF_COMP_TYPEMAP=($(for k in "${!types[@]}"; do
    # shellcheck disable=SC2086
    printf "%s $k " ${types[$k]}
  done))"
  # refresh line after complete
  bind '"\e[0n": redraw-current-line'
}

_fzf_completion_loader() {
  local dec
  declare -Fp _completion_loader &> /dev/null && _completion_loader "$@"
  # have not reload or load failed
  [ $? = 124 ] && dec=$(complete -p "$1") || return
  if [[ $dec =~ ^(.*)?( -C [^ ]+)?( -F [^ ]+)\ (.*)$ ]]; then
    local cmd fn name
    dec=${BASH_REMATCH[1]}
    cmd=${BASH_REMATCH[2]}
    fn=${BASH_REMATCH[3]:4}
    name=${BASH_REMATCH[4]}
    # ensure loaded to -[FC]
    if [[ $cmd || ($fn && $fn != _minimal) ]]; then
      [ "$fn" ] && _FZF_COMP_BACKUP[$name]=$fn
      eval "$dec $cmd -F _fzf_complete $name"
    fi
  fi
  return 124
}

_fzf_setup_completion
complete -F _fzf_completion_loader -D

unset -f _fzf_setup_completion
