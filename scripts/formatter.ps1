#Requires -Modules PSScriptAnalyzer

param([Parameter(Mandatory, ValueFromPipelineByPropertyName)][string[]]$Path, [switch]$Recurse)

Get-ChildItem $Path -Recurse:$Recurse -File | ForEach-Object {
  Invoke-Formatter (Get-Content -Raw $_) | Out-File $_
  Write-Verbose "Formatted $_"
}
