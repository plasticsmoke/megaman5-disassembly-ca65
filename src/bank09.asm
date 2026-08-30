.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK09"

; =============================================================================
; BANK $09 (mapped at $A000) — DARK MAN 1-4 AI + PROTO CASTLE 2 STAGE
; DATA
; Data half (file +$0900 on): stage $09 (Proto castle 2) stage data —
; screen table at $A900 with this bank at $A000; format in
; DATA_REFERENCE.md section 11.
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
; --- $A800: DAMAGE TABLE, weapon $9 (Star Crash) ---
; $A800[ent_type] via damage_engine $1C:809D; low 7 bits = damage,
; bit 7 = special handling; $00 = ricochet. Types $00-$CF.
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A800  types $00-$0F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$01,$01,$01,$00,$00 ; A810  types $10-$1F
        .byte   $03,$01,$00,$00,$00,$01,$80,$00,$01,$01,$01,$01,$80,$80,$00,$00 ; A820  types $20-$2F
        .byte   $00,$01,$01,$01,$01,$00,$01,$80,$00,$01,$01,$01,$80,$00,$02,$80 ; A830  types $30-$3F
        .byte   $03,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$01 ; A840  types $40-$4F
        .byte   $01,$80,$01,$01,$01,$80,$01,$00,$80,$01,$01,$00,$01,$02,$00,$00 ; A850  types $50-$5F
        .byte   $01,$80,$01,$01,$01,$01,$02,$01,$01,$01,$80,$01,$80,$00,$01,$80 ; A860  types $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$00,$80,$80 ; A870  types $70-$7F
        .byte   $80,$04,$80,$01,$80,$80,$01,$80,$00,$01,$80,$80,$00,$01,$00,$80 ; A880  types $80-$8F
        .byte   $80,$01,$00,$01,$80,$80,$01,$80,$02,$00,$80,$80,$02,$80,$01,$80 ; A890  types $90-$9F
        .byte   $04,$00,$00,$00,$00,$01,$00,$80,$80,$00,$01,$80,$00,$00,$00,$00 ; A8A0  types $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$02,$00 ; A8B0  types $B0-$BF
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8C0  types $C0-$CF
; --- $A8D0: remainder (beyond type $CF) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8F0

; =============================================================================
; PROTO CASTLE 2 STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $A900: screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; A900  screens $00-$0F
        .byte   $10,$11,$12,$13,$14,$15,$16,$17,$00,$00,$00,$00,$00,$80,$00,$00 ; A910  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A920  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A930  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A940  screens $40-$4F
; --- $A950: section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $20,$80,$A3,$40,$62,$80,$A2,$40,$62,$80,$A2,$20,$20,$00,$00,$00 ; A950
        .byte   $00,$00,$02,$00,$00,$00,$00,$00 ; A960
; --- $A968: per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $1C,$02,$23,$19,$03,$2A,$1C,$00,$2B,$1C,$24,$80,$BB,$00,$00,$02 ; A968
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A978
; --- $A980: BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $A4,$A6,$00,$00,$00,$00,$00,$00 ; A980
; --- $A988: palette sets, 20 bytes each [16 BG palette + 4 palette-cycle
; seeds]: set n at +20n; set 0 is loaded by stage_load, later sets are
; switched per section by the bank $00 environment service
; ($A968 attr bits 0-5 -> $00:809E records, ctl bit 7) ---
        .byte   $0F,$30,$10,$18,$0F,$30,$23,$0C,$0F,$37,$18,$08,$0F,$30,$00,$0B ; A988
        .byte   $00,$00,$93,$00,$00,$00,$00,$00 ; A998
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9B0
        .byte   $00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9D0
; --- $A9E0: screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9E0  terminator / filler
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9F0  
        .byte   $00                             ; A9FF  -1 base for the spawn arrays
; --- $AA00: spawn screens (ascending) ---
        .byte   $00,$00,$01,$01,$01,$02,$02,$03,$03,$03,$04,$04,$04,$04,$04,$05 ; AA00  entries $00-$0F
        .byte   $05,$05,$06,$06,$06,$08,$08,$08,$09,$09,$09,$0A,$0A,$0A,$0A,$0B ; AA10  entries $10-$1F
        .byte   $0B,$0B,$0B,$0C,$0C,$0C,$0D,$0D,$0D,$0E,$10,$10,$11,$11,$12,$12 ; AA20  entries $20-$2F
        .byte   $12,$13,$13,$13,$14,$14,$14,$14,$15,$15,$15,$15,$17,$FF,$00,$00 ; AA30  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00 ; AA50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA70  entries $70-$7F
; --- $AA80: spawn X px ---
        .byte   $68,$98,$48,$98,$B8,$E0,$E8,$30,$60,$B0,$20,$50,$80,$E8,$F0,$60 ; AA80  entries $00-$0F
        .byte   $B0,$B1,$00,$50,$90,$28,$88,$90,$48,$A8,$D8,$00,$20,$30,$C0,$00 ; AA90  entries $10-$1F
        .byte   $90,$B8,$D0,$20,$48,$B0,$77,$78,$80,$30,$90,$D0,$10,$50,$70,$88 ; AAA0  entries $20-$2F
        .byte   $B0,$40,$88,$D0,$10,$30,$80,$C0,$20,$40,$A0,$D0,$D8,$FF,$00,$00 ; AAB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00 ; AAC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00 ; AAE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAF0  entries $70-$7F
; --- $AB00: spawn Y px ---
        .byte   $56,$56,$B0,$68,$B0,$40,$B0,$50,$90,$60,$70,$A0,$80,$70,$A0,$A0 ; AB00  entries $00-$0F
        .byte   $80,$B0,$00,$96,$66,$60,$70,$38,$20,$40,$60,$00,$30,$B1,$71,$00 ; AB10  entries $10-$1F
        .byte   $68,$38,$94,$70,$85,$45,$78,$98,$30,$78,$30,$30,$30,$30,$80,$C0 ; AB20  entries $20-$2F
        .byte   $68,$38,$48,$74,$30,$E0,$54,$40,$44,$B0,$B4,$40,$00,$FF,$00,$00 ; AB30  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB70  entries $70-$7F
