.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK1C"

; =============================================================================
; BANK $1C (mapped at $8000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
; =============================================================================
L0000           := $0000
L00DF           := $00DF
L4100           := $4100
LA001           := $A001
LA021           := $A021
LA54D           := $A54D
LA56C           := $A56C
LE747           := $E747
LE7A8           := $E7A8
LE999           := $E999
LEA29           := $EA29
LEA34           := $EA34
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR ENGINE — $1C:8000 (called once per frame by the player task)
; For each active entity slot 1-$17 ($A6 = current): if bhv_pc_hi bit 7
; is clear, seed the behavior PC from bhv_pc_lo/hi_tbl[type]; map the
; type's AI bank (bhv_bank_tbl[type] -> $A000: bank $1D generic, or the
; entity's own stage bank), push $805A and jmp (bhv PC) — behaviors run
; as coroutines and rts back here. Types with $8xxx/$9xxx PCs execute
; within this bank itself.
; =============================================================================
bhv_run_all:
        ldx     #$01                            ; 8000 A2 01                    ..
        stx     $A6                             ; 8002 86 A6                    ..
L8004:  ldy     $0300,x                         ; 8004 BC 00 03                 ...
        beq     L8039                           ; 8007 F0 30                    .0
        lda     $05A0,x                         ; 8009 BD A0 05                 ...
        bmi     L801A                           ; 800C 30 0C                    0.
        lda     bhv_pc_lo_tbl,y                         ; 800E B9 C3 88                 ...
        sta     $0588,x                         ; 8011 9D 88 05                 ...
        lda     bhv_pc_hi_tbl,y                         ; 8014 B9 93 89                 ...
        sta     $05A0,x                         ; 8017 9D A0 05                 ...
L801A:  lda     bhv_bank_tbl,y                         ; 801A B9 C3 86                 ...
        cmp     $F6                             ; 801D C5 F6                    ..
        beq     L8026                           ; 801F F0 05                    ..
        sta     $F6                             ; 8021 85 F6                    ..
        jsr     bank_load_shadow                           ; 8023 20 43 FF                  C.
L8026:  lda     $0588,x                         ; 8026 BD 88 05                 ...
        sta     L0000                           ; 8029 85 00                    ..
        lda     $05A0,x                         ; 802B BD A0 05                 ...
        sta     $01                             ; 802E 85 01                    ..
        lda     #$80                            ; 8030 A9 80                    ..
        pha                                     ; 8032 48                       H
        lda     #$5A                            ; 8033 A9 5A                    .Z
        pha                                     ; 8035 48                       H
        jmp     (L0000)                         ; 8036 6C 00 00                 l..

; ----------------------------------------------------------------------------
L8039:  inc     $A6                             ; 8039 E6 A6                    ..
        ldx     $A6                             ; 803B A6 A6                    ..
        cpx     #$18                            ; 803D E0 18                    ..
        beq     L8044                           ; 803F F0 03                    ..
        jmp     L8004                           ; 8041 4C 04 80                 L..

; ----------------------------------------------------------------------------
L8044:  lda     $36                             ; 8044 A5 36                    .6
        beq     L8056                           ; 8046 F0 0E                    ..
        lda     $05B8                           ; 8048 AD B8 05                 ...
        bne     L8056                           ; 804B D0 09                    ..
        lda     $30                             ; 804D A5 30                    .0
        cmp     #$06                            ; 804F C9 06                    ..
        bcs     L8056                           ; 8051 B0 03                    ..
        jsr     L82A5                           ; 8053 20 A5 82                  ..
L8056:  lda     #$00                            ; 8056 A9 00                    ..
        sta     $36                             ; 8058 85 36                    .6
        rts                                     ; 805A 60                       `

; ----------------------------------------------------------------------------
        cpx     #$05                            ; 805B E0 05                    ..
        bcc     L8082                           ; 805D 90 23                    .#
        lda     $30                             ; 805F A5 30                    .0
        cmp     #$06                            ; 8061 C9 06                    ..
        bcs     L8073                           ; 8063 B0 0E                    ..
        lda     $0558                           ; 8065 AD 58 05                 .X.
        cmp     #$B0                            ; 8068 C9 B0                    ..
        bne     L8073                           ; 806A D0 07                    ..
        jsr     entity_player_collide                           ; 806C 20 87 EF                  ..
        bcs     L8082                           ; 806F B0 11                    ..
        bcc     L8078                           ; 8071 90 05                    ..
L8073:  jsr     entity_hitbox_check                           ; 8073 20 F8 EF                  ..
        bcs     L8082                           ; 8076 B0 0A                    ..
L8078:  lda     $0408,x                         ; 8078 BD 08 04                 ...
        and     #$40                            ; 807B 29 40                    )@
        sta     L0000                           ; 807D 85 00                    ..
        jsr     L809D                           ; 807F 20 9D 80                  ..
L8082:  lda     $0408,x                         ; 8082 BD 08 04                 ...
        bpl     L809A                           ; 8085 10 13                    ..
        lda     $05B8                           ; 8087 AD B8 05                 ...
        bne     L809A                           ; 808A D0 0E                    ..
        lda     $30                             ; 808C A5 30                    .0
        cmp     #$06                            ; 808E C9 06                    ..
        bcs     L809A                           ; 8090 B0 08                    ..
        jsr     entity_player_collide                           ; 8092 20 87 EF                  ..
        bcs     L809A                           ; 8095 B0 03                    ..
        jsr     L82C3                           ; 8097 20 C3 82                  ..
L809A:  jmp     L8039                           ; 809A 4C 39 80                 L9.

; ----------------------------------------------------------------------------
L809D:  lda     $F6                             ; 809D A5 F6                    ..
        pha                                     ; 809F 48                       H
        lda     $32                             ; 80A0 A5 32                    .2
        sta     $F6                             ; 80A2 85 F6                    ..
        cmp     #$0C                            ; 80A4 C9 0C                    ..
        bne     L80B2                           ; 80A6 D0 0A                    ..
        lda     $10                             ; 80A8 A5 10                    ..
        cmp     #$01                            ; 80AA C9 01                    ..
        beq     L80B2                           ; 80AC F0 04                    ..
        lda     #$00                            ; 80AE A9 00                    ..
        sta     $F6                             ; 80B0 85 F6                    ..
L80B2:  jsr     bank_load_shadow                           ; 80B2 20 43 FF                  C.
        lda     $32                             ; 80B5 A5 32                    .2
        cmp     #$01                            ; 80B7 C9 01                    ..
        beq     L80BF                           ; 80B9 F0 04                    ..
        cmp     #$09                            ; 80BB C9 09                    ..
        bne     L80DB                           ; 80BD D0 1C                    ..
L80BF:  ldy     $0300,x                         ; 80BF BC 00 03                 ...
        lda     $A800,y                         ; 80C2 B9 00 A8                 ...
        bpl     L80DB                           ; 80C5 10 14                    ..
        jsr     entity_wipe_x                           ; 80C7 20 C4 F2                  ..
        lda     $32                             ; 80CA A5 32                    .2
        cmp     #$09                            ; 80CC C9 09                    ..
        bne     L80D8                           ; 80CE D0 08                    ..
        jsr     L8244                           ; 80D0 20 44 82                  D.
        ldy     $10                             ; 80D3 A4 10                    ..
        jsr     entity_wipe_y                           ; 80D5 20 FE F2                  ..
L80D8:  jmp     L8225                           ; 80D8 4C 25 82                 L%.

; ----------------------------------------------------------------------------
L80DB:  ldy     $0300,x                         ; 80DB BC 00 03                 ...
        lda     $A800,y                         ; 80DE B9 00 A8                 ...
        and     #$7F                            ; 80E1 29 7F                    ).
        ora     L0000                           ; 80E3 05 00                    ..
        beq     L80D8                           ; 80E5 F0 F1                    ..
        lda     $32                             ; 80E7 A5 32                    .2
        cmp     #$09                            ; 80E9 C9 09                    ..
        bne     L80F3                           ; 80EB D0 06                    ..
        jsr     L8244                           ; 80ED 20 44 82                  D.
        ldy     $0300,x                         ; 80F0 BC 00 03                 ...
L80F3:  lda     L0000                           ; 80F3 A5 00                    ..
        beq     L8113                           ; 80F5 F0 1C                    ..
        lda     $32                             ; 80F7 A5 32                    .2
        bne     L810C                           ; 80F9 D0 11                    ..
        lda     $A800,y                         ; 80FB B9 00 A8                 ...
        beq     L8113                           ; 80FE F0 13                    ..
        lda     $5B                             ; 8100 A5 5B                    .[
        cmp     #$0E                            ; 8102 C9 0E                    ..
        lda     #$01                            ; 8104 A9 01                    ..
        bcc     L8176                           ; 8106 90 6E                    .n
        lda     #$03                            ; 8108 A9 03                    ..
        bne     L8176                           ; 810A D0 6A                    .j
L810C:  lda     $A800,y                         ; 810C B9 00 A8                 ...
        and     #$7F                            ; 810F 29 7F                    ).
        bne     L8176                           ; 8111 D0 63                    .c
L8113:  ldy     $10                             ; 8113 A4 10                    ..
        lda     $32                             ; 8115 A5 32                    .2
        cmp     #$01                            ; 8117 C9 01                    ..
        beq     L8164                           ; 8119 F0 49                    .I
        cmp     #$07                            ; 811B C9 07                    ..
        beq     L8161                           ; 811D F0 42                    .B
        cmp     #$08                            ; 811F C9 08                    ..
        beq     L8161                           ; 8121 F0 3E                    .>
        cmp     #$04                            ; 8123 C9 04                    ..
        beq     L816A                           ; 8125 F0 43                    .C
        lda     $0300,y                         ; 8127 B9 00 03                 ...
        cmp     #$79                            ; 812A C9 79                    .y
        beq     L8167                           ; 812C F0 39                    .9
        lda     #$1E                            ; 812E A9 1E                    ..
        jsr     queue_sound                           ; 8130 20 5D EC                  ].
        jsr     entity_wipe_y                           ; 8133 20 FE F2                  ..
        lda     #$46                            ; 8136 A9 46                    .F
        sta     $0300,y                         ; 8138 99 00 03                 ...
        lda     $0420,y                         ; 813B B9 20 04                 . .
        eor     #$03                            ; 813E 49 03                    I.
        ora     #$08                            ; 8140 09 08                    ..
        sta     $0420,y                         ; 8142 99 20 04                 . .
        lda     #$00                            ; 8145 A9 00                    ..
        sta     $03A8,y                         ; 8147 99 A8 03                 ...
        sta     $03D8,y                         ; 814A 99 D8 03                 ...
        lda     #$04                            ; 814D A9 04                    ..
        sta     $03C0,y                         ; 814F 99 C0 03                 ...
        sta     $03F0,y                         ; 8152 99 F0 03                 ...
        lda     $0558,y                         ; 8155 B9 58 05                 .X.
        cmp     #$A9                            ; 8158 C9 A9                    ..
        bne     L8161                           ; 815A D0 05                    ..
        lda     #$A8                            ; 815C A9 A8                    ..
        jsr     entity_init_subtype_y                           ; 815E 20 E9 EA                  ..
L8161:  jmp     L8225                           ; 8161 4C 25 82                 L%.

; ----------------------------------------------------------------------------
L8164:  jmp     L81FF                           ; 8164 4C FF 81                 L..

; ----------------------------------------------------------------------------
L8167:  jmp     L821B                           ; 8167 4C 1B 82                 L..

; ----------------------------------------------------------------------------
L816A:  ldy     $10                             ; 816A A4 10                    ..
        lda     $0300,y                         ; 816C B9 00 03                 ...
        cmp     #$72                            ; 816F C9 72                    .r
        bne     L8161                           ; 8171 D0 EE                    ..
        jmp     L81FF                           ; 8173 4C FF 81                 L..

; ----------------------------------------------------------------------------
L8176:  and     #$7F                            ; 8176 29 7F                    ).
        sta     $11                             ; 8178 85 11                    ..
        lda     $05B8,x                         ; 817A BD B8 05                 ...
        bpl     L8181                           ; 817D 10 02                    ..
        and     #$7F                            ; 817F 29 7F                    ).
L8181:  bne     L81E0                           ; 8181 D0 5D                    .]
        lda     $05B8,x                         ; 8183 BD B8 05                 ...
        and     #$80                            ; 8186 29 80                    ).
        lda     #$08                            ; 8188 A9 08                    ..
        sta     $05B8,x                         ; 818A 9D B8 05                 ...
        cpx     $56                             ; 818D E4 56                    .V
        bne     L819F                           ; 818F D0 0E                    ..
        lda     $2F                             ; 8191 A5 2F                    ./
        bpl     L819F                           ; 8193 10 0A                    ..
        lda     $05B8,x                         ; 8195 BD B8 05                 ...
        and     #$80                            ; 8198 29 80                    ).
        ora     #$30                            ; 819A 09 30                    .0
        sta     $05B8,x                         ; 819C 9D B8 05                 ...
L819F:  lda     #$2A                            ; 819F A9 2A                    .*
        jsr     queue_sound                           ; 81A1 20 5D EC                  ].
        lda     $0450,x                         ; 81A4 BD 50 04                 .P.
        sta     $12                             ; 81A7 85 12                    ..
        sec                                     ; 81A9 38                       8
        sbc     $11                             ; 81AA E5 11                    ..
        sta     $0450,x                         ; 81AC 9D 50 04                 .P.
        beq     L81B3                           ; 81AF F0 02                    ..
        bcs     L81E0                           ; 81B1 B0 2D                    .-
L81B3:  lda     #$00                            ; 81B3 A9 00                    ..
        sta     $0450,x                         ; 81B5 9D 50 04                 .P.
        lda     L87C3,y                         ; 81B8 B9 C3 87                 ...
        bne     L822C                           ; 81BB D0 6F                    .o
        lda     $32                             ; 81BD A5 32                    .2
        cmp     #$07                            ; 81BF C9 07                    ..
        bne     L81C6                           ; 81C1 D0 03                    ..
        jmp     L8257                           ; 81C3 4C 57 82                 LW.

; ----------------------------------------------------------------------------
L81C6:  jsr     entity_wipe_x                           ; 81C6 20 C4 F2                  ..
        lda     #$2B                            ; 81C9 A9 2B                    .+
        jsr     queue_sound                           ; 81CB 20 5D EC                  ].
        lda     #$B8                            ; 81CE A9 B8                    ..
        sta     $0300,x                         ; 81D0 9D 00 03                 ...
        lda     #$42                            ; 81D3 A9 42                    .B
        jsr     entity_set_subtype                           ; 81D5 20 98 EA                  ..
        jsr     entity_stop_y                           ; 81D8 20 1E EA                  ..
        lda     #$00                            ; 81DB A9 00                    ..
        sta     $0528,x                         ; 81DD 9D 28 05                 .(.
L81E0:  ldy     $10                             ; 81E0 A4 10                    ..
        lda     $32                             ; 81E2 A5 32                    .2
        cmp     #$07                            ; 81E4 C9 07                    ..
        beq     L8225                           ; 81E6 F0 3D                    .=
        cmp     #$08                            ; 81E8 C9 08                    ..
        beq     L8225                           ; 81EA F0 39                    .9
        lda     $0300,y                         ; 81EC B9 00 03                 ...
        cmp     #$79                            ; 81EF C9 79                    .y
        beq     L8218                           ; 81F1 F0 25                    .%
        lda     $5B                             ; 81F3 A5 5B                    .[
        cmp     #$0E                            ; 81F5 C9 0E                    ..
        bne     L81FF                           ; 81F7 D0 06                    ..
        lda     $12                             ; 81F9 A5 12                    ..
        cmp     #$04                            ; 81FB C9 04                    ..
        bcc     L8225                           ; 81FD 90 26                    .&
L81FF:  lda     $0300,y                         ; 81FF B9 00 03                 ...
        pha                                     ; 8202 48                       H
        jsr     entity_wipe_y                           ; 8203 20 FE F2                  ..
        pla                                     ; 8206 68                       h
        cmp     #$72                            ; 8207 C9 72                    .r
        bne     L8215                           ; 8209 D0 0A                    ..
        lda     #$C2                            ; 820B A9 C2                    ..
        sta     $0300,y                         ; 820D 99 00 03                 ...
        lda     #$42                            ; 8210 A9 42                    .B
        jsr     entity_init_subtype_y                           ; 8212 20 E9 EA                  ..
L8215:  jmp     L8225                           ; 8215 4C 25 82                 L%.

; ----------------------------------------------------------------------------
L8218:  jsr     L8288                           ; 8218 20 88 82                  ..
L821B:  lda     #$C8                            ; 821B A9 C8                    ..
        sta     $0588,y                         ; 821D 99 88 05                 ...
        lda     #$B6                            ; 8220 A9 B6                    ..
        sta     $05A0,y                         ; 8222 99 A0 05                 ...
L8225:  pla                                     ; 8225 68                       h
        sta     $F6                             ; 8226 85 F6                    ..
        jsr     bank_load_shadow                           ; 8228 20 43 FF                  C.
        rts                                     ; 822B 60                       `

; ----------------------------------------------------------------------------
L822C:  pha                                     ; 822C 48                       H
        lda     $0450,x                         ; 822D BD 50 04                 .P.
        pha                                     ; 8230 48                       H
        jsr     entity_wipe_x                           ; 8231 20 C4 F2                  ..
        pla                                     ; 8234 68                       h
        sta     $0450,x                         ; 8235 9D 50 04                 .P.
        pla                                     ; 8238 68                       h
        sta     $0300,x                         ; 8239 9D 00 03                 ...
        lda     #$00                            ; 823C A9 00                    ..
        sta     $0408,x                         ; 823E 9D 08 04                 ...
        jmp     L81E0                           ; 8241 4C E0 81                 L..

; ----------------------------------------------------------------------------
L8244:  ldy     $10                             ; 8244 A4 10                    ..
        lda     $03C0,y                         ; 8246 B9 C0 03                 ...
        bne     L8256                           ; 8249 D0 0B                    ..
        lda     $B9                             ; 824B A5 B9                    ..
        sec                                     ; 824D 38                       8
        sbc     #$03                            ; 824E E9 03                    ..
        bmi     L8254                           ; 8250 30 02                    0.
        lda     #$80                            ; 8252 A9 80                    ..
L8254:  sta     $B9                             ; 8254 85 B9                    ..
L8256:  rts                                     ; 8256 60                       `

; ----------------------------------------------------------------------------
L8257:  lda     $0300,x                         ; 8257 BD 00 03                 ...
        pha                                     ; 825A 48                       H
        lda     $0438,x                         ; 825B BD 38 04                 .8.
        pha                                     ; 825E 48                       H
        jsr     entity_wipe_x                           ; 825F 20 C4 F2                  ..
        pla                                     ; 8262 68                       h
        sta     $0438,x                         ; 8263 9D 38 04                 .8.
        pla                                     ; 8266 68                       h
        tay                                     ; 8267 A8                       .
        lda     #$14                            ; 8268 A9 14                    ..
        sta     $0468,x                         ; 826A 9D 68 04                 .h.
        lda     #$00                            ; 826D A9 00                    ..
        sta     entity_stop_y,x                         ; 826F 9D 1E EA                 ...
        sta     $03F0,x                         ; 8272 9D F0 03                 ...
        sta     $0408,x                         ; 8275 9D 08 04                 ...
        lda     $E33B,y                         ; 8278 B9 3B E3                 .;.
        sec                                     ; 827B 38                       8
        sbc     #$12                            ; 827C E9 12                    ..
        lsr     a                               ; 827E 4A                       J
        clc                                     ; 827F 18                       .
        adc     #$C6                            ; 8280 69 C6                    i.
        sta     $0300,x                         ; 8282 9D 00 03                 ...
        jmp     L8225                           ; 8285 4C 25 82                 L%.

; ----------------------------------------------------------------------------
L8288:  lda     $05B8,x                         ; 8288 BD B8 05                 ...
        beq     L8295                           ; 828B F0 08                    ..
        cmp     #$08                            ; 828D C9 08                    ..
        beq     L8295                           ; 828F F0 04                    ..
        cmp     #$30                            ; 8291 C9 30                    .0
        bne     L82A4                           ; 8293 D0 0F                    ..
L8295:  lda     $BC                             ; 8295 A5 BC                    ..
        and     #$7F                            ; 8297 29 7F                    ).
        sec                                     ; 8299 38                       8
        sbc     #$02                            ; 829A E9 02                    ..
        bcs     L82A0                           ; 829C B0 02                    ..
        lda     #$00                            ; 829E A9 00                    ..
L82A0:  ora     #$80                            ; 82A0 09 80                    ..
        sta     $BC                             ; 82A2 85 BC                    ..
L82A4:  rts                                     ; 82A4 60                       `

; ----------------------------------------------------------------------------
L82A5:  lda     $17                             ; 82A5 A5 17                    ..
        and     #$40                            ; 82A7 29 40                    )@
        bne     L82A4                           ; 82A9 D0 F9                    ..
        lda     $36                             ; 82AB A5 36                    .6
        cmp     #$F0                            ; 82AD C9 F0                    ..
        beq     L82B5                           ; 82AF F0 04                    ..
        dec     $B0                             ; 82B1 C6 B0                    ..
        bmi     L82E1                           ; 82B3 30 2C                    0,
L82B5:  jmp     L8332                           ; 82B5 4C 32 83                 L2.

; ----------------------------------------------------------------------------
L82B8:  lda     $05B8                           ; 82B8 AD B8 05                 ...
        bne     L8331                           ; 82BB D0 74                    .t
        lda     $30                             ; 82BD A5 30                    .0
        cmp     #$06                            ; 82BF C9 06                    ..
        bcs     L8331                           ; 82C1 B0 6E                    .n
L82C3:  jsr     L83FC                           ; 82C3 20 FC 83                  ..
        beq     L8331                           ; 82C6 F0 69                    .i
        lda     $17                             ; 82C8 A5 17                    ..
        and     #$40                            ; 82CA 29 40                    )@
        bne     L8331                           ; 82CC D0 63                    .c
        ldy     $0300,x                         ; 82CE BC 00 03                 ...
        lda     $B0                             ; 82D1 A5 B0                    ..
        and     #$1F                            ; 82D3 29 1F                    ).
        sec                                     ; 82D5 38                       8
        sbc     L85C3,y                         ; 82D6 F9 C3 85                 ...
        beq     L8332                           ; 82D9 F0 57                    .W
        bcc     L8332                           ; 82DB 90 55                    .U
        ora     #$80                            ; 82DD 09 80                    ..
        sta     $B0                             ; 82DF 85 B0                    ..
L82E1:  lda     #$04                            ; 82E1 A9 04                    ..
        ldy     $30                             ; 82E3 A4 30                    .0
        cpy     #$02                            ; 82E5 C0 02                    ..
        beq     L82F1                           ; 82E7 F0 08                    ..
        lda     #$00                            ; 82E9 A9 00                    ..
        cpy     #$04                            ; 82EB C0 04                    ..
        beq     L82F1                           ; 82ED F0 02                    ..
        ldy     #$00                            ; 82EF A0 00                    ..
L82F1:  sty     $0498                           ; 82F1 8C 98 04                 ...
        sta     $04B0                           ; 82F4 8D B0 04                 ...
        ldx     #$00                            ; 82F7 A2 00                    ..
        stx     $54                             ; 82F9 86 54                    .T
        stx     $33                             ; 82FB 86 33                    .3
        stx     $34                             ; 82FD 86 34                    .4
        stx     $38                             ; 82FF 86 38                    .8
        lda     #$06                            ; 8301 A9 06                    ..
        sta     $30                             ; 8303 85 30                    .0
        lda     #$11                            ; 8305 A9 11                    ..
        cpy     #$04                            ; 8307 C0 04                    ..
        bne     L830D                           ; 8309 D0 02                    ..
        lda     #$21                            ; 830B A9 21                    .!
L830D:  jsr     entity_set_subtype                           ; 830D 20 98 EA                  ..
        jsr     entity_stop_y                           ; 8310 20 1E EA                  ..
        jsr     player_palette_load                           ; 8313 20 BF F3                  ..
        lda     $0305                           ; 8316 AD 05 03                 ...
        bne     L832A                           ; 8319 D0 0F                    ..
        lda     #$12                            ; 831B A9 12                    ..
        ldy     #$05                            ; 831D A0 05                    ..
        jsr     entity_init_pos                           ; 831F 20 A4 EA                  ..
        stx     $040D                           ; 8322 8E 0D 04                 ...
        lda     #$01                            ; 8325 A9 01                    ..
        sta     $0305                           ; 8327 8D 05 03                 ...
L832A:  ldx     $A6                             ; 832A A6 A6                    ..
        lda     #$1C                            ; 832C A9 1C                    ..
        jsr     queue_sound                           ; 832E 20 5D EC                  ].
L8331:  rts                                     ; 8331 60                       `

; ----------------------------------------------------------------------------
L8332:  lda     #$F0                            ; 8332 A9 F0                    ..
        jsr     queue_sound_param                           ; 8334 20 5B EC                  [.
        lda     #$1D                            ; 8337 A9 1D                    ..
        jsr     queue_sound                           ; 8339 20 5D EC                  ].
        lda     #$80                            ; 833C A9 80                    ..
        sta     $B0                             ; 833E 85 B0                    ..
        lda     #$00                            ; 8340 A9 00                    ..
        sta     $54                             ; 8342 85 54                    .T
        jsr     player_palette_load                           ; 8344 20 BF F3                  ..
        lda     $0528                           ; 8347 AD 28 05                 .(.
        and     #$DF                            ; 834A 29 DF                    ).
        ora     #$04                            ; 834C 09 04                    ..
        sta     $0528                           ; 834E 8D 28 05                 .(.
        lda     #$07                            ; 8351 A9 07                    ..
        sta     $30                             ; 8353 85 30                    .0
        lda     #$2C                            ; 8355 A9 2C                    .,
        sta     $0468                           ; 8357 8D 68 04                 .h.
        lda     #$01                            ; 835A A9 01                    ..
        sta     $0480                           ; 835C 8D 80 04                 ...
        lda     #$0F                            ; 835F A9 0F                    ..
        sta     $11                             ; 8361 85 11                    ..
L8363:  ldy     #$17                            ; 8363 A0 17                    ..
L8365:  lda     $0300,y                         ; 8365 B9 00 03                 ...
        beq     L8371                           ; 8368 F0 07                    ..
        dey                                     ; 836A 88                       .
        cpy     #$04                            ; 836B C0 04                    ..
        bne     L8365                           ; 836D D0 F6                    ..
        beq     L83B9                           ; 836F F0 48                    .H
L8371:  ldx     #$00                            ; 8371 A2 00                    ..
        lda     #$19                            ; 8373 A9 19                    ..
        jsr     entity_init_pos                           ; 8375 20 A4 EA                  ..
        lda     #$80                            ; 8378 A9 80                    ..
        sta     $0528,y                         ; 837A 99 28 05                 .(.
        lda     #$03                            ; 837D A9 03                    ..
        sta     $0300,y                         ; 837F 99 00 03                 ...
        lda     #$00                            ; 8382 A9 00                    ..
        sta     $0408,y                         ; 8384 99 08 04                 ...
        sta     $0468,y                         ; 8387 99 68 04                 .h.
        sta     $0480,y                         ; 838A 99 80 04                 ...
        ldx     $11                             ; 838D A6 11                    ..
        lda     L83BC,x                         ; 838F BD BC 83                 ...
        sta     $03A8,y                         ; 8392 99 A8 03                 ...
        lda     L83CC,x                         ; 8395 BD CC 83                 ...
        sta     $03C0,y                         ; 8398 99 C0 03                 ...
        bpl     L83A2                           ; 839B 10 05                    ..
        lda     #$FF                            ; 839D A9 FF                    ..
        sta     $0468,y                         ; 839F 99 68 04                 .h.
L83A2:  lda     L83DC,x                         ; 83A2 BD DC 83                 ...
        sta     $03D8,y                         ; 83A5 99 D8 03                 ...
        lda     L83EC,x                         ; 83A8 BD EC 83                 ...
        sta     $03F0,y                         ; 83AB 99 F0 03                 ...
        bpl     L83B5                           ; 83AE 10 05                    ..
        lda     #$FF                            ; 83B0 A9 FF                    ..
        sta     $0480,y                         ; 83B2 99 80 04                 ...
L83B5:  dec     $11                             ; 83B5 C6 11                    ..
        bpl     L8363                           ; 83B7 10 AA                    ..
L83B9:  ldx     $A6                             ; 83B9 A6 A6                    ..
        rts                                     ; 83BB 60                       `

; ----------------------------------------------------------------------------
L83BC:  brk                                     ; 83BC 00                       .
        .byte   $0F                             ; 83BD 0F                       .
        .byte   $80                             ; 83BE 80                       .
        .byte   $0F                             ; 83BF 0F                       .
        brk                                     ; 83C0 00                       .
        sbc     ($80),y                         ; 83C1 F1 80                    ..
        sbc     (L0000),y                       ; 83C3 F1 00                    ..
        .byte   $87                             ; 83C5 87                       .
        cpy     #$87                            ; 83C6 C0 87                    ..
        brk                                     ; 83C8 00                       .
        adc     $7940,y                         ; 83C9 79 40 79                 y@y
L83CC:  brk                                     ; 83CC 00                       .
        ora     ($01,x)                         ; 83CD 01 01                    ..
        ora     (L0000,x)                       ; 83CF 01 00                    ..
        inc     $FEFE,x                         ; 83D1 FE FE FE                 ...
        brk                                     ; 83D4 00                       .
        brk                                     ; 83D5 00                       .
        brk                                     ; 83D6 00                       .
        brk                                     ; 83D7 00                       .
        brk                                     ; 83D8 00                       .
        .byte   $FF                             ; 83D9 FF                       .
        .byte   $FF                             ; 83DA FF                       .
        .byte   $FF                             ; 83DB FF                       .
L83DC:  .byte   $80                             ; 83DC 80                       .
        sbc     (L0000),y                       ; 83DD F1 00                    ..
        .byte   $0F                             ; 83DF 0F                       .
        .byte   $80                             ; 83E0 80                       .
        .byte   $0F                             ; 83E1 0F                       .
        brk                                     ; 83E2 00                       .
        sbc     ($40),y                         ; 83E3 F1 40                    .@
        adc     L8700,y                         ; 83E5 79 00 87                 y..
        cpy     #$87                            ; 83E8 C0 87                    ..
        brk                                     ; 83EA 00                       .
        .byte   $79                             ; 83EB 79                       y
L83EC:  inc     a:$FE,x                         ; 83EC FE FE 00                 ...
        ora     ($01,x)                         ; 83EF 01 01                    ..
        ora     (L0000,x)                       ; 83F1 01 00                    ..
        inc     $FFFF,x                         ; 83F3 FE FF FF                 ...
        brk                                     ; 83F6 00                       .
        brk                                     ; 83F7 00                       .
        brk                                     ; 83F8 00                       .
        brk                                     ; 83F9 00                       .
        brk                                     ; 83FA 00                       .
        .byte   $FF                             ; 83FB FF                       .
