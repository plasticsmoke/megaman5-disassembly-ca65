.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK17"

; =============================================================================
; BANK $17 (mapped at $8000) — TITLE SCREEN / MENUS / CASTLE MAPS
;
; The whole between-stages game flow: copyright + title screen (with the
; bank $0C:A000 story intro as attract mode), stage select, password
; entry/decode/display, death & game-over checkpoint handling, weapon-get,
; and the Proto/Wily castle map interludes (including the post-Proto-4
; escape cutscene). Entered at $8000 from the fixed-bank boot/respawn
; task ($DE15 maps the $17/$0C pair); returns with $26 = stage to load.
; Screens are drawn via LDAFC/LDB23 from the menu pseudo-stage ($26=$10,
; whose layout data lives in PRG bank $10).
;
; Code: $8000-$8B73 (menus) and $91C9-$9821 (castle maps/cutscene).
; Data: $8B74-$91C8 (menu tables) and $9822-$9FFF (castle map tables).
; =============================================================================
L0000           := $0000
L0004           := $0004
L0027           := $0027
L0040           := $0040
L0200           := $0200
L0206           := $0206
L0207           := $0207
L0208           := $0208
L0209           := $0209
L020A           := $020A
L020B           := $020B
L020C           := $020C
L0211           := $0211
L0300           := $0300
L0409           := $0409
L0418           := $0418
L0513           := $0513
L0605           := $0605
L0616           := $0616
L0730           := $0730
L0A16           := $0A16
L0A29           := $0A29
L0F07           := $0F07
L0F0F           := $0F0F
L0F11           := $0F11
L0F14           := $0F14
L0F15           := $0F15
L0F16           := $0F16
L0F1A           := $0F1A
L0F26           := $0F26
L0F28           := $0F28
L0F29           := $0F29
L0F2C           := $0F2C
L0F36           := $0F36
L0F37           := $0F37
L1004           := $1004
L1121           := $1121
L1229           := $1229
L122C           := $122C
L1321           := $1321
L1621           := $1621
L1625           := $1625
L1626           := $1626
L1627           := $1627
L1726           := $1726
L1727           := $1727
L1A2A           := $1A2A
L1C2C           := $1C2C
L2000           := $2000
L2020           := $2020
L202C           := $202C
L2041           := $2041
L2049           := $2049
L204D           := $204D
L2176           := $2176
L2232           := $2232
L2284           := $2284
L2320           := $2320
L2400           := $2400
L2438           := $2438
L2621           := $2621
L269F           := $269F
L26B7           := $26B7
L2E44           := $2E44
L3931           := $3931
L3C3C           := $3C3C
L4148           := $4148
L414C           := $414C
L414D           := $414D
L414E           := $414E
L4157           := $4157
L4320           := $4320
L4349           := $4349
L4420           := $4420
L4454           := $4454
L454A           := $454A
L4843           := $4843
L4854           := $4854
L494E           := $494E
L4C50           := $4C50
L4E41           := $4E41
L4F44           := $4F44
L4F46           := $4F46
L4F47           := $4F47
L4F4E           := $4F4E
L4F50           := $4F50
L4F57           := $4F57
L4F59           := $4F59
L5041           := $5041
L50FE           := $50FE
L5241           := $5241
L5243           := $5243
L5245           := $5245
L5246           := $5246
L5247           := $5247
L5349           := $5349
L5408           := $5408
L5441           := $5441
L5453           := $5453
L5845           := $5845
L5942           := $5942
L5945           := $5945
L5947           := $5947
L594D           := $594D
LA000           := $A000
LCA9F           := $CA9F
LD216           := $D216
LDAFC           := $DAFC
LDB23           := $DB23
LF391           := $F391
LFF20           := $FF20
LFF24           := $FF24
; ----------------------------------------------------------------------------
; =============================================================================
; GAME FLOW HUB — $17:8000 (called by the orchestrator task per cycle)
; Dispatches on player state $30: $07 death -> game-over/continue
; ($859C); $10 boss defeated -> stage clear ($8860; clears the $0100
; no-respawn bitmap + furthest-screen $69); $23 -> ending via bank
; $0E:A000; otherwise title/menu/stage-select flow using pseudo-stage
; bank $10 for its screens.
; =============================================================================
L8000:  lda     #$00                            ; 8000 A9 00                    ..
        sta     $95                             ; 8002 85 95                    ..
        lda     $30                             ; 8004 A5 30                    .0
        cmp     #$07                            ; 8006 C9 07                    ..
        beq     L801C                           ; 8008 F0 12                    ..
        cmp     #$10                            ; 800A C9 10                    ..
        beq     L801F                           ; 800C F0 11                    ..
        cmp     #$23                            ; 800E C9 23                    .#
        bne     L8029                           ; 8010 D0 17                    ..
        lda     #$0E                            ; 8012 A9 0E                    ..
L8014:  sta     $F6                             ; 8014 85 F6                    ..
        jsr     bank_load_shadow                           ; 8016 20 43 FF                  C.
        jmp     LA000                           ; 8019 4C 00 A0                 L..

; ----------------------------------------------------------------------------
L801C:  jmp     L859C                           ; 801C 4C 9C 85                 L..

; ----------------------------------------------------------------------------
L801F:  lda     #$00                            ; 801F A9 00                    ..
        sta     $69                             ; 8021 85 69                    .i
        jsr     no_respawn_clear                           ; 8023 20 65 F4                  e.
        jmp     L8860                           ; 8026 4C 60 88                 L`.

; ----------------------------------------------------------------------------
; --- L8029: TITLE SCREEN. Draw the two title nametables (menu pseudo-stage
; screens $01/$00), palette set $4C, logo alone for $96 frames, then loop:
; play the bank $0C story intro (attract, Start skippable), come back,
; show the GAME START / PASSWORD menu for $05A0 frames, repeat on timeout.
L8029:  lda     #$F0                            ; 8029 A9 F0                    ..
        jsr     queue_sound_param                           ; 802B 20 5B EC                  [.
        jsr     L91C9                           ; 802E 20 C9 91                  ..
        jsr     palette_fade_out                           ; 8031 20 F1 C3                  ..
        jsr     entity_clear_all                           ; 8034 20 9D C3                  ..
        jsr     oam_clear                           ; 8037 20 8F C3                  ..
        jsr     scroll_irq_reset                           ; 803A 20 B8 C3                  ..
        jsr     frame_wait                           ; 803D 20 22 FF                  ".
        jsr     disable_rendering                           ; 8040 20 D1 C2                  ..
        jsr     stage_state_init                           ; 8043 20 F2 F3                  ..
        lda     #$01                            ; 8046 A9 01                    ..
        jsr     set_mirroring                           ; 8048 20 B7 FF                  ..
        lda     #$10                            ; 804B A9 10                    ..
        sta     L0027                           ; 804D 85 27                    .'
        sta     $26                             ; 804F 85 26                    .&
        lda     #$08                            ; 8051 A9 08                    ..
        sta     $10                             ; 8053 85 10                    ..
        lda     #$01                            ; 8055 A9 01                    ..
        sta     $23                             ; 8057 85 23                    .#
        jsr     LDAFC                           ; 8059 20 FC DA                  ..
        dec     L0027                           ; 805C C6 27                    .'
        lda     #$00                            ; 805E A9 00                    ..
        sta     $10                             ; 8060 85 10                    ..
        lda     #$00                            ; 8062 A9 00                    ..
        sta     $23                             ; 8064 85 23                    .#
        jsr     LDAFC                           ; 8066 20 FC DA                  ..
        ldy     #$4C                            ; 8069 A0 4C                    .L
        jsr     L89FC                           ; 806B 20 FC 89                  ..
        lda     #$02                            ; 806E A9 02                    ..
        sta     $FD                             ; 8070 85 FD                    ..
        jsr     enable_rendering                           ; 8072 20 DB C2                  ..
        jsr     palette_fade_in                           ; 8075 20 EB C3                  ..
        lda     #$96                            ; 8078 A9 96                    ..
        jsr     LFF24                           ; 807A 20 24 FF                  $.
; --- L807D: attract loop point — story intro, then menu sprites (L8C96
; block $00), title music ($49), $05A0-frame menu timeout in $10/$11.
L807D:  jsr     LA000                           ; 807D 20 00 A0                  ..
        ldy     #$00                            ; 8080 A0 00                    ..
        jsr     L89FC                           ; 8082 20 FC 89                  ..
        ldy     #$00                            ; 8085 A0 00                    ..
        lda     #$10                            ; 8087 A9 10                    ..
        jsr     L8A29                           ; 8089 20 29 8A                  ).
        lda     #$49                            ; 808C A9 49                    .I
        jsr     queue_sound_param                           ; 808E 20 5B EC                  [.
        lda     #$00                            ; 8091 A9 00                    ..
        sta     $FD                             ; 8093 85 FD                    ..
        lda     #$A0                            ; 8095 A9 A0                    ..
        sta     $10                             ; 8097 85 10                    ..
        lda     #$05                            ; 8099 A9 05                    ..
        sta     $11                             ; 809B 85 11                    ..
        jsr     palette_fade_in                           ; 809D 20 EB C3                  ..
; --- L80A0: title menu input. Start/A = confirm; Select/Up/Down = toggle
; cursor ($0200 sprite Y ^= $10: $A7 GAME START / $B7 PASSWORD).
L80A0:  jsr     frame_wait                           ; 80A0 20 22 FF                  ".
        jsr     read_controllers                           ; 80A3 20 E5 C2                  ..
        lda     $14                             ; 80A6 A5 14                    ..
        and     #$90                            ; 80A8 29 90                    ).
        bne     L80D2                           ; 80AA D0 26                    .&
        lda     $14                             ; 80AC A5 14                    ..
        and     #$2C                            ; 80AE 29 2C                    ),
        beq     L80BF                           ; 80B0 F0 0D                    ..
        lda     #$27                            ; 80B2 A9 27                    .'
        jsr     queue_sound                           ; 80B4 20 5D EC                  ].
        lda     L0200                           ; 80B7 AD 00 02                 ...
        eor     #$10                            ; 80BA 49 10                    I.
        sta     L0200                           ; 80BC 8D 00 02                 ...
L80BF:  lda     $10                             ; 80BF A5 10                    ..
        sec                                     ; 80C1 38                       8
        sbc     #$01                            ; 80C2 E9 01                    ..
        sta     $10                             ; 80C4 85 10                    ..
        lda     $11                             ; 80C6 A5 11                    ..
        sbc     #$00                            ; 80C8 E9 00                    ..
        sta     $11                             ; 80CA 85 11                    ..
        ora     $10                             ; 80CC 05 10                    ..
        bne     L80A0                           ; 80CE D0 D0                    ..
        beq     L807D                           ; 80D0 F0 AB                    ..
L80D2:  lda     #$28                            ; 80D2 A9 28                    .(
        jsr     queue_sound                           ; 80D4 20 5D EC                  ].
        lda     L0200                           ; 80D7 AD 00 02                 ...
        cmp     #$A7                            ; 80DA C9 A7                    ..
        beq     L80E1                           ; 80DC F0 03                    ..
        jmp     L83BA                           ; 80DE 4C BA 83                 L..

; ----------------------------------------------------------------------------
; --- L80E1: STAGE SELECT. Draw grid screens ($23=$02 top / $04 bottom),
; palette set $26, mugshot sprites (L8C96 block $10), blank already-beaten
; portraits (L8A94), reveal the center castle door if all 8 beaten (L8AF1),
; stage select music ($0D). Cursor: $10 = column, $11 = row (0-2 each).
L80E1:  jsr     palette_fade_out                           ; 80E1 20 F1 C3                  ..
        jsr     entity_clear_all                           ; 80E4 20 9D C3                  ..
        jsr     oam_clear                           ; 80E7 20 8F C3                  ..
        jsr     scroll_irq_reset                           ; 80EA 20 B8 C3                  ..
        jsr     stage_state_init                           ; 80ED 20 F2 F3                  ..
        jsr     frame_wait                           ; 80F0 20 22 FF                  ".
        jsr     disable_rendering                           ; 80F3 20 D1 C2                  ..
        lda     #$10                            ; 80F6 A9 10                    ..
        sta     $26                             ; 80F8 85 26                    .&
        lda     #$0F                            ; 80FA A9 0F                    ..
        sta     L0027                           ; 80FC 85 27                    .'
        lda     #$00                            ; 80FE A9 00                    ..
        sta     $10                             ; 8100 85 10                    ..
        lda     #$02                            ; 8102 A9 02                    ..
        sta     $23                             ; 8104 85 23                    .#
        jsr     LDAFC                           ; 8106 20 FC DA                  ..
        lda     #$08                            ; 8109 A9 08                    ..
        sta     $10                             ; 810B 85 10                    ..
        lda     #$04                            ; 810D A9 04                    ..
        sta     $23                             ; 810F 85 23                    .#
        jsr     LDAFC                           ; 8111 20 FC DA                  ..
        ldy     #$26                            ; 8114 A0 26                    .&
        jsr     L89FC                           ; 8116 20 FC 89                  ..
        ldy     #$10                            ; 8119 A0 10                    ..
        lda     #$E4                            ; 811B A9 E4                    ..
        jsr     L8A29                           ; 811D 20 29 8A                  ).
        jsr     L8A94                           ; 8120 20 94 8A                  ..
        jsr     enable_rendering                           ; 8123 20 DB C2                  ..
        jsr     frame_wait                           ; 8126 20 22 FF                  ".
        jsr     palette_fade_in                           ; 8129 20 EB C3                  ..
        lda     #$0D                            ; 812C A9 0D                    ..
        jsr     queue_sound_param                           ; 812E 20 5B EC                  [.
        jsr     L8AF1                           ; 8131 20 F1 8A                  ..
        lda     #$01                            ; 8134 A9 01                    ..
        sta     $10                             ; 8136 85 10                    ..
        sta     $11                             ; 8138 85 11                    ..
        lda     #$00                            ; 813A A9 00                    ..
        sta     $14                             ; 813C 85 14                    ..
        sta     $9D                             ; 813E 85 9D                    ..
; --- L8140: stage select input loop. D-pad moves cursor with wraparound
; (L8D90 step / L8D92 wrap); 8-sprite cursor frame rebuilt from L8D8A/L8D8D
; pixel origins + L8D94/L8D9C offsets, blinking on $9D bit 3.
L8140:  lda     $14                             ; 8140 A5 14                    ..
        and     #$90                            ; 8142 29 90                    ).
        beq     L8149                           ; 8144 F0 03                    ..
        jmp     L81CD                           ; 8146 4C CD 81                 L..

; ----------------------------------------------------------------------------
L8149:  lda     $14                             ; 8149 A5 14                    ..
        and     #$0F                            ; 814B 29 0F                    ).
        beq     L818A                           ; 814D F0 3B                    .;
        and     #$03                            ; 814F 29 03                    ).
        beq     L8168                           ; 8151 F0 15                    ..
        and     #$01                            ; 8153 29 01                    ).
        tay                                     ; 8155 A8                       .
        lda     $11                             ; 8156 A5 11                    ..
        clc                                     ; 8158 18                       .
        adc     L8D90,y                         ; 8159 79 90 8D                 y..
        sta     $11                             ; 815C 85 11                    ..
        cmp     #$03                            ; 815E C9 03                    ..
        bcc     L8168                           ; 8160 90 06                    ..
        clc                                     ; 8162 18                       .
        adc     L8D92,y                         ; 8163 79 92 8D                 y..
        sta     $11                             ; 8166 85 11                    ..
L8168:  lda     $14                             ; 8168 A5 14                    ..
        and     #$0C                            ; 816A 29 0C                    ).
        beq     L8185                           ; 816C F0 17                    ..
        and     #$04                            ; 816E 29 04                    ).
        lsr     a                               ; 8170 4A                       J
        lsr     a                               ; 8171 4A                       J
        tay                                     ; 8172 A8                       .
        lda     $10                             ; 8173 A5 10                    ..
        clc                                     ; 8175 18                       .
        adc     L8D90,y                         ; 8176 79 90 8D                 y..
        sta     $10                             ; 8179 85 10                    ..
        cmp     #$03                            ; 817B C9 03                    ..
        bcc     L8185                           ; 817D 90 06                    ..
        clc                                     ; 817F 18                       .
        adc     L8D92,y                         ; 8180 79 92 8D                 y..
        sta     $10                             ; 8183 85 10                    ..
L8185:  lda     #$27                            ; 8185 A9 27                    .'
        jsr     queue_sound                           ; 8187 20 5D EC                  ].
L818A:  ldy     $10                             ; 818A A4 10                    ..
        lda     L8D8A,y                         ; 818C B9 8A 8D                 ...
        sta     L0000                           ; 818F 85 00                    ..
        ldy     $11                             ; 8191 A4 11                    ..
        lda     L8D8D,y                         ; 8193 B9 8D 8D                 ...
        sta     $01                             ; 8196 85 01                    ..
        ldy     #$00                            ; 8198 A0 00                    ..
        ldx     #$00                            ; 819A A2 00                    ..
L819C:  lda     L0000                           ; 819C A5 00                    ..
        clc                                     ; 819E 18                       .
        adc     L8D94,y                         ; 819F 79 94 8D                 y..
        sta     L0200,x                         ; 81A2 9D 00 02                 ...
        lda     $01                             ; 81A5 A5 01                    ..
        clc                                     ; 81A7 18                       .
        adc     L8D9C,y                         ; 81A8 79 9C 8D                 y..
        sta     $0203,x                         ; 81AB 9D 03 02                 ...
        lda     $9D                             ; 81AE A5 9D                    ..
        and     #$08                            ; 81B0 29 08                    ).
        beq     L81B9                           ; 81B2 F0 05                    ..
        lda     #$F8                            ; 81B4 A9 F8                    ..
        sta     L0200,x                         ; 81B6 9D 00 02                 ...
L81B9:  inx                                     ; 81B9 E8                       .
        inx                                     ; 81BA E8                       .
        inx                                     ; 81BB E8                       .
        inx                                     ; 81BC E8                       .
        iny                                     ; 81BD C8                       .
        cpy     #$08                            ; 81BE C0 08                    ..
        bne     L819C                           ; 81C0 D0 DA                    ..
L81C2:  inc     $9D                             ; 81C2 E6 9D                    ..
        jsr     frame_wait                           ; 81C4 20 22 FF                  ".
        jsr     read_controllers                           ; 81C7 20 E5 C2                  ..
        jmp     L8140                           ; 81CA 4C 40 81                 L@.

; ----------------------------------------------------------------------------
; --- L81CD: confirm — grid index = $10*3 + $11, stage id from L8DA4 into
; $26/$6C. Center entry ($08 = Proto castle 1, shown as Wily's castle)
; is refused unless all 8 bosses are beaten ($6E == $FF).
L81CD:  lda     $10                             ; 81CD A5 10                    ..
        asl     a                               ; 81CF 0A                       .
        adc     $10                             ; 81D0 65 10                    e.
        adc     $11                             ; 81D2 65 11                    e.
        sta     $12                             ; 81D4 85 12                    ..
        tay                                     ; 81D6 A8                       .
        lda     L8DA4,y                         ; 81D7 B9 A4 8D                 ...
        sta     $26                             ; 81DA 85 26                    .&
        sta     $6C                             ; 81DC 85 6C                    .l
        cmp     #$08                            ; 81DE C9 08                    ..
        bne     L81F0                           ; 81E0 D0 0E                    ..
        lda     $6E                             ; 81E2 A5 6E                    .n
        cmp     #$FF                            ; 81E4 C9 FF                    ..
        bne     L81C2                           ; 81E6 D0 DA                    ..
        lda     #$28                            ; 81E8 A9 28                    .(
        jsr     queue_sound                           ; 81EA 20 5D EC                  ].
        jmp     L9272                           ; 81ED 4C 72 92                 Lr.

; ----------------------------------------------------------------------------
; --- L81F0: stage picked: flash the screen 8 times (BG palette ^= $3F),
; then wipe the grid palette columns dark left-to-right (L8C8A delay /
; L8C90 threshold), leaving only the picked mugshot lit (L8B2E enlarges
; it). If this boss is already beaten ($F2B2 stage mask & $6E) return to
; the caller — the fixed-bank task proceeds straight to stage_load.
L81F0:  lda     #$28                            ; 81F0 A9 28                    .(
        jsr     queue_sound                           ; 81F2 20 5D EC                  ].
        ldx     #$08                            ; 81F5 A2 08                    ..
L81F7:  lda     $0610                           ; 81F7 AD 10 06                 ...
        eor     #$3F                            ; 81FA 49 3F                    I?
        sta     $0610                           ; 81FC 8D 10 06                 ...
        lda     #$FF                            ; 81FF A9 FF                    ..
        sta     $18                             ; 8201 85 18                    ..
        lda     #$08                            ; 8203 A9 08                    ..
        jsr     LFF24                           ; 8205 20 24 FF                  $.
        dex                                     ; 8208 CA                       .
        bne     L81F7                           ; 8209 D0 EC                    ..
        lda     #$0F                            ; 820B A9 0F                    ..
        ldy     #$0B                            ; 820D A0 0B                    ..
L820F:  sta     $0604,y                         ; 820F 99 04 06                 ...
        dey                                     ; 8212 88                       .
        bpl     L820F                           ; 8213 10 FA                    ..
        tay                                     ; 8215 A8                       .
L8216:  lda     L8C42,y                         ; 8216 B9 42 8C                 .B.
        sta     $0630,y                         ; 8219 99 30 06                 .0.
        dey                                     ; 821C 88                       .
        bpl     L8216                           ; 821D 10 F7                    ..
        jsr     oam_clear                           ; 821F 20 8F C3                  ..
        jsr     L8B2E                           ; 8222 20 2E 8B                  ..
        ldx     #$05                            ; 8225 A2 05                    ..
L8227:  lda     L8C8A,x                         ; 8227 BD 8A 8C                 ...
        sta     $EA                             ; 822A 85 EA                    ..
        ldy     #$03                            ; 822C A0 03                    ..
L822E:  lda     $0620,y                         ; 822E B9 20 06                 . .
        sec                                     ; 8231 38                       8
        sbc     L8C90,x                         ; 8232 FD 90 8C                 ...
        bcs     L8239                           ; 8235 B0 02                    ..
        lda     #$0F                            ; 8237 A9 0F                    ..
L8239:  sta     $0600,y                         ; 8239 99 00 06                 ...
        dey                                     ; 823C 88                       .
        bpl     L822E                           ; 823D 10 EF                    ..
        sty     $18                             ; 823F 84 18                    ..
        lda     #$08                            ; 8241 A9 08                    ..
        jsr     LFF24                           ; 8243 20 24 FF                  $.
        dex                                     ; 8246 CA                       .
        bpl     L8227                           ; 8247 10 DE                    ..
        ldy     #$1F                            ; 8249 A0 1F                    ..
        lda     #$0F                            ; 824B A9 0F                    ..
L824D:  sta     $0600,y                         ; 824D 99 00 06                 ...
        sta     $0620,y                         ; 8250 99 20 06                 . .
        dey                                     ; 8253 88                       .
        bpl     L824D                           ; 8254 10 F7                    ..
        sty     $18                             ; 8256 84 18                    ..
        jsr     frame_wait                           ; 8258 20 22 FF                  ".
        ldy     $6C                             ; 825B A4 6C                    .l
        lda     $F2B2,y                         ; 825D B9 B2 F2                 ...
        and     $6E                             ; 8260 25 6E                    %n
        beq     L8265                           ; 8262 F0 01                    ..
        rts                                     ; 8264 60                       `

