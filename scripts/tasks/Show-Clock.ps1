<#
.SYNOPSIS
Show clock alarm at breakfast, lunch or dinner.
#>
[CmdletBinding()]
param (
  [Parameter()]
  [switch]
  $Uninstall
)

if ($Uninstall) {
  return Unregister-PSScheduledTask (('breakfast', 'lunch', 'dinner', 'bed').ForEach{ "Show-Clock-$_" } + 'Stop-Computer')
}

[string]$text = {
  Send-Notify -Title %clock% 'It''s time for %dinner%'
  $audioVolume = Get-AudioDevice -Volume
  Set-AudioDevice -Volume 0.6
  if ($IsWindows) {
    1..3 | ForEach-Object { [System.Media.SystemSounds]::Beep.Play(); Start-Sleep 2 }
  }
  elseif ($IsLinux) {
    1..3 | ForEach-Object { pw-play /usr/share/sounds/freedesktop/stereo/complete.oga; Start-Sleep -Milliseconds 300 }
  }
  Set-AudioDevice -Volume $audioVolume
}
('7:20-breakfast', '11:50-lunch', '17:20-dinner', '23:10-bed').ForEach{
  $clock, $dinner = $_.Split('-')
  Register-PSScheduledTask "Show-Clock-$dinner" $text.Replace('%clock%', $clock).Replace('%dinner%', $dinner) -DaysInterval 1 -At $clock -UsePowerShell -Graphical -Force
}

Register-PSScheduledTask 'Stop-Computer' {
  if ($IsWindows) {
    return shutdown.exe -s -t 120
  }
  Send-Notify -Title 'Stop-Computer' -Severity Error 'Computer will shutdown in 2 minutes.'
  Start-Sleep 60
  Stop-Computer
} -DaysInterval 1 -At 23:28 -UsePowerShell -Force
