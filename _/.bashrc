# .bashrc

# import env
if [ -f ~/.env ]; then
  while read -r line; do
    export "$line"
  done < ~/.env
fi

# shell options
shopt -s globstar
HISTCONTROL=ignoreboth
HISTSIZE=9000
HISTFILESIZE=120000
TIMEFORMAT=$'\nreal\t%6lR\nuser\t%6lU\nsys\t%6lS\ncpu\t%P'

# shutils
FZF_CTRL_T_OPTS='--preview="bat -p --color=always {}"'
FZF_ALT_C_OPTS='--preview="tree -C {}"'

if [[ $- = *i* ]]; then
  eval "$(printf '. %q\n' "$SHUTILS_ROOT"/bash/*.sh)"
fi

# aliases
alias cls=clear \
  r='fc -s' \
  ls='ls --color=auto --hyperlink=auto' \
  ll='ls -lah' \
  grep='grep --color=auto' \
  rg='rg --hyperlink-format=vscode' \
  tree='tree -C --hyperlink --gitignore' \
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

#region UserEnv
#endregion
