.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK1D"

; =============================================================================
; BANK $1D (mapped at $A000) — GENERIC ENEMY / PICKUP / EFFECT AI
; =============================================================================
L0000           := $0000
L0001           := $0001
L0008           := $0008
L0010           := $0010
L0033           := $0033
L0100           := $0100
L0800           := $0800
L0801           := $0801
L4000           := $4000
L8000           := $8000
L8001           := $8001
L809D           := $809D
L8141           := $8141
L84FC           := $84FC
L8526           := $8526
L852F           := $852F
L8538           := $8538
LD7DB           := $D7DB
LD8A2           := $D8A2
LD8C7           := $D8C7
LE747           := $E747
LE999           := $E999
LEA03           := $EA03
LEA34           := $EA34
LEC85           := $EC85
LECAB           := $ECAB
LED5B           := $ED5B
LED5D           := $ED5D
LF297           := $F297
LF2F3           := $F2F3
LFF24           := $FF24
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $3B — hopping sniper: wakes within $50 px or when the
; player fires; leaps (yvel $09.6F), and while grounded fires a 2-shot
; aimed volley every $B4 frames (type $3C, speed 8, adjacent 16-dir
; headings around the player octant), one volley alive at a time
; =============================================================================
        lda     $14                             ; A000 A5 14                    ..
        and     #$40                            ; A002 29 40                    )@
        bne     LA00D                           ; A004 D0 07                    ..
        jsr     entity_x_dist_px                           ; A006 20 94 EC                  ..
        cmp     #$50                            ; A009 C9 50                    .P
        bcs     LA032                           ; A00B B0 25                    .%
LA00D:  lda     #$6D                            ; A00D A9 6D                    .m
        jsr     entity_set_subtype                           ; A00F 20 98 EA                  ..
        lda     #$1C                            ; A012 A9 1C                    ..
        sta     $0588,x                         ; A014 9D 88 05                 ...
        lda     #$A0                            ; A017 A9 A0                    ..
        sta     $05A0,x                         ; A019 9D A0 05                 ...
        lda     $0540,x                         ; A01C BD 40 05                 .@.
        beq     LA033                           ; A01F F0 12                    ..
        lda     $0570,x                         ; A021 BD 70 05                 .p.
        cmp     #$08                            ; A024 C9 08                    ..
        bne     LA032                           ; A026 D0 0A                    ..
        lda     #$6F                            ; A028 A9 6F                    .o
        sta     $03D8,x                         ; A02A 9D D8 03                 ...
        lda     #$09                            ; A02D A9 09                    ..
        sta     $03F0,x                         ; A02F 9D F0 03                 ...
LA032:  rts                                     ; A032 60                       `

; ----------------------------------------------------------------------------
LA033:  lda     #$00                            ; A033 A9 00                    ..
        sta     $0570,x                         ; A035 9D 70 05                 .p.
        ldy     #$21                            ; A038 A0 21                    .!
        jsr     entity_gravity_collide                           ; A03A 20 B7 E7                  ..
        bcc     LA045                           ; A03D 90 06                    ..
        lda     #$01                            ; A03F A9 01                    ..
        sta     $0540,x                         ; A041 9D 40 05                 .@.
        rts                                     ; A044 60                       `

; ----------------------------------------------------------------------------
LA045:  lda     $0468,x                         ; A045 BD 68 04                 .h.
        beq     LA04F                           ; A048 F0 05                    ..
        dec     $0468,x                         ; A04A DE 68 04                 .h.
        bne     LA088                           ; A04D D0 39                    .9
LA04F:  ldy     $0480,x                         ; A04F BC 80 04                 ...
        lda     $0300,y                         ; A052 B9 00 03                 ...
        cmp     #$3C                            ; A055 C9 3C                    .<
        beq     LA088                           ; A057 F0 2F                    ./
        lda     #$B4                            ; A059 A9 B4                    ..
        sta     $0468,x                         ; A05B 9D 68 04                 .h.
        jsr     entity_set_facing                           ; A05E 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A061 20 30 EC                  0.
        jsr     LA089                           ; A064 20 89 A0                  ..
LA067:  jsr     find_free_slot_y                           ; A067 20 6F F1                  o.
        bcs     LA088                           ; A06A B0 1C                    ..
        lda     #$87                            ; A06C A9 87                    ..
        sta     $0408,y                         ; A06E 99 08 04                 ...
        tya                                     ; A071 98                       .
        sta     $0480,x                         ; A072 9D 80 04                 ...
        lda     #$6E                            ; A075 A9 6E                    .n
        jsr     entity_init_pos                           ; A077 20 A4 EA                  ..
        jsr     LA09D                           ; A07A 20 9D A0                  ..
        lda     #$08                            ; A07D A9 08                    ..
        jsr     entity_set_dir_velocity                           ; A07F 20 70 F4                  p.
        ldx     $0D                             ; A082 A6 0D                    ..
        dec     $0E                             ; A084 C6 0E                    ..
        bpl     LA067                           ; A086 10 DF                    ..
LA088:  rts                                     ; A088 60                       `

; ----------------------------------------------------------------------------
LA089:  jsr     entity_distance_calc                           ; A089 20 C2 EC                  ..
        sta     $0F                             ; A08C 85 0F                    ..
        dec     $0F                             ; A08E C6 0F                    ..
        lda     $0F                             ; A090 A5 0F                    ..
        and     #$0F                            ; A092 29 0F                    ).
        sta     $0F                             ; A094 85 0F                    ..
        lda     #$01                            ; A096 A9 01                    ..
        sta     $0E                             ; A098 85 0E                    ..
        stx     $0D                             ; A09A 86 0D                    ..
        rts                                     ; A09C 60                       `

; ----------------------------------------------------------------------------
LA09D:  lda     $0300,x                         ; A09D BD 00 03                 ...
        clc                                     ; A0A0 18                       .
        adc     #$01                            ; A0A1 69 01                    i.
        sta     $0300,y                         ; A0A3 99 00 03                 ...
        tya                                     ; A0A6 98                       .
        tax                                     ; A0A7 AA                       .
        lda     $0E                             ; A0A8 A5 0E                    ..
        asl     a                               ; A0AA 0A                       .
        clc                                     ; A0AB 18                       .
        adc     $0F                             ; A0AC 65 0F                    e.
        and     #$0F                            ; A0AE 29 0F                    ).
        tay                                     ; A0B0 A8                       .
LA0B1:  rts                                     ; A0B1 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $3F — ballistic mover: facing dispatch + raw y velocity
; =============================================================================
        jsr     entity_process_y_vel                           ; A0B2 20 68 E9                  h.
        jmp     entity_facing_dispatch                           ; A0B5 4C 65 EA                 Le.

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $50 — burst pod: sleeps until the player is within
; $50x/$14y, then rises 3px armed (shape $C1); when a shot connects it
; dies (LA54D) and splits into three type $C4 fragments (shape $C6,
; pose $73, $F0-frame life, dirs 0-2); otherwise settles back down
; =============================================================================
        jsr     entity_set_facing                           ; A0B8 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A0BB 20 30 EC                  0.
        lda     $0468,x                         ; A0BE BD 68 04                 .h.
        beq     LA0CD                           ; A0C1 F0 0A                    ..
        lda     #$00                            ; A0C3 A9 00                    ..
        sta     $0570,x                         ; A0C5 9D 70 05                 .p.
        dec     $0468,x                         ; A0C8 DE 68 04                 .h.
        bne     LA0B1                           ; A0CB D0 E4                    ..
LA0CD:  sta     $0570,x                         ; A0CD 9D 70 05                 .p.
        jsr     entity_x_dist_px                           ; A0D0 20 94 EC                  ..
        cmp     #$50                            ; A0D3 C9 50                    .P
        bcs     LA0B1                           ; A0D5 B0 DA                    ..
        jsr     entity_y_dist_abs                           ; A0D7 20 76 EC                  v.
        cmp     #$14                            ; A0DA C9 14                    ..
        bcs     LA0B1                           ; A0DC B0 D3                    ..
        lda     #$01                            ; A0DE A9 01                    ..
        sta     $0540,x                         ; A0E0 9D 40 05                 .@.
        lda     $0378,x                         ; A0E3 BD 78 03                 .x.
        sec                                     ; A0E6 38                       8
        sbc     #$03                            ; A0E7 E9 03                    ..
        sta     $0378,x                         ; A0E9 9D 78 03                 .x.
        lda     #$C1                            ; A0EC A9 C1                    ..
        sta     $0408,x                         ; A0EE 9D 08 04                 ...
        lda     #$FB                            ; A0F1 A9 FB                    ..
        sta     $0588,x                         ; A0F3 9D 88 05                 ...
        lda     #$A0                            ; A0F6 A9 A0                    ..
        sta     $05A0,x                         ; A0F8 9D A0 05                 ...
        jsr     entity_hitbox_check                           ; A0FB 20 F8 EF                  ..
        bcs     LA13D                           ; A0FE B0 3D                    .=
        jsr     LF2F3                           ; A100 20 F3 F2                  ..
        jsr     LA54D                           ; A103 20 4D A5                  M.
        lda     #$02                            ; A106 A9 02                    ..
        sta     $0E                             ; A108 85 0E                    ..
LA10A:  jsr     find_free_slot_y                           ; A10A 20 6F F1                  o.
        bcs     LA16C                           ; A10D B0 5D                    .]
        lda     #$C4                            ; A10F A9 C4                    ..
        sta     $0300,y                         ; A111 99 00 03                 ...
        lda     #$C6                            ; A114 A9 C6                    ..
        sta     $0408,y                         ; A116 99 08 04                 ...
        lda     #$01                            ; A119 A9 01                    ..
        sta     $0450,y                         ; A11B 99 50 04                 .P.
        lda     #$73                            ; A11E A9 73                    .s
        jsr     entity_init_pos                           ; A120 20 A4 EA                  ..
        lda     #$F0                            ; A123 A9 F0                    ..
        sta     $0468,y                         ; A125 99 68 04                 .h.
        lda     $0E                             ; A128 A5 0E                    ..
        sta     $0420,y                         ; A12A 99 20 04                 . .
        jsr     LEA34                           ; A12D 20 34 EA                  4.
        lda     #$00                            ; A130 A9 00                    ..
        sta     $03A8,y                         ; A132 99 A8 03                 ...
        sta     $03C0,y                         ; A135 99 C0 03                 ...
        dec     $0E                             ; A138 C6 0E                    ..
        bpl     LA10A                           ; A13A 10 CE                    ..
        rts                                     ; A13C 60                       `

; ----------------------------------------------------------------------------
LA13D:  lda     $0570,x                         ; A13D BD 70 05                 .p.
        cmp     #$04                            ; A140 C9 04                    ..
        bne     LA1A3                           ; A142 D0 5F                    ._
        lda     $0540,x                         ; A144 BD 40 05                 .@.
        cmp     #$03                            ; A147 C9 03                    ..
        beq     LA16D                           ; A149 F0 22                    ."
        cmp     #$08                            ; A14B C9 08                    ..
        bne     LA1A3                           ; A14D D0 54                    .T
        lda     $0378,x                         ; A14F BD 78 03                 .x.
        clc                                     ; A152 18                       .
        adc     #$03                            ; A153 69 03                    i.
        sta     $0378,x                         ; A155 9D 78 03                 .x.
        lda     #$81                            ; A158 A9 81                    ..
        sta     $0408,x                         ; A15A 9D 08 04                 ...
        lda     #$3C                            ; A15D A9 3C                    .<
        sta     $0468,x                         ; A15F 9D 68 04                 .h.
        lda     #$B8                            ; A162 A9 B8                    ..
        sta     $0588,x                         ; A164 9D 88 05                 ...
        lda     #$A0                            ; A167 A9 A0                    ..
        sta     $05A0,x                         ; A169 9D A0 05                 ...
LA16C:  rts                                     ; A16C 60                       `

; ----------------------------------------------------------------------------
LA16D:  stx     $0F                             ; A16D 86 0F                    ..
        lda     #$02                            ; A16F A9 02                    ..
        sta     $0E                             ; A171 85 0E                    ..
        lda     $0420,x                         ; A173 BD 20 04                 . .
        and     #$02                            ; A176 29 02                    ).
        asl     a                               ; A178 0A                       .
        asl     a                               ; A179 0A                       .
        sta     $0D                             ; A17A 85 0D                    ..
LA17C:  jsr     find_free_slot_y                           ; A17C 20 6F F1                  o.
        bcs     LA1A3                           ; A17F B0 22                    ."
        lda     #$86                            ; A181 A9 86                    ..
        sta     $0408,y                         ; A183 99 08 04                 ...
        lda     #$51                            ; A186 A9 51                    .Q
        sta     $0300,y                         ; A188 99 00 03                 ...
        lda     #$85                            ; A18B A9 85                    ..
        jsr     entity_init_pos                           ; A18D 20 A4 EA                  ..
        tya                                     ; A190 98                       .
        tax                                     ; A191 AA                       .
        inc     $0D                             ; A192 E6 0D                    ..
        inc     $0D                             ; A194 E6 0D                    ..
        ldy     $0D                             ; A196 A4 0D                    ..
        lda     #$18                            ; A198 A9 18                    ..
        jsr     entity_set_dir_velocity                           ; A19A 20 70 F4                  p.
        ldx     $0F                             ; A19D A6 0F                    ..
        dec     $0E                             ; A19F C6 0E                    ..
        bpl     LA17C                           ; A1A1 10 D9                    ..
LA1A3:  rts                                     ; A1A3 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $C4 — burst fragment (spawned in threes by type $50
; when shot; $F0-frame life)
; =============================================================================
        dec     $0468,x                         ; A1A4 DE 68 04                 .h.
        bne     LA1AC                           ; A1A7 D0 03                    ..
        jmp     LA54D                           ; A1A9 4C 4D A5                 LM.

; ----------------------------------------------------------------------------
LA1AC:  ldy     #$13                            ; A1AC A0 13                    ..
        jsr     entity_gravity_collide                           ; A1AE 20 B7 E7                  ..
        bcs     LA1C4                           ; A1B1 B0 11                    ..
        lda     $0420,x                         ; A1B3 BD 20 04                 . .
        and     #$03                            ; A1B6 29 03                    ).
        beq     LA1A3                           ; A1B8 F0 E9                    ..
        ldy     #$1A                            ; A1BA A0 1A                    ..
        jsr     entity_horiz_dispatch                           ; A1BC 20 3F EA                  ?.
        bcc     LA1A3                           ; A1BF 90 E2                    ..
        jmp     entity_flip_direction                           ; A1C1 4C 4A EC                 LJ.

; ----------------------------------------------------------------------------
LA1C4:  lda     $E6                             ; A1C4 A5 E6                    ..
        adc     $E7                             ; A1C6 65 E7                    e.
        sta     $E6                             ; A1C8 85 E6                    ..
        and     #$01                            ; A1CA 29 01                    ).
        tay                                     ; A1CC A8                       .
        lda     LA1E4,y                         ; A1CD B9 E4 A1                 ...
        sta     $03A8,x                         ; A1D0 9D A8 03                 ...
        lda     LA1E0,y                         ; A1D3 B9 E0 A1                 ...
        sta     $03D8,x                         ; A1D6 9D D8 03                 ...
        lda     LA1E2,y                         ; A1D9 B9 E2 A1                 ...
        sta     $03F0,x                         ; A1DC 9D F0 03                 ...
        rts                                     ; A1DF 60                       `

; ----------------------------------------------------------------------------
LA1E0:  .byte   $D4,$77                         ; A1E0
LA1E2:  .byte   $02,$03                         ; A1E2
LA1E4:  .byte   $58,$48                         ; A1E4
; =============================================================================
; BEHAVIOR type $3D — ledge crawler: hugs whatever surface it sits on and
; circumnavigates platforms — probes ahead each step, turning into walls,
; climbing them, and wrapping around convex corners (y nudged +/-2 while
; rounding); vflip state picks the initial facing (gravity-flip aware)
; =============================================================================
        lda     $03A8,x                         ; A1E6 BD A8 03                 ...
        sta     $03D8,x                         ; A1E9 9D D8 03                 ...
        lda     $03C0,x                         ; A1EC BD C0 03                 ...
        sta     $03F0,x                         ; A1EF 9D F0 03                 ...
        ldy     #$01                            ; A1F2 A0 01                    ..
        lda     $0528,x                         ; A1F4 BD 28 05                 .(.
        sta     $0468,x                         ; A1F7 9D 68 04                 .h.
        and     #$20                            ; A1FA 29 20                    ) 
        bne     LA1FF                           ; A1FC D0 01                    ..
        iny                                     ; A1FE C8                       .
LA1FF:  tya                                     ; A1FF 98                       .
        ora     #$04                            ; A200 09 04                    ..
        sta     $0420,x                         ; A202 9D 20 04                 . .
        lda     #$0F                            ; A205 A9 0F                    ..
        sta     $0588,x                         ; A207 9D 88 05                 ...
        lda     #$A2                            ; A20A A9 A2                    ..
        sta     $05A0,x                         ; A20C 9D A0 05                 ...
        ldy     #$07                            ; A20F A0 07                    ..
        inc     $03F0,x                         ; A211 FE F0 03                 ...
        jsr     LE747                           ; A214 20 47 E7                  G.
        dec     $03F0,x                         ; A217 DE F0 03                 ...
        bcc     LA21F                           ; A21A 90 03                    ..
        jmp     LA273                           ; A21C 4C 73 A2                 Ls.

; ----------------------------------------------------------------------------
LA21F:  inc     $0378,x                         ; A21F FE 78 03                 .x.
        inc     $0378,x                         ; A222 FE 78 03                 .x.
        jsr     LA2A6                           ; A225 20 A6 A2                  ..
        ldy     #$0E                            ; A228 A0 0E                    ..
        inc     $03C0,x                         ; A22A FE C0 03                 ...
        jsr     entity_horiz_dispatch                           ; A22D 20 3F EA                  ?.
        dec     $03C0,x                         ; A230 DE C0 03                 ...
        lda     $0468,x                         ; A233 BD 68 04                 .h.
        sta     $0528,x                         ; A236 9D 28 05                 .(.
        bcc     LA247                           ; A239 90 0C                    ..
        ldy     #$07                            ; A23B A0 07                    ..
        jsr     entity_vert_dispatch                           ; A23D 20 52 EA                  R.
        bcc     LA290                           ; A240 90 4E                    .N
        jsr     L852F                           ; A242 20 2F 85                  /.
        bne     LA24A                           ; A245 D0 03                    ..
LA247:  jsr     LA291                           ; A247 20 91 A2                  ..
LA24A:  lda     $0420,x                         ; A24A BD 20 04                 . .
        and     #$08                            ; A24D 29 08                    ).
        bne     LA25C                           ; A24F D0 0B                    ..
        lda     #$0F                            ; A251 A9 0F                    ..
        sta     $0588,x                         ; A253 9D 88 05                 ...
        lda     #$A2                            ; A256 A9 A2                    ..
        sta     $05A0,x                         ; A258 9D A0 05                 ...
        rts                                     ; A25B 60                       `

; ----------------------------------------------------------------------------
LA25C:  lda     #$66                            ; A25C A9 66                    .f
        sta     $0588,x                         ; A25E 9D 88 05                 ...
        lda     #$A2                            ; A261 A9 A2                    ..
        sta     $05A0,x                         ; A263 9D A0 05                 ...
        ldy     #$08                            ; A266 A0 08                    ..
        inc     $03F0,x                         ; A268 FE F0 03                 ...
        jsr     entity_move_up                           ; A26B 20 80 E7                  ..
        dec     $03F0,x                         ; A26E DE F0 03                 ...
        bcc     LA287                           ; A271 90 14                    ..
LA273:  ldy     #$0E                            ; A273 A0 0E                    ..
        jsr     entity_horiz_dispatch                           ; A275 20 3F EA                  ?.
        lda     $0468,x                         ; A278 BD 68 04                 .h.
        sta     $0528,x                         ; A27B 9D 28 05                 .(.
        bcc     LA290                           ; A27E 90 10                    ..
        lda     $0420,x                         ; A280 BD 20 04                 . .
        eor     #$0C                            ; A283 49 0C                    I.
        bne     LA2AB                           ; A285 D0 24                    .$
LA287:  jsr     LA2A6                           ; A287 20 A6 A2                  ..
        dec     $0378,x                         ; A28A DE 78 03                 .x.
        dec     $0378,x                         ; A28D DE 78 03                 .x.
LA290:  rts                                     ; A290 60                       `

; ----------------------------------------------------------------------------
LA291:  jsr     L8538                           ; A291 20 38 85                  8.
        and     #$01                            ; A294 29 01                    ).
        bne     LA29F                           ; A296 D0 07                    ..
        dec     $0330,x                         ; A298 DE 30 03                 .0.
        dec     $0330,x                         ; A29B DE 30 03                 .0.
        rts                                     ; A29E 60                       `

; ----------------------------------------------------------------------------
LA29F:  inc     $0330,x                         ; A29F FE 30 03                 .0.
        inc     $0330,x                         ; A2A2 FE 30 03                 .0.
        rts                                     ; A2A5 60                       `

; ----------------------------------------------------------------------------
LA2A6:  lda     $0420,x                         ; A2A6 BD 20 04                 . .
        eor     #$03                            ; A2A9 49 03                    I.
LA2AB:  sta     $0420,x                         ; A2AB 9D 20 04                 . .
        lda     #$28                            ; A2AE A9 28                    .(
        sta     $0588,x                         ; A2B0 9D 88 05                 ...
        lda     #$A2                            ; A2B3 A9 A2                    ..
        sta     $05A0,x                         ; A2B5 9D A0 05                 ...
        rts                                     ; A2B8 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $53 — pop-out ambusher: dormant until the player is within
; $50 px horizontally and $10 px vertically; then plays its emerge anim
; (sub_type $75) — mid-anim it settles 4 px and turns armored+damaging
; (shape $D1) — and at anim phase 2 becomes a walker (sub_type $76) that
; sets off toward the player under gravity, reversing at walls
; =============================================================================
        jsr     entity_x_dist_px                           ; A2B9 20 94 EC                  ..
        cmp     #$50                            ; A2BC C9 50                    .P
        bcs     LA31E                           ; A2BE B0 5E                    .^
        jsr     entity_y_dist_abs                           ; A2C0 20 76 EC                  v.
        cmp     #$10                            ; A2C3 C9 10                    ..
        bcs     LA31E                           ; A2C5 B0 57                    .W
        lda     #$75                            ; A2C7 A9 75                    .u
        jsr     entity_set_subtype                           ; A2C9 20 98 EA                  ..
        lda     #$D7                            ; A2CC A9 D7                    ..
        sta     $0588,x                         ; A2CE 9D 88 05                 ...
        lda     #$A2                            ; A2D1 A9 A2                    ..
        sta     $05A0,x                         ; A2D3 9D A0 05                 ...
        rts                                     ; A2D6 60                       `

; ----------------------------------------------------------------------------
        lda     $0570,x                         ; A2D7 BD 70 05                 .p.
        cmp     #$04                            ; A2DA C9 04                    ..
        bne     LA31E                           ; A2DC D0 40                    .@
        lda     $0540,x                         ; A2DE BD 40 05                 .@.
        bne     LA2F1                           ; A2E1 D0 0E                    ..
        lda     $0378,x                         ; A2E3 BD 78 03                 .x.
        clc                                     ; A2E6 18                       .
        adc     #$04                            ; A2E7 69 04                    i.
        sta     $0378,x                         ; A2E9 9D 78 03                 .x.
        lda     #$D1                            ; A2EC A9 D1                    ..
        sta     $0408,x                         ; A2EE 9D 08 04                 ...
LA2F1:  cmp     #$02                            ; A2F1 C9 02                    ..
        bne     LA31E                           ; A2F3 D0 29                    .)
        lda     #$76                            ; A2F5 A9 76                    .v
        jsr     entity_set_subtype                           ; A2F7 20 98 EA                  ..
        lda     #$0A                            ; A2FA A9 0A                    ..
        sta     $0588,x                         ; A2FC 9D 88 05                 ...
        lda     #$A3                            ; A2FF A9 A3                    ..
        sta     $05A0,x                         ; A301 9D A0 05                 ...
        jsr     entity_set_facing                           ; A304 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A307 20 30 EC                  0.
        ldy     #$13                            ; A30A A0 13                    ..
        jsr     entity_gravity_collide                           ; A30C 20 B7 E7                  ..
        bcc     LA31E                           ; A30F 90 0D                    ..
        ldy     #$1A                            ; A311 A0 1A                    ..
        jsr     entity_horiz_dispatch                           ; A313 20 3F EA                  ?.
        jsr     L8526                           ; A316 20 26 85                  &.
        bcc     LA31E                           ; A319 90 03                    ..
        jsr     entity_flip_direction                           ; A31B 20 4A EC                  J.
LA31E:  rts                                     ; A31E 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $54 — hovering strafer: flies horizontally, reversing
; direction every $40 frames ($20 on the first leg, so it sways about
; its spawn point); every $96 frames releases a 2-shot spread (type $55,
; sub_type $78, speed idx $08) fanned one 16-dir step either side of
; the aim-at-player angle
; =============================================================================
        lda     #$20                            ; A31F A9 20                    . 
        sta     $0468,x                         ; A321 9D 68 04                 .h.
        lda     #$2D                            ; A324 A9 2D                    .-
        sta     $0480,x                         ; A326 9D 80 04                 ...
        lda     #$33                            ; A329 A9 33                    .3
        sta     $0588,x                         ; A32B 9D 88 05                 ...
        lda     #$A3                            ; A32E A9 A3                    ..
        sta     $05A0,x                         ; A330 9D A0 05                 ...
        jsr     entity_facing_dispatch                           ; A333 20 65 EA                  e.
        jsr     L8526                           ; A336 20 26 85                  &.
        dec     $0468,x                         ; A339 DE 68 04                 .h.
        bne     LA346                           ; A33C D0 08                    ..
        jsr     L852F                           ; A33E 20 2F 85                  /.
        lda     #$40                            ; A341 A9 40                    .@
        sta     $0468,x                         ; A343 9D 68 04                 .h.
LA346:  dec     $0480,x                         ; A346 DE 80 04                 ...
        bne     LA379                           ; A349 D0 2E                    ..
        lda     #$96                            ; A34B A9 96                    ..
        sta     $0480,x                         ; A34D 9D 80 04                 ...
        jsr     LA089                           ; A350 20 89 A0                  ..
