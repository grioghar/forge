#!/bin/sh
# forge/play/build-chip8-play.sh — build the interactive CHIP-8 player (arm64 macOS).
#
# Run it directly: forge/dist/forge-chip8-play-macos-arm64
# Type moves (w/a/s/d) then Enter to move; 'q' + Enter to quit. (cc0's raw
# syscall builtins don't support real per-keystroke reads on arm64 macOS today —
# see the toolchain note atop chip8_play.sg — so this is turn-based, not raw-mode.)
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
OBJ="$(mktemp -t c8p).o"; OUT="$REPO/forge/dist/forge-chip8-play-macos-arm64"
printf '%s\n%s\n%s\n%s\n%s\n\n%s\n' "$OBJ" \
  "$REPO/forge/input/pad.sg" "$REPO/forge/input/bind_chip8.sg" \
  "$REPO/forge/play/chip8_core.sg" "$REPO/forge/play/chip8_play.sg" "macho" | "$CC0"
ld -o "$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
echo "Built: $OUT"
