@{
  RootModule           = './GithubRelease.psm1'
  ModuleVersion        = '0.3.0'
  CompatiblePSEditions = 'Core'
  GUID                 = '35d514bd-503b-442f-9de9-083c0463080f'
  Author               = 'Ming Chen'
  CompanyName          = 'Unknown'
  Copyright            = '(c) Ming Chen. All rights reserved.'
  Description          = 'Enhance clis by these extra commands.'
  PowerShellVersion    = '7.6.0'
  RequiredModules      = 'PSToml', 'Yayaml'
  FunctionsToExport    = 'Update-Release', 'Update-Software', 'Update-System'
  CmdletsToExport      = @()
  VariablesToExport    = @()
  AliasesToExport      = @()
  FileList             = './globalTools.yml', './releases.yml'
}
