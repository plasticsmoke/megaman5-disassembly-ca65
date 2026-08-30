.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK0A"

; =============================================================================
; BANK $0A (mapped at $A000) — AFTERMATH DIRECTORS, STAGE TRIGGERS +
; PROTO CASTLE 3 STAGE DATA
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
; --- $A800: DAMAGE TABLE, weapon $A (Rush Coil) ---
; $A800[ent_type] via damage_engine $1C:809D; low 7 bits = damage,
; bit 7 = special handling; $00 = ricochet. Types $00-$CF.
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A800  types $00-$0F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$01 ; A810  types $10-$1F
        .byte   $01,$01,$00,$00,$00,$01,$00,$00,$01,$01,$01,$01,$00,$01,$00,$00 ; A820  types $20-$2F
        .byte   $00,$01,$01,$01,$01,$01,$01,$00,$01,$01,$01,$01,$00,$00,$01,$00 ; A830  types $30-$3F
        .byte   $01,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 ; A840  types $40-$4F
        .byte   $01,$00,$01,$01,$01,$00,$01,$00,$00,$01,$01,$00,$01,$01,$00,$01 ; A850  types $50-$5F
        .byte   $01,$00,$01,$01,$01,$01,$01,$01,$01,$01,$00,$01,$00,$00,$01,$00 ; A860  types $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$00,$00,$00 ; A870  types $70-$7F
        .byte   $00,$01,$00,$01,$00,$00,$01,$00,$01,$01,$00,$00,$00,$01,$00,$00 ; A880  types $80-$8F
        .byte   $00,$01,$01,$01,$00,$00,$01,$00,$01,$01,$00,$00,$01,$00,$01,$00 ; A890  types $90-$9F
        .byte   $01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00 ; A8A0  types $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$00 ; A8B0  types $B0-$BF
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8C0  types $C0-$CF
; --- $A8D0: remainder (beyond type $CF) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8F0

; =============================================================================
; PROTO CASTLE 3 STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $A900: screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; A900  screens $00-$0F
        .byte   $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$00,$00 ; A910  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00 ; A920  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A930  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A940  screens $40-$4F
; --- $A950: section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $23,$80,$A0,$20,$80,$A4,$80,$A4,$40,$62,$80,$A3,$20,$20,$00,$00 ; A950
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A960
; --- $A968: per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $18,$09,$2D,$59,$19,$1C,$2B,$2F,$02,$25,$02,$2A,$80,$BC,$00,$00 ; A968
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A978
; --- $A980: BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $A8,$AA,$00,$00,$00,$80,$00,$00 ; A980
; --- $A988: palette sets, 20 bytes each [16 BG palette + 4 palette-cycle
; seeds]: set n at +20n; set 0 is loaded by stage_load, later sets are
; switched per section by the bank $00 environment service
; ($A968 attr bits 0-5 -> $00:809E records, ctl bit 7) ---
        .byte   $0F,$30,$28,$07,$0F,$30,$2C,$0C,$0F,$30,$2B,$0A,$0F,$17,$07,$08 ; A988
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A998
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9D0
; --- $A9E0: screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9E0  terminator / filler
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9F0  
        .byte   $00                             ; A9FF  -1 base for the spawn arrays
; --- $AA00: spawn screens (ascending) ---
        .byte   $01,$01,$01,$02,$02,$02,$03,$03,$03,$03,$04,$04,$04,$05,$05,$05 ; AA00  entries $00-$0F
        .byte   $05,$06,$06,$06,$06,$06,$07,$07,$07,$07,$07,$09,$09,$09,$0A,$0A ; AA10  entries $10-$1F
        .byte   $0B,$0B,$0D,$0F,$0F,$0F,$0F,$10,$11,$11,$12,$12,$12,$13,$15,$15 ; AA20  entries $20-$2F
        .byte   $16,$16,$16,$16,$17,$17,$19,$19,$19,$19,$1A,$1A,$1A,$1B,$1B,$1D ; AA30  entries $30-$3F
        .byte   $FF,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA70  entries $70-$7F
; --- $AA80: spawn X px ---
        .byte   $20,$70,$C0,$08,$18,$70,$10,$30,$60,$C0,$58,$D8,$E8,$90,$B0,$D0 ; AA80  entries $00-$0F
        .byte   $D1,$30,$60,$A0,$E0,$E1,$40,$60,$A0,$40,$50,$20,$A8,$F8,$88,$C8 ; AA90  entries $10-$1F
        .byte   $30,$B8,$60,$38,$38,$FE,$FF,$A8,$88,$C8,$10,$40,$98,$68,$20,$C0 ; AAA0  entries $20-$2F
        .byte   $30,$90,$B0,$D0,$30,$58,$68,$68,$98,$F8,$40,$98,$E8,$A8,$C8,$D8 ; AAB0  entries $30-$3F
        .byte   $FF,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00 ; AAE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAF0  entries $70-$7F
; --- $AB00: spawn Y px ---
        .byte   $60,$B8,$98,$98,$18,$98,$B8,$50,$A8,$A8,$20,$30,$88,$78,$58,$48 ; AB00  entries $00-$0F
        .byte   $C0,$30,$40,$70,$10,$80,$60,$B0,$88,$70,$C0,$98,$90,$60,$90,$60 ; AB10  entries $10-$1F
        .byte   $60,$A0,$31,$E8,$E8,$28,$58,$78,$70,$70,$20,$D0,$D8,$94,$A4,$B0 ; AB20  entries $20-$2F
        .byte   $C0,$A0,$80,$60,$B8,$74,$E8,$E8,$88,$68,$78,$68,$40,$38,$48,$00 ; AB30  entries $30-$3F
        .byte   $FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB70  entries $70-$7F
