[CmdletBinding()]
param (
  [Parameter(Position = 0)]
  [SupportsWildcards()]
  [string[]]
  $Path = [System.IO.Path]::Join([System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::CommonApplicationData), 'code/resources/app/extensions/theme-defaults/themes/dark_modern.json')
)
$Path.ForEach{
  [hashtable]$colors = (Get-Content -Raw -LiteralPath $_ | ConvertFrom-Json -AsHashtable).colors
  $newColors = @{}
  $colors.GetEnumerator().ForEach{
    $newColors[$_.Key] = "`e[48;2;{0};{1};{2}m{3}`e[0m" -f @(
      [System.Convert]::ToInt32($_.Value.Substring(1, 2), 16)
      [System.Convert]::ToInt32($_.Value.Substring(3, 2), 16)
      [System.Convert]::ToInt32($_.Value.Substring(5, 2), 16)
      $_.Value
    )
  }
  $_
  $newColors.GetEnumerator() | Sort-Object Key
}
