.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK10"

; =============================================================================
; BANK $10 — MENU/ENDING PSEUDO-STAGE DATA
; Stage $26=$10, used by the bank $17 menus, the $0C story intro and
; the $0E ending: screen table at $A900 (identity), layouts $B600+,
; and (for the title screens, $27=$10) its own block/metatile art.
; Other menu screens borrow art banks via $27: password/stage-select
; $0F, story intro $0B, castle maps $11. Format: DATA_REFERENCE §11.
; Front half ($A000-$A7FF): dense bit table with no known reader —
; apparently unused filler.
; SKELETON — raw ROM bytes, not yet classified as code or data.
; =============================================================================
    .byte $F7,$FB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A000
    .byte $FF,$FF,$FB,$FF,$FE,$FF,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF   ; $A010
    .byte $FF,$FF,$BF,$FF,$BF,$FF,$FF,$FF,$FF,$FF,$BF,$FF,$FF,$FF,$DF,$FF   ; $A020
    .byte $FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A030
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A040
    .byte $FB,$FF,$FB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FB,$FF,$FF,$FF,$FF,$FF   ; $A050
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$BF,$FD,$FF,$FF,$FF,$FF,$FF,$FF   ; $A060
    .byte $FF,$FF,$FE,$FF,$EF,$FF,$FF,$FF,$EA,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A070
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A080
    .byte $BF,$FF,$FF,$FF,$F7,$FF,$FF,$FF,$FD,$FF,$FF,$FB,$FF,$FF,$EF,$FF   ; $A090
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$BF,$FF,$AF,$FF,$FF,$FF,$FF,$FF,$BF,$FF   ; $A0A0
    .byte $FF,$FF,$BF,$FF,$FF,$FF,$E7,$FF,$FF,$FF,$FF,$FF,$F7,$FF,$FE,$FF   ; $A0B0
    .byte $FE,$FF,$FB,$FF,$FF,$DF,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A0C0
    .byte $76,$FF,$FF,$FF,$BF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A0D0
    .byte $FE,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$EB,$FE,$FF,$FF,$EF,$FF,$EF,$FF   ; $A0E0
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FB,$FF,$EF,$FF,$FE,$FF   ; $A0F0
    .byte $FB,$FF,$FF,$FF,$FF,$FF,$FB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF,$FF   ; $A100
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF   ; $A110
    .byte $BF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A120
    .byte $FF,$FF,$BE,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF,$FB,$FF,$FF,$FF   ; $A130
    .byte $FE,$FF,$FF,$FB,$FF,$FF,$EF,$FF,$EF,$FF,$FF,$FF,$FE,$FF,$FE,$FF   ; $A140
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A150
    .byte $FF,$FF,$BF,$FF,$7E,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A160
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF   ; $A170
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FB,$FF,$FF,$FF,$FF,$FF,$FB,$FF,$FF,$FF   ; $A180
    .byte $FF,$FF,$FF,$FB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF   ; $A190
    .byte $FE,$FF,$FE,$FF,$FF,$FF,$EF,$FF,$FF,$FF,$F6,$7F,$FF,$FF,$FE,$FF   ; $A1A0
    .byte $FF,$7F,$BF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF   ; $A1B0
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD   ; $A1C0
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A1D0
    .byte $FF,$FF,$EE,$FF,$FE,$FF,$FF,$FF,$FB,$FF,$FE,$FF,$FE,$FF,$FF,$FF   ; $A1E0
    .byte $FB,$FF,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF   ; $A1F0
    .byte $FF,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A200
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$EF,$FB,$FF,$FF,$FF,$FF,$FF,$FF   ; $A210
    .byte $FF,$FF,$FE,$FF,$FF,$FF,$FB,$FF,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF   ; $A220
    .byte $FF,$FF,$FF,$FF,$FB,$FF,$FF,$FF,$FF,$FF,$FE,$FF,$BF,$FF,$FF,$BF   ; $A230
    .byte $BF,$FF,$F7,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF   ; $A240
    .byte $FF,$FF,$FF,$FF,$EF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A250
    .byte $FF,$FF,$BE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$BF,$EF,$FE,$FF,$BF,$FF   ; $A260
    .byte $FF,$FF,$FF,$FF,$EE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF   ; $A270
    .byte $FF,$FF,$BF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FB,$FF,$FF,$FF,$FF   ; $A280
    .byte $FF,$7F,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A290
    .byte $EF,$FF,$BF,$FF,$FE,$FF,$FF,$FF,$FB,$FF,$FF,$FF,$FE,$FF,$FF,$FF   ; $A2A0
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$BF,$FF,$FF,$FF,$FF,$FF,$BF,$FF   ; $A2B0
    .byte $FF,$FF,$FE,$FF,$FF,$EF,$FF,$FF,$FF,$FF,$BF,$FF,$FF,$FF,$FF,$FF   ; $A2C0
    .byte $FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF   ; $A2D0
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$EE,$FF,$FF,$FF,$EF,$FF,$FF,$FF,$FF,$FF   ; $A2E0
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$BF,$FF   ; $A2F0
    .byte $FE,$FF,$FF,$FF,$FF,$FF,$DF,$FF,$FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF   ; $A300
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A310
    .byte $FF,$FF,$7F,$FF,$EF,$FF,$FE,$FF,$FF,$EF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A320
    .byte $EF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A330
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A340
    .byte $FE,$FF,$BF,$FF,$EF,$FF,$FD,$FF,$FF,$FD,$FF,$FF,$FE,$FF,$BF,$FF   ; $A350
    .byte $BF,$FF,$FF,$FE,$7F,$FF,$BF,$FF,$FB,$FF,$FF,$FF,$FF,$FF,$FE,$FF   ; $A360
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$EF,$FF,$FF,$FF,$FF,$FF   ; $A370
    .byte $FF,$FF,$FF,$FF,$FF,$F7,$FF,$FF,$AE,$FF,$FF,$FF,$FF,$FF,$BF,$FF   ; $A380
    .byte $FF,$FF,$FF,$FF,$FB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$EF,$FF,$FF,$FF   ; $A390
    .byte $FE,$FF,$FE,$FF,$FF,$FF,$EF,$FF,$BF,$FF,$FF,$FF,$EF,$FF,$FF,$FF   ; $A3A0
    .byte $BF,$FF,$FF,$FF,$FB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FB,$FF,$FF,$FF   ; $A3B0
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$EF,$FF,$EB,$FF,$FF,$FF   ; $A3C0
    .byte $FF,$FF,$FF,$FF,$E7,$FF,$FF,$FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A3D0
    .byte $BF,$FF,$EF,$FF,$FB,$FF,$BF,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF   ; $A3E0
    .byte $FF,$DF,$FF,$FF,$FF,$FF,$FA,$FF,$EF,$FF,$BF,$FF,$FF,$FF,$BF,$FF   ; $A3F0
    .byte $3F,$AF,$FF,$FD,$FF,$F7,$FF,$DF,$FF,$FF,$FF,$55,$FF,$FF,$FF,$FD   ; $A400
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F7,$FF,$7D   ; $A410
    .byte $FF,$FF,$FF,$FF,$FF,$F7,$FF,$FF,$FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF   ; $A420
    .byte $FF,$D7,$FF,$FF,$FF,$7F,$FF,$FF,$FF,$F7,$FF,$F7,$FF,$FF,$FF,$FF   ; $A430
    .byte $FD,$FF,$FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF,$FF,$75,$FF,$FF,$FF,$FD   ; $A440
    .byte $FF,$7F,$FF,$FF,$FF,$DF,$FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF   ; $A450
    .byte $FD,$FF,$FF,$D7,$FF,$7F,$FF,$FF,$FB,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A460
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF,$FF,$FD,$FF,$FF,$FF,$F7,$FF,$FF   ; $A470
    .byte $FF,$FF,$FF,$7F,$BF,$7F,$FF,$7F,$FF,$FF,$FF,$FD,$FF,$FF,$FF,$FF   ; $A480
    .byte $FF,$FF,$FF,$F7,$FF,$FF,$FF,$DD,$FF,$FF,$FF,$F7,$FF,$7D,$FF,$FF   ; $A490
    .byte $FF,$FF,$FF,$DF,$FF,$FF,$FF,$FF,$FF,$F7,$FF,$5F,$FF,$FF,$FF,$FF   ; $A4A0
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF,$FF,$FF,$FF,$FF,$FF,$F7,$FF,$77   ; $A4B0
    .byte $FF,$F7,$FF,$F7,$FF,$FF,$FF,$FF,$F7,$D7,$FF,$FF,$FF,$7D,$FF,$7F   ; $A4C0
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF,$7F,$FF,$DF,$FF,$FF,$FF,$FF   ; $A4D0
    .byte $FF,$DF,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD   ; $A4E0
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$7F,$FF,$FF,$FF,$F7,$FF,$FF   ; $A4F0
    .byte $FF,$F5,$EF,$B7,$FF,$D5,$7F,$FF,$FF,$FD,$FF,$FF,$FF,$BF,$FF,$DF   ; $A500
    .byte $FF,$FF,$FF,$5D,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F,$FF,$7F   ; $A510
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$F7,$FF,$FF,$FF,$DF   ; $A520
    .byte $FF,$7B,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A530
    .byte $FF,$FF,$FF,$F7,$FF,$FF,$FF,$FF,$7F,$FD,$FF,$DF,$FF,$FD,$FF,$FD   ; $A540
    .byte $FF,$E7,$FF,$FF,$FF,$DF,$FF,$FF,$FF,$FF,$FF,$7F,$FF,$7F,$FF,$7F   ; $A550
    .byte $FF,$FB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A560
    .byte $FF,$FF,$FF,$FF,$FF,$F6,$FF,$FD,$FF,$FF,$FF,$F5,$BF,$FF,$FF,$FF   ; $A570
    .byte $FF,$7F,$FF,$FF,$FF,$FF,$FF,$DF,$FF,$FD,$FF,$FF,$DF,$BD,$FF,$FF   ; $A580
    .byte $FF,$DF,$FF,$7F,$FF,$FE,$FF,$DF,$FF,$FF,$FF,$F7,$FF,$F5,$FF,$FF   ; $A590
    .byte $FF,$FF,$FF,$7F,$FF,$DD,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF,$FF,$FD   ; $A5A0
    .byte $FF,$DD,$FF,$FF,$FF,$F7,$FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD   ; $A5B0
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD   ; $A5C0
    .byte $FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF   ; $A5D0
    .byte $FF,$FF,$BF,$FF,$FF,$FF,$FF,$DF,$FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF   ; $A5E0
    .byte $FF,$F7,$FF,$DD,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF   ; $A5F0
    .byte $EF,$7F,$FF,$DF,$FF,$FF,$DF,$7F,$FB,$DF,$FF,$FF,$FF,$FF,$B7,$FF   ; $A600
    .byte $FF,$D7,$FF,$DF,$FF,$FF,$FF,$FD,$FF,$F5,$FF,$FD,$FE,$FF,$FF,$7F   ; $A610
    .byte $FF,$FE,$FF,$FF,$DF,$F7,$FF,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A620
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF,$FF,$FF,$FF,$7D,$FF,$F7   ; $A630
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$EF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A640
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7D,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD   ; $A650
    .byte $FF,$FF,$FF,$7D,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF   ; $A660
    .byte $FF,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A670
    .byte $FF,$7F,$FF,$7F,$FF,$DF,$FF,$DF,$FF,$F6,$7F,$FF,$FF,$FF,$FF,$FF   ; $A680
    .byte $FF,$DF,$FF,$FF,$FF,$FF,$FF,$DF,$FF,$DF,$FF,$FF,$FF,$F7,$FF,$FF   ; $A690
    .byte $FF,$F5,$FF,$D7,$FF,$FD,$FF,$FF,$FF,$7D,$FF,$FF,$FF,$FF,$FF,$F5   ; $A6A0
    .byte $FF,$FF,$FF,$F7,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF,$FF,$FD,$FF,$DF   ; $A6B0
    .byte $FF,$7F,$FF,$FF,$FF,$7D,$FF,$F6,$FF,$FF,$FF,$FF,$FF,$7F,$FF,$F7   ; $A6C0
    .byte $DF,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD   ; $A6D0
    .byte $FF,$FF,$FF,$EF,$FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A6E0
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A6F0
    .byte $FF,$7F,$FF,$FD,$FB,$FF,$FF,$57,$FF,$FF,$FF,$F7,$FF,$FF,$FF,$D7   ; $A700
    .byte $FF,$F7,$FF,$7F,$FF,$FD,$FF,$DD,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$F7   ; $A710
    .byte $FF,$FF,$FF,$7F,$FF,$FF,$FF,$EF,$FF,$DF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A720
    .byte $FF,$FF,$FF,$FF,$FF,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A730
    .byte $FF,$FD,$BF,$FD,$FF,$F7,$FF,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD   ; $A740
    .byte $FF,$FF,$FF,$7F,$FF,$77,$FF,$DF,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$7F   ; $A750
    .byte $FF,$77,$FF,$7F,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF,$FF,$FF,$FF,$DF   ; $A760
    .byte $FF,$FF,$FF,$DF,$FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$7C,$FF,$FF   ; $A770
    .byte $FF,$FF,$FF,$FF,$FF,$DF,$FF,$5F,$FF,$FF,$FF,$DF,$FF,$F7,$FF,$EF   ; $A780
    .byte $FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF,$FF,$FF   ; $A790
    .byte $FF,$7F,$FF,$7F,$FF,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F,$FF,$FF   ; $A7A0
    .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$5F,$FF,$FF,$FF,$FF,$FF,$5F,$FF,$FF   ; $A7B0
    .byte $FF,$FF,$FF,$BF,$FF,$F7,$FF,$FF,$FF,$FF,$FF,$F7,$F7,$F7,$FF,$7F   ; $A7C0
    .byte $FF,$7F,$FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F,$FF,$D7,$FF,$FF   ; $A7D0
    .byte $FF,$F7,$FF,$5F,$FF,$DD,$FF,$FD,$FF,$DF,$FF,$FF,$FF,$FF,$FF,$FF   ; $A7E0
    .byte $FF,$5F,$FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF   ; $A7F0
