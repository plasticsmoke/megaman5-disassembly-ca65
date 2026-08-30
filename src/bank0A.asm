.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK0A"

; =============================================================================
; BANK $0A (mapped at $A000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
; Data half (file +$0900 on): stage $0A (Proto castle 3) stage data —
; screen table at $A900 with this bank at $A000; format in
; DATA_REFERENCE.md section 11.
; =============================================================================
L0000           := $0000
L0020           := $0020
L0028           := $0028
L0728           := $0728
L0C21           := $0C21
L0F15           := $0F15
L0F37           := $0F37
L1615           := $1615
L1621           := $1621
L1714           := $1714
L1818           := $1818
L1D1C           := $1D1C
L2120           := $2120
L2121           := $2121
L2314           := $2314
L2504           := $2504
L280F           := $280F
L2821           := $2821
L2921           := $2921
L30C0           := $30C0
L3525           := $3525
L3B28           := $3B28
L4622           := $4622
L5A51           := $5A51
L5FC1           := $5FC1
L6001           := $6001
L645E           := $645E
L6814           := $6814
L6C6C           := $6C6C
L7021           := $7021
L809D           := $809D
L84BF           := $84BF
L84C4           := $84C4
L8830           := $8830
L9633           := $9633
L9A9A           := $9A9A
LC070           := $C070
LD8D0           := $D8D0
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $AC — Wily Press aftermath (death transform of $A0):
; wipes the arena ($1C:84BF), hands the shutdown to a spawned type
; $AD actor (sub $59), then launches its own carcass upward ($01.80)
; after a $3C pause until it leaves the screen.
; =============================================================================
        jsr     L84BF                           ; A000 20 BF 84                  ..
        jsr     find_free_slot_y                           ; A003 20 6F F1                  o.
        bcs     LA052                           ; A006 B0 4A                    .J
        lda     #$3D                            ; A008 A9 3D                    .=
        sta     $0588,x                         ; A00A 9D 88 05                 ...
        lda     #$A0                            ; A00D A9 A0                    ..
        sta     $05A0,x                         ; A00F 9D A0 05                 ...
        lda     #$00                            ; A012 A9 00                    ..
        sta     $0408,y                         ; A014 99 08 04                 ...
        jsr     entity_init_pos                           ; A017 20 A4 EA                  ..
        lda     #$AD                            ; A01A A9 AD                    ..
        sta     $0300,y                         ; A01C 99 00 03 hand-off actor: type $AD
        lda     #$59                            ; A01F A9 59                    .Y
        jsr     entity_set_subtype                           ; A021 20 98 EA                  ..
        lda     #$56                            ; A024 A9 56                    .V
        sta     $0588,y                         ; A026 99 88 05                 ...
        lda     #$A0                            ; A029 A9 A0                    ..
        sta     $05A0,y                         ; A02B 99 A0 05                 ...
        lda     #$80                            ; A02E A9 80                    ..
        sta     $03D8,x                         ; A030 9D D8 03                 ...
        lda     #$01                            ; A033 A9 01                    ..
        sta     $03F0,x                         ; A035 9D F0 03                 ...
        lda     #$3C                            ; A038 A9 3C                    .<
        sta     $0468,x                         ; A03A 9D 68 04                 .h.
        lda     $0468,x                         ; A03D BD 68 04                 .h.
        beq     LA047                           ; A040 F0 05                    ..
        dec     $0468,x                         ; A042 DE 68 04                 .h.
        bne     LA052                           ; A045 D0 0B                    ..
LA047:  jsr     entity_move_up_nofacing                           ; A047 20 4A E9                  J.
        lda     $0390,x                         ; A04A BD 90 03                 ...
        beq     LA052                           ; A04D F0 03                    ..
        jsr     entity_wipe_x                           ; A04F 20 C4 F2                  ..
LA052:  rts                                     ; A052 60                       `

; ----------------------------------------------------------------------------
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $AD — fortress-boss defeat director (death transform
; of Big Pets $4F and Circring $7C; also entered by $AC/$C0): wipes
; the arena, kills the palette cyclers/CHR anim, blacks out the
; palettes, spawns a type $30 explosion shower, then strobes the BG
; color ($A09C, LA2B1) and after the wait hands over: type $C0 keeps
; its own epilogue, everyone else waits for play state 0, teleports
; the player out (LA276) and sets state $18 boss-defeated ($A0E5).
; =============================================================================
        jsr     L84BF                           ; A053 20 BF 84                  ..
LA056:  lda     #$00                            ; A056 A9 00                    ..
        sta     $05F0                           ; A058 8D F0 05                 ...
        sta     $05F1                           ; A05B 8D F1 05                 ...
        sta     $05F2                           ; A05E 8D F2 05                 ...
        sta     $05F3                           ; A061 8D F3 05                 ...
        sta     $05D0                           ; A064 8D D0 05                 ...
        jsr     entity_set_subtype                           ; A067 20 98 EA                  ..
        lda     #$0F                            ; A06A A9 0F                    ..
        ldy     #$0B                            ; A06C A0 0B                    ..
LA06E:  sta     $0604,y                         ; A06E 99 04 06                 ...
        sta     $0624,y                         ; A071 99 24 06                 .$.
        dey                                     ; A074 88                       .
        bpl     LA06E                           ; A075 10 F7                    ..
        sty     $18                             ; A077 84 18                    ..
        jsr     find_free_slot_y                           ; A079 20 6F F1                  o.
        bcs     LA0F3                           ; A07C B0 75                    .u
        lda     #$00                            ; A07E A9 00                    ..
        jsr     entity_init_pos                           ; A080 20 A4 EA                  ..
        lda     #$30                            ; A083 A9 30                    .0
        sta     $0300,y                         ; A085 99 00 03                 ...
        lda     #$00                            ; A088 A9 00                    ..
        sta     $0408,y                         ; A08A 99 08 04                 ...
        lda     #$9C                            ; A08D A9 9C                    ..
        sta     $0588,x                         ; A08F 9D 88 05                 ...
        lda     #$A0                            ; A092 A9 A0                    ..
        sta     $05A0,x                         ; A094 9D A0 05                 ...
        lda     #$80                            ; A097 A9 80                    ..
        sta     $0468,x                         ; A099 9D 68 04                 .h.
        lda     $0468,x                         ; A09C BD 68 04                 .h.
        and     #$07                            ; A09F 29 07                    ).
LA0A1:  bne     LA0B6                           ; A0A1 D0 13                    ..
        lda     $0468,x                         ; A0A3 BD 68 04                 .h.
        lsr     a                               ; A0A6 4A                       J
        lsr     a                               ; A0A7 4A                       J
        lsr     a                               ; A0A8 4A                       J
        and     #$01                            ; A0A9 29 01                    ).
        tay                                     ; A0AB A8                       .
        lda     LA2B1,y                         ; A0AC B9 B1 A2                 ...
        sta     $0610                           ; A0AF 8D 10 06                 ...
        lda     #$FF                            ; A0B2 A9 FF                    ..
        sta     $18                             ; A0B4 85 18                    ..
LA0B6:  dec     $0468,x                         ; A0B6 DE 68 04                 .h.
        bne     LA0F3                           ; A0B9 D0 38                    .8
        lda     #$CA                            ; A0BB A9 CA                    ..
        sta     $0588,x                         ; A0BD 9D 88 05                 ...
        lda     #$A0                            ; A0C0 A9 A0                    ..
        sta     $05A0,x                         ; A0C2 9D A0 05                 ...
        lda     #$80                            ; A0C5 A9 80                    ..
        sta     $0468,x                         ; A0C7 9D 68 04                 .h.
        jsr     LA2A4                           ; A0CA 20 A4 A2                  ..
        bne     LA0F3                           ; A0CD D0 24                    .$
        lda     $0300,x                         ; A0CF BD 00 03                 ...
        cmp     #$C0                            ; A0D2 C9 C0    Wily-escape director?
        bne     LA0E5                           ; A0D4 D0 0F
        lda     #$78                            ; A0D6 A9 78                    .x
        sta     $0468                           ; A0D8 8D 68 04                 .h.
        lda     #$00                            ; A0DB A9 00                    ..
        sta     $99                             ; A0DD 85 99                    ..
        sta     $FD                             ; A0DF 85 FD                    ..
        sta     $FA                             ; A0E1 85 FA                    ..
        beq     LA0F0                           ; A0E3 F0 0B                    ..
LA0E5:  lda     $30                             ; A0E5 A5 30                    .0
        bne     LA0F3                           ; A0E7 D0 0A                    ..
        jsr     LA276                           ; A0E9 20 76 A2                  v.
        lda     #$18                            ; A0EC A9 18                    ..
        sta     $30                             ; A0EE 85 30                    .0
LA0F0:  jsr     entity_wipe_x                           ; A0F0 20 C4 F2                  ..
LA0F3:  rts                                     ; A0F3 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $AE — water giant aftermath (death transform of $44):
; wipes the arena keeping itself ($1C:84C4), blacks out the BG rows,
; becomes a type $30 explosion shower, clears the split-screen state
; and restores stage CHR (R0/R1 := $84/$7A).
; =============================================================================
        jsr     L84C4                           ; A0F4 20 C4 84                  ..
        lda     #$0F                            ; A0F7 A9 0F                    ..
        ldy     #$0B                            ; A0F9 A0 0B                    ..
LA0FB:  sta     $0600,y                         ; A0FB 99 00 06                 ...
        sta     $0620,y                         ; A0FE 99 20 06
        dey                                     ; A101 88
        bpl     LA0FB                           ; A102 10 F7                    ..
        sty     $18                             ; A104 84 18                    ..
        jsr     entity_wipe_x                           ; A106 20 C4 F2                  ..
        lda     #$00                            ; A109 A9 00                    ..
        jsr     entity_set_subtype                           ; A10B 20 98 EA                  ..
        lda     #$30                            ; A10E A9 30                    .0
        sta     $0300,x                         ; A110 9D 00 03                 ...
        lda     #$00                            ; A113 A9 00                    ..
        sta     $0408,x                         ; A115 9D 08 04                 ...
        sta     $FD                             ; A118 85 FD                    ..
        sta     $FA                             ; A11A 85 FA                    ..
        sta     $99                             ; A11C 85 99                    ..
        sta     $55                             ; A11E 85 55                    .U
        lda     #$84                            ; A120 A9 84                    ..
        sta     $EA                             ; A122 85 EA                    ..
        lda     #$7A                            ; A124 A9 7A                    .z
        sta     $EB                             ; A126 85 EB                    ..
        rts                                     ; A128 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $B4 — robot-master death director (death transform of
; all eight RMs and the Dark Men): clears gravity flip, wipes the
; arena, bursts into 16 type $03 particles on the classic spread
; (velocity tables $1C:83BC-$83FB), sound $1D. In the boss rush
; (stage $0E) it becomes the type $B0 return orb (sub $74); otherwise
; it waits out the burst, teleports the player (LA276) and sets state
; $18 boss-defeated -> weapon get.
; =============================================================================
        lda     $AF                             ; A129 A5 AF                    ..
        beq     LA139                           ; A12B F0 0C                    ..
        lda     #$00                            ; A12D A9 00                    ..
        sta     $AF                             ; A12F 85 AF                    ..
        lda     $0528                           ; A131 AD 28 05                 .(.
        and     #$BF                            ; A134 29 BF                    ).
        sta     $0528                           ; A136 8D 28 05                 .(.
LA139:  jsr     L84BF                           ; A139 20 BF 84                  ..
        lda     #$0F                            ; A13C A9 0F                    ..
        sta     $11                             ; A13E 85 11                    ..
LA140:  ldy     #$17                            ; A140 A0 17                    ..
LA142:  lda     $0300,y                         ; A142 B9 00 03                 ...
        beq     LA14E                           ; A145 F0 07                    ..
        dey                                     ; A147 88                       .
        cpy     #$05                            ; A148 C0 05                    ..
        bne     LA142                           ; A14A D0 F6                    ..
        beq     LA196                           ; A14C F0 48                    .H
LA14E:  lda     #$19                            ; A14E A9 19                    ..
        jsr     entity_init_pos                           ; A150 20 A4 EA                  ..
        lda     #$80                            ; A153 A9 80                    ..
        sta     $0528,y                         ; A155 99 28 05                 .(.
        lda     #$03                            ; A158 A9 03                    ..
        sta     $0300,y                         ; A15A 99 00 03                 ...
        lda     #$00                            ; A15D A9 00                    ..
        sta     $0408,y                         ; A15F 99 08 04                 ...
        sta     $0468,y                         ; A162 99 68 04                 .h.
        sta     $0480,y                         ; A165 99 80 04                 ...
        ldx     $11                             ; A168 A6 11                    ..
        lda     $83BC,x                         ; A16A BD BC 83                 ...
        sta     $03A8,y                         ; A16D 99 A8 03                 ...
        lda     $83CC,x                         ; A170 BD CC 83                 ...
        sta     $03C0,y                         ; A173 99 C0 03                 ...
        bpl     LA17D                           ; A176 10 05                    ..
        lda     #$FF                            ; A178 A9 FF                    ..
        sta     $0468,y                         ; A17A 99 68 04                 .h.
LA17D:  lda     $83DC,x                         ; A17D BD DC 83                 ...
        sta     $03D8,y                         ; A180 99 D8 03                 ...
        lda     $83EC,x                         ; A183 BD EC 83                 ...
        sta     $03F0,y                         ; A186 99 F0 03                 ...
        bpl     LA190                           ; A189 10 05                    ..
        lda     #$FF                            ; A18B A9 FF                    ..
        sta     $0480,y                         ; A18D 99 80 04                 ...
LA190:  ldx     $A6                             ; A190 A6 A6                    ..
        dec     $11                             ; A192 C6 11                    ..
        bpl     LA140                           ; A194 10 AA                    ..
LA196:  lda     #$1D                            ; A196 A9 1D                    ..
        jsr     queue_sound                           ; A198 20 5D EC                  ].
        lda     #$00                            ; A19B A9 00                    ..
        jsr     entity_set_subtype                           ; A19D 20 98 EA                  ..
LA1A0:  lda     #$C5                            ; A1A0 A9 C5                    ..
        sta     $0588,x                         ; A1A2 9D 88 05                 ...
        lda     #$A1                            ; A1A5 A9 A1                    ..
        sta     $05A0,x                         ; A1A7 9D A0 05                 ...
        lda     #$FF                            ; A1AA A9 FF                    ..
        sta     $0468,x                         ; A1AC 9D 68 04                 .h.
        lda     $26                             ; A1AF A5 26                    .&
        cmp     #$0E                            ; A1B1 C9 0E                    ..
        bne     LA1F7                           ; A1B3 D0 42                    .B
        jsr     entity_wipe_x                           ; A1B5 20 C4 F2                  ..
        lda     #$B0                            ; A1B8 A9 B0                    ..
        sta     $0300,x                         ; A1BA 9D 00 03                 ...
        lda     #$74                            ; A1BD A9 74                    .t
        jsr     entity_set_subtype                           ; A1BF 20 98 EA                  ..
        jmp     entity_stop_y                           ; A1C2 4C 1E EA                 L..

; ----------------------------------------------------------------------------
        jsr     LA2A4                           ; A1C5 20 A4 A2                  ..
        bne     LA1F7                           ; A1C8 D0 2D                    .-
        ldy     $30                             ; A1CA A4 30                    .0
        bne     LA1F7                           ; A1CC D0 29                    .)
        sty     $34                             ; A1CE 84 34                    .4
        sty     $33                             ; A1D0 84 33                    .3
        lda     #$01                            ; A1D2 A9 01                    ..
        jsr     entity_init_subtype_y                           ; A1D4 20 E9 EA                  ..
        lda     #$18                            ; A1D7 A9 18                    ..
        sta     $30                             ; A1D9 85 30                    .0
        jsr     LA276                           ; A1DB 20 76 A2                  v.
        lda     #$FF                            ; A1DE A9 FF                    ..
        sta     $0468                           ; A1E0 8D 68 04                 .h.
        jsr     entity_wipe_x                           ; A1E3 20 C4 F2                  ..
        lda     #$01                            ; A1E6 A9 01                    ..
        sta     $0420                           ; A1E8 8D 20 04                 . .
        lda     $0330                           ; A1EB AD 30 03                 .0.
        cmp     #$80                            ; A1EE C9 80                    ..
        bcc     LA1F7                           ; A1F0 90 05                    ..
        lda     #$02                            ; A1F2 A9 02                    ..
        sta     $0420                           ; A1F4 8D 20 04                 . .
LA1F7:  rts                                     ; A1F7 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $C0 — Wily Machine destroyed, Wily bails out (death
; transform of $AA): wipes the arena and flings a type $BA Wily
; ($0D:A09C) up at $05.A9, aimed to land at X=$D4 — airtime from the
; height table at $A3F0 (via $A3ED+Y/16), xvel = distance/time
; (div16). Palette from LA3F8, sound $F1, then player state $1C
; (capsule epilogue) and the $AD shutdown chain ($A056).
; =============================================================================
        jsr     L84BF                           ; A1F8 20 BF 84                  ..
        jsr     find_free_slot_y                           ; A1FB 20 6F F1                  o.
        lda     #$6C                            ; A1FE A9 6C                    .l
        jsr     entity_init_pos                           ; A200 20 A4 EA                  ..
        lda     $0528,y                         ; A203 B9 28 05
        and     #$DF                            ; A206 29 DF
LA208:  sta     $0528,y                         ; A208 99 28 05                 .(.
        lda     #$BA                            ; A20B A9 BA                    ..
        sta     $0300,y                         ; A20D 99 00 03                 ...
        lda     #$00                            ; A210 A9 00                    ..
        sta     $0408,y                         ; A212 99 08 04                 ...
        lda     #$A9                            ; A215 A9 A9                    ..
        sta     $03D8,y                         ; A217 99 D8 03                 ...
        lda     #$05                            ; A21A A9 05                    ..
        sta     $03F0,y                         ; A21C 99 F0 03                 ...
        lda     #$00                            ; A21F A9 00                    ..
        sta     L0000                           ; A221 85 00                    ..
        sta     $02                             ; A223 85 02                    ..
        lda     #$D4                            ; A225 A9 D4                    ..
        sec                                     ; A227 38                       8
        sbc     $0330,x                         ; A228 FD 30 03                 .0.
        sta     $01                             ; A22B 85 01                    ..
        lda     $0378,x                         ; A22D BD 78 03                 .x.
        lsr     a                               ; A230 4A                       J
        lsr     a                               ; A231 4A                       J
        lsr     a                               ; A232 4A                       J
        lsr     a                               ; A233 4A                       J
        tax                                     ; A234 AA                       .
        lda     $A3ED,x                         ; A235 BD ED A3 airtime by height
        sta     $03                             ; A238 85 03
        sty     $0F                             ; A23A 84 0F                    ..
        jsr     div16                           ; A23C 20 2D F2                  -.
        ldy     $0F                             ; A23F A4 0F                    ..
        ldx     $A6                             ; A241 A6 A6                    ..
        lda     $04                             ; A243 A5 04                    ..
        sta     $03A8,y                         ; A245 99 A8 03                 ...
        lda     $05                             ; A248 A5 05                    ..
        sta     $03C0,y                         ; A24A 99 C0 03                 ...
        lda     $0F                             ; A24D A5 0F                    ..
        sta     $04F8                           ; A24F 8D F8 04                 ...
        ldy     #$0F                            ; A252 A0 0F                    ..
LA254:  lda     LA3F8,y                         ; A254 B9 F8 A3                 ...
        sta     $0610,y                         ; A257 99 10 06                 ...
        sta     $0630,y                         ; A25A 99 30 06                 .0.
        dey                                     ; A25D 88                       .
        bpl     LA254                           ; A25E 10 F4                    ..
        lda     #$F1                            ; A260 A9 F1                    ..
        jsr     queue_sound                           ; A262 20 5D EC                  ].
        jsr     LA291                           ; A265 20 91 A2                  ..
        lda     $30                             ; A268 A5 30                    .0
        cmp     #$07                            ; A26A C9 07                    ..
        bcs     LA275                           ; A26C B0 07                    ..
        lda     #$1C                            ; A26E A9 1C                    ..
        sta     $30                             ; A270 85 30                    .0
        jmp     LA056                           ; A272 4C 56 A0                 LV.

; ----------------------------------------------------------------------------
LA275:  rts                                     ; A275 60                       `

; ----------------------------------------------------------------------------
LA276:  lda     #$F1                            ; A276 A9 F1                    ..
        jsr     queue_sound                           ; A278 20 5D EC                  ].
        lda     $32                             ; A27B A5 32                    .2
        bne     LA291                           ; A27D D0 12                    ..
        ldy     #$03                            ; A27F A0 03                    ..
LA281:  lda     LA2AD,y                         ; A281 B9 AD A2                 ...
        sta     $0610,y                         ; A284 99 10 06                 ...
        sta     $0630,y                         ; A287 99 30 06                 .0.
        dey                                     ; A28A 88                       .
        bne     LA281                           ; A28B D0 F4                    ..
        lda     #$FF                            ; A28D A9 FF                    ..
        sta     $18                             ; A28F 85 18                    ..
LA291:  ldy     #$04                            ; A291 A0 04                    ..
LA293:  jsr     entity_wipe_y                           ; A293 20 FE F2                  ..
        dey                                     ; A296 88                       .
        bne     LA293                           ; A297 D0 FA                    ..
        lda     #$4C                            ; A299 A9 4C                    .L
        sta     $03A8                           ; A29B 8D A8 03                 ...
        lda     #$01                            ; A29E A9 01                    ..
        sta     $03C0                           ; A2A0 8D C0 03                 ...
        rts                                     ; A2A3 60                       `

; ----------------------------------------------------------------------------
LA2A4:  lda     $0468,x                         ; A2A4 BD 68 04                 .h.
        beq     LA2AC                           ; A2A7 F0 03                    ..
        dec     $0468,x                         ; A2A9 DE 68 04                 .h.
LA2AC:  rts                                     ; A2AC 60                       `

; ----------------------------------------------------------------------------
LA2AD:  .byte   $0F                             ; A2AD 0F                       .
        .byte   $0F                             ; A2AE 0F                       .
        .byte   $2C                             ; A2AF 2C                       ,
        .byte   $11                             ; A2B0 11                       .
LA2B1:  .byte   $30,$0F                         ; A2B1 30 0F  colors read by $A0AC
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $B3 — boss-room director (one per stage, placed on the
; boss room's screen; the spawn sub_type is the intro-drop animation).
; In Gravity Man's stage only (stage_bank_alt==0 there, cf. LD4C2) it
; first inverts gravity and sets the player's vflip bit — the fight is
; entered on the ceiling. Then waits for the player to land (Y >= $A0,
; or < $40 when flipped); a robot master already beaten ($6E bitmap)
; short-circuits to player state $10 (stage clear). Otherwise: freeze
; the player (state $19), unhide, drop to LA3B4[stage] ($A31A), play
; the landing anim to frame LA3C0[stage] ($A33A; Charge Man sub $20
; also spawns a type $6D/$21 smoke effect at Y=$8C), fill boss HP
; 0->$1C with sound $26 every 4 frames ($A375, boss meter on: $2F=$80,
; boss slot renders first), then wipe the slot and morph it into the
; real boss: sub_type/type/shape from LA3CC/LA3D8/LA3E4[stage], HP $1C,
; player state 0 — fight on. Table index = stage bank ($26), or the
; room's screen & 7 in boss-rush stage $0E.
; =============================================================================
        lda     $30                             ; A2B3 A5 30    player_state
        bne     LA2AC                           ; A2B5 D0 F5
        lda     $AF                             ; A2B7 A5 AF    gravity_flip
        bne     LA2CC                           ; A2B9 D0 11
        lda     $27                             ; A2BB A5 27    stage_bank_alt (0 = Gravity stage)
        bne     LA2CC                           ; A2BD D0 0D
        lda     #$01                            ; A2BF A9 01
        sta     $AF                             ; A2C1 85 AF    invert gravity for the fight
        lda     $0528                           ; A2C3 AD 28 05
        ora     #$40                            ; A2C6 09 40
        sta     $0528                           ; A2C8 8D 28 05 player vflip bit
        rts                                     ; A2CB 60

; ----------------------------------------------------------------------------
LA2CC:  lda     $0378                           ; A2CC AD 78 03 player Y px
        cmp     #$A0                            ; A2CF C9 A0
        bcs     LA2D7                           ; A2D1 B0 04
        cmp     #$40                            ; A2D3 C9 40
        bcs     LA2AC                           ; A2D5 B0 D5    mid-air: wait
LA2D7:  ldy     $26                             ; A2D7 A4 26    stage_bank
        cpy     #$08                            ; A2D9 C0 08
        bcs     LA2E9                           ; A2DB B0 0C    castle: always fight
        lda     $F2B2,y                         ; A2DD B9 B2 F2 stage bit mask
        and     $6E                             ; A2E0 25 6E    boss-beaten bitmap
        beq     LA2E9                           ; A2E2 F0 05
        lda     #$10                            ; A2E4 A9 10
        sta     $30                             ; A2E6 85 30    already beaten -> stage clear
LA2E8:  rts                                     ; A2E8 60

; ----------------------------------------------------------------------------
LA2E9:  lda     #$00                            ; A2E9 A9 00
        sta     $0540,x                         ; A2EB 9D 40 05 anim phase
        sta     $0570,x                         ; A2EE 9D 70 05 anim tick
        lda     #$19                            ; A2F1 A9 19
        sta     $30                             ; A2F3 85 30    player state $19: stand frozen
        lda     $0528,x                         ; A2F5 BD 28 05
        and     #$FB                            ; A2F8 29 FB
        sta     $0528,x                         ; A2FA 9D 28 05 clear no-draw: boss appears
        lda     #$0A                            ; A2FD A9 0A
        jsr     queue_sound_param               ; A2FF 20 5B EC
        lda     #$1A                            ; A302 A9 1A
        sta     $0588,x                         ; A304 9D 88 05
        lda     #$A3                            ; A307 A9 A3
        sta     $05A0,x                         ; A309 9D A0 05 behavior PC := $A31A
        lda     $26                             ; A30C A5 26
        cmp     #$0E                            ; A30E C9 0E
        bne     LA317                           ; A310 D0 05
        lda     $0348,x                         ; A312 BD 48 03 boss rush: room screen
        and     #$07                            ; A315 29 07
LA317:  sta     $0468,x                         ; A317 9D 68 04 stage/table index
; --- $A31A: drop to the landing Y ---------------------------------------------
        lda     #$00                            ; A31A A9 00
        sta     $0570,x                         ; A31C 9D 70 05
        jsr     entity_process_y_vel            ; A31F 20 68 E9
        ldy     $0468,x                         ; A322 BC 68 04
        lda     LA3B4,y                         ; A325 B9 B4 A3 landing Y for this stage
        cmp     $0378,x                         ; A328 DD 78 03
        bcs     LA2E8                           ; A32B B0 BB    still falling
        sta     $0378,x                         ; A32D 9D 78 03 land: clamp Y
        lda     #$3A                            ; A330 A9 3A
        sta     $0588,x                         ; A332 9D 88 05
        lda     #$A3                            ; A335 A9 A3
        sta     $05A0,x                         ; A337 9D A0 05 behavior PC := $A33A
; --- $A33A: play the intro animation ------------------------------------------
        ldy     $0468,x                         ; A33A BC 68 04
        lda     $0540,x                         ; A33D BD 40 05 anim phase
        cmp     LA3C0,y                         ; A340 D9 C0 A3 done?
        bne     LA3B3                           ; A343 D0 6E
        stx     $56                             ; A345 86 56    render_first: boss draws first
        lda     #$80                            ; A347 A9 80
        sta     $2F                             ; A349 85 2F    boss HP meter on
        lda     #$75                            ; A34B A9 75
        sta     $0588,x                         ; A34D 9D 88 05
        lda     #$A3                            ; A350 A9 A3
        sta     $05A0,x                         ; A352 9D A0 05 behavior PC := $A375
        lda     $0558,x                         ; A355 BD 58 05 sub_type
        cmp     #$20                            ; A358 C9 20    Charge Man's intro?
        bne     LA375                           ; A35A D0 19
        jsr     find_free_slot_y                ; A35C 20 6F F1
        bcs     LA375                           ; A35F B0 14
        lda     #$21                            ; A361 A9 21
        jsr     entity_init_pos                 ; A363 20 A4 EA
        lda     #$6D                            ; A366 A9 6D
        sta     $0300,y                         ; A368 99 00 03 smoke: inert effect $6D
        lda     #$00                            ; A36B A9 00
        sta     $0408,y                         ; A36D 99 08 04
        lda     #$8C                            ; A370 A9 8C
        sta     $0378,y                         ; A372 99 78 03 at ground level
; --- $A375: fill the boss HP meter --------------------------------------------
LA375:  lda     #$00                            ; A375 A9 00
        sta     $0570,x                         ; A377 9D 70 05 hold the anim
        lda     $9D                             ; A37A A5 9D    frame counter
        and     #$03                            ; A37C 29 03
        bne     LA3B3                           ; A37E D0 33
        lda     #$26                            ; A380 A9 26
        jsr     queue_sound                     ; A382 20 5D EC HP tick
        inc     $0450,x                         ; A385 FE 50 04
        lda     $0450,x                         ; A388 BD 50 04
        cmp     #$1C                            ; A38B C9 1C    full at 28
        bne     LA3B3                           ; A38D D0 24
        lda     $0468,x                         ; A38F BD 68 04
        pha                                     ; A392 48
        jsr     entity_wipe_x                   ; A393 20 C4 F2 fresh slot for the boss
        pla                                     ; A396 68
        tay                                     ; A397 A8
        lda     LA3CC,y                         ; A398 B9 CC A3
        jsr     entity_set_subtype              ; A39B 20 98 EA
        lda     LA3D8,y                         ; A39E B9 D8 A3
        sta     $0300,x                         ; A3A1 9D 00 03 morph into the real boss
        lda     LA3E4,y                         ; A3A4 B9 E4 A3
        sta     $0408,x                         ; A3A7 9D 08 04
        lda     #$1C                            ; A3AA A9 1C
        sta     $0450,x                         ; A3AC 9D 50 04
        lda     #$00                            ; A3AF A9 00
        sta     $30                             ; A3B1 85 30    fight on
LA3B3:  rts                                     ; A3B3 60

; ----------------------------------------------------------------------------
; Per-stage boss tables, indexed by stage bank (or boss-rush screen & 7):
; $00 Gravity Man $81, $01 Wave Man $86, $02 Stone Man $69, $03 Gyro Man
; $6E, $04 Star Man $8D, $05 Charge Man $6B, $06 Napalm Man $89, $07
; Crystal Man $83, $08-$0B Dark Man 1-4 $96/$91/$93/$98.
; ----------------------------------------------------------------------------
LA3B4:  .byte   $B0,$B0,$AC,$B0,$B0,$AC,$B0,$B0 ; A3B4  landing Y px
        .byte   $B0,$B0,$B0,$B0                 ; A3BC
LA3C0:  .byte   $0C,$10,$09,$1D,$1E,$0C,$09,$15 ; A3C0  intro anim end frame
        .byte   $00,$00,$00,$00                 ; A3C8
LA3CC:  .byte   $01,$2A,$08,$12,$3C,$19,$32,$24 ; A3CC  boss sub_type
        .byte   $53,$42,$4B,$47                 ; A3D4
LA3D8:  .byte   $81,$86,$69,$6E,$8D,$6B,$89,$83 ; A3D8  boss entity type
        .byte   $96,$91,$93,$98                 ; A3E0
LA3E4:  .byte   $CB,$CB,$C9,$C8,$C8,$D7,$CB,$CC ; A3E4  boss shape
        .byte   $CB,$D2,$CB,$CC                 ; A3EC
        .byte   $40,$3D,$3B,$38,$36,$33,$2F,$29 ; A3F0  Wily-escape airtime by height ($C0)
LA3F8:  .byte   $0F,$0F,$2C,$11                 ; A3F8  palette rows for $A254
        .byte   $0F,$0F,$20,$37                 ; A3FC
        .byte   $0F,$0F,$20,$15                 ; A400
        .byte   $0F,$0F,$27,$15                 ; A404
; =============================================================================
; BEHAVIOR type $0A — Gyro Man stage shaft auto-scroll (scr $01):
; vertical-wrap scroll on ($74/$46 via the $A408 entry), IRQ mode
; $1C; accelerates the camera upward (+$10/frame yvel to 4 px, sound
; $31 at speed, $32 at the brake), 16-bit through $0360/$FA and
; $75/$76, then restores mirroring and wipes at the top.
; =============================================================================
; ----------------------------------------------------------------------------
        lda     #$FF                            ; A408 A9 FF
        sta     $74                             ; A40A 85 74                    .t
        lda     #$00                            ; A40C A9 00                    ..
        sta     $75                             ; A40E 85 75                    .u
        sta     $76                             ; A410 85 76                    .v
        lda     $0330                           ; A412 AD 30 03                 .0.
        cmp     #$80                            ; A415 C9 80                    ..
        bcc     LA458                           ; A417 90 3F                    .?
        lda     #$80                            ; A419 A9 80                    ..
        sta     $1E                             ; A41B 85 1E                    ..
        sta     $55                             ; A41D 85 55                    .U
        lda     #$1C                            ; A41F A9 1C                    ..
        sta     $23                             ; A421 85 23                    .#
        lda     #$2D                            ; A423 A9 2D                    .-
        sta     $0588,x                         ; A425 9D 88 05                 ...
        lda     #$A4                            ; A428 A9 A4                    ..
        sta     $05A0,x                         ; A42A 9D A0 05                 ...
        lda     $1E                             ; A42D A5 1E                    ..
        bne     LA458                           ; A42F D0 27                    .'
        sta     $03D8,x                         ; A431 9D D8 03                 ...
        sta     $03F0,x                         ; A434 9D F0 03                 ...
        jsr     set_mirroring                           ; A437 20 B7 FF                  ..
        lda     #$BF                            ; A43A A9 BF                    ..
        sta     $9B                             ; A43C 85 9B                    ..
        lda     #$02                            ; A43E A9 02                    ..
        sta     $99                             ; A440 85 99                    ..
        inc     $FD                             ; A442 E6 FD                    ..
        lda     #$68                            ; A444 A9 68                    .h
        sta     $0468,x                         ; A446 9D 68 04                 .h.
        lda     #$31                            ; A449 A9 31                    .1
        jsr     queue_sound                           ; A44B 20 5D EC                  ].
        lda     #$59                            ; A44E A9 59                    .Y
        sta     $0588,x                         ; A450 9D 88 05                 ...
        lda     #$A4                            ; A453 A9 A4                    ..
        sta     $05A0,x                         ; A455 9D A0 05                 ...