; --- $AB80: spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $2F,$2E,$14,$82,$14,$36,$36,$36,$09,$36,$36,$09,$36,$36,$09,$36 ; AB80  entries $00-$0F
        .byte   $36,$09,$C0,$2E,$2F,$02,$02,$02,$02,$02,$02,$C0,$18,$18,$18,$C2 ; AB90  entries $10-$1F
        .byte   $12,$86,$33,$12,$33,$33,$84,$81,$33,$83,$2B,$2B,$2B,$2B,$08,$08 ; ABA0  entries $20-$2F
        .byte   $84,$3F,$3F,$04,$3F,$3F,$04,$3F,$04,$3F,$04,$3F,$6A,$FF,$00,$00 ; ABB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABF0  entries $70-$7F
; --- $AC00: per-screen spawn-list start index ---
        .byte   $00,$02,$05,$07,$0A,$0F,$12,$15,$15,$18,$1B,$1F,$23,$26,$29,$2A ; AC00  screens $00-$0F
        .byte   $2A,$2C,$2E,$31,$34,$38,$3C,$3C,$00,$00,$00,$00,$00,$00,$00,$10 ; AC10  screens $10-$1F
        .byte   $00,$40,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC20  screens $20-$2F
        .byte   $00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC30  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$06,$00,$00,$00,$00,$00,$00,$00 ; AC40  screens $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC50  screens $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC60  screens $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC80  screens $80-$8F
        .byte   $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC90  screens $90-$9F
        .byte   $00,$00,$00,$00,$60,$00,$20,$00,$00,$00,$00,$04,$00,$00,$00,$00 ; ACA0  screens $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00 ; ACB0  screens $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACD0  screens $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACE0  screens $E0-$EF
        .byte   $04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$04 ; ACF0  screens $F0-$FF
; --- $AD00: metatile top-left tile ids ---
        .byte   $00,$01,$02,$04,$06,$08,$0A,$00,$02,$12,$00,$04,$00,$0C,$0E,$00 ; AD00  metatiles $00-$0F
        .byte   $00,$00,$82,$00,$00,$00,$D0,$AE,$CB,$CD,$A3,$A6,$80,$82,$83,$86 ; AD10  metatiles $10-$1F
        .byte   $80,$82,$82,$11,$80,$82,$82,$02,$A0,$11,$11,$82,$A0,$80,$82,$80 ; AD20  metatiles $20-$2F
        .byte   $C0,$C2,$C6,$85,$C0,$C2,$C6,$A5,$D7,$E2,$E6,$A5,$C8,$CA,$00,$C0 ; AD30  metatiles $30-$3F
        .byte   $20,$00,$22,$24,$34,$4A,$29,$2B,$40,$00,$42,$49,$00,$00,$00,$48 ; AD40  metatiles $40-$4F
        .byte   $42,$42,$42,$00,$00,$00,$00,$68,$42,$00,$36,$42,$27,$47,$00,$5A ; AD50  metatiles $50-$5F
        .byte   $00,$00,$00,$00,$00,$76,$01,$00,$54,$55,$00,$00,$00,$76,$C4,$00 ; AD60  metatiles $60-$6F
        .byte   $74,$75,$00,$00,$00,$00,$63,$00,$00,$00,$00,$00,$00,$00,$63,$00 ; AD70  metatiles $70-$7F
        .byte   $E8,$EA,$EB,$ED,$EE,$82,$88,$8A,$E9,$EA,$C0,$00,$00,$BA,$98,$AC ; AD80  metatiles $80-$8F
        .byte   $80,$82,$CA,$00,$00,$82,$98,$9A,$00,$00,$C0,$00,$00,$BE,$6A,$6C ; AD90  metatiles $90-$9F
        .byte   $4E,$4E,$3D,$00,$00,$00,$00,$00,$2C,$5E,$3E,$3E,$00,$00,$00,$00 ; ADA0  metatiles $A0-$AF
        .byte   $5C,$5E,$00,$00,$5E,$8E,$8E,$00,$CF,$5E,$00,$A2,$5E,$01,$01,$00 ; ADB0  metatiles $B0-$BF
        .byte   $5C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADC0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADD0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADF0  metatiles $F0-$FF
; --- $AE00: metatile bottom-left tile ids ---
        .byte   $00,$01,$03,$05,$07,$09,$0B,$00,$03,$13,$00,$05,$00,$0D,$0F,$00 ; AE00  metatiles $00-$0F
        .byte   $00,$00,$84,$00,$00,$00,$AD,$AF,$CC,$CB,$A4,$A7,$81,$87,$86,$83 ; AE10  metatiles $10-$1F
        .byte   $81,$81,$87,$85,$81,$81,$87,$03,$11,$11,$97,$A5,$85,$B5,$87,$87 ; AE20  metatiles $20-$2F
        .byte   $C1,$C2,$C7,$85,$C1,$C2,$C7,$A5,$E1,$E3,$E7,$A5,$C9,$CA,$00,$C7 ; AE30  metatiles $30-$3F
        .byte   $21,$00,$23,$24,$34,$28,$2A,$4B,$41,$00,$43,$49,$00,$00,$00,$21 ; AE40  metatiles $40-$4F
        .byte   $43,$43,$43,$00,$00,$00,$00,$41,$36,$00,$43,$46,$27,$43,$00,$5B ; AE50  metatiles $50-$5F
        .byte   $00,$00,$25,$61,$61,$01,$77,$00,$55,$55,$35,$61,$61,$C3,$77,$00 ; AE60  metatiles $60-$6F
        .byte   $75,$75,$00,$61,$00,$62,$00,$00,$00,$00,$00,$00,$00,$62,$00,$00 ; AE70  metatiles $70-$7F
        .byte   $E9,$EA,$EC,$EA,$E8,$81,$89,$8B,$EA,$EE,$C5,$00,$00,$BB,$99,$9B ; AE80  metatiles $80-$8F
        .byte   $81,$87,$95,$00,$00,$81,$99,$9B,$00,$00,$B5,$00,$00,$BF,$6B,$6D ; AE90  metatiles $90-$9F
        .byte   $4F,$3C,$3C,$00,$00,$00,$00,$00,$2D,$3E,$3E,$3E,$00,$00,$00,$00 ; AEA0  metatiles $A0-$AF
        .byte   $5D,$00,$00,$00,$8D,$8E,$8F,$00,$EF,$EF,$00,$84,$9D,$01,$9F,$00 ; AEB0  metatiles $B0-$BF
        .byte   $00,$5D,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEC0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AED0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEF0  metatiles $F0-$FF
