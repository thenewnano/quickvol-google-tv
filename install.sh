#!/usr/bin/env bash
# Build QuickVol TV, install it on the TV over ADB and let it switch its own key service on.
#   TV_HOST=<tv ip> ./install.sh        (network debugging on; leave it off afterwards)
#   ./install.sh                        (one device already attached, e.g. over USB)
# Needs JDK 17, the Android SDK (ANDROID_HOME) and adb on PATH.
set -euo pipefail
cd "$(dirname "$0")"
PKG=io.github.thenewnano.quickvol
[ -f local.properties ] || { [ -n "${ANDROID_HOME:-}" ] && echo "sdk.dir=${ANDROID_HOME//\\//}" > local.properties; } || true
if [ -n "${JAVA_HOME:-}" ]; then export PATH="$JAVA_HOME/bin:$PATH"; fi
./gradlew assembleRelease -q --console=plain

if [ -n "${TV_HOST:-}" ]; then adb connect "$TV_HOST:5555" >/dev/null; fi
adb install -r app/build/outputs/apk/release/app-release.apk
# Only this lets the app switch its own key service on when it is opened.
adb shell pm grant "$PKG" android.permission.WRITE_SECURE_SETTINGS
adb shell am start -n "$PKG/.MainActivity" >/dev/null
echo "Installed. QuickVol TV is open on the TV: Left/Right change a level, OK plays it."
echo "Turn network debugging off when you are done."
