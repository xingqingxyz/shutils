<#
.SYNOPSIS
Show clock alarm at breakfast, lunch or dinner.
 #>
[string]$scriptText = if ($IsWindows) {
  {
    Send-Notify -Title %clock% 'It''s time for %dinner%'
    [double]$audioVolume = (Get-AudioDevice -PlaybackVolume).TrimEnd('%')
    Set-AudioDevice -PlaybackVolume 60
    1..3 | ForEach-Object { Start-Sleep 2; [System.Media.SystemSounds]::Beep.Play() }
    Set-AudioDevice -PlaybackVolume $audioVolume
  }
}
elseif ($IsLinux) {
  {
    Send-Notify -Title %clock% 'It''s time for %dinner%'
    $audioVolume = (wpctl get-volume '@DEFAULT_AUDIO_SINK@').Split(' ', 2)[1]
    wpctl set-volume '@DEFAULT_AUDIO_SINK@' 0.60
    1..3 | ForEach-Object { Start-Sleep -Milliseconds 300; pw-play /usr/share/sounds/freedesktop/stereo/complete.oga }
    wpctl set-volume '@DEFAULT_AUDIO_SINK@' $audioVolume
  }
}
else {
  throw [System.NotImplementedException]::new()
}
@('7:20-breakfast', '11:50-lunch', '17:20-dinner', '22:50-bed').ForEach{
  $clock, $dinner = $_.Split('-')
  Register-PSScheduledTask "Show-Clock-$dinner" $scriptText.Replace('%clock%', $clock).Replace('%dinner%', $dinner) -Kind daily -At $clock
}
