BEGIN {
  rank[dir] = 1
  time[dir] = systime()
}
$2 >= 1 {
  if ($1 == dir) {
    rank[dir] += $2
  } else {
    rank[$1] = $2
    time[$1] = $3
  }
  cnt += $2
}
END {
  if (cnt > max_size) {
    for (i in rank) {
      rank[i] *= .99
      # rank ::= (int|float)
      printf "%s|%s|%d\n", i, rank[i], time[i]
    }
    exit
  }
  for (i in rank) {
    printf "%s|%s|%d\n", i, rank[i], time[i]
  }
}
