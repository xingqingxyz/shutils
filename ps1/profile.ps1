if ($IsWindows) {
  . $PSScriptRoot/windows/profile.ps1
}
else {
  . $PSScriptRoot/linux/profile.ps1
}
