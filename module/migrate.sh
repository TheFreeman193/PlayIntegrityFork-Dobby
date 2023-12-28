#!/bin/sh

case "$1" in
  -h|--help|help) echo "sh migrate.sh [-f] [file]"; exit 0;;
esac;

case "$1" in
  -i|--install|install) INSTALL=1; shift;;
  *) echo "custom.pif.json migration script \
       \n  by osm0sis @ xda-developers \n";;
esac;

item() { echo "- $@"; }
die() { [ "$INSTALL" ] || echo "\n\n! $@"; exit 1; }
grep_get_json() { grep "$1" "$DIR/custom.pif.json" | cut -d\" -f4; }
grep_check_json() { grep -q "$1" "$DIR/custom.pif.json" && [ "$(grep_get_json "$1")" ]; }

case "$1" in
  -f|--force|force) FORCE=1; shift;;
esac;

if [ -f "$1" ]; then
  DIR="$1";
  shift;
else
  case "$0" in
    *.sh) DIR="$0";;
       *) DIR="$(lsof -p $$ 2>/dev/null | grep -o '/.*migrate.sh$')";;
  esac;
fi;
DIR=$(dirname "$(readlink -f "$DIR")");

[ -f "$DIR/custom.pif.json" ] || die "No custom.pif.json found";

grep_check_json api_level && [ ! "$FORCE" ] && die "No migration required";

[ "$INSTALL" ] || item "Parsing fields ...";

FPFIELDS="BRAND PRODUCT DEVICE RELEASE ID INCREMENTAL TYPE TAGS";
ALLFIELDS="MANUFACTURER MODEL FINGERPRINT $FPFIELDS SECURITY_PATCH DEVICE_INITIAL_SDK_INT";

for FIELD in $ALLFIELDS; do
  eval $FIELD=\"$(grep_get_json \"$FIELD\")\";
done;

if [ -z "$ID" ] && grep_check_json BUILD_ID; then
  item 'Deprecated entry BUILD_ID found, changing to ID field and "*.build.id" property ...';
  ID="$(grep_get_json BUILD_ID)";
fi;

if [ -n "$SECURITY_PATCH" ] && ! grep_check_json security_patch; then
  item 'Simple entry SECURITY_PATCH found, changing to SECURITY_PATCH field and "*.security_patch" property ...';
fi;

if grep_check_json VNDK_VERSION; then
  item 'Deprecated entry VNDK_VERSION found, changing to "*.vndk_version" property ...';
  VNDK_VERSION="$(grep_get_json VNDK_VERSION)";
fi;

if [ -z "$DEVICE_INITIAL_SDK_INT" ] && grep_check_json FIRST_API_LEVEL; then
  item 'Deprecated entry FIRST_API_LEVEL found, changing to DEVICE_INITIAL_SDK_INT field and "*api_level" property ...';
  DEVICE_INITIAL_SDK_INT="$(grep_get_json FIRST_API_LEVEL)";
fi;

if [ -z "$RELEASE" -o -z "$INCREMENTAL" -o -z "$TYPE" -o -z "$TAGS" ]; then
  item "Missing default fields found, deriving from FINGERPRINT ...";
  IFS='/:' read F1 F2 F3 F4 F5 F6 F7 F8 <<EOF
$(grep_get_json FINGERPRINT)
EOF
  i=1;
  for FIELD in $FPFIELDS; do
    eval [ -z "\$$FIELD" ] \&\& $FIELD=\"\$F$i\";
    i=$((i+1));
  done;
fi;

if [ -z "$DEVICE_INITIAL_SDK_INT" -o "$DEVICE_INITIAL_SDK_INT" = "null" ]; then
  item 'Missing required DEVICE_INITIAL_SDK_INT field and "*api_level" property value found, setting to 25 ...';
  DEVICE_INITIAL_SDK_INT=25;
fi;

item "Renaming old file to custom.pif.json.bak ...";
mv -f "$DIR/custom.pif.json" "$DIR/custom.pif.json.bak";

[ "$INSTALL" ] || item "Writing fields and properties to updated custom.pif.json ...";

(echo "{";
echo "  // Build Fields";
for FIELD in $ALLFIELDS; do
  eval echo '\ \ \ \ \"$FIELD\": \"'\$$FIELD'\",';
done;
echo "
  // System Properties";
echo '    "*.build.id": "'$ID'",';
echo '    "*.security_patch": "'$SECURITY_PATCH'",';
[ -z "$VNDK_VERSION" ] || echo '    "*.vndk_version": "'$VNDK_VERSION'",';
echo '    "*api_level": "'$DEVICE_INITIAL_SDK_INT'"';
echo "}") > "$DIR/custom.pif.json";

[ "$INSTALL" ] || cat "$DIR/custom.pif.json";

