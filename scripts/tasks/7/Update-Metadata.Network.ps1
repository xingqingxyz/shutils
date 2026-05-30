# stars
try {
  $text = Invoke-GithubGraphQL stars
  $text > "$env:WISH_ROOT/scripts/data/stars.txt"
}
catch { }
