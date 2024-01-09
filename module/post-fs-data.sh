MODDIR="${0%/*}"
. "$MODDIR/common.sh"

# Remove Play Services from Magisk Denylist when set to enforcing
if magisk --denylist status; then
    magisk --denylist rm com.google.android.gms
fi

# Remove conflicting modules if installed
if [ -d /data/adb/modules/safetynet-fix ]; then
    touch /data/adb/modules/safetynet-fix/remove
fi

# Replace conflicting custom ROM injection app folders to disable them
LIST=$MODDIR/example.app_replace.list
[ -f "$MODDIR/custom.app_replace.list" ] && LIST=$MODDIR/custom.app_replace.list
for APP in $(grep -v '^#' $LIST); do
    if [ -d "$APP" ]; then
        HIDEDIR=$MODDIR/$APP
        mkdir -p $HIDEDIR
        touch $HIDEDIR/.replace
    fi
done

# Conditional early sensitive properties

# Samsung
resetprop_if_diff ro.boot.warranty_bit 0
resetprop_if_diff ro.vendor.boot.warranty_bit 0
resetprop_if_diff ro.vendor.warranty_bit 0
resetprop_if_diff ro.warranty_bit 0

# Xiaomi
resetprop_if_diff ro.secureboot.lockstate locked

# Realme
resetprop_if_diff ro.boot.realme.lockstate 1
resetprop_if_diff ro.boot.realmebootstate green

# OnePlus
resetprop_if_diff ro.is_ever_orange 0

# Microsoft, RootBeer
resetprop_if_diff ro.build.tags release-keys

# Other
resetprop_if_diff ro.build.type user
resetprop_if_diff ro.debuggable 0
resetprop_if_diff ro.secure 1
