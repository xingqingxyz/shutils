param(
  [Parameter()]
  [ValidateSet('monthly', 'weekly', 'daily')]
  [string[]]
  $Kind
)

$Kind.ForEach{
  # weekly-task.service
  $service = @"
[Unit]
Description=PowerShell $_ task

[Service]
Type=oneshot
ExecStart=/usr/bin/pwsh -noni -nop -c Get-ChildItem -LiteralPath $PSScriptRoot/$_ -Force -File | ForEach-Object { & `$_.FullName }
"@
  # weekly-task.timer
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

systemctl --user daemon-reload
$Kind.ForEach{
  systemctl --user enable --now $_-task.timer
}