LA353:  jsr     find_free_slot_y                           ; A353 20 6F F1                  o.
        bcs     LA379                           ; A356 B0 21                    .!
        lda     #$87                            ; A358 A9 87                    ..
        sta     $0408,y                         ; A35A 99 08 04                 ...
        lda     #$78                            ; A35D A9 78                    .x
        jsr     entity_init_pos                           ; A35F 20 A4 EA                  ..
        lda     $0378,y                         ; A362 B9 78 03                 .x.
        sec                                     ; A365 38                       8
        sbc     #$04                            ; A366 E9 04                    ..
        sta     $0378,y                         ; A368 99 78 03                 .x.
        jsr     LA09D                           ; A36B 20 9D A0                  ..
        lda     #$08                            ; A36E A9 08                    ..
        jsr     entity_set_dir_velocity                           ; A370 20 70 F4                  p.
        ldx     $0D                             ; A373 A6 0D                    ..
        dec     $0E                             ; A375 C6 0E                    ..
        bpl     LA353                           ; A377 10 DA                    ..
LA379:  rts                                     ; A379 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $56 — delayed chaser: lies dormant $78 frames, then plays
; its wake anim with sound $37; once the anim reaches phase 5 it turns
; armored+damaging (shape $C1, sub_type $7A) and homes on the player at
; speed idx $38, re-aiming every $20 frames and dropping an aimed type
; $55 shot (sub_type $7B) every $78 frames; after player contact it
; drifts upward for $3C frames, then re-aims and dives again
; =============================================================================
        lda     $0540,x                         ; A37A BD 40 05                 .@.
        bne     LA396                           ; A37D D0 17                    ..
        sta     $0570,x                         ; A37F 9D 70 05                 .p.
        inc     $0468,x                         ; A382 FE 68 04                 .h.
        lda     $0468,x                         ; A385 BD 68 04                 .h.
        cmp     #$78                            ; A388 C9 78                    .x
        bcc     LA379                           ; A38A 90 ED                    ..
        lda     #$01                            ; A38C A9 01                    ..
        sta     $0540,x                         ; A38E 9D 40 05                 .@.
        lda     #$37                            ; A391 A9 37                    .7
        jmp     queue_sound                           ; A393 4C 5D EC                 L].

; ----------------------------------------------------------------------------
LA396:  cmp     #$05                            ; A396 C9 05                    ..
        bne     LA379                           ; A398 D0 DF                    ..
        lda     $0570,x                         ; A39A BD 70 05                 .p.
        cmp     #$03                            ; A39D C9 03                    ..
        bne     LA379                           ; A39F D0 D8                    ..
        lda     #$7A                            ; A3A1 A9 7A                    .z
        jsr     entity_set_subtype                           ; A3A3 20 98 EA                  ..
        lda     #$C1                            ; A3A6 A9 C1                    ..
        sta     $0408,x                         ; A3A8 9D 08 04                 ...
LA3AB:  lda     #$00                            ; A3AB A9 00                    ..
        sta     $0480,x                         ; A3AD 9D 80 04                 ...
        lda     #$BD                            ; A3B0 A9 BD                    ..
        sta     $0588,x                         ; A3B2 9D 88 05                 ...
        lda     #$A3                            ; A3B5 A9 A3                    ..
        sta     $05A0,x                         ; A3B7 9D A0 05                 ...
        jmp     LA3E6                           ; A3BA 4C E6 A3                 L..

; ----------------------------------------------------------------------------
        jsr     entity_player_collide                           ; A3BD 20 87 EF                  ..
        bcs     LA3DC                           ; A3C0 B0 1A                    ..
        lda     #$00                            ; A3C2 A9 00                    ..
        sta     $03D8,x                         ; A3C4 9D D8 03                 ...
        lda     #$01                            ; A3C7 A9 01                    ..
        sta     $03F0,x                         ; A3C9 9D F0 03                 ...
        lda     #$31                            ; A3CC A9 31                    .1
        sta     $0588,x                         ; A3CE 9D 88 05                 ...
        lda     #$A4                            ; A3D1 A9 A4                    ..
        sta     $05A0,x                         ; A3D3 9D A0 05                 ...
        lda     #$3C                            ; A3D6 A9 3C                    .<
        sta     $04B0,x                         ; A3D8 9D B0 04                 ...
        rts                                     ; A3DB 60                       `

; ----------------------------------------------------------------------------
LA3DC:  inc     $0480,x                         ; A3DC FE 80 04                 ...
        lda     $0480,x                         ; A3DF BD 80 04                 ...
        and     #$1F                            ; A3E2 29 1F                    ).
        bne     LA3EF                           ; A3E4 D0 09                    ..
LA3E6:  jsr     entity_distance_calc                           ; A3E6 20 C2 EC                  ..
        tay                                     ; A3E9 A8                       .
        lda     #$38                            ; A3EA A9 38                    .8
        jsr     entity_set_dir_velocity                           ; A3EC 20 70 F4                  p.
LA3EF:  jsr     entity_facing_dispatch                           ; A3EF 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A3F2 20 86 EA                  ..
        dec     $0468,x                         ; A3F5 DE 68 04                 .h.
        bne     LA43C                           ; A3F8 D0 42                    .B
        jsr     entity_distance_calc                           ; A3FA 20 C2 EC                  ..
        sta     $0D                             ; A3FD 85 0D                    ..
        lda     #$78                            ; A3FF A9 78                    .x
        sta     $0468,x                         ; A401 9D 68 04                 .h.
        stx     $0F                             ; A404 86 0F                    ..
        jsr     find_free_slot_y                           ; A406 20 6F F1                  o.
        bcs     LA43C                           ; A409 B0 31                    .1
        lda     #$87                            ; A40B A9 87                    ..
        sta     $0408,y                         ; A40D 99 08 04                 ...
        lda     #$55                            ; A410 A9 55                    .U
        sta     $0300,y                         ; A412 99 00 03                 ...
        lda     #$7B                            ; A415 A9 7B                    .{
        jsr     entity_init_pos                           ; A417 20 A4 EA                  ..
        lda     $0378,y                         ; A41A B9 78 03                 .x.
        clc                                     ; A41D 18                       .
        adc     #$08                            ; A41E 69 08                    i.
        sta     $0378,y                         ; A420 99 78 03                 .x.
        sty     $0E                             ; A423 84 0E                    ..
        ldy     $0D                             ; A425 A4 0D                    ..
        ldx     $0E                             ; A427 A6 0E                    ..
        lda     #$08                            ; A429 A9 08                    ..
        jsr     entity_set_dir_velocity                           ; A42B 20 70 F4                  p.
        ldx     $0F                             ; A42E A6 0F                    ..
        rts                                     ; A430 60                       `

; ----------------------------------------------------------------------------
        jsr     entity_move_up_nofacing                           ; A431 20 4A E9                  J.
        dec     $04B0,x                         ; A434 DE B0 04                 ...
        bne     LA43C                           ; A437 D0 03                    ..
        jmp     LA3AB                           ; A439 4C AB A3                 L..

; ----------------------------------------------------------------------------
LA43C:  rts                                     ; A43C 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $18 — shell-back walker: patrols, turning around at walls
; and ledges (sub_type $24 turn anim, flip at its midpoint, back to $23);
; sets the shot-deflect bit every frame but clears it when an incoming
; shot's direction opposes its own facing — so shots striking its face
; connect while shots hitting its armored back bounce off
; =============================================================================
        lda     $0558,x                         ; A43D BD 58 05                 .X.
        cmp     #$24                            ; A440 C9 24                    .$
        beq     LA45B                           ; A442 F0 17                    ..
        ldy     #$18                            ; A444 A0 18                    ..
        jsr     entity_horiz_dispatch                           ; A446 20 3F EA                  ?.
        bcs     LA456                           ; A449 B0 0B                    ..
        ldy     #$20                            ; A44B A0 20                    . 
        jsr     tile_collide_horiz                           ; A44D 20 A1 C4                  ..
        lda     L0010                           ; A450 A5 10                    ..
        and     #$10                            ; A452 29 10                    ).
        bne     LA478                           ; A454 D0 22                    ."
LA456:  lda     #$24                            ; A456 A9 24                    .$
        jsr     entity_set_subtype                           ; A458 20 98 EA                  ..
LA45B:  lda     $0570,x                         ; A45B BD 70 05                 .p.
        cmp     #$04                            ; A45E C9 04                    ..
        bne     LA478                           ; A460 D0 16                    ..
        lda     $0540,x                         ; A462 BD 40 05                 .@.
        cmp     #$02                            ; A465 C9 02                    ..
        beq     LA475                           ; A467 F0 0C                    ..
        cmp     #$04                            ; A469 C9 04                    ..
        bne     LA478                           ; A46B D0 0B                    ..
        lda     #$23                            ; A46D A9 23                    .#
        jsr     entity_set_subtype                           ; A46F 20 98 EA                  ..
        jmp     LA478                           ; A472 4C 78 A4                 Lx.

; ----------------------------------------------------------------------------
LA475:  jsr     entity_flip_direction                           ; A475 20 4A EC                  J.
LA478:  lda     $0408,x                         ; A478 BD 08 04                 ...
        ora     #$40                            ; A47B 09 40                    .@
        sta     $0408,x                         ; A47D 9D 08 04                 ...
        jsr     entity_hitbox_check                           ; A480 20 F8 EF                  ..
        bcs     LA497                           ; A483 B0 12                    ..
        lda     $0420,y                         ; A485 B9 20 04                 . .
        and     #$03                            ; A488 29 03                    ).
        cmp     $0420,x                         ; A48A DD 20 04                 . .
        beq     LA497                           ; A48D F0 08                    ..
        lda     $0408,x                         ; A48F BD 08 04                 ...
        and     #$BF                            ; A492 29 BF                    ).
        sta     $0408,x                         ; A494 9D 08 04                 ...
LA497:  rts                                     ; A497 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $5A — kamikaze flyer: sails horizontally; striking a wall
; bursts it (sound $2B, self becomes a type $01/$42 puff) into 3 type $5B
; fragments fanned around the aim-at-player angle; while Gravity Hold is
; equipped it turns shot-proof (shape $E2); if a shot kills it instead
; (manual damage_engine call), it splits into 3 type $5B fragments in a
; wide fan (angles $0E/$0A/$06; sub_types from LA543, gravity-flip aware)
; =============================================================================
        ldy     #$0E                            ; A498 A0 0E                    ..
        jsr     entity_horiz_dispatch                           ; A49A 20 3F EA                  ?.
        bcc     LA4DB                           ; A49D 90 3C                    .<
        jsr     LA089                           ; A49F 20 89 A0                  ..
        inc     $0E                             ; A4A2 E6 0E                    ..
        jsr     LA54D                           ; A4A4 20 4D A5                  M.
        lda     #$2B                            ; A4A7 A9 2B                    .+
        jsr     queue_sound                           ; A4A9 20 5D EC                  ].
LA4AC:  jsr     find_free_slot_y                           ; A4AC 20 6F F1                  o.
        bcs     LA4DA                           ; A4AF B0 29                    .)
        lda     #$87                            ; A4B1 A9 87                    ..
        sta     $0408,y                         ; A4B3 99 08 04                 ...
        lda     #$5B                            ; A4B6 A9 5B                    .[
        sta     $0300,y                         ; A4B8 99 00 03                 ...
        lda     #$82                            ; A4BB A9 82                    ..
        sec                                     ; A4BD 38                       8
        sbc     $0E                             ; A4BE E5 0E                    ..
        jsr     entity_init_pos                           ; A4C0 20 A4 EA                  ..
        tya                                     ; A4C3 98                       .
        tax                                     ; A4C4 AA                       .
        ldy     $0F                             ; A4C5 A4 0F                    ..
        lda     #$08                            ; A4C7 A9 08                    ..
        jsr     entity_set_dir_velocity                           ; A4C9 20 70 F4                  p.
        ldx     $0D                             ; A4CC A6 0D                    ..
        inc     $0F                             ; A4CE E6 0F                    ..
        lda     $0F                             ; A4D0 A5 0F                    ..
        and     #$0F                            ; A4D2 29 0F                    ).
        sta     $0F                             ; A4D4 85 0F                    ..
        dec     $0E                             ; A4D6 C6 0E                    ..
        bpl     LA4AC                           ; A4D8 10 D2                    ..
LA4DA:  rts                                     ; A4DA 60                       `

; ----------------------------------------------------------------------------
LA4DB:  lda     #$A2                            ; A4DB A9 A2                    ..
        sta     $0408,x                         ; A4DD 9D 08 04                 ...
        lda     $32                             ; A4E0 A5 32                    .2
        cmp     #$07                            ; A4E2 C9 07                    ..
        bne     LA4EC                           ; A4E4 D0 06                    ..
        lda     #$E2                            ; A4E6 A9 E2                    ..
        sta     $0408,x                         ; A4E8 9D 08 04                 ...
        rts                                     ; A4EB 60                       `

; ----------------------------------------------------------------------------
LA4EC:  jsr     entity_hitbox_check                           ; A4EC 20 F8 EF                  ..
        bcs     LA4DA                           ; A4EF B0 E9                    ..
        lda     #$40                            ; A4F1 A9 40                    .@
        sta     L0000                           ; A4F3 85 00                    ..
        jsr     L809D                           ; A4F5 20 9D 80                  ..
        lda     $0300,x                         ; A4F8 BD 00 03                 ...
        cmp     #$5A                            ; A4FB C9 5A                    .Z
        beq     LA4DA                           ; A4FD F0 DB                    ..
        lda     #$0E                            ; A4FF A9 0E                    ..
        sta     $0D                             ; A501 85 0D                    ..
        lda     #$03                            ; A503 A9 03                    ..
        sta     $0E                             ; A505 85 0E                    ..
        stx     $0F                             ; A507 86 0F                    ..
