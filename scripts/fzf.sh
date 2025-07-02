#!/usr/bin/env bash
. "$SHUTILS_ROOT/bash/lib/gql.sh"
# aria2c https://github.com/junegunn/fzf/releases/download/0.63.0/fzf-0.63.0-linux_amd64.tar.gz

set -e
tag=$(gql_get_release junegunn/fzf stable getTag)
echo "$tag"
fname=fzf-${tag:1}-linux_amd64.tar.gz
tmp=/tmp/$fname
curl -fL https://github.com/junegunn/fzf/releases/download/$tag/$fname -o "$tmp"
tar -C ~/.local/bin -xf "$tmp"
