.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK0E"

; =============================================================================
; BANK $0E (mapped at $A000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
; =============================================================================
L0000           := $0000
L0008           := $0008
L0020           := $0020
L0100           := $0100
L0177           := $0177
L0627           := $0627
L0808           := $0808
L0C07           := $0C07
L0C10           := $0C10
L0F0F           := $0F0F
L0F11           := $0F11
L0F15           := $0F15
L0F37           := $0F37
L10F0           := $10F0
L1C2C           := $1C2C
L1F00           := $1F00
L2000           := $2000
L2020           := $2020
L2035           := $2035
L2120           := $2120
L2221           := $2221
L2607           := $2607
L2800           := $2800
L344E           := $344E
L444F           := $444F
L4748           := $4748
L494E           := $494E
L4A4F           := $4A4F
L4A68           := $4A68
L4B4E           := $4B4E
L4C4D           := $4C4D
L4C4F           := $4C4F
L524D           := $524D
L554F           := $554F
L6040           := $6040
L6362           := $6362
L664F           := $664F
L6664           := $6664
L696B           := $696B
L6B6A           := $6B6A
L6B6B           := $6B6B
L6B6E           := $6B6E
L6C22           := $6C22
L6C69           := $6C69
L6C6A           := $6C6A
L6C6C           := $6C6C
L6C6D           := $6C6D
L6D6C           := $6D6C
L6D6E           := $6D6E
L6E6D           := $6E6D
L6F6A           := $6F6A
L754F           := $754F
L797E           := $797E
L7B4F           := $7B4F
L7B7A           := $7B7A
L7C74           := $7C74
L7E4D           := $7E4D
L804E           := $804E
L8400           := $8400
L910A           := $910A
L9190           := $9190
LDAFC           := $DAFC
LE4E5           := $E4E5
LE904           := $E904
LF36F           := $F36F
LFF24           := $FF24
; ----------------------------------------------------------------------------
; =============================================================================
; ENDING SEQUENCE — $0E:A000 (jumped to by the game-flow hub, bank
; $17, when the player reaches state $23 after the Wily Capsule). A
; linear cutscene program, not entity AI: stops the music ($F0),
; fades, and steps through the ending tableaux using pseudo-stage
; nametables (banks $10/$0F at $A000 via LDAFC loads), IRQ split
; modes 2/3/5, OAM tableaux copied straight into $0200 (e.g. LA57C),
; palette programs (LA486), timed waits (LA47C / $FF24), and the
; ending-cast spawner at $A490 (type table LA51E: effect actors) for
; the castle-collapse and epilogue scenes. Beat-by-beat annotation
; belongs with the menu/cutscene pass — structure noted here so the
; stage-AI survey is complete.
; =============================================================================
        lda     #$F0                            ; A000 A9 F0                    ..
        jsr     queue_sound_param                           ; A002 20 5B EC                  [.
        jsr     palette_fade_out                           ; A005 20 F1 C3                  ..
        jsr     oam_clear                           ; A008 20 8F C3                  ..
        jsr     scroll_irq_reset                           ; A00B 20 B8 C3                  ..
        jsr     entity_clear_all                           ; A00E 20 9D C3                  ..
        jsr     frame_wait                           ; A011 20 22 FF                  ".
        jsr     disable_rendering                           ; A014 20 D1 C2                  ..
        lda     #$10                            ; A017 A9 10                    ..
        sta     $26                             ; A019 85 26                    .&
        sta     $27                             ; A01B 85 27                    .'
        lda     #$02                            ; A01D A9 02                    ..
        sta     $23                             ; A01F 85 23                    .#
        lda     #$00                            ; A021 A9 00                    ..
        sta     $F9                             ; A023 85 F9                    ..
        sta     $10                             ; A025 85 10                    ..
        jsr     LDAFC                           ; A027 20 FC DA                  ..
        lda     #$03                            ; A02A A9 03                    ..
        sta     $23                             ; A02C 85 23                    .#
        lda     #$08                            ; A02E A9 08                    ..
        sta     $10                             ; A030 85 10                    ..
        jsr     LDAFC                           ; A032 20 FC DA                  ..
        ldy     #$00                            ; A035 A0 00                    ..
        jsr     LA486                           ; A037 20 86 A4                  ..
        jsr     LA49F                           ; A03A 20 9F A4                  ..
        jsr     enable_rendering                           ; A03D 20 DB C2                  ..
        jsr     frame_wait                           ; A040 20 22 FF                  ".
        jsr     palette_fade_in                           ; A043 20 EB C3                  ..
        lda     #$00                            ; A046 A9 00                    ..
        sta     $78                             ; A048 85 78                    .x
        sta     $79                             ; A04A 85 79                    .y
        lda     #$22                            ; A04C A9 22                    ."
        sta     $7A                             ; A04E 85 7A                    .z
        lda     #$00                            ; A050 A9 00                    ..
        sta     $7B                             ; A052 85 7B                    .{
        lda     #$7F                            ; A054 A9 7F                    ..
        sta     $9B                             ; A056 85 9B                    ..
        lda     #$05                            ; A058 A9 05                    ..
        sta     $99                             ; A05A 85 99                    ..
        lda     #$02                            ; A05C A9 02                    ..
        sta     $FD                             ; A05E 85 FD                    ..
        lda     #$EF                            ; A060 A9 EF                    ..
        sta     $FA                             ; A062 85 FA                    ..
        jsr     LA432                           ; A064 20 32 A4                  2.
        jsr     LA3DC                           ; A067 20 DC A3                  ..
        lda     #$3C                            ; A06A A9 3C                    .<
        jsr     LA47C                           ; A06C 20 7C A4                  |.
        jsr     LA3FF                           ; A06F 20 FF A3                  ..
        lda     #$78                            ; A072 A9 78                    .x
        jsr     LFF24                           ; A074 20 24 FF                  $.
        jsr     oam_clear                           ; A077 20 8F C3                  ..
        jsr     scroll_irq_reset                           ; A07A 20 B8 C3                  ..
        jsr     entity_clear_all                           ; A07D 20 9D C3                  ..
        jsr     frame_wait                           ; A080 20 22 FF                  ".
        jsr     disable_rendering                           ; A083 20 D1 C2                  ..
        lda     #$10                            ; A086 A9 10                    ..
        sta     $26                             ; A088 85 26                    .&
        lda     #$0F                            ; A08A A9 0F                    ..
        sta     $27                             ; A08C 85 27                    .'
LA08E:  lda     #$05                            ; A08E A9 05                    ..
        sta     $23                             ; A090 85 23                    .#
        lda     #$00                            ; A092 A9 00                    ..
        sta     $F9                             ; A094 85 F9                    ..
        sta     $10                             ; A096 85 10                    ..
        jsr     LDAFC                           ; A098 20 FC DA                  ..
        ldy     #$08                            ; A09B A0 08                    ..
LA09D:  lda     LA56A,y                         ; A09D B9 6A A5                 .j.
        sta     $0780,y                         ; A0A0 99 80 07                 ...
        dey                                     ; A0A3 88                       .
        bpl     LA09D                           ; A0A4 10 F7                    ..
        jsr     nametable_flush                           ; A0A6 20 98 C2                  ..
        ldy     #$43                            ; A0A9 A0 43                    .C
LA0AB:  lda     LA57C,y                         ; A0AB B9 7C A5                 .|.
        sta     $0200,y                         ; A0AE 99 00 02                 ...
        dey                                     ; A0B1 88                       .
        bpl     LA0AB                           ; A0B2 10 F7                    ..
        lda     #$49                            ; A0B4 A9 49                    .I
        sta     $ED                             ; A0B6 85 ED                    ..
        ldy     #$22                            ; A0B8 A0 22                    ."
        jsr     LA486                           ; A0BA 20 86 A4                  ..
        jsr     enable_rendering                           ; A0BD 20 DB C2                  ..
        jsr     frame_wait                           ; A0C0 20 22 FF                  ".
        lda     #$0C                            ; A0C3 A9 0C                    ..
        jsr     queue_sound_param                           ; A0C5 20 5B EC                  [.
        jsr     palette_fade_in                           ; A0C8 20 EB C3                  ..
        lda     #$96                            ; A0CB A9 96                    ..
        sta     $05F1                           ; A0CD 8D F1 05                 ...
        lda     #$00                            ; A0D0 A9 00                    ..
        sta     $05F9                           ; A0D2 8D F9 05                 ...
        sta     $05F5                           ; A0D5 8D F5 05                 ...
        lda     #$B4                            ; A0D8 A9 B4                    ..
        jsr     LA3BD                           ; A0DA 20 BD A3                  ..
        ldy     #$08                            ; A0DD A0 08                    ..
LA0DF:  lda     LA573,y                         ; A0DF B9 73 A5                 .s.
        sta     $0780,y                         ; A0E2 99 80 07                 ...
        dey                                     ; A0E5 88                       .
        bpl     LA0DF                           ; A0E6 10 F7                    ..
        sty     $19                             ; A0E8 84 19                    ..
        lda     #$00                            ; A0EA A9 00                    ..
        sta     $6C                             ; A0EC 85 6C                    .l
        jsr     LA2A3                           ; A0EE 20 A3 A2                  ..
        jsr     palette_fade_out                           ; A0F1 20 F1 C3                  ..
        jsr     oam_clear                           ; A0F4 20 8F C3                  ..
        jsr     frame_wait                           ; A0F7 20 22 FF                  ".
        jsr     disable_rendering                           ; A0FA 20 D1 C2                  ..
        lda     #$20                            ; A0FD A9 20                    . 
        ldx     #$00                            ; A0FF A2 00                    ..
        ldy     #$00                            ; A101 A0 00                    ..
        jsr     ppu_fill_nametable                           ; A103 20 43 C3                  C.
        lda     #$28                            ; A106 A9 28                    .(
        ldx     #$00                            ; A108 A2 00                    ..
        ldy     #$00                            ; A10A A0 00                    ..
        jsr     ppu_fill_nametable                           ; A10C 20 43 C3                  C.
        ldy     #$43                            ; A10F A0 43                    .C
LA111:  lda     LA5C0,y                         ; A111 B9 C0 A5                 ...
        sta     $0200,y                         ; A114 99 00 02                 ...
        dey                                     ; A117 88                       .
        bpl     LA111                           ; A118 10 F7                    ..
        lda     #$00                            ; A11A A9 00                    ..
        sta     $25                             ; A11C 85 25                    .%
        sta     $05F1                           ; A11E 8D F1 05                 ...
        ldy     #$0F                            ; A121 A0 0F                    ..
LA123:  lda     LA6C4,y                         ; A123 B9 C4 A6                 ...
        sta     $0620,y                         ; A126 99 20 06                 . .
        dey                                     ; A129 88                       .
        bpl     LA123                           ; A12A 10 F7                    ..
        jsr     enable_rendering                           ; A12C 20 DB C2                  ..
        jsr     frame_wait                           ; A12F 20 22 FF                  ".
        jsr     palette_fade_in                           ; A132 20 EB C3                  ..
        jsr     LA1AA                           ; A135 20 AA A1                  ..
        ldy     #$06                            ; A138 A0 06                    ..
        ldx     #$00                            ; A13A A2 00                    ..
        jsr     LA4A3                           ; A13C 20 A3 A4                  ..
        lda     #$00                            ; A13F A9 00                    ..
        sta     $03A8                           ; A141 8D A8 03                 ...
        lda     #$01                            ; A144 A9 01                    ..
        sta     $03C0                           ; A146 8D C0 03                 ...
        jsr     LA152                           ; A149 20 52 A1                  R.
LA14C:  jsr     LA3BB                           ; A14C 20 BB A3                  ..
        jmp     LA14C                           ; A14F 4C 4C A1                 LL.

; ----------------------------------------------------------------------------
LA152:  lda     #$29                            ; A152 A9 29                    .)
        sta     $0780                           ; A154 8D 80 07                 ...
        lda     #$40                            ; A157 A9 40                    .@
        sta     $0781                           ; A159 8D 81 07                 ...
        lda     #$00                            ; A15C A9 00                    ..
        sta     $0782                           ; A15E 8D 82 07                 ...
        lda     #$00                            ; A161 A9 00                    ..
        sta     $0783                           ; A163 8D 83 07                 ...
        lda     #$FF                            ; A166 A9 FF                    ..
        sta     $0784                           ; A168 8D 84 07                 ...
        lda     #$05                            ; A16B A9 05                    ..
        sta     L0008                           ; A16D 85 08                    ..
LA16F:  ldx     #$00                            ; A16F A2 00                    ..
        jsr     LE904                           ; A171 20 04 E9                  ..
        ldy     L0008                           ; A174 A4 08                    ..
        bmi     LA190                           ; A176 30 18                    0.
        lda     LA738,y                         ; A178 B9 38 A7                 .8.
        cmp     $0330                           ; A17B CD 30 03                 .0.
        bne     LA190                           ; A17E D0 10                    ..
        lda     LA73E,y                         ; A180 B9 3E A7                 .>.
        sta     $0781                           ; A183 8D 81 07                 ...
        lda     LA744,y                         ; A186 B9 44 A7                 .D.
        sta     $0783                           ; A189 8D 83 07                 ...
        inc     $19                             ; A18C E6 19                    ..
        .byte   $C6                             ; A18E C6                       .
LA18F:  php                                     ; A18F 08                       .
LA190:  jsr     LA3BB                           ; A190 20 BB A3                  ..
        lda     #$58                            ; A193 A9 58                    .X
        cmp     $0330                           ; A195 CD 30 03                 .0.
        bne     LA16F                           ; A198 D0 D5                    ..
        ldx     #$00                            ; A19A A2 00                    ..
        lda     #$9C                            ; A19C A9 9C                    ..
        jsr     entity_set_subtype                           ; A19E 20 98 EA                  ..
        lda     $0528                           ; A1A1 AD 28 05                 .(.
        ora     #$20                            ; A1A4 09 20                    . 
        sta     $0528                           ; A1A6 8D 28 05                 .(.
        rts                                     ; A1A9 60                       `

; ----------------------------------------------------------------------------
LA1AA:  lda     $9D                             ; A1AA A5 9D                    ..
        and     #$01                            ; A1AC 29 01                    ).
        beq     LA1B3                           ; A1AE F0 03                    ..
        jmp     LA23A                           ; A1B0 4C 3A A2                 L:.

; ----------------------------------------------------------------------------
LA1B3:  inc     $FA                             ; A1B3 E6 FA                    ..
        lda     $FA                             ; A1B5 A5 FA                    ..
        cmp     #$F0                            ; A1B7 C9 F0                    ..
        bne     LA1C5                           ; A1B9 D0 0A                    ..
        lda     #$00                            ; A1BB A9 00                    ..
        sta     $FA                             ; A1BD 85 FA                    ..
        lda     $FD                             ; A1BF A5 FD                    ..
        eor     #$02                            ; A1C1 49 02                    I.
        sta     $FD                             ; A1C3 85 FD                    ..
LA1C5:  lda     $FA                             ; A1C5 A5 FA                    ..
        and     #$07                            ; A1C7 29 07                    ).
        bne     LA23A                           ; A1C9 D0 6F                    .o
        ldy     #$23                            ; A1CB A0 23                    .#
LA1CD:  lda     LA6D4,y                         ; A1CD B9 D4 A6                 ...
        sta     $0780,y                         ; A1D0 99 80 07                 ...
        dey                                     ; A1D3 88                       .
        bpl     LA1CD                           ; A1D4 10 F7                    ..
        lda     $FA                             ; A1D6 A5 FA                    ..
        lsr     a                               ; A1D8 4A                       J
        lsr     a                               ; A1D9 4A                       J
        lsr     a                               ; A1DA 4A                       J
        sta     $03                             ; A1DB 85 03                    ..
        ldy     $25                             ; A1DD A4 25                    .%
        cmp     LA6AB,y                         ; A1DF D9 AB A6                 ...
        bne     LA21C                           ; A1E2 D0 38                    .8
        lda     #$0F                            ; A1E4 A9 0F                    ..
        sta     $F5                             ; A1E6 85 F5                    ..
        jsr     bank_load_shadow                           ; A1E8 20 43 FF                  C.
        ldy     $6C                             ; A1EB A4 6C                    .l
        lda     $8000,y                         ; A1ED B9 00 80                 ...
        sta     L0000                           ; A1F0 85 00                    ..
        lda     $8028,y                         ; A1F2 B9 28 80                 .(.
        sta     $01                             ; A1F5 85 01                    ..
        ldy     #$00                            ; A1F7 A0 00                    ..
        lda     (L0000),y                       ; A1F9 B1 00                    ..
        tax                                     ; A1FB AA                       .
        iny                                     ; A1FC C8                       .
        lda     (L0000),y                       ; A1FD B1 00                    ..
        sta     $02                             ; A1FF 85 02                    ..
        iny                                     ; A201 C8                       .
LA202:  lda     (L0000),y                       ; A202 B1 00                    ..
        cmp     #$20                            ; A204 C9 20                    . 
        beq     LA20B                           ; A206 F0 03                    ..
        sta     $0783,x                         ; A208 9D 83 07                 ...
LA20B:  iny                                     ; A20B C8                       .
        inx                                     ; A20C E8                       .
        dec     $02                             ; A20D C6 02                    ..
        bpl     LA202                           ; A20F 10 F1                    ..
        lda     #$17                            ; A211 A9 17                    ..
        sta     $F5                             ; A213 85 F5                    ..
        jsr     bank_load_shadow                           ; A215 20 43 FF                  C.
        inc     $25                             ; A218 E6 25                    .%
        inc     $6C                             ; A21A E6 6C                    .l
LA21C:  ldy     $03                             ; A21C A4 03                    ..
        lda     LA6F8,y                         ; A21E B9 F8 A6                 ...
        sta     $0780                           ; A221 8D 80 07                 ...
        lda     LA718,y                         ; A224 B9 18 A7                 ...
        sta     $0781                           ; A227 8D 81 07                 ...
        lda     $FD                             ; A22A A5 FD                    ..
        bne     LA236                           ; A22C D0 08                    ..
        lda     $0780                           ; A22E AD 80 07                 ...
        eor     #$08                            ; A231 49 08                    I.
        sta     $0780                           ; A233 8D 80 07                 ...
LA236:  lda     #$FF                            ; A236 A9 FF                    ..
        sta     $19                             ; A238 85 19                    ..
LA23A:  jsr     LA3A6                           ; A23A 20 A6 A3                  ..
        jsr     LF36F                           ; A23D 20 6F F3                  o.
        lda     $25                             ; A240 A5 25                    .%
        cmp     #$18                            ; A242 C9 18                    ..
        bne     LA250                           ; A244 D0 0A                    ..
        lda     $FD                             ; A246 A5 FD                    ..
        bne     LA250                           ; A248 D0 06                    ..
        lda     $FA                             ; A24A A5 FA                    ..
        cmp     #$D0                            ; A24C C9 D0                    ..
        beq     LA253                           ; A24E F0 03                    ..
LA250:  jmp     LA1AA                           ; A250 4C AA A1                 L..

; ----------------------------------------------------------------------------
LA253:  rts                                     ; A253 60                       `

; ----------------------------------------------------------------------------
LA254:  lda     #$0F                            ; A254 A9 0F                    ..
        sta     $F5                             ; A256 85 F5                    ..
        jsr     bank_load_shadow                           ; A258 20 43 FF                  C.
        lda     $8000,y                         ; A25B B9 00 80                 ...
        sta     L0008                           ; A25E 85 08                    ..
        lda     $8028,y                         ; A260 B9 28 80                 .(.
        sta     $09                             ; A263 85 09                    ..
        ldy     #$00                            ; A265 A0 00                    ..
LA267:  lda     (L0008),y                       ; A267 B1 08                    ..
        sta     $0780                           ; A269 8D 80 07                 ...
        iny                                     ; A26C C8                       .
        lda     (L0008),y                       ; A26D B1 08                    ..
        sta     $0781                           ; A26F 8D 81 07                 ...
        iny                                     ; A272 C8                       .
        lda     #$00                            ; A273 A9 00                    ..
        sta     $0782                           ; A275 8D 82 07                 ...
LA278:  lda     (L0008),y                       ; A278 B1 08                    ..
        sta     $0783                           ; A27A 8D 83 07                 ...
        iny                                     ; A27D C8                       .
        lda     #$FF                            ; A27E A9 FF                    ..
        sta     $0784                           ; A280 8D 84 07                 ...
        sta     $19                             ; A283 85 19                    ..
        sty     $0A                             ; A285 84 0A                    ..
        lda     #$05                            ; A287 A9 05                    ..
        jsr     LA3CA                           ; A289 20 CA A3                  ..
        inc     $0781                           ; A28C EE 81 07                 ...
        ldy     $0A                             ; A28F A4 0A                    ..
        lda     (L0008),y                       ; A291 B1 08                    ..
        beq     LA2A0                           ; A293 F0 0B                    ..
        cmp     #$FF                            ; A295 C9 FF                    ..
        bne     LA278                           ; A297 D0 DF                    ..
        lda     #$17                            ; A299 A9 17                    ..
        sta     $F5                             ; A29B 85 F5                    ..
        jmp     bank_load_shadow                           ; A29D 4C 43 FF                 LC.

; ----------------------------------------------------------------------------
LA2A0:  iny                                     ; A2A0 C8                       .
        bne     LA267                           ; A2A1 D0 C4                    ..
LA2A3:  ldx     #$00                            ; A2A3 A2 00                    ..
        ldy     #$05                            ; A2A5 A0 05                    ..
        jsr     LA4A3                           ; A2A7 20 A3 A4                  ..
LA2AA:  jsr     LA3BB                           ; A2AA 20 BB A3                  ..
        lda     $0540                           ; A2AD AD 40 05                 .@.
        cmp     #$06                            ; A2B0 C9 06                    ..
        bne     LA2AA                           ; A2B2 D0 F6                    ..
        ldx     #$00                            ; A2B4 A2 00                    ..
        stx     $9D                             ; A2B6 86 9D                    ..
        ldy     $6C                             ; A2B8 A4 6C                    .l
        lda     $8DB3,y                         ; A2BA B9 B3 8D                 ...
        jsr     entity_set_subtype                           ; A2BD 20 98 EA                  ..
        ldy     #$02                            ; A2C0 A0 02                    ..
        lda     #$36                            ; A2C2 A9 36                    .6
LA2C4:  sta     $0611,y                         ; A2C4 99 11 06                 ...
        sta     $0615,y                         ; A2C7 99 15 06                 ...
        sta     $0619,y                         ; A2CA 99 19 06                 ...
        sta     $061D,y                         ; A2CD 99 1D 06                 ...
        dey                                     ; A2D0 88                       .
        bpl     LA2C4                           ; A2D1 10 F1                    ..
        sty     $18                             ; A2D3 84 18                    ..
LA2D5:  lda     #$00                            ; A2D5 A9 00                    ..
        sta     $0570                           ; A2D7 8D 70 05                 .p.
        jsr     LA3BB                           ; A2DA 20 BB A3                  ..
        lda     $9D                             ; A2DD A5 9D                    ..
        lsr     a                               ; A2DF 4A                       J
        and     #$07                            ; A2E0 29 07                    ).
        tay                                     ; A2E2 A8                       .
        lda     $0528                           ; A2E3 AD 28 05                 .(.
        and     #$FB                            ; A2E6 29 FB                    ).
        ora     $8DC3,y                         ; A2E8 19 C3 8D                 ...
        sta     $0528                           ; A2EB 8D 28 05                 .(.
        cpy     #$07                            ; A2EE C0 07                    ..
        bne     LA2D5                           ; A2F0 D0 E3                    ..
        lda     $6C                             ; A2F2 A5 6C                    .l
        asl     a                               ; A2F4 0A                       .
        asl     a                               ; A2F5 0A                       .
        asl     a                               ; A2F6 0A                       .
        tay                                     ; A2F7 A8                       .
        ldx     #$00                            ; A2F8 A2 00                    ..
LA2FA:  lda     $8C42,x                         ; A2FA BD 42 8C                 .B.
        sta     $0610,x                         ; A2FD 9D 10 06                 ...
        lda     $8C4A,y                         ; A300 B9 4A 8C                 .J.
        sta     $0618,x                         ; A303 9D 18 06                 ...
        sta     $0638,x                         ; A306 9D 38 06                 .8.
        iny                                     ; A309 C8                       .
        inx                                     ; A30A E8                       .
        cpx     #$08                            ; A30B E0 08                    ..
        bne     LA2FA                           ; A30D D0 EB                    ..
        lda     #$FF                            ; A30F A9 FF                    ..
        sta     $18                             ; A311 85 18                    ..
LA313:  jsr     LA3BB                           ; A313 20 BB A3                  ..
        ldy     $6C                             ; A316 A4 6C                    .l
        lda     $0540                           ; A318 AD 40 05                 .@.
        cmp     $8DBB,y                         ; A31B D9 BB 8D                 ...
        bne     LA313                           ; A31E D0 F3                    ..
        lda     $0558                           ; A320 AD 58 05                 .X.
        cmp     #$20                            ; A323 C9 20                    . 
        bne     LA347                           ; A325 D0 20                    . 
        ldx     #$00                            ; A327 A2 00                    ..
        ldy     #$01                            ; A329 A0 01                    ..
        lda     #$21                            ; A32B A9 21                    .!
        jsr     entity_init_pos                           ; A32D 20 A4 EA                  ..
        lda     #$6D                            ; A330 A9 6D                    .m
        sta     $0301                           ; A332 8D 01 03                 ...
        lda     #$48                            ; A335 A9 48                    .H
        sta     $0379                           ; A337 8D 79 03                 .y.
LA33A:  lda     #$00                            ; A33A A9 00                    ..
        sta     $0570                           ; A33C 8D 70 05                 .p.
        jsr     LA3BB                           ; A33F 20 BB A3                  ..
        lda     $0301                           ; A342 AD 01 03                 ...
        bne     LA33A                           ; A345 D0 F3                    ..
LA347:  lda     #$3C                            ; A347 A9 3C                    .<
        jsr     LA3CA                           ; A349 20 CA A3                  ..
        ldy     $6C                             ; A34C A4 6C                    .l
        jsr     LA254                           ; A34E 20 54 A2                  T.
        lda     #$B4                            ; A351 A9 B4                    ..
        jsr     LA3CA                           ; A353 20 CA A3                  ..
        ldy     #$41                            ; A356 A0 41                    .A
LA358:  lda     LA604,y                         ; A358 B9 04 A6                 ...
        sta     $0780,y                         ; A35B 99 80 07                 ...
        dey                                     ; A35E 88                       .
        bpl     LA358                           ; A35F 10 F7                    ..
        sty     $19                             ; A361 84 19                    ..
        lda     #$00                            ; A363 A9 00                    ..
        sta     $0300                           ; A365 8D 00 03                 ...
        jsr     LA3BB                           ; A368 20 BB A3                  ..
        ldy     #$0F                            ; A36B A0 0F                    ..
LA36D:  lda     LA50E,y                         ; A36D B9 0E A5                 ...
        sta     $0610,y                         ; A370 99 10 06                 ...
        dey                                     ; A373 88                       .
        bpl     LA36D                           ; A374 10 F7                    ..
        sty     $18                             ; A376 84 18                    ..
        inc     $6C                             ; A378 E6 6C                    .l
        lda     $6C                             ; A37A A5 6C                    .l
        cmp     #$08                            ; A37C C9 08                    ..
        beq     LA383                           ; A37E F0 03                    ..
        jmp     LA2A3                           ; A380 4C A3 A2                 L..

; ----------------------------------------------------------------------------
LA383:  ldy     $6C                             ; A383 A4 6C                    .l
        jsr     LA254                           ; A385 20 54 A2                  T.
        lda     #$B4                            ; A388 A9 B4                    ..
        jsr     LA3CA                           ; A38A 20 CA A3                  ..
        ldy     #$64                            ; A38D A0 64                    .d
LA38F:  lda     LA646,y                         ; A38F B9 46 A6                 .F.
        sta     $0780,y                         ; A392 99 80 07                 ...
        dey                                     ; A395 88                       .
        bpl     LA38F                           ; A396 10 F7                    ..
        sty     $19                             ; A398 84 19                    ..
        jsr     LA3BB                           ; A39A 20 BB A3                  ..
        inc     $6C                             ; A39D E6 6C                    .l
        lda     $6C                             ; A39F A5 6C                    .l
        cmp     #$10                            ; A3A1 C9 10                    ..
        bne     LA383                           ; A3A3 D0 DE                    ..
        rts                                     ; A3A5 60                       `

; ----------------------------------------------------------------------------
LA3A6:  ldx     #$00                            ; A3A6 A2 00                    ..
LA3A8:  dec     $0203,x                         ; A3A8 DE 03 02                 ...
        cpx     #$20                            ; A3AB E0 20                    . 
        bcs     LA3B2                           ; A3AD B0 03                    ..
        dec     $0203,x                         ; A3AF DE 03 02                 ...
LA3B2:  inx                                     ; A3B2 E8                       .
        inx                                     ; A3B3 E8                       .
        inx                                     ; A3B4 E8                       .
        inx                                     ; A3B5 E8                       .
        cpx     #$44                            ; A3B6 E0 44                    .D
        bne     LA3A8                           ; A3B8 D0 EE                    ..
        rts                                     ; A3BA 60                       `

; ----------------------------------------------------------------------------
LA3BB:  lda     #$01                            ; A3BB A9 01                    ..
LA3BD:  sta     $0F                             ; A3BD 85 0F                    ..
LA3BF:  jsr     LA3A6                           ; A3BF 20 A6 A3                  ..
        jsr     LF36F                           ; A3C2 20 6F F3                  o.
        dec     $0F                             ; A3C5 C6 0F                    ..
        bne     LA3BF                           ; A3C7 D0 F6                    ..
        rts                                     ; A3C9 60                       `

; ----------------------------------------------------------------------------
LA3CA:  sta     $0F                             ; A3CA 85 0F                    ..
LA3CC:  lda     #$00                            ; A3CC A9 00                    ..
        sta     $0570                           ; A3CE 8D 70 05                 .p.
        jsr     LA3A6                           ; A3D1 20 A6 A3                  ..
        jsr     LF36F                           ; A3D4 20 6F F3                  o.
        dec     $0F                             ; A3D7 C6 0F                    ..
        bne     LA3CC                           ; A3D9 D0 F1                    ..
        rts                                     ; A3DB 60                       `

; ----------------------------------------------------------------------------
LA3DC:  lda     $0361                           ; A3DC AD 61 03                 .a.
        clc                                     ; A3DF 18                       .
        adc     #$40                            ; A3E0 69 40                    i@
        sta     $0361                           ; A3E2 8D 61 03                 .a.
        lda     $0379                           ; A3E5 AD 79 03                 .y.
        adc     #$00                            ; A3E8 69 00                    i.
        sta     $0379                           ; A3EA 8D 79 03                 .y.
        cmp     #$F0                            ; A3ED C9 F0                    ..
        bne     LA3F6                           ; A3EF D0 05                    ..
        lda     #$00                            ; A3F1 A9 00                    ..
        sta     $0301                           ; A3F3 8D 01 03                 ...
LA3F6:  jsr     render_tick_frame                           ; A3F6 20 63 F3                  c.
        lda     $0301                           ; A3F9 AD 01 03                 ...
        bne     LA3DC                           ; A3FC D0 DE                    ..
        rts                                     ; A3FE 60                       `

; ----------------------------------------------------------------------------
LA3FF:  lda     #$00                            ; A3FF A9 00                    ..
        sta     $9D                             ; A401 85 9D                    ..
        sta     $10                             ; A403 85 10                    ..
LA405:  lda     $9D                             ; A405 A5 9D                    ..
        and     #$0F                            ; A407 29 0F                    ).
        bne     LA426                           ; A409 D0 1B                    ..
        ldy     #$1F                            ; A40B A0 1F                    ..
LA40D:  lda     $0620,y                         ; A40D B9 20 06                 . .
        sec                                     ; A410 38                       8
        sbc     $10                             ; A411 E5 10                    ..
        bcs     LA417                           ; A413 B0 02                    ..
        lda     #$0F                            ; A415 A9 0F                    ..
LA417:  sta     $0600,y                         ; A417 99 00 06                 ...
        dey                                     ; A41A 88                       .
        bpl     LA40D                           ; A41B 10 F0                    ..
        sty     $18                             ; A41D 84 18                    ..
        lda     $10                             ; A41F A5 10                    ..
        clc                                     ; A421 18                       .
        adc     #$10                            ; A422 69 10                    i.
        sta     $10                             ; A424 85 10                    ..
LA426:  inc     $9D                             ; A426 E6 9D                    ..
        jsr     frame_wait                           ; A428 20 22 FF                  ".
        lda     $10                             ; A42B A5 10                    ..
        cmp     #$50                            ; A42D C9 50                    .P
        bne     LA405                           ; A42F D0 D4                    ..
        rts                                     ; A431 60                       `

; ----------------------------------------------------------------------------
LA432:  ldx     #$00                            ; A432 A2 00                    ..
        lda     $0468                           ; A434 AD 68 04                 .h.
        bne     LA44E                           ; A437 D0 15                    ..
        ldy     $0480                           ; A439 AC 80 04                 ...
        inc     $0480                           ; A43C EE 80 04                 ...
        lda     LA552,y                         ; A43F B9 52 A5                 .R.
        sta     $0468                           ; A442 8D 68 04                 .h.
        lda     LA53A,y                         ; A445 B9 3A A5                 .:.
        tay                                     ; A448 A8                       .
        lda     #$38                            ; A449 A9 38                    .8
        jsr     entity_set_dir_velocity                           ; A44B 20 70 F4                  p.
LA44E:  jsr     entity_facing_dispatch                           ; A44E 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A451 20 86 EA                  ..
        lda     $0390                           ; A454 AD 90 03                 ...
        bne     LA47B                           ; A457 D0 22                    ."
        dec     $0468                           ; A459 CE 68 04                 .h.
        lda     $FA                             ; A45C A5 FA                    ..
        cmp     #$A0                            ; A45E C9 A0                    ..
        beq     LA475                           ; A460 F0 13                    ..
        lda     $9D                             ; A462 A5 9D                    ..
        and     #$03                            ; A464 29 03                    ).
        bne     LA475                           ; A466 D0 0D                    ..
        dec     $FA                             ; A468 C6 FA                    ..
        lda     $FA                             ; A46A A5 FA                    ..
        and     #$03                            ; A46C 29 03                    ).
        bne     LA475                           ; A46E D0 05                    ..
        lda     #$2B                            ; A470 A9 2B                    .+
        jsr     queue_sound                           ; A472 20 5D EC                  ].
LA475:  jsr     render_tick_frame                           ; A475 20 63 F3                  c.
        jmp     LA432                           ; A478 4C 32 A4                 L2.

; ----------------------------------------------------------------------------
LA47B:  rts                                     ; A47B 60                       `

; ----------------------------------------------------------------------------
LA47C:  sta     $0F                             ; A47C 85 0F                    ..
LA47E:  jsr     render_tick_frame                           ; A47E 20 63 F3                  c.
        dec     $0F                             ; A481 C6 0F                    ..
        bne     LA47E                           ; A483 D0 F9                    ..
        rts                                     ; A485 60                       `

; ----------------------------------------------------------------------------
LA486:  lda     LA4DA,y                         ; A486 B9 DA A4                 ...
        sta     $EA                             ; A489 85 EA                    ..
        lda     LA4DB,y                         ; A48B B9 DB A4                 ...
        sta     $EB                             ; A48E 85 EB                    ..
        ldx     #$00                            ; A490 A2 00                    ..
LA492:  lda     LA4DC,y                         ; A492 B9 DC A4                 ...
        sta     $0620,x                         ; A495 9D 20 06                 . .
        iny                                     ; A498 C8                       .
        inx                                     ; A499 E8                       .
        cpx     #$20                            ; A49A E0 20                    . 
        bne     LA492                           ; A49C D0 F4                    ..
        rts                                     ; A49E 60                       `

; ----------------------------------------------------------------------------
LA49F:  ldx     #$04                            ; A49F A2 04                    ..
        ldy     #$04                            ; A4A1 A0 04                    ..
LA4A3:  lda     LA51E,y                         ; A4A3 B9 1E A5                 ...
        sta     $0300,x                         ; A4A6 9D 00 03                 ...
        lda     LA525,y                         ; A4A9 B9 25 A5                 .%.
        jsr     entity_set_subtype                           ; A4AC 20 98 EA                  ..
        lda     LA52C,y                         ; A4AF B9 2C A5                 .,.
        sta     $0330,x                         ; A4B2 9D 30 03                 .0.
        lda     LA533,y                         ; A4B5 B9 33 A5                 .3.
        sta     $0378,x                         ; A4B8 9D 78 03                 .x.
        lda     #$00                            ; A4BB A9 00                    ..
        sta     $0528,x                         ; A4BD 9D 28 05                 .(.
        sta     $0390,x                         ; A4C0 9D 90 03                 ...
        sta     $0348,x                         ; A4C3 9D 48 03                 .H.
        sta     $05B8,x                         ; A4C6 9D B8 05                 ...
        sta     $0468,x                         ; A4C9 9D 68 04                 .h.
        sta     $0480,x                         ; A4CC 9D 80 04                 ...
        sta     $0498,x                         ; A4CF 9D 98 04                 ...
        sta     $04B0,x                         ; A4D2 9D B0 04                 ...
        dey                                     ; A4D5 88                       .
        dex                                     ; A4D6 CA                       .
        bpl     LA4A3                           ; A4D7 10 CA                    ..
        rts                                     ; A4D9 60                       `

; ----------------------------------------------------------------------------
LA4DA:  .byte   $E4                             ; A4DA E4                       .
LA4DB:  .byte   $E6                             ; A4DB E6                       .
LA4DC:  .byte   $0F                             ; A4DC 0F                       .
        .byte   $37                             ; A4DD 37                       7
        .byte   $17                             ; A4DE 17                       .
        .byte   $07                             ; A4DF 07                       .
        .byte   $0F                             ; A4E0 0F                       .
        bmi     LA506                           ; A4E1 30 23                    0#
        and     ($0F,x)                         ; A4E3 21 0F                    !.
        bmi     LA50D                           ; A4E5 30 26                    0&
        and     ($0F,x)                         ; A4E7 21 0F                    !.
        bmi     LA4FC                           ; A4E9 30 11                    0.
        and     ($0F,x)                         ; A4EB 21 0F                    !.
        .byte   $0F                             ; A4ED 0F                       .
        bit     L0F11                           ; A4EE 2C 11 0F                 ,..
        .byte   $0F                             ; A4F1 0F                       .
        jsr     L0F37                           ; A4F2 20 37 0F                  7.
        .byte   $0F                             ; A4F5 0F                       .
        jsr     L0F15                           ; A4F6 20 15 0F                  ..
        .byte   $0F                             ; A4F9 0F                       .
        .byte   $27                             ; A4FA 27                       '
        .byte   $15                             ; A4FB 15                       .
LA4FC:  iny                                     ; A4FC C8                       .
        dex                                     ; A4FD CA                       .
        .byte   $0F                             ; A4FE 0F                       .
        jsr     L1C2C                           ; A4FF 20 2C 1C                  ,.
        .byte   $0F                             ; A502 0F                       .
        and     ($1C),y                         ; A503 31 1C                    1.
        .byte   $27                             ; A505 27                       '
LA506:  .byte   $0F                             ; A506 0F                       .
        and     ($1C),y                         ; A507 31 1C                    1.
        ora     ($0F,x)                         ; A509 01 0F                    ..
        .byte   $20                             ; A50B 20                        
        .byte   $0F                             ; A50C 0F                       .
LA50D:  .byte   $0F                             ; A50D 0F                       .
LA50E:  .byte   $0F                             ; A50E 0F                       .
        .byte   $0F                             ; A50F 0F                       .
        bit     L0F11                           ; A510 2C 11 0F                 ,..
        .byte   $0F                             ; A513 0F                       .
        jsr     L0F37                           ; A514 20 37 0F                  7.
        .byte   $0F                             ; A517 0F                       .
        jsr     L0F11                           ; A518 20 11 0F                  ..
        .byte   $0F                             ; A51B 0F                       .
        .byte   $20                             ; A51C 20                        
        .byte   $15                             ; A51D 15                       .
LA51E:  adc     $6D6D                           ; A51E 6D 6D 6D                 mmm
        adc     $6D01                           ; A521 6D 01 6D                 m.m
        .byte   $01                             ; A524 01                       .
LA525:  ror     a                               ; A525 6A                       j
        adc     #$71                            ; A526 69 71                    iq
        pla                                     ; A528 68                       h
        cmp     $5B                             ; A529 C5 5B                    .[
        .byte   $9B                             ; A52B 9B                       .
LA52C:  cld                                     ; A52C D8                       .
        inx                                     ; A52D E8                       .
        iny                                     ; A52E C8                       .
        .byte   $1C                             ; A52F 1C                       .
        .byte   $3C                             ; A530 3C                       <
        .byte   $80                             ; A531 80                       .
        .byte   $FC                             ; A532 FC                       .
LA533:  sei                                     ; A533 78                       x
        .byte   $DB                             ; A534 DB                       .
        .byte   $7F                             ; A535 7F                       .
        .byte   $B3                             ; A536 B3                       .
        .byte   $BB                             ; A537 BB                       .
        .byte   $74                             ; A538 74                       t
        .byte   $74                             ; A539 74                       t
LA53A:  .byte   $03                             ; A53A 03                       .
        .byte   $02                             ; A53B 02                       .
        ora     (L0000,x)                       ; A53C 01 00                    ..
        .byte   $0F                             ; A53E 0F                       .
        asl     $0C0D                           ; A53F 0E 0D 0C                 ...
        ora     $0F0E                           ; A542 0D 0E 0F                 ...
LA545:  asl     $0C0D                           ; A545 0E 0D 0C                 ...
        ora     $0F0E                           ; A548 0D 0E 0F                 ...
        asl     $0C0D                           ; A54B 0E 0D 0C                 ...
        ora     $0F0E                           ; A54E 0D 0E 0F                 ...
        .byte   $FF                             ; A551 FF                       .
LA552:  bpl     LA564                           ; A552 10 10                    ..
        bpl     LA566                           ; A554 10 10                    ..
        bpl     LA568                           ; A556 10 10                    ..
        .byte   $10                             ; A558 10                       .
LA559:  jsr     L0808                           ; A559 20 08 08                  ..
        bpl     LA566                           ; A55C 10 08                    ..
        php                                     ; A55E 08                       .
        jsr     L0808                           ; A55F 20 08 08                  ..
        clc                                     ; A562 18                       .
        php                                     ; A563 08                       .
LA564:  php                                     ; A564 08                       .
        clc                                     ; A565 18                       .
LA566:  php                                     ; A566 08                       .
        php                                     ; A567 08                       .
LA568:  .byte   $FF                             ; A568 FF                       .
        .byte   $FF                             ; A569 FF                       .
LA56A:  and     ($AD,x)                         ; A56A 21 AD                    !.
        .byte   $04                             ; A56C 04                       .
        .byte   $53                             ; A56D 53                       S
        .byte   $54                             ; A56E 54                       T
        eor     ($46,x)                         ; A56F 41 46                    AF
        lsr     $FF                             ; A571 46 FF                    F.
LA573:  and     ($AD,x)                         ; A573 21 AD                    !.
        .byte   $04                             ; A575 04                       .
        ora     ($01,x)                         ; A576 01 01                    ..
        ora     ($01,x)                         ; A578 01 01                    ..
LA57A:  ora     ($FF,x)                         ; A57A 01 FF                    ..
LA57C:  bpl     LA5F4                           ; A57C 10 76                    .v
        ora     (L0020,x)                       ; A57E 01 20                    . 
        plp                                     ; A580 28                       (
        ror     $01,x                           ; A581 76 01                    v.
        pla                                     ; A583 68                       h
        clc                                     ; A584 18                       .
        ror     $01,x                           ; A585 76 01                    v.
        bcc     LA5A9                           ; A587 90 20                    . 
        ror     $01,x                           ; A589 76 01                    v.
        bne     LA545                           ; A58B D0 B8                    ..
        ror     $01,x                           ; A58D 76 01                    v.
        bpl     LA559                           ; A58F 10 C8                    ..
        ror     $01,x                           ; A591 76 01                    v.
        cli                                     ; A593 58                       X
        cpy     #$76                            ; A594 C0 76                    .v
        ora     ($88,x)                         ; A596 01 88                    ..
        cpx     #$76                            ; A598 E0 76                    .v
        ora     ($D0,x)                         ; A59A 01 D0                    ..
        jsr     L0177                           ; A59C 20 77 01                  w.
        rti                                     ; A59F 40                       @

; ----------------------------------------------------------------------------
        bmi     LA619                           ; A5A0 30 77                    0w
        ora     ($B0,x)                         ; A5A2 01 B0                    ..
        php                                     ; A5A4 08                       .
        .byte   $77                             ; A5A5 77                       w
        ora     ($C8,x)                         ; A5A6 01 C8                    ..
        .byte   $D0                             ; A5A8 D0                       .
LA5A9:  .byte   $77                             ; A5A9 77                       w
        ora     ($28,x)                         ; A5AA 01 28                    .(
        bcs     LA625                           ; A5AC B0 77                    .w
        ora     ($40,x)                         ; A5AE 01 40                    .@
        cpy     #$77                            ; A5B0 C0 77                    .w
        ora     ($A8,x)                         ; A5B2 01 A8                    ..
        cpx     #$77                            ; A5B4 E0 77                    .w
        ora     ($C8,x)                         ; A5B6 01 C8                    ..
        sed                                     ; A5B8 F8                       .
        brk                                     ; A5B9 00                       .
        brk                                     ; A5BA 00                       .
        iny                                     ; A5BB C8                       .
        sed                                     ; A5BC F8                       .
        brk                                     ; A5BD 00                       .
        brk                                     ; A5BE 00                       .
        iny                                     ; A5BF C8                       .
LA5C0:  bpl     LA638                           ; A5C0 10 76                    .v
        ora     ($10,x)                         ; A5C2 01 10                    ..
        clc                                     ; A5C4 18                       .
        ror     $01,x                           ; A5C5 76 01                    v.
        dey                                     ; A5C7 88                       .
        bmi     LA640                           ; A5C8 30 76                    0v
        ora     ($38,x)                         ; A5CA 01 38                    .8
        bvc     LA644                           ; A5CC 50 76                    Pv
        ora     ($C8,x)                         ; A5CE 01 C8                    ..
        bcc     LA648                           ; A5D0 90 76                    .v
        ora     ($70,x)                         ; A5D2 01 70                    .p
        bcs     LA64C                           ; A5D4 B0 76                    .v
        ora     ($E0,x)                         ; A5D6 01 E0                    ..
        bne     LA650                           ; A5D8 D0 76                    .v
        ora     ($B8,x)                         ; A5DA 01 B8                    ..
        cld                                     ; A5DC D8                       .
        ror     $01,x                           ; A5DD 76 01                    v.
        clc                                     ; A5DF 18                       .
        jsr     L0177                           ; A5E0 20 77 01                  w.
        plp                                     ; A5E3 28                       (
        plp                                     ; A5E4 28                       (
        .byte   $77                             ; A5E5 77                       w
        ora     ($A8,x)                         ; A5E6 01 A8                    ..
        sec                                     ; A5E8 38                       8
        .byte   $77                             ; A5E9 77                       w
        ora     ($C0,x)                         ; A5EA 01 C0                    ..
        cli                                     ; A5EC 58                       X
        .byte   $77                             ; A5ED 77                       w
        ora     ($88,x)                         ; A5EE 01 88                    ..
        pla                                     ; A5F0 68                       h
        .byte   $77                             ; A5F1 77                       w
        ora     ($40,x)                         ; A5F2 01 40                    .@
LA5F4:  tya                                     ; A5F4 98                       .
        .byte   $77                             ; A5F5 77                       w
        ora     ($50,x)                         ; A5F6 01 50                    .P
        ldy     #$77                            ; A5F8 A0 77                    .w
        ora     ($C0,x)                         ; A5FA 01 C0                    ..
        clv                                     ; A5FC B8                       .
        .byte   $77                             ; A5FD 77                       w
        ora     ($28,x)                         ; A5FE 01 28                    .(
        iny                                     ; A600 C8                       .
        .byte   $77                             ; A601 77                       w
        ora     ($78,x)                         ; A602 01 78                    .x
LA604:  and     ($83,x)                         ; A604 21 83                    !.
        php                                     ; A606 08                       .
        ora     ($01,x)                         ; A607 01 01                    ..
        ora     ($01,x)                         ; A609 01 01                    ..
        ora     ($01,x)                         ; A60B 01 01                    ..
        ora     ($01,x)                         ; A60D 01 01                    ..
        ora     ($21,x)                         ; A60F 01 21                    .!
        cpy     $07                             ; A611 C4 07                    ..
        ora     ($01,x)                         ; A613 01 01                    ..
        ora     ($01,x)                         ; A615 01 01                    ..
        ora     ($01,x)                         ; A617 01 01                    ..
LA619:  ora     ($01,x)                         ; A619 01 01                    ..
        and     ($E7,x)                         ; A61B 21 E7                    !.
        .byte   $03                             ; A61D 03                       .
        ora     ($01,x)                         ; A61E 01 01                    ..
        ora     ($01,x)                         ; A620 01 01                    ..
        and     ($B5,x)                         ; A622 21 B5                    !.
        .byte   $07                             ; A624 07                       .
LA625:  ora     ($01,x)                         ; A625 01 01                    ..
        ora     ($01,x)                         ; A627 01 01                    ..
        ora     ($01,x)                         ; A629 01 01                    ..
        ora     ($01,x)                         ; A62B 01 01                    ..
        and     ($F3,x)                         ; A62D 21 F3                    !.
        asl     a                               ; A62F 0A                       .
        ora     ($01,x)                         ; A630 01 01                    ..
        ora     ($01,x)                         ; A632 01 01                    ..
        ora     ($01,x)                         ; A634 01 01                    ..
        ora     ($01,x)                         ; A636 01 01                    ..
LA638:  ora     ($01,x)                         ; A638 01 01                    ..
        ora     ($22,x)                         ; A63A 01 22                    ."
        asl     $06,x                           ; A63C 16 06                    ..
        ora     ($01,x)                         ; A63E 01 01                    ..
LA640:  ora     ($01,x)                         ; A640 01 01                    ..
        ora     ($01,x)                         ; A642 01 01                    ..
LA644:  ora     ($FF,x)                         ; A644 01 FF                    ..
LA646:  and     ($64,x)                         ; A646 21 64                    !d
LA648:  ora     #$01                            ; A648 09 01                    ..
        ora     ($01,x)                         ; A64A 01 01                    ..
LA64C:  ora     ($01,x)                         ; A64C 01 01                    ..
        ora     ($01,x)                         ; A64E 01 01                    ..
LA650:  ora     ($01,x)                         ; A650 01 01                    ..
        ora     ($21,x)                         ; A652 01 21                    .!
        sta     L0008                           ; A654 85 08                    ..
        ora     ($01,x)                         ; A656 01 01                    ..
        ora     ($01,x)                         ; A658 01 01                    ..
        ora     ($01,x)                         ; A65A 01 01                    ..
        ora     ($01,x)                         ; A65C 01 01                    ..
        ora     ($21,x)                         ; A65E 01 21                    .!
        cpx     L0008                           ; A660 E4 08                    ..
        ora     ($01,x)                         ; A662 01 01                    ..
        ora     ($01,x)                         ; A664 01 01                    ..
        ora     ($01,x)                         ; A666 01 01                    ..
        ora     ($01,x)                         ; A668 01 01                    ..
        ora     ($22,x)                         ; A66A 01 22                    ."
        ora     L0008                           ; A66C 05 08                    ..
        ora     ($01,x)                         ; A66E 01 01                    ..
        ora     ($01,x)                         ; A670 01 01                    ..
        ora     ($01,x)                         ; A672 01 01                    ..
        ora     ($01,x)                         ; A674 01 01                    ..
        ora     ($21,x)                         ; A676 01 21                    .!
        .byte   $73                             ; A678 73                       s
        php                                     ; A679 08                       .
        ora     ($01,x)                         ; A67A 01 01                    ..
        ora     ($01,x)                         ; A67C 01 01                    ..
        ora     ($01,x)                         ; A67E 01 01                    ..
        ora     ($01,x)                         ; A680 01 01                    ..
        ora     ($21,x)                         ; A682 01 21                    .!
        sty     L0008,x                         ; A684 94 08                    ..
        ora     ($01,x)                         ; A686 01 01                    ..
        ora     ($01,x)                         ; A688 01 01                    ..
        ora     ($01,x)                         ; A68A 01 01                    ..
        ora     ($01,x)                         ; A68C 01 01                    ..
        ora     ($21,x)                         ; A68E 01 21                    .!
        .byte   $F3                             ; A690 F3                       .
        ora     #$01                            ; A691 09 01                    ..
        ora     ($01,x)                         ; A693 01 01                    ..
        ora     ($01,x)                         ; A695 01 01                    ..
        ora     ($01,x)                         ; A697 01 01                    ..
        ora     ($01,x)                         ; A699 01 01                    ..
        ora     ($22,x)                         ; A69B 01 22                    ."
        .byte   $14                             ; A69D 14                       .
        asl     a                               ; A69E 0A                       .
        ora     ($01,x)                         ; A69F 01 01                    ..
        ora     ($01,x)                         ; A6A1 01 01                    ..
        ora     ($01,x)                         ; A6A3 01 01                    ..
        ora     ($01,x)                         ; A6A5 01 01                    ..
        ora     ($01,x)                         ; A6A7 01 01                    ..
        ora     ($FF,x)                         ; A6A9 01 FF                    ..
LA6AB:  ora     ($03,x)                         ; A6AB 01 03                    ..
LA6AD:  asl     L0008                           ; A6AD 06 08                    ..
        asl     a                               ; A6AF 0A                       .
        .byte   $0C                             ; A6B0 0C                       .
        asl     $1310                           ; A6B1 0E 10 13                 ...
        ora     $17,x                           ; A6B4 15 17                    ..
        ora     $1D1B,y                         ; A6B6 19 1B 1D                 ...
        ora     ($04,x)                         ; A6B9 01 04                    ..
        asl     L0008                           ; A6BB 06 08                    ..
        asl     a                               ; A6BD 0A                       .
        .byte   $0C                             ; A6BE 0C                       .
        asl     $1311                           ; A6BF 0E 11 13                 ...
        php                                     ; A6C2 08                       .
        .byte   $FF                             ; A6C3 FF                       .
LA6C4:  .byte   $0F                             ; A6C4 0F                       .
        jsr     L0F0F                           ; A6C5 20 0F 0F                  ..
        .byte   $0F                             ; A6C8 0F                       .
        jsr     L0F0F                           ; A6C9 20 0F 0F                  ..
        .byte   $0F                             ; A6CC 0F                       .
        jsr     L0F0F                           ; A6CD 20 0F 0F                  ..
        .byte   $0F                             ; A6D0 0F                       .
        jsr     L0F0F                           ; A6D1 20 0F 0F                  ..
LA6D4:  jsr     L1F00                           ; A6D4 20 00 1F                  ..
        brk                                     ; A6D7 00                       .
        brk                                     ; A6D8 00                       .
        brk                                     ; A6D9 00                       .
        brk                                     ; A6DA 00                       .
        brk                                     ; A6DB 00                       .
        brk                                     ; A6DC 00                       .
        brk                                     ; A6DD 00                       .
        brk                                     ; A6DE 00                       .
        brk                                     ; A6DF 00                       .
        brk                                     ; A6E0 00                       .
        brk                                     ; A6E1 00                       .
        brk                                     ; A6E2 00                       .
        brk                                     ; A6E3 00                       .
        brk                                     ; A6E4 00                       .
        brk                                     ; A6E5 00                       .
        brk                                     ; A6E6 00                       .
        brk                                     ; A6E7 00                       .
        brk                                     ; A6E8 00                       .
        brk                                     ; A6E9 00                       .
        brk                                     ; A6EA 00                       .
        brk                                     ; A6EB 00                       .
        brk                                     ; A6EC 00                       .
        brk                                     ; A6ED 00                       .
        brk                                     ; A6EE 00                       .
        brk                                     ; A6EF 00                       .
        brk                                     ; A6F0 00                       .
        brk                                     ; A6F1 00                       .
        brk                                     ; A6F2 00                       .
        brk                                     ; A6F3 00                       .
        brk                                     ; A6F4 00                       .
        brk                                     ; A6F5 00                       .
        brk                                     ; A6F6 00                       .
        .byte   $FF                             ; A6F7 FF                       .
LA6F8:  jsr     L2020                           ; A6F8 20 20 20                    
        jsr     L2020                           ; A6FB 20 20 20                    
        jsr     L2120                           ; A6FE 20 20 21                   !
        and     ($21,x)                         ; A701 21 21                    !!
        and     ($21,x)                         ; A703 21 21                    !!
        and     ($21,x)                         ; A705 21 21                    !!
        and     ($22,x)                         ; A707 21 22                    !"
        .byte   $22                             ; A709 22                       "
        .byte   $22                             ; A70A 22                       "
        .byte   $22                             ; A70B 22                       "
        .byte   $22                             ; A70C 22                       "
        .byte   $22                             ; A70D 22                       "
        .byte   $22                             ; A70E 22                       "
        .byte   $22                             ; A70F 22                       "
        .byte   $23                             ; A710 23                       #
        .byte   $23                             ; A711 23                       #
        .byte   $23                             ; A712 23                       #
        .byte   $23                             ; A713 23                       #
LA714:  .byte   $23                             ; A714 23                       #
        .byte   $23                             ; A715 23                       #
        .byte   $23                             ; A716 23                       #
        .byte   $23                             ; A717 23                       #
LA718:  brk                                     ; A718 00                       .
        jsr     L6040                           ; A719 20 40 60                  @`
        .byte   $80                             ; A71C 80                       .
        ldy     #$C0                            ; A71D A0 C0                    ..
        cpx     #$00                            ; A71F E0 00                    ..
        jsr     L6040                           ; A721 20 40 60                  @`
        .byte   $80                             ; A724 80                       .
        ldy     #$C0                            ; A725 A0 C0                    ..
        cpx     #$00                            ; A727 E0 00                    ..
        jsr     L6040                           ; A729 20 40 60                  @`
        .byte   $80                             ; A72C 80                       .
        ldy     #$C0                            ; A72D A0 C0                    ..
        cpx     #$00                            ; A72F E0 00                    ..
        jsr     L6040                           ; A731 20 40 60                  @`
        .byte   $80                             ; A734 80                       .
        ldy     #$C0                            ; A735 A0 C0                    ..
        .byte   $E0                             ; A737 E0                       .
LA738:  jmp     (L7C74)                         ; A738 6C 74 7C                 lt|

; ----------------------------------------------------------------------------
        sty     $8C                             ; A73B 84 8C                    ..
        .byte   $94                             ; A73D 94                       .
LA73E:  eor     $4F4E                           ; A73E 4D 4E 4F                 MNO
        bvc     LA794                           ; A741 50 51                    PQ
        .byte   $52                             ; A743 52                       R
LA744:  .byte   $43                             ; A744 43                       C
        eor     ($50,x)                         ; A745 41 50                    AP
        .byte   $43                             ; A747 43                       C
        .byte   $4F                             ; A748 4F                       O
        eor     $15FB                           ; A749 4D FB 15                 M..
        .byte   $FF                             ; A74C FF                       .
        .byte   $5F                             ; A74D 5F                       _
        .byte   $FF                             ; A74E FF                       .
        eor     $7FFF,x                         ; A74F 5D FF 7F                 ]..
        sbc     $FF7F,y                         ; A752 F9 7F FF                 ...
        .byte   $F7                             ; A755 F7                       .
        .byte   $FF                             ; A756 FF                       .
        .byte   $FF                             ; A757 FF                       .
        .byte   $FF                             ; A758 FF                       .
        .byte   $FF                             ; A759 FF                       .
        .byte   $FF                             ; A75A FF                       .
        .byte   $FF                             ; A75B FF                       .
        .byte   $FF                             ; A75C FF                       .
        .byte   $7F                             ; A75D 7F                       .
        .byte   $FF                             ; A75E FF                       .
        .byte   $FF                             ; A75F FF                       .
        .byte   $FF                             ; A760 FF                       .
        cmp     $FA,x                           ; A761 D5 FA                    ..
        sta     $FA,x                           ; A763 95 FA                    ..
        sta     $FE,x                           ; A765 95 FE                    ..
        adc     ($F9),y                         ; A767 71 F9                    q.
        eor     $15DF,x                         ; A769 5D DF 15                 ]..
        inc     $DD54,x                         ; A76C FE 54 DD                 .T.
        adc     $6F,x                           ; A76F 75 6F                    uo
        eor     ($F7),y                         ; A771 51 F7                    Q.
        bvs     LA714                           ; A773 70 9F                    p.
        adc     $54FF,y                         ; A775 79 FF 54                 y.T
        .byte   $FF                             ; A778 FF                       .
        .byte   $F7                             ; A779 F7                       .
        .byte   $BF                             ; A77A BF                       .
        adc     $77FF,x                         ; A77B 7D FF 77                 }.w
        .byte   $FF                             ; A77E FF                       .
        .byte   $77                             ; A77F 77                       w
        ldx     $FE54,y                         ; A780 BE 54 FE                 .T.
        eor     $FF,x                           ; A783 55 FF                    U.
        eor     $FF,x                           ; A785 55 FF                    U.
        .byte   $F4                             ; A787 F4                       .
        .byte   $FF                             ; A788 FF                       .
        .byte   $7C                             ; A789 7C                       |
        .byte   $FF                             ; A78A FF                       .
        cmp     $FF,x                           ; A78B D5 FF                    ..
        .byte   $DF                             ; A78D DF                       .
        .byte   $FF                             ; A78E FF                       .
        .byte   $35                             ; A78F 35                       5
LA790:  .byte   $FF                             ; A790 FF                       .
        sbc     $7FFF,x                         ; A791 FD FF 7F                 ...
LA794:  .byte   $FF                             ; A794 FF                       .
        eor     $FF,x                           ; A795 55 FF                    U.
        adc     $FFFF,x                         ; A797 7D FF FF                 }..
        .byte   $FF                             ; A79A FF                       .
        .byte   $FF                             ; A79B FF                       .
        .byte   $FF                             ; A79C FF                       .
        .byte   $FF                             ; A79D FF                       .
        .byte   $FF                             ; A79E FF                       .
        sbc     $51EE,x                         ; A79F FD EE 51                 ..Q
        adc     $45,x                           ; A7A2 75 45                    uE
        sbc     LBFD1,x                         ; A7A4 FD D1 BF                 ...
        eor     $D5                             ; A7A7 45 D5                    E.
        .byte   $D0                             ; A7A9 D0                       .
LA7AA:  .byte   $FF                             ; A7AA FF                       .
        asl     $71FF,x                         ; A7AB 1E FF 71                 ..q
        .byte   $7F                             ; A7AE 7F                       .
        .byte   $57                             ; A7AF 57                       W
        .byte   $FF                             ; A7B0 FF                       .
        eor     $FF,x                           ; A7B1 55 FF                    U.
        eor     $FF,x                           ; A7B3 55 FF                    U.
        .byte   $DF                             ; A7B5 DF                       .
        cmp     $FF7D,x                         ; A7B6 DD 7D FF                 .}.
        .byte   $7F                             ; A7B9 7F                       .
        .byte   $FF                             ; A7BA FF                       .
        .byte   $57                             ; A7BB 57                       W
        .byte   $FF                             ; A7BC FF                       .
        .byte   $F7                             ; A7BD F7                       .
        .byte   $FF                             ; A7BE FF                       .
        .byte   $FF                             ; A7BF FF                       .
        .byte   $FF                             ; A7C0 FF                       .
        ora     $A5,x                           ; A7C1 15 A5                    ..
        ora     $FF,x                           ; A7C3 15 FF                    ..
        eor     $75FF,x                         ; A7C5 5D FF 75                 ].u
        ror     $EF74,x                         ; A7C8 7E 74 EF                 ~t.
        and     $FF,x                           ; A7CB 35 FF                    5.
        .byte   $57                             ; A7CD 57                       W
        inc     $FF75,x                         ; A7CE FE 75 FF                 .u.
        sbc     $F5FF,x                         ; A7D1 FD FF F5                 ...
        .byte   $FF                             ; A7D4 FF                       .
        .byte   $77                             ; A7D5 77                       w
        .byte   $FF                             ; A7D6 FF                       .
        sbc     $D7FF,x                         ; A7D7 FD FF D7                 ...
        .byte   $FF                             ; A7DA FF                       .
        .byte   $5F                             ; A7DB 5F                       _
        .byte   $FF                             ; A7DC FF                       .
        .byte   $FF                             ; A7DD FF                       .
        .byte   $FF                             ; A7DE FF                       .
        .byte   $FF                             ; A7DF FF                       .
        .byte   $F7                             ; A7E0 F7                       .
        lsr     $DD                             ; A7E1 46 DD                    F.
        .byte   $54                             ; A7E3 54                       T
        .byte   $EF                             ; A7E4 EF                       .
        eor     $51EE,x                         ; A7E5 5D EE 51                 ].Q
        .byte   $A3                             ; A7E8 A3                       .
        .byte   $74                             ; A7E9 74                       t
        .byte   $7F                             ; A7EA 7F                       .
        .byte   $5C                             ; A7EB 5C                       \
        cmp     $04                             ; A7EC C5 04                    ..
        lda     $E711,x                         ; A7EE BD 11 E7                 ...
        ora     $6B,x                           ; A7F1 15 6B                    .k
        bne     LA790                           ; A7F3 D0 9B                    ..
        eor     $77                             ; A7F5 45 77                    Ew
        .byte   $54                             ; A7F7 54                       T
        .byte   $FF                             ; A7F8 FF                       .
        .byte   $53                             ; A7F9 53                       S
        .byte   $5F                             ; A7FA 5F                       _
        .byte   $D7                             ; A7FB D7                       .
        .byte   $FF                             ; A7FC FF                       .
        sbc     $FF,x                           ; A7FD F5 FF                    ..
        .byte   $77                             ; A7FF 77                       w
LA800:  brk                                     ; A800 00                       .
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
        brk                                     ; A810 00                       .
        brk                                     ; A811 00                       .
        brk                                     ; A812 00                       .
        brk                                     ; A813 00                       .
        brk                                     ; A814 00                       .
        brk                                     ; A815 00                       .
        brk                                     ; A816 00                       .
        brk                                     ; A817 00                       .
        brk                                     ; A818 00                       .
        brk                                     ; A819 00                       .
        brk                                     ; A81A 00                       .
        brk                                     ; A81B 00                       .
        brk                                     ; A81C 00                       .
        brk                                     ; A81D 00                       .
        brk                                     ; A81E 00                       .
        brk                                     ; A81F 00                       .
        brk                                     ; A820 00                       .
        brk                                     ; A821 00                       .
        brk                                     ; A822 00                       .
        brk                                     ; A823 00                       .
        brk                                     ; A824 00                       .
        brk                                     ; A825 00                       .
        brk                                     ; A826 00                       .
        brk                                     ; A827 00                       .
        brk                                     ; A828 00                       .
        brk                                     ; A829 00                       .
        brk                                     ; A82A 00                       .
        brk                                     ; A82B 00                       .
        brk                                     ; A82C 00                       .
        brk                                     ; A82D 00                       .
        brk                                     ; A82E 00                       .
        brk                                     ; A82F 00                       .
        brk                                     ; A830 00                       .
        brk                                     ; A831 00                       .
        brk                                     ; A832 00                       .
        brk                                     ; A833 00                       .
        brk                                     ; A834 00                       .
        brk                                     ; A835 00                       .
        brk                                     ; A836 00                       .
        brk                                     ; A837 00                       .
        brk                                     ; A838 00                       .
        brk                                     ; A839 00                       .
        brk                                     ; A83A 00                       .
        brk                                     ; A83B 00                       .
        brk                                     ; A83C 00                       .
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
        brk                                     ; A850 00                       .
        brk                                     ; A851 00                       .
        brk                                     ; A852 00                       .
        brk                                     ; A853 00                       .
        brk                                     ; A854 00                       .
        brk                                     ; A855 00                       .
        brk                                     ; A856 00                       .
        brk                                     ; A857 00                       .
        brk                                     ; A858 00                       .
        brk                                     ; A859 00                       .
        brk                                     ; A85A 00                       .
        brk                                     ; A85B 00                       .
        brk                                     ; A85C 00                       .
        brk                                     ; A85D 00                       .
        brk                                     ; A85E 00                       .
        brk                                     ; A85F 00                       .
        brk                                     ; A860 00                       .
        brk                                     ; A861 00                       .
        brk                                     ; A862 00                       .
        brk                                     ; A863 00                       .
        brk                                     ; A864 00                       .
        brk                                     ; A865 00                       .
        brk                                     ; A866 00                       .
        brk                                     ; A867 00                       .
        brk                                     ; A868 00                       .
        brk                                     ; A869 00                       .
        brk                                     ; A86A 00                       .
        brk                                     ; A86B 00                       .
        brk                                     ; A86C 00                       .
        brk                                     ; A86D 00                       .
        brk                                     ; A86E 00                       .
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
        brk                                     ; A87C 00                       .
        brk                                     ; A87D 00                       .
        brk                                     ; A87E 00                       .
        brk                                     ; A87F 00                       .
        brk                                     ; A880 00                       .
        brk                                     ; A881 00                       .
        brk                                     ; A882 00                       .
        brk                                     ; A883 00                       .
        brk                                     ; A884 00                       .
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
        brk                                     ; A89E 00                       .
        brk                                     ; A89F 00                       .
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
        brk                                     ; A8BD 00                       .
        brk                                     ; A8BE 00                       .
        brk                                     ; A8BF 00                       .
        brk                                     ; A8C0 00                       .
        brk                                     ; A8C1 00                       .
        brk                                     ; A8C2 00                       .
        brk                                     ; A8C3 00                       .
        brk                                     ; A8C4 00                       .
        brk                                     ; A8C5 00                       .
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
LA900:  .byte   $02                             ; A900 02                       .
        .byte   $03                             ; A901 03                       .
        .byte   $04                             ; A902 04                       .
        ora     $06                             ; A903 05 06                    ..
        asl     $06                             ; A905 06 06                    ..
        .byte   $13                             ; A907 13                       .
        ora     $15,x                           ; A908 15 15                    ..
        and     ($1B,x)                         ; A90A 21 1B                    !.
        asl     $1C,x                           ; A90C 16 1C                    ..
        .byte   $1C                             ; A90E 1C                       .
        .byte   $1C                             ; A90F 1C                       .
        brk                                     ; A910 00                       .
        brk                                     ; A911 00                       .
        brk                                     ; A912 00                       .
        brk                                     ; A913 00                       .
        brk                                     ; A914 00                       .
        brk                                     ; A915 00                       .
        brk                                     ; A916 00                       .
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
        jsr     L8400                           ; A921 20 00 84                  ..
        brk                                     ; A924 00                       .
        .byte   $02                             ; A925 02                       .
        brk                                     ; A926 00                       .
        brk                                     ; A927 00                       .
        .byte   $02                             ; A928 02                       .
        brk                                     ; A929 00                       .
        .byte   $80                             ; A92A 80                       .
        brk                                     ; A92B 00                       .
        brk                                     ; A92C 00                       .
        brk                                     ; A92D 00                       .
        brk                                     ; A92E 00                       .
        .byte   $04                             ; A92F 04                       .
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
        jsr     L2800                           ; A940 20 00 28                  .(
        brk                                     ; A943 00                       .
        brk                                     ; A944 00                       .
        brk                                     ; A945 00                       .
        brk                                     ; A946 00                       .
        brk                                     ; A947 00                       .
        brk                                     ; A948 00                       .
        jsr     L0000                           ; A949 20 00 00                  ..
        brk                                     ; A94C 00                       .
        brk                                     ; A94D 00                       .
        brk                                     ; A94E 00                       .
        brk                                     ; A94F 00                       .
        .byte   $22                             ; A950 22                       "
        jsr     L0020                           ; A951 20 20 00                   .
        jsr     L0000                           ; A954 20 00 00                  ..
        brk                                     ; A957 00                       .
        brk                                     ; A958 00                       .
        brk                                     ; A959 00                       .
        brk                                     ; A95A 00                       .
        brk                                     ; A95B 00                       .
        brk                                     ; A95C 00                       .
        brk                                     ; A95D 00                       .
        brk                                     ; A95E 00                       .
        brk                                     ; A95F 00                       .
        brk                                     ; A960 00                       .
        bpl     LA963                           ; A961 10 00                    ..
LA963:  brk                                     ; A963 00                       .
        .byte   $22                             ; A964 22                       "
        brk                                     ; A965 00                       .
        php                                     ; A966 08                       .
        php                                     ; A967 08                       .
        ora     #$00                            ; A968 09 00                    ..
        .byte   $0F                             ; A96A 0F                       .
        brk                                     ; A96B 00                       .
        .byte   $80                             ; A96C 80                       .
        brk                                     ; A96D 00                       .
        brk                                     ; A96E 00                       .
        .byte   $22                             ; A96F 22                       "
        .byte   $80                             ; A970 80                       .
        ora     (L0000,x)                       ; A971 01 00                    ..
        sty     L0000                           ; A973 84 00                    ..
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
        clv                                     ; A980 B8                       .
        bcs     LA9A3                           ; A981 B0 20                    . 
        .byte   $80                             ; A983 80                       .
        brk                                     ; A984 00                       .
        php                                     ; A985 08                       .
        brk                                     ; A986 00                       .
        brk                                     ; A987 00                       .
        .byte   $0F                             ; A988 0F                       .
        bmi     LA9AD                           ; A989 30 22                    0"
        .byte   $13                             ; A98B 13                       .
        .byte   $0F                             ; A98C 0F                       .
        bmi     LA9B6                           ; A98D 30 27                    0'
        .byte   $07                             ; A98F 07                       .
        .byte   $0F                             ; A990 0F                       .
        bmi     LA9BF                           ; A991 30 2C                    0,
        .byte   $0C                             ; A993 0C                       .
        .byte   $0F                             ; A994 0F                       .
        .byte   $0F                             ; A995 0F                       .
        and     ($09,x)                         ; A996 21 09                    !.
        brk                                     ; A998 00                       .
        brk                                     ; A999 00                       .
        brk                                     ; A99A 00                       .
        sta     $300F,y                         ; A99B 99 0F 30                 ..0
        .byte   $22                             ; A99E 22                       "
        .byte   $13                             ; A99F 13                       .
        .byte   $0F                             ; A9A0 0F                       .
        bmi     LA9CA                           ; A9A1 30 27                    0'
LA9A3:  .byte   $07                             ; A9A3 07                       .
        .byte   $0F                             ; A9A4 0F                       .
        bmi     LA9C9                           ; A9A5 30 22                    0"
        .byte   $13                             ; A9A7 13                       .
        .byte   $0F                             ; A9A8 0F                       .
        bmi     LA9D0                           ; A9A9 30 25                    0%
        ora     L0000,x                         ; A9AB 15 00                    ..
LA9AD:  brk                                     ; A9AD 00                       .
        brk                                     ; A9AE 00                       .
        brk                                     ; A9AF 00                       .
        brk                                     ; A9B0 00                       .
        jsr     L0008                           ; A9B1 20 08 00                  ..
        brk                                     ; A9B4 00                       .
        brk                                     ; A9B5 00                       .
LA9B6:  brk                                     ; A9B6 00                       .
        brk                                     ; A9B7 00                       .
        brk                                     ; A9B8 00                       .
        brk                                     ; A9B9 00                       .
        brk                                     ; A9BA 00                       .
        brk                                     ; A9BB 00                       .
        brk                                     ; A9BC 00                       .
        brk                                     ; A9BD 00                       .
        brk                                     ; A9BE 00                       .
LA9BF:  brk                                     ; A9BF 00                       .
        plp                                     ; A9C0 28                       (
        brk                                     ; A9C1 00                       .
        .byte   $02                             ; A9C2 02                       .
        .byte   $04                             ; A9C3 04                       .
        .byte   $02                             ; A9C4 02                       .
        brk                                     ; A9C5 00                       .
        brk                                     ; A9C6 00                       .
        sty     L0000                           ; A9C7 84 00                    ..
LA9C9:  brk                                     ; A9C9 00                       .
LA9CA:  jsr     L2000                           ; A9CA 20 00 20                  . 
        brk                                     ; A9CD 00                       .
        brk                                     ; A9CE 00                       .
        brk                                     ; A9CF 00                       .
LA9D0:  brk                                     ; A9D0 00                       .
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
        brk                                     ; A9E5 00                       .
        brk                                     ; A9E6 00                       .
        rti                                     ; A9E7 40                       @

; ----------------------------------------------------------------------------
        ldy     #$00                            ; A9E8 A0 00                    ..
        .byte   $80                             ; A9EA 80                       .
        ldy     #$00                            ; A9EB A0 00                    ..
        bpl     LA9F9                           ; A9ED 10 0A                    ..
        .byte   $82                             ; A9EF 82                       .
        brk                                     ; A9F0 00                       .
        brk                                     ; A9F1 00                       .
        .byte   $22                             ; A9F2 22                       "
        php                                     ; A9F3 08                       .
        plp                                     ; A9F4 28                       (
        php                                     ; A9F5 08                       .
        brk                                     ; A9F6 00                       .
        brk                                     ; A9F7 00                       .
        .byte   $20                             ; A9F8 20                        
LA9F9:  brk                                     ; A9F9 00                       .
        brk                                     ; A9FA 00                       .
        brk                                     ; A9FB 00                       .
        brk                                     ; A9FC 00                       .
        brk                                     ; A9FD 00                       .
        brk                                     ; A9FE 00                       .
        brk                                     ; A9FF 00                       .
        brk                                     ; AA00 00                       .
        brk                                     ; AA01 00                       .
        .byte   $02                             ; AA02 02                       .
        .byte   $02                             ; AA03 02                       .
        .byte   $03                             ; AA04 03                       .
        .byte   $03                             ; AA05 03                       .
        .byte   $03                             ; AA06 03                       .
        .byte   $03                             ; AA07 03                       .
        .byte   $03                             ; AA08 03                       .
        .byte   $03                             ; AA09 03                       .
        .byte   $03                             ; AA0A 03                       .
        .byte   $03                             ; AA0B 03                       .
        .byte   $03                             ; AA0C 03                       .
        .byte   $04                             ; AA0D 04                       .
        php                                     ; AA0E 08                       .
        ora     #$0A                            ; AA0F 09 0A                    ..
        .byte   $0B                             ; AA11 0B                       .
        .byte   $0C                             ; AA12 0C                       .
        ora     $0F0E                           ; AA13 0D 0E 0F                 ...
        .byte   $FF                             ; AA16 FF                       .
        brk                                     ; AA17 00                       .
        brk                                     ; AA18 00                       .
        brk                                     ; AA19 00                       .
        brk                                     ; AA1A 00                       .
        brk                                     ; AA1B 00                       .
        brk                                     ; AA1C 00                       .
        brk                                     ; AA1D 00                       .
        brk                                     ; AA1E 00                       .
        brk                                     ; AA1F 00                       .
        php                                     ; AA20 08                       .
        jsr     L0000                           ; AA21 20 00 00                  ..
        brk                                     ; AA24 00                       .
        ora     (L0000,x)                       ; AA25 01 00                    ..
        .byte   $04                             ; AA27 04                       .
        brk                                     ; AA28 00                       .
        brk                                     ; AA29 00                       .
        brk                                     ; AA2A 00                       .
        brk                                     ; AA2B 00                       .
        brk                                     ; AA2C 00                       .
        rti                                     ; AA2D 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AA2E 00                       .
        brk                                     ; AA2F 00                       .
        brk                                     ; AA30 00                       .
        brk                                     ; AA31 00                       .
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
        asl     a                               ; AA40 0A                       .
        brk                                     ; AA41 00                       .
        brk                                     ; AA42 00                       .
        .byte   $80                             ; AA43 80                       .
        brk                                     ; AA44 00                       .
        bpl     LAA47                           ; AA45 10 00                    ..
LAA47:  brk                                     ; AA47 00                       .
        brk                                     ; AA48 00                       .
        bpl     LAA4B                           ; AA49 10 00                    ..
LAA4B:  bpl     LAA4D                           ; AA4B 10 00                    ..
LAA4D:  brk                                     ; AA4D 00                       .
        brk                                     ; AA4E 00                       .
        brk                                     ; AA4F 00                       .
        brk                                     ; AA50 00                       .
        brk                                     ; AA51 00                       .
LAA52:  brk                                     ; AA52 00                       .
        brk                                     ; AA53 00                       .
LAA54:  brk                                     ; AA54 00                       .
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
        .byte   $04                             ; AA61 04                       .
        brk                                     ; AA62 00                       .
        .byte   $44                             ; AA63 44                       D
        brk                                     ; AA64 00                       .
        eor     (L0000,x)                       ; AA65 41 00                    A.
        .byte   $02                             ; AA67 02                       .
        plp                                     ; AA68 28                       (
        jsr     L0000                           ; AA69 20 00 00                  ..
        brk                                     ; AA6C 00                       .
        brk                                     ; AA6D 00                       .
        brk                                     ; AA6E 00                       .
        ora     (L0008,x)                       ; AA6F 01 08                    ..
        brk                                     ; AA71 00                       .
        brk                                     ; AA72 00                       .
        .byte   $02                             ; AA73 02                       .
        brk                                     ; AA74 00                       .
        php                                     ; AA75 08                       .
        brk                                     ; AA76 00                       .
        bpl     LAA79                           ; AA77 10 00                    ..
LAA79:  brk                                     ; AA79 00                       .
        brk                                     ; AA7A 00                       .
        brk                                     ; AA7B 00                       .
        brk                                     ; AA7C 00                       .
        brk                                     ; AA7D 00                       .
        brk                                     ; AA7E 00                       .
        brk                                     ; AA7F 00                       .
        bmi     LAA52                           ; AA80 30 D0                    0.
        bcs     LAA54                           ; AA82 B0 D0                    ..
        jsr     L2020                           ; AA84 20 20 20                    
        .byte   $80                             ; AA87 80                       .
        .byte   $80                             ; AA88 80                       .
        cpx     #$E0                            ; AA89 E0 E0                    ..
        cpx     #$80                            ; AA8B E0 80                    ..
        .byte   $80                             ; AA8D 80                       .
        cld                                     ; AA8E D8                       .
        cld                                     ; AA8F D8                       .
        cld                                     ; AA90 D8                       .
        cld                                     ; AA91 D8                       .
        cld                                     ; AA92 D8                       .
        cld                                     ; AA93 D8                       .
        cld                                     ; AA94 D8                       .
        cld                                     ; AA95 D8                       .
        .byte   $FF                             ; AA96 FF                       .
        brk                                     ; AA97 00                       .
        brk                                     ; AA98 00                       .
        brk                                     ; AA99 00                       .
        brk                                     ; AA9A 00                       .
        brk                                     ; AA9B 00                       .
        brk                                     ; AA9C 00                       .
        brk                                     ; AA9D 00                       .
        brk                                     ; AA9E 00                       .
        brk                                     ; AA9F 00                       .
        brk                                     ; AAA0 00                       .
        .byte   $02                             ; AAA1 02                       .
        php                                     ; AAA2 08                       .
        .byte   $80                             ; AAA3 80                       .
        brk                                     ; AAA4 00                       .
        pha                                     ; AAA5 48                       H
        brk                                     ; AAA6 00                       .
        .byte   $02                             ; AAA7 02                       .
        .byte   $80                             ; AAA8 80                       .
        ora     (L0000,x)                       ; AAA9 01 00                    ..
        brk                                     ; AAAB 00                       .
        brk                                     ; AAAC 00                       .
        .byte   $04                             ; AAAD 04                       .
        brk                                     ; AAAE 00                       .
        asl     a                               ; AAAF 0A                       .
        brk                                     ; AAB0 00                       .
        brk                                     ; AAB1 00                       .
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
LAABC:  brk                                     ; AABC 00                       .
        brk                                     ; AABD 00                       .
        brk                                     ; AABE 00                       .
        brk                                     ; AABF 00                       .
        brk                                     ; AAC0 00                       .
        bvc     LAAC3                           ; AAC1 50 00                    P.
LAAC3:  .byte   $02                             ; AAC3 02                       .
        brk                                     ; AAC4 00                       .
        brk                                     ; AAC5 00                       .
        brk                                     ; AAC6 00                       .
        .byte   $02                             ; AAC7 02                       .
        brk                                     ; AAC8 00                       .
        brk                                     ; AAC9 00                       .
        brk                                     ; AACA 00                       .
        brk                                     ; AACB 00                       .
        brk                                     ; AACC 00                       .
        bpl     LAACF                           ; AACD 10 00                    ..
LAACF:  brk                                     ; AACF 00                       .
        .byte   $80                             ; AAD0 80                       .
        brk                                     ; AAD1 00                       .
        brk                                     ; AAD2 00                       .
        brk                                     ; AAD3 00                       .
        brk                                     ; AAD4 00                       .
        php                                     ; AAD5 08                       .
        brk                                     ; AAD6 00                       .
        brk                                     ; AAD7 00                       .
        brk                                     ; AAD8 00                       .
        brk                                     ; AAD9 00                       .
        brk                                     ; AADA 00                       .
        bpl     LAADD                           ; AADB 10 00                    ..
LAADD:  brk                                     ; AADD 00                       .
        brk                                     ; AADE 00                       .
        brk                                     ; AADF 00                       .
        brk                                     ; AAE0 00                       .
        bvc     LAAE3                           ; AAE1 50 00                    P.
LAAE3:  php                                     ; AAE3 08                       .
        bpl     LAAE6                           ; AAE4 10 00                    ..
LAAE6:  brk                                     ; AAE6 00                       .
        jsr     L910A                           ; AAE7 20 0A 91                  ..
        brk                                     ; AAEA 00                       .
        .byte   $04                             ; AAEB 04                       .
        brk                                     ; AAEC 00                       .
        sta     (L0000,x)                       ; AAED 81 00                    ..
        rti                                     ; AAEF 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AAF0 00                       .
        .byte   $04                             ; AAF1 04                       .
        .byte   $80                             ; AAF2 80                       .
        brk                                     ; AAF3 00                       .
        brk                                     ; AAF4 00                       .
        brk                                     ; AAF5 00                       .
        .byte   $80                             ; AAF6 80                       .
        brk                                     ; AAF7 00                       .
        brk                                     ; AAF8 00                       .
        brk                                     ; AAF9 00                       .
        brk                                     ; AAFA 00                       .
        brk                                     ; AAFB 00                       .
        brk                                     ; AAFC 00                       .
        brk                                     ; AAFD 00                       .
        brk                                     ; AAFE 00                       .
        brk                                     ; AAFF 00                       .
        cli                                     ; AB00 58                       X
        cli                                     ; AB01 58                       X
        ldy     $B0,x                           ; AB02 B4 B0                    ..
        bmi     LAB76                           ; AB04 30 70                    0p
        bcs     LAB78                           ; AB06 B0 70                    .p
        bcs     LAB3A                           ; AB08 B0 30                    .0
        bvs     LAABC                           ; AB0A 70 B0                    p.
        bmi     LAB26                           ; AB0C 30 18                    0.
        brk                                     ; AB0E 00                       .
        brk                                     ; AB0F 00                       .
        brk                                     ; AB10 00                       .
        brk                                     ; AB11 00                       .
        brk                                     ; AB12 00                       .
        brk                                     ; AB13 00                       .
        brk                                     ; AB14 00                       .
        brk                                     ; AB15 00                       .
        .byte   $FF                             ; AB16 FF                       .
        brk                                     ; AB17 00                       .
        brk                                     ; AB18 00                       .
        brk                                     ; AB19 00                       .
        brk                                     ; AB1A 00                       .
        brk                                     ; AB1B 00                       .
        brk                                     ; AB1C 00                       .
        brk                                     ; AB1D 00                       .
        brk                                     ; AB1E 00                       .
        brk                                     ; AB1F 00                       .
        brk                                     ; AB20 00                       .
        ldy     #$02                            ; AB21 A0 02                    ..
        brk                                     ; AB23 00                       .
        brk                                     ; AB24 00                       .
        rts                                     ; AB25 60                       `

; ----------------------------------------------------------------------------
LAB26:  .byte   $80                             ; AB26 80                       .
        rti                                     ; AB27 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AB28 00                       .
        brk                                     ; AB29 00                       .
        brk                                     ; AB2A 00                       .
        brk                                     ; AB2B 00                       .
        .byte   $80                             ; AB2C 80                       .
        brk                                     ; AB2D 00                       .
        brk                                     ; AB2E 00                       .
        brk                                     ; AB2F 00                       .
        brk                                     ; AB30 00                       .
        brk                                     ; AB31 00                       .
        brk                                     ; AB32 00                       .
        brk                                     ; AB33 00                       .
        brk                                     ; AB34 00                       .
        brk                                     ; AB35 00                       .
        .byte   $02                             ; AB36 02                       .
        brk                                     ; AB37 00                       .
        brk                                     ; AB38 00                       .
        brk                                     ; AB39 00                       .
LAB3A:  brk                                     ; AB3A 00                       .
        brk                                     ; AB3B 00                       .
        brk                                     ; AB3C 00                       .
        brk                                     ; AB3D 00                       .
        brk                                     ; AB3E 00                       .
        brk                                     ; AB3F 00                       .
        php                                     ; AB40 08                       .
        rti                                     ; AB41 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AB42 00                       .
        brk                                     ; AB43 00                       .
        brk                                     ; AB44 00                       .
        brk                                     ; AB45 00                       .
        brk                                     ; AB46 00                       .
        php                                     ; AB47 08                       .
        brk                                     ; AB48 00                       .
        brk                                     ; AB49 00                       .
        brk                                     ; AB4A 00                       .
        bpl     LAB6D                           ; AB4B 10 20                    . 
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
        brk                                     ; AB5C 00                       .
        brk                                     ; AB5D 00                       .
        brk                                     ; AB5E 00                       .
        brk                                     ; AB5F 00                       .
        brk                                     ; AB60 00                       .
        brk                                     ; AB61 00                       .
        brk                                     ; AB62 00                       .
        rti                                     ; AB63 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AB64 00                       .
        .byte   $74                             ; AB65 74                       t
        brk                                     ; AB66 00                       .
        php                                     ; AB67 08                       .
        asl     a                               ; AB68 0A                       .
        .byte   $0C                             ; AB69 0C                       .
        .byte   $80                             ; AB6A 80                       .
        php                                     ; AB6B 08                       .
        brk                                     ; AB6C 00                       .
LAB6D:  and     (L0000,x)                       ; AB6D 21 00                    !.
        brk                                     ; AB6F 00                       .
        brk                                     ; AB70 00                       .
        rti                                     ; AB71 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AB72 00                       .
        brk                                     ; AB73 00                       .
        brk                                     ; AB74 00                       .
        brk                                     ; AB75 00                       .
LAB76:  brk                                     ; AB76 00                       .
        brk                                     ; AB77 00                       .
LAB78:  brk                                     ; AB78 00                       .
        brk                                     ; AB79 00                       .
        brk                                     ; AB7A 00                       .
        brk                                     ; AB7B 00                       .
        brk                                     ; AB7C 00                       .
        brk                                     ; AB7D 00                       .
        brk                                     ; AB7E 00                       .
        brk                                     ; AB7F 00                       .
        sta     ($82,x)                         ; AB80 81 82                    ..
        ora     $7070,x                         ; AB82 1D 70 70                 .pp
        bvs     LABF7                           ; AB85 70 70                    pp
        bvs     LABF9                           ; AB87 70 70                    pp
        bvs     LABFB                           ; AB89 70 70                    pp
        bvs     LABFD                           ; AB8B 70 70                    pp
        eor     $6765,x                         ; AB8D 5D 65 67                 ]eg
        .byte   $62                             ; AB90 62                       b
        .byte   $64                             ; AB91 64                       d
        adc     #$63                            ; AB92 69 63                    ic
        pla                                     ; AB94 68                       h
        ror     $FF                             ; AB95 66 FF                    f.
        brk                                     ; AB97 00                       .
        brk                                     ; AB98 00                       .
        brk                                     ; AB99 00                       .
        brk                                     ; AB9A 00                       .
        brk                                     ; AB9B 00                       .
        brk                                     ; AB9C 00                       .
        brk                                     ; AB9D 00                       .
        brk                                     ; AB9E 00                       .
        brk                                     ; AB9F 00                       .
        brk                                     ; ABA0 00                       .
        .byte   $80                             ; ABA1 80                       .
        brk                                     ; ABA2 00                       .
        brk                                     ; ABA3 00                       .
        brk                                     ; ABA4 00                       .
        .byte   $0C                             ; ABA5 0C                       .
        brk                                     ; ABA6 00                       .
        brk                                     ; ABA7 00                       .
        brk                                     ; ABA8 00                       .
        bit     L0000                           ; ABA9 24 00                    $.
        .byte   $80                             ; ABAB 80                       .
        php                                     ; ABAC 08                       .
        jsr     L0100                           ; ABAD 20 00 01                  ..
        brk                                     ; ABB0 00                       .
        brk                                     ; ABB1 00                       .
        brk                                     ; ABB2 00                       .
        bpl     LABB5                           ; ABB3 10 00                    ..
LABB5:  brk                                     ; ABB5 00                       .
        brk                                     ; ABB6 00                       .
        bpl     LABD9                           ; ABB7 10 20                    . 
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
        php                                     ; ABC8 08                       .
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
LABD9:  brk                                     ; ABD9 00                       .
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
        .byte   $14                             ; ABE5 14                       .
        brk                                     ; ABE6 00                       .
        php                                     ; ABE7 08                       .
        asl     a                               ; ABE8 0A                       .
        brk                                     ; ABE9 00                       .
        .byte   $02                             ; ABEA 02                       .
        brk                                     ; ABEB 00                       .
        brk                                     ; ABEC 00                       .
        .byte   $22                             ; ABED 22                       "
        brk                                     ; ABEE 00                       .
        ora     L0000                           ; ABEF 05 00                    ..
        brk                                     ; ABF1 00                       .
        .byte   $02                             ; ABF2 02                       .
        rti                                     ; ABF3 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ABF4 00                       .
        bvc     LABF7                           ; ABF5 50 00                    P.
LABF7:  .byte   $80                             ; ABF7 80                       .
        brk                                     ; ABF8 00                       .
LABF9:  brk                                     ; ABF9 00                       .
        brk                                     ; ABFA 00                       .
LABFB:  brk                                     ; ABFB 00                       .
        brk                                     ; ABFC 00                       .
LABFD:  brk                                     ; ABFD 00                       .
        brk                                     ; ABFE 00                       .
        brk                                     ; ABFF 00                       .
        brk                                     ; AC00 00                       .
        .byte   $02                             ; AC01 02                       .
        .byte   $02                             ; AC02 02                       .
        .byte   $04                             ; AC03 04                       .
        ora     $0D0D                           ; AC04 0D 0D 0D                 ...
        ora     $0F0E                           ; AC07 0D 0E 0F                 ...
        bpl     LAC1D                           ; AC0A 10 11                    ..
        .byte   $12                             ; AC0C 12                       .
        .byte   $13                             ; AC0D 13                       .
        .byte   $14                             ; AC0E 14                       .
        ora     L0000,x                         ; AC0F 15 00                    ..
        brk                                     ; AC11 00                       .
        brk                                     ; AC12 00                       .
        brk                                     ; AC13 00                       .
        brk                                     ; AC14 00                       .
        brk                                     ; AC15 00                       .
        brk                                     ; AC16 00                       .
        brk                                     ; AC17 00                       .
        brk                                     ; AC18 00                       .
        brk                                     ; AC19 00                       .
        brk                                     ; AC1A 00                       .
        brk                                     ; AC1B 00                       .
        brk                                     ; AC1C 00                       .
LAC1D:  brk                                     ; AC1D 00                       .
        brk                                     ; AC1E 00                       .
        brk                                     ; AC1F 00                       .
        .byte   $04                             ; AC20 04                       .
        brk                                     ; AC21 00                       .
        brk                                     ; AC22 00                       .
        brk                                     ; AC23 00                       .
        rti                                     ; AC24 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AC25 00                       .
        brk                                     ; AC26 00                       .
        brk                                     ; AC27 00                       .
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
        brk                                     ; AC47 00                       .
        brk                                     ; AC48 00                       .
        brk                                     ; AC49 00                       .
        brk                                     ; AC4A 00                       .
        brk                                     ; AC4B 00                       .
        brk                                     ; AC4C 00                       .
        brk                                     ; AC4D 00                       .
LAC4E:  brk                                     ; AC4E 00                       .
        brk                                     ; AC4F 00                       .
        brk                                     ; AC50 00                       .
        brk                                     ; AC51 00                       .
        brk                                     ; AC52 00                       .
        ora     (L0000,x)                       ; AC53 01 00                    ..
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
        ora     (L0000,x)                       ; AC72 01 00                    ..
        brk                                     ; AC74 00                       .
        .byte   $04                             ; AC75 04                       .
        brk                                     ; AC76 00                       .
        rti                                     ; AC77 40                       @

; ----------------------------------------------------------------------------
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
        jsr     L0000                           ; ACA0 20 00 00                  ..
        brk                                     ; ACA3 00                       .
        brk                                     ; ACA4 00                       .
        brk                                     ; ACA5 00                       .
        brk                                     ; ACA6 00                       .
        brk                                     ; ACA7 00                       .
        brk                                     ; ACA8 00                       .
        brk                                     ; ACA9 00                       .
        brk                                     ; ACAA 00                       .
        ora     L0000                           ; ACAB 05 00                    ..
        ora     (L0000,x)                       ; ACAD 01 00                    ..
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
        ora     (L0000,x)                       ; ACBF 01 00                    ..
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
LACCE:  brk                                     ; ACCE 00                       .
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
        bpl     LACE3                           ; ACE1 10 00                    ..
LACE3:  brk                                     ; ACE3 00                       .
        .byte   $02                             ; ACE4 02                       .
        brk                                     ; ACE5 00                       .
        bpl     LACE8                           ; ACE6 10 00                    ..
LACE8:  rti                                     ; ACE8 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACE9 00                       .
        php                                     ; ACEA 08                       .
        ora     ($10,x)                         ; ACEB 01 10                    ..
        brk                                     ; ACED 00                       .
        brk                                     ; ACEE 00                       .
        brk                                     ; ACEF 00                       .
        brk                                     ; ACF0 00                       .
        brk                                     ; ACF1 00                       .
        brk                                     ; ACF2 00                       .
        brk                                     ; ACF3 00                       .
        brk                                     ; ACF4 00                       .
        rti                                     ; ACF5 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACF6 00                       .
        brk                                     ; ACF7 00                       .
        brk                                     ; ACF8 00                       .
        brk                                     ; ACF9 00                       .
        .byte   $02                             ; ACFA 02                       .
        brk                                     ; ACFB 00                       .
        brk                                     ; ACFC 00                       .
        brk                                     ; ACFD 00                       .
        brk                                     ; ACFE 00                       .
        brk                                     ; ACFF 00                       .
        brk                                     ; AD00 00                       .
        .byte   $0C                             ; AD01 0C                       .
        .byte   $0C                             ; AD02 0C                       .
        asl     $0604                           ; AD03 0E 04 06                 ...
        php                                     ; AD06 08                       .
        asl     a                               ; AD07 0A                       .
        brk                                     ; AD08 00                       .
        brk                                     ; AD09 00                       .
        .byte   $3C                             ; AD0A 3C                       <
        rol     $2624,x                         ; AD0B 3E 24 26                 >$&
        plp                                     ; AD0E 28                       (
        rol     a                               ; AD0F 2A                       *
        .byte   $22                             ; AD10 22                       "
        .byte   $7C                             ; AD11 7C                       |
        .byte   $5C                             ; AD12 5C                       \
        lsr     $8E8C,x                         ; AD13 5E 8C 8E                 ^..
        pha                                     ; AD16 48                       H
        lsr     a                               ; AD17 4A                       J
        .byte   $22                             ; AD18 22                       "
        brk                                     ; AD19 00                       .
        jmp     LAC4E                           ; AD1A 4C 4E AC                 LN.

; ----------------------------------------------------------------------------
        ldx     $6A68                           ; AD1D AE 68 6A                 .hj
        rti                                     ; AD20 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; AD21 80                       .
        ldy     #$D5                            ; AD22 A0 D5                    ..
        .byte   $A0                             ; AD24 A0                       .
LAD25:  .byte   $34                             ; AD25 34                       4
        bit     $D02E                           ; AD26 2C 2E D0                 ,..
        .byte   $D2                             ; AD29 D2                       .
        .byte   $D4                             ; AD2A D4                       .
        lda     ($70,x)                         ; AD2B A1 70                    .p
        .byte   $72                             ; AD2D 72                       r
        brk                                     ; AD2E 00                       .
        .byte   $54                             ; AD2F 54                       T
        plp                                     ; AD30 28                       (
        bmi     LAD25                           ; AD31 30 F2                    0.
        brk                                     ; AD33 00                       .
        .byte   $64                             ; AD34 64                       d
        ror     $56                             ; AD35 66 56                    fV
        .byte   $7C                             ; AD37 7C                       |
        .byte   $1C                             ; AD38 1C                       .
        asl     $F058,x                         ; AD39 1E 58 F0                 .X.
        ora     ($11),y                         ; AD3C 11 11                    ..
        ora     ($11),y                         ; AD3E 11 11                    ..
        .byte   $54                             ; AD40 54                       T
        .byte   $04                             ; AD41 04                       .
        .byte   $54                             ; AD42 54                       T
        lsr     $56,x                           ; AD43 56 56                    VV
        lsr     $56,x                           ; AD45 56 56                    VV
        cli                                     ; AD47 58                       X
        pla                                     ; AD48 68                       h
        .byte   $44                             ; AD49 44                       D
        .byte   $44                             ; AD4A 44                       D
        bmi     LADC1                           ; AD4B 30 74                    0t
        ror     $74,x                           ; AD4D 76 74                    vt
LAD4F:  .byte   $44                             ; AD4F 44                       D
        .byte   $62                             ; AD50 62                       b
        rts                                     ; AD51 60                       `

; ----------------------------------------------------------------------------
        .byte   $62                             ; AD52 62                       b
        .byte   $22                             ; AD53 22                       "
        .byte   $44                             ; AD54 44                       D
        asl     $16                             ; AD55 06 16                    ..
        .byte   $54                             ; AD57 54                       T
        .byte   $42                             ; AD58 42                       B
        rti                                     ; AD59 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; AD5A 42                       B
        .byte   $02                             ; AD5B 02                       .
        .byte   $54                             ; AD5C 54                       T
        rol     $4A                             ; AD5D 26 4A                    &J
        ora     $4B,x                           ; AD5F 15 4B                    .K
        eor     $4B4F                           ; AD61 4D 4F 4B                 MOK
        php                                     ; AD64 08                       .
        ora     #$0F                            ; AD65 09 0F                    ..
        brk                                     ; AD67 00                       .
        .byte   $6B                             ; AD68 6B                       k
        adc     $6B6F                           ; AD69 6D 6F 6B                 mok
        plp                                     ; AD6C 28                       (
        and     #$2F                            ; AD6D 29 2F                    )/
        brk                                     ; AD6F 00                       .
        lsr     $48                             ; AD70 46 48                    FH
        lsr     a                               ; AD72 4A                       J
        lsr     $0B                             ; AD73 46 0B                    F.
        ora     $2D2B                           ; AD75 0D 2B 2D                 .+-
        lsr     L0000                           ; AD78 46 00                    F.
        .byte   $34                             ; AD7A 34                       4
        eor     $54,x                           ; AD7B 55 54                    UT
        ror     a                               ; AD7D 6A                       j
        brk                                     ; AD7E 00                       .
        cli                                     ; AD7F 58                       X
        pla                                     ; AD80 68                       h
        .byte   $02                             ; AD81 02                       .
        .byte   $42                             ; AD82 42                       B
        rti                                     ; AD83 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; AD84 42                       B
        brk                                     ; AD85 00                       .
        brk                                     ; AD86 00                       .
        brk                                     ; AD87 00                       .
        brk                                     ; AD88 00                       .
        brk                                     ; AD89 00                       .
        brk                                     ; AD8A 00                       .
        .byte   $82                             ; AD8B 82                       .
        brk                                     ; AD8C 00                       .
        stx     a:L0000                         ; AD8D 8E 00 00                 ...
        brk                                     ; AD90 00                       .
        brk                                     ; AD91 00                       .
        sty     $86                             ; AD92 84 86                    ..
        brk                                     ; AD94 00                       .
        txa                                     ; AD95 8A                       .
        sty     a:L0000                         ; AD96 8C 00 00                 ...
        ldx     #$A4                            ; AD99 A2 A4                    ..
        ldx     $A8                             ; AD9B A6 A8                    ..
        tax                                     ; AD9D AA                       .
        ldy     a:$AE                           ; AD9E AC AE 00                 ...
        .byte   $02                             ; ADA1 02                       .
        .byte   $04                             ; ADA2 04                       .
        asl     L0008                           ; ADA3 06 08                    ..
        asl     a                               ; ADA5 0A                       .
        .byte   $0C                             ; ADA6 0C                       .
        ldx     $2220,y                         ; ADA7 BE 20 22                 . "
        bit     $26                             ; ADAA 24 26                    $&
        plp                                     ; ADAC 28                       (
        rol     a                               ; ADAD 2A                       *
        bit     $402E                           ; ADAE 2C 2E 40                 ,.@
        .byte   $42                             ; ADB1 42                       B
        .byte   $44                             ; ADB2 44                       D
        lsr     $48                             ; ADB3 46 48                    FH
        lsr     a                               ; ADB5 4A                       J
        jmp     L804E                           ; ADB6 4C 4E 80                 LN.

; ----------------------------------------------------------------------------
        .byte   $82                             ; ADB9 82                       .
        sty     $86                             ; ADBA 84 86                    ..
        dey                                     ; ADBC 88                       .
        txa                                     ; ADBD 8A                       .
        sty     LA08E                           ; ADBE 8C 8E A0                 ...
LADC1:  ldx     #$A4                            ; ADC1 A2 A4                    ..
        ldx     $A8                             ; ADC3 A6 A8                    ..
        tax                                     ; ADC5 AA                       .
        ldy     $C0AE                           ; ADC6 AC AE C0                 ...
        .byte   $C2                             ; ADC9 C2                       .
        cpy     $C6                             ; ADCA C4 C6                    ..
        iny                                     ; ADCC C8                       .
        dex                                     ; ADCD CA                       .
        .byte   $CC                             ; ADCE CC                       .
LADCF:  brk                                     ; ADCF 00                       .
        cpy     #$62                            ; ADD0 C0 62                    .b
        .byte   $64                             ; ADD2 64                       d
        ror     $68                             ; ADD3 66 68                    fh
        ror     a                               ; ADD5 6A                       j
        jmp     (entity_deactivate)                         ; ADD6 6C 6E E0                 ln.

; ----------------------------------------------------------------------------
        .byte   $E2                             ; ADD9 E2                       .
        cpx     $E6                             ; ADDA E4 E6                    ..
        inx                                     ; ADDC E8                       .
        nop                                     ; ADDD EA                       .
        cpx     LA800                           ; ADDE EC 00 A8                 ...
        tax                                     ; ADE1 AA                       .
        ldy     $CCAE                           ; ADE2 AC AE CC                 ...
        dec     $EAEA                           ; ADE5 CE EA EA                 ...
        iny                                     ; ADE8 C8                       .
        dex                                     ; ADE9 CA                       .
        cpy     $ECCE                           ; ADEA CC CE EC                 ...
        inc     $F8E8                           ; ADED EE E8 F8                 ...
        inx                                     ; ADF0 E8                       .
        nop                                     ; ADF1 EA                       .
        cpx     $D8EE                           ; ADF2 EC EE D8                 ...
        .byte   $DA                             ; ADF5 DA                       .
        sty     a:$8E                           ; ADF6 8C 8E 00                 ...
        .byte   $F3                             ; ADF9 F3                       .
        cpx     #$F1                            ; ADFA E0 F1                    ..
        cpy     LACCE                           ; ADFC CC CE AC                 ...
        ldx     $0D00                           ; ADFF AE 00 0D                 ...
        ora     $050F                           ; AE02 0D 0F 05                 ...
        .byte   $07                             ; AE05 07                       .
        ora     #$0B                            ; AE06 09 0B                    ..
        brk                                     ; AE08 00                       .
        adc     $3F3D,x                         ; AE09 7D 3D 3F                 }=?
        and     $27                             ; AE0C 25 27                    %'
        and     #$2B                            ; AE0E 29 2B                    )+
        .byte   $23                             ; AE10 23                       #
        .byte   $02                             ; AE11 02                       .
        eor     $8D5F,x                         ; AE12 5D 5F 8D                 ]_.
        .byte   $8F                             ; AE15 8F                       .
        eor     #$4B                            ; AE16 49 4B                    IK
        eor     ($03,x)                         ; AE18 41 03                    A.
        eor     LAD4F                           ; AE1A 4D 4F AD                 MO.
        .byte   $AF                             ; AE1D AF                       .
        adc     #$6B                            ; AE1E 69 6B                    ik
        .byte   $23                             ; AE20 23                       #
        brk                                     ; AE21 00                       .
        brk                                     ; AE22 00                       .
        dec     $0F,x                           ; AE23 D6 0F                    ..
        lda     ($2D,x)                         ; AE25 A1 2D                    .-
        .byte   $2F                             ; AE27 2F                       /
        cmp     ($D3),y                         ; AE28 D1 D3                    ..
        bne     LAE2C                           ; AE2A D0 00                    ..
LAE2C:  adc     ($73),y                         ; AE2C 71 73                    qs
        brk                                     ; AE2E 00                       .
        cli                                     ; AE2F 58                       X
        and     #$31                            ; AE30 29 31                    )1
        .byte   $F3                             ; AE32 F3                       .
        beq     LAE9A                           ; AE33 F0 65                    .e
        .byte   $67                             ; AE35 67                       g
        lsr     $7D,x                           ; AE36 56 7D                    V}
        ora     $571F,x                         ; AE38 1D 1F 57                 ..W
        brk                                     ; AE3B 00                       .
        ora     ($11),y                         ; AE3C 11 11                    ..
        ora     ($11),y                         ; AE3E 11 11                    ..
        .byte   $57                             ; AE40 57                       W
        ora     $58                             ; AE41 05 58                    .X
        lsr     $56,x                           ; AE43 56 56                    VV
        lsr     $56,x                           ; AE45 56 56                    VV
        .byte   $57                             ; AE47 57                       W
        adc     #$45                            ; AE48 69 45                    iE
        eor     $77                             ; AE4A 45 77                    Ew
        adc     $77,x                           ; AE4C 75 77                    uw
        and     ($45),y                         ; AE4E 31 45                    1E
        .byte   $63                             ; AE50 63                       c
        adc     ($23,x)                         ; AE51 61 23                    a#
        adc     ($45,x)                         ; AE53 61 45                    aE
        .byte   $07                             ; AE55 07                       .
        .byte   $17                             ; AE56 17                       .
        .byte   $57                             ; AE57 57                       W
        .byte   $43                             ; AE58 43                       C
        eor     ($03,x)                         ; AE59 41 03                    A.
        eor     ($57,x)                         ; AE5B 41 57                    AW
        .byte   $27                             ; AE5D 27                       '
        .byte   $14                             ; AE5E 14                       .
        .byte   $47                             ; AE5F 47                       G
        jmp     L4B4E                           ; AE60 4C 4E 4B                 LNK

; ----------------------------------------------------------------------------
        .byte   $4B                             ; AE63 4B                       K
        ora     #$0A                            ; AE64 09 0A                    ..
        .byte   $0F                             ; AE66 0F                       .
        brk                                     ; AE67 00                       .
        jmp     (L6B6E)                         ; AE68 6C 6E 6B                 lnk

; ----------------------------------------------------------------------------
        .byte   $6B                             ; AE6B 6B                       k
        and     #$2A                            ; AE6C 29 2A                    )*
        .byte   $2F                             ; AE6E 2F                       /
        brk                                     ; AE6F 00                       .
        .byte   $47                             ; AE70 47                       G
        eor     #$46                            ; AE71 49 46                    IF
        lsr     $0C                             ; AE73 46 0C                    F.
        asl     $2E2C                           ; AE75 0E 2C 2E                 .,.
        lsr     L0000                           ; AE78 46 00                    F.
        and     L0000,x                         ; AE7A 35 00                    5.
        cli                                     ; AE7C 58                       X
        ror     a                               ; AE7D 6A                       j
        brk                                     ; AE7E 00                       .
        .byte   $57                             ; AE7F 57                       W
        adc     #$41                            ; AE80 69 41                    iA
        .byte   $43                             ; AE82 43                       C
        eor     ($03,x)                         ; AE83 41 03                    A.
        brk                                     ; AE85 00                       .
        brk                                     ; AE86 00                       .
        brk                                     ; AE87 00                       .
        brk                                     ; AE88 00                       .
        brk                                     ; AE89 00                       .
        sta     (L0000,x)                       ; AE8A 81 00                    ..
        sta     a:L0000                         ; AE8C 8D 00 00                 ...
        brk                                     ; AE8F 00                       .
        brk                                     ; AE90 00                       .
        .byte   $83                             ; AE91 83                       .
        sta     L0000                           ; AE92 85 00                    ..
        .byte   $89                             ; AE94 89                       .
        .byte   $8B                             ; AE95 8B                       .
        brk                                     ; AE96 00                       .
        brk                                     ; AE97 00                       .
        lda     ($A3,x)                         ; AE98 A1 A3                    ..
LAE9A:  lda     $A7                             ; AE9A A5 A7                    ..
        lda     #$AB                            ; AE9C A9 AB                    ..
        lda     L0100                           ; AE9E AD 00 01                 ...
        .byte   $03                             ; AEA1 03                       .
        ora     $07                             ; AEA2 05 07                    ..
        ora     #$0B                            ; AEA4 09 0B                    ..
        ora     $21BE                           ; AEA6 0D BE 21                 ..!
        .byte   $23                             ; AEA9 23                       #
        and     $27                             ; AEAA 25 27                    %'
        .byte   $29                             ; AEAC 29                       )
LAEAD:  .byte   $2B                             ; AEAD 2B                       +
        and     $41BE                           ; AEAE 2D BE 41                 -.A
        .byte   $43                             ; AEB1 43                       C
LAEB2:  eor     $47                             ; AEB2 45 47                    EG
        eor     #$4B                            ; AEB4 49 4B                    IK
        eor     $814F                           ; AEB6 4D 4F 81                 MO.
        .byte   $83                             ; AEB9 83                       .
        sta     $87                             ; AEBA 85 87                    ..
        .byte   $89                             ; AEBC 89                       .
        .byte   $8B                             ; AEBD 8B                       .
        sta     LA18F                           ; AEBE 8D 8F A1                 ...
        .byte   $A3                             ; AEC1 A3                       .
        lda     $A7                             ; AEC2 A5 A7                    ..
        lda     #$AB                            ; AEC4 A9 AB                    ..
        lda     $C1AF                           ; AEC6 AD AF C1                 ...
        .byte   $C3                             ; AEC9 C3                       .
        cmp     $C7                             ; AECA C5 C7                    ..
        cmp     #$CB                            ; AECC C9 CB                    ..
        cmp     $C100                           ; AECE CD 00 C1                 ...
        .byte   $63                             ; AED1 63                       c
        adc     $67                             ; AED2 65 67                    eg
        adc     #$6B                            ; AED4 69 6B                    ik
        adc     $E100                           ; AED6 6D 00 E1                 m..
        .byte   $E3                             ; AED9 E3                       .
        sbc     $E7                             ; AEDA E5 E7                    ..
        sbc     #$EB                            ; AEDC E9 EB                    ..
        sbc     LA900                           ; AEDE ED 00 A9                 ...
        .byte   $AB                             ; AEE1 AB                       .
        lda     $CDAF                           ; AEE2 AD AF CD                 ...
        .byte   $CF                             ; AEE5 CF                       .
        .byte   $EB                             ; AEE6 EB                       .
        .byte   $EB                             ; AEE7 EB                       .
        cmp     #$CB                            ; AEE8 C9 CB                    ..
        cmp     $EDCF                           ; AEEA CD CF ED                 ...
        .byte   $EF                             ; AEED EF                       .
        sbc     #$F9                            ; AEEE E9 F9                    ..
        sbc     #$EB                            ; AEF0 E9 EB                    ..
        sbc     $D9EF                           ; AEF2 ED EF D9                 ...
        .byte   $DB                             ; AEF5 DB                       .
        sta     $F28F                           ; AEF6 8D 8F F2                 ...
        brk                                     ; AEF9 00                       .
        sbc     ($E0),y                         ; AEFA F1 E0                    ..
        cmp     LADCF                           ; AEFC CD CF AD                 ...
        .byte   $AF                             ; AEFF AF                       .
        brk                                     ; AF00 00                       .
        .byte   $0C                             ; AF01 0C                       .
        .byte   $0C                             ; AF02 0C                       .
        asl     $1614,x                         ; AF03 1E 14 16                 ...
        clc                                     ; AF06 18                       .
        .byte   $1A                             ; AF07 1A                       .
        brk                                     ; AF08 00                       .
LAF09:  brk                                     ; AF09 00                       .
        jmp     L344E                           ; AF0A 4C 4E 34                 LN4

; ----------------------------------------------------------------------------
        rol     $38,x                           ; AF0D 36 38                    68
        .byte   $3A                             ; AF0F 3A                       :
        .byte   $32                             ; AF10 32                       2
        ror     $3E3C,x                         ; AF11 7E 3C 3E                 ~<>
        .byte   $9C                             ; AF14 9C                       .
        .byte   $9E                             ; AF15 9E                       .
        cli                                     ; AF16 58                       X
        .byte   $5A                             ; AF17 5A                       Z
        .byte   $32                             ; AF18 32                       2
        brk                                     ; AF19 00                       .
        .byte   $5C                             ; AF1A 5C                       \
        lsr     LBEBC,x                         ; AF1B 5E BC BE                 ^..
LAF1E:  sei                                     ; AF1E 78                       x
        .byte   $7A                             ; AF1F 7A                       z
        bvc     LAEB2                           ; AF20 50 90                    P.
        bcs     LAF09                           ; AF22 B0 E5                    ..
        bcs     LAF6E                           ; AF24 B0 48                    .H
        brk                                     ; AF26 00                       .
        brk                                     ; AF27 00                       .
        cpx     #$E2                            ; AF28 E0 E2                    ..
        cpx     $B1                             ; AF2A E4 B1                    ..
        bvs     LAFA0                           ; AF2C 70 72                    pr
        ror     $6011,x                         ; AF2E 7E 11 60                 ~.`
        .byte   $62                             ; AF31 62                       b
        .byte   $F2                             ; AF32 F2                       .
        brk                                     ; AF33 00                       .
        .byte   $74                             ; AF34 74                       t
        ror     $11,x                           ; AF35 76 11                    v.
        ror     $6E0E,x                         ; AF37 7E 0E 6E                 ~.n
        ora     ($F0),y                         ; AF3A 11 F0                    ..
        ora     ($54),y                         ; AF3C 11 54                    .T
        lsr     $58,x                           ; AF3E 56 58                    VX
        .byte   $54                             ; AF40 54                       T
        .byte   $04                             ; AF41 04                       .
        .byte   $44                             ; AF42 44                       D
        jsr     L6664                           ; AF43 20 64 66                  df
        .byte   $64                             ; AF46 64                       d
        .byte   $44                             ; AF47 44                       D
        sei                                     ; AF48 78                       x
        .byte   $44                             ; AF49 44                       D
        .byte   $54                             ; AF4A 54                       T
        lsr     $56,x                           ; AF4B 56 56                    VV
        lsr     $56,x                           ; AF4D 56 56                    VV
        cli                                     ; AF4F 58                       X
        .byte   $72                             ; AF50 72                       r
        bvs     LAFC5                           ; AF51 70 72                    pr
        .byte   $32                             ; AF53 32                       2
        .byte   $54                             ; AF54 54                       T
        asl     $36,x                           ; AF55 16 36                    .6
        cli                                     ; AF57 58                       X
        .byte   $52                             ; AF58 52                       R
        bvc     LAFAD                           ; AF59 50 52                    PR
        .byte   $12                             ; AF5B 12                       .
        .byte   $44                             ; AF5C 44                       D
        rol     $4A                             ; AF5D 26 4A                    &J
        ora     $5B,x                           ; AF5F 15 5B                    .[
        eor     $5B5F,x                         ; AF61 5D 5F 5B                 ]_[
        clc                                     ; AF64 18                       .
        ora     $241F,y                         ; AF65 19 1F 24                 ..$
        .byte   $7B                             ; AF68 7B                       {
        adc     $7B7F,x                         ; AF69 7D 7F 7B                 }.{
        sec                                     ; AF6C 38                       8
        .byte   $39                             ; AF6D 39                       9
LAF6E:  .byte   $3F                             ; AF6E 3F                       ?
        bit     $46                             ; AF6F 24 46                    $F
        pha                                     ; AF71 48                       H
        lsr     a                               ; AF72 4A                       J
        lsr     $1B                             ; AF73 46 1B                    F.
        ora     $3D3B,x                         ; AF75 1D 3B 3D                 .;=
        eor     $4846,y                         ; AF78 59 46 48                 YFH
        lsr     a                               ; AF7B 4A                       J
        .byte   $54                             ; AF7C 54                       T
        .byte   $7A                             ; AF7D 7A                       z
        lsr     $58                             ; AF7E 46 58                    FX
        sta     ($83,x)                         ; AF80 81 83                    ..
        sta     $87                             ; AF82 85 87                    ..
        sta     L0000                           ; AF84 85 00                    ..
        ror     a:L0000,x                       ; AF86 7E 00 00                 ~..
        brk                                     ; AF89 00                       .
        bcc     LAF1E                           ; AF8A 90 92                    ..
        brk                                     ; AF8C 00                       .
        .byte   $9E                             ; AF8D 9E                       .
        .byte   $8F                             ; AF8E 8F                       .
        brk                                     ; AF8F 00                       .
        brk                                     ; AF90 00                       .
        brk                                     ; AF91 00                       .
        sty     $96,x                           ; AF92 94 96                    ..
        tya                                     ; AF94 98                       .
        txs                                     ; AF95 9A                       .
        .byte   $9C                             ; AF96 9C                       .
        brk                                     ; AF97 00                       .
        brk                                     ; AF98 00                       .
        .byte   $B2                             ; AF99 B2                       .
        ldy     $B6,x                           ; AF9A B4 B6                    ..
        clv                                     ; AF9C B8                       .
        tsx                                     ; AF9D BA                       .
        .byte   $BC                             ; AF9E BC                       .
        .byte   $BE                             ; AF9F BE                       .
LAFA0:  bpl     LAFB4                           ; AFA0 10 12                    ..
        .byte   $14                             ; AFA2 14                       .
        asl     $18,x                           ; AFA3 16 18                    ..
        .byte   $1A                             ; AFA5 1A                       .
        .byte   $1C                             ; AFA6 1C                       .
        asl     $3230,x                         ; AFA7 1E 30 32                 .02
        .byte   $34                             ; AFAA 34                       4
        rol     $38,x                           ; AFAB 36 38                    68
LAFAD:  .byte   $3A                             ; AFAD 3A                       :
        .byte   $3C                             ; AFAE 3C                       <
        dec     $5250                           ; AFAF CE 50 52                 .PR
        .byte   $54                             ; AFB2 54                       T
        .byte   $56                             ; AFB3 56                       V
LAFB4:  cli                                     ; AFB4 58                       X
        .byte   $5A                             ; AFB5 5A                       Z
        .byte   $5C                             ; AFB6 5C                       \
        dec     $9290,x                         ; AFB7 DE 90 92                 ...
        sty     $96,x                           ; AFBA 94 96                    ..
        tya                                     ; AFBC 98                       .
        txs                                     ; AFBD 9A                       .
        .byte   $9C                             ; AFBE 9C                       .
        inc     LB2B0                           ; AFBF EE B0 B2                 ...
        ldy     $B6,x                           ; AFC2 B4 B6                    ..
        clv                                     ; AFC4 B8                       .
LAFC5:  tsx                                     ; AFC5 BA                       .
        ldy     $D0FE,x                         ; AFC6 BC FE D0                 ...
        .byte   $D2                             ; AFC9 D2                       .
        .byte   $D4                             ; AFCA D4                       .
        dec     $D8,x                           ; AFCB D6 D8                    ..
        .byte   $DA                             ; AFCD DA                       .
        .byte   $DC                             ; AFCE DC                       .
        brk                                     ; AFCF 00                       .
        bne     LB044                           ; AFD0 D0 72                    .r
        .byte   $74                             ; AFD2 74                       t
        ror     $78,x                           ; AFD3 76 78                    vx
        .byte   $7A                             ; AFD5 7A                       z
        .byte   $7C                             ; AFD6 7C                       |
        ror     $F2F0,x                         ; AFD7 7E F0 F2                 ~..
        .byte   $F4                             ; AFDA F4                       .
        inc     $F8,x                           ; AFDB F6 F8                    ..
        .byte   $FA                             ; AFDD FA                       .
        .byte   $FC                             ; AFDE FC                       .
        brk                                     ; AFDF 00                       .
        clv                                     ; AFE0 B8                       .
        tsx                                     ; AFE1 BA                       .
        ldy     $DCBE,x                         ; AFE2 BC BE DC                 ...
        dec     $FAFA,x                         ; AFE5 DE FA FA                 ...
        cld                                     ; AFE8 D8                       .
        .byte   $DA                             ; AFE9 DA                       .
        .byte   $DC                             ; AFEA DC                       .
        dec     $FEFC,x                         ; AFEB DE FC FE                 ...
        beq     LAFF0                           ; AFEE F0 00                    ..
LAFF0:  sed                                     ; AFF0 F8                       .
        .byte   $FA                             ; AFF1 FA                       .
        .byte   $FC                             ; AFF2 FC                       .
        inc     $F300,x                         ; AFF3 FE 00 F3                 ...
        .byte   $9C                             ; AFF6 9C                       .
        .byte   $9E                             ; AFF7 9E                       .
        brk                                     ; AFF8 00                       .
        .byte   $F3                             ; AFF9 F3                       .
        beq     LAFFC                           ; AFFA F0 00                    ..
LAFFC:  iny                                     ; AFFC C8                       .
        dex                                     ; AFFD CA                       .
        .byte   $BC                             ; AFFE BC                       .
        .byte   $BE                             ; AFFF BE                       .
LB000:  brk                                     ; B000 00                       .
        ora     $1F0D                           ; B001 0D 0D 1F                 ...
        ora     $17,x                           ; B004 15 17                    ..
        ora     $1B,y                           ; B006 19 1B 00                 ...
        .byte   $7F                             ; B009 7F                       .
        eor     $354F                           ; B00A 4D 4F 35                 MO5
        .byte   $37                             ; B00D 37                       7
        and     $333B,y                         ; B00E 39 3B 33                 9;3
        .byte   $12                             ; B011 12                       .
        and     $9D3F,x                         ; B012 3D 3F 9D                 =?.
        .byte   $9F                             ; B015 9F                       .
        eor     $515B,y                         ; B016 59 5B 51                 Y[Q
        .byte   $03                             ; B019 03                       .
        eor     LBD5F,x                         ; B01A 5D 5F BD                 ]_.
        .byte   $BF                             ; B01D BF                       .
        adc     $337B,y                         ; B01E 79 7B 33                 y{3
        brk                                     ; B021 00                       .
        brk                                     ; B022 00                       .
        inc     $1F                             ; B023 E6 1F                    ..
        lda     (L0000),y                       ; B025 B1 00                    ..
        brk                                     ; B027 00                       .
        sbc     ($E3,x)                         ; B028 E1 E3                    ..
        cpx     #$47                            ; B02A E0 47                    .G
        adc     ($73),y                         ; B02C 71 73                    qs
        .byte   $7F                             ; B02E 7F                       .
        ora     ($61),y                         ; B02F 11 61                    .a
        .byte   $63                             ; B031 63                       c
        .byte   $F3                             ; B032 F3                       .
        beq     LB0AA                           ; B033 F0 75                    .u
        .byte   $77                             ; B035 77                       w
        ora     ($7F),y                         ; B036 11 7F                    ..
        .byte   $0F                             ; B038 0F                       .
        .byte   $6F                             ; B039 6F                       o
        ora     (L0000),y                       ; B03A 11 00                    ..
        ora     ($58),y                         ; B03C 11 58                    .X
        lsr     $57,x                           ; B03E 56 57                    VW
        cli                                     ; B040 58                       X
        ora     $45                             ; B041 05 45                    .E
        .byte   $67                             ; B043 67                       g
LB044:  adc     $67                             ; B044 65 67                    eg
        and     ($45,x)                         ; B046 21 45                    !E
        adc     $5845,y                         ; B048 79 45 58                 yEX
        lsr     $56,x                           ; B04B 56 56                    VV
        lsr     $56,x                           ; B04D 56 56                    VV
        .byte   $57                             ; B04F 57                       W
        .byte   $73                             ; B050 73                       s
        adc     ($33),y                         ; B051 71 33                    q3
        adc     ($57),y                         ; B053 71 57                    qW
        .byte   $17                             ; B055 17                       .
        .byte   $37                             ; B056 37                       7
        .byte   $57                             ; B057 57                       W
        .byte   $53                             ; B058 53                       S
        eor     ($13),y                         ; B059 51 13                    Q.
        eor     ($45),y                         ; B05B 51 45                    QE
        .byte   $27                             ; B05D 27                       '
        .byte   $14                             ; B05E 14                       .
        .byte   $47                             ; B05F 47                       G
        .byte   $5C                             ; B060 5C                       \
        lsr     $5B5B,x                         ; B061 5E 5B 5B                 ^[[
        ora     $1F1A,y                         ; B064 19 1A 1F                 ...
        and     $7C                             ; B067 25 7C                    %|
        ror     $7B7B,x                         ; B069 7E 7B 7B                 ~{{
        and     $3F3A,y                         ; B06C 39 3A 3F                 9:?
        bit     $47                             ; B06F 24 47                    $G
        eor     #$46                            ; B071 49 46                    IF
        lsr     $1C                             ; B073 46 1C                    F.
        asl     $3E3C,x                         ; B075 1E 3C 3E                 .<>
        .byte   $5A                             ; B078 5A                       Z
        .byte   $47                             ; B079 47                       G
        eor     #$46                            ; B07A 49 46                    IF
        cli                                     ; B07C 58                       X
        .byte   $7A                             ; B07D 7A                       z
        lsr     $57                             ; B07E 46 57                    FW
        .byte   $82                             ; B080 82                       .
        sty     $86                             ; B081 84 86                    ..
        sty     $91                             ; B083 84 91                    ..
        .byte   $03                             ; B085 03                       .
        .byte   $12                             ; B086 12                       .
        .byte   $7F                             ; B087 7F                       .
        brk                                     ; B088 00                       .
        .byte   $80                             ; B089 80                       .
        sta     (L0000),y                       ; B08A 91 00                    ..
        sta     a:$9F,x                         ; B08C 9D 9F 00                 ...
        brk                                     ; B08F 00                       .
        brk                                     ; B090 00                       .
        .byte   $93                             ; B091 93                       .
        sta     $97,x                           ; B092 95 97                    ..
        sta     $9B,y                           ; B094 99 9B 00                 ...
        brk                                     ; B097 00                       .
        lda     ($B3),y                         ; B098 B1 B3                    ..
        lda     $B7,x                           ; B09A B5 B7                    ..
        lda     LBDBB,y                         ; B09C B9 BB BD                 ...
        brk                                     ; B09F 00                       .
        ora     ($13),y                         ; B0A0 11 13                    ..
        ora     $17,x                           ; B0A2 15 17                    ..
        ora     $1D1B,y                         ; B0A4 19 1B 1D                 ...
        .byte   $BF                             ; B0A7 BF                       .
        and     ($33),y                         ; B0A8 31 33                    13
LB0AA:  and     $37,x                           ; B0AA 35 37                    57
        and     $3D3B,y                         ; B0AC 39 3B 3D                 9;=
        .byte   $CF                             ; B0AF CF                       .
        eor     ($53),y                         ; B0B0 51 53                    QS
        eor     $57,x                           ; B0B2 55 57                    UW
        eor     $5D5B,y                         ; B0B4 59 5B 5D                 Y[]
        .byte   $DF                             ; B0B7 DF                       .
        sta     ($93),y                         ; B0B8 91 93                    ..
        sta     $97,x                           ; B0BA 95 97                    ..
        sta     $9D9B,y                         ; B0BC 99 9B 9D                 ...
        .byte   $EF                             ; B0BF EF                       .
        lda     ($B3),y                         ; B0C0 B1 B3                    ..
        lda     $B7,x                           ; B0C2 B5 B7                    ..
        .byte   $B9                             ; B0C4 B9                       .
        .byte   $BB                             ; B0C5 BB                       .
LB0C6:  lda     $D1FF,x                         ; B0C6 BD FF D1                 ...
        .byte   $D3                             ; B0C9 D3                       .
        cmp     $D7,x                           ; B0CA D5 D7                    ..
        cmp     $DDDB,y                         ; B0CC D9 DB DD                 ...
        brk                                     ; B0CF 00                       .
        cmp     ($73),y                         ; B0D0 D1 73                    .s
        adc     $77,x                           ; B0D2 75 77                    uw
        adc     $7D7B,y                         ; B0D4 79 7B 7D                 y{}
        brk                                     ; B0D7 00                       .
        sbc     ($F3),y                         ; B0D8 F1 F3                    ..
        sbc     $F7,x                           ; B0DA F5 F7                    ..
        sbc     $FDFB,y                         ; B0DC F9 FB FD                 ...
        brk                                     ; B0DF 00                       .
        lda     LBDBB,y                         ; B0E0 B9 BB BD                 ...
        .byte   $BF                             ; B0E3 BF                       .
        cmp     $FBDF,x                         ; B0E4 DD DF FB                 ...
        .byte   $FB                             ; B0E7 FB                       .
        .byte   $D9                             ; B0E8 D9                       .
        .byte   $DB                             ; B0E9 DB                       .
LB0EA:  cmp     $FDDF,x                         ; B0EA DD DF FD                 ...
        .byte   $FF                             ; B0ED FF                       .
        brk                                     ; B0EE 00                       .
        beq     LB0EA                           ; B0EF F0 F9                    ..
        .byte   $FB                             ; B0F1 FB                       .
        sbc     $F2FF,x                         ; B0F2 FD FF F2                 ...
        brk                                     ; B0F5 00                       .
        sta     $F29F,x                         ; B0F6 9D 9F F2                 ...
        brk                                     ; B0F9 00                       .
        brk                                     ; B0FA 00                       .
        beq     LB0C6                           ; B0FB F0 C9                    ..
        .byte   $CB                             ; B0FD CB                       .
        lda     a:$BF,x                         ; B0FE BD BF 00                 ...
        rti                                     ; B101 40                       @

; ----------------------------------------------------------------------------
        jsr     L10F0                           ; B102 20 F0 10                  ..
        bpl     LB118                           ; B105 10 11                    ..
        ora     ($10),y                         ; B107 11 10                    ..
        ora     ($03,x)                         ; B109 01 03                    ..
        .byte   $03                             ; B10B 03                       .
        bpl     LB11E                           ; B10C 10 10                    ..
        adc     ($61,x)                         ; B10E 61 61                    aa
        .byte   $12                             ; B110 12                       .
        ora     ($03,x)                         ; B111 01 03                    ..
        .byte   $03                             ; B113 03                       .
        .byte   $12                             ; B114 12                       .
        .byte   $12                             ; B115 12                       .
        adc     ($61,x)                         ; B116 61 61                    aa
LB118:  .byte   $12                             ; B118 12                       .
        .byte   $03                             ; B119 03                       .
        .byte   $03                             ; B11A 03                       .
        .byte   $03                             ; B11B 03                       .
        .byte   $12                             ; B11C 12                       .
        .byte   $12                             ; B11D 12                       .
LB11E:  ora     ($11),y                         ; B11E 11 11                    ..
        .byte   $12                             ; B120 12                       .
        bpl     LB133                           ; B121 10 10                    ..
        bpl     LB135                           ; B123 10 10                    ..
        ora     ($01,x)                         ; B125 01 01                    ..
        ora     ($10,x)                         ; B127 01 10                    ..
        bpl     LB13B                           ; B129 10 10                    ..
        ora     ($12,x)                         ; B12B 01 12                    ..
        .byte   $12                             ; B12D 12                       .
        ora     ($61,x)                         ; B12E 01 61                    .a
        adc     ($61,x)                         ; B130 61 61                    aa
        .byte   $10                             ; B132 10                       .
LB133:  bpl     LB147                           ; B133 10 12                    ..
LB135:  .byte   $12                             ; B135 12                       .
        adc     ($01,x)                         ; B136 61 01                    a.
        adc     ($61,x)                         ; B138 61 61                    aa
        .byte   $61                             ; B13A 61                       a
LB13B:  bpl     LB19E                           ; B13B 10 61                    .a
        adc     ($61,x)                         ; B13D 61 61                    aa
        adc     ($12,x)                         ; B13F 61 12                    a.
        .byte   $02                             ; B141 02                       .
        .byte   $12                             ; B142 12                       .
        .byte   $12                             ; B143 12                       .
        .byte   $12                             ; B144 12                       .
        .byte   $12                             ; B145 12                       .
        .byte   $12                             ; B146 12                       .
LB147:  .byte   $12                             ; B147 12                       .
        .byte   $12                             ; B148 12                       .
        .byte   $12                             ; B149 12                       .
        .byte   $12                             ; B14A 12                       .
        .byte   $12                             ; B14B 12                       .
        .byte   $12                             ; B14C 12                       .
        .byte   $12                             ; B14D 12                       .
        .byte   $12                             ; B14E 12                       .
        .byte   $12                             ; B14F 12                       .
        .byte   $12                             ; B150 12                       .
        .byte   $12                             ; B151 12                       .
        .byte   $12                             ; B152 12                       .
        .byte   $12                             ; B153 12                       .
        .byte   $12                             ; B154 12                       .
        ora     ($01,x)                         ; B155 01 01                    ..
        .byte   $12                             ; B157 12                       .
        .byte   $12                             ; B158 12                       .
        .byte   $12                             ; B159 12                       .
        .byte   $12                             ; B15A 12                       .
        .byte   $12                             ; B15B 12                       .
        .byte   $12                             ; B15C 12                       .
        .byte   $03                             ; B15D 03                       .
        ora     ($01,x)                         ; B15E 01 01                    ..
        ora     ($01,x)                         ; B160 01 01                    ..
        ora     ($01,x)                         ; B162 01 01                    ..
        bpl     LB176                           ; B164 10 10                    ..
        bpl     LB169                           ; B166 10 01                    ..
        .byte   $01                             ; B168 01                       .
LB169:  ora     ($01,x)                         ; B169 01 01                    ..
        ora     ($10,x)                         ; B16B 01 10                    ..
        bpl     LB17F                           ; B16D 10 10                    ..
        ora     ($01,x)                         ; B16F 01 01                    ..
        ora     ($01,x)                         ; B171 01 01                    ..
        ora     ($10,x)                         ; B173 01 10                    ..
        .byte   $10                             ; B175 10                       .
LB176:  bpl     LB188                           ; B176 10 10                    ..
        ora     ($01,x)                         ; B178 01 01                    ..
        ora     ($01,x)                         ; B17A 01 01                    ..
        bpl     LB18E                           ; B17C 10 10                    ..
        .byte   $01                             ; B17E 01                       .
LB17F:  bpl     LB193                           ; B17F 10 12                    ..
        .byte   $12                             ; B181 12                       .
        .byte   $12                             ; B182 12                       .
        .byte   $12                             ; B183 12                       .
        .byte   $12                             ; B184 12                       .
        .byte   $03                             ; B185 03                       .
        ora     ($01,x)                         ; B186 01 01                    ..
LB188:  brk                                     ; B188 00                       .
        .byte   $03                             ; B189 03                       .
        .byte   $02                             ; B18A 02                       .
        .byte   $02                             ; B18B 02                       .
        .byte   $02                             ; B18C 02                       .
        .byte   $02                             ; B18D 02                       .
LB18E:  .byte   $03                             ; B18E 03                       .
        brk                                     ; B18F 00                       .
        brk                                     ; B190 00                       .
        .byte   $02                             ; B191 02                       .
        .byte   $02                             ; B192 02                       .
LB193:  .byte   $02                             ; B193 02                       .
        .byte   $02                             ; B194 02                       .
        .byte   $02                             ; B195 02                       .
        .byte   $02                             ; B196 02                       .
        brk                                     ; B197 00                       .
        ora     ($01,x)                         ; B198 01 01                    ..
        ora     ($01,x)                         ; B19A 01 01                    ..
        ora     ($01,x)                         ; B19C 01 01                    ..
LB19E:  ora     ($01,x)                         ; B19E 01 01                    ..
        .byte   $02                             ; B1A0 02                       .
        .byte   $02                             ; B1A1 02                       .
        .byte   $02                             ; B1A2 02                       .
        .byte   $02                             ; B1A3 02                       .
        .byte   $02                             ; B1A4 02                       .
        .byte   $02                             ; B1A5 02                       .
        .byte   $02                             ; B1A6 02                       .
        ora     ($02,x)                         ; B1A7 01 02                    ..
        .byte   $02                             ; B1A9 02                       .
        .byte   $02                             ; B1AA 02                       .
        .byte   $02                             ; B1AB 02                       .
        ora     ($01,x)                         ; B1AC 01 01                    ..
        ora     ($01,x)                         ; B1AE 01 01                    ..
        .byte   $02                             ; B1B0 02                       .
        .byte   $02                             ; B1B1 02                       .
        .byte   $02                             ; B1B2 02                       .
        .byte   $02                             ; B1B3 02                       .
        ora     ($01,x)                         ; B1B4 01 01                    ..
        ora     ($02,x)                         ; B1B6 01 02                    ..
        .byte   $02                             ; B1B8 02                       .
        .byte   $02                             ; B1B9 02                       .
        .byte   $02                             ; B1BA 02                       .
        .byte   $03                             ; B1BB 03                       .
        .byte   $03                             ; B1BC 03                       .
        .byte   $03                             ; B1BD 03                       .
        .byte   $03                             ; B1BE 03                       .
        .byte   $02                             ; B1BF 02                       .
        brk                                     ; B1C0 00                       .
        .byte   $02                             ; B1C1 02                       .
        .byte   $02                             ; B1C2 02                       .
        .byte   $03                             ; B1C3 03                       .
        .byte   $03                             ; B1C4 03                       .
        ora     ($01,x)                         ; B1C5 01 01                    ..
        .byte   $02                             ; B1C7 02                       .
        brk                                     ; B1C8 00                       .
        .byte   $02                             ; B1C9 02                       .
        .byte   $02                             ; B1CA 02                       .
        ora     ($01,x)                         ; B1CB 01 01                    ..
        ora     ($01,x)                         ; B1CD 01 01                    ..
        brk                                     ; B1CF 00                       .
        brk                                     ; B1D0 00                       .
        .byte   $03                             ; B1D1 03                       .
        .byte   $03                             ; B1D2 03                       .
        .byte   $03                             ; B1D3 03                       .
        .byte   $03                             ; B1D4 03                       .
        .byte   $03                             ; B1D5 03                       .
        .byte   $03                             ; B1D6 03                       .
        .byte   $03                             ; B1D7 03                       .
LB1D8:  brk                                     ; B1D8 00                       .
        ora     ($01,x)                         ; B1D9 01 01                    ..
        ora     ($01,x)                         ; B1DB 01 01                    ..
        ora     ($01,x)                         ; B1DD 01 01                    ..
        brk                                     ; B1DF 00                       .
        .byte   $02                             ; B1E0 02                       .
        .byte   $02                             ; B1E1 02                       .
        .byte   $02                             ; B1E2 02                       .
        .byte   $02                             ; B1E3 02                       .
        bpl     LB1F6                           ; B1E4 10 10                    ..
        beq     LB1D8                           ; B1E6 F0 F0                    ..
        ora     ($02,x)                         ; B1E8 01 02                    ..
        .byte   $02                             ; B1EA 02                       .
        ora     ($10,x)                         ; B1EB 01 10                    ..
        bpl     LB1FF                           ; B1ED 10 10                    ..
        bpl     LB1F2                           ; B1EF 10 01                    ..
        .byte   $01                             ; B1F1 01                       .
LB1F2:  ora     ($01,x)                         ; B1F2 01 01                    ..
        bpl     LB206                           ; B1F4 10 10                    ..
LB1F6:  bpl     LB208                           ; B1F6 10 10                    ..
        bpl     LB20A                           ; B1F8 10 10                    ..
        bpl     LB20C                           ; B1FA 10 10                    ..
        bpl     LB20E                           ; B1FC 10 10                    ..
        .byte   $10                             ; B1FE 10                       .
LB1FF:  bpl     LB201                           ; B1FF 10 00                    ..
LB201:  brk                                     ; B201 00                       .
        brk                                     ; B202 00                       .
        brk                                     ; B203 00                       .
        brk                                     ; B204 00                       .
        php                                     ; B205 08                       .
LB206:  brk                                     ; B206 00                       .
        php                                     ; B207 08                       .
LB208:  php                                     ; B208 08                       .
        php                                     ; B209 08                       .
LB20A:  php                                     ; B20A 08                       .
        php                                     ; B20B 08                       .
LB20C:  brk                                     ; B20C 00                       .
        brk                                     ; B20D 00                       .
LB20E:  php                                     ; B20E 08                       .
        php                                     ; B20F 08                       .
        bit     $342D                           ; B210 2C 2D 34                 ,-4
        and     $04,x                           ; B213 35 04                    5.
        ora     L0020                           ; B215 05 20                    . 
        bpl     LB21D                           ; B217 10 04                    ..
        ora     $0C                             ; B219 05 0C                    ..
        .byte   $0D                             ; B21B 0D                       .
        .byte   $04                             ; B21C 04                       .
LB21D:  ora     $10                             ; B21D 05 10                    ..
        clc                                     ; B21F 18                       .
        bit     $2C2D                           ; B220 2C 2D 2C                 ,-,
        and     $2E2E                           ; B223 2D 2E 2E                 -..
        .byte   $37                             ; B226 37                       7
        .byte   $37                             ; B227 37                       7
        rol     $3786                           ; B228 2E 86 37                 ..7
        ora     ($85),y                         ; B22B 11 85                    ..
        .byte   $87                             ; B22D 87                       .
        ora     $3709,y                         ; B22E 19 09 37                 ..7
        .byte   $37                             ; B231 37                       7
        .byte   $37                             ; B232 37                       7
        .byte   $37                             ; B233 37                       7
        .byte   $37                             ; B234 37                       7
        ora     ($37),y                         ; B235 11 37                    .7
        ora     ($19),y                         ; B237 11 19                    ..
        ora     #$19                            ; B239 09 19                    ..
        ora     #$10                            ; B23B 09 10                    ..
        bpl     LB24B                           ; B23D 10 0C                    ..
        ora     $1514                           ; B23F 0D 14 15                 ...
        .byte   $1C                             ; B242 1C                       .
        ora     $0504,x                         ; B243 1D 04 05                 ...
        rol     $042E                           ; B246 2E 2E 04                 ...
        ora     $2E                             ; B249 05 2E                    ..
LB24B:  stx     $10                             ; B24B 86 10                    ..
        clc                                     ; B24D 18                       .
        brk                                     ; B24E 00                       .
        .byte   $27                             ; B24F 27                       '
        .byte   $34                             ; B250 34                       4
        and     $06,x                           ; B251 35 06                    5.
        .byte   $07                             ; B253 07                       .
        jsr     L0C10                           ; B254 20 10 0C                  ..
        ora     $0F0E                           ; B257 0D 0E 0F                 ...
        asl     $17,x                           ; B25A 16 17                    ..
        bpl     LB276                           ; B25C 10 18                    ..
        bpl     LB278                           ; B25E 10 18                    ..
        asl     $341F,x                         ; B260 1E 1F 34                 ..4
        and     L0020,x                         ; B263 35 20                    5 
        bpl     LB287                           ; B265 10 20                    . 
        bpl     LB281                           ; B267 10 18                    ..
        .byte   $34                             ; B269 34                       4
        ora     $3506                           ; B26A 0D 06 35                 ..5
        jsr     L2607                           ; B26D 20 07 26                  .&
        bit     $0A2D                           ; B270 2C 2D 0A                 ,-.
        .byte   $0B                             ; B273 0B                       .
        bpl     LB286                           ; B274 10 10                    ..
LB276:  brk                                     ; B276 00                       .
        asl     a                               ; B277 0A                       .
LB278:  bpl     LB28A                           ; B278 10 10                    ..
        .byte   $0B                             ; B27A 0B                       .
        brk                                     ; B27B 00                       .
        clc                                     ; B27C 18                       .
        .byte   $34                             ; B27D 34                       4
        .byte   $27                             ; B27E 27                       '
        asl     $35                             ; B27F 06 35                    .5
LB281:  jsr     L0C07                           ; B281 20 07 0C                  ..
        ora     $0E                             ; B284 05 0E                    ..
LB286:  .byte   $0D                             ; B286 0D                       .
LB287:  asl     $0F,x                           ; B287 16 0F                    ..
        brk                                     ; B289 00                       .
LB28A:  .byte   $17                             ; B28A 17                       .
        brk                                     ; B28B 00                       .
        .byte   $12                             ; B28C 12                       .
        .byte   $13                             ; B28D 13                       .
        .byte   $1A                             ; B28E 1A                       .
        .byte   $1B                             ; B28F 1B                       .
        brk                                     ; B290 00                       .
        .byte   $12                             ; B291 12                       .
        brk                                     ; B292 00                       .
        .byte   $1A                             ; B293 1A                       .
        .byte   $13                             ; B294 13                       .
        brk                                     ; B295 00                       .
        .byte   $1B                             ; B296 1B                       .
        brk                                     ; B297 00                       .
        brk                                     ; B298 00                       .
        asl     $1600                           ; B299 0E 00 16                 ...
        .byte   $0F                             ; B29C 0F                       .
        .byte   $04                             ; B29D 04                       .
        .byte   $17                             ; B29E 17                       .
        .byte   $0C                             ; B29F 0C                       .
        clc                                     ; B2A0 18                       .
        asl     $060D,x                         ; B2A1 1E 0D 06                 ...
        .byte   $1F                             ; B2A4 1F                       .
        jsr     L2607                           ; B2A5 20 07 26                  .&
        ora     ($0B,x)                         ; B2A8 01 0B                    ..
        .byte   $02                             ; B2AA 02                       .
        .byte   $13                             ; B2AB 13                       .
        clc                                     ; B2AC 18                       .
        jsr     L0627                           ; B2AD 20 27 06                  '.
LB2B0:  clc                                     ; B2B0 18                       .
        jsr     L2607                           ; B2B1 20 07 26                  .&
        asl     a                               ; B2B4 0A                       .
        ora     ($12,x)                         ; B2B5 01 12                    ..
        .byte   $02                             ; B2B7 02                       .
        clc                                     ; B2B8 18                       .
        asl     L0627,x                         ; B2B9 1E 27 06                 .'.
        .byte   $1F                             ; B2BC 1F                       .
        jsr     L0C07                           ; B2BD 20 07 0C                  ..
        .byte   $02                             ; B2C0 02                       .
        .byte   $1B                             ; B2C1 1B                       .
        .byte   $02                             ; B2C2 02                       .
        .byte   $0B                             ; B2C3 0B                       .
        .byte   $1A                             ; B2C4 1A                       .
        .byte   $02                             ; B2C5 02                       .
        asl     a                               ; B2C6 0A                       .
        .byte   $02                             ; B2C7 02                       .
        .byte   $02                             ; B2C8 02                       .
        .byte   $13                             ; B2C9 13                       .
        .byte   $02                             ; B2CA 02                       .
        .byte   $1B                             ; B2CB 1B                       .
        .byte   $12                             ; B2CC 12                       .
        .byte   $02                             ; B2CD 02                       .
        .byte   $1A                             ; B2CE 1A                       .
        .byte   $02                             ; B2CF 02                       .
        .byte   $02                             ; B2D0 02                       .
        .byte   $0B                             ; B2D1 0B                       .
        .byte   $02                             ; B2D2 02                       .
        .byte   $13                             ; B2D3 13                       .
        asl     a                               ; B2D4 0A                       .
        .byte   $02                             ; B2D5 02                       .
        .byte   $12                             ; B2D6 12                       .
        .byte   $02                             ; B2D7 02                       .
        clc                                     ; B2D8 18                       .
        asl     $3418,x                         ; B2D9 1E 18 34                 ..4
        .byte   $1F                             ; B2DC 1F                       .
        jsr     L2035                           ; B2DD 20 35 20                  5 
        .byte   $04                             ; B2E0 04                       .
        bit     $3418                           ; B2E1 2C 18 34                 ,.4
        and     $3505                           ; B2E4 2D 05 35                 -.5
        jsr     LE4E5                           ; B2E7 20 E5 E4                  ..
        sbc     $E5EC                           ; B2EA ED EC E5                 ...
        brk                                     ; B2ED 00                       .
        sbc     a:$E6                           ; B2EE ED E6 00                 ...
        cpx     $E7                             ; B2F1 E4 E7                    ..
        cpx     $F4F5                           ; B2F3 EC F5 F4                 ...
        sbc     $F5F8,y                         ; B2F6 F9 F8 F5                 ...
        inc     $3BF9                           ; B2F9 EE F9 3B                 ..;
        .byte   $EF                             ; B2FC EF                       .
        .byte   $F4                             ; B2FD F4                       .
        .byte   $33                             ; B2FE 33                       3
        sed                                     ; B2FF F8                       .
        bvc     LB353                           ; B300 50 51                    PQ
        jmp     L524D                           ; B302 4C 4D 52                 LMR

; ----------------------------------------------------------------------------
        pha                                     ; B305 48                       H
        lsr     $484F                           ; B306 4E 4F 48                 NOH
        .byte   $53                             ; B309 53                       S
        lsr     a                               ; B30A 4A                       J
        .byte   $4B                             ; B30B 4B                       K
        .byte   $5C                             ; B30C 5C                       \
        adc     $7049,y                         ; B30D 79 49 70                 yIp
        .byte   $7A                             ; B310 7A                       z
        .byte   $7B                             ; B311 7B                       {
        adc     ($72),y                         ; B312 71 72                    qr
        ror     $7379,x                         ; B314 7E 79 73                 ~ys
        bvs     LB361                           ; B317 70 48                    pH
        rts                                     ; B319 60                       `

; ----------------------------------------------------------------------------
        eor     #$68                            ; B31A 49 68                    Ih
        adc     ($62,x)                         ; B31C 61 62                    ab
        adc     #$6A                            ; B31E 69 6A                    ij
        .byte   $63                             ; B320 63                       c
        rts                                     ; B321 60                       `

; ----------------------------------------------------------------------------
        .byte   $6B                             ; B322 6B                       k
        pla                                     ; B323 68                       h
        pha                                     ; B324 48                       H
        bvs     LB370                           ; B325 70 49                    pI
        bvs     LB39A                           ; B327 70 71                    pq
        lsr     $5E71,x                         ; B329 5E 71 5E                 ^q^
        eor     $5F,x                           ; B32C 55 5F                    U_
        lsr     $5F,x                           ; B32E 56 5F                    V_
        adc     ($72),y                         ; B330 71 72                    qr
        adc     ($72),y                         ; B332 71 72                    qr
        .byte   $73                             ; B334 73                       s
        bvs     LB3AF                           ; B335 70 78                    px
        bvs     LB381                           ; B337 70 48                    pH
        bvs     LB38F                           ; B339 70 54                    pT
        bvs     LB3B0                           ; B33B 70 73                    ps
        bvs     LB3B2                           ; B33D 70 73                    ps
        bvs     LB385                           ; B33F 70 44                    pD
        eor     $58                             ; B341 45 58                    EX
        eor     $4746,y                         ; B343 59 46 47                 YFG
        .byte   $5A                             ; B346 5A                       Z
        pha                                     ; B347 48                       H
        .byte   $42                             ; B348 42                       B
        .byte   $43                             ; B349 43                       C
        pha                                     ; B34A 48                       H
        .byte   $5B                             ; B34B 5B                       [
        bvc     LB39F                           ; B34C 50 51                    PQ
        cli                                     ; B34E 58                       X
        eor     $4852,y                         ; B34F 59 52 48                 YRH
        cli                                     ; B352 58                       X
LB353:  eor     #$48                            ; B353 49 48                    IH
        .byte   $53                             ; B355 53                       S
        eor     #$5B                            ; B356 49 5B                    I[
        ror     $7879,x                         ; B358 7E 79 78                 ~yx
        bvs     LB3D7                           ; B35B 70 7A                    pz
        eor     #$71                            ; B35D 49 71                    Iq
        eor     #$61                            ; B35F 49 61                    Ia
LB361:  pha                                     ; B361 48                       H
        adc     #$48                            ; B362 69 48                    iH
        adc     ($48),y                         ; B364 71 48                    qH
        adc     ($49),y                         ; B366 71 49                    qI
        .byte   $44                             ; B368 44                       D
        lsr     $58                             ; B369 46 58                    FX
        .byte   $5A                             ; B36B 5A                       Z
        .byte   $47                             ; B36C 47                       G
        rts                                     ; B36D 60                       `

; ----------------------------------------------------------------------------
        eor     #$68                            ; B36E 49 68                    Ih
LB370:  bvc     LB3C4                           ; B370 50 52                    PR
        cli                                     ; B372 58                       X
        .byte   $5A                             ; B373 5A                       Z
        adc     ($49),y                         ; B374 71 49                    qI
        adc     ($49),y                         ; B376 71 49                    qI
        bvc     LB3CC                           ; B378 50 52                    PR
        jmp     L494E                           ; B37A 4C 4E 49                 LNI

; ----------------------------------------------------------------------------
        rts                                     ; B37D 60                       `

; ----------------------------------------------------------------------------
        .byte   $4F                             ; B37E 4F                       O
        pla                                     ; B37F 68                       h
        .byte   $61                             ; B380 61                       a
LB381:  pha                                     ; B381 48                       H
        adc     #$49                            ; B382 69 49                    iI
        .byte   $7E                             ; B384 7E                       ~
LB385:  bvs     LB3FA                           ; B385 70 73                    ps
        bvs     LB405                           ; B387 70 7C                    p|
        adc     L797E,x                         ; B389 7D 7E 79                 }~y
        .byte   $74                             ; B38C 74                       t
        adc     $7A,x                           ; B38D 75 7A                    uz
LB38F:  .byte   $7B                             ; B38F 7B                       {
        adc     $7E7D,x                         ; B390 7D 7D 7E                 }}~
        adc     $7F7D,y                         ; B393 79 7D 7F                 y}.
        .byte   $7A                             ; B396 7A                       z
        .byte   $7B                             ; B397 7B                       {
        adc     ($72),y                         ; B398 71 72                    qr
LB39A:  adc     ($5E),y                         ; B39A 71 5E                    q^
        .byte   $73                             ; B39C 73                       s
        bvs     LB3F4                           ; B39D 70 55                    pU
LB39F:  .byte   $5F                             ; B39F 5F                       _
        eor     $565F,x                         ; B3A0 5D 5F 56                 ]_V
        .byte   $5F                             ; B3A3 5F                       _
        ror     $66                             ; B3A4 66 66                    ff
        ror     $77,x                           ; B3A6 76 77                    vw
        .byte   $64                             ; B3A8 64                       d
        adc     $6C                             ; B3A9 65 6C                    el
        adc     $6666                           ; B3AB 6D 66 66                 mff
        .byte   $74                             ; B3AE 74                       t
LB3AF:  .byte   $75                             ; B3AF 75                       u
LB3B0:  ror     $66                             ; B3B0 66 66                    ff
LB3B2:  ror     $6E6E                           ; B3B2 6E 6E 6E                 nnn
        ror     $6E6E                           ; B3B5 6E 6E 6E                 nnn
        jmp     (L6C6D)                         ; B3B8 6C 6D 6C                 lml

; ----------------------------------------------------------------------------
        adc     $7574                           ; B3BB 6D 74 75                 mtu
        ror     $496E                           ; B3BE 6E 6E 49                 nnI
        .byte   $53                             ; B3C1 53                       S
        pha                                     ; B3C2 48                       H
        .byte   $5B                             ; B3C3 5B                       [
LB3C4:  .byte   $52                             ; B3C4 52                       R
        pha                                     ; B3C5 48                       H
        .byte   $5A                             ; B3C6 5A                       Z
        .byte   $54                             ; B3C7 54                       T
        pha                                     ; B3C8 48                       H
        .byte   $53                             ; B3C9 53                       S
        .byte   $54                             ; B3CA 54                       T
        .byte   $5B                             ; B3CB 5B                       [
LB3CC:  .byte   $52                             ; B3CC 52                       R
        inc     $5A,x                           ; B3CD F6 5A                    .Z
        inc     $53F7,x                         ; B3CF FE F7 53                 ..S
        .byte   $FF                             ; B3D2 FF                       .
        .byte   $5B                             ; B3D3 5B                       [
        eor     #$53                            ; B3D4 49 53                    IS
        lsr     a                               ; B3D6 4A                       J
LB3D7:  .byte   $4B                             ; B3D7 4B                       K
        .byte   $52                             ; B3D8 52                       R
        .byte   $5C                             ; B3D9 5C                       \
        lsr     $5C4F                           ; B3DA 4E 4F 5C                 NO\
        .byte   $53                             ; B3DD 53                       S
        eor     #$5B                            ; B3DE 49 5B                    I[
        lsr     a                               ; B3E0 4A                       J
        .byte   $4F                             ; B3E1 4F                       O
        .byte   $7A                             ; B3E2 7A                       z
        .byte   $7B                             ; B3E3 7B                       {
        lsr     a                               ; B3E4 4A                       J
        .byte   $4B                             ; B3E5 4B                       K
        .byte   $6F                             ; B3E6 6F                       o
        .byte   $67                             ; B3E7 67                       g
        eor     $7A4E                           ; B3E8 4D 4E 7A                 MNz
        eor     ($71,x)                         ; B3EB 41 71                    Aq
        eor     ($71,x)                         ; B3ED 41 71                    Aq
        eor     ($48,x)                         ; B3EF 41 48                    AH
        pha                                     ; B3F1 48                       H
        .byte   $54                             ; B3F2 54                       T
        .byte   $54                             ; B3F3 54                       T
LB3F4:  .byte   $53                             ; B3F4 53                       S
        eor     ($5B),y                         ; B3F5 51 5B                    Q[
        eor     $4952,y                         ; B3F7 59 52 49                 YRI
LB3FA:  .byte   $5A                             ; B3FA 5A                       Z
        pha                                     ; B3FB 48                       H
        inc     $F7,x                           ; B3FC F6 F7                    ..
        inc     $5CFF,x                         ; B3FE FE FF 5C                 ..\
        .byte   $5C                             ; B401 5C                       \
        pha                                     ; B402 48                       H
        pha                                     ; B403 48                       H
        .byte   $52                             ; B404 52                       R
LB405:  .byte   $5C                             ; B405 5C                       \
        .byte   $5A                             ; B406 5A                       Z
        pha                                     ; B407 48                       H
        .byte   $5C                             ; B408 5C                       \
        .byte   $53                             ; B409 53                       S
        pha                                     ; B40A 48                       H
        .byte   $5B                             ; B40B 5B                       [
        .byte   $52                             ; B40C 52                       R
        pha                                     ; B40D 48                       H
        .byte   $5A                             ; B40E 5A                       Z
        eor     #$57                            ; B40F 49 57                    IW
        rti                                     ; B411 40                       @

; ----------------------------------------------------------------------------
        ror     $4B79,x                         ; B412 7E 79 4B                 ~yK
LB415:  jmp     L7B7A                           ; B415 4C 7A 7B                 Lz{

; ----------------------------------------------------------------------------
        lsr     $7E57                           ; B418 4E 57 7E                 NW~
        adc     $4B40,y                         ; B41B 79 40 4B                 y@K
        .byte   $7A                             ; B41E 7A                       z
        .byte   $7B                             ; B41F 7B                       {
        eor     $7E4E                           ; B420 4D 4E 7E                 MN~
        adc     $4057,y                         ; B423 79 57 40                 yW@
        .byte   $7A                             ; B426 7A                       z
        .byte   $7B                             ; B427 7B                       {
        .byte   $4B                             ; B428 4B                       K
        jmp     L797E                           ; B429 4C 7E 79                 L~y

; ----------------------------------------------------------------------------
        lsr     $7A4F                           ; B42C 4E 4F 7A                 NOz
        eor     (L0000,x)                       ; B42F 41 00                    A.
        .byte   $7B                             ; B431 7B                       {
        brk                                     ; B432 00                       .
        .byte   $72                             ; B433 72                       r
        brk                                     ; B434 00                       .
        lsr     $5E00,x                         ; B435 5E 00 5E                 ^.^
        eor     $5F,x                           ; B438 55 5F                    U_
        eor     a:$5F,x                         ; B43A 5D 5F 00                 ]_.
        lsr     $7200,x                         ; B43D 5E 00 72                 ^.r
        lsr     $5F,x                           ; B440 56 5F                    V_
        .byte   $73                             ; B442 73                       s
        bvs     LB4B6                           ; B443 70 71                    pq
        lsr     $7271,x                         ; B445 5E 71 72                 ^qr
        brk                                     ; B448 00                       .
        .byte   $62                             ; B449 62                       b
        brk                                     ; B44A 00                       .
        ror     a                               ; B44B 6A                       j
        brk                                     ; B44C 00                       .
        .byte   $72                             ; B44D 72                       r
        brk                                     ; B44E 00                       .
        .byte   $72                             ; B44F 72                       r
        lsr     a                               ; B450 4A                       J
        .byte   $4B                             ; B451 4B                       K
        and     $7B                             ; B452 25 7B                    %{
        jmp     L7E4D                           ; B454 4C 4D 7E                 LM~

; ----------------------------------------------------------------------------
        .byte   $2B                             ; B457 2B                       +
        lsr     $7A4F                           ; B458 4E 4F 7A                 NOz
        .byte   $7B                             ; B45B 7B                       {
        .byte   $2F                             ; B45C 2F                       /
        rol     $3C,x                           ; B45D 36 3C                    6<
        .byte   $3C                             ; B45F 3C                       <
        rol     $3A,x                           ; B460 36 3A                    6:
        .byte   $3C                             ; B462 3C                       <
        .byte   $3C                             ; B463 3C                       <
        and     $7A3E,x                         ; B464 3D 3E 7A                 =>z
        .byte   $7B                             ; B467 7B                       {
        rol     $7E3F,x                         ; B468 3E 3F 7E                 >?~
        adc     $2164,y                         ; B46B 79 64 21                 yd!
        jmp     (L6C22)                         ; B46E 6C 22 6C                 l"l

; ----------------------------------------------------------------------------
        bit     $6C                             ; B471 24 6C                    $l
        .byte   $22                             ; B473 22                       "
        sbc     $F9F8,y                         ; B474 F9 F8 F9                 ...
        sed                                     ; B477 F8                       .
        sbc     $F93B,y                         ; B478 F9 3B F9                 .;.
        .byte   $3B                             ; B47B 3B                       ;
        .byte   $33                             ; B47C 33                       3
        sed                                     ; B47D F8                       .
        .byte   $33                             ; B47E 33                       3
        sed                                     ; B47F F8                       .
        brk                                     ; B480 00                       .
        .byte   $89                             ; B481 89                       .
        bcc     LB415                           ; B482 90 91                    ..
        txa                                     ; B484 8A                       .
        .byte   $8B                             ; B485 8B                       .
        .byte   $92                             ; B486 92                       .
        .byte   $93                             ; B487 93                       .
        sty     $948D                           ; B488 8C 8D 94                 ...
        sta     $8E,x                           ; B48B 95 8E                    ..
        brk                                     ; B48D 00                       .
        stx     $97,y                           ; B48E 96 97                    ..
        tya                                     ; B490 98                       .
        sta     L0000,y                         ; B491 99 00 00                 ...
        txs                                     ; B494 9A                       .
        .byte   $9B                             ; B495 9B                       .
        brk                                     ; B496 00                       .
        brk                                     ; B497 00                       .
        .byte   $9C                             ; B498 9C                       .
        sta     a:L0000,x                       ; B499 9D 00 00                 ...
        .byte   $9E                             ; B49C 9E                       .
        .byte   $9F                             ; B49D 9F                       .
        brk                                     ; B49E 00                       .
        brk                                     ; B49F 00                       .
        brk                                     ; B4A0 00                       .
        brk                                     ; B4A1 00                       .
        brk                                     ; B4A2 00                       .
        .byte   $A7                             ; B4A3 A7                       .
        brk                                     ; B4A4 00                       .
        brk                                     ; B4A5 00                       .
        .byte   $AF                             ; B4A6 AF                       .
        .byte   $B7                             ; B4A7 B7                       .
        brk                                     ; B4A8 00                       .
        brk                                     ; B4A9 00                       .
        .byte   $BF                             ; B4AA BF                       .
        .byte   $C7                             ; B4AB C7                       .
        ldy     #$A1                            ; B4AC A0 A1                    ..
        tay                                     ; B4AE A8                       .
        lda     #$A2                            ; B4AF A9 A2                    ..
        .byte   $A3                             ; B4B1 A3                       .
        tax                                     ; B4B2 AA                       .
        .byte   $AB                             ; B4B3 AB                       .
        ldy     $A5                             ; B4B4 A4 A5                    ..
LB4B6:  ldy     LA6AD                           ; B4B6 AC AD A6                 ...
        brk                                     ; B4B9 00                       .
        ldx     LB000                           ; B4BA AE 00 B0                 ...
        lda     ($B8),y                         ; B4BD B1 B8                    ..
        lda     LB3B2,y                         ; B4BF B9 B2 B3                 ...
        tsx                                     ; B4C2 BA                       .
        .byte   $BB                             ; B4C3 BB                       .
        ldy     $B5,x                           ; B4C4 B4 B5                    ..
        ldy     LB6BD,x                         ; B4C6 BC BD B6                 ...
        brk                                     ; B4C9 00                       .
        ldx     a:L0000,y                       ; B4CA BE 00 00                 ...
        cmp     (L0000,x)                       ; B4CD C1 00                    ..
        cmp     #$C2                            ; B4CF C9 C2                    ..
        .byte   $C3                             ; B4D1 C3                       .
        dex                                     ; B4D2 CA                       .
        .byte   $CB                             ; B4D3 CB                       .
        cpy     $C5                             ; B4D4 C4 C5                    ..
        cpy     $C6CD                           ; B4D6 CC CD C6                 ...
        brk                                     ; B4D9 00                       .
        dec     a:L0000                         ; B4DA CE 00 00                 ...
        cmp     (L0000),y                       ; B4DD D1 00                    ..
        cmp     $D3D2,y                         ; B4DF D9 D2 D3                 ...
        .byte   $DA                             ; B4E2 DA                       .
        .byte   $DB                             ; B4E3 DB                       .
        .byte   $D4                             ; B4E4 D4                       .
        cmp     $DC,x                           ; B4E5 D5 DC                    ..
        cmp     $D7D6,x                         ; B4E7 DD D6 D7                 ...
        dec     a:$DF,x                         ; B4EA DE DF 00                 ...
        brk                                     ; B4ED 00                       .
        cpx     #$E1                            ; B4EE E0 E1                    ..
        brk                                     ; B4F0 00                       .
        brk                                     ; B4F1 00                       .
        .byte   $E2                             ; B4F2 E2                       .
        .byte   $E3                             ; B4F3 E3                       .
        inx                                     ; B4F4 E8                       .
        sbc     #$F0                            ; B4F5 E9 F0                    ..
        sbc     ($EA),y                         ; B4F7 F1 EA                    ..
        .byte   $EB                             ; B4F9 EB                       .
        .byte   $F2                             ; B4FA F2                       .
        .byte   $F3                             ; B4FB F3                       .
        brk                                     ; B4FC 00                       .
        .byte   $87                             ; B4FD 87                       .
        ora     $09,y                           ; B4FE 19 09 00                 ...
        brk                                     ; B501 00                       .
        brk                                     ; B502 00                       .
        brk                                     ; B503 00                       .
        brk                                     ; B504 00                       .
        brk                                     ; B505 00                       .
        brk                                     ; B506 00                       .
        brk                                     ; B507 00                       .
        brk                                     ; B508 00                       .
        brk                                     ; B509 00                       .
        brk                                     ; B50A 00                       .
        brk                                     ; B50B 00                       .
        brk                                     ; B50C 00                       .
        brk                                     ; B50D 00                       .
        brk                                     ; B50E 00                       .
        brk                                     ; B50F 00                       .
        brk                                     ; B510 00                       .
        brk                                     ; B511 00                       .
        brk                                     ; B512 00                       .
        brk                                     ; B513 00                       .
        brk                                     ; B514 00                       .
        brk                                     ; B515 00                       .
        brk                                     ; B516 00                       .
        brk                                     ; B517 00                       .
        brk                                     ; B518 00                       .
        brk                                     ; B519 00                       .
        brk                                     ; B51A 00                       .
        brk                                     ; B51B 00                       .
        brk                                     ; B51C 00                       .
        brk                                     ; B51D 00                       .
        brk                                     ; B51E 00                       .
        brk                                     ; B51F 00                       .
        brk                                     ; B520 00                       .
        brk                                     ; B521 00                       .
        brk                                     ; B522 00                       .
        brk                                     ; B523 00                       .
        brk                                     ; B524 00                       .
        brk                                     ; B525 00                       .
        brk                                     ; B526 00                       .
        brk                                     ; B527 00                       .
        brk                                     ; B528 00                       .
        brk                                     ; B529 00                       .
        brk                                     ; B52A 00                       .
        brk                                     ; B52B 00                       .
        brk                                     ; B52C 00                       .
        brk                                     ; B52D 00                       .
        brk                                     ; B52E 00                       .
        brk                                     ; B52F 00                       .
        brk                                     ; B530 00                       .
        brk                                     ; B531 00                       .
        brk                                     ; B532 00                       .
        brk                                     ; B533 00                       .
        brk                                     ; B534 00                       .
        brk                                     ; B535 00                       .
        brk                                     ; B536 00                       .
        brk                                     ; B537 00                       .
        brk                                     ; B538 00                       .
        brk                                     ; B539 00                       .
        brk                                     ; B53A 00                       .
        brk                                     ; B53B 00                       .
        brk                                     ; B53C 00                       .
        brk                                     ; B53D 00                       .
        brk                                     ; B53E 00                       .
        brk                                     ; B53F 00                       .
        brk                                     ; B540 00                       .
        brk                                     ; B541 00                       .
        brk                                     ; B542 00                       .
        brk                                     ; B543 00                       .
        brk                                     ; B544 00                       .
        brk                                     ; B545 00                       .
        brk                                     ; B546 00                       .
        brk                                     ; B547 00                       .
        brk                                     ; B548 00                       .
        brk                                     ; B549 00                       .
        brk                                     ; B54A 00                       .
        brk                                     ; B54B 00                       .
        brk                                     ; B54C 00                       .
        brk                                     ; B54D 00                       .
        brk                                     ; B54E 00                       .
        brk                                     ; B54F 00                       .
        brk                                     ; B550 00                       .
        brk                                     ; B551 00                       .
        brk                                     ; B552 00                       .
        brk                                     ; B553 00                       .
        brk                                     ; B554 00                       .
        brk                                     ; B555 00                       .
        brk                                     ; B556 00                       .
        brk                                     ; B557 00                       .
        brk                                     ; B558 00                       .
        brk                                     ; B559 00                       .
        brk                                     ; B55A 00                       .
        brk                                     ; B55B 00                       .
        brk                                     ; B55C 00                       .
        brk                                     ; B55D 00                       .
        brk                                     ; B55E 00                       .
        brk                                     ; B55F 00                       .
        brk                                     ; B560 00                       .
        brk                                     ; B561 00                       .
        brk                                     ; B562 00                       .
        brk                                     ; B563 00                       .
        brk                                     ; B564 00                       .
        brk                                     ; B565 00                       .
        brk                                     ; B566 00                       .
        brk                                     ; B567 00                       .
        brk                                     ; B568 00                       .
        brk                                     ; B569 00                       .
        brk                                     ; B56A 00                       .
        brk                                     ; B56B 00                       .
        brk                                     ; B56C 00                       .
        brk                                     ; B56D 00                       .
        brk                                     ; B56E 00                       .
        brk                                     ; B56F 00                       .
        brk                                     ; B570 00                       .
        brk                                     ; B571 00                       .
        brk                                     ; B572 00                       .
        brk                                     ; B573 00                       .
        brk                                     ; B574 00                       .
        brk                                     ; B575 00                       .
        brk                                     ; B576 00                       .
        brk                                     ; B577 00                       .
        brk                                     ; B578 00                       .
        brk                                     ; B579 00                       .
        brk                                     ; B57A 00                       .
        brk                                     ; B57B 00                       .
        brk                                     ; B57C 00                       .
        brk                                     ; B57D 00                       .
        brk                                     ; B57E 00                       .
        brk                                     ; B57F 00                       .
        brk                                     ; B580 00                       .
        brk                                     ; B581 00                       .
        brk                                     ; B582 00                       .
        brk                                     ; B583 00                       .
        brk                                     ; B584 00                       .
        brk                                     ; B585 00                       .
        brk                                     ; B586 00                       .
        brk                                     ; B587 00                       .
        brk                                     ; B588 00                       .
        brk                                     ; B589 00                       .
        brk                                     ; B58A 00                       .
        brk                                     ; B58B 00                       .
        brk                                     ; B58C 00                       .
        brk                                     ; B58D 00                       .
        brk                                     ; B58E 00                       .
        brk                                     ; B58F 00                       .
        brk                                     ; B590 00                       .
        brk                                     ; B591 00                       .
        brk                                     ; B592 00                       .
        brk                                     ; B593 00                       .
        brk                                     ; B594 00                       .
        brk                                     ; B595 00                       .
        brk                                     ; B596 00                       .
        brk                                     ; B597 00                       .
        brk                                     ; B598 00                       .
        brk                                     ; B599 00                       .
        brk                                     ; B59A 00                       .
        brk                                     ; B59B 00                       .
        brk                                     ; B59C 00                       .
        brk                                     ; B59D 00                       .
        brk                                     ; B59E 00                       .
        brk                                     ; B59F 00                       .
        brk                                     ; B5A0 00                       .
        brk                                     ; B5A1 00                       .
        brk                                     ; B5A2 00                       .
        brk                                     ; B5A3 00                       .
        brk                                     ; B5A4 00                       .
        brk                                     ; B5A5 00                       .
        brk                                     ; B5A6 00                       .
        brk                                     ; B5A7 00                       .
        brk                                     ; B5A8 00                       .
        brk                                     ; B5A9 00                       .
        brk                                     ; B5AA 00                       .
        brk                                     ; B5AB 00                       .
        brk                                     ; B5AC 00                       .
        brk                                     ; B5AD 00                       .
        brk                                     ; B5AE 00                       .
        brk                                     ; B5AF 00                       .
        brk                                     ; B5B0 00                       .
        brk                                     ; B5B1 00                       .
        brk                                     ; B5B2 00                       .
        brk                                     ; B5B3 00                       .
        brk                                     ; B5B4 00                       .
        brk                                     ; B5B5 00                       .
        brk                                     ; B5B6 00                       .
        brk                                     ; B5B7 00                       .
        brk                                     ; B5B8 00                       .
        brk                                     ; B5B9 00                       .
        brk                                     ; B5BA 00                       .
        brk                                     ; B5BB 00                       .
        brk                                     ; B5BC 00                       .
        brk                                     ; B5BD 00                       .
        brk                                     ; B5BE 00                       .
        brk                                     ; B5BF 00                       .
        brk                                     ; B5C0 00                       .
        brk                                     ; B5C1 00                       .
        brk                                     ; B5C2 00                       .
        brk                                     ; B5C3 00                       .
        brk                                     ; B5C4 00                       .
        brk                                     ; B5C5 00                       .
        brk                                     ; B5C6 00                       .
        brk                                     ; B5C7 00                       .
        brk                                     ; B5C8 00                       .
        brk                                     ; B5C9 00                       .
        brk                                     ; B5CA 00                       .
        brk                                     ; B5CB 00                       .
        brk                                     ; B5CC 00                       .
        brk                                     ; B5CD 00                       .
        brk                                     ; B5CE 00                       .
        brk                                     ; B5CF 00                       .
        brk                                     ; B5D0 00                       .
        brk                                     ; B5D1 00                       .
        brk                                     ; B5D2 00                       .
        brk                                     ; B5D3 00                       .
        brk                                     ; B5D4 00                       .
        brk                                     ; B5D5 00                       .
        brk                                     ; B5D6 00                       .
        brk                                     ; B5D7 00                       .
        brk                                     ; B5D8 00                       .
        brk                                     ; B5D9 00                       .
        brk                                     ; B5DA 00                       .
        brk                                     ; B5DB 00                       .
        brk                                     ; B5DC 00                       .
        brk                                     ; B5DD 00                       .
        brk                                     ; B5DE 00                       .
        brk                                     ; B5DF 00                       .
        brk                                     ; B5E0 00                       .
        brk                                     ; B5E1 00                       .
        brk                                     ; B5E2 00                       .
        brk                                     ; B5E3 00                       .
        brk                                     ; B5E4 00                       .
        brk                                     ; B5E5 00                       .
        brk                                     ; B5E6 00                       .
        brk                                     ; B5E7 00                       .
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
        brk                                     ; B600 00                       .
        brk                                     ; B601 00                       .
        brk                                     ; B602 00                       .
        brk                                     ; B603 00                       .
        brk                                     ; B604 00                       .
        brk                                     ; B605 00                       .
        brk                                     ; B606 00                       .
        ora     (L0000,x)                       ; B607 01 00                    ..
        brk                                     ; B609 00                       .
        brk                                     ; B60A 00                       .
        brk                                     ; B60B 00                       .
        brk                                     ; B60C 00                       .
        brk                                     ; B60D 00                       .
        brk                                     ; B60E 00                       .
        ora     (L0000,x)                       ; B60F 01 00                    ..
        brk                                     ; B611 00                       .
        brk                                     ; B612 00                       .
        brk                                     ; B613 00                       .
        brk                                     ; B614 00                       .
        brk                                     ; B615 00                       .
        brk                                     ; B616 00                       .
        ora     (L0000,x)                       ; B617 01 00                    ..
        brk                                     ; B619 00                       .
        brk                                     ; B61A 00                       .
        brk                                     ; B61B 00                       .
        brk                                     ; B61C 00                       .
        brk                                     ; B61D 00                       .
        brk                                     ; B61E 00                       .
        ora     (L0000,x)                       ; B61F 01 00                    ..
        brk                                     ; B621 00                       .
        brk                                     ; B622 00                       .
        brk                                     ; B623 00                       .
        brk                                     ; B624 00                       .
        brk                                     ; B625 00                       .
        brk                                     ; B626 00                       .
        ora     (L0000,x)                       ; B627 01 00                    ..
        brk                                     ; B629 00                       .
        brk                                     ; B62A 00                       .
        brk                                     ; B62B 00                       .
        brk                                     ; B62C 00                       .
        brk                                     ; B62D 00                       .
        brk                                     ; B62E 00                       .
        brk                                     ; B62F 00                       .
        .byte   $02                             ; B630 02                       .
        .byte   $02                             ; B631 02                       .
        .byte   $02                             ; B632 02                       .
        .byte   $02                             ; B633 02                       .
        .byte   $02                             ; B634 02                       .
        .byte   $02                             ; B635 02                       .
        .byte   $02                             ; B636 02                       .
        .byte   $02                             ; B637 02                       .
        .byte   $02                             ; B638 02                       .
        .byte   $02                             ; B639 02                       .
        .byte   $02                             ; B63A 02                       .
        .byte   $02                             ; B63B 02                       .
        .byte   $02                             ; B63C 02                       .
        .byte   $02                             ; B63D 02                       .
        .byte   $02                             ; B63E 02                       .
        .byte   $02                             ; B63F 02                       .
        brk                                     ; B640 00                       .
        brk                                     ; B641 00                       .
        brk                                     ; B642 00                       .
        brk                                     ; B643 00                       .
        brk                                     ; B644 00                       .
        brk                                     ; B645 00                       .
        brk                                     ; B646 00                       .
        ora     (L0000,x)                       ; B647 01 00                    ..
        brk                                     ; B649 00                       .
        brk                                     ; B64A 00                       .
        brk                                     ; B64B 00                       .
        brk                                     ; B64C 00                       .
        brk                                     ; B64D 00                       .
        brk                                     ; B64E 00                       .
        ora     (L0000,x)                       ; B64F 01 00                    ..
        brk                                     ; B651 00                       .
        brk                                     ; B652 00                       .
        brk                                     ; B653 00                       .
        brk                                     ; B654 00                       .
        brk                                     ; B655 00                       .
        brk                                     ; B656 00                       .
        ora     (L0000,x)                       ; B657 01 00                    ..
        brk                                     ; B659 00                       .
        brk                                     ; B65A 00                       .
        brk                                     ; B65B 00                       .
        brk                                     ; B65C 00                       .
        brk                                     ; B65D 00                       .
        brk                                     ; B65E 00                       .
        ora     (L0000,x)                       ; B65F 01 00                    ..
        brk                                     ; B661 00                       .
        brk                                     ; B662 00                       .
        brk                                     ; B663 00                       .
        brk                                     ; B664 00                       .
        brk                                     ; B665 00                       .
        brk                                     ; B666 00                       .
        brk                                     ; B667 00                       .
        .byte   $02                             ; B668 02                       .
        .byte   $02                             ; B669 02                       .
        .byte   $02                             ; B66A 02                       .
        .byte   $02                             ; B66B 02                       .
        .byte   $02                             ; B66C 02                       .
        .byte   $02                             ; B66D 02                       .
        .byte   $02                             ; B66E 02                       .
        .byte   $02                             ; B66F 02                       .
        .byte   $02                             ; B670 02                       .
        .byte   $02                             ; B671 02                       .
        .byte   $02                             ; B672 02                       .
        .byte   $02                             ; B673 02                       .
        .byte   $02                             ; B674 02                       .
        .byte   $03                             ; B675 03                       .
        .byte   $03                             ; B676 03                       .
        .byte   $03                             ; B677 03                       .
        .byte   $02                             ; B678 02                       .
        .byte   $02                             ; B679 02                       .
        .byte   $02                             ; B67A 02                       .
        .byte   $02                             ; B67B 02                       .
        .byte   $02                             ; B67C 02                       .
        .byte   $02                             ; B67D 02                       .
        .byte   $02                             ; B67E 02                       .
        .byte   $02                             ; B67F 02                       .
        .byte   $04                             ; B680 04                       .
        ora     $06                             ; B681 05 06                    ..
        asl     $06                             ; B683 06 06                    ..
        asl     $07                             ; B685 06 07                    ..
        .byte   $04                             ; B687 04                       .
        php                                     ; B688 08                       .
        ora     #$0A                            ; B689 09 0A                    ..
        .byte   $0B                             ; B68B 0B                       .
        asl     a                               ; B68C 0A                       .
        .byte   $0B                             ; B68D 0B                       .
        ora     #$08                            ; B68E 09 08                    ..
        php                                     ; B690 08                       .
        .byte   $0C                             ; B691 0C                       .
        ora     $0D0E                           ; B692 0D 0E 0D                 ...
        asl     $080C                           ; B695 0E 0C 08                 ...
        php                                     ; B698 08                       .
        asl     $0D                             ; B699 06 0D                    ..
        asl     $0E0D                           ; B69B 0E 0D 0E                 ...
        .byte   $07                             ; B69E 07                       .
        .byte   $04                             ; B69F 04                       .
        .byte   $04                             ; B6A0 04                       .
        ora     $0D                             ; B6A1 05 0D                    ..
        asl     $0E0D                           ; B6A3 0E 0D 0E                 ...
        ora     #$09                            ; B6A6 09 09                    ..
        php                                     ; B6A8 08                       .
        asl     $0D                             ; B6A9 06 0D                    ..
        asl     $0E0D                           ; B6AB 0E 0D 0E                 ...
        .byte   $0C                             ; B6AE 0C                       .
        .byte   $0C                             ; B6AF 0C                       .
        .byte   $04                             ; B6B0 04                       .
        ora     $07                             ; B6B1 05 07                    ..
        .byte   $04                             ; B6B3 04                       .
        ora     $04                             ; B6B4 05 04                    ..
        ora     $07                             ; B6B6 05 07                    ..
        php                                     ; B6B8 08                       .
        asl     $06                             ; B6B9 06 06                    ..
        php                                     ; B6BB 08                       .
        .byte   $06                             ; B6BC 06                       .
LB6BD:  php                                     ; B6BD 08                       .
        asl     $06                             ; B6BE 06 06                    ..
        ora     $07                             ; B6C0 05 07                    ..
        .byte   $04                             ; B6C2 04                       .
        ora     $06                             ; B6C3 05 06                    ..
        asl     $06                             ; B6C5 06 06                    ..
        asl     $06                             ; B6C7 06 06                    ..
        asl     a                               ; B6C9 0A                       .
        .byte   $0B                             ; B6CA 0B                       .
        asl     a                               ; B6CB 0A                       .
        .byte   $0B                             ; B6CC 0B                       .
        ora     #$09                            ; B6CD 09 09                    ..
        asl     a                               ; B6CF 0A                       .
        asl     $0D                             ; B6D0 06 0D                    ..
        asl     $0E0D                           ; B6D2 0E 0D 0E                 ...
        .byte   $0C                             ; B6D5 0C                       .
        .byte   $0C                             ; B6D6 0C                       .
        ora     $0D05                           ; B6D7 0D 05 0D                 ...
        asl     $0E0D                           ; B6DA 0E 0D 0E                 ...
        .byte   $0C                             ; B6DD 0C                       .
        .byte   $0C                             ; B6DE 0C                       .
        ora     $0D09                           ; B6DF 0D 09 0D                 ...
        asl     $0E0D                           ; B6E2 0E 0D 0E                 ...
        .byte   $0C                             ; B6E5 0C                       .
        .byte   $0C                             ; B6E6 0C                       .
        ora     $0D0C                           ; B6E7 0D 0C 0D                 ...
        asl     $0E0D                           ; B6EA 0E 0D 0E                 ...
        .byte   $0C                             ; B6ED 0C                       .
        .byte   $0C                             ; B6EE 0C                       .
        ora     $0705                           ; B6EF 0D 05 07                 ...
        .byte   $04                             ; B6F2 04                       .
        ora     $06                             ; B6F3 05 06                    ..
        asl     $06                             ; B6F5 06 06                    ..
        asl     $06                             ; B6F7 06 06                    ..
        asl     L0008                           ; B6F9 06 08                    ..
        asl     $06                             ; B6FB 06 06                    ..
        asl     $06                             ; B6FD 06 06                    ..
        asl     $06                             ; B6FF 06 06                    ..
        asl     $0F                             ; B701 06 0F                    ..
        asl     $0F                             ; B703 06 0F                    ..
        .byte   $07                             ; B705 07                       .
        .byte   $04                             ; B706 04                       .
        ora     $0B                             ; B707 05 0B                    ..
        ora     #$06                            ; B709 09 06                    ..
        asl     $06                             ; B70B 06 06                    ..
        asl     L0008                           ; B70D 06 08                    ..
        asl     $0E                             ; B70F 06 0E                    ..
        .byte   $0C                             ; B711 0C                       .
        asl     $06                             ; B712 06 06                    ..
        asl     $07                             ; B714 06 07                    ..
        .byte   $04                             ; B716 04                       .
        ora     $0E                             ; B717 05 0E                    ..
        .byte   $0C                             ; B719 0C                       .
        asl     $06                             ; B71A 06 06                    ..
        asl     $10                             ; B71C 06 10                    ..
        php                                     ; B71E 08                       .
        asl     $0E                             ; B71F 06 0E                    ..
        .byte   $0C                             ; B721 0C                       .
        ora     ($11),y                         ; B722 11 11                    ..
        .byte   $12                             ; B724 12                       .
        .byte   $13                             ; B725 13                       .
        .byte   $14                             ; B726 14                       .
        ora     $0E,x                           ; B727 15 0E                    ..
        .byte   $0C                             ; B729 0C                       .
        .byte   $0C                             ; B72A 0C                       .
        .byte   $0C                             ; B72B 0C                       .
        ora     $1600                           ; B72C 0D 00 16                 ...
        asl     $06                             ; B72F 06 06                    ..
        asl     $06                             ; B731 06 06                    ..
        asl     $06                             ; B733 06 06                    ..
        .byte   $17                             ; B735 17                       .
        clc                                     ; B736 18                       .
        ora     $0606,y                         ; B737 19 06 06                 ...
        asl     $06                             ; B73A 06 06                    ..
        asl     $06                             ; B73C 06 06                    ..
        php                                     ; B73E 08                       .
        asl     $1A                             ; B73F 06 1A                    ..
        .byte   $1B                             ; B741 1B                       .
        .byte   $1C                             ; B742 1C                       .
        ora     $1C1E,x                         ; B743 1D 1E 1C                 ...
        .byte   $1F                             ; B746 1F                       .
        jsr     L2221                           ; B747 20 21 22                  !"
        .byte   $23                             ; B74A 23                       #
        bit     $25                             ; B74B 24 25                    $%
        .byte   $23                             ; B74D 23                       #
        rol     $27                             ; B74E 26 27                    &'
        plp                                     ; B750 28                       (
        and     #$2A                            ; B751 29 2A                    )*
        .byte   $2B                             ; B753 2B                       +
        bit     $2E2D                           ; B754 2C 2D 2E                 ,-.
        .byte   $2F                             ; B757 2F                       /
        and     ($22,x)                         ; B758 21 22                    !"
        bmi     LB782                           ; B75A 30 26                    0&
        .byte   $22                             ; B75C 22                       "
        and     ($26),y                         ; B75D 31 26                    1&
        .byte   $27                             ; B75F 27                       '
        plp                                     ; B760 28                       (
        and     #$32                            ; B761 29 32                    )2
        rol     $3329                           ; B763 2E 29 33                 .)3
        rol     $212F                           ; B766 2E 2F 21                 ./!
        .byte   $22                             ; B769 22                       "
        .byte   $34                             ; B76A 34                       4
        rol     $22                             ; B76B 26 22                    &"
        and     $26,x                           ; B76D 35 26                    5&
        .byte   $27                             ; B76F 27                       '
        rol     $37,x                           ; B770 36 37                    67
        asl     $36                             ; B772 06 36                    .6
        .byte   $37                             ; B774 37                       7
        asl     $36                             ; B775 06 36                    .6
        .byte   $37                             ; B777 37                       7
        sec                                     ; B778 38                       8
        and     $3806,y                         ; B779 39 06 38                 9.8
        and     $3806,y                         ; B77C 39 06 38                 9.8
        and     L0000,y                         ; B77F 39 00 00                 9..
LB782:  brk                                     ; B782 00                       .
        brk                                     ; B783 00                       .
        brk                                     ; B784 00                       .
        brk                                     ; B785 00                       .
        brk                                     ; B786 00                       .
        brk                                     ; B787 00                       .
        brk                                     ; B788 00                       .
        brk                                     ; B789 00                       .
        brk                                     ; B78A 00                       .
        brk                                     ; B78B 00                       .
        brk                                     ; B78C 00                       .
        brk                                     ; B78D 00                       .
        brk                                     ; B78E 00                       .
        brk                                     ; B78F 00                       .
        brk                                     ; B790 00                       .
        brk                                     ; B791 00                       .
        brk                                     ; B792 00                       .
        brk                                     ; B793 00                       .
        brk                                     ; B794 00                       .
        brk                                     ; B795 00                       .
        brk                                     ; B796 00                       .
        brk                                     ; B797 00                       .
        brk                                     ; B798 00                       .
        brk                                     ; B799 00                       .
        brk                                     ; B79A 00                       .
        brk                                     ; B79B 00                       .
        brk                                     ; B79C 00                       .
        brk                                     ; B79D 00                       .
        brk                                     ; B79E 00                       .
        brk                                     ; B79F 00                       .
        brk                                     ; B7A0 00                       .
        brk                                     ; B7A1 00                       .
        brk                                     ; B7A2 00                       .
        brk                                     ; B7A3 00                       .
        brk                                     ; B7A4 00                       .
        brk                                     ; B7A5 00                       .
        brk                                     ; B7A6 00                       .
        brk                                     ; B7A7 00                       .
        brk                                     ; B7A8 00                       .
        brk                                     ; B7A9 00                       .
        brk                                     ; B7AA 00                       .
        brk                                     ; B7AB 00                       .
        brk                                     ; B7AC 00                       .
        brk                                     ; B7AD 00                       .
        brk                                     ; B7AE 00                       .
        brk                                     ; B7AF 00                       .
        .byte   $3A                             ; B7B0 3A                       :
        .byte   $3A                             ; B7B1 3A                       :
        .byte   $3A                             ; B7B2 3A                       :
        .byte   $3B                             ; B7B3 3B                       ;
        .byte   $3C                             ; B7B4 3C                       <
        .byte   $3A                             ; B7B5 3A                       :
        .byte   $3A                             ; B7B6 3A                       :
        .byte   $3A                             ; B7B7 3A                       :
        and     $3D3D,x                         ; B7B8 3D 3D 3D                 ===
        rol     $3D3F,x                         ; B7BB 3E 3F 3D                 >?=
        and     $403D,x                         ; B7BE 3D 3D 40                 ==@
        rti                                     ; B7C1 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B7C2 40                       @

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; B7C3 41 42                    AB
        rti                                     ; B7C5 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B7C6 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B7C7 40                       @

; ----------------------------------------------------------------------------
        .byte   $43                             ; B7C8 43                       C
        .byte   $44                             ; B7C9 44                       D
        eor     $44                             ; B7CA 45 44                    ED
        eor     $44                             ; B7CC 45 44                    ED
        eor     $44                             ; B7CE 45 44                    ED
        lsr     $47                             ; B7D0 46 47                    FG
        pha                                     ; B7D2 48                       H
        .byte   $47                             ; B7D3 47                       G
        pha                                     ; B7D4 48                       H
        .byte   $47                             ; B7D5 47                       G
        pha                                     ; B7D6 48                       H
        .byte   $47                             ; B7D7 47                       G
        eor     #$4A                            ; B7D8 49 4A                    IJ
        .byte   $4B                             ; B7DA 4B                       K
        jmp     L4C4D                           ; B7DB 4C 4D 4C                 LML

; ----------------------------------------------------------------------------
        eor     $464A                           ; B7DE 4D 4A 46                 MJF
        .byte   $47                             ; B7E1 47                       G
        pha                                     ; B7E2 48                       H
        .byte   $47                             ; B7E3 47                       G
        pha                                     ; B7E4 48                       H
        .byte   $47                             ; B7E5 47                       G
        pha                                     ; B7E6 48                       H
        .byte   $47                             ; B7E7 47                       G
        lsr     $4B4A                           ; B7E8 4E 4A 4B                 NJK
        lsr     a                               ; B7EB 4A                       J
        .byte   $4B                             ; B7EC 4B                       K
        jmp     L4A4F                           ; B7ED 4C 4F 4A                 LOJ

; ----------------------------------------------------------------------------
        bvc     LB842                           ; B7F0 50 50                    PP
        bvc     LB845                           ; B7F2 50 51                    PQ
        .byte   $52                             ; B7F4 52                       R
        bvc     LB847                           ; B7F5 50 50                    PP
        bvc     LB84C                           ; B7F7 50 53                    PS
        .byte   $53                             ; B7F9 53                       S
        .byte   $53                             ; B7FA 53                       S
        .byte   $54                             ; B7FB 54                       T
        eor     $53,x                           ; B7FC 55 53                    US
        .byte   $53                             ; B7FE 53                       S
        .byte   $53                             ; B7FF 53                       S
        rti                                     ; B800 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B801 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B802 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B803 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B804 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B805 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B806 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B807 40                       @

; ----------------------------------------------------------------------------
        eor     $44                             ; B808 45 44                    ED
        eor     $44                             ; B80A 45 44                    ED
        lsr     $44,x                           ; B80C 56 44                    VD
        lsr     $57,x                           ; B80E 56 57                    VW
        pha                                     ; B810 48                       H
        .byte   $47                             ; B811 47                       G
        pha                                     ; B812 48                       H
        .byte   $47                             ; B813 47                       G
        pha                                     ; B814 48                       H
        .byte   $47                             ; B815 47                       G
        pha                                     ; B816 48                       H
        cli                                     ; B817 58                       X
        .byte   $4B                             ; B818 4B                       K
        jmp     L4C4F                           ; B819 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        eor     $4D4C                           ; B81C 4D 4C 4D                 MLM
        eor     L4748,y                         ; B81F 59 48 47                 YHG
        pha                                     ; B822 48                       H
        .byte   $47                             ; B823 47                       G
        pha                                     ; B824 48                       H
        .byte   $47                             ; B825 47                       G
        pha                                     ; B826 48                       H
        cli                                     ; B827 58                       X
        .byte   $4B                             ; B828 4B                       K
        lsr     a                               ; B829 4A                       J
        .byte   $4B                             ; B82A 4B                       K
        jmp     L4C4F                           ; B82B 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        eor     $5059                           ; B82E 4D 59 50                 MYP
        bvc     LB883                           ; B831 50 50                    PP
        bvc     LB885                           ; B833 50 50                    PP
        .byte   $5A                             ; B835 5A                       Z
        .byte   $5B                             ; B836 5B                       [
        cli                                     ; B837 58                       X
        .byte   $53                             ; B838 53                       S
        .byte   $53                             ; B839 53                       S
        .byte   $53                             ; B83A 53                       S
        .byte   $53                             ; B83B 53                       S
        .byte   $53                             ; B83C 53                       S
        .byte   $5C                             ; B83D 5C                       \
        eor     #$5D                            ; B83E 49 5D                    I]
        rti                                     ; B840 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B841 40                       @

; ----------------------------------------------------------------------------
LB842:  rti                                     ; B842 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B843 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B844 40                       @

; ----------------------------------------------------------------------------
LB845:  .byte   $5E                             ; B845 5E                       ^
        .byte   $5F                             ; B846 5F                       _
LB847:  rts                                     ; B847 60                       `

; ----------------------------------------------------------------------------
        eor     $44                             ; B848 45 44                    ED
        eor     $44                             ; B84A 45 44                    ED
LB84C:  eor     $44                             ; B84C 45 44                    ED
        adc     ($59,x)                         ; B84E 61 59                    aY
        pha                                     ; B850 48                       H
        .byte   $47                             ; B851 47                       G
        pha                                     ; B852 48                       H
        .byte   $47                             ; B853 47                       G
        pha                                     ; B854 48                       H
        .byte   $47                             ; B855 47                       G
        pha                                     ; B856 48                       H
        rts                                     ; B857 60                       `

; ----------------------------------------------------------------------------
        eor     $4D4C                           ; B858 4D 4C 4D                 MLM
        jmp     L6362                           ; B85B 4C 62 63                 Lbc

; ----------------------------------------------------------------------------
        .byte   $64                             ; B85E 64                       d
        adc     $48                             ; B85F 65 48                    eH
        .byte   $47                             ; B861 47                       G
        pha                                     ; B862 48                       H
        .byte   $47                             ; B863 47                       G
        pha                                     ; B864 48                       H
        .byte   $47                             ; B865 47                       G
        pha                                     ; B866 48                       H
        .byte   $47                             ; B867 47                       G
        .byte   $4F                             ; B868 4F                       O
        ror     $67                             ; B869 66 67                    fg
        ror     $67                             ; B86B 66 67                    fg
        jmp     L4C4F                           ; B86D 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        .byte   $4F                             ; B870 4F                       O
        lsr     a                               ; B871 4A                       J
        pla                                     ; B872 68                       h
        lsr     a                               ; B873 4A                       J
        pla                                     ; B874 68                       h
        jmp     L4C4F                           ; B875 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        .byte   $4F                             ; B878 4F                       O
        jmp     L4C4F                           ; B879 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        .byte   $4F                             ; B87C 4F                       O
        jmp     L4C4F                           ; B87D 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        pha                                     ; B880 48                       H
        .byte   $47                             ; B881 47                       G
        pha                                     ; B882 48                       H
LB883:  .byte   $47                             ; B883 47                       G
        pha                                     ; B884 48                       H
LB885:  .byte   $47                             ; B885 47                       G
        pha                                     ; B886 48                       H
        .byte   $47                             ; B887 47                       G
        .byte   $67                             ; B888 67                       g
        ror     $67                             ; B889 66 67                    fg
        ror     $67                             ; B88B 66 67                    fg
        ror     $67                             ; B88D 66 67                    fg
        jmp     L4A68                           ; B88F 4C 68 4A                 LhJ

; ----------------------------------------------------------------------------
        pla                                     ; B892 68                       h
        lsr     a                               ; B893 4A                       J
        pla                                     ; B894 68                       h
        lsr     a                               ; B895 4A                       J
        pla                                     ; B896 68                       h
        jmp     L4C4D                           ; B897 4C 4D 4C                 LML

; ----------------------------------------------------------------------------
        eor     $4D4C                           ; B89A 4D 4C 4D                 MLM
        jmp     L4C4D                           ; B89D 4C 4D 4C                 LML

; ----------------------------------------------------------------------------
        pha                                     ; B8A0 48                       H
        .byte   $47                             ; B8A1 47                       G
        pha                                     ; B8A2 48                       H
        .byte   $47                             ; B8A3 47                       G
        pha                                     ; B8A4 48                       H
        .byte   $47                             ; B8A5 47                       G
        pha                                     ; B8A6 48                       H
        .byte   $47                             ; B8A7 47                       G
        .byte   $67                             ; B8A8 67                       g
        jmp     L664F                           ; B8A9 4C 4F 66                 LOf

; ----------------------------------------------------------------------------
        .byte   $67                             ; B8AC 67                       g
        jmp     L4C4F                           ; B8AD 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        pla                                     ; B8B0 68                       h
        jmp     L4A4F                           ; B8B1 4C 4F 4A                 LOJ

; ----------------------------------------------------------------------------
        pla                                     ; B8B4 68                       h
        jmp     L4C4F                           ; B8B5 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        .byte   $4F                             ; B8B8 4F                       O
        jmp     L4C4F                           ; B8B9 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        .byte   $4F                             ; B8BC 4F                       O
        jmp     L4C4F                           ; B8BD 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        pha                                     ; B8C0 48                       H
        .byte   $47                             ; B8C1 47                       G
        pha                                     ; B8C2 48                       H
        .byte   $47                             ; B8C3 47                       G
        pha                                     ; B8C4 48                       H
        .byte   $47                             ; B8C5 47                       G
        pha                                     ; B8C6 48                       H
        .byte   $47                             ; B8C7 47                       G
        .byte   $4F                             ; B8C8 4F                       O
        ror     $67                             ; B8C9 66 67                    fg
        ror     $67                             ; B8CB 66 67                    fg
        jmp     L664F                           ; B8CD 4C 4F 66                 LOf

; ----------------------------------------------------------------------------
        .byte   $4F                             ; B8D0 4F                       O
        lsr     a                               ; B8D1 4A                       J
        pla                                     ; B8D2 68                       h
        lsr     a                               ; B8D3 4A                       J
        pla                                     ; B8D4 68                       h
        jmp     L4A4F                           ; B8D5 4C 4F 4A                 LOJ

; ----------------------------------------------------------------------------
        .byte   $4F                             ; B8D8 4F                       O
        jmp     L4C4F                           ; B8D9 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        .byte   $4F                             ; B8DC 4F                       O
        jmp     L4C4F                           ; B8DD 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        pha                                     ; B8E0 48                       H
        .byte   $47                             ; B8E1 47                       G
        pha                                     ; B8E2 48                       H
        .byte   $47                             ; B8E3 47                       G
        pha                                     ; B8E4 48                       H
        .byte   $47                             ; B8E5 47                       G
        pha                                     ; B8E6 48                       H
        .byte   $47                             ; B8E7 47                       G
        .byte   $4F                             ; B8E8 4F                       O
        jmp     L4C4F                           ; B8E9 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        .byte   $4F                             ; B8EC 4F                       O
        jmp     L4C4F                           ; B8ED 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        adc     #$6A                            ; B8F0 69 6A                    ij
        adc     #$6B                            ; B8F2 69 6B                    ik
        .byte   $6B                             ; B8F4 6B                       k
        adc     #$6A                            ; B8F5 69 6A                    ij
        jmp     (L6E6D)                         ; B8F7 6C 6D 6E                 lmn

; ----------------------------------------------------------------------------
        .byte   $6F                             ; B8FA 6F                       o
        .byte   $6F                             ; B8FB 6F                       o
        adc     L6E6D                           ; B8FC 6D 6D 6E                 mmn
        .byte   $6F                             ; B8FF 6F                       o
        pha                                     ; B900 48                       H
        .byte   $47                             ; B901 47                       G
        pha                                     ; B902 48                       H
        bvs     LB958                           ; B903 70 53                    pS
        adc     ($72),y                         ; B905 71 72                    qr
        .byte   $5C                             ; B907 5C                       \
        .byte   $67                             ; B908 67                       g
        jmp     L554F                           ; B909 4C 4F 55                 LOU

; ----------------------------------------------------------------------------
        .byte   $53                             ; B90C 53                       S
        .byte   $73                             ; B90D 73                       s
        .byte   $74                             ; B90E 74                       t
        .byte   $5C                             ; B90F 5C                       \
        pla                                     ; B910 68                       h
        jmp     L754F                           ; B911 4C 4F 75                 LOu

; ----------------------------------------------------------------------------
        rti                                     ; B914 40                       @

; ----------------------------------------------------------------------------
        ror     $77,x                           ; B915 76 77                    vw
        .byte   $5C                             ; B917 5C                       \
        .byte   $4F                             ; B918 4F                       O
        jmp     L444F                           ; B919 4C 4F 44                 LOD

; ----------------------------------------------------------------------------
        eor     $78                             ; B91C 45 78                    Ex
        eor     $5C,x                           ; B91E 55 5C                    U\
        pha                                     ; B920 48                       H
        .byte   $47                             ; B921 47                       G
        pha                                     ; B922 48                       H
        .byte   $47                             ; B923 47                       G
        pha                                     ; B924 48                       H
        .byte   $47                             ; B925 47                       G
        adc     $4F7A,y                         ; B926 79 7A 4F                 yzO
        jmp     L4C4F                           ; B929 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        .byte   $4F                             ; B92C 4F                       O
        jmp     L7B4F                           ; B92D 4C 4F 7B                 LO{

; ----------------------------------------------------------------------------
        .byte   $6B                             ; B930 6B                       k
        adc     #$6C                            ; B931 69 6C                    il
        ror     a                               ; B933 6A                       j
        .byte   $6B                             ; B934 6B                       k
        jmp     (L6C69)                         ; B935 6C 69 6C                 lil

; ----------------------------------------------------------------------------
        .byte   $6F                             ; B938 6F                       o
        .byte   $6F                             ; B939 6F                       o
        .byte   $6F                             ; B93A 6F                       o
        ror     $6F6F                           ; B93B 6E 6F 6F                 noo
        adc     $7C6F                           ; B93E 6D 6F 7C                 mo|
        adc     $7271,x                         ; B941 7D 71 72                 }qr
        .byte   $5C                             ; B944 5C                       \
        .byte   $7C                             ; B945 7C                       |
        adc     $7F7E,x                         ; B946 7D 7E 7F                 }~.
        adc     $7473,x                         ; B949 7D 73 74                 }st
        .byte   $5C                             ; B94C 5C                       \
        .byte   $7F                             ; B94D 7F                       .
        adc     $807E,x                         ; B94E 7D 7E 80                 }~.
        adc     $8281,x                         ; B951 7D 81 82                 }..
        .byte   $5C                             ; B954 5C                       \
        .byte   $80                             ; B955 80                       .
        .byte   $7D                             ; B956 7D                       }
        .byte   $83                             ; B957 83                       .
LB958:  .byte   $7F                             ; B958 7F                       .
        adc     $7473,x                         ; B959 7D 73 74                 }st
        .byte   $5C                             ; B95C 5C                       \
        .byte   $7F                             ; B95D 7F                       .
        adc     $8483,x                         ; B95E 7D 83 84                 }..
        sta     $86                             ; B961 85 86                    ..
        .byte   $87                             ; B963 87                       .
        dey                                     ; B964 88                       .
        .byte   $89                             ; B965 89                       .
        txa                                     ; B966 8A                       .
        .byte   $8B                             ; B967 8B                       .
        .byte   $4F                             ; B968 4F                       O
        jmp     L4C4F                           ; B969 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        .byte   $4F                             ; B96C 4F                       O
LB96D:  .byte   $4C                             ; B96D 4C                       L
        .byte   $4F                             ; B96E 4F                       O
LB96F:  .byte   $7B                             ; B96F 7B                       {
        ror     a                               ; B970 6A                       j
LB971:  jmp     (L696B)                         ; B971 6C 6B 69                 lki

; ----------------------------------------------------------------------------
        jmp     (L6C6A)                         ; B974 6C 6A 6C                 ljl

; ----------------------------------------------------------------------------
        jmp     (L6D6E)                         ; B977 6C 6E 6D                 lnm

; ----------------------------------------------------------------------------
        .byte   $6F                             ; B97A 6F                       o
        .byte   $6F                             ; B97B 6F                       o
        .byte   $6F                             ; B97C 6F                       o
        ror     $6D6D                           ; B97D 6E 6D 6D                 nmm
        brk                                     ; B980 00                       .
        brk                                     ; B981 00                       .
        brk                                     ; B982 00                       .
        brk                                     ; B983 00                       .
        brk                                     ; B984 00                       .
        brk                                     ; B985 00                       .
        brk                                     ; B986 00                       .
        brk                                     ; B987 00                       .
        brk                                     ; B988 00                       .
        brk                                     ; B989 00                       .
        brk                                     ; B98A 00                       .
        brk                                     ; B98B 00                       .
        brk                                     ; B98C 00                       .
        brk                                     ; B98D 00                       .
        brk                                     ; B98E 00                       .
        brk                                     ; B98F 00                       .
        brk                                     ; B990 00                       .
        brk                                     ; B991 00                       .
        brk                                     ; B992 00                       .
        brk                                     ; B993 00                       .
        brk                                     ; B994 00                       .
        brk                                     ; B995 00                       .
        brk                                     ; B996 00                       .
        brk                                     ; B997 00                       .
        brk                                     ; B998 00                       .
        brk                                     ; B999 00                       .
        brk                                     ; B99A 00                       .
        brk                                     ; B99B 00                       .
        brk                                     ; B99C 00                       .
        brk                                     ; B99D 00                       .
        brk                                     ; B99E 00                       .
        brk                                     ; B99F 00                       .
        brk                                     ; B9A0 00                       .
        brk                                     ; B9A1 00                       .
        brk                                     ; B9A2 00                       .
        brk                                     ; B9A3 00                       .
        brk                                     ; B9A4 00                       .
        brk                                     ; B9A5 00                       .
        brk                                     ; B9A6 00                       .
        brk                                     ; B9A7 00                       .
        brk                                     ; B9A8 00                       .
        brk                                     ; B9A9 00                       .
        brk                                     ; B9AA 00                       .
LB9AB:  brk                                     ; B9AB 00                       .
        brk                                     ; B9AC 00                       .
LB9AD:  brk                                     ; B9AD 00                       .
        brk                                     ; B9AE 00                       .
        brk                                     ; B9AF 00                       .
        jmp     (L6C6C)                         ; B9B0 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        jmp     (L6C6C)                         ; B9B3 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        jmp     (L6D6C)                         ; B9B6 6C 6C 6D                 llm

; ----------------------------------------------------------------------------
        adc     $6D6D                           ; B9B9 6D 6D 6D                 mmm
        adc     $6D6D                           ; B9BC 6D 6D 6D                 mmm
        adc     $4200                           ; B9BF 6D 00 42                 m.B
        rti                                     ; B9C2 40                       @

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; B9C3 41 42                    AB
        rti                                     ; B9C5 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B9C6 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B9C7 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; B9C8 00                       .
        sty     $4445                           ; B9C9 8C 45 44                 .ED
        eor     $44                             ; B9CC 45 44                    ED
        eor     $44                             ; B9CE 45 44                    ED
        brk                                     ; B9D0 00                       .
        sta     $4A8E                           ; B9D1 8D 8E 4A                 ..J
        stx     $8E4A                           ; B9D4 8E 4A 8E                 .J.
        lsr     a                               ; B9D7 4A                       J
        brk                                     ; B9D8 00                       .
        .byte   $8F                             ; B9D9 8F                       .
        bcc     LB96D                           ; B9DA 90 91                    ..
        bcc     LB96F                           ; B9DC 90 91                    ..
        bcc     LB971                           ; B9DE 90 91                    ..
        brk                                     ; B9E0 00                       .
        .byte   $92                             ; B9E1 92                       .
        pha                                     ; B9E2 48                       H
        .byte   $47                             ; B9E3 47                       G
        pha                                     ; B9E4 48                       H
        .byte   $47                             ; B9E5 47                       G
        pha                                     ; B9E6 48                       H
        .byte   $47                             ; B9E7 47                       G
        brk                                     ; B9E8 00                       .
        .byte   $93                             ; B9E9 93                       .
        .byte   $4F                             ; B9EA 4F                       O
        .byte   $4C                             ; B9EB 4C                       L
        .byte   $4F                             ; B9EC 4F                       O
LB9ED:  jmp     L4C4F                           ; B9ED 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        jmp     ($6B6C)                         ; B9F0 6C 6C 6B                 llk

; ----------------------------------------------------------------------------
        .byte   $6B                             ; B9F3 6B                       k
        jmp     (L6B6A)                         ; B9F4 6C 6A 6B                 ljk

; ----------------------------------------------------------------------------
LB9F7:  .byte   $6B                             ; B9F7 6B                       k
        adc     $6D6F                           ; B9F8 6D 6F 6D                 mom
        adc     L6E6D                           ; B9FB 6D 6D 6E                 mmn
        adc     $406F                           ; B9FE 6D 6F 40                 mo@
        rti                                     ; BA01 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; BA02 40                       @

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; BA03 41 42                    AB
        rti                                     ; BA05 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; BA06 40                       @

; ----------------------------------------------------------------------------
        eor     ($45,x)                         ; BA07 41 45                    AE
        .byte   $44                             ; BA09 44                       D
        eor     $44                             ; BA0A 45 44                    ED
        eor     $44                             ; BA0C 45 44                    ED
        eor     $44                             ; BA0E 45 44                    ED
        stx     $8E4A                           ; BA10 8E 4A 8E                 .J.
        lsr     a                               ; BA13 4A                       J
        stx     $4F4C                           ; BA14 8E 4C 4F                 .LO
        lsr     a                               ; BA17 4A                       J
        bcc     LB9AB                           ; BA18 90 91                    ..
        bcc     LB9AD                           ; BA1A 90 91                    ..
        bcc     LBA6A                           ; BA1C 90 4C                    .L
        .byte   $4F                             ; BA1E 4F                       O
        sta     ($48),y                         ; BA1F 91 48                    .H
        .byte   $47                             ; BA21 47                       G
        pha                                     ; BA22 48                       H
        .byte   $47                             ; BA23 47                       G
        pha                                     ; BA24 48                       H
        .byte   $47                             ; BA25 47                       G
        pha                                     ; BA26 48                       H
        .byte   $47                             ; BA27 47                       G
        .byte   $4F                             ; BA28 4F                       O
        jmp     L4C4F                           ; BA29 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        .byte   $4F                             ; BA2C 4F                       O
        jmp     L4C4F                           ; BA2D 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        adc     #$6C                            ; BA30 69 6C                    il
        ror     a                               ; BA32 6A                       j
        jmp     (L6C6C)                         ; BA33 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        jmp     (L6F6A)                         ; BA36 6C 6A 6F                 ljo

; ----------------------------------------------------------------------------
        .byte   $6F                             ; BA39 6F                       o
        ror     $6D6D                           ; BA3A 6E 6D 6D                 nmm
        adc     L6E6D                           ; BA3D 6D 6D 6E                 mmn
        .byte   $42                             ; BA40 42                       B
        rti                                     ; BA41 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; BA42 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; BA43 40                       @

; ----------------------------------------------------------------------------
        eor     ($70,x)                         ; BA44 41 70                    Ap
        .byte   $53                             ; BA46 53                       S
        ror     $4445,x                         ; BA47 7E 45 44                 ~ED
        eor     $44                             ; BA4A 45 44                    ED
        eor     $94                             ; BA4C 45 94                    E.
        sta     $96,x                           ; BA4E 95 96                    ..
        stx     $8E4A                           ; BA50 8E 4A 8E                 .J.
        lsr     a                               ; BA53 4A                       J
        stx     $9897                           ; BA54 8E 97 98                 ...
        jmp     L9190                           ; BA57 4C 90 91                 L..

; ----------------------------------------------------------------------------
        bcc     LB9ED                           ; BA5A 90 91                    ..
        bcc     LB9F7                           ; BA5C 90 99                    ..
        txs                                     ; BA5E 9A                       .
        jmp     L4748                           ; BA5F 4C 48 47                 LHG

; ----------------------------------------------------------------------------
        pha                                     ; BA62 48                       H
        .byte   $47                             ; BA63 47                       G
        pha                                     ; BA64 48                       H
        .byte   $47                             ; BA65 47                       G
        pha                                     ; BA66 48                       H
        .byte   $47                             ; BA67 47                       G
        .byte   $4F                             ; BA68 4F                       O
        .byte   $4C                             ; BA69 4C                       L
LBA6A:  .byte   $4F                             ; BA6A 4F                       O
        jmp     L4C4F                           ; BA6B 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        .byte   $4F                             ; BA6E 4F                       O
        jmp     L6B6B                           ; BA6F 4C 6B 6B                 Lkk

; ----------------------------------------------------------------------------
        adc     #$6C                            ; BA72 69 6C                    il
        .byte   $9B                             ; BA74 9B                       .
        jmp     L4C4F                           ; BA75 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        adc     $6D6D                           ; BA78 6D 6D 6D                 mmm
        .byte   $6F                             ; BA7B 6F                       o
        .byte   $9C                             ; BA7C 9C                       .
        jmp     (L6B6B)                         ; BA7D 6C 6B 6B                 lkk

; ----------------------------------------------------------------------------
        bvs     LBAD5                           ; BA80 70 53                    pS
        .byte   $53                             ; BA82 53                       S
        .byte   $53                             ; BA83 53                       S
        ror     $5370,x                         ; BA84 7E 70 53                 ~pS
        ror     $5370,x                         ; BA87 7E 70 53                 ~pS
        .byte   $53                             ; BA8A 53                       S
        .byte   $53                             ; BA8B 53                       S
        ror     $5370,x                         ; BA8C 7E 70 53                 ~pS
        ror     $5370,x                         ; BA8F 7E 70 53                 ~pS
        .byte   $53                             ; BA92 53                       S
        .byte   $53                             ; BA93 53                       S
        ror     $5370,x                         ; BA94 7E 70 53                 ~pS
        ror     $5370,x                         ; BA97 7E 70 53                 ~pS
        .byte   $53                             ; BA9A 53                       S
        .byte   $53                             ; BA9B 53                       S
        ror     $5370,x                         ; BA9C 7E 70 53                 ~pS
        ror     $5370,x                         ; BA9F 7E 70 53                 ~pS
        .byte   $53                             ; BAA2 53                       S
        .byte   $53                             ; BAA3 53                       S
        ror     $5370,x                         ; BAA4 7E 70 53                 ~pS
        ror     $5370,x                         ; BAA7 7E 70 53                 ~pS
        .byte   $53                             ; BAAA 53                       S
        .byte   $53                             ; BAAB 53                       S
        ror     $5370,x                         ; BAAC 7E 70 53                 ~pS
        ror     $5370,x                         ; BAAF 7E 70 53                 ~pS
        .byte   $53                             ; BAB2 53                       S
        .byte   $53                             ; BAB3 53                       S
        ror     $5370,x                         ; BAB4 7E 70 53                 ~pS
        ror     $5370,x                         ; BAB7 7E 70 53                 ~pS
        .byte   $53                             ; BABA 53                       S
        .byte   $53                             ; BABB 53                       S
        ror     $5370,x                         ; BABC 7E 70 53                 ~pS
        ror     $9D9D,x                         ; BABF 7E 9D 9D                 ~..
        sta     $9F9E,x                         ; BAC2 9D 9E 9F                 ...
        sta     $9D9D,x                         ; BAC5 9D 9D 9D                 ...
        sta     $9D9D,x                         ; BAC8 9D 9D 9D                 ...
        .byte   $9E                             ; BACB 9E                       .
        .byte   $9F                             ; BACC 9F                       .
        sta     $9D9D,x                         ; BACD 9D 9D 9D                 ...
LBAD0:  brk                                     ; BAD0 00                       .
        brk                                     ; BAD1 00                       .
        brk                                     ; BAD2 00                       .
        brk                                     ; BAD3 00                       .
        brk                                     ; BAD4 00                       .
LBAD5:  brk                                     ; BAD5 00                       .
        brk                                     ; BAD6 00                       .
        brk                                     ; BAD7 00                       .
        brk                                     ; BAD8 00                       .
        brk                                     ; BAD9 00                       .
        brk                                     ; BADA 00                       .
        brk                                     ; BADB 00                       .
        brk                                     ; BADC 00                       .
        brk                                     ; BADD 00                       .
        brk                                     ; BADE 00                       .
        brk                                     ; BADF 00                       .
        brk                                     ; BAE0 00                       .
        brk                                     ; BAE1 00                       .
        brk                                     ; BAE2 00                       .
        brk                                     ; BAE3 00                       .
        brk                                     ; BAE4 00                       .
        brk                                     ; BAE5 00                       .
        brk                                     ; BAE6 00                       .
        brk                                     ; BAE7 00                       .
        brk                                     ; BAE8 00                       .
        brk                                     ; BAE9 00                       .
        brk                                     ; BAEA 00                       .
        brk                                     ; BAEB 00                       .
        brk                                     ; BAEC 00                       .
        brk                                     ; BAED 00                       .
        brk                                     ; BAEE 00                       .
        brk                                     ; BAEF 00                       .
        brk                                     ; BAF0 00                       .
        brk                                     ; BAF1 00                       .
        ldy     #$A1                            ; BAF2 A0 A1                    ..
        ldx     #$A3                            ; BAF4 A2 A3                    ..
        brk                                     ; BAF6 00                       .
        brk                                     ; BAF7 00                       .
        brk                                     ; BAF8 00                       .
        brk                                     ; BAF9 00                       .
        ldy     $A5                             ; BAFA A4 A5                    ..
        ldx     $A7                             ; BAFC A6 A7                    ..
        brk                                     ; BAFE 00                       .
        brk                                     ; BAFF 00                       .
        brk                                     ; BB00 00                       .
        brk                                     ; BB01 00                       .
        brk                                     ; BB02 00                       .
        brk                                     ; BB03 00                       .
        brk                                     ; BB04 00                       .
        brk                                     ; BB05 00                       .
        brk                                     ; BB06 00                       .
        brk                                     ; BB07 00                       .
        brk                                     ; BB08 00                       .
        brk                                     ; BB09 00                       .
        brk                                     ; BB0A 00                       .
        brk                                     ; BB0B 00                       .
        tay                                     ; BB0C A8                       .
        lda     #$AA                            ; BB0D A9 AA                    ..
        brk                                     ; BB0F 00                       .
        brk                                     ; BB10 00                       .
        brk                                     ; BB11 00                       .
        brk                                     ; BB12 00                       .
        brk                                     ; BB13 00                       .
        .byte   $AB                             ; BB14 AB                       .
        ldy     LAEAD                           ; BB15 AC AD AE                 ...
        brk                                     ; BB18 00                       .
        brk                                     ; BB19 00                       .
        brk                                     ; BB1A 00                       .
        brk                                     ; BB1B 00                       .
        .byte   $AF                             ; BB1C AF                       .
        bcs     LBAD0                           ; BB1D B0 B1                    ..
        .byte   $B2                             ; BB1F B2                       .
        brk                                     ; BB20 00                       .
        brk                                     ; BB21 00                       .
        brk                                     ; BB22 00                       .
        brk                                     ; BB23 00                       .
        .byte   $B3                             ; BB24 B3                       .
        ldy     $B5,x                           ; BB25 B4 B5                    ..
        ldx     L0000,y                         ; BB27 B6 00                    ..
        brk                                     ; BB29 00                       .
        brk                                     ; BB2A 00                       .
        brk                                     ; BB2B 00                       .
        .byte   $B7                             ; BB2C B7                       .
        clv                                     ; BB2D B8                       .
        lda     $BA,y                           ; BB2E B9 BA 00                 ...
        brk                                     ; BB31 00                       .
        brk                                     ; BB32 00                       .
        brk                                     ; BB33 00                       .
        brk                                     ; BB34 00                       .
        brk                                     ; BB35 00                       .
        brk                                     ; BB36 00                       .
        brk                                     ; BB37 00                       .
        brk                                     ; BB38 00                       .
        brk                                     ; BB39 00                       .
        brk                                     ; BB3A 00                       .
        brk                                     ; BB3B 00                       .
        brk                                     ; BB3C 00                       .
        brk                                     ; BB3D 00                       .
        brk                                     ; BB3E 00                       .
        brk                                     ; BB3F 00                       .
        brk                                     ; BB40 00                       .
        brk                                     ; BB41 00                       .
        brk                                     ; BB42 00                       .
        brk                                     ; BB43 00                       .
        brk                                     ; BB44 00                       .
        brk                                     ; BB45 00                       .
        brk                                     ; BB46 00                       .
        brk                                     ; BB47 00                       .
        brk                                     ; BB48 00                       .
        brk                                     ; BB49 00                       .
        brk                                     ; BB4A 00                       .
        brk                                     ; BB4B 00                       .
        brk                                     ; BB4C 00                       .
        brk                                     ; BB4D 00                       .
        brk                                     ; BB4E 00                       .
        brk                                     ; BB4F 00                       .
        brk                                     ; BB50 00                       .
        brk                                     ; BB51 00                       .
        brk                                     ; BB52 00                       .
        brk                                     ; BB53 00                       .
        brk                                     ; BB54 00                       .
        brk                                     ; BB55 00                       .
        brk                                     ; BB56 00                       .
        brk                                     ; BB57 00                       .
        brk                                     ; BB58 00                       .
        brk                                     ; BB59 00                       .
        brk                                     ; BB5A 00                       .
        brk                                     ; BB5B 00                       .
        brk                                     ; BB5C 00                       .
        brk                                     ; BB5D 00                       .
        brk                                     ; BB5E 00                       .
        brk                                     ; BB5F 00                       .
        brk                                     ; BB60 00                       .
        brk                                     ; BB61 00                       .
        brk                                     ; BB62 00                       .
        .byte   $BB                             ; BB63 BB                       .
        ldy     a:L0000,x                       ; BB64 BC 00 00                 ...
        brk                                     ; BB67 00                       .
        brk                                     ; BB68 00                       .
        brk                                     ; BB69 00                       .
        brk                                     ; BB6A 00                       .
        lda     a:$BE,x                         ; BB6B BD BE 00                 ...
        brk                                     ; BB6E 00                       .
        brk                                     ; BB6F 00                       .
        brk                                     ; BB70 00                       .
        brk                                     ; BB71 00                       .
        brk                                     ; BB72 00                       .
        brk                                     ; BB73 00                       .
        brk                                     ; BB74 00                       .
        brk                                     ; BB75 00                       .
        brk                                     ; BB76 00                       .
        brk                                     ; BB77 00                       .
        brk                                     ; BB78 00                       .
        brk                                     ; BB79 00                       .
        brk                                     ; BB7A 00                       .
        brk                                     ; BB7B 00                       .
        brk                                     ; BB7C 00                       .
        brk                                     ; BB7D 00                       .
        brk                                     ; BB7E 00                       .
        brk                                     ; BB7F 00                       .
        brk                                     ; BB80 00                       .
        brk                                     ; BB81 00                       .
        brk                                     ; BB82 00                       .
        brk                                     ; BB83 00                       .
        brk                                     ; BB84 00                       .
        brk                                     ; BB85 00                       .
        brk                                     ; BB86 00                       .
        brk                                     ; BB87 00                       .
        brk                                     ; BB88 00                       .
        brk                                     ; BB89 00                       .
        brk                                     ; BB8A 00                       .
        brk                                     ; BB8B 00                       .
        brk                                     ; BB8C 00                       .
        brk                                     ; BB8D 00                       .
        brk                                     ; BB8E 00                       .
        brk                                     ; BB8F 00                       .
        brk                                     ; BB90 00                       .
        brk                                     ; BB91 00                       .
        brk                                     ; BB92 00                       .
        brk                                     ; BB93 00                       .
        brk                                     ; BB94 00                       .
        brk                                     ; BB95 00                       .
        brk                                     ; BB96 00                       .
        brk                                     ; BB97 00                       .
        brk                                     ; BB98 00                       .
        brk                                     ; BB99 00                       .
        brk                                     ; BB9A 00                       .
        brk                                     ; BB9B 00                       .
        brk                                     ; BB9C 00                       .
        brk                                     ; BB9D 00                       .
        brk                                     ; BB9E 00                       .
        brk                                     ; BB9F 00                       .
        brk                                     ; BBA0 00                       .
        brk                                     ; BBA1 00                       .
        brk                                     ; BBA2 00                       .
        brk                                     ; BBA3 00                       .
        brk                                     ; BBA4 00                       .
        brk                                     ; BBA5 00                       .
        brk                                     ; BBA6 00                       .
        brk                                     ; BBA7 00                       .
        brk                                     ; BBA8 00                       .
        brk                                     ; BBA9 00                       .
        brk                                     ; BBAA 00                       .
        brk                                     ; BBAB 00                       .
        brk                                     ; BBAC 00                       .
        brk                                     ; BBAD 00                       .
        brk                                     ; BBAE 00                       .
        brk                                     ; BBAF 00                       .
        brk                                     ; BBB0 00                       .
        brk                                     ; BBB1 00                       .
        brk                                     ; BBB2 00                       .
        brk                                     ; BBB3 00                       .
        brk                                     ; BBB4 00                       .
        brk                                     ; BBB5 00                       .
        brk                                     ; BBB6 00                       .
        brk                                     ; BBB7 00                       .
        brk                                     ; BBB8 00                       .
        brk                                     ; BBB9 00                       .
        brk                                     ; BBBA 00                       .
        brk                                     ; BBBB 00                       .
        brk                                     ; BBBC 00                       .
        brk                                     ; BBBD 00                       .
        brk                                     ; BBBE 00                       .
        brk                                     ; BBBF 00                       .
        brk                                     ; BBC0 00                       .
        brk                                     ; BBC1 00                       .
        brk                                     ; BBC2 00                       .
        brk                                     ; BBC3 00                       .
        brk                                     ; BBC4 00                       .
        brk                                     ; BBC5 00                       .
        brk                                     ; BBC6 00                       .
        brk                                     ; BBC7 00                       .
        brk                                     ; BBC8 00                       .
        brk                                     ; BBC9 00                       .
        brk                                     ; BBCA 00                       .
        brk                                     ; BBCB 00                       .
        brk                                     ; BBCC 00                       .
        brk                                     ; BBCD 00                       .
        brk                                     ; BBCE 00                       .
        brk                                     ; BBCF 00                       .
        brk                                     ; BBD0 00                       .
        brk                                     ; BBD1 00                       .
        brk                                     ; BBD2 00                       .
        brk                                     ; BBD3 00                       .
        brk                                     ; BBD4 00                       .
        brk                                     ; BBD5 00                       .
        brk                                     ; BBD6 00                       .
        brk                                     ; BBD7 00                       .
        brk                                     ; BBD8 00                       .
        brk                                     ; BBD9 00                       .
        brk                                     ; BBDA 00                       .
        brk                                     ; BBDB 00                       .
        brk                                     ; BBDC 00                       .
        brk                                     ; BBDD 00                       .
        brk                                     ; BBDE 00                       .
        brk                                     ; BBDF 00                       .
        brk                                     ; BBE0 00                       .
        brk                                     ; BBE1 00                       .
        brk                                     ; BBE2 00                       .
        brk                                     ; BBE3 00                       .
        brk                                     ; BBE4 00                       .
        brk                                     ; BBE5 00                       .
        brk                                     ; BBE6 00                       .
        brk                                     ; BBE7 00                       .
        brk                                     ; BBE8 00                       .
        brk                                     ; BBE9 00                       .
        brk                                     ; BBEA 00                       .
        brk                                     ; BBEB 00                       .
        brk                                     ; BBEC 00                       .
        brk                                     ; BBED 00                       .
        brk                                     ; BBEE 00                       .
        brk                                     ; BBEF 00                       .
        brk                                     ; BBF0 00                       .
        brk                                     ; BBF1 00                       .
        brk                                     ; BBF2 00                       .
        brk                                     ; BBF3 00                       .
        brk                                     ; BBF4 00                       .
        brk                                     ; BBF5 00                       .
        brk                                     ; BBF6 00                       .
        brk                                     ; BBF7 00                       .
        brk                                     ; BBF8 00                       .
        brk                                     ; BBF9 00                       .
        brk                                     ; BBFA 00                       .
        brk                                     ; BBFB 00                       .
        brk                                     ; BBFC 00                       .
        brk                                     ; BBFD 00                       .
        brk                                     ; BBFE 00                       .
        brk                                     ; BBFF 00                       .
        brk                                     ; BC00 00                       .
        brk                                     ; BC01 00                       .
        brk                                     ; BC02 00                       .
        brk                                     ; BC03 00                       .
        brk                                     ; BC04 00                       .
        brk                                     ; BC05 00                       .
        brk                                     ; BC06 00                       .
        brk                                     ; BC07 00                       .
        brk                                     ; BC08 00                       .
        brk                                     ; BC09 00                       .
        brk                                     ; BC0A 00                       .
        brk                                     ; BC0B 00                       .
        brk                                     ; BC0C 00                       .
        brk                                     ; BC0D 00                       .
        brk                                     ; BC0E 00                       .
        brk                                     ; BC0F 00                       .
        brk                                     ; BC10 00                       .
        brk                                     ; BC11 00                       .
        brk                                     ; BC12 00                       .
        brk                                     ; BC13 00                       .
        brk                                     ; BC14 00                       .
        brk                                     ; BC15 00                       .
        brk                                     ; BC16 00                       .
        brk                                     ; BC17 00                       .
        brk                                     ; BC18 00                       .
        brk                                     ; BC19 00                       .
        brk                                     ; BC1A 00                       .
        brk                                     ; BC1B 00                       .
        brk                                     ; BC1C 00                       .
        brk                                     ; BC1D 00                       .
        brk                                     ; BC1E 00                       .
        brk                                     ; BC1F 00                       .
        brk                                     ; BC20 00                       .
        brk                                     ; BC21 00                       .
        brk                                     ; BC22 00                       .
        brk                                     ; BC23 00                       .
        brk                                     ; BC24 00                       .
        brk                                     ; BC25 00                       .
        brk                                     ; BC26 00                       .
        brk                                     ; BC27 00                       .
        brk                                     ; BC28 00                       .
        brk                                     ; BC29 00                       .
        brk                                     ; BC2A 00                       .
        brk                                     ; BC2B 00                       .
        brk                                     ; BC2C 00                       .
        brk                                     ; BC2D 00                       .
        brk                                     ; BC2E 00                       .
        brk                                     ; BC2F 00                       .
        brk                                     ; BC30 00                       .
        brk                                     ; BC31 00                       .
        brk                                     ; BC32 00                       .
        brk                                     ; BC33 00                       .
        brk                                     ; BC34 00                       .
        brk                                     ; BC35 00                       .
        brk                                     ; BC36 00                       .
        brk                                     ; BC37 00                       .
        brk                                     ; BC38 00                       .
        brk                                     ; BC39 00                       .
        brk                                     ; BC3A 00                       .
        brk                                     ; BC3B 00                       .
        brk                                     ; BC3C 00                       .
        brk                                     ; BC3D 00                       .
        brk                                     ; BC3E 00                       .
        brk                                     ; BC3F 00                       .
        brk                                     ; BC40 00                       .
        brk                                     ; BC41 00                       .
        brk                                     ; BC42 00                       .
        brk                                     ; BC43 00                       .
        brk                                     ; BC44 00                       .
        brk                                     ; BC45 00                       .
        brk                                     ; BC46 00                       .
        brk                                     ; BC47 00                       .
        brk                                     ; BC48 00                       .
        brk                                     ; BC49 00                       .
        brk                                     ; BC4A 00                       .
        brk                                     ; BC4B 00                       .
        brk                                     ; BC4C 00                       .
        brk                                     ; BC4D 00                       .
        brk                                     ; BC4E 00                       .
        brk                                     ; BC4F 00                       .
        brk                                     ; BC50 00                       .
        brk                                     ; BC51 00                       .
        brk                                     ; BC52 00                       .
        brk                                     ; BC53 00                       .
        brk                                     ; BC54 00                       .
        brk                                     ; BC55 00                       .
        brk                                     ; BC56 00                       .
        brk                                     ; BC57 00                       .
        brk                                     ; BC58 00                       .
        brk                                     ; BC59 00                       .
        brk                                     ; BC5A 00                       .
        brk                                     ; BC5B 00                       .
        brk                                     ; BC5C 00                       .
        brk                                     ; BC5D 00                       .
        brk                                     ; BC5E 00                       .
        brk                                     ; BC5F 00                       .
        brk                                     ; BC60 00                       .
        brk                                     ; BC61 00                       .
        brk                                     ; BC62 00                       .
        brk                                     ; BC63 00                       .
        brk                                     ; BC64 00                       .
        brk                                     ; BC65 00                       .
        brk                                     ; BC66 00                       .
        brk                                     ; BC67 00                       .
        brk                                     ; BC68 00                       .
        brk                                     ; BC69 00                       .
        brk                                     ; BC6A 00                       .
        brk                                     ; BC6B 00                       .
        brk                                     ; BC6C 00                       .
        brk                                     ; BC6D 00                       .
        brk                                     ; BC6E 00                       .
        brk                                     ; BC6F 00                       .
        brk                                     ; BC70 00                       .
        brk                                     ; BC71 00                       .
        brk                                     ; BC72 00                       .
        brk                                     ; BC73 00                       .
        brk                                     ; BC74 00                       .
        brk                                     ; BC75 00                       .
        brk                                     ; BC76 00                       .
        brk                                     ; BC77 00                       .
        brk                                     ; BC78 00                       .
        brk                                     ; BC79 00                       .
        brk                                     ; BC7A 00                       .
        brk                                     ; BC7B 00                       .
        brk                                     ; BC7C 00                       .
        brk                                     ; BC7D 00                       .
        brk                                     ; BC7E 00                       .
        brk                                     ; BC7F 00                       .
        brk                                     ; BC80 00                       .
        brk                                     ; BC81 00                       .
        brk                                     ; BC82 00                       .
        brk                                     ; BC83 00                       .
        brk                                     ; BC84 00                       .
        brk                                     ; BC85 00                       .
        brk                                     ; BC86 00                       .
        brk                                     ; BC87 00                       .
        brk                                     ; BC88 00                       .
        brk                                     ; BC89 00                       .
        brk                                     ; BC8A 00                       .
        brk                                     ; BC8B 00                       .
        brk                                     ; BC8C 00                       .
        brk                                     ; BC8D 00                       .
        brk                                     ; BC8E 00                       .
        brk                                     ; BC8F 00                       .
        brk                                     ; BC90 00                       .
        brk                                     ; BC91 00                       .
        brk                                     ; BC92 00                       .
        brk                                     ; BC93 00                       .
        brk                                     ; BC94 00                       .
        brk                                     ; BC95 00                       .
        brk                                     ; BC96 00                       .
        brk                                     ; BC97 00                       .
        brk                                     ; BC98 00                       .
        brk                                     ; BC99 00                       .
        brk                                     ; BC9A 00                       .
        brk                                     ; BC9B 00                       .
        brk                                     ; BC9C 00                       .
        brk                                     ; BC9D 00                       .
        brk                                     ; BC9E 00                       .
        brk                                     ; BC9F 00                       .
        brk                                     ; BCA0 00                       .
        brk                                     ; BCA1 00                       .
        brk                                     ; BCA2 00                       .
        brk                                     ; BCA3 00                       .
        brk                                     ; BCA4 00                       .
        brk                                     ; BCA5 00                       .
        brk                                     ; BCA6 00                       .
        brk                                     ; BCA7 00                       .
        brk                                     ; BCA8 00                       .
        brk                                     ; BCA9 00                       .
        brk                                     ; BCAA 00                       .
        brk                                     ; BCAB 00                       .
        brk                                     ; BCAC 00                       .
        brk                                     ; BCAD 00                       .
        brk                                     ; BCAE 00                       .
        brk                                     ; BCAF 00                       .
        brk                                     ; BCB0 00                       .
        brk                                     ; BCB1 00                       .
        brk                                     ; BCB2 00                       .
        brk                                     ; BCB3 00                       .
        brk                                     ; BCB4 00                       .
        brk                                     ; BCB5 00                       .
        brk                                     ; BCB6 00                       .
        brk                                     ; BCB7 00                       .
        brk                                     ; BCB8 00                       .
        brk                                     ; BCB9 00                       .
        brk                                     ; BCBA 00                       .
        brk                                     ; BCBB 00                       .
        brk                                     ; BCBC 00                       .
        brk                                     ; BCBD 00                       .
        brk                                     ; BCBE 00                       .
        brk                                     ; BCBF 00                       .
        brk                                     ; BCC0 00                       .
        brk                                     ; BCC1 00                       .
        brk                                     ; BCC2 00                       .
        brk                                     ; BCC3 00                       .
        brk                                     ; BCC4 00                       .
        brk                                     ; BCC5 00                       .
        brk                                     ; BCC6 00                       .
        brk                                     ; BCC7 00                       .
        brk                                     ; BCC8 00                       .
        brk                                     ; BCC9 00                       .
        brk                                     ; BCCA 00                       .
        brk                                     ; BCCB 00                       .
        brk                                     ; BCCC 00                       .
        brk                                     ; BCCD 00                       .
        brk                                     ; BCCE 00                       .
        brk                                     ; BCCF 00                       .
        brk                                     ; BCD0 00                       .
        brk                                     ; BCD1 00                       .
        brk                                     ; BCD2 00                       .
        brk                                     ; BCD3 00                       .
        brk                                     ; BCD4 00                       .
        brk                                     ; BCD5 00                       .
        brk                                     ; BCD6 00                       .
        brk                                     ; BCD7 00                       .
        brk                                     ; BCD8 00                       .
        brk                                     ; BCD9 00                       .
        brk                                     ; BCDA 00                       .
        brk                                     ; BCDB 00                       .
        brk                                     ; BCDC 00                       .
        brk                                     ; BCDD 00                       .
        brk                                     ; BCDE 00                       .
        brk                                     ; BCDF 00                       .
        brk                                     ; BCE0 00                       .
        brk                                     ; BCE1 00                       .
        brk                                     ; BCE2 00                       .
        brk                                     ; BCE3 00                       .
        brk                                     ; BCE4 00                       .
        brk                                     ; BCE5 00                       .
        brk                                     ; BCE6 00                       .
        brk                                     ; BCE7 00                       .
        brk                                     ; BCE8 00                       .
        brk                                     ; BCE9 00                       .
        brk                                     ; BCEA 00                       .
        brk                                     ; BCEB 00                       .
        brk                                     ; BCEC 00                       .
        brk                                     ; BCED 00                       .
        brk                                     ; BCEE 00                       .
        brk                                     ; BCEF 00                       .
        brk                                     ; BCF0 00                       .
        brk                                     ; BCF1 00                       .
        brk                                     ; BCF2 00                       .
        brk                                     ; BCF3 00                       .
        brk                                     ; BCF4 00                       .
        brk                                     ; BCF5 00                       .
        brk                                     ; BCF6 00                       .
        brk                                     ; BCF7 00                       .
        brk                                     ; BCF8 00                       .
        brk                                     ; BCF9 00                       .
        brk                                     ; BCFA 00                       .
        brk                                     ; BCFB 00                       .
        brk                                     ; BCFC 00                       .
        brk                                     ; BCFD 00                       .
        brk                                     ; BCFE 00                       .
        brk                                     ; BCFF 00                       .
        brk                                     ; BD00 00                       .
        brk                                     ; BD01 00                       .
        brk                                     ; BD02 00                       .
        brk                                     ; BD03 00                       .
        brk                                     ; BD04 00                       .
        brk                                     ; BD05 00                       .
        brk                                     ; BD06 00                       .
        brk                                     ; BD07 00                       .
        brk                                     ; BD08 00                       .
        brk                                     ; BD09 00                       .
        brk                                     ; BD0A 00                       .
        brk                                     ; BD0B 00                       .
        brk                                     ; BD0C 00                       .
        brk                                     ; BD0D 00                       .
        brk                                     ; BD0E 00                       .
        brk                                     ; BD0F 00                       .
        brk                                     ; BD10 00                       .
        brk                                     ; BD11 00                       .
        brk                                     ; BD12 00                       .
        brk                                     ; BD13 00                       .
        brk                                     ; BD14 00                       .
        brk                                     ; BD15 00                       .
        brk                                     ; BD16 00                       .
        brk                                     ; BD17 00                       .
        brk                                     ; BD18 00                       .
        brk                                     ; BD19 00                       .
        brk                                     ; BD1A 00                       .
        brk                                     ; BD1B 00                       .
        brk                                     ; BD1C 00                       .
        brk                                     ; BD1D 00                       .
        brk                                     ; BD1E 00                       .
        brk                                     ; BD1F 00                       .
        brk                                     ; BD20 00                       .
        brk                                     ; BD21 00                       .
        brk                                     ; BD22 00                       .
        brk                                     ; BD23 00                       .
        brk                                     ; BD24 00                       .
        brk                                     ; BD25 00                       .
        brk                                     ; BD26 00                       .
        brk                                     ; BD27 00                       .
        brk                                     ; BD28 00                       .
        brk                                     ; BD29 00                       .
        brk                                     ; BD2A 00                       .
        brk                                     ; BD2B 00                       .
        brk                                     ; BD2C 00                       .
        brk                                     ; BD2D 00                       .
        brk                                     ; BD2E 00                       .
        brk                                     ; BD2F 00                       .
        brk                                     ; BD30 00                       .
        brk                                     ; BD31 00                       .
        brk                                     ; BD32 00                       .
        brk                                     ; BD33 00                       .
        brk                                     ; BD34 00                       .
        brk                                     ; BD35 00                       .
        brk                                     ; BD36 00                       .
        brk                                     ; BD37 00                       .
        brk                                     ; BD38 00                       .
        brk                                     ; BD39 00                       .
        brk                                     ; BD3A 00                       .
        brk                                     ; BD3B 00                       .
        brk                                     ; BD3C 00                       .
        brk                                     ; BD3D 00                       .
        brk                                     ; BD3E 00                       .
        brk                                     ; BD3F 00                       .
        brk                                     ; BD40 00                       .
        brk                                     ; BD41 00                       .
        brk                                     ; BD42 00                       .
        brk                                     ; BD43 00                       .
        brk                                     ; BD44 00                       .
        brk                                     ; BD45 00                       .
        brk                                     ; BD46 00                       .
        brk                                     ; BD47 00                       .
        brk                                     ; BD48 00                       .
        brk                                     ; BD49 00                       .
        brk                                     ; BD4A 00                       .
        brk                                     ; BD4B 00                       .
        brk                                     ; BD4C 00                       .
        brk                                     ; BD4D 00                       .
        brk                                     ; BD4E 00                       .
        brk                                     ; BD4F 00                       .
        brk                                     ; BD50 00                       .
        brk                                     ; BD51 00                       .
        brk                                     ; BD52 00                       .
        brk                                     ; BD53 00                       .
        brk                                     ; BD54 00                       .
        brk                                     ; BD55 00                       .
        brk                                     ; BD56 00                       .
        brk                                     ; BD57 00                       .
        brk                                     ; BD58 00                       .
        brk                                     ; BD59 00                       .
        brk                                     ; BD5A 00                       .
        brk                                     ; BD5B 00                       .
        brk                                     ; BD5C 00                       .
        brk                                     ; BD5D 00                       .
        brk                                     ; BD5E 00                       .
LBD5F:  brk                                     ; BD5F 00                       .
        brk                                     ; BD60 00                       .
        brk                                     ; BD61 00                       .
        brk                                     ; BD62 00                       .
        brk                                     ; BD63 00                       .
        brk                                     ; BD64 00                       .
        brk                                     ; BD65 00                       .
        brk                                     ; BD66 00                       .
        brk                                     ; BD67 00                       .
        brk                                     ; BD68 00                       .
        brk                                     ; BD69 00                       .
        brk                                     ; BD6A 00                       .
        brk                                     ; BD6B 00                       .
        brk                                     ; BD6C 00                       .
        brk                                     ; BD6D 00                       .
        brk                                     ; BD6E 00                       .
        brk                                     ; BD6F 00                       .
        brk                                     ; BD70 00                       .
        brk                                     ; BD71 00                       .
        brk                                     ; BD72 00                       .
        brk                                     ; BD73 00                       .
        brk                                     ; BD74 00                       .
        brk                                     ; BD75 00                       .
        brk                                     ; BD76 00                       .
        brk                                     ; BD77 00                       .
        brk                                     ; BD78 00                       .
        brk                                     ; BD79 00                       .
        brk                                     ; BD7A 00                       .
        brk                                     ; BD7B 00                       .
        brk                                     ; BD7C 00                       .
        brk                                     ; BD7D 00                       .
        brk                                     ; BD7E 00                       .
        brk                                     ; BD7F 00                       .
        brk                                     ; BD80 00                       .
        brk                                     ; BD81 00                       .
        brk                                     ; BD82 00                       .
        brk                                     ; BD83 00                       .
        brk                                     ; BD84 00                       .
        brk                                     ; BD85 00                       .
        brk                                     ; BD86 00                       .
        brk                                     ; BD87 00                       .
        brk                                     ; BD88 00                       .
        brk                                     ; BD89 00                       .
        brk                                     ; BD8A 00                       .
        brk                                     ; BD8B 00                       .
        brk                                     ; BD8C 00                       .
        brk                                     ; BD8D 00                       .
        brk                                     ; BD8E 00                       .
        brk                                     ; BD8F 00                       .
        brk                                     ; BD90 00                       .
        brk                                     ; BD91 00                       .
        brk                                     ; BD92 00                       .
        brk                                     ; BD93 00                       .
        brk                                     ; BD94 00                       .
        brk                                     ; BD95 00                       .
        brk                                     ; BD96 00                       .
        brk                                     ; BD97 00                       .
        brk                                     ; BD98 00                       .
        brk                                     ; BD99 00                       .
        brk                                     ; BD9A 00                       .
        brk                                     ; BD9B 00                       .
        brk                                     ; BD9C 00                       .
        brk                                     ; BD9D 00                       .
        brk                                     ; BD9E 00                       .
        brk                                     ; BD9F 00                       .
        brk                                     ; BDA0 00                       .
        brk                                     ; BDA1 00                       .
        brk                                     ; BDA2 00                       .
        brk                                     ; BDA3 00                       .
        brk                                     ; BDA4 00                       .
        brk                                     ; BDA5 00                       .
        brk                                     ; BDA6 00                       .
        brk                                     ; BDA7 00                       .
        brk                                     ; BDA8 00                       .
        brk                                     ; BDA9 00                       .
        brk                                     ; BDAA 00                       .
        brk                                     ; BDAB 00                       .
        brk                                     ; BDAC 00                       .
        brk                                     ; BDAD 00                       .
        brk                                     ; BDAE 00                       .
        brk                                     ; BDAF 00                       .
        brk                                     ; BDB0 00                       .
        brk                                     ; BDB1 00                       .
        brk                                     ; BDB2 00                       .
        brk                                     ; BDB3 00                       .
        brk                                     ; BDB4 00                       .
        brk                                     ; BDB5 00                       .
        brk                                     ; BDB6 00                       .
        brk                                     ; BDB7 00                       .
        brk                                     ; BDB8 00                       .
        brk                                     ; BDB9 00                       .
        brk                                     ; BDBA 00                       .
LBDBB:  brk                                     ; BDBB 00                       .
        brk                                     ; BDBC 00                       .
        brk                                     ; BDBD 00                       .
        brk                                     ; BDBE 00                       .
        brk                                     ; BDBF 00                       .
        brk                                     ; BDC0 00                       .
        brk                                     ; BDC1 00                       .
        brk                                     ; BDC2 00                       .
        brk                                     ; BDC3 00                       .
        brk                                     ; BDC4 00                       .
        brk                                     ; BDC5 00                       .
        brk                                     ; BDC6 00                       .
        brk                                     ; BDC7 00                       .
        brk                                     ; BDC8 00                       .
        brk                                     ; BDC9 00                       .
        brk                                     ; BDCA 00                       .
        brk                                     ; BDCB 00                       .
        brk                                     ; BDCC 00                       .
        brk                                     ; BDCD 00                       .
        brk                                     ; BDCE 00                       .
        brk                                     ; BDCF 00                       .
        brk                                     ; BDD0 00                       .
        brk                                     ; BDD1 00                       .
        brk                                     ; BDD2 00                       .
        brk                                     ; BDD3 00                       .
        brk                                     ; BDD4 00                       .
        brk                                     ; BDD5 00                       .
        brk                                     ; BDD6 00                       .
        brk                                     ; BDD7 00                       .
        brk                                     ; BDD8 00                       .
        brk                                     ; BDD9 00                       .
        brk                                     ; BDDA 00                       .
        brk                                     ; BDDB 00                       .
        brk                                     ; BDDC 00                       .
        brk                                     ; BDDD 00                       .
        brk                                     ; BDDE 00                       .
        brk                                     ; BDDF 00                       .
        brk                                     ; BDE0 00                       .
        brk                                     ; BDE1 00                       .
        brk                                     ; BDE2 00                       .
        brk                                     ; BDE3 00                       .
        brk                                     ; BDE4 00                       .
        brk                                     ; BDE5 00                       .
        brk                                     ; BDE6 00                       .
        brk                                     ; BDE7 00                       .
        brk                                     ; BDE8 00                       .
        brk                                     ; BDE9 00                       .
        brk                                     ; BDEA 00                       .
        brk                                     ; BDEB 00                       .
        brk                                     ; BDEC 00                       .
        brk                                     ; BDED 00                       .
        brk                                     ; BDEE 00                       .
        brk                                     ; BDEF 00                       .
        brk                                     ; BDF0 00                       .
        brk                                     ; BDF1 00                       .
        brk                                     ; BDF2 00                       .
        brk                                     ; BDF3 00                       .
        brk                                     ; BDF4 00                       .
        brk                                     ; BDF5 00                       .
        brk                                     ; BDF6 00                       .
        brk                                     ; BDF7 00                       .
        brk                                     ; BDF8 00                       .
        brk                                     ; BDF9 00                       .
        brk                                     ; BDFA 00                       .
        brk                                     ; BDFB 00                       .
        brk                                     ; BDFC 00                       .
        brk                                     ; BDFD 00                       .
        brk                                     ; BDFE 00                       .
        brk                                     ; BDFF 00                       .
        brk                                     ; BE00 00                       .
        brk                                     ; BE01 00                       .
        brk                                     ; BE02 00                       .
        brk                                     ; BE03 00                       .
        brk                                     ; BE04 00                       .
        brk                                     ; BE05 00                       .
        brk                                     ; BE06 00                       .
        brk                                     ; BE07 00                       .
        brk                                     ; BE08 00                       .
        brk                                     ; BE09 00                       .
        brk                                     ; BE0A 00                       .
        brk                                     ; BE0B 00                       .
        brk                                     ; BE0C 00                       .
        brk                                     ; BE0D 00                       .
        brk                                     ; BE0E 00                       .
        brk                                     ; BE0F 00                       .
        brk                                     ; BE10 00                       .
        brk                                     ; BE11 00                       .
        brk                                     ; BE12 00                       .
        brk                                     ; BE13 00                       .
        brk                                     ; BE14 00                       .
        brk                                     ; BE15 00                       .
        brk                                     ; BE16 00                       .
        brk                                     ; BE17 00                       .
        brk                                     ; BE18 00                       .
        brk                                     ; BE19 00                       .
        brk                                     ; BE1A 00                       .
        brk                                     ; BE1B 00                       .
        brk                                     ; BE1C 00                       .
        brk                                     ; BE1D 00                       .
        brk                                     ; BE1E 00                       .
        brk                                     ; BE1F 00                       .
        brk                                     ; BE20 00                       .
        brk                                     ; BE21 00                       .
        brk                                     ; BE22 00                       .
        brk                                     ; BE23 00                       .
        brk                                     ; BE24 00                       .
        brk                                     ; BE25 00                       .
        brk                                     ; BE26 00                       .
        brk                                     ; BE27 00                       .
        brk                                     ; BE28 00                       .
        brk                                     ; BE29 00                       .
        brk                                     ; BE2A 00                       .
        brk                                     ; BE2B 00                       .
        brk                                     ; BE2C 00                       .
        brk                                     ; BE2D 00                       .
        brk                                     ; BE2E 00                       .
        brk                                     ; BE2F 00                       .
        brk                                     ; BE30 00                       .
        brk                                     ; BE31 00                       .
        brk                                     ; BE32 00                       .
        brk                                     ; BE33 00                       .
        brk                                     ; BE34 00                       .
        brk                                     ; BE35 00                       .
        brk                                     ; BE36 00                       .
        brk                                     ; BE37 00                       .
        brk                                     ; BE38 00                       .
        brk                                     ; BE39 00                       .
        brk                                     ; BE3A 00                       .
        brk                                     ; BE3B 00                       .
        brk                                     ; BE3C 00                       .
        brk                                     ; BE3D 00                       .
        brk                                     ; BE3E 00                       .
        brk                                     ; BE3F 00                       .
        brk                                     ; BE40 00                       .
        brk                                     ; BE41 00                       .
        brk                                     ; BE42 00                       .
        brk                                     ; BE43 00                       .
        brk                                     ; BE44 00                       .
        brk                                     ; BE45 00                       .
        brk                                     ; BE46 00                       .
        brk                                     ; BE47 00                       .
        brk                                     ; BE48 00                       .
        brk                                     ; BE49 00                       .
        brk                                     ; BE4A 00                       .
        brk                                     ; BE4B 00                       .
        brk                                     ; BE4C 00                       .
        brk                                     ; BE4D 00                       .
        brk                                     ; BE4E 00                       .
        brk                                     ; BE4F 00                       .
        brk                                     ; BE50 00                       .
        brk                                     ; BE51 00                       .
        brk                                     ; BE52 00                       .
        brk                                     ; BE53 00                       .
        brk                                     ; BE54 00                       .
        brk                                     ; BE55 00                       .
        brk                                     ; BE56 00                       .
        brk                                     ; BE57 00                       .
        brk                                     ; BE58 00                       .
        brk                                     ; BE59 00                       .
        brk                                     ; BE5A 00                       .
        brk                                     ; BE5B 00                       .
        brk                                     ; BE5C 00                       .
        brk                                     ; BE5D 00                       .
        brk                                     ; BE5E 00                       .
        brk                                     ; BE5F 00                       .
        brk                                     ; BE60 00                       .
        brk                                     ; BE61 00                       .
        brk                                     ; BE62 00                       .
        brk                                     ; BE63 00                       .
        brk                                     ; BE64 00                       .
        brk                                     ; BE65 00                       .
        brk                                     ; BE66 00                       .
        brk                                     ; BE67 00                       .
        brk                                     ; BE68 00                       .
        brk                                     ; BE69 00                       .
        brk                                     ; BE6A 00                       .
        brk                                     ; BE6B 00                       .
        brk                                     ; BE6C 00                       .
        brk                                     ; BE6D 00                       .
        brk                                     ; BE6E 00                       .
        brk                                     ; BE6F 00                       .
        brk                                     ; BE70 00                       .
        brk                                     ; BE71 00                       .
        brk                                     ; BE72 00                       .
        brk                                     ; BE73 00                       .
        brk                                     ; BE74 00                       .
        brk                                     ; BE75 00                       .
        brk                                     ; BE76 00                       .
        brk                                     ; BE77 00                       .
        brk                                     ; BE78 00                       .
        brk                                     ; BE79 00                       .
        brk                                     ; BE7A 00                       .
        brk                                     ; BE7B 00                       .
        brk                                     ; BE7C 00                       .
        brk                                     ; BE7D 00                       .
        brk                                     ; BE7E 00                       .
        brk                                     ; BE7F 00                       .
        brk                                     ; BE80 00                       .
        brk                                     ; BE81 00                       .
        brk                                     ; BE82 00                       .
        brk                                     ; BE83 00                       .
        brk                                     ; BE84 00                       .
        brk                                     ; BE85 00                       .
        brk                                     ; BE86 00                       .
        brk                                     ; BE87 00                       .
        brk                                     ; BE88 00                       .
        brk                                     ; BE89 00                       .
        brk                                     ; BE8A 00                       .
        brk                                     ; BE8B 00                       .
        brk                                     ; BE8C 00                       .
        brk                                     ; BE8D 00                       .
        brk                                     ; BE8E 00                       .
        brk                                     ; BE8F 00                       .
        brk                                     ; BE90 00                       .
        brk                                     ; BE91 00                       .
        brk                                     ; BE92 00                       .
        brk                                     ; BE93 00                       .
        brk                                     ; BE94 00                       .
        brk                                     ; BE95 00                       .
        brk                                     ; BE96 00                       .
        brk                                     ; BE97 00                       .
        brk                                     ; BE98 00                       .
        brk                                     ; BE99 00                       .
        brk                                     ; BE9A 00                       .
        brk                                     ; BE9B 00                       .
        brk                                     ; BE9C 00                       .
        brk                                     ; BE9D 00                       .
        brk                                     ; BE9E 00                       .
        brk                                     ; BE9F 00                       .
        brk                                     ; BEA0 00                       .
        brk                                     ; BEA1 00                       .
        brk                                     ; BEA2 00                       .
        brk                                     ; BEA3 00                       .
        brk                                     ; BEA4 00                       .
        brk                                     ; BEA5 00                       .
        brk                                     ; BEA6 00                       .
        brk                                     ; BEA7 00                       .
        brk                                     ; BEA8 00                       .
        brk                                     ; BEA9 00                       .
        brk                                     ; BEAA 00                       .
        brk                                     ; BEAB 00                       .
        brk                                     ; BEAC 00                       .
        brk                                     ; BEAD 00                       .
        brk                                     ; BEAE 00                       .
        brk                                     ; BEAF 00                       .
        brk                                     ; BEB0 00                       .
        brk                                     ; BEB1 00                       .
        brk                                     ; BEB2 00                       .
        brk                                     ; BEB3 00                       .
        brk                                     ; BEB4 00                       .
        brk                                     ; BEB5 00                       .
        brk                                     ; BEB6 00                       .
        brk                                     ; BEB7 00                       .
        brk                                     ; BEB8 00                       .
        brk                                     ; BEB9 00                       .
        brk                                     ; BEBA 00                       .
        brk                                     ; BEBB 00                       .
LBEBC:  brk                                     ; BEBC 00                       .
        brk                                     ; BEBD 00                       .
        brk                                     ; BEBE 00                       .
        brk                                     ; BEBF 00                       .
        brk                                     ; BEC0 00                       .
        brk                                     ; BEC1 00                       .
        brk                                     ; BEC2 00                       .
        brk                                     ; BEC3 00                       .
        brk                                     ; BEC4 00                       .
        brk                                     ; BEC5 00                       .
        brk                                     ; BEC6 00                       .
        brk                                     ; BEC7 00                       .
        brk                                     ; BEC8 00                       .
        brk                                     ; BEC9 00                       .
        brk                                     ; BECA 00                       .
        brk                                     ; BECB 00                       .
        brk                                     ; BECC 00                       .
        brk                                     ; BECD 00                       .
        brk                                     ; BECE 00                       .
        brk                                     ; BECF 00                       .
        brk                                     ; BED0 00                       .
        brk                                     ; BED1 00                       .
        brk                                     ; BED2 00                       .
        brk                                     ; BED3 00                       .
        brk                                     ; BED4 00                       .
        brk                                     ; BED5 00                       .
        brk                                     ; BED6 00                       .
        brk                                     ; BED7 00                       .
        brk                                     ; BED8 00                       .
        brk                                     ; BED9 00                       .
        brk                                     ; BEDA 00                       .
        brk                                     ; BEDB 00                       .
        brk                                     ; BEDC 00                       .
        brk                                     ; BEDD 00                       .
        brk                                     ; BEDE 00                       .
        brk                                     ; BEDF 00                       .
        brk                                     ; BEE0 00                       .
        brk                                     ; BEE1 00                       .
        brk                                     ; BEE2 00                       .
        brk                                     ; BEE3 00                       .
        brk                                     ; BEE4 00                       .
        brk                                     ; BEE5 00                       .
        brk                                     ; BEE6 00                       .
        brk                                     ; BEE7 00                       .
        brk                                     ; BEE8 00                       .
        brk                                     ; BEE9 00                       .
        brk                                     ; BEEA 00                       .
        brk                                     ; BEEB 00                       .
        brk                                     ; BEEC 00                       .
        brk                                     ; BEED 00                       .
        brk                                     ; BEEE 00                       .
        brk                                     ; BEEF 00                       .
        brk                                     ; BEF0 00                       .
        brk                                     ; BEF1 00                       .
        brk                                     ; BEF2 00                       .
        brk                                     ; BEF3 00                       .
        brk                                     ; BEF4 00                       .
        brk                                     ; BEF5 00                       .
        brk                                     ; BEF6 00                       .
        brk                                     ; BEF7 00                       .
        brk                                     ; BEF8 00                       .
        brk                                     ; BEF9 00                       .
        brk                                     ; BEFA 00                       .
        brk                                     ; BEFB 00                       .
        brk                                     ; BEFC 00                       .
        brk                                     ; BEFD 00                       .
        brk                                     ; BEFE 00                       .
        brk                                     ; BEFF 00                       .
        brk                                     ; BF00 00                       .
        brk                                     ; BF01 00                       .
        brk                                     ; BF02 00                       .
        brk                                     ; BF03 00                       .
        brk                                     ; BF04 00                       .
        brk                                     ; BF05 00                       .
        brk                                     ; BF06 00                       .
        brk                                     ; BF07 00                       .
        brk                                     ; BF08 00                       .
        brk                                     ; BF09 00                       .
        brk                                     ; BF0A 00                       .
        brk                                     ; BF0B 00                       .
        brk                                     ; BF0C 00                       .
        brk                                     ; BF0D 00                       .
        brk                                     ; BF0E 00                       .
        brk                                     ; BF0F 00                       .
        brk                                     ; BF10 00                       .
        brk                                     ; BF11 00                       .
        brk                                     ; BF12 00                       .
        brk                                     ; BF13 00                       .
        brk                                     ; BF14 00                       .
        brk                                     ; BF15 00                       .
        brk                                     ; BF16 00                       .
        brk                                     ; BF17 00                       .
        brk                                     ; BF18 00                       .
        brk                                     ; BF19 00                       .
        brk                                     ; BF1A 00                       .
        brk                                     ; BF1B 00                       .
        brk                                     ; BF1C 00                       .
        brk                                     ; BF1D 00                       .
        brk                                     ; BF1E 00                       .
        brk                                     ; BF1F 00                       .
        brk                                     ; BF20 00                       .
        brk                                     ; BF21 00                       .
        brk                                     ; BF22 00                       .
        brk                                     ; BF23 00                       .
        brk                                     ; BF24 00                       .
        brk                                     ; BF25 00                       .
        brk                                     ; BF26 00                       .
        brk                                     ; BF27 00                       .
        brk                                     ; BF28 00                       .
        brk                                     ; BF29 00                       .
        brk                                     ; BF2A 00                       .
        brk                                     ; BF2B 00                       .
        brk                                     ; BF2C 00                       .
        brk                                     ; BF2D 00                       .
        brk                                     ; BF2E 00                       .
        brk                                     ; BF2F 00                       .
        brk                                     ; BF30 00                       .
        brk                                     ; BF31 00                       .
        brk                                     ; BF32 00                       .
        brk                                     ; BF33 00                       .
        brk                                     ; BF34 00                       .
        brk                                     ; BF35 00                       .
        brk                                     ; BF36 00                       .
        brk                                     ; BF37 00                       .
        brk                                     ; BF38 00                       .
        brk                                     ; BF39 00                       .
        brk                                     ; BF3A 00                       .
        brk                                     ; BF3B 00                       .
        brk                                     ; BF3C 00                       .
        brk                                     ; BF3D 00                       .
        brk                                     ; BF3E 00                       .
        brk                                     ; BF3F 00                       .
        brk                                     ; BF40 00                       .
        brk                                     ; BF41 00                       .
        brk                                     ; BF42 00                       .
        brk                                     ; BF43 00                       .
        brk                                     ; BF44 00                       .
        brk                                     ; BF45 00                       .
        brk                                     ; BF46 00                       .
        brk                                     ; BF47 00                       .
        brk                                     ; BF48 00                       .
        brk                                     ; BF49 00                       .
        brk                                     ; BF4A 00                       .
        brk                                     ; BF4B 00                       .
        brk                                     ; BF4C 00                       .
        brk                                     ; BF4D 00                       .
        brk                                     ; BF4E 00                       .
        brk                                     ; BF4F 00                       .
        brk                                     ; BF50 00                       .
        brk                                     ; BF51 00                       .
        brk                                     ; BF52 00                       .
        brk                                     ; BF53 00                       .
        brk                                     ; BF54 00                       .
        brk                                     ; BF55 00                       .
        brk                                     ; BF56 00                       .
        brk                                     ; BF57 00                       .
        brk                                     ; BF58 00                       .
        brk                                     ; BF59 00                       .
        brk                                     ; BF5A 00                       .
        brk                                     ; BF5B 00                       .
        brk                                     ; BF5C 00                       .
        brk                                     ; BF5D 00                       .
        brk                                     ; BF5E 00                       .
        brk                                     ; BF5F 00                       .
        brk                                     ; BF60 00                       .
        brk                                     ; BF61 00                       .
        brk                                     ; BF62 00                       .
        brk                                     ; BF63 00                       .
        brk                                     ; BF64 00                       .
        brk                                     ; BF65 00                       .
        brk                                     ; BF66 00                       .
        brk                                     ; BF67 00                       .
        brk                                     ; BF68 00                       .
        brk                                     ; BF69 00                       .
        brk                                     ; BF6A 00                       .
        brk                                     ; BF6B 00                       .
        brk                                     ; BF6C 00                       .
        brk                                     ; BF6D 00                       .
        brk                                     ; BF6E 00                       .
        brk                                     ; BF6F 00                       .
        brk                                     ; BF70 00                       .
        brk                                     ; BF71 00                       .
        brk                                     ; BF72 00                       .
        brk                                     ; BF73 00                       .
        brk                                     ; BF74 00                       .
        brk                                     ; BF75 00                       .
        brk                                     ; BF76 00                       .
        brk                                     ; BF77 00                       .
        brk                                     ; BF78 00                       .
        brk                                     ; BF79 00                       .
        brk                                     ; BF7A 00                       .
        brk                                     ; BF7B 00                       .
        brk                                     ; BF7C 00                       .
        brk                                     ; BF7D 00                       .
        brk                                     ; BF7E 00                       .
        brk                                     ; BF7F 00                       .
        brk                                     ; BF80 00                       .
        brk                                     ; BF81 00                       .
        brk                                     ; BF82 00                       .
        brk                                     ; BF83 00                       .
        brk                                     ; BF84 00                       .
        brk                                     ; BF85 00                       .
        brk                                     ; BF86 00                       .
        brk                                     ; BF87 00                       .
        brk                                     ; BF88 00                       .
        brk                                     ; BF89 00                       .
        brk                                     ; BF8A 00                       .
        brk                                     ; BF8B 00                       .
        brk                                     ; BF8C 00                       .
        brk                                     ; BF8D 00                       .
        brk                                     ; BF8E 00                       .
        brk                                     ; BF8F 00                       .
        brk                                     ; BF90 00                       .
        brk                                     ; BF91 00                       .
        brk                                     ; BF92 00                       .
        brk                                     ; BF93 00                       .
        brk                                     ; BF94 00                       .
        brk                                     ; BF95 00                       .
        brk                                     ; BF96 00                       .
        brk                                     ; BF97 00                       .
        brk                                     ; BF98 00                       .
        brk                                     ; BF99 00                       .
        brk                                     ; BF9A 00                       .
        brk                                     ; BF9B 00                       .
        brk                                     ; BF9C 00                       .
        brk                                     ; BF9D 00                       .
        brk                                     ; BF9E 00                       .
        brk                                     ; BF9F 00                       .
        brk                                     ; BFA0 00                       .
        brk                                     ; BFA1 00                       .
        brk                                     ; BFA2 00                       .
        brk                                     ; BFA3 00                       .
        brk                                     ; BFA4 00                       .
        brk                                     ; BFA5 00                       .
        brk                                     ; BFA6 00                       .
        brk                                     ; BFA7 00                       .
        brk                                     ; BFA8 00                       .
        brk                                     ; BFA9 00                       .
        brk                                     ; BFAA 00                       .
        brk                                     ; BFAB 00                       .
        brk                                     ; BFAC 00                       .
        brk                                     ; BFAD 00                       .
        brk                                     ; BFAE 00                       .
        brk                                     ; BFAF 00                       .
        brk                                     ; BFB0 00                       .
        brk                                     ; BFB1 00                       .
        brk                                     ; BFB2 00                       .
        brk                                     ; BFB3 00                       .
        brk                                     ; BFB4 00                       .
        brk                                     ; BFB5 00                       .
        brk                                     ; BFB6 00                       .
        brk                                     ; BFB7 00                       .
        brk                                     ; BFB8 00                       .
        brk                                     ; BFB9 00                       .
        brk                                     ; BFBA 00                       .
        brk                                     ; BFBB 00                       .
        brk                                     ; BFBC 00                       .
        brk                                     ; BFBD 00                       .
        brk                                     ; BFBE 00                       .
        brk                                     ; BFBF 00                       .
        brk                                     ; BFC0 00                       .
        brk                                     ; BFC1 00                       .
        brk                                     ; BFC2 00                       .
        brk                                     ; BFC3 00                       .
        brk                                     ; BFC4 00                       .
        brk                                     ; BFC5 00                       .
        brk                                     ; BFC6 00                       .
        brk                                     ; BFC7 00                       .
        brk                                     ; BFC8 00                       .
        brk                                     ; BFC9 00                       .
        brk                                     ; BFCA 00                       .
        brk                                     ; BFCB 00                       .
        brk                                     ; BFCC 00                       .
        brk                                     ; BFCD 00                       .
        brk                                     ; BFCE 00                       .
        brk                                     ; BFCF 00                       .
        brk                                     ; BFD0 00                       .
LBFD1:  brk                                     ; BFD1 00                       .
        brk                                     ; BFD2 00                       .
        brk                                     ; BFD3 00                       .
        brk                                     ; BFD4 00                       .
        brk                                     ; BFD5 00                       .
        brk                                     ; BFD6 00                       .
        brk                                     ; BFD7 00                       .
        brk                                     ; BFD8 00                       .
        brk                                     ; BFD9 00                       .
        brk                                     ; BFDA 00                       .
        brk                                     ; BFDB 00                       .
        brk                                     ; BFDC 00                       .
        brk                                     ; BFDD 00                       .
        brk                                     ; BFDE 00                       .
        brk                                     ; BFDF 00                       .
        brk                                     ; BFE0 00                       .
        brk                                     ; BFE1 00                       .
        brk                                     ; BFE2 00                       .
        brk                                     ; BFE3 00                       .
        brk                                     ; BFE4 00                       .
        brk                                     ; BFE5 00                       .
        brk                                     ; BFE6 00                       .
        brk                                     ; BFE7 00                       .
        brk                                     ; BFE8 00                       .
        brk                                     ; BFE9 00                       .
        brk                                     ; BFEA 00                       .
        brk                                     ; BFEB 00                       .
        brk                                     ; BFEC 00                       .
        brk                                     ; BFED 00                       .
        brk                                     ; BFEE 00                       .
        brk                                     ; BFEF 00                       .
        brk                                     ; BFF0 00                       .
        brk                                     ; BFF1 00                       .
        brk                                     ; BFF2 00                       .
        brk                                     ; BFF3 00                       .
        brk                                     ; BFF4 00                       .
        brk                                     ; BFF5 00                       .
        brk                                     ; BFF6 00                       .
        brk                                     ; BFF7 00                       .
        brk                                     ; BFF8 00                       .
        brk                                     ; BFF9 00                       .
        brk                                     ; BFFA 00                       .
        brk                                     ; BFFB 00                       .
        brk                                     ; BFFC 00                       .
        brk                                     ; BFFD 00                       .
        brk                                     ; BFFE 00                       .
        brk                                     ; BFFF 00                       .
