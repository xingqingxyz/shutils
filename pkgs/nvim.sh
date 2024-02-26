curl -fLO https://kkgithub.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz --output-dir /tmp || exit 1
tarball=/tmp/nvim-linux64.tar.gz

cd || exit 1
rm -rf nvim-linux64

tar xf $tarball
ln -sf ~/{nvim-linux64,.local}/bin/nvim

rm -rf $tarball
cd - || exit 1
