if (!$IsWindows) {
  return
}

function env {
  $environment = @{}
  for ($i = 0; $i -lt $args.Length; $i++) {
    $name, $value = $args[$i].Split('=', 2)
    if ($null -eq $value) {
      break
    }
    $environment.$name = $value
  }
  $Command = (Get-Command -Type Application -TotalCount 1 -ea Stop $args[$i]).Path
  $ArgumentList = $args[($i + 1)..($args.Length - 1)]
  $saveEnvironment = @{}
  $environment.GetEnumerator().ForEach{
    # ignore non exist
    $item = Get-Item -LiteralPath env:$($_.Key) -ea Ignore
    if ($item) {
      $saveEnvironment[$_.Key] = $item.Value
    }
    Set-Item -LiteralPath env:$($_.Key) $_.Value
  }
  Write-Debug "$($args[0..($i-1)]) $Command $ArgumentList"
  try {
    if ($InputObject) {
      $InputObject | & $Command $ArgumentList
    }
    else {
      & $Command $ArgumentList
    }
  }
  finally {
    foreach ($key in $environment.Keys) {
      if ($saveEnvironment.Contains($key)) {
        Set-Item -LiteralPath env:$key $saveEnvironment.$key
      }
      else {
        Remove-Item -LiteralPath env:$key -ea Ignore
      }
    }
  }
}

function setenv {
  $args.ForEach{
    $value = "$_"
    $index = $value.IndexOf('=')
    if ($index -eq -1) {
      $key = $value
      $value = '1'
    }
    elseif ($index -and $value.IndexOf('+') -eq $index - 1) {
      $key = $value.Substring(0, $index - 1)
      $value = [System.Environment]::GetEnvironmentVariable($key, 'User') + $value.Substring($index + 1)
    }
    else {
      $key = $value.Substring(0, $index)
      $value = $value.Substring($index + 1)
    }
    if (!$key) {
      return Write-Error "use empty key to set env value: $value"
    }
    Write-Debug "$key=$value"
    [System.Environment]::SetEnvironmentVariable($key, $value, 'User')
    Set-Item -LiteralPath env:$key $value
  }
}
