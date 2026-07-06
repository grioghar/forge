#!/bin/sh
# forge/app/build-forge-gui.sh — build the native Cocoa Forge Complete GUI
# (arm64 macOS). Requires a cc0_mac built from sigil#188 or later (the
# dyld_call6/dyld_call_rect/addr()-PIE-fix branch) — the stock cc0 has no
# Cocoa/AppKit FFI support at all.
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
OBJ="$(mktemp -t fggui).o"; OUT="$REPO/forge/dist/forge-gui-macos-arm64"
printf '%s\n%s\n\n%s\n' "$OBJ" "$REPO/forge/app/forge_gui.sg" "macho" | "$CC0"
ld -o "$OUT" "$OBJ" -e _main -lSystem -framework Cocoa -syslibroot "$SDK"; rm -f "$OBJ"
echo "Built: $OUT"
