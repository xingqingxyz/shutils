# .bashrc

# source env
if [ -f ~/.bash_profile ]; then
  . ~/.bash_profile
fi

#region UserEnv
#endregion

# shutils
if [[ $- = *i* ]]; then
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
  rg='rg --hyperlink-format=vscode' \
  tree='tree -C --hyperlink --gitignore'

if [[ $TERM_PROGRAM != vscode* ]]; then
  alias fd='fd --hyperlink=auto'
  if declare -xp WSL_DISTRO_NAME &> /dev/null; then
    alias rg='rg --hyperlink-format=vscode://file/{wslprefix}{path}:{line}:{column}'
  fi
fi
