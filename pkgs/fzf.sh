tarball="$1"

pushd /usr/local/bin || exit 4
sudo tar xf "$tarball"

popd || exit 4
