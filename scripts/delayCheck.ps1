[CmdletBinding(DefaultParameterSetName = 'Base')]
param (
  [Parameter(Mandatory, Position = 0)]
  [timespan]
  $Delay,
  [Parameter()]
  [switch]
  $AsJob,
  [Parameter(Mandatory, Position = 1, ParameterSetName = 'Base')]
  [string]
  $Command,
  [Parameter(Mandatory, Position = 1, ParameterSetName = 'ScriptBlock')]
  [scriptblock]
  $ScriptBlock,
  [Parameter(Position = 2, ValueFromRemainingArguments)]
  [System.Object[]]
  $ArgumentList
)

$PSNativeCommandUseErrorActionPreference = $true
if ($AsJob) {
  $PSBoundParameters.Remove('AsJob')
  # surprisingly, variables in there is catching from any upstream function local variables
  return & { $__ags__ = $PSBoundParameters; & $PSCommandPath @__ags__ } &
}
Write-Debug "Sleeping $Delay"
Start-Sleep $Delay
$description = if ($Command) {
  $ScriptBlock = { &$Command @args }
  "$Command $ArgumentList"
}
else {
  "{$ScriptBlock}"
}
& $ScriptBlock @ArgumentList
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
