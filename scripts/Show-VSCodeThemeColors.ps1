[CmdletBinding()]
param (
  [Parameter(Position = 0)]
  [string[]]
  $Path = '/usr/share/code/resources/app/extensions/theme-defaults/themes/dark_modern.json'
)

function hex([string]$Color) {
  $r, $g, $b = $Color.Substring(1, 2), $Color.Substring(3, 2), $Color.Substring(5, 2)
  [System.Convert]::ToInt32($r, 16),
  [System.Convert]::ToInt32($g, 16),
  [System.Convert]::ToInt32($b, 16) -join ';'
}

(Get-Item $Path).ForEach{
  $colors = (Get-Content -Raw -LiteralPath $_.FullName | ConvertFrom-Json -AsHashtable).colors
  $newColors = @{}
  $colors.GetEnumerator().ForEach{
    $newColors[$_.Key] = "`e[48;2;$(hex $_.Value)m$($_.Value)`e[0m"
  }
  $_.FullName
  $newColors.GetEnumerator() | Sort-Object Key
}
