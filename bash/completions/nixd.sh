_nixd() {
  mapfile -t COMPREPLY < <({
    case "$3" in
      --role)
        compgen -W 'controller evaluator option' -- "$2"
        ;;
      --log)
        compgen -W 'debug error info verbose' -- "$2"
        ;;
      --input-style)
        compgen -W 'delimited standard' -- "$2"
        ;;
      *)
        false
        ;;
    esac || compgen -W '--help --help-hidden --help-list --help-list-hidden --input-style --lit-test --log --pretty --print-all-options --print-options --role --version --wait-worker' -- "$2"
  })
}

if [ -x "$(type -P nixd-next)" ]; then
  complete -o default -F _nixd nixd-next
fi

complete -o default -F _nixd nixd