; ----------------------------------------------------------------------------
; --- L8265: first visit: boss intro screen ($23=$03) over the starfield
; (L8A3A/L8A4A), boss teleports in as menu-actor type $6D sub L8DB3
; (falls until anim phase $06), strikes his pose (phase strobe from L8DC3,
; done at phase L8DBB; Charge Man's intro, sub $20, adds a companion
; actor sub $21 at Y=$48 — his steam burst — and waits it out), then his
; name is typed one letter per 8 frames from L8DD0 (+$26*16) into the
; $0780 nametable buffer. $B4 frames, rts.
L8265:  jsr     disable_rendering                           ; 8265 20 D1 C2                  ..
        lda     #$00                            ; 8268 A9 00                    ..
        sta     $10                             ; 826A 85 10                    ..
        lda     #$03                            ; 826C A9 03                    ..
        sta     $23                             ; 826E 85 23                    .#
        jsr     LDAFC                           ; 8270 20 FC DA                  ..
        jsr     frame_wait                           ; 8273 20 22 FF                  ".
        jsr     enable_rendering                           ; 8276 20 DB C2                  ..
        lda     #$0E                            ; 8279 A9 0E                    ..
        jsr     queue_sound_param                           ; 827B 20 5B EC                  [.
        ldy     #$1F                            ; 827E A0 1F                    ..
L8280:  lda     L8C32,y                         ; 8280 B9 32 8C                 .2.
        sta     $0620,y                         ; 8283 99 20 06                 . .
        dey                                     ; 8286 88                       .
        bpl     L8280                           ; 8287 10 F7                    ..
        ldx     #$01                            ; 8289 A2 01                    ..
L828B:  lda     #$6D                            ; 828B A9 6D                    .m
        sta     L0300,x                         ; 828D 9D 00 03                 ...
        lda     #$00                            ; 8290 A9 00                    ..
        sta     $0348,x                         ; 8292 9D 48 03                 .H.
        sta     $0390,x                         ; 8295 9D 90 03                 ...
        sta     $0528,x                         ; 8298 9D 28 05                 .(.
        lda     L8E50,x                         ; 829B BD 50 8E                 .P.
        jsr     entity_set_subtype                           ; 829E 20 98 EA                  ..
        lda     #$68                            ; 82A1 A9 68                    .h
        sta     $0378,x                         ; 82A3 9D 78 03                 .x.
        lda     #$80                            ; 82A6 A9 80                    ..
        sta     $0330,x                         ; 82A8 9D 30 03                 .0.
        dex                                     ; 82AB CA                       .
        bpl     L828B                           ; 82AC 10 DD                    ..
        lda     #$C8                            ; 82AE A9 C8                    ..
        sta     $EA                             ; 82B0 85 EA                    ..
        lda     #$CA                            ; 82B2 A9 CA                    ..
        sta     $EB                             ; 82B4 85 EB                    ..
        lda     #$57                            ; 82B6 A9 57                    .W
        sta     $FA                             ; 82B8 85 FA                    ..
        lda     #$CE                            ; 82BA A9 CE                    ..
        sta     $9B                             ; 82BC 85 9B                    ..
        lda     #$06                            ; 82BE A9 06                    ..
        sta     $99                             ; 82C0 85 99                    ..
        lda     #$96                            ; 82C2 A9 96                    ..
        sta     $05F1                           ; 82C4 8D F1 05                 ...
        lda     #$00                            ; 82C7 A9 00                    ..
        sta     $05F9                           ; 82C9 8D F9 05                 ...
        sta     $05F5                           ; 82CC 8D F5 05                 ...
        jsr     palette_fade_in                           ; 82CF 20 EB C3                  ..
L82D2:  inc     $95                             ; 82D2 E6 95                    ..
        dec     $FA                             ; 82D4 C6 FA                    ..
        dec     $FA                             ; 82D6 C6 FA                    ..
        dec     $FA                             ; 82D8 C6 FA                    ..
        dec     $9B                             ; 82DA C6 9B                    ..
        dec     $9B                             ; 82DC C6 9B                    ..
        dec     $9B                             ; 82DE C6 9B                    ..
        dec     $95                             ; 82E0 C6 95                    ..
        jsr     frame_wait                           ; 82E2 20 22 FF                  ".
        lda     $FA                             ; 82E5 A5 FA                    ..
        bne     L82D2                           ; 82E7 D0 E9                    ..
        jsr     L8A3A                           ; 82E9 20 3A 8A                  :.
L82EC:  jsr     L8A4A                           ; 82EC 20 4A 8A                  J.
        lda     $0540                           ; 82EF AD 40 05                 .@.
        cmp     #$06                            ; 82F2 C9 06                    ..
        bne     L82EC                           ; 82F4 D0 F6                    ..
        ldx     #$00                            ; 82F6 A2 00                    ..
        stx     $9D                             ; 82F8 86 9D                    ..
        ldy     $6C                             ; 82FA A4 6C                    .l
        lda     L8DB3,y                         ; 82FC B9 B3 8D                 ...
        jsr     entity_set_subtype                           ; 82FF 20 98 EA                  ..
        lda     #$00                            ; 8302 A9 00                    ..
        sta     $0301                           ; 8304 8D 01 03                 ...
        ldy     #$0E                            ; 8307 A0 0E                    ..
        lda     #$36                            ; 8309 A9 36                    .6
L830B:  sta     $0611,y                         ; 830B 99 11 06                 ...
        dey                                     ; 830E 88                       .
        bpl     L830B                           ; 830F 10 FA                    ..
        sty     $18                             ; 8311 84 18                    ..
L8313:  lda     #$00                            ; 8313 A9 00                    ..
        sta     $0570                           ; 8315 8D 70 05                 .p.
        jsr     L8A4A                           ; 8318 20 4A 8A                  J.
        lda     $9D                             ; 831B A5 9D                    ..
        lsr     a                               ; 831D 4A                       J
        and     #$07                            ; 831E 29 07                    ).
        tay                                     ; 8320 A8                       .
        lda     $0528                           ; 8321 AD 28 05                 .(.
        and     #$FB                            ; 8324 29 FB                    ).
        ora     L8DC3,y                         ; 8326 19 C3 8D                 ...
        sta     $0528                           ; 8329 8D 28 05                 .(.
        cpy     #$07                            ; 832C C0 07                    ..
        bne     L8313                           ; 832E D0 E3                    ..
        lda     $6C                             ; 8330 A5 6C                    .l
        asl     a                               ; 8332 0A                       .
        asl     a                               ; 8333 0A                       .
        asl     a                               ; 8334 0A                       .
        tay                                     ; 8335 A8                       .
        ldx     #$00                            ; 8336 A2 00                    ..
L8338:  lda     L8C42,x                         ; 8338 BD 42 8C                 .B.
        sta     $0610,x                         ; 833B 9D 10 06                 ...
        lda     L8C4A,y                         ; 833E B9 4A 8C                 .J.
        sta     $0618,x                         ; 8341 9D 18 06                 ...
        sta     $0638,x                         ; 8344 9D 38 06                 .8.
        iny                                     ; 8347 C8                       .
        inx                                     ; 8348 E8                       .
        cpx     #$08                            ; 8349 E0 08                    ..
        bne     L8338                           ; 834B D0 EB                    ..
        lda     #$FF                            ; 834D A9 FF                    ..
        sta     $18                             ; 834F 85 18                    ..
L8351:  jsr     L8A4A                           ; 8351 20 4A 8A                  J.
        ldy     $6C                             ; 8354 A4 6C                    .l
        lda     $0540                           ; 8356 AD 40 05                 .@.
        cmp     L8DBB,y                         ; 8359 D9 BB 8D                 ...
        bne     L8351                           ; 835C D0 F3                    ..
        lda     $0558                           ; 835E AD 58 05                 .X.
        cmp     #$20                            ; 8361 C9 20                    . 
        bne     L8385                           ; 8363 D0 20                    . 
        ldx     #$00                            ; 8365 A2 00                    ..
        ldy     #$01                            ; 8367 A0 01                    ..
        lda     #$21                            ; 8369 A9 21                    .!
        jsr     entity_init_pos                           ; 836B 20 A4 EA                  ..
        lda     #$6D                            ; 836E A9 6D                    .m
        sta     $0301                           ; 8370 8D 01 03                 ...
        lda     #$48                            ; 8373 A9 48                    .H
        sta     $0379                           ; 8375 8D 79 03                 .y.
L8378:  lda     #$00                            ; 8378 A9 00                    ..
        sta     $0570                           ; 837A 8D 70 05                 .p.
        jsr     L8A4A                           ; 837D 20 4A 8A                  J.
        lda     $0301                           ; 8380 AD 01 03                 ...
        bne     L8378                           ; 8383 D0 F3                    ..
L8385:  ldy     #$04                            ; 8385 A0 04                    ..
L8387:  lda     L8DCB,y                         ; 8387 B9 CB 8D                 ...
        sta     $0780,y                         ; 838A 99 80 07                 ...
        dey                                     ; 838D 88                       .
        bpl     L8387                           ; 838E 10 F7                    ..
        lda     $26                             ; 8390 A5 26                    .&
        asl     a                               ; 8392 0A                       .
        asl     a                               ; 8393 0A                       .
        asl     a                               ; 8394 0A                       .
        asl     a                               ; 8395 0A                       .
        tay                                     ; 8396 A8                       .
L8397:  lda     L8DD0,y                         ; 8397 B9 D0 8D                 ...
        cmp     #$20                            ; 839A C9 20                    . 
        beq     L83AA                           ; 839C F0 0C                    ..
        sta     $0783                           ; 839E 8D 83 07                 ...
        lda     #$FF                            ; 83A1 A9 FF                    ..
        sta     $19                             ; 83A3 85 19                    ..
        lda     #$08                            ; 83A5 A9 08                    ..
        jsr     L8A7D                           ; 83A7 20 7D 8A                  }.
L83AA:  iny                                     ; 83AA C8                       .
        inc     $0781                           ; 83AB EE 81 07                 ...
        lda     $0781                           ; 83AE AD 81 07                 ...
        cmp     #$17                            ; 83B1 C9 17                    ..
        bne     L8397                           ; 83B3 D0 E2                    ..
        lda     #$B4                            ; 83B5 A9 B4                    ..
        jmp     L8A7D                           ; 83B7 4C 7D 8A                 L}.

; ----------------------------------------------------------------------------
; --- L83BA: PASSWORD ENTRY screen. Common setup L866A, 4-sprite cursor
; from L9024, password music ($13). Top-level cursor $10: 0 = red dot,
; 1 = gray dot, 2 = END.
L83BA:  jsr     L866A                           ; 83BA 20 6A 86                  j.
        ldy     #$0F                            ; 83BD A0 0F                    ..
L83BF:  lda     L9024,y                         ; 83BF B9 24 90                 .$.
        sta     L0200,y                         ; 83C2 99 00 02                 ...
        dey                                     ; 83C5 88                       .
        bpl     L83BF                           ; 83C6 10 F7                    ..
        lda     #$13                            ; 83C8 A9 13                    ..
        jsr     queue_sound_param                           ; 83CA 20 5B EC                  [.
        jsr     palette_fade_in                           ; 83CD 20 EB C3                  ..
L83D0:  lda     #$00                            ; 83D0 A9 00                    ..
        sta     $10                             ; 83D2 85 10                    ..
        beq     L840F                           ; 83D4 F0 39                    .9
; --- L83D6: password top-row input: left/right toggles red/gray dot,
; up/down jumps to END ($10 ^= 2), Start/A on END validates (L86AB),
; on a dot color enters the grid (L8441).
L83D6:  lda     $14                             ; 83D6 A5 14                    ..
        and     #$90                            ; 83D8 29 90                    ).
        beq     L83E5                           ; 83DA F0 09                    ..
        lda     $10                             ; 83DC A5 10                    ..
        cmp     #$02                            ; 83DE C9 02                    ..
        bcc     L8441                           ; 83E0 90 5F                    ._
        jmp     L86AB                           ; 83E2 4C AB 86                 L..

; ----------------------------------------------------------------------------
L83E5:  lda     $14                             ; 83E5 A5 14                    ..
        and     #$0C                            ; 83E7 29 0C                    ).
        beq     L83F8                           ; 83E9 F0 0D                    ..
        lda     $10                             ; 83EB A5 10                    ..
        eor     #$02                            ; 83ED 49 02                    I.
        and     #$02                            ; 83EF 29 02                    ).
        sta     $10                             ; 83F1 85 10                    ..
        lda     #$27                            ; 83F3 A9 27                    .'
        jsr     queue_sound                           ; 83F5 20 5D EC                  ].
L83F8:  lda     $10                             ; 83F8 A5 10                    ..
        cmp     #$02                            ; 83FA C9 02                    ..
        bcs     L840F                           ; 83FC B0 11                    ..
        lda     $14                             ; 83FE A5 14                    ..
        and     #$03                            ; 8400 29 03                    ).
        beq     L840F                           ; 8402 F0 0B                    ..
        lda     $10                             ; 8404 A5 10                    ..
        eor     #$01                            ; 8406 49 01                    I.
        sta     $10                             ; 8408 85 10                    ..
        lda     #$27                            ; 840A A9 27                    .'
        jsr     queue_sound                           ; 840C 20 5D EC                  ].
L840F:  ldy     $10                             ; 840F A4 10                    ..
        lda     L9034,y                         ; 8411 B9 34 90                 .4.
        sta     L0000                           ; 8414 85 00                    ..
        lda     L9037,y                         ; 8416 B9 37 90                 .7.
        sta     $01                             ; 8419 85 01                    ..
        ldx     L903A,y                         ; 841B BE 3A 90                 .:.
        ldy     #$00                            ; 841E A0 00                    ..
L8420:  .byte   $BD                             ; 8420 BD                       .
L8421:  .byte   $3D                             ; 8421 3D                       =
L8422:  .byte   $90,$18                    ; 8422 90 18   (branch out of range for ca65: target has no local label)
        adc     L0000                           ; 8424 65 00                    e.
        sta     L0200,y                         ; 8426 99 00 02                 ...
        lda     L9045,x                         ; 8429 BD 45 90                 .E.
        clc                                     ; 842C 18                       .
        adc     $01                             ; 842D 65 01                    e.
        sta     $0203,y                         ; 842F 99 03 02                 ...
        inx                                     ; 8432 E8                       .
        iny                                     ; 8433 C8                       .
        iny                                     ; 8434 C8                       .
        iny                                     ; 8435 C8                       .
        iny                                     ; 8436 C8                       .
        cpy     #$10                            ; 8437 C0 10                    ..
        bne     L8420                           ; 8439 D0 E5                    ..
        jsr     L851E                           ; 843B 20 1E 85                  ..
        jmp     L83D6                           ; 843E 4C D6 83                 L..

; ----------------------------------------------------------------------------
L8441:  lda     #$00                            ; 8441 A9 00                    ..
        sta     $12                             ; 8443 85 12                    ..
        sta     $13                             ; 8445 85 13                    ..
        jmp     L84EB                           ; 8447 4C EB 84                 L..

; ----------------------------------------------------------------------------
; --- L844A: password grid input. B = back to dot select; Start = jump
; to END; A = place dot of the current color (L906F/L9071 tiles) at cell
; $12/$13, or erase it if the same color is already there (16 dot sprites
; live at $0210+); d-pad moves in the 6x6 grid (A-F rows, 1-6 cols).
L844A:  lda     $14                             ; 844A A5 14                    ..
        and     #$40                            ; 844C 29 40                    )@
        bne     L83D0                           ; 844E D0 80                    ..
        lda     $14                             ; 8450 A5 14                    ..
        and     #$10                            ; 8452 29 10                    ).
        beq     L845C                           ; 8454 F0 06                    ..
        lda     #$02                            ; 8456 A9 02                    ..
        sta     $10                             ; 8458 85 10                    ..
        bne     L840F                           ; 845A D0 B3                    ..
L845C:  lda     $14                             ; 845C A5 14                    ..
        and     #$80                            ; 845E 29 80                    ).
        beq     L84AD                           ; 8460 F0 4B                    .K
        lda     $13                             ; 8462 A5 13                    ..
        asl     a                               ; 8464 0A                       .
        asl     a                               ; 8465 0A                       .
        sta     L0000                           ; 8466 85 00                    ..
        lda     $12                             ; 8468 A5 12                    ..
        asl     a                               ; 846A 0A                       .
        asl     a                               ; 846B 0A                       .
        asl     a                               ; 846C 0A                       .
        sta     $01                             ; 846D 85 01                    ..
        asl     a                               ; 846F 0A                       .
        adc     L0000                           ; 8470 65 00                    e.
        adc     $01                             ; 8472 65 01                    e.
        tay                                     ; 8474 A8                       .
        lda     $0210,y                         ; 8475 B9 10 02                 ...
        cmp     #$F8                            ; 8478 C9 F8                    ..
        beq     L848D                           ; 847A F0 11                    ..
        ldx     $10                             ; 847C A6 10                    ..
        lda     L906F,x                         ; 847E BD 6F 90                 .o.
        cmp     L0211,y                         ; 8481 D9 11 02                 ...
        bne     L848D                           ; 8484 D0 07                    ..
        lda     #$F8                            ; 8486 A9 F8                    ..
        sta     $0210,y                         ; 8488 99 10 02                 ...
        bne     L84EB                           ; 848B D0 5E                    .^
L848D:  ldx     $12                             ; 848D A6 12                    ..
        lda     L9063,x                         ; 848F BD 63 90                 .c.
        sta     $0210,y                         ; 8492 99 10 02                 ...
        ldx     $13                             ; 8495 A6 13                    ..
        lda     L9069,x                         ; 8497 BD 69 90                 .i.
        sta     $0213,y                         ; 849A 99 13 02                 ...
        ldx     $10                             ; 849D A6 10                    ..
        lda     L906F,x                         ; 849F BD 6F 90                 .o.
        sta     L0211,y                         ; 84A2 99 11 02                 ...
        lda     L9071,x                         ; 84A5 BD 71 90                 .q.
        sta     $0212,y                         ; 84A8 99 12 02                 ...
        bne     L84EB                           ; 84AB D0 3E                    .>
L84AD:  lda     $14                             ; 84AD A5 14                    ..
        and     #$03                            ; 84AF 29 03                    ).
        beq     L84CD                           ; 84B1 F0 1A                    ..
        and     #$02                            ; 84B3 29 02                    ).
        tay                                     ; 84B5 A8                       .
        lda     #$27                            ; 84B6 A9 27                    .'
        jsr     queue_sound                           ; 84B8 20 5D EC                  ].
        lda     $13                             ; 84BB A5 13                    ..
        clc                                     ; 84BD 18                       .
        adc     L9059,y                         ; 84BE 79 59 90                 yY.
        sta     $13                             ; 84C1 85 13                    ..
        cmp     #$06                            ; 84C3 C9 06                    ..
        bcc     L84CD                           ; 84C5 90 06                    ..
        clc                                     ; 84C7 18                       .
        adc     L905A,y                         ; 84C8 79 5A 90                 yZ.
        sta     $13                             ; 84CB 85 13                    ..
L84CD:  lda     $14                             ; 84CD A5 14                    ..
        and     #$0C                            ; 84CF 29 0C                    ).
        beq     L84EB                           ; 84D1 F0 18                    ..
        tay                                     ; 84D3 A8                       .
        lda     #$27                            ; 84D4 A9 27                    .'
        jsr     queue_sound                           ; 84D6 20 5D EC                  ].
        lda     $12                             ; 84D9 A5 12                    ..
        clc                                     ; 84DB 18                       .
        adc     L9059,y                         ; 84DC 79 59 90                 yY.
        sta     $12                             ; 84DF 85 12                    ..
        cmp     #$06                            ; 84E1 C9 06                    ..
        bcc     L84EB                           ; 84E3 90 06                    ..
        clc                                     ; 84E5 18                       .
        adc     L905A,y                         ; 84E6 79 5A 90                 yZ.
        sta     $12                             ; 84E9 85 12                    ..
L84EB:  ldx     $12                             ; 84EB A6 12                    ..
        lda     L904D,x                         ; 84ED BD 4D 90                 .M.
        sta     L0000                           ; 84F0 85 00                    ..
        ldx     $13                             ; 84F2 A6 13                    ..
        lda     L9053,x                         ; 84F4 BD 53 90                 .S.
        sta     $01                             ; 84F7 85 01                    ..
        ldx     #$00                            ; 84F9 A2 00                    ..
        ldy     #$00                            ; 84FB A0 00                    ..
L84FD:  lda     L903D,x                         ; 84FD BD 3D 90                 .=.
        clc                                     ; 8500 18                       .
        adc     L0000                           ; 8501 65 00                    e.
        sta     L0200,y                         ; 8503 99 00 02                 ...
        lda     L9045,x                         ; 8506 BD 45 90                 .E.
        clc                                     ; 8509 18                       .
        adc     $01                             ; 850A 65 01                    e.
        sta     $0203,y                         ; 850C 99 03 02                 ...
        inx                                     ; 850F E8                       .
        iny                                     ; 8510 C8                       .
        iny                                     ; 8511 C8                       .
        iny                                     ; 8512 C8                       .
        iny                                     ; 8513 C8                       .
        cpy     #$10                            ; 8514 C0 10                    ..
        bne     L84FD                           ; 8516 D0 E5                    ..
        jsr     L851E                           ; 8518 20 1E 85                  ..
        jmp     L844A                           ; 851B 4C 4A 84                 LJ.

; ----------------------------------------------------------------------------
; --- L851E: password frame tick: blink the 4 cursor sprites on $9D bit 3,
; frame_wait + read_controllers.
L851E:  lda     $9D                             ; 851E A5 9D                    ..
        inc     $9D                             ; 8520 E6 9D                    ..
        lsr     a                               ; 8522 4A                       J
        lsr     a                               ; 8523 4A                       J
        lsr     a                               ; 8524 4A                       J
        bcs     L8535                           ; 8525 B0 0E                    ..
        lda     #$F8                            ; 8527 A9 F8                    ..
        sta     L0200                           ; 8529 8D 00 02                 ...
        sta     $0204                           ; 852C 8D 04 02                 ...
        sta     L0208                           ; 852F 8D 08 02                 ...
        sta     L020C                           ; 8532 8D 0C 02                 ...
L8535:  jsr     frame_wait                           ; 8535 20 22 FF                  ".
        jmp     read_controllers                           ; 8538 4C E5 C2                 L..

