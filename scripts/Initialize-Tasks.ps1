Get-ChildItem -LiteralPath $env:SHUTILS_ROOT/ps1/tasks -Force -ea Stop | ForEach-Object {
  if ($_.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
    $dir = $_
    $_.GetFiles().ForEach{ Register-PSScheduledTask $_.BaseName "pwsh -noni -nop $_" -Interval $dir.Name -Persistent }
    return
  }
  . $_.FullName
}
