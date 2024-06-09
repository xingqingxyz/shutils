if (!(Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux)) {
  $state = Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
  if ($state.RestartNeeded) {
    Restart-Computer -Wait -Timeout 1800
  }
}

wsl.exe --install Ubuntu
