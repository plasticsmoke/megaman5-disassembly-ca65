.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK01"

; =============================================================================
; BANK $01 (mapped at $8000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
; =============================================================================
L0000           := $0000
L0010           := $0010
L00A2           := $00A2
L0422           := $0422
L056D           := $056D
L0600           := $0600
L064D           := $064D
L0A00           := $0A00
L0B00           := $0B00
L0F07           := $0F07
L0F0F           := $0F0F
L0F11           := $0F11
L0F14           := $0F14
L0F16           := $0F16
L0F1A           := $0F1A
L0F26           := $0F26
L0F2C           := $0F2C
L0F37           := $0F37
L1110           := $1110
L1506           := $1506
L1515           := $1515
L1827           := $1827
L1C2C           := $1C2C
L1F38           := $1F38
L1F3A           := $1F3A
L2020           := $2020
L211C           := $211C
L2120           := $2120
L2121           := $2121
L2221           := $2221
L222A           := $222A
L2322           := $2322
L2522           := $2522
L3130           := $3130
L3422           := $3422
L3722           := $3722
L3A20           := $3A20
L4443           := $4443
L4C00           := $4C00
L4C2F           := $4C2F
L4C4A           := $4C4A
L4C4B           := $4C4B
L4F66           := $4F66
L6422           := $6422
L6820           := $6820
L6D20           := $6D20
L6F82           := $6F82
LA3B0           := $A3B0
LA440           := $A440
LD000           := $D000
LD423           := $D423
LD840           := $D840
LDAFC           := $DAFC
LE000           := $E000
LFF24           := $FF24
; ----------------------------------------------------------------------------
        lda     #$00                            ; 8000 A9 00                    ..
        sta     $95                             ; 8002 85 95                    ..
        inc     $1B                             ; 8004 E6 1B                    ..
        jsr     palette_fade_out                           ; 8006 20 F1 C3                  ..
        jsr     oam_clear                           ; 8009 20 8F C3                  ..
        .byte   $20                             ; 800C 20                        
        .byte   $22                             ; 800D 22                       "
L800E:  .byte   $FF                             ; 800E FF                       .
        jsr     disable_rendering                           ; 800F 20 D1 C2                  ..
        inc     $59                             ; 8012 E6 59                    .Y
        lda     $27                             ; 8014 A5 27                    .'
        sta     $07A2                           ; 8016 8D A2 07                 ...
        lda     $26                             ; 8019 A5 26                    .&
        sta     $07A3                           ; 801B 8D A3 07                 ...
        lda     $FC                             ; 801E A5 FC                    ..
        sta     $07A4                           ; 8020 8D A4 07                 ...
        lda     $FD                             ; 8023 A5 FD                    ..
        sta     $07A5                           ; 8025 8D A5 07                 ...
        lda     $FA                             ; 8028 A5 FA                    ..
        sta     $07A6                           ; 802A 8D A6 07                 ...
        lda     $FB                             ; 802D A5 FB                    ..
        .byte   $8D                             ; 802F 8D                       .
L8030:  .byte   $A7                             ; 8030 A7                       .
        .byte   $07                             ; 8031 07                       .
        lda     $23                             ; 8032 A5 23                    .#
        sta     $07A8                           ; 8034 8D A8 07                 ...
        lda     $99                             ; 8037 A5 99                    ..
        sta     $07A9                           ; 8039 8D A9 07                 ...
        lda     #$10                            ; 803C A9 10                    ..
        sta     $27                             ; 803E 85 27                    .'
        sta     $26                             ; 8040 85 26                    .&
        ldy     $2C                             ; 8042 A4 2C                    .,
        lda     L8522,y                         ; 8044 B9 22 85                 .".
        sta     L0010                           ; 8047 85 10                    ..
        lda     #$00                            ; 8049 A9 00                    ..
        sta     $FC                             ; 804B 85 FC                    ..
        sta     $FA                             ; 804D 85 FA                    ..
        sta     $99                             ; 804F 85 99                    ..
        sta     $23                             ; 8051 85 23                    .#
        jsr     LDAFC                           ; 8053 20 FC DA                  ..
        ldy     #$05                            ; 8056 A0 05                    ..
L8058:  lda     $EA,y                           ; 8058 B9 EA 00                 ...
        sta     $07AA,y                         ; 805B 99 AA 07                 ...
        lda     L8524,y                         ; 805E B9 24 85                 .$.
        sta     $EA,y                           ; 8061 99 EA 00                 ...
        dey                                     ; 8064 88                       .
        bpl     L8058                           ; 8065 10 F1                    ..
        ldy     #$1F                            ; 8067 A0 1F                    ..
L8069:  .byte   $B9                             ; 8069 B9                       .
L806A:  jsr     $9906                           ; 806A 20 06 99                  ..
        .byte   $B0,$07                    ; 806D B0 07   (branch out of range for ca65: target has no local label)
        .byte   $B9                             ; 806F B9                       .
L8070:  rol     a                               ; 8070 2A                       *
        sta     $99                             ; 8071 85 99                    ..
        jsr     $8806                           ; 8073 20 06 88                  ..
        bpl     L8069                           ; 8076 10 F1                    ..
        ldy     #$04                            ; 8078 A0 04                    ..
L807A:  jsr     entity_wipe_y                           ; 807A 20 FE F2                  ..
        dey                                     ; 807D 88                       .
        .byte   $D0                             ; 807E D0                       .
L807F:  .byte   $FA                             ; 807F FA                       .
L8080:  jsr     L82FE                           ; 8080 20 FE 82                  ..
        jsr     L8403                           ; 8083 20 03 84                  ..
        jsr     L8488                           ; 8086 20 88 84                  ..
        jsr     L8437                           ; 8089 20 37 84                  7.
L808C:  jsr     L84E9                           ; 808C 20 E9 84                  ..
L808F:  ldx     #$00                            ; 808F A2 00                    ..
        jsr     L8375                           ; 8091 20 75 83                  u.
        lda     $2C                             ; 8094 A5 2C                    .,
        sta     $FD                             ; 8096 85 FD                    ..
        inc     $FD                             ; 8098 E6 FD                    ..
        jsr     frame_wait                           ; 809A 20 22 FF                  ".
        jsr     enable_rendering                           ; 809D 20 DB C2                  ..
        jsr     palette_fade_in                           ; 80A0 20 EB C3                  ..
L80A3:  lda     $14                             ; 80A3 A5 14                    ..
        and     #$90                            ; 80A5 29 90                    ).
        beq     L80AC                           ; 80A7 F0 03                    ..
        jmp     L8140                           ; 80A9 4C 40 81                 L@.

; ----------------------------------------------------------------------------
L80AC:  lda     $50                             ; 80AC A5 50                    .P
        sta     L0000                           ; 80AE 85 00                    ..
        lda     $14                             ; 80B0 A5 14                    ..
        and     #$0F                            ; 80B2 29 0F                    ).
        beq     L811F                           ; 80B4 F0 69                    .i
        and     #$03                            ; 80B6 29 03                    ).
        beq     L80E1                           ; 80B8 F0 27                    .'
        and     #$02                            ; 80BA 29 02                    ).
        tay                                     ; 80BC A8                       .
        lda     $50                             ; 80BD A5 50                    .P
        clc                                     ; 80BF 18                       .
        adc     L858A,y                         ; 80C0 79 8A 85                 y..
        sta     $50                             ; 80C3 85 50                    .P
        cmp     #$10                            ; 80C5 C9 10                    ..
        bcc     L80CF                           ; 80C7 90 06                    ..
        clc                                     ; 80C9 18                       .
        adc     L858B,y                         ; 80CA 79 8B 85                 y..
        sta     $50                             ; 80CD 85 50                    .P
L80CF:  ldx     $50                             ; 80CF A6 50                    .P
        lda     L8594,x                         ; 80D1 BD 94 85                 ...
        tax                                     ; 80D4 AA                       .
        lda     $B0,x                           ; 80D5 B5 B0                    ..
        bmi     L80E1                           ; 80D7 30 08                    0.
        ldy     #$04                            ; 80D9 A0 04                    ..
        lda     $14                             ; 80DB A5 14                    ..
        and     #$0C                            ; 80DD 29 0C                    ).
        beq     L80E8                           ; 80DF F0 07                    ..
L80E1:  lda     $14                             ; 80E1 A5 14                    ..
        and     #$0C                            ; 80E3 29 0C                    ).
        beq     L811B                           ; 80E5 F0 34                    .4
        tay                                     ; 80E7 A8                       .
L80E8:  lda     $50                             ; 80E8 A5 50                    .P
        pha                                     ; 80EA 48                       H
        and     #$08                            ; 80EB 29 08                    ).
        sta     $01                             ; 80ED 85 01                    ..
        pla                                     ; 80EF 68                       h
        and     #$07                            ; 80F0 29 07                    ).
        clc                                     ; 80F2 18                       .
        adc     L858A,y                         ; 80F3 79 8A 85                 y..
        sta     $50                             ; 80F6 85 50                    .P
        cmp     #$08                            ; 80F8 C9 08                    ..
        bcc     L8102                           ; 80FA 90 06                    ..
        clc                                     ; 80FC 18                       .
        adc     L858B,y                         ; 80FD 79 8B 85                 y..
        sta     $50                             ; 8100 85 50                    .P
L8102:  lda     $50                             ; 8102 A5 50                    .P
        ora     $01                             ; 8104 05 01                    ..
        sta     $50                             ; 8106 85 50                    .P
        tax                                     ; 8108 AA                       .
        lda     L8594,x                         ; 8109 BD 94 85                 ...
        tax                                     ; 810C AA                       .
        lda     $B0,x                           ; 810D B5 B0                    ..
        bpl     L80E8                           ; 810F 10 D7                    ..
        lda     $14                             ; 8111 A5 14                    ..
        and     #$0C                            ; 8113 29 0C                    ).
        bne     L811B                           ; 8115 D0 04                    ..
        cpx     #$0D                            ; 8117 E0 0D                    ..
        bcs     L80E8                           ; 8119 B0 CD                    ..
L811B:  ldy     L0000                           ; 811B A4 00                    ..
        cpy     $50                             ; 811D C4 50                    .P
L811F:  beq     L8137                           ; 811F F0 16                    ..
        lda     #$27                            ; 8121 A9 27                    .'
        jsr     queue_sound                           ; 8123 20 5D EC                  ].
L8126:  jsr     L834A                           ; 8126 20 4A 83                  J.
        lda     #$FF                            ; 8129 A9 FF                    ..
        sta     $18                             ; 812B 85 18                    ..
        lda     $50                             ; 812D A5 50                    .P
        and     #$07                            ; 812F 29 07                    ).
        cmp     #$06                            ; 8131 C9 06                    ..
        bne     L8137                           ; 8133 D0 02                    ..
        sta     $50                             ; 8135 85 50                    .P
L8137:  jsr     L8309                           ; 8137 20 09 83                  ..
        jsr     frame_wait                           ; 813A 20 22 FF                  ".
        jmp     L80A3                           ; 813D 4C A3 80                 L..

; ----------------------------------------------------------------------------
L8140:  lda     $50                             ; 8140 A5 50                    .P
        cmp     #$0F                            ; 8142 C9 0F                    ..
        beq     L8164                           ; 8144 F0 1E                    ..
        cmp     #$07                            ; 8146 C9 07                    ..
        bne     L819E                           ; 8148 D0 54                    .T
        lda     $BD                             ; 814A A5 BD                    ..
        cmp     #$80                            ; 814C C9 80                    ..
        beq     L8137                           ; 814E F0 E7                    ..
        lda     $B0                             ; 8150 A5 B0                    ..
        cmp     #$9C                            ; 8152 C9 9C                    ..
        beq     L8137                           ; 8154 F0 E1                    ..
        dec     $BD                             ; 8156 C6 BD                    ..
        ldy     #$00                            ; 8158 A0 00                    ..
        sty     $50                             ; 815A 84 50                    .P
        jsr     L8235                           ; 815C 20 35 82                  5.
        ldy     #$07                            ; 815F A0 07                    ..
        jmp     L8126                           ; 8161 4C 26 81                 L&.

; ----------------------------------------------------------------------------
L8164:  lda     $BE                             ; 8164 A5 BE                    ..
        cmp     #$80                            ; 8166 C9 80                    ..
        beq     L8137                           ; 8168 F0 CD                    ..
        lda     #$24                            ; 816A A9 24                    .$
        jsr     queue_sound                           ; 816C 20 5D EC                  ].
        ldy     #$0C                            ; 816F A0 0C                    ..
L8171:  lda     $B0,y                           ; 8171 B9 B0 00                 ...
        bpl     L8180                           ; 8174 10 0A                    ..
        cmp     #$9C                            ; 8176 C9 9C                    ..
        beq     L8180                           ; 8178 F0 06                    ..
        jsr     L82BA                           ; 817A 20 BA 82                  ..
        jmp     L8192                           ; 817D 4C 92 81                 L..

; ----------------------------------------------------------------------------
L8180:  dey                                     ; 8180 88                       .
        bpl     L8171                           ; 8181 10 EE                    ..
        jsr     LA3B0                           ; 8183 20 B0 A3                  ..
        lda     $02                             ; 8186 A5 02                    ..
        bne     L8192                           ; 8188 D0 08                    ..
        lda     $BF                             ; 818A A5 BF                    ..
        cmp     #$09                            ; 818C C9 09                    ..
        beq     L8192                           ; 818E F0 02                    ..
        inc     $BF                             ; 8190 E6 BF                    ..
L8192:  jsr     L82CE                           ; 8192 20 CE 82                  ..
        lda     #$00                            ; 8195 A9 00                    ..
        sta     $50                             ; 8197 85 50                    .P
        ldy     #$0F                            ; 8199 A0 0F                    ..
        jmp     L8126                           ; 819B 4C 26 81                 L&.

; ----------------------------------------------------------------------------
L819E:  lda     #$28                            ; 819E A9 28                    .(
        jsr     queue_sound                           ; 81A0 20 5D EC                  ].
        jsr     palette_fade_out                           ; 81A3 20 F1 C3                  ..
        jsr     oam_clear                           ; 81A6 20 8F C3                  ..
        jsr     frame_wait                           ; 81A9 20 22 FF                  ".
        jsr     disable_rendering                           ; 81AC 20 D1 C2                  ..
        lda     $07A2                           ; 81AF AD A2 07                 ...
        sta     $27                             ; 81B2 85 27                    .'
        lda     $07A3                           ; 81B4 AD A3 07                 ...
        sta     $26                             ; 81B7 85 26                    .&
        lda     $07A4                           ; 81B9 AD A4 07                 ...
        sta     $FC                             ; 81BC 85 FC                    ..
        lda     $07A5                           ; 81BE AD A5 07                 ...
        sta     $FD                             ; 81C1 85 FD                    ..
        lda     $07A6                           ; 81C3 AD A6 07                 ...
        sta     $FA                             ; 81C6 85 FA                    ..
        lda     $07A7                           ; 81C8 AD A7 07                 ...
        sta     $FB                             ; 81CB 85 FB                    ..
        lda     $07A8                           ; 81CD AD A8 07                 ...
        sta     $23                             ; 81D0 85 23                    .#
        lda     $07A9                           ; 81D2 AD A9 07                 ...
        sta     $99                             ; 81D5 85 99                    ..
        ldy     #$05                            ; 81D7 A0 05                    ..
L81D9:  lda     $07AA,y                         ; 81D9 B9 AA 07                 ...
        sta     $EA,y                           ; 81DC 99 EA 00                 ...
        dey                                     ; 81DF 88                       .
        bpl     L81D9                           ; 81E0 10 F7                    ..
        ldy     #$1F                            ; 81E2 A0 1F                    ..
L81E4:  lda     $07B0,y                         ; 81E4 B9 B0 07                 ...
        sta     $0620,y                         ; 81E7 99 20 06                 . .
        dey                                     ; 81EA 88                       .
        bpl     L81E4                           ; 81EB 10 F7                    ..
        ldy     $2C                             ; 81ED A4 2C                    .,
        lda     L8522,y                         ; 81EF B9 22 85                 .".
        sta     L0010                           ; 81F2 85 10                    ..
        jsr     LDAFC                           ; 81F4 20 FC DA                  ..
        jsr     frame_wait                           ; 81F7 20 22 FF                  ".
        ldy     $50                             ; 81FA A4 50                    .P
        lda     L85E1,y                         ; 81FC B9 E1 85                 ...
        sta     $32                             ; 81FF 85 32                    .2
        sta     $2E                             ; 8201 85 2E                    ..
        beq     L8209                           ; 8203 F0 04                    ..
        ora     #$80                            ; 8205 09 80                    ..
        sta     $2E                             ; 8207 85 2E                    ..
L8209:  lda     L85F1,y                         ; 8209 B9 F1 85                 ...
        sta     $ED                             ; 820C 85 ED                    ..
        jsr     enable_rendering                           ; 820E 20 DB C2                  ..
        jsr     palette_fade_in                           ; 8211 20 EB C3                  ..
        ldx     #$00                            ; 8214 A2 00                    ..
        stx     $1B                             ; 8216 86 1B                    ..
        stx     $59                             ; 8218 86 59                    .Y
        inc     $95                             ; 821A E6 95                    ..
        ldy     $32                             ; 821C A4 32                    .2
        beq     L8222                           ; 821E F0 02                    ..
        stx     $38                             ; 8220 86 38                    .8
L8222:  lda     $0558                           ; 8222 AD 58 05                 .X.
        cmp     #$B0                            ; 8225 C9 B0                    ..
        bne     L8234                           ; 8227 D0 0B                    ..
        lda     $32                             ; 8229 A5 32                    .2
        cmp     #$08                            ; 822B C9 08                    ..
        beq     L8234                           ; 822D F0 05                    ..
        lda     #$10                            ; 822F A9 10                    ..
        jsr     entity_set_subtype                           ; 8231 20 98 EA                  ..
L8234:  rts                                     ; 8234 60                       `

; ----------------------------------------------------------------------------
L8235:  ldx     #$12                            ; 8235 A2 12                    ..
L8237:  lda     L87D7,x                         ; 8237 BD D7 87                 ...
        sta     $0780,x                         ; 823A 9D 80 07                 ...
        dex                                     ; 823D CA                       .
        bpl     L8237                           ; 823E 10 F7                    ..
        ldx     $2C                             ; 8240 A6 2C                    .,
        lda     L87BD,y                         ; 8242 B9 BD 87                 ...
        ora     L8522,x                         ; 8245 1D 22 85                 .".
        sta     $0780                           ; 8248 8D 80 07                 ...
        lda     L87CA,y                         ; 824B B9 CA 87                 ...
        sta     $0781                           ; 824E 8D 81 07                 ...
        lda     $078A                           ; 8251 AD 8A 07                 ...
        ora     L8522,x                         ; 8254 1D 22 85                 .".
        sta     $078A                           ; 8257 8D 8A 07                 ...
        lda     $078E                           ; 825A AD 8E 07                 ...
        ora     L8522,x                         ; 825D 1D 22 85                 .".
        sta     $078E                           ; 8260 8D 8E 07                 ...
        lda     $BD                             ; 8263 A5 BD                    ..
        and     #$0F                            ; 8265 29 0F                    ).
        ora     #$B0                            ; 8267 09 B0                    ..
        sta     $078D                           ; 8269 8D 8D 07                 ...
        lda     $BE                             ; 826C A5 BE                    ..
        and     #$0F                            ; 826E 29 0F                    ).
        ora     #$B0                            ; 8270 09 B0                    ..
        sta     $0791                           ; 8272 8D 91 07                 ...
L8275:  lda     $B0,y                           ; 8275 B9 B0 00                 ...
        clc                                     ; 8278 18                       .
        adc     #$01                            ; 8279 69 01                    i.
        sta     $B0,y                           ; 827B 99 B0 00                 ...
        and     #$1F                            ; 827E 29 1F                    ).
        sta     $01                             ; 8280 85 01                    ..
        jsr     L846A                           ; 8282 20 6A 84                  j.
        cpy     #$00                            ; 8285 C0 00                    ..
        bne     L82A6                           ; 8287 D0 1D                    ..
        ldx     #$09                            ; 8289 A2 09                    ..
L828B:  lda     $0780,x                         ; 828B BD 80 07                 ...
        sta     $0792,x                         ; 828E 9D 92 07                 ...
        dex                                     ; 8291 CA                       .
        bpl     L828B                           ; 8292 10 F7                    ..
        stx     $079C                           ; 8294 8E 9C 07                 ...
        lda     #$70                            ; 8297 A9 70                    .p
        sta     $0793                           ; 8299 8D 93 07                 ...
        lda     $0780                           ; 829C AD 80 07                 ...
        and     #$2C                            ; 829F 29 2C                    ),
        ora     #$23                            ; 82A1 09 23                    .#
        sta     $0792                           ; 82A3 8D 92 07                 ...
L82A6:  dec     $19                             ; 82A6 C6 19                    ..
        lda     #$26                            ; 82A8 A9 26                    .&
        jsr     queue_sound                           ; 82AA 20 5D EC                  ].
        lda     #$04                            ; 82AD A9 04                    ..
        jsr     LFF24                           ; 82AF 20 24 FF                  $.
        lda     $B0,y                           ; 82B2 B9 B0 00                 ...
        cmp     #$9C                            ; 82B5 C9 9C                    ..
        bne     L8275                           ; 82B7 D0 BC                    ..
        rts                                     ; 82B9 60                       `

; ----------------------------------------------------------------------------
L82BA:  ldy     #$00                            ; 82BA A0 00                    ..
L82BC:  lda     $B0,y                           ; 82BC B9 B0 00                 ...
        bpl     L82C8                           ; 82BF 10 07                    ..
        cmp     #$9C                            ; 82C1 C9 9C                    ..
        beq     L82C8                           ; 82C3 F0 03                    ..
        jsr     L8235                           ; 82C5 20 35 82                  5.
L82C8:  iny                                     ; 82C8 C8                       .
        cpy     #$0D                            ; 82C9 C0 0D                    ..
        bne     L82BC                           ; 82CB D0 EF                    ..
        rts                                     ; 82CD 60                       `

; ----------------------------------------------------------------------------
L82CE:  ldy     #$08                            ; 82CE A0 08                    ..
L82D0:  lda     L87EA,y                         ; 82D0 B9 EA 87                 ...
        sta     $0780,y                         ; 82D3 99 80 07                 ...
        dey                                     ; 82D6 88                       .
        bpl     L82D0                           ; 82D7 10 F7                    ..
        dec     $BE                             ; 82D9 C6 BE                    ..
        lda     $BE                             ; 82DB A5 BE                    ..
        and     #$0F                            ; 82DD 29 0F                    ).
        ora     #$B0                            ; 82DF 09 B0                    ..
        sta     $0783                           ; 82E1 8D 83 07                 ...
        ldx     $2C                             ; 82E4 A6 2C                    .,
        lda     $0780                           ; 82E6 AD 80 07                 ...
        ora     L8522,x                         ; 82E9 1D 22 85                 .".
        sta     $0780                           ; 82EC 8D 80 07                 ...
        sta     $0784                           ; 82EF 8D 84 07                 ...
        lda     $BF                             ; 82F2 A5 BF                    ..
        ora     #$B0                            ; 82F4 09 B0                    ..
        sta     $0787                           ; 82F6 8D 87 07                 ...
        sty     $19                             ; 82F9 84 19                    ..
        jmp     frame_wait                           ; 82FB 4C 22 FF                 L".

; ----------------------------------------------------------------------------
L82FE:  ldx     #$0F                            ; 82FE A2 0F                    ..
L8300:  lda     L8601,x                         ; 8300 BD 01 86                 ...
        sta     $0200,x                         ; 8303 9D 00 02                 ...
        dex                                     ; 8306 CA                       .
        bpl     L8300                           ; 8307 10 F7                    ..
L8309:  ldx     $50                             ; 8309 A6 50                    .P
        ldy     L8611,x                         ; 830B BC 11 86                 ...
        lda     L8621,y                         ; 830E B9 21 86                 .!.
        sta     L0000                           ; 8311 85 00                    ..
        lda     L8622,y                         ; 8313 B9 22 86                 .".
        sta     $ED                             ; 8316 85 ED                    ..
        ldx     #$10                            ; 8318 A2 10                    ..
L831A:  lda     L8623,y                         ; 831A B9 23 86                 .#.
        sta     $0200,x                         ; 831D 9D 00 02                 ...
        lda     L8624,y                         ; 8320 B9 24 86                 .$.
        sta     $0201,x                         ; 8323 9D 01 02                 ...
        lda     L8625,y                         ; 8326 B9 25 86                 .%.
        sta     $0202,x                         ; 8329 9D 02 02                 ...
        lda     L8626,y                         ; 832C B9 26 86                 .&.
        sta     $0203,x                         ; 832F 9D 03 02                 ...
        iny                                     ; 8332 C8                       .
        iny                                     ; 8333 C8                       .
        iny                                     ; 8334 C8                       .
        iny                                     ; 8335 C8                       .
L8336:  inx                                     ; 8336 E8                       .
        inx                                     ; 8337 E8                       .
        inx                                     ; 8338 E8                       .
        inx                                     ; 8339 E8                       .
        dec     L0000                           ; 833A C6 00                    ..
        bpl     L831A                           ; 833C 10 DC                    ..
        cpx     #$3C                            ; 833E E0 3C                    .<
        beq     L8349                           ; 8340 F0 07                    ..
        lda     #$F8                            ; 8342 A9 F8                    ..
        sta     $0200,x                         ; 8344 9D 00 02                 ...
        bne     L8336                           ; 8347 D0 ED                    ..
L8349:  rts                                     ; 8349 60                       `

; ----------------------------------------------------------------------------
L834A:  lda     L86B1,y                         ; 834A B9 B1 86                 ...
        tay                                     ; 834D A8                       .
        ldx     #$00                            ; 834E A2 00                    ..
        lda     L86C1,y                         ; 8350 B9 C1 86                 ...
        ora     L0010                           ; 8353 05 10                    ..
        sta     $0780,x                         ; 8355 9D 80 07                 ...
        lda     L86C2,y                         ; 8358 B9 C2 86                 ...
        sta     $0781,x                         ; 835B 9D 81 07                 ...
        lda     L86C3,y                         ; 835E B9 C3 86                 ...
        sta     $0782,x                         ; 8361 9D 82 07                 ...
        sta     $02                             ; 8364 85 02                    ..
L8366:  lda     L86C4,y                         ; 8366 B9 C4 86                 ...
        sta     $0783,x                         ; 8369 9D 83 07                 ...
        iny                                     ; 836C C8                       .
        inx                                     ; 836D E8                       .
        dec     $02                             ; 836E C6 02                    ..
        bpl     L8366                           ; 8370 10 F4                    ..
        inx                                     ; 8372 E8                       .
        inx                                     ; 8373 E8                       .
        inx                                     ; 8374 E8                       .
L8375:  ldy     $50                             ; 8375 A4 50                    .P
        lda     L86B1,y                         ; 8377 B9 B1 86                 ...
        tay                                     ; 837A A8                       .
        lda     L86C1,y                         ; 837B B9 C1 86                 ...
        ora     L0010                           ; 837E 05 10                    ..
        .byte   $9D                             ; 8380 9D                       .
L8381:  .byte   $80                             ; 8381 80                       .
        .byte   $07                             ; 8382 07                       .
        lda     L86C2,y                         ; 8383 B9 C2 86                 ...
        sta     $0781,x                         ; 8386 9D 81 07                 ...
        lda     L86C3,y                         ; 8389 B9 C3 86                 ...
        sta     $0782,x                         ; 838C 9D 82 07                 ...
        sta     $02                             ; 838F 85 02                    ..
L8391:  lda     L86C4,y                         ; 8391 B9 C4 86                 ...
        ora     L8722,y                         ; 8394 19 22 87                 .".
        sta     $0783,x                         ; 8397 9D 83 07                 ...
        iny                                     ; 839A C8                       .
        inx                                     ; 839B E8                       .
        dec     $02                             ; 839C C6 02                    ..
        bpl     L8391                           ; 839E 10 F1                    ..
        stx     $02                             ; 83A0 86 02                    ..
        ldy     #$00                            ; 83A2 A0 00                    ..
L83A4:  lda     L87B2,y                         ; 83A4 B9 B2 87                 ...
        sta     $0783,x                         ; 83A7 9D 83 07                 ...
        inx                                     ; 83AA E8                       .
        iny                                     ; 83AB C8                       .
        cpy     #$0B                            ; 83AC C0 0B                    ..
        bne     L83A4                           ; 83AE D0 F4                    ..
        ldy     $50                             ; 83B0 A4 50                    .P
        ldx     L85E1,y                         ; 83B2 BE E1 85                 ...
        lda     $B0,x                           ; 83B5 B5 B0                    ..
        and     #$1F                            ; 83B7 29 1F                    ).
        sta     $01                             ; 83B9 85 01                    ..
        ldx     $02                             ; 83BB A6 02                    ..
        lda     $0783,x                         ; 83BD BD 83 07                 ...
        ora     L0010                           ; 83C0 05 10                    ..
        sta     $0783,x                         ; 83C2 9D 83 07                 ...
        lda     #$07                            ; 83C5 A9 07                    ..
        sta     $02                             ; 83C7 85 02                    ..
L83C9:  lda     $01                             ; 83C9 A5 01                    ..
        sec                                     ; 83CB 38                       8
        sbc     #$04                            ; 83CC E9 04                    ..
        bcc     L83DE                           ; 83CE 90 0E                    ..
        sta     $01                             ; 83D0 85 01                    ..
        lda     #$88                            ; 83D2 A9 88                    ..
        sta     $0786,x                         ; 83D4 9D 86 07                 ...
        inx                                     ; 83D7 E8                       .
        dec     $02                             ; 83D8 C6 02                    ..
        bne     L83C9                           ; 83DA D0 ED                    ..
        beq     L83E5                           ; 83DC F0 07                    ..
L83DE:  lda     $01                             ; 83DE A5 01                    ..
        ora     #$84                            ; 83E0 09 84                    ..
        sta     $0786,x                         ; 83E2 9D 86 07                 ...
L83E5:  lda     #$FF                            ; 83E5 A9 FF                    ..
        sta     $19                             ; 83E7 85 19                    ..
        lda     $50                             ; 83E9 A5 50                    .P
        asl     a                               ; 83EB 0A                       .
        asl     a                               ; 83EC 0A                       .
        tay                                     ; 83ED A8                       .
        ldx     #$00                            ; 83EE A2 00                    ..
L83F0:  lda     L854B,y                         ; 83F0 B9 4B 85                 .K.
        sta     $0611,x                         ; 83F3 9D 11 06                 ...
        sta     $0631,x                         ; 83F6 9D 31 06                 .1.
        sta     $07C1,x                         ; 83F9 9D C1 07                 ...
        iny                                     ; 83FC C8                       .
        inx                                     ; 83FD E8                       .
        cpx     #$03                            ; 83FE E0 03                    ..
        bne     L83F0                           ; 8400 D0 EE                    ..
        rts                                     ; 8402 60                       `

; ----------------------------------------------------------------------------
L8403:  ldy     #$1C                            ; 8403 A0 1C                    ..
L8405:  lda     L877D,y                         ; 8405 B9 7D 87                 .}.
        sta     $0780,y                         ; 8408 99 80 07                 ...
        dey                                     ; 840B 88                       .
        bpl     L8405                           ; 840C 10 F7                    ..
        ldy     #$0B                            ; 840E A0 0B                    ..
        sty     L0000                           ; 8410 84 00                    ..
L8412:  ldy     L0000                           ; 8412 A4 00                    ..
        lda     $B0,y                           ; 8414 B9 B0 00                 ...
        bmi     L8432                           ; 8417 30 19                    0.
        lda     L879A,y                         ; 8419 B9 9A 87                 ...
        ora     L0010                           ; 841C 05 10                    ..
        sta     $0780                           ; 841E 8D 80 07                 ...
        sta     $078E                           ; 8421 8D 8E 07                 ...
        lda     L87A6,y                         ; 8424 B9 A6 87                 ...
        sta     $0781                           ; 8427 8D 81 07                 ...
        ora     #$20                            ; 842A 09 20                    . 
        sta     $078F                           ; 842C 8D 8F 07                 ...
        jsr     nametable_flush                           ; 842F 20 98 C2                  ..
L8432:  dec     L0000                           ; 8432 C6 00                    ..
        bpl     L8412                           ; 8434 10 DC                    ..
        rts                                     ; 8436 60                       `

; ----------------------------------------------------------------------------
L8437:  ldy     #$0C                            ; 8437 A0 0C                    ..
        sty     L0000                           ; 8439 84 00                    ..
L843B:  ldy     L0000                           ; 843B A4 00                    ..
        lda     $B0,y                           ; 843D B9 B0 00                 ...
        bpl     L844C                           ; 8440 10 0A                    ..
        and     #$1F                            ; 8442 29 1F                    ).
        sta     $01                             ; 8444 85 01                    ..
        jsr     L8451                           ; 8446 20 51 84                  Q.
        jsr     nametable_flush                           ; 8449 20 98 C2                  ..
L844C:  dec     L0000                           ; 844C C6 00                    ..
        bpl     L843B                           ; 844E 10 EB                    ..
        rts                                     ; 8450 60                       `

; ----------------------------------------------------------------------------
L8451:  ldx     #$0A                            ; 8451 A2 0A                    ..
L8453:  lda     L87B2,x                         ; 8453 BD B2 87                 ...
        sta     $0780,x                         ; 8456 9D 80 07                 ...
        dex                                     ; 8459 CA                       .
        bpl     L8453                           ; 845A 10 F7                    ..
        lda     L87BD,y                         ; 845C B9 BD 87                 ...
        ora     L0010                           ; 845F 05 10                    ..
        sta     $0780                           ; 8461 8D 80 07                 ...
        lda     L87CA,y                         ; 8464 B9 CA 87                 ...
        sta     $0781                           ; 8467 8D 81 07                 ...
L846A:  ldx     #$00                            ; 846A A2 00                    ..
L846C:  lda     $01                             ; 846C A5 01                    ..
        sec                                     ; 846E 38                       8
        sbc     #$04                            ; 846F E9 04                    ..
        bcc     L8480                           ; 8471 90 0D                    ..
        sta     $01                             ; 8473 85 01                    ..
        lda     #$88                            ; 8475 A9 88                    ..
        sta     $0783,x                         ; 8477 9D 83 07                 ...
        inx                                     ; 847A E8                       .
        cpx     #$07                            ; 847B E0 07                    ..
        bne     L846C                           ; 847D D0 ED                    ..
        rts                                     ; 847F 60                       `

; ----------------------------------------------------------------------------
L8480:  lda     $01                             ; 8480 A5 01                    ..
        ora     #$84                            ; 8482 09 84                    ..
        sta     $0783,x                         ; 8484 9D 83 07                 ...
