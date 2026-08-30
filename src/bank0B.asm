.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK0B"

; =============================================================================
; BANK $0B — STAGE-LOAD SERVICE + PROTO CASTLE 4 STAGE DATA
; $8000: boss-rush teleporter-room draw (stage $0E screen $03 — door
; states from the re-beaten bitmask $6B), called from stage_load
; ($1E:D44D). $814D: stage-load-time service, called for every stage
; ($1E:D43E) with the stage data bank at $A000.
; $8800 (rt $A800): Rush Jet damage table. Data half (file +$0900 on):
; stage $0B (Proto castle 4) stage data — screen table at $8900
; (rt $A900); format in DATA_REFERENCE.md section 11. Also the
; block/metatile art bank for the story-intro screens ($27=$0B).
; =============================================================================

; =============================================================================
; BOSS-RUSH TELEPORTER-ROOM DRAW — called from stage_load ($1E:D44D) when
; loading stage $0E screen $03. Walks the re-beaten bitmask $6B (bit set =
; boss re-beaten): for each set bit, queues the door-fill packets (L80AB
; template + per-pod PPU address/tile rows L80CD/L80CE, attr byte L80CF),
; flushes the buffer, and marks the pod's spawn bit in the $0100 no-respawn
; bitmap ($AD = base spawn index, 3 list entries per pod). The tail seeds
; the dynamic tile-override records ($06C0, L812C seed block) and the
; L80E5 packet so closed doors also collide.
; =============================================================================
        lda     $6B                             ; 8000 A5 6B                    .k
        sta     $10                             ; 8002 85 10                    ..
        lda     $AD                             ; 8004 A5 AD                    ..
        sta     $11                             ; 8006 85 11                    ..
        lda     #$15                            ; 8008 A9 15                    ..
        sta     $12                             ; 800A 85 12                    ..
L800C:  lsr     $10                             ; 800C 46 10                    F.
        bcc     L8062                           ; 800E 90 52                    .R
        ldy     #$21                            ; 8010 A0 21                    .!
L8012:  lda     L80AB,y                         ; 8012 B9 AB 80                 ...
        sta     $0780,y                         ; 8015 99 80 07                 ...
        dey                                     ; 8018 88                       .
        bpl     L8012                           ; 8019 10 F7                    ..
        ldy     $12                             ; 801B A4 12                    ..
        lda     L80CD,y                         ; 801D B9 CD 80                 ...
        sta     $0780                           ; 8020 8D 80 07                 ...
        sta     $0787                           ; 8023 8D 87 07                 ...
        sta     $078E                           ; 8026 8D 8E 07                 ...
        sta     $0795                           ; 8029 8D 95 07                 ...
        lda     L80CE,y                         ; 802C B9 CE 80                 ...
        sta     $0781                           ; 802F 8D 81 07                 ...
        clc                                     ; 8032 18                       .
        adc     #$20                            ; 8033 69 20                    i 
        sta     $0788                           ; 8035 8D 88 07                 ...
        adc     #$20                            ; 8038 69 20                    i 
        sta     $078F                           ; 803A 8D 8F 07                 ...
        adc     #$20                            ; 803D 69 20                    i 
        sta     $0796                           ; 803F 8D 96 07                 ...
        lda     L80CF,y                         ; 8042 B9 CF 80                 ...
        ora     $079D                           ; 8045 0D 9D 07                 ...
        sta     $079D                           ; 8048 8D 9D 07                 ...
        jsr     nametable_flush                           ; 804B 20 98 C2                  ..
        lda     $11                             ; 804E A5 11                    ..
        and     #$07                            ; 8050 29 07                    ).
        tax                                     ; 8052 AA                       .
        lda     $11                             ; 8053 A5 11                    ..
        lsr     a                               ; 8055 4A                       J
        lsr     a                               ; 8056 4A                       J
        lsr     a                               ; 8057 4A                       J
        tay                                     ; 8058 A8                       .
        lda     $0100,y                         ; 8059 B9 00 01                 ...
        ora     $F2B2,x                         ; 805C 1D B2 F2                 ...
        sta     $0100,y                         ; 805F 99 00 01                 ...
L8062:  inc     $11                             ; 8062 E6 11                    ..
        dec     $12                             ; 8064 C6 12                    ..
        dec     $12                             ; 8066 C6 12                    ..
        dec     $12                             ; 8068 C6 12                    ..
        bpl     L800C                           ; 806A 10 A0                    ..
        lda     $11                             ; 806C A5 11                    ..
        and     #$07                            ; 806E 29 07                    ).
        tax                                     ; 8070 AA                       .
        lda     $11                             ; 8071 A5 11                    ..
        lsr     a                               ; 8073 4A                       J
        lsr     a                               ; 8074 4A                       J
        lsr     a                               ; 8075 4A                       J
        tay                                     ; 8076 A8                       .
        lda     $0100,y                         ; 8077 B9 00 01                 ...
        ora     $F2B2,x                         ; 807A 1D B2 F2                 ...
        sta     $0100,y                         ; 807D 99 00 01                 ...
        lda     $6B                             ; 8080 A5 6B                    .k
        cmp     #$FF                            ; 8082 C9 FF                    ..
        bne     L80AA                           ; 8084 D0 24                    .$
        lda     $0100,y                         ; 8086 B9 00 01                 ...
        and     $F2BA,x                         ; 8089 3D BA F2                 =..
        sta     $0100,y                         ; 808C 99 00 01                 ...
        ldy     #$20                            ; 808F A0 20                    . 
        sty     $43                             ; 8091 84 43                    .C
L8093:  lda     L812C,y                         ; 8093 B9 2C 81                 .,.
        sta     $06BF,y                         ; 8096 99 BF 06                 ...
        dey                                     ; 8099 88                       .
        bpl     L8093                           ; 809A 10 F7                    ..
        ldy     #$47                            ; 809C A0 47                    .G
L809E:  lda     L80E5,y                         ; 809E B9 E5 80                 ...
        sta     $0780,y                         ; 80A1 99 80 07                 ...
        dey                                     ; 80A4 88                       .
        bpl     L809E                           ; 80A5 10 F7                    ..
        jsr     nametable_flush                           ; 80A7 20 98 C2                  ..
L80AA:  rts                                     ; 80AA 60                       `

; ----------------------------------------------------------------------------

; --- $80AB: door draw data: $22-byte packet template (L80AB), per-pod PPU
; addr hi/lo + attr rows (L80CD/L80CE/L80CF, 3 bytes apart per pod), fill
; packet (L80E5), tile-override seed block (L812C -> $06C0) ---
L80AB:  .byte   $20,$00,$03,$28,$29,$30,$31,$20 ; 80AB 20 00 03 28 29 30 31 20   ..()01 
        .byte   $00,$03,$60,$61,$62,$63,$20,$00 ; 80B3 00 03 60 61 62 63 20 00  ..`abc .
        .byte   $03,$1C,$1D,$1E,$1F,$20,$00,$03 ; 80BB 03 1C 1D 1E 1F 20 00 03  ..... ..
        .byte   $0E,$0F,$6E,$6F,$23,$C0,$01,$44 ; 80C3 0E 0F 6E 6F 23 C0 01 44  ..no#..D
        .byte   $11,$FF                         ; 80CB 11 FF                    ..
