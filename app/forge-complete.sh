#!/bin/sh
# forge/app/forge-complete.sh — Forge Complete launcher (macOS arm64).
#
# Runs the catalog picker (forge/dist/forge-complete-macos-arm64). CHIP-8 (12)
# plays interactively in that same process. For the 5 VERIFIED engines, cc0
# has no dynamic linking and several engines share function names across
# systems (e.g. Genesis's and Game Gear's own copies of cores/psg.sg both
# define psg_st/psg_write/etc, with no per-file namespacing) — so each
# verified core ships as its OWN binary, and the picker returns the chosen
# catalog sysid as its exit code. This script reads that and execs the
# matching binary: one process per core, the same shape real multi-core
# frontends use.
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
DIST="$REPO/forge/dist"

# NOTE: deliberately no `set -e` — the picker's exit code IS the dispatch
# signal (the chosen catalog sysid), so a "successful" pick returns non-zero
# on purpose; `set -e` would abort the script right there before it could act.
"$DIST/forge-complete-macos-arm64"
CODE=$?

case "$CODE" in
  25) exec "$DIST/forge-gb-boot-test-macos-arm64" ;;
  26) exec "$DIST/forge-gba-boot-test-macos-arm64" ;;
  62) exec "$DIST/forge-vb-boot-test-macos-arm64" ;;
  22) exec "$DIST/forge-fds-boot-test-macos-arm64" ;;
  58) exec "$DIST/forge-snes-input-test-macos-arm64" ;;
  28) exec "$DIST/forge-genesis-boot-test-macos-arm64" ;;
  53) exec "$DIST/forge-s32x-boot-test-macos-arm64" ;;
  24) exec "$DIST/forge-gamegear-boot-test-macos-arm64" ;;
  42) exec "$DIST/forge-ngpc-boot-test-macos-arm64" ;;
  69) exec "$DIST/forge-ws-boot-test-macos-arm64" ;;
  *) exit "$CODE" ;;
esac
