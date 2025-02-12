import pyautogui
import time
import sys
import re

path = "typewriter/code.txt";
with open(path, "r", encoding="utf-8") as file:
    code = file.read()

cleaned_code = [re.sub(r"\s+", " ", line).strip() for line in code.splitlines()]

time.sleep(10)

for i, line in enumerate(cleaned_code):
    if line.strip() == "}":
        pyautogui.press("down")
        pyautogui.press("enter")
    else:
        pyautogui.write(line, interval=0.05)
        pyautogui.press("enter")

pyautogui.hotkey("shift", "alt", "f")
sys.exit(0)