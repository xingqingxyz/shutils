_coreutils() {
  if [ "$COMP_CWORD" = 1 ]; then
    mapfile -t COMPREPLY < <(compgen -W '--help --version --coreutils-prog=' -- "$2")
    if [[ ${COMPREPLY[*]} == --coreutils-prog= ]]; then
      compopt -o nospace
    fi
    return
  fi
  local prev
  if [ "$3" = = ]; then
    prev=${COMP_WORDS[COMP_CWORD - 2]}
  else
    prev=$3
  fi
  if [ "$prev" = --coreutils-prog ]; then
    mapfile -t COMPREPLY < <(compgen -W '[ b2sum base32 base64 basename basenc cat chcon chgrp chmod chown chroot cksum comm cp csplit cut date dd df dir dircolors dirname du echo env expand expr factor false fmt fold ginstall groups head hostid id join kill link ln logname ls md5sum mkdir mkfifo mknod mktemp mv nice nl nohup nproc numfmt od paste pathchk pinky pr printenv printf ptx pwd readlink realpath rm rmdir runcon seq sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf sleep sort split stat stdbuf stty sum sync tac tail tee test timeout touch tr true truncate tsort tty uname unexpand uniq unlink uptime users vdir wc who whoami yes' -- "$2")
  elif [[ $2 == -* ]]; then
    mapfile -t COMPREPLY < <(compgen -W '--help --version' -- "$2")
  fi
}

complete -o default -F _coreutils coreutils
