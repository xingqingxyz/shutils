_tree() {
  case "$3" in
    --charset)
      mapfile -t COMPREPLY < <(compgen -W 'UTF-8 GBK GB2312 C ASCII ISO-8895-1' -- "$2")
      ;;
    --sort)
      mapfile -t COMPREPLY < <(compgen -W 'name version size mtime ctime' -- "$2")
      ;;
    *)
      mapfile -t COMPREPLY < <(compgen -W '-a -d -l -f -x -L -R -P -I --gitignore --gitfile --ignore-case --matchdirs --metafirst --prune --info --infofile --noreport --charset --filelimit -o -q -N -Q -p -u -g -s -h --si --du -D --timefmt -F --inodes --device -v -t -c -U -r --dirsfirst --filesfirst --sort -i -A -S -n -C -X -J -H -T --nolinks --hintro --houtro --fromfile --fromtabfile --fflinks --version --help' -- "$2")
      ;;
  esac
}

complete -o default -F _tree tree
