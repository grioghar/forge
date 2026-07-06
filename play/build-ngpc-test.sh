#!/bin/sh
# forge/play/build-ngpc-test.sh — build the Neo Geo Pocket (Color) native
# boot test (arm64 macOS).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
build() {
  OBJ="$(mktemp -t ngpc).o"; OUT="$1"; shift
  printf '%s\n' "$OBJ" "$@" "" "macho" | tr ' ' '\n' | "$CC0"
  ld -o "$REPO/forge/dist/$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
  echo "Built: forge/dist/$OUT"
}
build forge-ngpc-boot-test-macos-arm64 "$REPO/forge/play/ngpc_core.sg" "$REPO/forge/play/ngpc_boot_test.sg"
