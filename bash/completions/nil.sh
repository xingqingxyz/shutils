_nil() {
  mapfile -t COMPREPLY < <({
    case "${COMP_WORDS[1]}" in
      diagnostics | parse | ssr)
        compgen -W '--help' -G '*.nix' -- "$2"
        ;;
      *)
        compgen -W 'diagnostics parse ssr --version --stdio --help' -- "$2"
        ;;
    esac
  })
}

complete -o default -F _nil nil
