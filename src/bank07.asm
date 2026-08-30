.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK07"

; =============================================================================
; BANK $07 (mapped at $A000) — GRAVITY/CRYSTAL/WAVE MAN AI + CRYSTAL MAN
; STAGE DATA
; Data half (file +$0900 on): stage $07 (Crystal Man) stage data —
; screen table at $A900 with this bank at $A000; format in
; DATA_REFERENCE.md section 11.
; =============================================================================
L0000           := $0000
L0002           := $0002
L0004           := $0004
L000C           := $000C
L0011           := $0011
L0020           := $0020
L0040           := $0040
L0044           := $0044
L00A0           := $00A0
L00A2           := $00A2
L0101           := $0101
L0210           := $0210
L0B05           := $0B05
L0C21           := $0C21
L10F0           := $10F0
L111C           := $111C
L1210           := $1210
L1321           := $1321
L1501           := $1501
L181B           := $181B
L1821           := $1821
L1C21           := $1C21
L1D1C           := $1D1C
L1D7F           := $1D7F
L1E1D           := $1E1D
L1F4F           := $1F4F
L2000           := $2000
L2010           := $2010
L201F           := $201F
L2121           := $2121
L21A2           := $21A2
L2420           := $2420
L2421           := $2421
L353F           := $353F
L361F           := $361F
L3725           := $3725
L3E6B           := $3E6B
L4000           := $4000
L4046           := $4046
L4337           := $4337
L466D           := $466D
L5021           := $5021
L5050           := $5050
L5221           := $5221
L5354           := $5354
L5C5A           := $5C5A
L6414           := $6414
L6AAB           := $6AAB
L6C68           := $6C68
L6C6A           := $6C6A
L8081           := $8081
L82B8           := $82B8
L850B           := $850B
L851A           := $851A
L852F           := $852F
L8538           := $8538
L854D           := $854D
L8B6A           := $8B6A
L9B43           := $9B43
LD3CC           := $D3CC
LE7A8           := $E7A8
LE979           := $E979
LE999           := $E999
LEA29           := $EA29
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $81 — GRAVITY MAN (boss of stage $00). Script-driven:
; state index $0468 steps 0-$0B through the tables at LA245-LA274
; (dir, sub_type, xvel) and dispatches through LA281/LA284 to three
; handlers: $A032 FLIP — at the anim beat, toggles gravity_flip and
; the player's vflip, then floats himself to the ceiling ($A051, Y
; < $70 = ceiling half) or drops to the floor ($A082); $A0D0 WALK to
; the per-state target X (LA275); $A0FF FIRE — pauses, then his shot
; anim ($1C:850B in LA1D0) spawns a type $82 bullet at the throw
; frame ($A1EA, aimed 16-dir, speed preset $07 sped up on the
; ceiling). Jump states use yvel $FB.1A up / $04.79 down by gravity
; side ($A126). Fire cadence from LA287.
; =============================================================================
        ldy     $0468,x                         ; A000 BC 68 04                 .h.
        lda     LA25D,y                         ; A003 B9 5D A2                 .].
        sta     $03A8,x                         ; A006 9D A8 03                 ...
        lda     LA269,y                         ; A009 B9 69 A2                 .i.
        sta     $03C0,x                         ; A00C 9D C0 03                 ...
        lda     LA245,y                         ; A00F B9 45 A2                 .E.
        sta     $0420,x                         ; A012 9D 20 04                 . .
        lda     LA251,y                         ; A015 B9 51 A2                 .Q.
        pha                                     ; A018 48                       H
        lsr     a                               ; A019 4A                       J
        tay                                     ; A01A A8                       .
        pla                                     ; A01B 68                       h
        jsr     entity_set_subtype                           ; A01C 20 98 EA                  ..
        lda     LA281,y                         ; A01F B9 81 A2                 ...
        sta     L0000                           ; A022 85 00                    ..
        sta     $0588,x                         ; A024 9D 88 05                 ...
        lda     LA284,y                         ; A027 B9 84 A2                 ...
        sta     $01                             ; A02A 85 01                    ..
        sta     $05A0,x                         ; A02C 9D A0 05                 ...
        jmp     (L0000)                         ; A02F 6C 00 00                 l..

