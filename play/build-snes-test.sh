#!/bin/sh
# forge/play/build-snes-test.sh — build the SNES native relic+controller tests (arm64 macOS).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
build() {
  OBJ="$(mktemp -t sn).o"; OUT="$1"; shift
  printf '%s\n' "$OBJ" "$@" "" "macho" | tr ' ' '\n' | "$CC0"
  ld -o "$REPO/forge/dist/$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
  echo "Built: forge/dist/$OUT"
}
build forge-snes-relic-test-macos-arm64 \
  "$REPO/forge/play/spc700_core.sg" "$REPO/forge/play/snes_core.sg" "$REPO/forge/play/snes_relic_test.sg"
build forge-snes-input-test-macos-arm64 \
  "$REPO/forge/input/pad.sg" "$REPO/forge/input/bind_normalized.sg" \
  "$REPO/forge/play/spc700_core.sg" "$REPO/forge/play/snes_core.sg" "$REPO/forge/play/snes_input_test.sg"
