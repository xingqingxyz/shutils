if ($IsWindows) {
  # clear tmp files
  Remove-Item Temp:/* -Recurse -Force -ea Ignore
}