; --- $AF00: metatile top-right tile ids ---
        .byte   $00,$01,$02,$16,$16,$18,$1A,$00,$02,$12,$00,$14,$00,$1C,$1E,$00 ; AF00  metatiles $00-$0F
        .byte   $00,$00,$93,$00,$00,$00,$E0,$F4,$DB,$DD,$B3,$B6,$B1,$A3,$01,$01 ; AF10  metatiles $10-$1F
        .byte   $90,$11,$11,$B3,$B0,$B3,$B3,$B0,$B0,$B2,$B3,$11,$B0,$B0,$B3,$B0 ; AF20  metatiles $20-$2F
        .byte   $D7,$D2,$D6,$95,$F0,$F2,$F6,$95,$F0,$F2,$F6,$B5,$D8,$DA,$00,$F0 ; AF30  metatiles $30-$3F
        .byte   $30,$00,$32,$01,$34,$00,$39,$3B,$40,$00,$32,$32,$00,$00,$00,$58 ; AF40  metatiles $40-$4F
        .byte   $32,$27,$37,$32,$00,$36,$00,$68,$32,$00,$36,$32,$32,$32,$32,$40 ; AF50  metatiles $50-$5F
        .byte   $44,$45,$00,$50,$70,$66,$01,$00,$64,$65,$00,$00,$00,$00,$63,$00 ; AF60  metatiles $60-$6F
        .byte   $00,$00,$00,$00,$70,$00,$73,$00,$59,$52,$00,$63,$50,$00,$63,$00 ; AF70  metatiles $70-$7F
        .byte   $F8,$FA,$FB,$FD,$FE,$B8,$98,$AC,$F9,$FA,$F0,$00,$00,$B3,$98,$9A ; AF80  metatiles $80-$8F
        .byte   $B0,$B3,$DA,$00,$00,$BC,$A8,$AA,$00,$00,$F0,$00,$00,$B2,$7A,$7C ; AF90  metatiles $90-$9F
        .byte   $5E,$5E,$4D,$5E,$4D,$2F,$5E,$5E,$2C,$5E,$2F,$3F,$00,$00,$00,$00 ; AFA0  metatiles $A0-$AF
        .byte   $5C,$5E,$00,$00,$5E,$01,$01,$00,$DF,$5E,$00,$93,$5E,$01,$01,$00 ; AFB0  metatiles $B0-$BF
        .byte   $B8,$BA,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFC0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFD0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFF0  metatiles $F0-$FF
; --- $B000: metatile bottom-right tile ids ---
        .byte   $00,$01,$03,$17,$17,$19,$1B,$00,$03,$13,$00,$15,$00,$1D,$1F,$00 ; B000  metatiles $00-$0F
        .byte   $00,$00,$94,$00,$00,$00,$F3,$F5,$DC,$DB,$B3,$B7,$B3,$B4,$01,$01 ; B010  metatiles $10-$1F
        .byte   $11,$11,$97,$95,$B3,$B3,$B4,$B4,$B3,$B3,$B4,$B5,$95,$B3,$85,$B4 ; B020  metatiles $20-$2F
        .byte   $D1,$D3,$E7,$95,$F1,$F2,$F7,$95,$F1,$F2,$F7,$B5,$D9,$DA,$00,$F7 ; B030  metatiles $30-$3F
        .byte   $31,$00,$33,$01,$34,$38,$3A,$00,$41,$00,$33,$33,$00,$00,$00,$31 ; B040  metatiles $40-$4F
        .byte   $26,$27,$33,$36,$00,$33,$00,$41,$36,$00,$33,$33,$33,$33,$33,$41 ; B050  metatiles $50-$5F
        .byte   $45,$45,$35,$51,$71,$01,$67,$00,$65,$65,$35,$61,$71,$62,$00,$00 ; B060  metatiles $60-$6F
        .byte   $00,$00,$61,$60,$71,$72,$00,$00,$59,$57,$62,$00,$51,$62,$00,$00 ; B070  metatiles $70-$7F
        .byte   $F9,$FA,$FC,$FA,$F8,$B9,$99,$9B,$FA,$FE,$85,$00,$00,$B3,$8C,$9B ; B080  metatiles $80-$8F
        .byte   $B3,$B4,$A5,$00,$00,$BD,$A9,$AB,$00,$00,$D5,$00,$00,$B3,$7B,$7D ; B090  metatiles $90-$9F
        .byte   $5F,$4C,$4C,$4C,$4C,$2F,$5F,$00,$2D,$2F,$2F,$3F,$00,$00,$00,$00 ; B0A0  metatiles $A0-$AF
        .byte   $5D,$00,$00,$00,$9D,$01,$9F,$00,$FF,$FF,$00,$94,$9D,$01,$9F,$00 ; B0B0  metatiles $B0-$BF
        .byte   $B9,$BB,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0C0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0D0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0E0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0F0  metatiles $F0-$FF
