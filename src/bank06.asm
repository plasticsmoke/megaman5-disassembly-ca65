.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK06"

; =============================================================================
; BANK $06 (mapped at $A000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
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
        brk                                     ; A800 00
        brk                                     ; A801 00
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
        ora     ($01,x)                         ; A81A 01 01                    ..
        ora     ($01,x)                         ; A81C 01 01                    ..
        brk                                     ; A81E 00                       .
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
        ora     (L0000,x)                       ; A82D 01 00                    ..
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
        ora     (L0000,x)                       ; A83E 01 00                    ..
        .byte   $03                             ; A840 03                       .
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
        ora     ($01,x)                         ; A84F 01 01                    ..
        ora     ($01,x)                         ; A851 01 01                    ..
        ora     ($01,x)                         ; A853 01 01                    ..
        ora     ($01,x)                         ; A855 01 01                    ..
        brk                                     ; A857 00                       .
        brk                                     ; A858 00                       .
        .byte   $02                             ; A859 02                       .
        ora     (L0000,x)                       ; A85A 01 00                    ..
        ora     ($02,x)                         ; A85C 01 02                    ..
        brk                                     ; A85E 00                       .
        brk                                     ; A85F 00                       .
        ora     (L0000,x)                       ; A860 01 00                    ..
        ora     ($01,x)                         ; A862 01 01                    ..
        ora     ($01,x)                         ; A864 01 01                    ..
        ora     ($01,x)                         ; A866 01 01                    ..
        ora     ($01,x)                         ; A868 01 01                    ..
        brk                                     ; A86A 00                       .
        .byte   $04                             ; A86B 04                       .
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
        ora     ($01,x)                         ; A87B 01 01                    ..
        brk                                     ; A87D 00                       .
        brk                                     ; A87E 00                       .
        brk                                     ; A87F 00                       .
        brk                                     ; A880 00                       .
        ora     (L0000,x)                       ; A881 01 00                    ..
        ora     (L0000,x)                       ; A883 01 00                    ..
        brk                                     ; A885 00                       .
        ora     (L0000,x)                       ; A886 01 00                    ..
        brk                                     ; A888 00                       .
        ora     (L0000,x)                       ; A889 01 00                    ..
        brk                                     ; A88B 00                       .
        brk                                     ; A88C 00                       .
        ora     (L0000,x)                       ; A88D 01 00                    ..
        brk                                     ; A88F 00                       .
        brk                                     ; A890 00                       .
        ora     (L0000,x)                       ; A891 01 00                    ..
        ora     (L0000,x)                       ; A893 01 00                    ..
        brk                                     ; A895 00                       .
        ora     ($01,x)                         ; A896 01 01                    ..
        .byte   $02                             ; A898 02                       .
        brk                                     ; A899 00                       .
        brk                                     ; A89A 00                       .
        brk                                     ; A89B 00                       .
        ora     (L0000,x)                       ; A89C 01 00                    ..
        ora     ($01,x)                         ; A89E 01 01                    ..
        brk                                     ; A8A0 00                       .
        brk                                     ; A8A1 00                       .
LA8A2:  brk                                     ; A8A2 00                       .
        brk                                     ; A8A3 00                       .
        brk                                     ; A8A4 00                       .
        ora     (L0000,x)                       ; A8A5 01 00                    ..
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
        clc                                     ; A918 18                       .
        ora     $1B1A,y                         ; A919 19 1A 1B                 ...
        .byte   $1C                             ; A91C 1C                       .
        ora     $0C00,x                         ; A91D 1D 00 0C                 ...
        ldy     #$00                            ; A920 A0 00                    ..
        brk                                     ; A922 00                       .
LA923:  .byte   $80                             ; A923 80                       .
        brk                                     ; A924 00                       .
        brk                                     ; A925 00                       .
        php                                     ; A926 08                       .
        sta     ($08,x)                         ; A927 81 08                    ..
        bpl     LA92B                           ; A929 10 00                    ..
LA92B:  brk                                     ; A92B 00                       .
        .byte   $02                             ; A92C 02                       .
        brk                                     ; A92D 00                       .
        .byte   $02                             ; A92E 02                       .
        .byte   $54                             ; A92F 54                       T
        brk                                     ; A930 00                       .
        brk                                     ; A931 00                       .
        brk                                     ; A932 00                       .
        .byte   $04                             ; A933 04                       .
        .byte   $80                             ; A934 80                       .
        bmi     LA957                           ; A935 30 20                    0 
        .byte   $80                             ; A937 80                       .
        brk                                     ; A938 00                       .
        ora     (L0020,x)                       ; A939 01 20                    . 
        php                                     ; A93B 08                       .
        php                                     ; A93C 08                       .
        .byte   $22                             ; A93D 22                       "
        php                                     ; A93E 08                       .
        sty     $08                             ; A93F 84 08                    ..
        brk                                     ; A941 00                       .
        php                                     ; A942 08                       .
        brk                                     ; A943 00                       .
        brk                                     ; A944 00                       .
        .byte   $02                             ; A945 02                       .
        brk                                     ; A946 00                       .
        ldy     #$00                            ; A947 A0 00                    ..
        brk                                     ; A949 00                       .
        brk                                     ; A94A 00                       .
        .byte   $62                             ; A94B 62                       b
        brk                                     ; A94C 00                       .
        rti                                     ; A94D 40                       @

; ----------------------------------------------------------------------------
        php                                     ; A94E 08                       .
        .byte   $80                             ; A94F 80                       .
        .byte   $23                             ; A950 23                       #
LA951:  rti                                     ; A951 40                       @

; ----------------------------------------------------------------------------
        rts                                     ; A952 60                       `

; ----------------------------------------------------------------------------
        .byte   $22                             ; A953 22                       "
        jsr     L23A0                           ; A954 20 A0 23                  .#
LA957:  .byte   $80                             ; A957 80                       .
        ldx     #$40                            ; A958 A2 40                    .@
        .byte   $62                             ; A95A 62                       b
        rti                                     ; A95B 40                       @

; ----------------------------------------------------------------------------
        .byte   $62                             ; A95C 62                       b
        jsr     L0020                           ; A95D 20 20 00                   .
        brk                                     ; A960 00                       .
        jsr     L0400                           ; A961 20 00 04                  ..
        php                                     ; A964 08                       .
        ora     (L0000,x)                       ; A965 01 00                    ..
        bvc     LA98B                           ; A967 50 22                    P"
        .byte   $22                             ; A969 22                       "
        .byte   $1C                             ; A96A 1C                       .
        bit     L0000                           ; A96B 24 00                    $.
        brk                                     ; A96D 00                       .
        ora     $16,x                           ; A96E 15 16                    ..
        .byte   $2B                             ; A970 2B                       +
        .byte   $1C                             ; A971 1C                       .
        and     L0000                           ; A972 25 00                    %.
        bit     L0080                           ; A974 24 80                    $.
        lda     $8200,y                         ; A976 B9 00 82                 ...
        .byte   $42                             ; A979 42                       B
        brk                                     ; A97A 00                       .
        sbc     (L0000,x)                       ; A97B E1 00                    ..
        .byte   $03                             ; A97D 03                       .
        brk                                     ; A97E 00                       .
LA97F:  php                                     ; A97F 08                       .
        tya                                     ; A980 98                       .
        txs                                     ; A981 9A                       .
        jsr     L2800                           ; A982 20 00 28                  .(
        brk                                     ; A985 00                       .
        brk                                     ; A986 00                       .
        jsr     L290F                           ; A987 20 0F 29                  .)
        .byte   $19                             ; A98A 19                       .
LA98B:  .byte   $0B                             ; A98B 0B                       .
        .byte   $0F                             ; A98C 0F                       .
        .byte   $27                             ; A98D 27                       '
        .byte   $17                             ; A98E 17                       .
        .byte   $0B                             ; A98F 0B                       .
        .byte   $0F                             ; A990 0F                       .
        and     $1827,y                         ; A991 39 27 18                 9'.
        .byte   $0F                             ; A994 0F                       .
        bit     $14                             ; A995 24 14                    $.
        .byte   $03                             ; A997 03                       .
        brk                                     ; A998 00                       .
        brk                                     ; A999 00                       .
        brk                                     ; A99A 00                       .
        brk                                     ; A99B 00                       .
        .byte   $0F                             ; A99C 0F                       .
        .byte   $3C                             ; A99D 3C                       <
        bit     $0F20                           ; A99E 2C 20 0F                 , .
        .byte   $1C                             ; A9A1 1C                       .
        bpl     LA9D0                           ; A9A2 10 2C                    .,
        .byte   $0F                             ; A9A4 0F                       .
        and     $1827,y                         ; A9A5 39 27 18                 9'.
        .byte   $0F                             ; A9A8 0F                       .
        bit     $14                             ; A9A9 24 14                    $.
        .byte   $03                             ; A9AB 03                       .
        .byte   $9B                             ; A9AC 9B                       .
        .byte   $9C                             ; A9AD 9C                       .
        brk                                     ; A9AE 00                       .
        brk                                     ; A9AF 00                       .
        .byte   $0F                             ; A9B0 0F                       .
        sec                                     ; A9B1 38                       8
        .byte   $27                             ; A9B2 27                       '
        clc                                     ; A9B3 18                       .
        .byte   $0F                             ; A9B4 0F                       .
        .byte   $27                             ; A9B5 27                       '
        ora     $0F0B,y                         ; A9B6 19 0B 0F                 ...
        and     $1827,y                         ; A9B9 39 27 18                 9'.
        .byte   $0F                             ; A9BC 0F                       .
        bit     $14                             ; A9BD 24 14                    $.
        .byte   $03                             ; A9BF 03                       .
        brk                                     ; A9C0 00                       .
        brk                                     ; A9C1 00                       .
        brk                                     ; A9C2 00                       .
        brk                                     ; A9C3 00                       .
        brk                                     ; A9C4 00                       .
        brk                                     ; A9C5 00                       .
        brk                                     ; A9C6 00                       .
        bpl     LA951                           ; A9C7 10 88                    ..
        dey                                     ; A9C9 88                       .
        brk                                     ; A9CA 00                       .
        bit     $02                             ; A9CB 24 02                    $.
        ora     (L0080,x)                       ; A9CD 01 80                    ..
        brk                                     ; A9CF 00                       .
LA9D0:  brk                                     ; A9D0 00                       .
        .byte   $44                             ; A9D1 44                       D
        ldx     #$01                            ; A9D2 A2 01                    ..
        brk                                     ; A9D4 00                       .
        plp                                     ; A9D5 28                       (
        brk                                     ; A9D6 00                       .
        rts                                     ; A9D7 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; A9D8 03                       .
        brk                                     ; A9D9 00                       .
        .byte   $22                             ; A9DA 22                       "
        bpl     LA9FD                           ; A9DB 10 20                    . 
        cpy     L0000                           ; A9DD C4 00                    ..
LA9DF:  tya                                     ; A9DF 98                       .
        .byte   $FF                             ; A9E0 FF                       .
        pha                                     ; A9E1 48                       H
        jsr     L2019                           ; A9E2 20 19 20                  . 
        sta     L0400,y                         ; A9E5 99 00 04                 ...
        .byte   $80                             ; A9E8 80                       .
        brk                                     ; A9E9 00                       .
        brk                                     ; A9EA 00                       .
        txa                                     ; A9EB 8A                       .
        php                                     ; A9EC 08                       .
        brk                                     ; A9ED 00                       .
        brk                                     ; A9EE 00                       .
        brk                                     ; A9EF 00                       .
        php                                     ; A9F0 08                       .
        clc                                     ; A9F1 18                       .
        php                                     ; A9F2 08                       .
        brk                                     ; A9F3 00                       .
        php                                     ; A9F4 08                       .
        pha                                     ; A9F5 48                       H
        brk                                     ; A9F6 00                       .
        .byte   $04                             ; A9F7 04                       .
        brk                                     ; A9F8 00                       .
        asl     $2A,x                           ; A9F9 16 2A                    .*
        .byte   $03                             ; A9FB 03                       .
        brk                                     ; A9FC 00                       .
LA9FD:  eor     (L0000,x)                       ; A9FD 41 00                    A.
        cpy     #$00                            ; A9FF C0 00                    ..
        ora     ($01,x)                         ; AA01 01 01                    ..
        .byte   $02                             ; AA03 02                       .
        .byte   $03                             ; AA04 03                       .
        .byte   $03                             ; AA05 03                       .
        .byte   $04                             ; AA06 04                       .
        .byte   $04                             ; AA07 04                       .
        ora     $05                             ; AA08 05 05                    ..
        ora     $05                             ; AA0A 05 05                    ..
        asl     $09                             ; AA0C 06 09                    ..
        asl     a                               ; AA0E 0A                       .
        .byte   $0B                             ; AA0F 0B                       .
        .byte   $0B                             ; AA10 0B                       .
        .byte   $0C                             ; AA11 0C                       .
        .byte   $0C                             ; AA12 0C                       .
        .byte   $0C                             ; AA13 0C                       .
        .byte   $0C                             ; AA14 0C                       .
        ora     L0D0D                           ; AA15 0D 0D 0D                 ...
        asl     $0E0E                           ; AA18 0E 0E 0E                 ...
        asl     $0F0E                           ; AA1B 0E 0E 0F                 ...
        bpl     LAA31                           ; AA1E 10 11                    ..
        ora     ($11),y                         ; AA20 11 11                    ..
        .byte   $12                             ; AA22 12                       .
        .byte   $12                             ; AA23 12                       .
        .byte   $12                             ; AA24 12                       .
        .byte   $13                             ; AA25 13                       .
        .byte   $13                             ; AA26 13                       .
        .byte   $13                             ; AA27 13                       .
        .byte   $14                             ; AA28 14                       .
        ora     $15,x                           ; AA29 15 15                    ..
        ora     $15,x                           ; AA2B 15 15                    ..
        asl     $16,x                           ; AA2D 16 16                    ..
        .byte   $16                             ; AA2F 16                       .
LAA30:  .byte   $16                             ; AA30 16                       .
LAA31:  asl     $18,x                           ; AA31 16 18                    ..
        clc                                     ; AA33 18                       .
        clc                                     ; AA34 18                       .
        .byte   $19                             ; AA35 19                       .
        .byte   $1A                             ; AA36 1A                       .
LAA37:  .byte   $1A                             ; AA37 1A                       .
        .byte   $1A                             ; AA38 1A                       .
        .byte   $1C                             ; AA39 1C                       .
        .byte   $FF                             ; AA3A FF                       .
LAA3B:  bpl     LAA3D                           ; AA3B 10 00                    ..
LAA3D:  .byte   $EB                             ; AA3D EB                       .
        .byte   $02                             ; AA3E 02                       .
        bcc     LAA41                           ; AA3F 90 00                    ..
LAA41:  brk                                     ; AA41 00                       .
        php                                     ; AA42 08                       .
        brk                                     ; AA43 00                       .
        brk                                     ; AA44 00                       .
        brk                                     ; AA45 00                       .
        brk                                     ; AA46 00                       .
        brk                                     ; AA47 00                       .
        brk                                     ; AA48 00                       .
        sty     L0080                           ; AA49 84 80                    ..
        bpl     LAA4D                           ; AA4B 10 00                    ..
LAA4D:  eor     (L0000),y                       ; AA4D 51 00                    Q.
        eor     (L0000,x)                       ; AA4F 41 00                    A.
        brk                                     ; AA51 00                       .
        brk                                     ; AA52 00                       .
        brk                                     ; AA53 00                       .
        brk                                     ; AA54 00                       .
        bvc     LA9DF                           ; AA55 50 88                    P.
        brk                                     ; AA57 00                       .
LAA58:  php                                     ; AA58 08                       .
        php                                     ; AA59 08                       .
        php                                     ; AA5A 08                       .
        php                                     ; AA5B 08                       .
        .byte   $80                             ; AA5C 80                       .
        sec                                     ; AA5D 38                       8
        php                                     ; AA5E 08                       .
        bcc     LAA61                           ; AA5F 90 00                    ..
LAA61:  jsr     L0080                           ; AA61 20 80 00                  ..
        brk                                     ; AA64 00                       .
        brk                                     ; AA65 00                       .
        brk                                     ; AA66 00                       .
        jsr     L1708                           ; AA67 20 08 17                  ..
        ldy     #$57                            ; AA6A A0 57                    .W
        .byte   $80                             ; AA6C 80                       .
        brk                                     ; AA6D 00                       .
        php                                     ; AA6E 08                       .
        rti                                     ; AA6F 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AA70 00                       .
LAA71:  .byte   $03                             ; AA71 03                       .
        php                                     ; AA72 08                       .
        stx     L0000                           ; AA73 86 00                    ..
        brk                                     ; AA75 00                       .
        php                                     ; AA76 08                       .
        ora     $08                             ; AA77 05 08                    ..
        .byte   $02                             ; AA79 02                       .
        brk                                     ; AA7A 00                       .
        brk                                     ; AA7B 00                       .
        .byte   $80                             ; AA7C 80                       .
        .byte   $82                             ; AA7D 82                       .
        ldy     #$04                            ; AA7E A0 04                    ..
        brk                                     ; AA80 00                       .
        jsr     L70E0                           ; AA81 20 E0 70                  .p
        ora     ($A8,x)                         ; AA84 01 A8                    ..
        cli                                     ; AA86 58                       X
        cmp     ($70,x)                         ; AA87 C1 70                    .p
        bcc     LAA3B                           ; AA89 90 B0                    ..
        bne     LAA71                           ; AA8B D0 E4                    ..
LAA8D:  brk                                     ; AA8D 00                       .
        bmi     LAA30                           ; AA8E 30 A0                    0.
        .byte   $FF                             ; AA90 FF                       .
        rti                                     ; AA91 40                       @

; ----------------------------------------------------------------------------
LAA92:  rts                                     ; AA92 60                       `

; ----------------------------------------------------------------------------
        ldy     #$F0                            ; AA93 A0 F0                    ..
LAA95:  bvc     LAA37                           ; AA95 50 A0                    P.
        .byte   $AF                             ; AA97 AF                       .
        bpl     LAACA                           ; AA98 10 30                    .0
        cli                                     ; AA9A 58                       X
        .byte   $80                             ; AA9B 80                       .
        cpy     #$60                            ; AA9C C0 60                    .`
        brk                                     ; AA9E 00                       .
        brk                                     ; AA9F 00                       .
        brk                                     ; AAA0 00                       .
        jsr     L5400                           ; AAA1 20 00 54                  .T
        clv                                     ; AAA4 B8                       .
        bcs     LAA58                           ; AAA5 B0 B1                    ..
        .byte   $D0                             ; AAA7 D0                       .
LAAA8:  brk                                     ; AAA8 00                       .
LAAA9:  bpl     LAB1B                           ; AAA9 10 70                    .p
        bne     LAA8D                           ; AAAB D0 E0                    ..
        jsr     LD1D0                           ; AAAD 20 D0 D1                  ..
        .byte   $D2                             ; AAB0 D2                       .
        beq     LAB03                           ; AAB1 F0 50                    .P
        bcs     LAA95                           ; AAB3 B0 E0                    ..
LAAB5:  bmi     LAAC7                           ; AAB5 30 10                    0.
        rti                                     ; AAB7 40                       @

; ----------------------------------------------------------------------------
        bvs     LAA92                           ; AAB8 70 D8                    p.
        .byte   $FF                             ; AABA FF                       .
        brk                                     ; AABB 00                       .
        brk                                     ; AABC 00                       .
        brk                                     ; AABD 00                       .
        brk                                     ; AABE 00                       .
        rti                                     ; AABF 40                       @

; ----------------------------------------------------------------------------
        php                                     ; AAC0 08                       .
        bpl     LAAC3                           ; AAC1 10 00                    ..
LAAC3:  ora     (L0000,x)                       ; AAC3 01 00                    ..
        ora     ($02,x)                         ; AAC5 01 02                    ..
LAAC7:  ora     (L0000,x)                       ; AAC7 01 00                    ..
        .byte   $B4                             ; AAC9 B4                       .
LAACA:  brk                                     ; AACA 00                       .
        .byte   $20                             ; AACB 20                        
LAACC:  brk                                     ; AACC 00                       .
        .byte   $14                             ; AACD 14                       .
        brk                                     ; AACE 00                       .
        .byte   $1C                             ; AACF 1C                       .
        brk                                     ; AAD0 00                       .
LAAD1:  pha                                     ; AAD1 48                       H
        .byte   $82                             ; AAD2 82                       .
LAAD3:  brk                                     ; AAD3 00                       .
        .byte   $80                             ; AAD4 80                       .
        rti                                     ; AAD5 40                       @

; ----------------------------------------------------------------------------
        jsr     L0000                           ; AAD6 20 00 00                  ..
        brk                                     ; AAD9 00                       .
        jsr     L8010                           ; AADA 20 10 80                  ..
        jsr     L5A00                           ; AADD 20 00 5A                  .Z
        brk                                     ; AAE0 00                       .
        bpl     LAAE3                           ; AAE1 10 00                    ..
LAAE3:  .byte   $80                             ; AAE3 80                       .
        .byte   $02                             ; AAE4 02                       .
        .byte   $14                             ; AAE5 14                       .
        brk                                     ; AAE6 00                       .
        .byte   $03                             ; AAE7 03                       .
        brk                                     ; AAE8 00                       .
        rti                                     ; AAE9 40                       @

; ----------------------------------------------------------------------------
        jsr     L0040                           ; AAEA 20 40 00                  @.
        rts                                     ; AAED 60                       `

; ----------------------------------------------------------------------------
        jsr     L8020                           ; AAEE 20 20 80                   .
        plp                                     ; AAF1 28                       (
        brk                                     ; AAF2 00                       .
        .byte   $97                             ; AAF3 97                       .
        ldy     #$40                            ; AAF4 A0 40                    .@
        php                                     ; AAF6 08                       .
        brk                                     ; AAF7 00                       .
        asl     a                               ; AAF8 0A                       .
        php                                     ; AAF9 08                       .
        jsr     L0042                           ; AAFA 20 42 00                  B.
        .byte   $02                             ; AAFD 02                       .
        php                                     ; AAFE 08                       .
        .byte   $80                             ; AAFF 80                       .
        brk                                     ; AB00 00                       .
        ldy     $94                             ; AB01 A4 94                    ..
LAB03:  ldy     $94,x                           ; AB03 B4 94                    ..
        .byte   $64                             ; AB05 64                       d
        sty     $98,x                           ; AB06 94 98                    ..
        .byte   $80                             ; AB08 80                       .
        pha                                     ; AB09 48                       H
        pla                                     ; AB0A 68                       h
        bcs     LAAB5                           ; AB0B B0 A8                    ..
        brk                                     ; AB0D 00                       .
        tya                                     ; AB0E 98                       .
        tya                                     ; AB0F 98                       .
        sei                                     ; AB10 78                       x
        clv                                     ; AB11 B8                       .
        clc                                     ; AB12 18                       .
LAB13:  tay                                     ; AB13 A8                       .
        tay                                     ; AB14 A8                       .
        plp                                     ; AB15 28                       (
        sec                                     ; AB16 38                       8
LAB17:  tya                                     ; AB17 98                       .
        pha                                     ; AB18 48                       H
        pha                                     ; AB19 48                       H
        sei                                     ; AB1A 78                       x
LAB1B:  sei                                     ; AB1B 78                       x
        rti                                     ; AB1C 40                       @

; ----------------------------------------------------------------------------
        sei                                     ; AB1D 78                       x
        brk                                     ; AB1E 00                       .
        brk                                     ; AB1F 00                       .
        brk                                     ; AB20 00                       .
        bcs     LAB23                           ; AB21 B0 00                    ..
LAB23:  .byte   $80                             ; AB23 80                       .
        clv                                     ; AB24 B8                       .
        bcs     LAB87                           ; AB25 B0 60                    .`
        clv                                     ; AB27 B8                       .
        brk                                     ; AB28 00                       .
        bcs     LAAD3                           ; AB29 B0 A8                    ..
        tya                                     ; AB2B 98                       .
        tay                                     ; AB2C A8                       .
        ldy     L0080,x                         ; AB2D B4 80                    ..
        bcc     LAAD1                           ; AB2F 90 A0                    ..
        bcs     LAB13                           ; AB31 B0 E0                    ..
        cpx     #$B0                            ; AB33 E0 B0                    ..
        bcc     LAB17                           ; AB35 90 E0                    ..
        cpx     #$E0                            ; AB37 E0 E0                    ..
        brk                                     ; AB39 00                       .
        .byte   $FF                             ; AB3A FF                       .
        php                                     ; AB3B 08                       .
        .byte   $02                             ; AB3C 02                       .
        brk                                     ; AB3D 00                       .
        .byte   $80                             ; AB3E 80                       .
        brk                                     ; AB3F 00                       .
        brk                                     ; AB40 00                       .
        php                                     ; AB41 08                       .
        brk                                     ; AB42 00                       .
        pha                                     ; AB43 48                       H
        brk                                     ; AB44 00                       .
        rti                                     ; AB45 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; AB46 80                       .
        ldy     #$00                            ; AB47 A0 00                    ..
        jsr     L0E00                           ; AB49 20 00 0E                  ..
        brk                                     ; AB4C 00                       .
        brk                                     ; AB4D 00                       .
        .byte   $02                             ; AB4E 02                       .
        and     (L0080,x)                       ; AB4F 21 80                    !.
        .byte   $80                             ; AB51 80                       .
        brk                                     ; AB52 00                       .
        .byte   $02                             ; AB53 02                       .
        .byte   $02                             ; AB54 02                       .
LAB55:  ora     (L0000,x)                       ; AB55 01 00                    ..
        rti                                     ; AB57 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AB58 00                       .
        bmi     LAB5B                           ; AB59 30 00                    0.
LAB5B:  sta     ($02,x)                         ; AB5B 81 02                    ..
        bcc     LAB5F                           ; AB5D 90 00                    ..
LAB5F:  .byte   $20                             ; AB5F 20                        
        brk                                     ; AB60 00                       .
LAB61:  ora     (L0000),y                       ; AB61 11 00                    ..
        .byte   $12                             ; AB63 12                       .
        .byte   $02                             ; AB64 02                       .
        .byte   $04                             ; AB65 04                       .
        brk                                     ; AB66 00                       .
        bpl     LABA9                           ; AB67 10 40                    .@
        .byte   $80                             ; AB69 80                       .
        brk                                     ; AB6A 00                       .
        bmi     LAB6D                           ; AB6B 30 00                    0.
LAB6D:  php                                     ; AB6D 08                       .
        .byte   $02                             ; AB6E 02                       .
        brk                                     ; AB6F 00                       .
        brk                                     ; AB70 00                       .
        .byte   $80                             ; AB71 80                       .
        brk                                     ; AB72 00                       .
        brk                                     ; AB73 00                       .
        plp                                     ; AB74 28                       (
        jsr     L01A0                           ; AB75 20 A0 01                  ..
        php                                     ; AB78 08                       .
        brk                                     ; AB79 00                       .
        brk                                     ; AB7A 00                       .
        plp                                     ; AB7B 28                       (
        brk                                     ; AB7C 00                       .
        bpl     LAB7F                           ; AB7D 10 00                    ..
LAB7F:  sty     $D3,x                           ; AB7F 94 D3                    ..
        .byte   $04                             ; AB81 04                       .
        .byte   $04                             ; AB82 04                       .
        .byte   $04                             ; AB83 04                       .
        .byte   $04                             ; AB84 04                       .
        .byte   $04                             ; AB85 04                       .
        .byte   $04                             ; AB86 04                       .
LAB87:  sty     $08                             ; AB87 84 08                    ..
        .byte   $34                             ; AB89 34                       4
        .byte   $34                             ; AB8A 34                       4
LAB8B:  php                                     ; AB8B 08                       .
        jmp     L81D5                           ; AB8C 4C D5 81                 L..

; ----------------------------------------------------------------------------
        .byte   $32                             ; AB8F 32                       2
        .byte   $32                             ; AB90 32                       2
        .byte   $32                             ; AB91 32                       2
        ora     $3232                           ; AB92 0D 32 32                 .22
        .byte   $32                             ; AB95 32                       2
        .byte   $32                             ; AB96 32                       2
        .byte   $32                             ; AB97 32                       2
        .byte   $32                             ; AB98 32                       2
        .byte   $32                             ; AB99 32                       2
        .byte   $32                             ; AB9A 32                       2
        .byte   $32                             ; AB9B 32                       2
        ora     $DF80                           ; AB9C 0D 80 DF                 ...
        .byte   $D2                             ; AB9F D2                       .
        sbc     ($1B,x)                         ; ABA0 E1 1B                    ..
        cpx     #$1B                            ; ABA2 E0 1B                    ..
        stx     $0808                           ; ABA4 8E 08 08                 ...
        .byte   $83                             ; ABA7 83                       .
        .byte   $E2                             ; ABA8 E2                       .
LABA9:  .byte   $37                             ; ABA9 37                       7
        .byte   $37                             ; ABAA 37                       7
        .byte   $37                             ; ABAB 37                       7
        .byte   $37                             ; ABAC 37                       7
        .byte   $0C                             ; ABAD 0C                       .
        .byte   $37                             ; ABAE 37                       7
        .byte   $37                             ; ABAF 37                       7
        .byte   $37                             ; ABB0 37                       7
        .byte   $37                             ; ABB1 37                       7
        bpl     LABC4                           ; ABB2 10 10                    ..
        asl     $16,x                           ; ABB4 16 16                    ..
        bpl     LABC8                           ; ABB6 10 10                    ..
        bpl     LAC22                           ; ABB8 10 68                    .h
        .byte   $FF                             ; ABBA FF                       .
        .byte   $80                             ; ABBB 80                       .
        plp                                     ; ABBC 28                       (
        brk                                     ; ABBD 00                       .
        php                                     ; ABBE 08                       .
        tya                                     ; ABBF 98                       .
        jsr     L0000                           ; ABC0 20 00 00                  ..
        .byte   $80                             ; ABC3 80                       .
LABC4:  jsr     L8001                           ; ABC4 20 01 80                  ..
        .byte   $04                             ; ABC7 04                       .
LABC8:  .byte   $80                             ; ABC8 80                       .
        brk                                     ; ABC9 00                       .
        brk                                     ; ABCA 00                       .
        rti                                     ; ABCB 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ABCC 00                       .
        php                                     ; ABCD 08                       .
        .byte   $80                             ; ABCE 80                       .
        brk                                     ; ABCF 00                       .
        php                                     ; ABD0 08                       .
        .byte   $12                             ; ABD1 12                       .
        brk                                     ; ABD2 00                       .
        brk                                     ; ABD3 00                       .
        brk                                     ; ABD4 00                       .
        .byte   $02                             ; ABD5 02                       .
        brk                                     ; ABD6 00                       .
        ora     (L0080,x)                       ; ABD7 01 80                    ..
        brk                                     ; ABD9 00                       .
        php                                     ; ABDA 08                       .
        .byte   $04                             ; ABDB 04                       .
        brk                                     ; ABDC 00                       .
        php                                     ; ABDD 08                       .
        dey                                     ; ABDE 88                       .
        bcc     LAB61                           ; ABDF 90 80                    ..
        bpl     LAB8B                           ; ABE1 10 A8                    ..
        brk                                     ; ABE3 00                       .
        brk                                     ; ABE4 00                       .
        jsr     L0000                           ; ABE5 20 00 00                  ..
        brk                                     ; ABE8 00                       .
        ora     (L0000),y                       ; ABE9 11 00                    ..
        brk                                     ; ABEB 00                       .
        brk                                     ; ABEC 00                       .
        brk                                     ; ABED 00                       .
        brk                                     ; ABEE 00                       .
        rti                                     ; ABEF 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; ABF0 80                       .
        brk                                     ; ABF1 00                       .
        .byte   $82                             ; ABF2 82                       .
        jsr     L3000                           ; ABF3 20 00 30                  .0
        jsr     L20A1                           ; ABF6 20 A1 20                  . 
        pla                                     ; ABF9 68                       h
        brk                                     ; ABFA 00                       .
        .byte   $02                             ; ABFB 02                       .
        .byte   $02                             ; ABFC 02                       .
        ora     ($82,x)                         ; ABFD 01 82                    ..
        .byte   $44                             ; ABFF 44                       D
        brk                                     ; AC00 00                       .
        ora     ($03,x)                         ; AC01 01 03                    ..
        .byte   $04                             ; AC03 04                       .
        asl     $08                             ; AC04 06 08                    ..
        .byte   $0C                             ; AC06 0C                       .
        ora     L0D0D                           ; AC07 0D 0D 0D                 ...
        asl     $110F                           ; AC0A 0E 0F 11                 ...
        ora     $18,x                           ; AC0D 15 18                    ..
        ora     $1F1E,x                         ; AC0F 1D 1E 1F                 ...
        .byte   $22                             ; AC12 22                       "
        and     $28                             ; AC13 25 28                    %(
        and     #$2D                            ; AC15 29 2D                    )-
        .byte   $32                             ; AC17 32                       2
        .byte   $32                             ; AC18 32                       2
        and     $36,x                           ; AC19 35 36                    56
        and     $0439,y                         ; AC1B 39 39 04                 99.
        brk                                     ; AC1E 00                       .
        brk                                     ; AC1F 00                       .
        brk                                     ; AC20 00                       .
        brk                                     ; AC21 00                       .
LAC22:  brk                                     ; AC22 00                       .
        brk                                     ; AC23 00                       .
        brk                                     ; AC24 00                       .
        brk                                     ; AC25 00                       .
        brk                                     ; AC26 00                       .
        brk                                     ; AC27 00                       .
        brk                                     ; AC28 00                       .
        brk                                     ; AC29 00                       .
        bpl     LAC2C                           ; AC2A 10 00                    ..
LAC2C:  brk                                     ; AC2C 00                       .
        brk                                     ; AC2D 00                       .
        brk                                     ; AC2E 00                       .
        brk                                     ; AC2F 00                       .
        jsr     L0000                           ; AC30 20 00 00                  ..
        brk                                     ; AC33 00                       .
        ora     (L0000,x)                       ; AC34 01 00                    ..
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
        brk                                     ; AC48 00                       .
        brk                                     ; AC49 00                       .
        brk                                     ; AC4A 00                       .
        brk                                     ; AC4B 00                       .
        brk                                     ; AC4C 00                       .
        brk                                     ; AC4D 00                       .
        brk                                     ; AC4E 00                       .
        brk                                     ; AC4F 00                       .
        rti                                     ; AC50 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AC51 00                       .
        brk                                     ; AC52 00                       .
        brk                                     ; AC53 00                       .
        brk                                     ; AC54 00                       .
        brk                                     ; AC55 00                       .
        .byte   $04                             ; AC56 04                       .
        brk                                     ; AC57 00                       .
        brk                                     ; AC58 00                       .
        brk                                     ; AC59 00                       .
        brk                                     ; AC5A 00                       .
        brk                                     ; AC5B 00                       .
        brk                                     ; AC5C 00                       .
        brk                                     ; AC5D 00                       .
        .byte   $80                             ; AC5E 80                       .
        brk                                     ; AC5F 00                       .
        brk                                     ; AC60 00                       .
        brk                                     ; AC61 00                       .
        brk                                     ; AC62 00                       .
        brk                                     ; AC63 00                       .
        rti                                     ; AC64 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AC65 00                       .
        brk                                     ; AC66 00                       .
        brk                                     ; AC67 00                       .
        .byte   $80                             ; AC68 80                       .
        brk                                     ; AC69 00                       .
        brk                                     ; AC6A 00                       .
        brk                                     ; AC6B 00                       .
        brk                                     ; AC6C 00                       .
        cpy     #$00                            ; AC6D C0 00                    ..
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
        ora     (L0000,x)                       ; AC7D 01 00                    ..
        ora     (L0000,x)                       ; AC7F 01 00                    ..
        .byte   $04                             ; AC81 04                       .
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
        rti                                     ; AC94 40                       @

; ----------------------------------------------------------------------------
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
        .byte   $02                             ; ACB8 02                       .
        .byte   $04                             ; ACB9 04                       .
        brk                                     ; ACBA 00                       .
        brk                                     ; ACBB 00                       .
        brk                                     ; ACBC 00                       .
        brk                                     ; ACBD 00                       .
        rti                                     ; ACBE 40                       @

; ----------------------------------------------------------------------------
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
        bvc     LACE7                           ; ACE5 50 00                    P.
LACE7:  brk                                     ; ACE7 00                       .
        brk                                     ; ACE8 00                       .
        brk                                     ; ACE9 00                       .
        brk                                     ; ACEA 00                       .
        brk                                     ; ACEB 00                       .
        brk                                     ; ACEC 00                       .
        brk                                     ; ACED 00                       .
        php                                     ; ACEE 08                       .
        ora     ($02,x)                         ; ACEF 01 02                    ..
        brk                                     ; ACF1 00                       .
        rti                                     ; ACF2 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACF3 00                       .
        brk                                     ; ACF4 00                       .
        rti                                     ; ACF5 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACF6 00                       .
        rti                                     ; ACF7 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACF8 00                       .
        brk                                     ; ACF9 00                       .
        brk                                     ; ACFA 00                       .
        brk                                     ; ACFB 00                       .
        brk                                     ; ACFC 00                       .
        brk                                     ; ACFD 00                       .
        ora     (L0040,x)                       ; ACFE 01 40                    .@
        brk                                     ; AD00 00                       .
        .byte   $03                             ; AD01 03                       .
        .byte   $82                             ; AD02 82                       .
        .byte   $82                             ; AD03 82                       .
        stx     $70                             ; AD04 86 70                    .p
        .byte   $73                             ; AD06 73                       s
        .byte   $03                             ; AD07 03                       .
        .byte   $03                             ; AD08 03                       .
        sta     ($93),y                         ; AD09 91 93                    ..
        sta     $97,x                           ; AD0B 95 97                    ..
        rts                                     ; AD0D 60                       `

; ----------------------------------------------------------------------------
        .byte   $63                             ; AD0E 63                       c
        adc     $03                             ; AD0F 65 03                    e.
        lda     ($B3),y                         ; AD11 B1 B3                    ..
        lda     $03,x                           ; AD13 B5 03                    ..
        cpy     $01CE                           ; AD15 CC CE 01                 ...
        .byte   $03                             ; AD18 03                       .
        cmp     ($D3),y                         ; AD19 D1 D3                    ..
        cmp     $AC,x                           ; AD1B D5 AC                    ..
        ldx     a:L0000                         ; AD1D AE 00 00                 ...
        ora     ($F1,x)                         ; AD20 01 F1                    ..
        .byte   $F3                             ; AD22 F3                       .
        .byte   $03                             ; AD23 03                       .
        ldy     $20BE,x                         ; AD24 BC BE 20                 .. 
        .byte   $22                             ; AD27 22                       "
        .byte   $12                             ; AD28 12                       .
        .byte   $12                             ; AD29 12                       .
        .byte   $EB                             ; AD2A EB                       .
        ora     ($EF,x)                         ; AD2B 01 EF                    ..
        sbc     $4240                           ; AD2D ED 40 42                 .@B
        bpl     LAD42                           ; AD30 10 10                    ..
        asl     a                               ; AD32 0A                       .
        asl     a                               ; AD33 0A                       .
        brk                                     ; AD34 00                       .
        .byte   $54                             ; AD35 54                       T
        brk                                     ; AD36 00                       .
LAD37:  asl     $1212                           ; AD37 0E 12 12                 ...
        bpl     LAD3C                           ; AD3A 10 00                    ..
LAD3C:  .byte   $BB                             ; AD3C BB                       .
        lsr     $C9,x                           ; AD3D 56 C9                    V.
        sbc     #$00                            ; AD3F E9 00                    ..
        .byte   $10                             ; AD41 10                       .
LAD42:  jsr     L0022                           ; AD42 20 22 00                  ".
        brk                                     ; AD45 00                       .
        .byte   $12                             ; AD46 12                       .
        .byte   $12                             ; AD47 12                       .
        .byte   $12                             ; AD48 12                       .
        .byte   $12                             ; AD49 12                       .
        rti                                     ; AD4A 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; AD4B 42                       B
        jsr     L4222                           ; AD4C 20 22 42                  "B
        brk                                     ; AD4F 00                       .
        .byte   $04                             ; AD50 04                       .
        brk                                     ; AD51 00                       .
        bit     $2A2E                           ; AD52 2C 2E 2A                 ,.*
LAD55:  .byte   $0C                             ; AD55 0C                       .
        lsr     a                               ; AD56 4A                       J
        brk                                     ; AD57 00                       .
        .byte   $14                             ; AD58 14                       .
        ora     $4C,x                           ; AD59 15 4C                    .L
        lsr     $86EB                           ; AD5B 4E EB 86                 N..
        plp                                     ; AD5E 28                       (
        ror     $70                             ; AD5F 66 70                    fp
        .byte   $72                             ; AD61 72                       r
        cli                                     ; AD62 58                       X
        .byte   $5A                             ; AD63 5A                       Z
        .byte   $5A                             ; AD64 5A                       Z
        sei                                     ; AD65 78                       x
        .byte   $7B                             ; AD66 7B                       {
        jmp     (L986E)                         ; AD67 6C 6E 98                 ln.

; ----------------------------------------------------------------------------
        txs                                     ; AD6A 9A                       .
        sei                                     ; AD6B 78                       x
        sei                                     ; AD6C 78                       x
        pha                                     ; AD6D 48                       H
        eor     #$00                            ; AD6E 49 00                    I.
        brk                                     ; AD70 00                       .
        brk                                     ; AD71 00                       .
        brk                                     ; AD72 00                       .
        nop                                     ; AD73 EA                       .
        asl     $36                             ; AD74 06 36                    .6
        stx     $0467                           ; AD76 8E 67 04                 .g.
        ora     $1A,x                           ; AD79 15 1A                    ..
        brk                                     ; AD7B 00                       .
        .byte   $27                             ; AD7C 27                       '
        .byte   $02                             ; AD7D 02                       .
        brk                                     ; AD7E 00                       .
        sbc     $4A09,y                         ; AD7F F9 09 4A                 ..J
        bit     $25                             ; AD82 24 25                    $%
        and     L0000                           ; AD84 25 00                    %.
        sta     $CBBB,x                         ; AD86 9D BB CB                 ...
        brk                                     ; AD89 00                       .
        .byte   $CF                             ; AD8A CF                       .
        brk                                     ; AD8B 00                       .
        inc     $0100                           ; AD8C EE 00 01                 ...
        .byte   $03                             ; AD8F 03                       .
        cpy     $585A                           ; AD90 CC 5A 58                 .ZX
        .byte   $5A                             ; AD93 5A                       Z
        .byte   $5A                             ; AD94 5A                       Z
        sbc     #$F8                            ; AD95 E9 F8                    ..
        brk                                     ; AD97 00                       .
        asl     $2220                           ; AD98 0E 20 22                 . "
        rti                                     ; AD9B 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; AD9C 42                       B
        lda     (L0000,x)                       ; AD9D A1 00                    ..
        .byte   $DB                             ; AD9F DB                       .
        brk                                     ; ADA0 00                       .
        brk                                     ; ADA1 00                       .
        brk                                     ; ADA2 00                       .
        .byte   $F7                             ; ADA3 F7                       .
        brk                                     ; ADA4 00                       .
        .byte   $F7                             ; ADA5 F7                       .
        brk                                     ; ADA6 00                       .
        brk                                     ; ADA7 00                       .
        brk                                     ; ADA8 00                       .
        iny                                     ; ADA9 C8                       .
        cmp     #$00                            ; ADAA C9 00                    ..
        brk                                     ; ADAC 00                       .
        brk                                     ; ADAD 00                       .
        brk                                     ; ADAE 00                       .
        brk                                     ; ADAF 00                       .
        brk                                     ; ADB0 00                       .
        nop                                     ; ADB1 EA                       .
        nop                                     ; ADB2 EA                       .
        brk                                     ; ADB3 00                       .
        brk                                     ; ADB4 00                       .
        brk                                     ; ADB5 00                       .
        brk                                     ; ADB6 00                       .
        brk                                     ; ADB7 00                       .
        nop                                     ; ADB8 EA                       .
        adc     a:$7F,x                         ; ADB9 7D 7F 00                 }..
        nop                                     ; ADBC EA                       .
        brk                                     ; ADBD 00                       .
        brk                                     ; ADBE 00                       .
LADBF:  brk                                     ; ADBF 00                       .
        nop                                     ; ADC0 EA                       .
        nop                                     ; ADC1 EA                       .
        brk                                     ; ADC2 00                       .
        nop                                     ; ADC3 EA                       .
LADC4:  rts                                     ; ADC4 60                       `

; ----------------------------------------------------------------------------
        nop                                     ; ADC5 EA                       .
        dex                                     ; ADC6 CA                       .
        nop                                     ; ADC7 EA                       .
        nop                                     ; ADC8 EA                       .
        pla                                     ; ADC9 68                       h
        brk                                     ; ADCA 00                       .
        nop                                     ; ADCB EA                       .
        brk                                     ; ADCC 00                       .
        nop                                     ; ADCD EA                       .
        nop                                     ; ADCE EA                       .
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
        nop                                     ; ADE0 EA                       .
        nop                                     ; ADE1 EA                       .
        brk                                     ; ADE2 00                       .
        nop                                     ; ADE3 EA                       .
        rts                                     ; ADE4 60                       `

; ----------------------------------------------------------------------------
        nop                                     ; ADE5 EA                       .
        dex                                     ; ADE6 CA                       .
        nop                                     ; ADE7 EA                       .
        nop                                     ; ADE8 EA                       .
        pla                                     ; ADE9 68                       h
        brk                                     ; ADEA 00                       .
        nop                                     ; ADEB EA                       .
LADEC:  brk                                     ; ADEC 00                       .
        nop                                     ; ADED EA                       .
        nop                                     ; ADEE EA                       .
        brk                                     ; ADEF 00                       .
        brk                                     ; ADF0 00                       .
        brk                                     ; ADF1 00                       .
        brk                                     ; ADF2 00                       .
        brk                                     ; ADF3 00                       .
        brk                                     ; ADF4 00                       .
        brk                                     ; ADF5 00                       .
        brk                                     ; ADF6 00                       .
        brk                                     ; ADF7 00                       .
        nop                                     ; ADF8 EA                       .
        cli                                     ; ADF9 58                       X
        brk                                     ; ADFA 00                       .
        nop                                     ; ADFB EA                       .
        nop                                     ; ADFC EA                       .
        nop                                     ; ADFD EA                       .
        nop                                     ; ADFE EA                       .
        nop                                     ; ADFF EA                       .
        brk                                     ; AE00 00                       .
        .byte   $03                             ; AE01 03                       .
        .byte   $83                             ; AE02 83                       .
        .byte   $83                             ; AE03 83                       .
        .byte   $87                             ; AE04 87                       .
        adc     ($74),y                         ; AE05 71 74                    qt
        .byte   $03                             ; AE07 03                       .
        .byte   $03                             ; AE08 03                       .
        .byte   $92                             ; AE09 92                       .
        .byte   $03                             ; AE0A 03                       .
        stx     $03,y                           ; AE0B 96 03                    ..
        .byte   $74                             ; AE0D 74                       t
        .byte   $74                             ; AE0E 74                       t
        brk                                     ; AE0F 00                       .
        bcs     LADC4                           ; AE10 B0 B2                    ..
        ldy     $B6,x                           ; AE12 B4 B6                    ..
        .byte   $03                             ; AE14 03                       .
        cmp     $EFCF                           ; AE15 CD CF EF                 ...
        bne     LADEC                           ; AE18 D0 D2                    ..
        .byte   $D4                             ; AE1A D4                       .
        dec     $AD,x                           ; AE1B D6 AD                    ..
        .byte   $AF                             ; AE1D AF                       .
        brk                                     ; AE1E 00                       .
        brk                                     ; AE1F 00                       .
        ora     ($F2,x)                         ; AE20 01 F2                    ..
        .byte   $F4                             ; AE22 F4                       .
        inc     $BD,x                           ; AE23 F6 BD                    ..
        .byte   $BF                             ; AE25 BF                       .
        and     ($23,x)                         ; AE26 21 23                    !#
        ora     ($11),y                         ; AE28 11 11                    ..
        ora     ($01,x)                         ; AE2A 01 01                    ..
        .byte   $03                             ; AE2C 03                       .
        inc     $4341                           ; AE2D EE 41 43                 .AC
        ora     ($11),y                         ; AE30 11 11                    ..
        .byte   $0B                             ; AE32 0B                       .
        .byte   $0B                             ; AE33 0B                       .
        .byte   $E7                             ; AE34 E7                       .
        eor     L0000,x                         ; AE35 55 00                    U.
        .byte   $0F                             ; AE37 0F                       .
        ora     ($11),y                         ; AE38 11 11                    ..
        ora     (L0000),y                       ; AE3A 11 00                    ..
        brk                                     ; AE3C 00                       .
        .byte   $57                             ; AE3D 57                       W
        dex                                     ; AE3E CA                       .
        brk                                     ; AE3F 00                       .
        brk                                     ; AE40 00                       .
        ora     ($21),y                         ; AE41 11 21                    .!
        .byte   $23                             ; AE43 23                       #
        brk                                     ; AE44 00                       .
        brk                                     ; AE45 00                       .
        .byte   $13                             ; AE46 13                       .
        .byte   $13                             ; AE47 13                       .
        .byte   $13                             ; AE48 13                       .
        .byte   $13                             ; AE49 13                       .
        eor     ($43,x)                         ; AE4A 41 43                    AC
        and     ($23,x)                         ; AE4C 21 23                    !#
        nop                                     ; AE4E EA                       .
        brk                                     ; AE4F 00                       .
        ora     L0000                           ; AE50 05 00                    ..
        and     $2B2F                           ; AE52 2D 2F 2B                 -/+
        ora     a:$4B                           ; AE55 0D 4B 00                 .K.
        .byte   $14                             ; AE58 14                       .
        brk                                     ; AE59 00                       .
        eor     $014F                           ; AE5A 4D 4F 01                 MO.
        .byte   $B7                             ; AE5D B7                       .
        and     #$AF                            ; AE5E 29 AF                    ).
        adc     ($74),y                         ; AE60 71 74                    qt
        eor     $5B59,y                         ; AE62 59 59 5B                 YY[
        adc     $6D7B,y                         ; AE65 79 7B 6D                 y{m
        .byte   $6F                             ; AE68 6F                       o
        sta     $799B,y                         ; AE69 99 9B 79                 ..y
        adc     $4903,y                         ; AE6C 79 03 49                 y.I
        brk                                     ; AE6F 00                       .
        ora     L0000,x                         ; AE70 15 00                    ..
        brk                                     ; AE72 00                       .
        brk                                     ; AE73 00                       .
        rol     $36,x                           ; AE74 36 36                    66
        .byte   $8F                             ; AE76 8F                       .
        .byte   $67                             ; AE77 67                       g
        ora     $05                             ; AE78 05 05                    ..
        .byte   $1B                             ; AE7A 1B                       .
        brk                                     ; AE7B 00                       .
        .byte   $02                             ; AE7C 02                       .
        .byte   $9C                             ; AE7D 9C                       .
        brk                                     ; AE7E 00                       .
        sbc     $4B29,y                         ; AE7F F9 29 4B                 .)K
        .byte   $25                             ; AE82 25                       %
LAE83:  and     $16                             ; AE83 25 16                    %.
        brk                                     ; AE85 00                       .
        .byte   $9E                             ; AE86 9E                       .
        .byte   $CB                             ; AE87 CB                       .
        brk                                     ; AE88 00                       .
        dec     $EDCE                           ; AE89 CE CE ED                 ...
        sbc     $6464                           ; AE8C ED 64 64                 .dd
        .byte   $03                             ; AE8F 03                       .
        cmp     $5959                           ; AE90 CD 59 59                 .YY
        eor     $F75B,y                         ; AE93 59 5B F7                 Y[.
        sbc     #$00                            ; AE96 E9 00                    ..
        .byte   $0F                             ; AE98 0F                       .
        and     ($23,x)                         ; AE99 21 23                    !#
        eor     ($43,x)                         ; AE9B 41 43                    AC
        .byte   $D7                             ; AE9D D7                       .
        .byte   $DB                             ; AE9E DB                       .
        brk                                     ; AE9F 00                       .
        sed                                     ; AEA0 F8                       .
        brk                                     ; AEA1 00                       .
        brk                                     ; AEA2 00                       .
        brk                                     ; AEA3 00                       .
        .byte   $E7                             ; AEA4 E7                       .
        .byte   $E7                             ; AEA5 E7                       .
        brk                                     ; AEA6 00                       .
        brk                                     ; AEA7 00                       .
        cmp     $E8D8,y                         ; AEA8 D9 D8 E8                 ...
        brk                                     ; AEAB 00                       .
LAEAC:  brk                                     ; AEAC 00                       .
        brk                                     ; AEAD 00                       .
LAEAE:  brk                                     ; AEAE 00                       .
        brk                                     ; AEAF 00                       .
        nop                                     ; AEB0 EA                       .
        nop                                     ; AEB1 EA                       .
        brk                                     ; AEB2 00                       .
        brk                                     ; AEB3 00                       .
        brk                                     ; AEB4 00                       .
        brk                                     ; AEB5 00                       .
        brk                                     ; AEB6 00                       .
        brk                                     ; AEB7 00                       .
        nop                                     ; AEB8 EA                       .
        nop                                     ; AEB9 EA                       .
        nop                                     ; AEBA EA                       .
        nop                                     ; AEBB EA                       .
        nop                                     ; AEBC EA                       .
        brk                                     ; AEBD 00                       .
        brk                                     ; AEBE 00                       .
        brk                                     ; AEBF 00                       .
        lda     ($EA,x)                         ; AEC0 A1 EA                    ..
        nop                                     ; AEC2 EA                       .
        nop                                     ; AEC3 EA                       .
        nop                                     ; AEC4 EA                       .
        nop                                     ; AEC5 EA                       .
        nop                                     ; AEC6 EA                       .
        nop                                     ; AEC7 EA                       .
        cmp     ($EA,x)                         ; AEC8 C1 EA                    ..
        nop                                     ; AECA EA                       .
        brk                                     ; AECB 00                       .
        nop                                     ; AECC EA                       .
        nop                                     ; AECD EA                       .
        nop                                     ; AECE EA                       .
        nop                                     ; AECF EA                       .
        brk                                     ; AED0 00                       .
        brk                                     ; AED1 00                       .
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
        lda     ($EA,x)                         ; AEE0 A1 EA                    ..
        nop                                     ; AEE2 EA                       .
        nop                                     ; AEE3 EA                       .
        nop                                     ; AEE4 EA                       .
        nop                                     ; AEE5 EA                       .
        nop                                     ; AEE6 EA                       .
        nop                                     ; AEE7 EA                       .
        cmp     ($EA,x)                         ; AEE8 C1 EA                    ..
        nop                                     ; AEEA EA                       .
        brk                                     ; AEEB 00                       .
        nop                                     ; AEEC EA                       .
        nop                                     ; AEED EA                       .
        nop                                     ; AEEE EA                       .
        nop                                     ; AEEF EA                       .
        brk                                     ; AEF0 00                       .
        brk                                     ; AEF1 00                       .
        brk                                     ; AEF2 00                       .
        brk                                     ; AEF3 00                       .
        brk                                     ; AEF4 00                       .
        brk                                     ; AEF5 00                       .
        brk                                     ; AEF6 00                       .
        brk                                     ; AEF7 00                       .
        nop                                     ; AEF8 EA                       .
        nop                                     ; AEF9 EA                       .
        nop                                     ; AEFA EA                       .
        nop                                     ; AEFB EA                       .
        nop                                     ; AEFC EA                       .
        nop                                     ; AEFD EA                       .
        nop                                     ; AEFE EA                       .
        nop                                     ; AEFF EA                       .
        brk                                     ; AF00 00                       .
        bcc     LAE83                           ; AF01 90 80                    ..
        sty     $86                             ; AF03 84 86                    ..
        .byte   $73                             ; AF05 73                       s
        brk                                     ; AF06 00                       .
        bvs     LAF0C                           ; AF07 70 03                    p.
        .byte   $03                             ; AF09 03                       .
        .byte   $A3                             ; AF0A A3                       .
        .byte   $A5                             ; AF0B A5                       .
LAF0C:  .byte   $A7                             ; AF0C A7                       .
        adc     ($65,x)                         ; AF0D 61 65                    ae
        adc     $03                             ; AF0F 65 03                    e.
        cmp     ($C3,x)                         ; AF11 C1 C3                    ..
        cmp     $C7                             ; AF13 C5 C7                    ..
        .byte   $DC                             ; AF15 DC                       .
        dec     $0301,x                         ; AF16 DE 01 03                 ...
        sbc     ($E3,x)                         ; AF19 E1 E3                    ..
        sbc     $BC                             ; AF1B E5 BC                    ..
        ldx     LAEAC,y                         ; AF1D BE AC AE                 ...
        ora     ($A0,x)                         ; AF20 01 A0                    ..
        .byte   $80                             ; AF22 80                       .
        .byte   $03                             ; AF23 03                       .
        .byte   $03                             ; AF24 03                       .
        .byte   $03                             ; AF25 03                       .
        bmi     LAF5A                           ; AF26 30 32                    02
        bvc     LAF7C                           ; AF28 50 52                    PR
        .byte   $FB                             ; AF2A FB                       .
        sbc     $03FF,x                         ; AF2B FD FF 03                 ...
        bvc     LAF82                           ; AF2E 50 52                    PR
        bvc     LAF84                           ; AF30 50 52                    PR
        asl     a                               ; AF32 0A                       .
        asl     a                               ; AF33 0A                       .
        brk                                     ; AF34 00                       .
        lsr     $B9                             ; AF35 46 B9                    F.
        asl     $3230,x                         ; AF37 1E 30 32                 .02
        bmi     LAF3C                           ; AF3A 30 00                    0.
LAF3C:  .byte   $CB                             ; AF3C CB                       .
        pha                                     ; AF3D 48                       H
        cmp     L0000,y                         ; AF3E D9 00 00                 ...
        .byte   $32                             ; AF41 32                       2
        .byte   $44                             ; AF42 44                       D
        .byte   $44                             ; AF43 44                       D
        brk                                     ; AF44 00                       .
        brk                                     ; AF45 00                       .
        .byte   $32                             ; AF46 32                       2
        bvc     LAF79                           ; AF47 50 30                    P0
        .byte   $52                             ; AF49 52                       R
        .byte   $44                             ; AF4A 44                       D
        .byte   $44                             ; AF4B 44                       D
        .byte   $44                             ; AF4C 44                       D
        .byte   $44                             ; AF4D 44                       D
        .byte   $52                             ; AF4E 52                       R
        brk                                     ; AF4F 00                       .
        .byte   $04                             ; AF50 04                       .
        .byte   $04                             ; AF51 04                       .
        .byte   $3C                             ; AF52 3C                       <
        rol     $1C3A,x                         ; AF53 3E 3A 1C                 >:.
        clc                                     ; AF56 18                       .
        brk                                     ; AF57 00                       .
        .byte   $04                             ; AF58 04                       .
        .byte   $15                             ; AF59 15                       .
LAF5A:  .byte   $5C                             ; AF5A 5C                       \
        lsr     $7603,x                         ; AF5B 5E 03 76                 ^.v
        ora     #$BD                            ; AF5E 09 BD                    ..
        .byte   $72                             ; AF60 72                       r
        brk                                     ; AF61 00                       .
        pla                                     ; AF62 68                       h
        ror     a                               ; AF63 6A                       j
        ror     a                               ; AF64 6A                       j
        dey                                     ; AF65 88                       .
        .byte   $8B                             ; AF66 8B                       .
        .byte   $7C                             ; AF67 7C                       |
        ror     LAAA8,x                         ; AF68 7E A8 AA                 ~..
        dey                                     ; AF6B 88                       .
        ror     $4949,x                         ; AF6C 7E 49 49                 ~II
        .byte   $04                             ; AF6F 04                       .
        brk                                     ; AF70 00                       .
        ora     L0000,x                         ; AF71 15 00                    ..
        brk                                     ; AF73 00                       .
        .byte   $17                             ; AF74 17                       .
        .byte   $02                             ; AF75 02                       .
        sta     $14F0,x                         ; AF76 9D F0 14                 ...
LAF79:  ora     $1A,x                           ; AF79 15 1A                    ..
        brk                                     ; AF7B 00                       .
LAF7C:  .byte   $37                             ; AF7C 37                       7
        sec                                     ; AF7D 38                       8
        brk                                     ; AF7E 00                       .
        .byte   $FA                             ; AF7F FA                       .
        ora     #$4A                            ; AF80 09 4A                    .J
LAF82:  .byte   $34                             ; AF82 34                       4
        .byte   $35                             ; AF83 35                       5
LAF84:  and     L0000,x                         ; AF84 35 00                    5.
        php                                     ; AF86 08                       .
        stx     a:$8F                           ; AF87 8E 8F 00                 ...
        .byte   $DF                             ; AF8A DF                       .
        brk                                     ; AF8B 00                       .
        txa                                     ; AF8C 8A                       .
        brk                                     ; AF8D 00                       .
        ora     ($EC,x)                         ; AF8E 01 EC                    ..
        .byte   $DC                             ; AF90 DC                       .
        ror     a                               ; AF91 6A                       j
        pla                                     ; AF92 68                       h
        ror     a                               ; AF93 6A                       j
        ror     a                               ; AF94 6A                       j
        sbc     #$F7                            ; AF95 E9 F7                    ..
        brk                                     ; AF97 00                       .
        asl     $3230,x                         ; AF98 1E 30 32                 .02
        bvc     LAFEF                           ; AF9B 50 52                    PR
        lda     (L0000,x)                       ; AF9D A1 00                    ..
        .byte   $DB                             ; AF9F DB                       .
        brk                                     ; AFA0 00                       .
        clv                                     ; AFA1 B8                       .
        sed                                     ; AFA2 F8                       .
        lda     ($E7,x)                         ; AFA3 A1 E7                    ..
        lda     (L0000,x)                       ; AFA5 A1 00                    ..
        brk                                     ; AFA7 00                       .
        brk                                     ; AFA8 00                       .
        brk                                     ; AFA9 00                       .
        cmp     L0000,y                         ; AFAA D9 00 00                 ...
        brk                                     ; AFAD 00                       .
        brk                                     ; AFAE 00                       .
        brk                                     ; AFAF 00                       .
        brk                                     ; AFB0 00                       .
        nop                                     ; AFB1 EA                       .
        nop                                     ; AFB2 EA                       .
        brk                                     ; AFB3 00                       .
        brk                                     ; AFB4 00                       .
        brk                                     ; AFB5 00                       .
        brk                                     ; AFB6 00                       .
        brk                                     ; AFB7 00                       .
        .byte   $8B                             ; AFB8 8B                       .
        nop                                     ; AFB9 EA                       .
        nop                                     ; AFBA EA                       .
        nop                                     ; AFBB EA                       .
        nop                                     ; AFBC EA                       .
        brk                                     ; AFBD 00                       .
        brk                                     ; AFBE 00                       .
        brk                                     ; AFBF 00                       .
        nop                                     ; AFC0 EA                       .
        cli                                     ; AFC1 58                       X
        brk                                     ; AFC2 00                       .
        nop                                     ; AFC3 EA                       .
        nop                                     ; AFC4 EA                       .
        nop                                     ; AFC5 EA                       .
        nop                                     ; AFC6 EA                       .
        nop                                     ; AFC7 EA                       .
        nop                                     ; AFC8 EA                       .
        sei                                     ; AFC9 78                       x
        nop                                     ; AFCA EA                       .
        brk                                     ; AFCB 00                       .
        brk                                     ; AFCC 00                       .
        nop                                     ; AFCD EA                       .
        nop                                     ; AFCE EA                       .
        nop                                     ; AFCF EA                       .
        brk                                     ; AFD0 00                       .
        brk                                     ; AFD1 00                       .
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
        brk                                     ; AFDD 00                       .
        brk                                     ; AFDE 00                       .
        brk                                     ; AFDF 00                       .
        nop                                     ; AFE0 EA                       .
        cli                                     ; AFE1 58                       X
        brk                                     ; AFE2 00                       .
        nop                                     ; AFE3 EA                       .
        nop                                     ; AFE4 EA                       .
        nop                                     ; AFE5 EA                       .
        nop                                     ; AFE6 EA                       .
        nop                                     ; AFE7 EA                       .
        nop                                     ; AFE8 EA                       .
        sei                                     ; AFE9 78                       x
        nop                                     ; AFEA EA                       .
        brk                                     ; AFEB 00                       .
        brk                                     ; AFEC 00                       .
        nop                                     ; AFED EA                       .
        nop                                     ; AFEE EA                       .
LAFEF:  nop                                     ; AFEF EA                       .
        nop                                     ; AFF0 EA                       .
        nop                                     ; AFF1 EA                       .
        brk                                     ; AFF2 00                       .
        nop                                     ; AFF3 EA                       .
        rts                                     ; AFF4 60                       `

; ----------------------------------------------------------------------------
        nop                                     ; AFF5 EA                       .
        dex                                     ; AFF6 CA                       .
        nop                                     ; AFF7 EA                       .
        nop                                     ; AFF8 EA                       .
        pla                                     ; AFF9 68                       h
        brk                                     ; AFFA 00                       .
        nop                                     ; AFFB EA                       .
        brk                                     ; AFFC 00                       .
        nop                                     ; AFFD EA                       .
        nop                                     ; AFFE EA                       .
        brk                                     ; AFFF 00                       .
        brk                                     ; B000 00                       .
        sty     $81,x                           ; B001 94 81                    ..
        sta     $B7                             ; B003 85 B7                    ..
        .byte   $74                             ; B005 74                       t
        brk                                     ; B006 00                       .
        adc     ($03),y                         ; B007 71 03                    q.
        ldx     #$A4                            ; B009 A2 A4                    ..
        ldx     $03                             ; B00B A6 03                    ..
        .byte   $62                             ; B00D 62                       b
        brk                                     ; B00E 00                       .
        brk                                     ; B00F 00                       .
        cpy     #$C2                            ; B010 C0 C2                    ..
        cpy     $C6                             ; B012 C4 C6                    ..
        .byte   $03                             ; B014 03                       .
        cmp     $EFDF,x                         ; B015 DD DF EF                 ...
        cpx     #$E2                            ; B018 E0 E2                    ..
        cpx     $E6                             ; B01A E4 E6                    ..
        lda     LADBF,x                         ; B01C BD BF AD                 ...
        .byte   $AF                             ; B01F AF                       .
        ora     ($03,x)                         ; B020 01 03                    ..
        sta     ($03,x)                         ; B022 81 03                    ..
        .byte   $03                             ; B024 03                       .
        .byte   $03                             ; B025 03                       .
        and     ($33),y                         ; B026 31 33                    13
        eor     ($53),y                         ; B028 51 53                    QS
        .byte   $FC                             ; B02A FC                       .
        inc     $0303,x                         ; B02B FE 03 03                 ...
        eor     ($53),y                         ; B02E 51 53                    QS
        eor     ($53),y                         ; B030 51 53                    QS
        .byte   $0B                             ; B032 0B                       .
        .byte   $0B                             ; B033 0B                       .
        .byte   $F7                             ; B034 F7                       .
        .byte   $47                             ; B035 47                       G
        tsx                                     ; B036 BA                       .
        .byte   $1F                             ; B037 1F                       .
        and     ($33),y                         ; B038 31 33                    13
        and     (L0000),y                       ; B03A 31 00                    1.
        brk                                     ; B03C 00                       .
        eor     #$DA                            ; B03D 49 DA                    I.
        brk                                     ; B03F 00                       .
        brk                                     ; B040 00                       .
        .byte   $33                             ; B041 33                       3
        eor     $45                             ; B042 45 45                    EE
        brk                                     ; B044 00                       .
        brk                                     ; B045 00                       .
        .byte   $33                             ; B046 33                       3
        eor     ($31),y                         ; B047 51 31                    Q1
        .byte   $53                             ; B049 53                       S
        eor     $45                             ; B04A 45 45                    EE
        eor     $45                             ; B04C 45 45                    EE
        nop                                     ; B04E EA                       .
        brk                                     ; B04F 00                       .
        ora     $05                             ; B050 05 05                    ..
        and     $3B3F,x                         ; B052 3D 3F 3B                 =?;
        ora     a:$19,x                         ; B055 1D 19 00                 ...
        ora     L0000                           ; B058 05 00                    ..
        eor     $EB5F,x                         ; B05A 5D 5F EB                 ]_.
        .byte   $77                             ; B05D 77                       w
        and     #$BF                            ; B05E 29 BF                    ).
        .byte   $74                             ; B060 74                       t
        brk                                     ; B061 00                       .
        adc     #$69                            ; B062 69 69                    ii
        .byte   $6B                             ; B064 6B                       k
        .byte   $89                             ; B065 89                       .
        .byte   $8B                             ; B066 8B                       .
        adc     LA97F,x                         ; B067 7D 7F A9                 }..
        .byte   $AB                             ; B06A AB                       .
        .byte   $89                             ; B06B 89                       .
        .byte   $7F                             ; B06C 7F                       .
        pha                                     ; B06D 48                       H
        eor     #$04                            ; B06E 49 04                    I.
        ora     L0000,x                         ; B070 15 00                    ..
        ora     L0000,x                         ; B072 15 00                    ..
        .byte   $02                             ; B074 02                       .
        sty     $F59E                           ; B075 8C 9E F5                 ...
        .byte   $14                             ; B078 14                       .
        ora     $1B                             ; B079 05 1B                    ..
        brk                                     ; B07B 00                       .
        sec                                     ; B07C 38                       8
        sta     $FA00                           ; B07D 8D 00 FA                 ...
        and     #$4B                            ; B080 29 4B                    )K
        and     $35,x                           ; B082 35 35                    55
        rol     $07                             ; B084 26 07                    &.
        adc     $8E,x                           ; B086 75 8E                    u.
        brk                                     ; B088 00                       .
        dec     $7ADE,x                         ; B089 DE DE 7A                 ..z
        .byte   $7A                             ; B08C 7A                       z
        .byte   $64                             ; B08D 64                       d
        .byte   $64                             ; B08E 64                       d
        cpx     $69DD                           ; B08F EC DD 69                 ..i
        adc     #$69                            ; B092 69 69                    ii
        .byte   $6B                             ; B094 6B                       k
        sed                                     ; B095 F8                       .
        sbc     #$00                            ; B096 E9 00                    ..
        .byte   $1F                             ; B098 1F                       .
        and     ($33),y                         ; B099 31 33                    13
        eor     ($53),y                         ; B09B 51 53                    QS
        .byte   $D7                             ; B09D D7                       .
        .byte   $DB                             ; B09E DB                       .
        brk                                     ; B09F 00                       .
        cmp     #$00                            ; B0A0 C9 00                    ..
        cld                                     ; B0A2 D8                       .
        .byte   $F7                             ; B0A3 F7                       .
        .byte   $D7                             ; B0A4 D7                       .
        .byte   $D7                             ; B0A5 D7                       .
        brk                                     ; B0A6 00                       .
        brk                                     ; B0A7 00                       .
        brk                                     ; B0A8 00                       .
        inx                                     ; B0A9 E8                       .
        brk                                     ; B0AA 00                       .
        brk                                     ; B0AB 00                       .
        brk                                     ; B0AC 00                       .
        brk                                     ; B0AD 00                       .
        brk                                     ; B0AE 00                       .
        brk                                     ; B0AF 00                       .
        nop                                     ; B0B0 EA                       .
        nop                                     ; B0B1 EA                       .
        nop                                     ; B0B2 EA                       .
        brk                                     ; B0B3 00                       .
        brk                                     ; B0B4 00                       .
        brk                                     ; B0B5 00                       .
        brk                                     ; B0B6 00                       .
        brk                                     ; B0B7 00                       .
        sty     $EAEA                           ; B0B8 8C EA EA                 ...
        nop                                     ; B0BB EA                       .
LB0BC:  brk                                     ; B0BC 00                       .
        brk                                     ; B0BD 00                       .
        brk                                     ; B0BE 00                       .
        brk                                     ; B0BF 00                       .
        nop                                     ; B0C0 EA                       .
        nop                                     ; B0C1 EA                       .
        nop                                     ; B0C2 EA                       .
        nop                                     ; B0C3 EA                       .
        nop                                     ; B0C4 EA                       .
        nop                                     ; B0C5 EA                       .
        nop                                     ; B0C6 EA                       .
        nop                                     ; B0C7 EA                       .
        nop                                     ; B0C8 EA                       .
        adc     L0000,y                         ; B0C9 79 00 00                 y..
        nop                                     ; B0CC EA                       .
        nop                                     ; B0CD EA                       .
        nop                                     ; B0CE EA                       .
        nop                                     ; B0CF EA                       .
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
        nop                                     ; B0E0 EA                       .
        nop                                     ; B0E1 EA                       .
        nop                                     ; B0E2 EA                       .
        nop                                     ; B0E3 EA                       .
        nop                                     ; B0E4 EA                       .
        nop                                     ; B0E5 EA                       .
        nop                                     ; B0E6 EA                       .
        nop                                     ; B0E7 EA                       .
        nop                                     ; B0E8 EA                       .
        adc     L0000,y                         ; B0E9 79 00 00                 y..
        nop                                     ; B0EC EA                       .
        nop                                     ; B0ED EA                       .
        nop                                     ; B0EE EA                       .
        nop                                     ; B0EF EA                       .
        lda     ($EA,x)                         ; B0F0 A1 EA                    ..
        nop                                     ; B0F2 EA                       .
        nop                                     ; B0F3 EA                       .
        nop                                     ; B0F4 EA                       .
        nop                                     ; B0F5 EA                       .
        nop                                     ; B0F6 EA                       .
        nop                                     ; B0F7 EA                       .
        cmp     ($EA,x)                         ; B0F8 C1 EA                    ..
        nop                                     ; B0FA EA                       .
        brk                                     ; B0FB 00                       .
        nop                                     ; B0FC EA                       .
        nop                                     ; B0FD EA                       .
        nop                                     ; B0FE EA                       .
        nop                                     ; B0FF EA                       .
        brk                                     ; B100 00                       .
        brk                                     ; B101 00                       .
        ora     ($01,x)                         ; B102 01 01                    ..
        ora     ($01,x)                         ; B104 01 01                    ..
        ora     ($01,x)                         ; B106 01 01                    ..
        ora     (L0000,x)                       ; B108 01 00                    ..
        brk                                     ; B10A 00                       .
        brk                                     ; B10B 00                       .
        brk                                     ; B10C 00                       .
        ora     ($01,x)                         ; B10D 01 01                    ..
        ora     (L0000,x)                       ; B10F 01 00                    ..
        brk                                     ; B111 00                       .
        brk                                     ; B112 00                       .
        brk                                     ; B113 00                       .
        brk                                     ; B114 00                       .
        brk                                     ; B115 00                       .
        brk                                     ; B116 00                       .
        ora     (L0000,x)                       ; B117 01 00                    ..
        brk                                     ; B119 00                       .
        brk                                     ; B11A 00                       .
        brk                                     ; B11B 00                       .
        ora     ($01,x)                         ; B11C 01 01                    ..
        ora     ($01,x)                         ; B11E 01 01                    ..
        ora     (L0000,x)                       ; B120 01 00                    ..
        ora     (L0000,x)                       ; B122 01 00                    ..
        ora     ($01,x)                         ; B124 01 01                    ..
        .byte   $12                             ; B126 12                       .
        .byte   $12                             ; B127 12                       .
        .byte   $12                             ; B128 12                       .
        .byte   $12                             ; B129 12                       .
        ora     ($01,x)                         ; B12A 01 01                    ..
        ora     ($01,x)                         ; B12C 01 01                    ..
        .byte   $12                             ; B12E 12                       .
        .byte   $12                             ; B12F 12                       .
        .byte   $12                             ; B130 12                       .
        .byte   $12                             ; B131 12                       .
        .byte   $22                             ; B132 22                       "
        .byte   $42                             ; B133 42                       B
        .byte   $03                             ; B134 03                       .
        .byte   $03                             ; B135 03                       .
        .byte   $03                             ; B136 03                       .
LB137:  .byte   $F3                             ; B137 F3                       .
        .byte   $12                             ; B138 12                       .
        .byte   $12                             ; B139 12                       .
        .byte   $12                             ; B13A 12                       .
        .byte   $02                             ; B13B 02                       .
        .byte   $04                             ; B13C 04                       .
        .byte   $03                             ; B13D 03                       .
        .byte   $03                             ; B13E 03                       .
        .byte   $03                             ; B13F 03                       .
        .byte   $02                             ; B140 02                       .
        .byte   $12                             ; B141 12                       .
        .byte   $12                             ; B142 12                       .
        .byte   $12                             ; B143 12                       .
        .byte   $02                             ; B144 02                       .
        .byte   $03                             ; B145 03                       .
        .byte   $12                             ; B146 12                       .
        .byte   $12                             ; B147 12                       .
        .byte   $12                             ; B148 12                       .
LB149:  .byte   $12                             ; B149 12                       .
        .byte   $12                             ; B14A 12                       .
        .byte   $12                             ; B14B 12                       .
        .byte   $12                             ; B14C 12                       .
        .byte   $12                             ; B14D 12                       .
        .byte   $12                             ; B14E 12                       .
        brk                                     ; B14F 00                       .
        .byte   $02                             ; B150 02                       .
        .byte   $02                             ; B151 02                       .
        bpl     LB164                           ; B152 10 10                    ..
        bpl     LB149                           ; B154 10 F3                    ..
        bpl     LB158                           ; B156 10 00                    ..
LB158:  .byte   $02                             ; B158 02                       .
        .byte   $02                             ; B159 02                       .
        bpl     LB16F                           ; B15A 10 13                    ..
        ora     ($01,x)                         ; B15C 01 01                    ..
        bpl     LB161                           ; B15E 10 01                    ..
        .byte   $01                             ; B160 01                       .
LB161:  ora     ($72,x)                         ; B161 01 72                    .r
        .byte   $72                             ; B163 72                       r
LB164:  .byte   $52                             ; B164 52                       R
        brk                                     ; B165 00                       .
        brk                                     ; B166 00                       .
        brk                                     ; B167 00                       .
        brk                                     ; B168 00                       .
        brk                                     ; B169 00                       .
        brk                                     ; B16A 00                       .
        ora     (L0000,x)                       ; B16B 01 00                    ..
        brk                                     ; B16D 00                       .
        brk                                     ; B16E 00                       .
LB16F:  .byte   $02                             ; B16F 02                       .
        .byte   $02                             ; B170 02                       .
        .byte   $02                             ; B171 02                       .
        .byte   $02                             ; B172 02                       .
        ora     ($13,x)                         ; B173 01 13                    ..
        .byte   $13                             ; B175 13                       .
        .byte   $02                             ; B176 02                       .
        bpl     LB17B                           ; B177 10 02                    ..
        .byte   $02                             ; B179 02                       .
        .byte   $03                             ; B17A 03                       .
LB17B:  brk                                     ; B17B 00                       .
        .byte   $13                             ; B17C 13                       .
        .byte   $13                             ; B17D 13                       .
        .byte   $03                             ; B17E 03                       .
        bpl     LB191                           ; B17F 10 10                    ..
        bpl     LB185                           ; B181 10 02                    ..
        .byte   $02                             ; B183 02                       .
        .byte   $02                             ; B184 02                       .
LB185:  .byte   $02                             ; B185 02                       .
        .byte   $02                             ; B186 02                       .
        .byte   $02                             ; B187 02                       .
        .byte   $02                             ; B188 02                       .
        .byte   $03                             ; B189 03                       .
        .byte   $03                             ; B18A 03                       .
        .byte   $03                             ; B18B 03                       .
        .byte   $03                             ; B18C 03                       .
        .byte   $03                             ; B18D 03                       .
        .byte   $03                             ; B18E 03                       .
        brk                                     ; B18F 00                       .
        .byte   $01                             ; B190 01                       .
LB191:  .byte   $52                             ; B191 52                       R
        .byte   $12                             ; B192 12                       .
        .byte   $12                             ; B193 12                       .
        .byte   $12                             ; B194 12                       .
        .byte   $03                             ; B195 03                       .
        .byte   $03                             ; B196 03                       .
        .byte   $03                             ; B197 03                       .
        .byte   $F2                             ; B198 F2                       .
        .byte   $62                             ; B199 62                       b
        .byte   $62                             ; B19A 62                       b
        .byte   $62                             ; B19B 62                       b
        .byte   $62                             ; B19C 62                       b
        .byte   $03                             ; B19D 03                       .
        .byte   $03                             ; B19E 03                       .
        .byte   $03                             ; B19F 03                       .
        .byte   $03                             ; B1A0 03                       .
        .byte   $03                             ; B1A1 03                       .
        .byte   $03                             ; B1A2 03                       .
        .byte   $03                             ; B1A3 03                       .
        .byte   $03                             ; B1A4 03                       .
        .byte   $03                             ; B1A5 03                       .
        .byte   $03                             ; B1A6 03                       .
        .byte   $03                             ; B1A7 03                       .
        .byte   $03                             ; B1A8 03                       .
        .byte   $03                             ; B1A9 03                       .
        .byte   $03                             ; B1AA 03                       .
        .byte   $03                             ; B1AB 03                       .
        .byte   $03                             ; B1AC 03                       .
        .byte   $03                             ; B1AD 03                       .
        .byte   $03                             ; B1AE 03                       .
        .byte   $03                             ; B1AF 03                       .
        brk                                     ; B1B0 00                       .
        brk                                     ; B1B1 00                       .
        brk                                     ; B1B2 00                       .
        brk                                     ; B1B3 00                       .
        brk                                     ; B1B4 00                       .
        brk                                     ; B1B5 00                       .
        brk                                     ; B1B6 00                       .
        brk                                     ; B1B7 00                       .
        brk                                     ; B1B8 00                       .
        brk                                     ; B1B9 00                       .
        brk                                     ; B1BA 00                       .
        brk                                     ; B1BB 00                       .
        brk                                     ; B1BC 00                       .
        brk                                     ; B1BD 00                       .
        brk                                     ; B1BE 00                       .
        brk                                     ; B1BF 00                       .
        brk                                     ; B1C0 00                       .
        brk                                     ; B1C1 00                       .
        brk                                     ; B1C2 00                       .
        brk                                     ; B1C3 00                       .
        brk                                     ; B1C4 00                       .
        bvc     LB217                           ; B1C5 50 50                    PP
        brk                                     ; B1C7 00                       .
        brk                                     ; B1C8 00                       .
        brk                                     ; B1C9 00                       .
        brk                                     ; B1CA 00                       .
        brk                                     ; B1CB 00                       .
        brk                                     ; B1CC 00                       .
        bvc     LB21F                           ; B1CD 50 50                    PP
        brk                                     ; B1CF 00                       .
        brk                                     ; B1D0 00                       .
        brk                                     ; B1D1 00                       .
        brk                                     ; B1D2 00                       .
        brk                                     ; B1D3 00                       .
        brk                                     ; B1D4 00                       .
        bvc     LB227                           ; B1D5 50 50                    PP
        brk                                     ; B1D7 00                       .
        brk                                     ; B1D8 00                       .
        brk                                     ; B1D9 00                       .
        brk                                     ; B1DA 00                       .
        brk                                     ; B1DB 00                       .
        brk                                     ; B1DC 00                       .
        bvc     LB22F                           ; B1DD 50 50                    PP
        brk                                     ; B1DF 00                       .
        brk                                     ; B1E0 00                       .
        brk                                     ; B1E1 00                       .
        brk                                     ; B1E2 00                       .
        brk                                     ; B1E3 00                       .
        brk                                     ; B1E4 00                       .
        bvc     LB237                           ; B1E5 50 50                    PP
        brk                                     ; B1E7 00                       .
        brk                                     ; B1E8 00                       .
        brk                                     ; B1E9 00                       .
        brk                                     ; B1EA 00                       .
        brk                                     ; B1EB 00                       .
        brk                                     ; B1EC 00                       .
        bvc     LB23F                           ; B1ED 50 50                    PP
        brk                                     ; B1EF 00                       .
        brk                                     ; B1F0 00                       .
        brk                                     ; B1F1 00                       .
        brk                                     ; B1F2 00                       .
        brk                                     ; B1F3 00                       .
        brk                                     ; B1F4 00                       .
        bvc     LB247                           ; B1F5 50 50                    PP
        brk                                     ; B1F7 00                       .
        brk                                     ; B1F8 00                       .
        brk                                     ; B1F9 00                       .
        brk                                     ; B1FA 00                       .
        brk                                     ; B1FB 00                       .
        brk                                     ; B1FC 00                       .
        bvc     LB24F                           ; B1FD 50 50                    PP
        brk                                     ; B1FF 00                       .
        php                                     ; B200 08                       .
        ora     #$10                            ; B201 09 10                    ..
        ora     ($0A),y                         ; B203 11 0A                    ..
        .byte   $0B                             ; B205 0B                       .
        .byte   $12                             ; B206 12                       .
        .byte   $13                             ; B207 13                       .
        .byte   $0C                             ; B208 0C                       .
        php                                     ; B209 08                       .
        .byte   $14                             ; B20A 14                       .
        php                                     ; B20B 08                       .
        .byte   $5C                             ; B20C 5C                       \
        jsr     L2A08                           ; B20D 20 08 2A                  .*
        jsr     L2B17                           ; B210 20 17 2B                  .+
        bit     $0108                           ; B213 2C 08 01                 ,..
        php                                     ; B216 08                       .
LB217:  ora     #$08                            ; B217 09 08                    ..
        php                                     ; B219 08                       .
        asl     a                               ; B21A 0A                       .
        .byte   $0B                             ; B21B 0B                       .
        php                                     ; B21C 08                       .
        php                                     ; B21D 08                       .
        .byte   $0C                             ; B21E 0C                       .
LB21F:  php                                     ; B21F 08                       .
        clc                                     ; B220 18                       .
        ora     $2108,y                         ; B221 19 08 21                 ..!
        .byte   $1A                             ; B224 1A                       .
        .byte   $1B                             ; B225 1B                       .
        .byte   $22                             ; B226 22                       "
LB227:  .byte   $23                             ; B227 23                       #
        bpl     LB23B                           ; B228 10 11                    ..
        clc                                     ; B22A 18                       .
        ora     $1312,y                         ; B22B 19 12 13                 ...
        .byte   $1A                             ; B22E 1A                       .
LB22F:  .byte   $1B                             ; B22F 1B                       .
        .byte   $14                             ; B230 14                       .
        php                                     ; B231 08                       .
        php                                     ; B232 08                       .
        ora     ($08,x)                         ; B233 01 08                    ..
        php                                     ; B235 08                       .
        php                                     ; B236 08                       .
LB237:  php                                     ; B237 08                       .
        .byte   $02                             ; B238 02                       .
        php                                     ; B239 08                       .
        .byte   $02                             ; B23A 02                       .
LB23B:  php                                     ; B23B 08                       .
        .byte   $14                             ; B23C 14                       .
        php                                     ; B23D 08                       .
        php                                     ; B23E 08                       .
LB23F:  php                                     ; B23F 08                       .
        php                                     ; B240 08                       .
        and     ($08,x)                         ; B241 21 08                    !.
        php                                     ; B243 08                       .
        .byte   $22                             ; B244 22                       "
        .byte   $23                             ; B245 23                       #
        .byte   $02                             ; B246 02                       .
LB247:  php                                     ; B247 08                       .
        php                                     ; B248 08                       .
        .byte   $07                             ; B249 07                       .
        rts                                     ; B24A 60                       `

; ----------------------------------------------------------------------------
        adc     ($03,x)                         ; B24B 61 03                    a.
        .byte   $07                             ; B24D 07                       .
        .byte   $04                             ; B24E 04                       .
LB24F:  asl     $2107                           ; B24F 0E 07 21                 ..!
        ora     $2205                           ; B252 0D 05 22                 .."
        .byte   $23                             ; B255 23                       #
        .byte   $03                             ; B256 03                       .
        .byte   $07                             ; B257 07                       .
        php                                     ; B258 08                       .
        php                                     ; B259 08                       .
        .byte   $07                             ; B25A 07                       .
        rts                                     ; B25B 60                       `

; ----------------------------------------------------------------------------
        php                                     ; B25C 08                       .
        php                                     ; B25D 08                       .
        ora     $07                             ; B25E 05 07                    ..
        .byte   $02                             ; B260 02                       .
        php                                     ; B261 08                       .
        .byte   $03                             ; B262 03                       .
        .byte   $07                             ; B263 07                       .
        brk                                     ; B264 00                       .
        brk                                     ; B265 00                       .
        .byte   $1C                             ; B266 1C                       .
        ora     $0F04,x                         ; B267 1D 04 0F                 ...
        eor     $045F,x                         ; B26A 5D 5F 04                 ]_.
        asl     $5F5D                           ; B26D 0E 5D 5F                 .]_
        asl     L0000                           ; B270 06 00                    ..
        ora     a:$1D,x                         ; B272 1D 1D 00                 ...
        ora     $1D1E                           ; B275 0D 1E 1D                 ...
        ora     $05                             ; B278 05 05                    ..
        ora     $081D,x                         ; B27A 1D 1D 08                 ...
        php                                     ; B27D 08                       .
        ora     $15,x                           ; B27E 15 15                    ..
        .byte   $02                             ; B280 02                       .
        php                                     ; B281 08                       .
        .byte   $02                             ; B282 02                       .
        ora     $24,x                           ; B283 15 24                    .$
        php                                     ; B285 08                       .
        php                                     ; B286 08                       .
        php                                     ; B287 08                       .
        .byte   $02                             ; B288 02                       .
        php                                     ; B289 08                       .
        .byte   $3A                             ; B28A 3A                       :
        and     $0808,y                         ; B28B 39 08 08                 9..
        sec                                     ; B28E 38                       8
        and     $2928,y                         ; B28F 39 28 29                 9()
        rol     $27                             ; B292 26 27                    &'
        rol     $262F                           ; B294 2E 2F 26                 ./&
        .byte   $27                             ; B297 27                       '
        php                                     ; B298 08                       .
        php                                     ; B299 08                       .
        php                                     ; B29A 08                       .
        .byte   $07                             ; B29B 07                       .
        .byte   $03                             ; B29C 03                       .
        adc     ($5D,x)                         ; B29D 61 5D                    a]
        ora     $6105,x                         ; B29F 1D 05 61                 ..a
        ora     $021D,x                         ; B2A2 1D 1D 02                 ...
        php                                     ; B2A5 08                       .
        sec                                     ; B2A6 38                       8
        and     $0802,y                         ; B2A7 39 02 08                 9..
        sec                                     ; B2AA 38                       8
        lsr     $24                             ; B2AB 46 24                    F$
        and     ($08),y                         ; B2AD 31 08                    1.
        .byte   $27                             ; B2AF 27                       '
        plp                                     ; B2B0 28                       (
        .byte   $2F                             ; B2B1 2F                       /
        rol     $27                             ; B2B2 26 27                    &'
        eor     #$08                            ; B2B4 49 08                    I.
        .byte   $9B                             ; B2B6 9B                       .
        php                                     ; B2B7 08                       .
        rol     $2629                           ; B2B8 2E 29 26                 .)&
        .byte   $27                             ; B2BB 27                       '
        plp                                     ; B2BC 28                       (
        eor     #$26                            ; B2BD 49 26                    I&
        .byte   $27                             ; B2BF 27                       '
        .byte   $8F                             ; B2C0 8F                       .
        .byte   $8F                             ; B2C1 8F                       .
        tya                                     ; B2C2 98                       .
        tya                                     ; B2C3 98                       .
        .byte   $3A                             ; B2C4 3A                       :
        eor     #$26                            ; B2C5 49 26                    I&
        .byte   $27                             ; B2C7 27                       '
        .byte   $8F                             ; B2C8 8F                       .
        and     ($98),y                         ; B2C9 31 98                    1.
        .byte   $27                             ; B2CB 27                       '
        php                                     ; B2CC 08                       .
        php                                     ; B2CD 08                       .
        php                                     ; B2CE 08                       .
        eor     ($05,x)                         ; B2CF 41 05                    A.
        adc     ($1E,x)                         ; B2D1 61 1E                    a.
        ora     $3103,x                         ; B2D3 1D 03 31                 ..1
        eor     $8F27,x                         ; B2D6 5D 27 8F                 ]'.
        .byte   $8F                             ; B2D9 8F                       .
        brk                                     ; B2DA 00                       .
        brk                                     ; B2DB 00                       .
        brk                                     ; B2DC 00                       .
        brk                                     ; B2DD 00                       .
        brk                                     ; B2DE 00                       .
        brk                                     ; B2DF 00                       .
        rol     $27                             ; B2E0 26 27                    &'
        rol     $262F                           ; B2E2 2E 2F 26                 ./&
        .byte   $27                             ; B2E5 27                       '
        lsr     a                               ; B2E6 4A                       J
        .byte   $4B                             ; B2E7 4B                       K
        lda     ($A2,x)                         ; B2E8 A1 A2                    ..
        lda     #$AA                            ; B2EA A9 AA                    ..
        brk                                     ; B2EC 00                       .
        ldy     #$00                            ; B2ED A0 00                    ..
        tay                                     ; B2EF A8                       .
        and     a:$35,x                         ; B2F0 3D 35 00                 =5.
        and     $3D36,x                         ; B2F3 3D 36 3D                 =6=
        rol     $3500,x                         ; B2F6 3E 00 35                 >.5
        and     $363D,x                         ; B2F9 3D 3D 36                 ==6
        .byte   $3F                             ; B2FC 3F                       ?
        brk                                     ; B2FD 00                       .
        brk                                     ; B2FE 00                       .
        brk                                     ; B2FF 00                       .
        brk                                     ; B300 00                       .
        rol     $3F00,x                         ; B301 3E 00 3F                 >.?
        brk                                     ; B304 00                       .
        brk                                     ; B305 00                       .
        brk                                     ; B306 00                       .
        and     (L0000),y                       ; B307 31 00                    1.
        brk                                     ; B309 00                       .
        plp                                     ; B30A 28                       (
        and     #$00                            ; B30B 29 00                    ).
        eor     $3D00                           ; B30D 4D 00 3D                 M.=
        .byte   $42                             ; B310 42                       B
        .byte   $27                             ; B311 27                       '
        brk                                     ; B312 00                       .
        .byte   $2F                             ; B313 2F                       /
        brk                                     ; B314 00                       .
        .byte   $27                             ; B315 27                       '
        brk                                     ; B316 00                       .
        .byte   $2F                             ; B317 2F                       /
        .byte   $3A                             ; B318 3A                       :
        and     $2F2E,y                         ; B319 39 2E 2F                 9./
        pha                                     ; B31C 48                       H
        brk                                     ; B31D 00                       .
        rol     a:$31                           ; B31E 2E 31 00                 .1.
        eor     ($28,x)                         ; B321 41 28                    A(
        .byte   $2F                             ; B323 2F                       /
        sec                                     ; B324 38                       8
        .byte   $27                             ; B325 27                       '
        rol     $2E2F                           ; B326 2E 2F 2E                 ./.
        .byte   $2F                             ; B329 2F                       /
        jmp     L004D                           ; B32A 4C 4D 00                 LM.

; ----------------------------------------------------------------------------
        brk                                     ; B32D 00                       .
        lda     $A3                             ; B32E A5 A3                    ..
        sta     $289D,x                         ; B330 9D 9D 28                 ..(
        and     #$A5                            ; B333 29 A5                    ).
        .byte   $A3                             ; B335 A3                       .
        plp                                     ; B336 28                       (
        and     #$00                            ; B337 29 00                    ).
        brk                                     ; B339 00                       .
        sec                                     ; B33A 38                       8
        lsr     L0000                           ; B33B 46 00                    F.
        brk                                     ; B33D 00                       .
        sec                                     ; B33E 38                       8
        and     L0000,y                         ; B33F 39 00 00                 9..
        pha                                     ; B342 48                       H
        brk                                     ; B343 00                       .
        lsr     a                               ; B344 4A                       J
        .byte   $4B                             ; B345 4B                       K
        brk                                     ; B346 00                       .
        brk                                     ; B347 00                       .
        brk                                     ; B348 00                       .
        brk                                     ; B349 00                       .
        .byte   $89                             ; B34A 89                       .
        txa                                     ; B34B 8A                       .
        sta     $8B8E                           ; B34C 8D 8E 8B                 ...
        sty     $4B4A                           ; B34F 8C 4A 4B                 .JK
        .byte   $89                             ; B352 89                       .
        txa                                     ; B353 8A                       .
        rol     $2632                           ; B354 2E 32 26                 .2&
        .byte   $32                             ; B357 32                       2
        lsr     a                               ; B358 4A                       J
        .byte   $32                             ; B359 32                       2
        brk                                     ; B35A 00                       .
        .byte   $32                             ; B35B 32                       2
        brk                                     ; B35C 00                       .
        brk                                     ; B35D 00                       .
        brk                                     ; B35E 00                       .
        eor     (L0000,x)                       ; B35F 41 00                    A.
        .byte   $32                             ; B361 32                       2
        sec                                     ; B362 38                       8
        and     $26,y                           ; B363 39 26 00                 9&.
        rol     $2600                           ; B366 2E 00 26                 ..&
        brk                                     ; B369 00                       .
        lsr     a                               ; B36A 4A                       J
        brk                                     ; B36B 00                       .
        and     LA8A2,x                         ; B36C 3D A2 A8                 =..
        tax                                     ; B36F AA                       .
        sta     $9B9A,y                         ; B370 99 9A 9B                 ...
        .byte   $9C                             ; B373 9C                       .
        rol     L004D                           ; B374 26 4D                    &M
        rol     $9900                           ; B376 2E 00 99                 ...
        brk                                     ; B379 00                       .
        .byte   $9B                             ; B37A 9B                       .
        brk                                     ; B37B 00                       .
        brk                                     ; B37C 00                       .
        brk                                     ; B37D 00                       .
        ldy     $A5                             ; B37E A4 A5                    ..
        rol     $A4                             ; B380 26 A4                    &.
        rol     $9D9D                           ; B382 2E 9D 9D                 ...
        sta     $9D9D,x                         ; B385 9D 9D 9D                 ...
        rol     $33                             ; B388 26 33                    &3
        rol     $2632                           ; B38A 2E 32 26                 .2&
        .byte   $32                             ; B38D 32                       2
        rol     a:$32                           ; B38E 2E 32 00                 .2.
        .byte   $6B                             ; B391 6B                       k
        brk                                     ; B392 00                       .
        .byte   $6B                             ; B393 6B                       k
        brk                                     ; B394 00                       .
        adc     L0000                           ; B395 65 00                    e.
        adc     $65                             ; B397 65 65                    ee
        brk                                     ; B399 00                       .
        adc     L0000                           ; B39A 65 00                    e.
        brk                                     ; B39C 00                       .
        brk                                     ; B39D 00                       .
        brk                                     ; B39E 00                       .
        .byte   $67                             ; B39F 67                       g
        brk                                     ; B3A0 00                       .
        adc     $68                             ; B3A1 65 68                    eh
        ror     $65                             ; B3A3 66 65                    fe
        brk                                     ; B3A5 00                       .
        ror     $69                             ; B3A6 66 69                    fi
        brk                                     ; B3A8 00                       .
        adc     $6A                             ; B3A9 65 6A                    ej
        adc     $62                             ; B3AB 65 62                    eb
        .byte   $63                             ; B3AD 63                       c
        tax                                     ; B3AE AA                       .
        and     $6BA3,x                         ; B3AF 3D A3 6B                 =.k
        .byte   $9D,$6B,$A3                     ; B3B2 9D 6B A3                 .k.
        adc     $9D                             ; B3B5 65 9D                    e.
        adc     $91                             ; B3B7 65 91                    e.
        .byte   $64                             ; B3B9 64                       d
        tax                                     ; B3BA AA                       .
        and     $6565,x                         ; B3BB 3D 65 65                 =ee
        adc     $65                             ; B3BE 65 65                    ee
        sec                                     ; B3C0 38                       8
        and     $2F2E,y                         ; B3C1 39 2E 2F                 9./
        sec                                     ; B3C4 38                       8
        lsr     $2E                             ; B3C5 46 2E                    F.
        .byte   $2F                             ; B3C7 2F                       /
        sta     $9D65,x                         ; B3C8 9D 65 9D                 .e.
        adc     $A4                             ; B3CB 65 A4                    e.
LB3CD:  .byte   $A3                             ; B3CD A3                       .
        sta     a:$9D,x                         ; B3CE 9D 9D 00                 ...
        brk                                     ; B3D1 00                       .
        .byte   $A3                             ; B3D2 A3                       .
        brk                                     ; B3D3 00                       .
        sta     $9DA3,x                         ; B3D4 9D A3 9D                 ...
        sta     $6565,x                         ; B3D7 9D 65 65                 .ee
        jmp     (L0066)                         ; B3DA 6C 66 00                 lf.

; ----------------------------------------------------------------------------
        brk                                     ; B3DD 00                       .
        ror     a                               ; B3DE 6A                       j
        brk                                     ; B3DF 00                       .
        brk                                     ; B3E0 00                       .
        .byte   $6B                             ; B3E1 6B                       k
        bmi     LB40D                           ; B3E2 30 29                    0)
        brk                                     ; B3E4 00                       .
        brk                                     ; B3E5 00                       .
        brk                                     ; B3E6 00                       .
        .byte   $33                             ; B3E7 33                       3
        brk                                     ; B3E8 00                       .
        brk                                     ; B3E9 00                       .
        .byte   $92                             ; B3EA 92                       .
        .byte   $93                             ; B3EB 93                       .
        brk                                     ; B3EC 00                       .
        brk                                     ; B3ED 00                       .
        .byte   $93                             ; B3EE 93                       .
        sty     L0000,x                         ; B3EF 94 00                    ..
        .byte   $32                             ; B3F1 32                       2
        brk                                     ; B3F2 00                       .
        .byte   $32                             ; B3F3 32                       2
        brk                                     ; B3F4 00                       .
        .byte   $92                             ; B3F5 92                       .
        brk                                     ; B3F6 00                       .
        brk                                     ; B3F7 00                       .
        .byte   $93                             ; B3F8 93                       .
        .byte   $93                             ; B3F9 93                       .
        lda     #$00                            ; B3FA A9 00                    ..
        sty     $A2,x                           ; B3FC 94 A2                    ..
        tay                                     ; B3FE A8                       .
        tax                                     ; B3FF AA                       .
        brk                                     ; B400 00                       .
        .byte   $32                             ; B401 32                       2
        plp                                     ; B402 28                       (
        eor     #$00                            ; B403 49 00                    I.
        brk                                     ; B405 00                       .
        .byte   $A3                             ; B406 A3                       .
        ldy     L0000                           ; B407 A4 00                    ..
        eor     (L0000,x)                       ; B409 41 00                    A.
        .byte   $2F                             ; B40B 2F                       /
        .byte   $9D                             ; B40C 9D                       .
LB40D:  .byte   $9F                             ; B40D 9F                       .
        .byte   $9D,$9F,$A4                     ; B40E 9D 9F A4                 ...
        lda     $9D                             ; B411 A5 9D                    ..
        sta     $3200,x                         ; B413 9D 00 32                 ..2
        .byte   $A3                             ; B416 A3                       .
        .byte   $32                             ; B417 32                       2
        .byte   $47                             ; B418 47                       G
        brk                                     ; B419 00                       .
        rol     L0000                           ; B41A 26 00                    &.
        .byte   $47                             ; B41C 47                       G
        .byte   $33                             ; B41D 33                       3
        rol     $32                             ; B41E 26 32                    &2
        php                                     ; B420 08                       .
        .byte   $5C                             ; B421 5C                       \
        php                                     ; B422 08                       .
        php                                     ; B423 08                       .
        jsr     L2A20                           ; B424 20 20 2A                   *
        .byte   $2B                             ; B427 2B                       +
        .byte   $17                             ; B428 17                       .
        php                                     ; B429 08                       .
        bit     $0508                           ; B42A 2C 08 05                 ,..
        .byte   $07                             ; B42D 07                       .
        brk                                     ; B42E 00                       .
        ora     $0760                           ; B42F 0D 60 07                 .`.
        brk                                     ; B432 00                       .
        ora     a:L0000                         ; B433 0D 00 00                 ...
        asl     a:$1E,x                         ; B436 1E 1E 00                 ...
        brk                                     ; B439 00                       .
        ora     $241D,x                         ; B43A 1D 1D 24                 ..$
        bit     $90                             ; B43D 24 90                    $.
        bcc     LB479                           ; B43F 90 38                    .8
        .byte   $33                             ; B441 33                       3
        rol     $0832                           ; B442 2E 32 08                 .2.
        .byte   $07                             ; B445 07                       .
        ora     $61                             ; B446 05 61                    .a
        bit     $54                             ; B448 24 54                    $T
        bcc     LB3CD                           ; B44A 90 81                    ..
        brk                                     ; B44C 00                       .
        brk                                     ; B44D 00                       .
        .byte   $37                             ; B44E 37                       7
        .byte   $37                             ; B44F 37                       7
        .byte   $54                             ; B450 54                       T
        brk                                     ; B451 00                       .
        sta     ($37,x)                         ; B452 81 37                    .7
        brk                                     ; B454 00                       .
        .byte   $54                             ; B455 54                       T
        .byte   $37                             ; B456 37                       7
        sta     ($52,x)                         ; B457 81 52                    .R
        .byte   $53                             ; B459 53                       S
        .byte   $5A                             ; B45A 5A                       Z
        .byte   $5B                             ; B45B 5B                       [
        .byte   $74                             ; B45C 74                       t
        adc     $7C,x                           ; B45D 75 7C                    u|
        adc     $0808,x                         ; B45F 7D 08 08                 }..
        ora     $05                             ; B462 05 05                    ..
        .byte   $07                             ; B464 07                       .
        .byte   $07                             ; B465 07                       .
        asl     $0D                             ; B466 06 0D                    ..
        rts                                     ; B468 60                       `

; ----------------------------------------------------------------------------
        adc     (L0000,x)                       ; B469 61 00                    a.
        brk                                     ; B46B 00                       .
        brk                                     ; B46C 00                       .
        ora     a:L0000                         ; B46D 0D 00 00                 ...
        brk                                     ; B470 00                       .
        brk                                     ; B471 00                       .
        .byte   $54                             ; B472 54                       T
        .byte   $54                             ; B473 54                       T
        brk                                     ; B474 00                       .
        brk                                     ; B475 00                       .
        .byte   $77                             ; B476 77                       w
        .byte   $77                             ; B477 77                       w
        .byte   $81                             ; B478 81                       .
LB479:  sta     ($81,x)                         ; B479 81 81                    ..
        sta     ($51,x)                         ; B47B 81 51                    .Q
        lsr     $8050,x                         ; B47D 5E 50 80                 ^P.
        eor     ($51),y                         ; B480 51 51                    QQ
        bvc     LB4D4                           ; B482 50 50                    PP
        cli                                     ; B484 58                       X
        cli                                     ; B485 58                       X
        bvc     LB4D8                           ; B486 50 50                    PP
        .byte   $74                             ; B488 74                       t
        .byte   $54                             ; B489 54                       T
        .byte   $7C                             ; B48A 7C                       |
        lsr     $50,x                           ; B48B 56 50                    VP
        bvc     LB4DF                           ; B48D 50 50                    PP
        bvc     LB506                           ; B48F 50 75                    Pu
        .byte   $74                             ; B491 74                       t
        adc     $757C,x                         ; B492 7D 7C 75                 }|u
        lsr     $807D,x                         ; B495 5E 7D 80                 ^}.
        .byte   $7F                             ; B498 7F                       .
        .byte   $77                             ; B499 77                       w
        eor     ($51),y                         ; B49A 51 51                    QQ
        adc     $74,x                           ; B49C 75 74                    ut
        adc     $7554,x                         ; B49E 7D 54 75                 }Tu
        .byte   $74                             ; B4A1 74                       t
        .byte   $7F                             ; B4A2 7F                       .
        .byte   $7F                             ; B4A3 7F                       .
        adc     $5E,x                           ; B4A4 75 5E                    u^
        .byte   $7F                             ; B4A6 7F                       .
        .byte   $77                             ; B4A7 77                       w
        .byte   $74                             ; B4A8 74                       t
        adc     $7C,x                           ; B4A9 75 7C                    u|
        .byte   $54                             ; B4AB 54                       T
        .byte   $74                             ; B4AC 74                       t
        lsr     $7F,x                           ; B4AD 56 7F                    V.
        .byte   $77                             ; B4AF 77                       w
        adc     (L0000),y                       ; B4B0 71 00                    q.
        .byte   $59                             ; B4B2 59                       Y
LB4B3:  brk                                     ; B4B3 00                       .
        brk                                     ; B4B4 00                       .
LB4B5:  .byte   $72                             ; B4B5 72                       r
        brk                                     ; B4B6 00                       .
LB4B7:  bvs     LB509                           ; B4B7 70 50                    pP
        bvc     LB50D                           ; B4B9 50 52                    PR
        .byte   $53                             ; B4BB 53                       S
        adc     $56,x                           ; B4BC 75 56                    uV
        adc     $595E,x                         ; B4BE 7D 5E 59                 }^Y
        brk                                     ; B4C1 00                       .
        eor     L0000,y                         ; B4C2 59 00 00                 Y..
        bvs     LB4C7                           ; B4C5 70 00                    p.
