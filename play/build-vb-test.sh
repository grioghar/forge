#!/bin/sh
# forge/play/build-vb-test.sh — build the Virtual Boy native boot test (arm64 macOS).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
OBJ="$(mktemp -t vb).o"; OUT="$REPO/forge/dist/forge-vb-boot-test-macos-arm64"
printf '%s\n%s\n%s\n\n%s\n' "$OBJ" "$REPO/forge/play/vb_core.sg" "$REPO/forge/play/vb_boot_test.sg" "macho" | "$CC0"
ld -o "$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
echo "Built: $OUT"
