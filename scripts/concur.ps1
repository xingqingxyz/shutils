Set-Location ~/Downloads
(Get-Clipboard) -split "`n" | ForEach-Object -Parallel {
  try {
    if (![string]::IsNullOrEmpty($_)) {
      Invoke-Expression "$_ -x5"
    }
  }
  finally {}
} -ThrottleLimit 6 -AsJob
