_bun() {
  case "$3" in
    pm)
      mapfile -t COMPREPLY < <(compgen -W 'bin ls hash hash-string hash-print cache migrate untrusted trust default-trusted' -- "$2")
      ;;
    cache)
      COMPREPLY=(rm)
      ;;
    --shell)
      mapfile -t COMPREPLY < <(compgen -W 'bun system' -- "$2")
      ;;
    --install)
      mapfile -t COMPREPLY < <(compgen -W 'auto fallback force' -- "$2")
      ;;
    *)
      case "$2" in
        -*)
          case "${COMP_WORDS[*]:1:2}" in
            'pm bin')
              mapfile -t COMPREPLY < <(compgen -W '-g' -- "$2")
              ;;
            'pm ls' | 'pm trust')
              mapfile -t COMPREPLY < <(compgen -W '--all' -- "$2")
              ;;
          esac
          mapfile -O ${#COMPREPLY} -t COMPREPLY < <(compgen -W '--watch --hot --smol -r --preload --inspect --inspect-wait --inspect-brk --if-present --no-install --install -i -e --eval --print --prefer-offline --prefer-latest -p --port --conditions --silent -v --version --revision --filter -b --bun --shell --env-file --cwd -c --config -h --help' -- "$2")
          ;;
        *)
          if [ "$COMP_CWORD" = 1 ]; then
            mapfile -t COMPREPLY < <(compgen -W 'c x i a rm run test repl exec install add remove update link unlink pm build init create upgrade' -- "$2")
          fi
          ;;
      esac
      ;;
  esac
}

complete -o default -o nosort -F _bun bun
