curl -fLO https://kkgithub.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz --output-dir /tmp || exit 1
tarball=/tmp/nvim-linux64.tar.gz

pushd /opt || exit 1
sudo rm -rf nvim-linux64
sudo tar xf $tarball
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/vi

rm -rf $tarball
popd || exit 1