; --- $A800: unreferenced (no damage table: not a weapon bank) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A800
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A810
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A820
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A830
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A840
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A850
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A860
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00 ; A870
        .byte   $00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A880
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A890
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00 ; A8A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00 ; A8B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8F0

; =============================================================================
; MENU/ENDING PSEUDO-STAGE STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $A900: screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; A900  screens $00-$0F
        .byte   $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F ; A910  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A920  screens $20-$2F
        .byte   $00,$10,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A930  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A940  screens $40-$4F
; --- $A950: section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00 ; A950
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A960
; --- $A968: per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A968
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A978
; --- $A980: BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A980
; --- $A988: BG palette (16 bytes) ---
        .byte   $0F,$00,$00,$00,$0F,$00,$00,$00,$0F,$00,$00,$00,$0F,$00,$00,$00 ; A988
; --- $A998: sprite palette-cycle seeds -> $05F0 slots ($A998-$A99B read) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A998
; --- $A9A0: unreferenced ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9D0
; --- $A9E0: screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9E0  terminator / filler
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9F0  
        .byte   $00                             ; A9FF  -1 base for the spawn arrays
; --- $AA00: spawn screens (ascending) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA00  entries $00-$0F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA10  entries $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA20  entries $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA30  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$10,$00,$00 ; AA50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA70  entries $70-$7F
; --- $AA80: spawn X px ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA80  entries $00-$0F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA90  entries $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAA0  entries $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00 ; AAE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAF0  entries $70-$7F
; --- $AB00: spawn Y px ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB00  entries $00-$0F
        .byte   $00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB10  entries $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB20  entries $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB30  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB70  entries $70-$7F