LA509:  jsr     find_free_slot_y                           ; A509 20 6F F1                  o.
        bcs     LA4DA                           ; A50C B0 CC                    ..
        lda     #$87                            ; A50E A9 87                    ..
        sta     $0408,y                         ; A510 99 08 04                 ...
        lda     #$5B                            ; A513 A9 5B                    .[
        sta     $0300,y                         ; A515 99 00 03                 ...
        lda     $0528,x                         ; A518 BD 28 05                 .(.
        ldx     $0E                             ; A51B A6 0E                    ..
        and     #$20                            ; A51D 29 20                    ) 
        beq     LA524                           ; A51F F0 03                    ..
        inx                                     ; A521 E8                       .
        inx                                     ; A522 E8                       .
        inx                                     ; A523 E8                       .
LA524:  lda     LA543,x                         ; A524 BD 43 A5                 .C.
        ldx     $0F                             ; A527 A6 0F                    ..
        jsr     entity_init_pos                           ; A529 20 A4 EA                  ..
        tya                                     ; A52C 98                       .
        tax                                     ; A52D AA                       .
        ldy     $0D                             ; A52E A4 0D                    ..
        lda     #$08                            ; A530 A9 08                    ..
        jsr     entity_set_dir_velocity                           ; A532 20 70 F4                  p.
        ldx     $0F                             ; A535 A6 0F                    ..
        dec     $0E                             ; A537 C6 0E                    ..
        lda     $0D                             ; A539 A5 0D                    ..
        sec                                     ; A53B 38                       8
        sbc     #$04                            ; A53C E9 04                    ..
        sta     $0D                             ; A53E 85 0D                    ..
        bpl     LA509                           ; A540 10 C7                    ..
        rts                                     ; A542 60                       `

; ----------------------------------------------------------------------------
LA543:  .byte   $80                             ; A543 80                       .
        .byte   $82                             ; A544 82                       .
        sta     ($7F,x)                         ; A545 81 7F                    ..
        sta     ($82,x)                         ; A547 81 82                    ..
        .byte   $80                             ; A549 80                       .
; =============================================================================
; BEHAVIOR type $5B — burst fragment (spawned in threes by type $5A):
; drifts on its launch velocity (facing + raw y dispatch, flags kept)
; =============================================================================
        jmp     L84FC                           ; A54A 4C FC 84                 L..

; ----------------------------------------------------------------------------
LA54D:  jsr     entity_wipe_x                           ; A54D 20 C4 F2                  ..
        lda     #$01                            ; A550 A9 01                    ..
        sta     $0300,x                         ; A552 9D 00 03                 ...
        lda     #$2B                            ; A555 A9 2B                    .+
        jsr     queue_sound                           ; A557 20 5D EC                  ].
        lda     #$42                            ; A55A A9 42                    .B
        jmp     entity_set_subtype                           ; A55C 4C 98 EA                 L..

; ----------------------------------------------------------------------------
        jsr     entity_wipe_y                           ; A55F 20 FE F2                  ..
        lda     #$01                            ; A562 A9 01                    ..
        sta     $0300,y                         ; A564 99 00 03                 ...
        lda     #$42                            ; A567 A9 42                    .B
        jmp     entity_init_subtype_y                           ; A569 4C E9 EA                 L..

; ----------------------------------------------------------------------------
LA56C:  jsr     entity_wipe_x                           ; A56C 20 C4 F2                  ..
        lda     #$2F                            ; A56F A9 2F                    ./
        sta     $0300,x                         ; A571 9D 00 03                 ...
        lda     #$42                            ; A574 A9 42                    .B
        jmp     entity_set_subtype                           ; A576 4C 98 EA                 L..

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $5D — minion generator: stationary, always facing the
; player; keeps up to 3 type $52 hoppers alive — when fewer exist
; (checked every 8 frames, $32-frame cooldown) it plays its spawn anim
; (sub_type $87) and births one with 1 HP walking at 1 px/frame, then
; idles again (sub_type $AE); LA620 = its hurt check, probing a taller
; box $0C px above the sprite (shape $CD) and calling damage_engine
; =============================================================================
        jsr     LA620                           ; A579 20 20 A6                   .
        bcc     LA5BD                           ; A57C 90 3F                    .?
        jsr     entity_set_facing                           ; A57E 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A581 20 30 EC                  0.
        lda     $0468,x                         ; A584 BD 68 04                 .h.
        beq     LA58E                           ; A587 F0 05                    ..
        dec     $0468,x                         ; A589 DE 68 04                 .h.
        bne     LA5BD                           ; A58C D0 2F                    ./
LA58E:  lda     $9D                             ; A58E A5 9D                    ..
        and     #$07                            ; A590 29 07                    ).
        bne     LA5BD                           ; A592 D0 29                    .)
        lda     #$00                            ; A594 A9 00                    ..
        sta     L0000                           ; A596 85 00                    ..
        ldy     #$17                            ; A598 A0 17                    ..
LA59A:  lda     $0300,y                         ; A59A B9 00 03                 ...
        cmp     #$52                            ; A59D C9 52                    .R
        bne     LA5A3                           ; A59F D0 02                    ..
        inc     L0000                           ; A5A1 E6 00                    ..
LA5A3:  dey                                     ; A5A3 88                       .
        cpy     #$07                            ; A5A4 C0 07                    ..
        bcs     LA59A                           ; A5A6 B0 F2                    ..
        lda     L0000                           ; A5A8 A5 00                    ..
        cmp     #$03                            ; A5AA C9 03                    ..
        bcs     LA61F                           ; A5AC B0 71                    .q
        lda     #$87                            ; A5AE A9 87                    ..
        jsr     entity_set_subtype                           ; A5B0 20 98 EA                  ..
        lda     #$BE                            ; A5B3 A9 BE                    ..
        sta     $0588,x                         ; A5B5 9D 88 05                 ...
        lda     #$A5                            ; A5B8 A9 A5                    ..
        sta     $05A0,x                         ; A5BA 9D A0 05                 ...
LA5BD:  rts                                     ; A5BD 60                       `

; ----------------------------------------------------------------------------
        jsr     LA620                           ; A5BE 20 20 A6                   .
        bcc     LA61F                           ; A5C1 90 5C                    .\
        lda     $0300,x                         ; A5C3 BD 00 03                 ...
        cmp     #$5D                            ; A5C6 C9 5D                    .]
        bne     LA61F                           ; A5C8 D0 55                    .U
        lda     $0570,x                         ; A5CA BD 70 05                 .p.
        cmp     #$04                            ; A5CD C9 04                    ..
        beq     LA5E4                           ; A5CF F0 13                    ..
        cmp     #$08                            ; A5D1 C9 08                    ..
        bne     LA61F                           ; A5D3 D0 4A                    .J
        lda     #$79                            ; A5D5 A9 79                    .y
        sta     $0588,x                         ; A5D7 9D 88 05                 ...
        lda     #$A5                            ; A5DA A9 A5                    ..
        sta     $05A0,x                         ; A5DC 9D A0 05                 ...
        lda     #$AE                            ; A5DF A9 AE                    ..
        jmp     entity_set_subtype                           ; A5E1 4C 98 EA                 L..

; ----------------------------------------------------------------------------
LA5E4:  lda     #$32                            ; A5E4 A9 32                    .2
        sta     $0468,x                         ; A5E6 9D 68 04                 .h.
        jsr     find_free_slot_y                           ; A5E9 20 6F F1                  o.
        bcs     LA61F                           ; A5EC B0 31                    .1
        lda     #$D6                            ; A5EE A9 D6                    ..
        sta     $0408,y                         ; A5F0 99 08 04                 ...
        lda     #$01                            ; A5F3 A9 01                    ..
        sta     $0450,y                         ; A5F5 99 50 04                 .P.
        lda     #$52                            ; A5F8 A9 52                    .R
        sta     $0300,y                         ; A5FA 99 00 03                 ...
        lda     $0420,x                         ; A5FD BD 20 04                 . .
        sta     $0420,y                         ; A600 99 20 04                 . .
        and     #$01                            ; A603 29 01                    ).
        clc                                     ; A605 18                       .
        adc     #$02                            ; A606 69 02                    i.
        sta     L0010                           ; A608 85 10                    ..
        lda     #$88                            ; A60A A9 88                    ..
        jsr     entity_speed_preset                           ; A60C 20 F5 EA                  ..
        lda     #$00                            ; A60F A9 00                    ..
        sta     $03A8,y                         ; A611 99 A8 03                 ...
        lda     #$01                            ; A614 A9 01                    ..
        sta     $03C0,y                         ; A616 99 C0 03                 ...
        jsr     LEA34                           ; A619 20 34 EA                  4.
        inc     $0570,x                         ; A61C FE 70 05                 .p.
LA61F:  rts                                     ; A61F 60                       `

; ----------------------------------------------------------------------------
LA620:  lda     $0378,x                         ; A620 BD 78 03                 .x.
        sta     $0480,x                         ; A623 9D 80 04                 ...
        sec                                     ; A626 38                       8
        sbc     #$0C                            ; A627 E9 0C                    ..
        sta     $0378,x                         ; A629 9D 78 03                 .x.
        lda     #$CD                            ; A62C A9 CD                    ..
        sta     $0408,x                         ; A62E 9D 08 04                 ...
        jsr     entity_hitbox_check                           ; A631 20 F8 EF                  ..
        lda     $0480,x                         ; A634 BD 80 04                 ...
        sta     $0378,x                         ; A637 9D 78 03                 .x.
        lda     #$97                            ; A63A A9 97                    ..
        sta     $0408,x                         ; A63C 9D 08 04                 ...
        bcs     LA61F                           ; A63F B0 DE                    ..
        lda     #$40                            ; A641 A9 40                    .@
        sta     L0000                           ; A643 85 00                    ..
        jsr     L809D                           ; A645 20 9D 80                  ..
        clc                                     ; A648 18                       .
        rts                                     ; A649 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $52 — wall-hopping minion (spawned by type $5D): walks
; under gravity until blocked by a wall, then springs up (yvel 5.$7A)
; still moving forward; on landing it resumes walking, reversing only
; if the wall still blocks it
; =============================================================================
        ldy     #$17                            ; A64A A0 17                    ..
        jsr     entity_gravity_collide                           ; A64C 20 B7 E7                  ..
        bcc     LA68B                           ; A64F 90 3A                    .:
        ldy     #$1C                            ; A651 A0 1C                    ..
        jsr     entity_horiz_dispatch                           ; A653 20 3F EA                  ?.
        bcc     LA68B                           ; A656 90 33                    .3
        lda     #$7A                            ; A658 A9 7A                    .z
        sta     $03D8,x                         ; A65A 9D D8 03                 ...
        lda     #$05                            ; A65D A9 05                    ..
        sta     $03F0,x                         ; A65F 9D F0 03                 ...
        lda     #$6C                            ; A662 A9 6C                    .l
        sta     $0588,x                         ; A664 9D 88 05                 ...
        lda     #$A6                            ; A667 A9 A6                    ..
        sta     $05A0,x                         ; A669 9D A0 05                 ...
        ldy     #$17                            ; A66C A0 17                    ..
        jsr     entity_gravity_collide                           ; A66E 20 B7 E7                  ..
        ror     $0F                             ; A671 66 0F                    f.
        ldy     #$1C                            ; A673 A0 1C                    ..
        jsr     entity_horiz_dispatch                           ; A675 20 3F EA                  ?.
        lda     $0F                             ; A678 A5 0F                    ..
        bpl     LA68B                           ; A67A 10 0F                    ..
        bcc     LA681                           ; A67C 90 03                    ..
        jsr     entity_flip_direction                           ; A67E 20 4A EC                  J.
LA681:  lda     #$4A                            ; A681 A9 4A                    .J
        sta     $0588,x                         ; A683 9D 88 05                 ...
        lda     #$A6                            ; A686 A9 A6                    ..
        sta     $05A0,x                         ; A688 9D A0 05                 ...
LA68B:  rts                                     ; A68B 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $5F — slow hopper: leaps in shallow arcs (yvel 5.$A8 up,
; xvel 0.$B5 along its facing), riding gravity while airborne; each
; landing plays a crouch anim, then it springs again — it never re-aims
; at the player
; =============================================================================
        lda     #$B5                            ; A68C A9 B5                    ..
        sta     $03A8,x                         ; A68E 9D A8 03                 ...
        lda     #$00                            ; A691 A9 00                    ..
        sta     $03C0,x                         ; A693 9D C0 03                 ...
        jsr     LA6C5                           ; A696 20 C5 A6                  ..
        lda     #$00                            ; A699 A9 00                    ..
        sta     $0570,x                         ; A69B 9D 70 05                 .p.
        ldy     #$17                            ; A69E A0 17                    ..
        jsr     entity_gravity_collide                           ; A6A0 20 B7 E7                  ..
        bcs     LA6A8                           ; A6A3 B0 03                    ..
        jmp     entity_facing_dispatch                           ; A6A5 4C 65 EA                 Le.

; ----------------------------------------------------------------------------
LA6A8:  lda     #$01                            ; A6A8 A9 01                    ..
        sta     $0540,x                         ; A6AA 9D 40 05                 .@.
        lda     #$B7                            ; A6AD A9 B7                    ..
        sta     $0588,x                         ; A6AF 9D 88 05                 ...
        lda     #$A6                            ; A6B2 A9 A6                    ..
        sta     $05A0,x                         ; A6B4 9D A0 05                 ...
        lda     $0570,x                         ; A6B7 BD 70 05                 .p.
        cmp     #$04                            ; A6BA C9 04                    ..
        bne     LA6D9                           ; A6BC D0 1B                    ..
        lda     $0540,x                         ; A6BE BD 40 05                 .@.
        cmp     #$02                            ; A6C1 C9 02                    ..
        bne     LA6D9                           ; A6C3 D0 14                    ..
LA6C5:  lda     #$A8                            ; A6C5 A9 A8                    ..
        sta     $03D8,x                         ; A6C7 9D D8 03                 ...
        lda     #$05                            ; A6CA A9 05                    ..
        sta     $03F0,x                         ; A6CC 9D F0 03                 ...
        lda     #$99                            ; A6CF A9 99                    ..
        sta     $0588,x                         ; A6D1 9D 88 05                 ...
        lda     #$A6                            ; A6D4 A9 A6                    ..
        sta     $05A0,x                         ; A6D6 9D A0 05                 ...
LA6D9:  rts                                     ; A6D9 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $60 — pop-up turret: hidden until the player is within
; $40 px horizontally and $10 px vertically; emerges facing the player
; in three 4-px steps (shapes $D1/$C0/$CC per anim phase), fires a type
; $61 shot straight ahead at 2 px/frame (anim phase 9), then at phase
; $10 retracts step by step (shapes reversed via LA7BA) and stays
; hidden $1E frames before re-arming
; =============================================================================
        lda     #$00                            ; A6DA A9 00                    ..
        sta     $0570,x                         ; A6DC 9D 70 05                 .p.
        jsr     entity_x_dist_px                           ; A6DF 20 94 EC                  ..
        cmp     #$40                            ; A6E2 C9 40                    .@
        bcs     LA6D9                           ; A6E4 B0 F3                    ..
        jsr     entity_y_dist_abs                           ; A6E6 20 76 EC                  v.
        cmp     #$10                            ; A6E9 C9 10                    ..
        bcs     LA6D9                           ; A6EB B0 EC                    ..
        lda     #$FC                            ; A6ED A9 FC                    ..
        sta     $0588,x                         ; A6EF 9D 88 05                 ...
        lda     #$A6                            ; A6F2 A9 A6                    ..
        sta     $05A0,x                         ; A6F4 9D A0 05                 ...
        lda     #$04                            ; A6F7 A9 04                    ..
        sta     $0570,x                         ; A6F9 9D 70 05                 .p.
        jsr     entity_set_facing                           ; A6FC 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A6FF 20 30 EC                  0.
        lda     $0570,x                         ; A702 BD 70 05                 .p.
        cmp     #$04                            ; A705 C9 04                    ..
        bne     LA6D9                           ; A707 D0 D0                    ..
        ldy     $0540,x                         ; A709 BC 40 05                 .@.
        lda     LA7BB,y                         ; A70C B9 BB A7                 ...
        sta     $0408,x                         ; A70F 9D 08 04                 ...
        lda     $0378,x                         ; A712 BD 78 03                 .x.
        sec                                     ; A715 38                       8
        sbc     #$04                            ; A716 E9 04                    ..
        sta     $0378,x                         ; A718 9D 78 03                 .x.
        cpy     #$02                            ; A71B C0 02                    ..
        bne     LA6D9                           ; A71D D0 BA                    ..
        lda     #$29                            ; A71F A9 29                    .)
        sta     $0588,x                         ; A721 9D 88 05                 ...
        lda     #$A7                            ; A724 A9 A7                    ..
        sta     $05A0,x                         ; A726 9D A0 05                 ...
        lda     $0570,x                         ; A729 BD 70 05                 .p.
        cmp     #$04                            ; A72C C9 04                    ..
        bne     LA6D9                           ; A72E D0 A9                    ..
        lda     $0540,x                         ; A730 BD 40 05                 .@.
        cmp     #$10                            ; A733 C9 10                    ..
        beq     LA767                           ; A735 F0 30                    .0
        cmp     #$09                            ; A737 C9 09                    ..
        bne     LA6D9                           ; A739 D0 9E                    ..
        jsr     find_free_slot_y                           ; A73B 20 6F F1                  o.
        bcs     LA6D9                           ; A73E B0 99                    ..
        lda     #$87                            ; A740 A9 87                    ..
        sta     $0408,y                         ; A742 99 08 04                 ...
        lda     #$61                            ; A745 A9 61                    .a
        sta     $0300,y                         ; A747 99 00 03                 ...
        lda     $0420,x                         ; A74A BD 20 04                 . .
        sta     $0420,y                         ; A74D 99 20 04                 . .
        and     #$01                            ; A750 29 01                    ).
        clc                                     ; A752 18                       .
        adc     #$28                            ; A753 69 28                    i(
        sta     L0010                           ; A755 85 10                    ..
        lda     #$8A                            ; A757 A9 8A                    ..
        jsr     entity_speed_preset                           ; A759 20 F5 EA                  ..
        lda     #$00                            ; A75C A9 00                    ..
        sta     $03A8,y                         ; A75E 99 A8 03                 ...
        lda     #$02                            ; A761 A9 02                    ..
        sta     $03C0,y                         ; A763 99 C0 03                 ...
        rts                                     ; A766 60                       `

; ----------------------------------------------------------------------------
LA767:  lda     #$76                            ; A767 A9 76                    .v
        sta     $0588,x                         ; A769 9D 88 05                 ...
        lda     #$A7                            ; A76C A9 A7                    ..
        sta     $05A0,x                         ; A76E 9D A0 05                 ...
        lda     #$02                            ; A771 A9 02                    ..
        sta     $0468,x                         ; A773 9D 68 04                 .h.
        lda     $0480,x                         ; A776 BD 80 04                 ...
        beq     LA790                           ; A779 F0 15                    ..
        lda     #$00                            ; A77B A9 00                    ..
        sta     $0570,x                         ; A77D 9D 70 05                 .p.
        dec     $0480,x                         ; A780 DE 80 04                 ...
        bne     LA7B9                           ; A783 D0 34                    .4
        lda     #$DA                            ; A785 A9 DA                    ..
        sta     $0588,x                         ; A787 9D 88 05                 ...
        lda     #$A6                            ; A78A A9 A6                    ..
        sta     $05A0,x                         ; A78C 9D A0 05                 ...
        rts                                     ; A78F 60                       `

; ----------------------------------------------------------------------------
LA790:  lda     $0570,x                         ; A790 BD 70 05                 .p.
        cmp     #$04                            ; A793 C9 04                    ..
        bne     LA7B9                           ; A795 D0 22                    ."
        lda     $0540,x                         ; A797 BD 40 05                 .@.
        cmp     #$13                            ; A79A C9 13                    ..
        beq     LA7B4                           ; A79C F0 16                    ..
        lda     $0378,x                         ; A79E BD 78 03                 .x.
        clc                                     ; A7A1 18                       .
        adc     #$04                            ; A7A2 69 04                    i.
        sta     $0378,x                         ; A7A4 9D 78 03                 .x.
        ldy     $0468,x                         ; A7A7 BC 68 04                 .h.
        lda     LA7BA,y                         ; A7AA B9 BA A7                 ...
        sta     $0408,x                         ; A7AD 9D 08 04                 ...
        dec     $0468,x                         ; A7B0 DE 68 04                 .h.
        rts                                     ; A7B3 60                       `

; ----------------------------------------------------------------------------
LA7B4:  lda     #$1E                            ; A7B4 A9 1E                    ..
        sta     $0480,x                         ; A7B6 9D 80 04                 ...
LA7B9:  rts                                     ; A7B9 60                       `

; ----------------------------------------------------------------------------
LA7BA:  dex                                     ; A7BA CA                       .
LA7BB:  .byte   $D1,$C0,$CC                     ; A7BB
; =============================================================================
; BEHAVIOR type $26 — recycling dripper: waits inert at y=$30 for a
; pseudo-random delay (LA82E[frame-rng $E6 & 3] frames), then falls; a
; weapon hit (damage_engine with $00=0) or falling past y=$E8 resets it
; to the top with a fresh delay — the kill is undone by restoring its
; type/spawn index, so the drip respawns forever
; =============================================================================
        lda     $0468,x                         ; A7BE BD 68 04
        beq     LA7C8                           ; A7C1 F0 05                    ..
        dec     $0468,x                         ; A7C3 DE 68 04                 .h.
        bne     LA82D                           ; A7C6 D0 65                    .e
LA7C8:  jsr     entity_stop_y                           ; A7C8 20 1E EA                  ..
        lda     $0528,x                         ; A7CB BD 28 05                 .(.
        and     #$FB                            ; A7CE 29 FB                    ).
        sta     $0528,x                         ; A7D0 9D 28 05                 .(.
        lda     #$DD                            ; A7D3 A9 DD                    ..
        sta     $0588,x                         ; A7D5 9D 88 05                 ...
        lda     #$A7                            ; A7D8 A9 A7                    ..
        sta     $05A0,x                         ; A7DA 9D A0 05                 ...
        jsr     entity_process_y_vel                           ; A7DD 20 68 E9                  h.
        jsr     entity_hitbox_check                           ; A7E0 20 F8 EF                  ..
        bcs     LA800                           ; A7E3 B0 1B                    ..
        lda     $0438,x                         ; A7E5 BD 38 04                 .8.
        pha                                     ; A7E8 48                       H
        lda     #$00                            ; A7E9 A9 00                    ..
        sta     L0000                           ; A7EB 85 00                    ..
        jsr     L809D                           ; A7ED 20 9D 80                  ..
        pla                                     ; A7F0 68                       h
        sta     $0438,x                         ; A7F1 9D 38 04                 .8.
        lda     $0300,x                         ; A7F4 BD 00 03                 ...
        bne     LA800                           ; A7F7 D0 07                    ..
        lda     #$26                            ; A7F9 A9 26                    .&
        sta     $0300,x                         ; A7FB 9D 00 03                 ...
        bne     LA807                           ; A7FE D0 07                    ..
LA800:  lda     $0378,x                         ; A800 BD 78 03                 .x.
        cmp     #$E8                            ; A803 C9 E8                    ..
        bcc     LA82D                           ; A805 90 26                    .&
LA807:  lda     $E6                             ; A807 A5 E6                    ..
        adc     $E5                             ; A809 65 E5                    e.
        sta     $E6                             ; A80B 85 E6                    ..
        and     #$03                            ; A80D 29 03                    ).
        tay                                     ; A80F A8                       .
        lda     LA82E,y                         ; A810 B9 2E A8                 ...
        sta     $0468,x                         ; A813 9D 68 04                 .h.
        lda     $0528,x                         ; A816 BD 28 05                 .(.
        ora     #$04                            ; A819 09 04                    ..
        sta     $0528,x                         ; A81B 9D 28 05                 .(.
        lda     #$30                            ; A81E A9 30                    .0
        sta     $0378,x                         ; A820 9D 78 03                 .x.
        lda     #$BE                            ; A823 A9 BE                    ..
        sta     $0588,x                         ; A825 9D 88 05                 ...
        lda     #$A7                            ; A828 A9 A7                    ..
        sta     $05A0,x                         ; A82A 9D A0 05                 ...
LA82D:  rts                                     ; A82D 60                       `

; ----------------------------------------------------------------------------
LA82E:  asl     a                               ; A82E 0A                       .
        .byte   $3C                             ; A82F 3C                       <
        sei                                     ; A830 78                       x
        asl     a                               ; A831 0A                       .
; =============================================================================
; BEHAVIOR type $1D — walking bomb: patrols under gravity, turning at
; walls via anim $36 (flip at its midpoint, then restore the saved
; sub_type/shape from LA908); when calm (sub_type $26) and the player is
; within $50/$28 px it ignites (sound $3D): sub_type drops to $25, xvel
; jumps to 2 px/frame, it sprays 3 type $55 sparks (sub_type $9D, speed
; idx $40, quarter-fan ahead of its facing), pauses $3C frames, and
; $F0 frames later expires into a type $2F/$42 puff (LA56C)
; =============================================================================
        lda     $0480,x                         ; A832 BD 80 04                 ...
        beq     LA83F                           ; A835 F0 08                    ..
        dec     $0480,x                         ; A837 DE 80 04                 ...
        bne     LA83F                           ; A83A D0 03                    ..
        jmp     LA56C                           ; A83C 4C 6C A5                 Ll.

; ----------------------------------------------------------------------------
LA83F:  lda     $0558,x                         ; A83F BD 58 05                 .X.
        cmp     #$36                            ; A842 C9 36                    .6
        bne     LA866                           ; A844 D0 20                    . 
        lda     $0570,x                         ; A846 BD 70 05                 .p.
        cmp     #$06                            ; A849 C9 06                    ..
        bne     LA82D                           ; A84B D0 E0                    ..
        lda     $0540,x                         ; A84D BD 40 05                 .@.
        bne     LA855                           ; A850 D0 03                    ..
        jmp     entity_flip_direction                           ; A852 4C 4A EC                 LJ.

; ----------------------------------------------------------------------------
LA855:  lda     $0468,x                         ; A855 BD 68 04                 .h.
        pha                                     ; A858 48                       H
        jsr     entity_set_subtype                           ; A859 20 98 EA                  ..
        pla                                     ; A85C 68                       h
        and     #$01                            ; A85D 29 01                    ).
        tay                                     ; A85F A8                       .
        lda     LA908,y                         ; A860 B9 08 A9                 ...
        sta     $0408,x                         ; A863 9D 08 04                 ...
LA866:  lda     $0498,x                         ; A866 BD 98 04                 ...
        beq     LA870                           ; A869 F0 05                    ..
        dec     $0498,x                         ; A86B DE 98 04                 ...
        bne     LA82D                           ; A86E D0 BD                    ..
LA870:  ldy     #$0D                            ; A870 A0 0D                    ..
        jsr     entity_gravity_collide                           ; A872 20 B7 E7                  ..
        bcc     LA88E                           ; A875 90 17                    ..
        ldy     #$10                            ; A877 A0 10                    ..
        jsr     entity_horiz_dispatch                           ; A879 20 3F EA                  ?.
        bcc     LA88E                           ; A87C 90 10                    ..
        lda     $0558,x                         ; A87E BD 58 05                 .X.
        sta     $0468,x                         ; A881 9D 68 04                 .h.
        lda     #$91                            ; A884 A9 91                    ..
        sta     $0408,x                         ; A886 9D 08 04                 ...
        lda     #$36                            ; A889 A9 36                    .6
        jmp     entity_set_subtype                           ; A88B 4C 98 EA                 L..

; ----------------------------------------------------------------------------
LA88E:  lda     $0558,x                         ; A88E BD 58 05                 .X.
        cmp     #$26                            ; A891 C9 26                    .&
        bne     LA907                           ; A893 D0 72                    .r
        jsr     entity_x_dist_px                           ; A895 20 94 EC                  ..
        cmp     #$50                            ; A898 C9 50                    .P
        bcs     LA907                           ; A89A B0 6B                    .k
        jsr     entity_y_dist_abs                           ; A89C 20 76 EC                  v.
        cmp     #$28                            ; A89F C9 28                    .(
        bcs     LA907                           ; A8A1 B0 64                    .d
        dec     $0558,x                         ; A8A3 DE 58 05                 .X.
        lda     #$C9                            ; A8A6 A9 C9                    ..
        sta     $0408,x                         ; A8A8 9D 08 04                 ...
        lda     #$F0                            ; A8AB A9 F0                    ..
        sta     $0480,x                         ; A8AD 9D 80 04                 ...
        lda     #$00                            ; A8B0 A9 00                    ..
        sta     $03A8,x                         ; A8B2 9D A8 03                 ...
        lda     #$02                            ; A8B5 A9 02                    ..
        sta     $03C0,x                         ; A8B7 9D C0 03                 ...
        lda     #$3D                            ; A8BA A9 3D                    .=
        jsr     queue_sound                           ; A8BC 20 5D EC                  ].
        stx     $0F                             ; A8BF 86 0F                    ..
        lda     #$02                            ; A8C1 A9 02                    ..
        sta     $0E                             ; A8C3 85 0E                    ..
LA8C5:  jsr     find_free_slot_y                           ; A8C5 20 6F F1                  o.
        bcs     LA907                           ; A8C8 B0 3D                    .=
        lda     #$87                            ; A8CA A9 87                    ..
        sta     $0408,y                         ; A8CC 99 08 04                 ...
        lda     #$55                            ; A8CF A9 55                    .U
        sta     $0300,y                         ; A8D1 99 00 03                 ...
        lda     #$9D                            ; A8D4 A9 9D                    ..
        jsr     entity_init_pos                           ; A8D6 20 A4 EA                  ..
        lda     $0378,y                         ; A8D9 B9 78 03                 .x.
        sec                                     ; A8DC 38                       8
        sbc     #$04                            ; A8DD E9 04                    ..
        sta     $0378,y                         ; A8DF 99 78 03                 .x.
        sty     $0D                             ; A8E2 84 0D                    ..
        lda     $0420,x                         ; A8E4 BD 20 04                 . .
        and     #$02                            ; A8E7 29 02                    ).
        asl     a                               ; A8E9 0A                       .
        asl     a                               ; A8EA 0A                       .
        clc                                     ; A8EB 18                       .
        adc     $0E                             ; A8EC 65 0E                    e.
        tay                                     ; A8EE A8                       .
        ldx     $0D                             ; A8EF A6 0D                    ..
        lda     #$40                            ; A8F1 A9 40                    .@
        jsr     entity_set_dir_velocity                           ; A8F3 20 70 F4                  p.
        ldx     $0F                             ; A8F6 A6 0F                    ..
        inc     $0E                             ; A8F8 E6 0E                    ..
        inc     $0E                             ; A8FA E6 0E                    ..
        lda     $0E                             ; A8FC A5 0E                    ..
        cmp     #$08                            ; A8FE C9 08                    ..
        bne     LA8C5                           ; A900 D0 C3                    ..
        lda     #$3C                            ; A902 A9 3C                    .<
        sta     $0498,x                         ; A904 9D 98 04                 ...
LA907:  rts                                     ; A907 60                       `

; ----------------------------------------------------------------------------
LA908:  .byte   $80,$C0                         ; A908
; =============================================================================
; BEHAVIOR type $63 — ceiling dropper: hangs frozen until the player is
; within $30 px horizontally, then falls (sound $3B); on landing it
; faces the player (sub_type $1F) and charges under gravity (speed idx
; $1C) until it slams a wall, where it converts into stage-bank type
; $8C sub_type $42 (impact burst)
; =============================================================================
        lda     $0558,x                         ; A90A BD 58 05
        cmp     #$1E                            ; A90D C9 1E
        beq     LA920                           ; A90F F0 0F
        jsr     entity_x_dist_px                           ; A911 20 94 EC                  ..
        cmp     #$30                            ; A914 C9 30                    .0
        bcs     LA964                           ; A916 B0 4C                    .L
        inc     $0558,x                         ; A918 FE 58 05                 .X.
        lda     #$3B                            ; A91B A9 3B                    .;
        jsr     queue_sound                           ; A91D 20 5D EC                  ].
LA920:  ldy     #$17                            ; A920 A0 17                    ..
        jsr     entity_gravity_collide                           ; A922 20 B7 E7                  ..
        bcc     LA964                           ; A925 90 3D                    .=
        lda     #$1F                            ; A927 A9 1F                    ..
        jsr     entity_set_subtype                           ; A929 20 98 EA                  ..
        lda     $0528,x                         ; A92C BD 28 05                 .(.
        and     #$BF                            ; A92F 29 BF                    ).
        sta     $0528,x                         ; A931 9D 28 05                 .(.
        jsr     entity_set_facing                           ; A934 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A937 20 30 EC                  0.
        lda     #$44                            ; A93A A9 44                    .D
        sta     $0588,x                         ; A93C 9D 88 05                 ...
        lda     #$A9                            ; A93F A9 A9                    ..
        sta     $05A0,x                         ; A941 9D A0 05                 ...
        ldy     #$17                            ; A944 A0 17                    ..
        jsr     entity_gravity_collide                           ; A946 20 B7 E7                  ..
        bcc     LA964                           ; A949 90 19                    ..
        ldy     #$1C                            ; A94B A0 1C                    ..
        jsr     entity_horiz_dispatch                           ; A94D 20 3F EA                  ?.
        bcc     LA964                           ; A950 90 12                    ..
        jsr     entity_wipe_x                           ; A952 20 C4 F2                  ..
        lda     #$42                            ; A955 A9 42                    .B
        jsr     entity_set_subtype                           ; A957 20 98 EA                  ..
        lda     #$8C                            ; A95A A9 8C                    ..
        sta     $0300,x                         ; A95C 9D 00 03                 ...
        lda     #$8B                            ; A95F A9 8B                    ..
        sta     $0408,x                         ; A961 9D 08 04                 ...
LA964:  rts                                     ; A964 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $66 — bobbing lunger: hovers in place, drifting 0.5
; px/frame vertically and flipping direction every 8 frames (8
; half-cycles, shape $D1); then locks onto the player and dashes at
; speed idx $18 for $20 frames (shape $C0, anim phase 1) before
; resetting to the bob
; =============================================================================
LA965:  lda     #$80                            ; A965 A9 80                    ..
        sta     $03D8,x                         ; A967 9D D8 03                 ...
        lda     #$00                            ; A96A A9 00                    ..
        sta     $03F0,x                         ; A96C 9D F0 03                 ...
        lda     #$08                            ; A96F A9 08                    ..
        sta     $0420,x                         ; A971 9D 20 04                 . .
        lda     #$08                            ; A974 A9 08                    ..
        sta     $0468,x                         ; A976 9D 68 04                 .h.
        sta     $0480,x                         ; A979 9D 80 04                 ...
        lda     #$D1                            ; A97C A9 D1                    ..
        sta     $0408,x                         ; A97E 9D 08 04                 ...
        lda     #$00                            ; A981 A9 00                    ..
        sta     $0540,x                         ; A983 9D 40 05                 .@.
        sta     $0570,x                         ; A986 9D 70 05                 .p.
        lda     #$93                            ; A989 A9 93                    ..
        sta     $0588,x                         ; A98B 9D 88 05                 ...
        lda     #$A9                            ; A98E A9 A9                    ..
        sta     $05A0,x                         ; A990 9D A0 05                 ...
        lda     #$00                            ; A993 A9 00                    ..
        sta     $0570,x                         ; A995 9D 70 05                 .p.
        jsr     entity_vert_dispatch_raw                           ; A998 20 86 EA                  ..
        dec     $0468,x                         ; A99B DE 68 04                 .h.
        bne     LA9DF                           ; A99E D0 3F                    .?
        lda     #$08                            ; A9A0 A9 08                    ..
        sta     $0468,x                         ; A9A2 9D 68 04                 .h.
        jsr     L8538                           ; A9A5 20 38 85                  8.
        dec     $0480,x                         ; A9A8 DE 80 04                 ...
        bne     LA9DF                           ; A9AB D0 32                    .2
        jsr     entity_distance_calc                           ; A9AD 20 C2 EC                  ..
        tay                                     ; A9B0 A8                       .
        lda     #$18                            ; A9B1 A9 18                    ..
        jsr     entity_set_dir_velocity                           ; A9B3 20 70 F4                  p.
        lda     #$20                            ; A9B6 A9 20                    . 
        sta     $0498,x                         ; A9B8 9D 98 04                 ...
        lda     #$CF                            ; A9BB A9 CF                    ..
        sta     $0588,x                         ; A9BD 9D 88 05                 ...
        lda     #$A9                            ; A9C0 A9 A9                    ..
        sta     $05A0,x                         ; A9C2 9D A0 05                 ...
        lda     #$01                            ; A9C5 A9 01                    ..
        sta     $0540,x                         ; A9C7 9D 40 05                 .@.
        lda     #$C0                            ; A9CA A9 C0                    ..
        sta     $0408,x                         ; A9CC 9D 08 04                 ...
        lda     #$00                            ; A9CF A9 00                    ..
        sta     $0570,x                         ; A9D1 9D 70 05                 .p.
        jsr     entity_facing_dispatch                           ; A9D4 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A9D7 20 86 EA                  ..
        dec     $0498,x                         ; A9DA DE 98 04                 ...
        beq     LA965                           ; A9DD F0 86                    ..
LA9DF:  rts                                     ; A9DF 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $59 — flyer nest: stationary, always facing the player;
; shot-deflect comes from LAAB0[cur_weapon] (only Gravity Hold is
; repelled); its hurtbox is probed $18 px above the origin (shape $C1,
; manual damage_engine); keeps up to 2 type $62 homing flyers alive —
; when fewer exist it plays spawn anim $62 and births one (1 HP, 1
; px/frame, parent slot + screen recorded for the tether)
; =============================================================================
        ldy     $32                             ; A9E0 A4 32                    .2
        lda     $0408,x                         ; A9E2 BD 08 04                 ...
        and     #$BF                            ; A9E5 29 BF                    ).
        ora     LAAB0,y                         ; A9E7 19 B0 AA                 ...
        sta     $0408,x                         ; A9EA 9D 08 04                 ...
        lda     $0378,x                         ; A9ED BD 78 03                 .x.
        pha                                     ; A9F0 48                       H
        sec                                     ; A9F1 38                       8
        sbc     #$18                            ; A9F2 E9 18                    ..
        sta     $0378,x                         ; A9F4 9D 78 03                 .x.
        lda     $0408,x                         ; A9F7 BD 08 04                 ...
        pha                                     ; A9FA 48                       H
        lda     #$C1                            ; A9FB A9 C1                    ..
        sta     $0408,x                         ; A9FD 9D 08 04                 ...
        jsr     entity_hitbox_check                           ; AA00 20 F8 EF                  ..
        pla                                     ; AA03 68                       h
        sta     $0408,x                         ; AA04 9D 08 04                 ...
        pla                                     ; AA07 68                       h
        sta     $0378,x                         ; AA08 9D 78 03                 .x.
        bcs     LAA14                           ; AA0B B0 07                    ..
        lda     #$40                            ; AA0D A9 40                    .@
        sta     L0000                           ; AA0F 85 00                    ..
        jmp     L809D                           ; AA11 4C 9D 80                 L..

; ----------------------------------------------------------------------------
LAA14:  jsr     entity_set_facing                           ; AA14 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; AA17 20 30 EC                  0.
        lda     $0558,x                         ; AA1A BD 58 05                 .X.
        cmp     #$62                            ; AA1D C9 62                    .b
        bne     LAA3C                           ; AA1F D0 1B                    ..
        lda     $0570,x                         ; AA21 BD 70 05                 .p.
        cmp     #$03                            ; AA24 C9 03                    ..
        bne     LA9DF                           ; AA26 D0 B7                    ..
        lda     $0540,x                         ; AA28 BD 40 05                 .@.
        cmp     #$03                            ; AA2B C9 03                    ..
        beq     LAA65                           ; AA2D F0 36                    .6
        cmp     #$0F                            ; AA2F C9 0F                    ..
        beq     LAA70                           ; AA31 F0 3D                    .=
        cmp     #$13                            ; AA33 C9 13                    ..
        bne     LAAAF                           ; AA35 D0 78                    .x
        lda     #$61                            ; AA37 A9 61                    .a
        jsr     entity_set_subtype                           ; AA39 20 98 EA                  ..
LAA3C:  lda     #$00                            ; AA3C A9 00                    ..
        sta     L0000                           ; AA3E 85 00                    ..
        ldy     #$17                            ; AA40 A0 17                    ..
LAA42:  lda     $0300,y                         ; AA42 B9 00 03                 ...
        cmp     #$62                            ; AA45 C9 62                    .b
        bne     LAA4B                           ; AA47 D0 02                    ..
        inc     L0000                           ; AA49 E6 00                    ..
LAA4B:  dey                                     ; AA4B 88                       .
        cpy     #$07                            ; AA4C C0 07                    ..
        bcs     LAA42                           ; AA4E B0 F2                    ..
        lda     L0000                           ; AA50 A5 00                    ..
        cmp     #$02                            ; AA52 C9 02                    ..
        bcs     LAAAF                           ; AA54 B0 59                    .Y
        lda     $0408,x                         ; AA56 BD 08 04                 ...
        and     #$C0                            ; AA59 29 C0                    ).
        ora     #$25                            ; AA5B 09 25                    .%
        sta     $0408,x                         ; AA5D 9D 08 04                 ...
        lda     #$62                            ; AA60 A9 62                    .b
        jmp     entity_set_subtype                           ; AA62 4C 98 EA                 L..

; ----------------------------------------------------------------------------
LAA65:  lda     $0408,x                         ; AA65 BD 08 04                 ...
        and     #$C0                            ; AA68 29 C0                    ).
        ora     #$24                            ; AA6A 09 24                    .$
        sta     $0408,x                         ; AA6C 9D 08 04                 ...
        rts                                     ; AA6F 60                       `

