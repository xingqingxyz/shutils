if (!$IsWindows) {
  Write-Error 'can only run on windows'
}
Repair-GitSymlinks
$root = "$env:SHUTILS_ROOT\_\windows"
$files = @{}
Get-ChildItem $root -Recurse -File -ea Ignore | ForEach-Object {
  $files.($_.ResolvedTarget) = $_.FullName.Replace($root, $HOME)
}
$files.GetEnumerator().ForEach{
  Write-Information "$($_.Value) -> $($_.Key)"
  $null = New-Item -Type SymbolicLink -Target $_.Key $_.Value -Force
}
