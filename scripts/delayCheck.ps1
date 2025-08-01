[CmdletBinding()]
param (
  [Parameter(Mandatory, Position = 0)]
  [string]
  $Delay,
  [Parameter(Mandatory, Position = 1)]
  [scriptblock]
  $ScriptBlock
)

Start-Sleep -Duration ([timespan]::Parse($Delay))
$PSNativeCommandUseErrorActionPreference = $true
Invoke-Command $ScriptBlock -ErrorVariable err
Add-Type -AssemblyName System.Windows.Forms
$notify = [System.Windows.Forms.NotifyIcon]::new()
$notify.BalloonTipIcon = !$err ? [System.Windows.Forms.ToolTipIcon]::Info : [System.Windows.Forms.ToolTipIcon]::Warning
$notify.BalloonTipText = "code: $ScriptBlock"
$notify.BalloonTipTitle = !$err ? 'completed' : 'failed'
$notify.Icon = [System.Drawing.SystemIcons]::Application
$notify.Text = 'delayCheck'
$notify.Visible = $true
$notify.ShowBalloonTip(1000)
$null = Register-ObjectEvent $notify -EventName BalloonTipClosed -MaxTriggerCount 1 -Action { $args[0].Dispose() }
Start-Sleep 1 # prevent pwsh free BalloonTipIcon
