@{
  RootModule           = 'Tools.psm1'
  ModuleVersion        = '0.0.1'
  CompatiblePSEditions = 'Core'
  GUID                 = '0d87529a-5193-45ff-8ab8-d8eb3e90a57d'
  Author               = 'Ming Chen'
  CompanyName          = 'Unknown'
  Copyright            = '(c) Ming Chen. All rights reserved.'
  Description          = 'Powershell tools.'
  PowerShellVersion    = '7.6.0'
  FormatsToProcess     = './Tools.format.ps1xml'
  FunctionsToExport    = 'Get-MemoryInfo', 'Get-TypeMember', 'Search-Web', 'Set-SystemProxy', 'Test-Administrator', 'Get-EnvironmentVariable', 'Set-EnvironmentVariable', 'Set-EnvironmentVariablePath', 'Update-SessionEnvironment', 'Use-DevelopmentEnvironment', 'delay', 'icat'
  CmdletsToExport      = @()
  VariablesToExport    = @()
  AliasesToExport      = 'gtm', 'sw', 'ssp', 'gev', 'sev', 'sevp', 'ude'
}
