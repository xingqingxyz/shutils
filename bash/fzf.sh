# -- FZF_COMP_TRIGGER (default: '*')
# -- FZF_COMP_HEIGHT  (default: 40%)
# -A FZF_COMP_FZFOPTS    ...
# -A FZF_COMP_CMDTYPE ...

_fzf_compgen_file() {
  rg --hidden --no-ignore --files -- "$(dirname -- "$2")"
}

_fzf_compgen_file_post() {
  COMPREPLY=("${COMPREPLY[*]@Q}")
}

_fzf_compgen_dir() {
  fd -HILtd --search-path="$(dirname -- "$2")"
}

_fzf_compgen_dir_post() {
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
      _fzf_compgen_file "$@"
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

_fzf_compgen_command() {
  compgen -abckv -A function -- "${2%"${FZF_COMP_TRIGGER:-*}"}" | sort -u
}

_fzf_complete() {
  local typ=${FZF_COMP_CMDTYPE[$1]-file} query=$2
  if [[ $2 != *"${FZF_COMP_TRIGGER:-*}" ]]; then
    ${_FZF_COMP_BACKUP[$1]-:} "$@"
    return
  fi
  query=${query%"${FZF_COMP_TRIGGER:-*}"}
  mapfile -t COMPREPLY < <("_fzf_compgen_$typ" "$@" \
    | FZF_DEFAULT_OPTS+=" --reverse ${FZF_COMP_OPTS[$typ]}" fzf -q "$query")
  # some completer need set compopt, must not be subshell
  if declare -Fp "_fzf_compgen_${typ}_post" &> /dev/null; then
    _fzf_compgen_${typ}_post "$@"
  else
    COMPREPLY=("${COMPREPLY[*]}")
  fi
}

_fzf_completion_loader() {
  local dec
  _completion_loader "$@"
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

_fzf_setup_completion() {
  local -A commands=(
    [command]='vw sudo npx pnpx env'
    [dir]='cd pushd rmdir mkdir tree z'
    [file]='vim vi code bat less grep cat cp rm'
    [alias]='alias unalias'
    [variable]='export unset let declare readonly local'
    [host]='telnet'
    [ssh]='ssh'
  )
  declare -gA FZF_COMP_CMDTYPE _FZF_COMP_BACKUP FZF_COMP_OPTS=(
    [command]='-m'
    [dir]='-m --scheme=path --preview="tree -C {} | head -200"'
    [file]='-m --scheme=path --preview="bat -p --color=always {}"'
    [alias]='-m'
    [variable]='-m'
    [ssh]='+m'
    [host]='+m'
  ) FZF_COMP_BASHOPTS=(
    [command]='-o bashdefault -o default'
    [dir]='-o bashdefault -o default'
    [file]='-o bashdefault -o default'
    [alias]='-o bashdefault -o default -o nospace'
    [variable]='-o bashdefault -o default -o nospace'
    [ssh]='-o bashdefault -o default'
    [host]='-o bashdefault -o default'
  )
  eval "FZF_COMP_CMDTYPE=($(for t in "${!commands[@]}"; do
    printf "[%s]=$t " ${commands[$t]}
  done))"
  if declare -Fp _completion_loader &> /dev/null; then
    complete -o bashdefault -o default -F _fzf_completion_loader -D
    return
  fi
  local i t
  for i in "${!FZF_COMP_CMDTYPE[@]}"; do
    t=${FZF_COMP_CMDTYPE[$i]}
    complete ${FZF_COMP_BASHOPTS[$t]} -F _fzf_complete "$i"
  done
}

_fzf_setup_completion && unset -f _fzf_setup_completion
