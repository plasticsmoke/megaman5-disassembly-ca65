.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK02"

; =============================================================================
; BANK $02 (mapped at $A000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
; Data half (file +$0900 on): stage $02 (Stone Man) stage data —
; screen table at $A900 with this bank at $A000; format in
; DATA_REFERENCE.md section 11.
; =============================================================================
L0000           := $0000
L0020           := $0020
L0021           := $0021
L0402           := $0402
L0F21           := $0F21
L1221           := $1221
L1626           := $1626
L1B12           := $1B12
L2000           := $2000
L2221           := $2221
L5150           := $5150
L5A8A           := $5A8A
L6020           := $6020
L6040           := $6040
L6C57           := $6C57
L6C6C           := $6C6C
L70C0           := $70C0
L8040           := $8040
L82B8           := $82B8
L8420           := $8420
L84A6           := $84A6
L84D5           := $84D5
L8936           := $8936
LE700           := $E700
LF2F3           := $F2F3
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $4F — BIG PETS director (Wily 1 boss; spawn code $59 in
; bank $0C scr $1B). The boss body is background tiles on an IRQ-split
; screen (mode $1D): $1C:84A6 freezes the player, then after the IRQ
; handshake ($1E) this sets up the split ($9B/$99/$FD), CHR R1 := $E8,
; fades in the palette at $A26F + fills the boss HP bar ($1C:8420).
; Fight loop ($A067): every $D2 frames spit 1-2 "pet" minions (type
; $7B) from the mouth at X=$D8/Y=$34, targets picked from LA283 (no
; immediate repeat). Face sub_type $C2 -> $C3 (mouth open) while either
; ram row ($78/$79, driven by the two type $7A segments) is at rest
; 0/$FF; vflip overlay bits from LA28B by anim phase.
; =============================================================================
        jsr     L84A6                           ; A000 20 A6 84                  ..
        bcs     LA066                           ; A003 B0 61                    .a
        lda     #$80                            ; A005 A9 80                    ..
        sta     $1E                             ; A007 85 1E                    ..
        lda     #$1D                            ; A009 A9 1D                    ..
        sta     $23                             ; A00B 85 23                    .#
        lda     #$17                            ; A00D A9 17                    ..
        sta     $0588,x                         ; A00F 9D 88 05                 ...
        lda     #$A0                            ; A012 A9 A0                    ..
        sta     $05A0,x                         ; A014 9D A0 05                 ...
        lda     $1E                             ; A017 A5 1E                    ..
        bne     LA066                           ; A019 D0 4B                    .K
        sta     $9D                             ; A01B 85 9D                    ..
        sta     $78                             ; A01D 85 78                    .x
        sta     $79                             ; A01F 85 79                    .y
        lda     #$80                            ; A021 A9 80                    ..
        sta     $9B                             ; A023 85 9B                    ..
        lda     #$07                            ; A025 A9 07                    ..
        sta     $99                             ; A027 85 99                    ..
        lda     #$02                            ; A029 A9 02                    ..
        sta     $FD                             ; A02B 85 FD                    ..
        lda     #$E8                            ; A02D A9 E8                    ..
        sta     $EB                             ; A02F 85 EB                    ..
        lda     #$40                            ; A031 A9 40                    .@
        sta     $0588,x                         ; A033 9D 88 05                 ...
        lda     #$A0                            ; A036 A9 A0                    ..
        sta     $05A0,x                         ; A038 9D A0 05                 ...
        lda     #$30                            ; A03B A9 30                    .0
        sta     $0468,x                         ; A03D 9D 68 04                 .h.
        lda     #$6F                            ; A040 A9 6F                    .o
        sta     L0000                           ; A042 85 00                    ..
        lda     #$A2                            ; A044 A9 A2                    ..
        sta     $01                             ; A046 85 01                    ..
        jsr     L8420                           ; A048 20 20 84                   .
        bcs     LA066                           ; A04B B0 19                    ..
        lda     #$67                            ; A04D A9 67                    .g
        sta     $0588,x                         ; A04F 9D 88 05                 ...
        lda     #$A0                            ; A052 A9 A0                    ..
        sta     $05A0,x                         ; A054 9D A0 05                 ...
        lda     #$D2                            ; A057 A9 D2                    ..
        sta     $0468,x                         ; A059 9D 68 04                 .h.
        lda     #$02                            ; A05C A9 02
        sta     $0540,x                         ; A05E 9D 40 05
        lda     #$00                            ; A061 A9 00
        sta     $0570,x                         ; A063 9D 70 05
LA066:  rts                                     ; A066 60

; --- $A067: fight loop --------------------------------------------------------
        lda     $0468,x                         ; A067 BD 68 04                 .h.
        bne     LA0CF                           ; A06A D0 63                    .c
        lda     #$D2                            ; A06C A9 D2                    ..
        sta     $0468,x                         ; A06E 9D 68 04                 .h.
        lda     $E4                             ; A071 A5 E4                    ..
        adc     $E7                             ; A073 65 E7                    e.
        and     #$03                            ; A075 29 03                    ).
        beq     LA07B                           ; A077 F0 02                    ..
        lda     #$01                            ; A079 A9 01                    ..
LA07B:  sta     $11                             ; A07B 85 11                    ..
        sta     $12                             ; A07D 85 12                    ..
LA07F:  jsr     find_free_slot_y                           ; A07F 20 6F F1                  o.
        bcs     LA0CF                           ; A082 B0 4B                    .K
        lda     #$BE                            ; A084 A9 BE                    ..
        jsr     entity_init_pos                           ; A086 20 A4 EA                  ..
        lda     #$7B                            ; A089 A9 7B                    .{
        sta     $0300,y                         ; A08B 99 00 03                 ...
        lda     #$34                            ; A08E A9 34                    .4
        sta     $0378,y                         ; A090 99 78 03                 .x.
        lda     #$D8                            ; A093 A9 D8                    ..
        sta     $0330,y                         ; A095 99 30 03                 .0.
        lda     #$00                            ; A098 A9 00                    ..
        sta     $03D8,y                         ; A09A 99 D8 03                 ...
        lda     #$02                            ; A09D A9 02
        sta     $03F0,y                         ; A09F 99 F0 03 pet yvel 2 px/f down
LA0A2:  lda     $E4                             ; A0A2 A5 E4                    ..
        adc     $E5                             ; A0A4 65 E5                    e.
        sta     $E4                             ; A0A6 85 E4                    ..
        and     #$07                            ; A0A8 29 07                    ).
        tax                                     ; A0AA AA                       .
        lda     LA283,x                         ; A0AB BD 83 A2                 ...
        cmp     $12                             ; A0AE C5 12                    ..
        bne     LA0BA                           ; A0B0 D0 08                    ..
        inx                                     ; A0B2 E8                       .
        txa                                     ; A0B3 8A                       .
        and     #$07                            ; A0B4 29 07                    ).
        tax                                     ; A0B6 AA                       .
        lda     LA283,x                         ; A0B7 BD 83 A2                 ...
LA0BA:  sta     $0468,y                         ; A0BA 99 68 04                 .h.
        sta     $12                             ; A0BD 85 12                    ..
        lda     #$C0                            ; A0BF A9 C0                    ..
        sta     $0408,y                         ; A0C1 99 08 04                 ...
        lda     #$01                            ; A0C4 A9 01                    ..
        sta     $0450,y                         ; A0C6 99 50 04                 .P.
        ldx     $A6                             ; A0C9 A6 A6                    ..
        dec     $11                             ; A0CB C6 11                    ..
        bpl     LA07F                           ; A0CD 10 B0                    ..
LA0CF:  dec     $0468,x                         ; A0CF DE 68 04                 .h.
        lda     #$C2                            ; A0D2 A9 C2                    ..
        ldy     $78                             ; A0D4 A4 78                    .x
        beq     LA0DC                           ; A0D6 F0 04                    ..
        cpy     #$FF                            ; A0D8 C0 FF                    ..
        bne     LA0E6                           ; A0DA D0 0A                    ..
LA0DC:  ldy     $79                             ; A0DC A4 79                    .y
        beq     LA0E4                           ; A0DE F0 04                    ..
        cpy     #$FF                            ; A0E0 C0 FF                    ..
        bne     LA0E6                           ; A0E2 D0 02                    ..
LA0E4:  lda     #$C3                            ; A0E4 A9 C3                    ..
LA0E6:  cmp     $0558,x                         ; A0E6 DD 58 05                 .X.
        beq     LA0EE                           ; A0E9 F0 03                    ..
        jsr     entity_set_subtype                           ; A0EB 20 98 EA                  ..
LA0EE:  lda     $0540,x                         ; A0EE BD 40 05                 .@.
        cmp     #$02                            ; A0F1 C9 02                    ..
        bne     LA0FA                           ; A0F3 D0 05                    ..
        lda     #$00                            ; A0F5 A9 00                    ..
        sta     $0570,x                         ; A0F7 9D 70 05                 .p.
LA0FA:  lda     #$03                            ; A0FA A9 03                    ..
        ldy     $0558,x                         ; A0FC BC 58 05                 .X.
        cpy     #$C3                            ; A0FF C0 C3                    ..
        beq     LA105                           ; A101 F0 02                    ..
        lda     #$00                            ; A103 A9 00                    ..
LA105:  clc                                     ; A105 18                       .
        adc     $0540,x                         ; A106 7D 40 05                 }@.
        tay                                     ; A109 A8                       .
        lda     $0408,x                         ; A10A BD 08 04                 ...
        and     #$BF                            ; A10D 29 BF                    ).
        ora     LA28B,y                         ; A10F 19 8B A2                 ...
        sta     $0408,x                         ; A112 9D 08 04                 ...
LA115:  rts                                     ; A115 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $7A — BIG PETS ram row (two per fight, spawn code $5B;
; also the row-pair boss of the Wily 1 room). Each drives one BG scroll
; offset of the boss body: $78 (row at Y=$90) or $79 (other row) :=
; $D8 - own X ($A1CE). Idles until the HP bar is up ($2F bit 7) and the
; player is in play (state < 8); inert while Gravity Hold ($32==7) is
; equipped. A weapon hit ($EFF8 clear-carry) kills the shot
; (entity_wipe_y_checked) and knocks the row left at 4 px/f ($A12E);
; reaching X=$20 it shudders ($A165, X bit 0 toggle), crawls back right
; at 2 px/f ($A193), shudders again at X=$D8 ($A1AC), then re-arms.
; While extended it drags the player via the push vars $39-$3B and
; deals contact damage through shape $B2 + player_take_damage.
; =============================================================================
        lda     $2F                             ; A116 A5 2F                    ./
        bpl     LA115                           ; A118 10 FB                    ..
        lda     $30                             ; A11A A5 30                    .0
        cmp     #$08                            ; A11C C9 08                    ..
        bcs     LA115                           ; A11E B0 F5                    ..
        lda     $32                             ; A120 A5 32                    .2
        cmp     #$07                            ; A122 C9 07                    ..
        beq     LA115                           ; A124 F0 EF                    ..
        jsr     entity_hitbox_check                           ; A126 20 F8 EF                  ..
        bcc     LA12E                           ; A129 90 03                    ..
        jmp     LA1CE                           ; A12B 4C CE A1                 L..

; ----------------------------------------------------------------------------
LA12E:  ldy     $10                             ; A12E A4 10                    ..
        jsr     LF2F3                           ; A130 20 F3 F2                  ..
        lda     #$02                            ; A133 A9 02                    ..
        sta     $0420,x                         ; A135 9D 20 04                 . .
        lda     #$00                            ; A138 A9 00                    ..
        sta     $03A8,x                         ; A13A 9D A8 03                 ...
        lda     #$04                            ; A13D A9 04                    ..
        sta     $03C0,x                         ; A13F 9D C0 03                 ...
        lda     #$4C                            ; A142 A9 4C                    .L
        sta     $0588,x                         ; A144 9D 88 05                 ...
        lda     #$A1                            ; A147 A9 A1                    ..
        sta     $05A0,x                         ; A149 9D A0 05                 ...
        jsr     LA1F6                           ; A14C 20 F6 A1                  ..
        lda     $0330,x                         ; A14F BD 30 03                 .0.
        cmp     #$20                            ; A152 C9 20                    . 
        bne     LA1CE                           ; A154 D0 78                    .x
        lda     #$1E                            ; A156 A9 1E                    ..
        sta     $0468,x                         ; A158 9D 68 04                 .h.
        lda     #$65                            ; A15B A9 65                    .e
        sta     $0588,x                         ; A15D 9D 88 05                 ...
        lda     #$A1                            ; A160 A9 A1                    ..
        sta     $05A0,x                         ; A162 9D A0 05                 ...
        lda     $0468,x                         ; A165 BD 68 04                 .h.
        cmp     #$14                            ; A168 C9 14                    ..
        bcc     LA17A                           ; A16A 90 0E                    ..
        and     #$01                            ; A16C 29 01                    ).
        sta     L0000                           ; A16E 85 00                    ..
        lda     $0330,x                         ; A170 BD 30 03                 .0.
        and     #$F0                            ; A173 29 F0                    ).
        ora     L0000                           ; A175 05 00                    ..
        sta     $0330,x                         ; A177 9D 30 03                 .0.
LA17A:  dec     $0468,x                         ; A17A DE 68 04                 .h.
        bne     LA1CE                           ; A17D D0 4F                    .O
        lda     #$01                            ; A17F A9 01                    ..
        sta     $0420,x                         ; A181 9D 20 04                 . .
        lda     #$02                            ; A184 A9 02                    ..
        sta     $03C0,x                         ; A186 9D C0 03                 ...
        lda     #$93                            ; A189 A9 93
        sta     $0588,x                         ; A18B 9D 88 05
        lda     #$A1                            ; A18E A9 A1
        sta     $05A0,x                         ; A190 9D A0 05 behavior PC := $A193
; --- $A193: crawl back right --------------------------------------------------
        jsr     LA1F6                           ; A193 20 F6 A1                  ..
        lda     $0330,x                         ; A196 BD 30 03                 .0.
        cmp     #$D8                            ; A199 C9 D8                    ..
        bne     LA1CE                           ; A19B D0 31                    .1
        lda     #$AC                            ; A19D A9 AC                    ..
        sta     $0588,x                         ; A19F 9D 88 05                 ...
        lda     #$A1                            ; A1A2 A9 A1                    ..
        sta     $05A0,x                         ; A1A4 9D A0 05                 ...
        lda     #$06                            ; A1A7 A9 06                    ..
        sta     $0468,x                         ; A1A9 9D 68 04                 .h.
        dec     $0468,x                         ; A1AC DE 68 04                 .h.
        lda     $0468,x                         ; A1AF BD 68 04                 .h.
        pha                                     ; A1B2 48                       H
        and     #$01                            ; A1B3 29 01                    ).
        sta     L0000                           ; A1B5 85 00                    ..
        lda     $0330,x                         ; A1B7 BD 30 03                 .0.
        and     #$F8                            ; A1BA 29 F8                    ).
        ora     L0000                           ; A1BC 05 00                    ..
        sta     $0330,x                         ; A1BE 9D 30 03                 .0.
        pla                                     ; A1C1 68                       h
        bne     LA1CE                           ; A1C2 D0 0A                    ..
        lda     #$16                            ; A1C4 A9 16                    ..
        sta     $0588,x                         ; A1C6 9D 88 05                 ...
        lda     #$A1                            ; A1C9 A9 A1                    ..
        sta     $05A0,x                         ; A1CB 9D A0 05                 ...
