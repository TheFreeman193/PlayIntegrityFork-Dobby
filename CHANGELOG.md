# Custom Fork v4
- Very verbose logging (for now)
- Allow spoofing literally any field from android.os.Build or android.os.Build.VERSION
- Add BUILD_ID and VNDK_VERSION support to keep cross-fork API compatibility
- Add exceptions for FIRST_API_VERSION (actually DEVICE_INITIAL_SDK_INT) and BUILD_ID (actually ID) for backwards API compatibility
- Add empty example.pif.json with reference link
- Fix GMS crashes if a null/bad value was read from json

# Custom Fork v3
- Combine system.prop (runs at post-fs-data) entries into service.sh so that they're only set if needed
- Clean up GMS data pif.prop/pif.json files left over from previous releases to ensure they don't trigger detection
- Use custom.pif.json for custom spoofing if it exists, self-contained in the module directory, and restore it after module updates
- Move props that need to be changed earlier into post-fs-data.sh
- Warn of possible conflict if MagiskHidePropsConfig (MHPC) is installed
- Continue to use ShadowHook for now

