#!/bin/sh
# forge/app/build-forge-app.sh — package Forge as a real, Finder-launchable
# Forge.app bundle (arm64 macOS). Builds forge_gui.sg fresh, then assembles
# Contents/MacOS + Contents/Info.plist + Contents/Resources/dist (every
# per-system binary the GUI's buttons launch via NSTask), and ad-hoc
# codesigns it (required on Apple Silicon even for local-only execution).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
APP="$REPO/forge/dist/Forge.app"
VERSION="0.3.0"

sh "$REPO/forge/app/build-forge-gui.sh"

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources/dist"

cp "$REPO/forge/dist/forge-gui-macos-arm64" "$APP/Contents/MacOS/Forge"
chmod +x "$APP/Contents/MacOS/Forge"
cp "$REPO/forge/assets/AppIcon.icns" "$APP/Contents/Resources/AppIcon.icns"

for bin in forge-gb-boot-test-macos-arm64 forge-gba-boot-test-macos-arm64 \
           forge-snes-input-test-macos-arm64 forge-genesis-boot-test-macos-arm64 \
           forge-s32x-boot-test-macos-arm64 forge-gamegear-boot-test-macos-arm64 \
           forge-vb-boot-test-macos-arm64 forge-fds-boot-test-macos-arm64 \
           forge-ngpc-boot-test-macos-arm64 forge-ws-boot-test-macos-arm64 \
           forge-seal-mac-arm64; do
  cp "$REPO/forge/dist/$bin" "$APP/Contents/Resources/dist/$bin"
  chmod +x "$APP/Contents/Resources/dist/$bin"
done

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>Forge</string>
    <key>CFBundleIdentifier</key>
    <string>co.grio.forge</string>
    <key>CFBundleName</key>
    <string>Forge</string>
    <key>CFBundleDisplayName</key>
    <string>Forge</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleVersion</key>
    <string>$VERSION</string>
    <key>LSMinimumSystemVersion</key>
    <string>11.0</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
PLIST

codesign -s - --force --deep "$APP" 2>&1
xattr -cr "$APP" 2>/dev/null || true

echo "Built: $APP"
