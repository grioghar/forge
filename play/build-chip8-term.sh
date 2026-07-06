#!/bin/sh
# Build the CHIP-8 IBM-logo demo (arm64 macOS). cc0 object -> ld (linker ad-hoc sign).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
OBJ="$(mktemp -t c8t).o"; OUT="$REPO/forge/dist/forge-chip8-macos-arm64"
printf '%s\n%s\n%s\n\n%s\n' "$OBJ" "$REPO/forge/play/chip8_core.sg" "$REPO/forge/play/chip8_term.sg" "macho" | "$CC0"
ld -o "$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"; echo "Built: $OUT"; "$OUT"