LA1CE:  ldy     #$00                            ; A1CE A0 00                    ..
        lda     $0378,x                         ; A1D0 BD 78 03                 .x.
        cmp     #$90                            ; A1D3 C9 90                    ..
        beq     LA1D8                           ; A1D5 F0 01                    ..
        iny                                     ; A1D7 C8                       .
LA1D8:  lda     #$D8                            ; A1D8 A9 D8                    ..
        sec                                     ; A1DA 38                       8
        sbc     $0330,x                         ; A1DB FD 30 03                 .0.
        sta     $78,y                           ; A1DE 99 78 00                 .x.
        lda     $0408,x                         ; A1E1 BD 08 04                 ...
        pha                                     ; A1E4 48                       H
        lda     #$B2                            ; A1E5 A9 B2                    ..
        sta     $0408,x                         ; A1E7 9D 08 04                 ...
        jsr     entity_player_collide                           ; A1EA 20 87 EF                  ..
        pla                                     ; A1ED 68                       h
        sta     $0408,x                         ; A1EE 9D 08 04                 ...
        bcs     LA213                           ; A1F1 B0 20                    . 
        jmp     L82B8                           ; A1F3 4C B8 82                 L..

; ----------------------------------------------------------------------------
LA1F6:  jsr     entity_facing_dispatch                           ; A1F6 20 65 EA                  e.
        dec     $0378,x                         ; A1F9 DE 78 03                 .x.
        jsr     entity_player_collide                           ; A1FC 20 87 EF                  ..
        inc     $0378,x                         ; A1FF FE 78 03                 .x.
        bcs     LA213                           ; A202 B0 0F                    ..
        lda     $0420,x                         ; A204 BD 20 04                 . .
        sta     $39                             ; A207 85 39                    .9
        lda     $03A8,x                         ; A209 BD A8 03                 ...
        sta     $3A                             ; A20C 85 3A                    .:
        lda     $03C0,x                         ; A20E BD C0 03                 ...
        sta     $3B                             ; A211 85 3B                    .;
