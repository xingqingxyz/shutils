_tree-sitter() {
  mapfile -t COMPREPLY < <({
    case "${COMP_WORDS[1]}" in
      # init-config) ;;
      generate)
        case "$3" in
          --js-runtime)
            compgen -W 'node esno bun deno' -- "$2"
            ;;
          *) false ;;
        esac || compgen -W '--log --no-bindings -b --build -0 --debug-build --abi --libdir --report-states-for-rule --js-runtime' -- "$2"
        ;;
      parse)
        case "$3" in
          --encoding)
            compgen -W 'utf-8 utf-16 utf-32 utf8 ascii gb2312 gbk' -- "$2"
            ;;
          *) false ;;
        esac || compgen -W '-d --debug -0 --debug-build -D --debug-graph --wasm --dot -x --xml -s --stat -t --time -q --quiet --paths --scope --timeout -e --edit --encoding' -- "$2"
        ;;
      query)
        compgen -W '-t --time -q --quiet -c --captures --test --paths --byte-range --row-range --scope' -- "$2"
        ;;
      tags)
        compgen -W '-t --time -q --quiet --scope --paths' -- "$2"
        ;;
      tests)
        compgen -W '-u --update -d --debug -0 --debug-build -D --debug-graph --wasm --apply-all-captures -f --filter' -- "$2"
        ;;
      highlight)
        compgen -W '-H --html --check -t --time -q --quiet --apply-all-captures --captures-path --query-paths --scope --paths' -- "$2"
        ;;
      build-wasm)
        compgen -W '--docker' -- "$2"
        ;;
      playground)
        compgen -W '-q --quiet' -- "$2"
        ;;
      *)
        if [ "$COMP_CWORD" = 1 ]; then
          compgen -W 'init-config generate parse query tags test highlight build-wasm playground dump-languages' -- "$2"
        else
          false
        fi
        ;;
    esac || compgen -W '-h --help -V --version' -- "$2"
  })
}

complete -o default -F _tree-sitter tree-sitter