L80CD:  .byte   $22                             ; 80CD 22                       "
L80CE:  .byte   $9A                             ; 80CE 9A                       .
L80CF:  .byte   $2E,$21,$9A,$1E,$20,$9A,$0E,$22 ; 80CF 2E 21 9A 1E 20 9A 0E 22  .!.. .."
        .byte   $8E,$2B,$21,$8E,$1B,$22,$82,$28 ; 80D7 8E 2B 21 8E 1B 22 82 28  .+!..".(
        .byte   $21,$82,$18,$20,$82,$08         ; 80DF 21 82 18 20 82 08        !.. ..
L80E5:  .byte   $20,$4E,$03,$08,$09,$0A,$0B,$20 ; 80E5 20 4E 03 08 09 0A 0B 20   N..... 
        .byte   $6E,$03,$18,$19,$1A,$1B,$20,$8E ; 80ED 6E 03 18 19 1A 1B 20 8E  n..... .
        .byte   $03,$28,$29,$2A,$2B,$20,$AE,$03 ; 80F5 03 28 29 2A 2B 20 AE 03  .()*+ ..
        .byte   $38,$39,$3A,$3B,$20,$CE,$03,$48 ; 80FD 38 39 3A 3B 20 CE 03 48  89:; ..H
        .byte   $49,$4A,$4B,$20,$EE,$03,$58,$59 ; 8105 49 4A 4B 20 EE 03 58 59  IJK ..XY
        .byte   $5A,$5B,$21,$0E,$03,$68,$69,$6A ; 810D 5A 5B 21 0E 03 68 69 6A  Z[!..hij
        .byte   $6B,$21,$2E,$03,$78,$79,$7A,$7B ; 8115 6B 21 2E 03 78 79 7A 7B  k!..xyz{
        .byte   $23,$C3,$01,$6A,$9A,$23,$CB,$01 ; 811D 23 C3 01 6A 9A 23 CB 01  #..j.#..
        .byte   $44,$11,$23,$D3,$01,$56,$59     ; 8125 44 11 23 D3 01 56 59     D.#..VY
L812C:  .byte   $FF,$03,$03,$03,$06,$03,$04,$02 ; 812C FF 03 03 03 06 03 04 02  ........
        .byte   $07,$03,$0B,$01,$0E,$03,$0C,$00 ; 8134 07 03 0B 01 0E 03 0C 00  ........
        .byte   $0F,$03,$0B,$03,$16,$03,$0C,$02 ; 813C 0F 03 0B 03 16 03 0C 02  ........
        .byte   $17,$03,$13,$01,$1E,$03,$14,$00 ; 8144 17 03 13 01 1E 03 14 00  ........
        .byte   $1F                             ; 814C 1F                       .
; ----------------------------------------------------------------------------

; =============================================================================
; STAGE-LOAD ENVIRONMENT SERVICE — called for every stage ($1E:D43E) with the
; stage data bank at $A000. $68 = requested environment record (0 = none,
; cleared after use): pointer = L8194/L81A8 + $68 (1-indexed, lo table
; overlapping the rts). Record ($18 bytes): [R0 CHR bank -> $EA, R1 -> $EB,
; (unused), BG CHR-anim program -> $05D0, 16 BG master palette bytes ->
; $0620+, 4 palette-cycle slot seeds -> $05F0+ ($05F4/$05F8 counters
; cleared)]. Set by stage code to swap art/palettes mid-game (castle maps,
; boss rush).
; =============================================================================
        ldy     $68                             ; 814D A4 68                    .h
        beq     L8194                           ; 814F F0 43                    .C
        lda     L8194,y                         ; 8151 B9 94 81                 ...
        sta     $00                             ; 8154 85 00                    ..
        lda     L81A8,y                         ; 8156 B9 A8 81                 ...
        sta     $01                             ; 8159 85 01                    ..
        ldy     #$00                            ; 815B A0 00                    ..
        sty     $68                             ; 815D 84 68                    .h
        lda     ($00),y                         ; 815F B1 00                    ..
        sta     $EA                             ; 8161 85 EA                    ..
        iny                                     ; 8163 C8                       .
        lda     ($00),y                         ; 8164 B1 00                    ..
        sta     $EB                             ; 8166 85 EB                    ..
        iny                                     ; 8168 C8                       .
        iny                                     ; 8169 C8                       .
        lda     ($00),y                         ; 816A B1 00                    ..
        sta     $05D0                           ; 816C 8D D0 05                 ...
        lda     #$00                            ; 816F A9 00                    ..
        sta     $05D2                           ; 8171 8D D2 05                 ...
        sta     $05D1                           ; 8174 8D D1 05                 ...
        iny                                     ; 8177 C8                       .
L8178:  lda     ($00),y                         ; 8178 B1 00                    ..
        sta     $061C,y                         ; 817A 99 1C 06                 ...
        iny                                     ; 817D C8                       .
        cpy     #$14                            ; 817E C0 14                    ..
        bne     L8178                           ; 8180 D0 F6                    ..
L8182:  lda     ($00),y                         ; 8182 B1 00                    ..
        sta     $05DC,y                         ; 8184 99 DC 05                 ...
        lda     #$00                            ; 8187 A9 00                    ..
        sta     $05E4,y                         ; 8189 99 E4 05                 ...
        sta     $05E0,y                         ; 818C 99 E0 05                 ...
        iny                                     ; 818F C8                       .
        cpy     #$18                            ; 8190 C0 18                    ..
        bne     L8182                           ; 8192 D0 EE                    ..
L8194:  rts                                     ; 8194 60                       `

; ----------------------------------------------------------------------------

; --- $8195: environment records: lo/hi pointer tables (1-indexed off L8194/
; L81A8), then the $18-byte records ($81BD + $18*n) ---
        .byte   $BD,$D5,$ED,$05,$1D,$35,$4D,$65 ; 8195 BD D5 ED 05 1D 35 4D 65  .....5Me
        .byte   $7D,$95,$AD,$C5,$DD,$F5,$0D,$25 ; 819D 7D 95 AD C5 DD F5 0D 25  }......%
        .byte   $3D,$55,$6D                     ; 81A5 3D 55 6D                 =Um
L81A8:  .byte   $85,$81,$81,$81,$82,$82,$82,$82 ; 81A8 85 81 81 81 82 82 82 82  ........
        .byte   $82,$82,$82,$82,$82,$82,$82,$83 ; 81B0 82 82 82 82 82 82 82 83  ........
        .byte   $83,$83,$83,$83,$83,$80,$82,$00 ; 81B8 83 83 83 83 83 80 82 00  ........
        .byte   $00,$0F,$16,$20,$00,$0F,$2C,$1C ; 81C0 00 0F 16 20 00 0F 2C 1C  ... ..,.
        .byte   $0C,$0F,$20,$27,$17,$0F,$16,$1B ; 81C8 0C 0F 20 27 17 0F 16 1B  .. '....
        .byte   $0B,$00,$00,$00,$80,$84,$7A,$00 ; 81D0 0B 00 00 00 80 84 7A 00  ......z.
        .byte   $00,$0F,$20,$10,$11,$0F,$20,$1C ; 81D8 00 0F 20 10 11 0F 20 1C  .. ... .
        .byte   $21,$0F,$10,$1C,$0C,$0F,$10,$00 ; 81E0 21 0F 10 1C 0C 0F 10 00  !.......
        .byte   $08,$00,$00,$00,$00,$84,$86,$00 ; 81E8 08 00 00 00 00 84 86 00  ........
        .byte   $00,$0F,$20,$10,$11,$0F,$20,$27 ; 81F0 00 0F 20 10 11 0F 20 27  .. ... '
        .byte   $18,$0F,$2C,$20,$1C,$0F,$10,$00 ; 81F8 18 0F 2C 20 1C 0F 10 00  .., ....
        .byte   $08,$00,$00,$89,$00,$88,$FA,$00 ; 8200 08 00 00 89 00 88 FA 00  ........
        .byte   $00,$0F,$39,$27,$17,$0F,$19,$09 ; 8208 00 0F 39 27 17 0F 19 09  ..9'....
        .byte   $06,$0F,$20,$26,$16,$0F,$20,$21 ; 8210 06 0F 20 26 16 0F 20 21  .. &.. !
        .byte   $12,$00,$00,$00,$00,$88,$FA,$00 ; 8218 12 00 00 00 00 88 FA 00  ........
        .byte   $00,$0F,$39,$27,$17,$0F,$1C,$0C ; 8220 00 0F 39 27 17 0F 1C 0C  ..9'....
        .byte   $05,$0F,$20,$26,$16,$0F,$20,$21 ; 8228 05 0F 20 26 16 0F 20 21  .. &.. !
        .byte   $12,$00,$00,$00,$00,$8C,$8E,$00 ; 8230 12 00 00 00 00 8C 8E 00  ........
        .byte   $80,$21,$30,$28,$0F,$21,$30,$2B ; 8238 80 21 30 28 0F 21 30 2B  .!0(.!0+
        .byte   $0F,$21,$30,$27,$0F,$21,$30,$30 ; 8240 0F 21 30 27 0F 21 30 30  .!0'.!00
        .byte   $3C,$00,$00,$00,$81,$90,$F8,$00 ; 8248 3C 00 00 00 81 90 F8 00  <.......
        .byte   $00,$0F,$20,$23,$13,$0F,$2C,$1C ; 8250 00 0F 20 23 13 0F 2C 1C  .. #..,.
        .byte   $01,$0F,$20,$10,$1A,$0F,$38,$28 ; 8258 01 0F 20 10 1A 0F 38 28  .. ...8(
        .byte   $15,$00,$00,$00,$00,$94,$F0,$00 ; 8260 15 00 00 00 00 94 F0 00  ........
        .byte   $00,$0F,$20,$11,$01,$0F,$20,$10 ; 8268 00 0F 20 11 01 0F 20 10  .. ... .
        .byte   $00,$0F,$21,$19,$09,$0F,$20,$27 ; 8270 00 0F 21 19 09 0F 20 27  ..!... '
        .byte   $17,$00,$00,$00,$00,$98,$9A,$00 ; 8278 17 00 00 00 00 98 9A 00  ........
        .byte   $85,$0F,$38,$27,$18,$0F,$27,$19 ; 8280 85 0F 38 27 18 0F 27 19  ..8'..'.
        .byte   $0B,$0F,$39,$27,$18,$0F,$24,$14 ; 8288 0B 0F 39 27 18 0F 24 14  ..9'..$.
        .byte   $03,$00,$00,$00,$00,$98,$9A,$00 ; 8290 03 00 00 00 00 98 9A 00  ........
        .byte   $85,$0F,$38,$27,$18,$0F,$04,$0F ; 8298 85 0F 38 27 18 0F 04 0F  ..8'....
        .byte   $25,$0F,$08,$08,$09,$0F,$3C,$2C ; 82A0 25 0F 08 08 09 0F 3C 2C  %.....<,
        .byte   $1C,$00,$9D,$00,$00,$9C,$9E,$00 ; 82A8 1C 00 9D 00 00 9C 9E 00  ........
        .byte   $00,$0F,$20,$01,$1C,$0F,$20,$11 ; 82B0 00 0F 20 01 1C 0F 20 11  .. ... .
        .byte   $01,$0F,$23,$12,$03,$0F,$20,$31 ; 82B8 01 0F 23 12 03 0F 20 31  ..#... 1
        .byte   $21,$82,$84,$00,$00,$9C,$68,$00 ; 82C0 21 82 84 00 00 9C 68 00  !.....h.
        .byte   $00,$0F,$20,$01,$1C,$0F,$20,$11 ; 82C8 00 0F 20 01 1C 0F 20 11  .. ... .
        .byte   $01,$0F,$23,$12,$03,$0F,$20,$10 ; 82D0 01 0F 23 12 03 0F 20 10  ..#... .
        .byte   $12,$82,$84,$00,$00,$A0,$A2,$00 ; 82D8 12 82 84 00 00 A0 A2 00  ........
        .byte   $00,$0F,$30,$22,$00,$0F,$35,$24 ; 82E0 00 0F 30 22 00 0F 35 24  ..0"..5$
        .byte   $14,$0F,$17,$08,$0A,$0F,$30,$28 ; 82E8 14 0F 17 08 0A 0F 30 28  ......0(
        .byte   $07,$00,$00,$00,$00,$A4,$A6,$00 ; 82F0 07 00 00 00 00 A4 A6 00  ........
        .byte   $00,$0F,$30,$10,$18,$0F,$30,$23 ; 82F8 00 0F 30 10 18 0F 30 23  ..0...0#
        .byte   $0C,$0F,$07,$18,$08,$0F,$30,$00 ; 8300 0C 0F 07 18 08 0F 30 00  ......0.
        .byte   $0B,$00,$00,$93,$00,$A8,$AA,$00 ; 8308 0B 00 00 93 00 A8 AA 00  ........
        .byte   $00,$0F,$30,$28,$07,$0F,$30,$2C ; 8310 00 0F 30 28 07 0F 30 2C  ..0(..0,
        .byte   $0C,$0F,$30,$2B,$0A,$0F,$17,$07 ; 8318 0C 0F 30 2B 0A 0F 17 07  ..0+....
        .byte   $08,$00,$00,$00,$00,$A4,$B2,$00 ; 8320 08 00 00 00 00 A4 B2 00  ........
        .byte   $82,$0F,$30,$23,$04,$0F,$30,$26 ; 8328 82 0F 30 23 04 0F 30 26  ..0#..0&
        .byte   $06,$0F,$30,$10,$00,$0F,$30,$1C ; 8330 06 0F 30 10 00 0F 30 1C  ..0...0.
        .byte   $02,$00,$00,$00,$00,$B4,$B6,$00 ; 8338 02 00 00 00 00 B4 B6 00  ........
        .byte   $00,$0F,$30,$10,$1C,$0F,$31,$21 ; 8340 00 0F 30 10 1C 0F 31 21  ..0...1!
        .byte   $11,$0F,$1C,$11,$01,$0F,$17,$14 ; 8348 11 0F 1C 11 01 0F 17 14  ........
        .byte   $04,$00,$00,$00,$83,$B8,$B0,$00 ; 8350 04 00 00 00 83 B8 B0 00  ........
        .byte   $00,$0F,$30,$22,$13,$0F,$30,$27 ; 8358 00 0F 30 22 13 0F 30 27  ..0"..0'
        .byte   $07,$0F,$30,$2C,$0C,$0F,$26,$11 ; 8360 07 0F 30 2C 0C 0F 26 11  ..0,..&.
        .byte   $0F,$00,$00,$00,$99,$B0,$B2,$00 ; 8368 0F 00 00 00 99 B0 B2 00  ........
        .byte   $00,$0F,$30,$23,$04,$0F,$30,$26 ; 8370 00 0F 30 23 04 0F 30 26  ..0#..0&
        .byte   $06,$0F,$30,$10,$00,$0F,$30,$1C ; 8378 06 0F 30 10 00 0F 30 1C  ..0...0.
        .byte   $02,$00,$00,$00,$00,$B4,$B6,$00 ; 8380 02 00 00 00 00 B4 B6 00  ........
        .byte   $00,$0F,$30,$10,$1C,$0F,$31,$21 ; 8388 00 0F 30 10 1C 0F 31 21  ..0...1!
        .byte   $11,$0F,$30,$2A,$0A,$0F,$17,$14 ; 8390 11 0F 30 2A 0A 0F 17 14  ..0*....
        .byte   $04,$00,$00,$00,$83,$FF,$FF,$FF ; 8398 04 00 00 00 83 FF FF FF  ........
        .byte   $FF,$FF,$EF,$FF,$FF,$FF,$FF,$FF ; 83A0 FF FF EF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$EF,$FF,$FE,$FF ; 83A8 FF FF FF FF EF FF FE FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 83B0 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 83B8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 83C0 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 83C8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 83D0 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF ; 83D8 FF FF FF FF FF FF FE FF  ........
        .byte   $FF,$FF,$EF,$FF,$FB,$FF,$FF,$FF ; 83E0 FF FF EF FF FB FF FF FF  ........
        .byte   $EE,$FF,$BF,$FF,$FF,$FF,$FF,$FF ; 83E8 EE FF BF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FB,$FF,$EA,$FF ; 83F0 FF FF FF FF FB FF EA FF  ........
        .byte   $FF,$FF,$EB,$FF,$BF,$FF,$FE,$FF ; 83F8 FF FF EB FF BF FF FE FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8400 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$DF,$FF,$FF ; 8408 FF FF FF FF FF DF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F ; 8410 FF FF FF FF FF FF FF 7F  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F ; 8418 FF FF FF FF FF FF FF 7F  ........
        .byte   $FF,$FD,$FB,$FF,$FF,$FF,$FF,$FF ; 8420 FF FD FB FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FD,$FF,$FD,$FF,$FF ; 8428 FF FF FF FD FF FD FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$7D,$FF,$FF ; 8430 FF FF FF FF FF 7D FF FF  .....}..
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F ; 8438 FF FF FF FF FF FF FF 7F  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8440 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8448 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$F7,$FF,$FF,$FF,$FF,$FF ; 8450 FF FF F7 FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8458 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$DF,$FF,$7F ; 8460 FF FF FF FF FF DF FF 7F  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8468 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8470 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$F7,$FF,$FF,$FF,$FF,$FF,$FF ; 8478 FF F7 FF FF FF FF FF FF  ........
        .byte   $FF,$F7,$FD,$F7,$FF,$FF,$FF,$FF ; 8480 FF F7 FD F7 FF FF FF FF  ........
        .byte   $FF,$7F,$FF,$FF,$FF,$FF,$FF,$DF ; 8488 FF 7F FF FF FF FF FF DF  ........
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF ; 8490 FF FF FF 7F FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FD,$FF,$7F,$FF,$FF ; 8498 FF FF FF FD FF 7F FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 84A0 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$DF,$BF,$FF,$FF,$FF ; 84A8 FF FF FF DF BF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FD,$FF,$FF,$FF,$FF ; 84B0 FF FF FF FD FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 84B8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$7F,$FF,$FD,$FF,$DD,$FF,$FD ; 84C0 FF 7F FF FD FF DD FF FD  ........
        .byte   $FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF ; 84C8 FF FD FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$EF,$FF,$FF,$77,$FF,$FF ; 84D0 FF FF EF FF FF 77 FF FF  .....w..
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 84D8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 84E0 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 84E8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$7F,$FF,$7F ; 84F0 FF FF FF FF FF 7F FF 7F  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 84F8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8500 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$DF,$FF,$F7 ; 8508 FF FF FF FF FF DF FF F7  ........
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF ; 8510 FF FF FF 7F FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FD,$FF,$DF,$FF,$FD ; 8518 FF FF FF FD FF DF FF FD  ........
        .byte   $FF,$FF,$FF,$57,$FF,$FF,$FF,$FF ; 8520 FF FF FF 57 FF FF FF FF  ...W....
        .byte   $FF,$7F,$FF,$F7,$FF,$FF,$FF,$FF ; 8528 FF 7F FF F7 FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8530 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF ; 8538 FF FF FF FF FF FF FE FF  ........
        .byte   $FF,$FD,$FF,$5F,$FF,$FF,$FF,$7F ; 8540 FF FD FF 5F FF FF FF 7F  ..._....
        .byte   $FF,$DF,$FF,$FF,$FF,$FF,$FF,$FF ; 8548 FF DF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF ; 8550 FF FF FF FF FF FF FF DF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$F6 ; 8558 FF FF FF FF FF FF FF F6  ........
        .byte   $FF,$FF,$FF,$FD,$FF,$FF,$FF,$F7 ; 8560 FF FF FF FD FF FF FF F7  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8568 FF FF FF FF FF FF FF FF  ........
        .byte   $7F,$7F,$FF,$FF,$FF,$FF,$FF,$FF ; 8570 7F 7F FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF ; 8578 FF FF FF 7F FF FF FF FF  ........
        .byte   $FF,$FF,$FD,$FF,$FF,$FF,$FF,$FF ; 8580 FF FF FD FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$F7,$FF,$7F,$FF,$FF ; 8588 FF FF FF F7 FF 7F FF FF  ........
        .byte   $FF,$D7,$FF,$FF,$FF,$FF,$FF,$FF ; 8590 FF D7 FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8598 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF ; 85A0 FF 7F FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD ; 85A8 FF FF FF FF FF FF FF FD  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 85B0 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 85B8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$DF,$FF,$FF ; 85C0 FF FF FF FF FF DF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 85C8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$7F,$FF,$FD,$FF,$FF,$FF,$FF ; 85D0 FF 7F FF FD FF FF FF FF  ........
        .byte   $FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF ; 85D8 FF 7F FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 85E0 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF ; 85E8 FF FF FF FF FF FD FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 85F0 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 85F8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FD,$FF,$FD,$FF,$FF,$FF,$FF ; 8600 FF FD FF FD FF FF FF FF  ........
        .byte   $FF,$DF,$FF,$F7,$FF,$FF,$FF,$FF ; 8608 FF DF FF F7 FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$7F,$FF,$FF ; 8610 FF FF FF FF FF 7F FF FF  ........
        .byte   $FF,$FF,$FF,$F7,$FF,$F7,$FF,$FF ; 8618 FF FF FF F7 FF F7 FF FF  ........
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF ; 8620 FF FF FF 7F FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8628 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8630 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$F7,$FF,$FF ; 8638 FF FF FF FF FF F7 FF FF  ........
        .byte   $FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF ; 8640 FF 7F FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$DF,$FF,$FF,$FF,$FF ; 8648 FF FF FF DF FF FF FF FF  ........
        .byte   $FF,$F7,$FF,$DF,$FF,$FF,$FF,$7F ; 8650 FF F7 FF DF FF FF FF 7F  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8658 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$F7 ; 8660 FF FF FF FF FF FF FF F7  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$DF,$FF,$FF ; 8668 FF FF FF FF FF DF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8670 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8678 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$7F,$FF,$FF,$FF,$FD,$FF,$FF ; 8680 FF 7F FF FF FF FD FF FF  ........
        .byte   $FF,$DF,$FF,$FF,$FF,$FF,$FF,$FF ; 8688 FF DF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8690 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$DF,$FF,$FF,$FF,$FF ; 8698 FF FF FF DF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$DF,$FF,$FF ; 86A0 FF FF FF FF FF DF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F ; 86A8 FF FF FF FF FF FF FF 7F  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 86B0 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 86B8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$DF,$FF,$7F,$FF,$FF,$FF,$FF ; 86C0 FF DF FF 7F FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 86C8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 86D0 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 86D8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 86E0 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF ; 86E8 FF FD FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 86F0 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 86F8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$7F,$FF,$7F,$FF,$F7 ; 8700 FF FF FF 7F FF 7F FF F7  ........
        .byte   $DD,$FF,$FF,$FF,$FF,$D7,$FF,$FF ; 8708 DD FF FF FF FF D7 FF FF  ........
        .byte   $FF,$F7,$FF,$FF,$FF,$DF,$FF,$FF ; 8710 FF F7 FF FF FF DF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$DF,$FF,$DF ; 8718 FF FF FF FF FF DF FF DF  ........
        .byte   $FF,$F7,$FF,$7F,$FF,$FF,$FF,$FF ; 8720 FF F7 FF 7F FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$DF,$FF,$FF,$FF,$F7 ; 8728 FF FF FF DF FF FF FF F7  ........
        .byte   $FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF ; 8730 FF FD FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF ; 8738 FF FF FF 7F FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD ; 8740 FF FF FF FF FF FF FF FD  ........
        .byte   $FB,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8748 FB FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$DF,$FF,$FF ; 8750 FF FF FF FF FF DF FF FF  ........
        .byte   $FF,$F7,$FF,$FF,$FF,$FF,$FF,$FF ; 8758 FF F7 FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF ; 8760 FF FF FF 7F FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$7F,$FF,$DF,$FF,$FF ; 8768 FF FF FF 7F FF DF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$EF,$EF,$FF,$FF ; 8770 FF FF FF FF EF EF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 8778 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$DF,$FF,$F7,$FF,$FF ; 8780 FF FF FF DF FF F7 FF FF  ........
        .byte   $FF,$FF,$FF,$DF,$FF,$7F,$FF,$DD ; 8788 FF FF FF DF FF 7F FF DD  ........
        .byte   $FF,$7F,$FF,$F7,$FF,$FF,$FF,$FF ; 8790 FF 7F FF F7 FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$F7,$FF,$FF,$FF,$FF ; 8798 FF FF FF F7 FF FF FF FF  ........
        .byte   $FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF ; 87A0 FF FD FF FF FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD ; 87A8 FF FF FF FF FF FF FF FD  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$7F,$FF,$F5 ; 87B0 FF FF FF FF FF 7F FF F5  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 87B8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$77,$FF,$FF,$FF,$FF,$FF,$FF ; 87C0 FF 77 FF FF FF FF FF FF  .w......
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; 87C8 FF FF FF FF FF FF FF FF  ........
        .byte   $FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF ; 87D0 FF 7F FF FF FF FF FF FF  ........
        .byte   $FF,$DF,$FF,$FF,$FF,$FF,$FF,$7F ; 87D8 FF DF FF FF FF FF FF 7F  ........
        .byte   $FF,$FD,$FF,$FF,$FF,$7F,$FF,$FF ; 87E0 FF FD FF FF FF 7F FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$F7,$FF,$FF ; 87E8 FF FF FF FF FF F7 FF FF  ........
        .byte   $FF,$FF,$FF,$F7,$FF,$FF,$FF,$FF ; 87F0 FF FF FF F7 FF FF FF FF  ........
        .byte   $FF,$FF,$FF,$FF,$FF,$F5,$FF,$FF ; 87F8 FF FF FF FF FF F5 FF FF  ........

; --- $8800 (rt $A800): DAMAGE TABLE, weapon $B (Rush Jet) ---
; $A800[ent_type] via damage_engine $1C:809D; low 7 bits = damage,
; bit 7 = special handling; $00 = ricochet. Types $00-$CF.
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8800  types $00-$0F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$01 ; 8810  types $10-$1F
        .byte   $01,$01,$00,$00,$00,$01,$00,$00,$01,$01,$01,$01,$00,$01,$00,$00 ; 8820  types $20-$2F
        .byte   $00,$01,$01,$01,$01,$01,$01,$00,$01,$01,$01,$01,$00,$00,$01,$00 ; 8830  types $30-$3F
        .byte   $01,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 ; 8840  types $40-$4F
        .byte   $01,$00,$01,$01,$01,$00,$01,$00,$00,$01,$01,$00,$01,$01,$00,$01 ; 8850  types $50-$5F
        .byte   $01,$00,$01,$01,$01,$01,$01,$01,$01,$01,$00,$01,$00,$00,$01,$00 ; 8860  types $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$00,$00,$00 ; 8870  types $70-$7F
        .byte   $00,$01,$00,$01,$00,$00,$01,$00,$01,$01,$00,$00,$00,$01,$00,$00 ; 8880  types $80-$8F
        .byte   $00,$01,$01,$01,$00,$00,$01,$00,$01,$01,$00,$00,$01,$00,$01,$00 ; 8890  types $90-$9F
        .byte   $01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00 ; 88A0  types $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$00 ; 88B0  types $B0-$BF
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 88C0  types $C0-$CF
; --- $88D0 (rt $A8D0): remainder (beyond type $CF) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 88D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 88E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 88F0

; =============================================================================
; PROTO CASTLE 4 STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $8900 (rt $A900): screen -> layout index ---
        .byte   $17,$18,$19,$1A,$17,$1A,$1C,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8900  screens $00-$0F
        .byte   $00,$00,$00,$00,$00,$00,$80,$00,$00,$08,$00,$00,$00,$00,$00,$00 ; 8910  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8920  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00 ; 8930  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8940  screens $40-$4F
; --- $8950 (rt $A950): section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $80,$80,$A0,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8950
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8960
; --- $8968 (rt $A968): per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $00,$00,$00,$B0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8968
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8978
; --- $8980 (rt $A980): BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $A0,$AE,$00,$00,$00,$00,$00,$20 ; 8980
; --- $8988 (rt $A988): palette sets, 20 bytes each [16 BG palette + 4 palette-cycle
; seeds]: set n at +20n; set 0 is loaded by stage_load, later sets are
; switched per section by the bank $00 environment service
; ($A968 attr bits 0-5 -> $00:809E records, ctl bit 7) ---
        .byte   $0F,$30,$2B,$0C,$0F,$30,$28,$07,$0F,$13,$01,$0F,$0F,$30,$23,$07 ; 8988
        .byte   $00,$00,$92,$00,$00,$00,$00,$00 ; 8998
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 89A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 89B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 89C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 89D0
; --- $89E0 (rt $A9E0): screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 89E0  terminator / filler
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 89F0  
        .byte   $00                             ; 89FF  -1 base for the spawn arrays
; --- $8A00 (rt $AA00): spawn screens (ascending) ---
        .byte   $00,$03,$FF,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A00  entries $00-$0F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A10  entries $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00 ; 8A20  entries $20-$2F
        .byte   $80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A30  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00 ; 8A40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A70  entries $70-$7F
; --- $8A80 (rt $AA80): spawn X px ---
        .byte   $80,$D4,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00 ; 8A80  entries $00-$0F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A90  entries $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8AA0  entries $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00 ; 8AB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8AC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8AD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8AE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8AF0  entries $70-$7F
; --- $8B00 (rt $AB00): spawn Y px ---
        .byte   $C8,$B4,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B00  entries $00-$0F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00 ; 8B10  entries $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B20  entries $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B30  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00 ; 8B40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B70  entries $70-$7F
; --- $8B80 (rt $AB80): spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $55,$5E,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B80  entries $00-$0F
        .byte   $00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B90  entries $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8BA0  entries $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8BB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8BC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8BD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8BE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8BF0  entries $70-$7F
; --- $8C00 (rt $AC00): per-screen spawn-list start index ---
        .byte   $00,$01,$01,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C00  screens $00-$0F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C10  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00 ; 8C20  screens $20-$2F
        .byte   $00,$00,$80,$00,$00,$00,$00,$00,$00,$01,$00,$01,$00,$00,$00,$00 ; 8C30  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00 ; 8C40  screens $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C50  screens $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00 ; 8C60  screens $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00 ; 8C80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C90  screens $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00 ; 8CA0  screens $A0-$AF
        .byte   $08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00 ; 8CB0  screens $B0-$BF
        .byte   $00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CD0  screens $D0-$DF
        .byte   $04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00 ; 8CE0  screens $E0-$EF
        .byte   $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CF0  screens $F0-$FF
; --- $8D00 (rt $AD00): metatile top-left tile ids ---
        .byte   $00,$02,$02,$08,$0A,$0C,$0E,$01,$01,$03,$26,$18,$29,$18,$11,$30 ; 8D00  metatiles $00-$0F
        .byte   $2A,$01,$46,$18,$49,$18,$18,$22,$01,$32,$01,$1B,$53,$55,$57,$27 ; 8D10  metatiles $10-$1F
        .byte   $34,$2B,$2D,$2F,$00,$00,$00,$00,$10,$10,$10,$A7,$BC,$AB,$10,$8C ; 8D20  metatiles $20-$2F
        .byte   $80,$80,$80,$BD,$BD,$BA,$80,$8E,$01,$01,$94,$AD,$AD,$BA,$01,$AE ; 8D30  metatiles $30-$3F
        .byte   $90,$92,$B4,$AD,$AD,$BA,$88,$CE,$B0,$B2,$C4,$AD,$AD,$BA,$CC,$EE ; 8D40  metatiles $40-$4F
        .byte   $D0,$D2,$E4,$B6,$B8,$DA,$E6,$9A,$00,$00,$00,$63,$71,$00,$00,$00 ; 8D50  metatiles $50-$5F
        .byte   $00,$06,$08,$0A,$0C,$0E,$10,$00,$00,$1B,$1D,$1F,$4B,$4D,$4F,$82 ; 8D60  metatiles $60-$6F
        .byte   $27,$29,$2B,$01,$6B,$6D,$6F,$93,$00,$33,$34,$01,$8B,$8D,$8F,$A8 ; 8D70  metatiles $70-$7F
        .byte   $3D,$3F,$41,$01,$AB,$AD,$AF,$C5,$48,$4A,$51,$53,$CB,$CD,$CF,$D9 ; 8D80  metatiles $80-$8F
        .byte   $65,$67,$69,$E9,$EB,$ED,$EF,$F0,$78,$85,$94,$96,$00,$00,$AA,$B1 ; 8D90  metatiles $90-$9F
        .byte   $B3,$B5,$C7,$C8,$00,$E1,$80,$E3,$E5,$F9,$FB,$F2,$00,$00,$00,$00 ; 8DA0  metatiles $A0-$AF
        .byte   $10,$10,$2C,$3C,$36,$38,$3A,$01,$00,$10,$4C,$14,$14,$5A,$5C,$34 ; 8DB0  metatiles $B0-$BF
        .byte   $01,$16,$18,$1A,$01,$75,$77,$79,$30,$32,$01,$10,$58,$00,$00,$00 ; 8DC0  metatiles $C0-$CF
        .byte   $50,$52,$54,$56,$73,$00,$00,$00,$11,$11,$11,$0B,$00,$00,$00,$00 ; 8DD0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8DE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8DF0  metatiles $F0-$FF
; --- $8E00 (rt $AE00): metatile bottom-left tile ids ---
        .byte   $00,$02,$07,$09,$0B,$0D,$0F,$01,$01,$03,$18,$18,$18,$18,$14,$31 ; 8E00  metatiles $00-$0F
        .byte   $2A,$01,$18,$47,$18,$18,$18,$24,$01,$33,$1A,$1C,$54,$56,$11,$28 ; 8E10  metatiles $10-$1F
        .byte   $35,$2C,$2E,$11,$00,$00,$00,$00,$10,$10,$10,$A8,$AA,$10,$CD,$8D ; 8E20  metatiles $20-$2F
        .byte   $80,$80,$95,$BD,$BD,$80,$CD,$8F,$01,$01,$95,$AD,$AD,$01,$DD,$AF ; 8E30  metatiles $30-$3F
        .byte   $91,$93,$95,$AD,$AD,$01,$DD,$CF,$B1,$B3,$95,$AD,$AD,$BB,$E7,$EF ; 8E40  metatiles $40-$4F
        .byte   $D1,$D3,$E5,$B7,$B9,$DB,$ED,$9B,$00,$00,$00,$64,$72,$00,$00,$00 ; 8E50  metatiles $50-$5F
        .byte   $00,$07,$09,$0B,$0D,$0F,$11,$00,$1A,$1C,$1E,$01,$4C,$4E,$81,$83 ; 8E60  metatiles $60-$6F
        .byte   $28,$2A,$2C,$6A,$6C,$6E,$92,$01,$32,$01,$35,$8A,$8C,$8E,$01,$A9 ; 8E70  metatiles $70-$7F
        .byte   $3E,$40,$42,$01,$AC,$AE,$C4,$C6,$49,$50,$52,$CA,$CC,$CE,$D8,$E0 ; 8E80  metatiles $80-$8F
        .byte   $66,$68,$70,$EA,$EC,$EE,$FD,$F1,$84,$00,$95,$00,$00,$00,$B0,$B2 ; 8E90  metatiles $90-$9F
        .byte   $B4,$B6,$01,$C9,$00,$00,$E2,$E4,$00,$FA,$FC,$00,$00,$00,$00,$00 ; 8EA0  metatiles $A0-$AF
        .byte   $10,$2B,$3C,$3C,$37,$39,$01,$35,$00,$10,$14,$14,$6A,$5B,$05,$34 ; 8EB0  metatiles $B0-$BF
        .byte   $01,$17,$19,$01,$01,$76,$78,$7A,$31,$33,$01,$10,$59,$00,$00,$00 ; 8EC0  metatiles $C0-$CF
        .byte   $51,$53,$55,$57,$74,$00,$00,$00,$11,$60,$70,$1C,$00,$00,$00,$00 ; 8ED0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8EE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8EF0  metatiles $F0-$FF
; --- $8F00 (rt $AF00): metatile top-right tile ids ---
        .byte   $00,$12,$16,$18,$19,$18,$18,$20,$01,$13,$36,$18,$39,$18,$11,$40 ; 8F00  metatiles $00-$0F
        .byte   $11,$22,$4A,$4C,$38,$1D,$1F,$32,$24,$42,$58,$51,$53,$15,$05,$25 ; 8F10  metatiles $10-$1F
        .byte   $44,$3A,$3C,$3E,$00,$00,$00,$00,$81,$81,$81,$97,$98,$89,$81,$9C ; 8F20  metatiles $20-$2F
        .byte   $01,$01,$84,$AD,$AD,$BA,$01,$9E,$01,$01,$A4,$AD,$AD,$BA,$87,$BE ; 8F30  metatiles $30-$3F
        .byte   $A0,$A2,$B4,$AD,$AD,$BA,$86,$DE,$C0,$C2,$D4,$AD,$AD,$CA,$DC,$8A ; 8F40  metatiles $40-$4F
        .byte   $E0,$E2,$D6,$C6,$C8,$D8,$EC,$EA,$00,$00,$54,$00,$78,$00,$04,$00 ; 8F50  metatiles $50-$5F
        .byte   $00,$13,$15,$17,$01,$19,$74,$76,$20,$22,$24,$26,$5B,$5D,$5F,$87 ; 8F60  metatiles $60-$6F
        .byte   $00,$2E,$30,$01,$7B,$7D,$7F,$98,$36,$38,$3A,$3C,$9B,$9D,$9F,$B7 ; 8F70  metatiles $70-$7F
        .byte   $43,$45,$47,$01,$BB,$BD,$BF,$D1,$56,$58,$60,$62,$DB,$DD,$DF,$01 ; 8F80  metatiles $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$F3,$89,$91,$A0,$A2,$A4,$A6,$B9,$01 ; 8F90  metatiles $90-$9F
        .byte   $C1,$C3,$D3,$D5,$D7,$E8,$00,$F5,$F7,$00,$00,$00,$00,$00,$00,$00 ; 8FA0  metatiles $A0-$AF
        .byte   $10,$10,$04,$04,$46,$48,$4A,$4B,$00,$10,$08,$0A,$07,$01,$6C,$12 ; 8FB0  metatiles $B0-$BF
        .byte   $20,$26,$28,$2A,$01,$25,$03,$23,$40,$42,$44,$10,$68,$00,$00,$00 ; 8FC0  metatiles $C0-$CF
        .byte   $60,$62,$64,$66,$7B,$00,$00,$00,$11,$11,$72,$00,$00,$00,$00,$00 ; 8FD0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8FE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8FF0  metatiles $F0-$FF
; --- $9000 (rt $B000): metatile bottom-right tile ids ---
        .byte   $00,$12,$17,$18,$18,$18,$18,$21,$01,$13,$18,$37,$18,$18,$11,$41 ; 9000  metatiles $00-$0F
        .byte   $11,$23,$4B,$4D,$48,$1E,$4C,$33,$23,$43,$50,$52,$15,$04,$06,$11 ; 9010  metatiles $10-$1F
        .byte   $45,$3B,$3D,$3F,$00,$00,$00,$00,$81,$81,$96,$98,$99,$81,$CD,$9D ; 9020  metatiles $20-$2F
        .byte   $01,$01,$95,$AD,$AD,$01,$DD,$9F,$01,$01,$95,$AD,$AD,$01,$DD,$BF ; 9030  metatiles $30-$3F
        .byte   $A1,$A3,$95,$AD,$AD,$85,$DD,$DF,$C1,$C3,$D5,$AD,$AD,$CB,$ED,$8B ; 9040  metatiles $40-$4F
        .byte   $E1,$E3,$D7,$C7,$C9,$D9,$ED,$EB,$02,$00,$55,$00,$79,$03,$00,$00 ; 9050  metatiles $50-$5F
        .byte   $12,$14,$16,$01,$18,$73,$75,$77,$21,$23,$25,$5A,$5C,$5E,$86,$88 ; 9060  metatiles $60-$6F
        .byte   $2D,$2F,$31,$7A,$7C,$7E,$97,$99,$37,$01,$3B,$9A,$9C,$9E,$01,$B8 ; 9070  metatiles $70-$7F
        .byte   $44,$46,$01,$01,$BC,$BE,$D0,$D2,$57,$59,$61,$DA,$DC,$DE,$E6,$E7 ; 9080  metatiles $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$F4,$90,$00,$A1,$A3,$A5,$A7,$BA,$C0 ; 9090  metatiles $90-$9F
        .byte   $C2,$00,$D4,$D6,$00,$00,$05,$F6,$F8,$00,$00,$00,$00,$00,$00,$00 ; 90A0  metatiles $A0-$AF
        .byte   $10,$3B,$04,$04,$47,$49,$4B,$4B,$00,$16,$09,$06,$1B,$6B,$15,$13 ; 90B0  metatiles $B0-$BF
        .byte   $21,$27,$29,$01,$01,$02,$22,$24,$41,$43,$45,$10,$69,$00,$00,$00 ; 90C0  metatiles $C0-$CF
        .byte   $61,$63,$65,$67,$7C,$00,$00,$00,$11,$11,$71,$00,$00,$00,$00,$00 ; 90D0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 90E0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 90F0  metatiles $F0-$FF
; --- $9100 (rt $B100): metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$01 ; 9100  metatiles $00-$0F
        .byte   $00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$02,$02 ; 9110  metatiles $10-$1F
        .byte   $01,$01,$01,$01,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$01 ; 9120  metatiles $20-$2F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; 9130  metatiles $30-$3F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; 9140  metatiles $40-$4F
        .byte   $01,$01,$01,$00,$00,$00,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; 9150  metatiles $50-$5F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$03,$02,$02,$01,$01 ; 9160  metatiles $60-$6F
        .byte   $01,$01,$01,$03,$00,$02,$01,$01,$01,$01,$01,$03,$00,$00,$03,$01 ; 9170  metatiles $70-$7F
        .byte   $01,$01,$01,$01,$02,$00,$03,$01,$01,$01,$01,$03,$03,$03,$03,$01 ; 9180  metatiles $80-$8F
        .byte   $01,$01,$01,$03,$03,$03,$03,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; 9190  metatiles $90-$9F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$00 ; 91A0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$02,$02,$02,$02,$00,$00,$02,$02,$02,$00,$00,$03 ; 91B0  metatiles $B0-$BF
        .byte   $01,$00,$00,$02,$02,$00,$00,$03,$01,$01,$01,$00,$00,$00,$00,$00 ; 91C0  metatiles $C0-$CF
        .byte   $01,$01,$01,$00,$00,$00,$00,$00,$01,$01,$01,$00,$00,$00,$00,$00 ; 91D0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 91E0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 91F0  metatiles $F0-$FF
; --- $9200 (rt $B200): 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $00,$00,$00,$00,$00,$00,$01,$01,$00,$00,$01,$02,$00,$00,$03,$04 ; 9200  blocks $00-$03
        .byte   $00,$00,$05,$06,$09,$09,$08,$08,$09,$0A,$08,$12,$0B,$0C,$13,$14 ; 9210  blocks $04-$07
        .byte   $0D,$0D,$15,$16,$07,$11,$0F,$19,$18,$1A,$20,$21,$1B,$1C,$22,$23 ; 9220  blocks $08-$0B
        .byte   $1D,$1E,$0E,$1F,$10,$10,$00,$00,$00,$00,$28,$29,$00,$00,$2A,$2B ; 9230  blocks $0C-$0F
        .byte   $00,$00,$2C,$2D,$00,$00,$2E,$2F,$30,$31,$38,$39,$32,$33,$3A,$3B ; 9240  blocks $10-$13
        .byte   $34,$35,$3C,$3D,$36,$37,$3E,$3F,$40,$41,$48,$49,$42,$43,$4A,$4B ; 9250  blocks $14-$17
        .byte   $44,$45,$4C,$4D,$46,$47,$4E,$4F,$50,$51,$00,$00,$52,$53,$00,$00 ; 9260  blocks $18-$1B
        .byte   $54,$55,$00,$00,$56,$57,$00,$00,$00,$00,$00,$60,$58,$00,$61,$62 ; 9270  blocks $1C-$1F
        .byte   $00,$5D,$63,$64,$5E,$00,$65,$66,$00,$00,$67,$5C,$00,$68,$00,$70 ; 9280  blocks $20-$23
        .byte   $69,$6A,$71,$72,$6B,$6C,$73,$74,$6D,$6E,$75,$76,$6F,$98,$77,$9A ; 9290  blocks $24-$27
        .byte   $99,$00,$9B,$9C,$00,$00,$9D,$00,$00,$78,$00,$80,$79,$7A,$81,$82 ; 92A0  blocks $28-$2B
        .byte   $7B,$7C,$83,$84,$7D,$7E,$85,$86,$7F,$9E,$87,$A2,$9F,$A0,$A3,$A4 ; 92B0  blocks $2C-$2F
        .byte   $A1,$00,$00,$00,$5A,$88,$5B,$90,$89,$8A,$91,$92,$8B,$8C,$93,$94 ; 92C0  blocks $30-$33
        .byte   $8D,$8E,$95,$96,$8F,$A5,$97,$AB,$A6,$A7,$00,$A9,$A8,$00,$AA,$00 ; 92D0  blocks $34-$37
        .byte   $00,$00,$B0,$B0,$00,$00,$B1,$B2,$00,$00,$B3,$B3,$B0,$B0,$C0,$B0 ; 92E0  blocks $38-$3B
        .byte   $B0,$B0,$B0,$B0,$B9,$BA,$C1,$C2,$BB,$BC,$C3,$C4,$C8,$C9,$D0,$D1 ; 92F0  blocks $3C-$3F
        .byte   $CA,$CB,$D2,$D3,$B4,$B5,$CC,$BD,$B6,$B7,$BE,$BF,$D8,$D9,$00,$00 ; 9300  blocks $40-$43
        .byte   $DA,$DB,$00,$00,$D4,$C5,$00,$00,$C6,$C7,$00,$00,$00,$00,$00,$00 ; 9310  blocks $44-$47
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9320  blocks $48-$4B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9330  blocks $4C-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9340  blocks $50-$53
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9350  blocks $54-$57
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9360  blocks $58-$5B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9370  blocks $5C-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9380  blocks $60-$63
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9390  blocks $64-$67
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 93A0  blocks $68-$6B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 93B0  blocks $6C-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 93C0  blocks $70-$73
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 93D0  blocks $74-$77
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 93E0  blocks $78-$7B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 93F0  blocks $7C-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9400  blocks $80-$83
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9410  blocks $84-$87
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9420  blocks $88-$8B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9430  blocks $8C-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9440  blocks $90-$93
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9450  blocks $94-$97
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9460  blocks $98-$9B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9470  blocks $9C-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9480  blocks $A0-$A3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9490  blocks $A4-$A7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 94A0  blocks $A8-$AB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 94B0  blocks $AC-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 94C0  blocks $B0-$B3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 94D0  blocks $B4-$B7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 94E0  blocks $B8-$BB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 94F0  blocks $BC-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9500  blocks $C0-$C3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9510  blocks $C4-$C7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9520  blocks $C8-$CB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9530  blocks $CC-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9540  blocks $D0-$D3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9550  blocks $D4-$D7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9560  blocks $D8-$DB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9570  blocks $DC-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9580  blocks $E0-$E3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9590  blocks $E4-$E7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 95A0  blocks $E8-$EB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 95B0  blocks $EC-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 95C0  blocks $F0-$F3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 95D0  blocks $F4-$F7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 95E0  blocks $F8-$FB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 95F0  blocks $FC-$FF
; --- $9600 (rt $B600): screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9600
        .byte   $00,$00,$01,$02,$03,$04,$00,$00,$00,$00,$05,$06,$07,$08,$00,$00 ; 9610
        .byte   $00,$00,$09,$0A,$0B,$0C,$00,$00,$00,$00,$0D,$0D,$0D,$0D,$00,$00 ; 9620
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9630
; layout $01
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9640
        .byte   $00,$00,$0E,$0F,$10,$11,$00,$00,$00,$00,$12,$13,$14,$15,$00,$00 ; 9650
        .byte   $00,$00,$16,$17,$18,$19,$00,$00,$00,$00,$1A,$1B,$1C,$1D,$00,$00 ; 9660
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9670
; layout $02
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9680
        .byte   $00,$1E,$1F,$20,$21,$22,$00,$00,$00,$23,$24,$25,$26,$27,$28,$29 ; 9690
        .byte   $00,$2A,$2B,$2C,$2D,$2E,$2F,$30,$00,$31,$32,$33,$34,$35,$36,$37 ; 96A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 96B0
; layout $03
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 96C0
        .byte   $00,$00,$38,$38,$39,$3A,$00,$00,$00,$00,$3B,$3C,$3D,$3E,$00,$00 ; 96D0
        .byte   $00,$00,$3F,$40,$41,$42,$00,$00,$00,$00,$43,$44,$45,$46,$00,$00 ; 96E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 96F0
; layout $04
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9700
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9710
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9720
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9730
; layout $05
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9740
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9750
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9760
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9770
; layout $06
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9780
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9790
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 97A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 97B0
; layout $07
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 97C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 97D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 97E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 97F0
; layout $08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9800
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9810
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9820
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9830
; layout $09
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9840
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9850
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9860
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9870
; layout $0A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9880
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9890
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 98A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 98B0
; layout $0B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 98C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 98D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 98E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 98F0
; layout $0C
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9900
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9910
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9920
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9930
; layout $0D
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9940
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9950
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9960
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9970
; layout $0E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9980
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9990
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 99A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 99B0
; layout $0F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 99C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 99D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 99E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 99F0
; layout $10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9A00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9A10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9A20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9A30
; layout $11
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9A40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9A50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9A60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9A70
; layout $12
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9A80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9A90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9AA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9AB0
; layout $13
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9AC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9AD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9AE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9AF0
; layout $14
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9B00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9B10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9B20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9B30
; layout $15
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9B40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9B50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9B60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9B70
; layout $16
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9B80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9B90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9BA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9BB0
; layout $17
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9BC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9BD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9BE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9BF0
; layout $18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9C00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9C10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9C20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9C30
; layout $19
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9C40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9C50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9C60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9C70
; layout $1A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9C80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9C90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9CA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9CB0
; layout $1B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9CC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9CD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9CE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9CF0
; layout $1C
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D30
; layout $1D
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D70
; layout $1E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9DA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9DB0
; layout $1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9DC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9DD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9DE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9DF0
; layout $20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E30
; layout $21
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E70
; layout $22
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9EA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9EB0
; layout $23
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9EC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9ED0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9EE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9EF0
; layout $24
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F30
; layout $25
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F70
; layout $26
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9FA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9FB0
; layout $27
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9FC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9FD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9FE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9FF0
