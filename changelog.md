# CUSTOM SPOOF FORK v3

- Combine system.prop (runs at post-fs-data) entries into service.sh so that they're only set if needed
- Clean up GMS data pif.prop/pif.json files left over from previous releases to ensure they don't trigger detection
- Use custom.pif.json for custom spoofing if it exists, self-contained in the module directory, and restore it after module updates
- Move props that need to be changed earlier into post-fs-data.sh
- Warn of possible conflict if MagiskHidePropsConfig (MHPC) is installed
