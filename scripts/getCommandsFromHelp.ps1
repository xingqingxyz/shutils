$sep = [int]$args[0]
$contents = @(if ($args.Length -gt 1) {
    & $args[1] --help
  }
  elseif ($MyInvocation.ExpectingInput) {
    $input
  }
  else {
    throw 'no contents'
  }) | Tee-Object help.log

$contents | ForEach-Object {
  try {
    $text = $_.Substring(0, $sep)
  }
  catch {
    return
  }
  if (![string]::IsNullOrWhiteSpace($text) -and $text[0] -eq ' ') {
    $text.Trim().Split(', ')
  }
} | Join-String -Separator "', '" -OutputPrefix "'" -OutputSuffix "'" | Set-Clipboard
