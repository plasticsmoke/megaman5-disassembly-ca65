.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK05"

; =============================================================================
; BANK $05 (mapped at $A000) — STAGE-GIMMICK DIRECTORS + CHARGE MAN
; STAGE DATA
; Data half (file +$0900 on): stage $05 (Charge Man) stage data —
; screen table at $A900 with this bank at $A000; format in
; DATA_REFERENCE.md section 11.
; =============================================================================
L0000           := $0000
L0006           := $0006
L0010           := $0010
L0020           := $0020
L0043           := $0043
L004C           := $004C
L0080           := $0080
L0098           := $0098
L0111           := $0111
L0200           := $0200
L0208           := $0208
L0802           := $0802
L0818           := $0818
L1727           := $1727
L174C           := $174C
L19DF           := $19DF
L2037           := $2037
L2080           := $2080
L2221           := $2221
L2837           := $2837
L2843           := $2843
L3840           := $3840
L4C4C           := $4C4C
L4C64           := $4C64
L5051           := $5051
L6362           := $6362
L654C           := $654C
L6868           := $6868
L6F04           := $6F04
L8000           := $8000
L8004           := $8004
L800A           := $800A
L804C           := $804C
L8100           := $8100
L82BA           := $82BA
L8675           := $8675
L8860           := $8860
L886C           := $886C
L994E           := $994E
LD7DB           := $D7DB
LD806           := $D806
LD8A2           := $D8A2
LDA4E           := $DA4E
LF05A           := $F05A
LFD10           := $FD10
LFF10           := $FF10
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR types $06/$07 — gravity flip panel, horizontal (Gravity Man
; stage): while the player touches it, gravity_flip is forced by which
; side of the panel the player's X is on; polarity and the player's
; vflip bit come from the per-type rows at $A06C ($A066/$A068 + type).
; On an actual change: sound $3F. Type $07 is the mirrored polarity.
; =============================================================================
        jsr     entity_player_collide                           ; A000 20 87 EF                  ..
        bcs     LA06B                           ; A003 B0 66                    .f
        lda     $AF                             ; A005 A5 AF                    ..
        sta     L0000                           ; A007 85 00                    ..
        ldy     $0300,x                         ; A009 BC 00 03                 ...
        lda     $0528                           ; A00C AD 28 05                 .(.
        and     #$BF                            ; A00F 29 BF                    ).
        ora     LA066,y                         ; A011 19 66 A0                 .f.
        sta     $0528                           ; A014 8D 28 05                 .(.
        lda     LA068,y                         ; A017 B9 68 A0                 .h.
        sta     $01                             ; A01A 85 01                    ..
        lda     $0330                           ; A01C AD 30 03                 .0.
        cmp     $0330,x                         ; A01F DD 30 03                 .0.
        bcs     LA05E                           ; A022 B0 3A                    .:
        lda     $0528                           ; A024 AD 28 05                 .(.
        eor     #$40                            ; A027 49 40                    I@
        sta     $0528                           ; A029 8D 28 05                 .(.
        lda     $01                             ; A02C A5 01                    ..
        eor     #$01                            ; A02E 49 01                    I.
        sta     $01                             ; A030 85 01                    ..
        jmp     LA05E                           ; A032 4C 5E A0                 L^.

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $08 — gravity flip panel, vertical: same, but compares
; the player's Y (above the panel = flipped).
; =============================================================================
        jsr     entity_player_collide                           ; A035 20 87 EF                  ..
        bcs     LA06B                           ; A038 B0 31                    .1
        lda     $AF                             ; A03A A5 AF                    ..
        sta     L0000                           ; A03C 85 00                    ..
        lda     $0528                           ; A03E AD 28 05                 .(.
        and     #$BF                            ; A041 29 BF                    ).
        sta     $0528                           ; A043 8D 28 05                 .(.
        lda     #$00                            ; A046 A9 00                    ..
        sta     $01                             ; A048 85 01                    ..
        lda     $0378                           ; A04A AD 78 03                 .x.
        cmp     $0378,x                         ; A04D DD 78 03                 .x.
        bcs     LA05E                           ; A050 B0 0C                    ..
        lda     $0528                           ; A052 AD 28 05                 .(.
        ora     #$40                            ; A055 09 40                    .@
        sta     $0528                           ; A057 8D 28 05                 .(.
        lda     #$01                            ; A05A A9 01                    ..
        sta     $01                             ; A05C 85 01                    ..
LA05E:  lda     $01                             ; A05E A5 01                    ..
        cmp     L0000                           ; A060 C5 00                    ..
        beq     LA06B                           ; A062 F0 07                    ..
        sta     $AF                             ; A064 85 AF                    ..
LA066:  lda     #$3F                            ; A066 A9 3F                    .?
LA068:  jsr     queue_sound                           ; A068 20 5D EC                  ].
LA06B:  rts                                     ; A06B 60                       `

        .byte   $40,$00,$01,$00                 ; A06C  panel rows: LA066/LA068+type
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $09 — Star Man stage space-section backdrop (IRQ mode
; $17): rides the player's X/screen, oscillates vertically ($00.80,
; reversing every $80 frames), and drives the vertical split ($FA from
; own Y, $78/$79/$9B seeds, $FD=2).
; =============================================================================
        lda     #$80                            ; A070 A9 80                    ..
        sta     $1E                             ; A072 85 1E                    ..
        lda     #$17                            ; A074 A9 17                    ..
        sta     $23                             ; A076 85 23                    .#
        lda     #$82                            ; A078 A9 82                    ..
        sta     $0588,x                         ; A07A 9D 88 05                 ...
        lda     #$A0                            ; A07D A9 A0                    ..
        sta     $05A0,x                         ; A07F 9D A0 05                 ...
        lda     $1E                             ; A082 A5 1E                    ..
        bne     LA0E2                           ; A084 D0 5C                    .\
        lda     $0330                           ; A086 AD 30 03                 .0.
        sta     $0330,x                         ; A089 9D 30 03                 .0.
        lda     $0348                           ; A08C AD 48 03                 .H.
        sta     $0348,x                         ; A08F 9D 48 03                 .H.
        lda     $99                             ; A092 A5 99                    ..
        bne     LA0BB                           ; A094 D0 25                    .%
        sta     $0360,x                         ; A096 9D 60 03                 .`.
        lda     #$80                            ; A099 A9 80                    ..
        sta     $78                             ; A09B 85 78                    .x
        lda     #$22                            ; A09D A9 22                    ."
        sta     $79                             ; A09F 85 79                    .y
        lda     #$9F                            ; A0A1 A9 9F                    ..
        sta     $9B                             ; A0A3 85 9B                    ..
        inc     $99                             ; A0A5 E6 99                    ..
        lda     #$80                            ; A0A7 A9 80                    ..
        sta     $0468,x                         ; A0A9 9D 68 04                 .h.
        lda     #$08                            ; A0AC A9 08                    ..
        sta     $0420,x                         ; A0AE 9D 20 04                 . .
        lda     #$80                            ; A0B1 A9 80                    ..
        sta     $03D8,x                         ; A0B3 9D D8 03                 ...
        lda     #$00                            ; A0B6 A9 00                    ..
        sta     $03F0,x                         ; A0B8 9D F0 03                 ...
LA0BB:  jsr     entity_vert_dispatch_raw                           ; A0BB 20 86 EA                  ..
        lda     #$00                            ; A0BE A9 00                    ..
        sta     $0390,x                         ; A0C0 9D 90 03                 ...
        dec     $0468,x                         ; A0C3 DE 68 04                 .h.
        bne     LA0D5                           ; A0C6 D0 0D                    ..
        lda     #$80                            ; A0C8 A9 80                    ..
        sta     $0468,x                         ; A0CA 9D 68 04                 .h.
        lda     $0420,x                         ; A0CD BD 20 04                 . .
        eor     #$0C                            ; A0D0 49 0C                    I.
        sta     $0420,x                         ; A0D2 9D 20 04                 . .
LA0D5:  lda     #$02                            ; A0D5 A9 02                    ..
        sta     $FD                             ; A0D7 85 FD                    ..
        lda     $0378,x                         ; A0D9 BD 78 03                 .x.
        sta     $FA                             ; A0DC 85 FA                    ..
        bne     LA0E2                           ; A0DE D0 02                    ..
        sta     $FD                             ; A0E0 85 FD                    ..
LA0E2:  rts                                     ; A0E2 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $0B — Gyro Man stage express elevator: arms the
; vertical-wrap scroll ($74/$46), and once ridden (player collide)
; switches to IRQ mode $1D, then rockets the shaft upward $0.80/frame
; ($A141, 16-bit through $FA/$FB); at the top it swaps in bank pair
; $14/$1D, resets the section chain to screen $15/section $2B and
; re-enters normal scrolling.
; =============================================================================
        lda     #$FF                            ; A0E3 A9 FF                    ..
        sta     $74                             ; A0E5 85 74                    .t
        sta     $46                             ; A0E7 85 46                    .F
        lda     #$00                            ; A0E9 A9 00                    ..
        sta     $75                             ; A0EB 85 75                    .u
        sta     $76                             ; A0ED 85 76                    .v
        jsr     entity_player_collide                           ; A0EF 20 87 EF                  ..
        bcs     LA140                           ; A0F2 B0 4C                    .L
        lda     #$00                            ; A0F4 A9 00                    ..
        sta     $FB                             ; A0F6 85 FB                    ..
        sta     $0360,x                         ; A0F8 9D 60 03                 .`.
        jsr     set_mirroring                           ; A0FB 20 B7 FF                  ..
        lda     #$80                            ; A0FE A9 80                    ..
        sta     $1E                             ; A100 85 1E                    ..
        lda     #$1D                            ; A102 A9 1D                    ..
        sta     $23                             ; A104 85 23                    .#
        lda     #$03                            ; A106 A9 03                    ..
        sta     $0408,x                         ; A108 9D 08 04                 ...
        lda     #$C8                            ; A10B A9 C8                    ..
        sta     $0378,x                         ; A10D 9D 78 03                 .x.
        lda     $0528,x                         ; A110 BD 28 05                 .(.
        ora     #$02                            ; A113 09 02                    ..
        sta     $0528,x                         ; A115 9D 28 05                 .(.
        lda     #$22                            ; A118 A9 22                    ."
        sta     $0588,x                         ; A11A 9D 88 05                 ...
        lda     #$A1                            ; A11D A9 A1                    ..
        sta     $05A0,x                         ; A11F 9D A0 05                 ...
        lda     $1E                             ; A122 A5 1E                    ..
        bne     LA140                           ; A124 D0 1A                    ..
        lda     #$BF                            ; A126 A9 BF                    ..
        sta     $9B                             ; A128 85 9B                    ..
        lda     #$02                            ; A12A A9 02                    ..
LA12C:  sta     $99                             ; A12C 85 99                    ..
        lda     #$1D                            ; A12E A9 1D                    ..
        sta     $25                             ; A130 85 25                    .%
        lda     #$14                            ; A132 A9 14                    ..
        sta     $24                             ; A134 85 24                    .$
        lda     #$41                            ; A136 A9 41                    .A
        sta     $0588,x                         ; A138 9D 88 05                 ...
        lda     #$A1                            ; A13B A9 A1                    ..
        sta     $05A0,x                         ; A13D 9D A0 05                 ...
LA140:  rts                                     ; A140 60                       `

; ----------------------------------------------------------------------------
        lda     $0360,x                         ; A141 BD 60 03                 .`.
        sec                                     ; A144 38                       8
        sbc     #$80                            ; A145 E9 80                    ..
        sta     $0360,x                         ; A147 9D 60 03                 .`.
        lda     $FA                             ; A14A A5 FA                    ..
        sbc     #$00                            ; A14C E9 00                    ..
        bcs     LA154                           ; A14E B0 04                    ..
        inc     $FB                             ; A150 E6 FB                    ..
        sbc     #$0F                            ; A152 E9 0F                    ..
LA154:  sta     $FA                             ; A154 85 FA                    ..
        sta     $76                             ; A156 85 76                    .v
        bne     LA18F                           ; A158 D0 35                    .5
        lda     $24                             ; A15A A5 24                    .$
        cmp     #$1D                            ; A15C C9 1D                    ..
        bne     LA18F                           ; A15E D0 2F                    ./
        lda     #$16                            ; A160 A9 16                    ..
        sta     $24                             ; A162 85 24                    .$
        lda     #$00                            ; A164 A9 00                    ..
        sta     $2B                             ; A166 85 2B                    .+
        sta     $2A                             ; A168 85 2A                    .*
        sta     $25                             ; A16A 85 25                    .%
        sta     $FB                             ; A16C 85 FB                    ..
        lda     #$2B                            ; A16E A9 2B                    .+
        sta     $29                             ; A170 85 29                    .)
        lda     #$01                            ; A172 A9 01                    ..
        sta     $28                             ; A174 85 28                    .(
        lda     #$15                            ; A176 A9 15                    ..
        sta     $F9                             ; A178 85 F9                    ..
        sta     $0348                           ; A17A 8D 48 03                 .H.
        sta     $0348,x                         ; A17D 9D 48 03                 .H.
        lda     #$01                            ; A180 A9 01                    ..
        jsr     set_mirroring                           ; A182 20 B7 FF                  ..
        lda     #$8F                            ; A185 A9 8F                    ..
        sta     $0588,x                         ; A187 9D 88 05                 ...
        lda     #$A1                            ; A18A A9 A1                    ..
        sta     $05A0,x                         ; A18C 9D A0 05                 ...
LA18F:  rts                                     ; A18F 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $0C — block restorer: after its delay, redraws its
; metatile (LD7DB with row $22 / tile $10 from $0480/$0498), takes
; sub_type $69, falls until it lands, then clears this block's bit in
; the destroyed-block bitmap ($0680 via the $F2BA/$F2C2 masks) and
; wipes — the re-materializing block animation.
; =============================================================================
        lda     $0468,x                         ; A190 BD 68 04                 .h.
        beq     LA1B2                           ; A193 F0 1D                    ..
        lda     $1C                             ; A195 A5 1C                    ..
        bne     LA1D1                           ; A197 D0 38                    .8
        dec     $0468,x                         ; A199 DE 68 04                 .h.
        bne     LA1D1                           ; A19C D0 33                    .3
        lda     $0480,x                         ; A19E BD 80 04                 ...
        sta     $22                             ; A1A1 85 22                    ."
        lda     $0498,x                         ; A1A3 BD 98 04                 ...
        sta     L0010                           ; A1A6 85 10                    ..
        ldy     #$00                            ; A1A8 A0 00                    ..
        jsr     LD7DB                           ; A1AA 20 DB D7                  ..
        lda     #$69                            ; A1AD A9 69                    .i
        jsr     entity_set_subtype                           ; A1AF 20 98 EA                  ..
LA1B2:  lda     $0528,x                         ; A1B2 BD 28 05                 .(.
        and     #$04                            ; A1B5 29 04                    ).
        bne     LA1D1                           ; A1B7 D0 18                    ..
        jsr     entity_process_y_vel                           ; A1B9 20 68 E9                  h.
        lda     $0390,x                         ; A1BC BD 90 03                 ...
        beq     LA1D1                           ; A1BF F0 10                    ..
        lda     #$00                            ; A1C1 A9 00                    ..
        sta     $0378,x                         ; A1C3 9D 78 03                 .x.
        sta     $0390,x                         ; A1C6 9D 90 03                 ...
        lda     $0528,x                         ; A1C9 BD 28 05                 .(.
        ora     #$04                            ; A1CC 09 04                    ..
        sta     $0528,x                         ; A1CE 9D 28 05                 .(.
LA1D1:  lda     $0330,x                         ; A1D1 BD 30 03                 .0.
        sec                                     ; A1D4 38                       8
        sbc     $FC                             ; A1D5 E5 FC                    ..
        sta     L0000                           ; A1D7 85 00                    ..
        lda     $0348,x                         ; A1D9 BD 48 03                 .H.
        sbc     $F9                             ; A1DC E5 F9                    ..
        beq     LA215                           ; A1DE F0 35                    .5
        lda     L0000                           ; A1E0 A5 00                    ..
        bcs     LA1E8                           ; A1E2 B0 04                    ..
        eor     #$FF                            ; A1E4 49 FF                    I.
        adc     #$01                            ; A1E6 69 01                    i.
LA1E8:  cmp     #$10                            ; A1E8 C9 10                    ..
        bcc     LA215                           ; A1EA 90 29    offscreen check
        lda     $0480,x                         ; A1EC BD 80 04
        and     #$01                            ; A1EF 29 01                    ).
        asl     a                               ; A1F1 0A                       .
        asl     a                               ; A1F2 0A                       .
        ora     $0498,x                         ; A1F3 1D 98 04                 ...
        tay                                     ; A1F6 A8                       .
        lda     $F2BA,y                         ; A1F7 B9 BA F2                 ...
        sta     L0000                           ; A1FA 85 00                    ..
        lda     $0348,x                         ; A1FC BD 48 03                 .H.
        and     #$01                            ; A1FF 29 01                    ).
        tay                                     ; A201 A8                       .
        lda     $0480,x                         ; A202 BD 80 04                 ...
        lsr     a                               ; A205 4A                       J
        ora     $F2C2,y                         ; A206 19 C2 F2                 ...
        tay                                     ; A209 A8                       .
        lda     $0680,y                         ; A20A B9 80 06                 ...
        and     L0000                           ; A20D 25 00                    %.
        sta     $0680,y                         ; A20F 99 80 06                 ...
        jsr     entity_wipe_x                           ; A212 20 C4 F2                  ..
LA215:  rts                                     ; A215 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $0D — Wave Man stage bubble platform (spawned by the
; $0E spawner). Big variant (this entry): forms at anim phase 4 (sub
; $64), rises $00.80/frame; the player standing on top latches
; ride_slot $37 (sub $5C while ridden, $64 free); pops at the ceiling
; probe ($A276: sub $84 burst, becomes inert type $01). Small variant
; at $A284 (sub $66): rises 1 px/f, pops shortly after being stood on.
; =============================================================================
        lda     $0540,x                         ; A216 BD 40 05                 .@.
        cmp     #$04                            ; A219 C9 04                    ..
        bne     LA275                           ; A21B D0 58                    .X
        lda     #$64                            ; A21D A9 64                    .d
        jsr     entity_set_subtype                           ; A21F 20 98 EA                  ..
        lda     $0378,x                         ; A222 BD 78 03                 .x.
        sec                                     ; A225 38                       8
        sbc     #$14                            ; A226 E9 14                    ..
        sta     $0378,x                         ; A228 9D 78 03                 .x.
        lda     #$80                            ; A22B A9 80                    ..
        sta     $03D8,x                         ; A22D 9D D8 03                 ...
        lda     #$00                            ; A230 A9 00                    ..
        sta     $03F0,x                         ; A232 9D F0 03                 ...
        inc     $0528,x                         ; A235 FE 28 05                 .(.
        lda     #$42                            ; A238 A9 42                    .B
        sta     $0588,x                         ; A23A 9D 88 05                 ...
        lda     #$A2                            ; A23D A9 A2                    ..
        sta     $05A0,x                         ; A23F 9D A0 05                 ...
        ldy     #$18                            ; A242 A0 18                    ..
        jsr     entity_move_up                           ; A244 20 80 E7                  ..
        bcs     LA276                           ; A247 B0 2D                    .-
        lda     #$64                            ; A249 A9 64                    .d
        sta     L0010                           ; A24B 85 10                    ..
        dec     $0378,x                         ; A24D DE 78 03                 .x.
        jsr     entity_player_collide                           ; A250 20 87 EF                  ..
        inc     $0378,x                         ; A253 FE 78 03                 .x.
        bcs     LA26B                           ; A256 B0 13                    ..
        lda     $0378,x                         ; A258 BD 78 03                 .x.
        sec                                     ; A25B 38                       8
        sbc     $0378                           ; A25C ED 78 03                 .x.
        bcc     LA26B                           ; A25F 90 0A                    ..
        cmp     #$10                            ; A261 C9 10                    ..
        bcc     LA26B                           ; A263 90 06                    ..
        stx     $37                             ; A265 86 37                    .7
        lda     #$5C                            ; A267 A9 5C                    .\
        sta     L0010                           ; A269 85 10                    ..
LA26B:  lda     L0010                           ; A26B A5 10                    ..
        cmp     $0558,x                         ; A26D DD 58 05                 .X.
        beq     LA275                           ; A270 F0 03                    ..
        jsr     entity_set_subtype                           ; A272 20 98 EA                  ..
LA275:  rts                                     ; A275 60                       `

; ----------------------------------------------------------------------------
LA276:  lda     #$84                            ; A276 A9 84                    ..
        jsr     entity_set_subtype                           ; A278 20 98 EA                  ..
        jsr     entity_wipe_x                           ; A27B 20 C4 F2                  ..
        lda     #$01                            ; A27E A9 01                    ..
        sta     $0300,x                         ; A280 9D 00 03                 ...
        rts                                     ; A283 60                       `

; ----------------------------------------------------------------------------
        lda     $0540,x                         ; A284 BD 40 05                 .@.
        bne     LA275                           ; A287 D0 EC                    ..
        lda     #$66                            ; A289 A9 66                    .f
        jsr     entity_set_subtype                           ; A28B 20 98 EA                  ..
        lda     $0378,x                         ; A28E BD 78 03                 .x.
        sec                                     ; A291 38                       8
        sbc     #$04                            ; A292 E9 04                    ..
        sta     $0378,x                         ; A294 9D 78 03                 .x.
        lda     #$00                            ; A297 A9 00                    ..
        sta     $03D8,x                         ; A299 9D D8 03                 ...
        lda     #$01                            ; A29C A9 01                    ..
        sta     $03F0,x                         ; A29E 9D F0 03                 ...
        inc     $0528,x                         ; A2A1 FE 28 05
        lda     #$AE                            ; A2A4 A9 AE
        sta     $0588,x                         ; A2A6 9D 88 05
        lda     #$A2                            ; A2A9 A9 A2
        sta     $05A0,x                         ; A2AB 9D A0 05 behavior PC := $A2AE
        ldy     #$14                            ; A2AE A0 14                    ..
        jsr     entity_move_up                           ; A2B0 20 80 E7                  ..
        lda     L0010                           ; A2B3 A5 10                    ..
        and     #$10                            ; A2B5 29 10                    ).
        bne     LA2DC                           ; A2B7 D0 23                    .#
        lda     $0468,x                         ; A2B9 BD 68 04                 .h.
        bne     LA2D7                           ; A2BC D0 19                    ..
        jsr     entity_player_collide                           ; A2BE 20 87 EF                  ..
        bcs     LA2E9                           ; A2C1 B0 26                    .&
        lda     $0378,x                         ; A2C3 BD 78 03                 .x.
        sec                                     ; A2C6 38                       8
        sbc     $0378                           ; A2C7 ED 78 03                 .x.
        bcc     LA2E9                           ; A2CA 90 1D                    ..
        cmp     #$08                            ; A2CC C9 08                    ..
        bcc     LA2E9                           ; A2CE 90 19                    ..
        stx     $37                             ; A2D0 86 37                    .7
        lda     #$1E                            ; A2D2 A9 1E                    ..
        sta     $0468,x                         ; A2D4 9D 68 04                 .h.
LA2D7:  dec     $0468,x                         ; A2D7 DE 68 04                 .h.
        bne     LA2E9                           ; A2DA D0 0D                    ..
LA2DC:  jsr     entity_wipe_x                           ; A2DC 20 C4 F2                  ..
        lda     #$5D                            ; A2DF A9 5D                    .]
        jsr     entity_set_subtype                           ; A2E1 20 98 EA                  ..
        lda     #$01                            ; A2E4 A9 01                    ..
        sta     $0300,x                         ; A2E6 9D 00 03                 ...
LA2E9:  rts                                     ; A2E9 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $0E — bubble-column spawner (Wave Man stage): every $51
; frames spawns a type $0D bubble, cycling through 5 columns (start
; offset by screen via LA371): sub_type LA360, X LA365, shape LA36A,
; variant PC LA36F/LA374 (big $A216 / small $A284).
; =============================================================================
        ldy     $F9                             ; A2EA A4 F9                    ..
        lda     LA371,y                         ; A2EC B9 71 A3                 .q.
        sta     $0480,x                         ; A2EF 9D 80 04                 ...
        lda     #$50                            ; A2F2 A9 50                    .P
        sta     $0468,x                         ; A2F4 9D 68 04                 .h.
        lda     #$01                            ; A2F7 A9 01                    ..
        sta     $0588,x                         ; A2F9 9D 88 05                 ...
        lda     #$A3                            ; A2FC A9 A3                    ..
        sta     $05A0,x                         ; A2FE 9D A0 05                 ...
        lda     $0468,x                         ; A301 BD 68 04                 .h.
        bne     LA35C                           ; A304 D0 56                    .V
        jsr     find_free_slot_y                           ; A306 20 6F F1                  o.
        bcs     LA357                           ; A309 B0 4C                    .L
        sty     $0F                             ; A30B 84 0F                    ..
        ldy     $0480,x                         ; A30D BC 80 04                 ...
        sty     $0E                             ; A310 84 0E                    ..
        lda     LA360,y                         ; A312 B9 60 A3                 .`.
        ldy     $0F                             ; A315 A4 0F                    ..
        jsr     entity_init_pos                           ; A317 20 A4 EA                  ..
        ldx     $0E                             ; A31A A6 0E                    ..
        lda     #$0D                            ; A31C A9 0D                    ..
        sta     $0300,y                         ; A31E 99 00 03                 ...
        lda     LA365,x                         ; A321 BD 65 A3                 .e.
        sta     $0330,y                         ; A324 99 30 03                 .0.
        lda     LA36F,x                         ; A327 BD 6F A3                 .o.
        sta     $0588,y                         ; A32A 99 88 05                 ...
        lda     LA374,x                         ; A32D BD 74 A3                 .t.
        sta     $05A0,y                         ; A330 99 A0 05                 ...
        lda     LA36A,x                         ; A333 BD 6A A3                 .j.
        sta     $0408,y                         ; A336 99 08 04                 ...
        bne     LA346                           ; A339 D0 0B                    ..
        lda     $F9                             ; A33B A5 F9                    ..
        cmp     #$08                            ; A33D C9 08                    ..
        beq     LA346                           ; A33F F0 05                    ..
        lda     #$04                            ; A341 A9 04                    ..
        sta     $0540,y                         ; A343 99 40 05                 .@.
LA346:  ldx     $A6                             ; A346 A6 A6                    ..
        inc     $0480,x                         ; A348 FE 80 04                 ...
        lda     $0480,x                         ; A34B BD 80 04                 ...
        cmp     #$05                            ; A34E C9 05                    ..
        bne     LA357                           ; A350 D0 05                    ..
        lda     #$00                            ; A352 A9 00                    ..
        sta     $0480,x                         ; A354 9D 80 04                 ...
LA357:  lda     #$51                            ; A357 A9 51                    .Q
        sta     $0468,x                         ; A359 9D 68 04                 .h.
LA35C:  dec     $0468,x                         ; A35C DE 68 04                 .h.
        rts                                     ; A35F 60                       `

; ----------------------------------------------------------------------------
LA360:  .byte   $65,$63,$65,$65,$63             ; A360  bubble sub_type
LA365:  .byte   $E8,$B8,$88,$58,$28             ; A365  bubble X
LA36A:  .byte   $05,$00,$05,$05,$00             ; A36A  bubble shape
LA36F:  .byte   $84,$16                         ; A36F  bubble PC lo (overlaps)
LA371:  .byte   $84,$84,$16                     ; A371  ^ + per-screen start idx
LA374:  .byte   $A2,$A2,$A2,$A2,$A2             ; A374  bubble PC hi
        .byte   $00,$02,$02                     ; A379  (start idx tail)
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $0F — Wily 1 shaft water level (IRQ mode $1C): pinned
; to the camera center, vertical-scroll section ($46); its Y (kept in
; $0498 across the offscreen clamp) rises and falls in $30-frame
; strokes with a $1E pause at the top, and drives the water split
; ($FA := water Y, $FD=2).
; =============================================================================
        lda     #$80                            ; A37C A9 80                    ..
        sta     $1E                             ; A37E 85 1E                    ..
        lda     #$1C                            ; A380 A9 1C                    ..
        sta     $23                             ; A382 85 23                    .#
        lda     #$8E                            ; A384 A9 8E                    ..
        sta     $0588,x                         ; A386 9D 88 05                 ...
        lda     #$A3                            ; A389 A9 A3                    ..
        sta     $05A0,x                         ; A38B 9D A0 05                 ...
        lda     $1E                             ; A38E A5 1E                    ..
        bne     LA3A9                           ; A390 D0 17                    ..
        lda     $FC                             ; A392 A5 FC                    ..
        clc                                     ; A394 18                       .
        adc     #$80                            ; A395 69 80                    i.
        sta     $0330,x                         ; A397 9D 30 03                 .0.
        lda     $F9                             ; A39A A5 F9                    ..
        adc     #$00                            ; A39C 69 00                    i.
        sta     $0348,x                         ; A39E 9D 48 03                 .H.
        lda     $0480,x                         ; A3A1 BD 80 04                 ...
        beq     LA3AA                           ; A3A4 F0 04                    ..
        dec     $0480,x                         ; A3A6 DE 80 04                 ...
LA3A9:  rts                                     ; A3A9 60                       `

; ----------------------------------------------------------------------------
LA3AA:  lda     $99                             ; A3AA A5 99                    ..
        bne     LA3D2                           ; A3AC D0 24                    .$
        lda     #$40                            ; A3AE A9 40                    .@
        sta     $78                             ; A3B0 85 78                    .x
        lda     #$23                            ; A3B2 A9 23                    .#
        sta     $79                             ; A3B4 85 79                    .y
        lda     #$CF                            ; A3B6 A9 CF                    ..
        sta     $9B                             ; A3B8 85 9B                    ..
        inc     $99                             ; A3BA E6 99                    ..
        inc     $46                             ; A3BC E6 46                    .F
        lda     #$30                            ; A3BE A9 30                    .0
        sta     $0468,x                         ; A3C0 9D 68 04                 .h.
        lda     #$08                            ; A3C3 A9 08                    ..
        sta     $0420,x                         ; A3C5 9D 20 04                 . .
        lda     #$00                            ; A3C8 A9 00                    ..
        sta     $03D8,x                         ; A3CA 9D D8 03                 ...
        lda     #$01                            ; A3CD A9 01                    ..
        sta     $03F0,x                         ; A3CF 9D F0 03                 ...
LA3D2:  lda     $0498,x                         ; A3D2 BD 98 04                 ...
        sta     $0378,x                         ; A3D5 9D 78 03                 .x.
        jsr     entity_vert_dispatch_raw                           ; A3D8 20 86 EA                  ..
        lda     $0378,x                         ; A3DB BD 78 03                 .x.
        sta     $0498,x                         ; A3DE 9D 98 04                 ...
        lda     #$D8                            ; A3E1 A9 D8                    ..
        sta     $0378,x                         ; A3E3 9D 78 03                 .x.
        lda     #$00                            ; A3E6 A9 00                    ..
        sta     $0390,x                         ; A3E8 9D 90 03                 ...
        dec     $0468,x                         ; A3EB DE 68 04                 .h.
        bne     LA406                           ; A3EE D0 16                    ..
        lda     #$30                            ; A3F0 A9 30                    .0
        sta     $0468,x                         ; A3F2 9D 68 04                 .h.
        lda     $0420,x                         ; A3F5 BD 20 04                 . .
        eor     #$0C                            ; A3F8 49 0C                    I.
        sta     $0420,x                         ; A3FA 9D 20 04                 . .
        and     #$08                            ; A3FD 29 08                    ).
        beq     LA406                           ; A3FF F0 05                    ..
        lda     #$1E                            ; A401 A9 1E                    ..
        sta     $0480,x                         ; A403 9D 80 04                 ...
LA406:  lda     #$02                            ; A406 A9 02                    ..
        sta     $FD                             ; A408 85 FD                    ..
        lda     $0498,x                         ; A40A BD 98 04                 ...
        sta     $FA                             ; A40D 85 FA                    ..
        bne     LA413                           ; A40F D0 02                    ..
        sta     $FD                             ; A411 85 FD                    ..
LA413:  rts                                     ; A413 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $41 — Charge Man stage train parallax: rides the
; player, sets up the split ($7A=$0F, $9B=$40, mode 4), and advances
; the two background strips $78/$79 by +/- the player's own x
; velocity while the pad is held ($16) — the scenery streams past the
; moving train.
; =============================================================================
        lda     $0330                           ; A414 AD 30 03                 .0.
        sta     $0330,x                         ; A417 9D 30 03                 .0.
        lda     $0348                           ; A41A AD 48 03                 .H.
        sta     $0348,x                         ; A41D 9D 48 03                 .H.
        lda     $99                             ; A420 A5 99                    ..
        bne     LA434                           ; A422 D0 10                    ..
        sta     $78                             ; A424 85 78                    .x
        sta     $79                             ; A426 85 79                    .y
        lda     #$0F                            ; A428 A9 0F                    ..
        sta     $7A                             ; A42A 85 7A                    .z
        lda     #$40                            ; A42C A9 40                    .@
        sta     $9B                             ; A42E 85 9B                    ..
        lda     #$04                            ; A430 A9 04                    ..
        sta     $99                             ; A432 85 99                    ..
LA434:  lda     #$00                            ; A434 A9 00                    ..
        sta     L0000                           ; A436 85 00                    ..
        lda     #$03                            ; A438 A9 03                    ..
        sta     $01                             ; A43A 85 01                    ..
        lda     #$00                            ; A43C A9 00                    ..
        sta     $02                             ; A43E 85 02                    ..
        lda     #$05                            ; A440 A9 05                    ..
        sta     $03                             ; A442 85 03                    ..
        lda     $16                             ; A444 A5 16                    ..
        and     #$03                            ; A446 29 03                    ).
        beq     LA48D                           ; A448 F0 43                    .C
        and     #$01                            ; A44A 29 01                    ).
        bne     LA46F                           ; A44C D0 21                    .!
        lda     L0000                           ; A44E A5 00                    ..
        sec                                     ; A450 38                       8
        sbc     $03A8                           ; A451 ED A8 03                 ...
        sta     L0000                           ; A454 85 00                    ..
        lda     $01                             ; A456 A5 01                    ..
        sbc     $03C0                           ; A458 ED C0 03                 ...
        sta     $01                             ; A45B 85 01                    ..
        lda     $02                             ; A45D A5 02                    ..
        sec                                     ; A45F 38                       8
        sbc     $03A8                           ; A460 ED A8 03                 ...
        sta     $02                             ; A463 85 02                    ..
        lda     $03                             ; A465 A5 03                    ..
        sbc     $03C0                           ; A467 ED C0 03                 ...
        sta     $03                             ; A46A 85 03                    ..
        jmp     LA48D                           ; A46C 4C 8D A4                 L..

; ----------------------------------------------------------------------------
LA46F:  lda     L0000                           ; A46F A5 00                    ..
        clc                                     ; A471 18                       .
        adc     $03A8                           ; A472 6D A8 03                 m..
        sta     L0000                           ; A475 85 00                    ..
        lda     $01                             ; A477 A5 01                    ..
        adc     $03C0                           ; A479 6D C0 03                 m..
        sta     $01                             ; A47C 85 01                    ..
        lda     $02                             ; A47E A5 02                    ..
        clc                                     ; A480 18                       .
        adc     $03A8                           ; A481 6D A8 03                 m..
        sta     $02                             ; A484 85 02                    ..
        lda     $03                             ; A486 A5 03                    ..
        adc     $03C0                           ; A488 6D C0 03                 m..
        sta     $03                             ; A48B 85 03                    ..
LA48D:  lda     $0468,x                         ; A48D BD 68 04                 .h.
        clc                                     ; A490 18                       .
        adc     L0000                           ; A491 65 00                    e.
        sta     $0468,x                         ; A493 9D 68 04                 .h.
        lda     $78                             ; A496 A5 78                    .x
        adc     $01                             ; A498 65 01                    e.
        sta     $78                             ; A49A 85 78                    .x
        lda     $0480,x                         ; A49C BD 80 04                 ...
        clc                                     ; A49F 18                       .
        adc     $02                             ; A4A0 65 02                    e.
LA4A2:  sta     $0480,x                         ; A4A2 9D 80 04                 ...
        lda     $79                             ; A4A5 A5 79                    .y
        adc     $03                             ; A4A7 65 03                    e.
        sta     $79                             ; A4A9 85 79                    .y
        rts                                     ; A4AB 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $42 — Wave Man stage jet ski: when touched in play,
; sound $F1, player state $0D (ride), clears the arena and weapon
; state, palette row from LA51B, player xvel $01.4C — then hands the
; player its position (sub $1D mount pose) and wipes itself.
; =============================================================================
        lda     $30                             ; A4AC A5 30                    .0
        bne     LA51A                           ; A4AE D0 6A                    .j
        lda     #$F1                            ; A4B0 A9 F1                    ..
        jsr     queue_sound                           ; A4B2 20 5D EC                  ].
        lda     #$0D                            ; A4B5 A9 0D                    ..
        sta     $30                             ; A4B7 85 30                    .0
        ldy     #$04                            ; A4B9 A0 04                    ..
LA4BB:  jsr     entity_wipe_y                           ; A4BB 20 FE F2                  ..
        dey                                     ; A4BE 88                       .
        bne     LA4BB                           ; A4BF D0 FA                    ..
        lda     #$00                            ; A4C1 A9 00                    ..
        sta     $32                             ; A4C3 85 32                    .2
        sta     $50                             ; A4C5 85 50                    .P
        sta     $38                             ; A4C7 85 38                    .8
        sta     $2E                             ; A4C9 85 2E                    ..
        lda     #$06                            ; A4CB A9 06                    ..
        sta     $ED                             ; A4CD 85 ED                    ..
        ldy     #$03                            ; A4CF A0 03                    ..
LA4D1:  lda     LA51B,y                         ; A4D1 B9 1B A5                 ...
        sta     $0610,y                         ; A4D4 99 10 06                 ...
        sta     $0630,y                         ; A4D7 99 30 06                 .0.
        dey                                     ; A4DA 88                       .
        bpl     LA4D1                           ; A4DB 10 F4                    ..
        sty     $18                             ; A4DD 84 18                    ..
        lda     #$4C                            ; A4DF A9 4C                    .L
        sta     $03A8                           ; A4E1 8D A8 03                 ...
        lda     #$01                            ; A4E4 A9 01                    ..
        sta     $03C0                           ; A4E6 8D C0 03                 ...
        lda     #$F3                            ; A4E9 A9 F3                    ..
        sta     $0588,x                         ; A4EB 9D 88 05                 ...
        lda     #$A4                            ; A4EE A9 A4                    ..
        sta     $05A0,x                         ; A4F0 9D A0 05                 ...
        jsr     entity_player_collide                           ; A4F3 20 87 EF                  ..
        bcs     LA51A                           ; A4F6 B0 22                    ."
        ldy     #$00                            ; A4F8 A0 00                    ..
        lda     #$1D                            ; A4FA A9 1D                    ..
        jsr     entity_init_subtype_y                           ; A4FC 20 E9 EA                  ..
        lda     $0330,x                         ; A4FF BD 30 03                 .0.
        sta     $0330                           ; A502 8D 30 03                 .0.
        lda     $0348,x                         ; A505 BD 48 03                 .H.
        sta     $0348                           ; A508 8D 48 03                 .H.
        lda     $0378,x                         ; A50B BD 78 03                 .x.
        sta     $0378                           ; A50E 8D 78 03                 .x.
        lda     $0390,x                         ; A511 BD 90 03                 ...
        sta     $0390                           ; A514 8D 90 03                 ...
        jsr     entity_wipe_x                           ; A517 20 C4 F2                  ..
LA51A:  rts                                     ; A51A 60                       `

; ----------------------------------------------------------------------------
LA51B:  .byte   $0F,$0F,$2C,$11                 ; A51B  jet-ski palette row
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $48 — camera-locked sprite (Star Man stage): pins its
; Y to the background ($0468 anchor - camera $FA).
; =============================================================================
        lda     $0378,x                         ; A51F BD 78 03
        sta     $0468,x                         ; A522 9D 68 04                 .h.
        lda     #$2F                            ; A525 A9 2F                    ./
        sta     $0588,x                         ; A527 9D 88 05                 ...
        lda     #$A5                            ; A52A A9 A5                    ..
        sta     $05A0,x                         ; A52C 9D A0 05                 ...
        lda     $0468,x                         ; A52F BD 68 04                 .h.
        sec                                     ; A532 38                       8
        sbc     $FA                             ; A533 E5 FA                    ..
        bcs     LA539                           ; A535 B0 02                    ..
        sbc     #$0F                            ; A537 E9 0F                    ..
LA539:  sta     $0378,x                         ; A539 9D 78 03                 .x.
        rts                                     ; A53C 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $4A — Proto castle 3 wall borer: clears the dynamic
; tile-override list ($06C0/$43), then follows the movement program at
; LA77D (duration/dir pairs, resumed at $0480; alternate start $26 off
; screen $0F), carving as it goes: each step stamps its metatile to
; tile $9C (LD8A2 + LA6BC, which also patches the collision row cache
; $0640 and the pending PPU queue $07D0 across screen seams via the
; LA7CF/LA7D8 index maps, forcing IRQ row redraw $1C=$FF) and appends
; a dynamic override record. LA6A3 retires the oldest record when the
; list is full. Program byte 0 ends the run (sub 0, PC $A5FD idle).
; =============================================================================
        lda     #$00                            ; A53D A9 00                    ..
        sta     L0043                           ; A53F 85 43                    .C
        ldy     #$3F                            ; A541 A0 3F                    .?
LA543:  sta     $06C0,y                         ; A543 99 C0 06                 ...
        dey                                     ; A546 88                       .
        bpl     LA543                           ; A547 10 FA                    ..
        lda     #$00                            ; A549 A9 00                    ..
        sta     $03D8,x                         ; A54B 9D D8 03                 ...
        sta     $03A8,x                         ; A54E 9D A8 03                 ...
        lda     #$10                            ; A551 A9 10                    ..
        sta     $03F0,x                         ; A553 9D F0 03                 ...
        sta     $03C0,x                         ; A556 9D C0 03                 ...
        lda     #$76                            ; A559 A9 76                    .v
        sta     $0588,x                         ; A55B 9D 88 05                 ...
        lda     #$A5                            ; A55E A9 A5                    ..
        sta     $05A0,x                         ; A560 9D A0 05                 ...
        lda     #$10                            ; A563 A9 10                    ..
        sta     $0468,x                         ; A565 9D 68 04                 .h.
        lda     $0348,x                         ; A568 BD 48 03                 .H.
        cmp     #$0F                            ; A56B C9 0F                    ..
        beq     LA5BE                           ; A56D F0 4F                    .O
        lda     #$26                            ; A56F A9 26                    .&
        sta     $0480,x                         ; A571 9D 80 04                 ...
        bne     LA5BE                           ; A574 D0 48                    .H
        lda     $0468,x                         ; A576 BD 68 04                 .h.
        bne     LA5E6                           ; A579 D0 6B                    .k
        sta     $0540,x                         ; A57B 9D 40 05                 .@.
        sta     $0570,x                         ; A57E 9D 70 05                 .p.
        lda     $0528,x                         ; A581 BD 28 05                 .(.
        and     #$FD                            ; A584 29 FD                    ).
        sta     $0528,x                         ; A586 9D 28 05                 .(.
        lda     #$10                            ; A589 A9 10                    ..
        sta     $0468,x                         ; A58B 9D 68 04                 .h.
        ldy     #$9C                            ; A58E A0 9C                    ..
        jsr     LD8A2                           ; A590 20 A2 D8                  ..
        jsr     LA6BC                           ; A593 20 BC A6                  ..
        ldy     L0043                           ; A596 A4 43                    .C
        lda     $0348,x                         ; A598 BD 48 03                 .H.
        sta     $06C0,y                         ; A59B 99 C0 06                 ...
        lda     $22                             ; A59E A5 22                    ."
        sta     $06C1,y                         ; A5A0 99 C1 06                 ...
        lda     L0010                           ; A5A3 A5 10                    ..
        sta     $06C2,y                         ; A5A5 99 C2 06                 ...
        lda     #$9C                            ; A5A8 A9 9C                    ..
        sta     $06C3,y                         ; A5AA 99 C3 06                 ...
        iny                                     ; A5AD C8                       .
        iny                                     ; A5AE C8                       .
        iny                                     ; A5AF C8                       .
        iny                                     ; A5B0 C8                       .
        sty     L0043                           ; A5B1 84 43                    .C
        jsr     entity_facing_dispatch                           ; A5B3 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A5B6 20 86 EA                  ..
        dec     $0498,x                         ; A5B9 DE 98 04                 ...
        bne     LA5E6                           ; A5BC D0 28                    .(
LA5BE:  ldy     $0480,x                         ; A5BE BC 80 04                 ...
        inc     $0480,x                         ; A5C1 FE 80 04                 ...
        inc     $0480,x                         ; A5C4 FE 80 04                 ...
        lda     LA77D,y                         ; A5C7 B9 7D A7                 .}.
        sta     $0498,x                         ; A5CA 9D 98 04                 ...
        lda     LA77E,y                         ; A5CD B9 7E A7                 .~.
        sta     $0420,x                         ; A5D0 9D 20 04                 . .
        bne     LA5E6                           ; A5D3 D0 11                    ..
        lda     #$00                            ; A5D5 A9 00                    ..
        jsr     entity_set_subtype                           ; A5D7 20 98 EA                  ..
        lda     #$FD                            ; A5DA A9 FD                    ..
        sta     $0588,x                         ; A5DC 9D 88 05                 ...
        lda     #$A5                            ; A5DF A9 A5                    ..
        sta     $05A0,x                         ; A5E1 9D A0 05                 ...
        bne     LA5FD                           ; A5E4 D0 17                    ..
LA5E6:  lda     $0540,x                         ; A5E6 BD 40 05                 .@.
        cmp     #$02                            ; A5E9 C9 02                    ..
        bne     LA5FA                           ; A5EB D0 0D                    ..
        lda     #$00                            ; A5ED A9 00                    ..
        sta     $0570,x                         ; A5EF 9D 70 05                 .p.
        lda     $0528,x                         ; A5F2 BD 28 05                 .(.
        ora     #$02                            ; A5F5 09 02                    ..
        sta     $0528,x                         ; A5F7 9D 28 05                 .(.
LA5FA:  dec     $0468,x                         ; A5FA DE 68 04                 .h.
LA5FD:  rts                                     ; A5FD 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $4B — second wall borer: waits $A0 frames, then runs
; the same carving engine stamping tile $00 (shares LA66B/LA6A3/LA6BC).
; =============================================================================
        inc     $0468,x                         ; A5FE FE 68 04                 .h.
        lda     $0468,x                         ; A601 BD 68 04                 .h.
        cmp     #$A0                            ; A604 C9 A0                    ..
        bne     LA5FD                           ; A606 D0 F5                    ..
        lda     #$00                            ; A608 A9 00                    ..
        sta     $0468,x                         ; A60A 9D 68 04                 .h.
        sta     $0480,x                         ; A60D 9D 80 04                 ...
        lda     #$00                            ; A610 A9 00                    ..
        sta     $03D8,x                         ; A612 9D D8 03                 ...
        sta     $03A8,x                         ; A615 9D A8 03                 ...
        lda     #$10                            ; A618 A9 10                    ..
        sta     $03F0,x                         ; A61A 9D F0 03                 ...
        sta     $03C0,x                         ; A61D 9D C0 03                 ...
        lda     #$46                            ; A620 A9 46                    .F
        sta     $0588,x                         ; A622 9D 88 05                 ...
        lda     #$A6                            ; A625 A9 A6                    ..
        sta     $05A0,x                         ; A627 9D A0 05                 ...
        lda     $0348,x                         ; A62A BD 48 03                 .H.
        cmp     #$0F                            ; A62D C9 0F                    ..
        beq     LA636                           ; A62F F0 05                    ..
        lda     #$26                            ; A631 A9 26                    .&
        sta     $0480,x                         ; A633 9D 80 04                 ...
LA636:  jsr     LA66B                           ; A636 20 6B A6                  k.
        lda     #$00                            ; A639 A9 00                    ..
        sta     $0468,x                         ; A63B 9D 68 04                 .h.
        inc     $0498,x                         ; A63E FE 98 04                 ...
        lda     #$F8                            ; A641 A9 F8                    ..
        sta     $0378,x                         ; A643 9D 78 03                 .x.
        lda     $0468,x                         ; A646 BD 68 04                 .h.
        bne     LA693                           ; A649 D0 48                    .H
        jsr     LA6A3                           ; A64B 20 A3 A6                  ..
        jsr     entity_facing_dispatch                           ; A64E 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A651 20 86 EA                  ..
        lda     #$B8                            ; A654 A9 B8                    ..
        jsr     entity_set_subtype                           ; A656 20 98 EA                  ..
        lda     #$10                            ; A659 A9 10                    ..
        sta     $0468,x                         ; A65B 9D 68 04                 .h.
        ldy     #$00                            ; A65E A0 00                    ..
        jsr     LD8A2                           ; A660 20 A2 D8                  ..
        jsr     LA6BC                           ; A663 20 BC A6                  ..
        dec     $0498,x                         ; A666 DE 98 04                 ...
        bne     LA693                           ; A669 D0 28                    .(
LA66B:  ldy     $0480,x                         ; A66B BC 80 04                 ...
        inc     $0480,x                         ; A66E FE 80 04                 ...
        inc     $0480,x                         ; A671 FE 80 04                 ...
        lda     LA77D,y                         ; A674 B9 7D A7                 .}.
        sta     $0498,x                         ; A677 9D 98 04                 ...
        lda     LA77E,y                         ; A67A B9 7E A7                 .~.
        sta     $0420,x                         ; A67D 9D 20 04                 . .
LA680:  bne     LA693                           ; A680 D0 11                    ..
        lda     #$00                            ; A682 A9 00                    ..
        jsr     entity_set_subtype                           ; A684 20 98 EA                  ..
        lda     #$BB                            ; A687 A9 BB                    ..
        sta     $0588,x                         ; A689 9D 88 05                 ...
        lda     #$A6                            ; A68C A9 A6                    ..
        sta     $05A0,x                         ; A68E 9D A0 05                 ...
        bne     LA6BB                           ; A691 D0 28                    .(
LA693:  lda     $0540,x                         ; A693 BD 40 05                 .@.
        cmp     #$02                            ; A696 C9 02                    ..
        bne     LA69F                           ; A698 D0 05                    ..
        lda     #$00                            ; A69A A9 00                    ..
        jsr     entity_set_subtype                           ; A69C 20 98 EA                  ..
LA69F:  dec     $0468,x                         ; A69F DE 68 04                 .h.
        rts                                     ; A6A2 60                       `

; ----------------------------------------------------------------------------
LA6A3:  lda     L0043                           ; A6A3 A5 43                    .C
        beq     LA6BB                           ; A6A5 F0 14                    ..
        ldy     #$00                            ; A6A7 A0 00                    ..
LA6A9:  lda     $06C4,y                         ; A6A9 B9 C4 06                 ...
        sta     $06C0,y                         ; A6AC 99 C0 06                 ...
        iny                                     ; A6AF C8                       .
        cpy     L0043                           ; A6B0 C4 43                    .C
        bne     LA6A9                           ; A6B2 D0 F5                    ..
        lda     L0043                           ; A6B4 A5 43                    .C
        sec                                     ; A6B6 38                       8
        sbc     #$04                            ; A6B7 E9 04                    ..
        sta     L0043                           ; A6B9 85 43                    .C
LA6BB:  rts                                     ; A6BB 60                       `

; ----------------------------------------------------------------------------
LA6BC:  sty     L0000                           ; A6BC 84 00                    ..
        ldy     $22                             ; A6BE A4 22                    ."
        lda     $0640,y                         ; A6C0 B9 40 06                 .@.
        pha                                     ; A6C3 48                       H
        ldy     L0000                           ; A6C4 A4 00                    ..
        jsr     LD806                           ; A6C6 20 06 D8                  ..
        ldy     $22                             ; A6C9 A4 22                    ."
        lda     $0640,y                         ; A6CB B9 40 06                 .@.
        sta     $03                             ; A6CE 85 03                    ..
        pla                                     ; A6D0 68                       h
        sta     $0640,y                         ; A6D1 99 40 06                 .@.
        lda     $FC                             ; A6D4 A5 FC                    ..
        lsr     a                               ; A6D6 4A                       J
        lsr     a                               ; A6D7 4A                       J
        lsr     a                               ; A6D8 4A                       J
        sta     L0000                           ; A6D9 85 00                    ..
        lda     $0330,x                         ; A6DB BD 30 03                 .0.
        and     #$F0                            ; A6DE 29 F0                    ).
        lsr     a                               ; A6E0 4A                       J
        lsr     a                               ; A6E1 4A                       J
        lsr     a                               ; A6E2 4A                       J
        sta     $01                             ; A6E3 85 01                    ..
        sec                                     ; A6E5 38                       8
        sbc     L0000                           ; A6E6 E5 00                    ..
        and     #$1F                            ; A6E8 29 1F                    ).
        sta     $02                             ; A6EA 85 02                    ..
        lda     $0348,x                         ; A6EC BD 48 03                 .H.
        sbc     $F9                             ; A6EF E5 F9                    ..
        beq     LA710                           ; A6F1 F0 1D                    ..
        bcc     LA6FF                           ; A6F3 90 0A                    ..
        cmp     #$01                            ; A6F5 C9 01                    ..
        bne     LA6BB                           ; A6F7 D0 C2                    ..
        lda     $02                             ; A6F9 A5 02                    ..
        bne     LA77C                           ; A6FB D0 7F                    ..
        beq     LA737                           ; A6FD F0 38                    .8
LA6FF:  inc     $01                             ; A6FF E6 01                    ..
        lda     $25                             ; A701 A5 25                    .%
        cmp     $01                             ; A703 C5 01                    ..
        bne     LA77C                           ; A705 D0 75                    .u
        lda     $0348,x                         ; A707 BD 48 03                 .H.
        cmp     $24                             ; A70A C5 24                    .$
        bne     LA77C                           ; A70C D0 6E                    .n
        beq     LA751                           ; A70E F0 41                    .A
LA710:  lda     $25                             ; A710 A5 25                    .%
        cmp     $01                             ; A712 C5 01                    ..
        bne     LA71D                           ; A714 D0 07                    ..
        lda     $0348,x                         ; A716 BD 48 03                 .H.
        cmp     $24                             ; A719 C5 24                    .$
        bne     LA751                           ; A71B D0 34                    .4
LA71D:  inc     $01                             ; A71D E6 01                    ..
        lda     $25                             ; A71F A5 25                    .%
        cmp     $01                             ; A721 C5 01                    ..
        bne     LA734                           ; A723 D0 0F                    ..
        lda     $0348,x                         ; A725 BD 48 03                 .H.
        cmp     $24                             ; A728 C5 24                    .$
        bne     LA77C                           ; A72A D0 50                    .P
        lda     $28                             ; A72C A5 28                    .(
        and     #$01                            ; A72E 29 01                    ).
        bne     LA76F                           ; A730 D0 3D                    .=
        beq     LA751                           ; A732 F0 1D                    ..
LA734:  jmp     LA76F                           ; A734 4C 6F A7                 Lo.

; ----------------------------------------------------------------------------
LA737:  ldy     #$00                            ; A737 A0 00                    ..
LA739:  ldx     LA7CF,y                         ; A739 BE CF A7                 ...
        lda     $07D0,x                         ; A73C BD D0 07                 ...
        sta     $07D0,y                         ; A73F 99 D0 07                 ...
        iny                                     ; A742 C8                       .
        cpy     #$09                            ; A743 C0 09                    ..
        bne     LA739                           ; A745 D0 F2                    ..
        lda     #$00                            ; A747 A9 00                    ..
        sta     $07D2                           ; A749 8D D2 07                 ...
        sta     $07D6                           ; A74C 8D D6 07                 ...
        beq     LA776                           ; A74F F0 25                    .%
LA751:  ldy     #$00                            ; A751 A0 00                    ..
LA753:  ldx     LA7D8,y                         ; A753 BE D8 A7                 ...
        lda     $07D0,x                         ; A756 BD D0 07                 ...
        sta     $07D0,y                         ; A759 99 D0 07                 ...
        iny                                     ; A75C C8                       .
        cpy     #$0D                            ; A75D C0 0D                    ..
        bne     LA753                           ; A75F D0 F2                    ..
        inc     $07D1                           ; A761 EE D1 07                 ...
        inc     $07D5                           ; A764 EE D5 07                 ...
        lda     #$00                            ; A767 A9 00                    ..
        sta     $07D2                           ; A769 8D D2 07                 ...
        sta     $07D6                           ; A76C 8D D6 07                 ...
LA76F:  ldy     $22                             ; A76F A4 22                    ."
        lda     $03                             ; A771 A5 03                    ..
        sta     $0640,y                         ; A773 99 40 06                 .@.
LA776:  lda     #$FF                            ; A776 A9 FF                    ..
        sta     $1C                             ; A778 85 1C                    ..
        ldx     $A6                             ; A77A A6 A6                    ..
LA77C:  rts                                     ; A77C 60                       `

; ----------------------------------------------------------------------------
; Wall-borer movement program: (duration, dir) pairs, 0 = end; then the
; PPU-queue index remap tables used at screen seams (LA737/LA751).
LA77D:  .byte   $02 ; A77D  program: duration
LA77E:  .byte   $08,$09,$01,$02,$08,$06,$01,$01 ; A77E  dir (interleaved pairs)
        .byte   $08,$05,$01,$03,$08,$02,$01,$02 ; A786
        .byte   $04,$0D,$01,$04,$04,$07,$01,$04 ; A78E
        .byte   $08,$02,$01,$04,$04,$07,$01,$04 ; A796
        .byte   $08,$0A,$01,$00,$00,$02,$08,$05 ; A79E
        .byte   $01,$02,$08,$08,$01,$02,$04,$03 ; A7A6
        .byte   $01,$01,$08,$02,$01,$03,$08,$03 ; A7AE
        .byte   $01,$02,$04,$04,$01,$02,$08,$02 ; A7B6
        .byte   $01,$01,$04,$01,$01,$03,$08,$03 ; A7BE
        .byte   $01,$02,$04,$01,$01,$07,$04,$00 ; A7C6
        .byte   $00 ; A7CE
LA7CF:  .byte   $00,$01,$02,$03,$05,$06,$07,$08 ; A7CF  queue remap A
        .byte   $0E ; A7D7
LA7D8:  .byte   $00,$01,$02,$04,$05,$06,$07,$09 ; A7D8  queue remap B
        .byte   $0A,$0B,$0C,$0D,$0E ; A7E0
        .byte   $F7,$FF,$D5,$3F,$F7,$BB,$59,$EF ; A7E5  (unreferenced tail)
        .byte   $15,$F7,$7D,$AF,$35,$4F,$75,$7E ; A7ED
        .byte   $D7,$F7,$C6,$BD,$E7,$FF,$72,$FB ; A7F5
        .byte   $24,$FB,$34 ; A7FD
; --- $A800: DAMAGE TABLE, weapon $5 (Super Arrow) ---
; $A800[ent_type] via damage_engine $1C:809D; low 7 bits = damage,
; bit 7 = special handling; $00 = ricochet. Types $00-$CF.
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A800  types $00-$0F
        .byte   $02,$03,$01,$01,$01,$01,$01,$02,$02,$00,$01,$03,$01,$01,$00,$00 ; A810  types $10-$1F
        .byte   $03,$02,$00,$00,$00,$03,$00,$00,$03,$03,$01,$03,$00,$00,$00,$00 ; A820  types $20-$2F
        .byte   $00,$03,$01,$02,$01,$00,$02,$00,$00,$01,$03,$03,$00,$00,$03,$00 ; A830  types $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 ; A840  types $40-$4F
        .byte   $01,$00,$01,$01,$01,$00,$01,$00,$00,$03,$01,$00,$01,$02,$00,$00 ; A850  types $50-$5F
        .byte   $01,$00,$01,$01,$01,$01,$02,$01,$01,$01,$00,$01,$00,$00,$01,$00 ; A860  types $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$00,$00,$00 ; A870  types $70-$7F
        .byte   $00,$01,$00,$01,$00,$00,$01,$00,$00,$01,$00,$00,$00,$01,$00,$00 ; A880  types $80-$8F
        .byte   $00,$02,$00,$02,$00,$00,$01,$00,$01,$00,$00,$00,$01,$00,$01,$00 ; A890  types $90-$9F
        .byte   $01,$00,$00,$00,$00,$04,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00 ; A8A0  types $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$02,$00 ; A8B0  types $B0-$BF
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8C0  types $C0-$CF
; --- $A8D0: remainder (beyond type $CF) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8F0

; =============================================================================
; CHARGE MAN STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $A900: screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; A900  screens $00-$0F
        .byte   $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$00,$A0,$45 ; A910  screens $10-$1F
        .byte   $00,$00,$80,$00,$20,$04,$80,$10,$02,$A0,$80,$44,$28,$64,$0A,$00 ; A920  screens $20-$2F
        .byte   $00,$00,$20,$80,$20,$42,$00,$C4,$00,$00,$00,$00,$80,$34,$20,$80 ; A930  screens $30-$3F
        .byte   $00,$0A,$00,$18,$08,$00,$00,$02,$00,$00,$00,$01,$00,$00,$00,$40 ; A940  screens $40-$4F
; --- $A950: section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $23,$A0,$25,$67,$A0,$25,$60,$20,$20,$00,$2A,$20,$00,$80,$00,$02 ; A950
        .byte   $20,$00,$00,$04,$20,$0A,$80,$40 ; A960
; --- $A968: per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $38,$19,$0D,$21,$2D,$0E,$1A,$80,$B8,$00,$00,$72,$22,$19,$00,$00 ; A968
        .byte   $20,$98,$00,$22,$00,$10,$02,$10 ; A978
; --- $A980: BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $94,$96,$00,$00,$00,$01,$00,$50 ; A980
; --- $A988: BG palette (16 bytes) ---
        .byte   $0F,$20,$11,$01,$0F,$20,$10,$00,$0F,$23,$13,$03,$0F,$2B,$1B,$0B ; A988
; --- $A998: sprite palette-cycle seeds -> $05F0 slots ($A998-$A99B read) ---
        .byte   $00,$00,$00,$00,$0F,$20,$11,$01 ; A998
; --- $A9A0: unreferenced ---
        .byte   $0F,$20,$10,$00,$0F,$2A,$1A,$0A,$0F,$20,$27,$17,$00,$00,$00,$00 ; A9A0
        .byte   $0F,$20,$11,$01,$0F,$20,$10,$00,$0F,$26,$16,$06,$0F,$20,$27,$17 ; A9B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$02,$00,$00,$02,$00,$10 ; A9C0
        .byte   $00,$48,$80,$40,$00,$00,$00,$00,$88,$04,$80,$10,$20,$80,$20,$10 ; A9D0
; --- $A9E0: screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$00,$08,$00,$02,$44,$00,$44,$00,$00,$00,$08,$00,$02,$80,$08 ; A9E0  terminator / filler
        .byte   $00,$62,$02,$08,$00,$84,$20,$00,$80,$A0,$88,$00,$00,$00,$02 ; A9F0  
        .byte   $00                             ; A9FF  -1 base for the spawn arrays
; --- $AA00: spawn screens (ascending) ---
        .byte   $01,$02,$02,$03,$03,$03,$03,$03,$05,$05,$06,$07,$07,$07,$07,$08 ; AA00  entries $00-$0F
        .byte   $08,$09,$0A,$0A,$0A,$0C,$0C,$0D,$0D,$0E,$0E,$0F,$0F,$10,$10,$11 ; AA10  entries $10-$1F
        .byte   $11,$11,$11,$12,$12,$12,$12,$14,$14,$15,$16,$16,$16,$17,$17,$18 ; AA20  entries $20-$2F
        .byte   $19,$19,$19,$19,$1A,$1C,$FF,$40,$00,$00,$02,$90,$00,$44,$00,$85 ; AA30  entries $30-$3F
        .byte   $20,$10,$00,$01,$00,$10,$00,$00,$00,$44,$00,$40,$00,$10,$00,$80 ; AA40  entries $40-$4F
        .byte   $00,$41,$00,$14,$00,$40,$00,$10,$00,$05,$00,$00,$28,$40,$00,$04 ; AA50  entries $50-$5F
        .byte   $00,$44,$00,$00,$00,$81,$20,$09,$00,$02,$00,$80,$00,$10,$00,$40 ; AA60  entries $60-$6F
        .byte   $02,$00,$00,$88,$28,$24,$20,$04,$00,$00,$20,$20,$00,$4F,$28,$36 ; AA70  entries $70-$7F
; --- $AA80: spawn X px ---
        .byte   $50,$12,$92,$37,$38,$79,$F0,$F1,$80,$C0,$68,$10,$11,$C0,$C1,$70 ; AA80  entries $00-$0F
        .byte   $FF,$F0,$50,$D0,$F0,$30,$80,$01,$70,$40,$E0,$7C,$C0,$20,$80,$48 ; AA90  entries $10-$1F
        .byte   $49,$C8,$F0,$30,$40,$A0,$B8,$80,$F0,$90,$10,$90,$C0,$80,$C0,$40 ; AAA0  entries $20-$2F
        .byte   $30,$B0,$D0,$F0,$C0,$D8,$FF,$08,$20,$10,$00,$0E,$00,$00,$08,$20 ; AAB0  entries $30-$3F
        .byte   $00,$81,$00,$25,$02,$80,$00,$40,$08,$16,$00,$04,$08,$80,$02,$00 ; AAC0  entries $40-$4F
        .byte   $00,$64,$08,$80,$02,$08,$02,$00,$00,$02,$80,$38,$88,$0B,$02,$02 ; AAD0  entries $50-$5F
        .byte   $00,$10,$20,$12,$00,$00,$20,$00,$00,$14,$20,$06,$00,$02,$00,$00 ; AAE0  entries $60-$6F
        .byte   $00,$18,$20,$60,$88,$66,$80,$80,$88,$40,$00,$10,$0A,$08,$08,$41 ; AAF0  entries $70-$7F
; --- $AB00: spawn Y px ---
        .byte   $70,$78,$A0,$88,$A8,$A8,$68,$A8,$80,$A0,$80,$20,$40,$38,$D8,$B0 ; AB00  entries $00-$0F
        .byte   $90,$A0,$A0,$A0,$C0,$90,$5C,$7C,$80,$BC,$80,$7C,$9C,$9C,$70,$2A ; AB10  entries $10-$1F
        .byte   $BC,$9C,$2A,$4E,$BC,$9C,$2A,$80,$80,$70,$70,$70,$60,$A0,$90,$A0 ; AB20  entries $20-$2F
        .byte   $70,$70,$60,$C0,$B0,$00,$FF,$12,$00,$20,$08,$02,$20,$02,$08,$00 ; AB30  entries $30-$3F
        .byte   $00,$02,$00,$00,$20,$80,$00,$00,$20,$00,$00,$00,$00,$40,$20,$00 ; AB40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$C1,$00,$31,$00,$24,$00,$24,$20,$04,$00,$01 ; AB50  entries $50-$5F
        .byte   $00,$10,$02,$42,$00,$A0,$00,$00,$00,$40,$00,$44,$00,$04,$80,$05 ; AB60  entries $60-$6F
        .byte   $00,$10,$00,$44,$00,$00,$00,$00,$00,$02,$02,$10,$00,$02,$08,$D8 ; AB70  entries $70-$7F
; --- $AB80: spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $07,$07,$07,$07,$07,$07,$07,$07,$4D,$09,$09,$61,$61,$61,$61,$09 ; AB80  entries $00-$0F
        .byte   $09,$09,$09,$09,$40,$39,$05,$05,$39,$05,$39,$05,$05,$05,$39,$34 ; AB90  entries $10-$1F
        .byte   $05,$05,$34,$8D,$05,$05,$34,$4D,$09,$09,$09,$16,$16,$09,$09,$09 ; ABA0  entries $20-$2F
        .byte   $16,$16,$16,$40,$1B,$63,$FF,$42,$08,$01,$02,$08,$00,$00,$08,$58 ; ABB0  entries $30-$3F
        .byte   $00,$48,$A8,$04,$02,$00,$08,$12,$80,$02,$00,$02,$0A,$40,$80,$40 ; ABC0  entries $40-$4F
        .byte   $08,$08,$0A,$00,$00,$00,$20,$18,$08,$80,$80,$00,$00,$09,$02,$82 ; ABD0  entries $50-$5F
        .byte   $A2,$40,$20,$20,$00,$00,$00,$00,$20,$4C,$80,$40,$00,$00,$00,$90 ; ABE0  entries $60-$6F
        .byte   $00,$08,$08,$00,$00,$30,$88,$84,$00,$49,$88,$41,$20,$14,$80,$98 ; ABF0  entries $70-$7F
; --- $AC00: per-screen spawn-list start index ---
        .byte   $00,$00,$01,$03,$08,$08,$0A,$0B,$0F,$11,$12,$15,$15,$17,$19,$1B ; AC00  screens $00-$0F
        .byte   $1D,$1F,$23,$27,$27,$29,$2A,$2D,$2F,$30,$34,$35,$35,$00,$00,$00 ; AC10  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00 ; AC20  screens $20-$2F
        .byte   $00,$10,$80,$00,$00,$20,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00 ; AC30  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$80,$00,$00,$00 ; AC40  screens $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$10,$00,$00,$00,$00,$00 ; AC50  screens $50-$5F
        .byte   $00,$00,$00,$00,$10,$00,$00,$00,$00,$01,$00,$00,$08,$00,$00,$00 ; AC60  screens $60-$6F
        .byte   $00,$00,$00,$00,$04,$00,$00,$20,$10,$00,$00,$00,$00,$00,$A1,$00 ; AC70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10 ; AC80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00 ; AC90  screens $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACA0  screens $A0-$AF
        .byte   $00,$00,$00,$01,$00,$00,$00,$00,$00,$01,$10,$00,$00,$00,$10,$00 ; ACB0  screens $B0-$BF
        .byte   $00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00 ; ACC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$04,$00,$04,$20,$00 ; ACD0  screens $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$28,$00 ; ACE0  screens $E0-$EF
        .byte   $40,$00,$01,$04,$00,$44,$00,$00,$00,$00,$00,$00,$10,$00,$00,$40 ; ACF0  screens $F0-$FF
; --- $AD00: metatile top-left tile ids ---
        .byte   $00,$10,$01,$10,$10,$21,$FA,$9F,$10,$12,$60,$00,$84,$86,$87,$99 ; AD00  metatiles $00-$0F
        .byte   $F0,$F0,$00,$A2,$A4,$2D,$E2,$00,$60,$F2,$C0,$C5,$C4,$B5,$43,$D5 ; AD10  metatiles $10-$1F
        .byte   $06,$00,$8B,$E7,$AB,$E0,$E6,$E5,$06,$00,$43,$CD,$FA,$EB,$6E,$E2 ; AD20  metatiles $20-$2F
        .byte   $00,$D0,$C5,$C5,$C5,$C5,$F2,$F2,$00,$9D,$8F,$96,$98,$00,$E3,$E4 ; AD30  metatiles $30-$3F
        .byte   $8C,$8E,$26,$B7,$B7,$63,$2C,$2A,$89,$AF,$AF,$AF,$91,$EF,$63,$63 ; AD40  metatiles $40-$4F
        .byte   $00,$AF,$C6,$C8,$B8,$B9,$FD,$FD,$0F,$0C,$1E,$09,$E8,$00,$30,$30 ; AD50  metatiles $50-$5F
        .byte   $2F,$50,$DE,$09,$F8,$00,$2A,$2B,$43,$43,$41,$44,$00,$29,$2A,$2A ; AD60  metatiles $60-$6F
        .byte   $43,$50,$32,$32,$43,$00,$37,$2D,$2A,$00,$EE,$32,$44,$C5,$48,$80 ; AD70  metatiles $70-$7F
        .byte   $68,$68,$16,$40,$24,$7B,$76,$73,$43,$6A,$7B,$71,$49,$4A,$79,$78 ; AD80  metatiles $80-$8F
        .byte   $0A,$05,$04,$05,$3C,$3C,$39,$3A,$B2,$00,$00,$E3,$9F,$2A,$43,$AA ; AD90  metatiles $90-$9F
        .byte   $B3,$00,$65,$66,$43,$4A,$4A,$88,$60,$83,$B6,$00,$4C,$4E,$DA,$AE ; ADA0  metatiles $A0-$AF
        .byte   $60,$B0,$00,$4C,$4E,$99,$AC,$E5,$39,$43,$BD,$39,$3A,$3A,$E3,$E5 ; ADB0  metatiles $B0-$BF
        .byte   $63,$63,$83,$83,$63,$64,$64,$A0,$64,$64,$91,$93,$95,$00,$97,$2F ; ADC0  metatiles $C0-$CF
        .byte   $8A,$8C,$A1,$EE,$A6,$B8,$8E,$ED,$B6,$C6,$C0,$C0,$C0,$B8,$B8,$EC ; ADD0  metatiles $D0-$DF
        .byte   $BA,$BB,$F8,$D2,$D0,$B8,$E8,$D8,$E1,$E0,$B3,$A1,$A1,$FE,$32,$F6 ; ADE0  metatiles $E0-$EF
        .byte   $E1,$E0,$A8,$A8,$F7,$45,$6C,$68,$DE,$36,$36,$68,$BE,$57,$7C,$7F ; ADF0  metatiles $F0-$FF
; --- $AE00: metatile bottom-left tile ids ---
        .byte   $00,$10,$10,$02,$20,$10,$FD,$9F,$11,$10,$60,$00,$85,$87,$87,$99 ; AE00  metatiles $00-$0F
        .byte   $F0,$F1,$A1,$A3,$A5,$CB,$00,$00,$60,$F0,$C1,$C3,$C5,$43,$43,$D5 ; AE10  metatiles $10-$1F
        .byte   $06,$8A,$E0,$43,$AB,$E1,$E7,$E5,$06,$AA,$EB,$43,$FA,$F6,$CD,$E2 ; AE20  metatiles $20-$2F
        .byte   $00,$D1,$C5,$C5,$C5,$C5,$F3,$F3,$9C,$9E,$96,$97,$43,$00,$E3,$00 ; AE30  metatiles $30-$3F
        .byte   $8D,$8F,$26,$C6,$00,$63,$2A,$1C,$AF,$AF,$AF,$AF,$EF,$C2,$63,$63 ; AE40  metatiles $40-$4F
        .byte   $D3,$BD,$C7,$C6,$B9,$B8,$FD,$FE,$0F,$0D,$0C,$09,$E9,$00,$31,$31 ; AE50  metatiles $50-$5F
        .byte   $2F,$32,$DF,$09,$F9,$00,$2A,$2A,$43,$40,$42,$43,$C4,$37,$2A,$2B ; AE60  metatiles $60-$6F
        .byte   $43,$62,$32,$44,$43,$81,$47,$2D,$2A,$EA,$EF,$32,$43,$00,$48,$76 ; AE70  metatiles $70-$7F
        .byte   $68,$68,$68,$41,$25,$76,$72,$74,$43,$43,$76,$43,$4A,$4B,$79,$78 ; AE80  metatiles $80-$8F
        .byte   $0B,$0B,$0B,$03,$3C,$3D,$3A,$39,$FB,$FA,$A9,$E4,$9F,$07,$08,$AB ; AE90  metatiles $90-$9F
        .byte   $A1,$EC,$66,$67,$43,$4A,$4C,$BA,$82,$60,$B6,$00,$4D,$4F,$DB,$00 ; AEA0  metatiles $A0-$AF
        .byte   $A0,$60,$00,$4D,$4F,$B2,$AD,$E4,$43,$39,$CD,$3A,$3A,$39,$E4,$E4 ; AEB0  metatiles $B0-$BF
        .byte   $63,$63,$83,$83,$63,$64,$64,$A0,$64,$90,$92,$94,$64,$96,$00,$2F ; AEC0  metatiles $C0-$CF
        .byte   $8B,$8D,$A1,$EF,$A7,$B9,$8F,$EC,$B7,$D5,$B1,$C0,$C0,$B9,$B9,$FC ; AED0  metatiles $D0-$DF
        .byte   $BB,$BC,$F9,$D3,$D0,$D9,$E9,$B9,$E0,$E1,$A1,$C3,$A1,$32,$C7,$F6 ; AEE0  metatiles $E0-$EF
        .byte   $E0,$E1,$A8,$A9,$F6,$45,$68,$6C,$DF,$19,$19,$68,$BF,$57,$7D,$7C ; AEF0  metatiles $F0-$FF
; --- $AF00: metatile top-right tile ids ---
        .byte   $00,$10,$11,$02,$02,$11,$82,$90,$10,$10,$90,$92,$94,$F1,$88,$00 ; AF00  metatiles $00-$0F
        .byte   $10,$02,$00,$B2,$B4,$43,$F4,$90,$00,$11,$D0,$B3,$C5,$C5,$C5,$E5 ; AF10  metatiles $10-$1F
        .byte   $06,$00,$9B,$F7,$43,$F0,$F6,$E5,$BA,$8A,$43,$DD,$82,$FB,$FC,$F4 ; AF20  metatiles $20-$2F
        .byte   $00,$8D,$8F,$96,$97,$3F,$D2,$F2,$BB,$BD,$96,$97,$43,$D4,$F2,$00 ; AF30  metatiles $30-$3F
        .byte   $9C,$9E,$89,$F2,$00,$64,$3B,$3A,$00,$00,$00,$B7,$CC,$FF,$6B,$6B ; AF40  metatiles $40-$4F
        .byte   $00,$AF,$D6,$D8,$C9,$CA,$FD,$FD,$1F,$00,$3E,$09,$F8,$27,$30,$30 ; AF50  metatiles $50-$5F
        .byte   $2F,$51,$DE,$0E,$E8,$26,$3A,$3B,$43,$43,$32,$32,$00,$48,$1D,$3A ; AF60  metatiles $60-$6F
        .byte   $40,$51,$32,$32,$55,$00,$48,$43,$3A,$ED,$FE,$32,$32,$00,$6F,$00 ; AF70  metatiles $70-$7F
        .byte   $43,$69,$71,$33,$34,$18,$70,$75,$43,$6A,$18,$71,$59,$43,$7A,$78 ; AF80  metatiles $80-$8F
        .byte   $1A,$15,$14,$15,$58,$58,$39,$3A,$BD,$00,$00,$22,$00,$3A,$43,$AA ; AF90  metatiles $90-$9F
        .byte   $B3,$00,$65,$66,$43,$4A,$4A,$43,$00,$00,$58,$00,$5C,$5E,$AC,$AE ; AFA0  metatiles $A0-$AF
        .byte   $00,$00,$00,$5C,$5E,$AF,$AC,$E2,$65,$65,$BD,$39,$3A,$3A,$E6,$E7 ; AFB0  metatiles $B0-$BF
        .byte   $98,$98,$81,$82,$85,$86,$88,$B0,$00,$00,$00,$00,$00,$00,$97,$7E ; AFC0  metatiles $C0-$CF
        .byte   $9A,$9C,$A1,$FE,$32,$C8,$9E,$00,$9A,$F4,$C0,$C2,$C0,$B8,$DC,$00 ; AFD0  metatiles $D0-$DF
        .byte   $CA,$CA,$A1,$78,$78,$DC,$EA,$EA,$82,$82,$B3,$A1,$A1,$D4,$D6,$E6 ; AFE0  metatiles $E0-$EF
        .byte   $86,$88,$58,$58,$E7,$56,$7C,$7F,$DE,$36,$36,$36,$CE,$58,$7C,$7F ; AFF0  metatiles $F0-$FF
; --- $B000: metatile bottom-right tile ids ---
        .byte   $00,$10,$01,$12,$12,$01,$FD,$90,$10,$10,$90,$93,$95,$3F,$3F,$00 ; B000  metatiles $00-$0F
        .byte   $10,$12,$B1,$B3,$B5,$08,$00,$90,$00,$01,$D1,$B4,$C5,$C5,$C5,$E5 ; B010  metatiles $10-$1F
        .byte   $06,$9A,$F0,$43,$43,$EC,$F7,$E5,$BA,$8B,$FB,$43,$82,$FC,$DD,$F5 ; B020  metatiles $20-$2F
        .byte   $8C,$8E,$96,$96,$88,$88,$D2,$F3,$BC,$8F,$96,$98,$43,$00,$F3,$00 ; B030  metatiles $30-$3F
        .byte   $9D,$8F,$89,$F3,$00,$64,$3A,$3B,$00,$00,$B7,$00,$FF,$DC,$6B,$61 ; B040  metatiles $40-$4F
        .byte   $D3,$BD,$D7,$D9,$C9,$CA,$FD,$FE,$1F,$2E,$00,$09,$F9,$28,$31,$31 ; B050  metatiles $50-$5F
        .byte   $2F,$32,$DF,$0E,$E9,$27,$3A,$3A,$43,$52,$32,$53,$00,$48,$1D,$3B ; B060  metatiles $60-$6F
        .byte   $41,$32,$32,$54,$43,$81,$48,$43,$3A,$EE,$FF,$32,$53,$00,$46,$81 ; B070  metatiles $70-$7F
        .byte   $43,$43,$43,$34,$35,$70,$7A,$7A,$43,$43,$7A,$43,$5A,$5B,$7A,$78 ; B080  metatiles $80-$8F
        .byte   $1B,$1B,$1B,$13,$58,$58,$3A,$39,$CD,$82,$00,$22,$00,$17,$08,$AB ; B090  metatiles $90-$9F
        .byte   $A1,$00,$66,$67,$43,$4A,$4C,$43,$00,$00,$58,$00,$5D,$5F,$AD,$00 ; B0A0  metatiles $A0-$AF
        .byte   $00,$00,$00,$5D,$5F,$BD,$AD,$E6,$65,$65,$CD,$3A,$3A,$39,$E6,$E6 ; B0B0  metatiles $B0-$BF
        .byte   $98,$80,$82,$84,$98,$87,$89,$B0,$00,$00,$00,$00,$00,$96,$00,$7E ; B0C0  metatiles $C0-$CF
        .byte   $9B,$9D,$A1,$32,$C7,$C9,$9F,$00,$F3,$F5,$C1,$C0,$C0,$B9,$DD,$FD ; B0D0  metatiles $D0-$DF
        .byte   $CA,$CC,$A1,$D1,$78,$EA,$EB,$DD,$82,$82,$A1,$C3,$A1,$D6,$D7,$E6 ; B0E0  metatiles $E0-$EF
        .byte   $87,$89,$58,$58,$E6,$56,$7D,$7C,$DF,$19,$19,$19,$CF,$58,$7D,$7C ; B0F0  metatiles $F0-$FF
; --- $B100: metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$00 ; B100  metatiles $00-$0F
        .byte   $00,$00,$02,$02,$02,$11,$00,$00,$00,$00,$02,$02,$02,$02,$02,$00 ; B110  metatiles $10-$1F
        .byte   $00,$02,$02,$02,$02,$02,$02,$00,$00,$02,$02,$02,$00,$02,$02,$00 ; B120  metatiles $20-$2F
        .byte   $02,$02,$02,$02,$02,$02,$00,$00,$02,$02,$02,$02,$02,$00,$00,$00 ; B130  metatiles $30-$3F
        .byte   $02,$02,$00,$00,$00,$11,$11,$11,$02,$02,$02,$02,$11,$11,$11,$11 ; B140  metatiles $40-$4F
        .byte   $00,$02,$02,$02,$02,$02,$11,$11,$11,$11,$11,$03,$03,$01,$41,$21 ; B150  metatiles $50-$5F
        .byte   $11,$00,$03,$03,$03,$01,$11,$11,$00,$00,$00,$00,$11,$11,$11,$11 ; B160  metatiles $60-$6F
        .byte   $00,$00,$00,$00,$00,$01,$11,$01,$11,$00,$00,$00,$00,$11,$11,$01 ; B170  metatiles $70-$7F
        .byte   $02,$02,$02,$00,$00,$01,$01,$01,$02,$02,$01,$02,$13,$13,$01,$01 ; B180  metatiles $80-$8F
        .byte   $13,$13,$13,$13,$13,$13,$11,$11,$02,$00,$01,$13,$00,$11,$11,$02 ; B190  metatiles $90-$9F
        .byte   $02,$00,$12,$12,$01,$13,$13,$02,$00,$00,$03,$00,$02,$02,$00,$00 ; B1A0  metatiles $A0-$AF
        .byte   $00,$00,$00,$03,$03,$02,$00,$13,$03,$03,$02,$03,$03,$03,$13,$13 ; B1B0  metatiles $B0-$BF
        .byte   $11,$11,$11,$11,$11,$11,$11,$00,$11,$11,$11,$11,$11,$11,$11,$11 ; B1C0  metatiles $C0-$CF
        .byte   $13,$13,$02,$02,$02,$11,$F1,$00,$13,$13,$02,$02,$02,$11,$11,$00 ; B1D0  metatiles $D0-$DF
        .byte   $13,$13,$02,$02,$02,$11,$11,$11,$11,$11,$02,$02,$02,$02,$02,$13 ; B1E0  metatiles $E0-$EF
        .byte   $11,$11,$13,$13,$13,$13,$12,$12,$01,$02,$11,$12,$11,$13,$12,$12 ; B1F0  metatiles $F0-$FF
; --- $B200: 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $02,$01,$08,$02,$20,$37,$28,$36,$00,$50,$3D,$79,$50,$50,$50,$50 ; B200  blocks $00-$03
        .byte   $00,$00,$00,$00,$00,$00,$0B,$0C,$00,$00,$0D,$0E,$00,$00,$0E,$0E ; B210  blocks $04-$07
        .byte   $01,$03,$03,$09,$20,$3E,$28,$1F,$3F,$00,$1F,$00,$50,$00,$79,$00 ; B220  blocks $08-$0B
        .byte   $00,$12,$00,$1A,$13,$14,$1B,$1C,$88,$88,$1D,$1E,$88,$88,$1E,$1E ; B230  blocks $0C-$0F
        .byte   $09,$01,$01,$01,$20,$27,$28,$2F,$27,$00,$2F,$16,$21,$22,$29,$2A ; B240  blocks $10-$13
        .byte   $23,$88,$2B,$88,$25,$26,$2D,$2E,$F9,$88,$F9,$88,$01,$01,$01,$01 ; B250  blocks $14-$17
        .byte   $20,$43,$28,$37,$44,$00,$00,$00,$00,$30,$00,$38,$31,$32,$39,$3A ; B260  blocks $18-$1B
        .byte   $33,$34,$3B,$3C,$35,$35,$88,$88,$20,$37,$20,$37,$AE,$AE,$B6,$B6 ; B270  blocks $1C-$1F
        .byte   $AF,$40,$AF,$48,$41,$3B,$49,$49,$3C,$88,$4A,$4B,$88,$88,$49,$49 ; B280  blocks $20-$23
        .byte   $88,$88,$4A,$4B,$0A,$0A,$0F,$0F,$07,$17,$0F,$0F,$17,$17,$0F,$0F ; B290  blocks $24-$27
        .byte   $17,$00,$0F,$0F,$52,$53,$0F,$0F,$54,$55,$0F,$0F,$4E,$4F,$4C,$4D ; B2A0  blocks $28-$2B
        .byte   $4E,$4F,$56,$57,$45,$45,$96,$97,$45,$45,$77,$15,$56,$57,$56,$57 ; B2B0  blocks $2C-$2F
        .byte   $96,$97,$96,$97,$FA,$FC,$FA,$9E,$5C,$5B,$64,$5B,$5B,$5B,$5B,$5B ; B2C0  blocks $30-$33
        .byte   $5B,$5C,$5B,$64,$B3,$B4,$5B,$5B,$62,$5B,$62,$5B,$5B,$62,$5B,$62 ; B2D0  blocks $34-$37
        .byte   $5C,$AA,$64,$24,$AA,$AA,$24,$24,$AA,$5C,$24,$64,$62,$88,$62,$49 ; B2E0  blocks $38-$3B
        .byte   $88,$62,$49,$62,$00,$00,$0F,$0F,$62,$55,$62,$0F,$00,$62,$0F,$62 ; B2F0  blocks $3C-$3F
        .byte   $62,$5B,$62,$AA,$5B,$5B,$AA,$AA,$5B,$62,$AA,$62,$00,$5F,$0E,$5F ; B300  blocks $40-$43
        .byte   $60,$60,$60,$60,$88,$5F,$1E,$5F,$88,$5F,$88,$5F,$35,$5F,$88,$5F ; B310  blocks $44-$47
        .byte   $88,$5F,$4A,$5F,$52,$5F,$0F,$5F,$01,$08,$01,$01,$28,$68,$20,$68 ; B320  blocks $48-$4B
        .byte   $68,$68,$68,$68,$01,$04,$03,$09,$05,$01,$08,$02,$28,$7F,$20,$75 ; B330  blocks $4C-$4F
        .byte   $86,$87,$8F,$8F,$85,$86,$8F,$8F,$01,$03,$03,$01,$28,$75,$20,$75 ; B340  blocks $50-$53
        .byte   $8F,$8F,$8F,$8F,$28,$75,$20,$00,$8F,$8F,$8E,$8E,$28,$00,$20,$00 ; B350  blocks $54-$57
        .byte   $02,$03,$04,$02,$00,$00,$00,$5E,$00,$00,$58,$58,$B1,$A8,$00,$00 ; B360  blocks $58-$5B
        .byte   $A9,$B0,$00,$00,$B1,$18,$00,$00,$18,$A8,$00,$00,$9C,$00,$00,$00 ; B370  blocks $5C-$5F
        .byte   $00,$5F,$00,$5F,$83,$84,$68,$68,$68,$68,$69,$6A,$68,$68,$6B,$68 ; B380  blocks $60-$63
        .byte   $68,$68,$83,$84,$68,$70,$70,$61,$71,$72,$7B,$7B,$73,$74,$7B,$7C ; B390  blocks $64-$67
        .byte   $8A,$8A,$8F,$8F,$87,$85,$8F,$8F,$00,$00,$46,$6F,$00,$00,$6E,$6E ; B3A0  blocks $68-$6B
        .byte   $00,$00,$67,$6F,$00,$00,$67,$47,$00,$8C,$00,$94,$96,$97,$F6,$F7 ; B3B0  blocks $6C-$6F
        .byte   $77,$77,$80,$80,$96,$97,$80,$80,$7E,$7E,$82,$81,$7E,$7E,$81,$81 ; B3C0  blocks $70-$73
        .byte   $FE,$FF,$FE,$FF,$AC,$AD,$88,$88,$88,$88,$88,$88,$A2,$A3,$A2,$A3 ; B3D0  blocks $74-$77
        .byte   $8B,$89,$8B,$89,$89,$89,$89,$89,$8F,$8F,$90,$92,$8F,$8F,$92,$93 ; B3E0  blocks $78-$7B
        .byte   $8F,$8F,$90,$91,$8F,$8F,$92,$91,$90,$92,$92,$92,$92,$91,$92,$91 ; B3F0  blocks $7C-$7F
        .byte   $92,$93,$92,$93,$8D,$8C,$95,$94,$8D,$F5,$95,$FD,$F5,$F5,$FD,$FD ; B400  blocks $80-$83
        .byte   $4C,$4D,$81,$81,$7E,$7E,$81,$82,$7E,$7E,$80,$80,$89,$8B,$89,$8B ; B410  blocks $84-$87
        .byte   $8C,$8D,$94,$95,$00,$00,$65,$5D,$67,$6F,$80,$80,$6D,$76,$80,$80 ; B420  blocks $88-$8B
        .byte   $67,$47,$96,$97,$46,$6F,$96,$97,$6E,$6E,$77,$77,$67,$6F,$96,$97 ; B430  blocks $8C-$8F
        .byte   $A4,$A4,$80,$80,$66,$9D,$FA,$FC,$00,$00,$66,$9D,$FA,$9E,$FB,$80 ; B440  blocks $90-$93
        .byte   $45,$D5,$45,$D5,$D5,$45,$D5,$C2,$45,$45,$C2,$C2,$45,$45,$E8,$E9 ; B450  blocks $94-$97
        .byte   $D5,$DA,$D5,$E4,$DB,$DA,$E3,$E4,$DB,$DA,$E4,$E4,$DA,$DA,$E3,$E4 ; B460  blocks $98-$9B
        .byte   $D5,$A0,$D5,$A0,$B5,$98,$51,$BA,$D3,$D4,$ED,$EE,$EB,$EC,$EB,$EC ; B470  blocks $9C-$9F
        .byte   $D2,$D2,$14,$D2,$D5,$A0,$DE,$A0,$51,$BA,$51,$BA,$E2,$E2,$9F,$9F ; B480  blocks $A0-$A3
        .byte   $2C,$2C,$D7,$DF,$2C,$A0,$00,$A0,$9F,$9F,$9F,$9F,$F1,$59,$00,$6C ; B490  blocks $A4-$A7
        .byte   $5A,$F0,$7D,$00,$F1,$C4,$00,$CC,$C1,$C2,$C9,$CA,$C2,$C4,$CB,$CC ; B4A0  blocks $A8-$AB
        .byte   $C0,$C0,$C5,$C6,$C7,$C7,$00,$00,$CD,$CE,$CD,$CE,$DA,$DA,$E4,$E4 ; B4B0  blocks $AC-$AF
        .byte   $D2,$D2,$D2,$D2,$D0,$D1,$D8,$D9,$EB,$EC,$D0,$D1,$8C,$8D,$E0,$E1 ; B4C0  blocks $B0-$B3
        .byte   $D8,$D9,$D0,$D1,$9B,$B7,$EF,$F4,$E0,$E1,$94,$94,$D8,$D9,$F2,$F2 ; B4D0  blocks $B4-$B7
        .byte   $BF,$BF,$F4,$F4,$45,$D5,$C2,$D5,$DA,$D5,$E4,$D5,$EB,$D5,$EB,$D5 ; B4E0  blocks $B8-$BB
        .byte   $EB,$D5,$EB,$E5,$CF,$CF,$E6,$E6,$E0,$E1,$94,$95,$D8,$D9,$F2,$F3 ; B4F0  blocks $BC-$BF
        .byte   $EB,$99,$EB,$A1,$2C,$2C,$DF,$D7,$C1,$F0,$C9,$00,$EB,$B5,$EB,$51 ; B500  blocks $C0-$C3
        .byte   $EB,$51,$EB,$51,$D5,$A0,$E7,$A0,$E2,$E2,$90,$91,$EB,$B5,$92,$92 ; B510  blocks $C4-$C7
        .byte   $51,$BA,$90,$91,$51,$BA,$91,$91,$90,$91,$91,$91,$92,$92,$92,$92 ; B520  blocks $C8-$CB
        .byte   $98,$EC,$BA,$EC,$BA,$EC,$BA,$EC,$98,$EC,$91,$91,$D2,$D2,$92,$91 ; B530  blocks $CC-$CF
        .byte   $91,$91,$91,$91,$06,$2C,$DF,$D7,$C0,$C0,$C8,$C8,$51,$8C,$51,$94 ; B540  blocks $D0-$D3
        .byte   $8D,$8D,$95,$95,$45,$5F,$C2,$5F,$DB,$DB,$E3,$E3,$DA,$5F,$E4,$5F ; B550  blocks $D4-$D7
        .byte   $EB,$5F,$EB,$5F,$D6,$D6,$45,$45,$D6,$D6,$67,$6F,$D6,$00,$6F,$00 ; B560  blocks $D8-$DB
        .byte   $77,$15,$FA,$FC,$97,$00,$97,$00,$FA,$9E,$FA,$9E,$97,$5E,$97,$5F ; B570  blocks $DC-$DF
        .byte   $8F,$8F,$46,$6F,$8F,$8F,$6E,$6E,$8F,$8F,$67,$6F,$65,$5D,$6D,$76 ; B580  blocks $E0-$E3
        .byte   $8F,$8F,$8C,$8D,$E0,$E1,$E0,$E1,$90,$91,$90,$91,$D5,$00,$D5,$00 ; B590  blocks $E4-$E7
        .byte   $D5,$DA,$DE,$E4,$00,$A0,$00,$A0,$EC,$EC,$EC,$EC,$D5,$F5,$D5,$FD ; B5A0  blocks $E8-$EB
        .byte   $99,$2C,$A1,$DF,$E5,$E6,$EB,$F8,$EB,$F8,$EB,$F8,$00,$00,$90,$91 ; B5B0  blocks $EC-$EF
        .byte   $00,$00,$92,$91,$00,$00,$92,$93,$E6,$E6,$10,$10,$E6,$E6,$10,$F8 ; B5C0  blocks $F0-$F3
        .byte   $01,$F8,$01,$F8,$D5,$10,$D5,$01,$19,$10,$08,$02,$10,$10,$01,$01 ; B5D0  blocks $F4-$F7
        .byte   $10,$11,$03,$09,$10,$D5,$01,$D5,$D5,$01,$D5,$01,$01,$D5,$03,$D5 ; B5E0  blocks $F8-$FB
        .byte   $05,$D5,$08,$D5,$E7,$01,$10,$02,$01,$D5,$01,$D5,$00,$00,$00,$00 ; B5F0  blocks $FC-$FF
; --- $B600: screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; B600
        .byte   $10,$11,$12,$04,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1D ; B610
        .byte   $00,$1E,$1F,$20,$21,$22,$23,$24,$25,$26,$27,$27,$28,$29,$2A,$29 ; B620
        .byte   $2B,$2C,$2D,$2E,$2D,$2E,$2D,$2E,$2F,$2F,$30,$31,$30,$31,$30,$31 ; B630
; layout $01
        .byte   $07,$32,$33,$33,$33,$34,$32,$33,$0F,$32,$33,$35,$33,$34,$32,$33 ; B640
        .byte   $15,$36,$33,$33,$33,$37,$36,$33,$1D,$38,$39,$39,$39,$3A,$32,$33 ; B650
        .byte   $23,$3B,$24,$23,$24,$3C,$36,$33,$3D,$3E,$29,$2A,$29,$3F,$40,$41 ; B660
        .byte   $2D,$2C,$2B,$2C,$2D,$2E,$2D,$2E,$30,$2F,$2F,$2F,$30,$31,$30,$31 ; B670
; layout $02
        .byte   $33,$33,$34,$32,$33,$33,$33,$34,$33,$33,$34,$32,$33,$33,$33,$34 ; B680
        .byte   $33,$33,$37,$36,$33,$33,$33,$37,$33,$33,$34,$32,$33,$33,$33,$34 ; B690
        .byte   $35,$33,$37,$36,$33,$35,$33,$37,$41,$41,$42,$40,$41,$41,$41,$42 ; B6A0
        .byte   $2D,$2E,$2D,$2C,$2B,$2C,$2C,$2B,$30,$31,$30,$2F,$2F,$2F,$2F,$2F ; B6B0
; layout $03
        .byte   $32,$33,$33,$33,$34,$07,$43,$44,$32,$33,$35,$33,$34,$0F,$45,$44 ; B6C0
        .byte   $36,$33,$33,$33,$37,$15,$46,$44,$38,$39,$39,$39,$3A,$1D,$47,$44 ; B6D0
        .byte   $3B,$24,$23,$24,$3C,$24,$48,$44,$3E,$29,$2A,$29,$3F,$29,$49,$44 ; B6E0
        .byte   $2C,$2C,$2D,$2E,$2D,$2E,$2D,$2E,$2F,$2F,$30,$31,$30,$31,$30,$31 ; B6F0
; layout $04
        .byte   $10,$4A,$00,$08,$10,$4B,$4C,$4C,$17,$17,$4D,$4E,$17,$4B,$4C,$4C ; B700
        .byte   $00,$08,$10,$4A,$00,$4F,$50,$51,$52,$00,$17,$17,$52,$53,$54,$54 ; B710
        .byte   $10,$4A,$00,$08,$10,$55,$56,$56,$00,$17,$4D,$4E,$17,$57,$04,$04 ; B720
        .byte   $4A,$58,$10,$4A,$58,$57,$59,$5A,$5B,$5C,$5D,$5E,$5C,$5F,$60,$44 ; B730
; layout $05
        .byte   $61,$62,$63,$4C,$64,$4C,$4C,$4C,$65,$66,$67,$4C,$62,$63,$61,$4C ; B740
        .byte   $50,$50,$51,$68,$51,$68,$51,$69,$54,$54,$54,$54,$54,$54,$54,$54 ; B750
        .byte   $56,$56,$56,$56,$56,$56,$56,$56,$04,$6A,$6B,$6C,$6B,$6D,$04,$6E ; B760
        .byte   $5A,$6F,$70,$71,$70,$71,$72,$73,$44,$74,$75,$76,$77,$77,$78,$79 ; B770
; layout $06
        .byte   $61,$62,$63,$4C,$64,$4C,$4C,$4C,$65,$66,$67,$4C,$62,$63,$61,$4C ; B780
        .byte   $51,$50,$51,$68,$51,$68,$51,$69,$54,$54,$54,$54,$7A,$7B,$54,$54 ; B790
        .byte   $56,$56,$7C,$7D,$7E,$7F,$7F,$80,$81,$82,$83,$83,$83,$83,$83,$83 ; B7A0
        .byte   $84,$73,$73,$85,$86,$86,$72,$84,$79,$79,$79,$87,$16,$75,$78,$79 ; B7B0
; layout $07
        .byte   $61,$62,$63,$4C,$64,$4C,$4C,$4C,$65,$66,$67,$4C,$62,$63,$61,$4C ; B7C0
        .byte   $51,$50,$51,$68,$51,$68,$51,$69,$54,$54,$54,$54,$54,$54,$54,$54 ; B7D0
        .byte   $56,$56,$56,$56,$56,$56,$56,$56,$88,$88,$88,$04,$89,$89,$04,$04 ; B7E0
        .byte   $73,$73,$85,$8A,$8B,$8B,$8C,$5A,$79,$79,$87,$77,$75,$77,$30,$44 ; B7F0
; layout $08
        .byte   $61,$62,$63,$4C,$64,$4C,$4C,$4C,$65,$66,$67,$4C,$62,$63,$61,$4C ; B800
        .byte   $51,$50,$51,$68,$51,$68,$51,$69,$54,$54,$54,$54,$54,$54,$54,$54 ; B810
        .byte   $56,$56,$56,$56,$56,$56,$56,$56,$04,$04,$89,$89,$89,$8D,$8E,$8F ; B820
        .byte   $5A,$8D,$8B,$8B,$8B,$6F,$90,$6F,$44,$30,$76,$75,$76,$74,$77,$74 ; B830
; layout $09
        .byte   $61,$62,$63,$4C,$64,$4C,$4C,$4C,$65,$66,$67,$4C,$62,$63,$61,$4C ; B840
        .byte   $51,$50,$51,$68,$51,$68,$51,$69,$54,$54,$54,$54,$54,$54,$54,$54 ; B850
        .byte   $56,$56,$56,$56,$56,$56,$56,$56,$91,$91,$8C,$89,$89,$6A,$92,$6B ; B860
        .byte   $93,$93,$71,$8B,$8B,$6F,$93,$70,$16,$16,$77,$77,$76,$74,$16,$76 ; B870
; layout $0A
        .byte   $61,$62,$63,$4C,$64,$4C,$4C,$4C,$65,$66,$67,$4C,$62,$63,$61,$4C ; B880
        .byte   $51,$50,$51,$68,$51,$68,$51,$69,$54,$54,$54,$54,$54,$54,$54,$54 ; B890
        .byte   $56,$56,$56,$56,$56,$56,$56,$56,$6C,$92,$6D,$89,$89,$89,$6C,$04 ; B8A0
        .byte   $6F,$93,$71,$8B,$8B,$8B,$30,$04,$74,$16,$77,$77,$75,$76,$30,$04 ; B8B0
; layout $0B
        .byte   $94,$04,$95,$96,$97,$97,$97,$97,$94,$04,$98,$99,$9A,$9B,$9B,$9A ; B8C0
        .byte   $94,$04,$9C,$9D,$9E,$9F,$9F,$9E,$94,$04,$9C,$9D,$A0,$9F,$9F,$A0 ; B8D0
        .byte   $94,$04,$A1,$A2,$A3,$9F,$9F,$A3,$94,$A4,$A5,$9D,$A6,$9F,$9F,$A6 ; B8E0
        .byte   $94,$A7,$A8,$A9,$AA,$AB,$AC,$AA,$94,$AD,$AD,$AD,$AD,$AD,$AE,$AD ; B8F0
; layout $0C
        .byte   $96,$96,$97,$97,$97,$97,$96,$96,$AF,$AF,$9A,$9B,$9B,$AF,$AF,$AF ; B900
        .byte   $9D,$9D,$9E,$9F,$9F,$9E,$9D,$9D,$9D,$A2,$B0,$B1,$B1,$B2,$9D,$A2 ; B910
        .byte   $A2,$9D,$B3,$B4,$B4,$B4,$A2,$B5,$9D,$B5,$B6,$B7,$B7,$B7,$B5,$B8 ; B920
        .byte   $AB,$AC,$AA,$AB,$AC,$AA,$AB,$AC,$AD,$AE,$AD,$AD,$AE,$AD,$AD,$AE ; B930
; layout $0D
        .byte   $96,$97,$97,$97,$97,$96,$B9,$44,$AF,$99,$9B,$9B,$99,$AF,$BA,$44 ; B940
        .byte   $9E,$9F,$9F,$9E,$9F,$9D,$BB,$44,$B0,$9F,$9F,$9F,$9F,$9D,$BB,$44 ; B950
        .byte   $B3,$B2,$B2,$B2,$9F,$A2,$BC,$BD,$BE,$BF,$BF,$BF,$9F,$9D,$C0,$C1 ; B960
        .byte   $AA,$AB,$AC,$AA,$AB,$AC,$C2,$A7,$AD,$AD,$AE,$AD,$AD,$AE,$AD,$AD ; B970
; layout $0E
        .byte   $44,$95,$96,$97,$97,$97,$97,$96,$44,$98,$99,$99,$AF,$AF,$99,$99 ; B980
        .byte   $44,$9C,$9F,$9E,$9D,$9D,$9E,$C3,$44,$9C,$9F,$A0,$9D,$A2,$B0,$C4 ; B990
        .byte   $BD,$C5,$9F,$A3,$A2,$9D,$C6,$C7,$A4,$A5,$9F,$A6,$C8,$C9,$CA,$CB ; B9A0
        .byte   $A8,$A9,$AC,$AA,$AB,$AC,$AA,$AB,$AD,$AD,$AE,$AD,$AD,$AE,$AD,$AD ; B9B0
; layout $0F
        .byte   $96,$97,$97,$97,$97,$96,$96,$97,$99,$99,$AF,$AF,$9A,$99,$99,$99 ; B9C0
        .byte   $CC,$9E,$9D,$9D,$9E,$9F,$9F,$9E,$CD,$A0,$9D,$A2,$B0,$9F,$9F,$A0 ; B9D0
        .byte   $CE,$CF,$7E,$80,$A6,$9F,$9F,$A3,$D0,$7F,$CB,$7F,$7F,$80,$B5,$B8 ; B9E0
        .byte   $AC,$AA,$AB,$AC,$AA,$AB,$AC,$AA,$AE,$AD,$AD,$AE,$AD,$AD,$AE,$AD ; B9F0
; layout $10
        .byte   $97,$97,$97,$96,$96,$96,$B9,$44,$AF,$AF,$9A,$99,$99,$AF,$BA,$44 ; BA00
        .byte   $9D,$9D,$9E,$9F,$9F,$9D,$BB,$44,$9D,$A2,$B0,$9F,$9F,$9D,$BB,$44 ; BA10
        .byte   $A2,$9D,$B0,$B1,$B1,$A2,$BC,$BD,$B8,$B8,$B8,$BF,$BF,$A2,$C0,$D1 ; BA20
        .byte   $AB,$AC,$AA,$AB,$AC,$D2,$C2,$A7,$AD,$AE,$AD,$AD,$AE,$AD,$AD,$AD ; BA30
; layout $11
        .byte   $44,$95,$96,$97,$97,$97,$97,$96,$44,$98,$99,$99,$AF,$AF,$AF,$AF ; BA40
        .byte   $44,$9C,$9D,$9E,$9D,$9D,$9E,$9D,$44,$9C,$9D,$B0,$9D,$A2,$A2,$9D ; BA50
        .byte   $BD,$C5,$A2,$A3,$A2,$9D,$9D,$A2,$A4,$A5,$9D,$A6,$D3,$D4,$88,$88 ; BA60
        .byte   $A8,$A9,$AC,$AA,$AB,$AC,$AA,$AB,$AD,$AD,$AE,$AD,$AD,$AE,$AD,$AD ; BA70
; layout $12
        .byte   $96,$97,$97,$97,$97,$96,$D5,$44,$AF,$99,$99,$AF,$99,$D6,$D7,$44 ; BA80
        .byte   $9F,$9E,$9F,$9E,$9F,$9D,$D8,$44,$9F,$9F,$9F,$A0,$9F,$A2,$D8,$44 ; BA90
        .byte   $9F,$9F,$9F,$A3,$9F,$9D,$D8,$44,$9F,$9F,$9F,$A6,$88,$88,$88,$44 ; BAA0
        .byte   $AC,$AA,$AB,$AC,$AA,$AB,$C2,$A7,$AE,$AD,$AD,$AE,$AD,$AD,$AD,$AD ; BAB0
; layout $13
        .byte   $61,$62,$63,$4C,$64,$4C,$4C,$4C,$65,$66,$67,$4C,$62,$63,$61,$4C ; BAC0
        .byte   $51,$50,$51,$68,$51,$68,$51,$69,$54,$54,$54,$54,$54,$54,$54,$54 ; BAD0
        .byte   $56,$56,$56,$56,$56,$56,$56,$56,$D9,$D9,$D9,$D9,$D9,$DA,$DB,$04 ; BAE0
        .byte   $DC,$30,$DC,$30,$DC,$30,$DD,$5A,$DE,$30,$DE,$30,$DE,$30,$DF,$44 ; BAF0
; layout $14
        .byte   $61,$62,$63,$4C,$64,$4C,$4C,$4C,$65,$66,$67,$4C,$62,$63,$61,$4C ; BB00
        .byte   $51,$50,$51,$68,$51,$68,$51,$69,$54,$54,$54,$54,$54,$54,$54,$54 ; BB10
        .byte   $56,$56,$56,$E0,$E1,$E2,$E1,$E2,$04,$6A,$E3,$30,$DC,$30,$DC,$30 ; BB20
        .byte   $5A,$6F,$90,$71,$93,$71,$93,$71,$44,$74,$75,$76,$16,$76,$16,$76 ; BB30
; layout $15
        .byte   $61,$62,$63,$4C,$64,$4C,$4C,$4C,$65,$66,$67,$4C,$62,$63,$61,$4C ; BB40
        .byte   $51,$50,$51,$68,$51,$68,$51,$69,$54,$54,$54,$54,$54,$54,$54,$54 ; BB50
        .byte   $E1,$E2,$E2,$E4,$B3,$E4,$E2,$E4,$DC,$30,$30,$BE,$BE,$BE,$30,$BE ; BB60
        .byte   $93,$71,$71,$72,$73,$73,$6F,$73,$16,$76,$75,$78,$79,$79,$74,$79 ; BB70
; layout $16
        .byte   $61,$62,$63,$4C,$64,$4C,$4C,$4C,$65,$66,$67,$4C,$62,$63,$61,$4C ; BB80
        .byte   $51,$50,$51,$68,$51,$68,$51,$69,$54,$54,$54,$54,$54,$E4,$E2,$54 ; BB90
        .byte   $B3,$E4,$E2,$B1,$B1,$E5,$30,$56,$BE,$BE,$30,$BF,$BF,$BE,$30,$04 ; BBA0
        .byte   $73,$73,$6F,$73,$85,$86,$6F,$5A,$79,$79,$74,$79,$87,$75,$74,$44 ; BBB0
; layout $17
        .byte   $61,$62,$63,$4C,$64,$4C,$4C,$4C,$65,$66,$67,$4C,$62,$63,$61,$4C ; BBC0
        .byte   $51,$50,$51,$68,$51,$68,$51,$69,$54,$54,$54,$54,$54,$54,$54,$54 ; BBD0
        .byte   $56,$56,$56,$56,$56,$56,$56,$56,$04,$6A,$E3,$E3,$6D,$88,$88,$04 ; BBE0
        .byte   $5A,$6F,$90,$90,$6F,$72,$73,$73,$44,$74,$75,$76,$74,$78,$79,$79 ; BBF0
; layout $18
        .byte   $61,$62,$63,$4C,$64,$4C,$4C,$4C,$65,$66,$67,$4C,$62,$63,$61,$4C ; BC00
        .byte   $51,$50,$51,$68,$51,$68,$51,$69,$54,$54,$54,$54,$54,$54,$54,$54 ; BC10
        .byte   $56,$56,$56,$56,$56,$56,$E6,$7F,$04,$6C,$6C,$88,$88,$04,$83,$83 ; BC20
        .byte   $85,$71,$71,$72,$73,$73,$85,$73,$87,$77,$77,$78,$79,$79,$87,$79 ; BC30
; layout $19
        .byte   $61,$62,$63,$4C,$64,$4C,$4C,$4C,$65,$66,$67,$4C,$62,$63,$61,$4C ; BC40
        .byte   $51,$50,$51,$68,$51,$68,$51,$69,$54,$54,$54,$54,$54,$54,$E2,$54 ; BC50
        .byte   $7F,$80,$56,$56,$8D,$91,$30,$56,$83,$83,$83,$83,$30,$31,$30,$04 ; BC60
        .byte   $73,$73,$85,$86,$71,$93,$30,$04,$79,$79,$87,$75,$76,$16,$30,$04 ; BC70
; layout $1A
        .byte   $94,$04,$95,$96,$97,$97,$96,$E7,$94,$04,$E8,$99,$99,$99,$99,$E7 ; BC80
        .byte   $94,$04,$E9,$9D,$9F,$EA,$9F,$E7,$94,$04,$E9,$9D,$9F,$A0,$9F,$EB ; BC90
        .byte   $94,$EC,$A5,$A2,$9F,$A3,$9F,$ED,$94,$EC,$A5,$9D,$9F,$A6,$9F,$EE ; BCA0
        .byte   $94,$A7,$A8,$A9,$AA,$AB,$AC,$AA,$94,$AD,$AD,$AD,$AD,$AD,$AE,$AD ; BCB0
; layout $1B
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$EF,$7E,$80,$F0,$F1 ; BCC0
        .byte   $EF,$CA,$D0,$D0,$7F,$7F,$7F,$7F,$83,$83,$83,$83,$83,$83,$83,$83 ; BCD0
        .byte   $F2,$F2,$F2,$F2,$F2,$F2,$F2,$F3,$17,$17,$17,$17,$17,$17,$17,$F4 ; BCE0
        .byte   $AB,$AC,$AA,$AB,$AC,$AA,$AB,$AC,$AD,$AE,$AD,$AD,$AE,$AD,$AD,$AE ; BCF0
; layout $1C
        .byte   $95,$96,$97,$97,$97,$96,$97,$B9,$F5,$F6,$F7,$F7,$F8,$F6,$F7,$F9 ; BD00
        .byte   $FA,$4A,$00,$08,$10,$4A,$00,$FB,$FA,$17,$4D,$4E,$17,$17,$4D,$FC ; BD10
        .byte   $FD,$08,$10,$4A,$00,$08,$10,$FE,$4D,$4E,$17,$17,$4D,$4E,$17,$FE ; BD20
        .byte   $AA,$AB,$AC,$AA,$AB,$AC,$AA,$AB,$AD,$AD,$AE,$AD,$AD,$AE,$AD,$AD ; BD30
; layout $1D
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BD40
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BD50
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BD60
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BD70
; layout $1E
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BD80
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BD90
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BDA0
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BDB0
; layout $1F
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BDC0
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BDD0
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BDE0
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BDF0
; layout $20
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BE00
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BE10
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BE20
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BE30
; layout $21
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BE40
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BE50
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BE60
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BE70
; layout $22
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BE80
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BE90
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BEA0
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BEB0
; layout $23
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BEC0
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BED0
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BEE0
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BEF0
; layout $24
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BF00
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BF10
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BF20
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BF30
; layout $25
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BF40
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BF50
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BF60
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BF70
; layout $26
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BF80
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BF90
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BFA0
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BFB0
; layout $27
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BFC0
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BFD0
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BFE0
        .byte   $04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04,$04 ; BFF0