; ----------------------------------------------------------------------------
LAA70:  jsr     find_free_slot_y                           ; AA70 20 6F F1                  o.
        bcs     LAAAF                           ; AA73 B0 3A                    .:
        lda     #$C5                            ; AA75 A9 C5                    ..
        sta     $0408,y                         ; AA77 99 08 04                 ...
        lda     #$01                            ; AA7A A9 01                    ..
        sta     $0450,y                         ; AA7C 99 50 04                 .P.
        lda     #$62                            ; AA7F A9 62                    .b
        sta     $0300,y                         ; AA81 99 00 03                 ...
        lda     $0420,x                         ; AA84 BD 20 04                 . .
        sta     $0420,y                         ; AA87 99 20 04                 . .
        and     #$01                            ; AA8A 29 01                    ).
        clc                                     ; AA8C 18                       .
        adc     #$1E                            ; AA8D 69 1E                    i.
        sta     L0010                           ; AA8F 85 10                    ..
        lda     #$00                            ; AA91 A9 00                    ..
        sta     $03A8,y                         ; AA93 99 A8 03                 ...
        lda     #$01                            ; AA96 A9 01                    ..
        sta     $03C0,y                         ; AA98 99 C0 03                 ...
        lda     #$87                            ; AA9B A9 87                    ..
        jsr     entity_speed_preset                           ; AA9D 20 F5 EA                  ..
        lda     #$0A                            ; AAA0 A9 0A                    ..
        sta     $0468,y                         ; AAA2 99 68 04                 .h.
        txa                                     ; AAA5 8A                       .
        sta     $0480,y                         ; AAA6 99 80 04                 ...
        lda     $0348,x                         ; AAA9 BD 48 03                 .H.
        sta     $0498,y                         ; AAAC 99 98 04                 ...
LAAAF:  rts                                     ; AAAF 60                       `

; ----------------------------------------------------------------------------
LAAB0:  .byte   $00,$00,$00,$00,$00,$00,$00,$40 ; AAB0

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00             ; AAB8
; =============================================================================
; BEHAVIOR type $62 — homing flyer (spawned by type $59 nest): every $0A
; frames re-aims at the player (LED5B 16-dir angle, speed idx $20),
; picking sprite flags/sub_type from LAAF3/LAB03 per angle; if its
; parent slot is no longer a type $59 on the recorded screen it
; self-destructs into a puff (LA54D)
; =============================================================================
        ldy     $0480,x                         ; AABD BC 80 04                 ...
        lda     $0300,y                         ; AAC0 B9 00 03                 ...
        cmp     #$59                            ; AAC3 C9 59                    .Y
        bne     LAACF                           ; AAC5 D0 08                    ..
        lda     $0498,x                         ; AAC7 BD 98 04                 ...
        cmp     $0348,y                         ; AACA D9 48 03                 .H.
        beq     LAAD2                           ; AACD F0 03                    ..
LAACF:  jmp     LA54D                           ; AACF 4C 4D A5                 LM.

; ----------------------------------------------------------------------------
LAAD2:  jsr     L84FC                           ; AAD2 20 FC 84                  ..
        dec     $0468,x                         ; AAD5 DE 68 04                 .h.
        bne     LAAAF                           ; AAD8 D0 D5                    ..
        lda     #$0A                            ; AADA A9 0A                    ..
        sta     $0468,x                         ; AADC 9D 68 04                 .h.
        jsr     LED5B                           ; AADF 20 5B ED                  [.
        lda     LAAF3,y                         ; AAE2 B9 F3 AA                 ...
        sta     $0528,x                         ; AAE5 9D 28 05                 .(.
        lda     LAB03,y                         ; AAE8 B9 03 AB                 ...
        sta     $0558,x                         ; AAEB 9D 58 05                 .X.
        lda     #$20                            ; AAEE A9 20                    . 
        jmp     entity_set_dir_velocity                           ; AAF0 4C 70 F4                 Lp.

; ----------------------------------------------------------------------------
LAAF3:  .byte   $80,$A0,$A0,$A0,$A0,$E0,$E0,$E0,$C0,$C0,$C0,$C0,$80,$80,$80,$80 ; AAF3
LAB03:  .byte   $88,$64,$64,$64,$87,$64,$64,$64,$88,$64,$64,$64,$87,$64,$64,$64 ; AB03
; =============================================================================
; BEHAVIOR type $67 — plain walker: gravity (idx $15) + walk (idx $16),
; reversing at walls
; =============================================================================
        ldy     #$15                            ; AB13 A0 15                    ..
        jsr     entity_gravity_collide                           ; AB15 20 B7 E7                  ..
        bcc     LAB24                           ; AB18 90 0A                    ..
        ldy     #$16                            ; AB1A A0 16                    ..
        jsr     entity_horiz_dispatch                           ; AB1C 20 3F EA                  ?.
        bcc     LAB24                           ; AB1F 90 03                    ..
        jsr     entity_flip_direction                           ; AB21 20 4A EC                  J.
LAB24:  rts                                     ; AB24 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $68 — homing flyer: re-aims at the player every 16
; frames (speed idx $38) and drifts on both axes between corrections
; =============================================================================
        lda     $0468,x                         ; AB25 BD 68 04                 .h.
        inc     $0468,x                         ; AB28 FE 68 04                 .h.
        and     #$0F                            ; AB2B 29 0F                    ).
        bne     LAB38                           ; AB2D D0 09                    ..
        jsr     entity_distance_calc                           ; AB2F 20 C2 EC                  ..
        tay                                     ; AB32 A8                       .
        lda     #$38                            ; AB33 A9 38                    .8
        jsr     entity_set_dir_velocity                           ; AB35 20 70 F4                  p.
LAB38:  jsr     entity_facing_dispatch                           ; AB38 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; AB3B 20 86 EA                  ..
LAB3E:  rts                                     ; AB3E 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $27 — lurker trap: harmless and hidden until the player
; stands within $20/$18 px; then rises out of the floor in shape-table
; steps (LABFB/LABFF, then 4 px more at anim $91), holds a damaging
; pose for 7 anim loops (sub_type $95), and sinks back (LAC03/LAC09,
; final shape 0 = no hitbox), re-arming after $3C frames
; =============================================================================
        lda     #$00                            ; AB3F A9 00                    ..
        sta     $0570,x                         ; AB41 9D 70 05                 .p.
        lda     $0498,x                         ; AB44 BD 98 04                 ...
        beq     LAB4E                           ; AB47 F0 05                    ..
        dec     $0498,x                         ; AB49 DE 98 04                 ...
        bne     LAB3E                           ; AB4C D0 F0                    ..
LAB4E:  jsr     entity_x_dist_px                           ; AB4E 20 94 EC                  ..
        cmp     #$20                            ; AB51 C9 20                    . 
        bcs     LAB3E                           ; AB53 B0 E9                    ..
        jsr     entity_y_dist_abs                           ; AB55 20 76 EC                  v.
        cmp     #$18                            ; AB58 C9 18                    ..
        bcs     LAB3E                           ; AB5A B0 E2                    ..
        lda     #$66                            ; AB5C A9 66                    .f
        sta     $0588,x                         ; AB5E 9D 88 05                 ...
        lda     #$AB                            ; AB61 A9 AB                    ..
        sta     $05A0,x                         ; AB63 9D A0 05                 ...
        lda     $0570,x                         ; AB66 BD 70 05                 .p.
        cmp     #$02                            ; AB69 C9 02                    ..
        bne     LAB3E                           ; AB6B D0 D1                    ..
        ldy     $0540,x                         ; AB6D BC 40 05                 .@.
        lda     $0378,x                         ; AB70 BD 78 03                 .x.
        sec                                     ; AB73 38                       8
        sbc     LABFB,y                         ; AB74 F9 FB AB                 ...
        sta     $0378,x                         ; AB77 9D 78 03                 .x.
        lda     LABFF,y                         ; AB7A B9 FF AB                 ...
        sta     $0408,x                         ; AB7D 9D 08 04                 ...
        cpy     #$03                            ; AB80 C0 03                    ..
        bne     LABFA                           ; AB82 D0 76                    .v
        lda     #$98                            ; AB84 A9 98                    ..
        sta     $0588,x                         ; AB86 9D 88 05                 ...
        lda     #$AB                            ; AB89 A9 AB                    ..
        sta     $05A0,x                         ; AB8B 9D A0 05                 ...
        lda     #$95                            ; AB8E A9 95                    ..
        jsr     entity_set_subtype                           ; AB90 20 98 EA                  ..
        lda     #$07                            ; AB93 A9 07                    ..
        sta     $0468,x                         ; AB95 9D 68 04                 .h.
        lda     $0570,x                         ; AB98 BD 70 05                 .p.
        cmp     #$02                            ; AB9B C9 02                    ..
        bne     LABFA                           ; AB9D D0 5B                    .[
        lda     $0540,x                         ; AB9F BD 40 05                 .@.
        cmp     #$03                            ; ABA2 C9 03                    ..
        bne     LABFA                           ; ABA4 D0 54                    .T
        dec     $0468,x                         ; ABA6 DE 68 04                 .h.
        bne     LABFA                           ; ABA9 D0 4F                    .O
        lda     #$C8                            ; ABAB A9 C8                    ..
        sta     $0588,x                         ; ABAD 9D 88 05                 ...
        lda     #$AB                            ; ABB0 A9 AB                    ..
        sta     $05A0,x                         ; ABB2 9D A0 05                 ...
        lda     #$91                            ; ABB5 A9 91                    ..
        jsr     entity_set_subtype                           ; ABB7 20 98 EA                  ..
        lda     #$A0                            ; ABBA A9 A0                    ..
        sta     $0408,x                         ; ABBC 9D 08 04                 ...
        lda     $0378,x                         ; ABBF BD 78 03                 .x.
        sec                                     ; ABC2 38                       8
        sbc     #$04                            ; ABC3 E9 04                    ..
        sta     $0378,x                         ; ABC5 9D 78 03                 .x.
        lda     $0570,x                         ; ABC8 BD 70 05                 .p.
        cmp     #$04                            ; ABCB C9 04                    ..
        bne     LABFA                           ; ABCD D0 2B                    .+
        ldy     $0540,x                         ; ABCF BC 40 05                 .@.
        lda     $0378,x                         ; ABD2 BD 78 03                 .x.
        sec                                     ; ABD5 38                       8
        sbc     LAC03,y                         ; ABD6 F9 03 AC                 ...
        sta     $0378,x                         ; ABD9 9D 78 03                 .x.
        lda     LAC09,y                         ; ABDC B9 09 AC                 ...
        sta     $0408,x                         ; ABDF 9D 08 04                 ...
        cpy     #$05                            ; ABE2 C0 05                    ..
        bne     LABFA                           ; ABE4 D0 14                    ..
        lda     #$3F                            ; ABE6 A9 3F                    .?
        sta     $0588,x                         ; ABE8 9D 88 05                 ...
        lda     #$AB                            ; ABEB A9 AB                    ..
        sta     $05A0,x                         ; ABED 9D A0 05                 ...
        lda     #$59                            ; ABF0 A9 59                    .Y
        jsr     entity_set_subtype                           ; ABF2 20 98 EA                  ..
        lda     #$3C                            ; ABF5 A9 3C                    .<
        sta     $0498,x                         ; ABF7 9D 98 04                 ...
LABFA:  rts                                     ; ABFA 60                       `

; ----------------------------------------------------------------------------
LABFB:  .byte   $08,$08,$00,$00                 ; ABFB
LABFF:  .byte   $9B,$9C,$9C,$9C                 ; ABFF
LAC03:  .byte   $07,$01,$00,$00,$00,$E4         ; AC03
LAC09:  .byte   $A3,$A3,$A3,$00,$00,$00         ; AC09
; =============================================================================
; BEHAVIOR type $64 — retaliating turret: stationary, faces the player;
; fires a 2 px/frame stage-bank type $9B shot every $78 frames, but
; holds fire while its type $65 child lives; probes hits with an
; enlarged shape $E6 — being struck triggers reaction anim $97, which
; launches a type $65 at 4 px/frame (1 HP, slot remembered) before
; settling back to sub_type $96
; =============================================================================
        jsr     entity_set_facing                           ; AC0F 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; AC12 20 30 EC                  0.
        lda     $0558,x                         ; AC15 BD 58 05                 .X.
        cmp     #$97                            ; AC18 C9 97                    ..
        beq     LAC33                           ; AC1A F0 17                    ..
        lda     $0408,x                         ; AC1C BD 08 04                 ...
        pha                                     ; AC1F 48                       H
        lda     #$E6                            ; AC20 A9 E6                    ..
        sta     $0408,x                         ; AC22 9D 08 04                 ...
        jsr     entity_hitbox_check                           ; AC25 20 F8 EF                  ..
        pla                                     ; AC28 68                       h
        sta     $0408,x                         ; AC29 9D 08 04                 ...
        bcs     LAC7D                           ; AC2C B0 4F                    .O
        lda     #$97                            ; AC2E A9 97                    ..
        jsr     entity_set_subtype                           ; AC30 20 98 EA                  ..
LAC33:  lda     $0570,x                         ; AC33 BD 70 05                 .p.
        cmp     #$05                            ; AC36 C9 05                    ..
        bne     LAC7D                           ; AC38 D0 43                    .C
        lda     $0540,x                         ; AC3A BD 40 05                 .@.
        beq     LAC48                           ; AC3D F0 09                    ..
        cmp     #$05                            ; AC3F C9 05                    ..
        bne     LAC7D                           ; AC41 D0 3A                    .:
        lda     #$96                            ; AC43 A9 96                    ..
        jmp     entity_set_subtype                           ; AC45 4C 98 EA                 L..

; ----------------------------------------------------------------------------
LAC48:  jsr     find_free_slot_y                           ; AC48 20 6F F1                  o.
        bcs     LAC7D                           ; AC4B B0 30                    .0
        lda     #$C7                            ; AC4D A9 C7                    ..
        sta     $0408,y                         ; AC4F 99 08 04                 ...
        lda     #$01                            ; AC52 A9 01                    ..
        sta     $0450,y                         ; AC54 99 50 04                 .P.
        lda     #$65                            ; AC57 A9 65                    .e
        sta     $0300,y                         ; AC59 99 00 03                 ...
        lda     $0420,x                         ; AC5C BD 20 04                 . .
        sta     $0420,y                         ; AC5F 99 20 04                 . .
        and     #$01                            ; AC62 29 01                    ).
        clc                                     ; AC64 18                       .
        adc     #$53                            ; AC65 69 53                    iS
        sta     L0010                           ; AC67 85 10                    ..
        lda     #$9E                            ; AC69 A9 9E                    ..
        jsr     entity_speed_preset                           ; AC6B 20 F5 EA                  ..
        lda     #$00                            ; AC6E A9 00                    ..
        sta     $03A8,y                         ; AC70 99 A8 03                 ...
        lda     #$04                            ; AC73 A9 04                    ..
        sta     $03C0,y                         ; AC75 99 C0 03                 ...
        tya                                     ; AC78 98                       .
        sta     $0480,x                         ; AC79 9D 80 04                 ...
        rts                                     ; AC7C 60                       `

; ----------------------------------------------------------------------------
LAC7D:  inc     $0468,x                         ; AC7D FE 68 04                 .h.
        lda     $0468,x                         ; AC80 BD 68 04                 .h.
        cmp     #$78                            ; AC83 C9 78                    .x
        bcc     LACC1                           ; AC85 90 3A                    .:
        lda     #$00                            ; AC87 A9 00                    ..
        sta     $0468,x                         ; AC89 9D 68 04                 .h.
        ldy     $0480,x                         ; AC8C BC 80 04                 ...
        lda     $0300,y                         ; AC8F B9 00 03                 ...
        cmp     #$65                            ; AC92 C9 65                    .e
        beq     LACC1                           ; AC94 F0 2B                    .+
        jsr     find_free_slot_y                           ; AC96 20 6F F1                  o.
        bcs     LACC1                           ; AC99 B0 26                    .&
        lda     #$87                            ; AC9B A9 87                    ..
        sta     $0408,y                         ; AC9D 99 08 04                 ...
        lda     #$9B                            ; ACA0 A9 9B                    ..
        sta     $0300,y                         ; ACA2 99 00 03                 ...
        lda     $0420,x                         ; ACA5 BD 20 04                 . .
        sta     $0420,y                         ; ACA8 99 20 04                 . .
        and     #$01                            ; ACAB 29 01                    ).
        clc                                     ; ACAD 18                       .
        adc     #$02                            ; ACAE 69 02                    i.
        sta     L0010                           ; ACB0 85 10                    ..
        lda     #$9F                            ; ACB2 A9 9F                    ..
        jsr     entity_speed_preset                           ; ACB4 20 F5 EA                  ..
        lda     #$00                            ; ACB7 A9 00                    ..
        sta     $03A8,y                         ; ACB9 99 A8 03                 ...
        lda     #$02                            ; ACBC A9 02                    ..
        sta     $03C0,y                         ; ACBE 99 C0 03                 ...
LACC1:  rts                                     ; ACC1 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $22 — item carrier: despawns on arrival if flag $5D is
; already set (its gift was taken); otherwise patrols under gravity,
; and when the player comes within $20 px it tosses a type $57 pickup
; (1 px/f forward, 4 px/f up, random sub_type from LADC4 via frame-rng
; $E7, spawn index inherited) then flees: after a $50-frame hold it
; rises off the top of the screen and wipes itself
; =============================================================================
        lda     $0528,x                         ; ACC2 BD 28 05                 .(.
        and     #$FB                            ; ACC5 29 FB                    ).
        sta     $0528,x                         ; ACC7 9D 28 05                 .(.
        lda     #$DB                            ; ACCA A9 DB                    ..
        sta     $0588,x                         ; ACCC 9D 88 05                 ...
        lda     #$AC                            ; ACCF A9 AC                    ..
        sta     $05A0,x                         ; ACD1 9D A0 05                 ...
        lda     $5D                             ; ACD4 A5 5D                    .]
        beq     LACDB                           ; ACD6 F0 03                    ..
        jmp     entity_wipe_x                           ; ACD8 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LACDB:  ldy     #$21                            ; ACDB A0 21                    .!
        jsr     entity_gravity_collide                           ; ACDD 20 B7 E7                  ..
        bcc     LAD2B                           ; ACE0 90 49                    .I
        ldy     #$28                            ; ACE2 A0 28                    .(
        jsr     entity_horiz_dispatch                           ; ACE4 20 3F EA                  ?.
        bcc     LACEC                           ; ACE7 90 03                    ..
        jsr     entity_flip_direction                           ; ACE9 20 4A EC                  J.
LACEC:  jsr     entity_x_dist_px                           ; ACEC 20 94 EC                  ..
        cmp     #$20                            ; ACEF C9 20                    . 
        bcs     LAD2B                           ; ACF1 B0 38                    .8
        lda     #$02                            ; ACF3 A9 02                    ..
        sta     $0588,x                         ; ACF5 9D 88 05                 ...
        lda     #$AD                            ; ACF8 A9 AD                    ..
        sta     $05A0,x                         ; ACFA 9D A0 05                 ...
        lda     #$08                            ; ACFD A9 08                    ..
        jsr     entity_set_subtype                           ; ACFF 20 98 EA                  ..
        lda     $0570,x                         ; AD02 BD 70 05                 .p.
        cmp     #$08                            ; AD05 C9 08                    ..
        bne     LAD7B                           ; AD07 D0 72                    .r
        lda     $0540,x                         ; AD09 BD 40 05                 .@.
        cmp     #$03                            ; AD0C C9 03                    ..
        beq     LAD2C                           ; AD0E F0 1C                    ..
        cmp     #$05                            ; AD10 C9 05                    ..
        bne     LAD7B                           ; AD12 D0 67                    .g
        lda     #$50                            ; AD14 A9 50                    .P
        sta     $0468,x                         ; AD16 9D 68 04                 .h.
        lda     #$7C                            ; AD19 A9 7C                    .|
        sta     $0588,x                         ; AD1B 9D 88 05                 ...
        lda     #$AD                            ; AD1E A9 AD                    ..
        sta     $05A0,x                         ; AD20 9D A0 05                 ...
        lda     #$07                            ; AD23 A9 07                    ..
        jsr     entity_set_subtype                           ; AD25 20 98 EA                  ..
        inc     $0540,x                         ; AD28 FE 40 05                 .@.
LAD2B:  rts                                     ; AD2B 60                       `

; ----------------------------------------------------------------------------
LAD2C:  stx     $0F                             ; AD2C 86 0F                    ..
        jsr     find_free_slot_y                           ; AD2E 20 6F F1                  o.
        bcs     LAD7B                           ; AD31 B0 48                    .H
        lda     #$57                            ; AD33 A9 57                    .W
        sta     $0300,y                         ; AD35 99 00 03                 ...
        lda     #$00                            ; AD38 A9 00                    ..
        sta     $0408,y                         ; AD3A 99 08 04                 ...
        sta     $0450,y                         ; AD3D 99 50 04                 .P.
        sta     $03A8,y                         ; AD40 99 A8 03                 ...
        sta     $03D8,y                         ; AD43 99 D8 03                 ...
        lda     #$01                            ; AD46 A9 01                    ..
        sta     $03C0,y                         ; AD48 99 C0 03                 ...
        lda     #$04                            ; AD4B A9 04                    ..
        sta     $03F0,y                         ; AD4D 99 F0 03                 ...
        lda     $0420,x                         ; AD50 BD 20 04                 . .
        sta     $0420,y                         ; AD53 99 20 04                 . .
        lda     $0438,x                         ; AD56 BD 38 04                 .8.
        sta     $0438,y                         ; AD59 99 38 04                 .8.
        lda     $E5                             ; AD5C A5 E5                    ..
        adc     $E7                             ; AD5E 65 E7                    e.
        sta     $E7                             ; AD60 85 E7                    ..
        and     #$07                            ; AD62 29 07                    ).
        tax                                     ; AD64 AA                       .
        lda     LADC4,x                         ; AD65 BD C4 AD                 ...
        ldx     $0F                             ; AD68 A6 0F                    ..
        jsr     entity_init_pos                           ; AD6A 20 A4 EA                  ..
        lda     #$23                            ; AD6D A9 23                    .#
        sta     $0468,y                         ; AD6F 99 68 04                 .h.
        lda     $0378,y                         ; AD72 B9 78 03                 .x.
        sec                                     ; AD75 38                       8
        sbc     #$0C                            ; AD76 E9 0C                    ..
        sta     $0378,y                         ; AD78 99 78 03                 .x.
