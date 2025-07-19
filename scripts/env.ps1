
$environment = @{}
for ($i = 0; $i -lt $args.Length; $i++) {
  $name, $value = $args[$i].Split('=', 2)
  if ($null -eq $value) {
    break
  }
  $environment.$name = $value
}
$Command = (Get-Command -Type Application -TotalCount 1 -ea Stop $args[$i]).Path
$ArgumentList = $args[($i + 1)..($args.Length)]
$saveEnvironment = @{}
$environment.GetEnumerator().ForEach{
  # ignore non exist
  $saveEnvironment[$_.Key] = (Get-Item -LiteralPath Env:$($_.Key)).Value
  Set-Item -LiteralPath Env:$($_.Key) $_.Value
}
Write-Debug "$($args[0..($i-1)]) $Command $ArgumentList"
try {
  if ($InputObject) {
    $InputObject | & $Command @ArgumentList
  }
  else {
    & $Command @ArgumentList
  }
}
finally {
  foreach ($key in $environment.Keys) {
    if ($saveEnvironment.Contains($key)) {
      Set-Item -LiteralPath Env:$key $saveEnvironment.$key
    }
    else {
      Remove-Item -LiteralPath Env:$key -ea Ignore
    }
  }
}
