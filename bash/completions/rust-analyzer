_rust-analyzer() {
  mapfile -t COMPREPLY < <({
    case "${COMP_WORDS[1]}" in
      parse)
        compgen -W '--no-dump' -- "$2"
        ;;
      highlight)
        compgen -W '--rainbow' -- "$2"
        ;;
      analysis-stats)
        compgen -W '--disable-build-scripts --disable-proc-macros --no-sysroot -o --only --output --parallel --randomize --run-all-ide-things --skip-const-eval --skip-data-layout --skip-inference --skip-lowering --skip-mir-stats --source-stats --with-deps' -- "$2"
        ;;
      rustc-tests)
        compgen -W '--filter' -- "$2"
        ;;
      diagnostics)
        compgen -W '--disable-build-scripts --disable-proc-macros --proc-macros-srv' -- "$2"
        ;;
      search)
        compgen -W '--debug' -- "$2"
        ;;
      scip)
        compgen -W '--config-path --output' -- "$2"
        ;;
      *)
        if [[ "$COMP_CWORD" = 1 || "$2" = -* ]]; then
          compgen -W 'analysis-stats diagnostics -h --help highlight --log-file lsif --no-log-buffering parse --print-config-schema -q --quiet run-tests rustc-tests scip search ssr symbols -v --verbose --version --wait-dbg' -- "$2"
        fi
        ;;
    esac
  })
}

complete -o default -F _rust-analyzer rust-analyzer