LAD7B:  rts                                     ; AD7B 60                       `

; ----------------------------------------------------------------------------
        lda     $0468,x                         ; AD7C BD 68 04                 .h.
        beq     LAD90                           ; AD7F F0 0F                    ..
        lda     #$00                            ; AD81 A9 00                    ..
        sta     $0570,x                         ; AD83 9D 70 05                 .p.
        dec     $0468,x                         ; AD86 DE 68 04                 .h.
        bne     LAD7B                           ; AD89 D0 F0                    ..
        lda     #$09                            ; AD8B A9 09                    ..
        jsr     entity_set_subtype                           ; AD8D 20 98 EA                  ..
LAD90:  lda     $0570,x                         ; AD90 BD 70 05                 .p.
        cmp     #$02                            ; AD93 C9 02                    ..
        bne     LAD7B                           ; AD95 D0 E4                    ..
        cmp     $0540,x                         ; AD97 DD 40 05                 .@.
        bne     LAD7B                           ; AD9A D0 DF                    ..
        lda     #$B1                            ; AD9C A9 B1                    ..
        sta     $0588,x                         ; AD9E 9D 88 05                 ...
        lda     #$AD                            ; ADA1 A9 AD                    ..
        sta     $05A0,x                         ; ADA3 9D A0 05                 ...
        lda     #$00                            ; ADA6 A9 00                    ..
        sta     $03D8,x                         ; ADA8 9D D8 03                 ...
        sta     $03F0,x                         ; ADAB 9D F0 03                 ...
        inc     $0540,x                         ; ADAE FE 40 05                 .@.
        lda     #$00                            ; ADB1 A9 00                    ..
        sta     $0570,x                         ; ADB3 9D 70 05                 .p.
        jsr     entity_apply_gravity                           ; ADB6 20 E1 E9                  ..
        jsr     entity_move_up_nofacing                           ; ADB9 20 4A E9                  J.
        lda     $0390,x                         ; ADBC BD 90 03                 ...
        beq     LAD7B                           ; ADBF F0 BA                    ..
        jmp     entity_wipe_x                           ; ADC1 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LADC4:  sei                                     ; ADC4 78                       x
        .byte   $74                             ; ADC5 74                       t
        ror     $72,x                           ; ADC6 76 72                    vr
        sei                                     ; ADC8 78                       x
        .byte   $74                             ; ADC9 74                       t
        ror     $78,x                           ; ADCA 76 78                    vx
; =============================================================================
; BEHAVIOR type $57 — tossed pickup (thrown by type $22; converted
; type $B7 random drops enter here too): falls with
; gravity (speed idx from $0468), slides horizontally (idx $2A) until a
; wall stops it (dir cleared), then falls through into the shared
; pickup-grant code below — taking it latches flag $5D so the carrier
; never regifts
; =============================================================================
        ldy     $0468,x                         ; ADCC BC 68 04                 .h.
        jsr     entity_gravity_collide                           ; ADCF 20 B7 E7                  ..
        bcc     LADDE                           ; ADD2 90 0A                    ..
        lda     #$ED                            ; ADD4 A9 ED                    ..
        sta     $0588,x                         ; ADD6 9D 88 05                 ...
        lda     #$AD                            ; ADD9 A9 AD                    ..
        sta     $05A0,x                         ; ADDB 9D A0 05                 ...
LADDE:  ldy     #$2A                            ; ADDE A0 2A                    .*
        jsr     entity_horiz_dispatch                           ; ADE0 20 3F EA                  ?.
        jsr     L8526                           ; ADE3 20 26 85                  &.
        bcc     LADED                           ; ADE6 90 05                    ..
        lda     #$00                            ; ADE8 A9 00                    ..
        sta     $0420,x                         ; ADEA 9D 20 04                 . .
; =============================================================================
; BEHAVIOR types $B6/$C3 — pickup grant (shared tail; types $57 and $B7
; drops fall through here): sub_type $73 evaporates unless $BE == $80;
; on player contact (game modes 0-5) — type $B6 placed pickups first
; set their no-respawn bit (LF297), type $57 latches carrier flag $5D —
; then the per-sub_type tables at LAEB8/LAEC7/LAED6/LAEE5 (+sub_type)
; supply the effect id (-> $5A), pickup sound, and a handler pointer
; jumped to after the entity is wiped; an uncollected $B7 drop ticks
; $0480 down, self-stuns to flicker for its last $3C frames, and
; vanishes at zero
; =============================================================================
LADED:  lda     $0558,x                         ; ADED BD 58 05                 .X.
        cmp     #$73                            ; ADF0 C9 73                    .s
        bne     LADFD                           ; ADF2 D0 09                    ..
        lda     $BE                             ; ADF4 A5 BE                    ..
        cmp     #$80                            ; ADF6 C9 80                    ..
        beq     LADFD                           ; ADF8 F0 03                    ..
        jmp     entity_wipe_x                           ; ADFA 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LADFD:  lda     $0528,x                         ; ADFD BD 28 05                 .(.
        and     #$FB                            ; AE00 29 FB                    ).
        sta     $0528,x                         ; AE02 9D 28 05                 .(.
        lda     $30                             ; AE05 A5 30                    .0
        cmp     #$06                            ; AE07 C9 06                    ..
        bcs     LAE42                           ; AE09 B0 37                    .7
        jsr     entity_player_collide                           ; AE0B 20 87 EF                  ..
        bcs     LAE42                           ; AE0E B0 32                    .2
        lda     $0300,x                         ; AE10 BD 00 03                 ...
        cmp     #$B6                            ; AE13 C9 B6                    ..
        beq     LAE1F                           ; AE15 F0 08                    ..
        cmp     #$57                            ; AE17 C9 57                    .W
        bne     LAE22                           ; AE19 D0 07                    ..
        inc     $5D                             ; AE1B E6 5D                    .]
        bne     LAE22                           ; AE1D D0 03                    ..
LAE1F:  jsr     LF297                           ; AE1F 20 97 F2                  ..
LAE22:  ldy     $0558,x                         ; AE22 BC 58 05                 .X.
        lda     LAEC7,y                         ; AE25 B9 C7 AE                 ...
        beq     LAE2D                           ; AE28 F0 03                    ..
        jsr     queue_sound                           ; AE2A 20 5D EC                  ].
LAE2D:  lda     LAEB8,y                         ; AE2D B9 B8 AE                 ...
        sta     $5A                             ; AE30 85 5A                    .Z
        lda     LAED6,y                         ; AE32 B9 D6 AE                 ...
        sta     L0000                           ; AE35 85 00                    ..
        lda     LAEE5,y                         ; AE37 B9 E5 AE                 ...
        sta     L0001                           ; AE3A 85 01                    ..
        jsr     entity_wipe_x                           ; AE3C 20 C4 F2                  ..
        jmp     (L0000)                         ; AE3F 6C 00 00                 l..

; ----------------------------------------------------------------------------
LAE42:  lda     $0300,x                         ; AE42 BD 00 03                 ...
        cmp     #$B7                            ; AE45 C9 B7                    ..
        bne     LAE58                           ; AE47 D0 0F                    ..
        dec     $0480,x                         ; AE49 DE 80 04                 ...
        lda     $0480,x                         ; AE4C BD 80 04                 ...
        beq     LAE8B                           ; AE4F F0 3A                    .:
        cmp     #$3C                            ; AE51 C9 3C                    .<
        bcs     LAE58                           ; AE53 B0 03                    ..
        sta     $05B8,x                         ; AE55 9D B8 05                 ...
LAE58:  rts                                     ; AE58 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR types $B7/$B8 — enemy death explosion (damage engine
; spawns type $B8 on kill); at anim phase 4, unless drops are
; suppressed ($2F bit 7), it rolls the frame-rng ($E6/$E7 mash, div8)
; against the LAF1B thresholds: a miss wipes the entity, a hit turns
; it into a type $B7 falling drop — sub_type from LAF20, fall-speed
; idx LAF25 -> $0468, $FF-frame lifetime — entering at $ADCC to drop
; and slide like a type $57 pickup
; =============================================================================
        lda     $0540,x                         ; AE59 BD 40 05                 .@.
        cmp     #$04                            ; AE5C C9 04                    ..
        bne     LAE58                           ; AE5E D0 F8                    ..
        lda     $2F                             ; AE60 A5 2F                    ./
        bmi     LAE58                           ; AE62 30 F4                    0.
        lda     $E6                             ; AE64 A5 E6                    ..
        adc     $E7                             ; AE66 65 E7                    e.
        adc     L0000                           ; AE68 65 00                    e.
        sbc     $9D                             ; AE6A E5 9D                    ..
        sta     $E6                             ; AE6C 85 E6                    ..
        adc     L0001                           ; AE6E 65 01                    e.
        sbc     $E5                             ; AE70 E5 E5                    ..
        adc     $92                             ; AE72 65 92                    e.
        sta     $E7                             ; AE74 85 E7                    ..
        sta     L0000                           ; AE76 85 00                    ..
        lda     #$32                            ; AE78 A9 32                    .2
        sta     L0001                           ; AE7A 85 01                    ..
        jsr     div8                           ; AE7C 20 07 F2                  ..
        ldy     #$04                            ; AE7F A0 04                    ..
        lda     $03                             ; AE81 A5 03                    ..
LAE83:  cmp     LAF1B,y                         ; AE83 D9 1B AF                 ...
        bcc     LAE8E                           ; AE86 90 06                    ..
        dey                                     ; AE88 88                       .
        bpl     LAE83                           ; AE89 10 F8                    ..
LAE8B:  jmp     entity_wipe_x                           ; AE8B 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LAE8E:  lda     LAF20,y                         ; AE8E B9 20 AF                 . .
        jsr     entity_set_subtype                           ; AE91 20 98 EA                  ..
        lda     #$00                            ; AE94 A9 00                    ..
        sta     $0408,x                         ; AE96 9D 08 04                 ...
        sta     $0420,x                         ; AE99 9D 20 04                 . .
        lda     LAF25,y                         ; AE9C B9 25 AF                 .%.
        sta     $0468,x                         ; AE9F 9D 68 04                 .h.
        lda     #$FF                            ; AEA2 A9 FF                    ..
        sta     $0480,x                         ; AEA4 9D 80 04                 ...
        jsr     entity_stop_y                           ; AEA7 20 1E EA                  ..
        lda     #$B7                            ; AEAA A9 B7                    ..
        .byte   $9D                             ; AEAC 9D                       .
        brk                                     ; AEAD 00                       .
LAEAE:  .byte   $03                             ; AEAE 03                       .
        lda     #$CC                            ; AEAF A9 CC                    ..
        sta     $0588,x                         ; AEB1 9D 88 05                 ...
        lda     #$AD                            ; AEB4 A9 AD                    ..
        .byte   $9D                             ; AEB6 9D                       .
        .byte   $A0                             ; AEB7 A0                       .
LAEB8:  .byte   $05                             ; AEB8 05                       .
LAEB9:  rts                                     ; AEB9 60                       `

; ----------------------------------------------------------------------------
        .byte   $A5,$BD,$C9,$89,$F0,$F9,$E6,$BD,$D0,$F5,$A5,$BE,$C9 ; AEBA
LAEC7:  .byte   $89,$F0,$EF,$E6,$BE,$D0,$EB,$A5,$BF,$C9,$09,$F0,$E5,$E6,$BF ; AEC7
LAED6:  .byte   $D0,$E1,$A2,$00,$F0,$04,$A6,$32,$F0,$1D,$B5,$B0,$C9,$9C,$F0 ; AED6
LAEE5:  .byte   $17,$F6,$B0,$8A,$48,$A9,$26,$20,$5D,$EC,$20,$63,$F3,$A9,$03,$20 ; AEE5
        .byte   $24,$FF,$68,$AA,$C6,$5A,$D0,$E3,$A9,$01,$85,$95,$A9,$00,$85,$5A ; AEF5
        .byte   $A6,$A6,$60                     ; AF05

; ----------------------------------------------------------------------------
        ldy     $0558,x                         ; AF08 BC 58 05                 .X.
        lda     $F239,y                         ; AF0B B9 39 F2                 .9.
        ora     $6D                             ; AF0E 05 6D                    .m
        sta     $6D                             ; AF10 85 6D                    .m
        cmp     #$FF                            ; AF12 C9 FF                    ..
        bne     LAF1A                           ; AF14 D0 04                    ..
        lda     #$9C                            ; AF16 A9 9C                    ..
        sta     $BC                             ; AF18 85 BC                    ..
LAF1A:  rts                                     ; AF1A 60                       `

; ----------------------------------------------------------------------------
LAF1B:  .byte   $0E,$0A,$08,$03,$02             ; AF1B
LAF20:  .byte   $77,$74,$75,$78,$76             ; AF20
LAF25:  .byte   $13,$23,$13,$23,$23,$00,$00,$0A,$02,$0A,$02,$00,$00,$00,$00,$00 ; AF25
        .byte   $00,$00,$00,$00,$24,$24,$00,$00,$00,$00,$24,$24,$24,$24,$24,$24 ; AF35
        .byte   $24,$24,$24,$BA,$C4,$D8,$D8,$DC,$DC,$CE,$08,$08,$08,$08,$08,$08 ; AF45
        .byte   $08,$08,$AE,$AE,$AE,$AE,$AE,$AE,$AE,$AF,$AF,$AF,$AF,$AF,$AF,$AF ; AF55
        .byte   $AF                             ; AF65
; =============================================================================
; BEHAVIOR type $70 — P.BUSTER SHOT (all charge tiers; sub_types
; $36/$37 normal, $A8/$A9 charged)
; =============================================================================
        jsr     entity_facing_dispatch                           ; AF66 20 65 EA                  e.
        lda     $0330,x                         ; AF69 BD 30 03                 .0.
        sec                                     ; AF6C 38                       8
        sbc     $FC                             ; AF6D E5 FC                    ..
        sta     L0000                           ; AF6F 85 00                    ..
        lda     $0348,x                         ; AF71 BD 48 03                 .H.
        sbc     $F9                             ; AF74 E5 F9                    ..
        bne     LAFDB                           ; AF76 D0 63                    .c
        lda     L0000                           ; AF78 A5 00                    ..
        cmp     #$18                            ; AF7A C9 18                    ..
        bcc     LAFDB                           ; AF7C 90 5D                    .]
        cmp     #$F4                            ; AF7E C9 F4                    ..
        bcs     LAFDB                           ; AF80 B0 59                    .Y
        ldy     $26                             ; AF82 A4 26                    .&
        lda     LB0E1,y                         ; AF84 B9 E1 B0                 ...
        beq     LAFDB                           ; AF87 F0 52                    .R
        cpy     #$0B                            ; AF89 C0 0B                    ..
        bne     LAF93                           ; AF8B D0 06                    ..
        lda     $FA                             ; AF8D A5 FA                    ..
        and     #$0F                            ; AF8F 29 0F                    ).
        bne     LAFDB                           ; AF91 D0 48                    .H
LAF93:  lda     $1C                             ; AF93 A5 1C                    ..
        bne     LAFDB                           ; AF95 D0 44                    .D
        ldy     #$06                            ; AF97 A0 06                    ..
        jsr     tile_collide_horiz                           ; AF99 20 A1 C4                  ..
        lda     L0010                           ; AF9C A5 10                    ..
        cmp     #$30                            ; AF9E C9 30                    .0
        bne     LAFDB                           ; AFA0 D0 39                    .9
        lda     #$2B                            ; AFA2 A9 2B                    .+
        jsr     queue_sound                           ; AFA4 20 5D EC                  ].
        jsr     entity_wipe_x                           ; AFA7 20 C4 F2                  ..
        lda     #$42                            ; AFAA A9 42                    .B
        jsr     entity_set_subtype                           ; AFAC 20 98 EA                  ..
LAFAF:  lda     #$01                            ; AFAF A9 01                    ..
        sta     $0300,x                         ; AFB1 9D 00 03                 ...
        lda     $0330,x                         ; AFB4 BD 30 03                 .0.
        and     #$F0                            ; AFB7 29 F0                    ).
        ora     #$08                            ; AFB9 09 08                    ..
        sta     $0330,x                         ; AFBB 9D 30 03                 .0.
        lda     $0378,x                         ; AFBE BD 78 03                 .x.
        and     #$F0                            ; AFC1 29 F0                    ).
        ora     #$08                            ; AFC3 09 08                    ..
        sta     $0378,x                         ; AFC5 9D 78 03                 .x.
        ldy     $26                             ; AFC8 A4 26                    .&
        lda     LB0E1,y                         ; AFCA B9 E1 B0                 ...
        tay                                     ; AFCD A8                       .
        lda     LB0F0,y                         ; AFCE B9 F0 B0                 ...
        sta     L0000                           ; AFD1 85 00                    ..
        lda     LB0F3,y                         ; AFD3 B9 F3 B0                 ...
        sta     L0001                           ; AFD6 85 01                    ..
        jmp     (L0000)                         ; AFD8 6C 00 00                 l..

; ----------------------------------------------------------------------------
LAFDB:  rts                                     ; AFDB 60                       `

; ----------------------------------------------------------------------------
        ldy     #$30                            ; AFDC A0 30                    .0
LAFDE:  lda     LB0AD,y                         ; AFDE B9 AD B0                 ...
        cmp     $0348,x                         ; AFE1 DD 48 03                 .H.
        bne     LB019                           ; AFE4 D0 33                    .3
        lda     LB0AE,y                         ; AFE6 B9 AE B0                 ...
        cmp     $22                             ; AFE9 C5 22                    ."
        bne     LB019                           ; AFEB D0 2C                    .,
        lda     LB0AF,y                         ; AFED B9 AF B0                 ...
        cmp     $03                             ; AFF0 C5 03                    ..
        bne     LB019                           ; AFF2 D0 25                    .%
        sta     L0010                           ; AFF4 85 10                    ..
        ldx     $43                             ; AFF6 A6 43                    .C
        sta     $06C2,x                         ; AFF8 9D C2 06                 ...
        lda     LB0AD,y                         ; AFFB B9 AD B0                 ...
        sta     $06C0,x                         ; AFFE 9D C0 06                 ...
        lda     LB0AE,y                         ; B001 B9 AE B0                 ...
        sta     $06C1,x                         ; B004 9D C1 06                 ...
        lda     LB0B0,y                         ; B007 B9 B0 B0                 ...
        sta     $06C3,x                         ; B00A 9D C3 06                 ...
        inx                                     ; B00D E8                       .
        inx                                     ; B00E E8                       .
        inx                                     ; B00F E8                       .
        inx                                     ; B010 E8                       .
        stx     $43                             ; B011 86 43                    .C
        ldx     $A6                             ; B013 A6 A6                    ..
        tay                                     ; B015 A8                       .
        jmp     LD7DB                           ; B016 4C DB D7                 L..

; ----------------------------------------------------------------------------
LB019:  dey                                     ; B019 88                       .
        dey                                     ; B01A 88                       .
        dey                                     ; B01B 88                       .
        dey                                     ; B01C 88                       .
        bpl     LAFDE                           ; B01D 10 BF                    ..
        rts                                     ; B01F 60                       `

; ----------------------------------------------------------------------------
        lda     $0378,x                         ; B020 BD 78 03                 .x.
        pha                                     ; B023 48                       H
        lda     $11                             ; B024 A5 11                    ..
        sta     $0378,x                         ; B026 9D 78 03                 .x.
        jsr     LD8A2                           ; B029 20 A2 D8                  ..
        jsr     LD8C7                           ; B02C 20 C7 D8                  ..
        ldy     #$00                            ; B02F A0 00                    ..
        jsr     LD7DB                           ; B031 20 DB D7                  ..
        pla                                     ; B034 68                       h
        sta     $0378,x                         ; B035 9D 78 03                 .x.
        rts                                     ; B038 60                       `

; ----------------------------------------------------------------------------
        lda     $0378,x                         ; B039 BD 78 03                 .x.
        pha                                     ; B03C 48                       H
        lda     $11                             ; B03D A5 11                    ..
        sta     $0378,x                         ; B03F 9D 78 03                 .x.
        lda     $0348,x                         ; B042 BD 48 03                 .H.
        pha                                     ; B045 48                       H
        lda     $13                             ; B046 A5 13                    ..
        sta     $0348,x                         ; B048 9D 48 03                 .H.
        tay                                     ; B04B A8                       .
        lda     $11                             ; B04C A5 11                    ..
        and     #$F0                            ; B04E 29 F0                    ).
        ora     $13                             ; B050 05 13                    ..
        sta     L0000                           ; B052 85 00                    ..
        lda     LBA18,y                         ; B054 B9 18 BA                 ...
        sta     L0001                           ; B057 85 01                    ..
        lda     LB9BB,y                         ; B059 B9 BB B9                 ...
        tay                                     ; B05C A8                       .
LB05D:  lda     LB9BE,y                         ; B05D B9 BE B9                 ...
        cmp     L0000                           ; B060 C5 00                    ..
        bne     LB06C                           ; B062 D0 08                    ..
        lda     LB9BF,y                         ; B064 B9 BF B9                 ...
        cmp     $0330,x                         ; B067 DD 30 03                 .0.
        beq     LB073                           ; B06A F0 07                    ..
LB06C:  iny                                     ; B06C C8                       .
        iny                                     ; B06D C8                       .
        iny                                     ; B06E C8                       .
        inc     L0001                           ; B06F E6 01                    ..
        bne     LB05D                           ; B071 D0 EA                    ..
LB073:  lda     L0001                           ; B073 A5 01                    ..
        and     #$07                            ; B075 29 07                    ).
        tay                                     ; B077 A8                       .
        lda     $F2B2,y                         ; B078 B9 B2 F2                 ...
        sta     L0000                           ; B07B 85 00                    ..
        lda     L0001                           ; B07D A5 01                    ..
        pha                                     ; B07F 48                       H
        lsr     a                               ; B080 4A                       J
        lsr     a                               ; B081 4A                       J
        lsr     a                               ; B082 4A                       J
        tay                                     ; B083 A8                       .
        lda     $05DC,y                         ; B084 B9 DC 05                 ...
        ora     L0000                           ; B087 05 00                    ..
        sta     $05DC,y                         ; B089 99 DC 05                 ...
        jsr     LD8A2                           ; B08C 20 A2 D8                  ..
        jsr     LD8C7                           ; B08F 20 C7 D8                  ..
        pla                                     ; B092 68                       h
        tay                                     ; B093 A8                       .
        lda     LBA1B,y                         ; B094 B9 1B BA                 ...
        tay                                     ; B097 A8                       .
        jsr     LD7DB                           ; B098 20 DB D7                  ..
        pla                                     ; B09B 68                       h
        .byte   $9D                             ; B09C 9D                       .
LB09D:  pha                                     ; B09D 48                       H
        .byte   $03                             ; B09E 03                       .
        pla                                     ; B09F 68                       h
        sta     $0378,x                         ; B0A0 9D 78 03                 .x.
        lda     #$00                            ; B0A3 A9 00                    ..
        sta     $95                             ; B0A5 85 95                    ..
        jsr     frame_wait                           ; B0A7 20 22 FF                  ".
        inc     $95                             ; B0AA E6 95                    ..
        rts                                     ; B0AC 60                       `

; ----------------------------------------------------------------------------
LB0AD:  .byte   $05                             ; B0AD
LB0AE:  .byte   $2F                             ; B0AE
LB0AF:  .byte   $02                             ; B0AF
LB0B0:  .byte   $00,$05,$2F,$03,$00,$05,$37,$00,$00,$05,$37,$01,$00,$0F,$1F,$01 ; B0B0
        .byte   $00,$0F,$1F,$03,$00,$0F,$27,$01,$00,$1A,$1F,$00,$00,$1A,$1F,$01 ; B0C0
        .byte   $00,$1A,$1F,$02,$00,$1A,$1F,$03,$00,$1A,$27,$00,$00,$1A,$27,$01 ; B0D0
        .byte   $00                             ; B0E0
LB0E1:  .byte   $00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$03,$02,$00,$00 ; B0E1
LB0F0:  .byte   $00,$DC,$20                     ; B0F0
LB0F3:  .byte   $39,$AF,$B0,$B0                 ; B0F3
; =============================================================================
; BEHAVIOR type $C5 — GRAVITY HOLD screen effect (flash + lift all
; vulnerable enemies)
; =============================================================================
        lda     $FC                             ; B0F7 A5 FC
        clc                                     ; B0F9 18                       .
        adc     #$80                            ; B0FA 69 80                    i.
        sta     $0330,x                         ; B0FC 9D 30 03                 .0.
        lda     $F9                             ; B0FF A5 F9                    ..
        adc     #$00                            ; B101 69 00                    i.
        sta     $0348,x                         ; B103 9D 48 03                 .H.
        dec     $0468,x                         ; B106 DE 68 04                 .h.
        bne     LB118                           ; B109 D0 0D                    ..
        lda     $0620                           ; B10B AD 20 06                 . .
        sta     $0610                           ; B10E 8D 10 06                 ...
        lda     #$FF                            ; B111 A9 FF                    ..
        sta     $18                             ; B113 85 18                    ..
        jmp     entity_wipe_x                           ; B115 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LB118:  rts                                     ; B118 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR types $C6/$C7/$C8 — delayed-fall debris: sits frozen (anim
; sub-frame pinned) for $0468 frames, then toggles its vflip bit and
; drops under gravity, wiping itself once it leaves the screen
; vertically
; =============================================================================
        lda     #$00                            ; B119 A9 00                    ..
        sta     $0570,x                         ; B11B 9D 70 05                 .p.
        lda     $0468,x                         ; B11E BD 68 04                 .h.
        beq     LB130                           ; B121 F0 0D                    ..
        dec     $0468,x                         ; B123 DE 68 04                 .h.
        bne     LB118                           ; B126 D0 F0                    ..
        lda     $0528,x                         ; B128 BD 28 05                 .(.
        eor     #$40                            ; B12B 49 40                    I@
        sta     $0528,x                         ; B12D 9D 28 05                 .(.
LB130:  jsr     entity_apply_gravity                           ; B130 20 E1 E9                  ..
        jsr     LE999                           ; B133 20 99 E9                  ..
        lda     $0390,x                         ; B136 BD 90 03                 ...
        beq     LB13E                           ; B139 F0 03                    ..
        jsr     entity_wipe_x                           ; B13B 20 C4 F2                  ..
LB13E:  rts                                     ; B13E 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $02 — RUSH COIL: descends, lands, springs the player;
; returns to the sky when done
; =============================================================================
        jsr     LEA03                           ; B13F 20 03 EA                  ..
        jsr     entity_move_down_collide                           ; B142 20 2A E9                  *.
        lda     $46                             ; B145 A5 46                    .F
        ora     $AF                             ; B147 05 AF                    ..
        bne     LB182                           ; B149 D0 37                    .7
        lda     $0378                           ; B14B AD 78 03                 .x.
        sec                                     ; B14E 38                       8
        sbc     $0378,x                         ; B14F FD 78 03                 .x.
        bcc     LB158                           ; B152 90 04                    ..
        cmp     #$28                            ; B154 C9 28                    .(
        bcs     LB182                           ; B156 B0 2A                    .*
LB158:  ldy     #$1B                            ; B158 A0 1B                    ..
        jsr     tile_collide_horiz                           ; B15A 20 A1 C4                  ..
        lda     L0010                           ; B15D A5 10                    ..
        and     #$10                            ; B15F 29 10                    ).
        bne     LB182                           ; B161 D0 1F                    ..
        ldy     #$17                            ; B163 A0 17                    ..
        jsr     tile_collide_horiz                           ; B165 20 A1 C4                  ..
        lda     L0010                           ; B168 A5 10                    ..
        and     #$10                            ; B16A 29 10                    ).
        bne     LB182                           ; B16C D0 14                    ..
        lda     #$78                            ; B16E A9 78                    .x
        sta     $0588,x                         ; B170 9D 88 05                 ...
        lda     #$B1                            ; B173 A9 B1                    ..
        sta     $05A0,x                         ; B175 9D A0 05                 ...
        ldy     #$17                            ; B178 A0 17                    ..
        jsr     LEA03                           ; B17A 20 03 EA                  ..
        jsr     LE747                           ; B17D 20 47 E7                  G.
        bcs     LB188                           ; B180 B0 06                    ..
LB182:  lda     #$00                            ; B182 A9 00                    ..
        sta     $0570,x                         ; B184 9D 70 05                 .p.
LB187:  rts                                     ; B187 60                       `

