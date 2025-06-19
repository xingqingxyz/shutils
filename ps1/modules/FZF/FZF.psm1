function pp {
  param(
    [Parameter(Mandatory)]
    [string]
    $Path
  )
  $Path = (Convert-Path $Path)[0]
  $primary, $secondary = (file -b --mime-type $Path).Split('/', 2)
  switch ($primary) {
    'text' { bat --plain --color=always $Path; break }
    'application' {
      switch ($secondary) {
        'javascript' { bat --plain --color=always $Path; break }
        Default { (file -b $Path) -split ',' }
      }
      break
    }
    'image' { icat $Path; break }
    # 'media' { Invoke-Item $Path; break }
    # 'font' { Invoke-Item $Path; break }
    Default { (file -b $Path) -split ',' }
  }
}
