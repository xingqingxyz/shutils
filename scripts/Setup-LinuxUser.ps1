# ensure English home dirs
if ($PSCulture -cne 'en-US' -and (Get-Content -Raw -LiteralPath ~/.config/user-dirs.locale) -cnotmatch '^(C|en_US)$') {
  [string[]]$prevDirs = Get-Content -LiteralPath ~/.config/user-dirs.dirs | ForEach-Object { if ($_.StartsWith('XDG_')) { $_.Split('/', 2)[1].TrimEnd('"') } }
  env LC_ALL=C xdg-user-dirs-update --force
  [string[]]$newDirs = Get-Content -LiteralPath ~/.config/user-dirs.dirs | ForEach-Object { if ($_.StartsWith('XDG_')) { $_.Split('/', 2)[1].TrimEnd('"') } }
  Set-Location
  $null = for ($i = 0; $i -lt $prevDirs.Count; $i++) {
    if (Test-Path -LiteralPath $prevDirs[$i] -PathType Container) {
      Rename-Item -LiteralPath $prevDirs[$i] $newDirs[$i]
      continue
    }
    if (Test-Path -LiteralPath $prevDirs[$i]) {
      Move-Item -LiteralPath $prevDirs[$i] "$($prevDirs[$i]).bak"
    }
    New-Item -ItemType Directory $newDirs[$i]
  }
  Set-Location -
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
