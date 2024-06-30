if (!([System.Security.Principal.WindowsPrincipal]::new([System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))) {
  Start-Process -Verb runas pwsh -ArgumentList $PSCommandPath -Wait
  return
}

$session = New-PSSession
Invoke-Command -Session $session -ScriptBlock ([scriptblock]::Create(@"
  `$trigger = New-JobTrigger -AtStartup
  Register-ScheduledJob -Name 'RustDesk Server' -FilePath $PSScriptRoot/Start-RustDeskServer.ps1 -Trigger `$trigger -RunNow
"@))
Remove-PSSession $session
