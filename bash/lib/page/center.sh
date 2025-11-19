# $1: width
# stdin: lines
# stdout: lines
center() {
  sed -E "
  1{x; s/^$/$(printf "%${1:-80}s" ' ')/; x}
  s/^\s+//
  s/\s+$//
  G
  s/^(.{81}).*$/\1/
  s/(.*)\n(.*)\2/\2\1/
"
}