LB4C7:  bvs     LB523                           ; B4C7 70 5A                    pZ
LB4C9:  .byte   $5B                             ; B4C9 5B                       [
        eor     ($51),y                         ; B4CA 51 51                    QQ
        .byte   $5A                             ; B4CC 5A                       Z
        .byte   $5B                             ; B4CD 5B                       [
        .byte   $77                             ; B4CE 77                       w
        .byte   $7F                             ; B4CF 7F                       .
        .byte   $74                             ; B4D0 74                       t
        .byte   $54                             ; B4D1 54                       T
        .byte   $7C                             ; B4D2 7C                       |
        .byte   $81                             ; B4D3 81                       .
LB4D4:  .byte   $54                             ; B4D4 54                       T
        adc     $56,x                           ; B4D5 75 56                    uV
        .byte   $7D                             ; B4D7 7D                       }
LB4D8:  adc     $81,x                           ; B4D8 75 81                    u.
        adc     $5E81,x                         ; B4DA 7D 81 5E                 }.^
        .byte   $74                             ; B4DD 74                       t
        .byte   $77                             ; B4DE 77                       w
LB4DF:  .byte   $7F                             ; B4DF 7F                       .
        .byte   $7F                             ; B4E0 7F                       .
        lsr     $7C,x                           ; B4E1 56 7C                    V|
        lsr     $7F5E,x                         ; B4E3 5E 5E 7F                 ^^.
        lsr     $7F7D,x                         ; B4E6 5E 7D 7F                 ^}.
        .byte   $7F                             ; B4E9 7F                       .
