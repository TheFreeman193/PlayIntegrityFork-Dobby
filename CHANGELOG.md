## Custom Fork v5
- Allow spoofing literally any system property, supporting * lead wildcard to match multiple
- Remove all backwards compat cruft and deprecated entries
- Add log levels with VERBOSE_LOGS last json entry of 0, 1, 2, 3 or 100
- Spoof sys.usb.state to DroidGuard by default to hide USB Debugging
- Update example json for properties
- Add migration script to automatically upgrade old custom.pif.json during install/update (may also be run manually)

## Custom Fork v4
- Very verbose logging (for now)
- Allow spoofing literally any field from android.os.Build or android.os.Build.VERSION
- Add BUILD_ID and VNDK_VERSION support to keep cross-fork API compatibility
- Add exceptions for FIRST_API_VERSION (actually DEVICE_INITIAL_SDK_INT) and BUILD_ID (actually ID) for backwards API compatibility
- Add empty example.pif.json with reference link
- Fix GMS crashes if a null/bad value was read from json

_[Previous changelogs](https://github.com/osm0sis/PlayIntegrityFork/releases)_
