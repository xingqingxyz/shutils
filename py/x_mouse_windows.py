import time

import uiautomation as auto
from pynput import mouse
from pynput.mouse import Button

# 配置开关
ENABLE_SELECT_COPY = True  # 选中自动复制
ENABLE_MIDDLE_PASTE = True  # 中键粘贴

last_left_pos = (-1, -1)
last_left_time = 0.0
last_selected_text = ""
left_click_times = 0


def get_selected_text(x, y):
    control = auto.ControlFromPoint(x, y)
    if control is None or not hasattr(control, "GetTextPattern"):
        return
    pattern = control.GetTextPattern()  # type: ignore
    if pattern is None or not pattern.SupportedTextSelection:
        return
    return pattern.GetSelection()[0].GetText()


# ------------------------------
# 选中自动复制（模拟松开左键复制）
# ------------------------------
def on_left(x, y, button, pressed, injected):
    global last_left_pos, last_left_time, last_selected_text, left_click_times

    if ENABLE_SELECT_COPY and button == Button.left:
        if pressed:
            left_click_times = (
                x,
                y,
            ) == last_left_pos and time.time() - last_left_time < 0.3
            last_left_pos = (x, y)
            last_left_time = time.time()
            return
        # cursor move
        if not left_click_times and time.time() - last_left_time < 0.2:
            return
        top = auto.GetForegroundControl()
        if (
            top is not None
            and top.ClassName == "Chrome_WidgetWin_1"
            and top.Name.endswith("Visual Studio Code")
        ):
            return
        text = get_selected_text(x, y)
        if not text:
            print("get_selected_text empty")
            if left_click_times or (x, y) != last_left_pos:
                auto.SendKeys("{Ctrl}{Insert}")
                text = auto.GetClipboardText()
        if text:
            print(text)
            last_selected_text = text


# ------------------------------
# 中键粘贴
# ------------------------------
def on_middle_down(x, y, button, pressed, injected):
    if ENABLE_MIDDLE_PASTE and button == Button.middle and pressed:
        if len(last_selected_text) < 300:
            for ch in last_selected_text:
                auto.SendUnicodeChar(ch)
            return
        auto.SetClipboardText(last_selected_text)
        auto.SendKeys("{Shift}{Insert}")


def wrap(*fn):
    def wrapped(*args, **kwargs):
        with auto.UIAutomationInitializerInThread():
            for f in fn:
                f(*args, **kwargs)

    return wrapped


if __name__ == "__main__":
    print("Linux 选中复制+中键粘贴已启动")
    with mouse.Listener(on_click=wrap(on_left, on_middle_down)) as listener:
        listener.join()