; ----------------------------------------------------------------------------
        lda     $0540,x                         ; A032 BD 40 05                 .@.
        beq     LA081                           ; A035 F0 4A                    .J
        lda     #$31                            ; A037 A9 31                    .1
        jsr     entity_set_subtype                           ; A039 20 98 EA                  ..
        lda     $AF                             ; A03C A5 AF                    ..
        eor     #$01                            ; A03E 49 01                    I.
        sta     $AF                             ; A040 85 AF                    ..
        lda     $0528                           ; A042 AD 28 05                 .(.
        eor     #$40                            ; A045 49 40                    I@
        sta     $0528                           ; A047 8D 28 05                 .(.
        lda     $0528,x                         ; A04A BD 28 05                 .(.
        and     #$40                            ; A04D 29 40                    )@
        beq     LA082                           ; A04F F0 31                    .1
        lda     #$5E                            ; A051 A9 5E                    .^
        sta     $0588,x                         ; A053 9D 88 05
        lda     #$A0                            ; A056 A9 A0
        sta     $05A0,x                         ; A058 9D A0 05 behavior PC := $A05E
        jsr     entity_stop_y                           ; A05B 20 1E EA                  ..
        lda     $0378,x                         ; A05E BD 78 03                 .x.
        cmp     #$70                            ; A061 C9 70                    .p
        bcc     LA077                           ; A063 90 12                    ..
        lda     $0528,x                         ; A065 BD 28 05                 .(.
        and     #$BF                            ; A068 29 BF                    ).
        sta     $0528,x                         ; A06A 9D 28 05                 .(.
        lda     #$77                            ; A06D A9 77                    .w
        sta     $0588,x                         ; A06F 9D 88 05                 ...
        lda     #$A0                            ; A072 A9 A0                    ..
        sta     $05A0,x                         ; A074 9D A0 05                 ...
LA077:  jsr     LA1D0                           ; A077 20 D0 A1                  ..
        ldy     #$1C                            ; A07A A0 1C                    ..
        jsr     entity_gravity_collide                           ; A07C 20 B7 E7                  ..
        bcs     LA0B8                           ; A07F B0 37                    .7
LA081:  rts                                     ; A081 60                       `

; ----------------------------------------------------------------------------
LA082:  lda     #$8F                            ; A082 A9 8F                    ..
        sta     $0588,x                         ; A084 9D 88 05                 ...
        lda     #$A0                            ; A087 A9 A0                    ..
        sta     $05A0,x                         ; A089 9D A0 05                 ...
        jsr     LEA29                           ; A08C 20 29 EA                  ).
        lda     $0378,x                         ; A08F BD 78 03                 .x.
        cmp     #$70                            ; A092 C9 70                    .p
        bcs     LA0A8                           ; A094 B0 12                    ..
        lda     $0528,x                         ; A096 BD 28 05                 .(.
        ora     #$40                            ; A099 09 40                    .@
        sta     $0528,x                         ; A09B 9D 28 05                 .(.
        lda     #$A8                            ; A09E A9 A8                    ..
        sta     $0588,x                         ; A0A0 9D 88 05                 ...
        lda     #$A0                            ; A0A3 A9 A0                    ..
        sta     $05A0,x                         ; A0A5 9D A0 05                 ...
LA0A8:  jsr     LA1D0                           ; A0A8 20 D0 A1                  ..
        jsr     entity_apply_gravity                           ; A0AB 20 E1 E9                  ..
        jsr     LE999                           ; A0AE 20 99 E9                  ..
        ldy     #$1D                            ; A0B1 A0 1D                    ..
        jsr     LE7A8                           ; A0B3 20 A8 E7                  ..
        bcc     LA0CF                           ; A0B6 90 17                    ..
LA0B8:  lda     #$04                            ; A0B8 A9 04                    ..
        jsr     entity_set_subtype                           ; A0BA 20 98 EA                  ..
        lda     #$C7                            ; A0BD A9 C7                    ..
LA0BF:  sta     $0588,x                         ; A0BF 9D 88 05                 ...
        lda     #$A0                            ; A0C2 A9 A0                    ..
        sta     $05A0,x                         ; A0C4 9D A0 05                 ...
        lda     $0540,x                         ; A0C7 BD 40 05                 .@.
        beq     LA0CF                           ; A0CA F0 03                    ..
        jsr     LA1B6                           ; A0CC 20 B6 A1                  ..
LA0CF:  rts                                     ; A0CF 60                       `

; ----------------------------------------------------------------------------
        lda     $0558,x                         ; A0D0 BD 58 05                 .X.
        cmp     #$02                            ; A0D3 C9 02                    ..
        bne     LA0CF                           ; A0D5 D0 F8                    ..
        jsr     entity_facing_dispatch                           ; A0D7 20 65 EA                  e.
        ldy     $0468,x                         ; A0DA BC 68 04                 .h.
        lda     $0420,x                         ; A0DD BD 20 04                 . .
        and     #$01                            ; A0E0 29 01                    ).
        bne     LA0F1                           ; A0E2 D0 0D                    ..
        lda     LA275,y                         ; A0E4 B9 75 A2                 .u.
        cmp     $0330,x                         ; A0E7 DD 30 03                 .0.
        bcc     LA0CF                           ; A0EA 90 E3                    ..
        sta     $0330,x                         ; A0EC 9D 30 03                 .0.
        bne     LA0FC                           ; A0EF D0 0B                    ..
LA0F1:  lda     LA275,y                         ; A0F1 B9 75 A2                 .u.
        cmp     $0330,x                         ; A0F4 DD 30 03                 .0.
        bcs     LA0CF                           ; A0F7 B0 D6                    ..
        sta     $0330,x                         ; A0F9 9D 30 03                 .0.
LA0FC:  jmp     LA1B6                           ; A0FC 4C B6 A1                 L..

; ----------------------------------------------------------------------------
        lda     $0558,x                         ; A0FF BD 58 05                 .X.
        cmp     #$06                            ; A102 C9 06                    ..
        beq     LA0CF                           ; A104 F0 C9                    ..
        lda     $0558,x                         ; A106 BD 58 05                 .X.
        cmp     #$01                            ; A109 C9 01                    ..
        bne     LA121                           ; A10B D0 14                    ..
        lda     $0480,x                         ; A10D BD 80 04                 ...
        bne     LA117                           ; A110 D0 05                    ..
        lda     #$14                            ; A112 A9 14                    ..
        sta     $0480,x                         ; A114 9D 80 04                 ...
LA117:  dec     $0480,x                         ; A117 DE 80 04                 ...
        bne     LA0CF                           ; A11A D0 B3                    ..
        lda     #$04                            ; A11C A9 04                    ..
        jsr     entity_set_subtype                           ; A11E 20 98 EA                  ..
LA121:  lda     $0540,x                         ; A121 BD 40 05                 .@.
        beq     LA0CF                           ; A124 F0 A9                    ..
        lda     #$31                            ; A126 A9 31                    .1
        jsr     entity_set_subtype                           ; A128 20 98 EA                  ..
        lda     #$50                            ; A12B A9 50                    .P
        sta     $0588,x                         ; A12D 9D 88 05                 ...
        lda     #$A1                            ; A130 A9 A1                    ..
        sta     $05A0,x                         ; A132 9D A0 05                 ...
        lda     #$1A                            ; A135 A9 1A                    ..
        sta     $03D8,x                         ; A137 9D D8 03                 ...
        lda     #$FB                            ; A13A A9 FB                    ..
        sta     $03F0,x                         ; A13C 9D F0 03                 ...
        ldy     $0468,x                         ; A13F BC 68 04                 .h.
        cpy     #$05                            ; A142 C0 05                    ..
        beq     LA150                           ; A144 F0 0A                    ..
        lda     #$79                            ; A146 A9 79                    .y
        sta     $03D8,x                         ; A148 9D D8 03                 ...
        lda     #$04                            ; A14B A9 04                    ..
        sta     $03F0,x                         ; A14D 9D F0 03                 ...
LA150:  jsr     entity_facing_dispatch                           ; A150 20 65 EA                  e.
        jsr     LA1D0                           ; A153 20 D0 A1                  ..
        lda     $0528,x                         ; A156 BD 28 05                 .(.
        and     #$40                            ; A159 29 40                    )@
        bne     LA168                           ; A15B D0 0B                    ..
        jsr     entity_process_y_vel                           ; A15D 20 68 E9                  h.
        lda     #$B0                            ; A160 A9 B0                    ..
        cmp     $0378,x                         ; A162 DD 78 03                 .x.
        bcc     LA180                           ; A165 90 19                    ..
        rts                                     ; A167 60                       `

; ----------------------------------------------------------------------------
LA168:  lda     $03F0,x                         ; A168 BD F0 03                 ...
        bpl     LA173                           ; A16B 10 06                    ..
        jsr     LE979                           ; A16D 20 79 E9                  y.
        jmp     entity_apply_gravity                           ; A170 4C E1 E9                 L..

; ----------------------------------------------------------------------------
LA173:  jsr     LE999                           ; A173 20 99 E9                  ..
        jsr     entity_apply_gravity                           ; A176 20 E1 E9                  ..
        lda     #$30                            ; A179 A9 30                    .0
        cmp     $0378,x                         ; A17B DD 78 03                 .x.
        bcc     LA1CF                           ; A17E 90 4F                    .O
LA180:  sta     $0378,x                         ; A180 9D 78 03                 .x.
        ldy     $0468,x                         ; A183 BC 68 04                 .h.
        lda     LA275,y                         ; A186 B9 75 A2                 .u.
        sta     $0330,x                         ; A189 9D 30 03                 .0.
        lda     #$14                            ; A18C A9 14                    ..
        sta     $0480,x                         ; A18E 9D 80 04                 ...
        lda     #$A0                            ; A191 A9 A0                    ..
        sta     $0588,x                         ; A193 9D 88 05                 ...
        lda     #$A1                            ; A196 A9 A1                    ..
LA198:  sta     $05A0,x                         ; A198 9D A0 05                 ...
        lda     #$04                            ; A19B A9 04                    ..
        jsr     entity_set_subtype                           ; A19D 20 98 EA                  ..
        lda     #$01                            ; A1A0 A9 01                    ..
        cmp     $0558,x                         ; A1A2 DD 58 05                 .X.
        beq     LA1B1                           ; A1A5 F0 0A                    ..
        lda     $0540,x                         ; A1A7 BD 40 05                 .@.
        beq     LA1CF                           ; A1AA F0 23                    .#
        lda     #$01                            ; A1AC A9 01                    ..
        jsr     entity_set_subtype                           ; A1AE 20 98 EA                  ..
LA1B1:  dec     $0480,x                         ; A1B1 DE 80 04                 ...
        bne     LA1CF                           ; A1B4 D0 19                    ..
LA1B6:  lda     #$00                            ; A1B6 A9 00                    ..
        sta     $0588,x                         ; A1B8 9D 88 05                 ...
        lda     #$A0                            ; A1BB A9 A0                    ..
        sta     $05A0,x                         ; A1BD 9D A0 05                 ...
        inc     $0468,x                         ; A1C0 FE 68 04                 .h.
        lda     $0468,x                         ; A1C3 BD 68 04                 .h.
        cmp     #$0C                            ; A1C6 C9 0C                    ..
        bcc     LA1CF                           ; A1C8 90 05                    ..
        lda     #$00                            ; A1CA A9 00                    ..
        sta     $0468,x                         ; A1CC 9D 68 04                 .h.
LA1CF:  rts                                     ; A1CF 60                       `

; ----------------------------------------------------------------------------
LA1D0:  jsr     L850B                           ; A1D0 20 0B 85                  ..
        lda     $0558,x                         ; A1D3 BD 58 05                 .X.
        cmp     #$05                            ; A1D6 C9 05                    ..
        bne     LA21D                           ; A1D8 D0 43                    .C
        lda     $0570,x                         ; A1DA BD 70 05                 .p.
        cmp     #$08                            ; A1DD C9 08                    ..
        beq     LA1EA                           ; A1DF F0 09                    ..
        cmp     #$10                            ; A1E1 C9 10                    ..
        bne     LA244                           ; A1E3 D0 5F                    ._
        lda     #$31                            ; A1E5 A9 31                    .1
        jmp     entity_set_subtype                           ; A1E7 4C 98 EA                 L..

; ----------------------------------------------------------------------------
LA1EA:  stx     $0F                             ; A1EA 86 0F                    ..
        jsr     find_free_slot_y                           ; A1EC 20 6F F1                  o.
        bcs     LA244                           ; A1EF B0 53                    .S
        lda     #$87                            ; A1F1 A9 87                    ..
        sta     $0408,y                         ; A1F3 99 08 04                 ...
        lda     #$82                            ; A1F6 A9 82    Gravity Man's bullet
        sta     $0300,y                         ; A1F8 99 00 03                 ...
        lda     #$40                            ; A1FB A9 40                    .@
        sta     $10                             ; A1FD 85 10                    ..
LA1FF:  lda     $0528,x                         ; A1FF BD 28 05                 .(.
        and     #$20                            ; A202 29 20                    ) 
        beq     LA208                           ; A204 F0 02                    ..
        inc     $10                             ; A206 E6 10                    ..
LA208:  lda     #$07                            ; A208 A9 07                    ..
        jsr     entity_speed_preset                           ; A20A 20 F5 EA                  ..
        tya                                     ; A20D 98                       .
        tax                                     ; A20E AA                       .
        sta     $0E                             ; A20F 85 0E                    ..
        jsr     entity_distance_calc                           ; A211 20 C2 EC                  ..
        tay                                     ; A214 A8                       .
        lda     #$10                            ; A215 A9 10                    ..
        jsr     entity_set_dir_velocity                           ; A217 20 70 F4                  p.
        ldx     $0F                             ; A21A A6 0F                    ..
        rts                                     ; A21C 60                       `

; ----------------------------------------------------------------------------
LA21D:  lda     $0498,x                         ; A21D BD 98 04                 ...
        bne     LA23A                           ; A220 D0 18                    ..
        ldy     $04B0,x                         ; A222 BC B0 04                 ...
        lda     LA287,y                         ; A225 B9 87 A2                 ...
        sta     $0498,x                         ; A228 9D 98 04                 ...
        inc     $04B0,x                         ; A22B FE B0 04                 ...
        lda     $04B0,x                         ; A22E BD B0 04                 ...
        cmp     #$03                            ; A231 C9 03                    ..
        bcc     LA23A                           ; A233 90 05                    ..
        lda     #$00                            ; A235 A9 00                    ..
        sta     $04B0,x                         ; A237 9D B0 04                 ...
LA23A:  dec     $0498,x                         ; A23A DE 98 04                 ...
        bne     LA244                           ; A23D D0 05                    ..
        lda     #$05                            ; A23F A9 05                    ..
        jsr     entity_set_subtype                           ; A241 20 98 EA                  ..
LA244:  rts                                     ; A244 60                       `

; ----------------------------------------------------------------------------
LA245:  .byte   $08,$02,$04,$02,$08,$01,$04,$02,$08,$01,$04,$01 ; A245  dir per state
LA251:  .byte   $04,$02,$04,$02,$04,$01,$04,$01,$04,$02,$04,$02 ; A251  sub_type per state
LA25D:  .byte   $00,$00,$00,$00,$00,$10,$00,$3C,$00,$00,$00,$00 ; A25D  xvel sub per state
LA269:  .byte   $00,$02,$00,$02,$00,$03,$00,$02,$00,$02,$00,$02 ; A269  xvel px per state
LA275:  .byte   $D0,$80,$80,$30,$30,$A8,$A8,$58,$58,$80,$80,$D0 ; A275  target X per state
LA281:  .byte   $FF,$D0,$32 ; A281  handler PC lo
LA284:  .byte   $A0,$A0,$A0 ; A284  handler PC hi
LA287:  .byte   $50,$14,$14 ; A287  fire cadence
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR types $82/$85 — straight projectile (Gravity Man's bullet /
; Crystal Man's aimed eye): velocity as set by the spawner.
; =============================================================================
        jsr     entity_vert_dispatch_raw                           ; A28A 20 86 EA                  ..
        jmp     entity_facing_dispatch                           ; A28D 4C 65 EA                 Le.

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $83 — CRYSTAL MAN (boss of stage $07). On each anim
; start, picks far/near mode by distance ($50 px): index 0 = big slow
; bound, 1 = quick short hops (vel/PC tables LA428-LA433). While
; rising he may switch to the fire pose (sub $25, RNG for near mode):
; $A394 fires at the throw frames — far mode scatters four type $84
; crystal balls in the diagonal dirs ($A3C7, only one volley on
; screen), near mode snipes one aimed type $85 ($A403). Landing gives
; up to 3 chained re-hops ($A34A).
; =============================================================================
        lda     $0540,x                         ; A290 BD 40 05                 .@.
        beq     LA244                           ; A293 F0 AF                    ..
        jsr     entity_set_facing                           ; A295 20 16 EC                  ..
        jsr     entity_x_dist_px                           ; A298 20 94 EC                  ..
        ldy     #$00                            ; A29B A0 00                    ..
LA29D:  cmp     #$50                            ; A29D C9 50                    .P
        bcs     LA2A2                           ; A29F B0 01                    ..
        iny                                     ; A2A1 C8                       .
LA2A2:  lda     #$00                            ; A2A2 A9 00                    ..
        sta     $0468,x                         ; A2A4 9D 68 04                 .h.
        lda     LA430,y                         ; A2A7 B9 30 A4                 .0.
LA2AA:  sta     $03A8,x                         ; A2AA 9D A8 03                 ...
        lda     LA432,y                         ; A2AD B9 32 A4                 .2.
        sta     $03C0,x                         ; A2B0 9D C0 03                 ...
        lda     LA42C,y                         ; A2B3 B9 2C A4                 .,.
LA2B6:  sta     $03D8,x                         ; A2B6 9D D8 03                 ...
        lda     LA42E,y                         ; A2B9 B9 2E A4                 ...
        sta     $03F0,x                         ; A2BC 9D F0 03                 ...
        lda     LA428,y                         ; A2BF B9 28 A4                 .(.
        sta     $0588,x                         ; A2C2 9D 88 05                 ...
        lda     LA42A,y                         ; A2C5 B9 2A A4                 .*.
        sta     $05A0,x                         ; A2C8 9D A0 05                 ...
        tya                                     ; A2CB 98                       .
        sta     $0480,x                         ; A2CC 9D 80 04                 ...
        bne     LA30B                           ; A2CF D0 3A                    .:
        lda     $0558,x                         ; A2D1 BD 58 05                 .X.
        cmp     #$25                            ; A2D4 C9 25                    .%
        bne     LA2DB                           ; A2D6 D0 03                    ..
        jmp     LA394                           ; A2D8 4C 94 A3                 L..

; ----------------------------------------------------------------------------
LA2DB:  lda     $03F0,x                         ; A2DB BD F0 03                 ...
        bpl     LA2FA                           ; A2DE 10 1A                    ..
        ldy     #$17                            ; A2E0 A0 17                    ..
LA2E2:  lda     $0300,y                         ; A2E2 B9 00 03                 ...
        cmp     #$84                            ; A2E5 C9 84                    ..
        beq     LA2ED                           ; A2E7 F0 04                    ..
        cmp     #$85                            ; A2E9 C9 85                    ..
        bne     LA2F0                           ; A2EB D0 03                    ..
LA2ED:  jmp     LA3B1                           ; A2ED 4C B1 A3                 L..

; ----------------------------------------------------------------------------
LA2F0:  dey                                     ; A2F0 88                       .
        cpy     #$07                            ; A2F1 C0 07                    ..
        bcs     LA2E2                           ; A2F3 B0 ED                    ..
        lda     #$25                            ; A2F5 A9 25                    .%
        jmp     entity_set_subtype                           ; A2F7 4C 98 EA                 L..

; ----------------------------------------------------------------------------
LA2FA:  lda     #$00                            ; A2FA A9 00                    ..
        sta     $0570,x                         ; A2FC 9D 70 05                 .p.
        ldy     #$1C                            ; A2FF A0 1C                    ..
        jsr     entity_gravity_collide                           ; A301 20 B7 E7                  ..
        bcs     LA34A                           ; A304 B0 44                    .D
        ldy     #$1E                            ; A306 A0 1E                    ..
        jmp     entity_horiz_dispatch                           ; A308 4C 3F EA                 L?.

; ----------------------------------------------------------------------------
LA30B:  lda     $0558,x                         ; A30B BD 58 05                 .X.
        cmp     #$25                            ; A30E C9 25                    .%
        bne     LA315                           ; A310 D0 03                    ..
        jmp     LA394                           ; A312 4C 94 A3                 L..

; ----------------------------------------------------------------------------
LA315:  lda     $03F0,x                         ; A315 BD F0 03                 ...
        bpl     LA331                           ; A318 10 17                    ..
        lda     $E6                             ; A31A A5 E6                    ..
        adc     $E5                             ; A31C 65 E5                    e.
        and     #$01                            ; A31E 29 01                    ).
        bne     LA327                           ; A320 D0 05                    ..
        lda     #$25                            ; A322 A9 25                    .%
        jmp     entity_set_subtype                           ; A324 4C 98 EA                 L..

; ----------------------------------------------------------------------------
LA327:  lda     #$31                            ; A327 A9 31                    .1
        sta     $0588,x                         ; A329 9D 88 05                 ...
        lda     #$A3                            ; A32C A9 A3                    ..
        sta     $05A0,x                         ; A32E 9D A0 05                 ...
LA331:  lda     #$00                            ; A331 A9 00                    ..
        sta     $0570,x                         ; A333 9D 70 05                 .p.
        ldy     #$1C                            ; A336 A0 1C                    ..
        jsr     entity_gravity_collide                           ; A338 20 B7 E7                  ..
        bcs     LA34A                           ; A33B B0 0D                    ..
        ldy     #$1E                            ; A33D A0 1E                    ..
        jsr     entity_horiz_dispatch                           ; A33F 20 3F EA                  ?.
        bcc     LA347                           ; A342 90 03                    ..
        jsr     L852F                           ; A344 20 2F 85                  /.
LA347:  jmp     L850B                           ; A347 4C 0B 85                 L..

; ----------------------------------------------------------------------------
LA34A:  lda     #$02                            ; A34A A9 02                    ..
        sta     $0540,x                         ; A34C 9D 40 05                 .@.
        lda     #$59                            ; A34F A9 59                    .Y
        sta     $0588,x                         ; A351 9D 88 05                 ...
        lda     #$A3                            ; A354 A9 A3                    ..
        sta     $05A0,x                         ; A356 9D A0 05                 ...
        lda     $0570,x                         ; A359 BD 70 05                 .p.
        cmp     #$08                            ; A35C C9 08                    ..
        bne     LA393                           ; A35E D0 33                    .3
        lda     #$24                            ; A360 A9 24                    .$
        jsr     entity_set_subtype                           ; A362 20 98 EA                  ..
        lda     $0480,x                         ; A365 BD 80 04                 ...
        beq     LA384                           ; A368 F0 1A                    ..
        inc     $0498,x                         ; A36A FE 98 04                 ...
        lda     $0498,x                         ; A36D BD 98 04                 ...
        cmp     #$03                            ; A370 C9 03                    ..
        bcs     LA384                           ; A372 B0 10                    ..
        lda     #$01                            ; A374 A9 01                    ..
        sta     $0540,x                         ; A376 9D 40 05                 .@.
        jsr     entity_set_facing                           ; A379 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A37C 20 30 EC                  0.
        ldy     #$01                            ; A37F A0 01                    ..
        jmp     LA2A2                           ; A381 4C A2 A2                 L..

; ----------------------------------------------------------------------------
LA384:  lda     #$00                            ; A384 A9 00                    ..
        sta     $0498,x                         ; A386 9D 98 04                 ...
        lda     #$90                            ; A389 A9 90                    ..
        sta     $0588,x                         ; A38B 9D 88 05                 ...
        lda     #$A2                            ; A38E A9 A2                    ..
        sta     $05A0,x                         ; A390 9D A0 05                 ...
LA393:  rts                                     ; A393 60                       `

; ----------------------------------------------------------------------------
LA394:  lda     $0540,x                         ; A394 BD 40 05                 .@.
        cmp     #$08                            ; A397 C9 08                    ..
        bne     LA393                           ; A399 D0 F8                    ..
        lda     $0570,x                         ; A39B BD 70 05                 .p.
        beq     LA3C7                           ; A39E F0 27                    .'
        cmp     #$04                            ; A3A0 C9 04                    ..
        bne     LA393                           ; A3A2 D0 EF                    ..
        lda     #$24                            ; A3A4 A9 24                    .$
        jsr     entity_set_subtype                           ; A3A6 20 98 EA                  ..
        inc     $0540,x                         ; A3A9 FE 40 05                 .@.
        lda     $0480,x                         ; A3AC BD 80 04                 ...
        bne     LA3BC                           ; A3AF D0 0B                    ..
LA3B1:  lda     #$FA                            ; A3B1 A9 FA                    ..
        sta     $0588,x                         ; A3B3 9D 88 05                 ...
        lda     #$A2                            ; A3B6 A9 A2                    ..
        sta     $05A0,x                         ; A3B8 9D A0 05                 ...
        rts                                     ; A3BB 60                       `

; ----------------------------------------------------------------------------
LA3BC:  lda     #$31                            ; A3BC A9 31                    .1
        sta     $0588,x                         ; A3BE 9D 88 05                 ...
        lda     #$A3                            ; A3C1 A9 A3                    ..
        sta     $05A0,x                         ; A3C3 9D A0 05                 ...
        rts                                     ; A3C6 60                       `

; ----------------------------------------------------------------------------
LA3C7:  stx     $0F                             ; A3C7 86 0F                    ..
        lda     $0480,x                         ; A3C9 BD 80 04                 ...
        bne     LA403                           ; A3CC D0 35                    .5
        lda     #$02                            ; A3CE A9 02                    ..
        sta     $0E                             ; A3D0 85 0E                    ..
LA3D2:  jsr     find_free_slot_y                           ; A3D2 20 6F F1                  o.
        bcs     LA427                           ; A3D5 B0 50                    .P
        lda     #$87                            ; A3D7 A9 87                    ..
        sta     $0408,y                         ; A3D9 99 08 04                 ...
        lda     #$84                            ; A3DC A9 84                    ..
        sta     $0300,y                         ; A3DE 99 00 03                 ...
        lda     #$F0                            ; A3E1 A9 F0                    ..
        sta     $0468,y                         ; A3E3 99 68 04                 .h.
        lda     #$27                            ; A3E6 A9 27                    .'
        jsr     entity_init_pos                           ; A3E8 20 A4 EA                  ..
        tya                                     ; A3EB 98                       .
        tax                                     ; A3EC AA                       .
        ldy     $0E                             ; A3ED A4 0E                    ..
        lda     #$10                            ; A3EF A9 10                    ..
        jsr     entity_set_dir_velocity                           ; A3F1 20 70 F4                  p.
        ldx     $0F                             ; A3F4 A6 0F                    ..
        lda     $0E                             ; A3F6 A5 0E                    ..
        cmp     #$0E                            ; A3F8 C9 0E                    ..
        beq     LA427                           ; A3FA F0 2B                    .+
        clc                                     ; A3FC 18                       .
        adc     #$04                            ; A3FD 69 04                    i.
        sta     $0E                             ; A3FF 85 0E                    ..
        bne     LA3D2                           ; A401 D0 CF                    ..
LA403:  jsr     entity_distance_calc                           ; A403 20 C2 EC                  ..
        sta     $0E                             ; A406 85 0E                    ..
        jsr     find_free_slot_y                           ; A408 20 6F F1                  o.
        bcs     LA427                           ; A40B B0 1A                    ..
        lda     #$87                            ; A40D A9 87                    ..
        sta     $0408,y                         ; A40F 99 08 04                 ...
        lda     #$85                            ; A412 A9 85                    ..
        sta     $0300,y                         ; A414 99 00 03                 ...
        lda     #$26                            ; A417 A9 26                    .&
        jsr     entity_init_pos                           ; A419 20 A4 EA                  ..
        tya                                     ; A41C 98                       .
        tax                                     ; A41D AA                       .
        ldy     $0E                             ; A41E A4 0E                    ..
        lda     #$10                            ; A420 A9 10                    ..
        jsr     entity_set_dir_velocity                           ; A422 20 70 F4                  p.
        ldx     $0F                             ; A425 A6 0F                    ..
LA427:  rts                                     ; A427 60                       `

; ----------------------------------------------------------------------------
LA428:  .byte   $D1,$0B                         ; A428  Crystal PC lo (far/near)
LA42A:  .byte   $A2,$A3                         ; A42A  Crystal PC hi
LA42C:  .byte   $ED,$A8                         ; A42C  yvel sub
LA42E:  .byte   $06,$05                         ; A42E  yvel px
LA430:  .byte   $B8,$E2                         ; A430  xvel sub
LA432:  .byte   $00,$00                         ; A432  xvel px
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $84 — Crystal Eye ball (spread volley): bounces off
; floors and walls ($1C:8538/$851A/$852F), hurting on touch, and
; evaporates when its $F0-frame lifetime runs out.
; =============================================================================
        ldy     #$13                            ; A434 A0 13                    ..
        jsr     entity_vert_dispatch                           ; A436 20 52 EA                  R.
        bcc     LA441                           ; A439 90 06                    ..
        jsr     L8538                           ; A43B 20 38 85                  8.
        jmp     LA44B                           ; A43E 4C 4B A4                 LK.

; ----------------------------------------------------------------------------
LA441:  ldy     #$1A                            ; A441 A0 1A                    ..
        jsr     L851A                           ; A443 20 1A 85                  ..
        bcc     LA44B                           ; A446 90 03                    ..
        jsr     L852F                           ; A448 20 2F 85                  /.
LA44B:  dec     $0468,x                         ; A44B DE 68 04                 .h.
        beq     LA458                           ; A44E F0 08                    ..
        jsr     entity_player_collide                           ; A450 20 87 EF                  ..
        bcs     LA427                           ; A453 B0 D2                    ..
        jsr     L82B8                           ; A455 20 B8 82                  ..
LA458:  jmp     entity_wipe_x                           ; A458 4C C4 F2                 L..

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $86 — WAVE MAN (boss of stage $01). Notes the
; player's X at his anim beat ($A46D), then raises a type $88 water
; spout under/near it ($A474: X = mark + LA585/LA58D offset, first
; on-screen candidate wins, at floor Y=$BC); while the spout lives he
; poses ($A4DA), then either fires the type $87 harpoon (preset $2F,
; $A524) or hops (L854D by RNG, sub $29, $A50D); lands and repeats.
; =============================================================================
        jsr     entity_set_facing                           ; A45B 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A45E 20 30 EC                  0.
        lda     $0540,x                         ; A461 BD 40 05                 .@.
        bne     LA474                           ; A464 D0 0E                    ..
        lda     $0570,x                         ; A466 BD 70 05                 .p.
        cmp     #$02                            ; A469 C9 02                    ..
        bne     LA473                           ; A46B D0 06                    ..
        lda     $0330                           ; A46D AD 30 03                 .0.
        sta     $0480,x                         ; A470 9D 80 04                 ...
LA473:  rts                                     ; A473 60                       `

; ----------------------------------------------------------------------------
LA474:  cmp     #$03                            ; A474 C9 03                    ..
        bne     LA473                           ; A476 D0 FB                    ..
        stx     $0F                             ; A478 86 0F                    ..
        lda     #$DA                            ; A47A A9 DA                    ..
        sta     $0588,x                         ; A47C 9D 88 05                 ...
        lda     #$A4                            ; A47F A9 A4                    ..
        sta     $05A0,x                         ; A481 9D A0 05                 ...
        jsr     find_free_slot_y                           ; A484 20 6F F1                  o.
        bcs     LA473                           ; A487 B0 EA                    ..
        lda     #$87                            ; A489 A9 87                    ..
        sta     $0408,y                         ; A48B 99 08 04                 ...
        tya                                     ; A48E 98                       .
        sta     $0498,x                         ; A48F 9D 98 04                 ...
        lda     #$88                            ; A492 A9 88                    ..
        sta     $0300,y                         ; A494 99 00 03                 ...
        lda     #$2C                            ; A497 A9 2C
        jsr     entity_init_pos                 ; A499 20 A4 EA
        lda     #$BC                            ; A49C A9 BC                    ..
        sta     $0378,y                         ; A49E 99 78 03                 .x.
        lda     $0480,x                         ; A4A1 BD 80 04                 ...
        sta     L0000                           ; A4A4 85 00                    ..
        lda     $E7                             ; A4A6 A5 E7                    ..
        adc     $E4                             ; A4A8 65 E4                    e.
        sta     $E4                             ; A4AA 85 E4                    ..
LA4AC:  and     #$07                            ; A4AC 29 07                    ).
        tax                                     ; A4AE AA                       .
        lda     L0000                           ; A4AF A5 00                    ..
        clc                                     ; A4B1 18                       .
        adc     LA585,x                         ; A4B2 7D 85 A5                 }..
        sta     $0330,y                         ; A4B5 99 30 03                 .0.
        lda     $0348,y                         ; A4B8 B9 48 03                 .H.
        adc     LA58D,x                         ; A4BB 7D 8D A5                 }..
        cmp     $0348                           ; A4BE CD 48 03                 .H.
        bne     LA4CE                           ; A4C1 D0 0B                    ..
        lda     $0330,y                         ; A4C3 B9 30 03                 .0.
        cmp     #$18                            ; A4C6 C9 18                    ..
        bcc     LA4CE                           ; A4C8 90 04                    ..
        cmp     #$E8                            ; A4CA C9 E8                    ..
        bcc     LA4D2                           ; A4CC 90 04                    ..
LA4CE:  inx                                     ; A4CE E8                       .
        txa                                     ; A4CF 8A                       .
        bne     LA4AC                           ; A4D0 D0 DA                    ..
LA4D2:  lda     $0E                             ; A4D2 A5 0E                    ..
        sta     $0468,y                         ; A4D4 99 68 04                 .h.
        ldx     $0F                             ; A4D7 A6 0F                    ..
LA4D9:  rts                                     ; A4D9 60                       `

; ----------------------------------------------------------------------------
        jsr     entity_set_facing                           ; A4DA 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A4DD 20 30 EC                  0.
        lda     #$00                            ; A4E0 A9 00                    ..
        sta     $0570,x                         ; A4E2 9D 70 05                 .p.
        ldy     $0498,x                         ; A4E5 BC 98 04                 ...
        lda     $0300,y                         ; A4E8 B9 00 03                 ...
        bne     LA4D9                           ; A4EB D0 EC                    ..
        lda     #$FC                            ; A4ED A9 FC                    ..
        sta     $0588,x                         ; A4EF 9D 88 05                 ...
        lda     #$A4                            ; A4F2 A9 A4                    ..
        sta     $05A0,x                         ; A4F4 9D A0 05                 ...
        lda     #$2B                            ; A4F7 A9 2B                    .+
        jsr     entity_set_subtype                           ; A4F9 20 98 EA                  ..
        jsr     entity_set_facing                           ; A4FC 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A4FF 20 30 EC                  0.
        lda     $0570,x                         ; A502 BD 70 05                 .p.
        cmp     #$04                            ; A505 C9 04                    ..
        beq     LA524                           ; A507 F0 1B                    ..
        cmp     #$08                            ; A509 C9 08                    ..
        bne     LA4D9                           ; A50B D0 CC                    ..
        lda     #$4F                            ; A50D A9 4F                    .O
        sta     $0588,x                         ; A50F 9D 88 05                 ...
        lda     #$A5                            ; A512 A9 A5                    ..
        sta     $05A0,x                         ; A514 9D A0 05                 ...
        lda     $E6                             ; A517 A5 E6                    ..
        and     #$01                            ; A519 29 01                    ).
        tay                                     ; A51B A8                       .
        jsr     L854D                           ; A51C 20 4D 85                  M.
        lda     #$29                            ; A51F A9 29                    .)
        jmp     entity_set_subtype                           ; A521 4C 98 EA                 L..

; ----------------------------------------------------------------------------
LA524:  jsr     find_free_slot_y                           ; A524 20 6F F1                  o.
        bcs     LA584                           ; A527 B0 5B                    .[
        lda     #$8A                            ; A529 A9 8A                    ..
        sta     $0408,y                         ; A52B 99 08 04                 ...
        lda     #$87                            ; A52E A9 87                    ..
        sta     $0300,y                         ; A530 99 00 03                 ...
        lda     $0420,x                         ; A533 BD 20 04                 . .
        sta     $0420,y                         ; A536 99 20 04                 . .
        and     #$01                            ; A539 29 01                    ).
        clc                                     ; A53B 18                       .
        adc     #$42                            ; A53C 69 42                    iB
        sta     $10                             ; A53E 85 10                    ..
        lda     #$00                            ; A540 A9 00                    ..
        sta     $03A8,y                         ; A542 99 A8 03                 ...
        lda     #$02                            ; A545 A9 02                    ..
        sta     $03C0,y                         ; A547 99 C0 03                 ...
        lda     #$2F                            ; A54A A9 2F                    ./
        jmp     entity_speed_preset                           ; A54C 4C F5 EA                 L..

; ----------------------------------------------------------------------------
        lda     $0540,x                         ; A54F BD 40 05                 .@.
        beq     LA584                           ; A552 F0 30                    .0
        cmp     #$02                            ; A554 C9 02                    ..
        beq     LA56E                           ; A556 F0 16                    ..
        lda     #$00                            ; A558 A9 00                    ..
        sta     $0570,x                         ; A55A 9D 70 05                 .p.
        ldy     #$1C                            ; A55D A0 1C                    ..
        jsr     entity_gravity_collide                           ; A55F 20 B7 E7                  ..
        bcs     LA569                           ; A562 B0 05                    ..
        ldy     #$1E                            ; A564 A0 1E                    ..
        jmp     entity_horiz_dispatch                           ; A566 4C 3F EA                 L?.

; ----------------------------------------------------------------------------
LA569:  lda     #$02                            ; A569 A9 02                    ..
        sta     $0540,x                         ; A56B 9D 40 05                 .@.
LA56E:  lda     $0570,x                         ; A56E BD 70 05                 .p.
        cmp     #$08                            ; A571 C9 08                    ..
        bne     LA584                           ; A573 D0 0F                    ..
        lda     #$5B                            ; A575 A9 5B                    .[
        sta     $0588,x                         ; A577 9D 88 05                 ...
        lda     #$A4                            ; A57A A9 A4                    ..
        sta     $05A0,x                         ; A57C 9D A0 05                 ...
        lda     #$2A                            ; A57F A9 2A                    .*
        jsr     entity_set_subtype                           ; A581 20 98 EA                  ..
LA584:  rts                                     ; A584 60                       `

; ----------------------------------------------------------------------------
LA585:  .byte   $20,$F0,$10,$E0,$20,$C0,$40,$F0 ; A585  spout X offsets
LA58D:  .byte   $00,$FF,$00,$FF,$00,$FF,$00,$FF ; A58D  offset sign (screen carry)
; =============================================================================
; BEHAVIOR type $87 — Wave Man's harpoon: straight flight.
; =============================================================================
        jmp     entity_facing_dispatch                           ; A595 4C 65 EA                 Le.

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR types $88/$BB — water spout column: grows in steps (shape
; per anim phase via LA605, then sub $2D full column, sub $2E crest,
; shapes LA608), holding $3C frames at full height before collapsing.
; =============================================================================
        lda     $0570,x                         ; A598 BD 70 05                 .p.
        cmp     #$02                            ; A59B C9 02                    ..
        bne     LA584                           ; A59D D0 E5                    ..
        lda     $0378,x                         ; A59F BD 78 03                 .x.
        sec                                     ; A5A2 38                       8
        sbc     #$04                            ; A5A3 E9 04                    ..
        sta     $0378,x                         ; A5A5 9D 78 03                 .x.
        ldy     $0540,x                         ; A5A8 BC 40 05                 .@.
        lda     LA605,y                         ; A5AB B9 05 A6                 ...
        sta     $0408,x                         ; A5AE 9D 08 04                 ...
        cpy     #$02                            ; A5B1 C0 02                    ..
        bne     LA604                           ; A5B3 D0 4F                    .O
        lda     #$2D                            ; A5B5 A9 2D                    .-
        jsr     entity_set_subtype                           ; A5B7 20 98 EA                  ..
        lda     #$C4                            ; A5BA A9 C4                    ..
        sta     $0588,x                         ; A5BC 9D 88 05                 ...
        lda     #$A5                            ; A5BF A9 A5                    ..
        sta     $05A0,x                         ; A5C1 9D A0 05                 ...
        inc     $0498,x                         ; A5C4 FE 98 04                 ...
        lda     $0498,x                         ; A5C7 BD 98 04                 ...
        cmp     #$3C                            ; A5CA C9 3C                    .<
        bne     LA604                           ; A5CC D0 36                    .6
        lda     #$2E                            ; A5CE A9 2E                    ..
        jsr     entity_set_subtype                           ; A5D0 20 98 EA                  ..
        lda     $0378,x                         ; A5D3 BD 78 03                 .x.
        clc                                     ; A5D6 18                       .
        adc     #$04                            ; A5D7 69 04                    i.
        sta     $0378,x                         ; A5D9 9D 78 03                 .x.
        lda     #$9B                            ; A5DC A9 9B                    ..
        sta     $0408,x                         ; A5DE 9D 08 04                 ...
        lda     #$EB                            ; A5E1 A9 EB                    ..
        sta     $0588,x                         ; A5E3 9D 88 05                 ...
        lda     #$A5                            ; A5E6 A9 A5                    ..
        sta     $05A0,x                         ; A5E8 9D A0 05                 ...
        lda     $0570,x                         ; A5EB BD 70 05                 .p.
        cmp     #$02                            ; A5EE C9 02                    ..
        bne     LA604                           ; A5F0 D0 12                    ..
        ldy     $0540,x                         ; A5F2 BC 40 05                 .@.
        lda     LA608,y                         ; A5F5 B9 08 A6                 ...
        sta     $0408,x                         ; A5F8 9D 08 04                 ...
        lda     $0378,x                         ; A5FB BD 78 03                 .x.
        clc                                     ; A5FE 18                       .
        adc     #$04                            ; A5FF 69 04                    i.
        sta     $0378,x                         ; A601 9D 78 03                 .x.
LA604:  rts                                     ; A604 60                       `

; ----------------------------------------------------------------------------
LA605:  .byte   $81,$9B,$9C                     ; A605  spout shape by phase
LA608:  .byte   $81,$87,$00                     ; A608  crest shape by phase
; $A60B-$A7FF: data, TBD (unreferenced in-bank)
        .byte   $4D,$FD,$15,$9F,$55,$F7,$7F,$CF ; A60B
        .byte   $49,$93,$75,$BE,$D5,$F7,$47,$EF ; A613
        .byte   $61,$EE,$74,$DE,$7D,$77,$5F,$DF ; A61B
        .byte   $51,$F1,$55,$FD,$55,$FF,$F5,$DF ; A623
        .byte   $77,$F9,$D5,$9F,$7D,$BE,$6D,$72 ; A62B
        .byte   $E8,$F6,$7F,$CF,$F9,$BE,$7F,$DD ; A633
        .byte   $25,$FA,$CD,$CD,$77,$FF,$5D,$5F ; A63B
        .byte   $57,$FF,$DD,$F4,$D5,$EE,$45,$EF ; A643
        .byte   $D9,$EB,$D5,$6A,$87,$3F,$5F,$E7 ; A64B
        .byte   $5D,$FB,$77,$7E,$51,$DF,$45,$DD ; A653
        .byte   $75,$FA,$34,$B6,$50,$F9,$F5,$EF ; A65B
        .byte   $1D,$DD,$54,$7D,$EC,$F2,$35,$FF ; A663
        .byte   $77,$8F,$91,$E7,$7F,$A7,$77,$FF ; A66B
        .byte   $F3,$5B,$FB,$FF,$4D,$FB,$55,$DF ; A673
        .byte   $D6,$FF,$77,$E8,$B5,$BF,$45,$FB ; A67B
        .byte   $52,$55,$58,$56,$63,$77,$C5,$D5 ; A683
        .byte   $51,$FF,$7D,$F6,$5D,$FD,$71,$D7 ; A68B
        .byte   $59,$FB,$55,$BE,$B9,$EF,$FC,$7F ; A693
        .byte   $71,$EA,$47,$FD,$59,$EF,$E7,$6F ; A69B
        .byte   $DD,$B7,$7D,$F6,$F5,$FD,$CD,$FF ; A6A3
        .byte   $57,$EB,$F7,$FB,$15,$B7,$6F,$7D ; A6AB
        .byte   $F5,$FF,$75,$FF,$7F,$BD,$5F,$EF ; A6B3
        .byte   $55,$FB,$35,$FB,$D5,$5F,$55,$47 ; A6BB
        .byte   $FD,$F9,$39,$F9,$55,$DF,$5C,$FE ; A6C3
        .byte   $7D,$F7,$91,$7B,$5F,$AD,$7F,$FF ; A6CB
        .byte   $E7,$AF,$F5,$FF,$95,$F9,$15,$F8 ; A6D3
        .byte   $F7,$F9,$D5,$FB,$75,$FF,$76,$FF ; A6DB
        .byte   $7C,$F7,$9F,$7F,$54,$FF,$5E,$F7 ; A6E3
        .byte   $75,$FE,$F9,$FF,$75,$EF,$79,$DF ; A6EB
        .byte   $55,$BF,$7E,$FF,$A1,$BE,$F5,$B2 ; A6F3
        .byte   $75,$FF,$05,$7F,$6D,$BF,$D6,$EF ; A6FB
        .byte   $9F,$4E,$51,$EA,$44,$EF,$57,$ED ; A703
        .byte   $94,$FF,$5D,$FB,$77,$A2,$64,$F8 ; A70B
        .byte   $FC,$FF,$C7,$D7,$C3,$FF,$53,$FB ; A713
        .byte   $CD,$F5,$04,$FF,$EF,$3C,$63,$FF ; A71B
        .byte   $50,$E9,$12,$7E,$05,$BF,$7D,$FF ; A723
        .byte   $75,$DF,$45,$FD,$45,$FB,$15,$9F ; A72B
        .byte   $5C,$7F,$37,$ED,$BD,$7B,$D7,$F7 ; A733
        .byte   $37,$BF,$57,$FE,$53,$F3,$13,$F5 ; A73B
        .byte   $57,$BF,$5D,$7F,$45,$FE,$56,$FF ; A743
        .byte   $55,$FD,$A7,$6B,$95,$D5,$5F,$EF ; A74B
        .byte   $35,$FF,$D0,$FB,$1F,$FE,$CD,$FF ; A753
        .byte   $15,$F7,$E5,$FF,$44,$BD,$5D,$F7 ; A75B
        .byte   $75,$FF,$5F,$EF,$56,$DE,$D5,$DB ; A763
        .byte   $50,$7F,$D3,$FB,$DF,$CE,$5E,$FF ; A76B
        .byte   $1F,$FF,$55,$DE,$C1,$BB,$75,$BC ; A773
        .byte   $D6,$B7,$55,$FD,$55,$B7,$75,$AF ; A77B
        .byte   $77,$FF,$94,$3B,$47,$E7,$5C,$E7 ; A783
        .byte   $4F,$3F,$75,$FD,$DF,$D7,$C4,$BA ; A78B
        .byte   $57,$FB,$73,$FF,$5D,$FF,$74,$FB ; A793
        .byte   $F5,$D9,$F4,$B7,$00,$EF,$50,$FF ; A79B
        .byte   $55,$FB,$35,$BD,$45,$FF,$5D,$BF ; A7A3
        .byte   $53,$F7,$41,$BF,$F5,$F7,$57,$DF ; A7AB
        .byte   $F4,$F9,$55,$79,$77,$FE,$4D,$FD ; A7B3
        .byte   $37,$FF,$7F,$AE,$55,$89,$5B,$FD ; A7BB
        .byte   $55,$FF,$59,$ED,$5D,$FB,$4F,$F7 ; A7C3
        .byte   $75,$BC,$21,$DC,$51,$7E,$55,$FE ; A7CB
        .byte   $97,$EF,$1C,$97,$5A,$F5,$7B,$BF ; A7D3
        .byte   $D7,$F7,$CD,$E2,$13,$FE,$D3,$FA ; A7DB
        .byte   $7F,$FB,$BD,$FF,$53,$DE,$55,$EF ; A7E3
        .byte   $55,$FF,$77,$FB,$7D,$FD,$E7,$FF ; A7EB
        .byte   $DF,$FF,$4C,$7F,$1D,$DF,$F8,$E7 ; A7F3
        .byte   $59,$FF,$47,$97,$77 ; A7FB
; --- $A800: DAMAGE TABLE, weapon $7 (Gravity Hold) ---
; $A800[ent_type] via damage_engine $1C:809D; low 7 bits = damage,
; bit 7 = special handling; $00 = ricochet. Types $00-$CF.
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A800  types $00-$0F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$00,$01,$01,$01,$01,$01,$00,$00 ; A810  types $10-$1F
        .byte   $01,$01,$00,$00,$00,$01,$00,$00,$01,$01,$01,$01,$00,$00,$00,$00 ; A820  types $20-$2F
        .byte   $00,$01,$01,$01,$01,$00,$01,$00,$00,$01,$01,$01,$00,$00,$00,$00 ; A830  types $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A840  types $40-$4F
        .byte   $01,$00,$01,$01,$01,$00,$01,$00,$00,$01,$01,$00,$01,$01,$00,$00 ; A850  types $50-$5F
        .byte   $01,$00,$01,$01,$01,$00,$02,$01,$01,$01,$00,$00,$00,$00,$04,$00 ; A860  types $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00 ; A870  types $70-$7F
        .byte   $00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A880  types $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00 ; A890  types $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8A0  types $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$02,$00 ; A8B0  types $B0-$BF
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8C0  types $C0-$CF
; --- $A8D0: remainder (beyond type $CF) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8F0

; =============================================================================
; CRYSTAL MAN STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $A900: screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; A900  screens $00-$0F
        .byte   $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$00,$00,$50 ; A910  screens $10-$1F
        .byte   $00,$08,$00,$00,$00,$00,$08,$04,$00,$41,$00,$00,$00,$50,$00,$41 ; A920  screens $20-$2F
        .byte   $00,$40,$00,$00,$00,$00,$08,$11,$08,$00,$80,$62,$00,$01,$20,$00 ; A930  screens $30-$3F
        .byte   $08,$00,$00,$84,$00,$02,$00,$10,$02,$05,$02,$04,$28,$05,$02,$0E ; A940  screens $40-$4F
; --- $A950: section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $22,$40,$62,$80,$A2,$80,$A2,$40,$40,$62,$40,$40,$40,$61,$40,$60 ; A950
        .byte   $20,$20,$00,$00,$00,$80,$20,$20 ; A960
; --- $A968: per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $24,$09,$10,$1E,$11,$0A,$12,$02,$13,$0A,$00,$00,$00,$28,$28,$02 ; A968
        .byte   $80,$BA,$00,$00,$80,$00,$0A,$84 ; A978
; --- $A980: BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $9C,$9E,$00,$10,$20,$28,$80,$00 ; A980
; --- $A988: BG palette (16 bytes) ---
        .byte   $0F,$20,$01,$01,$0F,$20,$1C,$11,$0F,$23,$12,$03,$0F,$31,$21,$1C ; A988
; --- $A998: sprite palette-cycle seeds -> $05F0 slots ($A998-$A99B read) ---
        .byte   $82,$84,$00,$00,$0F,$20,$01,$01 ; A998
; --- $A9A0: unreferenced ---
        .byte   $0F,$20,$1C,$11,$0F,$23,$12,$03,$0F,$22,$12,$02,$82,$84,$00,$00 ; A9A0
        .byte   $0F,$20,$01,$15,$0F,$20,$1C,$11,$0F,$23,$12,$03,$0F,$35,$25,$15 ; A9B0
        .byte   $94,$97,$00,$00,$0F,$20,$01,$01,$0F,$20,$1C,$11,$0F,$23,$12,$03 ; A9C0
        .byte   $0F,$20,$10,$12,$82,$84,$00,$00,$80,$01,$20,$00,$80,$00,$22,$09 ; A9D0
; --- $A9E0: screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$20,$00,$20,$02,$84,$A0,$02,$88,$01,$00,$04,$00,$0A,$08,$21 ; A9E0  terminator / filler
        .byte   $00,$00,$02,$12,$80,$64,$20,$00,$00,$00,$00,$00,$08,$00,$00 ; A9F0  
        .byte   $00                             ; A9FF  -1 base for the spawn arrays
; --- $AA00: spawn screens (ascending) ---
        .byte   $01,$01,$02,$02,$03,$03,$04,$05,$05,$05,$05,$06,$06,$06,$06,$07 ; AA00  entries $00-$0F
        .byte   $08,$09,$09,$09,$0A,$0A,$0A,$0B,$0B,$0C,$0C,$0C,$0D,$0D,$0D,$0E ; AA10  entries $10-$1F
        .byte   $0E,$0F,$0F,$0F,$10,$10,$10,$12,$12,$12,$12,$13,$13,$13,$16,$17 ; AA20  entries $20-$2F
        .byte   $17,$18,$18,$18,$18,$19,$19,$1A,$1C,$FF,$00,$00,$00,$00,$00,$80 ; AA30  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$11,$80,$02,$00,$00,$00,$20,$00,$00,$00,$80 ; AA40  entries $40-$4F
        .byte   $00,$18,$80,$82,$A0,$04,$00,$00,$80,$08,$00,$40,$02,$40,$00,$48 ; AA50  entries $50-$5F
        .byte   $00,$11,$02,$00,$08,$02,$80,$00,$00,$02,$00,$00,$00,$00,$A0,$81 ; AA60  entries $60-$6F
        .byte   $00,$12,$00,$2C,$20,$09,$00,$08,$08,$04,$02,$00,$00,$04,$02,$21 ; AA70  entries $70-$7F
; --- $AA80: spawn X px ---
        .byte   $08,$78,$40,$A0,$50,$70,$A0,$20,$70,$B0,$F0,$20,$50,$80,$B0,$30 ; AA80  entries $00-$0F
        .byte   $90,$70,$98,$C0,$18,$90,$C0,$50,$90,$70,$90,$B0,$00,$30,$F0,$70 ; AA90  entries $10-$1F
        .byte   $B0,$10,$30,$D0,$30,$C0,$E8,$30,$70,$A8,$F0,$10,$70,$90,$50,$80 ; AAA0  entries $20-$2F
        .byte   $C0,$50,$70,$90,$B0,$68,$A8,$C0,$D8,$FF,$08,$2A,$20,$81,$80,$40 ; AAB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$82,$83,$00,$12,$00,$50,$00,$00,$00,$04,$08,$00 ; AAC0  entries $40-$4F
        .byte   $00,$40,$00,$22,$00,$06,$00,$00,$20,$04,$00,$21,$00,$20,$A2,$21 ; AAD0  entries $50-$5F
        .byte   $00,$04,$80,$80,$02,$12,$00,$00,$00,$49,$00,$20,$00,$40,$80,$0A ; AAE0  entries $60-$6F
        .byte   $20,$44,$00,$04,$02,$00,$02,$18,$02,$00,$80,$80,$20,$11,$00,$09 ; AAF0  entries $70-$7F
; --- $AB00: spawn Y px ---
        .byte   $B8,$A8,$98,$98,$50,$70,$B8,$B8,$30,$30,$30,$30,$30,$30,$30,$98 ; AB00  entries $00-$0F
        .byte   $A2,$30,$62,$30,$32,$30,$52,$C8,$B0,$98,$78,$58,$38,$38,$52,$72 ; AB10  entries $10-$1F
        .byte   $92,$60,$30,$B8,$80,$A0,$C0,$C8,$6C,$68,$6C,$C8,$AC,$8C,$80,$B8 ; AB20  entries $20-$2F
        .byte   $B8,$98,$98,$78,$58,$78,$58,$A4,$00,$FF,$00,$40,$20,$00,$00,$80 ; AB30  entries $30-$3F
        .byte   $08,$0F,$20,$10,$20,$80,$08,$00,$00,$23,$08,$28,$00,$80,$08,$82 ; AB40  entries $40-$4F
        .byte   $2A,$40,$00,$00,$00,$00,$02,$20,$A2,$00,$08,$54,$A8,$D0,$00,$A0 ; AB50  entries $50-$5F
        .byte   $02,$00,$00,$06,$00,$04,$20,$20,$00,$02,$02,$80,$00,$00,$80,$18 ; AB60  entries $60-$6F
        .byte   $80,$00,$20,$A0,$00,$02,$28,$41,$20,$50,$80,$50,$28,$41,$08,$0A ; AB70  entries $70-$7F
; --- $AB80: spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $00,$00,$00,$00,$60,$60,$00,$00,$0A,$0A,$0A,$0A,$0A,$0A,$0A,$80 ; AB80  entries $00-$0F
        .byte   $18,$0A,$18,$0A,$18,$0A,$18,$15,$27,$60,$60,$60,$60,$60,$06,$06 ; AB90  entries $10-$1F
        .byte   $06,$02,$02,$81,$02,$02,$02,$15,$05,$82,$05,$15,$05,$05,$8F,$32 ; ABA0  entries $20-$2F
        .byte   $32,$32,$32,$32,$32,$32,$32,$0C,$66,$FF,$00,$00,$02,$08,$80,$10 ; ABB0  entries $30-$3F
        .byte   $00,$00,$88,$00,$00,$00,$02,$10,$80,$00,$20,$00,$00,$14,$00,$E0 ; ABC0  entries $40-$4F
        .byte   $00,$08,$00,$00,$00,$00,$00,$00,$28,$00,$00,$24,$02,$40,$02,$84 ; ABD0  entries $50-$5F
        .byte   $00,$40,$00,$00,$00,$10,$20,$40,$20,$0C,$00,$00,$00,$00,$80,$01 ; ABE0  entries $60-$6F
        .byte   $20,$90,$02,$50,$A0,$00,$00,$01,$28,$00,$00,$07,$02,$40,$00,$00 ; ABF0  entries $70-$7F
; --- $AC00: per-screen spawn-list start index ---
        .byte   $00,$00,$02,$04,$06,$07,$0B,$0F,$10,$11,$14,$17,$19,$1C,$1F,$21 ; AC00  screens $00-$0F
        .byte   $24,$27,$27,$2B,$2E,$2E,$2E,$2F,$31,$35,$37,$38,$38,$00,$00,$00 ; AC10  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$80,$00,$00,$10 ; AC20  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00 ; AC30  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC40  screens $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$40,$00,$10,$00,$00,$00,$00,$00,$00,$00 ; AC50  screens $50-$5F
        .byte   $00,$40,$00,$00,$08,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00 ; AC60  screens $60-$6F
        .byte   $00,$00,$00,$00,$00,$10,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC70  screens $70-$7F
        .byte   $00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC90  screens $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACA0  screens $A0-$AF
        .byte   $10,$00,$00,$00,$00,$10,$00,$00,$00,$05,$00,$00,$20,$02,$00,$00 ; ACB0  screens $B0-$BF
        .byte   $00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$80,$00,$04,$00 ; ACC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACD0  screens $D0-$DF
        .byte   $00,$20,$40,$00,$4A,$00,$04,$00,$00,$00,$00,$00,$00,$01,$40,$00 ; ACE0  screens $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00 ; ACF0  screens $F0-$FF
; --- $AD00: metatile top-left tile ids ---
        .byte   $00,$FF,$20,$21,$0C,$60,$0C,$2E,$FE,$6A,$6C,$6A,$6C,$60,$1E,$0E ; AD00  metatiles $00-$0F
        .byte   $21,$50,$50,$6A,$6C,$50,$50,$0E,$4A,$2C,$3A,$3C,$4A,$4C,$5A,$5C ; AD10  metatiles $10-$1F
        .byte   $02,$04,$06,$08,$2A,$2C,$3A,$3C,$22,$24,$26,$28,$32,$34,$36,$38 ; AD20  metatiles $20-$2F
        .byte   $42,$44,$46,$48,$00,$00,$00,$00,$62,$64,$66,$68,$52,$54,$56,$58 ; AD30  metatiles $30-$3F
        .byte   $00,$00,$00,$00,$B0,$B2,$11,$FF,$98,$9A,$9C,$9E,$C4,$C6,$A8,$AA ; AD40  metatiles $40-$4F
        .byte   $80,$82,$4E,$6E,$F0,$F2,$11,$11,$A0,$A2,$8D,$8F,$F4,$F6,$B4,$00 ; AD50  metatiles $50-$5F
        .byte   $C0,$C2,$D4,$10,$11,$CF,$00,$C9,$E0,$E2,$F0,$F2,$BC,$BE,$00,$ED ; AD60  metatiles $60-$6F
        .byte   $A8,$E9,$11,$FB,$11,$CB,$FF,$FF,$11,$DB,$11,$FB,$FF,$20,$21,$21 ; AD70  metatiles $70-$7F
        .byte   $84,$85,$DE,$DF,$01,$01,$01,$01,$94,$87,$DE,$DF,$CC,$01,$FF,$F8 ; AD80  metatiles $80-$8F
        .byte   $FF,$80,$82,$82,$FF,$F9,$FF,$CC,$A4,$A0,$84,$A2,$02,$04,$06,$08 ; AD90  metatiles $90-$9F
        .byte   $C4,$C0,$C1,$B2,$E0,$E2,$E2,$50,$E4,$C0,$C1,$B2,$E0,$E2,$E2,$DB ; ADA0  metatiles $A0-$AF
        .byte   $86,$88,$6A,$8B,$6A,$6C,$6A,$8B,$A6,$A8,$6C,$AB,$6A,$8B,$50,$DB ; ADB0  metatiles $B0-$BF
        .byte   $BC,$BE,$FC,$F6,$EA,$FF,$FF,$FF,$DC,$DE,$FF,$FF,$FF,$FF,$FF,$FF ; ADC0  metatiles $C0-$CF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADD0  metatiles $D0-$DF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADE0  metatiles $E0-$EF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; ADF0  metatiles $F0-$FF
; --- $AE00: metatile bottom-left tile ids ---
        .byte   $00,$FF,$21,$21,$0D,$61,$0D,$3E,$FE,$6B,$6D,$6B,$6D,$61,$1F,$0F ; AE00  metatiles $00-$0F
        .byte   $2F,$51,$51,$6B,$6D,$51,$51,$0F,$2B,$2D,$3B,$5D,$4B,$4D,$5B,$5D ; AE10  metatiles $10-$1F
        .byte   $03,$05,$07,$09,$2B,$2D,$3B,$3D,$23,$25,$27,$29,$33,$35,$37,$39 ; AE20  metatiles $20-$2F
        .byte   $43,$45,$47,$49,$00,$00,$00,$00,$63,$65,$67,$69,$53,$55,$57,$59 ; AE30  metatiles $30-$3F
        .byte   $00,$00,$00,$00,$B1,$B3,$11,$FF,$99,$9B,$9D,$9F,$C5,$C7,$A9,$AB ; AE40  metatiles $40-$4F
        .byte   $81,$83,$4F,$6F,$F1,$F3,$11,$11,$A1,$A3,$00,$00,$F5,$F7,$B5,$B7 ; AE50  metatiles $50-$5F
        .byte   $C1,$C3,$D5,$D7,$CE,$11,$C8,$00,$E1,$E3,$F1,$F3,$BD,$BF,$EC,$00 ; AE60  metatiles $60-$6F
        .byte   $E8,$AB,$FA,$11,$CA,$11,$FF,$FF,$DA,$11,$FA,$11,$FF,$21,$21,$2F ; AE70  metatiles $70-$7F
        .byte   $85,$0B,$DF,$B6,$01,$01,$01,$01,$87,$1B,$DF,$B6,$CD,$F9,$FF,$01 ; AE80  metatiles $80-$8F
        .byte   $FF,$81,$81,$83,$FF,$CD,$FF,$F8,$A5,$A1,$85,$A3,$03,$05,$07,$09 ; AE90  metatiles $90-$9F
        .byte   $C5,$B1,$C2,$C3,$E1,$E1,$E3,$DA,$E5,$B1,$C2,$C3,$E1,$E1,$E3,$51 ; AEA0  metatiles $A0-$AF
        .byte   $87,$89,$8A,$6D,$6B,$6D,$8A,$6D,$A7,$A9,$AA,$6B,$8A,$6D,$DA,$51 ; AEB0  metatiles $B0-$BF
        .byte   $BD,$BF,$00,$F7,$EB,$FF,$FF,$FF,$00,$DF,$FF,$FF,$FF,$FF,$FF,$FF ; AEC0  metatiles $C0-$CF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AED0  metatiles $D0-$DF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AEE0  metatiles $E0-$EF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AEF0  metatiles $F0-$FF
; --- $AF00: metatile top-right tile ids ---
        .byte   $00,$FF,$30,$31,$1C,$70,$1C,$0E,$FE,$40,$40,$7A,$7C,$60,$1E,$0E ; AF00  metatiles $00-$0F
        .byte   $31,$1A,$1A,$1A,$1A,$7A,$7C,$0E,$2A,$2C,$5A,$5C,$4A,$4C,$5A,$5C ; AF10  metatiles $10-$1F
        .byte   $12,$14,$16,$18,$22,$24,$26,$28,$32,$34,$36,$38,$00,$00,$00,$00 ; AF20  metatiles $20-$2F
        .byte   $52,$54,$56,$58,$42,$44,$46,$48,$72,$74,$76,$78,$2A,$2C,$3A,$3C ; AF30  metatiles $30-$3F
        .byte   $88,$8A,$8C,$8E,$B4,$00,$11,$FF,$80,$82,$AC,$AE,$D4,$10,$11,$11 ; AF40  metatiles $40-$4F
        .byte   $90,$92,$5E,$7E,$E4,$E6,$A4,$A6,$00,$00,$00,$00,$B8,$BA,$B4,$00 ; AF50  metatiles $50-$5F
        .byte   $D0,$D2,$D4,$10,$11,$CB,$00,$D9,$F0,$F2,$F0,$F2,$80,$82,$00,$FD ; AF60  metatiles $60-$6F
        .byte   $11,$CB,$11,$FB,$11,$CB,$FF,$FF,$11,$EB,$A4,$DD,$FF,$30,$31,$31 ; AF70  metatiles $70-$7F
        .byte   $94,$95,$DE,$DF,$01,$F9,$CC,$CC,$96,$97,$EE,$EF,$11,$F9,$FF,$11 ; AF80  metatiles $80-$8F
        .byte   $FF,$90,$92,$92,$FF,$11,$FF,$11,$B4,$B0,$C1,$B2,$72,$74,$76,$78 ; AF90  metatiles $90-$9F
        .byte   $D4,$B0,$C1,$B2,$90,$92,$92,$1A,$F4,$D0,$94,$D2,$F0,$F2,$F2,$D8 ; AFA0  metatiles $A0-$AF
        .byte   $96,$98,$7A,$9B,$C6,$C8,$E6,$E8,$B6,$B8,$7C,$BB,$1A,$D8,$7C,$9B ; AFB0  metatiles $B0-$BF
        .byte   $CC,$CE,$00,$F8,$FA,$FF,$FF,$FF,$EC,$EE,$FF,$FF,$FF,$FF,$FF,$FF ; AFC0  metatiles $C0-$CF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AFD0  metatiles $D0-$DF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AFE0  metatiles $E0-$EF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; AFF0  metatiles $F0-$FF
; --- $B000: metatile bottom-right tile ids ---
        .byte   $00,$FF,$31,$31,$1D,$71,$1D,$0F,$FE,$41,$41,$7B,$7D,$61,$1F,$0F ; B000  metatiles $00-$0F
        .byte   $3F,$1A,$1A,$1A,$1A,$7B,$7D,$0F,$4B,$2D,$3B,$3D,$4B,$4D,$5B,$5D ; B010  metatiles $10-$1F
        .byte   $13,$15,$17,$19,$23,$25,$27,$29,$33,$35,$37,$39,$00,$00,$00,$00 ; B020  metatiles $20-$2F
        .byte   $53,$55,$57,$59,$43,$45,$47,$49,$73,$75,$77,$79,$2B,$2D,$3B,$3D ; B030  metatiles $30-$3F
        .byte   $89,$8B,$00,$00,$B5,$B7,$11,$FF,$81,$83,$AD,$AF,$D5,$D7,$11,$11 ; B040  metatiles $40-$4F
        .byte   $91,$93,$5F,$7F,$E5,$E7,$A5,$A7,$00,$00,$00,$00,$B9,$BB,$B5,$B7 ; B050  metatiles $50-$5F
        .byte   $D1,$D3,$D5,$D7,$CA,$11,$D8,$00,$F1,$F3,$F1,$F3,$81,$83,$FC,$00 ; B060  metatiles $60-$6F
        .byte   $CA,$11,$FA,$11,$CA,$11,$FF,$FF,$EA,$11,$DC,$A7,$FF,$31,$31,$3F ; B070  metatiles $70-$7F
        .byte   $95,$1B,$DF,$B6,$01,$CD,$CD,$F8,$97,$86,$EF,$D6,$11,$11,$FF,$F8 ; B080  metatiles $80-$8F
        .byte   $FF,$91,$91,$93,$FF,$11,$FF,$11,$B5,$B1,$C2,$B3,$73,$75,$77,$79 ; B090  metatiles $90-$9F
        .byte   $D5,$B1,$C2,$B3,$91,$91,$93,$D7,$F5,$D1,$95,$D3,$F1,$F1,$F3,$1A ; B0A0  metatiles $A0-$AF
        .byte   $97,$99,$9A,$7D,$C7,$C9,$E7,$E9,$B7,$B9,$BA,$7B,$D7,$1A,$9A,$7B ; B0B0  metatiles $B0-$BF
        .byte   $CD,$CF,$00,$F9,$FB,$FF,$FF,$FF,$00,$EF,$FF,$FF,$FF,$FF,$FF,$FF ; B0C0  metatiles $C0-$CF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B0D0  metatiles $D0-$DF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B0E0  metatiles $E0-$EF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; B0F0  metatiles $F0-$FF
; --- $B100: metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$00,$10,$11,$F0,$02,$F1,$40,$10,$02,$02,$02,$02,$02,$00,$20 ; B100  metatiles $00-$0F
        .byte   $10,$02,$02,$02,$02,$02,$02,$21,$10,$11,$10,$11,$10,$11,$10,$11 ; B110  metatiles $10-$1F
        .byte   $10,$11,$10,$11,$10,$11,$10,$11,$10,$11,$10,$11,$10,$11,$10,$11 ; B120  metatiles $20-$2F
        .byte   $10,$11,$10,$11,$10,$11,$10,$11,$10,$11,$10,$11,$10,$11,$10,$11 ; B130  metatiles $30-$3F
        .byte   $02,$02,$02,$02,$03,$03,$03,$00,$02,$02,$02,$02,$03,$03,$03,$03 ; B140  metatiles $40-$4F
        .byte   $02,$02,$02,$02,$03,$03,$03,$03,$02,$02,$02,$02,$03,$03,$03,$03 ; B150  metatiles $50-$5F
        .byte   $03,$03,$03,$03,$03,$03,$02,$02,$03,$03,$03,$03,$03,$03,$02,$02 ; B160  metatiles $60-$6F
        .byte   $03,$03,$03,$03,$03,$03,$00,$00,$03,$03,$03,$03,$00,$11,$10,$11 ; B170  metatiles $70-$7F
        .byte   $10,$11,$10,$10,$03,$03,$03,$03,$10,$11,$10,$10,$03,$03,$00,$03 ; B180  metatiles $80-$8F
        .byte   $00,$13,$13,$13,$00,$03,$00,$03,$13,$13,$13,$13,$10,$11,$10,$11 ; B190  metatiles $90-$9F
        .byte   $13,$13,$13,$13,$13,$13,$13,$02,$13,$13,$13,$13,$13,$13,$13,$02 ; B1A0  metatiles $A0-$AF
        .byte   $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02 ; B1B0  metatiles $B0-$BF
        .byte   $02,$02,$02,$02,$02,$00,$00,$00,$02,$02,$00,$00,$00,$00,$00,$00 ; B1C0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1D0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1E0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1F0  metatiles $F0-$FF
; --- $B200: 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $84,$84,$84,$84,$84,$84,$85,$86,$84,$84,$87,$84,$84,$85,$8D,$46 ; B200  blocks $00-$03
        .byte   $86,$95,$46,$46,$46,$46,$46,$46,$84,$8D,$8C,$46,$46,$97,$46,$46 ; B210  blocks $04-$07
        .byte   $46,$46,$6C,$6D,$46,$46,$64,$65,$6C,$6D,$60,$61,$64,$65,$78,$79 ; B220  blocks $08-$0B
        .byte   $60,$61,$68,$69,$6C,$6D,$62,$63,$78,$79,$72,$73,$68,$69,$6A,$6B ; B230  blocks $0C-$0F
        .byte   $72,$73,$72,$73,$6A,$6B,$6A,$6B,$7A,$7B,$6E,$6F,$54,$55,$5C,$5D ; B240  blocks $10-$13
        .byte   $56,$57,$00,$00,$52,$53,$5A,$5B,$50,$51,$58,$59,$20,$21,$28,$29 ; B250  blocks $14-$17
        .byte   $22,$23,$2A,$2B,$20,$21,$24,$25,$22,$23,$1A,$1B,$20,$21,$1C,$1D ; B260  blocks $18-$1B
        .byte   $15,$16,$0C,$0B,$2C,$2D,$16,$15,$2A,$2B,$16,$15,$18,$19,$1C,$1D ; B270  blocks $1C-$1F
        .byte   $1E,$1F,$1E,$1F,$97,$86,$46,$46,$87,$84,$46,$8F,$1C,$1D,$38,$39 ; B280  blocks $20-$23
        .byte   $32,$33,$3A,$3B,$34,$35,$3C,$3D,$09,$0A,$36,$37,$8C,$8F,$46,$46 ; B290  blocks $24-$27
        .byte   $84,$85,$8C,$46,$18,$19,$38,$39,$3E,$3F,$3A,$3B,$52,$53,$20,$21 ; B2A0  blocks $28-$2B
        .byte   $52,$53,$22,$23,$50,$51,$20,$21,$50,$51,$22,$23,$22,$23,$26,$27 ; B2B0  blocks $2C-$2F
        .byte   $18,$19,$28,$29,$1C,$1D,$24,$25,$1A,$1B,$1E,$1F,$24,$25,$2C,$2D ; B2C0  blocks $30-$33
        .byte   $1A,$1B,$2A,$2B,$2E,$2F,$16,$15,$0B,$0C,$0C,$0B,$0B,$0C,$0A,$09 ; B2D0  blocks $34-$37
        .byte   $3C,$3D,$38,$39,$30,$31,$38,$39,$1A,$1B,$1A,$1B,$1E,$1F,$1A,$1B ; B2E0  blocks $38-$3B
        .byte   $20,$21,$18,$19,$22,$23,$1E,$1F,$11,$12,$0C,$0B,$28,$29,$16,$15 ; B2F0  blocks $3C-$3F
        .byte   $13,$14,$0C,$0B,$30,$31,$18,$19,$09,$0A,$32,$33,$1C,$1D,$18,$19 ; B300  blocks $40-$43
        .byte   $1E,$1F,$3A,$3B,$13,$14,$09,$0A,$80,$81,$88,$89,$42,$43,$4A,$4B ; B310  blocks $44-$47
        .byte   $11,$05,$0C,$0D,$13,$05,$0C,$0D,$13,$05,$09,$0D,$1A,$1B,$26,$27 ; B320  blocks $48-$4B
        .byte   $09,$0A,$34,$35,$00,$00,$00,$00,$00,$00,$66,$67,$3E,$3F,$1A,$1B ; B330  blocks $4C-$4F
        .byte   $4E,$4F,$46,$46,$70,$71,$74,$75,$4C,$4D,$60,$61,$1A,$1B,$3A,$3B ; B340  blocks $50-$53
        .byte   $18,$19,$18,$19,$74,$75,$78,$79,$1C,$1D,$1C,$1D,$09,$0A,$30,$31 ; B350  blocks $54-$57
        .byte   $82,$83,$82,$83,$8A,$8B,$00,$00,$70,$71,$78,$79,$18,$82,$38,$82 ; B360  blocks $58-$5B
        .byte   $83,$19,$83,$39,$1C,$0F,$38,$17,$00,$8A,$00,$00,$8B,$00,$66,$67 ; B370  blocks $5C-$5F
        .byte   $8A,$8B,$66,$67,$00,$0F,$00,$17,$4E,$0F,$46,$17,$46,$0F,$46,$17 ; B380  blocks $60-$63
        .byte   $7A,$7B,$6E,$23,$22,$57,$1A,$00,$52,$53,$22,$5B,$52,$1B,$5A,$1F ; B390  blocks $64-$67
        .byte   $1A,$53,$1E,$5B,$1A,$00,$1E,$00,$00,$1B,$00,$1F,$1C,$0F,$1C,$17 ; B3A0  blocks $68-$6B
        .byte   $32,$33,$1A,$1B,$05,$12,$0D,$0B,$00,$00,$16,$0D,$00,$00,$15,$16 ; B3B0  blocks $6C-$6F
        .byte   $05,$14,$0D,$0B,$1C,$0F,$1C,$0A,$05,$14,$0D,$0A,$20,$07,$1C,$17 ; B3C0  blocks $70-$73
        .byte   $3A,$3B,$00,$00,$38,$39,$00,$00,$3A,$3B,$48,$49,$1C,$00,$1C,$00 ; B3D0  blocks $74-$77
        .byte   $44,$45,$5E,$5F,$1C,$4F,$1C,$46,$1C,$46,$1C,$46,$1C,$57,$1C,$00 ; B3E0  blocks $78-$7B
        .byte   $1C,$53,$1C,$5B,$1C,$07,$1C,$17,$18,$19,$24,$25,$26,$27,$2E,$2F ; B3F0  blocks $7C-$7F
        .byte   $3A,$82,$00,$82,$83,$39,$83,$00,$72,$73,$7D,$7E,$46,$46,$7F,$46 ; B400  blocks $80-$83
        .byte   $72,$73,$72,$02,$46,$46,$03,$10,$56,$7D,$00,$00,$03,$10,$00,$00 ; B410  blocks $84-$87
        .byte   $52,$53,$04,$06,$52,$53,$04,$5B,$52,$53,$5A,$06,$22,$00,$1E,$00 ; B420  blocks $88-$8B
        .byte   $00,$23,$00,$1F,$0F,$1F,$17,$1F,$7D,$7E,$72,$73,$7F,$4F,$46,$46 ; B430  blocks $8C-$8F
        .byte   $7F,$46,$46,$46,$7E,$7F,$00,$00,$52,$1F,$04,$1F,$0F,$1F,$17,$3B ; B440  blocks $90-$93
        .byte   $0F,$43,$17,$4B,$0F,$12,$0C,$0B,$00,$00,$16,$15,$3C,$3D,$18,$19 ; B450  blocks $94-$97
        .byte   $00,$00,$15,$0D,$00,$00,$15,$15,$00,$1F,$15,$1F,$13,$14,$0A,$09 ; B460  blocks $98-$9B
        .byte   $05,$14,$0D,$09,$13,$05,$0A,$0D,$13,$1F,$0A,$1F,$07,$1F,$17,$1F ; B470  blocks $9C-$9F
        .byte   $3A,$3B,$84,$84,$38,$39,$84,$84,$38,$39,$84,$85,$3A,$3B,$86,$95 ; B480  blocks $A0-$A3
        .byte   $38,$39,$46,$46,$3A,$3B,$97,$87,$85,$95,$46,$46,$8C,$8C,$6C,$6D ; B490  blocks $A4-$A7
        .byte   $8F,$84,$46,$8C,$8D,$46,$46,$46,$07,$23,$17,$1F,$38,$39,$85,$95 ; B4A0  blocks $A8-$AB
        .byte   $3A,$3B,$46,$46,$97,$87,$46,$46,$38,$39,$97,$87,$3A,$3B,$85,$86 ; B4B0  blocks $AC-$AF
        .byte   $38,$39,$86,$95,$3A,$3B,$46,$97,$38,$39,$87,$84,$46,$8F,$46,$46 ; B4C0  blocks $B0-$B3
        .byte   $1E,$1F,$2A,$2B,$36,$37,$3E,$3F,$02,$03,$7D,$7E,$7E,$7F,$03,$10 ; B4D0  blocks $B4-$B7
        .byte   $02,$03,$00,$00,$B4,$B5,$BA,$BB,$11,$12,$0C,$0C,$B0,$B1,$B8,$B9 ; B4E0  blocks $B8-$BB
        .byte   $B6,$B7,$0C,$0B,$BC,$BD,$BA,$BB,$98,$91,$98,$99,$92,$93,$9A,$9B ; B4F0  blocks $BC-$BF
        .byte   $98,$99,$98,$A1,$9A,$9B,$A2,$A3,$28,$29,$34,$35,$2A,$2B,$32,$33 ; B500  blocks $C0-$C3
        .byte   $A0,$A9,$A8,$AC,$AA,$AB,$AD,$AE,$00,$00,$BE,$BF,$A0,$A1,$A8,$A9 ; B510  blocks $C4-$C7
        .byte   $A2,$A3,$AA,$AB,$A0,$91,$A8,$99,$98,$A4,$98,$99,$A5,$A6,$9A,$9B ; B520  blocks $C8-$CB
        .byte   $B6,$B7,$20,$21,$B6,$B7,$22,$23,$98,$A1,$98,$A1,$A2,$A3,$A2,$A3 ; B530  blocks $CC-$CF
        .byte   $98,$00,$98,$15,$98,$00,$98,$0D,$BC,$BD,$20,$21,$13,$05,$22,$23 ; B540  blocks $D0-$D3
        .byte   $00,$14,$20,$21,$13,$14,$22,$23,$00,$05,$20,$21,$12,$05,$0C,$0D ; B550  blocks $D4-$D7
        .byte   $A7,$AF,$BA,$BB,$13,$05,$20,$21,$B6,$B7,$98,$91,$00,$00,$92,$93 ; B560  blocks $D8-$DB
        .byte   $00,$00,$98,$91,$BC,$BD,$22,$23,$00,$00,$C3,$C4,$0B,$C8,$0C,$C0 ; B570  blocks $DC-$DF
        .byte   $C1,$0C,$C9,$0B,$0B,$0C,$C3,$C4,$C0,$00,$C3,$C4,$C1,$0C,$C3,$C4 ; B580  blocks $E0-$E3
        .byte   $00,$C9,$00,$C1,$09,$0A,$04,$06,$C0,$C2,$C8,$00,$00,$C9,$00,$00 ; B590  blocks $E4-$E7
        .byte   $0B,$0C,$C9,$0B,$00,$00,$00,$C1,$C1,$0C,$0C,$0B,$00,$00,$0D,$15 ; B5A0  blocks $E8-$EB
        .byte   $98,$A4,$98,$A1,$A5,$A6,$A2,$A3,$3A,$3B,$00,$0E,$11,$0E,$0C,$0E ; B5B0  blocks $EC-$EF
        .byte   $A9,$AA,$AC,$AD,$AB,$A0,$AE,$A8,$18,$43,$1C,$4B,$42,$1B,$4A,$1F ; B5C0  blocks $F0-$F3
        .byte   $1C,$12,$18,$0B,$11,$1B,$0C,$1F,$18,$14,$1C,$0B,$13,$1F,$0C,$1B ; B5D0  blocks $F4-$F7
        .byte   $38,$14,$00,$0B,$13,$1B,$0C,$1F,$11,$14,$0C,$0B,$91,$92,$99,$9A ; B5E0  blocks $F8-$FB
        .byte   $93,$98,$9B,$98,$A1,$A2,$A1,$A2,$A3,$98,$A3,$98,$00,$00,$00,$00 ; B5F0  blocks $FC-$FF
; --- $B600: screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$01,$02,$00,$03,$04,$05,$05,$06,$05,$07,$04,$08,$05,$05,$05 ; B600
        .byte   $09,$0A,$05,$0B,$0C,$09,$0B,$0D,$0E,$0F,$05,$10,$11,$0E,$10,$0C ; B610
        .byte   $12,$13,$14,$12,$13,$12,$12,$13,$15,$16,$15,$15,$16,$15,$15,$16 ; B620
        .byte   $17,$18,$19,$1A,$1B,$1A,$19,$1A,$1C,$1C,$1D,$1E,$1F,$20,$1D,$1E ; B630
; layout $01
        .byte   $05,$21,$22,$00,$23,$24,$25,$26,$05,$05,$05,$27,$28,$04,$29,$2A ; B640
        .byte   $05,$09,$05,$0B,$0A,$05,$09,$0D,$05,$0E,$05,$10,$0F,$05,$0E,$0C ; B650
        .byte   $14,$12,$14,$12,$13,$14,$12,$13,$15,$15,$2B,$2C,$2D,$2C,$2B,$2E ; B660
        .byte   $17,$2F,$30,$1E,$31,$32,$33,$34,$1C,$35,$1C,$36,$1D,$1E,$1C,$1C ; B670
; layout $02
        .byte   $37,$25,$24,$24,$38,$2A,$23,$32,$39,$29,$04,$08,$27,$28,$22,$3A ; B680
        .byte   $05,$09,$05,$0C,$0B,$05,$05,$3B,$05,$0E,$05,$11,$10,$05,$05,$3B ; B690
        .byte   $14,$12,$14,$13,$12,$14,$14,$20,$1B,$18,$19,$18,$3C,$3D,$3E,$3A ; B6A0
        .byte   $33,$1C,$1D,$1C,$3F,$3A,$40,$32,$41,$42,$41,$42,$41,$20,$40,$32 ; B6B0
; layout $03
        .byte   $43,$24,$23,$24,$29,$44,$45,$3A,$46,$47,$47,$47,$47,$47,$47,$3B ; B6C0
        .byte   $46,$3E,$48,$3E,$3E,$48,$3E,$46,$43,$40,$3C,$40,$40,$49,$40,$46 ; B6D0
        .byte   $46,$45,$43,$1A,$45,$4A,$45,$46,$46,$15,$43,$34,$3C,$15,$15,$3B ; B6E0
        .byte   $1F,$3E,$43,$1C,$3F,$18,$19,$4B,$1F,$42,$1F,$42,$4C,$1C,$1D,$35 ; B6F0
; layout $04
        .byte   $43,$47,$23,$24,$25,$26,$1C,$1C,$46,$4D,$4E,$4D,$23,$4F,$36,$42 ; B700
        .byte   $46,$50,$51,$50,$52,$53,$39,$53,$54,$05,$0E,$05,$0F,$55,$05,$0E ; B710
        .byte   $43,$1A,$12,$14,$13,$12,$14,$12,$46,$34,$3C,$15,$16,$15,$15,$15 ; B720
        .byte   $43,$1C,$30,$1A,$3C,$2F,$1B,$1A,$56,$36,$1C,$1E,$56,$35,$1F,$1E ; B730
; layout $05
        .byte   $57,$46,$29,$58,$46,$58,$23,$58,$54,$46,$4E,$59,$4D,$59,$4E,$59 ; B740
        .byte   $23,$53,$51,$50,$50,$50,$5A,$50,$0C,$05,$0E,$05,$05,$05,$10,$05 ; B750
        .byte   $13,$14,$12,$14,$14,$14,$12,$14,$16,$15,$15,$15,$3C,$15,$15,$15 ; B760
        .byte   $3C,$3D,$3C,$4D,$43,$4D,$1B,$4D,$1F,$32,$1F,$4D,$1F,$4D,$1F,$4D ; B770
; layout $06
        .byte   $5B,$5C,$58,$5B,$5C,$58,$5D,$32,$5E,$5F,$59,$5E,$5F,$60,$61,$3B ; B780
        .byte   $50,$51,$50,$50,$5A,$51,$62,$3A,$05,$0E,$05,$05,$10,$0E,$63,$20 ; B790
        .byte   $14,$64,$14,$65,$64,$12,$1B,$3B,$66,$67,$15,$68,$67,$15,$1F,$32 ; B7A0
        .byte   $69,$6A,$4D,$69,$6A,$4D,$1F,$3B,$69,$6A,$4D,$69,$6A,$4D,$1F,$20 ; B7B0
; layout $07
        .byte   $6B,$53,$23,$24,$29,$6C,$25,$37,$6B,$47,$47,$47,$47,$53,$23,$6C ; B7C0
        .byte   $6B,$3E,$6D,$3E,$3E,$6E,$6F,$46,$6B,$40,$70,$40,$40,$49,$40,$46 ; B7D0
        .byte   $71,$45,$72,$45,$45,$4A,$45,$32,$1B,$1B,$1A,$1B,$3C,$15,$15,$3B ; B7E0
        .byte   $1F,$1F,$3B,$1F,$1F,$3D,$73,$32,$1F,$1F,$32,$1F,$1F,$32,$6B,$32 ; B7F0
; layout $08
        .byte   $23,$53,$39,$24,$23,$74,$75,$76,$77,$4E,$78,$4E,$4D,$4E,$4D,$78 ; B800
        .byte   $79,$5A,$52,$51,$50,$5A,$50,$52,$7A,$10,$11,$0E,$05,$10,$05,$0F ; B810
        .byte   $7B,$12,$13,$12,$14,$12,$14,$13,$7C,$15,$16,$15,$2B,$2C,$2B,$1A ; B820
        .byte   $7D,$3D,$17,$18,$1F,$34,$7E,$7F,$6B,$32,$41,$1C,$1F,$1C,$1D,$1C ; B830
; layout $09
        .byte   $75,$74,$75,$58,$75,$80,$81,$74,$4E,$4D,$4D,$60,$4E,$5E,$5F,$4D ; B840
        .byte   $5A,$50,$50,$51,$5A,$50,$5A,$50,$10,$05,$05,$0E,$82,$83,$84,$85 ; B850
        .byte   $12,$86,$87,$12,$12,$14,$12,$14,$3C,$3C,$88,$15,$88,$89,$8A,$1A ; B860
        .byte   $1F,$1F,$19,$4D,$19,$8B,$8C,$32,$3F,$3F,$1D,$4D,$1D,$69,$6A,$32 ; B870
; layout $0A
        .byte   $75,$74,$75,$74,$58,$75,$75,$8D,$4E,$4D,$4D,$4D,$60,$4E,$4D,$8D ; B880
        .byte   $8E,$8F,$50,$50,$51,$5A,$50,$8D,$10,$05,$05,$05,$0E,$8E,$90,$8D ; B890
        .byte   $12,$14,$86,$91,$12,$12,$14,$8D,$3C,$88,$88,$88,$15,$88,$88,$92 ; B8A0
        .byte   $1F,$2F,$3C,$18,$4D,$18,$1B,$1A,$3F,$35,$3F,$1C,$4D,$1C,$1F,$32 ; B8B0
; layout $0B
        .byte   $43,$93,$23,$24,$25,$37,$36,$36,$1F,$94,$47,$47,$29,$6C,$4C,$37 ; B8C0
        .byte   $43,$95,$6D,$3E,$96,$32,$97,$6C,$46,$40,$70,$40,$40,$53,$23,$44 ; B8D0
        .byte   $46,$40,$70,$40,$40,$98,$99,$9A,$1F,$9B,$9C,$9B,$9B,$9D,$9B,$9E ; B8E0
        .byte   $46,$88,$88,$88,$19,$17,$1B,$9F,$1F,$3D,$1B,$3D,$1D,$41,$1F,$8D ; B8F0
; layout $0C
        .byte   $54,$A0,$A1,$A0,$A2,$A3,$A4,$A5,$56,$A6,$A7,$A8,$A9,$05,$05,$05 ; B900
        .byte   $1F,$0B,$0C,$05,$0B,$05,$1B,$3D,$54,$10,$11,$05,$10,$3D,$43,$46 ; B910
        .byte   $56,$12,$13,$14,$3C,$32,$30,$32,$43,$15,$16,$1A,$43,$4B,$1C,$7F ; B920
        .byte   $1F,$AA,$3C,$4B,$30,$35,$36,$1C,$1F,$8D,$56,$35,$1C,$36,$36,$36 ; B930
; layout $0D
        .byte   $A1,$A0,$AB,$AC,$A4,$AC,$A4,$AC,$AD,$06,$05,$08,$05,$05,$05,$08 ; B940
        .byte   $3C,$3D,$05,$0C,$05,$05,$0B,$0C,$46,$32,$3C,$3D,$05,$05,$10,$11 ; B950
        .byte   $33,$32,$7E,$32,$1B,$1A,$3C,$1A,$1C,$1E,$1D,$3A,$7E,$3B,$1F,$34 ; B960
        .byte   $37,$42,$37,$1E,$1D,$34,$33,$1C,$41,$32,$41,$36,$36,$1C,$1C,$36 ; B970
; layout $0E
        .byte   $AE,$A0,$A1,$AF,$B0,$B1,$B2,$3A,$05,$21,$04,$05,$05,$08,$B3,$20 ; B980
        .byte   $05,$0B,$05,$09,$0B,$0C,$05,$32,$05,$10,$05,$0E,$10,$11,$05,$3B ; B990
        .byte   $1B,$1A,$14,$12,$12,$13,$14,$3A,$3F,$B4,$3C,$3D,$15,$16,$15,$20 ; B9A0
        .byte   $37,$B5,$3F,$7F,$3C,$1A,$3E,$3A,$41,$32,$57,$6C,$1F,$20,$40,$20 ; B9B0
; layout $0F
        .byte   $54,$53,$39,$44,$29,$53,$37,$3B,$1F,$47,$47,$47,$47,$47,$47,$53 ; B9C0
        .byte   $1F,$3E,$6D,$3E,$3E,$48,$B6,$B7,$43,$40,$70,$40,$40,$49,$96,$3D ; B9D0
        .byte   $1F,$40,$70,$B8,$91,$49,$40,$3B,$1F,$40,$70,$3E,$3E,$49,$40,$44 ; B9E0
        .byte   $1F,$40,$70,$40,$40,$49,$B6,$B7,$56,$40,$70,$40,$40,$49,$B8,$91 ; B9F0
; layout $10
        .byte   $43,$40,$70,$B9,$40,$49,$BA,$1A,$1F,$B9,$70,$BB,$40,$49,$40,$3B ; BA00
        .byte   $1F,$BB,$70,$BB,$B9,$49,$40,$20,$43,$BC,$70,$BB,$BB,$49,$B9,$3A ; BA10
        .byte   $1F,$B9,$70,$BB,$BB,$49,$BB,$32,$43,$BB,$70,$BC,$BB,$49,$BB,$3B ; BA20
        .byte   $54,$BB,$70,$40,$BB,$49,$BB,$20,$56,$BD,$70,$3D,$BE,$BF,$3C,$32 ; BA30
; layout $11
        .byte   $43,$BB,$70,$32,$C0,$C1,$C2,$C3,$1F,$BB,$70,$53,$C4,$C5,$38,$44 ; BA40
        .byte   $43,$BB,$70,$C6,$C6,$6E,$C6,$C6,$43,$BB,$70,$BB,$BB,$49,$BB,$BB ; BA50
        .byte   $1F,$1A,$BE,$BF,$BD,$49,$BB,$BB,$3F,$4B,$C7,$C8,$C9,$BF,$BB,$BB ; BA60
        .byte   $36,$35,$CA,$CB,$C7,$C8,$CC,$CD,$36,$36,$CE,$CF,$CA,$CB,$1F,$1E ; BA70
; layout $12
        .byte   $37,$26,$CA,$CB,$CE,$CF,$CA,$CB,$39,$2A,$C4,$C5,$C4,$C5,$C4,$C5 ; BA80
        .byte   $6E,$C6,$C6,$6E,$D0,$96,$D1,$96,$49,$BD,$D2,$D3,$D4,$D5,$D6,$D5 ; BA90
        .byte   $B8,$91,$75,$C3,$C2,$C3,$23,$74,$D7,$D8,$D8,$53,$38,$44,$6E,$3E ; BAA0
        .byte   $D9,$CD,$DA,$DB,$DC,$DB,$D9,$D5,$33,$1E,$C0,$C1,$C0,$C1,$33,$1E ; BAB0
; layout $13
        .byte   $41,$53,$C4,$C5,$C4,$C5,$39,$3B,$23,$6E,$C6,$C6,$6E,$96,$96,$32 ; BAC0
        .byte   $C6,$49,$BD,$BB,$49,$40,$40,$3B,$BB,$49,$BB,$BB,$49,$D5,$40,$3A ; BAD0
        .byte   $BB,$49,$BB,$BB,$D9,$32,$40,$3B,$BB,$49,$BB,$DD,$54,$3A,$40,$20 ; BAE0
        .byte   $CC,$D3,$CC,$4B,$33,$32,$40,$32,$1F,$20,$3F,$35,$41,$32,$40,$32 ; BAF0
; layout $14
        .byte   $43,$1E,$37,$6C,$43,$53,$40,$32,$3F,$36,$41,$44,$23,$96,$40,$3A ; BB00
        .byte   $36,$37,$54,$96,$6E,$40,$3C,$32,$37,$6C,$43,$9B,$1B,$18,$33,$1E ; BB10
        .byte   $25,$32,$23,$15,$29,$B5,$1C,$36,$54,$53,$DE,$DE,$DE,$44,$57,$26 ; BB20
        .byte   $56,$96,$DF,$4D,$E0,$96,$54,$4F,$1F,$36,$DF,$4D,$E0,$36,$1F,$32 ; BB30
; layout $15
        .byte   $54,$E1,$E2,$DE,$E3,$E1,$1F,$20,$1F,$36,$DF,$4D,$E4,$E5,$1F,$3A ; BB40
        .byte   $43,$E5,$E6,$4D,$E0,$3D,$54,$3B,$1F,$3D,$E2,$DE,$E3,$32,$43,$7F ; BB50
        .byte   $30,$3A,$DF,$E4,$36,$32,$7E,$1C,$1C,$3B,$E5,$E7,$E8,$3A,$35,$36 ; BB60
        .byte   $36,$34,$1B,$DE,$E3,$32,$36,$36,$36,$1C,$1F,$4D,$E0,$32,$36,$36 ; BB70
; layout $16
        .byte   $36,$26,$1F,$4D,$E0,$3A,$37,$36,$36,$4F,$29,$DE,$E3,$32,$41,$37 ; BB80
        .byte   $37,$3B,$96,$4D,$E4,$32,$54,$B5,$25,$32,$DF,$E9,$EA,$3A,$56,$3A ; BB90
        .byte   $1F,$3B,$E6,$E4,$E5,$3B,$1F,$3B,$43,$3B,$E2,$E3,$1B,$3B,$7E,$1E ; BBA0
        .byte   $1F,$3B,$DF,$E0,$54,$34,$1D,$36,$1F,$32,$E6,$E4,$1F,$1C,$36,$36 ; BBB0
; layout $17
        .byte   $54,$53,$47,$47,$43,$37,$36,$42,$1F,$6E,$3E,$D8,$43,$B5,$37,$3B ; BBC0
        .byte   $43,$49,$40,$BB,$43,$32,$41,$3A,$43,$49,$B6,$B7,$29,$53,$29,$44 ; BBD0
        .byte   $1F,$49,$96,$C6,$6E,$C6,$C6,$6E,$43,$49,$40,$BB,$49,$BB,$BB,$49 ; BBE0
        .byte   $1F,$BE,$BF,$C9,$BF,$BE,$BF,$C9,$1F,$CE,$CF,$CE,$CF,$CE,$CF,$CE ; BBF0
; layout $18
        .byte   $25,$53,$39,$24,$29,$24,$23,$3B,$43,$96,$6E,$C6,$C6,$6E,$96,$32 ; BC00
        .byte   $1F,$B9,$49,$BB,$BB,$49,$B9,$3B,$29,$BB,$49,$BB,$BB,$1A,$BB,$32 ; BC10
        .byte   $96,$BB,$49,$BB,$1B,$32,$BB,$32,$40,$BC,$1B,$1A,$43,$32,$BC,$3A ; BC20
        .byte   $BF,$3D,$43,$32,$1F,$32,$40,$32,$CF,$32,$1F,$32,$56,$32,$40,$32 ; BC30
; layout $19
        .byte   $C5,$53,$23,$53,$29,$44,$40,$3B,$54,$96,$EB,$C6,$C6,$6E,$40,$32 ; BC40
        .byte   $43,$40,$70,$BB,$BB,$49,$40,$3A,$43,$B9,$70,$BB,$BB,$1A,$1B,$3A ; BC50
        .byte   $43,$BB,$70,$C9,$BF,$32,$7E,$3B,$1F,$BB,$70,$C7,$C8,$34,$1D,$3B ; BC60
        .byte   $43,$BB,$70,$EC,$ED,$1C,$4C,$32,$1F,$BD,$70,$CE,$CF,$42,$97,$32 ; BC70
; layout $1A
        .byte   $1F,$BB,$70,$C4,$C5,$24,$29,$3B,$54,$BB,$70,$96,$C6,$6E,$96,$32 ; BC80
        .byte   $23,$BB,$70,$B9,$BB,$49,$40,$3A,$C9,$BF,$70,$BB,$BB,$49,$40,$32 ; BC90
        .byte   $C7,$C8,$70,$BB,$BB,$49,$40,$EE,$EC,$ED,$70,$BC,$BB,$49,$40,$EF ; BCA0
        .byte   $C7,$C8,$3C,$2F,$1B,$2F,$17,$1A,$EC,$ED,$1F,$35,$3F,$35,$1C,$32 ; BCB0
; layout $1B
        .byte   $25,$36,$3F,$7F,$3F,$1E,$37,$B5,$1F,$37,$57,$1C,$36,$26,$41,$3A ; BCC0
        .byte   $54,$B5,$54,$42,$4C,$4F,$1F,$3B,$43,$32,$43,$3A,$97,$3B,$1F,$3A ; BCD0
        .byte   $75,$74,$75,$74,$75,$74,$75,$EE,$3E,$D8,$6D,$D8,$D8,$48,$3E,$EF ; BCE0
        .byte   $BE,$BF,$C9,$BF,$1B,$18,$19,$3D,$CE,$CF,$CE,$CF,$3F,$1C,$1D,$32 ; BCF0
; layout $1C
        .byte   $C4,$C5,$29,$24,$39,$53,$F0,$F1,$F2,$47,$47,$47,$47,$47,$47,$F3 ; BD00
        .byte   $F4,$D8,$70,$40,$3E,$48,$D8,$F5,$F6,$BB,$70,$B9,$B9,$49,$BB,$F7 ; BD10
        .byte   $F8,$BB,$70,$BB,$BB,$49,$BB,$F9,$FA,$BB,$70,$BC,$BC,$49,$BB,$F9 ; BD20
        .byte   $BE,$BF,$3C,$2F,$1B,$1A,$FB,$FC,$CE,$CF,$33,$35,$3F,$1E,$FD,$FE ; BD30
; layout $1D
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BD40
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BD50
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BD60
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BD70
; layout $1E
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BD80
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BD90
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BDA0
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BDB0
; layout $1F
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BDC0
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BDD0
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BDE0
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BDF0
; layout $20
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BE00
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BE10
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BE20
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BE30
; layout $21
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BE40
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BE50
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BE60
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BE70
; layout $22
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BE80
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BE90
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BEA0
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BEB0
; layout $23
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BEC0
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BED0
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BEE0
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BEF0
; layout $24
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BF00
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BF10
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BF20
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BF30
; layout $25
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BF40
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BF50
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BF60
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BF70
; layout $26
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BF80
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BF90
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BFA0
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BFB0
; layout $27
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BFC0
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BFD0
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BFE0
        .byte   $4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D,$4D ; BFF0
