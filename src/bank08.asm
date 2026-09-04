.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK08"

; =============================================================================
; BANK $08 (mapped at $A000) — NAPALM/STAR MAN AI, PICKUP SWEEP + PROTO
; CASTLE 1 STAGE DATA
; Data half (file +$0900 on): stage $08 (Proto castle 1) stage data —
; screen table at $A900 with this bank at $A000; format in
; DATA_REFERENCE.md section 11.
; =============================================================================
L0000           := $0000
L00FF           := $00FF
L1624           := $1624
L20A6           := $20A6
L2221           := $2221
L2821           := $2821
L3E2D           := $3E2D
L4240           := $4240
L425B           := $425B
L4C3F           := $4C3F
L4D3F           := $4D3F
L4F00           := $4F00
L546E           := $546E
L604D           := $604D
L8080           := $8080
L850B           := $850B
L851A           := $851A
L8541           := $8541
L8550           := $8550
L8592           := $8592
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $89 — NAPALM MAN (boss of stage $06). By range: close
; (< $50 px, sub $35 -> $A0E0) he fires TWO type $8B napalm bombs in
; arcs (presets $36, dirs staggered, aim tweak via $1C:8550); far
; (sub $34) he launches a type $8A missile from the shoulder ($A07C,
; preset $39, level flight) — then hops half the distance toward the
; player (arc $1C:8592, sub $33, $A03E), pausing $0A frames after
; every third volley ($A06D). $A152: after his bombs clear, another
; full-distance hop.
; =============================================================================
        jsr     entity_x_dist_px                           ; A000 20 94 EC                  ..
        cmp     #$50                            ; A003 C9 50                    .P
        bcs     LA019                           ; A005 B0 12                    ..
        lda     #$35                            ; A007 A9 35                    .5
        jsr     entity_set_subtype                           ; A009 20 98 EA                  ..
        lda     #$E0                            ; A00C A9 E0                    ..
        sta     $0588,x                         ; A00E 9D 88 05                 ...
        lda     #$A0                            ; A011 A9 A0                    ..
        sta     $05A0,x                         ; A013 9D A0 05                 ...
        jmp     LA0E0                           ; A016 4C E0 A0                 L..

; ----------------------------------------------------------------------------
LA019:  lda     #$34                            ; A019 A9 34                    .4
        jsr     entity_set_subtype                           ; A01B 20 98 EA                  ..
        lda     #$2D                            ; A01E A9 2D                    .-
        sta     $0588,x                         ; A020 9D 88 05
        lda     #$A0                            ; A023 A9 A0
        sta     $05A0,x                         ; A025 9D A0 05 behavior PC := $A028
        lda     #$03                            ; A028 A9 03                    ..
        sta     $0480,x                         ; A02A 9D 80 04                 ...
        jsr     entity_set_facing                           ; A02D 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A030 20 30 EC                  0.
        lda     $04B0,x                         ; A033 BD B0 04                 ...
        beq     LA05B                           ; A036 F0 23                    .#
        dec     $04B0,x                         ; A038 DE B0 04                 ...
        beq     LA03E                           ; A03B F0 01                    ..
        rts                                     ; A03D 60                       `

; ----------------------------------------------------------------------------
LA03E:  lda     #$AC                            ; A03E A9 AC                    ..
        sta     $0588,x                         ; A040 9D 88 05                 ...
        lda     #$A0                            ; A043 A9 A0                    ..
        sta     $05A0,x                         ; A045 9D A0 05                 ...
        jsr     entity_x_dist_px                           ; A048 20 94 EC                  ..
        lsr     a                               ; A04B 4A                       J
        sta     $01                             ; A04C 85 01                    ..
        ldy     #$02                            ; A04E A0 02                    ..
        jsr     L8592                           ; A050 20 92 85                  ..
        lda     #$33                            ; A053 A9 33                    .3
        jsr     entity_set_subtype                           ; A055 20 98 EA                  ..
        jmp     LA0AC                           ; A058 4C AC A0                 L..

; ----------------------------------------------------------------------------
LA05B:  lda     $0570,x                         ; A05B BD 70 05                 .p.
        cmp     #$02                            ; A05E C9 02                    ..
        bne     LA0AB                           ; A060 D0 49                    .I
        lda     $0540,x                         ; A062 BD 40 05                 .@.
        cmp     #$05                            ; A065 C9 05                    ..
        beq     LA07C                           ; A067 F0 13                    ..
        cmp     #$0B                            ; A069 C9 0B                    ..
        bne     LA0AB                           ; A06B D0 3E                    .>
        dec     $0480,x                         ; A06D DE 80 04                 ...
        bne     LA0AB                           ; A070 D0 39                    .9
        lda     #$0A                            ; A072 A9 0A                    ..
        sta     $04B0,x                         ; A074 9D B0 04                 ...
        lda     #$32                            ; A077 A9 32                    .2
        jmp     entity_set_subtype                           ; A079 4C 98 EA                 L..

; ----------------------------------------------------------------------------
LA07C:  stx     $0F                             ; A07C 86 0F                    ..
        jsr     find_free_slot_y                           ; A07E 20 6F F1                  o.
        bcs     LA0AB                           ; A081 B0 28                    .(
        lda     #$A3                            ; A083 A9 A3                    ..
        sta     $0408,y                         ; A085 99 08 04                 ...
        lda     #$8A                            ; A088 A9 8A                    ..
        sta     $0300,y                         ; A08A 99 00 03                 ...
        lda     $0420,x                         ; A08D BD 20 04                 . .
        sta     $0420,y                         ; A090 99 20 04                 . .
        and     #$01                            ; A093 29 01                    ).
        clc                                     ; A095 18                       .
        adc     #$46                            ; A096 69 46                    iF
        sta     $10                             ; A098 85 10                    ..
        lda     #$39                            ; A09A A9 39                    .9
        jsr     entity_speed_preset                           ; A09C 20 F5 EA                  ..
        lda     #$00                            ; A09F A9 00                    ..
        sta     $03A8,y                         ; A0A1 99 A8 03                 ...
        lda     #$03                            ; A0A4 A9 03                    ..
        sta     $03C0,y                         ; A0A6 99 C0 03                 ...
        ldx     $0F                             ; A0A9 A6 0F                    ..
LA0AB:  rts                                     ; A0AB 60                       `

; ----------------------------------------------------------------------------
LA0AC:  lda     $0540,x                         ; A0AC BD 40 05                 .@.
        beq     LA0AB                           ; A0AF F0 FA                    ..
        lda     $0540,x                         ; A0B1 BD 40 05                 .@.
        cmp     #$02                            ; A0B4 C9 02                    ..
        beq     LA0CE                           ; A0B6 F0 16                    ..
        lda     #$00                            ; A0B8 A9 00                    ..
        sta     $0570,x                         ; A0BA 9D 70 05                 .p.
        ldy     #$1C                            ; A0BD A0 1C                    ..
        jsr     entity_gravity_collide                           ; A0BF 20 B7 E7                  ..
        bcs     LA0C9                           ; A0C2 B0 05                    ..
        ldy     #$1E                            ; A0C4 A0 1E                    ..
        jmp     entity_horiz_dispatch                           ; A0C6 4C 3F EA                 L?.

; ----------------------------------------------------------------------------
LA0C9:  lda     #$02                            ; A0C9 A9 02                    ..
        sta     $0540,x                         ; A0CB 9D 40 05                 .@.
LA0CE:  lda     $0570,x                         ; A0CE BD 70 05                 .p.
        cmp     #$08                            ; A0D1 C9 08                    ..
        bne     LA0DF                           ; A0D3 D0 0A                    ..
        lda     #$00                            ; A0D5 A9 00                    ..
        sta     $0588,x                         ; A0D7 9D 88 05                 ...
        lda     #$A0                            ; A0DA A9 A0                    ..
        sta     $05A0,x                         ; A0DC 9D A0 05                 ...
LA0DF:  rts                                     ; A0DF 60                       `

; ----------------------------------------------------------------------------
LA0E0:  jsr     entity_set_facing                           ; A0E0 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A0E3 20 30 EC                  0.
        lda     $0570,x                         ; A0E6 BD 70 05                 .p.
        cmp     #$08                            ; A0E9 C9 08                    ..
        bne     LA0DF                           ; A0EB D0 F2                    ..
        lda     $0540,x                         ; A0ED BD 40 05                 .@.
        beq     LA105                           ; A0F0 F0 13                    ..
        cmp     #$02                            ; A0F2 C9 02                    ..
        bne     LA0DF                           ; A0F4 D0 E9                    ..
        lda     #$52                            ; A0F6 A9 52                    .R
        sta     $0588,x                         ; A0F8 9D 88 05                 ...
        lda     #$A1                            ; A0FB A9 A1                    ..
        sta     $05A0,x                         ; A0FD 9D A0 05                 ...
        lda     #$32                            ; A100 A9 32                    .2
        jmp     entity_set_subtype                           ; A102 4C 98 EA                 L..

; ----------------------------------------------------------------------------
LA105:  stx     $0F                             ; A105 86 0F                    ..
        lda     #$01                            ; A107 A9 01                    ..
        sta     $0E                             ; A109 85 0E                    ..
        lda     $0420,x                         ; A10B BD 20 04                 . .
        and     #$02                            ; A10E 29 02                    ).
        clc                                     ; A110 18                       .
        adc     #$48                            ; A111 69 48                    iH
        sta     $0D                             ; A113 85 0D                    ..
LA115:  jsr     find_free_slot_y                           ; A115 20 6F F1                  o.
        bcs     LA0DF                           ; A118 B0 C5                    ..
        lda     #$85                            ; A11A A9 85                    ..
        sta     $0408,y                         ; A11C 99 08 04                 ...
        lda     #$8B                            ; A11F A9 8B                    ..
        sta     $0300,y                         ; A121 99 00 03                 ...
        lda     $0420,x                         ; A124 BD 20 04                 . .
        sta     $0420,y                         ; A127 99 20 04                 . .
        lda     $0D                             ; A12A A5 0D                    ..
        clc                                     ; A12C 18                       .
        adc     $0E                             ; A12D 65 0E                    e.
        sta     $10                             ; A12F 85 10                    ..
        lda     #$36                            ; A131 A9 36                    .6
        jsr     entity_speed_preset                           ; A133 20 F5 EA                  ..
        tya                                     ; A136 98                       .
        tax                                     ; A137 AA                       .
        jsr     entity_x_dist_px                           ; A138 20 94 EC                  ..
        cmp     #$20                            ; A13B C9 20                    . 
        bcc     LA146                           ; A13D 90 07                    ..
        ldy     $0E                             ; A13F A4 0E                    ..
        bne     LA146                           ; A141 D0 03                    ..
        sec                                     ; A143 38                       8
        sbc     #$20                            ; A144 E9 20                    . 
LA146:  ldy     #$00                            ; A146 A0 00                    ..
        jsr     L8550                           ; A148 20 50 85                  P.
        ldx     $0F                             ; A14B A6 0F                    ..
        dec     $0E                             ; A14D C6 0E                    ..
        bpl     LA115                           ; A14F 10 C4                    ..
        rts                                     ; A151 60                       `

