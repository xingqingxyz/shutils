#!/usr/bin/env bash
# aria2c https://github.com/junegunn/fzf/releases/download/0.63.0/fzf-0.63.0-linux_amd64.tar.gz
set -e
. "$SHUTILS_ROOT/bash/lib/gql.sh"

tag=$(gql_get_release junegunn/fzf stable getTag)
echo "$tag"
if type -aP fzf > /dev/null && [[ $tag = $(fzf --version | cut -d' ' -f1) ]]; then
  return
fi
fname=fzf-${tag:1}-linux_amd64.tar.gz
tmp=/tmp/$fname
curl -fL https://github.com/junegunn/fzf/releases/download/$tag/$fname -o "$tmp"
tar -C ~/.local/bin -xf "$tmp"
rm "$tmp"
