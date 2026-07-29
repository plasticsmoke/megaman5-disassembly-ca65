; =============================================================================
; Mega Man 5 (U) — Game Constants
; =============================================================================
; Populated as structures are confirmed. Entity array addresses match
; MM4's layout where verified (entity_clear_all $C39D touches type,
; spawn_idx, enemy_hp, bhv_pc_hi, stun at MM4's exact addresses); the
; remaining arrays are added as MM5 code confirms them.

; Entity array base addresses (stride $18, 24 slots: $00-$17)
; Slot $00 = player, slots $01+ = weapons/enemies/items
ent_type        := $0300        ; entity type/active (0 = inactive)
ent_spawn_idx   := $0438        ; spawn-list entry index (init $FF)
ent_enemy_hp    := $0450        ; enemy hit points
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
OAM_BUF         := $0200        ; 256-byte OAM buffer (DMA source)
PAL_BUF         := $0600        ; 32-byte palette buffer (uploaded when palette_dirty)
NT_BUF          := $0780        ; nametable write buffer: records of
                                ;   [PPU addr hi (bit7 set = end), addr lo,
                                ;    length-1, data...]
                                ; nt_row_dirty flushes from NT_BUF+$50
