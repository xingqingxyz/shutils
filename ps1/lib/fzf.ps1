function Select-Fzf {
  param(
    [Parameter(Mandatory)]
    [ValidateSet('bat-themes')]
    [string]
    $Name
  )
  switch ($Name) {
    'bat-themes' {
      bat --list-themes | fzf --preview="bat --theme {} --color=always $PROFILE"
    }
    Default {}
  }
}

function Get-PoshThemes {
  param(
    [string]$Path = $env:POSH_THEMES_PATH,
    [switch]$Select
  )
  $items = Get-Item $Path/*.omp.json
  if ($Select) {
    $items = $items.FullName | fzf --scheme=path --preview="oh-my-posh print primary --config {}"
    if ($items) {
      $env:POSH_THEME = $items
    }
    return
  }
  $items | ForEach-Object { $_.Name, (oh-my-posh print primary --config $_.FullName) | Out-String }
}
