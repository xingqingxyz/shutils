function Format-Duration {
  param([timespan]$Duration)
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
  $lastHist = Get-History -Count 1 -ErrorAction Ignore
  $cwd = if ($PWD.Provider.Name -eq 'FileSystem') {
    if ($IsLinux -and (Test-Path Env:/WSLENV)) {
      "`e]8;;file://$(wslpath -w $PWD.Path)`e\$PWD`e]8;;`e\"
    }
    else {
      "`e]8;;file://$PWD`e\$PWD`e]8;;`e\"
    }
  }
  else {
    $PWD.Path
  }
  if (!$lastHist) {
    "PS [`e[32m${env:USER}${env:USERNAME}@${env:HOSTNAME}${env:COMPUTERNAME}`e[0m] $cwd$('>' * ($nestedPromptLevel + 1)) "
  }
  elseif ($lastStatus) {
    "`e[32mPS`e[0m ($(Format-Duration $lastHist.Duration)) $cwd$('>' * ($nestedPromptLevel + 1)) "
  }
  elseif ($Error -and $lastHist.Id -eq ($Error[0].ErrorRecord ?? $Error[0]).InvocationInfo.HistoryId) {
    "`e[31mPS`e[0m ($(Format-Duration $lastHist.Duration)) $cwd$('>' * ($nestedPromptLevel + 1)) "
  }
  else {
    "`e[31m$LASTEXITCODE`e[0m ($(Format-Duration $lastHist.Duration)) $cwd$('>' * ($nestedPromptLevel + 1)) "
  }
}