; ----------------------------------------------------------------------------
        ldy     #$17                            ; A152 A0 17                    ..
LA154:  lda     $0300,y                         ; A154 B9 00 03                 ...
        cmp     #$8B                            ; A157 C9 8B                    ..
        beq     LA184                           ; A159 F0 29                    .)
        dey                                     ; A15B 88                       .
        cpy     #$07                            ; A15C C0 07                    ..
        bcs     LA154                           ; A15E B0 F4                    ..
        jsr     entity_set_facing                           ; A160 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A163 20 30 EC                  0.
        lda     #$33                            ; A166 A9 33                    .3
        jsr     entity_set_subtype                           ; A168 20 98 EA                  ..
        lda     #$01                            ; A16B A9 01                    ..
        sta     $0468,x                         ; A16D 9D 68 04                 .h.
        lda     #$AC                            ; A170 A9 AC                    ..
        sta     $0588,x                         ; A172 9D 88 05                 ...
        lda     #$A0                            ; A175 A9 A0                    ..
        sta     $05A0,x                         ; A177 9D A0 05                 ...
        jsr     entity_x_dist_px                           ; A17A 20 94 EC                  ..
        sta     $01                             ; A17D 85 01                    ..
        ldy     #$00                            ; A17F A0 00                    ..
        jsr     L8592                           ; A181 20 92 85                  ..
LA184:  rts                                     ; A184 60                       `

; ----------------------------------------------------------------------------
        .byte   $00,$02,$03,$04,$00,$0E,$0D,$0C ; A185  (unreferenced)
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $8A — napalm missile: level homing shot; on player
; contact becomes a type $8C blast (sub $42).
; =============================================================================
        jsr     entity_facing_dispatch                           ; A18D 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A190 20 86 EA                  ..
        jsr     entity_player_collide                           ; A193 20 87 EF                  ..
        bcs     LA184                           ; A196 B0 EC                    ..
        jsr     entity_wipe_x                           ; A198 20 C4 F2                  ..
        lda     #$80                            ; A19B A9 80                    ..
        sta     $0408,x                         ; A19D 9D 08 04                 ...
        lda     #$8C                            ; A1A0 A9 8C                    ..
        sta     $0300,x                         ; A1A2 9D 00 03                 ...
        lda     #$42                            ; A1A5 A9 42                    .B
        jmp     entity_set_subtype                           ; A1A7 4C 98 EA                 L..

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $8B — napalm bomb: ballistic arc, rolls on landing;
; on impact or player contact becomes a type $BC big blast (sub $42).
; =============================================================================
        ldy     #$13                            ; A1AA A0 13                    ..
        jsr     entity_gravity_collide                           ; A1AC 20 B7 E7                  ..
        bcs     LA1BB                           ; A1AF B0 0A                    ..
        ldy     #$1A                            ; A1B1 A0 1A                    ..
        jsr     entity_horiz_dispatch                           ; A1B3 20 3F EA                  ?.
        jsr     entity_player_collide                           ; A1B6 20 87 EF                  ..
        bcs     LA184                           ; A1B9 B0 C9                    ..
LA1BB:  jsr     entity_wipe_x                           ; A1BB 20 C4 F2                  ..
        lda     #$8B                            ; A1BE A9 8B                    ..
        sta     $0408,x                         ; A1C0 9D 08 04                 ...
        lda     #$BC                            ; A1C3 A9 BC                    ..
        sta     $0300,x                         ; A1C5 9D 00 03                 ...
        lda     #$42                            ; A1C8 A9 42                    .B
        jsr     entity_set_subtype                           ; A1CA 20 98 EA                  ..
LA1CD:  rts                                     ; A1CD 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $8D — STAR MAN (boss of stage $04). First raises his
; type $8E Star Crash shield (cross-linked via $0468) and re-summons
; it (sub $3B pose, $A2FB) whenever it's gone. Jumps far (>= $50 px:
; full arc, $A288) or near (half arc, $A221) with floaty low-gravity
; falls (yvel 2, $A2CB); mid-rise with the shield up he may throw it
; (sub $3D, $A24C) — the shield launches itself at the player when it
; sees the pose ($A386). Landing chains through crouch poses.
; =============================================================================
        jsr     find_free_slot_y                           ; A1CE 20 6F F1                  o.
        bcs     LA184                           ; A1D1 B0 B1                    ..
        lda     #$8E                            ; A1D3 A9 8E                    ..
        sta     $0300,y                         ; A1D5 99 00 03                 ...
        lda     #$40                            ; A1D8 A9 40                    .@
        jsr     entity_init_pos                           ; A1DA 20 A4 EA                  ..
        lda     $0528,y                         ; A1DD B9 28 05                 .(.
        ora     #$08                            ; A1E0 09 08                    ..
        sta     $0528,y                         ; A1E2 99 28 05                 .(.
        txa                                     ; A1E5 8A                       .
        sta     $0468,y                         ; A1E6 99 68 04                 .h.
        tya                                     ; A1E9 98                       .
        sta     $0468,x                         ; A1EA 9D 68 04                 .h.
        jsr     entity_set_facing                           ; A1ED 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A1F0 20 30 EC                  0.
        lda     $0480,x                         ; A1F3 BD 80 04                 ...
        beq     LA202                           ; A1F6 F0 0A                    ..
        dec     $0480,x                         ; A1F8 DE 80 04                 ...
        bne     LA1CD                           ; A1FB D0 D0                    ..
        lda     #$3C                            ; A1FD A9 3C                    .<
        jsr     entity_set_subtype                           ; A1FF 20 98 EA                  ..
LA202:  jsr     entity_x_dist_px                           ; A202 20 94 EC                  ..
        sta     $01                             ; A205 85 01                    ..
        cmp     #$50                            ; A207 C9 50                    .P
        bcc     LA221                           ; A209 90 16                    ..
        ldy     #$00                            ; A20B A0 00                    ..
        tya                                     ; A20D 98                       .
        sta     $0498,x                         ; A20E 9D 98 04                 ...
        jsr     L8592                           ; A211 20 92 85                  ..
        lda     #$88                            ; A214 A9 88                    ..
        sta     $0588,x                         ; A216 9D 88 05                 ...
        lda     #$A2                            ; A219 A9 A2                    ..
        sta     $05A0,x                         ; A21B 9D A0 05                 ...
        jmp     LA288                           ; A21E 4C 88 A2                 L..

; ----------------------------------------------------------------------------
LA221:  ldy     #$03                            ; A221 A0 03                    ..
        tya                                     ; A223 98                       .
        sta     $0498,x                         ; A224 9D 98 04                 ...
        lsr     $01                             ; A227 46 01                    F.
        jsr     L8592                           ; A229 20 92 85                  ..
        lda     #$36                            ; A22C A9 36                    .6
        sta     $0588,x                         ; A22E 9D 88 05                 ...
        lda     #$A2                            ; A231 A9 A2                    ..
        sta     $05A0,x                         ; A233 9D A0 05                 ...
        lda     $0540,x                         ; A236 BD 40 05                 .@.
        beq     LA287                           ; A239 F0 4C                    .L
        lda     $03F0,x                         ; A23B BD F0 03                 ...
        bpl     LA28D                           ; A23E 10 4D                    .M
        adc     $E7                             ; A240 65 E7                    e.
        and     #$01                            ; A242 29 01                    ).
        bne     LA24C                           ; A244 D0 06                    ..
        jsr     LA275                           ; A246 20 75 A2                  u.
        jmp     LA28D                           ; A249 4C 8D A2                 L..

; ----------------------------------------------------------------------------
LA24C:  lda     #$3D                            ; A24C A9 3D                    .=
        jsr     entity_set_subtype                           ; A24E 20 98 EA                  ..
        lda     #$5B                            ; A251 A9 5B                    .[
        sta     $0588,x                         ; A253 9D 88 05                 ...
        lda     #$A2                            ; A256 A9 A2                    ..
        sta     $05A0,x                         ; A258 9D A0 05                 ...
        jsr     L850B                           ; A25B 20 0B 85                  ..
        ldy     $0468,x                         ; A25E BC 68 04                 .h.
        lda     $0300,y                         ; A261 B9 00 03                 ...
        cmp     #$8E                            ; A264 C9 8E                    ..
        bne     LA275                           ; A266 D0 0D                    ..
        lda     $0540,x                         ; A268 BD 40 05                 .@.
        cmp     #$0C                            ; A26B C9 0C                    ..
        bne     LA287                           ; A26D D0 18                    ..
        lda     #$00                            ; A26F A9 00                    ..
        sta     $0570,x                         ; A271 9D 70 05                 .p.
        rts                                     ; A274 60                       `

; ----------------------------------------------------------------------------
LA275:  lda     #$3C                            ; A275 A9 3C                    .<
        jsr     entity_set_subtype                           ; A277 20 98 EA                  ..
        inc     $0540,x                         ; A27A FE 40 05                 .@.
        lda     #$8D                            ; A27D A9 8D                    ..
        sta     $0588,x                         ; A27F 9D 88 05                 ...
        lda     #$A2                            ; A282 A9 A2                    ..
        sta     $05A0,x                         ; A284 9D A0 05                 ...
LA287:  rts                                     ; A287 60                       `

; ----------------------------------------------------------------------------
LA288:  lda     $0540,x                         ; A288 BD 40 05                 .@.
        beq     LA287                           ; A28B F0 FA                    ..
LA28D:  lda     #$00                            ; A28D A9 00                    ..
        sta     $0570,x                         ; A28F 9D 70 05                 .p.
        ldy     #$1C                            ; A292 A0 1C                    ..
        jsr     entity_gravity_collide                           ; A294 20 B7 E7                  ..
        bcs     LA29E                           ; A297 B0 05                    ..
        ldy     #$1E                            ; A299 A0 1E                    ..
        jmp     L851A                           ; A29B 4C 1A 85                 L..

; ----------------------------------------------------------------------------
LA29E:  lda     #$02                            ; A29E A9 02                    ..
        sta     $0540,x                         ; A2A0 9D 40 05                 .@.
        lda     #$AD                            ; A2A3 A9 AD                    ..
        sta     $0588,x                         ; A2A5 9D 88 05                 ...
        lda     #$A2                            ; A2A8 A9 A2                    ..
        sta     $05A0,x                         ; A2AA 9D A0 05                 ...
        lda     $0570,x                         ; A2AD BD 70 05                 .p.
        cmp     #$08                            ; A2B0 C9 08                    ..
        bne     LA287                           ; A2B2 D0 D3                    ..
        lda     $0498,x                         ; A2B4 BD 98 04                 ...
        beq     LA2FB                           ; A2B7 F0 42                    .B
        ldy     $0468,x                         ; A2B9 BC 68 04                 .h.
        lda     $0300,y                         ; A2BC B9 00 03                 ...
        cmp     #$8E                            ; A2BF C9 8E                    ..
        bne     LA2F0                           ; A2C1 D0 2D                    .-
        lda     $E6                             ; A2C3 A5 E6                    ..
        adc     $E4                             ; A2C5 65 E4                    e.
        and     #$03                            ; A2C7 29 03                    ).
        beq     LA305                           ; A2C9 F0 3A                    .:
        lda     #$02                            ; A2CB A9 02                    ..
        sta     $03F0,x                         ; A2CD 9D F0 03                 ...
        lda     #$00                            ; A2D0 A9 00                    ..
        sta     $03D8,x                         ; A2D2 9D D8 03                 ...
        sta     $03A8,x                         ; A2D5 9D A8 03                 ...
        sta     $03C0,x                         ; A2D8 9D C0 03                 ...
        lda     #$3C                            ; A2DB A9 3C                    .<
        jsr     entity_set_subtype                           ; A2DD 20 98 EA                  ..
        inc     $0540,x                         ; A2E0 FE 40 05                 .@.
        lda     #$10                            ; A2E3 A9 10                    ..
        sta     $0588,x                         ; A2E5 9D 88 05                 ...
        lda     #$A3                            ; A2E8 A9 A3                    ..
        sta     $05A0,x                         ; A2EA 9D A0 05                 ...
        jmp     LA310                           ; A2ED 4C 10 A3                 L..

; ----------------------------------------------------------------------------
LA2F0:  lda     #$CE                            ; A2F0 A9 CE                    ..
        sta     $0588,x                         ; A2F2 9D 88 05                 ...
        lda     #$A1                            ; A2F5 A9 A1                    ..
        sta     $05A0,x                         ; A2F7 9D A0 05                 ...
        rts                                     ; A2FA 60                       `

