#!/bin/sh
# forge/play/build-fds-test.sh — build the FDS/NES native tests (arm64 macOS).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
CORE="$REPO/forge/play/nes_core.sg $REPO/forge/play/fds_core.sg"
build() {
  OBJ="$(mktemp -t fds).o"; OUT="$1"; shift
  printf '%s\n' "$OBJ" "$@" "" "macho" | tr ' ' '\n' | "$CC0"
  ld -o "$REPO/forge/dist/$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
  echo "Built: forge/dist/$OUT"
}
build forge-fds-boot-test-macos-arm64 $CORE "$REPO/forge/play/fds_boot_test.sg"
build forge-fds-input-test-macos-arm64 \
  "$REPO/forge/input/pad.sg" "$REPO/forge/input/bind_normalized.sg" $CORE "$REPO/forge/play/fds_input_test.sg"
