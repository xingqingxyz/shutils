#region cross
function env {
  $environment = @{}
  [regex]$reEnv = [regex]::new('^\w+\+?=')
  # flat iterator args for native passing
  # note: replace token -- with `-- to escape function passing
  [string[]]$ags = foreach ($arg in [string[]]$args.ForEach{ $_ }) {
    if (!$reEnv.IsMatch($arg)) {
      $arg
      $foreach
      break
    }
    [string]$key, [string]$value = $arg.Split('=', 2)
    if ($key.EndsWith('+')) {
      $key = $key.TrimEnd('+')
      $value = [System.Environment]::GetEnvironmentVariable($key) + $value
    }
    $environment.$key = $value
  }
  $ags[0] = (Get-Command $ags[0] -Type Application -TotalCount 1 -ea Stop).Source
  $saveEnvironment = @{}
  $environment.GetEnumerator().ForEach{
    [string]$value = [System.Environment]::GetEnvironmentVariable($_.Key)
    if (![string]::IsNullOrEmpty($value)) {
      $saveEnvironment[$_.Key] = $value
    }
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
  }
  Write-Debug "$($environment.GetEnumerator()) $ags"
  try {
    [string]$cmd, $ags = $ags
    if ($MyInvocation.ExpectingInput) {
      $input | & $cmd $ags
    }
    else {
      & $cmd $ags
    }
  }
  finally {
    $saveEnvironment.GetEnumerator().ForEach{
      [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
    }
  }
  if ($LASTEXITCODE) {
    throw "exit status $LASTEXITCODE"
  }
}
#endregion