; --- $AB80: spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $0D,$32,$32,$32,$0D,$32,$32,$0D,$32,$32,$1C,$1C,$84,$34,$34,$34 ; AB80  entries $00-$0F
        .byte   $14,$61,$22,$26,$61,$61,$22,$22,$26,$61,$61,$02,$08,$02,$08,$08 ; AB90  entries $10-$1F
        .byte   $02,$08,$2B,$56,$57,$81,$83,$36,$36,$36,$36,$36,$36,$0C,$0C,$14 ; ABA0  entries $20-$2F
        .byte   $14,$14,$14,$14,$81,$0C,$56,$57,$01,$01,$01,$01,$01,$01,$01,$6B ; ABB0  entries $30-$3F
        .byte   $FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABF0  entries $70-$7F
; --- $AC00: per-screen spawn-list start index ---
        .byte   $00,$00,$03,$06,$0A,$0D,$11,$16,$1B,$1B,$1E,$20,$22,$22,$23,$23 ; AC00  screens $00-$0F
        .byte   $27,$28,$2A,$2D,$2E,$2E,$30,$34,$36,$36,$3A,$3D,$3F,$3F,$00,$00 ; AC10  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC20  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC30  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC40  screens $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC50  screens $50-$5F
        .byte   $20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC60  screens $60-$6F
        .byte   $00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC90  screens $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00 ; ACA0  screens $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACB0  screens $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACC0  screens $C0-$CF
        .byte   $00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACD0  screens $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACE0  screens $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$10,$00 ; ACF0  screens $F0-$FF
; --- $AD00: metatile top-left tile ids ---
        .byte   $00,$34,$02,$04,$06,$64,$00,$8C,$06,$10,$26,$76,$00,$00,$E8,$8E ; AD00  metatiles $00-$0F
        .byte   $00,$00,$5C,$5E,$6A,$58,$78,$59,$10,$01,$01,$01,$08,$0B,$0B,$0B ; AD10  metatiles $10-$1F
        .byte   $20,$22,$46,$24,$28,$2A,$2C,$01,$20,$40,$42,$44,$38,$4A,$3C,$1E ; AD20  metatiles $20-$2F
        .byte   $00,$00,$84,$24,$3E,$3E,$3C,$38,$70,$72,$00,$34,$08,$01,$28,$2C ; AD30  metatiles $30-$3F
        .byte   $00,$91,$92,$02,$93,$93,$95,$3E,$00,$B1,$B2,$B2,$B3,$B3,$B5,$1E ; AD40  metatiles $40-$4F
        .byte   $02,$C0,$C2,$C3,$C5,$C7,$C5,$00,$C1,$CA,$C2,$02,$C5,$02,$C5,$00 ; AD50  metatiles $50-$5F
        .byte   $C0,$C0,$C2,$C3,$C5,$C7,$00,$00,$88,$8A,$88,$8A,$00,$B5,$00,$85 ; AD60  metatiles $60-$6F
        .byte   $CE,$00,$A8,$AA,$7C,$7E,$00,$00,$EE,$00,$B8,$BA,$F2,$F3,$79,$86 ; AD70  metatiles $70-$7F
        .byte   $CB,$CD,$AC,$AE,$F0,$16,$00,$96,$EB,$ED,$7C,$7E,$00,$00,$00,$96 ; AD80  metatiles $80-$8F
        .byte   $80,$82,$7C,$7E,$5E,$2A,$00,$00,$83,$81,$20,$22,$04,$00,$00,$00 ; AD90  metatiles $90-$9F
        .byte   $46,$67,$38,$D6,$2F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADA0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADB0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADC0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADD0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADF0  metatiles $F0-$FF
; --- $AE00: metatile bottom-left tile ids ---
        .byte   $00,$34,$03,$05,$07,$65,$76,$8D,$07,$11,$27,$76,$00,$00,$E9,$8F ; AE00  metatiles $00-$0F
        .byte   $00,$00,$5D,$5F,$6A,$10,$79,$10,$10,$01,$01,$01,$09,$0B,$0C,$09 ; AE10  metatiles $10-$1F
        .byte   $21,$23,$47,$24,$29,$2B,$2D,$01,$23,$41,$43,$45,$39,$4B,$3D,$1F ; AE20  metatiles $20-$2F
        .byte   $00,$00,$00,$25,$3E,$3E,$3D,$39,$71,$73,$00,$35,$0C,$01,$29,$2D ; AE30  metatiles $30-$3F
        .byte   $90,$92,$92,$02,$93,$94,$00,$3E,$B0,$B2,$B2,$B2,$B3,$B4,$00,$1F ; AE40  metatiles $40-$4F
        .byte   $02,$C1,$C2,$C4,$C6,$C8,$C6,$00,$C0,$C1,$D8,$02,$D9,$02,$D9,$85 ; AE50  metatiles $50-$5F
        .byte   $C0,$C1,$C2,$C4,$C6,$C8,$E8,$00,$89,$8B,$89,$8B,$00,$B6,$E9,$85 ; AE60  metatiles $60-$6F
        .byte   $CF,$00,$A9,$AB,$7D,$7F,$00,$00,$EF,$00,$B9,$BB,$F2,$F3,$79,$00 ; AE70  metatiles $70-$7F
        .byte   $CC,$3E,$AD,$AF,$F1,$17,$00,$97,$EC,$01,$7D,$7F,$00,$00,$00,$97 ; AE80  metatiles $80-$8F
        .byte   $81,$83,$7D,$7F,$5F,$2B,$00,$00,$81,$80,$21,$23,$05,$00,$00,$00 ; AE90  metatiles $90-$9F
        .byte   $47,$67,$0D,$D7,$3D,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEA0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEB0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEC0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AED0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEF0  metatiles $F0-$FF