; ----------------------------------------------------------------------------
LA2FB:  lda     #$3B                            ; A2FB A9 3B                    .;
        jsr     entity_set_subtype                           ; A2FD 20 98 EA                  ..
        lda     #$14                            ; A300 A9 14                    ..
        sta     $0480,x                         ; A302 9D 80 04                 ...
LA305:  lda     #$ED                            ; A305 A9 ED                    ..
        sta     $0588,x                         ; A307 9D 88 05                 ...
        lda     #$A1                            ; A30A A9 A1                    ..
        sta     $05A0,x                         ; A30C 9D A0 05                 ...
LA30F:  rts                                     ; A30F 60                       `

; ----------------------------------------------------------------------------
LA310:  lda     $03F0,x                         ; A310 BD F0 03                 ...
        bpl     LA350                           ; A313 10 3B                    .;
        lda     #$3D                            ; A315 A9 3D                    .=
        jsr     entity_set_subtype                           ; A317 20 98 EA                  ..
        lda     #$24                            ; A31A A9 24                    .$
        sta     $0588,x                         ; A31C 9D 88 05                 ...
        lda     #$A3                            ; A31F A9 A3                    ..
        sta     $05A0,x                         ; A321 9D A0 05                 ...
        jsr     L850B                           ; A324 20 0B 85                  ..
        ldy     $0468,x                         ; A327 BC 68 04                 .h.
        lda     $0300,y                         ; A32A B9 00 03                 ...
        cmp     #$8E                            ; A32D C9 8E                    ..
        bne     LA33E                           ; A32F D0 0D                    ..
        lda     $0540,x                         ; A331 BD 40 05                 .@.
        cmp     #$0C                            ; A334 C9 0C                    ..
        bne     LA30F                           ; A336 D0 D7                    ..
        lda     #$00                            ; A338 A9 00                    ..
        sta     $0570,x                         ; A33A 9D 70 05                 .p.
        rts                                     ; A33D 60                       `

; ----------------------------------------------------------------------------
LA33E:  lda     #$50                            ; A33E A9 50                    .P
        sta     $0588,x                         ; A340 9D 88 05                 ...
        lda     #$A3                            ; A343 A9 A3                    ..
        sta     $05A0,x                         ; A345 9D A0 05                 ...
        lda     #$3C                            ; A348 A9 3C                    .<
        jsr     entity_set_subtype                           ; A34A 20 98 EA                  ..
        inc     $0540,x                         ; A34D FE 40 05                 .@.
LA350:  lda     #$00                            ; A350 A9 00                    ..
        sta     $0570,x                         ; A352 9D 70 05                 .p.
        ldy     #$1C                            ; A355 A0 1C                    ..
        jsr     entity_gravity_collide                           ; A357 20 B7 E7                  ..
        bcc     LA30F                           ; A35A 90 B3                    ..
        jmp     LA2F0                           ; A35C 4C F0 A2                 L..

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $8E — Star Crash shield: rides its owner; spins up
; (sub $40 -> $3F, shape $E4); when the owner hits the throw pose it
; aims at the player (speed 8) and flies off with facing flip
; ($1C:8541), then despawns offscreen.
; =============================================================================
        ldy     $0468,x                         ; A35F BC 68 04                 .h.
        lda     $0330,y                         ; A362 B9 30 03                 .0.
        sta     $0330,x                         ; A365 9D 30 03                 .0.
        lda     $0378,y                         ; A368 B9 78 03                 .x.
        sta     $0378,x                         ; A36B 9D 78 03                 .x.
        lda     $0558,x                         ; A36E BD 58 05                 .X.
        cmp     #$40                            ; A371 C9 40                    .@
        bne     LA386                           ; A373 D0 11                    ..
        lda     $0540,x                         ; A375 BD 40 05                 .@.
        cmp     #$02                            ; A378 C9 02                    ..
        bne     LA386                           ; A37A D0 0A                    ..
        lda     #$3F                            ; A37C A9 3F                    .?
        jsr     entity_set_subtype                           ; A37E 20 98 EA                  ..
        lda     #$E4                            ; A381 A9 E4                    ..
        sta     $0408,x                         ; A383 9D 08 04                 ...
LA386:  lda     $0558,y                         ; A386 B9 58 05                 .X.
        cmp     #$3D                            ; A389 C9 3D                    .=
        bne     LA3AD                           ; A38B D0 20                    . 
        lda     $0540,y                         ; A38D B9 40 05                 .@.
        cmp     #$02                            ; A390 C9 02                    ..
        bne     LA3AD                           ; A392 D0 19                    ..
        jsr     entity_distance_calc                           ; A394 20 C2 EC                  ..
        tay                                     ; A397 A8                       .
        lda     #$08                            ; A398 A9 08                    ..
        jsr     entity_set_dir_velocity                           ; A39A 20 70 F4                  p.
        lda     #$A7                            ; A39D A9 A7                    ..
        sta     $0588,x                         ; A39F 9D 88 05                 ...
        lda     #$A3                            ; A3A2 A9 A3                    ..
        sta     $05A0,x                         ; A3A4 9D A0 05                 ...
        jsr     L8541                           ; A3A7 20 41 85                  A.
        jsr     entity_vert_dispatch_raw                           ; A3AA 20 86 EA                  ..
LA3AD:  rts                                     ; A3AD 60                       `

; ----------------------------------------------------------------------------
; BEHAVIOR types $8F/$90 — inert (rts).
        rts                                     ; A3AE 60
        rts                                     ; A3AF 60
; ----------------------------------------------------------------------------
; --- $A3B0: sweep slots $08-$17: every enemy whose LA3E8 entry is set is
; converted in place to a type $C3 pickup grant (sub $78), counting the
; conversions in $02 (called from the pause menu's M-tank path, $01:8183,
; with this bank at $A000).
; ----------------------------------------------------------------------------
        lda     #$00                            ; A3B0 A9 00                    ..
        sta     $02                             ; A3B2 85 02                    ..
        ldx     #$08                            ; A3B4 A2 08                    ..
LA3B6:  ldy     $0300,x                         ; A3B6 BC 00 03                 ...
        lda     LA3E8,y                         ; A3B9 B9 E8 A3                 ...
        beq     LA3E2                           ; A3BC F0 24                    .$
        lda     $0438,x                         ; A3BE BD 38 04                 .8.
        pha                                     ; A3C1 48                       H
        jsr     entity_wipe_x                           ; A3C2 20 C4 F2                  ..
        pla                                     ; A3C5 68                       h
        sta     $0438,x                         ; A3C6 9D 38 04                 .8.
        lda     #$C3                            ; A3C9 A9 C3                    ..
        sta     $0300,x                         ; A3CB 9D 00 03                 ...
        lda     #$00                            ; A3CE A9 00                    ..
        sta     $0408,x                         ; A3D0 9D 08 04                 ...
        lda     #$78                            ; A3D3 A9 78                    .x
        jsr     entity_set_subtype                           ; A3D5 20 98 EA                  ..
        lda     $0528,x                         ; A3D8 BD 28 05                 .(.
        and     #$00                            ; A3DB 29 00                    ).
        sta     $0528,x                         ; A3DD 9D 28 05                 .(.
        inc     $02                             ; A3E0 E6 02                    ..
LA3E2:  inx                                     ; A3E2 E8                       .
        cpx     #$18                            ; A3E3 E0 18                    ..
        bne     LA3B6                           ; A3E5 D0 CF                    ..
        rts                                     ; A3E7 60                       `

