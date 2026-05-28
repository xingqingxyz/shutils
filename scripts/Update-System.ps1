$shared = [pscustomobject]@{
  now      = Get-Date
  status   = $false
  duration = $null
}

$job = Start-ThreadJob {
  param ([psobject]$Shared)
  end {
    Send-Notify "Update-System started at $($Shared.now.ToString('HH:mm:ss'))."
    while ($true) {
      Start-Sleep 0:10
      Send-Notify "Update-System running $((++$i)*10) minutes."
    }
  }
  clean {
    Send-Notify "Update-System $($Shared.status ? 'finished' : 'failed') in $(Format-Duration $Shared.duration -NoColor)." -Severity ($Shared.status ? 'Information' : 'Error')
  }
} -ArgumentList $shared

Update-System -Force
$shared.status = $?
$shared.duration = (Get-Date) - $shared.now
if (!$shared.status) {
  Get-Error > Temp:/Update-System-error.log
}
Stop-Job $job
