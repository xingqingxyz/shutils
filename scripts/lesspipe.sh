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

[ -e "$1" ] || exit 1

# git bash env
PATH+=:/usr/bin

if [ -d "$1" ]; then
  ls -lah --color=always --hyperlink=always -- "$1"
  exit
fi

manfilter() {
  if test -x /usr/bin/man; then
    # See rhbz#1241543 for more info.  Well, actually we firstly
    # used 'man -l', then we switched to groff, and then we again
    # switched back to 'man -l'.
    MAN_KEEP_FORMATTING=1 man -P /usr/bin/cat -l "$1" | sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman --color=always
  elif test -x /usr/bin/groff; then
    # This is from pre-rhbz#1241543-time.
    groff -Tascii -mandoc "$1" | sed 's/\x1b\[[0-9;]*m\|.\x08//g' | bat -plman --color=always
  else
    bat -pltroff --color=always "$1"
  fi
}

case "$1" in
  *.[1-9n].bz2 | *.[1-9]x.bz2 | *.man.bz2 | *.[1-9n].[glx]z | *.[1-9]x.[glx]z | *.man.[glx]z | *.[1-9n].lzma | *.[1-9]x.lzma | *.man.lzma | *.[1-9n].zst | *.[1-9]x.zst | *.man.zst | *.[1-9n].br | *.[1-9]x.br | *.man.br)
    case "$1" in
      *.gz) DECOMPRESSOR="gzip -dc" ;;
      *.bz2) DECOMPRESSOR="bzip2 -dc" ;;
      *.lz) DECOMPRESSOR="lzip -dc" ;;
      *.zst) DECOMPRESSOR="zstd -dcq" ;;
      *.br) DECOMPRESSOR="brotli -dc" ;;
      *.xz | *.lzma) DECOMPRESSOR="xz -dc" ;;
    esac
    if [ "$DECOMPRESSOR" ] && $DECOMPRESSOR -- "$1" | file -L - | grep -q troff; then
      $DECOMPRESSOR -- "$1" | manfilter -
      exit
    fi
    ;;
esac
case "$1" in
  *.[1-9n] | *.[1-9]x | *.man)
    if file -L "$1" | grep -q troff; then
      manfilter "$1"
      exit
    fi
    ;;
esac
case "$1" in
  *.tar)
    tar tvvf "$1"
    exit
    ;;
  *.tgz | *.tar.gz | *.tar.[zZ])
    tar tzvvf "$1"
    exit
    ;;
  *.tar.xz)
    tar Jtvvf "$1"
    exit
    ;;
  *.xz | *.lzma)
    xz -dc -- "$1" | bat -p --color=always --file-name="${1%.*}"
    exit
    ;;
  *.tar.lz)
    tar --lzip -tvvf "$1"
    exit
    ;;
  *.lz)
    lzip -dc -- "$1" | bat -p --color=always --file-name="${1%.*}"
    exit
    ;;
  *.tar.zst)
    tar --zstd -tvvf "$1"
    exit
    ;;
  *.zst)
    zstd -dcq -- "$1" | bat -p --color=always --file-name="${1%.*}"
    exit
    ;;
  *.tar.br)
    brotli -dc -- "$1" | tar tvvf -
    exit
    ;;
  *.br)
    brotli -dc -- "$1" | bat -p --color=always --file-name="${1%.*}"
    exit
    ;;
  *.tar.bz2 | *.tbz2)
    bzip2 -dc -- "$1" | tar tvvf -
    exit
    ;;
  *.[zZ] | *.gz)
    gzip -dc -- "$1" | bat -p --color=always --file-name="${1%.*}"
    exit
    ;;
  *.bz2)
    bzip2 -dc -- "$1" | bat -p --color=always --file-name="${1%.*}"
    exit
    ;;
  *.zip | *.jar | *.nbm)
    zipinfo -- "$1"
    exit
    ;;
  # --nomanifest -> rhbz#1450277
  *.rpm)
    rpm -qpivl --changelog --nomanifest -- "$1"
    exit
    ;;
  *.cpi | *.cpio)
    cpio -itv < "$1"
    exit
    ;;
  *.gpg)
    if read -r < <(type -aP gpg2 gpg); then
      "$REPLY" -d "$1"
      exit
    else
      echo "No GnuPG available."
      echo "Install gnupg2 or gnupg to show encrypted files."
      exit 1
    fi
    ;;
  *.gif | *.jpeg | *.jpg | *.pcd | *.png | *.tga | *.tiff | *.tif)
    if type -aP identify > /dev/null; then
      identify "$1"
      exit
    else
      echo "No identify available"
      echo "Install ImageMagick to browse images"
      exit 1
    fi
    ;;
  *)
    type -aP file iconv > /dev/null || exit 1
    case $(file -Lb --mime-encoding "$1") in
      utf-16) conv='utf-16' ;;
      utf-32) conv='utf-32' ;;
      *)
        bat -p --color=always "$1"
        exit
        ;;
    esac
    if [ -n "$conv" ]; then
      env=$(cut -d. -f2 <<< $LANG)
      if [ "$env" -a "$conv" != "$env" ]; then
        iconv -f $conv -t $env "$1" | bat -p --color=always --file-name="$1"
        exit
      fi
    fi
    exit 1
    ;;
esac
