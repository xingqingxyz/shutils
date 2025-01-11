function stripAnsi {
  @(if ($MyInvocation.ExpectingInput) {
      $input
    }
    else {
      $args
    }) | bat --strip-ansi=always --plain
}

function sortJSON {
  param(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]]$Path,
    [Parameter(Mandatory)]
    [scriptblock]$Filter,
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
        $content | ConvertFrom-Yaml | ForEach-Object { & $Filter } | ConvertTo-Yaml -Depth 100
        break
      }
      'toml' {
        $content | ConvertFrom-Toml | ForEach-Object { & $Filter } | ConvertTo-Toml -Depth 100
        break
      }
    }
    if ($WhatIf) {
      ($Global:a = $content)
    }
    else {
      $content | Out-File -Encoding $Encoding $cur
    }
  }
}
