; =============================================================================
; Mega Man 5 (U) — Zero Page Variable Definitions
; Only confirmed variables from NMI/game loop/entity code tracing
; =============================================================================
; MM5 shares MM4's engine and most of its RAM layout, but every entry
; below is confirmed against MM5 code before being added.

; General-purpose temps ($00-$0F) — reused freely by any routine
temp_00         := $00
temp_01         := $01
temp_02         := $02
temp_03         := $03
temp_04         := $04
temp_05         := $05
temp_06         := $06
temp_07         := $07
temp_08         := $08
temp_09         := $09
temp_0A         := $0A
temp_0B         := $0B
temp_0C         := $0C
temp_0D         := $0D
temp_0E         := $0E
temp_0F         := $0F

; Controller input (read_controllers $C2E5; joy2 is zeroed at the end —
; pad 2 input is discarded after the debug hooks read the raw bits)
joy1_press      := $14          ; controller 1 new presses this frame
joy2_press      := $15          ; controller 2 new presses (cleared each read)
joy1_held       := $16          ; controller 1 held buttons
joy2_held       := $17          ; controller 2 held buttons (cleared each read)

; Rendering flags (NMI handler)
palette_dirty   := $18          ; palette upload flag (32 bytes from $0600)
nametable_dirty := $19          ; nametable buffer write flag (flush from $0780)
nt_column_dirty := $1A          ; column/attr write pending (flushed in inc-32 mode)
nt_row_dirty    := $1C          ; second buffer region pending (flush from $0780+$50)
nt_busy         := $60          ; nametable_dirty | nt_column_dirty this frame

; IRQ split parameters (meaning is per game mode; see irq handlers $C185+)
irq_split0      := $78          ; e.g. mode 4/7: X scroll below the split
irq_split1      := $79          ; e.g. mode 1: PPUADDR hi for mid-frame seam
irq_split2      := $7A          ; e.g. mode 4: next IRQ latch value
irq_split3      := $7B          ; e.g. mode 5: PPUADDR lo for second split

; Task scheduler (4 tasks, 4-byte records at $80: state/counter/lo/hi;
; state: 0=free, 1=frame-wait, 4=ready, 8=new)
task_state      := $80          ; task record base: state byte
task_arg        := $81          ; frame-wait counter
task_sp         := $82          ; saved stack pointer (lo byte = entry lo at spawn)
task_ptr_hi     := $83          ; entry pointer hi at spawn
nmi_occurred    := $90          ; set $FF by NMI task step, cleared by scheduler
cur_task        := $91          ; current task index (0-3)
frame_counter   := $92          ; incremented every NMI
task_ptr_lo     := $93          ; task_create argument: entry pointer lo
task_ptr_hi_arg := $94          ; task_create argument: entry pointer hi

; NMI / IRQ control
nmi_quick       := $95          ; nonzero: skip uploads, scroll+tasks only
irq_enable_idx  := $96          ; 0/1: NMI writes $E000+x (0=IRQ off, 1=IRQ on)
irq_vector      := $97          ; 2 bytes: current IRQ handler (jmp ($0097))
game_mode_req   := $99          ; game mode requested by game code
game_mode       := $9A          ; game mode applied at NMI (indexes IRQ tables)
irq_latch_req   := $9B          ; MMC3 IRQ latch value requested
irq_latch       := $9C          ; latch value applied at NMI

; Scroll (pending, applied at NMI)
scroll_y_apl    := $A2          ; scroll Y -> PPUSCROLL (2nd write)
scroll_x_apl    := $A4          ; scroll X -> PPUSCROLL (1st write)
nt_sel_apl      := $A5          ; nametable bits -> PPUCTRL

; Sound queue (8 slots, $88 = empty; pumped after NMI via the $C147 trampoline)
sound_q_idx     := $DB          ; next queue slot to scan
sound_queue     := $DC          ; 8 queued sound IDs ($DC-$E3)

; Sound trampoline ($C12B/$C147): NMI swaps the interrupted return
; address with $C147 so the music driver runs after the handler exits
saved_pc_lo     := $E8          ; interrupted PC (restored -1 on the stack)
saved_pc_hi     := $E9

; CHR banking — NMI writes MMC3 R0-R5 from these every frame
chr_banks       := $EA          ; 6 bytes $EA-$EF: CHR bank per MMC3 R0-R5

