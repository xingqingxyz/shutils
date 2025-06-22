param(
  [string]
  $Tag = (gh api graphql -F owner=PowerShell -F repo=DSC -F query=@${env:SHUTILS_ROOT}/gql/stable.gql -f operationName=getTag -q .data.repository.tagName | ConvertFrom-Json),
  [string]
  $InstallDirectory = "$HOME/.local/share/dscV3"
)
$ErrorActionPreference = 'Stop'
$fileName = DSC-$($Tag.Substring(1))-$(uname -m)-linux.tar.gz
aria2c https://github.com/PowerShell/DSC/releases/download/$Tag/$fileName --dir /tmp
if ($LASTEXITCODE -ne 0) {
  return
}
Remove-Item -Recurse -Force $InstallDirectory/*
tar xf /tmp/$fileName -C $InstallDirectory