LB4EA:  .byte   $7C                             ; B4EA 7C                       |
        adc     $5E74,x                         ; B4EB 7D 74 5E                 }t^
        .byte   $7C                             ; B4EE 7C                       |
        lsr     $5050,x                         ; B4EF 5E 50 50                 ^PP
        sei                                     ; B4F2 78                       x
        sei                                     ; B4F3 78                       x
        .byte   $54                             ; B4F4 54                       T
        .byte   $74                             ; B4F5 74                       t
        sta     ($7C,x)                         ; B4F6 81 7C                    .|
        adc     $5E,x                           ; B4F8 75 5E                    u^
        adc     $815E,x                         ; B4FA 7D 5E 81                 }^.
        adc     $56,x                           ; B4FD 75 56                    uV
        .byte   $7D                             ; B4FF 7D                       }
LB500:  lsr     $5E74,x                         ; B500 5E 74 5E                 ^t^
        .byte   $7C                             ; B503 7C                       |
        adc     $81,x                           ; B504 75 81                    u.
LB506:  adc     $5E56,x                         ; B506 7D 56 5E                 }V^
LB509:  adc     $5E,x                           ; B509 75 5E                    u^
        .byte   $7D                             ; B50B 7D                       }
        .byte   $74                             ; B50C 74                       t
