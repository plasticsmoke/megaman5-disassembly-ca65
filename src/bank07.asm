.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK07"

; =============================================================================
; BANK $07 (mapped at $A000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
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
        brk                                     ; A818 00                       .
        ora     ($01,x)                         ; A819 01 01                    ..
        ora     ($01,x)                         ; A81B 01 01                    ..
        ora     (L0000,x)                       ; A81D 01 00                    ..
        brk                                     ; A81F 00                       .
        ora     ($01,x)                         ; A820 01 01                    ..
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
        ora     ($01,x)                         ; A833 01 01                    ..
        brk                                     ; A835 00                       .
        ora     (L0000,x)                       ; A836 01 00                    ..
        brk                                     ; A838 00                       .
        ora     ($01,x)                         ; A839 01 01                    ..
        ora     (L0000,x)                       ; A83B 01 00                    ..
        brk                                     ; A83D 00                       .
        brk                                     ; A83E 00                       .
        brk                                     ; A83F 00                       .
        brk                                     ; A840 00                       .
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
        brk                                     ; A84F 00                       .
        ora     (L0000,x)                       ; A850 01 00                    ..
        ora     ($01,x)                         ; A852 01 01                    ..
        ora     (L0000,x)                       ; A854 01 00                    ..
        ora     (L0000,x)                       ; A856 01 00                    ..
        brk                                     ; A858 00                       .
        ora     ($01,x)                         ; A859 01 01                    ..
        brk                                     ; A85B 00                       .
        ora     ($01,x)                         ; A85C 01 01                    ..
        brk                                     ; A85E 00                       .
        brk                                     ; A85F 00                       .
        ora     (L0000,x)                       ; A860 01 00                    ..
        ora     ($01,x)                         ; A862 01 01                    ..
        ora     (L0000,x)                       ; A864 01 00                    ..
        .byte   $02                             ; A866 02                       .
        ora     ($01,x)                         ; A867 01 01                    ..
        ora     (L0000,x)                       ; A869 01 00                    ..
        brk                                     ; A86B 00                       .
        brk                                     ; A86C 00                       .
        brk                                     ; A86D 00                       .
        .byte   $04                             ; A86E 04                       .
        brk                                     ; A86F 00                       .
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
        brk                                     ; A87B 00                       .
        ora     (L0000,x)                       ; A87C 01 00                    ..
        brk                                     ; A87E 00                       .
        brk                                     ; A87F 00                       .
        brk                                     ; A880 00                       .
        brk                                     ; A881 00                       .
        brk                                     ; A882 00                       .
        ora     (L0000,x)                       ; A883 01 00                    ..
        brk                                     ; A885 00                       .
        brk                                     ; A886 00                       .
        brk                                     ; A887 00                       .
        brk                                     ; A888 00                       .
        brk                                     ; A889 00                       .
        brk                                     ; A88A 00                       .
        brk                                     ; A88B 00                       .
        brk                                     ; A88C 00                       .
        brk                                     ; A88D 00                       .
        brk                                     ; A88E 00                       .
        brk                                     ; A88F 00                       .
        brk                                     ; A890 00                       .
        brk                                     ; A891 00                       .
        brk                                     ; A892 00                       .
        brk                                     ; A893 00                       .
        brk                                     ; A894 00                       .
        brk                                     ; A895 00                       .
        brk                                     ; A896 00                       .
        brk                                     ; A897 00                       .
        brk                                     ; A898 00                       .
        brk                                     ; A899 00                       .
        brk                                     ; A89A 00                       .
        brk                                     ; A89B 00                       .
        brk                                     ; A89C 00                       .
        brk                                     ; A89D 00                       .
        ora     (L0000,x)                       ; A89E 01 00                    ..
        brk                                     ; A8A0 00                       .
        brk                                     ; A8A1 00                       .
        brk                                     ; A8A2 00                       .
        brk                                     ; A8A3 00                       .
        brk                                     ; A8A4 00                       .
        brk                                     ; A8A5 00                       .
        brk                                     ; A8A6 00                       .
        brk                                     ; A8A7 00                       .
        brk                                     ; A8A8 00                       .
        brk                                     ; A8A9 00                       .
        brk                                     ; A8AA 00                       .
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
        brk                                     ; A8BB 00                       .
        brk                                     ; A8BC 00                       .
        ora     (L0002,x)                       ; A8BD 01 02                    ..
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
        ora     (L0002,x)                       ; A901 01 02                    ..
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
        brk                                     ; A91D 00                       .
        brk                                     ; A91E 00                       .
        bvc     LA921                           ; A91F 50 00                    P.
LA921:  php                                     ; A921 08                       .
        brk                                     ; A922 00                       .
LA923:  brk                                     ; A923 00                       .
        brk                                     ; A924 00                       .
        brk                                     ; A925 00                       .
        php                                     ; A926 08                       .
        .byte   $04                             ; A927 04                       .
        brk                                     ; A928 00                       .
        eor     (L0000,x)                       ; A929 41 00                    A.
        brk                                     ; A92B 00                       .
        brk                                     ; A92C 00                       .
        bvc     LA92F                           ; A92D 50 00                    P.
LA92F:  eor     (L0000,x)                       ; A92F 41 00                    A.
        rti                                     ; A931 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; A932 00                       .
        brk                                     ; A933 00                       .
        brk                                     ; A934 00                       .
        brk                                     ; A935 00                       .
        php                                     ; A936 08                       .
        ora     ($08),y                         ; A937 11 08                    ..
        brk                                     ; A939 00                       .
        .byte   $80                             ; A93A 80                       .
        .byte   $62                             ; A93B 62                       b
        brk                                     ; A93C 00                       .
        ora     (L0020,x)                       ; A93D 01 20                    . 
        brk                                     ; A93F 00                       .
        php                                     ; A940 08                       .
        brk                                     ; A941 00                       .
        brk                                     ; A942 00                       .
        sty     L0000                           ; A943 84 00                    ..
        .byte   $02                             ; A945 02                       .
        brk                                     ; A946 00                       .
        bpl     LA94B                           ; A947 10 02                    ..
        ora     L0002                           ; A949 05 02                    ..
LA94B:  .byte   $04                             ; A94B 04                       .
        plp                                     ; A94C 28                       (
        ora     L0002                           ; A94D 05 02                    ..
        asl     $4022                           ; A94F 0E 22 40                 ."@
        .byte   $62                             ; A952 62                       b
        .byte   $80                             ; A953 80                       .
        ldx     #$80                            ; A954 A2 80                    ..
        ldx     #$40                            ; A956 A2 40                    .@
        rti                                     ; A958 40                       @

; ----------------------------------------------------------------------------
        .byte   $62                             ; A959 62                       b
        rti                                     ; A95A 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; A95B 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; A95C 40                       @

; ----------------------------------------------------------------------------
        adc     (L0040,x)                       ; A95D 61 40                    a@
        rts                                     ; A95F 60                       `

; ----------------------------------------------------------------------------
        jsr     L0020                           ; A960 20 20 00                   .
        brk                                     ; A963 00                       .
        brk                                     ; A964 00                       .
        .byte   $80                             ; A965 80                       .
        jsr     L2420                           ; A966 20 20 24                   $
        ora     #$10                            ; A969 09 10                    ..
        asl     $0A11,x                         ; A96B 1E 11 0A                 ...
        .byte   $12                             ; A96E 12                       .
        .byte   $02                             ; A96F 02                       .
        .byte   $13                             ; A970 13                       .
        asl     a                               ; A971 0A                       .
        brk                                     ; A972 00                       .
        brk                                     ; A973 00                       .
        brk                                     ; A974 00                       .
        plp                                     ; A975 28                       (
        plp                                     ; A976 28                       (
        .byte   $02                             ; A977 02                       .
        .byte   $80                             ; A978 80                       .
        tsx                                     ; A979 BA                       .
        brk                                     ; A97A 00                       .
        brk                                     ; A97B 00                       .
        .byte   $80                             ; A97C 80                       .
        brk                                     ; A97D 00                       .
        asl     a                               ; A97E 0A                       .
        sty     $9C                             ; A97F 84 9C                    ..
        .byte   $9E                             ; A981 9E                       .
        brk                                     ; A982 00                       .
        bpl     LA9A5                           ; A983 10 20                    . 
        plp                                     ; A985 28                       (
        .byte   $80                             ; A986 80                       .
        brk                                     ; A987 00                       .
        .byte   $0F                             ; A988 0F                       .
        jsr     L0101                           ; A989 20 01 01                  ..
        .byte   $0F                             ; A98C 0F                       .
        jsr     L111C                           ; A98D 20 1C 11                  ..
        .byte   $0F                             ; A990 0F                       .
        .byte   $23                             ; A991 23                       #
        .byte   $12                             ; A992 12                       .
        .byte   $03                             ; A993 03                       .
        .byte   $0F                             ; A994 0F                       .
        and     ($21),y                         ; A995 31 21                    1!
        .byte   $1C                             ; A997 1C                       .
        .byte   $82                             ; A998 82                       .
        sty     L0000                           ; A999 84 00                    ..
        brk                                     ; A99B 00                       .
        .byte   $0F                             ; A99C 0F                       .
        jsr     L0101                           ; A99D 20 01 01                  ..
        .byte   $0F                             ; A9A0 0F                       .
        jsr     L111C                           ; A9A1 20 1C 11                  ..
        .byte   $0F                             ; A9A4 0F                       .
LA9A5:  .byte   $23                             ; A9A5 23                       #
        .byte   $12                             ; A9A6 12                       .
LA9A7:  .byte   $03                             ; A9A7 03                       .
        .byte   $0F                             ; A9A8 0F                       .
        .byte   $22                             ; A9A9 22                       "
        .byte   $12                             ; A9AA 12                       .
        .byte   $02                             ; A9AB 02                       .
        .byte   $82                             ; A9AC 82                       .
        sty     L0000                           ; A9AD 84 00                    ..
        brk                                     ; A9AF 00                       .
        .byte   $0F                             ; A9B0 0F                       .
        jsr     L1501                           ; A9B1 20 01 15                  ..
        .byte   $0F                             ; A9B4 0F                       .
        jsr     L111C                           ; A9B5 20 1C 11                  ..
        .byte   $0F                             ; A9B8 0F                       .
        .byte   $23                             ; A9B9 23                       #
        .byte   $12                             ; A9BA 12                       .
        .byte   $03                             ; A9BB 03                       .
        .byte   $0F                             ; A9BC 0F                       .
        and     $25,x                           ; A9BD 35 25                    5%
        ora     $94,x                           ; A9BF 15 94                    ..
        .byte   $97                             ; A9C1 97                       .
        brk                                     ; A9C2 00                       .
        brk                                     ; A9C3 00                       .
        .byte   $0F                             ; A9C4 0F                       .
        jsr     L0101                           ; A9C5 20 01 01                  ..
        .byte   $0F                             ; A9C8 0F                       .
        jsr     L111C                           ; A9C9 20 1C 11                  ..
        .byte   $0F                             ; A9CC 0F                       .
        .byte   $23                             ; A9CD 23                       #
        .byte   $12                             ; A9CE 12                       .
        .byte   $03                             ; A9CF 03                       .
        .byte   $0F                             ; A9D0 0F                       .
        jsr     L1210                           ; A9D1 20 10 12                  ..
        .byte   $82                             ; A9D4 82                       .
        sty     L0000                           ; A9D5 84 00                    ..
        brk                                     ; A9D7 00                       .
        .byte   $80                             ; A9D8 80                       .
        ora     (L0020,x)                       ; A9D9 01 20                    . 
        brk                                     ; A9DB 00                       .
        .byte   $80                             ; A9DC 80                       .
        brk                                     ; A9DD 00                       .
        .byte   $22                             ; A9DE 22                       "
        ora     #$FF                            ; A9DF 09 FF                    ..
        jsr     L2000                           ; A9E1 20 00 20                  . 
        .byte   $02                             ; A9E4 02                       .
        sty     L00A0                           ; A9E5 84 A0                    ..
        .byte   $02                             ; A9E7 02                       .
        dey                                     ; A9E8 88                       .
        ora     (L0000,x)                       ; A9E9 01 00                    ..
        .byte   $04                             ; A9EB 04                       .
        brk                                     ; A9EC 00                       .
        asl     a                               ; A9ED 0A                       .
        php                                     ; A9EE 08                       .
        and     (L0000,x)                       ; A9EF 21 00                    !.
        brk                                     ; A9F1 00                       .
        .byte   $02                             ; A9F2 02                       .
        .byte   $12                             ; A9F3 12                       .
        .byte   $80                             ; A9F4 80                       .
        .byte   $64                             ; A9F5 64                       d
        jsr     L0000                           ; A9F6 20 00 00                  ..
        brk                                     ; A9F9 00                       .
        brk                                     ; A9FA 00                       .
        brk                                     ; A9FB 00                       .
        php                                     ; A9FC 08                       .
        brk                                     ; A9FD 00                       .
        brk                                     ; A9FE 00                       .
        brk                                     ; A9FF 00                       .
        ora     ($01,x)                         ; AA00 01 01                    ..
        .byte   $02                             ; AA02 02                       .
        .byte   $02                             ; AA03 02                       .
        .byte   $03                             ; AA04 03                       .
        .byte   $03                             ; AA05 03                       .
        .byte   $04                             ; AA06 04                       .
        ora     $05                             ; AA07 05 05                    ..
        ora     $05                             ; AA09 05 05                    ..
        asl     $06                             ; AA0B 06 06                    ..
        .byte   $06                             ; AA0D 06                       .
LAA0E:  asl     $07                             ; AA0E 06 07                    ..
        php                                     ; AA10 08                       .
        ora     #$09                            ; AA11 09 09                    ..
        ora     #$0A                            ; AA13 09 0A                    ..
        asl     a                               ; AA15 0A                       .
        asl     a                               ; AA16 0A                       .
        .byte   $0B                             ; AA17 0B                       .
        .byte   $0B                             ; AA18 0B                       .
        .byte   $0C                             ; AA19 0C                       .
        .byte   $0C                             ; AA1A 0C                       .
        .byte   $0C                             ; AA1B 0C                       .
        ora     $0D0D                           ; AA1C 0D 0D 0D                 ...
        asl     $0F0E                           ; AA1F 0E 0E 0F                 ...
        .byte   $0F                             ; AA22 0F                       .
        .byte   $0F                             ; AA23 0F                       .
        bpl     LAA36                           ; AA24 10 10                    ..
        .byte   $10                             ; AA26 10                       .
LAA27:  .byte   $12                             ; AA27 12                       .
        .byte   $12                             ; AA28 12                       .
LAA29:  .byte   $12                             ; AA29 12                       .
        .byte   $12                             ; AA2A 12                       .
LAA2B:  .byte   $13                             ; AA2B 13                       .
        .byte   $13                             ; AA2C 13                       .
        .byte   $13                             ; AA2D 13                       .
        asl     $17,x                           ; AA2E 16 17                    ..
LAA30:  .byte   $17                             ; AA30 17                       .
        clc                                     ; AA31 18                       .
        clc                                     ; AA32 18                       .
        clc                                     ; AA33 18                       .
        clc                                     ; AA34 18                       .
        .byte   $19                             ; AA35 19                       .
LAA36:  ora     $1C1A,y                         ; AA36 19 1A 1C                 ...
        .byte   $FF                             ; AA39 FF                       .
LAA3A:  brk                                     ; AA3A 00                       .
        brk                                     ; AA3B 00                       .
        brk                                     ; AA3C 00                       .
        brk                                     ; AA3D 00                       .
LAA3E:  brk                                     ; AA3E 00                       .
        .byte   $80                             ; AA3F 80                       .
        brk                                     ; AA40 00                       .
        brk                                     ; AA41 00                       .
        brk                                     ; AA42 00                       .
        brk                                     ; AA43 00                       .
LAA44:  brk                                     ; AA44 00                       .
        ora     ($80),y                         ; AA45 11 80                    ..
        .byte   $02                             ; AA47 02                       .
        brk                                     ; AA48 00                       .
        brk                                     ; AA49 00                       .
        brk                                     ; AA4A 00                       .
        jsr     L0000                           ; AA4B 20 00 00                  ..
        brk                                     ; AA4E 00                       .
        .byte   $80                             ; AA4F 80                       .
        brk                                     ; AA50 00                       .
LAA51:  clc                                     ; AA51 18                       .
        .byte   $80                             ; AA52 80                       .
        .byte   $82                             ; AA53 82                       .
        ldy     #$04                            ; AA54 A0 04                    ..
        brk                                     ; AA56 00                       .
LAA57:  brk                                     ; AA57 00                       .
        .byte   $80                             ; AA58 80                       .
        php                                     ; AA59 08                       .
        brk                                     ; AA5A 00                       .
        rti                                     ; AA5B 40                       @

; ----------------------------------------------------------------------------
        .byte   $02                             ; AA5C 02                       .
        rti                                     ; AA5D 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AA5E 00                       .
        pha                                     ; AA5F 48                       H
        brk                                     ; AA60 00                       .
        ora     (L0002),y                       ; AA61 11 02                    ..
        brk                                     ; AA63 00                       .
        php                                     ; AA64 08                       .
        .byte   $02                             ; AA65 02                       .
        .byte   $80                             ; AA66 80                       .
        brk                                     ; AA67 00                       .
        brk                                     ; AA68 00                       .
        .byte   $02                             ; AA69 02                       .
        brk                                     ; AA6A 00                       .
        brk                                     ; AA6B 00                       .
        brk                                     ; AA6C 00                       .
        brk                                     ; AA6D 00                       .
        ldy     #$81                            ; AA6E A0 81                    ..
        brk                                     ; AA70 00                       .
        .byte   $12                             ; AA71 12                       .
        brk                                     ; AA72 00                       .
        bit     $0920                           ; AA73 2C 20 09                 , .
        brk                                     ; AA76 00                       .
        php                                     ; AA77 08                       .
        php                                     ; AA78 08                       .
        .byte   $04                             ; AA79 04                       .
        .byte   $02                             ; AA7A 02                       .
        brk                                     ; AA7B 00                       .
        brk                                     ; AA7C 00                       .
        .byte   $04                             ; AA7D 04                       .
        .byte   $02                             ; AA7E 02                       .
        and     ($08,x)                         ; AA7F 21 08                    !.
        sei                                     ; AA81 78                       x
        rti                                     ; AA82 40                       @

; ----------------------------------------------------------------------------
        ldy     #$50                            ; AA83 A0 50                    .P
        bvs     LAA27                           ; AA85 70 A0                    p.
        jsr     LB070                           ; AA87 20 70 B0                  p.
        beq     LAAAC                           ; AA8A F0 20                    . 
        bvc     LAA0E                           ; AA8C 50 80                    P.
        .byte   $B0                             ; AA8E B0                       .
LAA8F:  .byte   $30,$90                    ; AA8F 30 90   (branch out of range for ca65: target has no local label)
        bvs     LAA2B                           ; AA91 70 98                    p.
        cpy     #$18                            ; AA93 C0 18                    ..
        bcc     LAA57                           ; AA95 90 C0                    ..
        bvc     LAA29                           ; AA97 50 90                    P.
        bvs     LAA2B                           ; AA99 70 90                    p.
        bcs     LAA9D                           ; AA9B B0 00                    ..
LAA9D:  bmi     LAA8F                           ; AA9D 30 F0                    0.
        bvs     LAA51                           ; AA9F 70 B0                    p.
        bpl     LAAD3                           ; AAA1 10 30                    .0
        bne     LAAD5                           ; AAA3 D0 30                    .0
        cpy     #$E8                            ; AAA5 C0 E8                    ..
        .byte   $30                             ; AAA7 30                       0
LAAA8:  .byte   $70                             ; AAA8 70                       p
LAAA9:  tay                                     ; AAA9 A8                       .
        beq     LAABC                           ; AAAA F0 10                    ..
LAAAC:  bvs     LAA3E                           ; AAAC 70 90                    p.
        bvc     LAA30                           ; AAAE 50 80                    P.
        cpy     #$50                            ; AAB0 C0 50                    .P
        bvs     LAA44                           ; AAB2 70 90                    p.
        bcs     LAB1E                           ; AAB4 B0 68                    .h
        tay                                     ; AAB6 A8                       .
        cpy     #$D8                            ; AAB7 C0 D8                    ..
        .byte   $FF                             ; AAB9 FF                       .
        php                                     ; AABA 08                       .
        rol     a                               ; AABB 2A                       *
LAABC:  jsr     L8081                           ; AABC 20 81 80                  ..
        rti                                     ; AABF 40                       @

; ----------------------------------------------------------------------------
LAAC0:  brk                                     ; AAC0 00                       .
        brk                                     ; AAC1 00                       .
        brk                                     ; AAC2 00                       .
        brk                                     ; AAC3 00                       .
        .byte   $82                             ; AAC4 82                       .
        .byte   $83                             ; AAC5 83                       .
        brk                                     ; AAC6 00                       .
        .byte   $12                             ; AAC7 12                       .
        brk                                     ; AAC8 00                       .
        bvc     LAACB                           ; AAC9 50 00                    P.
LAACB:  brk                                     ; AACB 00                       .
        brk                                     ; AACC 00                       .
        .byte   $04                             ; AACD 04                       .
        php                                     ; AACE 08                       .
        brk                                     ; AACF 00                       .
        brk                                     ; AAD0 00                       .
        rti                                     ; AAD1 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AAD2 00                       .
LAAD3:  .byte   $22                             ; AAD3 22                       "
        brk                                     ; AAD4 00                       .
LAAD5:  asl     L0000                           ; AAD5 06 00                    ..
        brk                                     ; AAD7 00                       .
        jsr     L0004                           ; AAD8 20 04 00                  ..
        .byte   $21                             ; AADB 21                       !
LAADC:  brk                                     ; AADC 00                       .
        jsr     L21A2                           ; AADD 20 A2 21                  .!
        brk                                     ; AAE0 00                       .
        .byte   $04                             ; AAE1 04                       .
        .byte   $80                             ; AAE2 80                       .
        .byte   $80                             ; AAE3 80                       .
        .byte   $02                             ; AAE4 02                       .
        .byte   $12                             ; AAE5 12                       .
        brk                                     ; AAE6 00                       .
        brk                                     ; AAE7 00                       .
        brk                                     ; AAE8 00                       .
        eor     #$00                            ; AAE9 49 00                    I.
        jsr     L4000                           ; AAEB 20 00 40                  .@
        .byte   $80                             ; AAEE 80                       .
        asl     a                               ; AAEF 0A                       .
        jsr     L0044                           ; AAF0 20 44 00                  D.
        .byte   $04                             ; AAF3 04                       .
        .byte   $02                             ; AAF4 02                       .
        brk                                     ; AAF5 00                       .
        .byte   $02                             ; AAF6 02                       .
        clc                                     ; AAF7 18                       .
        .byte   $02                             ; AAF8 02                       .
        brk                                     ; AAF9 00                       .
        .byte   $80                             ; AAFA 80                       .
LAAFB:  .byte   $80                             ; AAFB 80                       .
        jsr     L0011                           ; AAFC 20 11 00                  ..
        ora     #$B8                            ; AAFF 09 B8                    ..
        tay                                     ; AB01 A8                       .
LAB02:  tya                                     ; AB02 98                       .
        tya                                     ; AB03 98                       .
        bvc     LAB76                           ; AB04 50 70                    Pp
        clv                                     ; AB06 B8                       .
        clv                                     ; AB07 B8                       .
        bmi     LAB3A                           ; AB08 30 30                    00
        bmi     LAB3C                           ; AB0A 30 30                    00
        bmi     LAB3E                           ; AB0C 30 30                    00
        bmi     LAAA8                           ; AB0E 30 98                    0.
        ldx     #$30                            ; AB10 A2 30                    .0
        .byte   $62                             ; AB12 62                       b
        bmi     LAB47                           ; AB13 30 32                    02
        bmi     LAB69                           ; AB15 30 52                    0R
        iny                                     ; AB17 C8                       .
        .byte   $B0                             ; AB18 B0                       .
LAB19:  tya                                     ; AB19 98                       .
        sei                                     ; AB1A 78                       x
        cli                                     ; AB1B 58                       X
        sec                                     ; AB1C 38                       8
        sec                                     ; AB1D 38                       8
LAB1E:  .byte   $52                             ; AB1E 52                       R
        .byte   $72                             ; AB1F 72                       r
        .byte   $92                             ; AB20 92                       .
        rts                                     ; AB21 60                       `

; ----------------------------------------------------------------------------
        bmi     LAADC                           ; AB22 30 B8                    0.
        .byte   $80                             ; AB24 80                       .
        ldy     #$C0                            ; AB25 A0 C0                    ..
        iny                                     ; AB27 C8                       .
        jmp     (L6C68)                         ; AB28 6C 68 6C                 lhl

; ----------------------------------------------------------------------------
        iny                                     ; AB2B C8                       .
        ldy     $808C                           ; AB2C AC 8C 80                 ...
        clv                                     ; AB2F B8                       .
        clv                                     ; AB30 B8                       .
        tya                                     ; AB31 98                       .
        tya                                     ; AB32 98                       .
        sei                                     ; AB33 78                       x
        cli                                     ; AB34 58                       X
        sei                                     ; AB35 78                       x
        cli                                     ; AB36 58                       X
        ldy     L0000                           ; AB37 A4 00                    ..
        .byte   $FF                             ; AB39 FF                       .
LAB3A:  brk                                     ; AB3A 00                       .
        rti                                     ; AB3B 40                       @

; ----------------------------------------------------------------------------
LAB3C:  .byte   $20                             ; AB3C 20                        
        brk                                     ; AB3D 00                       .
LAB3E:  brk                                     ; AB3E 00                       .
        .byte   $80                             ; AB3F 80                       .
        php                                     ; AB40 08                       .
        .byte   $0F                             ; AB41 0F                       .
        jsr     L2010                           ; AB42 20 10 20                  . 
        .byte   $80                             ; AB45 80                       .
        php                                     ; AB46 08                       .
LAB47:  brk                                     ; AB47 00                       .
        brk                                     ; AB48 00                       .
LAB49:  .byte   $23                             ; AB49 23                       #
        php                                     ; AB4A 08                       .
        plp                                     ; AB4B 28                       (
        brk                                     ; AB4C 00                       .
        .byte   $80                             ; AB4D 80                       .
        php                                     ; AB4E 08                       .
        .byte   $82                             ; AB4F 82                       .
        rol     a                               ; AB50 2A                       *
        rti                                     ; AB51 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AB52 00                       .
        brk                                     ; AB53 00                       .
        brk                                     ; AB54 00                       .
        brk                                     ; AB55 00                       .
        .byte   $02                             ; AB56 02                       .
        jsr     L00A2                           ; AB57 20 A2 00                  ..
        php                                     ; AB5A 08                       .
        .byte   $54                             ; AB5B 54                       T
        tay                                     ; AB5C A8                       .
        bne     LAB5F                           ; AB5D D0 00                    ..
LAB5F:  ldy     #$02                            ; AB5F A0 02                    ..
        brk                                     ; AB61 00                       .
        brk                                     ; AB62 00                       .
        asl     L0000                           ; AB63 06 00                    ..
        .byte   $04                             ; AB65 04                       .
        jsr     L0020                           ; AB66 20 20 00                   .
LAB69:  .byte   $02                             ; AB69 02                       .
        .byte   $02                             ; AB6A 02                       .
        .byte   $80                             ; AB6B 80                       .
        brk                                     ; AB6C 00                       .
        brk                                     ; AB6D 00                       .
        .byte   $80                             ; AB6E 80                       .
        clc                                     ; AB6F 18                       .
        .byte   $80                             ; AB70 80                       .
        brk                                     ; AB71 00                       .
        jsr     L00A0                           ; AB72 20 A0 00                  ..
        .byte   $02                             ; AB75 02                       .
LAB76:  plp                                     ; AB76 28                       (
        eor     (L0020,x)                       ; AB77 41 20                    A 
        bvc     LAAFB                           ; AB79 50 80                    P.
        bvc     LABA5                           ; AB7B 50 28                    P(
        eor     ($08,x)                         ; AB7D 41 08                    A.
        asl     a                               ; AB7F 0A                       .
        brk                                     ; AB80 00                       .
        brk                                     ; AB81 00                       .
        brk                                     ; AB82 00                       .
        brk                                     ; AB83 00                       .
        rts                                     ; AB84 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; AB85 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; AB86 00                       .
        brk                                     ; AB87 00                       .
        asl     a                               ; AB88 0A                       .
        asl     a                               ; AB89 0A                       .
        asl     a                               ; AB8A 0A                       .
        asl     a                               ; AB8B 0A                       .
        asl     a                               ; AB8C 0A                       .
        asl     a                               ; AB8D 0A                       .
        asl     a                               ; AB8E 0A                       .
        .byte   $80                             ; AB8F 80                       .
        clc                                     ; AB90 18                       .
        asl     a                               ; AB91 0A                       .
        clc                                     ; AB92 18                       .
        asl     a                               ; AB93 0A                       .
        clc                                     ; AB94 18                       .
LAB95:  asl     a                               ; AB95 0A                       .
        clc                                     ; AB96 18                       .
        ora     $27,x                           ; AB97 15 27                    .'
        rts                                     ; AB99 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; AB9A 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; AB9B 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; AB9C 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; AB9D 60                       `

; ----------------------------------------------------------------------------
        asl     $06                             ; AB9E 06 06                    ..
        asl     L0002                           ; ABA0 06 02                    ..
        .byte   $02                             ; ABA2 02                       .
        sta     (L0002,x)                       ; ABA3 81 02                    ..
LABA5:  .byte   $02                             ; ABA5 02                       .
        .byte   $02                             ; ABA6 02                       .
        ora     $05,x                           ; ABA7 15 05                    ..
        .byte   $82                             ; ABA9 82                       .
LABAA:  ora     $15                             ; ABAA 05 15                    ..
        .byte   $05                             ; ABAC 05                       .
LABAD:  ora     $8F                             ; ABAD 05 8F                    ..
        .byte   $32                             ; ABAF 32                       2
        .byte   $32                             ; ABB0 32                       2
        .byte   $32                             ; ABB1 32                       2
        .byte   $32                             ; ABB2 32                       2
        .byte   $32                             ; ABB3 32                       2
        .byte   $32                             ; ABB4 32                       2
        .byte   $32                             ; ABB5 32                       2
        .byte   $32                             ; ABB6 32                       2
        .byte   $0C                             ; ABB7 0C                       .
        ror     $FF                             ; ABB8 66 FF                    f.
        brk                                     ; ABBA 00                       .
        brk                                     ; ABBB 00                       .
        .byte   $02                             ; ABBC 02                       .
        php                                     ; ABBD 08                       .
        .byte   $80                             ; ABBE 80                       .
        bpl     LABC1                           ; ABBF 10 00                    ..
LABC1:  brk                                     ; ABC1 00                       .
        dey                                     ; ABC2 88                       .
        brk                                     ; ABC3 00                       .
        brk                                     ; ABC4 00                       .
        brk                                     ; ABC5 00                       .
        .byte   $02                             ; ABC6 02                       .
        bpl     LAB49                           ; ABC7 10 80                    ..
        brk                                     ; ABC9 00                       .
        jsr     L0000                           ; ABCA 20 00 00                  ..
        .byte   $14                             ; ABCD 14                       .
        brk                                     ; ABCE 00                       .
        cpx     #$00                            ; ABCF E0 00                    ..
        php                                     ; ABD1 08                       .
        brk                                     ; ABD2 00                       .
        brk                                     ; ABD3 00                       .
        brk                                     ; ABD4 00                       .
        brk                                     ; ABD5 00                       .
        brk                                     ; ABD6 00                       .
        brk                                     ; ABD7 00                       .
        plp                                     ; ABD8 28                       (
        brk                                     ; ABD9 00                       .
        brk                                     ; ABDA 00                       .
        bit     L0002                           ; ABDB 24 02                    $.
        rti                                     ; ABDD 40                       @

; ----------------------------------------------------------------------------
        .byte   $02                             ; ABDE 02                       .
        sty     L0000                           ; ABDF 84 00                    ..
        rti                                     ; ABE1 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ABE2 00                       .
        brk                                     ; ABE3 00                       .
        brk                                     ; ABE4 00                       .
        bpl     LAC07                           ; ABE5 10 20                    . 
        rti                                     ; ABE7 40                       @

; ----------------------------------------------------------------------------
        jsr     L000C                           ; ABE8 20 0C 00                  ..
        brk                                     ; ABEB 00                       .
        brk                                     ; ABEC 00                       .
        brk                                     ; ABED 00                       .
        .byte   $80                             ; ABEE 80                       .
        ora     (L0020,x)                       ; ABEF 01 20                    . 
        bcc     LABF5                           ; ABF1 90 02                    ..
        bvc     LAB95                           ; ABF3 50 A0                    P.
LABF5:  brk                                     ; ABF5 00                       .
        brk                                     ; ABF6 00                       .
        ora     ($28,x)                         ; ABF7 01 28                    .(
        brk                                     ; ABF9 00                       .
        brk                                     ; ABFA 00                       .
        .byte   $07                             ; ABFB 07                       .
        .byte   $02                             ; ABFC 02                       .
        rti                                     ; ABFD 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ABFE 00                       .
        brk                                     ; ABFF 00                       .
        brk                                     ; AC00 00                       .
        brk                                     ; AC01 00                       .
        .byte   $02                             ; AC02 02                       .
        .byte   $04                             ; AC03 04                       .
        asl     $07                             ; AC04 06 07                    ..
        .byte   $0B                             ; AC06 0B                       .
LAC07:  .byte   $0F                             ; AC07 0F                       .
        bpl     LAC1B                           ; AC08 10 11                    ..
        .byte   $14                             ; AC0A 14                       .
        .byte   $17                             ; AC0B 17                       .
        ora     $1F1C,y                         ; AC0C 19 1C 1F                 ...
        and     ($24,x)                         ; AC0F 21 24                    !$
        .byte   $27                             ; AC11 27                       '
        .byte   $27                             ; AC12 27                       '
        .byte   $2B                             ; AC13 2B                       +
        rol     $2E2E                           ; AC14 2E 2E 2E                 ...
        .byte   $2F                             ; AC17 2F                       /
        and     ($35),y                         ; AC18 31 35                    15
        .byte   $37                             ; AC1A 37                       7
LAC1B:  sec                                     ; AC1B 38                       8
        sec                                     ; AC1C 38                       8
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
        brk                                     ; AC28 00                       .
        brk                                     ; AC29 00                       .
        brk                                     ; AC2A 00                       .
        .byte   $04                             ; AC2B 04                       .
        .byte   $80                             ; AC2C 80                       .
        brk                                     ; AC2D 00                       .
        brk                                     ; AC2E 00                       .
        bpl     LAC31                           ; AC2F 10 00                    ..
LAC31:  brk                                     ; AC31 00                       .
        brk                                     ; AC32 00                       .
        brk                                     ; AC33 00                       .
        brk                                     ; AC34 00                       .
        brk                                     ; AC35 00                       .
        brk                                     ; AC36 00                       .
        brk                                     ; AC37 00                       .
        brk                                     ; AC38 00                       .
        brk                                     ; AC39 00                       .
        brk                                     ; AC3A 00                       .
        bpl     LAC3D                           ; AC3B 10 00                    ..
LAC3D:  brk                                     ; AC3D 00                       .
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
        rti                                     ; AC56 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AC57 00                       .
        bpl     LAC5A                           ; AC58 10 00                    ..
LAC5A:  brk                                     ; AC5A 00                       .
        brk                                     ; AC5B 00                       .
        brk                                     ; AC5C 00                       .
        brk                                     ; AC5D 00                       .
        brk                                     ; AC5E 00                       .
        brk                                     ; AC5F 00                       .
        brk                                     ; AC60 00                       .
        rti                                     ; AC61 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AC62 00                       .
        brk                                     ; AC63 00                       .
        php                                     ; AC64 08                       .
        brk                                     ; AC65 00                       .
        brk                                     ; AC66 00                       .
        brk                                     ; AC67 00                       .
        brk                                     ; AC68 00                       .
        brk                                     ; AC69 00                       .
        brk                                     ; AC6A 00                       .
        jsr     L0000                           ; AC6B 20 00 00                  ..
        brk                                     ; AC6E 00                       .
        brk                                     ; AC6F 00                       .
        brk                                     ; AC70 00                       .
        brk                                     ; AC71 00                       .
        brk                                     ; AC72 00                       .
        brk                                     ; AC73 00                       .
        brk                                     ; AC74 00                       .
        bpl     LAC97                           ; AC75 10 20                    . 
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
        bpl     LAC86                           ; AC84 10 00                    ..
LAC86:  brk                                     ; AC86 00                       .
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
LAC97:  brk                                     ; AC97 00                       .
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
LACA4:  brk                                     ; ACA4 00                       .
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
        bpl     LACB2                           ; ACB0 10 00                    ..
LACB2:  brk                                     ; ACB2 00                       .
        brk                                     ; ACB3 00                       .
        brk                                     ; ACB4 00                       .
        bpl     LACB7                           ; ACB5 10 00                    ..
LACB7:  brk                                     ; ACB7 00                       .
        brk                                     ; ACB8 00                       .
        ora     L0000                           ; ACB9 05 00                    ..
        brk                                     ; ACBB 00                       .
        jsr     L0002                           ; ACBC 20 02 00                  ..
        brk                                     ; ACBF 00                       .
        brk                                     ; ACC0 00                       .
        brk                                     ; ACC1 00                       .
        brk                                     ; ACC2 00                       .
        brk                                     ; ACC3 00                       .
        brk                                     ; ACC4 00                       .
        .byte   $04                             ; ACC5 04                       .
        brk                                     ; ACC6 00                       .
        brk                                     ; ACC7 00                       .
        brk                                     ; ACC8 00                       .
        brk                                     ; ACC9 00                       .
        brk                                     ; ACCA 00                       .
        brk                                     ; ACCB 00                       .
        .byte   $80                             ; ACCC 80                       .
        brk                                     ; ACCD 00                       .
        .byte   $04                             ; ACCE 04                       .
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
        jsr     L0040                           ; ACE1 20 40 00                  @.
        lsr     a                               ; ACE4 4A                       J
        brk                                     ; ACE5 00                       .
        .byte   $04                             ; ACE6 04                       .
        brk                                     ; ACE7 00                       .
        brk                                     ; ACE8 00                       .
        brk                                     ; ACE9 00                       .
        brk                                     ; ACEA 00                       .
        brk                                     ; ACEB 00                       .
        brk                                     ; ACEC 00                       .
        ora     (L0040,x)                       ; ACED 01 40                    .@
        brk                                     ; ACEF 00                       .
        brk                                     ; ACF0 00                       .
        brk                                     ; ACF1 00                       .
        brk                                     ; ACF2 00                       .
        brk                                     ; ACF3 00                       .
        brk                                     ; ACF4 00                       .
        brk                                     ; ACF5 00                       .
        brk                                     ; ACF6 00                       .
        brk                                     ; ACF7 00                       .
LACF8:  brk                                     ; ACF8 00                       .
        brk                                     ; ACF9 00                       .
        brk                                     ; ACFA 00                       .
        brk                                     ; ACFB 00                       .
        brk                                     ; ACFC 00                       .
        bpl     LACFF                           ; ACFD 10 00                    ..
LACFF:  brk                                     ; ACFF 00                       .
        brk                                     ; AD00 00                       .
        .byte   $FF                             ; AD01 FF                       .
        jsr     L0C21                           ; AD02 20 21 0C                  !.
        rts                                     ; AD05 60                       `

; ----------------------------------------------------------------------------
        .byte   $0C                             ; AD06 0C                       .
        rol     $6AFE                           ; AD07 2E FE 6A                 ..j
        jmp     (L6C6A)                         ; AD0A 6C 6A 6C                 ljl

; ----------------------------------------------------------------------------
        rts                                     ; AD0D 60                       `

; ----------------------------------------------------------------------------
        asl     $210E,x                         ; AD0E 1E 0E 21                 ..!
        bvc     LAD63                           ; AD11 50 50                    PP
        ror     a                               ; AD13 6A                       j
        jmp     (L5050)                         ; AD14 6C 50 50                 lPP

; ----------------------------------------------------------------------------
        asl     $2C4A                           ; AD17 0E 4A 2C                 .J,
        .byte   $3A                             ; AD1A 3A                       :
        .byte   $3C                             ; AD1B 3C                       <
        lsr     a                               ; AD1C 4A                       J
        jmp     L5C5A                           ; AD1D 4C 5A 5C                 LZ\

; ----------------------------------------------------------------------------
        .byte   $02                             ; AD20 02                       .
        .byte   $04                             ; AD21 04                       .
        asl     $08                             ; AD22 06 08                    ..
        rol     a                               ; AD24 2A                       *
        bit     $3C3A                           ; AD25 2C 3A 3C                 ,:<
        .byte   $22                             ; AD28 22                       "
        bit     $26                             ; AD29 24 26                    $&
        plp                                     ; AD2B 28                       (
        .byte   $32                             ; AD2C 32                       2
        .byte   $34                             ; AD2D 34                       4
        rol     $38,x                           ; AD2E 36 38                    68
        .byte   $42                             ; AD30 42                       B
        .byte   $44                             ; AD31 44                       D
        lsr     $48                             ; AD32 46 48                    FH
        brk                                     ; AD34 00                       .
        brk                                     ; AD35 00                       .
        brk                                     ; AD36 00                       .
        brk                                     ; AD37 00                       .
        .byte   $62                             ; AD38 62                       b
        .byte   $64                             ; AD39 64                       d
        ror     $68                             ; AD3A 66 68                    fh
        .byte   $52                             ; AD3C 52                       R
        .byte   $54                             ; AD3D 54                       T
        lsr     $58,x                           ; AD3E 56 58                    VX
        brk                                     ; AD40 00                       .
        brk                                     ; AD41 00                       .
        brk                                     ; AD42 00                       .
        brk                                     ; AD43 00                       .
        bcs     LACF8                           ; AD44 B0 B2                    ..
        ora     ($FF),y                         ; AD46 11 FF                    ..
        tya                                     ; AD48 98                       .
        txs                                     ; AD49 9A                       .
        .byte   $9C                             ; AD4A 9C                       .
        .byte   $9E                             ; AD4B 9E                       .
        cpy     $C6                             ; AD4C C4 C6                    ..
        tay                                     ; AD4E A8                       .
        tax                                     ; AD4F AA                       .
        .byte   $80                             ; AD50 80                       .
        .byte   $82                             ; AD51 82                       .
        lsr     $F06E                           ; AD52 4E 6E F0                 Nn.
        .byte   $F2                             ; AD55 F2                       .
        ora     (L0011),y                       ; AD56 11 11                    ..
        ldy     #$A2                            ; AD58 A0 A2                    ..
        sta     $F48F                           ; AD5A 8D 8F F4                 ...
        .byte   $F6                             ; AD5D F6                       .
LAD5E:  ldy     L0000,x                         ; AD5E B4 00                    ..
        cpy     #$C2                            ; AD60 C0 C2                    ..
        .byte   $D4                             ; AD62 D4                       .
LAD63:  bpl     LAD76                           ; AD63 10 11                    ..
        .byte   $CF                             ; AD65 CF                       .
        brk                                     ; AD66 00                       .
        cmp     #$E0                            ; AD67 C9 E0                    ..
        .byte   $E2                             ; AD69 E2                       .
        beq     LAD5E                           ; AD6A F0 F2                    ..
        ldy     a:$BE,x                         ; AD6C BC BE 00                 ...
        sbc     $E9A8                           ; AD6F ED A8 E9                 ...
        ora     ($FB),y                         ; AD72 11 FB                    ..
        ora     ($CB),y                         ; AD74 11 CB                    ..
LAD76:  .byte   $FF                             ; AD76 FF                       .
        .byte   $FF                             ; AD77 FF                       .
        ora     ($DB),y                         ; AD78 11 DB                    ..
        ora     ($FB),y                         ; AD7A 11 FB                    ..
        .byte   $FF                             ; AD7C FF                       .
        jsr     L2121                           ; AD7D 20 21 21                  !!
        sty     $85                             ; AD80 84 85                    ..
        dec     $01DF,x                         ; AD82 DE DF 01                 ...
        ora     ($01,x)                         ; AD85 01 01                    ..
        ora     ($94,x)                         ; AD87 01 94                    ..
        .byte   $87                             ; AD89 87                       .
        dec     $CCDF,x                         ; AD8A DE DF CC                 ...
LAD8D:  ora     ($FF,x)                         ; AD8D 01 FF                    ..
        sed                                     ; AD8F F8                       .
        .byte   $FF                             ; AD90 FF                       .
        .byte   $80                             ; AD91 80                       .
        .byte   $82                             ; AD92 82                       .
        .byte   $82                             ; AD93 82                       .
        .byte   $FF                             ; AD94 FF                       .
        sbc     $CCFF,y                         ; AD95 F9 FF CC                 ...
        ldy     L00A0                           ; AD98 A4 A0                    ..
        .byte   $84                             ; AD9A 84                       .
LAD9B:  ldx     #$02                            ; AD9B A2 02                    ..
        .byte   $04                             ; AD9D 04                       .
        asl     $08                             ; AD9E 06 08                    ..
        cpy     $C0                             ; ADA0 C4 C0                    ..
        cmp     ($B2,x)                         ; ADA2 C1 B2                    ..
        cpx     #$E2                            ; ADA4 E0 E2                    ..
        .byte   $E2                             ; ADA6 E2                       .
        bvc     LAD8D                           ; ADA7 50 E4                    P.
        cpy     #$C1                            ; ADA9 C0 C1                    ..
        .byte   $B2                             ; ADAB B2                       .
        cpx     #$E2                            ; ADAC E0 E2                    ..
        .byte   $E2                             ; ADAE E2                       .
        .byte   $DB                             ; ADAF DB                       .
        stx     $88                             ; ADB0 86 88                    ..
        ror     a                               ; ADB2 6A                       j
        .byte   $8B                             ; ADB3 8B                       .
        ror     a                               ; ADB4 6A                       j
        jmp     (L8B6A)                         ; ADB5 6C 6A 8B                 lj.

; ----------------------------------------------------------------------------
        ldx     $A8                             ; ADB8 A6 A8                    ..
        jmp     (L6AAB)                         ; ADBA 6C AB 6A                 l.j

; ----------------------------------------------------------------------------
        .byte   $8B                             ; ADBD 8B                       .
        bvc     LAD9B                           ; ADBE 50 DB                    P.
        ldy     $FCBE,x                         ; ADC0 BC BE FC                 ...
        inc     $EA,x                           ; ADC3 F6 EA                    ..
        .byte   $FF                             ; ADC5 FF                       .
        .byte   $FF                             ; ADC6 FF                       .
        .byte   $FF                             ; ADC7 FF                       .
        .byte   $DC                             ; ADC8 DC                       .
        dec     $FFFF,x                         ; ADC9 DE FF FF                 ...
        .byte   $FF                             ; ADCC FF                       .
        .byte   $FF                             ; ADCD FF                       .
        .byte   $FF                             ; ADCE FF                       .
        .byte   $FF                             ; ADCF FF                       .
        .byte   $FF                             ; ADD0 FF                       .
        .byte   $FF                             ; ADD1 FF                       .
        .byte   $FF                             ; ADD2 FF                       .
        .byte   $FF                             ; ADD3 FF                       .
        .byte   $FF                             ; ADD4 FF                       .
        .byte   $FF                             ; ADD5 FF                       .
        .byte   $FF                             ; ADD6 FF                       .
        .byte   $FF                             ; ADD7 FF                       .
        .byte   $FF                             ; ADD8 FF                       .
        .byte   $FF                             ; ADD9 FF                       .
        .byte   $FF                             ; ADDA FF                       .
        .byte   $FF                             ; ADDB FF                       .
        .byte   $FF                             ; ADDC FF                       .
        .byte   $FF                             ; ADDD FF                       .
        .byte   $FF                             ; ADDE FF                       .
        .byte   $FF                             ; ADDF FF                       .
        .byte   $FF                             ; ADE0 FF                       .
        .byte   $FF                             ; ADE1 FF                       .
        .byte   $FF                             ; ADE2 FF                       .
        .byte   $FF                             ; ADE3 FF                       .
        .byte   $FF                             ; ADE4 FF                       .
        .byte   $FF                             ; ADE5 FF                       .
        .byte   $FF                             ; ADE6 FF                       .
        .byte   $FF                             ; ADE7 FF                       .
        .byte   $FF                             ; ADE8 FF                       .
        .byte   $FF                             ; ADE9 FF                       .
        .byte   $FF                             ; ADEA FF                       .
        .byte   $FF                             ; ADEB FF                       .
        .byte   $FF                             ; ADEC FF                       .
        .byte   $FF                             ; ADED FF                       .
        .byte   $FF                             ; ADEE FF                       .
        .byte   $FF                             ; ADEF FF                       .
        .byte   $FF                             ; ADF0 FF                       .
        .byte   $FF                             ; ADF1 FF                       .
        .byte   $FF                             ; ADF2 FF                       .
        .byte   $FF                             ; ADF3 FF                       .
        .byte   $FF                             ; ADF4 FF                       .
        .byte   $FF                             ; ADF5 FF                       .
        .byte   $FF                             ; ADF6 FF                       .
        .byte   $FF                             ; ADF7 FF                       .
        .byte   $FF                             ; ADF8 FF                       .
        .byte   $FF                             ; ADF9 FF                       .
        .byte   $FF                             ; ADFA FF                       .
        .byte   $FF                             ; ADFB FF                       .
        .byte   $FF                             ; ADFC FF                       .
        .byte   $FF                             ; ADFD FF                       .
        .byte   $FF                             ; ADFE FF                       .
        .byte   $FF                             ; ADFF FF                       .
        brk                                     ; AE00 00                       .
        .byte   $FF                             ; AE01 FF                       .
        and     ($21,x)                         ; AE02 21 21                    !!
        ora     $0D61                           ; AE04 0D 61 0D                 .a.
        rol     $6BFE,x                         ; AE07 3E FE 6B                 >.k
        adc     $6D6B                           ; AE0A 6D 6B 6D                 mkm
        adc     ($1F,x)                         ; AE0D 61 1F                    a.
        .byte   $0F                             ; AE0F 0F                       .
        .byte   $2F                             ; AE10 2F                       /
        eor     ($51),y                         ; AE11 51 51                    QQ
        .byte   $6B                             ; AE13 6B                       k
        adc     $5151                           ; AE14 6D 51 51                 mQQ
        .byte   $0F                             ; AE17 0F                       .
        .byte   $2B                             ; AE18 2B                       +
        and     $5D3B                           ; AE19 2D 3B 5D                 -;]
        .byte   $4B                             ; AE1C 4B                       K
        eor     $5D5B                           ; AE1D 4D 5B 5D                 M[]
        .byte   $03                             ; AE20 03                       .
        ora     $07                             ; AE21 05 07                    ..
        ora     #$2B                            ; AE23 09 2B                    .+
        and     $3D3B                           ; AE25 2D 3B 3D                 -;=
        .byte   $23                             ; AE28 23                       #
        and     $27                             ; AE29 25 27                    %'
        and     #$33                            ; AE2B 29 33                    )3
        and     $37,x                           ; AE2D 35 37                    57
        and     $4543,y                         ; AE2F 39 43 45                 9CE
        .byte   $47                             ; AE32 47                       G
        eor     #$00                            ; AE33 49 00                    I.
        brk                                     ; AE35 00                       .
        brk                                     ; AE36 00                       .
        brk                                     ; AE37 00                       .
        .byte   $63                             ; AE38 63                       c
        adc     $67                             ; AE39 65 67                    eg
        adc     #$53                            ; AE3B 69 53                    iS
        eor     $57,x                           ; AE3D 55 57                    UW
        eor     L0000,y                         ; AE3F 59 00 00                 Y..
        brk                                     ; AE42 00                       .
        brk                                     ; AE43 00                       .
        lda     ($B3),y                         ; AE44 B1 B3                    ..
        ora     ($FF),y                         ; AE46 11 FF                    ..
        sta     $9D9B,y                         ; AE48 99 9B 9D                 ...
        .byte   $9F                             ; AE4B 9F                       .
        cmp     $C7                             ; AE4C C5 C7                    ..
        lda     #$AB                            ; AE4E A9 AB                    ..
        sta     ($83,x)                         ; AE50 81 83                    ..
        .byte   $4F                             ; AE52 4F                       O
        .byte   $6F                             ; AE53 6F                       o
        sbc     ($F3),y                         ; AE54 F1 F3                    ..
        ora     (L0011),y                       ; AE56 11 11                    ..
        lda     ($A3,x)                         ; AE58 A1 A3                    ..
        brk                                     ; AE5A 00                       .
        brk                                     ; AE5B 00                       .
        sbc     $F7,x                           ; AE5C F5 F7                    ..
        lda     $B7,x                           ; AE5E B5 B7                    ..
        cmp     ($C3,x)                         ; AE60 C1 C3                    ..
        cmp     $D7,x                           ; AE62 D5 D7                    ..
        dec     $C811                           ; AE64 CE 11 C8                 ...
        brk                                     ; AE67 00                       .
        sbc     ($E3,x)                         ; AE68 E1 E3                    ..
        sbc     ($F3),y                         ; AE6A F1 F3                    ..
        lda     $ECBF,x                         ; AE6C BD BF EC                 ...
        brk                                     ; AE6F 00                       .
        inx                                     ; AE70 E8                       .
        .byte   $AB                             ; AE71 AB                       .
        .byte   $FA                             ; AE72 FA                       .
        ora     ($CA),y                         ; AE73 11 CA                    ..
        ora     ($FF),y                         ; AE75 11 FF                    ..
        .byte   $FF                             ; AE77 FF                       .
        .byte   $DA                             ; AE78 DA                       .
        ora     ($FA),y                         ; AE79 11 FA                    ..
        ora     ($FF),y                         ; AE7B 11 FF                    ..
        and     ($21,x)                         ; AE7D 21 21                    !!
        .byte   $2F                             ; AE7F 2F                       /
        sta     $0B                             ; AE80 85 0B                    ..
        .byte   $DF                             ; AE82 DF                       .
        ldx     $01,y                           ; AE83 B6 01                    ..
        ora     ($01,x)                         ; AE85 01 01                    ..
        ora     ($87,x)                         ; AE87 01 87                    ..
        .byte   $1B                             ; AE89 1B                       .
        .byte   $DF                             ; AE8A DF                       .
        ldx     $CD,y                           ; AE8B B6 CD                    ..
        sbc     $01FF,y                         ; AE8D F9 FF 01                 ...
        .byte   $FF                             ; AE90 FF                       .
        sta     ($81,x)                         ; AE91 81 81                    ..
        .byte   $83                             ; AE93 83                       .
        .byte   $FF                             ; AE94 FF                       .
        cmp     $F8FF                           ; AE95 CD FF F8                 ...
        lda     $A1                             ; AE98 A5 A1                    ..
        sta     $A3                             ; AE9A 85 A3                    ..
        .byte   $03                             ; AE9C 03                       .
        ora     $07                             ; AE9D 05 07                    ..
        ora     #$C5                            ; AE9F 09 C5                    ..
        lda     ($C2),y                         ; AEA1 B1 C2                    ..
        .byte   $C3                             ; AEA3 C3                       .
        sbc     ($E1,x)                         ; AEA4 E1 E1                    ..
        .byte   $E3                             ; AEA6 E3                       .
        .byte   $DA                             ; AEA7 DA                       .
        sbc     $B1                             ; AEA8 E5 B1                    ..
        .byte   $C2                             ; AEAA C2                       .
        .byte   $C3                             ; AEAB C3                       .
        sbc     ($E1,x)                         ; AEAC E1 E1                    ..
        .byte   $E3                             ; AEAE E3                       .
        eor     ($87),y                         ; AEAF 51 87                    Q.
        .byte   $89                             ; AEB1 89                       .
        txa                                     ; AEB2 8A                       .
        adc     $6D6B                           ; AEB3 6D 6B 6D                 mkm
        txa                                     ; AEB6 8A                       .
        adc     LA9A7                           ; AEB7 6D A7 A9                 m..
        tax                                     ; AEBA AA                       .
        .byte   $6B                             ; AEBB 6B                       k
        txa                                     ; AEBC 8A                       .
        adc     $51DA                           ; AEBD 6D DA 51                 m.Q
        lda     a:$BF,x                         ; AEC0 BD BF 00                 ...
        .byte   $F7                             ; AEC3 F7                       .
        .byte   $EB                             ; AEC4 EB                       .
        .byte   $FF                             ; AEC5 FF                       .
        .byte   $FF                             ; AEC6 FF                       .
        .byte   $FF                             ; AEC7 FF                       .
        brk                                     ; AEC8 00                       .
        .byte   $DF                             ; AEC9 DF                       .
        .byte   $FF                             ; AECA FF                       .
        .byte   $FF                             ; AECB FF                       .
        .byte   $FF                             ; AECC FF                       .
        .byte   $FF                             ; AECD FF                       .
        .byte   $FF                             ; AECE FF                       .
        .byte   $FF                             ; AECF FF                       .
        .byte   $FF                             ; AED0 FF                       .
        .byte   $FF                             ; AED1 FF                       .
        .byte   $FF                             ; AED2 FF                       .
        .byte   $FF                             ; AED3 FF                       .
        .byte   $FF                             ; AED4 FF                       .
        .byte   $FF                             ; AED5 FF                       .
        .byte   $FF                             ; AED6 FF                       .
        .byte   $FF                             ; AED7 FF                       .
        .byte   $FF                             ; AED8 FF                       .
        .byte   $FF                             ; AED9 FF                       .
        .byte   $FF                             ; AEDA FF                       .
        .byte   $FF                             ; AEDB FF                       .
        .byte   $FF                             ; AEDC FF                       .
        .byte   $FF                             ; AEDD FF                       .
        .byte   $FF                             ; AEDE FF                       .
        .byte   $FF                             ; AEDF FF                       .
        .byte   $FF                             ; AEE0 FF                       .
        .byte   $FF                             ; AEE1 FF                       .
        .byte   $FF                             ; AEE2 FF                       .
        .byte   $FF                             ; AEE3 FF                       .
        .byte   $FF                             ; AEE4 FF                       .
        .byte   $FF                             ; AEE5 FF                       .
        .byte   $FF                             ; AEE6 FF                       .
        .byte   $FF                             ; AEE7 FF                       .
        .byte   $FF                             ; AEE8 FF                       .
        .byte   $FF                             ; AEE9 FF                       .
        .byte   $FF                             ; AEEA FF                       .
        .byte   $FF                             ; AEEB FF                       .
        .byte   $FF                             ; AEEC FF                       .
        .byte   $FF                             ; AEED FF                       .
        .byte   $FF                             ; AEEE FF                       .
        .byte   $FF                             ; AEEF FF                       .
        .byte   $FF                             ; AEF0 FF                       .
        .byte   $FF                             ; AEF1 FF                       .
        .byte   $FF                             ; AEF2 FF                       .
        .byte   $FF                             ; AEF3 FF                       .
        .byte   $FF                             ; AEF4 FF                       .
        .byte   $FF                             ; AEF5 FF                       .
        .byte   $FF                             ; AEF6 FF                       .
        .byte   $FF                             ; AEF7 FF                       .
        .byte   $FF                             ; AEF8 FF                       .
        .byte   $FF                             ; AEF9 FF                       .
        .byte   $FF                             ; AEFA FF                       .
        .byte   $FF                             ; AEFB FF                       .
        .byte   $FF                             ; AEFC FF                       .
        .byte   $FF                             ; AEFD FF                       .
        .byte   $FF                             ; AEFE FF                       .
        .byte   $FF                             ; AEFF FF                       .
        brk                                     ; AF00 00                       .
        .byte   $FF                             ; AF01 FF                       .
        bmi     LAF35                           ; AF02 30 31                    01
        .byte   $1C                             ; AF04 1C                       .
        bvs     LAF23                           ; AF05 70 1C                    p.
        asl     $40FE                           ; AF07 0E FE 40                 ..@
        rti                                     ; AF0A 40                       @

; ----------------------------------------------------------------------------
        .byte   $7A                             ; AF0B 7A                       z
        .byte   $7C                             ; AF0C 7C                       |
        rts                                     ; AF0D 60                       `

; ----------------------------------------------------------------------------
        asl     $310E,x                         ; AF0E 1E 0E 31                 ..1
        .byte   $1A                             ; AF11 1A                       .
        .byte   $1A                             ; AF12 1A                       .
        .byte   $1A                             ; AF13 1A                       .
        .byte   $1A                             ; AF14 1A                       .
        .byte   $7A                             ; AF15 7A                       z
        .byte   $7C                             ; AF16 7C                       |
        asl     $2C2A                           ; AF17 0E 2A 2C                 .*,
        .byte   $5A                             ; AF1A 5A                       Z
        .byte   $5C                             ; AF1B 5C                       \
        lsr     a                               ; AF1C 4A                       J
        jmp     L5C5A                           ; AF1D 4C 5A 5C                 LZ\

; ----------------------------------------------------------------------------
        .byte   $12                             ; AF20 12                       .
        .byte   $14                             ; AF21 14                       .
        .byte   $16                             ; AF22 16                       .
LAF23:  clc                                     ; AF23 18                       .
        .byte   $22                             ; AF24 22                       "
LAF25:  bit     $26                             ; AF25 24 26                    $&
        plp                                     ; AF27 28                       (
        .byte   $32                             ; AF28 32                       2
        .byte   $34                             ; AF29 34                       4
        rol     $38,x                           ; AF2A 36 38                    68
        brk                                     ; AF2C 00                       .
        brk                                     ; AF2D 00                       .
        brk                                     ; AF2E 00                       .
        brk                                     ; AF2F 00                       .
        .byte   $52                             ; AF30 52                       R
        .byte   $54                             ; AF31 54                       T
        lsr     $58,x                           ; AF32 56 58                    VX
LAF34:  .byte   $42                             ; AF34 42                       B
LAF35:  .byte   $44                             ; AF35 44                       D
        lsr     $48                             ; AF36 46 48                    FH
LAF38:  .byte   $72                             ; AF38 72                       r
        .byte   $74                             ; AF39 74                       t
        ror     $78,x                           ; AF3A 76 78                    vx
        rol     a                               ; AF3C 2A                       *
        .byte   $2C                             ; AF3D 2C                       ,
        .byte   $3A                             ; AF3E 3A                       :
LAF3F:  .byte   $3C                             ; AF3F 3C                       <
        dey                                     ; AF40 88                       .
        txa                                     ; AF41 8A                       .
        sty     LB48E                           ; AF42 8C 8E B4                 ...
        brk                                     ; AF45 00                       .
        ora     ($FF),y                         ; AF46 11 FF                    ..
        .byte   $80                             ; AF48 80                       .
        .byte   $82                             ; AF49 82                       .
        ldy     $D4AE                           ; AF4A AC AE D4                 ...
        bpl     LAF60                           ; AF4D 10 11                    ..
        ora     ($90),y                         ; AF4F 11 90                    ..
        .byte   $92                             ; AF51 92                       .
        lsr     $E47E,x                         ; AF52 5E 7E E4                 ^~.
        inc     $A4                             ; AF55 E6 A4                    ..
        ldx     L0000                           ; AF57 A6 00                    ..
        brk                                     ; AF59 00                       .
        brk                                     ; AF5A 00                       .
        brk                                     ; AF5B 00                       .
LAF5C:  clv                                     ; AF5C B8                       .
        tsx                                     ; AF5D BA                       .
LAF5E:  ldy     L0000,x                         ; AF5E B4 00                    ..
LAF60:  bne     LAF34                           ; AF60 D0 D2                    ..
        .byte   $D4                             ; AF62 D4                       .
        .byte   $10                             ; AF63 10                       .
LAF64:  ora     ($CB),y                         ; AF64 11 CB                    ..
        brk                                     ; AF66 00                       .
        cmp     $F2F0,y                         ; AF67 D9 F0 F2                 ...
        beq     LAF5E                           ; AF6A F0 F2                    ..
        .byte   $80                             ; AF6C 80                       .
        .byte   $82                             ; AF6D 82                       .
        brk                                     ; AF6E 00                       .
        sbc     $CB11,x                         ; AF6F FD 11 CB                 ...
        ora     ($FB),y                         ; AF72 11 FB                    ..
        ora     ($CB),y                         ; AF74 11 CB                    ..
LAF76:  .byte   $FF                             ; AF76 FF                       .
        .byte   $FF                             ; AF77 FF                       .
        ora     ($EB),y                         ; AF78 11 EB                    ..
        ldy     $DD                             ; AF7A A4 DD                    ..
        .byte   $FF                             ; AF7C FF                       .
        bmi     LAFB0                           ; AF7D 30 31                    01
        and     ($94),y                         ; AF7F 31 94                    1.
        sta     $DE,x                           ; AF81 95 DE                    ..
        .byte   $DF                             ; AF83 DF                       .
        ora     ($F9,x)                         ; AF84 01 F9                    ..
        cpy     $96CC                           ; AF86 CC CC 96                 ...
        .byte   $97                             ; AF89 97                       .
        inc     $11EF                           ; AF8A EE EF 11                 ...
        sbc     $11FF,y                         ; AF8D F9 FF 11                 ...
        .byte   $FF                             ; AF90 FF                       .
        bcc     LAF25                           ; AF91 90 92                    ..
        .byte   $92                             ; AF93 92                       .
        .byte   $FF                             ; AF94 FF                       .
        ora     ($FF),y                         ; AF95 11 FF                    ..
        ora     ($B4),y                         ; AF97 11 B4                    ..
        bcs     LAF5C                           ; AF99 B0 C1                    ..
        .byte   $B2                             ; AF9B B2                       .
        .byte   $72                             ; AF9C 72                       r
        .byte   $74                             ; AF9D 74                       t
        ror     $78,x                           ; AF9E 76 78                    vx
LAFA0:  .byte   $D4                             ; AFA0 D4                       .
        bcs     LAF64                           ; AFA1 B0 C1                    ..
        .byte   $B2                             ; AFA3 B2                       .
        bcc     LAF38                           ; AFA4 90 92                    ..
        .byte   $92                             ; AFA6 92                       .
LAFA7:  .byte   $1A                             ; AFA7 1A                       .
        .byte   $F4                             ; AFA8 F4                       .
        bne     LAF3F                           ; AFA9 D0 94                    ..
        .byte   $D2                             ; AFAB D2                       .
        beq     LAFA0                           ; AFAC F0 F2                    ..
        .byte   $F2                             ; AFAE F2                       .
        cld                                     ; AFAF D8                       .
LAFB0:  stx     $98,y                           ; AFB0 96 98                    ..
        .byte   $7A                             ; AFB2 7A                       z
        .byte   $9B                             ; AFB3 9B                       .
        dec     $C8                             ; AFB4 C6 C8                    ..
        inc     $E8                             ; AFB6 E6 E8                    ..
        ldx     $B8,y                           ; AFB8 B6 B8                    ..
        .byte   $7C                             ; AFBA 7C                       |
        .byte   $BB                             ; AFBB BB                       .
        .byte   $1A                             ; AFBC 1A                       .
        cld                                     ; AFBD D8                       .
        .byte   $7C                             ; AFBE 7C                       |
        .byte   $9B                             ; AFBF 9B                       .
        cpy     a:$CE                           ; AFC0 CC CE 00                 ...
        sed                                     ; AFC3 F8                       .
        .byte   $FA                             ; AFC4 FA                       .
        .byte   $FF                             ; AFC5 FF                       .
        .byte   $FF                             ; AFC6 FF                       .
        .byte   $FF                             ; AFC7 FF                       .
        cpx     $FFEE                           ; AFC8 EC EE FF                 ...
        .byte   $FF                             ; AFCB FF                       .
        .byte   $FF                             ; AFCC FF                       .
        .byte   $FF                             ; AFCD FF                       .
        .byte   $FF                             ; AFCE FF                       .
        .byte   $FF                             ; AFCF FF                       .
        .byte   $FF                             ; AFD0 FF                       .
        .byte   $FF                             ; AFD1 FF                       .
        .byte   $FF                             ; AFD2 FF                       .
        .byte   $FF                             ; AFD3 FF                       .
        .byte   $FF                             ; AFD4 FF                       .
        .byte   $FF                             ; AFD5 FF                       .
        .byte   $FF                             ; AFD6 FF                       .
        .byte   $FF                             ; AFD7 FF                       .
        .byte   $FF                             ; AFD8 FF                       .
        .byte   $FF                             ; AFD9 FF                       .
        .byte   $FF                             ; AFDA FF                       .
        .byte   $FF                             ; AFDB FF                       .
        .byte   $FF                             ; AFDC FF                       .
        .byte   $FF                             ; AFDD FF                       .
        .byte   $FF                             ; AFDE FF                       .
        .byte   $FF                             ; AFDF FF                       .
        .byte   $FF                             ; AFE0 FF                       .
        .byte   $FF                             ; AFE1 FF                       .
        .byte   $FF                             ; AFE2 FF                       .
        .byte   $FF                             ; AFE3 FF                       .
        .byte   $FF                             ; AFE4 FF                       .
        .byte   $FF                             ; AFE5 FF                       .
        .byte   $FF                             ; AFE6 FF                       .
        .byte   $FF                             ; AFE7 FF                       .
        .byte   $FF                             ; AFE8 FF                       .
        .byte   $FF                             ; AFE9 FF                       .
        .byte   $FF                             ; AFEA FF                       .
        .byte   $FF                             ; AFEB FF                       .
        .byte   $FF                             ; AFEC FF                       .
        .byte   $FF                             ; AFED FF                       .
        .byte   $FF                             ; AFEE FF                       .
        .byte   $FF                             ; AFEF FF                       .
        .byte   $FF                             ; AFF0 FF                       .
        .byte   $FF                             ; AFF1 FF                       .
        .byte   $FF                             ; AFF2 FF                       .
        .byte   $FF                             ; AFF3 FF                       .
        .byte   $FF                             ; AFF4 FF                       .
        .byte   $FF                             ; AFF5 FF                       .
        .byte   $FF                             ; AFF6 FF                       .
        .byte   $FF                             ; AFF7 FF                       .
        .byte   $FF                             ; AFF8 FF                       .
        .byte   $FF                             ; AFF9 FF                       .
        .byte   $FF                             ; AFFA FF                       .
        .byte   $FF                             ; AFFB FF                       .
        .byte   $FF                             ; AFFC FF                       .
        .byte   $FF                             ; AFFD FF                       .
        .byte   $FF                             ; AFFE FF                       .
        .byte   $FF                             ; AFFF FF                       .
        brk                                     ; B000 00                       .
        .byte   $FF                             ; B001 FF                       .
        and     ($31),y                         ; B002 31 31                    11
        ora     $1D71,x                         ; B004 1D 71 1D                 .q.
        .byte   $0F                             ; B007 0F                       .
        inc     $4141,x                         ; B008 FE 41 41                 .AA
        .byte   $7B                             ; B00B 7B                       {
        adc     $1F61,x                         ; B00C 7D 61 1F                 }a.
        .byte   $0F                             ; B00F 0F                       .
        .byte   $3F                             ; B010 3F                       ?
        .byte   $1A                             ; B011 1A                       .
        .byte   $1A                             ; B012 1A                       .
        .byte   $1A                             ; B013 1A                       .
        .byte   $1A                             ; B014 1A                       .
        .byte   $7B                             ; B015 7B                       {
        adc     $4B0F,x                         ; B016 7D 0F 4B                 }.K
        and     $3D3B                           ; B019 2D 3B 3D                 -;=
        .byte   $4B                             ; B01C 4B                       K
        eor     $5D5B                           ; B01D 4D 5B 5D                 M[]
        .byte   $13                             ; B020 13                       .
        ora     $17,x                           ; B021 15 17                    ..
        ora     $2523,y                         ; B023 19 23 25                 .#%
        .byte   $27                             ; B026 27                       '
        and     #$33                            ; B027 29 33                    )3
        and     $37,x                           ; B029 35 37                    57
        and     L0000,y                         ; B02B 39 00 00                 9..
        brk                                     ; B02E 00                       .
        brk                                     ; B02F 00                       .
        .byte   $53                             ; B030 53                       S
        eor     $57,x                           ; B031 55 57                    UW
        eor     $4543,y                         ; B033 59 43 45                 YCE
        .byte   $47                             ; B036 47                       G
        eor     #$73                            ; B037 49 73                    Is
        adc     $77,x                           ; B039 75 77                    uw
        adc     $2D2B,y                         ; B03B 79 2B 2D                 y+-
        .byte   $3B                             ; B03E 3B                       ;
        and     $8B89,x                         ; B03F 3D 89 8B                 =..
        brk                                     ; B042 00                       .
        brk                                     ; B043 00                       .
        lda     $B7,x                           ; B044 B5 B7                    ..
        ora     ($FF),y                         ; B046 11 FF                    ..
        sta     ($83,x)                         ; B048 81 83                    ..
        lda     $D5AF                           ; B04A AD AF D5                 ...
        .byte   $D7                             ; B04D D7                       .
        ora     (L0011),y                       ; B04E 11 11                    ..
        sta     ($93),y                         ; B050 91 93                    ..
        .byte   $5F                             ; B052 5F                       _
        .byte   $7F                             ; B053 7F                       .
        sbc     $E7                             ; B054 E5 E7                    ..
        lda     $A7                             ; B056 A5 A7                    ..
        brk                                     ; B058 00                       .
        brk                                     ; B059 00                       .
        brk                                     ; B05A 00                       .
        brk                                     ; B05B 00                       .
        lda     LB5BB,y                         ; B05C B9 BB B5                 ...
        .byte   $B7                             ; B05F B7                       .
        cmp     ($D3),y                         ; B060 D1 D3                    ..
        cmp     $D7,x                           ; B062 D5 D7                    ..
        dex                                     ; B064 CA                       .
        ora     ($D8),y                         ; B065 11 D8                    ..
        brk                                     ; B067 00                       .
        sbc     ($F3),y                         ; B068 F1 F3                    ..
        sbc     ($F3),y                         ; B06A F1 F3                    ..
        sta     ($83,x)                         ; B06C 81 83                    ..
        .byte   $FC                             ; B06E FC                       .
        brk                                     ; B06F 00                       .
LB070:  dex                                     ; B070 CA                       .
        ora     ($FA),y                         ; B071 11 FA                    ..
        ora     ($CA),y                         ; B073 11 CA                    ..
        ora     ($FF),y                         ; B075 11 FF                    ..
        .byte   $FF                             ; B077 FF                       .
        nop                                     ; B078 EA                       .
        ora     ($DC),y                         ; B079 11 DC                    ..
        .byte   $A7                             ; B07B A7                       .
        .byte   $FF                             ; B07C FF                       .
        and     ($31),y                         ; B07D 31 31                    11
        .byte   $3F                             ; B07F 3F                       ?
        sta     $1B,x                           ; B080 95 1B                    ..
        .byte   $DF                             ; B082 DF                       .
        ldx     $01,y                           ; B083 B6 01                    ..
        cmp     $F8CD                           ; B085 CD CD F8                 ...
        .byte   $97                             ; B088 97                       .
        stx     $EF                             ; B089 86 EF                    ..
        dec     L0011,x                         ; B08B D6 11                    ..
        ora     ($FF),y                         ; B08D 11 FF                    ..
        sed                                     ; B08F F8                       .
        .byte   $FF                             ; B090 FF                       .
        sta     ($91),y                         ; B091 91 91                    ..
        .byte   $93                             ; B093 93                       .
        .byte   $FF                             ; B094 FF                       .
        ora     ($FF),y                         ; B095 11 FF                    ..
        ora     ($B5),y                         ; B097 11 B5                    ..
        lda     ($C2),y                         ; B099 B1 C2                    ..
        .byte   $B3                             ; B09B B3                       .
        .byte   $73                             ; B09C 73                       s
        adc     $77,x                           ; B09D 75 77                    uw
        adc     LB1D5,y                         ; B09F 79 D5 B1                 y..
        .byte   $C2                             ; B0A2 C2                       .
        .byte   $B3                             ; B0A3 B3                       .
        sta     ($91),y                         ; B0A4 91 91                    ..
        .byte   $93                             ; B0A6 93                       .
        .byte   $D7                             ; B0A7 D7                       .
        sbc     $D1,x                           ; B0A8 F5 D1                    ..
        sta     $D3,x                           ; B0AA 95 D3                    ..
        sbc     ($F1),y                         ; B0AC F1 F1                    ..
        .byte   $F3                             ; B0AE F3                       .
        .byte   $1A                             ; B0AF 1A                       .
        .byte   $97                             ; B0B0 97                       .
        sta     $7D9A,y                         ; B0B1 99 9A 7D                 ..}
        .byte   $C7                             ; B0B4 C7                       .
        cmp     #$E7                            ; B0B5 C9 E7                    ..
        sbc     #$B7                            ; B0B7 E9 B7                    ..
        lda     $7BBA,y                         ; B0B9 B9 BA 7B                 ..{
        .byte   $D7                             ; B0BC D7                       .
        .byte   $1A                             ; B0BD 1A                       .
        txs                                     ; B0BE 9A                       .
        .byte   $7B                             ; B0BF 7B                       {
        cmp     a:$CF                           ; B0C0 CD CF 00                 ...
        sbc     $FFFB,y                         ; B0C3 F9 FB FF                 ...
        .byte   $FF                             ; B0C6 FF                       .
        .byte   $FF                             ; B0C7 FF                       .
        brk                                     ; B0C8 00                       .
        .byte   $EF                             ; B0C9 EF                       .
        .byte   $FF                             ; B0CA FF                       .
        .byte   $FF                             ; B0CB FF                       .
        .byte   $FF                             ; B0CC FF                       .
        .byte   $FF                             ; B0CD FF                       .
        .byte   $FF                             ; B0CE FF                       .
        .byte   $FF                             ; B0CF FF                       .
        .byte   $FF                             ; B0D0 FF                       .
        .byte   $FF                             ; B0D1 FF                       .
        .byte   $FF                             ; B0D2 FF                       .
        .byte   $FF                             ; B0D3 FF                       .
        .byte   $FF                             ; B0D4 FF                       .
        .byte   $FF                             ; B0D5 FF                       .
        .byte   $FF                             ; B0D6 FF                       .
        .byte   $FF                             ; B0D7 FF                       .
        .byte   $FF                             ; B0D8 FF                       .
        .byte   $FF                             ; B0D9 FF                       .
        .byte   $FF                             ; B0DA FF                       .
        .byte   $FF                             ; B0DB FF                       .
        .byte   $FF                             ; B0DC FF                       .
        .byte   $FF                             ; B0DD FF                       .
        .byte   $FF                             ; B0DE FF                       .
        .byte   $FF                             ; B0DF FF                       .
        .byte   $FF                             ; B0E0 FF                       .
        .byte   $FF                             ; B0E1 FF                       .
        .byte   $FF                             ; B0E2 FF                       .
        .byte   $FF                             ; B0E3 FF                       .
        .byte   $FF                             ; B0E4 FF                       .
        .byte   $FF                             ; B0E5 FF                       .
        .byte   $FF                             ; B0E6 FF                       .
        .byte   $FF                             ; B0E7 FF                       .
        .byte   $FF                             ; B0E8 FF                       .
        .byte   $FF                             ; B0E9 FF                       .
        .byte   $FF                             ; B0EA FF                       .
        .byte   $FF                             ; B0EB FF                       .
        .byte   $FF                             ; B0EC FF                       .
        .byte   $FF                             ; B0ED FF                       .
        .byte   $FF                             ; B0EE FF                       .
        .byte   $FF                             ; B0EF FF                       .
        .byte   $FF                             ; B0F0 FF                       .
        .byte   $FF                             ; B0F1 FF                       .
        .byte   $FF                             ; B0F2 FF                       .
        .byte   $FF                             ; B0F3 FF                       .
        .byte   $FF                             ; B0F4 FF                       .
        .byte   $FF                             ; B0F5 FF                       .
        .byte   $FF                             ; B0F6 FF                       .
        .byte   $FF                             ; B0F7 FF                       .
        .byte   $FF                             ; B0F8 FF                       .
        .byte   $FF                             ; B0F9 FF                       .
        .byte   $FF                             ; B0FA FF                       .
        .byte   $FF                             ; B0FB FF                       .
        .byte   $FF                             ; B0FC FF                       .
        .byte   $FF                             ; B0FD FF                       .
        .byte   $FF                             ; B0FE FF                       .
        .byte   $FF                             ; B0FF FF                       .
        brk                                     ; B100 00                       .
        brk                                     ; B101 00                       .
        bpl     LB115                           ; B102 10 11                    ..
        beq     LB108                           ; B104 F0 02                    ..
        sbc     (L0040),y                       ; B106 F1 40                    .@
LB108:  bpl     LB10C                           ; B108 10 02                    ..
        .byte   $02                             ; B10A 02                       .
        .byte   $02                             ; B10B 02                       .
LB10C:  .byte   $02                             ; B10C 02                       .
        .byte   $02                             ; B10D 02                       .
        brk                                     ; B10E 00                       .
        jsr     L0210                           ; B10F 20 10 02                  ..
        .byte   $02                             ; B112 02                       .
        .byte   $02                             ; B113 02                       .
        .byte   $02                             ; B114 02                       .
LB115:  .byte   $02                             ; B115 02                       .
        .byte   $02                             ; B116 02                       .
        and     ($10,x)                         ; B117 21 10                    !.
        ora     ($10),y                         ; B119 11 10                    ..
        ora     ($10),y                         ; B11B 11 10                    ..
        ora     ($10),y                         ; B11D 11 10                    ..
        ora     ($10),y                         ; B11F 11 10                    ..
        ora     ($10),y                         ; B121 11 10                    ..
        ora     ($10),y                         ; B123 11 10                    ..
        ora     ($10),y                         ; B125 11 10                    ..
        ora     ($10),y                         ; B127 11 10                    ..
        ora     ($10),y                         ; B129 11 10                    ..
        ora     ($10),y                         ; B12B 11 10                    ..
        ora     ($10),y                         ; B12D 11 10                    ..
        ora     ($10),y                         ; B12F 11 10                    ..
        ora     ($10),y                         ; B131 11 10                    ..
        ora     ($10),y                         ; B133 11 10                    ..
        ora     ($10),y                         ; B135 11 10                    ..
        ora     ($10),y                         ; B137 11 10                    ..
        ora     ($10),y                         ; B139 11 10                    ..
        ora     ($10),y                         ; B13B 11 10                    ..
        ora     ($10),y                         ; B13D 11 10                    ..
        ora     (L0002),y                       ; B13F 11 02                    ..
        .byte   $02                             ; B141 02                       .
        .byte   $02                             ; B142 02                       .
        .byte   $02                             ; B143 02                       .
        .byte   $03                             ; B144 03                       .
        .byte   $03                             ; B145 03                       .
        .byte   $03                             ; B146 03                       .
        brk                                     ; B147 00                       .
        .byte   $02                             ; B148 02                       .
        .byte   $02                             ; B149 02                       .
        .byte   $02                             ; B14A 02                       .
        .byte   $02                             ; B14B 02                       .
        .byte   $03                             ; B14C 03                       .
        .byte   $03                             ; B14D 03                       .
        .byte   $03                             ; B14E 03                       .
        .byte   $03                             ; B14F 03                       .
        .byte   $02                             ; B150 02                       .
        .byte   $02                             ; B151 02                       .
        .byte   $02                             ; B152 02                       .
        .byte   $02                             ; B153 02                       .
        .byte   $03                             ; B154 03                       .
        .byte   $03                             ; B155 03                       .
        .byte   $03                             ; B156 03                       .
        .byte   $03                             ; B157 03                       .
        .byte   $02                             ; B158 02                       .
        .byte   $02                             ; B159 02                       .
        .byte   $02                             ; B15A 02                       .
        .byte   $02                             ; B15B 02                       .
        .byte   $03                             ; B15C 03                       .
        .byte   $03                             ; B15D 03                       .
        .byte   $03                             ; B15E 03                       .
        .byte   $03                             ; B15F 03                       .
        .byte   $03                             ; B160 03                       .
        .byte   $03                             ; B161 03                       .
        .byte   $03                             ; B162 03                       .
        .byte   $03                             ; B163 03                       .
        .byte   $03                             ; B164 03                       .
        .byte   $03                             ; B165 03                       .
        .byte   $02                             ; B166 02                       .
        .byte   $02                             ; B167 02                       .
        .byte   $03                             ; B168 03                       .
        .byte   $03                             ; B169 03                       .
        .byte   $03                             ; B16A 03                       .
        .byte   $03                             ; B16B 03                       .
        .byte   $03                             ; B16C 03                       .
        .byte   $03                             ; B16D 03                       .
        .byte   $02                             ; B16E 02                       .
        .byte   $02                             ; B16F 02                       .
        .byte   $03                             ; B170 03                       .
        .byte   $03                             ; B171 03                       .
        .byte   $03                             ; B172 03                       .
        .byte   $03                             ; B173 03                       .
        .byte   $03                             ; B174 03                       .
        .byte   $03                             ; B175 03                       .
        brk                                     ; B176 00                       .
        brk                                     ; B177 00                       .
        .byte   $03                             ; B178 03                       .
        .byte   $03                             ; B179 03                       .
        .byte   $03                             ; B17A 03                       .
        .byte   $03                             ; B17B 03                       .
        brk                                     ; B17C 00                       .
        ora     ($10),y                         ; B17D 11 10                    ..
        ora     ($10),y                         ; B17F 11 10                    ..
        ora     ($10),y                         ; B181 11 10                    ..
        bpl     LB188                           ; B183 10 03                    ..
        .byte   $03                             ; B185 03                       .
        .byte   $03                             ; B186 03                       .
        .byte   $03                             ; B187 03                       .
LB188:  bpl     LB19B                           ; B188 10 11                    ..
        bpl     LB19C                           ; B18A 10 10                    ..
        .byte   $03                             ; B18C 03                       .
        .byte   $03                             ; B18D 03                       .
        brk                                     ; B18E 00                       .
        .byte   $03                             ; B18F 03                       .
        brk                                     ; B190 00                       .
        .byte   $13                             ; B191 13                       .
        .byte   $13                             ; B192 13                       .
        .byte   $13                             ; B193 13                       .
        brk                                     ; B194 00                       .
        .byte   $03                             ; B195 03                       .
        brk                                     ; B196 00                       .
        .byte   $03                             ; B197 03                       .
        .byte   $13                             ; B198 13                       .
        .byte   $13                             ; B199 13                       .
        .byte   $13                             ; B19A 13                       .
LB19B:  .byte   $13                             ; B19B 13                       .
LB19C:  bpl     LB1AF                           ; B19C 10 11                    ..
        bpl     LB1B1                           ; B19E 10 11                    ..
        .byte   $13                             ; B1A0 13                       .
        .byte   $13                             ; B1A1 13                       .
        .byte   $13                             ; B1A2 13                       .
        .byte   $13                             ; B1A3 13                       .
        .byte   $13                             ; B1A4 13                       .
        .byte   $13                             ; B1A5 13                       .
        .byte   $13                             ; B1A6 13                       .
        .byte   $02                             ; B1A7 02                       .
        .byte   $13                             ; B1A8 13                       .
        .byte   $13                             ; B1A9 13                       .
        .byte   $13                             ; B1AA 13                       .
        .byte   $13                             ; B1AB 13                       .
        .byte   $13                             ; B1AC 13                       .
        .byte   $13                             ; B1AD 13                       .
        .byte   $13                             ; B1AE 13                       .
LB1AF:  .byte   $02                             ; B1AF 02                       .
        .byte   $02                             ; B1B0 02                       .
LB1B1:  .byte   $02                             ; B1B1 02                       .
        .byte   $02                             ; B1B2 02                       .
        .byte   $02                             ; B1B3 02                       .
        .byte   $02                             ; B1B4 02                       .
        .byte   $02                             ; B1B5 02                       .
        .byte   $02                             ; B1B6 02                       .
        .byte   $02                             ; B1B7 02                       .
        .byte   $02                             ; B1B8 02                       .
        .byte   $02                             ; B1B9 02                       .
        .byte   $02                             ; B1BA 02                       .
        .byte   $02                             ; B1BB 02                       .
        .byte   $02                             ; B1BC 02                       .
        .byte   $02                             ; B1BD 02                       .
        .byte   $02                             ; B1BE 02                       .
        .byte   $02                             ; B1BF 02                       .
        .byte   $02                             ; B1C0 02                       .
        .byte   $02                             ; B1C1 02                       .
        .byte   $02                             ; B1C2 02                       .
        .byte   $02                             ; B1C3 02                       .
        .byte   $02                             ; B1C4 02                       .
        brk                                     ; B1C5 00                       .
        brk                                     ; B1C6 00                       .
        brk                                     ; B1C7 00                       .
        .byte   $02                             ; B1C8 02                       .
        .byte   $02                             ; B1C9 02                       .
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
LB1D5:  brk                                     ; B1D5 00                       .
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
        sty     $84                             ; B200 84 84                    ..
        sty     $84                             ; B202 84 84                    ..
        sty     $84                             ; B204 84 84                    ..
        sta     $86                             ; B206 85 86                    ..
        sty     $84                             ; B208 84 84                    ..
        .byte   $87                             ; B20A 87                       .
        sty     $84                             ; B20B 84 84                    ..
        sta     $8D                             ; B20D 85 8D                    ..
        lsr     $86                             ; B20F 46 86                    F.
        sta     $46,x                           ; B211 95 46                    .F
        lsr     $46                             ; B213 46 46                    FF
        lsr     $46                             ; B215 46 46                    FF
        lsr     $84                             ; B217 46 84                    F.
        sta     $468C                           ; B219 8D 8C 46                 ..F
        lsr     $97                             ; B21C 46 97                    F.
        lsr     $46                             ; B21E 46 46                    FF
        lsr     $46                             ; B220 46 46                    FF
        jmp     (L466D)                         ; B222 6C 6D 46                 lmF

; ----------------------------------------------------------------------------
        lsr     $64                             ; B225 46 64                    Fd
        adc     $6C                             ; B227 65 6C                    el
        adc     $6160                           ; B229 6D 60 61                 m`a
        .byte   $64                             ; B22C 64                       d
        adc     $78                             ; B22D 65 78                    ex
        adc     $6160,y                         ; B22F 79 60 61                 y`a
        pla                                     ; B232 68                       h
        adc     #$6C                            ; B233 69 6C                    il
        adc     $6362                           ; B235 6D 62 63                 mbc
        sei                                     ; B238 78                       x
        adc     $7372,y                         ; B239 79 72 73                 yrs
        pla                                     ; B23C 68                       h
        adc     #$6A                            ; B23D 69 6A                    ij
        .byte   $6B                             ; B23F 6B                       k
        .byte   $72                             ; B240 72                       r
        .byte   $73                             ; B241 73                       s
        .byte   $72                             ; B242 72                       r
        .byte   $73                             ; B243 73                       s
        ror     a                               ; B244 6A                       j
        .byte   $6B                             ; B245 6B                       k
        ror     a                               ; B246 6A                       j
        .byte   $6B                             ; B247 6B                       k
        .byte   $7A                             ; B248 7A                       z
        .byte   $7B                             ; B249 7B                       {
        ror     $546F                           ; B24A 6E 6F 54                 noT
        eor     $5C,x                           ; B24D 55 5C                    U\
        eor     $5756,x                         ; B24F 5D 56 57                 ]VW
        brk                                     ; B252 00                       .
        brk                                     ; B253 00                       .
        .byte   $52                             ; B254 52                       R
        .byte   $53                             ; B255 53                       S
        .byte   $5A                             ; B256 5A                       Z
        .byte   $5B                             ; B257 5B                       [
        bvc     LB2AB                           ; B258 50 51                    PQ
        cli                                     ; B25A 58                       X
        eor     $2120,y                         ; B25B 59 20 21                 Y !
        plp                                     ; B25E 28                       (
        and     #$22                            ; B25F 29 22                    )"
        .byte   $23                             ; B261 23                       #
        rol     a                               ; B262 2A                       *
        .byte   $2B                             ; B263 2B                       +
        jsr     L2421                           ; B264 20 21 24                  !$
        and     $22                             ; B267 25 22                    %"
        .byte   $23                             ; B269 23                       #
        .byte   $1A                             ; B26A 1A                       .
        .byte   $1B                             ; B26B 1B                       .
        jsr     L1C21                           ; B26C 20 21 1C                  !.
        ora     $1615,x                         ; B26F 1D 15 16                 ...
        .byte   $0C                             ; B272 0C                       .
        .byte   $0B                             ; B273 0B                       .
        bit     $162D                           ; B274 2C 2D 16                 ,-.
        ora     $2A,x                           ; B277 15 2A                    .*
        .byte   $2B                             ; B279 2B                       +
        asl     $15,x                           ; B27A 16 15                    ..
        clc                                     ; B27C 18                       .
        ora     L1D1C,y                         ; B27D 19 1C 1D                 ...
        asl     $1E1F,x                         ; B280 1E 1F 1E                 ...
        .byte   $1F                             ; B283 1F                       .
        .byte   $97                             ; B284 97                       .
        stx     $46                             ; B285 86 46                    .F
        lsr     $87                             ; B287 46 87                    F.
        sty     $46                             ; B289 84 46                    .F
        .byte   $8F                             ; B28B 8F                       .
        .byte   $1C                             ; B28C 1C                       .
        ora     $3938,x                         ; B28D 1D 38 39                 .89
        .byte   $32                             ; B290 32                       2
        .byte   $33                             ; B291 33                       3
        .byte   $3A                             ; B292 3A                       :
        .byte   $3B                             ; B293 3B                       ;
        .byte   $34                             ; B294 34                       4
        and     $3C,x                           ; B295 35 3C                    5<
        and     $0A09,x                         ; B297 3D 09 0A                 =..
        rol     $37,x                           ; B29A 36 37                    67
        sty     $468F                           ; B29C 8C 8F 46                 ..F
        lsr     $84                             ; B29F 46 84                    F.
        sta     $8C                             ; B2A1 85 8C                    ..
        lsr     $18                             ; B2A3 46 18                    F.
        ora     $3938,y                         ; B2A5 19 38 39                 .89
        rol     $3A3F,x                         ; B2A8 3E 3F 3A                 >?:
LB2AB:  .byte   $3B                             ; B2AB 3B                       ;
        .byte   $52                             ; B2AC 52                       R
        .byte   $53                             ; B2AD 53                       S
        jsr     L5221                           ; B2AE 20 21 52                  !R
        .byte   $53                             ; B2B1 53                       S
        .byte   $22                             ; B2B2 22                       "
        .byte   $23                             ; B2B3 23                       #
        bvc     LB307                           ; B2B4 50 51                    PQ
        jsr     L5021                           ; B2B6 20 21 50                  !P
        eor     ($22),y                         ; B2B9 51 22                    Q"
        .byte   $23                             ; B2BB 23                       #
        .byte   $22                             ; B2BC 22                       "
        .byte   $23                             ; B2BD 23                       #
        rol     $27                             ; B2BE 26 27                    &'
        clc                                     ; B2C0 18                       .
        ora     $2928,y                         ; B2C1 19 28 29                 .()
        .byte   $1C                             ; B2C4 1C                       .
        ora     $2524,x                         ; B2C5 1D 24 25                 .$%
        .byte   $1A                             ; B2C8 1A                       .
        .byte   $1B                             ; B2C9 1B                       .
        asl     $241F,x                         ; B2CA 1E 1F 24                 ..$
        and     $2C                             ; B2CD 25 2C                    %,
        and     $1B1A                           ; B2CF 2D 1A 1B                 -..
        rol     a                               ; B2D2 2A                       *
        .byte   $2B                             ; B2D3 2B                       +
        rol     $162F                           ; B2D4 2E 2F 16                 ./.
        ora     $0B,x                           ; B2D7 15 0B                    ..
        .byte   $0C                             ; B2D9 0C                       .
        .byte   $0C                             ; B2DA 0C                       .
        .byte   $0B                             ; B2DB 0B                       .
        .byte   $0B                             ; B2DC 0B                       .
        .byte   $0C                             ; B2DD 0C                       .
        asl     a                               ; B2DE 0A                       .
        ora     #$3C                            ; B2DF 09 3C                    .<
        and     $3938,x                         ; B2E1 3D 38 39                 =89
        bmi     LB317                           ; B2E4 30 31                    01
        sec                                     ; B2E6 38                       8
        and     $1B1A,y                         ; B2E7 39 1A 1B                 9..
        .byte   $1A                             ; B2EA 1A                       .
        .byte   $1B                             ; B2EB 1B                       .
        asl     $1A1F,x                         ; B2EC 1E 1F 1A                 ...
        .byte   $1B                             ; B2EF 1B                       .
        jsr     L1821                           ; B2F0 20 21 18                  !.
        .byte   $19                             ; B2F3 19                       .
        .byte   $22                             ; B2F4 22                       "
LB2F5:  .byte   $23                             ; B2F5 23                       #
        asl     $111F,x                         ; B2F6 1E 1F 11                 ...
        .byte   $12                             ; B2F9 12                       .
        .byte   $0C                             ; B2FA 0C                       .
        .byte   $0B                             ; B2FB 0B                       .
        plp                                     ; B2FC 28                       (
        and     #$16                            ; B2FD 29 16                    ).
        ora     $13,x                           ; B2FF 15 13                    ..
        .byte   $14                             ; B301 14                       .
        .byte   $0C                             ; B302 0C                       .
        .byte   $0B                             ; B303 0B                       .
        bmi     LB337                           ; B304 30 31                    01
        clc                                     ; B306 18                       .
LB307:  ora     $0A09,y                         ; B307 19 09 0A                 ...
        .byte   $32                             ; B30A 32                       2
        .byte   $33                             ; B30B 33                       3
        .byte   $1C                             ; B30C 1C                       .
        ora     $1918,x                         ; B30D 1D 18 19                 ...
        asl     $3A1F,x                         ; B310 1E 1F 3A                 ..:
        .byte   $3B                             ; B313 3B                       ;
        .byte   $13                             ; B314 13                       .
        .byte   $14                             ; B315 14                       .
        .byte   $09                             ; B316 09                       .
LB317:  asl     a                               ; B317 0A                       .
        .byte   $80                             ; B318 80                       .
        sta     ($88,x)                         ; B319 81 88                    ..
        .byte   $89                             ; B31B 89                       .
        .byte   $42                             ; B31C 42                       B
        .byte   $43                             ; B31D 43                       C
        lsr     a                               ; B31E 4A                       J
        .byte   $4B                             ; B31F 4B                       K
        ora     ($05),y                         ; B320 11 05                    ..
        .byte   $0C                             ; B322 0C                       .
        ora     $0513                           ; B323 0D 13 05                 ...
        .byte   $0C                             ; B326 0C                       .
        ora     $0513                           ; B327 0D 13 05                 ...
        ora     #$0D                            ; B32A 09 0D                    ..
        .byte   $1A                             ; B32C 1A                       .
        .byte   $1B                             ; B32D 1B                       .
        rol     $27                             ; B32E 26 27                    &'
        ora     #$0A                            ; B330 09 0A                    ..
        .byte   $34                             ; B332 34                       4
        and     L0000,x                         ; B333 35 00                    5.
        brk                                     ; B335 00                       .
        brk                                     ; B336 00                       .
LB337:  brk                                     ; B337 00                       .
        brk                                     ; B338 00                       .
        brk                                     ; B339 00                       .
        ror     $67                             ; B33A 66 67                    fg
        rol     $1A3F,x                         ; B33C 3E 3F 1A                 >?.
        .byte   $1B                             ; B33F 1B                       .
        lsr     $464F                           ; B340 4E 4F 46                 NOF
        lsr     $70                             ; B343 46 70                    Fp
        adc     ($74),y                         ; B345 71 74                    qt
        adc     $4C,x                           ; B347 75 4C                    uL
        eor     $6160                           ; B349 4D 60 61                 M`a
        .byte   $1A                             ; B34C 1A                       .
        .byte   $1B                             ; B34D 1B                       .
        .byte   $3A                             ; B34E 3A                       :
        .byte   $3B                             ; B34F 3B                       ;
        clc                                     ; B350 18                       .
        ora     $1918,y                         ; B351 19 18 19                 ...
        .byte   $74                             ; B354 74                       t
        adc     $78,x                           ; B355 75 78                    ux
        adc     L1D1C,y                         ; B357 79 1C 1D                 y..
        .byte   $1C                             ; B35A 1C                       .
        ora     $0A09,x                         ; B35B 1D 09 0A                 ...
        bmi     LB391                           ; B35E 30 31                    01
        .byte   $82                             ; B360 82                       .
        .byte   $83                             ; B361 83                       .
        .byte   $82                             ; B362 82                       .
        .byte   $83                             ; B363 83                       .
        txa                                     ; B364 8A                       .
        .byte   $8B                             ; B365 8B                       .
        brk                                     ; B366 00                       .
        brk                                     ; B367 00                       .
        bvs     LB3DB                           ; B368 70 71                    pq
        sei                                     ; B36A 78                       x
        adc     $8218,y                         ; B36B 79 18 82                 y..
        sec                                     ; B36E 38                       8
        .byte   $82                             ; B36F 82                       .
        .byte   $83                             ; B370 83                       .
        ora     $3983,y                         ; B371 19 83 39                 ..9
        .byte   $1C                             ; B374 1C                       .
        .byte   $0F                             ; B375 0F                       .
        sec                                     ; B376 38                       8
        .byte   $17                             ; B377 17                       .
        brk                                     ; B378 00                       .
        txa                                     ; B379 8A                       .
        brk                                     ; B37A 00                       .
        brk                                     ; B37B 00                       .
        .byte   $8B                             ; B37C 8B                       .
        brk                                     ; B37D 00                       .
        ror     $67                             ; B37E 66 67                    fg
        txa                                     ; B380 8A                       .
        .byte   $8B                             ; B381 8B                       .
        ror     $67                             ; B382 66 67                    fg
        brk                                     ; B384 00                       .
        .byte   $0F                             ; B385 0F                       .
        brk                                     ; B386 00                       .
        .byte   $17                             ; B387 17                       .
        lsr     $460F                           ; B388 4E 0F 46                 N.F
        .byte   $17                             ; B38B 17                       .
        lsr     $0F                             ; B38C 46 0F                    F.
        lsr     $17                             ; B38E 46 17                    F.
        .byte   $7A                             ; B390 7A                       z
LB391:  .byte   $7B                             ; B391 7B                       {
        ror     $2223                           ; B392 6E 23 22                 n#"
        .byte   $57                             ; B395 57                       W
        .byte   $1A                             ; B396 1A                       .
        brk                                     ; B397 00                       .
        .byte   $52                             ; B398 52                       R
        .byte   $53                             ; B399 53                       S
        .byte   $22                             ; B39A 22                       "
        .byte   $5B                             ; B39B 5B                       [
        .byte   $52                             ; B39C 52                       R
        .byte   $1B                             ; B39D 1B                       .
        .byte   $5A                             ; B39E 5A                       Z
        .byte   $1F                             ; B39F 1F                       .
        .byte   $1A                             ; B3A0 1A                       .
        .byte   $53                             ; B3A1 53                       S
        asl     $1A5B,x                         ; B3A2 1E 5B 1A                 .[.
        brk                                     ; B3A5 00                       .
        asl     a:L0000,x                       ; B3A6 1E 00 00                 ...
        .byte   $1B                             ; B3A9 1B                       .
        brk                                     ; B3AA 00                       .
        .byte   $1F                             ; B3AB 1F                       .
        .byte   $1C                             ; B3AC 1C                       .
        .byte   $0F                             ; B3AD 0F                       .
        .byte   $1C                             ; B3AE 1C                       .
        .byte   $17                             ; B3AF 17                       .
        .byte   $32                             ; B3B0 32                       2
        .byte   $33                             ; B3B1 33                       3
        .byte   $1A                             ; B3B2 1A                       .
        .byte   $1B                             ; B3B3 1B                       .
        ora     $12                             ; B3B4 05 12                    ..
        ora     a:$0B                           ; B3B6 0D 0B 00                 ...
        brk                                     ; B3B9 00                       .
        asl     $0D,x                           ; B3BA 16 0D                    ..
        brk                                     ; B3BC 00                       .
        brk                                     ; B3BD 00                       .
        ora     $16,x                           ; B3BE 15 16                    ..
        ora     $14                             ; B3C0 05 14                    ..
        ora     $1C0B                           ; B3C2 0D 0B 1C                 ...
        .byte   $0F                             ; B3C5 0F                       .
        .byte   $1C                             ; B3C6 1C                       .
        asl     a                               ; B3C7 0A                       .
        ora     $14                             ; B3C8 05 14                    ..
        ora     $200A                           ; B3CA 0D 0A 20                 .. 
        .byte   $07                             ; B3CD 07                       .
        .byte   $1C                             ; B3CE 1C                       .
        .byte   $17                             ; B3CF 17                       .
        .byte   $3A                             ; B3D0 3A                       :
        .byte   $3B                             ; B3D1 3B                       ;
        brk                                     ; B3D2 00                       .
        brk                                     ; B3D3 00                       .
        sec                                     ; B3D4 38                       8
        and     L0000,y                         ; B3D5 39 00 00                 9..
        .byte   $3A                             ; B3D8 3A                       :
        .byte   $3B                             ; B3D9 3B                       ;
        pha                                     ; B3DA 48                       H
LB3DB:  eor     #$1C                            ; B3DB 49 1C                    I.
        brk                                     ; B3DD 00                       .
        .byte   $1C                             ; B3DE 1C                       .
        brk                                     ; B3DF 00                       .
        .byte   $44                             ; B3E0 44                       D
        eor     $5E                             ; B3E1 45 5E                    E^
        .byte   $5F                             ; B3E3 5F                       _
        .byte   $1C                             ; B3E4 1C                       .
        .byte   $4F                             ; B3E5 4F                       O
        .byte   $1C                             ; B3E6 1C                       .
        lsr     $1C                             ; B3E7 46 1C                    F.
        lsr     $1C                             ; B3E9 46 1C                    F.
        lsr     $1C                             ; B3EB 46 1C                    F.
        .byte   $57                             ; B3ED 57                       W
        .byte   $1C                             ; B3EE 1C                       .
        brk                                     ; B3EF 00                       .
        .byte   $1C                             ; B3F0 1C                       .
        .byte   $53                             ; B3F1 53                       S
        .byte   $1C                             ; B3F2 1C                       .
        .byte   $5B                             ; B3F3 5B                       [
        .byte   $1C                             ; B3F4 1C                       .
        .byte   $07                             ; B3F5 07                       .
        .byte   $1C                             ; B3F6 1C                       .
        .byte   $17                             ; B3F7 17                       .
        clc                                     ; B3F8 18                       .
        ora     $2524,y                         ; B3F9 19 24 25                 .$%
        rol     $27                             ; B3FC 26 27                    &'
        rol     $3A2F                           ; B3FE 2E 2F 3A                 ./:
        .byte   $82                             ; B401 82                       .
        brk                                     ; B402 00                       .
        .byte   $82                             ; B403 82                       .
        .byte   $83                             ; B404 83                       .
        and     $83,y                           ; B405 39 83 00                 9..
        .byte   $72                             ; B408 72                       r
        .byte   $73                             ; B409 73                       s
        adc     $467E,x                         ; B40A 7D 7E 46                 }~F
        lsr     $7F                             ; B40D 46 7F                    F.
        lsr     $72                             ; B40F 46 72                    Fr
        .byte   $73                             ; B411 73                       s
        .byte   $72                             ; B412 72                       r
        .byte   $02                             ; B413 02                       .
        lsr     $46                             ; B414 46 46                    FF
        .byte   $03                             ; B416 03                       .
        bpl     LB46F                           ; B417 10 56                    .V
        adc     a:L0000,x                       ; B419 7D 00 00                 }..
        .byte   $03                             ; B41C 03                       .
        bpl     LB41F                           ; B41D 10 00                    ..
LB41F:  brk                                     ; B41F 00                       .
        .byte   $52                             ; B420 52                       R
        .byte   $53                             ; B421 53                       S
        .byte   $04                             ; B422 04                       .
        asl     $52                             ; B423 06 52                    .R
        .byte   $53                             ; B425 53                       S
        .byte   $04                             ; B426 04                       .
        .byte   $5B                             ; B427 5B                       [
        .byte   $52                             ; B428 52                       R
        .byte   $53                             ; B429 53                       S
        .byte   $5A                             ; B42A 5A                       Z
        asl     $22                             ; B42B 06 22                    ."
        brk                                     ; B42D 00                       .
        asl     a:L0000,x                       ; B42E 1E 00 00                 ...
        .byte   $23                             ; B431 23                       #
        brk                                     ; B432 00                       .
        .byte   $1F                             ; B433 1F                       .
        .byte   $0F                             ; B434 0F                       .
        .byte   $1F                             ; B435 1F                       .
        .byte   $17                             ; B436 17                       .
        .byte   $1F                             ; B437 1F                       .
        adc     $727E,x                         ; B438 7D 7E 72                 }~r
        .byte   $73                             ; B43B 73                       s
        .byte   $7F                             ; B43C 7F                       .
        .byte   $4F                             ; B43D 4F                       O
        lsr     $46                             ; B43E 46 46                    FF
        .byte   $7F                             ; B440 7F                       .
        lsr     $46                             ; B441 46 46                    FF
        lsr     $7E                             ; B443 46 7E                    F~
        .byte   $7F                             ; B445 7F                       .
        brk                                     ; B446 00                       .
        brk                                     ; B447 00                       .
        .byte   $52                             ; B448 52                       R
        .byte   $1F                             ; B449 1F                       .
        .byte   $04                             ; B44A 04                       .
        .byte   $1F                             ; B44B 1F                       .
        .byte   $0F                             ; B44C 0F                       .
        .byte   $1F                             ; B44D 1F                       .
        .byte   $17                             ; B44E 17                       .
        .byte   $3B                             ; B44F 3B                       ;
        .byte   $0F                             ; B450 0F                       .
        .byte   $43                             ; B451 43                       C
        .byte   $17                             ; B452 17                       .
        .byte   $4B                             ; B453 4B                       K
        .byte   $0F                             ; B454 0F                       .
        .byte   $12                             ; B455 12                       .
        .byte   $0C                             ; B456 0C                       .
        .byte   $0B                             ; B457 0B                       .
        brk                                     ; B458 00                       .
        brk                                     ; B459 00                       .
        asl     $15,x                           ; B45A 16 15                    ..
        .byte   $3C                             ; B45C 3C                       <
        and     $1918,x                         ; B45D 3D 18 19                 =..
        brk                                     ; B460 00                       .
        brk                                     ; B461 00                       .
        ora     $0D,x                           ; B462 15 0D                    ..
        brk                                     ; B464 00                       .
        brk                                     ; B465 00                       .
        ora     $15,x                           ; B466 15 15                    ..
        brk                                     ; B468 00                       .
        .byte   $1F                             ; B469 1F                       .
        ora     $1F,x                           ; B46A 15 1F                    ..
        .byte   $13                             ; B46C 13                       .
        .byte   $14                             ; B46D 14                       .
        asl     a                               ; B46E 0A                       .
LB46F:  ora     #$05                            ; B46F 09 05                    ..
        .byte   $14                             ; B471 14                       .
        ora     $1309                           ; B472 0D 09 13                 ...
        ora     $0A                             ; B475 05 0A                    ..
        ora     $1F13                           ; B477 0D 13 1F                 ...
        asl     a                               ; B47A 0A                       .
        .byte   $1F                             ; B47B 1F                       .
        .byte   $07                             ; B47C 07                       .
        .byte   $1F                             ; B47D 1F                       .
        .byte   $17                             ; B47E 17                       .
        .byte   $1F                             ; B47F 1F                       .
        .byte   $3A                             ; B480 3A                       :
        .byte   $3B                             ; B481 3B                       ;
        sty     $84                             ; B482 84 84                    ..
        sec                                     ; B484 38                       8
        and     $8484,y                         ; B485 39 84 84                 9..
        sec                                     ; B488 38                       8
        and     $8584,y                         ; B489 39 84 85                 9..
        .byte   $3A                             ; B48C 3A                       :
        .byte   $3B                             ; B48D 3B                       ;
LB48E:  stx     $95                             ; B48E 86 95                    ..
        sec                                     ; B490 38                       8
        and     $4646,y                         ; B491 39 46 46                 9FF
        .byte   $3A                             ; B494 3A                       :
        .byte   $3B                             ; B495 3B                       ;
        .byte   $97                             ; B496 97                       .
        .byte   $87                             ; B497 87                       .
        sta     $95                             ; B498 85 95                    ..
        lsr     $46                             ; B49A 46 46                    FF
        sty     $6C8C                           ; B49C 8C 8C 6C                 ..l
LB49F:  adc     $848F                           ; B49F 6D 8F 84                 m..
        lsr     $8C                             ; B4A2 46 8C                    F.
        sta     $4646                           ; B4A4 8D 46 46                 .FF
        lsr     $07                             ; B4A7 46 07                    F.
        .byte   $23                             ; B4A9 23                       #
        .byte   $17                             ; B4AA 17                       .
        .byte   $1F                             ; B4AB 1F                       .
        sec                                     ; B4AC 38                       8
        and     $9585,y                         ; B4AD 39 85 95                 9..
        .byte   $3A                             ; B4B0 3A                       :
        .byte   $3B                             ; B4B1 3B                       ;
        lsr     $46                             ; B4B2 46 46                    FF
        .byte   $97                             ; B4B4 97                       .
        .byte   $87                             ; B4B5 87                       .
        lsr     $46                             ; B4B6 46 46                    FF
        sec                                     ; B4B8 38                       8
        and     $8797,y                         ; B4B9 39 97 87                 9..
        .byte   $3A                             ; B4BC 3A                       :
        .byte   $3B                             ; B4BD 3B                       ;
        sta     $86                             ; B4BE 85 86                    ..
        sec                                     ; B4C0 38                       8
        and     $9586,y                         ; B4C1 39 86 95                 9..
        .byte   $3A                             ; B4C4 3A                       :
        .byte   $3B                             ; B4C5 3B                       ;
        lsr     $97                             ; B4C6 46 97                    F.
        sec                                     ; B4C8 38                       8
        and     $8487,y                         ; B4C9 39 87 84                 9..
        lsr     $8F                             ; B4CC 46 8F                    F.
        lsr     $46                             ; B4CE 46 46                    FF
        asl     $2A1F,x                         ; B4D0 1E 1F 2A                 ..*
        .byte   $2B                             ; B4D3 2B                       +
        rol     $37,x                           ; B4D4 36 37                    67
        rol     $023F,x                         ; B4D6 3E 3F 02                 >?.
        .byte   $03                             ; B4D9 03                       .
        adc     $7E7E,x                         ; B4DA 7D 7E 7E                 }~~
        .byte   $7F                             ; B4DD 7F                       .
        .byte   $03                             ; B4DE 03                       .
        bpl     LB4E3                           ; B4DF 10 02                    ..
        .byte   $03                             ; B4E1 03                       .
        brk                                     ; B4E2 00                       .
LB4E3:  brk                                     ; B4E3 00                       .
        ldy     $B5,x                           ; B4E4 B4 B5                    ..
        tsx                                     ; B4E6 BA                       .
        .byte   $BB                             ; B4E7 BB                       .
        ora     ($12),y                         ; B4E8 11 12                    ..
        .byte   $0C                             ; B4EA 0C                       .
        .byte   $0C                             ; B4EB 0C                       .
        bcs     LB49F                           ; B4EC B0 B1                    ..
        clv                                     ; B4EE B8                       .
        lda     LB7B6,y                         ; B4EF B9 B6 B7                 ...
        .byte   $0C                             ; B4F2 0C                       .
        .byte   $0B                             ; B4F3 0B                       .
        ldy     LBABD,x                         ; B4F4 BC BD BA                 ...
        .byte   $BB                             ; B4F7 BB                       .
        tya                                     ; B4F8 98                       .
        sta     ($98),y                         ; B4F9 91 98                    ..
        sta     $9392,y                         ; B4FB 99 92 93                 ...
        txs                                     ; B4FE 9A                       .
        .byte   $9B                             ; B4FF 9B                       .
        tya                                     ; B500 98                       .
        sta     LA198,y                         ; B501 99 98 A1                 ...
        txs                                     ; B504 9A                       .
        .byte   $9B                             ; B505 9B                       .
        ldx     #$A3                            ; B506 A2 A3                    ..
        plp                                     ; B508 28                       (
        and     #$34                            ; B509 29 34                    )4
        and     $2A,x                           ; B50B 35 2A                    5*
        .byte   $2B                             ; B50D 2B                       +
        .byte   $32                             ; B50E 32                       2
        .byte   $33                             ; B50F 33                       3
        ldy     #$A9                            ; B510 A0 A9                    ..
        tay                                     ; B512 A8                       .
        ldy     LABAA                           ; B513 AC AA AB                 ...
        lda     a:$AE                           ; B516 AD AE 00                 ...
        brk                                     ; B519 00                       .
        ldx     LA0BF,y                         ; B51A BE BF A0                 ...
        lda     ($A8,x)                         ; B51D A1 A8                    ..
        lda     #$A2                            ; B51F A9 A2                    ..
        .byte   $A3                             ; B521 A3                       .
        tax                                     ; B522 AA                       .
        .byte   $AB                             ; B523 AB                       .
        ldy     #$91                            ; B524 A0 91                    ..
        tay                                     ; B526 A8                       .
        .byte   $99,$98,$A4                     ; B527 99 98 A4
        tya                                     ; B52A 98                       .
        .byte   $99,$A5,$A6                     ; B52B 99 A5 A6
        txs                                     ; B52E 9A                       .
        .byte   $9B                             ; B52F 9B                       .
        ldx     $B7,y                           ; B530 B6 B7                    ..
        jsr     LB621                           ; B532 20 21 B6                  !.
        .byte   $B7                             ; B535 B7                       .
        .byte   $22                             ; B536 22                       "
LB537:  .byte   $23                             ; B537 23                       #
        tya                                     ; B538 98                       .
        lda     ($98,x)                         ; B539 A1 98                    ..
        lda     (L00A2,x)                       ; B53B A1 A2                    ..
        .byte   $A3                             ; B53D A3                       .
        ldx     #$A3                            ; B53E A2 A3                    ..
        tya                                     ; B540 98                       .
        brk                                     ; B541 00                       .
        tya                                     ; B542 98                       .
        ora     $98,x                           ; B543 15 98                    ..
        brk                                     ; B545 00                       .
        tya                                     ; B546 98                       .
        ora     LBDBC                           ; B547 0D BC BD                 ...
        jsr     L1321                           ; B54A 20 21 13                  !.
        ora     $22                             ; B54D 05 22                    ."
        .byte   $23                             ; B54F 23                       #
        brk                                     ; B550 00                       .
        .byte   $14                             ; B551 14                       .
        jsr     L1321                           ; B552 20 21 13                  !.
        .byte   $14                             ; B555 14                       .
        .byte   $22                             ; B556 22                       "
        .byte   $23                             ; B557 23                       #
        brk                                     ; B558 00                       .
        ora     L0020                           ; B559 05 20                    . 
        and     ($12,x)                         ; B55B 21 12                    !.
        ora     L000C                           ; B55D 05 0C                    ..
        ora     LAFA7                           ; B55F 0D A7 AF                 ...
        tsx                                     ; B562 BA                       .
        .byte   $BB                             ; B563 BB                       .
        .byte   $13                             ; B564 13                       .
        ora     L0020                           ; B565 05 20                    . 
        and     ($B6,x)                         ; B567 21 B6                    !.
        .byte   $B7                             ; B569 B7                       .
        tya                                     ; B56A 98                       .
        sta     (L0000),y                       ; B56B 91 00                    ..
        brk                                     ; B56D 00                       .
        .byte   $92                             ; B56E 92                       .
        .byte   $93                             ; B56F 93                       .
        brk                                     ; B570 00                       .
        brk                                     ; B571 00                       .
        tya                                     ; B572 98                       .
        sta     ($BC),y                         ; B573 91 BC                    ..
        lda     $2322,x                         ; B575 BD 22 23                 ."#
        brk                                     ; B578 00                       .
        brk                                     ; B579 00                       .
        .byte   $C3                             ; B57A C3                       .
        cpy     $0B                             ; B57B C4 0B                    ..
        iny                                     ; B57D C8                       .
        .byte   $0C                             ; B57E 0C                       .
        cpy     #$C1                            ; B57F C0 C1                    ..
        .byte   $0C                             ; B581 0C                       .
        cmp     #$0B                            ; B582 C9 0B                    ..
        .byte   $0B                             ; B584 0B                       .
        .byte   $0C                             ; B585 0C                       .
        .byte   $C3                             ; B586 C3                       .
        cpy     $C0                             ; B587 C4 C0                    ..
        brk                                     ; B589 00                       .
        .byte   $C3                             ; B58A C3                       .
        cpy     $C1                             ; B58B C4 C1                    ..
        .byte   $0C                             ; B58D 0C                       .
        .byte   $C3                             ; B58E C3                       .
        cpy     L0000                           ; B58F C4 00                    ..
        cmp     #$00                            ; B591 C9 00                    ..
        cmp     ($09,x)                         ; B593 C1 09                    ..
        asl     a                               ; B595 0A                       .
        .byte   $04                             ; B596 04                       .
        asl     $C0                             ; B597 06 C0                    ..
        .byte   $C2                             ; B599 C2                       .
        iny                                     ; B59A C8                       .
        brk                                     ; B59B 00                       .
        brk                                     ; B59C 00                       .
        cmp     #$00                            ; B59D C9 00                    ..
        brk                                     ; B59F 00                       .
        .byte   $0B                             ; B5A0 0B                       .
        .byte   $0C                             ; B5A1 0C                       .
        cmp     #$0B                            ; B5A2 C9 0B                    ..
        brk                                     ; B5A4 00                       .
        brk                                     ; B5A5 00                       .
        brk                                     ; B5A6 00                       .
        cmp     ($C1,x)                         ; B5A7 C1 C1                    ..
        .byte   $0C                             ; B5A9 0C                       .
        .byte   $0C                             ; B5AA 0C                       .
        .byte   $0B                             ; B5AB 0B                       .
        brk                                     ; B5AC 00                       .
        brk                                     ; B5AD 00                       .
        ora     $9815                           ; B5AE 0D 15 98                 ...
        ldy     $98                             ; B5B1 A4 98                    ..
        lda     ($A5,x)                         ; B5B3 A1 A5                    ..
        ldx     L00A2                           ; B5B5 A6 A2                    ..
        .byte   $A3                             ; B5B7 A3                       .
        .byte   $3A                             ; B5B8 3A                       :
        .byte   $3B                             ; B5B9 3B                       ;
        brk                                     ; B5BA 00                       .
LB5BB:  asl     $0E11                           ; B5BB 0E 11 0E                 ...
        .byte   $0C                             ; B5BE 0C                       .
        asl     LAAA9                           ; B5BF 0E A9 AA                 ...
        ldy     LABAD                           ; B5C2 AC AD AB                 ...
        ldy     #$AE                            ; B5C5 A0 AE                    ..
        tay                                     ; B5C7 A8                       .
        clc                                     ; B5C8 18                       .
        .byte   $43                             ; B5C9 43                       C
        .byte   $1C                             ; B5CA 1C                       .
        .byte   $4B                             ; B5CB 4B                       K
        .byte   $42                             ; B5CC 42                       B
        .byte   $1B                             ; B5CD 1B                       .
        lsr     a                               ; B5CE 4A                       J
        .byte   $1F                             ; B5CF 1F                       .
        .byte   $1C                             ; B5D0 1C                       .
        .byte   $12                             ; B5D1 12                       .
        clc                                     ; B5D2 18                       .
        .byte   $0B                             ; B5D3 0B                       .
        ora     ($1B),y                         ; B5D4 11 1B                    ..
        .byte   $0C                             ; B5D6 0C                       .
        .byte   $1F                             ; B5D7 1F                       .
        clc                                     ; B5D8 18                       .
        .byte   $14                             ; B5D9 14                       .
        .byte   $1C                             ; B5DA 1C                       .
        .byte   $0B                             ; B5DB 0B                       .
        .byte   $13                             ; B5DC 13                       .
        .byte   $1F                             ; B5DD 1F                       .
        .byte   $0C                             ; B5DE 0C                       .
        .byte   $1B                             ; B5DF 1B                       .
        sec                                     ; B5E0 38                       8
        .byte   $14                             ; B5E1 14                       .
        brk                                     ; B5E2 00                       .
        .byte   $0B                             ; B5E3 0B                       .
        .byte   $13                             ; B5E4 13                       .
        .byte   $1B                             ; B5E5 1B                       .
        .byte   $0C                             ; B5E6 0C                       .
        .byte   $1F                             ; B5E7 1F                       .
        ora     ($14),y                         ; B5E8 11 14                    ..
        .byte   $0C                             ; B5EA 0C                       .
        .byte   $0B                             ; B5EB 0B                       .
        sta     ($92),y                         ; B5EC 91 92                    ..
        sta     $939A,y                         ; B5EE 99 9A 93                 ...
        tya                                     ; B5F1 98                       .
        .byte   $9B                             ; B5F2 9B                       .
        tya                                     ; B5F3 98                       .
        lda     (L00A2,x)                       ; B5F4 A1 A2                    ..
        lda     (L00A2,x)                       ; B5F6 A1 A2                    ..
        .byte   $A3                             ; B5F8 A3                       .
        tya                                     ; B5F9 98                       .
        .byte   $A3                             ; B5FA A3                       .
        tya                                     ; B5FB 98                       .
        brk                                     ; B5FC 00                       .
        brk                                     ; B5FD 00                       .
        brk                                     ; B5FE 00                       .
        brk                                     ; B5FF 00                       .
        brk                                     ; B600 00                       .
        ora     (L0002,x)                       ; B601 01 02                    ..
        brk                                     ; B603 00                       .
        .byte   $03                             ; B604 03                       .
        .byte   $04                             ; B605 04                       .
        ora     $05                             ; B606 05 05                    ..
        asl     $05                             ; B608 06 05                    ..
        .byte   $07                             ; B60A 07                       .
        .byte   $04                             ; B60B 04                       .
        php                                     ; B60C 08                       .
        ora     $05                             ; B60D 05 05                    ..
        ora     $09                             ; B60F 05 09                    ..
        asl     a                               ; B611 0A                       .
        ora     $0B                             ; B612 05 0B                    ..
        .byte   $0C                             ; B614 0C                       .
        ora     #$0B                            ; B615 09 0B                    ..
        ora     $0F0E                           ; B617 0D 0E 0F                 ...
        ora     $10                             ; B61A 05 10                    ..
        ora     ($0E),y                         ; B61C 11 0E                    ..
        bpl     LB62C                           ; B61E 10 0C                    ..
        .byte   $12                             ; B620 12                       .
LB621:  .byte   $13                             ; B621 13                       .
        .byte   $14                             ; B622 14                       .
        .byte   $12                             ; B623 12                       .
        .byte   $13                             ; B624 13                       .
        .byte   $12                             ; B625 12                       .
        .byte   $12                             ; B626 12                       .
        .byte   $13                             ; B627 13                       .
        ora     $16,x                           ; B628 15 16                    ..
        ora     $15,x                           ; B62A 15 15                    ..
LB62C:  asl     $15,x                           ; B62C 16 15                    ..
        ora     $16,x                           ; B62E 15 16                    ..
        .byte   $17                             ; B630 17                       .
        clc                                     ; B631 18                       .
        ora     $1B1A,y                         ; B632 19 1A 1B                 ...
        .byte   $1A                             ; B635 1A                       .
        ora     $1C1A,y                         ; B636 19 1A 1C                 ...
        .byte   $1C                             ; B639 1C                       .
        ora     $1F1E,x                         ; B63A 1D 1E 1F                 ...
        jsr     L1E1D                           ; B63D 20 1D 1E                  ..
        ora     $21                             ; B640 05 21                    .!
        .byte   $22                             ; B642 22                       "
        brk                                     ; B643 00                       .
        .byte   $23                             ; B644 23                       #
        bit     $25                             ; B645 24 25                    $%
        .byte   $26                             ; B647 26                       &
LB648:  ora     $05                             ; B648 05 05                    ..
        ora     $27                             ; B64A 05 27                    .'
        plp                                     ; B64C 28                       (
        .byte   $04                             ; B64D 04                       .
        and     #$2A                            ; B64E 29 2A                    )*
        ora     $09                             ; B650 05 09                    ..
        ora     $0B                             ; B652 05 0B                    ..
        asl     a                               ; B654 0A                       .
        ora     $09                             ; B655 05 09                    ..
        ora     $0E05                           ; B657 0D 05 0E                 ...
        ora     $10                             ; B65A 05 10                    ..
        .byte   $0F                             ; B65C 0F                       .
        ora     $0E                             ; B65D 05 0E                    ..
        .byte   $0C                             ; B65F 0C                       .
        .byte   $14                             ; B660 14                       .
        .byte   $12                             ; B661 12                       .
        .byte   $14                             ; B662 14                       .
        .byte   $12                             ; B663 12                       .
        .byte   $13                             ; B664 13                       .
        .byte   $14                             ; B665 14                       .
        .byte   $12                             ; B666 12                       .
        .byte   $13                             ; B667 13                       .
        ora     $15,x                           ; B668 15 15                    ..
        .byte   $2B                             ; B66A 2B                       +
        bit     $2C2D                           ; B66B 2C 2D 2C                 ,-,
        .byte   $2B                             ; B66E 2B                       +
        rol     $2F17                           ; B66F 2E 17 2F                 ../
        bmi     LB692                           ; B672 30 1E                    0.
        and     ($32),y                         ; B674 31 32                    12
        .byte   $33                             ; B676 33                       3
        .byte   $34                             ; B677 34                       4
        .byte   $1C                             ; B678 1C                       .
        and     $1C,x                           ; B679 35 1C                    5.
        rol     $1D,x                           ; B67B 36 1D                    6.
        asl     $1C1C,x                         ; B67D 1E 1C 1C                 ...
        .byte   $37                             ; B680 37                       7
        and     $24                             ; B681 25 24                    %$
        bit     $38                             ; B683 24 38                    $8
        rol     a                               ; B685 2A                       *
        .byte   $23                             ; B686 23                       #
        .byte   $32                             ; B687 32                       2
        and     $0429,y                         ; B688 39 29 04                 9).
        php                                     ; B68B 08                       .
        .byte   $27                             ; B68C 27                       '
        plp                                     ; B68D 28                       (
        .byte   $22                             ; B68E 22                       "
        .byte   $3A                             ; B68F 3A                       :
        ora     $09                             ; B690 05 09                    ..
LB692:  ora     L000C                           ; B692 05 0C                    ..
        .byte   $0B                             ; B694 0B                       .
        ora     $05                             ; B695 05 05                    ..
        .byte   $3B                             ; B697 3B                       ;
        ora     $0E                             ; B698 05 0E                    ..
        ora     L0011                           ; B69A 05 11                    ..
        bpl     LB6A3                           ; B69C 10 05                    ..
        ora     $3B                             ; B69E 05 3B                    .;
        .byte   $14                             ; B6A0 14                       .
        .byte   $12                             ; B6A1 12                       .
        .byte   $14                             ; B6A2 14                       .
LB6A3:  .byte   $13                             ; B6A3 13                       .
        .byte   $12                             ; B6A4 12                       .
        .byte   $14                             ; B6A5 14                       .
        .byte   $14                             ; B6A6 14                       .
        jsr     L181B                           ; B6A7 20 1B 18                  ..
        ora     $3C18,y                         ; B6AA 19 18 3C                 ..<
        and     $3A3E,x                         ; B6AD 3D 3E 3A                 =>:
        .byte   $33                             ; B6B0 33                       3
        .byte   $1C                             ; B6B1 1C                       .
        ora     $3F1C,x                         ; B6B2 1D 1C 3F                 ..?
        .byte   $3A                             ; B6B5 3A                       :
        rti                                     ; B6B6 40                       @

; ----------------------------------------------------------------------------
        .byte   $32                             ; B6B7 32                       2
        eor     ($42,x)                         ; B6B8 41 42                    AB
        eor     ($42,x)                         ; B6BA 41 42                    AB
        eor     (L0020,x)                       ; B6BC 41 20                    A 
        rti                                     ; B6BE 40                       @

; ----------------------------------------------------------------------------
        .byte   $32                             ; B6BF 32                       2
        .byte   $43                             ; B6C0 43                       C
        bit     $23                             ; B6C1 24 23                    $#
        bit     $29                             ; B6C3 24 29                    $)
        .byte   $44                             ; B6C5 44                       D
        eor     $3A                             ; B6C6 45 3A                    E:
        lsr     $47                             ; B6C8 46 47                    FG
        .byte   $47                             ; B6CA 47                       G
        .byte   $47                             ; B6CB 47                       G
        .byte   $47                             ; B6CC 47                       G
        .byte   $47                             ; B6CD 47                       G
        .byte   $47                             ; B6CE 47                       G
        .byte   $3B                             ; B6CF 3B                       ;
        lsr     $3E                             ; B6D0 46 3E                    F>
        pha                                     ; B6D2 48                       H
        rol     $483E,x                         ; B6D3 3E 3E 48                 >>H
        rol     $4346,x                         ; B6D6 3E 46 43                 >FC
        rti                                     ; B6D9 40                       @

; ----------------------------------------------------------------------------
        .byte   $3C                             ; B6DA 3C                       <
        rti                                     ; B6DB 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B6DC 40                       @

; ----------------------------------------------------------------------------
        eor     #$40                            ; B6DD 49 40                    I@
        lsr     $46                             ; B6DF 46 46                    FF
        eor     $43                             ; B6E1 45 43                    EC
        .byte   $1A                             ; B6E3 1A                       .
        eor     $4A                             ; B6E4 45 4A                    EJ
        eor     $46                             ; B6E6 45 46                    EF
        lsr     $15                             ; B6E8 46 15                    F.
        .byte   $43                             ; B6EA 43                       C
        .byte   $34                             ; B6EB 34                       4
        .byte   $3C                             ; B6EC 3C                       <
        ora     $15,x                           ; B6ED 15 15                    ..
        .byte   $3B                             ; B6EF 3B                       ;
        .byte   $1F                             ; B6F0 1F                       .
        rol     $1C43,x                         ; B6F1 3E 43 1C                 >C.
        .byte   $3F                             ; B6F4 3F                       ?
        clc                                     ; B6F5 18                       .
        ora     $1F4B,y                         ; B6F6 19 4B 1F                 .K.
        .byte   $42                             ; B6F9 42                       B
        .byte   $1F                             ; B6FA 1F                       .
        .byte   $42                             ; B6FB 42                       B
        jmp     L1D1C                           ; B6FC 4C 1C 1D                 L..

; ----------------------------------------------------------------------------
        and     $43,x                           ; B6FF 35 43                    5C
        .byte   $47                             ; B701 47                       G
        .byte   $23                             ; B702 23                       #
        bit     $25                             ; B703 24 25                    $%
        rol     $1C                             ; B705 26 1C                    &.
        .byte   $1C                             ; B707 1C                       .
        lsr     $4D                             ; B708 46 4D                    FM
        lsr     $234D                           ; B70A 4E 4D 23                 NM#
        .byte   $4F                             ; B70D 4F                       O
        rol     $42,x                           ; B70E 36 42                    6B
        lsr     $50                             ; B710 46 50                    FP
        eor     ($50),y                         ; B712 51 50                    QP
        .byte   $52                             ; B714 52                       R
        .byte   $53                             ; B715 53                       S
        and     $5453,y                         ; B716 39 53 54                 9ST
        ora     $0E                             ; B719 05 0E                    ..
        ora     $0F                             ; B71B 05 0F                    ..
        eor     $05,x                           ; B71D 55 05                    U.
        asl     $1A43                           ; B71F 0E 43 1A                 .C.
        .byte   $12                             ; B722 12                       .
        .byte   $14                             ; B723 14                       .
        .byte   $13                             ; B724 13                       .
        .byte   $12                             ; B725 12                       .
        .byte   $14                             ; B726 14                       .
        .byte   $12                             ; B727 12                       .
        lsr     $34                             ; B728 46 34                    F4
        .byte   $3C                             ; B72A 3C                       <
        ora     $16,x                           ; B72B 15 16                    ..
        ora     $15,x                           ; B72D 15 15                    ..
        ora     $43,x                           ; B72F 15 43                    .C
        .byte   $1C                             ; B731 1C                       .
        bmi     LB74E                           ; B732 30 1A                    0.
        .byte   $3C                             ; B734 3C                       <
        .byte   $2F                             ; B735 2F                       /
        .byte   $1B                             ; B736 1B                       .
        .byte   $1A                             ; B737 1A                       .
        lsr     $36,x                           ; B738 56 36                    V6
        .byte   $1C                             ; B73A 1C                       .
        asl     $3556,x                         ; B73B 1E 56 35                 .V5
        .byte   $1F                             ; B73E 1F                       .
        asl     $4657,x                         ; B73F 1E 57 46                 .WF
        and     #$58                            ; B742 29 58                    )X
        lsr     $58                             ; B744 46 58                    FX
        .byte   $23                             ; B746 23                       #
        cli                                     ; B747 58                       X
        .byte   $54                             ; B748 54                       T
        lsr     $4E                             ; B749 46 4E                    FN
        eor     $594D,y                         ; B74B 59 4D 59                 YMY
LB74E:  lsr     $2359                           ; B74E 4E 59 23                 NY#
        .byte   $53                             ; B751 53                       S
        eor     ($50),y                         ; B752 51 50                    QP
        bvc     LB7A6                           ; B754 50 50                    PP
        .byte   $5A                             ; B756 5A                       Z
        bvc     LB765                           ; B757 50 0C                    P.
        ora     $0E                             ; B759 05 0E                    ..
        ora     $05                             ; B75B 05 05                    ..
        ora     $10                             ; B75D 05 10                    ..
        ora     $13                             ; B75F 05 13                    ..
        .byte   $14                             ; B761 14                       .
        .byte   $12                             ; B762 12                       .
        .byte   $14                             ; B763 14                       .
        .byte   $14                             ; B764 14                       .
LB765:  .byte   $14                             ; B765 14                       .
        .byte   $12                             ; B766 12                       .
        .byte   $14                             ; B767 14                       .
        asl     $15,x                           ; B768 16 15                    ..
        ora     $15,x                           ; B76A 15 15                    ..
        .byte   $3C                             ; B76C 3C                       <
        ora     $15,x                           ; B76D 15 15                    ..
        ora     $3C,x                           ; B76F 15 3C                    .<
        and     $4D3C,x                         ; B771 3D 3C 4D                 =<M
        .byte   $43                             ; B774 43                       C
        eor     $4D1B                           ; B775 4D 1B 4D                 M.M
        .byte   $1F                             ; B778 1F                       .
        .byte   $32                             ; B779 32                       2
        .byte   $1F                             ; B77A 1F                       .
        eor     $4D1F                           ; B77B 4D 1F 4D                 M.M
        .byte   $1F                             ; B77E 1F                       .
        eor     $5C5B                           ; B77F 4D 5B 5C                 M[\
        cli                                     ; B782 58                       X
        .byte   $5B                             ; B783 5B                       [
        .byte   $5C                             ; B784 5C                       \
        cli                                     ; B785 58                       X
        eor     $5E32,x                         ; B786 5D 32 5E                 ]2^
        .byte   $5F                             ; B789 5F                       _
        eor     $5F5E,y                         ; B78A 59 5E 5F                 Y^_
        rts                                     ; B78D 60                       `

; ----------------------------------------------------------------------------
        adc     ($3B,x)                         ; B78E 61 3B                    a;
        bvc     LB7E3                           ; B790 50 51                    PQ
        bvc     LB7E4                           ; B792 50 50                    PP
        .byte   $5A                             ; B794 5A                       Z
        eor     ($62),y                         ; B795 51 62                    Qb
        .byte   $3A                             ; B797 3A                       :
        ora     $0E                             ; B798 05 0E                    ..
        ora     $05                             ; B79A 05 05                    ..
        bpl     LB7AC                           ; B79C 10 0E                    ..
        .byte   $63                             ; B79E 63                       c
        jsr     L6414                           ; B79F 20 14 64                  .d
        .byte   $14                             ; B7A2 14                       .
        adc     $64                             ; B7A3 65 64                    ed
        .byte   $12                             ; B7A5 12                       .
LB7A6:  .byte   $1B                             ; B7A6 1B                       .
        .byte   $3B                             ; B7A7 3B                       ;
        ror     $67                             ; B7A8 66 67                    fg
        ora     $68,x                           ; B7AA 15 68                    .h
LB7AC:  .byte   $67                             ; B7AC 67                       g
        ora     $1F,x                           ; B7AD 15 1F                    ..
        .byte   $32                             ; B7AF 32                       2
        adc     #$6A                            ; B7B0 69 6A                    ij
        eor     $6A69                           ; B7B2 4D 69 6A                 Mij
        .byte   $4D                             ; B7B5 4D                       M
LB7B6:  .byte   $1F                             ; B7B6 1F                       .
        .byte   $3B                             ; B7B7 3B                       ;
        adc     #$6A                            ; B7B8 69 6A                    ij
        eor     $6A69                           ; B7BA 4D 69 6A                 Mij
        eor     L201F                           ; B7BD 4D 1F 20                 M. 
        .byte   $6B                             ; B7C0 6B                       k
        .byte   $53                             ; B7C1 53                       S
        .byte   $23                             ; B7C2 23                       #
        bit     $29                             ; B7C3 24 29                    $)
        jmp     (L3725)                         ; B7C5 6C 25 37                 l%7

; ----------------------------------------------------------------------------
        .byte   $6B                             ; B7C8 6B                       k
        .byte   $47                             ; B7C9 47                       G
        .byte   $47                             ; B7CA 47                       G
        .byte   $47                             ; B7CB 47                       G
        .byte   $47                             ; B7CC 47                       G
        .byte   $53                             ; B7CD 53                       S
        .byte   $23                             ; B7CE 23                       #
        jmp     (L3E6B)                         ; B7CF 6C 6B 3E                 lk>

; ----------------------------------------------------------------------------
        adc     $3E3E                           ; B7D2 6D 3E 3E                 m>>
        ror     $466F                           ; B7D5 6E 6F 46                 noF
        .byte   $6B                             ; B7D8 6B                       k
        rti                                     ; B7D9 40                       @

; ----------------------------------------------------------------------------
        bvs     LB81C                           ; B7DA 70 40                    p@
        rti                                     ; B7DC 40                       @

; ----------------------------------------------------------------------------
        eor     #$40                            ; B7DD 49 40                    I@
        lsr     $71                             ; B7DF 46 71                    Fq
        eor     $72                             ; B7E1 45 72                    Er
LB7E3:  .byte   $45                             ; B7E3 45                       E
LB7E4:  eor     $4A                             ; B7E4 45 4A                    EJ
        eor     $32                             ; B7E6 45 32                    E2
        .byte   $1B                             ; B7E8 1B                       .
        .byte   $1B                             ; B7E9 1B                       .
        .byte   $1A                             ; B7EA 1A                       .
        .byte   $1B                             ; B7EB 1B                       .
        .byte   $3C                             ; B7EC 3C                       <
        ora     $15,x                           ; B7ED 15 15                    ..
        .byte   $3B                             ; B7EF 3B                       ;
        .byte   $1F                             ; B7F0 1F                       .
        .byte   $1F                             ; B7F1 1F                       .
        .byte   $3B                             ; B7F2 3B                       ;
        .byte   $1F                             ; B7F3 1F                       .
        .byte   $1F                             ; B7F4 1F                       .
        and     $3273,x                         ; B7F5 3D 73 32                 =s2
        .byte   $1F                             ; B7F8 1F                       .
        .byte   $1F                             ; B7F9 1F                       .
        .byte   $32                             ; B7FA 32                       2
        .byte   $1F                             ; B7FB 1F                       .
        .byte   $1F                             ; B7FC 1F                       .
        .byte   $32                             ; B7FD 32                       2
        .byte   $6B                             ; B7FE 6B                       k
        .byte   $32                             ; B7FF 32                       2
        .byte   $23                             ; B800 23                       #
        .byte   $53                             ; B801 53                       S
        and     $2324,y                         ; B802 39 24 23                 9$#
        .byte   $74                             ; B805 74                       t
        adc     $76,x                           ; B806 75 76                    uv
        .byte   $77                             ; B808 77                       w
        lsr     $4E78                           ; B809 4E 78 4E                 NxN
        eor     $4D4E                           ; B80C 4D 4E 4D                 MNM
        sei                                     ; B80F 78                       x
        adc     $525A,y                         ; B810 79 5A 52                 yZR
        eor     ($50),y                         ; B813 51 50                    QP
        .byte   $5A                             ; B815 5A                       Z
        bvc     LB86A                           ; B816 50 52                    PR
        .byte   $7A                             ; B818 7A                       z
        bpl     LB82C                           ; B819 10 11                    ..
        .byte   $0E                             ; B81B 0E                       .
LB81C:  ora     $10                             ; B81C 05 10                    ..
        ora     $0F                             ; B81E 05 0F                    ..
        .byte   $7B                             ; B820 7B                       {
        .byte   $12                             ; B821 12                       .
        .byte   $13                             ; B822 13                       .
        .byte   $12                             ; B823 12                       .
        .byte   $14                             ; B824 14                       .
LB825:  .byte   $12                             ; B825 12                       .
        .byte   $14                             ; B826 14                       .
        .byte   $13                             ; B827 13                       .
        .byte   $7C                             ; B828 7C                       |
        ora     $16,x                           ; B829 15 16                    ..
        .byte   $15                             ; B82B 15                       .
LB82C:  .byte   $2B                             ; B82C 2B                       +
        bit     $1A2B                           ; B82D 2C 2B 1A                 ,+.
        adc     $173D,x                         ; B830 7D 3D 17                 }=.
        clc                                     ; B833 18                       .
        .byte   $1F                             ; B834 1F                       .
        .byte   $34                             ; B835 34                       4
        ror     $6B7F,x                         ; B836 7E 7F 6B                 ~.k
        .byte   $32                             ; B839 32                       2
        eor     ($1C,x)                         ; B83A 41 1C                    A.
        .byte   $1F                             ; B83C 1F                       .
        .byte   $1C                             ; B83D 1C                       .
        ora     $751C,x                         ; B83E 1D 1C 75                 ..u
        .byte   $74                             ; B841 74                       t
        adc     $58,x                           ; B842 75 58                    uX
        adc     $80,x                           ; B844 75 80                    u.
        sta     ($74,x)                         ; B846 81 74                    .t
        lsr     $4D4D                           ; B848 4E 4D 4D                 NMM
        rts                                     ; B84B 60                       `

; ----------------------------------------------------------------------------
        lsr     $5F5E                           ; B84C 4E 5E 5F                 N^_
        eor     $505A                           ; B84F 4D 5A 50                 MZP
        bvc     LB8A5                           ; B852 50 51                    PQ
        .byte   $5A                             ; B854 5A                       Z
        bvc     LB8B1                           ; B855 50 5A                    PZ
        bvc     LB869                           ; B857 50 10                    P.
        ora     $05                             ; B859 05 05                    ..
        asl     $8382                           ; B85B 0E 82 83                 ...
        sty     $85                             ; B85E 84 85                    ..
        .byte   $12                             ; B860 12                       .
        stx     $87                             ; B861 86 87                    ..
        .byte   $12                             ; B863 12                       .
        .byte   $12                             ; B864 12                       .
        .byte   $14                             ; B865 14                       .
        .byte   $12                             ; B866 12                       .
        .byte   $14                             ; B867 14                       .
        .byte   $3C                             ; B868 3C                       <
LB869:  .byte   $3C                             ; B869 3C                       <
LB86A:  dey                                     ; B86A 88                       .
        ora     $88,x                           ; B86B 15 88                    ..
        .byte   $89                             ; B86D 89                       .
        txa                                     ; B86E 8A                       .
        .byte   $1A                             ; B86F 1A                       .
        .byte   $1F                             ; B870 1F                       .
        .byte   $1F                             ; B871 1F                       .
        ora     $194D,y                         ; B872 19 4D 19                 .M.
        .byte   $8B                             ; B875 8B                       .
        sty     $3F32                           ; B876 8C 32 3F                 .2?
        .byte   $3F                             ; B879 3F                       ?
        ora     $1D4D,x                         ; B87A 1D 4D 1D                 .M.
        adc     #$6A                            ; B87D 69 6A                    ij
        .byte   $32                             ; B87F 32                       2
        adc     $74,x                           ; B880 75 74                    ut
        adc     $74,x                           ; B882 75 74                    ut
        cli                                     ; B884 58                       X
        adc     $75,x                           ; B885 75 75                    uu
        sta     $4D4E                           ; B887 8D 4E 4D                 .NM
        eor     $604D                           ; B88A 4D 4D 60                 MM`
        lsr     $8D4D                           ; B88D 4E 4D 8D                 NM.
        stx     $508F                           ; B890 8E 8F 50                 ..P
        bvc     LB8E6                           ; B893 50 51                    PQ
        .byte   $5A                             ; B895 5A                       Z
        bvc     LB825                           ; B896 50 8D                    P.
        bpl     LB89F                           ; B898 10 05                    ..
        ora     $05                             ; B89A 05 05                    ..
        asl     $908E                           ; B89C 0E 8E 90                 ...
LB89F:  sta     $1412                           ; B89F 8D 12 14                 ...
        stx     $91                             ; B8A2 86 91                    ..
        .byte   $12                             ; B8A4 12                       .
LB8A5:  .byte   $12                             ; B8A5 12                       .
        .byte   $14                             ; B8A6 14                       .
        sta     $883C                           ; B8A7 8D 3C 88                 .<.
        dey                                     ; B8AA 88                       .
        dey                                     ; B8AB 88                       .
        ora     $88,x                           ; B8AC 15 88                    ..
        dey                                     ; B8AE 88                       .
        .byte   $92                             ; B8AF 92                       .
        .byte   $1F                             ; B8B0 1F                       .
LB8B1:  .byte   $2F                             ; B8B1 2F                       /
        .byte   $3C                             ; B8B2 3C                       <
        clc                                     ; B8B3 18                       .
        eor     $1B18                           ; B8B4 4D 18 1B                 M..
        .byte   $1A                             ; B8B7 1A                       .
        .byte   $3F                             ; B8B8 3F                       ?
        and     $3F,x                           ; B8B9 35 3F                    5?
        .byte   $1C                             ; B8BB 1C                       .
        eor     $1F1C                           ; B8BC 4D 1C 1F                 M..
        .byte   $32                             ; B8BF 32                       2
        .byte   $43                             ; B8C0 43                       C
        .byte   $93                             ; B8C1 93                       .
        .byte   $23                             ; B8C2 23                       #
        bit     $25                             ; B8C3 24 25                    $%
        .byte   $37                             ; B8C5 37                       7
        rol     $36,x                           ; B8C6 36 36                    66
        .byte   $1F                             ; B8C8 1F                       .
        sty     $47,x                           ; B8C9 94 47                    .G
        .byte   $47                             ; B8CB 47                       G
        and     #$6C                            ; B8CC 29 6C                    )l
        jmp     L4337                           ; B8CE 4C 37 43                 L7C

; ----------------------------------------------------------------------------
        sta     $6D,x                           ; B8D1 95 6D                    .m
        rol     $3296,x                         ; B8D3 3E 96 32                 >.2
        .byte   $97                             ; B8D6 97                       .
        jmp     (L4046)                         ; B8D7 6C 46 40                 lF@

; ----------------------------------------------------------------------------
        bvs     LB91C                           ; B8DA 70 40                    p@
        rti                                     ; B8DC 40                       @

; ----------------------------------------------------------------------------
        .byte   $53                             ; B8DD 53                       S
        .byte   $23                             ; B8DE 23                       #
        .byte   $44                             ; B8DF 44                       D
        lsr     L0040                           ; B8E0 46 40                    F@
        bvs     LB924                           ; B8E2 70 40                    p@
        rti                                     ; B8E4 40                       @

; ----------------------------------------------------------------------------
        tya                                     ; B8E5 98                       .
LB8E6:  sta     $1F9A,y                         ; B8E6 99 9A 1F                 ...
        .byte   $9B                             ; B8E9 9B                       .
        .byte   $9C                             ; B8EA 9C                       .
        .byte   $9B                             ; B8EB 9B                       .
        .byte   $9B                             ; B8EC 9B                       .
        sta     $9E9B,x                         ; B8ED 9D 9B 9E                 ...
        lsr     $88                             ; B8F0 46 88                    F.
        dey                                     ; B8F2 88                       .
        dey                                     ; B8F3 88                       .
        ora     $1B17,y                         ; B8F4 19 17 1B                 ...
        .byte   $9F                             ; B8F7 9F                       .
        .byte   $1F                             ; B8F8 1F                       .
        and     $3D1B,x                         ; B8F9 3D 1B 3D                 =.=
        ora     $1F41,x                         ; B8FC 1D 41 1F                 .A.
        .byte   $8D,$54,$A0                     ; B8FF 8D 54 A0
        lda     (L00A0,x)                       ; B902 A1 A0                    ..
        ldx     #$A3                            ; B904 A2 A3                    ..
        ldy     $A5                             ; B906 A4 A5                    ..
        lsr     $A6,x                           ; B908 56 A6                    V.
        .byte   $A7                             ; B90A A7                       .
        tay                                     ; B90B A8                       .
        lda     #$05                            ; B90C A9 05                    ..
        ora     $05                             ; B90E 05 05                    ..
        .byte   $1F                             ; B910 1F                       .
        .byte   $0B                             ; B911 0B                       .
        .byte   $0C                             ; B912 0C                       .
        ora     $0B                             ; B913 05 0B                    ..
        ora     $1B                             ; B915 05 1B                    ..
        and     $1054,x                         ; B917 3D 54 10                 =T.
        ora     ($05),y                         ; B91A 11 05                    ..
LB91C:  bpl     LB95B                           ; B91C 10 3D                    .=
        .byte   $43                             ; B91E 43                       C
        lsr     $56                             ; B91F 46 56                    FV
        .byte   $12                             ; B921 12                       .
        .byte   $13                             ; B922 13                       .
        .byte   $14                             ; B923 14                       .
LB924:  .byte   $3C                             ; B924 3C                       <
        .byte   $32                             ; B925 32                       2
        bmi     LB95A                           ; B926 30 32                    02
        .byte   $43                             ; B928 43                       C
        ora     $16,x                           ; B929 15 16                    ..
        .byte   $1A                             ; B92B 1A                       .
        .byte   $43                             ; B92C 43                       C
        .byte   $4B                             ; B92D 4B                       K
        .byte   $1C                             ; B92E 1C                       .
        .byte   $7F                             ; B92F 7F                       .
        .byte   $1F                             ; B930 1F                       .
        tax                                     ; B931 AA                       .
        .byte   $3C                             ; B932 3C                       <
        .byte   $4B                             ; B933 4B                       K
        bmi     LB96B                           ; B934 30 35                    05
        .byte   $36                             ; B936 36                       6
LB937:  .byte   $1C                             ; B937 1C                       .
        .byte   $1F                             ; B938 1F                       .
        sta     $3556                           ; B939 8D 56 35                 .V5
        .byte   $1C                             ; B93C 1C                       .
        rol     $36,x                           ; B93D 36 36                    66
        rol     $A1,x                           ; B93F 36 A1                    6.
        ldy     #$AB                            ; B941 A0 AB                    ..
        ldy     LACA4                           ; B943 AC A4 AC                 ...
        ldy     $AC                             ; B946 A4 AC                    ..
        lda     $0506                           ; B948 AD 06 05                 ...
        php                                     ; B94B 08                       .
        ora     $05                             ; B94C 05 05                    ..
        ora     $08                             ; B94E 05 08                    ..
        .byte   $3C                             ; B950 3C                       <
        and     $0C05,x                         ; B951 3D 05 0C                 =..
        ora     $05                             ; B954 05 05                    ..
        .byte   $0B                             ; B956 0B                       .
        .byte   $0C                             ; B957 0C                       .
        lsr     $32                             ; B958 46 32                    F2
LB95A:  .byte   $3C                             ; B95A 3C                       <
LB95B:  and     $0505,x                         ; B95B 3D 05 05                 =..
        bpl     LB971                           ; B95E 10 11                    ..
        .byte   $33                             ; B960 33                       3
        .byte   $32                             ; B961 32                       2
        ror     $1B32,x                         ; B962 7E 32 1B                 ~2.
        .byte   $1A                             ; B965 1A                       .
        .byte   $3C                             ; B966 3C                       <
        .byte   $1A                             ; B967 1A                       .
        .byte   $1C                             ; B968 1C                       .
        .byte   $1E                             ; B969 1E                       .
        .byte   $1D                             ; B96A 1D                       .
LB96B:  .byte   $3A                             ; B96B 3A                       :
        ror     $1F3B,x                         ; B96C 7E 3B 1F                 ~;.
        .byte   $34                             ; B96F 34                       4
        .byte   $37                             ; B970 37                       7
LB971:  .byte   $42                             ; B971 42                       B
        .byte   $37                             ; B972 37                       7
        asl     $341D,x                         ; B973 1E 1D 34                 ..4
        .byte   $33                             ; B976 33                       3
        .byte   $1C                             ; B977 1C                       .
        eor     ($32,x)                         ; B978 41 32                    A2
        eor     ($36,x)                         ; B97A 41 36                    A6
        rol     $1C,x                           ; B97C 36 1C                    6.
        .byte   $1C                             ; B97E 1C                       .
        rol     $AE,x                           ; B97F 36 AE                    6.
        ldy     #$A1                            ; B981 A0 A1                    ..
        .byte   $AF                             ; B983 AF                       .
        bcs     LB937                           ; B984 B0 B1                    ..
        .byte   $B2                             ; B986 B2                       .
        .byte   $3A                             ; B987 3A                       :
        ora     $21                             ; B988 05 21                    .!
        .byte   $04                             ; B98A 04                       .
        ora     $05                             ; B98B 05 05                    ..
        php                                     ; B98D 08                       .
        .byte   $B3                             ; B98E B3                       .
        jsr     L0B05                           ; B98F 20 05 0B                  ..
        ora     $09                             ; B992 05 09                    ..
        .byte   $0B                             ; B994 0B                       .
        .byte   $0C                             ; B995 0C                       .
        ora     $32                             ; B996 05 32                    .2
        ora     $10                             ; B998 05 10                    ..
        ora     $0E                             ; B99A 05 0E                    ..
LB99C:  bpl     LB9AF                           ; B99C 10 11                    ..
        ora     $3B                             ; B99E 05 3B                    .;
        .byte   $1B                             ; B9A0 1B                       .
        .byte   $1A                             ; B9A1 1A                       .
        .byte   $14                             ; B9A2 14                       .
        .byte   $12                             ; B9A3 12                       .
        .byte   $12                             ; B9A4 12                       .
        .byte   $13                             ; B9A5 13                       .
        .byte   $14                             ; B9A6 14                       .
        .byte   $3A                             ; B9A7 3A                       :
        .byte   $3F                             ; B9A8 3F                       ?
        ldy     $3C,x                           ; B9A9 B4 3C                    .<
        and     $1615,x                         ; B9AB 3D 15 16                 =..
        .byte   $15                             ; B9AE 15                       .
LB9AF:  jsr     LB537                           ; B9AF 20 37 B5                  7.
        .byte   $3F                             ; B9B2 3F                       ?
        .byte   $7F                             ; B9B3 7F                       .
        .byte   $3C                             ; B9B4 3C                       <
        .byte   $1A                             ; B9B5 1A                       .
        rol     $413A,x                         ; B9B6 3E 3A 41                 >:A
        .byte   $32                             ; B9B9 32                       2
        .byte   $57                             ; B9BA 57                       W
        .byte   $6C                             ; B9BB 6C                       l
        .byte   $1F                             ; B9BC 1F                       .
LB9BD:  jsr     $2040                           ; B9BD 20 40 20                  @ 
        .byte   $54                             ; B9C0 54                       T
        .byte   $53                             ; B9C1 53                       S
        and     $2944,y                         ; B9C2 39 44 29                 9D)
        .byte   $53                             ; B9C5 53                       S
        .byte   $37                             ; B9C6 37                       7
        .byte   $3B                             ; B9C7 3B                       ;
        .byte   $1F                             ; B9C8 1F                       .
        .byte   $47                             ; B9C9 47                       G
        .byte   $47                             ; B9CA 47                       G
        .byte   $47                             ; B9CB 47                       G
        .byte   $47                             ; B9CC 47                       G
        .byte   $47                             ; B9CD 47                       G
        .byte   $47                             ; B9CE 47                       G
LB9CF:  .byte   $53                             ; B9CF 53                       S
        .byte   $1F                             ; B9D0 1F                       .
        rol     $3E6D,x                         ; B9D1 3E 6D 3E                 >m>
        rol     LB648,x                         ; B9D4 3E 48 B6                 >H.
LB9D7:  .byte   $B7                             ; B9D7 B7                       .
        .byte   $43                             ; B9D8 43                       C
        rti                                     ; B9D9 40                       @

; ----------------------------------------------------------------------------
        bvs     LBA1C                           ; B9DA 70 40                    p@
        rti                                     ; B9DC 40                       @

; ----------------------------------------------------------------------------
        eor     #$96                            ; B9DD 49 96                    I.
        and     $401F,x                         ; B9DF 3D 1F 40                 =.@
        bvs     LB99C                           ; B9E2 70 B8                    p.
        sta     ($49),y                         ; B9E4 91 49                    .I
        rti                                     ; B9E6 40                       @

; ----------------------------------------------------------------------------
        .byte   $3B                             ; B9E7 3B                       ;
LB9E8:  .byte   $1F                             ; B9E8 1F                       .
        rti                                     ; B9E9 40                       @

; ----------------------------------------------------------------------------
        bvs     LBA2A                           ; B9EA 70 3E                    p>
        rol     $4049,x                         ; B9EC 3E 49 40                 >I@
        .byte   $44                             ; B9EF 44                       D
        .byte   $1F                             ; B9F0 1F                       .
        rti                                     ; B9F1 40                       @

; ----------------------------------------------------------------------------
        bvs     LBA34                           ; B9F2 70 40                    p@
        rti                                     ; B9F4 40                       @

; ----------------------------------------------------------------------------
        eor     #$B6                            ; B9F5 49 B6                    I.
        .byte   $B7                             ; B9F7 B7                       .
        lsr     L0040,x                         ; B9F8 56 40                    V@
        bvs     LBA3C                           ; B9FA 70 40                    p@
        rti                                     ; B9FC 40                       @

; ----------------------------------------------------------------------------
        eor     #$B8                            ; B9FD 49 B8                    I.
        sta     ($43),y                         ; B9FF 91 43                    .C
        rti                                     ; BA01 40                       @

; ----------------------------------------------------------------------------
        bvs     LB9BD                           ; BA02 70 B9                    p.
        rti                                     ; BA04 40                       @

; ----------------------------------------------------------------------------
        eor     #$BA                            ; BA05 49 BA                    I.
        .byte   $1A                             ; BA07 1A                       .
        .byte   $1F                             ; BA08 1F                       .
        lda     LBB70,y                         ; BA09 B9 70 BB                 .p.
        rti                                     ; BA0C 40                       @

; ----------------------------------------------------------------------------
        eor     #$40                            ; BA0D 49 40                    I@
        .byte   $3B                             ; BA0F 3B                       ;
        .byte   $1F                             ; BA10 1F                       .
        .byte   $BB                             ; BA11 BB                       .
        bvs     LB9CF                           ; BA12 70 BB                    p.
        lda     $4049,y                         ; BA14 B9 49 40                 .I@
LBA17:  jsr     LBC43                           ; BA17 20 43 BC                  C.
LBA1A:  bvs     LB9D7                           ; BA1A 70 BB                    p.
LBA1C:  .byte   $BB                             ; BA1C BB                       .
        eor     #$B9                            ; BA1D 49 B9                    I.
        .byte   $3A                             ; BA1F 3A                       :
        .byte   $1F                             ; BA20 1F                       .
        lda     LBB70,y                         ; BA21 B9 70 BB                 .p.
        .byte   $BB                             ; BA24 BB                       .
        eor     #$BB                            ; BA25 49 BB                    I.
        .byte   $32                             ; BA27 32                       2
        .byte   $43                             ; BA28 43                       C
        .byte   $BB                             ; BA29 BB                       .
LBA2A:  bvs     LB9E8                           ; BA2A 70 BC                    p.
        .byte   $BB                             ; BA2C BB                       .
        eor     #$BB                            ; BA2D 49 BB                    I.
        .byte   $3B                             ; BA2F 3B                       ;
        .byte   $54                             ; BA30 54                       T
        .byte   $BB                             ; BA31 BB                       .
        bvs     LBA74                           ; BA32 70 40                    p@
LBA34:  .byte   $BB                             ; BA34 BB                       .
        eor     #$BB                            ; BA35 49 BB                    I.
        jsr     LBD56                           ; BA37 20 56 BD                  V.
        bvs     LBA79                           ; BA3A 70 3D                    p=
LBA3C:  ldx     $3CBF,y                         ; BA3C BE BF 3C                 ..<
        .byte   $32                             ; BA3F 32                       2
        .byte   $43                             ; BA40 43                       C
        .byte   $BB                             ; BA41 BB                       .
        bvs     LBA76                           ; BA42 70 32                    p2
        cpy     #$C1                            ; BA44 C0 C1                    ..
        .byte   $C2                             ; BA46 C2                       .
        .byte   $C3                             ; BA47 C3                       .
        .byte   $1F                             ; BA48 1F                       .
        .byte   $BB                             ; BA49 BB                       .
        bvs     LBA9F                           ; BA4A 70 53                    pS
        cpy     $C5                             ; BA4C C4 C5                    ..
        sec                                     ; BA4E 38                       8
        .byte   $44                             ; BA4F 44                       D
        .byte   $43                             ; BA50 43                       C
        .byte   $BB                             ; BA51 BB                       .
        bvs     LBA1A                           ; BA52 70 C6                    p.
        dec     $6E                             ; BA54 C6 6E                    .n
        dec     $C6                             ; BA56 C6 C6                    ..
        .byte   $43                             ; BA58 43                       C
        .byte   $BB                             ; BA59 BB                       .
        bvs     LBA17                           ; BA5A 70 BB                    p.
        .byte   $BB                             ; BA5C BB                       .
        eor     #$BB                            ; BA5D 49 BB                    I.
        .byte   $BB                             ; BA5F BB                       .
        .byte   $1F                             ; BA60 1F                       .
        .byte   $1A                             ; BA61 1A                       .
        ldx     LBDBF,y                         ; BA62 BE BF BD                 ...
        eor     #$BB                            ; BA65 49 BB                    I.
        .byte   $BB                             ; BA67 BB                       .
        .byte   $3F                             ; BA68 3F                       ?
        .byte   $4B                             ; BA69 4B                       K
        .byte   $C7                             ; BA6A C7                       .
        iny                                     ; BA6B C8                       .
        cmp     #$BF                            ; BA6C C9 BF                    ..
        .byte   $BB                             ; BA6E BB                       .
        .byte   $BB                             ; BA6F BB                       .
        rol     $35,x                           ; BA70 36 35                    65
        dex                                     ; BA72 CA                       .
        .byte   $CB                             ; BA73 CB                       .
LBA74:  .byte   $C7                             ; BA74 C7                       .
        iny                                     ; BA75 C8                       .
LBA76:  cpy     $36CD                           ; BA76 CC CD 36                 ..6
LBA79:  rol     $CE,x                           ; BA79 36 CE                    6.
        .byte   $CF                             ; BA7B CF                       .
        dex                                     ; BA7C CA                       .
        .byte   $CB                             ; BA7D CB                       .
        .byte   $1F                             ; BA7E 1F                       .
        asl     $2637,x                         ; BA7F 1E 37 26                 .7&
        dex                                     ; BA82 CA                       .
        .byte   $CB                             ; BA83 CB                       .
        dec     $CACF                           ; BA84 CE CF CA                 ...
        .byte   $CB                             ; BA87 CB                       .
        and     $C42A,y                         ; BA88 39 2A C4                 9*.
        cmp     $C4                             ; BA8B C5 C4                    ..
        cmp     $C4                             ; BA8D C5 C4                    ..
        cmp     $6E                             ; BA8F C5 6E                    .n
        dec     $C6                             ; BA91 C6 C6                    ..
        ror     $96D0                           ; BA93 6E D0 96                 n..
        cmp     ($96),y                         ; BA96 D1 96                    ..
        eor     #$BD                            ; BA98 49 BD                    I.
        .byte   $D2                             ; BA9A D2                       .
        .byte   $D3                             ; BA9B D3                       .
        .byte   $D4                             ; BA9C D4                       .
        cmp     $D6,x                           ; BA9D D5 D6                    ..
LBA9F:  cmp     $B8,x                           ; BA9F D5 B8                    ..
        sta     ($75),y                         ; BAA1 91 75                    .u
        .byte   $C3                             ; BAA3 C3                       .
        .byte   $C2                             ; BAA4 C2                       .
        .byte   $C3                             ; BAA5 C3                       .
        .byte   $23                             ; BAA6 23                       #
        .byte   $74                             ; BAA7 74                       t
        .byte   $D7                             ; BAA8 D7                       .
        cld                                     ; BAA9 D8                       .
        cld                                     ; BAAA D8                       .
        .byte   $53                             ; BAAB 53                       S
        sec                                     ; BAAC 38                       8
        .byte   $44                             ; BAAD 44                       D
        ror     $D93E                           ; BAAE 6E 3E D9                 n>.
        cmp     $DBDA                           ; BAB1 CD DA DB                 ...
        .byte   $DC                             ; BAB4 DC                       .
        .byte   $DB                             ; BAB5 DB                       .
        cmp     $33D5,y                         ; BAB6 D9 D5 33                 ..3
        asl     $C1C0,x                         ; BAB9 1E C0 C1                 ...
        .byte   $C0                             ; BABC C0                       .
LBABD:  cmp     ($33,x)                         ; BABD C1 33                    .3
        asl     $5341,x                         ; BABF 1E 41 53                 .AS
        cpy     $C5                             ; BAC2 C4 C5                    ..
        cpy     $C5                             ; BAC4 C4 C5                    ..
        and     $233B,y                         ; BAC6 39 3B 23                 9;#
        ror     $C6C6                           ; BAC9 6E C6 C6                 n..
        ror     $9696                           ; BACC 6E 96 96                 n..
        .byte   $32                             ; BACF 32                       2
        dec     $49                             ; BAD0 C6 49                    .I
        lda     $49BB,x                         ; BAD2 BD BB 49                 ..I
        rti                                     ; BAD5 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; BAD6 40                       @

; ----------------------------------------------------------------------------
        .byte   $3B                             ; BAD7 3B                       ;
        .byte   $BB                             ; BAD8 BB                       .
        eor     #$BB                            ; BAD9 49 BB                    I.
        .byte   $BB                             ; BADB BB                       .
        eor     #$D5                            ; BADC 49 D5                    I.
        rti                                     ; BADE 40                       @

; ----------------------------------------------------------------------------
        .byte   $3A                             ; BADF 3A                       :
        .byte   $BB                             ; BAE0 BB                       .
        eor     #$BB                            ; BAE1 49 BB                    I.
        .byte   $BB                             ; BAE3 BB                       .
        cmp     $4032,y                         ; BAE4 D9 32 40                 .2@
        .byte   $3B                             ; BAE7 3B                       ;
        .byte   $BB                             ; BAE8 BB                       .
        eor     #$BB                            ; BAE9 49 BB                    I.
        cmp     $3A54,x                         ; BAEB DD 54 3A                 .T:
        rti                                     ; BAEE 40                       @

; ----------------------------------------------------------------------------
        jsr     LD3CC                           ; BAEF 20 CC D3                  ..
        cpy     $334B                           ; BAF2 CC 4B 33                 .K3
        .byte   $32                             ; BAF5 32                       2
        rti                                     ; BAF6 40                       @

; ----------------------------------------------------------------------------
        .byte   $32                             ; BAF7 32                       2
        .byte   $1F                             ; BAF8 1F                       .
        jsr     L353F                           ; BAF9 20 3F 35                  ?5
        eor     ($32,x)                         ; BAFC 41 32                    A2
        rti                                     ; BAFE 40                       @

; ----------------------------------------------------------------------------
        .byte   $32                             ; BAFF 32                       2
        .byte   $43                             ; BB00 43                       C
        asl     $6C37,x                         ; BB01 1E 37 6C                 .7l
        .byte   $43                             ; BB04 43                       C
        .byte   $53                             ; BB05 53                       S
        rti                                     ; BB06 40                       @

; ----------------------------------------------------------------------------
        .byte   $32                             ; BB07 32                       2
        .byte   $3F                             ; BB08 3F                       ?
        rol     $41,x                           ; BB09 36 41                    6A
        .byte   $44                             ; BB0B 44                       D
        .byte   $23                             ; BB0C 23                       #
        stx     L0040,y                         ; BB0D 96 40                    .@
        .byte   $3A                             ; BB0F 3A                       :
        rol     $37,x                           ; BB10 36 37                    67
        .byte   $54                             ; BB12 54                       T
        stx     $6E,y                           ; BB13 96 6E                    .n
        rti                                     ; BB15 40                       @

; ----------------------------------------------------------------------------
        .byte   $3C                             ; BB16 3C                       <
        .byte   $32                             ; BB17 32                       2
        .byte   $37                             ; BB18 37                       7
        jmp     (L9B43)                         ; BB19 6C 43 9B                 lC.

; ----------------------------------------------------------------------------
        .byte   $1B                             ; BB1C 1B                       .
        clc                                     ; BB1D 18                       .
        .byte   $33                             ; BB1E 33                       3
        asl     $3225,x                         ; BB1F 1E 25 32                 .%2
        .byte   $23                             ; BB22 23                       #
        ora     $29,x                           ; BB23 15 29                    .)
        lda     $1C,x                           ; BB25 B5 1C                    ..
        rol     $54,x                           ; BB27 36 54                    6T
        .byte   $53                             ; BB29 53                       S
        dec     $DEDE,x                         ; BB2A DE DE DE                 ...
        .byte   $44                             ; BB2D 44                       D
        .byte   $57                             ; BB2E 57                       W
        rol     $56                             ; BB2F 26 56                    &V
        stx     $DF,y                           ; BB31 96 DF                    ..
        eor     $96E0                           ; BB33 4D E0 96                 M..
        .byte   $54                             ; BB36 54                       T
        .byte   $4F                             ; BB37 4F                       O
        .byte   $1F                             ; BB38 1F                       .
        rol     $DF,x                           ; BB39 36 DF                    6.
        eor     $36E0                           ; BB3B 4D E0 36                 M.6
        .byte   $1F                             ; BB3E 1F                       .
        .byte   $32                             ; BB3F 32                       2
        .byte   $54                             ; BB40 54                       T
        sbc     ($E2,x)                         ; BB41 E1 E2                    ..
        dec     $E1E3,x                         ; BB43 DE E3 E1                 ...
        .byte   $1F                             ; BB46 1F                       .
        .byte   $20                             ; BB47 20                        
        .byte   $1F                             ; BB48 1F                       .
LBB49:  rol     $DF,x                           ; BB49 36 DF                    6.
        eor     $E5E4                           ; BB4B 4D E4 E5                 M..
        .byte   $1F                             ; BB4E 1F                       .
        .byte   $3A                             ; BB4F 3A                       :
        .byte   $43                             ; BB50 43                       C
        sbc     $E6                             ; BB51 E5 E6                    ..
        eor     $3DE0                           ; BB53 4D E0 3D                 M.=
        .byte   $54                             ; BB56 54                       T
        .byte   $3B                             ; BB57 3B                       ;
        .byte   $1F                             ; BB58 1F                       .
        and     $DEE2,x                         ; BB59 3D E2 DE                 =..
        .byte   $E3                             ; BB5C E3                       .
        .byte   $32                             ; BB5D 32                       2
        .byte   $43                             ; BB5E 43                       C
        .byte   $7F                             ; BB5F 7F                       .
        bmi     LBB9C                           ; BB60 30 3A                    0:
        .byte   $DF                             ; BB62 DF                       .
        cpx     $36                             ; BB63 E4 36                    .6
        .byte   $32                             ; BB65 32                       2
        ror     $1C1C,x                         ; BB66 7E 1C 1C                 ~..
        .byte   $3B                             ; BB69 3B                       ;
        sbc     $E7                             ; BB6A E5 E7                    ..
        inx                                     ; BB6C E8                       .
        .byte   $3A                             ; BB6D 3A                       :
        and     $36,x                           ; BB6E 35 36                    56
LBB70:  rol     $34,x                           ; BB70 36 34                    64
        .byte   $1B                             ; BB72 1B                       .
        dec     $32E3,x                         ; BB73 DE E3 32                 ..2
        rol     $36,x                           ; BB76 36 36                    66
        rol     $1C,x                           ; BB78 36 1C                    6.
        .byte   $1F                             ; BB7A 1F                       .
        eor     $32E0                           ; BB7B 4D E0 32                 M.2
        rol     $36,x                           ; BB7E 36 36                    66
        rol     $26,x                           ; BB80 36 26                    6&
        .byte   $1F                             ; BB82 1F                       .
        eor     $3AE0                           ; BB83 4D E0 3A                 M.:
        .byte   $37                             ; BB86 37                       7
        rol     $36,x                           ; BB87 36 36                    66
        .byte   $4F                             ; BB89 4F                       O
        and     #$DE                            ; BB8A 29 DE                    ).
        .byte   $E3                             ; BB8C E3                       .
        .byte   $32                             ; BB8D 32                       2
        eor     ($37,x)                         ; BB8E 41 37                    A7
        .byte   $37                             ; BB90 37                       7
        .byte   $3B                             ; BB91 3B                       ;
        stx     $4D,y                           ; BB92 96 4D                    .M
        cpx     $32                             ; BB94 E4 32                    .2
        .byte   $54                             ; BB96 54                       T
        lda     $25,x                           ; BB97 B5 25                    .%
        .byte   $32                             ; BB99 32                       2
        .byte   $DF                             ; BB9A DF                       .
        .byte   $E9                             ; BB9B E9                       .
LBB9C:  nop                                     ; BB9C EA                       .
        .byte   $3A                             ; BB9D 3A                       :
        lsr     $3A,x                           ; BB9E 56 3A                    V:
        .byte   $1F                             ; BBA0 1F                       .
        .byte   $3B                             ; BBA1 3B                       ;
        inc     $E4                             ; BBA2 E6 E4                    ..
        sbc     $3B                             ; BBA4 E5 3B                    .;
        .byte   $1F                             ; BBA6 1F                       .
        .byte   $3B                             ; BBA7 3B                       ;
        .byte   $43                             ; BBA8 43                       C
        .byte   $3B                             ; BBA9 3B                       ;
        .byte   $E2                             ; BBAA E2                       .
        .byte   $E3                             ; BBAB E3                       .
        .byte   $1B                             ; BBAC 1B                       .
        .byte   $3B                             ; BBAD 3B                       ;
        ror     $1F1E,x                         ; BBAE 7E 1E 1F                 ~..
        .byte   $3B                             ; BBB1 3B                       ;
        .byte   $DF                             ; BBB2 DF                       .
        cpx     #$54                            ; BBB3 E0 54                    .T
        .byte   $34                             ; BBB5 34                       4
        ora     $1F36,x                         ; BBB6 1D 36 1F                 .6.
        .byte   $32                             ; BBB9 32                       2
        inc     $E4                             ; BBBA E6 E4                    ..
        .byte   $1F                             ; BBBC 1F                       .
        .byte   $1C                             ; BBBD 1C                       .
        rol     $36,x                           ; BBBE 36 36                    66
        .byte   $54                             ; BBC0 54                       T
        .byte   $53                             ; BBC1 53                       S
        .byte   $47                             ; BBC2 47                       G
        .byte   $47                             ; BBC3 47                       G
        .byte   $43                             ; BBC4 43                       C
        .byte   $37                             ; BBC5 37                       7
        rol     $42,x                           ; BBC6 36 42                    6B
        .byte   $1F                             ; BBC8 1F                       .
        ror     $D83E                           ; BBC9 6E 3E D8                 n>.
        .byte   $43                             ; BBCC 43                       C
        lda     $37,x                           ; BBCD B5 37                    .7
        .byte   $3B                             ; BBCF 3B                       ;
        .byte   $43                             ; BBD0 43                       C
        eor     #$40                            ; BBD1 49 40                    I@
        .byte   $BB                             ; BBD3 BB                       .
        .byte   $43                             ; BBD4 43                       C
        .byte   $32                             ; BBD5 32                       2
        eor     ($3A,x)                         ; BBD6 41 3A                    A:
        .byte   $43                             ; BBD8 43                       C
        eor     #$B6                            ; BBD9 49 B6                    I.
        .byte   $B7                             ; BBDB B7                       .
        and     #$53                            ; BBDC 29 53                    )S
        and     #$44                            ; BBDE 29 44                    )D
        .byte   $1F                             ; BBE0 1F                       .
        eor     #$96                            ; BBE1 49 96                    I.
        dec     $6E                             ; BBE3 C6 6E                    .n
        dec     $C6                             ; BBE5 C6 C6                    ..
        ror     $4943                           ; BBE7 6E 43 49                 nCI
        rti                                     ; BBEA 40                       @

; ----------------------------------------------------------------------------
        .byte   $BB                             ; BBEB BB                       .
        eor     #$BB                            ; BBEC 49 BB                    I.
        .byte   $BB                             ; BBEE BB                       .
        eor     #$1F                            ; BBEF 49 1F                    I.
        ldx     $C9BF,y                         ; BBF1 BE BF C9                 ...
        .byte   $BF                             ; BBF4 BF                       .
        ldx     $C9BF,y                         ; BBF5 BE BF C9                 ...
        .byte   $1F                             ; BBF8 1F                       .
        .byte   $CE                             ; BBF9 CE                       .
LBBFA:  .byte   $CF                             ; BBFA CF                       .
        dec     $CECF                           ; BBFB CE CF CE                 ...
        .byte   $CF                             ; BBFE CF                       .
        dec     $5325                           ; BBFF CE 25 53                 .%S
        and     $2924,y                         ; BC02 39 24 29                 9$)
        bit     $23                             ; BC05 24 23                    $#
        .byte   $3B                             ; BC07 3B                       ;
        .byte   $43                             ; BC08 43                       C
        stx     $6E,y                           ; BC09 96 6E                    .n
        dec     $C6                             ; BC0B C6 C6                    ..
        .byte   $6E                             ; BC0D 6E                       n
        .byte   $96                             ; BC0E 96                       .
LBC0F:  .byte   $32                             ; BC0F 32                       2
        .byte   $1F                             ; BC10 1F                       .
        lda     LBB49,y                         ; BC11 B9 49 BB                 .I.
        .byte   $BB                             ; BC14 BB                       .
        eor     #$B9                            ; BC15 49 B9                    I.
        .byte   $3B                             ; BC17 3B                       ;
        and     #$BB                            ; BC18 29 BB                    ).
        eor     #$BB                            ; BC1A 49 BB                    I.
        .byte   $BB                             ; BC1C BB                       .
        .byte   $1A                             ; BC1D 1A                       .
        .byte   $BB                             ; BC1E BB                       .
        .byte   $32                             ; BC1F 32                       2
        stx     $BB,y                           ; BC20 96 BB                    ..
LBC22:  eor     #$BB                            ; BC22 49 BB                    I.
        .byte   $1B                             ; BC24 1B                       .
        .byte   $32                             ; BC25 32                       2
        .byte   $BB                             ; BC26 BB                       .
        .byte   $32                             ; BC27 32                       2
        rti                                     ; BC28 40                       @

; ----------------------------------------------------------------------------
        ldy     $1A1B,x                         ; BC29 BC 1B 1A                 ...
        .byte   $43                             ; BC2C 43                       C
LBC2D:  .byte   $32                             ; BC2D 32                       2
        ldy     LBF3A,x                         ; BC2E BC 3A BF                 .:.
        .byte   $3D                             ; BC31 3D                       =
        .byte   $43                             ; BC32 43                       C
LBC33:  .byte   $32                             ; BC33 32                       2
        .byte   $1F                             ; BC34 1F                       .
        .byte   $32                             ; BC35 32                       2
        rti                                     ; BC36 40                       @

; ----------------------------------------------------------------------------
        .byte   $32                             ; BC37 32                       2
        .byte   $CF                             ; BC38 CF                       .
        .byte   $32                             ; BC39 32                       2
        .byte   $1F                             ; BC3A 1F                       .
        .byte   $32                             ; BC3B 32                       2
        lsr     $32,x                           ; BC3C 56 32                    V2
        rti                                     ; BC3E 40                       @

; ----------------------------------------------------------------------------
        .byte   $32                             ; BC3F 32                       2
        cmp     $53                             ; BC40 C5 53                    .S
        .byte   $23                             ; BC42 23                       #
LBC43:  .byte   $53                             ; BC43 53                       S
        and     #$44                            ; BC44 29 44                    )D
        rti                                     ; BC46 40                       @

; ----------------------------------------------------------------------------
        .byte   $3B                             ; BC47 3B                       ;
LBC48:  .byte   $54                             ; BC48 54                       T
        stx     $EB,y                           ; BC49 96 EB                    ..
        dec     $C6                             ; BC4B C6 C6                    ..
LBC4D:  ror     $3240                           ; BC4D 6E 40 32                 n@2
        .byte   $43                             ; BC50 43                       C
        rti                                     ; BC51 40                       @

; ----------------------------------------------------------------------------
        bvs     LBC0F                           ; BC52 70 BB                    p.
        .byte   $BB                             ; BC54 BB                       .
        eor     #$40                            ; BC55 49 40                    I@
LBC57:  .byte   $3A                             ; BC57 3A                       :
        .byte   $43                             ; BC58 43                       C
        lda     LBB70,y                         ; BC59 B9 70 BB                 .p.
        .byte   $BB                             ; BC5C BB                       .
        .byte   $1A                             ; BC5D 1A                       .
        .byte   $1B                             ; BC5E 1B                       .
LBC5F:  .byte   $3A                             ; BC5F 3A                       :
LBC60:  .byte   $43                             ; BC60 43                       C
        .byte   $BB                             ; BC61 BB                       .
        bvs     LBC2D                           ; BC62 70 C9                    p.
        .byte   $BF                             ; BC64 BF                       .
        .byte   $32                             ; BC65 32                       2
        .byte   $7E                             ; BC66 7E                       ~
        .byte   $3B                             ; BC67 3B                       ;
LBC68:  .byte   $1F                             ; BC68 1F                       .
        .byte   $BB                             ; BC69 BB                       .
        bvs     LBC33                           ; BC6A 70 C7                    p.
        iny                                     ; BC6C C8                       .
        .byte   $34                             ; BC6D 34                       4
        ora     $433B,x                         ; BC6E 1D 3B 43                 .;C
        .byte   $BB                             ; BC71 BB                       .
        bvs     LBC60                           ; BC72 70 EC                    p.
        sbc     $4C1C                           ; BC74 ED 1C 4C                 ..L
        .byte   $32                             ; BC77 32                       2
        .byte   $1F                             ; BC78 1F                       .
        lda     $CE70,x                         ; BC79 BD 70 CE                 .p.
        .byte   $CF                             ; BC7C CF                       .
        .byte   $42                             ; BC7D 42                       B
        .byte   $97                             ; BC7E 97                       .
        .byte   $32                             ; BC7F 32                       2
        .byte   $1F                             ; BC80 1F                       .
        .byte   $BB                             ; BC81 BB                       .
        bvs     LBC48                           ; BC82 70 C4                    p.
        cmp     $24                             ; BC84 C5 24                    .$
        and     #$3B                            ; BC86 29 3B                    );
        .byte   $54                             ; BC88 54                       T
        .byte   $BB                             ; BC89 BB                       .
        bvs     LBC22                           ; BC8A 70 96                    p.
        dec     $6E                             ; BC8C C6 6E                    .n
        stx     $32,y                           ; BC8E 96 32                    .2
        .byte   $23                             ; BC90 23                       #
        .byte   $BB                             ; BC91 BB                       .
        bvs     LBC4D                           ; BC92 70 B9                    p.
        .byte   $BB                             ; BC94 BB                       .
        eor     #$40                            ; BC95 49 40                    I@
        .byte   $3A                             ; BC97 3A                       :
        cmp     #$BF                            ; BC98 C9 BF                    ..
        bvs     LBC57                           ; BC9A 70 BB                    p.
        .byte   $BB                             ; BC9C BB                       .
        eor     #$40                            ; BC9D 49 40                    I@
        .byte   $32                             ; BC9F 32                       2
        .byte   $C7                             ; BCA0 C7                       .
        iny                                     ; BCA1 C8                       .
        bvs     LBC5F                           ; BCA2 70 BB                    p.
        .byte   $BB                             ; BCA4 BB                       .
        eor     #$40                            ; BCA5 49 40                    I@
        inc     $EDEC                           ; BCA7 EE EC ED                 ...
        bvs     LBC68                           ; BCAA 70 BC                    p.
        .byte   $BB                             ; BCAC BB                       .
        eor     #$40                            ; BCAD 49 40                    I@
        .byte   $EF                             ; BCAF EF                       .
        .byte   $C7                             ; BCB0 C7                       .
        iny                                     ; BCB1 C8                       .
        .byte   $3C                             ; BCB2 3C                       <
        .byte   $2F                             ; BCB3 2F                       /
        .byte   $1B                             ; BCB4 1B                       .
        .byte   $2F                             ; BCB5 2F                       /
        .byte   $17                             ; BCB6 17                       .
        .byte   $1A                             ; BCB7 1A                       .
        cpx     $1FED                           ; BCB8 EC ED 1F                 ...
        and     $3F,x                           ; BCBB 35 3F                    5?
        and     $1C,x                           ; BCBD 35 1C                    5.
        .byte   $32                             ; BCBF 32                       2
        and     $36                             ; BCC0 25 36                    %6
        .byte   $3F                             ; BCC2 3F                       ?
        .byte   $7F                             ; BCC3 7F                       .
        .byte   $3F                             ; BCC4 3F                       ?
        asl     LB537,x                         ; BCC5 1E 37 B5                 .7.
        .byte   $1F                             ; BCC8 1F                       .
        .byte   $37                             ; BCC9 37                       7
        .byte   $57                             ; BCCA 57                       W
        .byte   $1C                             ; BCCB 1C                       .
        rol     $26,x                           ; BCCC 36 26                    6&
        eor     ($3A,x)                         ; BCCE 41 3A                    A:
        .byte   $54                             ; BCD0 54                       T
        lda     $54,x                           ; BCD1 B5 54                    .T
        .byte   $42                             ; BCD3 42                       B
        .byte   $4C                             ; BCD4 4C                       L
LBCD5:  .byte   $4F                             ; BCD5 4F                       O
        .byte   $1F                             ; BCD6 1F                       .
        .byte   $3B                             ; BCD7 3B                       ;
        .byte   $43                             ; BCD8 43                       C
        .byte   $32                             ; BCD9 32                       2
        .byte   $43                             ; BCDA 43                       C
        .byte   $3A                             ; BCDB 3A                       :
        .byte   $97                             ; BCDC 97                       .
        .byte   $3B                             ; BCDD 3B                       ;
        .byte   $1F                             ; BCDE 1F                       .
LBCDF:  .byte   $3A                             ; BCDF 3A                       :
        adc     $74,x                           ; BCE0 75 74                    ut
        adc     $74,x                           ; BCE2 75 74                    ut
        adc     $74,x                           ; BCE4 75 74                    ut
        adc     $EE,x                           ; BCE6 75 EE                    u.
LBCE8:  rol     $6DD8,x                         ; BCE8 3E D8 6D                 >.m
        cld                                     ; BCEB D8                       .
        cld                                     ; BCEC D8                       .
        pha                                     ; BCED 48                       H
        rol     LBEEF,x                         ; BCEE 3E EF BE                 >..
        .byte   $BF                             ; BCF1 BF                       .
        cmp     #$BF                            ; BCF2 C9 BF                    ..
        .byte   $1B                             ; BCF4 1B                       .
        clc                                     ; BCF5 18                       .
        ora     $CE3D,y                         ; BCF6 19 3D CE                 .=.
LBCF9:  .byte   $CF                             ; BCF9 CF                       .
        dec     $3FCF                           ; BCFA CE CF 3F                 ..?
        .byte   $1C                             ; BCFD 1C                       .
        ora     $C432,x                         ; BCFE 1D 32 C4                 .2.
        cmp     $29                             ; BD01 C5 29                    .)
        bit     $39                             ; BD03 24 39                    $9
        .byte   $53                             ; BD05 53                       S
        beq     LBCF9                           ; BD06 F0 F1                    ..
        .byte   $F2                             ; BD08 F2                       .
        .byte   $47                             ; BD09 47                       G
        .byte   $47                             ; BD0A 47                       G
        .byte   $47                             ; BD0B 47                       G
        .byte   $47                             ; BD0C 47                       G
        .byte   $47                             ; BD0D 47                       G
        .byte   $47                             ; BD0E 47                       G
        .byte   $F3                             ; BD0F F3                       .
        .byte   $F4                             ; BD10 F4                       .
        cld                                     ; BD11 D8                       .
        bvs     LBD54                           ; BD12 70 40                    p@
        rol     $D848,x                         ; BD14 3E 48 D8                 >H.
        sbc     $F6,x                           ; BD17 F5 F6                    ..
        .byte   $BB                             ; BD19 BB                       .
        bvs     LBCD5                           ; BD1A 70 B9                    p.
        lda     LBB49,y                         ; BD1C B9 49 BB                 .I.
        .byte   $F7                             ; BD1F F7                       .
        sed                                     ; BD20 F8                       .
        .byte   $BB                             ; BD21 BB                       .
        bvs     LBCDF                           ; BD22 70 BB                    p.
        .byte   $BB                             ; BD24 BB                       .
        eor     #$BB                            ; BD25 49 BB                    I.
        sbc     LBBFA,y                         ; BD27 F9 FA BB                 ...
        bvs     LBCE8                           ; BD2A 70 BC                    p.
        ldy     LBB49,x                         ; BD2C BC 49 BB                 .I.
        sbc     LBFBE,y                         ; BD2F F9 BE BF                 ...
        .byte   $3C                             ; BD32 3C                       <
        .byte   $2F                             ; BD33 2F                       /
        .byte   $1B                             ; BD34 1B                       .
        .byte   $1A                             ; BD35 1A                       .
        .byte   $FB                             ; BD36 FB                       .
        .byte   $FC                             ; BD37 FC                       .
        dec     $33CF                           ; BD38 CE CF 33                 ..3
        and     $3F,x                           ; BD3B 35 3F                    5?
        asl     $FEFD,x                         ; BD3D 1E FD FE                 ...
        eor     $4D4D                           ; BD40 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD43 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD46 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD49 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD4C 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD4F 4D 4D 4D                 MMM
        .byte   $4D                             ; BD52 4D                       M
        .byte   $4D                             ; BD53 4D                       M
LBD54:  .byte   $4D                             ; BD54 4D                       M
        .byte   $4D                             ; BD55 4D                       M
LBD56:  eor     $4D4D                           ; BD56 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD59 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD5C 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD5F 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD62 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD65 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD68 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD6B 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD6E 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD71 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD74 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD77 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD7A 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD7D 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD80 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD83 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD86 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD89 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD8C 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD8F 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD92 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD95 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD98 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD9B 4D 4D 4D                 MMM
        eor     $4D4D                           ; BD9E 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDA1 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDA4 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDA7 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDAA 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDAD 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDB0 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDB3 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDB6 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDB9 4D 4D 4D                 MMM
LBDBC:  eor     $4D4D                           ; BDBC 4D 4D 4D                 MMM
LBDBF:  eor     $4D4D                           ; BDBF 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDC2 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDC5 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDC8 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDCB 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDCE 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDD1 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDD4 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDD7 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDDA 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDDD 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDE0 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDE3 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDE6 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDE9 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDEC 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDEF 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDF2 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDF5 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDF8 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDFB 4D 4D 4D                 MMM
        eor     $4D4D                           ; BDFE 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE01 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE04 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE07 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE0A 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE0D 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE10 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE13 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE16 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE19 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE1C 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE1F 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE22 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE25 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE28 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE2B 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE2E 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE31 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE34 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE37 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE3A 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE3D 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE40 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE43 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE46 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE49 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE4C 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE4F 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE52 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE55 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE58 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE5B 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE5E 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE61 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE64 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE67 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE6A 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE6D 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE70 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE73 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE76 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE79 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE7C 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE7F 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE82 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE85 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE88 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE8B 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE8E 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE91 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE94 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE97 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE9A 4D 4D 4D                 MMM
        eor     $4D4D                           ; BE9D 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEA0 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEA3 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEA6 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEA9 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEAC 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEAF 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEB2 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEB5 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEB8 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEBB 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEBE 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEC1 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEC4 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEC7 4D 4D 4D                 MMM
        eor     $4D4D                           ; BECA 4D 4D 4D                 MMM
        eor     $4D4D                           ; BECD 4D 4D 4D                 MMM
        eor     $4D4D                           ; BED0 4D 4D 4D                 MMM
        eor     $4D4D                           ; BED3 4D 4D 4D                 MMM
        eor     $4D4D                           ; BED6 4D 4D 4D                 MMM
        eor     $4D4D                           ; BED9 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEDC 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEDF 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEE2 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEE5 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEE8 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEEB 4D 4D 4D                 MMM
        .byte   $4D                             ; BEEE 4D                       M
LBEEF:  eor     $4D4D                           ; BEEF 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEF2 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEF5 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEF8 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEFB 4D 4D 4D                 MMM
        eor     $4D4D                           ; BEFE 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF01 4D 4D 4D                 MMM
        .byte   $4D                             ; BF04 4D                       M
LBF05:  eor     $4D4D                           ; BF05 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF08 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF0B 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF0E 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF11 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF14 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF17 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF1A 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF1D 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF20 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF23 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF26 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF29 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF2C 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF2F 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF32 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF35 4D 4D 4D                 MMM
        .byte   $4D                             ; BF38 4D                       M
        .byte   $4D                             ; BF39 4D                       M
LBF3A:  eor     $4D4D                           ; BF3A 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF3D 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF40 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF43 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF46 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF49 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF4C 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF4F 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF52 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF55 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF58 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF5B 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF5E 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF61 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF64 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF67 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF6A 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF6D 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF70 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF73 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF76 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF79 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF7C 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF7F 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF82 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF85 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF88 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF8B 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF8E 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF91 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF94 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF97 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF9A 4D 4D 4D                 MMM
        eor     $4D4D                           ; BF9D 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFA0 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFA3 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFA6 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFA9 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFAC 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFAF 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFB2 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFB5 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFB8 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFBB 4D 4D 4D                 MMM
LBFBE:  eor     $4D4D                           ; BFBE 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFC1 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFC4 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFC7 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFCA 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFCD 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFD0 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFD3 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFD6 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFD9 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFDC 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFDF 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFE2 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFE5 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFE8 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFEB 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFEE 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFF1 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFF4 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFF7 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFFA 4D 4D 4D                 MMM
        eor     $4D4D                           ; BFFD 4D 4D 4D                 MMM
