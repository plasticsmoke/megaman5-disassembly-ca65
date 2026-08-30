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
13. CHR Animation
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
| `$0E` | Wily 3 | — | boss rush (screens `$08-$0F`, pods `$AF`) + Wily Press | `$A0` | `$02:A61A` |
| `$0F` | Wily 4 | — | Wily Machine `$A5`→`$A9`, then Wily Capsule `$AA` (scr `$07`); ending-scene Wily `$B9` (scr `$0A`) | `$A5` | `$04:A000` |

Stage `$0F` maps PRG bank `$0F` at `$A000` (stage data only — its AI
lives in banks `$04`/`$0D`); its alternate bank is `$0E`. Fortress
boss deaths chain through `death_transform_tbl` (`$1C:87C3`): robot
masters and Dark Men → `$B4` (weapon-get/boss-death director), Big
Pets `$4F` → `$AD`, water giant `$44` → `$AE`, Circring `$7C` → `$AD`,
Wily Press `$A0` → `$AC`, Wily Machine `$A5` → `$A9` (explosion) →
`$AA` (Wily Capsule) → `$C0` (Wily escape) — the `$AC`/`$AD`/`$AE`/`$B4`/
`$C0` directors all live in bank `$0A`.

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

## 8. Player States and Sub-types

`player_state $30` dispatches through `$1B:8045/$8069` (36 handlers;
one header block per state in `src/bank1B.asm`):

| State | Meaning | State | Meaning |
|---|---|---|---|
| `$00` | ground | `$0D` | jetski mount |
| `$01` | air | `$0E` | jetski dock |
| `$02` | slide | `$0F` | victory orbs |
| `$03` | ladder | `$10` | teleport-out |
| `$04` | jetski ride | `$11` | walk-to-mark |
| `$05` | nop | `$12` | cutscene pose |
| `$06` | hurt | `$13` | drop-in + restore |
| `$07` | dead | `$14` | castle clear |
| `$08` | teleport-in | `$15/$16` | warp depart/arrive |
| `$09` | carried off | `$17` | rematch won |
| `$0A` | re-enter top | `$18` | boss defeated |
| `$0B` | carried path | `$19` | stand frozen |
| `$0C` | nop | `$1C-$23` | ending choreography |

States `$07/$10/$23` double as the game-flow selector read by the
bank `$17` hub (death / stage clear / ending).

## 9. Weapons

`cur_weapon $32`; fire dispatch `$1B:9571/$9581`; energy meters
`$B0+id` (bit 7 = owned, `$9C` = owned + full 28), cost via
`weapon_deduct $1B:953D`.

| ID | Weapon | ID | Weapon |
|---|---|---|---|
| `$0` | Power Buster | `$7` | Gravity Hold |
| `$1` | Water Wave | `$8` | Charge Kick |
| `$2` | Gyro Attack | `$9` | Star Crash |
| `$3` | Crystal Eye | `$A` | Rush Coil |
| `$4` | Napalm Bomb | `$B` | Rush Jet |
| `$5` | Super Arrow | `$C` | Beat |
| `$6` | Power Stone | | |

Buster charge level in `$5B` (`>= $0E` = full; shot sub_types
`$18/$A8/$A9`). Beat is granted by items mask `$6D = $FF`
(password or castle progress). Rush/Beat ride via `ride_slot $37`.

## 10. Damage Tables

Weapon N's per-enemy-type damage table is at `$A800` **in PRG bank
N** — the weapon id doubles as the bank number (`$1C:809D` maps
`$32` into `$F6`). Entry = `$A800[ent_type]`; low 7 bits = damage,
bit 7 = special handling (weapons `$1/$9`: instant kill/capture
classes). Zero = ricochet (shot becomes type `$46`). Buster damage
comes from the charge level instead (1/2/3, `$1C` tables).

## 11. Stage Data Format

Each stage's data bank id equals its stage id (`$26`); the bank is
mapped at `$A000` (`screen_layout_ptr`, `$1E:D7A3`). The `$A000-$A8FF`
region is *not* stage data — it hosts AI/menu/cutscene code per the
bank map. Layout (as mapped at `$A000`):

