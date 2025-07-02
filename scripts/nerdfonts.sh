#!/usr/bin/env bash
# $@: fonts name
. "$SHUTILS_ROOT/bash/lib/gql.sh"

tag=$(gql_get_release ryanoasis/nerd-fonts stable getTag)
for i in "$@"; do
  fname=$i.zip
  tmp=/tmp/$fname
  curl -fL https://github.com/ryanoasis/nerd-fonts/releases/download/$tag/$fname -o "$tmp" \
    && unzip "$tmp" -d ~/.local/share/fonts/truetype
done
sudo fc-cache -vf
