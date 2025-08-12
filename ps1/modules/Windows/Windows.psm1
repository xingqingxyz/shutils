function bat {
  if ($MyInvocation.PipelinePosition -eq $MyInvocation.PipelineLength) {
    if ($MyInvocation.ExpectingInput) {
      $input | bat.exe --color=always $args | & 'C:\Program Files\Git\usr\bin\less.exe'
    }
    else {
      bat.exe --color=always $args | & 'C:\Program Files\Git\usr\bin\less.exe'
    }
  }
  else {
    if ($MyInvocation.ExpectingInput) {
      $input | bat.exe $args
    }
    else {
      bat.exe $args
    }
  }
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