LA458:  rts                                     ; A458 60                       `

; ----------------------------------------------------------------------------
        lda     $03D8,x                         ; A459 BD D8 03                 ...
        clc                                     ; A45C 18                       .
        adc     #$10                            ; A45D 69 10                    i.
        sta     $03D8,x                         ; A45F 9D D8 03                 ...
        lda     $03F0,x                         ; A462 BD F0 03                 ...
        adc     #$00                            ; A465 69 00                    i.
        sta     $03F0,x                         ; A467 9D F0 03                 ...
        cmp     #$04                            ; A46A C9 04                    ..
        bne     LA4AF                           ; A46C D0 41                    .A
        dec     $0468,x                         ; A46E DE 68 04                 .h.
        bne     LA4AA                           ; A471 D0 37                    .7
        lda     #$32                            ; A473 A9 32                    .2
        jsr     queue_sound                           ; A475 20 5D EC                  ].
        lda     #$84                            ; A478 A9 84                    ..
        sta     $0588,x                         ; A47A 9D 88 05                 ...
        lda     #$A4                            ; A47D A9 A4                    ..
        sta     $05A0,x                         ; A47F 9D A0 05                 ...
        bne     LA4AF                           ; A482 D0 2B                    .+
        lda     $03D8,x                         ; A484 BD D8 03                 ...
        sec                                     ; A487 38                       8
        sbc     #$10                            ; A488 E9 10                    ..
        sta     $03D8,x                         ; A48A 9D D8 03                 ...
        lda     $03F0,x                         ; A48D BD F0 03                 ...
        sbc     #$00                            ; A490 E9 00                    ..
        sta     $03F0,x                         ; A492 9D F0 03                 ...
        bne     LA4AF                           ; A495 D0 18                    ..
        lda     #$01                            ; A497 A9 01                    ..
        sta     $03F0,x                         ; A499 9D F0 03                 ...
        lda     $FA                             ; A49C A5 FA                    ..
        bne     LA4AA                           ; A49E D0 0A                    ..
        sta     $55                             ; A4A0 85 55                    .U
        lda     #$01                            ; A4A2 A9 01
        jsr     set_mirroring                   ; A4A4 20 B7 FF
        jmp     entity_wipe_x                           ; A4A7 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LA4AA:  lda     #$00                            ; A4AA A9 00                    ..
        sta     $03D8,x                         ; A4AC 9D D8 03                 ...
LA4AF:  lda     $0360,x                         ; A4AF BD 60 03                 .`.
        sec                                     ; A4B2 38                       8
        sbc     $03D8,x                         ; A4B3 FD D8 03                 ...
        sta     $0360,x                         ; A4B6 9D 60 03                 .`.
        lda     $FA                             ; A4B9 A5 FA                    ..
        sbc     $03F0,x                         ; A4BB FD F0 03                 ...
        bcs     LA4C2                           ; A4BE B0 02                    ..
        sbc     #$0F                            ; A4C0 E9 0F                    ..
LA4C2:  sta     $FA                             ; A4C2 85 FA                    ..
        lda     $03D8,x                         ; A4C4 BD D8 03                 ...
        asl     a                               ; A4C7 0A                       .
        sta     L0000                           ; A4C8 85 00                    ..
        lda     $03F0,x                         ; A4CA BD F0 03                 ...
        rol     a                               ; A4CD 2A                       *
        sta     $01                             ; A4CE 85 01                    ..
        lda     $75                             ; A4D0 A5 75                    .u
        sec                                     ; A4D2 38                       8
        sbc     L0000                           ; A4D3 E5 00                    ..
        sta     $75                             ; A4D5 85 75                    .u
        lda     $76                             ; A4D7 A5 76                    .v
        sbc     $01                             ; A4D9 E5 01                    ..
        sta     $76                             ; A4DB 85 76                    .v
        bcs     LA4E3                           ; A4DD B0 04                    ..
        sbc     #$0F                            ; A4DF E9 0F                    ..
        sta     $76                             ; A4E1 85 76                    .v
LA4E3:  rts                                     ; A4E3 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $40 — Napalm Man stage wall turret (scr $06): pinned
; to the right screen edge (X = camera + $E4) with a linked overlay
; sprite at +$10; takes weapon hits into the damage engine (flag $40,
; preserving its spawn/link fields). Each time it dies it survives as
; type $40: goes dark (palette rows out), bursts (type $2F), then
; when the camera closes within $C0 px it strobes back in (LA672
; fade) and revives as sub $83 with 3 HP ($A5D0) — a regenerating
; barrier the player must out-run or re-kill.
; =============================================================================
        lda     #$00                            ; A4E4 A9 00                    ..
        sta     $78                             ; A4E6 85 78                    .x
        lda     #$90                            ; A4E8 A9 90                    ..
        sta     $9B                             ; A4EA 85 9B                    ..
        lda     #$03                            ; A4EC A9 03                    ..
        sta     $99                             ; A4EE 85 99                    ..
        lda     #$1A                            ; A4F0 A9 1A                    ..
        sta     $0588,x                         ; A4F2 9D 88 05                 ...
        lda     #$A5                            ; A4F5 A9 A5                    ..
        sta     $05A0,x                         ; A4F7 9D A0 05                 ...
        jsr     find_free_slot_y                           ; A4FA 20 6F F1                  o.
        bcs     LA51A                           ; A4FD B0 1B                    ..
        lda     #$62                            ; A4FF A9 62                    .b
        jsr     entity_init_pos                           ; A501 20 A4 EA                  ..
        lda     $0528,y                         ; A504 B9 28 05                 .(.
        ora     #$08                            ; A507 09 08                    ..
        sta     $0528,y                         ; A509 99 28 05                 .(.
        lda     #$01                            ; A50C A9 01                    ..
        sta     $0300,y                         ; A50E 99 00 03                 ...
        lda     #$59                            ; A511 A9 59                    .Y
        sta     $0408,y                         ; A513 99 08 04                 ...
        tya                                     ; A516 98                       .
        sta     $0498,x                         ; A517 9D 98 04                 ...
LA51A:  jsr     entity_move_left_collide                           ; A51A 20 0C E9                  ..
        lda     $0330,x                         ; A51D BD 30 03                 .0.
        sec                                     ; A520 38                       8
        sbc     $FC                             ; A521 E5 FC                    ..
        lda     $0348,x                         ; A523 BD 48 03                 .H.
        sbc     $F9                             ; A526 E5 F9                    ..
        beq     LA534                           ; A528 F0 0A                    ..
        bcc     LA531                           ; A52A 90 05                    ..
        dec     $0348,x                         ; A52C DE 48 03                 .H.
        bne     LA534                           ; A52F D0 03                    ..
LA531:  inc     $0348,x                         ; A531 FE 48 03                 .H.
LA534:  lda     $0330,x                         ; A534 BD 30 03                 .0.
        sec                                     ; A537 38                       8
        sbc     $FC                             ; A538 E5 FC                    ..
        sta     L0000                           ; A53A 85 00                    ..
        lda     #$E4                            ; A53C A9 E4                    ..
        sec                                     ; A53E 38                       8
        sbc     L0000                           ; A53F E5 00                    ..
        sta     $78                             ; A541 85 78                    .x
        jsr     LA64B                           ; A543 20 4B A6                  K.
        jsr     entity_hitbox_check                           ; A546 20 F8 EF                  ..
        bcs     LA4E3                           ; A549 B0 98                    ..
        lda     #$40                            ; A54B A9 40                    .@
        sta     L0000                           ; A54D 85 00                    ..
        lda     $0438,x                         ; A54F BD 38 04                 .8.
        pha                                     ; A552 48                       H
        lda     $0498,x                         ; A553 BD 98 04                 ...
        pha                                     ; A556 48                       H
        jsr     L809D                           ; A557 20 9D 80                  ..
        pla                                     ; A55A 68                       h
        sta     $0498,x                         ; A55B 9D 98 04                 ...
        pla                                     ; A55E 68                       h
        sta     $0438,x                         ; A55F 9D 38 04                 .8.
        lda     #$40                            ; A562 A9 40                    .@
        cmp     $0300,x                         ; A564 DD 00 03                 ...
        beq     LA5CF                           ; A567 F0 66                    .f
        sta     $0300,x                         ; A569 9D 00 03                 ...
        lda     $0528,x                         ; A56C BD 28 05                 .(.
        ora     #$04                            ; A56F 09 04                    ..
        sta     $0528,x                         ; A571 9D 28 05                 .(.
        ldy     #$03                            ; A574 A0 03                    ..
        lda     #$0F                            ; A576 A9 0F                    ..
LA578:  sta     $060C,y                         ; A578 99 0C 06                 ...
        sta     $062C,y                         ; A57B 99 2C 06                 .,.
        dey                                     ; A57E 88                       .
        bpl     LA578                           ; A57F 10 F7                    ..
        sty     $18                             ; A581 84 18                    ..
        jsr     find_free_slot_y                           ; A583 20 6F F1                  o.
        bcs     LA5A8                           ; A586 B0 20                    . 
        lda     #$42                            ; A588 A9 42                    .B
        jsr     entity_init_pos                           ; A58A 20 A4 EA                  ..
        lda     #$2F                            ; A58D A9 2F                    ./
        sta     $0300,y                         ; A58F 99 00 03                 ...
        lda     #$00                            ; A592 A9 00                    ..
        sta     $0408,y                         ; A594 99 08 04                 ...
        lda     $0330,y                         ; A597 B9 30 03                 .0.
        clc                                     ; A59A 18                       .
        adc     #$10                            ; A59B 69 10                    i.
        sta     $0330,y                         ; A59D 99 30 03                 .0.
        lda     $0348,y                         ; A5A0 B9 48 03                 .H.
        adc     #$00                            ; A5A3 69 00                    i.
        sta     $0348,y                         ; A5A5 99 48 03                 .H.
LA5A8:  ldy     $0498,x                         ; A5A8 BC 98 04                 ...
        lda     $0528,y                         ; A5AB B9 28 05                 .(.
        and     #$FD                            ; A5AE 29 FD                    ).
        sta     $0528,y                         ; A5B0 99 28 05                 .(.
        lda     #$00                            ; A5B3 A9 00                    ..
        sta     $0408,y                         ; A5B5 99 08 04                 ...
        jsr     entity_set_subtype                           ; A5B8 20 98 EA                  ..
        lda     #$78                            ; A5BB A9 78                    .x
        sta     $0468,x                         ; A5BD 9D 68 04                 .h.
        lda     #$30                            ; A5C0 A9 30                    .0
        sta     $0480,x                         ; A5C2 9D 80 04                 ...
        lda     #$D0                            ; A5C5 A9 D0                    ..
        sta     $0588,x                         ; A5C7 9D 88 05                 ...
        lda     #$A5                            ; A5CA A9 A5                    ..
        sta     $05A0,x                         ; A5CC 9D A0 05                 ...
LA5CF:  rts                                     ; A5CF 60                       `

; ----------------------------------------------------------------------------
        lda     $0468,x                         ; A5D0 BD 68 04                 .h.
        beq     LA5DA                           ; A5D3 F0 05                    ..
        dec     $0468,x                         ; A5D5 DE 68 04                 .h.
        bne     LA63C                           ; A5D8 D0 62                    .b
LA5DA:  lda     $0330                           ; A5DA AD 30 03                 .0.
        sec                                     ; A5DD 38                       8
        sbc     $FC                             ; A5DE E5 FC                    ..
        cmp     #$C0                            ; A5E0 C9 C0                    ..
        bcs     LA63C                           ; A5E2 B0 58                    .X
        lda     #$F2                            ; A5E4 A9 F2                    ..
        sta     $0588,x                         ; A5E6 9D 88 05                 ...
        lda     #$A5                            ; A5E9 A9 A5                    ..
        sta     $05A0,x                         ; A5EB 9D A0 05                 ...
        lda     #$00                            ; A5EE A9 00                    ..
        sta     $78                             ; A5F0 85 78                    .x
        lda     $9D                             ; A5F2 A5 9D                    ..
        and     #$03                            ; A5F4 29 03                    ).
        bne     LA63C                           ; A5F6 D0 44                    .D
        ldy     #$03                            ; A5F8 A0 03                    ..
LA5FA:  lda     LA672,y                         ; A5FA B9 72 A6                 .r.
        sec                                     ; A5FD 38                       8
        sbc     $0480,x                         ; A5FE FD 80 04                 ...
        bcs     LA605                           ; A601 B0 02                    ..
        lda     #$0F                            ; A603 A9 0F                    ..