LB50D:  adc     $7F,x                           ; B50D 75 7F                    u.
        .byte   $7F                             ; B50F 7F                       .
        .byte   $74                             ; B510 74                       t
        .byte   $54                             ; B511 54                       T
        .byte   $7F                             ; B512 7F                       .
        .byte   $77                             ; B513 77                       w
        .byte   $7F                             ; B514 7F                       .
        .byte   $7F                             ; B515 7F                       .
        eor     ($51),y                         ; B516 51 51                    QQ
        adc     $54,x                           ; B518 75 54                    uT
        adc     $7481,x                         ; B51A 7D 81 74                 }.t
        sta     ($7C,x)                         ; B51D 81 7C                    .|
        lsr     L0000,x                         ; B51F 56 00                    V.
        brk                                     ; B521 00                       .
        .byte   $73                             ; B522 73                       s
LB523:  brk                                     ; B523 00                       .
        bvc     LB576                           ; B524 50 50                    PP
        bvc     LB59F                           ; B526 50 77                    Pw
        sta     $86                             ; B528 85 86                    ..
        .byte   $82                             ; B52A 82                       .
        .byte   $83                             ; B52B 83                       .
        .byte   $7F                             ; B52C 7F                       .
        .byte   $7F                             ; B52D 7F                       .
        eor     ($54),y                         ; B52E 51 54                    QT
        bvc     LB4B3                           ; B530 50 81                    P.
        bvc     LB4B5                           ; B532 50 81                    P.
        bvc     LB4B7                           ; B534 50 81                    P.
        sei                                     ; B536 78                       x
        lsr     $50,x                           ; B537 56 50                    VP
        lsr     $5E50,x                         ; B539 5E 50 5E                 ^P^
        .byte   $87                             ; B53C 87                       .
        dey                                     ; B53D 88                       .
        .byte   $83                             ; B53E 83                       .
        sty     $50                             ; B53F 84 50                    .P
        bvc     LB597                           ; B541 50 54                    PT
        bvc     LB595                           ; B543 50 50                    PP
        .byte   $54                             ; B545 54                       T
        bvc     LB4C9                           ; B546 50 81                    P.
        sta     ($50,x)                         ; B548 81 50                    .P
        sta     ($50,x)                         ; B54A 81 50                    .P
        adc     $74,x                           ; B54C 75 74                    ut
        .byte   $54                             ; B54E 54                       T
        .byte   $7F                             ; B54F 7F                       .
        sta     ($50,x)                         ; B550 81 50                    .P
        .byte   $77                             ; B552 77                       w
        bvc     LB5A5                           ; B553 50 50                    PP
        sta     ($50,x)                         ; B555 81 50                    .P
        .byte   $56                             ; B557 56                       V
