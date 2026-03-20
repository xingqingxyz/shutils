if ($IsLinux -and (Get-Process dms -ea Ignore)) {
  uv run ./py/bing_wallpaper_linux.py
}
