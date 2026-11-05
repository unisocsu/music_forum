#!/bin/sh
set -eu

python3 -m http.server 8765 --directory .github/compat >/tmp/compat-http.log 2>&1 &
SERVER_PID=$!
trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT

adb wait-for-device
adb shell am start -a android.intent.action.VIEW -d http://10.0.2.2:8765/kitkat-smoke.html

attempt=0
while [ "$attempt" -lt 30 ]; do
  attempt=$((attempt + 1))
  sleep 2
  adb shell uiautomator dump /sdcard/window.xml >/dev/null 2>&1 || true
  adb pull /sdcard/window.xml /tmp/window.xml >/dev/null 2>&1 || true
  if grep -q 'KitKat JavaScript smoke test: PASS' /tmp/window.xml 2>/dev/null; then
    echo 'KitKat browser smoke test passed.'
    exit 0
  fi
done

echo 'KitKat browser did not display a passing smoke-test result.'
adb logcat -d -t 1000 || true
cat /tmp/compat-http.log || true
exit 1
