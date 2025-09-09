param (
  [Parameter(Mandatory, Position = 0)]
  [string[]]
  $Path
)
Get-Item $Path -Force -ea Ignore | ForEach-Object {
  if ($_.Mode.StartsWith('l') -and [System.IO.Path]::IsPathRooted($_.Target)) {
    $null = New-Item -Type SymbolicLink -Target ([System.IO.Path]::GetRelativePath($_.DirectoryName, $_.Target)) $_.FullName -Force
  }
}
