# .bashrc

if [[ $- != *i* ]]; then
  exit
fi

# shell options
shopt -s globstar
HISTCONTROL=ignoreboth
HISTSIZE=9000
HISTFILESIZE=120000
TIMEFORMAT=$'\nreal\t%6lR\nuser\t%6lU\nsys\t%6lS\ncpu\t%P'

# aliases
alias cls=clear \
  r='fc -s' \
  ls='ls --color=auto --hyperlink=auto' \
  ll='ls -lah' \
  grep='grep --color=auto' \
  rg='rg --hyperlink-format=vscode' \
  tree='fd -tf --hyperlink=auto' \
  cd..='cd ..' \
  cd...='cd ../..' \
  cd....='cd ../../..'

if [[ $TERM_PROGRAM != vscode* ]]; then
  alias fd='fd --hyperlink=auto'
  if declare -xp WSL_DISTRO_NAME &> /dev/null; then
    alias rg='rg --hyperlink-format=vscode://file/{wslprefix}{path}:{line}:{column}'
  fi
fi

# load
case "$OSTYPE" in
  msys | cygwin)
    # env
    if [[ :$PATH: != *:/usr/bin:* ]]; then
      PATH=/usr/bin:$PATH
    fi
    if [[ :$PATH: != *:/mingw64/bin:* ]]; then
      PATH=/mingw64/bin:$PATH
    fi
    alias ls='ls --color=auto'
    shopt -s extglob
    ;;
esac
REPLY=$(realpath -- "${BASH_SOURCE[0]}")
eval "$(printf '. %q\n' "${REPLY%/*}"/*.sh)"

# command-not-found
command_not_found_handle() {
  # check because c-n-f could've been removed in the meantime
  if [ -x /usr/lib/command-not-found ]; then
    /usr/lib/command-not-found --ignore-installed --no-failure-msg -- "$1"
  elif [ -x /usr/libexec/command-not-found ]; then
    /usr/libexec/command-not-found -- "$1"
  elif [ -x /usr/share/command-not-found/command-not-found ]; then
    /usr/share/command-not-found/command-not-found -- "$1"
  else
    echo "$1: command not found" >&2
    return 127
  fi
}

l() {
  if [ $# = 0 ]; then
    if [ -p /dev/stdin ]; then
      bat -plhelp
    else
      l "$PWD"
    fi
    return
  fi
  while [ $# != 0 ]; do
    case "$(type -t -- "$1")" in
      alias)
        alias -- "$1" | bat -plsh
        ;;
      builtin | keyword)
        help -- "$1" | bat -plhelp
        ;;
      file)
        bat -p "$1"
        ;;
      function)
        declare -fp -- "$1" | bat -plsh
        ;;
      *)
        # not found
        local i
        # maybe variable
        if [ "${1: -1}" = '*' ]; then
          eval "declare -p -- \${!$1}" | bat -plsh
        elif [ -v "$1" ]; then
          declare -p -- "$1" | bat -plsh
        elif [ -d "$1" ]; then
          # maybe directory
          command ls -lah --color=always --hyperlink=always -- "$1" | less
        else
          bat -p "$1"
        fi
        ;;
    esac
    shift
  done
}

e() {
  local editor=${EDITOR:-edit}
  if [ $# = 0 ]; then
    if [ -p /dev/stdin ]; then
      "$editor" "$@"
    else
      "$editor"
    fi
    return
  fi
  case "$(type -t -- "$1")" in
    alias)
      alias -- "$@" | bat -plsh
      ;;
    builtin | keyword)
      help -- "$@" | bat -plhelp
      ;;
    file)
      "$editor" "$@"
      ;;
    function)
      declare -fp -- "$@" | bat -plsh
      ;;
    *)
      # not found
      # maybe variable
      if [ -d "$1" ]; then
        # maybe directory
        command ls -lah --color=always --hyperlink=always -- "$@" | less
      else
        "$editor" "$@"
      fi
      ;;
  esac
}

k() {
  bat -plsh
}

# $1: duration
# ..: cmd
delay() {
  sleep "$1"
  shift
  "$@"
}

x() {
  if ((!$#)); then
    echo "no command to execute" >&2
    return 1
  fi
  local term=command term_cmd=(command)
  case "$TERM" in
    alacritty) term=$TERM ;;
    xterm-ghostty) term=ghostty ;;
    xterm-kitty) term=kitty ;;
    *)
      if [[ $(declare -p ALACRITTY_LOG 2> /dev/null) = 'declare -x'* ]]; then
        term=alacritty
      elif [[ $(declare -p GHOSTTY_BIN_DIR 2> /dev/null) = 'declare -x'* ]]; then
        term=ghostty
      elif [[ $(declare -p KITTY_PID 2> /dev/null) = 'declare -x'* ]]; then
        term=kitty
      elif [[ $(declare -p WT_SESSION 2> /dev/null) = 'declare -x'* ]] \
        || type -aP wt.exe > /dev/null; then
        term=wt
      fi
      ;;
  esac
  case "$term" in
    alacritty)
      if [[ $OSTYPE = @(cygwin|msys) ]]; then
        term_cmd=(conhost alacritty)
      elif type -aP pgrep > /dev/null && pgrep alacritty \
        || (ps -ef | grep -q '/alacritty\s'); then
        term_cmd=(alacritty msg create-window --working-directory "$PWD")
      elif [ "$OSTYPE" = darwin ]; then
        term_cmd=(open -n -a alacritty.app --)
      else
        term_cmd=(sh -c 'setsid -f "$@" &> /dev/null' alacritty)
      fi
      term_cmd+=(--title "$1" -e)
      ;;
    ghostty) term_cmd=(ghostty +new-window --title "$1" -e) ;;
    kitty)
      if [ "$OSTYPE" = darwin ]; then
        term_cmd=(open -n -a kitty.app -- --title "$1" --)
      else
        term_cmd=(kitty --detach --title "$1" --)
      fi
      ;;
    wt) term_cmd=(wt.exe -w 0 nt -d "$PWD" --title "$1" --) ;;
  esac
  local tmp input clean=:
  if read -rt0 _; then
    tmp=$(mktemp)
    cat > "$tmp"
    input="< ${tmp@Q}"
    clean="rm ${tmp@Q}"
  fi
  cmd=$(
    cat << EOF
while true; do
  ${*@Q} $input
  ec=\$?
  if ((ec)); then
    echo "process exited with code \$ec" >&2
    echo 'press ctrl+d to exit, or press enter to retry' >&2
    while read -rsn1 -t "\$EPOCHSECONDS"; do
      if [ "\$REPLY" = \$'\004' ]; then
        break
      elif [ -z "\$REPLY" ]; then
        continue 2
      fi
    done
  fi
  $clean
  exit "\$ec"
done
EOF
  )
  echo "$cmd"
  local shell=$BASH
  if [ -v WSL_DISTRO_NAME ]; then
    shell=$(wslpath -w "$BASH")
  elif [[ $OSTYPE = @(cygwin|msys) ]]; then
    shell=$(cygpath -w "$BASH")
  fi
  "${term_cmd[@]}" "$shell" -c "$cmd"
}
