@{
  RootModule           = './bin/Release/net10.0/Utility.dll'
  ModuleVersion        = '0.0.1'
  CompatiblePSEditions = 'Core'
  GUID                 = '30ea4ed0-c3be-4981-93e2-e594994cede9'
  Author               = 'Ming Chen'
  CompanyName          = 'Unknown'
  Copyright            = '(c) Ming Chen. All rights reserved.'
  Description          = 'Powershell utility commands.'
  PowerShellVersion    = '7.6.0'
  RequiredAssemblies   = './bin/Release/net10.0/CoreAudio.dll'
  FunctionsToExport    = 'Get-AudioDevice', 'Set-AudioDevice'
  CmdletsToExport      = @()
  VariablesToExport    = @()
  AliasesToExport      = @()
}
