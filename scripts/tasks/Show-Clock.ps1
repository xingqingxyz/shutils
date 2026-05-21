<#
.SYNOPSIS
Show clock alarm at breakfast, lunch or dinner.
 #>
[string]$scriptText = if ($IsWindows) {
  {
    Send-Notify -Title %clock% 'It''s time for %dinner%'
    Import-Module PSCoreAudio -ea Stop
    [double]$audioVolume = [PSCoreAudio.Device]::GetVolume()
    [PSCoreAudio.Device]::SetVolume(.6)
    1..3 | ForEach-Object { [System.Media.SystemSounds]::Beep.Play(); Start-Sleep 2 }
    [PSCoreAudio.Device]::SetVolume($audioVolume)
  }
}
elseif ($IsLinux) {
  {
    Send-Notify -Title %clock% 'It''s time for %dinner%'
    $audioVolume = (wpctl get-volume '@DEFAULT_AUDIO_SINK@').Split(' ', 2)[1]
    wpctl set-volume '@DEFAULT_AUDIO_SINK@' 0.60
    1..3 | ForEach-Object { pw-play /usr/share/sounds/freedesktop/stereo/complete.oga; Start-Sleep -Milliseconds 300 }
    wpctl set-volume '@DEFAULT_AUDIO_SINK@' $audioVolume
  }
}
else {
  throw [System.NotImplementedException]::new()
}
@('7:20-breakfast', '11:50-lunch', '17:20-dinner', '22:50-bed').ForEach{
  $clock, $dinner = $_.Split('-')
  Register-PSScheduledTask "Show-Clock-$dinner" $scriptText.Replace('%clock%', $clock).Replace('%dinner%', $dinner) -DaysInterval 1 -At $clock -UsePowerShell -Graphical -Force
}
Register-PSScheduledTask 'Stop-Computer' {
  if ($IsWindows) {
    return shutdown.exe -s -t 180
  }
  Send-Notify -Title 'Stop-Computer' -Severity Error 'Computer will shutdown in 3 minutes.'
  Start-Sleep 0:3
  Stop-Computer
} -DaysInterval 1 -At 23:27 -UsePowerShell -Force
