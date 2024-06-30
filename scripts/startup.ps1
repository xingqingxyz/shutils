Register-ScheduledJob -Name 'Startup' -FilePath $PSScriptRoot/_/Set-UserEnv.ps1 -Trigger (New-JobTrigger -AtStartup) -RunNow
