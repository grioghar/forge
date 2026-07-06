#!/bin/sh
# Forge installer for macOS
# Installs forge to /usr/local/bin and creates the ROM directory.
#
# Two layouts supported:
#   (1) Real download bundle (forge-macos-{arch}-{thin,fat}.tar.gz, extracted): this
#       script sits NEXT TO the "forge" binary, plus catalog.json + cores/ for fat.
#   (2) In-repo dev layout: forge/install/install-macos.sh alongside forge/dist/*.
set -e

INSTALL_DIR="/usr/local/bin"
ROM_DIR="$HOME/Documents/Forge/roms"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

ARCH="$(uname -m)"
ARCH_TAG="x86_64"
if [ "$ARCH" = "arm64" ]; then
    ARCH_TAG="arm64"
fi

# (1) bundle layout — binary is a sibling of this script
BINARY=""
CORES_DIR=""
if [ -f "$SCRIPT_DIR/forge" ]; then
    BINARY="$SCRIPT_DIR/forge"
    if [ -d "$SCRIPT_DIR/cores" ]; then CORES_DIR="$SCRIPT_DIR/cores"; fi
fi

# (2) in-repo dev layout — forge/dist/forge-macos-{arch}-{thin,fat}
if [ -z "$BINARY" ]; then
    for variant in thin fat; do
        candidate="$SCRIPT_DIR/../dist/forge-macos-$ARCH_TAG-$variant"
        if [ -f "$candidate" ]; then
            BINARY="$candidate"
            if [ -d "$SCRIPT_DIR/../catalog/cores" ]; then CORES_DIR="$SCRIPT_DIR/../catalog/cores"; fi
            break
        fi
    done
fi

echo "Forge Installer - macOS"
echo "-----------------------"

if [ -z "$BINARY" ]; then
    echo "Error: no forge binary found next to this script or in ../dist/"
    exit 1
fi

echo "Installing to $INSTALL_DIR/forge ..."
cp "$BINARY" "$INSTALL_DIR/forge"
chmod +x "$INSTALL_DIR/forge"
xattr -c "$INSTALL_DIR/forge" 2>/dev/null || true   # clear Gatekeeper quarantine

echo "Creating ROM directory at $ROM_DIR ..."
mkdir -p "$ROM_DIR"
for sys in nes snes genesis psx gb gba sms gamegear n64 pce arcade; do
    mkdir -p "$ROM_DIR/$sys"
done

if [ -n "$CORES_DIR" ]; then
    CORES_INSTALL_DIR="$HOME/Documents/Forge/cores"
    echo "Fat bundle detected — installing $(ls "$CORES_DIR"/*.sigpkg 2>/dev/null | wc -l | tr -d ' ') bundled cores to $CORES_INSTALL_DIR ..."
    mkdir -p "$CORES_INSTALL_DIR"
    cp "$CORES_DIR"/*.sigpkg "$CORES_INSTALL_DIR/" 2>/dev/null || true
fi

echo ""
echo "Done. Run: forge"
echo "Place ROMs in: $ROM_DIR/<system>/"
echo ""
forge
