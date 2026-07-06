#!/bin/sh
# forge/input/build-input-demo.sh — build the input-abstraction demo (arm64 macOS).
# cc0 -> Mach-O object -> ld (adds the ad-hoc linker signature so it runs).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"
SDK="$(xcrun --show-sdk-path)"
OBJ="$(mktemp -t indemo).o"
OUT="$REPO/forge/dist/forge-input-demo-macos-arm64"
printf '%s\n%s\n%s\n%s\n%s\n\n%s\n' "$OBJ" \
  "$REPO/forge/input/pad.sg" "$REPO/forge/input/bind_chip8.sg" \
  "$REPO/forge/input/bind_dos.sg" "$REPO/forge/input/input_demo.sg" "macho" | "$CC0"
ld -o "$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"
rm -f "$OBJ"
echo "Built: $OUT"; "$OUT"
