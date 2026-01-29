l() {
  if [ $# = 0 ]; then
    if [ -p /dev/stdin ]; then
      bat -plhelp
    else
      l "$PWD"
    fi
    return
  fi
  while [ $# != 0 ]; do
    case "$(type -t -- "$1")" in
      alias)
        alias -- "$1" | bat -plsh
        ;;
      builtin | keyword)
        help -- "$1" | bat -plhelp
        ;;
      file)
        bat -p "$1"
        ;;
      function)
        declare -fp -- "$1" | bat -plsh
        ;;
      *)
        # not found
        local i
        # maybe variable
        if [ "${1: -1}" = '*' ]; then
          eval "declare -p -- \${!$1}" | bat -plsh
        elif [ -v "$1" ]; then
          declare -p -- "$1" | bat -plsh
        elif [ -d "$1" ]; then
          # maybe directory
          command ls -lah --color=always --hyperlink=always -- "$1" | less
        else
          bat -p "$1"
        fi
        ;;
    esac
    shift
  done
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
      "$editor" "$@"
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
