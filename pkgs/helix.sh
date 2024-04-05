. "${BASH_SOURCE[0]%/*}/../lib/gql.sh"

tag=$(gql_get_release helix-editor/helix stable getTag)
fname=helix-$tag-x86_64-linux.tar.xz
tmp=/tmp/$fname

curl -fL https://kkgithub.com/helix-editor/helix/releases/download/"$tag"/"$fname" -o "$tmp"

rm -rf ~/helix
tar xf "$tmp" -C ~
mv ~/helix-"$tag"-x86_64-linux ~/helix
ln -sfr ~/helix/hx ~/.local/bin
