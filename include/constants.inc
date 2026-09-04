; =============================================================================
; Mega Man 5 (U) — Game Constants
; =============================================================================
; Entity array addresses match MM4's layout, confirmed by the physics,
; render, collision and behavior-engine code.

; Entity array base addresses (stride $18, 24 slots: $00-$17)
; Slot $00 = player, slots $01+ = weapons/enemies/items
; Layout matches MM4's; confirmed via physics/render/collision tracing.
ent_type        := $0300        ; entity type/active (0 = inactive)
ent_x_sub       := $0318        ; X position sub-pixel
ent_x_px        := $0330        ; X position pixel
ent_x_screen    := $0348        ; X position screen
ent_y_sub       := $0360        ; Y position sub-pixel
ent_y_px        := $0378        ; Y position pixel
ent_y_screen    := $0390        ; Y position screen
ent_xvel_sub    := $03A8        ; X velocity sub-pixel
ent_xvel        := $03C0        ; X velocity pixel
ent_yvel_sub    := $03D8        ; Y velocity sub-pixel
ent_yvel        := $03F0        ; Y velocity pixel (terminal fall +7)
ent_shape       := $0408        ; collision shape (& $3F -> extent tables)
ent_dir         := $0420        ; direction (bits 0-1 horiz, 2-3 vert)
ent_spawn_idx   := $0438        ; spawn-list entry index ($FF = none; no-respawn bitmap key)
ent_enemy_hp    := $0450        ; enemy hit points
ent_param       := $0468        ; general parameter / timer
ent_var5        := $0480        ; general purpose (cleared at spawn/wipe)
ent_var6        := $0498        ; general purpose
ent_angle       := $04B0        ; angle / AI counter
ent_var1        := $04C8        ; general purpose
ent_var2        := $04E0        ; general purpose
ent_var7        := $04F8        ; general purpose
ent_spawn_code  := $0510        ; spawn code from the $AB80 list (enemy id)
ent_flags       := $0528        ; 7=renderable 6=vflip 5=hflip 4=behind-BG 3=wide-range 2=no-draw/no-collide
ent_anim_phase  := $0540        ; animation frame index
ent_sub_type    := $0558        ; sub-type: anim descriptor index
ent_var3        := $0570        ; animation tick counter
ent_bhv_pc_lo   := $0588        ; behavior PC low (seeded from bhv_pc_lo_tbl)
ent_bhv_pc_hi   := $05A0        ; behavior PC high (cleared on despawn)
ent_stun        := $05B8        ; hit-stun countdown / pause-frozen flags

; Entity slot count
ENT_SLOT_COUNT  = $18           ; 24 entity slots (0-$17)
ENT_SLOT_MAX    = $17           ; last entity slot index

; Button masks (standard NES)
BTN_A           = $80
BTN_B           = $40
BTN_SELECT      = $20
BTN_START       = $10
BTN_UP          = $08
BTN_DOWN        = $04
BTN_LEFT        = $02
BTN_RIGHT       = $01

; Buffers
NO_RESPAWN_BUF  := $0100        ; 32-byte bitmap: killed spawn indices (no respawn)
OAM_BUF         := $0200        ; 256-byte OAM buffer (DMA source)
PAL_BUF         := $0600        ; 32-byte palette buffer (uploaded when palette_dirty)
NT_BUF          := $0780        ; nametable write buffer: records of
                                ;   [PPU addr hi (bit7 set = end), addr lo,
                                ;    length-1, data...]
                                ; nt_row_dirty flushes from NT_BUF+$50
