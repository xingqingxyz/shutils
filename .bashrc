# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# shutils
if ((BASH_VERSINFO[0] >= 5 && BASH_VERSINFO[1] >= 3)); then
  eval "$(printf '. %q\n' "$SHUTILS_ROOT"/bash/*.sh)"
fi

# shutils options
FZF_CTRL_T_OPTS='--preview="bat -p --color=always {}"'
FZF_ALT_C_OPTS='--preview="tree -C {}"'

# shell options
shopt -s globstar
HISTCONTROL=ignoreboth
HISTSIZE=9000
HISTFILESIZE=120000
TIMEFORMAT=$'\nreal\t%6lR\nuser\t%6lU\nsys\t%6lS\ncpu\t%P'

# aliases
alias cls=clear \
  r='fc -s' \
  l='ls --color=auto --hyperlink=auto' \
  ls='ls --color=auto --hyperlink=auto -lah' \
  tree='tree -C --hyperlink --gitignore'

if [[ $TERM_PROGRAM != vscode* ]]; then
  alias fd='fd --hyperlink=auto'
  if declare -xp WSL_DISTRO_NAME &> /dev/null; then
    alias rg='rg --hyperlink-format=file://{wslprefix}{path}'
  else
    alias rg='rg --hyperlink-format=default'
  fi
fi
