
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

function Get-AudioDevice {
  [CmdletBinding()]
  [OutputType([double])]
  param (
    [Parameter(ParameterSetName = 'Volume')]
    [switch]
    $Volume
  )
  switch ($true) {
    $Volume {
      if ($IsWindows) {
        [Utility.AudioDevice]::GetVolume()
        break
      }
      elseif ($IsLinux) {
        (wpctl get-volume '@DEFAULT_AUDIO_SINK@').Split(' ', 3)[1] -as [double]
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
        [Utility.AudioDevice]::SetVolume($Volume)
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
