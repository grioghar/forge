#!/bin/sh
# forge/play/build-gba-test.sh — build the GBA native boot test (arm64 macOS).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
OBJ="$(mktemp -t gba).o"; OUT="$REPO/forge/dist/forge-gba-boot-test-macos-arm64"
printf '%s\n%s\n%s\n\n%s\n' "$OBJ" "$REPO/forge/play/gba_core.sg" "$REPO/forge/play/gba_boot_test.sg" "macho" | "$CC0"
ld -o "$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
echo "Built: $OUT"
