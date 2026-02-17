function Set-DarkMode ([switch]$Off) {
  Set-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'SystemUsesLightTheme' -Value ([int]$Off.IsPresent) -Type DWord
  Set-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'AppsUseLightTheme' -Value ([int]$Off.IsPresent) -Type DWord
}

function Set-DscResourcePath {
  $env:DSC_RESOURCE_PATH = $null
  $resources = dsc resource list | ConvertFrom-Json
  $env:DSC_RESOURCE_PATH = ($resources.directory | Sort-Object -Unique) -join [System.IO.Path]::PathSeparator
  [System.Environment]::SetEnvironmentVariable('DSC_RESOURCE_PATH', $env:DSC_RESOURCE_PATH, 'User')
}

# pwsh scripts
Install-Script Refresh-EnvironmentVariables
# alacritty startup
if (Get-Command alacritty -Type Application -TotalCount 1 -ea Ignore) {
  $null = New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Alacritty' -Value 'C:\Program Files\Alacritty\alacritty.exe' -PropertyType String -Force
}
else {
  Remove-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -Name 'Alacritty' -ea Ignore
}
# misc
Set-DarkMode
if (Get-Command dsc -CommandType Application -TotalCount 1 -ea Ignore) {
  Set-DscResourcePath
}