; --- $AF00: metatile top-right tile ids ---
        .byte   $00,$34,$12,$14,$06,$74,$00,$9C,$06,$10,$36,$76,$F4,$00,$F8,$9E ; AF00  metatiles $00-$0F
        .byte   $F6,$F5,$01,$01,$7A,$68,$10,$68,$10,$01,$6C,$6E,$18,$1A,$1B,$1B ; AF10  metatiles $10-$1F
        .byte   $30,$32,$56,$34,$38,$3A,$3C,$0E,$30,$50,$52,$54,$48,$5A,$4C,$01 ; AF20  metatiles $20-$2F
        .byte   $60,$62,$00,$34,$4F,$01,$3C,$38,$80,$82,$00,$34,$AE,$4F,$48,$4C ; AF30  metatiles $30-$3F
        .byte   $00,$A1,$A2,$02,$A3,$A3,$A5,$0E,$00,$C0,$C2,$C3,$C5,$C7,$00,$4F ; AF40  metatiles $40-$4F
        .byte   $02,$C0,$C2,$C3,$C5,$C7,$C5,$00,$C1,$DA,$D8,$02,$62,$02,$C5,$85 ; AF50  metatiles $50-$5F
        .byte   $60,$D0,$62,$D2,$62,$D4,$F7,$F9,$88,$8A,$98,$9A,$00,$80,$00,$85 ; AF60  metatiles $60-$6F
        .byte   $DE,$00,$A8,$AA,$7C,$7E,$00,$00,$FE,$00,$88,$8A,$00,$00,$10,$C5 ; AF70  metatiles $70-$7F
        .byte   $DB,$DD,$BC,$7E,$F0,$16,$00,$96,$FB,$FD,$7C,$7E,$00,$00,$00,$A6 ; AF80  metatiles $80-$8F
        .byte   $84,$00,$BC,$BE,$4E,$2A,$00,$00,$00,$00,$30,$32,$14,$00,$00,$00 ; AF90  metatiles $90-$9F
        .byte   $56,$77,$38,$E6,$3F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFA0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFB0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFC0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFD0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFF0  metatiles $F0-$FF
; --- $B000: metatile bottom-right tile ids ---
        .byte   $00,$34,$13,$15,$07,$75,$00,$9D,$07,$10,$37,$76,$F4,$66,$F9,$9F ; B000  metatiles $00-$0F
        .byte   $F6,$F6,$01,$01,$7A,$10,$10,$10,$10,$01,$6D,$6F,$19,$1B,$1C,$19 ; B010  metatiles $10-$1F
        .byte   $31,$33,$57,$34,$39,$3B,$3D,$0F,$33,$51,$53,$55,$49,$5B,$4D,$01 ; B020  metatiles $20-$2F
        .byte   $61,$63,$00,$35,$4F,$01,$3D,$39,$81,$83,$00,$35,$AF,$4F,$49,$4D ; B030  metatiles $30-$3F
        .byte   $A0,$A2,$A2,$02,$A3,$A4,$00,$0F,$00,$C1,$C2,$C4,$C6,$C8,$00,$4F ; B040  metatiles $40-$4F
        .byte   $02,$C1,$C2,$C4,$C6,$C8,$C9,$00,$C0,$C1,$C2,$02,$63,$02,$D9,$87 ; B050  metatiles $50-$5F
        .byte   $61,$D1,$63,$D3,$63,$D5,$F8,$FA,$89,$8B,$99,$9B,$00,$81,$EA,$85 ; B060  metatiles $60-$6F
        .byte   $DF,$00,$A9,$AB,$7D,$7F,$00,$00,$FF,$00,$89,$8B,$00,$00,$10,$A6 ; B070  metatiles $70-$7F
        .byte   $DC,$01,$BD,$7F,$F1,$17,$00,$97,$FC,$4E,$7D,$7F,$00,$00,$00,$A7 ; B080  metatiles $80-$8F
        .byte   $00,$00,$BD,$BF,$4F,$2B,$00,$00,$00,$84,$31,$33,$15,$00,$00,$00 ; B090  metatiles $90-$9F
        .byte   $57,$77,$1D,$E7,$3D,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0A0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0B0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0C0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0D0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0E0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0F0  metatiles $F0-$FF
; --- $B100: metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$10,$F0,$10,$20,$01,$01,$F0,$40,$00,$01,$00,$03,$01,$00,$F0 ; B100  metatiles $00-$0F
        .byte   $03,$03,$11,$11,$03,$03,$03,$03,$03,$11,$11,$11,$11,$11,$11,$11 ; B110  metatiles $10-$1F
        .byte   $10,$10,$00,$10,$11,$12,$11,$11,$10,$10,$10,$10,$11,$12,$11,$11 ; B120  metatiles $20-$2F
        .byte   $03,$03,$03,$10,$11,$11,$11,$11,$03,$03,$00,$10,$11,$11,$11,$11 ; B130  metatiles $30-$3F
        .byte   $03,$03,$03,$00,$03,$03,$03,$11,$03,$03,$03,$03,$03,$03,$03,$11 ; B140  metatiles $40-$4F
        .byte   $00,$03,$03,$03,$03,$03,$03,$00,$00,$03,$03,$03,$03,$03,$03,$00 ; B150  metatiles $50-$5F
        .byte   $00,$03,$03,$03,$03,$03,$01,$01,$11,$11,$11,$11,$00,$00,$01,$00 ; B160  metatiles $60-$6F
        .byte   $10,$00,$12,$12,$12,$12,$00,$00,$10,$00,$11,$11,$03,$03,$03,$00 ; B170  metatiles $70-$7F
        .byte   $11,$11,$12,$01,$01,$01,$00,$01,$11,$11,$01,$01,$00,$00,$00,$01 ; B180  metatiles $80-$8F
        .byte   $03,$03,$01,$01,$11,$01,$00,$00,$03,$03,$12,$12,$12,$00,$00,$00 ; B190  metatiles $90-$9F
        .byte   $11,$11,$11,$11,$11,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1A0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1B0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1C0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1D0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1E0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1F0  metatiles $F0-$FF
