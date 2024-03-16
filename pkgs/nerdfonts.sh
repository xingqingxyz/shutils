. "${BASH_SOURCE[0]%/*}/../lib/gql.sh"

tag=$(gql_get_release ryanoasis/nerd-fonts stable getTag)
fname=${font:-0xProto}.zip
tmp=${TMPDIR:-/tmp}/$fname

curl -fL https://kkgithub.com/ryanoasis/nerd-fonts/releases/download/$tag/$fname -o "$tmp"

unzip "$tmp" -d ~/.local/share/fonts/truetype
fc-cache
