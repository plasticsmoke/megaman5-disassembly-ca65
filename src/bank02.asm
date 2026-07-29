.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK02"

; =============================================================================
; BANK $02 (mapped at $8000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
; =============================================================================
L0000           := $0000
L0020           := $0020
L0021           := $0021
L0402           := $0402
L0F21           := $0F21
L1221           := $1221
L1626           := $1626
L1B12           := $1B12
L2000           := $2000
L202B           := $202B
L2221           := $2221
L5150           := $5150
L5A8A           := $5A8A
L6020           := $6020
L6040           := $6040
L6C57           := $6C57
L6C6C           := $6C6C
L70C0           := $70C0
LA060           := $A060
LA1CE           := $A1CE
LA1F6           := $A1F6
LA421           := $A421
LA469           := $A469
LA4B9           := $A4B9
LA4E4           := $A4E4
LA515           := $A515
LB022           := $B022
LB82B           := $B82B
LE700           := $E700
LE94A           := $E94A
LE968           := $E968
LEA65           := $EA65
LEA86           := $EA86
LEA98           := $EA98
LEAA4           := $EAA4
LEC16           := $EC16
LEC94           := $EC94
LECC2           := $ECC2
LEF87           := $EF87
LEFF8           := $EFF8
LF16F           := $F16F
LF2F3           := $F2F3
LF470           := $F470
; ----------------------------------------------------------------------------
        jsr     L84A6                           ; 8000 20 A6 84                  ..
        bcs     L8066                           ; 8003 B0 61                    .a
        lda     #$80                            ; 8005 A9 80                    ..
        sta     $1E                             ; 8007 85 1E                    ..
        lda     #$1D                            ; 8009 A9 1D                    ..
        sta     $23                             ; 800B 85 23                    .#
        .byte   $A9                             ; 800D A9                       .
L800E:  .byte   $17                             ; 800E 17                       .
        sta     $0588,x                         ; 800F 9D 88 05                 ...
        lda     #$A0                            ; 8012 A9 A0                    ..
        sta     $05A0,x                         ; 8014 9D A0 05                 ...
        lda     $1E                             ; 8017 A5 1E                    ..
        bne     L8066                           ; 8019 D0 4B                    .K
        sta     $9D                             ; 801B 85 9D                    ..
        sta     $78                             ; 801D 85 78                    .x
        sta     $79                             ; 801F 85 79                    .y
        lda     #$80                            ; 8021 A9 80                    ..
        sta     $9B                             ; 8023 85 9B                    ..
        lda     #$07                            ; 8025 A9 07                    ..
        sta     $99                             ; 8027 85 99                    ..
        lda     #$02                            ; 8029 A9 02                    ..
        sta     $FD                             ; 802B 85 FD                    ..
        lda     #$E8                            ; 802D A9 E8                    ..
        sta     $EB                             ; 802F 85 EB                    ..
        lda     #$40                            ; 8031 A9 40                    .@
        sta     $0588,x                         ; 8033 9D 88 05                 ...
        lda     #$A0                            ; 8036 A9 A0                    ..
        sta     $05A0,x                         ; 8038 9D A0 05                 ...
        lda     #$30                            ; 803B A9 30                    .0
        sta     $0468,x                         ; 803D 9D 68 04                 .h.
L8040:  lda     #$6F                            ; 8040 A9 6F                    .o
        sta     L0000                           ; 8042 85 00                    ..
        lda     #$A2                            ; 8044 A9 A2                    ..
        sta     $01                             ; 8046 85 01                    ..
        jsr     L8420                           ; 8048 20 20 84                   .
        bcs     L8066                           ; 804B B0 19                    ..
        .byte   $A9                             ; 804D A9                       .
L804E:  .byte   $67                             ; 804E 67                       g
        sta     $0588,x                         ; 804F 9D 88 05                 ...
        lda     #$A0                            ; 8052 A9 A0                    ..
        sta     $05A0,x                         ; 8054 9D A0 05                 ...
        lda     #$D2                            ; 8057 A9 D2                    ..
        sta     $0468,x                         ; 8059 9D 68 04                 .h.
        lda     #$02                            ; 805C A9 02                    ..
        sta     $0540,x                         ; 805E 9D 40 05                 .@.
        lda     #$00                            ; 8061 A9 00                    ..
        sta     $0570,x                         ; 8063 9D 70 05                 .p.
L8066:  rts                                     ; 8066 60                       `

; ----------------------------------------------------------------------------
        lda     $0468,x                         ; 8067 BD 68 04                 .h.
        bne     L80CF                           ; 806A D0 63                    .c
        lda     #$D2                            ; 806C A9 D2                    ..
        .byte   $9D                             ; 806E 9D                       .
        pla                                     ; 806F 68                       h
L8070:  .byte   $04                             ; 8070 04                       .
        lda     $E4                             ; 8071 A5 E4                    ..
        adc     $E7                             ; 8073 65 E7                    e.
        and     #$03                            ; 8075 29 03                    ).
        beq     L807B                           ; 8077 F0 02                    ..
        lda     #$01                            ; 8079 A9 01                    ..
L807B:  sta     $11                             ; 807B 85 11                    ..
        sta     $12                             ; 807D 85 12                    ..
L807F:  jsr     LF16F                           ; 807F 20 6F F1                  o.
        bcs     L80CF                           ; 8082 B0 4B                    .K
        lda     #$BE                            ; 8084 A9 BE                    ..
        jsr     LEAA4                           ; 8086 20 A4 EA                  ..
        lda     #$7B                            ; 8089 A9 7B                    .{
        sta     $0300,y                         ; 808B 99 00 03                 ...
        lda     #$34                            ; 808E A9 34                    .4
        sta     $0378,y                         ; 8090 99 78 03                 .x.
        lda     #$D8                            ; 8093 A9 D8                    ..
        sta     $0330,y                         ; 8095 99 30 03                 .0.
        lda     #$00                            ; 8098 A9 00                    ..
        sta     $03D8,y                         ; 809A 99 D8 03                 ...
        lda     #$02                            ; 809D A9 02                    ..
        sta     $03F0,y                         ; 809F 99 F0 03                 ...
        lda     $E4                             ; 80A2 A5 E4                    ..
        adc     $E5                             ; 80A4 65 E5                    e.
        sta     $E4                             ; 80A6 85 E4                    ..
        and     #$07                            ; 80A8 29 07                    ).
        tax                                     ; 80AA AA                       .
        lda     $A283,x                         ; 80AB BD 83 A2                 ...
L80AE:  cmp     $12                             ; 80AE C5 12                    ..
        bne     L80BA                           ; 80B0 D0 08                    ..
        inx                                     ; 80B2 E8                       .
        txa                                     ; 80B3 8A                       .
        and     #$07                            ; 80B4 29 07                    ).
        tax                                     ; 80B6 AA                       .
        lda     $A283,x                         ; 80B7 BD 83 A2                 ...
L80BA:  sta     $0468,y                         ; 80BA 99 68 04                 .h.
        sta     $12                             ; 80BD 85 12                    ..
        lda     #$C0                            ; 80BF A9 C0                    ..
        sta     $0408,y                         ; 80C1 99 08 04                 ...
        lda     #$01                            ; 80C4 A9 01                    ..
        sta     $0450,y                         ; 80C6 99 50 04                 .P.
        ldx     $A6                             ; 80C9 A6 A6                    ..
        dec     $11                             ; 80CB C6 11                    ..
        bpl     L807F                           ; 80CD 10 B0                    ..
L80CF:  dec     $0468,x                         ; 80CF DE 68 04                 .h.
        lda     #$C2                            ; 80D2 A9 C2                    ..
        ldy     $78                             ; 80D4 A4 78                    .x
        beq     L80DC                           ; 80D6 F0 04                    ..
        cpy     #$FF                            ; 80D8 C0 FF                    ..
        bne     L80E6                           ; 80DA D0 0A                    ..
L80DC:  ldy     $79                             ; 80DC A4 79                    .y
        beq     L80E4                           ; 80DE F0 04                    ..
        cpy     #$FF                            ; 80E0 C0 FF                    ..
        bne     L80E6                           ; 80E2 D0 02                    ..
L80E4:  lda     #$C3                            ; 80E4 A9 C3                    ..
L80E6:  cmp     $0558,x                         ; 80E6 DD 58 05                 .X.
        beq     L80EE                           ; 80E9 F0 03                    ..
        jsr     LEA98                           ; 80EB 20 98 EA                  ..
L80EE:  lda     $0540,x                         ; 80EE BD 40 05                 .@.
        cmp     #$02                            ; 80F1 C9 02                    ..
        bne     L80FA                           ; 80F3 D0 05                    ..
        lda     #$00                            ; 80F5 A9 00                    ..
        sta     $0570,x                         ; 80F7 9D 70 05                 .p.
L80FA:  lda     #$03                            ; 80FA A9 03                    ..
        ldy     $0558,x                         ; 80FC BC 58 05                 .X.
        cpy     #$C3                            ; 80FF C0 C3                    ..
        beq     L8105                           ; 8101 F0 02                    ..
        lda     #$00                            ; 8103 A9 00                    ..
L8105:  clc                                     ; 8105 18                       .
        adc     $0540,x                         ; 8106 7D 40 05                 }@.
        tay                                     ; 8109 A8                       .
        lda     $0408,x                         ; 810A BD 08 04                 ...
        and     #$BF                            ; 810D 29 BF                    ).
        ora     $A28B,y                         ; 810F 19 8B A2                 ...
        sta     $0408,x                         ; 8112 9D 08 04                 ...
L8115:  rts                                     ; 8115 60                       `

; ----------------------------------------------------------------------------
        lda     $2F                             ; 8116 A5 2F                    ./
        bpl     L8115                           ; 8118 10 FB                    ..
        lda     $30                             ; 811A A5 30                    .0
        cmp     #$08                            ; 811C C9 08                    ..
        bcs     L8115                           ; 811E B0 F5                    ..
        lda     $32                             ; 8120 A5 32                    .2
        cmp     #$07                            ; 8122 C9 07                    ..
        beq     L8115                           ; 8124 F0 EF                    ..
        jsr     LEFF8                           ; 8126 20 F8 EF                  ..
        bcc     L812E                           ; 8129 90 03                    ..
        jmp     LA1CE                           ; 812B 4C CE A1                 L..

; ----------------------------------------------------------------------------
L812E:  ldy     $10                             ; 812E A4 10                    ..
        jsr     LF2F3                           ; 8130 20 F3 F2                  ..
        lda     #$02                            ; 8133 A9 02                    ..
        sta     $0420,x                         ; 8135 9D 20 04                 . .
        lda     #$00                            ; 8138 A9 00                    ..
        sta     $03A8,x                         ; 813A 9D A8 03                 ...
        lda     #$04                            ; 813D A9 04                    ..
        sta     $03C0,x                         ; 813F 9D C0 03                 ...
        lda     #$4C                            ; 8142 A9 4C                    .L
        sta     $0588,x                         ; 8144 9D 88 05                 ...
        lda     #$A1                            ; 8147 A9 A1                    ..
        sta     $05A0,x                         ; 8149 9D A0 05                 ...
        .byte   $20                             ; 814C 20                        
        .byte   $F6                             ; 814D F6                       .
L814E:  lda     ($BD,x)                         ; 814E A1 BD                    ..
        .byte   $30,$03                    ; 8150 30 03   (branch out of range for ca65: target has no local label)
        cmp     #$20                            ; 8152 C9 20                    . 
        bne     L81CE                           ; 8154 D0 78                    .x
        lda     #$1E                            ; 8156 A9 1E                    ..
        sta     $0468,x                         ; 8158 9D 68 04                 .h.
        lda     #$65                            ; 815B A9 65                    .e
        sta     $0588,x                         ; 815D 9D 88 05                 ...
        lda     #$A1                            ; 8160 A9 A1                    ..
        sta     $05A0,x                         ; 8162 9D A0 05                 ...
        lda     $0468,x                         ; 8165 BD 68 04                 .h.
        cmp     #$14                            ; 8168 C9 14                    ..
        bcc     L817A                           ; 816A 90 0E                    ..
        and     #$01                            ; 816C 29 01                    ).
        sta     L0000                           ; 816E 85 00                    ..
        lda     $0330,x                         ; 8170 BD 30 03                 .0.
        and     #$F0                            ; 8173 29 F0                    ).
        ora     L0000                           ; 8175 05 00                    ..
        sta     $0330,x                         ; 8177 9D 30 03                 .0.
L817A:  dec     $0468,x                         ; 817A DE 68 04                 .h.
        bne     L81CE                           ; 817D D0 4F                    .O
        lda     #$01                            ; 817F A9 01                    ..
        sta     $0420,x                         ; 8181 9D 20 04                 . .
        lda     #$02                            ; 8184 A9 02                    ..
        sta     $03C0,x                         ; 8186 9D C0 03                 ...
        lda     #$93                            ; 8189 A9 93                    ..
        sta     $0588,x                         ; 818B 9D 88 05                 ...
        lda     #$A1                            ; 818E A9 A1                    ..
        sta     $05A0,x                         ; 8190 9D A0 05                 ...
        jsr     LA1F6                           ; 8193 20 F6 A1                  ..
        lda     $0330,x                         ; 8196 BD 30 03                 .0.
        cmp     #$D8                            ; 8199 C9 D8                    ..
        bne     L81CE                           ; 819B D0 31                    .1
        lda     #$AC                            ; 819D A9 AC                    ..
        sta     $0588,x                         ; 819F 9D 88 05                 ...
        lda     #$A1                            ; 81A2 A9 A1                    ..
        sta     $05A0,x                         ; 81A4 9D A0 05                 ...
        lda     #$06                            ; 81A7 A9 06                    ..
        sta     $0468,x                         ; 81A9 9D 68 04                 .h.
        dec     $0468,x                         ; 81AC DE 68 04                 .h.
        lda     $0468,x                         ; 81AF BD 68 04                 .h.
        pha                                     ; 81B2 48                       H
        and     #$01                            ; 81B3 29 01                    ).
        sta     L0000                           ; 81B5 85 00                    ..
        lda     $0330,x                         ; 81B7 BD 30 03                 .0.
        and     #$F8                            ; 81BA 29 F8                    ).
        ora     L0000                           ; 81BC 05 00                    ..
        sta     $0330,x                         ; 81BE 9D 30 03                 .0.
        pla                                     ; 81C1 68                       h
        bne     L81CE                           ; 81C2 D0 0A                    ..
        lda     #$16                            ; 81C4 A9 16                    ..
        sta     $0588,x                         ; 81C6 9D 88 05                 ...
        lda     #$A1                            ; 81C9 A9 A1                    ..
        sta     $05A0,x                         ; 81CB 9D A0 05                 ...
L81CE:  ldy     #$00                            ; 81CE A0 00                    ..
        lda     $0378,x                         ; 81D0 BD 78 03                 .x.
        cmp     #$90                            ; 81D3 C9 90                    ..
        beq     L81D8                           ; 81D5 F0 01                    ..
        iny                                     ; 81D7 C8                       .
L81D8:  lda     #$D8                            ; 81D8 A9 D8                    ..
        sec                                     ; 81DA 38                       8
        sbc     $0330,x                         ; 81DB FD 30 03                 .0.
        sta     $78,y                           ; 81DE 99 78 00                 .x.
        lda     $0408,x                         ; 81E1 BD 08 04                 ...
        pha                                     ; 81E4 48                       H
        lda     #$B2                            ; 81E5 A9 B2                    ..
        sta     $0408,x                         ; 81E7 9D 08 04                 ...
        jsr     LEF87                           ; 81EA 20 87 EF                  ..
        pla                                     ; 81ED 68                       h
        sta     $0408,x                         ; 81EE 9D 08 04                 ...
        bcs     L8213                           ; 81F1 B0 20                    . 
        jmp     L82B8                           ; 81F3 4C B8 82                 L..

; ----------------------------------------------------------------------------
        jsr     LEA65                           ; 81F6 20 65 EA                  e.
        dec     $0378,x                         ; 81F9 DE 78 03                 .x.
        jsr     LEF87                           ; 81FC 20 87 EF                  ..
        inc     $0378,x                         ; 81FF FE 78 03                 .x.
        bcs     L8213                           ; 8202 B0 0F                    ..
        lda     $0420,x                         ; 8204 BD 20 04                 . .
        sta     $39                             ; 8207 85 39                    .9
        lda     $03A8,x                         ; 8209 BD A8 03                 ...
        sta     $3A                             ; 820C 85 3A                    .:
        lda     $03C0,x                         ; 820E BD C0 03                 ...
        sta     $3B                             ; 8211 85 3B                    .;
L8213:  rts                                     ; 8213 60                       `

; ----------------------------------------------------------------------------
        jsr     LE94A                           ; 8214 20 4A E9                  J.
        lda     $0390,x                         ; 8217 BD 90 03                 ...
        beq     L826E                           ; 821A F0 52                    .R
        lda     #$00                            ; 821C A9 00                    ..
        sta     $0390,x                         ; 821E 9D 90 03                 ...
        sta     $0378,x                         ; 8221 9D 78 03                 .x.
        lda     $0468,x                         ; 8224 BD 68 04                 .h.
        sta     $0330,x                         ; 8227 9D 30 03                 .0.
        lda     #$6A                            ; 822A A9 6A                    .j
        sta     $03A8,x                         ; 822C 9D A8 03                 ...
        sta     $03D8,x                         ; 822F 9D D8 03                 ...
        lda     #$01                            ; 8232 A9 01                    ..
        sta     $03C0,x                         ; 8234 9D C0 03                 ...
        sta     $03F0,x                         ; 8237 9D F0 03                 ...
        lda     #$06                            ; 823A A9 06                    ..
        sta     $0420,x                         ; 823C 9D 20 04                 . .
        lda     #$16                            ; 823F A9 16                    ..
        sta     $0468,x                         ; 8241 9D 68 04                 .h.
        lda     #$4E                            ; 8244 A9 4E                    .N
        sta     $0588,x                         ; 8246 9D 88 05                 ...
        lda     #$A2                            ; 8249 A9 A2                    ..
        sta     $05A0,x                         ; 824B 9D A0 05                 ...
        lda     $0528,x                         ; 824E BD 28 05                 .(.
        pha                                     ; 8251 48                       H
        jsr     LEA65                           ; 8252 20 65 EA                  e.
        jsr     LEA86                           ; 8255 20 86 EA                  ..
        pla                                     ; 8258 68                       h
        sta     $0528,x                         ; 8259 9D 28 05                 .(.
        dec     $0468,x                         ; 825C DE 68 04                 .h.
        bne     L826E                           ; 825F D0 0D                    ..
        lda     #$16                            ; 8261 A9 16                    ..
        sta     $0468,x                         ; 8263 9D 68 04                 .h.
        lda     $0420,x                         ; 8266 BD 20 04                 . .
        eor     #$03                            ; 8269 49 03                    I.
        sta     $0420,x                         ; 826B 9D 20 04                 . .
L826E:  rts                                     ; 826E 60                       `

; ----------------------------------------------------------------------------
        .byte   $0F                             ; 826F 0F                       .
        rol     $16,x                           ; 8270 36 16                    6.
        asl     $0F                             ; 8272 06 0F                    ..
        bmi     L8286                           ; 8274 30 10                    0.
        brk                                     ; 8276 00                       .
        .byte   $0F                             ; 8277 0F                       .
        bmi     L829B                           ; 8278 30 21                    0!
        ora     ($0F),y                         ; 827A 11 0F                    ..
        .byte   $0F                             ; 827C 0F                       .
        jsr     L0F21                           ; 827D 20 21 0F                  !.
        .byte   $0F                             ; 8280 0F                       .
        jsr     L202B                           ; 8281 20 2B 20                  + 
        rts                                     ; 8284 60                       `

; ----------------------------------------------------------------------------
        .byte   $A0                             ; 8285 A0                       .
L8286:  rti                                     ; 8286 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; 8287 80                       .
        jsr     LA060                           ; 8288 20 60 A0                  `.
        brk                                     ; 828B 00                       .
        brk                                     ; 828C 00                       .
        rti                                     ; 828D 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; 828E 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 828F 00                       .
        brk                                     ; 8290 00                       .
        jsr     L84A6                           ; 8291 20 A6 84                  ..
        bcs     L826E                           ; 8294 B0 D8                    ..
        lda     #$80                            ; 8296 A9 80                    ..
        sta     $1E                             ; 8298 85 1E                    ..
        .byte   $A9                             ; 829A A9                       .
L829B:  ora     $2385,y                         ; 829B 19 85 23                 ..#
        lda     #$A8                            ; 829E A9 A8                    ..
        sta     $0588,x                         ; 82A0 9D 88 05                 ...
        lda     #$A2                            ; 82A3 A9 A2                    ..
        sta     $05A0,x                         ; 82A5 9D A0 05                 ...
        lda     $1E                             ; 82A8 A5 1E                    ..
        bne     L826E                           ; 82AA D0 C2                    ..
        jsr     L84D5                           ; 82AC 20 D5 84                  ..
        lda     #$EA                            ; 82AF A9 EA                    ..
        sta     $EA                             ; 82B1 85 EA                    ..
        lda     #$C6                            ; 82B3 A9 C6                    ..
        sta     $0588,x                         ; 82B5 9D 88 05                 ...
L82B8:  lda     #$A2                            ; 82B8 A9 A2                    ..
        sta     $05A0,x                         ; 82BA 9D A0 05                 ...
        lda     #$30                            ; 82BD A9 30                    .0
        sta     $0468,x                         ; 82BF 9D 68 04                 .h.
        lda     #$40                            ; 82C2 A9 40                    .@
        sta     $FA                             ; 82C4 85 FA                    ..
        lda     #$A4                            ; 82C6 A9 A4                    ..
        sta     L0000                           ; 82C8 85 00                    ..
        lda     #$A5                            ; 82CA A9 A5                    ..
        sta     $01                             ; 82CC 85 01                    ..
        jsr     L8420                           ; 82CE 20 20 84                   .
        bcs     L8337                           ; 82D1 B0 64                    .d
        jsr     LA4E4                           ; 82D3 20 E4 A4                  ..
        lda     #$0A                            ; 82D6 A9 0A                    ..
        sta     $0420,y                         ; 82D8 99 20 04                 . .
        lda     #$34                            ; 82DB A9 34                    .4
        sta     $0330,y                         ; 82DD 99 30 03                 .0.
        jsr     LA4E4                           ; 82E0 20 E4 A4                  ..
        lda     #$09                            ; 82E3 A9 09                    ..
        sta     $0420,y                         ; 82E5 99 20 04                 . .
        lda     #$C4                            ; 82E8 A9 C4                    ..
        sta     $0330,y                         ; 82EA 99 30 03                 .0.
        jsr     LA515                           ; 82ED 20 15 A5                  ..
        lda     #$3C                            ; 82F0 A9 3C                    .<
        sta     $0378,y                         ; 82F2 99 78 03                 .x.
        lda     #$E4                            ; 82F5 A9 E4                    ..
        sta     $0480,y                         ; 82F7 99 80 04                 ...
        jsr     LA515                           ; 82FA 20 15 A5                  ..
        lda     #$74                            ; 82FD A9 74                    .t
        sta     $0378,y                         ; 82FF 99 78 03                 .x.
        lda     #$1C                            ; 8302 A9 1C                    ..
        sta     $0480,y                         ; 8304 99 80 04                 ...
        lda     #$80                            ; 8307 A9 80                    ..
        sta     $0330,x                         ; 8309 9D 30 03                 .0.
        lda     #$58                            ; 830C A9 58                    .X
        sta     $0378,x                         ; 830E 9D 78 03                 .x.
        lda     $E4                             ; 8311 A5 E4                    ..
        and     #$03                            ; 8313 29 03                    ).
        tay                                     ; 8315 A8                       .
        lda     $A5FF,y                         ; 8316 B9 FF A5                 ...
        sta     $04E0,x                         ; 8319 9D E0 04                 ...
        lda     #$3E                            ; 831C A9 3E                    .>
        sta     $0588,x                         ; 831E 9D 88 05                 ...
        lda     #$A3                            ; 8321 A9 A3                    ..
        sta     $05A0,x                         ; 8323 9D A0 05                 ...
        lda     #$02                            ; 8326 A9 02                    ..
        sta     $0468,x                         ; 8328 9D 68 04                 .h.
        lda     #$3C                            ; 832B A9 3C                    .<
        sta     $0498,x                         ; 832D 9D 98 04                 ...
        lda     #$3F                            ; 8330 A9 3F                    .?
        sta     $0480,x                         ; 8332 9D 80 04                 ...
        bne     L8358                           ; 8335 D0 21                    .!
L8337:  rts                                     ; 8337 60                       `

; ----------------------------------------------------------------------------
L8338:  dec     $04C8,x                         ; 8338 DE C8 04                 ...
L833B:  jmp     LA421                           ; 833B 4C 21 A4                 L!.

; ----------------------------------------------------------------------------
        lda     $04C8,x                         ; 833E BD C8 04                 ...
        bne     L8338                           ; 8341 D0 F5                    ..
        lda     $0468,x                         ; 8343 BD 68 04                 .h.
        bne     L8368                           ; 8346 D0 20                    . 
        lda     #$04                            ; 8348 A9 04                    ..
        sta     $0468,x                         ; 834A 9D 68 04                 .h.
        inc     $0480,x                         ; 834D FE 80 04                 ...
        lda     $0480,x                         ; 8350 BD 80 04                 ...
        and     #$3F                            ; 8353 29 3F                    )?
        sta     $0480,x                         ; 8355 9D 80 04                 ...
L8358:  cmp     #$20                            ; 8358 C9 20                    . 
        bcc     L835E                           ; 835A 90 02                    ..
        sbc     #$10                            ; 835C E9 10                    ..
L835E:  tay                                     ; 835E A8                       .
        lda     $A5B8,y                         ; 835F B9 B8 A5                 ...
        tay                                     ; 8362 A8                       .
        lda     #$08                            ; 8363 A9 08                    ..
        jsr     LF470                           ; 8365 20 70 F4                  p.
L8368:  dec     $0468,x                         ; 8368 DE 68 04                 .h.
        jsr     LEA65                           ; 836B 20 65 EA                  e.
        jsr     LEA86                           ; 836E 20 86 EA                  ..
        dec     $0498,x                         ; 8371 DE 98 04                 ...
        bne     L837E                           ; 8374 D0 08                    ..
        lda     #$3C                            ; 8376 A9 3C                    .<
        sta     $0498,x                         ; 8378 9D 98 04                 ...
        jsr     LA469                           ; 837B 20 69 A4                  i.
L837E:  lda     $0480,x                         ; 837E BD 80 04                 ...
        cmp     #$3F                            ; 8381 C9 3F                    .?
        bne     L833B                           ; 8383 D0 B6                    ..
        lda     $0468,x                         ; 8385 BD 68 04                 .h.
        cmp     #$02                            ; 8388 C9 02                    ..
        bne     L833B                           ; 838A D0 AF                    ..
        lda     #$D0                            ; 838C A9 D0                    ..
        sta     $0588,x                         ; 838E 9D 88 05                 ...
        lda     #$A3                            ; 8391 A9 A3                    ..
        sta     $05A0,x                         ; 8393 9D A0 05                 ...
        lda     #$33                            ; 8396 A9 33                    .3
        sta     $03A8,x                         ; 8398 9D A8 03                 ...
        lda     #$01                            ; 839B A9 01                    ..
        sta     $03C0,x                         ; 839D 9D C0 03                 ...
        lda     #$D9                            ; 83A0 A9 D9                    ..
        sta     $03D8,x                         ; 83A2 9D D8 03                 ...
        lda     #$00                            ; 83A5 A9 00                    ..
        sta     $03F0,x                         ; 83A7 9D F0 03                 ...
        jsr     LEC16                           ; 83AA 20 16 EC                  ..
        lda     $0420,x                         ; 83AD BD 20 04                 . .
        ora     #$04                            ; 83B0 09 04                    ..
        sta     $0420,x                         ; 83B2 9D 20 04                 . .
        lda     #$42                            ; 83B5 A9 42                    .B
        sta     $0498,x                         ; 83B7 9D 98 04                 ...
        sta     $04C8,x                         ; 83BA 9D C8 04                 ...
        lda     #$03                            ; 83BD A9 03                    ..
        sta     $04B0,x                         ; 83BF 9D B0 04                 ...
        ldy     $0540,x                         ; 83C2 BC 40 05                 .@.
        lda     $A603,y                         ; 83C5 B9 03 A6                 ...
        sta     $0540,x                         ; 83C8 9D 40 05                 .@.
        lda     #$F3                            ; 83CB A9 F3                    ..
        sta     $0408,x                         ; 83CD 9D 08 04                 ...
        lda     $0540,x                         ; 83D0 BD 40 05                 .@.
        cmp     #$10                            ; 83D3 C9 10                    ..
        bne     L83DC                           ; 83D5 D0 05                    ..
        lda     #$00                            ; 83D7 A9 00                    ..
        sta     $0570,x                         ; 83D9 9D 70 05                 .p.
L83DC:  lda     $04C8,x                         ; 83DC BD C8 04                 ...
        bne     L841E                           ; 83DF D0 3D                    .=
        jsr     LEA65                           ; 83E1 20 65 EA                  e.
        jsr     LEA86                           ; 83E4 20 86 EA                  ..
        dec     $0498,x                         ; 83E7 DE 98 04                 ...
        bne     L8421                           ; 83EA D0 35                    .5
        lda     #$42                            ; 83EC A9 42                    .B
        sta     $0498,x                         ; 83EE 9D 98 04                 ...
        ldy     $04B0,x                         ; 83F1 BC B0 04                 ...
        lda     $0420,x                         ; 83F4 BD 20 04                 . .
        eor     #$0C                            ; 83F7 49 0C                    I.
        eor     $A5E8,y                         ; 83F9 59 E8 A5                 Y..
        sta     $0420,x                         ; 83FC 9D 20 04                 . .
        lda     $A5EC,y                         ; 83FF B9 EC A5                 ...
        sta     $04C8,x                         ; 8402 9D C8 04                 ...
        lda     $04B0,x                         ; 8405 BD B0 04                 ...
        and     #$01                            ; 8408 29 01                    ).
        beq     L840F                           ; 840A F0 03                    ..
        jsr     LA4B9                           ; 840C 20 B9 A4                  ..
L840F:  dec     $04B0,x                         ; 840F DE B0 04                 ...
        bpl     L8421                           ; 8412 10 0D                    ..
        lda     #$07                            ; 8414 A9 07                    ..
        sta     $0588,x                         ; 8416 9D 88 05                 ...
        lda     #$A3                            ; 8419 A9 A3                    ..
        sta     $05A0,x                         ; 841B 9D A0 05                 ...
L841E:  .byte   $DE                             ; 841E DE                       .
        iny                                     ; 841F C8                       .
L8420:  .byte   $04                             ; 8420 04                       .
L8421:  lda     $0540,x                         ; 8421 BD 40 05                 .@.
        cmp     #$13                            ; 8424 C9 13                    ..
        bcc     L842F                           ; 8426 90 07                    ..
        lda     #$A9                            ; 8428 A9 A9                    ..
        sta     $0408,x                         ; 842A 9D 08 04                 ...
        bne     L8458                           ; 842D D0 29                    .)
L842F:  lda     $0540,x                         ; 842F BD 40 05                 .@.
        bne     L8458                           ; 8432 D0 24                    .$
        sta     $0570,x                         ; 8434 9D 70 05                 .p.
        lda     #$A9                            ; 8437 A9 A9                    ..
        sta     $0408,x                         ; 8439 9D 08 04                 ...
        dec     $04E0,x                         ; 843C DE E0 04                 ...
        bne     L8458                           ; 843F D0 17                    ..
        lda     $E4                             ; 8441 A5 E4                    ..
        adc     $E5                             ; 8443 65 E5                    e.
        sta     $E5                             ; 8445 85 E5                    ..
        and     #$03                            ; 8447 29 03                    ).
        tay                                     ; 8449 A8                       .
        lda     $A5FF,y                         ; 844A B9 FF A5                 ...
        sta     $04E0,x                         ; 844D 9D E0 04                 ...
        inc     $0540,x                         ; 8450 FE 40 05                 .@.
        lda     #$F3                            ; 8453 A9 F3                    ..
        sta     $0408,x                         ; 8455 9D 08 04                 ...
L8458:  lda     #$98                            ; 8458 A9 98                    ..
        sec                                     ; 845A 38                       8
        sbc     $0378,x                         ; 845B FD 78 03                 .x.
        sta     $FA                             ; 845E 85 FA                    ..
        lda     #$80                            ; 8460 A9 80                    ..
        sec                                     ; 8462 38                       8
        sbc     $0330,x                         ; 8463 FD 30 03                 .0.
        sta     $78                             ; 8466 85 78                    .x
        rts                                     ; 8468 60                       `

; ----------------------------------------------------------------------------
        jsr     LF16F                           ; 8469 20 6F F1                  o.
        bcs     L84B8                           ; 846C B0 4A                    .J
        lda     #$BB                            ; 846E A9 BB                    ..
        jsr     LEAA4                           ; 8470 20 A4 EA                  ..
        lda     #$7E                            ; 8473 A9 7E                    .~
        sta     $0300,y                         ; 8475 99 00 03                 ...
        lda     #$80                            ; 8478 A9 80                    ..
        sta     $0408,y                         ; 847A 99 08 04                 ...
        lda     $0378,x                         ; 847D BD 78 03                 .x.
        sec                                     ; 8480 38                       8
        sbc     #$44                            ; 8481 E9 44                    .D
        sta     $0378,y                         ; 8483 99 78 03                 .x.
        lda     $0390,x                         ; 8486 BD 90 03                 ...
        sbc     #$00                            ; 8489 E9 00                    ..
        sta     $0390,y                         ; 848B 99 90 03                 ...
        lda     #$7A                            ; 848E A9 7A                    .z
        sta     $03D8,y                         ; 8490 99 D8 03                 ...
        lda     #$03                            ; 8493 A9 03                    ..
        sta     $03F0,y                         ; 8495 99 F0 03                 ...
        tya                                     ; 8498 98                       .
        tax                                     ; 8499 AA                       .
        jsr     LEC16                           ; 849A 20 16 EC                  ..
        jsr     LEC94                           ; 849D 20 94 EC                  ..
        ldy     #$04                            ; 84A0 A0 04                    ..
L84A2:  cmp     $A5F0,y                         ; 84A2 D9 F0 A5                 ...
        .byte   $B0                             ; 84A5 B0                       .
L84A6:  .byte   $03                             ; 84A6 03                       .
        dey                                     ; 84A7 88                       .
        bne     L84A2                           ; 84A8 D0 F8                    ..
        lda     $A5F5,y                         ; 84AA B9 F5 A5                 ...
        sta     $03A8,x                         ; 84AD 9D A8 03                 ...
        lda     $A5FA,y                         ; 84B0 B9 FA A5                 ...
        sta     $03C0,x                         ; 84B3 9D C0 03                 ...
        ldx     $A6                             ; 84B6 A6 A6                    ..
L84B8:  rts                                     ; 84B8 60                       `

; ----------------------------------------------------------------------------
        jsr     LF16F                           ; 84B9 20 6F F1                  o.
        bcs     L84E3                           ; 84BC B0 25                    .%
        lda     #$BC                            ; 84BE A9 BC                    ..
        jsr     LEAA4                           ; 84C0 20 A4 EA                  ..
        lda     #$7F                            ; 84C3 A9 7F                    ..
        sta     $0300,y                         ; 84C5 99 00 03                 ...
        lda     #$85                            ; 84C8 A9 85                    ..
        sta     $0408,y                         ; 84CA 99 08 04                 ...
        lda     $0378,x                         ; 84CD BD 78 03                 .x.
        clc                                     ; 84D0 18                       .
        adc     #$14                            ; 84D1 69 14                    i.
        .byte   $99                             ; 84D3 99                       .
        sei                                     ; 84D4 78                       x
L84D5:  .byte   $03                             ; 84D5 03                       .
        tya                                     ; 84D6 98                       .
        tax                                     ; 84D7 AA                       .
        jsr     LECC2                           ; 84D8 20 C2 EC                  ..
        tay                                     ; 84DB A8                       .
        lda     #$28                            ; 84DC A9 28                    .(
        jsr     LF470                           ; 84DE 20 70 F4                  p.
        ldx     $A6                             ; 84E1 A6 A6                    ..
L84E3:  rts                                     ; 84E3 60                       `

; ----------------------------------------------------------------------------
        jsr     LF16F                           ; 84E4 20 6F F1                  o.
        lda     #$BD                            ; 84E7 A9 BD                    ..
        jsr     LEAA4                           ; 84E9 20 A4 EA                  ..
        lda     $0528,y                         ; 84EC B9 28 05                 .(.
        ora     #$01                            ; 84EF 09 01                    ..
        sta     $0528,y                         ; 84F1 99 28 05                 .(.
        lda     #$7D                            ; 84F4 A9 7D                    .}
        sta     $0300,y                         ; 84F6 99 00 03                 ...
        lda     #$22                            ; 84F9 A9 22                    ."
        sta     $0408,y                         ; 84FB 99 08 04                 ...
        lda     #$BC                            ; 84FE A9 BC                    ..
        sta     $0378,y                         ; 8500 99 78 03                 .x.
        lda     #$66                            ; 8503 A9 66                    .f
        sta     $03A8,y                         ; 8505 99 A8 03                 ...
        sta     $03D8,y                         ; 8508 99 D8 03                 ...
        lda     #$00                            ; 850B A9 00                    ..
        sta     $03C0,y                         ; 850D 99 C0 03                 ...
        sta     $03F0,y                         ; 8510 99 F0 03                 ...
        tya                                     ; 8513 98                       .
        rts                                     ; 8514 60                       `

; ----------------------------------------------------------------------------
        jsr     LF16F                           ; 8515 20 6F F1                  o.
        lda     #$62                            ; 8518 A9 62                    .b
        jsr     LEAA4                           ; 851A 20 A4 EA                  ..
        lda     #$B1                            ; 851D A9 B1                    ..
        sta     $0300,y                         ; 851F 99 00 03                 ...
        lda     #$EA                            ; 8522 A9 EA                    ..
        sta     $0408,y                         ; 8524 99 08 04                 ...
        lda     $0330,x                         ; 8527 BD 30 03                 .0.
        sta     $0330,y                         ; 852A 99 30 03                 .0.
        txa                                     ; 852D 8A                       .
        sta     $0468,y                         ; 852E 99 68 04                 .h.
        tya                                     ; 8531 98                       .
        rts                                     ; 8532 60                       `

; ----------------------------------------------------------------------------
        jsr     LE968                           ; 8533 20 68 E9                  h.
        jmp     LEA65                           ; 8536 4C 65 EA                 Le.

; ----------------------------------------------------------------------------
        dec     $0378,x                         ; 8539 DE 78 03                 .x.
        jsr     LEF87                           ; 853C 20 87 EF                  ..
        inc     $0378,x                         ; 853F FE 78 03                 .x.
        bcs     L85A3                           ; 8542 B0 5F                    ._
        lda     #$82                            ; 8544 A9 82                    ..
        sta     $0468,x                         ; 8546 9D 68 04                 .h.
        lda     #$53                            ; 8549 A9 53                    .S
        sta     $0588,x                         ; 854B 9D 88 05                 ...
        lda     #$A5                            ; 854E A9 A5                    ..
        sta     $05A0,x                         ; 8550 9D A0 05                 ...
        dec     $0378,x                         ; 8553 DE 78 03                 .x.
        jsr     LEF87                           ; 8556 20 87 EF                  ..
        inc     $0378,x                         ; 8559 FE 78 03                 .x.
        bcs     L8578                           ; 855C B0 1A                    ..
        lda     $0420,x                         ; 855E BD 20 04                 . .
        sta     $39                             ; 8561 85 39                    .9
        lda     $03A8,x                         ; 8563 BD A8 03                 ...
        sta     $3A                             ; 8566 85 3A                    .:
        lda     $03C0,x                         ; 8568 BD C0 03                 ...
        sta     $3B                             ; 856B 85 3B                    .;
        jsr     LEC94                           ; 856D 20 94 EC                  ..
        cmp     #$12                            ; 8570 C9 12                    ..
        bcc     L8578                           ; 8572 90 04                    ..
        lda     #$00                            ; 8574 A9 00                    ..
        sta     $39                             ; 8576 85 39                    .9
L8578:  jsr     LEA65                           ; 8578 20 65 EA                  e.
        jsr     LEA86                           ; 857B 20 86 EA                  ..
        dec     $0468,x                         ; 857E DE 68 04                 .h.
        bne     L85A3                           ; 8581 D0 20                    . 
        .byte   $A9                             ; 8583 A9                       .
L8584:  .byte   $82                             ; 8584 82                       .
        sta     $0468,x                         ; 8585 9D 68 04                 .h.
        lda     $0420,x                         ; 8588 BD 20 04                 . .
        eor     #$0F                            ; 858B 49 0F                    I.
        sta     $0420,x                         ; 858D 9D 20 04                 . .
        and     #$08                            ; 8590 29 08                    ).
        beq     L85A3                           ; 8592 F0 0F                    ..
        lda     #$BC                            ; 8594 A9 BC                    ..
        sta     $0378,x                         ; 8596 9D 78 03                 .x.
        lda     #$39                            ; 8599 A9 39                    .9
        sta     $0588,x                         ; 859B 9D 88 05                 ...
        lda     #$A5                            ; 859E A9 A5                    ..
        sta     $05A0,x                         ; 85A0 9D A0 05                 ...
L85A3:  rts                                     ; 85A3 60                       `

; ----------------------------------------------------------------------------
        .byte   $0F                             ; 85A4 0F                       .
        .byte   $37                             ; 85A5 37                       7
        .byte   $27                             ; 85A6 27                       '
        .byte   $03                             ; 85A7 03                       .
        .byte   $0F                             ; 85A8 0F                       .
        bmi     L85D6                           ; 85A9 30 2B                    0+
        .byte   $1B                             ; 85AB 1B                       .
        .byte   $0F                             ; 85AC 0F                       .
        bmi     L85C3                           ; 85AD 30 14                    0.
        .byte   $03                             ; 85AF 03                       .
        .byte   $0F                             ; 85B0 0F                       .
        .byte   $0F                             ; 85B1 0F                       .
        .byte   $37                             ; 85B2 37                       7
        .byte   $27                             ; 85B3 27                       '
        .byte   $0F                             ; 85B4 0F                       .
        bmi     L85C7                           ; 85B5 30 10                    0.
        .byte   $1C                             ; 85B7 1C                       .
        ora     #$0A                            ; 85B8 09 0A                    ..
        .byte   $0B                             ; 85BA 0B                       .
        .byte   $0C                             ; 85BB 0C                       .
        ora     $0F0E                           ; 85BC 0D 0E 0F                 ...
        brk                                     ; 85BF 00                       .
        .byte   $0F                             ; 85C0 0F                       .
        .byte   $0E                             ; 85C1 0E                       .
        .byte   $0D                             ; 85C2 0D                       .
L85C3:  .byte   $0C                             ; 85C3 0C                       .
        .byte   $0B                             ; 85C4 0B                       .
        asl     a                               ; 85C5 0A                       .
        .byte   $09                             ; 85C6 09                       .
L85C7:  php                                     ; 85C7 08                       .
        .byte   $07                             ; 85C8 07                       .
        asl     $05                             ; 85C9 06 05                    ..
        .byte   $04                             ; 85CB 04                       .
        .byte   $03                             ; 85CC 03                       .
        .byte   $02                             ; 85CD 02                       .
        ora     (L0000,x)                       ; 85CE 01 00                    ..
        ora     ($02,x)                         ; 85D0 01 02                    ..
        .byte   $03                             ; 85D2 03                       .
        .byte   $04                             ; 85D3 04                       .
        ora     $06                             ; 85D4 05 06                    ..
L85D6:  .byte   $07                             ; 85D6 07                       .
        php                                     ; 85D7 08                       .
        ora     #$0A                            ; 85D8 09 0A                    ..
        .byte   $0B                             ; 85DA 0B                       .
        .byte   $0C                             ; 85DB 0C                       .
        ora     $0F0E                           ; 85DC 0D 0E 0F                 ...
        brk                                     ; 85DF 00                       .
        .byte   $0F                             ; 85E0 0F                       .
        asl     $0C0D                           ; 85E1 0E 0D 0C                 ...
        .byte   $0B                             ; 85E4 0B                       .
        asl     a                               ; 85E5 0A                       .
        ora     #$08                            ; 85E6 09 08                    ..
        brk                                     ; 85E8 00                       .
        .byte   $03                             ; 85E9 03                       .
        brk                                     ; 85EA 00                       .
        .byte   $03                             ; 85EB 03                       .
        .byte   $3C                             ; 85EC 3C                       <
        brk                                     ; 85ED 00                       .
        brk                                     ; 85EE 00                       .
        brk                                     ; 85EF 00                       .
        rti                                     ; 85F0 40                       @

; ----------------------------------------------------------------------------
        rts                                     ; 85F1 60                       `

; ----------------------------------------------------------------------------
        .byte   $80                             ; 85F2 80                       .
        ldy     #$C0                            ; 85F3 A0 C0                    ..
        .byte   $47                             ; 85F5 47                       G
        .byte   $EB                             ; 85F6 EB                       .
        .byte   $8F                             ; 85F7 8F                       .
        .byte   $33                             ; 85F8 33                       3
        .byte   $D7                             ; 85F9 D7                       .
        ora     ($01,x)                         ; 85FA 01 01                    ..
        .byte   $02                             ; 85FC 02                       .
        .byte   $03                             ; 85FD 03                       .
        .byte   $03                             ; 85FE 03                       .
        .byte   $1E                             ; 85FF 1E                       .
        .byte   $3C                             ; 8600 3C                       <
L8601:  .byte   $5A                             ; 8601 5A                       Z
        sei                                     ; 8602 78                       x
        ora     ($01,x)                         ; 8603 01 01                    ..
        bpl     L8617                           ; 8605 10 10                    ..
        bpl     L8619                           ; 8607 10 10                    ..
        bpl     L861B                           ; 8609 10 10                    ..
        bpl     L861D                           ; 860B 10 10                    ..
        bpl     L861F                           ; 860D 10 10                    ..
        bpl     L8621                           ; 860F 10 10                    ..
        bpl     L8623                           ; 8611 10 10                    ..
        bpl     L8625                           ; 8613 10 10                    ..
        ora     ($01,x)                         ; 8615 01 01                    ..
L8617:  ora     ($01,x)                         ; 8617 01 01                    ..
L8619:  ora     (L0020,x)                       ; 8619 01 20                    . 
L861B:  ldx     $84                             ; 861B A6 84                    ..
L861D:  bcs     L85A3                           ; 861D B0 84                    ..
L861F:  lda     #$80                            ; 861F A9 80                    ..
L8621:  sta     $1E                             ; 8621 85 1E                    ..
L8623:  lda     #$07                            ; 8623 A9 07                    ..
L8625:  sta     $23                             ; 8625 85 23                    .#
        lda     #$31                            ; 8627 A9 31                    .1
        sta     $0588,x                         ; 8629 9D 88 05                 ...
        lda     #$A6                            ; 862C A9 A6                    ..
        sta     $05A0,x                         ; 862E 9D A0 05                 ...
        lda     $1E                             ; 8631 A5 1E                    ..
        bne     L869E                           ; 8633 D0 69                    .i
        jsr     L84D5                           ; 8635 20 D5 84                  ..
        inc     $46                             ; 8638 E6 46                    .F
        lda     #$4D                            ; 863A A9 4D                    .M
        sta     $0588,x                         ; 863C 9D 88 05                 ...
        lda     #$A6                            ; 863F A9 A6                    ..
        sta     $05A0,x                         ; 8641 9D A0 05                 ...
        lda     #$30                            ; 8644 A9 30                    .0
        sta     $0468,x                         ; 8646 9D 68 04                 .h.
        lda     #$B0                            ; 8649 A9 B0                    ..
        sta     $FA                             ; 864B 85 FA                    ..
        lda     #$BD                            ; 864D A9 BD                    ..
        sta     L0000                           ; 864F 85 00                    ..
        lda     #$A7                            ; 8651 A9 A7                    ..
        sta     $01                             ; 8653 85 01                    ..
        jsr     L8420                           ; 8655 20 20 84                   .
        bcs     L869E                           ; 8658 B0 44                    .D
        jsr     LF16F                           ; 865A 20 6F F1                  o.
        lda     #$62                            ; 865D A9 62                    .b
        jsr     LEAA4                           ; 865F 20 A4 EA                  ..
        lda     #$A1                            ; 8662 A9 A1                    ..
        sta     $0300,y                         ; 8664 99 00 03                 ...
        lda     #$38                            ; 8667 A9 38                    .8
        sta     $0378,y                         ; 8669 99 78 03                 .x.
        lda     #$DD                            ; 866C A9 DD                    ..
        sta     $0408,y                         ; 866E 99 08 04                 ...
        txa                                     ; 8671 8A                       .
        sta     $0468,y                         ; 8672 99 68 04                 .h.
        lda     $E4                             ; 8675 A5 E4                    ..
        adc     $E6                             ; 8677 65 E6                    e.
        sta     $E6                             ; 8679 85 E6                    ..
        and     #$03                            ; 867B 29 03                    ).
        tay                                     ; 867D A8                       .
        lda     $A7D5,y                         ; 867E B9 D5 A7                 ...
        sta     $0468,x                         ; 8681 9D 68 04                 .h.
        lda     $A7D9,y                         ; 8684 B9 D9 A7                 ...
        .byte   $9D                             ; 8687 9D                       .
        .byte   $80                             ; 8688 80                       .
L8689:  .byte   $04                             ; 8689 04                       .
        lda     #$00                            ; 868A A9 00                    ..
        sta     $03D8,x                         ; 868C 9D D8 03                 ...
        lda     #$02                            ; 868F A9 02                    ..
        sta     $03F0,x                         ; 8691 9D F0 03                 ...
        lda     #$9F                            ; 8694 A9 9F                    ..
        sta     $0588,x                         ; 8696 9D 88 05                 ...
        lda     #$A6                            ; 8699 A9 A6                    ..
        sta     $05A0,x                         ; 869B 9D A0 05                 ...
L869E:  rts                                     ; 869E 60                       `

; ----------------------------------------------------------------------------
        lda     #$55                            ; 869F A9 55                    .U
        cmp     $0558,x                         ; 86A1 DD 58 05                 .X.
        beq     L86B0                           ; 86A4 F0 0A                    ..
        ldy     $0540,x                         ; 86A6 BC 40 05                 .@.
        cpy     #$02                            ; 86A9 C0 02                    ..
        bne     L86B0                           ; 86AB D0 03                    ..
        jsr     LEA98                           ; 86AD 20 98 EA                  ..
L86B0:  lda     $0498,x                         ; 86B0 BD 98 04                 ...
        bne     L86BD                           ; 86B3 D0 08                    ..
        lda     #$14                            ; 86B5 A9 14                    ..
        sta     $0498,x                         ; 86B7 9D 98 04                 ...
        jsr     LEC16                           ; 86BA 20 16 EC                  ..
L86BD:  jsr     LEA65                           ; 86BD 20 65 EA                  e.
        lda     $0528,x                         ; 86C0 BD 28 05                 .(.
        and     #$DF                            ; 86C3 29 DF                    ).
        sta     $0528,x                         ; 86C5 9D 28 05                 .(.
        lda     $0420,x                         ; 86C8 BD 20 04                 . .
        and     #$01                            ; 86CB 29 01                    ).
        beq     L86D8                           ; 86CD F0 09                    ..
        lda     $0330,x                         ; 86CF BD 30 03                 .0.
        cmp     #$C8                            ; 86D2 C9 C8                    ..
        bcs     L86DF                           ; 86D4 B0 09                    ..
        bcc     L86E7                           ; 86D6 90 0F                    ..
L86D8:  lda     $0330,x                         ; 86D8 BD 30 03                 .0.
        cmp     #$39                            ; 86DB C9 39                    .9
        bcs     L86E7                           ; 86DD B0 08                    ..
L86DF:  lda     $0420,x                         ; 86DF BD 20 04                 . .
        eor     #$03                            ; 86E2 49 03                    I.
        sta     $0420,x                         ; 86E4 9D 20 04                 . .
L86E7:  dec     $0498,x                         ; 86E7 DE 98 04                 ...
        lda     $0468,x                         ; 86EA BD 68 04                 .h.
        sec                                     ; 86ED 38                       8
        sbc     #$01                            ; 86EE E9 01                    ..
        sta     $0468,x                         ; 86F0 9D 68 04                 .h.
        lda     $0480,x                         ; 86F3 BD 80 04                 ...
        sbc     #$00                            ; 86F6 E9 00                    ..
        sta     $0480,x                         ; 86F8 9D 80 04                 ...
        ora     $0468,x                         ; 86FB 1D 68 04                 .h.
        bne     L8741                           ; 86FE D0 41                    .A
        lda     #$08                            ; 8700 A9 08                    ..
        sta     $0420,x                         ; 8702 9D 20 04                 . .
        lda     #$32                            ; 8705 A9 32                    .2
        sta     $0498,x                         ; 8707 9D 98 04                 ...
        lda     #$19                            ; 870A A9 19                    ..
        sta     $0588,x                         ; 870C 9D 88 05                 ...
        lda     #$A7                            ; 870F A9 A7                    ..
        sta     $05A0,x                         ; 8711 9D A0 05                 ...
        lda     #$56                            ; 8714 A9 56                    .V
        jsr     LEA98                           ; 8716 20 98 EA                  ..
        lda     #$57                            ; 8719 A9 57                    .W
        cmp     $0558,x                         ; 871B DD 58 05                 .X.
        beq     L872A                           ; 871E F0 0A                    ..
        ldy     $0540,x                         ; 8720 BC 40 05                 .@.
        cpy     #$02                            ; 8723 C0 02                    ..
        bne     L872A                           ; 8725 D0 03                    ..
        jsr     LEA98                           ; 8727 20 98 EA                  ..
L872A:  lda     $0498,x                         ; 872A BD 98 04                 ...
        beq     L8743                           ; 872D F0 14                    ..
        dec     $0498,x                         ; 872F DE 98 04                 ...
        bne     L8781                           ; 8732 D0 4D                    .M
        lda     #$20                            ; 8734 A9 20                    . 
        sta     $0468,x                         ; 8736 9D 68 04                 .h.
        lda     $0420,x                         ; 8739 BD 20 04                 . .
        eor     #$0C                            ; 873C 49 0C                    I.
        sta     $0420,x                         ; 873E 9D 20 04                 . .
L8741:  bne     L8781                           ; 8741 D0 3E                    .>
L8743:  jsr     LEA86                           ; 8743 20 86 EA                  ..
        dec     $0468,x                         ; 8746 DE 68 04                 .h.
        bne     L8781                           ; 8749 D0 36                    .6
        lda     #$14                            ; 874B A9 14                    ..
        sta     $0498,x                         ; 874D 9D 98 04                 ...
        lda     $0420,x                         ; 8750 BD 20 04                 . .
        and     #$08                            ; 8753 29 08                    ).
        bne     L8772                           ; 8755 D0 1B                    ..
        jsr     LF16F                           ; 8757 20 6F F1                  o.
        bcs     L8781                           ; 875A B0 25                    .%
        lda     #$5A                            ; 875C A9 5A                    .Z
        jsr     LEAA4                           ; 875E 20 A4 EA                  ..
        lda     #$80                            ; 8761 A9 80                    ..
        sta     $0378,y                         ; 8763 99 78 03                 .x.
        lda     #$6D                            ; 8766 A9 6D                    .m
        sta     $0300,y                         ; 8768 99 00 03                 ...
        lda     #$00                            ; 876B A9 00                    ..
        sta     $0408,y                         ; 876D 99 08 04                 ...
        beq     L8781                           ; 8770 F0 0F                    ..
L8772:  lda     #$75                            ; 8772 A9 75                    .u
        sta     $0588,x                         ; 8774 9D 88 05                 ...
        lda     #$A6                            ; 8777 A9 A6                    ..
        sta     $05A0,x                         ; 8779 9D A0 05                 ...
        lda     #$56                            ; 877C A9 56                    .V
        jsr     LEA98                           ; 877E 20 98 EA                  ..
L8781:  lda     #$C8                            ; 8781 A9 C8                    ..
        sec                                     ; 8783 38                       8
        sbc     $0378,x                         ; 8784 FD 78 03                 .x.
        sta     $FA                             ; 8787 85 FA                    ..
        lda     #$80                            ; 8789 A9 80                    ..
        sec                                     ; 878B 38                       8
        sbc     $0330,x                         ; 878C FD 30 03                 .0.
        sta     $78                             ; 878F 85 78                    .x
        lda     #$D7                            ; 8791 A9 D7                    ..
        sec                                     ; 8793 38                       8
        sbc     $0378,x                         ; 8794 FD 78 03                 .x.
        sta     $9B                             ; 8797 85 9B                    ..
        lda     #$BF                            ; 8799 A9 BF                    ..
        sec                                     ; 879B 38                       8
        sbc     $9B                             ; 879C E5 9B                    ..
        sta     $79                             ; 879E 85 79                    .y
        ldy     $0558,x                         ; 87A0 BC 58 05                 .X.
        lda     $A77C,y                         ; 87A3 B9 7C A7                 .|.
        sta     $0408,x                         ; 87A6 9D 08 04                 ...
        rts                                     ; 87A9 60                       `

; ----------------------------------------------------------------------------
        ldy     $0468,x                         ; 87AA BC 68 04                 .h.
        lda     $0378,y                         ; 87AD B9 78 03                 .x.
        clc                                     ; 87B0 18                       .
        adc     #$20                            ; 87B1 69 20                    i 
        sta     $0378,x                         ; 87B3 9D 78 03                 .x.
        lda     $0330,y                         ; 87B6 B9 30 03                 .0.
        sta     $0330,x                         ; 87B9 9D 30 03                 .0.
        rts                                     ; 87BC 60                       `

; ----------------------------------------------------------------------------
        .byte   $0F                             ; 87BD 0F                       .
        bmi     L87E7                           ; 87BE 30 27                    0'
        .byte   $07                             ; 87C0 07                       .
        .byte   $0F                             ; 87C1 0F                       .
        bmi     L87E6                           ; 87C2 30 22                    0"
        .byte   $13                             ; 87C4 13                       .
        .byte   $0F                             ; 87C5 0F                       .
        bmi     L87ED                           ; 87C6 30 25                    0%
        ora     $0F,x                           ; 87C8 15 0F                    ..
        .byte   $0F                             ; 87CA 0F                       .
        plp                                     ; 87CB 28                       (
        asl     $0F,x                           ; 87CC 16 0F                    ..
        .byte   $22                             ; 87CE 22                       "
        jsr     L8936                           ; 87CF 20 36 89                  6.
        .byte   $89                             ; 87D2 89                       .
        cmp     #$00                            ; 87D3 C9 00                    ..
        bit     $C82C                           ; 87D5 2C 2C C8                 ,,.
        stx     $01,y                           ; 87D8 96 01                    ..
        ora     (L0000,x)                       ; 87DA 01 00                    ..
        brk                                     ; 87DC 00                       .
        .byte   $77                             ; 87DD 77                       w
        .byte   $FF                             ; 87DE FF                       .
        .byte   $FF                             ; 87DF FF                       .
        .byte   $FF                             ; 87E0 FF                       .
        .byte   $D7                             ; 87E1 D7                       .
        .byte   $DF                             ; 87E2 DF                       .
        .byte   $FF                             ; 87E3 FF                       .
        .byte   $FF                             ; 87E4 FF                       .
        .byte   $7D                             ; 87E5 7D                       }
L87E6:  .byte   $FF                             ; 87E6 FF                       .
L87E7:  .byte   $DF                             ; 87E7 DF                       .
        .byte   $F7                             ; 87E8 F7                       .
        cmp     L8FFF,x                         ; 87E9 DD FF 8F                 ...
        .byte   $FF                             ; 87EC FF                       .
L87ED:  .byte   $FF                             ; 87ED FF                       .
        .byte   $FF                             ; 87EE FF                       .
        adc     $FE,x                           ; 87EF 75 FE                    u.
        .byte   $7F                             ; 87F1 7F                       .
        .byte   $FF                             ; 87F2 FF                       .
        sbc     $FF,x                           ; 87F3 F5 FF                    ..
        cmp     $45FF,x                         ; 87F5 DD FF 45                 ..E
        .byte   $FF                             ; 87F8 FF                       .
        sbc     $FF,x                           ; 87F9 F5 FF                    ..
        sbc     $77FF,x                         ; 87FB FD FF 77                 ..w
        .byte   $FF                             ; 87FE FF                       .
        .byte   $5F                             ; 87FF 5F                       _
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
        .byte   $02                             ; 8810 02                       .
        .byte   $03                             ; 8811 03                       .
        ora     ($01,x)                         ; 8812 01 01                    ..
        ora     ($01,x)                         ; 8814 01 01                    ..
        ora     ($02,x)                         ; 8816 01 02                    ..
        .byte   $02                             ; 8818 02                       .
        ora     ($01,x)                         ; 8819 01 01                    ..
        .byte   $02                             ; 881B 02                       .
        ora     ($01,x)                         ; 881C 01 01                    ..
        brk                                     ; 881E 00                       .
        brk                                     ; 881F 00                       .
        .byte   $04                             ; 8820 04                       .
        .byte   $03                             ; 8821 03                       .
        brk                                     ; 8822 00                       .
        brk                                     ; 8823 00                       .
        brk                                     ; 8824 00                       .
        ora     (L0000,x)                       ; 8825 01 00                    ..
        brk                                     ; 8827 00                       .
        .byte   $03                             ; 8828 03                       .
        ora     ($03,x)                         ; 8829 01 03                    ..
        ora     (L0000,x)                       ; 882B 01 00                    ..
        brk                                     ; 882D 00                       .
        brk                                     ; 882E 00                       .
        brk                                     ; 882F 00                       .
        brk                                     ; 8830 00                       .
        .byte   $02                             ; 8831 02                       .
        ora     ($01,x)                         ; 8832 01 01                    ..
        ora     (L0000,x)                       ; 8834 01 00                    ..
        ora     (L0000,x)                       ; 8836 01 00                    ..
        brk                                     ; 8838 00                       .
        ora     ($01,x)                         ; 8839 01 01                    ..
        .byte   $03                             ; 883B 03                       .
        brk                                     ; 883C 00                       .
        brk                                     ; 883D 00                       .
        ora     (L0000,x)                       ; 883E 01 00                    ..
        .byte   $03                             ; 8840 03                       .
        brk                                     ; 8841 00                       .
        brk                                     ; 8842 00                       .
        brk                                     ; 8843 00                       .
        brk                                     ; 8844 00                       .
        brk                                     ; 8845 00                       .
        brk                                     ; 8846 00                       .
        brk                                     ; 8847 00                       .
        brk                                     ; 8848 00                       .
        brk                                     ; 8849 00                       .
        brk                                     ; 884A 00                       .
        brk                                     ; 884B 00                       .
        brk                                     ; 884C 00                       .
        brk                                     ; 884D 00                       .
        brk                                     ; 884E 00                       .
        ora     ($01,x)                         ; 884F 01 01                    ..
        brk                                     ; 8851 00                       .
        ora     ($01,x)                         ; 8852 01 01                    ..
        ora     (L0000,x)                       ; 8854 01 00                    ..
        ora     (L0000,x)                       ; 8856 01 00                    ..
        brk                                     ; 8858 00                       .
        .byte   $02                             ; 8859 02                       .
        ora     (L0000,x)                       ; 885A 01 00                    ..
        ora     ($02,x)                         ; 885C 01 02                    ..
        brk                                     ; 885E 00                       .
        brk                                     ; 885F 00                       .
        ora     (L0000,x)                       ; 8860 01 00                    ..
        ora     ($01,x)                         ; 8862 01 01                    ..
        ora     ($01,x)                         ; 8864 01 01                    ..
        .byte   $02                             ; 8866 02                       .
        ora     ($01,x)                         ; 8867 01 01                    ..
        ora     (L0000,x)                       ; 8869 01 00                    ..
        ora     (L0000,x)                       ; 886B 01 00                    ..
        brk                                     ; 886D 00                       .
        ora     (L0000,x)                       ; 886E 01 00                    ..
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
        ora     ($04,x)                         ; 887B 01 04                    ..
        brk                                     ; 887D 00                       .
        brk                                     ; 887E 00                       .
        brk                                     ; 887F 00                       .
        brk                                     ; 8880 00                       .
        ora     (L0000,x)                       ; 8881 01 00                    ..
        .byte   $04                             ; 8883 04                       .
        brk                                     ; 8884 00                       .
        brk                                     ; 8885 00                       .
        ora     (L0000,x)                       ; 8886 01 00                    ..
        brk                                     ; 8888 00                       .
L8889:  ora     (L0000,x)                       ; 8889 01 00                    ..
        brk                                     ; 888B 00                       .
        brk                                     ; 888C 00                       .
        ora     (L0000,x)                       ; 888D 01 00                    ..
        brk                                     ; 888F 00                       .
        brk                                     ; 8890 00                       .
        ora     (L0000,x)                       ; 8891 01 00                    ..
        .byte   $02                             ; 8893 02                       .
        brk                                     ; 8894 00                       .
        brk                                     ; 8895 00                       .
        ora     (L0000,x)                       ; 8896 01 00                    ..
        ora     (L0000,x)                       ; 8898 01 00                    ..
        brk                                     ; 889A 00                       .
        brk                                     ; 889B 00                       .
        ora     (L0000,x)                       ; 889C 01 00                    ..
        ora     (L0000,x)                       ; 889E 01 00                    ..
        ora     (L0000,x)                       ; 88A0 01 00                    ..
        brk                                     ; 88A2 00                       .
        brk                                     ; 88A3 00                       .
        brk                                     ; 88A4 00                       .
        ora     (L0000,x)                       ; 88A5 01 00                    ..
        brk                                     ; 88A7 00                       .
        brk                                     ; 88A8 00                       .
        brk                                     ; 88A9 00                       .
        ora     (L0000,x)                       ; 88AA 01 00                    ..
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
        .byte   $03                             ; 88BD 03                       .
        .byte   $02                             ; 88BE 02                       .
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
        bpl     L8923                           ; 8910 10 11                    ..
        .byte   $12                             ; 8912 12                       .
        .byte   $13                             ; 8913 13                       .
        .byte   $14                             ; 8914 14                       .
        ora     $16,x                           ; 8915 15 16                    ..
        .byte   $17                             ; 8917 17                       .
        clc                                     ; 8918 18                       .
        ora     $1B1A,y                         ; 8919 19 1A 1B                 ...
L891C:  .byte   $1C                             ; 891C 1C                       .
        ora     $1F1E,x                         ; 891D 1D 1E 1F                 ...
        jsr     L0021                           ; 8920 20 21 00                  !.
L8923:  brk                                     ; 8923 00                       .
        brk                                     ; 8924 00                       .
        brk                                     ; 8925 00                       .
        .byte   $80                             ; 8926 80                       .
        brk                                     ; 8927 00                       .
        brk                                     ; 8928 00                       .
        brk                                     ; 8929 00                       .
        brk                                     ; 892A 00                       .
        brk                                     ; 892B 00                       .
        brk                                     ; 892C 00                       .
        brk                                     ; 892D 00                       .
        brk                                     ; 892E 00                       .
        brk                                     ; 892F 00                       .
        brk                                     ; 8930 00                       .
        brk                                     ; 8931 00                       .
        brk                                     ; 8932 00                       .
        brk                                     ; 8933 00                       .
        .byte   $02                             ; 8934 02                       .
        brk                                     ; 8935 00                       .
L8936:  brk                                     ; 8936 00                       .
        brk                                     ; 8937 00                       .
        brk                                     ; 8938 00                       .
        brk                                     ; 8939 00                       .
        brk                                     ; 893A 00                       .
        brk                                     ; 893B 00                       .
        brk                                     ; 893C 00                       .
        brk                                     ; 893D 00                       .
        brk                                     ; 893E 00                       .
        brk                                     ; 893F 00                       .
        brk                                     ; 8940 00                       .
        brk                                     ; 8941 00                       .
        brk                                     ; 8942 00                       .
        brk                                     ; 8943 00                       .
        brk                                     ; 8944 00                       .
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
        .byte   $04                             ; 894F 04                       .
        .byte   $23                             ; 8950 23                       #
        ldy     #$20                            ; 8951 A0 20                    . 
        jsr     L2000                           ; 8953 20 00 20                  . 
        .byte   $22                             ; 8956 22                       "
        ldy     #$22                            ; 8957 A0 22                    ."
        ldy     #$20                            ; 8959 A0 20                    . 
        brk                                     ; 895B 00                       .
        bit     $A0                             ; 895C 24 A0                    $.
        .byte   $22                             ; 895E 22                       "
        ldy     #$20                            ; 895F A0 20                    . 
        brk                                     ; 8961 00                       .
        .byte   $23                             ; 8962 23                       #
        jsr     L0020                           ; 8963 20 20 00                   .
        brk                                     ; 8966 00                       .
        brk                                     ; 8967 00                       .
        asl     $06                             ; 8968 06 06                    ..
        .byte   $07                             ; 896A 07                       .
        rti                                     ; 896B 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 896C 00                       .
        asl     $08                             ; 896D 06 08                    ..
        .byte   $1C                             ; 896F 1C                       .
        asl     $1C                             ; 8970 06 1C                    ..
        pha                                     ; 8972 48                       H
        brk                                     ; 8973 00                       .
        .byte   $0B                             ; 8974 0B                       .
        .byte   $1C                             ; 8975 1C                       .
        lsr     a                               ; 8976 4A                       J
        asl     a:$40,x                         ; 8977 1E 40 00                 .@.
        .byte   $1C                             ; 897A 1C                       .
        .byte   $80                             ; 897B 80                       .
        lda     L0000,x                         ; 897C B5 00                    ..
        brk                                     ; 897E 00                       .
        brk                                     ; 897F 00                       .
L8980:  dey                                     ; 8980 88                       .
        txa                                     ; 8981 8A                       .
        brk                                     ; 8982 00                       .
        brk                                     ; 8983 00                       .
        brk                                     ; 8984 00                       .
        brk                                     ; 8985 00                       .
        brk                                     ; 8986 00                       .
        brk                                     ; 8987 00                       .
        .byte   $0F                             ; 8988 0F                       .
        and     $1727,y                         ; 8989 39 27 17                 9'.
        .byte   $0F                             ; 898C 0F                       .
        ora     $0609,y                         ; 898D 19 09 06                 ...
        .byte   $0F                             ; 8990 0F                       .
        and     ($14,x)                         ; 8991 21 14                    !.
        .byte   $12                             ; 8993 12                       .
        .byte   $0F                             ; 8994 0F                       .
        jsr     L1221                           ; 8995 20 21 12                  !.
        brk                                     ; 8998 00                       .
        brk                                     ; 8999 00                       .
        brk                                     ; 899A 00                       .
        brk                                     ; 899B 00                       .
        .byte   $0F                             ; 899C 0F                       .
        and     $1727,y                         ; 899D 39 27 17                 9'.
        .byte   $0F                             ; 89A0 0F                       .
        ora     $0609,y                         ; 89A1 19 09 06                 ...
        .byte   $0F                             ; 89A4 0F                       .
        jsr     L1626                           ; 89A5 20 26 16                  &.
        .byte   $0F                             ; 89A8 0F                       .
        jsr     L1221                           ; 89A9 20 21 12                  !.
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
        brk                                     ; 89C1 00                       .
        brk                                     ; 89C2 00                       .
        brk                                     ; 89C3 00                       .
        brk                                     ; 89C4 00                       .
        brk                                     ; 89C5 00                       .
        brk                                     ; 89C6 00                       .
        brk                                     ; 89C7 00                       .
        .byte   $80                             ; 89C8 80                       .
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
        ora     $80                             ; 89E0 05 80                    ..
        .byte   $07                             ; 89E2 07                       .
        ora     $07                             ; 89E3 05 07                    ..
        rti                                     ; 89E5 40                       @

; ----------------------------------------------------------------------------
        ora     $02                             ; 89E6 05 02                    ..
        .byte   $0F                             ; 89E8 0F                       .
        .byte   $80                             ; 89E9 80                       .
        ora     ($0C),y                         ; 89EA 11 0C                    ..
        ora     ($40),y                         ; 89EC 11 40                    .@
        .byte   $0F                             ; 89EE 0F                       .
        ora     #$1A                            ; 89EF 09 1A                    ..
        .byte   $80                             ; 89F1 80                       .
        .byte   $1C                             ; 89F2 1C                       .
        .byte   $12                             ; 89F3 12                       .
        .byte   $1C                             ; 89F4 1C                       .
        rti                                     ; 89F5 40                       @

; ----------------------------------------------------------------------------
        .byte   $1A                             ; 89F6 1A                       .
        .byte   $0F                             ; 89F7 0F                       .
        .byte   $FF                             ; 89F8 FF                       .
        brk                                     ; 89F9 00                       .
        brk                                     ; 89FA 00                       .
        brk                                     ; 89FB 00                       .
        .byte   $02                             ; 89FC 02                       .
        rti                                     ; 89FD 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 89FE 00                       .
        brk                                     ; 89FF 00                       .
        ora     ($01,x)                         ; 8A00 01 01                    ..
        .byte   $02                             ; 8A02 02                       .
        .byte   $03                             ; 8A03 03                       .
        .byte   $03                             ; 8A04 03                       .
        .byte   $04                             ; 8A05 04                       .
        .byte   $04                             ; 8A06 04                       .
        .byte   $04                             ; 8A07 04                       .
        ora     $05                             ; 8A08 05 05                    ..
        ora     $06                             ; 8A0A 05 06                    ..
        .byte   $07                             ; 8A0C 07                       .
        .byte   $07                             ; 8A0D 07                       .
        .byte   $07                             ; 8A0E 07                       .
        php                                     ; 8A0F 08                       .
        php                                     ; 8A10 08                       .
        ora     #$09                            ; 8A11 09 09                    ..
        ora     #$0A                            ; 8A13 09 0A                    ..
        asl     a                               ; 8A15 0A                       .
        .byte   $0B                             ; 8A16 0B                       .
        .byte   $0B                             ; 8A17 0B                       .
        .byte   $0B                             ; 8A18 0B                       .
        .byte   $0B                             ; 8A19 0B                       .
L8A1A:  .byte   $0C                             ; 8A1A 0C                       .
        .byte   $0C                             ; 8A1B 0C                       .
        .byte   $0C                             ; 8A1C 0C                       .
        ora     $0D0D                           ; 8A1D 0D 0D 0D                 ...
        ora     $0E0D                           ; 8A20 0D 0D 0E                 ...
        asl     $0F0E                           ; 8A23 0E 0E 0F                 ...
L8A26:  .byte   $0F                             ; 8A26 0F                       .
        .byte   $0F                             ; 8A27 0F                       .
        bpl     L8A3A                           ; 8A28 10 10                    ..
        bpl     L8A3D                           ; 8A2A 10 11                    ..
        .byte   $12                             ; 8A2C 12                       .
        .byte   $12                             ; 8A2D 12                       .
        .byte   $12                             ; 8A2E 12                       .
        .byte   $12                             ; 8A2F 12                       .
        .byte   $12                             ; 8A30 12                       .
        .byte   $12                             ; 8A31 12                       .
        .byte   $12                             ; 8A32 12                       .
        .byte   $12                             ; 8A33 12                       .
        .byte   $13                             ; 8A34 13                       .
        .byte   $13                             ; 8A35 13                       .
L8A36:  .byte   $13                             ; 8A36 13                       .
        .byte   $13                             ; 8A37 13                       .
L8A38:  .byte   $13                             ; 8A38 13                       .
L8A39:  .byte   $13                             ; 8A39 13                       .
L8A3A:  .byte   $14                             ; 8A3A 14                       .
        .byte   $14                             ; 8A3B 14                       .
        .byte   $14                             ; 8A3C 14                       .
L8A3D:  .byte   $14                             ; 8A3D 14                       .
        ora     $15,x                           ; 8A3E 15 15                    ..
        ora     $15,x                           ; 8A40 15 15                    ..
        asl     $17,x                           ; 8A42 16 17                    ..
        .byte   $17                             ; 8A44 17                       .
        .byte   $17                             ; 8A45 17                       .
        .byte   $17                             ; 8A46 17                       .
        clc                                     ; 8A47 18                       .
        clc                                     ; 8A48 18                       .
        clc                                     ; 8A49 18                       .
        clc                                     ; 8A4A 18                       .
        ora     $1919,y                         ; 8A4B 19 19 19                 ...
        ora     $1B1A,y                         ; 8A4E 19 1A 1B                 ...
        .byte   $1B                             ; 8A51 1B                       .
        ora     $1D1D,x                         ; 8A52 1D 1D 1D                 ...
        asl     $1E1E,x                         ; 8A55 1E 1E 1E                 ...
        asl     $1F1F,x                         ; 8A58 1E 1F 1F                 ...
        and     ($FF,x)                         ; 8A5B 21 FF                    !.
        brk                                     ; 8A5D 00                       .
        brk                                     ; 8A5E 00                       .
        brk                                     ; 8A5F 00                       .
        brk                                     ; 8A60 00                       .
L8A61:  brk                                     ; 8A61 00                       .
        brk                                     ; 8A62 00                       .
        brk                                     ; 8A63 00                       .
        brk                                     ; 8A64 00                       .
        brk                                     ; 8A65 00                       .
        brk                                     ; 8A66 00                       .
        brk                                     ; 8A67 00                       .
        brk                                     ; 8A68 00                       .
L8A69:  brk                                     ; 8A69 00                       .
L8A6A:  brk                                     ; 8A6A 00                       .
        brk                                     ; 8A6B 00                       .
        brk                                     ; 8A6C 00                       .
        brk                                     ; 8A6D 00                       .
        brk                                     ; 8A6E 00                       .
        brk                                     ; 8A6F 00                       .
L8A70:  brk                                     ; 8A70 00                       .
        brk                                     ; 8A71 00                       .
        brk                                     ; 8A72 00                       .
        brk                                     ; 8A73 00                       .
        brk                                     ; 8A74 00                       .
        ora     (L0000,x)                       ; 8A75 01 00                    ..
        brk                                     ; 8A77 00                       .
        brk                                     ; 8A78 00                       .
        brk                                     ; 8A79 00                       .
        brk                                     ; 8A7A 00                       .
        brk                                     ; 8A7B 00                       .
        brk                                     ; 8A7C 00                       .
        brk                                     ; 8A7D 00                       .
        brk                                     ; 8A7E 00                       .
        brk                                     ; 8A7F 00                       .
        jsr     L70C0                           ; 8A80 20 C0 70                  .p
        bmi     L8AED                           ; 8A83 30 68                    0h
        pha                                     ; 8A85 48                       H
        bne     L8A70                           ; 8A86 D0 E8                    ..
        bvs     L8A1A                           ; 8A88 70 90                    p.
        cld                                     ; 8A8A D8                       .
        bcs     L8ADD                           ; 8A8B B0 50                    .P
        .byte   $80                             ; 8A8D 80                       .
        .byte   $E0                             ; 8A8E E0                       .
L8A8F:  .byte   $B0,$E8                    ; 8A8F B0 E8   (branch out of range for ca65: target has no local label)
        bpl     L8AE3                           ; 8A91 10 50                    .P
        .byte   $80                             ; 8A93 80                       .
        bmi     L8A26                           ; 8A94 30 90                    0.
        plp                                     ; 8A96 28                       (
        bvc     L8A39                           ; 8A97 50 A0                    P.
        lda     L8070,y                         ; 8A99 B9 70 80                 .p.
        beq     L8AAE                           ; 8A9C F0 10                    ..
        .byte   $6F                             ; 8A9E 6F                       o
        adc     ($B0),y                         ; 8A9F 71 B0                    q.
        beq     L8AF3                           ; 8AA1 F0 50                    .P
        ldy     #$A0                            ; 8AA3 A0 A0                    ..
        brk                                     ; 8AA5 00                       .
        bmi     L8A38                           ; 8AA6 30 90                    0.
        pla                                     ; 8AA8 68                       h
        tay                                     ; 8AA9 A8                       .
        cld                                     ; 8AAA D8                       .
        jsr     L0402                           ; 8AAB 20 02 04                  ..
L8AAE:  jsr     L6020                           ; 8AAE 20 20 60                   `
        stx     $97,y                           ; 8AB1 96 97                    ..
        tya                                     ; 8AB3 98                       .
        bmi     L8A36                           ; 8AB4 30 80                    0.
        sta     ($90,x)                         ; 8AB6 81 90                    ..
        cpx     #$E1                            ; 8AB8 E0 E1                    ..
        bcc     L8A6A                           ; 8ABA 90 AE                    ..
        .byte   $AF                             ; 8ABC AF                       .
        beq     L8ADF                           ; 8ABD F0 20                    . 
        and     ($22,x)                         ; 8ABF 21 22                    !"
        clv                                     ; 8AC1 B8                       .
        bmi     L8B24                           ; 8AC2 30 60                    0`
        .byte   $61                             ; 8AC4 61                       a
L8AC5:  dey                                     ; 8AC5 88                       .
        cpy     #$10                            ; 8AC6 C0 10                    ..
        ora     ($88),y                         ; 8AC8 11 88                    ..
        ldy     #$18                            ; 8ACA A0 18                    ..
        rti                                     ; 8ACC 40                       @

; ----------------------------------------------------------------------------
        .byte   $50                             ; 8ACD 50                       P
L8ACE:  cpy     #$50                            ; 8ACE C0 50                    .P
        .byte   $90,$B0                    ; 8AD0 90 B0   (branch out of range for ca65: target has no local label)
        jsr     $F0B0                           ; 8AD2 20 B0 F0                  ..
        bpl     L8B17                           ; 8AD5 10 40                    .@
        bvs     L8A69                           ; 8AD7 70 90                    p.
        sei                                     ; 8AD9 78                       x
        adc     $FFD8,y                         ; 8ADA 79 D8 FF                 y..
L8ADD:  brk                                     ; 8ADD 00                       .
        brk                                     ; 8ADE 00                       .
L8ADF:  brk                                     ; 8ADF 00                       .
        brk                                     ; 8AE0 00                       .
        brk                                     ; 8AE1 00                       .
        brk                                     ; 8AE2 00                       .
L8AE3:  brk                                     ; 8AE3 00                       .
        brk                                     ; 8AE4 00                       .
        brk                                     ; 8AE5 00                       .
        brk                                     ; 8AE6 00                       .
        brk                                     ; 8AE7 00                       .
L8AE8:  brk                                     ; 8AE8 00                       .
        brk                                     ; 8AE9 00                       .
        brk                                     ; 8AEA 00                       .
        brk                                     ; 8AEB 00                       .
        brk                                     ; 8AEC 00                       .
L8AED:  brk                                     ; 8AED 00                       .
        brk                                     ; 8AEE 00                       .
        brk                                     ; 8AEF 00                       .
L8AF0:  brk                                     ; 8AF0 00                       .
        brk                                     ; 8AF1 00                       .
        brk                                     ; 8AF2 00                       .
L8AF3:  brk                                     ; 8AF3 00                       .
        jsr     L0000                           ; 8AF4 20 00 00                  ..
        brk                                     ; 8AF7 00                       .
        brk                                     ; 8AF8 00                       .
        brk                                     ; 8AF9 00                       .
        brk                                     ; 8AFA 00                       .
        php                                     ; 8AFB 08                       .
        brk                                     ; 8AFC 00                       .
        brk                                     ; 8AFD 00                       .
        brk                                     ; 8AFE 00                       .
        brk                                     ; 8AFF 00                       .
        tsx                                     ; 8B00 BA                       .
        txs                                     ; 8B01 9A                       .
        ror     a                               ; 8B02 6A                       j
        .byte   $1B                             ; 8B03 1B                       .
        .byte   $1B                             ; 8B04 1B                       .
        .byte   $9B                             ; 8B05 9B                       .
        jmp     (LB82B)                         ; 8B06 6C 2B B8                 l+.

; ----------------------------------------------------------------------------
        .byte   $5C                             ; 8B09 5C                       \
        sei                                     ; 8B0A 78                       x
        iny                                     ; 8B0B C8                       .
        .byte   $5C                             ; 8B0C 5C                       \
        .byte   $2B                             ; 8B0D 2B                       +
        .byte   $3B                             ; 8B0E 3B                       ;
        .byte   $6B                             ; 8B0F 6B                       k
        pha                                     ; 8B10 48                       H
        bcs     L8B5E                           ; 8B11 B0 4B                    .K
        rol     a                               ; 8B13 2A                       *
        rol     a                               ; 8B14 2A                       *
        cpy     #$31                            ; 8B15 C0 31                    .1
L8B17:  cli                                     ; 8B17 58                       X
        .byte   $7B                             ; 8B18 7B                       {
        and     ($BC),y                         ; 8B19 31 BC                    1.
        .byte   $5A                             ; 8B1B 5A                       Z
        lsr     a                               ; 8B1C 4A                       J
        ldy     $D82A                           ; 8B1D AC 2A D8                 .*.
        ldy     $3A2A,x                         ; 8B20 BC 2A 3A                 .*:
        rol     a                               ; 8B23 2A                       *
L8B24:  .byte   $9B                             ; 8B24 9B                       .
        brk                                     ; 8B25 00                       .
        sta     (L0021,x)                       ; 8B26 81 21                    .!
        and     ($90),y                         ; 8B28 31 90                    1.
        tya                                     ; 8B2A 98                       .
        brk                                     ; 8B2B 00                       .
        rti                                     ; 8B2C 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; 8B2D 80                       .
        brk                                     ; 8B2E 00                       .
        brk                                     ; 8B2F 00                       .
        bcc     L8B92                           ; 8B30 90 60                    .`
        .byte   $80                             ; 8B32 80                       .
        tay                                     ; 8B33 A8                       .
        bcc     L8B76                           ; 8B34 90 40                    .@
        bvs     L8AE8                           ; 8B36 70 B0                    p.
        bvc     L8BAA                           ; 8B38 50 70                    Pp
        ldy     #$50                            ; 8B3A A0 50                    .P
        bvs     L8ACE                           ; 8B3C 70 90                    p.
        bmi     L8BA0                           ; 8B3E 30 60                    0`
        rti                                     ; 8B40 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; 8B41 80                       .
        cli                                     ; 8B42 58                       X
        tay                                     ; 8B43 A8                       .
        jsr     L6040                           ; 8B44 20 40 60                  @`
        jsr     L8040                           ; 8B47 20 40 80                  @.
        iny                                     ; 8B4A C8                       .
        clc                                     ; 8B4B 18                       .
        cli                                     ; 8B4C 58                       X
        iny                                     ; 8B4D C8                       .
        bcc     L8AE8                           ; 8B4E 90 98                    ..
        tay                                     ; 8B50 A8                       .
        clv                                     ; 8B51 B8                       .
        ror     a                               ; 8B52 6A                       j
        .byte   $7A                             ; 8B53 7A                       z
        bmi     L8AF0                           ; 8B54 30 9A                    0.
        lsr     a                               ; 8B56 4A                       J
        jsr     L5A8A                           ; 8B57 20 8A 5A                  .Z
        txs                                     ; 8B5A 9A                       .
        brk                                     ; 8B5B 00                       .
        .byte   $FF                             ; 8B5C FF                       .
        brk                                     ; 8B5D 00                       .
L8B5E:  brk                                     ; 8B5E 00                       .
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
        .byte   $02                             ; 8B72 02                       .
        brk                                     ; 8B73 00                       .
        brk                                     ; 8B74 00                       .
        brk                                     ; 8B75 00                       .
L8B76:  brk                                     ; 8B76 00                       .
        brk                                     ; 8B77 00                       .
        brk                                     ; 8B78 00                       .
        brk                                     ; 8B79 00                       .
        brk                                     ; 8B7A 00                       .
        brk                                     ; 8B7B 00                       .
        brk                                     ; 8B7C 00                       .
        brk                                     ; 8B7D 00                       .
        .byte   $02                             ; 8B7E 02                       .
        brk                                     ; 8B7F 00                       .
        and     ($31),y                         ; 8B80 31 31                    11
        and     ($34),y                         ; 8B82 31 34                    14
        .byte   $34                             ; 8B84 34                       4
        .byte   $34                             ; 8B85 34                       4
        and     ($34),y                         ; 8B86 31 34                    14
        .byte   $32                             ; 8B88 32                       2
        and     ($32),y                         ; 8B89 31 32                    12
        txa                                     ; 8B8B 8A                       .
        and     ($34),y                         ; 8B8C 31 34                    14
        .byte   $34                             ; 8B8E 34                       4
        .byte   $34                             ; 8B8F 34                       4
        .byte   $34                             ; 8B90 34                       4
        .byte   $35                             ; 8B91 35                       5
L8B92:  .byte   $34                             ; 8B92 34                       4
        .byte   $34                             ; 8B93 34                       4
        .byte   $34                             ; 8B94 34                       4
        and     $1C,x                           ; 8B95 35 1C                    5.
        sty     $31                             ; 8B97 84 31                    .1
        .byte   $1C                             ; 8B99 1C                       .
        ora     $34                             ; 8B9A 05 34                    .4
        .byte   $34                             ; 8B9C 34                       4
        ora     $34                             ; 8B9D 05 34                    .4
        .byte   $84                             ; 8B9F 84                       .
L8BA0:  ora     $34                             ; 8BA0 05 34                    .4
        .byte   $34                             ; 8BA2 34                       4
        .byte   $34                             ; 8BA3 34                       4
        and     ($EF),y                         ; 8BA4 31 EF                    1.
        .byte   $1C                             ; 8BA6 1C                       .
        .byte   $1C                             ; 8BA7 1C                       .
        .byte   $1C                             ; 8BA8 1C                       .
        .byte   $35                             ; 8BA9 35                       5
L8BAA:  .byte   $82                             ; 8BAA 82                       .
        dec     $61                             ; 8BAB C6 61                    .a
        adc     ($D6,x)                         ; 8BAD 61 D6                    a.
        .byte   $C7                             ; 8BAF C7                       .
        .byte   $14                             ; 8BB0 14                       .
        adc     ($61,x)                         ; 8BB1 61 61                    aa
        and     ($14,x)                         ; 8BB3 21 14                    !.
        adc     ($61,x)                         ; 8BB5 61 61                    aa
        .byte   $14                             ; 8BB7 14                       .
        adc     ($61,x)                         ; 8BB8 61 61                    aa
        .byte   $14                             ; 8BBA 14                       .
        adc     ($61,x)                         ; 8BBB 61 61                    aa
        .byte   $14                             ; 8BBD 14                       .
        adc     ($61,x)                         ; 8BBE 61 61                    aa
        adc     ($14,x)                         ; 8BC0 61 14                    a.
        .byte   $83                             ; 8BC2 83                       .
        and     ($61,x)                         ; 8BC3 21 61                    !a
        adc     ($61,x)                         ; 8BC5 61 61                    aa
        adc     ($61,x)                         ; 8BC7 61 61                    aa
        adc     (L0020,x)                       ; 8BC9 61 20                    a 
        sta     ($22,x)                         ; 8BCB 81 22                    ."
        .byte   $22                             ; 8BCD 22                       "
        rol     $80                             ; 8BCE 26 80                    &.
        stx     $84                             ; 8BD0 86 84                    ..
        and     ($61),y                         ; 8BD2 31 61                    1a
        adc     ($31,x)                         ; 8BD4 61 31                    a1
        and     ($61),y                         ; 8BD6 31 61                    1a
        adc     ($61,x)                         ; 8BD8 61 61                    aa
        and     ($62),y                         ; 8BDA 31 62                    1b
        .byte   $FF                             ; 8BDC FF                       .
        brk                                     ; 8BDD 00                       .
        brk                                     ; 8BDE 00                       .
L8BDF:  brk                                     ; 8BDF 00                       .
        brk                                     ; 8BE0 00                       .
        brk                                     ; 8BE1 00                       .
        brk                                     ; 8BE2 00                       .
        brk                                     ; 8BE3 00                       .
        brk                                     ; 8BE4 00                       .
        brk                                     ; 8BE5 00                       .
        brk                                     ; 8BE6 00                       .
        .byte   $04                             ; 8BE7 04                       .
        brk                                     ; 8BE8 00                       .
        brk                                     ; 8BE9 00                       .
        brk                                     ; 8BEA 00                       .
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
        bpl     L8BFB                           ; 8BF9 10 00                    ..
L8BFB:  brk                                     ; 8BFB 00                       .
        brk                                     ; 8BFC 00                       .
        brk                                     ; 8BFD 00                       .
        brk                                     ; 8BFE 00                       .
        brk                                     ; 8BFF 00                       .
        brk                                     ; 8C00 00                       .
        brk                                     ; 8C01 00                       .
        .byte   $02                             ; 8C02 02                       .
        .byte   $03                             ; 8C03 03                       .
        ora     $08                             ; 8C04 05 08                    ..
        .byte   $0B                             ; 8C06 0B                       .
        .byte   $0C                             ; 8C07 0C                       .
        .byte   $0F                             ; 8C08 0F                       .
        ora     ($14),y                         ; 8C09 11 14                    ..
        asl     $1A,x                           ; 8C0B 16 1A                    ..
        ora     $2522,x                         ; 8C0D 1D 22 25                 ."%
        plp                                     ; 8C10 28                       (
        .byte   $2B                             ; 8C11 2B                       +
        bit     $3A34                           ; 8C12 2C 34 3A                 ,4:
        rol     $4342,x                         ; 8C15 3E 42 43                 >BC
        .byte   $47                             ; 8C18 47                       G
        .byte   $4B                             ; 8C19 4B                       K
        .byte   $4F                             ; 8C1A 4F                       O
        bvc     L8C6F                           ; 8C1B 50 52                    PR
        .byte   $52                             ; 8C1D 52                       R
        eor     $59,x                           ; 8C1E 55 59                    UY
        .byte   $5B                             ; 8C20 5B                       [
        .byte   $5B                             ; 8C21 5B                       [
        brk                                     ; 8C22 00                       .
        brk                                     ; 8C23 00                       .
        brk                                     ; 8C24 00                       .
        brk                                     ; 8C25 00                       .
        brk                                     ; 8C26 00                       .
        brk                                     ; 8C27 00                       .
        brk                                     ; 8C28 00                       .
        brk                                     ; 8C29 00                       .
        brk                                     ; 8C2A 00                       .
        brk                                     ; 8C2B 00                       .
        brk                                     ; 8C2C 00                       .
        brk                                     ; 8C2D 00                       .
        brk                                     ; 8C2E 00                       .
        brk                                     ; 8C2F 00                       .
        brk                                     ; 8C30 00                       .
        brk                                     ; 8C31 00                       .
        brk                                     ; 8C32 00                       .
        brk                                     ; 8C33 00                       .
        brk                                     ; 8C34 00                       .
        brk                                     ; 8C35 00                       .
        brk                                     ; 8C36 00                       .
        brk                                     ; 8C37 00                       .
        brk                                     ; 8C38 00                       .
        brk                                     ; 8C39 00                       .
        brk                                     ; 8C3A 00                       .
        brk                                     ; 8C3B 00                       .
        brk                                     ; 8C3C 00                       .
        brk                                     ; 8C3D 00                       .
        brk                                     ; 8C3E 00                       .
        brk                                     ; 8C3F 00                       .
        brk                                     ; 8C40 00                       .
        brk                                     ; 8C41 00                       .
        brk                                     ; 8C42 00                       .
        brk                                     ; 8C43 00                       .
        brk                                     ; 8C44 00                       .
        brk                                     ; 8C45 00                       .
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
        brk                                     ; 8C54 00                       .
        brk                                     ; 8C55 00                       .
        brk                                     ; 8C56 00                       .
        brk                                     ; 8C57 00                       .
        brk                                     ; 8C58 00                       .
        brk                                     ; 8C59 00                       .
        brk                                     ; 8C5A 00                       .
        brk                                     ; 8C5B 00                       .
        brk                                     ; 8C5C 00                       .
        brk                                     ; 8C5D 00                       .
        brk                                     ; 8C5E 00                       .
        brk                                     ; 8C5F 00                       .
        php                                     ; 8C60 08                       .
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
L8C6F:  brk                                     ; 8C6F 00                       .
        brk                                     ; 8C70 00                       .
        brk                                     ; 8C71 00                       .
        brk                                     ; 8C72 00                       .
        brk                                     ; 8C73 00                       .
        brk                                     ; 8C74 00                       .
        brk                                     ; 8C75 00                       .
        brk                                     ; 8C76 00                       .
        brk                                     ; 8C77 00                       .
        brk                                     ; 8C78 00                       .
        brk                                     ; 8C79 00                       .
        brk                                     ; 8C7A 00                       .
        brk                                     ; 8C7B 00                       .
        brk                                     ; 8C7C 00                       .
        brk                                     ; 8C7D 00                       .
        brk                                     ; 8C7E 00                       .
        brk                                     ; 8C7F 00                       .
        brk                                     ; 8C80 00                       .
        brk                                     ; 8C81 00                       .
        brk                                     ; 8C82 00                       .
        brk                                     ; 8C83 00                       .
        brk                                     ; 8C84 00                       .
        brk                                     ; 8C85 00                       .
        brk                                     ; 8C86 00                       .
        brk                                     ; 8C87 00                       .
        brk                                     ; 8C88 00                       .
        brk                                     ; 8C89 00                       .
L8C8A:  brk                                     ; 8C8A 00                       .
        brk                                     ; 8C8B 00                       .
        brk                                     ; 8C8C 00                       .
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
        rti                                     ; 8CAA 40                       @

; ----------------------------------------------------------------------------
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
        rti                                     ; 8CF2 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8CF3 00                       .
        brk                                     ; 8CF4 00                       .
        brk                                     ; 8CF5 00                       .
        brk                                     ; 8CF6 00                       .
        brk                                     ; 8CF7 00                       .
        brk                                     ; 8CF8 00                       .
        brk                                     ; 8CF9 00                       .
        rti                                     ; 8CFA 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8CFB 00                       .
        brk                                     ; 8CFC 00                       .
        brk                                     ; 8CFD 00                       .
        brk                                     ; 8CFE 00                       .
        brk                                     ; 8CFF 00                       .
        brk                                     ; 8D00 00                       .
        bpl     L8D07                           ; 8D01 10 04                    ..
        asl     $2E                             ; 8D03 06 2E                    ..
        .byte   $3C                             ; 8D05 3C                       <
        .byte   $2E                             ; 8D06 2E                       .
L8D07:  inc     $010E                           ; 8D07 EE 0E 01                 ...
        bit     $26                             ; 8D0A 24 26                    $&
        .byte   $8F                             ; 8D0C 8F                       .
        .byte   $8F                             ; 8D0D 8F                       .
        .byte   $8F                             ; 8D0E 8F                       .
        dec     $4240                           ; 8D0F CE 40 42                 .@B
        cpy     $40CE                           ; 8D12 CC CE 40                 ..@
        .byte   $42                             ; 8D15 42                       B
        cpy     $448F                           ; 8D16 CC 8F 44                 ..D
        lsr     $EC                             ; 8D19 46 EC                    F.
        inc     $6664                           ; 8D1B EE 64 66                 .df
        plp                                     ; 8D1E 28                       (
        rol     a                               ; 8D1F 2A                       *
        brk                                     ; 8D20 00                       .
        eor     $C700                           ; 8D21 4D 00 C7                 M..
        pla                                     ; 8D24 68                       h
        asl     $E5E3                           ; 8D25 0E E3 E5                 ...
        brk                                     ; 8D28 00                       .
        jmp     LE700                           ; 8D29 4C 00 E7                 L..

; ----------------------------------------------------------------------------
        ora     (L0000,x)                       ; 8D2C 01 00                    ..
        cpy     $C6                             ; 8D2E C4 C6                    ..
        .byte   $80                             ; 8D30 80                       .
        .byte   $82                             ; 8D31 82                       .
        ror     a                               ; 8D32 6A                       j
        jmp     (L0000)                         ; 8D33 6C 00 00                 l..

; ----------------------------------------------------------------------------
        brk                                     ; 8D36 00                       .
        dec     $2A0C                           ; 8D37 CE 0C 2A                 ..*
        lsr     $026E                           ; 8D3A 4E 6E 02                 Nn.
        ora     ($2E,x)                         ; 8D3D 01 2E                    ..
        .byte   $CF                             ; 8D3F CF                       .
        .byte   $44                             ; 8D40 44                       D
        lsr     L0000                           ; 8D41 46 00                    F.
        brk                                     ; 8D43 00                       .
        brk                                     ; 8D44 00                       .
        brk                                     ; 8D45 00                       .
        .byte   $04                             ; 8D46 04                       .
        asl     L0000                           ; 8D47 06 00                    ..
        brk                                     ; 8D49 00                       .
        brk                                     ; 8D4A 00                       .
        brk                                     ; 8D4B 00                       .
        brk                                     ; 8D4C 00                       .
        brk                                     ; 8D4D 00                       .
        bit     $26                             ; 8D4E 24 26                    $&
        dey                                     ; 8D50 88                       .
        .byte   $C2                             ; 8D51 C2                       .
        brk                                     ; 8D52 00                       .
        brk                                     ; 8D53 00                       .
        brk                                     ; 8D54 00                       .
        brk                                     ; 8D55 00                       .
        brk                                     ; 8D56 00                       .
        brk                                     ; 8D57 00                       .
        txa                                     ; 8D58 8A                       .
        tay                                     ; 8D59 A8                       .
        tax                                     ; 8D5A AA                       .
        sty     $DA10                           ; 8D5B 8C 10 DA                 ...
        ldx     $CA3E                           ; 8D5E AE 3E CA                 .>.
        iny                                     ; 8D61 C8                       .
        dex                                     ; 8D62 CA                       .
        cld                                     ; 8D63 D8                       .
        bpl     L8D67                           ; 8D64 10 01                    ..
        .byte   $01                             ; 8D66 01                       .
L8D67:  brk                                     ; 8D67 00                       .
        sta     $0202,y                         ; 8D68 99 02 02                 ...
        .byte   $02                             ; 8D6B 02                       .
        ora     ($92,x)                         ; 8D6C 01 92                    ..
        cpx     #$E2                            ; 8D6E E0 E2                    ..
        brk                                     ; 8D70 00                       .
        .byte   $02                             ; 8D71 02                       .
        stx     $0100                           ; 8D72 8E 00 01                 ...
        .byte   $B2                             ; 8D75 B2                       .
        brk                                     ; 8D76 00                       .
        brk                                     ; 8D77 00                       .
        brk                                     ; 8D78 00                       .
        brk                                     ; 8D79 00                       .
        ora     ($01,x)                         ; 8D7A 01 01                    ..
        ldy     $A6                             ; 8D7C A4 A6                    ..
        brk                                     ; 8D7E 00                       .
        brk                                     ; 8D7F 00                       .
        sty     $86                             ; 8D80 84 86                    ..
        sty     L0000,x                         ; 8D82 94 00                    ..
        brk                                     ; 8D84 00                       .
        brk                                     ; 8D85 00                       .
        rts                                     ; 8D86 60                       `

; ----------------------------------------------------------------------------
        .byte   $62                             ; 8D87 62                       b
L8D88:  ldy     #$A2                            ; 8D88 A0 A2                    ..
        inx                                     ; 8D8A E8                       .
        nop                                     ; 8D8B EA                       .
        .byte   $EB                             ; 8D8C EB                       .
L8D8D:  ldx     #$64                            ; 8D8D A2 64                    .d
        ror     $C0                             ; 8D8F 66 C0                    f.
        .byte   $C2                             ; 8D91 C2                       .
        lsr     L804E                           ; 8D92 4E 4E 80                 NN.
        .byte   $82                             ; 8D95 82                       .
        cpy     $F4                             ; 8D96 C4 F4                    ..
        cpx     #$E2                            ; 8D98 E0 E2                    ..
        brk                                     ; 8D9A 00                       .
        brk                                     ; 8D9B 00                       .
        cpy     $E4                             ; 8D9C C4 E4                    ..
        .byte   $D4                             ; 8D9E D4                       .
        ora     ($4E,x)                         ; 8D9F 01 4E                    .N
L8DA1:  lsr     a:$4E                           ; 8DA1 4E 4E 00                 NN.
        brk                                     ; 8DA4 00                       .
        brk                                     ; 8DA5 00                       .
        brk                                     ; 8DA6 00                       .
        brk                                     ; 8DA7 00                       .
        lsr     $4E00                           ; 8DA8 4E 00 4E                 N.N
        brk                                     ; 8DAB 00                       .
        brk                                     ; 8DAC 00                       .
        .byte   $CF                             ; 8DAD CF                       .
        .byte   $CF                             ; 8DAE CF                       .
        brk                                     ; 8DAF 00                       .
        brk                                     ; 8DB0 00                       .
        brk                                     ; 8DB1 00                       .
        ldy     $CFAE                           ; 8DB2 AC AE CF                 ...
        .byte   $CF                             ; 8DB5 CF                       .
        rti                                     ; 8DB6 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; 8DB7 42                       B
        tax                                     ; 8DB8 AA                       .
        cpy     a:L0000                         ; 8DB9 CC 00 00                 ...
        .byte   $CF                             ; 8DBC CF                       .
        .byte   $CF                             ; 8DBD CF                       .
        .byte   $44                             ; 8DBE 44                       D
        lsr     $80                             ; 8DBF 46 80                    F.
        .byte   $82                             ; 8DC1 82                       .
        .byte   $4F                             ; 8DC2 4F                       O
        lsr     a:L0000                         ; 8DC3 4E 00 00                 N..
        dey                                     ; 8DC6 88                       .
        brk                                     ; 8DC7 00                       .
        asl     L8584,x                         ; 8DC8 1E 84 85                 ...
        sta     $A5                             ; 8DCB 85 A5                    ..
        ror     $0184                           ; 8DCD 6E 84 01                 n..
        pha                                     ; 8DD0 48                       H
        ldy     $A5                             ; 8DD1 A4 A5                    ..
        ora     ($D6,x)                         ; 8DD3 01 D6                    ..
        ora     ($01,x)                         ; 8DD5 01 01                    ..
        ora     ($94,x)                         ; 8DD7 01 94                    ..
        stx     $87                             ; 8DD9 86 87                    ..
        .byte   $D7                             ; 8DDB D7                       .
        ora     ($85,x)                         ; 8DDC 01 85                    ..
        stx     $87                             ; 8DDE 86 87                    ..
        php                                     ; 8DE0 08                       .
        asl     a                               ; 8DE1 0A                       .
        brk                                     ; 8DE2 00                       .
        cpx     #$E2                            ; 8DE3 E0 E2                    ..
        ora     ($87,x)                         ; 8DE5 01 87                    ..
        .byte   $97                             ; 8DE7 97                       .
        jsr     LB022                           ; 8DE8 20 22 B0                  ".
        tax                                     ; 8DEB AA                       .
        .byte   $B2                             ; 8DEC B2                       .
        .byte   $D2                             ; 8DED D2                       .
        .byte   $E2                             ; 8DEE E2                       .
        .byte   $87                             ; 8DEF 87                       .
        ldy     L80AE                           ; 8DF0 AC AE 80                 ...
        sta     ($D2,x)                         ; 8DF3 81 D2                    ..
        bcs     L8DA1                           ; 8DF5 B0 AA                    ..
        .byte   $B2                             ; 8DF7 B2                       .
        tay                                     ; 8DF8 A8                       .
        dey                                     ; 8DF9 88                       .
        ldy     #$C0                            ; 8DFA A0 C0                    ..
        ldx     #$88                            ; 8DFC A2 88                    ..
        cpy     a:$CE                           ; 8DFE CC CE 00                 ...
        bpl     L8E08                           ; 8E01 10 05                    ..
        .byte   $07                             ; 8E03 07                       .
        .byte   $2F                             ; 8E04 2F                       /
        and     $EE2F,x                         ; 8E05 3D 2F EE                 =/.
L8E08:  .byte   $0F                             ; 8E08 0F                       .
        ora     ($25,x)                         ; 8E09 01 25                    .%
        .byte   $27                             ; 8E0B 27                       '
        .byte   $8F                             ; 8E0C 8F                       .
        .byte   $8F                             ; 8E0D 8F                       .
        .byte   $8F                             ; 8E0E 8F                       .
        .byte   $CF                             ; 8E0F CF                       .
        eor     ($43,x)                         ; 8E10 41 43                    AC
        cmp     $41CF                           ; 8E12 CD CF 41                 ..A
        .byte   $43                             ; 8E15 43                       C
        cmp     $459F                           ; 8E16 CD 9F 45                 ..E
        .byte   $47                             ; 8E19 47                       G
        sbc     $65EF                           ; 8E1A ED EF 65                 ..e
        .byte   $67                             ; 8E1D 67                       g
        and     #$2B                            ; 8E1E 29 2B                    )+
        lsr     a                               ; 8E20 4A                       J
        brk                                     ; 8E21 00                       .
        dec     L0000                           ; 8E22 C6 00                    ..
        adc     #$0F                            ; 8E24 69 0F                    i.
        cpx     $E6                             ; 8E26 E4 E6                    ..
        .byte   $4B                             ; 8E28 4B                       K
        brk                                     ; 8E29 00                       .
        inc     L0000                           ; 8E2A E6 00                    ..
        ora     (L0000,x)                       ; 8E2C 01 00                    ..
        cmp     $C7                             ; 8E2E C5 C7                    ..
        sta     ($83,x)                         ; 8E30 81 83                    ..
        .byte   $6B                             ; 8E32 6B                       k
        adc     a:L0000                         ; 8E33 6D 00 00                 m..
        brk                                     ; 8E36 00                       .
        dec     $0D29                           ; 8E37 CE 29 0D                 .).
        .byte   $4F                             ; 8E3A 4F                       O
        .byte   $6F                             ; 8E3B 6F                       o
        .byte   $02                             ; 8E3C 02                       .
        ora     ($2F,x)                         ; 8E3D 01 2F                    ./
        .byte   $CF                             ; 8E3F CF                       .
        eor     $47                             ; 8E40 45 47                    EG
        brk                                     ; 8E42 00                       .
        brk                                     ; 8E43 00                       .
        brk                                     ; 8E44 00                       .
        brk                                     ; 8E45 00                       .
        ora     $07                             ; 8E46 05 07                    ..
        brk                                     ; 8E48 00                       .
        brk                                     ; 8E49 00                       .
        brk                                     ; 8E4A 00                       .
        brk                                     ; 8E4B 00                       .
        brk                                     ; 8E4C 00                       .
        brk                                     ; 8E4D 00                       .
        and     $27                             ; 8E4E 25 27                    %'
        .byte   $89                             ; 8E50 89                       .
        .byte   $C3                             ; 8E51 C3                       .
        brk                                     ; 8E52 00                       .
        brk                                     ; 8E53 00                       .
        brk                                     ; 8E54 00                       .
        brk                                     ; 8E55 00                       .
        brk                                     ; 8E56 00                       .
        brk                                     ; 8E57 00                       .
        .byte   $8B                             ; 8E58 8B                       .
        lda     #$AB                            ; 8E59 A9 AB                    ..
        lda     $DB98                           ; 8E5B AD 98 DB                 ...
        .byte   $AF                             ; 8E5E AF                       .
        .byte   $3F                             ; 8E5F 3F                       ?
        tya                                     ; 8E60 98                       .
        cmp     #$10                            ; 8E61 C9 10                    ..
        cmp     $01BC,y                         ; 8E63 D9 BC 01                 ...
        ora     (L0000,x)                       ; 8E66 01 00                    ..
        sta     L9D02,y                         ; 8E68 99 02 9D                 ...
        sta     L9391,x                         ; 8E6B 9D 91 93                 ...
        sbc     ($E3,x)                         ; 8E6E E1 E3                    ..
        brk                                     ; 8E70 00                       .
        .byte   $02                             ; 8E71 02                       .
        bpl     L8E74                           ; 8E72 10 00                    ..
L8E74:  lda     ($B3),y                         ; 8E74 B1 B3                    ..
        brk                                     ; 8E76 00                       .
        brk                                     ; 8E77 00                       .
        brk                                     ; 8E78 00                       .
        brk                                     ; 8E79 00                       .
        ora     ($01,x)                         ; 8E7A 01 01                    ..
        lda     $01                             ; 8E7C A5 01                    ..
        brk                                     ; 8E7E 00                       .
        brk                                     ; 8E7F 00                       .
        sta     $87                             ; 8E80 85 87                    ..
        .byte   $02                             ; 8E82 02                       .
        brk                                     ; 8E83 00                       .
        brk                                     ; 8E84 00                       .
        brk                                     ; 8E85 00                       .
        adc     ($63,x)                         ; 8E86 61 63                    ac
        lda     ($A3,x)                         ; 8E88 A1 A3                    ..
        sbc     #$EA                            ; 8E8A E9 EA                    ..
        .byte   $EC                             ; 8E8C EC                       .
L8E8D:  .byte   $EF                             ; 8E8D EF                       .
        adc     $67                             ; 8E8E 65 67                    eg
        cmp     ($C3,x)                         ; 8E90 C1 C3                    ..
        lsr     L814E                           ; 8E92 4E 4E 81                 NN.
        .byte   $83                             ; 8E95 83                       .
        .byte   $F4                             ; 8E96 F4                       .
        cmp     $E1                             ; 8E97 C5 E1                    ..
        .byte   $E3                             ; 8E99 E3                       .
        brk                                     ; 8E9A 00                       .
        brk                                     ; 8E9B 00                       .
        cmp     $E5                             ; 8E9C C5 E5                    ..
        ora     ($D5,x)                         ; 8E9E 01 D5                    ..
        lsr     $4E4E                           ; 8EA0 4E 4E 4E                 NNN
        brk                                     ; 8EA3 00                       .
        brk                                     ; 8EA4 00                       .
        brk                                     ; 8EA5 00                       .
        brk                                     ; 8EA6 00                       .
        brk                                     ; 8EA7 00                       .
        lsr     $4E00                           ; 8EA8 4E 00 4E                 N.N
        brk                                     ; 8EAB 00                       .
        brk                                     ; 8EAC 00                       .
        .byte   $CF                             ; 8EAD CF                       .
        .byte   $CF                             ; 8EAE CF                       .
        brk                                     ; 8EAF 00                       .
        brk                                     ; 8EB0 00                       .
        brk                                     ; 8EB1 00                       .
        lda     $CF01                           ; 8EB2 AD 01 CF                 ...
        .byte   $CF                             ; 8EB5 CF                       .
        eor     ($43,x)                         ; 8EB6 41 43                    AC
        ora     ($CD,x)                         ; 8EB8 01 CD                    ..
        brk                                     ; 8EBA 00                       .
        brk                                     ; 8EBB 00                       .
        .byte   $CF                             ; 8EBC CF                       .
        .byte   $CF                             ; 8EBD CF                       .
        eor     $47                             ; 8EBE 45 47                    EG
        sta     ($83,x)                         ; 8EC0 81 83                    ..
        .byte   $4F                             ; 8EC2 4F                       O
        .byte   $4E                             ; 8EC3 4E                       N
L8EC4:  brk                                     ; 8EC4 00                       .
        brk                                     ; 8EC5 00                       .
        .byte   $89                             ; 8EC6 89                       .
        brk                                     ; 8EC7 00                       .
        brk                                     ; 8EC8 00                       .
        sta     $86                             ; 8EC9 85 86                    ..
        sta     $94                             ; 8ECB 85 94                    ..
        .byte   $6F                             ; 8ECD 6F                       o
        sta     $01                             ; 8ECE 85 01                    ..
        brk                                     ; 8ED0 00                       .
        lda     $B6                             ; 8ED1 A5 B6                    ..
        ora     ($D7,x)                         ; 8ED3 01 D7                    ..
        ora     ($01,x)                         ; 8ED5 01 01                    ..
        dec     $A5,x                           ; 8ED7 D6 A5                    ..
        stx     $85,y                           ; 8ED9 96 85                    ..
        ora     ($01,x)                         ; 8EDB 01 01                    ..
        .byte   $87                             ; 8EDD 87                       .
        brk                                     ; 8EDE 00                       .
        .byte   $87                             ; 8EDF 87                       .
        ora     #$0B                            ; 8EE0 09 0B                    ..
        brk                                     ; 8EE2 00                       .
        sbc     ($E3,x)                         ; 8EE3 E1 E3                    ..
        ora     ($E2,x)                         ; 8EE5 01 E2                    ..
        .byte   $97                             ; 8EE7 97                       .
        and     ($23,x)                         ; 8EE8 21 23                    !#
        lda     ($AB),y                         ; 8EEA B1 AB                    ..
        .byte   $B3                             ; 8EEC B3                       .
        .byte   $D3                             ; 8EED D3                       .
        .byte   $87                             ; 8EEE 87                       .
        .byte   $97                             ; 8EEF 97                       .
        lda     $D2AF                           ; 8EF0 AD AF D2                 ...
        .byte   $82                             ; 8EF3 82                       .
        .byte   $83                             ; 8EF4 83                       .
        lda     ($AB),y                         ; 8EF5 B1 AB                    ..
        .byte   $B3                             ; 8EF7 B3                       .
        lda     #$89                            ; 8EF8 A9 89                    ..
        lda     ($C1,x)                         ; 8EFA A1 C1                    ..
        .byte   $A3                             ; 8EFC A3                       .
        .byte   $89                             ; 8EFD 89                       .
        cmp     a:$CF                           ; 8EFE CD CF 00                 ...
        bpl     L8F17                           ; 8F01 10 14                    ..
        asl     $2C,x                           ; 8F03 16 2C                    .,
        rol     $FE2E                           ; 8F05 2E 2E FE                 ...
        asl     $3401                           ; 8F08 0E 01 34                 ..4
        rol     $8F,x                           ; 8F0B 36 8F                    6.
        .byte   $8F                             ; 8F0D 8F                       .
        .byte   $8F                             ; 8F0E 8F                       .
        dec     $5250,x                         ; 8F0F DE 50 52                 .PR
        .byte   $DC                             ; 8F12 DC                       .
        dec     L8C8A,x                         ; 8F13 DE 8A 8C                 ...
        .byte   $DC                             ; 8F16 DC                       .
L8F17:  .byte   $8F                             ; 8F17 8F                       .
        .byte   $54                             ; 8F18 54                       T
        lsr     $FC,x                           ; 8F19 56 FC                    V.
        inc     $7674,x                         ; 8F1B FE 74 76                 .tv
        sec                                     ; 8F1E 38                       8
        .byte   $3A                             ; 8F1F 3A                       :
        brk                                     ; 8F20 00                       .
        eor     $D700,x                         ; 8F21 5D 00 D7                 ]..
        sei                                     ; 8F24 78                       x
        asl     $F5F3                           ; 8F25 0E F3 F5                 ...
        brk                                     ; 8F28 00                       .
        .byte   $5C                             ; 8F29 5C                       \
        brk                                     ; 8F2A 00                       .
        .byte   $F7                             ; 8F2B F7                       .
        ora     (L0000,x)                       ; 8F2C 01 00                    ..
        iny                                     ; 8F2E C8                       .
        dex                                     ; 8F2F CA                       .
        bcc     L8EC4                           ; 8F30 90 92                    ..
        .byte   $7A                             ; 8F32 7A                       z
        .byte   $7C                             ; 8F33 7C                       |
        brk                                     ; 8F34 00                       .
        brk                                     ; 8F35 00                       .
        brk                                     ; 8F36 00                       .
        dec     $3A1C,x                         ; 8F37 DE 1C 3A                 ..:
        .byte   $5E                             ; 8F3A 5E                       ^
        .byte   $7E                             ; 8F3B 7E                       ~
L8F3C:  .byte   $02                             ; 8F3C 02                       .
        ora     ($3E,x)                         ; 8F3D 01 3E                    .>
        .byte   $DF                             ; 8F3F DF                       .
        sbc     a:$FD                           ; 8F40 ED FD 00                 ...
        brk                                     ; 8F43 00                       .
        brk                                     ; 8F44 00                       .
        brk                                     ; 8F45 00                       .
        .byte   $14                             ; 8F46 14                       .
        asl     L0000,x                         ; 8F47 16 00                    ..
        brk                                     ; 8F49 00                       .
        brk                                     ; 8F4A 00                       .
        brk                                     ; 8F4B 00                       .
        brk                                     ; 8F4C 00                       .
        brk                                     ; 8F4D 00                       .
        .byte   $34                             ; 8F4E 34                       4
        rol     $01,x                           ; 8F4F 36 01                    6.
        ora     (L0000,x)                       ; 8F51 01 00                    ..
        brk                                     ; 8F53 00                       .
        brk                                     ; 8F54 00                       .
        brk                                     ; 8F55 00                       .
        brk                                     ; 8F56 00                       .
        brk                                     ; 8F57 00                       .
        txs                                     ; 8F58 9A                       .
        clv                                     ; 8F59 B8                       .
        tsx                                     ; 8F5A BA                       .
        ldy     L9598,x                         ; 8F5B BC 98 95                 ...
        bpl     L8FA9                           ; 8F5E 10 49                    .I
        .byte   $02                             ; 8F60 02                       .
        .byte   $02                             ; 8F61 02                       .
        .byte   $02                             ; 8F62 02                       .
        bpl     L8F75                           ; 8F63 10 10                    ..
        .byte   $82                             ; 8F65 82                       .
        bne     L8F68                           ; 8F66 D0 00                    ..
L8F68:  ora     ($02,x)                         ; 8F68 01 02                    ..
        .byte   $CB                             ; 8F6A CB                       .
        .byte   $02                             ; 8F6B 02                       .
        ldy     #$02                            ; 8F6C A0 02                    ..
        .byte   $C2                             ; 8F6E C2                       .
        .byte   $C2                             ; 8F6F C2                       .
        brk                                     ; 8F70 00                       .
        sta     $9E,y                           ; 8F71 99 9E 00                 ...
        .byte   $C0                             ; 8F74 C0                       .
L8F75:  .byte   $C2                             ; 8F75 C2                       .
        brk                                     ; 8F76 00                       .
        brk                                     ; 8F77 00                       .
        brk                                     ; 8F78 00                       .
        brk                                     ; 8F79 00                       .
        sty     $86                             ; 8F7A 84 86                    ..
        .byte   $A7                             ; 8F7C A7                       .
        .byte   $02                             ; 8F7D 02                       .
        brk                                     ; 8F7E 00                       .
        brk                                     ; 8F7F 00                       .
        sty     $02,x                           ; 8F80 94 02                    ..
        .byte   $02                             ; 8F82 02                       .
        brk                                     ; 8F83 00                       .
        brk                                     ; 8F84 00                       .
        brk                                     ; 8F85 00                       .
        bvs     L8FFA                           ; 8F86 70 72                    pr
        bcs     L8F3C                           ; 8F88 B0 B2                    ..
        sed                                     ; 8F8A F8                       .
        .byte   $FA                             ; 8F8B FA                       .
        .byte   $FB                             ; 8F8C FB                       .
        .byte   $B2                             ; 8F8D B2                       .
        .byte   $74                             ; 8F8E 74                       t
        ror     $D0,x                           ; 8F8F 76 D0                    v.
        .byte   $D2                             ; 8F91 D2                       .
        lsr     L904E                           ; 8F92 4E 4E 90                 NN.
        .byte   $92                             ; 8F95 92                       .
        .byte   $D4                             ; 8F96 D4                       .
        ora     ($F0,x)                         ; 8F97 01 F0                    ..
        .byte   $F2                             ; 8F99 F2                       .
        brk                                     ; 8F9A 00                       .
        brk                                     ; 8F9B 00                       .
        .byte   $D4                             ; 8F9C D4                       .
        .byte   $F4                             ; 8F9D F4                       .
        cpx     $01                             ; 8F9E E4 01                    ..
        lsr     $4E4E                           ; 8FA0 4E 4E 4E                 NNN
        brk                                     ; 8FA3 00                       .
        brk                                     ; 8FA4 00                       .
        brk                                     ; 8FA5 00                       .
        brk                                     ; 8FA6 00                       .
        brk                                     ; 8FA7 00                       .
        .byte   $4E                             ; 8FA8 4E                       N
L8FA9:  brk                                     ; 8FA9 00                       .
        lsr     a:L0000                         ; 8FAA 4E 00 00                 N..
        .byte   $CF                             ; 8FAD CF                       .
L8FAE:  brk                                     ; 8FAE 00                       .
        brk                                     ; 8FAF 00                       .
        brk                                     ; 8FB0 00                       .
L8FB1:  brk                                     ; 8FB1 00                       .
        ldy     $CFBE,x                         ; 8FB2 BC BE CF                 ...
        .byte   $CF                             ; 8FB5 CF                       .
L8FB6:  bvc     L900A                           ; 8FB6 50 52                    PR
        tsx                                     ; 8FB8 BA                       .
        .byte   $DC                             ; 8FB9 DC                       .
        brk                                     ; 8FBA 00                       .
        brk                                     ; 8FBB 00                       .
        .byte   $CF                             ; 8FBC CF                       .
        .byte   $CF                             ; 8FBD CF                       .
        .byte   $54                             ; 8FBE 54                       T
        lsr     $90,x                           ; 8FBF 56 90                    V.
        .byte   $92                             ; 8FC1 92                       .
        lsr     a:$4F                           ; 8FC2 4E 4F 00                 NO.
        brk                                     ; 8FC5 00                       .
        tya                                     ; 8FC6 98                       .
        brk                                     ; 8FC7 00                       .
        .byte   $1F                             ; 8FC8 1F                       .
        sty     $96,x                           ; 8FC9 94 96                    ..
        ldy     $A5,x                           ; 8FCB B4 A5                    ..
        ror     $D494,x                         ; 8FCD 7E 94 D4                 ~..
        cli                                     ; 8FD0 58                       X
        ldy     $A6,x                           ; 8FD1 B4 A6                    ..
        .byte   $D4                             ; 8FD3 D4                       .
        bpl     L8FAE                           ; 8FD4 10 D8                    ..
        .byte   $D3                             ; 8FD6 D3                       .
L8FD7:  cmp     $94,x                           ; 8FD7 D5 94                    ..
        sty     $97,x                           ; 8FD9 94 97                    ..
        bpl     L8FB6                           ; 8FDB 10 D9                    ..
        ldy     $94,x                           ; 8FDD B4 94                    ..
        .byte   $97                             ; 8FDF 97                       .
        clc                                     ; 8FE0 18                       .
        .byte   $1A                             ; 8FE1 1A                       .
        brk                                     ; 8FE2 00                       .
        beq     L8FD7                           ; 8FE3 F0 F2                    ..
        .byte   $D3                             ; 8FE5 D3                       .
        .byte   $97                             ; 8FE6 97                       .
        .byte   $87                             ; 8FE7 87                       .
        bmi     L901C                           ; 8FE8 30 32                    02
        txs                                     ; 8FEA 9A                       .
        .byte   $9C                             ; 8FEB 9C                       .
        .byte   $9B                             ; 8FEC 9B                       .
        ldx     $F2,y                           ; 8FED B6 F2                    ..
        .byte   $97                             ; 8FEF 97                       .
        ldy     L90BE,x                         ; 8FF0 BC BE 90                 ...
        tsx                                     ; 8FF3 BA                       .
        .byte   $92                             ; 8FF4 92                       .
        bcc     L8FB1                           ; 8FF5 90 BA                    ..
        .byte   $92                             ; 8FF7 92                       .
        clv                                     ; 8FF8 B8                       .
        tya                                     ; 8FF9 98                       .
L8FFA:  ldy     #$D0                            ; 8FFA A0 D0                    ..
        .byte   $C3                             ; 8FFC C3                       .
        tya                                     ; 8FFD 98                       .
        .byte   $DC                             ; 8FFE DC                       .
L8FFF:  dec     $1000,x                         ; 8FFF DE 00 10                 ...
        ora     $17,x                           ; 9002 15 17                    ..
        and     $2F2F                           ; 9004 2D 2F 2F                 -//
        inc     $010F,x                         ; 9007 FE 0F 01                 ...
L900A:  and     $37,x                           ; 900A 35 37                    57
        .byte   $8F                             ; 900C 8F                       .
        .byte   $8F                             ; 900D 8F                       .
        .byte   $8F                             ; 900E 8F                       .
        .byte   $DF                             ; 900F DF                       .
        eor     ($53),y                         ; 9010 51 53                    QS
        cmp     L8BDF,x                         ; 9012 DD DF 8B                 ...
        sta     L9FDD                           ; 9015 8D DD 9F                 ...
        eor     $57,x                           ; 9018 55 57                    UW
        .byte   $FD                             ; 901A FD                       .
        .byte   $FF                             ; 901B FF                       .
L901C:  adc     $77,x                           ; 901C 75 77                    uw
        and     $5A3B,y                         ; 901E 39 3B 5A                 9;Z
        brk                                     ; 9021 00                       .
        dec     L0000,x                         ; 9022 D6 00                    ..
        adc     $F40F,y                         ; 9024 79 0F F4                 y..
        inc     $5B,x                           ; 9027 F6 5B                    .[
        brk                                     ; 9029 00                       .
        inc     L0000,x                         ; 902A F6 00                    ..
        ora     (L0000,x)                       ; 902C 01 00                    ..
        cmp     #$CB                            ; 902E C9 CB                    ..
        sta     ($93),y                         ; 9030 91 93                    ..
        .byte   $7B                             ; 9032 7B                       {
        adc     a:L0000,x                       ; 9033 7D 00 00                 }..
        brk                                     ; 9036 00                       .
        dec     $1D39,x                         ; 9037 DE 39 1D                 .9.
        .byte   $5F                             ; 903A 5F                       _
        .byte   $7F                             ; 903B 7F                       .
        .byte   $02                             ; 903C 02                       .
        ora     ($3F,x)                         ; 903D 01 3F                    .?
        .byte   $DF                             ; 903F DF                       .
        inc     a:$FE                           ; 9040 EE FE 00                 ...
        brk                                     ; 9043 00                       .
        brk                                     ; 9044 00                       .
        brk                                     ; 9045 00                       .
        ora     $17,x                           ; 9046 15 17                    ..
        brk                                     ; 9048 00                       .
        brk                                     ; 9049 00                       .
        brk                                     ; 904A 00                       .
        brk                                     ; 904B 00                       .
        brk                                     ; 904C 00                       .
        brk                                     ; 904D 00                       .
L904E:  and     $37,x                           ; 904E 35 37                    57
        ora     ($01,x)                         ; 9050 01 01                    ..
        brk                                     ; 9052 00                       .
        brk                                     ; 9053 00                       .
        brk                                     ; 9054 00                       .
        brk                                     ; 9055 00                       .
        brk                                     ; 9056 00                       .
        brk                                     ; 9057 00                       .
        .byte   $9B                             ; 9058 9B                       .
        lda     $BDBB,y                         ; 9059 B9 BB BD                 ...
        .byte   $02                             ; 905C 02                       .
        .byte   $97                             ; 905D 97                       .
        .byte   $BF                             ; 905E BF                       .
        eor     $0202,y                         ; 905F 59 02 02                 Y..
        sta     $1095                           ; 9062 8D 95 10                 ...
        .byte   $83                             ; 9065 83                       .
        cmp     (L0000),y                       ; 9066 D1 00                    ..
        ora     ($02,x)                         ; 9068 01 02                    ..
        ldx     $A18D,y                         ; 906A BE 8D A1                 ...
        .byte   $A3                             ; 906D A3                       .
        .byte   $C2                             ; 906E C2                       .
        .byte   $F3                             ; 906F F3                       .
        brk                                     ; 9070 00                       .
        sta     $10,y                           ; 9071 99 10 00                 ...
        cmp     ($C3,x)                         ; 9074 C1 C3                    ..
        brk                                     ; 9076 00                       .
        brk                                     ; 9077 00                       .
        brk                                     ; 9078 00                       .
        brk                                     ; 9079 00                       .
        sta     $87                             ; 907A 85 87                    ..
        .byte   $02                             ; 907C 02                       .
        .byte   $B7                             ; 907D B7                       .
        brk                                     ; 907E 00                       .
        brk                                     ; 907F 00                       .
        .byte   $02                             ; 9080 02                       .
        .byte   $02                             ; 9081 02                       .
        .byte   $02                             ; 9082 02                       .
        brk                                     ; 9083 00                       .
        brk                                     ; 9084 00                       .
        brk                                     ; 9085 00                       .
        adc     ($73),y                         ; 9086 71 73                    qs
        lda     ($B3),y                         ; 9088 B1 B3                    ..
        sbc     $FCFA,y                         ; 908A F9 FA FC                 ...
        .byte   $FF                             ; 908D FF                       .
        .byte   $75                             ; 908E 75                       u
L908F:  .byte   $77                             ; 908F 77                       w
        cmp     ($D3),y                         ; 9090 D1 D3                    ..
        lsr     L914E                           ; 9092 4E 4E 91                 NN.
        .byte   $93                             ; 9095 93                       .
        ora     ($D5,x)                         ; 9096 01 D5                    ..
        sbc     ($F3),y                         ; 9098 F1 F3                    ..
        brk                                     ; 909A 00                       .
        brk                                     ; 909B 00                       .
        cmp     $F5,x                           ; 909C D5 F5                    ..
        ora     ($E5,x)                         ; 909E 01 E5                    ..
        lsr     $4E4E                           ; 90A0 4E 4E 4E                 NNN
        brk                                     ; 90A3 00                       .
        brk                                     ; 90A4 00                       .
        brk                                     ; 90A5 00                       .
        brk                                     ; 90A6 00                       .
        brk                                     ; 90A7 00                       .
        lsr     $4E00                           ; 90A8 4E 00 4E                 N.N
        brk                                     ; 90AB 00                       .
        brk                                     ; 90AC 00                       .
        .byte   $CF                             ; 90AD CF                       .
        ldx     a:L0000,y                       ; 90AE BE 00 00                 ...
        brk                                     ; 90B1 00                       .
        brk                                     ; 90B2 00                       .
        .byte   $BF                             ; 90B3 BF                       .
        .byte   $CF                             ; 90B4 CF                       .
        .byte   $CF                             ; 90B5 CF                       .
        eor     ($53),y                         ; 90B6 51 53                    QS
        .byte   $BB                             ; 90B8 BB                       .
        cmp     a:L0000,x                       ; 90B9 DD 00 00                 ...
        .byte   $CF                             ; 90BC CF                       .
        .byte   $CF                             ; 90BD CF                       .
L90BE:  eor     $57,x                           ; 90BE 55 57                    UW
        sta     ($93),y                         ; 90C0 91 93                    ..
        lsr     a:$4F                           ; 90C2 4E 4F 00                 NO.
        brk                                     ; 90C5 00                       .
        sta     L0000,y                         ; 90C6 99 00 00                 ...
        sta     $94,x                           ; 90C9 95 94                    ..
        ldy     $94,x                           ; 90CB B4 94                    ..
        .byte   $7F                             ; 90CD 7F                       .
        sta     $D9,x                           ; 90CE 95 D9                    ..
        brk                                     ; 90D0 00                       .
        lda     $B4,x                           ; 90D1 B5 B4                    ..
        cmp     $10,x                           ; 90D3 D5 10                    ..
        cmp     $10D4,y                         ; 90D5 D9 D4 10                 ...
        lda     $A5                             ; 90D8 A5 A5                    ..
        ldy     $D8,x                           ; 90DA B4 D8                    ..
        .byte   $D3                             ; 90DC D3                       .
        .byte   $A7                             ; 90DD A7                       .
        stx     $97,y                           ; 90DE 96 97                    ..
        ora     $1B,y                           ; 90E0 19 1B 00                 ...
        sbc     ($F3),y                         ; 90E3 F1 F3                    ..
        .byte   $D3                             ; 90E5 D3                       .
        .byte   $F2                             ; 90E6 F2                       .
        .byte   $87                             ; 90E7 87                       .
        and     ($33),y                         ; 90E8 31 33                    13
        .byte   $9B                             ; 90EA 9B                       .
        sta     $F59E,x                         ; 90EB 9D 9E F5                 ...
        .byte   $97                             ; 90EE 97                       .
        .byte   $97                             ; 90EF 97                       .
        lda     L91BF,x                         ; 90F0 BD BF 91                 ...
        .byte   $BB                             ; 90F3 BB                       .
        .byte   $93                             ; 90F4 93                       .
        sta     ($BB),y                         ; 90F5 91 BB                    ..
        .byte   $93                             ; 90F7 93                       .
        lda     $C299,y                         ; 90F8 B9 99 C2                 ...
        cmp     ($A3),y                         ; 90FB D1 A3                    ..
        sta     $DFDD,y                         ; 90FD 99 DD DF                 ...
        brk                                     ; 9100 00                       .
        .byte   $03                             ; 9101 03                       .
        bpl     L9114                           ; 9102 10 10                    ..
        .byte   $02                             ; 9104 02                       .
        .byte   $02                             ; 9105 02                       .
        .byte   $02                             ; 9106 02                       .
        ora     ($23),y                         ; 9107 11 23                    .#
        .byte   $03                             ; 9109 03                       .
        bpl     L911C                           ; 910A 10 10                    ..
        .byte   $13                             ; 910C 13                       .
        .byte   $13                             ; 910D 13                       .
        .byte   $13                             ; 910E 13                       .
        .byte   $F2                             ; 910F F2                       .
        .byte   $02                             ; 9110 02                       .
        .byte   $02                             ; 9111 02                       .
        .byte   $02                             ; 9112 02                       .
        .byte   $02                             ; 9113 02                       .
L9114:  .byte   $02                             ; 9114 02                       .
        .byte   $02                             ; 9115 02                       .
        .byte   $02                             ; 9116 02                       .
        .byte   $03                             ; 9117 03                       .
        .byte   $02                             ; 9118 02                       .
        .byte   $02                             ; 9119 02                       .
        .byte   $02                             ; 911A 02                       .
        .byte   $02                             ; 911B 02                       .
L911C:  .byte   $02                             ; 911C 02                       .
        .byte   $02                             ; 911D 02                       .
        bpl     L9130                           ; 911E 10 10                    ..
        .byte   $03                             ; 9120 03                       .
        .byte   $03                             ; 9121 03                       .
        .byte   $03                             ; 9122 03                       .
        .byte   $03                             ; 9123 03                       .
        bmi     L9169                           ; 9124 30 43                    0C
        ora     ($01,x)                         ; 9126 01 01                    ..
        .byte   $03                             ; 9128 03                       .
        .byte   $03                             ; 9129 03                       .
        .byte   $03                             ; 912A 03                       .
        .byte   $03                             ; 912B 03                       .
        ora     (L0000,x)                       ; 912C 01 00                    ..
        ora     ($01,x)                         ; 912E 01 01                    ..
L9130:  .byte   $12                             ; 9130 12                       .
        .byte   $12                             ; 9131 12                       .
        ora     ($01,x)                         ; 9132 01 01                    ..
        brk                                     ; 9134 00                       .
        brk                                     ; 9135 00                       .
        brk                                     ; 9136 00                       .
        .byte   $F2                             ; 9137 F2                       .
        bpl     L914A                           ; 9138 10 10                    ..
        ora     ($01,x)                         ; 913A 01 01                    ..
        brk                                     ; 913C 00                       .
        brk                                     ; 913D 00                       .
        .byte   $02                             ; 913E 02                       .
        .byte   $F2                             ; 913F F2                       .
        .byte   $02                             ; 9140 02                       .
        .byte   $02                             ; 9141 02                       .
        brk                                     ; 9142 00                       .
        brk                                     ; 9143 00                       .
        brk                                     ; 9144 00                       .
        brk                                     ; 9145 00                       .
        rts                                     ; 9146 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; 9147 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; 9148 00                       .
        brk                                     ; 9149 00                       .
L914A:  brk                                     ; 914A 00                       .
        brk                                     ; 914B 00                       .
        brk                                     ; 914C 00                       .
        brk                                     ; 914D 00                       .
L914E:  rts                                     ; 914E 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; 914F 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 9150 03                       .
        .byte   $03                             ; 9151 03                       .
        brk                                     ; 9152 00                       .
        .byte   $04                             ; 9153 04                       .
        brk                                     ; 9154 00                       .
        brk                                     ; 9155 00                       .
        brk                                     ; 9156 00                       .
        brk                                     ; 9157 00                       .
        .byte   $03                             ; 9158 03                       .
        .byte   $03                             ; 9159 03                       .
        .byte   $03                             ; 915A 03                       .
        .byte   $03                             ; 915B 03                       .
        .byte   $03                             ; 915C 03                       .
        .byte   $03                             ; 915D 03                       .
        .byte   $03                             ; 915E 03                       .
        ora     ($03,x)                         ; 915F 01 03                    ..
        .byte   $03                             ; 9161 03                       .
        .byte   $03                             ; 9162 03                       .
        .byte   $03                             ; 9163 03                       .
        .byte   $03                             ; 9164 03                       .
        .byte   $03                             ; 9165 03                       .
        .byte   $03                             ; 9166 03                       .
        .byte   $03                             ; 9167 03                       .
        .byte   $03                             ; 9168 03                       .
L9169:  .byte   $03                             ; 9169 03                       .
        .byte   $03                             ; 916A 03                       .
        .byte   $03                             ; 916B 03                       .
        .byte   $03                             ; 916C 03                       .
        .byte   $03                             ; 916D 03                       .
        .byte   $03                             ; 916E 03                       .
        .byte   $03                             ; 916F 03                       .
        brk                                     ; 9170 00                       .
        .byte   $03                             ; 9171 03                       .
        .byte   $03                             ; 9172 03                       .
        .byte   $03                             ; 9173 03                       .
        .byte   $03                             ; 9174 03                       .
        .byte   $03                             ; 9175 03                       .
        .byte   $03                             ; 9176 03                       .
        .byte   $03                             ; 9177 03                       .
        .byte   $03                             ; 9178 03                       .
        .byte   $03                             ; 9179 03                       .
        .byte   $03                             ; 917A 03                       .
        .byte   $03                             ; 917B 03                       .
        .byte   $03                             ; 917C 03                       .
        .byte   $03                             ; 917D 03                       .
        .byte   $03                             ; 917E 03                       .
        .byte   $03                             ; 917F 03                       .
        .byte   $03                             ; 9180 03                       .
        .byte   $03                             ; 9181 03                       .
        .byte   $03                             ; 9182 03                       .
        .byte   $03                             ; 9183 03                       .
        .byte   $03                             ; 9184 03                       .
        .byte   $03                             ; 9185 03                       .
        .byte   $12                             ; 9186 12                       .
        .byte   $12                             ; 9187 12                       .
        .byte   $12                             ; 9188 12                       .
        .byte   $12                             ; 9189 12                       .
        .byte   $13                             ; 918A 13                       .
        .byte   $13                             ; 918B 13                       .
        .byte   $13                             ; 918C 13                       .
        .byte   $12                             ; 918D 12                       .
        .byte   $12                             ; 918E 12                       .
        .byte   $12                             ; 918F 12                       .
        .byte   $12                             ; 9190 12                       .
        .byte   $12                             ; 9191 12                       .
        bpl     L91A4                           ; 9192 10 10                    ..
        .byte   $12                             ; 9194 12                       .
        .byte   $12                             ; 9195 12                       .
        .byte   $12                             ; 9196 12                       .
        .byte   $12                             ; 9197 12                       .
        .byte   $12                             ; 9198 12                       .
        .byte   $12                             ; 9199 12                       .
        brk                                     ; 919A 00                       .
        brk                                     ; 919B 00                       .
        .byte   $12                             ; 919C 12                       .
        .byte   $12                             ; 919D 12                       .
        .byte   $12                             ; 919E 12                       .
        .byte   $12                             ; 919F 12                       .
        brk                                     ; 91A0 00                       .
        brk                                     ; 91A1 00                       .
        brk                                     ; 91A2 00                       .
        brk                                     ; 91A3 00                       .
L91A4:  brk                                     ; 91A4 00                       .
        brk                                     ; 91A5 00                       .
        brk                                     ; 91A6 00                       .
        brk                                     ; 91A7 00                       .
        brk                                     ; 91A8 00                       .
        brk                                     ; 91A9 00                       .
        brk                                     ; 91AA 00                       .
        brk                                     ; 91AB 00                       .
        brk                                     ; 91AC 00                       .
        brk                                     ; 91AD 00                       .
        brk                                     ; 91AE 00                       .
        brk                                     ; 91AF 00                       .
        brk                                     ; 91B0 00                       .
        brk                                     ; 91B1 00                       .
        .byte   $03                             ; 91B2 03                       .
        .byte   $03                             ; 91B3 03                       .
        brk                                     ; 91B4 00                       .
        brk                                     ; 91B5 00                       .
        ora     ($01,x)                         ; 91B6 01 01                    ..
        .byte   $03                             ; 91B8 03                       .
        .byte   $03                             ; 91B9 03                       .
        brk                                     ; 91BA 00                       .
        brk                                     ; 91BB 00                       .
        brk                                     ; 91BC 00                       .
        brk                                     ; 91BD 00                       .
        .byte   $01                             ; 91BE 01                       .
L91BF:  ora     ($02,x)                         ; 91BF 01 02                    ..
        .byte   $02                             ; 91C1 02                       .
        brk                                     ; 91C2 00                       .
        brk                                     ; 91C3 00                       .
        brk                                     ; 91C4 00                       .
        brk                                     ; 91C5 00                       .
        bpl     L91C8                           ; 91C6 10 00                    ..
L91C8:  .byte   $03                             ; 91C8 03                       .
        .byte   $13                             ; 91C9 13                       .
        .byte   $13                             ; 91CA 13                       .
        .byte   $13                             ; 91CB 13                       .
        .byte   $13                             ; 91CC 13                       .
        .byte   $13                             ; 91CD 13                       .
        .byte   $13                             ; 91CE 13                       .
        .byte   $03                             ; 91CF 03                       .
        .byte   $03                             ; 91D0 03                       .
        .byte   $13                             ; 91D1 13                       .
        .byte   $13                             ; 91D2 13                       .
        .byte   $03                             ; 91D3 03                       .
        .byte   $03                             ; 91D4 03                       .
        .byte   $03                             ; 91D5 03                       .
        .byte   $03                             ; 91D6 03                       .
        .byte   $03                             ; 91D7 03                       .
        .byte   $13                             ; 91D8 13                       .
        .byte   $13                             ; 91D9 13                       .
        .byte   $13                             ; 91DA 13                       .
        .byte   $03                             ; 91DB 03                       .
        .byte   $03                             ; 91DC 03                       .
        .byte   $13                             ; 91DD 13                       .
        .byte   $13                             ; 91DE 13                       .
        bpl     L91E2                           ; 91DF 10 01                    ..
        .byte   $01                             ; 91E1 01                       .
L91E2:  brk                                     ; 91E2 00                       .
        .byte   $03                             ; 91E3 03                       .
        .byte   $03                             ; 91E4 03                       .
        .byte   $03                             ; 91E5 03                       .
        bpl     L91F8                           ; 91E6 10 10                    ..
        ora     ($01,x)                         ; 91E8 01 01                    ..
        .byte   $13                             ; 91EA 13                       .
        .byte   $13                             ; 91EB 13                       .
        .byte   $13                             ; 91EC 13                       .
        .byte   $03                             ; 91ED 03                       .
        bpl     L9200                           ; 91EE 10 10                    ..
        .byte   $12                             ; 91F0 12                       .
        .byte   $12                             ; 91F1 12                       .
        .byte   $13                             ; 91F2 13                       .
        .byte   $13                             ; 91F3 13                       .
        .byte   $13                             ; 91F4 13                       .
        .byte   $13                             ; 91F5 13                       .
        .byte   $13                             ; 91F6 13                       .
        .byte   $13                             ; 91F7 13                       .
L91F8:  .byte   $13                             ; 91F8 13                       .
        .byte   $13                             ; 91F9 13                       .
        .byte   $13                             ; 91FA 13                       .
        .byte   $13                             ; 91FB 13                       .
        .byte   $13                             ; 91FC 13                       .
        bpl     L9212                           ; 91FD 10 13                    ..
        .byte   $10                             ; 91FF 10                       .
L9200:  bpl     L9213                           ; 9200 10 11                    ..
        clc                                     ; 9202 18                       .
        ora     $0909,y                         ; 9203 19 09 09                 ...
        ora     #$09                            ; 9206 09 09                    ..
        .byte   $14                             ; 9208 14                       .
        ora     $1A,x                           ; 9209 15 1A                    ..
        .byte   $1B                             ; 920B 1B                       .
        .byte   $CF                             ; 920C CF                       .
        .byte   $D3                             ; 920D D3                       .
        ora     ($01,x)                         ; 920E 01 01                    ..
        .byte   $D4                             ; 9210 D4                       .
        .byte   $D5                             ; 9211 D5                       .
L9212:  .byte   $01                             ; 9212 01                       .
L9213:  ora     ($12,x)                         ; 9213 01 12                    ..
        .byte   $13                             ; 9215 13                       .
        .byte   $1A                             ; 9216 1A                       .
        .byte   $1B                             ; 9217 1B                       .
        ora     ($01,x)                         ; 9218 01 01                    ..
        ora     ($01,x)                         ; 921A 01 01                    ..
        asl     $0A1F,x                         ; 921C 1E 1F 0A                 ...
        .byte   $0B                             ; 921F 0B                       .
        asl     $0A39,x                         ; 9220 1E 39 0A                 .9.
        .byte   $0B                             ; 9223 0B                       .
        .byte   $F2                             ; 9224 F2                       .
        .byte   $F3                             ; 9225 F3                       .
        .byte   $FA                             ; 9226 FA                       .
        .byte   $0B                             ; 9227 0B                       .
        .byte   $F4                             ; 9228 F4                       .
        sbc     $F0FC,y                         ; 9229 F9 FC F0                 ...
        sbc     $F1F2,y                         ; 922C F9 F2 F1                 ...
        .byte   $FA                             ; 922F FA                       .
        .byte   $F3                             ; 9230 F3                       .
        .byte   $F4                             ; 9231 F4                       .
        .byte   $03                             ; 9232 03                       .
        .byte   $FC                             ; 9233 FC                       .
        .byte   $CB                             ; 9234 CB                       .
        .byte   $DA                             ; 9235 DA                       .
L9236:  asl     a                               ; 9236 0A                       .
        .byte   $0B                             ; 9237 0B                       .
        .byte   $02                             ; 9238 02                       .
        .byte   $03                             ; 9239 03                       .
        asl     a                               ; 923A 0A                       .
        .byte   $0B                             ; 923B 0B                       .
        sbc     $F6,x                           ; 923C F5 F6                    ..
        .byte   $FA                             ; 923E FA                       .
L923F:  .byte   $0B                             ; 923F 0B                       .
        .byte   $F7                             ; 9240 F7                       .
        beq     L923F                           ; 9241 F0 FC                    ..
        beq     L9236                           ; 9243 F0 F1                    ..
        sbc     $F1,x                           ; 9245 F5 F1                    ..
        .byte   $FA                             ; 9247 FA                       .
        inc     $F7,x                           ; 9248 F6 F7                    ..
        .byte   $03                             ; 924A 03                       .
        .byte   $FC                             ; 924B FC                       .
        .byte   $D3                             ; 924C D3                       .
        cmp     $01,x                           ; 924D D5 01                    ..
        ora     ($12,x)                         ; 924F 01 12                    ..
        .byte   $13                             ; 9251 13                       .
        .byte   $F2                             ; 9252 F2                       .
        .byte   $F3                             ; 9253 F3                       .
        cmp     #$CB                            ; 9254 C9 CB                    ..
        cld                                     ; 9256 D8                       .
        .byte   $0B                             ; 9257 0B                       .
        .byte   $DA                             ; 9258 DA                       .
        .byte   $CB                             ; 9259 CB                       .
        asl     a                               ; 925A 0A                       .
        .byte   $0B                             ; 925B 0B                       .
        .byte   $FA                             ; 925C FA                       .
        .byte   $02                             ; 925D 02                       .
        sbc     $F6,x                           ; 925E F5 F6                    ..
        cmp     ($03),y                         ; 9260 D1 03                    ..
        asl     a                               ; 9262 0A                       .
        .byte   $0B                             ; 9263 0B                       .
        iny                                     ; 9264 C8                       .
        brk                                     ; 9265 00                       .
        bne     L9268                           ; 9266 D0 00                    ..
L9268:  cpx     #$E1                            ; 9268 E0 E1                    ..
        inx                                     ; 926A E8                       .
        sbc     #$32                            ; 926B E9 32                    .2
        .byte   $33                             ; 926D 33                       3
        .byte   $3A                             ; 926E 3A                       :
        .byte   $3B                             ; 926F 3B                       ;
        brk                                     ; 9270 00                       .
        brk                                     ; 9271 00                       .
        brk                                     ; 9272 00                       .
        brk                                     ; 9273 00                       .
        brk                                     ; 9274 00                       .
        sbc     (L0000,x)                       ; 9275 E1 00                    ..
        brk                                     ; 9277 00                       .
        .byte   $3A                             ; 9278 3A                       :
        .byte   $3B                             ; 9279 3B                       ;
        .byte   $3A                             ; 927A 3A                       :
        .byte   $3B                             ; 927B 3B                       ;
        ora     #$09                            ; 927C 09 09                    ..
        cmp     #$CB                            ; 927E C9 CB                    ..
        iny                                     ; 9280 C8                       .
        brk                                     ; 9281 00                       .
        .byte   $DA                             ; 9282 DA                       .
        .byte   $CB                             ; 9283 CB                       .
        brk                                     ; 9284 00                       .
        brk                                     ; 9285 00                       .
        .byte   $F2                             ; 9286 F2                       .
        .byte   $F3                             ; 9287 F3                       .
        brk                                     ; 9288 00                       .
        brk                                     ; 9289 00                       .
        .byte   $F4                             ; 928A F4                       .
        sbc     L0000,y                         ; 928B F9 00 00                 ...
        sbc     $12F2,y                         ; 928E F9 F2 12                 ...
        .byte   $13                             ; 9291 13                       .
        .byte   $F4                             ; 9292 F4                       .
        sbc     $1312,y                         ; 9293 F9 12 13                 ...
L9296:  sbc     $01F2,y                         ; 9296 F9 F2 01                 ...
        .byte   $01                             ; 9299 01                       .
L929A:  .byte   $F3                             ; 929A F3                       .
        .byte   $F4                             ; 929B F4                       .
        cld                                     ; 929C D8                       .
        .byte   $0B                             ; 929D 0B                       .
        cmp     ($0B),y                         ; 929E D1 0B                    ..
        .byte   $FC                             ; 92A0 FC                       .
        beq     L929A                           ; 92A1 F0 F7                    ..
        beq     L9296                           ; 92A3 F0 F1                    ..
        .byte   $FA                             ; 92A5 FA                       .
        sbc     ($F5),y                         ; 92A6 F1 F5                    ..
        asl     a                               ; 92A8 0A                       .
        .byte   $FC                             ; 92A9 FC                       .
        inc     $F7,x                           ; 92AA F6 F7                    ..
        asl     a                               ; 92AC 0A                       .
        .byte   $0B                             ; 92AD 0B                       .
        brk                                     ; 92AE 00                       .
        brk                                     ; 92AF 00                       .
        php                                     ; 92B0 08                       .
        brk                                     ; 92B1 00                       .
        php                                     ; 92B2 08                       .
        brk                                     ; 92B3 00                       .
        brk                                     ; 92B4 00                       .
        brk                                     ; 92B5 00                       .
        cmp     #$CB                            ; 92B6 C9 CB                    ..
        brk                                     ; 92B8 00                       .
        brk                                     ; 92B9 00                       .
        .byte   $DA                             ; 92BA DA                       .
        .byte   $CB                             ; 92BB CB                       .
        cmp     #$CB                            ; 92BC C9 CB                    ..
        cmp     ($02),y                         ; 92BE D1 02                    ..
        brk                                     ; 92C0 00                       .
        brk                                     ; 92C1 00                       .
        .byte   $F3                             ; 92C2 F3                       .
L92C3:  .byte   $F4                             ; 92C3 F4                       .
        cmp     #$CB                            ; 92C4 C9 CB                    ..
        cmp     ($0B),y                         ; 92C6 D1 0B                    ..
        .byte   $02                             ; 92C8 02                       .
        .byte   $03                             ; 92C9 03                       .
        asl     a                               ; 92CA 0A                       .
        cmp     #$02                            ; 92CB C9 02                    ..
        .byte   $03                             ; 92CD 03                       .
        .byte   $CB                             ; 92CE CB                       .
        .byte   $CB                             ; 92CF CB                       .
        .byte   $FA                             ; 92D0 FA                       .
        .byte   $02                             ; 92D1 02                       .
        nop                                     ; 92D2 EA                       .
        .byte   $EB                             ; 92D3 EB                       .
        .byte   $FC                             ; 92D4 FC                       .
        beq     L92C3                           ; 92D5 F0 EC                    ..
        sed                                     ; 92D7 F8                       .
        sbc     ($FA),y                         ; 92D8 F1 FA                    ..
        sed                                     ; 92DA F8                       .
        nop                                     ; 92DB EA                       .
        .byte   $02                             ; 92DC 02                       .
        .byte   $DA                             ; 92DD DA                       .
        asl     a                               ; 92DE 0A                       .
        brk                                     ; 92DF 00                       .
        .byte   $DA                             ; 92E0 DA                       .
        .byte   $CB                             ; 92E1 CB                       .
        brk                                     ; 92E2 00                       .
        brk                                     ; 92E3 00                       .
        .byte   $CB                             ; 92E4 CB                       .
        cmp     (L0000),y                       ; 92E5 D1 00                    ..
        brk                                     ; 92E7 00                       .
        .byte   $02                             ; 92E8 02                       .
        .byte   $3B                             ; 92E9 3B                       ;
        asl     a                               ; 92EA 0A                       .
        .byte   $3B                             ; 92EB 3B                       ;
        .byte   $02                             ; 92EC 02                       .
        .byte   $DA                             ; 92ED DA                       .
        asl     a                               ; 92EE 0A                       .
        .byte   $0B                             ; 92EF 0B                       .
        and     $CB                             ; 92F0 25 CB                    %.
        php                                     ; 92F2 08                       .
        brk                                     ; 92F3 00                       .
        cmp     ($0B),y                         ; 92F4 D1 0B                    ..
        brk                                     ; 92F6 00                       .
        brk                                     ; 92F7 00                       .
        .byte   $CB                             ; 92F8 CB                       .
        dex                                     ; 92F9 CA                       .
        asl     a                               ; 92FA 0A                       .
        .byte   $D2                             ; 92FB D2                       .
        brk                                     ; 92FC 00                       .
        brk                                     ; 92FD 00                       .
        and     $DD                             ; 92FE 25 DD                    %.
        php                                     ; 9300 08                       .
        .byte   $03                             ; 9301 03                       .
        asl     a                               ; 9302 0A                       .
        .byte   $0B                             ; 9303 0B                       .
        asl     a                               ; 9304 0A                       .
        .byte   $FC                             ; 9305 FC                       .
        .byte   $EB                             ; 9306 EB                       .
        cpx     $0302                           ; 9307 EC 02 03                 ...
        dex                                     ; 930A CA                       .
        .byte   $0B                             ; 930B 0B                       .
        .byte   $02                             ; 930C 02                       .
        php                                     ; 930D 08                       .
        asl     a                               ; 930E 0A                       .
        php                                     ; 930F 08                       .
        cpy     $D203                           ; 9310 CC 03 D2                 ...
        dex                                     ; 9313 CA                       .
        asl     a                               ; 9314 0A                       .
        .byte   $0B                             ; 9315 0B                       .
        .byte   $3A                             ; 9316 3A                       :
        .byte   $3B                             ; 9317 3B                       ;
        brk                                     ; 9318 00                       .
        php                                     ; 9319 08                       .
        brk                                     ; 931A 00                       .
        php                                     ; 931B 08                       .
L931C:  .byte   $3B                             ; 931C 3B                       ;
        cpy     $CC3B                           ; 931D CC 3B CC                 .;.
        brk                                     ; 9320 00                       .
        brk                                     ; 9321 00                       .
        .byte   $CB                             ; 9322 CB                       .
        dex                                     ; 9323 CA                       .
        brk                                     ; 9324 00                       .
        .byte   $D2                             ; 9325 D2                       .
        brk                                     ; 9326 00                       .
        brk                                     ; 9327 00                       .
        .byte   $CB                             ; 9328 CB                       .
        dex                                     ; 9329 CA                       .
        brk                                     ; 932A 00                       .
        .byte   $D2                             ; 932B D2                       .
        .byte   $CB                             ; 932C CB                       .
        dec     $D1CB,x                         ; 932D DE CB D1                 ...
        .byte   $02                             ; 9330 02                       .
        cpy     $D20A                           ; 9331 CC 0A D2                 ...
        brk                                     ; 9334 00                       .
        brk                                     ; 9335 00                       .
        dex                                     ; 9336 CA                       .
        brk                                     ; 9337 00                       .
        and     $DA                             ; 9338 25 DA                    %.
        php                                     ; 933A 08                       .
        .byte   $0B                             ; 933B 0B                       .
        cpy     $CC00                           ; 933C CC 00 CC                 ...
        brk                                     ; 933F 00                       .
        php                                     ; 9340 08                       .
        .byte   $03                             ; 9341 03                       .
        brk                                     ; 9342 00                       .
        brk                                     ; 9343 00                       .
        .byte   $D2                             ; 9344 D2                       .
        .byte   $CB                             ; 9345 CB                       .
        asl     a                               ; 9346 0A                       .
        .byte   $0B                             ; 9347 0B                       .
        bit     $24                             ; 9348 24 24                    $$
        .byte   $CB                             ; 934A CB                       .
        .byte   $CB                             ; 934B CB                       .
        brk                                     ; 934C 00                       .
        brk                                     ; 934D 00                       .
        .byte   $CB                             ; 934E CB                       .
        .byte   $CB                             ; 934F CB                       .
        nop                                     ; 9350 EA                       .
        .byte   $EB                             ; 9351 EB                       .
        brk                                     ; 9352 00                       .
        brk                                     ; 9353 00                       .
        cpx     a:$F8                           ; 9354 EC F8 00                 ...
        brk                                     ; 9357 00                       .
        sed                                     ; 9358 F8                       .
        nop                                     ; 9359 EA                       .
        brk                                     ; 935A 00                       .
        brk                                     ; 935B 00                       .
        .byte   $DA                             ; 935C DA                       .
        cmp     a:L0000,x                       ; 935D DD 00 00                 ...
        brk                                     ; 9360 00                       .
        brk                                     ; 9361 00                       .
        brk                                     ; 9362 00                       .
        .byte   $DA                             ; 9363 DA                       .
        .byte   $02                             ; 9364 02                       .
        cpy     $CC0A                           ; 9365 CC 0A CC                 ...
        brk                                     ; 9368 00                       .
        .byte   $3B                             ; 9369 3B                       ;
        dex                                     ; 936A CA                       .
        brk                                     ; 936B 00                       .
        brk                                     ; 936C 00                       .
        .byte   $03                             ; 936D 03                       .
        brk                                     ; 936E 00                       .
        sbc     #$02                            ; 936F E9 02                    ..
        .byte   $D2                             ; 9371 D2                       .
        asl     a                               ; 9372 0A                       .
        .byte   $0B                             ; 9373 0B                       .
        dex                                     ; 9374 CA                       .
        brk                                     ; 9375 00                       .
        .byte   $D2                             ; 9376 D2                       .
        .byte   $CB                             ; 9377 CB                       .
        brk                                     ; 9378 00                       .
        brk                                     ; 9379 00                       .
        .byte   $DD                             ; 937A DD                       .
L937B:  and     $F0                             ; 937B 25 F0                    %.
        sbc     ($F0),y                         ; 937D F1 F0                    ..
        sbc     ($EB),y                         ; 937F F1 EB                    ..
        cpx     a:L0000                         ; 9381 EC 00 00                 ...
        dex                                     ; 9384 CA                       .
        .byte   $03                             ; 9385 03                       .
        .byte   $D2                             ; 9386 D2                       .
        .byte   $CB                             ; 9387 CB                       .
        beq     L937B                           ; 9388 F0 F1                    ..
        sed                                     ; 938A F8                       .
        sed                                     ; 938B F8                       .
        .byte   $CB                             ; 938C CB                       .
        .byte   $CB                             ; 938D CB                       .
        .byte   $3A                             ; 938E 3A                       :
        .byte   $3B                             ; 938F 3B                       ;
        .byte   $F9                             ; 9390 F9                       .
L9391:  sbc     $F1F0,y                         ; 9391 F9 F0 F1                 ...
        cld                                     ; 9394 D8                       .
        php                                     ; 9395 08                       .
        cld                                     ; 9396 D8                       .
        php                                     ; 9397 08                       .
        cpy     $CC03                           ; 9398 CC 03 CC                 ...
        .byte   $0B                             ; 939B 0B                       .
        cpy     $D203                           ; 939C CC 03 D2                 ...
        .byte   $CB                             ; 939F CB                       .
        .byte   $02                             ; 93A0 02                       .
        dec     $D1CB                           ; 93A1 CE CB D1                 ...
        cmp     ($08),y                         ; 93A4 D1 08                    ..
        brk                                     ; 93A6 00                       .
        php                                     ; 93A7 08                       .
        brk                                     ; 93A8 00                       .
        php                                     ; 93A9 08                       .
        .byte   $CB                             ; 93AA CB                       .
        .byte   $CB                             ; 93AB CB                       .
        cpx     a:$F8                           ; 93AC EC F8 00                 ...
        sbc     ($3B,x)                         ; 93AF E1 3B                    .;
        .byte   $3B                             ; 93B1 3B                       ;
        .byte   $3A                             ; 93B2 3A                       :
        .byte   $3B                             ; 93B3 3B                       ;
        brk                                     ; 93B4 00                       .
        brk                                     ; 93B5 00                       .
        brk                                     ; 93B6 00                       .
        sec                                     ; 93B7 38                       8
        brk                                     ; 93B8 00                       .
        brk                                     ; 93B9 00                       .
        .byte   $1F                             ; 93BA 1F                       .
        asl     $1F38,x                         ; 93BB 1E 38 1F                 .8.
        asl     a                               ; 93BE 0A                       .
        .byte   $0B                             ; 93BF 0B                       .
        brk                                     ; 93C0 00                       .
        brk                                     ; 93C1 00                       .
        sec                                     ; 93C2 38                       8
        and     $3B00,y                         ; 93C3 39 00 3B                 9.;
        and     $0200,y                         ; 93C6 39 00 02                 9..
        sec                                     ; 93C9 38                       8
        asl     a                               ; 93CA 0A                       .
        .byte   $0B                             ; 93CB 0B                       .
        .byte   $1F                             ; 93CC 1F                       .
        asl     $0B0A,x                         ; 93CD 1E 0A 0B                 ...
        .byte   $1F                             ; 93D0 1F                       .
        and     $0B0A,y                         ; 93D1 39 0A 0B                 9..
        brk                                     ; 93D4 00                       .
        brk                                     ; 93D5 00                       .
        cmp     $D825,y                         ; 93D6 D9 25 D8                 .%.
        php                                     ; 93D9 08                       .
        cld                                     ; 93DA D8                       .
        .byte   $0B                             ; 93DB 0B                       .
        asl     a                               ; 93DC 0A                       .
        .byte   $0B                             ; 93DD 0B                       .
        .byte   $3B                             ; 93DE 3B                       ;
        .byte   $3B                             ; 93DF 3B                       ;
        brk                                     ; 93E0 00                       .
        brk                                     ; 93E1 00                       .
        sec                                     ; 93E2 38                       8
        .byte   $1F                             ; 93E3 1F                       .
        brk                                     ; 93E4 00                       .
        brk                                     ; 93E5 00                       .
        asl     a:$1F,x                         ; 93E6 1E 1F 00                 ...
        brk                                     ; 93E9 00                       .
        asl     $3839,x                         ; 93EA 1E 39 38                 .98
        and     $0B0A,y                         ; 93ED 39 0A 0B                 9..
        php                                     ; 93F0 08                       .
        sec                                     ; 93F1 38                       8
        php                                     ; 93F2 08                       .
        .byte   $0B                             ; 93F3 0B                       .
        php                                     ; 93F4 08                       .
        .byte   $03                             ; 93F5 03                       .
        php                                     ; 93F6 08                       .
        .byte   $0B                             ; 93F7 0B                       .
        and     $0A03,y                         ; 93F8 39 03 0A                 9..
        .byte   $0B                             ; 93FB 0B                       .
        brk                                     ; 93FC 00                       .
        .byte   $02                             ; 93FD 02                       .
        brk                                     ; 93FE 00                       .
        asl     a                               ; 93FF 0A                       .
        .byte   $02                             ; 9400 02                       .
        brk                                     ; 9401 00                       .
        asl     a                               ; 9402 0A                       .
        brk                                     ; 9403 00                       .
        brk                                     ; 9404 00                       .
        bit     $38                             ; 9405 24 38                    $8
        .byte   $1F                             ; 9407 1F                       .
        brk                                     ; 9408 00                       .
        sec                                     ; 9409 38                       8
        asl     $020B,x                         ; 940A 1E 0B 02                 ...
        brk                                     ; 940D 00                       .
        asl     a                               ; 940E 0A                       .
        and     $25,y                           ; 940F 39 25 00                 9%.
        php                                     ; 9412 08                       .
        brk                                     ; 9413 00                       .
        bcc     L9416                           ; 9414 90 00                    ..
L9416:  tya                                     ; 9416 98                       .
        brk                                     ; 9417 00                       .
        brk                                     ; 9418 00                       .
        bcc     L941B                           ; 9419 90 00                    ..
L941B:  tya                                     ; 941B 98                       .
        tya                                     ; 941C 98                       .
        brk                                     ; 941D 00                       .
        tya                                     ; 941E 98                       .
        brk                                     ; 941F 00                       .
        brk                                     ; 9420 00                       .
        tya                                     ; 9421 98                       .
        brk                                     ; 9422 00                       .
        tya                                     ; 9423 98                       .
        brk                                     ; 9424 00                       .
        plp                                     ; 9425 28                       (
        brk                                     ; 9426 00                       .
        jsr     L5150                           ; 9427 20 50 51                  PQ
        ora     #$09                            ; 942A 09 09                    ..
        ora     #$58                            ; 942C 09 58                    .X
        eor     $095A,y                         ; 942E 59 5A 09                 YZ.
        ora     #$5B                            ; 9431 09 5B                    .[
        eor     $0958,y                         ; 9433 59 58 09                 YX.
        .byte   $5A                             ; 9436 5A                       Z
        .byte   $5B                             ; 9437 5B                       [
        ora     #$59                            ; 9438 09 59                    .Y
        eor     $6161,y                         ; 943A 59 61 61                 Yaa
        .byte   $62                             ; 943D 62                       b
        adc     #$6A                            ; 943E 69 6A                    ij
        .byte   $63                             ; 9440 63                       c
        lsr     $6401,x                         ; 9441 5E 01 64                 ^.d
        .byte   $72                             ; 9444 72                       r
        .byte   $63                             ; 9445 63                       c
        sec                                     ; 9446 38                       8
        .byte   $1F                             ; 9447 1F                       .
        .byte   $5B                             ; 9448 5B                       [
        ora     #$1E                            ; 9449 09 1E                    ..
        .byte   $1F                             ; 944B 1F                       .
        brk                                     ; 944C 00                       .
        rol     a                               ; 944D 2A                       *
        and     $38                             ; 944E 25 38                    %8
        adc     ($69,x)                         ; 9450 61 69                    ai
        asl     $0939,x                         ; 9452 1E 39 09                 .9.
        ora     #$09                            ; 9455 09 09                    ..
        cli                                     ; 9457 58                       X
        ora     #$09                            ; 9458 09 09                    ..
        ora     #$59                            ; 945A 09 59                    .Y
        eor     $615A,y                         ; 945C 59 5A 61                 YZa
        .byte   $62                             ; 945F 62                       b
        .byte   $5B                             ; 9460 5B                       [
        ora     #$63                            ; 9461 09 63                    .c
        .byte   $5B                             ; 9463 5B                       [
        ora     #$09                            ; 9464 09 09                    ..
        asl     $591F,x                         ; 9466 1E 1F 59                 ..Y
        adc     ($1E,x)                         ; 9469 61 1E                    a.
        and     L8D88,y                         ; 946B 39 88 8D                 9..
        stx     $87                             ; 946E 86 87                    ..
        sta     L8689                           ; 9470 8D 89 86                 ...
        .byte   $87                             ; 9473 87                       .
        .byte   $5B                             ; 9474 5B                       [
        eor     $615C,y                         ; 9475 59 5C 61                 Y\a
        .byte   $72                             ; 9478 72                       r
        .byte   $63                             ; 9479 63                       c
        eor     L8601,x                         ; 947A 5D 01 86                 ]..
        .byte   $87                             ; 947D 87                       .
        stx     $87                             ; 947E 86 87                    ..
        adc     #$69                            ; 9480 69 69                    ii
        adc     #$69                            ; 9482 69 69                    ii
        adc     #$62                            ; 9484 69 62                    ib
        adc     #$6A                            ; 9486 69 6A                    ij
        dey                                     ; 9488 88                       .
        .byte   $89                             ; 9489 89                       .
        stx     $87                             ; 948A 86 87                    ..
        adc     #$6A                            ; 948C 69 6A                    ij
        adc     #$62                            ; 948E 69 62                    ib
        ora     ($64,x)                         ; 9490 01 64                    .d
        ora     ($01,x)                         ; 9492 01 01                    ..
        adc     #$62                            ; 9494 69 62                    ib
        dey                                     ; 9496 88                       .
        sta     $0101                           ; 9497 8D 01 01                 ...
        sta     $0989                           ; 949A 8D 89 09                 ...
        ora     #$58                            ; 949D 09 58                    .X
        ora     #$5B                            ; 949F 09 5B                    .[
        eor     $5E63,y                         ; 94A1 59 63 5E                 Yc^
        .byte   $5A                             ; 94A4 5A                       Z
        .byte   $5B                             ; 94A5 5B                       [
        .byte   $72                             ; 94A6 72                       r
        .byte   $63                             ; 94A7 63                       c
        ora     #$09                            ; 94A8 09 09                    ..
        .byte   $5B                             ; 94AA 5B                       [
        ora     #$59                            ; 94AB 09 59                    .Y
        adc     ($61,x)                         ; 94AD 61 61                    aa
        adc     #$69                            ; 94AF 69 69                    ii
        ror     a                               ; 94B1 6A                       j
        dey                                     ; 94B2 88                       .
        sta     $6401                           ; 94B3 8D 01 64                 ..d
        sta     $5D89                           ; 94B6 8D 89 5D                 ..]
        ora     ($63,x)                         ; 94B9 01 63                    .c
        eor     L8D8D,x                         ; 94BB 5D 8D 8D                 ]..
        stx     $87                             ; 94BE 86 87                    ..
        ora     ($64,x)                         ; 94C0 01 64                    .d
        dey                                     ; 94C2 88                       .
        .byte   $89                             ; 94C3 89                       .
        brk                                     ; 94C4 00                       .
        php                                     ; 94C5 08                       .
        asl     $4639,x                         ; 94C6 1E 39 46                 .9F
        .byte   $47                             ; 94C9 47                       G
        lsr     $464F                           ; 94CA 4E 4F 46                 NOF
        brk                                     ; 94CD 00                       .
        lsr     $0900                           ; 94CE 4E 00 09                 N..
        ora     #$E3                            ; 94D1 09 E3                    ..
        cpx     $39                             ; 94D3 E4 39                    .9
        brk                                     ; 94D5 00                       .
        asl     a                               ; 94D6 0A                       .
        brk                                     ; 94D7 00                       .
        brk                                     ; 94D8 00                       .
        plp                                     ; 94D9 28                       (
        brk                                     ; 94DA 00                       .
        rol     a                               ; 94DB 2A                       *
        and     $0B22,y                         ; 94DC 39 22 0B                 9".
        rol     a                               ; 94DF 2A                       *
        .byte   $02                             ; 94E0 02                       .
        dey                                     ; 94E1 88                       .
        asl     a                               ; 94E2 0A                       .
        .byte   $0B                             ; 94E3 0B                       .
        .byte   $89                             ; 94E4 89                       .
        and     $0A                             ; 94E5 25 0A                    %.
        php                                     ; 94E7 08                       .
        dey                                     ; 94E8 88                       .
        sta     $0B0A                           ; 94E9 8D 0A 0B                 ...
        sbc     $63E4                           ; 94EC ED E4 63                 ..c
        .byte   $5B                             ; 94EF 5B                       [
        .byte   $72                             ; 94F0 72                       r
        .byte   $5C                             ; 94F1 5C                       \
        .byte   $5C                             ; 94F2 5C                       \
        adc     #$61                            ; 94F3 69 61                    ia
        adc     #$69                            ; 94F5 69 69                    ii
        adc     #$01                            ; 94F7 69 01                    i.
        .byte   $5C                             ; 94F9 5C                       \
        .byte   $5C                             ; 94FA 5C                       \
        adc     #$69                            ; 94FB 69 69                    ii
        rts                                     ; 94FD 60                       `

; ----------------------------------------------------------------------------
        adc     #$69                            ; 94FE 69 69                    ii
        iny                                     ; 9500 C8                       .
        brk                                     ; 9501 00                       .
        and     #$00                            ; 9502 29 00                    ).
        and     (L0000,x)                       ; 9504 21 00                    !.
        and     #$00                            ; 9506 29 00                    ).
        .byte   $02                             ; 9508 02                       .
        .byte   $03                             ; 9509 03                       .
        brk                                     ; 950A 00                       .
        brk                                     ; 950B 00                       .
        .byte   $02                             ; 950C 02                       .
        .byte   $03                             ; 950D 03                       .
        brk                                     ; 950E 00                       .
        asl     a                               ; 950F 0A                       .
        sec                                     ; 9510 38                       8
        asl     $0B0A,x                         ; 9511 1E 0A 0B                 ...
        .byte   $03                             ; 9514 03                       .
        brk                                     ; 9515 00                       .
        .byte   $0B                             ; 9516 0B                       .
        brk                                     ; 9517 00                       .
        php                                     ; 9518 08                       .
        .byte   $02                             ; 9519 02                       .
        php                                     ; 951A 08                       .
        asl     a                               ; 951B 0A                       .
        .byte   $02                             ; 951C 02                       .
        and     $0B0A,y                         ; 951D 39 0A 0B                 9..
        sec                                     ; 9520 38                       8
        .byte   $02                             ; 9521 02                       .
        brk                                     ; 9522 00                       .
        asl     a                               ; 9523 0A                       .
        .byte   $02                             ; 9524 02                       .
        brk                                     ; 9525 00                       .
        .byte   $0B                             ; 9526 0B                       .
        brk                                     ; 9527 00                       .
        .byte   $5F                             ; 9528 5F                       _
        .byte   $03                             ; 9529 03                       .
        .byte   $5F                             ; 952A 5F                       _
        asl     a                               ; 952B 0A                       .
        .byte   $5F                             ; 952C 5F                       _
        brk                                     ; 952D 00                       .
        .byte   $5F                             ; 952E 5F                       _
        .byte   $5F                             ; 952F 5F                       _
        brk                                     ; 9530 00                       .
        brk                                     ; 9531 00                       .
        .byte   $5F                             ; 9532 5F                       _
        .byte   $5F                             ; 9533 5F                       _
        brk                                     ; 9534 00                       .
        .byte   $03                             ; 9535 03                       .
        .byte   $5F                             ; 9536 5F                       _
        asl     a                               ; 9537 0A                       .
        brk                                     ; 9538 00                       .
        php                                     ; 9539 08                       .
        .byte   $5F                             ; 953A 5F                       _
        php                                     ; 953B 08                       .
        .byte   $5F                             ; 953C 5F                       _
        .byte   $5F                             ; 953D 5F                       _
        .byte   $5F                             ; 953E 5F                       _
        .byte   $5F                             ; 953F 5F                       _
        .byte   $5F                             ; 9540 5F                       _
        php                                     ; 9541 08                       .
        and     $5F08,y                         ; 9542 39 08 5F                 9._
        .byte   $5F                             ; 9545 5F                       _
        .byte   $5F                             ; 9546 5F                       _
        sec                                     ; 9547 38                       8
        bit     $24                             ; 9548 24 24                    $$
        asl     $5F1F,x                         ; 954A 1E 1F 5F                 .._
        .byte   $5F                             ; 954D 5F                       _
        sec                                     ; 954E 38                       8
        .byte   $1F                             ; 954F 1F                       .
        .byte   $5F                             ; 9550 5F                       _
        .byte   $5F                             ; 9551 5F                       _
        asl     $5F1F,x                         ; 9552 1E 1F 5F                 .._
        .byte   $5F                             ; 9555 5F                       _
        asl     $5F39,x                         ; 9556 1E 39 5F                 .9_
        .byte   $03                             ; 9559 03                       .
        and     $0B                             ; 955A 25 0B                    %.
        .byte   $5F                             ; 955C 5F                       _
        .byte   $5F                             ; 955D 5F                       _
        sec                                     ; 955E 38                       8
        and     $0909,y                         ; 955F 39 09 09                 9..
        .byte   $80                             ; 9562 80                       .
        sta     ($80,x)                         ; 9563 81 80                    ..
        sta     ($69,x)                         ; 9565 81 69                    .i
        adc     #$7C                            ; 9567 69 7C                    i|
        adc     $6969,x                         ; 9569 7D 69 69                 }ii
        brk                                     ; 956C 00                       .
        rol     a                               ; 956D 2A                       *
        brk                                     ; 956E 00                       .
        .byte   $22                             ; 956F 22                       "
        adc     #$69                            ; 9570 69 69                    ii
        dey                                     ; 9572 88                       .
        .byte   $89                             ; 9573 89                       .
        brk                                     ; 9574 00                       .
        rol     a                               ; 9575 2A                       *
        dey                                     ; 9576 88                       .
        sta     $6969                           ; 9577 8D 69 69                 .ii
        sta     L8889                           ; 957A 8D 89 88                 ...
        .byte   $89                             ; 957D 89                       .
        asl     a                               ; 957E 0A                       .
        .byte   $0B                             ; 957F 0B                       .
        .byte   $02                             ; 9580 02                       .
        brk                                     ; 9581 00                       .
        asl     a                               ; 9582 0A                       .
        and     L0000                           ; 9583 25 00                    %.
        sec                                     ; 9585 38                       8
        sec                                     ; 9586 38                       8
        .byte   $0B                             ; 9587 0B                       .
        brk                                     ; 9588 00                       .
        .byte   $03                             ; 9589 03                       .
        brk                                     ; 958A 00                       .
        .byte   $0B                             ; 958B 0B                       .
        .byte   $7A                             ; 958C 7A                       z
        .byte   $7B                             ; 958D 7B                       {
        .byte   $82                             ; 958E 82                       .
        adc     #$7A                            ; 958F 69 7A                    iz
        .byte   $7B                             ; 9591 7B                       {
        adc     #$69                            ; 9592 69 69                    ii
        adc     #$69                            ; 9594 69 69                    ii
        dey                                     ; 9596 88                       .
        .byte   $8D                             ; 9597 8D                       .
L9598:  txa                                     ; 9598 8A                       .
        .byte   $8B                             ; 9599 8B                       .
        adc     #$69                            ; 959A 69 69                    ii
        .byte   $8B                             ; 959C 8B                       .
        .byte   $8B                             ; 959D 8B                       .
        adc     #$69                            ; 959E 69 69                    ii
        .byte   $8B                             ; 95A0 8B                       .
        sty     $6969                           ; 95A1 8C 69 69                 .ii
        adc     #$69                            ; 95A4 69 69                    ii
        .byte   $37                             ; 95A6 37                       7
        .byte   $37                             ; 95A7 37                       7
        adc     #$88                            ; 95A8 69 88                    i.
        .byte   $37                             ; 95AA 37                       7
        stx     $3F                             ; 95AB 86 3F                    .?
        .byte   $3F                             ; 95AD 3F                       ?
        dey                                     ; 95AE 88                       .
        .byte   $89                             ; 95AF 89                       .
        .byte   $3F                             ; 95B0 3F                       ?
        stx     $89                             ; 95B1 86 89                    ..
        stx     $69                             ; 95B3 86 69                    .i
        adc     #$8A                            ; 95B5 69 8A                    i.
        .byte   $8B                             ; 95B7 8B                       .
        adc     #$69                            ; 95B8 69 69                    ii
        .byte   $8B                             ; 95BA 8B                       .
        sty     $6969                           ; 95BB 8C 69 69                 .ii
        .byte   $8B                             ; 95BE 8B                       .
        .byte   $8B                             ; 95BF 8B                       .
        bne     L95C2                           ; 95C0 D0 00                    ..
L95C2:  iny                                     ; 95C2 C8                       .
        brk                                     ; 95C3 00                       .
        .byte   $2B                             ; 95C4 2B                       +
        brk                                     ; 95C5 00                       .
        .byte   $23                             ; 95C6 23                       #
        brk                                     ; 95C7 00                       .
        asl     a                               ; 95C8 0A                       .
        .byte   $0B                             ; 95C9 0B                       .
        brk                                     ; 95CA 00                       .
        .byte   $17                             ; 95CB 17                       .
        and     $0A5F,y                         ; 95CC 39 5F 0A                 9_.
        and     $175F,y                         ; 95CF 39 5F 17                 9_.
        .byte   $5F                             ; 95D2 5F                       _
        .byte   $17                             ; 95D3 17                       .
        stx     a:$8F                           ; 95D4 8E 8F 00                 ...
        brk                                     ; 95D7 00                       .
        stx     $87                             ; 95D8 86 87                    ..
        stx     $028F                           ; 95DA 8E 8F 02                 ...
        .byte   $03                             ; 95DD 03                       .
        stx     $038F                           ; 95DE 8E 8F 03                 ...
        brk                                     ; 95E1 00                       .
        .byte   $0B                             ; 95E2 0B                       .
        .byte   $5F                             ; 95E3 5F                       _
        brk                                     ; 95E4 00                       .
        brk                                     ; 95E5 00                       .
        .byte   $3A                             ; 95E6 3A                       :
        .byte   $3B                             ; 95E7 3B                       ;
        brk                                     ; 95E8 00                       .
        .byte   $02                             ; 95E9 02                       .
        .byte   $5F                             ; 95EA 5F                       _
        asl     a                               ; 95EB 0A                       .
        .byte   $03                             ; 95EC 03                       .
        .byte   $5F                             ; 95ED 5F                       _
        .byte   $0B                             ; 95EE 0B                       .
        .byte   $5F                             ; 95EF 5F                       _
        .byte   $5F                             ; 95F0 5F                       _
        .byte   $02                             ; 95F1 02                       .
        .byte   $5F                             ; 95F2 5F                       _
        asl     a                               ; 95F3 0A                       .
        .byte   $0B                             ; 95F4 0B                       .
        .byte   $5F                             ; 95F5 5F                       _
        brk                                     ; 95F6 00                       .
        .byte   $5F                             ; 95F7 5F                       _
        brk                                     ; 95F8 00                       .
        brk                                     ; 95F9 00                       .
        brk                                     ; 95FA 00                       .
        brk                                     ; 95FB 00                       .
        brk                                     ; 95FC 00                       .
        brk                                     ; 95FD 00                       .
        brk                                     ; 95FE 00                       .
        brk                                     ; 95FF 00                       .
        brk                                     ; 9600 00                       .
        brk                                     ; 9601 00                       .
        brk                                     ; 9602 00                       .
        ora     ($01,x)                         ; 9603 01 01                    ..
        brk                                     ; 9605 00                       .
        brk                                     ; 9606 00                       .
        brk                                     ; 9607 00                       .
        brk                                     ; 9608 00                       .
        brk                                     ; 9609 00                       .
        brk                                     ; 960A 00                       .
        ora     ($01,x)                         ; 960B 01 01                    ..
        brk                                     ; 960D 00                       .
        brk                                     ; 960E 00                       .
        brk                                     ; 960F 00                       .
        brk                                     ; 9610 00                       .
        brk                                     ; 9611 00                       .
        brk                                     ; 9612 00                       .
        ora     ($01,x)                         ; 9613 01 01                    ..
        brk                                     ; 9615 00                       .
        brk                                     ; 9616 00                       .
        brk                                     ; 9617 00                       .
        .byte   $02                             ; 9618 02                       .
        .byte   $02                             ; 9619 02                       .
        .byte   $02                             ; 961A 02                       .
        .byte   $03                             ; 961B 03                       .
        .byte   $04                             ; 961C 04                       .
        .byte   $02                             ; 961D 02                       .
        .byte   $02                             ; 961E 02                       .
        .byte   $02                             ; 961F 02                       .
        ora     $05                             ; 9620 05 05                    ..
        ora     $06                             ; 9622 05 06                    ..
        asl     $05                             ; 9624 06 05                    ..
        ora     $05                             ; 9626 05 05                    ..
        ora     $05                             ; 9628 05 05                    ..
        ora     $06                             ; 962A 05 06                    ..
        asl     $05                             ; 962C 06 05                    ..
        ora     $05                             ; 962E 05 05                    ..
        .byte   $07                             ; 9630 07                       .
        php                                     ; 9631 08                       .
        ora     #$0A                            ; 9632 09 0A                    ..
        .byte   $0B                             ; 9634 0B                       .
        .byte   $0C                             ; 9635 0C                       .
        ora     $0E09                           ; 9636 0D 09 0E                 ...
        asl     $100F                           ; 9639 0E 0F 10                 ...
        ora     ($12),y                         ; 963C 11 12                    ..
        asl     a:$0F                           ; 963E 0E 0F 00                 ...
        brk                                     ; 9641 00                       .
        ora     ($01,x)                         ; 9642 01 01                    ..
        ora     ($01,x)                         ; 9644 01 01                    ..
        brk                                     ; 9646 00                       .
        brk                                     ; 9647 00                       .
        brk                                     ; 9648 00                       .
        brk                                     ; 9649 00                       .
        ora     ($01,x)                         ; 964A 01 01                    ..
        ora     ($01,x)                         ; 964C 01 01                    ..
        brk                                     ; 964E 00                       .
        brk                                     ; 964F 00                       .
        brk                                     ; 9650 00                       .
        brk                                     ; 9651 00                       .
        ora     ($01,x)                         ; 9652 01 01                    ..
        ora     ($01,x)                         ; 9654 01 01                    ..
        brk                                     ; 9656 00                       .
        brk                                     ; 9657 00                       .
        .byte   $02                             ; 9658 02                       .
        .byte   $02                             ; 9659 02                       .
        .byte   $13                             ; 965A 13                       .
        .byte   $03                             ; 965B 03                       .
        .byte   $04                             ; 965C 04                       .
        .byte   $13                             ; 965D 13                       .
        .byte   $02                             ; 965E 02                       .
        .byte   $02                             ; 965F 02                       .
        ora     $05                             ; 9660 05 05                    ..
        asl     $06                             ; 9662 06 06                    ..
        asl     $06                             ; 9664 06 06                    ..
        ora     $14                             ; 9666 05 14                    ..
        ora     $05                             ; 9668 05 05                    ..
        asl     $15                             ; 966A 06 15                    ..
        asl     $16,x                           ; 966C 16 16                    ..
        asl     $17,x                           ; 966E 16 17                    ..
        asl     a                               ; 9670 0A                       .
        .byte   $0B                             ; 9671 0B                       .
        .byte   $0C                             ; 9672 0C                       .
        clc                                     ; 9673 18                       .
        asl     $0E0E                           ; 9674 0E 0E 0E                 ...
        .byte   $17                             ; 9677 17                       .
        bpl     L968B                           ; 9678 10 11                    ..
        .byte   $12                             ; 967A 12                       .
        asl     $0E0E                           ; 967B 0E 0E 0E                 ...
        asl     a:$17                           ; 967E 0E 17 00                 ...
        brk                                     ; 9681 00                       .
        ora     ($01,x)                         ; 9682 01 01                    ..
        ora     $1B1A,y                         ; 9684 19 1A 1B                 ...
        .byte   $1C                             ; 9687 1C                       .
        brk                                     ; 9688 00                       .
        brk                                     ; 9689 00                       .
        .byte   $01                             ; 968A 01                       .
L968B:  ora     ($19,x)                         ; 968B 01 19                    ..
        ora     $1E1B,x                         ; 968D 1D 1B 1E                 ...
        brk                                     ; 9690 00                       .
        brk                                     ; 9691 00                       .
        ora     ($01,x)                         ; 9692 01 01                    ..
        ora     $1B1A,y                         ; 9694 19 1A 1B                 ...
        ora     $0202,x                         ; 9697 1D 02 02                 ...
        .byte   $13                             ; 969A 13                       .
        .byte   $1F                             ; 969B 1F                       .
        jsr     L2221                           ; 969C 20 21 22                  !"
        .byte   $23                             ; 969F 23                       #
        bit     $25                             ; 96A0 24 25                    $%
        rol     $27                             ; 96A2 26 27                    &'
        asl     $2817                           ; 96A4 0E 17 28                 ..(
        and     #$28                            ; 96A7 29 28                    )(
        and     #$2A                            ; 96A9 29 2A                    )*
        asl     $170E                           ; 96AB 0E 0E 17                 ...
        plp                                     ; 96AE 28                       (
        and     #$28                            ; 96AF 29 28                    )(
        and     #$2A                            ; 96B1 29 2A                    )*
        asl     $170E                           ; 96B3 0E 0E 17                 ...
        plp                                     ; 96B6 28                       (
        and     #$28                            ; 96B7 29 28                    )(
        and     #$2A                            ; 96B9 29 2A                    )*
        asl     $170E                           ; 96BB 0E 0E 17                 ...
        plp                                     ; 96BE 28                       (
        and     #$2B                            ; 96BF 29 2B                    )+
        .byte   $2B                             ; 96C1 2B                       +
        .byte   $2B                             ; 96C2 2B                       +
        .byte   $2B                             ; 96C3 2B                       +
        .byte   $1A                             ; 96C4 1A                       .
        ora     $1A2C,x                         ; 96C5 1D 2C 1A                 .,.
        asl     $1E1E,x                         ; 96C8 1E 1E 1E                 ...
        .byte   $1B                             ; 96CB 1B                       .
        asl     $2C1E,x                         ; 96CC 1E 1E 2C                 ..,
        .byte   $1B                             ; 96CF 1B                       .
        ora     $1A1A,x                         ; 96D0 1D 1A 1A                 ...
        and     $2F2E                           ; 96D3 2D 2E 2F                 -./
        ora     $301A                           ; 96D6 0D 1A 30                 ..0
        and     ($0D),y                         ; 96D9 31 0D                    1.
        clc                                     ; 96DB 18                       .
        asl     $0E0E                           ; 96DC 0E 0E 0E                 ...
        .byte   $1C                             ; 96DF 1C                       .
        rol     a                               ; 96E0 2A                       *
        asl     $0E0E                           ; 96E1 0E 0E 0E                 ...
        asl     $0E0E                           ; 96E4 0E 0E 0E                 ...
        .byte   $1C                             ; 96E7 1C                       .
        rol     a                               ; 96E8 2A                       *
        asl     $0E0E                           ; 96E9 0E 0E 0E                 ...
        asl     $0E0E                           ; 96EC 0E 0E 0E                 ...
        .byte   $1C                             ; 96EF 1C                       .
        rol     a                               ; 96F0 2A                       *
        asl     $0E0E                           ; 96F1 0E 0E 0E                 ...
        asl     $0E0E                           ; 96F4 0E 0E 0E                 ...
        .byte   $1C                             ; 96F7 1C                       .
        rol     a                               ; 96F8 2A                       *
        asl     $0E0E                           ; 96F9 0E 0E 0E                 ...
        asl     $0E0E                           ; 96FC 0E 0E 0E                 ...
        .byte   $1C                             ; 96FF 1C                       .
        asl     $0E0E                           ; 9700 0E 0E 0E                 ...
        .byte   $32                             ; 9703 32                       2
        .byte   $33                             ; 9704 33                       3
        .byte   $34                             ; 9705 34                       4
        and     $36,x                           ; 9706 35 36                    56
        .byte   $37                             ; 9708 37                       7
        sec                                     ; 9709 38                       8
        sec                                     ; 970A 38                       8
        and     $1D1A,y                         ; 970B 39 1A 1D                 9..
        .byte   $1A                             ; 970E 1A                       .
        .byte   $1B                             ; 970F 1B                       .
        .byte   $3A                             ; 9710 3A                       :
        asl     $1E1B,x                         ; 9711 1E 1B 1E                 ...
        asl     $1E1E,x                         ; 9714 1E 1E 1E                 ...
        .byte   $1B                             ; 9717 1B                       .
        .byte   $3A                             ; 9718 3A                       :
        .byte   $1B                             ; 9719 1B                       .
        .byte   $1A                             ; 971A 1A                       .
        and     $2E2E                           ; 971B 2D 2E 2E                 -..
        rol     $3B2E                           ; 971E 2E 2E 3B                 ..;
        .byte   $3C                             ; 9721 3C                       <
        sec                                     ; 9722 38                       8
        and     $2B2B,x                         ; 9723 3D 2B 2B                 =++
        asl     $0E0E                           ; 9726 0E 0E 0E                 ...
        bit     $1D1A                           ; 9729 2C 1A 1D                 ,..
        .byte   $1A                             ; 972C 1A                       .
        ora     $0E2B,x                         ; 972D 1D 2B 0E                 .+.
        asl     $0D0D                           ; 9730 0E 0D 0D                 ...
        rol     $2E2E,x                         ; 9733 3E 2E 2E                 >..
        .byte   $3F                             ; 9736 3F                       ?
        asl     $0E0E                           ; 9737 0E 0E 0E                 ...
        asl     $0E0E                           ; 973A 0E 0E 0E                 ...
        asl     $0E40                           ; 973D 0E 40 0E                 .@.
        eor     ($33,x)                         ; 9740 41 33                    A3
        .byte   $42                             ; 9742 42                       B
        asl     $430E                           ; 9743 0E 0E 43                 ..C
        asl     $1D0E                           ; 9746 0E 0E 1D                 ...
        .byte   $1C                             ; 9749 1C                       .
        .byte   $44                             ; 974A 44                       D
        asl     $4645                           ; 974B 0E 45 46                 .EF
        asl     $1E0E,x                         ; 974E 1E 0E 1E                 ...
        .byte   $1B                             ; 9751 1B                       .
        .byte   $47                             ; 9752 47                       G
        asl     $461B                           ; 9753 0E 1B 46                 ..F
        .byte   $1B                             ; 9756 1B                       .
        asl     $1A48                           ; 9757 0E 48 1A                 .H.
        eor     #$4A                            ; 975A 49 4A                    IJ
        .byte   $4B                             ; 975C 4B                       K
        .byte   $1C                             ; 975D 1C                       .
        asl     $4C0E,x                         ; 975E 1E 0E 4C                 ..L
        eor     $1D1A                           ; 9761 4D 1A 1D                 M..
        asl     $4E1D,x                         ; 9764 1E 1D 4E                 ..N
        asl     $4F0E                           ; 9767 0E 0E 4F                 ..O
        .byte   $1A                             ; 976A 1A                       .
        .byte   $1A                             ; 976B 1A                       .
        .byte   $1B                             ; 976C 1B                       .
        .byte   $1A                             ; 976D 1A                       .
        bvc     L977E                           ; 976E 50 0E                    P.
        asl     $0D51                           ; 9770 0E 51 0D                 .Q.
        ora     $2E3E                           ; 9773 0D 3E 2E                 .>.
        rol     $0E52                           ; 9776 2E 52 0E                 .R.
        asl     $0E0E                           ; 9779 0E 0E 0E                 ...
        .byte   $0E                             ; 977C 0E                       .
        .byte   $0E                             ; 977D 0E                       .
L977E:  asl     $0E0E                           ; 977E 0E 0E 0E                 ...
        asl     $2817                           ; 9781 0E 17 28                 ..(
        and     #$2A                            ; 9784 29 2A                    )*
        .byte   $17                             ; 9786 17                       .
        plp                                     ; 9787 28                       (
        asl     $170E                           ; 9788 0E 0E 17                 ...
        plp                                     ; 978B 28                       (
        and     #$2A                            ; 978C 29 2A                    )*
        .byte   $17                             ; 978E 17                       .
        plp                                     ; 978F 28                       (
        asl     $340E                           ; 9790 0E 0E 34                 ..4
        and     $36,x                           ; 9793 35 36                    56
        eor     ($17,x)                         ; 9795 41 17                    A.
        plp                                     ; 9797 28                       (
        asl     $1D0E                           ; 9798 0E 0E 1D                 ...
        .byte   $1A                             ; 979B 1A                       .
        ora     $171B,x                         ; 979C 1D 1B 17                 ...
        plp                                     ; 979F 28                       (
        asl     $1A0E                           ; 97A0 0E 0E 1A                 ...
        .byte   $1C                             ; 97A3 1C                       .
        .byte   $1A                             ; 97A4 1A                       .
        .byte   $1B                             ; 97A5 1B                       .
        .byte   $17                             ; 97A6 17                       .
        plp                                     ; 97A7 28                       (
        asl     $1D1A                           ; 97A8 0E 1A 1D                 ...
        .byte   $1A                             ; 97AB 1A                       .
        .byte   $1A                             ; 97AC 1A                       .
        .byte   $1B                             ; 97AD 1B                       .
        .byte   $17                             ; 97AE 17                       .
        plp                                     ; 97AF 28                       (
        .byte   $53                             ; 97B0 53                       S
        and     ($22,x)                         ; 97B1 21 22                    !"
        .byte   $23                             ; 97B3 23                       #
        bmi     L97E4                           ; 97B4 30 2E                    0.
        .byte   $17                             ; 97B6 17                       .
        plp                                     ; 97B7 28                       (
        asl     $2817                           ; 97B8 0E 17 28                 ..(
        and     #$2A                            ; 97BB 29 2A                    )*
        asl     $2817                           ; 97BD 0E 17 28                 ..(
        .byte   $12                             ; 97C0 12                       .
        asl     $3332                           ; 97C1 0E 32 33                 .23
        .byte   $33                             ; 97C4 33                       3
        .byte   $0F                             ; 97C5 0F                       .
        bpl     L97D9                           ; 97C6 10 11                    ..
        .byte   $12                             ; 97C8 12                       .
        sec                                     ; 97C9 38                       8
        and     $1A1E,y                         ; 97CA 39 1E 1A                 9..
        .byte   $54                             ; 97CD 54                       T
        eor     $56,x                           ; 97CE 55 56                    UV
        .byte   $12                             ; 97D0 12                       .
        asl     $1B1E,x                         ; 97D1 1E 1E 1B                 ...
        asl     $1E1E,x                         ; 97D4 1E 1E 1E                 ...
        .byte   $1E                             ; 97D7 1E                       .
        .byte   $12                             ; 97D8 12                       .
L97D9:  .byte   $1B                             ; 97D9 1B                       .
        .byte   $57                             ; 97DA 57                       W
        .byte   $1B                             ; 97DB 1B                       .
        .byte   $1A                             ; 97DC 1A                       .
        and     $1A48                           ; 97DD 2D 48 1A                 -H.
        .byte   $12                             ; 97E0 12                       .
        asl     $2E58,x                         ; 97E1 1E 58 2E                 .X.
L97E4:  and     ($18),y                         ; 97E4 31 18                    1.
        eor     $121B,y                         ; 97E6 59 1B 12                 Y..
        .byte   $5A                             ; 97E9 5A                       Z
        ora     $1A1B,x                         ; 97EA 1D 1B 1A                 ...
        .byte   $5B                             ; 97ED 5B                       [
        .byte   $5C                             ; 97EE 5C                       \
        ora     $5112                           ; 97EF 0D 12 51                 ..Q
        ora     $5D0D                           ; 97F2 0D 0D 5D                 ..]
        lsr     $0E0E,x                         ; 97F5 5E 0E 0E                 ^..
        .byte   $12                             ; 97F8 12                       .
        asl     $0E0E                           ; 97F9 0E 0E 0E                 ...
        asl     $0E43                           ; 97FC 0E 43 0E                 .C.
        asl     $0E12                           ; 97FF 0E 12 0E                 ...
        asl     $0E5F                           ; 9802 0E 5F 0E                 ._.
        .byte   $5F                             ; 9805 5F                       _
        asl     $600E                           ; 9806 0E 0E 60                 ..`
        sec                                     ; 9809 38                       8
        adc     ($5F,x)                         ; 980A 61 5F                    a_
        asl     $335F                           ; 980C 0E 5F 33                 ._3
        .byte   $33                             ; 980F 33                       3
        asl     $1E1E,x                         ; 9810 1E 1E 1E                 ...
        .byte   $62                             ; 9813 62                       b
        .byte   $63                             ; 9814 63                       c
        .byte   $62                             ; 9815 62                       b
        ora     $1D1C,x                         ; 9816 1D 1C 1D                 ...
        .byte   $1A                             ; 9819 1A                       .
        .byte   $1A                             ; 981A 1A                       .
        .byte   $1C                             ; 981B 1C                       .
        .byte   $1B                             ; 981C 1B                       .
        .byte   $1C                             ; 981D 1C                       .
        .byte   $1A                             ; 981E 1A                       .
        .byte   $1A                             ; 981F 1A                       .
        asl     $1E1E,x                         ; 9820 1E 1E 1E                 ...
        asl     $1E1B,x                         ; 9823 1E 1B 1E                 ...
        .byte   $1B                             ; 9826 1B                       .
        asl     $3E0D,x                         ; 9827 1E 0D 3E                 ..>
        pha                                     ; 982A 48                       H
        .byte   $1C                             ; 982B 1C                       .
        asl     $1A1D,x                         ; 982C 1E 1D 1A                 ...
        ora     $0E0E,x                         ; 982F 1D 0E 0E                 ...
        .byte   $5C                             ; 9832 5C                       \
        rol     $2E2E,x                         ; 9833 3E 2E 2E                 >..
        and     ($0D),y                         ; 9836 31 0D                    1.
        asl     $0E0E                           ; 9838 0E 0E 0E                 ...
        asl     $0E0E                           ; 983B 0E 0E 0E                 ...
        asl     $5F0E                           ; 983E 0E 0E 5F                 .._
        asl     $335F                           ; 9841 0E 5F 33                 ._3
        .byte   $33                             ; 9844 33                       3
        .byte   $34                             ; 9845 34                       4
        and     $36,x                           ; 9846 35 36                    56
        .byte   $62                             ; 9848 62                       b
        sec                                     ; 9849 38                       8
        .byte   $62                             ; 984A 62                       b
        asl     $1E1B,x                         ; 984B 1E 1B 1E                 ...
        .byte   $1B                             ; 984E 1B                       .
        asl     $1E1A,x                         ; 984F 1E 1A 1E                 ...
        ora     $1A1A,x                         ; 9852 1D 1A 1A                 ...
        ora     $1A1A,x                         ; 9855 1D 1A 1A                 ...
        .byte   $1A                             ; 9858 1A                       .
        asl     $1A1A,x                         ; 9859 1E 1A 1A                 ...
        ora     $1D64,x                         ; 985C 1D 64 1D                 .d.
        .byte   $1A                             ; 985F 1A                       .
        asl     $1E1B,x                         ; 9860 1E 1B 1E                 ...
        ora     $0D,x                           ; 9863 15 0D                    ..
        .byte   $5F                             ; 9865 5F                       _
        rol     $1A2E,x                         ; 9866 3E 2E 1A                 >..
        and     $1831                           ; 9869 2D 31 18                 -1.
        asl     $0E5F                           ; 986C 0E 5F 0E                 ._.
        asl     $180D                           ; 986F 0E 0D 18                 ...
        asl     $0E0E                           ; 9872 0E 0E 0E                 ...
        .byte   $5F                             ; 9875 5F                       _
        asl     $0E0E                           ; 9876 0E 0E 0E                 ...
        asl     $0E0E                           ; 9879 0E 0E 0E                 ...
        asl     $0E5F                           ; 987C 0E 5F 0E                 ._.
        asl     $3341                           ; 987F 0E 41 33                 .A3
        .byte   $42                             ; 9882 42                       B
        asl     $650E                           ; 9883 0E 0E 65                 ..e
        .byte   $17                             ; 9886 17                       .
        plp                                     ; 9887 28                       (
        .byte   $1B                             ; 9888 1B                       .
        asl     $0E66,x                         ; 9889 1E 66 0E                 .f.
        .byte   $0E                             ; 988C 0E                       .
L988D:  adc     $17                             ; 988D 65 17                    e.
        plp                                     ; 988F 28                       (
        .byte   $1A                             ; 9890 1A                       .
        ora     $6867,x                         ; 9891 1D 67 68                 .gh
        sec                                     ; 9894 38                       8
        adc     #$17                            ; 9895 69 17                    i.
        plp                                     ; 9897 28                       (
        .byte   $1A                             ; 9898 1A                       .
        .byte   $1A                             ; 9899 1A                       .
        asl     $1A1E,x                         ; 989A 1E 1E 1A                 ...
        lsr     $17                             ; 989D 46 17                    F.
        plp                                     ; 989F 28                       (
        pha                                     ; 98A0 48                       H
        .byte   $1A                             ; 98A1 1A                       .
        asl     $1D1B,x                         ; 98A2 1E 1B 1D                 ...
        lsr     $17                             ; 98A5 46 17                    F.
        plp                                     ; 98A7 28                       (
        eor     $1B1E,y                         ; 98A8 59 1E 1B                 Y..
        .byte   $1B                             ; 98AB 1B                       .
        asl     $1746,x                         ; 98AC 1E 46 17                 .F.
        plp                                     ; 98AF 28                       (
        .byte   $5C                             ; 98B0 5C                       \
        .byte   $64                             ; 98B1 64                       d
        asl     $2E2E,x                         ; 98B2 1E 2E 2E                 ...
        ror     a                               ; 98B5 6A                       j
        .byte   $17                             ; 98B6 17                       .
        plp                                     ; 98B7 28                       (
        asl     $1C5F                           ; 98B8 0E 5F 1C                 ._.
        asl     $0E0E                           ; 98BB 0E 0E 0E                 ...
        .byte   $17                             ; 98BE 17                       .
        plp                                     ; 98BF 28                       (
        .byte   $12                             ; 98C0 12                       .
        asl     $0E0E                           ; 98C1 0E 0E 0E                 ...
        asl     $100F                           ; 98C4 0E 0F 10                 ...
        ora     ($12),y                         ; 98C7 11 12                    ..
        .byte   $2B                             ; 98C9 2B                       +
        .byte   $2B                             ; 98CA 2B                       +
        asl     $540E                           ; 98CB 0E 0E 54                 ..T
        .byte   $6B                             ; 98CE 6B                       k
        lsr     $12,x                           ; 98CF 56 12                    V.
        .byte   $1B                             ; 98D1 1B                       .
        .byte   $1A                             ; 98D2 1A                       .
        ora     $1A1D,x                         ; 98D3 1D 1D 1A                 ...
        ora     $121A,x                         ; 98D6 1D 1A 12                 ...
        jmp     (L6C57)                         ; 98D9 6C 57 6C                 lWl

; ----------------------------------------------------------------------------
        jmp     (L6C6C)                         ; 98DC 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        jmp     (L1B12)                         ; 98DF 6C 12 1B                 l..

; ----------------------------------------------------------------------------
        adc     $6F6E                           ; 98E2 6D 6E 6F                 mno
        php                                     ; 98E5 08                       .
        bvs     L9905                           ; 98E6 70 1D                    p.
        .byte   $12                             ; 98E8 12                       .
        adc     ($1D),y                         ; 98E9 71 1D                    q.
        .byte   $1A                             ; 98EB 1A                       .
        .byte   $1A                             ; 98EC 1A                       .
        ora     $0A09,x                         ; 98ED 1D 09 0A                 ...
        .byte   $12                             ; 98F0 12                       .
        .byte   $72                             ; 98F1 72                       r
        .byte   $73                             ; 98F2 73                       s
        .byte   $74                             ; 98F3 74                       t
        rol     $0F75                           ; 98F4 2E 75 0F                 .u.
        bpl     L990B                           ; 98F7 10 12                    ..
        asl     $0E0E                           ; 98F9 0E 0E 0E                 ...
        asl     $0F76                           ; 98FC 0E 76 0F                 .v.
        bpl     L9913                           ; 98FF 10 12                    ..
        asl     $0E0E                           ; 9901 0E 0E 0E                 ...
        .byte   $0E                             ; 9904 0E                       .
L9905:  asl     $0E0E                           ; 9905 0E 0E 0E                 ...
        rts                                     ; 9908 60                       `

; ----------------------------------------------------------------------------
        .byte   $0E                             ; 9909 0E                       .
        .byte   $0E                             ; 990A 0E                       .
L990B:  asl     $0E0E                           ; 990B 0E 0E 0E                 ...
        asl     $1D0E                           ; 990E 0E 0E 1D                 ...
        .byte   $0E                             ; 9911 0E                       .
        .byte   $0E                             ; 9912 0E                       .
L9913:  .byte   $77                             ; 9913 77                       w
        .byte   $77                             ; 9914 77                       w
        asl     $1C0E                           ; 9915 0E 0E 1C                 ...
        jmp     (L6C6C)                         ; 9918 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        .byte   $1B                             ; 991B 1B                       .
        .byte   $1B                             ; 991C 1B                       .
        jmp     (L6C6C)                         ; 991D 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        .byte   $1A                             ; 9920 1A                       .
        .byte   $1A                             ; 9921 1A                       .
        .byte   $1A                             ; 9922 1A                       .
        .byte   $1B                             ; 9923 1B                       .
        .byte   $1B                             ; 9924 1B                       .
        .byte   $1A                             ; 9925 1A                       .
        ora     $0B1A,x                         ; 9926 1D 1A 0B                 ...
        .byte   $0C                             ; 9929 0C                       .
        ora     $1B1B,x                         ; 992A 1D 1B 1B                 ...
        .byte   $1A                             ; 992D 1A                       .
        .byte   $1A                             ; 992E 1A                       .
        sei                                     ; 992F 78                       x
        ora     ($12),y                         ; 9930 11 12                    ..
        .byte   $6F                             ; 9932 6F                       o
        php                                     ; 9933 08                       .
        sei                                     ; 9934 78                       x
        adc     $0E7A,y                         ; 9935 79 7A 0E                 yz.
        ora     ($12),y                         ; 9938 11 12                    ..
        asl     $0E0E                           ; 993A 0E 0E 0E                 ...
        asl     $0E0E                           ; 993D 0E 0E 0E                 ...
        .byte   $34                             ; 9940 34                       4
        and     $36,x                           ; 9941 35 36                    56
        eor     ($34,x)                         ; 9943 41 34                    A4
        and     $36,x                           ; 9945 35 36                    56
        eor     ($1C,x)                         ; 9947 41 1C                    A.
        .byte   $1A                             ; 9949 1A                       .
        ora     $1A1E,x                         ; 994A 1D 1E 1A                 ...
        .byte   $1A                             ; 994D 1A                       .
        ora     $1A1A,x                         ; 994E 1D 1A 1A                 ...
        ora     $1B1A,x                         ; 9951 1D 1A 1B                 ...
        .byte   $1A                             ; 9954 1A                       .
        ora     $1A1A,x                         ; 9955 1D 1A 1A                 ...
        jmp     (L6C6C)                         ; 9958 6C 6C 6C                 lll

; ----------------------------------------------------------------------------
        asl     $1E1E,x                         ; 995B 1E 1E 1E                 ...
        .byte   $1B                             ; 995E 1B                       .
        asl     $1A1D,x                         ; 995F 1E 1D 1A                 ...
        ora     $1A1B,x                         ; 9962 1D 1B 1A                 ...
        ora     $1D1A,x                         ; 9965 1D 1A 1D                 ...
        adc     $6F7A,y                         ; 9968 79 7A 6F                 yzo
        php                                     ; 996B 08                       .
        ora     $7B1C,x                         ; 996C 1D 1C 7B                 ..{
        sei                                     ; 996F 78                       x
        asl     $0E0E                           ; 9970 0E 0E 0E                 ...
        asl     $7B1A,x                         ; 9973 1E 1A 7B                 ..{
        asl     $0E0E                           ; 9976 0E 0E 0E                 ...
        asl     $6F0E                           ; 9979 0E 0E 6F                 ..o
        php                                     ; 997C 08                       .
        asl     $0E0E                           ; 997D 0E 0E 0E                 ...
        asl     $0E0E                           ; 9980 0E 0E 0E                 ...
        asl     $0E0E                           ; 9983 0E 0E 0E                 ...
        bit     $1D0E                           ; 9986 2C 0E 1D                 ,..
        .byte   $2B                             ; 9989 2B                       +
        .byte   $2B                             ; 998A 2B                       +
        .byte   $2B                             ; 998B 2B                       +
        .byte   $1C                             ; 998C 1C                       .
L998D:  asl     $0E2C,x                         ; 998D 1E 2C 0E                 .,.
        .byte   $1A                             ; 9990 1A                       .
        ora     $1D1A,x                         ; 9991 1D 1A 1D                 ...
        .byte   $1A                             ; 9994 1A                       .
        .byte   $1B                             ; 9995 1B                       .
        .byte   $7C                             ; 9996 7C                       |
        asl     $1E1E                           ; 9997 0E 1E 1E                 ...
        .byte   $1B                             ; 999A 1B                       .
        asl     $1E1E,x                         ; 999B 1E 1E 1E                 ...
        adc     $1A0E,x                         ; 999E 7D 0E 1A                 }..
        .byte   $1C                             ; 99A1 1C                       .
        .byte   $1A                             ; 99A2 1A                       .
        .byte   $1A                             ; 99A3 1A                       .
        .byte   $1A                             ; 99A4 1A                       .
        .byte   $1B                             ; 99A5 1B                       .
        adc     $790E,x                         ; 99A6 7D 0E 79                 }.y
        .byte   $7A                             ; 99A9 7A                       z
        ora     #$0A                            ; 99AA 09 0A                    ..
        .byte   $0B                             ; 99AC 0B                       .
        .byte   $0C                             ; 99AD 0C                       .
        ror     $0E0E,x                         ; 99AE 7E 0E 0E                 ~..
        asl     $100F                           ; 99B1 0E 0F 10                 ...
        ora     ($12),y                         ; 99B4 11 12                    ..
        asl     $0E0E                           ; 99B6 0E 0E 0E                 ...
        asl     $100F                           ; 99B9 0E 0F 10                 ...
        ora     ($12),y                         ; 99BC 11 12                    ..
        asl     $0E0E                           ; 99BE 0E 0E 0E                 ...
        ora     $1A2C,x                         ; 99C1 1D 2C 1A                 .,.
        asl     $0E0E                           ; 99C4 0E 0E 0E                 ...
        asl     $7B0E                           ; 99C7 0E 0E 7B                 ..{
        bit     $1A1D                           ; 99CA 2C 1D 1A                 ,..
        .byte   $1A                             ; 99CD 1A                       .
        asl     $0E0E                           ; 99CE 0E 0E 0E                 ...
        asl     $707B                           ; 99D1 0E 7B 70                 .{p
        .byte   $1A                             ; 99D4 1A                       .
        .byte   $1A                             ; 99D5 1A                       .
        .byte   $1C                             ; 99D6 1C                       .
        .byte   $7F                             ; 99D7 7F                       .
        asl     $0E0E                           ; 99D8 0E 0E 0E                 ...
        asl     $707B                           ; 99DB 0E 7B 70                 .{p
        .byte   $1A                             ; 99DE 1A                       .
        .byte   $7F                             ; 99DF 7F                       .
        .byte   $80                             ; 99E0 80                       .
        ora     $2B1A,x                         ; 99E1 1D 1A 2B                 ..+
        .byte   $1A                             ; 99E4 1A                       .
        .byte   $1A                             ; 99E5 1A                       .
        .byte   $1C                             ; 99E6 1C                       .
        sta     ($80,x)                         ; 99E7 81 80                    ..
        .byte   $1A                             ; 99E9 1A                       .
        sei                                     ; 99EA 78                       x
        adc     $7979,y                         ; 99EB 79 79 79                 yyy
        .byte   $82                             ; 99EE 82                       .
        asl     $1A83                           ; 99EF 0E 83 1A                 ...
        .byte   $1A                             ; 99F2 1A                       .
        .byte   $1C                             ; 99F3 1C                       .
        .byte   $1A                             ; 99F4 1A                       .
        .byte   $1A                             ; 99F5 1A                       .
        ora     $720E,x                         ; 99F6 1D 0E 72                 ..r
        .byte   $07                             ; 99F9 07                       .
        .byte   $07                             ; 99FA 07                       .
        .byte   $07                             ; 99FB 07                       .
        .byte   $07                             ; 99FC 07                       .
        .byte   $07                             ; 99FD 07                       .
        sty     $0E                             ; 99FE 84 0E                    ..
        asl     $0E0E                           ; 9A00 0E 0E 0E                 ...
        asl     $0E0E                           ; 9A03 0E 0E 0E                 ...
        asl     $0E0E                           ; 9A06 0E 0E 0E                 ...
        .byte   $2B                             ; 9A09 2B                       +
        .byte   $2B                             ; 9A0A 2B                       +
        .byte   $2B                             ; 9A0B 2B                       +
        .byte   $2B                             ; 9A0C 2B                       +
        .byte   $2B                             ; 9A0D 2B                       +
        .byte   $2B                             ; 9A0E 2B                       +
        asl     $1A0E                           ; 9A0F 0E 0E 1A                 ...
        ora     $1A1A,x                         ; 9A12 1D 1A 1A                 ...
        ora     $0E1A,x                         ; 9A15 1D 1A 0E                 ...
        asl     $1A1D                           ; 9A18 0E 1D 1A                 ...
        .byte   $1C                             ; 9A1B 1C                       .
        .byte   $1A                             ; 9A1C 1A                       .
        .byte   $1A                             ; 9A1D 1A                       .
        ora     $790E,x                         ; 9A1E 1D 0E 79                 ..y
        .byte   $7A                             ; 9A21 7A                       z
        .byte   $1A                             ; 9A22 1A                       .
        .byte   $1A                             ; 9A23 1A                       .
        ora     $1A1A,x                         ; 9A24 1D 1A 1A                 ...
        asl     $0E0E                           ; 9A27 0E 0E 0E                 ...
        .byte   $7B                             ; 9A2A 7B                       {
        sta     $1A                             ; 9A2B 85 1A                    ..
        sta     $86                             ; 9A2D 85 86                    ..
        asl     $0E0E                           ; 9A2F 0E 0E 0E                 ...
        asl     $1C87                           ; 9A32 0E 87 1C                 ...
        .byte   $87                             ; 9A35 87                       .
        dey                                     ; 9A36 88                       .
        asl     $0E0E                           ; 9A37 0E 0E 0E                 ...
        asl     $1C87                           ; 9A3A 0E 87 1C                 ...
        .byte   $87                             ; 9A3D 87                       .
        dey                                     ; 9A3E 88                       .
        asl     $0E0E                           ; 9A3F 0E 0E 0E                 ...
        .byte   $89                             ; 9A42 89                       .
        ora     ($01,x)                         ; 9A43 01 01                    ..
        ora     ($01,x)                         ; 9A45 01 01                    ..
        ora     ($0E,x)                         ; 9A47 01 0E                    ..
        asl     $0189                           ; 9A49 0E 89 01                 ...
        ora     ($01,x)                         ; 9A4C 01 01                    ..
        ora     ($01,x)                         ; 9A4E 01 01                    ..
        asl     L891C                           ; 9A50 0E 1C 89                 ...
        ora     ($01,x)                         ; 9A53 01 01                    ..
        ora     ($01,x)                         ; 9A55 01 01                    ..
        ora     ($0E,x)                         ; 9A57 01 0E                    ..
        .byte   $1C                             ; 9A59 1C                       .
        .byte   $89                             ; 9A5A 89                       .
        ora     ($01,x)                         ; 9A5B 01 01                    ..
        ora     ($8A,x)                         ; 9A5D 01 8A                    ..
        ora     ($0E,x)                         ; 9A5F 01 0E                    ..
        .byte   $1C                             ; 9A61 1C                       .
        .byte   $89                             ; 9A62 89                       .
        txa                                     ; 9A63 8A                       .
        .byte   $8B                             ; 9A64 8B                       .
        sty     $018D                           ; 9A65 8C 8D 01                 ...
        asl     L891C                           ; 9A68 0E 1C 89                 ...
        stx     L908F                           ; 9A6B 8E 8F 90                 ...
        sta     ($92),y                         ; 9A6E 91 92                    ..
        asl     L931C                           ; 9A70 0E 1C 93                 ...
        sty     $6F,x                           ; 9A73 94 6F                    .o
        php                                     ; 9A75 08                       .
        asl     $0E0E                           ; 9A76 0E 0E 0E                 ...
        .byte   $1C                             ; 9A79 1C                       .
        adc     $0E0E,x                         ; 9A7A 7D 0E 0E                 }..
        asl     $0E0E                           ; 9A7D 0E 0E 0E                 ...
        ora     ($01,x)                         ; 9A80 01 01                    ..
        ora     ($01,x)                         ; 9A82 01 01                    ..
        ora     ($01,x)                         ; 9A84 01 01                    ..
        ora     ($01,x)                         ; 9A86 01 01                    ..
        ora     ($01,x)                         ; 9A88 01 01                    ..
        ora     ($01,x)                         ; 9A8A 01 01                    ..
        ora     ($01,x)                         ; 9A8C 01 01                    ..
L9A8E:  ora     ($01,x)                         ; 9A8E 01 01                    ..
        ora     ($01,x)                         ; 9A90 01 01                    ..
        ora     ($01,x)                         ; 9A92 01 01                    ..
        ora     ($01,x)                         ; 9A94 01 01                    ..
        txa                                     ; 9A96 8A                       .
        ora     ($01,x)                         ; 9A97 01 01                    ..
        ora     ($95,x)                         ; 9A99 01 95                    ..
        ora     ($8A,x)                         ; 9A9B 01 8A                    ..
        ora     ($01,x)                         ; 9A9D 01 01                    ..
        ora     ($8A,x)                         ; 9A9F 01 8A                    ..
        stx     $97,y                           ; 9AA1 96 97                    ..
        tya                                     ; 9AA3 98                       .
        ora     ($8B,x)                         ; 9AA4 01 8B                    ..
        sty     L998D                           ; 9AA6 8C 8D 99                 ...
        txs                                     ; 9AA9 9A                       .
        .byte   $9B                             ; 9AAA 9B                       .
        .byte   $9C                             ; 9AAB 9C                       .
        sta     L908F,x                         ; 9AAC 9D 8F 90                 ...
        .byte   $9E                             ; 9AAF 9E                       .
        asl     L9F0E                           ; 9AB0 0E 0E 9F                 ...
        .byte   $9F                             ; 9AB3 9F                       .
        ldy     #$A1                            ; 9AB4 A0 A1                    ..
        asl     $9B                             ; 9AB6 06 9B                    ..
        asl     L9F0E                           ; 9AB8 0E 0E 9F                 ...
        .byte   $9F                             ; 9ABB 9F                       .
        ldy     #$A1                            ; 9ABC A0 A1                    ..
        asl     $9F                             ; 9ABE 06 9F                    ..
        ora     ($01,x)                         ; 9AC0 01 01                    ..
        ora     ($01,x)                         ; 9AC2 01 01                    ..
        ora     ($01,x)                         ; 9AC4 01 01                    ..
        ora     ($01,x)                         ; 9AC6 01 01                    ..
        ora     ($01,x)                         ; 9AC8 01 01                    ..
        ora     ($01,x)                         ; 9ACA 01 01                    ..
        ora     ($01,x)                         ; 9ACC 01 01                    ..
        ora     ($01,x)                         ; 9ACE 01 01                    ..
        ora     ($01,x)                         ; 9AD0 01 01                    ..
        ora     ($01,x)                         ; 9AD2 01 01                    ..
        ora     ($8A,x)                         ; 9AD4 01 8A                    ..
L9AD6:  ora     ($01,x)                         ; 9AD6 01 01                    ..
        ora     ($8A,x)                         ; 9AD8 01 8A                    ..
        sta     $01,x                           ; 9ADA 95 01                    ..
        ora     ($01,x)                         ; 9ADC 01 01                    ..
        ora     ($01,x)                         ; 9ADE 01 01                    ..
        txa                                     ; 9AE0 8A                       .
        stx     $97,y                           ; 9AE1 96 97                    ..
        tya                                     ; 9AE3 98                       .
        ora     ($8B,x)                         ; 9AE4 01 8B                    ..
        sty     L988D                           ; 9AE6 8C 8D 98                 ...
        ldx     #$A3                            ; 9AE9 A2 A3                    ..
        ldy     $9D                             ; 9AEB A4 9D                    ..
        .byte   $8F                             ; 9AED 8F                       .
        bcc     L9A8E                           ; 9AEE 90 9E                    ..
        .byte   $9C                             ; 9AF0 9C                       .
        .byte   $9F                             ; 9AF1 9F                       .
        .byte   $A3                             ; 9AF2 A3                       .
        .byte   $9B                             ; 9AF3 9B                       .
        .byte   $9C                             ; 9AF4 9C                       .
        lda     $A6                             ; 9AF5 A5 A6                    ..
        .byte   $9B                             ; 9AF7 9B                       .
        .byte   $9F                             ; 9AF8 9F                       .
        .byte   $9F                             ; 9AF9 9F                       .
        .byte   $A3                             ; 9AFA A3                       .
        .byte   $9F                             ; 9AFB 9F                       .
        .byte   $9F                             ; 9AFC 9F                       .
        .byte   $9F                             ; 9AFD 9F                       .
        .byte   $9F                             ; 9AFE 9F                       .
        .byte   $9F                             ; 9AFF 9F                       .
        ora     ($01,x)                         ; 9B00 01 01                    ..
        ora     ($01,x)                         ; 9B02 01 01                    ..
        ora     ($01,x)                         ; 9B04 01 01                    ..
        ora     ($01,x)                         ; 9B06 01 01                    ..
        ora     ($01,x)                         ; 9B08 01 01                    ..
        ora     ($01,x)                         ; 9B0A 01 01                    ..
        ora     ($01,x)                         ; 9B0C 01 01                    ..
        ora     ($01,x)                         ; 9B0E 01 01                    ..
        ora     ($01,x)                         ; 9B10 01 01                    ..
        ora     ($01,x)                         ; 9B12 01 01                    ..
        txa                                     ; 9B14 8A                       .
        ora     ($01,x)                         ; 9B15 01 01                    ..
        ora     ($8A,x)                         ; 9B17 01 8A                    ..
        ora     ($01,x)                         ; 9B19 01 01                    ..
        sta     $01,x                           ; 9B1B 95 01                    ..
        .byte   $A7                             ; 9B1D A7                       .
        ora     ($01,x)                         ; 9B1E 01 01                    ..
        ora     ($8A,x)                         ; 9B20 01 8A                    ..
        stx     $97,y                           ; 9B22 96 97                    ..
        tay                                     ; 9B24 A8                       .
        lda     #$AA                            ; 9B25 A9 AA                    ..
        txa                                     ; 9B27 8A                       .
        tya                                     ; 9B28 98                       .
        ldx     #$AB                            ; 9B29 A2 AB                    ..
        ldy     $AEAD                           ; 9B2B AC AD AE                 ...
        .byte   $9B                             ; 9B2E 9B                       .
        .byte   $AF                             ; 9B2F AF                       .
        .byte   $9C                             ; 9B30 9C                       .
        .byte   $9F                             ; 9B31 9F                       .
        ldy     #$9F                            ; 9B32 A0 9F                    ..
        .byte   $9F                             ; 9B34 9F                       .
        bcs     L9AD6                           ; 9B35 B0 9F                    ..
        .byte   $9F                             ; 9B37 9F                       .
        .byte   $9F                             ; 9B38 9F                       .
        .byte   $9F                             ; 9B39 9F                       .
        ldy     #$9F                            ; 9B3A A0 9F                    ..
        .byte   $9F                             ; 9B3C 9F                       .
        .byte   $9F                             ; 9B3D 9F                       .
        .byte   $9F                             ; 9B3E 9F                       .
        .byte   $9F                             ; 9B3F 9F                       .
        ora     $0E0E,y                         ; 9B40 19 0E 0E                 ...
        asl     $0E0E                           ; 9B43 0E 0E 0E                 ...
        .byte   $43                             ; 9B46 43                       C
        asl     $1A19                           ; 9B47 0E 19 1A                 ...
        .byte   $1C                             ; 9B4A 1C                       .
        .byte   $1A                             ; 9B4B 1A                       .
        ora     $461A,x                         ; 9B4C 1D 1A 46                 ..F
        asl     $1D19                           ; 9B4F 0E 19 1D                 ...
        .byte   $1A                             ; 9B52 1A                       .
        .byte   $1A                             ; 9B53 1A                       .
        .byte   $1A                             ; 9B54 1A                       .
        ora     $0E46,x                         ; 9B55 1D 46 0E                 .F.
        ora     $1D1A,y                         ; 9B58 19 1A 1D                 ...
        .byte   $1A                             ; 9B5B 1A                       .
        ora     $461A,x                         ; 9B5C 1D 1A 46                 ..F
        asl     $7819                           ; 9B5F 0E 19 78                 ..x
        adc     $7979,y                         ; 9B62 79 79 79                 yyy
        adc     $0EB1,y                         ; 9B65 79 B1 0E                 y..
        .byte   $9C                             ; 9B68 9C                       .
        asl     $0E0E                           ; 9B69 0E 0E 0E                 ...
        asl     $0E0E                           ; 9B6C 0E 0E 0E                 ...
        asl     $0E9F                           ; 9B6F 0E 9F 0E                 ...
        asl     $0E0E                           ; 9B72 0E 0E 0E                 ...
        asl     $0E0E                           ; 9B75 0E 0E 0E                 ...
        .byte   $9F                             ; 9B78 9F                       .
        asl     $0E0E                           ; 9B79 0E 0E 0E                 ...
        asl     $0E0E                           ; 9B7C 0E 0E 0E                 ...
        asl     $0E0E                           ; 9B7F 0E 0E 0E                 ...
        .byte   $B2                             ; 9B82 B2                       .
        .byte   $B2                             ; 9B83 B2                       .
        .byte   $B3                             ; 9B84 B3                       .
        .byte   $89                             ; 9B85 89                       .
        ora     ($01,x)                         ; 9B86 01 01                    ..
        asl     $B2B2                           ; 9B88 0E B2 B2                 ...
        asl     L8980                           ; 9B8B 0E 80 89                 ...
        ldy     $95,x                           ; 9B8E B4 95                    ..
        .byte   $0E                             ; 9B90 0E                       .
        .byte   $1C                             ; 9B91 1C                       .
L9B92:  asl     $1C80                           ; 9B92 0E 80 1C                 ...
        .byte   $89                             ; 9B95 89                       .
        stx     $97,y                           ; 9B96 96 97                    ..
        asl     $0E0E                           ; 9B98 0E 0E 0E                 ...
        .byte   $72                             ; 9B9B 72                       r
        lda     $B6,x                           ; 9B9C B5 B6                    ..
        .byte   $AB                             ; 9B9E AB                       .
        .byte   $A3                             ; 9B9F A3                       .
        asl     $0E0E                           ; 9BA0 0E 0E 0E                 ...
        asl     $B772                           ; 9BA3 0E 72 B7                 .r.
        ldy     #$A3                            ; 9BA6 A0 A3                    ..
L9BA8:  asl     $0E0E                           ; 9BA8 0E 0E 0E                 ...
        asl     $B80E                           ; 9BAB 0E 0E B8                 ...
        lda     $0EBA,y                         ; 9BAE B9 BA 0E                 ...
        asl     $0E0E                           ; 9BB1 0E 0E 0E                 ...
        asl     $430E                           ; 9BB4 0E 0E 43                 ..C
        asl     $0E0E                           ; 9BB7 0E 0E 0E                 ...
        asl     $0E0E                           ; 9BBA 0E 0E 0E                 ...
        asl     $0E43                           ; 9BBD 0E 43 0E                 .C.
        ora     ($01,x)                         ; 9BC0 01 01                    ..
        ora     ($01,x)                         ; 9BC2 01 01                    ..
        ldy     $01,x                           ; 9BC4 B4 01                    ..
        ora     ($8B,x)                         ; 9BC6 01 8B                    ..
        ora     ($01,x)                         ; 9BC8 01 01                    ..
        ora     ($8B,x)                         ; 9BCA 01 8B                    ..
        sty     L8E8D                           ; 9BCC 8C 8D 8E                 ...
        .byte   $8F                             ; 9BCF 8F                       .
        .byte   $BB                             ; 9BD0 BB                       .
        ora     ($8E,x)                         ; 9BD1 01 8E                    ..
        .byte   $8F                             ; 9BD3 8F                       .
        bcc     L9B92                           ; 9BD4 90 BC                    ..
        ldx     #$A5                            ; 9BD6 A2 A5                    ..
        ldy     $9D                             ; 9BD8 A4 9D                    ..
        lda     $BEA1,x                         ; 9BDA BD A1 BE                 ...
        ldy     #$9F                            ; 9BDD A0 9F                    ..
        .byte   $9F                             ; 9BDF 9F                       .
        ldx     $A0A0,y                         ; 9BE0 BE A0 A0                 ...
        .byte   $BF                             ; 9BE3 BF                       .
        ldy     #$A0                            ; 9BE4 A0 A0                    ..
        .byte   $9F                             ; 9BE6 9F                       .
        .byte   $9F                             ; 9BE7 9F                       .
        .byte   $AF                             ; 9BE8 AF                       .
        .byte   $9C                             ; 9BE9 9C                       .
        ldy     #$A0                            ; 9BEA A0 A0                    ..
        ldy     #$A0                            ; 9BEC A0 A0                    ..
        .byte   $9F                             ; 9BEE 9F                       .
        .byte   $9F                             ; 9BEF 9F                       .
        .byte   $9F                             ; 9BF0 9F                       .
        .byte   $9F                             ; 9BF1 9F                       .
        ldy     #$A0                            ; 9BF2 A0 A0                    ..
        ldy     #$A0                            ; 9BF4 A0 A0                    ..
        .byte   $9F                             ; 9BF6 9F                       .
        .byte   $9F                             ; 9BF7 9F                       .
        .byte   $9F                             ; 9BF8 9F                       .
        .byte   $9F                             ; 9BF9 9F                       .
        ldy     #$A0                            ; 9BFA A0 A0                    ..
        ldy     #$A0                            ; 9BFC A0 A0                    ..
        .byte   $9F                             ; 9BFE 9F                       .
        .byte   $9F                             ; 9BFF 9F                       .
        sty     $018D                           ; 9C00 8C 8D 01                 ...
        ora     ($B4,x)                         ; 9C03 01 B4                    ..
        ora     $0E0E,y                         ; 9C05 19 0E 0E                 ...
        bcc     L9BA8                           ; 9C08 90 9E                    ..
        .byte   $BB                             ; 9C0A BB                       .
        ora     ($A7,x)                         ; 9C0B 01 A7                    ..
        ora     $0E0E,y                         ; 9C0D 19 0E 0E                 ...
        ldx     $06                             ; 9C10 A6 06                    ..
        ldy     $A8                             ; 9C12 A4 A8                    ..
        lda     #$C0                            ; 9C14 A9 C0                    ..
        asl     L9F0E                           ; 9C16 0E 0E 9F                 ...
        ldx     #$06                            ; 9C19 A2 06                    ..
        ldy     $AE                             ; 9C1B A4 AE                    ..
        cmp     ($0E,x)                         ; 9C1D C1 0E                    ..
        asl     L9F9F                           ; 9C1F 0E 9F 9F                 ...
        ldx     #$06                            ; 9C22 A2 06                    ..
        ldy     $C1                             ; 9C24 A4 C1                    ..
        .byte   $C2                             ; 9C26 C2                       .
        .byte   $C3                             ; 9C27 C3                       .
        .byte   $9F                             ; 9C28 9F                       .
        .byte   $9F                             ; 9C29 9F                       .
        .byte   $9F                             ; 9C2A 9F                       .
        ldx     #$06                            ; 9C2B A2 06                    ..
        cmp     ($1C,x)                         ; 9C2D C1 1C                    ..
        .byte   $1C                             ; 9C2F 1C                       .
        .byte   $9F                             ; 9C30 9F                       .
        .byte   $9F                             ; 9C31 9F                       .
        .byte   $9F                             ; 9C32 9F                       .
        .byte   $9F                             ; 9C33 9F                       .
        asl     $C1                             ; 9C34 06 C1                    ..
        cpy     $73                             ; 9C36 C4 73                    .s
        .byte   $9F                             ; 9C38 9F                       .
        .byte   $9F                             ; 9C39 9F                       .
        .byte   $9F                             ; 9C3A 9F                       .
        .byte   $9F                             ; 9C3B 9F                       .
        asl     $C1                             ; 9C3C 06 C1                    ..
        asl     $C50E                           ; 9C3E 0E 0E C5                 ...
        .byte   $1C                             ; 9C41 1C                       .
        .byte   $1C                             ; 9C42 1C                       .
        .byte   $1C                             ; 9C43 1C                       .
        ora     $C61C,x                         ; 9C44 1D 1C C6                 ...
        asl     $1DC7                           ; 9C47 0E C7 1D                 ...
        .byte   $1C                             ; 9C4A 1C                       .
        .byte   $1A                             ; 9C4B 1A                       .
        .byte   $1A                             ; 9C4C 1A                       .
        .byte   $1C                             ; 9C4D 1C                       .
        dec     $0E                             ; 9C4E C6 0E                    ..
        asl     $1D1A                           ; 9C50 0E 1A 1D                 ...
        .byte   $1A                             ; 9C53 1A                       .
        .byte   $1A                             ; 9C54 1A                       .
        .byte   $1A                             ; 9C55 1A                       .
        iny                                     ; 9C56 C8                       .
        asl     $1A80                           ; 9C57 0E 80 1A                 ...
        .byte   $1A                             ; 9C5A 1A                       .
        .byte   $1A                             ; 9C5B 1A                       .
        .byte   $1A                             ; 9C5C 1A                       .
        ora     $0E1C,x                         ; 9C5D 1D 1C 0E                 ...
        cmp     #$1A                            ; 9C60 C9 1A                    ..
        ora     $1D1A,x                         ; 9C62 1D 1A 1D                 ...
        .byte   $1A                             ; 9C65 1A                       .
        .byte   $1A                             ; 9C66 1A                       .
        asl     $1C1C                           ; 9C67 0E 1C 1C                 ...
L9C6A:  .byte   $1C                             ; 9C6A 1C                       .
        .byte   $1A                             ; 9C6B 1A                       .
        .byte   $1A                             ; 9C6C 1A                       .
        .byte   $1C                             ; 9C6D 1C                       .
        ora     $730E,x                         ; 9C6E 1D 0E 73                 ..s
        lda     $1C,x                           ; 9C71 B5 1C                    ..
        .byte   $1A                             ; 9C73 1A                       .
        ora     $1D1A,x                         ; 9C74 1D 1A 1D                 ...
        asl     L800E                           ; 9C77 0E 0E 80                 ...
        ora     $1C1C,x                         ; 9C7A 1D 1C 1C                 ...
        ora     $0E1C,x                         ; 9C7D 1D 1C 0E                 ...
        asl     $CA43                           ; 9C80 0E 43 CA                 .C.
        asl     $0E0E                           ; 9C83 0E 0E 0E                 ...
        asl     $0E0E                           ; 9C86 0E 0E 0E                 ...
        .byte   $43                             ; 9C89 43                       C
        .byte   $CB                             ; 9C8A CB                       .
        cpy     $CDCC                           ; 9C8B CC CC CD                 ...
        asl     $0E0E                           ; 9C8E 0E 0E 0E                 ...
        dec     $CFCF                           ; 9C91 CE CF CF                 ...
        .byte   $CF                             ; 9C94 CF                       .
        .byte   $CB                             ; 9C95 CB                       .
        cmp     $0E0E                           ; 9C96 CD 0E 0E                 ...
        bne     L9C6A                           ; 9C99 D0 CF                    ..
        .byte   $CF                             ; 9C9B CF                       .
        .byte   $CF                             ; 9C9C CF                       .
        .byte   $CF                             ; 9C9D CF                       .
        .byte   $CB                             ; 9C9E CB                       .
        asl     $430E                           ; 9C9F 0E 0E 43                 ..C
        .byte   $CF                             ; 9CA2 CF                       .
        .byte   $CF                             ; 9CA3 CF                       .
        .byte   $CF                             ; 9CA4 CF                       .
        .byte   $CF                             ; 9CA5 CF                       .
        cmp     ($D2),y                         ; 9CA6 D1 D2                    ..
        asl     $0872                           ; 9CA8 0E 72 08                 .r.
        .byte   $D3                             ; 9CAB D3                       .
        .byte   $D4                             ; 9CAC D4                       .
        cmp     $D6,x                           ; 9CAD D5 D6                    ..
        asl     $0E0E                           ; 9CAF 0E 0E 0E                 ...
        asl     $0E0E                           ; 9CB2 0E 0E 0E                 ...
        asl     $0E7D                           ; 9CB5 0E 7D 0E                 .}.
        asl     $0E0E                           ; 9CB8 0E 0E 0E                 ...
        asl     $0E0E                           ; 9CBB 0E 0E 0E                 ...
        adc     $0E0E,x                         ; 9CBE 7D 0E 0E                 }..
        asl     $0E0E                           ; 9CC1 0E 0E 0E                 ...
        asl     $0E0E                           ; 9CC4 0E 0E 0E                 ...
        asl     $0E0E                           ; 9CC7 0E 0E 0E                 ...
        asl     $0E0E                           ; 9CCA 0E 0E 0E                 ...
        asl     $0E0E                           ; 9CCD 0E 0E 0E                 ...
        asl     $0E0E                           ; 9CD0 0E 0E 0E                 ...
        asl     $0E0E                           ; 9CD3 0E 0E 0E                 ...
        asl     $0E0E                           ; 9CD6 0E 0E 0E                 ...
        cpy     $CCCC                           ; 9CD9 CC CC CC                 ...
        cpy     $0ECC                           ; 9CDC CC CC 0E                 ...
        asl     $D479                           ; 9CDF 0E 79 D4                 .y.
        cmp     $CF,x                           ; 9CE2 D5 CF                    ..
        .byte   $CF                             ; 9CE4 CF                       .
        .byte   $CF                             ; 9CE5 CF                       .
        asl     $0E0E                           ; 9CE6 0E 0E 0E                 ...
        asl     $7B0E                           ; 9CE9 0E 0E 7B                 ..{
        .byte   $D7                             ; 9CEC D7                       .
        .byte   $CF                             ; 9CED CF                       .
        asl     $0E0E                           ; 9CEE 0E 0E 0E                 ...
        asl     $0E0E                           ; 9CF1 0E 0E 0E                 ...
        asl     $0E7B                           ; 9CF4 0E 7B 0E                 .{.
        asl     $0E0E                           ; 9CF7 0E 0E 0E                 ...
        asl     $0E0E                           ; 9CFA 0E 0E 0E                 ...
        asl     $0E0E                           ; 9CFD 0E 0E 0E                 ...
        .byte   $0E                             ; 9D00 0E                       .
        .byte   $0E                             ; 9D01 0E                       .
L9D02:  asl     L8980                           ; 9D02 0E 80 89                 ...
        ora     ($01,x)                         ; 9D05 01 01                    ..
        ora     ($0E,x)                         ; 9D07 01 0E                    ..
        asl     L800E                           ; 9D09 0E 0E 80                 ...
        .byte   $89                             ; 9D0C 89                       .
        ora     ($01,x)                         ; 9D0D 01 01                    ..
        ora     ($0E,x)                         ; 9D0F 01 0E                    ..
        asl     $1D80                           ; 9D11 0E 80 1D                 ...
        .byte   $89                             ; 9D14 89                       .
        cld                                     ; 9D15 D8                       .
        cmp     $0EDA,y                         ; 9D16 D9 DA 0E                 ...
        asl     $1A80                           ; 9D19 0E 80 1A                 ...
        .byte   $DB                             ; 9D1C DB                       .
        ldy     #$A0                            ; 9D1D A0 A0                    ..
        ldy     #$0E                            ; 9D1F A0 0E                    ..
        .byte   $80                             ; 9D21 80                       .
        ora     $DB1A,x                         ; 9D22 1D 1A DB                 ...
        ldy     #$A0                            ; 9D25 A0 A0                    ..
        .byte   $DC                             ; 9D27 DC                       .
        asl     $1A80                           ; 9D28 0E 80 1A                 ...
        .byte   $1C                             ; 9D2B 1C                       .
        cmp     $DFDE,x                         ; 9D2C DD DE DF                 ...
        asl     $E00E                           ; 9D2F 0E 0E E0                 ...
        sbc     ($74,x)                         ; 9D32 E1 74                    .t
        asl     $0E0E                           ; 9D34 0E 0E 0E                 ...
        asl     $430E                           ; 9D37 0E 0E 43                 ..C
        .byte   $E2                             ; 9D3A E2                       .
        asl     $0E0E                           ; 9D3B 0E 0E 0E                 ...
        asl     $010E                           ; 9D3E 0E 0E 01                 ...
        ora     ($01,x)                         ; 9D41 01 01                    ..
        ora     ($01,x)                         ; 9D43 01 01                    ..
        ora     ($01,x)                         ; 9D45 01 01                    ..
        ora     ($01,x)                         ; 9D47 01 01                    ..
        ora     ($01,x)                         ; 9D49 01 01                    ..
        ora     ($01,x)                         ; 9D4B 01 01                    ..
        ora     ($01,x)                         ; 9D4D 01 01                    ..
        ora     ($DA,x)                         ; 9D4F 01 DA                    ..
        .byte   $E3                             ; 9D51 E3                       .
        .byte   $E3                             ; 9D52 E3                       .
        cmp     $DADA,y                         ; 9D53 D9 DA DA                 ...
        cpx     $D9                             ; 9D56 E4 D9                    ..
        sbc     $DE                             ; 9D58 E5 DE                    ..
        ldy     #$E6                            ; 9D5A A0 E6                    ..
        .byte   $E7                             ; 9D5C E7                       .
        .byte   $E7                             ; 9D5D E7                       .
        .byte   $E7                             ; 9D5E E7                       .
        inx                                     ; 9D5F E8                       .
        .byte   $9F                             ; 9D60 9F                       .
        .byte   $9F                             ; 9D61 9F                       .
        ldy     #$A0                            ; 9D62 A0 A0                    ..
        ldy     #$A0                            ; 9D64 A0 A0                    ..
        ldy     #$A0                            ; 9D66 A0 A0                    ..
        .byte   $9F                             ; 9D68 9F                       .
        .byte   $9F                             ; 9D69 9F                       .
        sbc     $DE                             ; 9D6A E5 DE                    ..
        ldy     #$A0                            ; 9D6C A0 A0                    ..
        ldy     #$A0                            ; 9D6E A0 A0                    ..
        .byte   $9F                             ; 9D70 9F                       .
        .byte   $9F                             ; 9D71 9F                       .
        .byte   $9F                             ; 9D72 9F                       .
        .byte   $9F                             ; 9D73 9F                       .
        sbc     #$EA                            ; 9D74 E9 EA                    ..
        .byte   $9C                             ; 9D76 9C                       .
        ldx     #$9F                            ; 9D77 A2 9F                    ..
        .byte   $9F                             ; 9D79 9F                       .
        .byte   $9F                             ; 9D7A 9F                       .
        .byte   $9F                             ; 9D7B 9F                       .
        .byte   $EB                             ; 9D7C EB                       .
        cpx     L9F9F                           ; 9D7D EC 9F 9F                 ...
        ora     ($01,x)                         ; 9D80 01 01                    ..
        ora     ($01,x)                         ; 9D82 01 01                    ..
        ora     ($01,x)                         ; 9D84 01 01                    ..
        ora     ($01,x)                         ; 9D86 01 01                    ..
        cld                                     ; 9D88 D8                       .
        cld                                     ; 9D89 D8                       .
        .byte   $E3                             ; 9D8A E3                       .
        cmp     $DADA,y                         ; 9D8B D9 DA DA                 ...
        cld                                     ; 9D8E D8                       .
        cld                                     ; 9D8F D8                       .
        ldy     #$ED                            ; 9D90 A0 ED                    ..
        inc     $A0A0                           ; 9D92 EE A0 A0                 ...
        .byte   $A0                             ; 9D95 A0                       .
L9D96:  ldy     #$A0                            ; 9D96 A0 A0                    ..
        ldy     #$A0                            ; 9D98 A0 A0                    ..
        ldy     #$A0                            ; 9D9A A0 A0                    ..
        sbc     $EEEF                           ; 9D9C ED EF EE                 ...
        ldy     #$A0                            ; 9D9F A0 A0                    ..
        ldy     #$A0                            ; 9DA1 A0 A0                    ..
        ldy     #$A0                            ; 9DA3 A0 A0                    ..
        ldy     #$ED                            ; 9DA5 A0 ED                    ..
        inc     $A0A2                           ; 9DA7 EE A2 A0                 ...
        ldx     #$A0                            ; 9DAA A2 A0                    ..
        ldy     #$A0                            ; 9DAC A0 A0                    ..
        ldy     #$A0                            ; 9DAE A0 A0                    ..
        .byte   $9F                             ; 9DB0 9F                       .
        sbc     #$9F                            ; 9DB1 E9 9F                    ..
        ldx     #$A2                            ; 9DB3 A2 A2                    ..
        sbc     #$E9                            ; 9DB5 E9 E9                    ..
        .byte   $9B                             ; 9DB7 9B                       .
        .byte   $9F                             ; 9DB8 9F                       .
        .byte   $EB                             ; 9DB9 EB                       .
        .byte   $9F                             ; 9DBA 9F                       .
        .byte   $9F                             ; 9DBB 9F                       .
        .byte   $9F                             ; 9DBC 9F                       .
        .byte   $EB                             ; 9DBD EB                       .
        .byte   $EB                             ; 9DBE EB                       .
        .byte   $9F                             ; 9DBF 9F                       .
        beq     L9DD0                           ; 9DC0 F0 0E                    ..
        asl     $0E0E                           ; 9DC2 0E 0E 0E                 ...
        asl     $0E0E                           ; 9DC5 0E 0E 0E                 ...
        beq     L9D96                           ; 9DC8 F0 CC                    ..
        .byte   $2B                             ; 9DCA 2B                       +
        asl     $0E0E                           ; 9DCB 0E 0E 0E                 ...
        .byte   $0E                             ; 9DCE 0E                       .
        .byte   $0E                             ; 9DCF 0E                       .
L9DD0:  sbc     ($CF),y                         ; 9DD0 F1 CF                    ..
        .byte   $CF                             ; 9DD2 CF                       .
        .byte   $2B                             ; 9DD3 2B                       +
        .byte   $2B                             ; 9DD4 2B                       +
        asl     $0E0E                           ; 9DD5 0E 0E 0E                 ...
        sbc     ($CF),y                         ; 9DD8 F1 CF                    ..
        .byte   $CF                             ; 9DDA CF                       .
        .byte   $CF                             ; 9DDB CF                       .
        .byte   $CF                             ; 9DDC CF                       .
        .byte   $2B                             ; 9DDD 2B                       +
        .byte   $2B                             ; 9DDE 2B                       +
        asl     $CFF1                           ; 9DDF 0E F1 CF                 ...
        .byte   $CF                             ; 9DE2 CF                       .
        .byte   $CF                             ; 9DE3 CF                       .
        .byte   $CF                             ; 9DE4 CF                       .
        .byte   $CF                             ; 9DE5 CF                       .
        .byte   $CF                             ; 9DE6 CF                       .
        .byte   $F2                             ; 9DE7 F2                       .
        sbc     ($CF),y                         ; 9DE8 F1 CF                    ..
        .byte   $CF                             ; 9DEA CF                       .
        .byte   $6F                             ; 9DEB 6F                       o
        .byte   $F3                             ; 9DEC F3                       .
        .byte   $CF                             ; 9DED CF                       .
        .byte   $CF                             ; 9DEE CF                       .
        .byte   $F4                             ; 9DEF F4                       .
        .byte   $AF                             ; 9DF0 AF                       .
        .byte   $AF                             ; 9DF1 AF                       .
        .byte   $9C                             ; 9DF2 9C                       .
        asl     $6F0E                           ; 9DF3 0E 0E 6F                 ..o
        .byte   $07                             ; 9DF6 07                       .
        .byte   $07                             ; 9DF7 07                       .
        .byte   $9F                             ; 9DF8 9F                       .
        .byte   $9F                             ; 9DF9 9F                       .
        .byte   $9F                             ; 9DFA 9F                       .
        asl     $0E0E                           ; 9DFB 0E 0E 0E                 ...
        asl     $0E0E                           ; 9DFE 0E 0E 0E                 ...
        asl     $0E9F                           ; 9E01 0E 9F 0E                 ...
        asl     $0E9F                           ; 9E04 0E 9F 0E                 ...
        asl     $0E0E                           ; 9E07 0E 0E 0E                 ...
        .byte   $9F                             ; 9E0A 9F                       .
        asl     L9F0E                           ; 9E0B 0E 0E 9F                 ...
        asl     $0E0E                           ; 9E0E 0E 0E 0E                 ...
        asl     $0E9F                           ; 9E11 0E 9F 0E                 ...
        asl     $0E9F                           ; 9E14 0E 9F 0E                 ...
        asl     $0E0E                           ; 9E17 0E 0E 0E                 ...
        .byte   $9F                             ; 9E1A 9F                       .
        asl     L9F0E                           ; 9E1B 0E 0E 9F                 ...
        asl     $2B0E                           ; 9E1E 0E 0E 2B                 ..+
        .byte   $2B                             ; 9E21 2B                       +
        sbc     $2B,x                           ; 9E22 F5 2B                    .+
        .byte   $2B                             ; 9E24 2B                       +
        sbc     $2B,x                           ; 9E25 F5 2B                    .+
        .byte   $F2                             ; 9E27 F2                       .
        .byte   $CF                             ; 9E28 CF                       .
        .byte   $CF                             ; 9E29 CF                       .
        .byte   $CF                             ; 9E2A CF                       .
        .byte   $CF                             ; 9E2B CF                       .
        .byte   $CF                             ; 9E2C CF                       .
        .byte   $CF                             ; 9E2D CF                       .
        .byte   $CF                             ; 9E2E CF                       .
        .byte   $F4                             ; 9E2F F4                       .
        .byte   $07                             ; 9E30 07                       .
        .byte   $07                             ; 9E31 07                       .
        ldx     #$07                            ; 9E32 A2 07                    ..
        .byte   $07                             ; 9E34 07                       .
        ldx     #$07                            ; 9E35 A2 07                    ..
        .byte   $07                             ; 9E37 07                       .
        asl     L9F0E                           ; 9E38 0E 0E 9F                 ...
        asl     L9F0E                           ; 9E3B 0E 0E 9F                 ...
        asl     $F60E                           ; 9E3E 0E 0E F6                 ...
        .byte   $F7                             ; 9E41 F7                       .
        inc     $F7,x                           ; 9E42 F6 F7                    ..
        .byte   $F7                             ; 9E44 F7                       .
        inc     $F7,x                           ; 9E45 F6 F7                    ..
        inc     $F8,x                           ; 9E47 F6 F8                    ..
        sbc     $F9CC,y                         ; 9E49 F9 CC F9                 ...
        sbc     $F9CC,y                         ; 9E4C F9 CC F9                 ...
        .byte   $FA                             ; 9E4F FA                       .
        .byte   $FB                             ; 9E50 FB                       .
        .byte   $1B                             ; 9E51 1B                       .
        .byte   $CF                             ; 9E52 CF                       .
        .byte   $1B                             ; 9E53 1B                       .
        .byte   $1B                             ; 9E54 1B                       .
        .byte   $CF                             ; 9E55 CF                       .
        .byte   $1B                             ; 9E56 1B                       .
        .byte   $FC                             ; 9E57 FC                       .
        .byte   $FB                             ; 9E58 FB                       .
        .byte   $1B                             ; 9E59 1B                       .
        .byte   $CF                             ; 9E5A CF                       .
        .byte   $1B                             ; 9E5B 1B                       .
        .byte   $1B                             ; 9E5C 1B                       .
        .byte   $CF                             ; 9E5D CF                       .
        .byte   $1B                             ; 9E5E 1B                       .
        .byte   $FC                             ; 9E5F FC                       .
        sbc     $CF1B,x                         ; 9E60 FD 1B CF                 ...
        .byte   $1B                             ; 9E63 1B                       .
        .byte   $1B                             ; 9E64 1B                       .
        .byte   $CF                             ; 9E65 CF                       .
        .byte   $1B                             ; 9E66 1B                       .
        .byte   $FC                             ; 9E67 FC                       .
        .byte   $CF                             ; 9E68 CF                       .
        .byte   $1B                             ; 9E69 1B                       .
        .byte   $CF                             ; 9E6A CF                       .
        .byte   $1B                             ; 9E6B 1B                       .
        .byte   $1B                             ; 9E6C 1B                       .
        .byte   $CF                             ; 9E6D CF                       .
        .byte   $1B                             ; 9E6E 1B                       .
        .byte   $FC                             ; 9E6F FC                       .
        ldx     #$07                            ; 9E70 A2 07                    ..
        ldx     #$07                            ; 9E72 A2 07                    ..
        .byte   $07                             ; 9E74 07                       .
        ldx     #$07                            ; 9E75 A2 07                    ..
        ldx     #$9F                            ; 9E77 A2 9F                    ..
        asl     $0E9F                           ; 9E79 0E 9F 0E                 ...
        asl     $0E9F                           ; 9E7C 0E 9F 0E                 ...
        .byte   $9F                             ; 9E7F 9F                       .
        .byte   $1C                             ; 9E80 1C                       .
        .byte   $1C                             ; 9E81 1C                       .
        .byte   $1C                             ; 9E82 1C                       .
        .byte   $1C                             ; 9E83 1C                       .
        .byte   $1C                             ; 9E84 1C                       .
        .byte   $1C                             ; 9E85 1C                       .
        .byte   $1C                             ; 9E86 1C                       .
        .byte   $1C                             ; 9E87 1C                       .
        .byte   $1C                             ; 9E88 1C                       .
        .byte   $1C                             ; 9E89 1C                       .
        .byte   $1C                             ; 9E8A 1C                       .
        .byte   $1C                             ; 9E8B 1C                       .
        .byte   $1C                             ; 9E8C 1C                       .
        .byte   $1C                             ; 9E8D 1C                       .
        .byte   $1C                             ; 9E8E 1C                       .
        .byte   $1C                             ; 9E8F 1C                       .
        .byte   $1C                             ; 9E90 1C                       .
        .byte   $1C                             ; 9E91 1C                       .
        .byte   $1C                             ; 9E92 1C                       .
        .byte   $1C                             ; 9E93 1C                       .
        .byte   $1C                             ; 9E94 1C                       .
        .byte   $1C                             ; 9E95 1C                       .
        .byte   $1C                             ; 9E96 1C                       .
        .byte   $1C                             ; 9E97 1C                       .
        .byte   $1C                             ; 9E98 1C                       .
        .byte   $1C                             ; 9E99 1C                       .
        .byte   $1C                             ; 9E9A 1C                       .
        .byte   $1C                             ; 9E9B 1C                       .
        .byte   $1C                             ; 9E9C 1C                       .
        .byte   $1C                             ; 9E9D 1C                       .
        .byte   $1C                             ; 9E9E 1C                       .
        .byte   $1C                             ; 9E9F 1C                       .
        .byte   $1C                             ; 9EA0 1C                       .
        .byte   $1C                             ; 9EA1 1C                       .
        .byte   $1C                             ; 9EA2 1C                       .
        .byte   $1C                             ; 9EA3 1C                       .
        .byte   $1C                             ; 9EA4 1C                       .
        .byte   $1C                             ; 9EA5 1C                       .
        .byte   $1C                             ; 9EA6 1C                       .
        .byte   $1C                             ; 9EA7 1C                       .
        .byte   $1C                             ; 9EA8 1C                       .
        .byte   $1C                             ; 9EA9 1C                       .
        .byte   $1C                             ; 9EAA 1C                       .
        .byte   $1C                             ; 9EAB 1C                       .
        .byte   $1C                             ; 9EAC 1C                       .
        .byte   $1C                             ; 9EAD 1C                       .
        .byte   $1C                             ; 9EAE 1C                       .
        .byte   $1C                             ; 9EAF 1C                       .
        .byte   $1C                             ; 9EB0 1C                       .
        .byte   $1C                             ; 9EB1 1C                       .
        .byte   $1C                             ; 9EB2 1C                       .
        .byte   $1C                             ; 9EB3 1C                       .
        .byte   $1C                             ; 9EB4 1C                       .
        .byte   $1C                             ; 9EB5 1C                       .
        .byte   $1C                             ; 9EB6 1C                       .
        .byte   $1C                             ; 9EB7 1C                       .
        .byte   $1C                             ; 9EB8 1C                       .
        .byte   $1C                             ; 9EB9 1C                       .
        .byte   $1C                             ; 9EBA 1C                       .
        .byte   $1C                             ; 9EBB 1C                       .
        .byte   $1C                             ; 9EBC 1C                       .
        .byte   $1C                             ; 9EBD 1C                       .
        .byte   $1C                             ; 9EBE 1C                       .
        .byte   $1C                             ; 9EBF 1C                       .
        .byte   $1C                             ; 9EC0 1C                       .
        .byte   $1C                             ; 9EC1 1C                       .
        .byte   $1C                             ; 9EC2 1C                       .
        .byte   $1C                             ; 9EC3 1C                       .
        .byte   $1C                             ; 9EC4 1C                       .
        .byte   $1C                             ; 9EC5 1C                       .
        .byte   $1C                             ; 9EC6 1C                       .
        .byte   $1C                             ; 9EC7 1C                       .
        .byte   $1C                             ; 9EC8 1C                       .
        .byte   $1C                             ; 9EC9 1C                       .
        .byte   $1C                             ; 9ECA 1C                       .
        .byte   $1C                             ; 9ECB 1C                       .
        .byte   $1C                             ; 9ECC 1C                       .
        .byte   $1C                             ; 9ECD 1C                       .
        .byte   $1C                             ; 9ECE 1C                       .
        .byte   $1C                             ; 9ECF 1C                       .
        .byte   $1C                             ; 9ED0 1C                       .
        .byte   $1C                             ; 9ED1 1C                       .
        .byte   $1C                             ; 9ED2 1C                       .
        .byte   $1C                             ; 9ED3 1C                       .
        .byte   $1C                             ; 9ED4 1C                       .
        .byte   $1C                             ; 9ED5 1C                       .
        .byte   $1C                             ; 9ED6 1C                       .
        .byte   $1C                             ; 9ED7 1C                       .
        .byte   $1C                             ; 9ED8 1C                       .
        .byte   $1C                             ; 9ED9 1C                       .
        .byte   $1C                             ; 9EDA 1C                       .
        .byte   $1C                             ; 9EDB 1C                       .
        .byte   $1C                             ; 9EDC 1C                       .
        .byte   $1C                             ; 9EDD 1C                       .
        .byte   $1C                             ; 9EDE 1C                       .
        .byte   $1C                             ; 9EDF 1C                       .
        .byte   $1C                             ; 9EE0 1C                       .
        .byte   $1C                             ; 9EE1 1C                       .
        .byte   $1C                             ; 9EE2 1C                       .
        .byte   $1C                             ; 9EE3 1C                       .
        .byte   $1C                             ; 9EE4 1C                       .
        .byte   $1C                             ; 9EE5 1C                       .
        .byte   $1C                             ; 9EE6 1C                       .
        .byte   $1C                             ; 9EE7 1C                       .
        .byte   $1C                             ; 9EE8 1C                       .
        .byte   $1C                             ; 9EE9 1C                       .
        .byte   $1C                             ; 9EEA 1C                       .
        .byte   $1C                             ; 9EEB 1C                       .
        .byte   $1C                             ; 9EEC 1C                       .
        .byte   $1C                             ; 9EED 1C                       .
        .byte   $1C                             ; 9EEE 1C                       .
        .byte   $1C                             ; 9EEF 1C                       .
        .byte   $1C                             ; 9EF0 1C                       .
        .byte   $1C                             ; 9EF1 1C                       .
        .byte   $1C                             ; 9EF2 1C                       .
        .byte   $1C                             ; 9EF3 1C                       .
        .byte   $1C                             ; 9EF4 1C                       .
        .byte   $1C                             ; 9EF5 1C                       .
        .byte   $1C                             ; 9EF6 1C                       .
        .byte   $1C                             ; 9EF7 1C                       .
        .byte   $1C                             ; 9EF8 1C                       .
        .byte   $1C                             ; 9EF9 1C                       .
        .byte   $1C                             ; 9EFA 1C                       .
        .byte   $1C                             ; 9EFB 1C                       .
        .byte   $1C                             ; 9EFC 1C                       .
        .byte   $1C                             ; 9EFD 1C                       .
        .byte   $1C                             ; 9EFE 1C                       .
        .byte   $1C                             ; 9EFF 1C                       .
        .byte   $1C                             ; 9F00 1C                       .
        .byte   $1C                             ; 9F01 1C                       .
        .byte   $1C                             ; 9F02 1C                       .
        .byte   $1C                             ; 9F03 1C                       .
        .byte   $1C                             ; 9F04 1C                       .
        .byte   $1C                             ; 9F05 1C                       .
        .byte   $1C                             ; 9F06 1C                       .
        .byte   $1C                             ; 9F07 1C                       .
        .byte   $1C                             ; 9F08 1C                       .
        .byte   $1C                             ; 9F09 1C                       .
        .byte   $1C                             ; 9F0A 1C                       .
        .byte   $1C                             ; 9F0B 1C                       .
        .byte   $1C                             ; 9F0C 1C                       .
        .byte   $1C                             ; 9F0D 1C                       .
L9F0E:  .byte   $1C                             ; 9F0E 1C                       .
        .byte   $1C                             ; 9F0F 1C                       .
        .byte   $1C                             ; 9F10 1C                       .
        .byte   $1C                             ; 9F11 1C                       .
        .byte   $1C                             ; 9F12 1C                       .
        .byte   $1C                             ; 9F13 1C                       .
        .byte   $1C                             ; 9F14 1C                       .
        .byte   $1C                             ; 9F15 1C                       .
        .byte   $1C                             ; 9F16 1C                       .
        .byte   $1C                             ; 9F17 1C                       .
        .byte   $1C                             ; 9F18 1C                       .
        .byte   $1C                             ; 9F19 1C                       .
        .byte   $1C                             ; 9F1A 1C                       .
        .byte   $1C                             ; 9F1B 1C                       .
        .byte   $1C                             ; 9F1C 1C                       .
        .byte   $1C                             ; 9F1D 1C                       .
        .byte   $1C                             ; 9F1E 1C                       .
        .byte   $1C                             ; 9F1F 1C                       .
        .byte   $1C                             ; 9F20 1C                       .
        .byte   $1C                             ; 9F21 1C                       .
        .byte   $1C                             ; 9F22 1C                       .
        .byte   $1C                             ; 9F23 1C                       .
        .byte   $1C                             ; 9F24 1C                       .
        .byte   $1C                             ; 9F25 1C                       .
        .byte   $1C                             ; 9F26 1C                       .
        .byte   $1C                             ; 9F27 1C                       .
        .byte   $1C                             ; 9F28 1C                       .
        .byte   $1C                             ; 9F29 1C                       .
        .byte   $1C                             ; 9F2A 1C                       .
        .byte   $1C                             ; 9F2B 1C                       .
        .byte   $1C                             ; 9F2C 1C                       .
        .byte   $1C                             ; 9F2D 1C                       .
        .byte   $1C                             ; 9F2E 1C                       .
        .byte   $1C                             ; 9F2F 1C                       .
        .byte   $1C                             ; 9F30 1C                       .
        .byte   $1C                             ; 9F31 1C                       .
        .byte   $1C                             ; 9F32 1C                       .
        .byte   $1C                             ; 9F33 1C                       .
        .byte   $1C                             ; 9F34 1C                       .
        .byte   $1C                             ; 9F35 1C                       .
        .byte   $1C                             ; 9F36 1C                       .
        .byte   $1C                             ; 9F37 1C                       .
        .byte   $1C                             ; 9F38 1C                       .
        .byte   $1C                             ; 9F39 1C                       .
        .byte   $1C                             ; 9F3A 1C                       .
        .byte   $1C                             ; 9F3B 1C                       .
        .byte   $1C                             ; 9F3C 1C                       .
        .byte   $1C                             ; 9F3D 1C                       .
        .byte   $1C                             ; 9F3E 1C                       .
        .byte   $1C                             ; 9F3F 1C                       .
        .byte   $1C                             ; 9F40 1C                       .
        .byte   $1C                             ; 9F41 1C                       .
        .byte   $1C                             ; 9F42 1C                       .
        .byte   $1C                             ; 9F43 1C                       .
        .byte   $1C                             ; 9F44 1C                       .
        .byte   $1C                             ; 9F45 1C                       .
        .byte   $1C                             ; 9F46 1C                       .
        .byte   $1C                             ; 9F47 1C                       .
        .byte   $1C                             ; 9F48 1C                       .
        .byte   $1C                             ; 9F49 1C                       .
        .byte   $1C                             ; 9F4A 1C                       .
        .byte   $1C                             ; 9F4B 1C                       .
        .byte   $1C                             ; 9F4C 1C                       .
        .byte   $1C                             ; 9F4D 1C                       .
        .byte   $1C                             ; 9F4E 1C                       .
        .byte   $1C                             ; 9F4F 1C                       .
        .byte   $1C                             ; 9F50 1C                       .
        .byte   $1C                             ; 9F51 1C                       .
        .byte   $1C                             ; 9F52 1C                       .
        .byte   $1C                             ; 9F53 1C                       .
        .byte   $1C                             ; 9F54 1C                       .
        .byte   $1C                             ; 9F55 1C                       .
        .byte   $1C                             ; 9F56 1C                       .
        .byte   $1C                             ; 9F57 1C                       .
        .byte   $1C                             ; 9F58 1C                       .
        .byte   $1C                             ; 9F59 1C                       .
        .byte   $1C                             ; 9F5A 1C                       .
        .byte   $1C                             ; 9F5B 1C                       .
        .byte   $1C                             ; 9F5C 1C                       .
        .byte   $1C                             ; 9F5D 1C                       .
        .byte   $1C                             ; 9F5E 1C                       .
        .byte   $1C                             ; 9F5F 1C                       .
        .byte   $1C                             ; 9F60 1C                       .
        .byte   $1C                             ; 9F61 1C                       .
        .byte   $1C                             ; 9F62 1C                       .
        .byte   $1C                             ; 9F63 1C                       .
        .byte   $1C                             ; 9F64 1C                       .
        .byte   $1C                             ; 9F65 1C                       .
        .byte   $1C                             ; 9F66 1C                       .
        .byte   $1C                             ; 9F67 1C                       .
        .byte   $1C                             ; 9F68 1C                       .
        .byte   $1C                             ; 9F69 1C                       .
        .byte   $1C                             ; 9F6A 1C                       .
        .byte   $1C                             ; 9F6B 1C                       .
        .byte   $1C                             ; 9F6C 1C                       .
        .byte   $1C                             ; 9F6D 1C                       .
        .byte   $1C                             ; 9F6E 1C                       .
        .byte   $1C                             ; 9F6F 1C                       .
        .byte   $1C                             ; 9F70 1C                       .
        .byte   $1C                             ; 9F71 1C                       .
        .byte   $1C                             ; 9F72 1C                       .
        .byte   $1C                             ; 9F73 1C                       .
        .byte   $1C                             ; 9F74 1C                       .
        .byte   $1C                             ; 9F75 1C                       .
        .byte   $1C                             ; 9F76 1C                       .
        .byte   $1C                             ; 9F77 1C                       .
        .byte   $1C                             ; 9F78 1C                       .
        .byte   $1C                             ; 9F79 1C                       .
        .byte   $1C                             ; 9F7A 1C                       .
        .byte   $1C                             ; 9F7B 1C                       .
        .byte   $1C                             ; 9F7C 1C                       .
        .byte   $1C                             ; 9F7D 1C                       .
        .byte   $1C                             ; 9F7E 1C                       .
        .byte   $1C                             ; 9F7F 1C                       .
        .byte   $1C                             ; 9F80 1C                       .
        .byte   $1C                             ; 9F81 1C                       .
        .byte   $1C                             ; 9F82 1C                       .
        .byte   $1C                             ; 9F83 1C                       .
        .byte   $1C                             ; 9F84 1C                       .
        .byte   $1C                             ; 9F85 1C                       .
        .byte   $1C                             ; 9F86 1C                       .
        .byte   $1C                             ; 9F87 1C                       .
        .byte   $1C                             ; 9F88 1C                       .
        .byte   $1C                             ; 9F89 1C                       .
        .byte   $1C                             ; 9F8A 1C                       .
        .byte   $1C                             ; 9F8B 1C                       .
        .byte   $1C                             ; 9F8C 1C                       .
        .byte   $1C                             ; 9F8D 1C                       .
        .byte   $1C                             ; 9F8E 1C                       .
        .byte   $1C                             ; 9F8F 1C                       .
        .byte   $1C                             ; 9F90 1C                       .
        .byte   $1C                             ; 9F91 1C                       .
        .byte   $1C                             ; 9F92 1C                       .
        .byte   $1C                             ; 9F93 1C                       .
        .byte   $1C                             ; 9F94 1C                       .
        .byte   $1C                             ; 9F95 1C                       .
        .byte   $1C                             ; 9F96 1C                       .
        .byte   $1C                             ; 9F97 1C                       .
        .byte   $1C                             ; 9F98 1C                       .
        .byte   $1C                             ; 9F99 1C                       .
        .byte   $1C                             ; 9F9A 1C                       .
        .byte   $1C                             ; 9F9B 1C                       .
        .byte   $1C                             ; 9F9C 1C                       .
        .byte   $1C                             ; 9F9D 1C                       .
        .byte   $1C                             ; 9F9E 1C                       .
L9F9F:  .byte   $1C                             ; 9F9F 1C                       .
        .byte   $1C                             ; 9FA0 1C                       .
        .byte   $1C                             ; 9FA1 1C                       .
        .byte   $1C                             ; 9FA2 1C                       .
        .byte   $1C                             ; 9FA3 1C                       .
        .byte   $1C                             ; 9FA4 1C                       .
        .byte   $1C                             ; 9FA5 1C                       .
        .byte   $1C                             ; 9FA6 1C                       .
        .byte   $1C                             ; 9FA7 1C                       .
        .byte   $1C                             ; 9FA8 1C                       .
        .byte   $1C                             ; 9FA9 1C                       .
        .byte   $1C                             ; 9FAA 1C                       .
        .byte   $1C                             ; 9FAB 1C                       .
        .byte   $1C                             ; 9FAC 1C                       .
        .byte   $1C                             ; 9FAD 1C                       .
        .byte   $1C                             ; 9FAE 1C                       .
        .byte   $1C                             ; 9FAF 1C                       .
        .byte   $1C                             ; 9FB0 1C                       .
        .byte   $1C                             ; 9FB1 1C                       .
        .byte   $1C                             ; 9FB2 1C                       .
        .byte   $1C                             ; 9FB3 1C                       .
        .byte   $1C                             ; 9FB4 1C                       .
        .byte   $1C                             ; 9FB5 1C                       .
        .byte   $1C                             ; 9FB6 1C                       .
        .byte   $1C                             ; 9FB7 1C                       .
        .byte   $1C                             ; 9FB8 1C                       .
        .byte   $1C                             ; 9FB9 1C                       .
        .byte   $1C                             ; 9FBA 1C                       .
        .byte   $1C                             ; 9FBB 1C                       .
        .byte   $1C                             ; 9FBC 1C                       .
        .byte   $1C                             ; 9FBD 1C                       .
        .byte   $1C                             ; 9FBE 1C                       .
        .byte   $1C                             ; 9FBF 1C                       .
        .byte   $1C                             ; 9FC0 1C                       .
        .byte   $1C                             ; 9FC1 1C                       .
        .byte   $1C                             ; 9FC2 1C                       .
        .byte   $1C                             ; 9FC3 1C                       .
        .byte   $1C                             ; 9FC4 1C                       .
        .byte   $1C                             ; 9FC5 1C                       .
        .byte   $1C                             ; 9FC6 1C                       .
        .byte   $1C                             ; 9FC7 1C                       .
        .byte   $1C                             ; 9FC8 1C                       .
        .byte   $1C                             ; 9FC9 1C                       .
        .byte   $1C                             ; 9FCA 1C                       .
        .byte   $1C                             ; 9FCB 1C                       .
        .byte   $1C                             ; 9FCC 1C                       .
        .byte   $1C                             ; 9FCD 1C                       .
        .byte   $1C                             ; 9FCE 1C                       .
        .byte   $1C                             ; 9FCF 1C                       .
        .byte   $1C                             ; 9FD0 1C                       .
        .byte   $1C                             ; 9FD1 1C                       .
        .byte   $1C                             ; 9FD2 1C                       .
        .byte   $1C                             ; 9FD3 1C                       .
        .byte   $1C                             ; 9FD4 1C                       .
        .byte   $1C                             ; 9FD5 1C                       .
        .byte   $1C                             ; 9FD6 1C                       .
        .byte   $1C                             ; 9FD7 1C                       .
        .byte   $1C                             ; 9FD8 1C                       .
        .byte   $1C                             ; 9FD9 1C                       .
        .byte   $1C                             ; 9FDA 1C                       .
        .byte   $1C                             ; 9FDB 1C                       .
        .byte   $1C                             ; 9FDC 1C                       .
L9FDD:  .byte   $1C                             ; 9FDD 1C                       .
        .byte   $1C                             ; 9FDE 1C                       .
        .byte   $1C                             ; 9FDF 1C                       .
        .byte   $1C                             ; 9FE0 1C                       .
        .byte   $1C                             ; 9FE1 1C                       .
        .byte   $1C                             ; 9FE2 1C                       .
        .byte   $1C                             ; 9FE3 1C                       .
        .byte   $1C                             ; 9FE4 1C                       .
        .byte   $1C                             ; 9FE5 1C                       .
        .byte   $1C                             ; 9FE6 1C                       .
        .byte   $1C                             ; 9FE7 1C                       .
        .byte   $1C                             ; 9FE8 1C                       .
        .byte   $1C                             ; 9FE9 1C                       .
        .byte   $1C                             ; 9FEA 1C                       .
        .byte   $1C                             ; 9FEB 1C                       .
        .byte   $1C                             ; 9FEC 1C                       .
        .byte   $1C                             ; 9FED 1C                       .
        .byte   $1C                             ; 9FEE 1C                       .
        .byte   $1C                             ; 9FEF 1C                       .
        .byte   $1C                             ; 9FF0 1C                       .
        .byte   $1C                             ; 9FF1 1C                       .
        .byte   $1C                             ; 9FF2 1C                       .
        .byte   $1C                             ; 9FF3 1C                       .
        .byte   $1C                             ; 9FF4 1C                       .
        .byte   $1C                             ; 9FF5 1C                       .
        .byte   $1C                             ; 9FF6 1C                       .
        .byte   $1C                             ; 9FF7 1C                       .
        .byte   $1C                             ; 9FF8 1C                       .
        .byte   $1C                             ; 9FF9 1C                       .
        .byte   $1C                             ; 9FFA 1C                       .
        .byte   $1C                             ; 9FFB 1C                       .
        .byte   $1C                             ; 9FFC 1C                       .
        .byte   $1C                             ; 9FFD 1C                       .
        .byte   $1C                             ; 9FFE 1C                       .
        .byte   $1C                             ; 9FFF 1C                       .