| Range | Contents |
|---|---|
| `$A900-$A94E` | Screen → layout index |
| `$A950-$A967` | Section list: start screen (bits 0-4) + flags (bits 5-7) |
| `$A968-$A97F` | Per-section attributes (bit 7 = vertical-scroll room) |
| `$A980/$A981` | BG CHR banks (MMC3 R0/R1 → `$EA/$EB`) |
| `$A988-$A997` | 16 BG palette bytes |
| `$A998-$A99B` | Sprite palette-cycle seeds → `$05F0` |
| `$A9E0+` | Screen links: `[screen, Y band, dest screen, dest section]`, bit 7 ends |
| `$AA00-$AB7F` | Spawn lists: screen / X / Y arrays (`$A9FF` = -1 base) |
| `$AB80-$ABFF` | Spawn codes ([section 12](#12-spawn-lists)) |
| `$AC00-$ACFF` | Per-screen spawn-list start index |
| `$AD00-$B0FF` | Metatile 2×2 tile ids: TL / BL / TR / BR planes (256 each) |
| `$B100-$B1FF` | Metatile attribute: palette (bits 0-1) + collision (high nibble) |
| `$B200-$B5FF` | 32-px block definitions: 4 metatile ids each |
| `$B600+` | Screen layouts: 64 block ids (8×8), ptr = `$B600 + layout*64` |

Collision comes from the `$B100` high nibble (`$20` solid; `$40`
ladder — treated as solid by vertical probes; player latches types
`>= $D0`, spikes, into `$36`).

The **alternate bank** `$27` splits art from screen lists: the screen
table and layout pointer are read from `$26`'s bank, but block defs
and metatiles are read with `$27`'s bank mapped (`block_ptr_setup`,
`$1E:D758`). `stage_alt_bank_tbl` (`$1E:D4C2`) is identity except
`$0B→$08`, `$0F→$0E`; boss-rush stage `$0E` picks a bank per screen
(`stage0E_screen_banks`, `$1E:D793`). The menus draw as pseudo-stage
`$26=$10` with `$27` = `$10` (title), `$0F` (stage select/password),
`$0B` (story intro) or `$11` (castle maps).

## 12. Spawn Lists

Four parallel arrays per stage ([section 11](#11-stage-data-format)),
sorted by screen, cursors seeded from `$AC00[screen]` (`spawn_engine`,
`$1B:988A`). Codes:

- `< $C0` — enemy id: type, sub-type, shape, flags, HP and a speed row
  come from bank `$1B`'s parallel parameter tables (entry `$1B:9995`);
  the spawn code is kept in `ent_spawn_idx` (`$0510`), and killed
  enemies set their bit in the `$0100` no-respawn bitmap.
- `>= $C0` — palette / CHR-anim command (`$1B:9933+`): slot < `$10`
  writes a palette command into PAL_BUF, otherwise starts a
  palette-cycle program slot (`$05F0+`) or the background CHR-anim
  program (`$05D0`).

## 13. CHR Animation (no CHR-RAM)

MM5 is CHR-ROM; all "animation" is bank cycling. Background CHR-anim
programs live in the fixed bank (`$1E:DDB3+` step/period/slot tables,
run from the NMI tail `$1E:DB97`) and rewrite `$EA-$EF` (MMC3 R0-R5
shadows). Palette-cycle programs (`$1E:DD01+`) run beside them from
the `$05F0` slots. Sprite CHR is per-animation-frame: each sprite
record names the CHR bank and which R2-R5 slot it loads
([section 14](#14-animation-and-sprite-data)).

## 14. Animation and Sprite Data

Anim bank pairs (`anim_bank_tbl` `$1E:E33B`[type] → `$12/$13`,
`$14/$15`, `$16/$17`; `$17` doubles as the menus bank, pair 3's
records stay in `$16`). Index tables in the `$8000` half:

| Table | Contents |
|---|---|
| `$8600/$8700` | sub-type → anim descriptor pointer lo/hi |
| `$8000/$8200` | frame id → sprite record pointer lo/hi (normal) |
| `$8100/$8300` | sprite record pointer lo/hi (h-flipped) |
| `$8400/$8500` | position-set pointer lo/hi (used at −3) |

Formats (`entity_render_visible`, `$1E:E08F`):

- **Descriptor**: `[frame count (bit 7 flag), frame duration, frame id
  per phase...]` — `$0570` counts the duration, `$0540` the phase;
  frame id `$00` despawns/ends.
- **Sprite record**: `[CHR bank, sprite count, position-set index,
  then per sprite: tile, attr...]` — byte 3's high bits pick which
  sprite CHR slot (R2-R5) receives the bank.
- **Position set**: per-sprite offset pairs added to the entity's
  screen position; off-screen results hide that sprite.

## 15. Sound Engine Reference

Driver = bank `$18` at `$8000`, data = bank `$19` at `$A000` spilling
into bank `$1A` (fetched as virtual `$C000-$DFFF`). Entry points
`$8000` = per-frame update, `$8003` = play id in A (via the fixed
bank's queue pump, `$1E:FF68`). 76 ids (`snd_song_count` `$18:8A40`),
directory at `$18:8A43` (hi/lo per entry); an entry's first byte is
its priority — `$00` = music, nonzero = SFX (b7 uninterruptible,
b6 chained). Control ops `$F0-$F7`: stop all / stop SFX / stop music /
pause / resume / fade speed / fade variant / SFX pitch offset.
Instruments: 8-byte records at `$18:8ADB` (envelope rates + sustain,
env speed, vibrato, tremolo, duty/noise mode). Track bytes < `$20`
are opcodes (tempo, gate, octave, transposes, 4 nested loops,
instrument, vibrato, portamento, duty, end); `>= $20` = length index
(bits 5-7, straight/dotted) | note (bits 0-4, 0 = rest). Channel
order noise/tri/pulse2/pulse1; SFX state block `$0700+ch`, music
`$0728+ch`. Full details in the bank `$18` source header.

## 16. Password System

6 dots on the 6×6 grid (A-F rows × 1-6 columns): exactly 3 red + 3
gray. The dots split into three groups (tables `$17:90E0+`); each
group's red-dot cell encodes 3 bits of `$6E` (bosses beaten) and its
gray-dot cell 3 bits of `$6D` (items — `$FF` grants Beat). When a red
and gray dot share a cell the gray uses the shifted-row cell list
(`$17:90FB`). Weapons granted per `$6E` bit via `$17:9111/$9112`
(energy `$9C` = owned + full). Encode (display) `$17:87B9`, decode
(validate) `$17:86AB`.
