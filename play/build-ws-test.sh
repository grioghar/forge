#!/bin/sh
# forge/play/build-ws-test.sh — build the WonderSwan (mono) native boot test
# (arm64 macOS).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
build() {
  OBJ="$(mktemp -t ws).o"; OUT="$1"; shift
  printf '%s\n' "$OBJ" "$@" "" "macho" | tr ' ' '\n' | "$CC0"
  ld -o "$REPO/forge/dist/$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
  echo "Built: forge/dist/$OUT"
}
build forge-ws-boot-test-macos-arm64 \
  "$REPO/forge/play/ws_core.sg" "$REPO/forge/play/ws_video_core.sg" "$REPO/forge/play/ws_boot_test.sg"
