if (!(Test-Path ~/srv/hbbs/id_ed25519)) {
  $public_key, $private_key = rustdesk-utils.exe genkeypair | ForEach-Object { $_.Split(' ')[-1] }
  $public_key | Out-File -NoNewline ~/srv/hbbs/id_ed25519.pub
  $private_key | Out-File -NoNewline ~/srv/hbbs/id_ed25519
}
$null = hbbs.exe --key (Get-Content -Raw ~/srv/hbbs/id_ed25519) >~/srv/hbbs.out 2>~/srv/hbbs.err &
if ($LASTEXITCODE -ne 0) {
  Write-Error "hbbs.exe failed with exit code $LASTEXITCODE, please check ~/srv/hbbs.out and ~/srv/hbbs.err"
}
