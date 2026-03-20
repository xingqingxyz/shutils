#!/usr/bin/env python3
import os
import subprocess
from datetime import datetime

import requests

# ===================== 配置项（可根据需要修改） =====================
# 壁纸保存目录（建议改为自己的目录，比如 ~/Pictures/bing_wallpapers）
WALLPAPER_DIR = os.path.expanduser("~/Pictures/bing_wallpapers")
# 壁纸分辨率（1920x1080 即可，Bing 会返回对应高清图）
RESOLUTION = "UHD"
# 语言/地区（zh-CN 为中国区，en-US 为国际区）
REGION = "zh-CN"
# ==================================================================


def init_dir():
    """初始化壁纸保存目录"""
    if not os.path.exists(WALLPAPER_DIR):
        os.makedirs(WALLPAPER_DIR)
        print(f"创建壁纸目录: {WALLPAPER_DIR}")


def get_bing_wallpaper_url():
    """调用 Bing API 获取当日壁纸下载链接"""
    # Bing 壁纸 API 地址（官方未公开但稳定可用）
    api_url = (
        f"https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt={REGION}"
    )

    try:
        response = requests.get(api_url, timeout=10)
        response.raise_for_status()  # 抛出 HTTP 错误
        data = response.json()

        # 提取壁纸基础链接
        image_base_url = data["images"][0]["urlbase"]
        # 拼接完整下载链接（带分辨率）
        full_url = f"https://www.bing.com{image_base_url}_{RESOLUTION}.jpg"

        # 提取壁纸文件名（按日期命名）
        image_name = data["images"][0]["hsh"] + ".jpg"
        return full_url, image_name

    except Exception as e:
        print(f"获取壁纸链接失败: {e}")
        return None, None


def download_wallpaper(url, filename):
    """下载壁纸（避免重复下载）"""
    wallpaper_path = os.path.join(WALLPAPER_DIR, filename)

    # 如果文件已存在，直接返回路径
    if os.path.exists(wallpaper_path):
        print(f"今日壁纸已存在，无需重复下载: {wallpaper_path}")
        return wallpaper_path

    try:
        print(f"开始下载壁纸: {url}")
        response = requests.get(url, timeout=30, stream=True)
        response.raise_for_status()

        # 写入文件
        with open(wallpaper_path, "wb") as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)

        print(f"壁纸下载完成: {wallpaper_path}")
        return wallpaper_path

    except Exception as e:
        print(f"下载壁纸失败: {e}")
        return None


def set_niri_wallpaper(wallpaper_path):
    """设置壁纸"""
    if not wallpaper_path or not os.path.exists(wallpaper_path):
        print("壁纸文件不存在，无法设置")
        return

    cmd = ["sh"]

    try:
        XDG_CURRENT_DESKTOP = os.environ["XDG_CURRENT_DESKTOP"]
        if XDG_CURRENT_DESKTOP.endswith("GNOME"):
            cmd = [
                "gsettings",
                "set",
                "org.gnome.desktop.background",
                "picture-uri",
                f"file://{wallpaper_path}",
            ]
            subprocess.run(cmd, check=True, capture_output=True, text=True)
            cmd[2] = "org.gnome.desktop.screensaver"
            subprocess.run(cmd, check=True, capture_output=True, text=True)
        elif XDG_CURRENT_DESKTOP == "niri" or XDG_CURRENT_DESKTOP == "hyprland":
            cmd = ["dms", "ipc", "wallpaper", "set", wallpaper_path]
            subprocess.run(cmd, check=True, capture_output=True, text=True)
        else:
            raise SystemError("unknown desktop")
        print(f"成功设置壁纸: {wallpaper_path}")
    except KeyError:
        print("env XDG_CURRENT_DESKTOP not set")
    except subprocess.CalledProcessError as e:
        print(f"设置壁纸失败: {e.stderr}")
    except FileNotFoundError:
        print(f"未找到 {cmd[0]} 命令，请确保正确安装并加入 PATH")


def main():
    """主流程"""
    print(
        f"===== {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} 开始更新 Bing 壁纸 ====="
    )
    init_dir()

    # 1. 获取壁纸链接
    wallpaper_url, wallpaper_name = get_bing_wallpaper_url()
    if not wallpaper_url:
        return

    # 2. 下载壁纸
    wallpaper_path = download_wallpaper(wallpaper_url, wallpaper_name)
    if not wallpaper_path:
        return

    # 3. 设置壁纸
    set_niri_wallpaper(wallpaper_path)
    print("===== 壁纸更新完成 =====")


if __name__ == "__main__":
    main()