LA605:  sta     $060C,y                         ; A605 99 0C 06                 ...
        sta     $062C,y                         ; A608 99 2C 06                 .,.
        dey                                     ; A60B 88                       .
        bpl     LA5FA                           ; A60C 10 EC                    ..
        sty     $18                             ; A60E 84 18                    ..
        lda     $0480,x                         ; A610 BD 80 04                 ...
        sec                                     ; A613 38                       8
        sbc     #$10                            ; A614 E9 10                    ..
        sta     $0480,x                         ; A616 9D 80 04                 ...
        bcs     LA63C                           ; A619 B0 21                    .!
        lda     #$83                            ; A61B A9 83                    ..
        jsr     entity_set_subtype                           ; A61D 20 98 EA                  ..
        lda     $0528,x                         ; A620 BD 28 05                 .(.
        and     #$FB                            ; A623 29 FB                    ).
        sta     $0528,x                         ; A625 9D 28 05                 .(.
        lda     #$1A                            ; A628 A9 1A                    ..
        sta     $0588,x                         ; A62A 9D 88 05                 ...
        lda     #$A5                            ; A62D A9 A5                    ..
        sta     $05A0,x                         ; A62F 9D A0 05                 ...
        lda     #$03                            ; A632 A9 03                    ..
        sta     $0450,x                         ; A634 9D 50 04                 .P.
        lda     #$A8                            ; A637 A9 A8                    ..
        sta     $0408,x                         ; A639 9D 08 04                 ...
LA63C:  lda     $FC                             ; A63C A5 FC                    ..
        clc                                     ; A63E 18                       .
        adc     #$E4                            ; A63F 69 E4                    i.
        sta     $0330,x                         ; A641 9D 30 03                 .0.
        lda     $F9                             ; A644 A5 F9                    ..
        adc     #$00                            ; A646 69 00                    i.
        sta     $0348,x                         ; A648 9D 48 03                 .H.
LA64B:  ldy     $0498,x                         ; A64B BC 98 04                 ...
        lda     $0330,x                         ; A64E BD 30 03                 .0.
        clc                                     ; A651 18                       .
        adc     #$10                            ; A652 69 10                    i.
        sta     $0330,y                         ; A654 99 30 03                 .0.
        lda     $0348,x                         ; A657 BD 48 03                 .H.
        adc     #$00                            ; A65A 69 00                    i.
        sta     $0348,y                         ; A65C 99 48 03                 .H.
        lda     $0558,x                         ; A65F BD 58 05                 .X.
        beq     LA671                           ; A662 F0 0D                    ..
        lda     $0528,y                         ; A664 B9 28 05                 .(.
        ora     #$02                            ; A667 09 02                    ..
        sta     $0528,y                         ; A669 99 28 05                 .(.
        lda     #$59                            ; A66C A9 59                    .Y
        sta     $0408,y                         ; A66E 99 08 04                 ...
LA671:  rts                                     ; A671 60                       `

; ----------------------------------------------------------------------------
LA672:  .byte   $0F,$24,$14,$03                 ; A672  turret revive palette
; =============================================================================
; BEHAVIOR type $04 — ride mount (Charge Man stage, X=$F0/Y=$C0):
; touched from above, snaps the player onto it, sets the player's
; behind-BG bit and state $09, then wipes.
; =============================================================================
        jsr     entity_player_collide                           ; A676 20 87 EF                  ..
        bcs     LA69E                           ; A679 B0 23                    .#
        lda     $0378,x                         ; A67B BD 78 03                 .x.
        cmp     $0378                           ; A67E CD 78 03                 .x.
        bcc     LA69E                           ; A681 90 1B                    ..
        lda     #$09                            ; A683 A9 09                    ..
        sta     $30                             ; A685 85 30                    .0
LA687:  lda     $0330,x                         ; A687 BD 30 03                 .0.
        sta     $0330                           ; A68A 8D 30 03                 .0.
        lda     $0378,x                         ; A68D BD 78 03                 .x.
        sta     $0378                           ; A690 8D 78 03                 .x.
        lda     $0528                           ; A693 AD 28 05                 .(.
        ora     #$10                            ; A696 09 10                    ..
        sta     $0528                           ; A698 8D 28 05                 .(.
        jsr     entity_wipe_x                           ; A69B 20 C4 F2                  ..
LA69E:  rts                                     ; A69E 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $05 — pipe launch (Wave Man stage, scr $03): on
; touch, pins the player, state $0B with $04.00 velocities (delay $20
; unless already at Y=$90), and wipes — the water-pressure pipe ride.
; =============================================================================
        jsr     entity_player_collide                           ; A69F 20 87 EF                  ..
        bcs     LA6D1                           ; A6A2 B0 2D                    .-
        jsr     LA687                           ; A6A4 20 87 A6                  ..
        lda     #$0B                            ; A6A7 A9 0B                    ..
        sta     $30                             ; A6A9 85 30                    .0
        lda     #$00                            ; A6AB A9 00                    ..
        sta     $03A8                           ; A6AD 8D A8 03                 ...
        sta     $03D8                           ; A6B0 8D D8 03                 ...
        lda     #$04                            ; A6B3 A9 04                    ..
        sta     $03C0                           ; A6B5 8D C0 03                 ...
        sta     $03F0                           ; A6B8 8D F0 03                 ...
        lda     #$01                            ; A6BB A9 01                    ..
        sta     $0420                           ; A6BD 8D 20 04                 . .
        lda     #$00                            ; A6C0 A9 00                    ..
        sta     $0468                           ; A6C2 8D 68 04                 .h.
        lda     $0378                           ; A6C5 AD 78 03                 .x.
        cmp     #$90                            ; A6C8 C9 90                    ..
        beq     LA6D1                           ; A6CA F0 05                    ..
        lda     #$20                            ; A6CC A9 20                    . 
        sta     $0468                           ; A6CE 8D 68 04                 .h.
LA6D1:  rts                                     ; A6D1 60                       `

; ----------------------------------------------------------------------------
; $A6D2-$A7FF: data, TBD (unreferenced in-bank)
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6D2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6DA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6E2
        .byte   $FF,$F7,$FF,$FF,$FF,$FF,$FF,$FF ; A6EA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6F2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6FA
        .byte   $FF,$FF,$FF,$FD,$FF,$FF,$FF,$F7 ; A702
        .byte   $FF,$DF,$FF,$7F,$FF,$7F,$FF,$F7 ; A70A
        .byte   $FF,$FF,$FF,$FF,$FF,$FD,$FF,$F7 ; A712
        .byte   $FF,$DF,$FF,$FF,$FF,$DD,$FF,$FF ; A71A
        .byte   $FF,$D5,$FF,$FF,$FF,$FF,$FF,$FF ; A722
        .byte   $FF,$FF,$FF,$DF,$FF,$FF,$FF,$FF ; A72A
        .byte   $FF,$FF,$FF,$FD,$FF,$FF,$FF,$FF ; A732
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF ; A73A
        .byte   $FF,$FF,$FF,$DF,$FF,$FF,$FF,$FF ; A742
        .byte   $FB,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A74A
        .byte   $FF,$F7,$FF,$FF,$FF,$FD,$FF,$FF ; A752
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A75A
        .byte   $FF,$FF,$FF,$F7,$FF,$FF,$FF,$FF ; A762
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A76A
        .byte   $FF,$FF,$FF,$FF,$FF,$F7,$FF,$FF ; A772
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A77A
        .byte   $FF,$FF,$FF,$DF,$FF,$FD,$FF,$DF ; A782
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A78A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A792
        .byte   $FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF ; A79A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7A2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7AA
        .byte   $FF,$F7,$FF,$FF,$FF,$FD,$FF,$FF ; A7B2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7BA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7C2
        .byte   $FF,$FF,$FF,$FF,$FF,$F7,$FF,$FF ; A7CA
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF ; A7D2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7DA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD ; A7E2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7EA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7F2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF ; A7FA
        brk                                     ; A800 00                       .
        brk                                     ; A801 00                       .
        brk                                     ; A802 00                       .
        brk                                     ; A803 00                       .
        brk                                     ; A804 00                       .
        brk                                     ; A805 00                       .
        brk                                     ; A806 00                       .
        brk                                     ; A807 00                       .
        brk                                     ; A808 00                       .
        brk                                     ; A809 00                       .
        brk                                     ; A80A 00                       .
        brk                                     ; A80B 00                       .
        brk                                     ; A80C 00                       .
        brk                                     ; A80D 00                       .
        brk                                     ; A80E 00                       .
        brk                                     ; A80F 00                       .
        ora     ($01,x)                         ; A810 01 01                    ..
        ora     ($01,x)                         ; A812 01 01                    ..
        ora     ($01,x)                         ; A814 01 01                    ..
        ora     ($01,x)                         ; A816 01 01                    ..
        ora     ($01,x)                         ; A818 01 01                    ..
        ora     ($01,x)                         ; A81A 01 01                    ..
        ora     ($01,x)                         ; A81C 01 01                    ..
        brk                                     ; A81E 00                       .
        ora     ($01,x)                         ; A81F 01 01                    ..
        ora     (L0000,x)                       ; A821 01 00                    ..
        brk                                     ; A823 00                       .
        brk                                     ; A824 00                       .
        ora     (L0000,x)                       ; A825 01 00                    ..
        brk                                     ; A827 00                       .
        ora     ($01,x)                         ; A828 01 01                    ..
        ora     ($01,x)                         ; A82A 01 01                    ..
        brk                                     ; A82C 00                       .
        ora     (L0000,x)                       ; A82D 01 00                    ..
        brk                                     ; A82F 00                       .
        brk                                     ; A830 00                       .
        ora     ($01,x)                         ; A831 01 01                    ..
        ora     ($01,x)                         ; A833 01 01                    ..
        ora     ($01,x)                         ; A835 01 01                    ..
        brk                                     ; A837 00                       .
        ora     ($01,x)                         ; A838 01 01                    ..
        ora     ($01,x)                         ; A83A 01 01                    ..
        brk                                     ; A83C 00                       .
        brk                                     ; A83D 00                       .
        ora     (L0000,x)                       ; A83E 01 00                    ..
        ora     (L0000,x)                       ; A840 01 00                    ..
        brk                                     ; A842 00                       .
        brk                                     ; A843 00                       .
        ora     (L0000,x)                       ; A844 01 00                    ..
        brk                                     ; A846 00                       .
        brk                                     ; A847 00                       .
        brk                                     ; A848 00                       .
        brk                                     ; A849 00                       .
        brk                                     ; A84A 00                       .
        brk                                     ; A84B 00                       .
        brk                                     ; A84C 00                       .
        brk                                     ; A84D 00                       .
        brk                                     ; A84E 00                       .
        ora     ($01,x)                         ; A84F 01 01                    ..
        brk                                     ; A851 00                       .
        ora     ($01,x)                         ; A852 01 01                    ..
        ora     (L0000,x)                       ; A854 01 00                    ..
        ora     (L0000,x)                       ; A856 01 00                    ..
        brk                                     ; A858 00                       .
        ora     ($01,x)                         ; A859 01 01                    ..
        brk                                     ; A85B 00                       .
        ora     ($01,x)                         ; A85C 01 01                    ..
        brk                                     ; A85E 00                       .
        ora     ($01,x)                         ; A85F 01 01                    ..
        brk                                     ; A861 00                       .
        ora     ($01,x)                         ; A862 01 01                    ..
        ora     ($01,x)                         ; A864 01 01                    ..
        ora     ($01,x)                         ; A866 01 01                    ..
        ora     ($01,x)                         ; A868 01 01                    ..
        brk                                     ; A86A 00                       .
        ora     (L0000,x)                       ; A86B 01 00                    ..
        brk                                     ; A86D 00                       .
        ora     (L0000,x)                       ; A86E 01 00                    ..
        brk                                     ; A870 00                       .
        brk                                     ; A871 00                       .
        brk                                     ; A872 00                       .
        brk                                     ; A873 00                       .
        brk                                     ; A874 00                       .
        brk                                     ; A875 00                       .
        brk                                     ; A876 00                       .
        brk                                     ; A877 00                       .
        brk                                     ; A878 00                       .
        brk                                     ; A879 00                       .
        brk                                     ; A87A 00                       .
        ora     ($01,x)                         ; A87B 01 01                    ..
        brk                                     ; A87D 00                       .
        brk                                     ; A87E 00                       .
        brk                                     ; A87F 00                       .
        brk                                     ; A880 00                       .
        ora     (L0000,x)                       ; A881 01 00                    ..
        ora     (L0000,x)                       ; A883 01 00                    ..
        brk                                     ; A885 00                       .
        ora     (L0000,x)                       ; A886 01 00                    ..
        ora     ($01,x)                         ; A888 01 01                    ..
        brk                                     ; A88A 00                       .
        brk                                     ; A88B 00                       .
        brk                                     ; A88C 00                       .
        ora     (L0000,x)                       ; A88D 01 00                    ..
        brk                                     ; A88F 00                       .
        brk                                     ; A890 00                       .
        ora     ($01,x)                         ; A891 01 01                    ..
        ora     (L0000,x)                       ; A893 01 00                    ..
        brk                                     ; A895 00                       .
        ora     (L0000,x)                       ; A896 01 00                    ..
        ora     ($01,x)                         ; A898 01 01                    ..
        brk                                     ; A89A 00                       .
        brk                                     ; A89B 00                       .
        ora     (L0000,x)                       ; A89C 01 00                    ..
        ora     (L0000,x)                       ; A89E 01 00                    ..
        ora     (L0000,x)                       ; A8A0 01 00                    ..
        brk                                     ; A8A2 00                       .
        brk                                     ; A8A3 00                       .
        brk                                     ; A8A4 00                       .
        ora     (L0000,x)                       ; A8A5 01 00                    ..
        brk                                     ; A8A7 00                       .
        brk                                     ; A8A8 00                       .
        brk                                     ; A8A9 00                       .
        ora     (L0000,x)                       ; A8AA 01 00                    ..
        brk                                     ; A8AC 00                       .
        brk                                     ; A8AD 00                       .
        brk                                     ; A8AE 00                       .
        brk                                     ; A8AF 00                       .
        brk                                     ; A8B0 00                       .
        brk                                     ; A8B1 00                       .
        brk                                     ; A8B2 00                       .
        brk                                     ; A8B3 00                       .
        brk                                     ; A8B4 00                       .
        brk                                     ; A8B5 00                       .
        brk                                     ; A8B6 00                       .
        brk                                     ; A8B7 00                       .
        brk                                     ; A8B8 00                       .
        brk                                     ; A8B9 00                       .
        brk                                     ; A8BA 00                       .
        brk                                     ; A8BB 00                       .
        brk                                     ; A8BC 00                       .
        ora     ($01,x)                         ; A8BD 01 01                    ..
        brk                                     ; A8BF 00                       .
        brk                                     ; A8C0 00                       .
        brk                                     ; A8C1 00                       .
        brk                                     ; A8C2 00                       .
        brk                                     ; A8C3 00                       .
        ora     (L0000,x)                       ; A8C4 01 00                    ..
        brk                                     ; A8C6 00                       .
        brk                                     ; A8C7 00                       .
        brk                                     ; A8C8 00                       .
        brk                                     ; A8C9 00                       .
        brk                                     ; A8CA 00                       .
        brk                                     ; A8CB 00                       .
        brk                                     ; A8CC 00                       .
        brk                                     ; A8CD 00                       .
        brk                                     ; A8CE 00                       .
        brk                                     ; A8CF 00                       .
        brk                                     ; A8D0 00                       .
        brk                                     ; A8D1 00                       .
        brk                                     ; A8D2 00                       .
        brk                                     ; A8D3 00                       .
        brk                                     ; A8D4 00                       .
        brk                                     ; A8D5 00                       .
        brk                                     ; A8D6 00                       .
        brk                                     ; A8D7 00                       .
        brk                                     ; A8D8 00                       .
        brk                                     ; A8D9 00                       .
        brk                                     ; A8DA 00                       .
        brk                                     ; A8DB 00                       .
        brk                                     ; A8DC 00                       .
        brk                                     ; A8DD 00                       .
        brk                                     ; A8DE 00                       .
        brk                                     ; A8DF 00                       .
        brk                                     ; A8E0 00                       .
        brk                                     ; A8E1 00                       .
        brk                                     ; A8E2 00                       .
        brk                                     ; A8E3 00                       .
        brk                                     ; A8E4 00                       .
        brk                                     ; A8E5 00                       .
        brk                                     ; A8E6 00                       .
        brk                                     ; A8E7 00                       .
        brk                                     ; A8E8 00                       .
        brk                                     ; A8E9 00                       .
        brk                                     ; A8EA 00                       .
        brk                                     ; A8EB 00                       .
        brk                                     ; A8EC 00                       .
        brk                                     ; A8ED 00                       .
        brk                                     ; A8EE 00                       .
        brk                                     ; A8EF 00                       .
        brk                                     ; A8F0 00                       .
        brk                                     ; A8F1 00                       .
        brk                                     ; A8F2 00                       .
        brk                                     ; A8F3 00                       .
        brk                                     ; A8F4 00                       .
        brk                                     ; A8F5 00                       .
        brk                                     ; A8F6 00                       .
        brk                                     ; A8F7 00                       .
        brk                                     ; A8F8 00                       .
        brk                                     ; A8F9 00                       .
        brk                                     ; A8FA 00                       .
        brk                                     ; A8FB 00                       .
        brk                                     ; A8FC 00                       .
        brk                                     ; A8FD 00                       .
        brk                                     ; A8FE 00                       .
LA8FF:  brk                                     ; A8FF 00                       .
        brk                                     ; A900 00                       .
        ora     ($02,x)                         ; A901 01 02                    ..
        .byte   $03                             ; A903 03                       .
        .byte   $04                             ; A904 04                       .
        ora     $06                             ; A905 05 06                    ..
        .byte   $07                             ; A907 07                       .
        php                                     ; A908 08                       .
        ora     #$0A                            ; A909 09 0A                    ..
        .byte   $0B                             ; A90B 0B                       .
        .byte   $0C                             ; A90C 0C                       .
        ora     $0F0E                           ; A90D 0D 0E 0F                 ...
        bpl     LA923                           ; A910 10 11                    ..
        .byte   $12                             ; A912 12                       .
        .byte   $13                             ; A913 13                       .
        .byte   $14                             ; A914 14                       .
        ora     $16,x                           ; A915 15 16                    ..
        .byte   $17                             ; A917 17                       .
        clc                                     ; A918 18                       .
        ora     $1B1A,y                         ; A919 19 1A 1B                 ...
        .byte   $1C                             ; A91C 1C                       .
        ora     a:L0000,x                       ; A91D 1D 00 00                 ...
        brk                                     ; A920 00                       .
        brk                                     ; A921 00                       .
        brk                                     ; A922 00                       .
LA923:  brk                                     ; A923 00                       .
        brk                                     ; A924 00                       .
        brk                                     ; A925 00                       .
        brk                                     ; A926 00                       .
        brk                                     ; A927 00                       .
        brk                                     ; A928 00                       .
        brk                                     ; A929 00                       .
        brk                                     ; A92A 00                       .
        brk                                     ; A92B 00                       .
        brk                                     ; A92C 00                       .
        brk                                     ; A92D 00                       .
        .byte   $80                             ; A92E 80                       .
        brk                                     ; A92F 00                       .
        brk                                     ; A930 00                       .
        brk                                     ; A931 00                       .
        brk                                     ; A932 00                       .
        brk                                     ; A933 00                       .
        brk                                     ; A934 00                       .
        brk                                     ; A935 00                       .
        brk                                     ; A936 00                       .
        brk                                     ; A937 00                       .
        brk                                     ; A938 00                       .
        brk                                     ; A939 00                       .
        brk                                     ; A93A 00                       .
        brk                                     ; A93B 00                       .
        brk                                     ; A93C 00                       .
        brk                                     ; A93D 00                       .
        brk                                     ; A93E 00                       .
        brk                                     ; A93F 00                       .
        brk                                     ; A940 00                       .
        brk                                     ; A941 00                       .
        brk                                     ; A942 00                       .
        brk                                     ; A943 00                       .
        brk                                     ; A944 00                       .
        brk                                     ; A945 00                       .
        brk                                     ; A946 00                       .
        brk                                     ; A947 00                       .
        brk                                     ; A948 00                       .
        brk                                     ; A949 00                       .
        brk                                     ; A94A 00                       .
        brk                                     ; A94B 00                       .
        brk                                     ; A94C 00                       .
        brk                                     ; A94D 00                       .
        brk                                     ; A94E 00                       .
        brk                                     ; A94F 00                       .
        .byte   $23                             ; A950 23                       #
        .byte   $80                             ; A951 80                       .
        ldy     #$20                            ; A952 A0 20                    . 
        .byte   $80                             ; A954 80                       .
        ldy     $80                             ; A955 A4 80                    ..
        ldy     $40                             ; A957 A4 40                    .@
        .byte   $62                             ; A959 62                       b
        .byte   $80                             ; A95A 80                       .
        .byte   $A3                             ; A95B A3                       .
        jsr     L0020                           ; A95C 20 20 00                   .
        brk                                     ; A95F 00                       .
        brk                                     ; A960 00                       .
        brk                                     ; A961 00                       .
        brk                                     ; A962 00                       .
        brk                                     ; A963 00                       .
        brk                                     ; A964 00                       .
        brk                                     ; A965 00                       .
        brk                                     ; A966 00                       .
        brk                                     ; A967 00                       .
        clc                                     ; A968 18                       .
        ora     #$2D                            ; A969 09 2D                    .-
        eor     $1C19,y                         ; A96B 59 19 1C                 Y..
        .byte   $2B                             ; A96E 2B                       +
        .byte   $2F                             ; A96F 2F                       /
        .byte   $02                             ; A970 02                       .
        and     $02                             ; A971 25 02                    %.
        rol     a                               ; A973 2A                       *
        .byte   $80                             ; A974 80                       .
        ldy     a:L0000,x                       ; A975 BC 00 00                 ...
        brk                                     ; A978 00                       .
        brk                                     ; A979 00                       .
        brk                                     ; A97A 00                       .
        brk                                     ; A97B 00                       .
        brk                                     ; A97C 00                       .
        brk                                     ; A97D 00                       .
        brk                                     ; A97E 00                       .
        brk                                     ; A97F 00                       .
        tay                                     ; A980 A8                       .
        tax                                     ; A981 AA                       .
        brk                                     ; A982 00                       .
        brk                                     ; A983 00                       .
        brk                                     ; A984 00                       .
        .byte   $80                             ; A985 80                       .
        brk                                     ; A986 00                       .
        brk                                     ; A987 00                       .
        .byte   $0F                             ; A988 0F                       .
        bmi     LA9B3                           ; A989 30 28                    0(
        .byte   $07                             ; A98B 07                       .
        .byte   $0F                             ; A98C 0F                       .
        bmi     LA9BB                           ; A98D 30 2C                    0,
        .byte   $0C                             ; A98F 0C                       .
        .byte   $0F                             ; A990 0F                       .
        bmi     LA9BE                           ; A991 30 2B                    0+
        asl     a                               ; A993 0A                       .
        .byte   $0F                             ; A994 0F                       .
        .byte   $17                             ; A995 17                       .
        .byte   $07                             ; A996 07                       .
        php                                     ; A997 08                       .
        brk                                     ; A998 00                       .
        brk                                     ; A999 00                       .
        brk                                     ; A99A 00                       .
        brk                                     ; A99B 00                       .
        brk                                     ; A99C 00                       .
        brk                                     ; A99D 00                       .
        brk                                     ; A99E 00                       .
        brk                                     ; A99F 00                       .
        brk                                     ; A9A0 00                       .
        brk                                     ; A9A1 00                       .
        brk                                     ; A9A2 00                       .
        brk                                     ; A9A3 00                       .
        brk                                     ; A9A4 00                       .
        brk                                     ; A9A5 00                       .
        brk                                     ; A9A6 00                       .
        brk                                     ; A9A7 00                       .
        brk                                     ; A9A8 00                       .
        brk                                     ; A9A9 00                       .
        brk                                     ; A9AA 00                       .
        brk                                     ; A9AB 00                       .
        brk                                     ; A9AC 00                       .
        brk                                     ; A9AD 00                       .
        brk                                     ; A9AE 00                       .
        brk                                     ; A9AF 00                       .
        brk                                     ; A9B0 00                       .
        brk                                     ; A9B1 00                       .
        brk                                     ; A9B2 00                       .
LA9B3:  brk                                     ; A9B3 00                       .
        brk                                     ; A9B4 00                       .
        brk                                     ; A9B5 00                       .
        brk                                     ; A9B6 00                       .
        brk                                     ; A9B7 00                       .
        brk                                     ; A9B8 00                       .
        brk                                     ; A9B9 00                       .
        brk                                     ; A9BA 00                       .
LA9BB:  brk                                     ; A9BB 00                       .
        brk                                     ; A9BC 00                       .
        brk                                     ; A9BD 00                       .
LA9BE:  brk                                     ; A9BE 00                       .
        brk                                     ; A9BF 00                       .
        brk                                     ; A9C0 00                       .
        brk                                     ; A9C1 00                       .
        brk                                     ; A9C2 00                       .
        brk                                     ; A9C3 00                       .
        brk                                     ; A9C4 00                       .
        brk                                     ; A9C5 00                       .
        brk                                     ; A9C6 00                       .
        brk                                     ; A9C7 00                       .
        brk                                     ; A9C8 00                       .
        brk                                     ; A9C9 00                       .
        brk                                     ; A9CA 00                       .
        brk                                     ; A9CB 00                       .
        brk                                     ; A9CC 00                       .
        brk                                     ; A9CD 00                       .
        brk                                     ; A9CE 00                       .
        brk                                     ; A9CF 00                       .
        brk                                     ; A9D0 00                       .
        brk                                     ; A9D1 00                       .
        brk                                     ; A9D2 00                       .
        brk                                     ; A9D3 00                       .
        brk                                     ; A9D4 00                       .
        brk                                     ; A9D5 00                       .
        brk                                     ; A9D6 00                       .
        brk                                     ; A9D7 00                       .
        brk                                     ; A9D8 00                       .
        brk                                     ; A9D9 00                       .
        brk                                     ; A9DA 00                       .
        brk                                     ; A9DB 00                       .
        brk                                     ; A9DC 00                       .
        brk                                     ; A9DD 00                       .
        brk                                     ; A9DE 00                       .
        brk                                     ; A9DF 00                       .
        .byte   $FF                             ; A9E0 FF                       .
        brk                                     ; A9E1 00                       .
        brk                                     ; A9E2 00                       .
        brk                                     ; A9E3 00                       .
        brk                                     ; A9E4 00                       .
        brk                                     ; A9E5 00                       .
        brk                                     ; A9E6 00                       .
        brk                                     ; A9E7 00                       .
        brk                                     ; A9E8 00                       .
        brk                                     ; A9E9 00                       .
        brk                                     ; A9EA 00                       .
        brk                                     ; A9EB 00                       .
        brk                                     ; A9EC 00                       .
        brk                                     ; A9ED 00                       .
        brk                                     ; A9EE 00                       .
        brk                                     ; A9EF 00                       .
        brk                                     ; A9F0 00                       .
        brk                                     ; A9F1 00                       .
        brk                                     ; A9F2 00                       .
        brk                                     ; A9F3 00                       .
        brk                                     ; A9F4 00                       .
        brk                                     ; A9F5 00                       .
        brk                                     ; A9F6 00                       .
        brk                                     ; A9F7 00                       .
        brk                                     ; A9F8 00                       .
        brk                                     ; A9F9 00                       .
        brk                                     ; A9FA 00                       .
        brk                                     ; A9FB 00                       .
        brk                                     ; A9FC 00                       .
        brk                                     ; A9FD 00                       .
        brk                                     ; A9FE 00                       .
        brk                                     ; A9FF 00                       .
        ora     ($01,x)                         ; AA00 01 01                    ..
        ora     ($02,x)                         ; AA02 01 02                    ..
        .byte   $02                             ; AA04 02                       .
        .byte   $02                             ; AA05 02                       .
        .byte   $03                             ; AA06 03                       .
        .byte   $03                             ; AA07 03                       .
        .byte   $03                             ; AA08 03                       .
        .byte   $03                             ; AA09 03                       .
        .byte   $04                             ; AA0A 04                       .
        .byte   $04                             ; AA0B 04                       .
        .byte   $04                             ; AA0C 04                       .
        ora     $05                             ; AA0D 05 05                    ..
        ora     $05                             ; AA0F 05 05                    ..
        asl     $06                             ; AA11 06 06                    ..
        asl     $06                             ; AA13 06 06                    ..
        asl     $07                             ; AA15 06 07                    ..
        .byte   $07                             ; AA17 07                       .
        .byte   $07                             ; AA18 07                       .
        .byte   $07                             ; AA19 07                       .
        .byte   $07                             ; AA1A 07                       .
        ora     #$09                            ; AA1B 09 09                    ..
        ora     #$0A                            ; AA1D 09 0A                    ..
        asl     a                               ; AA1F 0A                       .
        .byte   $0B                             ; AA20 0B                       .
        .byte   $0B                             ; AA21 0B                       .
        ora     $0F0F                           ; AA22 0D 0F 0F                 ...
        .byte   $0F                             ; AA25 0F                       .
        .byte   $0F                             ; AA26 0F                       .
        bpl     LAA3A                           ; AA27 10 11                    ..
        ora     ($12),y                         ; AA29 11 12                    ..
        .byte   $12                             ; AA2B 12                       .
        .byte   $12                             ; AA2C 12                       .
        .byte   $13                             ; AA2D 13                       .
        ora     $15,x                           ; AA2E 15 15                    ..
        asl     $16,x                           ; AA30 16 16                    ..
        asl     $16,x                           ; AA32 16 16                    ..
        .byte   $17                             ; AA34 17                       .
        .byte   $17                             ; AA35 17                       .
        ora     $1919,y                         ; AA36 19 19 19                 ...
        .byte   $19                             ; AA39 19                       .
LAA3A:  .byte   $1A                             ; AA3A 1A                       .
        .byte   $1A                             ; AA3B 1A                       .
        .byte   $1A                             ; AA3C 1A                       .
        .byte   $1B                             ; AA3D 1B                       .
        .byte   $1B                             ; AA3E 1B                       .
LAA3F:  ora     a:$FF,x                         ; AA3F 1D FF 00                 ...
        brk                                     ; AA42 00                       .
        brk                                     ; AA43 00                       .
        brk                                     ; AA44 00                       .
        .byte   $04                             ; AA45 04                       .
        brk                                     ; AA46 00                       .
        brk                                     ; AA47 00                       .
        brk                                     ; AA48 00                       .
        brk                                     ; AA49 00                       .
        brk                                     ; AA4A 00                       .
        brk                                     ; AA4B 00                       .
        brk                                     ; AA4C 00                       .
        brk                                     ; AA4D 00                       .
        brk                                     ; AA4E 00                       .
        brk                                     ; AA4F 00                       .
        brk                                     ; AA50 00                       .
        brk                                     ; AA51 00                       .
        brk                                     ; AA52 00                       .
        brk                                     ; AA53 00                       .
        brk                                     ; AA54 00                       .
        brk                                     ; AA55 00                       .
        brk                                     ; AA56 00                       .
        brk                                     ; AA57 00                       .
        brk                                     ; AA58 00                       .
        brk                                     ; AA59 00                       .
LAA5A:  brk                                     ; AA5A 00                       .
        brk                                     ; AA5B 00                       .
        brk                                     ; AA5C 00                       .
        brk                                     ; AA5D 00                       .
        brk                                     ; AA5E 00                       .
        brk                                     ; AA5F 00                       .
        brk                                     ; AA60 00                       .
        brk                                     ; AA61 00                       .
LAA62:  brk                                     ; AA62 00                       .
LAA63:  brk                                     ; AA63 00                       .
        brk                                     ; AA64 00                       .
        brk                                     ; AA65 00                       .
        brk                                     ; AA66 00                       .
        brk                                     ; AA67 00                       .
        brk                                     ; AA68 00                       .
        brk                                     ; AA69 00                       .
        brk                                     ; AA6A 00                       .
        brk                                     ; AA6B 00                       .
        brk                                     ; AA6C 00                       .
        brk                                     ; AA6D 00                       .
        brk                                     ; AA6E 00                       .
        brk                                     ; AA6F 00                       .
        brk                                     ; AA70 00                       .
        brk                                     ; AA71 00                       .
        brk                                     ; AA72 00                       .
        brk                                     ; AA73 00                       .
        brk                                     ; AA74 00                       .
        brk                                     ; AA75 00                       .
        brk                                     ; AA76 00                       .
        brk                                     ; AA77 00                       .
        brk                                     ; AA78 00                       .
        brk                                     ; AA79 00                       .
        brk                                     ; AA7A 00                       .
        brk                                     ; AA7B 00                       .
        brk                                     ; AA7C 00                       .
        brk                                     ; AA7D 00                       .
        brk                                     ; AA7E 00                       .
        brk                                     ; AA7F 00                       .
        jsr     LC070                           ; AA80 20 70 C0                  p.
        php                                     ; AA83 08                       .
        clc                                     ; AA84 18                       .
        bvs     LAA97                           ; AA85 70 10                    p.
        bmi     LAAE9                           ; AA87 30 60                    0`
        cpy     #$58                            ; AA89 C0 58                    .X
        cld                                     ; AA8B D8                       .
        inx                                     ; AA8C E8                       .
        bcc     LAA3F                           ; AA8D 90 B0                    ..
        bne     LAA62                           ; AA8F D0 D1                    ..
        bmi     LAAF3                           ; AA91 30 60                    0`
        ldy     #$E0                            ; AA93 A0 E0                    ..
        sbc     ($40,x)                         ; AA95 E1 40                    .@
LAA97:  rts                                     ; AA97 60                       `

; ----------------------------------------------------------------------------
        ldy     #$40                            ; AA98 A0 40                    .@
        bvc     LAABC                           ; AA9A 50 20                    P 
        tay                                     ; AA9C A8                       .
        sed                                     ; AA9D F8                       .
        dey                                     ; AA9E 88                       .
        iny                                     ; AA9F C8                       .
        .byte   $30                             ; AAA0 30                       0
LAAA1:  clv                                     ; AAA1 B8                       .
        rts                                     ; AAA2 60                       `

; ----------------------------------------------------------------------------
        sec                                     ; AAA3 38                       8
        sec                                     ; AAA4 38                       8
        inc     LA8FF,x                         ; AAA5 FE FF A8                 ...
        dey                                     ; AAA8 88                       .
        iny                                     ; AAA9 C8                       .
        bpl     LAAEC                           ; AAAA 10 40                    .@
        tya                                     ; AAAC 98                       .
        pla                                     ; AAAD 68                       h
        jsr     L30C0                           ; AAAE 20 C0 30                  .0
LAAB1:  bcc     LAA63                           ; AAB1 90 B0                    ..
        bne     LAAE5                           ; AAB3 D0 30                    .0
        cli                                     ; AAB5 58                       X
        pla                                     ; AAB6 68                       h
        pla                                     ; AAB7 68                       h
        tya                                     ; AAB8 98                       .
        sed                                     ; AAB9 F8                       .
        rti                                     ; AABA 40                       @

; ----------------------------------------------------------------------------
        tya                                     ; AABB 98                       .
LAABC:  inx                                     ; AABC E8                       .
        tay                                     ; AABD A8                       .
        iny                                     ; AABE C8                       .
        cld                                     ; AABF D8                       .
        .byte   $FF                             ; AAC0 FF                       .
        brk                                     ; AAC1 00                       .
        brk                                     ; AAC2 00                       .
        brk                                     ; AAC3 00                       .
        brk                                     ; AAC4 00                       .
        brk                                     ; AAC5 00                       .
        jsr     L0000                           ; AAC6 20 00 00                  ..
        brk                                     ; AAC9 00                       .
        brk                                     ; AACA 00                       .
        brk                                     ; AACB 00                       .
        brk                                     ; AACC 00                       .
        brk                                     ; AACD 00                       .
        brk                                     ; AACE 00                       .
        brk                                     ; AACF 00                       .
        brk                                     ; AAD0 00                       .
        brk                                     ; AAD1 00                       .
        brk                                     ; AAD2 00                       .
        brk                                     ; AAD3 00                       .
        brk                                     ; AAD4 00                       .
        brk                                     ; AAD5 00                       .
        brk                                     ; AAD6 00                       .
        brk                                     ; AAD7 00                       .
        brk                                     ; AAD8 00                       .
        brk                                     ; AAD9 00                       .
        brk                                     ; AADA 00                       .
LAADB:  brk                                     ; AADB 00                       .
        brk                                     ; AADC 00                       .
        brk                                     ; AADD 00                       .
        brk                                     ; AADE 00                       .
        brk                                     ; AADF 00                       .
        brk                                     ; AAE0 00                       .
        brk                                     ; AAE1 00                       .
        brk                                     ; AAE2 00                       .
        brk                                     ; AAE3 00                       .
        brk                                     ; AAE4 00                       .
LAAE5:  brk                                     ; AAE5 00                       .
        brk                                     ; AAE6 00                       .
        brk                                     ; AAE7 00                       .
        brk                                     ; AAE8 00                       .
LAAE9:  brk                                     ; AAE9 00                       .
        brk                                     ; AAEA 00                       .
        brk                                     ; AAEB 00                       .
LAAEC:  brk                                     ; AAEC 00                       .
        ora     (L0000,x)                       ; AAED 01 00                    ..
        brk                                     ; AAEF 00                       .
        brk                                     ; AAF0 00                       .
LAAF1:  brk                                     ; AAF1 00                       .
        brk                                     ; AAF2 00                       .
LAAF3:  brk                                     ; AAF3 00                       .
        brk                                     ; AAF4 00                       .
        brk                                     ; AAF5 00                       .
        brk                                     ; AAF6 00                       .
        brk                                     ; AAF7 00                       .
        brk                                     ; AAF8 00                       .
        brk                                     ; AAF9 00                       .
        brk                                     ; AAFA 00                       .
        brk                                     ; AAFB 00                       .
        brk                                     ; AAFC 00                       .
        brk                                     ; AAFD 00                       .
        brk                                     ; AAFE 00                       .
        brk                                     ; AAFF 00                       .
        rts                                     ; AB00 60                       `

; ----------------------------------------------------------------------------
        clv                                     ; AB01 B8                       .
        tya                                     ; AB02 98                       .
        tya                                     ; AB03 98                       .
        clc                                     ; AB04 18                       .
        tya                                     ; AB05 98                       .
        clv                                     ; AB06 B8                       .
        bvc     LAAB1                           ; AB07 50 A8                    P.
        tay                                     ; AB09 A8                       .
        jsr     L8830                           ; AB0A 20 30 88                  0.
        sei                                     ; AB0D 78                       x
        cli                                     ; AB0E 58                       X
        pha                                     ; AB0F 48                       H
        cpy     #$30                            ; AB10 C0 30                    .0
        rti                                     ; AB12 40                       @

; ----------------------------------------------------------------------------
        bvs     LAB25                           ; AB13 70 10                    p.
        .byte   $80                             ; AB15 80                       .
        rts                                     ; AB16 60                       `

; ----------------------------------------------------------------------------
        bcs     LAAA1                           ; AB17 B0 88                    ..
        bvs     LAADB                           ; AB19 70 C0                    p.
        tya                                     ; AB1B 98                       .
        bcc     LAB7E                           ; AB1C 90 60                    .`
        bcc     LAB80                           ; AB1E 90 60                    .`
        rts                                     ; AB20 60                       `

; ----------------------------------------------------------------------------
        ldy     #$31                            ; AB21 A0 31                    .1
        inx                                     ; AB23 E8                       .
        inx                                     ; AB24 E8                       .
LAB25:  plp                                     ; AB25 28                       (
        cli                                     ; AB26 58                       X
        sei                                     ; AB27 78                       x
        bvs     LAB9A                           ; AB28 70 70                    pp
        jsr     LD8D0                           ; AB2A 20 D0 D8                  ..
        sty     $A4,x                           ; AB2D 94 A4                    ..
        bcs     LAAF1                           ; AB2F B0 C0                    ..
        ldy     #$80                            ; AB31 A0 80                    ..
        rts                                     ; AB33 60                       `

; ----------------------------------------------------------------------------
        clv                                     ; AB34 B8                       .
        .byte   $74                             ; AB35 74                       t
        inx                                     ; AB36 E8                       .
        inx                                     ; AB37 E8                       .
        dey                                     ; AB38 88                       .
        pla                                     ; AB39 68                       h
        sei                                     ; AB3A 78                       x
        pla                                     ; AB3B 68                       h
        rti                                     ; AB3C 40                       @

; ----------------------------------------------------------------------------
        sec                                     ; AB3D 38                       8
        pha                                     ; AB3E 48                       H
        brk                                     ; AB3F 00                       .
        .byte   $FF                             ; AB40 FF                       .
        brk                                     ; AB41 00                       .
        brk                                     ; AB42 00                       .
        brk                                     ; AB43 00                       .
        brk                                     ; AB44 00                       .
        brk                                     ; AB45 00                       .
        brk                                     ; AB46 00                       .
        brk                                     ; AB47 00                       .
        brk                                     ; AB48 00                       .
        brk                                     ; AB49 00                       .
        brk                                     ; AB4A 00                       .
        brk                                     ; AB4B 00                       .
        brk                                     ; AB4C 00                       .
        brk                                     ; AB4D 00                       .
        brk                                     ; AB4E 00                       .
        brk                                     ; AB4F 00                       .
        brk                                     ; AB50 00                       .
        brk                                     ; AB51 00                       .
        brk                                     ; AB52 00                       .
        brk                                     ; AB53 00                       .
        brk                                     ; AB54 00                       .
        brk                                     ; AB55 00                       .
        brk                                     ; AB56 00                       .
        brk                                     ; AB57 00                       .
        brk                                     ; AB58 00                       .
        brk                                     ; AB59 00                       .
        brk                                     ; AB5A 00                       .
        brk                                     ; AB5B 00                       .
        brk                                     ; AB5C 00                       .
        brk                                     ; AB5D 00                       .
        brk                                     ; AB5E 00                       .
        brk                                     ; AB5F 00                       .
        brk                                     ; AB60 00                       .
        brk                                     ; AB61 00                       .
        brk                                     ; AB62 00                       .
        brk                                     ; AB63 00                       .
        brk                                     ; AB64 00                       .
        brk                                     ; AB65 00                       .
        brk                                     ; AB66 00                       .
        brk                                     ; AB67 00                       .
        brk                                     ; AB68 00                       .
        brk                                     ; AB69 00                       .
        brk                                     ; AB6A 00                       .
        brk                                     ; AB6B 00                       .
        brk                                     ; AB6C 00                       .
        brk                                     ; AB6D 00                       .
        brk                                     ; AB6E 00                       .
        brk                                     ; AB6F 00                       .
        brk                                     ; AB70 00                       .
        brk                                     ; AB71 00                       .
        brk                                     ; AB72 00                       .
        brk                                     ; AB73 00                       .
        brk                                     ; AB74 00                       .
        brk                                     ; AB75 00                       .
        brk                                     ; AB76 00                       .
        brk                                     ; AB77 00                       .
        brk                                     ; AB78 00                       .
        brk                                     ; AB79 00                       .
        brk                                     ; AB7A 00                       .
        brk                                     ; AB7B 00                       .
        brk                                     ; AB7C 00                       .
        brk                                     ; AB7D 00                       .
LAB7E:  brk                                     ; AB7E 00                       .
        brk                                     ; AB7F 00                       .
LAB80:  ora     $3232                           ; AB80 0D 32 32                 .22
        .byte   $32                             ; AB83 32                       2
        ora     $3232                           ; AB84 0D 32 32                 .22
        ora     $3232                           ; AB87 0D 32 32                 .22
        .byte   $1C                             ; AB8A 1C                       .
        .byte   $1C                             ; AB8B 1C                       .
        sty     $34                             ; AB8C 84 34                    .4
        .byte   $34                             ; AB8E 34                       4
        .byte   $34                             ; AB8F 34                       4
        .byte   $14                             ; AB90 14                       .
        adc     ($22,x)                         ; AB91 61 22                    a"
        rol     $61                             ; AB93 26 61                    &a
        adc     ($22,x)                         ; AB95 61 22                    a"
        .byte   $22                             ; AB97 22                       "
        rol     $61                             ; AB98 26 61                    &a
LAB9A:  adc     ($02,x)                         ; AB9A 61 02                    a.
        php                                     ; AB9C 08                       .
        .byte   $02                             ; AB9D 02                       .
        php                                     ; AB9E 08                       .
        php                                     ; AB9F 08                       .
        .byte   $02                             ; ABA0 02                       .
        php                                     ; ABA1 08                       .
        .byte   $2B                             ; ABA2 2B                       +
        lsr     $57,x                           ; ABA3 56 57                    VW
        sta     ($83,x)                         ; ABA5 81 83                    ..
        rol     $36,x                           ; ABA7 36 36                    66
        rol     $36,x                           ; ABA9 36 36                    66
        rol     $36,x                           ; ABAB 36 36                    66
        .byte   $0C                             ; ABAD 0C                       .
        .byte   $0C                             ; ABAE 0C                       .
        .byte   $14                             ; ABAF 14                       .
        .byte   $14                             ; ABB0 14                       .
        .byte   $14                             ; ABB1 14                       .
        .byte   $14                             ; ABB2 14                       .
        .byte   $14                             ; ABB3 14                       .
        sta     ($0C,x)                         ; ABB4 81 0C                    ..
        lsr     $57,x                           ; ABB6 56 57                    VW
        ora     ($01,x)                         ; ABB8 01 01                    ..
        ora     ($01,x)                         ; ABBA 01 01                    ..
        ora     ($01,x)                         ; ABBC 01 01                    ..
        ora     ($6B,x)                         ; ABBE 01 6B                    .k
        .byte   $FF                             ; ABC0 FF                       .
        brk                                     ; ABC1 00                       .
        brk                                     ; ABC2 00                       .
        brk                                     ; ABC3 00                       .
        brk                                     ; ABC4 00                       .
        brk                                     ; ABC5 00                       .
        brk                                     ; ABC6 00                       .
        brk                                     ; ABC7 00                       .
        brk                                     ; ABC8 00                       .
        brk                                     ; ABC9 00                       .
        brk                                     ; ABCA 00                       .
        brk                                     ; ABCB 00                       .
        brk                                     ; ABCC 00                       .
        brk                                     ; ABCD 00                       .
        brk                                     ; ABCE 00                       .
        brk                                     ; ABCF 00                       .
        brk                                     ; ABD0 00                       .
        brk                                     ; ABD1 00                       .
        brk                                     ; ABD2 00                       .
        brk                                     ; ABD3 00                       .
        brk                                     ; ABD4 00                       .
        brk                                     ; ABD5 00                       .
        brk                                     ; ABD6 00                       .
        brk                                     ; ABD7 00                       .
        brk                                     ; ABD8 00                       .
        brk                                     ; ABD9 00                       .
        brk                                     ; ABDA 00                       .
        brk                                     ; ABDB 00                       .
        brk                                     ; ABDC 00                       .
        brk                                     ; ABDD 00                       .
        brk                                     ; ABDE 00                       .
        brk                                     ; ABDF 00                       .
        brk                                     ; ABE0 00                       .
        brk                                     ; ABE1 00                       .
        brk                                     ; ABE2 00                       .
        brk                                     ; ABE3 00                       .
        brk                                     ; ABE4 00                       .
        brk                                     ; ABE5 00                       .
        brk                                     ; ABE6 00                       .
        brk                                     ; ABE7 00                       .
        brk                                     ; ABE8 00                       .
        brk                                     ; ABE9 00                       .
        brk                                     ; ABEA 00                       .
        brk                                     ; ABEB 00                       .
        brk                                     ; ABEC 00                       .
        brk                                     ; ABED 00                       .
        brk                                     ; ABEE 00                       .
        brk                                     ; ABEF 00                       .
        brk                                     ; ABF0 00                       .
        brk                                     ; ABF1 00                       .
        brk                                     ; ABF2 00                       .
        brk                                     ; ABF3 00                       .
        brk                                     ; ABF4 00                       .
        brk                                     ; ABF5 00                       .
        brk                                     ; ABF6 00                       .
        brk                                     ; ABF7 00                       .
        brk                                     ; ABF8 00                       .
        brk                                     ; ABF9 00                       .
        brk                                     ; ABFA 00                       .
        brk                                     ; ABFB 00                       .
        brk                                     ; ABFC 00                       .
        brk                                     ; ABFD 00                       .
        brk                                     ; ABFE 00                       .
        brk                                     ; ABFF 00                       .
        brk                                     ; AC00 00                       .
        brk                                     ; AC01 00                       .
        .byte   $03                             ; AC02 03                       .
        asl     $0A                             ; AC03 06 0A                    ..
        ora     $1611                           ; AC05 0D 11 16                 ...
        .byte   $1B                             ; AC08 1B                       .
        .byte   $1B                             ; AC09 1B                       .
        asl     $2220,x                         ; AC0A 1E 20 22                 . "
        .byte   $22                             ; AC0D 22                       "
        .byte   $23                             ; AC0E 23                       #
        .byte   $23                             ; AC0F 23                       #
        .byte   $27                             ; AC10 27                       '
        plp                                     ; AC11 28                       (
        rol     a                               ; AC12 2A                       *
        and     $2E2E                           ; AC13 2D 2E 2E                 -..
        bmi     LAC4C                           ; AC16 30 34                    04
        rol     $36,x                           ; AC18 36 36                    66
        .byte   $3A                             ; AC1A 3A                       :
        and     $3F3F,x                         ; AC1B 3D 3F 3F                 =??
        brk                                     ; AC1E 00                       .
        brk                                     ; AC1F 00                       .
        brk                                     ; AC20 00                       .
        brk                                     ; AC21 00                       .
        brk                                     ; AC22 00                       .
        brk                                     ; AC23 00                       .
        brk                                     ; AC24 00                       .
        brk                                     ; AC25 00                       .
        brk                                     ; AC26 00                       .
        brk                                     ; AC27 00                       .
        brk                                     ; AC28 00                       .
        brk                                     ; AC29 00                       .
        brk                                     ; AC2A 00                       .
        brk                                     ; AC2B 00                       .
        brk                                     ; AC2C 00                       .
        brk                                     ; AC2D 00                       .
        brk                                     ; AC2E 00                       .
        brk                                     ; AC2F 00                       .
        brk                                     ; AC30 00                       .
        brk                                     ; AC31 00                       .
        brk                                     ; AC32 00                       .
        brk                                     ; AC33 00                       .
        brk                                     ; AC34 00                       .
        brk                                     ; AC35 00                       .
        brk                                     ; AC36 00                       .
        brk                                     ; AC37 00                       .
        brk                                     ; AC38 00                       .
        brk                                     ; AC39 00                       .
        brk                                     ; AC3A 00                       .
        brk                                     ; AC3B 00                       .
        brk                                     ; AC3C 00                       .
        brk                                     ; AC3D 00                       .
        brk                                     ; AC3E 00                       .
        brk                                     ; AC3F 00                       .
        brk                                     ; AC40 00                       .
        brk                                     ; AC41 00                       .
        brk                                     ; AC42 00                       .
        brk                                     ; AC43 00                       .
        brk                                     ; AC44 00                       .
        brk                                     ; AC45 00                       .
        brk                                     ; AC46 00                       .
        brk                                     ; AC47 00                       .
        brk                                     ; AC48 00                       .
        brk                                     ; AC49 00                       .
        brk                                     ; AC4A 00                       .
        brk                                     ; AC4B 00                       .
LAC4C:  brk                                     ; AC4C 00                       .
        brk                                     ; AC4D 00                       .
        brk                                     ; AC4E 00                       .
        brk                                     ; AC4F 00                       .
        brk                                     ; AC50 00                       .
        brk                                     ; AC51 00                       .
        brk                                     ; AC52 00                       .
        brk                                     ; AC53 00                       .
        brk                                     ; AC54 00                       .
        brk                                     ; AC55 00                       .
        brk                                     ; AC56 00                       .
        brk                                     ; AC57 00                       .
        brk                                     ; AC58 00                       .
        brk                                     ; AC59 00                       .
        brk                                     ; AC5A 00                       .
        brk                                     ; AC5B 00                       .
        brk                                     ; AC5C 00                       .
        brk                                     ; AC5D 00                       .
        brk                                     ; AC5E 00                       .
        brk                                     ; AC5F 00                       .
        jsr     L0000                           ; AC60 20 00 00                  ..
        brk                                     ; AC63 00                       .
        brk                                     ; AC64 00                       .
        brk                                     ; AC65 00                       .
        brk                                     ; AC66 00                       .
        brk                                     ; AC67 00                       .
        brk                                     ; AC68 00                       .
        brk                                     ; AC69 00                       .
        brk                                     ; AC6A 00                       .
        brk                                     ; AC6B 00                       .
        brk                                     ; AC6C 00                       .
        brk                                     ; AC6D 00                       .
        brk                                     ; AC6E 00                       .
        brk                                     ; AC6F 00                       .
        brk                                     ; AC70 00                       .
        brk                                     ; AC71 00                       .
        brk                                     ; AC72 00                       .
        rti                                     ; AC73 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AC74 00                       .
        brk                                     ; AC75 00                       .
        brk                                     ; AC76 00                       .
        brk                                     ; AC77 00                       .
        brk                                     ; AC78 00                       .
        brk                                     ; AC79 00                       .
        brk                                     ; AC7A 00                       .
        brk                                     ; AC7B 00                       .
        brk                                     ; AC7C 00                       .
        brk                                     ; AC7D 00                       .
        brk                                     ; AC7E 00                       .
        brk                                     ; AC7F 00                       .
        brk                                     ; AC80 00                       .
        brk                                     ; AC81 00                       .
        brk                                     ; AC82 00                       .
        brk                                     ; AC83 00                       .
        brk                                     ; AC84 00                       .
        rti                                     ; AC85 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AC86 00                       .
        brk                                     ; AC87 00                       .
        brk                                     ; AC88 00                       .
        brk                                     ; AC89 00                       .
        brk                                     ; AC8A 00                       .
        brk                                     ; AC8B 00                       .
        brk                                     ; AC8C 00                       .
        brk                                     ; AC8D 00                       .
        brk                                     ; AC8E 00                       .
        brk                                     ; AC8F 00                       .
        brk                                     ; AC90 00                       .
        brk                                     ; AC91 00                       .
        brk                                     ; AC92 00                       .
        brk                                     ; AC93 00                       .
        brk                                     ; AC94 00                       .
        brk                                     ; AC95 00                       .
        brk                                     ; AC96 00                       .
        brk                                     ; AC97 00                       .
        brk                                     ; AC98 00                       .
        brk                                     ; AC99 00                       .
LAC9A:  brk                                     ; AC9A 00                       .
        brk                                     ; AC9B 00                       .
        brk                                     ; AC9C 00                       .
        brk                                     ; AC9D 00                       .
        brk                                     ; AC9E 00                       .
        brk                                     ; AC9F 00                       .
        brk                                     ; ACA0 00                       .
        brk                                     ; ACA1 00                       .
        brk                                     ; ACA2 00                       .
        brk                                     ; ACA3 00                       .
        brk                                     ; ACA4 00                       .
        brk                                     ; ACA5 00                       .
        brk                                     ; ACA6 00                       .
        brk                                     ; ACA7 00                       .
        brk                                     ; ACA8 00                       .
        brk                                     ; ACA9 00                       .
        brk                                     ; ACAA 00                       .
        brk                                     ; ACAB 00                       .
        brk                                     ; ACAC 00                       .
        ora     (L0000,x)                       ; ACAD 01 00                    ..
        brk                                     ; ACAF 00                       .
        brk                                     ; ACB0 00                       .
        brk                                     ; ACB1 00                       .
        brk                                     ; ACB2 00                       .
        brk                                     ; ACB3 00                       .
        brk                                     ; ACB4 00                       .
        brk                                     ; ACB5 00                       .
        brk                                     ; ACB6 00                       .
        brk                                     ; ACB7 00                       .
        brk                                     ; ACB8 00                       .
        brk                                     ; ACB9 00                       .
        brk                                     ; ACBA 00                       .
        brk                                     ; ACBB 00                       .
        brk                                     ; ACBC 00                       .
        brk                                     ; ACBD 00                       .
        brk                                     ; ACBE 00                       .
        brk                                     ; ACBF 00                       .
        brk                                     ; ACC0 00                       .
        brk                                     ; ACC1 00                       .
        brk                                     ; ACC2 00                       .
        brk                                     ; ACC3 00                       .
        brk                                     ; ACC4 00                       .
        brk                                     ; ACC5 00                       .
        brk                                     ; ACC6 00                       .
        brk                                     ; ACC7 00                       .
        brk                                     ; ACC8 00                       .
        brk                                     ; ACC9 00                       .
        brk                                     ; ACCA 00                       .
        brk                                     ; ACCB 00                       .
        brk                                     ; ACCC 00                       .
        brk                                     ; ACCD 00                       .
        brk                                     ; ACCE 00                       .
        brk                                     ; ACCF 00                       .
        brk                                     ; ACD0 00                       .
        brk                                     ; ACD1 00                       .
        .byte   $80                             ; ACD2 80                       .
        brk                                     ; ACD3 00                       .
        brk                                     ; ACD4 00                       .
        brk                                     ; ACD5 00                       .
        brk                                     ; ACD6 00                       .
        brk                                     ; ACD7 00                       .
        brk                                     ; ACD8 00                       .
        brk                                     ; ACD9 00                       .
        brk                                     ; ACDA 00                       .
        brk                                     ; ACDB 00                       .
        brk                                     ; ACDC 00                       .
        brk                                     ; ACDD 00                       .
        brk                                     ; ACDE 00                       .
        brk                                     ; ACDF 00                       .
        brk                                     ; ACE0 00                       .
        brk                                     ; ACE1 00                       .
        brk                                     ; ACE2 00                       .
        brk                                     ; ACE3 00                       .
        brk                                     ; ACE4 00                       .
        brk                                     ; ACE5 00                       .
        brk                                     ; ACE6 00                       .
        brk                                     ; ACE7 00                       .
        brk                                     ; ACE8 00                       .
        brk                                     ; ACE9 00                       .
        brk                                     ; ACEA 00                       .
        brk                                     ; ACEB 00                       .
        brk                                     ; ACEC 00                       .
        brk                                     ; ACED 00                       .
        brk                                     ; ACEE 00                       .
        brk                                     ; ACEF 00                       .
        brk                                     ; ACF0 00                       .
        brk                                     ; ACF1 00                       .
        brk                                     ; ACF2 00                       .
        brk                                     ; ACF3 00                       .
        brk                                     ; ACF4 00                       .
        brk                                     ; ACF5 00                       .
        bpl     LACF8                           ; ACF6 10 00                    ..
LACF8:  brk                                     ; ACF8 00                       .
        brk                                     ; ACF9 00                       .
        brk                                     ; ACFA 00                       .
        brk                                     ; ACFB 00                       .
        brk                                     ; ACFC 00                       .
        brk                                     ; ACFD 00                       .
        bpl     LAD00                           ; ACFE 10 00                    ..
LAD00:  brk                                     ; AD00 00                       .
        .byte   $34                             ; AD01 34                       4
        .byte   $02                             ; AD02 02                       .
        .byte   $04                             ; AD03 04                       .
        asl     $64                             ; AD04 06 64                    .d
        brk                                     ; AD06 00                       .
        sty     $1006                           ; AD07 8C 06 10                 ...
        rol     $76                             ; AD0A 26 76                    &v
        brk                                     ; AD0C 00                       .
        brk                                     ; AD0D 00                       .
        inx                                     ; AD0E E8                       .
        stx     a:L0000                         ; AD0F 8E 00 00                 ...
        .byte   $5C                             ; AD12 5C                       \
        lsr     $586A,x                         ; AD13 5E 6A 58                 ^jX
        sei                                     ; AD16 78                       x
        eor     $0110,y                         ; AD17 59 10 01                 Y..
        ora     ($01,x)                         ; AD1A 01 01                    ..
        php                                     ; AD1C 08                       .
        .byte   $0B                             ; AD1D 0B                       .
        .byte   $0B                             ; AD1E 0B                       .
        .byte   $0B                             ; AD1F 0B                       .
        jsr     L4622                           ; AD20 20 22 46                  "F
        bit     L0028                           ; AD23 24 28                    $(
        rol     a                               ; AD25 2A                       *
        bit     $2001                           ; AD26 2C 01 20                 ,. 
        rti                                     ; AD29 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; AD2A 42                       B
        .byte   $44                             ; AD2B 44                       D
        sec                                     ; AD2C 38                       8
        lsr     a                               ; AD2D 4A                       J
        .byte   $3C                             ; AD2E 3C                       <
        asl     a:L0000,x                       ; AD2F 1E 00 00                 ...
        sty     $24                             ; AD32 84 24                    .$
        rol     $3C3E,x                         ; AD34 3E 3E 3C                 >><
        sec                                     ; AD37 38                       8
        bvs     LADAC                           ; AD38 70 72                    pr
        brk                                     ; AD3A 00                       .
        .byte   $34                             ; AD3B 34                       4
        php                                     ; AD3C 08                       .
        ora     (L0028,x)                       ; AD3D 01 28                    .(
        bit     $9100                           ; AD3F 2C 00 91                 ,..
        .byte   $92                             ; AD42 92                       .
        .byte   $02                             ; AD43 02                       .
        .byte   $93                             ; AD44 93                       .
        .byte   $93                             ; AD45 93                       .
        sta     $3E,x                           ; AD46 95 3E                    .>
        brk                                     ; AD48 00                       .
        lda     ($B2),y                         ; AD49 B1 B2                    ..
        .byte   $B2                             ; AD4B B2                       .
        .byte   $B3                             ; AD4C B3                       .
        .byte   $B3                             ; AD4D B3                       .
        lda     $1E,x                           ; AD4E B5 1E                    ..
        .byte   $02                             ; AD50 02                       .
        cpy     #$C2                            ; AD51 C0 C2                    ..
        .byte   $C3                             ; AD53 C3                       .
        cmp     $C7                             ; AD54 C5 C7                    ..
        cmp     L0000                           ; AD56 C5 00                    ..
        cmp     ($CA,x)                         ; AD58 C1 CA                    ..
        .byte   $C2                             ; AD5A C2                       .
        .byte   $02                             ; AD5B 02                       .
        cmp     $02                             ; AD5C C5 02                    ..
        cmp     L0000                           ; AD5E C5 00                    ..
        cpy     #$C0                            ; AD60 C0 C0                    ..
        .byte   $C2                             ; AD62 C2                       .
        .byte   $C3                             ; AD63 C3                       .
        cmp     $C7                             ; AD64 C5 C7                    ..
        brk                                     ; AD66 00                       .
        brk                                     ; AD67 00                       .
        dey                                     ; AD68 88                       .
        txa                                     ; AD69 8A                       .
        dey                                     ; AD6A 88                       .
        txa                                     ; AD6B 8A                       .
        brk                                     ; AD6C 00                       .
        lda     L0000,x                         ; AD6D B5 00                    ..
        sta     $CE                             ; AD6F 85 CE                    ..
        brk                                     ; AD71 00                       .
        tay                                     ; AD72 A8                       .
        tax                                     ; AD73 AA                       .
        .byte   $7C                             ; AD74 7C                       |
        ror     a:L0000,x                       ; AD75 7E 00 00                 ~..
        inc     LB800                           ; AD78 EE 00 B8                 ...
        tsx                                     ; AD7B BA                       .
        .byte   $F2                             ; AD7C F2                       .
        .byte   $F3                             ; AD7D F3                       .
        adc     $CB86,y                         ; AD7E 79 86 CB                 y..
        cmp     LAEAC                           ; AD81 CD AC AE                 ...
        beq     LAD9C                           ; AD84 F0 16                    ..
        brk                                     ; AD86 00                       .
        stx     $EB,y                           ; AD87 96 EB                    ..
        sbc     $7E7C                           ; AD89 ED 7C 7E                 .|~
        brk                                     ; AD8C 00                       .
        brk                                     ; AD8D 00                       .
        brk                                     ; AD8E 00                       .
        stx     $80,y                           ; AD8F 96 80                    ..
        .byte   $82                             ; AD91 82                       .
        .byte   $7C                             ; AD92 7C                       |
        ror     $2A5E,x                         ; AD93 7E 5E 2A                 ~^*
        brk                                     ; AD96 00                       .
        brk                                     ; AD97 00                       .
        .byte   $83                             ; AD98 83                       .
        sta     (L0020,x)                       ; AD99 81 20                    . 
        .byte   $22                             ; AD9B 22                       "
LAD9C:  .byte   $04                             ; AD9C 04                       .
        brk                                     ; AD9D 00                       .
        brk                                     ; AD9E 00                       .
        brk                                     ; AD9F 00                       .
        lsr     $67                             ; ADA0 46 67                    Fg
        sec                                     ; ADA2 38                       8
        dec     $2F,x                           ; ADA3 D6 2F                    ./
        brk                                     ; ADA5 00                       .
        brk                                     ; ADA6 00                       .
        brk                                     ; ADA7 00                       .
        brk                                     ; ADA8 00                       .
        brk                                     ; ADA9 00                       .
        brk                                     ; ADAA 00                       .
        brk                                     ; ADAB 00                       .
LADAC:  brk                                     ; ADAC 00                       .
        brk                                     ; ADAD 00                       .
        brk                                     ; ADAE 00                       .
        brk                                     ; ADAF 00                       .
        brk                                     ; ADB0 00                       .
        brk                                     ; ADB1 00                       .
        brk                                     ; ADB2 00                       .
        brk                                     ; ADB3 00                       .
        brk                                     ; ADB4 00                       .
        brk                                     ; ADB5 00                       .
        brk                                     ; ADB6 00                       .
        brk                                     ; ADB7 00                       .
        brk                                     ; ADB8 00                       .
        brk                                     ; ADB9 00                       .
        brk                                     ; ADBA 00                       .
        brk                                     ; ADBB 00                       .
        brk                                     ; ADBC 00                       .
        brk                                     ; ADBD 00                       .
        brk                                     ; ADBE 00                       .
        brk                                     ; ADBF 00                       .
        brk                                     ; ADC0 00                       .
        brk                                     ; ADC1 00                       .
        brk                                     ; ADC2 00                       .
        brk                                     ; ADC3 00                       .
        brk                                     ; ADC4 00                       .
        brk                                     ; ADC5 00                       .
        brk                                     ; ADC6 00                       .
        brk                                     ; ADC7 00                       .
        brk                                     ; ADC8 00                       .
        brk                                     ; ADC9 00                       .
        brk                                     ; ADCA 00                       .
        brk                                     ; ADCB 00                       .
        brk                                     ; ADCC 00                       .
        brk                                     ; ADCD 00                       .
        brk                                     ; ADCE 00                       .
        brk                                     ; ADCF 00                       .
        brk                                     ; ADD0 00                       .
        brk                                     ; ADD1 00                       .
        brk                                     ; ADD2 00                       .
        brk                                     ; ADD3 00                       .
        brk                                     ; ADD4 00                       .
        brk                                     ; ADD5 00                       .
        brk                                     ; ADD6 00                       .
        brk                                     ; ADD7 00                       .
        brk                                     ; ADD8 00                       .
        brk                                     ; ADD9 00                       .
        brk                                     ; ADDA 00                       .
        brk                                     ; ADDB 00                       .
        brk                                     ; ADDC 00                       .
        brk                                     ; ADDD 00                       .
        brk                                     ; ADDE 00                       .
        brk                                     ; ADDF 00                       .
        brk                                     ; ADE0 00                       .
        brk                                     ; ADE1 00                       .
        brk                                     ; ADE2 00                       .
        brk                                     ; ADE3 00                       .
        brk                                     ; ADE4 00                       .
        brk                                     ; ADE5 00                       .
        brk                                     ; ADE6 00                       .
        brk                                     ; ADE7 00                       .
        brk                                     ; ADE8 00                       .
        brk                                     ; ADE9 00                       .
        brk                                     ; ADEA 00                       .
        brk                                     ; ADEB 00                       .
        brk                                     ; ADEC 00                       .
        brk                                     ; ADED 00                       .
        brk                                     ; ADEE 00                       .
        brk                                     ; ADEF 00                       .
        brk                                     ; ADF0 00                       .
        brk                                     ; ADF1 00                       .
        brk                                     ; ADF2 00                       .
        brk                                     ; ADF3 00                       .
        brk                                     ; ADF4 00                       .
        brk                                     ; ADF5 00                       .
        brk                                     ; ADF6 00                       .
        brk                                     ; ADF7 00                       .
        brk                                     ; ADF8 00                       .
        brk                                     ; ADF9 00                       .
        brk                                     ; ADFA 00                       .
        brk                                     ; ADFB 00                       .
        brk                                     ; ADFC 00                       .
        brk                                     ; ADFD 00                       .
        brk                                     ; ADFE 00                       .
        brk                                     ; ADFF 00                       .
        brk                                     ; AE00 00                       .
        .byte   $34                             ; AE01 34                       4
        .byte   $03                             ; AE02 03                       .
        ora     $07                             ; AE03 05 07                    ..
        adc     $76                             ; AE05 65 76                    ev
        sta     $1107                           ; AE07 8D 07 11                 ...
        .byte   $27                             ; AE0A 27                       '
        ror     L0000,x                         ; AE0B 76 00                    v.
        brk                                     ; AE0D 00                       .
        sbc     #$8F                            ; AE0E E9 8F                    ..
        brk                                     ; AE10 00                       .
        brk                                     ; AE11 00                       .
        eor     $6A5F,x                         ; AE12 5D 5F 6A                 ]_j
        bpl     LAE90                           ; AE15 10 79                    .y
        bpl     LAE29                           ; AE17 10 10                    ..
        ora     ($01,x)                         ; AE19 01 01                    ..
        ora     ($09,x)                         ; AE1B 01 09                    ..
        .byte   $0B                             ; AE1D 0B                       .
        .byte   $0C                             ; AE1E 0C                       .
        ora     #$21                            ; AE1F 09 21                    .!
        .byte   $23                             ; AE21 23                       #
        .byte   $47                             ; AE22 47                       G
        bit     $29                             ; AE23 24 29                    $)
        .byte   $2B                             ; AE25 2B                       +
        and     $2301                           ; AE26 2D 01 23                 -.#
LAE29:  eor     ($43,x)                         ; AE29 41 43                    AC
        eor     $39                             ; AE2B 45 39                    E9
        .byte   $4B                             ; AE2D 4B                       K
        and     a:$1F,x                         ; AE2E 3D 1F 00                 =..
        brk                                     ; AE31 00                       .
        brk                                     ; AE32 00                       .
        and     $3E                             ; AE33 25 3E                    %>
        rol     $393D,x                         ; AE35 3E 3D 39                 >=9
        adc     ($73),y                         ; AE38 71 73                    qs
        brk                                     ; AE3A 00                       .
        and     $0C,x                           ; AE3B 35 0C                    5.
        ora     ($29,x)                         ; AE3D 01 29                    .)
        and     $9290                           ; AE3F 2D 90 92                 -..
        .byte   $92                             ; AE42 92                       .
        .byte   $02                             ; AE43 02                       .
        .byte   $93                             ; AE44 93                       .
        sty     L0000,x                         ; AE45 94 00                    ..
        rol     LB2B0,x                         ; AE47 3E B0 B2                 >..
        .byte   $B2                             ; AE4A B2                       .
        .byte   $B2                             ; AE4B B2                       .
        .byte   $B3                             ; AE4C B3                       .
        ldy     L0000,x                         ; AE4D B4 00                    ..
        .byte   $1F                             ; AE4F 1F                       .
        .byte   $02                             ; AE50 02                       .
        cmp     ($C2,x)                         ; AE51 C1 C2                    ..
        cpy     $C6                             ; AE53 C4 C6                    ..
        iny                                     ; AE55 C8                       .
        dec     L0000                           ; AE56 C6 00                    ..
        cpy     #$C1                            ; AE58 C0 C1                    ..
        cld                                     ; AE5A D8                       .
        .byte   $02                             ; AE5B 02                       .
        cmp     $D902,y                         ; AE5C D9 02 D9                 ...
        sta     $C0                             ; AE5F 85 C0                    ..
        cmp     ($C2,x)                         ; AE61 C1 C2                    ..
        cpy     $C6                             ; AE63 C4 C6                    ..
        iny                                     ; AE65 C8                       .
        inx                                     ; AE66 E8                       .
        brk                                     ; AE67 00                       .
        .byte   $89                             ; AE68 89                       .
        .byte   $8B                             ; AE69 8B                       .
        .byte   $89                             ; AE6A 89                       .
        .byte   $8B                             ; AE6B 8B                       .
        brk                                     ; AE6C 00                       .
        ldx     $E9,y                           ; AE6D B6 E9                    ..
        sta     $CF                             ; AE6F 85 CF                    ..
        brk                                     ; AE71 00                       .
        lda     #$AB                            ; AE72 A9 AB                    ..
        adc     a:$7F,x                         ; AE74 7D 7F 00                 }..
        brk                                     ; AE77 00                       .
        .byte   $EF                             ; AE78 EF                       .
        brk                                     ; AE79 00                       .
        lda     $F2BB,y                         ; AE7A B9 BB F2                 ...
        .byte   $F3                             ; AE7D F3                       .
        adc     $CC00,y                         ; AE7E 79 00 CC                 y..
        rol     LAFAD,x                         ; AE81 3E AD AF                 >..
        sbc     ($17),y                         ; AE84 F1 17                    ..
        brk                                     ; AE86 00                       .
        .byte   $97                             ; AE87 97                       .
        cpx     $7D01                           ; AE88 EC 01 7D                 ..}
        .byte   $7F                             ; AE8B 7F                       .
        brk                                     ; AE8C 00                       .
        brk                                     ; AE8D 00                       .
        brk                                     ; AE8E 00                       .
        .byte   $97                             ; AE8F 97                       .
LAE90:  sta     ($83,x)                         ; AE90 81 83                    ..
        adc     $5F7F,x                         ; AE92 7D 7F 5F                 }._
        .byte   $2B                             ; AE95 2B                       +
        brk                                     ; AE96 00                       .
        brk                                     ; AE97 00                       .
        sta     ($80,x)                         ; AE98 81 80                    ..
        and     ($23,x)                         ; AE9A 21 23                    !#
        ora     L0000                           ; AE9C 05 00                    ..
        brk                                     ; AE9E 00                       .
        brk                                     ; AE9F 00                       .
        .byte   $47                             ; AEA0 47                       G
        .byte   $67                             ; AEA1 67                       g
        ora     $3DD7                           ; AEA2 0D D7 3D                 ..=
        brk                                     ; AEA5 00                       .
        brk                                     ; AEA6 00                       .
        brk                                     ; AEA7 00                       .
        brk                                     ; AEA8 00                       .
        brk                                     ; AEA9 00                       .
        brk                                     ; AEAA 00                       .
        brk                                     ; AEAB 00                       .
LAEAC:  brk                                     ; AEAC 00                       .
        brk                                     ; AEAD 00                       .
        brk                                     ; AEAE 00                       .
        brk                                     ; AEAF 00                       .
        brk                                     ; AEB0 00                       .
        brk                                     ; AEB1 00                       .
        brk                                     ; AEB2 00                       .
        brk                                     ; AEB3 00                       .
        brk                                     ; AEB4 00                       .
        brk                                     ; AEB5 00                       .
        brk                                     ; AEB6 00                       .
        brk                                     ; AEB7 00                       .
        brk                                     ; AEB8 00                       .
        brk                                     ; AEB9 00                       .
        brk                                     ; AEBA 00                       .
        brk                                     ; AEBB 00                       .
        brk                                     ; AEBC 00                       .
        brk                                     ; AEBD 00                       .
        brk                                     ; AEBE 00                       .
        brk                                     ; AEBF 00                       .
        brk                                     ; AEC0 00                       .
        brk                                     ; AEC1 00                       .
        brk                                     ; AEC2 00                       .
        brk                                     ; AEC3 00                       .
        brk                                     ; AEC4 00                       .
        brk                                     ; AEC5 00                       .
        brk                                     ; AEC6 00                       .
        brk                                     ; AEC7 00                       .
        brk                                     ; AEC8 00                       .
        brk                                     ; AEC9 00                       .
        brk                                     ; AECA 00                       .
        brk                                     ; AECB 00                       .
        brk                                     ; AECC 00                       .
        brk                                     ; AECD 00                       .
        brk                                     ; AECE 00                       .
        brk                                     ; AECF 00                       .
        brk                                     ; AED0 00                       .
        brk                                     ; AED1 00                       .
        brk                                     ; AED2 00                       .
        brk                                     ; AED3 00                       .
        brk                                     ; AED4 00                       .
        brk                                     ; AED5 00                       .
        brk                                     ; AED6 00                       .
        brk                                     ; AED7 00                       .
        brk                                     ; AED8 00                       .
        brk                                     ; AED9 00                       .
        brk                                     ; AEDA 00                       .
        brk                                     ; AEDB 00                       .
        brk                                     ; AEDC 00                       .
        brk                                     ; AEDD 00                       .
        brk                                     ; AEDE 00                       .
        brk                                     ; AEDF 00                       .
        brk                                     ; AEE0 00                       .
        brk                                     ; AEE1 00                       .
        brk                                     ; AEE2 00                       .
        brk                                     ; AEE3 00                       .
        brk                                     ; AEE4 00                       .
        brk                                     ; AEE5 00                       .
        brk                                     ; AEE6 00                       .
        brk                                     ; AEE7 00                       .
        brk                                     ; AEE8 00                       .
        brk                                     ; AEE9 00                       .
        brk                                     ; AEEA 00                       .
        brk                                     ; AEEB 00                       .
        brk                                     ; AEEC 00                       .
        brk                                     ; AEED 00                       .
        brk                                     ; AEEE 00                       .
        brk                                     ; AEEF 00                       .
        brk                                     ; AEF0 00                       .
        brk                                     ; AEF1 00                       .
        brk                                     ; AEF2 00                       .
        brk                                     ; AEF3 00                       .
        brk                                     ; AEF4 00                       .
        brk                                     ; AEF5 00                       .
        brk                                     ; AEF6 00                       .
        brk                                     ; AEF7 00                       .
        brk                                     ; AEF8 00                       .
        brk                                     ; AEF9 00                       .
        brk                                     ; AEFA 00                       .
        brk                                     ; AEFB 00                       .
        brk                                     ; AEFC 00                       .
        brk                                     ; AEFD 00                       .
        brk                                     ; AEFE 00                       .
        brk                                     ; AEFF 00                       .
        brk                                     ; AF00 00                       .
        .byte   $34                             ; AF01 34                       4
        .byte   $12                             ; AF02 12                       .
        .byte   $14                             ; AF03 14                       .
        asl     $74                             ; AF04 06 74                    .t
        brk                                     ; AF06 00                       .
        .byte   $9C                             ; AF07 9C                       .
        asl     $10                             ; AF08 06 10                    ..
        rol     $76,x                           ; AF0A 36 76                    6v
        .byte   $F4                             ; AF0C F4                       .
        brk                                     ; AF0D 00                       .
        sed                                     ; AF0E F8                       .
        .byte   $9E                             ; AF0F 9E                       .
        inc     $F5,x                           ; AF10 F6 F5                    ..
        ora     ($01,x)                         ; AF12 01 01                    ..
        .byte   $7A                             ; AF14 7A                       z
        pla                                     ; AF15 68                       h
        bpl     LAF80                           ; AF16 10 68                    .h
        bpl     LAF1B                           ; AF18 10 01                    ..
        .byte   $6C                             ; AF1A 6C                       l
LAF1B:  ror     $1A18                           ; AF1B 6E 18 1A                 n..
        .byte   $1B                             ; AF1E 1B                       .
        .byte   $1B                             ; AF1F 1B                       .
        bmi     LAF54                           ; AF20 30 32                    02
        lsr     $34,x                           ; AF22 56 34                    V4
        sec                                     ; AF24 38                       8
        .byte   $3A                             ; AF25 3A                       :
        .byte   $3C                             ; AF26 3C                       <
        asl     $5030                           ; AF27 0E 30 50                 .0P
        .byte   $52                             ; AF2A 52                       R
        .byte   $54                             ; AF2B 54                       T
        pha                                     ; AF2C 48                       H
        .byte   $5A                             ; AF2D 5A                       Z
        jmp     L6001                           ; AF2E 4C 01 60                 L.`

; ----------------------------------------------------------------------------
        .byte   $62                             ; AF31 62                       b
        brk                                     ; AF32 00                       .
        .byte   $34                             ; AF33 34                       4
        .byte   $4F                             ; AF34 4F                       O
        ora     ($3C,x)                         ; AF35 01 3C                    .<
        sec                                     ; AF37 38                       8
        .byte   $80                             ; AF38 80                       .
        .byte   $82                             ; AF39 82                       .
        brk                                     ; AF3A 00                       .
        .byte   $34                             ; AF3B 34                       4
        ldx     $484F                           ; AF3C AE 4F 48                 .OH
        .byte   $4C,$00,$A1                     ; AF3F 4C 00 A1                 L..

; ----------------------------------------------------------------------------
        ldx     #$02                            ; AF42 A2 02                    ..
        .byte   $A3                             ; AF44 A3                       .
LAF45:  .byte   $A3                             ; AF45 A3                       .
        lda     $0E                             ; AF46 A5 0E                    ..
        brk                                     ; AF48 00                       .
        cpy     #$C2                            ; AF49 C0 C2                    ..
        .byte   $C3                             ; AF4B C3                       .
        cmp     $C7                             ; AF4C C5 C7                    ..
        brk                                     ; AF4E 00                       .
        .byte   $4F                             ; AF4F 4F                       O
        .byte   $02                             ; AF50 02                       .
        cpy     #$C2                            ; AF51 C0 C2                    ..
        .byte   $C3                             ; AF53 C3                       .
LAF54:  cmp     $C7                             ; AF54 C5 C7                    ..
        cmp     L0000                           ; AF56 C5 00                    ..
        cmp     ($DA,x)                         ; AF58 C1 DA                    ..
        cld                                     ; AF5A D8                       .
        .byte   $02                             ; AF5B 02                       .
        .byte   $62                             ; AF5C 62                       b
        .byte   $02                             ; AF5D 02                       .
        cmp     $85                             ; AF5E C5 85                    ..
        rts                                     ; AF60 60                       `

; ----------------------------------------------------------------------------
        bne     LAFC5                           ; AF61 D0 62                    .b
        .byte   $D2                             ; AF63 D2                       .
        .byte   $62                             ; AF64 62                       b
        .byte   $D4                             ; AF65 D4                       .
        .byte   $F7                             ; AF66 F7                       .
        sbc     $8A88,y                         ; AF67 F9 88 8A                 ...
        tya                                     ; AF6A 98                       .
        txs                                     ; AF6B 9A                       .
        brk                                     ; AF6C 00                       .
        .byte   $80                             ; AF6D 80                       .
        brk                                     ; AF6E 00                       .
        sta     $DE                             ; AF6F 85 DE                    ..
        brk                                     ; AF71 00                       .
        tay                                     ; AF72 A8                       .
        tax                                     ; AF73 AA                       .
        .byte   $7C                             ; AF74 7C                       |
        ror     a:L0000,x                       ; AF75 7E 00 00                 ~..
        inc     $8800,x                         ; AF78 FE 00 88                 ...
        txa                                     ; AF7B 8A                       .
        brk                                     ; AF7C 00                       .
        brk                                     ; AF7D 00                       .
        bpl     LAF45                           ; AF7E 10 C5                    ..
LAF80:  .byte   $DB                             ; AF80 DB                       .
        cmp     $7EBC,x                         ; AF81 DD BC 7E                 ..~
        beq     LAF9C                           ; AF84 F0 16                    ..
        brk                                     ; AF86 00                       .
        stx     $FB,y                           ; AF87 96 FB                    ..
        sbc     $7E7C,x                         ; AF89 FD 7C 7E                 .|~
        brk                                     ; AF8C 00                       .
        brk                                     ; AF8D 00                       .
        brk                                     ; AF8E 00                       .
        ldx     $84                             ; AF8F A6 84                    ..
        brk                                     ; AF91 00                       .
        ldy     $4EBE,x                         ; AF92 BC BE 4E                 ..N
        rol     a                               ; AF95 2A                       *
        brk                                     ; AF96 00                       .
        brk                                     ; AF97 00                       .
        brk                                     ; AF98 00                       .
        brk                                     ; AF99 00                       .
        bmi     LAFCE                           ; AF9A 30 32                    02
LAF9C:  .byte   $14                             ; AF9C 14                       .
        brk                                     ; AF9D 00                       .
        brk                                     ; AF9E 00                       .
        brk                                     ; AF9F 00                       .
        lsr     $77,x                           ; AFA0 56 77                    Vw
        sec                                     ; AFA2 38                       8
        inc     $3F                             ; AFA3 E6 3F                    .?
        brk                                     ; AFA5 00                       .
        brk                                     ; AFA6 00                       .
        brk                                     ; AFA7 00                       .
        brk                                     ; AFA8 00                       .
        brk                                     ; AFA9 00                       .
        brk                                     ; AFAA 00                       .
        brk                                     ; AFAB 00                       .
        brk                                     ; AFAC 00                       .
LAFAD:  brk                                     ; AFAD 00                       .
        brk                                     ; AFAE 00                       .
        brk                                     ; AFAF 00                       .
        brk                                     ; AFB0 00                       .
        brk                                     ; AFB1 00                       .
        brk                                     ; AFB2 00                       .
        brk                                     ; AFB3 00                       .
        brk                                     ; AFB4 00                       .
        brk                                     ; AFB5 00                       .
        brk                                     ; AFB6 00                       .
        brk                                     ; AFB7 00                       .
        brk                                     ; AFB8 00                       .
        brk                                     ; AFB9 00                       .
        brk                                     ; AFBA 00                       .
        brk                                     ; AFBB 00                       .
        brk                                     ; AFBC 00                       .
        brk                                     ; AFBD 00                       .
        brk                                     ; AFBE 00                       .
        brk                                     ; AFBF 00                       .
        brk                                     ; AFC0 00                       .
        brk                                     ; AFC1 00                       .
        brk                                     ; AFC2 00                       .
        brk                                     ; AFC3 00                       .
        brk                                     ; AFC4 00                       .
LAFC5:  brk                                     ; AFC5 00                       .
        brk                                     ; AFC6 00                       .
        brk                                     ; AFC7 00                       .
        brk                                     ; AFC8 00                       .
        brk                                     ; AFC9 00                       .
        brk                                     ; AFCA 00                       .
        brk                                     ; AFCB 00                       .
        brk                                     ; AFCC 00                       .
        brk                                     ; AFCD 00                       .
LAFCE:  brk                                     ; AFCE 00                       .
        brk                                     ; AFCF 00                       .
        brk                                     ; AFD0 00                       .
        brk                                     ; AFD1 00                       .
        brk                                     ; AFD2 00                       .
        brk                                     ; AFD3 00                       .
        brk                                     ; AFD4 00                       .
        brk                                     ; AFD5 00                       .
        brk                                     ; AFD6 00                       .
        brk                                     ; AFD7 00                       .
        brk                                     ; AFD8 00                       .
        brk                                     ; AFD9 00                       .
        brk                                     ; AFDA 00                       .
        brk                                     ; AFDB 00                       .
        brk                                     ; AFDC 00                       .
        brk                                     ; AFDD 00                       .
        brk                                     ; AFDE 00                       .
        brk                                     ; AFDF 00                       .
        brk                                     ; AFE0 00                       .
        brk                                     ; AFE1 00                       .
        brk                                     ; AFE2 00                       .
        brk                                     ; AFE3 00                       .
        brk                                     ; AFE4 00                       .
        brk                                     ; AFE5 00                       .
        brk                                     ; AFE6 00                       .
        brk                                     ; AFE7 00                       .
        brk                                     ; AFE8 00                       .
        brk                                     ; AFE9 00                       .
        brk                                     ; AFEA 00                       .
        brk                                     ; AFEB 00                       .
        brk                                     ; AFEC 00                       .
        brk                                     ; AFED 00                       .
        brk                                     ; AFEE 00                       .
        brk                                     ; AFEF 00                       .
        brk                                     ; AFF0 00                       .
        brk                                     ; AFF1 00                       .
        brk                                     ; AFF2 00                       .
        brk                                     ; AFF3 00                       .
        brk                                     ; AFF4 00                       .
        brk                                     ; AFF5 00                       .
        brk                                     ; AFF6 00                       .
        brk                                     ; AFF7 00                       .
        brk                                     ; AFF8 00                       .
        brk                                     ; AFF9 00                       .
        brk                                     ; AFFA 00                       .
        brk                                     ; AFFB 00                       .
        brk                                     ; AFFC 00                       .
        brk                                     ; AFFD 00                       .
        brk                                     ; AFFE 00                       .
        brk                                     ; AFFF 00                       .
        brk                                     ; B000 00                       .
        .byte   $34                             ; B001 34                       4
        .byte   $13                             ; B002 13                       .
        ora     $07,x                           ; B003 15 07                    ..
        adc     L0000,x                         ; B005 75 00                    u.
        sta     $1007,x                         ; B007 9D 07 10                 ...
        .byte   $37                             ; B00A 37                       7
        ror     $F4,x                           ; B00B 76 F4                    v.
        ror     $F9                             ; B00D 66 F9                    f.
        .byte   $9F                             ; B00F 9F                       .
        inc     $F6,x                           ; B010 F6 F6                    ..
        ora     ($01,x)                         ; B012 01 01                    ..
        .byte   $7A                             ; B014 7A                       z
        bpl     LB027                           ; B015 10 10                    ..
        bpl     LB029                           ; B017 10 10                    ..
        ora     ($6D,x)                         ; B019 01 6D                    .m
        .byte   $6F                             ; B01B 6F                       o
        ora     $1C1B,y                         ; B01C 19 1B 1C                 ...
        ora     $3331,y                         ; B01F 19 31 33                 .13
        .byte   $57                             ; B022 57                       W
        .byte   $34                             ; B023 34                       4
        .byte   $39                             ; B024 39                       9
        .byte   $3B                             ; B025 3B                       ;
LB026:  .byte   $3D                             ; B026 3D                       =
LB027:  .byte   $0F                             ; B027 0F                       .
        .byte   $33                             ; B028 33                       3
LB029:  eor     ($53),y                         ; B029 51 53                    QS
        eor     $49,x                           ; B02B 55 49                    UI
        .byte   $5B                             ; B02D 5B                       [
        eor     $6101                           ; B02E 4D 01 61                 M.a
        .byte   $63                             ; B031 63                       c
        brk                                     ; B032 00                       .
        and     $4F,x                           ; B033 35 4F                    5O
        ora     ($3D,x)                         ; B035 01 3D                    .=
        and     $8381,y                         ; B037 39 81 83                 9..
        brk                                     ; B03A 00                       .
        and     $AF,x                           ; B03B 35 AF                    5.
        .byte   $4F                             ; B03D 4F                       O
        eor     #$4D                            ; B03E 49 4D                    IM
        ldy     #$A2                            ; B040 A0 A2                    ..
        ldx     #$02                            ; B042 A2 02                    ..
        .byte   $A3                             ; B044 A3                       .
        ldy     L0000                           ; B045 A4 00                    ..
        .byte   $0F                             ; B047 0F                       .
        brk                                     ; B048 00                       .
        cmp     ($C2,x)                         ; B049 C1 C2                    ..
        cpy     $C6                             ; B04B C4 C6                    ..
        iny                                     ; B04D C8                       .
        brk                                     ; B04E 00                       .
        .byte   $4F                             ; B04F 4F                       O
        .byte   $02                             ; B050 02                       .
        cmp     ($C2,x)                         ; B051 C1 C2                    ..
        cpy     $C6                             ; B053 C4 C6                    ..
        iny                                     ; B055 C8                       .
        cmp     #$00                            ; B056 C9 00                    ..
        cpy     #$C1                            ; B058 C0 C1                    ..
        .byte   $C2                             ; B05A C2                       .
        .byte   $02                             ; B05B 02                       .
        .byte   $63                             ; B05C 63                       c
        .byte   $02                             ; B05D 02                       .
        cmp     $6187,y                         ; B05E D9 87 61                 ..a
        cmp     ($63),y                         ; B061 D1 63                    .c
        .byte   $D3                             ; B063 D3                       .
        .byte   $63                             ; B064 63                       c
        cmp     $F8,x                           ; B065 D5 F8                    ..
        .byte   $FA                             ; B067 FA                       .
        .byte   $89                             ; B068 89                       .
        .byte   $8B                             ; B069 8B                       .
        sta     $9B,y                           ; B06A 99 9B 00                 ...
        sta     ($EA,x)                         ; B06D 81 EA                    ..
        sta     $DF                             ; B06F 85 DF                    ..
        brk                                     ; B071 00                       .
        lda     #$AB                            ; B072 A9 AB                    ..
        adc     a:$7F,x                         ; B074 7D 7F 00                 }..
        brk                                     ; B077 00                       .
        .byte   $FF                             ; B078 FF                       .
        brk                                     ; B079 00                       .
        .byte   $89                             ; B07A 89                       .
        .byte   $8B                             ; B07B 8B                       .
        brk                                     ; B07C 00                       .
        brk                                     ; B07D 00                       .
        bpl     LB026                           ; B07E 10 A6                    ..
        .byte   $DC                             ; B080 DC                       .
        ora     ($BD,x)                         ; B081 01 BD                    ..
        .byte   $7F                             ; B083 7F                       .
        sbc     ($17),y                         ; B084 F1 17                    ..
        brk                                     ; B086 00                       .
        .byte   $97                             ; B087 97                       .
        .byte   $FC                             ; B088 FC                       .
        lsr     $7F7D                           ; B089 4E 7D 7F                 N}.
        brk                                     ; B08C 00                       .
        brk                                     ; B08D 00                       .
        brk                                     ; B08E 00                       .
        .byte   $A7                             ; B08F A7                       .
        brk                                     ; B090 00                       .
        brk                                     ; B091 00                       .
        lda     $4FBF,x                         ; B092 BD BF 4F                 ..O
        .byte   $2B                             ; B095 2B                       +
        brk                                     ; B096 00                       .
        brk                                     ; B097 00                       .
        brk                                     ; B098 00                       .
        sty     $31                             ; B099 84 31                    .1
        .byte   $33                             ; B09B 33                       3
        ora     L0000,x                         ; B09C 15 00                    ..
        brk                                     ; B09E 00                       .
        brk                                     ; B09F 00                       .
        .byte   $57                             ; B0A0 57                       W
        .byte   $77                             ; B0A1 77                       w
        ora     $3DE7,x                         ; B0A2 1D E7 3D                 ..=
        brk                                     ; B0A5 00                       .
        brk                                     ; B0A6 00                       .
        brk                                     ; B0A7 00                       .
        brk                                     ; B0A8 00                       .
        brk                                     ; B0A9 00                       .
        brk                                     ; B0AA 00                       .
        brk                                     ; B0AB 00                       .
        brk                                     ; B0AC 00                       .
        brk                                     ; B0AD 00                       .
        brk                                     ; B0AE 00                       .
        brk                                     ; B0AF 00                       .
LB0B0:  brk                                     ; B0B0 00                       .
        brk                                     ; B0B1 00                       .
        brk                                     ; B0B2 00                       .
        brk                                     ; B0B3 00                       .
        brk                                     ; B0B4 00                       .
        brk                                     ; B0B5 00                       .
        brk                                     ; B0B6 00                       .
        brk                                     ; B0B7 00                       .
        brk                                     ; B0B8 00                       .
        brk                                     ; B0B9 00                       .
        brk                                     ; B0BA 00                       .
        brk                                     ; B0BB 00                       .
        brk                                     ; B0BC 00                       .
        brk                                     ; B0BD 00                       .
        brk                                     ; B0BE 00                       .
        brk                                     ; B0BF 00                       .
        brk                                     ; B0C0 00                       .
        brk                                     ; B0C1 00                       .
        brk                                     ; B0C2 00                       .
        brk                                     ; B0C3 00                       .
        brk                                     ; B0C4 00                       .
        brk                                     ; B0C5 00                       .
        brk                                     ; B0C6 00                       .
        brk                                     ; B0C7 00                       .
        brk                                     ; B0C8 00                       .
        brk                                     ; B0C9 00                       .
        brk                                     ; B0CA 00                       .
        brk                                     ; B0CB 00                       .
        brk                                     ; B0CC 00                       .
        brk                                     ; B0CD 00                       .
        brk                                     ; B0CE 00                       .
        brk                                     ; B0CF 00                       .
        brk                                     ; B0D0 00                       .
        brk                                     ; B0D1 00                       .
        brk                                     ; B0D2 00                       .
        brk                                     ; B0D3 00                       .
        brk                                     ; B0D4 00                       .
        brk                                     ; B0D5 00                       .
        brk                                     ; B0D6 00                       .
        brk                                     ; B0D7 00                       .
        brk                                     ; B0D8 00                       .
        brk                                     ; B0D9 00                       .
        brk                                     ; B0DA 00                       .
        brk                                     ; B0DB 00                       .
        brk                                     ; B0DC 00                       .
        brk                                     ; B0DD 00                       .
        brk                                     ; B0DE 00                       .
        brk                                     ; B0DF 00                       .
        brk                                     ; B0E0 00                       .
        brk                                     ; B0E1 00                       .
        brk                                     ; B0E2 00                       .
        brk                                     ; B0E3 00                       .
        brk                                     ; B0E4 00                       .
        brk                                     ; B0E5 00                       .
        brk                                     ; B0E6 00                       .
        brk                                     ; B0E7 00                       .
        brk                                     ; B0E8 00                       .
        brk                                     ; B0E9 00                       .
        brk                                     ; B0EA 00                       .
        brk                                     ; B0EB 00                       .
        brk                                     ; B0EC 00                       .
        brk                                     ; B0ED 00                       .
        brk                                     ; B0EE 00                       .
        brk                                     ; B0EF 00                       .
        brk                                     ; B0F0 00                       .
        brk                                     ; B0F1 00                       .
        brk                                     ; B0F2 00                       .
LB0F3:  brk                                     ; B0F3 00                       .
        brk                                     ; B0F4 00                       .
        brk                                     ; B0F5 00                       .
        brk                                     ; B0F6 00                       .
        brk                                     ; B0F7 00                       .
        brk                                     ; B0F8 00                       .
        brk                                     ; B0F9 00                       .
        brk                                     ; B0FA 00                       .
        brk                                     ; B0FB 00                       .
        brk                                     ; B0FC 00                       .
        brk                                     ; B0FD 00                       .
        brk                                     ; B0FE 00                       .
        brk                                     ; B0FF 00                       .
        brk                                     ; B100 00                       .
        bpl     LB0F3                           ; B101 10 F0                    ..
        bpl     LB125                           ; B103 10 20                    . 
        ora     ($01,x)                         ; B105 01 01                    ..
        beq     LB149                           ; B107 F0 40                    .@
        brk                                     ; B109 00                       .
        ora     (L0000,x)                       ; B10A 01 00                    ..
        .byte   $03                             ; B10C 03                       .
        ora     (L0000,x)                       ; B10D 01 00                    ..
        beq     LB114                           ; B10F F0 03                    ..
        .byte   $03                             ; B111 03                       .
        ora     ($11),y                         ; B112 11 11                    ..
LB114:  .byte   $03                             ; B114 03                       .
        .byte   $03                             ; B115 03                       .
        .byte   $03                             ; B116 03                       .
        .byte   $03                             ; B117 03                       .
        .byte   $03                             ; B118 03                       .
        ora     ($11),y                         ; B119 11 11                    ..
        ora     ($11),y                         ; B11B 11 11                    ..
        ora     ($11),y                         ; B11D 11 11                    ..
        ora     ($10),y                         ; B11F 11 10                    ..
        bpl     LB123                           ; B121 10 00                    ..
LB123:  bpl     LB136                           ; B123 10 11                    ..
LB125:  .byte   $12                             ; B125 12                       .
        ora     ($11),y                         ; B126 11 11                    ..
        bpl     LB13A                           ; B128 10 10                    ..
        bpl     LB13C                           ; B12A 10 10                    ..
        ora     ($12),y                         ; B12C 11 12                    ..
        ora     ($11),y                         ; B12E 11 11                    ..
        .byte   $03                             ; B130 03                       .
        .byte   $03                             ; B131 03                       .
        .byte   $03                             ; B132 03                       .
        bpl     LB146                           ; B133 10 11                    ..
        .byte   $11                             ; B135 11                       .
LB136:  ora     ($11),y                         ; B136 11 11                    ..
        .byte   $03                             ; B138 03                       .
        .byte   $03                             ; B139 03                       .
LB13A:  brk                                     ; B13A 00                       .
        .byte   $10                             ; B13B 10                       .
LB13C:  ora     ($11),y                         ; B13C 11 11                    ..
        ora     ($11),y                         ; B13E 11 11                    ..
        .byte   $03                             ; B140 03                       .
        .byte   $03                             ; B141 03                       .
        .byte   $03                             ; B142 03                       .
        brk                                     ; B143 00                       .
LB144:  .byte   $03                             ; B144 03                       .
        .byte   $03                             ; B145 03                       .
LB146:  .byte   $03                             ; B146 03                       .
        ora     ($03),y                         ; B147 11 03                    ..
LB149:  .byte   $03                             ; B149 03                       .
        .byte   $03                             ; B14A 03                       .
        .byte   $03                             ; B14B 03                       .
        .byte   $03                             ; B14C 03                       .
        .byte   $03                             ; B14D 03                       .
        .byte   $03                             ; B14E 03                       .
        ora     (L0000),y                       ; B14F 11 00                    ..
        .byte   $03                             ; B151 03                       .
        .byte   $03                             ; B152 03                       .
        .byte   $03                             ; B153 03                       .
        .byte   $03                             ; B154 03                       .
        .byte   $03                             ; B155 03                       .
        .byte   $03                             ; B156 03                       .
        brk                                     ; B157 00                       .
        brk                                     ; B158 00                       .
        .byte   $03                             ; B159 03                       .
        .byte   $03                             ; B15A 03                       .
        .byte   $03                             ; B15B 03                       .
        .byte   $03                             ; B15C 03                       .
        .byte   $03                             ; B15D 03                       .
        .byte   $03                             ; B15E 03                       .
        brk                                     ; B15F 00                       .
        brk                                     ; B160 00                       .
        .byte   $03                             ; B161 03                       .
        .byte   $03                             ; B162 03                       .
        .byte   $03                             ; B163 03                       .
        .byte   $03                             ; B164 03                       .
        .byte   $03                             ; B165 03                       .
        ora     ($01,x)                         ; B166 01 01                    ..
        ora     ($11),y                         ; B168 11 11                    ..
        ora     ($11),y                         ; B16A 11 11                    ..
        brk                                     ; B16C 00                       .
        brk                                     ; B16D 00                       .
        ora     (L0000,x)                       ; B16E 01 00                    ..
        bpl     LB172                           ; B170 10 00                    ..
LB172:  .byte   $12                             ; B172 12                       .
        .byte   $12                             ; B173 12                       .
        .byte   $12                             ; B174 12                       .
        .byte   $12                             ; B175 12                       .
        brk                                     ; B176 00                       .
        brk                                     ; B177 00                       .
        bpl     LB17A                           ; B178 10 00                    ..
LB17A:  ora     ($11),y                         ; B17A 11 11                    ..
        .byte   $03                             ; B17C 03                       .
        .byte   $03                             ; B17D 03                       .
        .byte   $03                             ; B17E 03                       .
        brk                                     ; B17F 00                       .
        ora     ($11),y                         ; B180 11 11                    ..
        .byte   $12                             ; B182 12                       .
        ora     ($01,x)                         ; B183 01 01                    ..
        ora     (L0000,x)                       ; B185 01 00                    ..
        ora     ($11,x)                         ; B187 01 11                    ..
        ora     ($01),y                         ; B189 11 01                    ..
        ora     (L0000,x)                       ; B18B 01 00                    ..
        brk                                     ; B18D 00                       .
        brk                                     ; B18E 00                       .
        ora     ($03,x)                         ; B18F 01 03                    ..
        .byte   $03                             ; B191 03                       .
        ora     ($01,x)                         ; B192 01 01                    ..
        ora     ($01),y                         ; B194 11 01                    ..
        brk                                     ; B196 00                       .
        brk                                     ; B197 00                       .
        .byte   $03                             ; B198 03                       .
        .byte   $03                             ; B199 03                       .
        .byte   $12                             ; B19A 12                       .
        .byte   $12                             ; B19B 12                       .
        .byte   $12                             ; B19C 12                       .
        brk                                     ; B19D 00                       .
        brk                                     ; B19E 00                       .
        brk                                     ; B19F 00                       .
        ora     ($11),y                         ; B1A0 11 11                    ..
        ora     ($11),y                         ; B1A2 11 11                    ..
        ora     (L0000),y                       ; B1A4 11 00                    ..
        brk                                     ; B1A6 00                       .
        brk                                     ; B1A7 00                       .
        brk                                     ; B1A8 00                       .
        brk                                     ; B1A9 00                       .
        brk                                     ; B1AA 00                       .
        brk                                     ; B1AB 00                       .
        brk                                     ; B1AC 00                       .
        brk                                     ; B1AD 00                       .
        brk                                     ; B1AE 00                       .
        brk                                     ; B1AF 00                       .
        brk                                     ; B1B0 00                       .
        brk                                     ; B1B1 00                       .
        brk                                     ; B1B2 00                       .
        brk                                     ; B1B3 00                       .
        brk                                     ; B1B4 00                       .
        brk                                     ; B1B5 00                       .
        brk                                     ; B1B6 00                       .
        brk                                     ; B1B7 00                       .
        brk                                     ; B1B8 00                       .
        brk                                     ; B1B9 00                       .
        brk                                     ; B1BA 00                       .
        brk                                     ; B1BB 00                       .
        brk                                     ; B1BC 00                       .
        brk                                     ; B1BD 00                       .
        brk                                     ; B1BE 00                       .
        brk                                     ; B1BF 00                       .
        brk                                     ; B1C0 00                       .
        brk                                     ; B1C1 00                       .
        brk                                     ; B1C2 00                       .
        brk                                     ; B1C3 00                       .
        brk                                     ; B1C4 00                       .
        brk                                     ; B1C5 00                       .
        brk                                     ; B1C6 00                       .
        brk                                     ; B1C7 00                       .
        brk                                     ; B1C8 00                       .
        brk                                     ; B1C9 00                       .
        brk                                     ; B1CA 00                       .
        brk                                     ; B1CB 00                       .
        brk                                     ; B1CC 00                       .
        brk                                     ; B1CD 00                       .
        brk                                     ; B1CE 00                       .
        brk                                     ; B1CF 00                       .
        brk                                     ; B1D0 00                       .
        brk                                     ; B1D1 00                       .
        brk                                     ; B1D2 00                       .
        brk                                     ; B1D3 00                       .
        brk                                     ; B1D4 00                       .
        brk                                     ; B1D5 00                       .
        brk                                     ; B1D6 00                       .
        brk                                     ; B1D7 00                       .
        brk                                     ; B1D8 00                       .
        brk                                     ; B1D9 00                       .
        brk                                     ; B1DA 00                       .
        brk                                     ; B1DB 00                       .
        brk                                     ; B1DC 00                       .
        brk                                     ; B1DD 00                       .
        brk                                     ; B1DE 00                       .
        brk                                     ; B1DF 00                       .
        brk                                     ; B1E0 00                       .
        brk                                     ; B1E1 00                       .
        brk                                     ; B1E2 00                       .
        brk                                     ; B1E3 00                       .
        brk                                     ; B1E4 00                       .
        brk                                     ; B1E5 00                       .
        brk                                     ; B1E6 00                       .
        brk                                     ; B1E7 00                       .
        brk                                     ; B1E8 00                       .
        brk                                     ; B1E9 00                       .
        brk                                     ; B1EA 00                       .
        brk                                     ; B1EB 00                       .
        brk                                     ; B1EC 00                       .
        brk                                     ; B1ED 00                       .
        brk                                     ; B1EE 00                       .
        brk                                     ; B1EF 00                       .
        brk                                     ; B1F0 00                       .
        brk                                     ; B1F1 00                       .
        brk                                     ; B1F2 00                       .
        brk                                     ; B1F3 00                       .
        brk                                     ; B1F4 00                       .
        brk                                     ; B1F5 00                       .
        brk                                     ; B1F6 00                       .
        brk                                     ; B1F7 00                       .
        brk                                     ; B1F8 00                       .
        brk                                     ; B1F9 00                       .
        brk                                     ; B1FA 00                       .
        brk                                     ; B1FB 00                       .
        brk                                     ; B1FC 00                       .
        brk                                     ; B1FD 00                       .
        brk                                     ; B1FE 00                       .
        brk                                     ; B1FF 00                       .
        brk                                     ; B200 00                       .
        brk                                     ; B201 00                       .
        brk                                     ; B202 00                       .
        brk                                     ; B203 00                       .
        ora     $06                             ; B204 05 06                    ..
        ora     a:L0000                         ; B206 0D 00 00                 ...
        ora     a:L0000                         ; B209 0D 00 00                 ...
        brk                                     ; B20C 00                       .
        brk                                     ; B20D 00                       .
        brk                                     ; B20E 00                       .
        asl     a                               ; B20F 0A                       .
        eor     $46                             ; B210 45 46                    EF
        eor     a:$4E                           ; B212 4D 4E 00                 MN.
        .byte   $87                             ; B215 87                       .
        brk                                     ; B216 00                       .
        .byte   $8F                             ; B217 8F                       .
        eor     L0000,x                         ; B218 55 00                    U.
        eor     L0000,x                         ; B21A 55 00                    U.
        brk                                     ; B21C 00                       .
        rti                                     ; B21D 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; B21E 00                       .
        pha                                     ; B21F 48                       H
        eor     ($42,x)                         ; B220 41 42                    AB
        eor     #$4A                            ; B222 49 4A                    IJ
        .byte   $42                             ; B224 42                       B
        .byte   $44                             ; B225 44                       D
        .byte   $4B                             ; B226 4B                       K
        jmp     L5A51                           ; B227 4C 51 5A                 LQZ

; ----------------------------------------------------------------------------
        eor     ($52),y                         ; B22A 51 52                    QR
        .byte   $53                             ; B22C 53                       S
        .byte   $54                             ; B22D 54                       T
        .byte   $53                             ; B22E 53                       S
        .byte   $54                             ; B22F 54                       T
        adc     $31                             ; B230 65 31                    e1
        sec                                     ; B232 38                       8
        and     $3130,y                         ; B233 39 30 31                 901
        sec                                     ; B236 38                       8
        and     $6261,y                         ; B237 39 61 62                 9ab
        sec                                     ; B23A 38                       8
        and     $6463,y                         ; B23B 39 63 64                 9cd
        sec                                     ; B23E 38                       8
        and     L2120,y                         ; B23F 39 20 21                 9 !
        .byte   $2B                             ; B242 2B                       +
        .byte   $23                             ; B243 23                       #
        jsr     L2921                           ; B244 20 21 29                  !)
        rol     a                               ; B247 2A                       *
        plp                                     ; B248 28                       (
        ora     (L0028,x)                       ; B249 01 28                    .(
        ora     (L0028,x)                       ; B24B 01 28                    .(
        brk                                     ; B24D 00                       .
        plp                                     ; B24E 28                       (
        brk                                     ; B24F 00                       .
        brk                                     ; B250 00                       .
        brk                                     ; B251 00                       .
        asl     L0000                           ; B252 06 00                    ..
        jsr     L2821                           ; B254 20 21 28                  !(
        jsr     L2120                           ; B257 20 20 21                   !
        and     (L0028,x)                       ; B25A 21 28                    !(
        .byte   $32                             ; B25C 32                       2
        brk                                     ; B25D 00                       .
        brk                                     ; B25E 00                       .
        brk                                     ; B25F 00                       .
        ldy     #$A0                            ; B260 A0 A0                    ..
        eor     ($5A),y                         ; B262 51 5A                    QZ
        ldy     #$A0                            ; B264 A0 A0                    ..
        eor     $0D,x                           ; B266 55 0D                    U.
        lda     ($A0,x)                         ; B268 A1 A0                    ..
        brk                                     ; B26A 00                       .
        brk                                     ; B26B 00                       .
        ldy     #$A1                            ; B26C A0 A1                    ..
        sec                                     ; B26E 38                       8
        and     LA0A1,y                         ; B26F 39 A1 A0                 9..
        sec                                     ; B272 38                       8
        and     $2428,y                         ; B273 39 28 24                 9($
        and     ($2C,x)                         ; B276 21 2C                    !,
        and     $47                             ; B278 25 47                    %G
        and     $474F                           ; B27A 2D 4F 47                 -OG
        rol     $4F                             ; B27D 26 4F                    &O
        .byte   $2E,$04,$A2                     ; B27F 2E 04 A2                 ...
        .byte   $04                             ; B282 04                       .
        .byte   $37                             ; B283 37                       7
        ldy     L0028                           ; B284 A4 28                    .(
        rol     L0020,x                         ; B286 36 20                    6 
        and     $26,x                           ; B288 35 26                    5&
        and     $0C2E,x                         ; B28A 3D 2E 0C                 =..
        ora     ($14),y                         ; B28D 11 14                    ..
        ora     $04,x                           ; B28F 15 04                    ..
        .byte   $37                             ; B291 37                       7
        .byte   $04                             ; B292 04                       .
        bit     $2836                           ; B293 2C 36 28                 ,6(
        rol     $1420                           ; B296 2E 20 14                 . .
        ora     $14,x                           ; B299 15 14                    ..
        asl     $04,x                           ; B29B 16 04                    ..
        ora     ($04),y                         ; B29D 11 04                    ..
        ora     $0C,x                           ; B29F 15 0C                    ..
        plp                                     ; B2A1 28                       (
        .byte   $14                             ; B2A2 14                       .
        jsr     L1714                           ; B2A3 20 14 17                  ..
        .byte   $14                             ; B2A6 14                       .
        asl     $14,x                           ; B2A7 16 14                    ..
        plp                                     ; B2A9 28                       (
        .byte   $14                             ; B2AA 14                       .
        jsr     L0000                           ; B2AB 20 00 00                  ..
        plp                                     ; B2AE 28                       (
        .byte   $20                             ; B2AF 20                        
LB2B0:  .byte   $14                             ; B2B0 14                       .
        .byte   $17                             ; B2B1 17                       .
        and     (L0028,x)                       ; B2B2 21 28                    !(
        .byte   $14                             ; B2B4 14                       .
        .byte   $17                             ; B2B5 17                       .
        .byte   $1F                             ; B2B6 1F                       .
        ora     L1714,x                         ; B2B7 1D 14 17                 ...
        .byte   $1F                             ; B2BA 1F                       .
        .byte   $1F                             ; B2BB 1F                       .
        .byte   $14                             ; B2BC 14                       .
        plp                                     ; B2BD 28                       (
        .byte   $1F                             ; B2BE 1F                       .
        ora     L2120,x                         ; B2BF 1D 20 21                 . !
        and     ($23,x)                         ; B2C2 21 23                    !#
        plp                                     ; B2C4 28                       (
        ora     ($21,x)                         ; B2C5 01 21                    .!
        ora     (L0028,x)                       ; B2C7 01 28                    .(
        .byte   $04                             ; B2C9 04                       .
        and     ($04,x)                         ; B2CA 21 04                    !.
        bit     $25                             ; B2CC 24 25                    $%
        bit     $352D                           ; B2CE 2C 2D 35                 ,-5
        .byte   $47                             ; B2D1 47                       G
        and     $354F,x                         ; B2D2 3D 4F 35                 =O5
        rol     $4F                             ; B2D5 26 4F                    &O
        rol     $720C                           ; B2D7 2E 0C 72                 ..r
        .byte   $14                             ; B2DA 14                       .
        .byte   $7A                             ; B2DB 7A                       z
        .byte   $73                             ; B2DC 73                       s
        plp                                     ; B2DD 28                       (
        .byte   $7B                             ; B2DE 7B                       {
        ora     (L0020),y                       ; B2DF 11 20                    . 
        and     ($0C,x)                         ; B2E1 21 0C                    !.
        ora     (L0020),y                       ; B2E3 11 20                    . 
        and     ($0C,x)                         ; B2E5 21 0C                    !.
        jsr     L6814                           ; B2E7 20 14 68                  .h
        .byte   $14                             ; B2EA 14                       .
        pla                                     ; B2EB 68                       h
        adc     #$16                            ; B2EC 69 16                    i.
        adc     #$17                            ; B2EE 69 17                    i.
        plp                                     ; B2F0 28                       (
        .byte   $04                             ; B2F1 04                       .
        and     ($16,x)                         ; B2F2 21 16                    !.
        .byte   $14                             ; B2F4 14                       .
        ror     a                               ; B2F5 6A                       j
        .byte   $14                             ; B2F6 14                       .
        ora     ($6B),y                         ; B2F7 11 6B                    .k
        ora     $0C,x                           ; B2F9 15 0C                    ..
        asl     $14,x                           ; B2FB 16 14                    ..
        .byte   $17                             ; B2FD 17                       .
        .byte   $14                             ; B2FE 14                       .
        .byte   $1C                             ; B2FF 1C                       .
        .byte   $14                             ; B300 14                       .
        plp                                     ; B301 28                       (
        ora     $281D,x                         ; B302 1D 1D 28                 ..(
        .byte   $17                             ; B305 17                       .
        and     ($16,x)                         ; B306 21 16                    !.
        .byte   $14                             ; B308 14                       .
        .byte   $17                             ; B309 17                       .
        .byte   $14                             ; B30A 14                       .
        ora     $14,x                           ; B30B 15 14                    ..
        ora     ($14),y                         ; B30D 11 14                    ..
LB30F:  asl     $1D,x                           ; B30F 16 1D                    ..
        .byte   $1F                             ; B311 1F                       .
        .byte   $2B                             ; B312 2B                       +
        .byte   $23                             ; B313 23                       #
        ora     $1C1E,x                         ; B314 1D 1E 1C                 ...
        asl     L1714,x                         ; B317 1E 14 17                 ...
        php                                     ; B31A 08                       .
        bit     $14                             ; B31B 24 14                    $.
        ora     $26,x                           ; B31D 15 26                    .&
        jsr     L1D1C                           ; B31F 20 1C 1D                  ..
        and     (L0028,x)                       ; B322 21 28                    !(
        .byte   $04                             ; B324 04                       .
        .byte   $37                             ; B325 37                       7
        .byte   $04                             ; B326 04                       .
        .byte   $37                             ; B327 37                       7
        rol     L0028,x                         ; B328 36 28                    6(
        rol     L0020,x                         ; B32A 36 20                    6 
        plp                                     ; B32C 28                       (
        .byte   $37                             ; B32D 37                       7
        and     ($37,x)                         ; B32E 21 37                    !7
        and     $36                             ; B330 25 36                    %6
        .byte   $2D,$36,$A2                     ; B332 2D 36 A2                 -6.
        .byte   $A3                             ; B335 A3                       .
        .byte   $37                             ; B336 37                       7
        .byte   $2F                             ; B337 2F                       /
        .byte   $A3                             ; B338 A3                       .
        ldy     $2F                             ; B339 A4 2F                    ./
        rol     $72,x                           ; B33B 36 72                    6r
        .byte   $73                             ; B33D 73                       s
        .byte   $72                             ; B33E 72                       r
        .byte   $73                             ; B33F 73                       s
        .byte   $7A                             ; B340 7A                       z
        .byte   $7B                             ; B341 7B                       {
        ror     a                               ; B342 6A                       j
        .byte   $6B                             ; B343 6B                       k
        plp                                     ; B344 28                       (
        bit     $1121                           ; B345 2C 21 11                 ,!.
        and     $0C2E                           ; B348 2D 2E 0C                 -..
        ora     ($37),y                         ; B34B 11 37                    .7
        .byte   $1B                             ; B34D 1B                       .
        .byte   $37                             ; B34E 37                       7
        rol     $4F,x                           ; B34F 36 4F                    6O
        rol     $110C                           ; B351 2E 0C 11                 ...
        bit     $0C2E                           ; B354 2C 2E 0C                 ,..
        .byte   $0C                             ; B357 0C                       .
        .byte   $14                             ; B358 14                       .
        .byte   $14                             ; B359 14                       .
        .byte   $14                             ; B35A 14                       .
        .byte   $14                             ; B35B 14                       .
        .byte   $0C                             ; B35C 0C                       .
        plp                                     ; B35D 28                       (
        .byte   $14                             ; B35E 14                       .
        .byte   $0C                             ; B35F 0C                       .
        plp                                     ; B360 28                       (
        php                                     ; B361 08                       .
        and     ($04,x)                         ; B362 21 04                    !.
        plp                                     ; B364 28                       (
        .byte   $17                             ; B365 17                       .
        plp                                     ; B366 28                       (
        .byte   $1C                             ; B367 1C                       .
        .byte   $14                             ; B368 14                       .
        .byte   $17                             ; B369 17                       .
        ora     $141E,x                         ; B36A 1D 1E 14                 ...
        .byte   $14                             ; B36D 14                       .
        .byte   $1C                             ; B36E 1C                       .
        ora     $3482,x                         ; B36F 1D 82 34                 ..4
        brk                                     ; B372 00                       .
        brk                                     ; B373 00                       .
        .byte   $82                             ; B374 82                       .
        .byte   $3F                             ; B375 3F                       ?
        brk                                     ; B376 00                       .
        brk                                     ; B377 00                       .
        plp                                     ; B378 28                       (
        .byte   $07                             ; B379 07                       .
        and     ($07,x)                         ; B37A 21 07                    !.
        bcc     LB30F                           ; B37C 90 91                    ..
        tya                                     ; B37E 98                       .
        sta     $9098,y                         ; B37F 99 98 90                 ...
        sta     $9098,y                         ; B382 99 98 90                 ...
        .byte   $04                             ; B385 04                       .
        tya                                     ; B386 98                       .
        .byte   $04                             ; B387 04                       .
        brk                                     ; B388 00                       .
        plp                                     ; B389 28                       (
        brk                                     ; B38A 00                       .
        jsr     L0028                           ; B38B 20 28 00                  (.
        and     (L0000,x)                       ; B38E 21 00                    !.
        sta     $98,y                           ; B390 99 98 00                 ...
        brk                                     ; B393 00                       .
        brk                                     ; B394 00                       .
        plp                                     ; B395 28                       (
        .byte   $0F                             ; B396 0F                       .
        jsr     L280F                           ; B397 20 0F 28                  .(
        brk                                     ; B39A 00                       .
        jsr     L0028                           ; B39B 20 28 00                  (.
        brk                                     ; B39E 00                       .
        brk                                     ; B39F 00                       .
        brk                                     ; B3A0 00                       .
        brk                                     ; B3A1 00                       .
        asl     a:$1C,x                         ; B3A2 1E 1C 00                 ...
        .byte   $1C                             ; B3A5 1C                       .
        .byte   $1F                             ; B3A6 1F                       .
        asl     $1D1F,x                         ; B3A7 1E 1F 1D                 ...
        and     #$2A                            ; B3AA 29 2A                    )*
        jsr     L2121                           ; B3AC 20 21 21                  !!
        jsr     L3525                           ; B3AF 20 25 35                  %5
        and     $903D                           ; B3B2 2D 3D 90                 -=.
        .byte   $04                             ; B3B5 04                       .
        tya                                     ; B3B6 98                       .
        sta     $1F1C,y                         ; B3B7 99 1C 1F                 ...
        brk                                     ; B3BA 00                       .
        brk                                     ; B3BB 00                       .
        .byte   $1F                             ; B3BC 1F                       .
        asl     a:L0000,x                       ; B3BD 1E 00 00                 ...
        .byte   $1F                             ; B3C0 1F                       .
        ora     $200F,x                         ; B3C1 1D 0F 20                 .. 
        .byte   $0F                             ; B3C4 0F                       .
        plp                                     ; B3C5 28                       (
        .byte   $0F                             ; B3C6 0F                       .
        jsr     L0728                           ; B3C7 20 28 07                  (.
        and     $35                             ; B3CA 25 35                    %5
        brk                                     ; B3CC 00                       .
        brk                                     ; B3CD 00                       .
        and     $25,x                           ; B3CE 35 25                    5%
        brk                                     ; B3D0 00                       .
        brk                                     ; B3D1 00                       .
        and     $35,x                           ; B3D2 35 35                    55
        brk                                     ; B3D4 00                       .
        brk                                     ; B3D5 00                       .
        and     $08                             ; B3D6 25 08                    %.
        brk                                     ; B3D8 00                       .
        brk                                     ; B3D9 00                       .
        and     $35                             ; B3DA 25 35                    %5
        .byte   $0F                             ; B3DC 0F                       .
        plp                                     ; B3DD 28                       (
        and     $25,x                           ; B3DE 35 25                    5%
        and     a:$3D                           ; B3E0 2D 3D 00                 -=.
        brk                                     ; B3E3 00                       .
        .byte   $4F                             ; B3E4 4F                       O
        and     a:L0000                         ; B3E5 2D 00 00                 -..
        and     a:$2D,x                         ; B3E8 3D 2D 00                 =-.
        brk                                     ; B3EB 00                       .
        and     a:$4F,x                         ; B3EC 3D 4F 00                 =O.
        brk                                     ; B3EF 00                       .
        and     a:$04                           ; B3F0 2D 04 00                 -..
        brk                                     ; B3F3 00                       .
        brk                                     ; B3F4 00                       .
        brk                                     ; B3F5 00                       .
        brk                                     ; B3F6 00                       .
        ora     L0028                           ; B3F7 05 28                    .(
        and     ($25),y                         ; B3F9 31 25                    1%
        and     $282D,y                         ; B3FB 39 2D 28                 9-(
        and     (L0020,x)                       ; B3FE 21 20                    ! 
        plp                                     ; B400 28                       (
        .byte   $1F                             ; B401 1F                       .
        plp                                     ; B402 28                       (
        .byte   $23                             ; B403 23                       #
        ora     $2B1E,x                         ; B404 1D 1E 2B                 ..+
        .byte   $33                             ; B407 33                       3
        and     $2100                           ; B408 2D 00 21                 -.!
        brk                                     ; B40B 00                       .
        .byte   $32                             ; B40C 32                       2
        brk                                     ; B40D 00                       .
        plp                                     ; B40E 28                       (
        jsr     L3B28                           ; B40F 20 28 3B                  (;
        plp                                     ; B412 28                       (
        .byte   $3B                             ; B413 3B                       ;
        brk                                     ; B414 00                       .
        brk                                     ; B415 00                       .
        plp                                     ; B416 28                       (
        brk                                     ; B417 00                       .
        brk                                     ; B418 00                       .
        brk                                     ; B419 00                       .
        brk                                     ; B41A 00                       .
        plp                                     ; B41B 28                       (
        and     $40                             ; B41C 25 40                    %@
        and     $3048                           ; B41E 2D 48 30                 -H0
        and     $38                             ; B421 25 38                    %8
        and     a:L0000                         ; B423 2D 00 00                 -..
        and     (L0028,x)                       ; B426 21 28                    !(
        and     $2800                           ; B428 2D 00 28                 -.(
        brk                                     ; B42B 00                       .
        .byte   $32                             ; B42C 32                       2
        plp                                     ; B42D 28                       (
        brk                                     ; B42E 00                       .
        .byte   $20,$A2,$A3                     ; B42F 20 A2 A3                  ..
        .byte   $37                             ; B432 37                       7
        .byte   $19,$A3,$A4                     ; B433 19 A3 A4                 ...
        .byte   $19,$36,$A2                     ; B436 19 36 A2                 .6.
        .byte   $A3                             ; B439 A3                       .
        .byte   $2C,$4F,$A3                     ; B43A 2C 4F A3                 ,O.
        ldy     $4F                             ; B43D A4 4F                    .O
        rol     $3130                           ; B43F 2E 30 31                 .01
        ldy     #$A1                            ; B442 A0 A1                    ..
        bmi     LB477                           ; B444 30 31                    01
        ldy     #$39                            ; B446 A0 39                    .9
        brk                                     ; B448 00                       .
        plp                                     ; B449 28                       (
        brk                                     ; B44A 00                       .
        and     L0000                           ; B44B 25 00                    %.
        brk                                     ; B44D 00                       .
        .byte   $7A                             ; B44E 7A                       z
        .byte   $7B                             ; B44F 7B                       {
        brk                                     ; B450 00                       .
        and     $2800                           ; B451 2D 00 28                 -.(
        ror     a                               ; B454 6A                       j
        .byte   $6B                             ; B455 6B                       k
        .byte   $72                             ; B456 72                       r
        .byte   $73                             ; B457 73                       s
        and     $26                             ; B458 25 26                    %&
        and     $042E                           ; B45A 2D 2E 04                 -..
        bit     $04                             ; B45D 24 04                    $.
        bit     $7020                           ; B45F 2C 20 70                 , p
        plp                                     ; B462 28                       (
        sei                                     ; B463 78                       x
        .byte   $0C                             ; B464 0C                       .
        .byte   $0C                             ; B465 0C                       .
        .byte   $14                             ; B466 14                       .
        .byte   $14                             ; B467 14                       .
        .byte   $80                             ; B468 80                       .
        sta     ($88,x)                         ; B469 81 88                    ..
        .byte   $89                             ; B46B 89                       .
        .byte   $04                             ; B46C 04                       .
        bit     $14                             ; B46D 24 14                    $.
        bit     $2414                           ; B46F 2C 14 24                 ,.$
        asl     $252C,x                         ; B472 1E 2C 25                 .,%
        and     $2D                             ; B475 25 2D                    %-
LB477:  and     $4747                           ; B477 2D 47 47                 -GG
        .byte   $4F                             ; B47A 4F                       O
        .byte   $4F                             ; B47B 4F                       O
        jsr     L7021                           ; B47C 20 21 70                  !p
        plp                                     ; B47F 28                       (
        .byte   $7A                             ; B480 7A                       z
        .byte   $7B                             ; B481 7B                       {
        pla                                     ; B482 68                       h
        adc     #$04                            ; B483 69 04                    i.
        .byte   $7A                             ; B485 7A                       z
        .byte   $04                             ; B486 04                       .
        ror     a                               ; B487 6A                       j
        .byte   $7B                             ; B488 7B                       {
        and     $6B                             ; B489 25 6B                    %k
        and     $1104                           ; B48B 2D 04 11                 -..
        .byte   $14                             ; B48E 14                       .
        ora     $14,x                           ; B48F 15 14                    ..
        ora     $25,x                           ; B491 15 25                    .%
        .byte   $7A                             ; B493 7A                       z
        .byte   $14                             ; B494 14                       .
        ora     $7B,x                           ; B495 15 7B                    .{
        ora     $1C,x                           ; B497 15 1C                    ..
        asl     $110C,x                         ; B499 1E 0C 11                 ...
        .byte   $1C                             ; B49C 1C                       .
        .byte   $1F                             ; B49D 1F                       .
        .byte   $0C                             ; B49E 0C                       .
        bit     $1F                             ; B49F 24 1F                    $.
        asl     $3535,x                         ; B4A1 1E 35 35                 .55
        and     $68                             ; B4A4 25 68                    %h
        and     $1468                           ; B4A6 2D 68 14                 -h.
        ldx     #$14                            ; B4A9 A2 14                    ..
        .byte   $37                             ; B4AB 37                       7
        .byte   $A3                             ; B4AC A3                       .
        .byte   $A3                             ; B4AD A3                       .
        .byte   $2F                             ; B4AE 2F                       /
        .byte   $2F                             ; B4AF 2F                       /
        rol     $14                             ; B4B0 26 14                    &.
        rol     $1414                           ; B4B2 2E 14 14                 ...
        .byte   $37                             ; B4B5 37                       7
        .byte   $14                             ; B4B6 14                       .
        .byte   $37                             ; B4B7 37                       7
        ora     $1919,y                         ; B4B8 19 19 19                 ...
        ora     LA208,y                         ; B4BB 19 08 A2                 ...
        .byte   $04                             ; B4BE 04                       .
        .byte   $2C,$A3,$A3                     ; B4BF 2C A3 A3                 ,..
        .byte   $4F                             ; B4C2 4F                       O
        .byte   $4F                             ; B4C3 4F                       O
        .byte   $1F                             ; B4C4 1F                       .
        .byte   $1F                             ; B4C5 1F                       .
        brk                                     ; B4C6 00                       .
        brk                                     ; B4C7 00                       .
        .byte   $1C                             ; B4C8 1C                       .
        asl     a:L0000,x                       ; B4C9 1E 00 00                 ...
        bit     $35                             ; B4CC 24 35                    $5
        .byte   $37                             ; B4CE 37                       7
        ora     $2635,y                         ; B4CF 19 35 26                 .5&
        ora     $7836,y                         ; B4D2 19 36 78                 .6x
        and     ($21,x)                         ; B4D5 21 21                    !!
        plp                                     ; B4D7 28                       (
        .byte   $04                             ; B4D8 04                       .
        rol     a:$04,x                         ; B4D9 3E 04 00                 >..
        .byte   $47                             ; B4DC 47                       G
        and     $4F                             ; B4DD 25 4F                    %O
        and     $3535                           ; B4DF 2D 35 35                 -55
        .byte   $A3                             ; B4E2 A3                       .
        .byte   $A3                             ; B4E3 A3                       .
        and     $25,x                           ; B4E4 35 25                    5%
        .byte   $A3                             ; B4E6 A3                       .
        and     $2625                           ; B4E7 2D 25 26                 -%&
        and     $3DA4                           ; B4EA 2D A4 3D                 -.=
        .byte   $4F                             ; B4ED 4F                       O
        .byte   $7A                             ; B4EE 7A                       z
        .byte   $7B                             ; B4EF 7B                       {
        and     a:$2E                           ; B4F0 2D 2E 00                 -..
        brk                                     ; B4F3 00                       .
        .byte   $72                             ; B4F4 72                       r
        .byte   $73                             ; B4F5 73                       s
        .byte   $7A                             ; B4F6 7A                       z
        .byte   $7B                             ; B4F7 7B                       {
        php                                     ; B4F8 08                       .
        .byte   $7A                             ; B4F9 7A                       z
        .byte   $04                             ; B4FA 04                       .
        ror     a                               ; B4FB 6A                       j
        .byte   $04                             ; B4FC 04                       .
        .byte   $72                             ; B4FD 72                       r
        .byte   $04                             ; B4FE 04                       .
        .byte   $7A                             ; B4FF 7A                       z
        .byte   $73                             ; B500 73                       s
        and     $7B                             ; B501 25 7B                    %{
        and     $7574                           ; B503 2D 74 75                 -tu
        .byte   $72                             ; B506 72                       r
        .byte   $73                             ; B507 73                       s
        brk                                     ; B508 00                       .
        brk                                     ; B509 00                       .
        .byte   $1C                             ; B50A 1C                       .
        .byte   $1F                             ; B50B 1F                       .
        ror     $67                             ; B50C 66 67                    fg
        ror     $2600                           ; B50E 6E 00 26                 n.&
        brk                                     ; B511 00                       .
        rol     a:L0000                         ; B512 2E 00 00                 ...
LB515:  brk                                     ; B515 00                       .
        .byte   $1F                             ; B516 1F                       .
        asl     a:L0000,x                       ; B517 1E 00 00                 ...
        .byte   $02                             ; B51A 02                       .
        brk                                     ; B51B 00                       .
        .byte   $3C                             ; B51C 3C                       <
        brk                                     ; B51D 00                       .
        brk                                     ; B51E 00                       .
        brk                                     ; B51F 00                       .
        brk                                     ; B520 00                       .
        brk                                     ; B521 00                       .
        brk                                     ; B522 00                       .
        .byte   $02                             ; B523 02                       .
        brk                                     ; B524 00                       .
        brk                                     ; B525 00                       .
        .byte   $02                             ; B526 02                       .
        .byte   $02                             ; B527 02                       .
        .byte   $02                             ; B528 02                       .
        brk                                     ; B529 00                       .
        brk                                     ; B52A 00                       .
        brk                                     ; B52B 00                       .
        brk                                     ; B52C 00                       .
        brk                                     ; B52D 00                       .
        brk                                     ; B52E 00                       .
        asl     $25                             ; B52F 06 25                    .%
        brk                                     ; B531 00                       .
        and     a:L0000                         ; B532 2D 00 00                 -..
        .byte   $02                             ; B535 02                       .
        .byte   $02                             ; B536 02                       .
        .byte   $02                             ; B537 02                       .
        brk                                     ; B538 00                       .
        .byte   $7A                             ; B539 7A                       z
        brk                                     ; B53A 00                       .
        ror     a                               ; B53B 6A                       j
        .byte   $7B                             ; B53C 7B                       {
        php                                     ; B53D 08                       .
        .byte   $6B                             ; B53E 6B                       k
        .byte   $04                             ; B53F 04                       .
        brk                                     ; B540 00                       .
        .byte   $72                             ; B541 72                       r
        brk                                     ; B542 00                       .
        .byte   $72                             ; B543 72                       r
        .byte   $73                             ; B544 73                       s
        .byte   $04                             ; B545 04                       .
        .byte   $73                             ; B546 73                       s
        .byte   $04                             ; B547 04                       .
        and     $7A                             ; B548 25 7A                    %z
        and     $7B6A                           ; B54A 2D 6A 7B                 -j{
        .byte   $04                             ; B54D 04                       .
        .byte   $6B                             ; B54E 6B                       k
        .byte   $04                             ; B54F 04                       .
        .byte   $32                             ; B550 32                       2
        brk                                     ; B551 00                       .
        tya                                     ; B552 98                       .
        sta     $32,y                           ; B553 99 32 00                 .2.
        sta     $321C,y                         ; B556 99 1C 32                 ..2
        brk                                     ; B559 00                       .
        ora     $6A1F,x                         ; B55A 1D 1F 6A                 ..j
        .byte   $6B                             ; B55D 6B                       k
        ora     $901F,x                         ; B55E 1D 1F 90                 ...
        bit     $98                             ; B561 24 98                    $.
        bit     $1C90                           ; B563 2C 90 1C                 ,..
        tya                                     ; B566 98                       .
        brk                                     ; B567 00                       .
        bit     $80                             ; B568 24 80                    $.
        bit     $8188                           ; B56A 2C 88 81                 ,..
        rol     $89                             ; B56D 26 89                    &.
        rol     $1614                           ; B56F 2E 14 16                 ...
        .byte   $7C                             ; B572 7C                       |
        adc     $7A14,x                         ; B573 7D 14 7A                 }.z
        .byte   $7C                             ; B576 7C                       |
        ror     a                               ; B577 6A                       j
        .byte   $7B                             ; B578 7B                       {
        .byte   $17                             ; B579 17                       .
        .byte   $6B                             ; B57A 6B                       k
        .byte   $1C                             ; B57B 1C                       .
        brk                                     ; B57C 00                       .
        .byte   $72                             ; B57D 72                       r
        brk                                     ; B57E 00                       .
        .byte   $7A                             ; B57F 7A                       z
        .byte   $73                             ; B580 73                       s
        .byte   $23                             ; B581 23                       #
        .byte   $7B                             ; B582 7B                       {
        ora     ($18,x)                         ; B583 01 18                    ..
        clc                                     ; B585 18                       .
        ror     $147E,x                         ; B586 7E 7E 14                 ~~.
        .byte   $04                             ; B589 04                       .
        .byte   $14                             ; B58A 14                       .
        .byte   $04                             ; B58B 04                       .
        clc                                     ; B58C 18                       .
        clc                                     ; B58D 18                       .
        clc                                     ; B58E 18                       .
        clc                                     ; B58F 18                       .
        .byte   $14                             ; B590 14                       .
        .byte   $04                             ; B591 04                       .
        .byte   $14                             ; B592 14                       .
        asl     $14,x                           ; B593 16 14                    ..
        .byte   $17                             ; B595 17                       .
        plp                                     ; B596 28                       (
        .byte   $20                             ; B597 20                        
LB598:  clc                                     ; B598 18                       .
        clc                                     ; B599 18                       .
        asl     $781C,x                         ; B59A 1E 1C 78                 ..x
        and     ($70,x)                         ; B59D 21 70                    !p
        plp                                     ; B59F 28                       (
        sei                                     ; B5A0 78                       x
        and     (L0028,x)                       ; B5A1 21 28                    !(
        jsr     L2504                           ; B5A3 20 04 25                  .%
        .byte   $04                             ; B5A6 04                       .
        and     $6968                           ; B5A7 2D 68 69                 -hi
        ror     a                               ; B5AA 6A                       j
        .byte   $6B                             ; B5AB 6B                       k
        .byte   $04                             ; B5AC 04                       .
        bpl     LB5B3                           ; B5AD 10 04                    ..
        ror     $110C,x                         ; B5AF 7E 0C 11                 ~..
        .byte   $14                             ; B5B2 14                       .
LB5B3:  asl     $04,x                           ; B5B3 16 04                    ..
        clc                                     ; B5B5 18                       .
        .byte   $04                             ; B5B6 04                       .
        ror     L1714,x                         ; B5B7 7E 14 17                 ~..
        .byte   $82                             ; B5BA 82                       .
        .byte   $34                             ; B5BB 34                       4
        .byte   $14                             ; B5BC 14                       .
LB5BD:  .byte   $17                             ; B5BD 17                       .
        .byte   $3F                             ; B5BE 3F                       ?
        php                                     ; B5BF 08                       .
        bpl     LB5D2                           ; B5C0 10 10                    ..
        ror     $0C7E,x                         ; B5C2 7E 7E 0C                 ~~.
        .byte   $04                             ; B5C5 04                       .
        .byte   $14                             ; B5C6 14                       .
        .byte   $04                             ; B5C7 04                       .
        brk                                     ; B5C8 00                       .
        brk                                     ; B5C9 00                       .
        php                                     ; B5CA 08                       .
        and     $04                             ; B5CB 25 04                    %.
        and     L2504                           ; B5CD 2D 04 25                 -.%
        .byte   $3D                             ; B5D0 3D                       =
        .byte   $2D                             ; B5D1 2D                       -
LB5D2:  and     $25,x                           ; B5D2 35 25                    5%
        ora     $06                             ; B5D4 05 06                    ..
        brk                                     ; B5D6 00                       .
        brk                                     ; B5D7 00                       .
        jsr     L0C21                           ; B5D8 20 21 0C                  !.
        sta     $14                             ; B5DB 85 14                    ..
        sta     $14                             ; B5DD 85 14                    ..
        sta     $25                             ; B5DF 85 25                    .%
        plp                                     ; B5E1 28                       (
        and     $2820                           ; B5E2 2D 20 28                 - (
        and     $21                             ; B5E5 25 21                    %!
        and     $1514                           ; B5E7 2D 14 15                 -..
        .byte   $14                             ; B5EA 14                       .
        ora     L0028,x                         ; B5EB 15 28                    .(
        ora     ($21),y                         ; B5ED 11 21                    .!
        asl     L0028,x                         ; B5EF 16 28                    .(
        .byte   $17                             ; B5F1 17                       .
        .byte   $0C                             ; B5F2 0C                       .
        asl     L0000,x                         ; B5F3 16 00                    ..
        brk                                     ; B5F5 00                       .
        brk                                     ; B5F6 00                       .
        brk                                     ; B5F7 00                       .
        brk                                     ; B5F8 00                       .
        brk                                     ; B5F9 00                       .
        brk                                     ; B5FA 00                       .
        brk                                     ; B5FB 00                       .
        brk                                     ; B5FC 00                       .
        brk                                     ; B5FD 00                       .
        brk                                     ; B5FE 00                       .
        brk                                     ; B5FF 00                       .
        brk                                     ; B600 00                       .
        ora     (L0000,x)                       ; B601 01 00                    ..
        brk                                     ; B603 00                       .
        brk                                     ; B604 00                       .
        brk                                     ; B605 00                       .
        ora     (L0000,x)                       ; B606 01 00                    ..
        .byte   $02                             ; B608 02                       .
        ora     (L0000,x)                       ; B609 01 00                    ..
        brk                                     ; B60B 00                       .
        brk                                     ; B60C 00                       .
        .byte   $03                             ; B60D 03                       .
        brk                                     ; B60E 00                       .
        brk                                     ; B60F 00                       .
        .byte   $04                             ; B610 04                       .
        brk                                     ; B611 00                       .
        ora     (L0000,x)                       ; B612 01 00                    ..
        brk                                     ; B614 00                       .
        ora     $03                             ; B615 05 03                    ..
        brk                                     ; B617 00                       .
        asl     L0000                           ; B618 06 00                    ..
        .byte   $03                             ; B61A 03                       .
        brk                                     ; B61B 00                       .
        .byte   $07                             ; B61C 07                       .
        php                                     ; B61D 08                       .
        ora     #$04                            ; B61E 09 04                    ..
        asl     $02                             ; B620 06 02                    ..
        ora     L0000                           ; B622 05 00                    ..
        brk                                     ; B624 00                       .
        asl     a                               ; B625 0A                       .
        .byte   $0B                             ; B626 0B                       .
        asl     $0C                             ; B627 06 0C                    ..
        ora     $0D0D                           ; B629 0D 0D 0D                 ...
        ora     $0F0E                           ; B62C 0D 0E 0F                 ...
        .byte   $0C                             ; B62F 0C                       .
        bpl     LB643                           ; B630 10 11                    ..
        bpl     LB645                           ; B632 10 11                    ..
        bpl     LB647                           ; B634 10 11                    ..
        bpl     LB649                           ; B636 10 11                    ..
        .byte   $12                             ; B638 12                       .
        .byte   $13                             ; B639 13                       .
        .byte   $12                             ; B63A 12                       .
        .byte   $13                             ; B63B 13                       .
        .byte   $12                             ; B63C 12                       .
        .byte   $13                             ; B63D 13                       .
        .byte   $12                             ; B63E 12                       .
        .byte   $13                             ; B63F 13                       .
        brk                                     ; B640 00                       .
        brk                                     ; B641 00                       .
        brk                                     ; B642 00                       .
LB643:  brk                                     ; B643 00                       .
        brk                                     ; B644 00                       .
LB645:  brk                                     ; B645 00                       .
        brk                                     ; B646 00                       .
LB647:  ora     (L0000,x)                       ; B647 01 00                    ..
LB649:  ora     (L0000,x)                       ; B649 01 00                    ..
        brk                                     ; B64B 00                       .
        brk                                     ; B64C 00                       .
        brk                                     ; B64D 00                       .
        brk                                     ; B64E 00                       .
        brk                                     ; B64F 00                       .
        brk                                     ; B650 00                       .
        brk                                     ; B651 00                       .
        brk                                     ; B652 00                       .
        brk                                     ; B653 00                       .
        ora     (L0000,x)                       ; B654 01 00                    ..
        brk                                     ; B656 00                       .
        brk                                     ; B657 00                       .
        brk                                     ; B658 00                       .
        .byte   $03                             ; B659 03                       .
        brk                                     ; B65A 00                       .
        brk                                     ; B65B 00                       .
        brk                                     ; B65C 00                       .
        .byte   $03                             ; B65D 03                       .
        brk                                     ; B65E 00                       .
        .byte   $07                             ; B65F 07                       .
        .byte   $14                             ; B660 14                       .
        ora     $14                             ; B661 05 14                    ..
        brk                                     ; B663 00                       .
        brk                                     ; B664 00                       .
        ora     L0000                           ; B665 05 00                    ..
        brk                                     ; B667 00                       .
        ora     $0D0D                           ; B668 0D 0D 0D                 ...
        ora     $150D                           ; B66B 0D 0D 15                 ...
        asl     $14,x                           ; B66E 16 14                    ..
        bpl     LB683                           ; B670 10 11                    ..
        bpl     LB685                           ; B672 10 11                    ..
        bpl     LB68B                           ; B674 10 15                    ..
        asl     $0D,x                           ; B676 16 0D                    ..
        .byte   $12                             ; B678 12                       .
        .byte   $13                             ; B679 13                       .
        .byte   $12                             ; B67A 12                       .
        .byte   $13                             ; B67B 13                       .
        .byte   $12                             ; B67C 12                       .
        ora     $16,x                           ; B67D 15 16                    ..
        .byte   $17                             ; B67F 17                       .
        brk                                     ; B680 00                       .
        brk                                     ; B681 00                       .
        brk                                     ; B682 00                       .
LB683:  brk                                     ; B683 00                       .
        brk                                     ; B684 00                       .
LB685:  brk                                     ; B685 00                       .
        brk                                     ; B686 00                       .
        ora     L0000,x                         ; B687 15 00                    ..
        ora     (L0000,x)                       ; B689 01 00                    ..
LB68B:  brk                                     ; B68B 00                       .
        brk                                     ; B68C 00                       .
        brk                                     ; B68D 00                       .
        brk                                     ; B68E 00                       .
        brk                                     ; B68F 00                       .
        .byte   $03                             ; B690 03                       .
        .byte   $03                             ; B691 03                       .
        brk                                     ; B692 00                       .
        brk                                     ; B693 00                       .
        brk                                     ; B694 00                       .
        brk                                     ; B695 00                       .
        .byte   $02                             ; B696 02                       .
        brk                                     ; B697 00                       .
        php                                     ; B698 08                       .
        ora     #$04                            ; B699 09 04                    ..
        brk                                     ; B69B 00                       .
        .byte   $02                             ; B69C 02                       .
        brk                                     ; B69D 00                       .
        brk                                     ; B69E 00                       .
        ora     ($0A,x)                         ; B69F 01 0A                    ..
        .byte   $0B                             ; B6A1 0B                       .
        asl     L0000                           ; B6A2 06 00                    ..
        brk                                     ; B6A4 00                       .
        .byte   $03                             ; B6A5 03                       .
        brk                                     ; B6A6 00                       .
        brk                                     ; B6A7 00                       .
        clc                                     ; B6A8 18                       .
        .byte   $0B                             ; B6A9 0B                       .
        ora     $1A,y                           ; B6AA 19 1A 00                 ...
        ora     L0000                           ; B6AD 05 00                    ..
        brk                                     ; B6AF 00                       .
        asl     $0C0F                           ; B6B0 0E 0F 0C                 ...
        ora     $1B0D                           ; B6B3 0D 0D 1B                 ...
        .byte   $1B                             ; B6B6 1B                       .
        .byte   $1C                             ; B6B7 1C                       .
        .byte   $17                             ; B6B8 17                       .
        .byte   $17                             ; B6B9 17                       .
        brk                                     ; B6BA 00                       .
        .byte   $17                             ; B6BB 17                       .
        .byte   $17                             ; B6BC 17                       .
        .byte   $17                             ; B6BD 17                       .
        brk                                     ; B6BE 00                       .
        brk                                     ; B6BF 00                       .
        asl     $15,x                           ; B6C0 16 15                    ..
        ora     $1F1E,x                         ; B6C2 1D 1E 1F                 ...
        jsr     L1621                           ; B6C5 20 21 16                  !.
        brk                                     ; B6C8 00                       .
        ora     $1D,x                           ; B6C9 15 1D                    ..
        asl     $2022,x                         ; B6CB 1E 22 20                 ." 
        and     ($16,x)                         ; B6CE 21 16                    !.
        brk                                     ; B6D0 00                       .
        brk                                     ; B6D1 00                       .
        brk                                     ; B6D2 00                       .
        .byte   $23                             ; B6D3 23                       #
        .byte   $23                             ; B6D4 23                       #
        bit     $25                             ; B6D5 24 25                    $%
        asl     L0000,x                         ; B6D7 16 00                    ..
        brk                                     ; B6D9 00                       .
        brk                                     ; B6DA 00                       .
        rol     $26                             ; B6DB 26 26                    &&
        .byte   $27                             ; B6DD 27                       '
        plp                                     ; B6DE 28                       (
        asl     L0000,x                         ; B6DF 16 00                    ..
        brk                                     ; B6E1 00                       .
        brk                                     ; B6E2 00                       .
        and     #$29                            ; B6E3 29 29                    ))
        rol     $2A                             ; B6E5 26 2A                    &*
        asl     L0000,x                         ; B6E7 16 00                    ..
        brk                                     ; B6E9 00                       .
        .byte   $2B                             ; B6EA 2B                       +
        bit     $2E2D                           ; B6EB 2C 2D 2E                 ,-.
        .byte   $2F                             ; B6EE 2F                       /
        ora     $1C,x                           ; B6EF 15 1C                    ..
        ora     $3015                           ; B6F1 0D 15 30                 ..0
        ora     ($10),y                         ; B6F4 11 10                    ..
        ora     ($10),y                         ; B6F6 11 10                    ..
        .byte   $17                             ; B6F8 17                       .
        brk                                     ; B6F9 00                       .
        ora     $31,x                           ; B6FA 15 31                    .1
        .byte   $13                             ; B6FC 13                       .
        .byte   $12                             ; B6FD 12                       .
        .byte   $13                             ; B6FE 13                       .
        .byte   $12                             ; B6FF 12                       .
        ora     $32,x                           ; B700 15 32                    .2
        .byte   $33                             ; B702 33                       3
        .byte   $34                             ; B703 34                       4
        and     $15,x                           ; B704 35 15                    5.
        asl     $15,x                           ; B706 16 15                    ..
        ora     $32,x                           ; B708 15 32                    .2
        .byte   $23                             ; B70A 23                       #
        rol     $37,x                           ; B70B 36 37                    67
        sec                                     ; B70D 38                       8
        sec                                     ; B70E 38                       8
        and     $3215,y                         ; B70F 39 15 32                 9.2
        rol     $3A                             ; B712 26 3A                    &:
        .byte   $3B                             ; B714 3B                       ;
        rol     $26                             ; B715 26 26                    &&
        rol     a                               ; B717 2A                       *
        ora     $32,x                           ; B718 15 32                    .2
        and     #$3A                            ; B71A 29 3A                    ):
        .byte   $3B                             ; B71C 3B                       ;
        and     #$29                            ; B71D 29 29                    ))
        rol     a                               ; B71F 2A                       *
        ora     $3C,x                           ; B720 15 3C                    .<
        and     #$3D                            ; B722 29 3D                    )=
        rol     $2E3F,x                         ; B724 3E 3F 2E                 >?.
        rti                                     ; B727 40                       @

; ----------------------------------------------------------------------------
        ora     $41,x                           ; B728 15 41                    .A
        and     #$26                            ; B72A 29 26                    )&
        .byte   $42                             ; B72C 42                       B
        .byte   $43                             ; B72D 43                       C
        .byte   $23                             ; B72E 23                       #
        .byte   $33                             ; B72F 33                       3
        .byte   $44                             ; B730 44                       D
        eor     $2D                             ; B731 45 2D                    E-
        and     $462D                           ; B733 2D 2D 46                 --F
        .byte   $47                             ; B736 47                       G
        pha                                     ; B737 48                       H
        .byte   $12                             ; B738 12                       .
        ora     $16,x                           ; B739 15 16                    ..
        ora     $16,x                           ; B73B 15 16                    ..
        eor     #$4A                            ; B73D 49 4A                    IJ
        asl     $4B,x                           ; B73F 16 4B                    .K
        jmp     L1615                           ; B741 4C 15 16                 L..

; ----------------------------------------------------------------------------
        eor     $4F4E                           ; B744 4D 4E 4F                 MNO
        ora     $4B,x                           ; B747 15 4B                    .K
        jmp     L1615                           ; B749 4C 15 16                 L..

; ----------------------------------------------------------------------------
        eor     $504E                           ; B74C 4D 4E 50                 MNP
        ora     $51,x                           ; B74F 15 51                    .Q
        .byte   $52                             ; B751 52                       R
        ora     $16,x                           ; B752 15 16                    ..
        .byte   $53                             ; B754 53                       S
        .byte   $54                             ; B755 54                       T
        .byte   $23                             ; B756 23                       #
        ora     $41,x                           ; B757 15 41                    .A
        rol     $15                             ; B759 26 15                    &.
        asl     $55,x                           ; B75B 16 55                    .U
        rol     $26                             ; B75D 26 26                    &&
        ora     $41,x                           ; B75F 15 41                    .A
        and     #$23                            ; B761 29 23                    )#
        .byte   $23                             ; B763 23                       #
        lsr     $29,x                           ; B764 56 29                    V)
        and     #$15                            ; B766 29 15                    ).
        eor     ($29,x)                         ; B768 41 29                    A)
        rol     $26                             ; B76A 26 26                    &&
        lsr     $29,x                           ; B76C 56 29                    V)
        and     #$57                            ; B76E 29 57                    )W
        ora     $58,x                           ; B770 15 58                    .X
        eor     $5B5A,y                         ; B772 59 5A 5B                 YZ[
        and     $5B5A                           ; B775 2D 5A 5B                 -Z[
        ora     $32,x                           ; B778 15 32                    .2
        .byte   $5C                             ; B77A 5C                       \
        .byte   $5C                             ; B77B 5C                       \
        .byte   $5C                             ; B77C 5C                       \
        .byte   $5C                             ; B77D 5C                       \
        eor     $5E15,x                         ; B77E 5D 15 5E                 ].^
        brk                                     ; B781 00                       .
        .byte   $5F                             ; B782 5F                       _
        .byte   $5F                             ; B783 5F                       _
        rts                                     ; B784 60                       `

; ----------------------------------------------------------------------------
        adc     ($60,x)                         ; B785 61 60                    a`
        .byte   $62                             ; B787 62                       b
        .byte   $63                             ; B788 63                       c
        .byte   $5F                             ; B789 5F                       _
        rts                                     ; B78A 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B78B 60                       `

; ----------------------------------------------------------------------------
        .byte   $5F                             ; B78C 5F                       _
        .byte   $5F                             ; B78D 5F                       _
        .byte   $64                             ; B78E 64                       d
        adc     $63                             ; B78F 65 63                    ec
        .byte   $5F                             ; B791 5F                       _
        .byte   $5F                             ; B792 5F                       _
        .byte   $5F                             ; B793 5F                       _
        .byte   $5F                             ; B794 5F                       _
        .byte   $5F                             ; B795 5F                       _
        brk                                     ; B796 00                       .
        ror     $5E                             ; B797 66 5E                    f^
        .byte   $64                             ; B799 64                       d
LB79A:  .byte   $5F                             ; B79A 5F                       _
        rts                                     ; B79B 60                       `

; ----------------------------------------------------------------------------
        .byte   $5F                             ; B79C 5F                       _
        rts                                     ; B79D 60                       `

; ----------------------------------------------------------------------------
        .byte   $5F                             ; B79E 5F                       _
        .byte   $62                             ; B79F 62                       b
        .byte   $63                             ; B7A0 63                       c
        .byte   $5F                             ; B7A1 5F                       _
        .byte   $5F                             ; B7A2 5F                       _
        .byte   $5F                             ; B7A3 5F                       _
        .byte   $5F                             ; B7A4 5F                       _
        .byte   $5F                             ; B7A5 5F                       _
        .byte   $5F                             ; B7A6 5F                       _
        .byte   $62                             ; B7A7 62                       b
        .byte   $67                             ; B7A8 67                       g
        brk                                     ; B7A9 00                       .
        .byte   $64                             ; B7AA 64                       d
        .byte   $5F                             ; B7AB 5F                       _
        .byte   $5F                             ; B7AC 5F                       _
        .byte   $62                             ; B7AD 62                       b
        asl     $15,x                           ; B7AE 16 15                    ..
        pla                                     ; B7B0 68                       h
        adc     #$6A                            ; B7B1 69 6A                    ij
        .byte   $44                             ; B7B3 44                       D
        ror     a                               ; B7B4 6A                       j
        .byte   $44                             ; B7B5 44                       D
        ora     $16,x                           ; B7B6 15 16                    ..
        asl     $12,x                           ; B7B8 16 12                    ..
        .byte   $13                             ; B7BA 13                       .
        .byte   $12                             ; B7BB 12                       .
        .byte   $13                             ; B7BC 13                       .
        .byte   $12                             ; B7BD 12                       .
        ora     $16,x                           ; B7BE 15 16                    ..
        .byte   $6B                             ; B7C0 6B                       k
        .byte   $32                             ; B7C1 32                       2
        jmp     (L6C6C)                         ; B7C2 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        jmp     (L6C6C)                         ; B7C5 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        lsr     $5F6D,x                         ; B7C8 5E 6D 5F                 ^m_
        brk                                     ; B7CB 00                       .
        jmp     (L6C6C)                         ; B7CC 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        jmp     (L645E)                         ; B7CF 6C 5E 64                 l^d

; ----------------------------------------------------------------------------
        rts                                     ; B7D2 60                       `

; ----------------------------------------------------------------------------
        .byte   $5F                             ; B7D3 5F                       _
        ror     $6F6F                           ; B7D4 6E 6F 6F                 noo
        bvs     LB837                           ; B7D7 70 5E                    p^
        .byte   $64                             ; B7D9 64                       d
        .byte   $5F                             ; B7DA 5F                       _
        rts                                     ; B7DB 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B7DC 60                       `

; ----------------------------------------------------------------------------
        .byte   $64                             ; B7DD 64                       d
        brk                                     ; B7DE 00                       .
        adc     ($5E),y                         ; B7DF 71 5E                    q^
        .byte   $5F                             ; B7E1 5F                       _
        .byte   $5F                             ; B7E2 5F                       _
        .byte   $5F                             ; B7E3 5F                       _
        rts                                     ; B7E4 60                       `

; ----------------------------------------------------------------------------
        .byte   $5F                             ; B7E5 5F                       _
        brk                                     ; B7E6 00                       .
        adc     ($5E),y                         ; B7E7 71 5E                    q^
LB7E9:  .byte   $64                             ; B7E9 64                       d
        rts                                     ; B7EA 60                       `

; ----------------------------------------------------------------------------
        .byte   $5F                             ; B7EB 5F                       _
        .byte   $5F                             ; B7EC 5F                       _
        rts                                     ; B7ED 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B7EE 60                       `

; ----------------------------------------------------------------------------
        adc     ($72),y                         ; B7EF 71 72                    qr
        .byte   $73                             ; B7F1 73                       s
        .byte   $73                             ; B7F2 73                       s
        .byte   $73                             ; B7F3 73                       s
        .byte   $74                             ; B7F4 74                       t
        adc     $76,x                           ; B7F5 75 76                    uv
        .byte   $77                             ; B7F7 77                       w
        sei                                     ; B7F8 78                       x
        adc     $7A7A,y                         ; B7F9 79 7A 7A                 yzz
        .byte   $7B                             ; B7FC 7B                       {
        .byte   $7C                             ; B7FD 7C                       |
        sei                                     ; B7FE 78                       x
        .byte   $79                             ; B7FF 79                       y
LB800:  .byte   $63                             ; B800 63                       c
        .byte   $14                             ; B801 14                       .
        brk                                     ; B802 00                       .
        ora     (L0000,x)                       ; B803 01 00                    ..
        adc     a:L0000,x                       ; B805 7D 00 00                 }..
        .byte   $63                             ; B808 63                       c
        brk                                     ; B809 00                       .
        brk                                     ; B80A 00                       .
        brk                                     ; B80B 00                       .
        .byte   $14                             ; B80C 14                       .
        .byte   $02                             ; B80D 02                       .
        brk                                     ; B80E 00                       .
        ora     ($63,x)                         ; B80F 01 63                    .c
        brk                                     ; B811 00                       .
        ora     (L0000,x)                       ; B812 01 00                    ..
        brk                                     ; B814 00                       .
        brk                                     ; B815 00                       .
        brk                                     ; B816 00                       .
        brk                                     ; B817 00                       .
        .byte   $63                             ; B818 63                       c
        brk                                     ; B819 00                       .
        brk                                     ; B81A 00                       .
        brk                                     ; B81B 00                       .
        brk                                     ; B81C 00                       .
        brk                                     ; B81D 00                       .
        brk                                     ; B81E 00                       .
        .byte   $07                             ; B81F 07                       .
        .byte   $63                             ; B820 63                       c
        brk                                     ; B821 00                       .
        brk                                     ; B822 00                       .
        brk                                     ; B823 00                       .
        brk                                     ; B824 00                       .
        brk                                     ; B825 00                       .
        brk                                     ; B826 00                       .
        brk                                     ; B827 00                       .
        ror     $0D0D,x                         ; B828 7E 0D 0D                 ~..
        ora     $0D0D                           ; B82B 0D 0D 0D                 ...
        ora     $7F0D                           ; B82E 0D 0D 7F                 ...
        cli                                     ; B831 58                       X
        .byte   $80                             ; B832 80                       .
        ror     a                               ; B833 6A                       j
        .byte   $44                             ; B834 44                       D
        ror     a                               ; B835 6A                       j
        .byte   $44                             ; B836 44                       D
LB837:  ror     a                               ; B837 6A                       j
        .byte   $6B                             ; B838 6B                       k
        .byte   $32                             ; B839 32                       2
        .byte   $12                             ; B83A 12                       .
        .byte   $13                             ; B83B 13                       .
        .byte   $12                             ; B83C 12                       .
        .byte   $13                             ; B83D 13                       .
        .byte   $12                             ; B83E 12                       .
        .byte   $13                             ; B83F 13                       .
        brk                                     ; B840 00                       .
        brk                                     ; B841 00                       .
        ora     (L0000,x)                       ; B842 01 00                    ..
        brk                                     ; B844 00                       .
        brk                                     ; B845 00                       .
        brk                                     ; B846 00                       .
        brk                                     ; B847 00                       .
        brk                                     ; B848 00                       .
        brk                                     ; B849 00                       .
        brk                                     ; B84A 00                       .
        .byte   $14                             ; B84B 14                       .
        brk                                     ; B84C 00                       .
        brk                                     ; B84D 00                       .
        .byte   $03                             ; B84E 03                       .
        .byte   $03                             ; B84F 03                       .
        .byte   $03                             ; B850 03                       .
        .byte   $03                             ; B851 03                       .
        brk                                     ; B852 00                       .
        brk                                     ; B853 00                       .
        brk                                     ; B854 00                       .
        .byte   $07                             ; B855 07                       .
        php                                     ; B856 08                       .
        ora     #$08                            ; B857 09 08                    ..
        ora     #$04                            ; B859 09 04                    ..
        brk                                     ; B85B 00                       .
        brk                                     ; B85C 00                       .
        brk                                     ; B85D 00                       .
        asl     a                               ; B85E 0A                       .
        .byte   $0B                             ; B85F 0B                       .
        asl     a                               ; B860 0A                       .
        .byte   $0B                             ; B861 0B                       .
        asl     L0000                           ; B862 06 00                    ..
        brk                                     ; B864 00                       .
        brk                                     ; B865 00                       .
        asl     a                               ; B866 0A                       .
        .byte   $0B                             ; B867 0B                       .
        asl     $0C0F                           ; B868 0E 0F 0C                 ...
        ora     $7E0D                           ; B86B 0D 0D 7E                 ..~
        asl     $440F                           ; B86E 0E 0F 44                 ..D
        ror     a                               ; B871 6A                       j
        sta     ($17,x)                         ; B872 81 17                    ..
        .byte   $62                             ; B874 62                       b
        .byte   $82                             ; B875 82                       .
        .byte   $17                             ; B876 17                       .
        .byte   $83                             ; B877 83                       .
        .byte   $12                             ; B878 12                       .
        .byte   $13                             ; B879 13                       .
        sty     L0000                           ; B87A 84 00                    ..
        .byte   $62                             ; B87C 62                       b
LB87D:  .byte   $63                             ; B87D 63                       c
        brk                                     ; B87E 00                       .
        ora     $01,x                           ; B87F 15 01                    ..
        brk                                     ; B881 00                       .
        .byte   $14                             ; B882 14                       .
        brk                                     ; B883 00                       .
        brk                                     ; B884 00                       .
        brk                                     ; B885 00                       .
        .byte   $02                             ; B886 02                       .
        brk                                     ; B887 00                       .
        brk                                     ; B888 00                       .
        brk                                     ; B889 00                       .
        brk                                     ; B88A 00                       .
        brk                                     ; B88B 00                       .
        .byte   $14                             ; B88C 14                       .
        ora     ($01,x)                         ; B88D 01 01                    ..
        brk                                     ; B88F 00                       .
        .byte   $04                             ; B890 04                       .
        .byte   $02                             ; B891 02                       .
        ora     (L0000,x)                       ; B892 01 00                    ..
        brk                                     ; B894 00                       .
        brk                                     ; B895 00                       .
        brk                                     ; B896 00                       .
        brk                                     ; B897 00                       .
        asl     L0000                           ; B898 06 00                    ..
        brk                                     ; B89A 00                       .
        brk                                     ; B89B 00                       .
        brk                                     ; B89C 00                       .
        .byte   $14                             ; B89D 14                       .
        sta     $03                             ; B89E 85 03                    ..
        asl     L0000                           ; B8A0 06 00                    ..
        brk                                     ; B8A2 00                       .
        .byte   $14                             ; B8A3 14                       .
        brk                                     ; B8A4 00                       .
        stx     $87                             ; B8A5 86 87                    ..
        php                                     ; B8A7 08                       .
        .byte   $0C                             ; B8A8 0C                       .
        ora     $0D0D                           ; B8A9 0D 0D 0D                 ...
        ror     $7E88,x                         ; B8AC 7E 88 7E                 ~.~
        asl     $8389                           ; B8AF 0E 89 83                 ...
        .byte   $89                             ; B8B2 89                       .
        .byte   $17                             ; B8B3 17                       .
        txa                                     ; B8B4 8A                       .
        .byte   $8B                             ; B8B5 8B                       .
        .byte   $82                             ; B8B6 82                       .
        .byte   $17                             ; B8B7 17                       .
        asl     $15,x                           ; B8B8 16 15                    ..
        asl     L0000,x                         ; B8BA 16 00                    ..
        .byte   $13                             ; B8BC 13                       .
        .byte   $62                             ; B8BD 62                       b
        .byte   $63                             ; B8BE 63                       c
        brk                                     ; B8BF 00                       .
        brk                                     ; B8C0 00                       .
        .byte   $14                             ; B8C1 14                       .
        brk                                     ; B8C2 00                       .
        brk                                     ; B8C3 00                       .
        brk                                     ; B8C4 00                       .
        brk                                     ; B8C5 00                       .
        sty     a:$8D                           ; B8C6 8C 8D 00                 ...
        brk                                     ; B8C9 00                       .
        brk                                     ; B8CA 00                       .
        brk                                     ; B8CB 00                       .
        .byte   $14                             ; B8CC 14                       .
        brk                                     ; B8CD 00                       .
        stx     $018F                           ; B8CE 8E 8F 01                 ...
        brk                                     ; B8D1 00                       .
        brk                                     ; B8D2 00                       .
        brk                                     ; B8D3 00                       .
        brk                                     ; B8D4 00                       .
        brk                                     ; B8D5 00                       .
        brk                                     ; B8D6 00                       .
        brk                                     ; B8D7 00                       .
        .byte   $03                             ; B8D8 03                       .
        brk                                     ; B8D9 00                       .
        brk                                     ; B8DA 00                       .
        brk                                     ; B8DB 00                       .
        brk                                     ; B8DC 00                       .
        brk                                     ; B8DD 00                       .
        brk                                     ; B8DE 00                       .
        brk                                     ; B8DF 00                       .
        ora     #$04                            ; B8E0 09 04                    ..
        brk                                     ; B8E2 00                       .
        brk                                     ; B8E3 00                       .
        ora     (L0000,x)                       ; B8E4 01 00                    ..
        brk                                     ; B8E6 00                       .
        brk                                     ; B8E7 00                       .
        .byte   $0F                             ; B8E8 0F                       .
        .byte   $0C                             ; B8E9 0C                       .
        bcc     LB87D                           ; B8EA 90 91                    ..
        ora     $9190                           ; B8EC 0D 90 91                 ...
        ora     $1792                           ; B8EF 0D 92 17                 ...
        brk                                     ; B8F2 00                       .
        brk                                     ; B8F3 00                       .
        .byte   $17                             ; B8F4 17                       .
        brk                                     ; B8F5 00                       .
        brk                                     ; B8F6 00                       .
        .byte   $93                             ; B8F7 93                       .
        sty     L0000,x                         ; B8F8 94 00                    ..
        brk                                     ; B8FA 00                       .
        brk                                     ; B8FB 00                       .
        brk                                     ; B8FC 00                       .
        brk                                     ; B8FD 00                       .
        brk                                     ; B8FE 00                       .
        sta     $33,x                           ; B8FF 95 33                    .3
        stx     $4D,y                           ; B901 96 4D                    .M
        lsr     L1615                           ; B903 4E 15 16                 N..
        .byte   $97                             ; B906 97                       .
        jmp     (L9633)                         ; B907 6C 33 96                 l3.

; ----------------------------------------------------------------------------
        stx     $988F                           ; B90A 8E 8F 98                 ...
        asl     $97,x                           ; B90D 16 97                    ..
        jmp     (L2314)                         ; B90F 6C 14 23                 l.#

; ----------------------------------------------------------------------------
        sta     $9823,y                         ; B912 99 23 98                 .#.
        asl     $97,x                           ; B915 16 97                    ..
        asl     $2600,x                         ; B917 1E 00 26                 ..&
        lsr     $26,x                           ; B91A 56 26                    V&
        tya                                     ; B91C 98                       .
        asl     $97,x                           ; B91D 16 97                    ..
        txs                                     ; B91F 9A                       .
        brk                                     ; B920 00                       .
        .byte   $42                             ; B921 42                       B
        lsr     $29,x                           ; B922 56 29                    V)
        .byte   $23                             ; B924 23                       #
        sta     $1E9B,y                         ; B925 99 9B 1E                 ...
        .byte   $0D                             ; B928 0D                       .
        .byte   $26                             ; B929 26                       &
LB92A:  lsr     $29,x                           ; B92A 56 29                    V)
        rol     $5B                             ; B92C 26 5B                    &[
        .byte   $9C                             ; B92E 9C                       .
        txs                                     ; B92F 9A                       .
        tya                                     ; B930 98                       .
        asl     $9D,x                           ; B931 16 9D                    ..
        tya                                     ; B933 98                       .
        asl     $33,x                           ; B934 16 33                    .3
        .byte   $9E                             ; B936 9E                       .
        asl     $9F98,x                         ; B937 1E 98 9F                 ...
        sta     $9F98,x                         ; B93A 9D 98 9F                 ...
        .byte   $33                             ; B93D 33                       3
        .byte   $9E                             ; B93E 9E                       .
        asl     LA1A0,x                         ; B93F 1E A0 A1                 ...
        ldx     #$50                            ; B942 A2 50                    .P
        asl     $1E9A,x                         ; B944 1E 9A 1E                 ...
        .byte   $1E,$95,$A3                     ; B947 1E 95 A3                 ...
        .byte   $23                             ; B94A 23                       #
        sta     $9A33,y                         ; B94B 99 33 9A                 .3.
        .byte   $1E,$1E,$A0                     ; B94E 1E 1E A0                 ...
        ldy     $A5                             ; B951 A4 A5                    ..
        lsr     $A6,x                           ; B953 56 A6                    V.
        ldx     $A7                             ; B955 A6 A7                    ..
        tay                                     ; B957 A8                       .
        sta     $A9,x                           ; B958 95 A9                    ..
        .byte   $3B                             ; B95A 3B                       ;
        lsr     $26,x                           ; B95B 56 26                    V&
        rol     $AA                             ; B95D 26 AA                    &.
        .byte   $AB                             ; B95F AB                       .
        ldy     #$A9                            ; B960 A0 A9                    ..
        .byte   $3B                             ; B962 3B                       ;
        lsr     $42,x                           ; B963 56 42                    VB
        and     #$AA                            ; B965 29 AA                    ).
        .byte   $AB                             ; B967 AB                       .
        txs                                     ; B968 9A                       .
        jmp     (LAC9A)                         ; B969 6C 9A AC                 l..

; ----------------------------------------------------------------------------
        rol     $29                             ; B96C 26 29                    &)
        lda     $34AE                           ; B96E AD AE 34                 ..4
        .byte   $34                             ; B971 34                       4
        sta     $9822,x                         ; B972 9D 22 98                 .".
        .byte   $9F                             ; B975 9F                       .
        .byte   $AF                             ; B976 AF                       .
        bcs     LB92A                           ; B977 B0 B1                    ..
        .byte   $B2                             ; B979 B2                       .
        .byte   $B3                             ; B97A B3                       .
        ldy     $15,x                           ; B97B B4 15                    ..
        lda     $B6,x                           ; B97D B5 B6                    ..
        .byte   $5C                             ; B97F 5C                       \
        asl     LB79A,x                         ; B980 1E 9A B7                 ...
        .byte   $34                             ; B983 34                       4
        stx     $01,y                           ; B984 96 01                    ..
        .byte   $14                             ; B986 14                       .
        brk                                     ; B987 00                       .
        asl     LB79A,x                         ; B988 1E 9A B7                 ...
        .byte   $34                             ; B98B 34                       4
        stx     L0000,y                         ; B98C 96 00                    ..
        brk                                     ; B98E 00                       .
        brk                                     ; B98F 00                       .
        clv                                     ; B990 B8                       .
        clv                                     ; B991 B8                       .
        lda     LBAB8,y                         ; B992 B9 B8 BA                 ...
        brk                                     ; B995 00                       .
        brk                                     ; B996 00                       .
        brk                                     ; B997 00                       .
        .byte   $BB                             ; B998 BB                       .
        .byte   $7B                             ; B999 7B                       {
        .byte   $7A                             ; B99A 7A                       z
        .byte   $7B                             ; B99B 7B                       {
        ldy     $0100,x                         ; B99C BC 00 01                 ...
        .byte   $02                             ; B99F 02                       .
        sta     $14,x                           ; B9A0 95 14                    ..
        brk                                     ; B9A2 00                       .
        brk                                     ; B9A3 00                       .
        brk                                     ; B9A4 00                       .
        brk                                     ; B9A5 00                       .
        brk                                     ; B9A6 00                       .
        brk                                     ; B9A7 00                       .
        bvc     LB9AA                           ; B9A8 50 00                    P.
LB9AA:  .byte   $14                             ; B9AA 14                       .
        .byte   $02                             ; B9AB 02                       .
        ora     (L0000,x)                       ; B9AC 01 00                    ..
        brk                                     ; B9AE 00                       .
        brk                                     ; B9AF 00                       .
        .byte   $BD,$BE,$A2                     ; B9B0 BD BE A2                 ...
        bvc     LB9D3                           ; B9B3 50 1E                    P.
        txs                                     ; B9B5 9A                       .
        asl     $9534,x                         ; B9B6 1E 34 95                 .4.
        .byte   $BF                             ; B9B9 BF                       .
        cpy     #$BD                            ; B9BA C0 BD                    ..
        brk                                     ; B9BC 00                       .
        cmp     (L0000,x)                       ; B9BD C1 00                    ..
        lda     a:L0000,x                       ; B9BF BD 00 00                 ...
        brk                                     ; B9C2 00                       .
        brk                                     ; B9C3 00                       .
        ora     ($14,x)                         ; B9C4 01 14                    ..
        brk                                     ; B9C6 00                       .
        ora     (L0000,x)                       ; B9C7 01 00                    ..
        brk                                     ; B9C9 00                       .
        .byte   $02                             ; B9CA 02                       .
        brk                                     ; B9CB 00                       .
        brk                                     ; B9CC 00                       .
        brk                                     ; B9CD 00                       .
        brk                                     ; B9CE 00                       .
        .byte   $C2                             ; B9CF C2                       .
        brk                                     ; B9D0 00                       .
        brk                                     ; B9D1 00                       .
        .byte   $C3                             ; B9D2 C3                       .
LB9D3:  ora     (L0000,x)                       ; B9D3 01 00                    ..
        brk                                     ; B9D5 00                       .
        brk                                     ; B9D6 00                       .
        .byte   $14                             ; B9D7 14                       .
        brk                                     ; B9D8 00                       .
        brk                                     ; B9D9 00                       .
        brk                                     ; B9DA 00                       .
        brk                                     ; B9DB 00                       .
        .byte   $02                             ; B9DC 02                       .
        ora     (L0000,x)                       ; B9DD 01 00                    ..
        ror     $0100                           ; B9DF 6E 00 01                 n..
        .byte   $02                             ; B9E2 02                       .
        brk                                     ; B9E3 00                       .
        brk                                     ; B9E4 00                       .
        brk                                     ; B9E5 00                       .
        brk                                     ; B9E6 00                       .
        .byte   $C2                             ; B9E7 C2                       .
        brk                                     ; B9E8 00                       .
        brk                                     ; B9E9 00                       .
        brk                                     ; B9EA 00                       .
        brk                                     ; B9EB 00                       .
        .byte   $14                             ; B9EC 14                       .
        brk                                     ; B9ED 00                       .
        brk                                     ; B9EE 00                       .
        brk                                     ; B9EF 00                       .
        asl     a:$C4,x                         ; B9F0 1E C4 00                 ...
        brk                                     ; B9F3 00                       .
        brk                                     ; B9F4 00                       .
        brk                                     ; B9F5 00                       .
        brk                                     ; B9F6 00                       .
        brk                                     ; B9F7 00                       .
        brk                                     ; B9F8 00                       .
        brk                                     ; B9F9 00                       .
        brk                                     ; B9FA 00                       .
        brk                                     ; B9FB 00                       .
        brk                                     ; B9FC 00                       .
        brk                                     ; B9FD 00                       .
        brk                                     ; B9FE 00                       .
        brk                                     ; B9FF 00                       .
        brk                                     ; BA00 00                       .
        brk                                     ; BA01 00                       .
        brk                                     ; BA02 00                       .
        brk                                     ; BA03 00                       .
        ora     (L0000,x)                       ; BA04 01 00                    ..
        brk                                     ; BA06 00                       .
        brk                                     ; BA07 00                       .
        cmp     L0000                           ; BA08 C5 00                    ..
        brk                                     ; BA0A 00                       .
        .byte   $14                             ; BA0B 14                       .
        brk                                     ; BA0C 00                       .
        brk                                     ; BA0D 00                       .
        .byte   $02                             ; BA0E 02                       .
        ora     ($01,x)                         ; BA0F 01 01                    ..
        brk                                     ; BA11 00                       .
        brk                                     ; BA12 00                       .
        brk                                     ; BA13 00                       .
        brk                                     ; BA14 00                       .
        .byte   $02                             ; BA15 02                       .
        brk                                     ; BA16 00                       .
        brk                                     ; BA17 00                       .
        .byte   $6F                             ; BA18 6F                       o
        brk                                     ; BA19 00                       .
        brk                                     ; BA1A 00                       .
        brk                                     ; BA1B 00                       .
        dec     L0000                           ; BA1C C6 00                    ..
        dec     L0000                           ; BA1E C6 00                    ..
        cmp     L0000                           ; BA20 C5 00                    ..
        brk                                     ; BA22 00                       .
        brk                                     ; BA23 00                       .
        brk                                     ; BA24 00                       .
        brk                                     ; BA25 00                       .
        brk                                     ; BA26 00                       .
        brk                                     ; BA27 00                       .
        brk                                     ; BA28 00                       .
        brk                                     ; BA29 00                       .
        brk                                     ; BA2A 00                       .
        brk                                     ; BA2B 00                       .
        brk                                     ; BA2C 00                       .
        brk                                     ; BA2D 00                       .
        brk                                     ; BA2E 00                       .
        brk                                     ; BA2F 00                       .
        brk                                     ; BA30 00                       .
        brk                                     ; BA31 00                       .
        brk                                     ; BA32 00                       .
        .byte   $14                             ; BA33 14                       .
        brk                                     ; BA34 00                       .
        brk                                     ; BA35 00                       .
        brk                                     ; BA36 00                       .
        .byte   $14                             ; BA37 14                       .
        brk                                     ; BA38 00                       .
        brk                                     ; BA39 00                       .
        brk                                     ; BA3A 00                       .
        brk                                     ; BA3B 00                       .
        brk                                     ; BA3C 00                       .
        brk                                     ; BA3D 00                       .
        brk                                     ; BA3E 00                       .
        ora     (L0000,x)                       ; BA3F 01 00                    ..
        .byte   $02                             ; BA41 02                       .
        brk                                     ; BA42 00                       .
        brk                                     ; BA43 00                       .
        .byte   $C3                             ; BA44 C3                       .
        brk                                     ; BA45 00                       .
        brk                                     ; BA46 00                       .
        brk                                     ; BA47 00                       .
        .byte   $02                             ; BA48 02                       .
        .byte   $C3                             ; BA49 C3                       .
        ora     (L0000,x)                       ; BA4A 01 00                    ..
        brk                                     ; BA4C 00                       .
        brk                                     ; BA4D 00                       .
        .byte   $02                             ; BA4E 02                       .
        brk                                     ; BA4F 00                       .
        ora     (L0000,x)                       ; BA50 01 00                    ..
        brk                                     ; BA52 00                       .
        brk                                     ; BA53 00                       .
        brk                                     ; BA54 00                       .
        brk                                     ; BA55 00                       .
        brk                                     ; BA56 00                       .
        ora     (L0000,x)                       ; BA57 01 00                    ..
        brk                                     ; BA59 00                       .
        brk                                     ; BA5A 00                       .
        brk                                     ; BA5B 00                       .
        brk                                     ; BA5C 00                       .
        brk                                     ; BA5D 00                       .
        brk                                     ; BA5E 00                       .
        brk                                     ; BA5F 00                       .
        brk                                     ; BA60 00                       .
        brk                                     ; BA61 00                       .
        brk                                     ; BA62 00                       .
        brk                                     ; BA63 00                       .
        .byte   $C7                             ; BA64 C7                       .
        brk                                     ; BA65 00                       .
        .byte   $C7                             ; BA66 C7                       .
        brk                                     ; BA67 00                       .
        .byte   $02                             ; BA68 02                       .
        brk                                     ; BA69 00                       .
        brk                                     ; BA6A 00                       .
        iny                                     ; BA6B C8                       .
        cmp     #$C9                            ; BA6C C9 C9                    ..
        dec     $C6                             ; BA6E C6 C6                    ..
        brk                                     ; BA70 00                       .
        ora     (L0000,x)                       ; BA71 01 00                    ..
        brk                                     ; BA73 00                       .
        brk                                     ; BA74 00                       .
        brk                                     ; BA75 00                       .
        brk                                     ; BA76 00                       .
        dex                                     ; BA77 CA                       .
        brk                                     ; BA78 00                       .
        brk                                     ; BA79 00                       .
        brk                                     ; BA7A 00                       .
        brk                                     ; BA7B 00                       .
        brk                                     ; BA7C 00                       .
        brk                                     ; BA7D 00                       .
        brk                                     ; BA7E 00                       .
        brk                                     ; BA7F 00                       .
        ora     (L0000,x)                       ; BA80 01 00                    ..
        brk                                     ; BA82 00                       .
        brk                                     ; BA83 00                       .
        .byte   $14                             ; BA84 14                       .
        .byte   $C3                             ; BA85 C3                       .
        brk                                     ; BA86 00                       .
        brk                                     ; BA87 00                       .
        brk                                     ; BA88 00                       .
        .byte   $CB                             ; BA89 CB                       .
        .byte   $C3                             ; BA8A C3                       .
        .byte   $02                             ; BA8B 02                       .
        ora     (L0000,x)                       ; BA8C 01 00                    ..
        brk                                     ; BA8E 00                       .
        brk                                     ; BA8F 00                       .
LBA90:  brk                                     ; BA90 00                       .
        .byte   $02                             ; BA91 02                       .
        brk                                     ; BA92 00                       .
        brk                                     ; BA93 00                       .
        .byte   $14                             ; BA94 14                       .
        brk                                     ; BA95 00                       .
        brk                                     ; BA96 00                       .
        brk                                     ; BA97 00                       .
        brk                                     ; BA98 00                       .
        brk                                     ; BA99 00                       .
        brk                                     ; BA9A 00                       .
        brk                                     ; BA9B 00                       .
        .byte   $02                             ; BA9C 02                       .
        brk                                     ; BA9D 00                       .
LBA9E:  brk                                     ; BA9E 00                       .
        brk                                     ; BA9F 00                       .
        .byte   $C7                             ; BAA0 C7                       .
        brk                                     ; BAA1 00                       .
        .byte   $C7                             ; BAA2 C7                       .
        brk                                     ; BAA3 00                       .
        brk                                     ; BAA4 00                       .
        brk                                     ; BAA5 00                       .
        brk                                     ; BAA6 00                       .
        brk                                     ; BAA7 00                       .
        cmp     #$C9                            ; BAA8 C9 C9                    ..
        cmp     #$C8                            ; BAAA C9 C8                    ..
        cmp     #$C9                            ; BAAC C9 C9                    ..
        cpy     a:L0000                         ; BAAE CC 00 00                 ...
        brk                                     ; BAB1 00                       .
        iny                                     ; BAB2 C8                       .
        cmp     $CE00                           ; BAB3 CD 00 CE                 ...
        .byte   $CF                             ; BAB6 CF                       .
        .byte   $A0                             ; BAB7 A0                       .
LBAB8:  brk                                     ; BAB8 00                       .
        brk                                     ; BAB9 00                       .
        brk                                     ; BABA 00                       .
        brk                                     ; BABB 00                       .
        brk                                     ; BABC 00                       .
        bne     LBA90                           ; BABD D0 D1                    ..
        sta     $50,x                           ; BABF 95 50                    .P
        asl     $341E,x                         ; BAC1 1E 1E 34                 ..4
        asl     $D3D2,x                         ; BAC4 1E D2 D3                 ...
        cmp     ($C1,x)                         ; BAC7 C1 C1                    ..
        .byte   $02                             ; BAC9 02                       .
        .byte   $14                             ; BACA 14                       .
        .byte   $02                             ; BACB 02                       .
        brk                                     ; BACC 00                       .
        .byte   $CE,$D3,$A0                     ; BACD CE D3 A0                 ...
        cmp     ($03,x)                         ; BAD0 C1 03                    ..
        brk                                     ; BAD2 00                       .
        ora     (L0000,x)                       ; BAD3 01 00                    ..
        brk                                     ; BAD5 00                       .
        brk                                     ; BAD6 00                       .
        sta     $50,x                           ; BAD7 95 50                    .P
        ora     #$04                            ; BAD9 09 04                    ..
        brk                                     ; BADB 00                       .
        brk                                     ; BADC 00                       .
        ora     (L0000,x)                       ; BADD 01 00                    ..
        bvc     LBA9E                           ; BADF 50 BD                    P.
        .byte   $0F                             ; BAE1 0F                       .
        .byte   $0C                             ; BAE2 0C                       .
LBAE3:  ora     $0D0D                           ; BAE3 0D 0D 0D                 ...
        ora     $95BD                           ; BAE6 0D BD 95                 ...
        .byte   $D4                             ; BAE9 D4                       .
        cmp     $D6,x                           ; BAEA D5 D6                    ..
        pla                                     ; BAEC 68                       h
        dec     $68,x                           ; BAED D6 68                    .h
        .byte   $D7                             ; BAEF D7                       .
        cmp     ($60,x)                         ; BAF0 C1 60                    .`
        cld                                     ; BAF2 D8                       .
        .byte   $6C                             ; BAF3 6C                       l
LBAF4:  txs                                     ; BAF4 9A                       .
        txs                                     ; BAF5 9A                       .
        txs                                     ; BAF6 9A                       .
        jmp     (L5FC1)                         ; BAF7 6C C1 5F                 l._

; ----------------------------------------------------------------------------
        cmp     LB144,y                         ; BAFA D9 44 B1                 .D.
        .byte   $44                             ; BAFD 44                       D
        lda     ($44),y                         ; BAFE B1 44                    .D
        cmp     ($60,x)                         ; BB00 C1 60                    .`
        cld                                     ; BB02 D8                       .
        sta     $9F98,x                         ; BB03 9D 98 9F                 ...
        sta     $C198,x                         ; BB06 9D 98 C1                 ...
        .byte   $5F                             ; BB09 5F                       _
        cld                                     ; BB0A D8                       .
        sta     LB598,x                         ; BB0B 9D 98 B5                 ...
        sta     $C198,x                         ; BB0E 9D 98 C1                 ...
        .byte   $5F                             ; BB11 5F                       _
        brk                                     ; BB12 00                       .
        brk                                     ; BB13 00                       .
        .byte   $23                             ; BB14 23                       #
        sta     $2323,y                         ; BB15 99 23 23                 .##
        cmp     ($64,x)                         ; BB18 C1 64                    .d
        .byte   $64                             ; BB1A 64                       d
        .byte   $5F                             ; BB1B 5F                       _
        rol     $56                             ; BB1C 26 56                    &V
        rol     $26                             ; BB1E 26 26                    &&
        cmp     ($60,x)                         ; BB20 C1 60                    .`
        .byte   $64                             ; BB22 64                       d
        .byte   $64                             ; BB23 64                       d
        and     #$56                            ; BB24 29 56                    )V
        and     #$29                            ; BB26 29 29                    ))
        asl     L0000,x                         ; BB28 16 00                    ..
        .byte   $64                             ; BB2A 64                       d
        brk                                     ; BB2B 00                       .
        .byte   $42                             ; BB2C 42                       B
        lsr     $42,x                           ; BB2D 56 42                    VB
        .byte   $42                             ; BB2F 42                       B
        asl     $98,x                           ; BB30 16 98                    ..
        asl     $9D,x                           ; BB32 16 9D                    ..
        .byte   $DA                             ; BB34 DA                       .
        .byte   $DB                             ; BB35 DB                       .
        sta     $9F98,x                         ; BB36 9D 98 9F                 ...
        tya                                     ; BB39 98                       .
        .byte   $9F                             ; BB3A 9F                       .
        sta     $DBDA,x                         ; BB3B 9D DA DB                 ...
        sta     $9F98,x                         ; BB3E 9D 98 9F                 ...
        sta     $9F98,x                         ; BB41 9D 98 9F                 ...
        cmp     ($BD,x)                         ; BB44 C1 BD                    ..
        sta     LB5BD,x                         ; BB46 9D BD B5                 ...
        sta     LB598,x                         ; BB49 9D 98 B5                 ...
        bvc     LBAE3                           ; BB4C 50 95                    P.
        sta     $2395,x                         ; BB4E 9D 95 23                 ..#
        .byte   $23                             ; BB51 23                       #
        sta     $2323,y                         ; BB52 99 23 23                 .##
        bvc     LBAF4                           ; BB55 50 9D                    P.
        bvc     LBB7F                           ; BB57 50 26                    P&
        rol     $56                             ; BB59 26 56                    &V
        rol     $26                             ; BB5B 26 26                    &&
        .byte   $23                             ; BB5D 23                       #
        .byte   $23                             ; BB5E 23                       #
        .byte   $23                             ; BB5F 23                       #
        and     #$29                            ; BB60 29 29                    ))
        lsr     $29,x                           ; BB62 56 29                    V)
        and     #$26                            ; BB64 29 26                    )&
        rol     $26                             ; BB66 26 26                    &&
        .byte   $42                             ; BB68 42                       B
        .byte   $42                             ; BB69 42                       B
        lsr     $42,x                           ; BB6A 56 42                    VB
        .byte   $42                             ; BB6C 42                       B
        and     #$29                            ; BB6D 29 29                    ))
        and     #$16                            ; BB6F 29 16                    ).
        sta     $1698,x                         ; BB71 9D 98 16                 ...
        .byte   $DC                             ; BB74 DC                       .
        cmp     $2DDE,x                         ; BB75 DD DE 2D                 ..-
        .byte   $9F                             ; BB78 9F                       .
        sta     $9F98,x                         ; BB79 9D 98 9F                 ...
        brk                                     ; BB7C 00                       .
        .byte   $DF                             ; BB7D DF                       .
        .byte   $E0                             ; BB7E E0                       .
LBB7F:  tya                                     ; BB7F 98                       .
        tya                                     ; BB80 98                       .
        asl     $E1,x                           ; BB81 16 E1                    ..
        rol     $26                             ; BB83 26 26                    &&
LBB85:  rol     $E2                             ; BB85 26 E2                    &.
        lda     $1F33,x                         ; BB87 BD 33 1F                 .3.
        sbc     ($29,x)                         ; BB8A E1 29                    .)
        and     #$29                            ; BB8C 29 29                    ))
        .byte   $E2                             ; BB8E E2                       .
        sta     $33,x                           ; BB8F 95 33                    .3
        .byte   $1F                             ; BB91 1F                       .
        .byte   $E3                             ; BB92 E3                       .
        and     #$29                            ; BB93 29 29                    ))
        and     #$E4                            ; BB95 29 E4                    ).
        tya                                     ; BB97 98                       .
        .byte   $23                             ; BB98 23                       #
        .byte   $23                             ; BB99 23                       #
        .byte   $E3                             ; BB9A E3                       .
        and     #$29                            ; BB9B 29 29                    ))
        and     #$E5                            ; BB9D 29 E5                    ).
        asl     $26,x                           ; BB9F 16 26                    .&
        rol     $E1                             ; BBA1 26 E1                    &.
        and     #$29                            ; BBA3 29 29                    ))
        sbc     $16                             ; BBA5 E5 16                    ..
        ora     $29,x                           ; BBA7 15 29                    .)
        and     #$E1                            ; BBA9 29 E1                    ).
        and     #$E5                            ; BBAB 29 E5                    ).
        .byte   $9F                             ; BBAD 9F                       .
        tya                                     ; BBAE 98                       .
        asl     $2D,x                           ; BBAF 16 2D                    .-
        and     $2DE6                           ; BBB1 2D E6 2D                 -.-
        ora     $E7,x                           ; BBB4 15 E7                    ..
        tya                                     ; BBB6 98                       .
        asl     $9F,x                           ; BBB7 16 9F                    ..
        tya                                     ; BBB9 98                       .
        .byte   $9F                             ; BBBA 9F                       .
        tya                                     ; BBBB 98                       .
        .byte   $9F                             ; BBBC 9F                       .
        inx                                     ; BBBD E8                       .
        asl     $98,x                           ; BBBE 16 98                    ..
        .byte   $BD                             ; BBC0 BD                       .
LBBC1:  sbc     #$B7                            ; BBC1 E9 B7                    ..
        .byte   $B7                             ; BBC3 B7                       .
        .byte   $B7                             ; BBC4 B7                       .
        .byte   $B7                             ; BBC5 B7                       .
        bvc     LBB85                           ; BBC6 50 BD                    P.
        nop                                     ; BBC8 EA                       .
        .byte   $EB                             ; BBC9 EB                       .
        .byte   $23                             ; BBCA 23                       #
LBBCB:  .byte   $23                             ; BBCB 23                       #
        .byte   $23                             ; BBCC 23                       #
        .byte   $23                             ; BBCD 23                       #
LBBCE:  cpx     LBD95                           ; BBCE EC 95 BD                 ...
        sbc     $2626                           ; BBD1 ED 26 26                 .&&
        rol     $26                             ; BBD4 26 26                    &&
        and     #$C1                            ; BBD6 29 C1                    ).
        sta     $ED,x                           ; BBD8 95 ED                    ..
        and     #$29                            ; BBDA 29 29                    ))
        and     #$29                            ; BBDC 29 29                    ))
        and     #$C1                            ; BBDE 29 C1                    ).
        lda     $EEE1,x                         ; BBE0 BD E1 EE                 ...
        inc     $EEEE                           ; BBE3 EE EE EE                 ...
        .byte   $EF                             ; BBE6 EF                       .
        lda     $E195,x                         ; BBE7 BD 95 E1                 ...
        beq     LBC0F                           ; BBEA F0 23                    .#
        .byte   $23                             ; BBEC 23                       #
        .byte   $23                             ; BBED 23                       #
        sbc     ($95),y                         ; BBEE F1 95                    ..
        tya                                     ; BBF0 98                       .
        .byte   $9F                             ; BBF1 9F                       .
        sbc     ($26,x)                         ; BBF2 E1 26                    .&
        rol     $26                             ; BBF4 26 26                    &&
        .byte   $E2                             ; BBF6 E2                       .
        cmp     ($15,x)                         ; BBF7 C1 15                    ..
        lda     $E3,x                           ; BBF9 B5 E3                    ..
        and     #$29                            ; BBFB 29 29                    ))
        and     #$E2                            ; BBFD 29 E2                    ).
        cmp     ($95,x)                         ; BBFF C1 95                    ..
        brk                                     ; BC01 00                       .
        brk                                     ; BC02 00                       .
        .byte   $C3                             ; BC03 C3                       .
        brk                                     ; BC04 00                       .
        brk                                     ; BC05 00                       .
        brk                                     ; BC06 00                       .
        brk                                     ; BC07 00                       .
        bvc     LBC0C                           ; BC08 50 02                    P.
        brk                                     ; BC0A 00                       .
        brk                                     ; BC0B 00                       .
LBC0C:  ora     (L0000,x)                       ; BC0C 01 00                    ..
        .byte   $C3                             ; BC0E C3                       .
LBC0F:  brk                                     ; BC0F 00                       .
        lda     a:L0000,x                       ; BC10 BD 00 00                 ...
        ora     ($02,x)                         ; BC13 01 02                    ..
        brk                                     ; BC15 00                       .
        ora     (L0000,x)                       ; BC16 01 00                    ..
        nop                                     ; BC18 EA                       .
        .byte   $F2                             ; BC19 F2                       .
        .byte   $73                             ; BC1A 73                       s
        brk                                     ; BC1B 00                       .
        brk                                     ; BC1C 00                       .
        brk                                     ; BC1D 00                       .
        brk                                     ; BC1E 00                       .
        brk                                     ; BC1F 00                       .
        lda     $F4F3,x                         ; BC20 BD F3 F4                 ...
        .byte   $73                             ; BC23 73                       s
        brk                                     ; BC24 00                       .
        brk                                     ; BC25 00                       .
        brk                                     ; BC26 00                       .
        .byte   $C3                             ; BC27 C3                       .
        nop                                     ; BC28 EA                       .
        .byte   $F3                             ; BC29 F3                       .
        .byte   $F4                             ; BC2A F4                       .
        .byte   $F4                             ; BC2B F4                       .
        bvc     LBBC1                           ; BC2C 50 93                    P.
        .byte   $93                             ; BC2E 93                       .
        brk                                     ; BC2F 00                       .
        lda     $F4F3,x                         ; BC30 BD F3 F4                 ...
        .byte   $F4                             ; BC33 F4                       .
        bvc     LBBCB                           ; BC34 50 95                    P.
        nop                                     ; BC36 EA                       .
        bvc     LBBCE                           ; BC37 50 95                    P.
        .byte   $F3                             ; BC39 F3                       .
        .byte   $F4                             ; BC3A F4                       .
        .byte   $F4                             ; BC3B F4                       .
        cmp     ($C1,x)                         ; BC3C C1 C1                    ..
        .byte   $4F                             ; BC3E 4F                       O
        .byte   $4F                             ; BC3F 4F                       O
        brk                                     ; BC40 00                       .
        brk                                     ; BC41 00                       .
        brk                                     ; BC42 00                       .
        brk                                     ; BC43 00                       .
        brk                                     ; BC44 00                       .
        .byte   $02                             ; BC45 02                       .
        brk                                     ; BC46 00                       .
        .byte   $C3                             ; BC47 C3                       .
        brk                                     ; BC48 00                       .
        brk                                     ; BC49 00                       .
        ora     ($C3,x)                         ; BC4A 01 C3                    ..
        brk                                     ; BC4C 00                       .
        ora     (L0000,x)                       ; BC4D 01 00                    ..
        brk                                     ; BC4F 00                       .
        brk                                     ; BC50 00                       .
        brk                                     ; BC51 00                       .
        .byte   $02                             ; BC52 02                       .
        brk                                     ; BC53 00                       .
        ora     (L0000,x)                       ; BC54 01 00                    ..
        .byte   $C3                             ; BC56 C3                       .
        .byte   $02                             ; BC57 02                       .
        .byte   $C3                             ; BC58 C3                       .
        brk                                     ; BC59 00                       .
        brk                                     ; BC5A 00                       .
        brk                                     ; BC5B 00                       .
        brk                                     ; BC5C 00                       .
        brk                                     ; BC5D 00                       .
        .byte   $02                             ; BC5E 02                       .
        brk                                     ; BC5F 00                       .
        ora     (L0000,x)                       ; BC60 01 00                    ..
        brk                                     ; BC62 00                       .
        brk                                     ; BC63 00                       .
        .byte   $02                             ; BC64 02                       .
        brk                                     ; BC65 00                       .
        ora     (L0000,x)                       ; BC66 01 00                    ..
        brk                                     ; BC68 00                       .
        brk                                     ; BC69 00                       .
        brk                                     ; BC6A 00                       .
        brk                                     ; BC6B 00                       .
        brk                                     ; BC6C 00                       .
        brk                                     ; BC6D 00                       .
        brk                                     ; BC6E 00                       .
        brk                                     ; BC6F 00                       .
        .byte   $33                             ; BC70 33                       3
        .byte   $1F                             ; BC71 1F                       .
        brk                                     ; BC72 00                       .
        brk                                     ; BC73 00                       .
        brk                                     ; BC74 00                       .
        brk                                     ; BC75 00                       .
        brk                                     ; BC76 00                       .
        brk                                     ; BC77 00                       .
        .byte   $33                             ; BC78 33                       3
        .byte   $1F                             ; BC79 1F                       .
        brk                                     ; BC7A 00                       .
        brk                                     ; BC7B 00                       .
        brk                                     ; BC7C 00                       .
        brk                                     ; BC7D 00                       .
        brk                                     ; BC7E 00                       .
        brk                                     ; BC7F 00                       .
        brk                                     ; BC80 00                       .
        brk                                     ; BC81 00                       .
        brk                                     ; BC82 00                       .
        brk                                     ; BC83 00                       .
        ora     (L0000,x)                       ; BC84 01 00                    ..
        brk                                     ; BC86 00                       .
        brk                                     ; BC87 00                       .
        brk                                     ; BC88 00                       .
        brk                                     ; BC89 00                       .
        brk                                     ; BC8A 00                       .
        brk                                     ; BC8B 00                       .
        brk                                     ; BC8C 00                       .
        brk                                     ; BC8D 00                       .
        .byte   $02                             ; BC8E 02                       .
        brk                                     ; BC8F 00                       .
        brk                                     ; BC90 00                       .
        brk                                     ; BC91 00                       .
        brk                                     ; BC92 00                       .
        brk                                     ; BC93 00                       .
        .byte   $02                             ; BC94 02                       .
        brk                                     ; BC95 00                       .
        sbc     $C3,x                           ; BC96 F5 C3                    ..
        brk                                     ; BC98 00                       .
        .byte   $02                             ; BC99 02                       .
        brk                                     ; BC9A 00                       .
        brk                                     ; BC9B 00                       .
        brk                                     ; BC9C 00                       .
        brk                                     ; BC9D 00                       .
        brk                                     ; BC9E 00                       .
        .byte   $14                             ; BC9F 14                       .
        brk                                     ; BCA0 00                       .
        brk                                     ; BCA1 00                       .
        brk                                     ; BCA2 00                       .
        brk                                     ; BCA3 00                       .
        brk                                     ; BCA4 00                       .
        brk                                     ; BCA5 00                       .
        brk                                     ; BCA6 00                       .
        brk                                     ; BCA7 00                       .
        brk                                     ; BCA8 00                       .
        brk                                     ; BCA9 00                       .
        brk                                     ; BCAA 00                       .
        brk                                     ; BCAB 00                       .
        brk                                     ; BCAC 00                       .
        brk                                     ; BCAD 00                       .
        brk                                     ; BCAE 00                       .
        brk                                     ; BCAF 00                       .
        brk                                     ; BCB0 00                       .
        brk                                     ; BCB1 00                       .
        brk                                     ; BCB2 00                       .
        brk                                     ; BCB3 00                       .
        brk                                     ; BCB4 00                       .
        ora     (L0000,x)                       ; BCB5 01 00                    ..
        brk                                     ; BCB7 00                       .
        brk                                     ; BCB8 00                       .
        brk                                     ; BCB9 00                       .
        brk                                     ; BCBA 00                       .
        brk                                     ; BCBB 00                       .
        brk                                     ; BCBC 00                       .
        brk                                     ; BCBD 00                       .
        .byte   $C3                             ; BCBE C3                       .
        .byte   $02                             ; BCBF 02                       .
        brk                                     ; BCC0 00                       .
        .byte   $C3                             ; BCC1 C3                       .
        .byte   $02                             ; BCC2 02                       .
        brk                                     ; BCC3 00                       .
        sty     $98,x                           ; BCC4 94 98                    ..
        asl     $98,x                           ; BCC6 16 98                    ..
        .byte   $02                             ; BCC8 02                       .
        brk                                     ; BCC9 00                       .
        brk                                     ; BCCA 00                       .
        .byte   $14                             ; BCCB 14                       .
        brk                                     ; BCCC 00                       .
        brk                                     ; BCCD 00                       .
        brk                                     ; BCCE 00                       .
        tya                                     ; BCCF 98                       .
        brk                                     ; BCD0 00                       .
        ora     (L0000,x)                       ; BCD1 01 00                    ..
        brk                                     ; BCD3 00                       .
        brk                                     ; BCD4 00                       .
        brk                                     ; BCD5 00                       .
        brk                                     ; BCD6 00                       .
        tya                                     ; BCD7 98                       .
        brk                                     ; BCD8 00                       .
        brk                                     ; BCD9 00                       .
        brk                                     ; BCDA 00                       .
        brk                                     ; BCDB 00                       .
        brk                                     ; BCDC 00                       .
        ora     (L0000,x)                       ; BCDD 01 00                    ..
        ora     $02,x                           ; BCDF 15 02                    ..
        brk                                     ; BCE1 00                       .
        brk                                     ; BCE2 00                       .
        brk                                     ; BCE3 00                       .
        brk                                     ; BCE4 00                       .
        brk                                     ; BCE5 00                       .
        brk                                     ; BCE6 00                       .
        inc     L0000,x                         ; BCE7 F6 00                    ..
        brk                                     ; BCE9 00                       .
        brk                                     ; BCEA 00                       .
        brk                                     ; BCEB 00                       .
        brk                                     ; BCEC 00                       .
        brk                                     ; BCED 00                       .
        brk                                     ; BCEE 00                       .
        .byte   $F7                             ; BCEF F7                       .
        brk                                     ; BCF0 00                       .
        brk                                     ; BCF1 00                       .
        brk                                     ; BCF2 00                       .
        brk                                     ; BCF3 00                       .
        .byte   $92                             ; BCF4 92                       .
        tya                                     ; BCF5 98                       .
        bmi     LBD09                           ; BCF6 30 11                    0.
        brk                                     ; BCF8 00                       .
        brk                                     ; BCF9 00                       .
        brk                                     ; BCFA 00                       .
        brk                                     ; BCFB 00                       .
        sty     $98,x                           ; BCFC 94 98                    ..
        and     ($13),y                         ; BCFE 31 13                    1.
        .byte   $E7                             ; BD00 E7                       .
        sed                                     ; BD01 F8                       .
        sbc     $9F15,y                         ; BD02 F9 15 9F                 ...
        sed                                     ; BD05 F8                       .
        sbc     $E798,y                         ; BD06 F9 98 E7                 ...
LBD09:  sed                                     ; BD09 F8                       .
        sbc     $E798,y                         ; BD0A F9 98 E7                 ...
        sed                                     ; BD0D F8                       .
        sbc     $E715,y                         ; BD0E F9 15 E7                 ...
        sed                                     ; BD11 F8                       .
        sbc     $E715,y                         ; BD12 F9 15 E7                 ...
        sed                                     ; BD15 F8                       .
        sbc     LB515,y                         ; BD16 F9 15 B5                 ...
        sed                                     ; BD19 F8                       .
        sbc     LB598,y                         ; BD1A F9 98 B5                 ...
        sed                                     ; BD1D F8                       .
        sbc     $3815,y                         ; BD1E F9 15 38                 ..8
        sec                                     ; BD21 38                       8
        sec                                     ; BD22 38                       8
        sec                                     ; BD23 38                       8
        sec                                     ; BD24 38                       8
        sec                                     ; BD25 38                       8
        sec                                     ; BD26 38                       8
        inc     $26,x                           ; BD27 F6 26                    .&
        .byte   $FA                             ; BD29 FA                       .
        rol     $26                             ; BD2A 26 26                    &&
        .byte   $FA                             ; BD2C FA                       .
        rol     $26                             ; BD2D 26 26                    &&
        .byte   $F7                             ; BD2F F7                       .
        .byte   $44                             ; BD30 44                       D
        ror     a                               ; BD31 6A                       j
        .byte   $44                             ; BD32 44                       D
        ror     a                               ; BD33 6A                       j
        .byte   $44                             ; BD34 44                       D
        ror     a                               ; BD35 6A                       j
        .byte   $44                             ; BD36 44                       D
        tya                                     ; BD37 98                       .
        .byte   $12                             ; BD38 12                       .
        .byte   $13                             ; BD39 13                       .
        .byte   $12                             ; BD3A 12                       .
        .byte   $13                             ; BD3B 13                       .
        .byte   $12                             ; BD3C 12                       .
        .byte   $13                             ; BD3D 13                       .
        .byte   $12                             ; BD3E 12                       .
        tya                                     ; BD3F 98                       .
        lda     $98,x                           ; BD40 B5 98                    ..
        lda     $98,x                           ; BD42 B5 98                    ..
        lda     $98,x                           ; BD44 B5 98                    ..
        lda     $98,x                           ; BD46 B5 98                    ..
        .byte   $FB                             ; BD48 FB                       .
        .byte   $23                             ; BD49 23                       #
        .byte   $23                             ; BD4A 23                       #
        .byte   $23                             ; BD4B 23                       #
        .byte   $23                             ; BD4C 23                       #
        .byte   $23                             ; BD4D 23                       #
        .byte   $23                             ; BD4E 23                       #
        plp                                     ; BD4F 28                       (
        eor     ($26,x)                         ; BD50 41 26                    A&
        rol     $FA                             ; BD52 26 FA                    &.
        rol     $26                             ; BD54 26 26                    &&
        rol     $2A                             ; BD56 26 2A                    &*
        eor     ($29,x)                         ; BD58 41 29                    A)
        .byte   $42                             ; BD5A 42                       B
        rol     $29                             ; BD5B 26 29                    &)
        .byte   $42                             ; BD5D 42                       B
        and     #$2A                            ; BD5E 29 2A                    )*
        .byte   $FC                             ; BD60 FC                       .
        and     #$26                            ; BD61 29 26                    )&
        and     #$29                            ; BD63 29 29                    ))
        rol     $29                             ; BD65 26 29                    &)
        rol     a                               ; BD67 2A                       *
        and     #$29                            ; BD68 29 29                    ))
        and     #$29                            ; BD6A 29 29                    ))
        and     #$29                            ; BD6C 29 29                    ))
        and     #$2A                            ; BD6E 29 2A                    )*
        .byte   $9F                             ; BD70 9F                       .
        tya                                     ; BD71 98                       .
        .byte   $9F                             ; BD72 9F                       .
        tya                                     ; BD73 98                       .
        .byte   $9F                             ; BD74 9F                       .
        tya                                     ; BD75 98                       .
        .byte   $9F                             ; BD76 9F                       .
        tya                                     ; BD77 98                       .
        .byte   $E7                             ; BD78 E7                       .
        tya                                     ; BD79 98                       .
        .byte   $E7                             ; BD7A E7                       .
        tya                                     ; BD7B 98                       .
        .byte   $E7                             ; BD7C E7                       .
        tya                                     ; BD7D 98                       .
        .byte   $E7                             ; BD7E E7                       .
        tya                                     ; BD7F 98                       .
        brk                                     ; BD80 00                       .
        brk                                     ; BD81 00                       .
        brk                                     ; BD82 00                       .
        brk                                     ; BD83 00                       .
        brk                                     ; BD84 00                       .
        brk                                     ; BD85 00                       .
        brk                                     ; BD86 00                       .
        brk                                     ; BD87 00                       .
        brk                                     ; BD88 00                       .
        brk                                     ; BD89 00                       .
        brk                                     ; BD8A 00                       .
        brk                                     ; BD8B 00                       .
        brk                                     ; BD8C 00                       .
        brk                                     ; BD8D 00                       .
        brk                                     ; BD8E 00                       .
        brk                                     ; BD8F 00                       .
        brk                                     ; BD90 00                       .
        brk                                     ; BD91 00                       .
        brk                                     ; BD92 00                       .
        brk                                     ; BD93 00                       .
        brk                                     ; BD94 00                       .
LBD95:  brk                                     ; BD95 00                       .
        brk                                     ; BD96 00                       .
        brk                                     ; BD97 00                       .
        brk                                     ; BD98 00                       .
        brk                                     ; BD99 00                       .
        brk                                     ; BD9A 00                       .
        brk                                     ; BD9B 00                       .
        brk                                     ; BD9C 00                       .
        brk                                     ; BD9D 00                       .
        brk                                     ; BD9E 00                       .
        brk                                     ; BD9F 00                       .
        brk                                     ; BDA0 00                       .
        brk                                     ; BDA1 00                       .
        brk                                     ; BDA2 00                       .
        brk                                     ; BDA3 00                       .
        brk                                     ; BDA4 00                       .
        brk                                     ; BDA5 00                       .
        brk                                     ; BDA6 00                       .
        brk                                     ; BDA7 00                       .
        brk                                     ; BDA8 00                       .
        brk                                     ; BDA9 00                       .
        brk                                     ; BDAA 00                       .
        brk                                     ; BDAB 00                       .
        brk                                     ; BDAC 00                       .
        brk                                     ; BDAD 00                       .
        brk                                     ; BDAE 00                       .
        brk                                     ; BDAF 00                       .
        brk                                     ; BDB0 00                       .
        brk                                     ; BDB1 00                       .
        brk                                     ; BDB2 00                       .
        brk                                     ; BDB3 00                       .
        brk                                     ; BDB4 00                       .
        brk                                     ; BDB5 00                       .
        brk                                     ; BDB6 00                       .
        brk                                     ; BDB7 00                       .
        brk                                     ; BDB8 00                       .
        brk                                     ; BDB9 00                       .
        brk                                     ; BDBA 00                       .
        brk                                     ; BDBB 00                       .
        brk                                     ; BDBC 00                       .
        brk                                     ; BDBD 00                       .
        brk                                     ; BDBE 00                       .
        brk                                     ; BDBF 00                       .
        brk                                     ; BDC0 00                       .
        brk                                     ; BDC1 00                       .
        brk                                     ; BDC2 00                       .
        brk                                     ; BDC3 00                       .
        brk                                     ; BDC4 00                       .
        brk                                     ; BDC5 00                       .
        brk                                     ; BDC6 00                       .
        brk                                     ; BDC7 00                       .
        brk                                     ; BDC8 00                       .
        brk                                     ; BDC9 00                       .
        brk                                     ; BDCA 00                       .
        brk                                     ; BDCB 00                       .
        brk                                     ; BDCC 00                       .
        brk                                     ; BDCD 00                       .
        brk                                     ; BDCE 00                       .
        brk                                     ; BDCF 00                       .
        brk                                     ; BDD0 00                       .
        brk                                     ; BDD1 00                       .
        brk                                     ; BDD2 00                       .
        brk                                     ; BDD3 00                       .
        brk                                     ; BDD4 00                       .
        brk                                     ; BDD5 00                       .
        brk                                     ; BDD6 00                       .
        brk                                     ; BDD7 00                       .
        brk                                     ; BDD8 00                       .
        brk                                     ; BDD9 00                       .
        brk                                     ; BDDA 00                       .
        brk                                     ; BDDB 00                       .
        brk                                     ; BDDC 00                       .
        brk                                     ; BDDD 00                       .
        brk                                     ; BDDE 00                       .
        brk                                     ; BDDF 00                       .
        brk                                     ; BDE0 00                       .
        brk                                     ; BDE1 00                       .
        brk                                     ; BDE2 00                       .
        brk                                     ; BDE3 00                       .
        brk                                     ; BDE4 00                       .
        brk                                     ; BDE5 00                       .
        brk                                     ; BDE6 00                       .
        brk                                     ; BDE7 00                       .
        brk                                     ; BDE8 00                       .
        brk                                     ; BDE9 00                       .
        brk                                     ; BDEA 00                       .
        brk                                     ; BDEB 00                       .
        brk                                     ; BDEC 00                       .
        brk                                     ; BDED 00                       .
        brk                                     ; BDEE 00                       .
        brk                                     ; BDEF 00                       .
        brk                                     ; BDF0 00                       .
        brk                                     ; BDF1 00                       .
        brk                                     ; BDF2 00                       .
        brk                                     ; BDF3 00                       .
        brk                                     ; BDF4 00                       .
        brk                                     ; BDF5 00                       .
        brk                                     ; BDF6 00                       .
        brk                                     ; BDF7 00                       .
        brk                                     ; BDF8 00                       .
        brk                                     ; BDF9 00                       .
        brk                                     ; BDFA 00                       .
        brk                                     ; BDFB 00                       .
        brk                                     ; BDFC 00                       .
        brk                                     ; BDFD 00                       .
        brk                                     ; BDFE 00                       .
        brk                                     ; BDFF 00                       .
        brk                                     ; BE00 00                       .
        brk                                     ; BE01 00                       .
        brk                                     ; BE02 00                       .
        brk                                     ; BE03 00                       .
        brk                                     ; BE04 00                       .
        brk                                     ; BE05 00                       .
        brk                                     ; BE06 00                       .
        brk                                     ; BE07 00                       .
        brk                                     ; BE08 00                       .
        brk                                     ; BE09 00                       .
        brk                                     ; BE0A 00                       .
        brk                                     ; BE0B 00                       .
        brk                                     ; BE0C 00                       .
        brk                                     ; BE0D 00                       .
        brk                                     ; BE0E 00                       .
        brk                                     ; BE0F 00                       .
        brk                                     ; BE10 00                       .
        brk                                     ; BE11 00                       .
        brk                                     ; BE12 00                       .
        brk                                     ; BE13 00                       .
        brk                                     ; BE14 00                       .
        brk                                     ; BE15 00                       .
        brk                                     ; BE16 00                       .
        brk                                     ; BE17 00                       .
        brk                                     ; BE18 00                       .
        brk                                     ; BE19 00                       .
        brk                                     ; BE1A 00                       .
        brk                                     ; BE1B 00                       .
        brk                                     ; BE1C 00                       .
        brk                                     ; BE1D 00                       .
        brk                                     ; BE1E 00                       .
        brk                                     ; BE1F 00                       .
        brk                                     ; BE20 00                       .
        brk                                     ; BE21 00                       .
        brk                                     ; BE22 00                       .
        brk                                     ; BE23 00                       .
        brk                                     ; BE24 00                       .
        brk                                     ; BE25 00                       .
        brk                                     ; BE26 00                       .
        brk                                     ; BE27 00                       .
        brk                                     ; BE28 00                       .
        brk                                     ; BE29 00                       .
        brk                                     ; BE2A 00                       .
        brk                                     ; BE2B 00                       .
        brk                                     ; BE2C 00                       .
        brk                                     ; BE2D 00                       .
        brk                                     ; BE2E 00                       .
        brk                                     ; BE2F 00                       .
        brk                                     ; BE30 00                       .
        brk                                     ; BE31 00                       .
        brk                                     ; BE32 00                       .
        brk                                     ; BE33 00                       .
        brk                                     ; BE34 00                       .
        brk                                     ; BE35 00                       .
        brk                                     ; BE36 00                       .
        brk                                     ; BE37 00                       .
        brk                                     ; BE38 00                       .
        brk                                     ; BE39 00                       .
        brk                                     ; BE3A 00                       .
        brk                                     ; BE3B 00                       .
        brk                                     ; BE3C 00                       .
        brk                                     ; BE3D 00                       .
        brk                                     ; BE3E 00                       .
        brk                                     ; BE3F 00                       .
        brk                                     ; BE40 00                       .
        brk                                     ; BE41 00                       .
        brk                                     ; BE42 00                       .
        brk                                     ; BE43 00                       .
        brk                                     ; BE44 00                       .
        brk                                     ; BE45 00                       .
        brk                                     ; BE46 00                       .
        brk                                     ; BE47 00                       .
        brk                                     ; BE48 00                       .
        brk                                     ; BE49 00                       .
        brk                                     ; BE4A 00                       .
        brk                                     ; BE4B 00                       .
        brk                                     ; BE4C 00                       .
        brk                                     ; BE4D 00                       .
        brk                                     ; BE4E 00                       .
        brk                                     ; BE4F 00                       .
        brk                                     ; BE50 00                       .
        brk                                     ; BE51 00                       .
        brk                                     ; BE52 00                       .
        brk                                     ; BE53 00                       .
        brk                                     ; BE54 00                       .
        brk                                     ; BE55 00                       .
        brk                                     ; BE56 00                       .
        brk                                     ; BE57 00                       .
        brk                                     ; BE58 00                       .
        brk                                     ; BE59 00                       .
        brk                                     ; BE5A 00                       .
        brk                                     ; BE5B 00                       .
        brk                                     ; BE5C 00                       .
        brk                                     ; BE5D 00                       .
        brk                                     ; BE5E 00                       .
        brk                                     ; BE5F 00                       .
        brk                                     ; BE60 00                       .
        brk                                     ; BE61 00                       .
        brk                                     ; BE62 00                       .
        brk                                     ; BE63 00                       .
        brk                                     ; BE64 00                       .
        brk                                     ; BE65 00                       .
        brk                                     ; BE66 00                       .
        brk                                     ; BE67 00                       .
        brk                                     ; BE68 00                       .
        brk                                     ; BE69 00                       .
        brk                                     ; BE6A 00                       .
        brk                                     ; BE6B 00                       .
        brk                                     ; BE6C 00                       .
        brk                                     ; BE6D 00                       .
        brk                                     ; BE6E 00                       .
        brk                                     ; BE6F 00                       .
        brk                                     ; BE70 00                       .
        brk                                     ; BE71 00                       .
        brk                                     ; BE72 00                       .
        brk                                     ; BE73 00                       .
        brk                                     ; BE74 00                       .
        brk                                     ; BE75 00                       .
        brk                                     ; BE76 00                       .
        brk                                     ; BE77 00                       .
        brk                                     ; BE78 00                       .
        brk                                     ; BE79 00                       .
        brk                                     ; BE7A 00                       .
        brk                                     ; BE7B 00                       .
        brk                                     ; BE7C 00                       .
        brk                                     ; BE7D 00                       .
        brk                                     ; BE7E 00                       .
        brk                                     ; BE7F 00                       .
        brk                                     ; BE80 00                       .
        brk                                     ; BE81 00                       .
        brk                                     ; BE82 00                       .
        brk                                     ; BE83 00                       .
        brk                                     ; BE84 00                       .
        brk                                     ; BE85 00                       .
        brk                                     ; BE86 00                       .
        brk                                     ; BE87 00                       .
        brk                                     ; BE88 00                       .
        brk                                     ; BE89 00                       .
        brk                                     ; BE8A 00                       .
        brk                                     ; BE8B 00                       .
        brk                                     ; BE8C 00                       .
        brk                                     ; BE8D 00                       .
        brk                                     ; BE8E 00                       .
        brk                                     ; BE8F 00                       .
        brk                                     ; BE90 00                       .
        brk                                     ; BE91 00                       .
        brk                                     ; BE92 00                       .
        brk                                     ; BE93 00                       .
        brk                                     ; BE94 00                       .
        brk                                     ; BE95 00                       .
        brk                                     ; BE96 00                       .
        brk                                     ; BE97 00                       .
        brk                                     ; BE98 00                       .
        brk                                     ; BE99 00                       .
        brk                                     ; BE9A 00                       .
        brk                                     ; BE9B 00                       .
        brk                                     ; BE9C 00                       .
        brk                                     ; BE9D 00                       .
        brk                                     ; BE9E 00                       .
        brk                                     ; BE9F 00                       .
        brk                                     ; BEA0 00                       .
        brk                                     ; BEA1 00                       .
        brk                                     ; BEA2 00                       .
        brk                                     ; BEA3 00                       .
        brk                                     ; BEA4 00                       .
        brk                                     ; BEA5 00                       .
        brk                                     ; BEA6 00                       .
        brk                                     ; BEA7 00                       .
        brk                                     ; BEA8 00                       .
        brk                                     ; BEA9 00                       .
        brk                                     ; BEAA 00                       .
        brk                                     ; BEAB 00                       .
        brk                                     ; BEAC 00                       .
        brk                                     ; BEAD 00                       .
        brk                                     ; BEAE 00                       .
        brk                                     ; BEAF 00                       .
        brk                                     ; BEB0 00                       .
        brk                                     ; BEB1 00                       .
        brk                                     ; BEB2 00                       .
        brk                                     ; BEB3 00                       .
        brk                                     ; BEB4 00                       .
        brk                                     ; BEB5 00                       .
        brk                                     ; BEB6 00                       .
        brk                                     ; BEB7 00                       .
        brk                                     ; BEB8 00                       .
        brk                                     ; BEB9 00                       .
        brk                                     ; BEBA 00                       .
        brk                                     ; BEBB 00                       .
        brk                                     ; BEBC 00                       .
        brk                                     ; BEBD 00                       .
        brk                                     ; BEBE 00                       .
        brk                                     ; BEBF 00                       .
        brk                                     ; BEC0 00                       .
        brk                                     ; BEC1 00                       .
        brk                                     ; BEC2 00                       .
        brk                                     ; BEC3 00                       .
        brk                                     ; BEC4 00                       .
        brk                                     ; BEC5 00                       .
        brk                                     ; BEC6 00                       .
        brk                                     ; BEC7 00                       .
        brk                                     ; BEC8 00                       .
        brk                                     ; BEC9 00                       .
        brk                                     ; BECA 00                       .
        brk                                     ; BECB 00                       .
        brk                                     ; BECC 00                       .
        brk                                     ; BECD 00                       .
        brk                                     ; BECE 00                       .
        brk                                     ; BECF 00                       .
        brk                                     ; BED0 00                       .
        brk                                     ; BED1 00                       .
        brk                                     ; BED2 00                       .
        brk                                     ; BED3 00                       .
        brk                                     ; BED4 00                       .
        brk                                     ; BED5 00                       .
        brk                                     ; BED6 00                       .
        brk                                     ; BED7 00                       .
        brk                                     ; BED8 00                       .
        brk                                     ; BED9 00                       .
        brk                                     ; BEDA 00                       .
        brk                                     ; BEDB 00                       .
        brk                                     ; BEDC 00                       .
        brk                                     ; BEDD 00                       .
        brk                                     ; BEDE 00                       .
        brk                                     ; BEDF 00                       .
        brk                                     ; BEE0 00                       .
        brk                                     ; BEE1 00                       .
        brk                                     ; BEE2 00                       .
        brk                                     ; BEE3 00                       .
        brk                                     ; BEE4 00                       .
        brk                                     ; BEE5 00                       .
        brk                                     ; BEE6 00                       .
        brk                                     ; BEE7 00                       .
        brk                                     ; BEE8 00                       .
        brk                                     ; BEE9 00                       .
        brk                                     ; BEEA 00                       .
        brk                                     ; BEEB 00                       .
        brk                                     ; BEEC 00                       .
        brk                                     ; BEED 00                       .
        brk                                     ; BEEE 00                       .
        brk                                     ; BEEF 00                       .
        brk                                     ; BEF0 00                       .
        brk                                     ; BEF1 00                       .
        brk                                     ; BEF2 00                       .
        brk                                     ; BEF3 00                       .
        brk                                     ; BEF4 00                       .
        brk                                     ; BEF5 00                       .
        brk                                     ; BEF6 00                       .
        brk                                     ; BEF7 00                       .
        brk                                     ; BEF8 00                       .
        brk                                     ; BEF9 00                       .
        brk                                     ; BEFA 00                       .
        brk                                     ; BEFB 00                       .
        brk                                     ; BEFC 00                       .
        brk                                     ; BEFD 00                       .
        brk                                     ; BEFE 00                       .
        brk                                     ; BEFF 00                       .
        brk                                     ; BF00 00                       .
        brk                                     ; BF01 00                       .
        brk                                     ; BF02 00                       .
        brk                                     ; BF03 00                       .
        brk                                     ; BF04 00                       .
        brk                                     ; BF05 00                       .
        brk                                     ; BF06 00                       .
        brk                                     ; BF07 00                       .
        brk                                     ; BF08 00                       .
        brk                                     ; BF09 00                       .
        brk                                     ; BF0A 00                       .
        brk                                     ; BF0B 00                       .
        brk                                     ; BF0C 00                       .
        brk                                     ; BF0D 00                       .
        brk                                     ; BF0E 00                       .
        brk                                     ; BF0F 00                       .
        brk                                     ; BF10 00                       .
        brk                                     ; BF11 00                       .
        brk                                     ; BF12 00                       .
        brk                                     ; BF13 00                       .
        brk                                     ; BF14 00                       .
        brk                                     ; BF15 00                       .
        brk                                     ; BF16 00                       .
        brk                                     ; BF17 00                       .
        brk                                     ; BF18 00                       .
        brk                                     ; BF19 00                       .
        brk                                     ; BF1A 00                       .
        brk                                     ; BF1B 00                       .
        brk                                     ; BF1C 00                       .
        brk                                     ; BF1D 00                       .
        brk                                     ; BF1E 00                       .
        brk                                     ; BF1F 00                       .
        brk                                     ; BF20 00                       .
        brk                                     ; BF21 00                       .
        brk                                     ; BF22 00                       .
        brk                                     ; BF23 00                       .
        brk                                     ; BF24 00                       .
        brk                                     ; BF25 00                       .
        brk                                     ; BF26 00                       .
        brk                                     ; BF27 00                       .
        brk                                     ; BF28 00                       .
        brk                                     ; BF29 00                       .
        brk                                     ; BF2A 00                       .
        brk                                     ; BF2B 00                       .
        brk                                     ; BF2C 00                       .
        brk                                     ; BF2D 00                       .
        brk                                     ; BF2E 00                       .
        brk                                     ; BF2F 00                       .
        brk                                     ; BF30 00                       .
        brk                                     ; BF31 00                       .
        brk                                     ; BF32 00                       .
        brk                                     ; BF33 00                       .
        brk                                     ; BF34 00                       .
        brk                                     ; BF35 00                       .
        brk                                     ; BF36 00                       .
        brk                                     ; BF37 00                       .
        brk                                     ; BF38 00                       .
        brk                                     ; BF39 00                       .
        brk                                     ; BF3A 00                       .
        brk                                     ; BF3B 00                       .
        brk                                     ; BF3C 00                       .
        brk                                     ; BF3D 00                       .
        brk                                     ; BF3E 00                       .
        brk                                     ; BF3F 00                       .
        brk                                     ; BF40 00                       .
        brk                                     ; BF41 00                       .
        brk                                     ; BF42 00                       .
        brk                                     ; BF43 00                       .
        brk                                     ; BF44 00                       .
        brk                                     ; BF45 00                       .
        brk                                     ; BF46 00                       .
        brk                                     ; BF47 00                       .
        brk                                     ; BF48 00                       .
        brk                                     ; BF49 00                       .
        brk                                     ; BF4A 00                       .
        brk                                     ; BF4B 00                       .
        brk                                     ; BF4C 00                       .
        brk                                     ; BF4D 00                       .
        brk                                     ; BF4E 00                       .
        brk                                     ; BF4F 00                       .
        brk                                     ; BF50 00                       .
        brk                                     ; BF51 00                       .
        brk                                     ; BF52 00                       .
        brk                                     ; BF53 00                       .
        brk                                     ; BF54 00                       .
        brk                                     ; BF55 00                       .
        brk                                     ; BF56 00                       .
        brk                                     ; BF57 00                       .
        brk                                     ; BF58 00                       .
        brk                                     ; BF59 00                       .
        brk                                     ; BF5A 00                       .
        brk                                     ; BF5B 00                       .
        brk                                     ; BF5C 00                       .
        brk                                     ; BF5D 00                       .
        brk                                     ; BF5E 00                       .
        brk                                     ; BF5F 00                       .
        brk                                     ; BF60 00                       .
        brk                                     ; BF61 00                       .
        brk                                     ; BF62 00                       .
        brk                                     ; BF63 00                       .
        brk                                     ; BF64 00                       .
        brk                                     ; BF65 00                       .
        brk                                     ; BF66 00                       .
        brk                                     ; BF67 00                       .
        brk                                     ; BF68 00                       .
        brk                                     ; BF69 00                       .
        brk                                     ; BF6A 00                       .
        brk                                     ; BF6B 00                       .
        brk                                     ; BF6C 00                       .
        brk                                     ; BF6D 00                       .
        brk                                     ; BF6E 00                       .
        brk                                     ; BF6F 00                       .
        brk                                     ; BF70 00                       .
        brk                                     ; BF71 00                       .
        brk                                     ; BF72 00                       .
        brk                                     ; BF73 00                       .
        brk                                     ; BF74 00                       .
        brk                                     ; BF75 00                       .
        brk                                     ; BF76 00                       .
        brk                                     ; BF77 00                       .
        brk                                     ; BF78 00                       .
        brk                                     ; BF79 00                       .
        brk                                     ; BF7A 00                       .
        brk                                     ; BF7B 00                       .
        brk                                     ; BF7C 00                       .
        brk                                     ; BF7D 00                       .
        brk                                     ; BF7E 00                       .
        brk                                     ; BF7F 00                       .
        brk                                     ; BF80 00                       .
        brk                                     ; BF81 00                       .
        brk                                     ; BF82 00                       .
        brk                                     ; BF83 00                       .
        brk                                     ; BF84 00                       .
        brk                                     ; BF85 00                       .
        brk                                     ; BF86 00                       .
        brk                                     ; BF87 00                       .
        brk                                     ; BF88 00                       .
        brk                                     ; BF89 00                       .
        brk                                     ; BF8A 00                       .
        brk                                     ; BF8B 00                       .
        brk                                     ; BF8C 00                       .
        brk                                     ; BF8D 00                       .
        brk                                     ; BF8E 00                       .
        brk                                     ; BF8F 00                       .
        brk                                     ; BF90 00                       .
        brk                                     ; BF91 00                       .
        brk                                     ; BF92 00                       .
        brk                                     ; BF93 00                       .
        brk                                     ; BF94 00                       .
        brk                                     ; BF95 00                       .
        brk                                     ; BF96 00                       .
        brk                                     ; BF97 00                       .
        brk                                     ; BF98 00                       .
        brk                                     ; BF99 00                       .
        brk                                     ; BF9A 00                       .
        brk                                     ; BF9B 00                       .
        brk                                     ; BF9C 00                       .
        brk                                     ; BF9D 00                       .
        brk                                     ; BF9E 00                       .
        brk                                     ; BF9F 00                       .
        brk                                     ; BFA0 00                       .
        brk                                     ; BFA1 00                       .
        brk                                     ; BFA2 00                       .
        brk                                     ; BFA3 00                       .
        brk                                     ; BFA4 00                       .
        brk                                     ; BFA5 00                       .
        brk                                     ; BFA6 00                       .
        brk                                     ; BFA7 00                       .
        brk                                     ; BFA8 00                       .
        brk                                     ; BFA9 00                       .
        brk                                     ; BFAA 00                       .
        brk                                     ; BFAB 00                       .
        brk                                     ; BFAC 00                       .
        brk                                     ; BFAD 00                       .
        brk                                     ; BFAE 00                       .
        brk                                     ; BFAF 00                       .
        brk                                     ; BFB0 00                       .
        brk                                     ; BFB1 00                       .
        brk                                     ; BFB2 00                       .
        brk                                     ; BFB3 00                       .
        brk                                     ; BFB4 00                       .
        brk                                     ; BFB5 00                       .
        brk                                     ; BFB6 00                       .
        brk                                     ; BFB7 00                       .
        brk                                     ; BFB8 00                       .
        brk                                     ; BFB9 00                       .
        brk                                     ; BFBA 00                       .
        brk                                     ; BFBB 00                       .
        brk                                     ; BFBC 00                       .
        brk                                     ; BFBD 00                       .
        brk                                     ; BFBE 00                       .
        brk                                     ; BFBF 00                       .
        brk                                     ; BFC0 00                       .
        brk                                     ; BFC1 00                       .
        brk                                     ; BFC2 00                       .
        brk                                     ; BFC3 00                       .
        brk                                     ; BFC4 00                       .
        brk                                     ; BFC5 00                       .
        brk                                     ; BFC6 00                       .
        brk                                     ; BFC7 00                       .
        brk                                     ; BFC8 00                       .
        brk                                     ; BFC9 00                       .
        brk                                     ; BFCA 00                       .
        brk                                     ; BFCB 00                       .
        brk                                     ; BFCC 00                       .
        brk                                     ; BFCD 00                       .
        brk                                     ; BFCE 00                       .
        brk                                     ; BFCF 00                       .
        brk                                     ; BFD0 00                       .
        brk                                     ; BFD1 00                       .
        brk                                     ; BFD2 00                       .
        brk                                     ; BFD3 00                       .
        brk                                     ; BFD4 00                       .
        brk                                     ; BFD5 00                       .
        brk                                     ; BFD6 00                       .
        brk                                     ; BFD7 00                       .
        brk                                     ; BFD8 00                       .
        brk                                     ; BFD9 00                       .
        brk                                     ; BFDA 00                       .
        brk                                     ; BFDB 00                       .
        brk                                     ; BFDC 00                       .
        brk                                     ; BFDD 00                       .
        brk                                     ; BFDE 00                       .
        brk                                     ; BFDF 00                       .
        brk                                     ; BFE0 00                       .
        brk                                     ; BFE1 00                       .
        brk                                     ; BFE2 00                       .
        brk                                     ; BFE3 00                       .
        brk                                     ; BFE4 00                       .
        brk                                     ; BFE5 00                       .
        brk                                     ; BFE6 00                       .
        brk                                     ; BFE7 00                       .
        brk                                     ; BFE8 00                       .
        brk                                     ; BFE9 00                       .
        brk                                     ; BFEA 00                       .
        brk                                     ; BFEB 00                       .
        brk                                     ; BFEC 00                       .
        brk                                     ; BFED 00                       .
        brk                                     ; BFEE 00                       .
        brk                                     ; BFEF 00                       .
        brk                                     ; BFF0 00                       .
        brk                                     ; BFF1 00                       .
        brk                                     ; BFF2 00                       .
        brk                                     ; BFF3 00                       .
        brk                                     ; BFF4 00                       .
        brk                                     ; BFF5 00                       .
        brk                                     ; BFF6 00                       .
        brk                                     ; BFF7 00                       .
        brk                                     ; BFF8 00                       .
        brk                                     ; BFF9 00                       .
        brk                                     ; BFFA 00                       .
        brk                                     ; BFFB 00                       .
        brk                                     ; BFFC 00                       .
        brk                                     ; BFFD 00                       .
        brk                                     ; BFFE 00                       .
        brk                                     ; BFFF 00                       .
