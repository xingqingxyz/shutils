. "${BASH_SOURCE[0]%/*}/../lib/gql.sh"

tag=$(gql_get_release akiyosi/goneovim stable getTag)
fname=goneovim-$tag-linux.tar.bz2
tmp=/tmp/$fname

curl -fL https://kkgithub.com/akiyosi/goneovim/releases/download/"$tag"/"$fname" -o "$tmp"

rm -rf ~/goneovim
tar xf "$tmp" -C ~
mv ~/goneovim-"$tag"-linux ~/goneovim
ln -sfr ~/goneovim/goneovim ~/.local/bin
