# $1: owner/repo
# $2: release=latest
get-releases() {
  local owner repo jquery release
  IFS=/ read -r owner repo <<< "$1"
  release=${2:-latest}
  if [ "$release" = latest ]; then
    jquery='.data.repository.releases.nodes[0].releaseAssets.nodes[]'
  else
    jquery='.data.repository.latestRelease.releaseAssets.nodes[]'
  fi
  gh api graphql \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -F "query=@gql/release.gql" -f "operationName=get${release@u}Release" \
    -F "owner=$owner" -F "repo=$repo" \
    -q "$jquery"
}

# pipe: asset nodes
# $1: project name
get-url() {
  jq -r 'select(.name | test("'"$1"'_[\\d.]+_amd64.deb")) | .downloadUrl'
}

curl-file() {
  curl -fLO "$1" --output-dir /tmp && echo "/tmp/$(basename "$1")"
}

wget-file() {
  wget "$1" -O "/tmp/$(basename "$1")" && echo "/tmp/$(basename "$1")"
}

# $1: name
_sharkdp() {
  # hyperfine_1.18.0_amd64.deb
  local pkgs='hexyl hyperfine'
  for pkg in $pkgs; do
    local url file
    url=$(get-releases "sharkdp/$pkg" | get_url "$pkg")
    url="https://kk${url:8}"
    log "$url"
    file=$(curl-file "$url")
    log "$file"
    install-deb "$file"
  done
  fd --gen-completions > /usr/share/bash-completion/completions/fd
}

log() {
  echo "[DEBUG]: $1"
}

# get info and check for updates
# $1: owner/repo
# $2: release=latest
# $3: browser=true
get-info() {
  local owner repo jquery release
  IFS=/ read -r owner repo <<< "$1"
  release=${2:-latest}
  if [ "$release" = latest ]; then
    jquery='.data.repository.releases.nodes[0]'
  else
    jquery='.data.repository.latestRelease'
  fi
  gh api graphql \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -F "query=@gql/release.gql" -f "operationName=get${release@u}Info" \
    -F "owner=$owner" -F "repo=$repo" \
    -q "$jquery" \
    | tee "data/$repo.json" \
    | {
      if [ "$3" != false ]; then
        jq -r '.descriptionHTML' | tee index.html > /dev/null
        xdg-open index.html > /dev/null
      else
        jq -r '.description' | glow /dev/stdin
      fi
    }
}

install-deb() {
  dpkg -i "$1"
}

check() {
  cd "$(dirname "$BASH_SOURCE")/.." || exit 1
  local exes='gh jq glow'
  for exe in $exes; do
    if ! type -P "$exe"; then
      echo "$exe cli not installed"
      exit 1
    fi
  done
  local dirs='data cache'
  for dir in $dirs; do
    if [ ! -d "$dir" ]; then
      rm -f "$dir"
      mkdir "$dir"
    fi
  done
}

# $1: repo
get-tag() {
  jq -r '.tagName' < "data/$1.json"
}

get-info "sharkdp/fd" latest true
