if (!$IsWindows) {
  Write-Error 'can only run on windows'
}
Repair-GitSymlinks
$root = "$env:SHUTILS_ROOT\_\windows"
$files = @{}
Get-ChildItem $root -Recurse -File -ea Ignore | ForEach-Object {
  $key = $_.LinkType ? $_.ResolveLinkTarget($false).FullName : $_.FullName
  $files.$key = $_.FullName.Replace($root, $HOME)
}
$files.GetEnumerator().ForEach{
  New-Item -Type SymbolicLink -Force -Target $_.Key $_.Value
}
