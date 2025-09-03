function hex {
  param(
    [switch]$NoPrefix
  )
  $c = switch ($MyInvocation.InvocationName) {
    'bin' { 'b'; break }
    'oct' { 'o'; break }
    default { 'x'; break }
  }
  @($input; $args.ForEach{ $_ }).ForEach{
    $value = $_
    $value = if ($value -is [string]) {
      try {
        if ($value.StartsWith('-')) {
          [long]$value
        }
        else {
          [ulong]$value
        }
      }
      catch {
        if ($value -match '^([+-]?)0o([0-7]+)$') {
          if ($Matches[1] -eq '-') {
            - [System.Convert]::ToInt64($Matches[2], 8)
          }
          else {
            [System.Convert]::ToUInt64($Matches[2], 8)
          }
        }
        elseif ($value -match '^([+-]?)([\da-f]+)$') {
          $value = "$($Matches[1])0x$($Matches[2])"
          if ($Matches[1] -eq '-') {
            [long]$value
          }
          else {
            [ulong]$value
          }
        }
        else {
          return Write-Error $_
        }
      }
    }
    elseif ($value -is [System.ValueType]) {
      $value
    }
    else {
      return Write-Error "cannot handle type $($value.GetType().FullName)"
    }
    ($NoPrefix ? '' : "0$c") + $(if ($c -eq 'o') {
        if ($value -is [ulong]) {
          # this keeps the binary same
          $value = [long]::CreateTruncating[ulong]($value)
        }
        [System.Convert]::ToString($value, 8)
      }
      else {
        # enums x format returns upper
        ("{0:$c}" -f $value).ToLower()
      })
  }
}

Set-Alias bin hex
Set-Alias oct hex