; ----------------------------------------------------------------------------
; LA3E8: per-type pickup-conversion eligibility for the $A3B0 sweep
; ($D0 entries); $A4B8-$A7FF data, unreferenced tail (no reader found).
LA3E8:  .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A3E8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A3F0
        .byte   $B6,$B6,$B6,$B6,$00,$B6,$B6,$B6 ; A3F8
        .byte   $B6,$B6,$00,$B6,$00,$B6,$00,$B6 ; A400
        .byte   $B6,$B6,$00,$B6,$00,$B6,$B6,$B6 ; A408
        .byte   $B6,$00,$B6,$B6,$00,$00,$00,$00 ; A410
        .byte   $00,$B6,$00,$B6,$00,$B6,$B6,$00 ; A418
        .byte   $00,$B6,$B6,$B6,$00,$B6,$B6,$00 ; A420
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A428
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A430
        .byte   $B6,$00,$B6,$B6,$B6,$00,$B6,$00 ; A438
        .byte   $00,$B6,$B6,$00,$B6,$B6,$00,$B6 ; A440
        .byte   $B6,$00,$00,$B6,$B6,$00,$B6,$B6 ; A448
        .byte   $B6,$00,$00,$00,$00,$00,$00,$00 ; A450
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A458
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A460
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A468
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A470
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A478
        .byte   $00,$00,$00,$00,$B6,$00,$B6,$00 ; A480
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A488
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A490
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A498
        .byte   $00,$00,$00,$00,$00,$B6,$00,$00 ; A4A0
        .byte   $00,$00,$00,$00,$B6,$00,$00,$00 ; A4A8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A4B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A4B8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A4C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A4C8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A4D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A4D8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A4E0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F ; A4E8
        .byte   $FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF ; A4F0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF ; A4F8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A500
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F ; A508
        .byte   $FF,$FF,$FF,$FF,$FF,$F5,$FF,$FF ; A510
        .byte   $FF,$F7,$FF,$77,$FF,$DF,$FF,$FF ; A518
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$77 ; A520
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A528
        .byte   $FF,$FF,$FF,$FF,$FF,$7F,$FF,$DF ; A530
        .byte   $FF,$FF,$FF,$D7,$FF,$FF,$FF,$FF ; A538
        .byte   $FF,$FF,$FF,$5F,$FF,$FD,$FF,$FF ; A540
        .byte   $FF,$7F,$FF,$7F,$FF,$FF,$FF,$DF ; A548
        .byte   $FF,$FF,$FF,$7F,$FF,$DF,$FF,$FF ; A550
        .byte   $FF,$F7,$FF,$7F,$FF,$FF,$FF,$FF ; A558
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF ; A560
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A568
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A570
        .byte   $FF,$FC,$FF,$FF,$FF,$FF,$FF,$FF ; A578
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$D7 ; A580
        .byte   $FF,$FD,$FF,$FF,$FF,$7F,$FF,$FF ; A588
        .byte   $FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF ; A590
        .byte   $FF,$FF,$FF,$FF,$FF,$F7,$FF,$FF ; A598
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A5A0
        .byte   $FF,$FF,$FF,$F7,$FF,$FF,$FF,$FF ; A5A8
        .byte   $FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF ; A5B0
        .byte   $DF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A5B8
        .byte   $FF,$FF,$FF,$77,$FF,$F7,$FF,$DF ; A5C0
        .byte   $FF,$FF,$FF,$FF,$FF,$7F,$FF,$FF ; A5C8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A5D0
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$D7 ; A5D8
        .byte   $FB,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A5E0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A5E8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A5F0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A5F8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A600
        .byte   $FF,$DF,$FF,$FF,$FF,$5F,$FF,$FF ; A608
        .byte   $DF,$FF,$FF,$7F,$F7,$FF,$FF,$FF ; A610
        .byte   $FF,$FF,$FF,$77,$FF,$DF,$FF,$FF ; A618
        .byte   $FF,$FF,$FF,$F7,$FF,$FD,$FF,$FF ; A620
        .byte   $FF,$FF,$FF,$FF,$FF,$7F,$FF,$FF ; A628
        .byte   $FF,$DF,$FF,$FD,$FF,$FF,$FF,$FF ; A630
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A638
        .byte   $FF,$F7,$FF,$7F,$FF,$FF,$FF,$7F ; A640
        .byte   $FF,$FF,$FF,$FF,$FF,$DF,$FF,$FF ; A648
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A650
        .byte   $FF,$FD,$FF,$DF,$FF,$FF,$FF,$FF ; A658
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A660
        .byte   $FF,$FF,$FF,$FF,$FF,$F7,$FF,$7F ; A668
        .byte   $FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF ; A670
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A678
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A680
        .byte   $FF,$FF,$FF,$DF,$FF,$FF,$FF,$FF ; A688
        .byte   $DF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A690
        .byte   $FF,$FF,$FF,$FF,$FF,$F5,$FF,$7F ; A698
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6A0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD ; A6A8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6B0
        .byte   $FF,$FF,$FF,$7D,$FF,$FF,$FF,$FF ; A6B8
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF ; A6C0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6C8
        .byte   $FF,$DF,$FF,$FF,$FF,$FF,$FF,$FF ; A6D0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6D8
        .byte   $FF,$FF,$FF,$F7,$FF,$FF,$FF,$F7 ; A6E0
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF ; A6E8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6F0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6F8
        .byte   $FF,$F7,$FF,$FF,$FF,$FF,$FF,$FF ; A700
        .byte   $FF,$F7,$FF,$FF,$FF,$FD,$FF,$FF ; A708
        .byte   $FF,$FD,$FF,$FD,$FF,$DF,$FF,$DF ; A710
        .byte   $FF,$7F,$FF,$FF,$FF,$DF,$FF,$FD ; A718
        .byte   $FF,$FD,$FF,$FF,$FF,$FF,$FF,$FD ; A720
        .byte   $FF,$7F,$FF,$7F,$FF,$FF,$FF,$FF ; A728
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF ; A730
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$F5 ; A738
        .byte   $FF,$FF,$FF,$F7,$FF,$7F,$FF,$FF ; A740
        .byte   $FF,$FF,$EF,$FF,$FF,$FF,$FF,$FF ; A748
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A750
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A758
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A760
        .byte   $FF,$FF,$FF,$FF,$FF,$7F,$FF,$F7 ; A768
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A770
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A778
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A780
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF ; A788
        .byte   $FF,$FF,$FF,$FF,$FF,$F7,$FF,$FF ; A790
        .byte   $FF,$FF,$FF,$7F,$FF,$7F,$FF,$FF ; A798
        .byte   $FF,$FD,$FF,$FF,$FF,$7F,$FF,$FF ; A7A0
        .byte   $FF,$DF,$FF,$FF,$FF,$FF,$FF,$FE ; A7A8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7B0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7B8
        .byte   $FF,$FD,$FF,$FF,$FF,$F7,$FF,$FF ; A7C0
        .byte   $FF,$FF,$FF,$FF,$FF,$7F,$FF,$FF ; A7C8
        .byte   $FF,$F5,$FF,$FF,$FF,$7F,$FF,$FF ; A7D0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7D8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7E0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$F7 ; A7E8
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7F0
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7F8
; --- $A800: DAMAGE TABLE, weapon $8 (Charge Kick) ---
; $A800[ent_type] via damage_engine $1C:809D; low 7 bits = damage,
; bit 7 = special handling; $00 = ricochet. Types $00-$CF.
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A800  types $00-$0F
        .byte   $01,$01,$01,$01,$01,$01,$02,$01,$80,$01,$01,$01,$01,$01,$00,$00 ; A810  types $10-$1F
        .byte   $01,$03,$00,$00,$00,$01,$00,$00,$01,$01,$01,$01,$00,$00,$00,$00 ; A820  types $20-$2F
        .byte   $00,$01,$01,$02,$01,$00,$03,$00,$00,$01,$01,$01,$00,$80,$01,$00 ; A830  types $30-$3F
        .byte   $80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80 ; A840  types $40-$4F
        .byte   $01,$00,$01,$01,$01,$00,$01,$00,$00,$01,$01,$00,$00,$07,$00,$00 ; A850  types $50-$5F
        .byte   $01,$00,$01,$01,$01,$01,$02,$01,$01,$80,$00,$80,$00,$00,$01,$00 ; A860  types $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$80,$00,$00,$00 ; A870  types $70-$7F
        .byte   $00,$80,$00,$01,$00,$00,$04,$00,$80,$80,$00,$00,$00,$01,$00,$00 ; A880  types $80-$8F
        .byte   $00,$80,$80,$01,$00,$00,$01,$00,$01,$00,$00,$00,$80,$00,$01,$00 ; A890  types $90-$9F
        .byte   $80,$00,$00,$00,$00,$80,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00 ; A8A0  types $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$01,$02,$00 ; A8B0  types $B0-$BF
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8C0  types $C0-$CF
; --- $A8D0: remainder (beyond type $CF) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8F0

; =============================================================================
; PROTO CASTLE 1 STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $A900: screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; A900  screens $00-$0F
        .byte   $10,$11,$12,$13,$14,$15,$16,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A910  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A920  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A930  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A940  screens $40-$4F
; --- $A950: section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $25,$80,$A5,$40,$62,$80,$80,$A1,$20,$20,$00,$00,$00,$00,$00,$00 ; A950
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A960
; --- $A968: per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $03,$1C,$2B,$2B,$32,$27,$27,$1B,$80,$BD,$00,$00,$00,$00,$00,$00 ; A968
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A978
; --- $A980: BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $A0,$A2,$00,$00,$00,$00,$00,$00 ; A980
; --- $A988: palette sets, 20 bytes each [16 BG palette + 4 palette-cycle
; seeds]: set n at +20n; set 0 is loaded by stage_load, later sets are
; switched per section by the bank $00 environment service
; ($A968 attr bits 0-5 -> $00:809E records, ctl bit 7) ---
        .byte   $0F,$30,$23,$00,$0F,$35,$24,$14,$0F,$17,$08,$0A,$0F,$30,$28,$07 ; A988
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A998
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00 ; A9A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9D0
; --- $A9E0: screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9E0  terminator / filler
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9F0  
        .byte   $00                             ; A9FF  -1 base for the spawn arrays
; --- $AA00: spawn screens (ascending) ---
        .byte   $01,$01,$01,$02,$02,$03,$03,$03,$04,$04,$04,$04,$05,$05,$06,$06 ; AA00  entries $00-$0F
        .byte   $06,$06,$07,$07,$07,$07,$08,$08,$08,$08,$09,$09,$0B,$0B,$0B,$0C ; AA10  entries $10-$1F
        .byte   $0C,$0C,$0C,$0C,$0D,$0D,$10,$11,$12,$13,$13,$13,$14,$14,$14,$14 ; AA20  entries $20-$2F
        .byte   $16,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA30  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA70  entries $70-$7F
; --- $AA80: spawn X px ---
        .byte   $10,$90,$F0,$60,$D0,$10,$80,$D0,$40,$70,$C0,$E0,$6F,$B0,$40,$80 ; AA80  entries $00-$0F
        .byte   $81,$B0,$60,$90,$B0,$E0,$5F,$60,$B0,$F8,$60,$70,$2F,$30,$88,$10 ; AA90  entries $10-$1F
        .byte   $20,$30,$50,$90,$60,$E8,$20,$80,$80,$AF,$B0,$D0,$01,$10,$30,$90 ; AAA0  entries $20-$2F
        .byte   $D8,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAF0  entries $70-$7F
; --- $AB00: spawn Y px ---
        .byte   $90,$94,$50,$60,$C0,$68,$54,$30,$40,$60,$84,$50,$44,$B4,$20,$20 ; AB00  entries $00-$0F
        .byte   $A6,$20,$48,$48,$48,$88,$A8,$40,$28,$60,$88,$B8,$68,$28,$B8,$30 ; AB10  entries $10-$1F
        .byte   $20,$10,$58,$98,$B4,$48,$9C,$80,$80,$78,$98,$78,$98,$50,$B8,$30 ; AB20  entries $20-$2F
        .byte   $00,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB30  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00 ; AB50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00,$00 ; AB60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB70  entries $70-$7F
; --- $AB80: spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $33,$04,$33,$33,$33,$33,$04,$33,$33,$33,$04,$33,$04,$04,$1C,$1C ; AB80  entries $00-$0F
        .byte   $2E,$1C,$32,$84,$86,$32,$32,$07,$07,$07,$07,$32,$32,$07,$32,$07 ; AB90  entries $10-$1F
        .byte   $07,$07,$32,$84,$1D,$32,$1F,$58,$58,$84,$86,$32,$32,$38,$32,$38 ; ABA0  entries $20-$2F
        .byte   $6C,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABF0  entries $70-$7F
