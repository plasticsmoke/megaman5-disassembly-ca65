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
| `$00-$1D` | *to be classified* (stage data, entity AI, animation data, sound engine, game engine code) |
| `$1E/$1F` | fixed bank at `$C000-$FFFF` (NMI/IRQ/RESET, core engine) |
| CHR `$00-$1F` | 32 x 8KB CHR-ROM banks (tiles, banked via MMC3 R0-R5) |

*(Bank map to be filled in as classification proceeds.)*

## Engine architecture

*To be documented as tracing proceeds. Vectors: NMI = `$C000`,
Reset = `$FE00`, IRQ = `$C169` — nearly identical entry points to
MM4's fixed bank, so the MM4-lineage engine is expected: cooperative
task scheduler, NMI-driven PPU upload pipeline, MMC3 scanline-IRQ
splits, struct-of-arrays entity system, behavior-interpreter AI, and
a banked music/SFX driver — with CHR-ROM banking replacing MM4's
CHR-RAM streaming. All to be verified against MM5 code.*

## Project structure

```
src/
  header.asm                  iNES header (Mapper 4 / MMC3, 256KB PRG + 256KB CHR)
  bank00-bank1D.asm           swappable 8KB PRG banks (raw dumps, being classified)
  fixed_bank.asm              fixed bank $1E/$1F ($C000-$FFFF)
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

## License

MIT License. See [LICENSE](LICENSE) for details.

This is a disassembly — the original game is copyrighted by Capcom.
This project provides only the annotated assembly source. No ROM data
is included.