; --- $B200: 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $00,$00,$00,$00,$05,$06,$0D,$00,$00,$0D,$00,$00,$00,$00,$00,$0A ; B200  blocks $00-$03
        .byte   $45,$46,$4D,$4E,$00,$87,$00,$8F,$55,$00,$55,$00,$00,$40,$00,$48 ; B210  blocks $04-$07
        .byte   $41,$42,$49,$4A,$42,$44,$4B,$4C,$51,$5A,$51,$52,$53,$54,$53,$54 ; B220  blocks $08-$0B
        .byte   $65,$31,$38,$39,$30,$31,$38,$39,$61,$62,$38,$39,$63,$64,$38,$39 ; B230  blocks $0C-$0F
        .byte   $20,$21,$2B,$23,$20,$21,$29,$2A,$28,$01,$28,$01,$28,$00,$28,$00 ; B240  blocks $10-$13
        .byte   $00,$00,$06,$00,$20,$21,$28,$20,$20,$21,$21,$28,$32,$00,$00,$00 ; B250  blocks $14-$17
        .byte   $A0,$A0,$51,$5A,$A0,$A0,$55,$0D,$A1,$A0,$00,$00,$A0,$A1,$38,$39 ; B260  blocks $18-$1B
        .byte   $A1,$A0,$38,$39,$28,$24,$21,$2C,$25,$47,$2D,$4F,$47,$26,$4F,$2E ; B270  blocks $1C-$1F
        .byte   $04,$A2,$04,$37,$A4,$28,$36,$20,$35,$26,$3D,$2E,$0C,$11,$14,$15 ; B280  blocks $20-$23
        .byte   $04,$37,$04,$2C,$36,$28,$2E,$20,$14,$15,$14,$16,$04,$11,$04,$15 ; B290  blocks $24-$27
        .byte   $0C,$28,$14,$20,$14,$17,$14,$16,$14,$28,$14,$20,$00,$00,$28,$20 ; B2A0  blocks $28-$2B
        .byte   $14,$17,$21,$28,$14,$17,$1F,$1D,$14,$17,$1F,$1F,$14,$28,$1F,$1D ; B2B0  blocks $2C-$2F
        .byte   $20,$21,$21,$23,$28,$01,$21,$01,$28,$04,$21,$04,$24,$25,$2C,$2D ; B2C0  blocks $30-$33
        .byte   $35,$47,$3D,$4F,$35,$26,$4F,$2E,$0C,$72,$14,$7A,$73,$28,$7B,$11 ; B2D0  blocks $34-$37
        .byte   $20,$21,$0C,$11,$20,$21,$0C,$20,$14,$68,$14,$68,$69,$16,$69,$17 ; B2E0  blocks $38-$3B
        .byte   $28,$04,$21,$16,$14,$6A,$14,$11,$6B,$15,$0C,$16,$14,$17,$14,$1C ; B2F0  blocks $3C-$3F
        .byte   $14,$28,$1D,$1D,$28,$17,$21,$16,$14,$17,$14,$15,$14,$11,$14,$16 ; B300  blocks $40-$43
        .byte   $1D,$1F,$2B,$23,$1D,$1E,$1C,$1E,$14,$17,$08,$24,$14,$15,$26,$20 ; B310  blocks $44-$47
        .byte   $1C,$1D,$21,$28,$04,$37,$04,$37,$36,$28,$36,$20,$28,$37,$21,$37 ; B320  blocks $48-$4B
        .byte   $25,$36,$2D,$36,$A2,$A3,$37,$2F,$A3,$A4,$2F,$36,$72,$73,$72,$73 ; B330  blocks $4C-$4F
        .byte   $7A,$7B,$6A,$6B,$28,$2C,$21,$11,$2D,$2E,$0C,$11,$37,$1B,$37,$36 ; B340  blocks $50-$53
        .byte   $4F,$2E,$0C,$11,$2C,$2E,$0C,$0C,$14,$14,$14,$14,$0C,$28,$14,$0C ; B350  blocks $54-$57
        .byte   $28,$08,$21,$04,$28,$17,$28,$1C,$14,$17,$1D,$1E,$14,$14,$1C,$1D ; B360  blocks $58-$5B
        .byte   $82,$34,$00,$00,$82,$3F,$00,$00,$28,$07,$21,$07,$90,$91,$98,$99 ; B370  blocks $5C-$5F
        .byte   $98,$90,$99,$98,$90,$04,$98,$04,$00,$28,$00,$20,$28,$00,$21,$00 ; B380  blocks $60-$63
        .byte   $99,$98,$00,$00,$00,$28,$0F,$20,$0F,$28,$00,$20,$28,$00,$00,$00 ; B390  blocks $64-$67
        .byte   $00,$00,$1E,$1C,$00,$1C,$1F,$1E,$1F,$1D,$29,$2A,$20,$21,$21,$20 ; B3A0  blocks $68-$6B
        .byte   $25,$35,$2D,$3D,$90,$04,$98,$99,$1C,$1F,$00,$00,$1F,$1E,$00,$00 ; B3B0  blocks $6C-$6F
        .byte   $1F,$1D,$0F,$20,$0F,$28,$0F,$20,$28,$07,$25,$35,$00,$00,$35,$25 ; B3C0  blocks $70-$73
        .byte   $00,$00,$35,$35,$00,$00,$25,$08,$00,$00,$25,$35,$0F,$28,$35,$25 ; B3D0  blocks $74-$77
        .byte   $2D,$3D,$00,$00,$4F,$2D,$00,$00,$3D,$2D,$00,$00,$3D,$4F,$00,$00 ; B3E0  blocks $78-$7B
        .byte   $2D,$04,$00,$00,$00,$00,$00,$05,$28,$31,$25,$39,$2D,$28,$21,$20 ; B3F0  blocks $7C-$7F
        .byte   $28,$1F,$28,$23,$1D,$1E,$2B,$33,$2D,$00,$21,$00,$32,$00,$28,$20 ; B400  blocks $80-$83
        .byte   $28,$3B,$28,$3B,$00,$00,$28,$00,$00,$00,$00,$28,$25,$40,$2D,$48 ; B410  blocks $84-$87
        .byte   $30,$25,$38,$2D,$00,$00,$21,$28,$2D,$00,$28,$00,$32,$28,$00,$20 ; B420  blocks $88-$8B
        .byte   $A2,$A3,$37,$19,$A3,$A4,$19,$36,$A2,$A3,$2C,$4F,$A3,$A4,$4F,$2E ; B430  blocks $8C-$8F
        .byte   $30,$31,$A0,$A1,$30,$31,$A0,$39,$00,$28,$00,$25,$00,$00,$7A,$7B ; B440  blocks $90-$93
        .byte   $00,$2D,$00,$28,$6A,$6B,$72,$73,$25,$26,$2D,$2E,$04,$24,$04,$2C ; B450  blocks $94-$97
        .byte   $20,$70,$28,$78,$0C,$0C,$14,$14,$80,$81,$88,$89,$04,$24,$14,$2C ; B460  blocks $98-$9B
        .byte   $14,$24,$1E,$2C,$25,$25,$2D,$2D,$47,$47,$4F,$4F,$20,$21,$70,$28 ; B470  blocks $9C-$9F
        .byte   $7A,$7B,$68,$69,$04,$7A,$04,$6A,$7B,$25,$6B,$2D,$04,$11,$14,$15 ; B480  blocks $A0-$A3
        .byte   $14,$15,$25,$7A,$14,$15,$7B,$15,$1C,$1E,$0C,$11,$1C,$1F,$0C,$24 ; B490  blocks $A4-$A7
        .byte   $1F,$1E,$35,$35,$25,$68,$2D,$68,$14,$A2,$14,$37,$A3,$A3,$2F,$2F ; B4A0  blocks $A8-$AB
        .byte   $26,$14,$2E,$14,$14,$37,$14,$37,$19,$19,$19,$19,$08,$A2,$04,$2C ; B4B0  blocks $AC-$AF
        .byte   $A3,$A3,$4F,$4F,$1F,$1F,$00,$00,$1C,$1E,$00,$00,$24,$35,$37,$19 ; B4C0  blocks $B0-$B3
        .byte   $35,$26,$19,$36,$78,$21,$21,$28,$04,$3E,$04,$00,$47,$25,$4F,$2D ; B4D0  blocks $B4-$B7
        .byte   $35,$35,$A3,$A3,$35,$25,$A3,$2D,$25,$26,$2D,$A4,$3D,$4F,$7A,$7B ; B4E0  blocks $B8-$BB
        .byte   $2D,$2E,$00,$00,$72,$73,$7A,$7B,$08,$7A,$04,$6A,$04,$72,$04,$7A ; B4F0  blocks $BC-$BF
        .byte   $73,$25,$7B,$2D,$74,$75,$72,$73,$00,$00,$1C,$1F,$66,$67,$6E,$00 ; B500  blocks $C0-$C3
        .byte   $26,$00,$2E,$00,$00,$00,$1F,$1E,$00,$00,$02,$00,$3C,$00,$00,$00 ; B510  blocks $C4-$C7
        .byte   $00,$00,$00,$02,$00,$00,$02,$02,$02,$00,$00,$00,$00,$00,$00,$06 ; B520  blocks $C8-$CB
        .byte   $25,$00,$2D,$00,$00,$02,$02,$02,$00,$7A,$00,$6A,$7B,$08,$6B,$04 ; B530  blocks $CC-$CF
        .byte   $00,$72,$00,$72,$73,$04,$73,$04,$25,$7A,$2D,$6A,$7B,$04,$6B,$04 ; B540  blocks $D0-$D3
        .byte   $32,$00,$98,$99,$32,$00,$99,$1C,$32,$00,$1D,$1F,$6A,$6B,$1D,$1F ; B550  blocks $D4-$D7
        .byte   $90,$24,$98,$2C,$90,$1C,$98,$00,$24,$80,$2C,$88,$81,$26,$89,$2E ; B560  blocks $D8-$DB
        .byte   $14,$16,$7C,$7D,$14,$7A,$7C,$6A,$7B,$17,$6B,$1C,$00,$72,$00,$7A ; B570  blocks $DC-$DF
        .byte   $73,$23,$7B,$01,$18,$18,$7E,$7E,$14,$04,$14,$04,$18,$18,$18,$18 ; B580  blocks $E0-$E3
        .byte   $14,$04,$14,$16,$14,$17,$28,$20,$18,$18,$1E,$1C,$78,$21,$70,$28 ; B590  blocks $E4-$E7
        .byte   $78,$21,$28,$20,$04,$25,$04,$2D,$68,$69,$6A,$6B,$04,$10,$04,$7E ; B5A0  blocks $E8-$EB
        .byte   $0C,$11,$14,$16,$04,$18,$04,$7E,$14,$17,$82,$34,$14,$17,$3F,$08 ; B5B0  blocks $EC-$EF
        .byte   $10,$10,$7E,$7E,$0C,$04,$14,$04,$00,$00,$08,$25,$04,$2D,$04,$25 ; B5C0  blocks $F0-$F3
        .byte   $3D,$2D,$35,$25,$05,$06,$00,$00,$20,$21,$0C,$85,$14,$85,$14,$85 ; B5D0  blocks $F4-$F7
        .byte   $25,$28,$2D,$20,$28,$25,$21,$2D,$14,$15,$14,$15,$28,$11,$21,$16 ; B5E0  blocks $F8-$FB
        .byte   $28,$17,$0C,$16,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5F0  blocks $FC-$FF