; --- $AC00: per-screen spawn-list start index ---
        .byte   $00,$00,$03,$05,$08,$0C,$0E,$12,$16,$1A,$1C,$1C,$1F,$24,$26,$26 ; AC00  screens $00-$0F
        .byte   $26,$27,$28,$29,$2C,$30,$30,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC10  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00 ; AC20  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC30  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC40  screens $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC50  screens $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$80,$00,$00,$00 ; AC60  screens $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00 ; AC80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC90  screens $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACA0  screens $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACB0  screens $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00 ; ACC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACD0  screens $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00 ; ACE0  screens $E0-$EF
        .byte   $00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACF0  screens $F0-$FF
; --- $AD00: metatile top-left tile ids ---
        .byte   $00,$50,$03,$05,$50,$DC,$00,$EE,$03,$00,$13,$50,$10,$AC,$00,$00 ; AD00  metatiles $00-$0F
        .byte   $0A,$01,$01,$0E,$00,$37,$A5,$00,$2B,$64,$66,$2E,$2E,$26,$27,$8A ; AD10  metatiles $10-$1F
        .byte   $08,$0A,$0C,$0E,$37,$37,$2A,$2C,$28,$2A,$2C,$2E,$26,$26,$6C,$6E ; AD20  metatiles $20-$2F
        .byte   $70,$72,$00,$00,$26,$26,$26,$26,$58,$5A,$5B,$00,$4B,$7A,$4E,$00 ; AD30  metatiles $30-$3F
        .byte   $10,$22,$40,$10,$01,$26,$26,$01,$34,$42,$10,$20,$44,$00,$10,$36 ; AD40  metatiles $40-$4F
        .byte   $34,$40,$44,$10,$52,$50,$52,$00,$10,$10,$00,$46,$00,$00,$54,$56 ; AD50  metatiles $50-$5F
        .byte   $82,$84,$86,$00,$A0,$A2,$A4,$A6,$80,$85,$88,$00,$A0,$00,$00,$C6 ; AD60  metatiles $60-$6F
        .byte   $C0,$C2,$82,$00,$E4,$00,$A2,$C4,$E0,$E2,$80,$00,$FC,$00,$00,$C4 ; AD70  metatiles $70-$7F
        .byte   $A8,$AA,$A2,$A6,$D4,$00,$E6,$00,$C8,$CA,$E8,$EA,$A6,$D4,$B5,$00 ; AD80  metatiles $80-$8F
        .byte   $D8,$DA,$D8,$AA,$A6,$D4,$F7,$00,$00,$00,$D8,$CA,$00,$00,$00,$00 ; AD90  metatiles $90-$9F
        .byte   $8C,$8E,$9C,$9E,$00,$00,$00,$A2,$BC,$BE,$BC,$BE,$00,$00,$00,$00 ; ADA0  metatiles $A0-$AF
        .byte   $9C,$9E,$AC,$AE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADB0  metatiles $B0-$BF
        .byte   $08,$0A,$0C,$0E,$00,$00,$2A,$2C,$28,$2A,$2C,$2E,$00,$00,$6C,$6E ; ADC0  metatiles $C0-$CF
        .byte   $54,$56,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADD0  metatiles $D0-$DF
        .byte   $EE,$C0,$C2,$C4,$00,$00,$00,$00,$8E,$E0,$E2,$E4,$00,$00,$00,$00 ; ADE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADF0  metatiles $F0-$FF
; --- $AE00: metatile bottom-left tile ids ---
        .byte   $00,$51,$04,$06,$53,$DD,$00,$EF,$04,$00,$14,$10,$53,$AD,$00,$00 ; AE00  metatiles $00-$0F
        .byte   $0D,$01,$01,$7B,$00,$37,$09,$00,$2D,$65,$67,$9B,$07,$26,$29,$29 ; AE10  metatiles $10-$1F
        .byte   $09,$0B,$0D,$0F,$37,$37,$2B,$2D,$29,$2B,$2D,$2F,$26,$26,$6D,$6F ; AE20  metatiles $20-$2F
        .byte   $71,$73,$00,$00,$26,$26,$26,$26,$59,$5A,$6B,$00,$4C,$00,$4F,$4D ; AE30  metatiles $30-$3F
        .byte   $10,$23,$40,$10,$27,$27,$01,$01,$34,$43,$45,$21,$10,$00,$10,$36 ; AE40  metatiles $40-$4F
        .byte   $34,$40,$45,$51,$10,$51,$53,$00,$10,$10,$00,$47,$00,$00,$55,$57 ; AE50  metatiles $50-$5F
        .byte   $83,$85,$87,$00,$A1,$A3,$A3,$A7,$81,$84,$89,$00,$A1,$00,$00,$C7 ; AE60  metatiles $60-$6F
        .byte   $C1,$C3,$89,$00,$E5,$00,$A4,$C4,$E1,$E3,$89,$00,$FD,$00,$00,$C4 ; AE70  metatiles $70-$7F
        .byte   $A9,$AB,$A3,$A7,$E7,$00,$D4,$00,$C9,$CB,$E9,$EB,$B5,$D4,$A7,$00 ; AE80  metatiles $80-$8F
        .byte   $D9,$DB,$A9,$DB,$F6,$D4,$A7,$00,$00,$00,$C9,$DB,$00,$00,$00,$00 ; AE90  metatiles $90-$9F
        .byte   $8D,$8F,$9D,$9F,$00,$00,$00,$C5,$BD,$BF,$BD,$BF,$00,$00,$00,$00 ; AEA0  metatiles $A0-$AF
        .byte   $9D,$9F,$AD,$AF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEB0  metatiles $B0-$BF
        .byte   $09,$0B,$0D,$0F,$00,$00,$2B,$2D,$29,$2B,$2D,$2F,$00,$00,$6D,$6F ; AEC0  metatiles $C0-$CF
        .byte   $55,$57,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AED0  metatiles $D0-$DF
        .byte   $EF,$C1,$C3,$C5,$00,$00,$00,$00,$8F,$E1,$E3,$E5,$00,$00,$00,$00 ; AEE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEF0  metatiles $F0-$FF
; --- $AF00: metatile top-right tile ids ---
        .byte   $00,$60,$03,$15,$10,$EC,$00,$FE,$03,$00,$13,$10,$10,$AE,$00,$B6 ; AF00  metatiles $00-$0F
        .byte   $1A,$64,$66,$1E,$00,$38,$02,$00,$2B,$10,$10,$2E,$2E,$10,$12,$9A ; AF10  metatiles $10-$1F
        .byte   $18,$1A,$1C,$1E,$38,$3A,$5C,$5E,$28,$2A,$2C,$2E,$10,$49,$7C,$7E ; AF20  metatiles $20-$2F
        .byte   $70,$72,$00,$00,$3B,$3D,$3E,$10,$68,$6A,$5B,$00,$7A,$7A,$00,$00 ; AF30  metatiles $30-$3F
        .byte   $10,$32,$24,$25,$27,$10,$10,$01,$40,$42,$10,$30,$40,$00,$44,$00 ; AF40  metatiles $40-$4F
        .byte   $40,$40,$40,$60,$62,$60,$62,$00,$76,$78,$00,$74,$00,$00,$64,$66 ; AF50  metatiles $50-$5F
        .byte   $92,$94,$96,$F8,$B0,$B2,$B4,$B6,$90,$95,$98,$00,$B2,$FA,$B4,$D6 ; AF60  metatiles $60-$6F
        .byte   $D0,$D2,$92,$00,$F4,$00,$B2,$D4,$F0,$F2,$90,$00,$00,$00,$B2,$C4 ; AF70  metatiles $70-$7F
        .byte   $B8,$BA,$BB,$BB,$B6,$00,$B5,$00,$D8,$DA,$D8,$DA,$B6,$C4,$B5,$00 ; AF80  metatiles $80-$8F
        .byte   $D8,$DA,$D8,$BA,$B6,$B6,$B6,$00,$00,$00,$D8,$DA,$00,$00,$00,$00 ; AF90  metatiles $90-$9F
        .byte   $9C,$9E,$9C,$9E,$00,$00,$00,$B2,$CC,$CE,$BC,$BE,$00,$00,$00,$FA ; AFA0  metatiles $A0-$AF
        .byte   $BC,$BE,$CC,$CE,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFB0  metatiles $B0-$BF
        .byte   $18,$1A,$1C,$1E,$00,$00,$5C,$5E,$28,$2A,$2C,$2E,$00,$00,$7C,$7E ; AFC0  metatiles $C0-$CF
        .byte   $94,$94,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFD0  metatiles $D0-$DF
        .byte   $FE,$D0,$D2,$D4,$00,$00,$00,$00,$9E,$F0,$F2,$F4,$00,$00,$00,$00 ; AFE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFF0  metatiles $F0-$FF
; --- $B000: metatile bottom-right tile ids ---
        .byte   $00,$61,$04,$16,$10,$ED,$00,$FF,$04,$00,$14,$10,$10,$AF,$00,$B7 ; B000  metatiles $00-$0F
        .byte   $1D,$65,$67,$8B,$00,$38,$19,$00,$2D,$10,$10,$9B,$17,$10,$29,$29 ; B010  metatiles $10-$1F
        .byte   $19,$1B,$1D,$1F,$39,$38,$5D,$5F,$29,$2B,$2D,$2F,$48,$10,$7D,$7F ; B020  metatiles $20-$2F
        .byte   $71,$73,$00,$00,$3C,$3D,$3F,$10,$69,$6A,$6B,$00,$00,$00,$4D,$4D ; B030  metatiles $30-$3F
        .byte   $10,$33,$24,$25,$10,$10,$26,$01,$40,$43,$40,$31,$10,$00,$45,$00 ; B040  metatiles $40-$4F
        .byte   $35,$40,$40,$61,$63,$61,$63,$00,$77,$79,$00,$75,$00,$00,$65,$67 ; B050  metatiles $50-$5F
        .byte   $93,$95,$97,$F9,$B1,$B3,$B3,$B7,$91,$94,$99,$00,$B3,$FB,$B3,$D7 ; B060  metatiles $60-$6F
        .byte   $D1,$D3,$99,$00,$F5,$00,$B4,$D4,$F1,$F3,$99,$00,$00,$00,$B4,$C4 ; B070  metatiles $70-$7F
        .byte   $B9,$BB,$BB,$BB,$B5,$00,$B7,$00,$D9,$DB,$D9,$DB,$B5,$C4,$B7,$00 ; B080  metatiles $80-$8F
        .byte   $D9,$DB,$B9,$DB,$B7,$B7,$B7,$00,$00,$00,$D9,$DB,$00,$00,$00,$00 ; B090  metatiles $90-$9F
        .byte   $9D,$9F,$9D,$9F,$00,$00,$00,$D5,$CD,$CF,$BD,$BF,$00,$00,$00,$D5 ; B0A0  metatiles $A0-$AF
        .byte   $BD,$BF,$CD,$CF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0B0  metatiles $B0-$BF
        .byte   $19,$1B,$1D,$1F,$00,$00,$5D,$5F,$29,$2B,$2D,$2F,$00,$00,$7D,$7F ; B0C0  metatiles $C0-$CF
        .byte   $95,$95,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0D0  metatiles $D0-$DF
        .byte   $FF,$D1,$D3,$D5,$00,$00,$00,$00,$9F,$F1,$F3,$F5,$00,$00,$00,$00 ; B0E0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0F0  metatiles $F0-$FF
