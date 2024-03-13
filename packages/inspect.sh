_mn_preview_env() {
  local val=${!1}
  # PATH like and multi, pretty print
  if [[ :$val: == :*/*:*: ]]; then
    local -a items
    IFS=: read -rd '' -a items < <(echo -n "$val")
    # quote by readable string
    items=("${items[@]@Q}")
    echo "-${1@a} $1 is PATH like, splitted by ':':"
    printf '%02d %s\n' "${items[@]@k}"
  else
    echo "-${1@a} $1:"
    echo "${val@Q}"
  fi
}

_mn_preview_ident() {
  case "$(type -t "$1")" in
    alias)
      alias "$1"
      ;;
    builtin | keyword)
      help "$1"
      ;;
    file)
      "$1" --help 2>&1 | bat --plain -l help
      ;;
    function)
      declare -fp "$1" | bat -nl bash
      ;;
    *)
      if [[ ${!1@a} == *([^aA])x ]]; then
        _mn_preview_env "$1"
      else
        declare -p "$1" | bat --plain -l bash
      fi
      ;;
  esac
}

# pretty print
alias pp=_mn_preview_ident
