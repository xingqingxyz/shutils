if (!$IsLinux) {
  Write-Error 'can only run on linux'
}
$root = "${env:SHUTILS_ROOT}/_"
$files = @{}
Get-ChildItem $root -Exclude windows -Force -ea Ignore |
  Get-ChildItem -Recurse -File -Force -ea Ignore | ForEach-Object {
    $files.($_.FullName) = $_.FullName.Replace($root, $HOME)
  }
$files.GetEnumerator().ForEach{
  Write-Information "$($_.Value) -> $($_.Key)"
  $null = New-Item -Type SymbolicLink -Target $_.Key $_.Value -Force
}
