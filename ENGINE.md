# Mega Man 5 — Engine Architecture

A walkthrough of the game engine as established by the annotated
disassembly. Addresses are CPU addresses; `$XX:YYYY` means PRG bank
`$XX` mapped at CPU address `$YYYY`. Named variables refer to
`include/zeropage.inc` / `include/constants.inc`; named routines to
`include/fixed_bank.inc`.

**SKELETON** — sections below are placeholders, filled in as tracing
confirms each system. Section list mirrors the MM4-lineage engine and
will be adjusted to match what MM5 actually does.

## Table of Contents

1. Hardware Overview
2. Memory Map
3. Boot and the Game Loop
4. NMI and the PPU Update Pipeline
5. IRQ Scanline Splits
6. Bank Switching
7. Entity System
8. Entity AI
9. Animation and Sprite Rendering
10. Damage Engine
11. Entity Physics
12. Tile Collision
13. Player State Machine
14. Weapon System
15. Camera, Sections and Scrolling
16. CHR Banking
17. Spawn Engine
18. Sound Engine
19. Password System
20. Tricks and Curiosities

---

## 1. Hardware Overview

| Property | Value |
|----------|-------|
| CPU | Ricoh 2A03 (MOS 6502 core, no BCD) |
| Mapper | MMC3 (iNES mapper 4) |
| PRG ROM | 256 KB — 32 × 8 KB banks (`$00-$1F`) |
| CHR | 256 KB CHR-ROM — 32 × 8 KB banks (MMC3 R0-R5) |
| Fixed banks | `$1E` at `$C000` + `$1F` at `$E000` (always mapped) |
| Switchable | MMC3 R6 → `$8000-$9FFF`, R7 → `$A000-$BFFF` |
| Vectors | NMI = `$C000`, Reset = `$FE00`, IRQ = `$C169` |

Unlike MM4 (CHR-RAM, tiles streamed through `$2007`), MM5 uses
CHR-ROM: the MMC3 CHR banking registers select tile banks directly.
Vector entry points nearly match MM4's fixed bank (NMI `$C000`,
Reset `$FE00`, IRQ `$C149` there) — the engine is expected to be the
same Capcom lineage, adapted for CHR-ROM.

*(Remaining sections TBD.)*
