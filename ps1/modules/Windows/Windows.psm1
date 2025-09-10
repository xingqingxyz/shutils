#region cross
function env {
  $environment = @{}
  $reEnv = [regex]::new('^\w+\+?=')
  $cmd, $ags = foreach ($arg in [string[]]$args) {
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
  $cmd = (Get-Command -CommandType Application -TotalCount 1 -ea Stop $cmd).Source
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
      [System.Environment]::SetEnvironmentVariable($_.Key, $_.Value)
    }
  }
}
#endregion

if (!$IsWindows) {
  return
}

function bat {
  if ($MyInvocation.PipelinePosition -eq $MyInvocation.PipelineLength) {
    $(try {
        if ($MyInvocation.ExpectingInput) {
          $input | bat.exe --color=always $args
        }
        else {
          bat.exe --color=always $args
        }
      }
      catch {}) | & 'C:\Program Files\Git\usr\bin\less.exe'
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
