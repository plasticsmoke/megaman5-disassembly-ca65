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

; --- Entity Management ---
entity_clear_all    := $C39D  ; clear entity slots $01-$17 (player untouched)

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
