#!/bin/sh
# forge/play/build-gamegear-test.sh — build the Game Gear/SMS native tests (arm64 macOS).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
CORE="$REPO/forge/play/z80_core.sg $REPO/forge/play/psg_gg_core.sg $REPO/forge/play/sms_vdp_core.sg $REPO/forge/play/sms_core.sg $REPO/forge/play/gamegear_core.sg"
build() {
  OBJ="$(mktemp -t gg).o"; OUT="$1"; shift
  printf '%s\n' "$OBJ" "$@" "" "macho" | tr ' ' '\n' | "$CC0"
  ld -o "$REPO/forge/dist/$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
  echo "Built: forge/dist/$OUT"
}
build forge-gamegear-boot-test-macos-arm64 $CORE "$REPO/forge/play/gamegear_boot_test.sg"
build forge-gamegear-input-test-macos-arm64 \
  "$REPO/forge/input/pad.sg" "$REPO/forge/input/bind_normalized.sg" $CORE "$REPO/forge/play/gamegear_input_test.sg"
