Get-ChildItem -LiteralPath $PSScriptRoot/../ps1/tasks -Force -ea Stop | ForEach-Object {
  if ($_.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
    $dir = $_
    $_.GetFiles().ForEach{
      $name, $props = $_.BaseName.Split('.')
      $params = @{}
      $props.ForEach{ $params[$_] = $true }
      Register-PSScheduledTask $name "pwsh -noni -nop $_" -Interval $dir.Name -Persistent -Force @params
    }
    return
  }
  . $_.FullName
}
