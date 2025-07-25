_esbuild() {
  local prev
  if [[ $3 == [:=] ]]; then
    prev=${COMP_WORDS[COMP_CWORD - 2]}
  else
    prev=$3
  fi
  case "$prev" in
    --footer | --banner)
      compopt -o nospace
      mapfile -t COMPREPLY < <(compgen -S = -W 'css js' -- "$2")
      ;;
    --drop)
      mapfile -t COMPREPLY < <(compgen -W 'console debugger' -- "$2")
      ;;
    --color | --tree-shaking)
      mapfile -t COMPREPLY < <(compgen -W 'true false' -- "$2")
      ;;
    --analyze)
      mapfile -t COMPREPLY < <(compgen -W 'verbose' -- "$2")
      ;;
    --watch)
      mapfile -t COMPREPLY < <(compgen -W 'forever' -- "$2")
      ;;
    --format)
      mapfile -t COMPREPLY < <(compgen -W 'iife cjs esm' -- "$2")
      ;;
    --packages)
      mapfile -t COMPREPLY < <(compgen -W 'external' -- "$2")
      ;;
    --platform)
      mapfile -t COMPREPLY < <(compgen -W 'browser node neutral' -- "$2")
      ;;
    --serve)
      mapfile -t COMPREPLY < <(compgen -W '127.0.0.1:3030' -- "$2")
      ;;
    --target)
      mapfile -t COMPREPLY < <(compgen -W 'es2017 chrome58 firefox57 safari11 edge16 node10 ie9 opera45 esnext' -- "$2")
      ;;
    --asset-names | --chunk-names)
      mapfile -t COMPREPLY < <(compgen -W '[name]-[hash]' -- "$2")
      ;;
    --entry-names)
      mapfile -t COMPREPLY < <(compgen -W '[dir]/[name] [hash]' -- "$2")
      ;;
    --jsx-factory)
      mapfile -t COMPREPLY < <(compgen -W 'React.createElement _jsx' -- "$2")
      ;;
    --jsx-fragment)
      mapfile -t COMPREPLY < <(compgen -W 'React.Fragment' -- "$2")
      ;;
    --jsx-import-source)
      mapfile -t COMPREPLY < <(compgen -W 'react vue preact emotion' -- "$2")
      ;;
    --jsx)
      mapfile -t COMPREPLY < <(compgen -W 'automatic preserve' -- "$2")
      ;;
    --legal-comments)
      mapfile -t COMPREPLY < <(compgen -W 'none inline eof linked external' -- "$2")
      ;;
    --line-limit)
      mapfile -t COMPREPLY < <(compgen -W '80 120' -- "$2")
      ;;
    --log-level)
      mapfile -t COMPREPLY < <(compgen -W 'verbose debug info warning error silent' -- "$2")
      ;;
    --log-limit)
      mapfile -t COMPREPLY < <(compgen -W "$(echo -n {0..6})" -- "$2")
      ;;
    --main-fields)
      mapfile -t COMPREPLY < <(compgen -W 'browser,module,main main,module' -- "$2")
      ;;
    --resolve-extensions)
      mapfile -t COMPREPLY < <(compgen -W '.tsx,.ts,.jsx,.js,.css,.json' -- "$2")
      ;;
    --sourcemap)
      mapfile -t COMPREPLY < <(compgen -W 'external inline' -- "$2")
      ;;
    *)
      mapfile -t COMPREPLY < <(compgen -W '--bundle --minify --sourcemap  --spliting --watch --allow-overwrite --analyze --charset=utf8 --ignore-annotations --jsx-dev --jsx-side-effects --keep-names --minify-whitespace --minify-identifiers --minify-syntax --preserve-symlinks --sources-content=false --version' -- "$2")
      local -a opts
      mapfile -t opts < <(compgen -W '--define: --external: --format= --target= --loader: --outdir= --outfile= --packages= --platform= --serve= --asset-names= --banner: --certfile= --chunk-names= --color= --drop: --drop-labels= --entry-names= --footer: --global-name= --inject: --jsx-factory= --jsx-fragment= --jsx-import-source= --jsx= --keyfile= --legal-comments= --line-limit= --log-level= --log-limit= --log-override: --main-fields= --mangle-cache= --mangle-props= --mangle-quoted= --metafile= --out-extension: --outbase= --public-path= --pure: --reserve-props= --resolve-extensions= --serve-fallback= --servedir= --source-root= --sourcefile= --sourcemap= --supported: --tree-shaking= --tsconfig=' -- "$2")
      if [[ ${#COMPREPLY[@]} == 0 && ${#opts[@]} == 1 ]]; then
        compopt -o nospace
      fi
      COMPREPLY+=("${opts[@]}")
      ;;
  esac
}

complete -o default -F _esbuild esbuild
