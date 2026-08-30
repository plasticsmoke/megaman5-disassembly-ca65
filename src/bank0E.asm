.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK0E"

; =============================================================================
; BANK $0E (mapped at $A000) — ENDING SEQUENCE + WILY 3 STAGE DATA
;
; $A000-$A8FF: the ending cutscene program ($30=$23, entered from the
; game-flow hub with the $17/$0E pair mapped — bank $17 stays at $8000,
; so the roll-call reuses its boss-intro tables directly, and credits
; text is fetched by briefly mapping bank $0F at $8000).
; $A900-$BFFF: Wily 3 stage data (stage $0E's data bank: screen table
; at $A900; boss-rush screens $08-$0F) — stage-data format pass.
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
; ENDING SEQUENCE — $A000 (from bank $17:$8014 on $30=$23). Beats:
;  1. $A000 aftermath scene: menu pseudo-stage screens $02/$03, palette
;     program 0, cast from LA51E records; IRQ mode $05 split at $2200,
;     camera starts at scroll Y $EF; Mega Man walks a scripted path
;     (LA432) while the view pans up, a second actor floats away
;     (LA3DC), and the palette steps to black (LA3FF) — nightfall.
;  2. $A077 roll-call backdrop: screen $05 (alt $27=$0F) + starfield
;     tableau LA57C (star CHR into $ED), header text LA56A, ending
;     music ($0C), then LA2A3: the eight-boss roll call.
;  3. $A0F1 credits flight: both nametables cleared, Mega-Man-on-Beat
;     tableau LA5C0 + palette LA6C4, then LA1AA scrolls 24 credit
;     pages past; finally LA152 types THE END as the flyer crosses,
;     and LA14C spins forever (the game halts here).
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
; --- LA152: THE END. Slot 0 (spawned from cast record 6) glides right
; (xvel 1); as its X crosses each LA738 mark, the next chunk of the
; "THE END" logo is written (PPU addr lo LA73E, tile LA744, base row
; $2940). At X=$58 the flyer morphs to sub $9C and drops behind the BG.
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
; --- LA1AA: CREDITS SCROLLER (runs until 24 pages have passed and the
; scroll rests at $D0). Scroll Y $FA advances 1px every other frame,
; toggling the nametable at $F0; every 8px the row entering from the
; bottom is rebuilt: blank row template LA6D4, row PPU address from
; LA6F8/LA718 (NT bit folded in via $FD), and when the row counter hits
; the next LA6AB threshold the next credits page is typed into it —
; bank $0F is mapped at $8000 for the text (ptr tables $0F:8000/$8028,
; page index $6C), then bank $17 restored. Scroller rows are column offset +
; length + chars ($20 = keep blank).
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
; --- LA254: type credits page Y from bank $0F (mapped at $8000 in
; place of $17, restored at the end): records of PPU addr hi/lo + text
; ($00 = next record, $FF = end of page), one char per 5 frames.
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
; --- LA2A3: BOSS ROLL CALL, one boss per $6C = 0-7. Each teleports in
; as a menu actor (cast record 5) and replays his stage-select intro
; using bank $17's tables directly at $8000 ($8DB3 sub_types, $8DC3
; pose strobe, $8DBB done phase, $8C42/$8C4A lit palette rows; Charge
; Man's steam companion included), then his credits page — DWN. number,
; name, and the fan designer credit — is typed via LA254, $B4 frames,
; sprite rows fade (LA50E), next boss.
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
; --- LA383: after the bosses, pages 8-$0F (staff credits) are typed on
; the same backdrop, $B4 frames each, separated by the LA646 wipe
; block, until $6C reaches $10; back to the caller for the flight scene.
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
; --- LA3A6: drift the tableau sprites left (first 8 at 2px/frame —
; cloud parallax), OAM $0200-$0243.
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
; --- LA3BB / LA3BD: run the scene 1 / A frames (drift + render via
; render_tick_hud, which preserves the tableau OAM).
LA3BB:  lda     #$01                            ; A3BB A9 01                    ..
LA3BD:  sta     $0F                             ; A3BD 85 0F                    ..
LA3BF:  jsr     LA3A6                           ; A3BF 20 A6 A3                  ..
        jsr     LF36F                           ; A3C2 20 6F F3                  o.
        dec     $0F                             ; A3C5 C6 0F                    ..
        bne     LA3BF                           ; A3C7 D0 F6                    ..
        rts                                     ; A3C9 60                       `

; ----------------------------------------------------------------------------
; --- LA3CA: same as LA3BD but also pins the roll-call actor's anim
; hold ($0570 = 0) each frame.
LA3CA:  sta     $0F                             ; A3CA 85 0F                    ..
LA3CC:  lda     #$00                            ; A3CC A9 00                    ..
        sta     $0570                           ; A3CE 8D 70 05                 .p.
        jsr     LA3A6                           ; A3D1 20 A6 A3                  ..
        jsr     LF36F                           ; A3D4 20 6F F3                  o.
        dec     $0F                             ; A3D7 C6 0F                    ..
        bne     LA3CC                           ; A3D9 D0 F1                    ..
        rts                                     ; A3DB 60                       `