; --- $B600: screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$01,$00,$00,$00,$00,$01,$00,$02,$01,$00,$00,$00,$03,$00,$00 ; B600
        .byte   $04,$00,$01,$00,$00,$05,$03,$00,$06,$00,$03,$00,$07,$08,$09,$04 ; B610
        .byte   $06,$02,$05,$00,$00,$0A,$0B,$06,$0C,$0D,$0D,$0D,$0D,$0E,$0F,$0C ; B620
        .byte   $10,$11,$10,$11,$10,$11,$10,$11,$12,$13,$12,$13,$12,$13,$12,$13 ; B630
; layout $01
        .byte   $00,$00,$00,$00,$00,$00,$00,$01,$00,$01,$00,$00,$00,$00,$00,$00 ; B640
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$03,$00,$00,$00,$03,$00,$07 ; B650
        .byte   $14,$05,$14,$00,$00,$05,$00,$00,$0D,$0D,$0D,$0D,$0D,$15,$16,$14 ; B660
        .byte   $10,$11,$10,$11,$10,$15,$16,$0D,$12,$13,$12,$13,$12,$15,$16,$17 ; B670
; layout $02
        .byte   $00,$00,$00,$00,$00,$00,$00,$15,$00,$01,$00,$00,$00,$00,$00,$00 ; B680
        .byte   $03,$03,$00,$00,$00,$00,$02,$00,$08,$09,$04,$00,$02,$00,$00,$01 ; B690
        .byte   $0A,$0B,$06,$00,$00,$03,$00,$00,$18,$0B,$19,$1A,$00,$05,$00,$00 ; B6A0
        .byte   $0E,$0F,$0C,$0D,$0D,$1B,$1B,$1C,$17,$17,$00,$17,$17,$17,$00,$00 ; B6B0
