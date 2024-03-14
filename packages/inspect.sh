_mn_preview_ident() {
  while [ "$1" ]; do
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
        local vars
        if [[ $1 == *'*' ]]; then
          eval "vars=(\${!$1})"
        else
          vars=("$1")
        fi
        declare -p "${vars[@]}" | bat --plain -l bash
        ;;
    esac
    shift
  done
}

# pretty print
alias pp=_mn_preview_ident
