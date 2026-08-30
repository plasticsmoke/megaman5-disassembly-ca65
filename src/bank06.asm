.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK06"

; =============================================================================
; BANK $06 (mapped at $A000) — STONE/CHARGE/GYRO MAN AI + NAPALM MAN
; STAGE DATA
; Data half (file +$0900 on): stage $06 (Napalm Man) stage data —
; screen table at $A900 with this bank at $A000; format in
; DATA_REFERENCE.md section 11.
; =============================================================================
L0000           := $0000
L0020           := $0020
L0022           := $0022
L0040           := $0040
L0042           := $0042
L004D           := $004D
L0066           := $0066
L0080           := $0080
L01A0           := $01A0
L0400           := $0400
L0D0D           := $0D0D
L0E00           := $0E00
L1100           := $1100
L1400           := $1400
L1708           := $1708
L2019           := $2019
L201F           := $201F
L20A1           := $20A1
L23A0           := $23A0
L2800           := $2800
L290F           := $290F
L2A08           := $2A08
L2A20           := $2A20
L2B17           := $2B17
L2C2B           := $2C2B
L2E2B           := $2E2B
L3000           := $3000
L4222           := $4222
L4D4C           := $4D4C
L5400           := $5400
L5A00           := $5A00
L70E0           := $70E0
L8001           := $8001
L8010           := $8010
L8020           := $8020
L81D5           := $81D5
L84FC           := $84FC
L8592           := $8592
L986E           := $986E
LD1D0           := $D1D0
LEA34           := $EA34
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $69 — STONE MAN (boss of stage $02). Faces the player
; and rolls the RNG against distance bands ($71+/$50+/closer) to pick:
; a short hop toward the player (LA05E half-distance / LA067 full,
; arc via $1C:8592, gravity+walk $A085) or the BIG JUMP ($A041, sub
; $09/$0A, shape $89): after $1E frames he launches ($A110), and on
; landing ($A09B) the screen shakes ($FA jiggle) and he CRUMBLES —
; sub $0E collapse into rubble (shape 0 = untouchable), then sub $0F
; reassemble, shape $C9 restored ($A0FB). The big-jump landing also
; spawns two type $6A Power Stone chunks ($A166, preset $11).
; =============================================================================
        jsr     entity_set_facing                           ; A000 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A003 20 30 EC                  0.
        lda     $0468,x                         ; A006 BD 68 04                 .h.
        beq     LA010                           ; A009 F0 05                    ..
        dec     $0468,x                         ; A00B DE 68 04                 .h.
        bne     LA05D                           ; A00E D0 4D                    .M
LA010:  lda     $E7                             ; A010 A5 E7                    ..
        adc     $E6                             ; A012 65 E6                    e.
        adc     $9D                             ; A014 65 9D                    e.
        sta     $E4                             ; A016 85 E4                    ..
        jsr     entity_x_dist_px                           ; A018 20 94 EC                  ..
        cmp     #$71                            ; A01B C9 71                    .q
        bcs     LA03B                           ; A01D B0 1C                    ..
        cmp     #$50                            ; A01F C9 50                    .P
        bcs     LA02D                           ; A021 B0 0A                    ..
        lda     $E4                             ; A023 A5 E4                    ..
        and     #$07                            ; A025 29 07                    ).
        cmp     #$04                            ; A027 C9 04                    ..
        bcc     LA05E                           ; A029 90 33                    .3
        bcs     LA067                           ; A02B B0 3A                    .:
LA02D:  lda     $E4                             ; A02D A5 E4                    ..
        and     #$01                            ; A02F 29 01                    ).
        beq     LA067                           ; A031 F0 34                    .4
        lda     $E6                             ; A033 A5 E6                    ..
        and     #$01                            ; A035 29 01                    ).
        beq     LA041                           ; A037 F0 08                    ..
        bne     LA05E                           ; A039 D0 23                    .#
LA03B:  lda     $E4                             ; A03B A5 E4                    ..
        and     #$03                            ; A03D 29 03                    ).
        beq     LA067                           ; A03F F0 26                    .&
LA041:  lda     #$10                            ; A041 A9 10                    ..
        sta     $0588,x                         ; A043 9D 88 05                 ...
        lda     #$A1                            ; A046 A9 A1                    ..
        sta     $05A0,x                         ; A048 9D A0 05                 ...
        lda     #$09                            ; A04B A9 09                    ..
        jsr     entity_set_subtype                           ; A04D 20 98 EA                  ..
        lda     #$1E                            ; A050 A9 1E                    ..
        sta     $0480,x                         ; A052 9D 80 04                 ...
        lda     #$89                            ; A055 A9 89                    ..
        sta     $0408,x                         ; A057 9D 08 04                 ...
        jsr     LA110                           ; A05A 20 10 A1                  ..
LA05D:  rts                                     ; A05D 60                       `

; ----------------------------------------------------------------------------
LA05E:  jsr     entity_x_dist_px                           ; A05E 20 94 EC                  ..
        sta     $01                             ; A061 85 01                    ..
        ldy     #$01                            ; A063 A0 01                    ..
        bne     LA06F                           ; A065 D0 08                    ..
LA067:  jsr     entity_x_dist_px                           ; A067 20 94 EC                  ..
        lsr     a                               ; A06A 4A                       J
        sta     $01                             ; A06B 85 01                    ..
        ldy     #$00                            ; A06D A0 00                    ..
LA06F:  tya                                     ; A06F 98                       .
        sta     $0498,x                         ; A070 9D 98 04                 ...
        jsr     L8592                           ; A073 20 92 85                  ..
        lda     #$85                            ; A076 A9 85                    ..
        sta     $0588,x                         ; A078 9D 88 05                 ...
        lda     #$A0                            ; A07B A9 A0                    ..
        sta     $05A0,x                         ; A07D 9D A0 05                 ...
        lda     #$0C                            ; A080 A9 0C                    ..
        jsr     entity_set_subtype                           ; A082 20 98 EA                  ..
        lda     #$00                            ; A085 A9 00                    ..
        sta     $0570,x                         ; A087 9D 70 05                 .p.
        ldy     #$19                            ; A08A A0 19                    ..
        jsr     entity_gravity_collide                           ; A08C 20 B7 E7                  ..
        bcs     LA09B                           ; A08F B0 0A                    ..
        ldy     #$1E                            ; A091 A0 1E                    ..
        jsr     entity_horiz_dispatch                           ; A093 20 3F EA                  ?.
        bcc     LA05D                           ; A096 90 C5                    ..
        jmp     entity_flip_direction                           ; A098 4C 4A EC                 LJ.

; ----------------------------------------------------------------------------
LA09B:  lda     $0498,x                         ; A09B BD 98 04                 ...
        bne     LA0B9                           ; A09E D0 19                    ..
LA0A0:  lda     #$AF                            ; A0A0 A9 AF
        sta     $0588,x                         ; A0A2 9D 88 05
        lda     #$A0                            ; A0A5 A9 A0
        sta     $05A0,x                         ; A0A7 9D A0 05 behavior PC := $A0AF
        lda     #$01                            ; A0AA A9 01                    ..
        sta     $0540,x                         ; A0AC 9D 40 05                 .@.
        lda     $0570,x                         ; A0AF BD 70 05                 .p.
        cmp     #$04                            ; A0B2 C9 04                    ..
        bne     LA05D                           ; A0B4 D0 A7                    ..
        jmp     LA0FB                           ; A0B6 4C FB A0                 L..

; ----------------------------------------------------------------------------
LA0B9:  lda     #$D0                            ; A0B9 A9 D0                    ..
        sta     $0588,x                         ; A0BB 9D 88 05                 ...
        lda     #$A0                            ; A0BE A9 A0                    ..
        sta     $05A0,x                         ; A0C0 9D A0 05                 ...
        lda     #$0E                            ; A0C3 A9 0E                    ..
        jsr     entity_set_subtype                           ; A0C5 20 98 EA                  ..
        lda     #$00                            ; A0C8 A9 00                    ..
        sta     $0408,x                         ; A0CA 9D 08 04                 ...
        jsr     entity_stop_y                           ; A0CD 20 1E EA                  ..
        lda     $0570,x                         ; A0D0 BD 70 05                 .p.
        and     #$02                            ; A0D3 29 02                    ).
        sta     $FA                             ; A0D5 85 FA                    ..
        lda     $0540,x                         ; A0D7 BD 40 05                 .@.
        cmp     #$0A                            ; A0DA C9 0A                    ..
        bne     LA10F                           ; A0DC D0 31                    .1
        lda     #$0F                            ; A0DE A9 0F                    ..
        jsr     entity_set_subtype                           ; A0E0 20 98 EA                  ..
        lda     #$ED                            ; A0E3 A9 ED                    ..
        sta     $0588,x                         ; A0E5 9D 88 05                 ...
        lda     #$A0                            ; A0E8 A9 A0                    ..
        sta     $05A0,x                         ; A0EA 9D A0 05                 ...
        lda     $0540,x                         ; A0ED BD 40 05                 .@.
        cmp     #$04                            ; A0F0 C9 04                    ..
        bne     LA10F                           ; A0F2 D0 1B                    ..
        lda     $0570,x                         ; A0F4 BD 70 05                 .p.
        cmp     #$02                            ; A0F7 C9 02                    ..
        bne     LA10F                           ; A0F9 D0 14                    ..
LA0FB:  lda     #$C9                            ; A0FB A9 C9                    ..
        sta     $0408,x                         ; A0FD 9D 08 04                 ...
        lda     #$00                            ; A100 A9 00                    ..
        sta     $0588,x                         ; A102 9D 88 05                 ...
        lda     #$A0                            ; A105 A9 A0                    ..
        sta     $05A0,x                         ; A107 9D A0 05                 ...
        lda     #$08                            ; A10A A9 08                    ..
        jsr     entity_set_subtype                           ; A10C 20 98 EA                  ..
LA10F:  rts                                     ; A10F 60                       `

; ----------------------------------------------------------------------------
LA110:  dec     $0480,x                         ; A110 DE 80 04                 ...
        bne     LA10F                           ; A113 D0 FA                    ..
        lda     #$0A                            ; A115 A9 0A                    ..
        jsr     entity_set_subtype                           ; A117 20 98 EA                  ..
        lda     $0378,x                         ; A11A BD 78 03                 .x.
        sec                                     ; A11D 38                       8
        sbc     #$08                            ; A11E E9 08                    ..
        sta     $0378,x                         ; A120 9D 78 03                 .x.
        lda     #$99                            ; A123 A9 99                    ..
        sta     $0408,x                         ; A125 9D 08 04                 ...
        lda     #$32                            ; A128 A9 32                    .2
        sta     $0588,x                         ; A12A 9D 88 05                 ...
        lda     #$A1                            ; A12D A9 A1                    ..
        sta     $05A0,x                         ; A12F 9D A0 05                 ...
        jsr     entity_set_facing                           ; A132 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A135 20 30 EC                  0.
        lda     $0570,x                         ; A138 BD 70 05                 .p.
        cmp     #$05                            ; A13B C9 05                    ..
        beq     LA166                           ; A13D F0 27                    .'
        cmp     #$0A                            ; A13F C9 0A                    ..
        bne     LA10F                           ; A141 D0 CC                    ..
        lda     $0378,x                         ; A143 BD 78 03                 .x.
        clc                                     ; A146 18                       .
        adc     #$08                            ; A147 69 08                    i.
        sta     $0378,x                         ; A149 9D 78 03                 .x.
        lda     #$3C                            ; A14C A9 3C                    .<
        sta     $0468,x                         ; A14E 9D 68 04                 .h.
        lda     #$C9                            ; A151 A9 C9                    ..
        sta     $0408,x                         ; A153 9D 08 04                 ...
        lda     #$5E                            ; A156 A9 5E                    .^
        sta     $0588,x                         ; A158 9D 88 05                 ...
        lda     #$A0                            ; A15B A9 A0                    ..
        sta     $05A0,x                         ; A15D 9D A0 05                 ...
        jsr     entity_set_facing                           ; A160 20 16 EC                  ..
        jmp     entity_facing_to_flags                           ; A163 4C 30 EC                 L0.

; ----------------------------------------------------------------------------
LA166:  lda     #$01                            ; A166 A9 01                    ..
        sta     $0E                             ; A168 85 0E                    ..
LA16A:  jsr     find_free_slot_y                           ; A16A 20 6F F1                  o.
        bcs     LA191                           ; A16D B0 22                    ."
        lda     #$81                            ; A16F A9 81                    ..
        sta     $0408,y                         ; A171 99 08 04                 ...
        lda     #$6A                            ; A174 A9 6A                    .j
        sta     $0300,y                         ; A176 99 00 03                 ...
        lda     $0E                             ; A179 A5 0E                    ..
        pha                                     ; A17B 48                       H
        clc                                     ; A17C 18                       .
        adc     #$38                            ; A17D 69 38                    i8
        sta     $10                             ; A17F 85 10                    ..
        lda     #$11                            ; A181 A9 11                    ..
        jsr     entity_speed_preset                           ; A183 20 F5 EA                  ..
        pla                                     ; A186 68                       h
        asl     a                               ; A187 0A                       .
        asl     a                               ; A188 0A                       .
        asl     a                               ; A189 0A                       .
        sta     $0468,y                         ; A18A 99 68 04                 .h.
        dec     $0E                             ; A18D C6 0E                    ..
        bpl     LA16A                           ; A18F 10 D9                    ..
