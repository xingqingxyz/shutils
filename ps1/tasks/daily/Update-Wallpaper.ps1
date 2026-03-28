<#
.SYNOPSIS
Update wallpaper from bing.
 #>
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

# ===================== 配置项 =====================
$WALLPAPER_DIR = Convert-Path ~/Pictures/bing_wallpapers
$RESOLUTION = 'UHD'
$REGION = 'zh-CN'
# ===================== /配置项 =====================

Write-Information "===== $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') 开始更新 Bing 壁纸 ====="

# 初始化目录
if (!(Test-Path -LiteralPath $WALLPAPER_DIR)) {
  New-Item -ItemType Directory $WALLPAPER_DIR -Force
}

# 获取壁纸 URL
$apiUrl = "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=$REGION"
$resp = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing -TimeoutSec 10
if (!$resp.images.Count) {
  throw '未从 Bing API 获取到 images 数据'
}
$wallpaperUrl = "https://www.bing.com$($resp.images[0].urlbase)_$RESOLUTION.jpg"
$wallpaperPath = [System.IO.Path]::Join($WALLPAPER_DIR, "$($resp.images[0].hsh).jpg")

# 下载壁纸（重复则跳过）
if (Test-Path -LiteralPath $wallpaperPath) {
  Write-Information "今日壁纸已存在，无需重复下载: $wallpaperPath"
}
else {
  try {
    Write-Information "开始下载壁纸: $wallpaperUrl"
    Invoke-WebRequest -Uri $wallpaperUrl -OutFile $wallpaperPath -TimeoutSec 30
    Write-Information "壁纸下载完成: $wallpaperPath"
  }
  catch {
    Write-Error "下载壁纸失败: $_"
  }
}

# 设置壁纸
try {
  if ($IsWindows) {
    Add-Type -TypeDefinition @'
      using System.Runtime.InteropServices;
      public class Wallpaper {
        [DllImport("user32.dll", SetLastError=true)]
        public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
      }
'@
    if (![Wallpaper]::SystemParametersInfo(20, 0, $wallpaperPath, 3)) {
      throw 'api set wallpaper failed'
    }
  }
  elseif ($IsMacOS) {
    # AppleScript 设置桌面壁纸，支持多显示器
    osascript -e @"
      tell application "System Events"
        set picturePath to "$($wallpaperPath.Replace('"', '\"'))"
        repeat with d in desktops
          set picture of d to picturePath
        end repeat
      end tell
"@
  }
  elseif ($IsLinux) {
    if ($env:XDG_CURRENT_DESKTOP -clike '*GNOME') {
      Write-Information '检测到 GNOME 桌面，设置 gsettings...'
      gsettings set org.gnome.desktop.background picture-uri "file://$wallpaperPath"
      gsettings set org.gnome.desktop.background picture-uri-dark "file://$wallpaperPath"
      gsettings set org.gnome.desktop.screensaver picture-uri "file://$wallpaperPath"
    }
    elseif ($env:XDG_CURRENT_DESKTOP -clike '*KDE') {
      Write-Information '检测到 KDE Plasma 桌面，设置 Plasma 壁纸...'
      qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript @"
        var allDesktops = desktops();
        for (i = 0; i < allDesktops.length; i++) {
          d = allDesktops[i];
          d.wallpaperPlugin = "org.kde.image";
          d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");
          d.writeConfig("Image", "file://$($wallpaperPath.Replace('"', '\"'))");
          d.writeConfig("FillMode", 3);
        }
"@
    }
    elseif (Get-Process dms -ea Ignore) {
      Write-Information '检测到 dms 桌面, 设置 dms...'
      dms ipc wallpaper set $wallpaperPath
    }
    else {
      throw "unknown desktop '$env:XDG_CURRENT_DESKTOP'"
    }
  }
  else {
    throw [System.NotImplementedException]::new('不支持的操作系统')
  }
  Write-Information "成功设置壁纸: $wallpaperPath"
}
catch [System.Management.Automation.CommandNotFoundException] {
  Write-Error "未找到命令，请确保正确安装并加入 PATH: $_"
}
catch {
  Write-Error "设置壁纸失败: $_"
}
