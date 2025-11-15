if ($IsWindows) {
  Update-FormatData -PrependPath $PSScriptRoot/LSColors.windows.format.ps1xml
}
else {
  Update-FormatData -PrependPath $PSScriptRoot/LSColors.format.ps1xml
}
$PSStyle.FileInfo.Directory = $PSStyle.Underline + $PSStyle.Foreground.BrightBlue
$PSStyle.FileInfo.Executable = $PSStyle.Italic + $PSStyle.Foreground.BrightYellow
Import-Csv -LiteralPath $PSScriptRoot/LSColors.ini -Delimiter = -Header name, value | ForEach-Object {
  $PSStyle.FileInfo.Extension[$_.name] = $PSStyle.Foreground.FromConsoleColor([System.ConsoleColor]$_.value)
}
