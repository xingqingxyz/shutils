function Get-AudioDevice {
  [CmdletBinding()]
  param (
    [Parameter(ParameterSetName = 'Volume')]
    [switch]
    $Volume
  )
  switch ($true) {
    $Volume {
      if ($IsWindows) {
        [Sys.AudioDevice]::GetVolume()
        break
      }
      elseif ($IsLinux) {
        (wpctl get-volume '@DEFAULT_AUDIO_SINK@').Split(' ', 2)[1]
        break
      }
      throw [System.NotImplementedException]::new()
      break
    }
  }
}

function Set-AudioDevice {
  [CmdletBinding()]
  param (
    [Parameter(ParameterSetName = 'Volume')]
    [double]
    $Volume
  )
  switch ($PSCmdlet.ParameterSetName) {
    Volume {
      if ($IsWindows) {
        [Sys.AudioDevice]::SetVolume($Volume)
        break
      }
      elseif ($IsLinux) {
        wpctl set-volume '@DEFAULT_AUDIO_SINK@' $Volume
        break
      }
      throw [System.NotImplementedException]::new()
      break
    }
  }
}
