param(
  [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
  [string[]]$Path,
  [Parameter(Mandatory)]
  [string]$Query,
  [string]$Key = '.',
  [System.Text.Encoding]$Encoding = [System.Text.Encoding]::UTF8,
  [switch]$WhatIf
)

Get-ChildItem $Path -File | ForEach-Object {
  $cur = $_
  $ext = switch ($cur.Extension.ToLower().Substring(1)) {
    'jsonc' { 'json'; break }
    'yml' { 'yaml'; break }
    Default { $_ }
  }
  $content = Get-Content -Raw -Encoding $Encoding $cur
  $content = switch ($ext) {
    'json' {
      $content | jq "$Query |= sort_by($Key)"
      break
    }
    'yaml' {
      $content | ConvertFrom-Yaml | ConvertTo-Json -Depth 100 | jq "$Query |= sort_by($Key)" | ConvertFrom-Json -Depth 100 | ConvertTo-Yaml -Depth 100
      break
    }
    'toml' {
      $content | ConvertFrom-Toml | ConvertTo-Json -Depth 100 | jq "$Query |= sort_by($Key)" | ConvertFrom-Json -Depth 100 | ConvertTo-Toml -Depth 100
      break
    }
  }
  $content | bat -l $ext
  if ($WhatIf) {
    $Global:a = Compare-Object (Get-Content -Raw -Encoding $Encoding $cur) $content -IncludeEqual -PassThru
  }
  else {
    $content | Out-File -Encoding $Encoding $cur
  }
}
