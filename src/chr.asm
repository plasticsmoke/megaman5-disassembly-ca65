; =============================================================================
; Mega Man 5 (U) — CHR ROM (256KB, 32 x 8KB banks)
; Banked by the MMC3 CHR registers (R0-R5) at runtime.
; chr/chr.bin is extracted from the original ROM by tools/split_rom.py
; (not distributed — see .gitignore).
; =============================================================================

.segment "CHR"
.incbin "chr/chr.bin"
