import ctypes
import locale
import os
import sys
import time

from uiautomation import WindowControl


def is_windows_chinese():
    return sys.platform == "win32" and locale.getlocale()[1] == "936"


def rerun_as_admin():
    if ctypes.windll.shell32.IsUserAnAdmin():
        return
    print("未以管理员权限运行")
    # 如果未以管理员运行，可以尝试重新启动脚本（仅限Windows）
    ctypes.windll.shell32.ShellExecuteW(
        None, "runas", sys.executable, " ".join(sys.argv), None, 1
    )
    sys.exit()


def block_input(block=True):
    """全局屏蔽/恢复键盘鼠标输入"""
    ctypes.windll.user32.BlockInput(block)


def set_light_theme(light=False):
    # 1. 打开 Windows 设置
    os.startfile("ms-settings:")
    time.sleep(1)

    # 2. 获取设置窗口
    window = WindowControl(Name="设置", ClassName="ApplicationFrameWindow")

    if not window.Exists():
        raise RuntimeError("cannot find ms settings window")

    block_input()
    print("activate window and set top most")
    window.SetActive()
    window.SetTopmost()
    search_box = window.EditControl(AutomationId="TextBox")
    print("send search text")
    search_box.SendKeys("浅色主题设置")
    print("click first suggestion")
    window.ListControl(AutomationId="SuggestionsList").GetFirstChildControl().Click()  # type: ignore
    combo = window.ComboBoxControl(
        AutomationId="SystemSettings_Personalize_Color_ColorMode_ComboBox"
    )
    print("click combo")
    combo.Click()
    print("click li")
    combo.ListItemControl(Name="浅色" if light else "深色").Click()
    print("close window")
    window.SendKeys("{ALT}{F4}")


def safe_oper(callback, *args, **kwargs):
    block_input(True)
    try:
        callback(*args, **kwargs)
    finally:
        block_input(False)


if __name__ == "__main__":
    if "###" in sys.argv:
        rerun_as_admin()
    assert is_windows_chinese(), "only support windows chinese"
    safe_oper(set_light_theme, len(sys.argv) > 1 and sys.argv[1] == "light")
