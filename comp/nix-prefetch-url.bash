_nix-prefetch-url() {
  mapfile -t COMPREPLY < <({
    case "$3" in
      --type)
        compgen -W 'sha256 sha512' -- "$2"
        ;;
      --unpack)
        compgen -W 'https://github.com https://gitlab.com https://kkgithub.com' -- "$2"
        ;;
      *)
        compgen -W '--type --unpack' -- "$2"
        ;;
    esac
  })
}

nix-prefetch-url --unpack https://github.com/atextor/icat/archive/refs/tags/v0.5.tar.gz --type sha256
path is '/nix/store/p8jl1jlqxcsc7ryiazbpm7c1mqb6848b-v0.5.tar.gz'
complete -o nosort -F _nix-prefetch-url nix-prefetch-url
