#!/bin/sh
# Forge installer for Linux
# Installs forge to ~/bin (or /usr/local/bin with sudo) and creates the ROM directory.
#
# Two layouts supported:
#   (1) Real download bundle (forge-linux-x86_64-{thin,fat}.tar.gz, extracted): this
#       script sits NEXT TO the "forge" binary, plus catalog.json + cores/ for fat.
#   (2) In-repo dev layout: forge/install/install-linux.sh alongside forge/dist/*.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROM_DIR="$HOME/forge/roms"

echo "Forge Installer - Linux"
echo "-----------------------"

BINARY=""
CORES_DIR=""
if [ -f "$SCRIPT_DIR/forge" ]; then
    BINARY="$SCRIPT_DIR/forge"
    if [ -d "$SCRIPT_DIR/cores" ]; then CORES_DIR="$SCRIPT_DIR/cores"; fi
fi

if [ -z "$BINARY" ]; then
    for variant in thin fat; do
        candidate="$SCRIPT_DIR/../dist/forge-linux-x86_64-$variant"
        if [ -f "$candidate" ]; then
            BINARY="$candidate"
            if [ -d "$SCRIPT_DIR/../catalog/cores" ]; then CORES_DIR="$SCRIPT_DIR/../catalog/cores"; fi
            break
        fi
    done
fi

if [ -z "$BINARY" ]; then
    echo "Error: no forge binary found next to this script or in ../dist/"
    exit 1
fi

# Install to ~/bin if it exists and is on PATH, else /usr/local/bin
if [ -d "$HOME/bin" ]; then
    INSTALL_DIR="$HOME/bin"
else
    INSTALL_DIR="/usr/local/bin"
fi

echo "Installing to $INSTALL_DIR/forge ..."
install -m 755 "$BINARY" "$INSTALL_DIR/forge"

echo "Creating ROM directory at $ROM_DIR ..."
mkdir -p "$ROM_DIR"
for sys in nes snes genesis psx gb gba sms gamegear n64 pce arcade; do
    mkdir -p "$ROM_DIR/$sys"
done

if [ -n "$CORES_DIR" ]; then
    CORES_INSTALL_DIR="$HOME/forge/cores"
    echo "Fat bundle detected — installing $(ls "$CORES_DIR"/*.sigpkg 2>/dev/null | wc -l | tr -d ' ') bundled cores to $CORES_INSTALL_DIR ..."
    mkdir -p "$CORES_INSTALL_DIR"
    cp "$CORES_DIR"/*.sigpkg "$CORES_INSTALL_DIR/" 2>/dev/null || true
fi

echo ""
echo "Done. Run: forge"
echo "Place ROMs in: $ROM_DIR/<system>/"
echo ""
"$INSTALL_DIR/forge"
