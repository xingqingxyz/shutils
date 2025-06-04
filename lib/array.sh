# $1 = <prefix>..<suffix>
# ... = array items
map_many() {
  local prefix suffix i
  prefix=${1%%..*}
  suffix=${1#*..}
  shift
  for i; do
    echo "$prefix$i$suffix"
  done
}

# $1 = <prefix>..<suffix>
# $2 = array name
# $3 ? map to array name
map() {
  declare -n _array=$2
  if [ -n "$3" ]; then
    declare -n _target=$3
  fi
  local prefix suffix i
  prefix=${1%%..*}
  suffix=${1#*..}
  for i in "${_array[@]}"; do
    if [ -n "$3" ]; then
      _target+=("$prefix$i$suffix")
    else
      echo "$prefix$i$suffix"
    fi
  done
}

# $1 = fn name
# $2 = array name
# $3 ? map to array name
map_fn() {
  declare -n _array=$2
  if [ -n "$3" ]; then
    declare -n _target=$3
  fi
  local i
  for i in "${!_array[@]}"; do
    if [ -n "$3" ]; then
      _target[i]=$("$1" "$i" "${_array[i]}" "$2")
    else
      printf '%s\n' "$("$1" "$i" "${_array[i]}" "$2")"
    fi
  done
}

# $1 = value
# $2 = array name
# $3 ?=0 from index
# $4 ?=#array to index
fill() {
  declare -n _array=$2
  local i=${3:-0} end=${4:-${#_array[@]}}
  ((i--))
  while ((++i < end)); do
    _array[i]=$1
  done
}

# $1 = <pattern>
# ... = array items
filter_many() {
  local i
  for i in "${@:2}"; do
    # shellcheck disable=SC2053
    if [[ $i == $1 ]]; then
      echo "$i"
    fi
  done
}

# $1 = <pattern>
# $2 = array name
# $3 ? to array name
filter() {
  declare -n _array=$2
  if [ -n "$3" ]; then
    declare -n _target=$3
  fi
  local i
  for i in "${_array[@]}"; do
    # shellcheck disable=SC2053
    if [[ $i == $1 ]]; then
      if [ -n "$3" ]; then
        _target+=("$i")
      else
        echo "$i"
      fi
    fi
  done
}

# $1 = fn name
# $2 = array name
# $3 ? to array name
filter_fn() {
  declare -n _array=$2
  if [ -n "$3" ]; then
    declare -n _target=$3
  fi
  local i
  for i in "${!_array[@]}"; do
    if "$1" "$i" "${_array[i]}" "$2"; then
      if [ -n "$3" ]; then
        _target+=("${_array[i]}")
      else
        echo "${_array[i]}"
      fi
    fi
  done
}

# $1 = index
# $2 = value
# $3 = array name
_test_map_fn() {
  echo -n "$@"
}

test_map() {
  local -a array=(a b c d) target
  map_many a\\../c a b c
  echo "init: ${target[*]}"
  map a\\../c array
  map a\\../c array target
  echo "after map prefix: ${target[*]}"
  map_fn _test_map_fn array
  map_fn _test_map_fn array target
  echo "after map fn: ${target[*]}"
}

test_fill() {
  declare -a a
  fill 3 a 10 100
  echo "${#a[@]}"
  echo "${a[@]}"
}

test_map
