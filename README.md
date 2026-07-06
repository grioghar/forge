# Forge

A native, cross-platform retro-console emulator suite written in
[Sigil](https://github.com/grioghar/sigil). Every core, tool, and (as of
v0.1.0) GUI is compiled Sigil — no Python, no bundled emulator cores from
other projects.

## What's here

- **`play/`** — ported emulator cores (Game Boy, Game Boy Advance, SNES,
  Genesis, 32X, Game Gear, Virtual Boy, Famicom Disk System, Neo Geo Pocket
  Color, WonderSwan), each verified via a deterministic hand-assembled boot
  test plus a controller-input test.
- **`app/`** — the Forge Complete catalog/launcher (terminal picker) and, as
  of v0.1.0, the first native Cocoa GUI (`forge_gui.sg`): a real `NSWindow`
  with one button per verified system, launching each via `NSTask` — no
  shell scripts in the launch path.
- **`tools/`** — ANVIL, the relic sealer: packages a ROM into a RELIC-V2
  container (sha256 + crc32 verified, native-macOS-optimized).
- **`pal.sg`** / **`pal_macos.sg`** / **`pal_linux.sg`** / **`pal_windows.sg`**
  — the platform-abstraction layer for the cross-platform native port track.
- **`install/`** — per-OS installers for the CLI build.

## Status (v0.1.0)

This is an early, actively-developing snapshot. The GUI (`forge_gui.sg`) is
a working prototype, not yet packaged as a real `.app` bundle — that's the
next milestone. See each source file's header comments for what's verified
vs. known-limitation.

Built on real Cocoa/AppKit FFI added to the Sigil compiler itself
([sigil#188](https://github.com/grioghar/sigil/pull/188)) — Sigil had no way
to call external dylibs/frameworks before this; the launcher GUI is the
first real user of that capability.
