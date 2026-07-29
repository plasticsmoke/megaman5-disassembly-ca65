# Mega Man 5 (U) — annotated ca65 disassembly

A byte-perfect, fully annotated disassembly of *Mega Man 5* (USA) for
the NES, buildable with cc65's `ca65`/`ld65`.

**Work in progress** — the skeleton builds byte-perfect from raw bank
dumps; code/data classification, label naming, and annotation are
underway. The goal matches the sibling projects: every line of 6502
code carrying an inline comment, every routine a header, and every
data bank converted to structured `.byte` form with its format
documented in place.

Built with [Claude Code](https://claude.com/claude-code) — starting
from raw disassembler output through label naming, constant
extraction, code/data verification, annotation, and a from-scratch
adversarial audit.

Anyone familiar with Mega Man 5's internals, NES development, or
MMC3 mapper conventions is welcome to double-check the annotations
and file corrections or improvements.

For a walkthrough of the game engine, see **[ENGINE.md](ENGINE.md)**
(skeleton). For data tables, addresses, formats, and ROM hacking
reference — see **[DATA_REFERENCE.md](DATA_REFERENCE.md)** (skeleton).

## Building

```
make
```

Requires `ca65`/`ld65` and the original ROM as `mm5.nes` in the project
root (not included; `tools/split_rom.py` extracts `chr/chr.bin` from
it). The build assembles all banks, links via `cfg/nes.cfg`, and
byte-compares the result against `mm5.nes` —
`BUILD VERIFIED: byte-perfect match!` means the sources exactly
reproduce the original ROM.

## ROM layout

524,304 bytes: 16-byte iNES header + 256KB PRG + 256KB CHR-ROM.
Mapper 4 (MMC3), 32 x 8KB PRG banks — unlike MM4's CHR-RAM board,
MM5 returns to CHR-ROM with MMC3 CHR banking (as in MM3):

| banks | contents |
|---|---|
| `$00-$0D` | stage banks at `$A000`: stage data + that stage's enemy AI (bank `$00` also hosts a per-frame engine service, `$01` the pause menu at `$8000`) |
| `$0E-$11` | code + screen/data banks (menus, cutscene screens — being classified) |
| `$12/$13` | animation data pair (descriptors at `$8000` + records at `$A000`) |
| `$14/$15` | animation data pair (probable — same paired-pointer structure) |
| `$16` | data (being classified) |
| `$17` | title / menus / stage select + stage→bank directory |
| `$18/$19` | sound engine (`$8000` update / `$8003` play) + sound data |
| `$1A` | data incl. text (being classified) |
| `$1B` | player state machine + weapons (`$8000`); spawn engine at `$988A` |
| `$1C` | behavior engine: per-type AI dispatch (coroutines via behavior PC) |
| `$1D` | generic enemy AI bank (`$A000`, 123 entity types) |
| `$1E/$1F` | fixed bank at `$C000-$FFFF` (NMI/IRQ/RESET, scheduler, core engine) |
| CHR `$00-$1F` | 32 x 8KB CHR-ROM banks (tiles, banked via MMC3 R0-R5) |

*(Provisional — classification in progress; per-bank contents firm up
as annotation proceeds.)*

## Engine architecture

MM4's engine adapted for CHR-ROM (vectors: NMI `$C000`, Reset `$FE00`,
IRQ `$C169`). Established so far — see [ENGINE.md](ENGINE.md):

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
  bank00-bank1D.asm           swappable 8KB PRG banks — code banks as raw da65
                              disassembly (annotation in progress), data banks
                              ($0B, $0F-$16, $19, $1A) as .byte dumps
  fixed_bank.asm              fixed bank $1E/$1F ($C000-$FFFF), da65 disassembly
  chr.asm                     CHR ROM (.incbin of chr/chr.bin, extracted from ROM)
include/
  hardware.inc                NES hardware registers (PPU, APU, MMC3)
  zeropage.inc                zero-page variable definitions (populated during tracing)
  constants.inc               game constants (populated during tracing)
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
- Sprite tile banks are claimed **per frame, per entity**: each sprite
  record names a CHR bank + 1KB slot (MMC3 R2-R5); first claimant wins,
  later entities needing a different bank in the same slot simply don't
  render that frame.

## License

MIT License. See [LICENSE](LICENSE) for details.

This is a disassembly — the original game is copyrighted by Capcom.
This project provides only the annotated assembly source. No ROM data
is included.