; --- $AB80: spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB80  entries $00-$0F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB90  entries $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABA0  entries $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04 ; ABE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABF0  entries $70-$7F
; --- $AC00: per-screen spawn-list start index ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC00  screens $00-$0F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC10  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC20  screens $20-$2F
        .byte   $00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC30  screens $30-$3F
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC40  screens $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC50  screens $50-$5F
        .byte   $00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00 ; AC60  screens $60-$6F
        .byte   $00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$02,$00 ; AC70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC90  screens $90-$9F
        .byte   $00,$00,$02,$00,$00,$00,$00,$00,$04,$00,$20,$00,$00,$00,$00,$00 ; ACA0  screens $A0-$AF
        .byte   $00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACB0  screens $B0-$BF
        .byte   $00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACD0  screens $D0-$DF
        .byte   $00,$00,$10,$01,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACE0  screens $E0-$EF
        .byte   $00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACF0  screens $F0-$FF
; --- $AD00: metatile top-left tile ids ---
        .byte   $00,$01,$01,$01,$11,$11,$01,$13,$01,$0A,$1A,$1A,$00,$01,$15,$0E ; AD00  metatiles $00-$0F
        .byte   $07,$10,$17,$1C,$00,$1C,$07,$01,$15,$1A,$1A,$01,$18,$18,$00,$0F ; AD10  metatiles $10-$1F
        .byte   $00,$61,$63,$65,$00,$65,$69,$68,$20,$22,$24,$26,$28,$2A,$00,$00 ; AD20  metatiles $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$40,$42,$44,$46,$48,$4A,$00,$00 ; AD30  metatiles $30-$3F
        .byte   $5E,$F1,$F0,$EE,$5E,$E0,$E4,$5E,$5E,$F0,$E0,$E9,$5E,$F3,$5E,$ED ; AD40  metatiles $40-$4F
        .byte   $E1,$5E,$E4,$00,$00,$EE,$ED,$F0,$EC,$5E,$ED,$E3,$5E,$E7,$E9,$5E ; AD50  metatiles $50-$5F
        .byte   $EE,$EF,$ED,$EA,$70,$00,$2D,$2E,$4C,$74,$6A,$6C,$6E,$80,$82,$8E ; AD60  metatiles $60-$6F
        .byte   $00,$19,$00,$B0,$B0,$8C,$00,$E4,$F0,$00,$00,$00,$00,$00,$00,$00 ; AD70  metatiles $70-$7F
        .byte   $AD,$AF,$BB,$A4,$A6,$A8,$AA,$BD,$BF,$00,$00,$00,$00,$00,$00,$00 ; AD80  metatiles $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AD90  metatiles $90-$9F
        .byte   $03,$02,$04,$06,$08,$08,$08,$08,$1F,$28,$60,$08,$2A,$2C,$2E,$08 ; ADA0  metatiles $A0-$AF
        .byte   $60,$60,$CF,$08,$4A,$4C,$4E,$0A,$22,$24,$AE,$68,$6A,$6C,$6E,$0C ; ADB0  metatiles $B0-$BF
        .byte   $08,$08,$A4,$A6,$A8,$AA,$AC,$08,$A2,$C2,$C4,$C6,$C8,$CA,$CC,$CE ; ADC0  metatiles $C0-$CF
        .byte   $00,$E2,$E4,$E6,$E8,$EA,$EC,$EE,$85,$60,$A0,$A2,$88,$8A,$99,$60 ; ADD0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$9D,$30,$32,$34,$36,$00,$95,$97,$9F ; ADE0  metatiles $E0-$EF
        .byte   $50,$52,$54,$56,$C0,$00,$00,$83,$60,$8B,$60,$76,$A1,$60,$8D,$60 ; ADF0  metatiles $F0-$FF
