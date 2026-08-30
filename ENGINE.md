# Mega Man 5 — Engine Architecture

A walkthrough of the game engine as established by the annotated
disassembly. Addresses are CPU addresses; `$XX:YYYY` means PRG bank
`$XX` mapped at CPU address `$YYYY`. Named variables refer to
`include/zeropage.inc` / `include/constants.inc`; named routines to
`include/fixed_bank.inc`.

## Table of Contents

1. Hardware Overview
2. Memory Map
3. Boot and the Task Scheduler
4. NMI and the PPU Update Pipeline
5. IRQ Scanline Splits
6. Bank Switching
7. The Frame: Game Loop Phases
8. Entity System
9. Behavior Engine (Entity AI)
10. Animation and Sprite Rendering
11. Damage Engine
12. Entity Physics
13. Tile Collision
14. Player State Machine
15. Weapon System
16. Camera, Sections and Scrolling
17. CHR Banking and Animation
18. Spawn Engine
19. Game Flow, Menus and Cutscenes
20. Sound Engine
21. Password System
22. Tricks and Curiosities

---

## 1. Hardware Overview

| Property | Value |
|----------|-------|
| CPU | Ricoh 2A03 (MOS 6502 core, no BCD) |
| Mapper | MMC3 (iNES mapper 4) |
| PRG ROM | 256 KB — 32 × 8 KB banks (`$00-$1F`) |
| CHR | 256 KB CHR-ROM — banked via MMC3 R0-R5 |
| Fixed banks | `$1E` at `$C000` + `$1F` at `$E000` (always mapped) |
| Switchable | MMC3 R6 → `$8000-$9FFF`, R7 → `$A000-$BFFF` |
| Vectors | NMI = `$C000`, Reset = `$FE00`, IRQ = `$C169` |

