# QuickVol TV

One-press volume presets for Android TV. The Red, Green, Yellow and Blue buttons on a TV remote are meant for teletext and are unused on most TVs. QuickVol TV makes each one set the volume to a level you choose: 10, 15, 20 and 25 to start with. One screen lists the
four buttons; Left and Right change a level (hold to run), OK sets the volume to it so you can judge it by ear.
Changes take effect at once, with no rebuild and no restart.

Made on a Philips UHD Android TV (TPV, MediaTek), Android 14. It sets the media volume through Android's normal
volume call, with the TV's own volume bar. Some firmware ignores that call (on the Philips,
`adb shell cmd media_session volume --set` is ignored while an app's call is not); on such a TV it does nothing.

## Install

Build it from source and sideload it; no prebuilt APK is published.

```
TV_HOST=<tv ip> ./install.sh
```

It needs JDK 17, the Android SDK (`ANDROID_HOME`) and `adb`, and the TV's network debugging on while it runs. It
builds the app, installs it, grants the one permission and opens it. Opening the app switches its key service on.
Turn network debugging off afterwards.

## How it works

One accessibility service sees key presses to catch the four colour buttons and ignores every other key and all
screen content (it subscribes to no accessibility events). On a press it calls
`AudioManager.setStreamVolume` for the music stream and shows the TV's volume bar. The levels live in the app's own
preferences.

A key-filtering service means a held Volume button moves one step per press on some firmware. Keys sent with
`adb shell input keyevent` do not reach it; test with the real remote.

## Permissions

| Permission | Why |
|---|---|
| `BIND_ACCESSIBILITY_SERVICE` (the service) | To catch the four colour buttons. |
| `WRITE_SECURE_SETTINGS` | Only to switch on its own key service when the app is opened. Android lets only ADB grant it; `install.sh` does. Without it, turn the service on in Settings > Accessibility. |

No internet permission: nothing leaves the TV. No telemetry, ads, accounts or libraries.

## With Clean Your TV

It declares a module card for the [Clean Your TV](https://github.com/Gathin23/cleanyourtv) launcher, so its tile
can show on that Home screen. On any other Android TV home it is an ordinary app.

## Licence

MIT, see [LICENSE](LICENSE).
