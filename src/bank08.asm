.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK08"

; =============================================================================
; BANK $08 (mapped at $A000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
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
; conversions in $02 (caller TBD — runs with bank $08 mapped).
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
; ($D0 entries); $A4B8-$A7FF data, TBD (unreferenced tail).
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
        .byte   $02                             ; A816 02                       .
        ora     ($80,x)                         ; A817 01 80                    ..
        ora     ($01,x)                         ; A819 01 01                    ..
        ora     ($01,x)                         ; A81B 01 01                    ..
        ora     (L0000,x)                       ; A81D 01 00                    ..
        brk                                     ; A81F 00                       .
        ora     ($03,x)                         ; A820 01 03                    ..
        brk                                     ; A822 00                       .
        brk                                     ; A823 00                       .
        brk                                     ; A824 00                       .
        ora     (L0000,x)                       ; A825 01 00                    ..
        brk                                     ; A827 00                       .
        ora     ($01,x)                         ; A828 01 01                    ..
        ora     ($01,x)                         ; A82A 01 01                    ..
        brk                                     ; A82C 00                       .
        brk                                     ; A82D 00                       .
        brk                                     ; A82E 00                       .
        brk                                     ; A82F 00                       .
        brk                                     ; A830 00                       .
        ora     ($01,x)                         ; A831 01 01                    ..
        .byte   $02                             ; A833 02                       .
        ora     (L0000,x)                       ; A834 01 00                    ..
        .byte   $03                             ; A836 03                       .
        brk                                     ; A837 00                       .
        brk                                     ; A838 00                       .
        ora     ($01,x)                         ; A839 01 01                    ..
        ora     (L0000,x)                       ; A83B 01 00                    ..
        .byte   $80                             ; A83D 80                       .
        ora     (L0000,x)                       ; A83E 01 00                    ..
        .byte   $80                             ; A840 80                       .
        brk                                     ; A841 00                       .
        brk                                     ; A842 00                       .
        brk                                     ; A843 00                       .
        brk                                     ; A844 00                       .
        brk                                     ; A845 00                       .
        brk                                     ; A846 00                       .
        brk                                     ; A847 00                       .
        brk                                     ; A848 00                       .
        brk                                     ; A849 00                       .
        brk                                     ; A84A 00                       .
        brk                                     ; A84B 00                       .
        brk                                     ; A84C 00                       .
        brk                                     ; A84D 00                       .
        brk                                     ; A84E 00                       .
        .byte   $80                             ; A84F 80                       .
        ora     (L0000,x)                       ; A850 01 00                    ..
        ora     ($01,x)                         ; A852 01 01                    ..
        ora     (L0000,x)                       ; A854 01 00                    ..
        ora     (L0000,x)                       ; A856 01 00                    ..
        brk                                     ; A858 00                       .
        ora     ($01,x)                         ; A859 01 01                    ..
        brk                                     ; A85B 00                       .
        brk                                     ; A85C 00                       .
        .byte   $07                             ; A85D 07                       .
        brk                                     ; A85E 00                       .
        brk                                     ; A85F 00                       .
        ora     (L0000,x)                       ; A860 01 00                    ..
        ora     ($01,x)                         ; A862 01 01                    ..
        ora     ($01,x)                         ; A864 01 01                    ..
        .byte   $02                             ; A866 02                       .
        ora     ($01,x)                         ; A867 01 01                    ..
        .byte   $80                             ; A869 80                       .
        brk                                     ; A86A 00                       .
        .byte   $80                             ; A86B 80                       .
        brk                                     ; A86C 00                       .
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
        ora     ($80,x)                         ; A87B 01 80                    ..
        brk                                     ; A87D 00                       .
        brk                                     ; A87E 00                       .
        brk                                     ; A87F 00                       .
        brk                                     ; A880 00                       .
        .byte   $80                             ; A881 80                       .
        brk                                     ; A882 00                       .
        .byte   $01                             ; A883 01                       .
LA884:  brk                                     ; A884 00                       .
        brk                                     ; A885 00                       .
        .byte   $04                             ; A886 04                       .
        brk                                     ; A887 00                       .
        .byte   $80                             ; A888 80                       .
        .byte   $80                             ; A889 80                       .
        brk                                     ; A88A 00                       .
        brk                                     ; A88B 00                       .
        brk                                     ; A88C 00                       .
        ora     (L0000,x)                       ; A88D 01 00                    ..
        brk                                     ; A88F 00                       .
        brk                                     ; A890 00                       .
        .byte   $80                             ; A891 80                       .
        .byte   $80                             ; A892 80                       .
        ora     (L0000,x)                       ; A893 01 00                    ..
        brk                                     ; A895 00                       .
        ora     (L0000,x)                       ; A896 01 00                    ..
        ora     (L0000,x)                       ; A898 01 00                    ..
        brk                                     ; A89A 00                       .
        brk                                     ; A89B 00                       .
        .byte   $80                             ; A89C 80                       .
        brk                                     ; A89D 00                       .
        ora     (L0000,x)                       ; A89E 01 00                    ..
        .byte   $80                             ; A8A0 80                       .
        brk                                     ; A8A1 00                       .
        brk                                     ; A8A2 00                       .
        brk                                     ; A8A3 00                       .
        brk                                     ; A8A4 00                       .
        .byte   $80                             ; A8A5 80                       .
        brk                                     ; A8A6 00                       .
        brk                                     ; A8A7 00                       .
        brk                                     ; A8A8 00                       .
        brk                                     ; A8A9 00                       .
        .byte   $80                             ; A8AA 80                       .
        brk                                     ; A8AB 00                       .
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
        .byte   $80                             ; A8BB 80                       .
        brk                                     ; A8BC 00                       .
        ora     ($02,x)                         ; A8BD 01 02                    ..
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
        brk                                     ; A8FF 00                       .
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
        brk                                     ; A917 00                       .
        brk                                     ; A918 00                       .
        brk                                     ; A919 00                       .
        brk                                     ; A91A 00                       .
        brk                                     ; A91B 00                       .
        brk                                     ; A91C 00                       .
        brk                                     ; A91D 00                       .
        brk                                     ; A91E 00                       .
        brk                                     ; A91F 00                       .
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
        brk                                     ; A92E 00                       .
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
        and     $80                             ; A950 25 80                    %.
        lda     $40                             ; A952 A5 40                    .@
        .byte   $62                             ; A954 62                       b
        .byte   $80                             ; A955 80                       .
        .byte   $80                             ; A956 80                       .
        lda     ($20,x)                         ; A957 A1 20                    . 
        jsr     L0000                           ; A959 20 00 00                  ..
        brk                                     ; A95C 00                       .
        brk                                     ; A95D 00                       .
        brk                                     ; A95E 00                       .
        brk                                     ; A95F 00                       .
        brk                                     ; A960 00                       .
        brk                                     ; A961 00                       .
        brk                                     ; A962 00                       .
        brk                                     ; A963 00                       .
        brk                                     ; A964 00                       .
        brk                                     ; A965 00                       .
        brk                                     ; A966 00                       .
        brk                                     ; A967 00                       .
        .byte   $03                             ; A968 03                       .
        .byte   $1C                             ; A969 1C                       .
        .byte   $2B                             ; A96A 2B                       +
        .byte   $2B                             ; A96B 2B                       +
        .byte   $32                             ; A96C 32                       2
        .byte   $27                             ; A96D 27                       '
        .byte   $27                             ; A96E 27                       '
        .byte   $1B                             ; A96F 1B                       .
        .byte   $80                             ; A970 80                       .
        lda     a:L0000,x                       ; A971 BD 00 00                 ...
        brk                                     ; A974 00                       .
        brk                                     ; A975 00                       .
        brk                                     ; A976 00                       .
        brk                                     ; A977 00                       .
        brk                                     ; A978 00                       .
        brk                                     ; A979 00                       .
        brk                                     ; A97A 00                       .
        brk                                     ; A97B 00                       .
        brk                                     ; A97C 00                       .
        brk                                     ; A97D 00                       .
        brk                                     ; A97E 00                       .
        brk                                     ; A97F 00                       .
        ldy     #$A2                            ; A980 A0 A2                    ..
        brk                                     ; A982 00                       .
        brk                                     ; A983 00                       .
        brk                                     ; A984 00                       .
        brk                                     ; A985 00                       .
        brk                                     ; A986 00                       .
        brk                                     ; A987 00                       .
        .byte   $0F                             ; A988 0F                       .
        bmi     LA9AE                           ; A989 30 23                    0#
        brk                                     ; A98B 00                       .
        .byte   $0F                             ; A98C 0F                       .
        and     $24,x                           ; A98D 35 24                    5$
        .byte   $14                             ; A98F 14                       .
        .byte   $0F                             ; A990 0F                       .
        .byte   $17                             ; A991 17                       .
        php                                     ; A992 08                       .
        asl     a                               ; A993 0A                       .
        .byte   $0F                             ; A994 0F                       .
        bmi     LA9BF                           ; A995 30 28                    0(
        .byte   $07                             ; A997 07                       .
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
        ora     (L0000,x)                       ; A9A8 01 00                    ..
        brk                                     ; A9AA 00                       .
        brk                                     ; A9AB 00                       .
        brk                                     ; A9AC 00                       .
        brk                                     ; A9AD 00                       .
LA9AE:  brk                                     ; A9AE 00                       .
        brk                                     ; A9AF 00                       .
        brk                                     ; A9B0 00                       .
        brk                                     ; A9B1 00                       .
        brk                                     ; A9B2 00                       .
        brk                                     ; A9B3 00                       .
        brk                                     ; A9B4 00                       .
        brk                                     ; A9B5 00                       .
        brk                                     ; A9B6 00                       .
        brk                                     ; A9B7 00                       .
        brk                                     ; A9B8 00                       .
        brk                                     ; A9B9 00                       .
        brk                                     ; A9BA 00                       .
        brk                                     ; A9BB 00                       .
        brk                                     ; A9BC 00                       .
        brk                                     ; A9BD 00                       .
        brk                                     ; A9BE 00                       .
LA9BF:  brk                                     ; A9BF 00                       .
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
LA9DB:  brk                                     ; A9DB 00                       .
        brk                                     ; A9DC 00                       .
        brk                                     ; A9DD 00                       .
        brk                                     ; A9DE 00                       .
        brk                                     ; A9DF 00                       .
        .byte   $FF                             ; A9E0 FF                       .
        brk                                     ; A9E1 00                       .
        brk                                     ; A9E2 00                       .
        brk                                     ; A9E3 00                       .
        brk                                     ; A9E4 00                       .
        .byte   $80                             ; A9E5 80                       .
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
        .byte   $03                             ; AA05 03                       .
        .byte   $03                             ; AA06 03                       .
        .byte   $03                             ; AA07 03                       .
        .byte   $04                             ; AA08 04                       .
        .byte   $04                             ; AA09 04                       .
        .byte   $04                             ; AA0A 04                       .
        .byte   $04                             ; AA0B 04                       .
        ora     $05                             ; AA0C 05 05                    ..
        asl     $06                             ; AA0E 06 06                    ..
        asl     $06                             ; AA10 06 06                    ..
LAA12:  .byte   $07                             ; AA12 07                       .
        .byte   $07                             ; AA13 07                       .
        .byte   $07                             ; AA14 07                       .
        .byte   $07                             ; AA15 07                       .
        php                                     ; AA16 08                       .
        php                                     ; AA17 08                       .
        php                                     ; AA18 08                       .
        php                                     ; AA19 08                       .
        ora     #$09                            ; AA1A 09 09                    ..
        .byte   $0B                             ; AA1C 0B                       .
        .byte   $0B                             ; AA1D 0B                       .
        .byte   $0B                             ; AA1E 0B                       .
        .byte   $0C                             ; AA1F 0C                       .
        .byte   $0C                             ; AA20 0C                       .
        .byte   $0C                             ; AA21 0C                       .
        .byte   $0C                             ; AA22 0C                       .
        .byte   $0C                             ; AA23 0C                       .
        ora     $100D                           ; AA24 0D 0D 10                 ...
LAA27:  ora     ($12),y                         ; AA27 11 12                    ..
        .byte   $13                             ; AA29 13                       .
        .byte   $13                             ; AA2A 13                       .
        .byte   $13                             ; AA2B 13                       .
        .byte   $14                             ; AA2C 14                       .
        .byte   $14                             ; AA2D 14                       .
        .byte   $14                             ; AA2E 14                       .
        .byte   $14                             ; AA2F 14                       .
        asl     L00FF,x                         ; AA30 16 FF                    ..
        brk                                     ; AA32 00                       .
        brk                                     ; AA33 00                       .
        brk                                     ; AA34 00                       .
        brk                                     ; AA35 00                       .
        brk                                     ; AA36 00                       .
        brk                                     ; AA37 00                       .
        brk                                     ; AA38 00                       .
        brk                                     ; AA39 00                       .
        brk                                     ; AA3A 00                       .
        brk                                     ; AA3B 00                       .
        brk                                     ; AA3C 00                       .
        brk                                     ; AA3D 00                       .
        brk                                     ; AA3E 00                       .
        brk                                     ; AA3F 00                       .
LAA40:  brk                                     ; AA40 00                       .
        brk                                     ; AA41 00                       .
        brk                                     ; AA42 00                       .
        brk                                     ; AA43 00                       .
        brk                                     ; AA44 00                       .
LAA45:  brk                                     ; AA45 00                       .
        brk                                     ; AA46 00                       .
        brk                                     ; AA47 00                       .
        brk                                     ; AA48 00                       .
        brk                                     ; AA49 00                       .
        brk                                     ; AA4A 00                       .
LAA4B:  brk                                     ; AA4B 00                       .
        brk                                     ; AA4C 00                       .
LAA4D:  brk                                     ; AA4D 00                       .
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
        brk                                     ; AA5A 00                       .
        brk                                     ; AA5B 00                       .
        brk                                     ; AA5C 00                       .
        brk                                     ; AA5D 00                       .
        brk                                     ; AA5E 00                       .
        brk                                     ; AA5F 00                       .
        brk                                     ; AA60 00                       .
        brk                                     ; AA61 00                       .
        brk                                     ; AA62 00                       .
        brk                                     ; AA63 00                       .
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
LAA7C:  brk                                     ; AA7C 00                       .
        brk                                     ; AA7D 00                       .
        brk                                     ; AA7E 00                       .
        brk                                     ; AA7F 00                       .
        bpl     LAA12                           ; AA80 10 90                    ..
        beq     LAAE4                           ; AA82 F0 60                    .`
        bne     LAA96                           ; AA84 D0 10                    ..
        .byte   $80                             ; AA86 80                       .
        bne     LAAC9                           ; AA87 D0 40                    .@
        bvs     LAA4B                           ; AA89 70 C0                    p.
        cpx     #$6F                            ; AA8B E0 6F                    .o
        bcs     LAACF                           ; AA8D B0 40                    .@
        .byte   $80                             ; AA8F 80                       .
        sta     ($B0,x)                         ; AA90 81 B0                    ..
LAA92:  rts                                     ; AA92 60                       `

; ----------------------------------------------------------------------------
        bcc     LAA45                           ; AA93 90 B0                    ..
        .byte   $E0                             ; AA95 E0                       .
LAA96:  .byte   $5F                             ; AA96 5F                       _
        rts                                     ; AA97 60                       `

; ----------------------------------------------------------------------------
        bcs     LAA92                           ; AA98 B0 F8                    ..
        rts                                     ; AA9A 60                       `

; ----------------------------------------------------------------------------
        bvs     LAACC                           ; AA9B 70 2F                    p/
        bmi     LAA27                           ; AA9D 30 88                    0.
        bpl     LAAC1                           ; AA9F 10 20                    . 
        bmi     LAAF3                           ; AAA1 30 50                    0P
        bcc     LAB05                           ; AAA3 90 60                    .`
        inx                                     ; AAA5 E8                       .
        jsr     L8080                           ; AAA6 20 80 80                  ..
        .byte   $AF                             ; AAA9 AF                       .
        bcs     LAA7C                           ; AAAA B0 D0                    ..
        ora     ($10,x)                         ; AAAC 01 10                    ..
        bmi     LAA40                           ; AAAE 30 90                    0.
        cld                                     ; AAB0 D8                       .
        .byte   $FF                             ; AAB1 FF                       .
        brk                                     ; AAB2 00                       .
        brk                                     ; AAB3 00                       .
        brk                                     ; AAB4 00                       .
        brk                                     ; AAB5 00                       .
        brk                                     ; AAB6 00                       .
        brk                                     ; AAB7 00                       .
        brk                                     ; AAB8 00                       .
        brk                                     ; AAB9 00                       .
        brk                                     ; AABA 00                       .
        brk                                     ; AABB 00                       .
        brk                                     ; AABC 00                       .
        brk                                     ; AABD 00                       .
        brk                                     ; AABE 00                       .
        brk                                     ; AABF 00                       .
        brk                                     ; AAC0 00                       .
LAAC1:  brk                                     ; AAC1 00                       .
        brk                                     ; AAC2 00                       .
        brk                                     ; AAC3 00                       .
        brk                                     ; AAC4 00                       .
        brk                                     ; AAC5 00                       .
        brk                                     ; AAC6 00                       .
        brk                                     ; AAC7 00                       .
        brk                                     ; AAC8 00                       .
LAAC9:  brk                                     ; AAC9 00                       .
        brk                                     ; AACA 00                       .
        brk                                     ; AACB 00                       .
LAACC:  brk                                     ; AACC 00                       .
        brk                                     ; AACD 00                       .
        brk                                     ; AACE 00                       .
LAACF:  brk                                     ; AACF 00                       .
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
        brk                                     ; AADB 00                       .
        brk                                     ; AADC 00                       .
        brk                                     ; AADD 00                       .
        brk                                     ; AADE 00                       .
        brk                                     ; AADF 00                       .
        brk                                     ; AAE0 00                       .
        brk                                     ; AAE1 00                       .
        brk                                     ; AAE2 00                       .
        brk                                     ; AAE3 00                       .
LAAE4:  brk                                     ; AAE4 00                       .
        brk                                     ; AAE5 00                       .
        brk                                     ; AAE6 00                       .
LAAE7:  brk                                     ; AAE7 00                       .
        brk                                     ; AAE8 00                       .
        brk                                     ; AAE9 00                       .
        brk                                     ; AAEA 00                       .
        brk                                     ; AAEB 00                       .
        brk                                     ; AAEC 00                       .
        brk                                     ; AAED 00                       .
        brk                                     ; AAEE 00                       .
        brk                                     ; AAEF 00                       .
        brk                                     ; AAF0 00                       .
        brk                                     ; AAF1 00                       .
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
        bcc     LAA96                           ; AB00 90 94                    ..
        bvc     LAB64                           ; AB02 50 60                    P`
        .byte   $C0                             ; AB04 C0                       .
LAB05:  pla                                     ; AB05 68                       h
        .byte   $54                             ; AB06 54                       T
        bmi     LAB49                           ; AB07 30 40                    0@
        rts                                     ; AB09 60                       `

; ----------------------------------------------------------------------------
        sty     $50                             ; AB0A 84 50                    .P
        .byte   $44                             ; AB0C 44                       D
        ldy     $20,x                           ; AB0D B4 20                    . 
        jsr     L20A6                           ; AB0F 20 A6 20                  . 
        pha                                     ; AB12 48                       H
        pha                                     ; AB13 48                       H
        pha                                     ; AB14 48                       H
        dey                                     ; AB15 88                       .
        tay                                     ; AB16 A8                       .
        rti                                     ; AB17 40                       @

; ----------------------------------------------------------------------------
        plp                                     ; AB18 28                       (
        rts                                     ; AB19 60                       `

; ----------------------------------------------------------------------------
        dey                                     ; AB1A 88                       .
        clv                                     ; AB1B B8                       .
        pla                                     ; AB1C 68                       h
        plp                                     ; AB1D 28                       (
        clv                                     ; AB1E B8                       .
        bmi     LAB41                           ; AB1F 30 20                    0 
        bpl     LAB7B                           ; AB21 10 58                    .X
        tya                                     ; AB23 98                       .
        ldy     $48,x                           ; AB24 B4 48                    .H
        .byte   $9C                             ; AB26 9C                       .
        .byte   $80                             ; AB27 80                       .
        .byte   $80                             ; AB28 80                       .
        sei                                     ; AB29 78                       x
        tya                                     ; AB2A 98                       .
        sei                                     ; AB2B 78                       x
        tya                                     ; AB2C 98                       .
        bvc     LAAE7                           ; AB2D 50 B8                    P.
        bmi     LAB31                           ; AB2F 30 00                    0.
LAB31:  .byte   $FF                             ; AB31 FF                       .
        brk                                     ; AB32 00                       .
        brk                                     ; AB33 00                       .
        brk                                     ; AB34 00                       .
        brk                                     ; AB35 00                       .
        brk                                     ; AB36 00                       .
        brk                                     ; AB37 00                       .
        brk                                     ; AB38 00                       .
        brk                                     ; AB39 00                       .
        brk                                     ; AB3A 00                       .
        brk                                     ; AB3B 00                       .
        brk                                     ; AB3C 00                       .
        brk                                     ; AB3D 00                       .
        brk                                     ; AB3E 00                       .
        brk                                     ; AB3F 00                       .
        brk                                     ; AB40 00                       .
LAB41:  brk                                     ; AB41 00                       .
        brk                                     ; AB42 00                       .
        brk                                     ; AB43 00                       .
        brk                                     ; AB44 00                       .
        brk                                     ; AB45 00                       .
        brk                                     ; AB46 00                       .
        brk                                     ; AB47 00                       .
        brk                                     ; AB48 00                       .
LAB49:  brk                                     ; AB49 00                       .
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
        .byte   $02                             ; AB5C 02                       .
        brk                                     ; AB5D 00                       .
        brk                                     ; AB5E 00                       .
        brk                                     ; AB5F 00                       .
        brk                                     ; AB60 00                       .
        brk                                     ; AB61 00                       .
        brk                                     ; AB62 00                       .
        brk                                     ; AB63 00                       .
LAB64:  brk                                     ; AB64 00                       .
        brk                                     ; AB65 00                       .
        brk                                     ; AB66 00                       .
        brk                                     ; AB67 00                       .
        brk                                     ; AB68 00                       .
        brk                                     ; AB69 00                       .
        brk                                     ; AB6A 00                       .
        brk                                     ; AB6B 00                       .
        .byte   $02                             ; AB6C 02                       .
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
LAB7B:  brk                                     ; AB7B 00                       .
        brk                                     ; AB7C 00                       .
        brk                                     ; AB7D 00                       .
        brk                                     ; AB7E 00                       .
        brk                                     ; AB7F 00                       .
        .byte   $33                             ; AB80 33                       3
        .byte   $04                             ; AB81 04                       .
        .byte   $33                             ; AB82 33                       3
        .byte   $33                             ; AB83 33                       3
        .byte   $33                             ; AB84 33                       3
        .byte   $33                             ; AB85 33                       3
        .byte   $04                             ; AB86 04                       .
        .byte   $33                             ; AB87 33                       3
        .byte   $33                             ; AB88 33                       3
        .byte   $33                             ; AB89 33                       3
        .byte   $04                             ; AB8A 04                       .
        .byte   $33                             ; AB8B 33                       3
        .byte   $04                             ; AB8C 04                       .
        .byte   $04                             ; AB8D 04                       .
        .byte   $1C                             ; AB8E 1C                       .
        .byte   $1C                             ; AB8F 1C                       .
        rol     $321C                           ; AB90 2E 1C 32                 ..2
        sty     $86                             ; AB93 84 86                    ..
        .byte   $32                             ; AB95 32                       2
        .byte   $32                             ; AB96 32                       2
        .byte   $07                             ; AB97 07                       .
        .byte   $07                             ; AB98 07                       .
        .byte   $07                             ; AB99 07                       .
        .byte   $07                             ; AB9A 07                       .
        .byte   $32                             ; AB9B 32                       2
        .byte   $32                             ; AB9C 32                       2
        .byte   $07                             ; AB9D 07                       .
        .byte   $32                             ; AB9E 32                       2
        .byte   $07                             ; AB9F 07                       .
        .byte   $07                             ; ABA0 07                       .
        .byte   $07                             ; ABA1 07                       .
        .byte   $32                             ; ABA2 32                       2
        sty     $1D                             ; ABA3 84 1D                    ..
        .byte   $32                             ; ABA5 32                       2
        .byte   $1F                             ; ABA6 1F                       .
        cli                                     ; ABA7 58                       X
        cli                                     ; ABA8 58                       X
        sty     $86                             ; ABA9 84 86                    ..
        .byte   $32                             ; ABAB 32                       2
        .byte   $32                             ; ABAC 32                       2
        sec                                     ; ABAD 38                       8
        .byte   $32                             ; ABAE 32                       2
        sec                                     ; ABAF 38                       8
        jmp     (L00FF)                         ; ABB0 6C FF 00                 l..

; ----------------------------------------------------------------------------
        brk                                     ; ABB3 00                       .
        brk                                     ; ABB4 00                       .
        brk                                     ; ABB5 00                       .
        brk                                     ; ABB6 00                       .
        brk                                     ; ABB7 00                       .
        brk                                     ; ABB8 00                       .
        brk                                     ; ABB9 00                       .
        brk                                     ; ABBA 00                       .
        brk                                     ; ABBB 00                       .
        brk                                     ; ABBC 00                       .
        brk                                     ; ABBD 00                       .
        brk                                     ; ABBE 00                       .
        brk                                     ; ABBF 00                       .
        brk                                     ; ABC0 00                       .
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
        ora     $08                             ; AC03 05 08                    ..
        .byte   $0C                             ; AC05 0C                       .
        asl     $1612                           ; AC06 0E 12 16                 ...
        .byte   $1A                             ; AC09 1A                       .
        .byte   $1C                             ; AC0A 1C                       .
        .byte   $1C                             ; AC0B 1C                       .
        .byte   $1F                             ; AC0C 1F                       .
        bit     $26                             ; AC0D 24 26                    $&
        rol     $26                             ; AC0F 26 26                    &&
        .byte   $27                             ; AC11 27                       '
        plp                                     ; AC12 28                       (
        and     #$2C                            ; AC13 29 2C                    ),
        bmi     LAC47                           ; AC15 30 30                    00
        brk                                     ; AC17 00                       .
        brk                                     ; AC18 00                       .
        brk                                     ; AC19 00                       .
        brk                                     ; AC1A 00                       .
        brk                                     ; AC1B 00                       .
        brk                                     ; AC1C 00                       .
        brk                                     ; AC1D 00                       .
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
        rti                                     ; AC28 40                       @

; ----------------------------------------------------------------------------
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
LAC47:  brk                                     ; AC47 00                       .
        brk                                     ; AC48 00                       .
        brk                                     ; AC49 00                       .
        brk                                     ; AC4A 00                       .
        brk                                     ; AC4B 00                       .
        brk                                     ; AC4C 00                       .
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
        brk                                     ; AC60 00                       .
        brk                                     ; AC61 00                       .
        brk                                     ; AC62 00                       .
        brk                                     ; AC63 00                       .
        brk                                     ; AC64 00                       .
        brk                                     ; AC65 00                       .
        jsr     L0000                           ; AC66 20 00 00                  ..
        brk                                     ; AC69 00                       .
        brk                                     ; AC6A 00                       .
        brk                                     ; AC6B 00                       .
        .byte   $80                             ; AC6C 80                       .
        brk                                     ; AC6D 00                       .
        brk                                     ; AC6E 00                       .
        brk                                     ; AC6F 00                       .
        brk                                     ; AC70 00                       .
        brk                                     ; AC71 00                       .
        brk                                     ; AC72 00                       .
        brk                                     ; AC73 00                       .
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
        brk                                     ; AC85 00                       .
        brk                                     ; AC86 00                       .
        brk                                     ; AC87 00                       .
        brk                                     ; AC88 00                       .
        brk                                     ; AC89 00                       .
        brk                                     ; AC8A 00                       .
        brk                                     ; AC8B 00                       .
        brk                                     ; AC8C 00                       .
        brk                                     ; AC8D 00                       .
        rti                                     ; AC8E 40                       @

; ----------------------------------------------------------------------------
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
        brk                                     ; AC9A 00                       .
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
        brk                                     ; ACAD 00                       .
        brk                                     ; ACAE 00                       .
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
        bpl     LACCF                           ; ACCD 10 00                    ..
LACCF:  brk                                     ; ACCF 00                       .
        brk                                     ; ACD0 00                       .
        brk                                     ; ACD1 00                       .
        brk                                     ; ACD2 00                       .
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
        rti                                     ; ACEC 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACED 00                       .
        brk                                     ; ACEE 00                       .
        brk                                     ; ACEF 00                       .
        brk                                     ; ACF0 00                       .
        brk                                     ; ACF1 00                       .
        brk                                     ; ACF2 00                       .
        brk                                     ; ACF3 00                       .
        rti                                     ; ACF4 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACF5 00                       .
        brk                                     ; ACF6 00                       .
        brk                                     ; ACF7 00                       .
        brk                                     ; ACF8 00                       .
        brk                                     ; ACF9 00                       .
        brk                                     ; ACFA 00                       .
        brk                                     ; ACFB 00                       .
        brk                                     ; ACFC 00                       .
        brk                                     ; ACFD 00                       .
        brk                                     ; ACFE 00                       .
        brk                                     ; ACFF 00                       .
        brk                                     ; AD00 00                       .
        bvc     LAD06                           ; AD01 50 03                    P.
        ora     $50                             ; AD03 05 50                    .P
        .byte   $DC                             ; AD05 DC                       .
LAD06:  brk                                     ; AD06 00                       .
        inc     a:$03                           ; AD07 EE 03 00                 ...
        .byte   $13                             ; AD0A 13                       .
        bvc     LAD1D                           ; AD0B 50 10                    P.
        ldy     a:L0000                         ; AD0D AC 00 00                 ...
        asl     a                               ; AD10 0A                       .
        ora     ($01,x)                         ; AD11 01 01                    ..
        asl     $3700                           ; AD13 0E 00 37                 ..7
        lda     L0000                           ; AD16 A5 00                    ..
        .byte   $2B                             ; AD18 2B                       +
        .byte   $64                             ; AD19 64                       d
        ror     $2E                             ; AD1A 66 2E                    f.
        .byte   $2E                             ; AD1C 2E                       .
LAD1D:  rol     $27                             ; AD1D 26 27                    &'
        txa                                     ; AD1F 8A                       .
        php                                     ; AD20 08                       .
        asl     a                               ; AD21 0A                       .
        .byte   $0C                             ; AD22 0C                       .
        asl     $3737                           ; AD23 0E 37 37                 .77
        rol     a                               ; AD26 2A                       *
        bit     $2A28                           ; AD27 2C 28 2A                 ,(*
        bit     $262E                           ; AD2A 2C 2E 26                 ,.&
        rol     $6C                             ; AD2D 26 6C                    &l
        ror     $7270                           ; AD2F 6E 70 72                 npr
        brk                                     ; AD32 00                       .
        brk                                     ; AD33 00                       .
        rol     $26                             ; AD34 26 26                    &&
        rol     $26                             ; AD36 26 26                    &&
        cli                                     ; AD38 58                       X
        .byte   $5A                             ; AD39 5A                       Z
        .byte   $5B                             ; AD3A 5B                       [
        brk                                     ; AD3B 00                       .
        .byte   $4B                             ; AD3C 4B                       K
        .byte   $7A                             ; AD3D 7A                       z
        lsr     $1000                           ; AD3E 4E 00 10                 N..
        .byte   $22                             ; AD41 22                       "
        rti                                     ; AD42 40                       @

; ----------------------------------------------------------------------------
        bpl     LAD46                           ; AD43 10 01                    ..
        .byte   $26                             ; AD45 26                       &
LAD46:  rol     $01                             ; AD46 26 01                    &.
        .byte   $34                             ; AD48 34                       4
        .byte   $42                             ; AD49 42                       B
        bpl     LAD6C                           ; AD4A 10 20                    . 
        .byte   $44                             ; AD4C 44                       D
        brk                                     ; AD4D 00                       .
        bpl     LAD86                           ; AD4E 10 36                    .6
        .byte   $34                             ; AD50 34                       4
        rti                                     ; AD51 40                       @

; ----------------------------------------------------------------------------
        .byte   $44                             ; AD52 44                       D
        bpl     LADA7                           ; AD53 10 52                    .R
        bvc     LADA9                           ; AD55 50 52                    PR
        brk                                     ; AD57 00                       .
        bpl     LAD6A                           ; AD58 10 10                    ..
        brk                                     ; AD5A 00                       .
        lsr     L0000                           ; AD5B 46 00                    F.
        brk                                     ; AD5D 00                       .
        .byte   $54                             ; AD5E 54                       T
        lsr     $82,x                           ; AD5F 56 82                    V.
        sty     $86                             ; AD61 84 86                    ..
        brk                                     ; AD63 00                       .
        ldy     #$A2                            ; AD64 A0 A2                    ..
        ldy     $A6                             ; AD66 A4 A6                    ..
        .byte   $80                             ; AD68 80                       .
        .byte   $85                             ; AD69 85                       .
LAD6A:  dey                                     ; AD6A 88                       .
        brk                                     ; AD6B 00                       .
LAD6C:  ldy     #$00                            ; AD6C A0 00                    ..
        brk                                     ; AD6E 00                       .
        dec     $C0                             ; AD6F C6 C0                    ..
        .byte   $C2                             ; AD71 C2                       .
        .byte   $82                             ; AD72 82                       .
        brk                                     ; AD73 00                       .
        cpx     L0000                           ; AD74 E4 00                    ..
        ldx     #$C4                            ; AD76 A2 C4                    ..
        cpx     #$E2                            ; AD78 E0 E2                    ..
        .byte   $80                             ; AD7A 80                       .
        brk                                     ; AD7B 00                       .
        .byte   $FC                             ; AD7C FC                       .
        brk                                     ; AD7D 00                       .
        brk                                     ; AD7E 00                       .
        cpy     $A8                             ; AD7F C4 A8                    ..
        tax                                     ; AD81 AA                       .
        ldx     #$A6                            ; AD82 A2 A6                    ..
        .byte   $D4                             ; AD84 D4                       .
        brk                                     ; AD85 00                       .
LAD86:  inc     L0000                           ; AD86 E6 00                    ..
        iny                                     ; AD88 C8                       .
        dex                                     ; AD89 CA                       .
        inx                                     ; AD8A E8                       .
        nop                                     ; AD8B EA                       .
        ldx     $D4                             ; AD8C A6 D4                    ..
        lda     L0000,x                         ; AD8E B5 00                    ..
        cld                                     ; AD90 D8                       .
        .byte   $DA                             ; AD91 DA                       .
        cld                                     ; AD92 D8                       .
        tax                                     ; AD93 AA                       .
        ldx     $D4                             ; AD94 A6 D4                    ..
        .byte   $F7                             ; AD96 F7                       .
        brk                                     ; AD97 00                       .
        brk                                     ; AD98 00                       .
        brk                                     ; AD99 00                       .
        cld                                     ; AD9A D8                       .
        dex                                     ; AD9B CA                       .
        brk                                     ; AD9C 00                       .
        brk                                     ; AD9D 00                       .
        brk                                     ; AD9E 00                       .
LAD9F:  brk                                     ; AD9F 00                       .
        sty     $9C8E                           ; ADA0 8C 8E 9C                 ...
        .byte   $9E                             ; ADA3 9E                       .
        brk                                     ; ADA4 00                       .
        brk                                     ; ADA5 00                       .
        brk                                     ; ADA6 00                       .
LADA7:  ldx     #$BC                            ; ADA7 A2 BC                    ..
LADA9:  ldx     LBEBC,y                         ; ADA9 BE BC BE                 ...
        brk                                     ; ADAC 00                       .
        brk                                     ; ADAD 00                       .
        brk                                     ; ADAE 00                       .
        brk                                     ; ADAF 00                       .
        .byte   $9C                             ; ADB0 9C                       .
        .byte   $9E                             ; ADB1 9E                       .
        ldy     a:$AE                           ; ADB2 AC AE 00                 ...
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
        php                                     ; ADC0 08                       .
        asl     a                               ; ADC1 0A                       .
        .byte   $0C                             ; ADC2 0C                       .
        asl     a:L0000                         ; ADC3 0E 00 00                 ...
        rol     a                               ; ADC6 2A                       *
        bit     $2A28                           ; ADC7 2C 28 2A                 ,(*
        bit     a:$2E                           ; ADCA 2C 2E 00                 ,..
        brk                                     ; ADCD 00                       .
        jmp     (L546E)                         ; ADCE 6C 6E 54                 lnT

; ----------------------------------------------------------------------------
        lsr     L0000,x                         ; ADD1 56 00                    V.
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
        inc     $C2C0                           ; ADE0 EE C0 C2                 ...
        cpy     L0000                           ; ADE3 C4 00                    ..
        brk                                     ; ADE5 00                       .
        brk                                     ; ADE6 00                       .
        brk                                     ; ADE7 00                       .
        stx     $E2E0                           ; ADE8 8E E0 E2                 ...
        cpx     L0000                           ; ADEB E4 00                    ..
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
        eor     ($04),y                         ; AE01 51 04                    Q.
        asl     $53                             ; AE03 06 53                    .S
        cmp     $EF00,x                         ; AE05 DD 00 EF                 ...
        .byte   $04                             ; AE08 04                       .
        brk                                     ; AE09 00                       .
        .byte   $14                             ; AE0A 14                       .
        bpl     LAE60                           ; AE0B 10 53                    .S
        lda     a:L0000                         ; AE0D AD 00 00                 ...
        ora     $0101                           ; AE10 0D 01 01                 ...
        .byte   $7B                             ; AE13 7B                       {
        brk                                     ; AE14 00                       .
        .byte   $37                             ; AE15 37                       7
        ora     #$00                            ; AE16 09 00                    ..
        and     $6765                           ; AE18 2D 65 67                 -eg
        .byte   $9B                             ; AE1B 9B                       .
        .byte   $07                             ; AE1C 07                       .
        rol     $29                             ; AE1D 26 29                    &)
        and     #$09                            ; AE1F 29 09                    ).
        .byte   $0B                             ; AE21 0B                       .
        ora     $370F                           ; AE22 0D 0F 37                 ..7
        .byte   $37                             ; AE25 37                       7
        .byte   $2B                             ; AE26 2B                       +
        and     $2B29                           ; AE27 2D 29 2B                 -)+
        and     $262F                           ; AE2A 2D 2F 26                 -/&
        rol     $6D                             ; AE2D 26 6D                    &m
        .byte   $6F                             ; AE2F 6F                       o
        adc     ($73),y                         ; AE30 71 73                    qs
        brk                                     ; AE32 00                       .
        brk                                     ; AE33 00                       .
        rol     $26                             ; AE34 26 26                    &&
        rol     $26                             ; AE36 26 26                    &&
        eor     $6B5A,y                         ; AE38 59 5A 6B                 YZk
        brk                                     ; AE3B 00                       .
        jmp     L4F00                           ; AE3C 4C 00 4F                 L.O

; ----------------------------------------------------------------------------
        eor     $2310                           ; AE3F 4D 10 23                 M.#
        rti                                     ; AE42 40                       @

; ----------------------------------------------------------------------------
        bpl     LAE6C                           ; AE43 10 27                    .'
        .byte   $27                             ; AE45 27                       '
        ora     ($01,x)                         ; AE46 01 01                    ..
        .byte   $34                             ; AE48 34                       4
        .byte   $43                             ; AE49 43                       C
        eor     $21                             ; AE4A 45 21                    E!
        bpl     LAE4E                           ; AE4C 10 00                    ..
LAE4E:  bpl     LAE86                           ; AE4E 10 36                    .6
        .byte   $34                             ; AE50 34                       4
        rti                                     ; AE51 40                       @

; ----------------------------------------------------------------------------
        eor     $51                             ; AE52 45 51                    EQ
        bpl     LAEA7                           ; AE54 10 51                    .Q
        .byte   $53                             ; AE56 53                       S
        brk                                     ; AE57 00                       .
        bpl     LAE6A                           ; AE58 10 10                    ..
        brk                                     ; AE5A 00                       .
        .byte   $47                             ; AE5B 47                       G
        brk                                     ; AE5C 00                       .
        brk                                     ; AE5D 00                       .
        eor     $57,x                           ; AE5E 55 57                    UW
LAE60:  .byte   $83                             ; AE60 83                       .
        sta     $87                             ; AE61 85 87                    ..
        brk                                     ; AE63 00                       .
        lda     ($A3,x)                         ; AE64 A1 A3                    ..
        .byte   $A3                             ; AE66 A3                       .
        .byte   $A7                             ; AE67 A7                       .
        sta     ($84,x)                         ; AE68 81 84                    ..
LAE6A:  .byte   $89                             ; AE6A 89                       .
        brk                                     ; AE6B 00                       .
LAE6C:  lda     (L0000,x)                       ; AE6C A1 00                    ..
        brk                                     ; AE6E 00                       .
        .byte   $C7                             ; AE6F C7                       .
        cmp     ($C3,x)                         ; AE70 C1 C3                    ..
        .byte   $89                             ; AE72 89                       .
        brk                                     ; AE73 00                       .
        sbc     L0000                           ; AE74 E5 00                    ..
        ldy     $C4                             ; AE76 A4 C4                    ..
        sbc     ($E3,x)                         ; AE78 E1 E3                    ..
        .byte   $89                             ; AE7A 89                       .
        brk                                     ; AE7B 00                       .
        sbc     a:L0000,x                       ; AE7C FD 00 00                 ...
        cpy     $A9                             ; AE7F C4 A9                    ..
        .byte   $AB                             ; AE81 AB                       .
        .byte   $A3                             ; AE82 A3                       .
        .byte   $A7                             ; AE83 A7                       .
        .byte   $E7                             ; AE84 E7                       .
        brk                                     ; AE85 00                       .
LAE86:  .byte   $D4                             ; AE86 D4                       .
        brk                                     ; AE87 00                       .
        cmp     #$CB                            ; AE88 C9 CB                    ..
        sbc     #$EB                            ; AE8A E9 EB                    ..
        lda     $D4,x                           ; AE8C B5 D4                    ..
        .byte   $A7                             ; AE8E A7                       .
        brk                                     ; AE8F 00                       .
        cmp     LA9DB,y                         ; AE90 D9 DB A9                 ...
        .byte   $DB                             ; AE93 DB                       .
        inc     $D4,x                           ; AE94 F6 D4                    ..
        .byte   $A7                             ; AE96 A7                       .
        brk                                     ; AE97 00                       .
        brk                                     ; AE98 00                       .
        brk                                     ; AE99 00                       .
        cmp     #$DB                            ; AE9A C9 DB                    ..
        brk                                     ; AE9C 00                       .
        brk                                     ; AE9D 00                       .
        brk                                     ; AE9E 00                       .
        brk                                     ; AE9F 00                       .
        sta     $9D8F                           ; AEA0 8D 8F 9D                 ...
        .byte   $9F                             ; AEA3 9F                       .
        brk                                     ; AEA4 00                       .
        brk                                     ; AEA5 00                       .
        brk                                     ; AEA6 00                       .
LAEA7:  cmp     $BD                             ; AEA7 C5 BD                    ..
        .byte   $BF                             ; AEA9 BF                       .
        lda     a:$BF,x                         ; AEAA BD BF 00                 ...
LAEAD:  brk                                     ; AEAD 00                       .
        brk                                     ; AEAE 00                       .
        brk                                     ; AEAF 00                       .
        sta     LAD9F,x                         ; AEB0 9D 9F AD                 ...
        .byte   $AF                             ; AEB3 AF                       .
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
        ora     #$0B                            ; AEC0 09 0B                    ..
        ora     a:$0F                           ; AEC2 0D 0F 00                 ...
        brk                                     ; AEC5 00                       .
        .byte   $2B                             ; AEC6 2B                       +
        and     $2B29                           ; AEC7 2D 29 2B                 -)+
        and     a:$2F                           ; AECA 2D 2F 00                 -/.
        brk                                     ; AECD 00                       .
        adc     $556F                           ; AECE 6D 6F 55                 moU
        .byte   $57                             ; AED1 57                       W
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
        .byte   $EF                             ; AEE0 EF                       .
        cmp     ($C3,x)                         ; AEE1 C1 C3                    ..
        cmp     L0000                           ; AEE3 C5 00                    ..
        brk                                     ; AEE5 00                       .
        brk                                     ; AEE6 00                       .
        brk                                     ; AEE7 00                       .
        .byte   $8F                             ; AEE8 8F                       .
        sbc     ($E3,x)                         ; AEE9 E1 E3                    ..
        sbc     L0000                           ; AEEB E5 00                    ..
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
LAEFF:  brk                                     ; AEFF 00                       .
        brk                                     ; AF00 00                       .
        rts                                     ; AF01 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; AF02 03                       .
        ora     $10,x                           ; AF03 15 10                    ..
        cpx     $FE00                           ; AF05 EC 00 FE                 ...
        .byte   $03                             ; AF08 03                       .
        brk                                     ; AF09 00                       .
        .byte   $13                             ; AF0A 13                       .
        bpl     LAF1D                           ; AF0B 10 10                    ..
        ldx     LB600                           ; AF0D AE 00 B6                 ...
        .byte   $1A                             ; AF10 1A                       .
        .byte   $64                             ; AF11 64                       d
        ror     $1E                             ; AF12 66 1E                    f.
        brk                                     ; AF14 00                       .
        sec                                     ; AF15 38                       8
        .byte   $02                             ; AF16 02                       .
        brk                                     ; AF17 00                       .
LAF18:  .byte   $2B                             ; AF18 2B                       +
        bpl     LAF2B                           ; AF19 10 10                    ..
        .byte   $2E                             ; AF1B 2E                       .
        .byte   $2E                             ; AF1C 2E                       .
LAF1D:  bpl     LAF31                           ; AF1D 10 12                    ..
        txs                                     ; AF1F 9A                       .
        clc                                     ; AF20 18                       .
        .byte   $1A                             ; AF21 1A                       .
        .byte   $1C                             ; AF22 1C                       .
        asl     $3A38,x                         ; AF23 1E 38 3A                 .8:
        .byte   $5C                             ; AF26 5C                       \
        lsr     $2A28,x                         ; AF27 5E 28 2A                 ^(*
        .byte   $2C                             ; AF2A 2C                       ,
LAF2B:  rol     $4910                           ; AF2B 2E 10 49                 ..I
        .byte   $7C                             ; AF2E 7C                       |
        .byte   $7E                             ; AF2F 7E                       ~
        .byte   $70                             ; AF30 70                       p
LAF31:  .byte   $72                             ; AF31 72                       r
        brk                                     ; AF32 00                       .
        brk                                     ; AF33 00                       .
        .byte   $3B                             ; AF34 3B                       ;
        and     $103E,x                         ; AF35 3D 3E 10                 =>.
        pla                                     ; AF38 68                       h
        ror     a                               ; AF39 6A                       j
        .byte   $5B                             ; AF3A 5B                       [
        brk                                     ; AF3B 00                       .
        .byte   $7A                             ; AF3C 7A                       z
        .byte   $7A                             ; AF3D 7A                       z
        brk                                     ; AF3E 00                       .
        brk                                     ; AF3F 00                       .
        bpl     LAF74                           ; AF40 10 32                    .2
        bit     $25                             ; AF42 24 25                    $%
LAF44:  .byte   $27                             ; AF44 27                       '
        bpl     LAF57                           ; AF45 10 10                    ..
        ora     ($40,x)                         ; AF47 01 40                    .@
        .byte   $42                             ; AF49 42                       B
        bpl     LAF7C                           ; AF4A 10 30                    .0
        rti                                     ; AF4C 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AF4D 00                       .
        .byte   $44                             ; AF4E 44                       D
        brk                                     ; AF4F 00                       .
        rti                                     ; AF50 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; AF51 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; AF52 40                       @

; ----------------------------------------------------------------------------
        rts                                     ; AF53 60                       `

; ----------------------------------------------------------------------------
        .byte   $62                             ; AF54 62                       b
        rts                                     ; AF55 60                       `

; ----------------------------------------------------------------------------
        .byte   $62                             ; AF56 62                       b
LAF57:  brk                                     ; AF57 00                       .
        ror     $78,x                           ; AF58 76 78                    vx
        brk                                     ; AF5A 00                       .
        .byte   $74                             ; AF5B 74                       t
        brk                                     ; AF5C 00                       .
        brk                                     ; AF5D 00                       .
        .byte   $64                             ; AF5E 64                       d
        ror     $92                             ; AF5F 66 92                    f.
        sty     $96,x                           ; AF61 94 96                    ..
        sed                                     ; AF63 F8                       .
        bcs     LAF18                           ; AF64 B0 B2                    ..
        ldy     $B6,x                           ; AF66 B4 B6                    ..
        bcc     LAEFF                           ; AF68 90 95                    ..
        tya                                     ; AF6A 98                       .
        brk                                     ; AF6B 00                       .
LAF6C:  .byte   $B2                             ; AF6C B2                       .
        .byte   $FA                             ; AF6D FA                       .
        ldy     $D6,x                           ; AF6E B4 D6                    ..
        bne     LAF44                           ; AF70 D0 D2                    ..
        .byte   $92                             ; AF72 92                       .
        brk                                     ; AF73 00                       .
LAF74:  .byte   $F4                             ; AF74 F4                       .
        brk                                     ; AF75 00                       .
        .byte   $B2                             ; AF76 B2                       .
        .byte   $D4                             ; AF77 D4                       .
        beq     LAF6C                           ; AF78 F0 F2                    ..
        bcc     LAF7C                           ; AF7A 90 00                    ..
LAF7C:  brk                                     ; AF7C 00                       .
        brk                                     ; AF7D 00                       .
        .byte   $B2                             ; AF7E B2                       .
        cpy     $B8                             ; AF7F C4 B8                    ..
        tsx                                     ; AF81 BA                       .
        .byte   $BB                             ; AF82 BB                       .
        .byte   $BB                             ; AF83 BB                       .
        ldx     L0000,y                         ; AF84 B6 00                    ..
        lda     L0000,x                         ; AF86 B5 00                    ..
        cld                                     ; AF88 D8                       .
        .byte   $DA                             ; AF89 DA                       .
        cld                                     ; AF8A D8                       .
        .byte   $DA                             ; AF8B DA                       .
        ldx     $C4,y                           ; AF8C B6 C4                    ..
        lda     L0000,x                         ; AF8E B5 00                    ..
        cld                                     ; AF90 D8                       .
        .byte   $DA                             ; AF91 DA                       .
        cld                                     ; AF92 D8                       .
        tsx                                     ; AF93 BA                       .
        ldx     $B6,y                           ; AF94 B6 B6                    ..
        ldx     L0000,y                         ; AF96 B6 00                    ..
        brk                                     ; AF98 00                       .
        brk                                     ; AF99 00                       .
        cld                                     ; AF9A D8                       .
        .byte   $DA                             ; AF9B DA                       .
        brk                                     ; AF9C 00                       .
        brk                                     ; AF9D 00                       .
        brk                                     ; AF9E 00                       .
        brk                                     ; AF9F 00                       .
        .byte   $9C                             ; AFA0 9C                       .
        .byte   $9E                             ; AFA1 9E                       .
        .byte   $9C                             ; AFA2 9C                       .
        .byte   $9E                             ; AFA3 9E                       .
        brk                                     ; AFA4 00                       .
        brk                                     ; AFA5 00                       .
        brk                                     ; AFA6 00                       .
        .byte   $B2                             ; AFA7 B2                       .
        cpy     LBCCE                           ; AFA8 CC CE BC                 ...
        ldx     a:L0000,y                       ; AFAB BE 00 00                 ...
        brk                                     ; AFAE 00                       .
        .byte   $FA                             ; AFAF FA                       .
        ldy     $CCBE,x                         ; AFB0 BC BE CC                 ...
        dec     a:L0000                         ; AFB3 CE 00 00                 ...
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
        clc                                     ; AFC0 18                       .
        .byte   $1A                             ; AFC1 1A                       .
        .byte   $1C                             ; AFC2 1C                       .
        asl     a:L0000,x                       ; AFC3 1E 00 00                 ...
        .byte   $5C                             ; AFC6 5C                       \
        lsr     $2A28,x                         ; AFC7 5E 28 2A                 ^(*
        bit     a:$2E                           ; AFCA 2C 2E 00                 ,..
        brk                                     ; AFCD 00                       .
        .byte   $7C                             ; AFCE 7C                       |
        ror     $9494,x                         ; AFCF 7E 94 94                 ~..
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
LAFDD:  brk                                     ; AFDD 00                       .
        brk                                     ; AFDE 00                       .
        brk                                     ; AFDF 00                       .
        inc     $D2D0,x                         ; AFE0 FE D0 D2                 ...
        .byte   $D4                             ; AFE3 D4                       .
        brk                                     ; AFE4 00                       .
        brk                                     ; AFE5 00                       .
        brk                                     ; AFE6 00                       .
        brk                                     ; AFE7 00                       .
        .byte   $9E                             ; AFE8 9E                       .
        beq     LAFDD                           ; AFE9 F0 F2                    ..
        .byte   $F4                             ; AFEB F4                       .
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
        adc     ($04,x)                         ; B001 61 04                    a.
        asl     $10,x                           ; B003 16 10                    ..
        sbc     $FF00                           ; B005 ED 00 FF                 ...
        .byte   $04                             ; B008 04                       .
        brk                                     ; B009 00                       .
        .byte   $14                             ; B00A 14                       .
        bpl     LB01D                           ; B00B 10 10                    ..
        .byte   $AF                             ; B00D AF                       .
        brk                                     ; B00E 00                       .
        .byte   $B7                             ; B00F B7                       .
        ora     $6765,x                         ; B010 1D 65 67                 .eg
        .byte   $8B                             ; B013 8B                       .
        brk                                     ; B014 00                       .
        sec                                     ; B015 38                       8
        ora     $2D00,y                         ; B016 19 00 2D                 ..-
        bpl     LB02B                           ; B019 10 10                    ..
        .byte   $9B                             ; B01B 9B                       .
        .byte   $17                             ; B01C 17                       .
LB01D:  bpl     LB048                           ; B01D 10 29                    .)
        and     #$19                            ; B01F 29 19                    ).
        .byte   $1B                             ; B021 1B                       .
        ora     $391F,x                         ; B022 1D 1F 39                 ..9
        sec                                     ; B025 38                       8
        eor     $295F,x                         ; B026 5D 5F 29                 ]_)
        .byte   $2B                             ; B029 2B                       +
        .byte   $2D                             ; B02A 2D                       -
LB02B:  .byte   $2F                             ; B02B 2F                       /
        pha                                     ; B02C 48                       H
        bpl     LB0AC                           ; B02D 10 7D                    .}
        .byte   $7F                             ; B02F 7F                       .
        adc     ($73),y                         ; B030 71 73                    qs
        brk                                     ; B032 00                       .
        brk                                     ; B033 00                       .
        .byte   $3C                             ; B034 3C                       <
        and     $103F,x                         ; B035 3D 3F 10                 =?.
        adc     #$6A                            ; B038 69 6A                    ij
        .byte   $6B                             ; B03A 6B                       k
        brk                                     ; B03B 00                       .
        brk                                     ; B03C 00                       .
        brk                                     ; B03D 00                       .
        eor     $104D                           ; B03E 4D 4D 10                 MM.
        .byte   $33                             ; B041 33                       3
        bit     $25                             ; B042 24 25                    $%
        bpl     LB056                           ; B044 10 10                    ..
        rol     $01                             ; B046 26 01                    &.
LB048:  rti                                     ; B048 40                       @

; ----------------------------------------------------------------------------
        .byte   $43                             ; B049 43                       C
        rti                                     ; B04A 40                       @

; ----------------------------------------------------------------------------
        and     ($10),y                         ; B04B 31 10                    1.
        brk                                     ; B04D 00                       .
        eor     L0000                           ; B04E 45 00                    E.
        and     $40,x                           ; B050 35 40                    5@
        rti                                     ; B052 40                       @

; ----------------------------------------------------------------------------
        adc     ($63,x)                         ; B053 61 63                    ac
        .byte   $61                             ; B055 61                       a
LB056:  .byte   $63                             ; B056 63                       c
        brk                                     ; B057 00                       .
        .byte   $77                             ; B058 77                       w
        adc     $7500,y                         ; B059 79 00 75                 y.u
        brk                                     ; B05C 00                       .
        brk                                     ; B05D 00                       .
        adc     $67                             ; B05E 65 67                    eg
        .byte   $93                             ; B060 93                       .
        sta     $97,x                           ; B061 95 97                    ..
        sbc     LB3B1,y                         ; B063 F9 B1 B3                 ...
        .byte   $B3                             ; B066 B3                       .
        .byte   $B7                             ; B067 B7                       .
        sta     ($94),y                         ; B068 91 94                    ..
        sta     LB300,y                         ; B06A 99 00 B3                 ...
        .byte   $FB                             ; B06D FB                       .
        .byte   $B3                             ; B06E B3                       .
        .byte   $D7                             ; B06F D7                       .
        cmp     ($D3),y                         ; B070 D1 D3                    ..
        sta     $F500,y                         ; B072 99 00 F5                 ...
        brk                                     ; B075 00                       .
        ldy     $D4,x                           ; B076 B4 D4                    ..
        sbc     ($F3),y                         ; B078 F1 F3                    ..
        sta     L0000,y                         ; B07A 99 00 00                 ...
        brk                                     ; B07D 00                       .
        ldy     $C4,x                           ; B07E B4 C4                    ..
        lda     LBBBB,y                         ; B080 B9 BB BB                 ...
        .byte   $BB                             ; B083 BB                       .
        lda     L0000,x                         ; B084 B5 00                    ..
        .byte   $B7                             ; B086 B7                       .
        brk                                     ; B087 00                       .
        cmp     $D9DB,y                         ; B088 D9 DB D9                 ...
        .byte   $DB                             ; B08B DB                       .
        lda     $C4,x                           ; B08C B5 C4                    ..
        .byte   $B7                             ; B08E B7                       .
        brk                                     ; B08F 00                       .
        cmp     LB9DB,y                         ; B090 D9 DB B9                 ...
        .byte   $DB                             ; B093 DB                       .
        .byte   $B7                             ; B094 B7                       .
        .byte   $B7                             ; B095 B7                       .
        .byte   $B7                             ; B096 B7                       .
        brk                                     ; B097 00                       .
        brk                                     ; B098 00                       .
        brk                                     ; B099 00                       .
        cmp     $DB,y                           ; B09A D9 DB 00                 ...
        brk                                     ; B09D 00                       .
        brk                                     ; B09E 00                       .
        brk                                     ; B09F 00                       .
        sta     $9D9F,x                         ; B0A0 9D 9F 9D                 ...
        .byte   $9F                             ; B0A3 9F                       .
        brk                                     ; B0A4 00                       .
        brk                                     ; B0A5 00                       .
        brk                                     ; B0A6 00                       .
        cmp     $CD,x                           ; B0A7 D5 CD                    ..
        .byte   $CF                             ; B0A9 CF                       .
        .byte   $BD                             ; B0AA BD                       .
        .byte   $BF                             ; B0AB BF                       .
LB0AC:  brk                                     ; B0AC 00                       .
        brk                                     ; B0AD 00                       .
        brk                                     ; B0AE 00                       .
        cmp     $BD,x                           ; B0AF D5 BD                    ..
        .byte   $BF                             ; B0B1 BF                       .
        cmp     a:$CF                           ; B0B2 CD CF 00                 ...
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
        ora     $1D1B,y                         ; B0C0 19 1B 1D                 ...
        .byte   $1F                             ; B0C3 1F                       .
        brk                                     ; B0C4 00                       .
        brk                                     ; B0C5 00                       .
        eor     $295F,x                         ; B0C6 5D 5F 29                 ]_)
        .byte   $2B                             ; B0C9 2B                       +
        and     a:$2F                           ; B0CA 2D 2F 00                 -/.
        brk                                     ; B0CD 00                       .
        adc     $957F,x                         ; B0CE 7D 7F 95                 }..
        sta     L0000,x                         ; B0D1 95 00                    ..
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
        .byte   $FF                             ; B0E0 FF                       .
        cmp     ($D3),y                         ; B0E1 D1 D3                    ..
        cmp     L0000,x                         ; B0E3 D5 00                    ..
        brk                                     ; B0E5 00                       .
        brk                                     ; B0E6 00                       .
        brk                                     ; B0E7 00                       .
        .byte   $9F                             ; B0E8 9F                       .
        sbc     ($F3),y                         ; B0E9 F1 F3                    ..
        sbc     L0000,x                         ; B0EB F5 00                    ..
        brk                                     ; B0ED 00                       .
        brk                                     ; B0EE 00                       .
        brk                                     ; B0EF 00                       .
        brk                                     ; B0F0 00                       .
        brk                                     ; B0F1 00                       .
        brk                                     ; B0F2 00                       .
        brk                                     ; B0F3 00                       .
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
        brk                                     ; B101 00                       .
        .byte   $23                             ; B102 23                       #
        .byte   $F3                             ; B103 F3                       .
        ora     ($01,x)                         ; B104 01 01                    ..
        bpl     LB108                           ; B106 10 00                    ..
LB108:  .byte   $43                             ; B108 43                       C
        brk                                     ; B109 00                       .
        .byte   $03                             ; B10A 03                       .
        ora     ($01,x)                         ; B10B 01 01                    ..
        ora     ($10,x)                         ; B10D 01 10                    ..
        .byte   $02                             ; B10F 02                       .
        bpl     LB113                           ; B110 10 01                    ..
        .byte   $01                             ; B112 01                       .
LB113:  bpl     LB125                           ; B113 10 10                    ..
        bpl     LB127                           ; B115 10 10                    ..
        bpl     LB129                           ; B117 10 10                    ..
        ora     ($01,x)                         ; B119 01 01                    ..
        bpl     LB12D                           ; B11B 10 10                    ..
        bpl     LB12F                           ; B11D 10 10                    ..
        bpl     LB131                           ; B11F 10 10                    ..
        bpl     LB133                           ; B121 10 10                    ..
        bpl     LB135                           ; B123 10 10                    ..
LB125:  bpl     LB137                           ; B125 10 10                    ..
LB127:  bpl     LB139                           ; B127 10 10                    ..
LB129:  bpl     LB13B                           ; B129 10 10                    ..
        bpl     LB13D                           ; B12B 10 10                    ..
LB12D:  bpl     LB13F                           ; B12D 10 10                    ..
LB12F:  bpl     LB144                           ; B12F 10 13                    ..
LB131:  .byte   $13                             ; B131 13                       .
        .byte   $13                             ; B132 13                       .
LB133:  bpl     LB145                           ; B133 10 10                    ..
LB135:  bpl     LB147                           ; B135 10 10                    ..
LB137:  bpl     LB14C                           ; B137 10 13                    ..
LB139:  .byte   $13                             ; B139 13                       .
        .byte   $13                             ; B13A 13                       .
LB13B:  bpl     LB14D                           ; B13B 10 10                    ..
LB13D:  bpl     LB14F                           ; B13D 10 10                    ..
LB13F:  bpl     LB142                           ; B13F 10 01                    ..
        .byte   $01                             ; B141 01                       .
LB142:  ora     ($01,x)                         ; B142 01 01                    ..
LB144:  .byte   $01                             ; B144 01                       .
LB145:  ora     ($01,x)                         ; B145 01 01                    ..
LB147:  ora     ($01,x)                         ; B147 01 01                    ..
        ora     ($01,x)                         ; B149 01 01                    ..
        .byte   $01                             ; B14B 01                       .
LB14C:  .byte   $01                             ; B14C 01                       .
LB14D:  brk                                     ; B14D 00                       .
        .byte   $01                             ; B14E 01                       .
LB14F:  ora     ($01,x)                         ; B14F 01 01                    ..
        ora     ($01,x)                         ; B151 01 01                    ..
        ora     ($01,x)                         ; B153 01 01                    ..
        ora     ($01,x)                         ; B155 01 01                    ..
        brk                                     ; B157 00                       .
        ora     ($01,x)                         ; B158 01 01                    ..
        bpl     LB15D                           ; B15A 10 01                    ..
        .byte   $10                             ; B15C 10                       .
LB15D:  bpl     LB160                           ; B15D 10 01                    ..
        .byte   $01                             ; B15F 01                       .
LB160:  bpl     LB172                           ; B160 10 10                    ..
        bpl     LB166                           ; B162 10 02                    ..
        .byte   $02                             ; B164 02                       .
        .byte   $02                             ; B165 02                       .
LB166:  .byte   $02                             ; B166 02                       .
        .byte   $02                             ; B167 02                       .
        bpl     LB17A                           ; B168 10 10                    ..
        bpl     LB16C                           ; B16A 10 00                    ..
LB16C:  .byte   $02                             ; B16C 02                       .
        .byte   $02                             ; B16D 02                       .
        .byte   $02                             ; B16E 02                       .
        .byte   $02                             ; B16F 02                       .
        bpl     LB182                           ; B170 10 10                    ..
LB172:  bpl     LB174                           ; B172 10 00                    ..
LB174:  .byte   $02                             ; B174 02                       .
        brk                                     ; B175 00                       .
        .byte   $02                             ; B176 02                       .
        .byte   $02                             ; B177 02                       .
        bpl     LB18A                           ; B178 10 10                    ..
LB17A:  bpl     LB17C                           ; B17A 10 00                    ..
LB17C:  .byte   $02                             ; B17C 02                       .
        brk                                     ; B17D 00                       .
        .byte   $02                             ; B17E 02                       .
        .byte   $02                             ; B17F 02                       .
        .byte   $02                             ; B180 02                       .
        .byte   $02                             ; B181 02                       .
LB182:  .byte   $02                             ; B182 02                       .
        .byte   $02                             ; B183 02                       .
        .byte   $02                             ; B184 02                       .
        brk                                     ; B185 00                       .
        .byte   $02                             ; B186 02                       .
        bpl     LB18B                           ; B187 10 02                    ..
        .byte   $02                             ; B189 02                       .
LB18A:  .byte   $02                             ; B18A 02                       .
LB18B:  .byte   $02                             ; B18B 02                       .
        .byte   $02                             ; B18C 02                       .
        .byte   $02                             ; B18D 02                       .
        .byte   $02                             ; B18E 02                       .
        brk                                     ; B18F 00                       .
        .byte   $02                             ; B190 02                       .
        .byte   $02                             ; B191 02                       .
        .byte   $02                             ; B192 02                       .
        .byte   $02                             ; B193 02                       .
        .byte   $02                             ; B194 02                       .
        .byte   $02                             ; B195 02                       .
        .byte   $02                             ; B196 02                       .
        brk                                     ; B197 00                       .
        brk                                     ; B198 00                       .
        bpl     LB19D                           ; B199 10 02                    ..
        .byte   $02                             ; B19B 02                       .
        .byte   $10                             ; B19C 10                       .
LB19D:  bpl     LB1AF                           ; B19D 10 10                    ..
        bpl     LB1B1                           ; B19F 10 10                    ..
        bpl     LB1B3                           ; B1A1 10 10                    ..
        bpl     LB1A5                           ; B1A3 10 00                    ..
LB1A5:  bpl     LB1A7                           ; B1A5 10 00                    ..
LB1A7:  .byte   $02                             ; B1A7 02                       .
        bpl     LB1BA                           ; B1A8 10 10                    ..
        bpl     LB1BC                           ; B1AA 10 10                    ..
        brk                                     ; B1AC 00                       .
        bpl     LB1AF                           ; B1AD 10 00                    ..
LB1AF:  .byte   $02                             ; B1AF 02                       .
        .byte   $10                             ; B1B0 10                       .
LB1B1:  bpl     LB1C3                           ; B1B1 10 10                    ..
LB1B3:  bpl     LB1B5                           ; B1B3 10 00                    ..
LB1B5:  brk                                     ; B1B5 00                       .
        brk                                     ; B1B6 00                       .
        brk                                     ; B1B7 00                       .
        brk                                     ; B1B8 00                       .
        brk                                     ; B1B9 00                       .
LB1BA:  brk                                     ; B1BA 00                       .
        brk                                     ; B1BB 00                       .
LB1BC:  brk                                     ; B1BC 00                       .
        brk                                     ; B1BD 00                       .
        brk                                     ; B1BE 00                       .
        brk                                     ; B1BF 00                       .
        .byte   $13                             ; B1C0 13                       .
        .byte   $13                             ; B1C1 13                       .
        .byte   $13                             ; B1C2 13                       .
LB1C3:  .byte   $13                             ; B1C3 13                       .
        brk                                     ; B1C4 00                       .
        brk                                     ; B1C5 00                       .
        .byte   $13                             ; B1C6 13                       .
        .byte   $13                             ; B1C7 13                       .
        .byte   $13                             ; B1C8 13                       .
        .byte   $13                             ; B1C9 13                       .
        .byte   $13                             ; B1CA 13                       .
        .byte   $13                             ; B1CB 13                       .
        brk                                     ; B1CC 00                       .
        brk                                     ; B1CD 00                       .
        .byte   $13                             ; B1CE 13                       .
        .byte   $13                             ; B1CF 13                       .
        bpl     LB1E2                           ; B1D0 10 10                    ..
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
        and     ($11),y                         ; B1E0 31 11                    1.
LB1E2:  ora     ($11),y                         ; B1E2 11 11                    ..
        brk                                     ; B1E4 00                       .
        brk                                     ; B1E5 00                       .
        brk                                     ; B1E6 00                       .
        brk                                     ; B1E7 00                       .
        .byte   $F3                             ; B1E8 F3                       .
        ora     ($11),y                         ; B1E9 11 11                    ..
        ora     (L0000),y                       ; B1EB 11 00                    ..
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
        .byte   $47                             ; B200 47                       G
        .byte   $47                             ; B201 47                       G
        ora     ($12),y                         ; B202 11 12                    ..
        .byte   $47                             ; B204 47                       G
        .byte   $47                             ; B205 47                       G
        .byte   $1A                             ; B206 1A                       .
        ora     $1247,y                         ; B207 19 47 12                 .G.
        .byte   $1A                             ; B20A 1A                       .
        rti                                     ; B20B 40                       @

; ----------------------------------------------------------------------------
        ora     ($47),y                         ; B20C 11 47                    .G
        rti                                     ; B20E 40                       @

; ----------------------------------------------------------------------------
        ora     $401A,y                         ; B20F 19 1A 40                 ..@
        rti                                     ; B212 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B213 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B214 40                       @

; ----------------------------------------------------------------------------
        ora     $4040,y                         ; B215 19 40 40                 .@@
        rti                                     ; B218 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B219 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B21A 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B21B 40                       @

; ----------------------------------------------------------------------------
        cli                                     ; B21C 58                       X
        eor     $4040,y                         ; B21D 59 40 40                 Y@@
        rti                                     ; B220 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B221 40                       @

; ----------------------------------------------------------------------------
        .byte   $4B                             ; B222 4B                       K
        eor     $404B,y                         ; B223 59 4B 40                 YK@
        eor     ($5B),y                         ; B226 51 5B                    Q[
        eor     ($4E),y                         ; B228 51 4E                    QN
        .byte   $42                             ; B22A 42                       B
        .byte   $42                             ; B22B 42                       B
        rti                                     ; B22C 40                       @

; ----------------------------------------------------------------------------
        eor     ($43,x)                         ; B22D 41 43                    AC
        eor     #$40                            ; B22F 49 40                    I@
        .byte   $4B                             ; B231 4B                       K
        .byte   $43                             ; B232 43                       C
        .byte   $42                             ; B233 42                       B
        .byte   $5B                             ; B234 5B                       [
        .byte   $52                             ; B235 52                       R
        .byte   $42                             ; B236 42                       B
        .byte   $42                             ; B237 42                       B
        eor     ($51),y                         ; B238 51 51                    QQ
        .byte   $42                             ; B23A 42                       B
        .byte   $42                             ; B23B 42                       B
        jmp     L425B                           ; B23C 4C 5B 42                 L[B

; ----------------------------------------------------------------------------
        .byte   $42                             ; B23F 42                       B
        jmp     L4240                           ; B240 4C 40 42                 L@B

; ----------------------------------------------------------------------------
        .byte   $43                             ; B243 43                       C
        bvc     LB296                           ; B244 50 50                    PP
        ora     $51                             ; B246 05 51                    .Q
        bvc     LB293                           ; B248 50 49                    PI
        eor     ($49),y                         ; B24A 51 49                    QI
        bvc     LB29E                           ; B24C 50 50                    PP
        eor     ($51),y                         ; B24E 51 51                    QQ
        bvc     LB2A2                           ; B250 50 50                    PP
        eor     ($20),y                         ; B252 51 20                    Q 
        bvc     LB29F                           ; B254 50 49                    PI
        and     ($22,x)                         ; B256 21 22                    !"
        bit     $25                             ; B258 24 25                    $%
        bit     $242D                           ; B25A 2C 2D 24                 ,-$
        and     $34                             ; B25D 25 34                    %4
        and     $24,x                           ; B25F 35 24                    5$
        and     $35                             ; B261 25 35                    %5
        rol     $15,x                           ; B263 36 15                    6.
        .byte   $1F                             ; B265 1F                       .
        .byte   $37                             ; B266 37                       7
        asl     $2726,x                         ; B267 1E 26 27                 .&'
        rol     $372F                           ; B26A 2E 2F 37                 ./7
        .byte   $37                             ; B26D 37                       7
        .byte   $37                             ; B26E 37                       7
        .byte   $37                             ; B26F 37                       7
        .byte   $3C                             ; B270 3C                       <
        brk                                     ; B271 00                       .
        and     a:L0000,x                       ; B272 3D 00 00                 =..
        rol     $3F00,x                         ; B275 3E 00 3F                 >.?
        .byte   $37                             ; B278 37                       7
        asl     $1E37,x                         ; B279 1E 37 1E                 .7.
        rti                                     ; B27C 40                       @

; ----------------------------------------------------------------------------
        .byte   $5B                             ; B27D 5B                       [
        .byte   $B2                             ; B27E B2                       .
        .byte   $B3                             ; B27F B3                       .
        jsr     L2821                           ; B280 20 21 28                  !(
        and     #$50                            ; B283 29 50                    )P
        bvc     LB29A                           ; B285 50 13                    P.
        ora     $50,x                           ; B287 15 50                    .P
        bvc     LB2A1                           ; B289 50 16                    P.
        and     ($50,x)                         ; B28B 21 50                    !P
        bvc     LB2B1                           ; B28D 50 22                    P"
        .byte   $23                             ; B28F 23                       #
        .byte   $22                             ; B290 22                       "
        .byte   $13                             ; B291 13                       .
        rol     a                               ; B292 2A                       *
LB293:  .byte   $1B                             ; B293 1B                       .
        .byte   $1F                             ; B294 1F                       .
        .byte   $26                             ; B295 26                       &
LB296:  asl     $1B2E,x                         ; B296 1E 2E 1B                 ...
        .byte   $37                             ; B299 37                       7
LB29A:  .byte   $1B                             ; B29A 1B                       .
        .byte   $37                             ; B29B 37                       7
        .byte   $1E                             ; B29C 1E                       .
        .byte   $26                             ; B29D 26                       &
LB29E:  .byte   $1E                             ; B29E 1E                       .
LB29F:  .byte   $2E                             ; B29F 2E                       .
        .byte   $27                             ; B2A0 27                       '
LB2A1:  .byte   $2B                             ; B2A1 2B                       +
LB2A2:  .byte   $2F                             ; B2A2 2F                       /
        .byte   $2B                             ; B2A3 2B                       +
        eor     ($51),y                         ; B2A4 51 51                    QQ
        .byte   $4F                             ; B2A6 4F                       O
        .byte   $4F                             ; B2A7 4F                       O
        plp                                     ; B2A8 28                       (
        rol     $28                             ; B2A9 26 28                    &(
        rol     $1C27                           ; B2AB 2E 27 1C                 .'.
        .byte   $2F                             ; B2AE 2F                       /
        .byte   $1B                             ; B2AF 1B                       .
        brk                                     ; B2B0 00                       .
LB2B1:  brk                                     ; B2B1 00                       .
        brk                                     ; B2B2 00                       .
        brk                                     ; B2B3 00                       .
        .byte   $22                             ; B2B4 22                       "
        .byte   $23                             ; B2B5 23                       #
        rol     a                               ; B2B6 2A                       *
        .byte   $2B                             ; B2B7 2B                       +
        rti                                     ; B2B8 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B2B9 40                       @

; ----------------------------------------------------------------------------
        .byte   $43                             ; B2BA 43                       C
        .byte   $43                             ; B2BB 43                       C
        bvc     LB30E                           ; B2BC 50 50                    PP
        .byte   $20,$21,$A0                     ; B2BE 20 21 A0                  !.
        lda     ($A8,x)                         ; B2C1 A1 A8                    ..
        lda     #$A2                            ; B2C3 A9 A2                    ..
        .byte   $A3                             ; B2C5 A3                       .
        tay                                     ; B2C6 A8                       .
        lda     #$28                            ; B2C7 A9 28                    .(
        and     #$28                            ; B2C9 29 28                    )(
        and     #$A0                            ; B2CB 29 A0                    ).
        lda     ($A2,x)                         ; B2CD A1 A2                    ..
        .byte   $A3                             ; B2CF A3                       .
        asl     $21,x                           ; B2D0 16 21                    .!
        asl     $2429,x                         ; B2D2 1E 29 24                 .)$
        and     $37                             ; B2D5 25 37                    %7
        .byte   $34                             ; B2D7 34                       4
        bit     $25                             ; B2D8 24 25                    $%
        and     $35,x                           ; B2DA 35 35                    55
        bit     $25                             ; B2DC 24 25                    $%
        rol     $2C,x                           ; B2DE 36 2C                    6,
        bit     $25                             ; B2E0 24 25                    $%
        and     $2434                           ; B2E2 2D 34 24                 -4$
        and     $36                             ; B2E5 25 36                    %6
        .byte   $37                             ; B2E7 37                       7
        rol     a                               ; B2E8 2A                       *
LB2E9:  .byte   $1B                             ; B2E9 1B                       .
        rol     a                               ; B2EA 2A                       *
        .byte   $1B                             ; B2EB 1B                       .
        .byte   $37                             ; B2EC 37                       7
        .byte   $3C                             ; B2ED 3C                       <
        .byte   $37                             ; B2EE 37                       7
        and     $373E,x                         ; B2EF 3D 3E 37                 =>7
        .byte   $3F                             ; B2F2 3F                       ?
        .byte   $37                             ; B2F3 37                       7
        asl     $1E29,x                         ; B2F4 1E 29 1E                 .).
        and     #$60                            ; B2F7 29 60                    )`
        adc     ($68,x)                         ; B2F9 61 68                    ah
        adc     #$61                            ; B2FB 69 61                    ia
        adc     ($69,x)                         ; B2FD 61 69                    ai
        .byte   $69                             ; B2FF 69                       i
LB300:  rts                                     ; B300 60                       `

; ----------------------------------------------------------------------------
        adc     ($40,x)                         ; B301 61 40                    a@
LB303:  ror     $6161                           ; B303 6E 61 61                 naa
        adc     $616D                           ; B306 6D 6D 61                 mma
        adc     ($8A,x)                         ; B309 61 8A                    a.
        .byte   $8B                             ; B30B 8B                       .
        rti                                     ; B30C 40                       @

; ----------------------------------------------------------------------------
        .byte   $66                             ; B30D 66                       f
LB30E:  rti                                     ; B30E 40                       @

; ----------------------------------------------------------------------------
        ror     $65                             ; B30F 66 65                    fe
        adc     $65                             ; B311 65 65                    ee
        adc     $90                             ; B313 65 90                    e.
        sta     ($90),y                         ; B315 91 90                    ..
        sta     ($92),y                         ; B317 91 92                    ..
        .byte   $93                             ; B319 93                       .
        txs                                     ; B31A 9A                       .
        .byte   $9B                             ; B31B 9B                       .
        rti                                     ; B31C 40                       @

; ----------------------------------------------------------------------------
        ror     $68                             ; B31D 66 68                    fh
        adc     #$65                            ; B31F 69 65                    ie
        adc     $69                             ; B321 65 69                    ei
        adc     #$90                            ; B323 69 90                    i.
        sta     ($69),y                         ; B325 91 69                    .i
        adc     #$70                            ; B327 69 70                    ip
        adc     ($78),y                         ; B329 71 78                    qx
        adc     $2B2A,y                         ; B32B 79 2A 2B                 y*+
        rol     a                               ; B32E 2A                       *
        .byte   $2B                             ; B32F 2B                       +
        bne     LB303                           ; B330 D0 D1                    ..
        adc     #$69                            ; B332 69 69                    ii
        adc     ($62,x)                         ; B334 61 62                    ab
        adc     #$6A                            ; B336 69 6A                    ij
        adc     $656D                           ; B338 6D 6D 65                 mme
        adc     $02                             ; B33B 65 02                    e.
        rts                                     ; B33D 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; B33E 02                       .
        pla                                     ; B33F 68                       h
        adc     ($62,x)                         ; B340 61 62                    ab
        adc     $826D                           ; B342 6D 6D 82                 mm.
        .byte   $82                             ; B345 82                       .
        adc     $65                             ; B346 65 65                    ee
        .byte   $80                             ; B348 80                       .
        sta     ($88,x)                         ; B349 81 88                    ..
        .byte   $89                             ; B34B 89                       .
        adc     $65                             ; B34C 65 65                    ee
        rts                                     ; B34E 60                       `

; ----------------------------------------------------------------------------
        adc     ($65,x)                         ; B34F 61 65                    ae
        adc     $61                             ; B351 65 61                    ea
        .byte   $62                             ; B353 62                       b
        txa                                     ; B354 8A                       .
        .byte   $8B                             ; B355 8B                       .
        bcc     LB2E9                           ; B356 90 91                    ..
        adc     $65                             ; B358 65 65                    ee
        adc     #$6A                            ; B35A 69 6A                    ij
        .byte   $92                             ; B35C 92                       .
        sta     ($9A,x)                         ; B35D 81 9A                    ..
        .byte   $89                             ; B35F 89                       .
        .byte   $02                             ; B360 02                       .
        rts                                     ; B361 60                       `

; ----------------------------------------------------------------------------
        adc     $68                             ; B362 65 68                    eh
        adc     ($62,x)                         ; B364 61 62                    ab
        adc     #$69                            ; B366 69 69                    ii
        adc     $65                             ; B368 65 65                    ee
        pla                                     ; B36A 68                       h
        adc     #$90                            ; B36B 69 90                    i.
        sta     ($69),y                         ; B36D 91 69                    .i
        ror     a                               ; B36F 6A                       j
        adc     $60                             ; B370 65 60                    e`
        adc     $68                             ; B372 65 68                    eh
        rts                                     ; B374 60                       `

; ----------------------------------------------------------------------------
        bvs     LB3DF                           ; B375 70 68                    ph
        sei                                     ; B377 78                       x
        adc     ($62),y                         ; B378 71 62                    qb
        adc     $656A,y                         ; B37A 79 6A 65                 yje
        adc     $74                             ; B37D 65 74                    et
        .byte   $74                             ; B37F 74                       t
        rts                                     ; B380 60                       `

; ----------------------------------------------------------------------------
        bne     LB3EB                           ; B381 D0 68                    .h
        adc     #$D1                            ; B383 69 D1                    i.
        .byte   $62                             ; B385 62                       b
        adc     #$6A                            ; B386 69 6A                    ij
        adc     #$6A                            ; B388 69 6A                    ij
        adc     ($62,x)                         ; B38A 61 62                    ab
        .byte   $02                             ; B38C 02                       .
        pla                                     ; B38D 68                       h
        .byte   $02                             ; B38E 02                       .
        rts                                     ; B38F 60                       `

; ----------------------------------------------------------------------------
        adc     #$69                            ; B390 69 69                    ii
        adc     ($61,x)                         ; B392 61 61                    aa
        .byte   $02                             ; B394 02                       .
        .byte   $63                             ; B395 63                       c
        .byte   $02                             ; B396 02                       .
        .byte   $67                             ; B397 67                       g
        .byte   $63                             ; B398 63                       c
        .byte   $63                             ; B399 63                       c
        .byte   $67                             ; B39A 67                       g
        .byte   $67                             ; B39B 67                       g
        .byte   $63                             ; B39C 63                       c
        pla                                     ; B39D 68                       h
        .byte   $67                             ; B39E 67                       g
        rts                                     ; B39F 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; B3A0 02                       .
        .byte   $6F                             ; B3A1 6F                       o
        .byte   $77                             ; B3A2 77                       w
        .byte   $77                             ; B3A3 77                       w
        .byte   $6F                             ; B3A4 6F                       o
        .byte   $6F                             ; B3A5 6F                       o
        .byte   $77                             ; B3A6 77                       w
        .byte   $77                             ; B3A7 77                       w
        .byte   $6F                             ; B3A8 6F                       o
        pla                                     ; B3A9 68                       h
        .byte   $77                             ; B3AA 77                       w
        rts                                     ; B3AB 60                       `

; ----------------------------------------------------------------------------
        adc     $68                             ; B3AC 65 68                    eh
        adc     $60                             ; B3AE 65 60                    e`
        .byte   $82                             ; B3B0 82                       .
LB3B1:  pla                                     ; B3B1 68                       h
        adc     $60                             ; B3B2 65 60                    e`
        adc     #$6A                            ; B3B4 69 6A                    ij
        adc     ($61,x)                         ; B3B6 61 61                    aa
        adc     $60                             ; B3B8 65 60                    e`
        adc     $6D                             ; B3BA 65 6D                    em
        .byte   $62                             ; B3BC 62                       b
        .byte   $82                             ; B3BD 82                       .
        adc     $6065                           ; B3BE 6D 65 60                 me`
        .byte   $62                             ; B3C1 62                       b
        adc     $086D                           ; B3C2 6D 6D 08                 mm.
        pla                                     ; B3C5 68                       h
        .byte   $02                             ; B3C6 02                       .
        rts                                     ; B3C7 60                       `

; ----------------------------------------------------------------------------
        adc     #$6A                            ; B3C8 69 6A                    ij
        adc     $616D                           ; B3CA 6D 6D 61                 mma
        adc     ($6A,x)                         ; B3CD 61 6A                    aj
        .byte   $8B                             ; B3CF 8B                       .
        adc     ($61,x)                         ; B3D0 61 61                    aa
        .byte   $63                             ; B3D2 63                       c
        .byte   $63                             ; B3D3 63                       c
        .byte   $62                             ; B3D4 62                       b
        .byte   $3A                             ; B3D5 3A                       :
        .byte   $63                             ; B3D6 63                       c
        sec                                     ; B3D7 38                       8
        rts                                     ; B3D8 60                       `

; ----------------------------------------------------------------------------
        adc     ($39,x)                         ; B3D9 61 39                    a9
LB3DB:  and     $6261,y                         ; B3DB 39 61 62                 9ab
        .byte   $39                             ; B3DE 39                       9
LB3DF:  and     $603A,y                         ; B3DF 39 3A 60                 9:`
        sec                                     ; B3E2 38                       8
        .byte   $63                             ; B3E3 63                       c
        .byte   $62                             ; B3E4 62                       b
        sta     ($6A,x)                         ; B3E5 81 6A                    .j
        .byte   $89                             ; B3E7 89                       .
        .byte   $83                             ; B3E8 83                       .
        .byte   $83                             ; B3E9 83                       .
        .byte   $67                             ; B3EA 67                       g
LB3EB:  .byte   $67                             ; B3EB 67                       g
        .byte   $83                             ; B3EC 83                       .
        .byte   $3A                             ; B3ED 3A                       :
        .byte   $67                             ; B3EE 67                       g
        sec                                     ; B3EF 38                       8
        .byte   $3A                             ; B3F0 3A                       :
        .byte   $83                             ; B3F1 83                       .
        sec                                     ; B3F2 38                       8
        .byte   $67                             ; B3F3 67                       g
        .byte   $62                             ; B3F4 62                       b
        .byte   $63                             ; B3F5 63                       c
        ror     a                               ; B3F6 6A                       j
        .byte   $67                             ; B3F7 67                       g
        txa                                     ; B3F8 8A                       .
        sta     ($90),y                         ; B3F9 91 90                    ..
        sta     ($67),y                         ; B3FB 91 67                    .g
        .byte   $67                             ; B3FD 67                       g
        .byte   $67                             ; B3FE 67                       g
        sec                                     ; B3FF 38                       8
        .byte   $67                             ; B400 67                       g
        .byte   $63                             ; B401 63                       c
        and     $6738,y                         ; B402 39 38 67                 98g
        .byte   $67                             ; B405 67                       g
        and     $9039,y                         ; B406 39 39 90                 99.
        sta     ($39),y                         ; B409 91 39                    .9
        and     $6763,y                         ; B40B 39 63 67                 9cg
        sec                                     ; B40E 38                       8
        .byte   $67                             ; B40F 67                       g
        .byte   $67                             ; B410 67                       g
        .byte   $67                             ; B411 67                       g
        .byte   $67                             ; B412 67                       g
        .byte   $67                             ; B413 67                       g
        .byte   $62                             ; B414 62                       b
        .byte   $67                             ; B415 67                       g
        ror     a                               ; B416 6A                       j
        .byte   $67                             ; B417 67                       g
        .byte   $67                             ; B418 67                       g
        .byte   $63                             ; B419 63                       c
        .byte   $67                             ; B41A 67                       g
        .byte   $67                             ; B41B 67                       g
        .byte   $63                             ; B41C 63                       c
        .byte   $67                             ; B41D 67                       g
        .byte   $67                             ; B41E 67                       g
        .byte   $67                             ; B41F 67                       g
        .byte   $62                             ; B420 62                       b
        .byte   $83                             ; B421 83                       .
        ror     a                               ; B422 6A                       j
        .byte   $67                             ; B423 67                       g
        .byte   $80                             ; B424 80                       .
        .byte   $93                             ; B425 93                       .
        dey                                     ; B426 88                       .
        .byte   $9B                             ; B427 9B                       .
        .byte   $67                             ; B428 67                       g
        .byte   $67                             ; B429 67                       g
        sec                                     ; B42A 38                       8
        and     $6008,y                         ; B42B 39 08 60                 9.`
        .byte   $02                             ; B42E 02                       .
        pla                                     ; B42F 68                       h
        adc     ($61,x)                         ; B430 61 61                    aa
        ora     ($12),y                         ; B432 11 12                    ..
        adc     ($62,x)                         ; B434 61 62                    ab
        .byte   $1A                             ; B436 1A                       .
        rti                                     ; B437 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; B438 80                       .
        .byte   $93                             ; B439 93                       .
        txs                                     ; B43A 9A                       .
        .byte   $9B                             ; B43B 9B                       .
        rti                                     ; B43C 40                       @

; ----------------------------------------------------------------------------
        stx     $95                             ; B43D 86 95                    ..
        stx     $95,y                           ; B43F 96 95                    ..
        sta     $67,x                           ; B441 95 67                    .g
        .byte   $67                             ; B443 67                       g
        sty     $40                             ; B444 84 40                    .@
        sty     $95,x                           ; B446 94 95                    ..
        bcc     LB3DB                           ; B448 90 91                    ..
        and     $6738,y                         ; B44A 39 38 67                 98g
        .byte   $67                             ; B44D 67                       g
        pla                                     ; B44E 68                       h
        adc     #$67                            ; B44F 69 67                    ig
        .byte   $67                             ; B451 67                       g
        adc     #$6A                            ; B452 69 6A                    ij
        .byte   $67                             ; B454 67                       g
        rts                                     ; B455 60                       `

; ----------------------------------------------------------------------------
        .byte   $67                             ; B456 67                       g
        .byte   $63                             ; B457 63                       c
        .byte   $7C                             ; B458 7C                       |
        .byte   $7C                             ; B459 7C                       |
        .byte   $03                             ; B45A 03                       .
        .byte   $03                             ; B45B 03                       .
        rts                                     ; B45C 60                       `

; ----------------------------------------------------------------------------
        .byte   $62                             ; B45D 62                       b
        pla                                     ; B45E 68                       h
        ror     a                               ; B45F 6A                       j
        adc     ($62,x)                         ; B460 61 62                    ab
        pla                                     ; B462 68                       h
        ror     a                               ; B463 6A                       j
        .byte   $67                             ; B464 67                       g
        .byte   $67                             ; B465 67                       g
        sec                                     ; B466 38                       8
        sec                                     ; B467 38                       8
        .byte   $67                             ; B468 67                       g
        sec                                     ; B469 38                       8
        and     $3938,y                         ; B46A 39 38 39                 989
        and     $6363,y                         ; B46D 39 63 63                 9cc
        .byte   $63                             ; B470 63                       c
        sec                                     ; B471 38                       8
        .byte   $67                             ; B472 67                       g
        .byte   $63                             ; B473 63                       c
        and     $6338,y                         ; B474 39 38 63                 98c
        .byte   $63                             ; B477 63                       c
        and     $3838,y                         ; B478 39 38 38                 988
        and     $6040,y                         ; B47B 39 40 60                 9@`
        rti                                     ; B47E 40                       @

; ----------------------------------------------------------------------------
        pla                                     ; B47F 68                       h
        sec                                     ; B480 38                       8
        sec                                     ; B481 38                       8
        .byte   $3A                             ; B482 3A                       :
        .byte   $3A                             ; B483 3A                       :
        sta     $60,x                           ; B484 95 60                    .`
        .byte   $67                             ; B486 67                       g
        pla                                     ; B487 68                       h
        .byte   $3A                             ; B488 3A                       :
        .byte   $3A                             ; B489 3A                       :
        sec                                     ; B48A 38                       8
        sec                                     ; B48B 38                       8
        .byte   $83                             ; B48C 83                       .
        rts                                     ; B48D 60                       `

; ----------------------------------------------------------------------------
        .byte   $67                             ; B48E 67                       g
        pla                                     ; B48F 68                       h
        .byte   $67                             ; B490 67                       g
        .byte   $67                             ; B491 67                       g
        adc     #$69                            ; B492 69 69                    ii
        tay                                     ; B494 A8                       .
        lda     #$69                            ; B495 A9 69                    .i
LB497:  adc     #$A8                            ; B497 69 A8                    i.
        lda     #$69                            ; B499 A9 69                    .i
        ror     a                               ; B49B 6A                       j
        .byte   $67                             ; B49C 67                       g
        rts                                     ; B49D 60                       `

; ----------------------------------------------------------------------------
        .byte   $67                             ; B49E 67                       g
        pla                                     ; B49F 68                       h
        .byte   $67                             ; B4A0 67                       g
        .byte   $67                             ; B4A1 67                       g
        .byte   $67                             ; B4A2 67                       g
        pla                                     ; B4A3 68                       h
        .byte   $67                             ; B4A4 67                       g
        rts                                     ; B4A5 60                       `

; ----------------------------------------------------------------------------
        adc     #$69                            ; B4A6 69 69                    ii
        .byte   $67                             ; B4A8 67                       g
        .byte   $67                             ; B4A9 67                       g
        .byte   $6F                             ; B4AA 6F                       o
        .byte   $6F                             ; B4AB 6F                       o
        .byte   $67                             ; B4AC 67                       g
        .byte   $63                             ; B4AD 63                       c
        .byte   $6F                             ; B4AE 6F                       o
        .byte   $6F                             ; B4AF 6F                       o
        .byte   $63                             ; B4B0 63                       c
        rts                                     ; B4B1 60                       `

; ----------------------------------------------------------------------------
        .byte   $6F                             ; B4B2 6F                       o
        pla                                     ; B4B3 68                       h
        .byte   $7F                             ; B4B4 7F                       .
        .byte   $7F                             ; B4B5 7F                       .
        .byte   $7F                             ; B4B6 7F                       .
        .byte   $7F                             ; B4B7 7F                       .
        .byte   $7F                             ; B4B8 7F                       .
        rts                                     ; B4B9 60                       `

; ----------------------------------------------------------------------------
        .byte   $7F                             ; B4BA 7F                       .
        pla                                     ; B4BB 68                       h
        .byte   $77                             ; B4BC 77                       w
        .byte   $77                             ; B4BD 77                       w
        adc     $65                             ; B4BE 65 65                    ee
        .byte   $77                             ; B4C0 77                       w
        pla                                     ; B4C1 68                       h
        adc     $60                             ; B4C2 65 60                    e`
        bne     LB497                           ; B4C4 D0 D1                    ..
        adc     ($61,x)                         ; B4C6 61 61                    aa
        .byte   $69                             ; B4C8 69                       i
LB4C9:  adc     #$61                            ; B4C9 69 61                    ia
        .byte   $62                             ; B4CB 62                       b
        .byte   $82                             ; B4CC 82                       .
        pla                                     ; B4CD 68                       h
        rts                                     ; B4CE 60                       `

; ----------------------------------------------------------------------------
        adc     ($69,x)                         ; B4CF 61 69                    ai
        adc     #$6D                            ; B4D1 69 6D                    im
        adc     $D1D0                           ; B4D3 6D D0 D1                 m..
        txa                                     ; B4D6 8A                       .
        .byte   $8B                             ; B4D7 8B                       .
        pla                                     ; B4D8 68                       h
        adc     #$60                            ; B4D9 69 60                    i`
        adc     ($AF,x)                         ; B4DB 61 AF                    a.
        rti                                     ; B4DD 40                       @

; ----------------------------------------------------------------------------
        .byte   $A7                             ; B4DE A7                       .
        rti                                     ; B4DF 40                       @

; ----------------------------------------------------------------------------
        .byte   $A7                             ; B4E0 A7                       .
        rti                                     ; B4E1 40                       @

; ----------------------------------------------------------------------------
        .byte   $A7                             ; B4E2 A7                       .
        rti                                     ; B4E3 40                       @

; ----------------------------------------------------------------------------
        .byte   $A7                             ; B4E4 A7                       .
        rti                                     ; B4E5 40                       @

; ----------------------------------------------------------------------------
        .byte   $A7                             ; B4E6 A7                       .
        .byte   $43                             ; B4E7 43                       C
        bvc     LB53A                           ; B4E8 50 50                    PP
        cpy     #$C1                            ; B4EA C0 C1                    ..
        cpy     #$C1                            ; B4EC C0 C1                    ..
        iny                                     ; B4EE C8                       .
        dec     $C2                             ; B4EF C6 C2                    ..
        .byte   $C3                             ; B4F1 C3                       .
        .byte   $C7                             ; B4F2 C7                       .
        .byte   $CB                             ; B4F3 CB                       .
        iny                                     ; B4F4 C8                       .
        dec     $C9C8                           ; B4F5 CE C8 C9                 ...
        .byte   $CF                             ; B4F8 CF                       .
        .byte   $CB                             ; B4F9 CB                       .
        dex                                     ; B4FA CA                       .
        .byte   $CB                             ; B4FB CB                       .
        rti                                     ; B4FC 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B4FD 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B4FE 40                       @

; ----------------------------------------------------------------------------
        lsr     a                               ; B4FF 4A                       J
        jmp     L425B                           ; B500 4C 5B 42                 L[B

; ----------------------------------------------------------------------------
        eor     ($50,x)                         ; B503 41 50                    AP
        bvc     LB4C9                           ; B505 50 C2                    P.
        .byte   $C3                             ; B507 C3                       .
        bvc     LB553                           ; B508 50 49                    PI
        pla                                     ; B50A 68                       h
        adc     #$50                            ; B50B 69 50                    iP
        bvc     LB578                           ; B50D 50 69                    Pi
        adc     #$62                            ; B50F 69 62                    ib
        .byte   $02                             ; B511 02                       .
        ror     a                               ; B512 6A                       j
        .byte   $02                             ; B513 02                       .
        rti                                     ; B514 40                       @

; ----------------------------------------------------------------------------
        ror     $6640                           ; B515 6E 40 66                 n@f
        adc     $6502                           ; B518 6D 02 65                 m.e
        .byte   $02                             ; B51B 02                       .
        adc     $02                             ; B51C 65 02                    e.
        adc     $02                             ; B51E 65 02                    e.
        rti                                     ; B520 40                       @

; ----------------------------------------------------------------------------
        lsr     a                               ; B521 4A                       J
        .byte   $43                             ; B522 43                       C
        .byte   $42                             ; B523 42                       B
        .byte   $5B                             ; B524 5B                       [
        ror     $42                             ; B525 66 42                    fB
        ror     $65                             ; B527 66 65                    fe
        .byte   $02                             ; B529 02                       .
        adc     $65                             ; B52A 65 65                    ee
        bvc     LB57E                           ; B52C 50 50                    PP
        adc     #$6A                            ; B52E 69 6A                    ij
        bvc     LB582                           ; B530 50 50                    PP
        pla                                     ; B532 68                       h
        adc     #$60                            ; B533 69 60                    i`
        adc     ($69,x)                         ; B535 61 69                    ai
        adc     #$50                            ; B537 69 50                    iP
        .byte   $66                             ; B539 66                       f
LB53A:  eor     ($66),y                         ; B53A 51 66                    Qf
        .byte   $02                             ; B53C 02                       .
        .byte   $67                             ; B53D 67                       g
        .byte   $67                             ; B53E 67                       g
        .byte   $67                             ; B53F 67                       g
        .byte   $7C                             ; B540 7C                       |
        pla                                     ; B541 68                       h
        .byte   $03                             ; B542 03                       .
        rts                                     ; B543 60                       `

; ----------------------------------------------------------------------------
        ror     a                               ; B544 6A                       j
        php                                     ; B545 08                       .
        .byte   $62                             ; B546 62                       b
        .byte   $02                             ; B547 02                       .
        ror     a                               ; B548 6A                       j
        .byte   $02                             ; B549 02                       .
        .byte   $62                             ; B54A 62                       b
        .byte   $02                             ; B54B 02                       .
        .byte   $02                             ; B54C 02                       .
        .byte   $67                             ; B54D 67                       g
        adc     ($62,x)                         ; B54E 61 62                    ab
        php                                     ; B550 08                       .
        .byte   $72                             ; B551 72                       r
        .byte   $02                             ; B552 02                       .
LB553:  .byte   $72                             ; B553 72                       r
        rts                                     ; B554 60                       `

; ----------------------------------------------------------------------------
        adc     ($8A,x)                         ; B555 61 8A                    a.
        .byte   $8B                             ; B557 8B                       .
        adc     $38                             ; B558 65 38                    e8
        .byte   $65                             ; B55A 65                       e
LB55B:  .byte   $3A                             ; B55B 3A                       :
        sec                                     ; B55C 38                       8
        sta     ($3A,x)                         ; B55D 81 3A                    .:
        .byte   $89                             ; B55F 89                       .
        sec                                     ; B560 38                       8
        adc     $3A                             ; B561 65 3A                    e:
        adc     $65                             ; B563 65 65                    ee
        sec                                     ; B565 38                       8
        adc     $6D                             ; B566 65 6D                    em
        and     $8A39,y                         ; B568 39 39 8A                 99.
        .byte   $8B                             ; B56B 8B                       .
        and     $6D39,y                         ; B56C 39 39 6D                 99m
        adc     $9138                           ; B56F 6D 38 91                 m8.
        txa                                     ; B572 8A                       .
        sta     ($38),y                         ; B573 91 38                    .8
        and     $6D6D,y                         ; B575 39 6D 6D                 9mm
LB578:  and     $6D38,y                         ; B578 39 38 6D                 98m
        adc     $6160                           ; B57B 6D 60 61                 m`a
LB57E:  adc     $650A                           ; B57E 6D 0A 65                 m.e
        asl     a                               ; B581 0A                       .
LB582:  adc     $0A                             ; B582 65 0A                    e.
        bmi     LB5B7                           ; B584 30 31                    01
        bmi     LB5B9                           ; B586 30 31                    01
        bne     LB55B                           ; B588 D0 D1                    ..
        adc     $616D                           ; B58A 6D 6D 61                 mma
        adc     ($6D,x)                         ; B58D 61 6D                    am
        asl     a                               ; B58F 0A                       .
        .byte   $62                             ; B590 62                       b
        adc     $656A                           ; B591 6D 6A 65                 mje
        adc     $6568                           ; B594 6D 68 65                 mhe
        rts                                     ; B597 60                       `

; ----------------------------------------------------------------------------
        .byte   $62                             ; B598 62                       b
        adc     $6A                             ; B599 65 6A                    ej
        adc     $E8                             ; B59B 65 E8                    e.
        inx                                     ; B59D E8                       .
        adc     $606D                           ; B59E 6D 6D 60                 mm`
        .byte   $62                             ; B5A1 62                       b
        cpx     #$6D                            ; B5A2 E0 6D                    .m
        adc     $65                             ; B5A4 65 65                    ee
        ror     a                               ; B5A6 6A                       j
        adc     $E0                             ; B5A7 65 E0                    e.
        adc     $E0                             ; B5A9 65 E0                    e.
        adc     $60                             ; B5AB 65 60                    e`
        adc     ($E8,x)                         ; B5AD 61 E8                    a.
        inx                                     ; B5AF E8                       .
        adc     ($62,x)                         ; B5B0 61 62                    ab
        inx                                     ; B5B2 E8                       .
        inx                                     ; B5B3 E8                       .
        adc     $E8                             ; B5B4 65 E8                    e.
        .byte   $65                             ; B5B6 65                       e
LB5B7:  .byte   $6D                             ; B5B7 6D                       m
        .byte   $E0                             ; B5B8 E0                       .
LB5B9:  adc     $68                             ; B5B9 65 68                    eh
        ror     a                               ; B5BB 6A                       j
        .byte   $62                             ; B5BC 62                       b
        .byte   $82                             ; B5BD 82                       .
        ror     a                               ; B5BE 6A                       j
        adc     $80                             ; B5BF 65 80                    e.
        sta     ($88,x)                         ; B5C1 81 88                    ..
        .byte   $9B                             ; B5C3 9B                       .
        cpx     #$E8                            ; B5C4 E0 E8                    ..
        cpx     #$6D                            ; B5C6 E0 6D                    .m
        .byte   $92                             ; B5C8 92                       .
        sta     ($9A,x)                         ; B5C9 81 9A                    ..
        .byte   $9B                             ; B5CB 9B                       .
        adc     $6560                           ; B5CC 6D 60 65                 m`e
        pla                                     ; B5CF 68                       h
        adc     $650A                           ; B5D0 6D 0A 65                 m.e
        asl     a                               ; B5D3 0A                       .
        .byte   $82                             ; B5D4 82                       .
        rts                                     ; B5D5 60                       `

; ----------------------------------------------------------------------------
        adc     $68                             ; B5D6 65 68                    eh
        adc     $0A                             ; B5D8 65 0A                    e.
        adc     #$69                            ; B5DA 69 69                    ii
        .byte   $62                             ; B5DC 62                       b
        rts                                     ; B5DD 60                       `

; ----------------------------------------------------------------------------
        ror     a                               ; B5DE 6A                       j
        pla                                     ; B5DF 68                       h
        adc     $6565                           ; B5E0 6D 65 65                 mee
        adc     $65                             ; B5E3 65 65                    ee
        adc     $6A                             ; B5E5 65 6A                    ej
        pla                                     ; B5E7 68                       h
        brk                                     ; B5E8 00                       .
        brk                                     ; B5E9 00                       .
        brk                                     ; B5EA 00                       .
        brk                                     ; B5EB 00                       .
        brk                                     ; B5EC 00                       .
        brk                                     ; B5ED 00                       .
        brk                                     ; B5EE 00                       .
        brk                                     ; B5EF 00                       .
        brk                                     ; B5F0 00                       .
        brk                                     ; B5F1 00                       .
        brk                                     ; B5F2 00                       .
        brk                                     ; B5F3 00                       .
        brk                                     ; B5F4 00                       .
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
LB600:  brk                                     ; B600 00                       .
        ora     (L0000,x)                       ; B601 01 00                    ..
        .byte   $02                             ; B603 02                       .
        .byte   $03                             ; B604 03                       .
        .byte   $02                             ; B605 02                       .
        .byte   $04                             ; B606 04                       .
        ora     $06                             ; B607 05 06                    ..
        asl     $06                             ; B609 06 06                    ..
        asl     $06                             ; B60B 06 06                    ..
        asl     $06                             ; B60D 06 06                    ..
        asl     $06                             ; B60F 06 06                    ..
        asl     $06                             ; B611 06 06                    ..
        asl     $06                             ; B613 06 06                    ..
        asl     $07                             ; B615 06 07                    ..
        asl     $08                             ; B617 06 08                    ..
        .byte   $07                             ; B619 07                       .
        asl     $06                             ; B61A 06 06                    ..
        ora     #$06                            ; B61C 09 06                    ..
        asl     $07                             ; B61E 06 07                    ..
        asl     a                               ; B620 0A                       .
        .byte   $0B                             ; B621 0B                       .
        .byte   $0C                             ; B622 0C                       .
        ora     $0F0E                           ; B623 0D 0E 0F                 ...
        bpl     LB633                           ; B626 10 0B                    ..
        ora     ($12),y                         ; B628 11 12                    ..
        .byte   $13                             ; B62A 13                       .
        ora     ($11),y                         ; B62B 11 11                    ..
        .byte   $13                             ; B62D 13                       .
        .byte   $14                             ; B62E 14                       .
        ora     $16,x                           ; B62F 15 16                    ..
        .byte   $17                             ; B631 17                       .
        clc                                     ; B632 18                       .
LB633:  asl     $17,x                           ; B633 16 17                    ..
        clc                                     ; B635 18                       .
        ora     $1B1A,y                         ; B636 19 1A 1B                 ...
        .byte   $1C                             ; B639 1C                       .
        ora     $1C1B,x                         ; B63A 1D 1B 1C                 ...
        ora     $1A1E,x                         ; B63D 1D 1E 1A                 ...
        .byte   $03                             ; B640 03                       .
        brk                                     ; B641 00                       .
        ora     (L0000,x)                       ; B642 01 00                    ..
        .byte   $02                             ; B644 02                       .
        .byte   $03                             ; B645 03                       .
        .byte   $02                             ; B646 02                       .
        .byte   $04                             ; B647 04                       .
        asl     $06                             ; B648 06 06                    ..
        asl     $06                             ; B64A 06 06                    ..
        asl     $06                             ; B64C 06 06                    ..
        asl     $06                             ; B64E 06 06                    ..
        asl     $06                             ; B650 06 06                    ..
        asl     $06                             ; B652 06 06                    ..
        asl     $06                             ; B654 06 06                    ..
        asl     $06                             ; B656 06 06                    ..
        asl     $06                             ; B658 06 06                    ..
        ora     #$07                            ; B65A 09 07                    ..
        php                                     ; B65C 08                       .
        asl     $06                             ; B65D 06 06                    ..
        asl     $0C                             ; B65F 06 0C                    ..
        ora     $0F0E                           ; B661 0D 0E 0F                 ...
        asl     a                               ; B664 0A                       .
        bpl     LB686                           ; B665 10 1F                    ..
        jsr     L2221                           ; B667 20 21 22                  !"
        .byte   $23                             ; B66A 23                       #
        .byte   $13                             ; B66B 13                       .
        jsr     L1624                           ; B66C 20 24 16                  $.
        and     $26                             ; B66F 25 26                    %&
        .byte   $27                             ; B671 27                       '
        plp                                     ; B672 28                       (
        and     #$2A                            ; B673 29 2A                    )*
        .byte   $2B                             ; B675 2B                       +
        asl     $25,x                           ; B676 16 25                    .%
        rol     $27                             ; B678 26 27                    &'
        plp                                     ; B67A 28                       (
        bit     $2B2A                           ; B67B 2C 2A 2B                 ,*+
        asl     $25,x                           ; B67E 16 25                    .%
        asl     $05                             ; B680 06 05                    ..
        .byte   $03                             ; B682 03                       .
        brk                                     ; B683 00                       .
        ora     (L0000,x)                       ; B684 01 00                    ..
LB686:  .byte   $02                             ; B686 02                       .
        .byte   $03                             ; B687 03                       .
        asl     $06                             ; B688 06 06                    ..
        asl     $06                             ; B68A 06 06                    ..
        asl     $06                             ; B68C 06 06                    ..
        asl     $06                             ; B68E 06 06                    ..
        .byte   $07                             ; B690 07                       .
        asl     $06                             ; B691 06 06                    ..
        asl     $06                             ; B693 06 06                    ..
        asl     $06                             ; B695 06 06                    ..
        asl     $06                             ; B697 06 06                    ..
        asl     $09                             ; B699 06 09                    ..
        asl     $06                             ; B69B 06 06                    ..
        asl     $06                             ; B69D 06 06                    ..
        asl     $2D                             ; B69F 06 2D                    .-
        bpl     LB6B1                           ; B6A1 10 0E                    ..
        .byte   $0F                             ; B6A3 0F                       .
        rol     $0F0C                           ; B6A4 2E 0C 0F                 ...
        .byte   $0B                             ; B6A7 0B                       .
        plp                                     ; B6A8 28                       (
        .byte   $13                             ; B6A9 13                       .
        .byte   $13                             ; B6AA 13                       .
        .byte   $2F                             ; B6AB 2F                       /
        .byte   $23                             ; B6AC 23                       #
        .byte   $13                             ; B6AD 13                       .
        .byte   $13                             ; B6AE 13                       .
        .byte   $20                             ; B6AF 20                        
        plp                                     ; B6B0 28                       (
LB6B1:  and     #$29                            ; B6B1 29 29                    ))
        rol     a                               ; B6B3 2A                       *
        plp                                     ; B6B4 28                       (
        bmi     LB6E0                           ; B6B5 30 29                    0)
        rol     a                               ; B6B7 2A                       *
        plp                                     ; B6B8 28                       (
        bit     $2A2C                           ; B6B9 2C 2C 2A                 ,,*
        plp                                     ; B6BC 28                       (
        and     ($2C),y                         ; B6BD 31 2C                    1,
        .byte   $32                             ; B6BF 32                       2
        .byte   $02                             ; B6C0 02                       .
        .byte   $04                             ; B6C1 04                       .
        asl     $06                             ; B6C2 06 06                    ..
        asl     $05                             ; B6C4 06 05                    ..
        .byte   $03                             ; B6C6 03                       .
        brk                                     ; B6C7 00                       .
        asl     $06                             ; B6C8 06 06                    ..
        asl     $06                             ; B6CA 06 06                    ..
        asl     $06                             ; B6CC 06 06                    ..
        asl     $06                             ; B6CE 06 06                    ..
        asl     $06                             ; B6D0 06 06                    ..
        asl     $06                             ; B6D2 06 06                    ..
        .byte   $07                             ; B6D4 07                       .
        asl     $06                             ; B6D5 06 06                    ..
        asl     $07                             ; B6D7 06 07                    ..
        asl     $09                             ; B6D9 06 09                    ..
        .byte   $33                             ; B6DB 33                       3
        .byte   $33                             ; B6DC 33                       3
        asl     $07                             ; B6DD 06 07                    ..
        php                                     ; B6DF 08                       .
LB6E0:  .byte   $0F                             ; B6E0 0F                       .
        bmi     LB713                           ; B6E1 30 30                    00
        and     ($31),y                         ; B6E3 31 31                    11
        bmi     LB6F6                           ; B6E5 30 0F                    0.
        asl     a                               ; B6E7 0A                       .
        bit     $16                             ; B6E8 24 16                    $.
        asl     $16,x                           ; B6EA 16 16                    ..
        asl     $16,x                           ; B6EC 16 16                    ..
        asl     $34,x                           ; B6EE 16 34                    .4
        .byte   $2B                             ; B6F0 2B                       +
        and     $36,x                           ; B6F1 35 36                    56
        .byte   $37                             ; B6F3 37                       7
        sec                                     ; B6F4 38                       8
        .byte   $36                             ; B6F5 36                       6
LB6F6:  and     $3A25,y                         ; B6F6 39 25 3A                 9%:
        .byte   $3B                             ; B6F9 3B                       ;
        bit     $3B3C                           ; B6FA 2C 3C 3B                 ,<;
        bit     $3D3C                           ; B6FD 2C 3C 3D                 ,<=
        ora     ($3E,x)                         ; B700 01 3E                    .>
        .byte   $3F                             ; B702 3F                       ?
        .byte   $3F                             ; B703 3F                       ?
        .byte   $3F                             ; B704 3F                       ?
        .byte   $3F                             ; B705 3F                       ?
        .byte   $3F                             ; B706 3F                       ?
        .byte   $3F                             ; B707 3F                       ?
        asl     $06                             ; B708 06 06                    ..
        asl     $06                             ; B70A 06 06                    ..
        rti                                     ; B70C 40                       @

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; B70D 41 42                    AB
        eor     ($07,x)                         ; B70F 41 07                    A.
        asl     $06                             ; B711 06 06                    ..
LB713:  asl     $43                             ; B713 06 43                    .C
        .byte   $44                             ; B715 44                       D
        eor     $44                             ; B716 45 44                    ED
        asl     $06                             ; B718 06 06                    ..
        ora     #$07                            ; B71A 09 07                    ..
        .byte   $43                             ; B71C 43                       C
        .byte   $44                             ; B71D 44                       D
        lsr     $44                             ; B71E 46 44                    FD
        bpl     LB731                           ; B720 10 0F                    ..
        asl     $4710                           ; B722 0E 10 47                 ..G
        pha                                     ; B725 48                       H
        eor     #$48                            ; B726 49 48                    IH
        and     $3E13                           ; B728 2D 13 3E                 -.>
        .byte   $3F                             ; B72B 3F                       ?
        .byte   $3F                             ; B72C 3F                       ?
        .byte   $3F                             ; B72D 3F                       ?
        .byte   $3F                             ; B72E 3F                       ?
        .byte   $3F                             ; B72F 3F                       ?
        plp                                     ; B730 28                       (
LB731:  and     #$3E                            ; B731 29 3E                    )>
        .byte   $3F                             ; B733 3F                       ?
        lsr     a                               ; B734 4A                       J
        .byte   $3F                             ; B735 3F                       ?
        lsr     a                               ; B736 4A                       J
        .byte   $3F                             ; B737 3F                       ?
        .byte   $4B                             ; B738 4B                       K
        bit     $3F3E                           ; B739 2C 3E 3F                 ,>?
        jmp     L4C3F                           ; B73C 4C 3F 4C                 L?L

; ----------------------------------------------------------------------------
        .byte   $3F                             ; B73F 3F                       ?
        eor     $444E                           ; B740 4D 4E 44                 MND
        .byte   $44                             ; B743 44                       D
        .byte   $44                             ; B744 44                       D
        eor     $44                             ; B745 45 44                    ED
        .byte   $4F                             ; B747 4F                       O
        bvc     LB79B                           ; B748 50 51                    PQ
        eor     ($51),y                         ; B74A 51 51                    QQ
        eor     ($52),y                         ; B74C 51 52                    QR
        eor     ($4F),y                         ; B74E 51 4F                    QO
        .byte   $44                             ; B750 44                       D
        .byte   $44                             ; B751 44                       D
        .byte   $44                             ; B752 44                       D
        .byte   $53                             ; B753 53                       S
        .byte   $54                             ; B754 54                       T
        eor     $44                             ; B755 45 44                    ED
        .byte   $4F                             ; B757 4F                       O
        .byte   $44                             ; B758 44                       D
        .byte   $44                             ; B759 44                       D
        .byte   $44                             ; B75A 44                       D
        eor     $4E,x                           ; B75B 55 4E                    UN
        eor     $44                             ; B75D 45 44                    ED
        .byte   $4F                             ; B75F 4F                       O
        lsr     $44,x                           ; B760 56 44                    VD
        .byte   $44                             ; B762 44                       D
        .byte   $57                             ; B763 57                       W
        eor     ($52),y                         ; B764 51 52                    QR
        eor     ($58),y                         ; B766 51 58                    QX
        eor     $5A56,y                         ; B768 59 56 5A                 YVZ
        .byte   $5B                             ; B76B 5B                       [
        .byte   $44                             ; B76C 44                       D
        eor     $44                             ; B76D 45 44                    ED
        .byte   $5C                             ; B76F 5C                       \
        lsr     a                               ; B770 4A                       J
        eor     $5E5D                           ; B771 4D 5D 5E                 M]^
        .byte   $5F                             ; B774 5F                       _
        rol     $3E4D,x                         ; B775 3E 4D 3E                 >M>
        jmp     L604D                           ; B778 4C 4D 60                 LM`

; ----------------------------------------------------------------------------
        adc     ($2C,x)                         ; B77B 61 2C                    a,
        rol     $3E4D,x                         ; B77D 3E 4D 3E                 >M>
        .byte   $62                             ; B780 62                       b
        .byte   $63                             ; B781 63                       c
        .byte   $64                             ; B782 64                       d
        .byte   $64                             ; B783 64                       d
        .byte   $64                             ; B784 64                       d
        .byte   $64                             ; B785 64                       d
        .byte   $64                             ; B786 64                       d
        .byte   $64                             ; B787 64                       d
        .byte   $62                             ; B788 62                       b
        adc     $66                             ; B789 65 66                    ef
        ror     $66                             ; B78B 66 66                    ff
        eor     $66,x                           ; B78D 55 66                    Uf
        .byte   $67                             ; B78F 67                       g
        .byte   $62                             ; B790 62                       b
        pla                                     ; B791 68                       h
        adc     #$69                            ; B792 69 69                    ii
        adc     #$46                            ; B794 69 46                    iF
        adc     #$6A                            ; B796 69 6A                    ij
        .byte   $62                             ; B798 62                       b
        .byte   $44                             ; B799 44                       D
        .byte   $44                             ; B79A 44                       D
LB79B:  .byte   $44                             ; B79B 44                       D
        .byte   $44                             ; B79C 44                       D
        eor     $44                             ; B79D 45 44                    ED
        .byte   $6B                             ; B79F 6B                       k
        .byte   $62                             ; B7A0 62                       b
        .byte   $44                             ; B7A1 44                       D
        .byte   $44                             ; B7A2 44                       D
        .byte   $44                             ; B7A3 44                       D
        .byte   $44                             ; B7A4 44                       D
LB7A5:  .byte   $57                             ; B7A5 57                       W
        eor     ($6C),y                         ; B7A6 51 6C                    Ql
LB7A8:  adc     $4454                           ; B7A8 6D 54 44                 mTD
        ror     $526F                           ; B7AB 6E 6F 52                 noR
        eor     ($6C),y                         ; B7AE 51 6C                    Ql
        .byte   $64                             ; B7B0 64                       d
        .byte   $62                             ; B7B1 62                       b
        .byte   $44                             ; B7B2 44                       D
        .byte   $44                             ; B7B3 44                       D
        .byte   $44                             ; B7B4 44                       D
        eor     $70                             ; B7B5 45 70                    Ep
        adc     ($64),y                         ; B7B7 71 64                    qd
        .byte   $72                             ; B7B9 72                       r
        .byte   $44                             ; B7BA 44                       D
        .byte   $44                             ; B7BB 44                       D
        .byte   $44                             ; B7BC 44                       D
        eor     $44                             ; B7BD 45 44                    ED
        .byte   $63                             ; B7BF 63                       c
        .byte   $3F                             ; B7C0 3F                       ?
        .byte   $73                             ; B7C1 73                       s
        .byte   $74                             ; B7C2 74                       t
        adc     $76,x                           ; B7C3 75 76                    uv
        .byte   $77                             ; B7C5 77                       w
        sei                                     ; B7C6 78                       x
        .byte   $74                             ; B7C7 74                       t
        .byte   $3F                             ; B7C8 3F                       ?
        adc     $7B7A,y                         ; B7C9 79 7A 7B                 yz{
        ror     $55                             ; B7CC 66 55                    fU
        .byte   $7C                             ; B7CE 7C                       |
        .byte   $7A                             ; B7CF 7A                       z
        adc     $7F7E,x                         ; B7D0 7D 7E 7F                 }~.
        .byte   $80                             ; B7D3 80                       .
        sta     ($82,x)                         ; B7D4 81 82                    ..
        .byte   $83                             ; B7D6 83                       .
        sty     $85                             ; B7D7 84 85                    ..
        eor     $86                             ; B7D9 45 86                    E.
        ror     $66                             ; B7DB 66 66                    ff
        eor     $87,x                           ; B7DD 55 87                    U.
        sty     $88                             ; B7DF 84 88                    ..
        .byte   $89                             ; B7E1 89                       .
        .byte   $84                             ; B7E2 84                       .
LB7E3:  sty     $84                             ; B7E3 84 84                    ..
        .byte   $45                             ; B7E5 45                       E
LB7E6:  txa                                     ; B7E6 8A                       .
        sta     ($88,x)                         ; B7E7 81 88                    ..
LB7E9:  .byte   $52                             ; B7E9 52                       R
        .byte   $7A                             ; B7EA 7A                       z
        .byte   $7A                             ; B7EB 7A                       z
        .byte   $7A                             ; B7EC 7A                       z
        .byte   $89                             ; B7ED 89                       .
        ror     $66                             ; B7EE 66 66                    ff
        eor     $3F8B                           ; B7F0 4D 8B 3F                 M.?
        lsr     a                               ; B7F3 4A                       J
        .byte   $3F                             ; B7F4 3F                       ?
        lsr     a                               ; B7F5 4A                       J
        .byte   $3F                             ; B7F6 3F                       ?
        .byte   $3F                             ; B7F7 3F                       ?
        eor     $3F4F                           ; B7F8 4D 4F 3F                 MO?
        jmp     L4C3F                           ; B7FB 4C 3F 4C                 L?L

; ----------------------------------------------------------------------------
        .byte   $3F                             ; B7FE 3F                       ?
        .byte   $3F                             ; B7FF 3F                       ?
        .byte   $42                             ; B800 42                       B
        sty     $058D                           ; B801 8C 8D 05                 ...
        .byte   $03                             ; B804 03                       .
        .byte   $02                             ; B805 02                       .
        .byte   $03                             ; B806 03                       .
        .byte   $02                             ; B807 02                       .
        stx     $0606                           ; B808 8E 06 06                 ...
        asl     $06                             ; B80B 06 06                    ..
        asl     $06                             ; B80D 06 06                    ..
        asl     $45                             ; B80F 06 45                    .E
        .byte   $8F                             ; B811 8F                       .
        bcc     LB7A5                           ; B812 90 91                    ..
        .byte   $8F                             ; B814 8F                       .
        bcc     LB7A8                           ; B815 90 91                    ..
        .byte   $8F                             ; B817 8F                       .
        lsr     $84                             ; B818 46 84                    F.
        sty     $84                             ; B81A 84 84                    ..
        sty     $84                             ; B81C 84 84                    ..
        sty     $84                             ; B81E 84 84                    ..
        .byte   $92                             ; B820 92                       .
        sty     $84                             ; B821 84 84                    ..
        sty     $84                             ; B823 84 84                    ..
LB825:  sty     $84                             ; B825 84 84                    ..
        .byte   $84                             ; B827 84                       .
LB828:  eor     $84,x                           ; B828 55 84                    U.
        .byte   $93                             ; B82A 93                       .
        sty     $84,x                           ; B82B 94 84                    ..
        sty     $84                             ; B82D 84 84                    ..
        sty     $3F                             ; B82F 84 3F                    .?
        eor     $5E5D                           ; B831 4D 5D 5E                 M]^
        rol     $3F4A,x                         ; B834 3E 4A 3F                 >J?
        .byte   $3F                             ; B837 3F                       ?
        .byte   $3F                             ; B838 3F                       ?
        eor     $6160                           ; B839 4D 60 61                 M`a
        rol     $3F4A,x                         ; B83C 3E 4A 3F                 >J?
        lsr     a                               ; B83F 4A                       J
        .byte   $04                             ; B840 04                       .
        asl     $05                             ; B841 06 05                    ..
        .byte   $03                             ; B843 03                       .
        .byte   $02                             ; B844 02                       .
        .byte   $03                             ; B845 03                       .
        .byte   $02                             ; B846 02                       .
        .byte   $04                             ; B847 04                       .
        asl     $06                             ; B848 06 06                    ..
        asl     $06                             ; B84A 06 06                    ..
        asl     $06                             ; B84C 06 06                    ..
        asl     $06                             ; B84E 06 06                    ..
        bcc     LB7E3                           ; B850 90 91                    ..
        .byte   $8F                             ; B852 8F                       .
        bcc     LB7E6                           ; B853 90 91                    ..
        .byte   $8F                             ; B855 8F                       .
        bcc     LB7E9                           ; B856 90 91                    ..
        sty     $84                             ; B858 84 84                    ..
        sty     $84                             ; B85A 84 84                    ..
        sty     $84                             ; B85C 84 84                    ..
        sty     $84                             ; B85E 84 84                    ..
        sty     $84                             ; B860 84 84                    ..
        .byte   $84                             ; B862 84                       .
LB863:  sty     $84                             ; B863 84 84                    ..
        .byte   $84                             ; B865 84                       .
LB866:  sty     $95                             ; B866 84 95                    ..
        .byte   $84                             ; B868 84                       .
LB869:  sty     $84                             ; B869 84 84                    ..
        sty     $84                             ; B86B 84 84                    ..
        sty     $84                             ; B86D 84 84                    ..
        sty     $3F                             ; B86F 84 3F                    .?
        lsr     a                               ; B871 4A                       J
        .byte   $3F                             ; B872 3F                       ?
        eor     $9696                           ; B873 4D 96 96                 M..
        stx     $96,y                           ; B876 96 96                    ..
        .byte   $3F                             ; B878 3F                       ?
        lsr     a                               ; B879 4A                       J
        .byte   $3F                             ; B87A 3F                       ?
        eor     $3F3E                           ; B87B 4D 3E 3F                 M>?
        .byte   $3F                             ; B87E 3F                       ?
        eor     $0606                           ; B87F 4D 06 06                 M..
        asl     $05                             ; B882 06 05                    ..
        .byte   $03                             ; B884 03                       .
        .byte   $02                             ; B885 02                       .
        .byte   $03                             ; B886 03                       .
        brk                                     ; B887 00                       .
        asl     $06                             ; B888 06 06                    ..
        asl     $06                             ; B88A 06 06                    ..
        asl     $06                             ; B88C 06 06                    ..
        asl     $06                             ; B88E 06 06                    ..
        .byte   $97                             ; B890 97                       .
        .byte   $8F                             ; B891 8F                       .
        bcc     LB825                           ; B892 90 91                    ..
        .byte   $8F                             ; B894 8F                       .
        bcc     LB828                           ; B895 90 91                    ..
        .byte   $8F                             ; B897 8F                       .
        .byte   $97                             ; B898 97                       .
        sty     $84                             ; B899 84 84                    ..
        sty     $84                             ; B89B 84 84                    ..
        sty     $84                             ; B89D 84 84                    ..
        sty     $98                             ; B89F 84 98                    ..
        sty     $84                             ; B8A1 84 84                    ..
LB8A3:  sty     $84                             ; B8A3 84 84                    ..
        sta     $9B9A,y                         ; B8A5 99 9A 9B                 ...
        .byte   $97                             ; B8A8 97                       .
        sty     $84                             ; B8A9 84 84                    ..
        sty     $84                             ; B8AB 84 84                    ..
        ror     $9C                             ; B8AD 66 9C                    f.
        .byte   $9B                             ; B8AF 9B                       .
        rol     L4D3F,x                         ; B8B0 3E 3F 4D                 >?M
        jsr     L3E2D                           ; B8B3 20 2D 3E                  ->
        .byte   $3F                             ; B8B6 3F                       ?
        .byte   $3F                             ; B8B7 3F                       ?
        .byte   $3E                             ; B8B8 3E                       >
LB8B9:  .byte   $3F                             ; B8B9 3F                       ?
        eor     $282A                           ; B8BA 4D 2A 28                 M*(
        rol     $3F3F,x                         ; B8BD 3E 3F 3F                 >??
        ora     (L0000,x)                       ; B8C0 01 00                    ..
        .byte   $02                             ; B8C2 02                       .
        .byte   $04                             ; B8C3 04                       .
        asl     $06                             ; B8C4 06 06                    ..
        asl     $06                             ; B8C6 06 06                    ..
        asl     $06                             ; B8C8 06 06                    ..
        asl     $06                             ; B8CA 06 06                    ..
        asl     $06                             ; B8CC 06 06                    ..
        asl     $06                             ; B8CE 06 06                    ..
        bcc     LB863                           ; B8D0 90 91                    ..
        .byte   $8F                             ; B8D2 8F                       .
        bcc     LB866                           ; B8D3 90 91                    ..
        .byte   $8F                             ; B8D5 8F                       .
        bcc     LB869                           ; B8D6 90 91                    ..
        sty     $99                             ; B8D8 84 99                    ..
        sty     $84                             ; B8DA 84 84                    ..
        sty     $84                             ; B8DC 84 84                    ..
        sty     $84                             ; B8DE 84 84                    ..
        sta     $9E9E,x                         ; B8E0 9D 9E 9E                 ...
        .byte   $9E                             ; B8E3 9E                       .
        sta     $8484,y                         ; B8E4 99 84 84                 ...
        .byte   $93                             ; B8E7 93                       .
        .byte   $9B                             ; B8E8 9B                       .
        sta     $6666,x                         ; B8E9 9D 66 66                 .ff
        ror     $84                             ; B8EC 66 84                    f.
        sty     $3E                             ; B8EE 84 3E                    .>
        eor     $2D20                           ; B8F0 4D 20 2D                 M -
        rol     $3F3F,x                         ; B8F3 3E 3F 3F                 >??
        eor     $4D3E                           ; B8F6 4D 3E 4D                 M>M
        rol     a                               ; B8F9 2A                       *
        plp                                     ; B8FA 28                       (
        rol     $3F3F,x                         ; B8FB 3E 3F 3F                 >??
        eor     $053E                           ; B8FE 4D 3E 05                 M>.
        .byte   $03                             ; B901 03                       .
        .byte   $02                             ; B902 02                       .
        .byte   $03                             ; B903 03                       .
        .byte   $02                             ; B904 02                       .
        .byte   $04                             ; B905 04                       .
        asl     $9F                             ; B906 06 9F                    ..
        asl     $06                             ; B908 06 06                    ..
        asl     $06                             ; B90A 06 06                    ..
        asl     $06                             ; B90C 06 06                    ..
        asl     $9F                             ; B90E 06 9F                    ..
        .byte   $8F                             ; B910 8F                       .
        bcc     LB8A3                           ; B911 90 90                    ..
        sta     ($A0),y                         ; B913 91 A0                    ..
        .byte   $8F                             ; B915 8F                       .
        bcc     LB8B9                           ; B916 90 A1                    ..
        sty     $84                             ; B918 84 84                    ..
        .byte   $33                             ; B91A 33                       3
        .byte   $33                             ; B91B 33                       3
        ldx     #$7A                            ; B91C A2 7A                    .z
        .byte   $7A                             ; B91E 7A                       z
        .byte   $A3                             ; B91F A3                       .
        ldy     $A4                             ; B920 A4 A4                    ..
        lda     $A6                             ; B922 A5 A6                    ..
        ror     $84                             ; B924 66 84                    f.
        sty     $A7                             ; B926 84 A7                    ..
        lsr     a                               ; B928 4A                       J
        .byte   $3F                             ; B929 3F                       ?
        .byte   $3F                             ; B92A 3F                       ?
        lsr     a                               ; B92B 4A                       J
        eor     LA884                           ; B92C 4D 84 A8                 M..
        lda     #$4C                            ; B92F A9 4C                    .L
        .byte   $3F                             ; B931 3F                       ?
        lsr     a                               ; B932 4A                       J
        jmp     LAA4D                           ; B933 4C 4D AA                 LM.

; ----------------------------------------------------------------------------
        .byte   $AB                             ; B936 AB                       .
        ldy     $3F3F                           ; B937 AC 3F 3F                 .??
        jmp     L4D3F                           ; B93A 4C 3F 4D                 L?M

; ----------------------------------------------------------------------------
        lda     LAEAD                           ; B93D AD AD AE                 ...
        .byte   $64                             ; B940 64                       d
        .byte   $64                             ; B941 64                       d
        lsr     a                               ; B942 4A                       J
        .byte   $64                             ; B943 64                       d
        .byte   $62                             ; B944 62                       b
        .byte   $AF                             ; B945 AF                       .
        .byte   $AF                             ; B946 AF                       .
        bcs     LB9AD                           ; B947 B0 64                    .d
        .byte   $64                             ; B949 64                       d
        lda     ($B2),y                         ; B94A B1 B2                    ..
        .byte   $72                             ; B94C 72                       r
        .byte   $44                             ; B94D 44                       D
        .byte   $44                             ; B94E 44                       D
        .byte   $6B                             ; B94F 6B                       k
        .byte   $64                             ; B950 64                       d
        .byte   $64                             ; B951 64                       d
        lsr     a                               ; B952 4A                       J
        .byte   $62                             ; B953 62                       b
        eor     ($51),y                         ; B954 51 51                    QQ
        eor     ($B3),y                         ; B956 51 B3                    Q.
        .byte   $B2                             ; B958 B2                       .
        ldy     $B5,x                           ; B959 B4 B5                    ..
        .byte   $72                             ; B95B 72                       r
        .byte   $44                             ; B95C 44                       D
        .byte   $44                             ; B95D 44                       D
        .byte   $44                             ; B95E 44                       D
        ldx     $62,y                           ; B95F B6 62                    .b
        .byte   $44                             ; B961 44                       D
        eor     $44                             ; B962 45 44                    ED
        .byte   $44                             ; B964 44                       D
        .byte   $44                             ; B965 44                       D
        .byte   $44                             ; B966 44                       D
        ldx     $62,y                           ; B967 B6 62                    .b
        eor     ($52),y                         ; B969 51 52                    QR
        eor     ($51),y                         ; B96B 51 51                    QQ
        eor     ($51),y                         ; B96D 51 51                    QQ
        ldx     $62,y                           ; B96F B6 62                    .b
        .byte   $44                             ; B971 44                       D
        ldx     $64,y                           ; B972 B6 64                    .d
        .byte   $64                             ; B974 64                       d
        .byte   $64                             ; B975 64                       d
        .byte   $64                             ; B976 64                       d
        .byte   $64                             ; B977 64                       d
        .byte   $62                             ; B978 62                       b
        eor     ($B6),y                         ; B979 51 B6                    Q.
        .byte   $64                             ; B97B 64                       d
        .byte   $64                             ; B97C 64                       d
        .byte   $64                             ; B97D 64                       d
        .byte   $64                             ; B97E 64                       d
        .byte   $64                             ; B97F 64                       d
        eor     $3E44                           ; B980 4D 44 3E                 MD>
        .byte   $3F                             ; B983 3F                       ?
        .byte   $3F                             ; B984 3F                       ?
        .byte   $3F                             ; B985 3F                       ?
        .byte   $3F                             ; B986 3F                       ?
        .byte   $3F                             ; B987 3F                       ?
        eor     $3E44                           ; B988 4D 44 3E                 MD>
        eor     $0606                           ; B98B 4D 06 06                 M..
        asl     $06                             ; B98E 06 06                    ..
        eor     $5544                           ; B990 4D 44 55                 MDU
        .byte   $B7                             ; B993 B7                       .
        .byte   $07                             ; B994 07                       .
        asl     $06                             ; B995 06 06                    ..
        asl     $4D                             ; B997 06 4D                    .M
        .byte   $44                             ; B999 44                       D
        eor     $B8                             ; B99A 45 B8                    E.
        asl     $07                             ; B99C 06 07                    ..
        ora     #$06                            ; B99E 09 06                    ..
        eor     $4544                           ; B9A0 4D 44 45                 MDE
        lda     $0D2E,y                         ; B9A3 B9 2E 0D                 ...
        asl     $4D0D                           ; B9A6 0E 0D 4D                 ..M
        eor     ($52),y                         ; B9A9 51 52                    QR
        .byte   $97                             ; B9AB 97                       .
        .byte   $13                             ; B9AC 13                       .
LB9AD:  .byte   $13                             ; B9AD 13                       .
        ora     ($BA),y                         ; B9AE 11 BA                    ..
        .byte   $3F                             ; B9B0 3F                       ?
        .byte   $3F                             ; B9B1 3F                       ?
        eor     $5E5D                           ; B9B2 4D 5D 5E                 M]^
        .byte   $BB                             ; B9B5 BB                       .
        ldy     $3FBB,x                         ; B9B6 BC BB 3F                 ..?
        .byte   $3F                             ; B9B9 3F                       ?
        eor     $6160                           ; B9BA 4D 60 61                 M`a
        lda     LBDBE,x                         ; B9BD BD BE BD                 ...
        .byte   $3F                             ; B9C0 3F                       ?
        .byte   $3F                             ; B9C1 3F                       ?
        .byte   $3F                             ; B9C2 3F                       ?
        .byte   $3F                             ; B9C3 3F                       ?
        .byte   $3F                             ; B9C4 3F                       ?
        .byte   $3F                             ; B9C5 3F                       ?
        .byte   $3F                             ; B9C6 3F                       ?
        .byte   $3F                             ; B9C7 3F                       ?
        asl     $3E                             ; B9C8 06 3E                    .>
        .byte   $3F                             ; B9CA 3F                       ?
        .byte   $3F                             ; B9CB 3F                       ?
        .byte   $3F                             ; B9CC 3F                       ?
        eor     $0606                           ; B9CD 4D 06 06                 M..
        asl     $06                             ; B9D0 06 06                    ..
        asl     $06                             ; B9D2 06 06                    ..
        asl     $06                             ; B9D4 06 06                    ..
        .byte   $07                             ; B9D6 07                       .
        asl     $08                             ; B9D7 06 08                    ..
        asl     $BF                             ; B9D9 06 BF                    ..
LB9DB:  ora     #$06                            ; B9DB 09 06                    ..
        php                                     ; B9DD 08                       .
        asl     $07                             ; B9DE 06 07                    ..
        asl     a                               ; B9E0 0A                       .
        .byte   $97                             ; B9E1 97                       .
        eor     $105E,x                         ; B9E2 5D 5E 10                 ]^.
        asl     a                               ; B9E5 0A                       .
        cpy     #$0D                            ; B9E6 C0 0D                    ..
        cmp     ($97,x)                         ; B9E8 C1 97                    ..
        eor     $135E,x                         ; B9EA 5D 5E 13                 ]^.
        ora     ($C2),y                         ; B9ED 11 C2                    ..
        .byte   $C3                             ; B9EF C3                       .
        ldy     $6097,x                         ; B9F0 BC 97 60                 ..`
        adc     ($BB,x)                         ; B9F3 61 BB                    a.
        ldy     $4A3E,x                         ; B9F5 BC 3E 4A                 .>J
        ldx     $3E97,y                         ; B9F8 BE 97 3E                 ..>
        eor     LBEBD                           ; B9FB 4D BD BE                 M..
        rol     $3F4C,x                         ; B9FE 3E 4C 3F                 >L?
        .byte   $3F                             ; BA01 3F                       ?
        .byte   $3F                             ; BA02 3F                       ?
        .byte   $3F                             ; BA03 3F                       ?
        .byte   $3F                             ; BA04 3F                       ?
        .byte   $3F                             ; BA05 3F                       ?
        cpy     $3E                             ; BA06 C4 3E                    .>
        asl     $06                             ; BA08 06 06                    ..
        asl     $06                             ; BA0A 06 06                    ..
        asl     $C5                             ; BA0C 06 C5                    ..
        dec     $3E                             ; BA0E C6 3E                    .>
        asl     $06                             ; BA10 06 06                    ..
        asl     $06                             ; BA12 06 06                    ..
        asl     $43                             ; BA14 06 43                    .C
        .byte   $C7                             ; BA16 C7                       .
        rol     $0806,x                         ; BA17 3E 06 08                 >..
        asl     $07                             ; BA1A 06 07                    ..
        php                                     ; BA1C 08                       .
        .byte   $43                             ; BA1D 43                       C
        .byte   $C7                             ; BA1E C7                       .
        rol     $0AC8,x                         ; BA1F 3E C8 0A                 >..
        .byte   $97                             ; BA22 97                       .
        ora     $C90A                           ; BA23 0D 0A C9                 ...
        dex                                     ; BA26 CA                       .
        rol     $CCCB,x                         ; BA27 3E CB CC                 >..
        cmp     $134D                           ; BA2A CD 4D 13                 .M.
        dec     $3E44                           ; BA2D CE 44 3E                 .D>
        eor     $4A3E                           ; BA30 4D 3E 4A                 M>J
        eor     $3F3E                           ; BA33 4D 3E 3F                 M>?
        .byte   $3F                             ; BA36 3F                       ?
        .byte   $3F                             ; BA37 3F                       ?
        eor     $4C3E                           ; BA38 4D 3E 4C                 M>L
        eor     $3F3E                           ; BA3B 4D 3E 3F                 M>?
        .byte   $3F                             ; BA3E 3F                       ?
        .byte   $3F                             ; BA3F 3F                       ?
        eor     $6463                           ; BA40 4D 63 64                 Mcd
        .byte   $64                             ; BA43 64                       d
        .byte   $64                             ; BA44 64                       d
        .byte   $64                             ; BA45 64                       d
        .byte   $64                             ; BA46 64                       d
        .byte   $64                             ; BA47 64                       d
LBA48:  eor     $6665                           ; BA48 4D 65 66                 Mef
        ror     $66                             ; BA4B 66 66                    ff
        ror     $66                             ; BA4D 66 66                    ff
        ldx     $4D,y                           ; BA4F B6 4D                    .M
        .byte   $CF                             ; BA51 CF                       .
        sty     $84                             ; BA52 84 84                    ..
        sty     $84                             ; BA54 84 84                    ..
        sty     $B6                             ; BA56 84 B6                    ..
        eor     $8484                           ; BA58 4D 84 84                 M..
        sty     $84                             ; BA5B 84 84                    ..
        sty     $84                             ; BA5D 84 84                    ..
        ldx     $4D,y                           ; BA5F B6 4D                    .M
        sty     $84                             ; BA61 84 84                    ..
        sty     $84                             ; BA63 84 84                    ..
        sty     $84                             ; BA65 84 84                    ..
        ldx     $4D,y                           ; BA67 B6 4D                    .M
        sty     $84                             ; BA69 84 84                    ..
        sty     $84                             ; BA6B 84 84                    ..
        sty     $84                             ; BA6D 84 84                    ..
        ldx     $62,y                           ; BA6F B6 62                    .b
        stx     $96,y                           ; BA71 96 96                    ..
        stx     $96,y                           ; BA73 96 96                    ..
        bne     LBA48                           ; BA75 D0 D1                    ..
        ldx     $64,y                           ; BA77 B6 64                    .d
        .byte   $64                             ; BA79 64                       d
        .byte   $64                             ; BA7A 64                       d
        .byte   $64                             ; BA7B 64                       d
        .byte   $64                             ; BA7C 64                       d
        .byte   $64                             ; BA7D 64                       d
        .byte   $D2                             ; BA7E D2                       .
        ldx     $62,y                           ; BA7F B6 62                    .b
        .byte   $63                             ; BA81 63                       c
        .byte   $64                             ; BA82 64                       d
        .byte   $64                             ; BA83 64                       d
        .byte   $64                             ; BA84 64                       d
        .byte   $64                             ; BA85 64                       d
        .byte   $64                             ; BA86 64                       d
        .byte   $64                             ; BA87 64                       d
        .byte   $62                             ; BA88 62                       b
        adc     $66                             ; BA89 65 66                    ef
        ror     $66                             ; BA8B 66 66                    ff
        ror     $66                             ; BA8D 66 66                    ff
        rol     $D36D,x                         ; BA8F 3E 6D D3                 >m.
        sty     $84                             ; BA92 84 84                    ..
        sty     $84                             ; BA94 84 84                    ..
        sty     $3E                             ; BA96 84 3E                    .>
        .byte   $62                             ; BA98 62                       b
        ror     $84                             ; BA99 66 84                    f.
        sty     $84                             ; BA9B 84 84                    ..
        sty     $84                             ; BA9D 84 84                    ..
        rol     $8462,x                         ; BA9F 3E 62 84                 >b.
        sty     $84                             ; BAA2 84 84                    ..
        sty     $84                             ; BAA4 84 84                    ..
        sty     $3E                             ; BAA6 84 3E                    .>
        .byte   $62                             ; BAA8 62                       b
        sty     $84                             ; BAA9 84 84                    ..
        sty     $84                             ; BAAB 84 84                    ..
        sty     $84                             ; BAAD 84 84                    ..
        rol     $D462,x                         ; BAAF 3E 62 D4                 >b.
        stx     $96,y                           ; BAB2 96 96                    ..
        stx     $96,y                           ; BAB4 96 96                    ..
        stx     $3E,y                           ; BAB6 96 3E                    .>
        .byte   $62                             ; BAB8 62                       b
        .byte   $4F                             ; BAB9 4F                       O
        .byte   $3F                             ; BABA 3F                       ?
        .byte   $3F                             ; BABB 3F                       ?
        .byte   $3F                             ; BABC 3F                       ?
        .byte   $3F                             ; BABD 3F                       ?
        .byte   $3F                             ; BABE 3F                       ?
        .byte   $3F                             ; BABF 3F                       ?
        eor     $4A3E                           ; BAC0 4D 3E 4A                 M>J
        .byte   $3F                             ; BAC3 3F                       ?
        eor     $3F3E                           ; BAC4 4D 3E 3F                 M>?
        .byte   $3F                             ; BAC7 3F                       ?
        eor     $554E                           ; BAC8 4D 4E 55                 MNU
        lsr     $D54E                           ; BACB 4E 4E D5                 NN.
        eor     ($42,x)                         ; BACE 41 42                    AB
        eor     $5251                           ; BAD0 4D 51 52                 MQR
        eor     ($51),y                         ; BAD3 51 51                    QQ
        .byte   $52                             ; BAD5 52                       R
        eor     ($89),y                         ; BAD6 51 89                    Q.
        eor     $8951                           ; BAD8 4D 51 89                 MQ.
        .byte   $44                             ; BADB 44                       D
        dec     $57,x                           ; BADC D6 57                    .W
        eor     ($D7),y                         ; BADE 51 D7                    Q.
        eor     $4544                           ; BAE0 4D 44 45                 MDE
        cld                                     ; BAE3 D8                       .
        cmp     $DBDA,y                         ; BAE4 D9 DA DB                 ...
        .byte   $DC                             ; BAE7 DC                       .
        eor     $5251                           ; BAE8 4D 51 52                 MQR
        cmp     $DADE,x                         ; BAEB DD DE DA                 ...
        cmp     $4DDA,x                         ; BAEE DD DA 4D                 ..M
        .byte   $8B                             ; BAF1 8B                       .
        lsr     a                               ; BAF2 4A                       J
        .byte   $3F                             ; BAF3 3F                       ?
        .byte   $3F                             ; BAF4 3F                       ?
        lsr     a                               ; BAF5 4A                       J
        .byte   $3F                             ; BAF6 3F                       ?
        lsr     a                               ; BAF7 4A                       J
        eor     $4C4F                           ; BAF8 4D 4F 4C                 MOL
        .byte   $3F                             ; BAFB 3F                       ?
        .byte   $3F                             ; BAFC 3F                       ?
        jmp     L4C3F                           ; BAFD 4C 3F 4C                 L?L

; ----------------------------------------------------------------------------
        eor     $3F3E                           ; BB00 4D 3E 3F                 M>?
        .byte   $3F                             ; BB03 3F                       ?
        .byte   $3F                             ; BB04 3F                       ?
        .byte   $3F                             ; BB05 3F                       ?
        .byte   $3F                             ; BB06 3F                       ?
        .byte   $3F                             ; BB07 3F                       ?
        bvc     LBB5F                           ; BB08 50 55                    PU
        lsr     $4E55                           ; BB0A 4E 55 4E                 NUN
        eor     $4E,x                           ; BB0D 55 4E                    UN
        rol     $4544,x                         ; BB0F 3E 44 45                 >DE
        .byte   $44                             ; BB12 44                       D
        eor     $44                             ; BB13 45 44                    ED
        .byte   $57                             ; BB15 57                       W
        eor     ($3E),y                         ; BB16 51 3E                    Q>
        eor     ($52),y                         ; BB18 51 52                    QR
        eor     ($89),y                         ; BB1A 51 89                    Q.
        .byte   $44                             ; BB1C 44                       D
        eor     $44                             ; BB1D 45 44                    ED
        rol     $45D6,x                         ; BB1F 3E D6 45                 >.E
        .byte   $44                             ; BB22 44                       D
        .byte   $57                             ; BB23 57                       W
        eor     ($89),y                         ; BB24 51 89                    Q.
        .byte   $44                             ; BB26 44                       D
        .byte   $DF                             ; BB27 DF                       .
        dec     $5152,x                         ; BB28 DE 52 51                 .RQ
        .byte   $89                             ; BB2B 89                       .
        .byte   $97                             ; BB2C 97                       .
        eor     $44                             ; BB2D 45 44                    ED
        cpx     #$3F                            ; BB2F E0 3F                    .?
        eor     LBCBB                           ; BB31 4D BB BC                 M..
        rol     $3E4D,x                         ; BB34 3E 4D 3E                 >M>
        .byte   $3F                             ; BB37 3F                       ?
        .byte   $3F                             ; BB38 3F                       ?
        eor     LBEBD                           ; BB39 4D BD BE                 M..
        rol     $3E4D,x                         ; BB3C 3E 4D 3E                 >M>
        .byte   $3F                             ; BB3F 3F                       ?
        .byte   $3F                             ; BB40 3F                       ?
        lsr     a                               ; BB41 4A                       J
        lsr     a                               ; BB42 4A                       J
        .byte   $3F                             ; BB43 3F                       ?
        .byte   $3F                             ; BB44 3F                       ?
        lsr     a                               ; BB45 4A                       J
        lsr     a                               ; BB46 4A                       J
        .byte   $3F                             ; BB47 3F                       ?
        eor     $E1E1                           ; BB48 4D E1 E1                 M..
        .byte   $3E                             ; BB4B 3E                       >
        .byte   $4D                             ; BB4C 4D                       M
LBB4D:  sbc     ($E1,x)                         ; BB4D E1 E1                    ..
        rol     $E14D,x                         ; BB4F 3E 4D E1                 >M.
        sbc     ($3E,x)                         ; BB52 E1 3E                    .>
        eor     $E1E1                           ; BB54 4D E1 E1                 M..
        rol     $4A3F,x                         ; BB57 3E 3F 4A                 >?J
        lsr     a                               ; BB5A 4A                       J
        .byte   $3F                             ; BB5B 3F                       ?
        .byte   $3F                             ; BB5C 3F                       ?
        lsr     a                               ; BB5D 4A                       J
        lsr     a                               ; BB5E 4A                       J
LBB5F:  .byte   $3F                             ; BB5F 3F                       ?
        eor     ($E2,x)                         ; BB60 41 E2                    A.
        .byte   $E2                             ; BB62 E2                       .
        eor     ($41,x)                         ; BB63 41 41                    AA
        .byte   $E2                             ; BB65 E2                       .
        .byte   $E2                             ; BB66 E2                       .
        .byte   $E3                             ; BB67 E3                       .
        .byte   $44                             ; BB68 44                       D
        .byte   $44                             ; BB69 44                       D
        .byte   $44                             ; BB6A 44                       D
        .byte   $44                             ; BB6B 44                       D
        .byte   $44                             ; BB6C 44                       D
        .byte   $44                             ; BB6D 44                       D
        .byte   $44                             ; BB6E 44                       D
        cpx     #$4D                            ; BB6F E0 4D                    .M
        .byte   $BB                             ; BB71 BB                       .
        ldy     $5E5D,x                         ; BB72 BC 5D 5E                 .]^
        .byte   $BB                             ; BB75 BB                       .
        ldy     $4D5D,x                         ; BB76 BC 5D 4D                 .]M
        lda     $5DBE,x                         ; BB79 BD BE 5D                 ..]
        lsr     LBEBD,x                         ; BB7C 5E BD BE                 ^..
        eor     $3F3F,x                         ; BB7F 5D 3F 3F                 ]??
        lsr     a                               ; BB82 4A                       J
        .byte   $3F                             ; BB83 3F                       ?
        .byte   $3F                             ; BB84 3F                       ?
        lsr     a                               ; BB85 4A                       J
        .byte   $3F                             ; BB86 3F                       ?
        .byte   $3F                             ; BB87 3F                       ?
        cpx     $4E                             ; BB88 E4 4E                    .N
        eor     $4E,x                           ; BB8A 55 4E                    UN
        lsr     $4E55                           ; BB8C 4E 55 4E                 NUN
        sbc     $E6                             ; BB8F E5 E6                    ..
        .byte   $44                             ; BB91 44                       D
        eor     $44                             ; BB92 45 44                    ED
        .byte   $44                             ; BB94 44                       D
        eor     $44                             ; BB95 45 44                    ED
        .byte   $6B                             ; BB97 6B                       k
        inc     $44                             ; BB98 E6 44                    .D
        .byte   $57                             ; BB9A 57                       W
        eor     ($51),y                         ; BB9B 51 51                    QQ
        .byte   $89                             ; BB9D 89                       .
        .byte   $44                             ; BB9E 44                       D
        .byte   $6B                             ; BB9F 6B                       k
        .byte   $6F                             ; BBA0 6F                       o
        eor     ($89),y                         ; BBA1 51 89                    Q.
        .byte   $44                             ; BBA3 44                       D
        .byte   $44                             ; BBA4 44                       D
        .byte   $57                             ; BBA5 57                       W
        eor     ($6C),y                         ; BBA6 51 6C                    Ql
        .byte   $44                             ; BBA8 44                       D
        .byte   $44                             ; BBA9 44                       D
        .byte   $57                             ; BBAA 57                       W
        eor     ($51),y                         ; BBAB 51 51                    QQ
        .byte   $89                             ; BBAD 89                       .
        .byte   $44                             ; BBAE 44                       D
        .byte   $6B                             ; BBAF 6B                       k
        lsr     LBCBB,x                         ; BBB0 5E BB BC                 ^..
        rol     LBB4D,x                         ; BBB3 3E 4D BB                 >M.
        ldy     $5E3E,x                         ; BBB6 BC 3E 5E                 .>^
        .byte   $BD                             ; BBB9 BD                       .
        .byte   $BE                             ; BBBA BE                       .
LBBBB:  eor     LBD5E,x                         ; BBBB 5D 5E BD                 ]^.
        ldx     $4D3E,y                         ; BBBE BE 3E 4D                 .>M
        .byte   $E7                             ; BBC1 E7                       .
        .byte   $E7                             ; BBC2 E7                       .
        .byte   $44                             ; BBC3 44                       D
        .byte   $44                             ; BBC4 44                       D
        .byte   $44                             ; BBC5 44                       D
        inx                                     ; BBC6 E8                       .
        rol     $444D,x                         ; BBC7 3E 4D 44                 >MD
        .byte   $5A                             ; BBCA 5A                       Z
        pha                                     ; BBCB 48                       H
        sbc     #$44                            ; BBCC E9 44                    .D
        nop                                     ; BBCE EA                       .
        rol     $444D,x                         ; BBCF 3E 4D 44                 >MD
        inx                                     ; BBD2 E8                       .
        .byte   $E7                             ; BBD3 E7                       .
        inx                                     ; BBD4 E8                       .
        .byte   $EB                             ; BBD5 EB                       .
        cpx     $4D3E                           ; BBD6 EC 3E 4D                 .>M
        .byte   $44                             ; BBD9 44                       D
        nop                                     ; BBDA EA                       .
        .byte   $44                             ; BBDB 44                       D
        nop                                     ; BBDC EA                       .
        lsr     $3E55                           ; BBDD 4E 55 3E                 NU>
        eor     $ECEB                           ; BBE0 4D EB EC                 M..
        eor     ($70),y                         ; BBE3 51 70                    Qp
        inx                                     ; BBE5 E8                       .
        .byte   $52                             ; BBE6 52                       R
        rol     $4E4D,x                         ; BBE7 3E 4D 4E                 >MN
        lsr     $4444                           ; BBEA 4E 44 44                 NDD
        nop                                     ; BBED EA                       .
        eor     $3E                             ; BBEE 45 3E                    E>
        .byte   $3F                             ; BBF0 3F                       ?
        eor     $4D3E                           ; BBF1 4D 3E 4D                 M>M
        rol     $3E4D,x                         ; BBF4 3E 4D 3E                 >M>
        .byte   $3F                             ; BBF7 3F                       ?
        .byte   $3F                             ; BBF8 3F                       ?
        eor     $4D3E                           ; BBF9 4D 3E 4D                 M>M
        rol     $3E4D,x                         ; BBFC 3E 4D 3E                 >M>
        .byte   $3F                             ; BBFF 3F                       ?
        eor     $EDEA                           ; BC00 4D EA ED                 M..
        rol     $3F3F,x                         ; BC03 3E 3F 3F                 >??
        .byte   $3F                             ; BC06 3F                       ?
        .byte   $3F                             ; BC07 3F                       ?
        eor     $44EA                           ; BC08 4D EA 44                 M.D
        rol     $3F3F,x                         ; BC0B 3E 3F 3F                 >??
        cpx     $55                             ; BC0E E4 55                    .U
        eor     $44EE                           ; BC10 4D EE 44                 M.D
        rol     $3F3F,x                         ; BC13 3E 3F 3F                 >??
        .byte   $EF                             ; BC16 EF                       .
        beq     LBC58                           ; BC17 F0 3F                    .?
        eor     $F144                           ; BC19 4D 44 F1                 MD.
        .byte   $E7                             ; BC1C E7                       .
        rol     $45E6,x                         ; BC1D 3E E6 45                 >.E
        .byte   $3F                             ; BC20 3F                       ?
        eor     $EA44                           ; BC21 4D 44 EA                 MD.
        .byte   $44                             ; BC24 44                       D
        rol     $F24D,x                         ; BC25 3E 4D F2                 >M.
        .byte   $3F                             ; BC28 3F                       ?
        eor     $EA56,y                         ; BC29 59 56 EA                 YV.
        .byte   $44                             ; BC2C 44                       D
        rol     $3F3F,x                         ; BC2D 3E 3F 3F                 >??
        .byte   $3F                             ; BC30 3F                       ?
        .byte   $3F                             ; BC31 3F                       ?
        eor     $44EA                           ; BC32 4D EA 44                 M.D
        .byte   $E7                             ; BC35 E7                       .
        rol     $3F3F,x                         ; BC36 3E 3F 3F                 >??
        .byte   $3F                             ; BC39 3F                       ?
        eor     $44EA                           ; BC3A 4D EA 44                 M.D
        .byte   $44                             ; BC3D 44                       D
        rol     $3F3F,x                         ; BC3E 3E 3F 3F                 >??
        inc     $44                             ; BC41 E6 44                    .D
        rol     $3F3F,x                         ; BC43 3E 3F 3F                 >??
        eor     $3F3E                           ; BC46 4D 3E 3F                 M>?
        .byte   $3F                             ; BC49 3F                       ?
        .byte   $3F                             ; BC4A 3F                       ?
        .byte   $3F                             ; BC4B 3F                       ?
        .byte   $3F                             ; BC4C 3F                       ?
        .byte   $3F                             ; BC4D 3F                       ?
        eor     $3F3E                           ; BC4E 4D 3E 3F                 M>?
        .byte   $3F                             ; BC51 3F                       ?
        .byte   $3F                             ; BC52 3F                       ?
        cpx     $4E                             ; BC53 E4 4E                    .N
        eor     $4E,x                           ; BC55 55 4E                    UN
        .byte   $3E                             ; BC57 3E                       >
LBC58:  .byte   $3F                             ; BC58 3F                       ?
        cpx     $F3                             ; BC59 E4 F3                    ..
        inc     $44                             ; BC5B E6 44                    .D
        eor     $44                             ; BC5D 45 44                    ED
        .byte   $F4                             ; BC5F F4                       .
        .byte   $3F                             ; BC60 3F                       ?
        .byte   $EF                             ; BC61 EF                       .
        sbc     $EF,x                           ; BC62 F5 EF                    ..
        eor     ($89),y                         ; BC64 51 89                    Q.
        .byte   $5A                             ; BC66 5A                       Z
        inc     $3F,x                           ; BC67 F6 3F                    .?
        inc     $6E                             ; BC69 E6 6E                    .n
        .byte   $6F                             ; BC6B 6F                       o
        sbc     $3F,x                           ; BC6C F5 3F                    .?
        .byte   $3F                             ; BC6E 3F                       ?
        .byte   $3F                             ; BC6F 3F                       ?
        eor     $5CEA                           ; BC70 4D EA 5C                 M.\
        .byte   $3F                             ; BC73 3F                       ?
        .byte   $F7                             ; BC74 F7                       .
        .byte   $3F                             ; BC75 3F                       ?
        .byte   $3F                             ; BC76 3F                       ?
        .byte   $3F                             ; BC77 3F                       ?
        eor     $5CEA                           ; BC78 4D EA 5C                 M.\
        .byte   $3F                             ; BC7B 3F                       ?
        .byte   $3F                             ; BC7C 3F                       ?
        .byte   $3F                             ; BC7D 3F                       ?
        .byte   $3F                             ; BC7E 3F                       ?
        .byte   $3F                             ; BC7F 3F                       ?
        .byte   $F7                             ; BC80 F7                       .
        .byte   $3F                             ; BC81 3F                       ?
        .byte   $3F                             ; BC82 3F                       ?
        .byte   $3F                             ; BC83 3F                       ?
        .byte   $3F                             ; BC84 3F                       ?
        .byte   $3F                             ; BC85 3F                       ?
        .byte   $3F                             ; BC86 3F                       ?
        .byte   $F7                             ; BC87 F7                       .
        cpx     $4E                             ; BC88 E4 4E                    .N
        lsr     $4E4E                           ; BC8A 4E 4E 4E                 NNN
        lsr     $F34E                           ; BC8D 4E 4E F3                 NN.
        .byte   $EF                             ; BC90 EF                       .
        eor     ($51),y                         ; BC91 51 51                    QQ
        eor     ($51),y                         ; BC93 51 51                    QQ
        eor     ($51),y                         ; BC95 51 51                    QQ
        sbc     $F8,x                           ; BC97 F5 F8                    ..
        .byte   $44                             ; BC99 44                       D
        .byte   $44                             ; BC9A 44                       D
        .byte   $44                             ; BC9B 44                       D
        .byte   $44                             ; BC9C 44                       D
        .byte   $44                             ; BC9D 44                       D
        .byte   $44                             ; BC9E 44                       D
        .byte   $5C                             ; BC9F 5C                       \
        sbc     $44E9,y                         ; BCA0 F9 E9 44                 ..D
        .byte   $44                             ; BCA3 44                       D
        .byte   $44                             ; BCA4 44                       D
        .byte   $44                             ; BCA5 44                       D
        .byte   $44                             ; BCA6 44                       D
        .byte   $5C                             ; BCA7 5C                       \
        .byte   $F7                             ; BCA8 F7                       .
        .byte   $3F                             ; BCA9 3F                       ?
        .byte   $EF                             ; BCAA EF                       .
        eor     ($51),y                         ; BCAB 51 51                    QQ
        eor     ($51),y                         ; BCAD 51 51                    QQ
        sbc     $3F,x                           ; BCAF F5 3F                    .?
        .byte   $3F                             ; BCB1 3F                       ?
        .byte   $F7                             ; BCB2 F7                       .
        .byte   $3F                             ; BCB3 3F                       ?
        .byte   $3F                             ; BCB4 3F                       ?
        eor     $F73E                           ; BCB5 4D 3E F7                 M>.
        .byte   $3F                             ; BCB8 3F                       ?
        .byte   $3F                             ; BCB9 3F                       ?
        .byte   $F7                             ; BCBA F7                       .
LBCBB:  .byte   $3F                             ; BCBB 3F                       ?
        .byte   $3F                             ; BCBC 3F                       ?
        eor     $F73E                           ; BCBD 4D 3E F7                 M>.
        .byte   $3F                             ; BCC0 3F                       ?
        inc     $44                             ; BCC1 E6 44                    .D
        rol     $3F3F,x                         ; BCC3 3E 3F 3F                 >??
        eor     $3F3E                           ; BCC6 4D 3E 3F                 M>?
        .byte   $3F                             ; BCC9 3F                       ?
        .byte   $3F                             ; BCCA 3F                       ?
        .byte   $3F                             ; BCCB 3F                       ?
        .byte   $3F                             ; BCCC 3F                       ?
        .byte   $3F                             ; BCCD 3F                       ?
LBCCE:  eor     $3F3E                           ; BCCE 4D 3E 3F                 M>?
        .byte   $3F                             ; BCD1 3F                       ?
        .byte   $3F                             ; BCD2 3F                       ?
        cpx     $4E                             ; BCD3 E4 4E                    .N
        eor     $4E,x                           ; BCD5 55 4E                    UN
        rol     $E43F,x                         ; BCD7 3E 3F E4                 >?.
        .byte   $F3                             ; BCDA F3                       .
        inc     $44                             ; BCDB E6 44                    .D
        eor     $44                             ; BCDD 45 44                    ED
        .byte   $F4                             ; BCDF F4                       .
        .byte   $3F                             ; BCE0 3F                       ?
        .byte   $EF                             ; BCE1 EF                       .
        sbc     $EF,x                           ; BCE2 F5 EF                    ..
        eor     ($89),y                         ; BCE4 51 89                    Q.
        .byte   $5A                             ; BCE6 5A                       Z
        inc     $3F,x                           ; BCE7 F6 3F                    .?
        inc     $6E                             ; BCE9 E6 6E                    .n
        .byte   $6F                             ; BCEB 6F                       o
        sbc     $3F,x                           ; BCEC F5 3F                    .?
        .byte   $3F                             ; BCEE 3F                       ?
        .byte   $3F                             ; BCEF 3F                       ?
        .byte   $3F                             ; BCF0 3F                       ?
        eor     $4D3E                           ; BCF1 4D 3E 4D                 M>M
        rol     $3E4D,x                         ; BCF4 3E 4D 3E                 >M>
        .byte   $3F                             ; BCF7 3F                       ?
        .byte   $3F                             ; BCF8 3F                       ?
        eor     $4D3E                           ; BCF9 4D 3E 4D                 M>M
        rol     $3E4D,x                         ; BCFC 3E 4D 3E                 >M>
        .byte   $3F                             ; BCFF 3F                       ?
        bit     $2C2C                           ; BD00 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD03 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD06 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD09 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD0C 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD0F 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD12 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD15 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD18 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD1B 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD1E 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD21 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD24 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD27 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD2A 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD2D 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD30 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD33 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD36 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD39 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD3C 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD3F 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD42 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD45 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD48 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD4B 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD4E 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD51 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD54 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD57 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD5A 2C 2C 2C                 ,,,
        .byte   $2C                             ; BD5D 2C                       ,
LBD5E:  bit     $2C2C                           ; BD5E 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD61 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD64 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD67 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD6A 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD6D 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD70 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD73 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD76 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD79 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD7C 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD7F 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD82 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD85 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD88 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD8B 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD8E 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD91 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD94 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD97 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD9A 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BD9D 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDA0 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDA3 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDA6 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDA9 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDAC 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDAF 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDB2 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDB5 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDB8 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDBB 2C 2C 2C                 ,,,
LBDBE:  bit     $2C2C                           ; BDBE 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDC1 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDC4 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDC7 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDCA 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDCD 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDD0 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDD3 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDD6 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDD9 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDDC 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDDF 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDE2 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDE5 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDE8 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDEB 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDEE 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDF1 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDF4 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDF7 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDFA 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BDFD 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE00 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE03 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE06 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE09 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE0C 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE0F 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE12 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE15 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE18 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE1B 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE1E 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE21 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE24 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE27 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE2A 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE2D 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE30 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE33 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE36 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE39 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE3C 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE3F 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE42 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE45 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE48 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE4B 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE4E 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE51 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE54 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE57 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE5A 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE5D 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE60 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE63 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE66 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE69 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE6C 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE6F 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE72 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE75 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE78 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE7B 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE7E 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE81 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE84 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE87 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE8A 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE8D 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE90 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE93 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE96 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE99 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE9C 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BE9F 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEA2 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEA5 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEA8 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEAB 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEAE 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEB1 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEB4 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEB7 2C 2C 2C                 ,,,
        .byte   $2C                             ; BEBA 2C                       ,
        .byte   $2C                             ; BEBB 2C                       ,
LBEBC:  .byte   $2C                             ; BEBC 2C                       ,
LBEBD:  bit     $2C2C                           ; BEBD 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEC0 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEC3 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEC6 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEC9 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BECC 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BECF 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BED2 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BED5 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BED8 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEDB 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEDE 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEE1 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEE4 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEE7 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEEA 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEED 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEF0 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEF3 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEF6 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEF9 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEFC 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BEFF 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF02 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF05 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF08 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF0B 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF0E 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF11 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF14 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF17 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF1A 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF1D 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF20 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF23 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF26 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF29 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF2C 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF2F 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF32 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF35 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF38 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF3B 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF3E 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF41 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF44 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF47 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF4A 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF4D 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF50 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF53 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF56 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF59 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF5C 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF5F 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF62 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF65 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF68 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF6B 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF6E 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF71 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF74 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF77 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF7A 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF7D 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF80 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF83 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF86 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF89 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF8C 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF8F 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF92 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF95 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF98 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF9B 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BF9E 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFA1 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFA4 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFA7 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFAA 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFAD 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFB0 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFB3 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFB6 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFB9 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFBC 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFBF 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFC2 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFC5 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFC8 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFCB 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFCE 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFD1 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFD4 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFD7 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFDA 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFDD 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFE0 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFE3 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFE6 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFE9 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFEC 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFEF 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFF2 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFF5 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFF8 2C 2C 2C                 ,,,
        bit     $2C2C                           ; BFFB 2C 2C 2C                 ,,,
        .byte   $2C                             ; BFFE 2C                       ,
        .byte   $2C                             ; BFFF 2C                       ,
