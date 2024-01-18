all() {
  local pkgs='bat fd hexyl hyperfine' pkg file
  file="$(dirname "$BASH_SOURCE")/_sharkdp.sh"
  for pkg in $pkgs; do
    bash "$file" "$pkg"
  done
}

all
