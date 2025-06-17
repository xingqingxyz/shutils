# $1: font name

. "$SHUTILS_ROOT/bash/lib/gql.sh"

tag=$(gql_get_release ryanoasis/nerd-fonts stable getTag)
fname=${1:-'0xProto'}.zip
tmp=/tmp/$fname

curl -fL https://github.com/ryanoasis/nerd-fonts/releases/download/$tag/$fname -o "$tmp"

unzip "$tmp" -d ~/.local/share/fonts/truetype
sudo fc-cache -vf
