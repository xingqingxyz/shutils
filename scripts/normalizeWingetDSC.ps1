param ([string[]]$Path = $PWD, [switch]$WhatIf)

Get-ChildItem -Path $Path -Filter *.dsc.yml -File | ForEach-Object {
  #Requires -Modules Yayaml
  $yml = Get-Content -Raw $_ | ConvertFrom-Yaml
  foreach ($r in $yml.properties.resources) {
    if ($r.resource -eq 'Microsoft.WinGet.DSC/WinGetPackage') {
      $r.directives.description = $r.settings.id
      $r.id = $r.settings.id -replace '[^\w]', '_'
    }
  }
  $yml = $yml | ConvertTo-Yaml -Depth 100
  if ($WhatIf) {
    $yml | bat -lyml
  }
  else {
    $yml > $_
  }
}
