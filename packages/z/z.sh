if [ ! -O "${_Z_DATA:-$HOME/.z}" ]; then
  echo "z data file not owned (${_Z_DATA:-$HOME/.z})" >&2
  return 1
fi

_z_help() {
  cat << 'EOF'
Usage:  z [-ehlrtx] [--] ...<search>

Z, jumps to most frecently used directory.

Options
        -c force search cwd
        -e echo instead of cd
        -h display this help message
        -l list instead of cd
        -r rank based sort
        -t time based sort
        -x remove dirs (or $PWD) from z data
EOF
}

_z_dirs() {
  # do not handle file exists there
  local line
  while read -r line; do
    [ -d "${line%%|*}" ] && echo "$line"
  done < "$datafile"
}

_z_rmdirs() {
  [ -f "$datafile" ] || return
  shift
  local pat dir dirs
  if [ $# = 0 ]; then
    dirs=("$PWD")
  else
    dirs=("$@")
  fi
  for dir in "${dirs[@]}"; do
    if [ "$_Z_RESOLVE_SYMLINKS" ]; then
      dir=$(realpath "$dir")
    else
      dir=$(realpath -s "$dir")
    fi || continue
    pat+="\|^$dir\||d;"
    _Z_EXCLUDE_DIRS+=":$dir"
  done
  [ "$pat" ] && sed -i "$pat" "$datafile"
}

_z() {
  local datafile=${_Z_DATA:-$HOME/.z}

  if [ "$COMP_CWORD" ]; then
    # shell completion
    [ -f "$datafile" ] || return
    local pat
    # space for $# = 0 or finally to '*'
    pat=${COMP_WORDS[*]//-*/}' '
    pat=' '${pat#* }
    pat=${pat//+( )/*}
    mapfile -t COMPREPLY < <(
      [[ $pat =~ [[:upper:]] ]] || shopt -s nocasematch
      _z_dirs | while IFS='|' read -r dir _; do
        # shellcheck disable=SC2053
        [[ $dir == $pat ]] && echo "$dir"
      done
    )
  elif [ "$1" = --add ]; then
    # prompt hook
    local exclude out
    # skip non sensitive
    [[ $2 == @(/|$HOME) ]] && return
    # skip excluded
    while read -rd: exclude; do
      # assume exclude is standard syntax (no dup, no trailing)
      [[ $exclude && $2/ == $exclude/* ]] && return
    done <<< "$_Z_EXCLUDE_DIRS" # dir path not startwith '\n'

    out=$(
      ([ -f "$datafile" ] && _z_dirs || true) \
        | awk -F'|' -v dir="$2" -v max_size="${_Z_MAX_SCORE:-9000}" \
          -f "${BASH_SOURCE[0]%/*}/age.awk"
    ) && cat <<< "$out" > "$datafile"
  else
    # main
    local fnd last typ ech list
    [ $# = 0 ] && list=1
    while [ "$1" ]; do
      case "$1" in
        --)
          shift
          fnd+=${fnd:+ }$*
          last=${*: -1}
          break
          ;;
        -*)
          local i
          for ((i = 1; i < ${#1}; i++)); do
            case "${1:i:1}" in
              c)
                if [ "$_Z_RESOLVE_SYMLINKS" ]; then
                  fnd="^$(pwd -P) $fnd"
                else
                  fnd="^$PWD $fnd"
                fi
                ;;
              e) ech=1 ;;
              l) list=1 ;;
              r) typ='rank' ;;
              t) typ='time' ;;
              h)
                _z_help
                return
                ;;
              x)
                _z_rmdirs "$@"
                return
                ;;
              *)
                echo "invalid option -${1:i:1}, have you forget '--' ?" >&2
                return 1
                ;;
            esac
          done
          ;;
        *)
          fnd+=${fnd:+ }$1
          last=$1
          ;;
      esac
      shift
    done

    if [[ $last == /* ]]; then
      # shellcheck disable=SC2164
      cd -- "$last"
      return
    fi

    [ -f "$datafile" ] || return

    if [ -z "$list$ech" ]; then
      read -r fnd
      # shellcheck disable=SC2164
      [ "$fnd" != / ] && cd -- "$fnd"
    else
      cat
    fi < <(_z_dirs | awk -F'|' -v list="$list" -v typ="$typ" -v q="$fnd" \
      -f "${BASH_SOURCE[0]%/*}/frecent.awk")
  fi
}

# shellcheck disable=2139
alias "${_Z_CMD:-z}=_z"

complete -o nosort -o nospace -o default -F _z "${_Z_CMD:-z}"

if [[ $PROMPT_COMMAND != *'(_z --add'* ]]; then
  # use sub shells to silent shell job msg
  if [ "$_Z_RESOLVE_SYMLINKS" ]; then
    PROMPT_COMMAND+='; (_z --add "$(pwd -P)" &)'
  else
    PROMPT_COMMAND+='; (_z --add "$PWD" &)'
  fi
fi