; layout $03
        .byte   $16,$15,$1D,$1E,$1F,$20,$21,$16,$00,$15,$1D,$1E,$22,$20,$21,$16 ; B6C0
        .byte   $00,$00,$00,$23,$23,$24,$25,$16,$00,$00,$00,$26,$26,$27,$28,$16 ; B6D0
        .byte   $00,$00,$00,$29,$29,$26,$2A,$16,$00,$00,$2B,$2C,$2D,$2E,$2F,$15 ; B6E0
        .byte   $1C,$0D,$15,$30,$11,$10,$11,$10,$17,$00,$15,$31,$13,$12,$13,$12 ; B6F0
; layout $04
        .byte   $15,$32,$33,$34,$35,$15,$16,$15,$15,$32,$23,$36,$37,$38,$38,$39 ; B700
        .byte   $15,$32,$26,$3A,$3B,$26,$26,$2A,$15,$32,$29,$3A,$3B,$29,$29,$2A ; B710
        .byte   $15,$3C,$29,$3D,$3E,$3F,$2E,$40,$15,$41,$29,$26,$42,$43,$23,$33 ; B720
        .byte   $44,$45,$2D,$2D,$2D,$46,$47,$48,$12,$15,$16,$15,$16,$49,$4A,$16 ; B730
; layout $05
        .byte   $4B,$4C,$15,$16,$4D,$4E,$4F,$15,$4B,$4C,$15,$16,$4D,$4E,$50,$15 ; B740
        .byte   $51,$52,$15,$16,$53,$54,$23,$15,$41,$26,$15,$16,$55,$26,$26,$15 ; B750
        .byte   $41,$29,$23,$23,$56,$29,$29,$15,$41,$29,$26,$26,$56,$29,$29,$57 ; B760
        .byte   $15,$58,$59,$5A,$5B,$2D,$5A,$5B,$15,$32,$5C,$5C,$5C,$5C,$5D,$15 ; B770
; layout $06
        .byte   $5E,$00,$5F,$5F,$60,$61,$60,$62,$63,$5F,$60,$60,$5F,$5F,$64,$65 ; B780
        .byte   $63,$5F,$5F,$5F,$5F,$5F,$00,$66,$5E,$64,$5F,$60,$5F,$60,$5F,$62 ; B790
        .byte   $63,$5F,$5F,$5F,$5F,$5F,$5F,$62,$67,$00,$64,$5F,$5F,$62,$16,$15 ; B7A0
        .byte   $68,$69,$6A,$44,$6A,$44,$15,$16,$16,$12,$13,$12,$13,$12,$15,$16 ; B7B0
; layout $07
        .byte   $6B,$32,$6C,$6C,$6C,$6C,$6C,$6C,$5E,$6D,$5F,$00,$6C,$6C,$6C,$6C ; B7C0
        .byte   $5E,$64,$60,$5F,$6E,$6F,$6F,$70,$5E,$64,$5F,$60,$60,$64,$00,$71 ; B7D0
        .byte   $5E,$5F,$5F,$5F,$60,$5F,$00,$71,$5E,$64,$60,$5F,$5F,$60,$60,$71 ; B7E0
        .byte   $72,$73,$73,$73,$74,$75,$76,$77,$78,$79,$7A,$7A,$7B,$7C,$78,$79 ; B7F0
; layout $08
        .byte   $63,$14,$00,$01,$00,$7D,$00,$00,$63,$00,$00,$00,$14,$02,$00,$01 ; B800
        .byte   $63,$00,$01,$00,$00,$00,$00,$00,$63,$00,$00,$00,$00,$00,$00,$07 ; B810
        .byte   $63,$00,$00,$00,$00,$00,$00,$00,$7E,$0D,$0D,$0D,$0D,$0D,$0D,$0D ; B820
        .byte   $7F,$58,$80,$6A,$44,$6A,$44,$6A,$6B,$32,$12,$13,$12,$13,$12,$13 ; B830
; layout $09
        .byte   $00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$14,$00,$00,$03,$03 ; B840
        .byte   $03,$03,$00,$00,$00,$07,$08,$09,$08,$09,$04,$00,$00,$00,$0A,$0B ; B850
        .byte   $0A,$0B,$06,$00,$00,$00,$0A,$0B,$0E,$0F,$0C,$0D,$0D,$7E,$0E,$0F ; B860
        .byte   $44,$6A,$81,$17,$62,$82,$17,$83,$12,$13,$84,$00,$62,$63,$00,$15 ; B870
; layout $0A
        .byte   $01,$00,$14,$00,$00,$00,$02,$00,$00,$00,$00,$00,$14,$01,$01,$00 ; B880
        .byte   $04,$02,$01,$00,$00,$00,$00,$00,$06,$00,$00,$00,$00,$14,$85,$03 ; B890
        .byte   $06,$00,$00,$14,$00,$86,$87,$08,$0C,$0D,$0D,$0D,$7E,$88,$7E,$0E ; B8A0
        .byte   $89,$83,$89,$17,$8A,$8B,$82,$17,$16,$15,$16,$00,$13,$62,$63,$00 ; B8B0
