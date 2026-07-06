#!/bin/sh
# forge/input/build-ctrl-demo.sh — build the CONTROLLER-relic demo (arm64 macOS).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
OBJ="$(mktemp -t ctrl).o"; OUT="$REPO/forge/dist/forge-ctrl-demo-macos-arm64"
printf '%s\n%s\n%s\n%s\n%s\n%s\n%s\n\n%s\n' "$OBJ" \
  "$REPO/forge/input/pad.sg" "$REPO/forge/input/bind_chip8.sg" "$REPO/forge/input/bind_dos.sg" \
  "$REPO/forge/app/relic_ctrl_cfg.sg" "$REPO/forge/input/ctrl_relic.sg" "$REPO/forge/input/ctrl_demo.sg" "macho" | "$CC0"
ld -o "$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
echo "Built: $OUT"; "$OUT"
