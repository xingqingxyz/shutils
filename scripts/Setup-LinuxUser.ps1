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
# data dirs
[string[]]$dirs = @(
  1..8 | ForEach-Object { "$HOME/.local/share/man/man$_" }
  "$HOME/.local/share/bash-completion/completions"
  "$HOME/.local/share/applications"
  "$HOME/.local/share/fonts/truetype"
)
New-Item -ItemType Directory $dirs -Force