; ----------------------------------------------------------------------------
LB188:  lda     $0540,x                         ; B188 BD 40 05                 .@.
        cmp     #$04                            ; B18B C9 04                    ..
        bne     LB187                           ; B18D D0 F8                    ..
        lda     #$99                            ; B18F A9 99                    ..
        jsr     entity_set_subtype                           ; B191 20 98 EA                  ..
        lda     #$05                            ; B194 A9 05                    ..
        sta     $ED                             ; B196 85 ED                    ..
        lda     #$A2                            ; B198 A9 A2                    ..
        sta     $0588,x                         ; B19A 9D 88 05                 ...
        lda     #$B1                            ; B19D A9 B1                    ..
        sta     $05A0,x                         ; B19F 9D A0 05                 ...
        lda     $30                             ; B1A2 A5 30                    .0
        cmp     #$02                            ; B1A4 C9 02                    ..
        bcs     LB187                           ; B1A6 B0 DF                    ..
        jsr     entity_player_collide                           ; B1A8 20 87 EF                  ..
        bcs     LB187                           ; B1AB B0 DA                    ..
        jsr     entity_x_dist_px                           ; B1AD 20 94 EC                  ..
        cmp     #$07                            ; B1B0 C9 07                    ..
        bcs     LB187                           ; B1B2 B0 D3                    ..
        lda     $0378,x                         ; B1B4 BD 78 03                 .x.
        sec                                     ; B1B7 38                       8
        sbc     $0378                           ; B1B8 ED 78 03                 .x.
        bcc     LB187                           ; B1BB 90 CA                    ..
        cmp     #$0C                            ; B1BD C9 0C                    ..
        bcc     LB187                           ; B1BF 90 C6                    ..
        lda     $0528,x                         ; B1C1 BD 28 05                 .(.
        ora     #$01                            ; B1C4 09 01                    ..
        sta     $0528,x                         ; B1C6 9D 28 05                 .(.
        lda     #$A9                            ; B1C9 A9 A9                    ..
        sta     $03D8,x                         ; B1CB 9D D8 03                 ...
        lda     #$05                            ; B1CE A9 05                    ..
        sta     $03F0,x                         ; B1D0 9D F0 03                 ...
        lda     #$11                            ; B1D3 A9 11                    ..
        sta     $0408,x                         ; B1D5 9D 08 04                 ...
        lda     #$E7                            ; B1D8 A9 E7                    ..
        sta     $0588,x                         ; B1DA 9D 88 05                 ...
        lda     #$B1                            ; B1DD A9 B1                    ..
        sta     $05A0,x                         ; B1DF 9D A0 05                 ...
        lda     #$04                            ; B1E2 A9 04                    ..
        jmp     LB5E8                           ; B1E4 4C E8 B5                 L..

; ----------------------------------------------------------------------------
        lda     #$9A                            ; B1E7 A9 9A                    ..
        cmp     $0558,x                         ; B1E9 DD 58 05                 .X.
        beq     LB1F1                           ; B1EC F0 03                    ..
        jsr     entity_set_subtype                           ; B1EE 20 98 EA                  ..
LB1F1:  ldy     #$17                            ; B1F1 A0 17                    ..
        jsr     entity_gravity_collide                           ; B1F3 20 B7 E7                  ..
        bcc     LB238                           ; B1F6 90 40                    .@
LB1F8:  lda     #$00                            ; B1F8 A9 00                    ..
        sta     $03D8,x                         ; B1FA 9D D8 03                 ...
        lda     #$08                            ; B1FD A9 08                    ..
        sta     $03F0,x                         ; B1FF 9D F0 03                 ...
        lda     #$22                            ; B202 A9 22                    ."
        sta     $0588,x                         ; B204 9D 88 05                 ...
        lda     #$B2                            ; B207 A9 B2                    ..
        sta     $05A0,x                         ; B209 9D A0 05                 ...
        lda     #$4E                            ; B20C A9 4E                    .N
        jsr     entity_set_subtype                           ; B20E 20 98 EA                  ..
        lda     #$46                            ; B211 A9 46                    .F
        sta     $ED                             ; B213 85 ED                    ..
        lda     #$04                            ; B215 A9 04                    ..
        sta     $0540,x                         ; B217 9D 40 05                 .@.
        lda     $0528,x                         ; B21A BD 28 05                 .(.
        and     #$FE                            ; B21D 29 FE                    ).
        sta     $0528,x                         ; B21F 9D 28 05                 .(.
        lda     $0540,x                         ; B222 BD 40 05                 .@.
        bne     LB238                           ; B225 D0 11                    ..
        jsr     LEA03                           ; B227 20 03 EA                  ..
        jsr     entity_move_up_nofacing                           ; B22A 20 4A E9                  J.
        lda     $0390,x                         ; B22D BD 90 03                 ...
        sta     $0570,x                         ; B230 9D 70 05                 .p.
        beq     LB238                           ; B233 F0 03                    ..
        jsr     entity_wipe_x                           ; B235 20 C4 F2                  ..
LB238:  rts                                     ; B238 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $45 — RUSH JET: descends and hovers to the player's
; level (when reachable, probe $17); ridden flag in ent_var1 enables
; d-pad steering; morphs through $B274 (mount) / $B2xx flight
; =============================================================================
        jsr     LEA03                           ; B239 20 03 EA                  ..
        jsr     entity_move_down_collide                           ; B23C 20 2A E9                  *.
        lda     $46                             ; B23F A5 46                    .F
        ora     $AF                             ; B241 05 AF                    ..
        bne     LB26E                           ; B243 D0 29                    .)
        lda     $0378                           ; B245 AD 78 03                 .x.
        sec                                     ; B248 38                       8
        sbc     $0378,x                         ; B249 FD 78 03                 .x.
        bcc     LB252                           ; B24C 90 04                    ..
        cmp     #$10                            ; B24E C9 10                    ..
        bcs     LB26E                           ; B250 B0 1C                    ..
LB252:  ldy     #$17                            ; B252 A0 17                    ..
        jsr     tile_collide_horiz                           ; B254 20 A1 C4                  ..
        lda     L0010                           ; B257 A5 10                    ..
        and     #$10                            ; B259 29 10                    ).
        bne     LB26E                           ; B25B D0 11                    ..
        lda     $0378,x                         ; B25D BD 78 03                 .x.
        cmp     #$D0                            ; B260 C9 D0                    ..
        bcs     LB26E                           ; B262 B0 0A                    ..
        lda     #$74                            ; B264 A9 74                    .t
        sta     $0588,x                         ; B266 9D 88 05                 ...
        lda     #$B2                            ; B269 A9 B2                    ..
        sta     $05A0,x                         ; B26B 9D A0 05                 ...
LB26E:  lda     #$00                            ; B26E A9 00                    ..
        sta     $0570,x                         ; B270 9D 70 05                 .p.
LB273:  rts                                     ; B273 60                       `

; ----------------------------------------------------------------------------
        lda     $0540,x                         ; B274 BD 40 05                 .@.
        cmp     #$04                            ; B277 C9 04                    ..
        bne     LB273                           ; B279 D0 F8                    ..
        lda     #$98                            ; B27B A9 98                    ..
        jsr     entity_set_subtype                           ; B27D 20 98 EA                  ..
        lda     #$04                            ; B280 A9 04                    ..
        sta     $ED                             ; B282 85 ED                    ..
        lda     #$96                            ; B284 A9 96                    ..
        sta     $0588,x                         ; B286 9D 88 05                 ...
        lda     #$B2                            ; B289 A9 B2                    ..
        sta     $05A0,x                         ; B28B 9D A0 05                 ...
        lda     $0528,x                         ; B28E BD 28 05                 .(.
        ora     #$01                            ; B291 09 01                    ..
        sta     $0528,x                         ; B293 9D 28 05                 .(.
        lda     $04C8                           ; B296 AD C8 04                 ...
        beq     LB273                           ; B299 F0 D8                    ..
        lda     #$C1                            ; B29B A9 C1                    ..
        sta     $0588,x                         ; B29D 9D 88 05                 ...
        lda     #$B2                            ; B2A0 A9 B2                    ..
        sta     $05A0,x                         ; B2A2 9D A0 05                 ...
        lda     $0420,x                         ; B2A5 BD 20 04                 . .
        sta     $0420                           ; B2A8 8D 20 04                 . .
        lda     $0528,x                         ; B2AB BD 28 05                 .(.
        and     #$20                            ; B2AE 29 20                    ) 
        sta     L0000                           ; B2B0 85 00                    ..
        lda     $0528                           ; B2B2 AD 28 05                 .(.
        and     #$DF                            ; B2B5 29 DF                    ).
        ora     L0000                           ; B2B7 05 00                    ..
        sta     $0528                           ; B2B9 8D 28 05                 .(.
        lda     #$32                            ; B2BC A9 32                    .2
        sta     $0468,x                         ; B2BE 9D 68 04                 .h.
        dec     $0468,x                         ; B2C1 DE 68 04                 .h.
        bne     LB2D0                           ; B2C4 D0 0A                    ..
        lda     #$32                            ; B2C6 A9 32                    .2
        sta     $0468,x                         ; B2C8 9D 68 04                 .h.
        lda     #$01                            ; B2CB A9 01                    ..
        jsr     LB5E8                           ; B2CD 20 E8 B5                  ..
LB2D0:  lda     $0420,x                         ; B2D0 BD 20 04                 . .
        and     #$03                            ; B2D3 29 03                    ).
        sta     $0420,x                         ; B2D5 9D 20 04                 . .
        ldy     #$00                            ; B2D8 A0 00                    ..
        lda     $04C8                           ; B2DA AD C8 04                 ...
        beq     LB2FE                           ; B2DD F0 1F                    ..
        lda     $0420,x                         ; B2DF BD 20 04                 . .
        sta     $39                             ; B2E2 85 39                    .9
        lda     $16                             ; B2E4 A5 16                    ..
        and     #$03                            ; B2E6 29 03                    ).
        beq     LB2F1                           ; B2E8 F0 07                    ..
        cmp     $0420,x                         ; B2EA DD 20 04                 . .
        beq     LB2F1                           ; B2ED F0 02                    ..
        ldy     #$02                            ; B2EF A0 02                    ..
LB2F1:  lda     $16                             ; B2F1 A5 16                    ..
        and     #$0C                            ; B2F3 29 0C                    ).
        beq     LB2FE                           ; B2F5 F0 07                    ..
        ora     $0420,x                         ; B2F7 1D 20 04                 . .
        sta     $0420,x                         ; B2FA 9D 20 04                 . .
        iny                                     ; B2FD C8                       .
LB2FE:  lda     LB34F,y                         ; B2FE B9 4F B3                 .O.
        sta     $03A8,x                         ; B301 9D A8 03                 ...
        sta     $3A                             ; B304 85 3A                    .:
        lda     LB353,y                         ; B306 B9 53 B3                 .S.
        sta     $03C0,x                         ; B309 9D C0 03                 ...
        sta     $3B                             ; B30C 85 3B                    .;
        lda     LB357,y                         ; B30E B9 57 B3                 .W.
        sta     $03D8,x                         ; B311 9D D8 03                 ...
        lda     LB35B,y                         ; B314 B9 5B B3                 .[.
        sta     $03F0,x                         ; B317 9D F0 03                 ...
        lda     $BB                             ; B31A A5 BB                    ..
        cmp     #$80                            ; B31C C9 80                    ..
        beq     LB327                           ; B31E F0 07                    ..
        ldy     #$1C                            ; B320 A0 1C                    ..
        jsr     entity_horiz_dispatch                           ; B322 20 3F EA                  ?.
        bcc     LB338                           ; B325 90 11                    ..
LB327:  lda     $39                             ; B327 A5 39                    .9
        beq     LB335                           ; B329 F0 0A                    ..
        lda     $03F0                           ; B32B AD F0 03                 ...
        bpl     LB335                           ; B32E 10 05                    ..
        ldy     #$00                            ; B330 A0 00                    ..
        jsr     LEA34                           ; B332 20 34 EA                  4.
LB335:  jmp     LB1F8                           ; B335 4C F8 B1                 L..

; ----------------------------------------------------------------------------
LB338:  ldy     #$17                            ; B338 A0 17                    ..
        jsr     entity_vert_dispatch                           ; B33A 20 52 EA                  R.
        lda     #$E8                            ; B33D A9 E8                    ..
        cmp     $0378,x                         ; B33F DD 78 03                 .x.
        bcc     LB34B                           ; B342 90 07                    ..
        lda     #$1C                            ; B344 A9 1C                    ..
        cmp     $0378,x                         ; B346 DD 78 03                 .x.
        bcc     LB34E                           ; B349 90 03                    ..
LB34B:  sta     $0378,x                         ; B34B 9D 78 03                 .x.
LB34E:  rts                                     ; B34E 60                       `

; ----------------------------------------------------------------------------
LB34F:  jmp     L0033                           ; B34F 4C 33 00                 L3.

; ----------------------------------------------------------------------------
        .byte   $B5                             ; B352
LB353:  .byte   $01,$01,$01,$00                 ; B353
LB357:  .byte   $00,$7F,$00,$B5                 ; B357
LB35B:  .byte   $00,$00,$00,$00                 ; B35B
; =============================================================================
; BEHAVIOR type $72 — NAPALM BOMB: gravity + ground bounce (rebound
; table LB3B0), reverses on walls; ent_param fuse expires into the
; type $C2 blast (pose $42)
; =============================================================================
        ldy     #$13                            ; B35F A0 13                    ..
        lda     $03D8,x                         ; B361 BD D8 03                 ...
        sta     $0480,x                         ; B364 9D 80 04                 ...
        lda     $03F0,x                         ; B367 BD F0 03                 ...
        sta     $0498,x                         ; B36A 9D 98 04                 ...
        jsr     entity_gravity_collide                           ; B36D 20 B7 E7                  ..
        bcc     LB38E                           ; B370 90 1C                    ..
        ldy     #$00                            ; B372 A0 00                    ..
        lda     $0480,x                         ; B374 BD 80 04                 ...
        sec                                     ; B377 38                       8
        sbc     #$00                            ; B378 E9 00                    ..
        lda     $0498,x                         ; B37A BD 98 04                 ...
        sbc     #$FD                            ; B37D E9 FD                    ..
        bcs     LB382                           ; B37F B0 01                    ..
        iny                                     ; B381 C8                       .
LB382:  lda     LB3B0,y                         ; B382 B9 B0 B3                 ...
        sta     $03D8,x                         ; B385 9D D8 03                 ...
        lda     LB3B2,y                         ; B388 B9 B2 B3                 ...
        sta     $03F0,x                         ; B38B 9D F0 03                 ...
LB38E:  ldy     #$1A                            ; B38E A0 1A                    ..
        jsr     entity_horiz_dispatch                           ; B390 20 3F EA                  ?.
        bcc     LB39D                           ; B393 90 08                    ..
        lda     $0420,x                         ; B395 BD 20 04                 . .
        eor     #$03                            ; B398 49 03                    I.
        sta     $0420,x                         ; B39A 9D 20 04                 . .
LB39D:  dec     $0468,x                         ; B39D DE 68 04                 .h.
        bne     LB3AF                           ; B3A0 D0 0D                    ..
        jsr     entity_wipe_x                           ; B3A2 20 C4 F2                  ..
        lda     #$42                            ; B3A5 A9 42                    .B
        jsr     entity_set_subtype                           ; B3A7 20 98 EA                  ..
        lda     #$C2                            ; B3AA A9 C2                    ..
        sta     $0300,x                         ; B3AC 9D 00 03                 ...
LB3AF:  rts                                     ; B3AF 60                       `

; ----------------------------------------------------------------------------
LB3B0:  .byte   $80                             ; B3B0 80                       .
        .byte   $80                             ; B3B1 80                       .
LB3B2:  ora     ($02,x)                         ; B3B2 01 02                    ..
; =============================================================================
; BEHAVIOR type $73 — CRYSTAL EYE: flies until a wall, then splits
; into three shard copies (velocity table LB43E-LB44A, behavior
; $B40B: bounce off walls AND floors/ceilings, $78-frame life)
; =============================================================================
        ldy     #$1A                            ; B3B4 A0 1A                    ..
        jsr     entity_horiz_dispatch                           ; B3B6 20 3F EA                  ?.
        bcc     LB40A                           ; B3B9 90 4F                    .O
        lda     #$0F                            ; B3BB A9 0F                    ..
        sta     $5B                             ; B3BD 85 5B                    .[
        ldy     #$03                            ; B3BF A0 03                    ..
LB3C1:  lda     #$AD                            ; B3C1 A9 AD                    ..
        jsr     entity_init_pos                           ; B3C3 20 A4 EA                  ..
        lda     #$73                            ; B3C6 A9 73                    .s
        sta     $0300,y                         ; B3C8 99 00 03                 ...
        lda     #$00                            ; B3CB A9 00                    ..
        sta     $0408,y                         ; B3CD 99 08 04                 ...
        lda     #$0B                            ; B3D0 A9 0B                    ..
        sta     $0588,y                         ; B3D2 99 88 05                 ...
        lda     #$B4                            ; B3D5 A9 B4                    ..
        sta     $05A0,y                         ; B3D7 99 A0 05                 ...
        lda     $0420,x                         ; B3DA BD 20 04                 . .
        eor     #$03                            ; B3DD 49 03                    I.
        ora     LB43B,y                         ; B3DF 19 3B B4                 .;.
        sta     $0420,y                         ; B3E2 99 20 04                 . .
        lda     LB43E,y                         ; B3E5 B9 3E B4                 .>.
        sta     $03A8,y                         ; B3E8 99 A8 03                 ...
        lda     LB441,y                         ; B3EB B9 41 B4                 .A.
        sta     $03C0,y                         ; B3EE 99 C0 03                 ...
        lda     LB444,y                         ; B3F1 B9 44 B4                 .D.
        sta     $03D8,y                         ; B3F4 99 D8 03                 ...
        lda     LB447,y                         ; B3F7 B9 47 B4                 .G.
        sta     $03F0,y                         ; B3FA 99 F0 03                 ...
        lda     #$00                            ; B3FD A9 00                    ..
        sta     $0408,y                         ; B3FF 99 08 04                 ...
        lda     #$78                            ; B402 A9 78                    .x
        sta     $0468,y                         ; B404 99 68 04                 .h.
        dey                                     ; B407 88                       .
        bne     LB3C1                           ; B408 D0 B7                    ..
LB40A:  rts                                     ; B40A 60                       `

; ----------------------------------------------------------------------------
        ldy     #$1A                            ; B40B A0 1A                    ..
        jsr     entity_horiz_dispatch                           ; B40D 20 3F EA                  ?.
        bcc     LB41A                           ; B410 90 08                    ..
        lda     $0420,x                         ; B412 BD 20 04                 . .
        eor     #$03                            ; B415 49 03                    I.
        sta     $0420,x                         ; B417 9D 20 04                 . .
LB41A:  ldy     #$13                            ; B41A A0 13                    ..
        jsr     entity_vert_dispatch                           ; B41C 20 52 EA                  R.
        bcc     LB429                           ; B41F 90 08                    ..
        lda     $0420,x                         ; B421 BD 20 04                 . .
        eor     #$0C                            ; B424 49 0C                    I.
        sta     $0420,x                         ; B426 9D 20 04                 . .
LB429:  dec     $0468,x                         ; B429 DE 68 04                 .h.
        bne     LB43B                           ; B42C D0 0D                    ..
        jsr     entity_wipe_x                           ; B42E 20 C4 F2                  ..
        lda     #$01                            ; B431 A9 01                    ..
        sta     $0300,x                         ; B433 9D 00 03                 ...
        lda     #$42                            ; B436 A9 42                    .B
        jsr     entity_set_subtype                           ; B438 20 98 EA                  ..
LB43B:  rts                                     ; B43B 60                       `

; ----------------------------------------------------------------------------
        .byte   $00,$08                         ; B43C
LB43E:  .byte   $04,$00,$D4                     ; B43E
LB441:  .byte   $D4,$04,$02                     ; B441
LB444:  .byte   $02,$00,$D4                     ; B444
LB447:  .byte   $D4,$00,$02,$02                 ; B447
; =============================================================================
; BEHAVIOR type $74 — GYRO ATTACK: Up/Down held redirects it
; vertically (once); propeller hum $41 every $24 frames; dies
; off-screen
; =============================================================================
        lda     $16                             ; B44B A5 16                    ..
        and     #$0C                            ; B44D 29 0C                    ).
        beq     LB45E                           ; B44F F0 0D                    ..
        sta     $0420,x                         ; B451 9D 20 04                 . .
        lda     #$5E                            ; B454 A9 5E                    .^
        sta     $0588,x                         ; B456 9D 88 05                 ...
        lda     #$B4                            ; B459 A9 B4                    ..
        sta     $05A0,x                         ; B45B 9D A0 05                 ...
LB45E:  lda     $0498,x                         ; B45E BD 98 04                 ...
        cmp     #$24                            ; B461 C9 24                    .$
        bne     LB46F                           ; B463 D0 0A                    ..
        lda     #$00                            ; B465 A9 00                    ..
        sta     $0498,x                         ; B467 9D 98 04                 ...
        lda     #$41                            ; B46A A9 41                    .A
        jsr     queue_sound                           ; B46C 20 5D EC                  ].
LB46F:  inc     $0498,x                         ; B46F FE 98 04                 ...
; =============================================================================
; BEHAVIOR types $46/$4E/$7F — deflected shot: tumbles away (the
; damage engine converts ricocheted shots to type $46)
; =============================================================================
        jsr     entity_facing_dispatch                           ; B472 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; B475 20 86 EA                  ..
        lda     $0390,x                         ; B478 BD 90 03                 ...
        beq     LB480                           ; B47B F0 03                    ..
        jsr     entity_wipe_x                           ; B47D 20 C4 F2                  ..
LB480:  rts                                     ; B480 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $75 — WATER WAVE segment: crawls forward hugging the
; ground; per-anim-phase y-offset/extent/damage-tier tables LB4D6+;
; dies on wall contact / phase 5
; =============================================================================
        lda     $0570,x                         ; B481 BD 70 05                 .p.
        cmp     #$02                            ; B484 C9 02                    ..
        bne     LB4AC                           ; B486 D0 24                    .$
        ldy     $0540,x                         ; B488 BC 40 05                 .@.
        lda     $0378,x                         ; B48B BD 78 03                 .x.
        clc                                     ; B48E 18                       .
        adc     LB4D6,y                         ; B48F 79 D6 B4                 y..
        sta     $0378,x                         ; B492 9D 78 03                 .x.
        lda     LB4DC,y                         ; B495 B9 DC B4                 ...
        sta     $0468,x                         ; B498 9D 68 04                 .h.
        lda     LB4E2,y                         ; B49B B9 E2 B4                 ...
        sta     $5B                             ; B49E 85 5B                    .[
        lda     $0480,x                         ; B4A0 BD 80 04                 ...
        beq     LB4AC                           ; B4A3 F0 07                    ..
        cpy     #$05                            ; B4A5 C0 05                    ..
        bne     LB4AC                           ; B4A7 D0 03                    ..
        jmp     entity_wipe_x                           ; B4A9 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LB4AC:  lda     $0498,x                         ; B4AC BD 98 04                 ...
        beq     LB4BE                           ; B4AF F0 0D                    ..
        dec     $0498,x                         ; B4B1 DE 98 04                 ...
        bne     LB4D5                           ; B4B4 D0 1F                    ..
        lda     $0528,x                         ; B4B6 BD 28 05                 .(.
        and     #$FB                            ; B4B9 29 FB                    ).
        sta     $0528,x                         ; B4BB 9D 28 05                 .(.
LB4BE:  ldy     $0468,x                         ; B4BE BC 68 04                 .h.
        jsr     entity_gravity_collide                           ; B4C1 20 B7 E7                  ..
        bcc     LB4D5                           ; B4C4 90 0F                    ..
        lda     #$00                            ; B4C6 A9 00                    ..
        sta     $0480,x                         ; B4C8 9D 80 04                 ...
        ldy     #$1A                            ; B4CB A0 1A                    ..
        jsr     entity_horiz_dispatch                           ; B4CD 20 3F EA                  ?.
        bcc     LB4D5                           ; B4D0 90 03                    ..
        inc     $0480,x                         ; B4D2 FE 80 04                 ...
LB4D5:  rts                                     ; B4D5 60                       `

; ----------------------------------------------------------------------------
LB4D6:  .byte   $FC,$FC,$FC,$04,$04,$04         ; B4D6
LB4DC:  .byte   $23,$27,$1C,$27,$23,$13         ; B4DC
LB4E2:  .byte   $01,$01,$01,$01,$01,$01         ; B4E2
; =============================================================================
; BEHAVIOR type $76 — SUPER ARROW: accelerates $00.33/frame to 4px/f;
; on wall contact sticks (rideable platform) for $78 frames;
; boss-rush room special-cases scroll seams
; =============================================================================
        lda     $0468,x                         ; B4E8 BD 68 04                 .h.
        beq     LB501                           ; B4EB F0 14                    ..
        dec     $0468,x                         ; B4ED DE 68 04                 .h.
        bne     LB51B                           ; B4F0 D0 29                    .)
        lda     #$05                            ; B4F2 A9 05                    ..
        sta     $0468,x                         ; B4F4 9D 68 04                 .h.
        lda     #$01                            ; B4F7 A9 01                    ..
        sta     $0588,x                         ; B4F9 9D 88 05                 ...
        lda     #$B5                            ; B4FC A9 B5                    ..
        sta     $05A0,x                         ; B4FE 9D A0 05                 ...
LB501:  lda     $03A8,x                         ; B501 BD A8 03                 ...
        clc                                     ; B504 18                       .
        adc     #$33                            ; B505 69 33                    i3
        sta     $03A8,x                         ; B507 9D A8 03                 ...
        lda     $03C0,x                         ; B50A BD C0 03                 ...
        adc     #$00                            ; B50D 69 00                    i.
        sta     $03C0,x                         ; B50F 9D C0 03                 ...
        cmp     #$04                            ; B512 C9 04                    ..
        bne     LB51B                           ; B514 D0 05                    ..
        lda     #$00                            ; B516 A9 00                    ..
        sta     $03A8,x                         ; B518 9D A8 03                 ...
LB51B:  lda     #$00                            ; B51B A9 00                    ..
        sta     $0F                             ; B51D 85 0F                    ..
        ldy     #$1E                            ; B51F A0 1E                    ..
        jsr     entity_horiz_dispatch                           ; B521 20 3F EA                  ?.
        bcc     LB57F                           ; B524 90 59                    .Y
        inc     $0540,x                         ; B526 FE 40 05                 .@.
        lda     #$60                            ; B529 A9 60                    .`
        sta     $0588,x                         ; B52B 9D 88 05                 ...
        lda     #$B5                            ; B52E A9 B5                    ..
        sta     $05A0,x                         ; B530 9D A0 05                 ...
        lda     #$78                            ; B533 A9 78                    .x
        sta     $0468,x                         ; B535 9D 68 04                 .h.
        lda     $26                             ; B538 A5 26                    .&
        cmp     #$0E                            ; B53A C9 0E                    ..
        bne     LB54C                           ; B53C D0 0E                    ..
        lda     $0378,x                         ; B53E BD 78 03                 .x.
        sta     $0498,x                         ; B541 9D 98 04                 ...
        lda     $FA                             ; B544 A5 FA                    ..
        sta     $04C8,x                         ; B546 9D C8 04                 ...
        jmp     LB560                           ; B549 4C 60 B5                 L`.

; ----------------------------------------------------------------------------
LB54C:  lda     $0378,x                         ; B54C BD 78 03                 .x.
        clc                                     ; B54F 18                       .
        adc     $FA                             ; B550 65 FA                    e.
        sta     $0498,x                         ; B552 9D 98 04                 ...
        bcs     LB55B                           ; B555 B0 04                    ..
        cmp     #$F0                            ; B557 C9 F0                    ..
        bcc     LB560                           ; B559 90 05                    ..
LB55B:  adc     #$0F                            ; B55B 69 0F                    i.
        sta     $0498,x                         ; B55D 9D 98 04                 ...
LB560:  lda     #$FF                            ; B560 A9 FF                    ..
        sta     $0F                             ; B562 85 0F                    ..
        dec     $0468,x                         ; B564 DE 68 04                 .h.
        bne     LB5A1                           ; B567 D0 38                    .8
        jsr     entity_wipe_x                           ; B569 20 C4 F2                  ..
        lda     #$01                            ; B56C A9 01                    ..
        sta     $0300,x                         ; B56E 9D 00 03                 ...
        lda     #$42                            ; B571 A9 42                    .B
        jsr     entity_set_subtype                           ; B573 20 98 EA                  ..
        lda     $0528,x                         ; B576 BD 28 05                 .(.
        and     #$FC                            ; B579 29 FC                    ).
        sta     $0528,x                         ; B57B 9D 28 05                 .(.
        rts                                     ; B57E 60                       `

; ----------------------------------------------------------------------------
LB57F:  cpx     $73                             ; B57F E4 73                    .s
        bne     LB5A1                           ; B581 D0 1E                    ..
        dec     $0468,x                         ; B583 DE 68 04                 .h.
        bne     LB592                           ; B586 D0 0A                    ..
        lda     #$05                            ; B588 A9 05                    ..
        sta     $0468,x                         ; B58A 9D 68 04                 .h.
        lda     #$01                            ; B58D A9 01                    ..
        jsr     LB5E8                           ; B58F 20 E8 B5                  ..
LB592:  lda     $0420,x                         ; B592 BD 20 04                 . .
        sta     $39                             ; B595 85 39                    .9
        lda     $03A8,x                         ; B597 BD A8 03                 ...
        sta     $3A                             ; B59A 85 3A                    .:
        lda     $03C0,x                         ; B59C BD C0 03                 ...
        sta     $3B                             ; B59F 85 3B                    .;
LB5A1:  lda     #$00                            ; B5A1 A9 00                    ..
        sta     $0570,x                         ; B5A3 9D 70 05                 .p.
        lda     $0F                             ; B5A6 A5 0F                    ..
        beq     LB5E7                           ; B5A8 F0 3D                    .=
        lda     $46                             ; B5AA A5 46                    .F
        beq     LB5E7                           ; B5AC F0 39                    .9
        lda     $26                             ; B5AE A5 26                    .&
        cmp     #$0E                            ; B5B0 C9 0E                    ..
        bne     LB5CD                           ; B5B2 D0 19                    ..
        lda     $FA                             ; B5B4 A5 FA                    ..
        sec                                     ; B5B6 38                       8
        sbc     $04C8,x                         ; B5B7 FD C8 04                 ...
        clc                                     ; B5BA 18                       .
        adc     $0498,x                         ; B5BB 7D 98 04                 }..
        sta     $0378,x                         ; B5BE 9D 78 03                 .x.
        .byte   $B0                             ; B5C1 B0                       .
LB5C2:  .byte   $1A                             ; B5C2 1A                       .
        cmp     #$F0                            ; B5C3 C9 F0                    ..
        bcc     LB5E7                           ; B5C5 90 20                    . 
        adc     #$0F                            ; B5C7 69 0F                    i.
        .byte   $9D                             ; B5C9 9D                       .
LB5CA:  sei                                     ; B5CA 78                       x
        .byte   $03                             ; B5CB 03                       .
        rts                                     ; B5CC 60                       `

; ----------------------------------------------------------------------------
LB5CD:  lda     $0498,x                         ; B5CD BD 98 04                 ...
        sec                                     ; B5D0 38                       8
        sbc     $FA                             ; B5D1 E5 FA                    ..
        sta     $0378,x                         ; B5D3 9D 78 03                 .x.
        bcs     LB5DD                           ; B5D6 B0 05                    ..
        sbc     #$0F                            ; B5D8 E9 0F                    ..
        sta     $0378,x                         ; B5DA 9D 78 03                 .x.
LB5DD:  ldy     $26                             ; B5DD A4 26                    .&
        cmp     LB5FE,y                         ; B5DF D9 FE B5                 ...
        bcc     LB5E7                           ; B5E2 90 03                    ..
        jsr     entity_wipe_x                           ; B5E4 20 C4 F2                  ..
LB5E7:  rts                                     ; B5E7 60                       `

; ----------------------------------------------------------------------------
LB5E8:  sta     L0000                           ; B5E8 85 00                    ..
        ldy     $32                             ; B5EA A4 32                    .2
        lda     $B0,y                           ; B5EC B9 B0 00                 ...
        .byte   $29                             ; B5EF 29                       )