; layout $0B
        .byte   $00,$14,$00,$00,$00,$00,$8C,$8D,$00,$00,$00,$00,$14,$00,$8E,$8F ; B8C0
        .byte   $01,$00,$00,$00,$00,$00,$00,$00,$03,$00,$00,$00,$00,$00,$00,$00 ; B8D0
        .byte   $09,$04,$00,$00,$01,$00,$00,$00,$0F,$0C,$90,$91,$0D,$90,$91,$0D ; B8E0
        .byte   $92,$17,$00,$00,$17,$00,$00,$93,$94,$00,$00,$00,$00,$00,$00,$95 ; B8F0
; layout $0C
        .byte   $33,$96,$4D,$4E,$15,$16,$97,$6C,$33,$96,$8E,$8F,$98,$16,$97,$6C ; B900
        .byte   $14,$23,$99,$23,$98,$16,$97,$1E,$00,$26,$56,$26,$98,$16,$97,$9A ; B910
        .byte   $00,$42,$56,$29,$23,$99,$9B,$1E,$0D,$26,$56,$29,$26,$5B,$9C,$9A ; B920
        .byte   $98,$16,$9D,$98,$16,$33,$9E,$1E,$98,$9F,$9D,$98,$9F,$33,$9E,$1E ; B930
; layout $0D
        .byte   $A0,$A1,$A2,$50,$1E,$9A,$1E,$1E,$95,$A3,$23,$99,$33,$9A,$1E,$1E ; B940
        .byte   $A0,$A4,$A5,$56,$A6,$A6,$A7,$A8,$95,$A9,$3B,$56,$26,$26,$AA,$AB ; B950
        .byte   $A0,$A9,$3B,$56,$42,$29,$AA,$AB,$9A,$6C,$9A,$AC,$26,$29,$AD,$AE ; B960
        .byte   $34,$34,$9D,$22,$98,$9F,$AF,$B0,$B1,$B2,$B3,$B4,$15,$B5,$B6,$5C ; B970
; layout $0E
        .byte   $1E,$9A,$B7,$34,$96,$01,$14,$00,$1E,$9A,$B7,$34,$96,$00,$00,$00 ; B980
        .byte   $B8,$B8,$B9,$B8,$BA,$00,$00,$00,$BB,$7B,$7A,$7B,$BC,$00,$01,$02 ; B990
        .byte   $95,$14,$00,$00,$00,$00,$00,$00,$50,$00,$14,$02,$01,$00,$00,$00 ; B9A0
        .byte   $BD,$BE,$A2,$50,$1E,$9A,$1E,$34,$95,$BF,$C0,$BD,$00,$C1,$00,$BD ; B9B0
; layout $0F
        .byte   $00,$00,$00,$00,$01,$14,$00,$01,$00,$00,$02,$00,$00,$00,$00,$C2 ; B9C0
        .byte   $00,$00,$C3,$01,$00,$00,$00,$14,$00,$00,$00,$00,$02,$01,$00,$6E ; B9D0
        .byte   $00,$01,$02,$00,$00,$00,$00,$C2,$00,$00,$00,$00,$14,$00,$00,$00 ; B9E0
        .byte   $1E,$C4,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B9F0
; layout $10
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$C5,$00,$00,$14,$00,$00,$02,$01 ; BA00
        .byte   $01,$00,$00,$00,$00,$02,$00,$00,$6F,$00,$00,$00,$C6,$00,$C6,$00 ; BA10
        .byte   $C5,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BA20
        .byte   $00,$00,$00,$14,$00,$00,$00,$14,$00,$00,$00,$00,$00,$00,$00,$01 ; BA30
; layout $11
        .byte   $00,$02,$00,$00,$C3,$00,$00,$00,$02,$C3,$01,$00,$00,$00,$02,$00 ; BA40
        .byte   $01,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00 ; BA50
        .byte   $00,$00,$00,$00,$C7,$00,$C7,$00,$02,$00,$00,$C8,$C9,$C9,$C6,$C6 ; BA60
        .byte   $00,$01,$00,$00,$00,$00,$00,$CA,$00,$00,$00,$00,$00,$00,$00,$00 ; BA70
; layout $12
        .byte   $01,$00,$00,$00,$14,$C3,$00,$00,$00,$CB,$C3,$02,$01,$00,$00,$00 ; BA80
        .byte   $00,$02,$00,$00,$14,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00 ; BA90
        .byte   $C7,$00,$C7,$00,$00,$00,$00,$00,$C9,$C9,$C9,$C8,$C9,$C9,$CC,$00 ; BAA0
        .byte   $00,$00,$C8,$CD,$00,$CE,$CF,$A0,$00,$00,$00,$00,$00,$D0,$D1,$95 ; BAB0
; layout $13
        .byte   $50,$1E,$1E,$34,$1E,$D2,$D3,$C1,$C1,$02,$14,$02,$00,$CE,$D3,$A0 ; BAC0
        .byte   $C1,$03,$00,$01,$00,$00,$00,$95,$50,$09,$04,$00,$00,$01,$00,$50 ; BAD0
        .byte   $BD,$0F,$0C,$0D,$0D,$0D,$0D,$BD,$95,$D4,$D5,$D6,$68,$D6,$68,$D7 ; BAE0
        .byte   $C1,$60,$D8,$6C,$9A,$9A,$9A,$6C,$C1,$5F,$D9,$44,$B1,$44,$B1,$44 ; BAF0
; layout $14
        .byte   $C1,$60,$D8,$9D,$98,$9F,$9D,$98,$C1,$5F,$D8,$9D,$98,$B5,$9D,$98 ; BB00
        .byte   $C1,$5F,$00,$00,$23,$99,$23,$23,$C1,$64,$64,$5F,$26,$56,$26,$26 ; BB10
        .byte   $C1,$60,$64,$64,$29,$56,$29,$29,$16,$00,$64,$00,$42,$56,$42,$42 ; BB20
        .byte   $16,$98,$16,$9D,$DA,$DB,$9D,$98,$9F,$98,$9F,$9D,$DA,$DB,$9D,$98 ; BB30
