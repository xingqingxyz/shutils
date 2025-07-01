$files = @{}
Get-ChildItem ${env:SHUTILS_ROOT}\windows -Recurse -File -Force -ea Ignore | ForEach-Object {
  $files.($_.ResolvedTarget) = $_.FullName.Replace("$env:SHUTILS_ROOT\windows", $HOME)
}
@'
.bashrc
.lessfilter
.nanorc
.npmrc
.prettierrc
'@.Split("`r`n").ForEach{ $files."${env:SHUTILS_ROOT}\$_" = "$HOME\$_" }
$files.GetEnumerator().ForEach{
  Write-Debug "$($_.Value) -> $($_.Key)"
  New-Item -Type SymbolicLink -Target $_.Key $_.Value -Force
}