LB5F0:  .byte   $7F                             ; B5F0 7F                       .
        sec                                     ; B5F1 38                       8
        sbc     L0000                           ; B5F2 E5 00                    ..
LB5F4:  bcs     LB5F8                           ; B5F4 B0 02                    ..
LB5F6:  lda     #$00                            ; B5F6 A9 00                    ..
LB5F8:  ora     #$80                            ; B5F8 09 80                    ..
        .byte   $99                             ; B5FA 99                       .
        .byte   $B0                             ; B5FB B0                       .
LB5FC:  brk                                     ; B5FC 00                       .
        rts                                     ; B5FD 60                       `

; ----------------------------------------------------------------------------
LB5FE:  beq     LB5F0                           ; B5FE F0 F0                    ..
        beq     LB5C2                           ; B600 F0 C0                    ..
        beq     LB5F4                           ; B602 F0 F0                    ..
        beq     LB5F6                           ; B604 F0 F0                    ..
        beq     LB5F8                           ; B606 F0 F0                    ..
        beq     LB5CA                           ; B608 F0 C0                    ..
        bne     LB5FC                           ; B60A D0 F0                    ..
        beq     LB5FE                           ; B60C F0 F0                    ..
; =============================================================================
; BEHAVIOR type $77 — STAR CRASH shield: orbits the player; B press
; launches it in the facing direction; metered here
; =============================================================================
        lda     $0540,x                         ; B60E BD 40 05                 .@.
        cmp     #$02                            ; B611 C9 02                    ..
        bne     LB654                           ; B613 D0 3F                    .?
        lda     #$AB                            ; B615 A9 AB                    ..
        jsr     entity_set_subtype                           ; B617 20 98 EA                  ..
        lda     #$24                            ; B61A A9 24                    .$
        sta     $0588,x                         ; B61C 9D 88 05                 ...
        lda     #$B6                            ; B61F A9 B6                    ..
        sta     $05A0,x                         ; B621 9D A0 05                 ...
        lda     $14                             ; B624 A5 14                    ..
        and     #$40                            ; B626 29 40                    )@
        beq     LB654                           ; B628 F0 2A                    .*
        lda     #$01                            ; B62A A9 01                    ..
        sta     $0420,x                         ; B62C 9D 20 04                 . .
        lda     $0528                           ; B62F AD 28 05                 .(.
        and     #$20                            ; B632 29 20                    ) 
        bne     LB63B                           ; B634 D0 05                    ..
        lda     #$02                            ; B636 A9 02                    ..
        sta     $0420,x                         ; B638 9D 20 04                 . .
LB63B:  lda     #$00                            ; B63B A9 00                    ..
        sta     $03A8,x                         ; B63D 9D A8 03                 ...
        lda     #$03                            ; B640 A9 03                    ..
        sta     $03C0,x                         ; B642 9D C0 03                 ...
        lda     #$6D                            ; B645 A9 6D                    .m
        sta     $0588,x                         ; B647 9D 88 05                 ...
        lda     #$B6                            ; B64A A9 B6                    ..
        sta     $05A0,x                         ; B64C 9D A0 05                 ...
        lda     #$02                            ; B64F A9 02                    ..
        jsr     LB5E8                           ; B651 20 E8 B5                  ..
LB654:  lda     $0330                           ; B654 AD 30 03                 .0.
        sta     $0330,x                         ; B657 9D 30 03                 .0.
        lda     $0348                           ; B65A AD 48 03                 .H.
        sta     $0348,x                         ; B65D 9D 48 03                 .H.
        lda     $0378                           ; B660 AD 78 03                 .x.
        sta     $0378,x                         ; B663 9D 78 03                 .x.
        lda     $0390                           ; B666 AD 90 03                 ...
        sta     $0390,x                         ; B669 9D 90 03                 ...
        rts                                     ; B66C 60                       `

