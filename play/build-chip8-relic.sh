#!/bin/sh
# Build "play a game from a sealed RELIC-V2 ROM relic" (arm64 macOS).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
OBJ="$(mktemp -t c8r).o"; OUT="$REPO/forge/dist/forge-chip8-relic-macos-arm64"
printf '%s\n%s\n%s\n\n%s\n' "$OBJ" "$REPO/forge/play/chip8_core.sg" "$REPO/forge/play/chip8_relic.sg" "macho" | "$CC0"
ld -o "$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"; echo "Built: $OUT"; "$OUT"
