@{
  RootModule           = './bin/Release/net10.0/LSColors.dll'
  ModuleVersion        = '0.1.0'
  CompatiblePSEditions = 'Core'
  GUID                 = '44b7341c-5b27-4fdb-b189-bcd5f3c2f9ae'
  Author               = 'Ming Chen'
  CompanyName          = 'Unknown'
  Copyright            = '(c) Ming Chen. All rights reserved.'
  Description          = 'PowerShell profile functions library.'
  PowerShellVersion    = '7.6.0'
  ScriptsToProcess     = './LSColors.ps1'
  FunctionsToExport    = @()
  CmdletsToExport      = @()
  VariablesToExport    = @()
  AliasesToExport      = @()
  FileList             = './LSColors.csv', './LSColors.format.ps1xml', './LSColors.windows.format.ps1xml'
}
