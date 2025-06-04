# begin: hist_cnt
/^[0-9]+\t \S/ {
  if (NR >= 2) {
    # collect line(s)
    seen[line] = hist_cnt - $1
  }
  # hist start
  line = $0
  sub(/^[0-9]+\t [ *]*/, "", line)
  next
}
{
  # proc multi line hist
  line = line RS $0
}
END {
  for (line in seen) {
    printf "%d\t%s\0", seen[line], line
  }
}
