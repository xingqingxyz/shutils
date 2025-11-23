$files = @{}

if ($IsWindows) {
  Repair-GitSymlinks
  $root = "$env:SHUTILS_ROOT\_\windows"
  Get-ChildItem -LiteralPath $root -Recurse -File -ea Ignore | ForEach-Object {
    $key = $_.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint) ? $_.ResolvedTarget : $_.FullName
    $files[$key] = $_.FullName.Replace($root, $HOME)
  }
}
else {
  $root = "$env:SHUTILS_ROOT/_"
  Get-ChildItem -LiteralPath $root -Exclude windows -Force -ea Ignore |
    Get-ChildItem -Recurse -File -Force -ea Ignore | ForEach-Object {
      $files[(realpath $_.FullName)] = $_.FullName.Replace($root, $HOME)
    }
}

$files.GetEnumerator().ForEach{
  if ((Get-Item -LiteralPath $_.Value -ea Ignore).Target -cne $_.Key) {
    New-Item -Type SymbolicLink -Force -Target $_.Key $_.Value
  }
}
