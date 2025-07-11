_nvim() {
  case "$3" in
    -u)
      mapfile -t COMPREPLY < <(compgen -W 'NONE NORC' -- "$2")
      ;;
    -i)
      mapfile -t COMPREPLY < <(compgen -W 'NONE' -- "$2")
      ;;
    *)
      if [[ $2 == -V* ]]; then
        compopt -o nospace
        if [[ $2 == -V*([[:digit:]]) ]]; then
          mapfile -t COMPREPLY < <(compgen -W "$(echo -n -V{0..16})" -- "$2")
        else
          mapfile -t COMPREPLY < <(compgen -P "$(grep -oP '^-V\d+' <<< "$2")" -f -- "${2##-V+([[:digit:]])}")
        fi
        return
      fi
      local -A opt_desc=(
        -t '{tag} Lookup in tags file, locate to it'
        -q '[errorfile] Read errors from errorfile and displays/goto first error'
        --help ''
        -h ''
        -? ''
        --version ''
        -v ''
        --clean 'no Write shada file, exclude user directories from rtp'
        --noplugin 'Load vimrc but no plugins'
        --startuptime '{fname} Write time logs to fname'
        + '+[num]'
        +/ '+/{pat}'
        + '+{command} Execute command after read first file, can be used up to 10 times'
        -c '{command} Equivalent to +{command}i'
        --cmd '{command} Execute command before processing any vimrc file'
        -S '[file] Equivalent to -c "source {file}"'
        -r 'Recovery mode, need reads a swap file'
        -L 'Equivalent to -r'
        -R 'Readonly mode'
        -m 'Modifications not allowed to be written'
        -M 'Modifications not allowed'
        -e 'Ex mode, if stdin is not a TTY, executes stdin as Ex commands'
        -E 'Ex mode, never executes stdin as Ex commands'
        -es 'Script mode, no UI, user config is skipped, swap file is skipped, shada is loaded, if stdin, executes as Ex commands'
        -Es 'Script mode, never executes stdin as Ex commands'
        -l '{script} [args] Execute Lua {script}, no UI, with [args], skip user config, disable plugins, shada and swap file'
        -ll '{script} [args] Execute lua {script}, but no vim apis, cannot precede arguments'
        -b 'Binary mode'
        -A 'Arabic mode'
        -H 'Hebrew mode'
        -V '-V[N] Verbose, set verbose to [N]'
        -V '-V[N]{file} Verbose, set verbosefile to {verbosefile}'
        -D 'Debugging'
        -n 'No swap file'
        -o '-o[N] Open N windows, split horizontally'
        -O '-O[N] Open N windows, split vertically'
        -p '-p[N] Open N tab pages'
        -d 'Diff mode'
        -u '{vimrc} The file {vimrc} is read for initializations, NONE to no load plugins and syntax highlighting, NORC to only no load vimrc'
        -i '{shada} Shada file, NONE to disable shada'
        -s '{scriptin} Read {scriptin} as normal mode input'
        -w '{number} Set windown option'
        -w '{scriptout} Record keys you have typed until leave vim, will append while {scriptout} exists'
        -W '{scriptout} Equivalent to -w but force overwrites {scriptout}'
        --api-info 'Print msgpack-encoded |api-metadata| and exit'
        --embed 'Use stdin/stdout as a msgpack-RPC channel, so applications can embed and control Nvim via the RPC |API|'
        --headless 'Start without UI, and do not wait for |nvim_ui_attach|'
        --listen '{addr} Start |RPC| server on pipe or TCP address {addr}'
        --remote '[+{cmd}] {file} Open the file list in a remote Vim'
        --remote-silent '... Same as --remote, but silent'
        --remote-tab '... Like --remote but open each file in a new tabpage'
        --remote-tab-silent '... Like --remote-silent but open each file in a new tabpage'
        --remote-send '{keys} Send {keys} to server and exit'
        --remote-expr '{expr} Evaluate {expr} in server and print the result on stdout'
        --remote-ui 'Display the UI of the server in the terminal'
        --server '{addr} Connect to the named pipe or socket at the given address for executing remote commands'
      )

      mapfile -t COMPREPLY < <(compgen -W '+ +/ -A --api-info -b -c --clean --cmd -d -D -e -E --embed -es -Es -h -H --headless --help -i -l -L --listen -ll -m -M -n --noplugin -o -O -p -r -R --remote -s -S --server --startuptime -u -v -V --version -w -W' -- "$2")
      if [ "${#COMPREPLY[@]}" -gt 1 ]; then
        local i
        for i in "${!COMPREPLY[@]}"; do
          COMPREPLY[i]+="$(printf '%*s' 8 ' ')${opt_desc[${COMPREPLY[i]}]}"
        done
      else
        case "${COMPREPLY[0]}" in
          + | +/ | -V | -o | -O | -p | -w)
            compopt -o nospace
            ;;
        esac
      fi
      ;;
  esac
}

complete -o default -F _nvim nvim

if alias vi 2> /dev/null | grep -qF nvim; then
  complete -o default -F _nvim vi
fi