; --- $B100: metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$10,$21,$F1,$F1,$70,$70,$10,$41,$01,$00,$F1,$00,$50,$50,$00 ; B100  metatiles $00-$0F
        .byte   $00,$00,$10,$00,$00,$00,$00,$00,$10,$10,$10,$10,$10,$10,$10,$10 ; B110  metatiles $10-$1F
        .byte   $10,$10,$10,$00,$10,$10,$10,$00,$10,$10,$10,$00,$00,$00,$00,$10 ; B120  metatiles $20-$2F
        .byte   $11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$10,$11 ; B130  metatiles $30-$3F
        .byte   $02,$00,$02,$02,$02,$00,$00,$00,$02,$00,$02,$02,$00,$00,$00,$00 ; B140  metatiles $40-$4F
        .byte   $02,$02,$02,$02,$00,$02,$00,$00,$02,$00,$02,$02,$02,$02,$02,$02 ; B150  metatiles $50-$5F
        .byte   $03,$03,$02,$03,$03,$03,$03,$00,$03,$03,$02,$03,$03,$03,$03,$00 ; B160  metatiles $60-$6F
        .byte   $03,$03,$03,$03,$03,$03,$03,$00,$02,$01,$03,$03,$03,$03,$03,$00 ; B170  metatiles $70-$7F
        .byte   $11,$11,$11,$11,$11,$10,$11,$11,$11,$11,$11,$00,$00,$10,$11,$11 ; B180  metatiles $80-$8F
        .byte   $60,$60,$11,$00,$00,$10,$11,$11,$00,$00,$11,$00,$00,$10,$11,$11 ; B190  metatiles $90-$9F
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00 ; B1A0  metatiles $A0-$AF
        .byte   $03,$03,$00,$00,$03,$03,$03,$00,$03,$03,$00,$02,$03,$03,$03,$00 ; B1B0  metatiles $B0-$BF
        .byte   $03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1C0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1D0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1E0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1F0  metatiles $F0-$FF
