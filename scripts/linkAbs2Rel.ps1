param (
  [Parameter(Mandatory, Position = 0)]
  [string[]]
  $Path
)
Get-Item $Path -Force | ForEach-Object {
  if ($_.UnixMode[0] -eq 'l' -and [System.IO.Path]::IsPathRooted($_.Target)) {
    New-Item -Type SymbolicLink -Target ([System.IO.Path]::GetRelativePath($_.DirectoryName, $_.Target)) $_.FullName -Force
  }
}
