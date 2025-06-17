gql_get_release() {
  local owner repo typ=${2:-stable} oper=${3:-getInfo} q
  IFS=/ read -r owner repo <<< "$1"
  if [ "$typ" = stable ]; then
    q=.latestRelease
  else
    q='.releases.nodes[0]'
  fi
  gh api graphql -F owner="$owner" -F repo="$repo" \
    -F query="@$SHUTILS_ROOT/gql/$typ.gql" \
    -f operationName="$oper" -q ".data.repository$q" \
    | _gql_query_release "$oper"
}

_gql_query_release() {
  if [ "$1" = getTag ]; then
    jq -r .tagName
    return
  fi
  jq -r '. as $obj | [
    "# [\(.tagName)](\(.url))",
    "\nAt \(.updatedAt)\n",
    .description,
    "---",
    (.releaseAssets.nodes[] |
    "- [\(.name)](\(.downloadUrl)) | \(.size / pow(2; 20) | tostring[:4])M")
  ] | join("\n")'
}
