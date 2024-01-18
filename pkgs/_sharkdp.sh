# $1: repo

tag=$(get-tag "$1")
curl -fLO "https://kkgithub.com/sharkdp/$1/releases/download/$tag/${1}_${tag#v}_amd64.deb" --output-dir /tmp

dpkg -i "/tmp/${1}_${tag#v}_amd64.deb"
sudo
