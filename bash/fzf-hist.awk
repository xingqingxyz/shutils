/^[0-9]+\t \S/ {
  if (NR >= 2) {
    items[i++] = item
  }
  item = $0
  next
}
{
  item = item RS $0
}
END {
  items[i] = item
  for (i in items) {
    printf "%s\0", items[i]
  }
}
