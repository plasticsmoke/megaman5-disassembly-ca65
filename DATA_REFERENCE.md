# Mega Man 5 — Data Reference

Addresses, table formats, and IDs for ROM hackers, as established by
the annotated disassembly. `$XX:YYYY` = PRG bank `$XX` at CPU address
`$YYYY`. File offset of a byte = `16 + bank*$2000 + (addr - base)`
where `base` is the bank's mapped address (`$8000`, `$A000`, or
`$C000` — see `cfg/nes.cfg`). See ENGINE.md for how these systems
work.

**SKELETON** — sections below are placeholders, filled in as the
disassembly establishes each table and format.

## Table of Contents

1. Quick Reference
2. Bank Map
3. Zero Page
4. RAM Map
5. Entity Arrays
6. Entity Type Catalog
7. Stages and Bosses
8. Player States and Sub-types
9. Weapons
10. Damage Tables
11. Stage Data Format
12. Spawn Lists
13. CHR-RAM Streaming Data
14. Animation and Sprite Data
15. Sound Engine Reference
16. Password System
17. Fixed-Bank Tables
18. Fixed-Bank API

*(Sections not listed below are TBD.)*

## 7. Stages and Bosses

Stage id = stage bank number (zp `$26`). The stage-select grid maps to
banks via `$17:8DA4` (row-major 3×3: `$02 $00 $07 / $05 [castle] $06 /
$01 $04 $03`). Weapon-get text per stage sits at `$17:8F07` (offsets
`$17:8EFF`).

Boss fights are run by **type `$B3`, the boss-room director**
(`$0A:A2B3`): each stage's spawn list places one on the boss-room
screen; after the intro drop it morphs itself into the real boss using
the per-stage tables at `$0A:A3B4-$A3EF` (landing Y, intro anim end
frame, boss sub_type / entity type / shape — indexed by stage bank, or
by screen `& 7` in boss-rush stage `$0E`).

| stage bank | stage | weapon got | boss | boss type | boss AI |
|---|---|---|---|---|---|
| `$00` | Gravity Man | Gravity Hold | Gravity Man | `$81` | `$07:A000` |
| `$01` | Wave Man | Water Wave | Wave Man | `$86` | `$07:A45B` |
| `$02` | Stone Man | Power Stone | Stone Man | `$69` | `$06:A000` |
| `$03` | Gyro Man | Gyro Attack + Rush Jet | Gyro Man | `$6E` | `$06:A455` |
| `$04` | Star Man | Star Crash + Super Arrow | Star Man | `$8D` | `$08:A1CE` |
| `$05` | Charge Man | Charge Kick | Charge Man | `$6B` | `$06:A1F8` |
| `$06` | Napalm Man | Napalm Bomb | Napalm Man | `$89` | `$08:A000` |
| `$07` | Crystal Man | Crystal Eye | Crystal Man | `$83` | `$07:A290` |
| `$08` | Proto castle 1 | — | Dark Man 1 | `$96` | `$09:A2EB` |
| `$09` | Proto castle 2 | — | Dark Man 2 | `$91` | `$09:A05C` |
| `$0A` | Proto castle 3 | — | Dark Man 3 | `$93` | `$09:A12F` |
| `$0B` | Proto castle 4 | — | Dark Man 4 | `$98` | `$09:A405` (spawn: type `$A2` `$03:A000`) |
| `$0C` | Wily 1 | — | Big Pets (director `$4F` + rows `$7A`×2 + body `$71`) | `$4F` | `$02:A000` |
| `$0D` | Wily 2 | — | Circring Q9 | `$7C` | `$02:A291` |
| `$0E` | Wily 3+4 | — | boss rush (screens `$08-$0F`, pods `$AF`) + Wily Press | `$A0` | `$02:A61A` |

The eight robot masters' AI is packed into banks `$06-$08`, the four
Dark Men into bank `$09` — a stage bank's `$A000-$A7FF` region hosts
whatever AI the game needed room for, not necessarily its own stage's.
Per-type AI bank routing is `bhv_bank_tbl` (`$1C:86C3`); entry PCs are
`bhv_pc_lo/hi_tbl` (`$1C:88C3/$8993`).

Boss-beaten state: bitmap `$6E` (bit = stage `& 7` via mask table
`$F2B2`); `stage_alt_bank_tbl` (`$1E:D4C2`) maps stage → alternate
data bank (identity except `$0B→$08`, `$0F→$0E`; `$00` = Gravity is
the zero entry the boss director uses to detect the ceiling-entry
fight).