L83FC:  lda     $0558                           ; 83FC AD 58 05                 .X.
        cmp     #$B0                            ; 83FF C9 B0                    ..
        bne     L841F                           ; 8401 D0 1C                    ..
        lda     $F6                             ; 8403 A5 F6                    ..
        pha                                     ; 8405 48                       H
        lda     $32                             ; 8406 A5 32                    .2
        sta     $F6                             ; 8408 85 F6                    ..
        jsr     bank_load_shadow                           ; 840A 20 43 FF                  C.
        ldy     $0300,x                         ; 840D BC 00 03                 ...
        lda     $A800,y                         ; 8410 B9 00 A8                 ...
        sta     $10                             ; 8413 85 10                    ..
        pla                                     ; 8415 68                       h
        sta     $F6                             ; 8416 85 F6                    ..
        jsr     bank_load_shadow                           ; 8418 20 43 FF                  C.
        lda     $10                             ; 841B A5 10                    ..
        and     #$80                            ; 841D 29 80                    ).
L841F:  rts                                     ; 841F 60                       `

; ----------------------------------------------------------------------------
        sec                                     ; 8420 38                       8
        lda     $0468,x                         ; 8421 BD 68 04                 .h.
        bmi     L8477                           ; 8424 30 51                    0Q
        lda     $9D                             ; 8426 A5 9D                    ..
        and     #$03                            ; 8428 29 03                    ).
        bne     L8476                           ; 842A D0 4A                    .J
        ldy     #$13                            ; 842C A0 13                    ..
L842E:  cpy     #$0C                            ; 842E C0 0C                    ..
        bcc     L8445                           ; 8430 90 13                    ..
        lda     (L0000),y                       ; 8432 B1 00                    ..
        sec                                     ; 8434 38                       8
        sbc     $0468,x                         ; 8435 FD 68 04                 .h.
        bcs     L843C                           ; 8438 B0 02                    ..
        lda     #$0F                            ; 843A A9 0F                    ..
L843C:  sta     $060C,y                         ; 843C 99 0C 06                 ...
        sta     $062C,y                         ; 843F 99 2C 06                 .,.
        jmp     L8455                           ; 8442 4C 55 84                 LU.

; ----------------------------------------------------------------------------
L8445:  lda     (L0000),y                       ; 8445 B1 00                    ..
        sec                                     ; 8447 38                       8
        sbc     $0468,x                         ; 8448 FD 68 04                 .h.
        bcs     L844F                           ; 844B B0 02                    ..
        lda     #$0F                            ; 844D A9 0F                    ..
L844F:  sta     $0604,y                         ; 844F 99 04 06                 ...
        sta     $0624,y                         ; 8452 99 24 06                 .$.
L8455:  dey                                     ; 8455 88                       .
        bpl     L842E                           ; 8456 10 D6                    ..
        sty     $18                             ; 8458 84 18                    ..
        lda     $0468,x                         ; 845A BD 68 04                 .h.
        sec                                     ; 845D 38                       8
        sbc     #$10                            ; 845E E9 10                    ..
        sta     $0468,x                         ; 8460 9D 68 04                 .h.
        bcs     L8476                           ; 8463 B0 11                    ..
        ldy     #$17                            ; 8465 A0 17                    ..
L8467:  lda     $0528,y                         ; 8467 B9 28 05                 .(.
        and     #$FB                            ; 846A 29 FB                    ).
        sta     $0528,y                         ; 846C 99 28 05                 .(.
        dey                                     ; 846F 88                       .
        cpy     #$07                            ; 8470 C0 07                    ..
        bne     L8467                           ; 8472 D0 F3                    ..
        beq     L8477                           ; 8474 F0 01                    ..
L8476:  rts                                     ; 8476 60                       `

; ----------------------------------------------------------------------------
L8477:  lda     #$00                            ; 8477 A9 00                    ..
        sta     $0570,x                         ; 8479 9D 70 05                 .p.
        lda     $2F                             ; 847C A5 2F                    ./
        bne     L8489                           ; 847E D0 09                    ..
        sta     $0450,x                         ; 8480 9D 50 04                 .P.
        lda     #$80                            ; 8483 A9 80                    ..
        sta     $2F                             ; 8485 85 2F                    ./
        stx     $56                             ; 8487 86 56                    .V
L8489:  lda     $9D                             ; 8489 A5 9D                    ..
        and     #$03                            ; 848B 29 03                    ).
        bne     L84A4                           ; 848D D0 15                    ..
        lda     #$26                            ; 848F A9 26                    .&
        jsr     queue_sound                           ; 8491 20 5D EC                  ].
        inc     $0450,x                         ; 8494 FE 50 04                 .P.
        lda     $0450,x                         ; 8497 BD 50 04                 .P.
        cmp     #$1C                            ; 849A C9 1C                    ..
        bne     L84A4                           ; 849C D0 06                    ..
        lda     #$00                            ; 849E A9 00                    ..
        sta     $30                             ; 84A0 85 30                    .0
        clc                                     ; 84A2 18                       .
        rts                                     ; 84A3 60                       `

; ----------------------------------------------------------------------------
L84A4:  sec                                     ; 84A4 38                       8
        rts                                     ; 84A5 60                       `

; ----------------------------------------------------------------------------
        sec                                     ; 84A6 38                       8
        lda     $30                             ; 84A7 A5 30                    .0
        bne     L84BE                           ; 84A9 D0 13                    ..
        lda     #$19                            ; 84AB A9 19                    ..
        sta     $30                             ; 84AD 85 30                    .0
        lda     #$0A                            ; 84AF A9 0A                    ..
        ldy     $0300,x                         ; 84B1 BC 00 03                 ...
        cpy     #$AA                            ; 84B4 C0 AA                    ..
        bne     L84BA                           ; 84B6 D0 02                    ..
        lda     #$16                            ; 84B8 A9 16                    ..
