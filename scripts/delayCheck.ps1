[CmdletBinding(DefaultParameterSetName = 'Base')]
param (
  [Parameter(Mandatory, Position = 0)]
  [timespan]
  $Delay,
  [Parameter(Position = 1, ParameterSetName = 'ScriptBlock')]
  [scriptblock]
  $ScriptBlock,
  [Parameter(Position = 1, ParameterSetName = 'Base')]
  [string]
  $Command,
  [Parameter(Position = 2, ValueFromRemainingArguments, ParameterSetName = 'Base')]
  [string[]]
  $ArgumentList
)

$PSNativeCommandUseErrorActionPreference = $true
Write-Debug "Sleeping $Delay"
Start-Sleep $Delay
if ($ScriptBlock) {
  $description = "{$ScriptBlock}"
  & $ScriptBlock
}
else {
  $description = "$Command $ArgumentList"
  & $Command $ArgumentList
}
$status = $?
$statusText = $status ? 'completed' : 'failed'
$message = "PowerShell job $statusText`: $description"

if ($IsWindows) {
  Add-Type -AssemblyName System.Windows.Forms
  $notify = [System.Windows.Forms.NotifyIcon]::new()
  $notify.BalloonTipIcon = $status ? [System.Windows.Forms.ToolTipIcon]::Info : [System.Windows.Forms.ToolTipIcon]::Warning
  $notify.BalloonTipTitle = $statusText
  $notify.BalloonTipText = $message
  $notify.Icon = [System.Drawing.SystemIcons]::Application
  $notify.Text = 'delayCheck'
  $notify.Visible = $true
  $notify.ShowBalloonTip(1000)
  $null = Register-ObjectEvent $notify -EventName BalloonTipClosed -MaxTriggerCount 1 -Action { $args[0].Dispose() }
  Start-Sleep 1 # prevent pwsh free BalloonTipIcon
}
elseif ($IsLinux) {
  notify-send $statusText $message
}
else {
  throw [System.NotImplementedException]::new()
}
