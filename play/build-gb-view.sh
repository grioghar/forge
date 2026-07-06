#!/bin/sh
# forge/play/build-gb-view.sh — build the Game Boy terminal viewer (arm64 macOS).
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
OBJ="$(mktemp -t gbview).o"; OUT="$REPO/forge/dist/forge-gb-view-macos-arm64"
printf '%s\n%s\n%s\n\n%s\n' "$OBJ" "$REPO/forge/play/gb_core.sg" "$REPO/forge/play/gb_relic_view.sg" "macho" | "$CC0"
ld -o "$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
echo "Built: $OUT"