L84BA:  jsr     queue_sound_param                           ; 84BA 20 5B EC                  [.
        clc                                     ; 84BD 18                       .
L84BE:  rts                                     ; 84BE 60                       `

; ----------------------------------------------------------------------------
        lda     #$F0                            ; 84BF A9 F0                    ..
        jsr     queue_sound_param                           ; 84C1 20 5B EC                  [.
        stx     L0000                           ; 84C4 86 00                    ..
        ldy     #$17                            ; 84C6 A0 17                    ..
L84C8:  cpy     L0000                           ; 84C8 C4 00                    ..
        beq     L84CF                           ; 84CA F0 03                    ..
        jsr     entity_wipe_y                           ; 84CC 20 FE F2                  ..
L84CF:  dey                                     ; 84CF 88                       .
        cpy     #$07                            ; 84D0 C0 07                    ..
        bne     L84C8                           ; 84D2 D0 F4                    ..
        rts                                     ; 84D4 60                       `

; ----------------------------------------------------------------------------
        sta     $9D                             ; 84D5 85 9D                    ..
        sta     $78                             ; 84D7 85 78                    .x
        sta     $79                             ; 84D9 85 79                    .y
        sta     $05F3                           ; 84DB 8D F3 05                 ...
        sta     $05D1                           ; 84DE 8D D1 05                 ...
        sta     $05D2                           ; 84E1 8D D2 05                 ...
        sta     $05D0                           ; 84E4 8D D0 05                 ...
        lda     #$23                            ; 84E7 A9 23                    .#
        sta     $7A                             ; 84E9 85 7A                    .z
        lda     #$00                            ; 84EB A9 00                    ..
        sta     $7B                             ; 84ED 85 7B                    .{
        lda     #$BF                            ; 84EF A9 BF                    ..
        sta     $9B                             ; 84F1 85 9B                    ..
        lda     #$05                            ; 84F3 A9 05                    ..
        sta     $99                             ; 84F5 85 99                    ..
        lda     #$02                            ; 84F7 A9 02                    ..
        sta     $FD                             ; 84F9 85 FD                    ..
        rts                                     ; 84FB 60                       `

; ----------------------------------------------------------------------------
L84FC:  lda     $0528,x                         ; 84FC BD 28 05                 .(.
        pha                                     ; 84FF 48                       H
        jsr     entity_facing_dispatch                           ; 8500 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; 8503 20 86 EA                  ..
        pla                                     ; 8506 68                       h
        sta     $0528,x                         ; 8507 9D 28 05                 .(.
        rts                                     ; 850A 60                       `

; ----------------------------------------------------------------------------
L850B:  lda     $0420,x                         ; 850B BD 20 04                 . .
        pha                                     ; 850E 48                       H
        jsr     entity_set_facing                           ; 850F 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; 8512 20 30 EC                  0.
        pla                                     ; 8515 68                       h
        sta     $0420,x                         ; 8516 9D 20 04                 . .
        rts                                     ; 8519 60                       `

; ----------------------------------------------------------------------------
L851A:  lda     $0528,x                         ; 851A BD 28 05                 .(.
        pha                                     ; 851D 48                       H
        jsr     entity_horiz_dispatch                           ; 851E 20 3F EA                  ?.
        pla                                     ; 8521 68                       h
        sta     $0528,x                         ; 8522 9D 28 05                 .(.
        rts                                     ; 8525 60                       `

; ----------------------------------------------------------------------------
L8526:  lda     $0528,x                         ; 8526 BD 28 05                 .(.
        and     #$DF                            ; 8529 29 DF                    ).
        sta     $0528,x                         ; 852B 9D 28 05                 .(.
        rts                                     ; 852E 60                       `

; ----------------------------------------------------------------------------
L852F:  lda     $0420,x                         ; 852F BD 20 04                 . .
        eor     #$03                            ; 8532 49 03                    I.
        sta     $0420,x                         ; 8534 9D 20 04                 . .
        rts                                     ; 8537 60                       `

; ----------------------------------------------------------------------------
L8538:  lda     $0420,x                         ; 8538 BD 20 04                 . .
        eor     #$0C                            ; 853B 49 0C                    I.
        sta     $0420,x                         ; 853D 9D 20 04                 . .
        rts                                     ; 8540 60                       `

; ----------------------------------------------------------------------------
        lda     $0528,x                         ; 8541 BD 28 05                 .(.
        pha                                     ; 8544 48                       H
        jsr     entity_facing_dispatch                           ; 8545 20 65 EA                  e.
        pla                                     ; 8548 68                       h
        sta     $0528,x                         ; 8549 9D 28 05                 .(.
        rts                                     ; 854C 60                       `

; ----------------------------------------------------------------------------
L854D:  jsr     entity_x_dist_px                           ; 854D 20 94 EC                  ..
        pha                                     ; 8550 48                       H
        lda     L857E,y                         ; 8551 B9 7E 85                 .~.
        sta     $03D8,x                         ; 8554 9D D8 03                 ...
        lda     L8580,y                         ; 8557 B9 80 85                 ...
        sta     $03F0,x                         ; 855A 9D F0 03                 ...
        tya                                     ; 855D 98                       .
        asl     a                               ; 855E 0A                       .
        asl     a                               ; 855F 0A                       .
        tay                                     ; 8560 A8                       .
        pla                                     ; 8561 68                       h
        cmp     #$80                            ; 8562 C9 80                    ..
        bcs     L8571                           ; 8564 B0 0B                    ..
        iny                                     ; 8566 C8                       .
        cmp     #$50                            ; 8567 C9 50                    .P
        bcs     L8571                           ; 8569 B0 06                    ..
        iny                                     ; 856B C8                       .
        cmp     #$20                            ; 856C C9 20                    . 
        bcs     L8571                           ; 856E B0 01                    ..
        iny                                     ; 8570 C8                       .
L8571:  lda     L8582,y                         ; 8571 B9 82 85                 ...
        sta     $03A8,x                         ; 8574 9D A8 03                 ...
        lda     L858A,y                         ; 8577 B9 8A 85                 ...
        sta     $03C0,x                         ; 857A 9D C0 03                 ...
        rts                                     ; 857D 60                       `

; ----------------------------------------------------------------------------
L857E:  .byte   $AB                             ; 857E AB                       .
        .byte   $12                             ; 857F 12                       .
L8580:  ora     $07                             ; 8580 05 07                    ..
L8582:  bvc     L85B9                           ; 8582 50 35                    P5
        .byte   $53                             ; 8584 53                       S
        lda     $A6,x                           ; 8585 B5 A6                    ..
        cpy     $0F                             ; 8587 C4 0F                    ..
        .byte   $90                             ; 8589 90                       .
L858A:  .byte   $03                             ; 858A 03                       .
        .byte   $02                             ; 858B 02                       .
        ora     (L0000,x)                       ; 858C 01 00                    ..
        .byte   $02                             ; 858E 02                       .
        ora     ($01,x)                         ; 858F 01 01                    ..
        brk                                     ; 8591 00                       .
        lda     L85B7,y                         ; 8592 B9 B7 85                 ...
        sta     $03D8,x                         ; 8595 9D D8 03                 ...
        lda     L85BB,y                         ; 8598 B9 BB 85                 ...
        sta     $03F0,x                         ; 859B 9D F0 03                 ...
        lda     L85BF,y                         ; 859E B9 BF 85                 ...
        sta     $03                             ; 85A1 85 03                    ..
        lda     #$00                            ; 85A3 A9 00                    ..
        sta     L0000                           ; 85A5 85 00                    ..
        sta     $02                             ; 85A7 85 02                    ..
        jsr     div16                           ; 85A9 20 2D F2                  -.
        lda     $04                             ; 85AC A5 04                    ..
        sta     $03A8,x                         ; 85AE 9D A8 03                 ...
        lda     $05                             ; 85B1 A5 05                    ..
        sta     $03C0,x                         ; 85B3 9D C0 03                 ...
        rts                                     ; 85B6 60                       `

; ----------------------------------------------------------------------------
L85B7:  .byte   $AB                             ; 85B7 AB                       .
        .byte   $7B                             ; 85B8 7B                       {
L85B9:  inc     $12                             ; 85B9 E6 12                    ..
L85BB:  ora     $07                             ; 85BB 05 07                    ..
        .byte   $04                             ; 85BD 04                       .
        .byte   $07                             ; 85BE 07                       .
L85BF:  and     $273B                           ; 85BF 2D 3B 27                 -;'
        sec                                     ; 85C2 38                       8
L85C3:  brk                                     ; 85C3 00                       .
        brk                                     ; 85C4 00                       .
        brk                                     ; 85C5 00                       .
        brk                                     ; 85C6 00                       .
        brk                                     ; 85C7 00                       .
        brk                                     ; 85C8 00                       .
        brk                                     ; 85C9 00                       .
        brk                                     ; 85CA 00                       .
        brk                                     ; 85CB 00                       .
        brk                                     ; 85CC 00                       .
        brk                                     ; 85CD 00                       .
        brk                                     ; 85CE 00                       .
        brk                                     ; 85CF 00                       .
        brk                                     ; 85D0 00                       .
        brk                                     ; 85D1 00                       .
        brk                                     ; 85D2 00                       .
        .byte   $03                             ; 85D3 03                       .
        .byte   $03                             ; 85D4 03                       .
        .byte   $04                             ; 85D5 04                       .
        ora     $06                             ; 85D6 05 06                    ..
        .byte   $03                             ; 85D8 03                       .
        asl     $03                             ; 85D9 06 03                    ..
        asl     $05                             ; 85DB 06 05                    ..
        asl     $04                             ; 85DD 06 04                    ..
        .byte   $04                             ; 85DF 04                       .
        .byte   $04                             ; 85E0 04                       .
        brk                                     ; 85E1 00                       .
        .byte   $04                             ; 85E2 04                       .
        php                                     ; 85E3 08                       .
        .byte   $04                             ; 85E4 04                       .
        brk                                     ; 85E5 00                       .
        .byte   $04                             ; 85E6 04                       .
        brk                                     ; 85E7 00                       .
        ora     ($04,x)                         ; 85E8 01 04                    ..
        .byte   $04                             ; 85EA 04                       .
        .byte   $04                             ; 85EB 04                       .
        .byte   $03                             ; 85EC 03                       .
        asl     $05                             ; 85ED 06 05                    ..
        .byte   $04                             ; 85EF 04                       .
        php                                     ; 85F0 08                       .
        brk                                     ; 85F1 00                       .
        brk                                     ; 85F2 00                       .
        brk                                     ; 85F3 00                       .
        .byte   $07                             ; 85F4 07                       .
        .byte   $03                             ; 85F5 03                       .
        asl     $06                             ; 85F6 06 06                    ..
        .byte   $04                             ; 85F8 04                       .
        .byte   $04                             ; 85F9 04                       .
        .byte   $02                             ; 85FA 02                       .
        brk                                     ; 85FB 00                       .
        .byte   $03                             ; 85FC 03                       .
        .byte   $04                             ; 85FD 04                       .
        .byte   $04                             ; 85FE 04                       .
        .byte   $03                             ; 85FF 03                       .
        asl     $05                             ; 8600 06 05                    ..
        .byte   $04                             ; 8602 04                       .
        .byte   $1C                             ; 8603 1C                       .
        brk                                     ; 8604 00                       .
        brk                                     ; 8605 00                       .
        .byte   $04                             ; 8606 04                       .
        .byte   $04                             ; 8607 04                       .
        brk                                     ; 8608 00                       .
        brk                                     ; 8609 00                       .
        asl     L0000                           ; 860A 06 00                    ..
        brk                                     ; 860C 00                       .
        brk                                     ; 860D 00                       .
        brk                                     ; 860E 00                       .
        brk                                     ; 860F 00                       .
        brk                                     ; 8610 00                       .
        .byte   $03                             ; 8611 03                       .
        asl     a                               ; 8612 0A                       .
        .byte   $04                             ; 8613 04                       .
        .byte   $03                             ; 8614 03                       .
        .byte   $03                             ; 8615 03                       .
        .byte   $03                             ; 8616 03                       .
        .byte   $04                             ; 8617 04                       .
        .byte   $03                             ; 8618 03                       .
        .byte   $04                             ; 8619 04                       .
        brk                                     ; 861A 00                       .
        .byte   $02                             ; 861B 02                       .
        php                                     ; 861C 08                       .
        asl     $03                             ; 861D 06 03                    ..
        ora     $07                             ; 861F 05 07                    ..
        ora     $04                             ; 8621 05 04                    ..
        .byte   $04                             ; 8623 04                       .
        .byte   $04                             ; 8624 04                       .
        .byte   $04                             ; 8625 04                       .
        ora     $02                             ; 8626 05 02                    ..
        .byte   $02                             ; 8628 02                       .
        .byte   $03                             ; 8629 03                       .
        .byte   $03                             ; 862A 03                       .
        .byte   $02                             ; 862B 02                       .
        asl     $04                             ; 862C 06 04                    ..
        ora     $04                             ; 862E 05 04                    ..
        brk                                     ; 8630 00                       .
        ora     $06                             ; 8631 05 06                    ..
        ora     ($05,x)                         ; 8633 01 05                    ..
        brk                                     ; 8635 00                       .
        brk                                     ; 8636 00                       .
        brk                                     ; 8637 00                       .
        brk                                     ; 8638 00                       .
        brk                                     ; 8639 00                       .
        brk                                     ; 863A 00                       .
        brk                                     ; 863B 00                       .
        brk                                     ; 863C 00                       .
        ora     $02                             ; 863D 05 02                    ..
        ora     L0000                           ; 863F 05 00                    ..
        ora     $05                             ; 8641 05 05                    ..
        asl     $05                             ; 8643 06 05                    ..
        .byte   $04                             ; 8645 04                       .
        ora     $03                             ; 8646 05 03                    ..
        .byte   $04                             ; 8648 04                       .
        ora     $04                             ; 8649 05 04                    ..
        .byte   $03                             ; 864B 03                       .
        ora     $05                             ; 864C 05 05                    ..
        ora     $05                             ; 864E 05 05                    ..
        ora     $04                             ; 8650 05 04                    ..
        .byte   $04                             ; 8652 04                       .
        ora     $05                             ; 8653 05 05                    ..
        ora     $05                             ; 8655 05 05                    ..
        .byte   $04                             ; 8657 04                       .
        brk                                     ; 8658 00                       .
        ora     $04                             ; 8659 05 04                    ..
        ora     $06                             ; 865B 05 06                    ..
        asl     $02                             ; 865D 06 02                    ..
        php                                     ; 865F 08                       .
        asl     $05                             ; 8660 06 05                    ..
        .byte   $02                             ; 8662 02                       .
        asl     $06                             ; 8663 06 06                    ..
        brk                                     ; 8665 00                       .
        brk                                     ; 8666 00                       .
        brk                                     ; 8667 00                       .
        asl     L0000                           ; 8668 06 00                    ..
        ora     $03                             ; 866A 05 03                    ..
        brk                                     ; 866C 00                       .
        .byte   $03                             ; 866D 03                       .
        asl     L0000                           ; 866E 06 00                    ..
        brk                                     ; 8670 00                       .
        brk                                     ; 8671 00                       .
        brk                                     ; 8672 00                       .
        brk                                     ; 8673 00                       .
        ora     $06                             ; 8674 05 06                    ..
        brk                                     ; 8676 00                       .
        brk                                     ; 8677 00                       .
        brk                                     ; 8678 00                       .
        brk                                     ; 8679 00                       .
        brk                                     ; 867A 00                       .
        brk                                     ; 867B 00                       .
        brk                                     ; 867C 00                       .
        brk                                     ; 867D 00                       .
        asl     $04                             ; 867E 06 04                    ..
        asl     $06                             ; 8680 06 06                    ..
        brk                                     ; 8682 00                       .
        brk                                     ; 8683 00                       .
        brk                                     ; 8684 00                       .
        brk                                     ; 8685 00                       .
        brk                                     ; 8686 00                       .
        .byte   $03                             ; 8687 03                       .
        brk                                     ; 8688 00                       .
        brk                                     ; 8689 00                       .
        brk                                     ; 868A 00                       .
        brk                                     ; 868B 00                       .
        brk                                     ; 868C 00                       .
        brk                                     ; 868D 00                       .
        brk                                     ; 868E 00                       .
        brk                                     ; 868F 00                       .
        brk                                     ; 8690 00                       .
        brk                                     ; 8691 00                       .
        brk                                     ; 8692 00                       .
        brk                                     ; 8693 00                       .
        brk                                     ; 8694 00                       .
        brk                                     ; 8695 00                       .
        brk                                     ; 8696 00                       .
        brk                                     ; 8697 00                       .
        brk                                     ; 8698 00                       .
        brk                                     ; 8699 00                       .
        brk                                     ; 869A 00                       .
        brk                                     ; 869B 00                       .
        brk                                     ; 869C 00                       .
        brk                                     ; 869D 00                       .
        brk                                     ; 869E 00                       .
        brk                                     ; 869F 00                       .
        brk                                     ; 86A0 00                       .
        brk                                     ; 86A1 00                       .
        brk                                     ; 86A2 00                       .
        brk                                     ; 86A3 00                       .
        brk                                     ; 86A4 00                       .
        brk                                     ; 86A5 00                       .
        brk                                     ; 86A6 00                       .
        brk                                     ; 86A7 00                       .
        brk                                     ; 86A8 00                       .
        brk                                     ; 86A9 00                       .
        brk                                     ; 86AA 00                       .
        brk                                     ; 86AB 00                       .
        brk                                     ; 86AC 00                       .
        brk                                     ; 86AD 00                       .
        brk                                     ; 86AE 00                       .
        brk                                     ; 86AF 00                       .
        brk                                     ; 86B0 00                       .
        brk                                     ; 86B1 00                       .
        brk                                     ; 86B2 00                       .
        brk                                     ; 86B3 00                       .
        brk                                     ; 86B4 00                       .
        brk                                     ; 86B5 00                       .
        brk                                     ; 86B6 00                       .
        brk                                     ; 86B7 00                       .
        brk                                     ; 86B8 00                       .
        brk                                     ; 86B9 00                       .
        brk                                     ; 86BA 00                       .
        brk                                     ; 86BB 00                       .
        brk                                     ; 86BC 00                       .
        brk                                     ; 86BD 00                       .
        brk                                     ; 86BE 00                       .
        brk                                     ; 86BF 00                       .
        brk                                     ; 86C0 00                       .
        brk                                     ; 86C1 00                       .
        brk                                     ; 86C2 00                       .
bhv_bank_tbl:  ora     $1D1D,x                         ; 86C3 1D 1D 1D                 ...
        ora     $0A0A,x                         ; 86C6 1D 0A 0A                 ...
        ora     $05                             ; 86C9 05 05                    ..
        ora     $05                             ; 86CB 05 05                    ..
        asl     a                               ; 86CD 0A                       .
        ora     $05                             ; 86CE 05 05                    ..
        ora     $05                             ; 86D0 05 05                    ..
        ora     $1D                             ; 86D2 05 1D                    ..
        ora     $1D1D,x                         ; 86D4 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 86D7 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 86DA 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 86DD 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 86E0 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 86E3 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 86E6 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 86E9 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 86EC 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 86EF 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 86F2 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 86F5 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 86F8 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 86FB 1D 1D 1D                 ...
        .byte   $1D                             ; 86FE 1D                       .
        .byte   $1D                             ; 86FF 1D                       .
L8700:  ora     $1D1D,x                         ; 8700 1D 1D 1D                 ...
        asl     a                               ; 8703 0A                       .
        ora     $05                             ; 8704 05 05                    ..
        .byte   $03                             ; 8706 03                       .
        .byte   $03                             ; 8707 03                       .
        ora     $041D,x                         ; 8708 1D 1D 04                 ...
        ora     $1D                             ; 870B 05 1D                    ..
        ora     $05                             ; 870D 05 05                    ..
        ora     $1D1D,x                         ; 870F 1D 1D 1D                 ...
        .byte   $02                             ; 8712 02                       .
        ora     $1D1D,x                         ; 8713 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 8716 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 8719 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 871C 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 871F 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 8722 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 8725 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 8728 1D 1D 1D                 ...
        ora     $0606,x                         ; 872B 1D 06 06                 ...
        asl     $06                             ; 872E 06 06                    ..
        ora     $0606,x                         ; 8730 1D 06 06                 ...
        ora     $1D1D,x                         ; 8733 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 8736 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 8739 1D 1D 1D                 ...
        ora     $0202,x                         ; 873C 1D 02 02                 ...
        .byte   $02                             ; 873F 02                       .
        .byte   $02                             ; 8740 02                       .
        .byte   $02                             ; 8741 02                       .
        ora     $0706,x                         ; 8742 1D 06 07                 ...
        .byte   $07                             ; 8745 07                       .
        .byte   $07                             ; 8746 07                       .
        .byte   $07                             ; 8747 07                       .
        .byte   $07                             ; 8748 07                       .
        .byte   $07                             ; 8749 07                       .
        .byte   $07                             ; 874A 07                       .
        .byte   $07                             ; 874B 07                       .
        php                                     ; 874C 08                       .
        php                                     ; 874D 08                       .
        php                                     ; 874E 08                       .
        ora     $0808,x                         ; 874F 1D 08 08                 ...
        php                                     ; 8752 08                       .
        php                                     ; 8753 08                       .
        ora     #$09                            ; 8754 09 09                    ..
        ora     #$09                            ; 8756 09 09                    ..
        ora     #$09                            ; 8758 09 09                    ..
        ora     #$09                            ; 875A 09 09                    ..
        ora     #$09                            ; 875C 09 09                    ..
        ora     $1D1D,x                         ; 875E 1D 1D 1D                 ...
        ora     $021D,x                         ; 8761 1D 1D 02                 ...
        .byte   $02                             ; 8764 02                       .
        .byte   $03                             ; 8765 03                       .
        .byte   $03                             ; 8766 03                       .
        .byte   $03                             ; 8767 03                       .
        .byte   $04                             ; 8768 04                       .
        .byte   $04                             ; 8769 04                       .
        .byte   $04                             ; 876A 04                       .
        .byte   $04                             ; 876B 04                       .
        .byte   $04                             ; 876C 04                       .
        .byte   $04                             ; 876D 04                       .
        .byte   $04                             ; 876E 04                       .
        asl     a                               ; 876F 0A                       .
        asl     a                               ; 8770 0A                       .
        asl     a                               ; 8771 0A                       .
        .byte   $03                             ; 8772 03                       .
        .byte   $03                             ; 8773 03                       .
        ora     $0A04,x                         ; 8774 1D 04 0A                 ...
        asl     a                               ; 8777 0A                       .
        .byte   $03                             ; 8778 03                       .
        ora     $1D1D,x                         ; 8779 1D 1D 1D                 ...
        ora     $070D                           ; 877C 0D 0D 07                 ...
        ora     $1D1D,x                         ; 877F 1D 1D 1D                 ...
        ora     $0D0A,x                         ; 8782 1D 0A 0D                 ...
        ora     $1D1D,x                         ; 8785 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 8788 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 878B 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 878E 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 8791 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 8794 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 8797 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 879A 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 879D 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 87A0 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 87A3 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 87A6 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 87A9 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 87AC 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 87AF 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 87B2 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 87B5 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 87B8 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 87BB 1D 1D 1D                 ...
        ora     $1D1D,x                         ; 87BE 1D 1D 1D                 ...
        .byte   $1D                             ; 87C1 1D                       .
        .byte   $1D                             ; 87C2 1D                       .
L87C3:  brk                                     ; 87C3 00                       .
        brk                                     ; 87C4 00                       .
        brk                                     ; 87C5 00                       .
        brk                                     ; 87C6 00                       .
        brk                                     ; 87C7 00                       .
        brk                                     ; 87C8 00                       .
        brk                                     ; 87C9 00                       .
        brk                                     ; 87CA 00                       .
        brk                                     ; 87CB 00                       .
        brk                                     ; 87CC 00                       .
        brk                                     ; 87CD 00                       .
        brk                                     ; 87CE 00                       .
        brk                                     ; 87CF 00                       .
        brk                                     ; 87D0 00                       .
        brk                                     ; 87D1 00                       .
        brk                                     ; 87D2 00                       .
        brk                                     ; 87D3 00                       .
        brk                                     ; 87D4 00                       .
        brk                                     ; 87D5 00                       .
        brk                                     ; 87D6 00                       .
        brk                                     ; 87D7 00                       .
        brk                                     ; 87D8 00                       .
        brk                                     ; 87D9 00                       .
        brk                                     ; 87DA 00                       .
        brk                                     ; 87DB 00                       .
        brk                                     ; 87DC 00                       .
        brk                                     ; 87DD 00                       .
        brk                                     ; 87DE 00                       .
        brk                                     ; 87DF 00                       .
        brk                                     ; 87E0 00                       .
        brk                                     ; 87E1 00                       .
        brk                                     ; 87E2 00                       .
        brk                                     ; 87E3 00                       .
        brk                                     ; 87E4 00                       .
        brk                                     ; 87E5 00                       .
        brk                                     ; 87E6 00                       .
        brk                                     ; 87E7 00                       .
        brk                                     ; 87E8 00                       .
        brk                                     ; 87E9 00                       .
        brk                                     ; 87EA 00                       .
        brk                                     ; 87EB 00                       .
        brk                                     ; 87EC 00                       .
        brk                                     ; 87ED 00                       .
        brk                                     ; 87EE 00                       .
        brk                                     ; 87EF 00                       .
        brk                                     ; 87F0 00                       .
        brk                                     ; 87F1 00                       .
        brk                                     ; 87F2 00                       .
        brk                                     ; 87F3 00                       .
        brk                                     ; 87F4 00                       .
        brk                                     ; 87F5 00                       .
        brk                                     ; 87F6 00                       .
        brk                                     ; 87F7 00                       .
        brk                                     ; 87F8 00                       .
        brk                                     ; 87F9 00                       .
        brk                                     ; 87FA 00                       .
        brk                                     ; 87FB 00                       .
        brk                                     ; 87FC 00                       .
        brk                                     ; 87FD 00                       .
        brk                                     ; 87FE 00                       .
        brk                                     ; 87FF 00                       .
        brk                                     ; 8800 00                       .
        brk                                     ; 8801 00                       .
        brk                                     ; 8802 00                       .
        ora     (L0000,x)                       ; 8803 01 00                    ..
        brk                                     ; 8805 00                       .
        brk                                     ; 8806 00                       .
        ldx     a:L0000                         ; 8807 AE 00 00                 ...
        brk                                     ; 880A 00                       .
        brk                                     ; 880B 00                       .
        brk                                     ; 880C 00                       .
        brk                                     ; 880D 00                       .
        brk                                     ; 880E 00                       .
        brk                                     ; 880F 00                       .
        brk                                     ; 8810 00                       .
        brk                                     ; 8811 00                       .
        lda     a:L0000                         ; 8812 AD 00 00                 ...
        brk                                     ; 8815 00                       .
        brk                                     ; 8816 00                       .
        brk                                     ; 8817 00                       .
        brk                                     ; 8818 00                       .
        brk                                     ; 8819 00                       .
        brk                                     ; 881A 00                       .
        brk                                     ; 881B 00                       .
        brk                                     ; 881C 00                       .
        brk                                     ; 881D 00                       .
        brk                                     ; 881E 00                       .
        brk                                     ; 881F 00                       .
        brk                                     ; 8820 00                       .
        brk                                     ; 8821 00                       .
        brk                                     ; 8822 00                       .
        brk                                     ; 8823 00                       .
        brk                                     ; 8824 00                       .
        brk                                     ; 8825 00                       .
        brk                                     ; 8826 00                       .
        brk                                     ; 8827 00                       .
        brk                                     ; 8828 00                       .
        brk                                     ; 8829 00                       .
        brk                                     ; 882A 00                       .
        brk                                     ; 882B 00                       .
        ldy     L0000,x                         ; 882C B4 00                    ..
        ldy     L0000,x                         ; 882E B4 00                    ..
        brk                                     ; 8830 00                       .
        ldy     L0000,x                         ; 8831 B4 00                    ..
        brk                                     ; 8833 00                       .
        brk                                     ; 8834 00                       .
        brk                                     ; 8835 00                       .
        brk                                     ; 8836 00                       .
        brk                                     ; 8837 00                       .
        brk                                     ; 8838 00                       .
        brk                                     ; 8839 00                       .
        brk                                     ; 883A 00                       .
        brk                                     ; 883B 00                       .
        brk                                     ; 883C 00                       .
        brk                                     ; 883D 00                       .
        brk                                     ; 883E 00                       .
        lda     a:L0000                         ; 883F AD 00 00                 ...
        brk                                     ; 8842 00                       .
        brk                                     ; 8843 00                       .
        ldy     L0000,x                         ; 8844 B4 00                    ..
        ldy     L0000,x                         ; 8846 B4 00                    ..
        brk                                     ; 8848 00                       .
        ldy     L0000,x                         ; 8849 B4 00                    ..
        brk                                     ; 884B 00                       .
        ldy     L0000,x                         ; 884C B4 00                    ..
        brk                                     ; 884E 00                       .
        brk                                     ; 884F 00                       .
        ldy     L0000,x                         ; 8850 B4 00                    ..
        brk                                     ; 8852 00                       .
        brk                                     ; 8853 00                       .
        ldy     L0000,x                         ; 8854 B4 00                    ..
        ldy     L0000,x                         ; 8856 B4 00                    ..
        brk                                     ; 8858 00                       .
        ldy     L0000,x                         ; 8859 B4 00                    ..
        ldy     L0000,x                         ; 885B B4 00                    ..
        brk                                     ; 885D 00                       .
        brk                                     ; 885E 00                       .
        brk                                     ; 885F 00                       .
        brk                                     ; 8860 00                       .
        brk                                     ; 8861 00                       .
        brk                                     ; 8862 00                       .
        ldy     a:L0000                         ; 8863 AC 00 00                 ...
        brk                                     ; 8866 00                       .
        brk                                     ; 8867 00                       .
        lda     #$00                            ; 8868 A9 00                    ..
        brk                                     ; 886A 00                       .
        brk                                     ; 886B 00                       .
        brk                                     ; 886C 00                       .
        cpy     #$00                            ; 886D C0 00                    ..
        brk                                     ; 886F 00                       .
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
        brk                                     ; 887B 00                       .
        brk                                     ; 887C 00                       .
        brk                                     ; 887D 00                       .
        brk                                     ; 887E 00                       .
        brk                                     ; 887F 00                       .
        brk                                     ; 8880 00                       .
        brk                                     ; 8881 00                       .
        brk                                     ; 8882 00                       .
        brk                                     ; 8883 00                       .
        brk                                     ; 8884 00                       .
        brk                                     ; 8885 00                       .
        brk                                     ; 8886 00                       .
        brk                                     ; 8887 00                       .
        brk                                     ; 8888 00                       .
        brk                                     ; 8889 00                       .
        brk                                     ; 888A 00                       .
        brk                                     ; 888B 00                       .
        brk                                     ; 888C 00                       .
        brk                                     ; 888D 00                       .
        brk                                     ; 888E 00                       .
        brk                                     ; 888F 00                       .
        brk                                     ; 8890 00                       .
        brk                                     ; 8891 00                       .
        brk                                     ; 8892 00                       .
        brk                                     ; 8893 00                       .
        brk                                     ; 8894 00                       .
        brk                                     ; 8895 00                       .
        brk                                     ; 8896 00                       .
        brk                                     ; 8897 00                       .
        brk                                     ; 8898 00                       .
        brk                                     ; 8899 00                       .
        brk                                     ; 889A 00                       .
        brk                                     ; 889B 00                       .
        brk                                     ; 889C 00                       .
        brk                                     ; 889D 00                       .
        brk                                     ; 889E 00                       .
        brk                                     ; 889F 00                       .
        brk                                     ; 88A0 00                       .
        brk                                     ; 88A1 00                       .
        brk                                     ; 88A2 00                       .
        brk                                     ; 88A3 00                       .
        brk                                     ; 88A4 00                       .
        brk                                     ; 88A5 00                       .
        brk                                     ; 88A6 00                       .
        brk                                     ; 88A7 00                       .
        brk                                     ; 88A8 00                       .
        brk                                     ; 88A9 00                       .
        brk                                     ; 88AA 00                       .
        brk                                     ; 88AB 00                       .
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
        brk                                     ; 88BD 00                       .
        brk                                     ; 88BE 00                       .
        brk                                     ; 88BF 00                       .
        brk                                     ; 88C0 00                       .
        brk                                     ; 88C1 00                       .
        brk                                     ; 88C2 00                       .
bhv_pc_lo_tbl:  .byte   $63                             ; 88C3 63                       c
        .byte   $63                             ; 88C4 63                       c
        .byte   $3F                             ; 88C5 3F                       ?
        .byte   $33                             ; 88C6 33                       3
        ror     $9F,x                           ; 88C7 76 9F                    v.
        brk                                     ; 88C9 00                       .
        brk                                     ; 88CA 00                       .
        and     $70,x                           ; 88CB 35 70                    5p
        php                                     ; 88CD 08                       .
        .byte   $E3                             ; 88CE E3                       .
        bcc     L88E7                           ; 88CF 90 16                    ..
        nop                                     ; 88D1 EA                       .
        .byte   $7C                             ; 88D2 7C                       |
        adc     $12                             ; 88D3 65 12                    e.
        .byte   $1B                             ; 88D5 1B                       .
        sbc     $57                             ; 88D6 E5 57                    .W
        .byte   $FB                             ; 88D8 FB                       .
        dec     $5D,x                           ; 88D9 D6 5D                    .]
        and     $11A0,x                         ; 88DB 3D A0 11                 =..
        adc     ($BC,x)                         ; 88DE 61 BC                    a.
        .byte   $32                             ; 88E0 32                       2
        .byte   $63                             ; 88E1 63                       c
        .byte   $FA                             ; 88E2 FA                       .
        .byte   $64                             ; 88E3 64                       d
        rol     $A8C2,x                         ; 88E4 3E C2 A8                 >..
L88E7:  adc     $BEBB,x                         ; 88E7 7D BB BE                 }..
        .byte   $3F                             ; 88EA 3F                       ?
        adc     $F9,x                           ; 88EB 75 F9                    u.
        adc     ($50,x)                         ; 88ED 61 50                    aP
        .byte   $E2                             ; 88EF E2                       .
        .byte   $13                             ; 88F0 13                       .
        eor     #$66                            ; 88F1 49 66                    If
        tsx                                     ; 88F3 BA                       .
        php                                     ; 88F4 08                       .
        .byte   $80                             ; 88F5 80                       .
        .byte   $DB                             ; 88F6 DB                       .
        bne     L8952                           ; 88F7 D0 59                    .Y
        .byte   $C2                             ; 88F9 C2                       .
        .byte   $E2                             ; 88FA E2                       .
        .byte   $9E                             ; 88FB 9E                       .
        .byte   $3F                             ; 88FC 3F                       ?
        inc     L0000,x                         ; 88FD F6 00                    ..
        ldy     $DBE6,x                         ; 88FF BC E6 DB                 ...
        .byte   $B2                             ; 8902 B2                       .
        cpx     $14                             ; 8903 E4 14                    ..
        ldy     $CF49                           ; 8905 AC 49 CF                 .I.
        and     $3872,y                         ; 8908 39 72 38                 9r8
        .byte   $1F                             ; 890B 1F                       .
        ror     $3D,x                           ; 890C 76 3D                    v=
        inc     $3B7D,x                         ; 890E FE 7D 3B                 .};
        .byte   $72                             ; 8911 72                       r
        brk                                     ; 8912 00                       .
        clv                                     ; 8913 B8                       .
        ldy     $B94A,x                         ; 8914 BC 4A B9                 .J.
        .byte   $1F                             ; 8917 1F                       .
        ldy     $CC7A,x                         ; 8918 BC 7A CC                 .z.
        .byte   $E2                             ; 891B E2                       .
        cpx     #$98                            ; 891C E0 98                    ..
        lsr     a                               ; 891E 4A                       J
        txa                                     ; 891F 8A                       .
        adc     L8C0A,y                         ; 8920 79 0A 8C                 y..
        .byte   $DA                             ; 8923 DA                       .
        ldy     $0ABD,x                         ; 8924 BC BD 0A                 ...
        .byte   $0F                             ; 8927 0F                       .
        .byte   $E2                             ; 8928 E2                       .
        adc     $13                             ; 8929 65 13                    e.
        and     L0000                           ; 892B 25 00                    %.
        .byte   $92                             ; 892D 92                       .
        sed                                     ; 892E F8                       .
        cmp     $63                             ; 892F C5 63                    .c
        eor     $D3,x                           ; 8931 55 D3                    U.
        .byte   $66                             ; 8933 66                       f
L8934:  .byte   $63                             ; 8934 63                       c
        .byte   $5F                             ; 8935 5F                       _
        ldy     $4B,x                           ; 8936 B4 4B                    .K
        sta     ($E8,x)                         ; 8938 81 E8                    ..
L893A:  asl     $C879                           ; 893A 0E 79 C8                 .y.
        asl     $14,x                           ; 893D 16 14                    ..
        sta     ($39),y                         ; 893F 91 39                    .9
        .byte   $33                             ; 8941 33                       3
        .byte   $72                             ; 8942 72                       r
        jsr     L8A00                           ; 8943 20 00 8A                  ..
L8946:  bcc     L897C                           ; 8946 90 34                    .4
        txa                                     ; 8948 8A                       .
        .byte   $5B                             ; 8949 5B                       [
        sta     $98,x                           ; 894A 95 98                    ..
        brk                                     ; 894C 00                       .
        sta     $66AA                           ; 894D 8D AA 66                 ..f
        .byte   $CE                             ; 8950 CE                       .
        .byte   $5F                             ; 8951 5F                       _
L8952:  ldx     $5CAF                           ; 8952 AE AF 5C                 ..\
        sbc     $CE2F                           ; 8955 ED 2F CE                 ./.
        .byte   $D4                             ; 8958 D4                       .
        .byte   $EB                             ; 8959 EB                       .
        dec     $4505                           ; 895A CE 05 45                 ..E
        .byte   $5F                             ; 895D 5F                       _
        .byte   $E2                             ; 895E E2                       .
        .byte   $7F                             ; 895F 7F                       .
        .byte   $BC                             ; 8960 BC                       .
L8961:  inc     $1ABC,x                         ; 8961 FE BC 1A                 ...
        tax                                     ; 8964 AA                       .
        brk                                     ; 8965 00                       .
        jmp     (L00DF)                         ; 8966 6C DF 00                 l..

; ----------------------------------------------------------------------------
        ror     a                               ; 8969 6A                       j
        tax                                     ; 896A AA                       .
        cmp     $253A,y                         ; 896B D9 3A 25                 .:%
        .byte   $FA                             ; 896E FA                       .
        brk                                     ; 896F 00                       .
        .byte   $53                             ; 8970 53                       S
        .byte   $F4                             ; 8971 F4                       .
        ora     $3BA3,x                         ; 8972 1D A3 3B                 ..;
        .byte   $84                             ; 8975 84                       .
L8976:  .byte   $B3                             ; 8976 B3                       .
        and     #$00                            ; 8977 29 00                    ).
        sbc     $5959                           ; 8979 ED 59 59                 .YY
L897C:  brk                                     ; 897C 00                       .
        .byte   $9C                             ; 897D 9C                       .
        tya                                     ; 897E 98                       .
        ror     $DB                             ; 897F 66 DB                    f.
        bne     L8976                           ; 8981 D0 F3                    ..
        sed                                     ; 8983 F8                       .
        eor     $ED66,x                         ; 8984 5D 66 ED                 ]f.
        ldy     $F7                             ; 8987 A4 F7                    ..
        ora     $1919,y                         ; 8989 19 19 19                 ...
        .byte   $64                             ; 898C 64                       d
        .byte   $64                             ; 898D 64                       d
        .byte   $64                             ; 898E 64                       d
        .byte   $64                             ; 898F 64                       d
        .byte   $64                             ; 8990 64                       d
        .byte   $64                             ; 8991 64                       d
        .byte   $64                             ; 8992 64                       d
bhv_pc_hi_tbl:  txa                                     ; 8993 8A                       .
        txa                                     ; 8994 8A                       .
        lda     ($B8),y                         ; 8995 B1 B8                    ..
        ldx     $A6                             ; 8997 A6 A6                    ..
        ldy     #$A0                            ; 8999 A0 A0                    ..
        ldy     #$A0                            ; 899B A0 A0                    ..
        ldy     $A0                             ; 899D A4 A0                    ..
        lda     ($A2,x)                         ; 899F A1 A2                    ..
        ldx     #$A3                            ; 89A1 A2 A3                    ..
        txa                                     ; 89A3 8A                       .
        .byte   $8B                             ; 89A4 8B                       .
        bcc     L8934                           ; 89A5 90 8D                    ..
        stx     L9690                           ; 89A7 8E 90 96                 ...
        .byte   $8F                             ; 89AA 8F                       .
        ldy     $8F                             ; 89AB A4 8F                    ..
        bcc     L893A                           ; 89AD 90 8B                    ..
        sty     L8AA8                           ; 89AF 8C A8 8A                 ...
        bcc     L8946                           ; 89B2 90 92                    ..
        .byte   $93                             ; 89B4 93                       .
        ldy     L9795                           ; 89B5 AC 95 97                 ...
        .byte   $97                             ; 89B8 97                       .
        .byte   $A7                             ; 89B9 A7                       .
        .byte   $AB                             ; 89BA AB                       .
        tya                                     ; 89BB 98                       .
        tya                                     ; 89BC 98                       .
        stx     L8D99                           ; 89BD 8E 99 8D                 ...
        .byte   $8F                             ; 89C0 8F                       .
        .byte   $96                             ; 89C1 96                       .
L89C2:  .byte   $90,$90                    ; 89C2 90 90   (branch out of range for ca65: target has no local label)
        .byte   $9C                             ; 89C4 9C                       .
        .byte   $9C                             ; 89C5 9C                       .
        sta     L9D9E,x                         ; 89C6 9D 9E 9D                 ...
        sty     L918D                           ; 89C9 8C 8D 91                 ...
        .byte   $92                             ; 89CC 92                       .
        .byte   $97                             ; 89CD 97                       .
        ldy     #$8C                            ; 89CE A0 8C                    ..
        lda     ($9D,x)                         ; 89D0 A1 9D                    ..
        ldy     #$A4                            ; 89D2 A0 A4                    ..
        ldy     $A4                             ; 89D4 A4 A4                    ..
        ldx     $A4                             ; 89D6 A6 A4                    ..
        .byte   $B2                             ; 89D8 B2                       .
        ldy     $A5,x                           ; 89D9 B4 A5                    ..
        lda     $B8                             ; 89DB A5 B8                    ..
        lda     $A5                             ; 89DD A5 A5                    ..
        tsx                                     ; 89DF BA                       .
        tsx                                     ; 89E0 BA                       .
        ldy     $A0,x                           ; 89E1 B4 A0                    ..
        ldy     #$8C                            ; 89E3 A0 8C                    ..
        ldx     $A2                             ; 89E5 A6 A2                    ..
        .byte   $A3                             ; 89E7 A3                       .
        sty     $ADA3                           ; 89E8 8C A3 AD                 ...
        sta     $A4A9                           ; 89EB 8D A9 A4                 ...
        lda     $9C                             ; 89EE A5 9C                    ..
        lda     $9F                             ; 89F0 A5 9F                    ..
        ldx     $A6                             ; 89F2 A6 A6                    ..
        sty     $A9AA                           ; 89F4 8C AA A9                 ...
        ldy     $A98D                           ; 89F7 AC 8D A9                 ...
        .byte   $AB                             ; 89FA AB                       .
        .byte   $AB                             ; 89FB AB                       .
        ldy     #$A1                            ; 89FC A0 A1                    ..
        lda     ($A3,x)                         ; 89FE A1 A3                    ..
L8A00:  txa                                     ; 8A00 8A                       .
        ldy     $A5                             ; 8A01 A4 A5                    ..
        .byte   $AF                             ; 8A03 AF                       .
L8A04:  txa                                     ; 8A04 8A                       .
        .byte   $B3                             ; 8A05 B3                       .
        .byte   $B3                             ; 8A06 B3                       .
        ldy     $B4,x                           ; 8A07 B4 B4                    ..
        ldy     $B6,x                           ; 8A09 B4 B6                    ..
        ldx     $B6,y                           ; 8A0B B6 B6                    ..
        lda     ($A2,x)                         ; 8A0D A1 A2                    ..
        ldx     #$A5                            ; 8A0F A2 A5                    ..
        lda     $B4                             ; 8A11 A5 B4                    ..
        ldx     $A0                             ; 8A13 A6 A0                    ..
        ldx     #$A2                            ; 8A15 A2 A2                    ..
        ldy     $A2                             ; 8A17 A4 A2                    ..
        ldy     $A5                             ; 8A19 A4 A5                    ..
        lda     $A0                             ; 8A1B A5 A0                    ..
        lda     ($A1,x)                         ; 8A1D A1 A1                    ..
        bcc     L89C2                           ; 8A1F 90 A1                    ..
        .byte   $A3                             ; 8A21 A3                       .
        .byte   $A3                             ; 8A22 A3                       .
        .byte   $A3                             ; 8A23 A3                       .
        ldy     #$A0                            ; 8A24 A0 A0                    ..
        lda     ($A2,x)                         ; 8A26 A1 A2                    ..
        ldx     #$A2                            ; 8A28 A2 A2                    ..
        ldx     #$A4                            ; 8A2A A2 A4                    ..
        lda     $A6                             ; 8A2C A5 A6                    ..
        sta     L8C94                           ; 8A2E 8D 94 8C                 ...
        sta     $A68C,y                         ; 8A31 99 8C A6                 ...
        .byte   $A7                             ; 8A34 A7                       .
        ldy     #$A2                            ; 8A35 A0 A2                    ..
        ldx     #$A0                            ; 8A37 A2 A0                    ..
        lda     ($A1,x)                         ; 8A39 A1 A1                    ..
        lda     ($A2,x)                         ; 8A3B A1 A2                    ..
        .byte   $A3                             ; 8A3D A3                       .
        ldy     $A0                             ; 8A3E A4 A0                    ..
        ldy     #$A0                            ; 8A40 A0 A0                    ..
        ldy     $A4                             ; 8A42 A4 A4                    ..
        .byte   $BB                             ; 8A44 BB                       .
        lda     $A2                             ; 8A45 A5 A2                    ..
        lda     ($A0,x)                         ; 8A47 A1 A0                    ..
        lda     $AEAE                           ; 8A49 AD AE AE                 ...
        ldy     #$A0                            ; 8A4C A0 A0                    ..
        lda     $90                             ; 8A4E A5 90                    ..
        sta     L9B9E,x                         ; 8A50 9D 9E 9B                 ...
        lda     ($A2,x)                         ; 8A53 A1 A2                    ..
        bcc     L8A04                           ; 8A55 90 AD                    ..
        lda     ($B0,x)                         ; 8A57 A1 B0                    ..
        lda     ($B1),y                         ; 8A59 B1 B1                    ..
        lda     ($8A),y                         ; 8A5B B1 8A                    ..
        txa                                     ; 8A5D 8A                       .
        txa                                     ; 8A5E 8A                       .
        txa                                     ; 8A5F 8A                       .
        txa                                     ; 8A60 8A                       .
        txa                                     ; 8A61 8A                       .
        txa                                     ; 8A62 8A                       .
        rts                                     ; 8A63 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; 8A64 60                       `

; ----------------------------------------------------------------------------
        jsr     find_free_slot_y                           ; 8A65 20 6F F1                  o.
        lda     #$11                            ; 8A68 A9 11                    ..
        sta     $0300,y                         ; 8A6A 99 00 03                 ...
        lda     #$C1                            ; 8A6D A9 C1                    ..
        sta     $0408,y                         ; 8A6F 99 08 04                 ...
        lda     #$03                            ; 8A72 A9 03                    ..
        sta     $0450,y                         ; 8A74 99 50 04                 .P.
        lda     #$47                            ; 8A77 A9 47                    .G
        jsr     entity_init_pos                           ; 8A79 20 A4 EA                  ..
        lda     $0528,y                         ; 8A7C B9 28 05                 .(.
        ora     #$08                            ; 8A7F 09 08                    ..
        sta     $0528,y                         ; 8A81 99 28 05                 .(.
        lda     $0378,y                         ; 8A84 B9 78 03                 .x.
        sec                                     ; 8A87 38                       8
        sbc     #$18                            ; 8A88 E9 18                    ..
        sta     $0378,y                         ; 8A8A 99 78 03                 .x.
        lda     #$00                            ; 8A8D A9 00                    ..
        sta     $03D8,y                         ; 8A8F 99 D8 03                 ...
        lda     #$02                            ; 8A92 A9 02                    ..
        sta     $03F0,y                         ; 8A94 99 F0 03                 ...
        lda     #$6A                            ; 8A97 A9 6A                    .j
        sta     $03A8,y                         ; 8A99 99 A8 03                 ...
        lda     #$01                            ; 8A9C A9 01                    ..
        sta     $03C0,y                         ; 8A9E 99 C0 03                 ...
        txa                                     ; 8AA1 8A                       .
        sta     $0468,y                         ; 8AA2 99 68 04                 .h.
        tya                                     ; 8AA5 98                       .
        .byte   $9D                             ; 8AA6 9D                       .
        pla                                     ; 8AA7 68                       h
L8AA8:  .byte   $04                             ; 8AA8 04                       .
        lda     #$08                            ; 8AA9 A9 08                    ..
        sta     $0420,y                         ; 8AAB 99 20 04                 . .
        lda     #$14                            ; 8AAE A9 14                    ..
        sta     $0480,y                         ; 8AB0 99 80 04                 ...
        lda     #$C2                            ; 8AB3 A9 C2                    ..
        sta     $0588,x                         ; 8AB5 9D 88 05                 ...
        lda     #$8A                            ; 8AB8 A9 8A                    ..
        sta     $05A0,x                         ; 8ABA 9D A0 05                 ...
        lda     #$3C                            ; 8ABD A9 3C                    .<
        sta     $0480,x                         ; 8ABF 9D 80 04                 ...
        ldy     $0468,x                         ; 8AC2 BC 68 04                 .h.
        lda     $0300,y                         ; 8AC5 B9 00 03                 ...
        cmp     #$11                            ; 8AC8 C9 11                    ..
        beq     L8ACF                           ; 8ACA F0 03                    ..
        jmp     LA54D                           ; 8ACC 4C 4D A5                 LM.

; ----------------------------------------------------------------------------
L8ACF:  jsr     entity_facing_dispatch                           ; 8ACF 20 65 EA                  e.
        dec     $0480,x                         ; 8AD2 DE 80 04                 ...
        bne     L8ADF                           ; 8AD5 D0 08                    ..
        lda     #$3C                            ; 8AD7 A9 3C                    .<
        sta     $0480,x                         ; 8AD9 9D 80 04                 ...
        jsr     entity_flip_direction                           ; 8ADC 20 4A EC                  J.
L8ADF:  jsr     entity_hitbox_check                           ; 8ADF 20 F8 EF                  ..
        bcs     L8B11                           ; 8AE2 B0 2D                    .-
        lda     #$40                            ; 8AE4 A9 40                    .@
        sta     L0000                           ; 8AE6 85 00                    ..
        lda     $0420,x                         ; 8AE8 BD 20 04                 . .
        pha                                     ; 8AEB 48                       H
        lda     $0468,x                         ; 8AEC BD 68 04                 .h.
        pha                                     ; 8AEF 48                       H
        jsr     L809D                           ; 8AF0 20 9D 80                  ..
        pla                                     ; 8AF3 68                       h
        tay                                     ; 8AF4 A8                       .
        pla                                     ; 8AF5 68                       h
        sta     L0000                           ; 8AF6 85 00                    ..
        lda     $0300,x                         ; 8AF8 BD 00 03                 ...
        cmp     #$10                            ; 8AFB C9 10                    ..
        beq     L8B11                           ; 8AFD F0 12                    ..
        lda     L0000                           ; 8AFF A5 00                    ..
        sta     $0420,y                         ; 8B01 99 20 04                 . .
        lda     #$42                            ; 8B04 A9 42                    .B
        sta     $0588,y                         ; 8B06 99 88 05                 ...
        lda     #$8B                            ; 8B09 A9 8B                    ..
        sta     $05A0,y                         ; 8B0B 99 A0 05                 ...
        jsr     LEA34                           ; 8B0E 20 34 EA                  4.
L8B11:  rts                                     ; 8B11 60                       `

; ----------------------------------------------------------------------------
        ldy     $0468,x                         ; 8B12 BC 68 04                 .h.
        lda     $0528,y                         ; 8B15 B9 28 05                 .(.
        and     #$20                            ; 8B18 29 20                    ) 
        sta     L0000                           ; 8B1A 85 00                    ..
        lda     $0528,x                         ; 8B1C BD 28 05                 .(.
        and     #$DF                            ; 8B1F 29 DF                    ).
        ora     L0000                           ; 8B21 05 00                    ..
        sta     $0528,x                         ; 8B23 9D 28 05                 .(.
        lda     $0330,y                         ; 8B26 B9 30 03                 .0.
        sta     $0330,x                         ; 8B29 9D 30 03                 .0.
        lda     $0348,y                         ; 8B2C B9 48 03                 .H.
        sta     $0348,x                         ; 8B2F 9D 48 03                 .H.
        dec     $0480,x                         ; 8B32 DE 80 04                 ...
        bne     L8B3F                           ; 8B35 D0 08                    ..
        lda     #$14                            ; 8B37 A9 14                    ..
        sta     $0480,x                         ; 8B39 9D 80 04                 ...
        jsr     L8538                           ; 8B3C 20 38 85                  8.
L8B3F:  jmp     entity_vert_dispatch_raw                           ; 8B3F 4C 86 EA                 L..

; ----------------------------------------------------------------------------
        ldy     #$07                            ; 8B42 A0 07                    ..
        jsr     entity_gravity_collide                           ; 8B44 20 B7 E7                  ..
        bcc     L8B53                           ; 8B47 90 0A                    ..
        lda     #$A8                            ; 8B49 A9 A8                    ..
        sta     $03D8,x                         ; 8B4B 9D D8 03                 ...
        lda     #$05                            ; 8B4E A9 05                    ..
        sta     $03F0,x                         ; 8B50 9D F0 03                 ...
L8B53:  ldy     #$0E                            ; 8B53 A0 0E                    ..
        jsr     entity_horiz_dispatch                           ; 8B55 20 3F EA                  ?.
        bcc     L8B60                           ; 8B58 90 06                    ..
        jsr     entity_flip_direction                           ; 8B5A 20 4A EC                  J.
        jsr     entity_stop_y                           ; 8B5D 20 1E EA                  ..
L8B60:  rts                                     ; 8B60 60                       `

; ----------------------------------------------------------------------------
        lda     #$00                            ; 8B61 A9 00                    ..
        sta     $0570,x                         ; 8B63 9D 70 05                 .p.
        lda     $0468,x                         ; 8B66 BD 68 04                 .h.
        beq     L8B70                           ; 8B69 F0 05                    ..
        dec     $0468,x                         ; 8B6B DE 68 04                 .h.
        bne     L8B60                           ; 8B6E D0 F0                    ..
L8B70:  jsr     entity_x_dist_px                           ; 8B70 20 94 EC                  ..
        cmp     #$50                            ; 8B73 C9 50                    .P
        bcs     L8B60                           ; 8B75 B0 E9                    ..
        jsr     entity_y_dist_abs                           ; 8B77 20 76 EC                  v.
        cmp     #$20                            ; 8B7A C9 20                    . 
        bcs     L8B60                           ; 8B7C B0 E2                    ..
        lda     #$8D                            ; 8B7E A9 8D                    ..
        sta     $0588,x                         ; 8B80 9D 88 05                 ...
        lda     #$8B                            ; 8B83 A9 8B                    ..
        sta     $05A0,x                         ; 8B85 9D A0 05                 ...
        lda     #$D3                            ; 8B88 A9 D3                    ..
        sta     $0408,x                         ; 8B8A 9D 08 04                 ...
        lda     $0570,x                         ; 8B8D BD 70 05                 .p.
        cmp     #$08                            ; 8B90 C9 08                    ..
        bne     L8C0C                           ; 8B92 D0 78                    .x
        lda     $0540,x                         ; 8B94 BD 40 05                 .@.
        cmp     #$02                            ; 8B97 C9 02                    ..
        beq     L8BA8                           ; 8B99 F0 0D                    ..
        inc     $0408,x                         ; 8B9B FE 08 04                 ...
        lda     $0378,x                         ; 8B9E BD 78 03                 .x.
        sec                                     ; 8BA1 38                       8
        sbc     #$04                            ; 8BA2 E9 04                    ..
        sta     $0378,x                         ; 8BA4 9D 78 03                 .x.
        rts                                     ; 8BA7 60                       `

; ----------------------------------------------------------------------------
L8BA8:  lda     #$B7                            ; 8BA8 A9 B7                    ..
        sta     $0588,x                         ; 8BAA 9D 88 05                 ...
        lda     #$8B                            ; 8BAD A9 8B                    ..
        sta     $05A0,x                         ; 8BAF 9D A0 05                 ...
        lda     #$45                            ; 8BB2 A9 45                    .E
        jsr     entity_set_subtype                           ; 8BB4 20 98 EA                  ..
        lda     $0420,x                         ; 8BB7 BD 20 04                 . .
        sta     $01                             ; 8BBA 85 01                    ..
        jsr     entity_set_facing                           ; 8BBC 20 16 EC                  ..
        ldy     $0420,x                         ; 8BBF BC 20 04                 . .
        lda     $01                             ; 8BC2 A5 01                    ..
        sta     $0420,x                         ; 8BC4 9D 20 04                 . .
        cpy     $01                             ; 8BC7 C4 01                    ..
        beq     L8C0D                           ; 8BC9 F0 42                    .B
        lda     #$ED                            ; 8BCB A9 ED                    ..
        sta     $0588,x                         ; 8BCD 9D 88 05                 ...
        lda     #$8B                            ; 8BD0 A9 8B                    ..
        sta     $05A0,x                         ; 8BD2 9D A0 05                 ...
        lda     #$44                            ; 8BD5 A9 44                    .D
        cmp     $0558,x                         ; 8BD7 DD 58 05                 .X.
        beq     L8BED                           ; 8BDA F0 11                    ..
        jsr     entity_set_subtype                           ; 8BDC 20 98 EA                  ..
        lda     #$94                            ; 8BDF A9 94                    ..
        sta     $0408,x                         ; 8BE1 9D 08 04                 ...
        lda     $0378,x                         ; 8BE4 BD 78 03                 .x.
        clc                                     ; 8BE7 18                       .
        adc     #$04                            ; 8BE8 69 04                    i.
        sta     $0378,x                         ; 8BEA 9D 78 03                 .x.
L8BED:  lda     $0570,x                         ; 8BED BD 70 05                 .p.
        cmp     #$08                            ; 8BF0 C9 08                    ..
        bne     L8C0C                           ; 8BF2 D0 18                    ..
        lda     $0540,x                         ; 8BF4 BD 40 05                 .@.
        cmp     #$03                            ; 8BF7 C9 03                    ..
        beq     L8C02                           ; 8BF9 F0 07                    ..
        cmp     #$01                            ; 8BFB C9 01                    ..
        bne     L8C0C                           ; 8BFD D0 0D                    ..
        jmp     entity_flip_direction                           ; 8BFF 4C 4A EC                 LJ.

; ----------------------------------------------------------------------------
L8C02:  lda     #$B7                            ; 8C02 A9 B7                    ..
        sta     $0588,x                         ; 8C04 9D 88 05                 ...
        lda     #$8B                            ; 8C07 A9 8B                    ..
        .byte   $9D                             ; 8C09 9D                       .
L8C0A:  ldy     #$05                            ; 8C0A A0 05                    ..
L8C0C:  rts                                     ; 8C0C 60                       `

; ----------------------------------------------------------------------------
L8C0D:  lda     #$45                            ; 8C0D A9 45                    .E
        cmp     $0558,x                         ; 8C0F DD 58 05                 .X.
        beq     L8C25                           ; 8C12 F0 11                    ..
        jsr     entity_set_subtype                           ; 8C14 20 98 EA                  ..
        lda     #$D5                            ; 8C17 A9 D5                    ..
        sta     $0408,x                         ; 8C19 9D 08 04                 ...
        lda     $0378,x                         ; 8C1C BD 78 03                 .x.
        sec                                     ; 8C1F 38                       8
        sbc     #$04                            ; 8C20 E9 04                    ..
        sta     $0378,x                         ; 8C22 9D 78 03                 .x.
L8C25:  lda     #$00                            ; 8C25 A9 00                    ..
        sta     $0570,x                         ; 8C27 9D 70 05                 .p.
        ldy     $0480,x                         ; 8C2A BC 80 04                 ...
        lda     $0300,y                         ; 8C2D B9 00 03                 ...
        cmp     #$1C                            ; 8C30 C9 1C                    ..
        beq     L8C0C                           ; 8C32 F0 D8                    ..
        lda     #$3E                            ; 8C34 A9 3E                    .>
        sta     $0588,x                         ; 8C36 9D 88 05                 ...
        lda     #$8C                            ; 8C39 A9 8C                    ..
        sta     $05A0,x                         ; 8C3B 9D A0 05                 ...
        lda     $0570,x                         ; 8C3E BD 70 05                 .p.
        cmp     #$04                            ; 8C41 C9 04                    ..
        bne     L8CAF                           ; 8C43 D0 6A                    .j
        lda     $0540,x                         ; 8C45 BD 40 05                 .@.
        tay                                     ; 8C48 A8                       .
        lda     $0378,x                         ; 8C49 BD 78 03                 .x.
        clc                                     ; 8C4C 18                       .
        adc     L8CB0,y                         ; 8C4D 79 B0 8C                 y..
        sta     $0378,x                         ; 8C50 9D 78 03                 .x.
        lda     L8CB6,y                         ; 8C53 B9 B6 8C                 ...
        sta     $0408,x                         ; 8C56 9D 08 04                 ...
        cpy     #$05                            ; 8C59 C0 05                    ..
        beq     L8C9B                           ; 8C5B F0 3E                    .>
        cpy     #$03                            ; 8C5D C0 03                    ..
        bne     L8CAF                           ; 8C5F D0 4E                    .N
        lda     #$3C                            ; 8C61 A9 3C                    .<
        jsr     queue_sound                           ; 8C63 20 5D EC                  ].
        jsr     find_free_slot_y                           ; 8C66 20 6F F1                  o.
        bcs     L8CAF                           ; 8C69 B0 44                    .D
        lda     #$1C                            ; 8C6B A9 1C                    ..
        sta     $0300,y                         ; 8C6D 99 00 03                 ...
        lda     #$C1                            ; 8C70 A9 C1                    ..
        sta     $0408,y                         ; 8C72 99 08 04                 ...
        lda     #$01                            ; 8C75 A9 01                    ..
        sta     $0450,y                         ; 8C77 99 50 04                 .P.
        lda     $0420,x                         ; 8C7A BD 20 04                 . .
        sta     $0420,y                         ; 8C7D 99 20 04                 . .
        and     #$01                            ; 8C80 29 01                    ).
        clc                                     ; 8C82 18                       .
        adc     #$02                            ; 8C83 69 02                    i.
        sta     $10                             ; 8C85 85 10                    ..
        lda     #$46                            ; 8C87 A9 46                    .F
        jsr     entity_speed_preset                           ; 8C89 20 F5 EA                  ..
        lda     #$00                            ; 8C8C A9 00                    ..
        sta     $03A8,y                         ; 8C8E 99 A8 03                 ...
        lda     #$02                            ; 8C91 A9 02                    ..
        .byte   $99                             ; 8C93 99                       .
L8C94:  cpy     #$03                            ; 8C94 C0 03                    ..
        tya                                     ; 8C96 98                       .
        sta     $0480,x                         ; 8C97 9D 80 04                 ...
        rts                                     ; 8C9A 60                       `

; ----------------------------------------------------------------------------
L8C9B:  lda     #$43                            ; 8C9B A9 43                    .C
        jsr     entity_set_subtype                           ; 8C9D 20 98 EA                  ..
        lda     #$61                            ; 8CA0 A9 61                    .a
        sta     $0588,x                         ; 8CA2 9D 88 05                 ...
        lda     #$8B                            ; 8CA5 A9 8B                    ..
        sta     $05A0,x                         ; 8CA7 9D A0 05                 ...
        lda     #$3C                            ; 8CAA A9 3C                    .<
        sta     $0468,x                         ; 8CAC 9D 68 04                 .h.
L8CAF:  rts                                     ; 8CAF 60                       `

; ----------------------------------------------------------------------------
L8CB0:  brk                                     ; 8CB0 00                       .
        .byte   $04                             ; 8CB1 04                       .
        sed                                     ; 8CB2 F8                       .
        brk                                     ; 8CB3 00                       .
        php                                     ; 8CB4 08                       .
        .byte   $04                             ; 8CB5 04                       .
L8CB6:  cmp     $D4,x                           ; 8CB6 D5 D4                    ..
        cld                                     ; 8CB8 D8                       .
        cld                                     ; 8CB9 D8                       .
        .byte   $D4                             ; 8CBA D4                       .
        .byte   $93                             ; 8CBB 93                       .
        jsr     entity_facing_dispatch                           ; 8CBC 20 65 EA                  e.
        jmp     entity_vert_dispatch_raw                           ; 8CBF 4C 86 EA                 L..

; ----------------------------------------------------------------------------
        jsr     L8DCA                           ; 8CC2 20 CA 8D                  ..
        jsr     entity_set_facing                           ; 8CC5 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; 8CC8 20 30 EC                  0.
        jsr     entity_x_dist_px                           ; 8CCB 20 94 EC                  ..
        cmp     #$60                            ; 8CCE C9 60                    .`
        bcs     L8CD9                           ; 8CD0 B0 07                    ..
        jsr     entity_y_dist_abs                           ; 8CD2 20 76 EC                  v.
        cmp     #$20                            ; 8CD5 C9 20                    . 
        bcc     L8CDE                           ; 8CD7 90 05                    ..
L8CD9:  lda     #$3C                            ; 8CD9 A9 3C                    .<
        sta     $0480,x                         ; 8CDB 9D 80 04                 ...
L8CDE:  dec     $0480,x                         ; 8CDE DE 80 04                 ...
        beq     L8D0A                           ; 8CE1 F0 27                    .'
        lda     $0528                           ; 8CE3 AD 28 05                 .(.
        and     #$40                            ; 8CE6 29 40                    )@
        cmp     $0468,x                         ; 8CE8 DD 68 04                 .h.
        beq     L8D09                           ; 8CEB F0 1C                    ..
        lda     #$71                            ; 8CED A9 71                    .q
        sta     $0588,x                         ; 8CEF 9D 88 05                 ...
        lda     #$8D                            ; 8CF2 A9 8D                    ..
        sta     $05A0,x                         ; 8CF4 9D A0 05                 ...
        lda     #$0D                            ; 8CF7 A9 0D                    ..
        jsr     entity_set_subtype                           ; 8CF9 20 98 EA                  ..
        lda     $0528,x                         ; 8CFC BD 28 05                 .(.
        and     #$40                            ; 8CFF 29 40                    )@
        beq     L8D06                           ; 8D01 F0 03                    ..
        jmp     entity_stop_y                           ; 8D03 4C 1E EA                 L..

; ----------------------------------------------------------------------------
L8D06:  jsr     LEA29                           ; 8D06 20 29 EA                  ).
L8D09:  rts                                     ; 8D09 60                       `

; ----------------------------------------------------------------------------
L8D0A:  lda     #$0C                            ; 8D0A A9 0C                    ..
        jsr     entity_set_subtype                           ; 8D0C 20 98 EA                  ..
        lda     #$19                            ; 8D0F A9 19                    ..
        sta     $0588,x                         ; 8D11 9D 88 05                 ...
        lda     #$8D                            ; 8D14 A9 8D                    ..
        sta     $05A0,x                         ; 8D16 9D A0 05                 ...
        lda     $0570,x                         ; 8D19 BD 70 05                 .p.
        cmp     #$04                            ; 8D1C C9 04                    ..
        bne     L8D70                           ; 8D1E D0 50                    .P
        lda     $0540,x                         ; 8D20 BD 40 05                 .@.
        beq     L8D39                           ; 8D23 F0 14                    ..
        lda     #$C5                            ; 8D25 A9 C5                    ..
        sta     $0588,x                         ; 8D27 9D 88 05                 ...
        lda     #$8C                            ; 8D2A A9 8C                    ..
        sta     $05A0,x                         ; 8D2C 9D A0 05                 ...
        lda     #$3C                            ; 8D2F A9 3C                    .<
        sta     $0480,x                         ; 8D31 9D 80 04                 ...
        lda     #$0A                            ; 8D34 A9 0A                    ..
        jmp     entity_set_subtype                           ; 8D36 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L8D39:  lda     #$01                            ; 8D39 A9 01                    ..
        sta     $0E                             ; 8D3B 85 0E                    ..
L8D3D:  jsr     find_free_slot_y                           ; 8D3D 20 6F F1                  o.
        bcs     L8D70                           ; 8D40 B0 2E                    ..
        lda     #$58                            ; 8D42 A9 58                    .X
        sta     $0300,y                         ; 8D44 99 00 03                 ...
        lda     #$87                            ; 8D47 A9 87                    ..
        sta     $0408,y                         ; 8D49 99 08 04                 ...
        lda     $0E                             ; 8D4C A5 0E                    ..
        pha                                     ; 8D4E 48                       H
        clc                                     ; 8D4F 18                       .
        adc     #$13                            ; 8D50 69 13                    i.
        sta     $10                             ; 8D52 85 10                    ..
        lda     #$0E                            ; 8D54 A9 0E                    ..
        jsr     entity_speed_preset                           ; 8D56 20 F5 EA                  ..
        pla                                     ; 8D59 68                       h
        clc                                     ; 8D5A 18                       .
        adc     #$01                            ; 8D5B 69 01                    i.
        eor     #$03                            ; 8D5D 49 03                    I.
        sta     $0420,y                         ; 8D5F 99 20 04                 . .
        lda     #$00                            ; 8D62 A9 00                    ..
        sta     $03A8,y                         ; 8D64 99 A8 03                 ...
        lda     #$02                            ; 8D67 A9 02                    ..
        sta     $03C0,y                         ; 8D69 99 C0 03                 ...
        dec     $0E                             ; 8D6C C6 0E                    ..
        bpl     L8D3D                           ; 8D6E 10 CD                    ..
L8D70:  rts                                     ; 8D70 60                       `

; ----------------------------------------------------------------------------
        lda     $0570,x                         ; 8D71 BD 70 05                 .p.
        cmp     #$08                            ; 8D74 C9 08                    ..
        bne     L8D97                           ; 8D76 D0 1F                    ..
        lda     $0540,x                         ; 8D78 BD 40 05                 .@.
        beq     L8D8F                           ; 8D7B F0 12                    ..
        lda     #$0A                            ; 8D7D A9 0A                    ..
        jsr     entity_set_subtype                           ; 8D7F 20 98 EA                  ..
        lda     #$97                            ; 8D82 A9 97                    ..
        sta     $0588,x                         ; 8D84 9D 88 05                 ...
        lda     #$8D                            ; 8D87 A9 8D                    ..
        sta     $05A0,x                         ; 8D89 9D A0 05                 ...
        jmp     L8D97                           ; 8D8C 4C 97 8D                 L..

; ----------------------------------------------------------------------------
L8D8F:  lda     $0528,x                         ; 8D8F BD 28 05                 .(.
        eor     #$40                            ; 8D92 49 40                    I@
        sta     $0528,x                         ; 8D94 9D 28 05                 .(.
L8D97:  .byte   $BD                             ; 8D97 BD                       .
        .byte   $F0                             ; 8D98 F0                       .
L8D99:  .byte   $03                             ; 8D99 03                       .
        bpl     L8DA4                           ; 8D9A 10 08                    ..
        ldy     #$21                            ; 8D9C A0 21                    .!
        jsr     entity_gravity_collide                           ; 8D9E 20 B7 E7                  ..
        bcs     L8DB1                           ; 8DA1 B0 0E                    ..
        rts                                     ; 8DA3 60                       `

; ----------------------------------------------------------------------------
L8DA4:  jsr     entity_apply_gravity                           ; 8DA4 20 E1 E9                  ..
        jsr     LE999                           ; 8DA7 20 99 E9                  ..
        ldy     #$22                            ; 8DAA A0 22                    ."
        jsr     LE7A8                           ; 8DAC 20 A8 E7                  ..
        bcc     L8DE1                           ; 8DAF 90 30                    .0
L8DB1:  lda     #$C0                            ; 8DB1 A9 C0                    ..
        sta     $0588,x                         ; 8DB3 9D 88 05                 ...
        lda     #$8D                            ; 8DB6 A9 8D                    ..
        sta     $05A0,x                         ; 8DB8 9D A0 05                 ...
        lda     #$0B                            ; 8DBB A9 0B                    ..
        jsr     entity_set_subtype                           ; 8DBD 20 98 EA                  ..
        lda     $0540,x                         ; 8DC0 BD 40 05                 .@.
        beq     L8DE1                           ; 8DC3 F0 1C                    ..
        lda     #$0A                            ; 8DC5 A9 0A                    ..
        jsr     entity_set_subtype                           ; 8DC7 20 98 EA                  ..
L8DCA:  lda     $0528                           ; 8DCA AD 28 05                 .(.
        and     #$40                            ; 8DCD 29 40                    )@
        sta     $0468,x                         ; 8DCF 9D 68 04                 .h.
        lda     #$C5                            ; 8DD2 A9 C5                    ..
        sta     $0588,x                         ; 8DD4 9D 88 05                 ...
        lda     #$8C                            ; 8DD7 A9 8C                    ..
        sta     $05A0,x                         ; 8DD9 9D A0 05                 ...
        lda     #$3C                            ; 8DDC A9 3C                    .<
        sta     $0480,x                         ; 8DDE 9D 80 04                 ...
L8DE1:  rts                                     ; 8DE1 60                       `

; ----------------------------------------------------------------------------
        jmp     entity_facing_dispatch                           ; 8DE2 4C 65 EA                 Le.

; ----------------------------------------------------------------------------
        jsr     entity_facing_dispatch                           ; 8DE5 20 65 EA                  e.
        jsr     entity_x_dist_px                           ; 8DE8 20 94 EC                  ..
        cmp     #$08                            ; 8DEB C9 08                    ..
        bcs     L8E56                           ; 8DED B0 67                    .g
        lda     #$28                            ; 8DEF A9 28                    .(
        jsr     entity_set_subtype                           ; 8DF1 20 98 EA                  ..
        lda     #$FE                            ; 8DF4 A9 FE                    ..
        sta     $0588,x                         ; 8DF6 9D 88 05                 ...
        lda     #$8D                            ; 8DF9 A9 8D                    ..
        sta     $05A0,x                         ; 8DFB 9D A0 05                 ...
        lda     $0570,x                         ; 8DFE BD 70 05                 .p.
        cmp     #$02                            ; 8E01 C9 02                    ..
        bne     L8E56                           ; 8E03 D0 51                    .Q
        lda     $0540,x                         ; 8E05 BD 40 05                 .@.
        cmp     #$07                            ; 8E08 C9 07                    ..
        beq     L8E1F                           ; 8E0A F0 13                    ..
        cmp     #$0B                            ; 8E0C C9 0B                    ..
        bne     L8E56                           ; 8E0E D0 46                    .F
        lda     #$53                            ; 8E10 A9 53                    .S
        sta     $0588,x                         ; 8E12 9D 88 05                 ...
        lda     #$8E                            ; 8E15 A9 8E                    ..
        sta     $05A0,x                         ; 8E17 9D A0 05                 ...
        lda     #$29                            ; 8E1A A9 29                    .)
        jmp     entity_set_subtype                           ; 8E1C 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L8E1F:  jsr     find_free_slot_y                           ; 8E1F 20 6F F1                  o.
        bcs     L8E56                           ; 8E22 B0 32                    .2
        lda     #$14                            ; 8E24 A9 14                    ..
        sta     $0300,y                         ; 8E26 99 00 03                 ...
        lda     #$2B                            ; 8E29 A9 2B                    .+
        jsr     entity_init_pos                           ; 8E2B 20 A4 EA                  ..
        lda     #$C1                            ; 8E2E A9 C1                    ..
        sta     $0408,y                         ; 8E30 99 08 04                 ...
        lda     #$01                            ; 8E33 A9 01                    ..
        sta     $0450,y                         ; 8E35 99 50 04                 .P.
        lda     $0378,y                         ; 8E38 B9 78 03                 .x.
        clc                                     ; 8E3B 18                       .
        adc     #$10                            ; 8E3C 69 10                    i.
        sta     $0378,y                         ; 8E3E 99 78 03                 .x.
        jsr     LEA34                           ; 8E41 20 34 EA                  4.
        jsr     find_free_slot_y                           ; 8E44 20 6F F1                  o.
        bcs     L8E56                           ; 8E47 B0 0D                    ..
        lda     #$01                            ; 8E49 A9 01                    ..
        sta     $0300,y                         ; 8E4B 99 00 03                 ...
        lda     #$2A                            ; 8E4E A9 2A                    .*
        jmp     entity_init_pos                           ; 8E50 4C A4 EA                 L..

; ----------------------------------------------------------------------------
        jsr     entity_facing_dispatch                           ; 8E53 20 65 EA                  e.
L8E56:  rts                                     ; 8E56 60                       `

; ----------------------------------------------------------------------------
        ldy     #$07                            ; 8E57 A0 07                    ..
        jsr     entity_gravity_collide                           ; 8E59 20 B7 E7                  ..
        bcc     L8E56                           ; 8E5C 90 F8                    ..
        jmp     LA54D                           ; 8E5E 4C 4D A5                 LM.

; ----------------------------------------------------------------------------
        lda     $0498,x                         ; 8E61 BD 98 04                 ...
        beq     L8E71                           ; 8E64 F0 0B                    ..
        jsr     entity_set_facing                           ; 8E66 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; 8E69 20 30 EC                  0.
        dec     $0498,x                         ; 8E6C DE 98 04                 ...
        bne     L8E56                           ; 8E6F D0 E5                    ..
L8E71:  inc     $0468,x                         ; 8E71 FE 68 04                 .h.
        lda     $0468,x                         ; 8E74 BD 68 04                 .h.
        cmp     #$08                            ; 8E77 C9 08                    ..
        beq     L8E9B                           ; 8E79 F0 20                    . 
        bcs     L8E83                           ; 8E7B B0 06                    ..
        jsr     entity_set_facing                           ; 8E7D 20 16 EC                  ..
        jmp     entity_facing_to_flags                           ; 8E80 4C 30 EC                 L0.

; ----------------------------------------------------------------------------
L8E83:  cmp     #$3C                            ; 8E83 C9 3C                    .<
        bne     L8E56                           ; 8E85 D0 CF                    ..
        lda     #$CF                            ; 8E87 A9 CF                    ..
        sta     $0588,x                         ; 8E89 9D 88 05                 ...
        lda     #$8E                            ; 8E8C A9 8E                    ..
        sta     $05A0,x                         ; 8E8E 9D A0 05                 ...
        lda     #$C0                            ; 8E91 A9 C0                    ..
        sta     $0408,x                         ; 8E93 9D 08 04                 ...
        lda     #$7D                            ; 8E96 A9 7D                    .}
        jmp     entity_set_subtype                           ; 8E98 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L8E9B:  jsr     find_free_slot_y                           ; 8E9B 20 6F F1                  o.
        bcs     L8E56                           ; 8E9E B0 B6                    ..
        lda     #$2D                            ; 8EA0 A9 2D                    .-
        sta     $0300,y                         ; 8EA2 99 00 03                 ...
        lda     #$87                            ; 8EA5 A9 87                    ..
        sta     $0408,y                         ; 8EA7 99 08 04                 ...
        lda     $0420,x                         ; 8EAA BD 20 04                 . .
        sta     $0420,y                         ; 8EAD 99 20 04                 . .
        and     #$01                            ; 8EB0 29 01                    ).
        clc                                     ; 8EB2 18                       .
        adc     #$2A                            ; 8EB3 69 2A                    i*
        sta     $10                             ; 8EB5 85 10                    ..
        lda     #$5A                            ; 8EB7 A9 5A                    .Z
        jsr     entity_speed_preset                           ; 8EB9 20 F5 EA                  ..
        lda     #$00                            ; 8EBC A9 00                    ..
        sta     $03A8,y                         ; 8EBE 99 A8 03                 ...
        lda     #$02                            ; 8EC1 A9 02                    ..
        sta     $03C0,y                         ; 8EC3 99 C0 03                 ...
        txa                                     ; 8EC6 8A                       .
        sta     $0480,y                         ; 8EC7 99 80 04                 ...
        tya                                     ; 8ECA 98                       .
        sta     $0480,x                         ; 8ECB 9D 80 04                 ...
        rts                                     ; 8ECE 60                       `

; ----------------------------------------------------------------------------
        lda     $0570,x                         ; 8ECF BD 70 05                 .p.
        cmp     #$04                            ; 8ED2 C9 04                    ..
        bne     L8F12                           ; 8ED4 D0 3C                    .<
        cmp     $0540,x                         ; 8ED6 DD 40 05                 .@.
        bne     L8F12                           ; 8ED9 D0 37                    .7
        lda     #$E5                            ; 8EDB A9 E5                    ..
        sta     $0588,x                         ; 8EDD 9D 88 05                 ...
        lda     #$8E                            ; 8EE0 A9 8E                    ..
        sta     $05A0,x                         ; 8EE2 9D A0 05                 ...
        lda     #$00                            ; 8EE5 A9 00                    ..
        sta     $0570,x                         ; 8EE7 9D 70 05                 .p.
        ldy     $0480,x                         ; 8EEA BC 80 04                 ...
        lda     $0300,y                         ; 8EED B9 00 03                 ...
        cmp     #$2D                            ; 8EF0 C9 2D                    .-
        beq     L8F12                           ; 8EF2 F0 1E                    ..
        lda     #$61                            ; 8EF4 A9 61                    .a
        sta     $0588,x                         ; 8EF6 9D 88 05                 ...
        lda     #$8E                            ; 8EF9 A9 8E                    ..
        sta     $05A0,x                         ; 8EFB 9D A0 05                 ...
        lda     #$00                            ; 8EFE A9 00                    ..
        sta     $0468,x                         ; 8F00 9D 68 04                 .h.
        lda     #$4D                            ; 8F03 A9 4D                    .M
        jsr     entity_set_subtype                           ; 8F05 20 98 EA                  ..
        lda     #$78                            ; 8F08 A9 78                    .x
        sta     $0498,x                         ; 8F0A 9D 98 04                 ...
        lda     #$80                            ; 8F0D A9 80                    ..
        sta     $0408,x                         ; 8F0F 9D 08 04                 ...
L8F12:  rts                                     ; 8F12 60                       `

; ----------------------------------------------------------------------------
        lda     $0570,x                         ; 8F13 BD 70 05                 .p.
        cmp     #$02                            ; 8F16 C9 02                    ..
        bne     L8F12                           ; 8F18 D0 F8                    ..
        lda     $0540,x                         ; 8F1A BD 40 05                 .@.
        cmp     #$05                            ; 8F1D C9 05                    ..
        beq     L8F22                           ; 8F1F F0 01                    ..
        rts                                     ; 8F21 60                       `

; ----------------------------------------------------------------------------
L8F22:  lda     #$36                            ; 8F22 A9 36                    .6
        sta     $0588,x                         ; 8F24 9D 88 05                 ...
        lda     #$8F                            ; 8F27 A9 8F                    ..
        sta     $05A0,x                         ; 8F29 9D A0 05                 ...
        lda     #$7C                            ; 8F2C A9 7C                    .|
        jsr     entity_set_subtype                           ; 8F2E 20 98 EA                  ..
        lda     #$85                            ; 8F31 A9 85                    ..
        sta     $0408,x                         ; 8F33 9D 08 04                 ...
        ldy     $0480,x                         ; 8F36 BC 80 04                 ...
        lda     $0300,y                         ; 8F39 B9 00 03                 ...
        cmp     #$2A                            ; 8F3C C9 2A                    .*
        beq     L8F43                           ; 8F3E F0 03                    ..
        jmp     LA54D                           ; 8F40 4C 4D A5                 LM.

; ----------------------------------------------------------------------------
L8F43:  lda     $0558,y                         ; 8F43 B9 58 05                 .X.
        cmp     #$7D                            ; 8F46 C9 7D                    .}
        bne     L8F5C                           ; 8F48 D0 12                    ..
        lda     #$96                            ; 8F4A A9 96                    ..
        jsr     entity_set_subtype                           ; 8F4C 20 98 EA                  ..
        lda     #$59                            ; 8F4F A9 59                    .Y
        sta     $0588,x                         ; 8F51 9D 88 05                 ...
        lda     #$8F                            ; 8F54 A9 8F                    ..
        sta     $05A0,x                         ; 8F56 9D A0 05                 ...
        jsr     entity_facing_dispatch                           ; 8F59 20 65 EA                  e.
L8F5C:  rts                                     ; 8F5C 60                       `

; ----------------------------------------------------------------------------
        lda     #$01                            ; 8F5D A9 01                    ..
        sta     $03D8,x                         ; 8F5F 9D D8 03                 ...
        sta     $03F0,x                         ; 8F62 9D F0 03                 ...
        ldy     #$0B                            ; 8F65 A0 0B                    ..
        jsr     LE747                           ; 8F67 20 47 E7                  G.
        lda     $0420,x                         ; 8F6A BD 20 04                 . .
        and     #$01                            ; 8F6D 29 01                    ).
        tay                                     ; 8F6F A8                       .
        lda     $48,y                           ; 8F70 B9 48 00                 .H.
        and     #$10                            ; 8F73 29 10                    ).
        beq     L8F7E                           ; 8F75 F0 07                    ..
        ldy     #$0C                            ; 8F77 A0 0C                    ..
        jsr     entity_horiz_dispatch                           ; 8F79 20 3F EA                  ?.
        bcc     L8F9F                           ; 8F7C 90 21                    .!
L8F7E:  lda     #$1E                            ; 8F7E A9 1E                    ..
        sta     $0468,x                         ; 8F80 9D 68 04                 .h.
        lda     #$8D                            ; 8F83 A9 8D                    ..
        sta     $0588,x                         ; 8F85 9D 88 05                 ...
        lda     #$8F                            ; 8F88 A9 8F                    ..
        sta     $05A0,x                         ; 8F8A 9D A0 05                 ...
        dec     $0468,x                         ; 8F8D DE 68 04                 .h.
        bne     L8F9F                           ; 8F90 D0 0D                    ..
        lda     #$5D                            ; 8F92 A9 5D                    .]
        sta     $0588,x                         ; 8F94 9D 88 05                 ...
        lda     #$8F                            ; 8F97 A9 8F                    ..
        sta     $05A0,x                         ; 8F99 9D A0 05                 ...
        jsr     entity_flip_direction                           ; 8F9C 20 4A EC                  J.
L8F9F:  rts                                     ; 8F9F 60                       `

; ----------------------------------------------------------------------------
        jsr     entity_facing_dispatch                           ; 8FA0 20 65 EA                  e.
        jsr     entity_distance_calc                           ; 8FA3 20 C2 EC                  ..
        cmp     #$06                            ; 8FA6 C9 06                    ..
        beq     L8FAE                           ; 8FA8 F0 04                    ..
        cmp     #$0A                            ; 8FAA C9 0A                    ..
        bne     L9010                           ; 8FAC D0 62                    .b
L8FAE:  lda     #$BD                            ; 8FAE A9 BD                    ..
        sta     $0588,x                         ; 8FB0 9D 88 05                 ...
        lda     #$8F                            ; 8FB3 A9 8F                    ..
        sta     $05A0,x                         ; 8FB5 9D A0 05                 ...
        lda     #$32                            ; 8FB8 A9 32                    .2
        jsr     entity_set_subtype                           ; 8FBA 20 98 EA                  ..
        lda     $0570,x                         ; 8FBD BD 70 05                 .p.
        cmp     #$04                            ; 8FC0 C9 04                    ..
        bne     L900D                           ; 8FC2 D0 49                    .I
        lda     $0540,x                         ; 8FC4 BD 40 05                 .@.
        cmp     #$04                            ; 8FC7 C9 04                    ..
        beq     L8FE8                           ; 8FC9 F0 1D                    ..
        cmp     #$08                            ; 8FCB C9 08                    ..
        beq     L8FE8                           ; 8FCD F0 19                    ..
        cmp     #$0C                            ; 8FCF C9 0C                    ..
        beq     L8FE8                           ; 8FD1 F0 15                    ..
        cmp     #$0D                            ; 8FD3 C9 0D                    ..
        bne     L900D                           ; 8FD5 D0 36                    .6
        lda     #$0D                            ; 8FD7 A9 0D                    ..
        sta     $0588,x                         ; 8FD9 9D 88 05                 ...
        lda     #$90                            ; 8FDC A9 90                    ..
        sta     $05A0,x                         ; 8FDE 9D A0 05                 ...
        lda     #$34                            ; 8FE1 A9 34                    .4
        jsr     entity_set_subtype                           ; 8FE3 20 98 EA                  ..
        beq     L900D                           ; 8FE6 F0 25                    .%
L8FE8:  jsr     find_free_slot_y                           ; 8FE8 20 6F F1                  o.
        bcs     L9010                           ; 8FEB B0 23                    .#
        lda     #$1A                            ; 8FED A9 1A                    ..
        sta     $0300,y                         ; 8FEF 99 00 03                 ...
        lda     #$CA                            ; 8FF2 A9 CA                    ..
        sta     $0408,y                         ; 8FF4 99 08 04                 ...
        lda     #$01                            ; 8FF7 A9 01                    ..
        sta     $0450,y                         ; 8FF9 99 50 04                 .P.
        lda     #$33                            ; 8FFC A9 33                    .3
        jsr     entity_init_pos                           ; 8FFE 20 A4 EA                  ..
        lda     $0378,x                         ; 9001 BD 78 03                 .x.
        clc                                     ; 9004 18                       .
        adc     #$14                            ; 9005 69 14                    i.
        sta     $0378,y                         ; 9007 99 78 03                 .x.
        jsr     LEA34                           ; 900A 20 34 EA                  4.
L900D:  jsr     entity_facing_dispatch                           ; 900D 20 65 EA                  e.
L9010:  rts                                     ; 9010 60                       `

; ----------------------------------------------------------------------------
        ldy     #$06                            ; 9011 A0 06                    ..
        jsr     entity_gravity_collide                           ; 9013 20 B7 E7                  ..
        bcc     L9010                           ; 9016 90 F8                    ..
        jmp     LA54D                           ; 9018 4C 4D A5                 LM.

; ----------------------------------------------------------------------------
        jsr     entity_facing_dispatch                           ; 901B 20 65 EA                  e.
        jsr     entity_distance_calc                           ; 901E 20 C2 EC                  ..
        cmp     #$07                            ; 9021 C9 07                    ..
        beq     L9029                           ; 9023 F0 04                    ..
        cmp     #$09                            ; 9025 C9 09                    ..
        bne     L9065                           ; 9027 D0 3C                    .<
L9029:  lda     #$38                            ; 9029 A9 38                    .8
        sta     $0588,x                         ; 902B 9D 88 05                 ...
        lda     #$90                            ; 902E A9 90                    ..
        sta     $05A0,x                         ; 9030 9D A0 05                 ...
        lda     #$30                            ; 9033 A9 30                    .0
        jsr     entity_set_subtype                           ; 9035 20 98 EA                  ..
        lda     $0540,x                         ; 9038 BD 40 05                 .@.
        cmp     #$02                            ; 903B C9 02                    ..
        bne     L9065                           ; 903D D0 26                    .&
        lda     $0570,x                         ; 903F BD 70 05                 .p.
        cmp     #$08                            ; 9042 C9 08                    ..
        bne     L9065                           ; 9044 D0 1F                    ..
        lda     #$5D                            ; 9046 A9 5D                    .]
        sta     $0588,x                         ; 9048 9D 88 05                 ...
        lda     #$90                            ; 904B A9 90                    ..
        sta     $05A0,x                         ; 904D 9D A0 05                 ...
        lda     #$CC                            ; 9050 A9 CC                    ..
        sta     $0408,x                         ; 9052 9D 08 04                 ...
        jsr     entity_stop_y                           ; 9055 20 1E EA                  ..
        lda     #$3B                            ; 9058 A9 3B                    .;
        jsr     queue_sound                           ; 905A 20 5D EC                  ].
        lda     #$00                            ; 905D A9 00                    ..
        sta     $0570,x                         ; 905F 9D 70 05                 .p.
        jsr     entity_process_y_vel                           ; 9062 20 68 E9                  h.
L9065:  rts                                     ; 9065 60                       `

; ----------------------------------------------------------------------------
        lda     #$2B                            ; 9066 A9 2B                    .+
        jsr     queue_sound                           ; 9068 20 5D EC                  ].
        lda     #$75                            ; 906B A9 75                    .u
        sta     $0588,x                         ; 906D 9D 88 05                 ...
        lda     #$90                            ; 9070 A9 90                    ..
        sta     $05A0,x                         ; 9072 9D A0 05                 ...
        lda     $0480,x                         ; 9075 BD 80 04                 ...
        cmp     #$09                            ; 9078 C9 09                    ..
        beq     L90B9                           ; 907A F0 3D                    .=
        lda     $0468,x                         ; 907C BD 68 04                 .h.
        beq     L9088                           ; 907F F0 07                    ..
        dec     $0468,x                         ; 9081 DE 68 04                 .h.
        bne     L90B9                           ; 9084 D0 33                    .3
        lda     #$01                            ; 9086 A9 01                    ..
L9088:  sta     $0E                             ; 9088 85 0E                    ..
        stx     $0F                             ; 908A 86 0F                    ..
        lda     #$02                            ; 908C A9 02                    ..
        sta     $0468,x                         ; 908E 9D 68 04                 .h.
L9091:  jsr     find_free_slot_y                           ; 9091 20 6F F1                  o.
        bcs     L90B2                           ; 9094 B0 1C                    ..
        lda     #$01                            ; 9096 A9 01                    ..
        sta     $0300,y                         ; 9098 99 00 03                 ...
        lda     #$00                            ; 909B A9 00                    ..
        sta     $0408,y                         ; 909D 99 08 04                 ...
        lda     #$00                            ; 90A0 A9 00                    ..
        sta     $0450,y                         ; 90A2 99 50 04                 .P.
        lda     $0480,x                         ; 90A5 BD 80 04                 ...
        clc                                     ; 90A8 18                       .
        adc     #$10                            ; 90A9 69 10                    i.
        sta     $10                             ; 90AB 85 10                    ..
        lda     #$42                            ; 90AD A9 42                    .B
        jsr     entity_speed_preset                           ; 90AF 20 F5 EA                  ..
L90B2:  inc     $0480,x                         ; 90B2 FE 80 04                 ...
        dec     $0E                             ; 90B5 C6 0E                    ..
        bpl     L9091                           ; 90B7 10 D8                    ..
L90B9:  rts                                     ; 90B9 60                       `

; ----------------------------------------------------------------------------
        lda     $0468,x                         ; 90BA BD 68 04                 .h.
        beq     L90C4                           ; 90BD F0 05                    ..
        dec     $0468,x                         ; 90BF DE 68 04                 .h.
        bne     L90F9                           ; 90C2 D0 35                    .5
L90C4:  lda     #$10                            ; 90C4 A9 10                    ..
        sta     $0468,x                         ; 90C6 9D 68 04                 .h.
        stx     $0F                             ; 90C9 86 0F                    ..
        jsr     find_free_slot_y                           ; 90CB 20 6F F1                  o.
        bcs     L90EC                           ; 90CE B0 1C                    ..
        lda     #$2C                            ; 90D0 A9 2C                    .,
        jsr     queue_sound                           ; 90D2 20 5D EC                  ].
        lda     #$2F                            ; 90D5 A9 2F                    ./
        sta     $0300,y                         ; 90D7 99 00 03                 ...
        lda     #$00                            ; 90DA A9 00                    ..
        sta     $0408,y                         ; 90DC 99 08 04                 ...
        lda     $0480,x                         ; 90DF BD 80 04                 ...
        clc                                     ; 90E2 18                       .
        adc     #$19                            ; 90E3 69 19                    i.
        sta     $10                             ; 90E5 85 10                    ..
        lda     #$42                            ; 90E7 A9 42                    .B
        jsr     entity_speed_preset                           ; 90E9 20 F5 EA                  ..
L90EC:  inc     $0480,x                         ; 90EC FE 80 04                 ...
        lda     $0480,x                         ; 90EF BD 80 04                 ...
        cmp     #$05                            ; 90F2 C9 05                    ..
        bne     L90F9                           ; 90F4 D0 03                    ..
        jsr     entity_wipe_x                           ; 90F6 20 C4 F2                  ..
L90F9:  rts                                     ; 90F9 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; 90FA 60                       `

; ----------------------------------------------------------------------------
        jsr     L911A                           ; 90FB 20 1A 91                  ..
        dec     $0468,x                         ; 90FE DE 68 04                 .h.
        bne     L912C                           ; 9101 D0 29                    .)
        jsr     L9174                           ; 9103 20 74 91                  t.
        lda     #$10                            ; 9106 A9 10                    ..
        sta     $0588,x                         ; 9108 9D 88 05                 ...
        lda     #$91                            ; 910B A9 91                    ..
        sta     $05A0,x                         ; 910D 9D A0 05                 ...
        jsr     entity_player_collide                           ; 9110 20 87 EF                  ..
        bcs     L912D                           ; 9113 B0 18                    ..
        lda     #$00                            ; 9115 A9 00                    ..
        sta     $0480,x                         ; 9117 9D 80 04                 ...
L911A:  lda     #$1E                            ; 911A A9 1E                    ..
        sta     $0468,x                         ; 911C 9D 68 04                 .h.
        sta     $0498,x                         ; 911F 9D 98 04                 ...
        lda     #$FE                            ; 9122 A9 FE                    ..
        sta     $0588,x                         ; 9124 9D 88 05                 ...
        lda     #$90                            ; 9127 A9 90                    ..
        sta     $05A0,x                         ; 9129 9D A0 05                 ...
L912C:  rts                                     ; 912C 60                       `

; ----------------------------------------------------------------------------
L912D:  jsr     entity_facing_dispatch                           ; 912D 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; 9130 20 86 EA                  ..
        jsr     entity_x_dist_px                           ; 9133 20 94 EC                  ..
        cmp     #$32                            ; 9136 C9 32                    .2
        bcs     L915E                           ; 9138 B0 24                    .$
        jsr     entity_y_dist_abs                           ; 913A 20 76 EC                  v.
        cmp     #$32                            ; 913D C9 32                    .2
        bcs     L915E                           ; 913F B0 1D                    ..
        lda     $0480,x                         ; 9141 BD 80 04                 ...
        bne     L914B                           ; 9144 D0 05                    ..
        lda     #$1E                            ; 9146 A9 1E                    ..
        sta     $0480,x                         ; 9148 9D 80 04                 ...
L914B:  dec     $0480,x                         ; 914B DE 80 04                 ...
        bne     L919D                           ; 914E D0 4D                    .M
        lda     #$1E                            ; 9150 A9 1E                    ..
        sta     $0480,x                         ; 9152 9D 80 04                 ...
        jsr     entity_distance_calc                           ; 9155 20 C2 EC                  ..
        tay                                     ; 9158 A8                       .
        lda     #$20                            ; 9159 A9 20                    . 
        jmp     entity_set_dir_velocity                           ; 915B 4C 70 F4                 Lp.

; ----------------------------------------------------------------------------
L915E:  lda     $0480,x                         ; 915E BD 80 04                 ...
        bne     L916F                           ; 9161 D0 0C                    ..
        dec     $0498,x                         ; 9163 DE 98 04                 ...
        bne     L919D                           ; 9166 D0 35                    .5
        lda     #$1E                            ; 9168 A9 1E                    ..
        sta     $0498,x                         ; 916A 9D 98 04                 ...
        bne     L9174                           ; 916D D0 05                    ..
L916F:  lda     #$00                            ; 916F A9 00                    ..
        sta     $0480,x                         ; 9171 9D 80 04                 ...
L9174:  jsr     entity_set_facing                           ; 9174 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; 9177 20 30 EC                  0.
        ldy     #$08                            ; 917A A0 08                    ..
        lda     $0378,x                         ; 917C BD 78 03                 .x.
        cmp     $0378                           ; 917F CD 78 03                 .x.
        bcs     L9186                           ; 9182 B0 02                    ..
        ldy     #$04                            ; 9184 A0 04                    ..
L9186:  tya                                     ; 9186 98                       .
        ora     $0420,x                         ; 9187 1D 20 04                 . .
        sta     $0420,x                         ; 918A 9D 20 04                 . .
L918D:  lda     #$0F                            ; 918D A9 0F                    ..
        sta     $03A8,x                         ; 918F 9D A8 03                 ...
        sta     $03D8,x                         ; 9192 9D D8 03                 ...
        lda     #$01                            ; 9195 A9 01                    ..
        sta     $03C0,x                         ; 9197 9D C0 03                 ...
        sta     $03F0,x                         ; 919A 9D F0 03                 ...
L919D:  rts                                     ; 919D 60                       `

; ----------------------------------------------------------------------------
        lda     $0348                           ; 919E AD 48 03                 .H.
        beq     L919D                           ; 91A1 F0 FA                    ..
        cmp     #$01                            ; 91A3 C9 01                    ..
        bne     L91AE                           ; 91A5 D0 07                    ..
        lda     $0330                           ; 91A7 AD 30 03                 .0.
        cmp     #$40                            ; 91AA C9 40                    .@
        bcc     L919D                           ; 91AC 90 EF                    ..
L91AE:  lda     $0330                           ; 91AE AD 30 03                 .0.
        sec                                     ; 91B1 38                       8
        sbc     #$70                            ; 91B2 E9 70                    .p
        sta     $0330,x                         ; 91B4 9D 30 03                 .0.
        lda     $0348                           ; 91B7 AD 48 03                 .H.
        sbc     #$00                            ; 91BA E9 00                    ..
        sta     $0348,x                         ; 91BC 9D 48 03                 .H.
        lda     $0468,x                         ; 91BF BD 68 04                 .h.
        beq     L91C9                           ; 91C2 F0 05                    ..
        dec     $0468,x                         ; 91C4 DE 68 04                 .h.
        bne     L923E                           ; 91C7 D0 75                    .u
L91C9:  ldy     #$17                            ; 91C9 A0 17                    ..
        lda     #$00                            ; 91CB A9 00                    ..
        sta     L0000                           ; 91CD 85 00                    ..
L91CF:  lda     $0300,y                         ; 91CF B9 00 03                 ...
        cmp     #$39                            ; 91D2 C9 39                    .9
        beq     L91DA                           ; 91D4 F0 04                    ..
        cmp     #$01                            ; 91D6 C9 01                    ..
        bne     L91DC                           ; 91D8 D0 02                    ..
L91DA:  inc     L0000                           ; 91DA E6 00                    ..
L91DC:  dey                                     ; 91DC 88                       .
        cpy     #$07                            ; 91DD C0 07                    ..
        bcs     L91CF                           ; 91DF B0 EE                    ..
        lda     L0000                           ; 91E1 A5 00                    ..
        cmp     #$03                            ; 91E3 C9 03                    ..
        bcs     L923E                           ; 91E5 B0 57                    .W
        stx     $0F                             ; 91E7 86 0F                    ..
        jsr     find_free_slot_y                           ; 91E9 20 6F F1                  o.
        bcs     L923E                           ; 91EC B0 50                    .P
        lda     #$39                            ; 91EE A9 39                    .9
        sta     $0300,y                         ; 91F0 99 00 03                 ...
        lda     #$C1                            ; 91F3 A9 C1                    ..
        sta     $0408,y                         ; 91F5 99 08 04                 ...
        lda     #$00                            ; 91F8 A9 00                    ..
        sta     $0450,y                         ; 91FA 99 50 04                 .P.
        lda     #$4B                            ; 91FD A9 4B                    .K
        jsr     entity_init_pos                           ; 91FF 20 A4 EA                  ..
        lda     $E6                             ; 9202 A5 E6                    ..
        adc     $E4                             ; 9204 65 E4                    e.
        sta     $E6                             ; 9206 85 E6                    ..
        cmp     #$E0                            ; 9208 C9 E0                    ..
        bcc     L920F                           ; 920A 90 03                    ..
        sec                                     ; 920C 38                       8
        sbc     #$E0                            ; 920D E9 E0                    ..
L920F:  sta     $0E                             ; 920F 85 0E                    ..
        lda     $0330,x                         ; 9211 BD 30 03                 .0.
        clc                                     ; 9214 18                       .
        adc     $0E                             ; 9215 65 0E                    e.
        sta     $0330,y                         ; 9217 99 30 03                 .0.
        lda     $0348,x                         ; 921A BD 48 03                 .H.
        adc     #$00                            ; 921D 69 00                    i.
        sta     $0348,y                         ; 921F 99 48 03                 .H.
        sty     $0E                             ; 9222 84 0E                    ..
        lda     $E6                             ; 9224 A5 E6                    ..
        and     #$03                            ; 9226 29 03                    ).
        adc     #$07                            ; 9228 69 07                    i.
        tay                                     ; 922A A8                       .
        cpy     #$0A                            ; 922B C0 0A                    ..
        bcc     L9230                           ; 922D 90 01                    ..
        dey                                     ; 922F 88                       .
L9230:  ldx     $0E                             ; 9230 A6 0E                    ..
        lda     #$28                            ; 9232 A9 28                    .(
        jsr     entity_set_dir_velocity                           ; 9234 20 70 F4                  p.
        ldx     $0F                             ; 9237 A6 0F                    ..
        lda     #$0A                            ; 9239 A9 0A                    ..
        sta     $0468,x                         ; 923B 9D 68 04                 .h.
L923E:  rts                                     ; 923E 60                       `

; ----------------------------------------------------------------------------
        lda     #$00                            ; 923F A9 00                    ..
        sta     $0570,x                         ; 9241 9D 70 05                 .p.
        ldy     #$17                            ; 9244 A0 17                    ..
        jsr     entity_vert_dispatch                           ; 9246 20 52 EA                  R.
        bcs     L9252                           ; 9249 B0 07                    ..
        ldy     #$1C                            ; 924B A0 1C                    ..
        jsr     L851A                           ; 924D 20 1A 85                  ..
        bcc     L923E                           ; 9250 90 EC                    ..
L9252:  lda     #$01                            ; 9252 A9 01                    ..
        sta     $0540,x                         ; 9254 9D 40 05                 .@.
        jsr     entity_wipe_x                           ; 9257 20 C4 F2                  ..
        lda     #$01                            ; 925A A9 01                    ..
        sta     $0300,x                         ; 925C 9D 00 03                 ...
        lda     #$2B                            ; 925F A9 2B                    .+
        jmp     queue_sound                           ; 9261 4C 5D EC                 L].

; ----------------------------------------------------------------------------
        lda     #$3C                            ; 9264 A9 3C                    .<
        jsr     L9330                           ; 9266 20 30 93                  0.
        lda     $0468,x                         ; 9269 BD 68 04                 .h.
        beq     L9278                           ; 926C F0 0A                    ..
        lda     #$00                            ; 926E A9 00                    ..
        sta     $0570,x                         ; 9270 9D 70 05                 .p.
        dec     $0468,x                         ; 9273 DE 68 04                 .h.
        bne     L92CE                           ; 9276 D0 56                    .V
L9278:  lda     #$C4                            ; 9278 A9 C4                    ..
        sta     $03A8,x                         ; 927A 9D A8 03                 ...
        lda     #$01                            ; 927D A9 01                    ..
        sta     $03C0,x                         ; 927F 9D C0 03                 ...
        lda     #$A8                            ; 9282 A9 A8                    ..
        sta     $03D8,x                         ; 9284 9D D8 03                 ...
        lda     #$05                            ; 9287 A9 05                    ..
        sta     $03F0,x                         ; 9289 9D F0 03                 ...
        jsr     entity_set_facing                           ; 928C 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; 928F 20 30 EC                  0.
        lda     #$A1                            ; 9292 A9 A1                    ..
        sta     $0588,x                         ; 9294 9D 88 05                 ...
        lda     #$92                            ; 9297 A9 92                    ..
        sta     $05A0,x                         ; 9299 9D A0 05                 ...
        lda     #$01                            ; 929C A9 01                    ..
        sta     $0540,x                         ; 929E 9D 40 05                 .@.
        jsr     entity_distance_calc                           ; 92A1 20 C2 EC                  ..
        cmp     #$08                            ; 92A4 C9 08                    ..
        bne     L92B8                           ; 92A6 D0 10                    ..
        lda     #$CF                            ; 92A8 A9 CF                    ..
        sta     $0588,x                         ; 92AA 9D 88 05                 ...
        lda     #$92                            ; 92AD A9 92                    ..
        sta     $05A0,x                         ; 92AF 9D A0 05                 ...
        lda     #$0A                            ; 92B2 A9 0A                    ..
        sta     $0480,x                         ; 92B4 9D 80 04                 ...
        rts                                     ; 92B7 60                       `

; ----------------------------------------------------------------------------
L92B8:  lda     #$00                            ; 92B8 A9 00                    ..
        sta     $0570,x                         ; 92BA 9D 70 05                 .p.
        ldy     #$0F                            ; 92BD A0 0F                    ..
        jsr     entity_gravity_collide                           ; 92BF 20 B7 E7                  ..
        bcs     L9307                           ; 92C2 B0 43                    .C
        ldy     #$12                            ; 92C4 A0 12                    ..
        jsr     entity_horiz_dispatch                           ; 92C6 20 3F EA                  ?.
        bcc     L92CE                           ; 92C9 90 03                    ..
        jsr     entity_flip_direction                           ; 92CB 20 4A EC                  J.
L92CE:  rts                                     ; 92CE 60                       `

; ----------------------------------------------------------------------------
        lda     #$00                            ; 92CF A9 00                    ..
        sta     $0570,x                         ; 92D1 9D 70 05                 .p.
        lda     $0480,x                         ; 92D4 BD 80 04                 ...
        beq     L92FB                           ; 92D7 F0 22                    ."
        dec     $0480,x                         ; 92D9 DE 80 04                 ...
        beq     L92F1                           ; 92DC F0 13                    ..
        cmp     #$04                            ; 92DE C9 04                    ..
        bne     L92CE                           ; 92E0 D0 EC                    ..
        jsr     find_free_slot_y                           ; 92E2 20 6F F1                  o.
        bcs     L92CE                           ; 92E5 B0 E7                    ..
        lda     #$01                            ; 92E7 A9 01                    ..
        sta     $0300,y                         ; 92E9 99 00 03                 ...
        lda     #$3B                            ; 92EC A9 3B                    .;
        jmp     entity_init_pos                           ; 92EE 4C A4 EA                 L..

; ----------------------------------------------------------------------------
L92F1:  lda     #$00                            ; 92F1 A9 00                    ..
        sta     $03D8,x                         ; 92F3 9D D8 03                 ...
        lda     #$04                            ; 92F6 A9 04                    ..
        sta     $03F0,x                         ; 92F8 9D F0 03                 ...
L92FB:  lda     #$00                            ; 92FB A9 00                    ..
        sta     $0570,x                         ; 92FD 9D 70 05                 .p.
        ldy     #$0F                            ; 9300 A0 0F                    ..
        jsr     LE747                           ; 9302 20 47 E7                  G.
        bcc     L92CE                           ; 9305 90 C7                    ..
L9307:  lda     #$3A                            ; 9307 A9 3A                    .:
        jsr     entity_set_subtype                           ; 9309 20 98 EA                  ..
        lda     #$1B                            ; 930C A9 1B                    ..
        sta     $0588,x                         ; 930E 9D 88 05                 ...
        lda     #$93                            ; 9311 A9 93                    ..
        sta     $05A0,x                         ; 9313 9D A0 05                 ...
        lda     #$36                            ; 9316 A9 36                    .6
        jsr     queue_sound                           ; 9318 20 5D EC                  ].
        lda     $0540,x                         ; 931B BD 40 05                 .@.
        cmp     #$03                            ; 931E C9 03                    ..
        bne     L92CE                           ; 9320 D0 AC                    ..
        lda     $0570,x                         ; 9322 BD 70 05                 .p.
        cmp     #$04                            ; 9325 C9 04                    ..
        bne     L92CE                           ; 9327 D0 A5                    ..
        lda     #$39                            ; 9329 A9 39                    .9
        jsr     entity_set_subtype                           ; 932B 20 98 EA                  ..
        lda     #$2A                            ; 932E A9 2A                    .*
L9330:  sta     $0468,x                         ; 9330 9D 68 04                 .h.
        lda     #$69                            ; 9333 A9 69                    .i
        sta     $0588,x                         ; 9335 9D 88 05                 ...
        lda     #$92                            ; 9338 A9 92                    ..
        sta     $05A0,x                         ; 933A 9D A0 05                 ...
        rts                                     ; 933D 60                       `

; ----------------------------------------------------------------------------
        inc     $04C8,x                         ; 933E FE C8 04                 ...
        lda     $04C8,x                         ; 9341 BD C8 04                 ...
        cmp     #$3C                            ; 9344 C9 3C                    .<
        bne     L92CE                           ; 9346 D0 86                    ..
        jsr     entity_distance_calc                           ; 9348 20 C2 EC                  ..
        tay                                     ; 934B A8                       .
        lda     #$18                            ; 934C A9 18                    ..
        jsr     entity_set_dir_velocity                           ; 934E 20 70 F4                  p.
        lda     #$60                            ; 9351 A9 60                    .`
        sta     $0588,x                         ; 9353 9D 88 05                 ...
        lda     #$93                            ; 9356 A9 93                    ..
        sta     $05A0,x                         ; 9358 9D A0 05                 ...
        lda     #$28                            ; 935B A9 28                    .(
        sta     $0468,x                         ; 935D 9D 68 04                 .h.
        jsr     L84FC                           ; 9360 20 FC 84                  ..
        lda     $0498,x                         ; 9363 BD 98 04                 ...
        beq     L936C                           ; 9366 F0 04                    ..
        dec     $0498,x                         ; 9368 DE 98 04                 ...
        rts                                     ; 936B 60                       `

; ----------------------------------------------------------------------------
L936C:  jsr     L9417                           ; 936C 20 17 94                  ..
        ldy     $04E0,x                         ; 936F BC E0 04                 ...
        lda     $0300,y                         ; 9372 B9 00 03                 ...
        cmp     #$55                            ; 9375 C9 55                    .U
        beq     L93CB                           ; 9377 F0 52                    .R
        jsr     find_free_slot_y                           ; 9379 20 6F F1                  o.
        bcs     L93CB                           ; 937C B0 4D                    .M
        stx     $0F                             ; 937E 86 0F                    ..
        lda     #$86                            ; 9380 A9 86                    ..
        sta     $0408,y                         ; 9382 99 08 04                 ...
        lda     #$55                            ; 9385 A9 55                    .U
        sta     $0300,y                         ; 9387 99 00 03                 ...
        tya                                     ; 938A 98                       .
        sta     $04E0,x                         ; 938B 9D E0 04                 ...
        lda     $0480,x                         ; 938E BD 80 04                 ...
        tax                                     ; 9391 AA                       .
        lda     L946F,x                         ; 9392 BD 6F 94                 .o.
        sta     $03D8,y                         ; 9395 99 D8 03                 ...
        lda     L9477,x                         ; 9398 BD 77 94                 .w.
        sta     $03F0,y                         ; 939B 99 F0 03                 ...
        lda     L945F,x                         ; 939E BD 5F 94                 ._.
        sta     $03A8,y                         ; 93A1 99 A8 03                 ...
        lda     L9467,x                         ; 93A4 BD 67 94                 .g.
        sta     $03C0,y                         ; 93A7 99 C0 03                 ...
        lda     L9457,x                         ; 93AA BD 57 94                 .W.
        sta     $0420,y                         ; 93AD 99 20 04                 . .
        lda     L944F,x                         ; 93B0 BD 4F 94                 .O.
        sta     $10                             ; 93B3 85 10                    ..
        ldx     $0F                             ; 93B5 A6 0F                    ..
        lda     $0558,x                         ; 93B7 BD 58 05                 .X.
        clc                                     ; 93BA 18                       .
        adc     #$03                            ; 93BB 69 03                    i.
        jsr     entity_speed_preset                           ; 93BD 20 F5 EA                  ..
        lda     #$08                            ; 93C0 A9 08                    ..
        sta     $0498,x                         ; 93C2 9D 98 04                 ...
        lda     #$00                            ; 93C5 A9 00                    ..
        sta     $04B0,x                         ; 93C7 9D B0 04                 ...
        rts                                     ; 93CA 60                       `

; ----------------------------------------------------------------------------
L93CB:  dec     $0468,x                         ; 93CB DE 68 04                 .h.
        bne     L9416                           ; 93CE D0 46                    .F
        lda     #$F5                            ; 93D0 A9 F5                    ..
        sta     $0588,x                         ; 93D2 9D 88 05                 ...
        lda     #$93                            ; 93D5 A9 93                    ..
        sta     $05A0,x                         ; 93D7 9D A0 05                 ...
        lda     #$66                            ; 93DA A9 66                    .f
        sta     $03D8,x                         ; 93DC 9D D8 03                 ...
        lda     #$02                            ; 93DF A9 02                    ..
        sta     $03F0,x                         ; 93E1 9D F0 03                 ...
        lda     #$08                            ; 93E4 A9 08                    ..
        sta     $0420,x                         ; 93E6 9D 20 04                 . .
        lda     $0378,x                         ; 93E9 BD 78 03                 .x.
        cmp     #$40                            ; 93EC C9 40                    .@
        bcs     L93F5                           ; 93EE B0 05                    ..
        lda     #$04                            ; 93F0 A9 04                    ..
        sta     $0420,x                         ; 93F2 9D 20 04                 . .
L93F5:  jsr     L9417                           ; 93F5 20 17 94                  ..
        jsr     entity_vert_dispatch_raw                           ; 93F8 20 86 EA                  ..
        lda     $0378,x                         ; 93FB BD 78 03                 .x.
        sec                                     ; 93FE 38                       8
        sbc     #$40                            ; 93FF E9 40                    .@
        bcs     L9408                           ; 9401 B0 05                    ..
        eor     #$FF                            ; 9403 49 FF                    I.
        clc                                     ; 9405 18                       .
        adc     #$01                            ; 9406 69 01                    i.
L9408:  cmp     #$08                            ; 9408 C9 08                    ..
        bcs     L9416                           ; 940A B0 0A                    ..
        lda     #$48                            ; 940C A9 48                    .H
        sta     $0588,x                         ; 940E 9D 88 05                 ...
        lda     #$93                            ; 9411 A9 93                    ..
        sta     $05A0,x                         ; 9413 9D A0 05                 ...
L9416:  rts                                     ; 9416 60                       `

; ----------------------------------------------------------------------------
L9417:  lda     $04B0,x                         ; 9417 BD B0 04                 ...
        inc     $04B0,x                         ; 941A FE B0 04                 ...
        and     #$07                            ; 941D 29 07                    ).
        bne     L9416                           ; 941F D0 F5                    ..
        jsr     entity_distance_calc                           ; 9421 20 C2 EC                  ..
        tay                                     ; 9424 A8                       .
        lsr     a                               ; 9425 4A                       J
        sta     $0480,x                         ; 9426 9D 80 04                 ...
        lda     $0420,x                         ; 9429 BD 20 04                 . .
        sta     $0F                             ; 942C 85 0F                    ..
        lda     $ED4B,y                         ; 942E B9 4B ED                 .K.
        sta     $0420,x                         ; 9431 9D 20 04                 . .
        jsr     entity_facing_to_flags                           ; 9434 20 30 EC                  0.
        lda     $0F                             ; 9437 A5 0F                    ..
        sta     $0420,x                         ; 9439 9D 20 04                 . .
        lda     $0480,x                         ; 943C BD 80 04                 ...
        tay                                     ; 943F A8                       .
        lda     L9447,y                         ; 9440 B9 47 94                 .G.
        sta     $0558,x                         ; 9443 9D 58 05                 .X.
        rts                                     ; 9446 60                       `

; ----------------------------------------------------------------------------
L9447:  and     $3D3D,x                         ; 9447 3D 3D 3D                 ===
        .byte   $3C                             ; 944A 3C                       <
        rol     $3D3C,x                         ; 944B 3E 3C 3D                 ><=
        .byte   $3D                             ; 944E 3D                       =
L944F:  .byte   $04                             ; 944F 04                       .
        .byte   $04                             ; 9450 04                       .
        .byte   $04                             ; 9451 04                       .
        ora     $06                             ; 9452 05 06                    ..
        .byte   $07                             ; 9454 07                       .
        php                                     ; 9455 08                       .
        php                                     ; 9456 08                       .
L9457:  ora     ($01,x)                         ; 9457 01 01                    ..
        ora     ($05,x)                         ; 9459 01 05                    ..
        .byte   $04                             ; 945B 04                       .
        asl     $02                             ; 945C 06 02                    ..
        .byte   $02                             ; 945E 02                       .
L945F:  brk                                     ; 945F 00                       .
        brk                                     ; 9460 00                       .
        brk                                     ; 9461 00                       .
        ror     a                               ; 9462 6A                       j
        brk                                     ; 9463 00                       .
        ror     a                               ; 9464 6A                       j
        brk                                     ; 9465 00                       .
        brk                                     ; 9466 00                       .
L9467:  .byte   $02                             ; 9467 02                       .
        .byte   $02                             ; 9468 02                       .
        .byte   $02                             ; 9469 02                       .
        ora     (L0000,x)                       ; 946A 01 00                    ..
        ora     ($02,x)                         ; 946C 01 02                    ..
        .byte   $02                             ; 946E 02                       .
L946F:  brk                                     ; 946F 00                       .
        brk                                     ; 9470 00                       .
        brk                                     ; 9471 00                       .
        ror     a                               ; 9472 6A                       j
        brk                                     ; 9473 00                       .
        ror     a                               ; 9474 6A                       j
        brk                                     ; 9475 00                       .
        brk                                     ; 9476 00                       .
L9477:  brk                                     ; 9477 00                       .
        brk                                     ; 9478 00                       .
        brk                                     ; 9479 00                       .
        ora     ($02,x)                         ; 947A 01 02                    ..
        ora     (L0000,x)                       ; 947C 01 00                    ..
        brk                                     ; 947E 00                       .
        jsr     entity_x_dist_px                           ; 947F 20 94 EC                  ..
        cmp     #$5A                            ; 9482 C9 5A                    .Z
        bcc     L948F                           ; 9484 90 09                    ..
        lda     $14                             ; 9486 A5 14                    ..
        and     #$40                            ; 9488 29 40                    )@
        bne     L948F                           ; 948A D0 03                    ..
        jmp     L9504                           ; 948C 4C 04 95                 L..

; ----------------------------------------------------------------------------
L948F:  lda     #$9E                            ; 948F A9 9E                    ..
        sta     $0588,x                         ; 9491 9D 88 05                 ...
        lda     #$94                            ; 9494 A9 94                    ..
        sta     $05A0,x                         ; 9496 9D A0 05                 ...
        lda     #$8A                            ; 9499 A9 8A                    ..
        jsr     entity_set_subtype                           ; 949B 20 98 EA                  ..
        lda     $9D                             ; 949E A5 9D                    ..
        and     #$0F                            ; 94A0 29 0F                    ).
        bne     L94A9                           ; 94A2 D0 05                    ..
        lda     #$47                            ; 94A4 A9 47                    .G
        jsr     queue_sound                           ; 94A6 20 5D EC                  ].
L94A9:  ldy     #$19                            ; 94A9 A0 19                    ..
        jsr     tile_collide_horiz                           ; 94AB 20 A1 C4                  ..
        lda     $0420,x                         ; 94AE BD 20 04                 . .
        and     #$01                            ; 94B1 29 01                    ).
        asl     a                               ; 94B3 0A                       .
        tay                                     ; 94B4 A8                       .
        lda     $48,y                           ; 94B5 B9 48 00                 .H.
        and     #$10                            ; 94B8 29 10                    ).
        beq     L94D1                           ; 94BA F0 15                    ..
        ldy     #$26                            ; 94BC A0 26                    .&
        jsr     L851A                           ; 94BE 20 1A 85                  ..
        bcs     L94D1                           ; 94C1 B0 0E                    ..
        lda     $0510,x                         ; 94C3 BD 10 05                 ...
        cmp     #$1F                            ; 94C6 C9 1F                    ..
        beq     L94E1                           ; 94C8 F0 17                    ..
        lda     $0330,x                         ; 94CA BD 30 03                 .0.
        cmp     #$F0                            ; 94CD C9 F0                    ..
        bcc     L94E1                           ; 94CF 90 10                    ..
L94D1:  jsr     L852F                           ; 94D1 20 2F 85                  /.
        lda     $0558,x                         ; 94D4 BD 58 05                 .X.
        eor     #$01                            ; 94D7 49 01                    I.
        sta     $0558,x                         ; 94D9 9D 58 05                 .X.
        lda     #$00                            ; 94DC A9 00                    ..
        sta     $0570,x                         ; 94DE 9D 70 05                 .p.
L94E1:  lda     $0528,x                         ; 94E1 BD 28 05                 .(.
        pha                                     ; 94E4 48                       H
        jsr     L850B                           ; 94E5 20 0B 85                  ..
        pla                                     ; 94E8 68                       h
        cmp     $0528,x                         ; 94E9 DD 28 05                 .(.
        beq     L9504                           ; 94EC F0 16                    ..
        lda     #$0F                            ; 94EE A9 0F                    ..
        sec                                     ; 94F0 38                       8
        sbc     $0540,x                         ; 94F1 FD 40 05                 .@.
        sta     $0540,x                         ; 94F4 9D 40 05                 .@.
        lda     $0558,x                         ; 94F7 BD 58 05                 .X.
        eor     #$01                            ; 94FA 49 01                    I.
        sta     $0558,x                         ; 94FC 9D 58 05                 .X.
        lda     #$00                            ; 94FF A9 00                    ..
        sta     $0570,x                         ; 9501 9D 70 05                 .p.
L9504:  lda     $0378,x                         ; 9504 BD 78 03                 .x.
        pha                                     ; 9507 48                       H
        sec                                     ; 9508 38                       8
        sbc     #$1C                            ; 9509 E9 1C                    ..
        sta     $0378,x                         ; 950B 9D 78 03                 .x.
        lda     #$CE                            ; 950E A9 CE                    ..
        sta     $0408,x                         ; 9510 9D 08 04                 ...
        jsr     entity_hitbox_check                           ; 9513 20 F8 EF                  ..
        pla                                     ; 9516 68                       h
        sta     $0378,x                         ; 9517 9D 78 03                 .x.
        lda     #$8F                            ; 951A A9 8F                    ..
        sta     $0408,x                         ; 951C 9D 08 04                 ...
        bcs     L9528                           ; 951F B0 07                    ..
        lda     #$40                            ; 9521 A9 40                    .@
        sta     L0000                           ; 9523 85 00                    ..
        jmp     L809D                           ; 9525 4C 9D 80                 L..

; ----------------------------------------------------------------------------
L9528:  lda     $0468,x                         ; 9528 BD 68 04                 .h.
        beq     L9532                           ; 952B F0 05                    ..
        dec     $0468,x                         ; 952D DE 68 04                 .h.
        bne     L959B                           ; 9530 D0 69                    .i
L9532:  ldy     $0480,x                         ; 9532 BC 80 04                 ...
        lda     L959C,y                         ; 9535 B9 9C 95                 ...
        sta     $0468,x                         ; 9538 9D 68 04                 .h.
        lda     $0528,x                         ; 953B BD 28 05                 .(.
        and     #$20                            ; 953E 29 20                    ) 
        lsr     a                               ; 9540 4A                       J
        lsr     a                               ; 9541 4A                       J
        lsr     a                               ; 9542 4A                       J
        ora     $0480,x                         ; 9543 1D 80 04                 ...
        tay                                     ; 9546 A8                       .
        lda     L95A0,y                         ; 9547 B9 A0 95                 ...
        sta     $0E                             ; 954A 85 0E                    ..
        stx     $0F                             ; 954C 86 0F                    ..
        lda     #$48                            ; 954E A9 48                    .H
        jsr     queue_sound                           ; 9550 20 5D EC                  ].
        jsr     find_free_slot_y                           ; 9553 20 6F F1                  o.
        bcs     L958E                           ; 9556 B0 36                    .6
        lda     #$87                            ; 9558 A9 87                    ..
        sta     $0408,y                         ; 955A 99 08 04                 ...
        lda     #$9D                            ; 955D A9 9D                    ..
        sta     $0300,y                         ; 955F 99 00 03                 ...
        lda     #$13                            ; 9562 A9 13                    ..
        sta     $0D                             ; 9564 85 0D                    ..
        lda     $0528,x                         ; 9566 BD 28 05                 .(.
        and     #$20                            ; 9569 29 20                    ) 
        beq     L956F                           ; 956B F0 02                    ..
        inc     $0D                             ; 956D E6 0D                    ..
L956F:  lda     $0D                             ; 956F A5 0D                    ..
        sta     $10                             ; 9571 85 10                    ..
        lda     $0480,x                         ; 9573 BD 80 04                 ...
        clc                                     ; 9576 18                       .
        adc     #$8C                            ; 9577 69 8C                    i.
        jsr     entity_speed_preset                           ; 9579 20 F5 EA                  ..
        lda     $0378,y                         ; 957C B9 78 03                 .x.
        sec                                     ; 957F 38                       8
        sbc     #$0C                            ; 9580 E9 0C                    ..
        sta     $0378,y                         ; 9582 99 78 03                 .x.
        tya                                     ; 9585 98                       .
        tax                                     ; 9586 AA                       .
        ldy     $0E                             ; 9587 A4 0E                    ..
        lda     #$28                            ; 9589 A9 28                    .(
        jsr     entity_set_dir_velocity                           ; 958B 20 70 F4                  p.
L958E:  ldx     $0F                             ; 958E A6 0F                    ..
        inc     $0480,x                         ; 9590 FE 80 04                 ...
        lda     $0480,x                         ; 9593 BD 80 04                 ...
        and     #$03                            ; 9596 29 03                    ).
        sta     $0480,x                         ; 9598 9D 80 04                 ...
L959B:  rts                                     ; 959B 60                       `

; ----------------------------------------------------------------------------
L959C:  .byte   $14                             ; 959C 14                       .
        .byte   $14                             ; 959D 14                       .
        .byte   $14                             ; 959E 14                       .
        sei                                     ; 959F 78                       x
L95A0:  .byte   $0C                             ; 95A0 0C                       .
        .byte   $0B                             ; 95A1 0B                       .
        asl     a                               ; 95A2 0A                       .
        ora     #$04                            ; 95A3 09 04                    ..
        ora     $06                             ; 95A5 05 06                    ..
        .byte   $07                             ; 95A7 07                       .
        lda     $0570,x                         ; 95A8 BD 70 05                 .p.
        cmp     #$08                            ; 95AB C9 08                    ..
        bne     L95BE                           ; 95AD D0 0F                    ..
        lda     $0540,x                         ; 95AF BD 40 05                 .@.
        cmp     #$09                            ; 95B2 C9 09                    ..
        bne     L95BE                           ; 95B4 D0 08                    ..
        lda     $0528,x                         ; 95B6 BD 28 05                 .(.
        eor     #$20                            ; 95B9 49 20                    I 
        sta     $0528,x                         ; 95BB 9D 28 05                 .(.
L95BE:  lda     $0540,x                         ; 95BE BD 40 05                 .@.
        tay                                     ; 95C1 A8                       .
        cmp     #$02                            ; 95C2 C9 02                    ..
        bne     L95D0                           ; 95C4 D0 0A                    ..
        lda     $0570,x                         ; 95C6 BD 70 05                 .p.
        bne     L95D0                           ; 95C9 D0 05                    ..
        lda     #$38                            ; 95CB A9 38                    .8
        jsr     queue_sound                           ; 95CD 20 5D EC                  ].
L95D0:  lda     $0378,x                         ; 95D0 BD 78 03                 .x.
        sta     $0D                             ; 95D3 85 0D                    ..
        lda     $0528,x                         ; 95D5 BD 28 05                 .(.
        and     #$40                            ; 95D8 29 40                    )@
        bne     L95E4                           ; 95DA D0 08                    ..
        lda     $0D                             ; 95DC A5 0D                    ..
        clc                                     ; 95DE 18                       .
        adc     L9635,y                         ; 95DF 79 35 96                 y5.
        bne     L95EA                           ; 95E2 D0 06                    ..
L95E4:  lda     $0D                             ; 95E4 A5 0D                    ..
        sec                                     ; 95E6 38                       8
        sbc     L9635,y                         ; 95E7 F9 35 96                 .5.
L95EA:  sta     $0378,x                         ; 95EA 9D 78 03                 .x.
        lda     $0330,x                         ; 95ED BD 30 03                 .0.
        sta     $0E                             ; 95F0 85 0E                    ..
        lda     $0348,x                         ; 95F2 BD 48 03                 .H.
        sta     $0F                             ; 95F5 85 0F                    ..
        lda     $0528,x                         ; 95F7 BD 28 05                 .(.
        and     #$20                            ; 95FA 29 20                    ) 
        bne     L960D                           ; 95FC D0 0F                    ..
        lda     $0E                             ; 95FE A5 0E                    ..
        sec                                     ; 9600 38                       8
        sbc     L963F,y                         ; 9601 F9 3F 96                 .?.
        sta     $0330,x                         ; 9604 9D 30 03                 .0.
        lda     $0F                             ; 9607 A5 0F                    ..
        sbc     #$00                            ; 9609 E9 00                    ..
        bcs     L961A                           ; 960B B0 0D                    ..
L960D:  lda     $0E                             ; 960D A5 0E                    ..
        clc                                     ; 960F 18                       .
        adc     L963F,y                         ; 9610 79 3F 96                 y?.
        sta     $0330,x                         ; 9613 9D 30 03                 .0.
        lda     $0F                             ; 9616 A5 0F                    ..
        adc     #$00                            ; 9618 69 00                    i.
L961A:  sta     $0348,x                         ; 961A 9D 48 03                 .H.
        jsr     entity_player_collide                           ; 961D 20 87 EF                  ..
        bcs     L9625                           ; 9620 B0 03                    ..
        jsr     L82B8                           ; 9622 20 B8 82                  ..
L9625:  lda     $0D                             ; 9625 A5 0D                    ..
        sta     $0378,x                         ; 9627 9D 78 03                 .x.
        lda     $0E                             ; 962A A5 0E                    ..
        sta     $0330,x                         ; 962C 9D 30 03                 .0.
        lda     $0F                             ; 962F A5 0F                    ..
        sta     $0348,x                         ; 9631 9D 48 03                 .H.
        rts                                     ; 9634 60                       `

; ----------------------------------------------------------------------------
L9635:  .byte   $34                             ; 9635 34                       4
        bit     $08                             ; 9636 24 08                    $.
        php                                     ; 9638 08                       .
        php                                     ; 9639 08                       .
        php                                     ; 963A 08                       .
        php                                     ; 963B 08                       .
        php                                     ; 963C 08                       .
        php                                     ; 963D 08                       .
        .byte   $24                             ; 963E 24                       $
L963F:  brk                                     ; 963F 00                       .
        .byte   $1C                             ; 9640 1C                       .
        bit     $2C2C                           ; 9641 2C 2C 2C                 ,,,
        bit     $2C2C                           ; 9644 2C 2C 2C                 ,,,
        bit     $BD1C                           ; 9647 2C 1C BD                 ,..
        bpl     L9651                           ; 964A 10 05                    ..
        and     #$07                            ; 964C 29 07                    ).
        pha                                     ; 964E 48                       H
        and     #$01                            ; 964F 29 01                    ).
L9651:  tay                                     ; 9651 A8                       .
        lda     L96D4,y                         ; 9652 B9 D4 96                 ...
        sta     $0468,x                         ; 9655 9D 68 04                 .h.
        pla                                     ; 9658 68                       h
        asl     a                               ; 9659 0A                       .
        tay                                     ; 965A A8                       .
        lda     #$08                            ; 965B A9 08                    ..
        jsr     entity_set_dir_velocity                           ; 965D 20 70 F4                  p.
        lda     #$6A                            ; 9660 A9 6A                    .j
        sta     $0588,x                         ; 9662 9D 88 05                 ...
        lda     #$96                            ; 9665 A9 96                    ..
        sta     $05A0,x                         ; 9667 9D A0 05                 ...
        lda     $30                             ; 966A A5 30                    .0
        bne     L96D3                           ; 966C D0 65                    .e
        dec     $0378,x                         ; 966E DE 78 03                 .x.
        jsr     entity_player_collide                           ; 9671 20 87 EF                  ..
        inc     $0378,x                         ; 9674 FE 78 03                 .x.
        bcs     L96D3                           ; 9677 B0 5A                    .Z
        lda     #$83                            ; 9679 A9 83                    ..
        sta     $0588,x                         ; 967B 9D 88 05                 ...
        lda     #$96                            ; 967E A9 96                    ..
        sta     $05A0,x                         ; 9680 9D A0 05                 ...
        lda     $0480,x                         ; 9683 BD 80 04                 ...
        beq     L969A                           ; 9686 F0 12                    ..
        dec     $0480,x                         ; 9688 DE 80 04                 ...
        bne     L96D3                           ; 968B D0 46                    .F
        lda     #$D0                            ; 968D A9 D0                    ..
        .byte   $9D                             ; 968F 9D                       .
L9690:  dey                                     ; 9690 88                       .
        ora     $A9                             ; 9691 05 A9                    ..
        stx     $9D,y                           ; 9693 96 9D                    ..
        ldy     #$05                            ; 9695 A0 05                    ..
        jmp     entity_stop_y                           ; 9697 4C 1E EA                 L..

; ----------------------------------------------------------------------------
L969A:  lda     $30                             ; 969A A5 30                    .0
        bne     L96BC                           ; 969C D0 1E                    ..
        dec     $0378,x                         ; 969E DE 78 03                 .x.
        jsr     entity_player_collide                           ; 96A1 20 87 EF                  ..
        inc     $0378,x                         ; 96A4 FE 78 03                 .x.
        bcs     L96BC                           ; 96A7 B0 13                    ..
        lda     $0420,x                         ; 96A9 BD 20 04                 . .
        and     #$03                            ; 96AC 29 03                    ).
        beq     L96BC                           ; 96AE F0 0C                    ..
        sta     $39                             ; 96B0 85 39                    .9
        lda     $03A8,x                         ; 96B2 BD A8 03                 ...
        sta     $3A                             ; 96B5 85 3A                    .:
        lda     $03C0,x                         ; 96B7 BD C0 03                 ...
        sta     $3B                             ; 96BA 85 3B                    .;
L96BC:  jsr     entity_facing_dispatch                           ; 96BC 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; 96BF 20 86 EA                  ..
        jsr     L8526                           ; 96C2 20 26 85                  &.
        dec     $0468,x                         ; 96C5 DE 68 04                 .h.
        bne     L96D3                           ; 96C8 D0 09                    ..
        lda     #$1E                            ; 96CA A9 1E                    ..
        sta     $0480,x                         ; 96CC 9D 80 04                 ...
        rts                                     ; 96CF 60                       `

; ----------------------------------------------------------------------------
        jsr     entity_process_y_vel                           ; 96D0 20 68 E9                  h.
L96D3:  rts                                     ; 96D3 60                       `

; ----------------------------------------------------------------------------
L96D4:  rti                                     ; 96D4 40                       @

; ----------------------------------------------------------------------------
        sec                                     ; 96D5 38                       8
        jsr     entity_set_facing                           ; 96D6 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; 96D9 20 30 EC                  0.
        lda     $0480,x                         ; 96DC BD 80 04                 ...
        beq     L96E5                           ; 96DF F0 04                    ..
        dec     $0480,x                         ; 96E1 DE 80 04                 ...
        rts                                     ; 96E4 60                       `

; ----------------------------------------------------------------------------
L96E5:  lda     $14                             ; 96E5 A5 14                    ..
        and     #$40                            ; 96E7 29 40                    )@
        bne     L96F9                           ; 96E9 D0 0E                    ..
        jsr     entity_x_dist_px                           ; 96EB 20 94 EC                  ..
        cmp     #$5A                            ; 96EE C9 5A                    .Z
        bcs     L96D3                           ; 96F0 B0 E1                    ..
        jsr     entity_y_dist_abs                           ; 96F2 20 76 EC                  v.
        cmp     #$32                            ; 96F5 C9 32                    .2
        bcs     L96D3                           ; 96F7 B0 DA                    ..
L96F9:  jsr     L974E                           ; 96F9 20 4E 97                  N.
        jsr     entity_player_collide                           ; 96FC 20 87 EF                  ..
        bcs     L9706                           ; 96FF B0 05                    ..
        lda     #$FF                            ; 9701 A9 FF                    ..
        sta     $0468,x                         ; 9703 9D 68 04                 .h.
L9706:  ldy     #$1E                            ; 9706 A0 1E                    ..
        jsr     entity_gravity_collide                           ; 9708 20 B7 E7                  ..
        bcs     L971A                           ; 970B B0 0D                    ..
        ldy     #$24                            ; 970D A0 24                    .$
        jsr     entity_horiz_dispatch                           ; 970F 20 3F EA                  ?.
        bcc     L96D3                           ; 9712 90 BF                    ..
        inc     $0498,x                         ; 9714 FE 98 04                 ...
        jmp     entity_flip_direction                           ; 9717 4C 4A EC                 LJ.

; ----------------------------------------------------------------------------
L971A:  lda     #$38                            ; 971A A9 38                    .8
        cmp     $0558,x                         ; 971C DD 58 05                 .X.
        beq     L9729                           ; 971F F0 08                    ..
        jsr     entity_set_subtype                           ; 9721 20 98 EA                  ..
        lda     #$CB                            ; 9724 A9 CB                    ..
        sta     $0408,x                         ; 9726 9D 08 04                 ...
L9729:  lda     $0540,x                         ; 9729 BD 40 05                 .@.
        cmp     #$03                            ; 972C C9 03                    ..
        bne     L977C                           ; 972E D0 4C                    .L
        lda     $0498,x                         ; 9730 BD 98 04                 ...
        bne     L974E                           ; 9733 D0 19                    ..
        lda     $0468,x                         ; 9735 BD 68 04                 .h.
        beq     L974E                           ; 9738 F0 14                    ..
        lda     #$D6                            ; 973A A9 D6                    ..
        sta     $0588,x                         ; 973C 9D 88 05                 ...
        lda     #$96                            ; 973F A9 96                    ..
        sta     $05A0,x                         ; 9741 9D A0 05                 ...
        lda     #$5A                            ; 9744 A9 5A                    .Z
        sta     $0480,x                         ; 9746 9D 80 04                 ...
        lda     #$49                            ; 9749 A9 49                    .I
        jmp     entity_set_subtype                           ; 974B 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L974E:  lda     #$45                            ; 974E A9 45                    .E
        jsr     queue_sound                           ; 9750 20 5D EC                  ].
        lda     #$FC                            ; 9753 A9 FC                    ..
        sta     $0588,x                         ; 9755 9D 88 05                 ...
        lda     #$96                            ; 9758 A9 96                    ..
        sta     $05A0,x                         ; 975A 9D A0 05                 ...
        lda     #$00                            ; 975D A9 00                    ..
        sta     $03D8,x                         ; 975F 9D D8 03                 ...
        lda     #$04                            ; 9762 A9 04                    ..
        sta     $03F0,x                         ; 9764 9D F0 03                 ...
        lda     #$37                            ; 9767 A9 37                    .7
        jsr     entity_set_subtype                           ; 9769 20 98 EA                  ..
        lda     #$F1                            ; 976C A9 F1                    ..
        sta     $0408,x                         ; 976E 9D 08 04                 ...
        lda     #$00                            ; 9771 A9 00                    ..
        sta     $0468,x                         ; 9773 9D 68 04                 .h.
        sta     $0498,x                         ; 9776 9D 98 04                 ...
        sta     $04B0,x                         ; 9779 9D B0 04                 ...
L977C:  rts                                     ; 977C 60                       `

; ----------------------------------------------------------------------------
        ldy     $0480,x                         ; 977D BC 80 04                 ...
        lda     $0300,y                         ; 9780 B9 00 03                 ...
        cmp     #$25                            ; 9783 C9 25                    .%
        beq     L97BA                           ; 9785 F0 33                    .3
        jsr     entity_x_dist_px                           ; 9787 20 94 EC                  ..
        cmp     #$20                            ; 978A C9 20                    . 
        bcs     L97BA                           ; 978C B0 2C                    .,
        jsr     find_free_slot_y                           ; 978E 20 6F F1                  o.
        bcs     L97BA                           ; 9791 B0 27                    .'
        lda     #$D0                            ; 9793 A9 D0                    ..
L9795:  sta     $0408,y                         ; 9795 99 08 04                 ...
        lda     #$0A                            ; 9798 A9 0A                    ..
        sta     $0450,y                         ; 979A 99 50 04                 .P.
        lda     #$25                            ; 979D A9 25                    .%
        sta     $0300,y                         ; 979F 99 00 03                 ...
        lda     #$4F                            ; 97A2 A9 4F                    .O
        jsr     entity_init_pos                           ; 97A4 20 A4 EA                  ..
        lda     #$00                            ; 97A7 A9 00                    ..
        sta     $03D8,y                         ; 97A9 99 D8 03                 ...
        lda     #$05                            ; 97AC A9 05                    ..
        sta     $03F0,y                         ; 97AE 99 F0 03                 ...
        lda     #$19                            ; 97B1 A9 19                    ..
        sta     $0468,y                         ; 97B3 99 68 04                 .h.
        tya                                     ; 97B6 98                       .
        sta     $0480,x                         ; 97B7 9D 80 04                 ...
L97BA:  rts                                     ; 97BA 60                       `

; ----------------------------------------------------------------------------
        lda     $0540,x                         ; 97BB BD 40 05                 .@.
        bne     L97D3                           ; 97BE D0 13                    ..
        lda     #$00                            ; 97C0 A9 00                    ..
        sta     $0570,x                         ; 97C2 9D 70 05                 .p.
        jsr     entity_move_up_nofacing                           ; 97C5 20 4A E9                  J.
        dec     $0468,x                         ; 97C8 DE 68 04                 .h.
        bne     L97BA                           ; 97CB D0 ED                    ..
        lda     #$01                            ; 97CD A9 01                    ..
        sta     $0540,x                         ; 97CF 9D 40 05                 .@.
        rts                                     ; 97D2 60                       `

; ----------------------------------------------------------------------------
L97D3:  cmp     #$02                            ; 97D3 C9 02                    ..
        bne     L97BA                           ; 97D5 D0 E3                    ..
        lda     $0570,x                         ; 97D7 BD 70 05                 .p.
        cmp     #$0A                            ; 97DA C9 0A                    ..
        bne     L97BA                           ; 97DC D0 DC                    ..
        lda     #$51                            ; 97DE A9 51                    .Q
        jsr     entity_set_subtype                           ; 97E0 20 98 EA                  ..
        lda     #$01                            ; 97E3 A9 01                    ..
        sta     $03F0,x                         ; 97E5 9D F0 03                 ...
        lda     #$F2                            ; 97E8 A9 F2                    ..
        sta     $0588,x                         ; 97EA 9D 88 05                 ...
        lda     #$97                            ; 97ED A9 97                    ..
        sta     $05A0,x                         ; 97EF 9D A0 05                 ...
        jsr     entity_move_down_collide                           ; 97F2 20 2A E9                  *.
        rts                                     ; 97F5 60                       `

; ----------------------------------------------------------------------------
        lda     #$05                            ; 97F6 A9 05                    ..
        sta     $0588,x                         ; 97F8 9D 88 05                 ...
        lda     #$98                            ; 97FB A9 98                    ..
        sta     $05A0,x                         ; 97FD 9D A0 05                 ...
        lda     #$30                            ; 9800 A9 30                    .0
        sta     $0468,x                         ; 9802 9D 68 04                 .h.
        jsr     entity_facing_dispatch                           ; 9805 20 65 EA                  e.
        lda     $0468,x                         ; 9808 BD 68 04                 .h.
        bne     L9812                           ; 980B D0 05                    ..
        lda     #$60                            ; 980D A9 60                    .`
        sta     $0468,x                         ; 980F 9D 68 04                 .h.
L9812:  dec     $0468,x                         ; 9812 DE 68 04                 .h.
        bne     L9864                           ; 9815 D0 4D                    .M
        lda     #$68                            ; 9817 A9 68                    .h
        jsr     entity_set_subtype                           ; 9819 20 98 EA                  ..
        lda     #$26                            ; 981C A9 26                    .&
        .byte   $9D                             ; 981E 9D                       .
L981F:  dey                                     ; 981F 88                       .
        ora     $A9                             ; 9820 05 A9                    ..
        tya                                     ; 9822 98                       .
        sta     $05A0,x                         ; 9823 9D A0 05                 ...
        lda     $0570,x                         ; 9826 BD 70 05                 .p.
        cmp     #$04                            ; 9829 C9 04                    ..
        bne     L9864                           ; 982B D0 37                    .7
        lda     $0540,x                         ; 982D BD 40 05                 .@.
        tay                                     ; 9830 A8                       .
        cmp     #$10                            ; 9831 C9 10                    ..
        beq     L984D                           ; 9833 F0 18                    ..
        and     #$01                            ; 9835 29 01                    ).
        beq     L9864                           ; 9837 F0 2B                    .+
        tya                                     ; 9839 98                       .
        lsr     a                               ; 983A 4A                       J
        tay                                     ; 983B A8                       .
        lda     $0378,x                         ; 983C BD 78 03                 .x.
        clc                                     ; 983F 18                       .
        adc     L9865,y                         ; 9840 79 65 98                 ye.
        sta     $0378,x                         ; 9843 9D 78 03                 .x.
        lda     L986D,y                         ; 9846 B9 6D 98                 .m.
        sta     $0408,x                         ; 9849 9D 08 04                 ...
        rts                                     ; 984C 60                       `

; ----------------------------------------------------------------------------
L984D:  lda     #$67                            ; 984D A9 67                    .g
        jsr     entity_set_subtype                           ; 984F 20 98 EA                  ..
        lda     #$05                            ; 9852 A9 05                    ..
        sta     $0588,x                         ; 9854 9D 88 05                 ...
        lda     #$98                            ; 9857 A9 98                    ..
        sta     $05A0,x                         ; 9859 9D A0 05                 ...
        lda     #$C0                            ; 985C A9 C0                    ..
        sta     $0408,x                         ; 985E 9D 08 04                 ...
        jsr     entity_flip_direction                           ; 9861 20 4A EC                  J.
L9864:  rts                                     ; 9864 60                       `

; ----------------------------------------------------------------------------
L9865:  .byte   $FC                             ; 9865 FC                       .
        .byte   $FC                             ; 9866 FC                       .
        .byte   $FC                             ; 9867 FC                       .
        .byte   $FC                             ; 9868 FC                       .
        .byte   $04                             ; 9869 04                       .
        .byte   $04                             ; 986A 04                       .
        .byte   $04                             ; 986B 04                       .
        .byte   $04                             ; 986C 04                       .
L986D:  cpy     #$D0                            ; 986D C0 D0                    ..
        .byte   $D3                             ; 986F D3                       .
        .byte   $D4                             ; 9870 D4                       .
        cmp     $D4,x                           ; 9871 D5 D4                    ..
        .byte   $D3                             ; 9873 D3                       .
        bne     L981F                           ; 9874 D0 A9                    ..
        brk                                     ; 9876 00                       .
        sta     $0570,x                         ; 9877 9D 70 05                 .p.
        lda     $0528                           ; 987A AD 28 05                 .(.
        and     #$40                            ; 987D 29 40                    )@
        sta     L0000                           ; 987F 85 00                    ..
        lda     $0528,x                         ; 9881 BD 28 05                 .(.
        and     #$40                            ; 9884 29 40                    )@
        eor     L0000                           ; 9886 45 00                    E.
        bne     L98D0                           ; 9888 D0 46                    .F
        ldy     $0468,x                         ; 988A BC 68 04                 .h.
        beq     L9896                           ; 988D F0 07                    ..
        lda     $0300,y                         ; 988F B9 00 03                 ...
        cmp     #$29                            ; 9892 C9 29                    .)
        beq     L98F8                           ; 9894 F0 62                    .b
L9896:  jsr     find_free_slot_y                           ; 9896 20 6F F1                  o.
        bcs     L98F8                           ; 9899 B0 5D                    .]
        lda     #$C7                            ; 989B A9 C7                    ..
        sta     $0408,y                         ; 989D 99 08 04                 ...
        lda     #$01                            ; 98A0 A9 01                    ..
        sta     $0450,y                         ; 98A2 99 50 04                 .P.
        lda     #$29                            ; 98A5 A9 29                    .)
        sta     $0300,y                         ; 98A7 99 00 03                 ...
        lda     #$0C                            ; 98AA A9 0C                    ..
        sta     $0F                             ; 98AC 85 0F                    ..
        lda     $0528,x                         ; 98AE BD 28 05                 .(.
        and     #$40                            ; 98B1 29 40                    )@
        beq     L98B7                           ; 98B3 F0 02                    ..
        inc     $0F                             ; 98B5 E6 0F                    ..
L98B7:  lda     $0F                             ; 98B7 A5 0F                    ..
        sta     $10                             ; 98B9 85 10                    ..
        lda     #$54                            ; 98BB A9 54                    .T
        jsr     entity_speed_preset                           ; 98BD 20 F5 EA                  ..
        lda     $0528,x                         ; 98C0 BD 28 05                 .(.
        and     #$40                            ; 98C3 29 40                    )@
        ora     $0528,y                         ; 98C5 19 28 05                 .(.
        sta     $0528,y                         ; 98C8 99 28 05                 .(.
        tya                                     ; 98CB 98                       .
        sta     $0468,x                         ; 98CC 9D 68 04                 .h.
        rts                                     ; 98CF 60                       `

; ----------------------------------------------------------------------------
L98D0:  lda     #$DF                            ; 98D0 A9 DF                    ..
        sta     $0588,x                         ; 98D2 9D 88 05                 ...
        lda     #$98                            ; 98D5 A9 98                    ..
        sta     $05A0,x                         ; 98D7 9D A0 05                 ...
        lda     #$01                            ; 98DA A9 01                    ..
        sta     $0540,x                         ; 98DC 9D 40 05                 .@.
        lda     $0570,x                         ; 98DF BD 70 05                 .p.
        cmp     #$08                            ; 98E2 C9 08                    ..
        bne     L98F8                           ; 98E4 D0 12                    ..
        lda     $0528,x                         ; 98E6 BD 28 05                 .(.
        eor     #$40                            ; 98E9 49 40                    I@
        sta     $0528,x                         ; 98EB 9D 28 05                 .(.
        lda     #$75                            ; 98EE A9 75                    .u
        sta     $0588,x                         ; 98F0 9D 88 05                 ...
        lda     #$98                            ; 98F3 A9 98                    ..
        sta     $05A0,x                         ; 98F5 9D A0 05                 ...
L98F8:  rts                                     ; 98F8 60                       `

; ----------------------------------------------------------------------------
        lda     $0528,x                         ; 98F9 BD 28 05                 .(.
        and     #$40                            ; 98FC 29 40                    )@
        bne     L9921                           ; 98FE D0 21                    .!
        jsr     entity_stop_y                           ; 9900 20 1E EA                  ..
        lda     #$0D                            ; 9903 A9 0D                    ..
        sta     $0588,x                         ; 9905 9D 88 05                 ...
        lda     #$99                            ; 9908 A9 99                    ..
        sta     $05A0,x                         ; 990A 9D A0 05                 ...
        lda     #$00                            ; 990D A9 00                    ..
        sta     $0570,x                         ; 990F 9D 70 05                 .p.
        ldy     #$13                            ; 9912 A0 13                    ..
        jsr     entity_gravity_collide                           ; 9914 20 B7 E7                  ..
        bcs     L9940                           ; 9917 B0 27                    .'
L9919:  lda     $0390,x                         ; 9919 BD 90 03                 ...
        beq     L98F8                           ; 991C F0 DA                    ..
        jmp     entity_wipe_x                           ; 991E 4C C4 F2                 L..

; ----------------------------------------------------------------------------
L9921:  jsr     LEA29                           ; 9921 20 29 EA                  ).
        lda     #$2E                            ; 9924 A9 2E                    ..
        sta     $0588,x                         ; 9926 9D 88 05                 ...
        lda     #$99                            ; 9929 A9 99                    ..
        sta     $05A0,x                         ; 992B 9D A0 05                 ...
        lda     #$00                            ; 992E A9 00                    ..
        sta     $0570,x                         ; 9930 9D 70 05                 .p.
        jsr     entity_apply_gravity                           ; 9933 20 E1 E9                  ..
        jsr     LE999                           ; 9936 20 99 E9                  ..
        ldy     #$14                            ; 9939 A0 14                    ..
        jsr     LE7A8                           ; 993B 20 A8 E7                  ..
        bcc     L9919                           ; 993E 90 D9                    ..
L9940:  lda     #$F8                            ; 9940 A9 F8                    ..
        sta     $0588,x                         ; 9942 9D 88 05                 ...
        lda     #$98                            ; 9945 A9 98                    ..
        sta     $05A0,x                         ; 9947 9D A0 05                 ...
        lda     #$01                            ; 994A A9 01                    ..
        sta     $0540,x                         ; 994C 9D 40 05                 .@.
        rts                                     ; 994F 60                       `

; ----------------------------------------------------------------------------
        lda     #$00                            ; 9950 A9 00                    ..
        sta     $0570,x                         ; 9952 9D 70 05                 .p.
        inc     $0480,x                         ; 9955 FE 80 04                 ...
        lda     $0480,x                         ; 9958 BD 80 04                 ...
        cmp     #$78                            ; 995B C9 78                    .x
        bne     L99CB                           ; 995D D0 6C                    .l
        lda     #$01                            ; 995F A9 01                    ..
        sta     $0540,x                         ; 9961 9D 40 05                 .@.
        lda     #$6E                            ; 9964 A9 6E                    .n
        sta     $0588,x                         ; 9966 9D 88 05                 ...
        lda     #$99                            ; 9969 A9 99                    ..
        sta     $05A0,x                         ; 996B 9D A0 05                 ...
        lda     $0408,x                         ; 996E BD 08 04                 ...
        ora     #$40                            ; 9971 09 40                    .@
        sta     $0408,x                         ; 9973 9D 08 04                 ...
        lda     $0540,x                         ; 9976 BD 40 05                 .@.
        cmp     #$06                            ; 9979 C9 06                    ..
        bne     L9994                           ; 997B D0 17                    ..
        lda     $0570,x                         ; 997D BD 70 05                 .p.
        cmp     #$08                            ; 9980 C9 08                    ..
        bne     L99CB                           ; 9982 D0 47                    .G
        lda     #$50                            ; 9984 A9 50                    .P
        sta     $0588,x                         ; 9986 9D 88 05                 ...
        lda     #$99                            ; 9989 A9 99                    ..
        sta     $05A0,x                         ; 998B 9D A0 05                 ...
        lda     #$00                            ; 998E A9 00                    ..
        sta     $0480,x                         ; 9990 9D 80 04                 ...
        rts                                     ; 9993 60                       `

; ----------------------------------------------------------------------------
L9994:  cmp     #$03                            ; 9994 C9 03                    ..
        bne     L99FD                           ; 9996 D0 65                    .e
        lda     $0570,x                         ; 9998 BD 70 05                 .p.
        cmp     #$08                            ; 999B C9 08                    ..
        bne     L99FD                           ; 999D D0 5E                    .^
        jsr     find_free_slot_y                           ; 999F 20 6F F1                  o.
        bcs     L99CB                           ; 99A2 B0 27                    .'
        lda     #$87                            ; 99A4 A9 87                    ..
        sta     $0408,y                         ; 99A6 99 08 04                 ...
        lda     #$2C                            ; 99A9 A9 2C                    .,
        sta     $0300,y                         ; 99AB 99 00 03                 ...
        lda     $0420,x                         ; 99AE BD 20 04                 . .
        sta     $0420,y                         ; 99B1 99 20 04                 . .
        and     #$01                            ; 99B4 29 01                    ).
        clc                                     ; 99B6 18                       .
        adc     #$0E                            ; 99B7 69 0E                    i.
        sta     $10                             ; 99B9 85 10                    ..
        lda     #$57                            ; 99BB A9 57                    .W
        jsr     entity_speed_preset                           ; 99BD 20 F5 EA                  ..
        lda     #$00                            ; 99C0 A9 00                    ..
        sta     $03A8,y                         ; 99C2 99 A8 03                 ...
        lda     #$02                            ; 99C5 A9 02                    ..
        sta     $03C0,y                         ; 99C7 99 C0 03                 ...
        rts                                     ; 99CA 60                       `

; ----------------------------------------------------------------------------
L99CB:  lda     $32                             ; 99CB A5 32                    .2
        cmp     #$07                            ; 99CD C9 07                    ..
        beq     L99FD                           ; 99CF F0 2C                    .,
        jsr     entity_hitbox_check                           ; 99D1 20 F8 EF                  ..
        bcs     L99FD                           ; 99D4 B0 27                    .'
        lda     $0330,x                         ; 99D6 BD 30 03                 .0.
        sec                                     ; 99D9 38                       8
        sbc     $0330,y                         ; 99DA F9 30 03                 .0.
        lda     $0348,x                         ; 99DD BD 48 03                 .H.
        sbc     $0348,y                         ; 99E0 F9 48 03                 .H.
        bcs     L99EE                           ; 99E3 B0 09                    ..
        lda     $0528,x                         ; 99E5 BD 28 05                 .(.
        and     #$20                            ; 99E8 29 20                    ) 
        beq     L99FD                           ; 99EA F0 11                    ..
        bne     L99F5                           ; 99EC D0 07                    ..
L99EE:  lda     $0528,x                         ; 99EE BD 28 05                 .(.
        and     #$20                            ; 99F1 29 20                    ) 
        bne     L99FD                           ; 99F3 D0 08                    ..
L99F5:  lda     $0408,x                         ; 99F5 BD 08 04                 ...
        and     #$BF                            ; 99F8 29 BF                    ).
        sta     $0408,x                         ; 99FA 9D 08 04                 ...
L99FD:  rts                                     ; 99FD 60                       `

; ----------------------------------------------------------------------------
        jsr     L9BA5                           ; 99FE 20 A5 9B                  ..
        lda     $0540,x                         ; 9A01 BD 40 05                 .@.
        bne     L9A23                           ; 9A04 D0 1D                    ..
        lda     #$00                            ; 9A06 A9 00                    ..
        sta     $0570,x                         ; 9A08 9D 70 05                 .p.
        jsr     entity_set_facing                           ; 9A0B 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; 9A0E 20 30 EC                  0.
        jsr     entity_x_dist_px                           ; 9A11 20 94 EC                  ..
        cmp     #$40                            ; 9A14 C9 40                    .@
        bcs     L9A2F                           ; 9A16 B0 17                    ..
        lda     #$01                            ; 9A18 A9 01                    ..
        sta     $0540,x                         ; 9A1A 9D 40 05                 .@.
        lda     #$C1                            ; 9A1D A9 C1                    ..
        sta     $0408,x                         ; 9A1F 9D 08 04                 ...
        rts                                     ; 9A22 60                       `

; ----------------------------------------------------------------------------
L9A23:  cmp     #$03                            ; 9A23 C9 03                    ..
        bne     L9A2F                           ; 9A25 D0 08                    ..
        lda     #$0C                            ; 9A27 A9 0C                    ..
        sta     $0468,x                         ; 9A29 9D 68 04                 .h.
        jsr     L9B86                           ; 9A2C 20 86 9B                  ..
L9A2F:  rts                                     ; 9A2F 60                       `

; ----------------------------------------------------------------------------
        jsr     L9BA5                           ; 9A30 20 A5 9B                  ..
        lda     $0558,x                         ; 9A33 BD 58 05                 .X.
        cmp     #$99                            ; 9A36 C9 99                    ..
        bne     L9A46                           ; 9A38 D0 0C                    ..
        lda     $0540,x                         ; 9A3A BD 40 05                 .@.
        cmp     #$03                            ; 9A3D C9 03                    ..
        bne     L9A2F                           ; 9A3F D0 EE                    ..
        lda     #$9A                            ; 9A41 A9 9A                    ..
        jmp     entity_set_subtype                           ; 9A43 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L9A46:  lda     $0468,x                         ; 9A46 BD 68 04                 .h.
        beq     L9A61                           ; 9A49 F0 16                    ..
        dec     $0468,x                         ; 9A4B DE 68 04                 .h.
        bne     L9A61                           ; 9A4E D0 11                    ..
        lda     #$00                            ; 9A50 A9 00                    ..
        sta     L0000                           ; 9A52 85 00                    ..
        ldy     $04E0,x                         ; 9A54 BC E0 04                 ...
        lda     $0300,y                         ; 9A57 B9 00 03                 ...
        cmp     #$9F                            ; 9A5A C9 9F                    ..
        beq     L9A61                           ; 9A5C F0 03                    ..
        jsr     L9B35                           ; 9A5E 20 35 9B                  5.
L9A61:  jsr     L9B17                           ; 9A61 20 17 9B                  ..
        lda     $03F0,x                         ; 9A64 BD F0 03                 ...
        bpl     L9A2F                           ; 9A67 10 C6                    ..
        lda     $10                             ; 9A69 A5 10                    ..
        and     #$10                            ; 9A6B 29 10                    ).
        bne     L9A87                           ; 9A6D D0 18                    ..
        lda     #$BC                            ; 9A6F A9 BC                    ..
        sta     $0588,x                         ; 9A71 9D 88 05                 ...
        lda     #$9A                            ; 9A74 A9 9A                    ..
        sta     $05A0,x                         ; 9A76 9D A0 05                 ...
        lda     #$00                            ; 9A79 A9 00                    ..
        sta     $0570,x                         ; 9A7B 9D 70 05                 .p.
        sta     $0540,x                         ; 9A7E 9D 40 05                 .@.
        lda     #$0C                            ; 9A81 A9 0C                    ..
        sta     $0468,x                         ; 9A83 9D 68 04                 .h.
        rts                                     ; 9A86 60                       `

; ----------------------------------------------------------------------------
L9A87:  lda     #$9E                            ; 9A87 A9 9E                    ..
        sta     $0588,x                         ; 9A89 9D 88 05                 ...
        lda     #$9A                            ; 9A8C A9 9A                    ..
        sta     $05A0,x                         ; 9A8E 9D A0 05                 ...
        lda     #$00                            ; 9A91 A9 00                    ..
        sta     $03A8,x                         ; 9A93 9D A8 03                 ...
        sta     $03C0,x                         ; 9A96 9D C0 03                 ...
        lda     #$98                            ; 9A99 A9 98                    ..
        jmp     entity_set_subtype                           ; 9A9B 4C 98 EA                 L..

; ----------------------------------------------------------------------------
        jsr     L9BA5                           ; 9A9E 20 A5 9B                  ..
        lda     $0540,x                         ; 9AA1 BD 40 05                 .@.
        cmp     #$03                            ; 9AA4 C9 03                    ..
        bne     L9AAD                           ; 9AA6 D0 05                    ..
        lda     #$00                            ; 9AA8 A9 00                    ..
        sta     $0570,x                         ; 9AAA 9D 70 05                 .p.
L9AAD:  jsr     L9B17                           ; 9AAD 20 17 9B                  ..
        bcc     L9B16                           ; 9AB0 90 64                    .d
        lda     #$BC                            ; 9AB2 A9 BC                    ..
        sta     $0588,x                         ; 9AB4 9D 88 05                 ...
        lda     #$9A                            ; 9AB7 A9 9A                    ..
        sta     $05A0,x                         ; 9AB9 9D A0 05                 ...
        jsr     L9BA5                           ; 9ABC 20 A5 9B                  ..
        lda     $0558,x                         ; 9ABF BD 58 05                 .X.
        cmp     #$98                            ; 9AC2 C9 98                    ..
        beq     L9AE2                           ; 9AC4 F0 1C                    ..
        lda     #$00                            ; 9AC6 A9 00                    ..
        sta     $0570,x                         ; 9AC8 9D 70 05                 .p.
        lda     $04C8,x                         ; 9ACB BD C8 04                 ...
        bmi     L9AD8                           ; 9ACE 30 08                    0.
        dec     $0468,x                         ; 9AD0 DE 68 04                 .h.
        bne     L9AD8                           ; 9AD3 D0 03                    ..
        jmp     L9B76                           ; 9AD5 4C 76 9B                 Lv.

; ----------------------------------------------------------------------------
L9AD8:  jsr     L9B17                           ; 9AD8 20 17 9B                  ..
        bcc     L9B16                           ; 9ADB 90 39                    .9
        lda     #$98                            ; 9ADD A9 98                    ..
        jmp     entity_set_subtype                           ; 9ADF 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L9AE2:  lda     $04B0,x                         ; 9AE2 BD B0 04                 ...
        beq     L9B05                           ; 9AE5 F0 1E                    ..
        lda     #$00                            ; 9AE7 A9 00                    ..
        sta     $0570,x                         ; 9AE9 9D 70 05                 .p.
        dec     $04B0,x                         ; 9AEC DE B0 04                 ...
        bne     L9B16                           ; 9AEF D0 25                    .%
        lda     #$FE                            ; 9AF1 A9 FE                    ..
        sta     $0588,x                         ; 9AF3 9D 88 05                 ...
        lda     #$99                            ; 9AF6 A9 99                    ..
        sta     $05A0,x                         ; 9AF8 9D A0 05                 ...
        lda     #$00                            ; 9AFB A9 00                    ..
        sta     $04C8,x                         ; 9AFD 9D C8 04                 ...
        lda     #$99                            ; 9B00 A9 99                    ..
        jmp     entity_set_subtype                           ; 9B02 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L9B05:  lda     $0540,x                         ; 9B05 BD 40 05                 .@.
        cmp     #$03                            ; 9B08 C9 03                    ..
        bne     L9B16                           ; 9B0A D0 0A                    ..
        lda     #$40                            ; 9B0C A9 40                    .@
        sta     $04B0,x                         ; 9B0E 9D B0 04                 ...
        lda     #$91                            ; 9B11 A9 91                    ..
        sta     $0408,x                         ; 9B13 9D 08 04                 ...
L9B16:  rts                                     ; 9B16 60                       `

; ----------------------------------------------------------------------------
L9B17:  lda     #$15                            ; 9B17 A9 15                    ..
        sta     $A1                             ; 9B19 85 A1                    ..
        ldy     #$23                            ; 9B1B A0 23                    .#
        jsr     entity_gravity_collide                           ; 9B1D 20 B7 E7                  ..
        php                                     ; 9B20 08                       .
        lda     $03F0,x                         ; 9B21 BD F0 03                 ...
        bmi     L9B2F                           ; 9B24 30 09                    0.
        lda     $10                             ; 9B26 A5 10                    ..
        cmp     #$80                            ; 9B28 C9 80                    ..
        beq     L9B2F                           ; 9B2A F0 03                    ..
        jsr     entity_stop_y                           ; 9B2C 20 1E EA                  ..
L9B2F:  plp                                     ; 9B2F 28                       (
        lda     #$40                            ; 9B30 A9 40                    .@
        sta     $A1                             ; 9B32 85 A1                    ..
        rts                                     ; 9B34 60                       `

; ----------------------------------------------------------------------------
L9B35:  stx     $0F                             ; 9B35 86 0F                    ..
        lda     #$02                            ; 9B37 A9 02                    ..
        sta     $0E                             ; 9B39 85 0E                    ..
        lda     $0420,x                         ; 9B3B BD 20 04                 . .
        and     #$02                            ; 9B3E 29 02                    ).
        asl     a                               ; 9B40 0A                       .
        asl     a                               ; 9B41 0A                       .
        sta     $0D                             ; 9B42 85 0D                    ..
L9B44:  jsr     find_free_slot_y                           ; 9B44 20 6F F1                  o.
        bcs     L9B75                           ; 9B47 B0 2C                    .,
        lda     #$86                            ; 9B49 A9 86                    ..
        sta     $0408,y                         ; 9B4B 99 08 04                 ...
        lda     #$9F                            ; 9B4E A9 9F                    ..
        sta     $0300,y                         ; 9B50 99 00 03                 ...
        lda     #$9C                            ; 9B53 A9 9C                    ..
        jsr     entity_init_pos                           ; 9B55 20 A4 EA                  ..
        tya                                     ; 9B58 98                       .
        tax                                     ; 9B59 AA                       .
        inc     $0D                             ; 9B5A E6 0D                    ..
        inc     $0D                             ; 9B5C E6 0D                    ..
        lda     $0E                             ; 9B5E A5 0E                    ..
        cmp     #$01                            ; 9B60 C9 01                    ..
        bne     L9B68                           ; 9B62 D0 04                    ..
        tya                                     ; 9B64 98                       .
        sta     $04E0,x                         ; 9B65 9D E0 04                 ...
L9B68:  ldy     $0D                             ; 9B68 A4 0D                    ..
        lda     #$18                            ; 9B6A A9 18                    ..
        jsr     entity_set_dir_velocity                           ; 9B6C 20 70 F4                  p.
        ldx     $0F                             ; 9B6F A6 0F                    ..
        dec     $0E                             ; 9B71 C6 0E                    ..
        bpl     L9B44                           ; 9B73 10 CF                    ..
L9B75:  rts                                     ; 9B75 60                       `

; ----------------------------------------------------------------------------
L9B76:  lda     #$20                            ; 9B76 A9 20                    . 
        sta     $0468,x                         ; 9B78 9D 68 04                 .h.
        lda     $E6                             ; 9B7B A5 E6                    ..
        adc     $E7                             ; 9B7D 65 E7                    e.
        sta     $E7                             ; 9B7F 85 E7                    ..
        and     #$01                            ; 9B81 29 01                    ).
        beq     L9B86                           ; 9B83 F0 01                    ..
        rts                                     ; 9B85 60                       `

; ----------------------------------------------------------------------------
L9B86:  lda     #$95                            ; 9B86 A9 95                    ..
        sta     $03D8,x                         ; 9B88 9D D8 03                 ...
        .byte   $A9                             ; 9B8B A9                       .
L9B8C:  .byte   $02                             ; 9B8C 02                       .
        sta     $03F0,x                         ; 9B8D 9D F0 03                 ...
        lda     #$30                            ; 9B90 A9 30                    .0
        sta     $0588,x                         ; 9B92 9D 88 05                 ...
        lda     #$9A                            ; 9B95 A9 9A                    ..
        sta     $05A0,x                         ; 9B97 9D A0 05                 ...
        jsr     entity_set_facing                           ; 9B9A 20 16 EC                  ..
        .byte   $20                             ; 9B9D 20                        
L9B9E:  bmi     L9B8C                           ; 9B9E 30 EC                    0.
        lda     #$9A                            ; 9BA0 A9 9A                    ..
        jmp     entity_set_subtype                           ; 9BA2 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L9BA5:  lda     $0498,x                         ; 9BA5 BD 98 04                 ...
        beq     L9BAE                           ; 9BA8 F0 04                    ..
        dec     $0498,x                         ; 9BAA DE 98 04                 ...
        rts                                     ; 9BAD 60                       `

; ----------------------------------------------------------------------------
L9BAE:  lda     $0480,x                         ; 9BAE BD 80 04                 ...
        and     #$01                            ; 9BB1 29 01                    ).
        tay                                     ; 9BB3 A8                       .
        lda     L9BF1,y                         ; 9BB4 B9 F1 9B                 ...
        sta     $0498,x                         ; 9BB7 9D 98 04                 ...
        inc     $0480,x                         ; 9BBA FE 80 04                 ...
        jsr     find_free_slot_y                           ; 9BBD 20 6F F1                  o.
        bcs     L9BF0                           ; 9BC0 B0 2E                    ..
        lda     #$BF                            ; 9BC2 A9 BF                    ..
        sta     $0300,y                         ; 9BC4 99 00 03                 ...
        lda     #$00                            ; 9BC7 A9 00                    ..
        sta     $0408,y                         ; 9BC9 99 08 04                 ...
        lda     $0420,x                         ; 9BCC BD 20 04                 . .
        sta     $0420,y                         ; 9BCF 99 20 04                 . .
        and     #$01                            ; 9BD2 29 01                    ).
        clc                                     ; 9BD4 18                       .
        adc     #$46                            ; 9BD5 69 46                    iF
        sta     $10                             ; 9BD7 85 10                    ..
        lda     #$8C                            ; 9BD9 A9 8C                    ..
        jsr     entity_speed_preset                           ; 9BDB 20 F5 EA                  ..
        lda     $0528,y                         ; 9BDE B9 28 05                 .(.
        and     #$BF                            ; 9BE1 29 BF                    ).
        sta     $0528,y                         ; 9BE3 99 28 05                 .(.
        lda     #$00                            ; 9BE6 A9 00                    ..
        sta     $03D8,y                         ; 9BE8 99 D8 03                 ...
        lda     #$01                            ; 9BEB A9 01                    ..
        sta     $03F0,y                         ; 9BED 99 F0 03                 ...
L9BF0:  rts                                     ; 9BF0 60                       `

; ----------------------------------------------------------------------------
L9BF1:  sei                                     ; 9BF1 78                       x
        plp                                     ; 9BF2 28                       (
        ldy     #$06                            ; 9BF3 A0 06                    ..
        jsr     entity_move_up                           ; 9BF5 20 80 E7                  ..
        bcs     L9C05                           ; 9BF8 B0 0B                    ..
        lda     $10                             ; 9BFA A5 10                    ..
        cmp     #$80                            ; 9BFC C9 80                    ..
        bne     L9C05                           ; 9BFE D0 05                    ..
        lda     $0390,x                         ; 9C00 BD 90 03                 ...
        beq     L9BF0                           ; 9C03 F0 EB                    ..
L9C05:  jmp     entity_wipe_x                           ; 9C05 4C C4 F2                 L..

; ----------------------------------------------------------------------------
        lda     $0540,x                         ; 9C08 BD 40 05                 .@.
        bne     L9C5F                           ; 9C0B D0 52                    .R
        lda     $0570,x                         ; 9C0D BD 70 05                 .p.
        cmp     #$02                            ; 9C10 C9 02                    ..
        bne     L9C5F                           ; 9C12 D0 4B                    .K
        inc     $0468,x                         ; 9C14 FE 68 04                 .h.
        lda     $0468,x                         ; 9C17 BD 68 04                 .h.
        and     #$01                            ; 9C1A 29 01                    ).
        bne     L9C5F                           ; 9C1C D0 41                    .A
        lda     #$02                            ; 9C1E A9 02                    ..
        sta     $0E                             ; 9C20 85 0E                    ..
        stx     $0F                             ; 9C22 86 0F                    ..
L9C24:  jsr     find_free_slot_y                           ; 9C24 20 6F F1                  o.
        bcs     L9C5F                           ; 9C27 B0 36                    .6
        lda     #$C7                            ; 9C29 A9 C7                    ..
        sta     $0408,y                         ; 9C2B 99 08 04                 ...
        lda     #$01                            ; 9C2E A9 01                    ..
        sta     $0450,y                         ; 9C30 99 50 04                 .P.
        lda     #$32                            ; 9C33 A9 32                    .2
        sta     $0300,y                         ; 9C35 99 00 03                 ...
        lda     $0420,x                         ; 9C38 BD 20 04                 . .
        and     #$01                            ; 9C3B 29 01                    ).
        clc                                     ; 9C3D 18                       .
        adc     #$55                            ; 9C3E 69 55                    iU
        sta     $10                             ; 9C40 85 10                    ..
        lda     #$02                            ; 9C42 A9 02                    ..
        clc                                     ; 9C44 18                       .
        adc     $0E                             ; 9C45 65 0E                    e.
        jsr     entity_speed_preset                           ; 9C47 20 F5 EA                  ..
        sty     $0D                             ; 9C4A 84 0D                    ..
        ldx     $0E                             ; 9C4C A6 0E                    ..
        lda     L9C7D,x                         ; 9C4E BD 7D 9C                 .}.
        tay                                     ; 9C51 A8                       .
        ldx     $0D                             ; 9C52 A6 0D                    ..
        lda     #$10                            ; 9C54 A9 10                    ..
        jsr     entity_set_dir_velocity                           ; 9C56 20 70 F4                  p.
        ldx     $0F                             ; 9C59 A6 0F                    ..
        dec     $0E                             ; 9C5B C6 0E                    ..
        bpl     L9C24                           ; 9C5D 10 C5                    ..
L9C5F:  ldy     #$15                            ; 9C5F A0 15                    ..
        jsr     entity_gravity_collide                           ; 9C61 20 B7 E7                  ..
        lda     $0420,x                         ; 9C64 BD 20 04                 . .
        asl     a                               ; 9C67 0A                       .
        and     #$03                            ; 9C68 29 03                    ).
        tay                                     ; 9C6A A8                       .
        lda     $48,y                           ; 9C6B B9 48 00                 .H.
        and     #$10                            ; 9C6E 29 10                    ).
        beq     L9C79                           ; 9C70 F0 07                    ..
        ldy     #$16                            ; 9C72 A0 16                    ..
        jsr     entity_horiz_dispatch                           ; 9C74 20 3F EA                  ?.
        bcc     L9C7C                           ; 9C77 90 03                    ..
L9C79:  jsr     L852F                           ; 9C79 20 2F 85                  /.
L9C7C:  rts                                     ; 9C7C 60                       `

; ----------------------------------------------------------------------------
L9C7D:  asl     $0200                           ; 9C7D 0E 00 02                 ...
        jsr     entity_move_up_nofacing                           ; 9C80 20 4A E9                  J.
        jsr     entity_facing_dispatch                           ; 9C83 20 65 EA                  e.
        jsr     L8526                           ; 9C86 20 26 85                  &.
        rts                                     ; 9C89 60                       `

; ----------------------------------------------------------------------------
        lda     $0378                           ; 9C8A AD 78 03                 .x.
        pha                                     ; 9C8D 48                       H
        sec                                     ; 9C8E 38                       8
        sbc     #$20                            ; 9C8F E9 20                    . 
        bcs     L9C95                           ; 9C91 B0 02                    ..
        lda     #$00                            ; 9C93 A9 00                    ..
L9C95:  sta     $0378                           ; 9C95 8D 78 03                 .x.
        jsr     entity_x_dist_px                           ; 9C98 20 94 EC                  ..
        cmp     #$03                            ; 9C9B C9 03                    ..
        bcs     L9CA6                           ; 9C9D B0 07                    ..
        jsr     entity_y_dist_abs                           ; 9C9F 20 76 EC                  v.
        cmp     #$03                            ; 9CA2 C9 03                    ..
        bcc     L9CB9                           ; 9CA4 90 13                    ..
L9CA6:  jsr     entity_distance_calc                           ; 9CA6 20 C2 EC                  ..
        tay                                     ; 9CA9 A8                       .
        lda     #$08                            ; 9CAA A9 08                    ..
        jsr     entity_set_dir_velocity                           ; 9CAC 20 70 F4                  p.
        pla                                     ; 9CAF 68                       h
        sta     $0378                           ; 9CB0 8D 78 03                 .x.
L9CB3:  jsr     entity_facing_dispatch                           ; 9CB3 20 65 EA                  e.
        jmp     entity_vert_dispatch_raw                           ; 9CB6 4C 86 EA                 L..

; ----------------------------------------------------------------------------
L9CB9:  lda     $0378                           ; 9CB9 AD 78 03                 .x.
        sta     $0378,x                         ; 9CBC 9D 78 03                 .x.
        lda     $0330                           ; 9CBF AD 30 03                 .0.
        sta     $0330,x                         ; 9CC2 9D 30 03                 .0.
        lda     $0348                           ; 9CC5 AD 48 03                 .H.
        sta     $0348,x                         ; 9CC8 9D 48 03                 .H.
        pla                                     ; 9CCB 68                       h
        sta     $0378                           ; 9CCC 8D 78 03                 .x.
        lda     #$EA                            ; 9CCF A9 EA                    ..
        sta     $0588,x                         ; 9CD1 9D 88 05                 ...
        lda     #$9C                            ; 9CD4 A9 9C                    ..
        sta     $05A0,x                         ; 9CD6 9D A0 05                 ...
        lda     #$03                            ; 9CD9 A9 03                    ..
        sta     $0480,x                         ; 9CDB 9D 80 04                 ...
        lda     #$06                            ; 9CDE A9 06                    ..
        sta     $0498,x                         ; 9CE0 9D 98 04                 ...
        lda     #$0C                            ; 9CE3 A9 0C                    ..
        sta     $0468,x                         ; 9CE5 9D 68 04                 .h.
        bne     L9CFF                           ; 9CE8 D0 15                    ..
        lda     $0480,x                         ; 9CEA BD 80 04                 ...
        bne     L9D1C                           ; 9CED D0 2D                    .-
        lda     #$06                            ; 9CEF A9 06                    ..
        sta     $0480,x                         ; 9CF1 9D 80 04                 ...
        dec     $0468,x                         ; 9CF4 DE 68 04                 .h.
        lda     $0468,x                         ; 9CF7 BD 68 04                 .h.
        and     #$0F                            ; 9CFA 29 0F                    ).
        sta     $0468,x                         ; 9CFC 9D 68 04                 .h.
L9CFF:  pha                                     ; 9CFF 48                       H
        tay                                     ; 9D00 A8                       .
        lda     #$08                            ; 9D01 A9 08                    ..
        jsr     entity_set_dir_velocity                           ; 9D03 20 70 F4                  p.
        pla                                     ; 9D06 68                       h
        cmp     #$0C                            ; 9D07 C9 0C                    ..
        bne     L9D1C                           ; 9D09 D0 11                    ..
        dec     $0498,x                         ; 9D0B DE 98 04                 ...
        bne     L9D1C                           ; 9D0E D0 0C                    ..
        lda     #$B3                            ; 9D10 A9 B3                    ..
        sta     $0588,x                         ; 9D12 9D 88 05                 ...
        lda     #$9C                            ; 9D15 A9 9C                    ..
        sta     $05A0,x                         ; 9D17 9D A0 05                 ...
        bne     L9CB3                           ; 9D1A D0 97                    ..
L9D1C:  jsr     entity_facing_dispatch                           ; 9D1C 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; 9D1F 20 86 EA                  ..
        dec     $0480,x                         ; 9D22 DE 80 04                 ...
        lda     $0378                           ; 9D25 AD 78 03                 .x.
        sec                                     ; 9D28 38                       8
        sbc     $3E                             ; 9D29 E5 3E                    .>
        beq     L9D34                           ; 9D2B F0 07                    ..
        clc                                     ; 9D2D 18                       .
        adc     $0378,x                         ; 9D2E 7D 78 03                 }x.
        sta     $0378,x                         ; 9D31 9D 78 03                 .x.
L9D34:  lda     $0330                           ; 9D34 AD 30 03                 .0.
        sec                                     ; 9D37 38                       8
        sbc     $3C                             ; 9D38 E5 3C                    .<
        sta     L0000                           ; 9D3A 85 00                    ..
        lda     $0348                           ; 9D3C AD 48 03                 .H.
        sbc     $3D                             ; 9D3F E5 3D                    .=
        sta     $01                             ; 9D41 85 01                    ..
        ora     L0000                           ; 9D43 05 00                    ..
        beq     L9D58                           ; 9D45 F0 11                    ..
        lda     $0330,x                         ; 9D47 BD 30 03                 .0.
        clc                                     ; 9D4A 18                       .
        adc     L0000                           ; 9D4B 65 00                    e.
        sta     $0330,x                         ; 9D4D 9D 30 03                 .0.
        lda     $0348,x                         ; 9D50 BD 48 03                 .H.
        adc     $01                             ; 9D53 65 01                    e.
        sta     $0348,x                         ; 9D55 9D 48 03                 .H.
L9D58:  rts                                     ; 9D58 60                       `

; ----------------------------------------------------------------------------
        lda     $0510,x                         ; 9D59 BD 10 05                 ...
        and     #$01                            ; 9D5C 29 01                    ).
        clc                                     ; 9D5E 18                       .
        adc     #$01                            ; 9D5F 69 01                    i.
        sta     $0420,x                         ; 9D61 9D 20 04                 . .
        jsr     entity_facing_to_flags                           ; 9D64 20 30 EC                  0.
        lda     #$CF                            ; 9D67 A9 CF                    ..
        sta     $0588,x                         ; 9D69 9D 88 05                 ...
        lda     #$9D                            ; 9D6C A9 9D                    ..
        sta     $05A0,x                         ; 9D6E 9D A0 05                 ...
        lda     #$01                            ; 9D71 A9 01                    ..
        sta     $0420,x                         ; 9D73 9D 20 04                 . .
        lda     $0510,x                         ; 9D76 BD 10 05                 ...
        and     #$01                            ; 9D79 29 01                    ).
        bne     L9DCF                           ; 9D7B D0 52                    .R
        lda     $0528,x                         ; 9D7D BD 28 05                 .(.
        and     #$FB                            ; 9D80 29 FB                    ).
        sta     $0528,x                         ; 9D82 9D 28 05                 .(.
        lda     $FC                             ; 9D85 A5 FC                    ..
        sta     $0330,x                         ; 9D87 9D 30 03                 .0.
        lda     $F9                             ; 9D8A A5 F9                    ..
        sta     $0348,x                         ; 9D8C 9D 48 03                 .H.
        lda     #$9E                            ; 9D8F A9 9E                    ..
        sta     $0588,x                         ; 9D91 9D 88 05                 ...
        lda     #$9D                            ; 9D94 A9 9D                    ..
        sta     $05A0,x                         ; 9D96 9D A0 05                 ...
        lda     #$3C                            ; 9D99 A9 3C                    .<
        sta     $0468,x                         ; 9D9B 9D 68 04                 .h.
L9D9E:  dec     $0468,x                         ; 9D9E DE 68 04                 .h.
        bne     L9DCF                           ; 9DA1 D0 2C                    .,
        lda     #$3C                            ; 9DA3 A9 3C                    .<
        sta     $0468,x                         ; 9DA5 9D 68 04                 .h.
        jsr     find_free_slot_y                           ; 9DA8 20 6F F1                  o.
        bcs     L9DDA                           ; 9DAB B0 2D                    .-
        lda     #$87                            ; 9DAD A9 87                    ..
        sta     $0408,y                         ; 9DAF 99 08 04                 ...
        lda     #$37                            ; 9DB2 A9 37                    .7
        sta     $0300,y                         ; 9DB4 99 00 03                 ...
        lda     #$57                            ; 9DB7 A9 57                    .W
        sta     $10                             ; 9DB9 85 10                    ..
        lda     #$5B                            ; 9DBB A9 5B                    .[
        jsr     entity_speed_preset                           ; 9DBD 20 F5 EA                  ..
        lda     #$01                            ; 9DC0 A9 01                    ..
        sta     $0420,y                         ; 9DC2 99 20 04                 . .
        lda     #$00                            ; 9DC5 A9 00                    ..
        sta     $03A8,y                         ; 9DC7 99 A8 03                 ...
        lda     #$08                            ; 9DCA A9 08                    ..
        sta     $03C0,y                         ; 9DCC 99 C0 03                 ...
L9DCF:  lda     $0528,x                         ; 9DCF BD 28 05                 .(.
        pha                                     ; 9DD2 48                       H
        jsr     entity_facing_dispatch                           ; 9DD3 20 65 EA                  e.
        pla                                     ; 9DD6 68                       h
        sta     $0528,x                         ; 9DD7 9D 28 05                 .(.
L9DDA:  rts                                     ; 9DDA 60                       `

; ----------------------------------------------------------------------------
        lda     $0528,x                         ; 9DDB BD 28 05                 .(.
        and     #$FB                            ; 9DDE 29 FB                    ).
        sta     $0528,x                         ; 9DE0 9D 28 05                 .(.
        lda     $0378,x                         ; 9DE3 BD 78 03                 .x.
        sta     $0480,x                         ; 9DE6 9D 80 04                 ...
        lda     #$F3                            ; 9DE9 A9 F3                    ..
        sta     $0588,x                         ; 9DEB 9D 88 05                 ...
        lda     #$9D                            ; 9DEE A9 9D                    ..
        sta     $05A0,x                         ; 9DF0 9D A0 05                 ...
        lda     #$00                            ; 9DF3 A9 00                    ..
        sta     $0570,x                         ; 9DF5 9D 70 05                 .p.
        jsr     entity_set_facing                           ; 9DF8 20 16 EC                  ..
        jsr     entity_facing_to_flags                           ; 9DFB 20 30 EC                  0.
        lda     $0300,x                         ; 9DFE BD 00 03                 ...
        clc                                     ; 9E01 18                       .
        adc     #$01                            ; 9E02 69 01                    i.
        sta     L0000                           ; 9E04 85 00                    ..
        ldy     $0498,x                         ; 9E06 BC 98 04                 ...
        lda     $0300,y                         ; 9E09 B9 00 03                 ...
        cmp     L0000                           ; 9E0C C5 00                    ..
        beq     L9E49                           ; 9E0E F0 39                    .9
        lda     #$01                            ; 9E10 A9 01                    ..
        sta     $0540,x                         ; 9E12 9D 40 05                 .@.
        lda     #$27                            ; 9E15 A9 27                    .'
        sta     $0588,x                         ; 9E17 9D 88 05                 ...
        lda     #$9E                            ; 9E1A A9 9E                    ..
        sta     $05A0,x                         ; 9E1C 9D A0 05                 ...
        lda     $0300,x                         ; 9E1F BD 00 03                 ...
        and     #$01                            ; 9E22 29 01                    ).
        sta     $0468,x                         ; 9E24 9D 68 04                 .h.
        ldy     $0468,x                         ; 9E27 BC 68 04                 .h.
        lda     $0570,x                         ; 9E2A BD 70 05                 .p.
        cmp     L9EC6,y                         ; 9E2D D9 C6 9E                 ...
        bne     L9E49                           ; 9E30 D0 17                    ..
        lda     $0540,x                         ; 9E32 BD 40 05                 .@.
        cmp     L9EC8,y                         ; 9E35 D9 C8 9E                 ...
        beq     L9E4C                           ; 9E38 F0 12                    ..
        cmp     L9ECA,y                         ; 9E3A D9 CA 9E                 ...
        bne     L9E49                           ; 9E3D D0 0A                    ..
        lda     #$F3                            ; 9E3F A9 F3                    ..
        sta     $0588,x                         ; 9E41 9D 88 05                 ...
        lda     #$9D                            ; 9E44 A9 9D                    ..
        sta     $05A0,x                         ; 9E46 9D A0 05                 ...
L9E49:  jmp     L9EB2                           ; 9E49 4C B2 9E                 L..

; ----------------------------------------------------------------------------
L9E4C:  stx     $0F                             ; 9E4C 86 0F                    ..
        ldy     $0468,x                         ; 9E4E BC 68 04                 .h.
        lda     L9ECC,y                         ; 9E51 B9 CC 9E                 ...
        sta     $0D                             ; 9E54 85 0D                    ..
        jsr     find_free_slot_y                           ; 9E56 20 6F F1                  o.
        bcs     L9EB2                           ; 9E59 B0 57                    .W
        lda     #$01                            ; 9E5B A9 01                    ..
        sta     $0450,y                         ; 9E5D 99 50 04                 .P.
        lda     $0558,x                         ; 9E60 BD 58 05                 .X.
        cmp     #$90                            ; 9E63 C9 90                    ..
        bne     L9E6C                           ; 9E65 D0 05                    ..
        lda     #$02                            ; 9E67 A9 02                    ..
        sta     $0450,y                         ; 9E69 99 50 04                 .P.
L9E6C:  lda     $0468,x                         ; 9E6C BD 68 04                 .h.
        tax                                     ; 9E6F AA                       .
        lda     L9ECE,x                         ; 9E70 BD CE 9E                 ...
        sta     $0408,y                         ; 9E73 99 08 04                 ...
        ldx     $0F                             ; 9E76 A6 0F                    ..
        lda     $0558,x                         ; 9E78 BD 58 05                 .X.
        clc                                     ; 9E7B 18                       .
        adc     #$01                            ; 9E7C 69 01                    i.
        jsr     entity_init_pos                           ; 9E7E 20 A4 EA                  ..
        tya                                     ; 9E81 98                       .
        sta     $0498,x                         ; 9E82 9D 98 04                 ...
        lda     $0300,x                         ; 9E85 BD 00 03                 ...
        clc                                     ; 9E88 18                       .
        adc     #$01                            ; 9E89 69 01                    i.
        sta     $0300,y                         ; 9E8B 99 00 03                 ...
        lda     $0420,x                         ; 9E8E BD 20 04                 . .
        sta     $0420,y                         ; 9E91 99 20 04                 . .
        lda     $0378,x                         ; 9E94 BD 78 03                 .x.
        sec                                     ; 9E97 38                       8
        sbc     $0D                             ; 9E98 E5 0D                    ..
        sta     $0378,y                         ; 9E9A 99 78 03                 .x.
        lda     #$A8                            ; 9E9D A9 A8                    ..
        sta     $03D8,y                         ; 9E9F 99 D8 03                 ...
        lda     #$05                            ; 9EA2 A9 05                    ..
        sta     $03F0,y                         ; 9EA4 99 F0 03                 ...
        sty     $0E                             ; 9EA7 84 0E                    ..
        ldx     $0E                             ; 9EA9 A6 0E                    ..
        ldy     #$00                            ; 9EAB A0 00                    ..
        jsr     L854D                           ; 9EAD 20 4D 85                  M.
        ldx     $0F                             ; 9EB0 A6 0F                    ..
L9EB2:  lda     $26                             ; 9EB2 A5 26                    .&
        cmp     #$04                            ; 9EB4 C9 04                    ..
        bne     L9EC5                           ; 9EB6 D0 0D                    ..
        lda     $0480,x                         ; 9EB8 BD 80 04                 ...
        sec                                     ; 9EBB 38                       8
        sbc     $FA                             ; 9EBC E5 FA                    ..
        bcs     L9EC2                           ; 9EBE B0 02                    ..
        sbc     #$0F                            ; 9EC0 E9 0F                    ..
L9EC2:  sta     $0378,x                         ; 9EC2 9D 78 03                 .x.
L9EC5:  rts                                     ; 9EC5 60                       `

; ----------------------------------------------------------------------------
L9EC6:  .byte   $04                             ; 9EC6 04                       .
        php                                     ; 9EC7 08                       .
L9EC8:  .byte   $07                             ; 9EC8 07                       .
        .byte   $02                             ; 9EC9 02                       .
L9ECA:  asl     a                               ; 9ECA 0A                       .
        .byte   $05                             ; 9ECB 05                       .
L9ECC:  bpl     L9EE6                           ; 9ECC 10 18                    ..
L9ECE:  .byte   $87                             ; 9ECE 87                       .
        cmp     ($A0,x)                         ; 9ECF C1 A0                    ..
        .byte   $07                             ; 9ED1 07                       .
        jsr     entity_gravity_collide                           ; 9ED2 20 B7 E7                  ..
        bcs     L9EDE                           ; 9ED5 B0 07                    ..
        ldy     #$0E                            ; 9ED7 A0 0E                    ..
        jsr     entity_horiz_dispatch                           ; 9ED9 20 3F EA                  ?.
        bcc     L9EC5                           ; 9EDC 90 E7                    ..
L9EDE:  lda     $0558,x                         ; 9EDE BD 58 05                 .X.
        cmp     #$91                            ; 9EE1 C9 91                    ..
        bne     L9EFC                           ; 9EE3 D0 17                    ..
        .byte   $20                             ; 9EE5 20                        
L9EE6:  cpy     $F2                             ; 9EE6 C4 F2                    ..
        lda     #$5E                            ; 9EE8 A9 5E                    .^
        sta     $0300,x                         ; 9EEA 9D 00 03                 ...
        lda     #$81                            ; 9EED A9 81                    ..
        sta     $0408,x                         ; 9EEF 9D 08 04                 ...
        lda     #$2B                            ; 9EF2 A9 2B                    .+
        jsr     queue_sound                           ; 9EF4 20 5D EC                  ].
        lda     #$92                            ; 9EF7 A9 92                    ..
        jmp     entity_set_subtype                           ; 9EF9 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L9EFC:  jsr     LA56C                           ; 9EFC 20 6C A5                  l.
        lda     #$8C                            ; 9EFF A9 8C                    ..
        sta     $0300,x                         ; 9F01 9D 00 03                 ...
        lda     #$8B                            ; 9F04 A9 8B                    ..
        sta     $0408,x                         ; 9F06 9D 08 04                 ...
        rts                                     ; 9F09 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; 9F0A 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; 9F0B 00                       .
        brk                                     ; 9F0C 00                       .
        brk                                     ; 9F0D 00                       .
        brk                                     ; 9F0E 00                       .
        brk                                     ; 9F0F 00                       .
        brk                                     ; 9F10 00                       .
        brk                                     ; 9F11 00                       .
        brk                                     ; 9F12 00                       .
        brk                                     ; 9F13 00                       .
        brk                                     ; 9F14 00                       .
        brk                                     ; 9F15 00                       .
        brk                                     ; 9F16 00                       .
        brk                                     ; 9F17 00                       .
        brk                                     ; 9F18 00                       .
        brk                                     ; 9F19 00                       .
        brk                                     ; 9F1A 00                       .
        brk                                     ; 9F1B 00                       .
        brk                                     ; 9F1C 00                       .
        brk                                     ; 9F1D 00                       .
        ora     (L0000,x)                       ; 9F1E 01 00                    ..
        brk                                     ; 9F20 00                       .
        brk                                     ; 9F21 00                       .
        brk                                     ; 9F22 00                       .
        brk                                     ; 9F23 00                       .
        brk                                     ; 9F24 00                       .
        brk                                     ; 9F25 00                       .
        brk                                     ; 9F26 00                       .
        brk                                     ; 9F27 00                       .
        .byte   $04                             ; 9F28 04                       .
        bvc     L9F4B                           ; 9F29 50 20                    P 
        brk                                     ; 9F2B 00                       .
        rts                                     ; 9F2C 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; 9F2D 00                       .
        rti                                     ; 9F2E 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 9F2F 00                       .
        brk                                     ; 9F30 00                       .
        brk                                     ; 9F31 00                       .
        rti                                     ; 9F32 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 9F33 00                       .
        bpl     L9F36                           ; 9F34 10 00                    ..
L9F36:  brk                                     ; 9F36 00                       .
        brk                                     ; 9F37 00                       .
        .byte   $03                             ; 9F38 03                       .
        brk                                     ; 9F39 00                       .
        sta     ($40,x)                         ; 9F3A 81 40                    .@
        plp                                     ; 9F3C 28                       (
        brk                                     ; 9F3D 00                       .
        brk                                     ; 9F3E 00                       .
        rti                                     ; 9F3F 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 9F40 00                       .
        brk                                     ; 9F41 00                       .
        brk                                     ; 9F42 00                       .
        brk                                     ; 9F43 00                       .
        brk                                     ; 9F44 00                       .
        brk                                     ; 9F45 00                       .
        brk                                     ; 9F46 00                       .
        brk                                     ; 9F47 00                       .
        brk                                     ; 9F48 00                       .
        brk                                     ; 9F49 00                       .
        brk                                     ; 9F4A 00                       .
L9F4B:  brk                                     ; 9F4B 00                       .
        brk                                     ; 9F4C 00                       .
        brk                                     ; 9F4D 00                       .
        brk                                     ; 9F4E 00                       .
        brk                                     ; 9F4F 00                       .
        brk                                     ; 9F50 00                       .
        brk                                     ; 9F51 00                       .
        brk                                     ; 9F52 00                       .
        brk                                     ; 9F53 00                       .
        brk                                     ; 9F54 00                       .
        brk                                     ; 9F55 00                       .
        ora     (L0000,x)                       ; 9F56 01 00                    ..
        brk                                     ; 9F58 00                       .
        bpl     L9F5B                           ; 9F59 10 00                    ..
L9F5B:  brk                                     ; 9F5B 00                       .
        brk                                     ; 9F5C 00                       .
        brk                                     ; 9F5D 00                       .
        brk                                     ; 9F5E 00                       .
        brk                                     ; 9F5F 00                       .
        bpl     L9F62                           ; 9F60 10 00                    ..
L9F62:  brk                                     ; 9F62 00                       .
        brk                                     ; 9F63 00                       .
        brk                                     ; 9F64 00                       .
        brk                                     ; 9F65 00                       .
        brk                                     ; 9F66 00                       .
        brk                                     ; 9F67 00                       .
        bvc     L9F6A                           ; 9F68 50 00                    P.
L9F6A:  .byte   $04                             ; 9F6A 04                       .
L9F6B:  brk                                     ; 9F6B 00                       .
        brk                                     ; 9F6C 00                       .
        brk                                     ; 9F6D 00                       .
        .byte   $02                             ; 9F6E 02                       .
        bvc     L9F71                           ; 9F6F 50 00                    P.
L9F71:  ora     (L0000,x)                       ; 9F71 01 00                    ..
        brk                                     ; 9F73 00                       .
        ora     (L0000,x)                       ; 9F74 01 00                    ..
        bit     L0000                           ; 9F76 24 00                    $.
        bmi     L9F7A                           ; 9F78 30 00                    0.
L9F7A:  php                                     ; 9F7A 08                       .
        brk                                     ; 9F7B 00                       .
        brk                                     ; 9F7C 00                       .
        brk                                     ; 9F7D 00                       .
        .byte   $0C                             ; 9F7E 0C                       .
        ora     (L0000),y                       ; 9F7F 11 00                    ..
        brk                                     ; 9F81 00                       .
        brk                                     ; 9F82 00                       .
        brk                                     ; 9F83 00                       .
        brk                                     ; 9F84 00                       .
        brk                                     ; 9F85 00                       .
        brk                                     ; 9F86 00                       .
        brk                                     ; 9F87 00                       .
        brk                                     ; 9F88 00                       .
        brk                                     ; 9F89 00                       .
        brk                                     ; 9F8A 00                       .
        brk                                     ; 9F8B 00                       .
        brk                                     ; 9F8C 00                       .
        brk                                     ; 9F8D 00                       .
        brk                                     ; 9F8E 00                       .
        brk                                     ; 9F8F 00                       .
        brk                                     ; 9F90 00                       .
        brk                                     ; 9F91 00                       .
        php                                     ; 9F92 08                       .
        brk                                     ; 9F93 00                       .
        brk                                     ; 9F94 00                       .
        brk                                     ; 9F95 00                       .
        brk                                     ; 9F96 00                       .
        brk                                     ; 9F97 00                       .
        brk                                     ; 9F98 00                       .
        brk                                     ; 9F99 00                       .
        jsr     L0000                           ; 9F9A 20 00 00                  ..
        brk                                     ; 9F9D 00                       .
        brk                                     ; 9F9E 00                       .
        brk                                     ; 9F9F 00                       .
        brk                                     ; 9FA0 00                       .
        brk                                     ; 9FA1 00                       .
        bit     a:$04                           ; 9FA2 2C 04 00                 ,..
        brk                                     ; 9FA5 00                       .
        brk                                     ; 9FA6 00                       .
        brk                                     ; 9FA7 00                       .
        brk                                     ; 9FA8 00                       .
        brk                                     ; 9FA9 00                       .
        php                                     ; 9FAA 08                       .
        brk                                     ; 9FAB 00                       .
        .byte   $02                             ; 9FAC 02                       .
        brk                                     ; 9FAD 00                       .
        ora     (L0000,x)                       ; 9FAE 01 00                    ..
        .byte   $80                             ; 9FB0 80                       .
        rti                                     ; 9FB1 40                       @

; ----------------------------------------------------------------------------
        bpl     L9FF4                           ; 9FB2 10 40                    .@
        brk                                     ; 9FB4 00                       .
        brk                                     ; 9FB5 00                       .
        brk                                     ; 9FB6 00                       .
        brk                                     ; 9FB7 00                       .
        brk                                     ; 9FB8 00                       .
        brk                                     ; 9FB9 00                       .
        .byte   $82                             ; 9FBA 82                       .
        brk                                     ; 9FBB 00                       .
        .byte   $0C                             ; 9FBC 0C                       .
        brk                                     ; 9FBD 00                       .
        brk                                     ; 9FBE 00                       .
        rti                                     ; 9FBF 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 9FC0 00                       .
        brk                                     ; 9FC1 00                       .
        brk                                     ; 9FC2 00                       .
        brk                                     ; 9FC3 00                       .
        brk                                     ; 9FC4 00                       .
        brk                                     ; 9FC5 00                       .
        ora     (L0000,x)                       ; 9FC6 01 00                    ..
        brk                                     ; 9FC8 00                       .
        brk                                     ; 9FC9 00                       .
        brk                                     ; 9FCA 00                       .
        brk                                     ; 9FCB 00                       .
        bpl     L9FCE                           ; 9FCC 10 00                    ..
L9FCE:  brk                                     ; 9FCE 00                       .
        brk                                     ; 9FCF 00                       .
        brk                                     ; 9FD0 00                       .
        brk                                     ; 9FD1 00                       .
        brk                                     ; 9FD2 00                       .
        brk                                     ; 9FD3 00                       .
        brk                                     ; 9FD4 00                       .
        brk                                     ; 9FD5 00                       .
        ora     (L0000,x)                       ; 9FD6 01 00                    ..
        brk                                     ; 9FD8 00                       .
        brk                                     ; 9FD9 00                       .
        brk                                     ; 9FDA 00                       .
        brk                                     ; 9FDB 00                       .
        brk                                     ; 9FDC 00                       .
        ora     ($22,x)                         ; 9FDD 01 22                    ."
        .byte   $10,$40                    ; 9FDF 10 40   (branch out of range for ca65: target has no local label)
        bpl     L9F6B                           ; 9FE1 10 88                    ..
        rti                                     ; 9FE3 40                       @

; ----------------------------------------------------------------------------
        jsr     L4100                           ; 9FE4 20 00 41                  .A
        .byte   $04                             ; 9FE7 04                       .
        brk                                     ; 9FE8 00                       .
        brk                                     ; 9FE9 00                       .
        rts                                     ; 9FEA 60                       `

; ----------------------------------------------------------------------------
        .byte   $04                             ; 9FEB 04                       .
        bpl     L9FEE                           ; 9FEC 10 00                    ..
L9FEE:  php                                     ; 9FEE 08                       .
        brk                                     ; 9FEF 00                       .
        .byte   $04                             ; 9FF0 04                       .
        brk                                     ; 9FF1 00                       .
        .byte   $22                             ; 9FF2 22                       "
        .byte   $10                             ; 9FF3 10                       .
L9FF4:  brk                                     ; 9FF4 00                       .
        brk                                     ; 9FF5 00                       .
        brk                                     ; 9FF6 00                       .
        brk                                     ; 9FF7 00                       .
        jsr     L0000                           ; 9FF8 20 00 00                  ..
        brk                                     ; 9FFB 00                       .
        rti                                     ; 9FFC 40                       @

; ----------------------------------------------------------------------------
        .byte   $10,$02                    ; 9FFD 10 02   (branch out of range for ca65: target has no local label)
        .byte   $10                             ; 9FFF 10                       .
