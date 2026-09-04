# Mega Man 5 (U) — annotated ca65 disassembly

A byte-perfect, fully annotated disassembly of *Mega Man 5* (USA) for
the NES, buildable with cc65's `ca65`/`ld65`.

The build is byte-perfect and every bank is annotated: the core engine
(`$1B-$1D` + fixed bank), all stage AI, menus/title, the ending, the
sound driver, the bank `$00` section-environment service and the bank
`$01` pause/weapon menu, plus the stage/animation/sound data formats.
All data regions are structured `.byte` tables with section banners
(stage data, damage tables, animation/sound data, fixed-bank tables).
The architecture is written up in ENGINE.md and the data formats in
DATA_REFERENCE.md, with the documented claims verified against the
code by adversarial audit passes.

Built with [Claude Code](https://claude.com/claude-code) — starting
from raw disassembler output through label naming, constant
extraction, code/data verification, annotation, and from-scratch
adversarial audits.

Anyone familiar with Mega Man 5's internals, NES development, or
MMC3 mapper conventions is welcome to double-check the annotations
and file corrections or improvements.

For a walkthrough of the game engine, see **[ENGINE.md](ENGINE.md)**.
For data tables, addresses, formats, and ROM hacking reference —
see **[DATA_REFERENCE.md](DATA_REFERENCE.md)**.

## Building

```
make
```

Requires `ca65`/`ld65` and the original ROM as `mm5.nes` in the project
root (not included). The build extracts `chr/chr.bin` (the ROM's CHR
half) from it, assembles all banks, links via `cfg/nes.cfg`, and
byte-compares the result against `mm5.nes` —
`BUILD VERIFIED: byte-perfect match!` means the sources exactly
reproduce the original ROM.

## ROM layout

524,304 bytes: 16-byte iNES header + 256KB PRG + 256KB CHR-ROM.
Mapper 4 (MMC3), 32 x 8KB PRG banks — unlike MM4's CHR-RAM board,
MM5 returns to CHR-ROM with MMC3 CHR banking (as in MM3):

| banks | contents |
|---|---|
| `$00-$0D` | stage banks at `$A000`: AI code `$A000-$A7FF` + one weapon's damage table (`$A800`) + stage data (`$A900+`). Stages: `$00` Gravity, `$01` Wave, `$02` Stone, `$03` Gyro, `$04` Star, `$05` Charge, `$06` Napalm, `$07` Crystal, `$08-$0B` Proto castle 1-4, `$0C-$0D` Wily 1-2. Bank `$00` also hosts the per-section environment service, `$01` the pause menu, `$0B` stage-load support (all at `$8000`) |
| `$0E/$0F` | stage `$0E` = Wily 3 (boss rush teleporters + Wily Press) + ending / cutscene flow (`$0E:A000` entry); stage `$0F` = Wily 4 stage data + the credits text at `$8000` (Wily Machine/Capsule AI in banks `$04`/`$0D`) |
| `$10/$11` | pseudo-stage screen data: menus/ending (`$10`) and castle-map art (`$11`), each fronted by an unreferenced 2 KB bit table |
| `$12/$13` | animation data pair 1 (index tables at `$8000` + records at `$A000`) |
| `$14/$15` | animation data pair 2 (same structure) |
| `$16` | animation data pair 3 (`$17` is its formal `$A000` partner; the records all stay in `$16`) |
| `$17` | game-flow hub: title / menus / stage select / password / castle maps |
| `$18` | sound driver (`$8000` update / `$8003` play) |
| `$19/$1A` | sound data (`$1A` is read through a virtual `$C000-$DFFF` window) |
| `$1B` | player state machine + weapons (`$8000`); spawn engine at `$988A` |
| `$1C` | behavior engine, damage engine and shared AI (69 entity types run here) |
| `$1D` | generic enemy / pickup / effect AI (`$A000`, 54 entity types) |
| `$1E/$1F` | fixed bank at `$C000-$FFFF` (NMI/IRQ/RESET, scheduler, core engine) |
| CHR `$00-$1F` | 32 x 8KB CHR-ROM banks (tiles, banked via MMC3 R0-R5) |

The full per-bank map is DATA_REFERENCE.md section 2.

## Engine architecture

MM4's engine adapted for CHR-ROM (vectors: NMI `$C000`, Reset `$FE00`,
IRQ `$C169`). In brief — see [ENGINE.md](ENGINE.md):