; PRG banking / PPU shadows
nmi_skip        := $F0          ; rendering-off nesting counter (NMI: tasks only)
mmc3_sel_shadow := $F2          ; last value written to MMC3 bank select
prg_bank_8000   := $F5          ; PRG bank mapped at $8000 (MMC3 R6)
prg_bank_a000   := $F6          ; PRG bank mapped at $A000 (MMC3 R7)
bank_nest       := $F7          ; bank-switch nesting depth
sound_pending   := $F8          ; nonzero: pump sound queue on next bank restore
scroll_y        := $FA          ; scroll Y pending
scroll_x        := $FC          ; scroll X pending
nt_select       := $FD          ; nametable select bits pending (& $03)
ppumask_shadow  := $FE          ; PPUMASK value applied at NMI
ppuctrl_shadow  := $FF          ; PPUCTRL base (NMI enable etc.)

; Stage banks
stage_bank      := $26          ; current stage bank (mapped at $A000 via R7)
stage_bank_alt  := $27          ; alternate stage bank for cross-bank reads

; Misc system
mirror_shadow   := $2C          ; last value written to MMC3 mirroring reg
sound_save_x    := $A7          ; X/Y saved across the sound queue pump
sound_save_y    := $A8
rng_state       := $E4          ; 4-byte LFSR RNG ($E4-$E7), seed $88, stepped by task 1
prg_cur_8000    := $F3          ; bank last actually written to MMC3 R6
prg_cur_a000    := $F4          ; bank last actually written to MMC3 R7

; Tile collision engine ($C4A1-$C7E6; see fixed_bank.asm)
coll_or         := $10          ; OR of all probe collision types
probe_y         := $11          ; current probe Y pixel
probe_x         := $12          ; current probe X pixel
probe_screen    := $13          ; current probe screen index
breakable_off   := $1E          ; nonzero: skip breakable-block bitmap check
player_tile_max := $36          ; player: latched coll_max >= $D0 (spikes etc.)
probe_row       := $40          ; extent record cursor
coll_max        := $42          ; strongest collision type this probe set
tile_ovr_cnt    := $43          ; dynamic tile override count * 4
vscroll_flag    := $46          ; nonzero: vertical-scroll room coordinates
coll_results    := $48          ; per-probe collision types ($48+)
saved_bank_a000 := $F1          ; $A000 bank saved across collision/stage reads
scroll_y_hi     := $FB          ; camera Y screen (pending, pairs with scroll_y)

; Camera / scroll / section engine ($C9DD-$D6BF)
col_cursor_hi   := $24          ; column-draw cursor: screen
col_cursor_lo   := $25          ; column-draw cursor: column (0-31, 8px units)
scroll_dir      := $28          ; scroll direction latch (1=right, 2=left)
cur_section     := $29          ; section index (& $1F) + flag bit $20
section_target  := $2A          ; section end screen
section_screen  := $2B          ; camera screen within section
scroll_x_drawn  := $44          ; scroll X at last column draw
scroll_x_hi     := $F9          ; camera X screen (pairs with scroll_x $FC)

; Entity rendering ($DF5E+)
render_first    := $56          ; slot rendered first on odd frames
boss_chr_flag   := $74          ; nonzero: boss CHR setup path in render loop
flicker_parity  := $9D          ; frame parity: entity iteration direction
render_slot     := $9E          ; current slot in render loop
oam_offset      := $9F          ; OAM build cursor (4 = skip sprite 0)

; Player
player_state    := $30          ; player state machine index (7 = death)
gravity_flip    := $AF          ; nonzero: gravity inverted (Gravity Man stage)
status_flags    := $17          ; joy2_held slot reused: bit 6 = water (suspected)

; Game flow
pause_freeze    := $A0          ; nonzero: player task idles (debug pad-2 SELECT)
pause_lock      := $54          ; blocks START pause menu when set
redraw_busy     := $1B          ; stage_load full-redraw in progress

; Physics
gravity         := $A1          ; gravity per frame ($40 default; cf. MM4 $99)

; Player state machine (bank $1B)
iframe_timer    := $33          ; invulnerability flash timer
iframe_sub_ofs  := $34          ; sub_type offset restored when flash ends
weapon_fired    := $37          ; cleared each frame by the state dispatcher
hit_freeze      := $54          ; damage/weapon-get freeze counter

; Spawn engine (bank $1B $988A)
spawn_ahead     := $AD          ; spawn-list cursor ahead of camera
spawn_behind    := $AE          ; spawn-list cursor behind camera
scroll_dir_cur  := $AC          ; scroll direction latch (mirrors $28)
