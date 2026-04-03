#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'
$isWin10 = try {
  $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
  $osInfo.Caption -clike '* Windows 10 *'
}
catch {
  $false
}

if ($isWin10) {
  Write-Host '检测到 Windows 10 + PowerShell 5.1，开始检查 winget 和 PowerShell 7 安装'

  # winget 检查和安装
  if (-not (Get-Command winget -CommandType Application -ea Ignore)) {
    Write-Host '未检测到 winget，尝试安装 winget...'
    Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
    $env:Path += ";$env:LOCALAPPDATA\Microsoft\WinGet\Links"
    if (-not (Get-Command winget -CommandType Application -ea Ignore)) {
      Write-Error 'winget 安装失败'
    }
    else {
      Write-Host 'winget 安装完成'
    }
  }
  else {
    Write-Host '已检测到 winget'
  }

  # 安装 PowerShell 7
  while ($true) {
    winget install --source winget --accept-source-agreements --accept-package-agreements --id Microsoft.PowerShell Git.Git aria2.aria2
    if ($LASTEXITCODE) {
      Start-Sleep 0:12
    }
    else {
      break
    }
  }
}

# setup repo
git -C (New-Item -ItemType Directory ~/p) clone https://github.com/xingqingxyz/wish
Set-Location -LiteralPath ~/p/wish
# runs
pwsh -nop $PSScriptRoot\Initialize-Computer.ps1
