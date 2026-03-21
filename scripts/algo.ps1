<#
.SYNOPSIS
Base64 编码/解码算法实现（纯位操作）
.DESCRIPTION
提供 Base64 编码和解码函数，支持字符串和文件模式。
#>

# Base64 字符表
$Base64Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'.ToCharArray()
$Base64Map = @{}
for ($i = 0; $i -lt 64; $i++) {
  $Base64Map[$Base64Chars[$i]] = $i
}

function Convert-Base64Encode {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string]$Text,

    [Parameter()]
    [Switch]$NoPadding
  )

  $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
  $divRem = [int]::DivRem($bytes.Length, 3)
  $len = $divRem.Item1 * 3
  $out = [System.Text.StringBuilder]::new(($divRem.Item1 + 1) * 4)

  for ($i = 0; $i -lt $len; $i += 3) {
    $triplet = ([int]$bytes[$i] -shl 16) -bor ([int]$bytes[$i + 1] -shl 8) -bor $bytes[$i + 2]
    $null = for ($j = 18; $j -ge 0; $j -= 6) {
      $out.Append($Base64Chars[($triplet -shr $j) -band 0x3f])
    }
  }

  $null = switch ($divRem.Item2) {
    1 {
      $out.Append($Base64Chars[$bytes[$len] -shr 2])
      $out.Append($Base64Chars[($bytes[$len] -shl 4) -band 0x3f])
      if ($NoPadding) {
        break
      }
      $out.Append('==')
      break
    }
    2 {
      $out.Append($Base64Chars[$bytes[$len] -shr 2])
      $out.Append($Base64Chars[(($bytes[$len] -shl 4) -bor ($bytes[$len + 1] -shr 4)) -band 0x3f])
      $out.Append($Base64Chars[($bytes[$len + 1] -shl 2) -band 0x3f])
      if ($NoPadding) {
        break
      }
      $out.Append('=')
      break
    }
  }
  $out.ToString()
}

function Convert-Base64Decode {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string]$Base64Text
  )

  if ($Base64Text -notmatch '^[A-Z\d+/=]+$') {
    throw '无效 Base64 字符串'
  }

  if ($Base64Text.Length % 4) {
    throw '无效的 Base64 字符串长度，必须为 4 的倍数（允许末尾补齐）。'
  }

  $outBytes = New-Object System.Collections.Generic.List[byte]
  for ($i = 0; $i -lt $Base64Text.Length; $i += 4) {
    $c0 = $Base64Text[$i]
    $c1 = $Base64Text[$i + 1]
    $c2 = $Base64Text[$i + 2]
    $c3 = $Base64Text[$i + 3]

    $v0 = $Base64Map[$c0]
    $v1 = $Base64Map[$c1]
    $v2 = if ($c2 -eq '=') { 0 } else { $Base64Map[$c2] }
    $v3 = if ($c3 -eq '=') { 0 } else { $Base64Map[$c3] }

    $triplet = ($v0 -shl 18) -bor ($v1 -shl 12) -bor ($v2 -shl 6) -bor $v3

    $outBytes.Add([byte](($triplet -shr 16) -band 0xFF))
    if ($c2 -ne '=') { $outBytes.Add([byte](($triplet -shr 8) -band 0xFF)) }
    if ($c3 -ne '=') { $outBytes.Add([byte]($triplet -band 0xFF)) }
  }

  [System.Text.Encoding]::UTF8.GetString($outBytes.ToArray())
}

function Convert-Base64EncodeFile {
  [CmdletBinding()]
  [OutputType([string])]
  param (
    [Parameter(Mandatory, Position = 0)]
    [string]$Path
  )
  [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($Path))
}

function Convert-Base64DecodeToFile {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
    [string]$Base64Text,

    [Parameter(Mandatory, Position = 1)]
    [string]$Path
  )
  [System.IO.File]::WriteAllBytes($Path, [System.Convert]::FromBase64String($Base64Text))
}
