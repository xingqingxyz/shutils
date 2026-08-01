@{
  RootModule           = './Extras.psm1'
  ModuleVersion        = '0.0.1'
  CompatiblePSEditions = 'Core'
  GUID                 = '6046d1fe-f87d-4f0a-babc-da88e77239d1'
  Author               = 'Ming Chen'
  CompanyName          = 'Unknown'
  Copyright            = '(c) Ming Chen. All rights reserved.'
  Description          = 'Enhanced powershell commands.'
  PowerShellVersion    = '7.6.0'
  FunctionsToExport    = 'Get-GithubRepositoryBlob', 'Invoke-GithubGraphQL', 'Register-PSScheduledTask', 'Unregister-PSScheduledTask', 'Get-Region', 'Set-Region', 'ConvertTo-RelativeSymlink', 'New-RelativeSymlink', 'Get-DarkMode', 'Get-Wallpaper', 'Set-Wallpaper', 'Send-Notify', 'Show-ScreenText', 'de', 'de.f', 'figlet.f', 'jq.f', 'rg.f'
  CmdletsToExport      = @()
  VariablesToExport    = @()
  AliasesToExport      = @()
  FileList             = './vimDigraph.tsv', './github/limits.gql', './github/releases.gql', './github/stars.gql'
}
