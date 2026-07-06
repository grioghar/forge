#!/bin/sh
# forge/app/build-forge-complete.sh — build Forge Complete (arm64 macOS): pick a
# system from the catalog and play (CHIP-8 today; the rest is honestly labeled
# catalog-only until their engines are wired).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
OBJ="$(mktemp -t fgc).o"; OUT="$REPO/forge/dist/forge-complete-macos-arm64"
printf '%s\n%s\n%s\n%s\n%s\n%s\n\n%s\n' "$OBJ" \
  "$REPO/forge/app/catalog.sg" "$REPO/forge/input/pad.sg" "$REPO/forge/input/bind_chip8.sg" \
  "$REPO/forge/play/chip8_core.sg" "$REPO/forge/app/forge_complete.sg" "macho" | "$CC0"
ld -o "$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
echo "Built: $OUT"
