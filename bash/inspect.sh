vw() {
  if [ $# = 0 ]; then
    if [ -p /dev/stdin ]; then
      bat -plhelp
    else
      vw vw
    fi
    return
  fi
  case "$(type -t "$1")" in
    alias)
      alias "$@" | bat -plsh
      ;;
    builtin | keyword)
      help "$@" | bat -plhelp
      ;;
    file)
      local i files=()
      for i in "$@"; do
        files+=("$(command -v "$i")")
      done
      bat "${files[@]}"
      ;;
    function)
      declare -fp "$@" | bat -plsh
      ;;
    *)
      local i
      for i in "$@"; do
        if [ "${i: -1}" = '*' ]; then
          eval "declare -p \${!$i}"
        else
          declare -p "$i"
        fi
      done | bat -plsh
      ;;
  esac
}
