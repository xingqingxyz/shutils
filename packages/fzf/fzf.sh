# - $FZF_COMPLETION_TRIGGER (default: '*')
# - $FZF_COMPLETION_OPTS    (default: '')

_fzf_compgen_path() {
  (cd -- "$1" && fd -H)
}

_fzf_compgen_dir() {
  (cd -- "$1" && fd -Htd)
}

# $1 = 'path'|'dir'
# ... comp args
_fzf_generic_path_completion() {
  local dir query trigger=${FZF_COMP_TRIGGER:-*} typ=$1
  shift

  if [[ $2 == *"$trigger" ]]; then
    dir=$2
    [[ $dir != */* ]] && dir="./$dir"
    dir=${2%/*}/
    query=${2:${#dir}:-${#trigger}}

    mapfile -t COMPREPLY < <("_fzf_compgen_$typ" "$dir" \
      | FZF_DEFAULT_OPTS+=" --scheme=path" fzf -q "$query")

    if [ ${#COMPREPLY} != 0 ]; then
      COMPREPLY=("${COMPREPLY[@]@Q}")
      COMPREPLY=("${COMPREPLY[@]/#/$dir}")
      case "$typ" in
        path)
          compopt +o nospace
          ;;
        dir)
          compopt -o nospace
          ;;
      esac
      return
    fi
  fi

  # no trigger or fallback
  return 1
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
      _fzf_generic_path_completion path "$@"
      ;;
    *)
      local line user=${2%@*}
      _fzf_compgen_host | while read -r line; do
        echo "$user@$line"
      done
      ;;
  esac
}

_fzf_compgen_variable() {
  declare -p | awk -F '[ =]' '{print $3}'
}

_fzf_compgen_alias() {
  alias | awk -F '[ =]' '{print $2}'
}

_fzf_compgen_proc() {
  ps -eo user,pid,ppid,start,time,command
}

_fzf_compgen_proc_host() {
  cut -d' ' -f2
}

_fzf_completion() {
  local opts=$FZF_DEFAULT_OPTS typ=${_FZF_COMP_TYPEMAP[$1]}
  FZF_DEFAULT_OPTS+=" ${FZF_COMP_OPTS[$1]} --height ${FZF_COMP_HEIGHT:-40%}
  --reverse -m --bind=ctrl-z:ignore"
  if ! case "$typ" in
    path | dir) _fzf_generic_path_completion "$1" "$@" ;;
    '') _fzf_generic_path_completion path "$@" ;;
    *)
      mapfile -t COMPREPLY < <("_fzf_compgen_$typ" | fzf -q "$2")
      if declare -Fp "_fzf_complete_${typ}_post" &> /dev/null; then
        "_fzf_complete_${typ}_post" "$@"
      fi
      ;;
  esac then
    "${_FZF_COMP_BACKUP[$1]-:}" "$@"
  fi
  FZF_DEFAULT_OPTS=$opts
  printf '\e[5n'
}

_fzf_setup_completion() {
  local -A types=(
    [path]='awk bat cat diff diff3 emacs emacsclient ex file ftp g++ gcc gvim head hg hx java javac ld less more mvim nvim patch perl python ruby sed sftp sort source tail tee uniq vi view vim wc xdg-open basename bunzip2 bzip2 chmod chown curl cp dirname du find git grep gunzip gzip hg jar ln ls mv open rm rsync scp svn tar unzip zip'
    [dir]='cd pushd rmdir mkdir tree z'
    [alias]='alias unalias'
    [variable]='export unset let declare readonly'
    [host]='telnet'
    [ssh]='ssh'
    [proc]='kill'
  )
  declare -gA _FZF_COMP_TYPEMAP _FZF_COMP_BACKUP FZF_COMP_OPTS=(
    [dir]='-m --preview="tree -C {} | head -200"'
    [path]='-m --preview="bat --plain --color=always {}"'
    [ssh]='+m --preview="dig {}"'
    [host]='+m'
    [proc]='-m --header-lines=1 --preview "echo {}" --preview-window down:3:wrap --min-height 15'
    [variable]='-m'
    [alias]='-m'
  )
  eval "_FZF_COMP_TYPEMAP=($(for k in "${!types[@]}"; do
    # shellcheck disable=SC2086
    printf "%s $k " ${types[$k]}
  done))"
  # refresh line after complete
  bind '"\e[0n": redraw-current-line'
}

_fzf_completion_loader() {
  declare -Fp _completion_loader &> /dev/null && _completion_loader "$@"
  local dec
  # have not reload or load failed
  [ $? = 124 ] && dec=$(complete -p "$1") || return
  # loaded to -[DEI], not -[FC]
  if [[ $dec =~ ^(.*)?( -C [^ ]+)?( -F [^ ]+)\ (.*)$ ]]; then
    local fn cmd name
    dec=${BASH_REMATCH[1]}
    fn=${BASH_REMATCH[2]}
    cmd=${BASH_REMATCH[3]}
    name=${BASH_REMATCH[4]}
    if [[ $cmd || ($fn && $fn != _minimal) ]]; then
      [ "$fn" ] && _FZF_COMP_BACKUP[$name]=${fn:4}
      eval "$dec $cmd -F _fzf_completion $name"
    fi
  fi
  return 124
}

complete -F _fzf_completion_loader -D

if ! declare -F _fzf_compgen_path > /dev/null; then
  _fzf_compgen_path() {
    echo "$1"
    command find -L "$1" \
      -name .git -prune -o -name .hg -prune -o -name .svn -prune -o \( -type d -o -type f -o -type l \) \
      -a -not -path "$1" -print 2> /dev/null | command sed 's@^\./@@'
  }
fi

if ! declare -F _fzf_compgen_dir > /dev/null; then
  _fzf_compgen_dir() {
    command find -L "$1" \
      -name .git -prune -o -name .hg -prune -o -name .svn -prune -o -type d \
      -a -not -path "$1" -print 2> /dev/null | command sed 's@^\./@@'
  }
fi