; ----------------------------------------------------------------------------
; --- L853B: PASSWORD DISPLAY + prompt (after weapon-get): shows the
; password encoding $6E/$6D (L87B9) with prompt string 3, cursor picks
; STAGE SELECT ($0200=$AF -> L80E1) or CONTINUE ($BF -> return with
; $26 = $6C, straight back into the current stage path).
L853B:  jsr     L866A                           ; 853B 20 6A 86                  j.
        jsr     L87B9                           ; 853E 20 B9 87                  ..
        ldx     #$03                            ; 8541 A2 03                    ..
        jsr     L884A                           ; 8543 20 4A 88                  J.
        lda     #$13                            ; 8546 A9 13                    ..
        jsr     queue_sound_param                           ; 8548 20 5B EC                  [.
        lda     #$AF                            ; 854B A9 AF                    ..
        sta     L0200                           ; 854D 8D 00 02                 ...
        lda     #$8F                            ; 8550 A9 8F                    ..
        sta     $0201                           ; 8552 8D 01 02                 ...
        lda     #$01                            ; 8555 A9 01                    ..
        sta     $0202                           ; 8557 8D 02 02                 ...
        lda     #$48                            ; 855A A9 48                    .H
        sta     $0203                           ; 855C 8D 03 02                 ...
        jsr     palette_fade_in                           ; 855F 20 EB C3                  ..
L8562:  jsr     read_controllers                           ; 8562 20 E5 C2                  ..
        jsr     frame_wait                           ; 8565 20 22 FF                  ".
        lda     $14                             ; 8568 A5 14                    ..
        and     #$90                            ; 856A 29 90                    ).
        bne     L8583                           ; 856C D0 15                    ..
        lda     $14                             ; 856E A5 14                    ..
        and     #$0C                            ; 8570 29 0C                    ).
        beq     L8562                           ; 8572 F0 EE                    ..
        lda     #$27                            ; 8574 A9 27                    .'
        jsr     queue_sound                           ; 8576 20 5D EC                  ].
        lda     L0200                           ; 8579 AD 00 02                 ...
        eor     #$10                            ; 857C 49 10                    I.
        sta     L0200                           ; 857E 8D 00 02                 ...
        bne     L8562                           ; 8581 D0 DF                    ..
L8583:  lda     L0200                           ; 8583 AD 00 02                 ...
        cmp     #$AF                            ; 8586 C9 AF                    ..
        bne     L8590                           ; 8588 D0 06                    ..
        jsr     L865A                           ; 858A 20 5A 86                  Z.
        jmp     L80E1                           ; 858D 4C E1 80                 L..

; ----------------------------------------------------------------------------
L8590:  jsr     L865A                           ; 8590 20 5A 86                  Z.
        lda     #$00                            ; 8593 A9 00                    ..
        sta     $69                             ; 8595 85 69                    .i
L8597:  lda     $6C                             ; 8597 A5 6C                    .l
        sta     $26                             ; 8599 85 26                    .&
        rts                                     ; 859B 60                       `

; ----------------------------------------------------------------------------
; --- L859C: DEATH ($30=$07). With lives left ($BF): consume one and
; restore the furthest checkpoint from L9169 — two 3-byte records per
; stage (checkpoint screen, section, spawn latch); a record applies once
; furthest-screen $69 has reached its screen, which then becomes
; scroll_x_hi $F9 (+ $29/$68). Returns with $26=$6C to reload the stage.
L859C:  lda     $BF                             ; 859C A5 BF                    ..
        beq     L85E2                           ; 859E F0 42                    .B
        dec     $BF                             ; 85A0 C6 BF                    ..
        lda     #$00                            ; 85A2 A9 00                    ..
        sta     $F9                             ; 85A4 85 F9                    ..
        sta     $29                             ; 85A6 85 29                    .)
        sta     $68                             ; 85A8 85 68                    .h
        lda     $6C                             ; 85AA A5 6C                    .l
        asl     a                               ; 85AC 0A                       .
        sta     L0000                           ; 85AD 85 00                    ..
        asl     a                               ; 85AF 0A                       .
        adc     L0000                           ; 85B0 65 00                    e.
        tay                                     ; 85B2 A8                       .
        lda     $69                             ; 85B3 A5 69                    .i
        cmp     L9169,y                         ; 85B5 D9 69 91                 .i.
        bcc     L8597                           ; 85B8 90 DD                    ..
        lda     L9169,y                         ; 85BA B9 69 91                 .i.
        sta     $F9                             ; 85BD 85 F9                    ..
        lda     L916A,y                         ; 85BF B9 6A 91                 .j.
        sta     $29                             ; 85C2 85 29                    .)
        lda     L916B,y                         ; 85C4 B9 6B 91                 .k.
        sta     $68                             ; 85C7 85 68                    .h
        lda     $69                             ; 85C9 A5 69                    .i
        cmp     L916C,y                         ; 85CB D9 6C 91                 .l.
        bcc     L8597                           ; 85CE 90 C7                    ..
        lda     L916C,y                         ; 85D0 B9 6C 91                 .l.
        sta     $F9                             ; 85D3 85 F9                    ..
        lda     L916D,y                         ; 85D5 B9 6D 91                 .m.
        sta     $29                             ; 85D8 85 29                    .)
        lda     L916E,y                         ; 85DA B9 6E 91                 .n.
        sta     $68                             ; 85DD 85 68                    .h
        jmp     L8597                           ; 85DF 4C 97 85                 L..

; ----------------------------------------------------------------------------
; --- L85E2: GAME OVER (no lives): reset progress screen $69, lives back
; to 2, clear the killed-enemy bitmap, then show the password display
; (game over music $12, string 2 banner). After a wait or button: on a
; robot master stage offer STAGE SELECT/CONTINUE (string 3); in the
; castles ($6C >= 8) CONTINUE only (string 4, cursor forced to $B7).
L85E2:  lda     #$00                            ; 85E2 A9 00                    ..
        sta     $69                             ; 85E4 85 69                    .i
        lda     #$02                            ; 85E6 A9 02                    ..
        sta     $BF                             ; 85E8 85 BF                    ..
        jsr     no_respawn_clear                           ; 85EA 20 65 F4                  e.
        jsr     L866A                           ; 85ED 20 6A 86                  j.
        jsr     L87B9                           ; 85F0 20 B9 87                  ..
        ldx     #$02                            ; 85F3 A2 02                    ..
        stx     $BF                             ; 85F5 86 BF                    ..
        jsr     L884A                           ; 85F7 20 4A 88                  J.
        lda     #$12                            ; 85FA A9 12                    ..
        jsr     queue_sound_param                           ; 85FC 20 5B EC                  [.
        jsr     palette_fade_in                           ; 85FF 20 EB C3                  ..
        lda     #$00                            ; 8602 A9 00                    ..
        sta     $14                             ; 8604 85 14                    ..
        sta     $10                             ; 8606 85 10                    ..
        sta     $6B                             ; 8608 85 6B                    .k
L860A:  lda     $14                             ; 860A A5 14                    ..
        and     #$C0                            ; 860C 29 C0                    ).
        bne     L861A                           ; 860E D0 0A                    ..
        jsr     read_controllers                           ; 8610 20 E5 C2                  ..
        jsr     frame_wait                           ; 8613 20 22 FF                  ".
        dec     $10                             ; 8616 C6 10                    ..
        bne     L860A                           ; 8618 D0 F0                    ..
L861A:  lda     #$AF                            ; 861A A9 AF                    ..
        sta     L0200                           ; 861C 8D 00 02                 ...
        lda     #$8F                            ; 861F A9 8F                    ..
        sta     $0201                           ; 8621 8D 01 02                 ...
        lda     #$01                            ; 8624 A9 01                    ..
        sta     $0202                           ; 8626 8D 02 02                 ...
        lda     #$48                            ; 8629 A9 48                    .H
        sta     $0203                           ; 862B 8D 03 02                 ...
        lda     #$13                            ; 862E A9 13                    ..
        jsr     queue_sound_param                           ; 8630 20 5B EC                  [.
        lda     $6C                             ; 8633 A5 6C                    .l
        cmp     #$08                            ; 8635 C9 08                    ..
        bcs     L8641                           ; 8637 B0 08                    ..
        ldx     #$03                            ; 8639 A2 03                    ..
        jsr     L884A                           ; 863B 20 4A 88                  J.
        jmp     L8562                           ; 863E 4C 62 85                 Lb.

; ----------------------------------------------------------------------------
L8641:  ldx     #$04                            ; 8641 A2 04                    ..
        jsr     L884A                           ; 8643 20 4A 88                  J.
        lda     #$B7                            ; 8646 A9 B7                    ..
        sta     L0200                           ; 8648 8D 00 02                 ...
L864B:  jsr     read_controllers                           ; 864B 20 E5 C2                  ..
        jsr     frame_wait                           ; 864E 20 22 FF                  ".
        lda     $14                             ; 8651 A5 14                    ..
        and     #$90                            ; 8653 29 90                    ).
        beq     L864B                           ; 8655 F0 F4                    ..
        jmp     L8590                           ; 8657 4C 90 85                 L..

; ----------------------------------------------------------------------------
; --- L865A: refill all owned weapon energy: any $B0-$BC entry with bit 7
; set (owned) is topped up to $9C (owned + 28 units).
L865A:  ldy     #$0C                            ; 865A A0 0C                    ..
L865C:  lda     $B0,y                           ; 865C B9 B0 00                 ...
        bpl     L8666                           ; 865F 10 05                    ..
        lda     #$9C                            ; 8661 A9 9C                    ..
        sta     $B0,y                           ; 8663 99 B0 00                 ...
L8666:  dey                                     ; 8666 88                       .
        bpl     L865C                           ; 8667 10 F3                    ..
        rts                                     ; 8669 60                       `

; ----------------------------------------------------------------------------
; --- L866A: common menu screen setup: fade/clear/reset, mirroring, menu
; pseudo-stage $26=$10 (alt $27=$0F), draw screen $23=$01 (password grid
; backdrop), palette set $72, rendering back on.
L866A:  jsr     palette_fade_out                           ; 866A 20 F1 C3                  ..
        jsr     scroll_irq_reset                           ; 866D 20 B8 C3                  ..
        jsr     entity_clear_all                           ; 8670 20 9D C3                  ..
        jsr     oam_clear                           ; 8673 20 8F C3                  ..
        jsr     frame_wait                           ; 8676 20 22 FF                  ".
        jsr     disable_rendering                           ; 8679 20 D1 C2                  ..
        jsr     stage_state_init                           ; 867C 20 F2 F3                  ..
        lda     #$01                            ; 867F A9 01                    ..
        jsr     set_mirroring                           ; 8681 20 B7 FF                  ..
        lda     #$10                            ; 8684 A9 10                    ..
        sta     $26                             ; 8686 85 26                    .&
        lda     #$0F                            ; 8688 A9 0F                    ..
        sta     L0027                           ; 868A 85 27                    .'
        lda     #$00                            ; 868C A9 00                    ..
        sta     $10                             ; 868E 85 10                    ..
        sta     $05F0                           ; 8690 8D F0 05                 ...
        sta     $05F1                           ; 8693 8D F1 05                 ...
        sta     $05F2                           ; 8696 8D F2 05                 ...
        sta     $05F3                           ; 8699 8D F3 05                 ...
        lda     #$01                            ; 869C A9 01                    ..
        sta     $23                             ; 869E 85 23                    .#
        jsr     LDAFC                           ; 86A0 20 FC DA                  ..
        ldy     #$72                            ; 86A3 A0 72                    .r
        jsr     L89FC                           ; 86A5 20 FC 89                  ..
        jmp     enable_rendering                           ; 86A8 4C DB C2                 L..

; ----------------------------------------------------------------------------
; --- L86AB: PASSWORD VALIDATION. Count the 16 dot sprites: exactly 6
; visible, 3 of them red (tile $8B) and 3 gray ($8C) or fail. For each of
; the 3 red and 3 gray dot groups (base L90E0, group sizes L90E3), find
; the dot's cell in the group's cell list (L90E4 straight / L90FB shifted
; row) — the position encodes 3 bits; the three groups assemble into
; $6E (bosses beaten, red) and $6D (items, gray). Failure -> L878E.
L86AB:  ldy     #$10                            ; 86AB A0 10                    ..
        lda     #$00                            ; 86AD A9 00                    ..
        sta     L0000                           ; 86AF 85 00                    ..
        sta     $01                             ; 86B1 85 01                    ..
        sta     $02                             ; 86B3 85 02                    ..
L86B5:  lda     L0200,y                         ; 86B5 B9 00 02                 ...
        cmp     #$F8                            ; 86B8 C9 F8                    ..
        beq     L86CD                           ; 86BA F0 11                    ..
        inc     L0000                           ; 86BC E6 00                    ..
        lda     $0201,y                         ; 86BE B9 01 02                 ...
        cmp     #$8B                            ; 86C1 C9 8B                    ..
        beq     L86C9                           ; 86C3 F0 04                    ..
        inc     $02                             ; 86C5 E6 02                    ..
        bne     L86D2                           ; 86C7 D0 09                    ..
L86C9:  inc     $01                             ; 86C9 E6 01                    ..
        bne     L86D2                           ; 86CB D0 05                    ..
L86CD:  lda     #$00                            ; 86CD A9 00                    ..
        sta     $0201,y                         ; 86CF 99 01 02                 ...
L86D2:  iny                                     ; 86D2 C8                       .
        iny                                     ; 86D3 C8                       .
        iny                                     ; 86D4 C8                       .
        iny                                     ; 86D5 C8                       .
        bne     L86B5                           ; 86D6 D0 DD                    ..
        lda     L0000                           ; 86D8 A5 00                    ..
        cmp     #$06                            ; 86DA C9 06                    ..
        bne     L8728                           ; 86DC D0 4A                    .J
        lda     $01                             ; 86DE A5 01                    ..
        cmp     #$03                            ; 86E0 C9 03                    ..
        bne     L8728                           ; 86E2 D0 44                    .D
        ldy     #$02                            ; 86E4 A0 02                    ..
        sty     L0000                           ; 86E6 84 00                    ..
L86E8:  ldy     L0000                           ; 86E8 A4 00                    ..
        ldx     L90E0,y                         ; 86EA BE E0 90                 ...
        stx     $02                             ; 86ED 86 02                    ..
        lda     L90E3,x                         ; 86EF BD E3 90                 ...
        sta     $01                             ; 86F2 85 01                    ..
        sta     $03                             ; 86F4 85 03                    ..
        clc                                     ; 86F6 18                       .
        adc     $02                             ; 86F7 65 02                    e.
        sta     $02                             ; 86F9 85 02                    ..
        tax                                     ; 86FB AA                       .
L86FC:  ldy     L90E4,x                         ; 86FC BC E4 90                 ...
        lda     L0211,y                         ; 86FF B9 11 02                 ...
        cmp     #$8B                            ; 8702 C9 8B                    ..
        beq     L870D                           ; 8704 F0 07                    ..
        dex                                     ; 8706 CA                       .
        dec     $01                             ; 8707 C6 01                    ..
        bpl     L86FC                           ; 8709 10 F1                    ..
        bmi     L8728                           ; 870B 30 1B                    0.
L870D:  ldy     L90FB,x                         ; 870D BC FB 90                 ...
        lda     L0211,y                         ; 8710 B9 11 02                 ...
        cmp     #$8C                            ; 8713 C9 8C                    ..
        beq     L872B                           ; 8715 F0 14                    ..
        ldx     $02                             ; 8717 A6 02                    ..
L8719:  ldy     L90E4,x                         ; 8719 BC E4 90                 ...
        lda     L0211,y                         ; 871C B9 11 02                 ...
        cmp     #$8C                            ; 871F C9 8C                    ..
        beq     L872F                           ; 8721 F0 0C                    ..
        dex                                     ; 8723 CA                       .
        dec     $03                             ; 8724 C6 03                    ..
        bpl     L8719                           ; 8726 10 F1                    ..
L8728:  jmp     L878E                           ; 8728 4C 8E 87                 L..

; ----------------------------------------------------------------------------
L872B:  lda     $01                             ; 872B A5 01                    ..
        sta     $03                             ; 872D 85 03                    ..
L872F:  ldy     L0000                           ; 872F A4 00                    ..
        lda     $01                             ; 8731 A5 01                    ..
        sta     L0004,y                         ; 8733 99 04 00                 ...
        lda     $03                             ; 8736 A5 03                    ..
        sta     $07,y                           ; 8738 99 07 00                 ...
        dec     L0000                           ; 873B C6 00                    ..
        bpl     L86E8                           ; 873D 10 A9                    ..
        lda     #$28                            ; 873F A9 28                    .(
        jsr     queue_sound                           ; 8741 20 5D EC                  ].
        ldy     #$06                            ; 8744 A0 06                    ..
; --- L8746: password accepted: shift the 3-bit group values into place,
; grant the matching weapons (bit -> weapon ids via L9111/L9112, energy
; $9C), latch $67 = $6E, and Beat ($BC) if $6D == $FF; then straight to
; stage select.
L8746:  asl     L0004                           ; 8746 06 04                    ..
        asl     $07                             ; 8748 06 07                    ..
        cpy     #$04                            ; 874A C0 04                    ..
        bcs     L8752                           ; 874C B0 04                    ..
        asl     $05                             ; 874E 06 05                    ..
        asl     $08                             ; 8750 06 08                    ..
L8752:  dey                                     ; 8752 88                       .
        bne     L8746                           ; 8753 D0 F1                    ..
        lda     L0004                           ; 8755 A5 04                    ..
        ora     $05                             ; 8757 05 05                    ..
        ora     $06                             ; 8759 05 06                    ..
        sta     $6E                             ; 875B 85 6E                    .n
        sta     L0000                           ; 875D 85 00                    ..
        sta     $67                             ; 875F 85 67                    .g
        ldy     #$00                            ; 8761 A0 00                    ..
L8763:  lsr     L0000                           ; 8763 46 00                    F.
        bcc     L8775                           ; 8765 90 0E                    ..
        lda     #$9C                            ; 8767 A9 9C                    ..
        ldx     L9111,y                         ; 8769 BE 11 91                 ...
        sta     $B0,x                           ; 876C 95 B0                    ..
        ldx     L9112,y                         ; 876E BE 12 91                 ...
        beq     L8775                           ; 8771 F0 02                    ..
        sta     $B0,x                           ; 8773 95 B0                    ..
L8775:  iny                                     ; 8775 C8                       .
        iny                                     ; 8776 C8                       .
        cpy     #$10                            ; 8777 C0 10                    ..
        bne     L8763                           ; 8779 D0 E8                    ..
        lda     $07                             ; 877B A5 07                    ..
        ora     $08                             ; 877D 05 08                    ..
        ora     $09                             ; 877F 05 09                    ..
        sta     $6D                             ; 8781 85 6D                    .m
        cmp     #$FF                            ; 8783 C9 FF                    ..
        bne     L878B                           ; 8785 D0 04                    ..
        lda     #$9C                            ; 8787 A9 9C                    ..
        sta     $BC                             ; 8789 85 BC                    ..
L878B:  jmp     L80E1                           ; 878B 4C E1 80                 L..

; ----------------------------------------------------------------------------
; --- L878E: password rejected: error buzz ($2E), “PASSWORD ERROR”
; (string 1), blink the dots until a button, restore banner (string 0),
; back to the entry loop.
L878E:  lda     #$2E                            ; 878E A9 2E                    ..
        jsr     queue_sound                           ; 8790 20 5D EC                  ].
        ldx     #$01                            ; 8793 A2 01                    ..
        jsr     L884A                           ; 8795 20 4A 88                  J.
L8798:  lda     #$73                            ; 8798 A9 73                    .s
        sta     L0200                           ; 879A 8D 00 02                 ...
        sta     $0204                           ; 879D 8D 04 02                 ...
        lda     #$7B                            ; 87A0 A9 7B                    .{
        sta     L0208                           ; 87A2 8D 08 02                 ...
        sta     L020C                           ; 87A5 8D 0C 02                 ...
        jsr     L851E                           ; 87A8 20 1E 85                  ..
        lda     $14                             ; 87AB A5 14                    ..
        and     #$C0                            ; 87AD 29 C0                    ).
        beq     L8798                           ; 87AF F0 E7                    ..
        ldx     #$00                            ; 87B1 A2 00                    ..
        jsr     L884A                           ; 87B3 20 4A 88                  J.
        jmp     L83D0                           ; 87B6 4C D0 83                 L..

; ----------------------------------------------------------------------------
; --- L87B9: draw the password for the current $6E/$6D: split each into
; three 3-bit groups (inverse of L86AB), place a red dot at each group's
; L90E4 cell and a gray dot at its L90FB (or L90E4) cell — red and gray
; dots colliding on one cell use the shifted-row variant to coexist.
L87B9:  lda     $6E                             ; 87B9 A5 6E                    .n
        sta     L0004                           ; 87BB 85 04                    ..
        sta     $05                             ; 87BD 85 05                    ..
        sta     $06                             ; 87BF 85 06                    ..
        lda     $6D                             ; 87C1 A5 6D                    .m
        sta     $07                             ; 87C3 85 07                    ..
        sta     $08                             ; 87C5 85 08                    ..
        sta     $09                             ; 87C7 85 09                    ..
        ldy     #$06                            ; 87C9 A0 06                    ..
L87CB:  lsr     L0004                           ; 87CB 46 04                    F.
        lsr     $07                             ; 87CD 46 07                    F.
        cpy     #$04                            ; 87CF C0 04                    ..
        bcs     L87D7                           ; 87D1 B0 04                    ..
        lsr     $05                             ; 87D3 46 05                    F.
        lsr     $08                             ; 87D5 46 08                    F.
L87D7:  dey                                     ; 87D7 88                       .
        bne     L87CB                           ; 87D8 D0 F1                    ..
        ldy     #$06                            ; 87DA A0 06                    ..
L87DC:  lda     L0004,y                         ; 87DC B9 04 00                 ...
        and     #$07                            ; 87DF 29 07                    ).
        sta     L0004,y                         ; 87E1 99 04 00                 ...
        dey                                     ; 87E4 88                       .
        bne     L87DC                           ; 87E5 D0 F5                    ..
        lda     #$02                            ; 87E7 A9 02                    ..
        sta     L0000                           ; 87E9 85 00                    ..
L87EB:  ldy     L0000                           ; 87EB A4 00                    ..
        lda     L90E0,y                         ; 87ED B9 E0 90                 ...
        clc                                     ; 87F0 18                       .
        adc     L0004,y                         ; 87F1 79 04 00                 y..
        tax                                     ; 87F4 AA                       .
        lda     L90E4,x                         ; 87F5 BD E4 90                 ...
        tay                                     ; 87F8 A8                       .
        lsr     a                               ; 87F9 4A                       J
        tax                                     ; 87FA AA                       .
        lda     #$8B                            ; 87FB A9 8B                    ..
        sta     L0211,y                         ; 87FD 99 11 02                 ...
        .byte   $A9                             ; 8800 A9                       .
L8801:  .byte   $03                             ; 8801 03                       .
        sta     $0212,y                         ; 8802 99 12 02                 ...
        lda     L9121,x                         ; 8805 BD 21 91                 .!.
        sta     $0210,y                         ; 8808 99 10 02                 ...
        lda     L9122,x                         ; 880B BD 22 91                 .".
        sta     $0213,y                         ; 880E 99 13 02                 ...
        ldy     L0000                           ; 8811 A4 00                    ..
        lda     $07,y                           ; 8813 B9 07 00                 ...
        clc                                     ; 8816 18                       .
        adc     L90E0,y                         ; 8817 79 E0 90                 y..
        tax                                     ; 881A AA                       .
        lda     L0004,y                         ; 881B B9 04 00                 ...
        cmp     $07,y                           ; 881E D9 07 00                 ...
        bne     L8829                           ; 8821 D0 06                    ..
        lda     L90FB,x                         ; 8823 BD FB 90                 ...
        jmp     L882C                           ; 8826 4C 2C 88                 L,.

