# Mega Man 5 — Data Reference

Addresses, table formats, and IDs for ROM hackers, as established by
the annotated disassembly. `$XX:YYYY` = PRG bank `$XX` at CPU address
`$YYYY`. File offset of a byte = `16 + bank*$2000 + (addr - base)`
where `base` is the bank's mapped address (`$8000`, `$A000`, or
`$C000` — see `cfg/nes.cfg`). See ENGINE.md for how these systems
work.


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


## 1. Quick Reference

The addresses hackers ask for first:

| Address | What |
|---|---|
| `$B0` | Player HP (`$9C` = full 28 for all meters) |
| `$B1-$BC` | Weapon energy meters (bit 7 = owned; [section 9](#9-weapons)) |
| `$BF` | Lives (game over resets to 2) |
| `$32` | Current weapon id |
| `$6E` | Defeated robot-master bitmask (bit = stage & 7, masks `$F2B2`) |
| `$67` | Weapon-obtained bitmask (lags `$6E` until the ceremony) |
| `$6D` | Items bitmask (`$FF` grants Beat) |
| `$6F` | Castle progress (low nibble Proto, high Wily) |
| `$26` | Current stage id (= its data bank at `$A000`) |
| `$30` | Player state / flow selector ([section 8](#8-player-states-and-sub-types)) |
| `$69` | Furthest screen reached (drives checkpoints, `$17:9169`) |
| `$A1` | Gravity (`$40` normal) |
| `N:A800` | Damage table for weapon N, indexed by entity type |
| `$18:8A43` | Song/SFX directory ([section 15](#15-sound-engine-reference)) |

## 2. Bank Map

Every 8 KB PRG bank, as identified by the annotation passes. "Data
half" = the stage-data tables from `$A900` on ([section
11](#11-stage-data-format)); each stage's data bank id equals its
stage id.

| Bank | `$8000`-half role | `$A000`-half role |
|---|---|---|
| `$00` | per-frame service (`call_bank00_frame`) | Gravity Man stage data |
| `$01` | pause/weapon menu + stage-load tables | Wave Man stage data |
| `$02` | — | Wily-boss AI (Big Pets, Circring, Press) + Stone Man data |
| `$03` | — | Dark Man 4 scene, boss-rush pods + Gyro Man data |
| `$04` | — | Wily Machine/Capsule AI + Star Man data |
| `$05` | — | stage-gimmick directors + Charge Man data |
| `$06` | — | Stone/Charge/Gyro Man AI + Napalm Man data |
| `$07` | — | Gravity/Crystal/Wave Man AI + Crystal Man data |
| `$08` | — | Napalm/Star Man AI, pickup sweep + Proto 1 data |
| `$09` | — | Dark Man 1-4 AI + Proto 2 data |
| `$0A` | — | aftermath directors, stage triggers + Proto 3 data |
| `$0B` | stage-load service, boss-rush teleporter draw | Proto 4 data |
| `$0C` | — | story intro (`$A000-$A625`) + Wily 1 data |
| `$0D` | — | endgame Wily scene AI + Wily 2 data |
| `$0E` | — | ending sequence (`$A000-$A8FF`) + Wily 3 data |
| `$0F` | ending credits text (`$8000-$8577`) | Wily 4 data |
| `$10` | — | *(unreferenced bit table `$A000-$A7FF`)* + menu/ending pseudo-stage data |
| `$11` | — | *(unreferenced bit table `$A000-$A7FF`)* + castle-map art bank (`$27=$11`) |
| `$12/$13` | animation pair 1 | (both halves) |
| `$14/$15` | animation pair 2 | (both halves) |
| `$16` | animation pair 3 (records stay here) | — |
| `$17` | game-flow hub: title/menus/castle maps | (formal anim pair 3 partner) |
| `$18` | sound driver | — |
| `$19` | — | sound data |
| `$1A` | — | sound data overflow (virtual `$C000-$DFFF`) |
| `$1B` | player engine, weapons, spawn engine | — |
| `$1C` | behavior engine, damage engine, shared AI | — |
| `$1D` | — | generic enemy/pickup/effect AI |
| `$1E/$1F` | fixed bank `$C000-$FFFF` | — |

## 3. Zero Page

Maintained as the annotated source of truth in
`include/zeropage.inc` — controller, rendering flags, IRQ splits,
task scheduler, sound queue, banking shadows, camera/scroll,
collision engine, player and weapon state. Game-flow globals worth
repeating: see [section 1](#1-quick-reference).

## 4. RAM Map

See ENGINE.md section 2 for the full map. Highlights: `$0100`
no-respawn bitmap + task stacks, `$0200` OAM shadow, `$0300-$05CF`
entity arrays ([section 5](#5-entity-arrays)), `$05D0/$05F0`
CHR-anim + palette-cycle program slots, `$0600-$063F` live/master
palettes, `$0680` destroyed-block bitmap, `$06C0` dynamic tile
overrides, `$0700-$077F` sound channels, `$0780-$07FF` PPU write
buffer.

## 5. Entity Arrays

24 slots (`$00-$17`), stride `$18`; address of field for slot N =
base + N. The layout matches MM4's engine verbatim:

| Base | Name | Purpose |
|---|---|---|
| `$0300` | `ent_type` | Type; 0 = free slot |
| `$0318` | `ent_x_sub` | X sub-pixel |
| `$0330` | `ent_x_px` | X pixel |
| `$0348` | `ent_x_screen` | X screen |
| `$0360` | `ent_y_sub` | Y sub-pixel |
| `$0378` | `ent_y_px` | Y pixel |
| `$0390` | `ent_y_screen` | Y screen / move-result flag |
| `$03A8` | `ent_xvel_sub` | X velocity sub-pixel |
| `$03C0` | `ent_xvel` | X velocity pixel |
| `$03D8` | `ent_yvel_sub` | Y velocity sub-pixel |
| `$03F0` | `ent_yvel` | Y velocity pixel (positive = up) |
| `$0408` | `ent_shape` | `& $3F` hitbox index; `$40` shot-deflect; `$80` contact damage |
| `$0420` | `ent_dir` | Bits 0-1 horizontal (1 R / 2 L), 2-3 vertical |
| `$0438` | — | Spawn-list linkage |
| `$0450` | `ent_enemy_hp` | Enemy HP (damage engine) |
| `$0468` | `ent_param` | General parameter/timer |
| `$0480` | `ent_var5` | AI state/counter |
| `$0498` | `ent_var6` | AI state/index |
| `$04B0` | `ent_angle` | 16-dir angle / AI counter |
| `$04C8` | `ent_var1` | General |
| `$04E0` | `ent_var2` | General |
| `$04F8` | — | General |
| `$0510` | `ent_spawn_code` | Spawn code (no-respawn bitmap key) |
| `$0528` | `ent_flags` | 7 renderable, 6 hflip, 5 behind-BG, 4 camera-relative, 3 wide range, 2 inert, 0-1 platform type |
| `$0540` | `ent_anim_phase` | Animation phase |
| `$0558` | `ent_sub_type` | Sub-type (selects the anim descriptor) |
| `$0570` | `ent_var3` | Anim sub-frame counter |
| `$0588` | `ent_bhv_pc_lo` | Behavior PC low |
| `$05A0` | `ent_bhv_pc_hi` | Behavior PC high (bit 7 = initialized) |
| `$05B8` | `ent_stun` | Bits 0-6 hit-stun; bit 7 = behavior frozen |

## 6. Entity Type Catalog

Seeded per type from `bhv_bank_tbl` / `bhv_pc_lo/hi_tbl`
(`$1C:86C3/$88C3/$8993`); "AI bank" is where the handler is
annotated (bank `$1C` handlers run at `$8000`, others at `$A000`).
One-line summaries — each handler carries a full header block in its
bank source.

| Type | AI bank | Behavior |
|---|---|---|
| `$00/$01/$1E/$6D/$71` | `$1C` | inert (effect actors: animation system only) |
| `$02` | `$1D` | RUSH COIL: descends, lands, springs the player |
| `$03` | `$1D` | screen-crossing drifter |
| `$04` | `$0A` | ride mount (Charge Man stage, X=$F0/Y=$C0) |
| `$05` | `$0A` | pipe launch (Wave Man stage, scr $03) |
| `$06/$07` | `$05` | gravity flip panel, horizontal (Gravity Man stage) |
| `$08` | `$05` | gravity flip panel, vertical |
| `$09` | `$05` | Star Man stage space-section backdrop (IRQ mode $17) |
| `$0A` | `$0A` | Gyro Man stage shaft auto-scroll (scr $01) |
| `$0B` | `$05` | Gyro Man stage express elevator |
| `$0C` | `$05` | block restorer |
| `$0D` | `$05` | Wave Man stage bubble platform (spawned by the $0E spawner) |
| `$0E` | `$05` | bubble-column spawner (Wave Man stage) |
| `$0F` | `$05` | Wily 1 shaft water level (IRQ mode $1C) |
| `$10` | `$1C` | carrier |
| `$11` | `$1C` | turret rider |
| `$12` | `$1C` | swooper: flies level facing the player |
| `$13` | `$1C` | planter |
| `$14` | `$1C` | planted drop: falls (extent 7) |
| `$15` | `$1C` | blink chaser: cycles hidden/visible on timers |
| `$16` | `$1C` | pounce hopper: wakes within $5A/$32 or when the player fires |
| `$17` | `$1C` | creeper: crawls with $01.01 velocity hugging the surface (probe $0B) |
| `$18` | `$1D` | shell-back walker |
| `$19` | `$1C` | bomber: flies facing the player |
| `$1A` | `$1C` | dropped bomb: falls (extent 6) |
| `$1B` | `$1C` | sleeper: waits out ent_param, wakes when the player is within $50x/$20y |
| `$1C/$3C/$51/$55/$61/$9D/$9F` | `$1C` | straight flier |
| `$1D` | `$1D` | walking bomb |
| `$1F` | `$1C` | inert |
| `$20` | `$1C` | leaper: rests $3C frames, then springs at the player (xvel $01.C4, yvel $05.A8) |
| `$21` | `$1C` | homing dart |
| `$22` | `$1D` | item carrier: despawns on arrival if flag $5D is already set (its gift was taken) |
| `$23` | `$1C` | pendulum |
| `$24` | `$1C` | pop-up trap |
| `$25` | `$1C` | pop-up column |
| `$26` | `$1D` | recycling dripper |
| `$27` | `$1D` | lurker trap: harmless and hidden until the player stands within $20/$18 px |
| `$28` | `$1C` | gravity dripper (Gravity Man stage) |
| `$29` | `$1C` | drop |
| `$2A` | `$1C` | pod |
| `$2B` | `$1C` | shield walker: shape bit 6 deflects shots from the front |
| `$2C/$37/$58/$65/$9B` | `$1C` | horizontal mover |
| `$2D` | `$1C` | released payload of the type $2A pod |
| `$2E` | `$1C` | drift lift: the spawn code (&7) picks its 8-way heading and run length (L96D4) |
| `$2F/$8C/$BC/$C2` | `$1C` | spark burst |
| `$30` | `$1C` | firework fountain |
| `$31` | `$1C` | spread launcher: walks, turning at walls/ledges (probe $15/$16) |
| `$32` | `$1C` | lobbed shell |
| `$33/$3E/$BD` | `$1C` | launcher (head of a pair) |
| `$34/$BE` | `$1C` | flung child: tumbles down walking its facing |
| `$35` | `$1C` | edge gun |
| `$36` | `$1C` | pop-up turret |
| `$38` | `$1C` | camera-edge stalker: once the camera passes x=$140 it rides $70px behind the left edge |
| `$39` | `$1C` | falling debris: anim pinned to phase 0 while it descends (preset $17, drift $1C) |
| `$3A` | `$1C` | telescoper |
| `$3B` | `$1D` | hopping sniper: wakes within $50 px or when the player fires |
| `$3D` | `$1D` | ledge crawler |
| `$3F` | `$1D` | ballistic mover |
| `$40` | `$0A` | Napalm Man stage wall turret (scr $06) |
| `$41` | `$05` | Charge Man stage train parallax |
| `$42` | `$05` | Wave Man stage jet ski |
| `$43` | `$03` | inert (rts) |
| `$44` | `$03` | Wave Man stage water giant (spawn: bank $01 scr $24) |
| `$45` | `$1D` | RUSH JET: descends and hovers to the player's level (when reachable, probe $17) |
| `$46/$4E/$7F` | `$1D` | deflected shot |
| `$47` | `$04` | phase-2 floor bomb |
| `$48` | `$05` | camera-locked sprite (Star Man stage) |
| `$49` | `$1D` | collapse camera director (scripted vertical fall) |
| `$4A` | `$05` | Proto castle 3 wall borer |
| `$4B` | `$05` | second wall borer |
| `$4C` | `$1D` | disappearing-block sequencer (yoku blocks) |
| `$4D` | `$1D` | victory weapon-energy orb |
| `$4F` | `$02` | BIG PETS director (Wily 1 boss) |
| `$50` | `$1D` | burst pod: sleeps until the player is within $50x/$14y, then rises 3px armed (shape $C1) |
| `$52` | `$1D` | wall-hopping minion (spawned by type $5D) |
| `$53` | `$1D` | pop-out ambusher |
| `$54` | `$1D` | hovering strafer |
| `$56` | `$1D` | delayed chaser: lies dormant $78 frames, then plays its wake anim with sound $37 |
| `$57` | `$1D` | tossed pickup (thrown by type $22) |
| `$59` | `$1D` | flyer nest: stationary, always facing the player |
| `$5A` | `$1D` | kamikaze flyer: sails horizontally |
| `$5B` | `$1D` | burst fragment (spawned in threes by type $5A) |
| `$5C` | `$1C` | head hunter: homes on a point $20 above the player (8-way, speed 8) |
| `$5D` | `$1D` | minion generator: stationary, always facing the player |
| `$5E` | `$1C` | inert (the settled remnant of type $34/$BE) |
| `$5F` | `$1D` | slow hopper |
| `$60` | `$1D` | pop-up turret |
| `$62` | `$1D` | homing flyer (spawned by type $59 nest) |
| `$63` | `$1D` | ceiling dropper |
| `$64` | `$1D` | retaliating turret: stationary, faces the player |
| `$66` | `$1D` | bobbing lunger |
| `$67` | `$1D` | plain walker |
| `$68` | `$1D` | homing flyer |
| `$69` | `$06` | STONE MAN (boss of stage $02) |
| `$6A` | `$06` | Power Stone chunk (Stone Man's): shape follows the anim phase (LA1F2) |
| `$6B` | `$06` | CHARGE MAN (boss of stage $05) |
| `$6C` | `$06` | Charge Man's coal chunk |
| `$6E` | `$06` | GYRO MAN (boss of stage $03) |
| `$6F` | `$06` | Gyro Attack blade |
| `$70` | `$1D` | P.BUSTER SHOT (all charge tiers) |
| `$72` | `$1D` | NAPALM BOMB: gravity + ground bounce (rebound table LB3B0), reverses on walls |
| `$73` | `$1D` | CRYSTAL EYE |
| `$74` | `$1D` | GYRO ATTACK: Up/Down held redirects it vertically (once) |
| `$75` | `$1D` | WATER WAVE segment: crawls forward hugging the ground |
| `$76` | `$1D` | SUPER ARROW: accelerates $00.33/frame to 4px/f |
| `$77` | `$1D` | STAR CRASH shield: orbits the player |
| `$78` | `$1D` | POWER STONE stone |
| `$79` | `$1D` | BEAT |
| `$7A` | `$02` | BIG PETS ram row (two per fight, spawn code $5B) |
| `$7B` | `$02` | BIG PETS "pet" minion |
| `$7C` | `$02` | CIRCRING Q9 (Wily 2 boss) |
| `$7D` | `$02` | Circring Q9 floor crawler |
| `$7E` | `$02` | Circring Q9 falling bomb |
| `$80` | `$06` | Gyro Man's falling gyro (dropped from the clouds) |
| `$81` | `$07` | GRAVITY MAN (boss of stage $00) |
| `$82/$85` | `$07` | straight projectile (Gravity Man's bullet / Crystal Man's aimed eye) |
| `$83` | `$07` | CRYSTAL MAN (boss of stage $07) |
| `$84` | `$07` | Crystal Eye ball (spread volley) |
| `$86` | `$07` | WAVE MAN (boss of stage $01) |
| `$87` | `$07` | Wave Man's harpoon |
| `$88/$BB` | `$07` | water spout column |
| `$89` | `$08` | NAPALM MAN (boss of stage $06) |
| `$8A` | `$08` | napalm missile: level homing shot |
| `$8B` | `$08` | napalm bomb: ballistic arc, rolls on landing |
| `$8D` | `$08` | STAR MAN (boss of stage $04) |
| `$8E` | `$08` | Star Crash shield: rides its owner |
| `$8F/$90` | `$08` | inert (rts) |
| `$91` | `$09` | DARK MAN 2 (Proto castle 2 boss) |
| `$92` | `$09` | Dark Man 2's shield pod |
| `$93` | `$09` | DARK MAN 3 (Proto castle 3 boss) |
| `$94/$97` | `$09` | Dark Man straight shots (DM3 jump shot / DM1 roll shot) |
| `$95` | `$09` | Dark Man 3's stun shot |
| `$96` | `$09` | DARK MAN 1 (Proto castle 1 boss). Rolls at the player |
| `$98` | `$09` | DARK MAN 4 (Proto castle 4 boss) |
| `$99` | `$09` | Dark Man 4's shield segment |
| `$9A` | `$09` | Dark Man 4's ring shot |
| `$9C` | `$1C` | hover pest (gravity-flip aware): wakes within $5A px or the moment the player fires |
| `$9E` | `$1C` | sleeper sentry (chain partially traced): shared flip helper L9BA5 |
| `$A0` | `$02` | WILY PRESS (Wily 3+4 boss) |
| `$A1` | `$02` | Wily Press underside rider (sub $62, shape $DD) |
| `$A2/$B5` | `$03` | DARK MAN 4 "fake Proto Man" scene director (Proto castle 4, spawn code $5E at scr $03) |
| `$A3` | `$03` | scene projectile |
| `$A4` | `$03` | real Proto Man (scene actor) |
| `$A5` | `$04` | WILY MACHINE, phase 1 (Wily 4 = stage $0F, spawn code $5F at scr $07) |
| `$A6` | `$04` | Wily Machine suction field |
| `$A7` | `$04` | Wily Machine arcing bomb |
| `$A8` | `$04` | Wily Machine hopping skull |
| `$A9` | `$04` | Wily Machine destruction (death transform of $A5) |
| `$AA` | `$04` | WILY CAPSULE (the true final boss, emerging from the wrecked machine) |
| `$AB` | `$04` | phase-2 curving orb |
| `$AC` | `$0A` | Wily Press aftermath (death transform of $A0) |
| `$AD` | `$0A` | fortress-boss defeat director (death transform of Big Pets $4F and Circring $7C) |
| `$AE` | `$0A` | water giant aftermath (death transform of $44) |
| `$AF` | `$03` | boss-rush teleporter pod (10 in bank $0E scr $02-$03) |
| `$B0` | `$03` | rematch-won return orb. Falls to the floor |
| `$B1` | `$1D` | attachment node |
| `$B2` | `$04` | BG-locked overlay |
| `$B3` | `$0A` | boss-room director (one per stage, placed on the boss room's screen) |
| `$B4` | `$0A` | robot-master death director (death transform of all eight RMs and the Dark Men) |
| `$B6/$C3` | `$1D` | pickup grant (shared tail) |
| `$B7/$B8` | `$1D` | enemy death explosion (damage engine spawns type $B8 on kill) |
| `$B9` | `$0D` | endgame Wily, capsule-room scene (spawn code $72, stage $0F scr $0A) |
| `$BA` | `$0D` | Wily bailed out of the Machine (flung here by type $C0, $0A:A215) |
| `$BF` | `$1C` | bubble: floats straight up |
| `$C0` | `$0A` | Wily Machine destroyed, Wily bails out (death transform of $AA) |
| `$C1` | `$0D` | scene burst |
| `$C4` | `$1D` | burst fragment (spawned in threes by type $50 when shot) |
| `$C5` | `$1D` | GRAVITY HOLD screen effect (flash + lift all vulnerable enemies) |
| `$C6/$C7/$C8` | `$1D` | delayed-fall debris |
| `$C9-$CF` | `$1C` | inert (unused type ids) |

Types `$C9-$CF` are unused ids (inert). Weapon-get / menu actors
(types `$1B/$21/$5D/$60/$6D`-as-menu-actor etc.) are driven by the
cutscene code in banks `$17/$0C/$0E` rather than the behavior
engine.

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
`$32` into `$F6`). One carve-out: with Beat selected (`$32 = $C`),
only the slot-1 shot (Beat itself) uses bank `$0C` — buster shots
fired alongside it (slots 2-3) reroute to bank `$00`'s table.
Entry = `$A800[ent_type]`; low 7 bits = damage,
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

## 17. Fixed-Bank Tables

| Address | Table |
|---|---|
| `$C280/$C288` | IRQ vectors per game mode (8 modes) |
| `$D4C2` | `stage_alt_bank_tbl` (stage → art bank `$27`) |
| `$D4D2` | Stage music ids (indexed by `$26`) |
| `$D793` | `stage0E_screen_banks` (boss rush per-screen art banks) |
| `$DD01+` | Palette-cycle programs (slots `$05F0`) |
| `$DDB3+` | Background CHR-anim programs (slot `$05D0`) |
| `$E33B` | `anim_bank_tbl` (entity type → animation pair) |
| `$F2B2/$F2C2` | Bit/byte mask tables (stage bits, block bitmaps) |
| `$C827/$C902` | Collision probe extent records (h/v shapes) |

Bank `$1C` companions: `bhv_bank_tbl $86C3`, `bhv_pc_lo/hi_tbl
$88C3/$8993`, `death_transform_tbl $87C3`.

## 18. Fixed-Bank API

The cross-bank callable surface is maintained as
`include/fixed_bank.inc` — rendering/PPU, input, palette fades,
entity management/physics/distance, frame helpers, stage state,
sound queue, math, tile collision, tasks and banking. That file is
the authoritative list; ENGINE.md walks the systems that use it.