; --- $B200: 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $26,$24,$24,$26,$26,$24,$16,$17,$26,$2F,$24,$26,$02,$24,$02,$2F ; B200  blocks $00-$03
        .byte   $26,$02,$2F,$02,$2F,$24,$24,$26,$86,$87,$96,$97,$26,$24,$5E,$5F ; B210  blocks $04-$07
        .byte   $26,$24,$5E,$5E,$02,$24,$02,$5F,$26,$02,$5E,$02,$86,$87,$8E,$8F ; B220  blocks $08-$0B
        .byte   $42,$40,$24,$26,$42,$42,$08,$24,$02,$40,$25,$25,$42,$02,$25,$25 ; B230  blocks $0C-$0F
        .byte   $42,$40,$26,$08,$42,$42,$24,$26,$8E,$8F,$8E,$8F,$5E,$5F,$42,$40 ; B240  blocks $10-$13
        .byte   $02,$5E,$02,$42,$5E,$24,$42,$2F,$26,$5E,$2F,$42,$5E,$02,$42,$02 ; B250  blocks $14-$17
        .byte   $5E,$5E,$42,$42,$8E,$8F,$96,$97,$42,$42,$4A,$4A,$24,$25,$5E,$5F ; B260  blocks $18-$1B
        .byte   $25,$26,$5E,$5E,$42,$40,$4A,$48,$86,$87,$9E,$9F,$42,$42,$42,$42 ; B270  blocks $1C-$1F
        .byte   $42,$40,$42,$40,$20,$21,$28,$29,$21,$22,$29,$2A,$26,$2F,$16,$17 ; B280  blocks $20-$23
        .byte   $21,$22,$29,$1B,$2F,$2F,$24,$26,$02,$5F,$02,$40,$5E,$53,$4A,$58 ; B290  blocks $24-$27
        .byte   $00,$24,$00,$2F,$26,$00,$2F,$00,$00,$00,$00,$00,$02,$40,$02,$2F ; B2A0  blocks $28-$2B
        .byte   $4A,$58,$24,$26,$00,$24,$24,$26,$26,$00,$24,$26,$00,$00,$90,$91 ; B2B0  blocks $2C-$2F
        .byte   $1D,$1C,$24,$26,$26,$24,$5E,$53,$26,$24,$00,$2F,$26,$1C,$2F,$00 ; B2C0  blocks $30-$33
        .byte   $91,$90,$00,$00,$02,$40,$02,$48,$4A,$58,$4A,$58,$61,$24,$69,$2F ; B2D0  blocks $34-$37
        .byte   $26,$60,$2F,$68,$61,$60,$69,$68,$08,$24,$02,$2F,$26,$08,$2F,$02 ; B2E0  blocks $38-$3B
        .byte   $26,$24,$5E,$2F,$42,$5E,$42,$42,$4A,$48,$4A,$48,$4A,$4A,$4A,$4A ; B2F0  blocks $3C-$3F
        .byte   $4A,$50,$4A,$58,$30,$32,$38,$3A,$26,$48,$2F,$48,$42,$40,$08,$2F ; B300  blocks $40-$43
        .byte   $51,$51,$00,$6A,$51,$51,$00,$00,$52,$48,$5A,$48,$00,$62,$00,$62 ; B310  blocks $44-$47
        .byte   $5A,$48,$5A,$48,$2F,$40,$24,$26,$42,$2F,$24,$26,$33,$33,$3B,$3B ; B320  blocks $48-$4B
        .byte   $33,$24,$3B,$2F,$26,$24,$3C,$3D,$00,$24,$00,$00,$26,$24,$00,$00 ; B330  blocks $4C-$4F
        .byte   $00,$00,$00,$59,$55,$53,$5A,$58,$00,$00,$00,$6A,$00,$59,$00,$59 ; B340  blocks $50-$53
        .byte   $5A,$58,$5A,$58,$61,$60,$24,$26,$42,$42,$51,$51,$42,$40,$52,$48 ; B350  blocks $54-$57
        .byte   $42,$42,$50,$51,$58,$00,$58,$00,$58,$61,$58,$69,$2F,$24,$1C,$1D ; B360  blocks $58-$5B
        .byte   $71,$70,$5C,$5C,$51,$51,$63,$63,$26,$24,$55,$5F,$26,$2F,$53,$00 ; B370  blocks $5C-$5F
        .byte   $5A,$48,$5D,$48,$58,$71,$5B,$5C,$71,$70,$34,$36,$0D,$0E,$5E,$5F ; B380  blocks $60-$63
        .byte   $42,$42,$0D,$0E,$5E,$5E,$51,$51,$31,$32,$39,$3A,$61,$60,$08,$68 ; B390  blocks $64-$67
        .byte   $02,$70,$02,$00,$71,$70,$00,$00,$58,$71,$58,$00,$02,$00,$02,$5C ; B3A0  blocks $68-$6B
        .byte   $00,$00,$5C,$5C,$5B,$5C,$4A,$4A,$5C,$5C,$4A,$4A,$02,$42,$02,$42 ; B3B0  blocks $6C-$6F
        .byte   $42,$03,$42,$4B,$42,$03,$03,$4B,$42,$03,$03,$5F,$4B,$42,$42,$42 ; B3C0  blocks $70-$73
        .byte   $4B,$40,$42,$40,$04,$04,$4B,$4B,$25,$26,$63,$63,$51,$51,$65,$66 ; B3D0  blocks $74-$77
        .byte   $50,$51,$58,$63,$6B,$6B,$64,$64,$6D,$6E,$75,$05,$6B,$6B,$06,$64 ; B3E0  blocks $78-$7B
        .byte   $58,$6B,$58,$64,$7D,$7B,$75,$76,$72,$6B,$6C,$64,$58,$6B,$05,$06 ; B3F0  blocks $7C-$7F
        .byte   $6B,$6B,$73,$73,$7D,$7E,$75,$76,$53,$72,$58,$73,$04,$04,$4B,$5F ; B400  blocks $80-$83
        .byte   $6B,$6B,$6B,$6B,$6B,$6B,$05,$06,$72,$72,$64,$64,$5A,$48,$5A,$0D ; B410  blocks $84-$87
        .byte   $58,$6B,$0E,$64,$5A,$5F,$5A,$48,$53,$6B,$58,$64,$72,$72,$73,$73 ; B420  blocks $88-$8B
        .byte   $58,$6B,$58,$73,$78,$78,$63,$63,$78,$78,$65,$66,$6D,$6E,$75,$76 ; B430  blocks $8C-$8F
        .byte   $0D,$0E,$72,$72,$6B,$6B,$6C,$64,$05,$06,$72,$72,$32,$AA,$3A,$AA ; B440  blocks $90-$93
        .byte   $AA,$AA,$AA,$AA,$02,$00,$02,$AA,$00,$00,$AA,$AA,$00,$00,$C0,$C1 ; B450  blocks $94-$97
        .byte   $00,$24,$AA,$2F,$02,$AA,$02,$AA,$C0,$C1,$C0,$C1,$AA,$24,$AA,$2F ; B460  blocks $98-$9B
        .byte   $31,$31,$39,$39,$30,$31,$38,$39,$33,$00,$3B,$AA,$A6,$A7,$A0,$A1 ; B470  blocks $9C-$9F
        .byte   $00,$00,$A2,$A2,$A0,$A1,$A0,$A1,$34,$35,$00,$00,$36,$A2,$00,$A2 ; B480  blocks $A0-$A3
        .byte   $A2,$A2,$A2,$A2,$36,$AA,$00,$AA,$36,$AA,$35,$36,$AA,$AA,$34,$36 ; B490  blocks $A4-$A7
        .byte   $AA,$AA,$08,$AA,$88,$82,$88,$82,$83,$84,$83,$84,$37,$37,$3B,$3B ; B4A0  blocks $A8-$AB
        .byte   $A6,$A7,$A0,$A9,$A0,$A9,$A0,$A9,$A0,$34,$A0,$A3,$35,$35,$A4,$A4 ; B4B0  blocks $AC-$AF
        .byte   $35,$35,$A6,$A3,$35,$36,$A4,$A4,$34,$35,$A5,$A5,$AA,$AA,$AB,$AB ; B4C0  blocks $B0-$B3
        .byte   $37,$3D,$37,$2F,$3C,$3D,$24,$26,$37,$3D,$37,$26,$37,$24,$3B,$2F ; B4D0  blocks $B4-$B7
        .byte   $34,$35,$A4,$A4,$03,$03,$A4,$A4,$83,$89,$83,$89,$33,$33,$37,$37 ; B4E0  blocks $B8-$BB
        .byte   $83,$82,$83,$82,$03,$03,$34,$36,$37,$24,$37,$2F,$26,$2F,$8A,$36 ; B4F0  blocks $BC-$BF
        .byte   $92,$3C,$9A,$36,$2F,$24,$8A,$36,$3D,$2F,$24,$26,$26,$24,$8A,$36 ; B500  blocks $C0-$C3
        .byte   $2F,$3C,$24,$26,$37,$30,$37,$38,$20,$95,$28,$9D,$37,$24,$8A,$36 ; B510  blocks $C4-$C7
        .byte   $95,$22,$9D,$2A,$2F,$2F,$A6,$A7,$3D,$24,$24,$26,$26,$00,$2F,$A2 ; B520  blocks $C8-$CB
        .byte   $26,$A2,$2F,$A2,$00,$A2,$A2,$A2,$A6,$A7,$A0,$B1,$00,$02,$00,$02 ; B530  blocks $CC-$CF
        .byte   $A0,$B1,$A0,$B1,$A0,$B1,$24,$26,$00,$00,$2F,$00,$AA,$00,$AA,$AA ; B540  blocks $D0-$D3
        .byte   $00,$00,$24,$26,$A0,$B1,$34,$36,$2F,$24,$34,$36,$26,$2F,$34,$35 ; B550  blocks $D4-$D7
        .byte   $3C,$3D,$35,$36,$02,$AA,$24,$26,$2F,$24,$16,$17,$26,$AA,$24,$26 ; B560  blocks $D8-$DB
        .byte   $00,$00,$2F,$08,$21,$21,$18,$19,$B8,$B8,$00,$00,$A0,$B9,$A0,$B1 ; B570  blocks $DC-$DF
        .byte   $BB,$BB,$BB,$BB,$A0,$B9,$A0,$B4,$B8,$B8,$B5,$B6,$A0,$BC,$A0,$BC ; B580  blocks $E0-$E3
        .byte   $BD,$BE,$24,$26,$BD,$BE,$BD,$BE,$33,$24,$37,$2F,$BB,$BB,$08,$2F ; B590  blocks $E4-$E7
        .byte   $08,$34,$02,$00,$36,$B9,$A6,$B1,$02,$BB,$02,$BB,$02,$B8,$02,$00 ; B5A0  blocks $E8-$EB
        .byte   $88,$82,$24,$26,$83,$89,$24,$26,$33,$30,$37,$38,$2F,$24,$00,$00 ; B5B0  blocks $EC-$EF
        .byte   $26,$24,$A6,$A7,$26,$24,$88,$81,$26,$B8,$89,$00,$2F,$24,$00,$09 ; B5C0  blocks $F0-$F3
        .byte   $33,$24,$37,$88,$AA,$09,$AA,$09,$BB,$BB,$24,$26,$26,$24,$34,$36 ; B5D0  blocks $F4-$F7
        .byte   $26,$24,$00,$09,$20,$21,$18,$19,$26,$00,$2F,$AA,$26,$AA,$2F,$AA ; B5E0  blocks $F8-$FB
        .byte   $26,$AA,$00,$AA,$1E,$1F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5F0  blocks $FC-$FF
