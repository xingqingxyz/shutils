# .bashrc on windows

# env
if [[ :$PATH: != *:/usr/bin:* ]]; then
  PATH=/usr/bin:$PATH
fi
if [[ :$PATH: != *:/mingw64/bin:* ]]; then
  PATH=/mingw64/bin:$PATH
fi

# Get the aliases and functions
. "$SHUTILS_ROOT/_/.bashrc"
