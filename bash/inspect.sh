vw() {
  if [ $# = 0 ]; then
    if [ -p /dev/stdin ]; then
      bat -plhelp
    else
      vw vw
    fi
    return
  fi
  while [ "$1" ]; do
    case "$(type -t "$1")" in
      alias)
        alias "$1" | bat -plsh
        ;;
      builtin | keyword)
        help "$1" | bat -plhelp
        ;;
      file)
        bat "$(command -v "$1")"
        ;;
      function)
        declare -fp "$1" | bat -plsh
        ;;
      *)
        if [ "${1: -1}" = '*' ]; then
          eval "declare -p \${!$1}"
        else
          declare -p "$1"
        fi | bat -plsh
        ;;
    esac
    shift
  done
}