; ----------------------------------------------------------------------------
L8829:  lda     L90E4,x                         ; 8829 BD E4 90                 ...
L882C:  tay                                     ; 882C A8                       .
        lsr     a                               ; 882D 4A                       J
        tax                                     ; 882E AA                       .
        lda     #$8C                            ; 882F A9 8C                    ..
        sta     L0211,y                         ; 8831 99 11 02                 ...
        lda     #$02                            ; 8834 A9 02                    ..
        sta     $0212,y                         ; 8836 99 12 02                 ...
        lda     L9121,x                         ; 8839 BD 21 91                 .!.
        sta     $0210,y                         ; 883C 99 10 02                 ...
        lda     L9122,x                         ; 883F BD 22 91                 .".
        sta     $0213,y                         ; 8842 99 13 02                 ...
        dec     L0000                           ; 8845 C6 00                    ..
        bpl     L87EB                           ; 8847 10 A2                    ..
        rts                                     ; 8849 60                       `

; ----------------------------------------------------------------------------
; --- L884A: write prompt string X (offsets L9073, text L9078) into the
; $0780 nametable buffer. 0 blank banner / 1 PASSWORD ERROR / 2 password
; banner / 3 STAGE SELECT+CONTINUE / 4 CONTINUE.
L884A:  ldy     L9073,x                         ; 884A BC 73 90                 .s.
        ldx     #$00                            ; 884D A2 00                    ..
L884F:  lda     L9078,y                         ; 884F B9 78 90                 .x.
        sta     $0780,x                         ; 8852 9D 80 07                 ...
        cmp     #$FF                            ; 8855 C9 FF                    ..
        beq     L885D                           ; 8857 F0 04                    ..
        iny                                     ; 8859 C8                       .
        inx                                     ; 885A E8                       .
        bne     L884F                           ; 885B D0 F2                    ..
L885D:  sta     $19                             ; 885D 85 19                    ..
        rts                                     ; 885F 60                       `

; ----------------------------------------------------------------------------
; --- L8860: STAGE CLEAR ($30=$10, arrives with $69/no-respawn cleared).
; $6C < $08 robot master -> weapon get; $08-$0A -> Proto castle map;
; $0B -> Proto-4 escape cutscene (L9331); $0C+ -> Wily castle map.
L8860:  lda     #$00                            ; 8860 A9 00                    ..
        sta     $95                             ; 8862 85 95                    ..
        lda     $6C                             ; 8864 A5 6C                    .l
        cmp     #$08                            ; 8866 C9 08                    ..
        bcc     L887B                           ; 8868 90 11                    ..
        cmp     #$0B                            ; 886A C9 0B                    ..
        beq     L8878                           ; 886C F0 0A                    ..
        cmp     #$0C                            ; 886E C9 0C                    ..
        bcs     L8875                           ; 8870 B0 03                    ..
        jmp     L9272                           ; 8872 4C 72 92                 Lr.

; ----------------------------------------------------------------------------
L8875:  jmp     L92CD                           ; 8875 4C CD 92                 L..

; ----------------------------------------------------------------------------
L8878:  jmp     L9331                           ; 8878 4C 31 93                 L1.

; ----------------------------------------------------------------------------
; --- L887B: WEAPON GET. Repeat visit (bit already in $67) skips straight
; back to stage select. Otherwise latch $67 = $6E and run the ceremony:
L887B:  ldy     $6C                             ; 887B A4 6C                    .l
        lda     $F2B2,y                         ; 887D B9 B2 F2                 ...
        and     $67                             ; 8880 25 67                    %g
        beq     L8887                           ; 8882 F0 03                    ..
        jmp     L80E1                           ; 8884 4C E1 80                 L..

; ----------------------------------------------------------------------------
; --- L8887: weapon-get screen ($23=$03/$04): Mega Man poses as menu actor
; type $1B over the starfield; scroll crawls up 3px/frame ($FA/$9B);
; weapon-get music ($14).
L8887:  lda     $6E                             ; 8887 A5 6E                    .n
        sta     $67                             ; 8889 85 67                    .g
        jsr     palette_fade_out                           ; 888B 20 F1 C3                  ..
        jsr     entity_clear_all                           ; 888E 20 9D C3                  ..
        jsr     oam_clear                           ; 8891 20 8F C3                  ..
        jsr     scroll_irq_reset                           ; 8894 20 B8 C3                  ..
        jsr     frame_wait                           ; 8897 20 22 FF                  ".
        jsr     disable_rendering                           ; 889A 20 D1 C2                  ..
        jsr     stage_state_init                           ; 889D 20 F2 F3                  ..
        lda     #$01                            ; 88A0 A9 01                    ..
        jsr     set_mirroring                           ; 88A2 20 B7 FF                  ..
        lda     #$10                            ; 88A5 A9 10                    ..
        sta     $26                             ; 88A7 85 26                    .&
        lda     #$0F                            ; 88A9 A9 0F                    ..
        sta     L0027                           ; 88AB 85 27                    .'
        lda     #$00                            ; 88AD A9 00                    ..
        sta     $10                             ; 88AF 85 10                    ..
        lda     #$03                            ; 88B1 A9 03                    ..
        sta     $23                             ; 88B3 85 23                    .#
        jsr     LDAFC                           ; 88B5 20 FC DA                  ..
        lda     #$08                            ; 88B8 A9 08                    ..
        sta     $10                             ; 88BA 85 10                    ..
        lda     #$04                            ; 88BC A9 04                    ..
        sta     $23                             ; 88BE 85 23                    .#
        jsr     LDAFC                           ; 88C0 20 FC DA                  ..
        ldy     #$98                            ; 88C3 A0 98                    ..
        jsr     L89FC                           ; 88C5 20 FC 89                  ..
        lda     #$01                            ; 88C8 A9 01                    ..
        sta     L0300                           ; 88CA 8D 00 03                 ...
        ldx     #$00                            ; 88CD A2 00                    ..
        stx     $0348                           ; 88CF 8E 48 03                 .H.
        stx     $0390                           ; 88D2 8E 90 03                 ...
        stx     $0528                           ; 88D5 8E 28 05                 .(.
        lda     #$1B                            ; 88D8 A9 1B                    ..
        jsr     entity_set_subtype                           ; 88DA 20 98 EA                  ..
        lda     #$6C                            ; 88DD A9 6C                    .l
        sta     $0378                           ; 88DF 8D 78 03                 .x.
        lda     #$80                            ; 88E2 A9 80                    ..
        sta     $0330                           ; 88E4 8D 30 03                 .0.
        lda     #$57                            ; 88E7 A9 57                    .W
        sta     $FA                             ; 88E9 85 FA                    ..
        lda     #$CE                            ; 88EB A9 CE                    ..
        sta     $9B                             ; 88ED 85 9B                    ..
        lda     #$06                            ; 88EF A9 06                    ..
        sta     $99                             ; 88F1 85 99                    ..
        jsr     enable_rendering                           ; 88F3 20 DB C2                  ..
        jsr     frame_wait                           ; 88F6 20 22 FF                  ".
        lda     #$14                            ; 88F9 A9 14                    ..
        jsr     queue_sound_param                           ; 88FB 20 5B EC                  [.
        jsr     palette_fade_in                           ; 88FE 20 EB C3                  ..
; --- L8901: crawl the scroll to rest, dim the backdrop palette rows in
; 4 steps, then type the “YOU GOT ...” text: rows lit up from L8ED7
; palette + L8EFB, then the per-stage string (L8EFF offset into L8F07;
; $5C = move to nametable address, ‘.’ = done) one letter per 8 frames.
; At the terminator, grant the weapon(s) L8F08/L8F09 (energy $9C), wait
; $B4 frames, and fall into the password display screen (L853B).
L8901:  inc     $95                             ; 8901 E6 95                    ..
        dec     $FA                             ; 8903 C6 FA                    ..
        dec     $FA                             ; 8905 C6 FA                    ..
        dec     $FA                             ; 8907 C6 FA                    ..
        dec     $9B                             ; 8909 C6 9B                    ..
        dec     $9B                             ; 890B C6 9B                    ..
        dec     $9B                             ; 890D C6 9B                    ..
        dec     $95                             ; 890F C6 95                    ..
        jsr     frame_wait                           ; 8911 20 22 FF                  ".
        lda     $FA                             ; 8914 A5 FA                    ..
        bne     L8901                           ; 8916 D0 E9                    ..
        sta     $9D                             ; 8918 85 9D                    ..
        lda     #$30                            ; 891A A9 30                    .0
        sta     $0F                             ; 891C 85 0F                    ..
        lda     #$04                            ; 891E A9 04                    ..
        sta     $0E                             ; 8920 85 0E                    ..
        jsr     L8A3A                           ; 8922 20 3A 8A                  :.
L8925:  lda     $9D                             ; 8925 A5 9D                    ..
        and     #$07                            ; 8927 29 07                    ).
        bne     L8948                           ; 8929 D0 1D                    ..
        ldy     #$07                            ; 892B A0 07                    ..
L892D:  lda     $0630,y                         ; 892D B9 30 06                 .0.
        sec                                     ; 8930 38                       8
        sbc     $0F                             ; 8931 E5 0F                    ..
        bcs     L8937                           ; 8933 B0 02                    ..
        lda     #$0F                            ; 8935 A9 0F                    ..
L8937:  sta     $0610,y                         ; 8937 99 10 06                 ...
        dey                                     ; 893A 88                       .
        bpl     L892D                           ; 893B 10 F0                    ..
        sty     $18                             ; 893D 84 18                    ..
        lda     $0F                             ; 893F A5 0F                    ..
        beq     L8948                           ; 8941 F0 05                    ..
        sec                                     ; 8943 38                       8
        sbc     #$10                            ; 8944 E9 10                    ..
        sta     $0F                             ; 8946 85 0F                    ..
L8948:  jsr     L8A4A                           ; 8948 20 4A 8A                  J.
        lda     $0540                           ; 894B AD 40 05                 .@.
        ora     $0570                           ; 894E 0D 70 05                 .p.
        bne     L8925                           ; 8951 D0 D2                    ..
        dec     $0E                             ; 8953 C6 0E                    ..
        bne     L8925                           ; 8955 D0 CE                    ..
        sta     $9D                             ; 8957 85 9D                    ..
        lda     #$02                            ; 8959 A9 02                    ..
        sta     $0E                             ; 895B 85 0E                    ..
L895D:  lda     $9D                             ; 895D A5 9D                    ..
        and     #$07                            ; 895F 29 07                    ).
        bne     L898D                           ; 8961 D0 2A                    .*
        tay                                     ; 8963 A8                       .
        ldx     #$20                            ; 8964 A2 20                    . 
        lda     $9D                             ; 8966 A5 9D                    ..
        and     #$08                            ; 8968 29 08                    ).
        beq     L8971                           ; 896A F0 05                    ..
        lda     $6C                             ; 896C A5 6C                    .l
        asl     a                               ; 896E 0A                       .
        asl     a                               ; 896F 0A                       .
        tax                                     ; 8970 AA                       .
L8971:  lda     L8ED7,x                         ; 8971 BD D7 8E                 ...
        sta     $0610,y                         ; 8974 99 10 06                 ...
        sta     $0630,y                         ; 8977 99 30 06                 .0.
        lda     L8EFB,y                         ; 897A B9 FB 8E                 ...
        sta     $0614,y                         ; 897D 99 14 06                 ...
        sta     $0634,y                         ; 8980 99 34 06                 .4.
        inx                                     ; 8983 E8                       .
        iny                                     ; 8984 C8                       .
        cpy     #$04                            ; 8985 C0 04                    ..
        bne     L8971                           ; 8987 D0 E8                    ..
        lda     #$FF                            ; 8989 A9 FF                    ..
        sta     $18                             ; 898B 85 18                    ..
L898D:  jsr     L8A4A                           ; 898D 20 4A 8A                  J.
        lda     $0540                           ; 8990 AD 40 05                 .@.
        ora     $0570                           ; 8993 0D 70 05                 .p.
        bne     L895D                           ; 8996 D0 C5                    ..
        dec     $0E                             ; 8998 C6 0E                    ..
        bne     L895D                           ; 899A D0 C1                    ..
        lda     #$3C                            ; 899C A9 3C                    .<
        jsr     L8A7D                           ; 899E 20 7D 8A                  }.
        ldy     #$04                            ; 89A1 A0 04                    ..
L89A3:  lda     L8FDB,y                         ; 89A3 B9 DB 8F                 ...
        sta     $0780,y                         ; 89A6 99 80 07                 ...
        dey                                     ; 89A9 88                       .
        bpl     L89A3                           ; 89AA 10 F7                    ..
        ldx     $6C                             ; 89AC A6 6C                    .l
        ldy     L8EFF,x                         ; 89AE BC FF 8E                 ...
L89B1:  lda     L8F07,y                         ; 89B1 B9 07 8F                 ...
        cmp     #$20                            ; 89B4 C9 20                    . 
        beq     L89DE                           ; 89B6 F0 26                    .&
        cmp     #$5C                            ; 89B8 C9 5C                    .\
        beq     L89D0                           ; 89BA F0 14                    ..
        sta     $0783                           ; 89BC 8D 83 07                 ...
        pha                                     ; 89BF 48                       H
        lda     #$FF                            ; 89C0 A9 FF                    ..
        sta     $19                             ; 89C2 85 19                    ..
        lda     #$08                            ; 89C4 A9 08                    ..
        jsr     L8A7D                           ; 89C6 20 7D 8A                  }.
        pla                                     ; 89C9 68                       h
        cmp     #$2E                            ; 89CA C9 2E                    ..
        beq     L89E4                           ; 89CC F0 16                    ..
        bne     L89DE                           ; 89CE D0 0E                    ..
L89D0:  iny                                     ; 89D0 C8                       .
        lda     L8F07,y                         ; 89D1 B9 07 8F                 ...
        sta     $0780                           ; 89D4 8D 80 07                 ...
        lda     L8F08,y                         ; 89D7 B9 08 8F                 ...
        sta     $0781                           ; 89DA 8D 81 07                 ...
        iny                                     ; 89DD C8                       .
L89DE:  iny                                     ; 89DE C8                       .
        inc     $0781                           ; 89DF EE 81 07                 ...
        bne     L89B1                           ; 89E2 D0 CD                    ..
L89E4:  ldx     L8F08,y                         ; 89E4 BE 08 8F                 ...
        lda     #$9C                            ; 89E7 A9 9C                    ..
        sta     $B0,x                           ; 89E9 95 B0                    ..
        ldx     L8F09,y                         ; 89EB BE 09 8F                 ...
        beq     L89F4                           ; 89EE F0 04                    ..
        lda     #$9C                            ; 89F0 A9 9C                    ..
        sta     $B0,x                           ; 89F2 95 B0                    ..
L89F4:  lda     #$B4                            ; 89F4 A9 B4                    ..
        jsr     L8A7D                           ; 89F6 20 7D 8A                  }.
        jmp     L853B                           ; 89F9 4C 3B 85                 L;.

; ----------------------------------------------------------------------------
; --- L89FC: palette set loader: record at L8B74+Y = 6 CHR banks for
; $EA-$EF + 32 palette bytes into $0620 (sets $4C title / $26 stage
; select / $72 password / $98 weapon get).
L89FC:  lda     L8B74,y                         ; 89FC B9 74 8B                 .t.
        sta     $EA                             ; 89FF 85 EA                    ..
        lda     L8B75,y                         ; 8A01 B9 75 8B                 .u.
        sta     $EB                             ; 8A04 85 EB                    ..
        lda     L8B76,y                         ; 8A06 B9 76 8B                 .v.
        sta     $EC                             ; 8A09 85 EC                    ..
        lda     L8B77,y                         ; 8A0B B9 77 8B                 .w.
        sta     $ED                             ; 8A0E 85 ED                    ..
        lda     L8B78,y                         ; 8A10 B9 78 8B                 .x.
        sta     $EE                             ; 8A13 85 EE                    ..
        lda     L8B79,y                         ; 8A15 B9 79 8B                 .y.
        sta     $EF                             ; 8A18 85 EF                    ..
        ldx     #$00                            ; 8A1A A2 00                    ..
L8A1C:  lda     L8B7A,y                         ; 8A1C B9 7A 8B                 .z.
        sta     $0620,x                         ; 8A1F 9D 20 06                 . .
        iny                                     ; 8A22 C8                       .
        inx                                     ; 8A23 E8                       .
        cpx     #$20                            ; 8A24 E0 20                    . 
        bne     L8A1C                           ; 8A26 D0 F4                    ..
        rts                                     ; 8A28 60                       `

; ----------------------------------------------------------------------------
; --- L8A29: copy A bytes of OAM sprite data from L8C96+Y to $0200
; ($00 title menu cursor+text, $10 stage select mugshot sprites).
L8A29:  sta     L0000                           ; 8A29 85 00                    ..
        ldx     #$00                            ; 8A2B A2 00                    ..
L8A2D:  lda     L8C96,y                         ; 8A2D B9 96 8C                 ...
        sta     L0200,x                         ; 8A30 9D 00 02                 ...
        iny                                     ; 8A33 C8                       .
        inx                                     ; 8A34 E8                       .
        cpx     L0000                           ; 8A35 E4 00                    ..
        bne     L8A2D                           ; 8A37 D0 F4                    ..
        rts                                     ; 8A39 60                       `

; ----------------------------------------------------------------------------
; --- L8A3A: init the drifting starfield: 16 sprites from L8FE0 into
; $02C0, star CHR bank into $ED.
L8A3A:  ldy     #$3F                            ; 8A3A A0 3F                    .?
L8A3C:  lda     L8FE0,y                         ; 8A3C B9 E0 8F                 ...
        sta     $02C0,y                         ; 8A3F 99 C0 02                 ...
        dey                                     ; 8A42 88                       .
        bpl     L8A3C                           ; 8A43 10 F7                    ..
        lda     #$49                            ; 8A45 A9 49                    .I
        sta     $ED                             ; 8A47 85 ED                    ..
        rts                                     ; 8A49 60                       `

; ----------------------------------------------------------------------------
; --- L8A4A: starfield tick: stars drift down-left (first 8 at double
; speed), wrap at Y=$F0, then render via render_tick_menu (OAM $00-$BF
; rebuilt, starfield sprites at $02C0+ persist).
L8A4A:  ldx     #$3C                            ; 8A4A A2 3C                    .<
L8A4C:  dec     $02C3,x                         ; 8A4C DE C3 02                 ...
        inc     $02C0,x                         ; 8A4F FE C0 02                 ...
        lda     $02C0,x                         ; 8A52 BD C0 02                 ...
        cmp     #$F0                            ; 8A55 C9 F0                    ..
        bne     L8A5E                           ; 8A57 D0 05                    ..
        lda     #$00                            ; 8A59 A9 00                    ..
        sta     $02C0,x                         ; 8A5B 9D C0 02                 ...
L8A5E:  cpx     #$20                            ; 8A5E E0 20                    . 
        bcs     L8A74                           ; 8A60 B0 12                    ..
        dec     $02C3,x                         ; 8A62 DE C3 02                 ...
        inc     $02C0,x                         ; 8A65 FE C0 02                 ...
        lda     $02C0,x                         ; 8A68 BD C0 02                 ...
        cmp     #$F0                            ; 8A6B C9 F0                    ..
        bne     L8A74                           ; 8A6D D0 05                    ..
        lda     #$00                            ; 8A6F A9 00                    ..
        sta     $02C0,x                         ; 8A71 9D C0 02                 ...
L8A74:  dex                                     ; 8A74 CA                       .
        dex                                     ; 8A75 CA                       .
        dex                                     ; 8A76 CA                       .
        dex                                     ; 8A77 CA                       .
        bpl     L8A4C                           ; 8A78 10 D2                    ..
        jmp     LF391                           ; 8A7A 4C 91 F3                 L..

; ----------------------------------------------------------------------------
; --- L8A7D: run the starfield for A frames (X/Y preserved).
L8A7D:  sta     $08                             ; 8A7D 85 08                    ..
        stx     $09                             ; 8A7F 86 09                    ..
        sty     $0A                             ; 8A81 84 0A                    ..
L8A83:  lda     #$00                            ; 8A83 A9 00                    ..
        sta     $0570                           ; 8A85 8D 70 05                 .p.
        jsr     L8A4A                           ; 8A88 20 4A 8A                  J.
        dec     $08                             ; 8A8B C6 08                    ..
        bne     L8A83                           ; 8A8D D0 F4                    ..
        ldx     $09                             ; 8A8F A6 09                    ..
        ldy     $0A                             ; 8A91 A4 0A                    ..
        rts                                     ; 8A93 60                       `

; ----------------------------------------------------------------------------
; --- L8A94: stage select: for each beaten boss (bit in $6E) blank his
; portrait — 4 rows of $07 tiles via the L8E52 template at nametable
; address L8E6F, and hide his sprites (L8E7F start / L8E80 count).
L8A94:  ldy     #$1C                            ; 8A94 A0 1C                    ..
L8A96:  lda     L8E52,y                         ; 8A96 B9 52 8E                 .R.
        sta     $0780,y                         ; 8A99 99 80 07                 ...
        dey                                     ; 8A9C 88                       .
        bpl     L8A96                           ; 8A9D 10 F7                    ..
        lda     $6E                             ; 8A9F A5 6E                    .n
        sta     L0000                           ; 8AA1 85 00                    ..
        lda     #$0E                            ; 8AA3 A9 0E                    ..
        sta     $01                             ; 8AA5 85 01                    ..
L8AA7:  asl     L0000                           ; 8AA7 06 00                    ..
        bcc     L8AEA                           ; 8AA9 90 3F                    .?
        ldy     $01                             ; 8AAB A4 01                    ..
        lda     L8E6F,y                         ; 8AAD B9 6F 8E                 .o.
        sta     $0780                           ; 8AB0 8D 80 07                 ...
        sta     $0787                           ; 8AB3 8D 87 07                 ...
        sta     $078E                           ; 8AB6 8D 8E 07                 ...
        sta     $0795                           ; 8AB9 8D 95 07                 ...
        lda     L8E70,y                         ; 8ABC B9 70 8E                 .p.
        sta     $0781                           ; 8ABF 8D 81 07                 ...
        clc                                     ; 8AC2 18                       .
        adc     #$20                            ; 8AC3 69 20                    i 
        sta     $0788                           ; 8AC5 8D 88 07                 ...
        adc     #$20                            ; 8AC8 69 20                    i 
        sta     $078F                           ; 8ACA 8D 8F 07                 ...
        adc     #$20                            ; 8ACD 69 20                    i 
        sta     $0796                           ; 8ACF 8D 96 07                 ...
        ldx     L8E7F,y                         ; 8AD2 BE 7F 8E                 ...
        lda     L8E80,y                         ; 8AD5 B9 80 8E                 ...
        sta     $02                             ; 8AD8 85 02                    ..
        lda     #$F8                            ; 8ADA A9 F8                    ..
L8ADC:  sta     L0200,x                         ; 8ADC 9D 00 02                 ...
        inx                                     ; 8ADF E8                       .
        inx                                     ; 8AE0 E8                       .
        inx                                     ; 8AE1 E8                       .
        inx                                     ; 8AE2 E8                       .
        dec     $02                             ; 8AE3 C6 02                    ..
        bne     L8ADC                           ; 8AE5 D0 F5                    ..
        jsr     nametable_flush                           ; 8AE7 20 98 C2                  ..