; --- $B100: metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$00,$23,$F3,$01,$01,$10,$00,$43,$00,$03,$01,$01,$01,$10,$02 ; B100  metatiles $00-$0F
        .byte   $10,$01,$01,$10,$10,$10,$10,$10,$10,$01,$01,$10,$10,$10,$10,$10 ; B110  metatiles $10-$1F
        .byte   $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10 ; B120  metatiles $20-$2F
        .byte   $13,$13,$13,$10,$10,$10,$10,$10,$13,$13,$13,$10,$10,$10,$10,$10 ; B130  metatiles $30-$3F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$01,$01 ; B140  metatiles $40-$4F
        .byte   $01,$01,$01,$01,$01,$01,$01,$00,$01,$01,$10,$01,$10,$10,$01,$01 ; B150  metatiles $50-$5F
        .byte   $10,$10,$10,$02,$02,$02,$02,$02,$10,$10,$10,$00,$02,$02,$02,$02 ; B160  metatiles $60-$6F
        .byte   $10,$10,$10,$00,$02,$00,$02,$02,$10,$10,$10,$00,$02,$00,$02,$02 ; B170  metatiles $70-$7F
        .byte   $02,$02,$02,$02,$02,$00,$02,$10,$02,$02,$02,$02,$02,$02,$02,$00 ; B180  metatiles $80-$8F
        .byte   $02,$02,$02,$02,$02,$02,$02,$00,$00,$10,$02,$02,$10,$10,$10,$10 ; B190  metatiles $90-$9F
        .byte   $10,$10,$10,$10,$00,$10,$00,$02,$10,$10,$10,$10,$00,$10,$00,$02 ; B1A0  metatiles $A0-$AF
        .byte   $10,$10,$10,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1B0  metatiles $B0-$BF
        .byte   $13,$13,$13,$13,$00,$00,$13,$13,$13,$13,$13,$13,$00,$00,$13,$13 ; B1C0  metatiles $C0-$CF
        .byte   $10,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1D0  metatiles $D0-$DF
        .byte   $31,$11,$11,$11,$00,$00,$00,$00,$F3,$11,$11,$11,$00,$00,$00,$00 ; B1E0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1F0  metatiles $F0-$FF
; --- $B200: 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $47,$47,$11,$12,$47,$47,$1A,$19,$47,$12,$1A,$40,$11,$47,$40,$19 ; B200  blocks $00-$03
        .byte   $1A,$40,$40,$40,$40,$19,$40,$40,$40,$40,$40,$40,$58,$59,$40,$40 ; B210  blocks $04-$07
        .byte   $40,$40,$4B,$59,$4B,$40,$51,$5B,$51,$4E,$42,$42,$40,$41,$43,$49 ; B220  blocks $08-$0B
        .byte   $40,$4B,$43,$42,$5B,$52,$42,$42,$51,$51,$42,$42,$4C,$5B,$42,$42 ; B230  blocks $0C-$0F
        .byte   $4C,$40,$42,$43,$50,$50,$05,$51,$50,$49,$51,$49,$50,$50,$51,$51 ; B240  blocks $10-$13
        .byte   $50,$50,$51,$20,$50,$49,$21,$22,$24,$25,$2C,$2D,$24,$25,$34,$35 ; B250  blocks $14-$17
        .byte   $24,$25,$35,$36,$15,$1F,$37,$1E,$26,$27,$2E,$2F,$37,$37,$37,$37 ; B260  blocks $18-$1B
        .byte   $3C,$00,$3D,$00,$00,$3E,$00,$3F,$37,$1E,$37,$1E,$40,$5B,$B2,$B3 ; B270  blocks $1C-$1F
        .byte   $20,$21,$28,$29,$50,$50,$13,$15,$50,$50,$16,$21,$50,$50,$22,$23 ; B280  blocks $20-$23
        .byte   $22,$13,$2A,$1B,$1F,$26,$1E,$2E,$1B,$37,$1B,$37,$1E,$26,$1E,$2E ; B290  blocks $24-$27
        .byte   $27,$2B,$2F,$2B,$51,$51,$4F,$4F,$28,$26,$28,$2E,$27,$1C,$2F,$1B ; B2A0  blocks $28-$2B
        .byte   $00,$00,$00,$00,$22,$23,$2A,$2B,$40,$40,$43,$43,$50,$50,$20,$21 ; B2B0  blocks $2C-$2F
        .byte   $A0,$A1,$A8,$A9,$A2,$A3,$A8,$A9,$28,$29,$28,$29,$A0,$A1,$A2,$A3 ; B2C0  blocks $30-$33
        .byte   $16,$21,$1E,$29,$24,$25,$37,$34,$24,$25,$35,$35,$24,$25,$36,$2C ; B2D0  blocks $34-$37
        .byte   $24,$25,$2D,$34,$24,$25,$36,$37,$2A,$1B,$2A,$1B,$37,$3C,$37,$3D ; B2E0  blocks $38-$3B
        .byte   $3E,$37,$3F,$37,$1E,$29,$1E,$29,$60,$61,$68,$69,$61,$61,$69,$69 ; B2F0  blocks $3C-$3F
        .byte   $60,$61,$40,$6E,$61,$61,$6D,$6D,$61,$61,$8A,$8B,$40,$66,$40,$66 ; B300  blocks $40-$43
        .byte   $65,$65,$65,$65,$90,$91,$90,$91,$92,$93,$9A,$9B,$40,$66,$68,$69 ; B310  blocks $44-$47
        .byte   $65,$65,$69,$69,$90,$91,$69,$69,$70,$71,$78,$79,$2A,$2B,$2A,$2B ; B320  blocks $48-$4B
        .byte   $D0,$D1,$69,$69,$61,$62,$69,$6A,$6D,$6D,$65,$65,$02,$60,$02,$68 ; B330  blocks $4C-$4F
        .byte   $61,$62,$6D,$6D,$82,$82,$65,$65,$80,$81,$88,$89,$65,$65,$60,$61 ; B340  blocks $50-$53
        .byte   $65,$65,$61,$62,$8A,$8B,$90,$91,$65,$65,$69,$6A,$92,$81,$9A,$89 ; B350  blocks $54-$57
        .byte   $02,$60,$65,$68,$61,$62,$69,$69,$65,$65,$68,$69,$90,$91,$69,$6A ; B360  blocks $58-$5B
        .byte   $65,$60,$65,$68,$60,$70,$68,$78,$71,$62,$79,$6A,$65,$65,$74,$74 ; B370  blocks $5C-$5F
        .byte   $60,$D0,$68,$69,$D1,$62,$69,$6A,$69,$6A,$61,$62,$02,$68,$02,$60 ; B380  blocks $60-$63
        .byte   $69,$69,$61,$61,$02,$63,$02,$67,$63,$63,$67,$67,$63,$68,$67,$60 ; B390  blocks $64-$67
        .byte   $02,$6F,$77,$77,$6F,$6F,$77,$77,$6F,$68,$77,$60,$65,$68,$65,$60 ; B3A0  blocks $68-$6B
        .byte   $82,$68,$65,$60,$69,$6A,$61,$61,$65,$60,$65,$6D,$62,$82,$6D,$65 ; B3B0  blocks $6C-$6F
        .byte   $60,$62,$6D,$6D,$08,$68,$02,$60,$69,$6A,$6D,$6D,$61,$61,$6A,$8B ; B3C0  blocks $70-$73
        .byte   $61,$61,$63,$63,$62,$3A,$63,$38,$60,$61,$39,$39,$61,$62,$39,$39 ; B3D0  blocks $74-$77
        .byte   $3A,$60,$38,$63,$62,$81,$6A,$89,$83,$83,$67,$67,$83,$3A,$67,$38 ; B3E0  blocks $78-$7B
        .byte   $3A,$83,$38,$67,$62,$63,$6A,$67,$8A,$91,$90,$91,$67,$67,$67,$38 ; B3F0  blocks $7C-$7F
        .byte   $67,$63,$39,$38,$67,$67,$39,$39,$90,$91,$39,$39,$63,$67,$38,$67 ; B400  blocks $80-$83
        .byte   $67,$67,$67,$67,$62,$67,$6A,$67,$67,$63,$67,$67,$63,$67,$67,$67 ; B410  blocks $84-$87
        .byte   $62,$83,$6A,$67,$80,$93,$88,$9B,$67,$67,$38,$39,$08,$60,$02,$68 ; B420  blocks $88-$8B
        .byte   $61,$61,$11,$12,$61,$62,$1A,$40,$80,$93,$9A,$9B,$40,$86,$95,$96 ; B430  blocks $8C-$8F
        .byte   $95,$95,$67,$67,$84,$40,$94,$95,$90,$91,$39,$38,$67,$67,$68,$69 ; B440  blocks $90-$93
        .byte   $67,$67,$69,$6A,$67,$60,$67,$63,$7C,$7C,$03,$03,$60,$62,$68,$6A ; B450  blocks $94-$97
        .byte   $61,$62,$68,$6A,$67,$67,$38,$38,$67,$38,$39,$38,$39,$39,$63,$63 ; B460  blocks $98-$9B
        .byte   $63,$38,$67,$63,$39,$38,$63,$63,$39,$38,$38,$39,$40,$60,$40,$68 ; B470  blocks $9C-$9F
        .byte   $38,$38,$3A,$3A,$95,$60,$67,$68,$3A,$3A,$38,$38,$83,$60,$67,$68 ; B480  blocks $A0-$A3
        .byte   $67,$67,$69,$69,$A8,$A9,$69,$69,$A8,$A9,$69,$6A,$67,$60,$67,$68 ; B490  blocks $A4-$A7
        .byte   $67,$67,$67,$68,$67,$60,$69,$69,$67,$67,$6F,$6F,$67,$63,$6F,$6F ; B4A0  blocks $A8-$AB
        .byte   $63,$60,$6F,$68,$7F,$7F,$7F,$7F,$7F,$60,$7F,$68,$77,$77,$65,$65 ; B4B0  blocks $AC-$AF
        .byte   $77,$68,$65,$60,$D0,$D1,$61,$61,$69,$69,$61,$62,$82,$68,$60,$61 ; B4C0  blocks $B0-$B3
        .byte   $69,$69,$6D,$6D,$D0,$D1,$8A,$8B,$68,$69,$60,$61,$AF,$40,$A7,$40 ; B4D0  blocks $B4-$B7
        .byte   $A7,$40,$A7,$40,$A7,$40,$A7,$43,$50,$50,$C0,$C1,$C0,$C1,$C8,$C6 ; B4E0  blocks $B8-$BB
        .byte   $C2,$C3,$C7,$CB,$C8,$CE,$C8,$C9,$CF,$CB,$CA,$CB,$40,$40,$40,$4A ; B4F0  blocks $BC-$BF
        .byte   $4C,$5B,$42,$41,$50,$50,$C2,$C3,$50,$49,$68,$69,$50,$50,$69,$69 ; B500  blocks $C0-$C3
        .byte   $62,$02,$6A,$02,$40,$6E,$40,$66,$6D,$02,$65,$02,$65,$02,$65,$02 ; B510  blocks $C4-$C7
        .byte   $40,$4A,$43,$42,$5B,$66,$42,$66,$65,$02,$65,$65,$50,$50,$69,$6A ; B520  blocks $C8-$CB
        .byte   $50,$50,$68,$69,$60,$61,$69,$69,$50,$66,$51,$66,$02,$67,$67,$67 ; B530  blocks $CC-$CF
        .byte   $7C,$68,$03,$60,$6A,$08,$62,$02,$6A,$02,$62,$02,$02,$67,$61,$62 ; B540  blocks $D0-$D3
        .byte   $08,$72,$02,$72,$60,$61,$8A,$8B,$65,$38,$65,$3A,$38,$81,$3A,$89 ; B550  blocks $D4-$D7
        .byte   $38,$65,$3A,$65,$65,$38,$65,$6D,$39,$39,$8A,$8B,$39,$39,$6D,$6D ; B560  blocks $D8-$DB
        .byte   $38,$91,$8A,$91,$38,$39,$6D,$6D,$39,$38,$6D,$6D,$60,$61,$6D,$0A ; B570  blocks $DC-$DF
        .byte   $65,$0A,$65,$0A,$30,$31,$30,$31,$D0,$D1,$6D,$6D,$61,$61,$6D,$0A ; B580  blocks $E0-$E3
        .byte   $62,$6D,$6A,$65,$6D,$68,$65,$60,$62,$65,$6A,$65,$E8,$E8,$6D,$6D ; B590  blocks $E4-$E7
        .byte   $60,$62,$E0,$6D,$65,$65,$6A,$65,$E0,$65,$E0,$65,$60,$61,$E8,$E8 ; B5A0  blocks $E8-$EB
        .byte   $61,$62,$E8,$E8,$65,$E8,$65,$6D,$E0,$65,$68,$6A,$62,$82,$6A,$65 ; B5B0  blocks $EC-$EF
        .byte   $80,$81,$88,$9B,$E0,$E8,$E0,$6D,$92,$81,$9A,$9B,$6D,$60,$65,$68 ; B5C0  blocks $F0-$F3
        .byte   $6D,$0A,$65,$0A,$82,$60,$65,$68,$65,$0A,$69,$69,$62,$60,$6A,$68 ; B5D0  blocks $F4-$F7
        .byte   $6D,$65,$65,$65,$65,$65,$6A,$68,$00,$00,$00,$00,$00,$00,$00,$00 ; B5E0  blocks $F8-$FB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5F0  blocks $FC-$FF