LB558:  lsr     $51,x                           ; B558 56 51                    VQ
LB55A:  .byte   $77                             ; B55A 77                       w
        .byte   $50                             ; B55B 50                       P
LB55C:  eor     ($50),y                         ; B55C 51 50                    QP
        .byte   $50,$50                    ; B55E 50 50   (branch out of range for ca65: target has no local label)
        eor     $55,x                           ; B560 55 55                    UU
        eor     ($51),y                         ; B562 51 51                    QQ
        eor     $50,x                           ; B564 55 50                    UP
        eor     ($50),y                         ; B566 51 50                    QP
        sta     ($51,x)                         ; B568 81 51                    .Q
        sta     ($50,x)                         ; B56A 81 50                    .P
        .byte   $54                             ; B56C 54                       T
        adc     $81,x                           ; B56D 75 81                    u.
        adc     $5081,x                         ; B56F 7D 81 50                 }.P
        lsr     $50,x                           ; B572 56 50                    VP
        .byte   $81                             ; B574 81                       .
LB575:  .byte   $74                             ; B575 74                       t
LB576:  lsr     $7C,x                           ; B576 56 7C                    V|
        lsr     $5E50,x                         ; B578 5E 50 5E                 ^P^
        bvc     LB5D1                           ; B57B 50 54                    PT
        bvc     LB500                           ; B57D 50 81                    P.
        bvc     LB5D1                           ; B57F 50 50                    PP
        .byte   $77                             ; B581 77                       w
        bvc     LB5D5                           ; B582 50 51                    PQ
        adc     $7950,y                         ; B584 79 50 79                 yPy
        bvc     LB5FD                           ; B587 50 74                    Pt
        adc     $54,x                           ; B589 75 54                    uT
        .byte   $7C                             ; B58B 7C                       |
        sta     ($74,x)                         ; B58C 81 74                    .t
        .byte   $77                             ; B58E 77                       w
        .byte   $7F                             ; B58F 7F                       .
        adc     $74,x                           ; B590 75 74                    ut
        .byte   $54                             ; B592 54                       T
        .byte   $7C                             ; B593 7C                       |
        .byte   $51                             ; B594 51                       Q
LB595:  eor     ($78),y                         ; B595 51 78                    Qx
LB597:  sei                                     ; B597 78                       x
        sta     ($75,x)                         ; B598 81 75                    .u
        .byte   $77                             ; B59A 77                       w
        .byte   $7F                             ; B59B 7F                       .
        .byte   $54                             ; B59C 54                       T
        .byte   $7F                             ; B59D 7F                       .
        .byte   $81                             ; B59E 81                       .
LB59F:  adc     $547F,x                         ; B59F 7D 7F 54                 }.T
        .byte   $7C                             ; B5A2 7C                       |
        sta     ($54,x)                         ; B5A3 81 54                    .T
LB5A5:  .byte   $7F                             ; B5A5 7F                       .
        sta     ($7C,x)                         ; B5A6 81 7C                    .|
        .byte   $77                             ; B5A8 77                       w
        .byte   $74                             ; B5A9 74                       t
        adc     $757C,x                         ; B5AA 7D 7C 75                 }|u
        .byte   $77                             ; B5AD 77                       w
LB5AE:  .byte   $7D                             ; B5AE 7D                       }
LB5AF:  .byte   $7C                             ; B5AF 7C                       |
        .byte   $7F                             ; B5B0 7F                       .
        .byte   $54                             ; B5B1 54                       T
        adc     $7781,x                         ; B5B2 7D 81 77                 }.w
        .byte   $75                             ; B5B5 75                       u
LB5B6:  .byte   $7C                             ; B5B6 7C                       |
        .byte   $7D                             ; B5B7 7D                       }
LB5B8:  .byte   $74                             ; B5B8 74                       t
        .byte   $77                             ; B5B9 77                       w
        .byte   $7C                             ; B5BA 7C                       |
        adc     $8174,x                         ; B5BB 7D 74 81                 }t.
        .byte   $7C                             ; B5BE 7C                       |
        sta     ($74,x)                         ; B5BF 81 74                    .t
LB5C1:  adc     $54,x                           ; B5C1 75 54                    uT
        adc     $7F77,x                         ; B5C3 7D 77 7F                 }w.
        eor     ($51),y                         ; B5C6 51 51                    QQ
        .byte   $7F                             ; B5C8 7F                       .
        .byte   $7F                             ; B5C9 7F                       .
        eor     ($7A),y                         ; B5CA 51 7A                    Qz
        bvc     LB622                           ; B5CC 50 54                    PT
        bvc     LB626                           ; B5CE 50 56                    PV
        .byte   $50                             ; B5D0 50                       P
LB5D1:  .byte   $7A                             ; B5D1 7A                       z
        bvc     LB64E                           ; B5D2 50 7A                    Pz
        .byte   $54                             ; B5D4 54                       T
LB5D5:  bvs     LB558                           ; B5D5 70 81                    p.
        bvs     LB55A                           ; B5D7 70 81                    p.
        bvs     LB55C                           ; B5D9 70 81                    p.
        bvs     LB65C                           ; B5DB 70 7F                    p.
        .byte   $7F                             ; B5DD 7F                       .
        adc     (L0000),y                       ; B5DE 71 00                    q.
        .byte   $7F                             ; B5E0 7F                       .
        .byte   $7F                             ; B5E1 7F                       .
        brk                                     ; B5E2 00                       .
        brk                                     ; B5E3 00                       .
        .byte   $7F                             ; B5E4 7F                       .
        .byte   $7F                             ; B5E5 7F                       .
        brk                                     ; B5E6 00                       .
        .byte   $72                             ; B5E7 72                       r
        .byte   $74                             ; B5E8 74                       t
        adc     $54,x                           ; B5E9 75 54                    uT
        .byte   $7F                             ; B5EB 7F                       .
        .byte   $74                             ; B5EC 74                       t
        adc     $7F,x                           ; B5ED 75 7F                    u.
        .byte   $54                             ; B5EF 54                       T
        eor     ($81),y                         ; B5F0 51 81                    Q.
        bvc     LB575                           ; B5F2 50 81                    P.
        .byte   $77                             ; B5F4 77                       w
        bvc     LB648                           ; B5F5 50 51                    PQ
        bvc     LB66D                           ; B5F7 50 74                    Pt
        adc     $7C,x                           ; B5F9 75 7C                    u|
        .byte   $7D                             ; B5FB 7D                       }
        brk                                     ; B5FC 00                       .
LB5FD:  brk                                     ; B5FD 00                       .
        brk                                     ; B5FE 00                       .
        brk                                     ; B5FF 00                       .
        brk                                     ; B600 00                       .
        ora     ($02,x)                         ; B601 01 02                    ..
        .byte   $03                             ; B603 03                       .
        .byte   $04                             ; B604 04                       .
        ora     $06                             ; B605 05 06                    ..
        .byte   $07                             ; B607 07                       .
        php                                     ; B608 08                       .
        ora     #$05                            ; B609 09 05                    ..
        asl     $07                             ; B60B 06 07                    ..
        asl     a                               ; B60D 0A                       .
        .byte   $0B                             ; B60E 0B                       .
        .byte   $0C                             ; B60F 0C                       .
        ora     $0A0E                           ; B610 0D 0E 0A                 ...
        .byte   $0B                             ; B613 0B                       .
        .byte   $0F                             ; B614 0F                       .
        bpl     LB628                           ; B615 10 11                    ..
        brk                                     ; B617 00                       .
        .byte   $12                             ; B618 12                       .
        .byte   $13                             ; B619 13                       .
        .byte   $14                             ; B61A 14                       .
        ora     $16,x                           ; B61B 15 16                    ..
        .byte   $17                             ; B61D 17                       .
        clc                                     ; B61E 18                       .
        php                                     ; B61F 08                       .
        .byte   $19                             ; B620 19                       .
        .byte   $1A                             ; B621 1A                       .
LB622:  ora     $1C1B,y                         ; B622 19 1B 1C                 ...
        .byte   $1D                             ; B625 1D                       .
LB626:  .byte   $1B                             ; B626 1B                       .
        .byte   $1E                             ; B627 1E                       .
LB628:  .byte   $1F                             ; B628 1F                       .
        jsr     L201F                           ; B629 20 1F 20                  . 
        .byte   $1F                             ; B62C 1F                       .
        and     (L0022,x)                       ; B62D 21 22                    !"
        .byte   $23                             ; B62F 23                       #
        bit     $24                             ; B630 24 24                    $$
        bit     $24                             ; B632 24 24                    $$
        bit     $24                             ; B634 24 24                    $$
        and     $25                             ; B636 25 25                    %%
        and     $25                             ; B638 25 25                    %%
        and     $25                             ; B63A 25 25                    %%
        and     $25                             ; B63C 25 25                    %%
        and     $25                             ; B63E 25 25                    %%
        ora     $0100                           ; B640 0D 00 01                 ...
        .byte   $02                             ; B643 02                       .
        .byte   $03                             ; B644 03                       .
        .byte   $04                             ; B645 04                       .
        ora     $06                             ; B646 05 06                    ..
LB648:  ora     $0908                           ; B648 0D 08 09                 ...
        ora     $06                             ; B64B 05 06                    ..
        .byte   $07                             ; B64D 07                       .
LB64E:  asl     a                               ; B64E 0A                       .
        .byte   $0B                             ; B64F 0B                       .
        ora     ($02,x)                         ; B650 01 02                    ..
        asl     $0B0A                           ; B652 0E 0A 0B                 ...
        .byte   $0F                             ; B655 0F                       .
        bpl     LB669                           ; B656 10 11                    ..
        ora     #$12                            ; B658 09 12                    ..
        .byte   $13                             ; B65A 13                       .
        .byte   $14                             ; B65B 14                       .
LB65C:  ora     $26,x                           ; B65C 15 26                    .&
        .byte   $17                             ; B65E 17                       .
        clc                                     ; B65F 18                       .
        .byte   $27                             ; B660 27                       '
        ora     $191A,y                         ; B661 19 1A 19                 ...
        .byte   $1B                             ; B664 1B                       .
        plp                                     ; B665 28                       (
        ora     $291B,x                         ; B666 1D 1B 29                 ..)
LB669:  .byte   $23                             ; B669 23                       #
        rol     a                               ; B66A 2A                       *
        .byte   $1F                             ; B66B 1F                       .
        .byte   $20                             ; B66C 20                        
