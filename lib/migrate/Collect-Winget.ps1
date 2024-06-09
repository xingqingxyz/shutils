$bakDir = "$PSScriptRoot\backup"
winget.exe export --source winget --output $bakDir\winget-apps.json
if ($LASTEXITCODE) {
    throw 'Winget export failed'
}
(Get-Content $bakDir\winget-apps.json | ConvertFrom-Json).Sources[0].Packages |
    ForEach-Object { $_.PackageIdentifier } |
    ConvertTo-Json |
    Out-File $bakDir\winget-list.json
