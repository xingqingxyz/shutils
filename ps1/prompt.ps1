function Format-Duration {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [timespan]
    $Duration
  )
  process {
    # colors: green, cyan, blue, yellow, magenta, red
    "`e[{0}m{1}`e[0m" -f @(switch ($true) {
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
}

function prompt {
  '{0} ({1}:{2}) {3}{4} ' -f @(
    # status
    switch ([int]!$? -shl 1 -bor [int][bool]$LASTEXITCODE) {
      0 { "`e[32mPS`e[0m"; break }
      1 { "`e[33m$LASTEXITCODE`e[0m"; break }
      2 { "`e[31mPS`e[0m"; break }
      3 { "`e[31m$LASTEXITCODE`e[0m"; break }
      # no default
    }
    # historyId
    $MyInvocation.HistoryId
    # duration
    Format-Duration ($MyInvocation.HistoryId -eq 1 ? 0 : (Get-History -Count 1).Duration)
    # pwd
    if ($PWD.Provider.Name -ceq 'FileSystem') {
      $PSStyle.FormatHyperlink($PWD.ProviderPath.Replace($HOME, '~'), [uri]::new($env:WSL_DISTRO_NAME ? (wslpath -w $PWD.ProviderPath) : $PWD.ProviderPath))
    }
    else {
      $PWD
    }
    # endMark
    ($PWD.Path.Length / [System.Console]::WindowWidth -gt .42 ? "`n" : '') + ('>' * ($NestedPromptLevel + 1))
  )
}
