<#
.SYNOPSIS
Strip ANSI escape codes from input or all args text.
 #>
function stripAnsi {
  @(if ($MyInvocation.ExpectingInput) {
      $input
    }
    else {
      $args
    }) | bat --strip-ansi=always --plain
}

<#
.PARAMETER Filter
A sequence of 'Query/Key' pairs.
#>
function sortJSON {
  param(
    [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [string[]]$Path,
    [Parameter(Mandatory)]
    [string[]]$Filter,
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
        $content | jq (($Filter | ForEach-Object {
              $Query, $Key = $_.Split('/', 2)
              $Key ??= '.'
              "$Query |= sort_by($Key)"
            }) -join '|empty,')
        break
      }
      'yaml' {
        $content = $content | ConvertFrom-Yaml
        Invoke-Expression ($Filter | ForEach-Object {
            $Query, $Key = $_.Split('/', 2)
            $Key ??= '.'
            "`$content$Query = `$content$Query | sort { `$_$Key } -CaseSensitive"
          } | Out-String)
        $content | ConvertTo-Yaml -Depth 100
        break
      }
      'toml' {
        $content = $content | ConvertFrom-Toml
        Invoke-Expression ($Filter | ForEach-Object {
            $Query, $Key = $_.Split('/', 2)
            $Key ??= '.'
            "`$content$Query = `$content$Query | sort { `$_$Key } -CaseSensitive"
          } | Out-String)
        $content | ConvertTo-Toml -Depth 100
        break
      }
    }
    if ($WhatIf) {
      $content | bat -l $ext
    }
    else {
      $content | Out-File -Encoding $Encoding $cur
    }
  }
}