; layout $15
        .byte   $9F,$9D,$98,$9F,$C1,$BD,$9D,$BD,$B5,$9D,$98,$B5,$50,$95,$9D,$95 ; BB40
        .byte   $23,$23,$99,$23,$23,$50,$9D,$50,$26,$26,$56,$26,$26,$23,$23,$23 ; BB50
        .byte   $29,$29,$56,$29,$29,$26,$26,$26,$42,$42,$56,$42,$42,$29,$29,$29 ; BB60
        .byte   $16,$9D,$98,$16,$DC,$DD,$DE,$2D,$9F,$9D,$98,$9F,$00,$DF,$E0,$98 ; BB70
; layout $16
        .byte   $98,$16,$E1,$26,$26,$26,$E2,$BD,$33,$1F,$E1,$29,$29,$29,$E2,$95 ; BB80
        .byte   $33,$1F,$E3,$29,$29,$29,$E4,$98,$23,$23,$E3,$29,$29,$29,$E5,$16 ; BB90
        .byte   $26,$26,$E1,$29,$29,$E5,$16,$15,$29,$29,$E1,$29,$E5,$9F,$98,$16 ; BBA0
        .byte   $2D,$2D,$E6,$2D,$15,$E7,$98,$16,$9F,$98,$9F,$98,$9F,$E8,$16,$98 ; BBB0
; layout $17
        .byte   $BD,$E9,$B7,$B7,$B7,$B7,$50,$BD,$EA,$EB,$23,$23,$23,$23,$EC,$95 ; BBC0
        .byte   $BD,$ED,$26,$26,$26,$26,$29,$C1,$95,$ED,$29,$29,$29,$29,$29,$C1 ; BBD0
        .byte   $BD,$E1,$EE,$EE,$EE,$EE,$EF,$BD,$95,$E1,$F0,$23,$23,$23,$F1,$95 ; BBE0
        .byte   $98,$9F,$E1,$26,$26,$26,$E2,$C1,$15,$B5,$E3,$29,$29,$29,$E2,$C1 ; BBF0
; layout $18
        .byte   $95,$00,$00,$C3,$00,$00,$00,$00,$50,$02,$00,$00,$01,$00,$C3,$00 ; BC00
        .byte   $BD,$00,$00,$01,$02,$00,$01,$00,$EA,$F2,$73,$00,$00,$00,$00,$00 ; BC10
        .byte   $BD,$F3,$F4,$73,$00,$00,$00,$C3,$EA,$F3,$F4,$F4,$50,$93,$93,$00 ; BC20
        .byte   $BD,$F3,$F4,$F4,$50,$95,$EA,$50,$95,$F3,$F4,$F4,$C1,$C1,$4F,$4F ; BC30
; layout $19
        .byte   $00,$00,$00,$00,$00,$02,$00,$C3,$00,$00,$01,$C3,$00,$01,$00,$00 ; BC40
        .byte   $00,$00,$02,$00,$01,$00,$C3,$02,$C3,$00,$00,$00,$00,$00,$02,$00 ; BC50
        .byte   $01,$00,$00,$00,$02,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC60
        .byte   $33,$1F,$00,$00,$00,$00,$00,$00,$33,$1F,$00,$00,$00,$00,$00,$00 ; BC70
; layout $1A
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00 ; BC80
        .byte   $00,$00,$00,$00,$02,$00,$F5,$C3,$00,$02,$00,$00,$00,$00,$00,$14 ; BC90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BCA0
        .byte   $00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$C3,$02 ; BCB0
; layout $1B
        .byte   $00,$C3,$02,$00,$94,$98,$16,$98,$02,$00,$00,$14,$00,$00,$00,$98 ; BCC0
        .byte   $00,$01,$00,$00,$00,$00,$00,$98,$00,$00,$00,$00,$00,$01,$00,$15 ; BCD0
        .byte   $02,$00,$00,$00,$00,$00,$00,$F6,$00,$00,$00,$00,$00,$00,$00,$F7 ; BCE0
        .byte   $00,$00,$00,$00,$92,$98,$30,$11,$00,$00,$00,$00,$94,$98,$31,$13 ; BCF0
; layout $1C
        .byte   $E7,$F8,$F9,$15,$9F,$F8,$F9,$98,$E7,$F8,$F9,$98,$E7,$F8,$F9,$15 ; BD00
        .byte   $E7,$F8,$F9,$15,$E7,$F8,$F9,$15,$B5,$F8,$F9,$98,$B5,$F8,$F9,$15 ; BD10
        .byte   $38,$38,$38,$38,$38,$38,$38,$F6,$26,$FA,$26,$26,$FA,$26,$26,$F7 ; BD20
        .byte   $44,$6A,$44,$6A,$44,$6A,$44,$98,$12,$13,$12,$13,$12,$13,$12,$98 ; BD30
; layout $1D
        .byte   $B5,$98,$B5,$98,$B5,$98,$B5,$98,$FB,$23,$23,$23,$23,$23,$23,$28 ; BD40
        .byte   $41,$26,$26,$FA,$26,$26,$26,$2A,$41,$29,$42,$26,$29,$42,$29,$2A ; BD50
        .byte   $FC,$29,$26,$29,$29,$26,$29,$2A,$29,$29,$29,$29,$29,$29,$29,$2A ; BD60
        .byte   $9F,$98,$9F,$98,$9F,$98,$9F,$98,$E7,$98,$E7,$98,$E7,$98,$E7,$98 ; BD70
; layout $1E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BD80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BD90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BDA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BDB0
; layout $1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BDC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BDD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BDE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BDF0
; layout $20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE30
; layout $21
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE70
; layout $22
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BEA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BEB0
; layout $23
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BEC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BED0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BEE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BEF0
; layout $24
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF30
; layout $25
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF70
; layout $26
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BFA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BFB0
; layout $27
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BFC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BFD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BFE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BFF0