**Scheduler.** A 4-slot cooperative multitasker (`$FEAB`); tasks yield
via `frame_wait` (`$FF22`). Task 0 = player (pause menu, gameplay
frame), task 1 = permanent service (LFSR RNG + HUD/palette upkeep),
task 2 = game orchestrator (menus → stage load → spawn task 0).

**NMI/IRQ.** NMI (`$C000`) does OAM DMA, nametable/palette buffer
flushes, writes the six CHR bank registers from zp shadows (`$EA-$EF`)
— CHR animation is bank cycling — and arms the MMC3 scanline IRQ.
IRQ (`$C169`) dispatches through per-game-mode vectors (`$C280/$C288`,
8 modes) for status bars and multi-way splits.

**Entities.** 24 slots (0 = player), struct-of-arrays at `$0300+`,
stride `$18` (MM4's exact layout). Behavior engine at `$1C:8000`:
per-type coroutine AI (resumable behavior PC), dispatched into bank
`$1D` or the entity's own stage bank at `$A000`. Rendering (`$DF5E`)
alternates iteration order per frame and lets sprite records claim
CHR banks in the four 1KB MMC3 sprite slots — first claimant wins.

**Stages.** Screen → layout (`$A900`/`$B600`, 8×8 blocks) → 32px
block defs (`$B200`) → metatiles (`$AD00-$B0FF`, attribute+collision
at `$B100`). Sections with 4px/frame camera-slide transitions; the
gameplay frame runs `$1B:8000` (player/weapons), `$1C:8000`
(behaviors), scroll update, then the spawn engine (`$1B:988A`).

## Project structure

```
src/
  header.asm                  iNES header (Mapper 4 / MMC3, 256KB PRG + 256KB CHR)
  bank00-bank1D.asm           swappable 8KB PRG banks: annotated code with per-line
                              address/byte comments; data regions as labelled .byte
                              tables under section banners
  fixed_bank.asm              fixed bank $1E/$1F ($C000-$FFFF), annotated
  chr.asm                     CHR ROM (.incbin of chr/chr.bin, extracted by make)
include/
  hardware.inc                NES hardware registers (PPU, APU, MMC3)
  zeropage.inc                zero-page variable definitions
  constants.inc               entity arrays, button masks, RAM buffers
  fixed_bank.inc              named fixed-bank entry points (cross-bank API)
cfg/
  nes.cfg                     ld65 linker config (per-bank base addresses)
Makefile                      build + byte-perfect verification
```

## Curiosities found along the way

- A **leftover debug task** in the fixed bank (`$E43B`): controller 2
  DOWN toggles inverted gravity on the player, controller 2 A skips to
  the next stage. Doubly disabled in retail — its spawn call was
  removed *and* `read_controllers` zeroes pad 2 every frame.
- The **boss-rush teleporter room** (stage bank `$0E`) shows each robot
  master's scenery by borrowing *other stages' banks* per screen via a
  16-entry table (`stage0E_screen_banks`).
- **Weapon damage tables are addressed by bank number**: weapon N's
  per-enemy damage bytes sit at `$A800` of PRG bank N — the stage
  banks double as damage-table hosts, and the damage engine just
  writes the weapon id into the MMC3 bank register.
- Sprite tile banks are claimed **per frame, per entity**: each sprite
  record names a CHR bank + 1KB slot (MMC3 R2-R5); first claimant wins,
  later entities needing a different bank in the same slot simply don't
  render that frame.
- **The M-tank pays out a 1-UP**: using one while every owned meter is
  already full runs bank `$08`'s pickup sweep and, if the screen is
  clear, grants an extra life — an easter egg in the pause menu.

## License

MIT License. See [LICENSE](LICENSE) for details.

This is a disassembly — the original game is copyrighted by Capcom.
This project provides only the annotated assembly source. No ROM data
is included.
