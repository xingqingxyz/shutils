# ensure manual directories
sudo mkdir -p /usr/local/share/man/man1
sudo mkdir -p /usr/local/share/man/man5
# ensure package mangers
rustup upgrade
python3 -m pip install --upgrade pip
pnpm up -g pnpm
# flatpak
# cargo
# go
