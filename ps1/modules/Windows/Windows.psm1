#region cross
function env {
  $environment = @{}
  $reEnv = [regex]::new('^\w+\+?=')
  # flat iterator args for native passing
  # note: replace token -- with `-- to escape function passing
  $cmd, $ags = foreach ($arg in [string[]]$args.ForEach{ $_ }) {
    if (!$reEnv.IsMatch($arg)) {
      @($arg; $foreach)
      break
    }
    [string]$key, $value = $arg.Split('=', 2)
    if ($key.EndsWith('+')) {
      $key = $key.TrimEnd('+')
      $value = [System.Environment]::GetEnvironmentVariable($key) + $value
    }
    $environment.$key = $value
  }
  $cmd = (Get-Command $cmd -Type Application -TotalCount 1 -ea Stop).Source
  $saveEnvironment = @{}
  $environment.GetEnumerator().ForEach{
    $saveEnvironment[$_.Key] = [System.Environment]::GetEnvironmentVariable($_.Key)
    [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
  }
  Write-Debug "$($environment.GetEnumerator()) $cmd $ags"
  try {
    if ($MyInvocation.ExpectingInput) {
      $input | & $cmd $ags
    }
    else {
      & $cmd $ags
    }
  }
  finally {
    $saveEnvironment.GetEnumerator().ForEach{
      Set-Item -LiteralPath env:$($_.Key) $_.Value
    }
  }
  if ($LASTEXITCODE) {
    throw "exit status $LASTEXITCODE"
  }
}
#endregion

if ($IsLinux) {
  . $PSScriptRoot/Linux.ps1
}
