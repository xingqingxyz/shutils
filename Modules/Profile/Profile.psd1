@{
  RootModule           = './Profile.psm1'
  ModuleVersion        = '0.3.0'
  CompatiblePSEditions = 'Core'
  GUID                 = 'e59afded-5b1c-441d-84bc-8e82f6bdac7e'
  Author               = 'Ming Chen'
  CompanyName          = 'Unknown'
  Copyright            = '(c) Ming Chen. All rights reserved.'
  Description          = 'PowerShell profile.'
  PowerShellVersion    = '7.6.0'
  FunctionsToExport    = 'Format-Duration', 'Get-PowerShellExecArgs', 'Show-CommandInfo', 'cd...', 'cd....', 'uev', 'npx', 'prompt', 'sudo', 'x'
  CmdletsToExport      = @()
  VariablesToExport    = @()
  AliasesToExport      = 'e', 'k', 'l'
  FileList             = './NerdFont.psd1', './NerdFontIcon.psd1'
}