; --- $B600: screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$01,$02,$03,$04,$05,$00,$00,$06,$07,$08,$09,$0A,$07,$08,$06 ; B600
        .byte   $0B,$0C,$0D,$0E,$0F,$10,$11,$0B,$12,$13,$14,$15,$16,$17,$18,$12 ; B610
        .byte   $19,$0C,$1A,$1B,$1C,$1D,$11,$19,$1E,$13,$1F,$20,$1F,$20,$18,$1E ; B620
        .byte   $21,$22,$05,$23,$21,$22,$05,$23,$02,$21,$22,$05,$00,$00,$00,$00 ; B630
; layout $01
        .byte   $22,$03,$01,$02,$21,$24,$21,$22,$02,$03,$00,$00,$02,$21,$22,$25 ; B640
        .byte   $02,$26,$27,$28,$29,$2A,$28,$00,$22,$2B,$2C,$2D,$2E,$2F,$2D,$30 ; B650
        .byte   $02,$09,$31,$32,$33,$34,$32,$01,$24,$35,$36,$37,$38,$39,$37,$00 ; B660
        .byte   $21,$22,$25,$3A,$3B,$25,$21,$22,$00,$00,$02,$03,$04,$05,$00,$00 ; B670
; layout $02
        .byte   $06,$05,$00,$30,$00,$01,$02,$21,$06,$13,$18,$15,$30,$08,$07,$3C ; B680
        .byte   $0B,$20,$1F,$3D,$18,$1F,$20,$3D,$19,$3E,$3F,$3F,$3F,$3F,$3E,$40 ; B690
        .byte   $06,$3E,$3F,$3F,$41,$05,$42,$36,$1E,$1D,$1A,$1A,$21,$22,$42,$36 ; B6A0
        .byte   $22,$43,$11,$11,$25,$21,$22,$05,$02,$03,$00,$00,$00,$00,$00,$00 ; B6B0
; layout $03
        .byte   $22,$21,$24,$21,$22,$05,$00,$00,$00,$02,$18,$13,$13,$18,$05,$00 ; B6C0
        .byte   $18,$18,$1F,$20,$20,$1F,$18,$13,$44,$44,$45,$46,$3E,$3F,$3F,$3E ; B6D0
        .byte   $47,$47,$2A,$48,$3E,$3F,$3F,$3E,$39,$39,$05,$42,$3E,$3F,$3F,$3E ; B6E0
        .byte   $23,$21,$22,$49,$0C,$11,$11,$4A,$00,$00,$00,$00,$00,$00,$00,$00 ; B6F0
; layout $04
        .byte   $00,$01,$00,$02,$4B,$25,$4C,$01,$00,$00,$01,$00,$4D,$02,$21,$24 ; B700
        .byte   $27,$4E,$4F,$32,$02,$21,$24,$21,$36,$2A,$2A,$50,$51,$52,$52,$50 ; B710
        .byte   $36,$2A,$2A,$53,$54,$47,$47,$53,$36,$39,$55,$39,$54,$39,$39,$55 ; B720
        .byte   $21,$22,$21,$24,$25,$21,$22,$05,$00,$00,$00,$00,$00,$00,$00,$00 ; B730
; layout $05
        .byte   $00,$00,$30,$00,$00,$00,$00,$30,$25,$18,$18,$18,$13,$18,$18,$05 ; B740
        .byte   $24,$56,$56,$56,$57,$58,$56,$21,$51,$52,$52,$2A,$48,$59,$2A,$05 ; B750
        .byte   $54,$47,$47,$2A,$48,$59,$2A,$21,$54,$39,$39,$39,$48,$5A,$39,$5B ; B760
        .byte   $02,$21,$24,$21,$24,$25,$5C,$21,$00,$00,$00,$30,$00,$02,$5D,$05 ; B770
; layout $06
        .byte   $21,$24,$33,$4F,$5E,$5F,$2A,$21,$22,$39,$39,$39,$48,$5A,$39,$21 ; B780
        .byte   $02,$5C,$5C,$5C,$60,$61,$62,$05,$24,$3F,$3F,$3F,$63,$1F,$18,$21 ; B790
        .byte   $02,$1A,$64,$1A,$1D,$58,$56,$21,$24,$56,$65,$56,$57,$59,$2A,$5B ; B7A0
        .byte   $66,$67,$39,$39,$48,$5A,$39,$21,$02,$68,$69,$69,$48,$6A,$69,$5B ; B7B0
