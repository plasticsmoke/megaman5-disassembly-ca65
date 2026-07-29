; =============================================================================
; Mega Man 5 (U) — iNES Header
; Mapper 4 (MMC3): 256KB PRG + 256KB CHR-ROM
; =============================================================================

.segment "HEADER"

.byte "NES", $1A       ; iNES magic
.byte $10              ; 16 x 16KB PRG = 256KB
.byte $20              ; 32 x 8KB CHR = 256KB CHR-ROM
.byte $40              ; Mapper 4 low nibble, horizontal mirroring
.byte $00              ; Mapper 4 high nibble
.byte $00, $00, $00, $00, $00, $00, $00, $00
