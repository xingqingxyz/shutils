function Format-Duration {
  param([timespan]$Duration)
  # colors: green, cyan, blue, yellow, magenta, red
  "`e[{1}m{0}`e[0m" -f $(switch ($true) {
      { $Duration.TotalMicroseconds -lt 1000 } { "$($Duration.Microseconds)μs", 32 }
      { $Duration.TotalMilliseconds -lt 1000 } { "$($Duration.Milliseconds).$($Duration.Microseconds)ms", 36 }
      { $Duration.TotalSeconds -lt 60 } { "$($Duration.Seconds).$($Duration.Milliseconds)s", 34 }
      { $Duration.TotalMinutes -lt 60 } { "$($Duration.Minutes)m$($Duration.Seconds)s" , 33 }
      { $Duration.TotalHours -lt 24 } { "$($Duration.Hours)h$($Duration.Minutes)m", 35 }
      { $Duration.TotalDays -lt 31 } { "$($Duration.Days)d$($Duration.Hours)h", 31 }
    })
}

function prompt {
  $lastStatus = $?
  $lastHist = Get-History -Count 1 -ErrorAction Ignore
  if (!$lastHist) {
    "PS [`e[32m${env:USERNAME}@${env:HOSTNAME}${env:COMPUTERNAME}`e[0m] $PWD$('>' * ($nestedPromptLevel + 1)) "
  }
  elseif ($lastStatus) {
    "`e[32mPS`e[0m ($(Format-Duration $lastHist.Duration)) $PWD$('>' * ($nestedPromptLevel + 1)) "
  }
  elseif ($Error -and $lastHist.Id -eq ($Error[0].ErrorRecord ?? $Error[0]).InvocationInfo.HistoryId) {
    "`e[31mPS`e[0m ($(Format-Duration $lastHist.Duration)) $PWD$('>' * ($nestedPromptLevel + 1)) "
  }
  else {
    "`e[31m$LASTEXITCODE`e[0m ($(Format-Duration $lastHist.Duration)) $PWD$('>' * ($nestedPromptLevel + 1)) "
  }
}
