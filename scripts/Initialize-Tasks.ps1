Get-ChildItem -LiteralPath $PSScriptRoot/../ps1/tasks -Force -ea Stop | ForEach-Object {
  if ($_.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
    $dir = $_
    $_.GetFiles().ForEach{ Register-PSScheduledTask $_.BaseName (Get-Content -Raw -LiteralPath $_) -Kind $dir.Name }
    return
  }
  . $_.FullName
}