L8AEA:  dec     $01                             ; 8AEA C6 01                    ..
        dec     $01                             ; 8AEC C6 01                    ..
        bpl     L8AA7                           ; 8AEE 10 B7                    ..
        rts                                     ; 8AF0 60                       `

; ----------------------------------------------------------------------------
; --- L8AF1: all 8 bosses beaten: flash the screen 16 times, then draw
; the castle door in the center cell (nametable text L8E8F + sprites
; L8EB1 at $0220).
L8AF1:  lda     $6E                             ; 8AF1 A5 6E                    .n
        cmp     #$FF                            ; 8AF3 C9 FF                    ..
        bne     L8B2D                           ; 8AF5 D0 36                    .6
        lda     #$10                            ; 8AF7 A9 10                    ..
        sta     $9D                             ; 8AF9 85 9D                    ..
L8AFB:  lda     $0610                           ; 8AFB AD 10 06                 ...
        eor     #$3F                            ; 8AFE 49 3F                    I?
        sta     $0610                           ; 8B00 8D 10 06                 ...
        lda     #$FF                            ; 8B03 A9 FF                    ..
        sta     $18                             ; 8B05 85 18                    ..
        lda     #$02                            ; 8B07 A9 02                    ..
        jsr     LFF24                           ; 8B09 20 24 FF                  $.
        dec     $9D                             ; 8B0C C6 9D                    ..
        bne     L8AFB                           ; 8B0E D0 EB                    ..
        ldy     #$21                            ; 8B10 A0 21                    .!
L8B12:  lda     L8E8F,y                         ; 8B12 B9 8F 8E                 ...
        sta     $0780,y                         ; 8B15 99 80 07                 ...
        dey                                     ; 8B18 88                       .
        bpl     L8B12                           ; 8B19 10 F7                    ..
        sty     $19                             ; 8B1B 84 19                    ..
        ldx     #$20                            ; 8B1D A2 20                    . 
        ldy     #$00                            ; 8B1F A0 00                    ..
L8B21:  lda     L8EB1,y                         ; 8B21 B9 B1 8E                 ...
        sta     L0200,x                         ; 8B24 9D 00 02                 ...
        inx                                     ; 8B27 E8                       .
        iny                                     ; 8B28 C8                       .
        cpy     #$20                            ; 8B29 C0 20                    . 
        bne     L8B21                           ; 8B2B D0 F4                    ..
L8B2D:  rts                                     ; 8B2D 60                       `

; ----------------------------------------------------------------------------
; --- L8B2E: enlarge the picked boss's portrait: rebuild the center cell
; frame rows from the L8E52 template + L8ED1 corner tiles (3 strips at
; $0780/$079C/$07B8).
L8B2E:  ldy     #$1C                            ; 8B2E A0 1C                    ..
L8B30:  lda     L8E52,y                         ; 8B30 B9 52 8E                 .R.
        sta     $0780,y                         ; 8B33 99 80 07                 ...
        sta     $079C,y                         ; 8B36 99 9C 07                 ...
        sta     $07B8,y                         ; 8B39 99 B8 07                 ...
        dey                                     ; 8B3C 88                       .
        bpl     L8B30                           ; 8B3D 10 F1                    ..
        ldx     #$38                            ; 8B3F A2 38                    .8
        ldy     #$04                            ; 8B41 A0 04                    ..
L8B43:  lda     L8ED1,y                         ; 8B43 B9 D1 8E                 ...
        sta     $0780,x                         ; 8B46 9D 80 07                 ...
        sta     $0787,x                         ; 8B49 9D 87 07                 ...
        sta     $078E,x                         ; 8B4C 9D 8E 07                 ...
        sta     $0795,x                         ; 8B4F 9D 95 07                 ...
        lda     L8ED2,y                         ; 8B52 B9 D2 8E                 ...
        sta     $0781,x                         ; 8B55 9D 81 07                 ...
        clc                                     ; 8B58 18                       .
        adc     #$20                            ; 8B59 69 20                    i 
        sta     $0788,x                         ; 8B5B 9D 88 07                 ...
        adc     #$20                            ; 8B5E 69 20                    i 
        sta     $078F,x                         ; 8B60 9D 8F 07                 ...
        adc     #$20                            ; 8B63 69 20                    i 
        sta     $0796,x                         ; 8B65 9D 96 07                 ...
        txa                                     ; 8B68 8A                       .
        sec                                     ; 8B69 38                       8
        sbc     #$1C                            ; 8B6A E9 1C                    ..
        tax                                     ; 8B6C AA                       .
        dey                                     ; 8B6D 88                       .
        dey                                     ; 8B6E 88                       .
        bpl     L8B43                           ; 8B6F 10 D2                    ..
        sty     $19                             ; 8B71 84 19                    ..
        rts                                     ; 8B73 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; MENU DATA — $8B74-$91C8
;   $8B74 palette set records for L89FC (Y-indexed: 6 CHR banks + 32 pal
;         bytes; $4C title, $26 stage select, $72 password, $98 weapon get)
;   $8C32 password-screen palette, $8C42 stage-select flash row
;   $8C4A per-stage lit palette rows (8 bytes * stage) for the boss intro
;   $8C8A/$8C90 palette column-wipe delay/threshold pairs
;   $8C96 OAM blocks for L8A29 (+$00 title menu, +$10 stage select)
;   $8D8A/$8D8D stage-select cursor pixel origins (X cols / Y rows)
;   $8D90/$8D92 cursor step/wraparound pairs, $8D94/$8D9C cursor sprite
;         offsets (8 sprites), $8DA4 grid -> stage id (center = $08)
;   $8DB3 boss menu-actor sub_types, $8DBB pose-done anim phase,
;   $8DC3 pose flag strobe, $8DCB name-typing header, $8DD0 boss names
;         (16 bytes/stage, $20 = skip)
;   $8E50 stage-select Mega Man sub_types, $8E52 blank-strip template,
;   $8E6F portrait nametable addrs, $8E7F/$8E80 portrait sprite ranges
;   $8E8F/$8EB1 castle door text + sprites, $8ED1 big-frame corner tiles
;   $8ED7 weapon-get palette rows (+$6C*4), $8EFB letter palette,
;   $8EFF/$8F07 “YOU GOT ...” strings ($5C = addr escape, ‘.’ = end,
;         then L8F08/L8F09 weapon ids), $8FDB typing header
;   $8FE0 starfield OAM, $9024 password cursor OAM
;   $9034-$9071 password cursor/grid tables (L9063/L9069 cell pixel
;         coords, L906F/L9071 red/gray dot tiles)
;   $9073/$9078 prompt strings, $90E0-$9122 password encode/decode
;         tables (groups, cell lists, dot pixel coords), $9111/$9112
;         password bit -> weapon grants
;   $9169 checkpoints: per stage 2 x 3 bytes (screen, section, spawn
;         latch) — see L859C
; =============================================================================
L8B74:  .byte   $C4                             ; 8B74
L8B75:  .byte   $C6                             ; 8B75
L8B76:  .byte   $00                             ; 8B76
L8B77:  .byte   $00                             ; 8B77
L8B78:  .byte   $08                             ; 8B78
L8B79:  .byte   $00                             ; 8B79
L8B7A:  .byte   $0F,$21,$20,$11,$0F,$26,$20,$16,$0F,$26,$28,$16,$0F,$17,$27,$06 ; 8B7A
        .byte   $0F,$00,$00,$00,$0F,$00,$00,$00,$0F,$11,$21,$16,$0F,$00,$00,$00 ; 8B8A
        .byte   $C8,$CA,$00,$00,$08,$09,$0F,$20,$21,$11,$0F,$20,$2A,$1A,$0F,$20 ; 8B9A
        .byte   $27,$17,$0F,$20,$26,$16,$0F,$0F,$36,$26,$0F,$0F,$20,$36,$0F,$26 ; 8BAA
        .byte   $2C,$11,$0F,$27,$36,$26,$CC,$CE,$00,$00,$00,$00,$0F,$27,$38,$02 ; 8BBA
        .byte   $0F,$17,$27,$02,$0F,$20,$32,$22,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F ; 8BCA
        .byte   $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$D0,$D2,$00,$00 ; 8BDA
        .byte   $08,$00,$0F,$20,$2C,$1C,$0F,$20,$16,$06,$0F,$1C,$0C,$01,$0F,$20 ; 8BEA
        .byte   $11,$02,$0F,$0F,$0F,$0F,$0F,$0F,$20,$36,$0F,$0F,$20,$11,$0F,$0F ; 8BFA
        .byte   $20,$16,$D2,$00,$00,$00,$00,$00,$0F,$20,$26,$17,$0F,$20,$26,$17 ; 8C0A
        .byte   $0F,$0F,$0F,$0B,$0F,$20,$0F,$0F,$0F,$0F,$2C,$11,$0F,$0F,$20,$37 ; 8C1A
        .byte   $0F,$00,$00,$00,$0F,$00,$00,$00 ; 8C2A
L8C32:  .byte   $0F,$20,$2C,$1C,$0F,$31,$1C,$27,$0F,$31,$1C,$01,$0F,$20,$0F,$0F ; 8C32
L8C42:  .byte   $0F,$0F,$2C,$11,$0F,$0F,$20,$37 ; 8C42
L8C4A:  .byte   $0F,$0F,$20,$11,$0F,$0F,$20,$15,$0F,$0F,$20,$2C,$0F,$0F,$27,$11 ; 8C4A
        .byte   $0F,$0F,$20,$16,$0F,$0F,$38,$27,$0F,$0F,$20,$26,$0F,$0F,$20,$29 ; 8C5A
        .byte   $0F,$0F,$20,$28,$0F,$0F,$27,$17,$0F,$0F,$10,$16,$0F,$0F,$20,$26 ; 8C6A
        .byte   $0F,$0F,$20,$15,$0F,$0F,$27,$12,$0F,$0F,$20,$2C,$0F,$0F,$20,$1A ; 8C7A
L8C8A:  .byte   $78,$78,$78,$76,$74,$C8         ; 8C8A
L8C90:  .byte   $40                             ; 8C90

; ----------------------------------------------------------------------------
        .byte   $30,$20,$10,$00,$00             ; 8C91
L8C96:  .byte   $A7,$86,$02,$28,$F8,$90,$02,$C0,$F8,$A0,$02,$C0,$F8,$B0,$02,$C0 ; 8C96
        .byte   $57,$8D,$01,$68,$57,$8D,$01,$6F,$57,$8D,$01,$88,$57,$8D,$01,$8F ; 8CA6
        .byte   $7F,$8D,$01,$68,$7F,$8D,$01,$6F,$7F,$8D,$01,$88,$7F,$8D,$01,$8F ; 8CB6
        .byte   $67,$91,$00,$74,$67,$91,$40,$84,$6F,$92,$00,$74,$6F,$93,$00,$7C ; 8CC6
        .byte   $6F,$94,$00,$84,$77,$95,$00,$74,$77,$96,$00,$7C,$77,$97,$00,$84 ; 8CD6
        .byte   $27,$AD,$03,$2C,$2F,$AE,$03,$28,$2F,$AF,$03,$30,$1F,$B3,$02,$78 ; 8CE6
        .byte   $1F,$B4,$02,$80,$2F,$B5,$03,$78,$2F,$B6,$03,$80,$37,$B7,$03,$78 ; 8CF6
        .byte   $37,$B8,$03,$80,$1F,$B9,$02,$C0,$1F,$BA,$02,$C8,$27,$BB,$02,$C0 ; 8D06
        .byte   $27,$BC,$02,$C8,$2F,$BD,$03,$C8,$2F,$BE,$03,$D0,$37,$BF,$02,$C8 ; 8D16
        .byte   $5F,$C0,$02,$38,$77,$C1,$03,$28,$77,$C2,$03,$30,$5F,$C3,$03,$C8 ; 8D26
        .byte   $5F,$C4,$03,$D0,$67,$C5,$03,$C8,$67,$C6,$03,$D0,$6F,$C7,$03,$C8 ; 8D36
        .byte   $6F,$C8,$03,$D0,$9F,$C9,$03,$20,$9F,$CA,$03,$28,$9F,$CB,$03,$38 ; 8D46
        .byte   $A7,$CC,$03,$28,$A7,$CD,$03,$30,$AF,$CE,$03,$28,$AF,$CF,$03,$30 ; 8D56
        .byte   $A7,$D3,$02,$88,$AF,$D0,$03,$78,$AF,$D1,$03,$80,$AF,$D4,$02,$88 ; 8D66
        .byte   $B7,$D2,$03,$78,$9F,$D5,$03,$C8,$A7,$D6,$03,$C8,$AF,$D7,$03,$C8 ; 8D76
        .byte   $B7,$D8,$03,$C8                 ; 8D86
L8D8A:  .byte   $17,$57,$97                     ; 8D8A
L8D8D:  .byte   $18,$68,$B8                     ; 8D8D
L8D90:  .byte   $FF,$01                         ; 8D90
L8D92:  .byte   $03,$FD                         ; 8D92
L8D94:  .byte   $00,$00,$00,$00,$28,$28,$28,$28 ; 8D94
L8D9C:  .byte   $00,$07,$20,$27,$00,$07,$20,$27 ; 8D9C
L8DA4:  .byte   $02,$00,$07,$05,$08,$06,$01,$04,$03,$30,$70,$B0,$30,$80,$D0 ; 8DA4
L8DB3:  .byte   $03,$30,$10,$0D,$3E,$20,$3A,$1F ; 8DB3
L8DBB:  .byte   $0C,$10,$09,$1D,$1E,$0C,$09,$15 ; 8DBB
L8DC3:  .byte   $00,$04,$00,$04,$00,$00,$04,$00 ; 8DC3
L8DCB:  .byte   $2A,$0A,$00,$00,$FF             ; 8DCB
L8DD0:  .byte   $20,$47,$52,$41,$56,$49,$54,$59,$20,$4D,$41,$4E,$20,$20,$20,$20 ; 8DD0
        .byte   $20,$20,$57,$41,$56,$45,$20,$4D,$41,$4E,$20,$20,$20,$20,$20,$20 ; 8DE0
        .byte   $20,$20,$53,$54,$4F,$4E,$45,$20,$4D,$41,$4E,$20,$20,$20,$20,$20 ; 8DF0
        .byte   $20,$20,$47,$59,$52,$4F,$20,$4D,$41,$4E,$20,$20,$20,$20,$20,$20 ; 8E00
        .byte   $20,$20,$53,$54,$41,$52,$20,$4D,$41,$4E,$20,$20,$20,$20,$20,$20 ; 8E10
        .byte   $20,$43,$48,$41,$52,$47,$45,$20,$4D,$41,$4E,$20,$20,$20,$20,$20 ; 8E20
        .byte   $20,$4E,$41,$50,$41,$4C,$4D,$20,$4D,$41,$4E,$20,$20,$20,$20,$20 ; 8E30
        .byte   $20,$43,$52,$59,$53,$54,$41,$4C,$20,$4D,$41,$4E,$20,$20,$20,$20 ; 8E40
L8E50:  .byte   $5B,$5C                         ; 8E50
L8E52:  .byte   $20,$00,$03,$00,$00,$00,$00,$20,$00,$03,$00,$00,$00,$00,$20,$00 ; 8E52
        .byte   $03,$00,$00,$00,$00,$20,$00,$03,$00,$00,$00,$00,$FF ; 8E62
L8E6F:  .byte   $20                             ; 8E6F
L8E70:  .byte   $8E,$22,$84,$20,$84,$22,$98,$22,$8E,$21,$84,$21,$98,$20,$98 ; 8E70
L8E7F:  .byte   $4C                             ; 8E7F
L8E80:  .byte   $06,$A4,$07,$40                 ; 8E80

; ----------------------------------------------------------------------------
        .byte   $03,$D4,$04,$C0,$05,$80,$03,$8C,$06,$64,$07 ; 8E84
L8E8F:  .byte   $21,$8E,$03,$10,$11,$16,$12,$21,$AE,$03,$20,$21,$26,$17,$21,$CE ; 8E8F
        .byte   $03,$3A,$3B,$0B,$3C,$21,$EE,$03,$5C,$5D,$5E,$5F,$23,$DB,$01,$CC ; 8E9F
        .byte   $33,$FF                         ; 8EAF
L8EB1:  .byte   $67,$D3,$02,$88,$6F,$D9,$00,$70,$6F,$DA,$00,$78,$6F,$DB,$00,$80 ; 8EB1
        .byte   $6F,$D4,$02,$88,$77,$DC,$00,$74,$77,$DD,$00,$7C,$F8,$00,$00,$00 ; 8EC1
L8ED1:  .byte   $21                             ; 8ED1
L8ED2:  .byte   $8E,$21,$98,$22,$84             ; 8ED2
L8ED7:  .byte   $0F,$0F,$20,$14,$0F,$0F,$20,$11,$0F,$0F,$20,$07,$0F,$0F,$20,$1A ; 8ED7
        .byte   $0F,$0F,$28,$17,$0F,$0F,$20,$26,$0F,$0F,$27,$12,$0F,$0F,$20,$2C ; 8EE7
        .byte   $0F,$0F,$2C,$11                 ; 8EF7
L8EFB:  .byte   $0F,$0F,$20,$37                 ; 8EFB
L8EFF:  .byte   $00,$17                         ; 8EFF
L8F01:  .byte   $2C,$42,$69,$92,$A8,$BE         ; 8F01
L8F07:  .byte   $59                             ; 8F07
L8F08:  .byte   $4F                             ; 8F08
L8F09:  .byte   $55,$20,$47,$4F,$54,$20,$47,$52,$41,$56,$49,$54,$59,$20,$48,$4F ; 8F09
        .byte   $4C,$44,$2E                     ; 8F19

; ----------------------------------------------------------------------------
        .byte   $07,$00,$59,$4F,$55,$20,$47,$4F,$54,$20,$57,$41,$54,$45,$52,$20 ; 8F1C
        .byte   $57,$41,$56,$45,$2E,$01,$00,$59,$4F,$55,$20,$47,$4F,$54,$20,$50 ; 8F2C
        .byte   $4F,$57,$45,$52,$20,$53,$54,$4F,$4E,$45,$2E,$06,$00,$59,$4F,$55 ; 8F3C
        .byte   $20,$47,$4F,$54,$20,$47,$59,$52,$4F,$20,$41,$54,$54,$41,$43,$4B ; 8F4C
        .byte   $5C,$2B,$0D,$41,$4E,$44,$5C,$2B,$4B,$52,$55,$53,$48,$20,$4A,$45 ; 8F5C
        .byte   $54,$2E,$02,$0B,$59,$4F,$55,$20,$47,$4F,$54,$20,$53,$54,$41,$52 ; 8F6C
        .byte   $20,$43,$52,$41,$53,$48,$5C,$2B,$0D,$41,$4E,$44,$5C,$2B,$49,$53 ; 8F7C
        .byte   $55,$50,$45,$52,$20,$41,$52,$52,$4F,$57,$2E,$05,$09,$59,$4F,$55 ; 8F8C
        .byte   $20,$47,$4F,$54,$20,$43,$48,$41,$52,$47,$45,$20,$4B,$49,$43,$4B ; 8F9C
        .byte   $2E,$08,$00,$59,$4F,$55,$20,$47,$4F,$54,$20,$4E,$41,$50,$41,$4C ; 8FAC
        .byte   $4D,$20                         ; 8FBC

; ----------------------------------------------------------------------------
        .byte   $42,$4F,$4D                     ; 8FBE
L8FC1:  .byte   $42,$2E,$04,$00,$59,$4F,$55,$20,$47,$4F,$54,$20,$43,$52,$59,$53 ; 8FC1
        .byte   $54,$41,$4C,$20,$45,$59,$45,$2E,$03,$00 ; 8FD1
L8FDB:  .byte   $2A,$C6,$00,$00,$FF             ; 8FDB
L8FE0:  .byte   $10,$76,$21,$20,$20,$76,$21,$40 ; 8FE0

; ----------------------------------------------------------------------------
        .byte   $30,$76,$21,$98,$18,$76,$21,$C8,$D0,$76,$21,$10,$B8,$76,$21,$50 ; 8FE8
        .byte   $C8,$76,$21,$88,$C0,$76,$21,$C8,$30,$77,$21,$20,$18,$77,$21,$60 ; 8FF8
        .byte   $08,$77,$21,$B0,$28,$77,$21,$D8,$C8,$77,$21,$20,$E8,$77,$21,$30 ; 9008
        .byte   $B0,$77,$21,$B8,$E0,$77,$21,$D0,$F8,$00,$00,$00 ; 9018
L9024:  .byte   $33,$8E,$01,$C4,$33,$8E,$41,$CC,$3B,$8E,$81,$C4,$3B,$8E,$C1,$CC ; 9024
L9034:  .byte   $33,$33,$73                     ; 9034
L9037:  .byte   $C4,$D4,$C4                     ; 9037
L903A:  .byte   $00,$00,$04                     ; 903A
L903D:  .byte   $00,$00,$08,$08,$00,$00,$08,$08 ; 903D
L9045:  .byte   $00,$08,$00,$08,$00,$18,$00,$18 ; 9045
L904D:  .byte   $2B,$3B,$4B,$5B,$6B,$7B         ; 904D
L9053:  .byte   $34,$44,$54,$64,$74             ; 9053
L9058:  .byte   $84                             ; 9058
L9059:  .byte   $01                             ; 9059
L905A:  .byte   $FA,$FF,$06,$01,$FA,$00,$00,$FF,$06 ; 905A
L9063:  .byte   $2F,$3F,$4F,$5F,$6F,$7F         ; 9063
L9069:  .byte   $38,$48,$58,$68,$78,$88         ; 9069
L906F:  .byte   $8C,$8B                         ; 906F
L9071:  .byte   $02,$03                         ; 9071
L9073:  .byte   $00,$13,$26,$33,$5A             ; 9073
L9078:  .byte   $22,$E9,$0E,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20 ; 9078
        .byte   $20,$20,$FF,$22,$E9,$0E,$50,$41,$53,$53,$20,$57,$4F,$52,$44,$20 ; 9088
        .byte   $45,$52,$52,$4F,$52,$FF,$22,$EC,$08,$47,$41,$4D,$45,$20,$4F,$56 ; 9098
        .byte   $45,$52,$FF,$22,$CB,$0B,$53,$54,$41,$47,$45,$20,$53,$45,$4C,$45 ; 90A8
        .byte   $43,$54,$22,$EC,$08,$20,$20,$20,$20,$20,$20,$20,$20,$20,$23,$0B ; 90B8
        .byte   $07,$43,$4F,$4E,$54,$49,$4E,$55,$45,$FF,$22,$EB,$09,$43,$4F,$4E ; 90C8
        .byte   $54,$49,$4E,$55,$45,$20,$20,$FF ; 90D8
L90E0:  .byte   $00,$05,$0E                     ; 90E0
L90E3:  .byte   $03                             ; 90E3
L90E4:  .byte   $18,$64,$4C,$30,$07             ; 90E4

; ----------------------------------------------------------------------------
        bvc     L90F7                           ; 90E9 50 0C                    P.
        sty     $68                             ; 90EB 84 68                    .h
        .byte   $80                             ; 90ED 80                       .
        jmp     (L5408)                         ; 90EE 6C 08 54                 l.T