; --- $AE00: metatile bottom-left tile ids ---
        .byte   $00,$01,$01,$06,$11,$12,$01,$11,$01,$0B,$1B,$1B,$00,$06,$01,$0F ; AE00  metatiles $00-$0F
        .byte   $15,$07,$18,$00,$1A,$00,$07,$10,$10,$1C,$1C,$16,$18,$0E,$00,$17 ; AE10  metatiles $10-$1F
        .byte   $60,$62,$64,$66,$61,$61,$67,$00,$21,$23,$25,$27,$29,$2B,$00,$00 ; AE20  metatiles $20-$2F
        .byte   $00,$F2,$E5,$E2,$EC,$EF,$F5,$E5,$41,$43,$45,$47,$49,$4B,$EE,$EB ; AE30  metatiles $30-$3F
        .byte   $E1,$EF,$E4,$00,$F2,$F4,$00,$EF,$E0,$F0,$E2,$00,$E4,$E4,$E1,$EB ; AE40  metatiles $40-$4F
        .byte   $00,$E8,$F0,$00,$00,$EE,$F2,$ED,$E4,$E6,$EA,$00,$E9,$E2,$00,$E2 ; AE50  metatiles $50-$5F
        .byte   $E0,$E6,$E7,$00,$71,$2C,$00,$2F,$4D,$75,$6B,$6D,$6F,$81,$83,$8F ; AE60  metatiles $60-$6F
        .byte   $00,$04,$B0,$B0,$1A,$8D,$E1,$E0,$00,$00,$00,$00,$00,$00,$00,$AC ; AE70  metatiles $70-$7F
        .byte   $AE,$BA,$BC,$A5,$A7,$A9,$AB,$BE,$00,$00,$00,$00,$00,$00,$00,$00 ; AE80  metatiles $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AE90  metatiles $90-$9F
        .byte   $01,$08,$05,$07,$08,$08,$08,$08,$27,$60,$60,$29,$2B,$2D,$2F,$08 ; AEA0  metatiles $A0-$AF
        .byte   $60,$60,$DF,$49,$4B,$4D,$4F,$08,$23,$25,$AF,$69,$6B,$6D,$6F,$0D ; AEB0  metatiles $B0-$BF
        .byte   $08,$A3,$A5,$A7,$A9,$AB,$AD,$08,$60,$C3,$C5,$C7,$C9,$CB,$CD,$00 ; AEC0  metatiles $C0-$CF
        .byte   $E1,$E3,$E5,$E7,$E9,$EB,$ED,$EF,$86,$60,$A1,$87,$89,$98,$9A,$60 ; AED0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$9E,$31,$33,$35,$37,$94,$96,$00,$60 ; AEE0  metatiles $E0-$EF
        .byte   $51,$53,$55,$57,$00,$00,$82,$84,$A0,$60,$60,$60,$A2,$60,$8E,$60 ; AEF0  metatiles $F0-$FF