LA191:  rts                                     ; A191 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $6A — Power Stone chunk (Stone Man's): shape follows
; the anim phase (LA1F2); from phase 5 it orbits outward — 16-dir
; velocity at speed $10, heading advanced every $0498 frames, the
; period growing each full turn: an expanding spiral.
; =============================================================================
        lda     $0540,x                         ; A192 BD 40 05                 .@.
        tay                                     ; A195 A8                       .
        lda     LA1F2,y                         ; A196 B9 F2 A1                 ...
        sta     $0408,x                         ; A199 9D 08 04                 ...
        cpy     #$05                            ; A19C C0 05                    ..
        bcc     LA1F1                           ; A19E 90 51                    .Q
        lda     #$B7                            ; A1A0 A9 B7                    ..
        sta     $0588,x                         ; A1A2 9D 88 05                 ...
        lda     #$A1                            ; A1A5 A9 A1                    ..
        sta     $05A0,x                         ; A1A7 9D A0 05                 ...
        lda     #$03                            ; A1AA A9 03                    ..
        sta     $0498,x                         ; A1AC 9D 98 04                 ...
        ldy     $0468,x                         ; A1AF BC 68 04                 .h.
        lda     #$10                            ; A1B2 A9 10                    ..
        jsr     entity_set_dir_velocity                           ; A1B4 20 70 F4                  p.
        lda     #$00                            ; A1B7 A9 00                    ..
        sta     $0570,x                         ; A1B9 9D 70 05                 .p.
        lda     #$05                            ; A1BC A9 05                    ..
        cmp     $0540,x                         ; A1BE DD 40 05                 .@.
        beq     LA1C6                           ; A1C1 F0 03                    ..
        sta     $0540,x                         ; A1C3 9D 40 05                 .@.
LA1C6:  jsr     L84FC                           ; A1C6 20 FC 84                  ..
        inc     $0480,x                         ; A1C9 FE 80 04                 ...
        lda     $0480,x                         ; A1CC BD 80 04                 ...
        cmp     $0498,x                         ; A1CF DD 98 04                 ...
        bne     LA1F1                           ; A1D2 D0 1D                    ..
        lda     #$00                            ; A1D4 A9 00                    ..
        sta     $0480,x                         ; A1D6 9D 80 04                 ...
        inc     $0468,x                         ; A1D9 FE 68 04                 .h.
        lda     $0468,x                         ; A1DC BD 68 04                 .h.
        and     #$0F                            ; A1DF 29 0F                    ).
        sta     $0468,x                         ; A1E1 9D 68 04                 .h.
        tay                                     ; A1E4 A8                       .
        and     #$07                            ; A1E5 29 07                    ).
        bne     LA1EC                           ; A1E7 D0 03                    ..
        inc     $0498,x                         ; A1E9 FE 98 04                 ...
LA1EC:  lda     #$10                            ; A1EC A9 10                    ..
        jsr     entity_set_dir_velocity                           ; A1EE 20 70 F4                  p.
LA1F1:  rts                                     ; A1F1 60                       `

; ----------------------------------------------------------------------------
LA1F2:  .byte   $87,$86,$85,$81,$81,$81         ; A1F2  $6A shape by anim phase
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $6B — CHARGE MAN (boss of stage $05; fought in his
; stage and the boss rush). Out of charge range (player > $3C px):
; idles (sub $19), chugs up (sub $1B), then leaps (sub $1C, yvel
; $03.00, arc scaled by distance/8) and walks toward the player
; puffing type $6D smoke from his stack ($A281); lands with a pause.
; Within $3C px he CHARGES ($A2D3): xvel $01.33 for $78 frames,
; re-aiming every $2D. Afterwards, on an RNG miss he rages (sub $1D,
; $A32A -> $A33F): at anim phase $0A, sound $42 and a type $6C coal
; chunk is flung up (preset $1E, yvel 8 up); repeats while chunks
; are alive, then returns to normal via sub $19.
; =============================================================================
        jsr     entity_set_facing               ; A1F8 20 16 EC
        jsr     entity_facing_to_flags                           ; A1FB 20 30 EC                  0.
        jsr     entity_x_dist_px                           ; A1FE 20 94 EC                  ..
        cmp     #$3D                            ; A201 C9 3D                    .=
        bcs     LA208                           ; A203 B0 03                    ..
        jmp     LA2D3                           ; A205 4C D3 A2                 L..

; ----------------------------------------------------------------------------
LA208:  lda     $0468,x                         ; A208 BD 68 04                 .h.
        bne     LA217                           ; A20B D0 0A                    ..
        lda     #$19                            ; A20D A9 19                    ..
        jsr     entity_set_subtype                           ; A20F 20 98 EA                  ..
        lda     #$1E                            ; A212 A9 1E                    ..
        sta     $0468,x                         ; A214 9D 68 04                 .h.
LA217:  dec     $0468,x                         ; A217 DE 68 04                 .h.
        bne     LA1F1                           ; A21A D0 D5                    ..
LA21C:  lda     #$2B                            ; A21C A9 2B                    .+
        sta     $0588,x                         ; A21E 9D 88 05                 ...
        lda     #$A2                            ; A221 A9 A2                    ..
        sta     $05A0,x                         ; A223 9D A0 05                 ...
        lda     #$1B                            ; A226 A9 1B                    ..
        jsr     entity_set_subtype                           ; A228 20 98 EA                  ..
        lda     $0558,x                         ; A22B BD 58 05                 .X.
        cmp     #$1B                            ; A22E C9 1B                    ..
        bne     LA272                           ; A230 D0 40                    .@
        lda     $0570,x                         ; A232 BD 70 05                 .p.
        cmp     #$06                            ; A235 C9 06                    ..
        bne     LA1F1                           ; A237 D0 B8                    ..
        lda     #$1C                            ; A239 A9 1C                    ..
        jsr     entity_set_subtype                           ; A23B 20 98 EA                  ..
        jsr     entity_set_facing                           ; A23E 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A241 20 30 EC                  0.
        lda     $0378,x                         ; A244 BD 78 03                 .x.
        clc                                     ; A247 18                       .
        adc     #$04                            ; A248 69 04                    i.
        sta     $0378,x                         ; A24A 9D 78 03                 .x.
        lda     #$00                            ; A24D A9 00                    ..
        sta     $03A8,x                         ; A24F 9D A8 03                 ...
        lda     #$03                            ; A252 A9 03                    ..
        sta     $03C0,x                         ; A254 9D C0 03                 ...
        lda     #$80                            ; A257 A9 80                    ..
        sta     $0408,x                         ; A259 9D 08 04                 ...
        jsr     entity_x_dist_px                           ; A25C 20 94 EC                  ..
        sta     L0000                           ; A25F 85 00                    ..
        lda     #$03                            ; A261 A9 03                    ..
        sta     $01                             ; A263 85 01                    ..
        jsr     div8                           ; A265 20 07 F2                  ..
        lda     $02                             ; A268 A5 02                    ..
        sta     $0480,x                         ; A26A 9D 80 04                 ...
        bne     LA272                           ; A26D D0 03                    ..
        inc     $0480,x                         ; A26F FE 80 04                 ...
LA272:  ldy     #$1E                            ; A272 A0 1E                    ..
        jsr     entity_horiz_dispatch                           ; A274 20 3F EA                  ?.
        bcc     LA27C                           ; A277 90 03                    ..
        jsr     entity_flip_direction                           ; A279 20 4A EC                  J.
LA27C:  dec     $0480,x                         ; A27C DE 80 04                 ...
        beq     LA2AB                           ; A27F F0 2A                    .*
        lda     $0540,x                         ; A281 BD 40 05                 .@.
        ora     $0570,x                         ; A284 1D 70 05                 .p.
        bne     LA2AA                           ; A287 D0 21                    .!
        jsr     find_free_slot_y                           ; A289 20 6F F1                  o.
        bcs     LA2AA                           ; A28C B0 1C                    ..
        lda     #$00                            ; A28E A9 00                    ..
        sta     $0408,y                         ; A290 99 08 04                 ...
        sta     $0450,y                         ; A293 99 50 04                 .P.
        lda     #$6D                            ; A296 A9 6D                    .m
        sta     $0300,y                         ; A298 99 00 03                 ...
        lda     $0420,x                         ; A29B BD 20 04                 . .
        and     #$01                            ; A29E 29 01                    ).
        clc                                     ; A2A0 18                       .
        adc     #$3A                            ; A2A1 69 3A                    i:
        sta     $10                             ; A2A3 85 10                    ..
        lda     #$21                            ; A2A5 A9 21                    .!
        jsr     entity_speed_preset                           ; A2A7 20 F5 EA                  ..
LA2AA:  rts                                     ; A2AA 60                       `

; ----------------------------------------------------------------------------
LA2AB:  lda     $0378,x                         ; A2AB BD 78 03                 .x.
        sec                                     ; A2AE 38                       8
        sbc     #$04                            ; A2AF E9 04                    ..
        sta     $0378,x                         ; A2B1 9D 78 03                 .x.
        lda     #$19                            ; A2B4 A9 19                    ..
        jsr     entity_set_subtype                           ; A2B6 20 98 EA                  ..
        lda     #$1C                            ; A2B9 A9 1C                    ..
        sta     $0480,x                         ; A2BB 9D 80 04                 ...
        lda     #$D3                            ; A2BE A9 D3                    ..
        sta     $0588,x                         ; A2C0 9D 88 05                 ...
        lda     #$A2                            ; A2C3 A9 A2                    ..
        sta     $05A0,x                         ; A2C5 9D A0 05                 ...
        lda     #$C0                            ; A2C8 A9 C0                    ..
        sta     $0408,x                         ; A2CA 9D 08 04                 ...
        jsr     entity_set_facing                           ; A2CD 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A2D0 20 30 EC                  0.
LA2D3:  lda     $0480,x                         ; A2D3 BD 80 04                 ...
        beq     LA2DD                           ; A2D6 F0 05                    ..
        dec     $0480,x                         ; A2D8 DE 80 04                 ...
        bne     LA2AA                           ; A2DB D0 CD                    ..
LA2DD:  lda     #$33                            ; A2DD A9 33                    .3
        sta     $03A8,x                         ; A2DF 9D A8 03                 ...
        lda     #$01                            ; A2E2 A9 01                    ..
        sta     $03C0,x                         ; A2E4 9D C0 03                 ...
        lda     #$78                            ; A2E7 A9 78                    .x
        sta     $0498,x                         ; A2E9 9D 98 04                 ...
        lda     #$2D                            ; A2EC A9 2D                    .-
        sta     $04B0,x                         ; A2EE 9D B0 04                 ...
        lda     #$1A                            ; A2F1 A9 1A                    ..
        jsr     entity_set_subtype                           ; A2F3 20 98 EA                  ..
        lda     #$00                            ; A2F6 A9 00                    ..
        sta     $0588,x                         ; A2F8 9D 88 05                 ...
        lda     #$A3                            ; A2FB A9 A3                    ..
        sta     $05A0,x                         ; A2FD 9D A0 05                 ...
        dec     $0498,x                         ; A300 DE 98 04                 ...
        beq     LA31F                           ; A303 F0 1A                    ..
        dec     $04B0,x                         ; A305 DE B0 04                 ...
        bne     LA315                           ; A308 D0 0B                    ..
        lda     #$2D                            ; A30A A9 2D                    .-
        sta     $04B0,x                         ; A30C 9D B0 04                 ...
        jsr     entity_set_facing                           ; A30F 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A312 20 30 EC                  0.
LA315:  ldy     #$1E                            ; A315 A0 1E                    ..
        jsr     entity_horiz_dispatch                           ; A317 20 3F EA                  ?.
        bcc     LA33E                           ; A31A 90 22                    ."
        jmp     entity_flip_direction                           ; A31C 4C 4A EC                 LJ.

; ----------------------------------------------------------------------------
LA31F:  lda     $E6                             ; A31F A5 E6                    ..
        sbc     $E4                             ; A321 E5 E4                    ..
        and     #$03                            ; A323 29 03                    ).
        bne     LA32A                           ; A325 D0 03                    ..
        jmp     LA21C                           ; A327 4C 1C A2                 L..

; ----------------------------------------------------------------------------
LA32A:  lda     #$3F                            ; A32A A9 3F                    .?
        sta     $0588,x                         ; A32C 9D 88 05                 ...
        lda     #$A3                            ; A32F A9 A3                    ..
        sta     $05A0,x                         ; A331 9D A0 05                 ...
        lda     #$1D                            ; A334 A9 1D                    ..
        jsr     entity_set_subtype                           ; A336 20 98 EA                  ..
        lda     #$80                            ; A339 A9 80                    ..
        sta     $0408,x                         ; A33B 9D 08 04                 ...
LA33E:  rts                                     ; A33E 60                       `

; ----------------------------------------------------------------------------
        jsr     entity_set_facing                           ; A33F 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A342 20 30 EC                  0.
        lda     $0540,x                         ; A345 BD 40 05                 .@.
        cmp     #$0A                            ; A348 C9 0A                    ..
        bne     LA33E                           ; A34A D0 F2                    ..
        lda     #$83                            ; A34C A9 83                    ..
        sta     $0588,x                         ; A34E 9D 88 05                 ...
        lda     #$A3                            ; A351 A9 A3                    ..
        sta     $05A0,x                         ; A353 9D A0 05                 ...
        lda     #$42                            ; A356 A9 42                    .B
        jsr     queue_sound                           ; A358 20 5D EC                  ].
        jsr     find_free_slot_y                           ; A35B 20 6F F1                  o.
        bcs     LA33E                           ; A35E B0 DE                    ..
        lda     #$87                            ; A360 A9 87                    ..
        sta     $0408,y                         ; A362 99 08 04                 ...
        lda     #$6C                            ; A365 A9 6C                    .l
        sta     $0300,y                         ; A367 99 00 03                 ...
        lda     $0420,x                         ; A36A BD 20 04
        and     #$01                            ; A36D 29 01
        clc                                     ; A36F 18
        adc     #$3A                            ; A370 69 3A                    i:
        sta     $10                             ; A372 85 10                    ..
        lda     #$1E                            ; A374 A9 1E                    ..
        jsr     entity_speed_preset                           ; A376 20 F5 EA                  ..
        lda     #$00                            ; A379 A9 00                    ..
        sta     $03D8,y                         ; A37B 99 D8 03                 ...
        lda     #$08                            ; A37E A9 08                    ..
        sta     $03F0,y                         ; A380 99 F0 03                 ...
        lda     $0540,x                         ; A383 BD 40 05                 .@.
        cmp     #$0B                            ; A386 C9 0B                    ..
        bcs     LA3A2                           ; A388 B0 18                    ..
        lda     #$00                            ; A38A A9 00                    ..
        sta     $0570,x                         ; A38C 9D 70 05                 .p.
        ldy     #$17                            ; A38F A0 17                    ..
LA391:  lda     $0300,y                         ; A391 B9 00 03                 ...
        cmp     #$6C                            ; A394 C9 6C                    .l
        beq     LA3C4                           ; A396 F0 2C                    .,
        dey                                     ; A398 88                       .
        cpy     #$07                            ; A399 C0 07                    ..
        bcs     LA391                           ; A39B B0 F4                    ..
        lda     #$0B                            ; A39D A9 0B                    ..
        sta     $0540,x                         ; A39F 9D 40 05                 .@.
LA3A2:  lda     $0540,x                         ; A3A2 BD 40 05                 .@.
        cmp     #$0E                            ; A3A5 C9 0E                    ..
        bne     LA3C4                           ; A3A7 D0 1B                    ..
        lda     $0570,x                         ; A3A9 BD 70 05                 .p.
        cmp     #$02                            ; A3AC C9 02
        bne     LA3C4                           ; A3AE D0 14                    ..
        lda     #$F8                            ; A3B0 A9 F8                    ..
        sta     $0588,x                         ; A3B2 9D 88 05                 ...
        lda     #$A1                            ; A3B5 A9 A1                    ..
        sta     $05A0,x                         ; A3B7 9D A0 05                 ...
        lda     #$19                            ; A3BA A9 19                    ..
        jsr     entity_set_subtype                           ; A3BC 20 98 EA                  ..
        lda     #$C0                            ; A3BF A9 C0                    ..
        sta     $0408,x                         ; A3C1 9D 08 04                 ...
LA3C4:  rts                                     ; A3C4 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $6C — Charge Man's coal chunk: soars up off the top of
; the screen, waits $1C frames, then respawns as three falling chunks
; at RNG-picked X positions (LA43D, 8 sets of 3) with PC $A43A (plain
; fall) and wipes itself.
; =============================================================================
        lda     $0468,x                         ; A3C5 BD 68 04                 .h.
        bne     LA3E1                           ; A3C8 D0 17                    ..
        jsr     entity_move_up_nofacing                           ; A3CA 20 4A E9                  J.
        lda     $0378,x                         ; A3CD BD 78 03                 .x.
        cmp     #$08                            ; A3D0 C9 08                    ..
        bcs     LA3C4                           ; A3D2 B0 F0                    ..
        lda     $0528,x                         ; A3D4 BD 28 05                 .(.
        ora     #$04                            ; A3D7 09 04                    ..
        sta     $0528,x                         ; A3D9 9D 28 05                 .(.
        lda     #$1C                            ; A3DC A9 1C                    ..
        sta     $0468,x                         ; A3DE 9D 68 04                 .h.
LA3E1:  dec     $0468,x                         ; A3E1 DE 68 04                 .h.
        bne     LA3C4                           ; A3E4 D0 DE                    ..
        lda     $E7                             ; A3E6 A5 E7                    ..
        sbc     $E4                             ; A3E8 E5 E4                    ..
        sta     $E4                             ; A3EA 85 E4                    ..
        and     #$07                            ; A3EC 29 07                    ).
        sta     $0E                             ; A3EE 85 0E                    ..
        asl     a                               ; A3F0 0A                       .
        clc                                     ; A3F1 18                       .
        adc     $0E                             ; A3F2 65 0E                    e.
        sta     $0E                             ; A3F4 85 0E                    ..
        stx     $0F                             ; A3F6 86 0F                    ..
        lda     #$02                            ; A3F8 A9 02                    ..
        sta     $0D                             ; A3FA 85 0D                    ..
LA3FC:  jsr     find_free_slot_y                           ; A3FC 20 6F F1                  o.
        bcs     LA3C4                           ; A3FF B0 C3                    ..
        lda     #$80                            ; A401 A9 80                    ..
        sta     $0408,y                         ; A403 99 08 04                 ...
        lda     #$00                            ; A406 A9 00                    ..
        sta     $0450,y                         ; A408 99 50 04                 .P.
        lda     #$6C                            ; A40B A9 6C                    .l
        sta     $0300,y                         ; A40D 99 00 03                 ...
        lda     #$22                            ; A410 A9 22                    ."
        jsr     entity_init_pos                           ; A412 20 A4 EA                  ..
        jsr     LEA34                           ; A415 20 34 EA                  4.
        ldx     $0E                             ; A418 A6 0E                    ..
        lda     #$08                            ; A41A A9 08                    ..
        sta     $0378,y                         ; A41C 99 78 03                 .x.
        lda     LA43D,x                         ; A41F BD 3D A4                 .=.
        sta     $0330,y                         ; A422 99 30 03                 .0.
        lda     #$3A                            ; A425 A9 3A
        sta     $0588,y                         ; A427 99 88 05 child PC := $A43A
        lda     #$A4                            ; A42A A9 A4                    ..
        sta     $05A0,y                         ; A42C 99 A0 05                 ...
        ldx     $0F                             ; A42F A6 0F                    ..
        inc     $0E                             ; A431 E6 0E                    ..
        dec     $0D                             ; A433 C6 0D                    ..
        bpl     LA3FC                           ; A435 10 C5                    ..
        jmp     entity_wipe_x                           ; A437 4C C4 F2                 L..

; ----------------------------------------------------------------------------
        jmp     entity_process_y_vel                           ; A43A 4C 68 E9                 Lh.

; ----------------------------------------------------------------------------
LA43D:  .byte   $40,$78,$B0,$28,$40,$68,$58,$B0 ; A43D  coal-rain X (8 sets of 3)
        .byte   $E0,$60,$88,$B0,$20,$80,$E0,$40 ; A445
        .byte   $78,$B0,$28,$40,$68,$60,$88,$B0 ; A44D
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $6E — GYRO MAN (boss of stage $03). Waits, then by
; RNG parity: ground attack (sub $13, $A493) — at the throw frame
; fires a type $6F gyro blade (LA4B7 -> LA595, 3 px/f); or takes off
; (sub $14/$15/$16, $A4CF): rockets up into the clouds ($03.00), off
; the top of the screen; while hidden drops four type $80 falling
; gyros ($A542 -> LA595), then falls back down at the player's
; clamped X ($A54D, X in [$20,$E0]), landing with a pause (sub $12).
; The $A4C2 gate holds him while his blade is still out.
; =============================================================================
        jsr     entity_set_facing               ; A455 20 16 EC
        jsr     entity_facing_to_flags                           ; A458 20 30 EC                  0.
        lda     $0468,x                         ; A45B BD 68 04                 .h.
        beq     LA464                           ; A45E F0 04                    ..
        dec     $0468,x                         ; A460 DE 68 04                 .h.
        rts                                     ; A463 60                       `

; ----------------------------------------------------------------------------
LA464:  lda     $E7                             ; A464 A5 E7                    ..
        sbc     $E4                             ; A466 E5 E4                    ..
        sta     $E4                             ; A468 85 E4
LA46A:  and     #$01                            ; A46A 29 01
        bne     LA480                           ; A46C D0 12                    ..
        lda     #$93                            ; A46E A9 93                    ..
        sta     $0588,x                         ; A470 9D 88 05                 ...
        lda     #$A4                            ; A473 A9 A4                    ..
        sta     $05A0,x                         ; A475 9D A0 05 behavior PC := $A478
LA478:  lda     #$13                            ; A478 A9 13                    ..
        jsr     entity_set_subtype                           ; A47A 20 98 EA                  ..
        jmp     LA493                           ; A47D 4C 93 A4                 L..

; ----------------------------------------------------------------------------
LA480:  lda     #$CF                            ; A480 A9 CF                    ..
        sta     $0588,x                         ; A482 9D 88 05                 ...
        lda     #$A4                            ; A485 A9 A4                    ..
        sta     $05A0,x                         ; A487 9D A0 05                 ...
        lda     #$14                            ; A48A A9 14                    ..
        jsr     entity_set_subtype                           ; A48C 20 98 EA                  ..
        jsr     LA4CF                           ; A48F 20 CF A4                  ..
LA492:  rts                                     ; A492 60                       `

; ----------------------------------------------------------------------------
LA493:  jsr     entity_set_facing                           ; A493 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A496 20 30 EC                  0.
        lda     $0558,x                         ; A499 BD 58 05                 .X.
        cmp     #$12                            ; A49C C9 12                    ..
        beq     LA4C2                           ; A49E F0 22
        lda     $0570,x                         ; A4A0 BD 70 05                 .p.
        cmp     #$04                            ; A4A3 C9 04
        bne     LA492                           ; A4A5 D0 EB                    ..
        lda     $0540,x                         ; A4A7 BD 40 05                 .@.
        cmp     #$01                            ; A4AA C9 01                    ..
        beq     LA4B7                           ; A4AC F0 09                    ..
        cmp     #$06                            ; A4AE C9 06                    ..
        bne     LA492                           ; A4B0 D0 E0                    ..
        lda     #$12                            ; A4B2 A9 12                    ..
        jmp     entity_set_subtype                           ; A4B4 4C 98 EA                 L..

; ----------------------------------------------------------------------------
LA4B7:  lda     #$03                            ; A4B7 A9 03                    ..
        sta     $0F                             ; A4B9 85 0F                    ..
        lda     #$6F                            ; A4BB A9 6F                    .o
LA4BD:  sta     $0E                             ; A4BD 85 0E                    ..
        jmp     LA595                           ; A4BF 4C 95 A5                 L..

; ----------------------------------------------------------------------------
LA4C2:  ldy     $0480,x                         ; A4C2 BC 80 04                 ...
        lda     $0300,y                         ; A4C5 B9 00 03                 ...
        cmp     #$6F                            ; A4C8 C9 6F                    .o
        beq     LA492                           ; A4CA F0 C6                    ..
        jmp     LA58A                           ; A4CC 4C 8A A5                 L..

; ----------------------------------------------------------------------------
LA4CF:  lda     $0558,x                         ; A4CF BD 58 05                 .X.
        cmp     #$15                            ; A4D2 C9 15                    ..
        beq     LA4E7                           ; A4D4 F0 11                    ..
        lda     $0570,x                         ; A4D6 BD 70 05                 .p.
        cmp     #$0A                            ; A4D9 C9 0A                    ..
        bne     LA492                           ; A4DB D0 B5                    ..
        lda     #$15                            ; A4DD A9 15                    ..
        jsr     entity_set_subtype                           ; A4DF 20 98 EA                  ..
        lda     #$14                            ; A4E2 A9 14                    ..
        sta     $0468,x                         ; A4E4 9D 68 04                 .h.
LA4E7:  dec     $0468,x                         ; A4E7 DE 68 04                 .h.
        bne     LA492                           ; A4EA D0 A6                    ..
        lda     #$16                            ; A4EC A9 16                    ..
        jsr     entity_set_subtype                           ; A4EE 20 98 EA                  ..
        lda     #$08                            ; A4F1 A9 08                    ..
        sta     $0468,x                         ; A4F3 9D 68 04                 .h.
        lda     #$0A                            ; A4F6 A9 0A                    ..
        sta     $0588,x                         ; A4F8 9D 88 05                 ...
        lda     #$A5                            ; A4FB A9 A5                    ..
        sta     $05A0,x                         ; A4FD 9D A0 05                 ...
        lda     #$00                            ; A500 A9 00                    ..
        sta     $03D8,x                         ; A502 9D D8 03                 ...
        lda     #$03                            ; A505 A9 03                    ..
        sta     $03F0,x                         ; A507 9D F0 03                 ...
        jsr     entity_set_facing                           ; A50A 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; A50D 20 30 EC                  0.
        lda     $0468,x                         ; A510 BD 68 04                 .h.
        beq     LA531                           ; A513 F0 1C                    ..
        dec     $0468,x                         ; A515 DE 68 04                 .h.
        bne     LA531                           ; A518 D0 17                    ..
        jsr     find_free_slot_y                           ; A51A 20 6F F1                  o.
        bcs     LA594                           ; A51D B0 75                    .u
        lda     #$00                            ; A51F A9 00                    ..
        sta     $0408,y                         ; A521 99 08 04                 ...
        sta     $0450,y                         ; A524 99 50 04                 .P.
        lda     #$6D                            ; A527 A9 6D                    .m
        sta     $0300,y                         ; A529 99 00 03                 ...
        lda     #$17                            ; A52C A9 17                    ..
        jsr     entity_init_pos                           ; A52E 20 A4 EA                  ..
LA531:  ldy     #$1D                            ; A531 A0 1D                    ..
        jsr     entity_move_up                           ; A533 20 80 E7                  ..
        bcc     LA594                           ; A536 90 5C                    .\
        lda     #$4D                            ; A538 A9 4D                    .M
        sta     $0588,x                         ; A53A 9D 88 05                 ...
        lda     #$A5                            ; A53D A9 A5                    ..
        sta     $05A0,x                         ; A53F 9D A0 05                 ...
        lda     #$04                            ; A542 A9 04                    ..
        sta     $0F                             ; A544 85 0F                    ..
        lda     #$80                            ; A546 A9 80                    ..
        sta     $0E                             ; A548 85 0E                    ..
        jmp     LA595                           ; A54A 4C 95 A5                 L..

; ----------------------------------------------------------------------------
        ldy     $0480,x                         ; A54D BC 80 04                 ...
        lda     $0300,y                         ; A550 B9 00 03                 ...
        cmp     #$80                            ; A553 C9 80                    ..
        beq     LA594                           ; A555 F0 3D                    .=
        ldy     $0330                           ; A557 AC 30 03                 .0.
        cpy     #$20                            ; A55A C0 20                    . 
        bcs     LA562                           ; A55C B0 04                    ..
        ldy     #$20                            ; A55E A0 20                    . 
        bne     LA568                           ; A560 D0 06                    ..
LA562:  cpy     #$E0                            ; A562 C0 E0                    ..
        bcc     LA568                           ; A564 90 02                    ..
        ldy     #$E0                            ; A566 A0 E0                    ..
LA568:  tya                                     ; A568 98                       .
        sta     $0330,x                         ; A569 9D 30 03                 .0.
        lda     #$79                            ; A56C A9 79                    .y
        sta     $0588,x                         ; A56E 9D 88 05                 ...
        lda     #$A5                            ; A571 A9 A5                    ..
        sta     $05A0,x                         ; A573 9D A0 05                 ...
        jsr     entity_stop_y                           ; A576 20 1E EA                  ..
        ldy     #$1C                            ; A579 A0 1C                    ..
        jsr     entity_gravity_collide                           ; A57B 20 B7 E7                  ..
        bcc     LA594                           ; A57E 90 14                    ..
        lda     #$12                            ; A580 A9 12                    ..
        jsr     entity_set_subtype                           ; A582 20 98 EA                  ..
        lda     #$1E                            ; A585 A9 1E                    ..
        sta     $0468,x                         ; A587 9D 68 04                 .h.
LA58A:  lda     #$55                            ; A58A A9 55                    .U
        sta     $0588,x                         ; A58C 9D 88 05                 ...
        lda     #$A4                            ; A58F A9 A4                    ..
        sta     $05A0,x                         ; A591 9D A0 05                 ...
LA594:  rts                                     ; A594 60                       `

; --- LA595: Gyro Man's projectile spawner — type from $0E ($6F blade / $80
; falling gyro), speed from $0F, preset $18 with dir $51/$52 by facing
LA595:  jsr     find_free_slot_y                           ; A595 20 6F F1                  o.
        bcs     LA594                           ; A598 B0 FA                    ..
        lda     #$91                            ; A59A A9 91                    ..
        sta     $0408,y                         ; A59C 99 08 04                 ...
        lda     $0E                             ; A59F A5 0E                    ..
        sta     $0300,y                         ; A5A1 99 00 03                 ...
        lda     $0420,x                         ; A5A4 BD 20 04                 . .
        sta     $0420,y                         ; A5A7 99 20 04                 . .
        and     #$01                            ; A5AA 29 01                    ).
        clc                                     ; A5AC 18                       .
        adc     #$51                            ; A5AD 69 51                    iQ
        sta     $10                             ; A5AF 85 10                    ..
        lda     #$18                            ; A5B1 A9 18                    ..
        jsr     entity_speed_preset                           ; A5B3 20 F5 EA                  ..
        lda     $0528,y                         ; A5B6 B9 28 05                 .(.
        ora     #$10                            ; A5B9 09 10                    ..
        sta     $0528,y                         ; A5BB 99 28 05                 .(.
        lda     $0F                             ; A5BE A5 0F                    ..
        sta     $03F0,y                         ; A5C0 99 F0 03                 ...
        sta     $03C0,y                         ; A5C3 99 C0 03                 ...
        lda     #$00                            ; A5C6 A9 00                    ..
        sta     $03D8,y                         ; A5C8 99 D8 03                 ...
        sta     $03A8,y                         ; A5CB 99 A8 03                 ...
        tya                                     ; A5CE 98                       .
        sta     $0480,x                         ; A5CF 9D 80 04                 ...
        rts                                     ; A5D2 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $6F — Gyro Attack blade: flies straight ahead until it
; passes the player's X, then after a $14-frame beat turns 90 degrees
; (up or down toward the player) and continues vertically.
; =============================================================================
        jsr     entity_facing_dispatch                           ; A5D3 20 65 EA                  e.
        ldy     $0330,x                         ; A5D6 BC 30 03                 .0.
        lda     $0420,x                         ; A5D9 BD 20 04                 . .
        and     #$01                            ; A5DC 29 01                    ).
        beq     LA5E7                           ; A5DE F0 07                    ..
        cpy     $0330                           ; A5E0 CC 30 03                 .0.
        bcc     LA61F                           ; A5E3 90 3A                    .:
        bcs     LA5EC                           ; A5E5 B0 05                    ..
LA5E7:  cpy     $0330                           ; A5E7 CC 30 03                 .0.
        bcs     LA61F                           ; A5EA B0 33                    .3
LA5EC:  ldy     #$08                            ; A5EC A0 08                    ..
        lda     $0378,x                         ; A5EE BD 78 03                 .x.
        cmp     $0378                           ; A5F1 CD 78 03                 .x.
        bcs     LA600                           ; A5F4 B0 0A                    ..
        lda     $0528,x                         ; A5F6 BD 28 05                 .(.
        and     #$EF                            ; A5F9 29 EF                    ).
        sta     $0528,x                         ; A5FB 9D 28 05                 .(.
        ldy     #$04                            ; A5FE A0 04                    ..
LA600:  tya                                     ; A600 98                       .
        sta     $0420,x                         ; A601 9D 20 04                 . .
        lda     #$13                            ; A604 A9 13                    ..
        sta     $0588,x                         ; A606 9D 88 05                 ...
        lda     #$A6                            ; A609 A9 A6                    ..
        sta     $05A0,x                         ; A60B 9D A0 05                 ...
        lda     #$14                            ; A60E A9 14                    ..
        sta     $0468,x                         ; A610 9D 68 04                 .h.
        lda     $0468,x                         ; A613 BD 68 04                 .h.
        beq     LA61C                           ; A616 F0 04                    ..
        dec     $0468,x                         ; A618 DE 68 04                 .h.
        rts                                     ; A61B 60                       `

; ----------------------------------------------------------------------------
LA61C:  jsr     entity_vert_dispatch_raw                           ; A61C 20 86 EA                  ..
LA61F:  rts                                     ; A61F 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $80 — Gyro Man's falling gyro (dropped from the
; clouds): falls until level with the player, pauses $14 frames, then
; re-aims and flies horizontally at him.
; =============================================================================
        jsr     entity_move_down_collide                           ; A620 20 2A E9                  *.
        lda     $0378,x                         ; A623 BD 78 03                 .x.
        cmp     $0378                           ; A626 CD 78 03                 .x.
        bcc     LA61F                           ; A629 90 F4                    ..
        lda     #$14                            ; A62B A9 14                    ..
        sta     $0468,x                         ; A62D 9D 68 04                 .h.
        lda     #$3A                            ; A630 A9 3A                    .:
        sta     $0588,x                         ; A632 9D 88 05                 ...
        lda     #$A6                            ; A635 A9 A6                    ..
        sta     $05A0,x                         ; A637 9D A0 05                 ...
        lda     $0468,x                         ; A63A BD 68 04                 .h.
        beq     LA647                           ; A63D F0 08                    ..
        dec     $0468,x                         ; A63F DE 68 04                 .h.
        bne     LA61F                           ; A642 D0 DB                    ..
        jsr     entity_set_facing                           ; A644 20 16 EC                  ..
LA647:  jmp     entity_facing_dispatch                           ; A647 4C 65 EA                 Le.

; ----------------------------------------------------------------------------
; $A64A-$A7FF: data, TBD (unreferenced in-bank)
        .byte   $FA,$D4,$FF,$1D,$FD,$6D,$F9,$75 ; A64A
        .byte   $FA,$7F,$F9,$FC,$DF,$5D,$9B,$7D ; A652
        .byte   $E7,$65,$F7,$BB,$CD,$9F,$FF,$D4 ; A65A
        .byte   $AD,$5E,$8D,$F7,$FF,$5D,$DF,$B4 ; A662
        .byte   $BB,$45,$FD,$47,$CE,$55,$AD,$51 ; A66A
        .byte   $DD,$D4,$F3,$65,$9F,$76,$4F,$15 ; A672
        .byte   $7E,$53,$FF,$67,$BF,$55,$DA,$75 ; A67A
        .byte   $FF,$D5,$FF,$55,$9F,$F4,$BF,$FD ; A682
        .byte   $A7,$77,$1D,$53,$2E,$91,$FF,$45 ; A68A
        .byte   $FC,$D5,$AF,$C5,$FF,$7C,$FF,$7C ; A692
        .byte   $BE,$97,$FA,$76,$DF,$55,$FB,$77 ; A69A
        .byte   $FF,$5F,$9F,$DC,$FE,$7D,$FE,$55 ; A6A2
        .byte   $FF,$75,$7F,$95,$FD,$55,$FD,$74 ; A6AA
        .byte   $3D,$55,$3B,$FD,$BF,$97,$FF,$5F ; A6B2
        .byte   $F7,$77,$7F,$B7,$FD,$5F,$7D,$DF ; A6BA
        .byte   $5D,$57,$E2,$95,$5F,$55,$EB,$75 ; A6C2
        .byte   $8F,$DB,$BF,$F7,$DF,$4D,$6B,$55 ; A6CA
        .byte   $BE,$4F,$BE,$57,$F9,$E4,$EF,$DD ; A6D2
        .byte   $7F,$15,$E1,$C5,$FF,$37,$7E,$CF ; A6DA
        .byte   $FF,$57,$EF,$77,$BF,$5D,$FC,$55 ; A6E2
        .byte   $FB,$77,$FF,$D5,$FF,$9D,$7F,$7D ; A6EA
        .byte   $FB,$55,$F7,$3D,$F9,$35,$F7,$17 ; A6F2
        .byte   $FD,$53,$FE,$74,$D9,$D5,$5E,$5D ; A6FA
        .byte   $CB,$56,$EB,$5D,$7F,$57,$F6,$59 ; A702
        .byte   $CF,$D5,$E9,$53,$BB,$59,$EE,$BF ; A70A
        .byte   $FD,$66,$FE,$5B,$D6,$11,$F2,$F5 ; A712
        .byte   $DE,$F9,$FB,$7C,$3B,$E2,$FE,$75 ; A71A
        .byte   $FF,$57,$7B,$D4,$FF,$7D,$CD,$55 ; A722
        .byte   $FF,$E4,$FB,$D7,$F7,$7F,$6F,$7F ; A72A
        .byte   $FB,$5D,$B7,$5B,$FF,$55,$7D,$3F ; A732
        .byte   $AF,$7D,$BD,$79,$9F,$77,$7F,$54 ; A73A
        .byte   $FE,$5C,$EE,$55,$FE,$57,$FF,$77 ; A742
        .byte   $BF,$78,$D7,$57,$FF,$75,$7F,$94 ; A74A
        .byte   $BB,$F1,$F9,$5F,$CF,$D4,$F3,$D5 ; A752
        .byte   $3D,$01,$BE,$77,$F2,$AF,$BF,$75 ; A75A
        .byte   $77,$55,$98,$51,$F6,$55,$EF,$75 ; A762
        .byte   $FF,$77,$FF,$5F,$F7,$07,$FD,$DD ; A76A
        .byte   $DF,$4F,$AF,$BE,$FF,$1F,$5E,$34 ; A772
        .byte   $EF,$F5,$FF,$77,$FE,$55,$FF,$55 ; A77A
        .byte   $B9,$4D,$BB,$D5,$F7,$75,$D6,$FF ; A782
        .byte   $E7,$55,$3C,$1D,$FD,$D5,$7E,$55 ; A78A
        .byte   $AB,$6D,$CB,$54,$6F,$7D,$DF,$51 ; A792
        .byte   $FE,$FF,$FB,$51,$DF,$D9,$FF,$55 ; A79A
        .byte   $FF,$45,$FF,$71,$FB,$79,$67,$4D ; A7A2
        .byte   $FE,$17,$FF,$DB,$7F,$55,$FB,$55 ; A7AA
        .byte   $9E,$DD,$FF,$41,$B8,$7C,$7F,$55 ; A7B2
        .byte   $7E,$7D,$EC,$37,$79,$D9,$BF,$D5 ; A7BA
        .byte   $9E,$77,$FE,$57,$E2,$45,$FA,$C7 ; A7C2
        .byte   $FE,$D3,$FE,$D5,$DB,$D7,$EF,$55 ; A7CA
        .byte   $EE,$DF,$DD,$14,$BF,$4D,$7E,$BD ; A7D2
        .byte   $F6,$FF,$7F,$55,$1D,$DD,$FF,$5D ; A7DA
        .byte   $DF,$DD,$FF,$DF,$DF,$17,$F9,$D3 ; A7E2
        .byte   $FF,$B5,$FF,$E7,$B7,$D5,$FD,$D8 ; A7EA
        .byte   $FF,$57,$EF,$D9,$FF,$DE,$FB,$25 ; A7F2
        .byte   $5E,$86,$FE,$D5,$EB,$7D ; A7FA
; --- $A800: DAMAGE TABLE, weapon $6 (Power Stone) ---
; $A800[ent_type] via damage_engine $1C:809D; low 7 bits = damage,
; bit 7 = special handling; $00 = ricochet. Types $00-$CF.
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A800  types $00-$0F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$00 ; A810  types $10-$1F
        .byte   $01,$01,$00,$00,$00,$01,$00,$00,$01,$01,$01,$01,$00,$01,$00,$00 ; A820  types $20-$2F
        .byte   $00,$01,$01,$01,$01,$00,$01,$00,$00,$01,$01,$01,$00,$00,$01,$00 ; A830  types $30-$3F
        .byte   $03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 ; A840  types $40-$4F
        .byte   $01,$01,$01,$01,$01,$01,$01,$00,$00,$02,$01,$00,$01,$02,$00,$00 ; A850  types $50-$5F
        .byte   $01,$00,$01,$01,$01,$01,$01,$01,$01,$01,$00,$04,$00,$00,$01,$00 ; A860  types $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$00,$00,$00 ; A870  types $70-$7F
        .byte   $00,$01,$00,$01,$00,$00,$01,$00,$00,$01,$00,$00,$00,$01,$00,$00 ; A880  types $80-$8F
        .byte   $00,$01,$00,$01,$00,$00,$01,$01,$02,$00,$00,$00,$01,$00,$01,$01 ; A890  types $90-$9F
        .byte   $00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8A0  types $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$02,$00 ; A8B0  types $B0-$BF
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8C0  types $C0-$CF
; --- $A8D0: remainder (beyond type $CF) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8F0

; =============================================================================
; NAPALM MAN STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $A900: screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; A900  screens $00-$0F
        .byte   $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$00,$0C ; A910  screens $10-$1F
        .byte   $A0,$00,$00,$80,$00,$00,$08,$81,$08,$10,$00,$00,$02,$00,$02,$54 ; A920  screens $20-$2F
        .byte   $00,$00,$00,$04,$80,$30,$20,$80,$00,$01,$20,$08,$08,$22,$08,$84 ; A930  screens $30-$3F
        .byte   $08,$00,$08,$00,$00,$02,$00,$A0,$00,$00,$00,$62,$00,$40,$08,$80 ; A940  screens $40-$4F
; --- $A950: section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $23,$40,$60,$22,$20,$A0,$23,$80,$A2,$40,$62,$40,$62,$20,$20,$00 ; A950
        .byte   $00,$20,$00,$04,$08,$01,$00,$50 ; A960
; --- $A968: per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $22,$22,$1C,$24,$00,$00,$15,$16,$2B,$1C,$25,$00,$24,$80,$B9,$00 ; A968
        .byte   $82,$42,$00,$E1,$00,$03,$00,$08 ; A978
; --- $A980: BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $98,$9A,$20,$00,$28,$00,$00,$20 ; A980
; --- $A988: palette sets, 20 bytes each [16 BG palette + 4 palette-cycle
; seeds]: set n at +20n; set 0 is loaded by stage_load, later sets are
; switched per section by the bank $00 environment service
; ($A968 attr bits 0-5 -> $00:809E records, ctl bit 7) ---
        .byte   $0F,$29,$19,$0B,$0F,$27,$17,$0B,$0F,$39,$27,$18,$0F,$24,$14,$03 ; A988
        .byte   $00,$00,$00,$00,$0F,$3C,$2C,$20 ; A998
        .byte   $0F,$1C,$10,$2C,$0F,$39,$27,$18,$0F,$24,$14,$03,$9B,$9C,$00,$00 ; A9A0
        .byte   $0F,$38,$27,$18,$0F,$27,$19,$0B,$0F,$39,$27,$18,$0F,$24,$14,$03 ; A9B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$10,$88,$88,$00,$24,$02,$01,$80,$00 ; A9C0
        .byte   $00,$44,$A2,$01,$00,$28,$00,$60,$03,$00,$22,$10,$20,$C4,$00,$98 ; A9D0
; --- $A9E0: screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$48,$20,$19,$20,$99,$00,$04,$80,$00,$00,$8A,$08,$00,$00,$00 ; A9E0  terminator / filler
        .byte   $08,$18,$08,$00,$08,$48,$00,$04,$00,$16,$2A,$03,$00,$41,$00 ; A9F0  
        .byte   $C0                             ; A9FF  -1 base for the spawn arrays
; --- $AA00: spawn screens (ascending) ---
        .byte   $00,$01,$01,$02,$03,$03,$04,$04,$05,$05,$05,$05,$06,$09,$0A,$0B ; AA00  entries $00-$0F
        .byte   $0B,$0C,$0C,$0C,$0C,$0D,$0D,$0D,$0E,$0E,$0E,$0E,$0E,$0F,$10,$11 ; AA10  entries $10-$1F
        .byte   $11,$11,$12,$12,$12,$13,$13,$13,$14,$15,$15,$15,$15,$16,$16,$16 ; AA20  entries $20-$2F
        .byte   $16,$16,$18,$18,$18,$19,$1A,$1A,$1A,$1C,$FF,$10,$00,$EB,$02,$90 ; AA30  entries $30-$3F
        .byte   $00,$00,$08,$00,$00,$00,$00,$00,$00,$84,$80,$10,$00,$51,$00,$41 ; AA40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$50,$88,$00,$08,$08,$08,$08,$80,$38,$08,$90 ; AA50  entries $50-$5F
        .byte   $00,$20,$80,$00,$00,$00,$00,$20,$08,$17,$A0,$57,$80,$00,$08,$40 ; AA60  entries $60-$6F
        .byte   $00,$03,$08,$86,$00,$00,$08,$05,$08,$02,$00,$00,$80,$82,$A0,$04 ; AA70  entries $70-$7F
; --- $AA80: spawn X px ---
        .byte   $00,$20,$E0,$70,$01,$A8,$58,$C1,$70,$90,$B0,$D0,$E4,$00,$30,$A0 ; AA80  entries $00-$0F
        .byte   $FF,$40,$60,$A0,$F0,$50,$A0,$AF,$10,$30,$58,$80,$C0,$60,$00,$00 ; AA90  entries $10-$1F
        .byte   $00,$20,$00,$54,$B8,$B0,$B1,$D0,$00,$10,$70,$D0,$E0,$20,$D0,$D1 ; AAA0  entries $20-$2F
        .byte   $D2,$F0,$50,$B0,$E0,$30,$10,$40,$70,$D8,$FF,$00,$00,$00,$00,$40 ; AAB0  entries $30-$3F
        .byte   $08,$10,$00,$01,$00,$01,$02,$01,$00,$B4,$00,$20,$00,$14,$00,$1C ; AAC0  entries $40-$4F
        .byte   $00,$48,$82,$00,$80,$40,$20,$00,$00,$00,$20,$10,$80,$20,$00,$5A ; AAD0  entries $50-$5F
        .byte   $00,$10,$00,$80,$02,$14,$00,$03,$00,$40,$20,$40,$00,$60,$20,$20 ; AAE0  entries $60-$6F
        .byte   $80,$28,$00,$97,$A0,$40,$08,$00,$0A,$08,$20,$42,$00,$02,$08,$80 ; AAF0  entries $70-$7F
; --- $AB00: spawn Y px ---
        .byte   $00,$A4,$94,$B4,$94,$64,$94,$98,$80,$48,$68,$B0,$A8,$00,$98,$98 ; AB00  entries $00-$0F
        .byte   $78,$B8,$18,$A8,$A8,$28,$38,$98,$48,$48,$78,$78,$40,$78,$00,$00 ; AB10  entries $10-$1F
        .byte   $00,$B0,$00,$80,$B8,$B0,$60,$B8,$00,$B0,$A8,$98,$A8,$B4,$80,$90 ; AB20  entries $20-$2F
        .byte   $A0,$B0,$E0,$E0,$B0,$90,$E0,$E0,$E0,$00,$FF,$08,$02,$00,$80,$00 ; AB30  entries $30-$3F
        .byte   $00,$08,$00,$48,$00,$40,$80,$A0,$00,$20,$00,$0E,$00,$00,$02,$21 ; AB40  entries $40-$4F
        .byte   $80,$80,$00,$02,$02,$01,$00,$40,$00,$30,$00,$81,$02,$90,$00,$20 ; AB50  entries $50-$5F
        .byte   $00,$11,$00,$12,$02,$04,$00,$10,$40,$80,$00,$30,$00,$08,$02,$00 ; AB60  entries $60-$6F
        .byte   $00,$80,$00,$00,$28,$20,$A0,$01,$08,$00,$00,$28,$00,$10,$00,$94 ; AB70  entries $70-$7F
; --- $AB80: spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $D3,$04,$04,$04,$04,$04,$04,$84,$08,$34,$34,$08,$4C,$D5,$81,$32 ; AB80  entries $00-$0F
        .byte   $32,$32,$0D,$32,$32,$32,$32,$32,$32,$32,$32,$32,$0D,$80,$DF,$D2 ; AB90  entries $10-$1F
        .byte   $E1,$1B,$E0,$1B,$8E,$08,$08,$83,$E2,$37,$37,$37,$37,$0C,$37,$37 ; ABA0  entries $20-$2F
        .byte   $37,$37,$10,$10,$16,$16,$10,$10,$10,$68,$FF,$80,$28,$00,$08,$98 ; ABB0  entries $30-$3F
        .byte   $20,$00,$00,$80,$20,$01,$80,$04,$80,$00,$00,$40,$00,$08,$80,$00 ; ABC0  entries $40-$4F
        .byte   $08,$12,$00,$00,$00,$02,$00,$01,$80,$00,$08,$04,$00,$08,$88,$90 ; ABD0  entries $50-$5F
        .byte   $80,$10,$A8,$00,$00,$20,$00,$00,$00,$11,$00,$00,$00,$00,$00,$40 ; ABE0  entries $60-$6F
        .byte   $80,$00,$82,$20,$00,$30,$20,$A1,$20,$68,$00,$02,$02,$01,$82,$44 ; ABF0  entries $70-$7F
; --- $AC00: per-screen spawn-list start index ---
        .byte   $00,$01,$03,$04,$06,$08,$0C,$0D,$0D,$0D,$0E,$0F,$11,$15,$18,$1D ; AC00  screens $00-$0F
        .byte   $1E,$1F,$22,$25,$28,$29,$2D,$32,$32,$35,$36,$39,$39,$04,$00,$00 ; AC10  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00 ; AC20  screens $20-$2F
        .byte   $20,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC30  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC40  screens $40-$4F
        .byte   $40,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$80,$00 ; AC50  screens $50-$5F
        .byte   $00,$00,$00,$00,$40,$00,$00,$00,$80,$00,$00,$00,$00,$C0,$00,$00 ; AC60  screens $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$01 ; AC70  screens $70-$7F
        .byte   $00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC80  screens $80-$8F
        .byte   $00,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC90  screens $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACA0  screens $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$02,$04,$00,$00,$00,$00,$40,$00 ; ACB0  screens $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACD0  screens $D0-$DF
        .byte   $00,$00,$00,$00,$00,$50,$00,$00,$00,$00,$00,$00,$00,$00,$08,$01 ; ACE0  screens $E0-$EF
        .byte   $02,$00,$40,$00,$00,$40,$00,$40,$00,$00,$00,$00,$00,$00,$01,$40 ; ACF0  screens $F0-$FF
; --- $AD00: metatile top-left tile ids ---
        .byte   $00,$03,$82,$82,$86,$70,$73,$03,$03,$91,$93,$95,$97,$60,$63,$65 ; AD00  metatiles $00-$0F
        .byte   $03,$B1,$B3,$B5,$03,$CC,$CE,$01,$03,$D1,$D3,$D5,$AC,$AE,$00,$00 ; AD10  metatiles $10-$1F
        .byte   $01,$F1,$F3,$03,$BC,$BE,$20,$22,$12,$12,$EB,$01,$EF,$ED,$40,$42 ; AD20  metatiles $20-$2F
        .byte   $10,$10,$0A,$0A,$00,$54,$00,$0E,$12,$12,$10,$00,$BB,$56,$C9,$E9 ; AD30  metatiles $30-$3F
        .byte   $00,$10,$20,$22,$00,$00,$12,$12,$12,$12,$40,$42,$20,$22,$42,$00 ; AD40  metatiles $40-$4F
        .byte   $04,$00,$2C,$2E,$2A,$0C,$4A,$00,$14,$15,$4C,$4E,$EB,$86,$28,$66 ; AD50  metatiles $50-$5F
        .byte   $70,$72,$58,$5A,$5A,$78,$7B,$6C,$6E,$98,$9A,$78,$78,$48,$49,$00 ; AD60  metatiles $60-$6F
        .byte   $00,$00,$00,$EA,$06,$36,$8E,$67,$04,$15,$1A,$00,$27,$02,$00,$F9 ; AD70  metatiles $70-$7F
        .byte   $09,$4A,$24,$25,$25,$00,$9D,$BB,$CB,$00,$CF,$00,$EE,$00,$01,$03 ; AD80  metatiles $80-$8F
        .byte   $CC,$5A,$58,$5A,$5A,$E9,$F8,$00,$0E,$20,$22,$40,$42,$A1,$00,$DB ; AD90  metatiles $90-$9F
        .byte   $00,$00,$00,$F7,$00,$F7,$00,$00,$00,$C8,$C9,$00,$00,$00,$00,$00 ; ADA0  metatiles $A0-$AF
        .byte   $00,$EA,$EA,$00,$00,$00,$00,$00,$EA,$7D,$7F,$00,$EA,$00,$00,$00 ; ADB0  metatiles $B0-$BF
        .byte   $EA,$EA,$00,$EA,$60,$EA,$CA,$EA,$EA,$68,$00,$EA,$00,$EA,$EA,$00 ; ADC0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADD0  metatiles $D0-$DF
        .byte   $EA,$EA,$00,$EA,$60,$EA,$CA,$EA,$EA,$68,$00,$EA,$00,$EA,$EA,$00 ; ADE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$EA,$58,$00,$EA,$EA,$EA,$EA,$EA ; ADF0  metatiles $F0-$FF
; --- $AE00: metatile bottom-left tile ids ---
        .byte   $00,$03,$83,$83,$87,$71,$74,$03,$03,$92,$03,$96,$03,$74,$74,$00 ; AE00  metatiles $00-$0F
        .byte   $B0,$B2,$B4,$B6,$03,$CD,$CF,$EF,$D0,$D2,$D4,$D6,$AD,$AF,$00,$00 ; AE10  metatiles $10-$1F
        .byte   $01,$F2,$F4,$F6,$BD,$BF,$21,$23,$11,$11,$01,$01,$03,$EE,$41,$43 ; AE20  metatiles $20-$2F
        .byte   $11,$11,$0B,$0B,$E7,$55,$00,$0F,$11,$11,$11,$00,$00,$57,$CA,$00 ; AE30  metatiles $30-$3F
        .byte   $00,$11,$21,$23,$00,$00,$13,$13,$13,$13,$41,$43,$21,$23,$EA,$00 ; AE40  metatiles $40-$4F
        .byte   $05,$00,$2D,$2F,$2B,$0D,$4B,$00,$14,$00,$4D,$4F,$01,$B7,$29,$AF ; AE50  metatiles $50-$5F
        .byte   $71,$74,$59,$59,$5B,$79,$7B,$6D,$6F,$99,$9B,$79,$79,$03,$49,$00 ; AE60  metatiles $60-$6F
        .byte   $15,$00,$00,$00,$36,$36,$8F,$67,$05,$05,$1B,$00,$02,$9C,$00,$F9 ; AE70  metatiles $70-$7F
        .byte   $29,$4B,$25,$25,$16,$00,$9E,$CB,$00,$CE,$CE,$ED,$ED,$64,$64,$03 ; AE80  metatiles $80-$8F
        .byte   $CD,$59,$59,$59,$5B,$F7,$E9,$00,$0F,$21,$23,$41,$43,$D7,$DB,$00 ; AE90  metatiles $90-$9F
        .byte   $F8,$00,$00,$00,$E7,$E7,$00,$00,$D9,$D8,$E8,$00,$00,$00,$00,$00 ; AEA0  metatiles $A0-$AF
        .byte   $EA,$EA,$00,$00,$00,$00,$00,$00,$EA,$EA,$EA,$EA,$EA,$00,$00,$00 ; AEB0  metatiles $B0-$BF
        .byte   $A1,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$C1,$EA,$EA,$00,$EA,$EA,$EA,$EA ; AEC0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AED0  metatiles $D0-$DF
        .byte   $A1,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$C1,$EA,$EA,$00,$EA,$EA,$EA,$EA ; AEE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA ; AEF0  metatiles $F0-$FF
; --- $AF00: metatile top-right tile ids ---
        .byte   $00,$90,$80,$84,$86,$73,$00,$70,$03,$03,$A3,$A5,$A7,$61,$65,$65 ; AF00  metatiles $00-$0F
        .byte   $03,$C1,$C3,$C5,$C7,$DC,$DE,$01,$03,$E1,$E3,$E5,$BC,$BE,$AC,$AE ; AF10  metatiles $10-$1F
        .byte   $01,$A0,$80,$03,$03,$03,$30,$32,$50,$52,$FB,$FD,$FF,$03,$50,$52 ; AF20  metatiles $20-$2F
        .byte   $50,$52,$0A,$0A,$00,$46,$B9,$1E,$30,$32,$30,$00,$CB,$48,$D9,$00 ; AF30  metatiles $30-$3F
        .byte   $00,$32,$44,$44,$00,$00,$32,$50,$30,$52,$44,$44,$44,$44,$52,$00 ; AF40  metatiles $40-$4F
        .byte   $04,$04,$3C,$3E,$3A,$1C,$18,$00,$04,$15,$5C,$5E,$03,$76,$09,$BD ; AF50  metatiles $50-$5F
        .byte   $72,$00,$68,$6A,$6A,$88,$8B,$7C,$7E,$A8,$AA,$88,$7E,$49,$49,$04 ; AF60  metatiles $60-$6F
        .byte   $00,$15,$00,$00,$17,$02,$9D,$F0,$14,$15,$1A,$00,$37,$38,$00,$FA ; AF70  metatiles $70-$7F
        .byte   $09,$4A,$34,$35,$35,$00,$08,$8E,$8F,$00,$DF,$00,$8A,$00,$01,$EC ; AF80  metatiles $80-$8F
        .byte   $DC,$6A,$68,$6A,$6A,$E9,$F7,$00,$1E,$30,$32,$50,$52,$A1,$00,$DB ; AF90  metatiles $90-$9F
        .byte   $00,$B8,$F8,$A1,$E7,$A1,$00,$00,$00,$00,$D9,$00,$00,$00,$00,$00 ; AFA0  metatiles $A0-$AF
        .byte   $00,$EA,$EA,$00,$00,$00,$00,$00,$8B,$EA,$EA,$EA,$EA,$00,$00,$00 ; AFB0  metatiles $B0-$BF
        .byte   $EA,$58,$00,$EA,$EA,$EA,$EA,$EA,$EA,$78,$EA,$00,$00,$EA,$EA,$EA ; AFC0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFD0  metatiles $D0-$DF
        .byte   $EA,$58,$00,$EA,$EA,$EA,$EA,$EA,$EA,$78,$EA,$00,$00,$EA,$EA,$EA ; AFE0  metatiles $E0-$EF
        .byte   $EA,$EA,$00,$EA,$60,$EA,$CA,$EA,$EA,$68,$00,$EA,$00,$EA,$EA,$00 ; AFF0  metatiles $F0-$FF
; --- $B000: metatile bottom-right tile ids ---
        .byte   $00,$94,$81,$85,$B7,$74,$00,$71,$03,$A2,$A4,$A6,$03,$62,$00,$00 ; B000  metatiles $00-$0F
        .byte   $C0,$C2,$C4,$C6,$03,$DD,$DF,$EF,$E0,$E2,$E4,$E6,$BD,$BF,$AD,$AF ; B010  metatiles $10-$1F
        .byte   $01,$03,$81,$03,$03,$03,$31,$33,$51,$53,$FC,$FE,$03,$03,$51,$53 ; B020  metatiles $20-$2F
        .byte   $51,$53,$0B,$0B,$F7,$47,$BA,$1F,$31,$33,$31,$00,$00,$49,$DA,$00 ; B030  metatiles $30-$3F
        .byte   $00,$33,$45,$45,$00,$00,$33,$51,$31,$53,$45,$45,$45,$45,$EA,$00 ; B040  metatiles $40-$4F
        .byte   $05,$05,$3D,$3F,$3B,$1D,$19,$00,$05,$00,$5D,$5F,$EB,$77,$29,$BF ; B050  metatiles $50-$5F
        .byte   $74,$00,$69,$69,$6B,$89,$8B,$7D,$7F,$A9,$AB,$89,$7F,$48,$49,$04 ; B060  metatiles $60-$6F
        .byte   $15,$00,$15,$00,$02,$8C,$9E,$F5,$14,$05,$1B,$00,$38,$8D,$00,$FA ; B070  metatiles $70-$7F
        .byte   $29,$4B,$35,$35,$26,$07,$75,$8E,$00,$DE,$DE,$7A,$7A,$64,$64,$EC ; B080  metatiles $80-$8F
        .byte   $DD,$69,$69,$69,$6B,$F8,$E9,$00,$1F,$31,$33,$51,$53,$D7,$DB,$00 ; B090  metatiles $90-$9F
        .byte   $C9,$00,$D8,$F7,$D7,$D7,$00,$00,$00,$E8,$00,$00,$00,$00,$00,$00 ; B0A0  metatiles $A0-$AF
        .byte   $EA,$EA,$EA,$00,$00,$00,$00,$00,$8C,$EA,$EA,$EA,$00,$00,$00,$00 ; B0B0  metatiles $B0-$BF
        .byte   $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$79,$00,$00,$EA,$EA,$EA,$EA ; B0C0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0D0  metatiles $D0-$DF
        .byte   $EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$79,$00,$00,$EA,$EA,$EA,$EA ; B0E0  metatiles $E0-$EF
        .byte   $A1,$EA,$EA,$EA,$EA,$EA,$EA,$EA,$C1,$EA,$EA,$00,$EA,$EA,$EA,$EA ; B0F0  metatiles $F0-$FF
; --- $B100: metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$00,$01,$01,$01,$01,$01,$01,$01,$00,$00,$00,$00,$01,$01,$01 ; B100  metatiles $00-$0F
        .byte   $00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$01,$01,$01,$01 ; B110  metatiles $10-$1F
        .byte   $01,$00,$01,$00,$01,$01,$12,$12,$12,$12,$01,$01,$01,$01,$12,$12 ; B120  metatiles $20-$2F
        .byte   $12,$12,$22,$42,$03,$03,$03,$F3,$12,$12,$12,$02,$04,$03,$03,$03 ; B130  metatiles $30-$3F
        .byte   $02,$12,$12,$12,$02,$03,$12,$12,$12,$12,$12,$12,$12,$12,$12,$00 ; B140  metatiles $40-$4F
        .byte   $02,$02,$10,$10,$10,$F3,$10,$00,$02,$02,$10,$13,$01,$01,$10,$01 ; B150  metatiles $50-$5F
        .byte   $01,$01,$72,$72,$52,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$02 ; B160  metatiles $60-$6F
        .byte   $02,$02,$02,$01,$13,$13,$02,$10,$02,$02,$03,$00,$13,$13,$03,$10 ; B170  metatiles $70-$7F
        .byte   $10,$10,$02,$02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$03,$03,$00 ; B180  metatiles $80-$8F
        .byte   $01,$52,$12,$12,$12,$03,$03,$03,$F2,$62,$62,$62,$62,$03,$03,$03 ; B190  metatiles $90-$9F
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; B1A0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1B0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$50,$50,$00,$00,$00,$00,$00,$00,$50,$50,$00 ; B1C0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$50,$50,$00,$00,$00,$00,$00,$00,$50,$50,$00 ; B1D0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$50,$50,$00,$00,$00,$00,$00,$00,$50,$50,$00 ; B1E0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$50,$50,$00,$00,$00,$00,$00,$00,$50,$50,$00 ; B1F0  metatiles $F0-$FF
; --- $B200: 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $08,$09,$10,$11,$0A,$0B,$12,$13,$0C,$08,$14,$08,$5C,$20,$08,$2A ; B200  blocks $00-$03
        .byte   $20,$17,$2B,$2C,$08,$01,$08,$09,$08,$08,$0A,$0B,$08,$08,$0C,$08 ; B210  blocks $04-$07
        .byte   $18,$19,$08,$21,$1A,$1B,$22,$23,$10,$11,$18,$19,$12,$13,$1A,$1B ; B220  blocks $08-$0B
        .byte   $14,$08,$08,$01,$08,$08,$08,$08,$02,$08,$02,$08,$14,$08,$08,$08 ; B230  blocks $0C-$0F
        .byte   $08,$21,$08,$08,$22,$23,$02,$08,$08,$07,$60,$61,$03,$07,$04,$0E ; B240  blocks $10-$13
        .byte   $07,$21,$0D,$05,$22,$23,$03,$07,$08,$08,$07,$60,$08,$08,$05,$07 ; B250  blocks $14-$17
        .byte   $02,$08,$03,$07,$00,$00,$1C,$1D,$04,$0F,$5D,$5F,$04,$0E,$5D,$5F ; B260  blocks $18-$1B
        .byte   $06,$00,$1D,$1D,$00,$0D,$1E,$1D,$05,$05,$1D,$1D,$08,$08,$15,$15 ; B270  blocks $1C-$1F
        .byte   $02,$08,$02,$15,$24,$08,$08,$08,$02,$08,$3A,$39,$08,$08,$38,$39 ; B280  blocks $20-$23
        .byte   $28,$29,$26,$27,$2E,$2F,$26,$27,$08,$08,$08,$07,$03,$61,$5D,$1D ; B290  blocks $24-$27
        .byte   $05,$61,$1D,$1D,$02,$08,$38,$39,$02,$08,$38,$46,$24,$31,$08,$27 ; B2A0  blocks $28-$2B
        .byte   $28,$2F,$26,$27,$49,$08,$9B,$08,$2E,$29,$26,$27,$28,$49,$26,$27 ; B2B0  blocks $2C-$2F
        .byte   $8F,$8F,$98,$98,$3A,$49,$26,$27,$8F,$31,$98,$27,$08,$08,$08,$41 ; B2C0  blocks $30-$33
        .byte   $05,$61,$1E,$1D,$03,$31,$5D,$27,$8F,$8F,$00,$00,$00,$00,$00,$00 ; B2D0  blocks $34-$37
        .byte   $26,$27,$2E,$2F,$26,$27,$4A,$4B,$A1,$A2,$A9,$AA,$00,$A0,$00,$A8 ; B2E0  blocks $38-$3B
        .byte   $3D,$35,$00,$3D,$36,$3D,$3E,$00,$35,$3D,$3D,$36,$3F,$00,$00,$00 ; B2F0  blocks $3C-$3F
        .byte   $00,$3E,$00,$3F,$00,$00,$00,$31,$00,$00,$28,$29,$00,$4D,$00,$3D ; B300  blocks $40-$43
        .byte   $42,$27,$00,$2F,$00,$27,$00,$2F,$3A,$39,$2E,$2F,$48,$00,$2E,$31 ; B310  blocks $44-$47
        .byte   $00,$41,$28,$2F,$38,$27,$2E,$2F,$2E,$2F,$4C,$4D,$00,$00,$A5,$A3 ; B320  blocks $48-$4B
        .byte   $9D,$9D,$28,$29,$A5,$A3,$28,$29,$00,$00,$38,$46,$00,$00,$38,$39 ; B330  blocks $4C-$4F
        .byte   $00,$00,$48,$00,$4A,$4B,$00,$00,$00,$00,$89,$8A,$8D,$8E,$8B,$8C ; B340  blocks $50-$53
        .byte   $4A,$4B,$89,$8A,$2E,$32,$26,$32,$4A,$32,$00,$32,$00,$00,$00,$41 ; B350  blocks $54-$57
        .byte   $00,$32,$38,$39,$26,$00,$2E,$00,$26,$00,$4A,$00,$3D,$A2,$A8,$AA ; B360  blocks $58-$5B
        .byte   $99,$9A,$9B,$9C,$26,$4D,$2E,$00,$99,$00,$9B,$00,$00,$00,$A4,$A5 ; B370  blocks $5C-$5F
        .byte   $26,$A4,$2E,$9D,$9D,$9D,$9D,$9D,$26,$33,$2E,$32,$26,$32,$2E,$32 ; B380  blocks $60-$63
        .byte   $00,$6B,$00,$6B,$00,$65,$00,$65,$65,$00,$65,$00,$00,$00,$00,$67 ; B390  blocks $64-$67
        .byte   $00,$65,$68,$66,$65,$00,$66,$69,$00,$65,$6A,$65,$62,$63,$AA,$3D ; B3A0  blocks $68-$6B
        .byte   $A3,$6B,$9D,$6B,$A3,$65,$9D,$65,$91,$64,$AA,$3D,$65,$65,$65,$65 ; B3B0  blocks $6C-$6F
        .byte   $38,$39,$2E,$2F,$38,$46,$2E,$2F,$9D,$65,$9D,$65,$A4,$A3,$9D,$9D ; B3C0  blocks $70-$73
        .byte   $00,$00,$A3,$00,$9D,$A3,$9D,$9D,$65,$65,$6C,$66,$00,$00,$6A,$00 ; B3D0  blocks $74-$77
        .byte   $00,$6B,$30,$29,$00,$00,$00,$33,$00,$00,$92,$93,$00,$00,$93,$94 ; B3E0  blocks $78-$7B
        .byte   $00,$32,$00,$32,$00,$92,$00,$00,$93,$93,$A9,$00,$94,$A2,$A8,$AA ; B3F0  blocks $7C-$7F
        .byte   $00,$32,$28,$49,$00,$00,$A3,$A4,$00,$41,$00,$2F,$9D,$9F,$9D,$9F ; B400  blocks $80-$83
        .byte   $A4,$A5,$9D,$9D,$00,$32,$A3,$32,$47,$00,$26,$00,$47,$33,$26,$32 ; B410  blocks $84-$87
        .byte   $08,$5C,$08,$08,$20,$20,$2A,$2B,$17,$08,$2C,$08,$05,$07,$00,$0D ; B420  blocks $88-$8B
        .byte   $60,$07,$00,$0D,$00,$00,$1E,$1E,$00,$00,$1D,$1D,$24,$24,$90,$90 ; B430  blocks $8C-$8F
        .byte   $38,$33,$2E,$32,$08,$07,$05,$61,$24,$54,$90,$81,$00,$00,$37,$37 ; B440  blocks $90-$93
        .byte   $54,$00,$81,$37,$00,$54,$37,$81,$52,$53,$5A,$5B,$74,$75,$7C,$7D ; B450  blocks $94-$97
        .byte   $08,$08,$05,$05,$07,$07,$06,$0D,$60,$61,$00,$00,$00,$0D,$00,$00 ; B460  blocks $98-$9B
        .byte   $00,$00,$54,$54,$00,$00,$77,$77,$81,$81,$81,$81,$51,$5E,$50,$80 ; B470  blocks $9C-$9F
        .byte   $51,$51,$50,$50,$58,$58,$50,$50,$74,$54,$7C,$56,$50,$50,$50,$50 ; B480  blocks $A0-$A3
        .byte   $75,$74,$7D,$7C,$75,$5E,$7D,$80,$7F,$77,$51,$51,$75,$74,$7D,$54 ; B490  blocks $A4-$A7
        .byte   $75,$74,$7F,$7F,$75,$5E,$7F,$77,$74,$75,$7C,$54,$74,$56,$7F,$77 ; B4A0  blocks $A8-$AB
        .byte   $71,$00,$59,$00,$00,$72,$00,$70,$50,$50,$52,$53,$75,$56,$7D,$5E ; B4B0  blocks $AC-$AF
        .byte   $59,$00,$59,$00,$00,$70,$00,$70,$5A,$5B,$51,$51,$5A,$5B,$77,$7F ; B4C0  blocks $B0-$B3
        .byte   $74,$54,$7C,$81,$54,$75,$56,$7D,$75,$81,$7D,$81,$5E,$74,$77,$7F ; B4D0  blocks $B4-$B7
        .byte   $7F,$56,$7C,$5E,$5E,$7F,$5E,$7D,$7F,$7F,$7C,$7D,$74,$5E,$7C,$5E ; B4E0  blocks $B8-$BB
        .byte   $50,$50,$78,$78,$54,$74,$81,$7C,$75,$5E,$7D,$5E,$81,$75,$56,$7D ; B4F0  blocks $BC-$BF
        .byte   $5E,$74,$5E,$7C,$75,$81,$7D,$56,$5E,$75,$5E,$7D,$74,$75,$7F,$7F ; B500  blocks $C0-$C3
        .byte   $74,$54,$7F,$77,$7F,$7F,$51,$51,$75,$54,$7D,$81,$74,$81,$7C,$56 ; B510  blocks $C4-$C7
        .byte   $00,$00,$73,$00,$50,$50,$50,$77,$85,$86,$82,$83,$7F,$7F,$51,$54 ; B520  blocks $C8-$CB
        .byte   $50,$81,$50,$81,$50,$81,$78,$56,$50,$5E,$50,$5E,$87,$88,$83,$84 ; B530  blocks $CC-$CF
        .byte   $50,$50,$54,$50,$50,$54,$50,$81,$81,$50,$81,$50,$75,$74,$54,$7F ; B540  blocks $D0-$D3
        .byte   $81,$50,$77,$50,$50,$81,$50,$56,$56,$51,$77,$50,$51,$50,$50,$50 ; B550  blocks $D4-$D7
        .byte   $55,$55,$51,$51,$55,$50,$51,$50,$81,$51,$81,$50,$54,$75,$81,$7D ; B560  blocks $D8-$DB
        .byte   $81,$50,$56,$50,$81,$74,$56,$7C,$5E,$50,$5E,$50,$54,$50,$81,$50 ; B570  blocks $DC-$DF
        .byte   $50,$77,$50,$51,$79,$50,$79,$50,$74,$75,$54,$7C,$81,$74,$77,$7F ; B580  blocks $E0-$E3
        .byte   $75,$74,$54,$7C,$51,$51,$78,$78,$81,$75,$77,$7F,$54,$7F,$81,$7D ; B590  blocks $E4-$E7
        .byte   $7F,$54,$7C,$81,$54,$7F,$81,$7C,$77,$74,$7D,$7C,$75,$77,$7D,$7C ; B5A0  blocks $E8-$EB
        .byte   $7F,$54,$7D,$81,$77,$75,$7C,$7D,$74,$77,$7C,$7D,$74,$81,$7C,$81 ; B5B0  blocks $EC-$EF
        .byte   $74,$75,$54,$7D,$77,$7F,$51,$51,$7F,$7F,$51,$7A,$50,$54,$50,$56 ; B5C0  blocks $F0-$F3
        .byte   $50,$7A,$50,$7A,$54,$70,$81,$70,$81,$70,$81,$70,$7F,$7F,$71,$00 ; B5D0  blocks $F4-$F7
        .byte   $7F,$7F,$00,$00,$7F,$7F,$00,$72,$74,$75,$54,$7F,$74,$75,$7F,$54 ; B5E0  blocks $F8-$FB
        .byte   $51,$81,$50,$81,$77,$50,$51,$50,$74,$75,$7C,$7D,$00,$00,$00,$00 ; B5F0  blocks $FC-$FF
; --- $B600: screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$05,$06,$07,$0A,$0B,$0C ; B600
        .byte   $0D,$0E,$0A,$0B,$0F,$10,$11,$00,$12,$13,$14,$15,$16,$17,$18,$08 ; B610
        .byte   $19,$1A,$19,$1B,$1C,$1D,$1B,$1E,$1F,$20,$1F,$20,$1F,$21,$22,$23 ; B620
        .byte   $24,$24,$24,$24,$24,$24,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25 ; B630
; layout $01
        .byte   $0D,$00,$01,$02,$03,$04,$05,$06,$0D,$08,$09,$05,$06,$07,$0A,$0B ; B640
        .byte   $01,$02,$0E,$0A,$0B,$0F,$10,$11,$09,$12,$13,$14,$15,$26,$17,$18 ; B650
        .byte   $27,$19,$1A,$19,$1B,$28,$1D,$1B,$29,$23,$2A,$1F,$20,$1F,$2B,$24 ; B660
        .byte   $25,$25,$25,$24,$24,$24,$2C,$25,$25,$25,$25,$25,$25,$25,$25,$25 ; B670
; layout $02
        .byte   $07,$0D,$00,$01,$02,$03,$04,$0D,$0C,$0D,$08,$09,$0D,$05,$06,$07 ; B680
        .byte   $00,$01,$02,$0E,$0D,$0A,$0B,$0F,$08,$09,$26,$18,$16,$14,$15,$17 ; B690
        .byte   $1E,$27,$28,$1B,$1C,$19,$1B,$1D,$2D,$20,$0D,$20,$0D,$0D,$20,$2B ; B6A0
        .byte   $2E,$2F,$30,$31,$30,$32,$24,$2C,$25,$25,$24,$25,$24,$2C,$25,$25 ; B6B0
; layout $03
        .byte   $05,$06,$07,$0D,$00,$01,$02,$03,$0A,$0B,$0C,$0D,$08,$09,$0D,$0D ; B6C0
        .byte   $10,$11,$00,$01,$02,$0E,$0D,$0D,$26,$18,$08,$09,$33,$2A,$17,$12 ; B6D0
        .byte   $28,$1B,$34,$35,$2C,$25,$1D,$19,$2F,$20,$2B,$2C,$25,$25,$21,$0D ; B6E0
        .byte   $25,$24,$2C,$25,$25,$25,$36,$36,$25,$25,$25,$25,$25,$25,$37,$37 ; B6F0
; layout $04
        .byte   $38,$39,$39,$39,$39,$39,$3A,$3B,$38,$3C,$3C,$3D,$3E,$3C,$37,$37 ; B700
        .byte   $38,$3B,$3A,$3F,$40,$41,$42,$42,$38,$37,$37,$3B,$3A,$43,$44,$38 ; B710
        .byte   $38,$3A,$37,$37,$37,$37,$45,$38,$38,$37,$46,$47,$42,$48,$49,$38 ; B720
        .byte   $38,$37,$38,$38,$38,$38,$38,$38,$38,$37,$38,$38,$38,$38,$38,$38 ; B730
; layout $05
        .byte   $25,$3A,$4A,$4A,$25,$25,$25,$25,$25,$37,$3E,$3C,$4A,$25,$25,$25 ; B740
        .byte   $25,$37,$40,$3A,$3D,$4A,$25,$25,$25,$4B,$37,$37,$3F,$3E,$4A,$25 ; B750
        .byte   $25,$4C,$4D,$4E,$37,$40,$3C,$4A,$25,$25,$25,$25,$4F,$50,$37,$37 ; B760
        .byte   $25,$25,$25,$25,$25,$2E,$24,$24,$25,$25,$25,$25,$25,$25,$25,$25 ; B770
; layout $06
        .byte   $25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25 ; B780
        .byte   $25,$25,$4A,$4A,$25,$25,$25,$25,$4A,$4A,$37,$37,$25,$25,$4A,$4A ; B790
        .byte   $37,$37,$37,$37,$51,$51,$37,$52,$37,$37,$37,$37,$37,$37,$37,$53 ; B7A0
        .byte   $24,$24,$24,$24,$24,$24,$24,$24,$25,$25,$25,$25,$25,$25,$25,$25 ; B7B0
; layout $07
        .byte   $25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25 ; B7C0
        .byte   $4A,$4A,$25,$25,$25,$25,$25,$25,$37,$37,$25,$25,$25,$25,$25,$25 ; B7D0
        .byte   $37,$37,$51,$51,$51,$51,$51,$54,$37,$37,$37,$37,$37,$37,$37,$53 ; B7E0
        .byte   $24,$24,$24,$24,$24,$24,$24,$24,$25,$25,$25,$25,$25,$25,$25,$25 ; B7F0
; layout $08
        .byte   $25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25 ; B800
        .byte   $25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25 ; B810
        .byte   $51,$51,$51,$51,$51,$51,$51,$54,$37,$37,$37,$37,$37,$37,$37,$53 ; B820
        .byte   $24,$24,$24,$24,$24,$24,$24,$24,$25,$25,$25,$25,$25,$25,$25,$25 ; B830
; layout $09
        .byte   $25,$25,$25,$25,$25,$25,$55,$25,$25,$25,$25,$25,$25,$25,$55,$25 ; B840
        .byte   $25,$25,$25,$25,$25,$25,$55,$25,$25,$25,$25,$25,$25,$25,$55,$25 ; B850
        .byte   $51,$51,$51,$51,$51,$51,$56,$25,$37,$37,$37,$57,$4F,$4F,$58,$25 ; B860
        .byte   $24,$24,$24,$2C,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25,$25 ; B870
; layout $0A
        .byte   $38,$38,$38,$38,$38,$38,$38,$59,$38,$38,$38,$38,$38,$38,$38,$5A ; B880
        .byte   $38,$38,$38,$38,$38,$38,$38,$5B,$38,$38,$38,$5C,$5C,$5C,$5D,$37 ; B890
        .byte   $38,$37,$5C,$5C,$38,$5C,$5E,$5F,$38,$38,$38,$38,$38,$38,$60,$61 ; B8A0
        .byte   $38,$38,$38,$38,$38,$38,$62,$46,$38,$38,$38,$38,$38,$38,$63,$38 ; B8B0
; layout $0B
        .byte   $3E,$64,$3D,$3E,$65,$66,$3E,$65,$40,$64,$3F,$40,$65,$66,$40,$65 ; B8C0
        .byte   $3A,$64,$3B,$3A,$65,$66,$3A,$65,$37,$64,$37,$37,$65,$66,$67,$68 ; B8D0
        .byte   $4B,$64,$4B,$67,$68,$69,$6A,$6B,$61,$6C,$61,$6D,$6B,$6E,$6F,$4B ; B8E0
        .byte   $70,$70,$71,$72,$73,$74,$6F,$61,$38,$38,$38,$72,$61,$75,$6F,$61 ; B8F0
; layout $0C
        .byte   $66,$65,$66,$3C,$64,$5B,$3E,$37,$66,$65,$66,$37,$64,$37,$40,$3A ; B900
        .byte   $66,$65,$66,$3A,$64,$37,$37,$37,$69,$6A,$66,$37,$64,$3A,$3A,$37 ; B910
        .byte   $6E,$6F,$66,$37,$64,$5F,$4B,$37,$67,$76,$69,$77,$78,$4C,$4C,$4D ; B920
        .byte   $6D,$6B,$6E,$66,$38,$38,$38,$38,$72,$37,$37,$66,$38,$38,$38,$38 ; B930
; layout $0D
        .byte   $3C,$37,$3A,$64,$3C,$37,$5B,$64,$79,$7A,$7B,$64,$37,$37,$37,$64 ; B940
        .byte   $7C,$3E,$3C,$64,$7D,$7E,$7F,$64,$7C,$40,$37,$64,$5F,$74,$37,$64 ; B950
        .byte   $7C,$37,$3A,$64,$61,$75,$74,$64,$80,$81,$74,$82,$70,$70,$70,$70 ; B960
        .byte   $38,$61,$83,$45,$38,$38,$38,$38,$38,$61,$83,$45,$38,$38,$38,$38 ; B970
; layout $0E
        .byte   $3E,$3C,$37,$3C,$5B,$3E,$7C,$38,$40,$37,$3A,$3A,$37,$40,$7C,$38 ; B980
        .byte   $7A,$7B,$37,$37,$37,$37,$7C,$38,$37,$37,$5F,$84,$73,$74,$7C,$38 ; B990
        .byte   $84,$46,$70,$70,$71,$75,$85,$38,$70,$38,$38,$38,$38,$70,$70,$38 ; B9A0
        .byte   $38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38,$38 ; B9B0
; layout $0F
        .byte   $25,$55,$4A,$4A,$4A,$25,$25,$25,$25,$55,$3C,$5B,$3E,$25,$25,$25 ; B9C0
        .byte   $25,$55,$3A,$37,$40,$51,$25,$25,$25,$2E,$86,$37,$3A,$3A,$25,$25 ; B9D0
        .byte   $25,$25,$2E,$86,$37,$37,$4A,$25,$25,$25,$25,$2E,$86,$5F,$84,$25 ; B9E0
        .byte   $25,$25,$25,$25,$2E,$24,$87,$25,$51,$51,$51,$51,$51,$51,$56,$25 ; B9F0
; layout $10
        .byte   $88,$89,$8A,$0D,$0D,$0D,$88,$89,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D ; BA00
        .byte   $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$8B,$17,$16,$12,$8C,$12,$8C,$17 ; BA10
        .byte   $8D,$1D,$1C,$8D,$8E,$8D,$8D,$1D,$8F,$21,$0D,$8F,$0D,$8F,$8F,$21 ; BA20
        .byte   $70,$90,$46,$70,$70,$70,$70,$71,$38,$63,$38,$38,$38,$38,$38,$38 ; BA30
; layout $11
        .byte   $8A,$0D,$0D,$0D,$0D,$88,$89,$8A,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D ; BA40
        .byte   $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$16,$91,$8C,$91,$8C,$91,$8C,$91 ; BA50
        .byte   $1C,$8D,$8D,$8D,$37,$37,$37,$37,$0D,$8F,$8F,$92,$93,$94,$95,$93 ; BA60
        .byte   $96,$96,$96,$96,$96,$96,$96,$96,$97,$97,$97,$97,$97,$97,$97,$97 ; BA70
; layout $12
        .byte   $0D,$0D,$88,$89,$8A,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D ; BA80
        .byte   $26,$98,$91,$91,$99,$98,$17,$91,$9A,$37,$37,$37,$37,$37,$9B,$37 ; BA90
        .byte   $37,$37,$9C,$9D,$9D,$9D,$9D,$37,$94,$93,$9E,$9F,$9F,$A0,$A0,$37 ; BAA0
        .byte   $96,$96,$96,$96,$96,$96,$96,$A1,$97,$97,$97,$97,$97,$97,$A2,$A3 ; BAB0
; layout $13
        .byte   $A4,$A4,$A4,$A4,$A5,$A6,$A6,$A3,$97,$97,$97,$A2,$A6,$A3,$A3,$A3 ; BAC0
        .byte   $A4,$A7,$A8,$A9,$A3,$A3,$A3,$A3,$AA,$AB,$AC,$AD,$A3,$AE,$AE,$AE ; BAD0
        .byte   $AF,$A0,$B0,$B1,$A3,$B2,$B2,$B3,$B4,$A3,$96,$96,$A3,$A3,$A3,$B5 ; BAE0
        .byte   $B6,$A3,$B5,$97,$96,$96,$96,$B7,$B8,$A3,$B9,$BA,$BA,$BA,$BA,$BA ; BAF0
; layout $14
        .byte   $BB,$BC,$BD,$A4,$A4,$A4,$A4,$A4,$BE,$37,$BF,$97,$97,$97,$97,$97 ; BB00
        .byte   $B4,$37,$C0,$A4,$A4,$A4,$A4,$A4,$C1,$A1,$C2,$97,$97,$97,$97,$97 ; BB10
        .byte   $BB,$A3,$B7,$A8,$A8,$A8,$A8,$A8,$BE,$A3,$A0,$AC,$37,$AD,$A0,$A0 ; BB20
        .byte   $96,$96,$96,$96,$96,$96,$96,$96,$97,$97,$97,$97,$97,$97,$97,$97 ; BB30
; layout $15
        .byte   $A4,$A4,$A4,$A4,$A4,$A4,$A4,$A4,$97,$97,$97,$AA,$C3,$C4,$C5,$C5 ; BB40
        .byte   $A4,$C6,$C5,$A6,$A0,$A0,$BC,$BC,$97,$C7,$A3,$A3,$A3,$A3,$B0,$C8 ; BB50
        .byte   $A8,$A9,$BC,$BC,$BC,$BC,$B0,$37,$A0,$A0,$A3,$C9,$AE,$AE,$B0,$CA ; BB60
        .byte   $96,$96,$96,$96,$B3,$B3,$AE,$AE,$97,$97,$97,$97,$97,$97,$BA,$BA ; BB70
; layout $16
        .byte   $A4,$A4,$A4,$A4,$A4,$A4,$A4,$A4,$C5,$C5,$C5,$C5,$C5,$C5,$C5,$CB ; BB80
        .byte   $BC,$BC,$BC,$BC,$BC,$BC,$A3,$CC,$C8,$C8,$C8,$C8,$C8,$B1,$BC,$CD ; BB90
        .byte   $37,$37,$37,$37,$37,$B1,$A3,$CE,$CF,$CA,$CF,$CA,$CF,$B1,$A3,$CE ; BBA0
        .byte   $AE,$AE,$96,$94,$93,$96,$D0,$D1,$BA,$BA,$BA,$BA,$BA,$BA,$D2,$CC ; BBB0
; layout $17
        .byte   $A4,$A4,$A4,$D3,$A8,$A8,$D4,$D5,$97,$AA,$C3,$D6,$A0,$A0,$D7,$CE ; BBC0
        .byte   $A4,$C1,$D8,$D9,$D1,$96,$96,$96,$97,$BB,$A3,$A3,$D5,$97,$97,$97 ; BBD0
        .byte   $D3,$A9,$BC,$96,$96,$A4,$A4,$A4,$DA,$A0,$A3,$DB,$97,$97,$97,$97 ; BBE0
        .byte   $DC,$D1,$93,$DD,$A4,$A4,$A4,$A4,$DE,$CC,$BA,$BA,$BA,$BA,$BA,$BA ; BBF0
; layout $18
        .byte   $DE,$CC,$AA,$C3,$C3,$C3,$C3,$C3,$DF,$E0,$A6,$A0,$A0,$A0,$A0,$A0 ; BC00
        .byte   $D2,$BC,$BC,$BC,$BC,$BC,$BC,$BC,$DC,$E1,$A3,$A3,$A3,$B0,$C8,$C8 ; BC10
        .byte   $DE,$E1,$BC,$BC,$BC,$B0,$37,$37,$DE,$E1,$E1,$A3,$A3,$B0,$CA,$CF ; BC20
        .byte   $96,$96,$E1,$96,$96,$B0,$96,$96,$97,$97,$E1,$97,$97,$B0,$97,$97 ; BC30
; layout $19
        .byte   $C3,$C3,$C3,$C3,$C3,$C3,$E2,$97,$A0,$A0,$A0,$A0,$A0,$A0,$E3,$E4 ; BC40
        .byte   $BC,$BC,$BC,$BC,$BC,$BC,$E5,$E6,$C8,$B1,$A3,$E7,$BA,$E8,$A3,$AC ; BC50
        .byte   $37,$B1,$E9,$EA,$A4,$EB,$EC,$B0,$CA,$E7,$ED,$97,$97,$97,$EE,$E8 ; BC60
        .byte   $96,$EA,$A4,$A4,$A4,$A4,$A4,$B6,$97,$97,$97,$97,$97,$97,$97,$EF ; BC70
; layout $1A
        .byte   $97,$97,$97,$97,$97,$97,$97,$97,$A4,$A4,$A4,$A4,$A4,$A4,$A4,$A4 ; BC80
        .byte   $C3,$C3,$C3,$C3,$C3,$C3,$F0,$97,$C8,$AD,$A0,$A0,$A0,$A0,$DD,$A4 ; BC90
        .byte   $37,$B1,$A3,$A3,$A3,$A3,$F1,$F2,$37,$B1,$F3,$A3,$D0,$A3,$A3,$F4 ; BCA0
        .byte   $37,$F5,$CE,$A3,$D2,$F3,$96,$96,$37,$F6,$CE,$A3,$D2,$CE,$97,$97 ; BCB0
; layout $1B
        .byte   $97,$97,$97,$97,$97,$97,$97,$97,$A4,$A4,$A4,$A4,$A4,$A4,$A4,$A4 ; BCC0
        .byte   $97,$97,$97,$97,$97,$97,$97,$97,$A4,$A4,$A4,$A4,$A4,$A4,$A4,$A4 ; BCD0
        .byte   $C5,$F7,$F8,$F8,$F9,$C5,$C5,$F2,$A3,$B0,$CA,$CF,$B1,$A3,$A3,$F4 ; BCE0
        .byte   $96,$96,$96,$96,$96,$96,$96,$96,$97,$97,$97,$97,$97,$97,$97,$97 ; BCF0
; layout $1C
        .byte   $FA,$C3,$C3,$C3,$C3,$C3,$C3,$FB,$DA,$A0,$A0,$A0,$A0,$A0,$A0,$FC ; BD00
        .byte   $DC,$BC,$BC,$BC,$BC,$BC,$BC,$D5,$DE,$B0,$37,$B0,$B1,$37,$B1,$CE ; BD10
        .byte   $FD,$B0,$37,$B0,$B1,$37,$B1,$CE,$A3,$B0,$CA,$CF,$CA,$CF,$B1,$CE ; BD20
        .byte   $96,$96,$96,$96,$96,$96,$96,$96,$97,$97,$97,$97,$97,$97,$97,$97 ; BD30
; layout $1D
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BD40
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BD50
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BD60
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BD70
; layout $1E
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BD80
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BD90
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BDA0
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BDB0
; layout $1F
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BDC0
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BDD0
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BDE0
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BDF0
; layout $20
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BE00
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BE10
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BE20
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BE30
; layout $21
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BE40
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BE50
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BE60
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BE70
; layout $22
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BE80
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BE90
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BEA0
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BEB0
; layout $23
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BEC0
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BED0
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BEE0
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BEF0
; layout $24
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BF00
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BF10
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BF20
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BF30
; layout $25
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BF40
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BF50
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BF60
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BF70
; layout $26
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BF80
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BF90
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BFA0
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BFB0
; layout $27
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BFC0
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BFD0
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BFE0
        .byte   $37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37,$37 ; BFF0