; ----------------------------------------------------------------------------
; --- LA3DC: scene 1: slot 1 floats upward ($40 subpixels/frame) until
; it leaves the screen (Y=$F0) and despawns.
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
; --- LA3FF: nightfall: darken all 32 palette entries by $10 every 16
; frames, 5 steps to black.
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
; --- LA432: scene 1 walk script for slot 0: direction/duration steps
; from LA53A/LA552 (speed preset $38), camera panning up 1px per 4
; frames toward scroll Y $A0 with a step cue ($2B) every 4px; ends when
; the walk's move flag ($0390) sets — he has walked off.
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
; --- LA47C: plain A-frame wait (render_tick_frame).
LA47C:  sta     $0F                             ; A47C 85 0F                    ..
LA47E:  jsr     render_tick_frame                           ; A47E 20 63 F3                  c.
        dec     $0F                             ; A481 C6 0F                    ..
        bne     LA47E                           ; A483 D0 F9                    ..
        rts                                     ; A485 60                       `

; ----------------------------------------------------------------------------
; --- LA486: palette program Y from LA4DA: 2 CHR banks + 32 colors.
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
; --- LA49F / LA4A3: ending cast spawner — X slots from record Y down:
; type LA51E / sub_type LA525 / X LA52C / Y LA533, AI vars cleared.
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
; =============================================================================
; ENDING DATA — $A4DA-$A8FF
;   $A4DA palette programs (LA486), $A50E roll-call sprite fade rows
;   $A51E-$A539 cast spawn records (type/sub/X/Y, LA4A3)
;   $A53A/$A552 scene-1 walk script (dirs / durations)
;   $A56A/$A573 roll-call header text, $A57C starfield tableau OAM
;   $A5C0 Mega-Man-on-Beat tableau OAM, $A604/$A646 credits wipe blocks
;   $A6AB per-page row thresholds, $A6C4 flight palette
;   $A6D4 blank scroll row, $A6F8/$A718 scroll row PPU addresses
;   $A738/$A73E/$A744 THE END trigger records (X mark / addr / tile)
; =============================================================================
LA4DA:  .byte   $E4                             ; A4DA
LA4DB:  .byte   $E6                             ; A4DB
LA4DC:  .byte   $0F,$37,$17,$07,$0F,$30,$23,$21,$0F,$30,$26,$21,$0F,$30,$11,$21 ; A4DC
        .byte   $0F,$0F,$2C,$11,$0F,$0F,$20,$37,$0F,$0F,$20,$15,$0F,$0F,$27,$15 ; A4EC
        .byte   $C8,$CA,$0F,$20,$2C,$1C,$0F,$31,$1C,$27,$0F,$31,$1C,$01,$0F,$20 ; A4FC
        .byte   $0F,$0F                         ; A50C
LA50E:  .byte   $0F,$0F,$2C,$11,$0F,$0F,$20,$37,$0F,$0F,$20,$11,$0F,$0F,$20,$15 ; A50E
LA51E:  .byte   $6D,$6D,$6D,$6D,$01,$6D,$01     ; A51E
LA525:  .byte   $6A,$69,$71,$68,$C5,$5B,$9B     ; A525
LA52C:  .byte   $D8,$E8,$C8,$1C,$3C,$80,$FC     ; A52C
LA533:  .byte   $78,$DB,$7F,$B3,$BB,$74,$74     ; A533
LA53A:  .byte   $03,$02,$01,$00,$0F,$0E,$0D,$0C,$0D,$0E,$0F,$0E,$0D,$0C,$0D,$0E ; A53A
        .byte   $0F,$0E,$0D,$0C,$0D,$0E,$0F,$FF ; A54A
LA552:  .byte   $10,$10,$10,$10,$10,$10,$10,$20,$08,$08,$10,$08,$08,$20,$08,$08 ; A552
        .byte   $18,$08,$08,$18,$08,$08,$FF,$FF ; A562
LA56A:  .byte   $21,$AD,$04,$53,$54,$41,$46,$46,$FF ; A56A
LA573:  .byte   $21,$AD,$04,$01,$01,$01,$01,$01,$FF ; A573
LA57C:  .byte   $10,$76,$01,$20,$28,$76,$01,$68,$18,$76,$01,$90,$20,$76,$01,$D0 ; A57C
        .byte   $B8,$76,$01,$10,$C8,$76,$01,$58,$C0,$76,$01,$88,$E0,$76,$01,$D0 ; A58C
        .byte   $20,$77,$01,$40                 ; A59C

; ----------------------------------------------------------------------------
        .byte   $30,$77,$01,$B0,$08,$77,$01,$C8,$D0,$77,$01,$28,$B0,$77,$01,$40 ; A5A0
        .byte   $C0,$77,$01,$A8,$E0,$77,$01,$C8,$F8,$00,$00,$C8,$F8,$00,$00,$C8 ; A5B0
LA5C0:  .byte   $10,$76,$01,$10,$18,$76,$01,$88,$30,$76,$01,$38,$50,$76,$01,$C8 ; A5C0
        .byte   $90,$76,$01,$70,$B0,$76,$01,$E0,$D0,$76,$01,$B8,$D8,$76,$01,$18 ; A5D0
        .byte   $20,$77,$01,$28,$28,$77,$01,$A8,$38,$77,$01,$C0,$58,$77,$01,$88 ; A5E0
        .byte   $68,$77,$01,$40,$98,$77,$01,$50,$A0,$77,$01,$C0,$B8,$77,$01,$28 ; A5F0
        .byte   $C8,$77,$01,$78                 ; A600
LA604:  .byte   $21,$83,$08,$01,$01,$01,$01,$01,$01,$01,$01,$01,$21,$C4,$07,$01 ; A604
        .byte   $01,$01,$01,$01,$01,$01,$01,$21,$E7,$03,$01,$01,$01,$01,$21,$B5 ; A614
        .byte   $07,$01,$01,$01,$01,$01,$01,$01,$01,$21,$F3,$0A,$01,$01,$01,$01 ; A624
        .byte   $01,$01,$01,$01,$01,$01,$01,$22,$16,$06,$01,$01,$01,$01,$01,$01 ; A634
        .byte   $01,$FF                         ; A644
LA646:  .byte   $21,$64,$09,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$21,$85,$08 ; A646
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$21,$E4,$08,$01,$01,$01,$01 ; A656
        .byte   $01,$01,$01,$01,$01,$22,$05,$08,$01,$01,$01,$01,$01,$01,$01,$01 ; A666
        .byte   $01,$21,$73,$08,$01,$01,$01,$01,$01,$01,$01,$01,$01,$21,$94,$08 ; A676
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$21,$F3,$09,$01,$01,$01,$01 ; A686
        .byte   $01,$01,$01,$01,$01,$01,$22,$14,$0A,$01,$01,$01,$01,$01,$01,$01 ; A696
        .byte   $01,$01,$01,$01,$FF             ; A6A6
LA6AB:  .byte   $01,$03,$06,$08,$0A,$0C,$0E,$10,$13,$15,$17,$19,$1B,$1D,$01,$04 ; A6AB
        .byte   $06,$08,$0A,$0C,$0E,$11,$13,$08,$FF ; A6BB
LA6C4:  .byte   $0F,$20,$0F,$0F,$0F,$20,$0F,$0F,$0F,$20,$0F,$0F,$0F,$20,$0F,$0F ; A6C4
LA6D4:  .byte   $20,$00,$1F,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A6D4
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A6E4
        .byte   $00,$00,$00,$FF                 ; A6F4
LA6F8:  .byte   $20,$20,$20,$20,$20,$20,$20,$20,$21,$21,$21,$21,$21,$21,$21,$21 ; A6F8
        .byte   $22,$22,$22,$22,$22,$22,$22,$22,$23,$23,$23,$23,$23,$23,$23,$23 ; A708
LA718:  .byte   $00,$20,$40,$60,$80,$A0,$C0,$E0,$00,$20,$40,$60,$80,$A0,$C0,$E0 ; A718
        .byte   $00,$20,$40,$60,$80,$A0,$C0,$E0,$00,$20,$40,$60,$80,$A0,$C0,$E0 ; A728
LA738:  .byte   $6C,$74,$7C                     ; A738

; ----------------------------------------------------------------------------
        .byte   $84,$8C,$94                     ; A73B
LA73E:  .byte   $4D,$4E,$4F,$50,$51,$52         ; A73E
LA744:  .byte   $43,$41,$50,$43,$4F,$4D,$FB,$15,$FF,$5F,$FF,$5D,$FF,$7F,$F9,$7F ; A744
        .byte   $FF,$F7,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$7F,$FF,$FF,$FF,$D5,$FA,$95 ; A754
        .byte   $FA,$95,$FE,$71,$F9,$5D,$DF,$15,$FE,$54,$DD,$75,$6F,$51,$F7,$70 ; A764
        .byte   $9F,$79,$FF,$54,$FF,$F7,$BF,$7D,$FF,$77,$FF,$77,$BE,$54,$FE,$55 ; A774
        .byte   $FF,$55,$FF,$F4,$FF,$7C,$FF,$D5,$FF,$DF,$FF,$35,$FF,$FD,$FF,$7F ; A784
        .byte   $FF,$55,$FF,$7D,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FD,$EE,$51,$75,$45 ; A794
        .byte   $FD,$D1,$BF,$45,$D5,$D0,$FF,$1E,$FF,$71,$7F,$57,$FF,$55,$FF,$55 ; A7A4
        .byte   $FF,$DF,$DD,$7D,$FF,$7F,$FF,$57,$FF,$F7,$FF,$FF,$FF,$15,$A5,$15 ; A7B4
        .byte   $FF,$5D,$FF,$75,$7E,$74,$EF,$35,$FF,$57,$FE,$75,$FF,$FD,$FF,$F5 ; A7C4
        .byte   $FF,$77,$FF,$FD,$FF,$D7,$FF,$5F,$FF,$FF,$FF,$FF,$F7,$46,$DD,$54 ; A7D4
        .byte   $EF,$5D,$EE,$51,$A3,$74,$7F,$5C,$C5,$04,$BD,$11,$E7,$15,$6B,$D0 ; A7E4
        .byte   $9B,$45,$77,$54,$FF,$53,$5F,$D7,$FF,$F5,$FF,$77,$00,$00,$00,$00 ; A7F4
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A804
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A814
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A824
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A834
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A844
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A854
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A864
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A874
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A884
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A894
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8A4
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8B4
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8C4
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8D4
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8E4
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8F4

; =============================================================================
; WILY 3 STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $A900: screen -> layout index ---
        .byte   $02,$03,$04,$05,$06,$06,$06,$13,$15,$15,$21,$1B,$16,$1C,$1C,$1C ; A900  screens $00-$0F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A910  screens $10-$1F
        .byte   $00,$20,$00,$84,$00,$02,$00,$00,$02,$00,$80,$00,$00,$00,$00,$04 ; A920  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A930  screens $30-$3F
        .byte   $20,$00,$28,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00 ; A940  screens $40-$4F
; --- $A950: section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $22,$20,$20,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A950
        .byte   $00,$10,$00,$00,$22,$00,$08,$08 ; A960
; --- $A968: per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $09,$00,$0F,$00,$80,$00,$00,$22,$80,$01,$00,$84,$00,$00,$00,$00 ; A968
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A978
; --- $A980: BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $B8,$B0,$20,$80,$00,$08,$00,$00 ; A980
; --- $A988: BG palette (16 bytes) ---
        .byte   $0F,$30,$22,$13,$0F,$30,$27,$07,$0F,$30,$2C,$0C,$0F,$0F,$21,$09 ; A988
; --- $A998: sprite palette-cycle seeds -> $05F0 slots ($A998-$A99B read) ---
        .byte   $00,$00,$00,$99,$0F,$30,$22,$13 ; A998
; --- $A9A0: unreferenced ---
        .byte   $0F,$30,$27,$07,$0F,$30,$22,$13,$0F,$30,$25,$15,$00,$00,$00,$00 ; A9A0
        .byte   $00,$20,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9B0
        .byte   $28,$00,$02,$04,$02,$00,$00,$84,$00,$00,$20,$00,$20,$00,$00,$00 ; A9C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9D0
; --- $A9E0: screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$00,$00,$00,$00,$00,$00,$40,$A0,$00,$80,$A0,$00,$10,$0A,$82 ; A9E0  terminator / filler
        .byte   $00,$00,$22,$08,$28,$08,$00,$00,$20,$00,$00,$00,$00,$00,$00 ; A9F0  
        .byte   $00                             ; A9FF  -1 base for the spawn arrays
; --- $AA00: spawn screens (ascending) ---
        .byte   $00,$00,$02,$02,$03,$03,$03,$03,$03,$03,$03,$03,$03,$04,$08,$09 ; AA00  entries $00-$0F
        .byte   $0A,$0B,$0C,$0D,$0E,$0F,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA10  entries $10-$1F
        .byte   $08,$20,$00,$00,$00,$01,$00,$04,$00,$00,$00,$00,$00,$40,$00,$00 ; AA20  entries $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA30  entries $30-$3F
        .byte   $0A,$00,$00,$80,$00,$10,$00,$00,$00,$10,$00,$10,$00,$00,$00,$00 ; AA40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA50  entries $50-$5F
        .byte   $00,$04,$00,$44,$00,$41,$00,$02,$28,$20,$00,$00,$00,$00,$00,$01 ; AA60  entries $60-$6F
        .byte   $08,$00,$00,$02,$00,$08,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00 ; AA70  entries $70-$7F
; --- $AA80: spawn X px ---
        .byte   $30,$D0,$B0,$D0,$20,$20,$20,$80,$80,$E0,$E0,$E0,$80,$80,$D8,$D8 ; AA80  entries $00-$0F
        .byte   $D8,$D8,$D8,$D8,$D8,$D8,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA90  entries $10-$1F
        .byte   $00,$02,$08,$80,$00,$48,$00,$02,$80,$01,$00,$00,$00,$04,$00,$0A ; AAA0  entries $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAB0  entries $30-$3F
        .byte   $00,$50,$00,$02,$00,$00,$00,$02,$00,$00,$00,$00,$00,$10,$00,$00 ; AAC0  entries $40-$4F
        .byte   $80,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$10,$00,$00,$00,$00 ; AAD0  entries $50-$5F
        .byte   $00,$50,$00,$08,$10,$00,$00,$20,$0A,$91,$00,$04,$00,$81,$00,$40 ; AAE0  entries $60-$6F
        .byte   $00,$04,$80,$00,$00,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAF0  entries $70-$7F
; --- $AB00: spawn Y px ---
        .byte   $58,$58,$B4,$B0,$30,$70,$B0,$70,$B0,$30,$70,$B0,$30,$18,$00,$00 ; AB00  entries $00-$0F
        .byte   $00,$00,$00,$00,$00,$00,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB10  entries $10-$1F
        .byte   $00,$A0,$02,$00,$00,$60,$80,$40,$00,$00,$00,$00,$80,$00,$00,$00 ; AB20  entries $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB30  entries $30-$3F
        .byte   $08,$40,$00,$00,$00,$00,$00,$08,$00,$00,$00,$10,$20,$00,$00,$00 ; AB40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB50  entries $50-$5F
        .byte   $00,$00,$00,$40,$00,$74,$00,$08,$0A,$0C,$80,$08,$00,$21,$00,$00 ; AB60  entries $60-$6F
        .byte   $00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB70  entries $70-$7F
; --- $AB80: spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $81,$82,$1D,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$5D,$65,$67 ; AB80  entries $00-$0F
        .byte   $62,$64,$69,$63,$68,$66,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB90  entries $10-$1F
        .byte   $00,$80,$00,$00,$00,$0C,$00,$00,$00,$24,$00,$80,$08,$20,$00,$01 ; ABA0  entries $20-$2F
        .byte   $00,$00,$00,$10,$00,$00,$00,$10,$20,$00,$00,$00,$00,$00,$00,$00 ; ABB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00 ; ABC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$14,$00,$08,$0A,$00,$02,$00,$00,$22,$00,$05 ; ABE0  entries $60-$6F
        .byte   $00,$00,$02,$40,$00,$50,$00,$80,$00,$00,$00,$00,$00,$00,$00,$00 ; ABF0  entries $70-$7F
; --- $AC00: per-screen spawn-list start index ---
        .byte   $00,$02,$02,$04,$0D,$0D,$0D,$0D,$0E,$0F,$10,$11,$12,$13,$14,$15 ; AC00  screens $00-$0F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC10  screens $10-$1F
        .byte   $04,$00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC20  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC30  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC40  screens $40-$4F
        .byte   $00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC50  screens $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC60  screens $60-$6F
        .byte   $00,$00,$01,$00,$00,$04,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00 ; AC70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC90  screens $90-$9F
        .byte   $20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00,$01,$00,$00 ; ACA0  screens $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 ; ACB0  screens $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACD0  screens $D0-$DF
        .byte   $00,$10,$00,$00,$02,$00,$10,$00,$40,$00,$08,$01,$10,$00,$00,$00 ; ACE0  screens $E0-$EF
        .byte   $00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00 ; ACF0  screens $F0-$FF
; --- $AD00: metatile top-left tile ids ---
        .byte   $00,$0C,$0C,$0E,$04,$06,$08,$0A,$00,$00,$3C,$3E,$24,$26,$28,$2A ; AD00  metatiles $00-$0F
        .byte   $22,$7C,$5C,$5E,$8C,$8E,$48,$4A,$22,$00,$4C,$4E,$AC,$AE,$68,$6A ; AD10  metatiles $10-$1F
        .byte   $40,$80,$A0,$D5,$A0,$34,$2C,$2E,$D0,$D2,$D4,$A1,$70,$72,$00,$54 ; AD20  metatiles $20-$2F
        .byte   $28,$30,$F2,$00,$64,$66,$56,$7C,$1C,$1E,$58,$F0,$11,$11,$11,$11 ; AD30  metatiles $30-$3F
        .byte   $54,$04,$54,$56,$56,$56,$56,$58,$68,$44,$44,$30,$74,$76,$74,$44 ; AD40  metatiles $40-$4F
        .byte   $62,$60,$62,$22,$44,$06,$16,$54,$42,$40,$42,$02,$54,$26,$4A,$15 ; AD50  metatiles $50-$5F
        .byte   $4B,$4D,$4F,$4B,$08,$09,$0F,$00,$6B,$6D,$6F,$6B,$28,$29,$2F,$00 ; AD60  metatiles $60-$6F
        .byte   $46,$48,$4A,$46,$0B,$0D,$2B,$2D,$46,$00,$34,$55,$54,$6A,$00,$58 ; AD70  metatiles $70-$7F
        .byte   $68,$02,$42,$40,$42,$00,$00,$00,$00,$00,$00,$82,$00,$8E,$00,$00 ; AD80  metatiles $80-$8F
        .byte   $00,$00,$84,$86,$00,$8A,$8C,$00,$00,$A2,$A4,$A6,$A8,$AA,$AC,$AE ; AD90  metatiles $90-$9F
        .byte   $00,$02,$04,$06,$08,$0A,$0C,$BE,$20,$22,$24,$26,$28,$2A,$2C,$2E ; ADA0  metatiles $A0-$AF
        .byte   $40,$42,$44,$46,$48,$4A,$4C,$4E,$80,$82,$84,$86,$88,$8A,$8C,$8E ; ADB0  metatiles $B0-$BF
        .byte   $A0,$A2,$A4,$A6,$A8,$AA,$AC,$AE,$C0,$C2,$C4,$C6,$C8,$CA,$CC,$00 ; ADC0  metatiles $C0-$CF
        .byte   $C0,$62,$64,$66,$68,$6A,$6C,$6E,$E0,$E2,$E4,$E6,$E8,$EA,$EC,$00 ; ADD0  metatiles $D0-$DF
        .byte   $A8,$AA,$AC,$AE,$CC,$CE,$EA,$EA,$C8,$CA,$CC,$CE,$EC,$EE,$E8,$F8 ; ADE0  metatiles $E0-$EF
        .byte   $E8,$EA,$EC,$EE,$D8,$DA,$8C,$8E,$00,$F3,$E0,$F1,$CC,$CE,$AC,$AE ; ADF0  metatiles $F0-$FF
; --- $AE00: metatile bottom-left tile ids ---
        .byte   $00,$0D,$0D,$0F,$05,$07,$09,$0B,$00,$7D,$3D,$3F,$25,$27,$29,$2B ; AE00  metatiles $00-$0F
        .byte   $23,$02,$5D,$5F,$8D,$8F,$49,$4B,$41,$03,$4D,$4F,$AD,$AF,$69,$6B ; AE10  metatiles $10-$1F
        .byte   $23,$00,$00,$D6,$0F,$A1,$2D,$2F,$D1,$D3,$D0,$00,$71,$73,$00,$58 ; AE20  metatiles $20-$2F
        .byte   $29,$31,$F3,$F0,$65,$67,$56,$7D,$1D,$1F,$57,$00,$11,$11,$11,$11 ; AE30  metatiles $30-$3F
        .byte   $57,$05,$58,$56,$56,$56,$56,$57,$69,$45,$45,$77,$75,$77,$31,$45 ; AE40  metatiles $40-$4F
        .byte   $63,$61,$23,$61,$45,$07,$17,$57,$43,$41,$03,$41,$57,$27,$14,$47 ; AE50  metatiles $50-$5F
        .byte   $4C,$4E,$4B,$4B,$09,$0A,$0F,$00,$6C,$6E,$6B,$6B,$29,$2A,$2F,$00 ; AE60  metatiles $60-$6F
        .byte   $47,$49,$46,$46,$0C,$0E,$2C,$2E,$46,$00,$35,$00,$58,$6A,$00,$57 ; AE70  metatiles $70-$7F
        .byte   $69,$41,$43,$41,$03,$00,$00,$00,$00,$00,$81,$00,$8D,$00,$00,$00 ; AE80  metatiles $80-$8F
        .byte   $00,$83,$85,$00,$89,$8B,$00,$00,$A1,$A3,$A5,$A7,$A9,$AB,$AD,$00 ; AE90  metatiles $90-$9F
        .byte   $01,$03,$05,$07,$09,$0B,$0D,$BE,$21,$23,$25,$27,$29,$2B,$2D,$BE ; AEA0  metatiles $A0-$AF
        .byte   $41,$43,$45,$47,$49,$4B,$4D,$4F,$81,$83,$85,$87,$89,$8B,$8D,$8F ; AEB0  metatiles $B0-$BF
        .byte   $A1,$A3,$A5,$A7,$A9,$AB,$AD,$AF,$C1,$C3,$C5,$C7,$C9,$CB,$CD,$00 ; AEC0  metatiles $C0-$CF
        .byte   $C1,$63,$65,$67,$69,$6B,$6D,$00,$E1,$E3,$E5,$E7,$E9,$EB,$ED,$00 ; AED0  metatiles $D0-$DF
        .byte   $A9,$AB,$AD,$AF,$CD,$CF,$EB,$EB,$C9,$CB,$CD,$CF,$ED,$EF,$E9,$F9 ; AEE0  metatiles $E0-$EF
        .byte   $E9,$EB,$ED,$EF,$D9,$DB,$8D,$8F,$F2,$00,$F1,$E0,$CD,$CF,$AD,$AF ; AEF0  metatiles $F0-$FF
; --- $AF00: metatile top-right tile ids ---
        .byte   $00,$0C,$0C,$1E,$14,$16,$18,$1A,$00,$00,$4C,$4E,$34,$36,$38,$3A ; AF00  metatiles $00-$0F
        .byte   $32,$7E,$3C,$3E,$9C,$9E,$58,$5A,$32,$00,$5C,$5E,$BC,$BE,$78,$7A ; AF10  metatiles $10-$1F
        .byte   $50,$90,$B0,$E5,$B0,$48,$00,$00,$E0,$E2,$E4,$B1,$70,$72,$7E,$11 ; AF20  metatiles $20-$2F
        .byte   $60,$62,$F2,$00,$74,$76,$11,$7E,$0E,$6E,$11,$F0,$11,$54,$56,$58 ; AF30  metatiles $30-$3F
        .byte   $54,$04,$44,$20,$64,$66,$64,$44,$78,$44,$54,$56,$56,$56,$56,$58 ; AF40  metatiles $40-$4F
        .byte   $72,$70,$72,$32,$54,$16,$36,$58,$52,$50,$52,$12,$44,$26,$4A,$15 ; AF50  metatiles $50-$5F
        .byte   $5B,$5D,$5F,$5B,$18,$19,$1F,$24,$7B,$7D,$7F,$7B,$38,$39,$3F,$24 ; AF60  metatiles $60-$6F
        .byte   $46,$48,$4A,$46,$1B,$1D,$3B,$3D,$59,$46,$48,$4A,$54,$7A,$46,$58 ; AF70  metatiles $70-$7F
        .byte   $81,$83,$85,$87,$85,$00,$7E,$00,$00,$00,$90,$92,$00,$9E,$8F,$00 ; AF80  metatiles $80-$8F
        .byte   $00,$00,$94,$96,$98,$9A,$9C,$00,$00,$B2,$B4,$B6,$B8,$BA,$BC,$BE ; AF90  metatiles $90-$9F
        .byte   $10,$12,$14,$16,$18,$1A,$1C,$1E,$30,$32,$34,$36,$38,$3A,$3C,$CE ; AFA0  metatiles $A0-$AF
        .byte   $50,$52,$54,$56,$58,$5A,$5C,$DE,$90,$92,$94,$96,$98,$9A,$9C,$EE ; AFB0  metatiles $B0-$BF
        .byte   $B0,$B2,$B4,$B6,$B8,$BA,$BC,$FE,$D0,$D2,$D4,$D6,$D8,$DA,$DC,$00 ; AFC0  metatiles $C0-$CF
        .byte   $D0,$72,$74,$76,$78,$7A,$7C,$7E,$F0,$F2,$F4,$F6,$F8,$FA,$FC,$00 ; AFD0  metatiles $D0-$DF
        .byte   $B8,$BA,$BC,$BE,$DC,$DE,$FA,$FA,$D8,$DA,$DC,$DE,$FC,$FE,$F0,$00 ; AFE0  metatiles $E0-$EF
        .byte   $F8,$FA,$FC,$FE,$00,$F3,$9C,$9E,$00,$F3,$F0,$00,$C8,$CA,$BC,$BE ; AFF0  metatiles $F0-$FF
; --- $B000: metatile bottom-right tile ids ---
        .byte   $00,$0D,$0D,$1F,$15,$17,$19,$1B,$00,$7F,$4D,$4F,$35,$37,$39,$3B ; B000  metatiles $00-$0F
        .byte   $33,$12,$3D,$3F,$9D,$9F,$59,$5B,$51,$03,$5D,$5F,$BD,$BF,$79,$7B ; B010  metatiles $10-$1F
        .byte   $33,$00,$00,$E6,$1F,$B1,$00,$00,$E1,$E3,$E0,$47,$71,$73,$7F,$11 ; B020  metatiles $20-$2F
        .byte   $61,$63,$F3,$F0,$75,$77,$11,$7F,$0F,$6F,$11,$00,$11,$58,$56,$57 ; B030  metatiles $30-$3F
        .byte   $58,$05,$45,$67,$65,$67,$21,$45,$79,$45,$58,$56,$56,$56,$56,$57 ; B040  metatiles $40-$4F
        .byte   $73,$71,$33,$71,$57,$17,$37,$57,$53,$51,$13,$51,$45,$27,$14,$47 ; B050  metatiles $50-$5F
        .byte   $5C,$5E,$5B,$5B,$19,$1A,$1F,$25,$7C,$7E,$7B,$7B,$39,$3A,$3F,$24 ; B060  metatiles $60-$6F
        .byte   $47,$49,$46,$46,$1C,$1E,$3C,$3E,$5A,$47,$49,$46,$58,$7A,$46,$57 ; B070  metatiles $70-$7F
        .byte   $82,$84,$86,$84,$91,$03,$12,$7F,$00,$80,$91,$00,$9D,$9F,$00,$00 ; B080  metatiles $80-$8F
        .byte   $00,$93,$95,$97,$99,$9B,$00,$00,$B1,$B3,$B5,$B7,$B9,$BB,$BD,$00 ; B090  metatiles $90-$9F
        .byte   $11,$13,$15,$17,$19,$1B,$1D,$BF,$31,$33,$35,$37,$39,$3B,$3D,$CF ; B0A0  metatiles $A0-$AF
        .byte   $51,$53,$55,$57,$59,$5B,$5D,$DF,$91,$93,$95,$97,$99,$9B,$9D,$EF ; B0B0  metatiles $B0-$BF
        .byte   $B1,$B3,$B5,$B7,$B9,$BB,$BD,$FF,$D1,$D3,$D5,$D7,$D9,$DB,$DD,$00 ; B0C0  metatiles $C0-$CF
        .byte   $D1,$73,$75,$77,$79,$7B,$7D,$00,$F1,$F3,$F5,$F7,$F9,$FB,$FD,$00 ; B0D0  metatiles $D0-$DF
        .byte   $B9,$BB,$BD,$BF,$DD,$DF,$FB,$FB,$D9,$DB,$DD,$DF,$FD,$FF,$00,$F0 ; B0E0  metatiles $E0-$EF
        .byte   $F9,$FB,$FD,$FF,$F2,$00,$9D,$9F,$F2,$00,$00,$F0,$C9,$CB,$BD,$BF ; B0F0  metatiles $F0-$FF
; --- $B100: metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$40,$20,$F0,$10,$10,$11,$11,$10,$01,$03,$03,$10,$10,$61,$61 ; B100  metatiles $00-$0F
        .byte   $12,$01,$03,$03,$12,$12,$61,$61,$12,$03,$03,$03,$12,$12,$11,$11 ; B110  metatiles $10-$1F
        .byte   $12,$10,$10,$10,$10,$01,$01,$01,$10,$10,$10,$01,$12,$12,$01,$61 ; B120  metatiles $20-$2F
        .byte   $61,$61,$10,$10,$12,$12,$61,$01,$61,$61,$61,$10,$61,$61,$61,$61 ; B130  metatiles $30-$3F
        .byte   $12,$02,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12 ; B140  metatiles $40-$4F
        .byte   $12,$12,$12,$12,$12,$01,$01,$12,$12,$12,$12,$12,$12,$03,$01,$01 ; B150  metatiles $50-$5F
        .byte   $01,$01,$01,$01,$10,$10,$10,$01,$01,$01,$01,$01,$10,$10,$10,$01 ; B160  metatiles $60-$6F
        .byte   $01,$01,$01,$01,$10,$10,$10,$10,$01,$01,$01,$01,$10,$10,$01,$10 ; B170  metatiles $70-$7F
        .byte   $12,$12,$12,$12,$12,$03,$01,$01,$00,$03,$02,$02,$02,$02,$03,$00 ; B180  metatiles $80-$8F
        .byte   $00,$02,$02,$02,$02,$02,$02,$00,$01,$01,$01,$01,$01,$01,$01,$01 ; B190  metatiles $90-$9F
        .byte   $02,$02,$02,$02,$02,$02,$02,$01,$02,$02,$02,$02,$01,$01,$01,$01 ; B1A0  metatiles $A0-$AF
        .byte   $02,$02,$02,$02,$01,$01,$01,$02,$02,$02,$02,$03,$03,$03,$03,$02 ; B1B0  metatiles $B0-$BF
        .byte   $00,$02,$02,$03,$03,$01,$01,$02,$00,$02,$02,$01,$01,$01,$01,$00 ; B1C0  metatiles $C0-$CF
        .byte   $00,$03,$03,$03,$03,$03,$03,$03,$00,$01,$01,$01,$01,$01,$01,$00 ; B1D0  metatiles $D0-$DF
        .byte   $02,$02,$02,$02,$10,$10,$F0,$F0,$01,$02,$02,$01,$10,$10,$10,$10 ; B1E0  metatiles $E0-$EF
        .byte   $01,$01,$01,$01,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10 ; B1F0  metatiles $F0-$FF
; --- $B200: 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $00,$00,$00,$00,$00,$08,$00,$08,$08,$08,$08,$08,$00,$00,$08,$08 ; B200  blocks $00-$03
        .byte   $2C,$2D,$34,$35,$04,$05,$20,$10,$04,$05,$0C,$0D,$04,$05,$10,$18 ; B210  blocks $04-$07
        .byte   $2C,$2D,$2C,$2D,$2E,$2E,$37,$37,$2E,$86,$37,$11,$85,$87,$19,$09 ; B220  blocks $08-$0B
        .byte   $37,$37,$37,$37,$37,$11,$37,$11,$19,$09,$19,$09,$10,$10,$0C,$0D ; B230  blocks $0C-$0F
        .byte   $14,$15,$1C,$1D,$04,$05,$2E,$2E,$04,$05,$2E,$86,$10,$18,$00,$27 ; B240  blocks $10-$13
        .byte   $34,$35,$06,$07,$20,$10,$0C,$0D,$0E,$0F,$16,$17,$10,$18,$10,$18 ; B250  blocks $14-$17
        .byte   $1E,$1F,$34,$35,$20,$10,$20,$10,$18,$34,$0D,$06,$35,$20,$07,$26 ; B260  blocks $18-$1B
        .byte   $2C,$2D,$0A,$0B,$10,$10,$00,$0A,$10,$10,$0B,$00,$18,$34,$27,$06 ; B270  blocks $1C-$1F
        .byte   $35,$20,$07,$0C,$05,$0E,$0D,$16,$0F,$00,$17,$00,$12,$13,$1A,$1B ; B280  blocks $20-$23
        .byte   $00,$12,$00,$1A,$13,$00,$1B,$00,$00,$0E,$00,$16,$0F,$04,$17,$0C ; B290  blocks $24-$27
        .byte   $18,$1E,$0D,$06,$1F,$20,$07,$26,$01,$0B,$02,$13,$18,$20,$27,$06 ; B2A0  blocks $28-$2B
        .byte   $18,$20,$07,$26,$0A,$01,$12,$02,$18,$1E,$27,$06,$1F,$20,$07,$0C ; B2B0  blocks $2C-$2F
        .byte   $02,$1B,$02,$0B,$1A,$02,$0A,$02,$02,$13,$02,$1B,$12,$02,$1A,$02 ; B2C0  blocks $30-$33
        .byte   $02,$0B,$02,$13,$0A,$02,$12,$02,$18,$1E,$18,$34,$1F,$20,$35,$20 ; B2D0  blocks $34-$37
        .byte   $04,$2C,$18,$34,$2D,$05,$35,$20,$E5,$E4,$ED,$EC,$E5,$00,$ED,$E6 ; B2E0  blocks $38-$3B
        .byte   $00,$E4,$E7,$EC,$F5,$F4,$F9,$F8,$F5,$EE,$F9,$3B,$EF,$F4,$33,$F8 ; B2F0  blocks $3C-$3F
        .byte   $50,$51,$4C,$4D,$52,$48,$4E,$4F,$48,$53,$4A,$4B,$5C,$79,$49,$70 ; B300  blocks $40-$43
        .byte   $7A,$7B,$71,$72,$7E,$79,$73,$70,$48,$60,$49,$68,$61,$62,$69,$6A ; B310  blocks $44-$47
        .byte   $63,$60,$6B,$68,$48,$70,$49,$70,$71,$5E,$71,$5E,$55,$5F,$56,$5F ; B320  blocks $48-$4B
        .byte   $71,$72,$71,$72,$73,$70,$78,$70,$48,$70,$54,$70,$73,$70,$73,$70 ; B330  blocks $4C-$4F
        .byte   $44,$45,$58,$59,$46,$47,$5A,$48,$42,$43,$48,$5B,$50,$51,$58,$59 ; B340  blocks $50-$53
        .byte   $52,$48,$58,$49,$48,$53,$49,$5B,$7E,$79,$78,$70,$7A,$49,$71,$49 ; B350  blocks $54-$57
        .byte   $61,$48,$69,$48,$71,$48,$71,$49,$44,$46,$58,$5A,$47,$60,$49,$68 ; B360  blocks $58-$5B
        .byte   $50,$52,$58,$5A,$71,$49,$71,$49,$50,$52,$4C,$4E,$49,$60,$4F,$68 ; B370  blocks $5C-$5F
        .byte   $61,$48,$69,$49,$7E,$70,$73,$70,$7C,$7D,$7E,$79,$74,$75,$7A,$7B ; B380  blocks $60-$63
        .byte   $7D,$7D,$7E,$79,$7D,$7F,$7A,$7B,$71,$72,$71,$5E,$73,$70,$55,$5F ; B390  blocks $64-$67
        .byte   $5D,$5F,$56,$5F,$66,$66,$76,$77,$64,$65,$6C,$6D,$66,$66,$74,$75 ; B3A0  blocks $68-$6B
        .byte   $66,$66,$6E,$6E,$6E,$6E,$6E,$6E,$6C,$6D,$6C,$6D,$74,$75,$6E,$6E ; B3B0  blocks $6C-$6F
        .byte   $49,$53,$48,$5B,$52,$48,$5A,$54,$48,$53,$54,$5B,$52,$F6,$5A,$FE ; B3C0  blocks $70-$73
        .byte   $F7,$53,$FF,$5B,$49,$53,$4A,$4B,$52,$5C,$4E,$4F,$5C,$53,$49,$5B ; B3D0  blocks $74-$77
        .byte   $4A,$4F,$7A,$7B,$4A,$4B,$6F,$67,$4D,$4E,$7A,$41,$71,$41,$71,$41 ; B3E0  blocks $78-$7B
        .byte   $48,$48,$54,$54,$53,$51,$5B,$59,$52,$49,$5A,$48,$F6,$F7,$FE,$FF ; B3F0  blocks $7C-$7F
        .byte   $5C,$5C,$48,$48,$52,$5C,$5A,$48,$5C,$53,$48,$5B,$52,$48,$5A,$49 ; B400  blocks $80-$83
        .byte   $57,$40,$7E,$79,$4B,$4C,$7A,$7B,$4E,$57,$7E,$79,$40,$4B,$7A,$7B ; B410  blocks $84-$87
        .byte   $4D,$4E,$7E,$79,$57,$40,$7A,$7B,$4B,$4C,$7E,$79,$4E,$4F,$7A,$41 ; B420  blocks $88-$8B
        .byte   $00,$7B,$00,$72,$00,$5E,$00,$5E,$55,$5F,$5D,$5F,$00,$5E,$00,$72 ; B430  blocks $8C-$8F
        .byte   $56,$5F,$73,$70,$71,$5E,$71,$72,$00,$62,$00,$6A,$00,$72,$00,$72 ; B440  blocks $90-$93
        .byte   $4A,$4B,$25,$7B,$4C,$4D,$7E,$2B,$4E,$4F,$7A,$7B,$2F,$36,$3C,$3C ; B450  blocks $94-$97
        .byte   $36,$3A,$3C,$3C,$3D,$3E,$7A,$7B,$3E,$3F,$7E,$79,$64,$21,$6C,$22 ; B460  blocks $98-$9B
        .byte   $6C,$24,$6C,$22,$F9,$F8,$F9,$F8,$F9,$3B,$F9,$3B,$33,$F8,$33,$F8 ; B470  blocks $9C-$9F
        .byte   $00,$89,$90,$91,$8A,$8B,$92,$93,$8C,$8D,$94,$95,$8E,$00,$96,$97 ; B480  blocks $A0-$A3
        .byte   $98,$99,$00,$00,$9A,$9B,$00,$00,$9C,$9D,$00,$00,$9E,$9F,$00,$00 ; B490  blocks $A4-$A7
        .byte   $00,$00,$00,$A7,$00,$00,$AF,$B7,$00,$00,$BF,$C7,$A0,$A1,$A8,$A9 ; B4A0  blocks $A8-$AB
        .byte   $A2,$A3,$AA,$AB,$A4,$A5,$AC,$AD,$A6,$00,$AE,$00,$B0,$B1,$B8,$B9 ; B4B0  blocks $AC-$AF
        .byte   $B2,$B3,$BA,$BB,$B4,$B5,$BC,$BD,$B6,$00,$BE,$00,$00,$C1,$00,$C9 ; B4C0  blocks $B0-$B3
        .byte   $C2,$C3,$CA,$CB,$C4,$C5,$CC,$CD,$C6,$00,$CE,$00,$00,$D1,$00,$D9 ; B4D0  blocks $B4-$B7
        .byte   $D2,$D3,$DA,$DB,$D4,$D5,$DC,$DD,$D6,$D7,$DE,$DF,$00,$00,$E0,$E1 ; B4E0  blocks $B8-$BB
        .byte   $00,$00,$E2,$E3,$E8,$E9,$F0,$F1,$EA,$EB,$F2,$F3,$00,$87,$19,$09 ; B4F0  blocks $BC-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B500  blocks $C0-$C3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B510  blocks $C4-$C7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B520  blocks $C8-$CB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B530  blocks $CC-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B540  blocks $D0-$D3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B550  blocks $D4-$D7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B560  blocks $D8-$DB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B570  blocks $DC-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B580  blocks $E0-$E3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B590  blocks $E4-$E7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5A0  blocks $E8-$EB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5B0  blocks $EC-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5C0  blocks $F0-$F3
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5D0  blocks $F4-$F7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5E0  blocks $F8-$FB
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5F0  blocks $FC-$FF
; --- $B600: screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$01 ; B600
        .byte   $00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$01 ; B610
        .byte   $00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00 ; B620
        .byte   $02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02,$02 ; B630
; layout $01
        .byte   $00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$01 ; B640
        .byte   $00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$01 ; B650
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$02,$02,$02,$02,$02,$02 ; B660
        .byte   $02,$02,$02,$02,$02,$03,$03,$03,$02,$02,$02,$02,$02,$02,$02,$02 ; B670
; layout $02
        .byte   $04,$05,$06,$06,$06,$06,$07,$04,$08,$09,$0A,$0B,$0A,$0B,$09,$08 ; B680
        .byte   $08,$0C,$0D,$0E,$0D,$0E,$0C,$08,$08,$06,$0D,$0E,$0D,$0E,$07,$04 ; B690
        .byte   $04,$05,$0D,$0E,$0D,$0E,$09,$09,$08,$06,$0D,$0E,$0D,$0E,$0C,$0C ; B6A0
        .byte   $04,$05,$07,$04,$05,$04,$05,$07,$08,$06,$06,$08,$06,$08,$06,$06 ; B6B0
; layout $03
        .byte   $05,$07,$04,$05,$06,$06,$06,$06,$06,$0A,$0B,$0A,$0B,$09,$09,$0A ; B6C0
        .byte   $06,$0D,$0E,$0D,$0E,$0C,$0C,$0D,$05,$0D,$0E,$0D,$0E,$0C,$0C,$0D ; B6D0
        .byte   $09,$0D,$0E,$0D,$0E,$0C,$0C,$0D,$0C,$0D,$0E,$0D,$0E,$0C,$0C,$0D ; B6E0
        .byte   $05,$07,$04,$05,$06,$06,$06,$06,$06,$06,$08,$06,$06,$06,$06,$06 ; B6F0
; layout $04
        .byte   $06,$06,$0F,$06,$0F,$07,$04,$05,$0B,$09,$06,$06,$06,$06,$08,$06 ; B700
        .byte   $0E,$0C,$06,$06,$06,$07,$04,$05,$0E,$0C,$06,$06,$06,$10,$08,$06 ; B710
        .byte   $0E,$0C,$11,$11,$12,$13,$14,$15,$0E,$0C,$0C,$0C,$0D,$00,$16,$06 ; B720
        .byte   $06,$06,$06,$06,$06,$17,$18,$19,$06,$06,$06,$06,$06,$06,$08,$06 ; B730
; layout $05
        .byte   $1A,$1B,$1C,$1D,$1E,$1C,$1F,$20,$21,$22,$23,$24,$25,$23,$26,$27 ; B740
        .byte   $28,$29,$2A,$2B,$2C,$2D,$2E,$2F,$21,$22,$30,$26,$22,$31,$26,$27 ; B750
        .byte   $28,$29,$32,$2E,$29,$33,$2E,$2F,$21,$22,$34,$26,$22,$35,$26,$27 ; B760
        .byte   $36,$37,$06,$36,$37,$06,$36,$37,$38,$39,$06,$38,$39,$06,$38,$39 ; B770
; layout $06
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B780
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B790
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B7A0
        .byte   $3A,$3A,$3A,$3B,$3C,$3A,$3A,$3A,$3D,$3D,$3D,$3E,$3F,$3D,$3D,$3D ; B7B0
; layout $07
        .byte   $40,$40,$40,$41,$42,$40,$40,$40,$43,$44,$45,$44,$45,$44,$45,$44 ; B7C0
        .byte   $46,$47,$48,$47,$48,$47,$48,$47,$49,$4A,$4B,$4C,$4D,$4C,$4D,$4A ; B7D0
        .byte   $46,$47,$48,$47,$48,$47,$48,$47,$4E,$4A,$4B,$4A,$4B,$4C,$4F,$4A ; B7E0
        .byte   $50,$50,$50,$51,$52,$50,$50,$50,$53,$53,$53,$54,$55,$53,$53,$53 ; B7F0
; layout $08
        .byte   $40,$40,$40,$40,$40,$40,$40,$40,$45,$44,$45,$44,$56,$44,$56,$57 ; B800
        .byte   $48,$47,$48,$47,$48,$47,$48,$58,$4B,$4C,$4F,$4C,$4D,$4C,$4D,$59 ; B810
        .byte   $48,$47,$48,$47,$48,$47,$48,$58,$4B,$4A,$4B,$4C,$4F,$4C,$4D,$59 ; B820
        .byte   $50,$50,$50,$50,$50,$5A,$5B,$58,$53,$53,$53,$53,$53,$5C,$49,$5D ; B830
; layout $09
        .byte   $40,$40,$40,$40,$40,$5E,$5F,$60,$45,$44,$45,$44,$45,$44,$61,$59 ; B840
        .byte   $48,$47,$48,$47,$48,$47,$48,$60,$4D,$4C,$4D,$4C,$62,$63,$64,$65 ; B850
        .byte   $48,$47,$48,$47,$48,$47,$48,$47,$4F,$66,$67,$66,$67,$4C,$4F,$4C ; B860
        .byte   $4F,$4A,$68,$4A,$68,$4C,$4F,$4C,$4F,$4C,$4F,$4C,$4F,$4C,$4F,$4C ; B870
; layout $0A
        .byte   $48,$47,$48,$47,$48,$47,$48,$47,$67,$66,$67,$66,$67,$66,$67,$4C ; B880
        .byte   $68,$4A,$68,$4A,$68,$4A,$68,$4C,$4D,$4C,$4D,$4C,$4D,$4C,$4D,$4C ; B890
        .byte   $48,$47,$48,$47,$48,$47,$48,$47,$67,$4C,$4F,$66,$67,$4C,$4F,$4C ; B8A0
        .byte   $68,$4C,$4F,$4A,$68,$4C,$4F,$4C,$4F,$4C,$4F,$4C,$4F,$4C,$4F,$4C ; B8B0
; layout $0B
        .byte   $48,$47,$48,$47,$48,$47,$48,$47,$4F,$66,$67,$66,$67,$4C,$4F,$66 ; B8C0
        .byte   $4F,$4A,$68,$4A,$68,$4C,$4F,$4A,$4F,$4C,$4F,$4C,$4F,$4C,$4F,$4C ; B8D0
        .byte   $48,$47,$48,$47,$48,$47,$48,$47,$4F,$4C,$4F,$4C,$4F,$4C,$4F,$4C ; B8E0
        .byte   $69,$6A,$69,$6B,$6B,$69,$6A,$6C,$6D,$6E,$6F,$6F,$6D,$6D,$6E,$6F ; B8F0
; layout $0C
        .byte   $48,$47,$48,$70,$53,$71,$72,$5C,$67,$4C,$4F,$55,$53,$73,$74,$5C ; B900
        .byte   $68,$4C,$4F,$75,$40,$76,$77,$5C,$4F,$4C,$4F,$44,$45,$78,$55,$5C ; B910
        .byte   $48,$47,$48,$47,$48,$47,$79,$7A,$4F,$4C,$4F,$4C,$4F,$4C,$4F,$7B ; B920
        .byte   $6B,$69,$6C,$6A,$6B,$6C,$69,$6C,$6F,$6F,$6F,$6E,$6F,$6F,$6D,$6F ; B930
; layout $0D
        .byte   $7C,$7D,$71,$72,$5C,$7C,$7D,$7E,$7F,$7D,$73,$74,$5C,$7F,$7D,$7E ; B940
        .byte   $80,$7D,$81,$82,$5C,$80,$7D,$83,$7F,$7D,$73,$74,$5C,$7F,$7D,$83 ; B950
        .byte   $84,$85,$86,$87,$88,$89,$8A,$8B,$4F,$4C,$4F,$4C,$4F,$4C,$4F,$7B ; B960
        .byte   $6A,$6C,$6B,$69,$6C,$6A,$6C,$6C,$6E,$6D,$6F,$6F,$6F,$6E,$6D,$6D ; B970
; layout $0E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B980
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B990
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B9A0
        .byte   $6C,$6C,$6C,$6C,$6C,$6C,$6C,$6C,$6D,$6D,$6D,$6D,$6D,$6D,$6D,$6D ; B9B0
; layout $0F
        .byte   $00,$42,$40,$41,$42,$40,$40,$40,$00,$8C,$45,$44,$45,$44,$45,$44 ; B9C0
        .byte   $00,$8D,$8E,$4A,$8E,$4A,$8E,$4A,$00,$8F,$90,$91,$90,$91,$90,$91 ; B9D0
        .byte   $00,$92,$48,$47,$48,$47,$48,$47,$00,$93,$4F,$4C,$4F,$4C,$4F,$4C ; B9E0
        .byte   $6C,$6C,$6B,$6B,$6C,$6A,$6B,$6B,$6D,$6F,$6D,$6D,$6D,$6E,$6D,$6F ; B9F0
; layout $10
        .byte   $40,$40,$40,$41,$42,$40,$40,$41,$45,$44,$45,$44,$45,$44,$45,$44 ; BA00
        .byte   $8E,$4A,$8E,$4A,$8E,$4C,$4F,$4A,$90,$91,$90,$91,$90,$4C,$4F,$91 ; BA10
        .byte   $48,$47,$48,$47,$48,$47,$48,$47,$4F,$4C,$4F,$4C,$4F,$4C,$4F,$4C ; BA20
        .byte   $69,$6C,$6A,$6C,$6C,$6C,$6C,$6A,$6F,$6F,$6E,$6D,$6D,$6D,$6D,$6E ; BA30
; layout $11
        .byte   $42,$40,$40,$40,$41,$70,$53,$7E,$45,$44,$45,$44,$45,$94,$95,$96 ; BA40
        .byte   $8E,$4A,$8E,$4A,$8E,$97,$98,$4C,$90,$91,$90,$91,$90,$99,$9A,$4C ; BA50
        .byte   $48,$47,$48,$47,$48,$47,$48,$47,$4F,$4C,$4F,$4C,$4F,$4C,$4F,$4C ; BA60
        .byte   $6B,$6B,$69,$6C,$9B,$4C,$4F,$4C,$6D,$6D,$6D,$6F,$9C,$6C,$6B,$6B ; BA70
; layout $12
        .byte   $70,$53,$53,$53,$7E,$70,$53,$7E,$70,$53,$53,$53,$7E,$70,$53,$7E ; BA80
        .byte   $70,$53,$53,$53,$7E,$70,$53,$7E,$70,$53,$53,$53,$7E,$70,$53,$7E ; BA90
        .byte   $70,$53,$53,$53,$7E,$70,$53,$7E,$70,$53,$53,$53,$7E,$70,$53,$7E ; BAA0
        .byte   $70,$53,$53,$53,$7E,$70,$53,$7E,$70,$53,$53,$53,$7E,$70,$53,$7E ; BAB0
; layout $13
        .byte   $9D,$9D,$9D,$9E,$9F,$9D,$9D,$9D,$9D,$9D,$9D,$9E,$9F,$9D,$9D,$9D ; BAC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BAD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BAE0
        .byte   $00,$00,$A0,$A1,$A2,$A3,$00,$00,$00,$00,$A4,$A5,$A6,$A7,$00,$00 ; BAF0
; layout $14
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$A8,$A9,$AA,$00 ; BB00
        .byte   $00,$00,$00,$00,$AB,$AC,$AD,$AE,$00,$00,$00,$00,$AF,$B0,$B1,$B2 ; BB10
        .byte   $00,$00,$00,$00,$B3,$B4,$B5,$B6,$00,$00,$00,$00,$B7,$B8,$B9,$BA ; BB20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BB30
; layout $15
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BB40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BB50
        .byte   $00,$00,$00,$BB,$BC,$00,$00,$00,$00,$00,$00,$BD,$BE,$00,$00,$00 ; BB60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BB70
; layout $16
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BB80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BB90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BBA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BBB0
; layout $17
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BBC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BBD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BBE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BBF0
; layout $18
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC30
; layout $19
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC70
; layout $1A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BC90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BCA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BCB0
; layout $1B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BCC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BCD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BCE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BCF0
; layout $1C
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BD00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BD10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BD20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BD30
; layout $1D
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BD40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BD50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BD60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BD70
; layout $1E
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BD80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BD90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BDA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BDB0
; layout $1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BDC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BDD0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BDE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BDF0
; layout $20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE30
; layout $21
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE70
; layout $22
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BE90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BEA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BEB0
; layout $23
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BEC0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BED0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BEE0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BEF0
; layout $24
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF20
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF30
; layout $25
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF40
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF50
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF60
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF70
; layout $26
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF80
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BF90
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BFA0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BFB0
; layout $27
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BFC0
        .byte   $00                             ; BFD0
LBFD1:  .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BFD1
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BFE1
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BFF1
