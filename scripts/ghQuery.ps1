function ghQuery {
  [CmdletBinding()]
  param (
    [Parameter(Position = 0)]
    [ValidateSet('releases', 'limit', 'stars')]
    [string]
    $Category = 'releases',
    [Parameter(Position = 1, ValueFromRemainingArguments)]
    [string[]]
    $Queries
  )
  [string]$query = "query=@$env:SHUTILS_ROOT/gql/github/$Category.gql"
  [string[]]$fields = @()
  [string]$jq = '.'
  switch ($Category) {
    releases {
      $jq = '.repository.latestRelease[].name'
      $owner, $name = $Queries.Split('/', 2)
      $fields += "owner=$owner", "name=$name"
      break
    }
    stars {
      $jq = '.user.starredRepositories[].nameWithOwner'
      break
    }
  }
  gh api graphql -F $query $fields.ForEach{ "-f=$_" } -q $jq | Tee-Object Temp:/ghQuery.json | jq
}
