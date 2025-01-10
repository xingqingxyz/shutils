#Requires -Modules PSScriptAnalyzer

param([Parameter(Mandatory, ValueFromPipelineByPropertyName)][string[]]$Path, [switch]$Recurse)

Get-ChildItem $Path -Recurse:$Recurse | ForEach-Object {
  if ($_.Mode[0] -eq 'd') {
    if ($Recurse) {
      & $MyInvocation.MyCommand.Definition -Path $_ -Recurse
    }
  }
  else {
    Invoke-Formatter (Get-Content -Raw $_) | Out-File $_
    Write-Verbose "Formatted $_"
  }
}
