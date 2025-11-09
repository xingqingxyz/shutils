if (!$IsLinux) {
  Write-Error 'can only run on linux'
}
$root = "$env:SHUTILS_ROOT/_"
$files = @{}
Get-ChildItem $root -Exclude windows -Force -ea Ignore |
  Get-ChildItem -Recurse -File -Force -ea Ignore | ForEach-Object {
    $files.($_.FullName) = $_.FullName.Replace($root, $HOME)
  }
$files.GetEnumerator().ForEach{
  New-Item -Type SymbolicLink -Force -Target $_.Key $_.Value
}
$historyDir = [System.IO.Path]::GetDirectoryName((Get-PSReadLineOption).HistorySavePath)
New-Item -ItemType SymbolicLink -Force -Target ConsoleHost_history.txt "$historyDir\Visual Studio Code Host_history.txt"
