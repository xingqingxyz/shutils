tmp=/tmp/nvim-linux64.tar.gz

curl -fL https://kkgithub.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz -o "$tmp"

rm -rf ~/nvim-linux64
tar xf "$tmp" -C ~
ln -sfr ~/{nvim-linux64,.local}/bin/nvim
