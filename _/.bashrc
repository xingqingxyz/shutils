# .bashrc

# import env
if [ -f ~/.env ]; then
  while read -r line; do
    export "$line"
  done < ~/.env
fi

#region UserEnv
#endregion

if [[ $- = *i* ]]; then
  eval "$(printf '. %q\n' "$SHUTILS_ROOT"/bash/*.sh)"
fi
