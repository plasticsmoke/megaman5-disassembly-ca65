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
Reset `$FE00`, IRQ `$C149` there) — the same Capcom engine lineage,
adapted for CHR-ROM.

Confirmed so far (initial fixed-bank survey; addresses to be
re-verified during annotation):

- **Task scheduler** at `$FEAB` — task records of stride 4 at
  `$80-$8F` (state / arg / saved SP), `$91` = current task, task
  create at `$FEF3` (pointer in `$93/$94`), frame-wait yield at
  `$FF22` (state 1; NMI decrements the counter and wakes to state 4).
- **NMI** (`$C000`): writes CHR regs R0-R5 from zp shadows `$EA-$EF`
  every frame (palette/tile animation by CHR banking), scroll from
  `$A4/$A2` (or `$78` in mode 4), PPUMASK shadow `$FE`, PPUCTRL
  `$A5 | $FF`, MMC3 IRQ latch from `$9C`, then steps waiting tasks.
- **IRQ** (`$C169`): dispatched through per-game-mode vector tables
  at `$C280/$C288` (8 modes).
- **Bank switching**: banks swap as 16KB pairs — `$FF3D` maps bank A
  at `$8000` (R6) and A+1 at `$A000` (R7); `$FF43` re-maps from the
  zp shadows `$F5/$F6`. `$F2` = MMC3 bank-select shadow, `$F7` =
  nesting counter, `$F8` = pending-sound flag. Mirroring control at
  `$FFB7` (write to `$A000`).
- **Stage banks**: zp `$26` holds the current stage bank (written to
  `$F6` → mapped at `$A000`); `$27` = alternate/second stage bank for
  cross-bank reads. Menus and cutscene screens are pseudo-stages
  (e.g. bank `$10`).
- **Sound**: banks `$18/$19` at `$8000/$A000`; driver jump table
  `$8000` = per-frame update, `$8003` = play sound id. 8-entry sound
  queue at `$DC-$E3` (`$88` = empty slot, index `$DB`), pumped from
  the bank-switch path when `$F8` is set.

*(Remaining sections TBD.)*
