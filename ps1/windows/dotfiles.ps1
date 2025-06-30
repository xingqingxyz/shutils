$files = @{}
Get-ChildItem ${env:SHUTILS_ROOT}/windows -Recurse -File -Force -ea Ignore | ForEach-Object {
  $files.($_.ResolvedTarget) = $_.FullName.Replace($env:SHUTILS_ROOT, $HOME)
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
  New-Item -Type SymbolicLink -Target $_.Key $_.Value -Force
}
