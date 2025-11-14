l() {
  if [ $# = 0 ]; then
    if [ -p /dev/stdin ]; then
      bat -plhelp
    else
      l "$PWD"
    fi
    return
  fi
  case "$(type -t -- "$1")" in
    alias)
      alias -- "$@" | bat -plsh
      ;;
    builtin | keyword)
      help -- "$@" | bat -plhelp
      ;;
    file)
      local i files=()
      for i in "$@"; do
        files+=("$(command -v -- "$i")")
      done
      bat -p "${files[@]}"
      ;;
    function)
      declare -fp -- "$@" | bat -plsh
      ;;
    *)
      # not found
      local i
      # maybe variable
      if [ "${1: -1}" = '*' ]; then
        eval "declare -p -- \${!$1}" | bat -plsh
        shift
        l "$@"
      elif [ -v "$1" ]; then
        declare -p -- "$@" | bat -plsh
      elif [ -d "$1" ]; then
        # maybe directory
        command ls -lah --color=always --hyperlink=always -- "$@" | less
      else
        shift
        l "$@"
      fi
      ;;
  esac
}

e() {
  local editor=${EDITOR:-edit}
  if [ $# = 0 ]; then
    if [ -p /dev/stdin ]; then
      "$editor" "$@"
    else
      e e
    fi
    return
  fi
  case "$(type -t -- "$1")" in
    alias)
      alias -- "$@" | bat -plsh
      ;;
    builtin | keyword)
      help -- "$@" | bat -plhelp
      ;;
    file)
      local i files=()
      for i in "$@"; do
        files+=("$(command -v -- "$i")")
      done
      "$editor" "${files[@]}"
      ;;
    function)
      declare -fp -- "$@" | bat -plsh
      ;;
    *)
      # not found
      # maybe variable
      if [ -d "$1" ]; then
        # maybe directory
        command ls -lah --color=always --hyperlink=always -- "$@" | less
      else
        "$editor" "$@"
      fi
      ;;
  esac
}
