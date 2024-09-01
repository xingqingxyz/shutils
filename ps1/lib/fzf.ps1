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
