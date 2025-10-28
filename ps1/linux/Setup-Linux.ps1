# keep English home dirs
if ($PSCulture -cne 'en-US') {
  Get-Content -LiteralPath ~/.config/user-dirs.dirs | Select-String -Raw -SimpleMatch XDG_ | ForEach-Object {
    $_.Split('/')[-1].TrimEnd('"')
  } | Remove-Item
  env LC_ALL=C xdg-user-dirs-update --force
}

#region gpg
# gnu
Invoke-RestMethod 'https://mirrors.ustc.edu.cn/gnu/gnu-keyring.gpg' -OutFile /tmp/gnu-keyring.gpg
gpg --import /tmp/gnu-keyring.gpg
#endregion
