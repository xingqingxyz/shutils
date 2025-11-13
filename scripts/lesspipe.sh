#!/bin/bash
#
# To use this filter with less, define LESSOPEN:
# export LESSOPEN="|lesspipe.sh %s"
#
# The script should return zero if the output was valid and non-zero
# otherwise, so less could detect even a valid empty output
# (for example while uncompressing gzipped empty file).
# For backward-compatibility, this is not required by default. To turn
# this functionality there should be another vertical bar (|) straight
# after the first one in the LESSOPEN environment variable:
# export LESSOPEN="||lesspipe.sh %s"

f=$(realpath -qe -- "$1") || exit
# git bash env
PATH+=:/usr/bin

if [ -d "$f" ]; then
  ls -xA --color=always --hyperlink=always "$f"
  exit 1 # less auto handle empty output
fi

case "$f" in
  *.[1-9n].bz2 | *.[1-9]x.bz2 | *.man.bz2 | *.[1-9n].[glx]z | *.[1-9]x.[glx]z | *.man.[glx]z | *.[1-9n].lzma | *.[1-9]x.lzma | *.man.lzma | *.[1-9n].zst | *.[1-9]x.zst | *.man.zst | *.[1-9n].br | *.[1-9]x.br | *.man.br)
    case "$f" in
      *.gz) DECOMPRESSOR="gzip -dc" ;;
      *.bz2) DECOMPRESSOR="bzip2 -dc" ;;
      *.lz) DECOMPRESSOR="lzip -dc" ;;
      *.zst) DECOMPRESSOR="zstd -dcq" ;;
      *.br) DECOMPRESSOR="brotli -dc" ;;
      *.xz | *.lzma) DECOMPRESSOR="xz -dc" ;;
    esac
    if [ "$DECOMPRESSOR" ] && $DECOMPRESSOR "$f" | file - | grep -q troff; then
      $DECOMPRESSOR "$f" | man -l - | sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman --color=always
    else
      echo "unknown man page $f"
      false
    fi
    ;;
  *.[1-9n] | *.[1-9]x | *.man)
    if file "$f" | grep -q troff; then
      man -l "$f" | sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman --color=always
    else
      echo "unknown man page $f"
      false
    fi
    ;;
  *.tar | *.tar.xz | *.tgz | *.tar.gz | *.tar.[zZ] | *.tar.bz2 | *.tbz2 | *.tar.br)
    tar -tvvf "$f"
    ;;
  *.tar.lz)
    tar --lzip -tvvf "$f"
    ;;
  *.tar.zst)
    tar --zstd -tvvf "$f"
    ;;
  *.xz | *.lzma)
    xz -dc "$f" | bat -p --color=always --file-name="${f%.*}"
    ;;
  *.lz)
    lzip -dc "$f" | bat -p --color=always --file-name="${f%.*}"
    ;;
  *.zst)
    zstd -dcq "$f" | bat -p --color=always --file-name="${f%.*}"
    ;;
  *.br)
    brotli -dc "$f" | bat -p --color=always --file-name="${f%.*}"
    ;;
  *.[zZ] | *.gz)
    gzip -dc "$f" | bat -p --color=always --file-name="${f%.*}"
    ;;
  *.bz2)
    bzip2 -dc "$f" | bat -p --color=always --file-name="${f%.*}"
    ;;
  *.zip | *.jar | *.nbm)
    zipinfo "$f"
    ;;
  *.rpm)
    rpm -qpivl --changelog --nomanifest "$f"
    ;;
  *.cpi | *.cpio)
    cpio -itv < "$f"
    ;;
  *.gpg)
    if read -r < <(type -aP gpg2 gpg); then
      "$REPLY" -d "$f"
    else
      echo 'No GnuPG available.'
      echo 'Install gnupg2 or gnupg to show encrypted files.'
      false
    fi
    ;;
  *.gif | *.jpeg | *.jpg | *.pcd | *.png | *.tga | *.tiff | *.tif)
    if type -aP identify > /dev/null; then
      identify "$f"
    else
      echo 'No identify available'
      echo 'Install ImageMagick to browse images'
      false
    fi
    ;;
  *)
    fc=$(file -b --mime-encoding "$f")
    tc=$(cut -d. -f2 <<< $LANG)
    if [ "$tc" -a "$fc" != "$tc" ]; then
      iconv -f $fc -t $tc "$f" | bat -p --color=always --file-name="$f"
    else
      bat -p --color=always "$f"
    fi
    ;;
esac
