function fzfList {
  param([string]$Name)
  switch ($Name) {
    'bat-themes' {
      bat --list-themes | fzf --preview="bat --theme {} --color=always $PROFILE"
    }
    Default {}
  }
}
