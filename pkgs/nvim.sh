tmp=/tmp/nvim-linux64.tar.gz

curl -fL "https://$github/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz" -o "$tmp"

rm -rf /opt/nvim-linux64
tar xf "$tmp" -C ~
ln -sf /tmp/nvim-linux64/bin/nvim /usr/bin/