; --- $B600: screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$01,$00,$02,$03,$02,$04,$05,$06,$06,$06,$06,$06,$06,$06,$06 ; B600
        .byte   $06,$06,$06,$06,$06,$06,$07,$06,$08,$07,$06,$06,$09,$06,$06,$07 ; B610
        .byte   $0A,$0B,$0C,$0D,$0E,$0F,$10,$0B,$11,$12,$13,$11,$11,$13,$14,$15 ; B620
        .byte   $16,$17,$18,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1B,$1C,$1D,$1E,$1A ; B630
; layout $01
        .byte   $03,$00,$01,$00,$02,$03,$02,$04,$06,$06,$06,$06,$06,$06,$06,$06 ; B640
        .byte   $06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$09,$07,$08,$06,$06,$06 ; B650
        .byte   $0C,$0D,$0E,$0F,$0A,$10,$1F,$20,$21,$22,$23,$13,$20,$24,$16,$25 ; B660
        .byte   $26,$27,$28,$29,$2A,$2B,$16,$25,$26,$27,$28,$2C,$2A,$2B,$16,$25 ; B670
; layout $02
        .byte   $06,$05,$03,$00,$01,$00,$02,$03,$06,$06,$06,$06,$06,$06,$06,$06 ; B680
        .byte   $07,$06,$06,$06,$06,$06,$06,$06,$06,$06,$09,$06,$06,$06,$06,$06 ; B690
        .byte   $2D,$10,$0E,$0F,$2E,$0C,$0F,$0B,$28,$13,$13,$2F,$23,$13,$13,$20 ; B6A0
        .byte   $28,$29,$29,$2A,$28,$30,$29,$2A,$28,$2C,$2C,$2A,$28,$31,$2C,$32 ; B6B0
; layout $03
        .byte   $02,$04,$06,$06,$06,$05,$03,$00,$06,$06,$06,$06,$06,$06,$06,$06 ; B6C0
        .byte   $06,$06,$06,$06,$07,$06,$06,$06,$07,$06,$09,$33,$33,$06,$07,$08 ; B6D0
        .byte   $0F,$30,$30,$31,$31,$30,$0F,$0A,$24,$16,$16,$16,$16,$16,$16,$34 ; B6E0
        .byte   $2B,$35,$36,$37,$38,$36,$39,$25,$3A,$3B,$2C,$3C,$3B,$2C,$3C,$3D ; B6F0
; layout $04
        .byte   $01,$3E,$3F,$3F,$3F,$3F,$3F,$3F,$06,$06,$06,$06,$40,$41,$42,$41 ; B700
        .byte   $07,$06,$06,$06,$43,$44,$45,$44,$06,$06,$09,$07,$43,$44,$46,$44 ; B710
        .byte   $10,$0F,$0E,$10,$47,$48,$49,$48,$2D,$13,$3E,$3F,$3F,$3F,$3F,$3F ; B720
        .byte   $28,$29,$3E,$3F,$4A,$3F,$4A,$3F,$4B,$2C,$3E,$3F,$4C,$3F,$4C,$3F ; B730
; layout $05
        .byte   $4D,$4E,$44,$44,$44,$45,$44,$4F,$50,$51,$51,$51,$51,$52,$51,$4F ; B740
        .byte   $44,$44,$44,$53,$54,$45,$44,$4F,$44,$44,$44,$55,$4E,$45,$44,$4F ; B750
        .byte   $56,$44,$44,$57,$51,$52,$51,$58,$59,$56,$5A,$5B,$44,$45,$44,$5C ; B760
        .byte   $4A,$4D,$5D,$5E,$5F,$3E,$4D,$3E,$4C,$4D,$60,$61,$2C,$3E,$4D,$3E ; B770
; layout $06
        .byte   $62,$63,$64,$64,$64,$64,$64,$64,$62,$65,$66,$66,$66,$55,$66,$67 ; B780
        .byte   $62,$68,$69,$69,$69,$46,$69,$6A,$62,$44,$44,$44,$44,$45,$44,$6B ; B790
        .byte   $62,$44,$44,$44,$44,$57,$51,$6C,$6D,$54,$44,$6E,$6F,$52,$51,$6C ; B7A0
        .byte   $64,$62,$44,$44,$44,$45,$70,$71,$64,$72,$44,$44,$44,$45,$44,$63 ; B7B0
; layout $07
        .byte   $3F,$73,$74,$75,$76,$77,$78,$74,$3F,$79,$7A,$7B,$66,$55,$7C,$7A ; B7C0
        .byte   $7D,$7E,$7F,$80,$81,$82,$83,$84,$85,$45,$86,$66,$66,$55,$87,$84 ; B7D0
        .byte   $88,$89,$84,$84,$84,$45,$8A,$81,$88,$52,$7A,$7A,$7A,$89,$66,$66 ; B7E0
        .byte   $4D,$8B,$3F,$4A,$3F,$4A,$3F,$3F,$4D,$4F,$3F,$4C,$3F,$4C,$3F,$3F ; B7F0
; layout $08
        .byte   $42,$8C,$8D,$05,$03,$02,$03,$02,$8E,$06,$06,$06,$06,$06,$06,$06 ; B800
        .byte   $45,$8F,$90,$91,$8F,$90,$91,$8F,$46,$84,$84,$84,$84,$84,$84,$84 ; B810
        .byte   $92,$84,$84,$84,$84,$84,$84,$84,$55,$84,$93,$94,$84,$84,$84,$84 ; B820
        .byte   $3F,$4D,$5D,$5E,$3E,$4A,$3F,$3F,$3F,$4D,$60,$61,$3E,$4A,$3F,$4A ; B830
; layout $09
        .byte   $04,$06,$05,$03,$02,$03,$02,$04,$06,$06,$06,$06,$06,$06,$06,$06 ; B840
        .byte   $90,$91,$8F,$90,$91,$8F,$90,$91,$84,$84,$84,$84,$84,$84,$84,$84 ; B850
        .byte   $84,$84,$84,$84,$84,$84,$84,$95,$84,$84,$84,$84,$84,$84,$84,$84 ; B860
        .byte   $3F,$4A,$3F,$4D,$96,$96,$96,$96,$3F,$4A,$3F,$4D,$3E,$3F,$3F,$4D ; B870
; layout $0A
        .byte   $06,$06,$06,$05,$03,$02,$03,$00,$06,$06,$06,$06,$06,$06,$06,$06 ; B880
        .byte   $97,$8F,$90,$91,$8F,$90,$91,$8F,$97,$84,$84,$84,$84,$84,$84,$84 ; B890
        .byte   $98,$84,$84,$84,$84,$99,$9A,$9B,$97,$84,$84,$84,$84,$66,$9C,$9B ; B8A0
        .byte   $3E,$3F,$4D,$20,$2D,$3E,$3F,$3F,$3E,$3F,$4D,$2A,$28,$3E,$3F,$3F ; B8B0
; layout $0B
        .byte   $01,$00,$02,$04,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06,$06 ; B8C0
        .byte   $90,$91,$8F,$90,$91,$8F,$90,$91,$84,$99,$84,$84,$84,$84,$84,$84 ; B8D0
        .byte   $9D,$9E,$9E,$9E,$99,$84,$84,$93,$9B,$9D,$66,$66,$66,$84,$84,$3E ; B8E0
        .byte   $4D,$20,$2D,$3E,$3F,$3F,$4D,$3E,$4D,$2A,$28,$3E,$3F,$3F,$4D,$3E ; B8F0
; layout $0C
        .byte   $05,$03,$02,$03,$02,$04,$06,$9F,$06,$06,$06,$06,$06,$06,$06,$9F ; B900
        .byte   $8F,$90,$90,$91,$A0,$8F,$90,$A1,$84,$84,$33,$33,$A2,$7A,$7A,$A3 ; B910
        .byte   $A4,$A4,$A5,$A6,$66,$84,$84,$A7,$4A,$3F,$3F,$4A,$4D,$84,$A8,$A9 ; B920
        .byte   $4C,$3F,$4A,$4C,$4D,$AA,$AB,$AC,$3F,$3F,$4C,$3F,$4D,$AD,$AD,$AE ; B930
