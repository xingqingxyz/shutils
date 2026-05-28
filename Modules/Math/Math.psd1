@{
  RootModule           = './Math.psm1'
  ModuleVersion        = '0.1.1'
  CompatiblePSEditions = 'Core'
  GUID                 = '48999db4-cbc5-4a06-ad0f-1b4f1be72fe9'
  Author               = 'Ming Chen'
  CompanyName          = 'Unknown'
  Copyright            = '(c) Ming Chen. All rights reserved.'
  Description          = 'Enhance clis by these extra commands.'
  PowerShellVersion    = '7.6.0'
  FunctionsToExport    = 'hex'
  CmdletsToExport      = @()
  VariablesToExport    = @()
  AliasesToExport      = 'bin', 'dec', 'oct'
}