; ----------------------------------------------------------------------------
        .byte   $07                             ; 90F1 07                       .
        dey                                     ; 90F2 88                       .
        .byte   $44                             ; 90F3 44                       D
        bit     $2810                           ; 90F4 2C 10 28                 ,.(
L90F7:  .byte   $14                             ; 90F7 14                       .
        rti                                     ; 90F8 40                       @

; ----------------------------------------------------------------------------
        .byte   $8C,$03                         ; 90F9
L90FB:  .byte   $78,$04,$04,$78,$07,$20,$3C,$3C,$20,$38,$24,$38,$24,$07,$70,$74 ; 90FB
        .byte   $74,$70,$58,$5C,$58,$5C         ; 910B
L9111:  .byte   $07                             ; 9111
L9112:  .byte   $00,$01,$00,$06,$00,$02,$0B,$05,$09,$08,$00,$04,$00,$03,$00 ; 9112
L9121:  .byte   $2F                             ; 9121
L9122:  .byte   $38,$2F,$48,$2F,$58,$2F,$68,$2F,$78,$2F,$88,$3F,$38,$3F,$48,$3F ; 9122
        .byte   $58,$3F,$68,$3F,$78,$3F,$88,$4F,$38,$4F,$48,$4F,$58,$4F,$68,$4F ; 9132
        .byte   $78,$4F,$88,$5F,$38,$5F,$48,$5F,$58,$5F,$68,$5F,$78,$5F,$88,$6F ; 9142
        .byte   $38,$6F,$48,$6F,$58,$6F,$68,$6F,$78,$6F,$88,$7F,$38,$7F,$48,$7F ; 9152
        .byte   $58,$7F,$68,$7F                 ; 9162
L9166:  .byte   $78,$7F,$88                     ; 9166
L9169:  .byte   $09                             ; 9169
L916A:  .byte   $05                             ; 916A
L916B:  .byte   $01                             ; 916B
L916C:  .byte   $14                             ; 916C
L916D:  .byte   $0A                             ; 916D
L916E:  .byte   $01,$0B,$07,$02,$42,$0D,$03,$11,$0C,$04,$20,$13,$05,$0F,$08,$06 ; 916E
        .byte   $1A                             ; 917E
L917F:  .byte   $0E,$06,$08,$03,$07,$15,$0A,$07,$0B,$03,$08,$1B,$07,$08,$10,$08 ; 917F
        .byte   $09,$1B,$0D,$0A,$0F,$07,$0B,$1B ; 918F
        .byte   $10,$0C,$0E,$04,$0D,$15,$08,$0D,$0F,$08,$0E,$16,$0B,$0E,$0E,$07 ; 9197
        .byte   $0F,$1C,$0C,$0F,$00,$00,$00,$00,$00,$00,$0D,$09,$10,$1A,$0E,$13 ; 91A7
        .byte   $0D,$04,$11,$17,$09,$14,$00,$00,$00,$03,$01,$12,$00,$00,$00,$00 ; 91B7
        .byte   $00,$00                         ; 91C7
; --- L91C9: copyright screen (boot): “CAPCOM CO.,LTD.” / license text
; from L9213, palette L9262, shown $78 frames.
L91C9:  jsr     palette_fade_out                           ; 91C9 20 F1 C3                  ..
        jsr     entity_clear_all                           ; 91CC 20 9D C3                  ..
        jsr     oam_clear                           ; 91CF 20 8F C3                  ..
        jsr     scroll_irq_reset                           ; 91D2 20 B8 C3                  ..
        jsr     frame_wait                           ; 91D5 20 22 FF                  ".
        jsr     disable_rendering                           ; 91D8 20 D1 C2                  ..
        jsr     stage_state_init                           ; 91DB 20 F2 F3                  ..
        lda     #$20                            ; 91DE A9 20                    . 
        ldx     #$00                            ; 91E0 A2 00                    ..
        ldy     #$00                            ; 91E2 A0 00                    ..
        jsr     ppu_fill_nametable                           ; 91E4 20 43 C3                  C.
        ldy     #$4F                            ; 91E7 A0 4F                    .O
L91E9:  lda     L9213,y                         ; 91E9 B9 13 92                 ...
        sta     $0780,y                         ; 91EC 99 80 07                 ...
        dey                                     ; 91EF 88                       .
        bpl     L91E9                           ; 91F0 10 F7                    ..
        jsr     nametable_flush                           ; 91F2 20 98 C2                  ..
        ldy     #$0F                            ; 91F5 A0 0F                    ..
L91F7:  lda     L9262,y                         ; 91F7 B9 62 92                 .b.
        sta     $0620,y                         ; 91FA 99 20 06                 . .
        dey                                     ; 91FD 88                       .
        bpl     L91F7                           ; 91FE 10 F7                    ..
        lda     #$C2                            ; 9200 A9 C2                    ..
        sta     $EA                             ; 9202 85 EA                    ..
        lda     #$C0                            ; 9204 A9 C0                    ..
        sta     $EB                             ; 9206 85 EB                    ..
        jsr     enable_rendering                           ; 9208 20 DB C2                  ..
        jsr     palette_fade_in                           ; 920B 20 EB C3                  ..
        lda     #$78                            ; 920E A9 78                    .x
        jmp     LFF24                           ; 9210 4C 24 FF                 L$.

; ----------------------------------------------------------------------------
L9213:  .byte   $21,$04,$16,$F5,$00,$43,$41,$50,$43,$4F,$4D,$20,$43,$4F,$2E,$2C ; 9213
        .byte   $20,$4C,$54,$44                 ; 9223

; ----------------------------------------------------------------------------
        rol     $3120                           ; 9227 2E 20 31                 . 1
        and     $3239,y                         ; 922A 39 39 32                 992
        and     ($43,x)                         ; 922D 21 43                    !C
        ora     $F5,y                           ; 922F 19 F5 00                 ...
        .byte   $43                             ; 9232 43                       C
        eor     ($50,x)                         ; 9233 41 50                    AP
        .byte   $43                             ; 9235 43                       C
        .byte   $4F                             ; 9236 4F                       O
        eor     $5520                           ; 9237 4D 20 55                 M U
        rol     $2E53                           ; 923A 2E 53 2E                 .S.
        eor     ($2E,x)                         ; 923D 41 2E                    A.
        bit     $4920                           ; 923F 2C 20 49                 , I
        lsr     $2E43                           ; 9242 4E 43 2E                 NC.
        jsr     L3931                           ; 9245 20 31 39                  19
        and     L2232,y                         ; 9248 39 32 22                 92"
        asl     $13                             ; 924B 06 13                    ..
        jmp     L4349                           ; 924D 4C 49 43                 LIC

; ----------------------------------------------------------------------------
        .byte   $45,$4E,$53,$45,$44,$20,$42,$59,$20,$4E,$49,$4E,$54,$45,$4E,$44 ; 9250
        .byte   $4F,$FF                         ; 9260
L9262:  .byte   $0F,$20,$0F,$0F,$0F,$20,$0F,$0F,$0F,$20,$0F,$0F,$0F,$20,$0F,$0F ; 9262
; --- L9272: PROTO CASTLE MAP. Castle exterior ($23=$01, palette record
; L9822+$00), entrance flash + fanfare (L965D), then $26=$6C=$08 and the
; approach path: one segment per cleared stage (bits of $6F low nibble)
; drawn instantly via L97A3 — each also inc $26/$6C to the next stage —
; then the newest segment animated dot-by-dot (L97EA). Returns with $26 =
; next castle stage for stage_load. Music $0F.
L9272:  jsr     palette_fade_out                           ; 9272 20 F1 C3                  ..
        jsr     oam_clear                           ; 9275 20 8F C3                  ..
        jsr     scroll_irq_reset                           ; 9278 20 B8 C3                  ..
        jsr     stage_state_init                           ; 927B 20 F2 F3                  ..
        jsr     frame_wait                           ; 927E 20 22 FF                  ".
        jsr     disable_rendering                           ; 9281 20 D1 C2                  ..
        ldy     #$00                            ; 9284 A0 00                    ..
        jsr     L968A                           ; 9286 20 8A 96                  ..
        lda     #$00                            ; 9289 A9 00                    ..
        sta     $10                             ; 928B 85 10                    ..
        lda     #$01                            ; 928D A9 01                    ..
        sta     $23                             ; 928F 85 23                    .#
        jsr     LDAFC                           ; 9291 20 FC DA                  ..
        jsr     enable_rendering                           ; 9294 20 DB C2                  ..
        jsr     frame_wait                           ; 9297 20 22 FF                  ".
        lda     #$0F                            ; 929A A9 0F                    ..
        jsr     queue_sound_param                           ; 929C 20 5B EC                  [.
        jsr     palette_fade_in                           ; 929F 20 EB C3                  ..
        jsr     L965D                           ; 92A2 20 5D 96                  ].
        lda     #$08                            ; 92A5 A9 08                    ..
        sta     $26                             ; 92A7 85 26                    .&
        sta     $6C                             ; 92A9 85 6C                    .l
        ldy     #$00                            ; 92AB A0 00                    ..
        lda     #$20                            ; 92AD A9 20                    . 
        sta     $9F                             ; 92AF 85 9F                    ..
        jsr     L96CA                           ; 92B1 20 CA 96                  ..
        ldy     #$00                            ; 92B4 A0 00                    ..
        lda     $6F                             ; 92B6 A5 6F                    .o
        and     #$0F                            ; 92B8 29 0F                    ).
        jsr     L97A3                           ; 92BA 20 A3 97                  ..
        jsr     L9601                           ; 92BD 20 01 96                  ..
        lda     #$3C                            ; 92C0 A9 3C                    .<
        jsr     L9614                           ; 92C2 20 14 96                  ..
        jsr     L97EA                           ; 92C5 20 EA 97                  ..
        lda     #$B4                            ; 92C8 A9 B4                    ..
        jmp     L9614                           ; 92CA 4C 14 96                 L..

; ----------------------------------------------------------------------------
; --- L92CD: WILY CASTLE MAP (skull castle, $23=$00, palette record +$12,
; sprites L985E block $20). Same scheme from $26=$6C=$0C using the $6F
; high nibble. Music $10. L92FD is the entry used by the L9331 cutscene.
L92CD:  jsr     palette_fade_out                           ; 92CD 20 F1 C3                  ..
        jsr     oam_clear                           ; 92D0 20 8F C3                  ..
        jsr     scroll_irq_reset                           ; 92D3 20 B8 C3                  ..
        jsr     stage_state_init                           ; 92D6 20 F2 F3                  ..
        jsr     frame_wait                           ; 92D9 20 22 FF                  ".
        jsr     disable_rendering                           ; 92DC 20 D1 C2                  ..
        ldy     #$12                            ; 92DF A0 12                    ..
        jsr     L968A                           ; 92E1 20 8A 96                  ..
        lda     #$00                            ; 92E4 A9 00                    ..
        sta     $10                             ; 92E6 85 10                    ..
        sta     $23                             ; 92E8 85 23                    .#
        jsr     LDAFC                           ; 92EA 20 FC DA                  ..
        ldy     #$20                            ; 92ED A0 20                    . 
        lda     #$18                            ; 92EF A9 18                    ..
        jsr     L96CA                           ; 92F1 20 CA 96                  ..
        jsr     enable_rendering                           ; 92F4 20 DB C2                  ..
        jsr     frame_wait                           ; 92F7 20 22 FF                  ".
        jsr     palette_fade_in                           ; 92FA 20 EB C3                  ..
L92FD:  lda     #$10                            ; 92FD A9 10                    ..
        jsr     queue_sound_param                           ; 92FF 20 5B EC                  [.
        jsr     L965D                           ; 9302 20 5D 96                  ].
        lda     #$0C                            ; 9305 A9 0C                    ..
        sta     $26                             ; 9307 85 26                    .&
        sta     $6C                             ; 9309 85 6C                    .l
        ldy     #$20                            ; 930B A0 20                    . 
        lda     #$38                            ; 930D A9 38                    .8
        sta     $9F                             ; 930F 85 9F                    ..
        jsr     L96CA                           ; 9311 20 CA 96                  ..
        ldy     #$04                            ; 9314 A0 04                    ..
        lda     $6F                             ; 9316 A5 6F                    .o
        lsr     a                               ; 9318 4A                       J
        lsr     a                               ; 9319 4A                       J
        lsr     a                               ; 931A 4A                       J
        lsr     a                               ; 931B 4A                       J
        and     #$0F                            ; 931C 29 0F                    ).
        jsr     L97A3                           ; 931E 20 A3 97                  ..
        jsr     L9601                           ; 9321 20 01 96                  ..
        lda     #$3C                            ; 9324 A9 3C                    .<
        jsr     L9614                           ; 9326 20 14 96                  ..
        jsr     L97EA                           ; 9329 20 EA 97                  ..
        lda     #$B4                            ; 932C A9 B4                    ..
        jmp     L9614                           ; 932E 4C 14 96                 L..

; ----------------------------------------------------------------------------
; --- L9331: PROTO-4 ESCAPE CUTSCENE ($6C=$0B, after Dark Man 4). On the
; darkened castle screen ($23=$06 via column loader LDB23) three dialog
; pages run in the message window (L96DB teletype + L976F frame). Then
; the castle screen is redrawn and Wily's escape plays out with menu
; actors: the saucer stack (slots 1-3, kept aligned by L959D) emerges
; (sub $5D drops in), hovers $B4 frames, dips, then flies the scripted
; L9935 path (speed/dir/frames/shape records, morphing to sub $60 at the
; end) while the castle quakes (L95B6) and the palette dims (L95D8);
; when the script ends the scene chains into the Wily castle map (L92FD).
L9331:  jsr     L96BB                           ; 9331 20 BB 96                  ..
        sty     $18                             ; 9334 84 18                    ..
        lda     #$B4                            ; 9336 A9 B4                    ..
        sta     $0378                           ; 9338 8D 78 03                 .x.
        lda     #$38                            ; 933B A9 38                    .8
        sta     $0330                           ; 933D 8D 30 03                 .0.
        jsr     entity_clear_all                           ; 9340 20 9D C3                  ..
        jsr     render_tick_frame                           ; 9343 20 63 F3                  c.
        lda     #$00                            ; 9346 A9 00                    ..
        sta     $05F2                           ; 9348 8D F2 05                 ...
        sta     $2D                             ; 934B 85 2D                    .-
        sta     $2E                             ; 934D 85 2E                    ..
        sta     $2F                             ; 934F 85 2F                    ./
        lda     #$0F                            ; 9351 A9 0F                    ..
        sta     $A9                             ; 9353 85 A9                    ..
        jsr     palette_fade_out                           ; 9355 20 F1 C3                  ..
        lda     #$01                            ; 9358 A9 01                    ..
        jsr     set_mirroring                           ; 935A 20 B7 FF                  ..
        lda     #$06                            ; 935D A9 06                    ..
        sta     $23                             ; 935F 85 23                    .#
        lda     #$28                            ; 9361 A9 28                    .(
        sta     $10                             ; 9363 85 10                    ..
        jsr     LDB23                           ; 9365 20 23 DB                  #.
        lda     #$02                            ; 9368 A9 02                    ..
        sta     $FD                             ; 936A 85 FD                    ..
        lda     #$C2                            ; 936C A9 C2                    ..
        sta     $EA                             ; 936E 85 EA                    ..
        lda     #$C0                            ; 9370 A9 C0                    ..
        sta     $EB                             ; 9372 85 EB                    ..
        lda     #$20                            ; 9374 A9 20                    . 
        sta     $0601                           ; 9376 8D 01 06                 ...
        jsr     L96BB                           ; 9379 20 BB 96                  ..
        lda     #$FF                            ; 937C A9 FF                    ..
        sta     $18                             ; 937E 85 18                    ..
        ldy     #$00                            ; 9380 A0 00                    ..
        jsr     L96DB                           ; 9382 20 DB 96                  ..
        ldx     #$00                            ; 9385 A2 00                    ..
        ldy     #$02                            ; 9387 A0 02                    ..
L9389:  lda     L98D5,y                         ; 9389 B9 D5 98                 ...
        jsr     entity_init_pos                           ; 938C 20 A4 EA                  ..
        lda     #$00                            ; 938F A9 00                    ..
        sta     $0528,y                         ; 9391 99 28 05                 .(.
        lda     #$6D                            ; 9394 A9 6D                    .m
        sta     L0300,y                         ; 9396 99 00 03                 ...
        lda     #$C0                            ; 9399 A9 C0                    ..
        sta     $0330,y                         ; 939B 99 30 03                 .0.
        lda     L98D7,y                         ; 939E B9 D7 98                 ...
        sta     $0378,y                         ; 93A1 99 78 03                 .x.
        lda     #$80                            ; 93A4 A9 80                    ..
        sta     $03A8,y                         ; 93A6 99 A8 03                 ...
        lda     #$00                            ; 93A9 A9 00                    ..
        sta     $03C0,y                         ; 93AB 99 C0 03                 ...
        lda     #$50                            ; 93AE A9 50                    .P
        sta     $03D8,y                         ; 93B0 99 D8 03                 ...
        lda     #$00                            ; 93B3 A9 00                    ..
        sta     $03F0,y                         ; 93B5 99 F0 03                 ...
        dey                                     ; 93B8 88                       .
        bne     L9389                           ; 93B9 D0 CE                    ..
        lda     #$3C                            ; 93BB A9 3C                    .<
        jsr     L9754                           ; 93BD 20 54 97                  T.
        jsr     L976F                           ; 93C0 20 6F 97                  o.
        ldy     #$01                            ; 93C3 A0 01                    ..
        jsr     L96DB                           ; 93C5 20 DB 96                  ..
        lda     #$3C                            ; 93C8 A9 3C                    .<
        jsr     L9754                           ; 93CA 20 54 97                  T.
        jsr     L976F                           ; 93CD 20 6F 97                  o.
        ldy     #$02                            ; 93D0 A0 02                    ..
        jsr     L96DB                           ; 93D2 20 DB 96                  ..
        lda     #$3C                            ; 93D5 A9 3C                    .<
        jsr     L9754                           ; 93D7 20 54 97                  T.
        jsr     L976F                           ; 93DA 20 6F 97                  o.
        lda     #$0F                            ; 93DD A9 0F                    ..
        sta     $0601                           ; 93DF 8D 01 06                 ...
        lda     #$FF                            ; 93E2 A9 FF                    ..
        sta     $18                             ; 93E4 85 18                    ..
        jsr     frame_wait                           ; 93E6 20 22 FF                  ".
        ldy     #$12                            ; 93E9 A0 12                    ..
        jsr     L968A                           ; 93EB 20 8A 96                  ..
        lda     #$00                            ; 93EE A9 00                    ..
        sta     $EC                             ; 93F0 85 EC                    ..
        jsr     L96BB                           ; 93F2 20 BB 96                  ..
        lda     #$20                            ; 93F5 A9 20                    . 
        sta     $10                             ; 93F7 85 10                    ..
        lda     #$00                            ; 93F9 A9 00                    ..
        sta     $23                             ; 93FB 85 23                    .#
        jsr     LDB23                           ; 93FD 20 23 DB                  #.
L9400:  ldx     #$01                            ; 9400 A2 01                    ..
        jsr     entity_move_up_nofacing                           ; 9402 20 4A E9                  J.
        jsr     entity_move_left_collide                           ; 9405 20 0C E9                  ..
        lda     $0379                           ; 9408 AD 79 03                 .y.
        sec                                     ; 940B 38                       8
        sbc     #$10                            ; 940C E9 10                    ..
        sta     $037A                           ; 940E 8D 7A 03                 .z.
        lda     $0331                           ; 9411 AD 31 03                 .1.
        sta     $0332                           ; 9414 8D 32 03                 .2.
        jsr     L95B6                           ; 9417 20 B6 95                  ..
        lda     $0332                           ; 941A AD 32 03                 .2.
        cmp     #$80                            ; 941D C9 80                    ..
        bne     L9400                           ; 941F D0 DF                    ..
        lda     #$68                            ; 9421 A9 68                    .h
        sta     $0379                           ; 9423 8D 79 03                 .y.
        lda     #$58                            ; 9426 A9 58                    .X
        sta     $037A                           ; 9428 8D 7A 03                 .z.
        ldy     #$03                            ; 942B A0 03                    ..
        ldx     #$01                            ; 942D A2 01                    ..
        lda     #$5D                            ; 942F A9 5D                    .]
        jsr     entity_init_pos                           ; 9431 20 A4 EA                  ..
        lda     #$6D                            ; 9434 A9 6D                    .m
        sta     L0300,y                         ; 9436 99 00 03                 ...
        lda     #$00                            ; 9439 A9 00                    ..
        sta     $0378,y                         ; 943B 99 78 03                 .x.
        sta     $03D8,y                         ; 943E 99 D8 03                 ...
        sta     $03D9                           ; 9441 8D D9 03                 ...
        sta     $03DA                           ; 9444 8D DA 03                 ...
        lda     #$03                            ; 9447 A9 03                    ..
        sta     $03F0,y                         ; 9449 99 F0 03                 ...
        sta     $03F1                           ; 944C 8D F1 03                 ...
        sta     $03F2                           ; 944F 8D F2 03                 ...
L9452:  ldx     #$03                            ; 9452 A2 03                    ..
        jsr     entity_move_down_collide                           ; 9454 20 2A E9                  *.
        lda     #$54                            ; 9457 A9 54                    .T
        cmp     $0378,y                         ; 9459 D9 78 03                 .x.
        bcs     L9461                           ; 945C B0 03                    ..
        sta     $0378,y                         ; 945E 99 78 03                 .x.
L9461:  jsr     L95B6                           ; 9461 20 B6 95                  ..
        lda     $037B                           ; 9464 AD 7B 03                 .{.
        cmp     #$54                            ; 9467 C9 54                    .T
        bne     L9452                           ; 9469 D0 E7                    ..
        lda     #$3C                            ; 946B A9 3C                    .<
        jsr     L95CE                           ; 946D 20 CE 95                  ..
L9470:  ldx     #$03                            ; 9470 A2 03                    ..
L9472:  jsr     entity_move_up_nofacing                           ; 9472 20 4A E9                  J.
        dex                                     ; 9475 CA                       .
        bne     L9472                           ; 9476 D0 FA                    ..
        jsr     L95B6                           ; 9478 20 B6 95                  ..
        lda     $0391                           ; 947B AD 91 03                 ...
        beq     L9470                           ; 947E F0 F0                    ..
        lda     #$78                            ; 9480 A9 78                    .x
        jsr     L95CE                           ; 9482 20 CE 95                  ..
        lda     #$10                            ; 9485 A9 10                    ..
        sta     $0E                             ; 9487 85 0E                    ..
        sta     $0D                             ; 9489 85 0D                    ..
        jsr     L95D8                           ; 948B 20 D8 95                  ..
        lda     #$F8                            ; 948E A9 F8                    ..
        sta     $0379                           ; 9490 8D 79 03                 .y.
        lda     #$E8                            ; 9493 A9 E8                    ..
        sta     $037A                           ; 9495 8D 7A 03                 .z.
        lda     #$E4                            ; 9498 A9 E4                    ..
        sta     $037B                           ; 949A 8D 7B 03                 .{.
        lda     #$00                            ; 949D A9 00                    ..
        sta     $0391                           ; 949F 8D 91 03                 ...
        sta     $0392                           ; 94A2 8D 92 03                 ...
        sta     $0393                           ; 94A5 8D 93 03                 ...
        sta     L0300                           ; 94A8 8D 00 03                 ...
        lda     #$30                            ; 94AB A9 30                    .0
        sta     $0E                             ; 94AD 85 0E                    ..
        lda     #$F0                            ; 94AF A9 F0                    ..
        sta     $0D                             ; 94B1 85 0D                    ..
        jsr     L95D8                           ; 94B3 20 D8 95                  ..
L94B6:  ldx     #$03                            ; 94B6 A2 03                    ..
L94B8:  jsr     entity_move_up_nofacing                           ; 94B8 20 4A E9                  J.
        dex                                     ; 94BB CA                       .
        bne     L94B8                           ; 94BC D0 FA                    ..
        jsr     L95B6                           ; 94BE 20 B6 95                  ..
        lda     $037B                           ; 94C1 AD 7B 03                 .{.
        cmp     #$63                            ; 94C4 C9 63                    .c
        bne     L94B6                           ; 94C6 D0 EE                    ..
        lda     #$78                            ; 94C8 A9 78                    .x
        jsr     L95CE                           ; 94CA 20 CE 95                  ..
        lda     #$01                            ; 94CD A9 01                    ..
        sta     $03F3                           ; 94CF 8D F3 03                 ...
L94D2:  ldx     #$03                            ; 94D2 A2 03                    ..
        jsr     entity_move_up_nofacing                           ; 94D4 20 4A E9                  J.
        jsr     L95B6                           ; 94D7 20 B6 95                  ..
        lda     $037B                           ; 94DA AD 7B 03                 .{.
        cmp     #$53                            ; 94DD C9 53                    .S
        bne     L94D2                           ; 94DF D0 F1                    ..
        lda     #$B4                            ; 94E1 A9 B4                    ..
        sta     $0F                             ; 94E3 85 0F                    ..
L94E5:  jsr     L95BD                           ; 94E5 20 BD 95                  ..
        dec     $0F                             ; 94E8 C6 0F                    ..
        bne     L94E5                           ; 94EA D0 F9                    ..
        lda     #$00                            ; 94EC A9 00                    ..
        sta     $0541                           ; 94EE 8D 41 05                 .A.
L94F1:  ldx     #$03                            ; 94F1 A2 03                    ..
        jsr     entity_move_down_collide                           ; 94F3 20 2A E9                  *.
        jsr     L95B6                           ; 94F6 20 B6 95                  ..
        lda     $037B                           ; 94F9 AD 7B 03                 .{.
        cmp     #$63                            ; 94FC C9 63                    .c
        bne     L94F1                           ; 94FE D0 F1                    ..
        lda     #$00                            ; 9500 A9 00                    ..
        sta     $0469                           ; 9502 8D 69 04                 .i.
        sta     $0481                           ; 9505 8D 81 04                 ...
L9508:  ldx     #$03                            ; 9508 A2 03                    ..
        lda     $046B                           ; 950A AD 6B 04                 .k.
        bne     L9555                           ; 950D D0 46                    .F
        ldy     $0483                           ; 950F AC 83 04                 ...
        lda     L9935,y                         ; 9512 B9 35 99                 .5.
        beq     L958A                           ; 9515 F0 73                    .s
        pha                                     ; 9517 48                       H
        lda     L9937,y                         ; 9518 B9 37 99                 .7.
        sta     $046B                           ; 951B 8D 6B 04                 .k.
        lda     L9938,y                         ; 951E B9 38 99                 .8.
        sta     $0543                           ; 9521 8D 43 05                 .C.
        lda     L9936,y                         ; 9524 B9 36 99                 .6.
        tay                                     ; 9527 A8                       .
        pla                                     ; 9528 68                       h
        jsr     entity_set_dir_velocity                           ; 9529 20 70 F4                  p.
        inc     $0483                           ; 952C EE 83 04                 ...
        inc     $0483                           ; 952F EE 83 04                 ...
        inc     $0483                           ; 9532 EE 83 04                 ...
        inc     $0483                           ; 9535 EE 83 04                 ...
        lda     $0483                           ; 9538 AD 83 04                 ...
        cmp     #$34                            ; 953B C9 34                    .4
        bne     L9555                           ; 953D D0 16                    ..
        lda     #$00                            ; 953F A9 00                    ..
        sta     $0301                           ; 9541 8D 01 03                 ...
        sta     $0302                           ; 9544 8D 02 03                 ...
        lda     #$60                            ; 9547 A9 60                    .`
        jsr     entity_set_subtype                           ; 9549 20 98 EA                  ..
        lda     $037B                           ; 954C AD 7B 03                 .{.
        clc                                     ; 954F 18                       .
        adc     #$0C                            ; 9550 69 0C                    i.
        sta     $037B                           ; 9552 8D 7B 03                 .{.
L9555:  jsr     entity_facing_dispatch                           ; 9555 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; 9558 20 86 EA                  ..
        jsr     L959D                           ; 955B 20 9D 95                  ..
        dec     $046B                           ; 955E CE 6B 04                 .k.
        lda     $FD                             ; 9561 A5 FD                    ..
        ora     $FA                             ; 9563 05 FA                    ..
        beq     L9577                           ; 9565 F0 10                    ..
        inc     $FA                             ; 9567 E6 FA                    ..
        inc     $FA                             ; 9569 E6 FA                    ..
        lda     $FA                             ; 956B A5 FA                    ..
        cmp     #$F0                            ; 956D C9 F0                    ..
        bne     L9577                           ; 956F D0 06                    ..
        lda     #$00                            ; 9571 A9 00                    ..
        sta     $FD                             ; 9573 85 FD                    ..
        sta     $FA                             ; 9575 85 FA                    ..
L9577:  lda     #$00                            ; 9577 A9 00                    ..
        sta     $9D                             ; 9579 85 9D                    ..
        sta     $0571                           ; 957B 8D 71 05                 .q.
        sta     $0572                           ; 957E 8D 72 05                 .r.
        sta     $0573                           ; 9581 8D 73 05                 .s.
        jsr     L95B6                           ; 9584 20 B6 95                  ..
        jmp     L9508                           ; 9587 4C 08 95                 L..

; ----------------------------------------------------------------------------
L958A:  ldy     #$12                            ; 958A A0 12                    ..
        jsr     L968A                           ; 958C 20 8A 96                  ..
        lda     #$FF                            ; 958F A9 FF                    ..
        sta     $18                             ; 9591 85 18                    ..
        ldy     #$20                            ; 9593 A0 20                    . 
        lda     #$18                            ; 9595 A9 18                    ..
        jsr     L96CA                           ; 9597 20 CA 96                  ..
        jmp     L92FD                           ; 959A 4C FD 92                 L..

; ----------------------------------------------------------------------------
; --- L959D: sync the saucer's two shadow slots: copy slot 3 X to slots
; 1/2 and stack their Y positions 4/20 px above it.
L959D:  lda     $0333                           ; 959D AD 33 03                 .3.
        sta     $0331                           ; 95A0 8D 31 03                 .1.
        sta     $0332                           ; 95A3 8D 32 03                 .2.
        lda     $037B                           ; 95A6 AD 7B 03                 .{.
        clc                                     ; 95A9 18                       .
        adc     #$04                            ; 95AA 69 04                    i.
        sta     $037A                           ; 95AC 8D 7A 03                 .z.
        clc                                     ; 95AF 18                       .
        adc     #$10                            ; 95B0 69 10                    i.
        sta     $0379                           ; 95B2 8D 79 03                 .y.
        rts                                     ; 95B5 60                       `

; ----------------------------------------------------------------------------
; --- L95B6: quake tick: render frame + rumble sound ($19) every 16
; frames of $48.
L95B6:  lda     #$00                            ; 95B6 A9 00                    ..
        sta     $9D                             ; 95B8 85 9D                    ..
        sta     $0572                           ; 95BA 8D 72 05                 .r.
L95BD:  jsr     render_tick_frame                           ; 95BD 20 63 F3                  c.
        inc     $48                             ; 95C0 E6 48                    .H
        lda     $48                             ; 95C2 A5 48                    .H
        and     #$0F                            ; 95C4 29 0F                    ).
        bne     L95CD                           ; 95C6 D0 05                    ..
        lda     #$19                            ; 95C8 A9 19                    ..
        jsr     queue_sound                           ; 95CA 20 5D EC                  ].
L95CD:  rts                                     ; 95CD 60                       `

; ----------------------------------------------------------------------------
; --- L95CE: A frames of quake.
L95CE:  sta     $0F                             ; 95CE 85 0F                    ..
L95D0:  jsr     L95B6                           ; 95D0 20 B6 95                  ..
        dec     $0F                             ; 95D3 C6 0F                    ..
        bne     L95D0                           ; 95D5 D0 F9                    ..
        rts                                     ; 95D7 60                       `

; ----------------------------------------------------------------------------
; --- L95D8: darken the whole palette in 4 steps of $0E (start step $0E,
; increment $0D), 4 quake frames apart.
L95D8:  lda     #$04                            ; 95D8 A9 04                    ..
        sta     $0C                             ; 95DA 85 0C                    ..
L95DC:  ldy     #$1F                            ; 95DC A0 1F                    ..
L95DE:  lda     $0620,y                         ; 95DE B9 20 06                 . .
        sec                                     ; 95E1 38                       8
        sbc     $0E                             ; 95E2 E5 0E                    ..
        bcs     L95E8                           ; 95E4 B0 02                    ..
        lda     #$0F                            ; 95E6 A9 0F                    ..
L95E8:  sta     $0600,y                         ; 95E8 99 00 06                 ...
        dey                                     ; 95EB 88                       .
        bpl     L95DE                           ; 95EC 10 F0                    ..
        sty     $18                             ; 95EE 84 18                    ..
        lda     #$04                            ; 95F0 A9 04                    ..
        jsr     L95CE                           ; 95F2 20 CE 95                  ..
        lda     $0E                             ; 95F5 A5 0E                    ..
        clc                                     ; 95F7 18                       .
        adc     $0D                             ; 95F8 65 0D                    e.
        sta     $0E                             ; 95FA 85 0E                    ..
        dec     $0C                             ; 95FC C6 0C                    ..
        bne     L95DC                           ; 95FE D0 DC                    ..
        rts                                     ; 9600 60                       `

; ----------------------------------------------------------------------------
; --- L9601: init the castle-map palette/sprite animator: per-map record
; ptr from L9B22 (+$6C*2) into $08/$09.
L9601:  lda     $6C                             ; 9601 A5 6C                    .l
        asl     a                               ; 9603 0A                       .
        tay                                     ; 9604 A8                       .
        lda     L9B22,y                         ; 9605 B9 22 9B                 .".
        sta     $08                             ; 9608 85 08                    ..
        lda     L9B23,y                         ; 960A B9 23 9B                 .#.
        sta     $09                             ; 960D 85 09                    ..
        lda     #$00                            ; 960F A9 00                    ..
        sta     $9D                             ; 9611 85 9D                    ..
        rts                                     ; 9613 60                       `

; ----------------------------------------------------------------------------
; --- L9614: run the map for A frames while cycling the animated sprites:
; frame index from $9D via the L9B42 sequence table, sprite tile/attr
; strips from L9B43 -> L9B50 records into $0200+ (torch flames etc.).
L9614:  sta     $0C                             ; 9614 85 0C                    ..
        stx     $0D                             ; 9616 86 0D                    ..
        sty     $0E                             ; 9618 84 0E                    ..
L961A:  ldy     $09                             ; 961A A4 09                    ..
        lda     $9D                             ; 961C A5 9D                    ..
        lsr     a                               ; 961E 4A                       J
        lsr     a                               ; 961F 4A                       J
        and     #$0F                            ; 9620 29 0F                    ).
        cmp     L9B42,y                         ; 9622 D9 42 9B                 .B.
        bcc     L962B                           ; 9625 90 04                    ..
        lda     #$00                            ; 9627 A9 00                    ..
        sta     $9D                             ; 9629 85 9D                    ..
L962B:  clc                                     ; 962B 18                       .
        adc     $09                             ; 962C 65 09                    e.
        tay                                     ; 962E A8                       .
        ldx     L9B43,y                         ; 962F BE 43 9B                 .C.
        lda     L9B50,x                         ; 9632 BD 50 9B                 .P.
        sta     $0B                             ; 9635 85 0B                    ..
        ldy     $08                             ; 9637 A4 08                    ..
L9639:  lda     L9B51,x                         ; 9639 BD 51 9B                 .Q.
        sta     $0201,y                         ; 963C 99 01 02                 ...
        lda     L9B52,x                         ; 963F BD 52 9B                 .R.
        sta     $0202,y                         ; 9642 99 02 02                 ...
        iny                                     ; 9645 C8                       .
        iny                                     ; 9646 C8                       .
        iny                                     ; 9647 C8                       .
        iny                                     ; 9648 C8                       .
        inx                                     ; 9649 E8                       .
        inx                                     ; 964A E8                       .
        dec     $0B                             ; 964B C6 0B                    ..
        bpl     L9639                           ; 964D 10 EA                    ..
        inc     $9D                             ; 964F E6 9D                    ..
        jsr     frame_wait                           ; 9651 20 22 FF                  ".
        dec     $0C                             ; 9654 C6 0C                    ..
        bne     L961A                           ; 9656 D0 C2                    ..
        ldx     $0D                             ; 9658 A6 0D                    ..
        ldy     $0E                             ; 965A A4 0E                    ..
        rts                                     ; 965C 60                       `

; ----------------------------------------------------------------------------
; --- L965D: castle-arrival flash: 8 screen flashes (BG palette ^= $3F)
; with fanfare ($17).
L965D:  lda     #$00                            ; 965D A9 00                    ..
        jsr     LFF24                           ; 965F 20 24 FF                  $.
        lda     #$00                            ; 9662 A9 00                    ..
        jsr     LFF24                           ; 9664 20 24 FF                  $.
        lda     #$02                            ; 9667 A9 02                    ..
        sta     $02                             ; 9669 85 02                    ..
        lda     #$17                            ; 966B A9 17                    ..
        jsr     queue_sound                           ; 966D 20 5D EC                  ].
        lda     #$08                            ; 9670 A9 08                    ..
        sta     $03                             ; 9672 85 03                    ..
L9674:  lda     $0610                           ; 9674 AD 10 06                 ...
        eor     #$3F                            ; 9677 49 3F                    I?
        sta     $0610                           ; 9679 8D 10 06                 ...
        lda     #$FF                            ; 967C A9 FF                    ..
        sta     $18                             ; 967E 85 18                    ..
        lda     #$08                            ; 9680 A9 08                    ..
        jsr     LFF24                           ; 9682 20 24 FF                  $.
        dec     $03                             ; 9685 C6 03                    ..
        bne     L9674                           ; 9687 D0 EB                    ..
        rts                                     ; 9689 60                       `

; ----------------------------------------------------------------------------
; --- L968A: castle map palette record loader (L9822+Y: 2 CHR banks +
; 16 BG colors, sprite rows fixed from L9846).
L968A:  lda     L9822,y                         ; 968A B9 22 98                 .".
        sta     $EA                             ; 968D 85 EA                    ..
        lda     L9823,y                         ; 968F B9 23 98                 .#.
        sta     $EB                             ; 9692 85 EB                    ..
        lda     #$08                            ; 9694 A9 08                    ..
        sta     $EC                             ; 9696 85 EC                    ..
        ldx     #$00                            ; 9698 A2 00                    ..
L969A:  lda     L9824,y                         ; 969A B9 24 98                 .$.
        sta     $0620,x                         ; 969D 9D 20 06                 . .
        sta     $0600,x                         ; 96A0 9D 00 06                 ...
        lda     L9846,x                         ; 96A3 BD 46 98                 .F.
        sta     $0630,x                         ; 96A6 9D 30 06                 .0.
        sta     $0610,x                         ; 96A9 9D 10 06                 ...
        iny                                     ; 96AC C8                       .
        inx                                     ; 96AD E8                       .
        cpx     #$10                            ; 96AE E0 10                    ..
        bne     L969A                           ; 96B0 D0 E8                    ..
        lda     #$11                            ; 96B2 A9 11                    ..
        sta     L0027                           ; 96B4 85 27                    .'
        lda     #$10                            ; 96B6 A9 10                    ..
        sta     $26                             ; 96B8 85 26                    .&
        rts                                     ; 96BA 60                       `

; ----------------------------------------------------------------------------
; --- L96BB: load the 8-color row L9856 (dialog/dark rows) into $0610/$0630.
L96BB:  ldy     #$07                            ; 96BB A0 07                    ..
L96BD:  lda     L9856,y                         ; 96BD B9 56 98                 .V.
        sta     $0610,y                         ; 96C0 99 10 06                 ...
        sta     $0630,y                         ; 96C3 99 30 06                 .0.
        dey                                     ; 96C6 88                       .
        bpl     L96BD                           ; 96C7 10 F4                    ..
        rts                                     ; 96C9 60                       `

; ----------------------------------------------------------------------------
; --- L96CA: copy A bytes of OAM data from L985E+Y to $0200.
L96CA:  sta     L0000                           ; 96CA 85 00                    ..
        ldx     #$00                            ; 96CC A2 00                    ..
L96CE:  lda     L985E,y                         ; 96CE B9 5E 98                 .^.
        sta     L0200,x                         ; 96D1 9D 00 02                 ...
        iny                                     ; 96D4 C8                       .
        inx                                     ; 96D5 E8                       .
        cpx     L0000                           ; 96D6 E4 00                    ..
        bne     L96CE                           ; 96D8 D0 F4                    ..
        rts                                     ; 96DA 60                       `

; ----------------------------------------------------------------------------
; --- L96DB: teletype dialog writer, page Y (ptrs L9B7A/L9B7D): chars
; into the message window at PPU $28E4+, one per 8 frames; $DE takes a
; second glyph byte, $00 = skip a column, $FE = next line (+$40),
; $FF = end of page.
L96DB:  lda     #$28                            ; 96DB A9 28                    .(
        ldx     #$E4                            ; 96DD A2 E4                    ..
        sta     $0780                           ; 96DF 8D 80 07                 ...
        sta     $0C                             ; 96E2 85 0C                    ..
        stx     $0781                           ; 96E4 8E 81 07                 ...
        stx     $0D                             ; 96E7 86 0D                    ..
        lda     L9B7A,y                         ; 96E9 B9 7A 9B                 .z.
        sta     $08                             ; 96EC 85 08                    ..
        lda     L9B7D,y                         ; 96EE B9 7D 9B                 .}.
        sta     $09                             ; 96F1 85 09                    ..
        ldy     #$00                            ; 96F3 A0 00                    ..
L96F5:  ldx     #$00                            ; 96F5 A2 00                    ..
        lda     ($08),y                         ; 96F7 B1 08                    ..
        beq     L9732                           ; 96F9 F0 37                    .7
        cmp     #$FE                            ; 96FB C9 FE                    ..
        beq     L973B                           ; 96FD F0 3C                    .<
        cmp     #$FF                            ; 96FF C9 FF                    ..
        beq     L9753                           ; 9701 F0 50                    .P
        sta     $0783                           ; 9703 8D 83 07                 ...
        jsr     L9769                           ; 9706 20 69 97                  i.
        lda     ($08),y                         ; 9709 B1 08                    ..
        cmp     #$DE                            ; 970B C9 DE                    ..
        bne     L9716                           ; 970D D0 07                    ..
        sta     $0784                           ; 970F 8D 84 07                 ...
        jsr     L9769                           ; 9712 20 69 97                  i.
        inx                                     ; 9715 E8                       .
L9716:  stx     $0782                           ; 9716 8E 82 07                 ...
        lda     #$FF                            ; 9719 A9 FF                    ..
        sta     $0784,x                         ; 971B 9D 84 07                 ...
        sta     $19                             ; 971E 85 19                    ..
        lda     #$08                            ; 9720 A9 08                    ..
        jsr     L9754                           ; 9722 20 54 97                  T.
L9725:  lda     $0781                           ; 9725 AD 81 07                 ...
        sec                                     ; 9728 38                       8
        adc     $0782                           ; 9729 6D 82 07                 m..
        sta     $0781                           ; 972C 8D 81 07                 ...
        jmp     L96F5                           ; 972F 4C F5 96                 L..

; ----------------------------------------------------------------------------
L9732:  sta     $0782                           ; 9732 8D 82 07                 ...
        jsr     L9769                           ; 9735 20 69 97                  i.
        jmp     L9725                           ; 9738 4C 25 97                 L%.

; ----------------------------------------------------------------------------
L973B:  jsr     L9769                           ; 973B 20 69 97                  i.
        lda     $0D                             ; 973E A5 0D                    ..
        clc                                     ; 9740 18                       .
        adc     #$40                            ; 9741 69 40                    i@
        sta     $0D                             ; 9743 85 0D                    ..
        sta     $0781                           ; 9745 8D 81 07                 ...
        lda     $0C                             ; 9748 A5 0C                    ..
        adc     #$00                            ; 974A 69 00                    i.
        sta     $0C                             ; 974C 85 0C                    ..
        sta     $0780                           ; 974E 8D 80 07                 ...
        bne     L96F5                           ; 9751 D0 A2                    ..
L9753:  rts                                     ; 9753 60                       `

; ----------------------------------------------------------------------------
; --- L9754: run the scene A frames (render_tick_frame, Y preserved).
L9754:  sty     $0B                             ; 9754 84 0B                    ..
        sta     $0A                             ; 9756 85 0A                    ..
L9758:  lda     #$00                            ; 9758 A9 00                    ..
        sta     $9D                             ; 975A 85 9D                    ..
        sta     $0572                           ; 975C 8D 72 05                 .r.
        jsr     render_tick_frame                           ; 975F 20 63 F3                  c.
        dec     $0A                             ; 9762 C6 0A                    ..
        bne     L9758                           ; 9764 D0 F2                    ..
        ldy     $0B                             ; 9766 A4 0B                    ..
L9768:  rts                                     ; 9768 60                       `

; ----------------------------------------------------------------------------
L9769:  iny                                     ; 9769 C8                       .
        bne     L9768                           ; 976A D0 FC                    ..
        inc     $11                             ; 976C E6 11                    ..
        rts                                     ; 976E 60                       `

; ----------------------------------------------------------------------------
; --- L976F: draw the message window frame (L98DA rows + corner fixups).
L976F:  ldy     #$5B                            ; 976F A0 5B                    .[
L9771:  lda     L98DA,y                         ; 9771 B9 DA 98                 ...
        sta     $0780,y                         ; 9774 99 80 07                 ...
        dey                                     ; 9777 88                       .
        bpl     L9771                           ; 9778 10 F7                    ..
        sty     $19                             ; 977A 84 19                    ..
        jsr     frame_wait                           ; 977C 20 22 FF                  ".
        lda     #$29                            ; 977F A9 29                    .)
        sta     $0780                           ; 9781 8D 80 07                 ...
        lda     #$A4                            ; 9784 A9 A4                    ..
        sta     $0781                           ; 9786 8D 81 07                 ...
        lda     #$29                            ; 9789 A9 29                    .)
        sta     $079E                           ; 978B 8D 9E 07                 ...
        lda     #$E4                            ; 978E A9 E4                    ..
        sta     $079F                           ; 9790 8D 9F 07                 ...
        lda     #$2A                            ; 9793 A9 2A                    .*
        sta     $07BC                           ; 9795 8D BC 07                 ...
        lda     #$24                            ; 9798 A9 24                    .$
        sta     $07BD                           ; 979A 8D BD 07                 ...
        dec     $19                             ; 979D C6 19                    ..
        jsr     frame_wait                           ; 979F 20 22 FF                  ".
        rts                                     ; 97A2 60                       `

; ----------------------------------------------------------------------------
; --- L97A3: draw castle-path progress: A = cleared-stage bitmask; for
; each set bit draw path segment $11's sprite run (ptr L99D6/L99DE:
; count + OAM bytes appended at $9F cursor) and inc $26/$6C to the next
; stage; then light the path palette rows (L98B6).
L97A3:  sta     $10                             ; 97A3 85 10                    ..
        sty     $11                             ; 97A5 84 11                    ..
L97A7:  lda     L99D6,y                         ; 97A7 B9 D6 99                 ...
        sta     $02                             ; 97AA 85 02                    ..
        lda     L99DE,y                         ; 97AC B9 DE 99                 ...
        sta     $03                             ; 97AF 85 03                    ..
        ldy     #$00                            ; 97B1 A0 00                    ..
        lda     ($02),y                         ; 97B3 B1 02                    ..
        sta     L0004                           ; 97B5 85 04                    ..
        lsr     $10                             ; 97B7 46 10                    F.
        bcc     L97D9                           ; 97B9 90 1E                    ..
        inc     $26                             ; 97BB E6 26                    .&
        inc     $6C                             ; 97BD E6 6C                    .l
        iny                                     ; 97BF C8                       .
        ldx     $9F                             ; 97C0 A6 9F                    ..
        lda     L0004                           ; 97C2 A5 04                    ..
        beq     L97D1                           ; 97C4 F0 0B                    ..
L97C6:  lda     ($02),y                         ; 97C6 B1 02                    ..
        sta     L0200,x                         ; 97C8 9D 00 02                 ...
        iny                                     ; 97CB C8                       .
        inx                                     ; 97CC E8                       .
        dec     L0004                           ; 97CD C6 04                    ..
        bne     L97C6                           ; 97CF D0 F5                    ..
L97D1:  stx     $9F                             ; 97D1 86 9F                    ..
        inc     $11                             ; 97D3 E6 11                    ..
        ldy     $11                             ; 97D5 A4 11                    ..
        bne     L97A7                           ; 97D7 D0 CE                    ..
L97D9:  ldy     #$1F                            ; 97D9 A0 1F                    ..
L97DB:  lda     L98B6,y                         ; 97DB B9 B6 98                 ...
        sta     $0600,y                         ; 97DE 99 00 06                 ...
        sta     $0620,y                         ; 97E1 99 20 06                 . .
        dey                                     ; 97E4 88                       .
        bpl     L97DB                           ; 97E5 10 F4                    ..
        sty     $18                             ; 97E7 84 18                    ..
        rts                                     ; 97E9 60                       `

; ----------------------------------------------------------------------------
; --- L97EA: animate the next path segment (index $11): its sprites appear
; 4 at a time with the step sound ($18), 4 animated frames between bursts.
L97EA:  ldy     $11                             ; 97EA A4 11                    ..
        lda     L99D6,y                         ; 97EC B9 D6 99                 ...
        sta     $02                             ; 97EF 85 02                    ..
        lda     L99DE,y                         ; 97F1 B9 DE 99                 ...
        sta     $03                             ; 97F4 85 03                    ..
        ldy     #$00                            ; 97F6 A0 00                    ..
        lda     ($02),y                         ; 97F8 B1 02                    ..
        beq     L9821                           ; 97FA F0 25                    .%
        sta     L0004                           ; 97FC 85 04                    ..
        ldx     $9F                             ; 97FE A6 9F                    ..
        iny                                     ; 9800 C8                       .
L9801:  lda     #$04                            ; 9801 A9 04                    ..
        sta     $05                             ; 9803 85 05                    ..
        lda     #$18                            ; 9805 A9 18                    ..
        jsr     queue_sound                           ; 9807 20 5D EC                  ].
L980A:  lda     ($02),y                         ; 980A B1 02                    ..
        sta     L0200,x                         ; 980C 9D 00 02                 ...
        iny                                     ; 980F C8                       .
        inx                                     ; 9810 E8                       .
        dec     L0004                           ; 9811 C6 04                    ..
        beq     L9821                           ; 9813 F0 0C                    ..
        dec     $05                             ; 9815 C6 05                    ..
        bne     L980A                           ; 9817 D0 F1                    ..
        lda     #$04                            ; 9819 A9 04                    ..
        jsr     L9614                           ; 981B 20 14 96                  ..
        jmp     L9801                           ; 981E 4C 01 98                 L..

; ----------------------------------------------------------------------------
L9821:  rts                                     ; 9821 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; CASTLE MAP DATA — $9822-$9FFF
;   $9822 palette records for L968A (+$00 Proto castle, +$12 Wily skull)
;   $9846/$9856 fixed sprite/dialog palette rows
;   $985E OAM blocks for L96CA (+$00 Proto castle base, +$20 skull)
;   $98B6 lit path palette (32 bytes), $98D5/$98D7 saucer actor types/Y
;   $98DA message window frame rows
;   $9935 saucer flight script: 4-byte steps (speed preset, dir, frames,
;         shape), $00 = end
;   $99D6/$99DE castle path segment sprite-run pointers, runs follow
;   $9B22 map animator records (L9601): $9B42 sequence + $9B43/$9B50
;         sprite strip records
;   $9B7A/$9B7D dialog page pointers, ASCII pages follow ($9B80-$9E05)
;   $9E06-$9FFF castle map screen patches / sprite runs for the cutscene
; =============================================================================
L9822:  .byte   $D8                             ; 9822
L9823:  .byte   $DA                             ; 9823
L9824:  .byte   $0F,$20,$25,$16,$0F,$20,$21,$13,$0F,$20,$21,$16,$0F,$20,$27,$16 ; 9824
        .byte   $DC,$DE,$0F,$20,$24,$12,$0F,$20,$2C,$12,$0F,$20,$29,$12,$0F,$20 ; 9834
        .byte   $26,$16                         ; 9844
L9846:  .byte   $0F,$20,$29,$0A,$0F,$20,$16,$0A,$0F,$0F,$20,$36,$0F,$0F,$20,$16 ; 9846
L9856:  .byte   $0F,$0F,$2C,$11                 ; 9856
L985A:  .byte   $0F,$0F,$20,$37                 ; 985A
L985E:  .byte   $B7,$24,$03,$18                 ; 985E
L9862:  .byte   $A7,$24,$03,$40                 ; 9862

; ----------------------------------------------------------------------------
        .byte   $87,$24,$03,$70,$6F,$24,$03,$C0,$3F,$21,$03,$BC ; 9866
L9872:  .byte   $3F,$21,$43,$C4,$47,$31,$02,$BC,$47,$31,$42,$C4,$77,$28,$01,$78 ; 9872
        .byte   $77,$29,$01,$80,$7F,$2A,$00,$78,$7F,$2B,$00,$80,$87,$2C,$40,$78 ; 9882
        .byte   $87,$2C,$00,$80,$5F,$24,$03,$18,$87,$24,$03,$40 ; 9892

; ----------------------------------------------------------------------------
        .byte   $97,$24,$03,$A0,$97,$24,$03,$B0,$BB,$1C,$02,$C8,$BB,$1C,$42,$D0 ; 989E
        .byte   $C3,$1E,$02,$C8,$C3,$1E,$42,$D0 ; 98AE
L98B6:  .byte   $0F,$11,$0C,$01,$0F,$11,$0C,$01,$0F,$11,$0C,$01,$0F,$11,$0C,$01 ; 98B6
        .byte   $0F,$00,$11,$00,$0F,$00,$11,$00,$0F,$0F,$20,$36,$0F,$0F,$20 ; 98C6
L98D5:  .byte   $16,$5E                         ; 98D5
L98D7:  .byte   $5F,$90,$80                     ; 98D7
L98DA:  .byte   $28,$E4,$1A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 98DA
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$29,$24 ; 98EA
        .byte   $1A,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 98FA
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$29,$64,$1A,$00 ; 990A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 991A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF ; 992A
L9935:  .byte   $28                             ; 9935
L9936:  .byte   $03                             ; 9936
L9937:  .byte   $11                             ; 9937
L9938:  .byte   $00,$28,$02,$07,$00,$28,$01,$04,$00,$28,$00,$03,$00,$28,$0F,$04 ; 9938
        .byte   $00,$28,$0E,$07,$00,$28,$0D,$0B,$00,$28,$0C,$10,$00,$28,$0B,$0B ; 9948
        .byte   $00,$28,$0A,$07,$00,$28,$09,$04,$00,$28,$08,$03,$00,$08,$07,$08 ; 9958
        .byte   $00,$08,$06,$08,$00,$08,$05,$10,$00,$08,$04,$18,$00,$08,$05,$10 ; 9968
        .byte   $00,$08,$06,$04,$00,$08,$07,$04,$00,$08,$08,$02,$00,$20,$09,$04 ; 9978
        .byte   $01,$20,$0A,$04,$01,$20,$0B,$0C,$01,$20,$0C,$30,$01,$20,$0B,$0C ; 9988
        .byte   $01,$20,$0A,$04,$01,$20,$09,$04,$01,$20,$08,$02,$01,$20,$07,$02 ; 9998
        .byte   $02,$20,$06,$02,$02,$20,$05,$06,$02,$20,$04,$10,$02,$20,$05,$06 ; 99A8
        .byte   $02,$20,$06,$02,$02,$20,$07,$02,$02,$20,$08,$02,$02,$20,$09,$02 ; 99B8
        .byte   $02,$20,$0A,$02,$02,$20,$0B,$02,$02,$20,$0C,$02,$03,$00 ; 99C8
L99D6:  .byte   $E6,$FF,$24,$65,$76,$B3,$10,$15 ; 99D6
L99DE:  .byte   $99,$99,$9A,$9A,$9A,$9A,$9B,$9B,$18,$B7,$26,$02,$20,$B7,$26,$02 ; 99DE
        .byte   $28,$B7,$27,$C2,$30,$AF,$25,$02,$30,$A7,$27,$02,$30,$A7,$26,$02 ; 99EE
        .byte   $38,$24,$A7,$26,$02,$48,$A7,$26,$02,$50,$A7,$26,$02,$58,$A7,$27 ; 99FE
        .byte   $C2,$60                         ; 9A0E

; ----------------------------------------------------------------------------
        .byte   $9F                             ; 9A10 9F                       .
        and     $02                             ; 9A11 25 02                    %.
        rts                                     ; 9A13 60                       `

; ----------------------------------------------------------------------------
        .byte   $97                             ; 9A14 97                       .
        and     $02                             ; 9A15 25 02                    %.
        rts                                     ; 9A17 60                       `

; ----------------------------------------------------------------------------
        .byte   $8F                             ; 9A18 8F                       .
        and     $02                             ; 9A19 25 02                    %.
        rts                                     ; 9A1B 60                       `

; ----------------------------------------------------------------------------
        .byte   $87                             ; 9A1C 87                       .
        .byte   $27                             ; 9A1D 27                       '
        .byte   $02                             ; 9A1E 02                       .
        rts                                     ; 9A1F 60                       `

; ----------------------------------------------------------------------------
        .byte   $87                             ; 9A20 87                       .
        rol     $02                             ; 9A21 26 02                    &.
        pla                                     ; 9A23 68                       h
        rti                                     ; 9A24 40                       @

; ----------------------------------------------------------------------------
        .byte   $87,$26,$02,$78,$87,$26,$02,$80,$87,$26,$02,$88,$87,$27,$C2,$90 ; 9A25
        .byte   $7F,$25,$02,$90,$77,$25,$02,$90,$6F,$25,$02,$90,$67,$25,$02,$90 ; 9A35
        .byte   $5F,$27,$02,$90,$5F,$26,$02,$98,$5F,$26,$02,$A0,$5F,$26,$02,$A8 ; 9A45
        .byte   $5F,$27,$42,$B0,$67,$25,$02,$B0,$6F,$27,$82,$B0,$6F,$26,$02,$B8 ; 9A55
        .byte   $10,$67,$25,$02,$C0,$5F,$25,$02,$C0,$57,$25,$02,$C0,$4F,$25,$02 ; 9A65
        .byte   $C0,$3C,$67,$25,$02,$18,$6F,$25,$02,$18,$77,$25,$02,$18,$7F,$25 ; 9A75
        .byte   $02,$18,$87,$25,$02,$18,$8F,$25,$02,$18,$97,$25,$02,$18,$9F,$27 ; 9A85
        .byte   $82,$18,$9F,$26                 ; 9A95
L9A99:  .byte   $02,$20,$9F,$26,$02,$28,$9F,$27,$C2,$30,$97,$25,$02,$30,$8F,$25 ; 9A99
        .byte   $02,$30,$87,$27,$02,$30,$87,$26,$02,$38,$5C,$87,$26,$02,$48,$87 ; 9AA9
        .byte   $27,$42,$50,$8F,$25,$02,$50,$97,$25,$02,$50,$9F,$25,$02,$50,$A7 ; 9AB9
        .byte   $25,$02,$50,$AF,$27,$82,$50,$AF,$26,$02,$58,$AF,$26,$02,$60 ; 9AC9

; ----------------------------------------------------------------------------
        .byte   $AF,$26,$02,$68,$AF,$27,$C2,$70,$A7,$27,$02,$70,$A7,$26,$02,$78 ; 9AD8
        .byte   $A7,$27,$42,$80,$AF,$25,$02,$80,$B7,$27,$82,$80,$B7,$26,$02,$88 ; 9AE8
        .byte   $B7,$26,$02,$90,$B7,$27,$C2,$98,$AF,$25,$02,$98,$A7,$25,$02,$98 ; 9AF8
        .byte   $9F,$25,$02,$98,$97,$27,$02,$98,$04,$97,$26,$02,$A8,$1C,$97,$27 ; 9B08
        .byte   $42,$B8,$9F,$25,$02,$B8,$A7,$25,$02,$B8 ; 9B18
L9B22:  .byte   $AF                             ; 9B22
L9B23:  .byte   $25,$02,$B8,$B7,$25,$02,$B8,$BF,$27,$82,$B8,$BF,$26,$02,$C0,$04 ; 9B23
        .byte   $00,$08,$00,$0C,$00,$10,$0A,$1C,$00,$20,$00,$24,$00,$28,$05 ; 9B33
L9B42:  .byte   $04                             ; 9B42
L9B43:  .byte   $00,$00,$03,$03,$04,$06,$06,$0F,$0F,$03,$18,$18,$21 ; 9B43
L9B50:  .byte   $00                             ; 9B50
L9B51:  .byte   $24                             ; 9B51
L9B52:  .byte   $03,$00,$23,$02,$03,$1C,$02,$1C,$42,$1E,$02,$1E,$42,$03,$1D,$42 ; 9B52
        .byte   $1D,$02,$1F,$42,$1F,$02,$03,$21,$03,$21,$43,$31,$02,$31,$42,$03 ; 9B62
        .byte   $22,$43,$22,$03,$32,$42,$32,$02 ; 9B72
L9B7A:  .byte   $80,$D7,$4E                     ; 9B7A
L9B7D:  .byte   $9B,$9B,$9C,$59,$4F,$55,$27,$56,$45,$20,$44,$4F,$4E,$45,$20,$57 ; 9B7D
        .byte   $45,$4C,$4C,$2C,$20             ; 9B8D

; ----------------------------------------------------------------------------
        .byte   $4D,$45,$47,$41,$20,$4D,$41,$4E,$21,$FE,$49,$20,$4E,$45,$56,$45 ; 9B92
        .byte   $52,$20,$45,$58,$50,$45,$43,$54,$45,$44,$20,$59,$4F,$55,$20,$54 ; 9BA2
        .byte   $4F,$FE,$44,$45,$46,$45,$41,$54,$20,$4D,$59,$20,$50,$4F,$57,$45 ; 9BB2
        .byte   $52,$46,$55,$4C,$20,$44         ; 9BC2

; ----------------------------------------------------------------------------
        .byte   $41,$52,$4B,$4D,$41,$4E,$FE,$52,$4F,$42,$4F,$54,$21,$21,$FF,$55 ; 9BC8
        .byte   $4E,$54,$49,$4C,$20,$4E,$4F,$57,$20,$49,$20,$48,$41,$56,$45,$20 ; 9BD8
        .byte   $4D,$41,$4E,$41,$47,$45,$44,$FE,$54,$4F,$20,$46,$52,$41,$4D,$45 ; 9BE8
        .byte   $20,$50,$52,$4F,$54,$4F,$4D,$41,$4E,$20,$46,$4F,$52,$20,$4D,$59 ; 9BF8
        .byte   $FE,$43,$52,$49,$4D,$45,$53,$2C,$20,$42,$55,$54,$20,$4E,$4F,$57 ; 9C08
        .byte   $20,$54,$48,$45,$20,$52,$45,$41,$4C,$FE,$50 ; 9C18

; ----------------------------------------------------------------------------
        .byte   $52,$4F,$54,$4F,$4D,$41,$4E,$20,$48,$41,$53,$20,$41,$50,$50,$45 ; 9C23
        .byte   $41,$52,$45,$44,$20,$41,$4E,$44,$FE,$53,$50,$4F,$49,$4C,$45,$44 ; 9C33
        .byte   $20,$4D,$59,$20,$50,$4C,$41,$4E,$21,$21,$FF,$44,$52,$2E,$4C,$49 ; 9C43
        .byte   $47,$48,$54,$20,$49,$53,$20,$41,$20,$43,$41,$50,$54,$49,$56,$45 ; 9C53
        .byte   $20,$49,$4E,$FE,$4D,$59,$20,$4C,$41,$42,$2E,$FE,$43,$4F,$4D,$45 ; 9C63
        .byte   $20,$49,$46,$20,$59,$4F,$55,$20,$44,$41,$52,$45,$21,$21,$FE,$48 ; 9C73
        .byte   $41,$2C,$20,$48,$41,$2C,$20,$48,$41,$2E,$FF,$00,$00,$00,$00,$00 ; 9C83
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00 ; 9C93
        .byte   $00,$00,$40                     ; 9CA3

; ----------------------------------------------------------------------------
        .byte   $00,$00,$20,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00 ; 9CA6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9CB6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9CC6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$40,$01 ; 9CD6
        .byte   $29,$50,$30,$10,$C2,$41,$20,$08,$10,$10,$40,$01,$18,$02,$80,$10 ; 9CE6
        .byte   $00,$04,$41,$00,$40,$50,$00,$50,$48,$10,$00,$04,$00,$00,$00,$00 ; 9CF6
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00 ; 9D06
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40 ; 9D16

; ----------------------------------------------------------------------------
        .byte   $04,$08,$00,$20,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D21
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00 ; 9D31
        .byte   $00,$00,$00,$00,$00,$00         ; 9D41
L9D47:  .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D47
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40 ; 9D57

; ----------------------------------------------------------------------------
        .byte   $00,$10,$10,$00,$00,$01,$00,$00,$10,$14,$09,$00,$40 ; 9D62

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$22,$08,$24,$00,$40 ; 9D6F

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00 ; 9D77
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9D87
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00 ; 9D97
        .byte   $10,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$20 ; 9DA7
        .byte   $40,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9DB7
        .byte   $00,$00,$00,$02,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$01,$01 ; 9DC7
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$00,$21,$00,$28 ; 9DD7
        .byte   $00,$08,$41,$04,$00,$11,$41,$00,$40 ; 9DE7

; ----------------------------------------------------------------------------
        .byte   $00,$04,$06,$04,$20,$00,$02,$00,$40 ; 9DF0

; ----------------------------------------------------------------------------
        ora     (L0000),y                       ; 9DF9 11 00                    ..
        rti                                     ; 9DFB 40                       @

; ----------------------------------------------------------------------------
        .byte   $00,$04,$C0,$01,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$10 ; 9DFC
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E0C
        .byte   $00,$00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$04,$04 ; 9E1C
        .byte   $00,$00,$00,$00,$80,$00,$00,$00,$00,$04,$00,$00,$00,$00,$20,$00 ; 9E2C
        .byte   $00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00 ; 9E3C
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E4C
        .byte   $00,$00,$00,$00,$C0,$00,$00,$40 ; 9E5C

; ----------------------------------------------------------------------------
        jsr     L8014                           ; 9E64 20 14 80                  ..
        rti                                     ; 9E67 40                       @

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$10,$00,$00,$00,$60 ; 9E68

; ----------------------------------------------------------------------------
        .byte   $03,$08,$00,$00,$00,$00,$00,$20,$04,$00,$01,$00,$00,$00,$00,$00 ; 9E77
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9E87
        .byte   $00,$00,$00,$40                 ; 9E97

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40 ; 9E9B

; ----------------------------------------------------------------------------
        .byte   $20,$00,$80,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00 ; 9EA8
        .byte   $08,$00,$00,$00,$00,$10,$40,$01,$00,$00,$00,$00,$02,$00,$00,$00 ; 9EB8
        .byte   $00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00 ; 9EC8
        .byte   $00,$04,$00,$00,$00,$00,$00,$00,$10,$00,$08,$00,$10,$00,$80,$41 ; 9ED8
        .byte   $02,$00,$22,$44,$01,$00,$20,$18,$04,$10,$00,$00,$45,$00,$02,$00 ; 9EE8
        .byte   $00,$00,$18,$44,$00,$05,$01,$00,$00,$00,$00,$00,$08,$00,$00,$00 ; 9EF8
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00 ; 9F08
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$40 ; 9F18

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F21
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F31
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00,$00,$00,$00,$00 ; 9F41
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00 ; 9F51
        .byte   $00,$40                         ; 9F61

; ----------------------------------------------------------------------------
        .byte   $00,$00,$04,$10,$40,$00,$00,$20,$04,$00,$00,$00,$00,$20,$40,$00 ; 9F63
        .byte   $40                             ; 9F73

; ----------------------------------------------------------------------------
        .byte   $00,$80,$00,$80,$00,$40         ; 9F74

; ----------------------------------------------------------------------------
        .byte   $08,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F7A
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 9F8A
        .byte   $00,$00,$00,$00,$00,$00,$00,$10,$02,$00,$04,$00,$00,$00,$04,$04 ; 9F9A
        .byte   $00,$04,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00 ; 9FAA
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$40 ; 9FBA

; ----------------------------------------------------------------------------
        .byte   $00,$20,$00,$00,$04,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00 ; 9FC3
        .byte   $00,$00,$00,$00,$04,$80,$00,$00,$00,$00,$00,$00,$00,$02,$00,$00 ; 9FD3
        .byte   $00,$10,$00,$00,$10,$80,$00,$00,$00,$00,$00,$C0,$00,$12,$00,$30 ; 9FE3
        .byte   $00,$00,$00,$40                 ; 9FF3

; ----------------------------------------------------------------------------
        .byte   $00,$00,$00,$0C,$00,$00,$00,$10,$00 ; 9FF7
