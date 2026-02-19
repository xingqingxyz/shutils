<#
.SYNOPSIS
Show clock alarm at breakfast, lunch or dinner.
 #>
[string]$scriptText = if ($IsWindows) {
  {
    $clock = ${%clock%}
    $dinner = ${%dinner%}
    Add-Type -AssemblyName System.Windows.Forms
    $notify = [System.Windows.Forms.NotifyIcon]::new()
    $notify.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning
    $notify.BalloonTipTitle = $clock
    $notify.BalloonTipText = "It's time for $dinner"
    $notify.Icon = [System.Drawing.SystemIcons]::Application
    $notify.Text = 'Show-Clock'
    $notify.Visible = $true
    $null = Register-ObjectEvent $notify -EventName BalloonTipClosed -MaxTriggerCount 1 -Action {
      $args[0].Visible = $false
      $args[0].Dispose()
    }
    [double]$audioVolume = (Get-AudioDevice -PlaybackVolume).TrimEnd('%')
    Set-AudioDevice -PlaybackVolume 60
    $notify.ShowBalloonTip(10000)
    Start-Sleep 2
    if ($notify.Visible) {
      [System.Media.SystemSounds]::Beep.Play()
      Start-Sleep 2
    }
    if ($notify.Visible) {
      [System.Media.SystemSounds]::Beep.Play()
      Start-Sleep 2
    }
    [System.Media.SystemSounds]::Beep.Play()
    Start-Sleep 2
    Set-AudioDevice -PlaybackVolume $audioVolume
  }
}
elseif ($IsLinux) {
  {
    $clock = ${%clock%}
    $dinner = ${%dinner%}
    notify-send --urgency=critical --app-name=clock $clock "It's time for $dinner"
  }
}
else {
  throw [System.NotImplementedException]::new()
}
@('7:20-breakfast', '11:50-lunch', '17:20-dinner', '22:50-bed').ForEach{
  $clock, $dinner = $_.Split('-')
  Register-PSScheduledTask "Show-Clock-$dinner" $scriptText.Replace('${%clock%}', "'$clock'").Replace('${%dinner%}', "'$dinner'") -Kind daily -At $clock
}
