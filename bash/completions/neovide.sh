_neovide() {
  mapfile -t COMPREPLY < <({
    compgen -W '--fork --frame --grid -h --help --log --maximized --neovim-bin --no-fork --no-idle --no-multigrid --no-srgb --no-tabs --no-vsync --server --size --srgb --title-hidden -v --version --vsync --wayland --wsl --x11-wm-class --x11-wm-class-instance' -- "$2"
    if [ "$(type -t _nvim)" = function ]; then
      _nvim "$@" && printf '%s\n' "${COMPREPLY[@]}"
    fi
  })
}

complete -o default -F _neovide neovide
