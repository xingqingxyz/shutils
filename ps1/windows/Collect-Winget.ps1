$bakDir = "$PSScriptRoot\backup"
winget.exe export --source winget --output $bakDir\winget-apps.json
if ($LASTEXITCODE) {
  throw 'Winget export failed'
}
(Get-Content -Raw $bakDir\winget-apps.json | ConvertFrom-Json).Sources[0].Packages.PackageIdentifier |
  Out-File $bakDir\winget-list.json