LA213:  rts                                     ; A213 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $7B — BIG PETS "pet" minion. Rises out of the mouth
; (entity_move_up_nofacing) until the collision flag $0390 trips, then
; teleports to the top (Y=0) at its target X ($0468, from LA283), and
; bounces diagonally at $01.6A px/f (facing + vert dispatch), dir
; ping-ponged every $16 frames (eor #$03 on $0420).
; =============================================================================
        jsr     entity_move_up_nofacing                           ; A214 20 4A E9                  J.
        lda     $0390,x                         ; A217 BD 90 03                 ...
        beq     LA26E                           ; A21A F0 52                    .R
        lda     #$00                            ; A21C A9 00                    ..
        sta     $0390,x                         ; A21E 9D 90 03                 ...
        sta     $0378,x                         ; A221 9D 78 03                 .x.
        lda     $0468,x                         ; A224 BD 68 04                 .h.
        sta     $0330,x                         ; A227 9D 30 03                 .0.
        lda     #$6A                            ; A22A A9 6A                    .j
        sta     $03A8,x                         ; A22C 9D A8 03                 ...
        sta     $03D8,x                         ; A22F 9D D8 03                 ...
        lda     #$01                            ; A232 A9 01                    ..
        sta     $03C0,x                         ; A234 9D C0 03                 ...
        sta     $03F0,x                         ; A237 9D F0 03                 ...
        lda     #$06                            ; A23A A9 06                    ..
        sta     $0420,x                         ; A23C 9D 20 04                 . .
        lda     #$16                            ; A23F A9 16                    ..
        sta     $0468,x                         ; A241 9D 68 04                 .h.
        lda     #$4E                            ; A244 A9 4E                    .N
        sta     $0588,x                         ; A246 9D 88 05                 ...
        lda     #$A2                            ; A249 A9 A2                    ..
        sta     $05A0,x                         ; A24B 9D A0 05                 ...
        lda     $0528,x                         ; A24E BD 28 05                 .(.
        pha                                     ; A251 48                       H
        jsr     entity_facing_dispatch                           ; A252 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A255 20 86 EA                  ..
        pla                                     ; A258 68                       h
        sta     $0528,x                         ; A259 9D 28 05                 .(.
        dec     $0468,x                         ; A25C DE 68 04                 .h.
        bne     LA26E                           ; A25F D0 0D                    ..
        lda     #$16                            ; A261 A9 16                    ..
        sta     $0468,x                         ; A263 9D 68 04                 .h.
        lda     $0420,x                         ; A266 BD 20 04                 . .
        eor     #$03                            ; A269 49 03                    I.
        sta     $0420,x                         ; A26B 9D 20 04                 . .
LA26E:  rts                                     ; A26E 60                       `

; ----------------------------------------------------------------------------
; Big Pets data: fade-in palette (5 rows for $1C:8420), pet target Xs,
; face vflip overlay bits by anim phase (+3 when mouth open, $C3).
; ----------------------------------------------------------------------------
        .byte   $0F,$36,$16,$06                 ; A26F  palette
        .byte   $0F,$30,$10,$00                 ; A273
        .byte   $0F,$30,$21,$11                 ; A277
        .byte   $0F,$0F,$20,$21                 ; A27B
        .byte   $0F,$0F,$20,$2B                 ; A27F
LA283:  .byte   $20,$60,$A0,$40,$80,$20,$60,$A0 ; A283  pet target X
LA28B:  .byte   $00,$00,$40,$40,$00,$00         ; A28B  face vflip bits
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $7C — CIRCRING Q9 (Wily 2 boss; spawn code $5C in bank
; $0D scr $18). Another IRQ-split background boss (mode $19): after the
; $84A6/$1E handshake, $84D5 resets the special screen, CHR R0 := $EA,
; camera Y $FA=$40, palette $A5A4 fade + HP fill ($1C:8420). Spawns its
; escort: two floor crawlers (type $7D via LA4E4, at X=$34/$C4) and two
; orbiting pods (type $B1 via LA515, angles $E4/$1C) — then centers at
; ($80,$58) and circles ($A33E): angle $0480 advances every 4 frames
; through dir table LA5B8 at speed 8, camera tracks it ($A458: $FA/$78
; := center - own pos). Every $3C frames it drops an aimed bomb (type
; $7E via LA469). Each full lap (angle $3F) it dashes ($A3D0): speed
; $01.33/$00.D9 at the player, 4 reversals timed by LA5E8/LA5EC, an
; aimed shot (type $7F via LA4B9) on every other reversal, then back to
; circling. Eye opens on a random cadence (LA5FF): anim phase steps
; through LA603, shape $F3 (eye open, vulnerable) vs $A9 (closed).
; =============================================================================
        jsr     L84A6                           ; A291 20 A6 84                  ..
        bcs     LA26E                           ; A294 B0 D8                    ..
        lda     #$80                            ; A296 A9 80                    ..
        sta     $1E                             ; A298 85 1E                    ..
        lda     #$19                            ; A29A A9 19
        sta     $23                             ; A29C 85 23    IRQ split mode $19
        lda     #$A8                            ; A29E A9 A8                    ..
        sta     $0588,x                         ; A2A0 9D 88 05                 ...
        lda     #$A2                            ; A2A3 A9 A2                    ..
        sta     $05A0,x                         ; A2A5 9D A0 05                 ...
        lda     $1E                             ; A2A8 A5 1E                    ..
        bne     LA26E                           ; A2AA D0 C2                    ..
        jsr     L84D5                           ; A2AC 20 D5 84                  ..
        lda     #$EA                            ; A2AF A9 EA                    ..
        sta     $EA                             ; A2B1 85 EA                    ..
        lda     #$C6                            ; A2B3 A9 C6                    ..
        sta     $0588,x                         ; A2B5 9D 88 05                 ...
        lda     #$A2                            ; A2B8 A9 A2                    ..
        sta     $05A0,x                         ; A2BA 9D A0 05                 ...
        lda     #$30                            ; A2BD A9 30                    .0
        sta     $0468,x                         ; A2BF 9D 68 04                 .h.
        lda     #$40                            ; A2C2 A9 40                    .@
        sta     $FA                             ; A2C4 85 FA                    ..
        lda     #$A4                            ; A2C6 A9 A4                    ..
        sta     L0000                           ; A2C8 85 00                    ..
        lda     #$A5                            ; A2CA A9 A5                    ..
        sta     $01                             ; A2CC 85 01                    ..
        jsr     L8420                           ; A2CE 20 20 84                   .
        bcs     LA337                           ; A2D1 B0 64                    .d
        jsr     LA4E4                           ; A2D3 20 E4 A4                  ..
        lda     #$0A                            ; A2D6 A9 0A                    ..
        sta     $0420,y                         ; A2D8 99 20 04                 . .
        lda     #$34                            ; A2DB A9 34                    .4
        sta     $0330,y                         ; A2DD 99 30 03                 .0.
        jsr     LA4E4                           ; A2E0 20 E4 A4                  ..
        lda     #$09                            ; A2E3 A9 09                    ..
        sta     $0420,y                         ; A2E5 99 20 04                 . .
        lda     #$C4                            ; A2E8 A9 C4                    ..
        sta     $0330,y                         ; A2EA 99 30 03                 .0.
        jsr     LA515                           ; A2ED 20 15 A5                  ..
        lda     #$3C                            ; A2F0 A9 3C                    .<
        sta     $0378,y                         ; A2F2 99 78 03                 .x.
        lda     #$E4                            ; A2F5 A9 E4                    ..
        sta     $0480,y                         ; A2F7 99 80 04                 ...
        jsr     LA515                           ; A2FA 20 15 A5                  ..
        lda     #$74                            ; A2FD A9 74                    .t
        sta     $0378,y                         ; A2FF 99 78 03                 .x.
        lda     #$1C                            ; A302 A9 1C                    ..
        sta     $0480,y                         ; A304 99 80 04                 ...
        lda     #$80                            ; A307 A9 80                    ..
        sta     $0330,x                         ; A309 9D 30 03                 .0.
        lda     #$58                            ; A30C A9 58                    .X
        sta     $0378,x                         ; A30E 9D 78 03                 .x.
        lda     $E4                             ; A311 A5 E4                    ..
        and     #$03                            ; A313 29 03                    ).
        tay                                     ; A315 A8                       .
        lda     LA5FF,y                         ; A316 B9 FF A5                 ...
        sta     $04E0,x                         ; A319 9D E0 04                 ...
        lda     #$3E                            ; A31C A9 3E                    .>
        sta     $0588,x                         ; A31E 9D 88 05                 ...
        lda     #$A3                            ; A321 A9 A3                    ..
        sta     $05A0,x                         ; A323 9D A0 05                 ...
        lda     #$02                            ; A326 A9 02                    ..
        sta     $0468,x                         ; A328 9D 68 04                 .h.
        lda     #$3C                            ; A32B A9 3C                    .<
        sta     $0498,x                         ; A32D 9D 98 04                 ...
        lda     #$3F                            ; A330 A9 3F                    .?
        sta     $0480,x                         ; A332 9D 80 04                 ...
        bne     LA358                           ; A335 D0 21                    .!
LA337:  rts                                     ; A337 60                       `

; ----------------------------------------------------------------------------
LA338:  dec     $04C8,x                         ; A338 DE C8 04                 ...
LA33B:  jmp     LA421                           ; A33B 4C 21 A4                 L!.

; ----------------------------------------------------------------------------
        lda     $04C8,x                         ; A33E BD C8 04                 ...
        bne     LA338                           ; A341 D0 F5                    ..
        lda     $0468,x                         ; A343 BD 68 04                 .h.
        bne     LA368                           ; A346 D0 20                    . 
        lda     #$04                            ; A348 A9 04                    ..
        sta     $0468,x                         ; A34A 9D 68 04                 .h.
        inc     $0480,x                         ; A34D FE 80 04                 ...
        lda     $0480,x                         ; A350 BD 80 04                 ...
        and     #$3F                            ; A353 29 3F                    )?
        sta     $0480,x                         ; A355 9D 80 04                 ...
LA358:  cmp     #$20                            ; A358 C9 20                    . 
        bcc     LA35E                           ; A35A 90 02                    ..
        sbc     #$10                            ; A35C E9 10                    ..
LA35E:  tay                                     ; A35E A8                       .
        lda     LA5B8,y                         ; A35F B9 B8 A5                 ...
        tay                                     ; A362 A8                       .
        lda     #$08                            ; A363 A9 08                    ..
        jsr     entity_set_dir_velocity                           ; A365 20 70 F4                  p.
LA368:  dec     $0468,x                         ; A368 DE 68 04                 .h.
        jsr     entity_facing_dispatch                           ; A36B 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A36E 20 86 EA                  ..
        dec     $0498,x                         ; A371 DE 98 04                 ...
        bne     LA37E                           ; A374 D0 08                    ..
        lda     #$3C                            ; A376 A9 3C                    .<
        sta     $0498,x                         ; A378 9D 98 04                 ...
        jsr     LA469                           ; A37B 20 69 A4                  i.
LA37E:  lda     $0480,x                         ; A37E BD 80 04                 ...
        cmp     #$3F                            ; A381 C9 3F                    .?
        bne     LA33B                           ; A383 D0 B6                    ..
        lda     $0468,x                         ; A385 BD 68 04                 .h.
        cmp     #$02                            ; A388 C9 02                    ..
        bne     LA33B                           ; A38A D0 AF                    ..
        lda     #$D0                            ; A38C A9 D0                    ..
        sta     $0588,x                         ; A38E 9D 88 05                 ...
        lda     #$A3                            ; A391 A9 A3                    ..
        sta     $05A0,x                         ; A393 9D A0 05                 ...
        lda     #$33                            ; A396 A9 33                    .3
        sta     $03A8,x                         ; A398 9D A8 03                 ...
        lda     #$01                            ; A39B A9 01                    ..
        sta     $03C0,x                         ; A39D 9D C0 03                 ...
        lda     #$D9                            ; A3A0 A9 D9                    ..
        sta     $03D8,x                         ; A3A2 9D D8 03                 ...
        lda     #$00                            ; A3A5 A9 00                    ..
        sta     $03F0,x                         ; A3A7 9D F0 03                 ...
        jsr     entity_set_facing                           ; A3AA 20 16 EC                  ..
        lda     $0420,x                         ; A3AD BD 20 04                 . .
        ora     #$04                            ; A3B0 09 04                    ..
        sta     $0420,x                         ; A3B2 9D 20 04                 . .
        lda     #$42                            ; A3B5 A9 42                    .B
        sta     $0498,x                         ; A3B7 9D 98 04                 ...
        sta     $04C8,x                         ; A3BA 9D C8 04                 ...
        lda     #$03                            ; A3BD A9 03                    ..
        sta     $04B0,x                         ; A3BF 9D B0 04                 ...
        ldy     $0540,x                         ; A3C2 BC 40 05                 .@.
        lda     LA603,y                         ; A3C5 B9 03 A6                 ...
        sta     $0540,x                         ; A3C8 9D 40 05                 .@.
        lda     #$F3                            ; A3CB A9 F3                    ..
        sta     $0408,x                         ; A3CD 9D 08 04                 ...
        lda     $0540,x                         ; A3D0 BD 40 05                 .@.
        cmp     #$10                            ; A3D3 C9 10                    ..
        bne     LA3DC                           ; A3D5 D0 05                    ..
        lda     #$00                            ; A3D7 A9 00                    ..
        sta     $0570,x                         ; A3D9 9D 70 05                 .p.
LA3DC:  lda     $04C8,x                         ; A3DC BD C8 04                 ...
        bne     LA41E                           ; A3DF D0 3D                    .=
        jsr     entity_facing_dispatch                           ; A3E1 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A3E4 20 86 EA                  ..
        dec     $0498,x                         ; A3E7 DE 98 04                 ...
        bne     LA421                           ; A3EA D0 35                    .5
        lda     #$42                            ; A3EC A9 42                    .B
        sta     $0498,x                         ; A3EE 9D 98 04                 ...
        ldy     $04B0,x                         ; A3F1 BC B0 04                 ...
        lda     $0420,x                         ; A3F4 BD 20 04                 . .
        eor     #$0C                            ; A3F7 49 0C                    I.
        eor     LA5E8,y                         ; A3F9 59 E8 A5                 Y..
        sta     $0420,x                         ; A3FC 9D 20 04                 . .
        lda     LA5EC,y                         ; A3FF B9 EC A5                 ...
        sta     $04C8,x                         ; A402 9D C8 04                 ...
        lda     $04B0,x                         ; A405 BD B0 04                 ...
        and     #$01                            ; A408 29 01                    ).
        beq     LA40F                           ; A40A F0 03                    ..
        jsr     LA4B9                           ; A40C 20 B9 A4                  ..
LA40F:  dec     $04B0,x                         ; A40F DE B0 04                 ...
        bpl     LA421                           ; A412 10 0D                    ..
        lda     #$07                            ; A414 A9 07                    ..
        sta     $0588,x                         ; A416 9D 88 05                 ...
        lda     #$A3                            ; A419 A9 A3                    ..
        sta     $05A0,x                         ; A41B 9D A0 05                 ...
LA41E:  dec     $04C8,x                         ; A41E DE C8 04                 ...
LA421:  lda     $0540,x                         ; A421 BD 40 05                 .@.
        cmp     #$13                            ; A424 C9 13                    ..
        bcc     LA42F                           ; A426 90 07                    ..
        lda     #$A9                            ; A428 A9 A9                    ..
        sta     $0408,x                         ; A42A 9D 08 04                 ...
        bne     LA458                           ; A42D D0 29                    .)
LA42F:  lda     $0540,x                         ; A42F BD 40 05                 .@.
        bne     LA458                           ; A432 D0 24                    .$
        sta     $0570,x                         ; A434 9D 70 05                 .p.
        lda     #$A9                            ; A437 A9 A9                    ..
        sta     $0408,x                         ; A439 9D 08 04                 ...
        dec     $04E0,x                         ; A43C DE E0 04                 ...
        bne     LA458                           ; A43F D0 17                    ..
        lda     $E4                             ; A441 A5 E4                    ..
        adc     $E5                             ; A443 65 E5                    e.
        sta     $E5                             ; A445 85 E5                    ..
        and     #$03                            ; A447 29 03                    ).
        tay                                     ; A449 A8                       .
        lda     LA5FF,y                         ; A44A B9 FF A5                 ...
        sta     $04E0,x                         ; A44D 9D E0 04                 ...
        inc     $0540,x                         ; A450 FE 40 05                 .@.
        lda     #$F3                            ; A453 A9 F3                    ..
        sta     $0408,x                         ; A455 9D 08 04                 ...
LA458:  lda     #$98                            ; A458 A9 98                    ..
        sec                                     ; A45A 38                       8
        sbc     $0378,x                         ; A45B FD 78 03                 .x.
        sta     $FA                             ; A45E 85 FA                    ..
        lda     #$80                            ; A460 A9 80                    ..
        sec                                     ; A462 38                       8
        sbc     $0330,x                         ; A463 FD 30 03                 .0.
        sta     $78                             ; A466 85 78                    .x
        rts                                     ; A468 60                       `

; --- LA469: drop an aimed bomb — type $7E, sub $BB, from $44 above own Y;
; yvel $03.7A down, xvel toward the player scaled by distance (LA5F0/F5/FA)
LA469:  jsr     find_free_slot_y                           ; A469 20 6F F1                  o.
        bcs     LA4B8                           ; A46C B0 4A                    .J
        lda     #$BB                            ; A46E A9 BB                    ..
        jsr     entity_init_pos                           ; A470 20 A4 EA                  ..
        lda     #$7E                            ; A473 A9 7E                    .~
        sta     $0300,y                         ; A475 99 00 03                 ...
        lda     #$80                            ; A478 A9 80                    ..
        sta     $0408,y                         ; A47A 99 08 04                 ...
        lda     $0378,x                         ; A47D BD 78 03                 .x.
        sec                                     ; A480 38                       8
        sbc     #$44                            ; A481 E9 44                    .D
        sta     $0378,y                         ; A483 99 78 03                 .x.
        lda     $0390,x                         ; A486 BD 90 03                 ...
        sbc     #$00                            ; A489 E9 00                    ..
        sta     $0390,y                         ; A48B 99 90 03                 ...
        lda     #$7A                            ; A48E A9 7A                    .z
        sta     $03D8,y                         ; A490 99 D8 03                 ...
        lda     #$03                            ; A493 A9 03                    ..
        sta     $03F0,y                         ; A495 99 F0 03                 ...
        tya                                     ; A498 98                       .
        tax                                     ; A499 AA                       .
        jsr     entity_set_facing                           ; A49A 20 16 EC                  ..
        jsr     entity_x_dist_px                           ; A49D 20 94 EC                  ..
        ldy     #$04                            ; A4A0 A0 04                    ..
LA4A2:  cmp     LA5F0,y                         ; A4A2 D9 F0 A5                 ...
        bcs     LA4AA                           ; A4A5 B0 03                    ..
        dey                                     ; A4A7 88                       .
        bne     LA4A2                           ; A4A8 D0 F8                    ..
LA4AA:  lda     LA5F5,y                         ; A4AA B9 F5 A5                 ...
        sta     $03A8,x                         ; A4AD 9D A8 03                 ...
        lda     LA5FA,y                         ; A4B0 B9 FA A5                 ...
        sta     $03C0,x                         ; A4B3 9D C0 03                 ...
        ldx     $A6                             ; A4B6 A6 A6                    ..
LA4B8:  rts                                     ; A4B8 60                       `

; --- LA4B9: fire an aimed shot — type $7F, sub $BC, from $14 below own Y,
; 16-dir at the player, speed $28
LA4B9:  jsr     find_free_slot_y                           ; A4B9 20 6F F1                  o.
        bcs     LA4E3                           ; A4BC B0 25                    .%
        lda     #$BC                            ; A4BE A9 BC                    ..
        jsr     entity_init_pos                           ; A4C0 20 A4 EA                  ..
        lda     #$7F                            ; A4C3 A9 7F                    ..
        sta     $0300,y                         ; A4C5 99 00 03                 ...
        lda     #$85                            ; A4C8 A9 85                    ..
        sta     $0408,y                         ; A4CA 99 08 04                 ...
        lda     $0378,x                         ; A4CD BD 78 03                 .x.
        clc                                     ; A4D0 18                       .
        adc     #$14                            ; A4D1 69 14                    i.
        sta     $0378,y                         ; A4D3 99 78 03                 .x.
        tya                                     ; A4D6 98                       .
        tax                                     ; A4D7 AA                       .
        jsr     entity_distance_calc                           ; A4D8 20 C2 EC                  ..
        tay                                     ; A4DB A8                       .
        lda     #$28                            ; A4DC A9 28                    .(
        jsr     entity_set_dir_velocity                           ; A4DE 20 70 F4                  p.
        ldx     $A6                             ; A4E1 A6 A6                    ..
LA4E3:  rts                                     ; A4E3 60                       `

; --- LA4E4: spawn a floor crawler — type $7D, sub $BD, at Y=$BC, xvel $00.66
LA4E4:  jsr     find_free_slot_y                           ; A4E4 20 6F F1                  o.
        lda     #$BD                            ; A4E7 A9 BD                    ..
        jsr     entity_init_pos                           ; A4E9 20 A4 EA                  ..
        lda     $0528,y                         ; A4EC B9 28 05                 .(.
        ora     #$01                            ; A4EF 09 01                    ..
        sta     $0528,y                         ; A4F1 99 28 05                 .(.
        lda     #$7D                            ; A4F4 A9 7D                    .}
        sta     $0300,y                         ; A4F6 99 00 03                 ...
        lda     #$22                            ; A4F9 A9 22                    ."
        sta     $0408,y                         ; A4FB 99 08 04                 ...
        lda     #$BC                            ; A4FE A9 BC                    ..
        sta     $0378,y                         ; A500 99 78 03                 .x.
        lda     #$66                            ; A503 A9 66                    .f
        sta     $03A8,y                         ; A505 99 A8 03                 ...
        sta     $03D8,y                         ; A508 99 D8 03                 ...
        lda     #$00                            ; A50B A9 00                    ..
        sta     $03C0,y                         ; A50D 99 C0 03                 ...
        sta     $03F0,y                         ; A510 99 F0 03                 ...
        tya                                     ; A513 98                       .
        rts                                     ; A514 60                       `

; --- LA515: spawn an orbiting pod — type $B1 (generic orbiter, bank $1D),
; sub $62, linked to this slot via $0468; start angle set by the caller
LA515:  jsr     find_free_slot_y                           ; A515 20 6F F1                  o.
        lda     #$62                            ; A518 A9 62                    .b
        jsr     entity_init_pos                           ; A51A 20 A4 EA                  ..
        lda     #$B1                            ; A51D A9 B1                    ..
        sta     $0300,y                         ; A51F 99 00 03                 ...
        lda     #$EA                            ; A522 A9 EA                    ..
        sta     $0408,y                         ; A524 99 08 04                 ...
        lda     $0330,x                         ; A527 BD 30 03                 .0.
        sta     $0330,y                         ; A52A 99 30 03                 .0.
        txa                                     ; A52D 8A                       .
        sta     $0468,y                         ; A52E 99 68 04                 .h.
        tya                                     ; A531 98                       .
        rts                                     ; A532 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $7E — Circring Q9 falling bomb: plain ballistic drop.
; =============================================================================
        jsr     entity_process_y_vel                           ; A533 20 68 E9                  h.
        jmp     entity_facing_dispatch                           ; A536 4C 65 EA                 Le.

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $7D — Circring Q9 floor crawler: paces the arena floor,
; shoving the player via push vars $39-$3B (zeroed beyond $12 px) and
; hurting on contact (Y-1 collide probe). Direction (and push) reverses
; every $82 frames (eor #$0F); when the flip sets bit 3 it snaps back
; to the floor (Y=$BC) and re-enters at $A539.
; =============================================================================
        dec     $0378,x                         ; A539 DE 78 03                 .x.
        jsr     entity_player_collide                           ; A53C 20 87 EF                  ..
        inc     $0378,x                         ; A53F FE 78 03                 .x.
        bcs     LA5A3                           ; A542 B0 5F                    ._
        lda     #$82                            ; A544 A9 82                    ..
        sta     $0468,x                         ; A546 9D 68 04                 .h.
        lda     #$53                            ; A549 A9 53                    .S
        sta     $0588,x                         ; A54B 9D 88 05                 ...
        lda     #$A5                            ; A54E A9 A5                    ..
        sta     $05A0,x                         ; A550 9D A0 05                 ...
        dec     $0378,x                         ; A553 DE 78 03                 .x.
        jsr     entity_player_collide                           ; A556 20 87 EF                  ..
        inc     $0378,x                         ; A559 FE 78 03                 .x.
        bcs     LA578                           ; A55C B0 1A                    ..
        lda     $0420,x                         ; A55E BD 20 04                 . .
        sta     $39                             ; A561 85 39                    .9
        lda     $03A8,x                         ; A563 BD A8 03                 ...
        sta     $3A                             ; A566 85 3A                    .:
        lda     $03C0,x                         ; A568 BD C0 03                 ...
        sta     $3B                             ; A56B 85 3B                    .;
        jsr     entity_x_dist_px                           ; A56D 20 94 EC                  ..
        cmp     #$12                            ; A570 C9 12                    ..
        bcc     LA578                           ; A572 90 04                    ..
        lda     #$00                            ; A574 A9 00                    ..
        sta     $39                             ; A576 85 39                    .9
LA578:  jsr     entity_facing_dispatch                           ; A578 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A57B 20 86 EA                  ..
        dec     $0468,x                         ; A57E DE 68 04                 .h.
        bne     LA5A3                           ; A581 D0 20                    . 
        lda     #$82                            ; A583 A9 82                    ..
        sta     $0468,x                         ; A585 9D 68 04                 .h.
        lda     $0420,x                         ; A588 BD 20 04                 . .
        eor     #$0F                            ; A58B 49 0F                    I.
        sta     $0420,x                         ; A58D 9D 20 04                 . .
        and     #$08                            ; A590 29 08                    ).
        beq     LA5A3                           ; A592 F0 0F                    ..
        lda     #$BC                            ; A594 A9 BC                    ..
        sta     $0378,x                         ; A596 9D 78 03                 .x.
        lda     #$39                            ; A599 A9 39                    .9
        sta     $0588,x                         ; A59B 9D 88 05                 ...
        lda     #$A5                            ; A59E A9 A5                    ..
        sta     $05A0,x                         ; A5A0 9D A0 05                 ...
LA5A3:  rts                                     ; A5A3 60                       `

; ----------------------------------------------------------------------------
; Circring Q9 data: fade-in palette (5 rows for $1C:8420), circle dir
; sequence, dash-reversal dir/pause, bomb xvel by distance, eye-open
; cadence, anim-phase step map.
; ----------------------------------------------------------------------------
        .byte   $0F,$37,$27,$03                 ; A5A4  palette
        .byte   $0F,$30,$2B,$1B                 ; A5A8
        .byte   $0F,$30,$14,$03                 ; A5AC
        .byte   $0F,$0F,$37,$27                 ; A5B0
        .byte   $0F,$30,$10,$1C                 ; A5B4
LA5B8:  .byte   $09,$0A,$0B,$0C,$0D,$0E,$0F,$00 ; A5B8  circle: 16-dir by angle
        .byte   $0F,$0E,$0D,$0C,$0B,$0A,$09,$08 ; A5C0
        .byte   $07,$06,$05,$04,$03,$02,$01,$00 ; A5C8
        .byte   $01,$02,$03,$04,$05,$06,$07,$08 ; A5D0
        .byte   $09,$0A,$0B,$0C,$0D,$0E,$0F,$00 ; A5D8
        .byte   $0F,$0E,$0D,$0C,$0B,$0A,$09,$08 ; A5E0
LA5E8:  .byte   $00,$03,$00,$03                 ; A5E8  dash reversal dir eor
LA5EC:  .byte   $3C,$00,$00,$00                 ; A5EC  dash reversal pause
LA5F0:  .byte   $40,$60,$80,$A0,$C0             ; A5F0  bomb: player dist steps
LA5F5:  .byte   $47,$EB,$8F,$33,$D7             ; A5F5  bomb xvel sub
LA5FA:  .byte   $01,$01,$02,$03,$03             ; A5FA  bomb xvel px
LA5FF:  .byte   $1E,$3C,$5A,$78                 ; A5FF  eye-open cadence (rnd)
LA603:  .byte   $01,$01,$10,$10,$10,$10,$10,$10 ; A603  anim phase step map
        .byte   $10,$10,$10,$10,$10,$10,$10,$10 ; A60B
        .byte   $10,$10,$01,$01,$01,$01,$01     ; A613
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $A0 — WILY PRESS (Wily 3+4 boss; spawned in bank $0E
; scr $04 past the teleporter hub). Background boss in a vertical room
; (IRQ mode $07, vscroll_flag $46 on): $84A6/$1E handshake, $84D5
; screen reset, camera Y $FA=$B0, palette $A7BD fade + HP fill
; ($1C:8420), then spawns its type $A1 underside rider and picks a
; move duration from LA7D5/LA7D9 (16-bit), falling at 2 px/f. Cruise
; ($A69F): stalks the player horizontally (re-aims every $14 frames,
; bounces off X $39/$C8), mouth anim swap at phase 2 (sub $55/$56/$57),
; until the duration runs out -> slam ($A719): dir=down, drops $20 px
; per burst; on the down-burst spawns a type $6D floor-hit effect at
; Y=$80, on the up-burst re-randomizes and resumes cruising. Camera and
; both BG split rows track it ($A781: $FA/$78/$9B/$79 from own X/Y);
; shape by sub_type via LA77C read ($A7D1-$A7D3: $89/$89/$C9).
; =============================================================================
        jsr     L84A6                           ; A61A 20 A6 84
        bcs     LA5A3                           ; A61D B0 84
        lda     #$80                            ; A61F A9 80
        sta     $1E                             ; A621 85 1E
        lda     #$07                            ; A623 A9 07
        sta     $23                             ; A625 85 23    IRQ split mode $07
        lda     #$31                            ; A627 A9 31                    .1
        sta     $0588,x                         ; A629 9D 88 05                 ...
        lda     #$A6                            ; A62C A9 A6                    ..
        sta     $05A0,x                         ; A62E 9D A0 05                 ...
        lda     $1E                             ; A631 A5 1E                    ..
        bne     LA69E                           ; A633 D0 69                    .i
        jsr     L84D5                           ; A635 20 D5 84                  ..
        inc     $46                             ; A638 E6 46                    .F
        lda     #$4D                            ; A63A A9 4D                    .M
        sta     $0588,x                         ; A63C 9D 88 05                 ...
        lda     #$A6                            ; A63F A9 A6                    ..
        sta     $05A0,x                         ; A641 9D A0 05                 ...
        lda     #$30                            ; A644 A9 30                    .0
        sta     $0468,x                         ; A646 9D 68 04                 .h.
        lda     #$B0                            ; A649 A9 B0                    ..
        sta     $FA                             ; A64B 85 FA                    ..
        lda     #$BD                            ; A64D A9 BD                    ..
        sta     L0000                           ; A64F 85 00                    ..
        lda     #$A7                            ; A651 A9 A7                    ..
        sta     $01                             ; A653 85 01                    ..
        jsr     L8420                           ; A655 20 20 84                   .
        bcs     LA69E                           ; A658 B0 44                    .D
        jsr     find_free_slot_y                           ; A65A 20 6F F1                  o.
        lda     #$62                            ; A65D A9 62                    .b
        jsr     entity_init_pos                           ; A65F 20 A4 EA                  ..
        lda     #$A1                            ; A662 A9 A1                    ..
        sta     $0300,y                         ; A664 99 00 03                 ...
        lda     #$38                            ; A667 A9 38                    .8
        sta     $0378,y                         ; A669 99 78 03                 .x.
        lda     #$DD                            ; A66C A9 DD                    ..
        sta     $0408,y                         ; A66E 99 08 04                 ...
        txa                                     ; A671 8A                       .
        sta     $0468,y                         ; A672 99 68 04                 .h.
        lda     $E4                             ; A675 A5 E4                    ..
        adc     $E6                             ; A677 65 E6                    e.
        sta     $E6                             ; A679 85 E6                    ..
        and     #$03                            ; A67B 29 03                    ).
        tay                                     ; A67D A8                       .
        lda     LA7D5,y                         ; A67E B9 D5 A7                 ...
        sta     $0468,x                         ; A681 9D 68 04                 .h.
        lda     LA7D9,y                         ; A684 B9 D9 A7                 ...
        sta     $0480,x                         ; A687 9D 80 04                 ...
        lda     #$00                            ; A68A A9 00                    ..
        sta     $03D8,x                         ; A68C 9D D8 03                 ...
        lda     #$02                            ; A68F A9 02                    ..
        sta     $03F0,x                         ; A691 9D F0 03                 ...
        lda     #$9F                            ; A694 A9 9F                    ..
        sta     $0588,x                         ; A696 9D 88 05                 ...
        lda     #$A6                            ; A699 A9 A6                    ..
        sta     $05A0,x                         ; A69B 9D A0 05                 ...
LA69E:  rts                                     ; A69E 60                       `

; ----------------------------------------------------------------------------
        lda     #$55                            ; A69F A9 55                    .U
        cmp     $0558,x                         ; A6A1 DD 58 05                 .X.
        beq     LA6B0                           ; A6A4 F0 0A                    ..
        ldy     $0540,x                         ; A6A6 BC 40 05                 .@.
        cpy     #$02                            ; A6A9 C0 02                    ..
        bne     LA6B0                           ; A6AB D0 03                    ..
        jsr     entity_set_subtype                           ; A6AD 20 98 EA                  ..
LA6B0:  lda     $0498,x                         ; A6B0 BD 98 04                 ...
        bne     LA6BD                           ; A6B3 D0 08                    ..
        lda     #$14                            ; A6B5 A9 14                    ..
        sta     $0498,x                         ; A6B7 9D 98 04                 ...
        jsr     entity_set_facing                           ; A6BA 20 16 EC                  ..
LA6BD:  jsr     entity_facing_dispatch                           ; A6BD 20 65 EA                  e.
        lda     $0528,x                         ; A6C0 BD 28 05                 .(.
        and     #$DF                            ; A6C3 29 DF                    ).
        sta     $0528,x                         ; A6C5 9D 28 05                 .(.
        lda     $0420,x                         ; A6C8 BD 20 04                 . .
        and     #$01                            ; A6CB 29 01                    ).
        beq     LA6D8                           ; A6CD F0 09                    ..
        lda     $0330,x                         ; A6CF BD 30 03                 .0.
        cmp     #$C8                            ; A6D2 C9 C8                    ..
        bcs     LA6DF                           ; A6D4 B0 09                    ..
        bcc     LA6E7                           ; A6D6 90 0F                    ..
LA6D8:  lda     $0330,x                         ; A6D8 BD 30 03                 .0.
        cmp     #$39                            ; A6DB C9 39                    .9
        bcs     LA6E7                           ; A6DD B0 08                    ..
LA6DF:  lda     $0420,x                         ; A6DF BD 20 04                 . .
        eor     #$03                            ; A6E2 49 03                    I.
        sta     $0420,x                         ; A6E4 9D 20 04                 . .
LA6E7:  dec     $0498,x                         ; A6E7 DE 98 04                 ...
        lda     $0468,x                         ; A6EA BD 68 04                 .h.
        sec                                     ; A6ED 38                       8
        sbc     #$01                            ; A6EE E9 01                    ..
        sta     $0468,x                         ; A6F0 9D 68 04                 .h.
        lda     $0480,x                         ; A6F3 BD 80 04                 ...
        sbc     #$00                            ; A6F6 E9 00                    ..
        sta     $0480,x                         ; A6F8 9D 80 04                 ...
        ora     $0468,x                         ; A6FB 1D 68 04                 .h.
        bne     LA741                           ; A6FE D0 41                    .A
        lda     #$08                            ; A700 A9 08                    ..
        sta     $0420,x                         ; A702 9D 20 04                 . .
        lda     #$32                            ; A705 A9 32                    .2
        sta     $0498,x                         ; A707 9D 98 04                 ...
        lda     #$19                            ; A70A A9 19                    ..
        sta     $0588,x                         ; A70C 9D 88 05                 ...
        lda     #$A7                            ; A70F A9 A7                    ..
        sta     $05A0,x                         ; A711 9D A0 05                 ...
        lda     #$56                            ; A714 A9 56                    .V
        jsr     entity_set_subtype                           ; A716 20 98 EA                  ..
        lda     #$57                            ; A719 A9 57                    .W
        cmp     $0558,x                         ; A71B DD 58 05                 .X.
        beq     LA72A                           ; A71E F0 0A                    ..
        ldy     $0540,x                         ; A720 BC 40 05                 .@.
        cpy     #$02                            ; A723 C0 02                    ..
        bne     LA72A                           ; A725 D0 03                    ..
        jsr     entity_set_subtype                           ; A727 20 98 EA                  ..
LA72A:  lda     $0498,x                         ; A72A BD 98 04                 ...
        beq     LA743                           ; A72D F0 14                    ..
        dec     $0498,x                         ; A72F DE 98 04                 ...
        bne     LA781                           ; A732 D0 4D                    .M
        lda     #$20                            ; A734 A9 20                    . 
        sta     $0468,x                         ; A736 9D 68 04                 .h.
        lda     $0420,x                         ; A739 BD 20 04                 . .
        eor     #$0C                            ; A73C 49 0C                    I.
        sta     $0420,x                         ; A73E 9D 20 04                 . .
LA741:  bne     LA781                           ; A741 D0 3E                    .>
LA743:  jsr     entity_vert_dispatch_raw                           ; A743 20 86 EA                  ..
        dec     $0468,x                         ; A746 DE 68 04                 .h.
        bne     LA781                           ; A749 D0 36                    .6
        lda     #$14                            ; A74B A9 14                    ..
        sta     $0498,x                         ; A74D 9D 98 04                 ...
        lda     $0420,x                         ; A750 BD 20 04                 . .
        and     #$08                            ; A753 29 08                    ).
        bne     LA772                           ; A755 D0 1B                    ..
        jsr     find_free_slot_y                           ; A757 20 6F F1                  o.
        bcs     LA781                           ; A75A B0 25                    .%
        lda     #$5A                            ; A75C A9 5A                    .Z
        jsr     entity_init_pos                           ; A75E 20 A4 EA                  ..
        lda     #$80                            ; A761 A9 80                    ..
        sta     $0378,y                         ; A763 99 78 03                 .x.
        lda     #$6D                            ; A766 A9 6D                    .m
        sta     $0300,y                         ; A768 99 00 03                 ...
        lda     #$00                            ; A76B A9 00                    ..
        sta     $0408,y                         ; A76D 99 08 04                 ...
        beq     LA781                           ; A770 F0 0F                    ..
LA772:  lda     #$75                            ; A772 A9 75                    .u
        sta     $0588,x                         ; A774 9D 88 05                 ...
        lda     #$A6                            ; A777 A9 A6                    ..
        sta     $05A0,x                         ; A779 9D A0 05                 ...
LA77C:  lda     #$56                            ; A77C A9 56                    .V
        jsr     entity_set_subtype                           ; A77E 20 98 EA                  ..
LA781:  lda     #$C8                            ; A781 A9 C8                    ..
        sec                                     ; A783 38                       8
        sbc     $0378,x                         ; A784 FD 78 03                 .x.
        sta     $FA                             ; A787 85 FA                    ..
        lda     #$80                            ; A789 A9 80                    ..
        sec                                     ; A78B 38                       8
        sbc     $0330,x                         ; A78C FD 30 03                 .0.
        sta     $78                             ; A78F 85 78                    .x
        lda     #$D7                            ; A791 A9 D7                    ..
        sec                                     ; A793 38                       8
        sbc     $0378,x                         ; A794 FD 78 03                 .x.
        sta     $9B                             ; A797 85 9B                    ..
        lda     #$BF                            ; A799 A9 BF                    ..
        sec                                     ; A79B 38                       8
        sbc     $9B                             ; A79C E5 9B                    ..
        sta     $79                             ; A79E 85 79                    .y
        ldy     $0558,x                         ; A7A0 BC 58 05                 .X.
        lda     LA77C,y                         ; A7A3 B9 7C A7                 .|.
        sta     $0408,x                         ; A7A6 9D 08 04                 ...
        rts                                     ; A7A9 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $A1 — Wily Press underside rider (sub $62, shape $DD):
; pinned $20 px below the press ($0468 = press slot) at its X.
; =============================================================================
        ldy     $0468,x                         ; A7AA BC 68 04                 .h.
        lda     $0378,y                         ; A7AD B9 78 03                 .x.
        clc                                     ; A7B0 18                       .
        adc     #$20                            ; A7B1 69 20                    i 
        sta     $0378,x                         ; A7B3 9D 78 03                 .x.
        lda     $0330,y                         ; A7B6 B9 30 03                 .0.
        sta     $0330,x                         ; A7B9 9D 30 03                 .0.
        rts                                     ; A7BC 60                       `

; ----------------------------------------------------------------------------
; Wily Press data: fade-in palette (5 rows for $1C:8420), shape by
; sub_type (read as LA77C+$55.. = $A7D1), cruise durations lo/hi.
; $A7DD-$A7FF unreferenced.
        .byte   $0F,$30,$27,$07                 ; A7BD  palette
        .byte   $0F,$30,$22,$13                 ; A7C1
        .byte   $0F,$30,$25,$15                 ; A7C5
        .byte   $0F,$0F,$28,$16                 ; A7C9
        .byte   $0F,$22,$20,$36                 ; A7CD
        .byte   $89,$89,$C9,$00                 ; A7D1  shape for sub $55-$57
LA7D5:  .byte   $2C,$2C,$C8,$96                 ; A7D5  cruise duration lo
LA7D9:  .byte   $01,$01,$00,$00                 ; A7D9  cruise duration hi
        .byte   $77,$FF,$FF,$FF,$D7,$DF,$FF,$FF ; A7DD  (unreferenced)
        .byte   $7D,$FF,$DF,$F7,$DD,$FF,$8F,$FF ; A7E5
        .byte   $FF,$FF,$75,$FE,$7F,$FF,$F5,$FF ; A7ED
        .byte   $DD,$FF,$45,$FF,$F5,$FF,$FD,$FF ; A7F5
        .byte   $77,$FF,$5F                     ; A7FD
; --- $A800: DAMAGE TABLE, weapon $2 (Gyro Attack) ---
; $A800[ent_type] via damage_engine $1C:809D; low 7 bits = damage,
; bit 7 = special handling; $00 = ricochet. Types $00-$CF.
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A800  types $00-$0F
        .byte   $02,$03,$01,$01,$01,$01,$01,$02,$02,$01,$01,$02,$01,$01,$00,$00 ; A810  types $10-$1F
        .byte   $04,$03,$00,$00,$00,$01,$00,$00,$03,$01,$03,$01,$00,$00,$00,$00 ; A820  types $20-$2F
        .byte   $00,$02,$01,$01,$01,$00,$01,$00,$00,$01,$01,$03,$00,$00,$01,$00 ; A830  types $30-$3F
        .byte   $03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 ; A840  types $40-$4F
        .byte   $01,$00,$01,$01,$01,$00,$01,$00,$00,$02,$01,$00,$01,$02,$00,$00 ; A850  types $50-$5F
        .byte   $01,$00,$01,$01,$01,$01,$02,$01,$01,$01,$00,$01,$00,$00,$01,$00 ; A860  types $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$04,$00,$00,$00 ; A870  types $70-$7F
        .byte   $00,$01,$00,$04,$00,$00,$01,$00,$00,$01,$00,$00,$00,$01,$00,$00 ; A880  types $80-$8F
        .byte   $00,$01,$00,$02,$00,$00,$01,$00,$01,$00,$00,$00,$01,$00,$01,$00 ; A890  types $90-$9F
        .byte   $01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00 ; A8A0  types $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$02,$00 ; A8B0  types $B0-$BF
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8C0  types $C0-$CF
; --- $A8D0: remainder (beyond type $CF) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8F0

; =============================================================================
; STONE MAN STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $A900: screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; A900  screens $00-$0F
        .byte   $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F ; A910  screens $10-$1F
        .byte   $20,$21,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A920  screens $20-$2F
        .byte   $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A930  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04 ; A940  screens $40-$4F
; --- $A950: section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $23,$A0,$20,$20,$00,$20,$22,$A0,$22,$A0,$20,$00,$24,$A0,$22,$A0 ; A950
        .byte   $20,$00,$23,$20,$20,$00,$00,$00 ; A960
; --- $A968: per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $06,$06,$07,$40,$00,$06,$08,$1C,$06,$1C,$48,$00,$0B,$1C,$4A,$1E ; A968
        .byte   $40,$00,$1C,$80,$B5,$00,$00,$00 ; A978
; --- $A980: BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $88,$8A,$00,$00,$00,$00,$00,$00 ; A980
; --- $A988: BG palette (16 bytes) ---
        .byte   $0F,$39,$27,$17,$0F,$19,$09,$06,$0F,$21,$14,$12,$0F,$20,$21,$12 ; A988
; --- $A998: sprite palette-cycle seeds -> $05F0 slots ($A998-$A99B read) ---
        .byte   $00,$00,$00,$00,$0F,$39,$27,$17 ; A998
; --- $A9A0: unreferenced ---
        .byte   $0F,$19,$09,$06,$0F,$20,$26,$16,$0F,$20,$21,$12,$00,$00,$00,$00 ; A9A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00 ; A9C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9D0
; --- $A9E0: screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $05,$80,$07,$05                 ; A9E0  scr $05 band $80 -> scr $07 sect $05
        .byte   $07,$40,$05,$02                 ; A9E4  scr $07 band $40 -> scr $05 sect $02
        .byte   $0F,$80,$11,$0C                 ; A9E8  scr $0F band $80 -> scr $11 sect $0C
        .byte   $11,$40,$0F,$09                 ; A9EC  scr $11 band $40 -> scr $0F sect $09
        .byte   $1A,$80,$1C,$12                 ; A9F0  scr $1A band $80 -> scr $1C sect $12
        .byte   $1C,$40,$1A,$0F                 ; A9F4  scr $1C band $40 -> scr $1A sect $0F
        .byte   $FF,$00,$00,$00,$02,$40,$00     ; A9F8  terminator / filler
        .byte   $00                             ; A9FF  -1 base for the spawn arrays
; --- $AA00: spawn screens (ascending) ---
        .byte   $01,$01,$02,$03,$03,$04,$04,$04,$05,$05,$05,$06,$07,$07,$07,$08 ; AA00  entries $00-$0F
        .byte   $08,$09,$09,$09,$0A,$0A,$0B,$0B,$0B,$0B,$0C,$0C,$0C,$0D,$0D,$0D ; AA10  entries $10-$1F
        .byte   $0D,$0D,$0E,$0E,$0E,$0F,$0F,$0F,$10,$10,$10,$11,$12,$12,$12,$12 ; AA20  entries $20-$2F
        .byte   $12,$12,$12,$12,$13,$13,$13,$13,$13,$13,$14,$14,$14,$14,$15,$15 ; AA30  entries $30-$3F
        .byte   $15,$15,$16,$17,$17,$17,$17,$18,$18,$18,$18,$19,$19,$19,$19,$1A ; AA40  entries $40-$4F
        .byte   $1B,$1B,$1D,$1D,$1D,$1E,$1E,$1E,$1E,$1F,$1F,$21,$FF,$00,$00,$00 ; AA50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA70  entries $70-$7F
; --- $AA80: spawn X px ---
        .byte   $20,$C0,$70,$30,$68,$48,$D0,$E8,$70,$90,$D8,$B0,$50,$80,$E0,$B0 ; AA80  entries $00-$0F
        .byte   $E8,$10,$50,$80,$30,$90,$28,$50,$A0,$B9,$70,$80,$F0,$10,$6F,$71 ; AA90  entries $10-$1F
        .byte   $B0,$F0,$50,$A0,$A0,$00,$30,$90,$68,$A8,$D8,$20,$02,$04,$20,$20 ; AAA0  entries $20-$2F
        .byte   $60,$96,$97,$98,$30,$80,$81,$90,$E0,$E1,$90,$AE,$AF,$F0,$20,$21 ; AAB0  entries $30-$3F
        .byte   $22,$B8,$30,$60,$61,$88,$C0,$10,$11,$88,$A0,$18,$40,$50,$C0,$50 ; AAC0  entries $40-$4F
        .byte   $90,$B0,$20,$B0,$F0,$10,$40,$70,$90,$78,$79,$D8,$FF,$00,$00,$00 ; AAD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00 ; AAF0  entries $70-$7F
; --- $AB00: spawn Y px ---
        .byte   $BA,$9A,$6A,$1B,$1B,$9B,$6C,$2B,$B8,$5C,$78,$C8,$5C,$2B,$3B,$6B ; AB00  entries $00-$0F
        .byte   $48,$B0,$4B,$2A,$2A,$C0,$31,$58,$7B,$31,$BC,$5A,$4A,$AC,$2A,$D8 ; AB10  entries $10-$1F
        .byte   $BC,$2A,$3A,$2A,$9B,$00,$81,$21,$31,$90,$98,$00,$40,$80,$00,$00 ; AB20  entries $20-$2F
        .byte   $90,$60,$80,$A8,$90,$40,$70,$B0,$50,$70,$A0,$50,$70,$90,$30,$60 ; AB30  entries $30-$3F
        .byte   $40,$80,$58,$A8,$20,$40,$60,$20,$40,$80,$C8,$18,$58,$C8,$90,$98 ; AB40  entries $40-$4F
        .byte   $A8,$B8,$6A,$7A,$30,$9A,$4A,$20,$8A,$5A,$9A,$00,$FF,$00,$00,$00 ; AB50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB60  entries $60-$6F
        .byte   $00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00 ; AB70  entries $70-$7F
; --- $AB80: spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $31,$31,$31,$34,$34,$34,$31,$34,$32,$31,$32,$8A,$31,$34,$34,$34 ; AB80  entries $00-$0F
        .byte   $34,$35,$34,$34,$34,$35,$1C,$84,$31,$1C,$05,$34,$34,$05,$34,$84 ; AB90  entries $10-$1F
        .byte   $05,$34,$34,$34,$31,$EF,$1C,$1C,$1C,$35,$82,$C6,$61,$61,$D6,$C7 ; ABA0  entries $20-$2F
        .byte   $14,$61,$61,$21,$14,$61,$61,$14,$61,$61,$14,$61,$61,$14,$61,$61 ; ABB0  entries $30-$3F
        .byte   $61,$14,$83,$21,$61,$61,$61,$61,$61,$61,$20,$81,$22,$22,$26,$80 ; ABC0  entries $40-$4F
        .byte   $86,$84,$31,$61,$61,$31,$31,$61,$61,$61,$31,$62,$FF,$00,$00,$00 ; ABD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00 ; ABE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00 ; ABF0  entries $70-$7F
; --- $AC00: per-screen spawn-list start index ---
        .byte   $00,$00,$02,$03,$05,$08,$0B,$0C,$0F,$11,$14,$16,$1A,$1D,$22,$25 ; AC00  screens $00-$0F
        .byte   $28,$2B,$2C,$34,$3A,$3E,$42,$43,$47,$4B,$4F,$50,$52,$52,$55,$59 ; AC10  screens $10-$1F
        .byte   $5B,$5B,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC20  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC30  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC40  screens $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC50  screens $50-$5F
        .byte   $08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC60  screens $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC90  screens $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00 ; ACA0  screens $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACB0  screens $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACD0  screens $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACE0  screens $E0-$EF
        .byte   $00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00 ; ACF0  screens $F0-$FF
; --- $AD00: metatile top-left tile ids ---
        .byte   $00,$10,$04,$06,$2E,$3C,$2E,$EE,$0E,$01,$24,$26,$8F,$8F,$8F,$CE ; AD00  metatiles $00-$0F
        .byte   $40,$42,$CC,$CE,$40,$42,$CC,$8F,$44,$46,$EC,$EE,$64,$66,$28,$2A ; AD10  metatiles $10-$1F
        .byte   $00,$4D,$00,$C7,$68,$0E,$E3,$E5,$00,$4C,$00,$E7,$01,$00,$C4,$C6 ; AD20  metatiles $20-$2F
        .byte   $80,$82,$6A,$6C,$00,$00,$00,$CE,$0C,$2A,$4E,$6E,$02,$01,$2E,$CF ; AD30  metatiles $30-$3F
        .byte   $44,$46,$00,$00,$00,$00,$04,$06,$00,$00,$00,$00,$00,$00,$24,$26 ; AD40  metatiles $40-$4F
        .byte   $88,$C2,$00,$00,$00,$00,$00,$00,$8A,$A8,$AA,$8C,$10,$DA,$AE,$3E ; AD50  metatiles $50-$5F
        .byte   $CA,$C8,$CA,$D8,$10,$01,$01,$00,$99,$02,$02,$02,$01,$92,$E0,$E2 ; AD60  metatiles $60-$6F
        .byte   $00,$02,$8E,$00,$01,$B2,$00,$00,$00,$00,$01,$01,$A4,$A6,$00,$00 ; AD70  metatiles $70-$7F
        .byte   $84,$86,$94,$00,$00,$00,$60,$62,$A0,$A2,$E8,$EA,$EB,$A2,$64,$66 ; AD80  metatiles $80-$8F
        .byte   $C0,$C2,$4E,$4E,$80,$82,$C4,$F4,$E0,$E2,$00,$00,$C4,$E4,$D4,$01 ; AD90  metatiles $90-$9F
        .byte   $4E,$4E,$4E,$00,$00,$00,$00,$00,$4E,$00,$4E,$00,$00,$CF,$CF,$00 ; ADA0  metatiles $A0-$AF
        .byte   $00,$00,$AC,$AE,$CF,$CF,$40,$42,$AA,$CC,$00,$00,$CF,$CF,$44,$46 ; ADB0  metatiles $B0-$BF
        .byte   $80,$82,$4F,$4E,$00,$00,$88,$00,$1E,$84,$85,$85,$A5,$6E,$84,$01 ; ADC0  metatiles $C0-$CF
        .byte   $48,$A4,$A5,$01,$D6,$01,$01,$01,$94,$86,$87,$D7,$01,$85,$86,$87 ; ADD0  metatiles $D0-$DF
        .byte   $08,$0A,$00,$E0,$E2,$01,$87,$97,$20,$22,$B0,$AA,$B2,$D2,$E2,$87 ; ADE0  metatiles $E0-$EF
        .byte   $AC,$AE,$80,$81,$D2,$B0,$AA,$B2,$A8,$88,$A0,$C0,$A2,$88,$CC,$CE ; ADF0  metatiles $F0-$FF
; --- $AE00: metatile bottom-left tile ids ---
        .byte   $00,$10,$05,$07,$2F,$3D,$2F,$EE,$0F,$01,$25,$27,$8F,$8F,$8F,$CF ; AE00  metatiles $00-$0F
        .byte   $41,$43,$CD,$CF,$41,$43,$CD,$9F,$45,$47,$ED,$EF,$65,$67,$29,$2B ; AE10  metatiles $10-$1F
        .byte   $4A,$00,$C6,$00,$69,$0F,$E4,$E6,$4B,$00,$E6,$00,$01,$00,$C5,$C7 ; AE20  metatiles $20-$2F
        .byte   $81,$83,$6B,$6D,$00,$00,$00,$CE,$29,$0D,$4F,$6F,$02,$01,$2F,$CF ; AE30  metatiles $30-$3F
        .byte   $45,$47,$00,$00,$00,$00,$05,$07,$00,$00,$00,$00,$00,$00,$25,$27 ; AE40  metatiles $40-$4F
        .byte   $89,$C3,$00,$00,$00,$00,$00,$00,$8B,$A9,$AB,$AD,$98,$DB,$AF,$3F ; AE50  metatiles $50-$5F
        .byte   $98,$C9,$10,$D9,$BC,$01,$01,$00,$99,$02,$9D,$9D,$91,$93,$E1,$E3 ; AE60  metatiles $60-$6F
        .byte   $00,$02,$10,$00,$B1,$B3,$00,$00,$00,$00,$01,$01,$A5,$01,$00,$00 ; AE70  metatiles $70-$7F
        .byte   $85,$87,$02,$00,$00,$00,$61,$63,$A1,$A3,$E9,$EA,$EC,$EF,$65,$67 ; AE80  metatiles $80-$8F
        .byte   $C1,$C3,$4E,$4E,$81,$83,$F4,$C5,$E1,$E3,$00,$00,$C5,$E5,$01,$D5 ; AE90  metatiles $90-$9F
        .byte   $4E,$4E,$4E,$00,$00,$00,$00,$00,$4E,$00,$4E,$00,$00,$CF,$CF,$00 ; AEA0  metatiles $A0-$AF
        .byte   $00,$00,$AD,$01,$CF,$CF,$41,$43,$01,$CD,$00,$00,$CF,$CF,$45,$47 ; AEB0  metatiles $B0-$BF
        .byte   $81,$83,$4F,$4E,$00,$00,$89,$00,$00,$85,$86,$85,$94,$6F,$85,$01 ; AEC0  metatiles $C0-$CF
        .byte   $00,$A5,$B6,$01,$D7,$01,$01,$D6,$A5,$96,$85,$01,$01,$87,$00,$87 ; AED0  metatiles $D0-$DF
        .byte   $09,$0B,$00,$E1,$E3,$01,$E2,$97,$21,$23,$B1,$AB,$B3,$D3,$87,$97 ; AEE0  metatiles $E0-$EF
        .byte   $AD,$AF,$D2,$82,$83,$B1,$AB,$B3,$A9,$89,$A1,$C1,$A3,$89,$CD,$CF ; AEF0  metatiles $F0-$FF
; --- $AF00: metatile top-right tile ids ---
        .byte   $00,$10,$14,$16,$2C,$2E,$2E,$FE,$0E,$01,$34,$36,$8F,$8F,$8F,$DE ; AF00  metatiles $00-$0F
        .byte   $50,$52,$DC,$DE,$8A,$8C,$DC,$8F,$54,$56,$FC,$FE,$74,$76,$38,$3A ; AF10  metatiles $10-$1F
        .byte   $00,$5D,$00,$D7,$78,$0E,$F3,$F5,$00,$5C,$00,$F7,$01,$00,$C8,$CA ; AF20  metatiles $20-$2F
        .byte   $90,$92,$7A,$7C,$00,$00,$00,$DE,$1C,$3A,$5E,$7E,$02,$01,$3E,$DF ; AF30  metatiles $30-$3F
        .byte   $ED,$FD,$00,$00,$00,$00,$14,$16,$00,$00,$00,$00,$00,$00,$34,$36 ; AF40  metatiles $40-$4F
        .byte   $01,$01,$00,$00,$00,$00,$00,$00,$9A,$B8,$BA,$BC,$98,$95,$10,$49 ; AF50  metatiles $50-$5F
        .byte   $02,$02,$02,$10,$10,$82,$D0,$00,$01,$02,$CB,$02,$A0,$02,$C2,$C2 ; AF60  metatiles $60-$6F
        .byte   $00,$99,$9E,$00,$C0,$C2,$00,$00,$00,$00,$84,$86,$A7,$02,$00,$00 ; AF70  metatiles $70-$7F
        .byte   $94,$02,$02,$00,$00,$00,$70,$72,$B0,$B2,$F8,$FA,$FB,$B2,$74,$76 ; AF80  metatiles $80-$8F
        .byte   $D0,$D2,$4E,$4E,$90,$92,$D4,$01,$F0,$F2,$00,$00,$D4,$F4,$E4,$01 ; AF90  metatiles $90-$9F
        .byte   $4E,$4E,$4E,$00,$00,$00,$00,$00,$4E,$00,$4E,$00,$00,$CF,$00,$00 ; AFA0  metatiles $A0-$AF
        .byte   $00,$00,$BC,$BE,$CF,$CF,$50,$52,$BA,$DC,$00,$00,$CF,$CF,$54,$56 ; AFB0  metatiles $B0-$BF
        .byte   $90,$92,$4E,$4F,$00,$00,$98,$00,$1F,$94,$96,$B4,$A5,$7E,$94,$D4 ; AFC0  metatiles $C0-$CF
        .byte   $58,$B4,$A6,$D4,$10,$D8,$D3,$D5,$94,$94,$97,$10,$D9,$B4,$94,$97 ; AFD0  metatiles $D0-$DF
        .byte   $18,$1A,$00,$F0,$F2,$D3,$97,$87,$30,$32,$9A,$9C,$9B,$B6,$F2,$97 ; AFE0  metatiles $E0-$EF
        .byte   $BC,$BE,$90,$BA,$92,$90,$BA,$92,$B8,$98,$A0,$D0,$C3,$98,$DC,$DE ; AFF0  metatiles $F0-$FF
; --- $B000: metatile bottom-right tile ids ---
        .byte   $00,$10,$15,$17,$2D,$2F,$2F,$FE,$0F,$01,$35,$37,$8F,$8F,$8F,$DF ; B000  metatiles $00-$0F
        .byte   $51,$53,$DD,$DF,$8B,$8D,$DD,$9F,$55,$57,$FD,$FF,$75,$77,$39,$3B ; B010  metatiles $10-$1F
        .byte   $5A,$00,$D6,$00,$79,$0F,$F4,$F6,$5B,$00,$F6,$00,$01,$00,$C9,$CB ; B020  metatiles $20-$2F
        .byte   $91,$93,$7B,$7D,$00,$00,$00,$DE,$39,$1D,$5F,$7F,$02,$01,$3F,$DF ; B030  metatiles $30-$3F
        .byte   $EE,$FE,$00,$00,$00,$00,$15,$17,$00,$00,$00,$00,$00,$00,$35,$37 ; B040  metatiles $40-$4F
        .byte   $01,$01,$00,$00,$00,$00,$00,$00,$9B,$B9,$BB,$BD,$02,$97,$BF,$59 ; B050  metatiles $50-$5F
        .byte   $02,$02,$8D,$95,$10,$83,$D1,$00,$01,$02,$BE,$8D,$A1,$A3,$C2,$F3 ; B060  metatiles $60-$6F
        .byte   $00,$99,$10,$00,$C1,$C3,$00,$00,$00,$00,$85,$87,$02,$B7,$00,$00 ; B070  metatiles $70-$7F
        .byte   $02,$02,$02,$00,$00,$00,$71,$73,$B1,$B3,$F9,$FA,$FC,$FF,$75,$77 ; B080  metatiles $80-$8F
        .byte   $D1,$D3,$4E,$4E,$91,$93,$01,$D5,$F1,$F3,$00,$00,$D5,$F5,$01,$E5 ; B090  metatiles $90-$9F
        .byte   $4E,$4E,$4E,$00,$00,$00,$00,$00,$4E,$00,$4E,$00,$00,$CF,$BE,$00 ; B0A0  metatiles $A0-$AF
        .byte   $00,$00,$00,$BF,$CF,$CF,$51,$53,$BB,$DD,$00,$00,$CF,$CF,$55,$57 ; B0B0  metatiles $B0-$BF
        .byte   $91,$93,$4E,$4F,$00,$00,$99,$00,$00,$95,$94,$B4,$94,$7F,$95,$D9 ; B0C0  metatiles $C0-$CF
        .byte   $00,$B5,$B4,$D5,$10,$D9,$D4,$10,$A5,$A5,$B4,$D8,$D3,$A7,$96,$97 ; B0D0  metatiles $D0-$DF
        .byte   $19,$1B,$00,$F1,$F3,$D3,$F2,$87,$31,$33,$9B,$9D,$9E,$F5,$97,$97 ; B0E0  metatiles $E0-$EF
        .byte   $BD,$BF,$91,$BB,$93,$91,$BB,$93,$B9,$99,$C2,$D1,$A3,$99,$DD,$DF ; B0F0  metatiles $F0-$FF
; --- $B100: metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$03,$10,$10,$02,$02,$02,$11,$23,$03,$10,$10,$13,$13,$13,$F2 ; B100  metatiles $00-$0F
        .byte   $02,$02,$02,$02,$02,$02,$02,$03,$02,$02,$02,$02,$02,$02,$10,$10 ; B110  metatiles $10-$1F
        .byte   $03,$03,$03,$03,$30,$43,$01,$01,$03,$03,$03,$03,$01,$00,$01,$01 ; B120  metatiles $20-$2F
        .byte   $12,$12,$01,$01,$00,$00,$00,$F2,$10,$10,$01,$01,$00,$00,$02,$F2 ; B130  metatiles $30-$3F
        .byte   $02,$02,$00,$00,$00,$00,$60,$60,$00,$00,$00,$00,$00,$00,$60,$60 ; B140  metatiles $40-$4F
        .byte   $03,$03,$00,$04,$00,$00,$00,$00,$03,$03,$03,$03,$03,$03,$03,$01 ; B150  metatiles $50-$5F
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; B160  metatiles $60-$6F
        .byte   $00,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; B170  metatiles $70-$7F
        .byte   $03,$03,$03,$03,$03,$03,$12,$12,$12,$12,$13,$13,$13,$12,$12,$12 ; B180  metatiles $80-$8F
        .byte   $12,$12,$10,$10,$12,$12,$12,$12,$12,$12,$00,$00,$12,$12,$12,$12 ; B190  metatiles $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1A0  metatiles $A0-$AF
        .byte   $00,$00,$03,$03,$00,$00,$01,$01,$03,$03,$00,$00,$00,$00,$01,$01 ; B1B0  metatiles $B0-$BF
        .byte   $02,$02,$00,$00,$00,$00,$10,$00,$03,$13,$13,$13,$13,$13,$13,$03 ; B1C0  metatiles $C0-$CF
        .byte   $03,$13,$13,$03,$03,$03,$03,$03,$13,$13,$13,$03,$03,$13,$13,$10 ; B1D0  metatiles $D0-$DF
        .byte   $01,$01,$00,$03,$03,$03,$10,$10,$01,$01,$13,$13,$13,$03,$10,$10 ; B1E0  metatiles $E0-$EF
        .byte   $12,$12,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$13,$10,$13,$10 ; B1F0  metatiles $F0-$FF
; --- $B200: 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $10,$11,$18,$19,$09,$09,$09,$09,$14,$15,$1A,$1B,$CF,$D3,$01,$01 ; B200  blocks $00-$03
        .byte   $D4,$D5,$01,$01,$12,$13,$1A,$1B,$01,$01,$01,$01,$1E,$1F,$0A,$0B ; B210  blocks $04-$07
        .byte   $1E,$39,$0A,$0B,$F2,$F3,$FA,$0B,$F4,$F9,$FC,$F0,$F9,$F2,$F1,$FA ; B220  blocks $08-$0B
        .byte   $F3,$F4,$03,$FC,$CB,$DA,$0A,$0B,$02,$03,$0A,$0B,$F5,$F6,$FA,$0B ; B230  blocks $0C-$0F
        .byte   $F7,$F0,$FC,$F0,$F1,$F5,$F1,$FA,$F6,$F7,$03,$FC,$D3,$D5,$01,$01 ; B240  blocks $10-$13
        .byte   $12,$13,$F2,$F3,$C9,$CB,$D8,$0B,$DA,$CB,$0A,$0B,$FA,$02,$F5,$F6 ; B250  blocks $14-$17
        .byte   $D1,$03,$0A,$0B,$C8,$00,$D0,$00,$E0,$E1,$E8,$E9,$32,$33,$3A,$3B ; B260  blocks $18-$1B
        .byte   $00,$00,$00,$00,$00,$E1,$00,$00,$3A,$3B,$3A,$3B,$09,$09,$C9,$CB ; B270  blocks $1C-$1F
        .byte   $C8,$00,$DA,$CB,$00,$00,$F2,$F3,$00,$00,$F4,$F9,$00,$00,$F9,$F2 ; B280  blocks $20-$23
        .byte   $12,$13,$F4,$F9,$12,$13,$F9,$F2,$01,$01,$F3,$F4,$D8,$0B,$D1,$0B ; B290  blocks $24-$27
        .byte   $FC,$F0,$F7,$F0,$F1,$FA,$F1,$F5,$0A,$FC,$F6,$F7,$0A,$0B,$00,$00 ; B2A0  blocks $28-$2B
        .byte   $08,$00,$08,$00,$00,$00,$C9,$CB,$00,$00,$DA,$CB,$C9,$CB,$D1,$02 ; B2B0  blocks $2C-$2F
        .byte   $00,$00,$F3,$F4,$C9,$CB,$D1,$0B,$02,$03,$0A,$C9,$02,$03,$CB,$CB ; B2C0  blocks $30-$33
        .byte   $FA,$02,$EA,$EB,$FC,$F0,$EC,$F8,$F1,$FA,$F8,$EA,$02,$DA,$0A,$00 ; B2D0  blocks $34-$37
        .byte   $DA,$CB,$00,$00,$CB,$D1,$00,$00,$02,$3B,$0A,$3B,$02,$DA,$0A,$0B ; B2E0  blocks $38-$3B
        .byte   $25,$CB,$08,$00,$D1,$0B,$00,$00,$CB,$CA,$0A,$D2,$00,$00,$25,$DD ; B2F0  blocks $3C-$3F
        .byte   $08,$03,$0A,$0B,$0A,$FC,$EB,$EC,$02,$03,$CA,$0B,$02,$08,$0A,$08 ; B300  blocks $40-$43
        .byte   $CC,$03,$D2,$CA,$0A,$0B,$3A,$3B,$00,$08,$00,$08,$3B,$CC,$3B,$CC ; B310  blocks $44-$47
        .byte   $00,$00,$CB,$CA,$00,$D2,$00,$00,$CB,$CA,$00,$D2,$CB,$DE,$CB,$D1 ; B320  blocks $48-$4B
        .byte   $02,$CC,$0A,$D2,$00,$00,$CA,$00,$25,$DA,$08,$0B,$CC,$00,$CC,$00 ; B330  blocks $4C-$4F
        .byte   $08,$03,$00,$00,$D2,$CB,$0A,$0B,$24,$24,$CB,$CB,$00,$00,$CB,$CB ; B340  blocks $50-$53
        .byte   $EA,$EB,$00,$00,$EC,$F8,$00,$00,$F8,$EA,$00,$00,$DA,$DD,$00,$00 ; B350  blocks $54-$57
        .byte   $00,$00,$00,$DA,$02,$CC,$0A,$CC,$00,$3B,$CA,$00,$00,$03,$00,$E9 ; B360  blocks $58-$5B
        .byte   $02,$D2,$0A,$0B,$CA,$00,$D2,$CB,$00,$00,$DD,$25,$F0,$F1,$F0,$F1 ; B370  blocks $5C-$5F
        .byte   $EB,$EC,$00,$00,$CA,$03,$D2,$CB,$F0,$F1,$F8,$F8,$CB,$CB,$3A,$3B ; B380  blocks $60-$63
        .byte   $F9,$F9,$F0,$F1,$D8,$08,$D8,$08,$CC,$03,$CC,$0B,$CC,$03,$D2,$CB ; B390  blocks $64-$67
        .byte   $02,$CE,$CB,$D1,$D1,$08,$00,$08,$00,$08,$CB,$CB,$EC,$F8,$00,$E1 ; B3A0  blocks $68-$6B
        .byte   $3B,$3B,$3A,$3B,$00,$00,$00,$38,$00,$00,$1F,$1E,$38,$1F,$0A,$0B ; B3B0  blocks $6C-$6F
        .byte   $00,$00,$38,$39,$00,$3B,$39,$00,$02,$38,$0A,$0B,$1F,$1E,$0A,$0B ; B3C0  blocks $70-$73
        .byte   $1F,$39,$0A,$0B,$00,$00,$D9,$25,$D8,$08,$D8,$0B,$0A,$0B,$3B,$3B ; B3D0  blocks $74-$77
        .byte   $00,$00,$38,$1F,$00,$00,$1E,$1F,$00,$00,$1E,$39,$38,$39,$0A,$0B ; B3E0  blocks $78-$7B
        .byte   $08,$38,$08,$0B,$08,$03,$08,$0B,$39,$03,$0A,$0B,$00,$02,$00,$0A ; B3F0  blocks $7C-$7F
        .byte   $02,$00,$0A,$00,$00,$24,$38,$1F,$00,$38,$1E,$0B,$02,$00,$0A,$39 ; B400  blocks $80-$83
        .byte   $25,$00,$08,$00,$90,$00,$98,$00,$00,$90,$00,$98,$98,$00,$98,$00 ; B410  blocks $84-$87
        .byte   $00,$98,$00,$98,$00,$28,$00,$20,$50,$51,$09,$09,$09,$58,$59,$5A ; B420  blocks $88-$8B
        .byte   $09,$09,$5B,$59,$58,$09,$5A,$5B,$09,$59,$59,$61,$61,$62,$69,$6A ; B430  blocks $8C-$8F
        .byte   $63,$5E,$01,$64,$72,$63,$38,$1F,$5B,$09,$1E,$1F,$00,$2A,$25,$38 ; B440  blocks $90-$93
        .byte   $61,$69,$1E,$39,$09,$09,$09,$58,$09,$09,$09,$59,$59,$5A,$61,$62 ; B450  blocks $94-$97
        .byte   $5B,$09,$63,$5B,$09,$09,$1E,$1F,$59,$61,$1E,$39,$88,$8D,$86,$87 ; B460  blocks $98-$9B
        .byte   $8D,$89,$86,$87,$5B,$59,$5C,$61,$72,$63,$5D,$01,$86,$87,$86,$87 ; B470  blocks $9C-$9F
        .byte   $69,$69,$69,$69,$69,$62,$69,$6A,$88,$89,$86,$87,$69,$6A,$69,$62 ; B480  blocks $A0-$A3
        .byte   $01,$64,$01,$01,$69,$62,$88,$8D,$01,$01,$8D,$89,$09,$09,$58,$09 ; B490  blocks $A4-$A7
        .byte   $5B,$59,$63,$5E,$5A,$5B,$72,$63,$09,$09,$5B,$09,$59,$61,$61,$69 ; B4A0  blocks $A8-$AB
        .byte   $69,$6A,$88,$8D,$01,$64,$8D,$89,$5D,$01,$63,$5D,$8D,$8D,$86,$87 ; B4B0  blocks $AC-$AF
        .byte   $01,$64,$88,$89,$00,$08,$1E,$39,$46,$47,$4E,$4F,$46,$00,$4E,$00 ; B4C0  blocks $B0-$B3
        .byte   $09,$09,$E3,$E4,$39,$00,$0A,$00,$00,$28,$00,$2A,$39,$22,$0B,$2A ; B4D0  blocks $B4-$B7
        .byte   $02,$88,$0A,$0B,$89,$25,$0A,$08,$88,$8D,$0A,$0B,$ED,$E4,$63,$5B ; B4E0  blocks $B8-$BB
        .byte   $72,$5C,$5C,$69,$61,$69,$69,$69,$01,$5C,$5C,$69,$69,$60,$69,$69 ; B4F0  blocks $BC-$BF
        .byte   $C8,$00,$29,$00,$21,$00,$29,$00,$02,$03,$00,$00,$02,$03,$00,$0A ; B500  blocks $C0-$C3
        .byte   $38,$1E,$0A,$0B,$03,$00,$0B,$00,$08,$02,$08,$0A,$02,$39,$0A,$0B ; B510  blocks $C4-$C7
        .byte   $38,$02,$00,$0A,$02,$00,$0B,$00,$5F,$03,$5F,$0A,$5F,$00,$5F,$5F ; B520  blocks $C8-$CB
        .byte   $00,$00,$5F,$5F,$00,$03,$5F,$0A,$00,$08,$5F,$08,$5F,$5F,$5F,$5F ; B530  blocks $CC-$CF
        .byte   $5F,$08,$39,$08,$5F,$5F,$5F,$38,$24,$24,$1E,$1F,$5F,$5F,$38,$1F ; B540  blocks $D0-$D3
        .byte   $5F,$5F,$1E,$1F,$5F,$5F,$1E,$39,$5F,$03,$25,$0B,$5F,$5F,$38,$39 ; B550  blocks $D4-$D7
        .byte   $09,$09,$80,$81,$80,$81,$69,$69,$7C,$7D,$69,$69,$00,$2A,$00,$22 ; B560  blocks $D8-$DB
        .byte   $69,$69,$88,$89,$00,$2A,$88,$8D,$69,$69,$8D,$89,$88,$89,$0A,$0B ; B570  blocks $DC-$DF
        .byte   $02,$00,$0A,$25,$00,$38,$38,$0B,$00,$03,$00,$0B,$7A,$7B,$82,$69 ; B580  blocks $E0-$E3
        .byte   $7A,$7B,$69,$69,$69,$69,$88,$8D,$8A,$8B,$69,$69,$8B,$8B,$69,$69 ; B590  blocks $E4-$E7
        .byte   $8B,$8C,$69,$69,$69,$69,$37,$37,$69,$88,$37,$86,$3F,$3F,$88,$89 ; B5A0  blocks $E8-$EB
        .byte   $3F,$86,$89,$86,$69,$69,$8A,$8B,$69,$69,$8B,$8C,$69,$69,$8B,$8B ; B5B0  blocks $EC-$EF
        .byte   $D0,$00,$C8,$00,$2B,$00,$23,$00,$0A,$0B,$00,$17,$39,$5F,$0A,$39 ; B5C0  blocks $F0-$F3
        .byte   $5F,$17,$5F,$17,$8E,$8F,$00,$00,$86,$87,$8E,$8F,$02,$03,$8E,$8F ; B5D0  blocks $F4-$F7
        .byte   $03,$00,$0B,$5F,$00,$00,$3A,$3B,$00,$02,$5F,$0A,$03,$5F,$0B,$5F ; B5E0  blocks $F8-$FB
        .byte   $5F,$02,$5F,$0A,$0B,$5F,$00,$5F,$00,$00,$00,$00,$00,$00,$00,$00 ; B5F0  blocks $FC-$FF
; --- $B600: screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$00,$00,$01,$01,$00,$00,$00,$00,$00,$00,$01,$01,$00,$00,$00 ; B600
        .byte   $00,$00,$00,$01,$01,$00,$00,$00,$02,$02,$02,$03,$04,$02,$02,$02 ; B610
        .byte   $05,$05,$05,$06,$06,$05,$05,$05,$05,$05,$05,$06,$06,$05,$05,$05 ; B620
        .byte   $07,$08,$09,$0A,$0B,$0C,$0D,$09,$0E,$0E,$0F,$10,$11,$12,$0E,$0F ; B630
; layout $01
        .byte   $00,$00,$01,$01,$01,$01,$00,$00,$00,$00,$01,$01,$01,$01,$00,$00 ; B640
        .byte   $00,$00,$01,$01,$01,$01,$00,$00,$02,$02,$13,$03,$04,$13,$02,$02 ; B650
        .byte   $05,$05,$06,$06,$06,$06,$05,$14,$05,$05,$06,$15,$16,$16,$16,$17 ; B660
        .byte   $0A,$0B,$0C,$18,$0E,$0E,$0E,$17,$10,$11,$12,$0E,$0E,$0E,$0E,$17 ; B670
; layout $02
        .byte   $00,$00,$01,$01,$19,$1A,$1B,$1C,$00,$00,$01,$01,$19,$1D,$1B,$1E ; B680
        .byte   $00,$00,$01,$01,$19,$1A,$1B,$1D,$02,$02,$13,$1F,$20,$21,$22,$23 ; B690
        .byte   $24,$25,$26,$27,$0E,$17,$28,$29,$28,$29,$2A,$0E,$0E,$17,$28,$29 ; B6A0
        .byte   $28,$29,$2A,$0E,$0E,$17,$28,$29,$28,$29,$2A,$0E,$0E,$17,$28,$29 ; B6B0
; layout $03
        .byte   $2B,$2B,$2B,$2B,$1A,$1D,$2C,$1A,$1E,$1E,$1E,$1B,$1E,$1E,$2C,$1B ; B6C0
        .byte   $1D,$1A,$1A,$2D,$2E,$2F,$0D,$1A,$30,$31,$0D,$18,$0E,$0E,$0E,$1C ; B6D0
        .byte   $2A,$0E,$0E,$0E,$0E,$0E,$0E,$1C,$2A,$0E,$0E,$0E,$0E,$0E,$0E,$1C ; B6E0
        .byte   $2A,$0E,$0E,$0E,$0E,$0E,$0E,$1C,$2A,$0E,$0E,$0E,$0E,$0E,$0E,$1C ; B6F0
; layout $04
        .byte   $0E,$0E,$0E,$32,$33,$34,$35,$36,$37,$38,$38,$39,$1A,$1D,$1A,$1B ; B700
        .byte   $3A,$1E,$1B,$1E,$1E,$1E,$1E,$1B,$3A,$1B,$1A,$2D,$2E,$2E,$2E,$2E ; B710
        .byte   $3B,$3C,$38,$3D,$2B,$2B,$0E,$0E,$0E,$2C,$1A,$1D,$1A,$1D,$2B,$0E ; B720
        .byte   $0E,$0D,$0D,$3E,$2E,$2E,$3F,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$40,$0E ; B730
; layout $05
        .byte   $41,$33,$42,$0E,$0E,$43,$0E,$0E,$1D,$1C,$44,$0E,$45,$46,$1E,$0E ; B740
        .byte   $1E,$1B,$47,$0E,$1B,$46,$1B,$0E,$48,$1A,$49,$4A,$4B,$1C,$1E,$0E ; B750
        .byte   $4C,$4D,$1A,$1D,$1E,$1D,$4E,$0E,$0E,$4F,$1A,$1A,$1B,$1A,$50,$0E ; B760
        .byte   $0E,$51,$0D,$0D,$3E,$2E,$2E,$52,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; B770
; layout $06
        .byte   $0E,$0E,$17,$28,$29,$2A,$17,$28,$0E,$0E,$17,$28,$29,$2A,$17,$28 ; B780
        .byte   $0E,$0E,$34,$35,$36,$41,$17,$28,$0E,$0E,$1D,$1A,$1D,$1B,$17,$28 ; B790
        .byte   $0E,$0E,$1A,$1C,$1A,$1B,$17,$28,$0E,$1A,$1D,$1A,$1A,$1B,$17,$28 ; B7A0
        .byte   $53,$21,$22,$23,$30,$2E,$17,$28,$0E,$17,$28,$29,$2A,$0E,$17,$28 ; B7B0
; layout $07
        .byte   $12,$0E,$32,$33,$33,$0F,$10,$11,$12,$38,$39,$1E,$1A,$54,$55,$56 ; B7C0
        .byte   $12,$1E,$1E,$1B,$1E,$1E,$1E,$1E,$12,$1B,$57,$1B,$1A,$2D,$48,$1A ; B7D0
        .byte   $12,$1E,$58,$2E,$31,$18,$59,$1B,$12,$5A,$1D,$1B,$1A,$5B,$5C,$0D ; B7E0
        .byte   $12,$51,$0D,$0D,$5D,$5E,$0E,$0E,$12,$0E,$0E,$0E,$0E,$43,$0E,$0E ; B7F0
; layout $08
        .byte   $12,$0E,$0E,$5F,$0E,$5F,$0E,$0E,$60,$38,$61,$5F,$0E,$5F,$33,$33 ; B800
        .byte   $1E,$1E,$1E,$62,$63,$62,$1D,$1C,$1D,$1A,$1A,$1C,$1B,$1C,$1A,$1A ; B810
        .byte   $1E,$1E,$1E,$1E,$1B,$1E,$1B,$1E,$0D,$3E,$48,$1C,$1E,$1D,$1A,$1D ; B820
        .byte   $0E,$0E,$5C,$3E,$2E,$2E,$31,$0D,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; B830
; layout $09
        .byte   $5F,$0E,$5F,$33,$33,$34,$35,$36,$62,$38,$62,$1E,$1B,$1E,$1B,$1E ; B840
        .byte   $1A,$1E,$1D,$1A,$1A,$1D,$1A,$1A,$1A,$1E,$1A,$1A,$1D,$64,$1D,$1A ; B850
        .byte   $1E,$1B,$1E,$15,$0D,$5F,$3E,$2E,$1A,$2D,$31,$18,$0E,$5F,$0E,$0E ; B860
        .byte   $0D,$18,$0E,$0E,$0E,$5F,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$5F,$0E,$0E ; B870
; layout $0A
        .byte   $41,$33,$42,$0E,$0E,$65,$17,$28,$1B,$1E,$66,$0E,$0E,$65,$17,$28 ; B880
        .byte   $1A,$1D,$67,$68,$38,$69,$17,$28,$1A,$1A,$1E,$1E,$1A,$46,$17,$28 ; B890
        .byte   $48,$1A,$1E,$1B,$1D,$46,$17,$28,$59,$1E,$1B,$1B,$1E,$46,$17,$28 ; B8A0
        .byte   $5C,$64,$1E,$2E,$2E,$6A,$17,$28,$0E,$5F,$1C,$0E,$0E,$0E,$17,$28 ; B8B0
; layout $0B
        .byte   $12,$0E,$0E,$0E,$0E,$0F,$10,$11,$12,$2B,$2B,$0E,$0E,$54,$6B,$56 ; B8C0
        .byte   $12,$1B,$1A,$1D,$1D,$1A,$1D,$1A,$12,$6C,$57,$6C,$6C,$6C,$6C,$6C ; B8D0
        .byte   $12,$1B,$6D,$6E,$6F,$08,$70,$1D,$12,$71,$1D,$1A,$1A,$1D,$09,$0A ; B8E0
        .byte   $12,$72,$73,$74,$2E,$75,$0F,$10,$12,$0E,$0E,$0E,$0E,$76,$0F,$10 ; B8F0
; layout $0C
        .byte   $12,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$60,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; B900
        .byte   $1D,$0E,$0E,$77,$77,$0E,$0E,$1C,$6C,$6C,$6C,$1B,$1B,$6C,$6C,$6C ; B910
        .byte   $1A,$1A,$1A,$1B,$1B,$1A,$1D,$1A,$0B,$0C,$1D,$1B,$1B,$1A,$1A,$78 ; B920
        .byte   $11,$12,$6F,$08,$78,$79,$7A,$0E,$11,$12,$0E,$0E,$0E,$0E,$0E,$0E ; B930
; layout $0D
        .byte   $34,$35,$36,$41,$34,$35,$36,$41,$1C,$1A,$1D,$1E,$1A,$1A,$1D,$1A ; B940
        .byte   $1A,$1D,$1A,$1B,$1A,$1D,$1A,$1A,$6C,$6C,$6C,$1E,$1E,$1E,$1B,$1E ; B950
        .byte   $1D,$1A,$1D,$1B,$1A,$1D,$1A,$1D,$79,$7A,$6F,$08,$1D,$1C,$7B,$78 ; B960
        .byte   $0E,$0E,$0E,$1E,$1A,$7B,$0E,$0E,$0E,$0E,$0E,$6F,$08,$0E,$0E,$0E ; B970
; layout $0E
        .byte   $0E,$0E,$0E,$0E,$0E,$0E,$2C,$0E,$1D,$2B,$2B,$2B,$1C,$1E,$2C,$0E ; B980
        .byte   $1A,$1D,$1A,$1D,$1A,$1B,$7C,$0E,$1E,$1E,$1B,$1E,$1E,$1E,$7D,$0E ; B990
        .byte   $1A,$1C,$1A,$1A,$1A,$1B,$7D,$0E,$79,$7A,$09,$0A,$0B,$0C,$7E,$0E ; B9A0
        .byte   $0E,$0E,$0F,$10,$11,$12,$0E,$0E,$0E,$0E,$0F,$10,$11,$12,$0E,$0E ; B9B0
; layout $0F
        .byte   $0E,$1D,$2C,$1A,$0E,$0E,$0E,$0E,$0E,$7B,$2C,$1D,$1A,$1A,$0E,$0E ; B9C0
        .byte   $0E,$0E,$7B,$70,$1A,$1A,$1C,$7F,$0E,$0E,$0E,$0E,$7B,$70,$1A,$7F ; B9D0
        .byte   $80,$1D,$1A,$2B,$1A,$1A,$1C,$81,$80,$1A,$78,$79,$79,$79,$82,$0E ; B9E0
        .byte   $83,$1A,$1A,$1C,$1A,$1A,$1D,$0E,$72,$07,$07,$07,$07,$07,$84,$0E ; B9F0
; layout $10
        .byte   $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$2B,$2B,$2B,$2B,$2B,$2B,$0E ; BA00
        .byte   $0E,$1A,$1D,$1A,$1A,$1D,$1A,$0E,$0E,$1D,$1A,$1C,$1A,$1A,$1D,$0E ; BA10
        .byte   $79,$7A,$1A,$1A,$1D,$1A,$1A,$0E,$0E,$0E,$7B,$85,$1A,$85,$86,$0E ; BA20
        .byte   $0E,$0E,$0E,$87,$1C,$87,$88,$0E,$0E,$0E,$0E,$87,$1C,$87,$88,$0E ; BA30
; layout $11
        .byte   $0E,$0E,$89,$01,$01,$01,$01,$01,$0E,$0E,$89,$01,$01,$01,$01,$01 ; BA40
        .byte   $0E,$1C,$89,$01,$01,$01,$01,$01,$0E,$1C,$89,$01,$01,$01,$8A,$01 ; BA50
        .byte   $0E,$1C,$89,$8A,$8B,$8C,$8D,$01,$0E,$1C,$89,$8E,$8F,$90,$91,$92 ; BA60
        .byte   $0E,$1C,$93,$94,$6F,$08,$0E,$0E,$0E,$1C,$7D,$0E,$0E,$0E,$0E,$0E ; BA70
; layout $12
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; BA80
        .byte   $01,$01,$01,$01,$01,$01,$8A,$01,$01,$01,$95,$01,$8A,$01,$01,$01 ; BA90
        .byte   $8A,$96,$97,$98,$01,$8B,$8C,$8D,$99,$9A,$9B,$9C,$9D,$8F,$90,$9E ; BAA0
        .byte   $0E,$0E,$9F,$9F,$A0,$A1,$06,$9B,$0E,$0E,$9F,$9F,$A0,$A1,$06,$9F ; BAB0
; layout $13
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; BAC0
        .byte   $01,$01,$01,$01,$01,$8A,$01,$01,$01,$8A,$95,$01,$01,$01,$01,$01 ; BAD0
        .byte   $8A,$96,$97,$98,$01,$8B,$8C,$8D,$98,$A2,$A3,$A4,$9D,$8F,$90,$9E ; BAE0
        .byte   $9C,$9F,$A3,$9B,$9C,$A5,$A6,$9B,$9F,$9F,$A3,$9F,$9F,$9F,$9F,$9F ; BAF0
; layout $14
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; BB00
        .byte   $01,$01,$01,$01,$8A,$01,$01,$01,$8A,$01,$01,$95,$01,$A7,$01,$01 ; BB10
        .byte   $01,$8A,$96,$97,$A8,$A9,$AA,$8A,$98,$A2,$AB,$AC,$AD,$AE,$9B,$AF ; BB20
        .byte   $9C,$9F,$A0,$9F,$9F,$B0,$9F,$9F,$9F,$9F,$A0,$9F,$9F,$9F,$9F,$9F ; BB30
; layout $15
        .byte   $19,$0E,$0E,$0E,$0E,$0E,$43,$0E,$19,$1A,$1C,$1A,$1D,$1A,$46,$0E ; BB40
        .byte   $19,$1D,$1A,$1A,$1A,$1D,$46,$0E,$19,$1A,$1D,$1A,$1D,$1A,$46,$0E ; BB50
        .byte   $19,$78,$79,$79,$79,$79,$B1,$0E,$9C,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; BB60
        .byte   $9F,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$9F,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; BB70
; layout $16
        .byte   $0E,$0E,$B2,$B2,$B3,$89,$01,$01,$0E,$B2,$B2,$0E,$80,$89,$B4,$95 ; BB80
        .byte   $0E,$1C,$0E,$80,$1C,$89,$96,$97,$0E,$0E,$0E,$72,$B5,$B6,$AB,$A3 ; BB90
        .byte   $0E,$0E,$0E,$0E,$72,$B7,$A0,$A3,$0E,$0E,$0E,$0E,$0E,$B8,$B9,$BA ; BBA0
        .byte   $0E,$0E,$0E,$0E,$0E,$0E,$43,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$43,$0E ; BBB0
; layout $17
        .byte   $01,$01,$01,$01,$B4,$01,$01,$8B,$01,$01,$01,$8B,$8C,$8D,$8E,$8F ; BBC0
        .byte   $BB,$01,$8E,$8F,$90,$BC,$A2,$A5,$A4,$9D,$BD,$A1,$BE,$A0,$9F,$9F ; BBD0
        .byte   $BE,$A0,$A0,$BF,$A0,$A0,$9F,$9F,$AF,$9C,$A0,$A0,$A0,$A0,$9F,$9F ; BBE0
        .byte   $9F,$9F,$A0,$A0,$A0,$A0,$9F,$9F,$9F,$9F,$A0,$A0,$A0,$A0,$9F,$9F ; BBF0
; layout $18
        .byte   $8C,$8D,$01,$01,$B4,$19,$0E,$0E,$90,$9E,$BB,$01,$A7,$19,$0E,$0E ; BC00
        .byte   $A6,$06,$A4,$A8,$A9,$C0,$0E,$0E,$9F,$A2,$06,$A4,$AE,$C1,$0E,$0E ; BC10
        .byte   $9F,$9F,$A2,$06,$A4,$C1,$C2,$C3,$9F,$9F,$9F,$A2,$06,$C1,$1C,$1C ; BC20
        .byte   $9F,$9F,$9F,$9F,$06,$C1,$C4,$73,$9F,$9F,$9F,$9F,$06,$C1,$0E,$0E ; BC30
; layout $19
        .byte   $C5,$1C,$1C,$1C,$1D,$1C,$C6,$0E,$C7,$1D,$1C,$1A,$1A,$1C,$C6,$0E ; BC40
        .byte   $0E,$1A,$1D,$1A,$1A,$1A,$C8,$0E,$80,$1A,$1A,$1A,$1A,$1D,$1C,$0E ; BC50
        .byte   $C9,$1A,$1D,$1A,$1D,$1A,$1A,$0E,$1C,$1C,$1C,$1A,$1A,$1C,$1D,$0E ; BC60
        .byte   $73,$B5,$1C,$1A,$1D,$1A,$1D,$0E,$0E,$80,$1D,$1C,$1C,$1D,$1C,$0E ; BC70
; layout $1A
        .byte   $0E,$43,$CA,$0E,$0E,$0E,$0E,$0E,$0E,$43,$CB,$CC,$CC,$CD,$0E,$0E ; BC80
        .byte   $0E,$CE,$CF,$CF,$CF,$CB,$CD,$0E,$0E,$D0,$CF,$CF,$CF,$CF,$CB,$0E ; BC90
        .byte   $0E,$43,$CF,$CF,$CF,$CF,$D1,$D2,$0E,$72,$08,$D3,$D4,$D5,$D6,$0E ; BCA0
        .byte   $0E,$0E,$0E,$0E,$0E,$0E,$7D,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$7D,$0E ; BCB0
; layout $1B
        .byte   $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; BCC0
        .byte   $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$CC,$CC,$CC,$CC,$CC,$0E,$0E ; BCD0
        .byte   $79,$D4,$D5,$CF,$CF,$CF,$0E,$0E,$0E,$0E,$0E,$7B,$D7,$CF,$0E,$0E ; BCE0
        .byte   $0E,$0E,$0E,$0E,$0E,$7B,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E ; BCF0
; layout $1C
        .byte   $0E,$0E,$0E,$80,$89,$01,$01,$01,$0E,$0E,$0E,$80,$89,$01,$01,$01 ; BD00
        .byte   $0E,$0E,$80,$1D,$89,$D8,$D9,$DA,$0E,$0E,$80,$1A,$DB,$A0,$A0,$A0 ; BD10
        .byte   $0E,$80,$1D,$1A,$DB,$A0,$A0,$DC,$0E,$80,$1A,$1C,$DD,$DE,$DF,$0E ; BD20
        .byte   $0E,$E0,$E1,$74,$0E,$0E,$0E,$0E,$0E,$43,$E2,$0E,$0E,$0E,$0E,$0E ; BD30
; layout $1D
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01 ; BD40
        .byte   $DA,$E3,$E3,$D9,$DA,$DA,$E4,$D9,$E5,$DE,$A0,$E6,$E7,$E7,$E7,$E8 ; BD50
        .byte   $9F,$9F,$A0,$A0,$A0,$A0,$A0,$A0,$9F,$9F,$E5,$DE,$A0,$A0,$A0,$A0 ; BD60
        .byte   $9F,$9F,$9F,$9F,$E9,$EA,$9C,$A2,$9F,$9F,$9F,$9F,$EB,$EC,$9F,$9F ; BD70
; layout $1E
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$D8,$D8,$E3,$D9,$DA,$DA,$D8,$D8 ; BD80
        .byte   $A0,$ED,$EE,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$ED,$EF,$EE,$A0 ; BD90
        .byte   $A0,$A0,$A0,$A0,$A0,$A0,$ED,$EE,$A2,$A0,$A2,$A0,$A0,$A0,$A0,$A0 ; BDA0
        .byte   $9F,$E9,$9F,$A2,$A2,$E9,$E9,$9B,$9F,$EB,$9F,$9F,$9F,$EB,$EB,$9F ; BDB0
; layout $1F
        .byte   $F0,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$F0,$CC,$2B,$0E,$0E,$0E,$0E,$0E ; BDC0
        .byte   $F1,$CF,$CF,$2B,$2B,$0E,$0E,$0E,$F1,$CF,$CF,$CF,$CF,$2B,$2B,$0E ; BDD0
        .byte   $F1,$CF,$CF,$CF,$CF,$CF,$CF,$F2,$F1,$CF,$CF,$6F,$F3,$CF,$CF,$F4 ; BDE0
        .byte   $AF,$AF,$9C,$0E,$0E,$6F,$07,$07,$9F,$9F,$9F,$0E,$0E,$0E,$0E,$0E ; BDF0
; layout $20
        .byte   $0E,$0E,$9F,$0E,$0E,$9F,$0E,$0E,$0E,$0E,$9F,$0E,$0E,$9F,$0E,$0E ; BE00
        .byte   $0E,$0E,$9F,$0E,$0E,$9F,$0E,$0E,$0E,$0E,$9F,$0E,$0E,$9F,$0E,$0E ; BE10
        .byte   $2B,$2B,$F5,$2B,$2B,$F5,$2B,$F2,$CF,$CF,$CF,$CF,$CF,$CF,$CF,$F4 ; BE20
        .byte   $07,$07,$A2,$07,$07,$A2,$07,$07,$0E,$0E,$9F,$0E,$0E,$9F,$0E,$0E ; BE30
; layout $21
        .byte   $F6,$F7,$F6,$F7,$F7,$F6,$F7,$F6,$F8,$F9,$CC,$F9,$F9,$CC,$F9,$FA ; BE40
        .byte   $FB,$1B,$CF,$1B,$1B,$CF,$1B,$FC,$FB,$1B,$CF,$1B,$1B,$CF,$1B,$FC ; BE50
        .byte   $FD,$1B,$CF,$1B,$1B,$CF,$1B,$FC,$CF,$1B,$CF,$1B,$1B,$CF,$1B,$FC ; BE60
        .byte   $A2,$07,$A2,$07,$07,$A2,$07,$A2,$9F,$0E,$9F,$0E,$0E,$9F,$0E,$9F ; BE70
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
