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
        [string]$Duration.Microseconds + 'ns'
        break
      }
      { $Duration.TotalMicroseconds -lt 1000 } {
        32
        [string]($Duration.Microseconds + $Duration.Nanoseconds / 1000) + 'μs'
        break
      }
      { $Duration.TotalMilliseconds -lt 1000 } {
        36
        [string]($Duration.Milliseconds + $Duration.Microseconds / 1000) + 'ms'
        break
      }
      { $Duration.TotalSeconds -lt 60 } {
        34
        [string]($Duration.Seconds + $Duration.Milliseconds / 1000) + 's'
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
    return "PS [`e[32m$([System.Environment]::UserName)@$([System.Environment]::MachineName)`e[0m] `e]8;;file://$PWD`e\$PWD`e]8;;`e\$('>' * ($nestedPromptLevel + 1)) "
  }
  $dur = Format-Duration (Get-History -Count 1 -ea Ignore).Duration
  $status = if ($lastStatus) {
    "`e[32mPS`e[0m"
  }
  elseif ($Error -and $MyInvocation.HistoryId - 1 -eq ($Error[0].ErrorRecord ?? $Error[0]).InvocationInfo.HistoryId) {
    "`e[31mPS`e[0m"
  }
  else {
    "`e[$(32 - [int][bool]$LASTEXITCODE)m$LASTEXITCODE`e[0m"
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
