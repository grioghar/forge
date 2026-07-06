#!/bin/sh
# forge/play/build-gb-test.sh — build the Game Boy native tests (arm64 macOS).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
build() {
  OBJ="$(mktemp -t gb).o"; OUT="$1"; shift
  printf '%s\n' "$OBJ" "$@" "" "macho" | tr ' ' '\n' | "$CC0"
  ld -o "$REPO/forge/dist/$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
  echo "Built: forge/dist/$OUT"
}
build forge-gb-boot-test-macos-arm64 "$REPO/forge/play/gb_core.sg" "$REPO/forge/play/gb_boot_test.sg"
build forge-gb-input-test-macos-arm64 \
  "$REPO/forge/input/pad.sg" "$REPO/forge/input/bind_normalized.sg" "$REPO/forge/play/gb_core.sg" "$REPO/forge/play/gb_input_test.sg"
