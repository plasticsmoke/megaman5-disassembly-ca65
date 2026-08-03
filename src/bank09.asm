.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK09"

; =============================================================================
; BANK $09 (mapped at $A000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
; =============================================================================
L0000           := $0000
L0564           := $0564
L193D           := $193D
L1F20           := $1F20
L201F           := $201F
L2821           := $2821
L2895           := $2895
L3D1F           := $3D1F
L4C4C           := $4C4C
L5864           := $5864
L6040           := $6040
L606C           := $606C
L8477           := $8477
L84A6           := $84A6
L850B           := $850B
L852F           := $852F
L8541           := $8541
L854D           := $854D
L8550           := $8550
LC030           := $C030
; ----------------------------------------------------------------------------
; --- LA000: spawn the boss's two escort pods — type := own type + 1,
; preset $46 with dir base $0D, linked both ways ($0480 = boss slot);
; Dark Man 2 pods get xvel $00.80, Dark Man 4 pods $01.00.
LA000:  lda     #$01                            ; A000 A9 01                    ..
        sta     $0E                             ; A002 85 0E                    ..
LA004:  jsr     find_free_slot_y                           ; A004 20 6F F1                  o.
        lda     #$A0                            ; A007 A9 A0                    ..
        sta     $0408,y                         ; A009 99 08 04                 ...
        lda     $0300,x                         ; A00C BD 00 03                 ...
        clc                                     ; A00F 18                       .
        adc     #$01                            ; A010 69 01                    i.
        sta     $0300,y                         ; A012 99 00 03                 ...
        lda     $0E                             ; A015 A5 0E                    ..
        clc                                     ; A017 18                       .
        adc     #$01                            ; A018 69 01                    i.
        sta     $0420,y                         ; A01A 99 20 04                 . .
        adc     $0D                             ; A01D 65 0D                    e.
        sta     $10                             ; A01F 85 10                    ..
        lda     #$46                            ; A021 A9 46                    .F
        jsr     entity_speed_preset                           ; A023 20 F5 EA                  ..
        lda     $0528,y                         ; A026 B9 28 05                 .(.
        ora     #$08                            ; A029 09 08                    ..
        sta     $0528,y                         ; A02B 99 28 05                 .(.
        lda     $0378,x                         ; A02E BD 78 03                 .x.
        sta     $0378,y                         ; A031 99 78 03                 .x.
        lda     #$40                            ; A034 A9 40                    .@
        sta     $0468,y                         ; A036 99 68 04                 .h.
        txa                                     ; A039 8A                       .
        sta     $0480,y                         ; A03A 99 80 04                 ...
        lda     $0300,x                         ; A03D BD 00 03                 ...
        cmp     #$91                            ; A040 C9 91                    ..
        bne     LA04D                           ; A042 D0 09                    ..
        lda     #$80                            ; A044 A9 80                    ..
        sta     $03A8,y                         ; A046 99 A8 03                 ...
        lda     #$00                            ; A049 A9 00                    ..
        beq     LA054                           ; A04B F0 07                    ..
LA04D:  lda     #$00                            ; A04D A9 00                    ..
        sta     $03A8,y                         ; A04F 99 A8 03                 ...
        lda     #$01                            ; A052 A9 01                    ..
LA054:  sta     $03C0,y                         ; A054 99 C0 03                 ...
        dec     $0E                             ; A057 C6 0E                    ..
        bpl     LA004                           ; A059 10 A9                    ..
        rts                                     ; A05B 60                       `

; ----------------------------------------------------------------------------
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $91 — DARK MAN 2 (Proto castle 2 boss). Spawns two
; type $92 shield pods (LA000, dir base $57), then rolls back and
; forth; as his HP falls through the LA0E1 thresholds he shifts up a
; gear (+$40 xvel sub) and changes tread sub_type (LA0E7). On each
; turn-around: $78-frame pause with turn anim (sub $41).
; =============================================================================
        lda     #$57                            ; A05C A9 57                    .W
        sta     $0D                             ; A05E 85 0D                    ..
        jsr     LA000                           ; A060 20 00 A0                  ..
        lda     #$6D                            ; A063 A9 6D                    .m
        sta     $0588,x                         ; A065 9D 88 05                 ...
        lda     #$A0                            ; A068 A9 A0                    ..
        sta     $05A0,x                         ; A06A 9D A0 05                 ...
        lda     $0330,x                         ; A06D BD 30 03                 .0.
        sta     $0480,x                         ; A070 9D 80 04                 ...
        lda     $0468,x                         ; A073 BD 68 04                 .h.
        beq     LA089                           ; A076 F0 11                    ..
        dec     $0468,x                         ; A078 DE 68 04                 .h.
        bne     LA0E0                           ; A07B D0 63                    .c
        lda     $04B0,x                         ; A07D BD B0 04                 ...
        jsr     entity_set_subtype                           ; A080 20 98 EA                  ..
        jsr     entity_set_facing                           ; A083 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A086 20 30 EC                  0.
LA089:  ldy     $0498,x                         ; A089 BC 98 04                 ...
        lda     LA0E1,y                         ; A08C B9 E1 A0                 ...
        beq     LA0C0                           ; A08F F0 2F                    ./
        cmp     $0450,x                         ; A091 DD 50 04                 .P.
        bcc     LA0C0                           ; A094 90 2A                    .*
        lda     LA0E7,y                         ; A096 B9 E7 A0                 ...
        sta     $0558,x                         ; A099 9D 58 05                 .X.
        inc     $0540,x                         ; A09C FE 40 05                 .@.
        lda     $0540,x                         ; A09F BD 40 05                 .@.
        and     #$03                            ; A0A2 29 03                    ).
        sta     $0540,x                         ; A0A4 9D 40 05                 .@.
        lda     #$00                            ; A0A7 A9 00                    ..
        sta     $0570,x                         ; A0A9 9D 70 05                 .p.
        lda     $03A8,x                         ; A0AC BD A8 03                 ...
        clc                                     ; A0AF 18                       .
        adc     #$40                            ; A0B0 69 40                    i@
        sta     $03A8,x                         ; A0B2 9D A8 03                 ...
        lda     $03C0,x                         ; A0B5 BD C0 03                 ...
        adc     #$00                            ; A0B8 69 00                    i.
        sta     $03C0,x                         ; A0BA 9D C0 03                 ...
        inc     $0498,x                         ; A0BD FE 98 04                 ...
LA0C0:  jsr     entity_facing_dispatch                           ; A0C0 20 65 EA                  e.
        lda     $0420,x                         ; A0C3 BD 20 04                 . .
        pha                                     ; A0C6 48                       H
        jsr     entity_set_facing                           ; A0C7 20 16 EC                  ..
        pla                                     ; A0CA 68                       h
        cmp     $0420,x                         ; A0CB DD 20 04                 . .
        beq     LA0E0                           ; A0CE F0 10                    ..
        lda     $0558,x                         ; A0D0 BD 58 05                 .X.
        sta     $04B0,x                         ; A0D3 9D B0 04                 ...
        lda     #$78                            ; A0D6 A9 78                    .x
        sta     $0468,x                         ; A0D8 9D 68 04                 .h.
        lda     #$41                            ; A0DB A9 41                    .A
        jsr     entity_set_subtype                           ; A0DD 20 98 EA                  ..
LA0E0:  rts                                     ; A0E0 60                       `

; ----------------------------------------------------------------------------
LA0E1:  .byte   $1A,$17,$14,$11,$0E,$00         ; A0E1  HP gear thresholds
LA0E7:  .byte   $43,$43,$44,$44,$45,$00         ; A0E7  tread sub_type per gear
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $92 — Dark Man 2's shield pod: hovers beside the boss
; mirroring his X movement (delta of boss X vs his $0480 mark),
; flipping to face him every $40 frames; dies with him.
; =============================================================================
        jsr     L8541                           ; A0ED 20 41 85                  A.
        dec     $0468,x                         ; A0F0 DE 68 04                 .h.
        bne     LA0FD                           ; A0F3 D0 08                    ..
        lda     #$40                            ; A0F5 A9 40                    .@
        sta     $0468,x                         ; A0F7 9D 68 04                 .h.
        jsr     L852F                           ; A0FA 20 2F 85                  /.
LA0FD:  lda     #$00                            ; A0FD A9 00                    ..
        sta     $01                             ; A0FF 85 01                    ..
        ldy     $0480,x                         ; A101 BC 80 04                 ...
        lda     $0300,y                         ; A104 B9 00 03                 ...
        cmp     #$91                            ; A107 C9 91                    ..
        beq     LA10E                           ; A109 F0 03                    ..
        jmp     entity_wipe_x                           ; A10B 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LA10E:  lda     $0330,y                         ; A10E B9 30 03                 .0.
        sec                                     ; A111 38                       8
        sbc     $0480,y                         ; A112 F9 80 04                 ...
        sta     L0000                           ; A115 85 00                    ..
        beq     LA12E                           ; A117 F0 15                    ..
        bpl     LA11D                           ; A119 10 02                    ..
        dec     $01                             ; A11B C6 01                    ..
LA11D:  lda     $0330,x                         ; A11D BD 30 03                 .0.
        clc                                     ; A120 18                       .
        adc     L0000                           ; A121 65 00                    e.
        sta     $0330,x                         ; A123 9D 30 03                 .0.
        lda     $0348,x                         ; A126 BD 48 03                 .H.
        adc     $01                             ; A129 65 01                    e.
        sta     $0348,x                         ; A12B 9D 48 03                 .H.
LA12E:  rts                                     ; A12E 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $93 — DARK MAN 3 (Proto castle 3 boss). While the
; player isn't frozen: close range (< $40 px) -> the paralyzer burst
; (sub $4E, $A255): at the anim beat, three type $95 stun shots fan
; out around the aim line, and the touched player is white-flashed
; and frozen (LA662 + $54). Otherwise by RNG: a walking burst (sub
; $4D, $A238) or a jump (arc $1C:8550, sub $4C): at even airborne
; frames he fires aimed type $94 shots ($A1C7, speed $10).
; =============================================================================
        lda     $0498,x                         ; A12F BD 98 04                 ...
        beq     LA138                           ; A132 F0 04                    ..
        dec     $0498,x                         ; A134 DE 98 04                 ...
        rts                                     ; A137 60                       `

; ----------------------------------------------------------------------------
LA138:  lda     $54                             ; A138 A5 54                    .T
        bne     LA184                           ; A13A D0 48                    .H
        jsr     entity_set_facing                           ; A13C 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A13F 20 30 EC                  0.
        jsr     entity_x_dist_px                           ; A142 20 94 EC                  ..
        cmp     #$40                            ; A145 C9 40                    .@
        bcs     LA15B                           ; A147 B0 12                    ..
        lda     #$4E                            ; A149 A9 4E                    .N
        jsr     entity_set_subtype                           ; A14B 20 98 EA                  ..
        lda     #$55                            ; A14E A9 55                    .U
        sta     $0588,x                         ; A150 9D 88 05                 ...
        lda     #$A2                            ; A153 A9 A2                    ..
        sta     $05A0,x                         ; A155 9D A0 05                 ...
        jmp     LA255                           ; A158 4C 55 A2                 LU.

; ----------------------------------------------------------------------------
LA15B:  adc     $E7                             ; A15B 65 E7                    e.
        sta     $E6                             ; A15D 85 E6                    ..
        and     #$03                            ; A15F 29 03                    ).
        beq     LA184                           ; A161 F0 21                    .!
        lda     #$00                            ; A163 A9 00                    ..
        sta     $03A8,x                         ; A165 9D A8 03                 ...
        lda     #$01                            ; A168 A9 01                    ..
        sta     $03C0,x                         ; A16A 9D C0 03                 ...
        lda     #$4D                            ; A16D A9 4D                    .M
        jsr     entity_set_subtype                           ; A16F 20 98 EA                  ..
        lda     #$0F                            ; A172 A9 0F                    ..
        sta     $0468,x                         ; A174 9D 68 04                 .h.
        lda     #$38                            ; A177 A9 38                    .8
        sta     $0588,x                         ; A179 9D 88 05                 ...
        lda     #$A2                            ; A17C A9 A2                    ..
        sta     $05A0,x                         ; A17E 9D A0 05                 ...
        jmp     LA238                           ; A181 4C 38 A2                 L8.

; ----------------------------------------------------------------------------
LA184:  jsr     entity_x_dist_px                           ; A184 20 94 EC                  ..
        lsr     a                               ; A187 4A                       J
        ldy     #$01                            ; A188 A0 01                    ..
        jsr     L8550                           ; A18A 20 50 85                  P.
        lda     #$4C                            ; A18D A9 4C                    .L
        jsr     entity_set_subtype                           ; A18F 20 98 EA                  ..
        lda     #$9C                            ; A192 A9 9C                    ..
        sta     $0588,x                         ; A194 9D 88 05                 ...
        lda     #$A1                            ; A197 A9 A1                    ..
        sta     $05A0,x                         ; A199 9D A0 05                 ...
        lda     $0558,x                         ; A19C BD 58 05                 .X.
        cmp     #$4F                            ; A19F C9 4F                    .O
        beq     LA1B2                           ; A1A1 F0 0F                    ..
        lda     $0540,x                         ; A1A3 BD 40 05                 .@.
        beq     LA1FE                           ; A1A6 F0 56                    .V
        lda     $03F0,x                         ; A1A8 BD F0 03                 ...
        bpl     LA211                           ; A1AB 10 64                    .d
        lda     #$4F                            ; A1AD A9 4F                    .O
        jsr     entity_set_subtype                           ; A1AF 20 98 EA                  ..
LA1B2:  jsr     L850B                           ; A1B2 20 0B 85                  ..
        lda     $0570,x                         ; A1B5 BD 70 05                 .p.
        cmp     #$04                            ; A1B8 C9 04                    ..
        bne     LA1FE                           ; A1BA D0 42                    .B
        lda     $0540,x                         ; A1BC BD 40 05                 .@.
        cmp     #$09                            ; A1BF C9 09                    ..
        beq     LA1FF                           ; A1C1 F0 3C                    .<
        and     #$01                            ; A1C3 29 01                    ).
        bne     LA1FE                           ; A1C5 D0 37                    .7
        jsr     entity_distance_calc                           ; A1C7 20 C2 EC                  ..
        sta     $0E                             ; A1CA 85 0E                    ..
        stx     $0F                             ; A1CC 86 0F                    ..
        jsr     find_free_slot_y                           ; A1CE 20 6F F1                  o.
        bcs     LA1FE                           ; A1D1 B0 2B                    .+
        lda     #$86                            ; A1D3 A9 86                    ..
        sta     $0408,y                         ; A1D5 99 08 04                 ...
        lda     #$94                            ; A1D8 A9 94                    ..
        sta     $0300,y                         ; A1DA 99 00 03                 ...
        lda     #$13                            ; A1DD A9 13                    ..
        sta     L0000                           ; A1DF 85 00                    ..
        lda     $0528,x                         ; A1E1 BD 28 05                 .(.
        and     #$20                            ; A1E4 29 20                    ) 
        beq     LA1EA                           ; A1E6 F0 02                    ..
        inc     L0000                           ; A1E8 E6 00                    ..
LA1EA:  lda     L0000                           ; A1EA A5 00                    ..
        sta     $10                             ; A1EC 85 10                    ..
        lda     #$51                            ; A1EE A9 51                    .Q
        jsr     entity_speed_preset                           ; A1F0 20 F5 EA                  ..
        tya                                     ; A1F3 98                       .
        tax                                     ; A1F4 AA                       .
        ldy     $0E                             ; A1F5 A4 0E                    ..
        lda     #$10                            ; A1F7 A9 10                    ..
        jsr     entity_set_dir_velocity                           ; A1F9 20 70 F4                  p.
        ldx     $0F                             ; A1FC A6 0F                    ..
LA1FE:  rts                                     ; A1FE 60                       `

; ----------------------------------------------------------------------------
LA1FF:  lda     #$4C                            ; A1FF A9 4C
        jsr     entity_set_subtype              ; A201 20 98 EA
        inc     $0540,x                         ; A204 FE 40 05                 .@.
        lda     #$11                            ; A207 A9 11                    ..
        sta     $0588,x                         ; A209 9D 88 05                 ...
        lda     #$A2                            ; A20C A9 A2                    ..
        sta     $05A0,x                         ; A20E 9D A0 05                 ...
LA211:  lda     $0540,x                         ; A211 BD 40 05                 .@.
        cmp     #$02                            ; A214 C9 02                    ..
        beq     LA22E                           ; A216 F0 16                    ..
        lda     #$00                            ; A218 A9 00                    ..
        sta     $0570,x                         ; A21A 9D 70 05                 .p.
        ldy     #$1C                            ; A21D A0 1C                    ..
        jsr     entity_gravity_collide                           ; A21F 20 B7 E7                  ..
        bcs     LA229                           ; A222 B0 05                    ..
        ldy     #$1E                            ; A224 A0 1E                    ..
        jmp     entity_horiz_dispatch                           ; A226 4C 3F EA                 L?.

; ----------------------------------------------------------------------------
LA229:  lda     #$02                            ; A229 A9 02                    ..
        sta     $0540,x                         ; A22B 9D 40 05                 .@.
LA22E:  lda     $0570,x                         ; A22E BD 70 05                 .p.
        cmp     #$08                            ; A231 C9 08                    ..
        bne     LA254                           ; A233 D0 1F                    ..
        jmp     LA2C3                           ; A235 4C C3 A2                 L..

; ----------------------------------------------------------------------------
LA238:  ldy     #$1E                            ; A238 A0 1E                    ..
        jsr     entity_horiz_dispatch                           ; A23A 20 3F EA                  ?.
        bcc     LA242                           ; A23D 90 03                    ..
        jsr     entity_flip_direction                           ; A23F 20 4A EC                  J.
LA242:  dec     $0468,x                         ; A242 DE 68 04                 .h.
        bne     LA254                           ; A245 D0 0D                    ..
        lda     #$10                            ; A247 A9 10                    ..
        sta     $0498,x                         ; A249 9D 98 04                 ...
        lda     #$4B                            ; A24C A9 4B                    .K
        jsr     entity_set_subtype                           ; A24E 20 98 EA                  ..
        jmp     LA2C3                           ; A251 4C C3 A2                 L..

; ----------------------------------------------------------------------------
LA254:  rts                                     ; A254 60                       `

; ----------------------------------------------------------------------------
LA255:  jsr     entity_set_facing                           ; A255 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A258 20 30 EC                  0.
        lda     $0570,x                         ; A25B BD 70 05                 .p.
        cmp     #$04                            ; A25E C9 04                    ..
        bne     LA254                           ; A260 D0 F2                    ..
        lda     $0540,x                         ; A262 BD 40 05                 .@.
        cmp     #$09                            ; A265 C9 09                    ..
        beq     LA2A6                           ; A267 F0 3D                    .=
        cmp     #$08                            ; A269 C9 08                    ..
        bne     LA254                           ; A26B D0 E7                    ..
        stx     $0F                             ; A26D 86 0F                    ..
        jsr     entity_distance_calc                           ; A26F 20 C2 EC                  ..
        sec                                     ; A272 38                       8
        sbc     #$01                            ; A273 E9 01                    ..
        sta     $0E                             ; A275 85 0E                    ..
        lda     #$02                            ; A277 A9 02                    ..
        sta     $0D                             ; A279 85 0D                    ..
LA27B:  jsr     find_free_slot_y                           ; A27B 20 6F F1                  o.
        bcs     LA254                           ; A27E B0 D4                    ..
        lda     #$06                            ; A280 A9 06                    ..
        sta     $0408,y                         ; A282 99 08 04                 ...
        lda     #$95                            ; A285 A9 95                    ..
        sta     $0300,y                         ; A287 99 00 03                 ...
        lda     #$50                            ; A28A A9 50                    .P
        jsr     entity_init_pos                           ; A28C 20 A4 EA                  ..
        tya                                     ; A28F 98                       .
        tax                                     ; A290 AA                       .
        lda     $0E                             ; A291 A5 0E                    ..
        and     #$0F                            ; A293 29 0F                    ).
        sta     $0E                             ; A295 85 0E                    ..
        tay                                     ; A297 A8                       .
        lda     #$08                            ; A298 A9 08                    ..
        jsr     entity_set_dir_velocity                           ; A29A 20 70 F4                  p.
        ldx     $0F                             ; A29D A6 0F                    ..
        inc     $0E                             ; A29F E6 0E                    ..
        dec     $0D                             ; A2A1 C6 0D                    ..
        bpl     LA27B                           ; A2A3 10 D6                    ..
        rts                                     ; A2A5 60                       `

; ----------------------------------------------------------------------------
LA2A6:  lda     #$4B                            ; A2A6 A9 4B                    .K
        jsr     entity_set_subtype                           ; A2A8 20 98 EA                  ..
        lda     #$B5                            ; A2AB A9 B5                    ..
        sta     $0588,x                         ; A2AD 9D 88 05                 ...
        lda     #$A2                            ; A2B0 A9 A2                    ..
        sta     $05A0,x                         ; A2B2 9D A0 05                 ...
        ldy     #$17                            ; A2B5 A0 17                    ..
LA2B7:  lda     $0300,y                         ; A2B7 B9 00 03                 ...
        cmp     #$95                            ; A2BA C9 95                    ..
        beq     LA2CD                           ; A2BC F0 0F                    ..
        dey                                     ; A2BE 88                       .
        cpy     #$07                            ; A2BF C0 07                    ..
        bcs     LA2B7                           ; A2C1 B0 F4                    ..
LA2C3:  lda     #$2F                            ; A2C3 A9 2F                    ./
        sta     $0588,x                         ; A2C5 9D 88 05                 ...
        lda     #$A1                            ; A2C8 A9 A1                    ..
        sta     $05A0,x                         ; A2CA 9D A0 05                 ...
LA2CD:  rts                                     ; A2CD 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR types $94/$97 — Dark Man straight shots (DM3 jump shot /
; DM1 roll shot): fly with their spawn velocity.
; =============================================================================
        jsr     entity_facing_dispatch                           ; A2CE 20 65 EA                  e.
        jmp     entity_vert_dispatch_raw                           ; A2D1 4C 86 EA                 L..

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $95 — Dark Man 3's stun shot: on player contact in
; play, white-flash palette + hit_freeze $FF (LA662) — paralysis.
; =============================================================================
        jsr     entity_facing_dispatch                           ; A2D4 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A2D7 20 86 EA                  ..
        jsr     entity_player_collide                           ; A2DA 20 87 EF                  ..
        bcs     LA2CD                           ; A2DD B0 EE                    ..
        lda     $30                             ; A2DF A5 30                    .0
        cmp     #$06                            ; A2E1 C9 06                    ..
        bcs     LA2CD                           ; A2E3 B0 E8                    ..
        jsr     LA662                           ; A2E5 20 62 A6                  b.
        sty     $54                             ; A2E8 84 54                    .T
        rts                                     ; A2EA 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $96 — DARK MAN 1 (Proto castle 1 boss). Rolls at the
; player; damage changes his speed (HP bands at $A328: below $12 HP
; xvel px 1, below 8 stop-and-fire), turn-arounds pause $1E (sub
; $52); when flagged ($0498) he stops and fires type $97 shots from
; the chest ($A364: preset $51 level, or aimed 16-dir when stopped).
; =============================================================================
        lda     #$1C                            ; A2EB A9 1C                    ..
        sta     $04B0,x                         ; A2ED 9D B0 04                 ...
        lda     #$3C                            ; A2F0 A9 3C                    .<
        sta     $0480,x                         ; A2F2 9D 80 04                 ...
        lda     #$FF                            ; A2F5 A9 FF                    ..
        sta     $0588,x                         ; A2F7 9D 88 05                 ...
        lda     #$A2                            ; A2FA A9 A2                    ..
        sta     $05A0,x                         ; A2FC 9D A0 05                 ...
        lda     $0468,x                         ; A2FF BD 68 04                 .h.
        beq     LA314                           ; A302 F0 10                    ..
        dec     $0468,x                         ; A304 DE 68 04                 .h.
        bne     LA35D                           ; A307 D0 54                    .T
        jsr     entity_set_facing                           ; A309 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A30C 20 30 EC                  0.
        lda     #$53                            ; A30F A9 53                    .S
        jsr     entity_set_subtype                           ; A311 20 98 EA                  ..
LA314:  dec     $0480,x                         ; A314 DE 80 04                 ...
        bne     LA320                           ; A317 D0 07                    ..
        lda     #$00                            ; A319 A9 00                    ..
        sta     $0498,x                         ; A31B 9D 98 04                 ...
        beq     LA364                           ; A31E F0 44                    .D
LA320:  lda     $0450,x                         ; A320 BD 50 04                 .P.
        cmp     $04B0,x                         ; A323 DD B0 04                 ...
        beq     LA343                           ; A326 F0 1B                    ..
        cmp     #$12                            ; A328 C9 12                    ..
        bcs     LA33C                           ; A32A B0 10                    ..
        cmp     #$08                            ; A32C C9 08                    ..
        bcs     LA337                           ; A32E B0 07                    ..
        lda     #$00                            ; A330 A9 00                    ..
        sta     $03C0,x                         ; A332 9D C0 03                 ...
        bne     LA33C                           ; A335 D0 05                    ..
LA337:  lda     #$01                            ; A337 A9 01                    ..
        sta     $03C0,x                         ; A339 9D C0 03                 ...
LA33C:  lda     #$FF                            ; A33C A9 FF                    ..
        sta     $0498,x                         ; A33E 9D 98 04                 ...
        bne     LA364                           ; A341 D0 21                    .!
LA343:  jsr     entity_facing_dispatch                           ; A343 20 65 EA                  e.
        lda     $0420,x                         ; A346 BD 20 04                 . .
        pha                                     ; A349 48                       H
        jsr     entity_set_facing                           ; A34A 20 16 EC                  ..
        pla                                     ; A34D 68                       h
        cmp     $0420,x                         ; A34E DD 20 04                 . .
        beq     LA35D                           ; A351 F0 0A                    ..
        lda     #$1E                            ; A353 A9 1E                    ..
        sta     $0468,x                         ; A355 9D 68 04                 .h.
        lda     #$52                            ; A358 A9 52                    .R
        jsr     entity_set_subtype                           ; A35A 20 98 EA                  ..
LA35D:  lda     $0450,x                         ; A35D BD 50 04                 .P.
        sta     $04B0,x                         ; A360 9D B0 04                 ...
LA363:  rts                                     ; A363 60                       `

; ----------------------------------------------------------------------------
LA364:  jsr     entity_set_facing                           ; A364 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A367 20 30 EC                  0.
        lda     #$54                            ; A36A A9 54                    .T
        cmp     $0558,x                         ; A36C DD 58 05                 .X.
        beq     LA37E                           ; A36F F0 0D                    ..
        jsr     entity_set_subtype                           ; A371 20 98 EA                  ..
        lda     #$64                            ; A374 A9 64                    .d
        sta     $0588,x                         ; A376 9D 88 05                 ...
        lda     #$A3                            ; A379 A9 A3                    ..
        sta     $05A0,x                         ; A37B 9D A0 05                 ...
LA37E:  lda     $0570,x                         ; A37E BD 70 05
        cmp     #$04                            ; A381 C9 04
        bne     LA363                           ; A383 D0 DE                    ..
        stx     $0F                             ; A385 86 0F                    ..
        jsr     entity_distance_calc                           ; A387 20 C2 EC                  ..
        sta     $0E                             ; A38A 85 0E                    ..
        jsr     find_free_slot_y                           ; A38C 20 6F F1                  o.
        bcs     LA363                           ; A38F B0 D2                    ..
        lda     #$87                            ; A391 A9 87                    ..
        sta     $0408,y                         ; A393 99 08 04                 ...
        lda     #$97                            ; A396 A9 97                    ..
        sta     $0300,y                         ; A398 99 00 03                 ...
        lda     $0420,x                         ; A39B BD 20 04                 . .
        sta     $0420,y                         ; A39E 99 20 04                 . .
        and     #$01                            ; A3A1 29 01                    ).
        clc                                     ; A3A3 18                       .
        adc     #$40                            ; A3A4 69 40                    i@
        sta     $10                             ; A3A6 85 10                    ..
        lda     #$51                            ; A3A8 A9 51                    .Q
        jsr     entity_speed_preset                           ; A3AA 20 F5 EA                  ..
        lda     #$00                            ; A3AD A9 00                    ..
        sta     $03A8,y                         ; A3AF 99 A8 03                 ...
        lda     #$03                            ; A3B2 A9 03                    ..
        sta     $03C0,y                         ; A3B4 99 C0 03                 ...
        lda     $0498,x                         ; A3B7 BD 98 04                 ...
        beq     LA3C7                           ; A3BA F0 0B                    ..
        tya                                     ; A3BC 98                       .
        tax                                     ; A3BD AA                       .
        ldy     $0E                             ; A3BE A4 0E                    ..
        lda     #$10                            ; A3C0 A9 10                    ..
        jsr     entity_set_dir_velocity                           ; A3C2 20 70 F4                  p.
        ldx     $0F                             ; A3C5 A6 0F                    ..
LA3C7:  lda     #$D1                            ; A3C7 A9 D1                    ..
        sta     $0588,x                         ; A3C9 9D 88 05                 ...
        lda     #$A3                            ; A3CC A9 A3                    ..
        sta     $05A0,x                         ; A3CE 9D A0 05                 ...
        lda     #$00                            ; A3D1 A9 00                    ..
        sta     $0570,x                         ; A3D3 9D 70 05                 .p.
        ldy     #$17                            ; A3D6 A0 17                    ..
LA3D8:  lda     $0300,y                         ; A3D8 B9 00 03                 ...
        cmp     #$97                            ; A3DB C9 97                    ..
        beq     LA404                           ; A3DD F0 25                    .%
        dey                                     ; A3DF 88                       .
        cpy     #$07                            ; A3E0 C0 07                    ..
        bcs     LA3D8                           ; A3E2 B0 F4                    ..
        jsr     entity_set_facing                           ; A3E4 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A3E7 20 30 EC                  0.
        lda     #$3C                            ; A3EA A9 3C                    .<
        sta     $0480,x                         ; A3EC 9D 80 04                 ...
        lda     #$FF                            ; A3EF A9 FF                    ..
        sta     $0588,x                         ; A3F1 9D 88 05                 ...
        lda     #$A2                            ; A3F4 A9 A2                    ..
        sta     $05A0,x                         ; A3F6 9D A0 05                 ...
        lda     #$53                            ; A3F9 A9 53                    .S
        jsr     entity_set_subtype                           ; A3FB 20 98 EA                  ..
        lda     $0450,x                         ; A3FE BD 50 04                 .P.
        sta     $04B0,x                         ; A401 9D B0 04
LA404:  rts                                     ; A404 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $98 — DARK MAN 4 (Proto castle 4 boss; also created
; in place by the fake-Proto-Man scene, $03:A252, arriving with full
; HP). Rematch spawns run their own intro: freeze ($84A6) + HP fill
; ($1C:8477), shape $CC. Spawns two type $99 shield segments (LA000,
; dir base $3B), then alternates by RNG between the ring attack (sub
; $49, $A4ED: type $9A paralyzer rings at odd anim frames, preset
; $4A) and jumps (L854D, sub $48/$47); after a jump he recalls the
; shields and waits for them to re-form ($A4D7).
; =============================================================================
        lda     $0450,x                         ; A405 BD 50 04                 .P.
        cmp     #$1C                            ; A408 C9 1C                    ..
        beq     LA42E                           ; A40A F0 22                    ."
        lda     $30                             ; A40C A5 30                    .0
        bne     LA46D                           ; A40E D0 5D                    .]
        lda     $0378                           ; A410 AD 78 03                 .x.
        cmp     #$B4                            ; A413 C9 B4                    ..
        bcc     LA46D                           ; A415 90 56                    .V
        jsr     L84A6                           ; A417 20 A6 84                  ..
        lda     #$24                            ; A41A A9 24                    .$
        sta     $0588,x                         ; A41C 9D 88 05                 ...
        lda     #$A4                            ; A41F A9 A4                    ..
        sta     $05A0,x                         ; A421 9D A0 05                 ...
        jsr     L8477                           ; A424 20 77 84                  w.
        bcs     LA46D                           ; A427 B0 44                    .D
        lda     #$CC                            ; A429 A9 CC                    ..
        sta     $0408,x                         ; A42B 9D 08 04                 ...
LA42E:  lda     #$3B                            ; A42E A9 3B                    .;
        sta     $0D                             ; A430 85 0D                    ..
        jsr     LA000                           ; A432 20 00 A0                  ..
        lda     #$44                            ; A435 A9 44                    .D
        sta     $0588,x                         ; A437 9D 88 05                 ...
        lda     #$A4                            ; A43A A9 A4                    ..
        sta     $05A0,x                         ; A43C 9D A0 05                 ...
        lda     #$20                            ; A43F A9 20                    . 
        sta     $0468,x                         ; A441 9D 68 04                 .h.
        jsr     entity_set_facing                           ; A444 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A447 20 30 EC                  0.
        dec     $0468,x                         ; A44A DE 68 04                 .h.
        bne     LA46D                           ; A44D D0 1E                    ..
        lda     $E5                             ; A44F A5 E5                    ..
        adc     $E6                             ; A451 65 E6                    e.
        sta     $E5                             ; A453 85 E5                    ..
        and     #$01                            ; A455 29 01                    ).
        beq     LA46E                           ; A457 F0 15                    ..
        lda     #$03                            ; A459 A9 03                    ..
        sta     $0480,x                         ; A45B 9D 80 04                 ...
        lda     #$49                            ; A45E A9 49                    .I
        jsr     entity_set_subtype                           ; A460 20 98 EA                  ..
        lda     #$ED                            ; A463 A9 ED                    ..
        sta     $0588,x                         ; A465 9D 88 05                 ...
        lda     #$A4                            ; A468 A9 A4                    ..
        sta     $05A0,x                         ; A46A 9D A0 05                 ...
LA46D:  rts                                     ; A46D 60                       `

; ----------------------------------------------------------------------------
LA46E:  inc     $0480,x                         ; A46E FE 80 04                 ...
        lda     #$80                            ; A471 A9 80                    ..
        sta     $0588,x                         ; A473 9D 88 05                 ...
        lda     #$A4                            ; A476 A9 A4                    ..
        sta     $05A0,x                         ; A478 9D A0 05                 ...
        lda     #$14                            ; A47B A9 14                    ..
        sta     $04C8,x                         ; A47D 9D C8 04                 ...
        dec     $04C8,x                         ; A480 DE C8 04                 ...
        bne     LA46D                           ; A483 D0 E8                    ..
        jsr     entity_set_facing                           ; A485 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A488 20 30 EC                  0.
        ldy     #$01                            ; A48B A0 01                    ..
        jsr     L854D                           ; A48D 20 4D 85                  M.
        lda     #$9F                            ; A490 A9 9F                    ..
        sta     $0588,x                         ; A492 9D 88 05                 ...
        lda     #$A4                            ; A495 A9 A4                    ..
        sta     $05A0,x                         ; A497 9D A0 05                 ...
        lda     #$48                            ; A49A A9 48                    .H
        jsr     entity_set_subtype                           ; A49C 20 98 EA                  ..
        lda     $0540,x                         ; A49F BD 40 05                 .@.
        beq     LA4EC                           ; A4A2 F0 48                    .H
        cmp     #$02                            ; A4A4 C9 02                    ..
        beq     LA4BE                           ; A4A6 F0 16                    ..
        lda     #$00                            ; A4A8 A9 00                    ..
        sta     $0570,x                         ; A4AA 9D 70 05                 .p.
        ldy     #$1C                            ; A4AD A0 1C                    ..
        jsr     entity_gravity_collide                           ; A4AF 20 B7 E7                  ..
        bcs     LA4B9                           ; A4B2 B0 05                    ..
        ldy     #$1E                            ; A4B4 A0 1E                    ..
        jmp     entity_horiz_dispatch                           ; A4B6 4C 3F EA                 L?.

; ----------------------------------------------------------------------------
LA4B9:  lda     #$02                            ; A4B9 A9 02                    ..
        sta     $0540,x                         ; A4BB 9D 40 05                 .@.
LA4BE:  lda     $0570,x                         ; A4BE BD 70 05                 .p.
        cmp     #$08                            ; A4C1 C9 08                    ..
        bne     LA4EC                           ; A4C3 D0 27                    .'
        lda     #$47                            ; A4C5 A9 47                    .G
        jsr     entity_set_subtype                           ; A4C7 20 98 EA                  ..
        lda     #$D7                            ; A4CA A9 D7                    ..
        sta     $0588,x                         ; A4CC 9D 88 05                 ...
        lda     #$A4                            ; A4CF A9 A4                    ..
        sta     $05A0,x                         ; A4D1 9D A0 05                 ...
        inc     $0480,x                         ; A4D4 FE 80 04                 ...
        ldy     #$17                            ; A4D7 A0 17                    ..
LA4D9:  lda     $0300,y                         ; A4D9 B9 00 03                 ...
        cmp     #$99                            ; A4DC C9 99                    ..
        bne     LA4E5                           ; A4DE D0 05                    ..
        lda     $0498,y                         ; A4E0 B9 98 04                 ...
        beq     LA4EC                           ; A4E3 F0 07                    ..
LA4E5:  dey                                     ; A4E5 88                       .
        cpy     #$07                            ; A4E6 C0 07                    ..
        bcs     LA4D9                           ; A4E8 B0 EF                    ..
        bcc     LA52B                           ; A4EA 90 3F                    .?
LA4EC:  rts                                     ; A4EC 60                       `

; ----------------------------------------------------------------------------
        lda     $0540,x                         ; A4ED BD 40 05                 .@.
        cmp     #$07                            ; A4F0 C9 07                    ..
        beq     LA52B                           ; A4F2 F0 37                    .7
        and     #$01                            ; A4F4 29 01                    ).
        beq     LA4EC                           ; A4F6 F0 F4                    ..
        lda     $0570,x                         ; A4F8 BD 70 05                 .p.
        cmp     #$08                            ; A4FB C9 08                    ..
        bne     LA4EC                           ; A4FD D0 ED                    ..
        jsr     find_free_slot_y                           ; A4FF 20 6F F1                  o.
        bcs     LA4EC                           ; A502 B0 E8                    ..
        lda     #$87                            ; A504 A9 87                    ..
        sta     $0408,y                         ; A506 99 08 04                 ...
        lda     #$9A                            ; A509 A9 9A                    ..
        sta     $0300,y                         ; A50B 99 00 03                 ...
        lda     $0420,x                         ; A50E BD 20 04                 . .
        sta     $0420,y                         ; A511 99 20 04                 . .
        and     #$01                            ; A514 29 01                    ).
        clc                                     ; A516 18                       .
        adc     #$51                            ; A517 69 51                    iQ
        sta     $10                             ; A519 85 10                    ..
        lda     #$4A                            ; A51B A9 4A                    .J
        jsr     entity_speed_preset                           ; A51D 20 F5 EA                  ..
        lda     #$00                            ; A520 A9 00                    ..
        sta     $03A8,y                         ; A522 99 A8 03                 ...
        lda     #$04                            ; A525 A9 04                    ..
        sta     $03C0,y                         ; A527 99 C0 03                 ...
        rts                                     ; A52A 60                       `

; ----------------------------------------------------------------------------
LA52B:  lda     #$00                            ; A52B A9 00                    ..
        sta     $0480,x                         ; A52D 9D 80 04                 ...
        lda     #$44                            ; A530 A9 44                    .D
        sta     $0588,x                         ; A532 9D 88 05                 ...
        lda     #$A4                            ; A535 A9 A4                    ..
        sta     $05A0,x                         ; A537 9D A0 05                 ...
        lda     #$20                            ; A53A A9 20                    . 
        sta     $0468,x                         ; A53C 9D 68 04                 .h.
        lda     #$47                            ; A53F A9 47                    .G
        jsr     entity_set_subtype                           ; A541 20 98 EA                  ..
        rts                                     ; A544 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $99 — Dark Man 4's shield segment: driven by the
; boss's $0480 phase — 0: re-form at his side ($A62C, tracks his X
; for facing), 1: fly out horizontally to the screen edge ($10/$F0)
; and hover ($A574), 2: boomerang back, arming itself ($0498 = $FF)
; within $20 px of the boss ($A5CC); dies if the boss is gone.
; =============================================================================
        jsr     L8541                           ; A545 20 41 85                  A.
        ldy     $0480,x                         ; A548 BC 80 04                 ...
        lda     $0300,y                         ; A54B B9 00 03                 ...
        cmp     #$98                            ; A54E C9 98                    ..
        beq     LA555                           ; A550 F0 03                    ..
        jmp     entity_wipe_x                           ; A552 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LA555:  lda     $0480,y                         ; A555 B9 80 04                 ...
        beq     LA573                           ; A558 F0 19                    ..
        cmp     #$01                            ; A55A C9 01                    ..
        beq     LA574                           ; A55C F0 16                    ..
        inc     $03C0,x                         ; A55E FE C0 03                 ...
        lda     #$0A                            ; A561 A9 0A                    ..
        sta     $0588,x                         ; A563 9D 88 05                 ...
        lda     #$A6                            ; A566 A9 A6                    ..
        sta     $05A0,x                         ; A568 9D A0 05                 ...
        lda     #$10                            ; A56B A9 10                    ..
        sta     $0468,x                         ; A56D 9D 68 04                 .h.
        jsr     LA60A                           ; A570 20 0A A6                  ..
LA573:  rts                                     ; A573 60                       `

; ----------------------------------------------------------------------------
LA574:  lda     #$04                            ; A574 A9 04                    ..
        sta     $03C0,x                         ; A576 9D C0 03                 ...
        lda     #$83                            ; A579 A9 83                    ..
        sta     $0588,x                         ; A57B 9D 88 05                 ...
        lda     #$A5                            ; A57E A9 A5                    ..
        sta     $05A0,x                         ; A580 9D A0 05                 ...
        jsr     entity_facing_dispatch                           ; A583 20 65 EA                  e.
        lda     $0348,x                         ; A586 BD 48 03                 .H.
        cmp     $0348                           ; A589 CD 48 03                 .H.
        beq     LA573                           ; A58C F0 E5                    ..
        lda     $0420,x                         ; A58E BD 20 04                 . .
        and     #$01                            ; A591 29 01                    ).
        beq     LA59E                           ; A593 F0 09                    ..
        lda     #$10                            ; A595 A9 10                    ..
        cmp     $0330,x                         ; A597 DD 30 03                 .0.
        bcs     LA609                           ; A59A B0 6D                    .m
        bcc     LA5A5                           ; A59C 90 07                    ..
LA59E:  lda     #$F0                            ; A59E A9 F0                    ..
        cmp     $0330,x                         ; A5A0 DD 30 03                 .0.
        bcc     LA609                           ; A5A3 90 64                    .d
LA5A5:  sta     $0330,x                         ; A5A5 9D 30 03                 .0.
        jsr     L852F                           ; A5A8 20 2F 85                  /.
        lda     #$00                            ; A5AB A9 00                    ..
        sta     $03A8,x                         ; A5AD 9D A8 03                 ...
        lda     #$04                            ; A5B0 A9 04                    ..
        sta     $03C0,x                         ; A5B2 9D C0 03                 ...
        lda     #$BF                            ; A5B5 A9 BF                    ..
        sta     $0588,x                         ; A5B7 9D 88 05                 ...
        lda     #$A5                            ; A5BA A9 A5                    ..
        sta     $05A0,x                         ; A5BC 9D A0 05                 ...
        ldy     $0480,x                         ; A5BF BC 80 04                 ...
        lda     $0300,y                         ; A5C2 B9 00 03                 ...
        cmp     #$98                            ; A5C5 C9 98                    ..
        beq     LA5CC                           ; A5C7 F0 03                    ..
        jmp     entity_wipe_x                           ; A5C9 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LA5CC:  lda     $0480,y                         ; A5CC B9 80 04                 ...
        beq     LA62C                           ; A5CF F0 5B                    .[
        cmp     #$02                            ; A5D1 C9 02                    ..
        bne     LA609                           ; A5D3 D0 34                    .4
        lda     $0498,x                         ; A5D5 BD 98 04                 ...
        bne     LA609                           ; A5D8 D0 2F                    ./
        jsr     entity_facing_dispatch                           ; A5DA 20 65 EA                  e.
        ldy     $0480,x                         ; A5DD BC 80 04                 ...
        lda     $0300,y                         ; A5E0 B9 00 03                 ...
        cmp     #$98                            ; A5E3 C9 98                    ..
        beq     LA5EA                           ; A5E5 F0 03                    ..
        jmp     entity_wipe_x                           ; A5E7 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LA5EA:  lda     $0330,y                         ; A5EA B9 30 03                 .0.
        sec                                     ; A5ED 38                       8
        sbc     $0330,x                         ; A5EE FD 30 03                 .0.
        pha                                     ; A5F1 48                       H
        lda     $0348,y                         ; A5F2 B9 48 03                 .H.
        sbc     $0348,x                         ; A5F5 FD 48 03                 .H.
        pla                                     ; A5F8 68                       h
        bcs     LA600                           ; A5F9 B0 05                    ..
        eor     #$FF                            ; A5FB 49 FF                    I.
        clc                                     ; A5FD 18                       .
        adc     #$01                            ; A5FE 69 01                    i.
LA600:  cmp     #$20                            ; A600 C9 20                    . 
        bcs     LA609                           ; A602 B0 05                    ..
        lda     #$FF                            ; A604 A9 FF                    ..
        sta     $0498,x                         ; A606 9D 98 04                 ...
LA609:  rts                                     ; A609 60                       `

; ----------------------------------------------------------------------------
LA60A:  ldy     $0480,x                         ; A60A BC 80 04                 ...
        lda     $0300,y                         ; A60D B9 00 03                 ...
        cmp     #$98                            ; A610 C9 98                    ..
        beq     LA617                           ; A612 F0 03                    ..
        jmp     entity_wipe_x                           ; A614 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LA617:  lda     $0480,y                         ; A617 B9 80 04                 ...
        beq     LA62C                           ; A61A F0 10                    ..
        jsr     L8541                           ; A61C 20 41 85                  A.
        dec     $0468,x                         ; A61F DE 68 04                 .h.
        bne     LA609                           ; A622 D0 E5                    ..
        lda     #$20                            ; A624 A9 20                    . 
        sta     $0468,x                         ; A626 9D 68 04                 .h.
        jmp     L852F                           ; A629 4C 2F 85                 L/.

; ----------------------------------------------------------------------------
LA62C:  lda     #$01                            ; A62C A9 01                    ..
        sta     $03C0,x                         ; A62E 9D C0 03                 ...
        lda     #$45                            ; A631 A9 45                    .E
        sta     $0588,x                         ; A633 9D 88 05                 ...
        lda     #$A5                            ; A636 A9 A5                    ..
        sta     $05A0,x                         ; A638 9D A0 05                 ...
        lda     #$00                            ; A63B A9 00                    ..
        sta     $0498,x                         ; A63D 9D 98 04                 ...
        ldy     $0480,x                         ; A640 BC 80 04                 ...
        lda     $0300,y                         ; A643 B9 00 03                 ...
        cmp     #$98                            ; A646 C9 98                    ..
        beq     LA64D                           ; A648 F0 03                    ..
        jmp     entity_wipe_x                           ; A64A 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LA64D:  lda     $0330                           ; A64D AD 30 03                 .0.
        pha                                     ; A650 48                       H
        lda     $0330,y                         ; A651 B9 30 03                 .0.
        sta     $0330                           ; A654 8D 30 03                 .0.
        jsr     entity_set_facing                           ; A657 20 16 EC                  ..
        pla                                     ; A65A 68                       h
        sta     $0330                           ; A65B 8D 30 03                 .0.
        rts                                     ; A65E 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $9A — Dark Man 4's ring shot: straight flight.
; =============================================================================
        jmp     entity_facing_dispatch                           ; A65F 4C 65 EA                 Le.

; ----------------------------------------------------------------------------
; --- LA662: paralysis flash — sprite palette rows $0612-$0617 := $20
; (white), palette dirty; returns Y=$FF for the caller to drop into
; hit_freeze ($54).
LA662:  lda     #$20                            ; A662 A9 20                    . 
        ldy     #$01                            ; A664 A0 01                    ..
LA666:  sta     $0612,y                         ; A666 99 12 06                 ...
        sta     $0616,y                         ; A669 99 16 06                 ...
        dey                                     ; A66C 88                       .
        bpl     LA666                           ; A66D 10 F7                    ..
        sty     $18                             ; A66F 84 18                    ..
        rts                                     ; A671 60                       `

; ----------------------------------------------------------------------------
; $A672-$A7FF: data, TBD (unreferenced in-bank)
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A672
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A67A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7D ; A682
        .byte   $FF,$FF,$FF,$F7,$FF,$DF,$FF,$FF ; A68A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A692
        .byte   $FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF ; A69A
        .byte   $FF,$FF,$FF,$DF,$FF,$FD,$FF,$FF ; A6A2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6AA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6B2
        .byte   $FF,$FF,$FF,$F7,$FF,$FF,$FF,$DF ; A6BA
        .byte   $FF,$FD,$FF,$FF,$FF,$7F,$FF,$FF ; A6C2
        .byte   $FF,$FF,$FF,$FD,$FF,$FF,$FF,$FF ; A6CA
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$FF ; A6D2
        .byte   $FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF ; A6DA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6E2
        .byte   $FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF ; A6EA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A6F2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$BF ; A6FA
        .byte   $FF,$FF,$FF,$DF,$FF,$FF,$FF,$FF ; A702
        .byte   $FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF ; A70A
        .byte   $FF,$DD,$FF,$FF,$FF,$FF,$FF,$FD ; A712
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A71A
        .byte   $FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF ; A722
        .byte   $FF,$FF,$FF,$FF,$FF,$DF,$FF,$FF ; A72A
        .byte   $FF,$FD,$FF,$DF,$FF,$FF,$FF,$FF ; A732
        .byte   $FF,$FF,$FF,$DF,$FF,$FF,$FF,$FF ; A73A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A742
        .byte   $FF,$DF,$FF,$DF,$FF,$FF,$FF,$F5 ; A74A
        .byte   $FF,$FF,$FF,$7F,$FF,$FF,$FF,$DF ; A752
        .byte   $FF,$FD,$FF,$FF,$FF,$FF,$FF,$FF ; A75A
        .byte   $FF,$FF,$FF,$FF,$DF,$FF,$FF,$FF ; A762
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A76A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A772
        .byte   $FF,$7F,$FF,$FF,$FF,$FF,$FF,$FF ; A77A
        .byte   $FD,$FF,$FF,$F7,$FF,$FF,$FF,$7F ; A782
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A78A
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A792
        .byte   $FF,$F7,$FF,$FF,$FF,$FF,$FF,$DF ; A79A
        .byte   $FF,$FF,$F7,$FF,$FF,$FF,$FF,$7E ; A7A2
        .byte   $FF,$FF,$FF,$FF,$FF,$DF,$FF,$FF ; A7AA
        .byte   $FF,$FF,$FF,$FF,$FF,$DF,$FF,$FF ; A7B2
        .byte   $FF,$FF,$FF,$FF,$FF,$FD,$FF,$FF ; A7BA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7C2
        .byte   $FF,$FF,$FF,$FD,$FF,$FF,$FF,$F7 ; A7CA
        .byte   $FF,$FF,$FF,$7F,$FF,$DF,$FF,$FF ; A7D2
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A7DA
        .byte   $FF,$F7,$FF,$FF,$FF,$F5,$FF,$FF ; A7E2
        .byte   $FF,$FB,$FF,$FF,$FF,$FD,$FF,$FF ; A7EA
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F ; A7F2
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
        brk                                     ; A81A 00                       .
        ora     ($01,x)                         ; A81B 01 01                    ..
        ora     (L0000,x)                       ; A81D 01 00                    ..
        brk                                     ; A81F 00                       .
        .byte   $03                             ; A820 03                       .
        ora     (L0000,x)                       ; A821 01 00                    ..
        brk                                     ; A823 00                       .
        brk                                     ; A824 00                       .
        ora     ($80,x)                         ; A825 01 80                    ..
        brk                                     ; A827 00                       .
        ora     ($01,x)                         ; A828 01 01                    ..
        ora     ($01,x)                         ; A82A 01 01                    ..
        .byte   $80                             ; A82C 80                       .
        .byte   $80                             ; A82D 80                       .
        brk                                     ; A82E 00                       .
        brk                                     ; A82F 00                       .
        brk                                     ; A830 00                       .
        ora     ($01,x)                         ; A831 01 01                    ..
        ora     ($01,x)                         ; A833 01 01                    ..
        brk                                     ; A835 00                       .
        ora     ($80,x)                         ; A836 01 80                    ..
        brk                                     ; A838 00                       .
        ora     ($01,x)                         ; A839 01 01                    ..
        ora     ($80,x)                         ; A83B 01 80                    ..
        brk                                     ; A83D 00                       .
        .byte   $02                             ; A83E 02                       .
        .byte   $80                             ; A83F 80                       .
        .byte   $03                             ; A840 03                       .
        brk                                     ; A841 00                       .
        brk                                     ; A842 00                       .
        brk                                     ; A843 00                       .
        brk                                     ; A844 00                       .
        brk                                     ; A845 00                       .
        brk                                     ; A846 00                       .
        .byte   $80                             ; A847 80                       .
        brk                                     ; A848 00                       .
        brk                                     ; A849 00                       .
        brk                                     ; A84A 00                       .
        brk                                     ; A84B 00                       .
        brk                                     ; A84C 00                       .
        brk                                     ; A84D 00                       .
        brk                                     ; A84E 00                       .
        ora     ($01,x)                         ; A84F 01 01                    ..
        .byte   $80                             ; A851 80                       .
        ora     ($01,x)                         ; A852 01 01                    ..
        ora     ($80,x)                         ; A854 01 80                    ..
        ora     (L0000,x)                       ; A856 01 00                    ..
        .byte   $80                             ; A858 80                       .
        ora     ($01,x)                         ; A859 01 01                    ..
        brk                                     ; A85B 00                       .
        ora     ($02,x)                         ; A85C 01 02                    ..
        brk                                     ; A85E 00                       .
        brk                                     ; A85F 00                       .
        ora     ($80,x)                         ; A860 01 80                    ..
        ora     ($01,x)                         ; A862 01 01                    ..
        ora     ($01,x)                         ; A864 01 01                    ..
        .byte   $02                             ; A866 02                       .
        ora     ($01,x)                         ; A867 01 01                    ..
        ora     ($80,x)                         ; A869 01 80                    ..
        ora     ($80,x)                         ; A86B 01 80                    ..
        brk                                     ; A86D 00                       .
        ora     ($80,x)                         ; A86E 01 80                    ..
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
        .byte   $80                             ; A87E 80                       .
        .byte   $80                             ; A87F 80                       .
        .byte   $80                             ; A880 80                       .
        .byte   $04                             ; A881 04                       .
        .byte   $80                             ; A882 80                       .
        ora     ($80,x)                         ; A883 01 80                    ..
        .byte   $80                             ; A885 80                       .
        ora     ($80,x)                         ; A886 01 80                    ..
        brk                                     ; A888 00                       .
        ora     ($80,x)                         ; A889 01 80                    ..
        .byte   $80                             ; A88B 80                       .
        brk                                     ; A88C 00                       .
        ora     (L0000,x)                       ; A88D 01 00                    ..
        .byte   $80                             ; A88F 80                       .
        .byte   $80                             ; A890 80                       .
        ora     (L0000,x)                       ; A891 01 00                    ..
        ora     ($80,x)                         ; A893 01 80                    ..
        .byte   $80                             ; A895 80                       .
        ora     ($80,x)                         ; A896 01 80                    ..
        .byte   $02                             ; A898 02                       .
        brk                                     ; A899 00                       .
        .byte   $80                             ; A89A 80                       .
        .byte   $80                             ; A89B 80                       .
        .byte   $02                             ; A89C 02                       .
        .byte   $80                             ; A89D 80                       .
        ora     ($80,x)                         ; A89E 01 80                    ..
        .byte   $04                             ; A8A0 04                       .
        brk                                     ; A8A1 00                       .
        brk                                     ; A8A2 00                       .
        brk                                     ; A8A3 00                       .
        brk                                     ; A8A4 00                       .
        ora     (L0000,x)                       ; A8A5 01 00                    ..
        .byte   $80                             ; A8A7 80                       .
        .byte   $80                             ; A8A8 80                       .
        brk                                     ; A8A9 00                       .
        ora     ($80,x)                         ; A8AA 01 80                    ..
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
        .byte   $17                             ; A917 17                       .
        brk                                     ; A918 00                       .
        brk                                     ; A919 00                       .
        brk                                     ; A91A 00                       .
        brk                                     ; A91B 00                       .
        brk                                     ; A91C 00                       .
        .byte   $80                             ; A91D 80                       .
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
        .byte   $20,$80,$A3                     ; A950 20 80 A3                  ..
        rti                                     ; A953 40                       @

; ----------------------------------------------------------------------------
        .byte   $62                             ; A954 62                       b
        .byte   $80                             ; A955 80                       .
        ldx     #$40                            ; A956 A2 40                    .@
        .byte   $62                             ; A958 62                       b
        .byte   $80                             ; A959 80                       .
        ldx     #$20                            ; A95A A2 20                    . 
        jsr     L0000                           ; A95C 20 00 00                  ..
        brk                                     ; A95F 00                       .
        brk                                     ; A960 00                       .
        brk                                     ; A961 00                       .
        .byte   $02                             ; A962 02                       .
        brk                                     ; A963 00                       .
        brk                                     ; A964 00                       .
        brk                                     ; A965 00                       .
LA966:  brk                                     ; A966 00                       .
        brk                                     ; A967 00                       .
        .byte   $1C                             ; A968 1C                       .
        .byte   $02                             ; A969 02                       .
        .byte   $23                             ; A96A 23                       #
        ora     $2A03,y                         ; A96B 19 03 2A                 ..*
        .byte   $1C                             ; A96E 1C                       .
        brk                                     ; A96F 00                       .
        .byte   $2B                             ; A970 2B                       +
        .byte   $1C                             ; A971 1C                       .
        bit     $80                             ; A972 24 80                    $.
        .byte   $BB                             ; A974 BB                       .
        brk                                     ; A975 00                       .
        brk                                     ; A976 00                       .
        .byte   $02                             ; A977 02                       .
        brk                                     ; A978 00                       .
        brk                                     ; A979 00                       .
        brk                                     ; A97A 00                       .
        brk                                     ; A97B 00                       .
        brk                                     ; A97C 00                       .
        brk                                     ; A97D 00                       .
        brk                                     ; A97E 00                       .
        brk                                     ; A97F 00                       .
        ldy     $A6                             ; A980 A4 A6                    ..
        brk                                     ; A982 00                       .
        brk                                     ; A983 00                       .
        brk                                     ; A984 00                       .
        brk                                     ; A985 00                       .
        brk                                     ; A986 00                       .
        brk                                     ; A987 00                       .
        .byte   $0F                             ; A988 0F                       .
        bmi     LA99B                           ; A989 30 10                    0.
        clc                                     ; A98B 18                       .
        .byte   $0F                             ; A98C 0F                       .
        bmi     LA9B2                           ; A98D 30 23                    0#
        .byte   $0C                             ; A98F 0C                       .
        .byte   $0F                             ; A990 0F                       .
        .byte   $37                             ; A991 37                       7
        clc                                     ; A992 18                       .
        php                                     ; A993 08                       .
        .byte   $0F                             ; A994 0F                       .
        bmi     LA997                           ; A995 30 00                    0.
LA997:  .byte   $0B                             ; A997 0B                       .
        brk                                     ; A998 00                       .
        brk                                     ; A999 00                       .
        .byte   $93                             ; A99A 93                       .
LA99B:  brk                                     ; A99B 00                       .
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
LA9B2:  brk                                     ; A9B2 00                       .
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
        brk                                     ; A9BF 00                       .
        brk                                     ; A9C0 00                       .
        brk                                     ; A9C1 00                       .
        brk                                     ; A9C2 00                       .
        brk                                     ; A9C3 00                       .
        brk                                     ; A9C4 00                       .
        bpl     LA9C7                           ; A9C5 10 00                    ..
LA9C7:  brk                                     ; A9C7 00                       .
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
        bpl     LA9E7                           ; A9E5 10 00                    ..
LA9E7:  brk                                     ; A9E7 00                       .
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
        brk                                     ; AA00 00                       .
        brk                                     ; AA01 00                       .
        ora     ($01,x)                         ; AA02 01 01                    ..
        ora     ($02,x)                         ; AA04 01 02                    ..
        .byte   $02                             ; AA06 02                       .
        .byte   $03                             ; AA07 03                       .
        .byte   $03                             ; AA08 03                       .
        .byte   $03                             ; AA09 03                       .
        .byte   $04                             ; AA0A 04                       .
        .byte   $04                             ; AA0B 04                       .
        .byte   $04                             ; AA0C 04                       .
LAA0D:  .byte   $04                             ; AA0D 04                       .
        .byte   $04                             ; AA0E 04                       .
        ora     $05                             ; AA0F 05 05                    ..
        ora     $06                             ; AA11 05 06                    ..
        asl     $06                             ; AA13 06 06                    ..
        php                                     ; AA15 08                       .
        php                                     ; AA16 08                       .
        php                                     ; AA17 08                       .
        ora     #$09                            ; AA18 09 09                    ..
        ora     #$0A                            ; AA1A 09 0A                    ..
        asl     a                               ; AA1C 0A                       .
        asl     a                               ; AA1D 0A                       .
        asl     a                               ; AA1E 0A                       .
        .byte   $0B                             ; AA1F 0B                       .
        .byte   $0B                             ; AA20 0B                       .
        .byte   $0B                             ; AA21 0B                       .
        .byte   $0B                             ; AA22 0B                       .
        .byte   $0C                             ; AA23 0C                       .
        .byte   $0C                             ; AA24 0C                       .
LAA25:  .byte   $0C                             ; AA25 0C                       .
        ora     $0D0D                           ; AA26 0D 0D 0D                 ...
        asl     $1010                           ; AA29 0E 10 10                 ...
        ora     ($11),y                         ; AA2C 11 11                    ..
        .byte   $12                             ; AA2E 12                       .
        .byte   $12                             ; AA2F 12                       .
        .byte   $12                             ; AA30 12                       .
        .byte   $13                             ; AA31 13                       .
        .byte   $13                             ; AA32 13                       .
        .byte   $13                             ; AA33 13                       .
        .byte   $14                             ; AA34 14                       .
        .byte   $14                             ; AA35 14                       .
        .byte   $14                             ; AA36 14                       .
LAA37:  .byte   $14                             ; AA37 14                       .
        ora     $15,x                           ; AA38 15 15                    ..
        .byte   $15                             ; AA3A 15                       .
LAA3B:  ora     $17,x                           ; AA3B 15 17                    ..
        .byte   $FF                             ; AA3D FF                       .
        brk                                     ; AA3E 00                       .
        brk                                     ; AA3F 00                       .
        brk                                     ; AA40 00                       .
        brk                                     ; AA41 00                       .
        brk                                     ; AA42 00                       .
LAA43:  brk                                     ; AA43 00                       .
        brk                                     ; AA44 00                       .
        brk                                     ; AA45 00                       .
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
        .byte   $20                             ; AA58 20                        
        brk                                     ; AA59 00                       .
LAA5A:  brk                                     ; AA5A 00                       .
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
        brk                                     ; AA7C 00                       .
        brk                                     ; AA7D 00                       .
        brk                                     ; AA7E 00                       .
        brk                                     ; AA7F 00                       .
        pla                                     ; AA80 68                       h
        tya                                     ; AA81 98                       .
        pha                                     ; AA82 48                       H
        tya                                     ; AA83 98                       .
        clv                                     ; AA84 B8                       .
        cpx     #$E8                            ; AA85 E0 E8                    ..
        bmi     LAAE9                           ; AA87 30 60                    0`
        bcs     LAAAB                           ; AA89 B0 20                    . 
        bvc     LAA0D                           ; AA8B 50 80                    P.
        inx                                     ; AA8D E8                       .
        beq     LAAF0                           ; AA8E F0 60                    .`
        bcs     LAA43                           ; AA90 B0 B1                    ..
        brk                                     ; AA92 00                       .
        bvc     LAA25                           ; AA93 50 90                    P.
        plp                                     ; AA95 28                       (
        dey                                     ; AA96 88                       .
        bcc     LAAE1                           ; AA97 90 48                    .H
        tay                                     ; AA99 A8                       .
        cld                                     ; AA9A D8                       .
        brk                                     ; AA9B 00                       .
        jsr     LC030                           ; AA9C 20 30 C0                  0.
        brk                                     ; AA9F 00                       .
        bcc     LAA5A                           ; AAA0 90 B8                    ..
        bne     LAAC4                           ; AAA2 D0 20                    . 
        pha                                     ; AAA4 48                       H
        bcs     LAB1E                           ; AAA5 B0 77                    .w
        sei                                     ; AAA7 78                       x
LAAA8:  .byte   $80                             ; AAA8 80                       .
        bmi     LAA3B                           ; AAA9 30 90                    0.
LAAAB:  .byte   $D0                             ; AAAB D0                       .
LAAAC:  .byte   $10,$50                    ; AAAC 10 50   (branch out of range for ca65: target has no local label)
        .byte   $70                             ; AAAE 70                       p
LAAAF:  dey                                     ; AAAF 88                       .
        bcs     LAAF2                           ; AAB0 B0 40                    .@
        dey                                     ; AAB2 88                       .
        bne     LAAC5                           ; AAB3 D0 10                    ..
        bmi     LAA37                           ; AAB5 30 80                    0.
        cpy     #$20                            ; AAB7 C0 20                    . 
        rti                                     ; AAB9 40                       @

; ----------------------------------------------------------------------------
        ldy     #$D0                            ; AABA A0 D0                    ..
        cld                                     ; AABC D8                       .
LAABD:  .byte   $FF                             ; AABD FF                       .
        brk                                     ; AABE 00                       .
        brk                                     ; AABF 00                       .
        brk                                     ; AAC0 00                       .
        brk                                     ; AAC1 00                       .
        brk                                     ; AAC2 00                       .
        brk                                     ; AAC3 00                       .
LAAC4:  brk                                     ; AAC4 00                       .
LAAC5:  brk                                     ; AAC5 00                       .
        brk                                     ; AAC6 00                       .
        brk                                     ; AAC7 00                       .
        brk                                     ; AAC8 00                       .
        brk                                     ; AAC9 00                       .
        brk                                     ; AACA 00                       .
        brk                                     ; AACB 00                       .
        brk                                     ; AACC 00                       .
        .byte   $04                             ; AACD 04                       .
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
LAAE1:  brk                                     ; AAE1 00                       .
        brk                                     ; AAE2 00                       .
        brk                                     ; AAE3 00                       .
        .byte   $02                             ; AAE4 02                       .
        brk                                     ; AAE5 00                       .
        brk                                     ; AAE6 00                       .
        brk                                     ; AAE7 00                       .
        brk                                     ; AAE8 00                       .
LAAE9:  brk                                     ; AAE9 00                       .
        .byte   $80                             ; AAEA 80                       .
        brk                                     ; AAEB 00                       .
        brk                                     ; AAEC 00                       .
        brk                                     ; AAED 00                       .
        brk                                     ; AAEE 00                       .
LAAEF:  brk                                     ; AAEF 00                       .
LAAF0:  brk                                     ; AAF0 00                       .
        brk                                     ; AAF1 00                       .
LAAF2:  brk                                     ; AAF2 00                       .
        brk                                     ; AAF3 00                       .
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
        lsr     $56,x                           ; AB00 56 56                    VV
        bcs     LAB6C                           ; AB02 B0 68                    .h
        bcs     LAB46                           ; AB04 B0 40                    .@
        bcs     LAB58                           ; AB06 B0 50                    .P
        bcc     LAB6A                           ; AB08 90 60                    .`
        bvs     LAAAC                           ; AB0A 70 A0                    p.
        .byte   $80                             ; AB0C 80                       .
        bvs     LAAAF                           ; AB0D 70 A0                    p.
        ldy     #$80                            ; AB0F A0 80                    ..
        bcs     LAB13                           ; AB11 B0 00                    ..
LAB13:  stx     $66,y                           ; AB13 96 66                    .f
        rts                                     ; AB15 60                       `

; ----------------------------------------------------------------------------
LAB16:  bvs     LAB50                           ; AB16 70 38                    p8
        jsr     L6040                           ; AB18 20 40 60                  @`
        brk                                     ; AB1B 00                       .
        bmi     LAACF                           ; AB1C 30 B1                    0.
LAB1E:  .byte   $71                             ; AB1E 71                       q
LAB1F:  brk                                     ; AB1F 00                       .
        pla                                     ; AB20 68                       h
        sec                                     ; AB21 38                       8
        sty     $70,x                           ; AB22 94 70                    .p
        sta     $45                             ; AB24 85 45                    .E
        sei                                     ; AB26 78                       x
        tya                                     ; AB27 98                       .
        bmi     LABA2                           ; AB28 30 78                    0x
        bmi     LAB5C                           ; AB2A 30 30                    00
        bmi     LAB5E                           ; AB2C 30 30                    00
        .byte   $80                             ; AB2E 80                       .
        cpy     #$68                            ; AB2F C0 68                    .h
        sec                                     ; AB31 38                       8
        pha                                     ; AB32 48                       H
        .byte   $74                             ; AB33 74                       t
        bmi     LAB16                           ; AB34 30 E0                    0.
        .byte   $54                             ; AB36 54                       T
        rti                                     ; AB37 40                       @

; ----------------------------------------------------------------------------
        .byte   $44                             ; AB38 44                       D
        bcs     LAAEF                           ; AB39 B0 B4                    ..
        rti                                     ; AB3B 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AB3C 00                       .
        .byte   $FF                             ; AB3D FF                       .
        brk                                     ; AB3E 00                       .
        brk                                     ; AB3F 00                       .
        brk                                     ; AB40 00                       .
        brk                                     ; AB41 00                       .
        brk                                     ; AB42 00                       .
        brk                                     ; AB43 00                       .
        brk                                     ; AB44 00                       .
        brk                                     ; AB45 00                       .
LAB46:  brk                                     ; AB46 00                       .
        brk                                     ; AB47 00                       .
        brk                                     ; AB48 00                       .
        brk                                     ; AB49 00                       .
        brk                                     ; AB4A 00                       .
        brk                                     ; AB4B 00                       .
        brk                                     ; AB4C 00                       .
        brk                                     ; AB4D 00                       .
        brk                                     ; AB4E 00                       .
        brk                                     ; AB4F 00                       .
LAB50:  brk                                     ; AB50 00                       .
        brk                                     ; AB51 00                       .
        brk                                     ; AB52 00                       .
        brk                                     ; AB53 00                       .
        brk                                     ; AB54 00                       .
        brk                                     ; AB55 00                       .
        brk                                     ; AB56 00                       .
        brk                                     ; AB57 00                       .
LAB58:  brk                                     ; AB58 00                       .
        brk                                     ; AB59 00                       .
        brk                                     ; AB5A 00                       .
        brk                                     ; AB5B 00                       .
LAB5C:  brk                                     ; AB5C 00                       .
        brk                                     ; AB5D 00                       .
LAB5E:  brk                                     ; AB5E 00                       .
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
LAB6A:  brk                                     ; AB6A 00                       .
        brk                                     ; AB6B 00                       .
LAB6C:  brk                                     ; AB6C 00                       .
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
        brk                                     ; AB7E 00                       .
        brk                                     ; AB7F 00                       .
        .byte   $2F                             ; AB80 2F                       /
        rol     $8214                           ; AB81 2E 14 82                 ...
        .byte   $14                             ; AB84 14                       .
        rol     $36,x                           ; AB85 36 36                    66
        rol     $09,x                           ; AB87 36 09                    6.
        rol     $36,x                           ; AB89 36 36                    66
        ora     #$36                            ; AB8B 09 36                    .6
        rol     $09,x                           ; AB8D 36 09                    6.
        rol     $36,x                           ; AB8F 36 36                    66
        ora     #$C0                            ; AB91 09 C0                    ..
        rol     $022F                           ; AB93 2E 2F 02                 ./.
        .byte   $02                             ; AB96 02                       .
        .byte   $02                             ; AB97 02                       .
        .byte   $02                             ; AB98 02                       .
        .byte   $02                             ; AB99 02                       .
        .byte   $02                             ; AB9A 02                       .
        cpy     #$18                            ; AB9B C0 18                    ..
        clc                                     ; AB9D 18                       .
        clc                                     ; AB9E 18                       .
        .byte   $C2                             ; AB9F C2                       .
        .byte   $12                             ; ABA0 12                       .
        .byte   $86                             ; ABA1 86                       .
LABA2:  .byte   $33                             ; ABA2 33                       3
        .byte   $12                             ; ABA3 12                       .
        .byte   $33                             ; ABA4 33                       3
        .byte   $33                             ; ABA5 33                       3
        sty     $81                             ; ABA6 84 81                    ..
        .byte   $33                             ; ABA8 33                       3
LABA9:  .byte   $83                             ; ABA9 83                       .
        .byte   $2B                             ; ABAA 2B                       +
        .byte   $2B                             ; ABAB 2B                       +
        .byte   $2B                             ; ABAC 2B                       +
        .byte   $2B                             ; ABAD 2B                       +
        php                                     ; ABAE 08                       .
        php                                     ; ABAF 08                       .
        sty     $3F                             ; ABB0 84 3F                    .?
        .byte   $3F                             ; ABB2 3F                       ?
        .byte   $04                             ; ABB3 04                       .
        .byte   $3F                             ; ABB4 3F                       ?
        .byte   $3F                             ; ABB5 3F                       ?
        .byte   $04                             ; ABB6 04                       .
        .byte   $3F                             ; ABB7 3F                       ?
        .byte   $04                             ; ABB8 04                       .
        .byte   $3F                             ; ABB9 3F                       ?
        .byte   $04                             ; ABBA 04                       .
        .byte   $3F                             ; ABBB 3F                       ?
        ror     a                               ; ABBC 6A                       j
        .byte   $FF                             ; ABBD FF                       .
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
        .byte   $02                             ; AC01 02                       .
        ora     $07                             ; AC02 05 07                    ..
        asl     a                               ; AC04 0A                       .
        .byte   $0F                             ; AC05 0F                       .
        .byte   $12                             ; AC06 12                       .
        ora     $15,x                           ; AC07 15 15                    ..
        clc                                     ; AC09 18                       .
        .byte   $1B                             ; AC0A 1B                       .
        .byte   $1F                             ; AC0B 1F                       .
        .byte   $23                             ; AC0C 23                       #
        rol     $29                             ; AC0D 26 29                    &)
        rol     a                               ; AC0F 2A                       *
        rol     a                               ; AC10 2A                       *
        bit     $312E                           ; AC11 2C 2E 31                 ,.1
        .byte   $34                             ; AC14 34                       4
        sec                                     ; AC15 38                       8
        .byte   $3C                             ; AC16 3C                       <
        .byte   $3C                             ; AC17 3C                       <
        brk                                     ; AC18 00                       .
        brk                                     ; AC19 00                       .
        brk                                     ; AC1A 00                       .
        brk                                     ; AC1B 00                       .
        brk                                     ; AC1C 00                       .
        brk                                     ; AC1D 00                       .
        brk                                     ; AC1E 00                       .
        bpl     LAC21                           ; AC1F 10 00                    ..
LAC21:  rti                                     ; AC21 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AC22 00                       .
        brk                                     ; AC23 00                       .
        brk                                     ; AC24 00                       .
        bpl     LAC27                           ; AC25 10 00                    ..
LAC27:  brk                                     ; AC27 00                       .
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
        bpl     LAC34                           ; AC32 10 00                    ..
LAC34:  brk                                     ; AC34 00                       .
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
        asl     L0000                           ; AC48 06 00                    ..
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
        brk                                     ; AC8E 00                       .
        brk                                     ; AC8F 00                       .
        brk                                     ; AC90 00                       .
        brk                                     ; AC91 00                       .
        brk                                     ; AC92 00                       .
        brk                                     ; AC93 00                       .
        .byte   $02                             ; AC94 02                       .
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
        rts                                     ; ACA4 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; ACA5 00                       .
        jsr     L0000                           ; ACA6 20 00 00                  ..
        brk                                     ; ACA9 00                       .
        brk                                     ; ACAA 00                       .
        .byte   $04                             ; ACAB 04                       .
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
        rti                                     ; ACBA 40                       @

; ----------------------------------------------------------------------------
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
LACC6:  brk                                     ; ACC6 00                       .
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
        brk                                     ; ACEC 00                       .
        brk                                     ; ACED 00                       .
        brk                                     ; ACEE 00                       .
        brk                                     ; ACEF 00                       .
        .byte   $04                             ; ACF0 04                       .
        brk                                     ; ACF1 00                       .
        brk                                     ; ACF2 00                       .
        brk                                     ; ACF3 00                       .
        brk                                     ; ACF4 00                       .
        brk                                     ; ACF5 00                       .
        brk                                     ; ACF6 00                       .
        brk                                     ; ACF7 00                       .
        brk                                     ; ACF8 00                       .
        brk                                     ; ACF9 00                       .
        brk                                     ; ACFA 00                       .
        brk                                     ; ACFB 00                       .
        rti                                     ; ACFC 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACFD 00                       .
        brk                                     ; ACFE 00                       .
        .byte   $04                             ; ACFF 04                       .
        brk                                     ; AD00 00                       .
        ora     ($02,x)                         ; AD01 01 02                    ..
        .byte   $04                             ; AD03 04                       .
        asl     $08                             ; AD04 06 08                    ..
        asl     a                               ; AD06 0A                       .
        brk                                     ; AD07 00                       .
        .byte   $02                             ; AD08 02                       .
        .byte   $12                             ; AD09 12                       .
        brk                                     ; AD0A 00                       .
        .byte   $04                             ; AD0B 04                       .
        brk                                     ; AD0C 00                       .
        .byte   $0C                             ; AD0D 0C                       .
        asl     a:L0000                         ; AD0E 0E 00 00                 ...
        brk                                     ; AD11 00                       .
        .byte   $82                             ; AD12 82                       .
        brk                                     ; AD13 00                       .
        brk                                     ; AD14 00                       .
        brk                                     ; AD15 00                       .
        bne     LACC6                           ; AD16 D0 AE                    ..
        .byte   $CB                             ; AD18 CB                       .
        .byte   $CD,$A3,$A6                     ; AD19 CD A3 A6                 ...
        .byte   $80                             ; AD1C 80                       .
        .byte   $82                             ; AD1D 82                       .
        .byte   $83                             ; AD1E 83                       .
        stx     $80                             ; AD1F 86 80                    ..
        .byte   $82                             ; AD21 82                       .
        .byte   $82                             ; AD22 82                       .
        ora     ($80),y                         ; AD23 11 80                    ..
        .byte   $82                             ; AD25 82                       .
        .byte   $82                             ; AD26 82                       .
        .byte   $02                             ; AD27 02                       .
        ldy     #$11                            ; AD28 A0 11                    ..
        ora     ($82),y                         ; AD2A 11 82                    ..
        ldy     #$80                            ; AD2C A0 80                    ..
        .byte   $82                             ; AD2E 82                       .
        .byte   $80                             ; AD2F 80                       .
        cpy     #$C2                            ; AD30 C0 C2                    ..
        dec     $85                             ; AD32 C6 85                    ..
        cpy     #$C2                            ; AD34 C0 C2                    ..
        dec     $A5                             ; AD36 C6 A5                    ..
        .byte   $D7                             ; AD38 D7                       .
        .byte   $E2                             ; AD39 E2                       .
        inc     $A5                             ; AD3A E6 A5                    ..
        iny                                     ; AD3C C8                       .
        dex                                     ; AD3D CA                       .
        brk                                     ; AD3E 00                       .
        cpy     #$20                            ; AD3F C0 20                    . 
        brk                                     ; AD41 00                       .
        .byte   $22                             ; AD42 22                       "
        bit     $34                             ; AD43 24 34                    $4
        lsr     a                               ; AD45 4A                       J
        and     #$2B                            ; AD46 29 2B                    )+
        rti                                     ; AD48 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AD49 00                       .
        .byte   $42                             ; AD4A 42                       B
        eor     #$00                            ; AD4B 49 00                    I.
        brk                                     ; AD4D 00                       .
        brk                                     ; AD4E 00                       .
        pha                                     ; AD4F 48                       H
        .byte   $42                             ; AD50 42                       B
        .byte   $42                             ; AD51 42                       B
        .byte   $42                             ; AD52 42                       B
        brk                                     ; AD53 00                       .
        brk                                     ; AD54 00                       .
        brk                                     ; AD55 00                       .
        brk                                     ; AD56 00                       .
        pla                                     ; AD57 68                       h
        .byte   $42                             ; AD58 42                       B
        brk                                     ; AD59 00                       .
        rol     $42,x                           ; AD5A 36 42                    6B
        .byte   $27                             ; AD5C 27                       '
        .byte   $47                             ; AD5D 47                       G
        brk                                     ; AD5E 00                       .
        .byte   $5A                             ; AD5F 5A                       Z
        brk                                     ; AD60 00                       .
        brk                                     ; AD61 00                       .
        brk                                     ; AD62 00                       .
        brk                                     ; AD63 00                       .
        brk                                     ; AD64 00                       .
        ror     $01,x                           ; AD65 76 01                    v.
        brk                                     ; AD67 00                       .
        .byte   $54                             ; AD68 54                       T
        eor     L0000,x                         ; AD69 55 00                    U.
        brk                                     ; AD6B 00                       .
        brk                                     ; AD6C 00                       .
        ror     $C4,x                           ; AD6D 76 C4                    v.
        brk                                     ; AD6F 00                       .
        .byte   $74                             ; AD70 74                       t
        adc     L0000,x                         ; AD71 75 00                    u.
        brk                                     ; AD73 00                       .
        brk                                     ; AD74 00                       .
        brk                                     ; AD75 00                       .
        .byte   $63                             ; AD76 63                       c
        brk                                     ; AD77 00                       .
        brk                                     ; AD78 00                       .
        brk                                     ; AD79 00                       .
        brk                                     ; AD7A 00                       .
        brk                                     ; AD7B 00                       .
        brk                                     ; AD7C 00                       .
        brk                                     ; AD7D 00                       .
        .byte   $63                             ; AD7E 63                       c
        brk                                     ; AD7F 00                       .
        inx                                     ; AD80 E8                       .
        nop                                     ; AD81 EA                       .
        .byte   $EB                             ; AD82 EB                       .
        sbc     $82EE                           ; AD83 ED EE 82                 ...
        dey                                     ; AD86 88                       .
        txa                                     ; AD87 8A                       .
        sbc     #$EA                            ; AD88 E9 EA                    ..
        cpy     #$00                            ; AD8A C0 00                    ..
        brk                                     ; AD8C 00                       .
        tsx                                     ; AD8D BA                       .
        tya                                     ; AD8E 98                       .
        ldy     $8280                           ; AD8F AC 80 82                 ...
        dex                                     ; AD92 CA                       .
        brk                                     ; AD93 00                       .
        brk                                     ; AD94 00                       .
        .byte   $82                             ; AD95 82                       .
        tya                                     ; AD96 98                       .
        txs                                     ; AD97 9A                       .
        brk                                     ; AD98 00                       .
        brk                                     ; AD99 00                       .
        cpy     #$00                            ; AD9A C0 00                    ..
        brk                                     ; AD9C 00                       .
        ldx     $6C6A,y                         ; AD9D BE 6A 6C                 .jl
        lsr     $3D4E                           ; ADA0 4E 4E 3D                 NN=
        brk                                     ; ADA3 00                       .
        brk                                     ; ADA4 00                       .
        brk                                     ; ADA5 00                       .
        brk                                     ; ADA6 00                       .
        brk                                     ; ADA7 00                       .
        bit     $3E5E                           ; ADA8 2C 5E 3E                 ,^>
        rol     a:L0000,x                       ; ADAB 3E 00 00                 >..
        brk                                     ; ADAE 00                       .
        brk                                     ; ADAF 00                       .
        .byte   $5C                             ; ADB0 5C                       \
        lsr     a:L0000,x                       ; ADB1 5E 00 00                 ^..
        lsr     $8E8E,x                         ; ADB4 5E 8E 8E                 ^..
        brk                                     ; ADB7 00                       .
        .byte   $CF                             ; ADB8 CF                       .
        .byte   $5E,$00,$A2                     ; ADB9 5E 00 A2                 ^..
        lsr     $0101,x                         ; ADBC 5E 01 01                 ^..
        brk                                     ; ADBF 00                       .
        .byte   $5C                             ; ADC0 5C                       \
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
        ora     ($03,x)                         ; AE01 01 03                    ..
        ora     $07                             ; AE03 05 07                    ..
        ora     #$0B                            ; AE05 09 0B                    ..
        brk                                     ; AE07 00                       .
        .byte   $03                             ; AE08 03                       .
        .byte   $13                             ; AE09 13                       .
        brk                                     ; AE0A 00                       .
        ora     L0000                           ; AE0B 05 00                    ..
        ora     a:$0F                           ; AE0D 0D 0F 00                 ...
        brk                                     ; AE10 00                       .
        brk                                     ; AE11 00                       .
        sty     L0000                           ; AE12 84 00                    ..
        brk                                     ; AE14 00                       .
        brk                                     ; AE15 00                       .
        lda     $CCAF                           ; AE16 AD AF CC                 ...
        .byte   $CB                             ; AE19 CB                       .
        ldy     $A7                             ; AE1A A4 A7                    ..
        sta     ($87,x)                         ; AE1C 81 87                    ..
        stx     $83                             ; AE1E 86 83                    ..
        sta     ($81,x)                         ; AE20 81 81                    ..
        .byte   $87                             ; AE22 87                       .
        sta     $81                             ; AE23 85 81                    ..
        sta     ($87,x)                         ; AE25 81 87                    ..
        .byte   $03                             ; AE27 03                       .
        ora     ($11),y                         ; AE28 11 11                    ..
        .byte   $97                             ; AE2A 97                       .
        lda     $85                             ; AE2B A5 85                    ..
        lda     $87,x                           ; AE2D B5 87                    ..
        .byte   $87                             ; AE2F 87                       .
        cmp     ($C2,x)                         ; AE30 C1 C2                    ..
        .byte   $C7                             ; AE32 C7                       .
        sta     $C1                             ; AE33 85 C1                    ..
        .byte   $C2                             ; AE35 C2                       .
        .byte   $C7                             ; AE36 C7                       .
        lda     $E1                             ; AE37 A5 E1                    ..
        .byte   $E3                             ; AE39 E3                       .
        .byte   $E7                             ; AE3A E7                       .
        lda     $C9                             ; AE3B A5 C9                    ..
        dex                                     ; AE3D CA                       .
        brk                                     ; AE3E 00                       .
        .byte   $C7                             ; AE3F C7                       .
        and     (L0000,x)                       ; AE40 21 00                    !.
        .byte   $23                             ; AE42 23                       #
        bit     $34                             ; AE43 24 34                    $4
        plp                                     ; AE45 28                       (
        rol     a                               ; AE46 2A                       *
        .byte   $4B                             ; AE47 4B                       K
        eor     (L0000,x)                       ; AE48 41 00                    A.
        .byte   $43                             ; AE4A 43                       C
        eor     #$00                            ; AE4B 49 00                    I.
        brk                                     ; AE4D 00                       .
        brk                                     ; AE4E 00                       .
        and     ($43,x)                         ; AE4F 21 43                    !C
        .byte   $43                             ; AE51 43                       C
        .byte   $43                             ; AE52 43                       C
        brk                                     ; AE53 00                       .
        brk                                     ; AE54 00                       .
        brk                                     ; AE55 00                       .
        brk                                     ; AE56 00                       .
        eor     ($36,x)                         ; AE57 41 36                    A6
        brk                                     ; AE59 00                       .
        .byte   $43                             ; AE5A 43                       C
        lsr     $27                             ; AE5B 46 27                    F'
        .byte   $43                             ; AE5D 43                       C
        brk                                     ; AE5E 00                       .
        .byte   $5B                             ; AE5F 5B                       [
        brk                                     ; AE60 00                       .
        brk                                     ; AE61 00                       .
        and     $61                             ; AE62 25 61                    %a
        adc     ($01,x)                         ; AE64 61 01                    a.
        .byte   $77                             ; AE66 77                       w
        brk                                     ; AE67 00                       .
        eor     $55,x                           ; AE68 55 55                    UU
        and     $61,x                           ; AE6A 35 61                    5a
        adc     ($C3,x)                         ; AE6C 61 C3                    a.
        .byte   $77                             ; AE6E 77                       w
        brk                                     ; AE6F 00                       .
        adc     $75,x                           ; AE70 75 75                    uu
        brk                                     ; AE72 00                       .
        adc     (L0000,x)                       ; AE73 61 00                    a.
        .byte   $62                             ; AE75 62                       b
        brk                                     ; AE76 00                       .
        brk                                     ; AE77 00                       .
        brk                                     ; AE78 00                       .
        brk                                     ; AE79 00                       .
        brk                                     ; AE7A 00                       .
        brk                                     ; AE7B 00                       .
        brk                                     ; AE7C 00                       .
        .byte   $62                             ; AE7D 62                       b
        brk                                     ; AE7E 00                       .
        brk                                     ; AE7F 00                       .
        sbc     #$EA                            ; AE80 E9 EA                    ..
        cpx     $E8EA                           ; AE82 EC EA E8                 ...
        sta     ($89,x)                         ; AE85 81 89                    ..
        .byte   $8B                             ; AE87 8B                       .
        nop                                     ; AE88 EA                       .
        inc     a:$C5                           ; AE89 EE C5 00                 ...
        brk                                     ; AE8C 00                       .
        .byte   $BB                             ; AE8D BB                       .
        sta     $819B,y                         ; AE8E 99 9B 81                 ...
        .byte   $87                             ; AE91 87                       .
        sta     L0000,x                         ; AE92 95 00                    ..
        brk                                     ; AE94 00                       .
        sta     ($99,x)                         ; AE95 81 99                    ..
        .byte   $9B                             ; AE97 9B                       .
        brk                                     ; AE98 00                       .
        brk                                     ; AE99 00                       .
        lda     L0000,x                         ; AE9A B5 00                    ..
        brk                                     ; AE9C 00                       .
        .byte   $BF                             ; AE9D BF                       .
        .byte   $6B                             ; AE9E 6B                       k
        adc     $3C4F                           ; AE9F 6D 4F 3C                 mO<
        .byte   $3C                             ; AEA2 3C                       <
        brk                                     ; AEA3 00                       .
        brk                                     ; AEA4 00                       .
        brk                                     ; AEA5 00                       .
        brk                                     ; AEA6 00                       .
        brk                                     ; AEA7 00                       .
        and     $3E3E                           ; AEA8 2D 3E 3E                 ->>
        rol     a:L0000,x                       ; AEAB 3E 00 00                 >..
        brk                                     ; AEAE 00                       .
        brk                                     ; AEAF 00                       .
        eor     a:L0000,x                       ; AEB0 5D 00 00                 ]..
        brk                                     ; AEB3 00                       .
        sta     $8F8E                           ; AEB4 8D 8E 8F                 ...
        brk                                     ; AEB7 00                       .
        .byte   $EF                             ; AEB8 EF                       .
        .byte   $EF                             ; AEB9 EF                       .
        brk                                     ; AEBA 00                       .
        sty     $9D                             ; AEBB 84 9D                    ..
        ora     ($9F,x)                         ; AEBD 01 9F                    ..
        brk                                     ; AEBF 00                       .
        brk                                     ; AEC0 00                       .
        eor     a:L0000,x                       ; AEC1 5D 00 00                 ]..
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
LAED9:  brk                                     ; AED9 00                       .
        brk                                     ; AEDA 00                       .
        brk                                     ; AEDB 00                       .
        brk                                     ; AEDC 00                       .
        brk                                     ; AEDD 00                       .
        brk                                     ; AEDE 00                       .
        brk                                     ; AEDF 00                       .
        brk                                     ; AEE0 00                       .
        brk                                     ; AEE1 00                       .
LAEE2:  brk                                     ; AEE2 00                       .
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
        ora     ($02,x)                         ; AF01 01 02                    ..
        asl     $16,x                           ; AF03 16 16                    ..
        clc                                     ; AF05 18                       .
        .byte   $1A                             ; AF06 1A                       .
        brk                                     ; AF07 00                       .
LAF08:  .byte   $02                             ; AF08 02                       .
        .byte   $12                             ; AF09 12                       .
        brk                                     ; AF0A 00                       .
        .byte   $14                             ; AF0B 14                       .
        brk                                     ; AF0C 00                       .
        .byte   $1C                             ; AF0D 1C                       .
        asl     a:L0000,x                       ; AF0E 1E 00 00                 ...
        brk                                     ; AF11 00                       .
        .byte   $93                             ; AF12 93                       .
        brk                                     ; AF13 00                       .
        brk                                     ; AF14 00                       .
        brk                                     ; AF15 00                       .
        cpx     #$F4                            ; AF16 E0 F4                    ..
        .byte   $DB                             ; AF18 DB                       .
        cmp     LB6B3,x                         ; AF19 DD B3 B6                 ...
        lda     ($A3),y                         ; AF1C B1 A3                    ..
        ora     ($01,x)                         ; AF1E 01 01                    ..
        bcc     LAF33                           ; AF20 90 11                    ..
        ora     ($B3),y                         ; AF22 11 B3                    ..
        bcs     LAED9                           ; AF24 B0 B3                    ..
        .byte   $B3                             ; AF26 B3                       .
        bcs     LAED9                           ; AF27 B0 B0                    ..
        .byte   $B2                             ; AF29 B2                       .
        .byte   $B3                             ; AF2A B3                       .
        .byte   $11                             ; AF2B 11                       .
LAF2C:  .byte   $B0,$B0                    ; AF2C B0 B0   (branch out of range for ca65: target has no local label)
        .byte   $B3                             ; AF2E B3                       .
        bcs     LAF08                           ; AF2F B0 D7                    ..
        .byte   $D2                             ; AF31 D2                       .
        .byte   $D6                             ; AF32 D6                       .
LAF33:  sta     $F0,x                           ; AF33 95 F0                    ..
        .byte   $F2                             ; AF35 F2                       .
        inc     $95,x                           ; AF36 F6 95                    ..
        beq     LAF2C                           ; AF38 F0 F2                    ..
        inc     $B5,x                           ; AF3A F6 B5                    ..
        cld                                     ; AF3C D8                       .
        .byte   $DA                             ; AF3D DA                       .
        brk                                     ; AF3E 00                       .
        beq     LAF71                           ; AF3F F0 30                    .0
        brk                                     ; AF41 00                       .
        .byte   $32                             ; AF42 32                       2
        ora     ($34,x)                         ; AF43 01 34                    .4
LAF45:  brk                                     ; AF45 00                       .
        and     $403B,y                         ; AF46 39 3B 40                 9;@
        brk                                     ; AF49 00                       .
        .byte   $32                             ; AF4A 32                       2
        .byte   $32                             ; AF4B 32                       2
        brk                                     ; AF4C 00                       .
        brk                                     ; AF4D 00                       .
        brk                                     ; AF4E 00                       .
        cli                                     ; AF4F 58                       X
        .byte   $32                             ; AF50 32                       2
        .byte   $27                             ; AF51 27                       '
        .byte   $37                             ; AF52 37                       7
        .byte   $32                             ; AF53 32                       2
        brk                                     ; AF54 00                       .
        rol     L0000,x                         ; AF55 36 00                    6.
        pla                                     ; AF57 68                       h
        .byte   $32                             ; AF58 32                       2
        brk                                     ; AF59 00                       .
        rol     $32,x                           ; AF5A 36 32                    62
        .byte   $32                             ; AF5C 32                       2
        .byte   $32                             ; AF5D 32                       2
        .byte   $32                             ; AF5E 32                       2
        rti                                     ; AF5F 40                       @

; ----------------------------------------------------------------------------
        .byte   $44                             ; AF60 44                       D
        eor     L0000                           ; AF61 45 00                    E.
        bvc     LAFD5                           ; AF63 50 70                    Pp
        ror     $01                             ; AF65 66 01                    f.
        brk                                     ; AF67 00                       .
        .byte   $64                             ; AF68 64                       d
        adc     L0000                           ; AF69 65 00                    e.
        brk                                     ; AF6B 00                       .
        brk                                     ; AF6C 00                       .
        brk                                     ; AF6D 00                       .
        .byte   $63                             ; AF6E 63                       c
        brk                                     ; AF6F 00                       .
        brk                                     ; AF70 00                       .
LAF71:  brk                                     ; AF71 00                       .
        brk                                     ; AF72 00                       .
        brk                                     ; AF73 00                       .
        bvs     LAF76                           ; AF74 70 00                    p.
LAF76:  .byte   $73                             ; AF76 73                       s
        brk                                     ; AF77 00                       .
        eor     $52,y                           ; AF78 59 52 00                 YR.
        .byte   $63                             ; AF7B 63                       c
        bvc     LAF7E                           ; AF7C 50 00                    P.
LAF7E:  .byte   $63                             ; AF7E 63                       c
        brk                                     ; AF7F 00                       .
        sed                                     ; AF80 F8                       .
        .byte   $FA                             ; AF81 FA                       .
        .byte   $FB                             ; AF82 FB                       .
        sbc     LB8FE,x                         ; AF83 FD FE B8                 ...
        tya                                     ; AF86 98                       .
        ldy     $FAF9                           ; AF87 AC F9 FA                 ...
        beq     LAF8C                           ; AF8A F0 00                    ..
LAF8C:  brk                                     ; AF8C 00                       .
        .byte   $B3                             ; AF8D B3                       .
        tya                                     ; AF8E 98                       .
        txs                                     ; AF8F 9A                       .
        bcs     LAF45                           ; AF90 B0 B3                    ..
        .byte   $DA                             ; AF92 DA                       .
        brk                                     ; AF93 00                       .
        brk                                     ; AF94 00                       .
        ldy     LAAA8,x                         ; AF95 BC A8 AA                 ...
        brk                                     ; AF98 00                       .
        brk                                     ; AF99 00                       .
        beq     LAF9C                           ; AF9A F0 00                    ..
LAF9C:  brk                                     ; AF9C 00                       .
        .byte   $B2                             ; AF9D B2                       .
        .byte   $7A                             ; AF9E 7A                       z
        .byte   $7C                             ; AF9F 7C                       |
        lsr     $4D5E,x                         ; AFA0 5E 5E 4D                 ^^M
        lsr     $2F4D,x                         ; AFA3 5E 4D 2F                 ^M/
        lsr     $2C5E,x                         ; AFA6 5E 5E 2C                 ^^,
        lsr     $3F2F,x                         ; AFA9 5E 2F 3F                 ^/?
        brk                                     ; AFAC 00                       .
        brk                                     ; AFAD 00                       .
        brk                                     ; AFAE 00                       .
        brk                                     ; AFAF 00                       .
        .byte   $5C                             ; AFB0 5C                       \
        lsr     a:L0000,x                       ; AFB1 5E 00 00                 ^..
        lsr     $0101,x                         ; AFB4 5E 01 01                 ^..
        brk                                     ; AFB7 00                       .
        .byte   $DF                             ; AFB8 DF                       .
        lsr     $9300,x                         ; AFB9 5E 00 93                 ^..
        lsr     $0101,x                         ; AFBC 5E 01 01                 ^..
        brk                                     ; AFBF 00                       .
        clv                                     ; AFC0 B8                       .
        tsx                                     ; AFC1 BA                       .
        brk                                     ; AFC2 00                       .
        brk                                     ; AFC3 00                       .
        brk                                     ; AFC4 00                       .
        brk                                     ; AFC5 00                       .
        brk                                     ; AFC6 00                       .
        brk                                     ; AFC7 00                       .
        brk                                     ; AFC8 00                       .
        brk                                     ; AFC9 00                       .
        brk                                     ; AFCA 00                       .
        brk                                     ; AFCB 00                       .
        brk                                     ; AFCC 00                       .
        brk                                     ; AFCD 00                       .
        brk                                     ; AFCE 00                       .
        brk                                     ; AFCF 00                       .
        brk                                     ; AFD0 00                       .
        brk                                     ; AFD1 00                       .
        brk                                     ; AFD2 00                       .
        brk                                     ; AFD3 00                       .
        brk                                     ; AFD4 00                       .
LAFD5:  brk                                     ; AFD5 00                       .
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
        ora     ($03,x)                         ; B001 01 03                    ..
        .byte   $17                             ; B003 17                       .
        .byte   $17                             ; B004 17                       .
        ora     $1B,y                           ; B005 19 1B 00                 ...
        .byte   $03                             ; B008 03                       .
        .byte   $13                             ; B009 13                       .
        brk                                     ; B00A 00                       .
        ora     L0000,x                         ; B00B 15 00                    ..
        ora     a:$1F,x                         ; B00D 1D 1F 00                 ...
        brk                                     ; B010 00                       .
        brk                                     ; B011 00                       .
        sty     L0000,x                         ; B012 94 00                    ..
        brk                                     ; B014 00                       .
        brk                                     ; B015 00                       .
        .byte   $F3                             ; B016 F3                       .
        sbc     $DC,x                           ; B017 F5 DC                    ..
        .byte   $DB                             ; B019 DB                       .
        .byte   $B3                             ; B01A B3                       .
        .byte   $B7                             ; B01B B7                       .
        .byte   $B3                             ; B01C B3                       .
        ldy     $01,x                           ; B01D B4 01                    ..
        ora     ($11,x)                         ; B01F 01 11                    ..
        ora     ($97),y                         ; B021 11 97                    ..
        sta     $B3,x                           ; B023 95 B3                    ..
        .byte   $B3                             ; B025 B3                       .
        ldy     $B4,x                           ; B026 B4 B4                    ..
        .byte   $B3                             ; B028 B3                       .
        .byte   $B3                             ; B029 B3                       .
        ldy     $B5,x                           ; B02A B4 B5                    ..
        sta     $B3,x                           ; B02C 95 B3                    ..
        sta     $B4                             ; B02E 85 B4                    ..
        cmp     ($D3),y                         ; B030 D1 D3                    ..
        .byte   $E7                             ; B032 E7                       .
        sta     $F1,x                           ; B033 95 F1                    ..
        .byte   $F2                             ; B035 F2                       .
        .byte   $F7                             ; B036 F7                       .
        sta     $F1,x                           ; B037 95 F1                    ..
        .byte   $F2                             ; B039 F2                       .
        .byte   $F7                             ; B03A F7                       .
        lda     $D9,x                           ; B03B B5 D9                    ..
        .byte   $DA                             ; B03D DA                       .
        brk                                     ; B03E 00                       .
        .byte   $F7                             ; B03F F7                       .
        and     (L0000),y                       ; B040 31 00                    1.
        .byte   $33                             ; B042 33                       3
        ora     ($34,x)                         ; B043 01 34                    .4
        sec                                     ; B045 38                       8
        .byte   $3A                             ; B046 3A                       :
        brk                                     ; B047 00                       .
        eor     (L0000,x)                       ; B048 41 00                    A.
        .byte   $33                             ; B04A 33                       3
        .byte   $33                             ; B04B 33                       3
        brk                                     ; B04C 00                       .
        brk                                     ; B04D 00                       .
        brk                                     ; B04E 00                       .
        and     ($26),y                         ; B04F 31 26                    1&
        .byte   $27                             ; B051 27                       '
        .byte   $33                             ; B052 33                       3
        rol     L0000,x                         ; B053 36 00                    6.
        .byte   $33                             ; B055 33                       3
        brk                                     ; B056 00                       .
        eor     ($36,x)                         ; B057 41 36                    A6
        brk                                     ; B059 00                       .
        .byte   $33                             ; B05A 33                       3
        .byte   $33                             ; B05B 33                       3
        .byte   $33                             ; B05C 33                       3
        .byte   $33                             ; B05D 33                       3
        .byte   $33                             ; B05E 33                       3
        eor     ($45,x)                         ; B05F 41 45                    AE
        eor     $35                             ; B061 45 35                    E5
        eor     ($71),y                         ; B063 51 71                    Qq
        ora     ($67,x)                         ; B065 01 67                    .g
        brk                                     ; B067 00                       .
        adc     $65                             ; B068 65 65                    ee
        and     $61,x                           ; B06A 35 61                    5a
        adc     ($62),y                         ; B06C 71 62                    qb
        brk                                     ; B06E 00                       .
        brk                                     ; B06F 00                       .
        brk                                     ; B070 00                       .
        brk                                     ; B071 00                       .
        adc     ($60,x)                         ; B072 61 60                    a`
        adc     ($72),y                         ; B074 71 72                    qr
        brk                                     ; B076 00                       .
        brk                                     ; B077 00                       .
        eor     $6257,y                         ; B078 59 57 62                 YWb
        brk                                     ; B07B 00                       .
        eor     ($62),y                         ; B07C 51 62                    Qb
        brk                                     ; B07E 00                       .
        brk                                     ; B07F 00                       .
        sbc     $FCFA,y                         ; B080 F9 FA FC                 ...
        .byte   $FA                             ; B083 FA                       .
        sed                                     ; B084 F8                       .
        lda     $9B99,y                         ; B085 B9 99 9B                 ...
        .byte   $FA                             ; B088 FA                       .
        inc     a:$85,x                         ; B089 FE 85 00                 ...
        brk                                     ; B08C 00                       .
        .byte   $B3                             ; B08D B3                       .
        sty     LB39B                           ; B08E 8C 9B B3                 ...
        ldy     $A5,x                           ; B091 B4 A5                    ..
        brk                                     ; B093 00                       .
        brk                                     ; B094 00                       .
        lda     LABA9,x                         ; B095 BD A9 AB                 ...
        brk                                     ; B098 00                       .
        brk                                     ; B099 00                       .
        cmp     L0000,x                         ; B09A D5 00                    ..
        brk                                     ; B09C 00                       .
        .byte   $B3                             ; B09D B3                       .
        .byte   $7B                             ; B09E 7B                       {
        adc     $4C5F,x                         ; B09F 7D 5F 4C                 }_L
        jmp     L4C4C                           ; B0A2 4C 4C 4C                 LLL

; ----------------------------------------------------------------------------
        .byte   $2F                             ; B0A5 2F                       /
        .byte   $5F                             ; B0A6 5F                       _
        brk                                     ; B0A7 00                       .
        and     $2F2F                           ; B0A8 2D 2F 2F                 -//
        .byte   $3F                             ; B0AB 3F                       ?
        brk                                     ; B0AC 00                       .
        brk                                     ; B0AD 00                       .
        brk                                     ; B0AE 00                       .
        brk                                     ; B0AF 00                       .
        eor     a:L0000,x                       ; B0B0 5D 00 00                 ]..
        brk                                     ; B0B3 00                       .
        sta     $9F01,x                         ; B0B4 9D 01 9F                 ...
        brk                                     ; B0B7 00                       .
        .byte   $FF                             ; B0B8 FF                       .
        .byte   $FF                             ; B0B9 FF                       .
        brk                                     ; B0BA 00                       .
        sty     $9D,x                           ; B0BB 94 9D                    ..
        ora     ($9F,x)                         ; B0BD 01 9F                    ..
        brk                                     ; B0BF 00                       .
        lda     $BB,y                           ; B0C0 B9 BB 00                 ...
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
        bpl     LB124                           ; B101 10 21                    .!
        sbc     ($F1),y                         ; B103 F1 F1                    ..
        bvs     LB177                           ; B105 70 70                    pp
        bpl     LB14A                           ; B107 10 41                    .A
        ora     (L0000,x)                       ; B109 01 00                    ..
        sbc     (L0000),y                       ; B10B F1 00                    ..
        bvc     LB15F                           ; B10D 50 50                    PP
        brk                                     ; B10F 00                       .
        brk                                     ; B110 00                       .
        brk                                     ; B111 00                       .
        bpl     LB114                           ; B112 10 00                    ..
LB114:  brk                                     ; B114 00                       .
        brk                                     ; B115 00                       .
        brk                                     ; B116 00                       .
        brk                                     ; B117 00                       .
        bpl     LB12A                           ; B118 10 10                    ..
        bpl     LB12C                           ; B11A 10 10                    ..
        bpl     LB12E                           ; B11C 10 10                    ..
        bpl     LB130                           ; B11E 10 10                    ..
        bpl     LB132                           ; B120 10 10                    ..
        bpl     LB124                           ; B122 10 00                    ..
LB124:  bpl     LB136                           ; B124 10 10                    ..
        bpl     LB128                           ; B126 10 00                    ..
LB128:  bpl     LB13A                           ; B128 10 10                    ..
LB12A:  bpl     LB12C                           ; B12A 10 00                    ..
LB12C:  brk                                     ; B12C 00                       .
        brk                                     ; B12D 00                       .
LB12E:  brk                                     ; B12E 00                       .
        .byte   $10                             ; B12F 10                       .
LB130:  ora     ($11),y                         ; B130 11 11                    ..
LB132:  ora     ($11),y                         ; B132 11 11                    ..
        ora     ($11),y                         ; B134 11 11                    ..
LB136:  ora     ($11),y                         ; B136 11 11                    ..
        ora     ($11),y                         ; B138 11 11                    ..
LB13A:  ora     ($11),y                         ; B13A 11 11                    ..
        ora     ($11),y                         ; B13C 11 11                    ..
        bpl     LB151                           ; B13E 10 11                    ..
        .byte   $02                             ; B140 02                       .
        brk                                     ; B141 00                       .
        .byte   $02                             ; B142 02                       .
        .byte   $02                             ; B143 02                       .
        .byte   $02                             ; B144 02                       .
        brk                                     ; B145 00                       .
        brk                                     ; B146 00                       .
        brk                                     ; B147 00                       .
        .byte   $02                             ; B148 02                       .
        brk                                     ; B149 00                       .
LB14A:  .byte   $02                             ; B14A 02                       .
        .byte   $02                             ; B14B 02                       .
        brk                                     ; B14C 00                       .
        brk                                     ; B14D 00                       .
        brk                                     ; B14E 00                       .
        brk                                     ; B14F 00                       .
        .byte   $02                             ; B150 02                       .
LB151:  .byte   $02                             ; B151 02                       .
        .byte   $02                             ; B152 02                       .
        .byte   $02                             ; B153 02                       .
        brk                                     ; B154 00                       .
        .byte   $02                             ; B155 02                       .
        brk                                     ; B156 00                       .
        brk                                     ; B157 00                       .
        .byte   $02                             ; B158 02                       .
        brk                                     ; B159 00                       .
        .byte   $02                             ; B15A 02                       .
        .byte   $02                             ; B15B 02                       .
        .byte   $02                             ; B15C 02                       .
        .byte   $02                             ; B15D 02                       .
        .byte   $02                             ; B15E 02                       .
LB15F:  .byte   $02                             ; B15F 02                       .
        .byte   $03                             ; B160 03                       .
        .byte   $03                             ; B161 03                       .
        .byte   $02                             ; B162 02                       .
        .byte   $03                             ; B163 03                       .
        .byte   $03                             ; B164 03                       .
        .byte   $03                             ; B165 03                       .
        .byte   $03                             ; B166 03                       .
        brk                                     ; B167 00                       .
        .byte   $03                             ; B168 03                       .
        .byte   $03                             ; B169 03                       .
        .byte   $02                             ; B16A 02                       .
        .byte   $03                             ; B16B 03                       .
        .byte   $03                             ; B16C 03                       .
        .byte   $03                             ; B16D 03                       .
        .byte   $03                             ; B16E 03                       .
        brk                                     ; B16F 00                       .
        .byte   $03                             ; B170 03                       .
        .byte   $03                             ; B171 03                       .
        .byte   $03                             ; B172 03                       .
        .byte   $03                             ; B173 03                       .
        .byte   $03                             ; B174 03                       .
        .byte   $03                             ; B175 03                       .
        .byte   $03                             ; B176 03                       .
LB177:  brk                                     ; B177 00                       .
        .byte   $02                             ; B178 02                       .
        ora     ($03,x)                         ; B179 01 03                    ..
        .byte   $03                             ; B17B 03                       .
        .byte   $03                             ; B17C 03                       .
        .byte   $03                             ; B17D 03                       .
        .byte   $03                             ; B17E 03                       .
        brk                                     ; B17F 00                       .
        ora     ($11),y                         ; B180 11 11                    ..
        ora     ($11),y                         ; B182 11 11                    ..
        ora     ($10),y                         ; B184 11 10                    ..
        ora     ($11),y                         ; B186 11 11                    ..
        ora     ($11),y                         ; B188 11 11                    ..
        ora     (L0000),y                       ; B18A 11 00                    ..
        brk                                     ; B18C 00                       .
        bpl     LB1A0                           ; B18D 10 11                    ..
        ora     ($60),y                         ; B18F 11 60                    .`
        rts                                     ; B191 60                       `

; ----------------------------------------------------------------------------
        ora     (L0000),y                       ; B192 11 00                    ..
        brk                                     ; B194 00                       .
        bpl     LB1A8                           ; B195 10 11                    ..
        ora     (L0000),y                       ; B197 11 00                    ..
        brk                                     ; B199 00                       .
        ora     (L0000),y                       ; B19A 11 00                    ..
        brk                                     ; B19C 00                       .
        bpl     LB1B0                           ; B19D 10 11                    ..
        .byte   $11                             ; B19F 11                       .
LB1A0:  .byte   $03                             ; B1A0 03                       .
        .byte   $03                             ; B1A1 03                       .
        .byte   $03                             ; B1A2 03                       .
        .byte   $03                             ; B1A3 03                       .
        .byte   $03                             ; B1A4 03                       .
        .byte   $03                             ; B1A5 03                       .
        .byte   $03                             ; B1A6 03                       .
        .byte   $03                             ; B1A7 03                       .
LB1A8:  .byte   $03                             ; B1A8 03                       .
        .byte   $03                             ; B1A9 03                       .
        .byte   $03                             ; B1AA 03                       .
        .byte   $03                             ; B1AB 03                       .
        brk                                     ; B1AC 00                       .
        brk                                     ; B1AD 00                       .
        brk                                     ; B1AE 00                       .
        brk                                     ; B1AF 00                       .
LB1B0:  .byte   $03                             ; B1B0 03                       .
        .byte   $03                             ; B1B1 03                       .
        brk                                     ; B1B2 00                       .
        brk                                     ; B1B3 00                       .
        .byte   $03                             ; B1B4 03                       .
        .byte   $03                             ; B1B5 03                       .
        .byte   $03                             ; B1B6 03                       .
        brk                                     ; B1B7 00                       .
        .byte   $03                             ; B1B8 03                       .
        .byte   $03                             ; B1B9 03                       .
        brk                                     ; B1BA 00                       .
        .byte   $02                             ; B1BB 02                       .
        .byte   $03                             ; B1BC 03                       .
        .byte   $03                             ; B1BD 03                       .
        .byte   $03                             ; B1BE 03                       .
        brk                                     ; B1BF 00                       .
        .byte   $03                             ; B1C0 03                       .
        .byte   $03                             ; B1C1 03                       .
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
        rol     $24                             ; B200 26 24                    &$
        bit     $26                             ; B202 24 26                    $&
        rol     $24                             ; B204 26 24                    &$
        asl     $17,x                           ; B206 16 17                    ..
        rol     $2F                             ; B208 26 2F                    &/
        bit     $26                             ; B20A 24 26                    $&
        .byte   $02                             ; B20C 02                       .
        bit     $02                             ; B20D 24 02                    $.
        .byte   $2F                             ; B20F 2F                       /
        rol     $02                             ; B210 26 02                    &.
        .byte   $2F                             ; B212 2F                       /
        .byte   $02                             ; B213 02                       .
        .byte   $2F                             ; B214 2F                       /
        bit     $24                             ; B215 24 24                    $$
        rol     $86                             ; B217 26 86                    &.
        .byte   $87                             ; B219 87                       .
        stx     $97,y                           ; B21A 96 97                    ..
        rol     $24                             ; B21C 26 24                    &$
        lsr     $265F,x                         ; B21E 5E 5F 26                 ^_&
        bit     $5E                             ; B221 24 5E                    $^
        lsr     $2402,x                         ; B223 5E 02 24                 ^.$
        .byte   $02                             ; B226 02                       .
        .byte   $5F                             ; B227 5F                       _
        rol     $02                             ; B228 26 02                    &.
        lsr     $8602,x                         ; B22A 5E 02 86                 ^..
        .byte   $87                             ; B22D 87                       .
        stx     $428F                           ; B22E 8E 8F 42                 ..B
        rti                                     ; B231 40                       @

; ----------------------------------------------------------------------------
        bit     $26                             ; B232 24 26                    $&
        .byte   $42                             ; B234 42                       B
        .byte   $42                             ; B235 42                       B
        php                                     ; B236 08                       .
        bit     $02                             ; B237 24 02                    $.
        rti                                     ; B239 40                       @

; ----------------------------------------------------------------------------
        and     $25                             ; B23A 25 25                    %%
        .byte   $42                             ; B23C 42                       B
        .byte   $02                             ; B23D 02                       .
        and     $25                             ; B23E 25 25                    %%
        .byte   $42                             ; B240 42                       B
        rti                                     ; B241 40                       @

; ----------------------------------------------------------------------------
        rol     $08                             ; B242 26 08                    &.
        .byte   $42                             ; B244 42                       B
        .byte   $42                             ; B245 42                       B
        bit     $26                             ; B246 24 26                    $&
        stx     $8E8F                           ; B248 8E 8F 8E                 ...
        .byte   $8F                             ; B24B 8F                       .
        lsr     $425F,x                         ; B24C 5E 5F 42                 ^_B
        rti                                     ; B24F 40                       @

; ----------------------------------------------------------------------------
        .byte   $02                             ; B250 02                       .
LB251:  lsr     $4202,x                         ; B251 5E 02 42                 ^.B
        lsr     $4224,x                         ; B254 5E 24 42                 ^$B
        .byte   $2F                             ; B257 2F                       /
        rol     $5E                             ; B258 26 5E                    &^
        .byte   $2F                             ; B25A 2F                       /
        .byte   $42                             ; B25B 42                       B
        lsr     $4202,x                         ; B25C 5E 02 42                 ^.B
        .byte   $02                             ; B25F 02                       .
        lsr     $425E,x                         ; B260 5E 5E 42                 ^^B
        .byte   $42                             ; B263 42                       B
        stx     $968F                           ; B264 8E 8F 96                 ...
        .byte   $97                             ; B267 97                       .
        .byte   $42                             ; B268 42                       B
        .byte   $42                             ; B269 42                       B
        lsr     a                               ; B26A 4A                       J
        lsr     a                               ; B26B 4A                       J
        bit     $25                             ; B26C 24 25                    $%
        lsr     $255F,x                         ; B26E 5E 5F 25                 ^_%
        rol     $5E                             ; B271 26 5E                    &^
        lsr     $4042,x                         ; B273 5E 42 40                 ^B@
        lsr     a                               ; B276 4A                       J
        pha                                     ; B277 48                       H
        stx     $87                             ; B278 86 87                    ..
        .byte   $9E                             ; B27A 9E                       .
        .byte   $9F                             ; B27B 9F                       .
        .byte   $42                             ; B27C 42                       B
        .byte   $42                             ; B27D 42                       B
        .byte   $42                             ; B27E 42                       B
        .byte   $42                             ; B27F 42                       B
        .byte   $42                             ; B280 42                       B
        rti                                     ; B281 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; B282 42                       B
        rti                                     ; B283 40                       @

; ----------------------------------------------------------------------------
        jsr     L2821                           ; B284 20 21 28                  !(
        and     #$21                            ; B287 29 21                    )!
        .byte   $22                             ; B289 22                       "
        and     #$2A                            ; B28A 29 2A                    )*
        rol     $2F                             ; B28C 26 2F                    &/
        asl     $17,x                           ; B28E 16 17                    ..
        and     ($22,x)                         ; B290 21 22                    !"
        and     #$1B                            ; B292 29 1B                    ).
        .byte   $2F                             ; B294 2F                       /
        .byte   $2F                             ; B295 2F                       /
        bit     $26                             ; B296 24 26                    $&
        .byte   $02                             ; B298 02                       .
        .byte   $5F                             ; B299 5F                       _
        .byte   $02                             ; B29A 02                       .
        rti                                     ; B29B 40                       @

; ----------------------------------------------------------------------------
        lsr     $4A53,x                         ; B29C 5E 53 4A                 ^SJ
        cli                                     ; B29F 58                       X
        brk                                     ; B2A0 00                       .
        bit     L0000                           ; B2A1 24 00                    $.
        .byte   $2F                             ; B2A3 2F                       /
        rol     L0000                           ; B2A4 26 00                    &.
        .byte   $2F                             ; B2A6 2F                       /
        brk                                     ; B2A7 00                       .
        brk                                     ; B2A8 00                       .
        brk                                     ; B2A9 00                       .
        brk                                     ; B2AA 00                       .
        brk                                     ; B2AB 00                       .
        .byte   $02                             ; B2AC 02                       .
        rti                                     ; B2AD 40                       @

; ----------------------------------------------------------------------------
        .byte   $02                             ; B2AE 02                       .
        .byte   $2F                             ; B2AF 2F                       /
        lsr     a                               ; B2B0 4A                       J
        cli                                     ; B2B1 58                       X
        bit     $26                             ; B2B2 24 26                    $&
        brk                                     ; B2B4 00                       .
        bit     $24                             ; B2B5 24 24                    $$
        rol     $26                             ; B2B7 26 26                    &&
        brk                                     ; B2B9 00                       .
        bit     $26                             ; B2BA 24 26                    $&
        brk                                     ; B2BC 00                       .
        brk                                     ; B2BD 00                       .
        bcc     LB251                           ; B2BE 90 91                    ..
        ora     $241C,x                         ; B2C0 1D 1C 24                 ..$
        rol     $26                             ; B2C3 26 26                    &&
        bit     $5E                             ; B2C5 24 5E                    $^
        .byte   $53                             ; B2C7 53                       S
        rol     $24                             ; B2C8 26 24                    &$
        brk                                     ; B2CA 00                       .
        .byte   $2F                             ; B2CB 2F                       /
        rol     $1C                             ; B2CC 26 1C                    &.
        .byte   $2F                             ; B2CE 2F                       /
        brk                                     ; B2CF 00                       .
        sta     ($90),y                         ; B2D0 91 90                    ..
        brk                                     ; B2D2 00                       .
        brk                                     ; B2D3 00                       .
        .byte   $02                             ; B2D4 02                       .
        rti                                     ; B2D5 40                       @

; ----------------------------------------------------------------------------
        .byte   $02                             ; B2D6 02                       .
        pha                                     ; B2D7 48                       H
        lsr     a                               ; B2D8 4A                       J
        cli                                     ; B2D9 58                       X
        lsr     a                               ; B2DA 4A                       J
        cli                                     ; B2DB 58                       X
        adc     ($24,x)                         ; B2DC 61 24                    a$
        adc     #$2F                            ; B2DE 69 2F                    i/
        rol     $60                             ; B2E0 26 60                    &`
        .byte   $2F                             ; B2E2 2F                       /
        pla                                     ; B2E3 68                       h
        adc     ($60,x)                         ; B2E4 61 60                    a`
        adc     #$68                            ; B2E6 69 68                    ih
        php                                     ; B2E8 08                       .
        bit     $02                             ; B2E9 24 02                    $.
        .byte   $2F                             ; B2EB 2F                       /
        rol     $08                             ; B2EC 26 08                    &.
        .byte   $2F                             ; B2EE 2F                       /
        .byte   $02                             ; B2EF 02                       .
        rol     $24                             ; B2F0 26 24                    &$
        lsr     $422F,x                         ; B2F2 5E 2F 42                 ^/B
        lsr     $4242,x                         ; B2F5 5E 42 42                 ^BB
        lsr     a                               ; B2F8 4A                       J
        pha                                     ; B2F9 48                       H
        lsr     a                               ; B2FA 4A                       J
        pha                                     ; B2FB 48                       H
        lsr     a                               ; B2FC 4A                       J
        lsr     a                               ; B2FD 4A                       J
        lsr     a                               ; B2FE 4A                       J
        lsr     a                               ; B2FF 4A                       J
        lsr     a                               ; B300 4A                       J
        bvc     LB34D                           ; B301 50 4A                    PJ
        cli                                     ; B303 58                       X
        bmi     LB338                           ; B304 30 32                    02
        sec                                     ; B306 38                       8
        .byte   $3A                             ; B307 3A                       :
        rol     $48                             ; B308 26 48                    &H
        .byte   $2F                             ; B30A 2F                       /
        pha                                     ; B30B 48                       H
        .byte   $42                             ; B30C 42                       B
        rti                                     ; B30D 40                       @

; ----------------------------------------------------------------------------
        php                                     ; B30E 08                       .
        .byte   $2F                             ; B30F 2F                       /
        eor     ($51),y                         ; B310 51 51                    QQ
        brk                                     ; B312 00                       .
        ror     a                               ; B313 6A                       j
        eor     ($51),y                         ; B314 51 51                    QQ
        brk                                     ; B316 00                       .
        brk                                     ; B317 00                       .
        .byte   $52                             ; B318 52                       R
        pha                                     ; B319 48                       H
        .byte   $5A                             ; B31A 5A                       Z
        pha                                     ; B31B 48                       H
        brk                                     ; B31C 00                       .
        .byte   $62                             ; B31D 62                       b
        brk                                     ; B31E 00                       .
        .byte   $62                             ; B31F 62                       b
        .byte   $5A                             ; B320 5A                       Z
        pha                                     ; B321 48                       H
        .byte   $5A                             ; B322 5A                       Z
        pha                                     ; B323 48                       H
        .byte   $2F                             ; B324 2F                       /
        rti                                     ; B325 40                       @

; ----------------------------------------------------------------------------
        bit     $26                             ; B326 24 26                    $&
        .byte   $42                             ; B328 42                       B
        .byte   $2F                             ; B329 2F                       /
        bit     $26                             ; B32A 24 26                    $&
        .byte   $33                             ; B32C 33                       3
        .byte   $33                             ; B32D 33                       3
        .byte   $3B                             ; B32E 3B                       ;
        .byte   $3B                             ; B32F 3B                       ;
        .byte   $33                             ; B330 33                       3
        bit     $3B                             ; B331 24 3B                    $;
        .byte   $2F                             ; B333 2F                       /
        rol     $24                             ; B334 26 24                    &$
        .byte   $3C                             ; B336 3C                       <
        .byte   $3D                             ; B337 3D                       =
LB338:  brk                                     ; B338 00                       .
        bit     L0000                           ; B339 24 00                    $.
        brk                                     ; B33B 00                       .
        rol     $24                             ; B33C 26 24                    &$
        brk                                     ; B33E 00                       .
        brk                                     ; B33F 00                       .
        brk                                     ; B340 00                       .
        brk                                     ; B341 00                       .
        brk                                     ; B342 00                       .
        eor     $5355,y                         ; B343 59 55 53                 YUS
        .byte   $5A                             ; B346 5A                       Z
        cli                                     ; B347 58                       X
        brk                                     ; B348 00                       .
        brk                                     ; B349 00                       .
        brk                                     ; B34A 00                       .
        ror     a                               ; B34B 6A                       j
        brk                                     ; B34C 00                       .
LB34D:  eor     $5900,y                         ; B34D 59 00 59                 Y.Y
        .byte   $5A                             ; B350 5A                       Z
        cli                                     ; B351 58                       X
        .byte   $5A                             ; B352 5A                       Z
        cli                                     ; B353 58                       X
        adc     ($60,x)                         ; B354 61 60                    a`
        bit     $26                             ; B356 24 26                    $&
        .byte   $42                             ; B358 42                       B
        .byte   $42                             ; B359 42                       B
        eor     ($51),y                         ; B35A 51 51                    QQ
        .byte   $42                             ; B35C 42                       B
        rti                                     ; B35D 40                       @

; ----------------------------------------------------------------------------
        .byte   $52                             ; B35E 52                       R
        pha                                     ; B35F 48                       H
        .byte   $42                             ; B360 42                       B
        .byte   $42                             ; B361 42                       B
        bvc     LB3B5                           ; B362 50 51                    PQ
        cli                                     ; B364 58                       X
        brk                                     ; B365 00                       .
LB366:  cli                                     ; B366 58                       X
        brk                                     ; B367 00                       .
        cli                                     ; B368 58                       X
        adc     ($58,x)                         ; B369 61 58                    aX
        adc     #$2F                            ; B36B 69 2F                    i/
        bit     $1C                             ; B36D 24 1C                    $.
        ora     $7071,x                         ; B36F 1D 71 70                 .qp
        .byte   $5C                             ; B372 5C                       \
        .byte   $5C                             ; B373 5C                       \
        eor     ($51),y                         ; B374 51 51                    QQ
        .byte   $63                             ; B376 63                       c
        .byte   $63                             ; B377 63                       c
        rol     $24                             ; B378 26 24                    &$
        eor     $5F,x                           ; B37A 55 5F                    U_
        rol     $2F                             ; B37C 26 2F                    &/
        .byte   $53                             ; B37E 53                       S
        brk                                     ; B37F 00                       .
        .byte   $5A                             ; B380 5A                       Z
        pha                                     ; B381 48                       H
        eor     $5848,x                         ; B382 5D 48 58                 ]HX
        adc     ($5B),y                         ; B385 71 5B                    q[
        .byte   $5C                             ; B387 5C                       \
        adc     ($70),y                         ; B388 71 70                    qp
        .byte   $34                             ; B38A 34                       4
        rol     $0D,x                           ; B38B 36 0D                    6.
        asl     $5F5E                           ; B38D 0E 5E 5F                 .^_
        .byte   $42                             ; B390 42                       B
        .byte   $42                             ; B391 42                       B
        ora     $5E0E                           ; B392 0D 0E 5E                 ..^
        lsr     $5151,x                         ; B395 5E 51 51                 ^QQ
        and     ($32),y                         ; B398 31 32                    12
        .byte   $39                             ; B39A 39                       9
LB39B:  .byte   $3A                             ; B39B 3A                       :
        adc     ($60,x)                         ; B39C 61 60                    a`
        php                                     ; B39E 08                       .
        pla                                     ; B39F 68                       h
        .byte   $02                             ; B3A0 02                       .
        bvs     LB3A5                           ; B3A1 70 02                    p.
        brk                                     ; B3A3 00                       .
        .byte   $71                             ; B3A4 71                       q
LB3A5:  bvs     LB3A7                           ; B3A5 70 00                    p.
LB3A7:  brk                                     ; B3A7 00                       .
        cli                                     ; B3A8 58                       X
        adc     ($58),y                         ; B3A9 71 58                    qX
        brk                                     ; B3AB 00                       .
        .byte   $02                             ; B3AC 02                       .
        brk                                     ; B3AD 00                       .
        .byte   $02                             ; B3AE 02                       .
        .byte   $5C                             ; B3AF 5C                       \
        brk                                     ; B3B0 00                       .
        brk                                     ; B3B1 00                       .
        .byte   $5C                             ; B3B2 5C                       \
        .byte   $5C                             ; B3B3 5C                       \
        .byte   $5B                             ; B3B4 5B                       [
LB3B5:  .byte   $5C                             ; B3B5 5C                       \
        lsr     a                               ; B3B6 4A                       J
        lsr     a                               ; B3B7 4A                       J
        .byte   $5C                             ; B3B8 5C                       \
        .byte   $5C                             ; B3B9 5C                       \
        lsr     a                               ; B3BA 4A                       J
        lsr     a                               ; B3BB 4A                       J
        .byte   $02                             ; B3BC 02                       .
        .byte   $42                             ; B3BD 42                       B
        .byte   $02                             ; B3BE 02                       .
        .byte   $42                             ; B3BF 42                       B
        .byte   $42                             ; B3C0 42                       B
        .byte   $03                             ; B3C1 03                       .
        .byte   $42                             ; B3C2 42                       B
        .byte   $4B                             ; B3C3 4B                       K
        .byte   $42                             ; B3C4 42                       B
        .byte   $03                             ; B3C5 03                       .
        .byte   $03                             ; B3C6 03                       .
        .byte   $4B                             ; B3C7 4B                       K
        .byte   $42                             ; B3C8 42                       B
        .byte   $03                             ; B3C9 03                       .
        .byte   $03                             ; B3CA 03                       .
        .byte   $5F                             ; B3CB 5F                       _
        .byte   $4B                             ; B3CC 4B                       K
        .byte   $42                             ; B3CD 42                       B
        .byte   $42                             ; B3CE 42                       B
        .byte   $42                             ; B3CF 42                       B
        .byte   $4B                             ; B3D0 4B                       K
        rti                                     ; B3D1 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; B3D2 42                       B
        rti                                     ; B3D3 40                       @

; ----------------------------------------------------------------------------
        .byte   $04                             ; B3D4 04                       .
        .byte   $04                             ; B3D5 04                       .
        .byte   $4B                             ; B3D6 4B                       K
        .byte   $4B                             ; B3D7 4B                       K
        and     $26                             ; B3D8 25 26                    %&
        .byte   $63                             ; B3DA 63                       c
        .byte   $63                             ; B3DB 63                       c
        eor     ($51),y                         ; B3DC 51 51                    QQ
        adc     $66                             ; B3DE 65 66                    ef
        bvc     LB433                           ; B3E0 50 51                    PQ
        cli                                     ; B3E2 58                       X
        .byte   $63                             ; B3E3 63                       c
        .byte   $6B                             ; B3E4 6B                       k
        .byte   $6B                             ; B3E5 6B                       k
        .byte   $64                             ; B3E6 64                       d
        .byte   $64                             ; B3E7 64                       d
        adc     $756E                           ; B3E8 6D 6E 75                 mnu
        ora     $6B                             ; B3EB 05 6B                    .k
        .byte   $6B                             ; B3ED 6B                       k
        asl     $64                             ; B3EE 06 64                    .d
        cli                                     ; B3F0 58                       X
        .byte   $6B                             ; B3F1 6B                       k
        cli                                     ; B3F2 58                       X
        .byte   $64                             ; B3F3 64                       d
        adc     $757B,x                         ; B3F4 7D 7B 75                 }{u
        ror     $72,x                           ; B3F7 76 72                    vr
        .byte   $6B                             ; B3F9 6B                       k
        jmp     (L5864)                         ; B3FA 6C 64 58                 ldX

; ----------------------------------------------------------------------------
        .byte   $6B                             ; B3FD 6B                       k
        ora     $06                             ; B3FE 05 06                    ..
        .byte   $6B                             ; B400 6B                       k
        .byte   $6B                             ; B401 6B                       k
        .byte   $73                             ; B402 73                       s
        .byte   $73                             ; B403 73                       s
        adc     $757E,x                         ; B404 7D 7E 75                 }~u
        ror     $53,x                           ; B407 76 53                    vS
        .byte   $72                             ; B409 72                       r
        cli                                     ; B40A 58                       X
        .byte   $73                             ; B40B 73                       s
        .byte   $04                             ; B40C 04                       .
        .byte   $04                             ; B40D 04                       .
        .byte   $4B                             ; B40E 4B                       K
        .byte   $5F                             ; B40F 5F                       _
        .byte   $6B                             ; B410 6B                       k
        .byte   $6B                             ; B411 6B                       k
        .byte   $6B                             ; B412 6B                       k
        .byte   $6B                             ; B413 6B                       k
        .byte   $6B                             ; B414 6B                       k
        .byte   $6B                             ; B415 6B                       k
        ora     $06                             ; B416 05 06                    ..
        .byte   $72                             ; B418 72                       r
        .byte   $72                             ; B419 72                       r
        .byte   $64                             ; B41A 64                       d
        .byte   $64                             ; B41B 64                       d
        .byte   $5A                             ; B41C 5A                       Z
        pha                                     ; B41D 48                       H
        .byte   $5A                             ; B41E 5A                       Z
        ora     $6B58                           ; B41F 0D 58 6B                 .Xk
        asl     $5A64                           ; B422 0E 64 5A                 .dZ
        .byte   $5F                             ; B425 5F                       _
        .byte   $5A                             ; B426 5A                       Z
        pha                                     ; B427 48                       H
        .byte   $53                             ; B428 53                       S
        .byte   $6B                             ; B429 6B                       k
        cli                                     ; B42A 58                       X
        .byte   $64                             ; B42B 64                       d
        .byte   $72                             ; B42C 72                       r
        .byte   $72                             ; B42D 72                       r
        .byte   $73                             ; B42E 73                       s
        .byte   $73                             ; B42F 73                       s
        cli                                     ; B430 58                       X
        .byte   $6B                             ; B431 6B                       k
        cli                                     ; B432 58                       X
LB433:  .byte   $73                             ; B433 73                       s
        sei                                     ; B434 78                       x
        sei                                     ; B435 78                       x
        .byte   $63                             ; B436 63                       c
        .byte   $63                             ; B437 63                       c
        sei                                     ; B438 78                       x
        sei                                     ; B439 78                       x
        adc     $66                             ; B43A 65 66                    ef
        adc     $756E                           ; B43C 6D 6E 75                 mnu
        ror     $0D,x                           ; B43F 76 0D                    v.
        asl     $7272                           ; B441 0E 72 72                 .rr
        .byte   $6B                             ; B444 6B                       k
        .byte   $6B                             ; B445 6B                       k
        jmp     (L0564)                         ; B446 6C 64 05                 ld.

; ----------------------------------------------------------------------------
        asl     $72                             ; B449 06 72                    .r
        .byte   $72                             ; B44B 72                       r
        .byte   $32                             ; B44C 32                       2
        tax                                     ; B44D AA                       .
        .byte   $3A                             ; B44E 3A                       :
        tax                                     ; B44F AA                       .
        tax                                     ; B450 AA                       .
        tax                                     ; B451 AA                       .
        tax                                     ; B452 AA                       .
        tax                                     ; B453 AA                       .
        .byte   $02                             ; B454 02                       .
        brk                                     ; B455 00                       .
        .byte   $02                             ; B456 02                       .
        tax                                     ; B457 AA                       .
        brk                                     ; B458 00                       .
        brk                                     ; B459 00                       .
        tax                                     ; B45A AA                       .
        tax                                     ; B45B AA                       .
        brk                                     ; B45C 00                       .
        brk                                     ; B45D 00                       .
        cpy     #$C1                            ; B45E C0 C1                    ..
        brk                                     ; B460 00                       .
        bit     $AA                             ; B461 24 AA                    $.
        .byte   $2F                             ; B463 2F                       /
        .byte   $02                             ; B464 02                       .
        tax                                     ; B465 AA                       .
        .byte   $02                             ; B466 02                       .
        tax                                     ; B467 AA                       .
        cpy     #$C1                            ; B468 C0 C1                    ..
        cpy     #$C1                            ; B46A C0 C1                    ..
        tax                                     ; B46C AA                       .
        bit     $AA                             ; B46D 24 AA                    $.
        .byte   $2F                             ; B46F 2F                       /
        and     ($31),y                         ; B470 31 31                    11
        and     $3039,y                         ; B472 39 39 30                 990
        and     ($38),y                         ; B475 31 38                    18
        and     $33,y                           ; B477 39 33 00                 93.
        .byte   $3B                             ; B47A 3B                       ;
        tax                                     ; B47B AA                       .
        ldx     $A7                             ; B47C A6 A7                    ..
        ldy     #$A1                            ; B47E A0 A1                    ..
        brk                                     ; B480 00                       .
        brk                                     ; B481 00                       .
        ldx     #$A2                            ; B482 A2 A2                    ..
        ldy     #$A1                            ; B484 A0 A1                    ..
        ldy     #$A1                            ; B486 A0 A1                    ..
        .byte   $34                             ; B488 34                       4
        and     L0000,x                         ; B489 35 00                    5.
        brk                                     ; B48B 00                       .
        rol     $A2,x                           ; B48C 36 A2                    6.
        brk                                     ; B48E 00                       .
        ldx     #$A2                            ; B48F A2 A2                    ..
        ldx     #$A2                            ; B491 A2 A2                    ..
        ldx     #$36                            ; B493 A2 36                    .6
        tax                                     ; B495 AA                       .
        brk                                     ; B496 00                       .
        tax                                     ; B497 AA                       .
        rol     $AA,x                           ; B498 36 AA                    6.
        and     $36,x                           ; B49A 35 36                    56
        tax                                     ; B49C AA                       .
        tax                                     ; B49D AA                       .
        .byte   $34                             ; B49E 34                       4
        rol     $AA,x                           ; B49F 36 AA                    6.
        tax                                     ; B4A1 AA                       .
        php                                     ; B4A2 08                       .
        tax                                     ; B4A3 AA                       .
        dey                                     ; B4A4 88                       .
        .byte   $82                             ; B4A5 82                       .
        dey                                     ; B4A6 88                       .
        .byte   $82                             ; B4A7 82                       .
        .byte   $83                             ; B4A8 83                       .
        sty     $83                             ; B4A9 84 83                    ..
        sty     $37                             ; B4AB 84 37                    .7
        .byte   $37                             ; B4AD 37                       7
        .byte   $3B                             ; B4AE 3B                       ;
        .byte   $3B                             ; B4AF 3B                       ;
        ldx     $A7                             ; B4B0 A6 A7                    ..
        ldy     #$A9                            ; B4B2 A0 A9                    ..
        ldy     #$A9                            ; B4B4 A0 A9                    ..
        ldy     #$A9                            ; B4B6 A0 A9                    ..
        ldy     #$34                            ; B4B8 A0 34                    .4
        ldy     #$A3                            ; B4BA A0 A3                    ..
        and     $35,x                           ; B4BC 35 35                    55
        ldy     $A4                             ; B4BE A4 A4                    ..
        and     $35,x                           ; B4C0 35 35                    55
        ldx     $A3                             ; B4C2 A6 A3                    ..
        and     $36,x                           ; B4C4 35 36                    56
        ldy     $A4                             ; B4C6 A4 A4                    ..
        .byte   $34                             ; B4C8 34                       4
        and     $A5,x                           ; B4C9 35 A5                    5.
        lda     $AA                             ; B4CB A5 AA                    ..
        tax                                     ; B4CD AA                       .
        .byte   $AB                             ; B4CE AB                       .
        .byte   $AB                             ; B4CF AB                       .
        .byte   $37                             ; B4D0 37                       7
        and     $2F37,x                         ; B4D1 3D 37 2F                 =7/
        .byte   $3C                             ; B4D4 3C                       <
        and     $2624,x                         ; B4D5 3D 24 26                 =$&
        .byte   $37                             ; B4D8 37                       7
        and     $2637,x                         ; B4D9 3D 37 26                 =7&
        .byte   $37                             ; B4DC 37                       7
        bit     $3B                             ; B4DD 24 3B                    $;
        .byte   $2F                             ; B4DF 2F                       /
        .byte   $34                             ; B4E0 34                       4
        and     $A4,x                           ; B4E1 35 A4                    5.
        ldy     $03                             ; B4E3 A4 03                    ..
        .byte   $03                             ; B4E5 03                       .
        ldy     $A4                             ; B4E6 A4 A4                    ..
        .byte   $83                             ; B4E8 83                       .
        .byte   $89                             ; B4E9 89                       .
        .byte   $83                             ; B4EA 83                       .
        .byte   $89                             ; B4EB 89                       .
        .byte   $33                             ; B4EC 33                       3
        .byte   $33                             ; B4ED 33                       3
        .byte   $37                             ; B4EE 37                       7
        .byte   $37                             ; B4EF 37                       7
        .byte   $83                             ; B4F0 83                       .
        .byte   $82                             ; B4F1 82                       .
        .byte   $83                             ; B4F2 83                       .
        .byte   $82                             ; B4F3 82                       .
        .byte   $03                             ; B4F4 03                       .
        .byte   $03                             ; B4F5 03                       .
        .byte   $34                             ; B4F6 34                       4
        rol     $37,x                           ; B4F7 36 37                    67
        bit     $37                             ; B4F9 24 37                    $7
        .byte   $2F                             ; B4FB 2F                       /
        rol     $2F                             ; B4FC 26 2F                    &/
        txa                                     ; B4FE 8A                       .
        rol     $92,x                           ; B4FF 36 92                    6.
        .byte   $3C                             ; B501 3C                       <
        txs                                     ; B502 9A                       .
        rol     $2F,x                           ; B503 36 2F                    6/
        bit     $8A                             ; B505 24 8A                    $.
        rol     $3D,x                           ; B507 36 3D                    6=
        .byte   $2F                             ; B509 2F                       /
        bit     $26                             ; B50A 24 26                    $&
        rol     $24                             ; B50C 26 24                    &$
        txa                                     ; B50E 8A                       .
        rol     $2F,x                           ; B50F 36 2F                    6/
        .byte   $3C                             ; B511 3C                       <
        bit     $26                             ; B512 24 26                    $&
        .byte   $37                             ; B514 37                       7
        bmi     LB54E                           ; B515 30 37                    07
        sec                                     ; B517 38                       8
        jsr     L2895                           ; B518 20 95 28                  .(
        sta     $2437,x                         ; B51B 9D 37 24                 .7$
        txa                                     ; B51E 8A                       .
        rol     $95,x                           ; B51F 36 95                    6.
        .byte   $22                             ; B521 22                       "
        sta     $2F2A,x                         ; B522 9D 2A 2F                 .*/
        .byte   $2F                             ; B525 2F                       /
        ldx     $A7                             ; B526 A6 A7                    ..
        and     $2424,x                         ; B528 3D 24 24                 =$$
        rol     $26                             ; B52B 26 26                    &&
        brk                                     ; B52D 00                       .
        .byte   $2F                             ; B52E 2F                       /
        ldx     #$26                            ; B52F A2 26                    .&
        ldx     #$2F                            ; B531 A2 2F                    ./
        ldx     #$00                            ; B533 A2 00                    ..
        ldx     #$A2                            ; B535 A2 A2                    ..
        ldx     #$A6                            ; B537 A2 A6                    ..
        .byte   $A7                             ; B539 A7                       .
        ldy     #$B1                            ; B53A A0 B1                    ..
        brk                                     ; B53C 00                       .
        .byte   $02                             ; B53D 02                       .
        brk                                     ; B53E 00                       .
        .byte   $02                             ; B53F 02                       .
        ldy     #$B1                            ; B540 A0 B1                    ..
        ldy     #$B1                            ; B542 A0 B1                    ..
        ldy     #$B1                            ; B544 A0 B1                    ..
        bit     $26                             ; B546 24 26                    $&
        brk                                     ; B548 00                       .
        brk                                     ; B549 00                       .
        .byte   $2F                             ; B54A 2F                       /
        brk                                     ; B54B 00                       .
        tax                                     ; B54C AA                       .
        brk                                     ; B54D 00                       .
LB54E:  tax                                     ; B54E AA                       .
        tax                                     ; B54F AA                       .
        brk                                     ; B550 00                       .
        brk                                     ; B551 00                       .
        bit     $26                             ; B552 24 26                    $&
        ldy     #$B1                            ; B554 A0 B1                    ..
        .byte   $34                             ; B556 34                       4
        rol     $2F,x                           ; B557 36 2F                    6/
        bit     $34                             ; B559 24 34                    $4
        rol     $26,x                           ; B55B 36 26                    6&
        .byte   $2F                             ; B55D 2F                       /
        .byte   $34                             ; B55E 34                       4
        and     $3C,x                           ; B55F 35 3C                    5<
        and     $3635,x                         ; B561 3D 35 36                 =56
        .byte   $02                             ; B564 02                       .
        tax                                     ; B565 AA                       .
        bit     $26                             ; B566 24 26                    $&
        .byte   $2F                             ; B568 2F                       /
        bit     $16                             ; B569 24 16                    $.
        .byte   $17                             ; B56B 17                       .
        rol     $AA                             ; B56C 26 AA                    &.
        bit     $26                             ; B56E 24 26                    $&
        brk                                     ; B570 00                       .
        brk                                     ; B571 00                       .
        .byte   $2F                             ; B572 2F                       /
        php                                     ; B573 08                       .
        and     ($21,x)                         ; B574 21 21                    !!
        clc                                     ; B576 18                       .
        ora     LB8B8,y                         ; B577 19 B8 B8                 ...
        brk                                     ; B57A 00                       .
        brk                                     ; B57B 00                       .
        ldy     #$B9                            ; B57C A0 B9                    ..
        ldy     #$B1                            ; B57E A0 B1                    ..
        .byte   $BB                             ; B580 BB                       .
        .byte   $BB                             ; B581 BB                       .
        .byte   $BB                             ; B582 BB                       .
        .byte   $BB                             ; B583 BB                       .
        ldy     #$B9                            ; B584 A0 B9                    ..
        ldy     #$B4                            ; B586 A0 B4                    ..
        clv                                     ; B588 B8                       .
        clv                                     ; B589 B8                       .
        lda     $B6,x                           ; B58A B5 B6                    ..
        ldy     #$BC                            ; B58C A0 BC                    ..
        ldy     #$BC                            ; B58E A0 BC                    ..
        lda     $24BE,x                         ; B590 BD BE 24                 ..$
        rol     $BD                             ; B593 26 BD                    &.
        ldx     LBEBD,y                         ; B595 BE BD BE                 ...
        .byte   $33                             ; B598 33                       3
        bit     $37                             ; B599 24 37                    $7
        .byte   $2F                             ; B59B 2F                       /
        .byte   $BB                             ; B59C BB                       .
        .byte   $BB                             ; B59D BB                       .
        php                                     ; B59E 08                       .
        .byte   $2F                             ; B59F 2F                       /
        php                                     ; B5A0 08                       .
        .byte   $34                             ; B5A1 34                       4
        .byte   $02                             ; B5A2 02                       .
        brk                                     ; B5A3 00                       .
        rol     $B9,x                           ; B5A4 36 B9                    6.
        ldx     $B1                             ; B5A6 A6 B1                    ..
        .byte   $02                             ; B5A8 02                       .
        .byte   $BB                             ; B5A9 BB                       .
        .byte   $02                             ; B5AA 02                       .
        .byte   $BB                             ; B5AB BB                       .
        .byte   $02                             ; B5AC 02                       .
        clv                                     ; B5AD B8                       .
        .byte   $02                             ; B5AE 02                       .
        brk                                     ; B5AF 00                       .
        dey                                     ; B5B0 88                       .
        .byte   $82                             ; B5B1 82                       .
        bit     $26                             ; B5B2 24 26                    $&
        .byte   $83                             ; B5B4 83                       .
        .byte   $89                             ; B5B5 89                       .
        bit     $26                             ; B5B6 24 26                    $&
        .byte   $33                             ; B5B8 33                       3
        bmi     LB5F2                           ; B5B9 30 37                    07
        sec                                     ; B5BB 38                       8
        .byte   $2F                             ; B5BC 2F                       /
        bit     L0000                           ; B5BD 24 00                    $.
        brk                                     ; B5BF 00                       .
        rol     $24                             ; B5C0 26 24                    &$
        ldx     $A7                             ; B5C2 A6 A7                    ..
        rol     $24                             ; B5C4 26 24                    &$
        dey                                     ; B5C6 88                       .
        sta     ($26,x)                         ; B5C7 81 26                    .&
        clv                                     ; B5C9 B8                       .
        .byte   $89                             ; B5CA 89                       .
        brk                                     ; B5CB 00                       .
        .byte   $2F                             ; B5CC 2F                       /
        bit     L0000                           ; B5CD 24 00                    $.
        ora     #$33                            ; B5CF 09 33                    .3
        bit     $37                             ; B5D1 24 37                    $7
        dey                                     ; B5D3 88                       .
        tax                                     ; B5D4 AA                       .
        ora     #$AA                            ; B5D5 09 AA                    ..
        ora     #$BB                            ; B5D7 09 BB                    ..
        .byte   $BB                             ; B5D9 BB                       .
        bit     $26                             ; B5DA 24 26                    $&
        rol     $24                             ; B5DC 26 24                    &$
        .byte   $34                             ; B5DE 34                       4
        rol     $26,x                           ; B5DF 36 26                    6&
        bit     L0000                           ; B5E1 24 00                    $.
        ora     #$20                            ; B5E3 09 20                    . 
        and     ($18,x)                         ; B5E5 21 18                    !.
        ora     $26,y                           ; B5E7 19 26 00                 .&.
        .byte   $2F                             ; B5EA 2F                       /
        tax                                     ; B5EB AA                       .
        rol     $AA                             ; B5EC 26 AA                    &.
        .byte   $2F                             ; B5EE 2F                       /
        tax                                     ; B5EF AA                       .
        rol     $AA                             ; B5F0 26 AA                    &.
LB5F2:  brk                                     ; B5F2 00                       .
        tax                                     ; B5F3 AA                       .
        asl     a:$1F,x                         ; B5F4 1E 1F 00                 ...
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
        ora     ($02,x)                         ; B601 01 02                    ..
        .byte   $03                             ; B603 03                       .
        .byte   $04                             ; B604 04                       .
        ora     L0000                           ; B605 05 00                    ..
        brk                                     ; B607 00                       .
        asl     $07                             ; B608 06 07                    ..
        php                                     ; B60A 08                       .
        ora     #$0A                            ; B60B 09 0A                    ..
        .byte   $07                             ; B60D 07                       .
        php                                     ; B60E 08                       .
        asl     $0B                             ; B60F 06 0B                    ..
        .byte   $0C                             ; B611 0C                       .
        ora     $0F0E                           ; B612 0D 0E 0F                 ...
        bpl     LB628                           ; B615 10 11                    ..
        .byte   $0B                             ; B617 0B                       .
        .byte   $12                             ; B618 12                       .
        .byte   $13                             ; B619 13                       .
        .byte   $14                             ; B61A 14                       .
        ora     $16,x                           ; B61B 15 16                    ..
        .byte   $17                             ; B61D 17                       .
        clc                                     ; B61E 18                       .
        .byte   $12                             ; B61F 12                       .
        ora     $1A0C,y                         ; B620 19 0C 1A                 ...
        .byte   $1B                             ; B623 1B                       .
        .byte   $1C                             ; B624 1C                       .
        ora     $1911,x                         ; B625 1D 11 19                 ...
LB628:  asl     $1F13,x                         ; B628 1E 13 1F                 ...
        jsr     L201F                           ; B62B 20 1F 20                  . 
        clc                                     ; B62E 18                       .
        asl     $2221,x                         ; B62F 1E 21 22                 .!"
        ora     $23                             ; B632 05 23                    .#
        and     ($22,x)                         ; B634 21 22                    !"
        ora     $23                             ; B636 05 23                    .#
        .byte   $02                             ; B638 02                       .
        and     ($22,x)                         ; B639 21 22                    !"
        ora     L0000                           ; B63B 05 00                    ..
        brk                                     ; B63D 00                       .
        brk                                     ; B63E 00                       .
        brk                                     ; B63F 00                       .
        .byte   $22                             ; B640 22                       "
        .byte   $03                             ; B641 03                       .
        ora     ($02,x)                         ; B642 01 02                    ..
        and     ($24,x)                         ; B644 21 24                    !$
        and     ($22,x)                         ; B646 21 22                    !"
        .byte   $02                             ; B648 02                       .
        .byte   $03                             ; B649 03                       .
        brk                                     ; B64A 00                       .
        brk                                     ; B64B 00                       .
        .byte   $02                             ; B64C 02                       .
        and     ($22,x)                         ; B64D 21 22                    !"
        and     $02                             ; B64F 25 02                    %.
        rol     $27                             ; B651 26 27                    &'
        plp                                     ; B653 28                       (
        and     #$2A                            ; B654 29 2A                    )*
        plp                                     ; B656 28                       (
        brk                                     ; B657 00                       .
        .byte   $22                             ; B658 22                       "
        .byte   $2B                             ; B659 2B                       +
        bit     $2E2D                           ; B65A 2C 2D 2E                 ,-.
        .byte   $2F                             ; B65D 2F                       /
        and     $0230                           ; B65E 2D 30 02                 -0.
        ora     #$31                            ; B661 09 31                    .1
        .byte   $32                             ; B663 32                       2
        .byte   $33                             ; B664 33                       3
        .byte   $34                             ; B665 34                       4
        .byte   $32                             ; B666 32                       2
        ora     ($24,x)                         ; B667 01 24                    .$
        and     $36,x                           ; B669 35 36                    56
        .byte   $37                             ; B66B 37                       7
        sec                                     ; B66C 38                       8
        and     $37,y                           ; B66D 39 37 00                 97.
        and     ($22,x)                         ; B670 21 22                    !"
        and     $3A                             ; B672 25 3A                    %:
        .byte   $3B                             ; B674 3B                       ;
        and     $21                             ; B675 25 21                    %!
        .byte   $22                             ; B677 22                       "
        brk                                     ; B678 00                       .
        brk                                     ; B679 00                       .
        .byte   $02                             ; B67A 02                       .
        .byte   $03                             ; B67B 03                       .
        .byte   $04                             ; B67C 04                       .
        ora     L0000                           ; B67D 05 00                    ..
        brk                                     ; B67F 00                       .
        asl     $05                             ; B680 06 05                    ..
        brk                                     ; B682 00                       .
        bmi     LB685                           ; B683 30 00                    0.
LB685:  ora     ($02,x)                         ; B685 01 02                    ..
        and     ($06,x)                         ; B687 21 06                    !.
        .byte   $13                             ; B689 13                       .
        clc                                     ; B68A 18                       .
        ora     $30,x                           ; B68B 15 30                    .0
        php                                     ; B68D 08                       .
        .byte   $07                             ; B68E 07                       .
        .byte   $3C                             ; B68F 3C                       <
        .byte   $0B                             ; B690 0B                       .
        jsr     L3D1F                           ; B691 20 1F 3D                  .=
        clc                                     ; B694 18                       .
        .byte   $1F                             ; B695 1F                       .
        jsr     L193D                           ; B696 20 3D 19                  =.
        rol     $3F3F,x                         ; B699 3E 3F 3F                 >??
        .byte   $3F                             ; B69C 3F                       ?
        .byte   $3F                             ; B69D 3F                       ?
        rol     $0640,x                         ; B69E 3E 40 06                 >@.
        rol     $3F3F,x                         ; B6A1 3E 3F 3F                 >??
        eor     ($05,x)                         ; B6A4 41 05                    A.
        .byte   $42                             ; B6A6 42                       B
        rol     $1E,x                           ; B6A7 36 1E                    6.
        ora     $1A1A,x                         ; B6A9 1D 1A 1A                 ...
        and     ($22,x)                         ; B6AC 21 22                    !"
        .byte   $42                             ; B6AE 42                       B
        rol     $22,x                           ; B6AF 36 22                    6"
        .byte   $43                             ; B6B1 43                       C
        .byte   $11                             ; B6B2 11                       .
LB6B3:  ora     ($25),y                         ; B6B3 11 25                    .%
        and     ($22,x)                         ; B6B5 21 22                    !"
        ora     $02                             ; B6B7 05 02                    ..
        .byte   $03                             ; B6B9 03                       .
        brk                                     ; B6BA 00                       .
        brk                                     ; B6BB 00                       .
        brk                                     ; B6BC 00                       .
        brk                                     ; B6BD 00                       .
        brk                                     ; B6BE 00                       .
        brk                                     ; B6BF 00                       .
        .byte   $22                             ; B6C0 22                       "
        and     ($24,x)                         ; B6C1 21 24                    !$
        and     ($22,x)                         ; B6C3 21 22                    !"
        ora     L0000                           ; B6C5 05 00                    ..
        brk                                     ; B6C7 00                       .
        brk                                     ; B6C8 00                       .
        .byte   $02                             ; B6C9 02                       .
        clc                                     ; B6CA 18                       .
        .byte   $13                             ; B6CB 13                       .
        .byte   $13                             ; B6CC 13                       .
        clc                                     ; B6CD 18                       .
        ora     L0000                           ; B6CE 05 00                    ..
        clc                                     ; B6D0 18                       .
        clc                                     ; B6D1 18                       .
        .byte   $1F                             ; B6D2 1F                       .
        jsr     L1F20                           ; B6D3 20 20 1F                   .
        clc                                     ; B6D6 18                       .
        .byte   $13                             ; B6D7 13                       .
        .byte   $44                             ; B6D8 44                       D
        .byte   $44                             ; B6D9 44                       D
        eor     $46                             ; B6DA 45 46                    EF
        rol     $3F3F,x                         ; B6DC 3E 3F 3F                 >??
        rol     $4747,x                         ; B6DF 3E 47 47                 >GG
        rol     a                               ; B6E2 2A                       *
        pha                                     ; B6E3 48                       H
        rol     $3F3F,x                         ; B6E4 3E 3F 3F                 >??
        rol     $3939,x                         ; B6E7 3E 39 39                 >99
        ora     $42                             ; B6EA 05 42                    .B
        rol     $3F3F,x                         ; B6EC 3E 3F 3F                 >??
        rol     $2123,x                         ; B6EF 3E 23 21                 >#!
        .byte   $22                             ; B6F2 22                       "
        eor     #$0C                            ; B6F3 49 0C                    I.
        ora     ($11),y                         ; B6F5 11 11                    ..
        lsr     a                               ; B6F7 4A                       J
        brk                                     ; B6F8 00                       .
        brk                                     ; B6F9 00                       .
        brk                                     ; B6FA 00                       .
        brk                                     ; B6FB 00                       .
        brk                                     ; B6FC 00                       .
        brk                                     ; B6FD 00                       .
        brk                                     ; B6FE 00                       .
        brk                                     ; B6FF 00                       .
        brk                                     ; B700 00                       .
        ora     (L0000,x)                       ; B701 01 00                    ..
        .byte   $02                             ; B703 02                       .
        .byte   $4B                             ; B704 4B                       K
        and     $4C                             ; B705 25 4C                    %L
        ora     (L0000,x)                       ; B707 01 00                    ..
        brk                                     ; B709 00                       .
        ora     (L0000,x)                       ; B70A 01 00                    ..
        eor     $2102                           ; B70C 4D 02 21                 M.!
        bit     $27                             ; B70F 24 27                    $'
        lsr     $324F                           ; B711 4E 4F 32                 NO2
        .byte   $02                             ; B714 02                       .
        and     ($24,x)                         ; B715 21 24                    !$
        and     ($36,x)                         ; B717 21 36                    !6
        rol     a                               ; B719 2A                       *
        rol     a                               ; B71A 2A                       *
        bvc     LB76E                           ; B71B 50 51                    PQ
        .byte   $52                             ; B71D 52                       R
        .byte   $52                             ; B71E 52                       R
        bvc     LB757                           ; B71F 50 36                    P6
        rol     a                               ; B721 2A                       *
        rol     a                               ; B722 2A                       *
        .byte   $53                             ; B723 53                       S
        .byte   $54                             ; B724 54                       T
        .byte   $47                             ; B725 47                       G
        .byte   $47                             ; B726 47                       G
        .byte   $53                             ; B727 53                       S
        rol     $39,x                           ; B728 36 39                    69
        eor     $39,x                           ; B72A 55 39                    U9
        .byte   $54                             ; B72C 54                       T
        and     $5539,y                         ; B72D 39 39 55                 99U
        and     ($22,x)                         ; B730 21 22                    !"
        and     ($24,x)                         ; B732 21 24                    !$
        and     $21                             ; B734 25 21                    %!
        .byte   $22                             ; B736 22                       "
        ora     L0000                           ; B737 05 00                    ..
        brk                                     ; B739 00                       .
        brk                                     ; B73A 00                       .
        brk                                     ; B73B 00                       .
        brk                                     ; B73C 00                       .
        brk                                     ; B73D 00                       .
        brk                                     ; B73E 00                       .
        brk                                     ; B73F 00                       .
        brk                                     ; B740 00                       .
        brk                                     ; B741 00                       .
        bmi     LB744                           ; B742 30 00                    0.
LB744:  brk                                     ; B744 00                       .
        brk                                     ; B745 00                       .
        brk                                     ; B746 00                       .
        bmi     LB76E                           ; B747 30 25                    0%
        clc                                     ; B749 18                       .
        clc                                     ; B74A 18                       .
        clc                                     ; B74B 18                       .
        .byte   $13                             ; B74C 13                       .
        clc                                     ; B74D 18                       .
        clc                                     ; B74E 18                       .
        ora     $24                             ; B74F 05 24                    .$
        lsr     $56,x                           ; B751 56 56                    VV
        lsr     $57,x                           ; B753 56 57                    VW
        cli                                     ; B755 58                       X
        .byte   $56                             ; B756 56                       V
LB757:  and     ($51,x)                         ; B757 21 51                    !Q
        .byte   $52                             ; B759 52                       R
        .byte   $52                             ; B75A 52                       R
        rol     a                               ; B75B 2A                       *
        pha                                     ; B75C 48                       H
        eor     $052A,y                         ; B75D 59 2A 05                 Y*.
        .byte   $54                             ; B760 54                       T
        .byte   $47                             ; B761 47                       G
        .byte   $47                             ; B762 47                       G
        rol     a                               ; B763 2A                       *
        pha                                     ; B764 48                       H
        eor     $212A,y                         ; B765 59 2A 21                 Y*!
        .byte   $54                             ; B768 54                       T
        and     $3939,y                         ; B769 39 39 39                 999
        pha                                     ; B76C 48                       H
        .byte   $5A                             ; B76D 5A                       Z
LB76E:  and     $025B,y                         ; B76E 39 5B 02                 9[.
        and     ($24,x)                         ; B771 21 24                    !$
        and     ($24,x)                         ; B773 21 24                    !$
        and     $5C                             ; B775 25 5C                    %\
        and     (L0000,x)                       ; B777 21 00                    !.
        brk                                     ; B779 00                       .
        brk                                     ; B77A 00                       .
        bmi     LB77D                           ; B77B 30 00                    0.
LB77D:  .byte   $02                             ; B77D 02                       .
        eor     $2105,x                         ; B77E 5D 05 21                 ].!
        bit     $33                             ; B781 24 33                    $3
        .byte   $4F                             ; B783 4F                       O
        lsr     $2A5F,x                         ; B784 5E 5F 2A                 ^_*
        and     ($22,x)                         ; B787 21 22                    !"
        and     $3939,y                         ; B789 39 39 39                 999
        pha                                     ; B78C 48                       H
        .byte   $5A                             ; B78D 5A                       Z
        and     $0221,y                         ; B78E 39 21 02                 9!.
        .byte   $5C                             ; B791 5C                       \
        .byte   $5C                             ; B792 5C                       \
        .byte   $5C                             ; B793 5C                       \
        rts                                     ; B794 60                       `

; ----------------------------------------------------------------------------
        adc     ($62,x)                         ; B795 61 62                    ab
        ora     $24                             ; B797 05 24                    .$
        .byte   $3F                             ; B799 3F                       ?
        .byte   $3F                             ; B79A 3F                       ?
        .byte   $3F                             ; B79B 3F                       ?
        .byte   $63                             ; B79C 63                       c
        .byte   $1F                             ; B79D 1F                       .
        clc                                     ; B79E 18                       .
        and     ($02,x)                         ; B79F 21 02                    !.
        .byte   $1A                             ; B7A1 1A                       .
        .byte   $64                             ; B7A2 64                       d
        .byte   $1A                             ; B7A3 1A                       .
        ora     $5658,x                         ; B7A4 1D 58 56                 .XV
        and     ($24,x)                         ; B7A7 21 24                    !$
        lsr     $65,x                           ; B7A9 56 65                    Ve
        lsr     $57,x                           ; B7AB 56 57                    VW
        eor     $5B2A,y                         ; B7AD 59 2A 5B                 Y*[
        ror     $67                             ; B7B0 66 67                    fg
        and     $4839,y                         ; B7B2 39 39 48                 99H
        .byte   $5A                             ; B7B5 5A                       Z
        and     $0221,y                         ; B7B6 39 21 02                 9!.
        pla                                     ; B7B9 68                       h
        adc     #$69                            ; B7BA 69 69                    ii
        pha                                     ; B7BC 48                       H
        ror     a                               ; B7BD 6A                       j
        adc     #$5B                            ; B7BE 69 5B                    i[
        bit     $6B                             ; B7C0 24 6B                    $k
        jmp     (L606C)                         ; B7C2 6C 6C 60                 ll`

; ----------------------------------------------------------------------------
        adc     $216E                           ; B7C5 6D 6E 21                 mn!
        bit     $6F                             ; B7C8 24 6F                    $o
        bvs     LB83D                           ; B7CA 70 71                    pq
        .byte   $72                             ; B7CC 72                       r
        adc     ($71),y                         ; B7CD 71 71                    qq
        .byte   $5B                             ; B7CF 5B                       [
        .byte   $02                             ; B7D0 02                       .
        .byte   $1F                             ; B7D1 1F                       .
        .byte   $1F                             ; B7D2 1F                       .
        .byte   $73                             ; B7D3 73                       s
        .byte   $74                             ; B7D4 74                       t
        .byte   $73                             ; B7D5 73                       s
        .byte   $73                             ; B7D6 73                       s
        adc     $5B,x                           ; B7D7 75 5B                    u[
        ror     $77,x                           ; B7D9 76 77                    vw
        eor     $7846,x                         ; B7DB 5D 46 78                 ]Fx
        .byte   $77                             ; B7DE 77                       w
        eor     $7924,x                         ; B7DF 5D 24 79                 ]$y
        .byte   $7A                             ; B7E2 7A                       z
        .byte   $7B                             ; B7E3 7B                       {
        pha                                     ; B7E4 48                       H
        .byte   $7C                             ; B7E5 7C                       |
LB7E6:  .byte   $7A                             ; B7E6 7A                       z
        .byte   $7B                             ; B7E7 7B                       {
        bit     $79                             ; B7E8 24 79                    $y
        adc     $487E,x                         ; B7EA 7D 7E 48                 }~H
        .byte   $7F                             ; B7ED 7F                       .
        adc     $027E,x                         ; B7EE 7D 7E 02                 }~.
        .byte   $80                             ; B7F1 80                       .
        sta     ($80,x)                         ; B7F2 81 80                    ..
        pha                                     ; B7F4 48                       H
        .byte   $82                             ; B7F5 82                       .
        sta     ($80,x)                         ; B7F6 81 80                    ..
        bit     $2A                             ; B7F8 24 2A                    $*
        sta     ($2A,x)                         ; B7FA 81 2A                    .*
        pha                                     ; B7FC 48                       H
        eor     $2A81,y                         ; B7FD 59 81 2A                 Y.*
        bit     $5B                             ; B800 24 5B                    $[
        php                                     ; B802 08                       .
        php                                     ; B803 08                       .
        php                                     ; B804 08                       .
        php                                     ; B805 08                       .
        php                                     ; B806 08                       .
        php                                     ; B807 08                       .
        bmi     LB80C                           ; B808 30 02                    0.
        sei                                     ; B80A 78                       x
        .byte   $5D                             ; B80B 5D                       ]
LB80C:  eor     $5D5D,x                         ; B80C 5D 5D 5D                 ]]]
        eor     $8375,x                         ; B80F 5D 75 83                 ]u.
        .byte   $7C                             ; B812 7C                       |
        sty     $84                             ; B813 84 84                    ..
        sta     $84                             ; B815 85 84                    ..
        sty     $5D                             ; B817 84 5D                    .]
        lsr     $7C                             ; B819 46 7C                    F|
        sta     $79                             ; B81B 85 79                    .y
        stx     $79                             ; B81D 86 79                    .y
        sta     $79                             ; B81F 85 79                    .y
        .byte   $87                             ; B821 87                       .
        dey                                     ; B822 88                       .
        stx     $79                             ; B823 86 79                    .y
        adc     $8679,y                         ; B825 79 79 86                 yy.
        sta     $89                             ; B828 85 89                    ..
        txa                                     ; B82A 8A                       .
        adc     $7979,y                         ; B82B 79 79 79                 yyy
        adc     $8B79,y                         ; B82E 79 79 8B                 yy.
        pha                                     ; B831 48                       H
        sty     $8080                           ; B832 8C 80 80                 ...
        .byte   $80                             ; B835 80                       .
        .byte   $80                             ; B836 80                       .
        .byte   $80                             ; B837 80                       .
        rol     a                               ; B838 2A                       *
        pha                                     ; B839 48                       H
        eor     $2A2A,y                         ; B83A 59 2A 2A                 Y**
LB83D:  rol     a                               ; B83D 2A                       *
        rol     a                               ; B83E 2A                       *
        rol     a                               ; B83F 2A                       *
        php                                     ; B840 08                       .
        php                                     ; B841 08                       .
        php                                     ; B842 08                       .
        bmi     LB847                           ; B843 30 02                    0.
        and     ($24,x)                         ; B845 21 24                    !$
LB847:  .byte   $03                             ; B847 03                       .
        eor     $775D,x                         ; B848 5D 5D 77                 ]]w
        sta     $8D8E                           ; B84B 8D 8E 8D                 ...
        stx     $8403                           ; B84E 8E 03 84                 ...
        sty     $8F                             ; B851 84 8F                    ..
        sty     $8F                             ; B853 84 8F                    ..
        sty     $8F                             ; B855 84 8F                    ..
        .byte   $03                             ; B857 03                       .
        adc     $8190,y                         ; B858 79 90 81                 y..
        sta     ($81),y                         ; B85B 91 81                    ..
        sta     ($81),y                         ; B85D 91 81                    ..
        .byte   $03                             ; B85F 03                       .
        adc     $8179,y                         ; B860 79 79 81                 yy.
        bcc     LB7E6                           ; B863 90 81                    ..
        sta     ($81),y                         ; B865 91 81                    ..
        plp                                     ; B867 28                       (
        adc     $8179,y                         ; B868 79 79 81                 yy.
        sta     ($81),y                         ; B86B 91 81                    ..
        .byte   $92                             ; B86D 92                       .
        sta     ($28,x)                         ; B86E 81 28                    .(
        .byte   $80                             ; B870 80                       .
        .byte   $80                             ; B871 80                       .
        sta     ($80,x)                         ; B872 81 80                    ..
        sta     ($80,x)                         ; B874 81 80                    ..
        sta     ($28,x)                         ; B876 81 28                    .(
        rol     a                               ; B878 2A                       *
        rol     a                               ; B879 2A                       *
        sta     ($2A,x)                         ; B87A 81 2A                    .*
        sta     ($2A,x)                         ; B87C 81 2A                    .*
        sta     ($28,x)                         ; B87E 81 28                    .(
        .byte   $93                             ; B880 93                       .
        sty     $95,x                           ; B881 94 95                    ..
        stx     $97,y                           ; B883 96 97                    ..
        stx     $97,y                           ; B885 96 97                    ..
        tya                                     ; B887 98                       .
        .byte   $93                             ; B888 93                       .
        sty     $99,x                           ; B889 94 99                    ..
        sty     $9A,x                           ; B88B 94 9A                    ..
        sty     $9A,x                           ; B88D 94 9A                    ..
        .byte   $9B                             ; B88F 9B                       .
        .byte   $9C                             ; B890 9C                       .
        .byte   $9C                             ; B891 9C                       .
        .byte   $9C                             ; B892 9C                       .
        ror     $9D                             ; B893 66 9D                    f.
        .byte   $9C                             ; B895 9C                       .
        ror     $3A                             ; B896 66 3A                    f:
        .byte   $9E                             ; B898 9E                       .
        stx     $96,y                           ; B899 96 96                    ..
        stx     $97,y                           ; B89B 96 97                    ..
        stx     $97,y                           ; B89D 96 97                    ..
        .byte   $03                             ; B89F 03                       .
        .byte   $3B                             ; B8A0 3B                       ;
        sta     $669C,x                         ; B8A1 9D 9C 66                 ..f
        sta     $9C9C,x                         ; B8A4 9D 9C 9C                 ...
        .byte   $9C                             ; B8A7 9C                       .
        .byte   $04                             ; B8A8 04                       .
        stx     $96,y                           ; B8A9 96 96                    ..
        stx     $97,y                           ; B8AB 96 97                    ..
        stx     $97,y                           ; B8AD 96 97                    ..
        tya                                     ; B8AF 98                       .
        .byte   $22                             ; B8B0 22                       "
LB8B1:  and     ($22,x)                         ; B8B1 21 22                    !"
        and     ($24,x)                         ; B8B3 21 24                    !$
        and     ($24,x)                         ; B8B5 21 24                    !$
        .byte   $3A                             ; B8B7 3A                       :
LB8B8:  brk                                     ; B8B8 00                       .
        brk                                     ; B8B9 00                       .
        brk                                     ; B8BA 00                       .
        brk                                     ; B8BB 00                       .
        brk                                     ; B8BC 00                       .
        brk                                     ; B8BD 00                       .
        .byte   $02                             ; B8BE 02                       .
        .byte   $03                             ; B8BF 03                       .
        sta     $2166,x                         ; B8C0 9D 66 21                 .f!
        bit     $05                             ; B8C3 24 05                    $.
        brk                                     ; B8C5 00                       .
        brk                                     ; B8C6 00                       .
        brk                                     ; B8C7 00                       .
        .byte   $9E                             ; B8C8 9E                       .
        stx     $96,y                           ; B8C9 96 96                    ..
        stx     $9F,y                           ; B8CB 96 9F                    ..
        ldy     #$A0                            ; B8CD A0 A0                    ..
        ldy     #$93                            ; B8CF A0 93                    ..
        sty     $94,x                           ; B8D1 94 94                    ..
        sty     $A1,x                           ; B8D3 94 A1                    ..
        ldx     #$A3                            ; B8D5 A2 A3                    ..
LB8D7:  ldy     $93                             ; B8D7 A4 93                    ..
        sty     $A2,x                           ; B8D9 94 A2                    ..
        lda     $A1                             ; B8DB A5 A1                    ..
        ldy     $A4                             ; B8DD A4 A4                    ..
        ldy     $A6                             ; B8DF A4 A6                    ..
        .byte   $A7                             ; B8E1 A7                       .
        tay                                     ; B8E2 A8                       .
        sty     $A1,x                           ; B8E3 94 A1                    ..
        ldy     $A4                             ; B8E5 A4 A4                    ..
        ldy     $9E                             ; B8E7 A4 9E                    ..
        stx     $99,y                           ; B8E9 96 99                    ..
        sty     $A1,x                           ; B8EB 94 A1                    ..
        ldy     $A4                             ; B8ED A4 A4                    ..
        ldy     $93                             ; B8EF A4 93                    ..
        sty     $03,x                           ; B8F1 94 03                    ..
        .byte   $02                             ; B8F3 02                       .
        and     ($24,x)                         ; B8F4 21 24                    !$
        lda     #$AA                            ; B8F6 A9 AA                    ..
        ldx     $94                             ; B8F8 A6 94                    ..
        .byte   $03                             ; B8FA 03                       .
        brk                                     ; B8FB 00                       .
        bmi     LB8FE                           ; B8FC 30 00                    0.
LB8FE:  bmi     LB900                           ; B8FE 30 00                    0.
LB900:  .byte   $02                             ; B900 02                       .
        .byte   $AB                             ; B901 AB                       .
        sta     $9D66,x                         ; B902 9D 66 9D                 .f.
        ror     $9D                             ; B905 66 9D                    f.
        ror     $AC                             ; B907 66 AC                    f.
        stx     $96,y                           ; B909 96 96                    ..
        stx     $96,y                           ; B90B 96 96                    ..
        .byte   $9F                             ; B90D 9F                       .
        .byte   $9F                             ; B90E 9F                       .
        ldy     #$AD                            ; B90F A0 AD                    ..
        sty     $94,x                           ; B911 94 94                    ..
        sty     $94,x                           ; B913 94 94                    ..
        lda     ($AE,x)                         ; B915 A1 AE                    ..
        .byte   $AF                             ; B917 AF                       .
        lda     $9494                           ; B918 AD 94 94                 ...
        sty     $94,x                           ; B91B 94 94                    ..
        ldx     LB1B0                           ; B91D AE B0 B1                 ...
        lda     $9494                           ; B920 AD 94 94                 ...
        sty     $B2,x                           ; B923 94 B2                    ..
        bcs     LB8D7                           ; B925 B0 B0                    ..
        .byte   $AF                             ; B927 AF                       .
        lda     $9494                           ; B928 AD 94 94                 ...
        lda     #$AA                            ; B92B A9 AA                    ..
        sta     LA966,x                         ; B92D 9D 66 A9                 .f.
        sta     LB366,x                         ; B930 9D 66 B3                 .f.
        and     $B4                             ; B933 25 B4                    %.
        lda     $B6,x                           ; B935 B5 B6                    ..
        and     $02                             ; B937 25 02                    %.
        ldy     $2A,x                           ; B939 B4 2A                    .*
        .byte   $02                             ; B93B 02                       .
        .byte   $B7                             ; B93C B7                       .
        .byte   $02                             ; B93D 02                       .
        .byte   $B7                             ; B93E B7                       .
        .byte   $02                             ; B93F 02                       .
        sta     $9C9C,x                         ; B940 9D 9C 9C                 ...
        ror     $9D                             ; B943 66 9D                    f.
        .byte   $9C                             ; B945 9C                       .
        .byte   $9C                             ; B946 9C                       .
        ror     $A0                             ; B947 66 A0                    f.
        ldy     #$A0                            ; B949 A0 A0                    ..
        ldy     #$A0                            ; B94B A0 A0                    ..
        ldy     #$A0                            ; B94D A0 A0                    ..
        sta     LB8B1,x                         ; B94F 9D B1 B8                 ...
        lda     ($B8),y                         ; B952 B1 B8                    ..
        lda     ($A4),y                         ; B954 B1 A4                    ..
        ldy     $9D                             ; B956 A4 9D                    ..
        clv                                     ; B958 B8                       .
        lda     ($B8),y                         ; B959 B1 B8                    ..
        .byte   $AF                             ; B95B AF                       .
        lda     ($A4),y                         ; B95C B1 A4                    ..
        ldy     $9D                             ; B95E A4 9D                    ..
        lda     ($B8),y                         ; B960 B1 B8                    ..
        .byte   $AF                             ; B962 AF                       .
        lda     ($B9),y                         ; B963 B1 B9                    ..
        ldy     $A4                             ; B965 A4 A4                    ..
        sta     LBBBA,x                         ; B967 9D BA BB                 ...
        lda     #$BC                            ; B96A A9 BC                    ..
        tsx                                     ; B96C BA                       .
        ldy     $BD                             ; B96D A4 BD                    ..
        eor     ($B4,x)                         ; B96F 41 B4                    A.
        .byte   $AB                             ; B971 AB                       .
        lda     $B4,x                           ; B972 B5 B4                    ..
        and     $A4                             ; B974 25 A4                    %.
        sta     LBE66,x                         ; B976 9D 66 BE                 .f.
        brk                                     ; B979 00                       .
        brk                                     ; B97A 00                       .
        .byte   $BE,$02,$A4                     ; B97B BE 02 A4                 ...
        ora     L0000                           ; B97E 05 00                    ..
        ldx     a:$01,y                         ; B980 BE 01 00                 ...
        .byte   $B7                             ; B983 B7                       .
        .byte   $02                             ; B984 02                       .
        ldy     $05                             ; B985 A4 05                    ..
        brk                                     ; B987 00                       .
        .byte   $B7                             ; B988 B7                       .
        sta     $9666,x                         ; B989 9D 66 96                 .f.
        .byte   $9F                             ; B98C 9F                       .
        ldy     $9D                             ; B98D A4 9D                    ..
        ror     $21                             ; B98F 66 21                    f!
        bit     $25                             ; B991 24 25                    $%
        sty     $A1,x                           ; B993 94 A1                    ..
        ldy     $21                             ; B995 A4 21                    .!
        .byte   $22                             ; B997 22                       "
        .byte   $BF                             ; B998 BF                       .
        stx     $96,y                           ; B999 96 96                    ..
        sty     $A1,x                           ; B99B 94 A1                    ..
        ldy     $9D                             ; B99D A4 9D                    ..
        ror     $C0                             ; B99F 66 C0                    f.
        cmp     ($02,x)                         ; B9A1 C1 02                    ..
        sty     $A1,x                           ; B9A3 94 A1                    ..
        ldy     $21                             ; B9A5 A4 21                    .!
        bit     $BF                             ; B9A7 24 BF                    $.
        cpy     #$C2                            ; B9A9 C0 C2                    ..
        sty     $A1,x                           ; B9AB 94 A1                    ..
        ora     L0000                           ; B9AD 05 00                    ..
        .byte   $C3                             ; B9AF C3                       .
        cpy     #$05                            ; B9B0 C0 05                    ..
        .byte   $02                             ; B9B2 02                       .
        sty     $A1,x                           ; B9B3 94 A1                    ..
        ldy     #$C4                            ; B9B5 A0 C4                    ..
        cpy     #$00                            ; B9B7 C0 00                    ..
        brk                                     ; B9B9 00                       .
        .byte   $02                             ; B9BA 02                       .
        sty     $A1,x                           ; B9BB 94 A1                    ..
        ldy     $05                             ; B9BD A4 05                    ..
        brk                                     ; B9BF 00                       .
        .byte   $02                             ; B9C0 02                       .
        and     ($24,x)                         ; B9C1 21 24                    !$
        sty     $A1,x                           ; B9C3 94 A1                    ..
        ldy     $05                             ; B9C5 A4 05                    ..
        .byte   $C3                             ; B9C7 C3                       .
        brk                                     ; B9C8 00                       .
        .byte   $C3                             ; B9C9 C3                       .
        .byte   $02                             ; B9CA 02                       .
        sty     $A1,x                           ; B9CB 94 A1                    ..
        ldy     $C4                             ; B9CD A4 C4                    ..
        cpy     #$C4                            ; B9CF C0 C4                    ..
        cpy     #$C2                            ; B9D1 C0 C2                    ..
        sty     $A1,x                           ; B9D3 94 A1                    ..
        ldy     $05                             ; B9D5 A4 05                    ..
        cmp     $AC                             ; B9D7 C5 AC                    ..
        ora     $02                             ; B9D9 05 02                    ..
        sty     $25,x                           ; B9DB 94 25                    .%
        dec     $24                             ; B9DD C6 24                    .$
        .byte   $C7                             ; B9DF C7                       .
        lda     $669D                           ; B9E0 AD 9D 66                 ..f
        sty     $C6,x                           ; B9E3 94 C6                    ..
        iny                                     ; B9E5 C8                       .
        cpy     $C0                             ; B9E6 C4 C0                    ..
        lda     $669D                           ; B9E8 AD 9D 66                 ..f
        sty     $C9,x                           ; B9EB 94 C9                    ..
        ldy     #$A0                            ; B9ED A0 A0                    ..
        ldy     #$AD                            ; B9EF A0 AD                    ..
        ora     $02                             ; B9F1 05 02                    ..
        sty     $A1,x                           ; B9F3 94 A1                    ..
        ldy     $C6                             ; B9F5 A4 C6                    ..
        bit     $A1                             ; B9F7 24 A1                    $.
        ora     L0000                           ; B9F9 05 00                    ..
        brk                                     ; B9FB 00                       .
        brk                                     ; B9FC 00                       .
        brk                                     ; B9FD 00                       .
        brk                                     ; B9FE 00                       .
        brk                                     ; B9FF 00                       .
        brk                                     ; BA00 00                       .
        brk                                     ; BA01 00                       .
        brk                                     ; BA02 00                       .
        .byte   $12                             ; BA03 12                       .
        brk                                     ; BA04 00                       .
        .byte   $12                             ; BA05 12                       .
        brk                                     ; BA06 00                       .
        .byte   $12                             ; BA07 12                       .
        dex                                     ; BA08 CA                       .
        .byte   $CB                             ; BA09 CB                       .
        ldy     $9619                           ; BA0A AC 19 96                 ...
        ora     $1996,y                         ; BA0D 19 96 19                 ...
        ror     $CC                             ; BA10 66 CC                    f.
        lda     $9406                           ; BA12 AD 06 94                 ...
        asl     $94                             ; BA15 06 94                    ..
        asl     L0000                           ; BA17 06 00                    ..
        cpy     $06AD                           ; BA19 CC AD 06                 ...
        sty     $06,x                           ; BA1C 94 06                    ..
        sty     $06,x                           ; BA1E 94 06                    ..
        dex                                     ; BA20 CA                       .
        cpy     $96AD                           ; BA21 CC AD 96                 ...
        sty     $96,x                           ; BA24 94 96                    ..
        sty     $96,x                           ; BA26 94 96                    ..
        ldy     #$CD                            ; BA28 A0 CD                    ..
        lda     $941E                           ; BA2A AD 1E 94                 ...
        asl     $1E94,x                         ; BA2D 1E 94 1E                 ...
        ora     L0000                           ; BA30 05 00                    ..
        ora     (L0000,x)                       ; BA32 01 00                    ..
        brk                                     ; BA34 00                       .
        brk                                     ; BA35 00                       .
        brk                                     ; BA36 00                       .
        brk                                     ; BA37 00                       .
        brk                                     ; BA38 00                       .
        brk                                     ; BA39 00                       .
        brk                                     ; BA3A 00                       .
        brk                                     ; BA3B 00                       .
        brk                                     ; BA3C 00                       .
        brk                                     ; BA3D 00                       .
        brk                                     ; BA3E 00                       .
        brk                                     ; BA3F 00                       .
        brk                                     ; BA40 00                       .
        .byte   $12                             ; BA41 12                       .
        dec     $24                             ; BA42 C6 24                    .$
        ora     L0000                           ; BA44 05 00                    ..
        .byte   $04                             ; BA46 04                       .
        and     ($96,x)                         ; BA47 21 96                    !.
        ora     $0596,y                         ; BA49 19 96 05                 ...
        brk                                     ; BA4C 00                       .
        ora     ($04,x)                         ; BA4D 01 04                    ..
        ora     $94                             ; BA4F 05 94                    ..
        asl     $94                             ; BA51 06 94                    ..
        and     $C6                             ; BA53 25 C6                    %.
        bit     $04                             ; BA55 24 04                    $.
        .byte   $5B                             ; BA57 5B                       [
        sty     $06,x                           ; BA58 94 06                    ..
        sty     $21,x                           ; BA5A 94 21                    .!
        bit     $05                             ; BA5C 24 05                    $.
        .byte   $04                             ; BA5E 04                       .
        and     ($94,x)                         ; BA5F 21 94                    !.
        stx     $94,y                           ; BA61 96 94                    ..
        stx     $CE,y                           ; BA63 96 CE                    ..
        rol     a                               ; BA65 2A                       *
        .byte   $CF                             ; BA66 CF                       .
        and     ($94,x)                         ; BA67 21 94                    !.
        asl     $1E94,x                         ; BA69 1E 94 1E                 ...
        bne     LBA98                           ; BA6C D0 2A                    .*
        .byte   $CF                             ; BA6E CF                       .
        and     (L0000,x)                       ; BA6F 21 00                    !.
        brk                                     ; BA71 00                       .
LBA72:  ora     ($02,x)                         ; BA72 01 02                    ..
        cmp     ($D2),y                         ; BA74 D1 D2                    ..
        rol     a                               ; BA76 2A                       *
        and     (L0000,x)                       ; BA77 21 00                    !.
        brk                                     ; BA79 00                       .
        brk                                     ; BA7A 00                       .
        brk                                     ; BA7B 00                       .
        brk                                     ; BA7C 00                       .
        and     #$2A                            ; BA7D 29 2A                    )*
        and     ($41,x)                         ; BA7F 21 41                    !A
        .byte   $03                             ; BA81 03                       .
        .byte   $02                             ; BA82 02                       .
        dec     $C8                             ; BA83 C6 C8                    ..
        ora     $BE                             ; BA85 05 BE                    ..
        ldx     $9502,y                         ; BA87 BE 02 95                 ...
        stx     $98,y                           ; BA8A 96 98                    ..
        brk                                     ; BA8C 00                       .
        brk                                     ; BA8D 00                       .
        ldx     $669D,y                         ; BA8E BE 9D 66                 ..f
        sta     $D394,y                         ; BA91 99 94 D3                 ...
        dec     $9D2A                           ; BA94 CE 2A 9D                 .*.
        .byte   $66                             ; BA97 66                       f
LBA98:  ror     $99                             ; BA98 66 99                    f.
        sty     $94,x                           ; BA9A 94 94                    ..
        bne     LBA72                           ; BA9C D0 D4                    ..
        sta     $0266,x                         ; BA9E 9D 66 02                 .f.
        .byte   $99,$94,$A7                     ; BAA1 99 94 A7                 ...
        cmp     $D6,x                           ; BAA4 D5 D6                    ..
        .byte   $D7                             ; BAA6 D7                       .
        cld                                     ; BAA7 D8                       .
        .byte   $22                             ; BAA8 22                       "
        cmp     $9694,y                         ; BAA9 D9 94 96                 ...
        dec     $2A2A                           ; BAAC CE 2A 2A                 .**
        sta     $2421,x                         ; BAAF 9D 21 24                 .!$
        .byte   $DA                             ; BAB2 DA                       .
        .byte   $DB                             ; BAB3 DB                       .
        cmp     ($D4),y                         ; BAB4 D1 D4                    ..
LBAB6:  .byte   $DC                             ; BAB6 DC                       .
        .byte   $05                             ; BAB7 05                       .
LBAB8:  brk                                     ; BAB8 00                       .
        .byte   $0B                             ; BAB9 0B                       .
        brk                                     ; BABA 00                       .
        brk                                     ; BABB 00                       .
        brk                                     ; BABC 00                       .
        brk                                     ; BABD 00                       .
        .byte   $04                             ; BABE 04                       .
        ora     $21                             ; BABF 05 21                    .!
        .byte   $22                             ; BAC1 22                       "
        dec     $C8                             ; BAC2 C6 C8                    ..
        and     ($24,x)                         ; BAC4 21 24                    !$
        cmp     $22DD,x                         ; BAC6 DD DD 22                 .."
        rol     a                               ; BAC9 2A                       *
        dec     $CE2A                           ; BACA CE 2A CE                 .*.
        rol     a                               ; BACD 2A                       *
        dec     $022A                           ; BACE CE 2A 02                 .*.
        dec     $DEDF,x                         ; BAD1 DE DF DE                 ...
        bne     LBAB6                           ; BAD4 D0 E0                    ..
        bne     LBAB8                           ; BAD6 D0 E0                    ..
        .byte   $02                             ; BAD8 02                       .
        cpx     #$D0                            ; BAD9 E0 D0                    ..
        cpx     #$E1                            ; BADB E0 E1                    ..
        .byte   $E2                             ; BADD E2                       .
        sbc     ($E2,x)                         ; BADE E1 E2                    ..
        ror     $E2                             ; BAE0 66 E2                    f.
        sbc     ($E2,x)                         ; BAE2 E1 E2                    ..
        .byte   $E3                             ; BAE4 E3                       .
        cpx     $21                             ; BAE5 E4 21                    .!
        bit     $02                             ; BAE7 24 02                    $.
        sbc     $E3                             ; BAE9 E5 E3                    ..
        cpx     $21                             ; BAEB E4 21                    .!
        .byte   $22                             ; BAED 22                       "
        ora     L0000                           ; BAEE 05 00                    ..
        eor     ($3A,x)                         ; BAF0 41 3A                    A:
        brk                                     ; BAF2 00                       .
        brk                                     ; BAF3 00                       .
        ora     (L0000,x)                       ; BAF4 01 00                    ..
        inc     $9D                             ; BAF6 E6 9D                    ..
        .byte   $02                             ; BAF8 02                       .
        .byte   $03                             ; BAF9 03                       .
        brk                                     ; BAFA 00                       .
        brk                                     ; BAFB 00                       .
        brk                                     ; BAFC 00                       .
        brk                                     ; BAFD 00                       .
        ldx     $DD00,y                         ; BAFE BE 00 DD                 ...
        cmp     $DDDD,x                         ; BB01 DD DD DD                 ...
        .byte   $DD                             ; BB04 DD                       .
        .byte   $DD                             ; BB05 DD                       .
LBB06:  .byte   $DD                             ; BB06 DD                       .
LBB07:  cmp     $2ACE,x                         ; BB07 DD CE 2A                 ..*
        dec     $CE2A                           ; BB0A CE 2A CE                 .*.
        rol     a                               ; BB0D 2A                       *
        dec     $D02A                           ; BB0E CE 2A D0                 .*.
        cpx     #$D0                            ; BB11 E0 D0                    ..
        cpx     #$D0                            ; BB13 E0 D0                    ..
        .byte   $E0                             ; BB15 E0                       .
LBB16:  .byte   $D0,$E7                    ; BB16 D0 E7   (branch out of range for ca65: target has no local label)
        .byte   $DF                             ; BB18 DF                       .
        dec     $E8DF,x                         ; BB19 DE DF E8                 ...
        sbc     #$DE                            ; BB1C E9 DE                    ..
        .byte   $DF                             ; BB1E DF                       .
        .byte   $03                             ; BB1F 03                       .
        .byte   $02                             ; BB20 02                       .
        cpx     #$D0                            ; BB21 E0 D0                    ..
        nop                                     ; BB23 EA                       .
        bne     LBB06                           ; BB24 D0 E0                    ..
        bne     LBB2B                           ; BB26 D0 03                    ..
        .byte   $02                             ; BB28 02                       .
        .byte   $DE                             ; BB29 DE                       .
        .byte   $DF                             ; BB2A DF                       .
LBB2B:  .byte   $EB                             ; BB2B EB                       .
        .byte   $DF                             ; BB2C DF                       .
        dec     $EDEC,x                         ; BB2D DE EC ED                 ...
        ror     $E0                             ; BB30 66 E0                    f.
        ora     $29                             ; BB32 05 29                    .)
LBB34:  bne     LBB16                           ; BB34 D0 E0                    ..
LBB36:  ora     $02                             ; BB36 05 02                    ..
        .byte   $02                             ; BB38 02                       .
        rol     a                               ; BB39 2A                       *
        ora     $29                             ; BB3A 05 29                    .)
        bne     LBB68                           ; BB3C D0 2A                    .*
        ora     $E6                             ; BB3E 05 E6                    ..
        cmp     $DDDD,x                         ; BB40 DD DD DD                 ...
        dec     $C8                             ; BB43 C6 C8                    ..
        dec     $C8                             ; BB45 C6 C8                    ..
        inc     $2ACE                           ; BB47 EE CE 2A                 ..*
        dec     $F0EF                           ; BB4A CE EF F0                 ...
        .byte   $4F                             ; BB4D 4F                       O
        beq     LBB07                           ; BB4E F0 B7                    ..
        cmp     ($D2),y                         ; BB50 D1 D2                    ..
        bne     LBB34                           ; BB52 D0 E0                    ..
        bne     LBB36                           ; BB54 D0 E0                    ..
        lda     $F1D6                           ; BB56 AD D6 F1                 ...
        .byte   $F2                             ; BB59 F2                       .
        .byte   $DF                             ; BB5A DF                       .
        dec     $DEDF,x                         ; BB5B DE DF DE                 ...
        lda     a:$D6                           ; BB5E AD D6 00                 ...
        and     #$D0                            ; BB61 29 D0                    ).
        cpx     #$D0                            ; BB63 E0 D0                    ..
        cpx     #$AD                            ; BB65 E0 AD                    ..
        .byte   $F3                             ; BB67 F3                       .
LBB68:  .byte   $F4                             ; BB68 F4                       .
        .byte   $F2                             ; BB69 F2                       .
        .byte   $DF                             ; BB6A DF                       .
        dec     $DEDF,x                         ; BB6B DE DF DE                 ...
        lda     LBEF5                           ; BB6E AD F5 BE                 ...
        rol     $F6D1                           ; BB71 2E D1 F6                 ...
        sta     $C666,x                         ; BB74 9D 66 C6                 .f.
        iny                                     ; BB77 C8                       .
        ldx     $0200,y                         ; BB78 BE 00 02                 ...
        sta     $9D66,x                         ; BB7B 9D 66 9D                 .f.
        ror     $05                             ; BB7E 66 05                    f.
        ror     $EE                             ; BB80 66 EE                    f.
        ror     $C5                             ; BB82 66 C5                    f.
        ror     $C6                             ; BB84 66 C6                    f.
        iny                                     ; BB86 C8                       .
        .byte   $AB                             ; BB87 AB                       .
        ldx     a:$B7,y                         ; BB88 BE B7 00                 ...
        ldx     $0100,y                         ; BB8B BE 00 01                 ...
        brk                                     ; BB8E 00                       .
        inc     $BE                             ; BB8F E6 BE                    ..
        brk                                     ; BB91 00                       .
        .byte   $F7                             ; BB92 F7                       .
        .byte   $B7                             ; BB93 B7                       .
        ora     ($02,x)                         ; BB94 01 02                    ..
        dec     $B7,x                           ; BB96 D6 B7                    ..
        .byte   $B7                             ; BB98 B7                       .
        brk                                     ; BB99 00                       .
        brk                                     ; BB9A 00                       .
        brk                                     ; BB9B 00                       .
        brk                                     ; BB9C 00                       .
        brk                                     ; BB9D 00                       .
        brk                                     ; BB9E 00                       .
        brk                                     ; BB9F 00                       .
        .byte   $4F                             ; BBA0 4F                       O
        .byte   $4F                             ; BBA1 4F                       O
        .byte   $4F                             ; BBA2 4F                       O
        .byte   $4F                             ; BBA3 4F                       O
        .byte   $4F                             ; BBA4 4F                       O
        .byte   $4F                             ; BBA5 4F                       O
        .byte   $4F                             ; BBA6 4F                       O
        sed                                     ; BBA7 F8                       .
        sty     $94,x                           ; BBA8 94 94                    ..
        txs                                     ; BBAA 9A                       .
        sty     $94,x                           ; BBAB 94 94                    ..
        sty     $9A,x                           ; BBAD 94 9A                    ..
        sbc     $21,x                           ; BBAF F5 21                    .!
        .byte   $22                             ; BBB1 22                       "
        and     ($22,x)                         ; BBB2 21 22                    !"
        and     ($22,x)                         ; BBB4 21 22                    !"
        sbc     $DD,y                           ; BBB6 F9 DD 00                 ...
        brk                                     ; BBB9 00                       .
LBBBA:  brk                                     ; BBBA 00                       .
        brk                                     ; BBBB 00                       .
        brk                                     ; BBBC 00                       .
        brk                                     ; BBBD 00                       .
        brk                                     ; BBBE 00                       .
        .byte   $02                             ; BBBF 02                       .
        sbc     $DDDD,y                         ; BBC0 F9 DD DD                 ...
        cmp     $DDDD,x                         ; BBC3 DD DD DD                 ...
        cmp     $FADD,x                         ; BBC6 DD DD FA                 ...
        stx     $97,y                           ; BBC9 96 97                    ..
        stx     $96,y                           ; BBCB 96 96                    ..
        .byte   $97                             ; BBCD 97                       .
        stx     $98,y                           ; BBCE 96 98                    ..
        .byte   $FB                             ; BBD0 FB                       .
        sty     $9A,x                           ; BBD1 94 9A                    ..
        sty     $94,x                           ; BBD3 94 94                    ..
        txs                                     ; BBD5 9A                       .
        sty     $9B,x                           ; BBD6 94 9B                    ..
        .byte   $FB                             ; BBD8 FB                       .
        sty     $9A,x                           ; BBD9 94 9A                    ..
        sty     $94,x                           ; BBDB 94 94                    ..
        txs                                     ; BBDD 9A                       .
        sty     $9B,x                           ; BBDE 94 9B                    ..
        .byte   $FC                             ; BBE0 FC                       .
        sty     $9A,x                           ; BBE1 94 9A                    ..
        sty     $94,x                           ; BBE3 94 94                    ..
        txs                                     ; BBE5 9A                       .
        sty     $9B,x                           ; BBE6 94 9B                    ..
        sty     $94,x                           ; BBE8 94 94                    ..
        txs                                     ; BBEA 9A                       .
        sty     $94,x                           ; BBEB 94 94                    ..
        txs                                     ; BBED 9A                       .
        sty     $9B,x                           ; BBEE 94 9B                    ..
        cmp     $DDDD,x                         ; BBF0 DD DD DD                 ...
        cmp     $DDDD,x                         ; BBF3 DD DD DD                 ...
        cmp     $FDDD,x                         ; BBF6 DD DD FD                 ...
        sbc     $FDFD,x                         ; BBF9 FD FD FD                 ...
        sbc     $FDFD,x                         ; BBFC FD FD FD                 ...
        sbc     $2A2A,x                         ; BBFF FD 2A 2A                 .**
        rol     a                               ; BC02 2A                       *
        rol     a                               ; BC03 2A                       *
        rol     a                               ; BC04 2A                       *
        rol     a                               ; BC05 2A                       *
        rol     a                               ; BC06 2A                       *
        rol     a                               ; BC07 2A                       *
        rol     a                               ; BC08 2A                       *
        rol     a                               ; BC09 2A                       *
        rol     a                               ; BC0A 2A                       *
        rol     a                               ; BC0B 2A                       *
        rol     a                               ; BC0C 2A                       *
        rol     a                               ; BC0D 2A                       *
        rol     a                               ; BC0E 2A                       *
        rol     a                               ; BC0F 2A                       *
        rol     a                               ; BC10 2A                       *
        rol     a                               ; BC11 2A                       *
        rol     a                               ; BC12 2A                       *
        rol     a                               ; BC13 2A                       *
        rol     a                               ; BC14 2A                       *
        rol     a                               ; BC15 2A                       *
        rol     a                               ; BC16 2A                       *
        rol     a                               ; BC17 2A                       *
        rol     a                               ; BC18 2A                       *
        rol     a                               ; BC19 2A                       *
        rol     a                               ; BC1A 2A                       *
        rol     a                               ; BC1B 2A                       *
        rol     a                               ; BC1C 2A                       *
        rol     a                               ; BC1D 2A                       *
        rol     a                               ; BC1E 2A                       *
        rol     a                               ; BC1F 2A                       *
        rol     a                               ; BC20 2A                       *
        rol     a                               ; BC21 2A                       *
        rol     a                               ; BC22 2A                       *
        rol     a                               ; BC23 2A                       *
        rol     a                               ; BC24 2A                       *
        rol     a                               ; BC25 2A                       *
        rol     a                               ; BC26 2A                       *
        rol     a                               ; BC27 2A                       *
        rol     a                               ; BC28 2A                       *
        rol     a                               ; BC29 2A                       *
        rol     a                               ; BC2A 2A                       *
        rol     a                               ; BC2B 2A                       *
        rol     a                               ; BC2C 2A                       *
        rol     a                               ; BC2D 2A                       *
        rol     a                               ; BC2E 2A                       *
        rol     a                               ; BC2F 2A                       *
        rol     a                               ; BC30 2A                       *
        rol     a                               ; BC31 2A                       *
        rol     a                               ; BC32 2A                       *
        rol     a                               ; BC33 2A                       *
        rol     a                               ; BC34 2A                       *
        rol     a                               ; BC35 2A                       *
        rol     a                               ; BC36 2A                       *
        rol     a                               ; BC37 2A                       *
        rol     a                               ; BC38 2A                       *
        rol     a                               ; BC39 2A                       *
        rol     a                               ; BC3A 2A                       *
        rol     a                               ; BC3B 2A                       *
        rol     a                               ; BC3C 2A                       *
        rol     a                               ; BC3D 2A                       *
        rol     a                               ; BC3E 2A                       *
        rol     a                               ; BC3F 2A                       *
        rol     a                               ; BC40 2A                       *
        rol     a                               ; BC41 2A                       *
        rol     a                               ; BC42 2A                       *
        rol     a                               ; BC43 2A                       *
        rol     a                               ; BC44 2A                       *
        rol     a                               ; BC45 2A                       *
        rol     a                               ; BC46 2A                       *
        rol     a                               ; BC47 2A                       *
        rol     a                               ; BC48 2A                       *
        rol     a                               ; BC49 2A                       *
        rol     a                               ; BC4A 2A                       *
        rol     a                               ; BC4B 2A                       *
        rol     a                               ; BC4C 2A                       *
        rol     a                               ; BC4D 2A                       *
        rol     a                               ; BC4E 2A                       *
        rol     a                               ; BC4F 2A                       *
        rol     a                               ; BC50 2A                       *
        rol     a                               ; BC51 2A                       *
        rol     a                               ; BC52 2A                       *
        rol     a                               ; BC53 2A                       *
        rol     a                               ; BC54 2A                       *
        rol     a                               ; BC55 2A                       *
        rol     a                               ; BC56 2A                       *
        rol     a                               ; BC57 2A                       *
        rol     a                               ; BC58 2A                       *
        rol     a                               ; BC59 2A                       *
        rol     a                               ; BC5A 2A                       *
        rol     a                               ; BC5B 2A                       *
        rol     a                               ; BC5C 2A                       *
        rol     a                               ; BC5D 2A                       *
        rol     a                               ; BC5E 2A                       *
        rol     a                               ; BC5F 2A                       *
        rol     a                               ; BC60 2A                       *
        rol     a                               ; BC61 2A                       *
        rol     a                               ; BC62 2A                       *
        rol     a                               ; BC63 2A                       *
        rol     a                               ; BC64 2A                       *
        rol     a                               ; BC65 2A                       *
        rol     a                               ; BC66 2A                       *
        rol     a                               ; BC67 2A                       *
        rol     a                               ; BC68 2A                       *
        rol     a                               ; BC69 2A                       *
        rol     a                               ; BC6A 2A                       *
        rol     a                               ; BC6B 2A                       *
        rol     a                               ; BC6C 2A                       *
        rol     a                               ; BC6D 2A                       *
        rol     a                               ; BC6E 2A                       *
        rol     a                               ; BC6F 2A                       *
        rol     a                               ; BC70 2A                       *
        rol     a                               ; BC71 2A                       *
        rol     a                               ; BC72 2A                       *
        rol     a                               ; BC73 2A                       *
        rol     a                               ; BC74 2A                       *
        rol     a                               ; BC75 2A                       *
        rol     a                               ; BC76 2A                       *
        rol     a                               ; BC77 2A                       *
        rol     a                               ; BC78 2A                       *
        rol     a                               ; BC79 2A                       *
        rol     a                               ; BC7A 2A                       *
        rol     a                               ; BC7B 2A                       *
        rol     a                               ; BC7C 2A                       *
        rol     a                               ; BC7D 2A                       *
        rol     a                               ; BC7E 2A                       *
        rol     a                               ; BC7F 2A                       *
        rol     a                               ; BC80 2A                       *
        rol     a                               ; BC81 2A                       *
        rol     a                               ; BC82 2A                       *
        rol     a                               ; BC83 2A                       *
        rol     a                               ; BC84 2A                       *
        rol     a                               ; BC85 2A                       *
        rol     a                               ; BC86 2A                       *
        rol     a                               ; BC87 2A                       *
        rol     a                               ; BC88 2A                       *
        rol     a                               ; BC89 2A                       *
        rol     a                               ; BC8A 2A                       *
        rol     a                               ; BC8B 2A                       *
        rol     a                               ; BC8C 2A                       *
        rol     a                               ; BC8D 2A                       *
        rol     a                               ; BC8E 2A                       *
        rol     a                               ; BC8F 2A                       *
        rol     a                               ; BC90 2A                       *
        rol     a                               ; BC91 2A                       *
        rol     a                               ; BC92 2A                       *
        rol     a                               ; BC93 2A                       *
        rol     a                               ; BC94 2A                       *
        rol     a                               ; BC95 2A                       *
        rol     a                               ; BC96 2A                       *
        rol     a                               ; BC97 2A                       *
        rol     a                               ; BC98 2A                       *
        rol     a                               ; BC99 2A                       *
        rol     a                               ; BC9A 2A                       *
        rol     a                               ; BC9B 2A                       *
        rol     a                               ; BC9C 2A                       *
        rol     a                               ; BC9D 2A                       *
        rol     a                               ; BC9E 2A                       *
        rol     a                               ; BC9F 2A                       *
        rol     a                               ; BCA0 2A                       *
        rol     a                               ; BCA1 2A                       *
        rol     a                               ; BCA2 2A                       *
        rol     a                               ; BCA3 2A                       *
        rol     a                               ; BCA4 2A                       *
        rol     a                               ; BCA5 2A                       *
        rol     a                               ; BCA6 2A                       *
        rol     a                               ; BCA7 2A                       *
        rol     a                               ; BCA8 2A                       *
        rol     a                               ; BCA9 2A                       *
        rol     a                               ; BCAA 2A                       *
        rol     a                               ; BCAB 2A                       *
        rol     a                               ; BCAC 2A                       *
        rol     a                               ; BCAD 2A                       *
        rol     a                               ; BCAE 2A                       *
        rol     a                               ; BCAF 2A                       *
        rol     a                               ; BCB0 2A                       *
        rol     a                               ; BCB1 2A                       *
        rol     a                               ; BCB2 2A                       *
        rol     a                               ; BCB3 2A                       *
        rol     a                               ; BCB4 2A                       *
        rol     a                               ; BCB5 2A                       *
        rol     a                               ; BCB6 2A                       *
        rol     a                               ; BCB7 2A                       *
        rol     a                               ; BCB8 2A                       *
        rol     a                               ; BCB9 2A                       *
        rol     a                               ; BCBA 2A                       *
        rol     a                               ; BCBB 2A                       *
        rol     a                               ; BCBC 2A                       *
        rol     a                               ; BCBD 2A                       *
        rol     a                               ; BCBE 2A                       *
        rol     a                               ; BCBF 2A                       *
        rol     a                               ; BCC0 2A                       *
        rol     a                               ; BCC1 2A                       *
        rol     a                               ; BCC2 2A                       *
        rol     a                               ; BCC3 2A                       *
        rol     a                               ; BCC4 2A                       *
        rol     a                               ; BCC5 2A                       *
        rol     a                               ; BCC6 2A                       *
        rol     a                               ; BCC7 2A                       *
        rol     a                               ; BCC8 2A                       *
        rol     a                               ; BCC9 2A                       *
        rol     a                               ; BCCA 2A                       *
        rol     a                               ; BCCB 2A                       *
        rol     a                               ; BCCC 2A                       *
        rol     a                               ; BCCD 2A                       *
        rol     a                               ; BCCE 2A                       *
        rol     a                               ; BCCF 2A                       *
        rol     a                               ; BCD0 2A                       *
        rol     a                               ; BCD1 2A                       *
        rol     a                               ; BCD2 2A                       *
        rol     a                               ; BCD3 2A                       *
        rol     a                               ; BCD4 2A                       *
        rol     a                               ; BCD5 2A                       *
        rol     a                               ; BCD6 2A                       *
        rol     a                               ; BCD7 2A                       *
        rol     a                               ; BCD8 2A                       *
        rol     a                               ; BCD9 2A                       *
        rol     a                               ; BCDA 2A                       *
        rol     a                               ; BCDB 2A                       *
        rol     a                               ; BCDC 2A                       *
        rol     a                               ; BCDD 2A                       *
        rol     a                               ; BCDE 2A                       *
        rol     a                               ; BCDF 2A                       *
        rol     a                               ; BCE0 2A                       *
        rol     a                               ; BCE1 2A                       *
        rol     a                               ; BCE2 2A                       *
        rol     a                               ; BCE3 2A                       *
        rol     a                               ; BCE4 2A                       *
        rol     a                               ; BCE5 2A                       *
        rol     a                               ; BCE6 2A                       *
        rol     a                               ; BCE7 2A                       *
        rol     a                               ; BCE8 2A                       *
        rol     a                               ; BCE9 2A                       *
        rol     a                               ; BCEA 2A                       *
        rol     a                               ; BCEB 2A                       *
        rol     a                               ; BCEC 2A                       *
        rol     a                               ; BCED 2A                       *
        rol     a                               ; BCEE 2A                       *
        rol     a                               ; BCEF 2A                       *
        rol     a                               ; BCF0 2A                       *
        rol     a                               ; BCF1 2A                       *
        rol     a                               ; BCF2 2A                       *
        rol     a                               ; BCF3 2A                       *
        rol     a                               ; BCF4 2A                       *
        rol     a                               ; BCF5 2A                       *
        rol     a                               ; BCF6 2A                       *
        rol     a                               ; BCF7 2A                       *
        rol     a                               ; BCF8 2A                       *
        rol     a                               ; BCF9 2A                       *
        rol     a                               ; BCFA 2A                       *
        rol     a                               ; BCFB 2A                       *
        rol     a                               ; BCFC 2A                       *
        rol     a                               ; BCFD 2A                       *
        rol     a                               ; BCFE 2A                       *
        rol     a                               ; BCFF 2A                       *
        rol     a                               ; BD00 2A                       *
        rol     a                               ; BD01 2A                       *
        rol     a                               ; BD02 2A                       *
        rol     a                               ; BD03 2A                       *
        rol     a                               ; BD04 2A                       *
        rol     a                               ; BD05 2A                       *
        rol     a                               ; BD06 2A                       *
        rol     a                               ; BD07 2A                       *
        rol     a                               ; BD08 2A                       *
        rol     a                               ; BD09 2A                       *
        rol     a                               ; BD0A 2A                       *
        rol     a                               ; BD0B 2A                       *
        rol     a                               ; BD0C 2A                       *
        rol     a                               ; BD0D 2A                       *
        rol     a                               ; BD0E 2A                       *
        rol     a                               ; BD0F 2A                       *
        rol     a                               ; BD10 2A                       *
        rol     a                               ; BD11 2A                       *
        rol     a                               ; BD12 2A                       *
        rol     a                               ; BD13 2A                       *
        rol     a                               ; BD14 2A                       *
        rol     a                               ; BD15 2A                       *
        rol     a                               ; BD16 2A                       *
        rol     a                               ; BD17 2A                       *
        rol     a                               ; BD18 2A                       *
        rol     a                               ; BD19 2A                       *
        rol     a                               ; BD1A 2A                       *
        rol     a                               ; BD1B 2A                       *
        rol     a                               ; BD1C 2A                       *
        rol     a                               ; BD1D 2A                       *
        rol     a                               ; BD1E 2A                       *
        rol     a                               ; BD1F 2A                       *
        rol     a                               ; BD20 2A                       *
        rol     a                               ; BD21 2A                       *
        rol     a                               ; BD22 2A                       *
        rol     a                               ; BD23 2A                       *
        rol     a                               ; BD24 2A                       *
        rol     a                               ; BD25 2A                       *
        rol     a                               ; BD26 2A                       *
        rol     a                               ; BD27 2A                       *
        rol     a                               ; BD28 2A                       *
        rol     a                               ; BD29 2A                       *
        rol     a                               ; BD2A 2A                       *
        rol     a                               ; BD2B 2A                       *
        rol     a                               ; BD2C 2A                       *
        rol     a                               ; BD2D 2A                       *
        rol     a                               ; BD2E 2A                       *
        rol     a                               ; BD2F 2A                       *
        rol     a                               ; BD30 2A                       *
        rol     a                               ; BD31 2A                       *
        rol     a                               ; BD32 2A                       *
        rol     a                               ; BD33 2A                       *
        rol     a                               ; BD34 2A                       *
        rol     a                               ; BD35 2A                       *
        rol     a                               ; BD36 2A                       *
        rol     a                               ; BD37 2A                       *
        rol     a                               ; BD38 2A                       *
        rol     a                               ; BD39 2A                       *
        rol     a                               ; BD3A 2A                       *
        rol     a                               ; BD3B 2A                       *
        rol     a                               ; BD3C 2A                       *
        rol     a                               ; BD3D 2A                       *
        rol     a                               ; BD3E 2A                       *
        rol     a                               ; BD3F 2A                       *
        rol     a                               ; BD40 2A                       *
        rol     a                               ; BD41 2A                       *
        rol     a                               ; BD42 2A                       *
        rol     a                               ; BD43 2A                       *
        rol     a                               ; BD44 2A                       *
        rol     a                               ; BD45 2A                       *
        rol     a                               ; BD46 2A                       *
        rol     a                               ; BD47 2A                       *
        rol     a                               ; BD48 2A                       *
        rol     a                               ; BD49 2A                       *
        rol     a                               ; BD4A 2A                       *
        rol     a                               ; BD4B 2A                       *
        rol     a                               ; BD4C 2A                       *
        rol     a                               ; BD4D 2A                       *
        rol     a                               ; BD4E 2A                       *
        rol     a                               ; BD4F 2A                       *
        rol     a                               ; BD50 2A                       *
        rol     a                               ; BD51 2A                       *
        rol     a                               ; BD52 2A                       *
        rol     a                               ; BD53 2A                       *
        rol     a                               ; BD54 2A                       *
        rol     a                               ; BD55 2A                       *
        rol     a                               ; BD56 2A                       *
        rol     a                               ; BD57 2A                       *
        rol     a                               ; BD58 2A                       *
        rol     a                               ; BD59 2A                       *
        rol     a                               ; BD5A 2A                       *
        rol     a                               ; BD5B 2A                       *
        rol     a                               ; BD5C 2A                       *
        rol     a                               ; BD5D 2A                       *
        rol     a                               ; BD5E 2A                       *
        rol     a                               ; BD5F 2A                       *
        rol     a                               ; BD60 2A                       *
        rol     a                               ; BD61 2A                       *
        rol     a                               ; BD62 2A                       *
        rol     a                               ; BD63 2A                       *
        rol     a                               ; BD64 2A                       *
        rol     a                               ; BD65 2A                       *
        rol     a                               ; BD66 2A                       *
        rol     a                               ; BD67 2A                       *
        rol     a                               ; BD68 2A                       *
        rol     a                               ; BD69 2A                       *
        rol     a                               ; BD6A 2A                       *
        rol     a                               ; BD6B 2A                       *
        rol     a                               ; BD6C 2A                       *
        rol     a                               ; BD6D 2A                       *
        rol     a                               ; BD6E 2A                       *
        rol     a                               ; BD6F 2A                       *
        rol     a                               ; BD70 2A                       *
        rol     a                               ; BD71 2A                       *
        rol     a                               ; BD72 2A                       *
        rol     a                               ; BD73 2A                       *
        rol     a                               ; BD74 2A                       *
        rol     a                               ; BD75 2A                       *
        rol     a                               ; BD76 2A                       *
        rol     a                               ; BD77 2A                       *
        rol     a                               ; BD78 2A                       *
        rol     a                               ; BD79 2A                       *
        rol     a                               ; BD7A 2A                       *
        rol     a                               ; BD7B 2A                       *
        rol     a                               ; BD7C 2A                       *
        rol     a                               ; BD7D 2A                       *
        rol     a                               ; BD7E 2A                       *
        rol     a                               ; BD7F 2A                       *
        rol     a                               ; BD80 2A                       *
        rol     a                               ; BD81 2A                       *
        rol     a                               ; BD82 2A                       *
        rol     a                               ; BD83 2A                       *
        rol     a                               ; BD84 2A                       *
        rol     a                               ; BD85 2A                       *
        rol     a                               ; BD86 2A                       *
        rol     a                               ; BD87 2A                       *
        rol     a                               ; BD88 2A                       *
        rol     a                               ; BD89 2A                       *
        rol     a                               ; BD8A 2A                       *
        rol     a                               ; BD8B 2A                       *
        rol     a                               ; BD8C 2A                       *
        rol     a                               ; BD8D 2A                       *
        rol     a                               ; BD8E 2A                       *
        rol     a                               ; BD8F 2A                       *
        rol     a                               ; BD90 2A                       *
        rol     a                               ; BD91 2A                       *
        rol     a                               ; BD92 2A                       *
        rol     a                               ; BD93 2A                       *
        rol     a                               ; BD94 2A                       *
        rol     a                               ; BD95 2A                       *
        rol     a                               ; BD96 2A                       *
        rol     a                               ; BD97 2A                       *
        rol     a                               ; BD98 2A                       *
        rol     a                               ; BD99 2A                       *
        rol     a                               ; BD9A 2A                       *
        rol     a                               ; BD9B 2A                       *
        rol     a                               ; BD9C 2A                       *
        rol     a                               ; BD9D 2A                       *
        rol     a                               ; BD9E 2A                       *
        rol     a                               ; BD9F 2A                       *
        rol     a                               ; BDA0 2A                       *
        rol     a                               ; BDA1 2A                       *
        rol     a                               ; BDA2 2A                       *
        rol     a                               ; BDA3 2A                       *
        rol     a                               ; BDA4 2A                       *
        rol     a                               ; BDA5 2A                       *
        rol     a                               ; BDA6 2A                       *
        rol     a                               ; BDA7 2A                       *
        rol     a                               ; BDA8 2A                       *
        rol     a                               ; BDA9 2A                       *
        rol     a                               ; BDAA 2A                       *
        rol     a                               ; BDAB 2A                       *
        rol     a                               ; BDAC 2A                       *
        rol     a                               ; BDAD 2A                       *
        rol     a                               ; BDAE 2A                       *
        rol     a                               ; BDAF 2A                       *
        rol     a                               ; BDB0 2A                       *
        rol     a                               ; BDB1 2A                       *
        rol     a                               ; BDB2 2A                       *
        rol     a                               ; BDB3 2A                       *
        rol     a                               ; BDB4 2A                       *
        rol     a                               ; BDB5 2A                       *
        rol     a                               ; BDB6 2A                       *
        rol     a                               ; BDB7 2A                       *
        rol     a                               ; BDB8 2A                       *
        rol     a                               ; BDB9 2A                       *
        rol     a                               ; BDBA 2A                       *
        rol     a                               ; BDBB 2A                       *
        rol     a                               ; BDBC 2A                       *
        rol     a                               ; BDBD 2A                       *
        rol     a                               ; BDBE 2A                       *
        rol     a                               ; BDBF 2A                       *
        rol     a                               ; BDC0 2A                       *
        rol     a                               ; BDC1 2A                       *
        rol     a                               ; BDC2 2A                       *
        rol     a                               ; BDC3 2A                       *
        rol     a                               ; BDC4 2A                       *
        rol     a                               ; BDC5 2A                       *
        rol     a                               ; BDC6 2A                       *
        rol     a                               ; BDC7 2A                       *
        rol     a                               ; BDC8 2A                       *
        rol     a                               ; BDC9 2A                       *
        rol     a                               ; BDCA 2A                       *
        rol     a                               ; BDCB 2A                       *
        rol     a                               ; BDCC 2A                       *
        rol     a                               ; BDCD 2A                       *
        rol     a                               ; BDCE 2A                       *
        rol     a                               ; BDCF 2A                       *
        rol     a                               ; BDD0 2A                       *
        rol     a                               ; BDD1 2A                       *
        rol     a                               ; BDD2 2A                       *
        rol     a                               ; BDD3 2A                       *
        rol     a                               ; BDD4 2A                       *
        rol     a                               ; BDD5 2A                       *
        rol     a                               ; BDD6 2A                       *
        rol     a                               ; BDD7 2A                       *
        rol     a                               ; BDD8 2A                       *
        rol     a                               ; BDD9 2A                       *
        rol     a                               ; BDDA 2A                       *
        rol     a                               ; BDDB 2A                       *
        rol     a                               ; BDDC 2A                       *
        rol     a                               ; BDDD 2A                       *
        rol     a                               ; BDDE 2A                       *
        rol     a                               ; BDDF 2A                       *
        rol     a                               ; BDE0 2A                       *
        rol     a                               ; BDE1 2A                       *
        rol     a                               ; BDE2 2A                       *
        rol     a                               ; BDE3 2A                       *
        rol     a                               ; BDE4 2A                       *
        rol     a                               ; BDE5 2A                       *
        rol     a                               ; BDE6 2A                       *
        rol     a                               ; BDE7 2A                       *
        rol     a                               ; BDE8 2A                       *
        rol     a                               ; BDE9 2A                       *
        rol     a                               ; BDEA 2A                       *
        rol     a                               ; BDEB 2A                       *
        rol     a                               ; BDEC 2A                       *
        rol     a                               ; BDED 2A                       *
        rol     a                               ; BDEE 2A                       *
        rol     a                               ; BDEF 2A                       *
        rol     a                               ; BDF0 2A                       *
        rol     a                               ; BDF1 2A                       *
        rol     a                               ; BDF2 2A                       *
        rol     a                               ; BDF3 2A                       *
        rol     a                               ; BDF4 2A                       *
        rol     a                               ; BDF5 2A                       *
        rol     a                               ; BDF6 2A                       *
        rol     a                               ; BDF7 2A                       *
        rol     a                               ; BDF8 2A                       *
        rol     a                               ; BDF9 2A                       *
        rol     a                               ; BDFA 2A                       *
        rol     a                               ; BDFB 2A                       *
        rol     a                               ; BDFC 2A                       *
        rol     a                               ; BDFD 2A                       *
        rol     a                               ; BDFE 2A                       *
        rol     a                               ; BDFF 2A                       *
        rol     a                               ; BE00 2A                       *
        rol     a                               ; BE01 2A                       *
        rol     a                               ; BE02 2A                       *
        rol     a                               ; BE03 2A                       *
        rol     a                               ; BE04 2A                       *
        rol     a                               ; BE05 2A                       *
        rol     a                               ; BE06 2A                       *
        rol     a                               ; BE07 2A                       *
        rol     a                               ; BE08 2A                       *
        rol     a                               ; BE09 2A                       *
        rol     a                               ; BE0A 2A                       *
        rol     a                               ; BE0B 2A                       *
        rol     a                               ; BE0C 2A                       *
        rol     a                               ; BE0D 2A                       *
        rol     a                               ; BE0E 2A                       *
        rol     a                               ; BE0F 2A                       *
        rol     a                               ; BE10 2A                       *
        rol     a                               ; BE11 2A                       *
        rol     a                               ; BE12 2A                       *
        rol     a                               ; BE13 2A                       *
        rol     a                               ; BE14 2A                       *
        rol     a                               ; BE15 2A                       *
        rol     a                               ; BE16 2A                       *
        rol     a                               ; BE17 2A                       *
        rol     a                               ; BE18 2A                       *
        rol     a                               ; BE19 2A                       *
        rol     a                               ; BE1A 2A                       *
        rol     a                               ; BE1B 2A                       *
        rol     a                               ; BE1C 2A                       *
        rol     a                               ; BE1D 2A                       *
        rol     a                               ; BE1E 2A                       *
        rol     a                               ; BE1F 2A                       *
        rol     a                               ; BE20 2A                       *
        rol     a                               ; BE21 2A                       *
        rol     a                               ; BE22 2A                       *
        rol     a                               ; BE23 2A                       *
        rol     a                               ; BE24 2A                       *
        rol     a                               ; BE25 2A                       *
        rol     a                               ; BE26 2A                       *
        rol     a                               ; BE27 2A                       *
        rol     a                               ; BE28 2A                       *
        rol     a                               ; BE29 2A                       *
        rol     a                               ; BE2A 2A                       *
        rol     a                               ; BE2B 2A                       *
        rol     a                               ; BE2C 2A                       *
        rol     a                               ; BE2D 2A                       *
        rol     a                               ; BE2E 2A                       *
        rol     a                               ; BE2F 2A                       *
        rol     a                               ; BE30 2A                       *
        rol     a                               ; BE31 2A                       *
        rol     a                               ; BE32 2A                       *
        rol     a                               ; BE33 2A                       *
        rol     a                               ; BE34 2A                       *
        rol     a                               ; BE35 2A                       *
        rol     a                               ; BE36 2A                       *
        rol     a                               ; BE37 2A                       *
        rol     a                               ; BE38 2A                       *
        rol     a                               ; BE39 2A                       *
        rol     a                               ; BE3A 2A                       *
        rol     a                               ; BE3B 2A                       *
        rol     a                               ; BE3C 2A                       *
        rol     a                               ; BE3D 2A                       *
        rol     a                               ; BE3E 2A                       *
        rol     a                               ; BE3F 2A                       *
        rol     a                               ; BE40 2A                       *
        rol     a                               ; BE41 2A                       *
        rol     a                               ; BE42 2A                       *
        rol     a                               ; BE43 2A                       *
        rol     a                               ; BE44 2A                       *
        rol     a                               ; BE45 2A                       *
        rol     a                               ; BE46 2A                       *
        rol     a                               ; BE47 2A                       *
        rol     a                               ; BE48 2A                       *
        rol     a                               ; BE49 2A                       *
        rol     a                               ; BE4A 2A                       *
        rol     a                               ; BE4B 2A                       *
        rol     a                               ; BE4C 2A                       *
        rol     a                               ; BE4D 2A                       *
        rol     a                               ; BE4E 2A                       *
        rol     a                               ; BE4F 2A                       *
        rol     a                               ; BE50 2A                       *
        rol     a                               ; BE51 2A                       *
        rol     a                               ; BE52 2A                       *
        rol     a                               ; BE53 2A                       *
        rol     a                               ; BE54 2A                       *
        rol     a                               ; BE55 2A                       *
        rol     a                               ; BE56 2A                       *
        rol     a                               ; BE57 2A                       *
        rol     a                               ; BE58 2A                       *
        rol     a                               ; BE59 2A                       *
        rol     a                               ; BE5A 2A                       *
        rol     a                               ; BE5B 2A                       *
        rol     a                               ; BE5C 2A                       *
        rol     a                               ; BE5D 2A                       *
        rol     a                               ; BE5E 2A                       *
        rol     a                               ; BE5F 2A                       *
        rol     a                               ; BE60 2A                       *
        rol     a                               ; BE61 2A                       *
        rol     a                               ; BE62 2A                       *
        rol     a                               ; BE63 2A                       *
        rol     a                               ; BE64 2A                       *
        rol     a                               ; BE65 2A                       *
LBE66:  rol     a                               ; BE66 2A                       *
        rol     a                               ; BE67 2A                       *
        rol     a                               ; BE68 2A                       *
        rol     a                               ; BE69 2A                       *
        rol     a                               ; BE6A 2A                       *
        rol     a                               ; BE6B 2A                       *
        rol     a                               ; BE6C 2A                       *
        rol     a                               ; BE6D 2A                       *
        rol     a                               ; BE6E 2A                       *
        rol     a                               ; BE6F 2A                       *
        rol     a                               ; BE70 2A                       *
        rol     a                               ; BE71 2A                       *
        rol     a                               ; BE72 2A                       *
        rol     a                               ; BE73 2A                       *
        rol     a                               ; BE74 2A                       *
        rol     a                               ; BE75 2A                       *
        rol     a                               ; BE76 2A                       *
        rol     a                               ; BE77 2A                       *
        rol     a                               ; BE78 2A                       *
        rol     a                               ; BE79 2A                       *
        rol     a                               ; BE7A 2A                       *
        rol     a                               ; BE7B 2A                       *
        rol     a                               ; BE7C 2A                       *
        rol     a                               ; BE7D 2A                       *
        rol     a                               ; BE7E 2A                       *
        rol     a                               ; BE7F 2A                       *
        rol     a                               ; BE80 2A                       *
        rol     a                               ; BE81 2A                       *
        rol     a                               ; BE82 2A                       *
        rol     a                               ; BE83 2A                       *
        rol     a                               ; BE84 2A                       *
        rol     a                               ; BE85 2A                       *
        rol     a                               ; BE86 2A                       *
        rol     a                               ; BE87 2A                       *
        rol     a                               ; BE88 2A                       *
        rol     a                               ; BE89 2A                       *
        rol     a                               ; BE8A 2A                       *
        rol     a                               ; BE8B 2A                       *
        rol     a                               ; BE8C 2A                       *
        rol     a                               ; BE8D 2A                       *
        rol     a                               ; BE8E 2A                       *
        rol     a                               ; BE8F 2A                       *
        rol     a                               ; BE90 2A                       *
        rol     a                               ; BE91 2A                       *
        rol     a                               ; BE92 2A                       *
        rol     a                               ; BE93 2A                       *
        rol     a                               ; BE94 2A                       *
        rol     a                               ; BE95 2A                       *
        rol     a                               ; BE96 2A                       *
        rol     a                               ; BE97 2A                       *
        rol     a                               ; BE98 2A                       *
        rol     a                               ; BE99 2A                       *
        rol     a                               ; BE9A 2A                       *
        rol     a                               ; BE9B 2A                       *
        rol     a                               ; BE9C 2A                       *
        rol     a                               ; BE9D 2A                       *
        rol     a                               ; BE9E 2A                       *
        rol     a                               ; BE9F 2A                       *
        rol     a                               ; BEA0 2A                       *
        rol     a                               ; BEA1 2A                       *
        rol     a                               ; BEA2 2A                       *
        rol     a                               ; BEA3 2A                       *
        rol     a                               ; BEA4 2A                       *
        rol     a                               ; BEA5 2A                       *
        rol     a                               ; BEA6 2A                       *
        rol     a                               ; BEA7 2A                       *
        rol     a                               ; BEA8 2A                       *
        rol     a                               ; BEA9 2A                       *
        rol     a                               ; BEAA 2A                       *
        rol     a                               ; BEAB 2A                       *
        rol     a                               ; BEAC 2A                       *
        rol     a                               ; BEAD 2A                       *
        rol     a                               ; BEAE 2A                       *
        rol     a                               ; BEAF 2A                       *
        rol     a                               ; BEB0 2A                       *
        rol     a                               ; BEB1 2A                       *
        rol     a                               ; BEB2 2A                       *
        rol     a                               ; BEB3 2A                       *
        rol     a                               ; BEB4 2A                       *
        rol     a                               ; BEB5 2A                       *
        rol     a                               ; BEB6 2A                       *
        rol     a                               ; BEB7 2A                       *
        rol     a                               ; BEB8 2A                       *
        rol     a                               ; BEB9 2A                       *
        rol     a                               ; BEBA 2A                       *
        rol     a                               ; BEBB 2A                       *
        rol     a                               ; BEBC 2A                       *
LBEBD:  rol     a                               ; BEBD 2A                       *
        rol     a                               ; BEBE 2A                       *
        rol     a                               ; BEBF 2A                       *
        rol     a                               ; BEC0 2A                       *
        rol     a                               ; BEC1 2A                       *
        rol     a                               ; BEC2 2A                       *
        rol     a                               ; BEC3 2A                       *
        rol     a                               ; BEC4 2A                       *
        rol     a                               ; BEC5 2A                       *
        rol     a                               ; BEC6 2A                       *
        rol     a                               ; BEC7 2A                       *
        rol     a                               ; BEC8 2A                       *
        rol     a                               ; BEC9 2A                       *
        rol     a                               ; BECA 2A                       *
        rol     a                               ; BECB 2A                       *
        rol     a                               ; BECC 2A                       *
        rol     a                               ; BECD 2A                       *
        rol     a                               ; BECE 2A                       *
        rol     a                               ; BECF 2A                       *
        rol     a                               ; BED0 2A                       *
        rol     a                               ; BED1 2A                       *
        rol     a                               ; BED2 2A                       *
        rol     a                               ; BED3 2A                       *
        rol     a                               ; BED4 2A                       *
        rol     a                               ; BED5 2A                       *
        rol     a                               ; BED6 2A                       *
        rol     a                               ; BED7 2A                       *
        rol     a                               ; BED8 2A                       *
        rol     a                               ; BED9 2A                       *
        rol     a                               ; BEDA 2A                       *
        rol     a                               ; BEDB 2A                       *
        rol     a                               ; BEDC 2A                       *
        rol     a                               ; BEDD 2A                       *
        rol     a                               ; BEDE 2A                       *
        rol     a                               ; BEDF 2A                       *
        rol     a                               ; BEE0 2A                       *
        rol     a                               ; BEE1 2A                       *
        rol     a                               ; BEE2 2A                       *
        rol     a                               ; BEE3 2A                       *
        rol     a                               ; BEE4 2A                       *
        rol     a                               ; BEE5 2A                       *
        rol     a                               ; BEE6 2A                       *
        rol     a                               ; BEE7 2A                       *
        rol     a                               ; BEE8 2A                       *
        rol     a                               ; BEE9 2A                       *
        rol     a                               ; BEEA 2A                       *
        rol     a                               ; BEEB 2A                       *
        rol     a                               ; BEEC 2A                       *
        rol     a                               ; BEED 2A                       *
        rol     a                               ; BEEE 2A                       *
        rol     a                               ; BEEF 2A                       *
        rol     a                               ; BEF0 2A                       *
        rol     a                               ; BEF1 2A                       *
        rol     a                               ; BEF2 2A                       *
        rol     a                               ; BEF3 2A                       *
        rol     a                               ; BEF4 2A                       *
LBEF5:  rol     a                               ; BEF5 2A                       *
        rol     a                               ; BEF6 2A                       *
        rol     a                               ; BEF7 2A                       *
        rol     a                               ; BEF8 2A                       *
        rol     a                               ; BEF9 2A                       *
        rol     a                               ; BEFA 2A                       *
        rol     a                               ; BEFB 2A                       *
        rol     a                               ; BEFC 2A                       *
        rol     a                               ; BEFD 2A                       *
        rol     a                               ; BEFE 2A                       *
        rol     a                               ; BEFF 2A                       *
        rol     a                               ; BF00 2A                       *
        rol     a                               ; BF01 2A                       *
        rol     a                               ; BF02 2A                       *
        rol     a                               ; BF03 2A                       *
        rol     a                               ; BF04 2A                       *
        rol     a                               ; BF05 2A                       *
        rol     a                               ; BF06 2A                       *
        rol     a                               ; BF07 2A                       *
        rol     a                               ; BF08 2A                       *
        rol     a                               ; BF09 2A                       *
        rol     a                               ; BF0A 2A                       *
        rol     a                               ; BF0B 2A                       *
        rol     a                               ; BF0C 2A                       *
        rol     a                               ; BF0D 2A                       *
        rol     a                               ; BF0E 2A                       *
        rol     a                               ; BF0F 2A                       *
        rol     a                               ; BF10 2A                       *
        rol     a                               ; BF11 2A                       *
        rol     a                               ; BF12 2A                       *
        rol     a                               ; BF13 2A                       *
        rol     a                               ; BF14 2A                       *
        rol     a                               ; BF15 2A                       *
        rol     a                               ; BF16 2A                       *
        rol     a                               ; BF17 2A                       *
        rol     a                               ; BF18 2A                       *
        rol     a                               ; BF19 2A                       *
        rol     a                               ; BF1A 2A                       *
        rol     a                               ; BF1B 2A                       *
        rol     a                               ; BF1C 2A                       *
        rol     a                               ; BF1D 2A                       *
        rol     a                               ; BF1E 2A                       *
        rol     a                               ; BF1F 2A                       *
        rol     a                               ; BF20 2A                       *
        rol     a                               ; BF21 2A                       *
        rol     a                               ; BF22 2A                       *
        rol     a                               ; BF23 2A                       *
        rol     a                               ; BF24 2A                       *
        rol     a                               ; BF25 2A                       *
        rol     a                               ; BF26 2A                       *
        rol     a                               ; BF27 2A                       *
        rol     a                               ; BF28 2A                       *
        rol     a                               ; BF29 2A                       *
        rol     a                               ; BF2A 2A                       *
        rol     a                               ; BF2B 2A                       *
        rol     a                               ; BF2C 2A                       *
        rol     a                               ; BF2D 2A                       *
        rol     a                               ; BF2E 2A                       *
        rol     a                               ; BF2F 2A                       *
        rol     a                               ; BF30 2A                       *
        rol     a                               ; BF31 2A                       *
        rol     a                               ; BF32 2A                       *
        rol     a                               ; BF33 2A                       *
        rol     a                               ; BF34 2A                       *
        rol     a                               ; BF35 2A                       *
        rol     a                               ; BF36 2A                       *
        rol     a                               ; BF37 2A                       *
        rol     a                               ; BF38 2A                       *
        rol     a                               ; BF39 2A                       *
        rol     a                               ; BF3A 2A                       *
        rol     a                               ; BF3B 2A                       *
        rol     a                               ; BF3C 2A                       *
        rol     a                               ; BF3D 2A                       *
        rol     a                               ; BF3E 2A                       *
        rol     a                               ; BF3F 2A                       *
        rol     a                               ; BF40 2A                       *
        rol     a                               ; BF41 2A                       *
        rol     a                               ; BF42 2A                       *
        rol     a                               ; BF43 2A                       *
        rol     a                               ; BF44 2A                       *
        rol     a                               ; BF45 2A                       *
        rol     a                               ; BF46 2A                       *
        rol     a                               ; BF47 2A                       *
        rol     a                               ; BF48 2A                       *
        rol     a                               ; BF49 2A                       *
        rol     a                               ; BF4A 2A                       *
        rol     a                               ; BF4B 2A                       *
        rol     a                               ; BF4C 2A                       *
        rol     a                               ; BF4D 2A                       *
        rol     a                               ; BF4E 2A                       *
        rol     a                               ; BF4F 2A                       *
        rol     a                               ; BF50 2A                       *
        rol     a                               ; BF51 2A                       *
        rol     a                               ; BF52 2A                       *
        rol     a                               ; BF53 2A                       *
        rol     a                               ; BF54 2A                       *
        rol     a                               ; BF55 2A                       *
        rol     a                               ; BF56 2A                       *
        rol     a                               ; BF57 2A                       *
        rol     a                               ; BF58 2A                       *
        rol     a                               ; BF59 2A                       *
        rol     a                               ; BF5A 2A                       *
        rol     a                               ; BF5B 2A                       *
        rol     a                               ; BF5C 2A                       *
        rol     a                               ; BF5D 2A                       *
        rol     a                               ; BF5E 2A                       *
        rol     a                               ; BF5F 2A                       *
        rol     a                               ; BF60 2A                       *
        rol     a                               ; BF61 2A                       *
        rol     a                               ; BF62 2A                       *
        rol     a                               ; BF63 2A                       *
        rol     a                               ; BF64 2A                       *
        rol     a                               ; BF65 2A                       *
        rol     a                               ; BF66 2A                       *
        rol     a                               ; BF67 2A                       *
        rol     a                               ; BF68 2A                       *
        rol     a                               ; BF69 2A                       *
        rol     a                               ; BF6A 2A                       *
        rol     a                               ; BF6B 2A                       *
        rol     a                               ; BF6C 2A                       *
        rol     a                               ; BF6D 2A                       *
        rol     a                               ; BF6E 2A                       *
        rol     a                               ; BF6F 2A                       *
        rol     a                               ; BF70 2A                       *
        rol     a                               ; BF71 2A                       *
        rol     a                               ; BF72 2A                       *
        rol     a                               ; BF73 2A                       *
        rol     a                               ; BF74 2A                       *
        rol     a                               ; BF75 2A                       *
        rol     a                               ; BF76 2A                       *
        rol     a                               ; BF77 2A                       *
        rol     a                               ; BF78 2A                       *
        rol     a                               ; BF79 2A                       *
        rol     a                               ; BF7A 2A                       *
        rol     a                               ; BF7B 2A                       *
        rol     a                               ; BF7C 2A                       *
        rol     a                               ; BF7D 2A                       *
        rol     a                               ; BF7E 2A                       *
        rol     a                               ; BF7F 2A                       *
        rol     a                               ; BF80 2A                       *
        rol     a                               ; BF81 2A                       *
        rol     a                               ; BF82 2A                       *
        rol     a                               ; BF83 2A                       *
        rol     a                               ; BF84 2A                       *
        rol     a                               ; BF85 2A                       *
        rol     a                               ; BF86 2A                       *
        rol     a                               ; BF87 2A                       *
        rol     a                               ; BF88 2A                       *
        rol     a                               ; BF89 2A                       *
        rol     a                               ; BF8A 2A                       *
        rol     a                               ; BF8B 2A                       *
        rol     a                               ; BF8C 2A                       *
        rol     a                               ; BF8D 2A                       *
        rol     a                               ; BF8E 2A                       *
        rol     a                               ; BF8F 2A                       *
        rol     a                               ; BF90 2A                       *
        rol     a                               ; BF91 2A                       *
        rol     a                               ; BF92 2A                       *
        rol     a                               ; BF93 2A                       *
        rol     a                               ; BF94 2A                       *
        rol     a                               ; BF95 2A                       *
        rol     a                               ; BF96 2A                       *
        rol     a                               ; BF97 2A                       *
        rol     a                               ; BF98 2A                       *
        rol     a                               ; BF99 2A                       *
        rol     a                               ; BF9A 2A                       *
        rol     a                               ; BF9B 2A                       *
        rol     a                               ; BF9C 2A                       *
        rol     a                               ; BF9D 2A                       *
        rol     a                               ; BF9E 2A                       *
        rol     a                               ; BF9F 2A                       *
        rol     a                               ; BFA0 2A                       *
        rol     a                               ; BFA1 2A                       *
        rol     a                               ; BFA2 2A                       *
        rol     a                               ; BFA3 2A                       *
        rol     a                               ; BFA4 2A                       *
        rol     a                               ; BFA5 2A                       *
        rol     a                               ; BFA6 2A                       *
        rol     a                               ; BFA7 2A                       *
        rol     a                               ; BFA8 2A                       *
        rol     a                               ; BFA9 2A                       *
        rol     a                               ; BFAA 2A                       *
        rol     a                               ; BFAB 2A                       *
        rol     a                               ; BFAC 2A                       *
        rol     a                               ; BFAD 2A                       *
        rol     a                               ; BFAE 2A                       *
        rol     a                               ; BFAF 2A                       *
        rol     a                               ; BFB0 2A                       *
        rol     a                               ; BFB1 2A                       *
        rol     a                               ; BFB2 2A                       *
        rol     a                               ; BFB3 2A                       *
        rol     a                               ; BFB4 2A                       *
        rol     a                               ; BFB5 2A                       *
        rol     a                               ; BFB6 2A                       *
        rol     a                               ; BFB7 2A                       *
        rol     a                               ; BFB8 2A                       *
        rol     a                               ; BFB9 2A                       *
        rol     a                               ; BFBA 2A                       *
        rol     a                               ; BFBB 2A                       *
        rol     a                               ; BFBC 2A                       *
        rol     a                               ; BFBD 2A                       *
        rol     a                               ; BFBE 2A                       *
        rol     a                               ; BFBF 2A                       *
        rol     a                               ; BFC0 2A                       *
        rol     a                               ; BFC1 2A                       *
        rol     a                               ; BFC2 2A                       *
        rol     a                               ; BFC3 2A                       *
        rol     a                               ; BFC4 2A                       *
        rol     a                               ; BFC5 2A                       *
        rol     a                               ; BFC6 2A                       *
        rol     a                               ; BFC7 2A                       *
        rol     a                               ; BFC8 2A                       *
        rol     a                               ; BFC9 2A                       *
        rol     a                               ; BFCA 2A                       *
        rol     a                               ; BFCB 2A                       *
        rol     a                               ; BFCC 2A                       *
        rol     a                               ; BFCD 2A                       *
        rol     a                               ; BFCE 2A                       *
        rol     a                               ; BFCF 2A                       *
        rol     a                               ; BFD0 2A                       *
        rol     a                               ; BFD1 2A                       *
        rol     a                               ; BFD2 2A                       *
        rol     a                               ; BFD3 2A                       *
        rol     a                               ; BFD4 2A                       *
        rol     a                               ; BFD5 2A                       *
        rol     a                               ; BFD6 2A                       *
        rol     a                               ; BFD7 2A                       *
        rol     a                               ; BFD8 2A                       *
        rol     a                               ; BFD9 2A                       *
        rol     a                               ; BFDA 2A                       *
        rol     a                               ; BFDB 2A                       *
        rol     a                               ; BFDC 2A                       *
        rol     a                               ; BFDD 2A                       *
        rol     a                               ; BFDE 2A                       *
        rol     a                               ; BFDF 2A                       *
        rol     a                               ; BFE0 2A                       *
        rol     a                               ; BFE1 2A                       *
        rol     a                               ; BFE2 2A                       *
        rol     a                               ; BFE3 2A                       *
        rol     a                               ; BFE4 2A                       *
        rol     a                               ; BFE5 2A                       *
        rol     a                               ; BFE6 2A                       *
        rol     a                               ; BFE7 2A                       *
        rol     a                               ; BFE8 2A                       *
        rol     a                               ; BFE9 2A                       *
        rol     a                               ; BFEA 2A                       *
        rol     a                               ; BFEB 2A                       *
        rol     a                               ; BFEC 2A                       *
        rol     a                               ; BFED 2A                       *
        rol     a                               ; BFEE 2A                       *
        rol     a                               ; BFEF 2A                       *
        rol     a                               ; BFF0 2A                       *
        rol     a                               ; BFF1 2A                       *
        rol     a                               ; BFF2 2A                       *
        rol     a                               ; BFF3 2A                       *
        rol     a                               ; BFF4 2A                       *
        rol     a                               ; BFF5 2A                       *
        rol     a                               ; BFF6 2A                       *
        rol     a                               ; BFF7 2A                       *
        rol     a                               ; BFF8 2A                       *
        rol     a                               ; BFF9 2A                       *
        rol     a                               ; BFFA 2A                       *
        rol     a                               ; BFFB 2A                       *
        rol     a                               ; BFFC 2A                       *
        rol     a                               ; BFFD 2A                       *
        rol     a                               ; BFFE 2A                       *
        rol     a                               ; BFFF 2A                       *
