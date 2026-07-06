#!/bin/sh
# forge/play/build-s32x-test.sh — build the 32X (SH2) native boot test (arm64 macOS).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
OBJ="$(mktemp -t s32x).o"; OUT="$REPO/forge/dist/forge-s32x-boot-test-macos-arm64"
printf '%s\n%s\n%s\n%s\n\n%s\n' "$OBJ" \
  "$REPO/forge/play/sh2_core.sg" "$REPO/forge/play/s32x_core.sg" "$REPO/forge/play/s32x_boot_test.sg" "macho" | "$CC0"
ld -o "$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
echo "Built: $OUT"
