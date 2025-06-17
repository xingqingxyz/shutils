param([string[]]$Path = $PWD)

Get-ChildItem -Path $Path -Filter *.dsc.yml -File | ForEach-Object {
  #Requires -Modules Yayaml
  $obj = Get-Content -Raw $_ | ConvertFrom-Yaml
  [System.Object[]]$resources = $obj.properties.resources
  $obj.properties.resources = $resources.ForEach{
    if ($_.resource -eq 'Microsoft.WinGet.DSC/WinGetPackage') {
      $_.directives.description = $_.settings.id
      $_.id = $_.settings.id -replace '[-.]', '_'
    }
    $_
  }
  $obj | ConvertTo-Yaml -Depth 100 | Out-File $_
}
