# .bash_profile

# init env
if [[ $- = *i* && -f ~/.bashrc ]]; then
  . ~/.bashrc
elif [ -f ~/.env ]; then
  while read -r line; do
    export "$line"
  done < ~/.env
fi
