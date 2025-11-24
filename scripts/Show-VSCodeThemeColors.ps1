[CmdletBinding()]
param (
  [Parameter(Position = 0)]
  [SupportsWildcards()]
  [string[]]
  $Path = $IsWindows ? "$env:LOCALAPPDATA\Programs\Microsoft VS Code\resources\app\extensions\theme-defaults\themes\dark_modern.json" : '/usr/share/code/resources/app/extensions/theme-defaults/themes/dark_modern.json'
)
$Path.ForEach{
  $_
  (Get-Content -Raw -LiteralPath $_ | ConvertFrom-Json -AsHashtable).colors.GetEnumerator() |
    Sort-Object Key | ForEach-Object {
      [System.Collections.DictionaryEntry]::new($_.Key, ("`e[48;2;{0};{1};{2}m{3}`e[0m" -f @(
            [System.Convert]::ToInt32($_.Value.Substring(1, 2), 16)
            [System.Convert]::ToInt32($_.Value.Substring(3, 2), 16)
            [System.Convert]::ToInt32($_.Value.Substring(5, 2), 16)
            $_.Value
          )))
    }
}