; --- $AF00: metatile top-right tile ids ---
        .byte   $00,$01,$01,$01,$00,$00,$11,$00,$03,$1A,$1A,$0E,$18,$01,$0A,$01 ; AF00  metatiles $00-$0F
        .byte   $00,$0C,$01,$0F,$00,$1C,$00,$01,$0A,$19,$1A,$01,$01,$01,$17,$01 ; AF10  metatiles $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$30,$32,$34,$36,$38,$3A,$88,$88 ; AF20  metatiles $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$50,$52,$54,$56,$58,$5A,$00,$00 ; AF30  metatiles $30-$3F
        .byte   $88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88 ; AF40  metatiles $40-$4F
        .byte   $88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88 ; AF50  metatiles $50-$5F
        .byte   $88,$88,$88,$88,$72,$00,$3D,$3E,$5C,$76,$7A,$7C,$7E,$90,$92,$9E ; AF60  metatiles $60-$6F
        .byte   $00,$01,$00,$00,$00,$9C,$00,$84,$84,$84,$84,$94,$96,$98,$9A,$00 ; AF70  metatiles $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AF80  metatiles $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AF90  metatiles $90-$9F
        .byte   $10,$12,$14,$16,$08,$1C,$1E,$08,$22,$24,$AE,$08,$3A,$3C,$3E,$09 ; AFA0  metatiles $A0-$AF
        .byte   $1F,$28,$60,$08,$5A,$5C,$5E,$0B,$60,$60,$CF,$78,$7A,$7C,$7E,$0E ; AFB0  metatiles $B0-$BF
        .byte   $B0,$B2,$B4,$B6,$B8,$BA,$BC,$BE,$60,$D2,$D4,$D6,$D8,$DA,$DC,$DE ; AFC0  metatiles $C0-$CF
        .byte   $00,$F2,$F4,$F6,$F8,$FA,$FC,$FE,$A1,$60,$60,$60,$A0,$A2,$60,$60 ; AFD0  metatiles $D0-$DF
        .byte   $20,$20,$20,$26,$00,$71,$73,$60,$40,$42,$44,$46,$00,$19,$1B,$60 ; AFE0  metatiles $E0-$EF
        .byte   $60,$62,$64,$66,$D0,$81,$91,$93,$60,$9B,$60,$60,$60,$8D,$9D,$9F ; AFF0  metatiles $F0-$FF
