<#
.SYNOPSIS
Make absolute links to relative symbolic links, returns created link info.
 #>
[CmdletBinding()]
[OutputType([System.IO.FileInfo])]
param (
  [Parameter(Mandatory, Position = 0)]
  [string[]]
  $Path
)
Get-Item $Path -Force -ea Ignore | ForEach-Object {
  if ($_.Mode.StartsWith('l') -and [System.IO.Path]::IsPathRooted($_.Target)) {
    New-Item -Type SymbolicLink -Target ([System.IO.Path]::GetRelativePath($_.DirectoryName, $_.Target)) $_.FullName -Force
  }
}
