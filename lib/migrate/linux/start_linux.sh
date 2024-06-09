# flathub
sudo flatpak remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub

# install nix single user mode
# sh <(curl -L https://nixos.org/nix/install) --no-daemon
sh <(curl https://mirrors.tuna.tsinghua.edu.cn/nix/latest/install)
# need to manual quit to skip download nix-channels
. ~/.nix-profile/etc/profile.d/nix.sh
nix-channel --add https://mirrors.ustc.edu.cn/nix-channels/nixpkgs-unstable
nix-channel --update
echo 'substituters = https://mirror.sjtu.edu.cn/nix-channels/store https://cache.nixos.org
trusted-substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://mirrors.ustc.edu.cn/nix-channels/store' > ~/.config/nix/nix.conf
alias nix='nix --extra-experimental-features nix-command --extra-experimental-features flakes'
alias nix-index='nix run github:nix-community/nix-index-database'
# nix-env -i ...
# nix profile install nixpkgs#gh
