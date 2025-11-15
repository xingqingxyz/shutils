if ($IsWindows) {
  Repair-GitSymlinks
  $root = "$env:SHUTILS_ROOT\_\windows"
  $files = @{}
  Get-ChildItem -LiteralPath $root -Recurse -File -ea Ignore | ForEach-Object {
    $key = $_.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint) ? $_.ResolvedTarget : $_.FullName
    $files[$key] = $_.FullName.Replace($root, $HOME)
  }
  $files.GetEnumerator().ForEach{
    New-Item -Type SymbolicLink -Force -Target $_.Key $_.Value
  }
  return
}

$root = "$env:SHUTILS_ROOT/_"
$files = @{}
Get-ChildItem -LiteralPath $root -Exclude windows -Force -ea Ignore |
  Get-ChildItem -Recurse -File -Force -ea Ignore | ForEach-Object {
    $files[(realpath $_.FullName)] = $_.FullName.Replace($root, $HOME)
  }
$files.GetEnumerator().ForEach{
  New-Item -Type SymbolicLink -Force -Target $_.Key $_.Value
}