; --- $B000: metatile bottom-right tile ids ---
        .byte   $00,$01,$10,$06,$00,$00,$11,$00,$01,$1B,$1B,$04,$18,$16,$0B,$01 ; B000  metatiles $00-$0F
        .byte   $0A,$00,$01,$17,$1A,$00,$00,$06,$0C,$0F,$1C,$01,$01,$01,$18,$01 ; B010  metatiles $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$31,$33,$35,$37,$39,$3B,$00,$88 ; B020  metatiles $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$51,$53,$55,$57,$59,$5B,$00,$00 ; B030  metatiles $30-$3F
        .byte   $88,$88,$88,$00,$88,$88,$88,$88,$88,$88,$88,$00,$88,$88,$88,$88 ; B040  metatiles $40-$4F
        .byte   $88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88,$88 ; B050  metatiles $50-$5F
        .byte   $88,$88,$88,$88,$73,$3C,$00,$3F,$5D,$77,$7B,$7D,$7F,$91,$93,$9F ; B060  metatiles $60-$6F
        .byte   $00,$01,$00,$00,$1A,$9D,$00,$84,$84,$84,$00,$95,$97,$99,$9B,$00 ; B070  metatiles $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B080  metatiles $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B090  metatiles $90-$9F
        .byte   $11,$13,$15,$17,$08,$1D,$08,$08,$23,$25,$AF,$39,$3B,$3D,$3F,$08 ; B0A0  metatiles $A0-$AF
        .byte   $27,$60,$60,$59,$5B,$5D,$5F,$08,$60,$60,$DF,$79,$7B,$7D,$7F,$0F ; B0B0  metatiles $B0-$BF
        .byte   $B1,$B3,$B5,$B7,$B9,$BB,$BD,$BF,$60,$D3,$D5,$D7,$D9,$DB,$DD,$00 ; B0C0  metatiles $C0-$CF
        .byte   $F1,$F3,$F5,$F7,$F9,$FB,$FD,$FF,$A2,$60,$60,$60,$A1,$60,$60,$60 ; B0D0  metatiles $D0-$DF
        .byte   $21,$20,$20,$00,$70,$72,$00,$60,$41,$43,$45,$47,$18,$1A,$00,$60 ; B0E0  metatiles $E0-$EF
        .byte   $61,$63,$65,$67,$80,$90,$92,$A0,$60,$9C,$60,$60,$60,$8E,$9E,$60 ; B0F0  metatiles $F0-$FF
; --- $B100: metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; B100  metatiles $00-$0F
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; B110  metatiles $10-$1F
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00 ; B120  metatiles $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B130  metatiles $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B140  metatiles $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B150  metatiles $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00 ; B160  metatiles $60-$6F
        .byte   $03,$03,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02 ; B170  metatiles $70-$7F
        .byte   $02,$02,$02,$01,$01,$01,$01,$02,$02,$03,$03,$03,$03,$03,$00,$00 ; B180  metatiles $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B190  metatiles $90-$9F
        .byte   $03,$03,$03,$03,$03,$03,$03,$01,$00,$00,$00,$03,$02,$02,$02,$01 ; B1A0  metatiles $A0-$AF
        .byte   $00,$00,$00,$03,$03,$01,$01,$01,$00,$00,$00,$03,$03,$01,$01,$01 ; B1B0  metatiles $B0-$BF
        .byte   $03,$03,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00,$00 ; B1C0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1D0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1E0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1F0  metatiles $F0-$FF