L8487:  rts                                     ; 8487 60                       `

; ----------------------------------------------------------------------------
L8488:  lda     $BC                             ; 8488 A5 BC                    ..
        bmi     L84BF                           ; 848A 30 33                    03
        lda     $6D                             ; 848C A5 6D                    .m
        beq     L8487                           ; 848E F0 F7                    ..
        sta     L0000                           ; 8490 85 00                    ..
        ldy     #$07                            ; 8492 A0 07                    ..
L8494:  lda     L85CC,y                         ; 8494 B9 CC 85                 ...
        sta     $0780,y                         ; 8497 99 80 07                 ...
        dey                                     ; 849A 88                       .
        bpl     L8494                           ; 849B 10 F7                    ..
        ldy     #$00                            ; 849D A0 00                    ..
L849F:  lsr     L0000                           ; 849F 46 00                    F.
        bcc     L84B8                           ; 84A1 90 15                    ..
        lda     #$30                            ; 84A3 A9 30                    .0
        sta     $01                             ; 84A5 85 01                    ..
        tya                                     ; 84A7 98                       .
        lsr     a                               ; 84A8 4A                       J
        tax                                     ; 84A9 AA                       .
        bcc     L84B0                           ; 84AA 90 04                    ..
        lda     #$C0                            ; 84AC A9 C0                    ..
        sta     $01                             ; 84AE 85 01                    ..
L84B0:  lda     $0783,x                         ; 84B0 BD 83 07                 ...
        ora     $01                             ; 84B3 05 01                    ..
        sta     $0783,x                         ; 84B5 9D 83 07                 ...
L84B8:  iny                                     ; 84B8 C8                       .
        lda     L0000                           ; 84B9 A5 00                    ..
        bne     L849F                           ; 84BB D0 E2                    ..
        beq     L84DE                           ; 84BD F0 1F                    ..
L84BF:  lda     $BC                             ; 84BF A5 BC                    ..
        ora     #$80                            ; 84C1 09 80                    ..
        sta     $BC                             ; 84C3 85 BC                    ..
        ldy     #$13                            ; 84C5 A0 13                    ..
L84C7:  lda     L85A4,y                         ; 84C7 B9 A4 85                 ...
        sta     $0780,y                         ; 84CA 99 80 07                 ...
        dey                                     ; 84CD 88                       .
        bpl     L84C7                           ; 84CE 10 F7                    ..
        jsr     L84DE                           ; 84D0 20 DE 84                  ..
        ldy     #$13                            ; 84D3 A0 13                    ..
L84D5:  lda     L85B8,y                         ; 84D5 B9 B8 85                 ...
        sta     $0780,y                         ; 84D8 99 80 07                 ...
        dey                                     ; 84DB 88                       .
        bpl     L84D5                           ; 84DC 10 F7                    ..
L84DE:  lda     $0780                           ; 84DE AD 80 07                 ...
        ora     L0010                           ; 84E1 05 10                    ..
        sta     $0780                           ; 84E3 8D 80 07                 ...
        jmp     nametable_flush                           ; 84E6 4C 98 C2                 L..

; ----------------------------------------------------------------------------
L84E9:  ldy     #$0C                            ; 84E9 A0 0C                    ..
L84EB:  lda     L85D4,y                         ; 84EB B9 D4 85                 ...
        sta     $0780,y                         ; 84EE 99 80 07                 ...
        dey                                     ; 84F1 88                       .
        bpl     L84EB                           ; 84F2 10 F7                    ..
        lda     $BD                             ; 84F4 A5 BD                    ..
        and     #$0F                            ; 84F6 29 0F                    ).
        ora     #$B0                            ; 84F8 09 B0                    ..
        sta     $0783                           ; 84FA 8D 83 07                 ...
        lda     $BE                             ; 84FD A5 BE                    ..
        and     #$0F                            ; 84FF 29 0F                    ).
        ora     #$B0                            ; 8501 09 B0                    ..
        sta     $0787                           ; 8503 8D 87 07                 ...
        lda     $BF                             ; 8506 A5 BF                    ..
        and     #$0F                            ; 8508 29 0F                    ).
        ora     #$B0                            ; 850A 09 B0                    ..
        sta     $078B                           ; 850C 8D 8B 07                 ...
        lda     $0784                           ; 850F AD 84 07                 ...
        ora     L0010                           ; 8512 05 10                    ..
        sta     $0784                           ; 8514 8D 84 07                 ...
        lda     $0788                           ; 8517 AD 88 07                 ...
        ora     L0010                           ; 851A 05 10                    ..
        sta     $0788                           ; 851C 8D 88 07                 ...
        jmp     L84DE                           ; 851F 4C DE 84                 L..

; ----------------------------------------------------------------------------
L8522:  .byte   $04                             ; 8522 04                       .
        php                                     ; 8523 08                       .
L8524:  cpy     a:$CE                           ; 8524 CC CE 00                 ...
        asl     L0000                           ; 8527 06 00                    ..
        brk                                     ; 8529 00                       .
L852A:  .byte   $0F                             ; 852A 0F                       .
        jsr     L0010                           ; 852B 20 10 00                  ..
        .byte   $0F                             ; 852E 0F                       .
        bmi     L8568                           ; 852F 30 37                    07
        bit     $380F                           ; 8531 2C 0F 38                 ,.8
        bit     L0F11                           ; 8534 2C 11 0F                 ,..
        jsr     L1827                           ; 8537 20 27 18                  '.
        .byte   $0F                             ; 853A 0F                       .
        .byte   $0F                             ; 853B 0F                       .
        bit     L0F11                           ; 853C 2C 11 0F                 ,..
        .byte   $0F                             ; 853F 0F                       .
        jsr     L0F37                           ; 8540 20 37 0F                  7.
        .byte   $0F                             ; 8543 0F                       .
        brk                                     ; 8544 00                       .
        brk                                     ; 8545 00                       .
        .byte   $0F                             ; 8546 0F                       .
        .byte   $0F                             ; 8547 0F                       .
        brk                                     ; 8548 00                       .
        brk                                     ; 8549 00                       .
        .byte   $0F                             ; 854A 0F                       .
L854B:  .byte   $0F                             ; 854B 0F                       .
        bit     L0F11                           ; 854C 2C 11 0F                 ,..
        .byte   $0F                             ; 854F 0F                       .
        jsr     L0F11                           ; 8550 20 11 0F                  ..
        .byte   $0F                             ; 8553 0F                       .
        jsr     L0F1A                           ; 8554 20 1A 0F                  ..
        .byte   $0F                             ; 8557 0F                       .
        jsr     L0F2C                           ; 8558 20 2C 0F                  ,.
        .byte   $0F                             ; 855B 0F                       .
        .byte   $27                             ; 855C 27                       '
        .byte   $12                             ; 855D 12                       .
        .byte   $0F                             ; 855E 0F                       .
        .byte   $0F                             ; 855F 0F                       .
        bit     L0F11                           ; 8560 2C 11 0F                 ,..
        .byte   $0F                             ; 8563 0F                       .
        bit     L0F11                           ; 8564 2C 11 0F                 ,..
        .byte   $0F                             ; 8567 0F                       .
L8568:  bit     L0F11                           ; 8568 2C 11 0F                 ,..
        .byte   $0F                             ; 856B 0F                       .
        jsr     L0F07                           ; 856C 20 07 0F                  ..
        .byte   $0F                             ; 856F 0F                       .
        jsr     L0F14                           ; 8570 20 14 0F                  ..
        .byte   $0F                             ; 8573 0F                       .
        jsr     L0F26                           ; 8574 20 26 0F                  &.
        .byte   $0F                             ; 8577 0F                       .
        plp                                     ; 8578 28                       (
        .byte   $17                             ; 8579 17                       .
        .byte   $0F                             ; 857A 0F                       .
        .byte   $0F                             ; 857B 0F                       .
        jsr     L0F16                           ; 857C 20 16 0F                  ..
        .byte   $0F                             ; 857F 0F                       .
        jsr     L0F16                           ; 8580 20 16 0F                  ..
        .byte   $0F                             ; 8583 0F                       .
        .byte   $2C                             ; 8584 2C                       ,
L8585:  ora     ($0F),y                         ; 8585 11 0F                    ..
        .byte   $0F                             ; 8587 0F                       .
        .byte   $2C                             ; 8588 2C                       ,
        .byte   $11                             ; 8589 11                       .
L858A:  php                                     ; 858A 08                       .
L858B:  beq     L8585                           ; 858B F0 F8                    ..
        bpl     L8590                           ; 858D 10 01                    ..
        sed                                     ; 858F F8                       .
L8590:  brk                                     ; 8590 00                       .
        brk                                     ; 8591 00                       .
        .byte   $FF                             ; 8592 FF                       .
        php                                     ; 8593 08                       .
L8594:  brk                                     ; 8594 00                       .
        ora     ($02,x)                         ; 8595 01 02                    ..
        .byte   $03                             ; 8597 03                       .
        .byte   $04                             ; 8598 04                       .
        ora     $0C                             ; 8599 05 0C                    ..
        ora     $0706                           ; 859B 0D 06 07                 ...
        php                                     ; 859E 08                       .
        ora     #$0A                            ; 859F 09 0A                    ..
        .byte   $0B                             ; 85A1 0B                       .
        .byte   $0C                             ; 85A2 0C                       .
        .byte   $0E                             ; 85A3 0E                       .
L85A4:  .byte   $22                             ; 85A4 22                       "
        pha                                     ; 85A5 48                       H
        .byte   $0F                             ; 85A6 0F                       .
        brk                                     ; 85A7 00                       .
        brk                                     ; 85A8 00                       .
        sty     a:$8D                           ; 85A9 8C 8D 00                 ...
        sbc     ($E4,x)                         ; 85AC E1 E4                    ..
        cpx     #$F0                            ; 85AE E0 F0                    ..
        brk                                     ; 85B0 00                       .
        brk                                     ; 85B1 00                       .
        brk                                     ; 85B2 00                       .
        brk                                     ; 85B3 00                       .
        brk                                     ; 85B4 00                       .
        brk                                     ; 85B5 00                       .
        brk                                     ; 85B6 00                       .
        .byte   $FF                             ; 85B7 FF                       .
L85B8:  .byte   $22                             ; 85B8 22                       "
        pla                                     ; 85B9 68                       h
        .byte   $0F                             ; 85BA 0F                       .
        brk                                     ; 85BB 00                       .
        brk                                     ; 85BC 00                       .
        .byte   $9C                             ; 85BD 9C                       .
        sta     a:L0000,x                       ; 85BE 9D 00 00                 ...
        sty     $84                             ; 85C1 84 84                    ..
        sty     $84                             ; 85C3 84 84                    ..
        sty     $84                             ; 85C5 84 84                    ..
        sty     L0000                           ; 85C7 84 00                    ..
        brk                                     ; 85C9 00                       .
        brk                                     ; 85CA 00                       .
        .byte   $FF                             ; 85CB FF                       .
L85CC:  .byte   $23                             ; 85CC 23                       #
        .byte   $E2                             ; 85CD E2                       .
        .byte   $03                             ; 85CE 03                       .
        brk                                     ; 85CF 00                       .
        brk                                     ; 85D0 00                       .
        brk                                     ; 85D1 00                       .
        brk                                     ; 85D2 00                       .
        .byte   $FF                             ; 85D3 FF                       .
L85D4:  .byte   $23                             ; 85D4 23                       #
        lsr     L0000                           ; 85D5 46 00                    F.
        brk                                     ; 85D7 00                       .
        .byte   $23                             ; 85D8 23                       #
        eor     a:L0000                         ; 85D9 4D 00 00                 M..
        .byte   $23                             ; 85DC 23                       #
        eor     a:L0000,x                       ; 85DD 5D 00 00                 ]..
        .byte   $FF                             ; 85E0 FF                       .
L85E1:  brk                                     ; 85E1 00                       .
        ora     ($02,x)                         ; 85E2 01 02                    ..
        .byte   $03                             ; 85E4 03                       .
        .byte   $04                             ; 85E5 04                       .
        ora     $0C                             ; 85E6 05 0C                    ..
        brk                                     ; 85E8 00                       .
        asl     $07                             ; 85E9 06 07                    ..
        php                                     ; 85EB 08                       .
        ora     #$0A                            ; 85EC 09 0A                    ..
        .byte   $0B                             ; 85EE 0B                       .
        .byte   $0C                             ; 85EF 0C                       .
        brk                                     ; 85F0 00                       .
L85F1:  asl     $48                             ; 85F1 06 48                    .H
        .byte   $44                             ; 85F3 44                       D
        eor     $47                             ; 85F4 45 47                    EG
        .byte   $04                             ; 85F6 04                       .
        eor     #$07                            ; 85F7 49 07                    I.
        lsr     $07                             ; 85F9 46 07                    F.
L85FB:  .byte   $07                             ; 85FB 07                       .
        .byte   $47                             ; 85FC 47                       G
        lsr     $46                             ; 85FD 46 46                    FF
        eor     #$07                            ; 85FF 49 07                    I.
L8601:  .byte   $BF                             ; 8601 BF                       .
        jmp     LD000                           ; 8602 4C 00 D0                 L..

; ----------------------------------------------------------------------------
        .byte   $BF                             ; 8605 BF                       .
        jmp     LD840                           ; 8606 4C 40 D8                 L@.

; ----------------------------------------------------------------------------
        .byte   $C7                             ; 8609 C7                       .
        eor     $D001                           ; 860A 4D 01 D0                 M..
        .byte   $C7                             ; 860D C7                       .
        .byte   $4D                             ; 860E 4D                       M
L860F:  eor     ($D8,x)                         ; 860F 41 D8                    A.
L8611:  brk                                     ; 8611 00                       .
        brk                                     ; 8612 00                       .
        brk                                     ; 8613 00                       .
        brk                                     ; 8614 00                       .
        brk                                     ; 8615 00                       .
        brk                                     ; 8616 00                       .
        .byte   $7A                             ; 8617 7A                       z
        brk                                     ; 8618 00                       .
        brk                                     ; 8619 00                       .
        brk                                     ; 861A 00                       .
        brk                                     ; 861B 00                       .
        brk                                     ; 861C 00                       .
        rol     $54                             ; 861D 26 54                    &T
        .byte   $7A                             ; 861F 7A                       z
        brk                                     ; 8620 00                       .
L8621:  php                                     ; 8621 08                       .
L8622:  .byte   $04                             ; 8622 04                       .
L8623:  .byte   $C5                             ; 8623 C5                       .
L8624:  php                                     ; 8624 08                       .
L8625:  .byte   $41                             ; 8625 41                       A
L8626:  sta     $01BF,y                         ; 8626 99 BF 01                 ...
        rti                                     ; 8629 40                       @

; ----------------------------------------------------------------------------
        sty     $BF,x                           ; 862A 94 BF                    ..
        brk                                     ; 862C 00                       .
        rti                                     ; 862D 40                       @

; ----------------------------------------------------------------------------
        .byte   $9C                             ; 862E 9C                       .
        .byte   $C7                             ; 862F C7                       .
        .byte   $04                             ; 8630 04                       .
        rti                                     ; 8631 40                       @

; ----------------------------------------------------------------------------
        bcc     L85FB                           ; 8632 90 C7                    ..
        .byte   $03                             ; 8634 03                       .
        rti                                     ; 8635 40                       @

; ----------------------------------------------------------------------------
        tya                                     ; 8636 98                       .
        .byte   $C7                             ; 8637 C7                       .
        .byte   $02                             ; 8638 02                       .
        rti                                     ; 8639 40                       @

; ----------------------------------------------------------------------------
        ldy     #$CF                            ; 863A A0 CF                    ..
        .byte   $07                             ; 863C 07                       .
        rti                                     ; 863D 40                       @

; ----------------------------------------------------------------------------
        bcc     L860F                           ; 863E 90 CF                    ..
        asl     $40                             ; 8640 06 40                    .@
        tya                                     ; 8642 98                       .
        .byte   $CF                             ; 8643 CF                       .
        ora     $40                             ; 8644 05 40                    .@
        ldy     #$0A                            ; 8646 A0 0A                    ..
        ora     $C5                             ; 8648 05 C5                    ..
        sei                                     ; 864A 78                       x
        eor     ($9C,x)                         ; 864B 41 9C                    A.
        .byte   $BF                             ; 864D BF                       .
        ror     $40                             ; 864E 66 40                    f@
        .byte   $9C                             ; 8650 9C                       .
        .byte   $BF                             ; 8651 BF                       .
        adc     $40                             ; 8652 65 40                    e@
        ldy     $C7                             ; 8654 A4 C7                    ..
        .byte   $6B                             ; 8656 6B                       k
        rti                                     ; 8657 40                       @

; ----------------------------------------------------------------------------
        sty     $6AC7                           ; 8658 8C C7 6A                 ..j
        rti                                     ; 865B 40                       @

; ----------------------------------------------------------------------------
        sty     $C7,x                           ; 865C 94 C7                    ..
        adc     #$40                            ; 865E 69 40                    i@
        .byte   $9C                             ; 8660 9C                       .
        .byte   $C7                             ; 8661 C7                       .
        pla                                     ; 8662 68                       h
        eor     ($A4,x)                         ; 8663 41 A4                    A.
        .byte   $CF                             ; 8665 CF                       .
        .byte   $67                             ; 8666 67                       g
        rti                                     ; 8667 40                       @

; ----------------------------------------------------------------------------
        sty     $79CF                           ; 8668 8C CF 79                 ..y
        rti                                     ; 866B 40                       @

; ----------------------------------------------------------------------------
        sty     $CF,x                           ; 866C 94 CF                    ..
        adc     L9C40                           ; 866E 6D 40 9C                 m@.
        .byte   $CF                             ; 8671 CF                       .
        jmp     (LA440)                         ; 8672 6C 40 A4                 l@.

; ----------------------------------------------------------------------------
        php                                     ; 8675 08                       .
        .byte   $04                             ; 8676 04                       .
        .byte   $CF                             ; 8677 CF                       .
        adc     $A141,y                         ; 8678 79 41 A1                 yA.
        .byte   $C7                             ; 867B C7                       .
        .byte   $73                             ; 867C 73                       s
        rti                                     ; 867D 40                       @

; ----------------------------------------------------------------------------
        sty     $72C7                           ; 867E 8C C7 72                 ..r
        rti                                     ; 8681 40                       @

; ----------------------------------------------------------------------------
        sty     $C7,x                           ; 8682 94 C7                    ..
        adc     ($40),y                         ; 8684 71 40                    q@
        .byte   $9C                             ; 8686 9C                       .
        .byte   $C7                             ; 8687 C7                       .
        bvs     L86CA                           ; 8688 70 40                    p@
        ldy     $CF                             ; 868A A4 CF                    ..
        .byte   $77                             ; 868C 77                       w
        eor     ($8C,x)                         ; 868D 41 8C                    A.
        .byte   $CF                             ; 868F CF                       .
        ror     $40,x                           ; 8690 76 40                    v@
        sty     $CF,x                           ; 8692 94 CF                    ..
        adc     $40,x                           ; 8694 75 40                    u@
        .byte   $9C                             ; 8696 9C                       .
        .byte   $CF                             ; 8697 CF                       .
        .byte   $74                             ; 8698 74                       t
        rti                                     ; 8699 40                       @

; ----------------------------------------------------------------------------
        ldy     $04                             ; 869A A4 04                    ..
        eor     #$CF                            ; 869C 49 CF                    I.
        .byte   $74                             ; 869E 74                       t
        eor     ($9C,x)                         ; 869F 41 9C                    A.
        .byte   $C7                             ; 86A1 C7                       .
        ror     $40                             ; 86A2 66 40                    f@
        sty     $C7,x                           ; 86A4 94 C7                    ..
        adc     $40                             ; 86A6 65 40                    e@
        .byte   $9C                             ; 86A8 9C                       .
        .byte   $CF                             ; 86A9 CF                       .
        pla                                     ; 86AA 68                       h
        rti                                     ; 86AB 40                       @

; ----------------------------------------------------------------------------
        sty     $CF,x                           ; 86AC 94 CF                    ..
        .byte   $67                             ; 86AE 67                       g
        rti                                     ; 86AF 40                       @

; ----------------------------------------------------------------------------
        .byte   $9C                             ; 86B0 9C                       .
L86B1:  brk                                     ; 86B1 00                       .
        asl     $0C                             ; 86B2 06 0C                    ..
        .byte   $12                             ; 86B4 12                       .
        clc                                     ; 86B5 18                       .
        asl     $2457,x                         ; 86B6 1E 57 24                 .W$
        and     #$30                            ; 86B9 29 30                    )0
        .byte   $37                             ; 86BB 37                       7
        rol     $4C45,x                         ; 86BC 3E 45 4C                 >EL
        .byte   $57                             ; 86BF 57                       W
        .byte   $53                             ; 86C0 53                       S
L86C1:  .byte   $23                             ; 86C1 23                       #
L86C2:  .byte   $C9                             ; 86C2 C9                       .
L86C3:  .byte   $02                             ; 86C3 02                       .
L86C4:  brk                                     ; 86C4 00                       .
        brk                                     ; 86C5 00                       .
        brk                                     ; 86C6 00                       .
        .byte   $23                             ; 86C7 23                       #
        cmp     #$02                            ; 86C8 C9 02                    ..
L86CA:  brk                                     ; 86CA 00                       .
        brk                                     ; 86CB 00                       .
        brk                                     ; 86CC 00                       .
        .byte   $23                             ; 86CD 23                       #
        cmp     ($02),y                         ; 86CE D1 02                    ..
        brk                                     ; 86D0 00                       .
        brk                                     ; 86D1 00                       .
        brk                                     ; 86D2 00                       .
        .byte   $23                             ; 86D3 23                       #
        cmp     ($02),y                         ; 86D4 D1 02                    ..
        brk                                     ; 86D6 00                       .
        brk                                     ; 86D7 00                       .
        brk                                     ; 86D8 00                       .
        .byte   $23                             ; 86D9 23                       #
        cmp     $02,y                           ; 86DA D9 02 00                 ...
        brk                                     ; 86DD 00                       .
        brk                                     ; 86DE 00                       .
        .byte   $23                             ; 86DF 23                       #
        cmp     $02,y                           ; 86E0 D9 02 00                 ...
        brk                                     ; 86E3 00                       .
        brk                                     ; 86E4 00                       .
        .byte   $23                             ; 86E5 23                       #
        beq     L86E9                           ; 86E6 F0 01                    ..
        .byte   $F3                             ; 86E8 F3                       .
L86E9:  .byte   $FC                             ; 86E9 FC                       .
        .byte   $23                             ; 86EA 23                       #
        cpy     a:$03                           ; 86EB CC 03 00                 ...
        brk                                     ; 86EE 00                       .
        brk                                     ; 86EF 00                       .
        cpy     $CC23                           ; 86F0 CC 23 CC                 .#.
        .byte   $03                             ; 86F3 03                       .
        brk                                     ; 86F4 00                       .
        brk                                     ; 86F5 00                       .
        brk                                     ; 86F6 00                       .
        cpy     LD423                           ; 86F7 CC 23 D4                 .#.
        .byte   $03                             ; 86FA 03                       .
        brk                                     ; 86FB 00                       .
        brk                                     ; 86FC 00                       .
        brk                                     ; 86FD 00                       .
        cpy     LD423                           ; 86FE CC 23 D4                 .#.
        .byte   $03                             ; 8701 03                       .
        brk                                     ; 8702 00                       .
        brk                                     ; 8703 00                       .
        brk                                     ; 8704 00                       .
        cpy     $DC23                           ; 8705 CC 23 DC                 .#.
        .byte   $03                             ; 8708 03                       .
        brk                                     ; 8709 00                       .
        brk                                     ; 870A 00                       .
        brk                                     ; 870B 00                       .
        cpy     $DC23                           ; 870C CC 23 DC                 .#.
        .byte   $03                             ; 870F 03                       .
        brk                                     ; 8710 00                       .
        brk                                     ; 8711 00                       .
        brk                                     ; 8712 00                       .
        cpy     $F223                           ; 8713 CC 23 F2                 .#.
        brk                                     ; 8716 00                       .
        .byte   $F3                             ; 8717 F3                       .
        .byte   $23                             ; 8718 23                       #
        .byte   $E2                             ; 8719 E2                       .
        .byte   $03                             ; 871A 03                       .
        brk                                     ; 871B 00                       .
        brk                                     ; 871C 00                       .
        brk                                     ; 871D 00                       .
        brk                                     ; 871E 00                       .
        .byte   $23                             ; 871F 23                       #
        cmp     #$02                            ; 8720 C9 02                    ..
L8722:  asl     a                               ; 8722 0A                       .
        asl     a                               ; 8723 0A                       .
        asl     a                               ; 8724 0A                       .
        .byte   $23                             ; 8725 23                       #
        cmp     #$02                            ; 8726 C9 02                    ..
        ldy     #$A0                            ; 8728 A0 A0                    ..
        ldy     #$23                            ; 872A A0 23                    .#
        cmp     ($02),y                         ; 872C D1 02                    ..
        asl     a                               ; 872E 0A                       .
        asl     a                               ; 872F 0A                       .
        asl     a                               ; 8730 0A                       .
        .byte   $23                             ; 8731 23                       #
        cmp     ($02),y                         ; 8732 D1 02                    ..
        ldy     #$A0                            ; 8734 A0 A0                    ..
        ldy     #$23                            ; 8736 A0 23                    .#
        cmp     $0A02,y                         ; 8738 D9 02 0A                 ...
        asl     a                               ; 873B 0A                       .
        asl     a                               ; 873C 0A                       .
        .byte   $23                             ; 873D 23                       #
        cmp     $A002,y                         ; 873E D9 02 A0                 ...
        ldy     #$A0                            ; 8741 A0 A0                    ..
        .byte   $23                             ; 8743 23                       #
        beq     L8747                           ; 8744 F0 01                    ..
        php                                     ; 8746 08                       .
L8747:  .byte   $02                             ; 8747 02                       .
        .byte   $23                             ; 8748 23                       #
        cpy     $0A03                           ; 8749 CC 03 0A                 ...
        asl     a                               ; 874C 0A                       .
        asl     a                               ; 874D 0A                       .
        .byte   $02                             ; 874E 02                       .
        .byte   $23                             ; 874F 23                       #
        cpy     $A003                           ; 8750 CC 03 A0                 ...
        ldy     #$A0                            ; 8753 A0 A0                    ..
        jsr     LD423                           ; 8755 20 23 D4                  #.
        .byte   $03                             ; 8758 03                       .
        asl     a                               ; 8759 0A                       .
        asl     a                               ; 875A 0A                       .
        asl     a                               ; 875B 0A                       .
        .byte   $02                             ; 875C 02                       .
        .byte   $23                             ; 875D 23                       #
        .byte   $D4                             ; 875E D4                       .
        .byte   $03                             ; 875F 03                       .
        ldy     #$A0                            ; 8760 A0 A0                    ..
        ldy     #$20                            ; 8762 A0 20                    . 
        .byte   $23                             ; 8764 23                       #
        .byte   $DC                             ; 8765 DC                       .
        .byte   $03                             ; 8766 03                       .
        asl     a                               ; 8767 0A                       .
        asl     a                               ; 8768 0A                       .
        asl     a                               ; 8769 0A                       .
        .byte   $02                             ; 876A 02                       .
        .byte   $23                             ; 876B 23                       #
        .byte   $DC                             ; 876C DC                       .
        .byte   $03                             ; 876D 03                       .
        ldy     #$A0                            ; 876E A0 A0                    ..
        ldy     #$20                            ; 8770 A0 20                    . 
        .byte   $23                             ; 8772 23                       #
        .byte   $F2                             ; 8773 F2                       .
        brk                                     ; 8774 00                       .
        php                                     ; 8775 08                       .
        .byte   $23                             ; 8776 23                       #
        .byte   $E2                             ; 8777 E2                       .
        .byte   $03                             ; 8778 03                       .
        ldy     #$A0                            ; 8779 A0 A0                    ..
        ldy     #$A0                            ; 877B A0 A0                    ..
L877D:  jsr     L0A00                           ; 877D 20 00 0A                  ..
        brk                                     ; 8780 00                       .
        brk                                     ; 8781 00                       .
        brk                                     ; 8782 00                       .
        brk                                     ; 8783 00                       .
        brk                                     ; 8784 00                       .
        brk                                     ; 8785 00                       .
        brk                                     ; 8786 00                       .
        brk                                     ; 8787 00                       .
        brk                                     ; 8788 00                       .
        brk                                     ; 8789 00                       .
        brk                                     ; 878A 00                       .
        jsr     L0A00                           ; 878B 20 00 0A                  ..
        brk                                     ; 878E 00                       .
        brk                                     ; 878F 00                       .
        brk                                     ; 8790 00                       .
        brk                                     ; 8791 00                       .
        brk                                     ; 8792 00                       .
        brk                                     ; 8793 00                       .
        brk                                     ; 8794 00                       .
        brk                                     ; 8795 00                       .
        brk                                     ; 8796 00                       .
        brk                                     ; 8797 00                       .
        brk                                     ; 8798 00                       .
        .byte   $FF                             ; 8799 FF                       .
L879A:  jsr     L2120                           ; 879A 20 20 21                   !
        and     ($21,x)                         ; 879D 21 21                    !!
        and     ($20,x)                         ; 879F 21 20                    ! 
        jsr     L2121                           ; 87A1 20 21 21                  !!
        and     ($21,x)                         ; 87A4 21 21                    !!
L87A6:  sty     $C4                             ; 87A6 84 C4                    ..
        .byte   $04                             ; 87A8 04                       .
        .byte   $44                             ; 87A9 44                       D
        sty     $C4                             ; 87AA 84 C4                    ..
        .byte   $92                             ; 87AC 92                       .
        .byte   $D2                             ; 87AD D2                       .
        .byte   $12                             ; 87AE 12                       .
        .byte   $52                             ; 87AF 52                       R
        .byte   $92                             ; 87B0 92                       .
        .byte   $D2                             ; 87B1 D2                       .
L87B2:  .byte   $23                             ; 87B2 23                       #
        bvs     L87BB                           ; 87B3 70 06                    p.
        sty     $84                             ; 87B5 84 84                    ..
        sty     $84                             ; 87B7 84 84                    ..
        sty     $84                             ; 87B9 84 84                    ..
L87BB:  sty     $FF                             ; 87BB 84 FF                    ..
L87BD:  jsr     L2120                           ; 87BD 20 20 21                   !
        and     ($21,x)                         ; 87C0 21 21                    !!
        and     ($20,x)                         ; 87C2 21 20                    ! 
        jsr     L2121                           ; 87C4 20 21 21                  !!
        and     ($21,x)                         ; 87C7 21 21                    !!
        .byte   $22                             ; 87C9 22                       "
L87CA:  tay                                     ; 87CA A8                       .
        inx                                     ; 87CB E8                       .
        plp                                     ; 87CC 28                       (
        pla                                     ; 87CD 68                       h
        tay                                     ; 87CE A8                       .
        inx                                     ; 87CF E8                       .
        ldx     $F6,y                           ; 87D0 B6 F6                    ..
        rol     $76,x                           ; 87D2 36 76                    6v
        ldx     $F6,y                           ; 87D4 B6 F6                    ..
        .byte   $6E                             ; 87D6 6E                       n
L87D7:  jsr     L0600                           ; 87D7 20 00 06                  ..
        sty     $84                             ; 87DA 84 84                    ..
        sty     $84                             ; 87DC 84 84                    ..
        sty     $84                             ; 87DE 84 84                    ..
        sty     $23                             ; 87E0 84 23                    .#
        lsr     L0000                           ; 87E2 46 00                    F.
        brk                                     ; 87E4 00                       .
        .byte   $23                             ; 87E5 23                       #
        eor     a:L0000                         ; 87E6 4D 00 00                 M..
        .byte   $FF                             ; 87E9 FF                       .
L87EA:  .byte   $23                             ; 87EA 23                       #
        eor     a:L0000                         ; 87EB 4D 00 00                 M..
        .byte   $23                             ; 87EE 23                       #
        eor     a:L0000,x                       ; 87EF 5D 00 00                 ]..
        .byte   $FF                             ; 87F2 FF                       .
        eor     $FF,x                           ; 87F3 55 FF                    U.
        .byte   $DF                             ; 87F5 DF                       .
        .byte   $FF                             ; 87F6 FF                       .
        .byte   $F7                             ; 87F7 F7                       .
        .byte   $FF                             ; 87F8 FF                       .
        sbc     $7FEF,x                         ; 87F9 FD EF 7F                 ...
        .byte   $FF                             ; 87FC FF                       .
        adc     $55FF,x                         ; 87FD 7D FF 55                 }.U
        brk                                     ; 8800 00                       .
        brk                                     ; 8801 00                       .
        brk                                     ; 8802 00                       .
        brk                                     ; 8803 00                       .
        brk                                     ; 8804 00                       .
        brk                                     ; 8805 00                       .
        brk                                     ; 8806 00                       .
        brk                                     ; 8807 00                       .
        brk                                     ; 8808 00                       .
        brk                                     ; 8809 00                       .
        brk                                     ; 880A 00                       .
        brk                                     ; 880B 00                       .
        brk                                     ; 880C 00                       .
        brk                                     ; 880D 00                       .
        brk                                     ; 880E 00                       .
        brk                                     ; 880F 00                       .
        ora     ($01,x)                         ; 8810 01 01                    ..
        ora     ($01,x)                         ; 8812 01 01                    ..
        ora     ($01,x)                         ; 8814 01 01                    ..
        ora     ($01,x)                         ; 8816 01 01                    ..
        ora     (L0000,x)                       ; 8818 01 00                    ..
        ora     ($01,x)                         ; 881A 01 01                    ..
        ora     ($01,x)                         ; 881C 01 01                    ..
        brk                                     ; 881E 00                       .
        brk                                     ; 881F 00                       .
        ora     ($01,x)                         ; 8820 01 01                    ..
        brk                                     ; 8822 00                       .
        brk                                     ; 8823 00                       .
        brk                                     ; 8824 00                       .
        ora     ($80,x)                         ; 8825 01 80                    ..
        brk                                     ; 8827 00                       .
        ora     ($01,x)                         ; 8828 01 01                    ..
        ora     ($01,x)                         ; 882A 01 01                    ..
        .byte   $80                             ; 882C 80                       .
        .byte   $80                             ; 882D 80                       .
        brk                                     ; 882E 00                       .
        brk                                     ; 882F 00                       .
        brk                                     ; 8830 00                       .
        ora     ($01,x)                         ; 8831 01 01                    ..
        ora     ($01,x)                         ; 8833 01 01                    ..
        brk                                     ; 8835 00                       .
        ora     ($80,x)                         ; 8836 01 80                    ..
        brk                                     ; 8838 00                       .
        ora     ($03,x)                         ; 8839 01 03                    ..
        .byte   $03                             ; 883B 03                       .
        .byte   $80                             ; 883C 80                       .
        brk                                     ; 883D 00                       .
        ora     ($80,x)                         ; 883E 01 80                    ..
        .byte   $03                             ; 8840 03                       .
        brk                                     ; 8841 00                       .
        brk                                     ; 8842 00                       .
        brk                                     ; 8843 00                       .
        brk                                     ; 8844 00                       .
        brk                                     ; 8845 00                       .
        brk                                     ; 8846 00                       .
        .byte   $80                             ; 8847 80                       .
        brk                                     ; 8848 00                       .
        brk                                     ; 8849 00                       .
        brk                                     ; 884A 00                       .
        brk                                     ; 884B 00                       .
        brk                                     ; 884C 00                       .
        brk                                     ; 884D 00                       .
        brk                                     ; 884E 00                       .
        brk                                     ; 884F 00                       .
        ora     ($80,x)                         ; 8850 01 80                    ..
        ora     ($01,x)                         ; 8852 01 01                    ..
        ora     ($80,x)                         ; 8854 01 80                    ..
        ora     (L0000,x)                       ; 8856 01 00                    ..
        .byte   $80                             ; 8858 80                       .
        ora     ($01,x)                         ; 8859 01 01                    ..
        brk                                     ; 885B 00                       .
        ora     L0000                           ; 885C 05 00                    ..
        brk                                     ; 885E 00                       .
        brk                                     ; 885F 00                       .
        ora     ($80,x)                         ; 8860 01 80                    ..
        ora     ($01,x)                         ; 8862 01 01                    ..
        ora     ($01,x)                         ; 8864 01 01                    ..
        ora     ($01,x)                         ; 8866 01 01                    ..
        ora     ($01,x)                         ; 8868 01 01                    ..
        .byte   $80                             ; 886A 80                       .
        ora     ($80,x)                         ; 886B 01 80                    ..
        brk                                     ; 886D 00                       .
        ora     ($80,x)                         ; 886E 01 80                    ..
        brk                                     ; 8870 00                       .
        brk                                     ; 8871 00                       .
        brk                                     ; 8872 00                       .
        brk                                     ; 8873 00                       .
        brk                                     ; 8874 00                       .
        brk                                     ; 8875 00                       .
        brk                                     ; 8876 00                       .
        brk                                     ; 8877 00                       .
        brk                                     ; 8878 00                       .
        brk                                     ; 8879 00                       .
        brk                                     ; 887A 00                       .
        ora     (L0000,x)                       ; 887B 01 00                    ..
        brk                                     ; 887D 00                       .
        .byte   $80                             ; 887E 80                       .
        .byte   $80                             ; 887F 80                       .
        .byte   $80                             ; 8880 80                       .
        ora     ($80,x)                         ; 8881 01 80                    ..
        ora     ($80,x)                         ; 8883 01 80                    ..
        .byte   $80                             ; 8885 80                       .
        ora     ($80,x)                         ; 8886 01 80                    ..
        brk                                     ; 8888 00                       .
        ora     ($80,x)                         ; 8889 01 80                    ..
        .byte   $80                             ; 888B 80                       .
L888C:  brk                                     ; 888C 00                       .
        .byte   $04                             ; 888D 04                       .
        .byte   $80                             ; 888E 80                       .
        .byte   $80                             ; 888F 80                       .
        .byte   $80                             ; 8890 80                       .
        ora     (L0000,x)                       ; 8891 01 00                    ..
        ora     ($80,x)                         ; 8893 01 80                    ..
        .byte   $80                             ; 8895 80                       .
        .byte   $03                             ; 8896 03                       .
        .byte   $80                             ; 8897 80                       .
        ora     (L0000,x)                       ; 8898 01 00                    ..
        .byte   $80                             ; 889A 80                       .
        .byte   $80                             ; 889B 80                       .
        brk                                     ; 889C 00                       .
        .byte   $80                             ; 889D 80                       .
        brk                                     ; 889E 00                       .
        .byte   $80                             ; 889F 80                       .
        brk                                     ; 88A0 00                       .
        brk                                     ; 88A1 00                       .
        brk                                     ; 88A2 00                       .
        brk                                     ; 88A3 00                       .
        brk                                     ; 88A4 00                       .
        brk                                     ; 88A5 00                       .
        brk                                     ; 88A6 00                       .
        .byte   $80                             ; 88A7 80                       .
        .byte   $80                             ; 88A8 80                       .
        brk                                     ; 88A9 00                       .
        brk                                     ; 88AA 00                       .
        .byte   $80                             ; 88AB 80                       .
        brk                                     ; 88AC 00                       .
        brk                                     ; 88AD 00                       .
        brk                                     ; 88AE 00                       .
        brk                                     ; 88AF 00                       .
        brk                                     ; 88B0 00                       .
        brk                                     ; 88B1 00                       .
        brk                                     ; 88B2 00                       .
        brk                                     ; 88B3 00                       .
        brk                                     ; 88B4 00                       .
        brk                                     ; 88B5 00                       .
        brk                                     ; 88B6 00                       .
        brk                                     ; 88B7 00                       .
        brk                                     ; 88B8 00                       .
        brk                                     ; 88B9 00                       .
        brk                                     ; 88BA 00                       .
        brk                                     ; 88BB 00                       .
        brk                                     ; 88BC 00                       .
        ora     ($02,x)                         ; 88BD 01 02                    ..
        brk                                     ; 88BF 00                       .
        brk                                     ; 88C0 00                       .
        brk                                     ; 88C1 00                       .
        brk                                     ; 88C2 00                       .
        brk                                     ; 88C3 00                       .
        ora     (L0000,x)                       ; 88C4 01 00                    ..
        brk                                     ; 88C6 00                       .
        brk                                     ; 88C7 00                       .
        brk                                     ; 88C8 00                       .
        brk                                     ; 88C9 00                       .
        brk                                     ; 88CA 00                       .
        brk                                     ; 88CB 00                       .
        brk                                     ; 88CC 00                       .
        brk                                     ; 88CD 00                       .
        brk                                     ; 88CE 00                       .
        brk                                     ; 88CF 00                       .
        brk                                     ; 88D0 00                       .
        brk                                     ; 88D1 00                       .
        brk                                     ; 88D2 00                       .
        brk                                     ; 88D3 00                       .
        brk                                     ; 88D4 00                       .
        brk                                     ; 88D5 00                       .
        brk                                     ; 88D6 00                       .
        brk                                     ; 88D7 00                       .
        brk                                     ; 88D8 00                       .
        brk                                     ; 88D9 00                       .
        brk                                     ; 88DA 00                       .
        brk                                     ; 88DB 00                       .
        brk                                     ; 88DC 00                       .
        brk                                     ; 88DD 00                       .
        brk                                     ; 88DE 00                       .
        brk                                     ; 88DF 00                       .
        brk                                     ; 88E0 00                       .
        brk                                     ; 88E1 00                       .
        brk                                     ; 88E2 00                       .
        brk                                     ; 88E3 00                       .
        brk                                     ; 88E4 00                       .
        brk                                     ; 88E5 00                       .
        brk                                     ; 88E6 00                       .
        brk                                     ; 88E7 00                       .
        brk                                     ; 88E8 00                       .
        brk                                     ; 88E9 00                       .
        brk                                     ; 88EA 00                       .
        brk                                     ; 88EB 00                       .
        brk                                     ; 88EC 00                       .
        brk                                     ; 88ED 00                       .
        brk                                     ; 88EE 00                       .
        brk                                     ; 88EF 00                       .
        brk                                     ; 88F0 00                       .
        brk                                     ; 88F1 00                       .
        brk                                     ; 88F2 00                       .
        brk                                     ; 88F3 00                       .
        brk                                     ; 88F4 00                       .
        brk                                     ; 88F5 00                       .
        brk                                     ; 88F6 00                       .
        brk                                     ; 88F7 00                       .
        brk                                     ; 88F8 00                       .
        brk                                     ; 88F9 00                       .
        brk                                     ; 88FA 00                       .
        brk                                     ; 88FB 00                       .
        brk                                     ; 88FC 00                       .
        brk                                     ; 88FD 00                       .
        brk                                     ; 88FE 00                       .
        brk                                     ; 88FF 00                       .
        brk                                     ; 8900 00                       .
        ora     ($02,x)                         ; 8901 01 02                    ..
        .byte   $03                             ; 8903 03                       .
        .byte   $04                             ; 8904 04                       .
        ora     $06                             ; 8905 05 06                    ..
        .byte   $07                             ; 8907 07                       .
        php                                     ; 8908 08                       .
        ora     #$0A                            ; 8909 09 0A                    ..
        .byte   $0B                             ; 890B 0B                       .
        .byte   $0C                             ; 890C 0C                       .
        ora     $0F0E                           ; 890D 0D 0E 0F                 ...
        .byte   $0F                             ; 8910 0F                       .
        .byte   $0F                             ; 8911 0F                       .
        .byte   $0F                             ; 8912 0F                       .
        .byte   $0F                             ; 8913 0F                       .
        .byte   $0F                             ; 8914 0F                       .
        .byte   $0F                             ; 8915 0F                       .
        .byte   $0F                             ; 8916 0F                       .
        .byte   $0F                             ; 8917 0F                       .
        .byte   $0F                             ; 8918 0F                       .
        .byte   $0F                             ; 8919 0F                       .
        .byte   $0F                             ; 891A 0F                       .
        .byte   $0F                             ; 891B 0F                       .
        .byte   $0F                             ; 891C 0F                       .
        .byte   $0F                             ; 891D 0F                       .
        .byte   $0F                             ; 891E 0F                       .
        .byte   $0F                             ; 891F 0F                       .
        .byte   $0F                             ; 8920 0F                       .
        .byte   $0F                             ; 8921 0F                       .
        .byte   $0F                             ; 8922 0F                       .
        .byte   $0F                             ; 8923 0F                       .
        .byte   $0F                             ; 8924 0F                       .
        .byte   $0F                             ; 8925 0F                       .
        .byte   $0F                             ; 8926 0F                       .
        .byte   $0F                             ; 8927 0F                       .
        .byte   $0F                             ; 8928 0F                       .
        .byte   $0F                             ; 8929 0F                       .
        .byte   $0F                             ; 892A 0F                       .
        .byte   $0F                             ; 892B 0F                       .
        .byte   $0F                             ; 892C 0F                       .
        .byte   $0F                             ; 892D 0F                       .
        .byte   $0F                             ; 892E 0F                       .
        .byte   $0F                             ; 892F 0F                       .
        .byte   $0F                             ; 8930 0F                       .
        .byte   $0F                             ; 8931 0F                       .
        .byte   $0F                             ; 8932 0F                       .
        .byte   $0F                             ; 8933 0F                       .
        .byte   $0F                             ; 8934 0F                       .
        .byte   $0F                             ; 8935 0F                       .
        .byte   $0F                             ; 8936 0F                       .
        .byte   $0F                             ; 8937 0F                       .
        .byte   $0F                             ; 8938 0F                       .
        .byte   $0F                             ; 8939 0F                       .
        .byte   $0F                             ; 893A 0F                       .
        .byte   $0F                             ; 893B 0F                       .
        .byte   $0F                             ; 893C 0F                       .
        .byte   $0F                             ; 893D 0F                       .
        .byte   $0F                             ; 893E 0F                       .
        ora     ($12),y                         ; 893F 11 12                    ..
        .byte   $13                             ; 8941 13                       .
        .byte   $14                             ; 8942 14                       .
        ora     L0010,x                         ; 8943 15 10                    ..
        brk                                     ; 8945 00                       .
        brk                                     ; 8946 00                       .
        brk                                     ; 8947 00                       .
        brk                                     ; 8948 00                       .
        brk                                     ; 8949 00                       .
        brk                                     ; 894A 00                       .
        brk                                     ; 894B 00                       .
        brk                                     ; 894C 00                       .
        brk                                     ; 894D 00                       .
        brk                                     ; 894E 00                       .
        brk                                     ; 894F 00                       .
        .byte   $23                             ; 8950 23                       #
        rti                                     ; 8951 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; 8952 40                       @

; ----------------------------------------------------------------------------
        adc     ($20,x)                         ; 8953 61 20                    a 
        .byte   $80                             ; 8955 80                       .
        ldy     #$22                            ; 8956 A0 22                    ."
        and     $20,x                           ; 8958 35 20                    5 
        .byte   $3A                             ; 895A 3A                       :
        jsr     L2020                           ; 895B 20 20 20                    
        jsr     L0000                           ; 895E 20 00 00                  ..
        brk                                     ; 8961 00                       .
        brk                                     ; 8962 00                       .
        brk                                     ; 8963 00                       .
        brk                                     ; 8964 00                       .
        brk                                     ; 8965 00                       .
        brk                                     ; 8966 00                       .
        brk                                     ; 8967 00                       .
        clc                                     ; 8968 18                       .
        clc                                     ; 8969 18                       .
        clc                                     ; 896A 18                       .
        clc                                     ; 896B 18                       .
        .byte   $04                             ; 896C 04                       .
        .byte   $04                             ; 896D 04                       .
        .byte   $04                             ; 896E 04                       .
        .byte   $17                             ; 896F 17                       .
        ora     $04                             ; 8970 05 04                    ..
        ora     $05                             ; 8972 05 05                    ..
        and     $B480                           ; 8974 2D 80 B4                 -..
        brk                                     ; 8977 00                       .
        brk                                     ; 8978 00                       .
        brk                                     ; 8979 00                       .
        brk                                     ; 897A 00                       .
        brk                                     ; 897B 00                       .
        brk                                     ; 897C 00                       .
        brk                                     ; 897D 00                       .
        brk                                     ; 897E 00                       .
        brk                                     ; 897F 00                       .
        sty     $86                             ; 8980 84 86                    ..
        brk                                     ; 8982 00                       .
        brk                                     ; 8983 00                       .
        brk                                     ; 8984 00                       .
        brk                                     ; 8985 00                       .
        brk                                     ; 8986 00                       .
        brk                                     ; 8987 00                       .
        .byte   $0F                             ; 8988 0F                       .
        jsr     L1110                           ; 8989 20 10 11                  ..
        .byte   $0F                             ; 898C 0F                       .
        jsr     L1827                           ; 898D 20 27 18                  '.
        .byte   $0F                             ; 8990 0F                       .
        jsr     L1C2C                           ; 8991 20 2C 1C                  ,.
        .byte   $0F                             ; 8994 0F                       .
        bpl     L8997                           ; 8995 10 00                    ..
L8997:  php                                     ; 8997 08                       .
        brk                                     ; 8998 00                       .
        brk                                     ; 8999 00                       .
        .byte   $89                             ; 899A 89                       .
        brk                                     ; 899B 00                       .
        .byte   $0F                             ; 899C 0F                       .
        jsr     L1110                           ; 899D 20 10 11                  ..
        .byte   $0F                             ; 89A0 0F                       .
        jsr     L211C                           ; 89A1 20 1C 21                  .!
        .byte   $0F                             ; 89A4 0F                       .
        bpl     L89C3                           ; 89A5 10 1C                    ..
        .byte   $0C                             ; 89A7 0C                       .
        .byte   $0F                             ; 89A8 0F                       .
        bpl     L89AB                           ; 89A9 10 00                    ..
L89AB:  php                                     ; 89AB 08                       .
        brk                                     ; 89AC 00                       .
        brk                                     ; 89AD 00                       .
        brk                                     ; 89AE 00                       .
        brk                                     ; 89AF 00                       .
        brk                                     ; 89B0 00                       .
        brk                                     ; 89B1 00                       .
        brk                                     ; 89B2 00                       .
        brk                                     ; 89B3 00                       .
        brk                                     ; 89B4 00                       .
        brk                                     ; 89B5 00                       .
        brk                                     ; 89B6 00                       .
        brk                                     ; 89B7 00                       .
        brk                                     ; 89B8 00                       .
        brk                                     ; 89B9 00                       .
        brk                                     ; 89BA 00                       .
        brk                                     ; 89BB 00                       .
        brk                                     ; 89BC 00                       .
        brk                                     ; 89BD 00                       .
        brk                                     ; 89BE 00                       .
        brk                                     ; 89BF 00                       .
        brk                                     ; 89C0 00                       .
        ora     (L0000,x)                       ; 89C1 01 00                    ..
L89C3:  brk                                     ; 89C3 00                       .
        brk                                     ; 89C4 00                       .
        brk                                     ; 89C5 00                       .
        brk                                     ; 89C6 00                       .
        brk                                     ; 89C7 00                       .
        brk                                     ; 89C8 00                       .
        brk                                     ; 89C9 00                       .
        brk                                     ; 89CA 00                       .
        brk                                     ; 89CB 00                       .
        brk                                     ; 89CC 00                       .
        brk                                     ; 89CD 00                       .
        brk                                     ; 89CE 00                       .
        brk                                     ; 89CF 00                       .
        brk                                     ; 89D0 00                       .
        brk                                     ; 89D1 00                       .
        brk                                     ; 89D2 00                       .
        brk                                     ; 89D3 00                       .
        brk                                     ; 89D4 00                       .
        brk                                     ; 89D5 00                       .
        brk                                     ; 89D6 00                       .
        brk                                     ; 89D7 00                       .
        brk                                     ; 89D8 00                       .
        brk                                     ; 89D9 00                       .
        brk                                     ; 89DA 00                       .
        brk                                     ; 89DB 00                       .
        brk                                     ; 89DC 00                       .
        brk                                     ; 89DD 00                       .
        brk                                     ; 89DE 00                       .
        brk                                     ; 89DF 00                       .
        .byte   $FF                             ; 89E0 FF                       .
        brk                                     ; 89E1 00                       .
        brk                                     ; 89E2 00                       .
        brk                                     ; 89E3 00                       .
        brk                                     ; 89E4 00                       .
        brk                                     ; 89E5 00                       .
        brk                                     ; 89E6 00                       .
        brk                                     ; 89E7 00                       .
        brk                                     ; 89E8 00                       .
        brk                                     ; 89E9 00                       .
        brk                                     ; 89EA 00                       .
        bpl     L89ED                           ; 89EB 10 00                    ..
L89ED:  brk                                     ; 89ED 00                       .
        brk                                     ; 89EE 00                       .
        brk                                     ; 89EF 00                       .
        brk                                     ; 89F0 00                       .
        brk                                     ; 89F1 00                       .
        brk                                     ; 89F2 00                       .
        brk                                     ; 89F3 00                       .
        brk                                     ; 89F4 00                       .
        brk                                     ; 89F5 00                       .
        brk                                     ; 89F6 00                       .
        brk                                     ; 89F7 00                       .
        brk                                     ; 89F8 00                       .
        brk                                     ; 89F9 00                       .
        brk                                     ; 89FA 00                       .
        jsr     L0000                           ; 89FB 20 00 00                  ..
        brk                                     ; 89FE 00                       .
        brk                                     ; 89FF 00                       .
        ora     ($01,x)                         ; 8A00 01 01                    ..
        ora     ($01,x)                         ; 8A02 01 01                    ..
        .byte   $02                             ; 8A04 02                       .
        .byte   $02                             ; 8A05 02                       .
        .byte   $03                             ; 8A06 03                       .
        .byte   $03                             ; 8A07 03                       .
        .byte   $03                             ; 8A08 03                       .
        ora     $05                             ; 8A09 05 05                    ..
        asl     $06                             ; 8A0B 06 06                    ..
        asl     $06                             ; 8A0D 06 06                    ..
        .byte   $07                             ; 8A0F 07                       .
        .byte   $07                             ; 8A10 07                       .
        .byte   $07                             ; 8A11 07                       .
        .byte   $07                             ; 8A12 07                       .
        .byte   $07                             ; 8A13 07                       .
        php                                     ; 8A14 08                       .
        ora     #$0A                            ; 8A15 09 0A                    ..
        .byte   $0C                             ; 8A17 0C                       .
        .byte   $0D                             ; 8A18 0D                       .
        .byte   $0D                             ; 8A19 0D                       .
L8A1A:  .byte   $0F                             ; 8A1A 0F                       .
        bpl     L8A2E                           ; 8A1B 10 11                    ..
        .byte   $12                             ; 8A1D 12                       .
        .byte   $13                             ; 8A1E 13                       .
        .byte   $14                             ; 8A1F 14                       .
        ora     $16,x                           ; 8A20 15 16                    ..
        .byte   $17                             ; 8A22 17                       .
        clc                                     ; 8A23 18                       .
        ora     $1B1A,y                         ; 8A24 19 1A 1B                 ...
        .byte   $1C                             ; 8A27 1C                       .
        .byte   $1D                             ; 8A28 1D                       .
        .byte   $1D                             ; 8A29 1D                       .
L8A2A:  .byte   $1F                             ; 8A2A 1F                       .
        jsr     L2221                           ; 8A2B 20 21 22                  !"
L8A2E:  bit     $26                             ; 8A2E 24 26                    $&
        plp                                     ; 8A30 28                       (
        .byte   $29                             ; 8A31 29                       )
L8A32:  rol     a                               ; 8A32 2A                       *
L8A33:  .byte   $2B                             ; 8A33 2B                       +
        bit     $2E2D                           ; 8A34 2C 2D 2E                 ,-.
        .byte   $2F                             ; 8A37 2F                       /
        .byte   $2F                             ; 8A38 2F                       /
        and     ($31),y                         ; 8A39 31 31                    11
        .byte   $34                             ; 8A3B 34                       4
        .byte   $34                             ; 8A3C 34                       4
        rol     $38,x                           ; 8A3D 36 38                    68
        sec                                     ; 8A3F 38                       8
        sec                                     ; 8A40 38                       8
        and     $3B39,y                         ; 8A41 39 39 3B                 99;
        .byte   $3C                             ; 8A44 3C                       <
        and     $3E3E,x                         ; 8A45 3D 3E 3E                 =>>
        .byte   $3F                             ; 8A48 3F                       ?
        eor     ($41,x)                         ; 8A49 41 41                    AA
        .byte   $42                             ; 8A4B 42                       B
L8A4C:  .byte   $42                             ; 8A4C 42                       B
        .byte   $43                             ; 8A4D 43                       C
        .byte   $FF                             ; 8A4E FF                       .
        brk                                     ; 8A4F 00                       .
L8A50:  brk                                     ; 8A50 00                       .
        brk                                     ; 8A51 00                       .
        brk                                     ; 8A52 00                       .
        brk                                     ; 8A53 00                       .
        brk                                     ; 8A54 00                       .
        brk                                     ; 8A55 00                       .
        brk                                     ; 8A56 00                       .
        brk                                     ; 8A57 00                       .
        brk                                     ; 8A58 00                       .
L8A59:  brk                                     ; 8A59 00                       .
        brk                                     ; 8A5A 00                       .
        .byte   $04                             ; 8A5B 04                       .
        brk                                     ; 8A5C 00                       .
        brk                                     ; 8A5D 00                       .
        brk                                     ; 8A5E 00                       .
        brk                                     ; 8A5F 00                       .
        brk                                     ; 8A60 00                       .
        brk                                     ; 8A61 00                       .
        brk                                     ; 8A62 00                       .
        brk                                     ; 8A63 00                       .
        brk                                     ; 8A64 00                       .
        brk                                     ; 8A65 00                       .
        brk                                     ; 8A66 00                       .
        brk                                     ; 8A67 00                       .
        brk                                     ; 8A68 00                       .
        brk                                     ; 8A69 00                       .
        brk                                     ; 8A6A 00                       .
L8A6B:  brk                                     ; 8A6B 00                       .
L8A6C:  brk                                     ; 8A6C 00                       .
        brk                                     ; 8A6D 00                       .
        brk                                     ; 8A6E 00                       .
        brk                                     ; 8A6F 00                       .
        brk                                     ; 8A70 00                       .
        brk                                     ; 8A71 00                       .
        brk                                     ; 8A72 00                       .
        brk                                     ; 8A73 00                       .
        brk                                     ; 8A74 00                       .
        brk                                     ; 8A75 00                       .
        brk                                     ; 8A76 00                       .
        brk                                     ; 8A77 00                       .
        brk                                     ; 8A78 00                       .
        brk                                     ; 8A79 00                       .
        brk                                     ; 8A7A 00                       .
        brk                                     ; 8A7B 00                       .
L8A7C:  brk                                     ; 8A7C 00                       .
        brk                                     ; 8A7D 00                       .
        brk                                     ; 8A7E 00                       .
        brk                                     ; 8A7F 00                       .
        rts                                     ; 8A80 60                       `

