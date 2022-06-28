#!/bin/bash
APPNAME="${1:?Missing app name parameter}"
APPBUNDLE="${2:?Missing app bundle path parameter}"

APPBUNDLECONTENTS=${APPBUNDLE}/Contents
APPBUNDLEEXE=${APPBUNDLECONTENTS}/MacOS
APPBUNDLERESOURCES=${APPBUNDLECONTENTS}/Resources
TARGET="${APPBUNDLEEXE}/${APPNAME}"

# create appsupport executable
clang -ObjC macosx/appsupport.m -arch arm64 -arch x86_64 -framework Foundation -o macosx/appsupport

# create app icon
rm -rf "macosx/${APPNAME}.iconset"
mkdir "macosx/${APPNAME}.iconset"
sips -z 16 16     "macosx/${APPNAME}Icon.png --out macosx/${APPNAME}.iconset/icon_16x16.png"
sips -z 32 32     "macosx/${APPNAME}Icon.png --out macosx/${APPNAME}.iconset/icon_16x16@2x.png"
sips -z 32 32     "macosx/${APPNAME}Icon.png --out macosx/${APPNAME}.iconset/icon_32x32.png"
sips -z 64 64     "macosx/${APPNAME}Icon.png --out macosx/${APPNAME}.iconset/icon_32x32@2x.png"
sips -z 128 128   "macosx/${APPNAME}Icon.png --out macosx/${APPNAME}.iconset/icon_128x128.png"
sips -z 256 256   "macosx/${APPNAME}Icon.png --out macosx/${APPNAME}.iconset/icon_128x128@2x.png"
sips -z 256 256   "macosx/${APPNAME}Icon.png --out macosx/${APPNAME}.iconset/icon_256x256.png"
sips -z 512 512   "macosx/${APPNAME}Icon.png --out macosx/${APPNAME}.iconset/icon_256x256@2x.png"
sips -z 512 512   "macosx/${APPNAME}Icon.png --out macosx/${APPNAME}.iconset/icon_512x512.png"
cp "macosx/${APPNAME}Icon.png" "macosx/${APPNAME}.iconset/icon_512x512@2x.png"
iconutil -c icns -o "macosx/${APPNAME}.icns" "macosx/${APPNAME}.iconset"
rm -r "macosx/${APPNAME}.iconset"

# copy over necessary items
mkdir $APPBUNDLERESOURCES
cp "macosx/PkgInfo" $APPBUNDLECONTENTS/
cp "macosx/${APPNAME}.icns" $APPBUNDLERESOURCES/
cp "macosx/launcher.sh" "${APPBUNDLEEXE}/launcher.sh"
cp "macosx/appsupport" "${APPBUNDLEEXE}/appsupport"

# embed non system frameworks used by the app
otool -l "${TARGET}" | grep -A 2 LC_RPATH  | tail -n 1 | awk '{print $2}' | dylibbundler -od -b -x  "${TARGET}" -d "${APPBUNDLECONTENTS}/libs"