; layout $0D
        .byte   $64,$64,$4A,$64,$62,$AF,$AF,$B0,$64,$64,$B1,$B2,$72,$44,$44,$6B ; B940
        .byte   $64,$64,$4A,$62,$51,$51,$51,$B3,$B2,$B4,$B5,$72,$44,$44,$44,$B6 ; B950
        .byte   $62,$44,$45,$44,$44,$44,$44,$B6,$62,$51,$52,$51,$51,$51,$51,$B6 ; B960
        .byte   $62,$44,$B6,$64,$64,$64,$64,$64,$62,$51,$B6,$64,$64,$64,$64,$64 ; B970
; layout $0E
        .byte   $4D,$44,$3E,$3F,$3F,$3F,$3F,$3F,$4D,$44,$3E,$4D,$06,$06,$06,$06 ; B980
        .byte   $4D,$44,$55,$B7,$07,$06,$06,$06,$4D,$44,$45,$B8,$06,$07,$09,$06 ; B990
        .byte   $4D,$44,$45,$B9,$2E,$0D,$0E,$0D,$4D,$51,$52,$97,$13,$13,$11,$BA ; B9A0
        .byte   $3F,$3F,$4D,$5D,$5E,$BB,$BC,$BB,$3F,$3F,$4D,$60,$61,$BD,$BE,$BD ; B9B0
; layout $0F
        .byte   $3F,$3F,$3F,$3F,$3F,$3F,$3F,$3F,$06,$3E,$3F,$3F,$3F,$4D,$06,$06 ; B9C0
        .byte   $06,$06,$06,$06,$06,$06,$07,$06,$08,$06,$BF,$09,$06,$08,$06,$07 ; B9D0
        .byte   $0A,$97,$5D,$5E,$10,$0A,$C0,$0D,$C1,$97,$5D,$5E,$13,$11,$C2,$C3 ; B9E0
        .byte   $BC,$97,$60,$61,$BB,$BC,$3E,$4A,$BE,$97,$3E,$4D,$BD,$BE,$3E,$4C ; B9F0
; layout $10
        .byte   $3F,$3F,$3F,$3F,$3F,$3F,$C4,$3E,$06,$06,$06,$06,$06,$C5,$C6,$3E ; BA00
        .byte   $06,$06,$06,$06,$06,$43,$C7,$3E,$06,$08,$06,$07,$08,$43,$C7,$3E ; BA10
        .byte   $C8,$0A,$97,$0D,$0A,$C9,$CA,$3E,$CB,$CC,$CD,$4D,$13,$CE,$44,$3E ; BA20
        .byte   $4D,$3E,$4A,$4D,$3E,$3F,$3F,$3F,$4D,$3E,$4C,$4D,$3E,$3F,$3F,$3F ; BA30
; layout $11
        .byte   $4D,$63,$64,$64,$64,$64,$64,$64,$4D,$65,$66,$66,$66,$66,$66,$B6 ; BA40
        .byte   $4D,$CF,$84,$84,$84,$84,$84,$B6,$4D,$84,$84,$84,$84,$84,$84,$B6 ; BA50
        .byte   $4D,$84,$84,$84,$84,$84,$84,$B6,$4D,$84,$84,$84,$84,$84,$84,$B6 ; BA60
        .byte   $62,$96,$96,$96,$96,$D0,$D1,$B6,$64,$64,$64,$64,$64,$64,$D2,$B6 ; BA70
; layout $12
        .byte   $62,$63,$64,$64,$64,$64,$64,$64,$62,$65,$66,$66,$66,$66,$66,$3E ; BA80
        .byte   $6D,$D3,$84,$84,$84,$84,$84,$3E,$62,$66,$84,$84,$84,$84,$84,$3E ; BA90
        .byte   $62,$84,$84,$84,$84,$84,$84,$3E,$62,$84,$84,$84,$84,$84,$84,$3E ; BAA0
        .byte   $62,$D4,$96,$96,$96,$96,$96,$3E,$62,$4F,$3F,$3F,$3F,$3F,$3F,$3F ; BAB0
; layout $13
        .byte   $4D,$3E,$4A,$3F,$4D,$3E,$3F,$3F,$4D,$4E,$55,$4E,$4E,$D5,$41,$42 ; BAC0
        .byte   $4D,$51,$52,$51,$51,$52,$51,$89,$4D,$51,$89,$44,$D6,$57,$51,$D7 ; BAD0
        .byte   $4D,$44,$45,$D8,$D9,$DA,$DB,$DC,$4D,$51,$52,$DD,$DE,$DA,$DD,$DA ; BAE0
        .byte   $4D,$8B,$4A,$3F,$3F,$4A,$3F,$4A,$4D,$4F,$4C,$3F,$3F,$4C,$3F,$4C ; BAF0
; layout $14
        .byte   $4D,$3E,$3F,$3F,$3F,$3F,$3F,$3F,$50,$55,$4E,$55,$4E,$55,$4E,$3E ; BB00
        .byte   $44,$45,$44,$45,$44,$57,$51,$3E,$51,$52,$51,$89,$44,$45,$44,$3E ; BB10
        .byte   $D6,$45,$44,$57,$51,$89,$44,$DF,$DE,$52,$51,$89,$97,$45,$44,$E0 ; BB20
        .byte   $3F,$4D,$BB,$BC,$3E,$4D,$3E,$3F,$3F,$4D,$BD,$BE,$3E,$4D,$3E,$3F ; BB30
; layout $15
        .byte   $3F,$4A,$4A,$3F,$3F,$4A,$4A,$3F,$4D,$E1,$E1,$3E,$4D,$E1,$E1,$3E ; BB40
        .byte   $4D,$E1,$E1,$3E,$4D,$E1,$E1,$3E,$3F,$4A,$4A,$3F,$3F,$4A,$4A,$3F ; BB50
        .byte   $41,$E2,$E2,$41,$41,$E2,$E2,$E3,$44,$44,$44,$44,$44,$44,$44,$E0 ; BB60
        .byte   $4D,$BB,$BC,$5D,$5E,$BB,$BC,$5D,$4D,$BD,$BE,$5D,$5E,$BD,$BE,$5D ; BB70
; layout $16
        .byte   $3F,$3F,$4A,$3F,$3F,$4A,$3F,$3F,$E4,$4E,$55,$4E,$4E,$55,$4E,$E5 ; BB80
        .byte   $E6,$44,$45,$44,$44,$45,$44,$6B,$E6,$44,$57,$51,$51,$89,$44,$6B ; BB90
        .byte   $6F,$51,$89,$44,$44,$57,$51,$6C,$44,$44,$57,$51,$51,$89,$44,$6B ; BBA0
        .byte   $5E,$BB,$BC,$3E,$4D,$BB,$BC,$3E,$5E,$BD,$BE,$5D,$5E,$BD,$BE,$3E ; BBB0
; layout $17
        .byte   $4D,$E7,$E7,$44,$44,$44,$E8,$3E,$4D,$44,$5A,$48,$E9,$44,$EA,$3E ; BBC0
        .byte   $4D,$44,$E8,$E7,$E8,$EB,$EC,$3E,$4D,$44,$EA,$44,$EA,$4E,$55,$3E ; BBD0
        .byte   $4D,$EB,$EC,$51,$70,$E8,$52,$3E,$4D,$4E,$4E,$44,$44,$EA,$45,$3E ; BBE0
        .byte   $3F,$4D,$3E,$4D,$3E,$4D,$3E,$3F,$3F,$4D,$3E,$4D,$3E,$4D,$3E,$3F ; BBF0
; layout $18
        .byte   $4D,$EA,$ED,$3E,$3F,$3F,$3F,$3F,$4D,$EA,$44,$3E,$3F,$3F,$E4,$55 ; BC00
        .byte   $4D,$EE,$44,$3E,$3F,$3F,$EF,$F0,$3F,$4D,$44,$F1,$E7,$3E,$E6,$45 ; BC10
        .byte   $3F,$4D,$44,$EA,$44,$3E,$4D,$F2,$3F,$59,$56,$EA,$44,$3E,$3F,$3F ; BC20
        .byte   $3F,$3F,$4D,$EA,$44,$E7,$3E,$3F,$3F,$3F,$4D,$EA,$44,$44,$3E,$3F ; BC30
; layout $19
        .byte   $3F,$E6,$44,$3E,$3F,$3F,$4D,$3E,$3F,$3F,$3F,$3F,$3F,$3F,$4D,$3E ; BC40
        .byte   $3F,$3F,$3F,$E4,$4E,$55,$4E,$3E,$3F,$E4,$F3,$E6,$44,$45,$44,$F4 ; BC50
        .byte   $3F,$EF,$F5,$EF,$51,$89,$5A,$F6,$3F,$E6,$6E,$6F,$F5,$3F,$3F,$3F ; BC60
        .byte   $4D,$EA,$5C,$3F,$F7,$3F,$3F,$3F,$4D,$EA,$5C,$3F,$3F,$3F,$3F,$3F ; BC70
; layout $1A
        .byte   $F7,$3F,$3F,$3F,$3F,$3F,$3F,$F7,$E4,$4E,$4E,$4E,$4E,$4E,$4E,$F3 ; BC80
        .byte   $EF,$51,$51,$51,$51,$51,$51,$F5,$F8,$44,$44,$44,$44,$44,$44,$5C ; BC90
        .byte   $F9,$E9,$44,$44,$44,$44,$44,$5C,$F7,$3F,$EF,$51,$51,$51,$51,$F5 ; BCA0
        .byte   $3F,$3F,$F7,$3F,$3F,$4D,$3E,$F7,$3F,$3F,$F7,$3F,$3F,$4D,$3E,$F7 ; BCB0
; layout $1B
        .byte   $3F,$E6,$44,$3E,$3F,$3F,$4D,$3E,$3F,$3F,$3F,$3F,$3F,$3F,$4D,$3E ; BCC0
        .byte   $3F,$3F,$3F,$E4,$4E,$55,$4E,$3E,$3F,$E4,$F3,$E6,$44,$45,$44,$F4 ; BCD0
        .byte   $3F,$EF,$F5,$EF,$51,$89,$5A,$F6,$3F,$E6,$6E,$6F,$F5,$3F,$3F,$3F ; BCE0
        .byte   $3F,$4D,$3E,$4D,$3E,$4D,$3E,$3F,$3F,$4D,$3E,$4D,$3E,$4D,$3E,$3F ; BCF0
; layout $1C
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BD00
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BD10
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BD20
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BD30
; layout $1D
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BD40
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BD50
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BD60
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BD70
; layout $1E
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BD80
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BD90
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BDA0
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BDB0
; layout $1F
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BDC0
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BDD0
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BDE0
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BDF0
; layout $20
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BE00
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BE10
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BE20
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BE30
; layout $21
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BE40
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BE50
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BE60
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BE70
; layout $22
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BE80
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BE90
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BEA0
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BEB0
; layout $23
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BEC0
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BED0
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BEE0
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BEF0
; layout $24
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BF00
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BF10
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BF20
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BF30
; layout $25
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BF40
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BF50
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BF60
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BF70
; layout $26
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BF80
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BF90
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BFA0
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BFB0
; layout $27
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BFC0
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BFD0
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BFE0
        .byte   $2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C,$2C ; BFF0