; ----------------------------------------------------------------------------
        bvs     L8A6B                           ; 8A81 70 E8                    p.
        .byte   $FF                             ; 8A83 FF                       .
        bvs     L8A32                           ; 8A84 70 AC                    p.
L8A86:  dey                                     ; 8A86 88                       .
L8A87:  tay                                     ; 8A87 A8                       .
        bne     L8A1A                           ; 8A88 D0 90                    ..
        bcs     L8A4C                           ; 8A8A B0 C0                    ..
        iny                                     ; 8A8C C8                       .
        .byte   $F0                             ; 8A8D F0                       .
L8A8E:  .byte   $FF                             ; 8A8E FF                       .
        cli                                     ; 8A8F 58                       X
        bcc     L8A2A                           ; 8A90 90 98                    ..
        .byte   $F0                             ; 8A92 F0                       .
L8A93:  .byte   $FF                             ; 8A93 FF                       .
        .byte   $80                             ; 8A94 80                       .
        .byte   $80                             ; 8A95 80                       .
        .byte   $80                             ; 8A96 80                       .
        brk                                     ; 8A97 00                       .
        brk                                     ; 8A98 00                       .
        cld                                     ; 8A99 D8                       .
        .byte   $F0                             ; 8A9A F0                       .
L8A9B:  .byte   $D0,$90                    ; 8A9B D0 90   (branch out of range for ca65: target has no local label)
        inx                                     ; 8A9D E8                       .
L8A9E:  .byte   $80                             ; 8A9E 80                       .
        cpx     #$98                            ; 8A9F E0 98                    ..
        bpl     L8A33                           ; 8AA1 10 90                    ..
        beq     L8B15                           ; 8AA3 F0 70                    .p
        bne     L8A87                           ; 8AA5 D0 E0                    ..
        ldy     #$30                            ; 8AA7 A0 30                    .0
        bne     L8A9B                           ; 8AA9 D0 F0                    ..
L8AAB:  cpx     #$70                            ; 8AAB E0 70                    .p
        brk                                     ; 8AAD 00                       .
        cpy     #$78                            ; 8AAE C0 78                    .x
        bpl     L8B02                           ; 8AB0 10 50                    .P
L8AB2:  bcs     L8B0C                           ; 8AB2 B0 58                    .X
        clv                                     ; 8AB4 B8                       .
        cpx     #$C0                            ; 8AB5 E0 C0                    ..
        .byte   $30                             ; 8AB7 30                       0
L8AB8:  ldy     #$10                            ; 8AB8 A0 10                    ..
        .byte   $F0,$40                    ; 8ABA F0 40   (branch out of range for ca65: target has no local label)
        bvs     L8ACE                           ; 8ABC 70 10                    p.
        bvs     L8A50                           ; 8ABE 70 90                    p.
        bcs     L8AD2                           ; 8AC0 B0 10                    ..
        beq     L8AD4                           ; 8AC2 F0 10                    ..
        bcs     L8AD6                           ; 8AC4 B0 10                    ..
        .byte   $10                             ; 8AC6 10                       .
L8AC7:  .byte   $F0,$20                    ; 8AC7 F0 20   (branch out of range for ca65: target has no local label)
L8AC9:  brk                                     ; 8AC9 00                       .
        cpx     #$00                            ; 8ACA E0 00                    ..
        brk                                     ; 8ACC 00                       .
        cld                                     ; 8ACD D8                       .
L8ACE:  .byte   $FF                             ; 8ACE FF                       .
        brk                                     ; 8ACF 00                       .
        brk                                     ; 8AD0 00                       .
        brk                                     ; 8AD1 00                       .
L8AD2:  brk                                     ; 8AD2 00                       .
        brk                                     ; 8AD3 00                       .
L8AD4:  brk                                     ; 8AD4 00                       .
        brk                                     ; 8AD5 00                       .
L8AD6:  brk                                     ; 8AD6 00                       .
        brk                                     ; 8AD7 00                       .
        brk                                     ; 8AD8 00                       .
        brk                                     ; 8AD9 00                       .
        brk                                     ; 8ADA 00                       .
        brk                                     ; 8ADB 00                       .
        brk                                     ; 8ADC 00                       .
        brk                                     ; 8ADD 00                       .
        brk                                     ; 8ADE 00                       .
        brk                                     ; 8ADF 00                       .
        brk                                     ; 8AE0 00                       .
        brk                                     ; 8AE1 00                       .
        brk                                     ; 8AE2 00                       .
        brk                                     ; 8AE3 00                       .
        brk                                     ; 8AE4 00                       .
        brk                                     ; 8AE5 00                       .
        brk                                     ; 8AE6 00                       .
L8AE7:  brk                                     ; 8AE7 00                       .
        brk                                     ; 8AE8 00                       .
        .byte   $80                             ; 8AE9 80                       .
        brk                                     ; 8AEA 00                       .
        brk                                     ; 8AEB 00                       .
        brk                                     ; 8AEC 00                       .
        brk                                     ; 8AED 00                       .
        brk                                     ; 8AEE 00                       .
        brk                                     ; 8AEF 00                       .
        brk                                     ; 8AF0 00                       .
        brk                                     ; 8AF1 00                       .
        brk                                     ; 8AF2 00                       .
        brk                                     ; 8AF3 00                       .
        brk                                     ; 8AF4 00                       .
        brk                                     ; 8AF5 00                       .
        brk                                     ; 8AF6 00                       .
        brk                                     ; 8AF7 00                       .
        brk                                     ; 8AF8 00                       .
        brk                                     ; 8AF9 00                       .
        brk                                     ; 8AFA 00                       .
        brk                                     ; 8AFB 00                       .
        brk                                     ; 8AFC 00                       .
        .byte   $04                             ; 8AFD 04                       .
        brk                                     ; 8AFE 00                       .
        rti                                     ; 8AFF 40                       @

; ----------------------------------------------------------------------------
        sta     ($40,x)                         ; 8B00 81 40                    .@
L8B02:  cpy     #$81                            ; 8B02 C0 81                    ..
        bcs     L8AB2                           ; 8B04 B0 AC                    ..
        .byte   $90                             ; 8B06 90                       .
L8B07:  .byte   $70,$58                    ; 8B07 70 58   (branch out of range for ca65: target has no local label)
        tya                                     ; 8B09 98                       .
        ldy     #$96                            ; 8B0A A0 96                    ..
L8B0C:  bcc     L8A9E                           ; 8B0C 90 90                    ..
        brk                                     ; 8B0E 00                       .
        bcs     L8AE7                           ; 8B0F B0 D6                    ..
        bne     L8AC9                           ; 8B11 D0 B6                    ..
        brk                                     ; 8B13 00                       .
        .byte   $B0                             ; 8B14 B0                       .
L8B15:  beq     L8B07                           ; 8B15 F0 F0                    ..
        brk                                     ; 8B17 00                       .
        brk                                     ; 8B18 00                       .
        sty     $8C                             ; 8B19 84 8C                    ..
        sty     L8C8C                           ; 8B1B 8C 8C 8C                 ...
        sty     L8C8C                           ; 8B1E 8C 8C 8C                 ...
        sty     L8C8C                           ; 8B21 8C 8C 8C                 ...
        sty     L888C                           ; 8B24 8C 8C 88                 ...
        dey                                     ; 8B27 88                       .
        sty     L808C                           ; 8B28 8C 8C 80                 ...
        dey                                     ; 8B2B 88                       .
        dey                                     ; 8B2C 88                       .
        sty     $30A0                           ; 8B2D 8C A0 30                 ..0
        sty     $7080                           ; 8B30 8C 80 70                 ..p
        sty     L8070                           ; 8B33 8C 70 80                 .p.
        rts                                     ; 8B36 60                       `

; ----------------------------------------------------------------------------
        sty     L8C80                           ; 8B37 8C 80 8C                 ...
        sty     $608C                           ; 8B3A 8C 8C 60                 ..`
        bmi     L8AC7                           ; 8B3D 30 88                    0.
        .byte   $80                             ; 8B3F 80                       .
        cli                                     ; 8B40 58                       X
        sty     L8030                           ; 8B41 8C 30 80                 .0.
        dey                                     ; 8B44 88                       .
        .byte   $80                             ; 8B45 80                       .
        sty     L8C30                           ; 8B46 8C 30 8C                 .0.
        brk                                     ; 8B49 00                       .
        ldy     L0000,x                         ; 8B4A B4 00                    ..
        brk                                     ; 8B4C 00                       .
        brk                                     ; 8B4D 00                       .
        .byte   $FF                             ; 8B4E FF                       .
        brk                                     ; 8B4F 00                       .
        brk                                     ; 8B50 00                       .
        brk                                     ; 8B51 00                       .
        brk                                     ; 8B52 00                       .
        brk                                     ; 8B53 00                       .
        brk                                     ; 8B54 00                       .
        brk                                     ; 8B55 00                       .
        brk                                     ; 8B56 00                       .
        brk                                     ; 8B57 00                       .
        brk                                     ; 8B58 00                       .
        brk                                     ; 8B59 00                       .
        brk                                     ; 8B5A 00                       .
        brk                                     ; 8B5B 00                       .
        brk                                     ; 8B5C 00                       .
L8B5D:  brk                                     ; 8B5D 00                       .
        brk                                     ; 8B5E 00                       .
        brk                                     ; 8B5F 00                       .
        brk                                     ; 8B60 00                       .
        brk                                     ; 8B61 00                       .
        brk                                     ; 8B62 00                       .
        brk                                     ; 8B63 00                       .
        brk                                     ; 8B64 00                       .
        brk                                     ; 8B65 00                       .
        brk                                     ; 8B66 00                       .
        brk                                     ; 8B67 00                       .
        brk                                     ; 8B68 00                       .
        brk                                     ; 8B69 00                       .
        brk                                     ; 8B6A 00                       .
        brk                                     ; 8B6B 00                       .
        brk                                     ; 8B6C 00                       .
        brk                                     ; 8B6D 00                       .
        brk                                     ; 8B6E 00                       .
        brk                                     ; 8B6F 00                       .
        brk                                     ; 8B70 00                       .
        brk                                     ; 8B71 00                       .
        brk                                     ; 8B72 00                       .
        brk                                     ; 8B73 00                       .
        brk                                     ; 8B74 00                       .
        brk                                     ; 8B75 00                       .
        brk                                     ; 8B76 00                       .
        brk                                     ; 8B77 00                       .
L8B78:  brk                                     ; 8B78 00                       .
        brk                                     ; 8B79 00                       .
        brk                                     ; 8B7A 00                       .
        brk                                     ; 8B7B 00                       .
        brk                                     ; 8B7C 00                       .
        brk                                     ; 8B7D 00                       .
        brk                                     ; 8B7E 00                       .
        brk                                     ; 8B7F 00                       .
        .byte   $13                             ; 8B80 13                       .
        asl     $0E13                           ; 8B81 0E 13 0E                 ...
        .byte   $13                             ; 8B84 13                       .
        .byte   $0F                             ; 8B85 0F                       .
        eor     ($41,x)                         ; 8B86 41 41                    AA
        sty     $83                             ; 8B88 84 83                    ..
        .byte   $13                             ; 8B8A 13                       .
        bmi     L8BA0                           ; 8B8B 30 13                    0.
        .byte   $13                             ; 8B8D 13                       .
        iny                                     ; 8B8E C8                       .
        bmi     L8BC1                           ; 8B8F 30 30                    00
        .byte   $13                             ; 8B91 13                       .
        bmi     L8B5D                           ; 8B92 30 C9                    0.
        lsr     a                               ; 8B94 4A                       J
        lsr     a                               ; 8B95 4A                       J
        lsr     a                               ; 8B96 4A                       J
        nop                                     ; 8B97 EA                       .
        .byte   $EB                             ; 8B98 EB                       .
        lsr     $0B0B                           ; 8B99 4E 0B 0B                 N..
        .byte   $0B                             ; 8B9C 0B                       .
        .byte   $0B                             ; 8B9D 0B                       .
        .byte   $17                             ; 8B9E 17                       .
        .byte   $0B                             ; 8B9F 0B                       .
