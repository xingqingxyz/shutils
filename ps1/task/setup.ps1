param (
  [Parameter()]
  [ValidateSet('monthly', 'weekly', 'daily')]
  [string[]]
  $Kind
)

if ($IsLinux) {
  $Kind.ForEach{
    $service = @"
[Unit]
Description=PowerShell $_ task

[Service]
Type=oneshot
ExecStart=/usr/bin/pwsh -noni -nop -c Get-ChildItem -LiteralPath $PSScriptRoot/$_ -Force -File | ForEach-Object { & `$_.FullName }
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

}
else {
  throw 'not implemented'
}