; layout $07
        .byte   $24,$6B,$6C,$6C,$60,$6D,$6E,$21,$24,$6F,$70,$71,$72,$71,$71,$5B ; B7C0
        .byte   $02,$1F,$1F,$73,$74,$73,$73,$75,$5B,$76,$77,$5D,$46,$78,$77,$5D ; B7D0
        .byte   $24,$79,$7A,$7B,$48,$7C,$7A,$7B,$24,$79,$7D,$7E,$48,$7F,$7D,$7E ; B7E0
        .byte   $02,$80,$81,$80,$48,$82,$81,$80,$24,$2A,$81,$2A,$48,$59,$81,$2A ; B7F0
; layout $08
        .byte   $24,$5B,$08,$08,$08,$08,$08,$08,$30,$02,$78,$5D,$5D,$5D,$5D,$5D ; B800
        .byte   $75,$83,$7C,$84,$84,$85,$84,$84,$5D,$46,$7C,$85,$79,$86,$79,$85 ; B810
        .byte   $79,$87,$88,$86,$79,$79,$79,$86,$85,$89,$8A,$79,$79,$79,$79,$79 ; B820
        .byte   $8B,$48,$8C,$80,$80,$80,$80,$80,$2A,$48,$59,$2A,$2A,$2A,$2A,$2A ; B830
; layout $09
        .byte   $08,$08,$08,$30,$02,$21,$24,$03,$5D,$5D,$77,$8D,$8E,$8D,$8E,$03 ; B840
        .byte   $84,$84,$8F,$84,$8F,$84,$8F,$03,$79,$90,$81,$91,$81,$91,$81,$03 ; B850
        .byte   $79,$79,$81,$90,$81,$91,$81,$28,$79,$79,$81,$91,$81,$92,$81,$28 ; B860
        .byte   $80,$80,$81,$80,$81,$80,$81,$28,$2A,$2A,$81,$2A,$81,$2A,$81,$28 ; B870
; layout $0A
        .byte   $93,$94,$95,$96,$97,$96,$97,$98,$93,$94,$99,$94,$9A,$94,$9A,$9B ; B880
        .byte   $9C,$9C,$9C,$66,$9D,$9C,$66,$3A,$9E,$96,$96,$96,$97,$96,$97,$03 ; B890
        .byte   $3B,$9D,$9C,$66,$9D,$9C,$9C,$9C,$04,$96,$96,$96,$97,$96,$97,$98 ; B8A0
        .byte   $22,$21,$22,$21,$24,$21,$24,$3A,$00,$00,$00,$00,$00,$00,$02,$03 ; B8B0
; layout $0B
        .byte   $9D,$66,$21,$24,$05,$00,$00,$00,$9E,$96,$96,$96,$9F,$A0,$A0,$A0 ; B8C0
        .byte   $93,$94,$94,$94,$A1,$A2,$A3,$A4,$93,$94,$A2,$A5,$A1,$A4,$A4,$A4 ; B8D0
        .byte   $A6,$A7,$A8,$94,$A1,$A4,$A4,$A4,$9E,$96,$99,$94,$A1,$A4,$A4,$A4 ; B8E0
        .byte   $93,$94,$03,$02,$21,$24,$A9,$AA,$A6,$94,$03,$00,$30,$00,$30,$00 ; B8F0
; layout $0C
        .byte   $02,$AB,$9D,$66,$9D,$66,$9D,$66,$AC,$96,$96,$96,$96,$9F,$9F,$A0 ; B900
        .byte   $AD,$94,$94,$94,$94,$A1,$AE,$AF,$AD,$94,$94,$94,$94,$AE,$B0,$B1 ; B910
        .byte   $AD,$94,$94,$94,$B2,$B0,$B0,$AF,$AD,$94,$94,$A9,$AA,$9D,$66,$A9 ; B920
        .byte   $9D,$66,$B3,$25,$B4,$B5,$B6,$25,$02,$B4,$2A,$02,$B7,$02,$B7,$02 ; B930
; layout $0D
        .byte   $9D,$9C,$9C,$66,$9D,$9C,$9C,$66,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$9D ; B940
        .byte   $B1,$B8,$B1,$B8,$B1,$A4,$A4,$9D,$B8,$B1,$B8,$AF,$B1,$A4,$A4,$9D ; B950
        .byte   $B1,$B8,$AF,$B1,$B9,$A4,$A4,$9D,$BA,$BB,$A9,$BC,$BA,$A4,$BD,$41 ; B960
        .byte   $B4,$AB,$B5,$B4,$25,$A4,$9D,$66,$BE,$00,$00,$BE,$02,$A4,$05,$00 ; B970
; layout $0E
        .byte   $BE,$01,$00,$B7,$02,$A4,$05,$00,$B7,$9D,$66,$96,$9F,$A4,$9D,$66 ; B980
        .byte   $21,$24,$25,$94,$A1,$A4,$21,$22,$BF,$96,$96,$94,$A1,$A4,$9D,$66 ; B990
        .byte   $C0,$C1,$02,$94,$A1,$A4,$21,$24,$BF,$C0,$C2,$94,$A1,$05,$00,$C3 ; B9A0
        .byte   $C0,$05,$02,$94,$A1,$A0,$C4,$C0,$00,$00,$02,$94,$A1,$A4,$05,$00 ; B9B0
; layout $0F
        .byte   $02,$21,$24,$94,$A1,$A4,$05,$C3,$00,$C3,$02,$94,$A1,$A4,$C4,$C0 ; B9C0
        .byte   $C4,$C0,$C2,$94,$A1,$A4,$05,$C5,$AC,$05,$02,$94,$25,$C6,$24,$C7 ; B9D0
        .byte   $AD,$9D,$66,$94,$C6,$C8,$C4,$C0,$AD,$9D,$66,$94,$C9,$A0,$A0,$A0 ; B9E0
        .byte   $AD,$05,$02,$94,$A1,$A4,$C6,$24,$A1,$05,$00,$00,$00,$00,$00,$00 ; B9F0
; layout $10
        .byte   $00,$00,$00,$12,$00,$12,$00,$12,$CA,$CB,$AC,$19,$96,$19,$96,$19 ; BA00
        .byte   $66,$CC,$AD,$06,$94,$06,$94,$06,$00,$CC,$AD,$06,$94,$06,$94,$06 ; BA10
        .byte   $CA,$CC,$AD,$96,$94,$96,$94,$96,$A0,$CD,$AD,$1E,$94,$1E,$94,$1E ; BA20
        .byte   $05,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BA30
