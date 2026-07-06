#!/bin/sh
# forge/play/build-genesis-test.sh — build the Genesis native tests (arm64 macOS).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
CORE="$REPO/forge/play/m68k_core.sg $REPO/forge/play/m68k_singlebus_core.sg $REPO/forge/play/ym2612_core.sg $REPO/forge/play/psg_core.sg $REPO/forge/play/genesis_core.sg $REPO/forge/play/genesis_abi_core.sg $REPO/forge/play/genesis_id_core.sg"
build() {
  OBJ="$(mktemp -t gn).o"; OUT="$1"; shift
  printf '%s\n' "$OBJ" "$@" "" "macho" | tr ' ' '\n' | "$CC0"
  ld -o "$REPO/forge/dist/$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
  echo "Built: forge/dist/$OUT"
}
build forge-genesis-boot-test-macos-arm64 $CORE "$REPO/forge/play/genesis_boot_test.sg"
build forge-genesis-input-test-macos-arm64 \
  "$REPO/forge/input/pad.sg" "$REPO/forge/input/bind_normalized.sg" $CORE "$REPO/forge/play/genesis_input_test.sg"