; ----------------------------------------------------------------------------
        lda     $0528,x                         ; B66D BD 28 05                 .(.
        pha                                     ; B670 48                       H
        jsr     entity_facing_dispatch                           ; B671 20 65 EA                  e.
        pla                                     ; B674 68                       h
        sta     $0528,x                         ; B675 9D 28 05                 .(.
        rts                                     ; B678 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $78 — POWER STONE stone: spirals outward from the
; player on its phase counter
; =============================================================================
        lda     $0480,x                         ; B679 BD 80 04                 ...
        bne     LB6AA                           ; B67C D0 2C                    .,
        ldy     $0468,x                         ; B67E BC 68 04                 .h.
        lda     #$48                            ; B681 A9 48                    .H
        jsr     entity_set_dir_velocity                           ; B683 20 70 F4                  p.
        dec     $0468,x                         ; B686 DE 68 04                 .h.
        lda     $0468,x                         ; B689 BD 68 04                 .h.
        and     #$0F                            ; B68C 29 0F                    ).
        sta     $0468,x                         ; B68E 9D 68 04                 .h.
        and     #$03                            ; B691 29 03                    ).
        bne     LB698                           ; B693 D0 03                    ..
        inc     $0498,x                         ; B695 FE 98 04                 ...
LB698:  lda     $0498,x                         ; B698 BD 98 04                 ...
        sta     $0480,x                         ; B69B 9D 80 04                 ...
        cmp     #$08                            ; B69E C9 08                    ..
        bcc     LB6AA                           ; B6A0 90 08                    ..
        lda     $0528,x                         ; B6A2 BD 28 05                 .(.
        bmi     LB6AA                           ; B6A5 30 03                    0.
        jmp     entity_wipe_x                           ; B6A7 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LB6AA:  lda     $0540,x                         ; B6AA BD 40 05                 .@.
        cmp     #$03                            ; B6AD C9 03                    ..
        bne     LB6B6                           ; B6AF D0 05                    ..
        lda     #$00                            ; B6B1 A9 00                    ..
        sta     $0570,x                         ; B6B3 9D 70 05                 .p.
LB6B6:  jsr     entity_facing_dispatch                           ; B6B6 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; B6B9 20 86 EA                  ..
        lda     $0528,x                         ; B6BC BD 28 05                 .(.
        and     #$DF                            ; B6BF 29 DF                    ).
        sta     $0528,x                         ; B6C1 9D 28 05                 .(.
        dec     $0480,x                         ; B6C4 DE 80 04                 ...
        rts                                     ; B6C7 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $79 — BEAT: dives at the nearest target, loops back
; up between passes
; =============================================================================
        lda     $BC                             ; B6C8 A5 BC                    ..
        cmp     #$80                            ; B6CA C9 80                    ..
        beq     LB731                           ; B6CC F0 63                    .c
        lda     $0330                           ; B6CE AD 30 03                 .0.
        pha                                     ; B6D1 48                       H
        lda     $0348                           ; B6D2 AD 48 03                 .H.
        pha                                     ; B6D5 48                       H
        lda     $0378                           ; B6D6 AD 78 03                 .x.
        pha                                     ; B6D9 48                       H
        lda     $0378                           ; B6DA AD 78 03                 .x.
        sec                                     ; B6DD 38                       8
        sbc     #$18                            ; B6DE E9 18                    ..
        bcs     LB6E4                           ; B6E0 B0 02                    ..
        lda     #$00                            ; B6E2 A9 00                    ..
LB6E4:  sta     $0378                           ; B6E4 8D 78 03                 .x.
        ldy     #$00                            ; B6E7 A0 00                    ..
        lda     $0528                           ; B6E9 AD 28 05                 .(.
        and     #$20                            ; B6EC 29 20                    ) 
        beq     LB6F1                           ; B6EE F0 01                    ..
        iny                                     ; B6F0 C8                       .
LB6F1:  lda     $0330                           ; B6F1 AD 30 03                 .0.
        clc                                     ; B6F4 18                       .
        adc     LB82F,y                         ; B6F5 79 2F B8                 y/.
        sta     $0330                           ; B6F8 8D 30 03                 .0.
        lda     $0348                           ; B6FB AD 48 03                 .H.
        adc     LB831,y                         ; B6FE 79 31 B8                 y1.
        sta     $0348                           ; B701 8D 48 03                 .H.
        jsr     LB7EE                           ; B704 20 EE B7                  ..
        bcc     LB711                           ; B707 90 08                    ..
        jsr     LED5B                           ; B709 20 5B ED                  [.
        lda     #$40                            ; B70C A9 40                    .@
        jsr     entity_set_dir_velocity                           ; B70E 20 70 F4                  p.
LB711:  pla                                     ; B711 68                       h
        sta     $0378                           ; B712 8D 78 03                 .x.
        pla                                     ; B715 68                       h
        sta     $0348                           ; B716 8D 48 03                 .H.
        pla                                     ; B719 68                       h
        sta     $0330                           ; B71A 8D 30 03                 .0.
        jsr     entity_facing_dispatch                           ; B71D 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; B720 20 86 EA                  ..
        dec     $0468,x                         ; B723 DE 68 04                 .h.
        bne     LB730                           ; B726 D0 08                    ..
        lda     #$0A                            ; B728 A9 0A                    ..
        sta     $0468,x                         ; B72A 9D 68 04                 .h.
        jsr     LB783                           ; B72D 20 83 B7                  ..
LB730:  rts                                     ; B730 60                       `

; ----------------------------------------------------------------------------
LB731:  jsr     entity_wipe_x                           ; B731 20 C4 F2                  ..
        lda     #$46                            ; B734 A9 46                    .F
        sta     $0300,x                         ; B736 9D 00 03                 ...
        lda     #$C6                            ; B739 A9 C6                    ..
        sta     $03A8,x                         ; B73B 9D A8 03                 ...
        sta     $03D8,x                         ; B73E 9D D8 03                 ...
        lda     #$01                            ; B741 A9 01                    ..
        sta     $03C0,x                         ; B743 9D C0 03                 ...
        sta     $03F0,x                         ; B746 9D F0 03                 ...
        lda     $0330,x                         ; B749 BD 30 03                 .0.
        sec                                     ; B74C 38                       8
        sbc     $FC                             ; B74D E5 FC                    ..
        tay                                     ; B74F A8                       .
        lda     #$09                            ; B750 A9 09                    ..
        cpy     #$80                            ; B752 C0 80                    ..
        bcs     LB758                           ; B754 B0 02                    ..
        lda     #$0A                            ; B756 A9 0A                    ..
LB758:  sta     $0420,x                         ; B758 9D 20 04                 . .
        rts                                     ; B75B 60                       `

; ----------------------------------------------------------------------------
        ldy     $0468,x                         ; B75C BC 68 04                 .h.
        jsr     LED5D                           ; B75F 20 5D ED                  ].
        lda     #$40                            ; B762 A9 40                    .@
        jsr     entity_set_dir_velocity                           ; B764 20 70 F4                  p.
        ldy     $0468,x                         ; B767 BC 68 04                 .h.
        lda     $0300,y                         ; B76A B9 00 03                 ...
        cmp     $0480,x                         ; B76D DD 80 04                 ...
        bne     LB778                           ; B770 D0 06                    ..
        jsr     entity_facing_dispatch                           ; B772 20 65 EA                  e.
        jmp     entity_vert_dispatch_raw                           ; B775 4C 86 EA                 L..

; ----------------------------------------------------------------------------
LB778:  lda     #$C8                            ; B778 A9 C8                    ..
        sta     $0588,x                         ; B77A 9D 88 05                 ...
        lda     #$B6                            ; B77D A9 B6                    ..
        sta     $05A0,x                         ; B77F 9D A0 05                 ...
        rts                                     ; B782 60                       `

; ----------------------------------------------------------------------------
LB783:  ldy     #$17                            ; B783 A0 17                    ..
        lda     #$FF                            ; B785 A9 FF                    ..
        sta     L0001                           ; B787 85 01                    ..
        lda     #$00                            ; B789 A9 00                    ..
        sta     $02                             ; B78B 85 02                    ..
LB78D:  lda     $0300,y                         ; B78D B9 00 03                 ...
        beq     LB7B8                           ; B790 F0 26                    .&
        lda     $0528,y                         ; B792 B9 28 05                 .(.
        bpl     LB7B8                           ; B795 10 21                    .!
        and     #$04                            ; B797 29 04                    ).
        bne     LB7B8                           ; B799 D0 1D                    ..
        lda     $0408,y                         ; B79B B9 08 04                 ...
        and     #$40                            ; B79E 29 40                    )@
        beq     LB7B8                           ; B7A0 F0 16                    ..
        jsr     LECAB                           ; B7A2 20 AB EC                  ..
        sta     L0000                           ; B7A5 85 00                    ..
        jsr     LEC85                           ; B7A7 20 85 EC                  ..
        cmp     L0000                           ; B7AA C5 00                    ..
        bcc     LB7B0                           ; B7AC 90 02                    ..
        lda     L0000                           ; B7AE A5 00                    ..
LB7B0:  cmp     L0001                           ; B7B0 C5 01                    ..
        bcs     LB7B8                           ; B7B2 B0 04                    ..
        sta     L0001                           ; B7B4 85 01                    ..
        sty     $02                             ; B7B6 84 02                    ..
LB7B8:  dey                                     ; B7B8 88                       .
        cpy     #$07                            ; B7B9 C0 07                    ..
        bne     LB78D                           ; B7BB D0 D0                    ..
        lda     $02                             ; B7BD A5 02                    ..
        beq     LB7ED                           ; B7BF F0 2C                    .,
        sta     $0468,x                         ; B7C1 9D 68 04                 .h.
        tay                                     ; B7C4 A8                       .
        lda     $0300,y                         ; B7C5 B9 00 03                 ...
        sta     $0480,x                         ; B7C8 9D 80 04                 ...
        lda     $0330,y                         ; B7CB B9 30 03                 .0.
        sta     $0498,x                         ; B7CE 9D 98 04                 ...
        lda     $0378,y                         ; B7D1 B9 78 03                 .x.
        sta     $04C8,x                         ; B7D4 9D C8 04                 ...
        lda     #$5C                            ; B7D7 A9 5C                    .\
        sta     $0588,x                         ; B7D9 9D 88 05                 ...
        lda     #$B7                            ; B7DC A9 B7                    ..
        sta     $05A0,x                         ; B7DE 9D A0 05                 ...
        jsr     entity_distance_from_y                           ; B7E1 20 C4 EC                  ..
        tay                                     ; B7E4 A8                       .
        sta     $04B0,x                         ; B7E5 9D B0 04                 ...
        lda     #$40                            ; B7E8 A9 40                    .@
        jsr     entity_set_dir_velocity                           ; B7EA 20 70 F4                  p.
LB7ED:  rts                                     ; B7ED 60                       `

; ----------------------------------------------------------------------------
LB7EE:  jsr     entity_y_dist_abs                           ; B7EE 20 76 EC                  v.
        cmp     #$04                            ; B7F1 C9 04                    ..
        bcs     LB829                           ; B7F3 B0 34                    .4
        jsr     entity_x_dist_px                           ; B7F5 20 94 EC                  ..
        cmp     #$04                            ; B7F8 C9 04                    ..
        bcs     LB829                           ; B7FA B0 2D                    .-
        lda     #$00                            ; B7FC A9 00                    ..
        sta     $0420,x                         ; B7FE 9D 20 04                 . .
        lda     $0330                           ; B801 AD 30 03                 .0.
        sta     $0330,x                         ; B804 9D 30 03                 .0.
        lda     $0348                           ; B807 AD 48 03                 .H.
        sta     $0348,x                         ; B80A 9D 48 03                 .H.
        lda     $0378                           ; B80D AD 78 03                 .x.
        sta     $0378,x                         ; B810 9D 78 03                 .x.
        lda     #$9C                            ; B813 A9 9C                    ..
        cmp     $0558,x                         ; B815 DD 58 05                 .X.
        beq     LB81D                           ; B818 F0 03                    ..
        jsr     entity_set_subtype                           ; B81A 20 98 EA                  ..
LB81D:  clc                                     ; B81D 18                       .
        lda     $0528                           ; B81E AD 28 05                 .(.
LB821:  and     #$20                            ; B821 29 20                    ) 
        ora     #$80                            ; B823 09 80                    ..
        sta     $0528,x                         ; B825 9D 28 05                 .(.
        rts                                     ; B828 60                       `

; ----------------------------------------------------------------------------
LB829:  lda     #$0A                            ; B829 A9 0A                    ..
        sta     $0468,x                         ; B82B 9D 68 04                 .h.
        rts                                     ; B82E 60                       `

; ----------------------------------------------------------------------------
LB82F:  bpl     LB821                           ; B82F 10 F0                    ..
LB831:  brk                                     ; B831 00                       .
        .byte   $FF                             ; B832 FF                       .
; =============================================================================
; BEHAVIOR type $03 — screen-crossing drifter: adds its velocity to the
; full 24-bit position on both axes, with screen-carry deltas taken
; from $0468 (x) and $0480 (y) — so it can sail across screen
; boundaries; wipes itself when derendered (flags bit 7 clear) or when
; its y screen leaves zero
; =============================================================================
        lda     $0528,x                         ; B833 BD 28 05                 .(.
        bpl     LB872                           ; B836 10 3A                    .:
        lda     $0318,x                         ; B838 BD 18 03                 ...
        clc                                     ; B83B 18                       .
        adc     $03A8,x                         ; B83C 7D A8 03                 }..
        sta     $0318,x                         ; B83F 9D 18 03                 ...
        lda     $0330,x                         ; B842 BD 30 03                 .0.
        adc     $03C0,x                         ; B845 7D C0 03                 }..
        sta     $0330,x                         ; B848 9D 30 03                 .0.
        lda     $0348,x                         ; B84B BD 48 03                 .H.
        adc     $0468,x                         ; B84E 7D 68 04                 }h.
        sta     $0348,x                         ; B851 9D 48 03                 .H.
        lda     $0360,x                         ; B854 BD 60 03                 .`.
        clc                                     ; B857 18                       .
        adc     $03D8,x                         ; B858 7D D8 03                 }..
        sta     $0360,x                         ; B85B 9D 60 03                 .`.
        lda     $0378,x                         ; B85E BD 78 03                 .x.
        adc     $03F0,x                         ; B861 7D F0 03                 }..
        sta     $0378,x                         ; B864 9D 78 03                 .x.
        lda     $0390,x                         ; B867 BD 90 03                 ...
        adc     $0480,x                         ; B86A 7D 80 04                 }..
        sta     $0390,x                         ; B86D 9D 90 03                 ...
        beq     LB875                           ; B870 F0 03                    ..
LB872:  jsr     entity_wipe_x                           ; B872 20 C4 F2                  ..
LB875:  rts                                     ; B875 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $49 — collapse camera director (scripted vertical fall):
; arms a scroll handshake ($1E/$29/$23) and clears the event bitmap
; $05DC-$05DF, then once $1E clears it enables vscroll ($46) and the
; status IRQ split ($24/$25, $99/$9B); each externally-set bit of
; $05DC+ (indexed by step counter $0468) advances through the 3-byte
; records at LB9C0 — byte 1 packs the camera target ($F0 -> $FA, $0F ->
; $FB) — shaking the screen ($FC toggled for $2D frames) and then
; free-falling the camera (gravity on its own yvel) until it reaches
; the target; record 14 also clears the destroyed-block bitmap $0680;
; at step $1D the end state waits for the split to rise past $18 and
; hands the room over (IRQ mode 3, camera/mirroring reset)
; =============================================================================
        lda     #$80                            ; B876 A9 80                    ..
        sta     $1E                             ; B878 85 1E                    ..
        sta     $29                             ; B87A 85 29                    .)
        lda     #$04                            ; B87C A9 04                    ..
        sta     $23                             ; B87E 85 23                    .#
        lda     #$00                            ; B880 A9 00                    ..
        sta     $05DC                           ; B882 8D DC 05                 ...
        sta     $05DD                           ; B885 8D DD 05                 ...
        sta     $05DE                           ; B888 8D DE 05                 ...
        sta     $05DF                           ; B88B 8D DF 05                 ...
        lda     #$98                            ; B88E A9 98                    ..
        sta     $0588,x                         ; B890 9D 88 05                 ...
        lda     #$B8                            ; B893 A9 B8                    ..
        sta     $05A0,x                         ; B895 9D A0 05                 ...
        lda     $1E                             ; B898 A5 1E                    ..
        bne     LB875                           ; B89A D0 D9                    ..
        sta     $0360                           ; B89C 8D 60 03                 .`.
        inc     $46                             ; B89F E6 46                    .F
        lda     #$BF                            ; B8A1 A9 BF                    ..
        sta     $9B                             ; B8A3 85 9B                    ..
        lda     #$02                            ; B8A5 A9 02                    ..
        sta     $99                             ; B8A7 85 99                    ..
        lda     #$1D                            ; B8A9 A9 1D                    ..
        sta     $25                             ; B8AB 85 25                    .%
        lda     #$01                            ; B8AD A9 01                    ..
        sta     $24                             ; B8AF 85 24                    .$
        lda     #$BB                            ; B8B1 A9 BB                    ..
        sta     $0588,x                         ; B8B3 9D 88 05                 ...
        lda     #$B8                            ; B8B6 A9 B8                    ..
        sta     $05A0,x                         ; B8B8 9D A0 05                 ...
        lda     $0480,x                         ; B8BB BD 80 04                 ...
        pha                                     ; B8BE 48                       H
        jsr     LB96E                           ; B8BF 20 6E B9                  n.
        pla                                     ; B8C2 68                       h
        cmp     $0480,x                         ; B8C3 DD 80 04                 ...
        beq     LB875                           ; B8C6 F0 AD                    ..
        lda     #$40                            ; B8C8 A9 40                    .@
        sta     $04B0,x                         ; B8CA 9D B0 04                 ...
        sta     $03D8,x                         ; B8CD 9D D8 03                 ...
        lda     #$00                            ; B8D0 A9 00                    ..
        sta     $03F0,x                         ; B8D2 9D F0 03                 ...
        lda     #$E4                            ; B8D5 A9 E4                    ..
        sta     $0588,x                         ; B8D7 9D 88 05                 ...
        lda     #$B8                            ; B8DA A9 B8                    ..
        sta     $05A0,x                         ; B8DC 9D A0 05                 ...
        lda     #$2D                            ; B8DF A9 2D                    .-
        sta     $04C8,x                         ; B8E1 9D C8 04                 ...
        lda     $04C8,x                         ; B8E4 BD C8 04                 ...
        beq     LB8F3                           ; B8E7 F0 0A                    ..
        dec     $04C8,x                         ; B8E9 DE C8 04                 ...
        and     #$02                            ; B8EC 29 02                    ).
        sta     $FC                             ; B8EE 85 FC                    ..
        jmp     LB96E                           ; B8F0 4C 6E B9                 Ln.

; ----------------------------------------------------------------------------
LB8F3:  lda     $04B0,x                         ; B8F3 BD B0 04                 ...
        sec                                     ; B8F6 38                       8
        sbc     $03D8,x                         ; B8F7 FD D8 03                 ...
        sta     $04B0,x                         ; B8FA 9D B0 04                 ...
        lda     $FA                             ; B8FD A5 FA                    ..
        sbc     $03F0,x                         ; B8FF FD F0 03                 ...
        bcs     LB908                           ; B902 B0 04                    ..
        sbc     #$0F                            ; B904 E9 0F                    ..
        inc     $FB                             ; B906 E6 FB                    ..
LB908:  sta     $FA                             ; B908 85 FA                    ..
        jsr     entity_apply_gravity                           ; B90A 20 E1 E9                  ..
        lda     $FB                             ; B90D A5 FB                    ..
        cmp     $0498,x                         ; B90F DD 98 04                 ...
        bcc     LB942                           ; B912 90 2E                    ..
        bne     LB91D                           ; B914 D0 07                    ..
        lda     $0480,x                         ; B916 BD 80 04                 ...
        cmp     $FA                             ; B919 C5 FA                    ..
        bcc     LB942                           ; B91B 90 25                    .%
LB91D:  lda     $0480,x                         ; B91D BD 80 04                 ...
        sta     $FA                             ; B920 85 FA                    ..
        lda     $0498,x                         ; B922 BD 98 04                 ...
        sta     $FB                             ; B925 85 FB                    ..
        lda     #$BB                            ; B927 A9 BB                    ..
        sta     $0588,x                         ; B929 9D 88 05                 ...
        lda     #$B8                            ; B92C A9 B8                    ..
        sta     $05A0,x                         ; B92E 9D A0 05                 ...
        lda     $0468,x                         ; B931 BD 68 04                 .h.
        cmp     #$1D                            ; B934 C9 1D                    ..
        bne     LB942                           ; B936 D0 0A                    ..
        lda     #$43                            ; B938 A9 43                    .C
        sta     $0588,x                         ; B93A 9D 88 05                 ...
        lda     #$B9                            ; B93D A9 B9                    ..
        sta     $05A0,x                         ; B93F 9D A0 05                 ...
LB942:  rts                                     ; B942 60                       `

; ----------------------------------------------------------------------------
        lda     $25                             ; B943 A5 25                    .%
        cmp     #$18                            ; B945 C9 18                    ..
        bcs     LB942                           ; B947 B0 F9                    ..
        lda     #$03                            ; B949 A9 03                    ..
        sta     $24                             ; B94B 85 24                    .$
        lda     #$00                            ; B94D A9 00                    ..
        sta     $2B                             ; B94F 85 2B                    .+
        sta     $2A                             ; B951 85 2A                    .*
        sta     $25                             ; B953 85 25                    .%
        sta     $FB                             ; B955 85 FB                    ..
        lda     #$22                            ; B957 A9 22                    ."
        sta     $29                             ; B959 85 29                    .)
        lda     #$01                            ; B95B A9 01                    ..
        sta     $28                             ; B95D 85 28                    .(
        lda     #$02                            ; B95F A9 02                    ..
        sta     $F9                             ; B961 85 F9                    ..
        sta     $0348                           ; B963 8D 48 03                 .H.
        sta     $0348,x                         ; B966 9D 48 03                 .H.
        lda     #$01                            ; B969 A9 01                    ..
        jmp     set_mirroring                           ; B96B 4C B7 FF                 L..

; ----------------------------------------------------------------------------
LB96E:  lda     $0468,x                         ; B96E BD 68 04                 .h.
        pha                                     ; B971 48                       H
        and     #$07                            ; B972 29 07                    ).
        tay                                     ; B974 A8                       .
        lda     $F2B2,y                         ; B975 B9 B2 F2                 ...
        sta     L0000                           ; B978 85 00                    ..
        pla                                     ; B97A 68                       h
        lsr     a                               ; B97B 4A                       J
        lsr     a                               ; B97C 4A                       J
        lsr     a                               ; B97D 4A                       J
        tay                                     ; B97E A8                       .
        lda     $05DC,y                         ; B97F B9 DC 05                 ...
        and     L0000                           ; B982 25 00                    %.
        beq     LB9AF                           ; B984 F0 29                    .)
        lda     $0468,x                         ; B986 BD 68 04                 .h.
        asl     a                               ; B989 0A                       .
        adc     $0468,x                         ; B98A 7D 68 04                 }h.
        inc     $0468,x                         ; B98D FE 68 04                 .h.
        tay                                     ; B990 A8                       .
        lda     LB9C0,y                         ; B991 B9 C0 B9                 ...
        and     #$F0                            ; B994 29 F0                    ).
        cmp     $FA                             ; B996 C5 FA                    ..
        beq     LB96E                           ; B998 F0 D4                    ..
        sta     $0480,x                         ; B99A 9D 80 04                 ...
        lda     LB9C0,y                         ; B99D B9 C0 B9                 ...
        and     #$0F                            ; B9A0 29 0F                    ).
        sta     $0498,x                         ; B9A2 9D 98 04                 ...
        cpy     #$2A                            ; B9A5 C0 2A                    .*
        bne     LB96E                           ; B9A7 D0 C5                    ..
        jsr     LB9B0                           ; B9A9 20 B0 B9                  ..
        jmp     LB96E                           ; B9AC 4C 6E B9                 Ln.

; ----------------------------------------------------------------------------
LB9AF:  rts                                     ; B9AF 60                       `

; ----------------------------------------------------------------------------
LB9B0:  ldy     #$1F                            ; B9B0 A0 1F                    ..
        lda     #$00                            ; B9B2 A9 00                    ..
LB9B4:  sta     $0680,y                         ; B9B4 99 80 06                 ...
        dey                                     ; B9B7 88                       .
        bpl     LB9B4                           ; B9B8 10 FA                    ..
        rts                                     ; B9BA 60                       `

; ----------------------------------------------------------------------------
LB9BB:  .byte   $00,$24,$4E                     ; B9BB
LB9BE:  .byte   $B0                             ; B9BE
LB9BF:  .byte   $A8                             ; B9BF
LB9C0:  .byte   $E1,$A0,$A8,$D1,$90,$A8,$B1,$70,$88,$B1,$70,$48,$A1,$60,$88,$A1 ; B9C0
        .byte   $60,$48,$91,$50,$88,$91,$50,$48,$71,$30,$C8,$61,$20,$C8,$51,$10 ; B9D0
        .byte   $C8,$31,$E1,$68,$21,$D1,$68,$11,$C1,$68,$01,$B1,$68,$E2,$A1,$68 ; B9E0
        .byte   $D2,$91,$68,$C2,$81,$68,$B2,$71,$68,$A2,$61,$68,$82,$41,$28,$72 ; B9F0
        .byte   $31,$28,$62,$21,$28,$52,$11,$28,$42,$01,$28,$32,$E2,$28,$22,$D2 ; BA00
        .byte   $28,$12,$C2,$28,$02,$00,$00,$00 ; BA10
LBA18:  .byte   $00,$0C,$1A                     ; BA18
LBA1B:  .byte   $65,$65,$6D,$65,$65,$65,$65,$6D,$6D,$65,$65,$6D,$65,$65,$65,$65 ; BA1B
        .byte   $65,$65,$65,$65,$6D,$65,$65,$65,$65,$65,$65,$65,$6D,$65,$65,$65 ; BA2B
; =============================================================================
; BEHAVIOR type $4D — victory weapon-energy orb: converges on the
; player (state $0F ceremony)
; =============================================================================
        lda     $0468,x                         ; BA3B BD 68 04
        bne     LBA6B                           ; BA3E D0 2B                    .+
        dec     $0498,x                         ; BA40 DE 98 04                 ...
        bne     LBA48                           ; BA43 D0 03                    ..
        jmp     entity_wipe_x                           ; BA45 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LBA48:  dec     $0480,x                         ; BA48 DE 80 04                 ...
        lda     $0480,x                         ; BA4B BD 80 04                 ...
        and     #$0F                            ; BA4E 29 0F                    ).
        tay                                     ; BA50 A8                       .
        lda     #$30                            ; BA51 A9 30                    .0
        jsr     entity_set_dir_velocity                           ; BA53 20 70 F4                  p.
        asl     $03A8,x                         ; BA56 1E A8 03                 ...
        rol     $03C0,x                         ; BA59 3E C0 03                 >..
        asl     $03D8,x                         ; BA5C 1E D8 03                 ...
        rol     $03F0,x                         ; BA5F 3E F0 03                 >..
        ldy     $0498,x                         ; BA62 BC 98 04                 ...
        lda     LBA75,y                         ; BA65 B9 75 BA                 .u.
        sta     $0468,x                         ; BA68 9D 68 04                 .h.
LBA6B:  jsr     entity_facing_dispatch                           ; BA6B 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; BA6E 20 86 EA                  ..
        dec     $0468,x                         ; BA71 DE 68 04                 .h.
        rts                                     ; BA74 60                       `

; ----------------------------------------------------------------------------
LBA75:  .byte   $03,$03,$02,$02,$02,$02,$03,$03 ; BA75
; =============================================================================
; BEHAVIOR type $4C — disappearing-block sequencer (yoku blocks): after
; a $3C-frame lead-in, spawns waves of type $01 sub_type $B9 blocks
; (sound $39, flags $02 = solid platform) at positions from the 3-byte
; records at LBAF6/LBAF7/LBAF8 (x, y, continuation: 1 = next block in
; the same wave, 0 = wave done, $FF = restart the loop from the saved
; offset); one wave every $3C frames, with the pattern's start offset
; chosen by parameter $0348 via the LBAE3 table
; =============================================================================
        inc     $0468,x                         ; BA7D FE 68 04                 .h.
        lda     $0468,x                         ; BA80 BD 68 04                 .h.
        cmp     #$3C                            ; BA83 C9 3C                    .<
        bne     LBAF3                           ; BA85 D0 6C                    .l
        lda     #$9D                            ; BA87 A9 9D                    ..
        sta     $0588,x                         ; BA89 9D 88 05                 ...
        lda     #$BA                            ; BA8C A9 BA                    ..
        sta     $05A0,x                         ; BA8E 9D A0 05                 ...
        ldy     $0348,x                         ; BA91 BC 48 03                 .H.
        lda     LBAE3,y                         ; BA94 B9 E3 BA                 ...
        sta     $0480,x                         ; BA97 9D 80 04                 ...
        sta     $0498,x                         ; BA9A 9D 98 04                 ...
        lda     $0468,x                         ; BA9D BD 68 04                 .h.
        bne     LBAF0                           ; BAA0 D0 4E                    .N
        lda     #$3C                            ; BAA2 A9 3C                    .<
        sta     $0468,x                         ; BAA4 9D 68 04                 .h.
LBAA7:  jsr     find_free_slot_y                           ; BAA7 20 6F F1                  o.
        bcs     LBAD7                           ; BAAA B0 2B                    .+
        lda     #$39                            ; BAAC A9 39                    .9
        jsr     queue_sound                           ; BAAE 20 5D EC                  ].
        lda     #$B9                            ; BAB1 A9 B9                    ..
        jsr     entity_init_pos                           ; BAB3 20 A4 EA                  ..
        lda     #$01                            ; BAB6 A9 01                    ..
        sta     $0300,y                         ; BAB8 99 00 03                 ...
        lda     #$00                            ; BABB A9 00                    ..
        sta     $0408,y                         ; BABD 99 08 04                 ...
        lda     #$02                            ; BAC0 A9 02                    ..
        sta     $0528,y                         ; BAC2 99 28 05                 .(.
        lda     $0480,x                         ; BAC5 BD 80 04                 ...
        tax                                     ; BAC8 AA                       .
        lda     LBAF6,x                         ; BAC9 BD F6 BA                 ...
        sta     $0330,y                         ; BACC 99 30 03                 .0.
        lda     LBAF7,x                         ; BACF BD F7 BA                 ...
        sta     $0378,y                         ; BAD2 99 78 03                 .x.
        ldx     $A6                             ; BAD5 A6 A6                    ..
LBAD7:  ldy     $0480,x                         ; BAD7 BC 80 04                 ...
        inc     $0480,x                         ; BADA FE 80 04                 ...
        inc     $0480,x                         ; BADD FE 80 04                 ...
        inc     $0480,x                         ; BAE0 FE 80 04                 ...
LBAE3:  lda     LBAF8,y                         ; BAE3 B9 F8 BA                 ...
        beq     LBAF0                           ; BAE6 F0 08                    ..
        bpl     LBAA7                           ; BAE8 10 BD                    ..
        lda     $0498,x                         ; BAEA BD 98 04                 ...
        sta     $0480,x                         ; BAED 9D 80 04                 ...
LBAF0:  dec     $0468,x                         ; BAF0 DE 68 04                 .h.
LBAF3:  rts                                     ; BAF3 60                       `

; ----------------------------------------------------------------------------
        .byte   $00,$24                         ; BAF4
LBAF6:  .byte   $38                             ; BAF6
LBAF7:  .byte   $98                             ; BAF7
LBAF8:  .byte   $01,$98,$B8,$00,$38,$68,$01,$78,$A8,$00,$48,$A8,$01,$98,$78,$00 ; BAF8
        .byte   $68,$A8,$01,$78,$68,$00,$38,$98,$01,$88,$88,$00,$58,$98,$01,$68 ; BB08
        .byte   $68,$FF,$58,$A8,$01,$68,$68,$00,$88,$A8,$01,$C8,$78,$00,$78,$68 ; BB18
        .byte   $01,$B8,$B8,$00,$58,$98,$01,$A8,$B8,$00,$88,$B8,$00,$88,$78,$01 ; BB28
        .byte   $A8,$B8,$FF                     ; BB38
; =============================================================================
; BEHAVIOR type $B1 — attachment node: pins itself to the entity in
; slot $0468, copying its x and sitting $0480 px below its y each frame
; =============================================================================
        ldy     $0468,x                         ; BB3B BC 68 04                 .h.
        lda     $0378,y                         ; BB3E B9 78 03                 .x.
        clc                                     ; BB41 18                       .
        adc     $0480,x                         ; BB42 7D 80 04                 }..
        sta     $0378,x                         ; BB45 9D 78 03                 .x.
        lda     $0330,y                         ; BB48 B9 30 03                 .0.
        sta     $0330,x                         ; BB4B 9D 30 03                 .0.
        rts                                     ; BB4E 60                       `

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00 ; BB4F
        .byte   $00,$08,$00,$00,$22,$08,$01,$08,$10,$02,$00,$00,$10,$00,$21,$00 ; BB5F
        .byte   $09,$00,$00,$00,$40             ; BB6F

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$88,$00,$20,$08,$00,$80,$00,$00,$00,$00,$00 ; BB74
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BB84
        .byte   $20,$00,$00,$00,$00,$00,$00,$01,$20,$00,$00,$00,$00,$00,$00,$00 ; BB94
        .byte   $00,$20,$00,$80,$08,$00,$00,$04,$88,$A0,$00,$40 ; BBA4

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$01,$00,$00,$02,$00 ; BBB0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BBC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$40 ; BBD0

; ----------------------------------------------------------------------------
        .byte   $00,$82,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00,$04,$00,$00 ; BBD8
        .byte   $00,$82,$00,$00,$00,$60         ; BBE8

; ----------------------------------------------------------------------------
        .byte   $20,$01,$80,$00,$00,$25,$00,$02,$00,$00,$00,$00,$00,$00,$08,$00 ; BBEE
        .byte   $00,$10,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00 ; BBFE
        .byte   $00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC0E
        .byte   $00,$10,$00,$00,$00,$00,$00,$00,$04,$01,$00,$00,$00,$00,$60 ; BC1E

; ----------------------------------------------------------------------------
        .byte   $00,$04,$00,$41,$01,$08,$00,$00,$10,$01,$00,$00,$00,$00,$00,$00 ; BC2D
        .byte   $01,$20,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC3D
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC4D
        .byte   $00,$00,$00,$80,$00,$00,$00,$01,$00,$0A,$04,$18,$01,$A1,$00,$20 ; BC5D
        .byte   $00,$01,$00,$07,$00,$00,$00,$00,$44,$08,$04,$20,$01,$08,$00,$08 ; BC6D
        .byte   $00,$02,$50,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC7D
        .byte   $00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC8D
        .byte   $00,$00,$00,$01,$00,$10,$00,$00,$00,$02,$14,$08,$00,$00,$00,$00 ; BC9D
        .byte   $00,$08,$01,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00 ; BCAD
        .byte   $00,$00,$40                     ; BCBD

; ----------------------------------------------------------------------------
        .byte   $08,$00,$00,$01,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00 ; BCC0
        .byte   $00,$00,$00,$10,$20,$00,$02,$00,$00,$00,$18,$00,$00,$00,$00,$00 ; BCD0
        .byte   $08,$10,$00,$00,$40             ; BCE0

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$01,$09,$40     ; BCE5

; ----------------------------------------------------------------------------
        .byte   $20,$00,$00,$00,$20,$00,$08,$00,$08,$00,$80,$00,$11,$01,$15,$01 ; BCEC
        .byte   $00,$00,$20,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BCFC
        .byte   $80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00 ; BD0C
        .byte   $01,$00,$02,$00,$00,$00,$00,$00,$02,$00,$00,$01,$02,$00,$00,$00 ; BD1C
        .byte   $00,$00,$00,$10,$00,$00,$00,$00,$20,$41,$81,$04,$00,$00,$00,$00 ; BD2C
        .byte   $00,$10,$00,$00,$00,$00,$00,$00,$40 ; BD3C

; ----------------------------------------------------------------------------
        .byte   $00,$00,$04,$00,$00,$00,$00,$02,$01,$00,$00,$04,$00,$00,$00,$00 ; BD45
        .byte   $00,$04,$00,$00,$00,$08,$00,$00,$00,$00,$01,$08,$00,$00,$00,$00 ; BD55
        .byte   $10,$04,$00,$00,$00,$00,$00,$90,$40,$00,$40 ; BD65

; ----------------------------------------------------------------------------
        .byte   $20,$00,$00,$00,$00,$00,$00,$10,$C0,$00,$00,$00,$00,$00,$04,$01 ; BD70
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BD80
        .byte   $00,$00,$00,$00,$40             ; BD90

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$12,$00,$00,$10,$00 ; BD95
        .byte   $00,$80,$00,$00,$00,$C0,$40,$00,$00,$04,$10,$20,$10,$20,$14,$A0 ; BDA5
        .byte   $00,$08,$00,$40                 ; BDB5

; ----------------------------------------------------------------------------
        .byte   $00,$10,$00,$02,$01,$82,$40     ; BDB9

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00 ; BDC0
        .byte   $00,$00,$40                     ; BDD0

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$20,$00,$08,$00,$00 ; BDD3
        .byte   $00,$00,$00,$0A,$00,$A0,$00,$00,$10,$0E,$00,$00,$04,$00,$00,$08 ; BDE3
        .byte   $01,$00,$00,$20,$00,$00,$00,$00,$04,$18,$01,$48,$51,$00,$00,$00 ; BDF3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE03
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$0A ; BE13
        .byte   $00,$00,$00,$80,$00,$00,$00,$00,$00,$20,$00,$00,$04,$00,$10,$00 ; BE23
        .byte   $00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$01,$00,$00,$00 ; BE33
        .byte   $00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$40 ; BE43

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00 ; BE4E
        .byte   $01,$00,$00,$00,$00,$00,$00,$00,$01,$10,$01,$00,$81,$14,$00,$00 ; BE5E
        .byte   $10,$00,$84,$05,$84,$00,$88,$00,$20,$00,$40,$00,$01,$00,$80,$11 ; BE6E
        .byte   $00,$01,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00 ; BE7E
        .byte   $00,$00,$00,$00,$00,$00,$40     ; BE8E

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00 ; BE95
        .byte   $04,$00,$00,$40                 ; BEA5

; ----------------------------------------------------------------------------
        rti                                     ; BEA9 40                       @

; ----------------------------------------------------------------------------
        .byte   $80,$00,$00,$00,$00,$00,$40     ; BEAA

; ----------------------------------------------------------------------------
        .byte   $04                             ; BEB1 04                       .
        rti                                     ; BEB2 40                       @

; ----------------------------------------------------------------------------
        .byte   $01,$42,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00 ; BEB3
        .byte   $00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$40 ; BEC3

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$40     ; BED0

; ----------------------------------------------------------------------------
        rti                                     ; BED7 40                       @

; ----------------------------------------------------------------------------
        .byte   $00,$00,$01,$00,$00,$04,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00 ; BED8
        .byte   $00,$00,$40                     ; BEE8

; ----------------------------------------------------------------------------
        .byte   $00,$82,$00,$80,$00,$11,$40,$49,$00,$00,$00,$40 ; BEEB

; ----------------------------------------------------------------------------
        .byte   $04,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$20,$01,$00,$00,$00 ; BEF7
        .byte   $00,$00,$00,$40                 ; BF07

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$40     ; BF0B

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00 ; BF12
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40 ; BF22

; ----------------------------------------------------------------------------
        .byte   $04,$01,$04,$00,$00,$01,$00,$01,$00,$00,$00,$00,$04,$00,$00,$00 ; BF2D
        .byte   $00,$00,$11,$00,$00,$04,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00 ; BF3D
        .byte   $00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00 ; BF4D
        .byte   $00,$00,$01,$00,$00,$00,$00,$E0,$04,$00,$00,$01,$01,$04,$00,$01 ; BF5D
        .byte   $01,$08,$00,$00,$00,$00,$04,$04,$00,$21,$00,$00,$00,$41,$00,$02 ; BF6D
        .byte   $00,$00,$40                     ; BF7D

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00 ; BF80
        .byte   $00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$40 ; BF90

; ----------------------------------------------------------------------------
        .byte   $00,$00,$10,$04,$00,$00,$00,$00,$00,$80,$00,$40 ; BF9D

; ----------------------------------------------------------------------------
        .byte   $00,$80,$00,$20,$00,$00,$00,$00,$00,$00,$10,$10,$00,$44,$00,$40 ; BFA9

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$01,$15,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BFB9
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$01,$04,$00,$00,$00,$40 ; BFC9

; ----------------------------------------------------------------------------
        .byte   $00,$00,$10,$80,$04,$C0,$00,$04,$01,$2D,$00,$00,$04,$08,$00,$00 ; BFD7
        .byte   $00,$01,$00,$80,$00,$00,$01,$21,$00,$00,$14,$00,$00,$09,$00,$00 ; BFE7
        .byte   $00,$40                         ; BFF7

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$04,$00     ; BFF9