; layout $11
        .byte   $00,$12,$C6,$24,$05,$00,$04,$21,$96,$19,$96,$05,$00,$01,$04,$05 ; BA40
        .byte   $94,$06,$94,$25,$C6,$24,$04,$5B,$94,$06,$94,$21,$24,$05,$04,$21 ; BA50
        .byte   $94,$96,$94,$96,$CE,$2A,$CF,$21,$94,$1E,$94,$1E,$D0,$2A,$CF,$21 ; BA60
        .byte   $00,$00,$01,$02,$D1,$D2,$2A,$21,$00,$00,$00,$00,$00,$29,$2A,$21 ; BA70
; layout $12
        .byte   $41,$03,$02,$C6,$C8,$05,$BE,$BE,$02,$95,$96,$98,$00,$00,$BE,$9D ; BA80
        .byte   $66,$99,$94,$D3,$CE,$2A,$9D,$66,$66,$99,$94,$94,$D0,$D4,$9D,$66 ; BA90
        .byte   $02,$99,$94,$A7,$D5,$D6,$D7,$D8,$22,$D9,$94,$96,$CE,$2A,$2A,$9D ; BAA0
        .byte   $21,$24,$DA,$DB,$D1,$D4,$DC,$05,$00,$0B,$00,$00,$00,$00,$04,$05 ; BAB0
; layout $13
        .byte   $21,$22,$C6,$C8,$21,$24,$DD,$DD,$22,$2A,$CE,$2A,$CE,$2A,$CE,$2A ; BAC0
        .byte   $02,$DE,$DF,$DE,$D0,$E0,$D0,$E0,$02,$E0,$D0,$E0,$E1,$E2,$E1,$E2 ; BAD0
        .byte   $66,$E2,$E1,$E2,$E3,$E4,$21,$24,$02,$E5,$E3,$E4,$21,$22,$05,$00 ; BAE0
        .byte   $41,$3A,$00,$00,$01,$00,$E6,$9D,$02,$03,$00,$00,$00,$00,$BE,$00 ; BAF0
; layout $14
        .byte   $DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$CE,$2A,$CE,$2A,$CE,$2A,$CE,$2A ; BB00
        .byte   $D0,$E0,$D0,$E0,$D0,$E0,$D0,$E7,$DF,$DE,$DF,$E8,$E9,$DE,$DF,$03 ; BB10
        .byte   $02,$E0,$D0,$EA,$D0,$E0,$D0,$03,$02,$DE,$DF,$EB,$DF,$DE,$EC,$ED ; BB20
        .byte   $66,$E0,$05,$29,$D0,$E0,$05,$02,$02,$2A,$05,$29,$D0,$2A,$05,$E6 ; BB30
; layout $15
        .byte   $DD,$DD,$DD,$C6,$C8,$C6,$C8,$EE,$CE,$2A,$CE,$EF,$F0,$4F,$F0,$B7 ; BB40
        .byte   $D1,$D2,$D0,$E0,$D0,$E0,$AD,$D6,$F1,$F2,$DF,$DE,$DF,$DE,$AD,$D6 ; BB50
        .byte   $00,$29,$D0,$E0,$D0,$E0,$AD,$F3,$F4,$F2,$DF,$DE,$DF,$DE,$AD,$F5 ; BB60
        .byte   $BE,$2E,$D1,$F6,$9D,$66,$C6,$C8,$BE,$00,$02,$9D,$66,$9D,$66,$05 ; BB70
; layout $16
        .byte   $66,$EE,$66,$C5,$66,$C6,$C8,$AB,$BE,$B7,$00,$BE,$00,$01,$00,$E6 ; BB80
        .byte   $BE,$00,$F7,$B7,$01,$02,$D6,$B7,$B7,$00,$00,$00,$00,$00,$00,$00 ; BB90
        .byte   $4F,$4F,$4F,$4F,$4F,$4F,$4F,$F8,$94,$94,$9A,$94,$94,$94,$9A,$F5 ; BBA0
        .byte   $21,$22,$21,$22,$21,$22,$F9,$DD,$00,$00,$00,$00,$00,$00,$00,$02 ; BBB0
; layout $17
        .byte   $F9,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$FA,$96,$97,$96,$96,$97,$96,$98 ; BBC0
        .byte   $FB,$94,$9A,$94,$94,$9A,$94,$9B,$FB,$94,$9A,$94,$94,$9A,$94,$9B ; BBD0
        .byte   $FC,$94,$9A,$94,$94,$9A,$94,$9B,$94,$94,$9A,$94,$94,$9A,$94,$9B ; BBE0
        .byte   $DD,$DD,$DD,$DD,$DD,$DD,$DD,$DD,$FD,$FD,$FD,$FD,$FD,$FD,$FD,$FD ; BBF0
; layout $18
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BC00
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BC10
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BC20
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BC30
; layout $19
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BC40
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BC50
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BC60
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BC70
; layout $1A
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BC80
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BC90
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BCA0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BCB0
; layout $1B
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BCC0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BCD0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BCE0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BCF0
; layout $1C
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BD00
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BD10
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BD20
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BD30
; layout $1D
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BD40
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BD50
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BD60
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BD70
; layout $1E
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BD80
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BD90
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BDA0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BDB0
; layout $1F
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BDC0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BDD0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BDE0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BDF0
; layout $20
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BE00
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BE10
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BE20
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BE30
; layout $21
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BE40
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BE50
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BE60
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BE70
; layout $22
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BE80
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BE90
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BEA0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BEB0
; layout $23
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BEC0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BED0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BEE0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BEF0
; layout $24
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BF00
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BF10
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BF20
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BF30
; layout $25
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BF40
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BF50
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BF60
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BF70
; layout $26
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BF80
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BF90
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BFA0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BFB0
; layout $27
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BFC0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BFD0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BFE0
        .byte   $2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A,$2A ; BFF0
