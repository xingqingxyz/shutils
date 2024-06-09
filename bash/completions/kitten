_kitten() {
  local cmd
  if [ "$COMP_CWORD" = 1 ]; then
    mapfile -t COMPREPLY < <(compgen -W '@ update-self edit-in-kitty clipboard icat ssh transfer unicode-input show-key mouse-demo hyperlinked-grep ask hints diff themes run-shell -h --help --version' -- "$2")
    return
  fi
  case "$3" in
    *) ;;
  esac
  case "$cmd" in
    @)
      mapfile -t COMPREPLY < <(compgen -W 'action close-tab close-window create-marker detach-tab detach-window disable-ligatures env focus-tab focus-window get-colors get-text goto-layout kitten last-used-layout launch load-config ls new-window remove-marker resize-os-window resize-window scroll-window select-window send-key send-text set-background-image set-background-opacity set-colors set-enabled-layouts set-font-size set-spacing set-tab-color set-tab-title set-user-vars set-window-logo set-window-title signal-child' -- "$2")
      ;;
    @__action)
      mapfile -t COMPREPLY < <(compgen -W '--self --no-response -m --match -h --help' -- "$2")
      ;;
    @__close-tab | @__close-window)
      mapfile -t COMPREPLY < <(compgen -W '-m --match --no-response --self --ignore-no-match -h --help' -- "$2")
      ;;
    @__create-marker | @__remove-marker | @__set-tab-color)
      mapfile -t COMPREPLY < <(compgen -W '-m --match --self -h --help' -- "$2")
      ;;
    @__detach-tab | @__detach-window)
      mapfile -t COMPREPLY < <(compgen -W '-m --match -t --target-tab --self -h --help' -- "$2")
      ;;
    @__disable-ligatures)
      mapfile -t COMPREPLY < <(compgen -W '-a --all -m --match -t --match-tab -h --help' -- "$2")
      ;;
    @__env)
      if [[ $2 =~ = ]]; then
        compopt +o default
      else
        mapfile -t COMPREPLY < <(compgen -A export -- "$2")
      fi
      ;;
    @__focus-tab | @__focus-window | @__scroll-window | @__signal-child)
      mapfile -t COMPREPLY < <(compgen -W '-m --match --no-response -h --help' -- "$2")
      ;;
    @__get-colors)
      mapfile -t COMPREPLY < <(compgen -W '-c --configured -m --match -h --help' -- "$2")
      ;;
    @__get-text)
      case "$3" in
        --extent)
          mapfile -t COMPREPLY < <(compgen -W 'screen all first_cmd_output_on_screen last_cmd_output last_non_empty_output last_visited_cmd_output selection' -- "$2")
          ;;
        *)
          mapfile -t COMPREPLY < <(compgen -W '-m --match --extent --ansi --add-cursor --add-wrap-markers --clear-selection --self -h --help' -- "$2")
          ;;
      esac
      ;;
    @__goto-layout | @__set-tab-title | @__set-user-vars)
      mapfile -t COMPREPLY < <(compgen -W '-m --match -h --help' -- "$2")
      ;;
    @__last-used-layout)
      mapfile -t COMPREPLY < <(compgen -W '-a --all --no-response -m --match -h --help' -- "$2")
      ;;
    @__launch)
      case "$3" in
        --env)
          if [[ $2 =~ = ]]; then
            compopt +o default
          else
            mapfile -t COMPREPLY < <(compgen -A export -- "$2")
          fi
          ;;
        --type)
          mapfile -t COMPREPLY < <(compgen -W 'window tab os-window overlay overlay-main background clipboard primary' -- "$2")
          ;;
        --var)
          if [[ $2 =~ = ]]; then
            compopt +o default
          else
            mapfile -t COMPREPLY < <(compgen -v -- "$2")
          fi
          ;;
        --location)
          mapfile -t COMPREPLY < <(compgen -W 'default after before first hsplit last neighbor split vsplit' -- "$2")
          ;;
        --stdin-source)
          mapfile -t COMPREPLY < <(compgen -W 'none @alternate @alternate_scrollback @first_cmd_output_on_screen @last_cmd_output @last_visited_cmd_output @screen @screen_scrollback @selection' -- "$2")
          ;;
        --os-window-state)
          mapfile -t COMPREPLY < <(compgen -W 'normal fullscreen maximized minimized' -- "$2")
          ;;
        --color)
          mapfile -t COMPREPLY < <(compgen -W 'background= foreground=' -- "$2")
          ;;
        *)
          mapfile -t COMPREPLY < <(compgen -W '-m --match --no-response --self --title --window-title --tab-title --type --dont-take-focus --keep-focus --cwd --env --var --hold --copy-colors --copy-cmdline --copy-env --location --allow-remote-control --remote-control-password --stdin-source --stdin-add-formatting --stdin-add-line-wrap-markers --marker --os-window-class --os-window-name --os-window-state --logo --logo-position --logo-alpha --color --spacing -w --watcher -h --help' -- "$2")
          ;;
      esac
      ;;
    @__load-config)
      mapfile -t COMPREPLY < <(compgen -W '--ignore-overrides -o --override --no-response -h --help' -- "$2")
      ;;
    @__ls)
      mapfile -t COMPREPLY < <(compgen -W '--all-env-vars --self -m --match -t --match-tab -h --help' -- "$2")
      ;;
    @__new-window)
      case "$3" in
        --window-type)
          mapfile -t COMPREPLY < <(compgen -W 'kitty os' -- "$2")
          ;;
        *)
          mapfile -t COMPREPLY < <(compgen -W '-m --match --title --cwd --dont-take-focus --keep-focus --window-type --new-tab --tab-title --no-response -h --help' -- "$2")
          ;;
      esac
      ;;
    @__resize-os-window)
      case "$3" in
        --action)
          mapfile -t COMPREPLY < <(compgen -W 'resize toggle-fullscreen toggle-maximized' -- "$2")
          ;;
        --unit)
          mapfile -t COMPREPLY < <(compgen -W 'cells pixels' -- "$2")
          ;;
        *)
          mapfile -t COMPREPLY < <(compgen -W '-m --match --action --unit --width --height --incremental --self --no-response -h --help' -- "$2")
          ;;
      esac
      ;;
    @__resize-window)
      case "$3" in
        --axis)
          mapfile -t COMPREPLY < <(compgen -W 'horizontal reset vertical' -- "$2")
          ;;
        *)
          mapfile -t COMPREPLY < <(compgen -W '-m --match -i --increment -a --axis --self -h --help' -- "$2")
          ;;
      esac
      ;;
    @__select-window)
      mapfile -t COMPREPLY < <(compgen -W '-m --match --response-timeout --self --title --exclude-active --reactivate-prev-tab -h --help' -- "$2")
      ;;
    @__send-key)
      mapfile -t COMPREPLY < <(compgen -W '-m --match -t --match-tab --all --exclude-active -h --help' -- "$2")
      ;;
    @__send-text)
      case "$3" in
        --bracketed-paste)
          mapfile -t COMPREPLY < <(compgen -W 'disable auto enable' -- "$2")
          ;;
        *)
          mapfile -t COMPREPLY < <(compgen -W '-m --match -t --match-tab --all --exclude-active --stdin --from-file --bracketed-paste -h --help' -- "$2")
          ;;
      esac
      ;;
    @__set-background-image)
      case "$3" in
        --layout)
          mapfile -t COMPREPLY < <(compgen -W 'configured clamped mirror-tiled scaled tiled' -- "$2")
          ;;
        *)
          mapfile -t COMPREPLY < <(compgen -W '-a --all -c --configured --layout --no-response -m --match -h --help' -- "$2")
          ;;
      esac
      ;;
    @__set-background-opacity)
      mapfile -t COMPREPLY < <(compgen -W '-a --all --toggle -m --match -t --match-tab  -h --help' -- "$2")
      ;;
    @__set-colors)
      mapfile -t COMPREPLY < <(compgen -W '-a --all -c --configured --reset -m --match -t --match-tab -h --help foreground= background=' -- "$2")
      ;;
    @__set-enabled-layouts)
      mapfile -t COMPREPLY < <(compgen -W '-m --match --configured -h --help' -- "$2")
      ;;
    @__set-font-size)
      mapfile -t COMPREPLY < <(compgen -W '-a --all -h --help' -- "$2")
      ;;
    @__set-spacing)
      mapfile -t COMPREPLY < <(compgen -W '-a --all -c --configured -m --match -t --match-tab -h --help' -- "$2")
      ;;
    @__set-window-logo)
      mapfile -t COMPREPLY < <(compgen -W '-m --match --self --position --alpha --no-response -h --help' -- "$2")
      ;;
    @__set-window-title)
      mapfile -t COMPREPLY < <(compgen -W '--temporary -m --match -h --help' -- "$2")
      ;;
    update-self)
      case "$3" in
        --fetch-version)
          mapfile -t COMPREPLY < <(compgen -W 'stable nightly' -- "$2")
          ;;
        *)
          mapfile -t COMPREPLY < <(compgen -W '--fetch-version -h --help' -- "$2")
          ;;
      esac
      ;;
    edit-in-kitty)
      case "$3" in

        *)
          mapfile -t COMPREPLY < <(compgen -W '--title --window-title' -- "$2")
          ;;
      esac
      ;;
  esac

  [ ${#COMPREPLY[@]} != 0 ] && return

  case "$cmd" in
    @*)
      case "$3" in
        --to)
          mapfile -t COMPREPLY < <(compgen -W 'http://127.0.0.1' -- "$2")
          ;;
        --password-env)
          mapfile -t COMPREPLY < <(compgen -W "$KITTY_RC_PASSWORD" -- "$2")
          ;;
        --use-password)
          mapfile -t COMPREPLY < <(compgen -W 'if-available always never' -- "$2")
          ;;
        -m | -t | --match | --match-tab)
          # resove --match
          local field query
          IFS=: read -r field query <<< "${2##* }"
          case "$field" in
            '')
              mapfile -t COMPREPLY < <(compgen -W 'id title pid cwd cmdline num env var state neighbor recent' -- "$2")
              ;;
            neighbor)
              mapfile -t COMPREPLY < <(compgen -W 'left right top bottom' -- "$query")
              ;;
            env)
              local name value
              IFS='=' read -r name value <<< "$query"
              if [ -z "$value" ]; then
                compopt -o nospace
                mapfile -t COMPREPLY < <(compgen -P env: -A export -- "$name")
              else
                compopt +o default
              fi
              ;;
            state)
              mapfile -t COMPREPLY < <(compgen -W 'active focused needs_attention parent_active parent_focused self overlay_parent' -- "$2")
              ;;
          esac
          ;;
        *)
          [[ $2 == -* ]] || return
          mapfile -t COMPREPLY < <(compgen -W '--to --password --password-file --password-env --use-password -h --help' -- "$2")
          ;;
      esac
      ;;
  esac
}
