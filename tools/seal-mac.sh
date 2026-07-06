#!/bin/sh
# forge/tools/seal-mac.sh — seal a ROM into a RELIC-V2 relic, native on your Mac
# (Apple Silicon arm64). No Proxmox, no Linux round-trip.
#
# Usage:
#   sh forge/tools/seal-mac.sh <input-rom> <system-id> [core-id] [output-path]
#
# system-id is the catalog.sg index for the console (see forge/app/catalog.sg,
# or run forge/dist/forge-complete-macos-arm64 to see the numbered list). Common
# ones: 25=Game Boy, 26=GBA, 27=GBC, 28=Genesis, 40=NES, 53=32X, 58=SNES,
# 24=Game Gear, 62=Virtual Boy, 22=FDS.
#
# core-id defaults to system-id (most cores are 1:1 with their system).
# output-path defaults to <input-rom's name>.relic in the current directory.
#
# Performance: ~0.3s/MB (a 25MB relic seals in ~8s). Output goes through
# print()-per-call (the only byte-exact write path on arm64 macOS today — see
# forge/tools/forge_seal_mac.sg for why write_bytes/write_buf can't be used),
# but only the ~128-byte header/footer go byte-by-byte — the multi-MB payload
# is emitted in ONE call. Hashing uses forge/tools/sha256_fast.sg (native
# xor/band/shl/shr instead of software bit-loops) — ~29x faster than the
# original sha256.sg, verified bit-exact against `shasum -a256` throughout.
set -e

if [ -z "$2" ]; then
  echo "Usage: sh $0 <input-rom> <system-id> [core-id] [output-path]" >&2
  exit 1
fi

REPO="$(cd "$(dirname "$0")/../.." && pwd)"
BIN="$REPO/forge/dist/forge-seal-mac-arm64"
[ -x "$BIN" ] || { echo "build first: sh forge/tools/build-forge-seal-mac.sh" >&2; exit 1; }

IN="$1"
[ -f "$IN" ] || { echo "not found: $IN" >&2; exit 1; }
SYSID="$2"
COREID="${3:-$SYSID}"
OUT="${4:-$(basename "$IN").relic}"

echo "Sealing: $IN (sysid=$SYSID coreid=$COREID) -> $OUT"
printf '%s\n%s\n%s\n' "$IN" "$SYSID" "$COREID" | "$BIN" > "$OUT"
SZ=$(wc -c < "$OUT" | tr -d ' ')
echo "Done: $OUT ($SZ bytes)"
