# $1 = s
# $2 = sep
# $3 ? array name
split() {
  if [[ $1 == *"$2"* ]]; then
    if [ "$3" ]; then
      IFS=$2 read -rd '' -a "$3" < <(echo -n "$1")
    else
      echo "${1//$2/$'\n'}"
    fi
  elif [ "$3" ]; then
    local -r v=$3
    # shellcheck disable=SC2034
    v=$1
  else
    echo "$1"
  fi
}
