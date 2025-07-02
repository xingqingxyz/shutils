$files = @{}
Get-ChildItem ${env:SHUTILS_ROOT}/.config, ${env:SHUTILS_ROOT}/.local -Recurse -File -Force -ea Ignore | ForEach-Object {
  $files.($_.FullName) = $_.FullName.Replace($env:SHUTILS_ROOT, $HOME)
}
@'
.bash_profile
.bashrc
.gitconfig
.lessfilter
.nanorc
.npmrc
.prettierrc
'@.Split("`n").ForEach{ $files."${env:SHUTILS_ROOT}\$_" = "$HOME\$_" }
$files.GetEnumerator().ForEach{
  Write-Debug "$($_.Value) -> $($_.Key)"
  New-Item -Type SymbolicLink -Target $_.Key $_.Value -Force
}
