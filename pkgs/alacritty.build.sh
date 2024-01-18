sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
cd ~/GitHub/alacritty || exit 1
# Force support for only X11
cargo build --release --no-default-features --features=x11
# Terminfo
if ! infocmp alacritty; then
  echo 'Install Terminfo...'
  sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
fi
# Desktop Entry
sudo cp -f target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp -f extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
# Manual Page
if [ -x gzip ] && [ -x scdoc ]; then
  scdoc < extra/man/alacritty.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
  scdoc < extra/man/alacritty-msg.1.scd | gzip -c | sudo tee /usr/local/share/man/man1/alacritty-msg.1.gz > /dev/null
  scdoc < extra/man/alacritty.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty.5.gz > /dev/null
  scdoc < extra/man/alacritty-bindings.5.scd | gzip -c | sudo tee /usr/local/share/man/man5/alacritty-bindings.5.gz > /dev/null
else
  echo 'need gzip and scdoc'
  echo 'sudo apt install gzip scdoc'
fi
# Shell Completion
cp -f extra/completions/alacritty.bash ~/.local/share/bash-completion/completions/alacritty
