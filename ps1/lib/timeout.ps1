$timeout = $args[0]
while ($timeout--) {
  Write-Host "Waiting for `e[32m$timeout`e[0m seconds, press a key to continue ...`r" -NoNewline
  Start-Sleep 1
}
Write-Host "Waiting for `e[32m0`e[0m seconds, press a key to continue ..."
