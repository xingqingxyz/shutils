function Format-Duration {
  param(
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [timespan]
    $Duration
  )
  # colors: white, green, cyan, blue, yellow, magenta, red
  "`e[{0}m{1}`e[0m" -f $(switch ($true) {
      { $Duration.TotalNanoseconds -lt 1000 } {
        37
        "$($Duration.Microseconds)ns"
        break
      }
      { $Duration.TotalMicroseconds -lt 1000 } {
        32
        '{0}.{1:000}μs' -f $Duration.Microseconds, $Duration.Nanoseconds
        break
      }
      { $Duration.TotalMilliseconds -lt 1000 } {
        36
        '{0}.{1:000}ms' -f $Duration.Milliseconds, $Duration.Microseconds
        break
      }
      { $Duration.TotalSeconds -lt 60 } {
        34
        '{0}.{1:000}s' -f $Duration.Seconds, $Duration.Milliseconds
        break
      }
      { $Duration.TotalMinutes -lt 60 } {
        33
        '{0}m{1}s' -f $Duration.Minutes, $Duration.Seconds
        break
      }
      { $Duration.TotalHours -lt 24 } {
        35
        '{0}h{1}m' -f $Duration.Hours, $Duration.Minutes
        break
      }
      { $Duration.TotalDays -lt 31 } {
        31
        '{0}d{1}h' -f $Duration.Days, $Duration.Hours
        break
      }
    })
}

function prompt {
  $lastStatus = $?
  if ($MyInvocation.HistoryId -eq 1) {
    return "PS [`e[32m$([System.Environment]::UserName)@$([System.Environment]::UserDomainName)`e[0m] $PWD$('>' * ($nestedPromptLevel + 1)) "
  }
  $dur = Format-Duration (Get-History -Count 1 -ea Ignore).Duration
  $status = if ($lastStatus) {
    "`e[32mPS`e[0m"
  }
  elseif ($Error -and $MyInvocation.HistoryId - 1 -eq ($Error[0].ErrorRecord ?? $Error[0]).InvocationInfo.HistoryId) {
    "`e[31mPS`e[0m"
  }
  else {
    "`e[31m$LASTEXITCODE`e[0m"
  }
  $cwd = if ($PWD.Provider.Name -eq 'FileSystem') {
    if ($env:WSL_DISTRO_NAME) {
      "`e]8;;file://$(wslpath -w $PWD.ProviderPath)`e\$PWD`e]8;;`e\"
    }
    else {
      "`e]8;;file://$($PWD.ProviderPath)`e\$PWD`e]8;;`e\"
    }
  }
  else {
    $PWD.Path
  }
  '{0} ({1}:{2}) {3}{4} ' -f $status, $MyInvocation.HistoryId, $dur, $cwd, ('>' * ($nestedPromptLevel + 1))
}
