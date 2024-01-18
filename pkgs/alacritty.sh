# Force support for only X11
if ! cargo install alacritty --no-default-features --features=x11; then
  echo try install deps:
  echo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
  exit 1
fi

pushd /tmp || exit 1
# resources
prefix='https://github.com/alacritty/alacritty/releases/download/v0.13.0/'
files='alacritty-bindings.5.gz alacritty-msg.1.gz alacritty.1.gz alacritty.5.gz alacritty.bash Alacritty.desktop alacritty.info Alacritty.svg'

for f in $files; do
  wget $prefix$f || (echo "Download Failed: $f" && exit 1)
done

# Terminfo
echo 'Install Terminfo...'
tic -xe alacritty,alacritty-direct alacritty.info
# Desktop Entry
echo 'Install Desktop Entry...'
cp -f alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
desktop-file-install Alacritty.desktop
update-desktop-database
# Manual Page
echo 'Install Manual Page...'
cp alacritty.1.gz /usr/local/share/man/man1
cp alacritty-msg.1.gz /usr/local/share/man/man1
cp alacritty.5.gz /usr/local/share/man/man5
cp alacritty-bindings.5.gz /usr/local/share/man/man5
# Shell Completion
echo 'Install Shell Completion...'
cp -f alacritty.bash ~/.local/share/bash-completion/completions/alacritty
echo 'Done!'
popd || exit 1