LB66D:  .byte   $1F                             ; B66D 1F                       .
        .byte   $2B                             ; B66E 2B                       +
        bit     $25                             ; B66F 24 25                    $%
        and     $25                             ; B671 25 25                    %%
        bit     $24                             ; B673 24 24                    $$
        bit     $2C                             ; B675 24 2C                    $,
        and     $25                             ; B677 25 25                    %%
        and     $25                             ; B679 25 25                    %%
        and     $25                             ; B67B 25 25                    %%
        and     $25                             ; B67D 25 25                    %%
        and     $07                             ; B67F 25 07                    %.
        ora     $0100                           ; B681 0D 00 01                 ...
        .byte   $02                             ; B684 02                       .
        .byte   $03                             ; B685 03                       .
        .byte   $04                             ; B686 04                       .
        ora     $0D0C                           ; B687 0D 0C 0D                 ...
        php                                     ; B68A 08                       .
        ora     #$0D                            ; B68B 09 0D                    ..
        ora     $06                             ; B68D 05 06                    ..
        .byte   $07                             ; B68F 07                       .
        brk                                     ; B690 00                       .
        ora     ($02,x)                         ; B691 01 02                    ..
        asl     $0A0D                           ; B693 0E 0D 0A                 ...
        .byte   $0B                             ; B696 0B                       .
        .byte   $0F                             ; B697 0F                       .
        php                                     ; B698 08                       .
        ora     #$26                            ; B699 09 26                    .&
        clc                                     ; B69B 18                       .
        asl     $14,x                           ; B69C 16 14                    ..
        ora     $17,x                           ; B69E 15 17                    ..
        asl     $2827,x                         ; B6A0 1E 27 28                 .'(
        .byte   $1B                             ; B6A3 1B                       .
        .byte   $1C                             ; B6A4 1C                       .
        ora     $1D1B,y                         ; B6A5 19 1B 1D                 ...
        and     $0D20                           ; B6A8 2D 20 0D                 - .
        jsr     L0D0D                           ; B6AB 20 0D 0D                  ..
        jsr     L2E2B                           ; B6AE 20 2B 2E                  +.
        .byte   $2F                             ; B6B1 2F                       /
        bmi     LB6E5                           ; B6B2 30 31                    01
        bmi     LB6E8                           ; B6B4 30 32                    02
        bit     $2C                             ; B6B6 24 2C                    $,
        and     $25                             ; B6B8 25 25                    %%
        bit     $25                             ; B6BA 24 25                    $%
        bit     $2C                             ; B6BC 24 2C                    $,
        and     $25                             ; B6BE 25 25                    %%
        ora     $06                             ; B6C0 05 06                    ..
        .byte   $07                             ; B6C2 07                       .
        ora     $0100                           ; B6C3 0D 00 01                 ...
        .byte   $02                             ; B6C6 02                       .
        .byte   $03                             ; B6C7 03                       .
        asl     a                               ; B6C8 0A                       .
        .byte   $0B                             ; B6C9 0B                       .
        .byte   $0C                             ; B6CA 0C                       .
        ora     $0908                           ; B6CB 0D 08 09                 ...
        ora     $100D                           ; B6CE 0D 0D 10                 ...
        ora     (L0000),y                       ; B6D1 11 00                    ..
        ora     ($02,x)                         ; B6D3 01 02                    ..
        asl     L0D0D                           ; B6D5 0E 0D 0D                 ...
        rol     $18                             ; B6D8 26 18                    &.
        php                                     ; B6DA 08                       .
        ora     #$33                            ; B6DB 09 33                    .3
        rol     a                               ; B6DD 2A                       *
        .byte   $17                             ; B6DE 17                       .
        .byte   $12                             ; B6DF 12                       .
        plp                                     ; B6E0 28                       (
        .byte   $1B                             ; B6E1 1B                       .
        .byte   $34                             ; B6E2 34                       4
        and     $2C,x                           ; B6E3 35 2C                    5,
LB6E5:  and     $1D                             ; B6E5 25 1D                    %.
        .byte   $19                             ; B6E7 19                       .
LB6E8:  .byte   $2F                             ; B6E8 2F                       /
        jsr     L2C2B                           ; B6E9 20 2B 2C                  +,
        and     $25                             ; B6EC 25 25                    %%
        and     ($0D,x)                         ; B6EE 21 0D                    !.
        and     $24                             ; B6F0 25 24                    %$
        bit     $2525                           ; B6F2 2C 25 25                 ,%%
        and     $36                             ; B6F5 25 36                    %6
        rol     $25,x                           ; B6F7 36 25                    6%
        and     $25                             ; B6F9 25 25                    %%
        and     $25                             ; B6FB 25 25                    %%
        and     $37                             ; B6FD 25 37                    %7
        .byte   $37                             ; B6FF 37                       7
        sec                                     ; B700 38                       8
        and     $3939,y                         ; B701 39 39 39                 999
        and     $3A39,y                         ; B704 39 39 3A                 99:
        .byte   $3B                             ; B707 3B                       ;
        sec                                     ; B708 38                       8
        .byte   $3C                             ; B709 3C                       <
        .byte   $3C                             ; B70A 3C                       <
        and     $3C3E,x                         ; B70B 3D 3E 3C                 =><
        .byte   $37                             ; B70E 37                       7
        .byte   $37                             ; B70F 37                       7
        sec                                     ; B710 38                       8
        .byte   $3B                             ; B711 3B                       ;
        .byte   $3A                             ; B712 3A                       :
        .byte   $3F                             ; B713 3F                       ?
        rti                                     ; B714 40                       @

; ----------------------------------------------------------------------------
        eor     (L0042,x)                       ; B715 41 42                    AB
        .byte   $42                             ; B717 42                       B
        sec                                     ; B718 38                       8
        .byte   $37                             ; B719 37                       7
        .byte   $37                             ; B71A 37                       7
        .byte   $3B                             ; B71B 3B                       ;
        .byte   $3A                             ; B71C 3A                       :
        .byte   $43                             ; B71D 43                       C
        .byte   $44                             ; B71E 44                       D
        sec                                     ; B71F 38                       8
        sec                                     ; B720 38                       8
        .byte   $3A                             ; B721 3A                       :
        .byte   $37                             ; B722 37                       7
        .byte   $37                             ; B723 37                       7
        .byte   $37                             ; B724 37                       7
        .byte   $37                             ; B725 37                       7
        eor     $38                             ; B726 45 38                    E8
        sec                                     ; B728 38                       8
        .byte   $37                             ; B729 37                       7
        lsr     $47                             ; B72A 46 47                    FG
        .byte   $42                             ; B72C 42                       B
        pha                                     ; B72D 48                       H
        eor     #$38                            ; B72E 49 38                    I8
        sec                                     ; B730 38                       8
        .byte   $37                             ; B731 37                       7
        sec                                     ; B732 38                       8
        sec                                     ; B733 38                       8
        sec                                     ; B734 38                       8
        sec                                     ; B735 38                       8
        sec                                     ; B736 38                       8
        sec                                     ; B737 38                       8
        sec                                     ; B738 38                       8
        .byte   $37                             ; B739 37                       7
        sec                                     ; B73A 38                       8
        sec                                     ; B73B 38                       8
        sec                                     ; B73C 38                       8
        sec                                     ; B73D 38                       8
        sec                                     ; B73E 38                       8
        sec                                     ; B73F 38                       8
        and     $3A                             ; B740 25 3A                    %:
        lsr     a                               ; B742 4A                       J
        lsr     a                               ; B743 4A                       J
        and     $25                             ; B744 25 25                    %%
        and     $25                             ; B746 25 25                    %%
        and     $37                             ; B748 25 37                    %7
        rol     $4A3C,x                         ; B74A 3E 3C 4A                 ><J
        and     $25                             ; B74D 25 25                    %%
        and     $25                             ; B74F 25 25                    %%
        .byte   $37                             ; B751 37                       7
        rti                                     ; B752 40                       @

; ----------------------------------------------------------------------------
        .byte   $3A                             ; B753 3A                       :
        and     $254A,x                         ; B754 3D 4A 25                 =J%
        and     $25                             ; B757 25 25                    %%
        .byte   $4B                             ; B759 4B                       K
        .byte   $37                             ; B75A 37                       7
        .byte   $37                             ; B75B 37                       7
        .byte   $3F                             ; B75C 3F                       ?
        rol     $254A,x                         ; B75D 3E 4A 25                 >J%
        and     $4C                             ; B760 25 4C                    %L
        eor     $374E                           ; B762 4D 4E 37                 MN7
        rti                                     ; B765 40                       @

; ----------------------------------------------------------------------------
        .byte   $3C                             ; B766 3C                       <
        lsr     a                               ; B767 4A                       J
        and     $25                             ; B768 25 25                    %%
        and     $25                             ; B76A 25 25                    %%
        .byte   $4F                             ; B76C 4F                       O
        bvc     LB7A6                           ; B76D 50 37                    P7
        .byte   $37                             ; B76F 37                       7
        and     $25                             ; B770 25 25                    %%
        and     $25                             ; B772 25 25                    %%
        and     $2E                             ; B774 25 2E                    %.
        bit     $24                             ; B776 24 24                    $$
        and     $25                             ; B778 25 25                    %%
        and     $25                             ; B77A 25 25                    %%
        and     $25                             ; B77C 25 25                    %%
        and     $25                             ; B77E 25 25                    %%
        and     $25                             ; B780 25 25                    %%
        and     $25                             ; B782 25 25                    %%
        and     $25                             ; B784 25 25                    %%
        and     $25                             ; B786 25 25                    %%
        and     $25                             ; B788 25 25                    %%
        and     $25                             ; B78A 25 25                    %%
        and     $25                             ; B78C 25 25                    %%
        and     $25                             ; B78E 25 25                    %%
        and     $25                             ; B790 25 25                    %%
        lsr     a                               ; B792 4A                       J
        lsr     a                               ; B793 4A                       J
        and     $25                             ; B794 25 25                    %%
        and     $25                             ; B796 25 25                    %%
        lsr     a                               ; B798 4A                       J
        lsr     a                               ; B799 4A                       J
        .byte   $37                             ; B79A 37                       7
        .byte   $37                             ; B79B 37                       7
        and     $25                             ; B79C 25 25                    %%
        lsr     a                               ; B79E 4A                       J
        lsr     a                               ; B79F 4A                       J
        .byte   $37                             ; B7A0 37                       7
        .byte   $37                             ; B7A1 37                       7
        .byte   $37                             ; B7A2 37                       7
        .byte   $37                             ; B7A3 37                       7
        eor     ($51),y                         ; B7A4 51 51                    QQ
LB7A6:  .byte   $37                             ; B7A6 37                       7
        .byte   $52                             ; B7A7 52                       R
        .byte   $37                             ; B7A8 37                       7
        .byte   $37                             ; B7A9 37                       7
        .byte   $37                             ; B7AA 37                       7
        .byte   $37                             ; B7AB 37                       7
        .byte   $37                             ; B7AC 37                       7
        .byte   $37                             ; B7AD 37                       7
        .byte   $37                             ; B7AE 37                       7
        .byte   $53                             ; B7AF 53                       S
        bit     $24                             ; B7B0 24 24                    $$
        bit     $24                             ; B7B2 24 24                    $$
        bit     $24                             ; B7B4 24 24                    $$
        bit     $24                             ; B7B6 24 24                    $$
        and     $25                             ; B7B8 25 25                    %%
        and     $25                             ; B7BA 25 25                    %%
        and     $25                             ; B7BC 25 25                    %%
        and     $25                             ; B7BE 25 25                    %%
        and     $25                             ; B7C0 25 25                    %%
        and     $25                             ; B7C2 25 25                    %%
        and     $25                             ; B7C4 25 25                    %%
        and     $25                             ; B7C6 25 25                    %%
        and     $25                             ; B7C8 25 25                    %%
        and     $25                             ; B7CA 25 25                    %%
        and     $25                             ; B7CC 25 25                    %%
        and     $25                             ; B7CE 25 25                    %%
        lsr     a                               ; B7D0 4A                       J
        lsr     a                               ; B7D1 4A                       J
        and     $25                             ; B7D2 25 25                    %%
        and     $25                             ; B7D4 25 25                    %%
        and     $25                             ; B7D6 25 25                    %%
        .byte   $37                             ; B7D8 37                       7
        .byte   $37                             ; B7D9 37                       7
        and     $25                             ; B7DA 25 25                    %%
        and     $25                             ; B7DC 25 25                    %%
        and     $25                             ; B7DE 25 25                    %%
        .byte   $37                             ; B7E0 37                       7
        .byte   $37                             ; B7E1 37                       7
        eor     ($51),y                         ; B7E2 51 51                    QQ
        eor     ($51),y                         ; B7E4 51 51                    QQ
        eor     ($54),y                         ; B7E6 51 54                    QT
        .byte   $37                             ; B7E8 37                       7
        .byte   $37                             ; B7E9 37                       7
        .byte   $37                             ; B7EA 37                       7
        .byte   $37                             ; B7EB 37                       7
        .byte   $37                             ; B7EC 37                       7
        .byte   $37                             ; B7ED 37                       7
        .byte   $37                             ; B7EE 37                       7
        .byte   $53                             ; B7EF 53                       S
        bit     $24                             ; B7F0 24 24                    $$
        bit     $24                             ; B7F2 24 24                    $$
        bit     $24                             ; B7F4 24 24                    $$
        bit     $24                             ; B7F6 24 24                    $$
        and     $25                             ; B7F8 25 25                    %%
        and     $25                             ; B7FA 25 25                    %%
        and     $25                             ; B7FC 25 25                    %%
        and     $25                             ; B7FE 25 25                    %%
        and     $25                             ; B800 25 25                    %%
        and     $25                             ; B802 25 25                    %%
        and     $25                             ; B804 25 25                    %%
        and     $25                             ; B806 25 25                    %%
        and     $25                             ; B808 25 25                    %%
        and     $25                             ; B80A 25 25                    %%
        and     $25                             ; B80C 25 25                    %%
        and     $25                             ; B80E 25 25                    %%
        and     $25                             ; B810 25 25                    %%
        and     $25                             ; B812 25 25                    %%
        and     $25                             ; B814 25 25                    %%
        and     $25                             ; B816 25 25                    %%
        and     $25                             ; B818 25 25                    %%
        and     $25                             ; B81A 25 25                    %%
        and     $25                             ; B81C 25 25                    %%
        and     $25                             ; B81E 25 25                    %%
        eor     ($51),y                         ; B820 51 51                    QQ
        eor     ($51),y                         ; B822 51 51                    QQ
        eor     ($51),y                         ; B824 51 51                    QQ
        eor     ($54),y                         ; B826 51 54                    QT
        .byte   $37                             ; B828 37                       7
        .byte   $37                             ; B829 37                       7
        .byte   $37                             ; B82A 37                       7
        .byte   $37                             ; B82B 37                       7
        .byte   $37                             ; B82C 37                       7
        .byte   $37                             ; B82D 37                       7
        .byte   $37                             ; B82E 37                       7
        .byte   $53                             ; B82F 53                       S
        bit     $24                             ; B830 24 24                    $$
        bit     $24                             ; B832 24 24                    $$
        bit     $24                             ; B834 24 24                    $$
        bit     $24                             ; B836 24 24                    $$
        and     $25                             ; B838 25 25                    %%
        and     $25                             ; B83A 25 25                    %%
        and     $25                             ; B83C 25 25                    %%
        and     $25                             ; B83E 25 25                    %%
        and     $25                             ; B840 25 25                    %%
        and     $25                             ; B842 25 25                    %%
        and     $25                             ; B844 25 25                    %%
        eor     $25,x                           ; B846 55 25                    U%
        and     $25                             ; B848 25 25                    %%
        and     $25                             ; B84A 25 25                    %%
        and     $25                             ; B84C 25 25                    %%
        eor     $25,x                           ; B84E 55 25                    U%
        and     $25                             ; B850 25 25                    %%
        and     $25                             ; B852 25 25                    %%
        and     $25                             ; B854 25 25                    %%
        eor     $25,x                           ; B856 55 25                    U%
        and     $25                             ; B858 25 25                    %%
        and     $25                             ; B85A 25 25                    %%
        and     $25                             ; B85C 25 25                    %%
        eor     $25,x                           ; B85E 55 25                    U%
        eor     ($51),y                         ; B860 51 51                    QQ
        eor     ($51),y                         ; B862 51 51                    QQ
        eor     ($51),y                         ; B864 51 51                    QQ
        lsr     $25,x                           ; B866 56 25                    V%
        .byte   $37                             ; B868 37                       7
        .byte   $37                             ; B869 37                       7
        .byte   $37                             ; B86A 37                       7
        .byte   $57                             ; B86B 57                       W
        .byte   $4F                             ; B86C 4F                       O
        .byte   $4F                             ; B86D 4F                       O
        cli                                     ; B86E 58                       X
        and     $24                             ; B86F 25 24                    %$
        bit     $24                             ; B871 24 24                    $$
        bit     $2525                           ; B873 2C 25 25                 ,%%
        and     $25                             ; B876 25 25                    %%
        and     $25                             ; B878 25 25                    %%
        and     $25                             ; B87A 25 25                    %%
        and     $25                             ; B87C 25 25                    %%
        and     $25                             ; B87E 25 25                    %%
        sec                                     ; B880 38                       8
        sec                                     ; B881 38                       8
        sec                                     ; B882 38                       8
        sec                                     ; B883 38                       8
        sec                                     ; B884 38                       8
        sec                                     ; B885 38                       8
        sec                                     ; B886 38                       8
        eor     $3838,y                         ; B887 59 38 38                 Y88
        sec                                     ; B88A 38                       8
        sec                                     ; B88B 38                       8
        sec                                     ; B88C 38                       8
        sec                                     ; B88D 38                       8
        sec                                     ; B88E 38                       8
        .byte   $5A                             ; B88F 5A                       Z
        sec                                     ; B890 38                       8
        sec                                     ; B891 38                       8
        sec                                     ; B892 38                       8
        sec                                     ; B893 38                       8
        sec                                     ; B894 38                       8
        sec                                     ; B895 38                       8
        sec                                     ; B896 38                       8
        .byte   $5B                             ; B897 5B                       [
        sec                                     ; B898 38                       8
        sec                                     ; B899 38                       8
        sec                                     ; B89A 38                       8
        .byte   $5C                             ; B89B 5C                       \
        .byte   $5C                             ; B89C 5C                       \
        .byte   $5C                             ; B89D 5C                       \
        eor     $3837,x                         ; B89E 5D 37 38                 ]78
        .byte   $37                             ; B8A1 37                       7
        .byte   $5C                             ; B8A2 5C                       \
        .byte   $5C                             ; B8A3 5C                       \
        sec                                     ; B8A4 38                       8
        .byte   $5C                             ; B8A5 5C                       \
        lsr     $385F,x                         ; B8A6 5E 5F 38                 ^_8
        sec                                     ; B8A9 38                       8
        sec                                     ; B8AA 38                       8
        sec                                     ; B8AB 38                       8
        sec                                     ; B8AC 38                       8
        sec                                     ; B8AD 38                       8
        rts                                     ; B8AE 60                       `

; ----------------------------------------------------------------------------
        adc     ($38,x)                         ; B8AF 61 38                    a8
        sec                                     ; B8B1 38                       8
        sec                                     ; B8B2 38                       8
        sec                                     ; B8B3 38                       8
        sec                                     ; B8B4 38                       8
        sec                                     ; B8B5 38                       8
        .byte   $62                             ; B8B6 62                       b
        lsr     $38                             ; B8B7 46 38                    F8
        sec                                     ; B8B9 38                       8
        sec                                     ; B8BA 38                       8
        sec                                     ; B8BB 38                       8
        sec                                     ; B8BC 38                       8
        sec                                     ; B8BD 38                       8
        .byte   $63                             ; B8BE 63                       c
        sec                                     ; B8BF 38                       8
        rol     $3D64,x                         ; B8C0 3E 64 3D                 >d=
        rol     $6665,x                         ; B8C3 3E 65 66                 >ef
        rol     $4065,x                         ; B8C6 3E 65 40                 >e@
        .byte   $64                             ; B8C9 64                       d
        .byte   $3F                             ; B8CA 3F                       ?
        rti                                     ; B8CB 40                       @

; ----------------------------------------------------------------------------
        adc     L0066                           ; B8CC 65 66                    ef
        rti                                     ; B8CE 40                       @

; ----------------------------------------------------------------------------
        adc     $3A                             ; B8CF 65 3A                    e:
        .byte   $64                             ; B8D1 64                       d
        .byte   $3B                             ; B8D2 3B                       ;
        .byte   $3A                             ; B8D3 3A                       :
        adc     L0066                           ; B8D4 65 66                    ef
        .byte   $3A                             ; B8D6 3A                       :
        adc     $37                             ; B8D7 65 37                    e7
        .byte   $64                             ; B8D9 64                       d
        .byte   $37                             ; B8DA 37                       7
        .byte   $37                             ; B8DB 37                       7
        adc     L0066                           ; B8DC 65 66                    ef
        .byte   $67                             ; B8DE 67                       g
        pla                                     ; B8DF 68                       h
        .byte   $4B                             ; B8E0 4B                       K
        .byte   $64                             ; B8E1 64                       d
        .byte   $4B                             ; B8E2 4B                       K
        .byte   $67                             ; B8E3 67                       g
        pla                                     ; B8E4 68                       h
        adc     #$6A                            ; B8E5 69 6A                    ij
        .byte   $6B                             ; B8E7 6B                       k
        adc     ($6C,x)                         ; B8E8 61 6C                    al
        adc     ($6D,x)                         ; B8EA 61 6D                    am
        .byte   $6B                             ; B8EC 6B                       k
        ror     $4B6F                           ; B8ED 6E 6F 4B                 noK
        bvs     LB962                           ; B8F0 70 70                    pp
        adc     ($72),y                         ; B8F2 71 72                    qr
        .byte   $73                             ; B8F4 73                       s
        .byte   $74                             ; B8F5 74                       t
        .byte   $6F                             ; B8F6 6F                       o
        adc     ($38,x)                         ; B8F7 61 38                    a8
        sec                                     ; B8F9 38                       8
        sec                                     ; B8FA 38                       8
        .byte   $72                             ; B8FB 72                       r
        adc     ($75,x)                         ; B8FC 61 75                    au
        .byte   $6F                             ; B8FE 6F                       o
        adc     (L0066,x)                       ; B8FF 61 66                    af
        adc     L0066                           ; B901 65 66                    ef
        .byte   $3C                             ; B903 3C                       <
        .byte   $64                             ; B904 64                       d
        .byte   $5B                             ; B905 5B                       [
        rol     $6637,x                         ; B906 3E 37 66                 >7f
        adc     L0066                           ; B909 65 66                    ef
        .byte   $37                             ; B90B 37                       7
        .byte   $64                             ; B90C 64                       d
        .byte   $37                             ; B90D 37                       7
        rti                                     ; B90E 40                       @

; ----------------------------------------------------------------------------
        .byte   $3A                             ; B90F 3A                       :
        ror     $65                             ; B910 66 65                    fe
        ror     $3A                             ; B912 66 3A                    f:
        .byte   $64                             ; B914 64                       d
        .byte   $37                             ; B915 37                       7
        .byte   $37                             ; B916 37                       7
        .byte   $37                             ; B917 37                       7
        adc     #$6A                            ; B918 69 6A                    ij
        ror     $37                             ; B91A 66 37                    f7
        .byte   $64                             ; B91C 64                       d
        .byte   $3A                             ; B91D 3A                       :
        .byte   $3A                             ; B91E 3A                       :
        .byte   $37                             ; B91F 37                       7
        ror     $666F                           ; B920 6E 6F 66                 nof
        .byte   $37                             ; B923 37                       7
        .byte   $64                             ; B924 64                       d
        .byte   $5F                             ; B925 5F                       _
        .byte   $4B                             ; B926 4B                       K
        .byte   $37                             ; B927 37                       7
        .byte   $67                             ; B928 67                       g
        ror     $69,x                           ; B929 76 69                    vi
        .byte   $77                             ; B92B 77                       w
        sei                                     ; B92C 78                       x
        jmp     L4D4C                           ; B92D 4C 4C 4D                 LLM

; ----------------------------------------------------------------------------
        adc     $6E6B                           ; B930 6D 6B 6E                 mkn
        ror     $38                             ; B933 66 38                    f8
        sec                                     ; B935 38                       8
        sec                                     ; B936 38                       8
        sec                                     ; B937 38                       8
        .byte   $72                             ; B938 72                       r
        .byte   $37                             ; B939 37                       7
        .byte   $37                             ; B93A 37                       7
        ror     $38                             ; B93B 66 38                    f8
        sec                                     ; B93D 38                       8
        sec                                     ; B93E 38                       8
        sec                                     ; B93F 38                       8
        .byte   $3C                             ; B940 3C                       <
        .byte   $37                             ; B941 37                       7
        .byte   $3A                             ; B942 3A                       :
        .byte   $64                             ; B943 64                       d
        .byte   $3C                             ; B944 3C                       <
        .byte   $37                             ; B945 37                       7
        .byte   $5B                             ; B946 5B                       [
        .byte   $64                             ; B947 64                       d
        adc     $7B7A,y                         ; B948 79 7A 7B                 yz{
        .byte   $64                             ; B94B 64                       d
        .byte   $37                             ; B94C 37                       7
        .byte   $37                             ; B94D 37                       7
        .byte   $37                             ; B94E 37                       7
        .byte   $64                             ; B94F 64                       d
        .byte   $7C                             ; B950 7C                       |
        rol     $643C,x                         ; B951 3E 3C 64                 ><d
        adc     $7F7E,x                         ; B954 7D 7E 7F                 }~.
        .byte   $64                             ; B957 64                       d
        .byte   $7C                             ; B958 7C                       |
        rti                                     ; B959 40                       @

; ----------------------------------------------------------------------------
        .byte   $37                             ; B95A 37                       7
        .byte   $64                             ; B95B 64                       d
        .byte   $5F                             ; B95C 5F                       _
        .byte   $74                             ; B95D 74                       t
        .byte   $37                             ; B95E 37                       7
        .byte   $64                             ; B95F 64                       d
        .byte   $7C                             ; B960 7C                       |
        .byte   $37                             ; B961 37                       7
LB962:  .byte   $3A                             ; B962 3A                       :
        .byte   $64                             ; B963 64                       d
        adc     ($75,x)                         ; B964 61 75                    au
        .byte   $74                             ; B966 74                       t
        .byte   $64                             ; B967 64                       d
        .byte   $80                             ; B968 80                       .
        sta     ($74,x)                         ; B969 81 74                    .t
        .byte   $82                             ; B96B 82                       .
        bvs     LB9DE                           ; B96C 70 70                    pp
        bvs     LB9E0                           ; B96E 70 70                    pp
        sec                                     ; B970 38                       8
        adc     ($83,x)                         ; B971 61 83                    a.
        eor     $38                             ; B973 45 38                    E8
        sec                                     ; B975 38                       8
        sec                                     ; B976 38                       8
        sec                                     ; B977 38                       8
        sec                                     ; B978 38                       8
        adc     ($83,x)                         ; B979 61 83                    a.
        eor     $38                             ; B97B 45 38                    E8
        sec                                     ; B97D 38                       8
        sec                                     ; B97E 38                       8
        sec                                     ; B97F 38                       8
        rol     $373C,x                         ; B980 3E 3C 37                 ><7
        .byte   $3C                             ; B983 3C                       <
        .byte   $5B                             ; B984 5B                       [
        rol     $387C,x                         ; B985 3E 7C 38                 >|8
        rti                                     ; B988 40                       @

; ----------------------------------------------------------------------------
        .byte   $37                             ; B989 37                       7
        .byte   $3A                             ; B98A 3A                       :
        .byte   $3A                             ; B98B 3A                       :
        .byte   $37                             ; B98C 37                       7
        rti                                     ; B98D 40                       @

; ----------------------------------------------------------------------------
        .byte   $7C                             ; B98E 7C                       |
        sec                                     ; B98F 38                       8
        .byte   $7A                             ; B990 7A                       z
        .byte   $7B                             ; B991 7B                       {
        .byte   $37                             ; B992 37                       7
        .byte   $37                             ; B993 37                       7
        .byte   $37                             ; B994 37                       7
        .byte   $37                             ; B995 37                       7
        .byte   $7C                             ; B996 7C                       |
        sec                                     ; B997 38                       8
        .byte   $37                             ; B998 37                       7
        .byte   $37                             ; B999 37                       7
        .byte   $5F                             ; B99A 5F                       _
        sty     $73                             ; B99B 84 73                    .s
        .byte   $74                             ; B99D 74                       t
        .byte   $7C                             ; B99E 7C                       |
        sec                                     ; B99F 38                       8
        sty     $46                             ; B9A0 84 46                    .F
        bvs     LBA14                           ; B9A2 70 70                    pp
        adc     ($75),y                         ; B9A4 71 75                    qu
        sta     $38                             ; B9A6 85 38                    .8
        bvs     LB9E2                           ; B9A8 70 38                    p8
        sec                                     ; B9AA 38                       8
        sec                                     ; B9AB 38                       8
        sec                                     ; B9AC 38                       8
        bvs     LBA1F                           ; B9AD 70 70                    pp
        sec                                     ; B9AF 38                       8
        sec                                     ; B9B0 38                       8
        sec                                     ; B9B1 38                       8
        sec                                     ; B9B2 38                       8
        sec                                     ; B9B3 38                       8
        sec                                     ; B9B4 38                       8
        sec                                     ; B9B5 38                       8
        sec                                     ; B9B6 38                       8
        sec                                     ; B9B7 38                       8
        sec                                     ; B9B8 38                       8
        sec                                     ; B9B9 38                       8
        sec                                     ; B9BA 38                       8
        sec                                     ; B9BB 38                       8
        sec                                     ; B9BC 38                       8
        sec                                     ; B9BD 38                       8
        sec                                     ; B9BE 38                       8
        sec                                     ; B9BF 38                       8
        and     $55                             ; B9C0 25 55                    %U
        lsr     a                               ; B9C2 4A                       J
        lsr     a                               ; B9C3 4A                       J
        lsr     a                               ; B9C4 4A                       J
        and     $25                             ; B9C5 25 25                    %%
        and     $25                             ; B9C7 25 25                    %%
        eor     $3C,x                           ; B9C9 55 3C                    U<
        .byte   $5B                             ; B9CB 5B                       [
        rol     $2525,x                         ; B9CC 3E 25 25                 >%%
        and     $25                             ; B9CF 25 25                    %%
        eor     $3A,x                           ; B9D1 55 3A                    U:
        .byte   $37                             ; B9D3 37                       7
        rti                                     ; B9D4 40                       @

; ----------------------------------------------------------------------------
        eor     ($25),y                         ; B9D5 51 25                    Q%
        and     $25                             ; B9D7 25 25                    %%
        rol     $3786                           ; B9D9 2E 86 37                 ..7
        .byte   $3A                             ; B9DC 3A                       :
        .byte   $3A                             ; B9DD 3A                       :
LB9DE:  and     $25                             ; B9DE 25 25                    %%
LB9E0:  and     $25                             ; B9E0 25 25                    %%
LB9E2:  rol     $3786                           ; B9E2 2E 86 37                 ..7
        .byte   $37                             ; B9E5 37                       7
        lsr     a                               ; B9E6 4A                       J
        and     $25                             ; B9E7 25 25                    %%
        and     $25                             ; B9E9 25 25                    %%
        rol     $5F86                           ; B9EB 2E 86 5F                 .._
        sty     $25                             ; B9EE 84 25                    .%
        and     $25                             ; B9F0 25 25                    %%
        and     $25                             ; B9F2 25 25                    %%
        rol     $8724                           ; B9F4 2E 24 87                 .$.
        and     $51                             ; B9F7 25 51                    %Q
        eor     ($51),y                         ; B9F9 51 51                    QQ
        eor     ($51),y                         ; B9FB 51 51                    QQ
        eor     ($56),y                         ; B9FD 51 56                    QV
        and     $88                             ; B9FF 25 88                    %.
        .byte   $89                             ; BA01 89                       .
        txa                                     ; BA02 8A                       .
        ora     L0D0D                           ; BA03 0D 0D 0D                 ...
        dey                                     ; BA06 88                       .
        .byte   $89                             ; BA07 89                       .
        ora     L0D0D                           ; BA08 0D 0D 0D                 ...
        ora     L0D0D                           ; BA0B 0D 0D 0D                 ...
        ora     L0D0D                           ; BA0E 0D 0D 0D                 ...
        ora     L0D0D                           ; BA11 0D 0D 0D                 ...
LBA14:  ora     L0D0D                           ; BA14 0D 0D 0D                 ...
        ora     $178B                           ; BA17 0D 8B 17                 ...
        asl     $12,x                           ; BA1A 16 12                    ..
        sty     $8C12                           ; BA1C 8C 12 8C                 ...
LBA1F:  .byte   $17                             ; BA1F 17                       .
        sta     $1C1D                           ; BA20 8D 1D 1C                 ...
        sta     $8D8E                           ; BA23 8D 8E 8D                 ...
        sta     $8F1D                           ; BA26 8D 1D 8F                 ...
        and     ($0D,x)                         ; BA29 21 0D                    !.
        .byte   $8F                             ; BA2B 8F                       .
        ora     $8F8F                           ; BA2C 0D 8F 8F                 ...
        and     ($70,x)                         ; BA2F 21 70                    !p
        bcc     LBA79                           ; BA31 90 46                    .F
        bvs     LBAA5                           ; BA33 70 70                    pp
        bvs     LBAA7                           ; BA35 70 70                    pp
        adc     ($38),y                         ; BA37 71 38                    q8
        .byte   $63                             ; BA39 63                       c
        sec                                     ; BA3A 38                       8
        sec                                     ; BA3B 38                       8
        sec                                     ; BA3C 38                       8
        sec                                     ; BA3D 38                       8
        sec                                     ; BA3E 38                       8
        sec                                     ; BA3F 38                       8
        txa                                     ; BA40 8A                       .
        ora     L0D0D                           ; BA41 0D 0D 0D                 ...
        ora     $8988                           ; BA44 0D 88 89                 ...
        txa                                     ; BA47 8A                       .
        ora     L0D0D                           ; BA48 0D 0D 0D                 ...
        ora     L0D0D                           ; BA4B 0D 0D 0D                 ...
        ora     L0D0D                           ; BA4E 0D 0D 0D                 ...
        ora     L0D0D                           ; BA51 0D 0D 0D                 ...
        ora     L0D0D                           ; BA54 0D 0D 0D                 ...
        ora     $9116                           ; BA57 0D 16 91                 ...
        sty     $8C91                           ; BA5A 8C 91 8C                 ...
        sta     ($8C),y                         ; BA5D 91 8C                    ..
        sta     ($1C),y                         ; BA5F 91 1C                    ..
        sta     $8D8D                           ; BA61 8D 8D 8D                 ...
        .byte   $37                             ; BA64 37                       7
        .byte   $37                             ; BA65 37                       7
        .byte   $37                             ; BA66 37                       7
        .byte   $37                             ; BA67 37                       7
        ora     $8F8F                           ; BA68 0D 8F 8F                 ...
        .byte   $92                             ; BA6B 92                       .
        .byte   $93                             ; BA6C 93                       .
        sty     $95,x                           ; BA6D 94 95                    ..
        .byte   $93                             ; BA6F 93                       .
        stx     $96,y                           ; BA70 96 96                    ..
        stx     $96,y                           ; BA72 96 96                    ..
        stx     $96,y                           ; BA74 96 96                    ..
        stx     $96,y                           ; BA76 96 96                    ..
        .byte   $97                             ; BA78 97                       .
LBA79:  .byte   $97                             ; BA79 97                       .
        .byte   $97                             ; BA7A 97                       .
        .byte   $97                             ; BA7B 97                       .
        .byte   $97                             ; BA7C 97                       .
        .byte   $97                             ; BA7D 97                       .
        .byte   $97                             ; BA7E 97                       .
        .byte   $97                             ; BA7F 97                       .
        ora     $880D                           ; BA80 0D 0D 88                 ...
        .byte   $89                             ; BA83 89                       .
        txa                                     ; BA84 8A                       .
        ora     L0D0D                           ; BA85 0D 0D 0D                 ...
        ora     L0D0D                           ; BA88 0D 0D 0D                 ...
        ora     L0D0D                           ; BA8B 0D 0D 0D                 ...
        ora     $260D                           ; BA8E 0D 0D 26                 ..&
        tya                                     ; BA91 98                       .
        sta     ($91),y                         ; BA92 91 91                    ..
        sta     $1798,y                         ; BA94 99 98 17                 ...
        sta     ($9A),y                         ; BA97 91 9A                    ..
        .byte   $37                             ; BA99 37                       7
        .byte   $37                             ; BA9A 37                       7
        .byte   $37                             ; BA9B 37                       7
        .byte   $37                             ; BA9C 37                       7
        .byte   $37                             ; BA9D 37                       7
        .byte   $9B                             ; BA9E 9B                       .
        .byte   $37                             ; BA9F 37                       7
        .byte   $37                             ; BAA0 37                       7
        .byte   $37                             ; BAA1 37                       7
        .byte   $9C                             ; BAA2 9C                       .
        .byte   $9D                             ; BAA3 9D                       .
        .byte   $9D                             ; BAA4 9D                       .
LBAA5:  .byte   $9D                             ; BAA5 9D                       .
        .byte   $9D                             ; BAA6 9D                       .
LBAA7:  .byte   $37                             ; BAA7 37                       7
        sty     $93,x                           ; BAA8 94 93                    ..
        .byte   $9E                             ; BAAA 9E                       .
        .byte   $9F                             ; BAAB 9F                       .
        .byte   $9F                             ; BAAC 9F                       .
        ldy     #$A0                            ; BAAD A0 A0                    ..
        .byte   $37                             ; BAAF 37                       7
        stx     $96,y                           ; BAB0 96 96                    ..
        stx     $96,y                           ; BAB2 96 96                    ..
        stx     $96,y                           ; BAB4 96 96                    ..
        stx     $A1,y                           ; BAB6 96 A1                    ..
        .byte   $97                             ; BAB8 97                       .
        .byte   $97                             ; BAB9 97                       .
LBABA:  .byte   $97                             ; BABA 97                       .
        .byte   $97                             ; BABB 97                       .
        .byte   $97                             ; BABC 97                       .
        .byte   $97                             ; BABD 97                       .
        ldx     #$A3                            ; BABE A2 A3                    ..
        ldy     $A4                             ; BAC0 A4 A4                    ..
        ldy     $A4                             ; BAC2 A4 A4                    ..
        lda     $A6                             ; BAC4 A5 A6                    ..
        ldx     $A3                             ; BAC6 A6 A3                    ..
        .byte   $97                             ; BAC8 97                       .
        .byte   $97                             ; BAC9 97                       .
        .byte   $97                             ; BACA 97                       .
        .byte   $A2                             ; BACB A2                       .
LBACC:  ldx     $A3                             ; BACC A6 A3                    ..
        .byte   $A3                             ; BACE A3                       .
        .byte   $A3                             ; BACF A3                       .
        ldy     $A7                             ; BAD0 A4 A7                    ..
        tay                                     ; BAD2 A8                       .
        lda     #$A3                            ; BAD3 A9 A3                    ..
        .byte   $A3                             ; BAD5 A3                       .
        .byte   $A3                             ; BAD6 A3                       .
        .byte   $A3                             ; BAD7 A3                       .
        tax                                     ; BAD8 AA                       .
        .byte   $AB                             ; BAD9 AB                       .
        .byte   $AC,$AD,$A3                     ; BADA AC AD A3                 ...
        ldx     LAEAE                           ; BADD AE AE AE                 ...
        .byte   $AF                             ; BAE0 AF                       .
        ldy     #$B0                            ; BAE1 A0 B0                    ..
        lda     ($A3),y                         ; BAE3 B1 A3                    ..
        .byte   $B2                             ; BAE5 B2                       .
        .byte   $B2                             ; BAE6 B2                       .
        .byte   $B3                             ; BAE7 B3                       .
        ldy     $A3,x                           ; BAE8 B4 A3                    ..
        stx     $96,y                           ; BAEA 96 96                    ..
        .byte   $A3                             ; BAEC A3                       .
        .byte   $A3                             ; BAED A3                       .
        .byte   $A3                             ; BAEE A3                       .
        lda     $B6,x                           ; BAEF B5 B6                    ..
        .byte   $A3                             ; BAF1 A3                       .
        lda     $97,x                           ; BAF2 B5 97                    ..
        stx     $96,y                           ; BAF4 96 96                    ..
        stx     $B7,y                           ; BAF6 96 B7                    ..
        clv                                     ; BAF8 B8                       .
        .byte   $A3                             ; BAF9 A3                       .
        lda     LBABA,y                         ; BAFA B9 BA BA                 ...
        tsx                                     ; BAFD BA                       .
        tsx                                     ; BAFE BA                       .
        tsx                                     ; BAFF BA                       .
        .byte   $BB                             ; BB00 BB                       .
        ldy     LA4BD,x                         ; BB01 BC BD A4                 ...
        ldy     $A4                             ; BB04 A4 A4                    ..
        ldy     $A4                             ; BB06 A4 A4                    ..
        ldx     LBF37,y                         ; BB08 BE 37 BF                 .7.
        .byte   $97                             ; BB0B 97                       .
        .byte   $97                             ; BB0C 97                       .
        .byte   $97                             ; BB0D 97                       .
        .byte   $97                             ; BB0E 97                       .
        .byte   $97                             ; BB0F 97                       .
        ldy     $37,x                           ; BB10 B4 37                    .7
        cpy     #$A4                            ; BB12 C0 A4                    ..
        ldy     $A4                             ; BB14 A4 A4                    ..
        ldy     $A4                             ; BB16 A4 A4                    ..
        cmp     ($A1,x)                         ; BB18 C1 A1                    ..
        .byte   $C2                             ; BB1A C2                       .
        .byte   $97                             ; BB1B 97                       .
        .byte   $97                             ; BB1C 97                       .
        .byte   $97                             ; BB1D 97                       .
        .byte   $97                             ; BB1E 97                       .
        .byte   $97                             ; BB1F 97                       .
        .byte   $BB                             ; BB20 BB                       .
        .byte   $A3                             ; BB21 A3                       .
        .byte   $B7                             ; BB22 B7                       .
        tay                                     ; BB23 A8                       .
        tay                                     ; BB24 A8                       .
        tay                                     ; BB25 A8                       .
        tay                                     ; BB26 A8                       .
        tay                                     ; BB27 A8                       .
LBB28:  .byte   $BE,$A3,$A0                     ; BB28 BE A3 A0                 ...
        ldy     LAD37                           ; BB2B AC 37 AD                 .7.
        ldy     #$A0                            ; BB2E A0 A0                    ..
        stx     $96,y                           ; BB30 96 96                    ..
        stx     $96,y                           ; BB32 96 96                    ..
        stx     $96,y                           ; BB34 96 96                    ..
        stx     $96,y                           ; BB36 96 96                    ..
        .byte   $97                             ; BB38 97                       .
        .byte   $97                             ; BB39 97                       .
        .byte   $97                             ; BB3A 97                       .
        .byte   $97                             ; BB3B 97                       .
        .byte   $97                             ; BB3C 97                       .
        .byte   $97                             ; BB3D 97                       .
        .byte   $97                             ; BB3E 97                       .
        .byte   $97                             ; BB3F 97                       .
        ldy     $A4                             ; BB40 A4 A4                    ..
        ldy     $A4                             ; BB42 A4 A4                    ..
        ldy     $A4                             ; BB44 A4 A4                    ..
        ldy     $A4                             ; BB46 A4 A4                    ..
        .byte   $97                             ; BB48 97                       .
        .byte   $97                             ; BB49 97                       .
        .byte   $97                             ; BB4A 97                       .
        tax                                     ; BB4B AA                       .
        .byte   $C3                             ; BB4C C3                       .
        cpy     $C5                             ; BB4D C4 C5                    ..
        cmp     $A4                             ; BB4F C5 A4                    ..
        dec     $C5                             ; BB51 C6 C5                    ..
        ldx     $A0                             ; BB53 A6 A0                    ..
        ldy     #$BC                            ; BB55 A0 BC                    ..
        ldy     $C797,x                         ; BB57 BC 97 C7                 ...
        .byte   $A3                             ; BB5A A3                       .
        .byte   $A3                             ; BB5B A3                       .
        .byte   $A3                             ; BB5C A3                       .
        .byte   $A3                             ; BB5D A3                       .
        bcs     LBB28                           ; BB5E B0 C8                    ..
        tay                                     ; BB60 A8                       .
        lda     #$BC                            ; BB61 A9 BC                    ..
        ldy     LBCBC,x                         ; BB63 BC BC BC                 ...
        bcs     LBB9F                           ; BB66 B0 37                    .7
        ldy     #$A0                            ; BB68 A0 A0                    ..
        .byte   $A3                             ; BB6A A3                       .
        cmp     #$AE                            ; BB6B C9 AE                    ..
        ldx     $CAB0                           ; BB6D AE B0 CA                 ...
        stx     $96,y                           ; BB70 96 96                    ..
        stx     $96,y                           ; BB72 96 96                    ..
        .byte   $B3                             ; BB74 B3                       .
        .byte   $B3                             ; BB75 B3                       .
        ldx     $97AE                           ; BB76 AE AE 97                 ...
        .byte   $97                             ; BB79 97                       .
        .byte   $97                             ; BB7A 97                       .
        .byte   $97                             ; BB7B 97                       .
        .byte   $97                             ; BB7C 97                       .
        .byte   $97                             ; BB7D 97                       .
        tsx                                     ; BB7E BA                       .
        tsx                                     ; BB7F BA                       .
        ldy     $A4                             ; BB80 A4 A4                    ..
        ldy     $A4                             ; BB82 A4 A4                    ..
        ldy     $A4                             ; BB84 A4 A4                    ..
        ldy     $A4                             ; BB86 A4 A4                    ..
        cmp     $C5                             ; BB88 C5 C5                    ..
        cmp     $C5                             ; BB8A C5 C5                    ..
        cmp     $C5                             ; BB8C C5 C5                    ..
        cmp     $CB                             ; BB8E C5 CB                    ..
        ldy     LBCBC,x                         ; BB90 BC BC BC                 ...
        ldy     LBCBC,x                         ; BB93 BC BC BC                 ...
        .byte   $A3                             ; BB96 A3                       .
        cpy     $C8C8                           ; BB97 CC C8 C8                 ...
        iny                                     ; BB9A C8                       .
        iny                                     ; BB9B C8                       .
        iny                                     ; BB9C C8                       .
        lda     ($BC),y                         ; BB9D B1 BC                    ..
LBB9F:  cmp     $3737                           ; BB9F CD 37 37                 .77
        .byte   $37                             ; BBA2 37                       7
        .byte   $37                             ; BBA3 37                       7
        .byte   $37                             ; BBA4 37                       7
        lda     ($A3),y                         ; BBA5 B1 A3                    ..
        dec     $CACF                           ; BBA7 CE CF CA                 ...
        .byte   $CF                             ; BBAA CF                       .
        dex                                     ; BBAB CA                       .
        .byte   $CF                             ; BBAC CF                       .
        lda     ($A3),y                         ; BBAD B1 A3                    ..
        dec     LAEAE                           ; BBAF CE AE AE                 ...
        stx     $94,y                           ; BBB2 96 94                    ..
        .byte   $93                             ; BBB4 93                       .
        stx     $D0,y                           ; BBB5 96 D0                    ..
        cmp     ($BA),y                         ; BBB7 D1 BA                    ..
        tsx                                     ; BBB9 BA                       .
        tsx                                     ; BBBA BA                       .
        tsx                                     ; BBBB BA                       .
        tsx                                     ; BBBC BA                       .
        tsx                                     ; BBBD BA                       .
        .byte   $D2                             ; BBBE D2                       .
        .byte   $CC,$A4,$A4                     ; BBBF CC A4 A4                 ...
        ldy     $D3                             ; BBC2 A4 D3                    ..
        tay                                     ; BBC4 A8                       .
        tay                                     ; BBC5 A8                       .
        .byte   $D4                             ; BBC6 D4                       .
        cmp     $97,x                           ; BBC7 D5 97                    ..
        tax                                     ; BBC9 AA                       .
        .byte   $C3                             ; BBCA C3                       .
        dec     $A0,x                           ; BBCB D6 A0                    ..
        ldy     #$D7                            ; BBCD A0 D7                    ..
        dec     $C1A4                           ; BBCF CE A4 C1                 ...
        cld                                     ; BBD2 D8                       .
        cmp     $96D1,y                         ; BBD3 D9 D1 96                 ...
LBBD6:  stx     $96,y                           ; BBD6 96 96                    ..
        .byte   $97                             ; BBD8 97                       .
        .byte   $BB                             ; BBD9 BB                       .
        .byte   $A3                             ; BBDA A3                       .
        .byte   $A3                             ; BBDB A3                       .
        cmp     $97,x                           ; BBDC D5 97                    ..
        .byte   $97                             ; BBDE 97                       .
        .byte   $97                             ; BBDF 97                       .
        .byte   $D3                             ; BBE0 D3                       .
        lda     #$BC                            ; BBE1 A9 BC                    ..
        stx     $96,y                           ; BBE3 96 96                    ..
        ldy     $A4                             ; BBE5 A4 A4                    ..
LBBE7:  ldy     $DA                             ; BBE7 A4 DA                    ..
        ldy     #$A3                            ; BBE9 A0 A3                    ..
        .byte   $DB                             ; BBEB DB                       .
        .byte   $97                             ; BBEC 97                       .
        .byte   $97                             ; BBED 97                       .
        .byte   $97                             ; BBEE 97                       .
        .byte   $97                             ; BBEF 97                       .
        .byte   $DC                             ; BBF0 DC                       .
        cmp     ($93),y                         ; BBF1 D1 93                    ..
        .byte   $DD,$A4,$A4                     ; BBF3 DD A4 A4                 ...
        ldy     $A4                             ; BBF6 A4 A4                    ..
        .byte   $DE                             ; BBF8 DE                       .
LBBF9:  cpy     LBABA                           ; BBF9 CC BA BA                 ...
        tsx                                     ; BBFC BA                       .
        tsx                                     ; BBFD BA                       .
        tsx                                     ; BBFE BA                       .
        tsx                                     ; BBFF BA                       .
        dec     LAACC,x                         ; BC00 DE CC AA                 ...
        .byte   $C3                             ; BC03 C3                       .
        .byte   $C3                             ; BC04 C3                       .
        .byte   $C3                             ; BC05 C3                       .
        .byte   $C3                             ; BC06 C3                       .
        .byte   $C3                             ; BC07 C3                       .
        .byte   $DF                             ; BC08 DF                       .
        cpx     #$A6                            ; BC09 E0 A6                    ..
        ldy     #$A0                            ; BC0B A0 A0                    ..
        ldy     #$A0                            ; BC0D A0 A0                    ..
        ldy     #$D2                            ; BC0F A0 D2                    ..
        ldy     LBCBC,x                         ; BC11 BC BC BC                 ...
        ldy     LBCBC,x                         ; BC14 BC BC BC                 ...
        ldy     $E1DC,x                         ; BC17 BC DC E1                 ...
        .byte   $A3                             ; BC1A A3                       .
        .byte   $A3                             ; BC1B A3                       .
        .byte   $A3                             ; BC1C A3                       .
        bcs     LBBE7                           ; BC1D B0 C8                    ..
        iny                                     ; BC1F C8                       .
        dec     LBCE1,x                         ; BC20 DE E1 BC                 ...
        ldy     LB0BC,x                         ; BC23 BC BC B0                 ...
        .byte   $37                             ; BC26 37                       7
        .byte   $37                             ; BC27 37                       7
        dec     $E1E1,x                         ; BC28 DE E1 E1                 ...
        .byte   $A3                             ; BC2B A3                       .
        .byte   $A3                             ; BC2C A3                       .
        bcs     LBBF9                           ; BC2D B0 CA                    ..
LBC2F:  .byte   $CF                             ; BC2F CF                       .
        stx     $96,y                           ; BC30 96 96                    ..
        sbc     ($96,x)                         ; BC32 E1 96                    ..
        stx     $B0,y                           ; BC34 96 B0                    ..
        stx     $96,y                           ; BC36 96 96                    ..
        .byte   $97                             ; BC38 97                       .
        .byte   $97                             ; BC39 97                       .
        sbc     ($97,x)                         ; BC3A E1 97                    ..
        .byte   $97                             ; BC3C 97                       .
        bcs     LBBD6                           ; BC3D B0 97                    ..
        .byte   $97                             ; BC3F 97                       .
        .byte   $C3                             ; BC40 C3                       .
        .byte   $C3                             ; BC41 C3                       .
        .byte   $C3                             ; BC42 C3                       .
        .byte   $C3                             ; BC43 C3                       .
        .byte   $C3                             ; BC44 C3                       .
        .byte   $C3                             ; BC45 C3                       .
        .byte   $E2                             ; BC46 E2                       .
        .byte   $97                             ; BC47 97                       .
        ldy     #$A0                            ; BC48 A0 A0                    ..
        ldy     #$A0                            ; BC4A A0 A0                    ..
        ldy     #$A0                            ; BC4C A0 A0                    ..
        .byte   $E3                             ; BC4E E3                       .
        cpx     $BC                             ; BC4F E4 BC                    ..
LBC51:  ldy     LBCBC,x                         ; BC51 BC BC BC                 ...
        ldy     $E5BC,x                         ; BC54 BC BC E5                 ...
        inc     $C8                             ; BC57 E6 C8                    ..
        lda     ($A3),y                         ; BC59 B1 A3                    ..
        .byte   $E7                             ; BC5B E7                       .
        tsx                                     ; BC5C BA                       .
        inx                                     ; BC5D E8                       .
        .byte   $A3                             ; BC5E A3                       .
        ldy     LB137                           ; BC5F AC 37 B1                 .7.
        sbc     #$EA                            ; BC62 E9 EA                    ..
        ldy     $EB                             ; BC64 A4 EB                    ..
        cpx     $CAB0                           ; BC66 EC B0 CA                 ...
        .byte   $E7                             ; BC69 E7                       .
        sbc     $9797                           ; BC6A ED 97 97                 ...
        .byte   $97                             ; BC6D 97                       .
        inc     $96E8                           ; BC6E EE E8 96                 ...
        nop                                     ; BC71 EA                       .
        ldy     $A4                             ; BC72 A4 A4                    ..
        ldy     $A4                             ; BC74 A4 A4                    ..
        ldy     $B6                             ; BC76 A4 B6                    ..
        .byte   $97                             ; BC78 97                       .
        .byte   $97                             ; BC79 97                       .
        .byte   $97                             ; BC7A 97                       .
        .byte   $97                             ; BC7B 97                       .
        .byte   $97                             ; BC7C 97                       .
        .byte   $97                             ; BC7D 97                       .
        .byte   $97                             ; BC7E 97                       .
        .byte   $EF                             ; BC7F EF                       .
        .byte   $97                             ; BC80 97                       .
        .byte   $97                             ; BC81 97                       .
        .byte   $97                             ; BC82 97                       .
        .byte   $97                             ; BC83 97                       .
        .byte   $97                             ; BC84 97                       .
        .byte   $97                             ; BC85 97                       .
        .byte   $97                             ; BC86 97                       .
        .byte   $97                             ; BC87 97                       .
        ldy     $A4                             ; BC88 A4 A4                    ..
        ldy     $A4                             ; BC8A A4 A4                    ..
        ldy     $A4                             ; BC8C A4 A4                    ..
        ldy     $A4                             ; BC8E A4 A4                    ..
        .byte   $C3                             ; BC90 C3                       .
        .byte   $C3                             ; BC91 C3                       .
        .byte   $C3                             ; BC92 C3                       .
        .byte   $C3                             ; BC93 C3                       .
        .byte   $C3                             ; BC94 C3                       .
        .byte   $C3                             ; BC95 C3                       .
        beq     LBC2F                           ; BC96 F0 97                    ..
        iny                                     ; BC98 C8                       .
        .byte   $AD,$A0,$A0                     ; BC99 AD A0 A0                 ...
        ldy     #$A0                            ; BC9C A0 A0                    ..
        cmp     $37A4,x                         ; BC9E DD A4 37                 ..7
        lda     ($A3),y                         ; BCA1 B1 A3                    ..
        .byte   $A3                             ; BCA3 A3                       .
        .byte   $A3                             ; BCA4 A3                       .
        .byte   $A3                             ; BCA5 A3                       .
        sbc     ($F2),y                         ; BCA6 F1 F2                    ..
        .byte   $37                             ; BCA8 37                       7
        lda     ($F3),y                         ; BCA9 B1 F3                    ..
        .byte   $A3                             ; BCAB A3                       .
        bne     LBC51                           ; BCAC D0 A3                    ..
        .byte   $A3                             ; BCAE A3                       .
        .byte   $F4                             ; BCAF F4                       .
        .byte   $37                             ; BCB0 37                       7
        sbc     $CE,x                           ; BCB1 F5 CE                    ..
        .byte   $A3                             ; BCB3 A3                       .
        .byte   $D2                             ; BCB4 D2                       .
LBCB5:  .byte   $F3                             ; BCB5 F3                       .
        stx     $96,y                           ; BCB6 96 96                    ..
        .byte   $37                             ; BCB8 37                       7
        inc     $CE,x                           ; BCB9 F6 CE                    ..
        .byte   $A3                             ; BCBB A3                       .
LBCBC:  .byte   $D2                             ; BCBC D2                       .
        dec     $9797                           ; BCBD CE 97 97                 ...
        .byte   $97                             ; BCC0 97                       .
        .byte   $97                             ; BCC1 97                       .
        .byte   $97                             ; BCC2 97                       .
        .byte   $97                             ; BCC3 97                       .
        .byte   $97                             ; BCC4 97                       .
        .byte   $97                             ; BCC5 97                       .
        .byte   $97                             ; BCC6 97                       .
        .byte   $97                             ; BCC7 97                       .
        ldy     $A4                             ; BCC8 A4 A4                    ..
        ldy     $A4                             ; BCCA A4 A4                    ..
        ldy     $A4                             ; BCCC A4 A4                    ..
LBCCE:  ldy     $A4                             ; BCCE A4 A4                    ..
        .byte   $97                             ; BCD0 97                       .
        .byte   $97                             ; BCD1 97                       .
        .byte   $97                             ; BCD2 97                       .
        .byte   $97                             ; BCD3 97                       .
        .byte   $97                             ; BCD4 97                       .
        .byte   $97                             ; BCD5 97                       .
LBCD6:  .byte   $97                             ; BCD6 97                       .
        .byte   $97                             ; BCD7 97                       .
        ldy     $A4                             ; BCD8 A4 A4                    ..
        ldy     $A4                             ; BCDA A4 A4                    ..
        ldy     $A4                             ; BCDC A4 A4                    ..
        ldy     $A4                             ; BCDE A4 A4                    ..
        .byte   $C5                             ; BCE0 C5                       .
LBCE1:  .byte   $F7                             ; BCE1 F7                       .
        sed                                     ; BCE2 F8                       .
        sed                                     ; BCE3 F8                       .
        sbc     $C5C5,y                         ; BCE4 F9 C5 C5                 ...
        .byte   $F2                             ; BCE7 F2                       .
        .byte   $A3                             ; BCE8 A3                       .
        bcs     LBCB5                           ; BCE9 B0 CA                    ..
        .byte   $CF                             ; BCEB CF                       .
        lda     ($A3),y                         ; BCEC B1 A3                    ..
        .byte   $A3                             ; BCEE A3                       .
        .byte   $F4                             ; BCEF F4                       .
        stx     $96,y                           ; BCF0 96 96                    ..
        stx     $96,y                           ; BCF2 96 96                    ..
        .byte   $96                             ; BCF4 96                       .
LBCF5:  stx     $96,y                           ; BCF5 96 96                    ..
        stx     $97,y                           ; BCF7 96 97                    ..
        .byte   $97                             ; BCF9 97                       .
        .byte   $97                             ; BCFA 97                       .
        .byte   $97                             ; BCFB 97                       .
        .byte   $97                             ; BCFC 97                       .
        .byte   $97                             ; BCFD 97                       .
        .byte   $97                             ; BCFE 97                       .
        .byte   $97                             ; BCFF 97                       .
        .byte   $FA                             ; BD00 FA                       .
        .byte   $C3                             ; BD01 C3                       .
        .byte   $C3                             ; BD02 C3                       .
        .byte   $C3                             ; BD03 C3                       .
        .byte   $C3                             ; BD04 C3                       .
        .byte   $C3                             ; BD05 C3                       .
        .byte   $C3                             ; BD06 C3                       .
        .byte   $FB                             ; BD07 FB                       .
        .byte   $DA                             ; BD08 DA                       .
        ldy     #$A0                            ; BD09 A0 A0                    ..
        ldy     #$A0                            ; BD0B A0 A0                    ..
        ldy     #$A0                            ; BD0D A0 A0                    ..
        .byte   $FC                             ; BD0F FC                       .
        .byte   $DC                             ; BD10 DC                       .
        ldy     LBCBC,x                         ; BD11 BC BC BC                 ...
        ldy     LBCBC,x                         ; BD14 BC BC BC                 ...
        cmp     $DE,x                           ; BD17 D5 DE                    ..
        bcs     LBD52                           ; BD19 B0 37                    .7
        bcs     LBCCE                           ; BD1B B0 B1                    ..
        .byte   $37                             ; BD1D 37                       7
        lda     ($CE),y                         ; BD1E B1 CE                    ..
        sbc     $37B0,x                         ; BD20 FD B0 37                 ..7
        bcs     LBCD6                           ; BD23 B0 B1                    ..
        .byte   $37                             ; BD25 37                       7
        lda     ($CE),y                         ; BD26 B1 CE                    ..
        .byte   $A3                             ; BD28 A3                       .
        bcs     LBCF5                           ; BD29 B0 CA                    ..
        .byte   $CF                             ; BD2B CF                       .
        dex                                     ; BD2C CA                       .
        .byte   $CF                             ; BD2D CF                       .
        lda     ($CE),y                         ; BD2E B1 CE                    ..
        stx     $96,y                           ; BD30 96 96                    ..
        stx     $96,y                           ; BD32 96 96                    ..
        stx     $96,y                           ; BD34 96 96                    ..
        stx     $96,y                           ; BD36 96 96                    ..
        .byte   $97                             ; BD38 97                       .
        .byte   $97                             ; BD39 97                       .
        .byte   $97                             ; BD3A 97                       .
        .byte   $97                             ; BD3B 97                       .
        .byte   $97                             ; BD3C 97                       .
        .byte   $97                             ; BD3D 97                       .
        .byte   $97                             ; BD3E 97                       .
        .byte   $97                             ; BD3F 97                       .
        .byte   $37                             ; BD40 37                       7
        .byte   $37                             ; BD41 37                       7
        .byte   $37                             ; BD42 37                       7
        .byte   $37                             ; BD43 37                       7
        .byte   $37                             ; BD44 37                       7
        .byte   $37                             ; BD45 37                       7
        .byte   $37                             ; BD46 37                       7
        .byte   $37                             ; BD47 37                       7
        .byte   $37                             ; BD48 37                       7
        .byte   $37                             ; BD49 37                       7
        .byte   $37                             ; BD4A 37                       7
        .byte   $37                             ; BD4B 37                       7
        .byte   $37                             ; BD4C 37                       7
        .byte   $37                             ; BD4D 37                       7
        .byte   $37                             ; BD4E 37                       7
        .byte   $37                             ; BD4F 37                       7
        .byte   $37                             ; BD50 37                       7
        .byte   $37                             ; BD51 37                       7
LBD52:  .byte   $37                             ; BD52 37                       7
        .byte   $37                             ; BD53 37                       7
        .byte   $37                             ; BD54 37                       7
        .byte   $37                             ; BD55 37                       7
        .byte   $37                             ; BD56 37                       7
        .byte   $37                             ; BD57 37                       7
        .byte   $37                             ; BD58 37                       7
        .byte   $37                             ; BD59 37                       7
        .byte   $37                             ; BD5A 37                       7
        .byte   $37                             ; BD5B 37                       7
        .byte   $37                             ; BD5C 37                       7
        .byte   $37                             ; BD5D 37                       7
        .byte   $37                             ; BD5E 37                       7
        .byte   $37                             ; BD5F 37                       7
        .byte   $37                             ; BD60 37                       7
        .byte   $37                             ; BD61 37                       7
        .byte   $37                             ; BD62 37                       7
        .byte   $37                             ; BD63 37                       7
        .byte   $37                             ; BD64 37                       7
        .byte   $37                             ; BD65 37                       7
        .byte   $37                             ; BD66 37                       7
        .byte   $37                             ; BD67 37                       7
        .byte   $37                             ; BD68 37                       7
        .byte   $37                             ; BD69 37                       7
        .byte   $37                             ; BD6A 37                       7
        .byte   $37                             ; BD6B 37                       7
        .byte   $37                             ; BD6C 37                       7
        .byte   $37                             ; BD6D 37                       7
        .byte   $37                             ; BD6E 37                       7
        .byte   $37                             ; BD6F 37                       7
        .byte   $37                             ; BD70 37                       7
        .byte   $37                             ; BD71 37                       7
        .byte   $37                             ; BD72 37                       7
        .byte   $37                             ; BD73 37                       7
        .byte   $37                             ; BD74 37                       7
        .byte   $37                             ; BD75 37                       7
        .byte   $37                             ; BD76 37                       7
        .byte   $37                             ; BD77 37                       7
        .byte   $37                             ; BD78 37                       7
        .byte   $37                             ; BD79 37                       7
        .byte   $37                             ; BD7A 37                       7
        .byte   $37                             ; BD7B 37                       7
        .byte   $37                             ; BD7C 37                       7
        .byte   $37                             ; BD7D 37                       7
LBD7E:  .byte   $37                             ; BD7E 37                       7
        .byte   $37                             ; BD7F 37                       7
        .byte   $37                             ; BD80 37                       7
        .byte   $37                             ; BD81 37                       7
        .byte   $37                             ; BD82 37                       7
        .byte   $37                             ; BD83 37                       7
        .byte   $37                             ; BD84 37                       7
        .byte   $37                             ; BD85 37                       7
        .byte   $37                             ; BD86 37                       7
        .byte   $37                             ; BD87 37                       7
        .byte   $37                             ; BD88 37                       7
        .byte   $37                             ; BD89 37                       7
        .byte   $37                             ; BD8A 37                       7
        .byte   $37                             ; BD8B 37                       7
        .byte   $37                             ; BD8C 37                       7
        .byte   $37                             ; BD8D 37                       7
        .byte   $37                             ; BD8E 37                       7
        .byte   $37                             ; BD8F 37                       7
        .byte   $37                             ; BD90 37                       7
        .byte   $37                             ; BD91 37                       7
        .byte   $37                             ; BD92 37                       7
        .byte   $37                             ; BD93 37                       7
        .byte   $37                             ; BD94 37                       7
        .byte   $37                             ; BD95 37                       7
        .byte   $37                             ; BD96 37                       7
        .byte   $37                             ; BD97 37                       7
        .byte   $37                             ; BD98 37                       7
        .byte   $37                             ; BD99 37                       7
        .byte   $37                             ; BD9A 37                       7
        .byte   $37                             ; BD9B 37                       7
        .byte   $37                             ; BD9C 37                       7
        .byte   $37                             ; BD9D 37                       7
        .byte   $37                             ; BD9E 37                       7
        .byte   $37                             ; BD9F 37                       7
        .byte   $37                             ; BDA0 37                       7
        .byte   $37                             ; BDA1 37                       7
        .byte   $37                             ; BDA2 37                       7
        .byte   $37                             ; BDA3 37                       7
        .byte   $37                             ; BDA4 37                       7
        .byte   $37                             ; BDA5 37                       7
        .byte   $37                             ; BDA6 37                       7
        .byte   $37                             ; BDA7 37                       7
        .byte   $37                             ; BDA8 37                       7
        .byte   $37                             ; BDA9 37                       7
        .byte   $37                             ; BDAA 37                       7
        .byte   $37                             ; BDAB 37                       7
        .byte   $37                             ; BDAC 37                       7
        .byte   $37                             ; BDAD 37                       7
        .byte   $37                             ; BDAE 37                       7
        .byte   $37                             ; BDAF 37                       7
        .byte   $37                             ; BDB0 37                       7
        .byte   $37                             ; BDB1 37                       7
        .byte   $37                             ; BDB2 37                       7
        .byte   $37                             ; BDB3 37                       7
        .byte   $37                             ; BDB4 37                       7
        .byte   $37                             ; BDB5 37                       7
        .byte   $37                             ; BDB6 37                       7
        .byte   $37                             ; BDB7 37                       7
        .byte   $37                             ; BDB8 37                       7
        .byte   $37                             ; BDB9 37                       7
        .byte   $37                             ; BDBA 37                       7
        .byte   $37                             ; BDBB 37                       7
        .byte   $37                             ; BDBC 37                       7
        .byte   $37                             ; BDBD 37                       7
        .byte   $37                             ; BDBE 37                       7
        .byte   $37                             ; BDBF 37                       7
        .byte   $37                             ; BDC0 37                       7
        .byte   $37                             ; BDC1 37                       7
        .byte   $37                             ; BDC2 37                       7
        .byte   $37                             ; BDC3 37                       7
        .byte   $37                             ; BDC4 37                       7
        .byte   $37                             ; BDC5 37                       7
        .byte   $37                             ; BDC6 37                       7
        .byte   $37                             ; BDC7 37                       7
        .byte   $37                             ; BDC8 37                       7
        .byte   $37                             ; BDC9 37                       7
        .byte   $37                             ; BDCA 37                       7
        .byte   $37                             ; BDCB 37                       7
        .byte   $37                             ; BDCC 37                       7
        .byte   $37                             ; BDCD 37                       7
        .byte   $37                             ; BDCE 37                       7
        .byte   $37                             ; BDCF 37                       7
        .byte   $37                             ; BDD0 37                       7
        .byte   $37                             ; BDD1 37                       7
        .byte   $37                             ; BDD2 37                       7
        .byte   $37                             ; BDD3 37                       7
        .byte   $37                             ; BDD4 37                       7
        .byte   $37                             ; BDD5 37                       7
        .byte   $37                             ; BDD6 37                       7
        .byte   $37                             ; BDD7 37                       7
        .byte   $37                             ; BDD8 37                       7
        .byte   $37                             ; BDD9 37                       7
        .byte   $37                             ; BDDA 37                       7
        .byte   $37                             ; BDDB 37                       7
        .byte   $37                             ; BDDC 37                       7
        .byte   $37                             ; BDDD 37                       7
        .byte   $37                             ; BDDE 37                       7
        .byte   $37                             ; BDDF 37                       7
        .byte   $37                             ; BDE0 37                       7
        .byte   $37                             ; BDE1 37                       7
        .byte   $37                             ; BDE2 37                       7
        .byte   $37                             ; BDE3 37                       7
        .byte   $37                             ; BDE4 37                       7
        .byte   $37                             ; BDE5 37                       7
        .byte   $37                             ; BDE6 37                       7
        .byte   $37                             ; BDE7 37                       7
        .byte   $37                             ; BDE8 37                       7
        .byte   $37                             ; BDE9 37                       7
        .byte   $37                             ; BDEA 37                       7
        .byte   $37                             ; BDEB 37                       7
        .byte   $37                             ; BDEC 37                       7
        .byte   $37                             ; BDED 37                       7
        .byte   $37                             ; BDEE 37                       7
        .byte   $37                             ; BDEF 37                       7
        .byte   $37                             ; BDF0 37                       7
        .byte   $37                             ; BDF1 37                       7
        .byte   $37                             ; BDF2 37                       7
        .byte   $37                             ; BDF3 37                       7
        .byte   $37                             ; BDF4 37                       7
        .byte   $37                             ; BDF5 37                       7
        .byte   $37                             ; BDF6 37                       7
        .byte   $37                             ; BDF7 37                       7
        .byte   $37                             ; BDF8 37                       7
        .byte   $37                             ; BDF9 37                       7
        .byte   $37                             ; BDFA 37                       7
        .byte   $37                             ; BDFB 37                       7
        .byte   $37                             ; BDFC 37                       7
        .byte   $37                             ; BDFD 37                       7
        .byte   $37                             ; BDFE 37                       7
        .byte   $37                             ; BDFF 37                       7
        .byte   $37                             ; BE00 37                       7
        .byte   $37                             ; BE01 37                       7
        .byte   $37                             ; BE02 37                       7
        .byte   $37                             ; BE03 37                       7
        .byte   $37                             ; BE04 37                       7
        .byte   $37                             ; BE05 37                       7
        .byte   $37                             ; BE06 37                       7
        .byte   $37                             ; BE07 37                       7
        .byte   $37                             ; BE08 37                       7
        .byte   $37                             ; BE09 37                       7
        .byte   $37                             ; BE0A 37                       7
        .byte   $37                             ; BE0B 37                       7
        .byte   $37                             ; BE0C 37                       7
        .byte   $37                             ; BE0D 37                       7
        .byte   $37                             ; BE0E 37                       7
        .byte   $37                             ; BE0F 37                       7
        .byte   $37                             ; BE10 37                       7
        .byte   $37                             ; BE11 37                       7
        .byte   $37                             ; BE12 37                       7
        .byte   $37                             ; BE13 37                       7
        .byte   $37                             ; BE14 37                       7
        .byte   $37                             ; BE15 37                       7
        .byte   $37                             ; BE16 37                       7
        .byte   $37                             ; BE17 37                       7
        .byte   $37                             ; BE18 37                       7
        .byte   $37                             ; BE19 37                       7
        .byte   $37                             ; BE1A 37                       7
        .byte   $37                             ; BE1B 37                       7
        .byte   $37                             ; BE1C 37                       7
        .byte   $37                             ; BE1D 37                       7
        .byte   $37                             ; BE1E 37                       7
        .byte   $37                             ; BE1F 37                       7
        .byte   $37                             ; BE20 37                       7
        .byte   $37                             ; BE21 37                       7
        .byte   $37                             ; BE22 37                       7
        .byte   $37                             ; BE23 37                       7
        .byte   $37                             ; BE24 37                       7
        .byte   $37                             ; BE25 37                       7
        .byte   $37                             ; BE26 37                       7
        .byte   $37                             ; BE27 37                       7
        .byte   $37                             ; BE28 37                       7
        .byte   $37                             ; BE29 37                       7
        .byte   $37                             ; BE2A 37                       7
        .byte   $37                             ; BE2B 37                       7
        .byte   $37                             ; BE2C 37                       7
        .byte   $37                             ; BE2D 37                       7
        .byte   $37                             ; BE2E 37                       7
        .byte   $37                             ; BE2F 37                       7
        .byte   $37                             ; BE30 37                       7
        .byte   $37                             ; BE31 37                       7
        .byte   $37                             ; BE32 37                       7
        .byte   $37                             ; BE33 37                       7
        .byte   $37                             ; BE34 37                       7
        .byte   $37                             ; BE35 37                       7
        .byte   $37                             ; BE36 37                       7
        .byte   $37                             ; BE37 37                       7
        .byte   $37                             ; BE38 37                       7
        .byte   $37                             ; BE39 37                       7
        .byte   $37                             ; BE3A 37                       7
        .byte   $37                             ; BE3B 37                       7
        .byte   $37                             ; BE3C 37                       7
        .byte   $37                             ; BE3D 37                       7
        .byte   $37                             ; BE3E 37                       7
        .byte   $37                             ; BE3F 37                       7
        .byte   $37                             ; BE40 37                       7
        .byte   $37                             ; BE41 37                       7
        .byte   $37                             ; BE42 37                       7
        .byte   $37                             ; BE43 37                       7
        .byte   $37                             ; BE44 37                       7
        .byte   $37                             ; BE45 37                       7
        .byte   $37                             ; BE46 37                       7
        .byte   $37                             ; BE47 37                       7
        .byte   $37                             ; BE48 37                       7
        .byte   $37                             ; BE49 37                       7
        .byte   $37                             ; BE4A 37                       7
        .byte   $37                             ; BE4B 37                       7
        .byte   $37                             ; BE4C 37                       7
        .byte   $37                             ; BE4D 37                       7
        .byte   $37                             ; BE4E 37                       7
LBE4F:  .byte   $37                             ; BE4F 37                       7
        .byte   $37                             ; BE50 37                       7
        .byte   $37                             ; BE51 37                       7
        .byte   $37                             ; BE52 37                       7
        .byte   $37                             ; BE53 37                       7
        .byte   $37                             ; BE54 37                       7
        .byte   $37                             ; BE55 37                       7
        .byte   $37                             ; BE56 37                       7
        .byte   $37                             ; BE57 37                       7
        .byte   $37                             ; BE58 37                       7
        .byte   $37                             ; BE59 37                       7
        .byte   $37                             ; BE5A 37                       7
        .byte   $37                             ; BE5B 37                       7
        .byte   $37                             ; BE5C 37                       7
        .byte   $37                             ; BE5D 37                       7
        .byte   $37                             ; BE5E 37                       7
        .byte   $37                             ; BE5F 37                       7
        .byte   $37                             ; BE60 37                       7
        .byte   $37                             ; BE61 37                       7
        .byte   $37                             ; BE62 37                       7
        .byte   $37                             ; BE63 37                       7
        .byte   $37                             ; BE64 37                       7
        .byte   $37                             ; BE65 37                       7
        .byte   $37                             ; BE66 37                       7
        .byte   $37                             ; BE67 37                       7
        .byte   $37                             ; BE68 37                       7
        .byte   $37                             ; BE69 37                       7
        .byte   $37                             ; BE6A 37                       7
        .byte   $37                             ; BE6B 37                       7
        .byte   $37                             ; BE6C 37                       7
        .byte   $37                             ; BE6D 37                       7
        .byte   $37                             ; BE6E 37                       7
        .byte   $37                             ; BE6F 37                       7
        .byte   $37                             ; BE70 37                       7
        .byte   $37                             ; BE71 37                       7
        .byte   $37                             ; BE72 37                       7
        .byte   $37                             ; BE73 37                       7
        .byte   $37                             ; BE74 37                       7
        .byte   $37                             ; BE75 37                       7
        .byte   $37                             ; BE76 37                       7
        .byte   $37                             ; BE77 37                       7
        .byte   $37                             ; BE78 37                       7
        .byte   $37                             ; BE79 37                       7
        .byte   $37                             ; BE7A 37                       7
        .byte   $37                             ; BE7B 37                       7
        .byte   $37                             ; BE7C 37                       7
        .byte   $37                             ; BE7D 37                       7
        .byte   $37                             ; BE7E 37                       7
        .byte   $37                             ; BE7F 37                       7
        .byte   $37                             ; BE80 37                       7
        .byte   $37                             ; BE81 37                       7
        .byte   $37                             ; BE82 37                       7
        .byte   $37                             ; BE83 37                       7
        .byte   $37                             ; BE84 37                       7
        .byte   $37                             ; BE85 37                       7
        .byte   $37                             ; BE86 37                       7
        .byte   $37                             ; BE87 37                       7
        .byte   $37                             ; BE88 37                       7
        .byte   $37                             ; BE89 37                       7
        .byte   $37                             ; BE8A 37                       7
        .byte   $37                             ; BE8B 37                       7
        .byte   $37                             ; BE8C 37                       7
        .byte   $37                             ; BE8D 37                       7
        .byte   $37                             ; BE8E 37                       7
        .byte   $37                             ; BE8F 37                       7
        .byte   $37                             ; BE90 37                       7
        .byte   $37                             ; BE91 37                       7
        .byte   $37                             ; BE92 37                       7
        .byte   $37                             ; BE93 37                       7
        .byte   $37                             ; BE94 37                       7
        .byte   $37                             ; BE95 37                       7
        .byte   $37                             ; BE96 37                       7
        .byte   $37                             ; BE97 37                       7
        .byte   $37                             ; BE98 37                       7
        .byte   $37                             ; BE99 37                       7
        .byte   $37                             ; BE9A 37                       7
        .byte   $37                             ; BE9B 37                       7
        .byte   $37                             ; BE9C 37                       7
        .byte   $37                             ; BE9D 37                       7
        .byte   $37                             ; BE9E 37                       7
        .byte   $37                             ; BE9F 37                       7
        .byte   $37                             ; BEA0 37                       7
        .byte   $37                             ; BEA1 37                       7
        .byte   $37                             ; BEA2 37                       7
        .byte   $37                             ; BEA3 37                       7
        .byte   $37                             ; BEA4 37                       7
        .byte   $37                             ; BEA5 37                       7
        .byte   $37                             ; BEA6 37                       7
        .byte   $37                             ; BEA7 37                       7
        .byte   $37                             ; BEA8 37                       7
        .byte   $37                             ; BEA9 37                       7
        .byte   $37                             ; BEAA 37                       7
        .byte   $37                             ; BEAB 37                       7
        .byte   $37                             ; BEAC 37                       7
        .byte   $37                             ; BEAD 37                       7
        .byte   $37                             ; BEAE 37                       7
        .byte   $37                             ; BEAF 37                       7
        .byte   $37                             ; BEB0 37                       7
        .byte   $37                             ; BEB1 37                       7
        .byte   $37                             ; BEB2 37                       7
        .byte   $37                             ; BEB3 37                       7
        .byte   $37                             ; BEB4 37                       7
        .byte   $37                             ; BEB5 37                       7
        .byte   $37                             ; BEB6 37                       7
        .byte   $37                             ; BEB7 37                       7
        .byte   $37                             ; BEB8 37                       7
        .byte   $37                             ; BEB9 37                       7
        .byte   $37                             ; BEBA 37                       7
        .byte   $37                             ; BEBB 37                       7
        .byte   $37                             ; BEBC 37                       7
        .byte   $37                             ; BEBD 37                       7
        .byte   $37                             ; BEBE 37                       7
        .byte   $37                             ; BEBF 37                       7
        .byte   $37                             ; BEC0 37                       7
        .byte   $37                             ; BEC1 37                       7
        .byte   $37                             ; BEC2 37                       7
        .byte   $37                             ; BEC3 37                       7
        .byte   $37                             ; BEC4 37                       7
        .byte   $37                             ; BEC5 37                       7
        .byte   $37                             ; BEC6 37                       7
        .byte   $37                             ; BEC7 37                       7
        .byte   $37                             ; BEC8 37                       7
        .byte   $37                             ; BEC9 37                       7
        .byte   $37                             ; BECA 37                       7
        .byte   $37                             ; BECB 37                       7
        .byte   $37                             ; BECC 37                       7
        .byte   $37                             ; BECD 37                       7
        .byte   $37                             ; BECE 37                       7
        .byte   $37                             ; BECF 37                       7
        .byte   $37                             ; BED0 37                       7
        .byte   $37                             ; BED1 37                       7
        .byte   $37                             ; BED2 37                       7
        .byte   $37                             ; BED3 37                       7
        .byte   $37                             ; BED4 37                       7
        .byte   $37                             ; BED5 37                       7
        .byte   $37                             ; BED6 37                       7
        .byte   $37                             ; BED7 37                       7
        .byte   $37                             ; BED8 37                       7
        .byte   $37                             ; BED9 37                       7
        .byte   $37                             ; BEDA 37                       7
        .byte   $37                             ; BEDB 37                       7
        .byte   $37                             ; BEDC 37                       7
        .byte   $37                             ; BEDD 37                       7
        .byte   $37                             ; BEDE 37                       7
        .byte   $37                             ; BEDF 37                       7
        .byte   $37                             ; BEE0 37                       7
        .byte   $37                             ; BEE1 37                       7
        .byte   $37                             ; BEE2 37                       7
        .byte   $37                             ; BEE3 37                       7
        .byte   $37                             ; BEE4 37                       7
        .byte   $37                             ; BEE5 37                       7
        .byte   $37                             ; BEE6 37                       7
        .byte   $37                             ; BEE7 37                       7
        .byte   $37                             ; BEE8 37                       7
        .byte   $37                             ; BEE9 37                       7
        .byte   $37                             ; BEEA 37                       7
        .byte   $37                             ; BEEB 37                       7
        .byte   $37                             ; BEEC 37                       7
        .byte   $37                             ; BEED 37                       7
        .byte   $37                             ; BEEE 37                       7
        .byte   $37                             ; BEEF 37                       7
        .byte   $37                             ; BEF0 37                       7
        .byte   $37                             ; BEF1 37                       7
        .byte   $37                             ; BEF2 37                       7
        .byte   $37                             ; BEF3 37                       7
        .byte   $37                             ; BEF4 37                       7
        .byte   $37                             ; BEF5 37                       7
        .byte   $37                             ; BEF6 37                       7
        .byte   $37                             ; BEF7 37                       7
        .byte   $37                             ; BEF8 37                       7
        .byte   $37                             ; BEF9 37                       7
        .byte   $37                             ; BEFA 37                       7
        .byte   $37                             ; BEFB 37                       7
        .byte   $37                             ; BEFC 37                       7
        .byte   $37                             ; BEFD 37                       7
        .byte   $37                             ; BEFE 37                       7
        .byte   $37                             ; BEFF 37                       7
        .byte   $37                             ; BF00 37                       7
        .byte   $37                             ; BF01 37                       7
        .byte   $37                             ; BF02 37                       7
        .byte   $37                             ; BF03 37                       7
        .byte   $37                             ; BF04 37                       7
        .byte   $37                             ; BF05 37                       7
        .byte   $37                             ; BF06 37                       7
        .byte   $37                             ; BF07 37                       7
        .byte   $37                             ; BF08 37                       7
        .byte   $37                             ; BF09 37                       7
        .byte   $37                             ; BF0A 37                       7
        .byte   $37                             ; BF0B 37                       7
        .byte   $37                             ; BF0C 37                       7
        .byte   $37                             ; BF0D 37                       7
        .byte   $37                             ; BF0E 37                       7
        .byte   $37                             ; BF0F 37                       7
        .byte   $37                             ; BF10 37                       7
        .byte   $37                             ; BF11 37                       7
        .byte   $37                             ; BF12 37                       7
        .byte   $37                             ; BF13 37                       7
LBF14:  .byte   $37                             ; BF14 37                       7
        .byte   $37                             ; BF15 37                       7
        .byte   $37                             ; BF16 37                       7
        .byte   $37                             ; BF17 37                       7
        .byte   $37                             ; BF18 37                       7
        .byte   $37                             ; BF19 37                       7
        .byte   $37                             ; BF1A 37                       7
        .byte   $37                             ; BF1B 37                       7
        .byte   $37                             ; BF1C 37                       7
        .byte   $37                             ; BF1D 37                       7
        .byte   $37                             ; BF1E 37                       7
        .byte   $37                             ; BF1F 37                       7
        .byte   $37                             ; BF20 37                       7
        .byte   $37                             ; BF21 37                       7
        .byte   $37                             ; BF22 37                       7
        .byte   $37                             ; BF23 37                       7
        .byte   $37                             ; BF24 37                       7
        .byte   $37                             ; BF25 37                       7
        .byte   $37                             ; BF26 37                       7
        .byte   $37                             ; BF27 37                       7
        .byte   $37                             ; BF28 37                       7
        .byte   $37                             ; BF29 37                       7
        .byte   $37                             ; BF2A 37                       7
        .byte   $37                             ; BF2B 37                       7
        .byte   $37                             ; BF2C 37                       7
        .byte   $37                             ; BF2D 37                       7
        .byte   $37                             ; BF2E 37                       7
        .byte   $37                             ; BF2F 37                       7
        .byte   $37                             ; BF30 37                       7
        .byte   $37                             ; BF31 37                       7
        .byte   $37                             ; BF32 37                       7
        .byte   $37                             ; BF33 37                       7
        .byte   $37                             ; BF34 37                       7
        .byte   $37                             ; BF35 37                       7
        .byte   $37                             ; BF36 37                       7
LBF37:  .byte   $37                             ; BF37 37                       7
        .byte   $37                             ; BF38 37                       7
        .byte   $37                             ; BF39 37                       7
        .byte   $37                             ; BF3A 37                       7
        .byte   $37                             ; BF3B 37                       7
        .byte   $37                             ; BF3C 37                       7
        .byte   $37                             ; BF3D 37                       7
        .byte   $37                             ; BF3E 37                       7
        .byte   $37                             ; BF3F 37                       7
        .byte   $37                             ; BF40 37                       7
        .byte   $37                             ; BF41 37                       7
        .byte   $37                             ; BF42 37                       7
        .byte   $37                             ; BF43 37                       7
        .byte   $37                             ; BF44 37                       7
        .byte   $37                             ; BF45 37                       7
        .byte   $37                             ; BF46 37                       7
        .byte   $37                             ; BF47 37                       7
        .byte   $37                             ; BF48 37                       7
        .byte   $37                             ; BF49 37                       7
        .byte   $37                             ; BF4A 37                       7
        .byte   $37                             ; BF4B 37                       7
        .byte   $37                             ; BF4C 37                       7
        .byte   $37                             ; BF4D 37                       7
        .byte   $37                             ; BF4E 37                       7
        .byte   $37                             ; BF4F 37                       7
        .byte   $37                             ; BF50 37                       7
        .byte   $37                             ; BF51 37                       7
        .byte   $37                             ; BF52 37                       7
        .byte   $37                             ; BF53 37                       7
        .byte   $37                             ; BF54 37                       7
        .byte   $37                             ; BF55 37                       7
        .byte   $37                             ; BF56 37                       7
        .byte   $37                             ; BF57 37                       7
        .byte   $37                             ; BF58 37                       7
        .byte   $37                             ; BF59 37                       7
        .byte   $37                             ; BF5A 37                       7
        .byte   $37                             ; BF5B 37                       7
        .byte   $37                             ; BF5C 37                       7
        .byte   $37                             ; BF5D 37                       7
        .byte   $37                             ; BF5E 37                       7
        .byte   $37                             ; BF5F 37                       7
        .byte   $37                             ; BF60 37                       7
        .byte   $37                             ; BF61 37                       7
        .byte   $37                             ; BF62 37                       7
        .byte   $37                             ; BF63 37                       7
        .byte   $37                             ; BF64 37                       7
        .byte   $37                             ; BF65 37                       7
        .byte   $37                             ; BF66 37                       7
        .byte   $37                             ; BF67 37                       7
        .byte   $37                             ; BF68 37                       7
        .byte   $37                             ; BF69 37                       7
        .byte   $37                             ; BF6A 37                       7
        .byte   $37                             ; BF6B 37                       7
        .byte   $37                             ; BF6C 37                       7
        .byte   $37                             ; BF6D 37                       7
        .byte   $37                             ; BF6E 37                       7
        .byte   $37                             ; BF6F 37                       7
        .byte   $37                             ; BF70 37                       7
        .byte   $37                             ; BF71 37                       7
        .byte   $37                             ; BF72 37                       7
        .byte   $37                             ; BF73 37                       7
        .byte   $37                             ; BF74 37                       7
        .byte   $37                             ; BF75 37                       7
        .byte   $37                             ; BF76 37                       7
        .byte   $37                             ; BF77 37                       7
        .byte   $37                             ; BF78 37                       7
        .byte   $37                             ; BF79 37                       7
        .byte   $37                             ; BF7A 37                       7
        .byte   $37                             ; BF7B 37                       7
        .byte   $37                             ; BF7C 37                       7
        .byte   $37                             ; BF7D 37                       7
        .byte   $37                             ; BF7E 37                       7
        .byte   $37                             ; BF7F 37                       7
        .byte   $37                             ; BF80 37                       7
        .byte   $37                             ; BF81 37                       7
        .byte   $37                             ; BF82 37                       7
        .byte   $37                             ; BF83 37                       7
        .byte   $37                             ; BF84 37                       7
        .byte   $37                             ; BF85 37                       7
        .byte   $37                             ; BF86 37                       7
        .byte   $37                             ; BF87 37                       7
        .byte   $37                             ; BF88 37                       7
        .byte   $37                             ; BF89 37                       7
        .byte   $37                             ; BF8A 37                       7
        .byte   $37                             ; BF8B 37                       7
        .byte   $37                             ; BF8C 37                       7
        .byte   $37                             ; BF8D 37                       7
        .byte   $37                             ; BF8E 37                       7
        .byte   $37                             ; BF8F 37                       7
        .byte   $37                             ; BF90 37                       7
        .byte   $37                             ; BF91 37                       7
        .byte   $37                             ; BF92 37                       7
        .byte   $37                             ; BF93 37                       7
        .byte   $37                             ; BF94 37                       7
        .byte   $37                             ; BF95 37                       7
        .byte   $37                             ; BF96 37                       7
        .byte   $37                             ; BF97 37                       7
        .byte   $37                             ; BF98 37                       7
        .byte   $37                             ; BF99 37                       7
        .byte   $37                             ; BF9A 37                       7
        .byte   $37                             ; BF9B 37                       7
        .byte   $37                             ; BF9C 37                       7
        .byte   $37                             ; BF9D 37                       7
        .byte   $37                             ; BF9E 37                       7
        .byte   $37                             ; BF9F 37                       7
        .byte   $37                             ; BFA0 37                       7
        .byte   $37                             ; BFA1 37                       7
        .byte   $37                             ; BFA2 37                       7
        .byte   $37                             ; BFA3 37                       7
        .byte   $37                             ; BFA4 37                       7
        .byte   $37                             ; BFA5 37                       7
        .byte   $37                             ; BFA6 37                       7
        .byte   $37                             ; BFA7 37                       7
        .byte   $37                             ; BFA8 37                       7
        .byte   $37                             ; BFA9 37                       7
        .byte   $37                             ; BFAA 37                       7
        .byte   $37                             ; BFAB 37                       7
        .byte   $37                             ; BFAC 37                       7
        .byte   $37                             ; BFAD 37                       7
        .byte   $37                             ; BFAE 37                       7
        .byte   $37                             ; BFAF 37                       7
        .byte   $37                             ; BFB0 37                       7
        .byte   $37                             ; BFB1 37                       7
        .byte   $37                             ; BFB2 37                       7
        .byte   $37                             ; BFB3 37                       7
        .byte   $37                             ; BFB4 37                       7
        .byte   $37                             ; BFB5 37                       7
        .byte   $37                             ; BFB6 37                       7
        .byte   $37                             ; BFB7 37                       7
        .byte   $37                             ; BFB8 37                       7
        .byte   $37                             ; BFB9 37                       7
        .byte   $37                             ; BFBA 37                       7
        .byte   $37                             ; BFBB 37                       7
        .byte   $37                             ; BFBC 37                       7
        .byte   $37                             ; BFBD 37                       7
        .byte   $37                             ; BFBE 37                       7
        .byte   $37                             ; BFBF 37                       7
        .byte   $37                             ; BFC0 37                       7
        .byte   $37                             ; BFC1 37                       7
        .byte   $37                             ; BFC2 37                       7
        .byte   $37                             ; BFC3 37                       7
        .byte   $37                             ; BFC4 37                       7
        .byte   $37                             ; BFC5 37                       7
        .byte   $37                             ; BFC6 37                       7
        .byte   $37                             ; BFC7 37                       7
        .byte   $37                             ; BFC8 37                       7
        .byte   $37                             ; BFC9 37                       7
        .byte   $37                             ; BFCA 37                       7
        .byte   $37                             ; BFCB 37                       7
        .byte   $37                             ; BFCC 37                       7
        .byte   $37                             ; BFCD 37                       7
        .byte   $37                             ; BFCE 37                       7
        .byte   $37                             ; BFCF 37                       7
        .byte   $37                             ; BFD0 37                       7
        .byte   $37                             ; BFD1 37                       7
        .byte   $37                             ; BFD2 37                       7
        .byte   $37                             ; BFD3 37                       7
        .byte   $37                             ; BFD4 37                       7
        .byte   $37                             ; BFD5 37                       7
        .byte   $37                             ; BFD6 37                       7
        .byte   $37                             ; BFD7 37                       7
        .byte   $37                             ; BFD8 37                       7
LBFD9:  .byte   $37                             ; BFD9 37                       7
        .byte   $37                             ; BFDA 37                       7
        .byte   $37                             ; BFDB 37                       7
        .byte   $37                             ; BFDC 37                       7
        .byte   $37                             ; BFDD 37                       7
        .byte   $37                             ; BFDE 37                       7
        .byte   $37                             ; BFDF 37                       7
        .byte   $37                             ; BFE0 37                       7
        .byte   $37                             ; BFE1 37                       7
        .byte   $37                             ; BFE2 37                       7
        .byte   $37                             ; BFE3 37                       7
        .byte   $37                             ; BFE4 37                       7
        .byte   $37                             ; BFE5 37                       7
        .byte   $37                             ; BFE6 37                       7
        .byte   $37                             ; BFE7 37                       7
        .byte   $37                             ; BFE8 37                       7
        .byte   $37                             ; BFE9 37                       7
        .byte   $37                             ; BFEA 37                       7
        .byte   $37                             ; BFEB 37                       7
        .byte   $37                             ; BFEC 37                       7
        .byte   $37                             ; BFED 37                       7
LBFEE:  .byte   $37                             ; BFEE 37                       7
        .byte   $37                             ; BFEF 37                       7
        .byte   $37                             ; BFF0 37                       7
        .byte   $37                             ; BFF1 37                       7
        .byte   $37                             ; BFF2 37                       7
        .byte   $37                             ; BFF3 37                       7
        .byte   $37                             ; BFF4 37                       7
        .byte   $37                             ; BFF5 37                       7
        .byte   $37                             ; BFF6 37                       7
        .byte   $37                             ; BFF7 37                       7
        .byte   $37                             ; BFF8 37                       7
        .byte   $37                             ; BFF9 37                       7
        .byte   $37                             ; BFFA 37                       7
        .byte   $37                             ; BFFB 37                       7
        .byte   $37                             ; BFFC 37                       7
        .byte   $37                             ; BFFD 37                       7
        .byte   $37                             ; BFFE 37                       7
        .byte   $37                             ; BFFF 37                       7
