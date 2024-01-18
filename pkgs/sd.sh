tarball="$1"

pushd /opt || exit 4
sudo tar xf "$tarball" #TODO: out 'sd'
sudo ln -sf /opt/sd/sd /usr/local/bin/sd
sudo cp -f /opt/sd/completions/sd.bash /usr/share/bash-completion/completions
gzip -c < /opt/sd/sd.1 | sudo tee /usr/local/share/man/man1/sd.1.gz > /dev/null

popd || exit 4
