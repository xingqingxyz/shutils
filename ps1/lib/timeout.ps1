[int]$timeout = $args[0]
while ($timeout) {
  Write-Host "`rWaiting for `e[32m$timeout`e[0m seconds, press a key to continue ..." -NoNewline
  Start-Sleep 1
  $timeout--
}
Write-Host "`rWaiting for `e[32m0`e[0m seconds, press a key to continue ..."
