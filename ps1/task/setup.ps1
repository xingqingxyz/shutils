param (
  [Parameter()]
  [ValidateSet('monthly', 'weekly', 'daily')]
  [string[]]
  $Kind
)

function encodedCommand ([string]$Kind) {
  [System.Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes(
      "Get-ChildItem -LiteralPath $PSScriptRoot/$Kind -Force -File | ForEach-Object { & `$_.FullName }"
    ))
}

if ($IsLinux) {
  $Kind.ForEach{
    $service = @"
[Unit]
Description=PowerShell $_ task

[Service]
Type=oneshot
ExecStart=/usr/bin/pwsh -noni -nop -e $(encodedCommand $_)")
"@
    $timer = @"
[Unit]
Description=PowerShell $_ task timer

[Timer]
OnCalendar=$_
Persistent=true
AccuracySec=1d

[Install]
WantedBy=timers.target
"@
    $service > ~/.config/systemd/user/$_-task.service
    $timer > ~/.config/systemd/user/$_-task.timer
  }

  systemctl daemon-reload --user
  $Kind.ForEach{
    systemctl enable --user --now $_-task.timer
  }
}
elseif ($IsWindows) {
  $Kind.ForEach{
    $trigger = switch ($_) {
      'daily' { New-ScheduledTaskTrigger -At 0am -Daily; break }
      'weekly' { New-ScheduledTaskTrigger -At 0am -Weekly -DaysOfWeek Friday; break }
      'monthly' { New-ScheduledTaskTrigger -At 0am -Daily -DaysInterval 30; break }
    }
    $action = New-ScheduledTaskAction -Execute pwsh -Argument "-noni -nop -e $(encodedCommand $_)"
    Register-ScheduledTask "pwsh-$_" -Force -Description "PowerShell $_ task" -Trigger $trigger -Action $action
  }
}
else {
  throw 'not implemented'
}