; --- $B200: 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $01,$01,$17,$16,$01,$02,$16,$05,$06,$06,$20,$21,$06,$06,$22,$23 ; B200  blocks $00-$03
        .byte   $06,$06,$24,$25,$06,$06,$26,$27,$08,$01,$07,$16,$01,$01,$16,$0E ; B210  blocks $04-$07
        .byte   $03,$00,$03,$00,$28,$3F,$29,$31,$40,$41,$44,$45,$42,$43,$46,$2E ; B220  blocks $08-$0B
        .byte   $00,$38,$00,$39,$36,$47,$37,$59,$57,$58,$5A,$5B,$2E,$0A,$2E,$0A ; B230  blocks $0C-$0F
        .byte   $2A,$32,$2B,$33,$48,$49,$4C,$4D,$4A,$4B,$2F,$2E,$00,$3A,$00,$3B ; B240  blocks $10-$13
        .byte   $33,$5C,$35,$5F,$5D,$5E,$60,$61,$2C,$34,$2D,$35,$4E,$4F,$48,$55 ; B250  blocks $14-$17
        .byte   $50,$2E,$56,$2E,$00,$3C,$00,$3D,$3E,$5F,$3E,$51,$62,$63,$52,$2F ; B260  blocks $18-$1B
        .byte   $00,$00,$00,$00,$00,$00,$64,$69,$00,$00,$6A,$6B,$00,$00,$6C,$6D ; B270  blocks $1C-$1F
        .byte   $00,$00,$6E,$6F,$00,$0A,$00,$0A,$0D,$0C,$17,$16,$0C,$0C,$16,$10 ; B280  blocks $20-$23
        .byte   $0C,$0C,$11,$16,$0C,$0C,$16,$18,$0C,$0C,$16,$16,$0C,$0B,$16,$0E ; B290  blocks $24-$27
        .byte   $03,$65,$03,$00,$66,$14,$72,$74,$15,$67,$15,$00,$00,$1A,$73,$1A ; B2A0  blocks $28-$2B
        .byte   $00,$00,$2F,$2F,$00,$00,$2F,$2E,$00,$68,$00,$00,$00,$0A,$73,$0A ; B2B0  blocks $2C-$2F
        .byte   $1B,$1C,$01,$01,$1C,$1D,$01,$01,$1F,$1C,$01,$01,$1C,$0F,$01,$01 ; B2C0  blocks $30-$33
        .byte   $12,$1C,$01,$01,$1C,$1C,$01,$01,$1C,$71,$01,$01,$7B,$7C,$83,$84 ; B2D0  blocks $34-$37
        .byte   $7D,$7E,$85,$86,$00,$7F,$00,$00,$80,$81,$00,$00,$82,$87,$00,$00 ; B2E0  blocks $38-$3B
        .byte   $88,$00,$00,$00,$A7,$A7,$A7,$A7,$A7,$A7,$AB,$AC,$A5,$A6,$AD,$AE ; B2F0  blocks $3C-$3F
        .byte   $A7,$A7,$AF,$A7,$B3,$B4,$BB,$BC,$B5,$B6,$BD,$BE,$B7,$A7,$BF,$A7 ; B300  blocks $40-$43
        .byte   $A0,$A1,$E0,$E1,$A2,$A3,$E2,$E3,$A0,$A1,$E4,$E5,$A2,$A3,$E6,$00 ; B310  blocks $44-$47
        .byte   $C0,$C1,$00,$C9,$C2,$C3,$CA,$CB,$C4,$C5,$CC,$CD,$C6,$C7,$CE,$CF ; B320  blocks $48-$4B
        .byte   $E8,$E9,$F0,$F1,$EA,$EB,$F2,$F3,$EC,$ED,$F4,$F5,$EE,$00,$F6,$F7 ; B330  blocks $4C-$4F
        .byte   $D0,$D1,$D8,$F9,$D2,$D3,$DA,$DB,$D4,$D5,$DC,$DD,$D6,$D7,$DE,$F8 ; B340  blocks $50-$53
        .byte   $FA,$F9,$A8,$A9,$FC,$FB,$B0,$B1,$B0,$DA,$B8,$B9,$C8,$FC,$AA,$FA ; B350  blocks $54-$57
        .byte   $FA,$FA,$A8,$A9,$FA,$FC,$FD,$FE,$F8,$FC,$FF,$AA,$F8,$FA,$A8,$A9 ; B360  blocks $58-$5B
        .byte   $FA,$FA,$FA,$FA,$B8,$B9,$FA,$FA,$B2,$FA,$FA,$FA,$E7,$EF,$FA,$FA ; B370  blocks $5C-$5F
        .byte   $FA,$B2,$FA,$FA,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B380  blocks $60-$63
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B390  blocks $64-$67
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B3A0  blocks $68-$6B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B3B0  blocks $6C-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B3C0  blocks $70-$73
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B3D0  blocks $74-$77
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B3E0  blocks $78-$7B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B3F0  blocks $7C-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B400  blocks $80-$83
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B410  blocks $84-$87
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B420  blocks $88-$8B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B430  blocks $8C-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B440  blocks $90-$93
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B450  blocks $94-$97
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B460  blocks $98-$9B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B470  blocks $9C-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B480  blocks $A0-$A3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B490  blocks $A4-$A7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B4A0  blocks $A8-$AB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B4B0  blocks $AC-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B4C0  blocks $B0-$B3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B4D0  blocks $B4-$B7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B4E0  blocks $B8-$BB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B4F0  blocks $BC-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B500  blocks $C0-$C3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B510  blocks $C4-$C7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B520  blocks $C8-$CB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B530  blocks $CC-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B540  blocks $D0-$D3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B550  blocks $D4-$D7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B560  blocks $D8-$DB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B570  blocks $DC-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B580  blocks $E0-$E3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B590  blocks $E4-$E7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5A0  blocks $E8-$EB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5B0  blocks $EC-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5C0  blocks $F0-$F3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5D0  blocks $F4-$F7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5E0  blocks $F8-$FB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5F0  blocks $FC-$FF
; --- $B600: screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; B600
        .byte   $08,$10,$11,$12,$13,$14,$15,$0F,$08,$16,$17,$18,$19,$1A,$1B,$0F ; B610
        .byte   $08,$1C,$1D,$1E,$1F,$20,$1C,$21,$22,$23,$24,$25,$26,$26,$26,$27 ; B620
        .byte   $28,$29,$2A,$2B,$2C,$2D,$2E,$2F,$30,$31,$32,$33,$34,$35,$35,$36 ; B630
