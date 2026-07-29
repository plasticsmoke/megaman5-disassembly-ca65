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
sound_q_guard   := $E4          ; $88 written after the 8 queue slots at reset
prg_cur_8000    := $F3          ; bank last actually written to MMC3 R6
prg_cur_a000    := $F4          ; bank last actually written to MMC3 R7