Unlike MM4 (CHR-RAM, tiles streamed through `$2007`), MM5 uses
CHR-ROM: the MMC3 CHR banking registers select tile banks directly,
and all tile "animation" is bank cycling
([section 17](#17-chr-banking-and-animation)). Vector entry points
nearly match MM4's fixed bank (NMI `$C000`, Reset `$FE00`, IRQ
`$C149` there) — the same Capcom engine lineage, adapted for CHR-ROM.

Mirroring is switched at runtime via `set_mirroring` (`$FFB7`):
1 = horizontal mirroring during horizontal scroll, 0 = vertical
during vertical scroll (single wrapping nametable, seam at the
screen edge).

## 2. Memory Map

| Address | Size | Contents |
|---------|------|----------|
| `$0000-$00FF` | 256 B | Zero page (see `include/zeropage.inc`) |
| `$0100-$01FF` | 256 B | Killed-enemy no-respawn bitmap (`$0100`, cleared by `no_respawn_clear`) + task stacks (SP seeded at `$8F`) |
| `$0200-$02FF` | 256 B | OAM shadow buffer (DMA'd every NMI; menus park persistent tableaux at `$02C0+`) |
| `$0300-$05CF` | 720 B | Entity arrays — stride-`$18` struct-of-arrays (DATA_REFERENCE §5) |
| `$05D0-$05D2` | 3 B | Background CHR-anim program slot (prog/frame/delay) |
| `$05DC-$05DF` | 4 B | Stage event bitmap (collapse director etc.) |
| `$05E0-$05EF` | 16 B | Metatile decode buffer (strip decode output) |
| `$05F0-$05FF` | 16 B | Palette-cycle program slots |
| `$0600-$063F` | 64 B | Palette buffers: `$0600` BG / `$0610` sprite (live), `$0620/$0630` master copy |
| `$0680-$06BF` | 64 B | Destroyed-block bitmap (breakable blocks, per screen parity) |
| `$06C0-$06FF` | 64 B | Dynamic tile-override records |
| `$0700-$077F` | 128 B | Sound driver channel state (SFX `$0700+`, music `$0728+`) |
| `$0780-$07FF` | 128 B | PPU nametable write buffer (`[hi, lo, count, data...]` packets) |
| `$8000-$9FFF` | 8 KB | Switchable window (MMC3 R6) |
| `$A000-$BFFF` | 8 KB | Switchable window (MMC3 R7) |
| `$C000-$FFFF` | 16 KB | Fixed banks `$1E/$1F` |

Zero-page highlights are kept in `include/zeropage.inc`; the game
flow ones worth knowing: `$26/$27` stage bank + alternate art bank,
`$30` player state (doubles as the between-stages flow selector),
`$32` current weapon, `$67/$6E` weapon-got / boss-beaten bitmasks,
`$69` furthest screen reached (checkpoint driver), `$6C` selected
stage, `$6D` items bitmask (Beat), `$6F` castle progress, `$B0-$BC`
weapon energy (bit 7 = owned, `$9C` = owned+full), `$BF` lives.

## 3. Boot and the Task Scheduler

Reset (`$FE00`) clears RAM, seeds the LFSR RNG (`$E4-$E7` = `$88`…),
and spawns **task 2** (`$DDE8`), the game orchestrator, into the
4-slot cooperative scheduler (`$FEAB`; 4-byte records at `$80`,
`frame_wait` yield at `$FF22`, `$FF24` = yield A frames). Game modes
are *task pointers*, not a dispatch table: a task runs until it
yields, and the NMI wakes it after vblank.

- **Task 0** (`$DE70`) — player task: the whole gameplay frame
  ([section 7](#7-the-frame-game-loop-phases)), including the Start
  pause menu (banks `$01/$08`, menu at `$01:8000`).
- **Task 1** (`$DB46`) — permanent background service: steps the
  RNG and runs per-frame HUD/palette/CHR-anim upkeep.
- **Task 2** (`$DDE8`) — orchestrator: title/menus (bank `$17` hub
  at `$8000` with `$0C` at `$A000`), player init, `stage_load`
  (`$D311`), then spawns task 0 and waits for the next flow event.
- **Task 3** — created by game code as needed (bosses/cutscenes).

## 4. NMI and the PPU Update Pipeline

The NMI handler (`$C000`), per frame:

1. **Quick-out paths** — `nmi_quick` (`$95`): scroll+tasks only;
   `nmi_skip` (`$F0`): rendering off, tasks only.
2. **OAM DMA** from `$0200`.
3. **Nametable flushes** — packet buffer `$0780`
   (`nametable_dirty $19`), column/attribute writes in inc-32 mode
   (`nt_column_dirty $1A`), second buffer region
   (`nt_row_dirty $1C`).
4. **Palette upload** — 32 bytes from `$0600` (`palette_dirty $18`).
5. **CHR banks** — MMC3 R0-R5 rewritten from the shadows `$EA-$EF`
   every frame (this is how all tile animation happens).
6. **Scroll + PPUCTRL/PPUMASK** from shadows (`$A2/$A4/$A5`,
   `$FE/$FF`); IRQ latch from `$9B` → `$9C`, game mode `$99` → `$9A`.
7. **Sound trampoline** — the interrupted return address is swapped
   with `$C147` so the music driver runs after the handler exits
   (`saved_pc` `$E8/$E9`).
8. **Task step** — frame-wait counters decrement; expired tasks wake.

Main-thread code never writes the PPU directly during gameplay; it
fills buffers and sets dirty flags.

## 5. IRQ Scanline Splits

IRQ (`$C169`) dispatches through per-game-mode vector tables at
`$C280/$C288` (8 modes, `game_mode $9A`); split parameters live in
`irq_split0-3` (`$78-$7B`), with meanings per mode (X scroll below
the split, PPUADDR seams, next latch value). Splits drive the HUD
bar, vertically split boss arenas, the menus' fixed panels, and the
ending's letterboxed tableaux (mode `$05`).

## 6. Bank Switching

`bank_load_pair` (`$FF3D`) maps bank A at `$8000` (R6) and A+1 at
`$A000` (R7); `bank_load_shadow` (`$FF43`) (re)maps from the zp
shadows `$F5/$F6`. `$F7` counts nesting so an interrupt can't corrupt
a switch; a sound request landing mid-switch sets `$F8` and is pumped
on the way out. Conventions:

- **Stage data**: `$26` → R7 (`screen_layout_ptr`), block/metatile
  art from the alternate bank `$27` (`block_ptr_setup`).
- **Behavior dispatch**: AI bank at `$A000`, bank `$1C` stays at
  `$8000`.
- **Animation**: `anim_bank_tbl[type]` as a 16 KB pair.
- **Sound**: ids queued via `queue_sound` (`$EC5D`) into the ring
  buffer `$DC-$E3`; the fixed-bank pump (`$FF68`) maps `$18/$19`,
  drains the queue into the driver, and restores the previous pair.

## 7. The Frame: Game Loop Phases

One gameplay frame (task 0, `$DE70`):

1. **Pause poll** — Start (unless `pause_lock $54`): map `$01/$08`,
   run the pause/weapon menu at `$01:8000` (sound `$29`).
2. **Player tick** — pair `$1B/$1C`: player state machine
   `$1B:8000`, weapon fire dispatch, i-frames.
3. **Entity behavior** — `$1C:8000`: every entity's coroutine
   ([section 9](#9-behavior-engine-entity-ai)).
4. **Camera/scroll** — stage bank at `$A000`: section engine
   (`$C9DD`), column streaming.
5. **Spawn engine** — `$1B:988A` + stage bank: spawn-list scan at
   the camera edges.
6. **Housekeeping** — position mirrors (`$3C-$3F/$44-$45`), the
   furthest-screen watermark `$69` (checkpoint driver), then
   render + `frame_wait`.

Entity iteration alternates direction each frame
(`flicker_parity $9D`), rotating OAM priority so flicker is
distributed.

## 8. Entity System

24 slots (`$00-$17`), struct-of-arrays at `$0300+` with stride
`$18` — the field map matches MM4 §5 verbatim (`$0300` type,
`$0330/$0348` X px/screen, `$0378` Y px, `$0408` shape, `$0420`
dir (1 = right, 2 = left; bits 2-3 vertical), `$0468+` AI vars,
`$0510` spawn index, `$0528` flags, `$0540` anim phase, `$0558`
sub_type, `$0570` anim counter, `$0588/$05A0` behavior PC, `$05B8`
stun). Slot 0 is the player; buster shots use slots 1-3; enemies
spawn into `$08+`.

Behaviors "morph" an entity by rewriting its behavior PC
(`$0588/$05A0`) — the standard way an intro shell becomes a boss, a
death becomes an explosion, a director hands off to the next scene.
Shape bit 7 = contact damage, bit 6 = shot deflect; stun `$05B8`
bit 7 freezes the behavior (hit-stun, boss intro).

## 9. Behavior Engine (Entity AI)

`$1C:8000`, called once per frame by the player task. For each
active slot 1-`$17` (`$A6` = cursor): if `bhv_pc_hi` bit 7 is clear
the entity is uninitialized — its PC is seeded per **type** from
`bhv_pc_lo/hi_tbl` (`$1C:88C3/$8993`) and its AI bank from
`bhv_bank_tbl` (`$1C:86C3`). Dispatch maps the AI bank at `$A000`
(bank `$1C` stays at `$8000`), pushes a common return (`$805A`) and
jumps through the PC; handlers run as **coroutines** — to sleep
until next frame they store a new PC and `rts`. Types with
`$8xxx/$9xxx` PCs execute inside bank `$1C` itself.

AI banks: `$1D` (generic enemies, pickups, common machinery) plus
the stage banks `$02-$0A/$0D` — a stage bank's `$A000-$A8FF` region
hosts whatever AI the game needed room for, not necessarily its own
stage's (the eight robot masters sit in `$06-$08`, the Dark Men in
`$09`, Wily forms in `$02/$04`, scene directors in `$0A/$0D`).

## 10. Animation and Sprite Rendering

`entity_render_all` (`$DF5E`): iteration order alternates each frame
(flicker rotation). Per entity, `anim_bank_tbl[type]` (`$E33B`)
selects one of three animation bank pairs (`$12/$13`, `$14/$15`,
`$16/$17`) mapped as 16 KB; the descriptor
(`$8600/$8700`[sub_type]) gives frame count, frame duration and the
per-phase frame ids; frame ids resolve through `$8000-$8300`
(normal/flipped sprite-record pointers) and `$8400/$8500` (position
sets). Sprite records claim a CHR bank in one of the four 1 KB
sprite slots (MMC3 R2-R5 shadows `$EC-$EF`) — first claimant per
frame wins — then emit OAM with flip/priority bits and
gravity-flip-aware mirroring. Formats: DATA_REFERENCE §14.

## 11. Damage Engine

`$1C:809D` (weapon shot in slot `$10` hit enemy X):

- **Per-weapon damage tables ride the stage banks**: weapon N's
  per-enemy-type damage bytes live at `$A800` in PRG bank N
  (`$32` → `$F6`). Damage = `$A800[type] & $7F`; bit 7 marks
  special handling (weapons 1/9: instant kill/capture).
- Zero damage → ricochet: sound `$1E`, the shot becomes type `$46`
  and flies up-and-back.
- Buster damage comes from the charge level `$5B` (≥ `$0E` = 3);
  a charged shot that connects downgrades `$A9` → `$A8`.
- On kill, `death_transform_tbl` (`$1C:87C3`) picks a second form
  (boss death directors, explosions), else generic explosion type
  `$B8`; sounds `$2A` hit / `$2B` kill. Kills roll the pickup-drop
  thresholds (`$1D:AF1B`) for a timed type-`$B7` drop.
- Piercing weapons (7/8) keep their shot alive; type-`$79` shots
  deflect via a behavior-PC rewrite.

## 12. Entity Physics

Fixed-bank movement library, tile collision baked in:
`entity_move_right/left/down/up(_collide)` (`$E6C7+/$E8E6+`),
dispatchers by dir bits (`entity_horiz_dispatch $EA3F`,
`entity_vert_dispatch $EA52`), gravity (`entity_gravity_collide
$E7B7`, `entity_apply_gravity $E9E1` — `yvel` positive = up, gravity
`$A1`, default `$40`), velocity presets (`entity_speed_preset
$EAF5`), 8-direction velocity from sine tables
(`entity_set_dir_velocity $F470`), distance/aiming helpers
(`$EC76-$ECC4`). Helpers in `$1C`: `$8526` clear behind-BG,
`$852F/$8538` flip h/v facing, `$84FC` drift keeping flags. In
`$1D`: `$A089/$A09D` spawn children with type = parent+1, `$A54D`
self→puff, `$A56C` self→pickup-drop.

## 13. Tile Collision

A **three-level hierarchy** decodes stage geometry (DATA_REFERENCE
§11): screens hold 32-px block ids (8×8 grid), blocks (`$B200+`)
expand to four 16-px metatiles, metatiles carry four tile ids
(`$AD00-$B0FF`) plus an attribute byte (`$B100`) whose high nibble
is the **collision type** (`$20` solid; `$40` ladder — solid to
vertical probes; player latches `>= $D0`, spikes, into `$36`).

Probes (`tile_collide_horiz $C4A1` / `tile_collide_vert $C5AA`) test
the leading edge from shape-indexed extent records; results feed
`coll_results/coll_max/coll_or`. Decode respects the dynamic
tile-override records (`$06C0`) and the destroyed-block bitmap
(`$0680`, bit/byte lookup via `$F2B2/$F2C2`).

## 14. Player State Machine

`$1B:8000`, dispatched by `player_state $30` through the
`$8045/$8069` tables — 36 states, and the high ones double as the
between-stages flow selector read by the bank `$17` hub:

| State | Meaning |
|---|---|
| `$00-$03` | ground / air / slide / ladder |
| `$04` | jetski ride (Wave Man stage) |
| `$06` | hurt/knockback |
| `$07` | dead (→ hub: checkpoint restore / game over) |
| `$08` | teleport-in |
| `$09-$0B` | carried off / re-enter top / carried path |
| `$0D/$0E` | jetski mount / dock |
| `$0F` | victory orbs |
| `$10` | teleport-out (→ hub: stage clear / weapon get) |
| `$11-$13` | walk-to-mark / cutscene pose / drop-in+restore |
| `$14` | castle clear |
| `$15/$16` | warp depart / arrive (boss-rush teleporters) |
| `$17/$18` | rematch won / boss defeated |
| `$19` | stand frozen |
| `$1C-$23` | ending choreography (`$23` → hub: run the ending) |

`$54` = damage/weapon-get freeze counter; `$33/$34` = i-frame flash
timer + sub_type offset; `$AF` = gravity flip (Gravity Man stage) —
the state handlers pick input masks and nudges through
gravity-flip-aware tables.

## 15. Weapon System

Fire dispatch at `$1B:9571/$9581` by `cur_weapon $32`:

| ID | Weapon | Notes |
|---|---|---|
| `$0` | Power Buster | slots 1-3; charge `$5B` (≥ `$0E` full), shot sub_types `$18/$A8/$A9` |
| `$1` | Water Wave | ground wave |
| `$2` | Gyro Attack | steerable once |
| `$3` | Crystal Eye | splits into bouncers |
| `$4` | Napalm Bomb | arcing, timed |
| `$5` | Super Arrow | rideable platform |
| `$6` | Power Stone | orbiting spiral |
| `$7` | Gravity Hold | screen effect (piercing class) |
| `$8` | Charge Kick | slide attack |
| `$9` | Star Crash | shield → throw |
| `$A/$B` | Rush Coil / Rush Jet | carrier (`ride_slot $37`) |
| `$C` | Beat | homing companion (granted by `$6D = $FF`) |

Energy meters at `$B0+id` (bit 7 owned, `$9C` = owned + full 28);
`weapon_deduct $1B:953D`. Weapon-get grants come from the strings'
trailer bytes (`$17:8F08/$8F09`); a full refill tops every owned
meter to `$9C` (`$17:865A`).

## 16. Camera, Sections and Scrolling

Stages are strings of **sections** (list at `$A950` in the stage
bank: start screen in bits 0-4, flags in 5-7; attributes at `$A968`,
bit 7 = vertical-scroll room). The camera is `scroll_x/hi $FC/$F9`
(vertical rooms add `$FA/$FB` with `vscroll_flag $46`); crossing
8-px boundaries streams new nametable columns through the `$0780`
buffer (`draw_scroll_column $D4E2`, cursor `$24/$25`). Section
transitions slide 4 px/frame (`$CB60+`), redraw via the column
streamer, and boss doors gate on the section flags. Screen-link
records (`$A9E0`) teleport the camera between non-adjacent screens
(boss-rush doors); `$AC00[screen]` reseeds the spawn cursors after
any jump.

## 17. CHR Banking and Animation

All graphics are CHR-ROM banks; the NMI rewrites R0-R5 from
`$EA-$EF` every frame, so "animation" is writing a shadow:

- **BG CHR**: 2 banks per stage (`$A980/$A981`); the background
  CHR-anim program (`$05D0` slot, tables `$1E:DDB3+`) cycles one
  register on a schedule (waterfalls, conveyors).
- **Palette cycling**: program slots `$05F0+` (tables `$1E:DD01+`),
  seeded by stage data and spawn commands.
- **Sprite CHR**: per animation frame — each sprite record names a
  CHR bank and which R2-R5 slot receives it
  ([section 10](#10-animation-and-sprite-rendering)).

## 18. Spawn Engine

`$1B:988A`, run each frame with the stage bank mapped. Scans the
spawn lists (four parallel arrays: screen `$AA00`, X `$AA80`, Y
`$AB00`, code `$AB80`) at both camera edges, cursors `$AD/$AE`
seeded from `$AC00[screen]`. Codes `< $C0` spawn an enemy with
parameters from bank `$1B`'s tables (type, sub-type, shape, flags,
HP, speed row — entry `$9995`); codes `>= $C0` are palette /
CHR-anim commands. `ent_spawn_idx` (`$0510`) ties a kill to its
list entry in the `$0100` no-respawn bitmap.

## 19. Game Flow, Menus and Cutscenes

Everything between stages runs through the **game-flow hub**,
bank `$17:8000` (with `$0C` at `$A000`), dispatched on
`player_state $30`: `$07` death → checkpoint restore or game over,
`$10` stage clear → weapon get / castle maps / the Proto-4 escape
cutscene, `$23` → the ending (bank `$0E:A000`), otherwise
title/menus. Menus draw as **pseudo-stage `$10`** through the
normal stage pipeline, borrowing art banks via `$27` (title `$10`,
stage select/password `$0F`, story intro `$0B`, castle maps `$11`).

Checkpoints are driven by one number — the furthest screen reached
(`$69`) — matched against two 3-byte records per stage
(`$17:9169`). The attract-mode story intro is `$0C:A000`; the
ending (`$0E:A000`) replays the boss intros as a roll call using
bank `$17`'s own tables and types the credits from bank
`$0F:8000`. Full flow detail in the bank `$17`/`$0C`/`$0E` source
headers.

## 20. Sound Engine

Bank `$18` at `$8000` (driver), `$19` at `$A000` (data, spilling
into `$1A` through a virtual `$C000-$DFFF` window — the far-fetch
temporarily remaps R7 mid-read). `$8000` = per-frame update,
`$8003` = play id; 76 ids, directory `$8A43`, priority byte per
entry (`$00` = music, else SFX priority; b7 uninterruptible, b6
chained). Four channels (noise/tri/pulse2/pulse1) with parallel SFX
(`$0700+`) and music (`$0728+`) state blocks; SFX claim channels by
mask and mute the music voice underneath. Track language and
instrument format: DATA_REFERENCE §15 and the bank `$18` source
header.

## 21. Password System

Bank `$17`. A 6×6 grid holding exactly **3 red + 3 gray dots**: the
dots split into three positional groups; each group's red cell
encodes 3 bits of `$6E` (bosses) and its gray cell 3 bits of `$6D`
(items; `$FF` = Beat). Red/gray sharing a cell moves the gray to a
shifted cell list. Decode validates the dot census (6 visible,
exactly 3 red), grants weapons via `$17:9111/$9112`, and the
display encoder (`$17:87B9`) regenerates the grid from `$6E/$6D`
after every game over / weapon get. Details: DATA_REFERENCE §16.

## 22. Tricks and Curiosities

- **The player state IS the game mode**: `$30` values past `$1B`
  aren't player poses at all — the bank `$17` hub reads them as
  "what just happened" (`$07` died, `$10` cleared, `$23` roll the
  credits).
- **The ending replays the boss intros from menu tables**: bank
  `$17` stays mapped at `$8000` during the ending, so the roll call
  indexes the stage-select intro tables in place — one code path,
  two ceremonies.
- **Damage tables ride the stage banks**: weapon N's damage-per-type
  table is at `$A800` of PRG bank N — the weapon id doubles as a
  bank number.
- **Mid-read bank switch**: the sound driver's data fetch remaps
  MMC3 R7 to bank `$1A` for a single byte when a stream pointer
  crosses `$C000`, then restores `$19` — a virtual 16 KB data
  window over an 8 KB slot.
- **A menus bank moonlights as an animation bank**: `$17` is
  formally the `$A000` half of anim pair 3; the renderer maps it,
  but pair 3's records all stay inside `$16`.
- **Stage banks host strangers' AI**: a bank's `$A000-$A8FF` region
  holds whatever needed room — Napalm Man's AI lives in Star Man's
  neighborhood, the Dark Men share one bank, and Wily's forms are
  two banks apart.
- **One watermark runs the checkpoints**: death restores are chosen
  purely by comparing `$69` (furthest screen seen) against two
  thresholds per stage.
- **The boss-rush teleporter room is drawn by a stage-load hook**
  in bank `$0B:8000`, reading the re-beaten bitmask `$6B`; stage
  `$0E` also borrows *other stages' art banks per screen*
  (`stage0E_screen_banks`).
- **Two 2 KB bit tables with no reader** sit at the front of banks
  `$10/$11` (97% set bits) — apparently abandoned data shipped in
  the ROM.
- **The credits card the fans**: pages 0-7 of the credits are
  "DWN.NO-33 GRAVITY MAN / DESIGNER ..." — the fan-contest winners,
  typed letter-by-letter from bank `$0F`.
- **The game never returns from THE END**: the last thing the
  ending does is `jmp` into a two-instruction render loop.
