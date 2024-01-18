tarball="$1"

pushd /opt || exit 4
sudo tar xf "$tarball" #TODO
cd fzy && make \
  && sudo ln -sf /opt/fzy/fzy /usr/local/bin/fzy

gzip -c < /opt/fzy/fzy.1 | sudo tee /usr/local/share/man/man1/fzy.1.gz > /dev/null

popd || exit 4
