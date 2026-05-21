[CmdletBinding()]
param (
  [Parameter()]
  [switch]
  $Uninstall
)

if ($IsLinux) {
  $null = New-Item -ItemType Directory ~/.config/systemd/user -Force
}
Get-ChildItem -LiteralPath $PSScriptRoot/tasks -Force -ea Stop | ForEach-Object {
  if ($_.Attributes.HasFlag([System.IO.FileAttributes]::Directory)) {
    $dir = $_
    $_.GetFiles().ForEach{
      $name, $props = $_.BaseName.Split('.')
      if ($Uninstall) {
        return Unregister-PSScheduledTask pwsh-$($dir.Name)d-$name
      }
      $params = @{}
      $props.ForEach{ $params[$_] = $true }
      if ($props.Admin) {
        sudo Register-PSScheduledTask $name "pwsh -noni -nop $_" -DaysInterval $dir.Name -Persistent -Force @params
      }
      else {
        Register-PSScheduledTask $name "pwsh -noni -nop $_" -DaysInterval $dir.Name -Persistent -Force @params
      }
    }
    return
  }
  if ($Uninstall) {
    return
  }
  . $_.FullName
}
