# .bash_profile

# init env
if [ -f ~/.env ]; then
  while read -r line; do
    export "$line"
  done < ~/.env
fi
if [ "$XDG_SESSION_TYPE" = tty ]; then
  export LANG=en_US.UTF-8
fi

# load bashrc
if [[ $- = *i* && -f ~/.bashrc ]]; then
  . ~/.bashrc
fi
