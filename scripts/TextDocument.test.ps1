#Requires -Version 7.5 -Modules Pester
using namespace Microsoft.Windows.PowerShell.ScriptAnalyzer

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

. $PSScriptRoot/TextDocument.ps1

BeforeAll {
  Write-Host ([TextDocument].FullName)
  $Global:document = [TextDocument]::new(@'
  hello,
  world
'@)
}

Describe '#offsetAt' {
  It 'must true offset' {
    $document.offsetAt([Position]::new(1, 6)) | Should -Be 5
    $document.offsetAt([Position]::new(2, 3)) | Should -Be 10
  }
}
