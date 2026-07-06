#!/bin/sh
# forge/tools/build-forge-seal-mac.sh — build the native macOS (arm64) relic
# sealer. No Proxmox / Linux round-trip needed.
set -e
REPO="$(cd "$(dirname "$0")/../.." && pwd)"; CC0="${CC0:-$HOME/sigil/selfhost/cc0_mac}"; SDK="$(xcrun --show-sdk-path)"
OBJ="$(mktemp -t fsm).o"; OUT="$REPO/forge/dist/forge-seal-mac-arm64"
printf '%s\n%s\n%s\n%s\n\n%s\n' "$OBJ" \
  "$REPO/forge/tools/sha256_fast.sg" "$REPO/forge/tools/crc32.sg" "$REPO/forge/tools/forge_seal_mac.sg" "macho" | "$CC0"
ld -o "$OUT" "$OBJ" -e _main -lSystem -syslibroot "$SDK"; rm -f "$OBJ"
echo "Built: $OUT"