L8BA0:  .byte   $0B                             ; 8BA0 0B                       .
        plp                                     ; 8BA1 28                       (
        .byte   $0B                             ; 8BA2 0B                       .
        .byte   $0B                             ; 8BA3 0B                       .
        plp                                     ; 8BA4 28                       (
        .byte   $0B                             ; 8BA5 0B                       .
        .byte   $3A                             ; 8BA6 3A                       :
        .byte   $3A                             ; 8BA7 3A                       :
        .byte   $0B                             ; 8BA8 0B                       .
        plp                                     ; 8BA9 28                       (
        .byte   $3A                             ; 8BAA 3A                       :
        .byte   $3A                             ; 8BAB 3A                       :
        .byte   $3A                             ; 8BAC 3A                       :
        .byte   $0B                             ; 8BAD 0B                       .
        bvc     L8BEA                           ; 8BAE 50 3A                    P:
        plp                                     ; 8BB0 28                       (
        .byte   $3A                             ; 8BB1 3A                       :
        .byte   $3A                             ; 8BB2 3A                       :
        plp                                     ; 8BB3 28                       (
        .byte   $3A                             ; 8BB4 3A                       :
        .byte   $3A                             ; 8BB5 3A                       :
        .byte   $3A                             ; 8BB6 3A                       :
        plp                                     ; 8BB7 28                       (
        .byte   $3A                             ; 8BB8 3A                       :
        .byte   $17                             ; 8BB9 17                       .
        plp                                     ; 8BBA 28                       (
        plp                                     ; 8BBB 28                       (
        .byte   $3A                             ; 8BBC 3A                       :
        .byte   $3A                             ; 8BBD 3A                       :
        .byte   $3A                             ; 8BBE 3A                       :
        .byte   $3A                             ; 8BBF 3A                       :
        .byte   $89                             ; 8BC0 89                       .
L8BC1:  .byte   $17                             ; 8BC1 17                       .
        .byte   $3A                             ; 8BC2 3A                       :
        .byte   $3A                             ; 8BC3 3A                       :
        .byte   $3A                             ; 8BC4 3A                       :
        .byte   $3A                             ; 8BC5 3A                       :
        .byte   $17                             ; 8BC6 17                       .
        .byte   $3A                             ; 8BC7 3A                       :
        .byte   $3A                             ; 8BC8 3A                       :
        nop                                     ; 8BC9 EA                       .
        ora     $C8CE,x                         ; 8BCA 1D CE C8                 ...
        .byte   $67                             ; 8BCD 67                       g
        .byte   $FF                             ; 8BCE FF                       .
        brk                                     ; 8BCF 00                       .
        brk                                     ; 8BD0 00                       .
        brk                                     ; 8BD1 00                       .
        brk                                     ; 8BD2 00                       .
        brk                                     ; 8BD3 00                       .
        brk                                     ; 8BD4 00                       .
        brk                                     ; 8BD5 00                       .
        brk                                     ; 8BD6 00                       .
        brk                                     ; 8BD7 00                       .
        brk                                     ; 8BD8 00                       .
        brk                                     ; 8BD9 00                       .
        brk                                     ; 8BDA 00                       .
        brk                                     ; 8BDB 00                       .
        brk                                     ; 8BDC 00                       .
        brk                                     ; 8BDD 00                       .
        brk                                     ; 8BDE 00                       .
        brk                                     ; 8BDF 00                       .
        brk                                     ; 8BE0 00                       .
        brk                                     ; 8BE1 00                       .
        brk                                     ; 8BE2 00                       .
        brk                                     ; 8BE3 00                       .
        brk                                     ; 8BE4 00                       .
        brk                                     ; 8BE5 00                       .
        brk                                     ; 8BE6 00                       .
        brk                                     ; 8BE7 00                       .
        brk                                     ; 8BE8 00                       .
        brk                                     ; 8BE9 00                       .
L8BEA:  brk                                     ; 8BEA 00                       .
        brk                                     ; 8BEB 00                       .
        brk                                     ; 8BEC 00                       .
        brk                                     ; 8BED 00                       .
        brk                                     ; 8BEE 00                       .
        brk                                     ; 8BEF 00                       .
        brk                                     ; 8BF0 00                       .
        brk                                     ; 8BF1 00                       .
        brk                                     ; 8BF2 00                       .
        brk                                     ; 8BF3 00                       .
        brk                                     ; 8BF4 00                       .
        brk                                     ; 8BF5 00                       .
        brk                                     ; 8BF6 00                       .
        brk                                     ; 8BF7 00                       .
        brk                                     ; 8BF8 00                       .
        brk                                     ; 8BF9 00                       .
        brk                                     ; 8BFA 00                       .
        brk                                     ; 8BFB 00                       .
        brk                                     ; 8BFC 00                       .
        brk                                     ; 8BFD 00                       .
        brk                                     ; 8BFE 00                       .
        brk                                     ; 8BFF 00                       .
        brk                                     ; 8C00 00                       .
        brk                                     ; 8C01 00                       .
        .byte   $04                             ; 8C02 04                       .
        asl     $09                             ; 8C03 06 09                    ..
        ora     #$0B                            ; 8C05 09 0B                    ..
        .byte   $0F                             ; 8C07 0F                       .
        .byte   $14                             ; 8C08 14                       .
        ora     $16,x                           ; 8C09 15 16                    ..
        .byte   $17                             ; 8C0B 17                       .
        .byte   $17                             ; 8C0C 17                       .
        clc                                     ; 8C0D 18                       .
        .byte   $1A                             ; 8C0E 1A                       .
        .byte   $1A                             ; 8C0F 1A                       .
        .byte   $1B                             ; 8C10 1B                       .
        .byte   $1C                             ; 8C11 1C                       .
        ora     $1F1E,x                         ; 8C12 1D 1E 1F                 ...
        jsr     L2221                           ; 8C15 20 21 22                  !"
        .byte   $23                             ; 8C18 23                       #
        bit     $25                             ; 8C19 24 25                    $%
        rol     $27                             ; 8C1B 26 27                    &'
        plp                                     ; 8C1D 28                       (
        rol     a                               ; 8C1E 2A                       *
        rol     a                               ; 8C1F 2A                       *
        .byte   $2B                             ; 8C20 2B                       +
        bit     $2E2D                           ; 8C21 2C 2D 2E                 ,-.
        rol     $2F2F                           ; 8C24 2E 2F 2F                 .//
        bmi     L8C59                           ; 8C27 30 30                    00
        and     ($32),y                         ; 8C29 31 32                    12
        .byte   $33                             ; 8C2B 33                       3
        .byte   $34                             ; 8C2C 34                       4
        and     $36,x                           ; 8C2D 35 36                    56
        .byte   $37                             ; 8C2F 37                       7
L8C30:  and     $3B39,y                         ; 8C30 39 39 3B                 99;
        .byte   $3B                             ; 8C33 3B                       ;
        .byte   $3B                             ; 8C34 3B                       ;
        and     $3E3D,x                         ; 8C35 3D 3D 3E                 ==>
        rol     $4341,x                         ; 8C38 3E 41 43                 >AC
        .byte   $43                             ; 8C3B 43                       C
        .byte   $44                             ; 8C3C 44                       D
        eor     $46                             ; 8C3D 45 46                    EF
        pha                                     ; 8C3F 48                       H
        eor     #$49                            ; 8C40 49 49                    II
        .byte   $4B                             ; 8C42 4B                       K
        eor     a:L0000                         ; 8C43 4D 00 00                 M..
        brk                                     ; 8C46 00                       .
        brk                                     ; 8C47 00                       .
        brk                                     ; 8C48 00                       .
        brk                                     ; 8C49 00                       .
        brk                                     ; 8C4A 00                       .
        brk                                     ; 8C4B 00                       .
        brk                                     ; 8C4C 00                       .
        brk                                     ; 8C4D 00                       .
        brk                                     ; 8C4E 00                       .
        brk                                     ; 8C4F 00                       .
        brk                                     ; 8C50 00                       .
        brk                                     ; 8C51 00                       .
        brk                                     ; 8C52 00                       .
        brk                                     ; 8C53 00                       .
        bpl     L8C56                           ; 8C54 10 00                    ..
L8C56:  brk                                     ; 8C56 00                       .
        brk                                     ; 8C57 00                       .
        brk                                     ; 8C58 00                       .
L8C59:  brk                                     ; 8C59 00                       .
        brk                                     ; 8C5A 00                       .
        brk                                     ; 8C5B 00                       .
        brk                                     ; 8C5C 00                       .
        brk                                     ; 8C5D 00                       .
        brk                                     ; 8C5E 00                       .
        brk                                     ; 8C5F 00                       .
        brk                                     ; 8C60 00                       .
        brk                                     ; 8C61 00                       .
        brk                                     ; 8C62 00                       .
        brk                                     ; 8C63 00                       .
        brk                                     ; 8C64 00                       .
        brk                                     ; 8C65 00                       .
        brk                                     ; 8C66 00                       .
        brk                                     ; 8C67 00                       .
        brk                                     ; 8C68 00                       .
        brk                                     ; 8C69 00                       .
        brk                                     ; 8C6A 00                       .
        brk                                     ; 8C6B 00                       .
        brk                                     ; 8C6C 00                       .
        brk                                     ; 8C6D 00                       .
        brk                                     ; 8C6E 00                       .
        brk                                     ; 8C6F 00                       .
        brk                                     ; 8C70 00                       .
        brk                                     ; 8C71 00                       .
        brk                                     ; 8C72 00                       .
        brk                                     ; 8C73 00                       .
        brk                                     ; 8C74 00                       .
        brk                                     ; 8C75 00                       .
        .byte   $80                             ; 8C76 80                       .
        brk                                     ; 8C77 00                       .
        brk                                     ; 8C78 00                       .
        brk                                     ; 8C79 00                       .
        brk                                     ; 8C7A 00                       .
        brk                                     ; 8C7B 00                       .
        brk                                     ; 8C7C 00                       .
        brk                                     ; 8C7D 00                       .
        .byte   $80                             ; 8C7E 80                       .
        brk                                     ; 8C7F 00                       .
L8C80:  brk                                     ; 8C80 00                       .
        brk                                     ; 8C81 00                       .
        brk                                     ; 8C82 00                       .
        brk                                     ; 8C83 00                       .
        brk                                     ; 8C84 00                       .
        brk                                     ; 8C85 00                       .
        php                                     ; 8C86 08                       .
        brk                                     ; 8C87 00                       .
        brk                                     ; 8C88 00                       .
        brk                                     ; 8C89 00                       .
        brk                                     ; 8C8A 00                       .
        brk                                     ; 8C8B 00                       .
L8C8C:  brk                                     ; 8C8C 00                       .
        brk                                     ; 8C8D 00                       .
        brk                                     ; 8C8E 00                       .
        brk                                     ; 8C8F 00                       .
        brk                                     ; 8C90 00                       .
        brk                                     ; 8C91 00                       .
        brk                                     ; 8C92 00                       .
        brk                                     ; 8C93 00                       .
        brk                                     ; 8C94 00                       .
        brk                                     ; 8C95 00                       .
        brk                                     ; 8C96 00                       .
        brk                                     ; 8C97 00                       .
        brk                                     ; 8C98 00                       .
        brk                                     ; 8C99 00                       .
        brk                                     ; 8C9A 00                       .
        brk                                     ; 8C9B 00                       .
        brk                                     ; 8C9C 00                       .
        brk                                     ; 8C9D 00                       .
        brk                                     ; 8C9E 00                       .
        brk                                     ; 8C9F 00                       .
        brk                                     ; 8CA0 00                       .
        brk                                     ; 8CA1 00                       .
        brk                                     ; 8CA2 00                       .
        brk                                     ; 8CA3 00                       .
        brk                                     ; 8CA4 00                       .
        brk                                     ; 8CA5 00                       .
        brk                                     ; 8CA6 00                       .
        brk                                     ; 8CA7 00                       .
        brk                                     ; 8CA8 00                       .
        brk                                     ; 8CA9 00                       .
        brk                                     ; 8CAA 00                       .
        brk                                     ; 8CAB 00                       .
        brk                                     ; 8CAC 00                       .
        brk                                     ; 8CAD 00                       .
        brk                                     ; 8CAE 00                       .
        brk                                     ; 8CAF 00                       .
        brk                                     ; 8CB0 00                       .
        brk                                     ; 8CB1 00                       .
        brk                                     ; 8CB2 00                       .
        brk                                     ; 8CB3 00                       .
        brk                                     ; 8CB4 00                       .
        brk                                     ; 8CB5 00                       .
        brk                                     ; 8CB6 00                       .
        brk                                     ; 8CB7 00                       .
        brk                                     ; 8CB8 00                       .
        brk                                     ; 8CB9 00                       .
        brk                                     ; 8CBA 00                       .
        brk                                     ; 8CBB 00                       .
        brk                                     ; 8CBC 00                       .
        brk                                     ; 8CBD 00                       .
        brk                                     ; 8CBE 00                       .
        brk                                     ; 8CBF 00                       .
        brk                                     ; 8CC0 00                       .
        brk                                     ; 8CC1 00                       .
        brk                                     ; 8CC2 00                       .
        brk                                     ; 8CC3 00                       .
        brk                                     ; 8CC4 00                       .
        brk                                     ; 8CC5 00                       .
        brk                                     ; 8CC6 00                       .
        brk                                     ; 8CC7 00                       .
        brk                                     ; 8CC8 00                       .
        brk                                     ; 8CC9 00                       .
        brk                                     ; 8CCA 00                       .
        brk                                     ; 8CCB 00                       .
        brk                                     ; 8CCC 00                       .
        brk                                     ; 8CCD 00                       .
        brk                                     ; 8CCE 00                       .
        brk                                     ; 8CCF 00                       .
        brk                                     ; 8CD0 00                       .
        brk                                     ; 8CD1 00                       .
        brk                                     ; 8CD2 00                       .
        brk                                     ; 8CD3 00                       .
        brk                                     ; 8CD4 00                       .
        brk                                     ; 8CD5 00                       .
        brk                                     ; 8CD6 00                       .
        brk                                     ; 8CD7 00                       .
        brk                                     ; 8CD8 00                       .
        brk                                     ; 8CD9 00                       .
        brk                                     ; 8CDA 00                       .
        brk                                     ; 8CDB 00                       .
        brk                                     ; 8CDC 00                       .
        brk                                     ; 8CDD 00                       .
        brk                                     ; 8CDE 00                       .
        brk                                     ; 8CDF 00                       .
        brk                                     ; 8CE0 00                       .
        brk                                     ; 8CE1 00                       .
        brk                                     ; 8CE2 00                       .
        brk                                     ; 8CE3 00                       .
        brk                                     ; 8CE4 00                       .
        brk                                     ; 8CE5 00                       .
        brk                                     ; 8CE6 00                       .
        brk                                     ; 8CE7 00                       .
        brk                                     ; 8CE8 00                       .
        brk                                     ; 8CE9 00                       .
        brk                                     ; 8CEA 00                       .
        brk                                     ; 8CEB 00                       .
        brk                                     ; 8CEC 00                       .
        brk                                     ; 8CED 00                       .
        brk                                     ; 8CEE 00                       .
        brk                                     ; 8CEF 00                       .
        brk                                     ; 8CF0 00                       .
        brk                                     ; 8CF1 00                       .
        brk                                     ; 8CF2 00                       .
        brk                                     ; 8CF3 00                       .
        brk                                     ; 8CF4 00                       .
        brk                                     ; 8CF5 00                       .
        brk                                     ; 8CF6 00                       .
        brk                                     ; 8CF7 00                       .
        brk                                     ; 8CF8 00                       .
        brk                                     ; 8CF9 00                       .
        brk                                     ; 8CFA 00                       .
        brk                                     ; 8CFB 00                       .
        brk                                     ; 8CFC 00                       .
        brk                                     ; 8CFD 00                       .
        brk                                     ; 8CFE 00                       .
        brk                                     ; 8CFF 00                       .
        brk                                     ; 8D00 00                       .
        sbc     ($02,x)                         ; 8D01 E1 02                    ..
        .byte   $04                             ; 8D03 04                       .
        cpy     #$00                            ; 8D04 C0 00                    ..
        bit     $01CE                           ; 8D06 2C CE 01                 ,..
        .byte   $74                             ; 8D09 74                       t
        .byte   $3F                             ; 8D0A 3F                       ?
        bit     $E0                             ; 8D0B 24 E0                    $.
        asl     $DFEF                           ; 8D0D 0E EF DF                 ...
        .byte   $80                             ; 8D10 80                       .
        .byte   $82                             ; 8D11 82                       .
        sty     $86                             ; 8D12 84 86                    ..
        dey                                     ; 8D14 88                       .
        txa                                     ; 8D15 8A                       .
        sty     $A08E                           ; 8D16 8C 8E A0                 ...
        ldx     #$A4                            ; 8D19 A2 A4                    ..
        ldx     $A8                             ; 8D1B A6 A8                    ..
        tax                                     ; 8D1D AA                       .
        ldy     a:$AE                           ; 8D1E AC AE 00                 ...
        rol     $0405,x                         ; 8D21 3E 05 04                 >..
        bmi     L8D58                           ; 8D24 30 32                    02
        rol     $5E,x                           ; 8D26 36 5E                    6^
        jsr     L2522                           ; 8D28 20 22 25                  "%
        bit     $20                             ; 8D2B 24 20                    $ 
        .byte   $22                             ; 8D2D 22                       "
        brk                                     ; 8D2E 00                       .
        brk                                     ; 8D2F 00                       .
        cmp     ($D1,x)                         ; 8D30 C1 D1                    ..
        jsr     L0422                           ; 8D32 20 22 04                  ".
        .byte   $C3                             ; 8D35 C3                       .
        .byte   $C3                             ; 8D36 C3                       .
        inc     $C1                             ; 8D37 E6 C1                    ..
        cmp     ($C1),y                         ; 8D39 D1 C1                    ..
        cmp     ($24),y                         ; 8D3B D1 24                    .$
        .byte   $E3                             ; 8D3D E3                       .
        .byte   $E3                             ; 8D3E E3                       .
        cpx     $4240                           ; 8D3F EC 40 42                 .@B
        .byte   $44                             ; 8D42 44                       D
        .byte   $44                             ; 8D43 44                       D
        lsr     $46                             ; 8D44 46 46                    FF
        pha                                     ; 8D46 48                       H
        lsr     a                               ; 8D47 4A                       J
        pla                                     ; 8D48 68                       h
        asl     $26                             ; 8D49 06 26                    .&
        brk                                     ; 8D4B 00                       .
        ror     a                               ; 8D4C 6A                       j
        lsr     a                               ; 8D4D 4A                       J
        pla                                     ; 8D4E 68                       h
        ror     a                               ; 8D4F 6A                       j
        rts                                     ; 8D50 60                       `

; ----------------------------------------------------------------------------
        .byte   $62                             ; 8D51 62                       b
        .byte   $64                             ; 8D52 64                       d
        .byte   $64                             ; 8D53 64                       d
        ror     $66                             ; 8D54 66 66                    ff
        ror     a                               ; 8D56 6A                       j
        ror     a                               ; 8D57 6A                       j
L8D58:  .byte   $D4                             ; 8D58 D4                       .
        ora     ($D4,x)                         ; 8D59 01 D4                    ..
        .byte   $0C                             ; 8D5B 0C                       .
        lsr     $106C                           ; 8D5C 4E 6C 10                 Nl.
        ldx     $08,y                           ; 8D5F B6 08                    ..
        asl     a                               ; 8D61 0A                       .
        ora     ($D6,x)                         ; 8D62 01 D6                    ..
        eor     $2E2E                           ; 8D64 4D 2E 2E                 M..
        brk                                     ; 8D67 00                       .
        plp                                     ; 8D68 28                       (
        rol     a                               ; 8D69 2A                       *
        ora     ($01,x)                         ; 8D6A 01 01                    ..
        eor     $3E3E,x                         ; 8D6C 5D 3E 3E                 ]>>
        brk                                     ; 8D6F 00                       .
        rol     $D4C5                           ; 8D70 2E C5 D4                 ...
        dec     $E4                             ; 8D73 C6 E4                    ..
        inc     L0000                           ; 8D75 E6 00                    ..
        brk                                     ; 8D77 00                       .
        rol     $D4D4,x                         ; 8D78 3E D4 D4                 >..
        .byte   $C7                             ; 8D7B C7                       .
        nop                                     ; 8D7C EA                       .
        cpx     $6E6F                           ; 8D7D EC 6F 6E                 .on
        ora     (L0010),y                       ; 8D80 11 10                    ..
        ora     ($81),y                         ; 8D82 11 81                    ..
        ora     ($11),y                         ; 8D84 11 11                    ..
        ora     ($B4),y                         ; 8D86 11 B4                    ..
        ora     ($11),y                         ; 8D88 11 11                    ..
        ora     ($01,x)                         ; 8D8A 01 01                    ..
        .byte   $89                             ; 8D8C 89                       .
        .byte   $83                             ; 8D8D 83                       .
        ora     ($86,x)                         ; 8D8E 01 86                    ..
        .byte   $92                             ; 8D90 92                       .
        ora     ($01,x)                         ; 8D91 01 01                    ..
        ora     (L0010,x)                       ; 8D93 01 10                    ..
        sta     $97,x                           ; 8D95 95 97                    ..
        tya                                     ; 8D97 98                       .
        .byte   $8F                             ; 8D98 8F                       .
        ora     ($11,x)                         ; 8D99 01 11                    ..
        .byte   $A7                             ; 8D9B A7                       .
        ora     ($11),y                         ; 8D9C 11 11                    ..
        sta     ($11,x)                         ; 8D9E 81 11                    ..
        dex                                     ; 8DA0 CA                       .
        nop                                     ; 8DA1 EA                       .
        .byte   $EB                             ; 8DA2 EB                       .
        .byte   $CB                             ; 8DA3 CB                       .
        ldx     $B6,y                           ; 8DA4 B6 B6                    ..
        tax                                     ; 8DA6 AA                       .
        ldx     $C2,y                           ; 8DA7 B6 C2                    ..
        .byte   $E2                             ; 8DA9 E2                       .
        cpy     #$01                            ; 8DAA C0 01                    ..
        inx                                     ; 8DAC E8                       .
        .byte   $E7                             ; 8DAD E7                       .
        ldy     $E1AE                           ; 8DAE AC AE E1                 ...
        .byte   $C3                             ; 8DB1 C3                       .
        .byte   $E3                             ; 8DB2 E3                       .
        cmp     ($EE,x)                         ; 8DB3 C1 EE                    ..
        inc     $B0B0                           ; 8DB5 EE B0 B0                 ...
        ora     ($01,x)                         ; 8DB8 01 01                    ..
        cpx     $B6E0                           ; 8DBA EC E0 B6                 ...
        brk                                     ; 8DBD 00                       .
        .byte   $B2                             ; 8DBE B2                       .
        .byte   $B2                             ; 8DBF B2                       .
        brk                                     ; 8DC0 00                       .
        brk                                     ; 8DC1 00                       .
        ora     $07                             ; 8DC2 05 07                    ..
        ora     #$00                            ; 8DC4 09 00                    ..
        dec     a:$2E                           ; 8DC6 CE 2E 00                 ...
        .byte   $23                             ; 8DC9 23                       #
        and     $27                             ; 8DCA 25 27                    %'
        and     #$2B                            ; 8DCC 29 2B                    )+
        brk                                     ; 8DCE 00                       .
        lsr     $43C8                           ; 8DCF 4E C8 43                 N.C
        eor     $47                             ; 8DD2 45 47                    EG
        eor     #$4B                            ; 8DD4 49 4B                    IK
        eor     $E86E                           ; 8DD6 4D 6E E8                 Mn.
        .byte   $63                             ; 8DD9 63                       c
        adc     $67                             ; 8DDA 65 67                    eg
        adc     #$6B                            ; 8DDC 69 6B                    ik
        adc     $D41D                           ; 8DDE 6D 1D D4                 m..
        .byte   $83                             ; 8DE1 83                       .
        sta     $87                             ; 8DE2 85 87                    ..
        .byte   $89                             ; 8DE4 89                       .
        .byte   $8B                             ; 8DE5 8B                       .
        sta     a:L0000                         ; 8DE6 8D 00 00                 ...
        .byte   $A3                             ; 8DE9 A3                       .
        lda     $A7                             ; 8DEA A5 A7                    ..
        lda     #$AB                            ; 8DEC A9 AB                    ..
        brk                                     ; 8DEE 00                       .
        .byte   $03                             ; 8DEF 03                       .
        brk                                     ; 8DF0 00                       .
        sta     ($C5,x)                         ; 8DF1 81 C5                    ..
        .byte   $C7                             ; 8DF3 C7                       .
        cmp     #$CD                            ; 8DF4 C9 CD                    ..
        ldy     #$40                            ; 8DF6 A0 40                    .@
        brk                                     ; 8DF8 00                       .
        lda     ($E5,x)                         ; 8DF9 A1 E5                    ..
        .byte   $E7                             ; 8DFB E7                       .
        sbc     #$ED                            ; 8DFC E9 ED                    ..
        .byte   $EF                             ; 8DFE EF                       .
        rts                                     ; 8DFF 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; 8E00 00                       .
        .byte   $E2                             ; 8E01 E2                       .
        .byte   $03                             ; 8E02 03                       .
        .byte   $04                             ; 8E03 04                       .
        .byte   $04                             ; 8E04 04                       .
        brk                                     ; 8E05 00                       .
        and     $01CF                           ; 8E06 2D CF 01                 -..
        rol     $243E                           ; 8E09 2E 3E 24                 .>$
        bit     $0D                             ; 8E0C 24 0D                    $.
        .byte   $CF                             ; 8E0E CF                       .
        dec     L8381,x                         ; 8E0F DE 81 83                 ...
        sta     $87                             ; 8E12 85 87                    ..
        .byte   $89                             ; 8E14 89                       .
        .byte   $8B                             ; 8E15 8B                       .
        sta     $A18F                           ; 8E16 8D 8F A1                 ...
        .byte   $A3                             ; 8E19 A3                       .
        lda     $A7                             ; 8E1A A5 A7                    ..
        lda     #$AB                            ; 8E1C A9 AB                    ..
        lda     a:$AF                           ; 8E1E AD AF 00                 ...
        rol     $0504,x                         ; 8E21 3E 04 05                 >..
        and     ($33),y                         ; 8E24 31 33                    13
        rol     $36,x                           ; 8E26 36 36                    66
        and     ($23,x)                         ; 8E28 21 23                    !#
        bit     $25                             ; 8E2A 24 25                    $%
        and     ($23,x)                         ; 8E2C 21 23                    !#
        brk                                     ; 8E2E 00                       .
        brk                                     ; 8E2F 00                       .
        .byte   $C2                             ; 8E30 C2                       .
        .byte   $D2                             ; 8E31 D2                       .
        and     ($23,x)                         ; 8E32 21 23                    !#
        .byte   $C3                             ; 8E34 C3                       .
        .byte   $04                             ; 8E35 04                       .
        .byte   $C3                             ; 8E36 C3                       .
        cmp     #$C2                            ; 8E37 C9 C2                    ..
        .byte   $D2                             ; 8E39 D2                       .
        .byte   $C2                             ; 8E3A C2                       .
        .byte   $D2                             ; 8E3B D2                       .
        .byte   $E3                             ; 8E3C E3                       .
        bit     $E3                             ; 8E3D 24 E3                    $.
        sbc     #$41                            ; 8E3F E9 41                    .A
        .byte   $43                             ; 8E41 43                       C
        .byte   $43                             ; 8E42 43                       C
        eor     $47                             ; 8E43 45 47                    EG
        eor     ($49,x)                         ; 8E45 41 49                    AI
        .byte   $4B                             ; 8E47 4B                       K
        adc     #$07                            ; 8E48 69 07                    i.
        .byte   $27                             ; 8E4A 27                       '
        brk                                     ; 8E4B 00                       .
        .byte   $6B                             ; 8E4C 6B                       k
        eor     #$69                            ; 8E4D 49 69                    Ii
        .byte   $6B                             ; 8E4F 6B                       k
        adc     ($63,x)                         ; 8E50 61 63                    ac
        .byte   $63                             ; 8E52 63                       c
        adc     $67                             ; 8E53 65 67                    eg
        adc     ($69,x)                         ; 8E55 61 69                    ai
        adc     #$D5                            ; 8E57 69 D5                    i.
        ora     ($D7,x)                         ; 8E59 01 D7                    ..
        .byte   $0F                             ; 8E5B 0F                       .
        .byte   $4F                             ; 8E5C 4F                       O
        adc     $B610                           ; 8E5D 6D 10 B6                 m..
        ora     #$0B                            ; 8E60 09 0B                    ..
        ora     ($D7,x)                         ; 8E62 01 D7                    ..
        rol     $4C2E                           ; 8E64 2E 2E 4C                 ..L
        brk                                     ; 8E67 00                       .
        and     #$2B                            ; 8E68 29 2B                    )+
        ora     ($01,x)                         ; 8E6A 01 01                    ..
        rol     $5C3E,x                         ; 8E6C 3E 3E 5C                 >>\
        brk                                     ; 8E6F 00                       .
        cpy     $C5                             ; 8E70 C4 C5                    ..
        cmp     $2E,x                           ; 8E72 D5 2E                    ..
        sbc     $E7                             ; 8E74 E5 E7                    ..
        brk                                     ; 8E76 00                       .
        brk                                     ; 8E77 00                       .
        .byte   $C7                             ; 8E78 C7                       .
        cmp     $D5,x                           ; 8E79 D5 D5                    ..
        rol     $EDEB,x                         ; 8E7B 3E EB ED                 >..
        .byte   $6F                             ; 8E7E 6F                       o
        .byte   $6F                             ; 8E7F 6F                       o
        ora     ($A6),y                         ; 8E80 11 A6                    ..
        .byte   $80                             ; 8E82 80                       .
        .byte   $82                             ; 8E83 82                       .
        ora     ($11),y                         ; 8E84 11 11                    ..
        ora     ($B0),y                         ; 8E86 11 B0                    ..
        ora     ($87),y                         ; 8E88 11 87                    ..
        ora     ($88,x)                         ; 8E8A 01 88                    ..
        txa                                     ; 8E8C 8A                       .
        sty     $85                             ; 8E8D 84 85                    ..
        ora     ($93),y                         ; 8E8F 11 93                    ..
        ora     ($01,x)                         ; 8E91 01 01                    ..
        sty     L0010,x                         ; 8E93 94 10                    ..
        stx     L0010,y                         ; 8E95 96 10                    ..
        sta     L9001,y                         ; 8E97 99 01 90                 ...
        .byte   $87                             ; 8E9A 87                       .
        tay                                     ; 8E9B A8                       .
        ora     ($80),y                         ; 8E9C 11 80                    ..
        .byte   $82                             ; 8E9E 82                       .
        ora     ($CB),y                         ; 8E9F 11 CB                    ..
        .byte   $EB                             ; 8EA1 EB                       .
        dex                                     ; 8EA2 CA                       .
        nop                                     ; 8EA3 EA                       .
        ldx     $B6,y                           ; 8EA4 B6 B6                    ..
        .byte   $AB                             ; 8EA6 AB                       .
        ldx     $C3,y                           ; 8EA7 B6 C3                    ..
        .byte   $E3                             ; 8EA9 E3                       .
        cmp     ($E1,x)                         ; 8EAA C1 E1                    ..
        sbc     #$AF                            ; 8EAC E9 AF                    ..
        lda     $C2AF                           ; 8EAE AD AF C2                 ...
        .byte   $E2                             ; 8EB1 E2                       .
        cpy     #$01                            ; 8EB2 C0 01                    ..
        .byte   $E7                             ; 8EB4 E7                       .
        inc     $B1B0                           ; 8EB5 EE B0 B1                 ...
        ora     ($01,x)                         ; 8EB8 01 01                    ..
        sbc     $B611                           ; 8EBA ED 11 B6                 ...
        brk                                     ; 8EBD 00                       .
        .byte   $B2                             ; 8EBE B2                       .
        .byte   $B3                             ; 8EBF B3                       .
        brk                                     ; 8EC0 00                       .
        brk                                     ; 8EC1 00                       .
        asl     $08                             ; 8EC2 06 08                    ..
        asl     a                               ; 8EC4 0A                       .
        brk                                     ; 8EC5 00                       .
        .byte   $CF                             ; 8EC6 CF                       .
        .byte   $2F                             ; 8EC7 2F                       /
        .byte   $12                             ; 8EC8 12                       .
        bit     $26                             ; 8EC9 24 26                    $&
        plp                                     ; 8ECB 28                       (
L8ECC:  rol     a                               ; 8ECC 2A                       *
        bit     $4F00                           ; 8ECD 2C 00 4F                 ,.O
        sbc     $44                             ; 8ED0 E5 44                    .D
        lsr     $48                             ; 8ED2 46 48                    FH
        lsr     a                               ; 8ED4 4A                       J
        jmp     L6F82                           ; 8ED5 4C 82 6F                 L.o

; ----------------------------------------------------------------------------
        .byte   $EB                             ; 8ED8 EB                       .
        .byte   $64                             ; 8ED9 64                       d
        ror     $68                             ; 8EDA 66 68                    fh
        ror     a                               ; 8EDC 6A                       j
        jmp     (L00A2)                         ; 8EDD 6C A2 00                 l..

; ----------------------------------------------------------------------------
        cmp     $84,x                           ; 8EE0 D5 84                    ..
        stx     $88                             ; 8EE2 86 88                    ..
        txa                                     ; 8EE4 8A                       .
        sty     a:$BD                           ; 8EE5 8C BD 00                 ...
        .byte   $80                             ; 8EE8 80                       .
        ldy     $A6                             ; 8EE9 A4 A6                    ..
        tay                                     ; 8EEB A8                       .
        tax                                     ; 8EEC AA                       .
        ldy     $2100                           ; 8EED AC 00 21                 ..!
        .byte   $42                             ; 8EF0 42                       B
        cpy     $C6                             ; 8EF1 C4 C6                    ..
        iny                                     ; 8EF3 C8                       .
        cpy     a:$AE                           ; 8EF4 CC AE 00                 ...
        eor     ($62,x)                         ; 8EF7 41 62                    Ab
        cpx     $E6                             ; 8EF9 E4 E6                    ..
        inx                                     ; 8EFB E8                       .
        cpx     a:$EE                           ; 8EFC EC EE 00                 ...
        adc     (L0000,x)                       ; 8EFF 61 00                    a.
        sbc     ($02),y                         ; 8F01 F1 02                    ..
        .byte   $14                             ; 8F03 14                       .
        bne     L8F45                           ; 8F04 D0 3F                    .?
        .byte   $3C                             ; 8F06 3C                       <
        dec     $3F01,x                         ; 8F07 DE 01 3F                 ..?
        .byte   $74                             ; 8F0A 74                       t
        .byte   $34                             ; 8F0B 34                       4
        beq     L8F2C                           ; 8F0C F0 1E                    ..
        inc     L90DE                           ; 8F0E EE DE 90                 ...
        .byte   $92                             ; 8F11 92                       .
        sty     $96,x                           ; 8F12 94 96                    ..
        tya                                     ; 8F14 98                       .
        txs                                     ; 8F15 9A                       .
        .byte   $9C                             ; 8F16 9C                       .
        .byte   $9E                             ; 8F17 9E                       .
        bcs     L8ECC                           ; 8F18 B0 B2                    ..
        ldy     $B6,x                           ; 8F1A B4 B6                    ..
        clv                                     ; 8F1C B8                       .
L8F1D:  tsx                                     ; 8F1D BA                       .
        ldy     $2FBE,x                         ; 8F1E BC BE 2F                 ../
        .byte   $2F                             ; 8F21 2F                       /
        ora     $14,x                           ; 8F22 15 14                    ..
        jsr     L3722                           ; 8F24 20 22 37                  "7
        ror     $2220,x                         ; 8F27 7E 20 22                 ~ "
        and     $34,x                           ; 8F2A 35 34                    54
L8F2C:  bmi     L8F60                           ; 8F2C 30 32                    02
        .byte   $13                             ; 8F2E 13                       .
        .byte   $12                             ; 8F2F 12                       .
        cmp     ($D1,x)                         ; 8F30 C1 D1                    ..
        cmp     ($D1,x)                         ; 8F32 C1 D1                    ..
        .byte   $14                             ; 8F34 14                       .
        .byte   $D3                             ; 8F35 D3                       .
        .byte   $D3                             ; 8F36 D3                       .
        inc     $30,x                           ; 8F37 F6 30                    .0
        .byte   $32                             ; 8F39 32                       2
L8F3A:  jsr     L3422                           ; 8F3A 20 22 34                  "4
        .byte   $F3                             ; 8F3D F3                       .
        .byte   $F3                             ; 8F3E F3                       .
        .byte   $FC                             ; 8F3F FC                       .
        bvc     L8F94                           ; 8F40 50 52                    PR
        .byte   $54                             ; 8F42 54                       T
        .byte   $54                             ; 8F43 54                       T
        .byte   $56                             ; 8F44 56                       V
L8F45:  lsr     $58,x                           ; 8F45 56 58                    VX
        .byte   $5A                             ; 8F47 5A                       Z
        cli                                     ; 8F48 58                       X
        asl     $CC,x                           ; 8F49 16 CC                    ..
        rol     $5A5A,x                         ; 8F4B 3E 5A 5A                 >ZZ
        sei                                     ; 8F4E 78                       x
        .byte   $7A                             ; 8F4F 7A                       z
        bvs     L8FC4                           ; 8F50 70 72                    pr
        .byte   $73                             ; 8F52 73                       s
        .byte   $73                             ; 8F53 73                       s
        ror     $76,x                           ; 8F54 76 76                    vv
        .byte   $5A                             ; 8F56 5A                       Z
        .byte   $7A                             ; 8F57 7A                       z
        ora     ($D4),y                         ; 8F58 11 D4                    ..
        ora     ($1C),y                         ; 8F5A 11 1C                    ..
        lsr     $107C                           ; 8F5C 4E 7C 10                 N|.
        .byte   $B7                             ; 8F5F B7                       .
L8F60:  clc                                     ; 8F60 18                       .
        .byte   $1A                             ; 8F61 1A                       .
        dec     $11,x                           ; 8F62 D6 11                    ..
        eor     $3E3E,x                         ; 8F64 5D 3E 3E                 ]>>
        rol     $3A38,x                         ; 8F67 3E 38 3A                 >8:
        ora     ($E5,x)                         ; 8F6A 01 E5                    ..
        eor     $2E2E                           ; 8F6C 4D 2E 2E                 M..
        eor     $FE3E,x                         ; 8F6F 5D 3E FE                 ]>.
        .byte   $DC                             ; 8F72 DC                       .
        .byte   $C7                             ; 8F73 C7                       .
        .byte   $F4                             ; 8F74 F4                       .
        inc     $5F,x                           ; 8F75 F6 5F                    ._
        lsr     $DA2E,x                         ; 8F77 5E 2E DA                 ^..
        .byte   $DC                             ; 8F7A DC                       .
        .byte   $D7                             ; 8F7B D7                       .
        .byte   $FA                             ; 8F7C FA                       .
        .byte   $FC                             ; 8F7D FC                       .
        .byte   $7F                             ; 8F7E 7F                       .
        ror     $1011,x                         ; 8F7F 7E 11 10                 ~..
        .byte   $83                             ; 8F82 83                       .
        ora     ($86,x)                         ; 8F83 01 86                    ..
        ora     ($81),y                         ; 8F85 11 81                    ..
        lda     $11,x                           ; 8F87 B5 11                    ..
        sty     $0101                           ; 8F89 8C 01 01                 ...
        bpl     L8F1D                           ; 8F8C 10 8F                    ..
        ora     ($91,x)                         ; 8F8E 01 91                    ..
        txs                                     ; 8F90 9A                       .
        .byte   $9C                             ; 8F91 9C                       .
        .byte   $9E                             ; 8F92 9E                       .
        .byte   $A0                             ; 8F93 A0                       .
L8F94:  bpl     L8FA6                           ; 8F94 10 10                    ..
        bpl     L8F3A                           ; 8F96 10 A2                    ..
        sta     $97,x                           ; 8F98 95 97                    ..
        lda     #$10                            ; 8F9A A9 10                    ..
        ldy     $83                             ; 8F9C A4 83                    ..
        ora     ($86,x)                         ; 8F9E 01 86                    ..
        .byte   $DA                             ; 8FA0 DA                       .
        .byte   $FA                             ; 8FA1 FA                       .
        .byte   $FB                             ; 8FA2 FB                       .
        .byte   $DB                             ; 8FA3 DB                       .
        cld                                     ; 8FA4 D8                       .
L8FA5:  .byte   $B7                             ; 8FA5 B7                       .
L8FA6:  tsx                                     ; 8FA6 BA                       .
        clv                                     ; 8FA7 B8                       .
        .byte   $D2                             ; 8FA8 D2                       .
        bpl     L8FBC                           ; 8FA9 10 11                    ..
        beq     L8FA5                           ; 8FAB F0 F8                    ..
        .byte   $F7                             ; 8FAD F7                       .
        ldy     $01BE,x                         ; 8FAE BC BE 01                 ...
        .byte   $D3                             ; 8FB1 D3                       .
        .byte   $F3                             ; 8FB2 F3                       .
        cmp     ($FE),y                         ; 8FB3 D1 FE                    ..
        inc     $B2B2,x                         ; 8FB5 FE B2 B2                 ...
        dec     $C4                             ; 8FB8 C6 C4                    ..
        .byte   $FC                             ; 8FBA FC                       .
        .byte   $F1                             ; 8FBB F1                       .
L8FBC:  .byte   $B7                             ; 8FBC B7                       .
        .byte   $B2                             ; 8FBD B2                       .
        .byte   $B2                             ; 8FBE B2                       .
        .byte   $B2                             ; 8FBF B2                       .
        brk                                     ; 8FC0 00                       .
        brk                                     ; 8FC1 00                       .
        ora     $17,x                           ; 8FC2 15 17                    ..
L8FC4:  ora     $DE1B,y                         ; 8FC4 19 1B DE                 ...
        rol     $3300,x                         ; 8FC7 3E 00 33                 >.3
        and     $37,x                           ; 8FCA 35 37                    57
        and     $3D3B,y                         ; 8FCC 39 3B 3D                 9;=
        lsr     $53D8,x                         ; 8FCF 5E D8 53                 ^.S
        eor     $57,x                           ; 8FD2 55 57                    UW
        eor     $5D5B,y                         ; 8FD4 59 5B 5D                 Y[]
        ora     $73F8                           ; 8FD7 0D F8 73                 ..s
        adc     $77,x                           ; 8FDA 75 77                    uw
        adc     $7D7B,y                         ; 8FDC 79 7B 7D                 y{}
        and     L93CA                           ; 8FDF 2D CA 93                 -..
        sta     $97,x                           ; 8FE2 95 97                    ..
        sta     L9D9B,y                         ; 8FE4 99 9B 9D                 ...
        brk                                     ; 8FE7 00                       .
        brk                                     ; 8FE8 00                       .
        .byte   $B3                             ; 8FE9 B3                       .
        lda     $B7,x                           ; 8FEA B5 B7                    ..
        lda     $BB,y                           ; 8FEC B9 BB 00                 ...
        bmi     L8FF1                           ; 8FEF 30 00                    0.
L8FF1:  sta     ($D5),y                         ; 8FF1 91 D5                    ..
        .byte   $D7                             ; 8FF3 D7                       .
        cmp     $B0DD,y                         ; 8FF4 D9 DD B0                 ...
        bvc     L8FF9                           ; 8FF7 50 00                    P.
L8FF9:  lda     ($F5),y                         ; 8FF9 B1 F5                    ..
        .byte   $F7                             ; 8FFB F7                       .
        sbc     $FFFD,y                         ; 8FFC F9 FD FF                 ...
        bvs     L9001                           ; 8FFF 70 00                    p.
L9001:  .byte   $F2                             ; 9001 F2                       .
        .byte   $03                             ; 9002 03                       .
        .byte   $14                             ; 9003 14                       .
        .byte   $14                             ; 9004 14                       .
        rol     $DF3D,x                         ; 9005 3E 3D DF                 >=.
        ora     ($3E,x)                         ; 9008 01 3E                    .>
        rol     $3434                           ; 900A 2E 34 34                 .44
        ora     $DFDF,x                         ; 900D 1D DF DF                 ...
        sta     ($93),y                         ; 9010 91 93                    ..
        sta     $97,x                           ; 9012 95 97                    ..
        sta     L9D9B,y                         ; 9014 99 9B 9D                 ...
        .byte   $9F                             ; 9017 9F                       .
        lda     ($B3),y                         ; 9018 B1 B3                    ..
L901A:  lda     $B7,x                           ; 901A B5 B7                    ..
        lda     $BDBB,y                         ; 901C B9 BB BD                 ...
        .byte   $BF                             ; 901F BF                       .
        .byte   $2F                             ; 9020 2F                       /
        .byte   $2F                             ; 9021 2F                       /
        .byte   $14                             ; 9022 14                       .
        ora     $21,x                           ; 9023 15 21                    .!
        .byte   $23                             ; 9025 23                       #
        .byte   $37                             ; 9026 37                       7
        .byte   $37                             ; 9027 37                       7
        and     ($23,x)                         ; 9028 21 23                    !#
        .byte   $34                             ; 902A 34                       4
        and     $31,x                           ; 902B 35 31                    51
        .byte   $33                             ; 902D 33                       3
        .byte   $13                             ; 902E 13                       .
        .byte   $13                             ; 902F 13                       .
        .byte   $C2                             ; 9030 C2                       .
        .byte   $D2                             ; 9031 D2                       .
        .byte   $C2                             ; 9032 C2                       .
        .byte   $D2                             ; 9033 D2                       .
        .byte   $D3                             ; 9034 D3                       .
        .byte   $14                             ; 9035 14                       .
        .byte   $D3                             ; 9036 D3                       .
        cmp     $3331,y                         ; 9037 D9 31 33                 .13
        .byte   $21                             ; 903A 21                       !
L903B:  .byte   $23                             ; 903B 23                       #
        .byte   $F3                             ; 903C F3                       .
        .byte   $34                             ; 903D 34                       4
        .byte   $F3                             ; 903E F3                       .
        sbc     $5351,y                         ; 903F F9 51 53                 .QS
        .byte   $53                             ; 9042 53                       S
        eor     $57,x                           ; 9043 55 57                    UW
        eor     ($59),y                         ; 9045 51 59                    QY
        .byte   $5B                             ; 9047 5B                       [
        eor     $CD17,y                         ; 9048 59 17 CD                 Y..
        .byte   $5C                             ; 904B 5C                       \
        .byte   $5B                             ; 904C 5B                       [
        eor     $7B79,y                         ; 904D 59 79 7B                 Yy{
        adc     ($73),y                         ; 9050 71 73                    qs
        .byte   $73                             ; 9052 73                       s
        adc     $77,x                           ; 9053 75 77                    uw
        adc     ($59),y                         ; 9055 71 59                    qY
        adc     $D511,y                         ; 9057 79 11 D5                 y..
        ora     ($1F),y                         ; 905A 11 1F                    ..
        .byte   $4F                             ; 905C 4F                       O
        adc     $B710,x                         ; 905D 7D 10 B7                 }..
        ora     $D71B,y                         ; 9060 19 1B D7                 ...
        ora     ($3E),y                         ; 9063 11 3E                    .>
        rol     $3E5C,x                         ; 9065 3E 5C 3E                 >\>
        and     $E43B,y                         ; 9068 39 3B E4                 9;.
        inc     $2E                             ; 906B E6 2E                    ..
        rol     $3E4C                           ; 906D 2E 4C 3E                 .L>
        .byte   $C7                             ; 9070 C7                       .
        inc     $3ECB,x                         ; 9071 FE CB 3E                 ..>
        sbc     $F7,x                           ; 9074 F5 F7                    ..
        .byte   $5F                             ; 9076 5F                       _
        .byte   $5F                             ; 9077 5F                       _
        dec     $DB,x                           ; 9078 D6 DB                    ..
        cmp     $FB2E,x                         ; 907A DD 2E FB                 ...
        sbc     $7F7F,x                         ; 907D FD 7F 7F                 ...
        ora     (L0010),y                       ; 9080 11 10                    ..
        sty     $85                             ; 9082 84 85                    ..
        ora     ($80),y                         ; 9084 11 80                    ..
        .byte   $82                             ; 9086 82                       .
        .byte   $B2                             ; 9087 B2                       .
        .byte   $8B                             ; 9088 8B                       .
        ora     ($01,x)                         ; 9089 01 01                    ..
        .byte   $8D                             ; 908B 8D                       .
        .byte   $8E                             ; 908C 8E                       .
L908D:  ora     ($90,x)                         ; 908D 01 90                    ..
L908F:  txa                                     ; 908F 8A                       .
        .byte   $9B                             ; 9090 9B                       .
        sta     $A19F,x                         ; 9091 9D 9F A1                 ...
        bpl     L90A6                           ; 9094 10 10                    ..
        bpl     L903B                           ; 9096 10 A3                    ..
        stx     L0010,y                         ; 9098 96 10                    ..
        ora     (L0010,x)                       ; 909A 01 10                    ..
        lda     $84                             ; 909C A5 84                    ..
L909E:  sta     $11                             ; 909E 85 11                    ..
        .byte   $DB                             ; 90A0 DB                       .
        .byte   $FB                             ; 90A1 FB                       .
        .byte   $DA                             ; 90A2 DA                       .
        .byte   $FA                             ; 90A3 FA                       .
        .byte   $D9                             ; 90A4 D9                       .
        .byte   $B9                             ; 90A5 B9                       .
L90A6:  .byte   $BB                             ; 90A6 BB                       .
        lda     $F3D3,y                         ; 90A7 B9 D3 F3                 ...
        cmp     ($01),y                         ; 90AA D1 01                    ..
L90AC:  sbc     $BDBF,y                         ; 90AC F9 BF BD                 ...
        .byte   $BF                             ; 90AF BF                       .
        .byte   $D2                             ; 90B0 D2                       .
        bpl     L90C4                           ; 90B1 10 11                    ..
        beq     L90AC                           ; 90B3 F0 F7                    ..
        inc     $B3B2,x                         ; 90B5 FE B2 B3                 ...
        .byte   $C7                             ; 90B8 C7                       .
        cmp     $FD                             ; 90B9 C5 FD                    ..
        .byte   $F2                             ; 90BB F2                       .
        lda     $B2B2,y                         ; 90BC B9 B2 B2                 ...
        .byte   $B3                             ; 90BF B3                       .
        .byte   $02                             ; 90C0 02                       .
        .byte   $14                             ; 90C1 14                       .
        asl     $18,x                           ; 90C2 16 18                    ..
L90C4:  .byte   $1A                             ; 90C4 1A                       .
        .byte   $13                             ; 90C5 13                       .
        .byte   $DF                             ; 90C6 DF                       .
        .byte   $3F                             ; 90C7 3F                       ?
        .byte   $22                             ; 90C8 22                       "
        .byte   $34                             ; 90C9 34                       4
        rol     $38,x                           ; 90CA 36 38                    68
        .byte   $3A                             ; 90CC 3A                       :
        .byte   $3C                             ; 90CD 3C                       <
        brk                                     ; 90CE 00                       .
        .byte   $5F                             ; 90CF 5F                       _
        sbc     $54,x                           ; 90D0 F5 54                    .T
        lsr     $58,x                           ; 90D2 56 58                    VX
        .byte   $5A                             ; 90D4 5A                       Z
        .byte   $5C                             ; 90D5 5C                       \
        .byte   $92                             ; 90D6 92                       .
        brk                                     ; 90D7 00                       .
        .byte   $FB                             ; 90D8 FB                       .
        .byte   $74                             ; 90D9 74                       t
        ror     $78,x                           ; 90DA 76 78                    vx
        .byte   $7A                             ; 90DC 7A                       z
        .byte   $7C                             ; 90DD 7C                       |
L90DE:  .byte   $B2                             ; 90DE B2                       .
        brk                                     ; 90DF 00                       .
        .byte   $DB                             ; 90E0 DB                       .
        sty     $96,x                           ; 90E1 94 96                    ..
        tya                                     ; 90E3 98                       .
        txs                                     ; 90E4 9A                       .
        .byte   $9C                             ; 90E5 9C                       .
        brk                                     ; 90E6 00                       .
        .byte   $03                             ; 90E7 03                       .
        bcc     L909E                           ; 90E8 90 B4                    ..
        ldx     $B8,y                           ; 90EA B6 B8                    ..
        tsx                                     ; 90EC BA                       .
        ldy     $3100,x                         ; 90ED BC 00 31                 ..1
        .byte   $52                             ; 90F0 52                       R
        .byte   $D4                             ; 90F1 D4                       .
        dec     $D8,x                           ; 90F2 D6 D8                    ..
        .byte   $DC                             ; 90F4 DC                       .
        ldx     $5100,y                         ; 90F5 BE 00 51                 ..Q
        .byte   $72                             ; 90F8 72                       r
        .byte   $F4                             ; 90F9 F4                       .
        inc     $F8,x                           ; 90FA F6 F8                    ..
        .byte   $FC                             ; 90FC FC                       .
        inc     $7100,x                         ; 90FD FE 00 71                 ..q
        brk                                     ; 9100 00                       .
        ora     (L0000),y                       ; 9101 11 00                    ..
        ora     ($01),y                         ; 9103 11 01                    ..
        .byte   $03                             ; 9105 03                       .
        beq     L9118                           ; 9106 F0 10                    ..
        ora     $03                             ; 9108 05 03                    ..
        .byte   $03                             ; 910A 03                       .
        ora     ($01),y                         ; 910B 11 01                    ..
        bpl     L910F                           ; 910D 10 00                    ..
L910F:  bpl     L9122                           ; 910F 10 11                    ..
        ora     ($11),y                         ; 9111 11 11                    ..
        ora     ($11),y                         ; 9113 11 11                    ..
        ora     ($11),y                         ; 9115 11 11                    ..
        .byte   $11                             ; 9117 11                       .
L9118:  ora     ($11),y                         ; 9118 11 11                    ..
        ora     ($11),y                         ; 911A 11 11                    ..
        ora     ($11),y                         ; 911C 11 11                    ..
        ora     ($11),y                         ; 911E 11 11                    ..
        .byte   $03                             ; 9120 03                       .
        .byte   $03                             ; 9121 03                       .
L9122:  ora     ($11),y                         ; 9122 11 11                    ..
        ora     ($11),y                         ; 9124 11 11                    ..
        .byte   $03                             ; 9126 03                       .
        .byte   $03                             ; 9127 03                       .
        ora     ($11),y                         ; 9128 11 11                    ..
        ora     ($11),y                         ; 912A 11 11                    ..
        ora     ($11),y                         ; 912C 11 11                    ..
        .byte   $03                             ; 912E 03                       .
        .byte   $03                             ; 912F 03                       .
        ora     ($11),y                         ; 9130 11 11                    ..
        ora     ($11),y                         ; 9132 11 11                    ..
        ora     ($11),y                         ; 9134 11 11                    ..
        ora     ($02),y                         ; 9136 11 02                    ..
        ora     ($11),y                         ; 9138 11 11                    ..
        ora     ($11),y                         ; 913A 11 11                    ..
        ora     ($11),y                         ; 913C 11 11                    ..
        ora     ($02),y                         ; 913E 11 02                    ..
        bpl     L9152                           ; 9140 10 10                    ..
        bpl     L9154                           ; 9142 10 10                    ..
        bpl     L9156                           ; 9144 10 10                    ..
        bpl     L9158                           ; 9146 10 10                    ..
        bpl     L915C                           ; 9148 10 12                    ..
        .byte   $12                             ; 914A 12                       .
        .byte   $03                             ; 914B 03                       .
        bpl     L915E                           ; 914C 10 10                    ..
        bpl     L9160                           ; 914E 10 10                    ..
        bpl     L9162                           ; 9150 10 10                    ..
L9152:  bpl     L9164                           ; 9152 10 10                    ..
L9154:  bpl     L9166                           ; 9154 10 10                    ..
L9156:  bpl     L9168                           ; 9156 10 10                    ..
L9158:  ora     ($11),y                         ; 9158 11 11                    ..
        ora     (L0010),y                       ; 915A 11 10                    ..
L915C:  bpl     L916E                           ; 915C 10 10                    ..
L915E:  bpl     L9162                           ; 915E 10 02                    ..
L9160:  bpl     L9172                           ; 9160 10 10                    ..
L9162:  ora     ($11),y                         ; 9162 11 11                    ..
L9164:  .byte   $03                             ; 9164 03                       .
        .byte   $03                             ; 9165 03                       .
L9166:  .byte   $03                             ; 9166 03                       .
        .byte   $03                             ; 9167 03                       .
L9168:  bpl     L917A                           ; 9168 10 10                    ..
        ora     ($11),y                         ; 916A 11 11                    ..
        .byte   $03                             ; 916C 03                       .
        .byte   $03                             ; 916D 03                       .
L916E:  .byte   $03                             ; 916E 03                       .
        .byte   $03                             ; 916F 03                       .
        .byte   $03                             ; 9170 03                       .
        .byte   $03                             ; 9171 03                       .
L9172:  .byte   $02                             ; 9172 02                       .
        .byte   $03                             ; 9173 03                       .
        .byte   $02                             ; 9174 02                       .
        .byte   $02                             ; 9175 02                       .
        .byte   $03                             ; 9176 03                       .
        .byte   $03                             ; 9177 03                       .
        .byte   $03                             ; 9178 03                       .
        .byte   $02                             ; 9179 02                       .
L917A:  .byte   $02                             ; 917A 02                       .
        .byte   $03                             ; 917B 03                       .
        .byte   $02                             ; 917C 02                       .
        .byte   $02                             ; 917D 02                       .
        .byte   $03                             ; 917E 03                       .
        .byte   $03                             ; 917F 03                       .
        ora     ($01,x)                         ; 9180 01 01                    ..
        ora     ($01,x)                         ; 9182 01 01                    ..
        ora     ($01,x)                         ; 9184 01 01                    ..
        ora     ($02,x)                         ; 9186 01 02                    ..
        ora     ($01,x)                         ; 9188 01 01                    ..
        ora     ($01,x)                         ; 918A 01 01                    ..
        ora     ($01,x)                         ; 918C 01 01                    ..
        ora     ($01,x)                         ; 918E 01 01                    ..
L9190:  ora     ($01,x)                         ; 9190 01 01                    ..
        ora     ($01,x)                         ; 9192 01 01                    ..
        ora     ($01,x)                         ; 9194 01 01                    ..
        ora     ($01,x)                         ; 9196 01 01                    ..
        ora     ($01,x)                         ; 9198 01 01                    ..
        ora     ($01,x)                         ; 919A 01 01                    ..
        ora     ($01,x)                         ; 919C 01 01                    ..
        ora     ($01,x)                         ; 919E 01 01                    ..
        .byte   $13                             ; 91A0 13                       .
        .byte   $13                             ; 91A1 13                       .
        .byte   $13                             ; 91A2 13                       .
        .byte   $13                             ; 91A3 13                       .
        .byte   $02                             ; 91A4 02                       .
        .byte   $02                             ; 91A5 02                       .
        .byte   $02                             ; 91A6 02                       .
        .byte   $02                             ; 91A7 02                       .
        .byte   $13                             ; 91A8 13                       .
        .byte   $13                             ; 91A9 13                       .
        .byte   $13                             ; 91AA 13                       .
        .byte   $13                             ; 91AB 13                       .
        .byte   $02                             ; 91AC 02                       .
        .byte   $02                             ; 91AD 02                       .
        .byte   $02                             ; 91AE 02                       .
        .byte   $02                             ; 91AF 02                       .
        .byte   $13                             ; 91B0 13                       .
        .byte   $13                             ; 91B1 13                       .
        .byte   $13                             ; 91B2 13                       .
        .byte   $13                             ; 91B3 13                       .
        .byte   $02                             ; 91B4 02                       .
        .byte   $02                             ; 91B5 02                       .
        .byte   $02                             ; 91B6 02                       .
        .byte   $02                             ; 91B7 02                       .
        ora     ($01,x)                         ; 91B8 01 01                    ..
        .byte   $01                             ; 91BA 01                       .
L91BB:  ora     ($02,x)                         ; 91BB 01 02                    ..
L91BD:  .byte   $02                             ; 91BD 02                       .
        .byte   $02                             ; 91BE 02                       .
        .byte   $02                             ; 91BF 02                       .
        brk                                     ; 91C0 00                       .
        cmp     ($D1),y                         ; 91C1 D1 D1                    ..
        cmp     ($D1),y                         ; 91C3 D1 D1                    ..
        .byte   $D1                             ; 91C5 D1                       .
L91C6:  .byte   $13                             ; 91C6 13                       .
        bne     L91C9                           ; 91C7 D0 00                    ..
L91C9:  cmp     ($D1),y                         ; 91C9 D1 D1                    ..
        .byte   $D1                             ; 91CB D1                       .
L91CC:  cmp     ($D1),y                         ; 91CC D1 D1                    ..
L91CE:  cmp     ($D0),y                         ; 91CE D1 D0                    ..
L91D0:  .byte   $02                             ; 91D0 02                       .
        cmp     ($D1),y                         ; 91D1 D1 D1                    ..
L91D3:  cmp     ($D1),y                         ; 91D3 D1 D1                    ..
        cmp     ($D1),y                         ; 91D5 D1 D1                    ..
        brk                                     ; 91D7 00                       .
        .byte   $02                             ; 91D8 02                       .
        ora     ($D2,x)                         ; 91D9 01 D2                    ..
        cmp     ($D1),y                         ; 91DB D1 D1                    ..
        cmp     ($D1),y                         ; 91DD D1 D1                    ..
        brk                                     ; 91DF 00                       .
        .byte   $02                             ; 91E0 02                       .
        cmp     ($D1),y                         ; 91E1 D1 D1                    ..
        cmp     ($D1),y                         ; 91E3 D1 D1                    ..
        ora     ($01,x)                         ; 91E5 01 01                    ..
        brk                                     ; 91E7 00                       .
        .byte   $02                             ; 91E8 02                       .
        bne     L91BB                           ; 91E9 D0 D0                    ..
        bne     L91BD                           ; 91EB D0 D0                    ..
        brk                                     ; 91ED 00                       .
        brk                                     ; 91EE 00                       .
        bne     L91F2                           ; 91EF D0 01                    ..
        .byte   $D0                             ; 91F1 D0                       .
L91F2:  bne     L91C6                           ; 91F2 D0 D2                    ..
        .byte   $D2                             ; 91F4 D2                       .
        .byte   $D2                             ; 91F5 D2                       .
        .byte   $D2                             ; 91F6 D2                       .
        bne     L91FA                           ; 91F7 D0 01                    ..
        .byte   $D0                             ; 91F9 D0                       .
L91FA:  bne     L91CC                           ; 91FA D0 D0                    ..
        bne     L91CE                           ; 91FC D0 D0                    ..
        bne     L91D0                           ; 91FE D0 D0                    ..
        .byte   $14                             ; 9200 14                       .
        ora     $1C,x                           ; 9201 15 1C                    ..
        ora     $2303,x                         ; 9203 1D 03 23                 ..#
        .byte   $0B                             ; 9206 0B                       .
        .byte   $2B                             ; 9207 2B                       +
        lsr     $504A                           ; 9208 4E 4A 50                 NJP
        eor     ($4A),y                         ; 920B 51 4A                    QJ
        lsr     a                               ; 920D 4A                       J
        .byte   $52                             ; 920E 52                       R
        .byte   $53                             ; 920F 53                       S
        lsr     $4A,x                           ; 9210 56 4A                    VJ
        eor     $51,x                           ; 9212 55 51                    UQ
        lsr     a                               ; 9214 4A                       J
        lsr     a                               ; 9215 4A                       J
        .byte   $52                             ; 9216 52                       R
        .byte   $52                             ; 9217 52                       R
        plp                                     ; 9218 28                       (
        and     #$28                            ; 9219 29 28                    )(
        and     #$67                            ; 921B 29 67                    )g
        .byte   $67                             ; 921D 67                       g
        adc     L056D                           ; 921E 6D 6D 05                 mm.
        .byte   $4B                             ; 9221 4B                       K
        asl     a                               ; 9222 0A                       .
        ror     a:L0000                         ; 9223 6E 00 00                 n..
        brk                                     ; 9226 00                       .
        brk                                     ; 9227 00                       .
        .byte   $6F                             ; 9228 6F                       o
        .byte   $67                             ; 9229 67                       g
        jmp     (L056D)                         ; 922A 6C 6D 05                 lm.

; ----------------------------------------------------------------------------
        .byte   $67                             ; 922D 67                       g
        asl     a                               ; 922E 0A                       .
        adc     $1312                           ; 922F 6D 12 13                 m..
        .byte   $1A                             ; 9232 1A                       .
        .byte   $1B                             ; 9233 1B                       .
        adc     $65                             ; 9234 65 65                    ee
        adc     $096D                           ; 9236 6D 6D 09                 mm.
        ror     $0A                             ; 9239 66 0A                    f.
        ror     $7776                           ; 923B 6E 76 77                 nvw
        ror     $647F,x                         ; 923E 7E 7F 64                 ~.d
        adc     $6C                             ; 9241 65 6C                    el
        adc     $6509                           ; 9243 6D 09 65                 m.e
        asl     a                               ; 9246 0A                       .
        adc     $1716                           ; 9247 6D 16 17                 m..
        asl     $651F,x                         ; 924A 1E 1F 65                 ..e
        adc     $65                             ; 924D 65 65                    ee
        adc     $09                             ; 924F 65 09                    e.
        ror     $09                             ; 9251 66 09                    f.
        ror     $26                             ; 9253 66 26                    f&
        .byte   $27                             ; 9255 27                       '
        rol     $642F                           ; 9256 2E 2F 64                 ./d
        adc     $64                             ; 9259 65 64                    ed
        adc     $09                             ; 925B 65 09                    e.
        adc     $09                             ; 925D 65 09                    e.
        adc     $2E                             ; 925F 65 2E                    e.
        .byte   $2F                             ; 9261 2F                       /
        rol     $27                             ; 9262 26 27                    &'
        rti                                     ; 9264 40                       @

; ----------------------------------------------------------------------------
        eor     ($46,x)                         ; 9265 41 46                    AF
        eor     #$42                            ; 9267 49 42                    IB
        .byte   $42                             ; 9269 42                       B
        eor     #$49                            ; 926A 49 49                    II
        .byte   $42                             ; 926C 42                       B
        .byte   $43                             ; 926D 43                       C
        eor     #$49                            ; 926E 49 49                    II
        eor     $41                             ; 9270 45 41                    EA
        eor     $4549                           ; 9272 4D 49 45                 MIE
        eor     ($4D,x)                         ; 9275 41 4D                    AM
        .byte   $5B                             ; 9277 5B                       [
        .byte   $42                             ; 9278 42                       B
        .byte   $42                             ; 9279 42                       B
        .byte   $5B                             ; 927A 5B                       [
        rts                                     ; 927B 60                       `

; ----------------------------------------------------------------------------
        pha                                     ; 927C 48                       H
        lsr     a                               ; 927D 4A                       J
        pha                                     ; 927E 48                       H
        lsr     a                               ; 927F 4A                       J
        lsr     a                               ; 9280 4A                       J
        lsr     a                               ; 9281 4A                       J
        lsr     a                               ; 9282 4A                       J
        lsr     a                               ; 9283 4A                       J
        lsr     $4A,x                           ; 9284 56 4A                    VJ
        lsr     $4A,x                           ; 9286 56 4A                    VJ
        lsr     $5C,x                           ; 9288 56 5C                    V\
        lsr     $5C,x                           ; 928A 56 5C                    V\
        .byte   $5C                             ; 928C 5C                       \
        pla                                     ; 928D 68                       h
        .byte   $5C                             ; 928E 5C                       \
        rts                                     ; 928F 60                       `

; ----------------------------------------------------------------------------
        lsr     a                               ; 9290 4A                       J
        .byte   $4F                             ; 9291 4F                       O
        .byte   $53                             ; 9292 53                       S
        .byte   $54                             ; 9293 54                       T
        rol     $2648                           ; 9294 2E 48 26                 .H&
        pha                                     ; 9297 48                       H
        bpl     L92AB                           ; 9298 10 11                    ..
        clc                                     ; 929A 18                       .
        ora     $0303,y                         ; 929B 19 03 03                 ...
        .byte   $0B                             ; 929E 0B                       .
        .byte   $0B                             ; 929F 0B                       .
        brk                                     ; 92A0 00                       .
        pha                                     ; 92A1 48                       H
        brk                                     ; 92A2 00                       .
        pha                                     ; 92A3 48                       H
        .byte   $23                             ; 92A4 23                       #
        pha                                     ; 92A5 48                       H
        .byte   $2B                             ; 92A6 2B                       +
        pha                                     ; 92A7 48                       H
        .byte   $67                             ; 92A8 67                       g
        .byte   $4B                             ; 92A9 4B                       K
        .byte   $65                             ; 92AA 65                       e
L92AB:  ror     L0000                           ; 92AB 66 00                    f.
        lsr     $5000                           ; 92AD 4E 00 50                 N.P
        lsr     a                               ; 92B0 4A                       J
        lsr     a                               ; 92B1 4A                       J
        eor     ($52),y                         ; 92B2 51 52                    QR
        rti                                     ; 92B4 40                       @

; ----------------------------------------------------------------------------
        eor     ($46,x)                         ; 92B5 41 46                    AF
        asl     L4443                           ; 92B7 0E 43 44                 .CD
        .byte   $07                             ; 92BA 07                       .
        .byte   $47                             ; 92BB 47                       G
        adc     $66                             ; 92BC 65 66                    ef
        adc     $486E                           ; 92BE 6D 6E 48                 mnH
        eor     #$48                            ; 92C1 49 48                    IH
        lsr     a                               ; 92C3 4A                       J
        eor     #$4C                            ; 92C4 49 4C                    IL
        lsr     a                               ; 92C6 4A                       J
        jmp     L4443                           ; 92C7 4C 43 44                 LCD

; ----------------------------------------------------------------------------
        adc     ($47,x)                         ; 92CA 61 47                    aG
        lsr     a                               ; 92CC 4A                       J
        jmp     L4C4A                           ; 92CD 4C 4A 4C                 LJL

; ----------------------------------------------------------------------------
        rti                                     ; 92D0 40                       @

; ----------------------------------------------------------------------------
        eor     ($46,x)                         ; 92D1 41 46                    AF
        .byte   $5B                             ; 92D3 5B                       [
        adc     #$4C                            ; 92D4 69 4C                    iL
        adc     ($4C,x)                         ; 92D6 61 4C                    aL
        pha                                     ; 92D8 48                       H
        .byte   $5C                             ; 92D9 5C                       \
        pha                                     ; 92DA 48                       H
        .byte   $5C                             ; 92DB 5C                       \
        jmp     L4C2F                           ; 92DC 4C 2F 4C                 L/L

; ----------------------------------------------------------------------------
        .byte   $27                             ; 92DF 27                       '
        jmp     L4C00                           ; 92E0 4C 00 4C                 L.L

; ----------------------------------------------------------------------------
        brk                                     ; 92E3 00                       .
        .byte   $67                             ; 92E4 67                       g
        .byte   $4B                             ; 92E5 4B                       K
        adc     $4C6E                           ; 92E6 6D 6E 4C                 mnL
        .byte   $22                             ; 92E9 22                       "
        jmp     L222A                           ; 92EA 4C 2A 22                 L*"

; ----------------------------------------------------------------------------
        .byte   $03                             ; 92ED 03                       .
        rol     a                               ; 92EE 2A                       *
        .byte   $0B                             ; 92EF 0B                       .
        .byte   $4F                             ; 92F0 4F                       O
        brk                                     ; 92F1 00                       .
        .byte   $54                             ; 92F2 54                       T
        brk                                     ; 92F3 00                       .
        .byte   $67                             ; 92F4 67                       g
        .byte   $67                             ; 92F5 67                       g
        adc     $65                             ; 92F6 65 65                    ee
        ora     $67                             ; 92F8 05 67                    .g
        ora     #$65                            ; 92FA 09 65                    .e
        adc     $66                             ; 92FC 65 66                    ef
        adc     $66                             ; 92FE 65 66                    ef
        .byte   $64                             ; 9300 64                       d
        adc     $40                             ; 9301 65 40                    e@
        eor     ($09,x)                         ; 9303 41 09                    A.
        adc     $42                             ; 9305 65 42                    eB
        .byte   $42                             ; 9307 42                       B
        adc     $65                             ; 9308 65 65                    ee
        .byte   $42                             ; 930A 42                       B
        .byte   $42                             ; 930B 42                       B
        adc     $66                             ; 930C 65 66                    ef
        .byte   $43                             ; 930E 43                       C
        .byte   $44                             ; 930F 44                       D
        brk                                     ; 9310 00                       .
        brk                                     ; 9311 00                       .
        .byte   $22                             ; 9312 22                       "
        .byte   $03                             ; 9313 03                       .
        brk                                     ; 9314 00                       .
        brk                                     ; 9315 00                       .
        .byte   $03                             ; 9316 03                       .
        .byte   $23                             ; 9317 23                       #
        lsr     $0E                             ; 9318 46 0E                    F.
        pha                                     ; 931A 48                       H
        eor     #$07                            ; 931B 49 07                    I.
        .byte   $07                             ; 931D 07                       .
        eor     #$49                            ; 931E 49 49                    II
        .byte   $07                             ; 9320 07                       .
        .byte   $47                             ; 9321 47                       G
        eor     #$4C                            ; 9322 49 4C                    IL
        rol     a                               ; 9324 2A                       *
        .byte   $0B                             ; 9325 0B                       .
        .byte   $67                             ; 9326 67                       g
        .byte   $67                             ; 9327 67                       g
        .byte   $0B                             ; 9328 0B                       .
        .byte   $2B                             ; 9329 2B                       +
        .byte   $67                             ; 932A 67                       g
        .byte   $4B                             ; 932B 4B                       K
        .byte   $04                             ; 932C 04                       .
        .byte   $03                             ; 932D 03                       .
        .byte   $0C                             ; 932E 0C                       .
        .byte   $0B                             ; 932F 0B                       .
        .byte   $32                             ; 9330 32                       2
        .byte   $33                             ; 9331 33                       3
        bmi     L9365                           ; 9332 30 31                    01
        bmi     L9367                           ; 9334 30 31                    01
        bmi     L9369                           ; 9336 30 31                    01
        .byte   $34                             ; 9338 34                       4
        rol     $3C,x                           ; 9339 36 3C                    6<
        rol     $3636,x                         ; 933B 3E 36 36                 >66
        rol     $363E,x                         ; 933E 3E 3E 36                 >>6
        and     $3E,x                           ; 9341 35 3E                    5>
        and     L3130,x                         ; 9343 3D 30 31                 =01
        .byte   $3A                             ; 9346 3A                       :
        .byte   $3B                             ; 9347 3B                       ;
        .byte   $32                             ; 9348 32                       2
        .byte   $33                             ; 9349 33                       3
        sec                                     ; 934A 38                       8
        and     $3332,y                         ; 934B 39 32 33                 923
        .byte   $3A                             ; 934E 3A                       :
        .byte   $3B                             ; 934F 3B                       ;
        brk                                     ; 9350 00                       .
        brk                                     ; 9351 00                       .
        .byte   $42                             ; 9352 42                       B
        .byte   $42                             ; 9353 42                       B
        bit     $432D                           ; 9354 2C 2D 43                 ,-C
        .byte   $44                             ; 9357 44                       D
        eor     #$49                            ; 9358 49 49                    II
        lsr     a                               ; 935A 4A                       J
        lsr     a                               ; 935B 4A                       J
        eor     #$47                            ; 935C 49 47                    IG
        lsr     a                               ; 935E 4A                       J
        jmp     L3130                           ; 935F 4C 30 31                 L01

; ----------------------------------------------------------------------------
        sec                                     ; 9362 38                       8
        .byte   $39                             ; 9363 39                       9
        .byte   $24                             ; 9364 24                       $
L9365:  and     $28                             ; 9365 25 28                    %(
L9367:  and     #$28                            ; 9367 29 28                    )(
L9369:  and     #$2C                            ; 9369 29 2C                    ),
        and     $4242                           ; 936B 2D 42 42                 -BB
        .byte   $07                             ; 936E 07                       .
        .byte   $07                             ; 936F 07                       .
        jsr     L6D20                           ; 9370 20 20 6D                   m
        adc     $2D2C                           ; 9373 6D 2C 2D                 m,-
        .byte   $42                             ; 9376 42                       B
        .byte   $42                             ; 9377 42                       B
        adc     $65                             ; 9378 65 65                    ee
        .byte   $43                             ; 937A 43                       C
        .byte   $44                             ; 937B 44                       D
        brk                                     ; 937C 00                       .
        brk                                     ; 937D 00                       .
        rti                                     ; 937E 40                       @

; ----------------------------------------------------------------------------
        eor     (L0000,x)                       ; 937F 41 00                    A.
        brk                                     ; 9381 00                       .
        .byte   $42                             ; 9382 42                       B
        .byte   $43                             ; 9383 43                       C
        adc     ($60,x)                         ; 9384 61 60                    a`
        adc     #$68                            ; 9386 69 68                    ih
        adc     ($47,x)                         ; 9388 61 47                    aG
        adc     #$4C                            ; 938A 69 4C                    iL
        adc     $226D                           ; 938C 6D 6D 22                 mm"
        .byte   $03                             ; 938F 03                       .
        .byte   $6D                             ; 9390 6D                       m
        .byte   $6E                             ; 9391 6E                       n
L9392:  .byte   $03                             ; 9392 03                       .
        .byte   $23                             ; 9393 23                       #
        adc     ($5B,x)                         ; 9394 61 5B                    a[
        adc     #$5C                            ; 9396 69 5C                    i\
        .byte   $5B                             ; 9398 5B                       [
        rts                                     ; 9399 60                       `

; ----------------------------------------------------------------------------
        .byte   $5C                             ; 939A 5C                       \
        pla                                     ; 939B 68                       h
        adc     ($4C,x)                         ; 939C 61 4C                    aL
        adc     #$4C                            ; 939E 69 4C                    iL
        adc     ($5C,x)                         ; 93A0 61 5C                    a\
        adc     #$5C                            ; 93A2 69 5C                    i\
        .byte   $5C                             ; 93A4 5C                       \
        rts                                     ; 93A5 60                       `

; ----------------------------------------------------------------------------
        .byte   $5C                             ; 93A6 5C                       \
        pla                                     ; 93A7 68                       h
        pha                                     ; 93A8 48                       H
        pla                                     ; 93A9 68                       h
        pha                                     ; 93AA 48                       H
        rts                                     ; 93AB 60                       `

; ----------------------------------------------------------------------------
        adc     #$68                            ; 93AC 69 68                    ih
        adc     ($60,x)                         ; 93AE 61 60                    a`
        .byte   $4F                             ; 93B0 4F                       O
        .byte   $22                             ; 93B1 22                       "
        .byte   $54                             ; 93B2 54                       T
        rol     a                               ; 93B3 2A                       *
        lsr     $5068                           ; 93B4 4E 68 50                 NhP
        eor     ($69),y                         ; 93B7 51 69                    Qi
        .byte   $4F                             ; 93B9 4F                       O
        .byte   $53                             ; 93BA 53                       S
        .byte   $54                             ; 93BB 54                       T
        adc     #$68                            ; 93BC 69 68                    ih
        .byte   $52                             ; 93BE 52                       R
        .byte   $52                             ; 93BF 52                       R
        brk                                     ; 93C0 00                       .
        brk                                     ; 93C1 00                       .
        .byte   $44                             ; 93C2 44                       D
        brk                                     ; 93C3 00                       .
        .byte   $47                             ; 93C4 47                       G
        brk                                     ; 93C5 00                       .
        jmp     L6422                           ; 93C6 4C 22 64                 L"d

; ----------------------------------------------------------------------------
        .byte   $65                             ; 93C9 65                       e
L93CA:  .byte   $03                             ; 93CA 03                       .
        .byte   $03                             ; 93CB 03                       .
        ora     #$65                            ; 93CC 09 65                    .e
        asl     $17,x                           ; 93CE 16 17                    ..
        brk                                     ; 93D0 00                       .
        brk                                     ; 93D1 00                       .
        .byte   $14                             ; 93D2 14                       .
        ora     $4C,x                           ; 93D3 15 4C                    .L
        rol     a                               ; 93D5 2A                       *
        jmp     L0B00                           ; 93D6 4C 00 0B                 L..

; ----------------------------------------------------------------------------
        .byte   $0B                             ; 93D9 0B                       .
        .byte   $6F                             ; 93DA 6F                       o
        .byte   $67                             ; 93DB 67                       g
        asl     $281F,x                         ; 93DC 1E 1F 28                 ..(
        and     #$65                            ; 93DF 29 65                    )e
        adc     $40                             ; 93E1 65 40                    e@
        eor     ($09,x)                         ; 93E3 41 09                    A.
        ror     $42                             ; 93E5 66 42                    fB
        .byte   $42                             ; 93E7 42                       B
        brk                                     ; 93E8 00                       .
        brk                                     ; 93E9 00                       .
        .byte   $43                             ; 93EA 43                       C
        .byte   $44                             ; 93EB 44                       D
        .byte   $1C                             ; 93EC 1C                       .
        ora     $2928,x                         ; 93ED 1D 28 29                 .()
        .byte   $0B                             ; 93F0 0B                       .
        .byte   $0B                             ; 93F1 0B                       .
        brk                                     ; 93F2 00                       .
        brk                                     ; 93F3 00                       .
        lsr     $60                             ; 93F4 46 60                    F`
        pha                                     ; 93F6 48                       H
        pla                                     ; 93F7 68                       h
        cld                                     ; 93F8 D8                       .
        adc     $75D0,x                         ; 93F9 7D D0 75                 }.u
        .byte   $7C                             ; 93FC 7C                       |
        adc     $7574,x                         ; 93FD 7D 74 75                 }tu
        .byte   $7C                             ; 9400 7C                       |
        .byte   $3F                             ; 9401 3F                       ?
        .byte   $74                             ; 9402 74                       t
        .byte   $37                             ; 9403 37                       7
        brk                                     ; 9404 00                       .
        brk                                     ; 9405 00                       .
        ora     $D80D                           ; 9406 0D 0D D8                 ...
        adc     $0D0D,x                         ; 9409 7D 0D 0D                 }..
        ora     $060D                           ; 940C 0D 0D 06                 ...
        asl     $09                             ; 940F 06 09                    ..
        ror     $03                             ; 9411 66 03                    f.
        .byte   $03                             ; 9413 03                       .
        ora     #$66                            ; 9414 09 66                    .f
        ora     ($03,x)                         ; 9416 01 03                    ..
        ora     #$66                            ; 9418 09 66                    .f
        .byte   $03                             ; 941A 03                       .
        ora     ($7C,x)                         ; 941B 01 7C                    .|
        .byte   $3F                             ; 941D 3F                       ?
        .byte   $03                             ; 941E 03                       .
        .byte   $03                             ; 941F 03                       .
        brk                                     ; 9420 00                       .
        brk                                     ; 9421 00                       .
        ora     ($03,x)                         ; 9422 01 03                    ..
        cld                                     ; 9424 D8                       .
        adc     $0103,x                         ; 9425 7D 03 01                 }..
        .byte   $0B                             ; 9428 0B                       .
        .byte   $0B                             ; 9429 0B                       .
        bne     L94A1                           ; 942A D0 75                    .u
        .byte   $0B                             ; 942C 0B                       .
        .byte   $0B                             ; 942D 0B                       .
        .byte   $74                             ; 942E 74                       t
        adc     $0B,x                           ; 942F 75 0B                    u.
        .byte   $0B                             ; 9431 0B                       .
        .byte   $74                             ; 9432 74                       t
        .byte   $37                             ; 9433 37                       7
        adc     $70                             ; 9434 65 70                    ep
        adc     $7178                           ; 9436 6D 78 71                 mxq
        adc     ($E0),y                         ; 9439 71 E0                    q.
        adc     $7171,y                         ; 943B 79 71 71                 yqq
        adc     $717A,y                         ; 943E 79 7A 71                 yzq
        adc     ($79),y                         ; 9441 71 79                    qy
        .byte   $72                             ; 9443 72                       r
        .byte   $73                             ; 9444 73                       s
        adc     $7B                             ; 9445 65 7B                    e{
        adc     $75D0                           ; 9447 6D D0 75                 m.u
        cld                                     ; 944A D8                       .
        adc     $7574,x                         ; 944B 7D 74 75                 }tu
        .byte   $7C                             ; 944E 7C                       |
        adc     $3774,x                         ; 944F 7D 74 37                 }t7
        .byte   $7C                             ; 9452 7C                       |
        .byte   $3F                             ; 9453 3F                       ?
        and     ($21,x)                         ; 9454 21 21                    !!
        brk                                     ; 9456 00                       .
        brk                                     ; 9457 00                       .
        ora     $0D0D                           ; 9458 0D 0D 0D                 ...
        ora     L2020                           ; 945B 0D 20 20                 .  
        adc     $65                             ; 945E 65 65                    ee
        asl     $06                             ; 9460 06 06                    ..
        .byte   $67                             ; 9462 67                       g
        .byte   $67                             ; 9463 67                       g
        .byte   $6B                             ; 9464 6B                       k
        php                                     ; 9465 08                       .
        .byte   $63                             ; 9466 63                       c
        .byte   $5A                             ; 9467 5A                       Z
        .byte   $6B                             ; 9468 6B                       k
        clv                                     ; 9469 B8                       .
        .byte   $5A                             ; 946A 5A                       Z
        tsx                                     ; 946B BA                       .
        eor     $BB62,y                         ; 946C 59 62 BB                 Yb.
        .byte   $80                             ; 946F 80                       .
        lda     L806A,y                         ; 9470 B9 6A 80                 .j.
        cli                                     ; 9473 58                       X
        .byte   $80                             ; 9474 80                       .
        .byte   $80                             ; 9475 80                       .
        .byte   $80                             ; 9476 80                       .
        .byte   $80                             ; 9477 80                       .
        .byte   $80                             ; 9478 80                       .
        .byte   $80                             ; 9479 80                       .
        tsx                                     ; 947A BA                       .
        .byte   $BB                             ; 947B BB                       .
        stx     $80                             ; 947C 86 80                    ..
        stx     L808F                           ; 947E 8E 8F 80                 ...
        .byte   $82                             ; 9481 82                       .
        txs                                     ; 9482 9A                       .
        txa                                     ; 9483 8A                       .
        .byte   $83                             ; 9484 83                       .
        sty     $8B                             ; 9485 84 8B                    ..
        sty     L8080                           ; 9487 8C 80 80                 ...
        .byte   $9C                             ; 948A 9C                       .
        sta     L8080,x                         ; 948B 9D 80 80                 ...
        .byte   $9E                             ; 948E 9E                       .
        .byte   $9F                             ; 948F 9F                       .
        stx     $97,y                           ; 9490 96 97                    ..
        ldy     $A5                             ; 9492 A4 A5                    ..
        sta     ($92),y                         ; 9494 91 92                    ..
        ldy     $5F                             ; 9496 A4 5F                    ._
        .byte   $9B                             ; 9498 9B                       .
        sty     $A6,x                           ; 9499 94 A6                    ..
        .byte   $A7                             ; 949B A7                       .
        sta     ($98,x)                         ; 949C 81 98                    ..
        .byte   $5F                             ; 949E 5F                       _
        .byte   $5F                             ; 949F 5F                       _
        .byte   $99                             ; 94A0 99                       .
L94A1:  sty     $BC5F                           ; 94A1 8C 5F BC                 ._.
        .byte   $64                             ; 94A4 64                       d
        adc     $0D                             ; 94A5 65 0D                    e.
        ora     $B7B6                           ; 94A7 0D B6 B7                 ...
        ldx     $B6BF,y                         ; 94AA BE BF B6                 ...
        ldx     $BE,y                           ; 94AD B6 BE                    ..
        ldx     $BFBE,y                         ; 94AF BE BE BF                 ...
        ldx     $BEBF,y                         ; 94B2 BE BF BE                 ...
        ldx     $BEBE,y                         ; 94B5 BE BE BE                 ...
        .byte   $42                             ; 94B8 42                       B
        .byte   $42                             ; 94B9 42                       B
        rts                                     ; 94BA 60                       `

; ----------------------------------------------------------------------------
        adc     ($42,x)                         ; 94BB 61 42                    aB
        .byte   $43                             ; 94BD 43                       C
        .byte   $5B                             ; 94BE 5B                       [
        .byte   $5B                             ; 94BF 5B                       [
        .byte   $42                             ; 94C0 42                       B
        .byte   $43                             ; 94C1 43                       C
        rts                                     ; 94C2 60                       `

; ----------------------------------------------------------------------------
        adc     ($68,x)                         ; 94C3 61 68                    ah
        adc     #$60                            ; 94C5 69 60                    i`
        adc     ($5C,x)                         ; 94C7 61 5C                    a\
        .byte   $5C                             ; 94C9 5C                       \
        .byte   $5C                             ; 94CA 5C                       \
        .byte   $5C                             ; 94CB 5C                       \
        tsx                                     ; 94CC BA                       .
        .byte   $BB                             ; 94CD BB                       .
        .byte   $80                             ; 94CE 80                       .
        .byte   $80                             ; 94CF 80                       .
        .byte   $80                             ; 94D0 80                       .
        .byte   $80                             ; 94D1 80                       .
        dey                                     ; 94D2 88                       .
        .byte   $89                             ; 94D3 89                       .
        .byte   $82                             ; 94D4 82                       .
        .byte   $83                             ; 94D5 83                       .
        txa                                     ; 94D6 8A                       .
        .byte   $8B                             ; 94D7 8B                       .
        sty     $85                             ; 94D8 84 85                    ..
        sty     L908D                           ; 94DA 8C 8D 90                 ...
        .byte   $91                             ; 94DD 91                       .
L94DE:  ldy     $A5                             ; 94DE A4 A5                    ..
        .byte   $92                             ; 94E0 92                       .
        .byte   $93                             ; 94E1 93                       .
        ldx     $A7                             ; 94E2 A6 A7                    ..
        sty     $95,x                           ; 94E4 94 95                    ..
        .byte   $5F                             ; 94E6 5F                       _
        .byte   $5F                             ; 94E7 5F                       _
        ldx     $B6,y                           ; 94E8 B6 B6                    ..
        rti                                     ; 94EA 40                       @

; ----------------------------------------------------------------------------
        eor     ($B6,x)                         ; 94EB 41 B6                    A.
        .byte   $B7                             ; 94ED B7                       .
        .byte   $42                             ; 94EE 42                       B
        .byte   $43                             ; 94EF 43                       C
        ldx     $0DBF,y                         ; 94F0 BE BF 0D                 ...
        ora     $5B46                           ; 94F3 0D 46 5B                 .F[
        pha                                     ; 94F6 48                       H
        .byte   $5C                             ; 94F7 5C                       \
        rts                                     ; 94F8 60                       `

; ----------------------------------------------------------------------------
        adc     ($68,x)                         ; 94F9 61 68                    ah
        adc     #$42                            ; 94FB 69 42                    iB
        .byte   $42                             ; 94FD 42                       B
        adc     ($60,x)                         ; 94FE 61 60                    a`
        ldy     $45AD                           ; 9500 AC AD 45                 ..E
        eor     ($AE,x)                         ; 9503 41 AE                    A.
        .byte   $AF                             ; 9505 AF                       .
        .byte   $42                             ; 9506 42                       B
        .byte   $42                             ; 9507 42                       B
        ldy     $B5,x                           ; 9508 B4 B5                    ..
        .byte   $42                             ; 950A 42                       B
        .byte   $43                             ; 950B 43                       C
        ldy     $42B5                           ; 950C AC B5 42                 ..B
        .byte   $42                             ; 950F 42                       B
        ldx     $43AF                           ; 9510 AE AF 43                 ..C
        .byte   $44                             ; 9513 44                       D
        ldy     $B5,x                           ; 9514 B4 B5                    ..
        dec     $C6                             ; 9516 C6 C6                    ..
        ldy     $AD,x                           ; 9518 B4 AD                    ..
        dec     $C6                             ; 951A C6 C6                    ..
        eor     $565B                           ; 951C 4D 5B 56                 M[V
        .byte   $5C                             ; 951F 5C                       \
        ldy     #$A1                            ; 9520 A0 A1                    ..
        ldx     #$A3                            ; 9522 A2 A3                    ..
        .byte   $5B                             ; 9524 5B                       [
        .byte   $5B                             ; 9525 5B                       [
        .byte   $5C                             ; 9526 5C                       \
        .byte   $5C                             ; 9527 5C                       \
        tay                                     ; 9528 A8                       .
        lda     #$B0                            ; 9529 A9 B0                    ..
        lda     ($AA),y                         ; 952B B1 AA                    ..
        .byte   $AB                             ; 952D AB                       .
        .byte   $B2                             ; 952E B2                       .
        .byte   $B3                             ; 952F B3                       .
        .byte   $AB                             ; 9530 AB                       .
        tay                                     ; 9531 A8                       .
        .byte   $B3                             ; 9532 B3                       .
        bcs     L94DE                           ; 9533 B0 A9                    ..
        tax                                     ; 9535 AA                       .
        lda     ($B2),y                         ; 9536 B1 B2                    ..
        ldy     $C6AD                           ; 9538 AC AD C6                 ...
        dec     $AE                             ; 953B C6 AE                    ..
        .byte   $AF                             ; 953D AF                       .
        dec     $C6                             ; 953E C6 C6                    ..
        ldy     $C6B5                           ; 9540 AC B5 C6                 ...
        dec     L0000                           ; 9543 C6 00                    ..
        cmp     (L0000,x)                       ; 9545 C1 00                    ..
        cmp     #$C2                            ; 9547 C9 C2                    ..
        .byte   $C3                             ; 9549 C3                       .
        dex                                     ; 954A CA                       .
        .byte   $CB                             ; 954B CB                       .
        cpy     $C5                             ; 954C C4 C5                    ..
        cpy     a:$CD                           ; 954E CC CD 00                 ...
        brk                                     ; 9551 00                       .
        dec     $F000                           ; 9552 CE 00 F0                 ...
        cmp     ($F8),y                         ; 9555 D1 F8                    ..
        cmp     $D3D2,y                         ; 9557 D9 D2 D3                 ...
        .byte   $DA                             ; 955A DA                       .
        .byte   $DB                             ; 955B DB                       .
        .byte   $D4                             ; 955C D4                       .
        cmp     $DC,x                           ; 955D D5 DC                    ..
        cmp     a:$D6,x                         ; 955F DD D6 00                 ...
        dec     a:L0000,x                       ; 9562 DE 00 00                 ...
        sbc     (L0000,x)                       ; 9565 E1 00                    ..
        sbc     #$E2                            ; 9567 E9 E2                    ..
        .byte   $E3                             ; 9569 E3                       .
        nop                                     ; 956A EA                       .
        .byte   $EB                             ; 956B EB                       .
        cpx     $E5                             ; 956C E4 E5                    ..
        cpx     $E6ED                           ; 956E EC ED E6                 ...
        brk                                     ; 9571 00                       .
        inc     $E800                           ; 9572 EE 00 E8                 ...
        sbc     (L0000),y                       ; 9575 F1 00                    ..
        sbc     $F3F2,y                         ; 9577 F9 F2 F3                 ...
        .byte   $FA                             ; 957A FA                       .
        .byte   $FB                             ; 957B FB                       .
        .byte   $F4                             ; 957C F4                       .
        sbc     $FC,x                           ; 957D F5 FC                    ..
        sbc     a:$F6,x                         ; 957F FD F6 00                 ...
        inc     $AC00,x                         ; 9582 FE 00 AC                 ...
        lda     $4140                           ; 9585 AD 40 41                 .@A
        .byte   $87                             ; 9588 87                       .
        ldx     $42,y                           ; 9589 B6 42                    .B
        .byte   $42                             ; 958B 42                       B
        ldx     $B7,y                           ; 958C B6 B7                    ..
        .byte   $43                             ; 958E 43                       C
        .byte   $44                             ; 958F 44                       D
        ldx     $0DBE,y                         ; 9590 BE BE 0D                 ...
        ora     $6048                           ; 9593 0D 48 60                 .H`
        pha                                     ; 9596 48                       H
        pla                                     ; 9597 68                       h
        pha                                     ; 9598 48                       H
        .byte   $5C                             ; 9599 5C                       \
        lsr     $505D                           ; 959A 4E 5D 50                 N]P
        eor     ($BD),y                         ; 959D 51 BD                    Q.
        .byte   $02                             ; 959F 02                       .
        ldx     $BE02,y                         ; 95A0 BE 02 BE                 ...
        .byte   $02                             ; 95A3 02                       .
        .byte   $5C                             ; 95A4 5C                       \
        .byte   $5C                             ; 95A5 5C                       \
        eor     $565D,x                         ; 95A6 5D 5D 56                 ]]V
        .byte   $5C                             ; 95A9 5C                       \
        .byte   $57                             ; 95AA 57                       W
        eor     $5252,x                         ; 95AB 5D 52 52                 ]RR
        .byte   $67                             ; 95AE 67                       g
        .byte   $67                             ; 95AF 67                       g
        .byte   $52                             ; 95B0 52                       R
        .byte   $53                             ; 95B1 53                       S
        ora     $67                             ; 95B2 05 67                    .g
        eor     $51,x                           ; 95B4 55 51                    UQ
        ora     $4B                             ; 95B6 05 4B                    .K
        .byte   $52                             ; 95B8 52                       R
        .byte   $53                             ; 95B9 53                       S
        rol     $552F                           ; 95BA 2E 2F 55                 ./U
        eor     ($2E),y                         ; 95BD 51 2E                    Q.
        .byte   $2F                             ; 95BF 2F                       /
        eor     ($53),y                         ; 95C0 51 53                    QS
        rol     $2E02                           ; 95C2 2E 02 2E                 ...
        .byte   $02                             ; 95C5 02                       .
        rol     $02                             ; 95C6 26 02                    &.
        jmp     L4C4B                           ; 95C8 4C 4B 4C                 LKL

; ----------------------------------------------------------------------------
        ror     $4867                           ; 95CB 6E 67 48                 ngH
        adc     $4C48                           ; 95CE 6D 48 4C                 mHL
        ror     $4C                             ; 95D1 66 4C                    fL
        ror     $65                             ; 95D3 66 65                    fe
        pha                                     ; 95D5 48                       H
        adc     $48                             ; 95D6 65 48                    eH
        jmp     L4F66                           ; 95D8 4C 66 4F                 LfO

; ----------------------------------------------------------------------------
        ror     $4865                           ; 95DB 6E 65 48                 neH
        adc     $5448                           ; 95DE 6D 48 54                 mHT
        ror     $67                             ; 95E1 66 67                    fg
        ror     $65                             ; 95E3 66 65                    fe
        lsr     $506D                           ; 95E5 4E 6D 50                 NmP
        .byte   $43                             ; 95E8 43                       C
        eor     $61                             ; 95E9 45 61                    Ea
        eor     $5669                           ; 95EB 4D 69 56                 MiV
        adc     ($56,x)                         ; 95EE 61 56                    aV
        brk                                     ; 95F0 00                       .
        brk                                     ; 95F1 00                       .
        brk                                     ; 95F2 00                       .
        brk                                     ; 95F3 00                       .
        brk                                     ; 95F4 00                       .
        brk                                     ; 95F5 00                       .
        brk                                     ; 95F6 00                       .
        brk                                     ; 95F7 00                       .
        brk                                     ; 95F8 00                       .
        brk                                     ; 95F9 00                       .
        brk                                     ; 95FA 00                       .
        brk                                     ; 95FB 00                       .
        brk                                     ; 95FC 00                       .
        brk                                     ; 95FD 00                       .
        brk                                     ; 95FE 00                       .
        brk                                     ; 95FF 00                       .
        brk                                     ; 9600 00                       .
        ora     ($02,x)                         ; 9601 01 02                    ..
        .byte   $03                             ; 9603 03                       .
        .byte   $04                             ; 9604 04                       .
        ora     $03                             ; 9605 05 03                    ..
        .byte   $04                             ; 9607 04                       .
        asl     $07                             ; 9608 06 07                    ..
        php                                     ; 960A 08                       .
        ora     #$09                            ; 960B 09 09                    ..
L960D:  asl     a                               ; 960D 0A                       .
        .byte   $0B                             ; 960E 0B                       .
        php                                     ; 960F 08                       .
        .byte   $0C                             ; 9610 0C                       .
        ora     $0F0E                           ; 9611 0D 0E 0F                 ...
        .byte   $0F                             ; 9614 0F                       .
        bpl     L9628                           ; 9615 10 11                    ..
        asl     $1312                           ; 9617 0E 12 13                 ...
        .byte   $14                             ; 961A 14                       .
        ora     $15,x                           ; 961B 15 15                    ..
        asl     $17,x                           ; 961D 16 17                    ..
        .byte   $14                             ; 961F 14                       .
        asl     $0D                             ; 9620 06 0D                    ..
        asl     $1818                           ; 9622 0E 18 18                 ...
        bpl     L9638                           ; 9625 10 11                    ..
        .byte   $0E                             ; 9627 0E                       .
L9628:  .byte   $0C                             ; 9628 0C                       .
        ora     $0F0E                           ; 9629 0D 0E 0F                 ...
        .byte   $0F                             ; 962C 0F                       .
        bpl     L9640                           ; 962D 10 11                    ..
        asl     $1901                           ; 962F 0E 01 19                 ...
        .byte   $1A                             ; 9632 1A                       .
        .byte   $1B                             ; 9633 1B                       .
        .byte   $1C                             ; 9634 1C                       .
        .byte   $1B                             ; 9635 1B                       .
        .byte   $1D                             ; 9636 1D                       .
        .byte   $1E                             ; 9637 1E                       .
L9638:  ora     #$1F                            ; 9638 09 1F                    ..
        jsr     L2120                           ; 963A 20 20 21                   !
        jsr     L2322                           ; 963D 20 22 23                  "#
L9640:  ora     $24                             ; 9640 05 24                    .$
        asl     $18                             ; 9642 06 18                    ..
        clc                                     ; 9644 18                       .
        clc                                     ; 9645 18                       .
        and     $20                             ; 9646 25 20                    % 
        ora     #$09                            ; 9648 09 09                    ..
        rol     $27                             ; 964A 26 27                    &'
        .byte   $27                             ; 964C 27                       '
        .byte   $12                             ; 964D 12                       .
        plp                                     ; 964E 28                       (
        jsr     L0F0F                           ; 964F 20 0F 0F                  ..
        .byte   $0F                             ; 9652 0F                       .
        asl     a                               ; 9653 0A                       .
        .byte   $07                             ; 9654 07                       .
        rol     $29                             ; 9655 26 29                    &)
        jsr     L1515                           ; 9657 20 15 15                  ..
        ora     $16,x                           ; 965A 15 16                    ..
        .byte   $13                             ; 965C 13                       .
        rol     a                               ; 965D 2A                       *
        .byte   $2B                             ; 965E 2B                       +
        bit     $1818                           ; 965F 2C 18 18                 ,..
        and     $0D2E                           ; 9662 2D 2E 0D                 -..
        .byte   $2F                             ; 9665 2F                       /
        clc                                     ; 9666 18                       .
        clc                                     ; 9667 18                       .
        .byte   $0F                             ; 9668 0F                       .
        brk                                     ; 9669 00                       .
        bmi     L969D                           ; 966A 30 31                    01
        .byte   $12                             ; 966C 12                       .
        .byte   $2F                             ; 966D 2F                       /
        ora     $15,x                           ; 966E 15 15                    ..
        .byte   $32                             ; 9670 32                       2
        asl     $1F                             ; 9671 06 1F                    ..
        .byte   $33                             ; 9673 33                       3
        asl     $34                             ; 9674 06 34                    .4
        asl     $3532,x                         ; 9676 1E 32 35                 .25
        asl     $1F                             ; 9679 06 1F                    ..
        .byte   $33                             ; 967B 33                       3
        asl     $36                             ; 967C 06 36                    .6
        .byte   $23                             ; 967E 23                       #
        and     $20,x                           ; 967F 35 20                    5 
        .byte   $37                             ; 9681 37                       7
        .byte   $1F                             ; 9682 1F                       .
        .byte   $33                             ; 9683 33                       3
        .byte   $13                             ; 9684 13                       .
        brk                                     ; 9685 00                       .
        .byte   $27                             ; 9686 27                       '
        .byte   $27                             ; 9687 27                       '
        jsr     L1F38                           ; 9688 20 38 1F                  8.
        .byte   $33                             ; 968B 33                       3
        ora     $3906                           ; 968C 0D 06 39                 ..9
        .byte   $0F                             ; 968F 0F                       .
        jsr     L1F3A                           ; 9690 20 3A 1F                  :.
        .byte   $33                             ; 9693 33                       3
        .byte   $3B                             ; 9694 3B                       ;
        .byte   $0C                             ; 9695 0C                       .
L9696:  .byte   $2F                             ; 9696 2F                       /
        ora     $03,x                           ; 9697 15 03                    ..
        .byte   $3C                             ; 9699 3C                       <
        .byte   $02                             ; 969A 02                       .
        bit     $3D                             ; 969B 24 3D                    $=
L969D:  rol     $093F,x                         ; 969D 3E 3F 09                 >?.
        clc                                     ; 96A0 18                       .
        clc                                     ; 96A1 18                       .
        asl     a                               ; 96A2 0A                       .
        .byte   $0B                             ; 96A3 0B                       .
        ora     $2F11                           ; 96A4 0D 11 2F                 ../
        clc                                     ; 96A7 18                       .
        ora     $15,x                           ; 96A8 15 15                    ..
        rti                                     ; 96AA 40                       @

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; 96AB 41 42                    AB
        eor     ($43,x)                         ; 96AD 41 43                    AC
        ora     $44,x                           ; 96AF 15 44                    .D
        eor     $46                             ; 96B1 45 46                    EF
        .byte   $47                             ; 96B3 47                       G
        .byte   $47                             ; 96B4 47                       G
        .byte   $47                             ; 96B5 47                       G
        pha                                     ; 96B6 48                       H
        .byte   $3B                             ; 96B7 3B                       ;
        eor     #$4A                            ; 96B8 49 4A                    IJ
        .byte   $1F                             ; 96BA 1F                       .
        jsr     L2020                           ; 96BB 20 20 20                    
        .byte   $33                             ; 96BE 33                       3
        ora     #$27                            ; 96BF 09 27                    .'
        .byte   $27                             ; 96C1 27                       '
        .byte   $27                             ; 96C2 27                       '
        .byte   $27                             ; 96C3 27                       '
        .byte   $27                             ; 96C4 27                       '
        .byte   $27                             ; 96C5 27                       '
        .byte   $27                             ; 96C6 27                       '
        .byte   $12                             ; 96C7 12                       .
        .byte   $0F                             ; 96C8 0F                       .
        asl     a                               ; 96C9 0A                       .
        and     L0F0F,y                         ; 96CA 39 0F 0F                 9..
        .byte   $0F                             ; 96CD 0F                       .
        .byte   $0F                             ; 96CE 0F                       .
        asl     $15                             ; 96CF 06 15                    ..
        bpl     L9702                           ; 96D1 10 2F                    ./
        ora     $15,x                           ; 96D3 15 15                    ..
        ora     $15,x                           ; 96D5 15 15                    ..
        asl     $09                             ; 96D7 06 09                    ..
        asl     $3F,x                           ; 96D9 16 3F                    .?
        ora     #$09                            ; 96DB 09 09                    ..
        .byte   $4B                             ; 96DD 4B                       K
        .byte   $12                             ; 96DE 12                       .
        asl     $18                             ; 96DF 06 18                    ..
        bpl     L9712                           ; 96E1 10 2F                    ./
        ora     #$4B                            ; 96E3 09 4B                    .K
        .byte   $12                             ; 96E5 12                       .
        jmp     L1506                           ; 96E6 4C 06 15                 L..

; ----------------------------------------------------------------------------
        bpl     L96EB                           ; 96E9 10 00                    ..
L96EB:  .byte   $27                             ; 96EB 27                       '
        .byte   $12                             ; 96EC 12                       .
        jmp     L064D                           ; 96ED 4C 4D 06                 LM.

; ----------------------------------------------------------------------------
        .byte   $27                             ; 96F0 27                       '
        .byte   $27                             ; 96F1 27                       '
        .byte   $0C                             ; 96F2 0C                       .
        ora     #$4C                            ; 96F3 09 4C                    .L
        eor     L064D                           ; 96F5 4D 4D 06                 MM.
        ora     #$0A                            ; 96F8 09 0A                    ..
        and     $4D09,y                         ; 96FA 39 09 4D                 9.M
        eor     L064D                           ; 96FD 4D 4D 06                 MM.
        brk                                     ; 9700 00                       .
        .byte   $4E                             ; 9701 4E                       N
L9702:  .byte   $4F                             ; 9702 4F                       O
        bvc     L9711                           ; 9703 50 0C                    P.
        eor     ($4D),y                         ; 9705 51 4D                    QM
        asl     $4C                             ; 9707 06 4C                    .L
        brk                                     ; 9709 00                       .
        lsr     $504F                           ; 970A 4E 4F 50                 NOP
        .byte   $0C                             ; 970D 0C                       .
        eor     $4D26                           ; 970E 4D 26 4D                 M&M
L9711:  .byte   $26                             ; 9711 26                       &
L9712:  .byte   $12                             ; 9712 12                       .
        ora     $4D,x                           ; 9713 15 4D                    .M
        ora     $51,x                           ; 9715 15 51                    .Q
        brk                                     ; 9717 00                       .
        eor     ($18),y                         ; 9718 51 18                    Q.
        rol     $12                             ; 971A 26 12                    &.
        eor     $0C00                           ; 971C 4D 00 0C                 M..
        asl     $26                             ; 971F 06 26                    .&
        .byte   $12                             ; 9721 12                       .
        ora     #$52                            ; 9722 09 52                    .R
        eor     $0953                           ; 9724 4D 53 09                 MS.
        asl     $09                             ; 9727 06 09                    ..
        asl     $09                             ; 9729 06 09                    ..
        ora     #$4D                            ; 972B 09 4D                    .M
        rol     $12                             ; 972D 26 12                    &.
        asl     $54                             ; 972F 06 54                    .T
        eor     $09,x                           ; 9731 55 09                    U.
        ora     #$4D                            ; 9733 09 4D                    .M
        ora     #$4C                            ; 9735 09 4C                    .L
        asl     $56                             ; 9737 06 56                    .V
        .byte   $57                             ; 9739 57                       W
        ora     $15,x                           ; 973A 15 15                    ..
        eor     $4D15                           ; 973C 4D 15 4D                 M.M
        asl     $20                             ; 973F 06 20                    . 
        .byte   $33                             ; 9741 33                       3
        .byte   $0F                             ; 9742 0F                       .
        .byte   $0F                             ; 9743 0F                       .
        eor     $4D0F                           ; 9744 4D 0F 4D                 M.M
        asl     $05                             ; 9747 06 05                    ..
        bit     $09                             ; 9749 24 09                    $.
        ora     #$4D                            ; 974B 09 4D                    .M
        ora     #$58                            ; 974D 09 58                    .X
        asl     $07                             ; 974F 06 07                    ..
        eor     $09,y                           ; 9751 59 09 00                 Y..
        .byte   $0C                             ; 9754 0C                       .
        ora     #$09                            ; 9755 09 09                    ..
        asl     $13                             ; 9757 06 13                    ..
        asl     $15                             ; 9759 06 15                    ..
        .byte   $52                             ; 975B 52                       R
        ora     $15,x                           ; 975C 15 15                    ..
        ora     $06,x                           ; 975E 15 06                    ..
        ora     $1806                           ; 9760 0D 06 18                 ...
        clc                                     ; 9763 18                       .
        clc                                     ; 9764 18                       .
        clc                                     ; 9765 18                       .
        clc                                     ; 9766 18                       .
        .byte   $5A                             ; 9767 5A                       Z
        brk                                     ; 9768 00                       .
        .byte   $0C                             ; 9769 0C                       .
        ora     #$09                            ; 976A 09 09                    ..
        and     $5B5B                           ; 976C 2D 5B 5B                 -[[
        .byte   $5B                             ; 976F 5B                       [
        asl     $0F                             ; 9770 06 0F                    ..
        .byte   $0F                             ; 9772 0F                       .
        .byte   $0F                             ; 9773 0F                       .
        bmi     L97CC                           ; 9774 30 56                    0V
        lsr     $56,x                           ; 9776 56 56                    VV
        asl     $15                             ; 9778 06 15                    ..
        ora     $15,x                           ; 977A 15 15                    ..
        .byte   $1F                             ; 977C 1F                       .
        jsr     L2020                           ; 977D 20 20 20                    
        asl     $0F                             ; 9780 06 0F                    ..
        .byte   $0F                             ; 9782 0F                       .
        .byte   $0F                             ; 9783 0F                       .
        .byte   $1F                             ; 9784 1F                       .
        jsr     L2020                           ; 9785 20 20 20                    
        asl     $5C                             ; 9788 06 5C                    .\
        .byte   $5C                             ; 978A 5C                       \
        .byte   $5C                             ; 978B 5C                       \
        .byte   $1F                             ; 978C 1F                       .
        jsr     L2020                           ; 978D 20 20 20                    
        asl     $0D                             ; 9790 06 0D                    ..
        ora     $020D                           ; 9792 0D 0D 02                 ...
        ora     $05                             ; 9795 05 05                    ..
        .byte   $03                             ; 9797 03                       .
        rol     $12                             ; 9798 26 12                    &.
        ora     $390D                           ; 979A 0D 0D 39                 ..9
        clc                                     ; 979D 18                       .
        clc                                     ; 979E 18                       .
        clc                                     ; 979F 18                       .
        .byte   $54                             ; 97A0 54                       T
        eor     $0D5E,x                         ; 97A1 5D 5E 0D                 ]^.
        .byte   $2F                             ; 97A4 2F                       /
        .byte   $5F                             ; 97A5 5F                       _
        .byte   $54                             ; 97A6 54                       T
        rts                                     ; 97A7 60                       `

; ----------------------------------------------------------------------------
        adc     ($61,x)                         ; 97A8 61 61                    aa
        .byte   $62                             ; 97AA 62                       b
        .byte   $63                             ; 97AB 63                       c
        .byte   $64                             ; 97AC 64                       d
        lsr     $47                             ; 97AD 46 47                    FG
        .byte   $47                             ; 97AF 47                       G
        adc     $66                             ; 97B0 65 66                    ef
        .byte   $67                             ; 97B2 67                       g
        eor     #$4A                            ; 97B3 49 4A                    IJ
        .byte   $1F                             ; 97B5 1F                       .
        jsr     L6820                           ; 97B6 20 20 68                   h
        adc     #$67                            ; 97B9 69 67                    ig
        ora     $1F2F                           ; 97BB 0D 2F 1F                 ./.
        jsr     L3A20                           ; 97BE 20 20 3A                   :
        .byte   $27                             ; 97C1 27                       '
        ora     ($6A,x)                         ; 97C2 01 6A                    .j
        .byte   $6B                             ; 97C4 6B                       k
        and     $6A,x                           ; 97C5 35 6A                    5j
        and     $38,x                           ; 97C7 35 38                    58
        asl     a                               ; 97C9 0A                       .
        .byte   $0B                             ; 97CA 0B                       .
        ror     a                               ; 97CB 6A                       j
L97CC:  .byte   $6B                             ; 97CC 6B                       k
        and     $6A,x                           ; 97CD 35 6A                    5j
        and     $6C,x                           ; 97CF 35 6C                    5l
        .byte   $27                             ; 97D1 27                       '
        ora     ($6A,x)                         ; 97D2 01 6A                    .j
        .byte   $6B                             ; 97D4 6B                       k
        and     $6D,x                           ; 97D5 35 6D                    5m
        ror     $0A18                           ; 97D7 6E 18 0A                 n..
        .byte   $0B                             ; 97DA 0B                       .
        adc     $6E6F                           ; 97DB 6D 6F 6E                 mon
        ora     $0A,x                           ; 97DE 15 0A                    ..
        bvs     L97F2                           ; 97E0 70 10                    p.
        ora     ($07),y                         ; 97E2 11 07                    ..
        php                                     ; 97E4 08                       .
        clc                                     ; 97E5 18                       .
        clc                                     ; 97E6 18                       .
        bpl     L985A                           ; 97E7 10 71                    .q
        .byte   $72                             ; 97E9 72                       r
        .byte   $73                             ; 97EA 73                       s
        .byte   $13                             ; 97EB 13                       .
        .byte   $14                             ; 97EC 14                       .
        ora     #$74                            ; 97ED 09 74                    .t
        .byte   $72                             ; 97EF 72                       r
        adc     $76,x                           ; 97F0 75 76                    uv
L97F2:  .byte   $77                             ; 97F2 77                       w
        sei                                     ; 97F3 78                       x
        adc     $7B7A,y                         ; 97F4 79 7A 7B                 yz{
        .byte   $7C                             ; 97F7 7C                       |
        sec                                     ; 97F8 38                       8
        bpl     L9821                           ; 97F9 10 26                    .&
        adc     $6261,x                         ; 97FB 7D 61 62                 }ab
        .byte   $0C                             ; 97FE 0C                       .
        ora     #$15                            ; 97FF 09 15                    ..
        ror     L807F,x                         ; 9801 7E 7F 80                 ~..
        ora     $7E,x                           ; 9804 15 7E                    .~
        .byte   $80                             ; 9806 80                       .
        ora     $81,x                           ; 9807 15 81                    ..
        .byte   $82                             ; 9809 82                       .
        .byte   $7F                             ; 980A 7F                       .
        .byte   $80                             ; 980B 80                       .
        ora     #$7E                            ; 980C 09 7E                    .~
        .byte   $80                             ; 980E 80                       .
        ora     #$83                            ; 980F 09 83                    ..
        .byte   $83                             ; 9811 83                       .
        .byte   $83                             ; 9812 83                       .
        .byte   $80                             ; 9813 80                       .
        .byte   $0F                             ; 9814 0F                       .
        ror     $0F80,x                         ; 9815 7E 80 0F                 ~..
        php                                     ; 9818 08                       .
        php                                     ; 9819 08                       .
        php                                     ; 981A 08                       .
        .byte   $80                             ; 981B 80                       .
        clc                                     ; 981C 18                       .
        ror     $1880,x                         ; 981D 7E 80 18                 ~..
        .byte   $0E                             ; 9820 0E                       .
L9821:  asl     L800E                           ; 9821 0E 0E 80                 ...
        ora     $7E,x                           ; 9824 15 7E                    .~
        .byte   $80                             ; 9826 80                       .
        ora     $84,x                           ; 9827 15 84                    ..
        sta     $86                             ; 9829 85 86                    ..
        .byte   $87                             ; 982B 87                       .
        dey                                     ; 982C 88                       .
        .byte   $89                             ; 982D 89                       .
        .byte   $87                             ; 982E 87                       .
        dey                                     ; 982F 88                       .
        .byte   $7C                             ; 9830 7C                       |
        txa                                     ; 9831 8A                       .
        .byte   $8B                             ; 9832 8B                       .
        sty     L8A7C                           ; 9833 8C 7C 8A                 .|.
        sty     $097C                           ; 9836 8C 7C 09                 .|.
        ror     L807F,x                         ; 9839 7E 7F 80                 ~..
        ora     #$7E                            ; 983C 09 7E                    .~
        .byte   $80                             ; 983E 80                       .
        ora     #$8D                            ; 983F 09 8D                    ..
        stx     L908F                           ; 9841 8E 8F 90                 ...
        sta     ($0D),y                         ; 9844 91 0D                    ..
        ora     $0D0D                           ; 9846 0D 0D 0D                 ...
        .byte   $92                             ; 9849 92                       .
        .byte   $93                             ; 984A 93                       .
        sty     $0D,x                           ; 984B 94 0D                    ..
        ora     $0D0D                           ; 984D 0D 0D 0D                 ...
        ora     L9392                           ; 9850 0D 92 93                 ...
        sty     $8D,x                           ; 9853 94 8D                    ..
        stx     L9190                           ; 9855 8E 90 91                 ...
        .byte   $0D                             ; 9858 0D                       .
        .byte   $92                             ; 9859 92                       .
L985A:  .byte   $93                             ; 985A 93                       .
        sty     $0D,x                           ; 985B 94 0D                    ..
        .byte   $92                             ; 985D 92                       .
        sty     $0D,x                           ; 985E 94 0D                    ..
        sta     $92,x                           ; 9860 95 92                    ..
        .byte   $93                             ; 9862 93                       .
        sty     $95,x                           ; 9863 94 95                    ..
        .byte   $92                             ; 9865 92                       .
        sty     $95,x                           ; 9866 94 95                    ..
        ora     $92,x                           ; 9868 15 92                    ..
        .byte   $93                             ; 986A 93                       .
        sty     $15,x                           ; 986B 94 15                    ..
        .byte   $92                             ; 986D 92                       .
        sty     $15,x                           ; 986E 94 15                    ..
        .byte   $0F                             ; 9870 0F                       .
        .byte   $92                             ; 9871 92                       .
        .byte   $93                             ; 9872 93                       .
        sty     $0F,x                           ; 9873 94 0F                    ..
        .byte   $92                             ; 9875 92                       .
        sty     $0F,x                           ; 9876 94 0F                    ..
        clc                                     ; 9878 18                       .
        .byte   $92                             ; 9879 92                       .
        .byte   $93                             ; 987A 93                       .
        sty     $18,x                           ; 987B 94 18                    ..
        .byte   $92                             ; 987D 92                       .
        sty     $18,x                           ; 987E 94 18                    ..
        stx     $96,y                           ; 9880 96 96                    ..
        stx     $96,y                           ; 9882 96 96                    ..
        stx     $96,y                           ; 9884 96 96                    ..
        stx     $96,y                           ; 9886 96 96                    ..
        .byte   $83                             ; 9888 83                       .
        .byte   $83                             ; 9889 83                       .
        .byte   $83                             ; 988A 83                       .
        .byte   $83                             ; 988B 83                       .
        .byte   $83                             ; 988C 83                       .
        .byte   $83                             ; 988D 83                       .
        .byte   $83                             ; 988E 83                       .
        .byte   $83                             ; 988F 83                       .
        .byte   $0F                             ; 9890 0F                       .
        .byte   $0F                             ; 9891 0F                       .
        .byte   $0F                             ; 9892 0F                       .
        .byte   $0F                             ; 9893 0F                       .
        .byte   $0F                             ; 9894 0F                       .
        .byte   $0F                             ; 9895 0F                       .
        .byte   $0F                             ; 9896 0F                       .
        .byte   $0F                             ; 9897 0F                       .
        clc                                     ; 9898 18                       .
        clc                                     ; 9899 18                       .
        clc                                     ; 989A 18                       .
        clc                                     ; 989B 18                       .
        clc                                     ; 989C 18                       .
        clc                                     ; 989D 18                       .
        clc                                     ; 989E 18                       .
        clc                                     ; 989F 18                       .
        ora     #$09                            ; 98A0 09 09                    ..
        ora     #$09                            ; 98A2 09 09                    ..
        sta     ($81,x)                         ; 98A4 81 81                    ..
        sta     ($81,x)                         ; 98A6 81 81                    ..
        .byte   $97                             ; 98A8 97                       .
        .byte   $97                             ; 98A9 97                       .
        .byte   $97                             ; 98AA 97                       .
        .byte   $97                             ; 98AB 97                       .
        tya                                     ; 98AC 98                       .
        .byte   $83                             ; 98AD 83                       .
        .byte   $83                             ; 98AE 83                       .
        stx     $0D,y                           ; 98AF 96 0D                    ..
        ora     $0D0D                           ; 98B1 0D 0D 0D                 ...
        ora     $0707                           ; 98B4 0D 07 07                 ...
        tya                                     ; 98B7 98                       .
        ora     $0D0D                           ; 98B8 0D 0D 0D                 ...
        ora     $0D0D                           ; 98BB 0D 0D 0D                 ...
        ora     L960D                           ; 98BE 0D 0D 96                 ...
        ror     a                               ; 98C1 6A                       j
        and     $99,x                           ; 98C2 35 99                    5.
        txs                                     ; 98C4 9A                       .
        .byte   $9B                             ; 98C5 9B                       .
        .byte   $9C                             ; 98C6 9C                       .
        sta     $6D83,y                         ; 98C7 99 83 6D                 ..m
        ror     L9D9D                           ; 98CA 6E 9D 9D                 n..
        sta     L9D9E,x                         ; 98CD 9D 9E 9D                 ...
        asl     a                               ; 98D0 0A                       .
        .byte   $07                             ; 98D1 07                       .
        and     $A09F,y                         ; 98D2 39 9F A0                 9..
        lda     (L00A2,x)                       ; 98D5 A1 A2                    ..
        .byte   $A3                             ; 98D7 A3                       .
        asl     $13,x                           ; 98D8 16 13                    ..
        .byte   $3F                             ; 98DA 3F                       ?
        ldy     $A5                             ; 98DB A4 A5                    ..
        ldx     $A7                             ; 98DD A6 A7                    ..
        tay                                     ; 98DF A8                       .
        lda     #$0D                            ; 98E0 A9 0D                    ..
        .byte   $2F                             ; 98E2 2F                       /
        tax                                     ; 98E3 AA                       .
        .byte   $AB                             ; 98E4 AB                       .
        tax                                     ; 98E5 AA                       .
        .byte   $AB                             ; 98E6 AB                       .
        tax                                     ; 98E7 AA                       .
        stx     $96,y                           ; 98E8 96 96                    ..
        .byte   $2F                             ; 98EA 2F                       /
        ldy     $ACAD                           ; 98EB AC AD AC                 ...
        lda     $34AC                           ; 98EE AD AC 34                 ..4
        ldx     $1DAF                           ; 98F1 AE AF 1D                 ...
        ldx     $1DB0                           ; 98F4 AE B0 1D                 ...
        ldx     $B136                           ; 98F7 AE 36 B1                 .6.
        .byte   $B2                             ; 98FA B2                       .
        .byte   $22                             ; 98FB 22                       "
        lda     ($B1),y                         ; 98FC B1 B1                    ..
        .byte   $22                             ; 98FE 22                       "
        lda     ($9A),y                         ; 98FF B1 9A                    ..
        .byte   $9B                             ; 9901 9B                       .
        .byte   $9C                             ; 9902 9C                       .
        sta     L9B9A,y                         ; 9903 99 9A 9B                 ...
        .byte   $9C                             ; 9906 9C                       .
        sta     L9D9D,y                         ; 9907 99 9D 9D                 ...
        .byte   $B3                             ; 990A B3                       .
        sta     L9D9D,x                         ; 990B 9D 9D 9D                 ...
        .byte   $9E                             ; 990E 9E                       .
        sta     $B5B4,x                         ; 990F 9D B4 B5                 ...
        ldx     $9F,y                           ; 9912 B6 9F                    ..
        ldy     #$A1                            ; 9914 A0 A1                    ..
        ldx     #$A3                            ; 9916 A2 A3                    ..
        .byte   $B7                             ; 9918 B7                       .
        clv                                     ; 9919 B8                       .
        lda     $A5A4,y                         ; 991A B9 A4 A5                 ...
        ldx     $A7                             ; 991D A6 A7                    ..
        tay                                     ; 991F A8                       .
        .byte   $AB                             ; 9920 AB                       .
        tax                                     ; 9921 AA                       .
        .byte   $AB                             ; 9922 AB                       .
        tax                                     ; 9923 AA                       .
        .byte   $AB                             ; 9924 AB                       .
        tax                                     ; 9925 AA                       .
        tsx                                     ; 9926 BA                       .
        .byte   $BB                             ; 9927 BB                       .
        lda     $ADAC                           ; 9928 AD AC AD                 ...
        ldy     L9696,x                         ; 992B BC 96 96                 ...
        lda     $AEBE,x                         ; 992E BD BE AE                 ...
        .byte   $AF                             ; 9931 AF                       .
        ora     $BF1E,x                         ; 9932 1D 1E BF                 ...
        .byte   $32                             ; 9935 32                       2
        rol     $BE,x                           ; 9936 36 BE                    6.
        lda     ($B2),y                         ; 9938 B1 B2                    ..
        .byte   $22                             ; 993A 22                       "
        .byte   $23                             ; 993B 23                       #
        .byte   $6B                             ; 993C 6B                       k
        and     $36,x                           ; 993D 35 36                    56
        ldx     L9B9A,y                         ; 993F BE 9A 9B                 ...
        .byte   $9C                             ; 9942 9C                       .
        sta     L9B9A,y                         ; 9943 99 9A 9B                 ...
        .byte   $9C                             ; 9946 9C                       .
        sta     L9D9D,y                         ; 9947 99 9D 9D                 ...
        .byte   $B3                             ; 994A B3                       .
        sta     L9D9D,x                         ; 994B 9D 9D 9D                 ...
        .byte   $9E                             ; 994E 9E                       .
        sta     $B5B4,x                         ; 994F 9D B4 B5                 ...
        ldx     $9F,y                           ; 9952 B6 9F                    ..
        ldy     #$A1                            ; 9954 A0 A1                    ..
        ldx     #$A3                            ; 9956 A2 A3                    ..
        .byte   $B7                             ; 9958 B7                       .
        clv                                     ; 9959 B8                       .
        lda     $A5A4,y                         ; 995A B9 A4 A5                 ...
        ldx     $A7                             ; 995D A6 A7                    ..
        tay                                     ; 995F A8                       .
        cpy     #$C1                            ; 9960 C0 C1                    ..
        .byte   $C2                             ; 9962 C2                       .
        cpy     #$C3                            ; 9963 C0 C3                    ..
        cpy     $C5                             ; 9965 C4 C5                    ..
        dec     $C7                             ; 9967 C6 C7                    ..
        ldx     $C7BE,y                         ; 9969 BE BE C7                 ...
        ror     $62                             ; 996C 66 62                    fb
        iny                                     ; 996E C8                       .
        iny                                     ; 996F C8                       .
        .byte   $22                             ; 9970 22                       "
        ldx     $22C9,y                         ; 9971 BE C9 22                 .."
        adc     #$67                            ; 9974 69 67                    ig
        dex                                     ; 9976 CA                       .
        .byte   $CB                             ; 9977 CB                       .
        .byte   $22                             ; 9978 22                       "
        .byte   $B2                             ; 9979 B2                       .
        .byte   $B2                             ; 997A B2                       .
        .byte   $22                             ; 997B 22                       "
        adc     #$67                            ; 997C 69 67                    ig
        cpy     L9ACD                           ; 997E CC CD 9A                 ...
        .byte   $9B                             ; 9981 9B                       .
        .byte   $9C                             ; 9982 9C                       .
        sta     L9B9A,y                         ; 9983 99 9A 9B                 ...
        .byte   $9C                             ; 9986 9C                       .
        sta     L9D9D,y                         ; 9987 99 9D 9D                 ...
        .byte   $B3                             ; 998A B3                       .
        sta     L9D9D,x                         ; 998B 9D 9D 9D                 ...
        .byte   $9E                             ; 998E 9E                       .
        sta     $B5B4,x                         ; 998F 9D B4 B5                 ...
        ldx     $9F,y                           ; 9992 B6 9F                    ..
        ldy     #$A1                            ; 9994 A0 A1                    ..
        ldx     #$A3                            ; 9996 A2 A3                    ..
        .byte   $B7                             ; 9998 B7                       .
        clv                                     ; 9999 B8                       .
        lda     $A5A4,y                         ; 999A B9 A4 A5                 ...
        ldx     $A7                             ; 999D A6 A7                    ..
        tay                                     ; 999F A8                       .
        dec     $C5CF                           ; 99A0 CE CF C5                 ...
        dec     $CFD0                           ; 99A3 CE D0 CF                 ...
        cmp     $C6                             ; 99A6 C5 C6                    ..
        iny                                     ; 99A8 C8                       .
        iny                                     ; 99A9 C8                       .
        iny                                     ; 99AA C8                       .
        iny                                     ; 99AB C8                       .
        iny                                     ; 99AC C8                       .
        iny                                     ; 99AD C8                       .
        iny                                     ; 99AE C8                       .
        iny                                     ; 99AF C8                       .
        dex                                     ; 99B0 CA                       .
        .byte   $CB                             ; 99B1 CB                       .
        dex                                     ; 99B2 CA                       .
        .byte   $CB                             ; 99B3 CB                       .
        dex                                     ; 99B4 CA                       .
        .byte   $CB                             ; 99B5 CB                       .
        dex                                     ; 99B6 CA                       .
        .byte   $CB                             ; 99B7 CB                       .
        cpy     $CCCD                           ; 99B8 CC CD CC                 ...
        cmp     $CDCC                           ; 99BB CD CC CD                 ...
        cpy     L9ACD                           ; 99BE CC CD 9A                 ...
        .byte   $9B                             ; 99C1 9B                       .
        .byte   $9C                             ; 99C2 9C                       .
        sta     L9B9A,y                         ; 99C3 99 9A 9B                 ...
        .byte   $9C                             ; 99C6 9C                       .
        sta     L9D9D,y                         ; 99C7 99 9D 9D                 ...
        .byte   $B3                             ; 99CA B3                       .
        sta     L9D9D,x                         ; 99CB 9D 9D 9D                 ...
        .byte   $9E                             ; 99CE 9E                       .
        sta     $B5B4,x                         ; 99CF 9D B4 B5                 ...
        ldx     $9F,y                           ; 99D2 B6 9F                    ..
        ldy     #$A1                            ; 99D4 A0 A1                    ..
        ldx     #$A3                            ; 99D6 A2 A3                    ..
        .byte   $B7                             ; 99D8 B7                       .
        clv                                     ; 99D9 B8                       .
        lda     $A5A4,y                         ; 99DA B9 A4 A5                 ...
        ldx     $A7                             ; 99DD A6 A7                    ..
        tay                                     ; 99DF A8                       .
        dec     $C5CF                           ; 99E0 CE CF C5                 ...
        dec     $CFD0                           ; 99E3 CE D0 CF                 ...
        cmp     $C6                             ; 99E6 C5 C6                    ..
        iny                                     ; 99E8 C8                       .
        iny                                     ; 99E9 C8                       .
        iny                                     ; 99EA C8                       .
        iny                                     ; 99EB C8                       .
        iny                                     ; 99EC C8                       .
        iny                                     ; 99ED C8                       .
        iny                                     ; 99EE C8                       .
        iny                                     ; 99EF C8                       .
        dex                                     ; 99F0 CA                       .
        .byte   $CB                             ; 99F1 CB                       .
        dex                                     ; 99F2 CA                       .
        .byte   $CB                             ; 99F3 CB                       .
        dex                                     ; 99F4 CA                       .
        .byte   $CB                             ; 99F5 CB                       .
        dex                                     ; 99F6 CA                       .
        .byte   $CB                             ; 99F7 CB                       .
        cpy     $CCCD                           ; 99F8 CC CD CC                 ...
        cmp     $CDCC                           ; 99FB CD CC CD                 ...
        cpy     $09CD                           ; 99FE CC CD 09                 ...
        ora     #$09                            ; 9A01 09 09                    ..
        ora     #$09                            ; 9A03 09 09                    ..
        ora     #$09                            ; 9A05 09 09                    ..
        ora     #$09                            ; 9A07 09 09                    ..
        ora     #$09                            ; 9A09 09 09                    ..
        ora     #$09                            ; 9A0B 09 09                    ..
        ora     #$09                            ; 9A0D 09 09                    ..
        ora     #$09                            ; 9A0F 09 09                    ..
        ora     #$09                            ; 9A11 09 09                    ..
        ora     #$09                            ; 9A13 09 09                    ..
        ora     #$09                            ; 9A15 09 09                    ..
        ora     #$09                            ; 9A17 09 09                    ..
        ora     #$09                            ; 9A19 09 09                    ..
        ora     #$D1                            ; 9A1B 09 D1                    ..
        .byte   $D2                             ; 9A1D D2                       .
        .byte   $D3                             ; 9A1E D3                       .
        .byte   $D4                             ; 9A1F D4                       .
        ora     #$09                            ; 9A20 09 09                    ..
        ora     #$09                            ; 9A22 09 09                    ..
        cmp     $D6,x                           ; 9A24 D5 D6                    ..
        .byte   $D7                             ; 9A26 D7                       .
        cld                                     ; 9A27 D8                       .
        ora     #$09                            ; 9A28 09 09                    ..
        ora     #$09                            ; 9A2A 09 09                    ..
        cmp     $DBDA,y                         ; 9A2C D9 DA DB                 ...
        .byte   $DC                             ; 9A2F DC                       .
        ora     #$09                            ; 9A30 09 09                    ..
        ora     #$09                            ; 9A32 09 09                    ..
        cmp     $DFDE,x                         ; 9A34 DD DE DF                 ...
        cpx     #$09                            ; 9A37 E0 09                    ..
        ora     #$09                            ; 9A39 09 09                    ..
        ora     #$09                            ; 9A3B 09 09                    ..
        ora     #$09                            ; 9A3D 09 09                    ..
        ora     #$9A                            ; 9A3F 09 9A                    ..
        .byte   $9B                             ; 9A41 9B                       .
        .byte   $9C                             ; 9A42 9C                       .
        sta     L9B9A,y                         ; 9A43 99 9A 9B                 ...
        .byte   $9C                             ; 9A46 9C                       .
        sta     L9D9D,y                         ; 9A47 99 9D 9D                 ...
        .byte   $B3                             ; 9A4A B3                       .
        sta     L9D9D,x                         ; 9A4B 9D 9D 9D                 ...
        .byte   $9E                             ; 9A4E 9E                       .
        sta     $B5B4,x                         ; 9A4F 9D B4 B5                 ...
        ldx     $9F,y                           ; 9A52 B6 9F                    ..
        ldy     #$A1                            ; 9A54 A0 A1                    ..
        ldx     #$A3                            ; 9A56 A2 A3                    ..
        .byte   $B7                             ; 9A58 B7                       .
        clv                                     ; 9A59 B8                       .
        lda     $A5A4,y                         ; 9A5A B9 A4 A5                 ...
        ldx     $A7                             ; 9A5D A6 A7                    ..
        tay                                     ; 9A5F A8                       .
        dec     $C5CF                           ; 9A60 CE CF C5                 ...
        dec     $CFD0                           ; 9A63 CE D0 CF                 ...
        cmp     $C6                             ; 9A66 C5 C6                    ..
        iny                                     ; 9A68 C8                       .
        iny                                     ; 9A69 C8                       .
        iny                                     ; 9A6A C8                       .
        iny                                     ; 9A6B C8                       .
        iny                                     ; 9A6C C8                       .
        iny                                     ; 9A6D C8                       .
        iny                                     ; 9A6E C8                       .
        iny                                     ; 9A6F C8                       .
        dex                                     ; 9A70 CA                       .
        .byte   $CB                             ; 9A71 CB                       .
        dex                                     ; 9A72 CA                       .
        .byte   $CB                             ; 9A73 CB                       .
        dex                                     ; 9A74 CA                       .
        .byte   $CB                             ; 9A75 CB                       .
        dex                                     ; 9A76 CA                       .
        .byte   $CB                             ; 9A77 CB                       .
        cpy     $CCCD                           ; 9A78 CC CD CC                 ...
        cmp     $CDCC                           ; 9A7B CD CC CD                 ...
        cpy     L9ACD                           ; 9A7E CC CD 9A                 ...
        .byte   $9B                             ; 9A81 9B                       .
        .byte   $9C                             ; 9A82 9C                       .
        .byte   $99                             ; 9A83 99                       .
        txs                                     ; 9A84 9A                       .
L9A85:  .byte   $9B                             ; 9A85 9B                       .
        .byte   $9C                             ; 9A86 9C                       .
        sta     L9D9D,y                         ; 9A87 99 9D 9D                 ...
        .byte   $B3                             ; 9A8A B3                       .
        sta     L9D9D,x                         ; 9A8B 9D 9D 9D                 ...
        .byte   $9E                             ; 9A8E 9E                       .
        sta     $B5B4,x                         ; 9A8F 9D B4 B5                 ...
        ldx     $9F,y                           ; 9A92 B6 9F                    ..
        ldy     #$A1                            ; 9A94 A0 A1                    ..
        ldx     #$A3                            ; 9A96 A2 A3                    ..
        .byte   $B7                             ; 9A98 B7                       .
        clv                                     ; 9A99 B8                       .
        lda     $A5A4,y                         ; 9A9A B9 A4 A5                 ...
        ldx     $A7                             ; 9A9D A6 A7                    ..
        tay                                     ; 9A9F A8                       .
        dec     $C5CF                           ; 9AA0 CE CF C5                 ...
        sbc     ($E2,x)                         ; 9AA3 E1 E2                    ..
        .byte   $E3                             ; 9AA5 E3                       .
        .byte   $AB                             ; 9AA6 AB                       .
        tax                                     ; 9AA7 AA                       .
        iny                                     ; 9AA8 C8                       .
        iny                                     ; 9AA9 C8                       .
        iny                                     ; 9AAA C8                       .
        adc     $6261,x                         ; 9AAB 7D 61 62                 }ab
        cpx     $BC                             ; 9AAE E4 BC                    ..
        dex                                     ; 9AB0 CA                       .
        .byte   $CB                             ; 9AB1 CB                       .
        dex                                     ; 9AB2 CA                       .
        sbc     $61                             ; 9AB3 E5 61                    .a
        .byte   $67                             ; 9AB5 67                       g
        .byte   $34                             ; 9AB6 34                       4
        bcs     L9A85                           ; 9AB7 B0 CC                    ..
        cmp     $E5CC                           ; 9AB9 CD CC E5                 ...
        adc     ($67,x)                         ; 9ABC 61 67                    ag
        rol     $B1,x                           ; 9ABE 36 B1                    6.
        txs                                     ; 9AC0 9A                       .
        .byte   $9B                             ; 9AC1 9B                       .
        .byte   $9C                             ; 9AC2 9C                       .
        sta     L9B9A,y                         ; 9AC3 99 9A 9B                 ...
        .byte   $9C                             ; 9AC6 9C                       .
        rol     $9D,x                           ; 9AC7 36 9D                    6.
        sta     L9DB3,x                         ; 9AC9 9D B3 9D                 ...
        .byte   $9D                             ; 9ACC 9D                       .
L9ACD:  sta     $369E,x                         ; 9ACD 9D 9E 36                 ..6
        ldy     $B5,x                           ; 9AD0 B4 B5                    ..
        ldx     $9F,y                           ; 9AD2 B6 9F                    ..
        ldy     #$A1                            ; 9AD4 A0 A1                    ..
        ldx     #$36                            ; 9AD6 A2 36                    .6
        .byte   $B7                             ; 9AD8 B7                       .
        clv                                     ; 9AD9 B8                       .
        lda     $A5A4,y                         ; 9ADA B9 A4 A5                 ...
        ldx     $A7                             ; 9ADD A6 A7                    ..
        inc     $AB                             ; 9ADF E6 AB                    ..
        tax                                     ; 9AE1 AA                       .
        .byte   $AB                             ; 9AE2 AB                       .
        tax                                     ; 9AE3 AA                       .
        .byte   $AB                             ; 9AE4 AB                       .
        tax                                     ; 9AE5 AA                       .
        .byte   $AB                             ; 9AE6 AB                       .
        .byte   $E7                             ; 9AE7 E7                       .
        cpx     $BC                             ; 9AE8 E4 BC                    ..
        cpx     $BC                             ; 9AEA E4 BC                    ..
        lda     $ADAC                           ; 9AEC AD AC AD                 ...
        inx                                     ; 9AEF E8                       .
        ora     $1DB0,x                         ; 9AF0 1D B0 1D                 ...
        ldx     $1DAF                           ; 9AF3 AE AF 1D                 ...
        bcs     L9B15                           ; 9AF6 B0 1D                    ..
        .byte   $22                             ; 9AF8 22                       "
        lda     ($22),y                         ; 9AF9 B1 22                    ."
        lda     ($B2),y                         ; 9AFB B1 B2                    ..
        .byte   $22                             ; 9AFD 22                       "
        lda     ($22),y                         ; 9AFE B1 22                    ."
        ldx     $22BE,y                         ; 9B00 BE BE 22                 .."
        .byte   $B2                             ; 9B03 B2                       .
        .byte   $22                             ; 9B04 22                       "
        sbc     #$22                            ; 9B05 E9 22                    ."
        ldx     $C9BE,y                         ; 9B07 BE BE C9                 ...
        .byte   $22                             ; 9B0A 22                       "
        sbc     #$22                            ; 9B0B E9 22                    ."
        ldx     $C922,y                         ; 9B0D BE 22 C9                 .".
        ldx     $22E9,y                         ; 9B10 BE E9 22                 .."
        .byte   $BE                             ; 9B13 BE                       .
        .byte   $22                             ; 9B14 22                       "
L9B15:  ldx     $B222,y                         ; 9B15 BE 22 B2                 .".
        ldx     $EABE,y                         ; 9B18 BE BE EA                 ...
        ldx     $BEEA,y                         ; 9B1B BE EA BE                 ...
        nop                                     ; 9B1E EA                       .
        sbc     #$EB                            ; 9B1F E9 EB                    ..
        cpx     $EEED                           ; 9B21 EC ED EE                 ...
        .byte   $EF                             ; 9B24 EF                       .
        inc     $F0EF                           ; 9B25 EE EF F0                 ...
        ora     $0E11                           ; 9B28 0D 11 0E                 ...
        clc                                     ; 9B2B 18                       .
        clc                                     ; 9B2C 18                       .
        clc                                     ; 9B2D 18                       .
        clc                                     ; 9B2E 18                       .
        sbc     ($AE),y                         ; 9B2F F1 AE                    ..
        bcs     L9B50                           ; 9B31 B0 1D                    ..
        ldx     $1DB0                           ; 9B33 AE B0 1D                 ...
        ldx     $B1AF                           ; 9B36 AE AF B1                 ...
        lda     ($22),y                         ; 9B39 B1 22                    ."
        lda     ($B1),y                         ; 9B3B B1 B1                    ..
        .byte   $22                             ; 9B3D 22                       "
        lda     ($B2),y                         ; 9B3E B1 B2                    ..
        .byte   $3A                             ; 9B40 3A                       :
        .byte   $27                             ; 9B41 27                       '
        .byte   $0C                             ; 9B42 0C                       .
        rol     $27                             ; 9B43 26 27                    &'
        .byte   $27                             ; 9B45 27                       '
        .byte   $27                             ; 9B46 27                       '
        and     #$F2                            ; 9B47 29 F2                    ).
        .byte   $0F                             ; 9B49 0F                       .
        asl     a                               ; 9B4A 0A                       .
        and     L0F0F,y                         ; 9B4B 39 0F 0F                 9..
        asl     a                               ; 9B4E 0A                       .
        .byte   $F3                             ; 9B4F F3                       .
L9B50:  .byte   $F4                             ; 9B50 F4                       .
        ora     #$16                            ; 9B51 09 16                    ..
        .byte   $3F                             ; 9B53 3F                       ?
        ora     #$09                            ; 9B54 09 09                    ..
        .byte   $16                             ; 9B56 16                       .
L9B57:  sbc     $F6,x                           ; 9B57 F5 F6                    ..
        ora     L0010,x                         ; 9B59 15 10                    ..
        .byte   $2F                             ; 9B5B 2F                       /
        ora     $15,x                           ; 9B5C 15 15                    ..
        bpl     L9B57                           ; 9B5E 10 F7                    ..
        sed                                     ; 9B60 F8                       .
        clc                                     ; 9B61 18                       .
        asl     $3F,x                           ; 9B62 16 3F                    .?
        clc                                     ; 9B64 18                       .
        clc                                     ; 9B65 18                       .
        asl     $F5,x                           ; 9B66 16 F5                    ..
        .byte   $2F                             ; 9B68 2F                       /
L9B69:  .byte   $0F                             ; 9B69 0F                       .
        bpl     L9B9B                           ; 9B6A 10 2F                    ./
        .byte   $0F                             ; 9B6C 0F                       .
        .byte   $0F                             ; 9B6D 0F                       .
        bpl     L9B69                           ; 9B6E 10 F9                    ..
        .byte   $1C                             ; 9B70 1C                       .
        .byte   $1B                             ; 9B71 1B                       .
        .byte   $1C                             ; 9B72 1C                       .
        .byte   $1A                             ; 9B73 1A                       .
        .byte   $1B                             ; 9B74 1B                       .
        ora     $FA1E,x                         ; 9B75 1D 1E FA                 ...
        and     ($20,x)                         ; 9B78 21 20                    ! 
        and     ($20,x)                         ; 9B7A 21 20                    ! 
        jsr     L2322                           ; 9B7C 20 22 23                  "#
        .byte   $FB                             ; 9B7F FB                       .
        ora     #$09                            ; 9B80 09 09                    ..
        ora     #$09                            ; 9B82 09 09                    ..
        ora     #$09                            ; 9B84 09 09                    ..
        ora     #$09                            ; 9B86 09 09                    ..
        ora     #$09                            ; 9B88 09 09                    ..
        .byte   $09                             ; 9B8A 09                       .
L9B8B:  ora     #$09                            ; 9B8B 09 09                    ..
        ora     #$09                            ; 9B8D 09 09                    ..
        ora     #$09                            ; 9B8F 09 09                    ..
        ora     #$09                            ; 9B91 09 09                    ..
        ora     #$09                            ; 9B93 09 09                    ..
        ora     #$09                            ; 9B95 09 09                    ..
        ora     #$09                            ; 9B97 09 09                    ..
        .byte   $09                             ; 9B99 09                       .
L9B9A:  .byte   $09                             ; 9B9A 09                       .
L9B9B:  ora     #$09                            ; 9B9B 09 09                    ..
        ora     #$09                            ; 9B9D 09 09                    ..
        ora     #$09                            ; 9B9F 09 09                    ..
        ora     #$09                            ; 9BA1 09 09                    ..
        ora     #$09                            ; 9BA3 09 09                    ..
        ora     #$09                            ; 9BA5 09 09                    ..
        ora     #$09                            ; 9BA7 09 09                    ..
        ora     #$09                            ; 9BA9 09 09                    ..
        ora     #$09                            ; 9BAB 09 09                    ..
        ora     #$09                            ; 9BAD 09 09                    ..
        ora     #$09                            ; 9BAF 09 09                    ..
        ora     #$09                            ; 9BB1 09 09                    ..
        ora     #$09                            ; 9BB3 09 09                    ..
        ora     #$09                            ; 9BB5 09 09                    ..
        ora     #$09                            ; 9BB7 09 09                    ..
        ora     #$09                            ; 9BB9 09 09                    ..
        ora     #$09                            ; 9BBB 09 09                    ..
        ora     #$09                            ; 9BBD 09 09                    ..
        ora     #$09                            ; 9BBF 09 09                    ..
        ora     #$09                            ; 9BC1 09 09                    ..
        ora     #$09                            ; 9BC3 09 09                    ..
        ora     #$09                            ; 9BC5 09 09                    ..
        ora     #$09                            ; 9BC7 09 09                    ..
        ora     #$09                            ; 9BC9 09 09                    ..
        ora     #$09                            ; 9BCB 09 09                    ..
        ora     #$09                            ; 9BCD 09 09                    ..
        ora     #$09                            ; 9BCF 09 09                    ..
        ora     #$09                            ; 9BD1 09 09                    ..
        ora     #$09                            ; 9BD3 09 09                    ..
        ora     #$09                            ; 9BD5 09 09                    ..
        ora     #$09                            ; 9BD7 09 09                    ..
        ora     #$09                            ; 9BD9 09 09                    ..
        ora     #$09                            ; 9BDB 09 09                    ..
        ora     #$09                            ; 9BDD 09 09                    ..
        ora     #$09                            ; 9BDF 09 09                    ..
        ora     #$09                            ; 9BE1 09 09                    ..
        ora     #$09                            ; 9BE3 09 09                    ..
        ora     #$09                            ; 9BE5 09 09                    ..
        ora     #$09                            ; 9BE7 09 09                    ..
        ora     #$09                            ; 9BE9 09 09                    ..
        ora     #$09                            ; 9BEB 09 09                    ..
        ora     #$09                            ; 9BED 09 09                    ..
        ora     #$09                            ; 9BEF 09 09                    ..
        ora     #$09                            ; 9BF1 09 09                    ..
        ora     #$09                            ; 9BF3 09 09                    ..
        ora     #$09                            ; 9BF5 09 09                    ..
        ora     #$09                            ; 9BF7 09 09                    ..
        ora     #$09                            ; 9BF9 09 09                    ..
        ora     #$09                            ; 9BFB 09 09                    ..
        ora     #$09                            ; 9BFD 09 09                    ..
        ora     #$09                            ; 9BFF 09 09                    ..
        ora     #$09                            ; 9C01 09 09                    ..
        ora     #$09                            ; 9C03 09 09                    ..
        ora     #$09                            ; 9C05 09 09                    ..
        ora     #$09                            ; 9C07 09 09                    ..
        ora     #$09                            ; 9C09 09 09                    ..
        ora     #$09                            ; 9C0B 09 09                    ..
        ora     #$09                            ; 9C0D 09 09                    ..
        ora     #$09                            ; 9C0F 09 09                    ..
        ora     #$09                            ; 9C11 09 09                    ..
        ora     #$09                            ; 9C13 09 09                    ..
        ora     #$09                            ; 9C15 09 09                    ..
        ora     #$09                            ; 9C17 09 09                    ..
        ora     #$09                            ; 9C19 09 09                    ..
        ora     #$09                            ; 9C1B 09 09                    ..
        ora     #$09                            ; 9C1D 09 09                    ..
        ora     #$09                            ; 9C1F 09 09                    ..
        ora     #$09                            ; 9C21 09 09                    ..
        ora     #$09                            ; 9C23 09 09                    ..
        ora     #$09                            ; 9C25 09 09                    ..
        ora     #$09                            ; 9C27 09 09                    ..
        ora     #$09                            ; 9C29 09 09                    ..
        ora     #$09                            ; 9C2B 09 09                    ..
        ora     #$09                            ; 9C2D 09 09                    ..
        ora     #$09                            ; 9C2F 09 09                    ..
        ora     #$09                            ; 9C31 09 09                    ..
        ora     #$09                            ; 9C33 09 09                    ..
        ora     #$09                            ; 9C35 09 09                    ..
        ora     #$09                            ; 9C37 09 09                    ..
        ora     #$09                            ; 9C39 09 09                    ..
        ora     #$09                            ; 9C3B 09 09                    ..
        ora     #$09                            ; 9C3D 09 09                    ..
        .byte   $09                             ; 9C3F 09                       .
L9C40:  ora     #$09                            ; 9C40 09 09                    ..
        ora     #$09                            ; 9C42 09 09                    ..
        ora     #$09                            ; 9C44 09 09                    ..
        ora     #$09                            ; 9C46 09 09                    ..
        ora     #$09                            ; 9C48 09 09                    ..
        ora     #$09                            ; 9C4A 09 09                    ..
        ora     #$09                            ; 9C4C 09 09                    ..
        ora     #$09                            ; 9C4E 09 09                    ..
        ora     #$09                            ; 9C50 09 09                    ..
        ora     #$09                            ; 9C52 09 09                    ..
        ora     #$09                            ; 9C54 09 09                    ..
        ora     #$09                            ; 9C56 09 09                    ..
        ora     #$09                            ; 9C58 09 09                    ..
        ora     #$09                            ; 9C5A 09 09                    ..
        ora     #$09                            ; 9C5C 09 09                    ..
        ora     #$09                            ; 9C5E 09 09                    ..
        ora     #$09                            ; 9C60 09 09                    ..
        ora     #$09                            ; 9C62 09 09                    ..
        ora     #$09                            ; 9C64 09 09                    ..
        ora     #$09                            ; 9C66 09 09                    ..
        ora     #$09                            ; 9C68 09 09                    ..
        ora     #$09                            ; 9C6A 09 09                    ..
        ora     #$09                            ; 9C6C 09 09                    ..
        ora     #$09                            ; 9C6E 09 09                    ..
        ora     #$09                            ; 9C70 09 09                    ..
        ora     #$09                            ; 9C72 09 09                    ..
        ora     #$09                            ; 9C74 09 09                    ..
        ora     #$09                            ; 9C76 09 09                    ..
        ora     #$09                            ; 9C78 09 09                    ..
        ora     #$09                            ; 9C7A 09 09                    ..
        ora     #$09                            ; 9C7C 09 09                    ..
        ora     #$09                            ; 9C7E 09 09                    ..
        ora     #$09                            ; 9C80 09 09                    ..
        ora     #$09                            ; 9C82 09 09                    ..
        ora     #$09                            ; 9C84 09 09                    ..
        ora     #$09                            ; 9C86 09 09                    ..
        ora     #$09                            ; 9C88 09 09                    ..
        ora     #$09                            ; 9C8A 09 09                    ..
        ora     #$09                            ; 9C8C 09 09                    ..
        ora     #$09                            ; 9C8E 09 09                    ..
        ora     #$09                            ; 9C90 09 09                    ..
        ora     #$09                            ; 9C92 09 09                    ..
        ora     #$09                            ; 9C94 09 09                    ..
        ora     #$09                            ; 9C96 09 09                    ..
        ora     #$09                            ; 9C98 09 09                    ..
        ora     #$09                            ; 9C9A 09 09                    ..
        ora     #$09                            ; 9C9C 09 09                    ..
        ora     #$09                            ; 9C9E 09 09                    ..
        ora     #$09                            ; 9CA0 09 09                    ..
        ora     #$09                            ; 9CA2 09 09                    ..
        ora     #$09                            ; 9CA4 09 09                    ..
        ora     #$09                            ; 9CA6 09 09                    ..
        ora     #$09                            ; 9CA8 09 09                    ..
        ora     #$09                            ; 9CAA 09 09                    ..
        ora     #$09                            ; 9CAC 09 09                    ..
        ora     #$09                            ; 9CAE 09 09                    ..
        ora     #$09                            ; 9CB0 09 09                    ..
        ora     #$09                            ; 9CB2 09 09                    ..
        ora     #$09                            ; 9CB4 09 09                    ..
        ora     #$09                            ; 9CB6 09 09                    ..
        ora     #$09                            ; 9CB8 09 09                    ..
        ora     #$09                            ; 9CBA 09 09                    ..
        ora     #$09                            ; 9CBC 09 09                    ..
        ora     #$09                            ; 9CBE 09 09                    ..
        ora     #$09                            ; 9CC0 09 09                    ..
        ora     #$09                            ; 9CC2 09 09                    ..
        ora     #$09                            ; 9CC4 09 09                    ..
        ora     #$09                            ; 9CC6 09 09                    ..
        ora     #$09                            ; 9CC8 09 09                    ..
        ora     #$09                            ; 9CCA 09 09                    ..
        ora     #$09                            ; 9CCC 09 09                    ..
        ora     #$09                            ; 9CCE 09 09                    ..
        ora     #$09                            ; 9CD0 09 09                    ..
        ora     #$09                            ; 9CD2 09 09                    ..
        ora     #$09                            ; 9CD4 09 09                    ..
        ora     #$09                            ; 9CD6 09 09                    ..
        ora     #$09                            ; 9CD8 09 09                    ..
        ora     #$09                            ; 9CDA 09 09                    ..
        ora     #$09                            ; 9CDC 09 09                    ..
        ora     #$09                            ; 9CDE 09 09                    ..
        ora     #$09                            ; 9CE0 09 09                    ..
        ora     #$09                            ; 9CE2 09 09                    ..
        ora     #$09                            ; 9CE4 09 09                    ..
        ora     #$09                            ; 9CE6 09 09                    ..
        ora     #$09                            ; 9CE8 09 09                    ..
        ora     #$09                            ; 9CEA 09 09                    ..
        ora     #$09                            ; 9CEC 09 09                    ..
        ora     #$09                            ; 9CEE 09 09                    ..
        ora     #$09                            ; 9CF0 09 09                    ..
        ora     #$09                            ; 9CF2 09 09                    ..
        ora     #$09                            ; 9CF4 09 09                    ..
        ora     #$09                            ; 9CF6 09 09                    ..
        ora     #$09                            ; 9CF8 09 09                    ..
        ora     #$09                            ; 9CFA 09 09                    ..
        ora     #$09                            ; 9CFC 09 09                    ..
        ora     #$09                            ; 9CFE 09 09                    ..
        ora     #$09                            ; 9D00 09 09                    ..
        ora     #$09                            ; 9D02 09 09                    ..
        ora     #$09                            ; 9D04 09 09                    ..
        ora     #$09                            ; 9D06 09 09                    ..
        ora     #$09                            ; 9D08 09 09                    ..
        ora     #$09                            ; 9D0A 09 09                    ..
        ora     #$09                            ; 9D0C 09 09                    ..
        ora     #$09                            ; 9D0E 09 09                    ..
        ora     #$09                            ; 9D10 09 09                    ..
        ora     #$09                            ; 9D12 09 09                    ..
        ora     #$09                            ; 9D14 09 09                    ..
        ora     #$09                            ; 9D16 09 09                    ..
        ora     #$09                            ; 9D18 09 09                    ..
        ora     #$09                            ; 9D1A 09 09                    ..
        ora     #$09                            ; 9D1C 09 09                    ..
        ora     #$09                            ; 9D1E 09 09                    ..
        ora     #$09                            ; 9D20 09 09                    ..
        ora     #$09                            ; 9D22 09 09                    ..
        ora     #$09                            ; 9D24 09 09                    ..
        ora     #$09                            ; 9D26 09 09                    ..
        ora     #$09                            ; 9D28 09 09                    ..
        ora     #$09                            ; 9D2A 09 09                    ..
        ora     #$09                            ; 9D2C 09 09                    ..
        ora     #$09                            ; 9D2E 09 09                    ..
        ora     #$09                            ; 9D30 09 09                    ..
        ora     #$09                            ; 9D32 09 09                    ..
        ora     #$09                            ; 9D34 09 09                    ..
        ora     #$09                            ; 9D36 09 09                    ..
        ora     #$09                            ; 9D38 09 09                    ..
        ora     #$09                            ; 9D3A 09 09                    ..
        ora     #$09                            ; 9D3C 09 09                    ..
        ora     #$09                            ; 9D3E 09 09                    ..
        ora     #$09                            ; 9D40 09 09                    ..
        ora     #$09                            ; 9D42 09 09                    ..
        ora     #$09                            ; 9D44 09 09                    ..
        ora     #$09                            ; 9D46 09 09                    ..
        ora     #$09                            ; 9D48 09 09                    ..
        ora     #$09                            ; 9D4A 09 09                    ..
        ora     #$09                            ; 9D4C 09 09                    ..
        ora     #$09                            ; 9D4E 09 09                    ..
        ora     #$09                            ; 9D50 09 09                    ..
        ora     #$09                            ; 9D52 09 09                    ..
        ora     #$09                            ; 9D54 09 09                    ..
        ora     #$09                            ; 9D56 09 09                    ..
        ora     #$09                            ; 9D58 09 09                    ..
        ora     #$09                            ; 9D5A 09 09                    ..
        ora     #$09                            ; 9D5C 09 09                    ..
        ora     #$09                            ; 9D5E 09 09                    ..
        ora     #$09                            ; 9D60 09 09                    ..
        ora     #$09                            ; 9D62 09 09                    ..
        ora     #$09                            ; 9D64 09 09                    ..
        ora     #$09                            ; 9D66 09 09                    ..
        ora     #$09                            ; 9D68 09 09                    ..
        ora     #$09                            ; 9D6A 09 09                    ..
        ora     #$09                            ; 9D6C 09 09                    ..
        ora     #$09                            ; 9D6E 09 09                    ..
        ora     #$09                            ; 9D70 09 09                    ..
        ora     #$09                            ; 9D72 09 09                    ..
        ora     #$09                            ; 9D74 09 09                    ..
        ora     #$09                            ; 9D76 09 09                    ..
        ora     #$09                            ; 9D78 09 09                    ..
        ora     #$09                            ; 9D7A 09 09                    ..
        ora     #$09                            ; 9D7C 09 09                    ..
        ora     #$09                            ; 9D7E 09 09                    ..
        ora     #$09                            ; 9D80 09 09                    ..
        ora     #$09                            ; 9D82 09 09                    ..
        ora     #$09                            ; 9D84 09 09                    ..
        ora     #$09                            ; 9D86 09 09                    ..
        ora     #$09                            ; 9D88 09 09                    ..
        ora     #$09                            ; 9D8A 09 09                    ..
        ora     #$09                            ; 9D8C 09 09                    ..
        ora     #$09                            ; 9D8E 09 09                    ..
        ora     #$09                            ; 9D90 09 09                    ..
        ora     #$09                            ; 9D92 09 09                    ..
        ora     #$09                            ; 9D94 09 09                    ..
        ora     #$09                            ; 9D96 09 09                    ..
        ora     #$09                            ; 9D98 09 09                    ..
        .byte   $09                             ; 9D9A 09                       .
L9D9B:  ora     #$09                            ; 9D9B 09 09                    ..
L9D9D:  .byte   $09                             ; 9D9D 09                       .
L9D9E:  ora     #$09                            ; 9D9E 09 09                    ..
        ora     #$09                            ; 9DA0 09 09                    ..
        ora     #$09                            ; 9DA2 09 09                    ..
        ora     #$09                            ; 9DA4 09 09                    ..
        ora     #$09                            ; 9DA6 09 09                    ..
        ora     #$09                            ; 9DA8 09 09                    ..
        ora     #$09                            ; 9DAA 09 09                    ..
        ora     #$09                            ; 9DAC 09 09                    ..
        ora     #$09                            ; 9DAE 09 09                    ..
        ora     #$09                            ; 9DB0 09 09                    ..
        .byte   $09                             ; 9DB2 09                       .
L9DB3:  ora     #$09                            ; 9DB3 09 09                    ..
        ora     #$09                            ; 9DB5 09 09                    ..
        ora     #$09                            ; 9DB7 09 09                    ..
        ora     #$09                            ; 9DB9 09 09                    ..
        ora     #$09                            ; 9DBB 09 09                    ..
        ora     #$09                            ; 9DBD 09 09                    ..
        ora     #$09                            ; 9DBF 09 09                    ..
        ora     #$09                            ; 9DC1 09 09                    ..
        ora     #$09                            ; 9DC3 09 09                    ..
        ora     #$09                            ; 9DC5 09 09                    ..
        ora     #$09                            ; 9DC7 09 09                    ..
        ora     #$09                            ; 9DC9 09 09                    ..
        ora     #$09                            ; 9DCB 09 09                    ..
        ora     #$09                            ; 9DCD 09 09                    ..
        ora     #$09                            ; 9DCF 09 09                    ..
        ora     #$09                            ; 9DD1 09 09                    ..
        ora     #$09                            ; 9DD3 09 09                    ..
        ora     #$09                            ; 9DD5 09 09                    ..
        ora     #$09                            ; 9DD7 09 09                    ..
        ora     #$09                            ; 9DD9 09 09                    ..
        ora     #$09                            ; 9DDB 09 09                    ..
        ora     #$09                            ; 9DDD 09 09                    ..
        ora     #$09                            ; 9DDF 09 09                    ..
        ora     #$09                            ; 9DE1 09 09                    ..
        ora     #$09                            ; 9DE3 09 09                    ..
        ora     #$09                            ; 9DE5 09 09                    ..
        ora     #$09                            ; 9DE7 09 09                    ..
        ora     #$09                            ; 9DE9 09 09                    ..
        ora     #$09                            ; 9DEB 09 09                    ..
        ora     #$09                            ; 9DED 09 09                    ..
        ora     #$09                            ; 9DEF 09 09                    ..
        ora     #$09                            ; 9DF1 09 09                    ..
        ora     #$09                            ; 9DF3 09 09                    ..
        ora     #$09                            ; 9DF5 09 09                    ..
        ora     #$09                            ; 9DF7 09 09                    ..
        ora     #$09                            ; 9DF9 09 09                    ..
        ora     #$09                            ; 9DFB 09 09                    ..
        ora     #$09                            ; 9DFD 09 09                    ..
        ora     #$09                            ; 9DFF 09 09                    ..
        ora     #$09                            ; 9E01 09 09                    ..
        ora     #$09                            ; 9E03 09 09                    ..
        ora     #$09                            ; 9E05 09 09                    ..
        ora     #$09                            ; 9E07 09 09                    ..
        ora     #$09                            ; 9E09 09 09                    ..
        ora     #$09                            ; 9E0B 09 09                    ..
        ora     #$09                            ; 9E0D 09 09                    ..
        ora     #$09                            ; 9E0F 09 09                    ..
        ora     #$09                            ; 9E11 09 09                    ..
        ora     #$09                            ; 9E13 09 09                    ..
        ora     #$09                            ; 9E15 09 09                    ..
        ora     #$09                            ; 9E17 09 09                    ..
        ora     #$09                            ; 9E19 09 09                    ..
        ora     #$09                            ; 9E1B 09 09                    ..
        ora     #$09                            ; 9E1D 09 09                    ..
        ora     #$09                            ; 9E1F 09 09                    ..
        ora     #$09                            ; 9E21 09 09                    ..
        ora     #$09                            ; 9E23 09 09                    ..
        ora     #$09                            ; 9E25 09 09                    ..
        ora     #$09                            ; 9E27 09 09                    ..
        ora     #$09                            ; 9E29 09 09                    ..
        ora     #$09                            ; 9E2B 09 09                    ..
        ora     #$09                            ; 9E2D 09 09                    ..
        ora     #$09                            ; 9E2F 09 09                    ..
        ora     #$09                            ; 9E31 09 09                    ..
        ora     #$09                            ; 9E33 09 09                    ..
        ora     #$09                            ; 9E35 09 09                    ..
        ora     #$09                            ; 9E37 09 09                    ..
        ora     #$09                            ; 9E39 09 09                    ..
        ora     #$09                            ; 9E3B 09 09                    ..
        ora     #$09                            ; 9E3D 09 09                    ..
        ora     #$09                            ; 9E3F 09 09                    ..
        ora     #$09                            ; 9E41 09 09                    ..
        ora     #$09                            ; 9E43 09 09                    ..
        ora     #$09                            ; 9E45 09 09                    ..
        ora     #$09                            ; 9E47 09 09                    ..
        ora     #$09                            ; 9E49 09 09                    ..
        ora     #$09                            ; 9E4B 09 09                    ..
        ora     #$09                            ; 9E4D 09 09                    ..
        ora     #$09                            ; 9E4F 09 09                    ..
        ora     #$09                            ; 9E51 09 09                    ..
        ora     #$09                            ; 9E53 09 09                    ..
        ora     #$09                            ; 9E55 09 09                    ..
        ora     #$09                            ; 9E57 09 09                    ..
        ora     #$09                            ; 9E59 09 09                    ..
        ora     #$09                            ; 9E5B 09 09                    ..
        ora     #$09                            ; 9E5D 09 09                    ..
        ora     #$09                            ; 9E5F 09 09                    ..
        ora     #$09                            ; 9E61 09 09                    ..
        ora     #$09                            ; 9E63 09 09                    ..
        ora     #$09                            ; 9E65 09 09                    ..
        ora     #$09                            ; 9E67 09 09                    ..
        ora     #$09                            ; 9E69 09 09                    ..
        ora     #$09                            ; 9E6B 09 09                    ..
        ora     #$09                            ; 9E6D 09 09                    ..
        ora     #$09                            ; 9E6F 09 09                    ..
        ora     #$09                            ; 9E71 09 09                    ..
        ora     #$09                            ; 9E73 09 09                    ..
        ora     #$09                            ; 9E75 09 09                    ..
        ora     #$09                            ; 9E77 09 09                    ..
        ora     #$09                            ; 9E79 09 09                    ..
        ora     #$09                            ; 9E7B 09 09                    ..
        ora     #$09                            ; 9E7D 09 09                    ..
        ora     #$09                            ; 9E7F 09 09                    ..
        ora     #$09                            ; 9E81 09 09                    ..
        ora     #$09                            ; 9E83 09 09                    ..
        ora     #$09                            ; 9E85 09 09                    ..
        ora     #$09                            ; 9E87 09 09                    ..
        ora     #$09                            ; 9E89 09 09                    ..
        ora     #$09                            ; 9E8B 09 09                    ..
        ora     #$09                            ; 9E8D 09 09                    ..
        ora     #$09                            ; 9E8F 09 09                    ..
        ora     #$09                            ; 9E91 09 09                    ..
        ora     #$09                            ; 9E93 09 09                    ..
        ora     #$09                            ; 9E95 09 09                    ..
        ora     #$09                            ; 9E97 09 09                    ..
        ora     #$09                            ; 9E99 09 09                    ..
        ora     #$09                            ; 9E9B 09 09                    ..
        ora     #$09                            ; 9E9D 09 09                    ..
        ora     #$09                            ; 9E9F 09 09                    ..
        ora     #$09                            ; 9EA1 09 09                    ..
        ora     #$09                            ; 9EA3 09 09                    ..
        ora     #$09                            ; 9EA5 09 09                    ..
        ora     #$09                            ; 9EA7 09 09                    ..
        ora     #$09                            ; 9EA9 09 09                    ..
        ora     #$09                            ; 9EAB 09 09                    ..
        ora     #$09                            ; 9EAD 09 09                    ..
        ora     #$09                            ; 9EAF 09 09                    ..
        ora     #$09                            ; 9EB1 09 09                    ..
        ora     #$09                            ; 9EB3 09 09                    ..
        ora     #$09                            ; 9EB5 09 09                    ..
        ora     #$09                            ; 9EB7 09 09                    ..
        ora     #$09                            ; 9EB9 09 09                    ..
        ora     #$09                            ; 9EBB 09 09                    ..
        ora     #$09                            ; 9EBD 09 09                    ..
        ora     #$09                            ; 9EBF 09 09                    ..
        ora     #$09                            ; 9EC1 09 09                    ..
        ora     #$09                            ; 9EC3 09 09                    ..
        ora     #$09                            ; 9EC5 09 09                    ..
        ora     #$09                            ; 9EC7 09 09                    ..
        ora     #$09                            ; 9EC9 09 09                    ..
        ora     #$09                            ; 9ECB 09 09                    ..
        ora     #$09                            ; 9ECD 09 09                    ..
        ora     #$09                            ; 9ECF 09 09                    ..
        ora     #$09                            ; 9ED1 09 09                    ..
        ora     #$09                            ; 9ED3 09 09                    ..
        ora     #$09                            ; 9ED5 09 09                    ..
        ora     #$09                            ; 9ED7 09 09                    ..
        ora     #$09                            ; 9ED9 09 09                    ..
        ora     #$09                            ; 9EDB 09 09                    ..
        ora     #$09                            ; 9EDD 09 09                    ..
        ora     #$09                            ; 9EDF 09 09                    ..
        ora     #$09                            ; 9EE1 09 09                    ..
        ora     #$09                            ; 9EE3 09 09                    ..
        ora     #$09                            ; 9EE5 09 09                    ..
        ora     #$09                            ; 9EE7 09 09                    ..
        ora     #$09                            ; 9EE9 09 09                    ..
        ora     #$09                            ; 9EEB 09 09                    ..
        ora     #$09                            ; 9EED 09 09                    ..
        ora     #$09                            ; 9EEF 09 09                    ..
        ora     #$09                            ; 9EF1 09 09                    ..
        ora     #$09                            ; 9EF3 09 09                    ..
        ora     #$09                            ; 9EF5 09 09                    ..
        ora     #$09                            ; 9EF7 09 09                    ..
        ora     #$09                            ; 9EF9 09 09                    ..
        ora     #$09                            ; 9EFB 09 09                    ..
        ora     #$09                            ; 9EFD 09 09                    ..
        ora     #$09                            ; 9EFF 09 09                    ..
        ora     #$09                            ; 9F01 09 09                    ..
        ora     #$09                            ; 9F03 09 09                    ..
        ora     #$09                            ; 9F05 09 09                    ..
        ora     #$09                            ; 9F07 09 09                    ..
        ora     #$09                            ; 9F09 09 09                    ..
        ora     #$09                            ; 9F0B 09 09                    ..
        ora     #$09                            ; 9F0D 09 09                    ..
        ora     #$09                            ; 9F0F 09 09                    ..
        ora     #$09                            ; 9F11 09 09                    ..
        ora     #$09                            ; 9F13 09 09                    ..
        ora     #$09                            ; 9F15 09 09                    ..
        ora     #$09                            ; 9F17 09 09                    ..
        ora     #$09                            ; 9F19 09 09                    ..
        ora     #$09                            ; 9F1B 09 09                    ..
        ora     #$09                            ; 9F1D 09 09                    ..
        ora     #$09                            ; 9F1F 09 09                    ..
        ora     #$09                            ; 9F21 09 09                    ..
        ora     #$09                            ; 9F23 09 09                    ..
        ora     #$09                            ; 9F25 09 09                    ..
        ora     #$09                            ; 9F27 09 09                    ..
        ora     #$09                            ; 9F29 09 09                    ..
        ora     #$09                            ; 9F2B 09 09                    ..
        ora     #$09                            ; 9F2D 09 09                    ..
        ora     #$09                            ; 9F2F 09 09                    ..
        ora     #$09                            ; 9F31 09 09                    ..
        ora     #$09                            ; 9F33 09 09                    ..
        ora     #$09                            ; 9F35 09 09                    ..
        ora     #$09                            ; 9F37 09 09                    ..
        ora     #$09                            ; 9F39 09 09                    ..
        ora     #$09                            ; 9F3B 09 09                    ..
        ora     #$09                            ; 9F3D 09 09                    ..
        ora     #$09                            ; 9F3F 09 09                    ..
        ora     #$09                            ; 9F41 09 09                    ..
        ora     #$09                            ; 9F43 09 09                    ..
        ora     #$09                            ; 9F45 09 09                    ..
        ora     #$09                            ; 9F47 09 09                    ..
        ora     #$09                            ; 9F49 09 09                    ..
        ora     #$09                            ; 9F4B 09 09                    ..
        ora     #$09                            ; 9F4D 09 09                    ..
        ora     #$09                            ; 9F4F 09 09                    ..
        ora     #$09                            ; 9F51 09 09                    ..
        ora     #$09                            ; 9F53 09 09                    ..
        ora     #$09                            ; 9F55 09 09                    ..
        ora     #$09                            ; 9F57 09 09                    ..
        ora     #$09                            ; 9F59 09 09                    ..
        ora     #$09                            ; 9F5B 09 09                    ..
        ora     #$09                            ; 9F5D 09 09                    ..
        ora     #$09                            ; 9F5F 09 09                    ..
        ora     #$09                            ; 9F61 09 09                    ..
        ora     #$09                            ; 9F63 09 09                    ..
        ora     #$09                            ; 9F65 09 09                    ..
        ora     #$09                            ; 9F67 09 09                    ..
        ora     #$09                            ; 9F69 09 09                    ..
        ora     #$09                            ; 9F6B 09 09                    ..
        ora     #$09                            ; 9F6D 09 09                    ..
        ora     #$09                            ; 9F6F 09 09                    ..
        ora     #$09                            ; 9F71 09 09                    ..
        ora     #$09                            ; 9F73 09 09                    ..
        ora     #$09                            ; 9F75 09 09                    ..
        ora     #$09                            ; 9F77 09 09                    ..
        ora     #$09                            ; 9F79 09 09                    ..
        ora     #$09                            ; 9F7B 09 09                    ..
        ora     #$09                            ; 9F7D 09 09                    ..
        ora     #$09                            ; 9F7F 09 09                    ..
        ora     #$09                            ; 9F81 09 09                    ..
        ora     #$09                            ; 9F83 09 09                    ..
        ora     #$09                            ; 9F85 09 09                    ..
        ora     #$09                            ; 9F87 09 09                    ..
        ora     #$09                            ; 9F89 09 09                    ..
        ora     #$09                            ; 9F8B 09 09                    ..
        ora     #$09                            ; 9F8D 09 09                    ..
        ora     #$09                            ; 9F8F 09 09                    ..
        ora     #$09                            ; 9F91 09 09                    ..
        ora     #$09                            ; 9F93 09 09                    ..
        ora     #$09                            ; 9F95 09 09                    ..
        ora     #$09                            ; 9F97 09 09                    ..
        ora     #$09                            ; 9F99 09 09                    ..
        ora     #$09                            ; 9F9B 09 09                    ..
        ora     #$09                            ; 9F9D 09 09                    ..
        ora     #$09                            ; 9F9F 09 09                    ..
        ora     #$09                            ; 9FA1 09 09                    ..
        ora     #$09                            ; 9FA3 09 09                    ..
        ora     #$09                            ; 9FA5 09 09                    ..
        ora     #$09                            ; 9FA7 09 09                    ..
        ora     #$09                            ; 9FA9 09 09                    ..
        ora     #$09                            ; 9FAB 09 09                    ..
        ora     #$09                            ; 9FAD 09 09                    ..
        ora     #$09                            ; 9FAF 09 09                    ..
        ora     #$09                            ; 9FB1 09 09                    ..
        ora     #$09                            ; 9FB3 09 09                    ..
        ora     #$09                            ; 9FB5 09 09                    ..
        ora     #$09                            ; 9FB7 09 09                    ..
        ora     #$09                            ; 9FB9 09 09                    ..
        ora     #$09                            ; 9FBB 09 09                    ..
        ora     #$09                            ; 9FBD 09 09                    ..
        ora     #$09                            ; 9FBF 09 09                    ..
        ora     #$09                            ; 9FC1 09 09                    ..
        ora     #$09                            ; 9FC3 09 09                    ..
        ora     #$09                            ; 9FC5 09 09                    ..
        ora     #$09                            ; 9FC7 09 09                    ..
        ora     #$09                            ; 9FC9 09 09                    ..
        ora     #$09                            ; 9FCB 09 09                    ..
        ora     #$09                            ; 9FCD 09 09                    ..
        ora     #$09                            ; 9FCF 09 09                    ..
        ora     #$09                            ; 9FD1 09 09                    ..
        ora     #$09                            ; 9FD3 09 09                    ..
        ora     #$09                            ; 9FD5 09 09                    ..
        ora     #$09                            ; 9FD7 09 09                    ..
        ora     #$09                            ; 9FD9 09 09                    ..
        ora     #$09                            ; 9FDB 09 09                    ..
        ora     #$09                            ; 9FDD 09 09                    ..
        ora     #$09                            ; 9FDF 09 09                    ..
        ora     #$09                            ; 9FE1 09 09                    ..
        ora     #$09                            ; 9FE3 09 09                    ..
        ora     #$09                            ; 9FE5 09 09                    ..
        ora     #$09                            ; 9FE7 09 09                    ..
        ora     #$09                            ; 9FE9 09 09                    ..
        ora     #$09                            ; 9FEB 09 09                    ..
        ora     #$09                            ; 9FED 09 09                    ..
        ora     #$09                            ; 9FEF 09 09                    ..
        ora     #$09                            ; 9FF1 09 09                    ..
        ora     #$09                            ; 9FF3 09 09                    ..
        ora     #$09                            ; 9FF5 09 09                    ..
        ora     #$09                            ; 9FF7 09 09                    ..
        ora     #$09                            ; 9FF9 09 09                    ..
        ora     #$09                            ; 9FFB 09 09                    ..
        ora     #$09                            ; 9FFD 09 09                    ..
        .byte   $09                             ; 9FFF 09                       .
