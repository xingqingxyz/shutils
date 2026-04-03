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

# wish
FZF_CTRL_T_OPTS='--preview="bat -p --color=always {}"'
FZF_ALT_C_OPTS='--preview="fd -tf --color=always --hyperlink=always {}"'

# aliases
alias cls=clear \
  r='fc -s' \
  ls='ls --color=auto --hyperlink=auto' \
  ll='ls -lah' \
  grep='grep --color=auto' \
  rg='rg --hyperlink-format=vscode' \
  tree='fd -tf --hyperlink=auto' \
  cd..='cd ..' \
  ..='cd ..' \
  ...='cd ../..' \
  ....='cd ../../..'

if [[ $TERM_PROGRAM != vscode* ]]; then
  alias fd='fd --hyperlink=auto'
  if declare -xp WSL_DISTRO_NAME &> /dev/null; then
    alias rg='rg --hyperlink-format=vscode://file/{wslprefix}{path}:{line}:{column}'
  fi
fi

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
    ;;
  *)
    REPLY=$(realpath -- "${BASH_SOURCE[0]}")
    eval "$(printf '. %q\n' "${REPLY%/*}"/*.sh)"
    ;;
esac
