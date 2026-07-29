; =============================================================================
; Mega Man 5 (U) — Fixed Bank Entry Points ($C000-$FFFF)
; Cross-bank callable routines in the fixed bank
; =============================================================================
; NOTE: fixed_bank.asm defines these as labels and does NOT include this
; file; the := definitions here are for the swappable bank sources.

; --- Rendering / PPU ---
nametable_flush     := $C298  ; flush nametable write buffer from NT_BUF
nametable_flush_at  := $C29C  ; flush from NT_BUF+X
render_ctrl_off     := $C2BD  ; PPUCTRL &= $11 (NMI off, sprites pattern kept)
nmi_ctrl_on         := $C2C7  ; PPUCTRL |= $80 (enable NMI)
disable_rendering   := $C2D1  ; inc nmi_skip, PPUMASK = 0
enable_rendering    := $C2DB  ; dec nmi_skip, PPUMASK = $18
ppu_fill_nametable  := $C343  ; fill nametable A(hi) with X, attributes with Y
oam_clear           := $C38F  ; clear OAM buffer ($F8 = offscreen)

; --- Input ---
read_controllers    := $C2E5  ; read both pads, compute press/held (joy2 cleared)

; --- Scroll / IRQ state ---
scroll_irq_reset    := $C3B8  ; clear game-mode req, IRQ splits, pending scroll

; --- Palette ---
palette_fade_in     := $C3EB  ; fade palette in from dark
palette_fade_out    := $C3F1  ; fade palette out to black

; --- Entity Management ---
entity_clear_all    := $C39D  ; clear entity slots $01-$17 (player untouched)
entity_deactivate   := $E06E  ; deactivate entity slot X
entity_set_subtype  := $EA98  ; set sub-type,X + reset anim counters
entity_init_pos     := $EAA4  ; copy position X->Y, init Y entity fields
entity_init_subtype_y := $EAE9 ; set sub-type for slot Y directly
entity_set_facing   := $EC16  ; face entity toward player (dir bits 0-1)
entity_flip_direction := $EC4A ; reverse horiz: XOR dir bits 0-1 + flags bit 6

; --- Entity Physics / Movement ---
entity_move_right_collide := $E8E6 ; rightward move + tile collision
entity_move_left_collide  := $E90C ; leftward move + tile collision
entity_move_down_collide  := $E92A ; downward move + tile collision (no facing)
entity_move_up_nofacing   := $E94A ; upward move + tile collision (no facing)
entity_process_y_vel      := $E968 ; apply Y velocity by sign, then gravity
entity_stop_y             := $EA1E ; set Y velocity to $FF00 (stopped)
entity_vert_dispatch      := $EA52 ; dispatch up/down movement by dir bits 2-3
entity_facing_dispatch    := $EA65 ; set hflip from dir bits + move left/right
entity_vert_dispatch_raw  := $EA86 ; up/down dispatch, raw collide (no platform)

; --- Entity Physics (additional) ---
entity_move_right   := $E6C7  ; move right + collision (player-aware)
entity_move_left    := $E708  ; move left + collision (player-aware)
entity_move_up      := $E780  ; move up + collision (player-aware)
entity_gravity_collide := $E7B7 ; gravity + fall + landing (gravity_flip-aware)
entity_apply_gravity := $E9E1 ; yvel += gravity, clamp at +7
entity_horiz_dispatch := $EA3F ; left/right by dir bits 0-1
entity_speed_preset := $EAF5  ; velocity preset from speed tables
entity_facing_to_flags := $EC30 ; dir -> flags bit 5 (hflip)
entity_player_collide := $EF87 ; entity vs player hitbox
entity_hitbox_check := $EFF8  ; entity vs slot hitbox (weapons)
find_free_slot_x    := $F15F  ; free slot -> X (C = fail)
find_free_slot_y    := $F16F  ; free slot $08-$17 -> Y (C = fail)
entity_distance_calc := $ECC2 ; distance from player slot

; --- Entity Distance / Aiming ---
entity_y_dist_abs         := $EC76 ; absolute Y pixel distance to player
entity_x_dist_px          := $EC94 ; absolute X pixel distance to player (16-bit)
entity_distance_from_y    := $ECC4 ; full distance calculation (from slot Y)

; --- Entity lifecycle / movement ---
entity_wipe_x       := $F2C4  ; full deactivate + clear all AI vars (slot X)
entity_wipe_y       := $F2FE  ; full deactivate + clear all AI vars (slot Y)
entity_set_dir_velocity := $F470 ; dir byte + 8-dir velocity from sine tables

; --- Frame helpers ---
render_frame_banksafe := $F34A ; oam_clear + entity_render_all, banks saved
render_tick_frame   := $F363  ; render + frame_wait (quick NMI)
call_bank00_frame   := $F32D  ; run bank $00's per-frame service

; --- Player / stage state ---
player_palette_load := $F3BF  ; load player palette rows into PAL_BUF
stage_state_init    := $F3F2  ; wipe scroll/override state for stage (re)load

; --- Sound ---
queue_sound_param   := $EC5B  ; set param + queue sound command
queue_sound         := $EC5D  ; queue sound A into the NMI-pumped ring buffer

; --- Math ---
div8                := $F207  ; 8-bit divide
div16               := $F22D  ; 16-bit divide

; --- Tile Collision ---
tile_collide_horiz  := $C4A1  ; probe leading vertical edge (horizontal moves)
tile_collide_vert   := $C5AA  ; probe leading horizontal edge (vertical moves)

; --- Tasks / System (see fixed_bank.asm tail) ---
scheduler_run       := $FEAB  ; run ready tasks until all yield
task_create         := $FEF3  ; create task X/4 with entry ptr in $93/$94
task_kill           := $FF03  ; free task slot A
task_exit           := $FF0B  ; terminate current task, re-enter scheduler
frame_wait_x        := $FF1B  ; yield X frames
frame_wait          := $FF22  ; yield one frame
bank_load_pair      := $FF3D  ; map PRG bank A at $8000, A+1 at $A000
bank_load_shadow    := $FF43  ; map PRG banks from prg_bank_8000/a000
set_mirroring       := $FFB7  ; write A to MMC3 mirroring register
