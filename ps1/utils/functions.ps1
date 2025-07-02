function quote([string]$s) {
  if ($s.Length -le 1) {
    return "'$s'"
  }
  $s = switch ($s[0]) {
    "'" { $s; break }
    '"' { "'" + $s.Substring(1); break }
    default { "'" + $s; break }
  }
  switch ($s[-1]) {
    "'" { $s; break }
    '"' { $s.Substring(0, $s.Length - 1) + "'"; break }
    default { $s + "'"; break }
  }
}

function unquote([string]$s) {
  $s -replace "^['`"]|['`"]$", ''
}
