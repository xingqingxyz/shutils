$shared = @{}
$job = Start-ThreadJob {
  begin {
    $shared = $Using:shared
  }
  end {
    Send-Notify "Update-System started at $($shared['now'].ToString('HH:mm:ss'))."
    while ($true) {
      Start-Sleep 0:10
      Send-Notify "Update-System running $((++$i)*10) minutes."
    }
  }
  clean {
    Send-Notify "Update-System $($shared['status'] ? 'finished' : 'failed') in $(Format-Duration $shared['duration'] -NoColor)." -Level ($shared['status'] ? 'Information' : 'Error')
  }
}
$shared['now'] = Get-Date
Update-System -Force
$shared['status'] = $?
$shared['duration'] = (Get-Date) - $shared['now']
if (!$shared['status']) {
  Get-Error > Temp:/Update-System-error.log
}
Stop-Job $job