; layout $01
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B640
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$37,$38,$1C,$1C,$1C ; B650
        .byte   $1C,$1C,$39,$3A,$3B,$3C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B660
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B670
; layout $02
        .byte   $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D ; B680
        .byte   $3D,$3D,$3D,$3D,$3D,$3E,$3F,$40,$3D,$3D,$3D,$3D,$3D,$41,$42,$43 ; B690
        .byte   $44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F,$50,$51,$52,$53 ; B6A0
        .byte   $54,$55,$56,$57,$58,$59,$5A,$5B,$5C,$5D,$5C,$5E,$5C,$5F,$60,$5C ; B6B0
; layout $03
        .byte   $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D ; B6C0
        .byte   $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D ; B6D0
        .byte   $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D ; B6E0
        .byte   $3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D ; B6F0
; layout $04
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B700
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B710
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B720
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B730
; layout $05
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B740
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B750
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B760
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B770
; layout $06
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B780
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B790
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B7A0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B7B0
; layout $07
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B7C0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B7D0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B7E0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B7F0
; layout $08
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B800
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B810
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B820
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B830
; layout $09
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B840
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B850
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B860
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B870
; layout $0A
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B880
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B890
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B8A0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B8B0
; layout $0B
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B8C0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B8D0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B8E0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B8F0
; layout $0C
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B900
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B910
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B920
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B930
; layout $0D
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B940
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B950
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B960
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B970
; layout $0E
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B980
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B990
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B9A0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B9B0
; layout $0F
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B9C0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B9D0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B9E0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; B9F0
; layout $10
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BA00
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BA10
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BA20
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BA30
; layout $11
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BA40
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BA50
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BA60
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BA70
; layout $12
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BA80
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BA90
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BAA0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BAB0
; layout $13
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BAC0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BAD0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BAE0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BAF0
; layout $14
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BB00
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BB10
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BB20
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BB30
; layout $15
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BB40
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BB50
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BB60
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BB70
; layout $16
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BB80
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BB90
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BBA0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BBB0
; layout $17
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BBC0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BBD0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BBE0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BBF0
; layout $18
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BC00
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BC10
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BC20
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BC30
; layout $19
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BC40
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BC50
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BC60
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BC70
; layout $1A
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BC80
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BC90
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BCA0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BCB0
; layout $1B
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BCC0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BCD0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BCE0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BCF0
; layout $1C
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BD00
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BD10
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BD20
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BD30
; layout $1D
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BD40
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BD50
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BD60
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BD70
; layout $1E
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BD80
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BD90
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BDA0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BDB0
; layout $1F
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BDC0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BDD0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BDE0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BDF0
; layout $20
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BE00
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BE10
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BE20
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BE30
; layout $21
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BE40
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BE50
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BE60
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BE70
; layout $22
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BE80
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BE90
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BEA0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BEB0
; layout $23
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BEC0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BED0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BEE0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BEF0
; layout $24
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BF00
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BF10
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BF20
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BF30
; layout $25
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BF40
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BF50
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BF60
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BF70
; layout $26
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BF80
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BF90
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BFA0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BFB0
; layout $27
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BFC0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BFD0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BFE0
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C ; BFF0
