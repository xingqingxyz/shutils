# max value 10000 * 9000 * 3 => 2.7e8 < 1e9
function frecent (rank, time) {
  return int(10000 * rank * (3.75 / (.0001 * (now - time) + 1.25)))
}

function tlide_path (path) {
  if (index(path, HOME) == 1) {
    return "~" substr(path, length(HOME) + 1)
  }
  return path
}

function output (matches, best_match) {
  commnon = LCP(matches)
  if (list) {
    printf "%-10s %s\n", "LCP:", tlide_path(commnon)
    asorti(matches, dirs, "@val_num_asc")
    for (i in dirs) {
      printf "%-10s %s\n", matches[dirs[i]], tlide_path(dirs[i])
    }
    return
  }
  if (!typ) {
    best_match = commnon
  }
  print best_match
}

function LCP (matches) {
  for (x in matches) {
    if (!short || length(x) < length(short)) {
      short = x
    }
  }
  # skip
  # if (short == "/") { return }
  for (x in matches) {
    if (index(x, short) != 1) {
      return
    }
  }
  return short
}

BEGIN {
  # args: list(bool) q(str?) typ('rank'|'time')
  now = systime()
  # typ == 'time' uses negatives
  # in case 1 year of seconds == 3.1536e7, 1e9 => 31 years
  max_rank = imax_rank = -1e9
  # already handled
  # list = q ? list : 1
  gsub(/ /, ".*", q)
  HOME = ENVIRON["HOME"]
}

{
  switch (typ) {
    case "rank":
      rank = $2
      break
    case "time":
      rank = $3 - now
      break
    default:
      rank = frecent($2, $3)
      break
  }
  if ($1 ~ q) {
    matches[$1] = rank
    if (rank > max_rank) {
      max_rank = rank
      best_match = $1
    }
  } else {
    IGNORECASE = 1
    if ($1 ~ q) {
      imatches[$1] = rank
      if (rank > imax_rank) {
        imax_rank = rank
        ibest_match = $1
      }
    }
  }
}

END {
  if (best_match) {
    output(matches, best_match)
  } else if (ibest_match) {
    output(imatches, ibest_match)
  } else {
    exit 1
  }
}
