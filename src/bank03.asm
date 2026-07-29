.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK03"

; =============================================================================
; BANK $03 (mapped at $8000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
; =============================================================================
L0000           := $0000
L000E           := $000E
L0020           := $0020
L0021           := $0021
L0023           := $0023
L0030           := $0030
L004D           := $004D
L0070           := $0070
L00B0           := $00B0
L0616           := $0616
L084D           := $084D
L086B           := $086B
L1010           := $1010
L106D           := $106D
L107C           := $107C
L1323           := $1323
L163A           := $163A
L1A19           := $1A19
L1B2B           := $1B2B
L201F           := $201F
L211E           := $211E
L2121           := $2121
L2122           := $2122
L2220           := $2220
L24B0           := $24B0
L2620           := $2620
L2818           := $2818
L282A           := $282A
L3B4D           := $3B4D
L4140           := $4140
L4A49           := $4A49
L6040           := $6040
L6123           := $6123
L6D0E           := $6D0E
L6E08           := $6E08
L7040           := $7040
L7B1F           := $7B1F
L7B21           := $7B21
LA080           := $A080
LA60E           := $A60E
LB000           := $B000
LE7B7           := $E7B7
LE8E6           := $E8E6
LE90C           := $E90C
LE94A           := $E94A
LE968           := $E968
LE9E1           := $E9E1
LEA34           := $EA34
LEA65           := $EA65
LEA86           := $EA86
LEA98           := $EA98
LEAA4           := $EAA4
LEAE9           := $EAE9
LEC5D           := $EC5D
LECC2           := $ECC2
LEF87           := $EF87
LEFF8           := $EFF8
LF16F           := $F16F
LF2C4           := $F2C4
LF470           := $F470
; ----------------------------------------------------------------------------
L8000:  lda     $69                             ; 8000 A5 69                    .i
        cmp     #$04                            ; 8002 C9 04                    ..
        bne     L801C                           ; 8004 D0 16                    ..
        lda     $0438,x                         ; 8006 BD 38 04                 .8.
        pha                                     ; 8009 48                       H
        jsr     LF2C4                           ; 800A 20 C4 F2                  ..
        pla                                     ; 800D 68                       h
        sta     $0438,x                         ; 800E 9D 38 04                 .8.
        lda     #$47                            ; 8011 A9 47                    .G
        jsr     LEA98                           ; 8013 20 98 EA                  ..
        lda     #$B3                            ; 8016 A9 B3                    ..
        sta     $0300,x                         ; 8018 9D 00 03                 ...
        rts                                     ; 801B 60                       `

; ----------------------------------------------------------------------------
L801C:  lda     $0528,x                         ; 801C BD 28 05                 .(.
        and     #$FB                            ; 801F 29 FB                    ).
        sta     $0528,x                         ; 8021 9D 28 05                 .(.
        ldy     L0030                           ; 8024 A4 30                    .0
        bne     L8075                           ; 8026 D0 4D                    .M
        sty     $33                             ; 8028 84 33                    .3
        sty     $34                             ; 802A 84 34                    .4
        lda     #$04                            ; 802C A9 04                    ..
        sta     $69                             ; 802E 85 69                    .i
        lda     #$01                            ; 8030 A9 01                    ..
        jsr     LEAE9                           ; 8032 20 E9 EA                  ..
        lda     $0528                           ; 8035 AD 28 05                 .(.
        ora     #$20                            ; 8038 09 20                    . 
        sta     $0528                           ; 803A 8D 28 05                 .(.
        lda     L00B0                           ; 803D A5 B0                    ..
        sta     $0468                           ; 803F 8D 68 04                 .h.
        lda     #$FF                            ; 8042 A9 FF                    ..
        sta     $0480                           ; 8044 8D 80 04                 ...
        lda     #$11                            ; 8047 A9 11                    ..
        sta     L0030                           ; 8049 85 30                    .0
        lda     #$5A                            ; 804B A9 5A                    .Z
        sta     $0588,x                         ; 804D 9D 88 05                 ...
        lda     #$A0                            ; 8050 A9 A0                    ..
        sta     $05A0,x                         ; 8052 9D A0 05                 ...
        lda     #$2F                            ; 8055 A9 2F                    ./
        jmp     LEC5D                           ; 8057 4C 5D EC                 L].

; ----------------------------------------------------------------------------
        lda     $0330                           ; 805A AD 30 03                 .0.
        cmp     #$84                            ; 805D C9 84                    ..
        bne     L8075                           ; 805F D0 14                    ..
        lda     #$3C                            ; 8061 A9 3C                    .<
        sta     $0468,x                         ; 8063 9D 68 04                 .h.
        lda     #$76                            ; 8066 A9 76                    .v
        sta     $0588,x                         ; 8068 9D 88 05                 ...
        lda     #$A0                            ; 806B A9 A0                    ..
        sta     $05A0,x                         ; 806D 9D A0 05                 ...
        lda     #$A0                            ; 8070 A9 A0                    ..
        jsr     LEA98                           ; 8072 20 98 EA                  ..
L8075:  rts                                     ; 8075 60                       `

; ----------------------------------------------------------------------------
        lda     $0468,x                         ; 8076 BD 68 04                 .h.
        beq     L808C                           ; 8079 F0 11                    ..
        dec     $0468,x                         ; 807B DE 68 04                 .h.
L807E:  bne     L80EF                           ; 807E D0 6F                    .o
        lda     #$A1                            ; 8080 A9 A1                    ..
        jsr     LEA98                           ; 8082 20 98 EA                  ..
        ldy     #$00                            ; 8085 A0 00                    ..
        lda     #$0D                            ; 8087 A9 0D                    ..
        jsr     LEAE9                           ; 8089 20 E9 EA                  ..
L808C:  lda     $0540,x                         ; 808C BD 40 05                 .@.
        bne     L80EF                           ; 808F D0 5E                    .^
        jsr     LE90C                           ; 8091 20 0C E9                  ..
        lda     #$AC                            ; 8094 A9 AC                    ..
        cmp     $0330,x                         ; 8096 DD 30 03                 .0.
        bcc     L80EF                           ; 8099 90 54                    .T
        .byte   $9D                             ; 809B 9D                       .
        .byte   $30                             ; 809C 30                       0
L809D:  .byte   $03                             ; 809D 03                       .
        lda     #$A0                            ; 809E A9 A0                    ..
        jsr     LEA98                           ; 80A0 20 98 EA                  ..
        lda     #$B2                            ; 80A3 A9 B2                    ..
        sta     $0588,x                         ; 80A5 9D 88 05                 ...
        lda     #$A0                            ; 80A8 A9 A0                    ..
        sta     $05A0,x                         ; 80AA 9D A0 05                 ...
        lda     #$1C                            ; 80AD A9 1C                    ..
        sta     $0468,x                         ; 80AF 9D 68 04                 .h.
        lda     $0468,x                         ; 80B2 BD 68 04                 .h.
        bne     L80EC                           ; 80B5 D0 35                    .5
        sta     $0570,x                         ; 80B7 9D 70 05                 .p.
        jsr     LF16F                           ; 80BA 20 6F F1                  o.
        bcs     L80EC                           ; 80BD B0 2D                    .-
        lda     #$A6                            ; 80BF A9 A6                    ..
        jsr     LEAA4                           ; 80C1 20 A4 EA                  ..
        lda     #$A3                            ; 80C4 A9 A3                    ..
        sta     $0300,y                         ; 80C6 99 00 03                 ...
        lda     #$A4                            ; 80C9 A9 A4                    ..
        sta     $0330,y                         ; 80CB 99 30 03                 .0.
        lda     #$00                            ; 80CE A9 00                    ..
        sta     $03A8,y                         ; 80D0 99 A8 03                 ...
        lda     #$04                            ; 80D3 A9 04                    ..
        sta     $03C0,y                         ; 80D5 99 C0 03                 ...
        lda     #$02                            ; 80D8 A9 02                    ..
        sta     $0420,y                         ; 80DA 99 20 04                 . .
        lda     #$28                            ; 80DD A9 28                    .(
        sta     $0468,x                         ; 80DF 9D 68 04                 .h.
        lda     #$F0                            ; 80E2 A9 F0                    ..
        sta     $0588,x                         ; 80E4 9D 88 05                 ...
        lda     #$A0                            ; 80E7 A9 A0                    ..
        sta     $05A0,x                         ; 80E9 9D A0 05                 ...
L80EC:  dec     $0468,x                         ; 80EC DE 68 04                 .h.
L80EF:  rts                                     ; 80EF 60                       `

; ----------------------------------------------------------------------------
        lda     $0468,x                         ; 80F0 BD 68 04                 .h.
        bne     L80EC                           ; 80F3 D0 F7                    ..
        lda     #$A1                            ; 80F5 A9 A1                    ..
        cmp     $0558,x                         ; 80F7 DD 58 05                 .X.
        beq     L80FF                           ; 80FA F0 03                    ..
        jsr     LEA98                           ; 80FC 20 98 EA                  ..
L80FF:  lda     $0540,x                         ; 80FF BD 40 05                 .@.
        bne     L80EF                           ; 8102 D0 EB                    ..
        jsr     LE90C                           ; 8104 20 0C E9                  ..
        lda     #$A4                            ; 8107 A9 A4                    ..
        cmp     $0330,x                         ; 8109 DD 30 03                 .0.
        bcc     L80EF                           ; 810C 90 E1                    ..
        sta     $0330,x                         ; 810E 9D 30 03                 .0.
        lda     #$A0                            ; 8111 A9 A0                    ..
        jsr     LEA98                           ; 8113 20 98 EA                  ..
        lda     #$26                            ; 8116 A9 26                    .&
        sta     $0588,x                         ; 8118 9D 88 05                 ...
        lda     #$A1                            ; 811B A9 A1                    ..
        sta     $05A0,x                         ; 811D 9D A0 05                 ...
L8120:  lda     #$3C                            ; 8120 A9 3C                    .<
        sta     $0468,x                         ; 8122 9D 68 04                 .h.
        rts                                     ; 8125 60                       `

; ----------------------------------------------------------------------------
        lda     #$30                            ; 8126 A9 30                    .0
        jsr     LEC5D                           ; 8128 20 5D EC                  ].
        lda     #$37                            ; 812B A9 37                    .7
        sta     $0588,x                         ; 812D 9D 88 05                 ...
        lda     #$A1                            ; 8130 A9 A1                    ..
        sta     $05A0,x                         ; 8132 9D A0 05                 ...
        bne     L8120                           ; 8135 D0 E9                    ..
        lda     $0468,x                         ; 8137 BD 68 04                 .h.
        bne     L80EC                           ; 813A D0 B0                    ..
        lda     #$9F                            ; 813C A9 9F                    ..
        jsr     LEA98                           ; 813E 20 98 EA                  ..
        ldy     #$00                            ; 8141 A0 00                    ..
        lda     #$1F                            ; 8143 A9 1F                    ..
        jsr     LEAE9                           ; 8145 20 E9 EA                  ..
        lda     #$57                            ; 8148 A9 57                    .W
        sta     $0588,x                         ; 814A 9D 88 05                 ...
        lda     #$A1                            ; 814D A9 A1                    ..
        sta     $05A0,x                         ; 814F 9D A0 05                 ...
        lda     #$E1                            ; 8152 A9 E1                    ..
        sta     $0468,x                         ; 8154 9D 68 04                 .h.
        lda     $0468,x                         ; 8157 BD 68 04                 .h.
        bne     L80EC                           ; 815A D0 90                    ..
        jsr     LF16F                           ; 815C 20 6F F1                  o.
        bcs     L80EF                           ; 815F B0 8E                    ..
        lda     #$A2                            ; 8161 A9 A2                    ..
        jsr     LEAA4                           ; 8163 20 A4 EA                  ..
        lda     $0528,y                         ; 8166 B9 28 05                 .(.
        ora     #$20                            ; 8169 09 20                    . 
        sta     $0528,y                         ; 816B 99 28 05                 .(.
        lda     #$A4                            ; 816E A9 A4                    ..
        sta     $0300,y                         ; 8170 99 00 03                 ...
        lda     #$00                            ; 8173 A9 00                    ..
        sta     $0378,y                         ; 8175 99 78 03                 .x.
        lda     #$24                            ; 8178 A9 24                    .$
        sta     $0330,y                         ; 817A 99 30 03                 .0.
        txa                                     ; 817D 8A                       .
        sta     $0468,y                         ; 817E 99 68 04                 .h.
        jsr     LEA34                           ; 8181 20 34 EA                  4.
        tya                                     ; 8184 98                       .
        sta     $0480,x                         ; 8185 9D 80 04                 ...
        lda     #$92                            ; 8188 A9 92                    ..
        sta     $0588,x                         ; 818A 9D 88 05                 ...
        lda     #$A1                            ; 818D A9 A1                    ..
        sta     $05A0,x                         ; 818F 9D A0 05                 ...
        ldy     $0480,x                         ; 8192 BC 80 04                 ...
        lda     $0558,y                         ; 8195 B9 58 05                 .X.
        cmp     #$A4                            ; 8198 C9 A4                    ..
        bne     L8215                           ; 819A D0 79                    .y
        lda     #$A1                            ; 819C A9 A1                    ..
        jsr     LEA98                           ; 819E 20 98 EA                  ..
        lda     #$AB                            ; 81A1 A9 AB                    ..
        sta     $0588,x                         ; 81A3 9D 88 05                 ...
        lda     #$A1                            ; 81A6 A9 A1                    ..
        sta     $05A0,x                         ; 81A8 9D A0 05                 ...
        lda     $0540,x                         ; 81AB BD 40 05                 .@.
        bne     L8215                           ; 81AE D0 65                    .e
        jsr     LE8E6                           ; 81B0 20 E6 E8                  ..
        lda     $0528,x                         ; 81B3 BD 28 05                 .(.
        and     #$DF                            ; 81B6 29 DF                    ).
        sta     $0528,x                         ; 81B8 9D 28 05                 .(.
        lda     #$D4                            ; 81BB A9 D4                    ..
        cmp     $0330,x                         ; 81BD DD 30 03                 .0.
        bcs     L8215                           ; 81C0 B0 53                    .S
        sta     $0330,x                         ; 81C2 9D 30 03                 .0.
        lda     #$A0                            ; 81C5 A9 A0                    ..
        jsr     LEA98                           ; 81C7 20 98 EA                  ..
        lda     #$D9                            ; 81CA A9 D9                    ..
        sta     $0588,x                         ; 81CC 9D 88 05                 ...
        lda     #$A1                            ; 81CF A9 A1                    ..
        sta     $05A0,x                         ; 81D1 9D A0 05                 ...
        lda     #$1E                            ; 81D4 A9 1E                    ..
        sta     $0468,x                         ; 81D6 9D 68 04                 .h.
        jsr     LF16F                           ; 81D9 20 6F F1                  o.
        bcs     L8215                           ; 81DC B0 37                    .7
        dec     $0468,x                         ; 81DE DE 68 04                 .h.
        bne     L8215                           ; 81E1 D0 32                    .2
        lda     #$A6                            ; 81E3 A9 A6                    ..
        jsr     LEAA4                           ; 81E5 20 A4 EA                  ..
        lda     #$A3                            ; 81E8 A9 A3                    ..
        sta     $0300,y                         ; 81EA 99 00 03                 ...
        lda     #$C4                            ; 81ED A9 C4                    ..
        sta     $0330,y                         ; 81EF 99 30 03                 .0.
        lda     #$00                            ; 81F2 A9 00                    ..
        sta     $03A8,y                         ; 81F4 99 A8 03                 ...
        lda     #$04                            ; 81F7 A9 04                    ..
        sta     $03C0,y                         ; 81F9 99 C0 03                 ...
        lda     #$86                            ; 81FC A9 86                    ..
        sta     $03D8,y                         ; 81FE 99 D8 03                 ...
        lda     #$01                            ; 8201 A9 01                    ..
        sta     $03F0,y                         ; 8203 99 F0 03                 ...
        lda     #$0A                            ; 8206 A9 0A                    ..
        sta     $0420,y                         ; 8208 99 20 04                 . .
        lda     #$16                            ; 820B A9 16                    ..
        sta     $0588,x                         ; 820D 9D 88 05                 ...
        lda     #$A2                            ; 8210 A9 A2                    ..
        sta     $05A0,x                         ; 8212 9D A0 05                 ...
L8215:  rts                                     ; 8215 60                       `

; ----------------------------------------------------------------------------
        lda     $0570,x                         ; 8216 BD 70 05                 .p.
        ora     $0540,x                         ; 8219 1D 40 05                 .@.
        bne     L825F                           ; 821C D0 41                    .A
L821E:  lda     #$9E                            ; 821E A9 9E                    ..
L8220:  jsr     LEA98                           ; 8220 20 98 EA                  ..
        lda     #$15                            ; 8223 A9 15                    ..
        sta     $0588,x                         ; 8225 9D 88 05                 ...
        lda     #$A2                            ; 8228 A9 A2                    ..
        sta     $05A0,x                         ; 822A 9D A0 05                 ...
        rts                                     ; 822D 60                       `

; ----------------------------------------------------------------------------
        dec     $0468,x                         ; 822E DE 68 04                 .h.
        bne     L8215                           ; 8231 D0 E2                    ..
        ldy     $0480,x                         ; 8233 BC 80 04                 ...
        lda     $A260,y                         ; 8236 B9 60 A2                 .`.
        jsr     LEA98                           ; 8239 20 98 EA                  ..
        lda     $A264,y                         ; 823C B9 64 A2                 .d.
        sta     $0300,x                         ; 823F 9D 00 03                 ...
        lda     $A268,y                         ; 8242 B9 68 A2                 .h.
        sta     $0378,x                         ; 8245 9D 78 03                 .x.
        lda     #$08                            ; 8248 A9 08                    ..
        sta     $0468,x                         ; 824A 9D 68 04                 .h.
        dec     $0480,x                         ; 824D DE 80 04                 ...
        bpl     L825F                           ; 8250 10 0D                    ..
        jsr     LF2C4                           ; 8252 20 C4 F2                  ..
        lda     #$98                            ; 8255 A9 98                    ..
        sta     $0300,x                         ; 8257 9D 00 03                 ...
        lda     #$00                            ; 825A A9 00                    ..
        sta     $0408,x                         ; 825C 9D 08 04                 ...
L825F:  rts                                     ; 825F 60                       `

; ----------------------------------------------------------------------------
        .byte   $47                             ; 8260 47                       G
        .byte   $9E                             ; 8261 9E                       .
        .byte   $47                             ; 8262 47                       G
        .byte   $9E                             ; 8263 9E                       .
        lda     $A2,x                           ; 8264 B5 A2                    ..
        lda     $A2,x                           ; 8266 B5 A2                    ..
        bcs     L821E                           ; 8268 B0 B4                    ..
        bcs     L8220                           ; 826A B0 B4                    ..
        jsr     LEA65                           ; 826C 20 65 EA                  e.
        jsr     LEA86                           ; 826F 20 86 EA                  ..
        lda     $0558,x                         ; 8272 BD 58 05                 .X.
        cmp     #$A5                            ; 8275 C9 A5                    ..
        beq     L8297                           ; 8277 F0 1E                    ..
        jsr     LEF87                           ; 8279 20 87 EF                  ..
        bcs     L82DE                           ; 827C B0 60                    .`
        jsr     LF2C4                           ; 827E 20 C4 F2                  ..
        lda     #$1C                            ; 8281 A9 1C                    ..
        jsr     LEC5D                           ; 8283 20 5D EC                  ].
        lda     #$11                            ; 8286 A9 11                    ..
        cmp     $0558                           ; 8288 CD 58 05                 .X.
        beq     L8296                           ; 828B F0 09                    ..
        ldy     #$00                            ; 828D A0 00                    ..
        jsr     LEAE9                           ; 828F 20 E9 EA                  ..
        lda     #$81                            ; 8292 A9 81                    ..
        sta     L00B0                           ; 8294 85 B0                    ..
L8296:  rts                                     ; 8296 60                       `

; ----------------------------------------------------------------------------
L8297:  lda     $0330,x                         ; 8297 BD 30 03                 .0.
        cmp     #$D0                            ; 829A C9 D0                    ..
        bcc     L82DE                           ; 829C 90 40                    .@
        jsr     LF16F                           ; 829E 20 6F F1                  o.
        bcs     L82DE                           ; 82A1 B0 3B                    .;
        lda     #$42                            ; 82A3 A9 42                    .B
        jsr     LEAA4                           ; 82A5 20 A4 EA                  ..
        lda     #$2F                            ; 82A8 A9 2F                    ./
        sta     $0300,y                         ; 82AA 99 00 03                 ...
        lda     #$00                            ; 82AD A9 00                    ..
        sta     $0408,y                         ; 82AF 99 08 04                 ...
        ldy     $0468,x                         ; 82B2 BC 68 04                 .h.
        jsr     LEAE9                           ; 82B5 20 E9 EA                  ..
        lda     #$2E                            ; 82B8 A9 2E                    ..
        sta     $0588,y                         ; 82BA 99 88 05                 ...
        lda     #$A2                            ; 82BD A9 A2                    ..
        sta     $05A0,y                         ; 82BF 99 A0 05                 ...
        lda     #$14                            ; 82C2 A9 14                    ..
        sta     $0468,y                         ; 82C4 99 68 04                 .h.
        lda     #$03                            ; 82C7 A9 03                    ..
        sta     $0480,y                         ; 82C9 99 80 04                 ...
        jsr     LF2C4                           ; 82CC 20 C4 F2                  ..
        ldy     #$00                            ; 82CF A0 00                    ..
        lda     #$01                            ; 82D1 A9 01                    ..
        jsr     LEAE9                           ; 82D3 20 E9 EA                  ..
        lda     $0528                           ; 82D6 AD 28 05                 .(.
        and     #$DF                            ; 82D9 29 DF                    ).
        sta     $0528                           ; 82DB 8D 28 05                 .(.
L82DE:  rts                                     ; 82DE 60                       `

; ----------------------------------------------------------------------------
        jsr     LE968                           ; 82DF 20 68 E9                  h.
        lda     #$84                            ; 82E2 A9 84                    ..
        cmp     $0378,x                         ; 82E4 DD 78 03                 .x.
        bcs     L82DE                           ; 82E7 B0 F5                    ..
        sta     $0378,x                         ; 82E9 9D 78 03                 .x.
        lda     #$A4                            ; 82EC A9 A4                    ..
        jsr     LEA98                           ; 82EE 20 98 EA                  ..
        lda     #$00                            ; 82F1 A9 00                    ..
        sta     $0588,x                         ; 82F3 9D 88 05                 ...
        lda     #$A3                            ; 82F6 A9 A3                    ..
        sta     $05A0,x                         ; 82F8 9D A0 05                 ...
        lda     #$3C                            ; 82FB A9 3C                    .<
        sta     $0480,x                         ; 82FD 9D 80 04                 ...
        ldy     $0468,x                         ; 8300 BC 68 04                 .h.
        lda     $0330,y                         ; 8303 B9 30 03                 .0.
        cmp     #$D4                            ; 8306 C9 D4                    ..
        bne     L82DE                           ; 8308 D0 D4                    ..
        dec     $0480,x                         ; 830A DE 80 04                 ...
        bne     L82DE                           ; 830D D0 CF                    ..
        lda     #$A3                            ; 830F A9 A3                    ..
        jsr     LEA98                           ; 8311 20 98 EA                  ..
        jsr     LF16F                           ; 8314 20 6F F1                  o.
        bcs     L82DE                           ; 8317 B0 C5                    ..
        lda     #$A5                            ; 8319 A9 A5                    ..
        jsr     LEAA4                           ; 831B 20 A4 EA                  ..
        lda     $0468,x                         ; 831E BD 68 04                 .h.
        sta     $0468,y                         ; 8321 99 68 04                 .h.
        txa                                     ; 8324 8A                       .
        sta     $0480,y                         ; 8325 99 80 04                 ...
        lda     #$A3                            ; 8328 A9 A3                    ..
        sta     $0300,y                         ; 832A 99 00 03                 ...
        lda     #$2C                            ; 832D A9 2C                    .,
        sta     $0330,y                         ; 832F 99 30 03                 .0.
        lda     #$00                            ; 8332 A9 00                    ..
        sta     $03A8,y                         ; 8334 99 A8 03                 ...
        lda     #$04                            ; 8337 A9 04                    ..
        sta     $03C0,y                         ; 8339 99 C0 03                 ...
        lda     #$50                            ; 833C A9 50                    .P
        sta     $03D8,y                         ; 833E 99 D8 03                 ...
        lda     #$01                            ; 8341 A9 01                    ..
        sta     $03F0,y                         ; 8343 99 F0 03                 ...
        lda     #$05                            ; 8346 A9 05                    ..
        sta     $0420,y                         ; 8348 99 20 04                 . .
        lda     #$2F                            ; 834B A9 2F                    ./
        sta     $03D8,x                         ; 834D 9D D8 03                 ...
        lda     #$05                            ; 8350 A9 05                    ..
        sta     $03F0,x                         ; 8352 9D F0 03                 ...
        lda     #$5F                            ; 8355 A9 5F                    ._
        sta     $0588,x                         ; 8357 9D 88 05                 ...
        lda     #$A3                            ; 835A A9 A3                    ..
        sta     $05A0,x                         ; 835C 9D A0 05                 ...
        jsr     LE968                           ; 835F 20 68 E9                  h.
        lda     #$84                            ; 8362 A9 84                    ..
        cmp     $0378,x                         ; 8364 DD 78 03                 .x.
        bcs     L838F                           ; 8367 B0 26                    .&
        sta     $0378,x                         ; 8369 9D 78 03                 .x.
        lda     #$90                            ; 836C A9 90                    ..
        sta     $0588,x                         ; 836E 9D 88 05                 ...
        lda     #$A3                            ; 8371 A9 A3                    ..
        sta     $05A0,x                         ; 8373 9D A0 05                 ...
        lda     #$A4                            ; 8376 A9 A4                    ..
        jsr     LEA98                           ; 8378 20 98 EA                  ..
        lda     #$20                            ; 837B A9 20                    . 
        sta     $03A8,x                         ; 837D 9D A8 03                 ...
        lda     #$01                            ; 8380 A9 01                    ..
        sta     $03C0,x                         ; 8382 9D C0 03                 ...
        lda     #$D4                            ; 8385 A9 D4                    ..
        sta     $03D8,x                         ; 8387 9D D8 03                 ...
        lda     #$02                            ; 838A A9 02                    ..
        sta     $03F0,x                         ; 838C 9D F0 03                 ...
L838F:  rts                                     ; 838F 60                       `

; ----------------------------------------------------------------------------
        ldy     $0468,x                         ; 8390 BC 68 04                 .h.
        lda     $0300,y                         ; 8393 B9 00 03                 ...
        cmp     #$98                            ; 8396 C9 98                    ..
        bne     L838F                           ; 8398 D0 F5                    ..
        jsr     LE968                           ; 839A 20 68 E9                  h.
        jsr     LE8E6                           ; 839D 20 E6 E8                  ..
        lda     #$94                            ; 83A0 A9 94                    ..
        cmp     $0378,x                         ; 83A2 DD 78 03                 .x.
        bcs     L841C                           ; 83A5 B0 75                    .u
        sta     $0378,x                         ; 83A7 9D 78 03                 .x.
        jsr     LF16F                           ; 83AA 20 6F F1                  o.
        bcs     L841C                           ; 83AD B0 6D                    .m
        lda     #$A4                            ; 83AF A9 A4                    ..
        jsr     LEA98                           ; 83B1 20 98 EA                  ..
        lda     #$63                            ; 83B4 A9 63                    .c
        jsr     LEAA4                           ; 83B6 20 A4 EA                  ..
        lda     $0528,y                         ; 83B9 B9 28 05                 .(.
        and     #$DF                            ; 83BC 29 DF                    ).
        sta     $0528,y                         ; 83BE 99 28 05                 .(.
        lda     #$6D                            ; 83C1 A9 6D                    .m
        sta     $0300,y                         ; 83C3 99 00 03                 ...
        lda     #$98                            ; 83C6 A9 98                    ..
        sta     $0378,y                         ; 83C8 99 78 03                 .x.
        tya                                     ; 83CB 98                       .
        sta     $0480                           ; 83CC 8D 80 04                 ...
        lda     #$00                            ; 83CF A9 00                    ..
        sta     $0408,y                         ; 83D1 99 08 04                 ...
        sta     $03D8,x                         ; 83D4 9D D8 03                 ...
        sta     $03F0,x                         ; 83D7 9D F0 03                 ...
        lda     #$EA                            ; 83DA A9 EA                    ..
        sta     $0588,x                         ; 83DC 9D 88 05                 ...
        lda     #$A3                            ; 83DF A9 A3                    ..
        sta     $05A0,x                         ; 83E1 9D A0 05                 ...
        lda     #$1E                            ; 83E4 A9 1E                    ..
        sta     $0480,x                         ; 83E6 9D 80 04                 ...
        rts                                     ; 83E9 60                       `

; ----------------------------------------------------------------------------
        lda     $0480,x                         ; 83EA BD 80 04                 ...
        beq     L83F9                           ; 83ED F0 0A                    ..
        dec     $0480,x                         ; 83EF DE 80 04                 ...
        bne     L841C                           ; 83F2 D0 28                    .(
        lda     #$A2                            ; 83F4 A9 A2                    ..
        jsr     LEA98                           ; 83F6 20 98 EA                  ..
L83F9:  jsr     LE9E1                           ; 83F9 20 E1 E9                  ..
        jsr     LE94A                           ; 83FC 20 4A E9                  J.
        lda     $0390,x                         ; 83FF BD 90 03                 ...
        beq     L841C                           ; 8402 F0 18                    ..
        jsr     LF2C4                           ; 8404 20 C4 F2                  ..
        ldy     #$00                            ; 8407 A0 00                    ..
        lda     #$07                            ; 8409 A9 07                    ..
        jsr     LEAE9                           ; 840B 20 E9 EA                  ..
        lda     #$7E                            ; 840E A9 7E                    .~
        sta     $03D8                           ; 8410 8D D8 03                 ...
        lda     #$04                            ; 8413 A9 04                    ..
        sta     $03F0                           ; 8415 8D F0 03                 ...
        lda     #$13                            ; 8418 A9 13                    ..
        sta     L0030                           ; 841A 85 30                    .0
L841C:  rts                                     ; 841C 60                       `

; ----------------------------------------------------------------------------
        lda     L0030                           ; 841D A5 30                    .0
        bne     L847A                           ; 841F D0 59                    .Y
        jsr     LEF87                           ; 8421 20 87 EF                  ..
        bcs     L847A                           ; 8424 B0 54                    .T
        ldy     #$00                            ; 8426 A0 00                    ..
        sty     $34                             ; 8428 84 34                    .4
        sty     $33                             ; 842A 84 33                    .3
        lda     #$13                            ; 842C A9 13                    ..
L842E:  jsr     LEAE9                           ; 842E 20 E9 EA                  ..
        lda     $0528                           ; 8431 AD 28 05                 .(.
        ora     #$20                            ; 8434 09 20                    . 
        sta     $0528                           ; 8436 8D 28 05                 .(.
        lda     #$04                            ; 8439 A9 04                    ..
        sta     $0540                           ; 843B 8D 40 05                 .@.
        lda     $0330,x                         ; 843E BD 30 03                 .0.
        sta     $0330                           ; 8441 8D 30 03                 .0.
        lda     $0378,x                         ; 8444 BD 78 03                 .x.
        ora     #$04                            ; 8447 09 04                    ..
        sta     $0378                           ; 8449 8D 78 03                 .x.
        lda     #$15                            ; 844C A9 15                    ..
        sta     L0030                           ; 844E 85 30                    .0
        lda     #$F1                            ; 8450 A9 F1                    ..
        jsr     LEC5D                           ; 8452 20 5D EC                  ].
        ldy     #$24                            ; 8455 A0 24                    .$
L8457:  lda     $0348,x                         ; 8457 BD 48 03                 .H.
        cmp     $A47B,y                         ; 845A D9 7B A4                 .{.
        bne     L8474                           ; 845D D0 15                    ..
        lda     $0330,x                         ; 845F BD 30 03                 .0.
        cmp     $A47C,y                         ; 8462 D9 7C A4                 .|.
        bne     L8474                           ; 8465 D0 0D                    ..
        lda     $0378,x                         ; 8467 BD 78 03                 .x.
        cmp     $A47D,y                         ; 846A D9 7D A4                 .}.
        bne     L8474                           ; 846D D0 05                    ..
        sty     $6A                             ; 846F 84 6A                    .j
        jmp     LF2C4                           ; 8471 4C C4 F2                 L..

; ----------------------------------------------------------------------------
L8474:  dey                                     ; 8474 88                       .
        dey                                     ; 8475 88                       .
        dey                                     ; 8476 88                       .
        dey                                     ; 8477 88                       .
        bpl     L8457                           ; 8478 10 DD                    ..
L847A:  rts                                     ; 847A 60                       `

; ----------------------------------------------------------------------------
        .byte   $02                             ; 847B 02                       .
        bne     L842E                           ; 847C D0 B0                    ..
        brk                                     ; 847E 00                       .
        .byte   $03                             ; 847F 03                       .
        jsr     L0030                           ; 8480 20 30 00                  0.
        .byte   $03                             ; 8483 03                       .
        jsr     L0070                           ; 8484 20 70 00                  p.
        .byte   $03                             ; 8487 03                       .
        jsr     L00B0                           ; 8488 20 B0 00                  ..
        .byte   $03                             ; 848B 03                       .
        .byte   $80                             ; 848C 80                       .
        bvs     L848F                           ; 848D 70 00                    p.
L848F:  .byte   $03                             ; 848F 03                       .
        .byte   $80                             ; 8490 80                       .
        bcs     L8493                           ; 8491 B0 00                    ..
L8493:  .byte   $03                             ; 8493 03                       .
        cpx     #$30                            ; 8494 E0 30                    .0
        brk                                     ; 8496 00                       .
        .byte   $03                             ; 8497 03                       .
        cpx     #$70                            ; 8498 E0 70                    .p
        brk                                     ; 849A 00                       .
        .byte   $03                             ; 849B 03                       .
        cpx     #$B0                            ; 849C E0 B0                    ..
        brk                                     ; 849E 00                       .
        .byte   $03                             ; 849F 03                       .
        .byte   $80                             ; 84A0 80                       .
        bmi     L84A3                           ; 84A1 30 00                    0.
L84A3:  ldy     #$23                            ; 84A3 A0 23                    .#
        jsr     LE7B7                           ; 84A5 20 B7 E7                  ..
        bcc     L84CE                           ; 84A8 90 24                    .$
        lda     L0030                           ; 84AA A5 30                    .0
        cmp     #$03                            ; 84AC C9 03                    ..
        bcs     L84CE                           ; 84AE B0 1E                    ..
        jsr     LEF87                           ; 84B0 20 87 EF                  ..
        bcs     L84CE                           ; 84B3 B0 19                    ..
        lda     $0348,x                         ; 84B5 BD 48 03                 .H.
        and     #$07                            ; 84B8 29 07                    ).
        tay                                     ; 84BA A8                       .
        lda     $F2B2,y                         ; 84BB B9 B2 F2                 ...
        ora     $6B                             ; 84BE 05 6B                    .k
        sta     $6B                             ; 84C0 85 6B                    .k
        lda     #$0A                            ; 84C2 A9 0A                    ..
        sta     $0468                           ; 84C4 8D 68 04                 .h.
        lda     #$17                            ; 84C7 A9 17                    ..
        sta     L0030                           ; 84C9 85 30                    .0
        jsr     LF2C4                           ; 84CB 20 C4 F2                  ..
L84CE:  rts                                     ; 84CE 60                       `

; ----------------------------------------------------------------------------
        lda     $05F0                           ; 84CF AD F0 05                 ...
        ora     $05F1                           ; 84D2 0D F1 05                 ...
        ora     $05F2                           ; 84D5 0D F2 05                 ...
        bne     L84CE                           ; 84D8 D0 F4                    ..
        lda     #$80                            ; 84DA A9 80                    ..
        sta     $1E                             ; 84DC 85 1E                    ..
        sta     $55                             ; 84DE 85 55                    .U
        lda     #$44                            ; 84E0 A9 44                    .D
        sta     L0023                           ; 84E2 85 23                    .#
        lda     #$EE                            ; 84E4 A9 EE                    ..
        sta     $0588,x                         ; 84E6 9D 88 05                 ...
        lda     #$A4                            ; 84E9 A9 A4                    ..
        sta     $05A0,x                         ; 84EB 9D A0 05                 ...
        lda     $1E                             ; 84EE A5 1E                    ..
        bne     L84CE                           ; 84F0 D0 DC                    ..
        sta     $78                             ; 84F2 85 78                    .x
        lda     #$22                            ; 84F4 A9 22                    ."
        sta     $7A                             ; 84F6 85 7A                    .z
        lda     #$40                            ; 84F8 A9 40                    .@
        sta     $7B                             ; 84FA 85 7B                    .{
        lda     #$8F                            ; 84FC A9 8F                    ..
        sta     $9B                             ; 84FE 85 9B                    ..
        lda     #$05                            ; 8500 A9 05                    ..
        sta     $99                             ; 8502 85 99                    ..
        lda     #$02                            ; 8504 A9 02                    ..
        sta     $FD                             ; 8506 85 FD                    ..
        lda     #$7C                            ; 8508 A9 7C                    .|
        sta     $EA                             ; 850A 85 EA                    ..
        lda     #$7E                            ; 850C A9 7E                    .~
        sta     $EB                             ; 850E 85 EB                    ..
        lda     #$30                            ; 8510 A9 30                    .0
        sta     $0480,x                         ; 8512 9D 80 04                 ...
        lda     #$1F                            ; 8515 A9 1F                    ..
        sta     $0588,x                         ; 8517 9D 88 05                 ...
        lda     #$A5                            ; 851A A9 A5                    ..
        sta     $05A0,x                         ; 851C 9D A0 05                 ...
        lda     $0468,x                         ; 851F BD 68 04                 .h.
        bne     L854C                           ; 8522 D0 28                    .(
        ldy     #$0B                            ; 8524 A0 0B                    ..
L8526:  lda     $A64A,y                         ; 8526 B9 4A A6                 .J.
        sec                                     ; 8529 38                       8
        sbc     $0480,x                         ; 852A FD 80 04                 ...
        bcs     L8531                           ; 852D B0 02                    ..
        lda     #$0F                            ; 852F A9 0F                    ..
L8531:  sta     $0600,y                         ; 8531 99 00 06                 ...
        sta     $0620,y                         ; 8534 99 20 06                 . .
        dey                                     ; 8537 88                       .
        bpl     L8526                           ; 8538 10 EC                    ..
        sty     $18                             ; 853A 84 18                    ..
        lda     #$08                            ; 853C A9 08                    ..
        sta     $0468,x                         ; 853E 9D 68 04                 .h.
        lda     $0480,x                         ; 8541 BD 80 04                 ...
        sec                                     ; 8544 38                       8
        sbc     #$10                            ; 8545 E9 10                    ..
        sta     $0480,x                         ; 8547 9D 80 04                 ...
        bcc     L8550                           ; 854A 90 04                    ..
L854C:  dec     $0468,x                         ; 854C DE 68 04                 .h.
        rts                                     ; 854F 60                       `

; ----------------------------------------------------------------------------
L8550:  lda     #$00                            ; 8550 A9 00                    ..
        sta     $03D8,x                         ; 8552 9D D8 03                 ...
        lda     #$01                            ; 8555 A9 01                    ..
        sta     $03F0,x                         ; 8557 9D F0 03                 ...
        lda     #$40                            ; 855A A9 40                    .@
        sta     $03A8,x                         ; 855C 9D A8 03                 ...
        lda     #$00                            ; 855F A9 00                    ..
        sta     $03C0,x                         ; 8561 9D C0 03                 ...
        lda     #$0A                            ; 8564 A9 0A                    ..
        sta     $0420,x                         ; 8566 9D 20 04                 . .
        lda     #$50                            ; 8569 A9 50                    .P
        sta     $0468,x                         ; 856B 9D 68 04                 .h.
        lda     #$40                            ; 856E A9 40                    .@
        sta     $0480,x                         ; 8570 9D 80 04                 ...
        lda     #$01                            ; 8573 A9 01                    ..
        sta     $0498,x                         ; 8575 9D 98 04                 ...
        lda     #$82                            ; 8578 A9 82                    ..
        sta     $0588,x                         ; 857A 9D 88 05                 ...
        lda     #$A5                            ; 857D A9 A5                    ..
        sta     $05A0,x                         ; 857F 9D A0 05                 ...
        jsr     LEA65                           ; 8582 20 65 EA                  e.
        jsr     LEA86                           ; 8585 20 86 EA                  ..
        dec     $0468,x                         ; 8588 DE 68 04                 .h.
        bne     L859D                           ; 858B D0 10                    ..
        jsr     LA60E                           ; 858D 20 0E A6                  ..
        lda     #$50                            ; 8590 A9 50                    .P
        sta     $0468,x                         ; 8592 9D 68 04                 .h.
        lda     $0420,x                         ; 8595 BD 20 04                 . .
        eor     #$0C                            ; 8598 49 0C                    I.
        sta     $0420,x                         ; 859A 9D 20 04                 . .
L859D:  lda     $0480,x                         ; 859D BD 80 04                 ...
        sec                                     ; 85A0 38                       8
        sbc     #$01                            ; 85A1 E9 01                    ..
        sta     $0480,x                         ; 85A3 9D 80 04                 ...
        lda     $0498,x                         ; 85A6 BD 98 04                 ...
        sbc     #$00                            ; 85A9 E9 00                    ..
        sta     $0498,x                         ; 85AB 9D 98 04                 ...
        ora     $0480,x                         ; 85AE 1D 80 04                 ...
        bne     L85C8                           ; 85B1 D0 15                    ..
        jsr     LA60E                           ; 85B3 20 0E A6                  ..
        lda     #$40                            ; 85B6 A9 40                    .@
        sta     $0480,x                         ; 85B8 9D 80 04                 ...
        lda     #$01                            ; 85BB A9 01                    ..
        sta     $0498,x                         ; 85BD 9D 98 04                 ...
        lda     $0420,x                         ; 85C0 BD 20 04                 . .
        eor     #$03                            ; 85C3 49 03                    I.
        sta     $0420,x                         ; 85C5 9D 20 04                 . .
L85C8:  lda     #$A0                            ; 85C8 A9 A0                    ..
        sec                                     ; 85CA 38                       8
        sbc     $0378,x                         ; 85CB FD 78 03                 .x.
        sta     $FA                             ; 85CE 85 FA                    ..
        lda     #$C0                            ; 85D0 A9 C0                    ..
        sec                                     ; 85D2 38                       8
        sbc     $0330,x                         ; 85D3 FD 30 03                 .0.
        sta     $78                             ; 85D6 85 78                    .x
        lda     $0408,x                         ; 85D8 BD 08 04                 ...
        pha                                     ; 85DB 48                       H
        lda     $0330,x                         ; 85DC BD 30 03                 .0.
        pha                                     ; 85DF 48                       H
        sec                                     ; 85E0 38                       8
        sbc     #$20                            ; 85E1 E9 20                    . 
        sta     $0330,x                         ; 85E3 9D 30 03                 .0.
        lda     $0378,x                         ; 85E6 BD 78 03                 .x.
        pha                                     ; 85E9 48                       H
        sec                                     ; 85EA 38                       8
        sbc     #$08                            ; 85EB E9 08                    ..
        sta     $0378,x                         ; 85ED 9D 78 03                 .x.
        lda     #$00                            ; 85F0 A9 00                    ..
        sta     $0408,x                         ; 85F2 9D 08 04                 ...
        jsr     LEFF8                           ; 85F5 20 F8 EF                  ..
        pla                                     ; 85F8 68                       h
        sta     $0378,x                         ; 85F9 9D 78 03                 .x.
        pla                                     ; 85FC 68                       h
        sta     $0330,x                         ; 85FD 9D 30 03                 .0.
        pla                                     ; 8600 68                       h
        sta     $0408,x                         ; 8601 9D 08 04                 ...
        bcs     L860D                           ; 8604 B0 07                    ..
        lda     #$40                            ; 8606 A9 40                    .@
        sta     L0000                           ; 8608 85 00                    ..
        jmp     L809D                           ; 860A 4C 9D 80                 L..

; ----------------------------------------------------------------------------
L860D:  rts                                     ; 860D 60                       `

; ----------------------------------------------------------------------------
        lda     $0378,x                         ; 860E BD 78 03                 .x.
        cmp     #$59                            ; 8611 C9 59                    .Y
        bcs     L8648                           ; 8613 B0 33                    .3
        jsr     LF16F                           ; 8615 20 6F F1                  o.
        bcs     L8648                           ; 8618 B0 2E                    ..
        lda     #$B5                            ; 861A A9 B5                    ..
        jsr     LEAA4                           ; 861C 20 A4 EA                  ..
        lda     $0378,x                         ; 861F BD 78 03                 .x.
        clc                                     ; 8622 18                       .
        adc     #$28                            ; 8623 69 28                    i(
        sta     $0378,y                         ; 8625 99 78 03                 .x.
        lda     $0330,y                         ; 8628 B9 30 03                 .0.
        sec                                     ; 862B 38                       8
        sbc     #$38                            ; 862C E9 38                    .8
        sta     $0330,y                         ; 862E 99 30 03                 .0.
        lda     #$4E                            ; 8631 A9 4E                    .N
        sta     $0300,y                         ; 8633 99 00 03                 ...
        lda     #$80                            ; 8636 A9 80                    ..
        sta     $0408,y                         ; 8638 99 08 04                 ...
        tya                                     ; 863B 98                       .
        tax                                     ; 863C AA                       .
        jsr     LECC2                           ; 863D 20 C2 EC                  ..
        tay                                     ; 8640 A8                       .
        lda     #$28                            ; 8641 A9 28                    .(
        jsr     LF470                           ; 8643 20 70 F4                  p.
        ldx     $A6                             ; 8646 A6 A6                    ..
L8648:  rts                                     ; 8648 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; 8649 60                       `

; ----------------------------------------------------------------------------
        .byte   $0F                             ; 864A 0F                       .
        jsr     L0616                           ; 864B 20 16 06                  ..
        .byte   $0F                             ; 864E 0F                       .
        jsr     L1323                           ; 864F 20 23 13                  #.
        .byte   $0F                             ; 8652 0F                       .
        jsr     L1B2B                           ; 8653 20 2B 1B                  +.
        .byte   $FF                             ; 8656 FF                       .
        ora     $DF,x                           ; 8657 15 DF                    ..
        .byte   $D7                             ; 8659 D7                       .
        .byte   $FF                             ; 865A FF                       .
        sbc     $D5FF,x                         ; 865B FD FF D5                 ...
        .byte   $FF                             ; 865E FF                       .
        eor     $D5FF,x                         ; 865F 5D FF D5                 ]..
        .byte   $FF                             ; 8662 FF                       .
        .byte   $7F                             ; 8663 7F                       .
        .byte   $FF                             ; 8664 FF                       .
        .byte   $D7                             ; 8665 D7                       .
        .byte   $FF                             ; 8666 FF                       .
        .byte   $F7                             ; 8667 F7                       .
        .byte   $FF                             ; 8668 FF                       .
        cmp     $FF,x                           ; 8669 D5 FF                    ..
        adc     $57FD,x                         ; 866B 7D FD 57                 }.W
        .byte   $FF                             ; 866E FF                       .
        sbc     $55FF,x                         ; 866F FD FF 55                 ..U
        .byte   $FF                             ; 8672 FF                       .
        adc     $7DFF                           ; 8673 6D FF 7D                 m.}
        .byte   $FF                             ; 8676 FF                       .
        adc     $F7,x                           ; 8677 75 F7                    u.
        eor     $FF,x                           ; 8679 55 FF                    U.
        sbc     $EF,x                           ; 867B F5 EF                    ..
        .byte   $F7                             ; 867D F7                       .
        .byte   $FF                             ; 867E FF                       .
        adc     $75FF,x                         ; 867F 7D FF 75                 }.u
        .byte   $FF                             ; 8682 FF                       .
        cmp     $5DBF,x                         ; 8683 DD BF 5D                 ..]
        inc     $F67D,x                         ; 8686 FE 7D F6                 .}.
        .byte   $D7                             ; 8689 D7                       .
        .byte   $FF                             ; 868A FF                       .
        .byte   $5F                             ; 868B 5F                       _
        .byte   $FF                             ; 868C FF                       .
        sbc     $FF,x                           ; 868D F5 FF                    ..
        .byte   $57                             ; 868F 57                       W
        .byte   $FF                             ; 8690 FF                       .
        eor     $EB,x                           ; 8691 55 EB                    U.
        .byte   $D7                             ; 8693 D7                       .
        .byte   $FF                             ; 8694 FF                       .
        .byte   $7F                             ; 8695 7F                       .
        .byte   $BF                             ; 8696 BF                       .
        eor     $FF,x                           ; 8697 55 FF                    U.
        sbc     $5DFF,x                         ; 8699 FD FF 5D                 ..]
        .byte   $FF                             ; 869C FF                       .
        cmp     $FF,x                           ; 869D D5 FF                    ..
        sbc     $5FFF,x                         ; 869F FD FF 5F                 .._
        .byte   $FF                             ; 86A2 FF                       .
        .byte   $D4                             ; 86A3 D4                       .
        .byte   $FF                             ; 86A4 FF                       .
        sbc     $77FF,x                         ; 86A5 FD FF 77                 ..w
        .byte   $DF                             ; 86A8 DF                       .
        adc     $FDFF,x                         ; 86A9 7D FF FD                 }..
        .byte   $FF                             ; 86AC FF                       .
        cmp     $FF,x                           ; 86AD D5 FF                    ..
        eor     $DFFF,x                         ; 86AF 5D FF DF                 ]..
        .byte   $FF                             ; 86B2 FF                       .
        eor     $77FF,x                         ; 86B3 5D FF 77                 ].w
        .byte   $FF                             ; 86B6 FF                       .
        sbc     $FF,x                           ; 86B7 F5 FF                    ..
        eor     $6F,x                           ; 86B9 55 6F                    Uo
        sbc     $F5FF,x                         ; 86BB FD FF F5                 ...
        .byte   $FF                             ; 86BE FF                       .
        .byte   $DF                             ; 86BF DF                       .
        .byte   $FF                             ; 86C0 FF                       .
        .byte   $5F                             ; 86C1 5F                       _
        .byte   $F7                             ; 86C2 F7                       .
        cmp     $55FF,x                         ; 86C3 DD FF 55                 ..U
        .byte   $FF                             ; 86C6 FF                       .
        sbc     $FF,x                           ; 86C7 F5 FF                    ..
        eor     $75FF,x                         ; 86C9 5D FF 75                 ].u
        .byte   $FF                             ; 86CC FF                       .
        eor     $F7FB,x                         ; 86CD 5D FB F7                 ]..
        .byte   $FF                             ; 86D0 FF                       .
        cmp     $EF,x                           ; 86D1 D5 EF                    ..
        eor     $FDFE,x                         ; 86D3 5D FE FD                 ]..
        .byte   $FF                             ; 86D6 FF                       .
        cmp     $7DFF,x                         ; 86D7 DD FF 7D                 ..}
        .byte   $7F                             ; 86DA 7F                       .
        .byte   $5F                             ; 86DB 5F                       _
        .byte   $FF                             ; 86DC FF                       .
        cmp     $FF,x                           ; 86DD D5 FF                    ..
        sbc     $DDFD,x                         ; 86DF FD FD DD                 ...
        .byte   $FF                             ; 86E2 FF                       .
        .byte   $1F                             ; 86E3 1F                       .
        .byte   $FF                             ; 86E4 FF                       .
        .byte   $77                             ; 86E5 77                       w
        .byte   $FF                             ; 86E6 FF                       .
        adc     $FB,x                           ; 86E7 75 FB                    u.
        adc     $FF                             ; 86E9 65 FF                    e.
        sbc     $FF,x                           ; 86EB F5 FF                    ..
        rol     $FF                             ; 86ED 26 FF                    &.
        eor     $FF,x                           ; 86EF 55 FF                    U.
        adc     $FF,x                           ; 86F1 75 FF                    u.
        .byte   $5F                             ; 86F3 5F                       _
        .byte   $FF                             ; 86F4 FF                       .
        .byte   $74                             ; 86F5 74                       t
        .byte   $FF                             ; 86F6 FF                       .
        .byte   $D7                             ; 86F7 D7                       .
        .byte   $FF                             ; 86F8 FF                       .
        cmp     $5DFF,x                         ; 86F9 DD FF 5D                 ..]
        .byte   $FB                             ; 86FC FB                       .
        cmp     $FF,x                           ; 86FD D5 FF                    ..
        sbc     $FC,x                           ; 86FF F5 FC                    ..
        eor     $55FF,x                         ; 8701 5D FF 55                 ].U
        .byte   $DF                             ; 8704 DF                       .
        cmp     $F5FB,x                         ; 8705 DD FB F5                 ...
        .byte   $FF                             ; 8708 FF                       .
        eor     $FF,x                           ; 8709 55 FF                    U.
        .byte   $BF                             ; 870B BF                       .
        .byte   $F7                             ; 870C F7                       .
        cmp     $FFFC                           ; 870D CD FC FF                 ...
        .byte   $FF                             ; 8710 FF                       .
        adc     $BF,x                           ; 8711 75 BF                    u.
        cmp     $FDFF,x                         ; 8713 DD FF FD                 ...
        .byte   $DF                             ; 8716 DF                       .
        adc     $55FF,x                         ; 8717 7D FF 55                 }.U
        .byte   $FF                             ; 871A FF                       .
        eor     $D5FD,x                         ; 871B 5D FD D5                 ]..
        .byte   $FF                             ; 871E FF                       .
        cmp     $FB,x                           ; 871F D5 FB                    ..
        .byte   $EF                             ; 8721 EF                       .
        .byte   $FB                             ; 8722 FB                       .
        .byte   $5F                             ; 8723 5F                       _
        .byte   $DF                             ; 8724 DF                       .
        adc     $FF,x                           ; 8725 75 FF                    u.
        sbc     $FF,x                           ; 8727 F5 FF                    ..
        .byte   $D7                             ; 8729 D7                       .
        .byte   $FB                             ; 872A FB                       .
        eor     $FD,x                           ; 872B 55 FD                    U.
        .byte   $DF                             ; 872D DF                       .
        .byte   $FF                             ; 872E FF                       .
        .byte   $74                             ; 872F 74                       t
        .byte   $FF                             ; 8730 FF                       .
        adc     $FF,x                           ; 8731 75 FF                    u.
        .byte   $DF                             ; 8733 DF                       .
        .byte   $FF                             ; 8734 FF                       .
        .byte   $D7                             ; 8735 D7                       .
        .byte   $FF                             ; 8736 FF                       .
        cmp     $FF,x                           ; 8737 D5 FF                    ..
        adc     $F7FF,x                         ; 8739 7D FF F7                 }..
        .byte   $DF                             ; 873C DF                       .
        adc     $FF,x                           ; 873D 75 FF                    u.
        .byte   $D7                             ; 873F D7                       .
        .byte   $FF                             ; 8740 FF                       .
        cmp     $FF,x                           ; 8741 D5 FF                    ..
        eor     $FF,x                           ; 8743 55 FF                    U.
        .byte   $DF                             ; 8745 DF                       .
        .byte   $FF                             ; 8746 FF                       .
        adc     $FDFF,x                         ; 8747 7D FF FD                 }..
        .byte   $FF                             ; 874A FF                       .
        adc     $DFFF,x                         ; 874B 7D FF DF                 }..
        .byte   $FF                             ; 874E FF                       .
        .byte   $77                             ; 874F 77                       w
        .byte   $FF                             ; 8750 FF                       .
        sbc     $FFFE,x                         ; 8751 FD FE FF                 ...
        .byte   $7F                             ; 8754 7F                       .
        adc     $7F,x                           ; 8755 75 7F                    u.
        .byte   $F7                             ; 8757 F7                       .
        .byte   $FF                             ; 8758 FF                       .
        eor     $55EF,x                         ; 8759 5D EF 55                 ].U
        .byte   $FF                             ; 875C FF                       .
        .byte   $D7                             ; 875D D7                       .
        .byte   $FF                             ; 875E FF                       .
        sbc     ($FF),y                         ; 875F F1 FF                    ..
        .byte   $7F                             ; 8761 7F                       .
        .byte   $FF                             ; 8762 FF                       .
        adc     $7DFF,x                         ; 8763 7D FF 7D                 }.}
        .byte   $FF                             ; 8766 FF                       .
        adc     $75FF,x                         ; 8767 7D FF 75                 }.u
        .byte   $FF                             ; 876A FF                       .
        sbc     $FF,x                           ; 876B F5 FF                    ..
        adc     $FF,x                           ; 876D 75 FF                    u.
        .byte   $7F                             ; 876F 7F                       .
        .byte   $FF                             ; 8770 FF                       .
        cmp     $57DF,x                         ; 8771 DD DF 57                 ..W
        .byte   $FB                             ; 8774 FB                       .
        eor     $FE,x                           ; 8775 55 FE                    U.
        .byte   $77                             ; 8777 77                       w
        .byte   $FF                             ; 8778 FF                       .
        cmp     $FF,x                           ; 8779 D5 FF                    ..
        .byte   $B7                             ; 877B B7                       .
        .byte   $F7                             ; 877C F7                       .
        eor     $FF,x                           ; 877D 55 FF                    U.
        .byte   $77                             ; 877F 77                       w
        .byte   $FF                             ; 8780 FF                       .
        adc     $FB,x                           ; 8781 75 FB                    u.
        eor     $FF,x                           ; 8783 55 FF                    U.
        .byte   $D7                             ; 8785 D7                       .
        .byte   $FB                             ; 8786 FB                       .
        eor     $FFFF,x                         ; 8787 5D FF FF                 ]..
        .byte   $FF                             ; 878A FF                       .
        .byte   $DF                             ; 878B DF                       .
        .byte   $FF                             ; 878C FF                       .
        .byte   $DF                             ; 878D DF                       .
        .byte   $FF                             ; 878E FF                       .
        cmp     $FF,x                           ; 878F D5 FF                    ..
        .byte   $F7                             ; 8791 F7                       .
        .byte   $9F                             ; 8792 9F                       .
        cmp     $FFFF,x                         ; 8793 DD FF FF                 ...
        .byte   $FF                             ; 8796 FF                       .
        cmp     $DFFE,x                         ; 8797 DD FE DF                 ...
        .byte   $FF                             ; 879A FF                       .
        .byte   $DF                             ; 879B DF                       .
        .byte   $FF                             ; 879C FF                       .
        .byte   $FF                             ; 879D FF                       .
        .byte   $F7                             ; 879E F7                       .
        adc     $75FF,x                         ; 879F 7D FF 75                 }.u
        inc     $FF75,x                         ; 87A2 FE 75 FF                 .u.
        .byte   $5F                             ; 87A5 5F                       _
        .byte   $FF                             ; 87A6 FF                       .
        sta     $FF,x                           ; 87A7 95 FF                    ..
        cmp     $577F,x                         ; 87A9 DD 7F 57                 ..W
        .byte   $FF                             ; 87AC FF                       .
        eor     $FF,x                           ; 87AD 55 FF                    U.
        .byte   $5F                             ; 87AF 5F                       _
        .byte   $EF                             ; 87B0 EF                       .
        eor     $FF,x                           ; 87B1 55 FF                    U.
        cmp     $FFFF,x                         ; 87B3 DD FF FF                 ...
        .byte   $FB                             ; 87B6 FB                       .
        adc     $FFFF,x                         ; 87B7 7D FF FF                 }..
        .byte   $FF                             ; 87BA FF                       .
        .byte   $D7                             ; 87BB D7                       .
        .byte   $FF                             ; 87BC FF                       .
        cmp     $D7FF,x                         ; 87BD DD FF D7                 ...
        .byte   $FF                             ; 87C0 FF                       .
        sbc     $FF,x                           ; 87C1 F5 FF                    ..
        sbc     $D7FF,x                         ; 87C3 FD FF D7                 ...
        .byte   $FF                             ; 87C6 FF                       .
        eor     $FF                             ; 87C7 45 FF                    E.
        cmp     $D7FF,x                         ; 87C9 DD FF D7                 ...
        .byte   $FF                             ; 87CC FF                       .
        cmp     $FF,x                           ; 87CD D5 FF                    ..
        sbc     $EF,x                           ; 87CF F5 EF                    ..
        adc     $D7FF,x                         ; 87D1 7D FF D7                 }..
        .byte   $FF                             ; 87D4 FF                       .
        cmp     $FF,x                           ; 87D5 D5 FF                    ..
        cmp     $5DFF,x                         ; 87D7 DD FF 5D                 ..]
        .byte   $FF                             ; 87DA FF                       .
        .byte   $DF                             ; 87DB DF                       .
        cmp     $FF57,x                         ; 87DC DD 57 FF                 .W.
        .byte   $FF                             ; 87DF FF                       .
        .byte   $FF                             ; 87E0 FF                       .
        .byte   $F7                             ; 87E1 F7                       .
        .byte   $FF                             ; 87E2 FF                       .
        sbc     $57FF,x                         ; 87E3 FD FF 57                 ..W
        .byte   $FF                             ; 87E6 FF                       .
        .byte   $57                             ; 87E7 57                       W
        .byte   $FF                             ; 87E8 FF                       .
        cmp     $FF,x                           ; 87E9 D5 FF                    ..
        .byte   $77                             ; 87EB 77                       w
        .byte   $FF                             ; 87EC FF                       .
        eor     $DDFF,x                         ; 87ED 5D FF DD                 ]..
        .byte   $FF                             ; 87F0 FF                       .
        .byte   $67                             ; 87F1 67                       g
        .byte   $FF                             ; 87F2 FF                       .
        adc     $FF,x                           ; 87F3 75 FF                    u.
        adc     $DFFF,x                         ; 87F5 7D FF DF                 }..
        .byte   $BF                             ; 87F8 BF                       .
        adc     $F5FF,x                         ; 87F9 7D FF F5                 }..
        .byte   $EF                             ; 87FC EF                       .
        adc     $FF,x                           ; 87FD 75 FF                    u.
        adc     L0000,x                         ; 87FF 75 00                    u.
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
        .byte   $02                             ; 8811 02                       .
        ora     ($01,x)                         ; 8812 01 01                    ..
        ora     ($01,x)                         ; 8814 01 01                    ..
        ora     ($02,x)                         ; 8816 01 02                    ..
        .byte   $02                             ; 8818 02                       .
        ora     ($01,x)                         ; 8819 01 01                    ..
        .byte   $02                             ; 881B 02                       .
        ora     ($01,x)                         ; 881C 01 01                    ..
        brk                                     ; 881E 00                       .
        brk                                     ; 881F 00                       .
        .byte   $02                             ; 8820 02                       .
        .byte   $02                             ; 8821 02                       .
        brk                                     ; 8822 00                       .
        brk                                     ; 8823 00                       .
        brk                                     ; 8824 00                       .
        ora     (L0000,x)                       ; 8825 01 00                    ..
        brk                                     ; 8827 00                       .
        .byte   $02                             ; 8828 02                       .
        ora     ($02,x)                         ; 8829 01 02                    ..
        ora     (L0000,x)                       ; 882B 01 00                    ..
        brk                                     ; 882D 00                       .
        brk                                     ; 882E 00                       .
        brk                                     ; 882F 00                       .
        brk                                     ; 8830 00                       .
        .byte   $02                             ; 8831 02                       .
        ora     ($02,x)                         ; 8832 01 02                    ..
        ora     (L0000,x)                       ; 8834 01 00                    ..
        .byte   $02                             ; 8836 02                       .
        brk                                     ; 8837 00                       .
        brk                                     ; 8838 00                       .
        ora     ($02,x)                         ; 8839 01 02                    ..
        ora     (L0000,x)                       ; 883B 01 00                    ..
        brk                                     ; 883D 00                       .
        .byte   $02                             ; 883E 02                       .
        brk                                     ; 883F 00                       .
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
        .byte   $04                             ; 884F 04                       .
        ora     (L0000,x)                       ; 8850 01 00                    ..
        ora     ($01,x)                         ; 8852 01 01                    ..
        ora     (L0000,x)                       ; 8854 01 00                    ..
        ora     (L0000,x)                       ; 8856 01 00                    ..
        brk                                     ; 8858 00                       .
        .byte   $02                             ; 8859 02                       .
        ora     (L0000,x)                       ; 885A 01 00                    ..
        .byte   $02                             ; 885C 02                       .
        .byte   $02                             ; 885D 02                       .
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
        ora     ($01,x)                         ; 887B 01 01                    ..
        brk                                     ; 887D 00                       .
        brk                                     ; 887E 00                       .
        brk                                     ; 887F 00                       .
        brk                                     ; 8880 00                       .
        ora     (L0000,x)                       ; 8881 01 00                    ..
        ora     (L0000,x)                       ; 8883 01 00                    ..
        brk                                     ; 8885 00                       .
        ora     (L0000,x)                       ; 8886 01 00                    ..
        brk                                     ; 8888 00                       .
        .byte   $03                             ; 8889 03                       .
        brk                                     ; 888A 00                       .
        brk                                     ; 888B 00                       .
        brk                                     ; 888C 00                       .
        ora     (L0000,x)                       ; 888D 01 00                    ..
        brk                                     ; 888F 00                       .
        brk                                     ; 8890 00                       .
        .byte   $02                             ; 8891 02                       .
        brk                                     ; 8892 00                       .
        ora     (L0000,x)                       ; 8893 01 00                    ..
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
        .byte   $02                             ; 88BD 02                       .
        .byte   $02                             ; 88BE 02                       .
        brk                                     ; 88BF 00                       .
        brk                                     ; 88C0 00                       .
        brk                                     ; 88C1 00                       .
        brk                                     ; 88C2 00                       .
        brk                                     ; 88C3 00                       .
        .byte   $02                             ; 88C4 02                       .
        brk                                     ; 88C5 00                       .
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
        .byte   $1C                             ; 891C 1C                       .
        ora     a:$16,x                         ; 891D 1D 16 00                 ...
        brk                                     ; 8920 00                       .
        brk                                     ; 8921 00                       .
        brk                                     ; 8922 00                       .
L8923:  brk                                     ; 8923 00                       .
        brk                                     ; 8924 00                       .
        .byte   $14                             ; 8925 14                       .
        brk                                     ; 8926 00                       .
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
        brk                                     ; 8934 00                       .
        brk                                     ; 8935 00                       .
        brk                                     ; 8936 00                       .
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
        brk                                     ; 894F 00                       .
        jsr     L2220                           ; 8950 20 20 22                   "
        .byte   $80                             ; 8953 80                       .
        .byte   $A3                             ; 8954 A3                       .
        .byte   $80                             ; 8955 80                       .
        ldx     #$80                            ; 8956 A2 80                    ..
        .byte   $A3                             ; 8958 A3                       .
        jsr     LA080                           ; 8959 20 80 A0                  ..
        .byte   $22                             ; 895C 22                       "
        rts                                     ; 895D 60                       `

; ----------------------------------------------------------------------------
        jsr     L0020                           ; 895E 20 20 00                   .
        brk                                     ; 8961 00                       .
        brk                                     ; 8962 00                       .
        brk                                     ; 8963 00                       .
        brk                                     ; 8964 00                       .
        brk                                     ; 8965 00                       .
        brk                                     ; 8966 00                       .
        brk                                     ; 8967 00                       .
        clc                                     ; 8968 18                       .
        clc                                     ; 8969 18                       .
        .byte   $1A                             ; 896A 1A                       .
        jsr     L1A19                           ; 896B 20 19 1A                  ..
        sec                                     ; 896E 38                       8
        and     $1B                             ; 896F 25 1B                    %.
        brk                                     ; 8971 00                       .
        brk                                     ; 8972 00                       .
        brk                                     ; 8973 00                       .
        .byte   $1C                             ; 8974 1C                       .
        ora     #$80                            ; 8975 09 80                    ..
        ldx     L0000,y                         ; 8977 B6 00                    ..
        brk                                     ; 8979 00                       .
        brk                                     ; 897A 00                       .
        .byte   $02                             ; 897B 02                       .
        brk                                     ; 897C 00                       .
        brk                                     ; 897D 00                       .
        brk                                     ; 897E 00                       .
        asl     a                               ; 897F 0A                       .
        sty     a:$8E                           ; 8980 8C 8E 00                 ...
        brk                                     ; 8983 00                       .
        brk                                     ; 8984 00                       .
        brk                                     ; 8985 00                       .
        brk                                     ; 8986 00                       .
        brk                                     ; 8987 00                       .
        and     (L0030,x)                       ; 8988 21 30                    !0
        plp                                     ; 898A 28                       (
        .byte   $0F                             ; 898B 0F                       .
        and     (L0030,x)                       ; 898C 21 30                    !0
        .byte   $2B                             ; 898E 2B                       +
        .byte   $0F                             ; 898F 0F                       .
        and     (L0030,x)                       ; 8990 21 30                    !0
        .byte   $27                             ; 8992 27                       '
        .byte   $0F                             ; 8993 0F                       .
        and     (L0030,x)                       ; 8994 21 30                    !0
        .byte   $3C                             ; 8996 3C                       <
        bit     a:L0000                         ; 8997 2C 00 00                 ,..
        brk                                     ; 899A 00                       .
        sta     (L0000,x)                       ; 899B 81 00                    ..
        brk                                     ; 899D 00                       .
        brk                                     ; 899E 00                       .
        brk                                     ; 899F 00                       .
        brk                                     ; 89A0 00                       .
        brk                                     ; 89A1 00                       .
        brk                                     ; 89A2 00                       .
        brk                                     ; 89A3 00                       .
        brk                                     ; 89A4 00                       .
        brk                                     ; 89A5 00                       .
        brk                                     ; 89A6 00                       .
        brk                                     ; 89A7 00                       .
        brk                                     ; 89A8 00                       .
        brk                                     ; 89A9 00                       .
        brk                                     ; 89AA 00                       .
        brk                                     ; 89AB 00                       .
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
        brk                                     ; 89EB 00                       .
        brk                                     ; 89EC 00                       .
        brk                                     ; 89ED 00                       .
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
        bpl     L89FB                           ; 89F9 10 00                    ..
L89FB:  rti                                     ; 89FB 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 89FC 00                       .
        bpl     L89FF                           ; 89FD 10 00                    ..
L89FF:  brk                                     ; 89FF 00                       .
        brk                                     ; 8A00 00                       .
        ora     ($01,x)                         ; 8A01 01 01                    ..
        .byte   $02                             ; 8A03 02                       .
        .byte   $03                             ; 8A04 03                       .
        .byte   $03                             ; 8A05 03                       .
        .byte   $03                             ; 8A06 03                       .
        .byte   $03                             ; 8A07 03                       .
        .byte   $04                             ; 8A08 04                       .
        .byte   $04                             ; 8A09 04                       .
        .byte   $04                             ; 8A0A 04                       .
        .byte   $04                             ; 8A0B 04                       .
        ora     $05                             ; 8A0C 05 05                    ..
        ora     $06                             ; 8A0E 05 06                    ..
        asl     $07                             ; 8A10 06 07                    ..
        .byte   $07                             ; 8A12 07                       .
        php                                     ; 8A13 08                       .
        php                                     ; 8A14 08                       .
        php                                     ; 8A15 08                       .
        ora     #$09                            ; 8A16 09 09                    ..
        ora     #$09                            ; 8A18 09 09                    ..
        asl     a                               ; 8A1A 0A                       .
        asl     a                               ; 8A1B 0A                       .
        asl     a                               ; 8A1C 0A                       .
        asl     a                               ; 8A1D 0A                       .
        asl     a                               ; 8A1E 0A                       .
        .byte   $0B                             ; 8A1F 0B                       .
        ora     $0D0D                           ; 8A20 0D 0D 0D                 ...
        ora     $0D0D                           ; 8A23 0D 0D 0D                 ...
        asl     L1010                           ; 8A26 0E 10 10                 ...
        bpl     L8A3C                           ; 8A29 10 11                    ..
        ora     ($11),y                         ; 8A2B 11 11                    ..
        .byte   $12                             ; 8A2D 12                       .
        .byte   $12                             ; 8A2E 12                       .
L8A2F:  .byte   $13                             ; 8A2F 13                       .
        asl     $16,x                           ; 8A30 16 16                    ..
        .byte   $17                             ; 8A32 17                       .
        .byte   $17                             ; 8A33 17                       .
        clc                                     ; 8A34 18                       .
        clc                                     ; 8A35 18                       .
        clc                                     ; 8A36 18                       .
        ora     $FF1B,y                         ; 8A37 19 1B FF                 ...
        brk                                     ; 8A3A 00                       .
        brk                                     ; 8A3B 00                       .
L8A3C:  brk                                     ; 8A3C 00                       .
        brk                                     ; 8A3D 00                       .
        brk                                     ; 8A3E 00                       .
        brk                                     ; 8A3F 00                       .
        brk                                     ; 8A40 00                       .
        brk                                     ; 8A41 00                       .
        brk                                     ; 8A42 00                       .
        brk                                     ; 8A43 00                       .
        brk                                     ; 8A44 00                       .
        brk                                     ; 8A45 00                       .
        brk                                     ; 8A46 00                       .
        brk                                     ; 8A47 00                       .
        brk                                     ; 8A48 00                       .
        brk                                     ; 8A49 00                       .
        brk                                     ; 8A4A 00                       .
        brk                                     ; 8A4B 00                       .
        brk                                     ; 8A4C 00                       .
        bpl     L8A4F                           ; 8A4D 10 00                    ..
L8A4F:  brk                                     ; 8A4F 00                       .
        brk                                     ; 8A50 00                       .
        brk                                     ; 8A51 00                       .
        brk                                     ; 8A52 00                       .
        brk                                     ; 8A53 00                       .
        brk                                     ; 8A54 00                       .
        brk                                     ; 8A55 00                       .
        brk                                     ; 8A56 00                       .
        brk                                     ; 8A57 00                       .
        brk                                     ; 8A58 00                       .
        brk                                     ; 8A59 00                       .
        brk                                     ; 8A5A 00                       .
        brk                                     ; 8A5B 00                       .
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
L8A67:  brk                                     ; 8A67 00                       .
        brk                                     ; 8A68 00                       .
        brk                                     ; 8A69 00                       .
        brk                                     ; 8A6A 00                       .
        brk                                     ; 8A6B 00                       .
        brk                                     ; 8A6C 00                       .
        jsr     L0000                           ; 8A6D 20 00 00                  ..
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
        brk                                     ; 8A7C 00                       .
        brk                                     ; 8A7D 00                       .
        brk                                     ; 8A7E 00                       .
        brk                                     ; 8A7F 00                       .
        brk                                     ; 8A80 00                       .
        .byte   $80                             ; 8A81 80                       .
        .byte   $80                             ; 8A82 80                       .
        bne     L8AD4                           ; 8A83 D0 4F                    .O
L8A85:  .byte   $70                             ; 8A85 70                       p
L8A86:  cpx     #$F0                            ; 8A86 E0 F0                    ..
        .byte   $30,$A0                    ; 8A88 30 A0   (branch out of range for ca65: target has no local label)
        .byte   $B0,$F0                    ; 8A8A B0 F0   (branch out of range for ca65: target has no local label)
        and     (L0070),y                       ; 8A8C 31 70                    1p
        .byte   $A0                             ; 8A8E A0                       .
L8A8F:  inx                                     ; 8A8F E8                       .
        .byte   $F0                             ; 8A90 F0                       .
L8A91:  rts                                     ; 8A91 60                       `

; ----------------------------------------------------------------------------
        .byte   $A0                             ; 8A92 A0                       .
L8A93:  and     ($D0),y                         ; 8A93 31 D0                    1.
        .byte   $F0,$08                    ; 8A95 F0 08   (branch out of range for ca65: target has no local label)
        bpl     L8AD9                           ; 8A97 10 40                    .@
        cpx     #$00                            ; 8A99 E0 00                    ..
        jsr     L4140                           ; 8A9B 20 40 41                  @A
        beq     L8AA0                           ; 8A9E F0 00                    ..
L8AA0:  jsr     L7040                           ; 8AA0 20 40 70                  @p
        .byte   $80                             ; 8AA3 80                       .
        bne     L8A86                           ; 8AA4 D0 E0                    ..
        jsr     L2818                           ; 8AA6 20 18 28                  .(
        sec                                     ; 8AA9 38                       8
        rts                                     ; 8AAA 60                       `

; ----------------------------------------------------------------------------
        bne     L8A85                           ; 8AAB D0 D8                    ..
        pha                                     ; 8AAD 48                       H
        cli                                     ; 8AAE 58                       X
        .byte   $80                             ; 8AAF 80                       .
        sei                                     ; 8AB0 78                       x
        bne     L8ADB                           ; 8AB1 D0 28                    .(
        .byte   $B0                             ; 8AB3 B0                       .
L8AB4:  .byte   $50,$90                    ; 8AB4 50 90   (branch out of range for ca65: target has no local label)
        cld                                     ; 8AB6 D8                       .
        bne     L8A91                           ; 8AB7 D0 D8                    ..
L8AB9:  .byte   $FF                             ; 8AB9 FF                       .
        brk                                     ; 8ABA 00                       .
        brk                                     ; 8ABB 00                       .
        brk                                     ; 8ABC 00                       .
        brk                                     ; 8ABD 00                       .
L8ABE:  brk                                     ; 8ABE 00                       .
        brk                                     ; 8ABF 00                       .
        brk                                     ; 8AC0 00                       .
        brk                                     ; 8AC1 00                       .
        brk                                     ; 8AC2 00                       .
        brk                                     ; 8AC3 00                       .
        brk                                     ; 8AC4 00                       .
        brk                                     ; 8AC5 00                       .
        brk                                     ; 8AC6 00                       .
        brk                                     ; 8AC7 00                       .
        brk                                     ; 8AC8 00                       .
        brk                                     ; 8AC9 00                       .
        brk                                     ; 8ACA 00                       .
        brk                                     ; 8ACB 00                       .
L8ACC:  brk                                     ; 8ACC 00                       .
        brk                                     ; 8ACD 00                       .
        brk                                     ; 8ACE 00                       .
        brk                                     ; 8ACF 00                       .
        brk                                     ; 8AD0 00                       .
        brk                                     ; 8AD1 00                       .
        brk                                     ; 8AD2 00                       .
        brk                                     ; 8AD3 00                       .
L8AD4:  brk                                     ; 8AD4 00                       .
        brk                                     ; 8AD5 00                       .
        brk                                     ; 8AD6 00                       .
        brk                                     ; 8AD7 00                       .
        brk                                     ; 8AD8 00                       .
L8AD9:  brk                                     ; 8AD9 00                       .
        brk                                     ; 8ADA 00                       .
L8ADB:  brk                                     ; 8ADB 00                       .
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
        brk                                     ; 8AE7 00                       .
        brk                                     ; 8AE8 00                       .
        brk                                     ; 8AE9 00                       .
        brk                                     ; 8AEA 00                       .
        brk                                     ; 8AEB 00                       .
L8AEC:  brk                                     ; 8AEC 00                       .
        .byte   $04                             ; 8AED 04                       .
        jsr     L0000                           ; 8AEE 20 00 00                  ..
        brk                                     ; 8AF1 00                       .
L8AF2:  brk                                     ; 8AF2 00                       .
        brk                                     ; 8AF3 00                       .
        brk                                     ; 8AF4 00                       .
        brk                                     ; 8AF5 00                       .
        brk                                     ; 8AF6 00                       .
        brk                                     ; 8AF7 00                       .
        brk                                     ; 8AF8 00                       .
        brk                                     ; 8AF9 00                       .
        .byte   $80                             ; 8AFA 80                       .
        brk                                     ; 8AFB 00                       .
        brk                                     ; 8AFC 00                       .
        brk                                     ; 8AFD 00                       .
        .byte   $80                             ; 8AFE 80                       .
        brk                                     ; 8AFF 00                       .
        brk                                     ; 8B00 00                       .
        .byte   $80                             ; 8B01 80                       .
        .byte   $80                             ; 8B02 80                       .
        ldy     #$38                            ; 8B03 A0 38                    .8
L8B05:  .byte   $80                             ; 8B05 80                       .
        sec                                     ; 8B06 38                       8
        ldy     #$80                            ; 8B07 A0 80                    ..
        bvc     L8B3B                           ; 8B09 50 30                    P0
        bvc     L8A93                           ; 8B0B 50 86                    P.
        ldx     $58                             ; 8B0D A6 58                    .X
        pha                                     ; 8B0F 48                       H
        clc                                     ; 8B10 18                       .
        pha                                     ; 8B11 48                       H
        bvs     L8ACC                           ; 8B12 70 B8                    p.
        iny                                     ; 8B14 C8                       .
        clc                                     ; 8B15 18                       .
        clc                                     ; 8B16 18                       .
        clv                                     ; 8B17 B8                       .
        sei                                     ; 8B18 78                       x
        jsr     LB000                           ; 8B19 20 00 B0                  ..
        ror     L0020                           ; 8B1C 66 20                    f 
        bvc     L8B20                           ; 8B1E 50 00                    P.
L8B20:  .byte   $64                             ; 8B20 64                       d
        jsr     L24B0                           ; 8B21 20 B0 24                  .$
        ldy     $60                             ; 8B24 A4 60                    .`
        sty     $58                             ; 8B26 84 58                    .X
        pla                                     ; 8B28 68                       h
        sei                                     ; 8B29 78                       x
        clc                                     ; 8B2A 18                       .
        plp                                     ; 8B2B 28                       (
        .byte   $D7                             ; 8B2C D7                       .
        plp                                     ; 8B2D 28                       (
        sec                                     ; 8B2E 38                       8
        .byte   $80                             ; 8B2F 80                       .
        bvc     L8B8A                           ; 8B30 50 58                    PX
        bvc     L8AB4                           ; 8B32 50 80                    P.
        rts                                     ; 8B34 60                       `

; ----------------------------------------------------------------------------
        rti                                     ; 8B35 40                       @

; ----------------------------------------------------------------------------
        bcc     L8AEC                           ; 8B36 90 B4                    ..
        brk                                     ; 8B38 00                       .
        .byte   $FF                             ; 8B39 FF                       .
        brk                                     ; 8B3A 00                       .
L8B3B:  brk                                     ; 8B3B 00                       .
        brk                                     ; 8B3C 00                       .
        brk                                     ; 8B3D 00                       .
        brk                                     ; 8B3E 00                       .
        brk                                     ; 8B3F 00                       .
        brk                                     ; 8B40 00                       .
        brk                                     ; 8B41 00                       .
        brk                                     ; 8B42 00                       .
        brk                                     ; 8B43 00                       .
        brk                                     ; 8B44 00                       .
        brk                                     ; 8B45 00                       .
        brk                                     ; 8B46 00                       .
        brk                                     ; 8B47 00                       .
        brk                                     ; 8B48 00                       .
        brk                                     ; 8B49 00                       .
        brk                                     ; 8B4A 00                       .
        brk                                     ; 8B4B 00                       .
        brk                                     ; 8B4C 00                       .
        brk                                     ; 8B4D 00                       .
        brk                                     ; 8B4E 00                       .
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
        brk                                     ; 8B5D 00                       .
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
        brk                                     ; 8B78 00                       .
        brk                                     ; 8B79 00                       .
L8B7A:  brk                                     ; 8B7A 00                       .
        brk                                     ; 8B7B 00                       .
        brk                                     ; 8B7C 00                       .
        brk                                     ; 8B7D 00                       .
        brk                                     ; 8B7E 00                       .
        brk                                     ; 8B7F 00                       .
        bne     L8BCA                           ; 8B80 D0 48                    .H
        cmp     ($14),y                         ; 8B82 D1 14                    ..
        rol     $14,x                           ; 8B84 36 14                    6.
        rol     $14,x                           ; 8B86 36 14                    6.
        .byte   $14                             ; 8B88 14                       .
        .byte   $36                             ; 8B89 36                       6
L8B8A:  rol     $14,x                           ; 8B8A 36 14                    6.
        .byte   $2F                             ; 8B8C 2F                       /
        rol     $6186                           ; 8B8D 2E 86 61                 ..a
        adc     ($84,x)                         ; 8B90 61 84                    a.
        and     $2083,y                         ; 8B92 39 83 20                 9. 
        adc     ($61,x)                         ; 8B95 61 61                    aa
        jsr     L6123                           ; 8B97 20 23 61                  #a
        cmp     ($36),y                         ; 8B9A D1 36                    .6
        and     $3636                           ; 8B9C 2D 36 36                 -66
        bne     L8BBE                           ; 8B9F D0 1D                    ..
        adc     ($61,x)                         ; 8BA1 61 61                    aa
        ora     $611D,x                         ; 8BA3 1D 1D 61                 ..a
        .byte   $0C                             ; 8BA6 0C                       .
        ora     ($01,x)                         ; 8BA7 01 01                    ..
        ora     ($01,x)                         ; 8BA9 01 01                    ..
        ora     ($8B,x)                         ; 8BAB 01 8B                    ..
        ora     ($01,x)                         ; 8BAD 01 01                    ..
        eor     #$33                            ; 8BAF 49 33                    I3
        .byte   $33                             ; 8BB1 33                       3
        .byte   $33                             ; 8BB2 33                       3
        .byte   $33                             ; 8BB3 33                       3
        .byte   $33                             ; 8BB4 33                       3
        .byte   $33                             ; 8BB5 33                       3
        .byte   $33                             ; 8BB6 33                       3
        ora     $FF64,x                         ; 8BB7 1D 64 FF                 .d.
        brk                                     ; 8BBA 00                       .
        brk                                     ; 8BBB 00                       .
        brk                                     ; 8BBC 00                       .
        brk                                     ; 8BBD 00                       .
L8BBE:  brk                                     ; 8BBE 00                       .
        brk                                     ; 8BBF 00                       .
        brk                                     ; 8BC0 00                       .
        brk                                     ; 8BC1 00                       .
        brk                                     ; 8BC2 00                       .
        brk                                     ; 8BC3 00                       .
        brk                                     ; 8BC4 00                       .
        brk                                     ; 8BC5 00                       .
        brk                                     ; 8BC6 00                       .
        brk                                     ; 8BC7 00                       .
        brk                                     ; 8BC8 00                       .
        brk                                     ; 8BC9 00                       .
L8BCA:  brk                                     ; 8BCA 00                       .
        .byte   $04                             ; 8BCB 04                       .
        brk                                     ; 8BCC 00                       .
        brk                                     ; 8BCD 00                       .
        brk                                     ; 8BCE 00                       .
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
L8BDF:  brk                                     ; 8BDF 00                       .
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
        brk                                     ; 8BF9 00                       .
        brk                                     ; 8BFA 00                       .
        brk                                     ; 8BFB 00                       .
        brk                                     ; 8BFC 00                       .
        brk                                     ; 8BFD 00                       .
        brk                                     ; 8BFE 00                       .
        brk                                     ; 8BFF 00                       .
        brk                                     ; 8C00 00                       .
        ora     ($03,x)                         ; 8C01 01 03                    ..
        .byte   $04                             ; 8C03 04                       .
        php                                     ; 8C04 08                       .
        .byte   $0C                             ; 8C05 0C                       .
        .byte   $0F                             ; 8C06 0F                       .
        ora     ($13),y                         ; 8C07 11 13                    ..
        asl     $1A,x                           ; 8C09 16 1A                    ..
        .byte   $1F                             ; 8C0B 1F                       .
        jsr     L2620                           ; 8C0C 20 20 26                   &
        .byte   $27                             ; 8C0F 27                       '
        .byte   $27                             ; 8C10 27                       '
        rol     a                               ; 8C11 2A                       *
        and     $302F                           ; 8C12 2D 2F 30                 -/0
        bmi     L8C47                           ; 8C15 30 30                    00
        .byte   $32                             ; 8C17 32                       2
        .byte   $34                             ; 8C18 34                       4
        .byte   $37                             ; 8C19 37                       7
        sec                                     ; 8C1A 38                       8
        sec                                     ; 8C1B 38                       8
        brk                                     ; 8C1C 00                       .
        brk                                     ; 8C1D 00                       .
        brk                                     ; 8C1E 00                       .
        bpl     L8C21                           ; 8C1F 10 00                    ..
L8C21:  brk                                     ; 8C21 00                       .
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
L8C47:  brk                                     ; 8C47 00                       .
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
L8C58:  brk                                     ; 8C58 00                       .
        brk                                     ; 8C59 00                       .
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
        brk                                     ; 8C8A 00                       .
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
        rti                                     ; 8CEA 40                       @

; ----------------------------------------------------------------------------
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
        php                                     ; 8CFE 08                       .
        brk                                     ; 8CFF 00                       .
        brk                                     ; 8D00 00                       .
        ora     ($03,x)                         ; 8D01 01 03                    ..
        ora     $04                             ; 8D03 05 04                    ..
        jsr     L6040                           ; 8D05 20 40 60                  @`
        .byte   $22                             ; 8D08 22                       "
        .byte   $22                             ; 8D09 22                       "
        .byte   $22                             ; 8D0A 22                       "
        .byte   $63                             ; 8D0B 63                       c
        lsr     $4A                             ; 8D0C 46 4A                    FJ
        bit     $4247                           ; 8D0E 2C 47 42                 ,GB
        .byte   $43                             ; 8D11 43                       C
        .byte   $24                             ; 8D12 24                       $
L8D13:  .byte   $64                             ; 8D13 64                       d
        plp                                     ; 8D14 28                       (
        rol     a                               ; 8D15 2A                       *
        pla                                     ; 8D16 68                       h
        sec                                     ; 8D17 38                       8
        .byte   $62                             ; 8D18 62                       b
        .byte   $74                             ; 8D19 74                       t
        .byte   $34                             ; 8D1A 34                       4
        rol     $0D                             ; 8D1B 26 0D                    &.
        .byte   $2B                             ; 8D1D 2B                       +
        pha                                     ; 8D1E 48                       H
        sec                                     ; 8D1F 38                       8
L8D20:  .byte   $07                             ; 8D20 07                       .
        ora     #$0B                            ; 8D21 09 0B                    ..
        cpy     $66                             ; 8D23 C4 66                    .f
        ror     a                               ; 8D25 6A                       j
        and     $C667                           ; 8D26 2D 67 C6                 -g.
        .byte   $A7                             ; 8D29 A7                       .
        iny                                     ; 8D2A C8                       .
        sty     $A8                             ; 8D2B 84 A8                    ..
        tay                                     ; 8D2D A8                       .
        tay                                     ; 8D2E A8                       .
        lda     #$A9                            ; 8D2F A9 A9                    ..
        stx     $88                             ; 8D31 86 88                    ..
        .byte   $89                             ; 8D33 89                       .
        .byte   $8B                             ; 8D34 8B                       .
        brk                                     ; 8D35 00                       .
        sta     a:$C0                           ; 8D36 8D C0 00                 ...
        sbc     ($E3,x)                         ; 8D39 E1 E3                    ..
        sbc     $E7                             ; 8D3B E5 E7                    ..
        sbc     #$C2                            ; 8D3D E9 C2                    ..
        bne     L8D13                           ; 8D3F D0 D2                    ..
        brk                                     ; 8D41 00                       .
        dec     $4746                           ; 8D42 CE 46 47                 .FG
        lsr     $4B                             ; 8D45 46 4B                    FK
        plp                                     ; 8D47 28                       (
        adc     #$D1                            ; 8D48 69 D1                    i.
        sty     $BC                             ; 8D4A 84 BC                    ..
        bne     L8D20                           ; 8D4C D0 D2                    ..
        pla                                     ; 8D4E 68                       h
        bpl     L8D51                           ; 8D4F 10 00                    ..
L8D51:  brk                                     ; 8D51 00                       .
        jmp     L000E                           ; 8D52 4C 0E 00                 L..

; ----------------------------------------------------------------------------
        bpl     L8DA1                           ; 8D55 10 4A                    .J
        brk                                     ; 8D57 00                       .
        brk                                     ; 8D58 00                       .
        jmp     (L107C)                         ; 8D59 6C 7C 10                 l|.

; ----------------------------------------------------------------------------
        rol     $100F                           ; 8D5C 2E 0F 10                 ...
        dec     $5D00,x                         ; 8D5F DE 00 5D                 ..]
        bpl     L8DD1                           ; 8D62 10 6D                    .m
        bpl     L8D76                           ; 8D64 10 10                    ..
        .byte   $1F                             ; 8D66 1F                       .
        brk                                     ; 8D67 00                       .
        brk                                     ; 8D68 00                       .
        lsr     $AF10                           ; 8D69 4E 10 AF                 N..
        .byte   $9E                             ; 8D6C 9E                       .
        bpl     L8D7F                           ; 8D6D 10 10                    ..
        .byte   $AF                             ; 8D6F AF                       .
        brk                                     ; 8D70 00                       .
        .byte   $6F                             ; 8D71 6F                       o
        lsr     L1010                           ; 8D72 4E 10 10                 N..
        .byte   $AF                             ; 8D75 AF                       .
L8D76:  .byte   $9E                             ; 8D76 9E                       .
        asl     $0700,x                         ; 8D77 1E 00 07                 ...
        brk                                     ; 8D7A 00                       .
        .byte   $6F                             ; 8D7B 6F                       o
        .byte   $9E                             ; 8D7C 9E                       .
        .byte   $EC                             ; 8D7D EC                       .
        .byte   $EE                             ; 8D7E EE                       .
L8D7F:  .byte   $0B                             ; 8D7F 0B                       .
        nop                                     ; 8D80 EA                       .
        cpy     a:L0000                         ; 8D81 CC 00 00                 ...
        brk                                     ; 8D84 00                       .
        brk                                     ; 8D85 00                       .
        brk                                     ; 8D86 00                       .
        brk                                     ; 8D87 00                       .
        dec     $4746                           ; 8D88 CE 46 47                 .FG
        plp                                     ; 8D8B 28                       (
        sec                                     ; 8D8C 38                       8
        ror     $67                             ; 8D8D 66 67                    fg
        ora     $1038                           ; 8D8F 0D 38 10                 .8.
        ldy     L8000,x                         ; 8D92 BC 00 80                 ...
        .byte   $82                             ; 8D95 82                       .
        brk                                     ; 8D96 00                       .
        brk                                     ; 8D97 00                       .
        bpl     L8DAA                           ; 8D98 10 10                    ..
        brk                                     ; 8D9A 00                       .
        brk                                     ; 8D9B 00                       .
        ldy     #$A2                            ; 8D9C A0 A2                    ..
        brk                                     ; 8D9E 00                       .
        brk                                     ; 8D9F 00                       .
        brk                                     ; 8DA0 00                       .
L8DA1:  brk                                     ; 8DA1 00                       .
        brk                                     ; 8DA2 00                       .
        brk                                     ; 8DA3 00                       .
        brk                                     ; 8DA4 00                       .
        brk                                     ; 8DA5 00                       .
        brk                                     ; 8DA6 00                       .
        brk                                     ; 8DA7 00                       .
        brk                                     ; 8DA8 00                       .
        brk                                     ; 8DA9 00                       .
L8DAA:  brk                                     ; 8DAA 00                       .
        brk                                     ; 8DAB 00                       .
        brk                                     ; 8DAC 00                       .
        brk                                     ; 8DAD 00                       .
        brk                                     ; 8DAE 00                       .
        brk                                     ; 8DAF 00                       .
        brk                                     ; 8DB0 00                       .
        brk                                     ; 8DB1 00                       .
        brk                                     ; 8DB2 00                       .
        brk                                     ; 8DB3 00                       .
        brk                                     ; 8DB4 00                       .
        brk                                     ; 8DB5 00                       .
        brk                                     ; 8DB6 00                       .
        brk                                     ; 8DB7 00                       .
        brk                                     ; 8DB8 00                       .
        brk                                     ; 8DB9 00                       .
        brk                                     ; 8DBA 00                       .
        brk                                     ; 8DBB 00                       .
        brk                                     ; 8DBC 00                       .
        brk                                     ; 8DBD 00                       .
        brk                                     ; 8DBE 00                       .
        brk                                     ; 8DBF 00                       .
        brk                                     ; 8DC0 00                       .
        brk                                     ; 8DC1 00                       .
        brk                                     ; 8DC2 00                       .
        brk                                     ; 8DC3 00                       .
        brk                                     ; 8DC4 00                       .
        brk                                     ; 8DC5 00                       .
        brk                                     ; 8DC6 00                       .
        brk                                     ; 8DC7 00                       .
        brk                                     ; 8DC8 00                       .
        brk                                     ; 8DC9 00                       .
        brk                                     ; 8DCA 00                       .
        brk                                     ; 8DCB 00                       .
        brk                                     ; 8DCC 00                       .
        brk                                     ; 8DCD 00                       .
        brk                                     ; 8DCE 00                       .
        brk                                     ; 8DCF 00                       .
        brk                                     ; 8DD0 00                       .
L8DD1:  brk                                     ; 8DD1 00                       .
        brk                                     ; 8DD2 00                       .
        brk                                     ; 8DD3 00                       .
        brk                                     ; 8DD4 00                       .
        brk                                     ; 8DD5 00                       .
        brk                                     ; 8DD6 00                       .
        brk                                     ; 8DD7 00                       .
        brk                                     ; 8DD8 00                       .
        brk                                     ; 8DD9 00                       .
        brk                                     ; 8DDA 00                       .
        brk                                     ; 8DDB 00                       .
        brk                                     ; 8DDC 00                       .
        brk                                     ; 8DDD 00                       .
        brk                                     ; 8DDE 00                       .
        brk                                     ; 8DDF 00                       .
        brk                                     ; 8DE0 00                       .
        brk                                     ; 8DE1 00                       .
        brk                                     ; 8DE2 00                       .
        brk                                     ; 8DE3 00                       .
        brk                                     ; 8DE4 00                       .
        brk                                     ; 8DE5 00                       .
        brk                                     ; 8DE6 00                       .
        brk                                     ; 8DE7 00                       .
        brk                                     ; 8DE8 00                       .
        brk                                     ; 8DE9 00                       .
        brk                                     ; 8DEA 00                       .
        brk                                     ; 8DEB 00                       .
        brk                                     ; 8DEC 00                       .
        brk                                     ; 8DED 00                       .
        brk                                     ; 8DEE 00                       .
        brk                                     ; 8DEF 00                       .
        brk                                     ; 8DF0 00                       .
        brk                                     ; 8DF1 00                       .
        brk                                     ; 8DF2 00                       .
        brk                                     ; 8DF3 00                       .
        brk                                     ; 8DF4 00                       .
        brk                                     ; 8DF5 00                       .
        brk                                     ; 8DF6 00                       .
        brk                                     ; 8DF7 00                       .
        brk                                     ; 8DF8 00                       .
        brk                                     ; 8DF9 00                       .
        brk                                     ; 8DFA 00                       .
        brk                                     ; 8DFB 00                       .
        brk                                     ; 8DFC 00                       .
        brk                                     ; 8DFD 00                       .
        brk                                     ; 8DFE 00                       .
        brk                                     ; 8DFF 00                       .
        brk                                     ; 8E00 00                       .
        .byte   $02                             ; 8E01 02                       .
        .byte   $04                             ; 8E02 04                       .
        brk                                     ; 8E03 00                       .
        ora     L0021                           ; 8E04 05 21                    .!
        eor     ($61,x)                         ; 8E06 41 61                    Aa
        .byte   $23                             ; 8E08 23                       #
        .byte   $23                             ; 8E09 23                       #
        .byte   $23                             ; 8E0A 23                       #
        asl     $47                             ; 8E0B 06 47                    .G
        .byte   $4B                             ; 8E0D 4B                       K
        .byte   $4B                             ; 8E0E 4B                       K
        .byte   $46                             ; 8E0F 46                       F
L8E10:  .byte   $43                             ; 8E10 43                       C
        ldy     $6525                           ; 8E11 AC 25 65                 .%e
        and     #$2A                            ; 8E14 29 2A                    )*
        adc     #$39                            ; 8E16 69 39                    i9
        .byte   $63                             ; 8E18 63                       c
        adc     $35,x                           ; 8E19 75 35                    u5
        .byte   $27                             ; 8E1B 27                       '
        and     #$D9                            ; 8E1C 29 D9                    ).
        eor     #$1D                            ; 8E1E 49 1D                    I.
        php                                     ; 8E20 08                       .
        asl     a                               ; 8E21 0A                       .
        .byte   $0C                             ; 8E22 0C                       .
        cmp     $67                             ; 8E23 C5 67                    .g
        .byte   $6B                             ; 8E25 6B                       k
        .byte   $6B                             ; 8E26 6B                       k
        ror     $C7                             ; 8E27 66 C7                    f.
        brk                                     ; 8E29 00                       .
        iny                                     ; 8E2A C8                       .
        sta     $85                             ; 8E2B 85 85                    ..
        lda     $A8                             ; 8E2D A5 A8                    ..
        tay                                     ; 8E2F A8                       .
        ldy     $87                             ; 8E30 A4 87                    ..
        brk                                     ; 8E32 00                       .
        txa                                     ; 8E33 8A                       .
        sty     $A600                           ; 8E34 8C 00 A6                 ...
        cmp     ($E0,x)                         ; 8E37 C1 E0                    ..
        .byte   $E2                             ; 8E39 E2                       .
        cpx     $E6                             ; 8E3A E4 E6                    ..
        inx                                     ; 8E3C E8                       .
        brk                                     ; 8E3D 00                       .
        .byte   $C3                             ; 8E3E C3                       .
        cmp     ($D3),y                         ; 8E3F D1 D3                    ..
        brk                                     ; 8E41 00                       .
        .byte   $CF                             ; 8E42 CF                       .
        .byte   $47                             ; 8E43 47                       G
        lsr     $4A                             ; 8E44 46 4A                    FJ
        lsr     $68                             ; 8E46 46 68                    Fh
        and     $A4D2,y                         ; 8E48 39 D2 A4                 9..
        lda     $D3D1,x                         ; 8E4B BD D1 D3                 ...
        adc     #$10                            ; 8E4E 69 10                    i.
        brk                                     ; 8E50 00                       .
        brk                                     ; 8E51 00                       .
        eor     a:$0F                           ; 8E52 4D 0F 00                 M..
        cmp     #$4B                            ; 8E55 C9 4B                    .K
        brk                                     ; 8E57 00                       .
        jmp     L106D                           ; 8E58 4C 6D 10                 Lm.

; ----------------------------------------------------------------------------
        bpl     L8E8C                           ; 8E5B 10 2F                    ./
        brk                                     ; 8E5D 00                       .
        .byte   $4F                             ; 8E5E 4F                       O
        .byte   $DF                             ; 8E5F DF                       .
        jmp     L107C                           ; 8E60 4C 7C 10                 L|.

; ----------------------------------------------------------------------------
        .byte   $7C                             ; 8E63 7C                       |
        bpl     L8E84                           ; 8E64 10 1E                    ..
        brk                                     ; 8E66 00                       .
        brk                                     ; 8E67 00                       .
        ror     $AE4F                           ; 8E68 6E 4F AE                 nO.
        .byte   $BF                             ; 8E6B BF                       .
        .byte   $9F                             ; 8E6C 9F                       .
        .byte   $3F                             ; 8E6D 3F                       ?
        ldx     $6E9F                           ; 8E6E AE 9F 6E                 ..n
        ror     $104F,x                         ; 8E71 7E 4F 10                 ~O.
        ldx     L9FBF                           ; 8E74 AE BF 9F                 ...
        .byte   $1F                             ; 8E77 1F                       .
        jmp     L6E08                           ; 8E78 4C 08 6E                 L.n

; ----------------------------------------------------------------------------
        ror     $ED9F,x                         ; 8E7B 7E 9F ED                 ~..
        .byte   $EF                             ; 8E7E EF                       .
        .byte   $0C                             ; 8E7F 0C                       .
        .byte   $EB                             ; 8E80 EB                       .
        cmp     a:L0000                         ; 8E81 CD 00 00                 ...
L8E84:  brk                                     ; 8E84 00                       .
        brk                                     ; 8E85 00                       .
        brk                                     ; 8E86 00                       .
        brk                                     ; 8E87 00                       .
        .byte   $CF                             ; 8E88 CF                       .
        .byte   $47                             ; 8E89 47                       G
        lsr     $29                             ; 8E8A 46 29                    F)
L8E8C:  and     $6667,y                         ; 8E8C 39 67 66                 9gf
        and     #$1D                            ; 8E8F 29 1D                    ).
        cmp     #$BD                            ; 8E91 C9 BD                    ..
        brk                                     ; 8E93 00                       .
        sta     ($83,x)                         ; 8E94 81 83                    ..
        brk                                     ; 8E96 00                       .
        brk                                     ; 8E97 00                       .
        bpl     L8EAA                           ; 8E98 10 10                    ..
        brk                                     ; 8E9A 00                       .
        brk                                     ; 8E9B 00                       .
        lda     ($A3,x)                         ; 8E9C A1 A3                    ..
        brk                                     ; 8E9E 00                       .
        brk                                     ; 8E9F 00                       .
        brk                                     ; 8EA0 00                       .
        brk                                     ; 8EA1 00                       .
        brk                                     ; 8EA2 00                       .
        brk                                     ; 8EA3 00                       .
        brk                                     ; 8EA4 00                       .
        brk                                     ; 8EA5 00                       .
        brk                                     ; 8EA6 00                       .
        brk                                     ; 8EA7 00                       .
        brk                                     ; 8EA8 00                       .
        brk                                     ; 8EA9 00                       .
L8EAA:  brk                                     ; 8EAA 00                       .
        brk                                     ; 8EAB 00                       .
        brk                                     ; 8EAC 00                       .
        brk                                     ; 8EAD 00                       .
        brk                                     ; 8EAE 00                       .
        brk                                     ; 8EAF 00                       .
        brk                                     ; 8EB0 00                       .
        brk                                     ; 8EB1 00                       .
        brk                                     ; 8EB2 00                       .
        brk                                     ; 8EB3 00                       .
        brk                                     ; 8EB4 00                       .
        brk                                     ; 8EB5 00                       .
        brk                                     ; 8EB6 00                       .
        brk                                     ; 8EB7 00                       .
        brk                                     ; 8EB8 00                       .
        brk                                     ; 8EB9 00                       .
        brk                                     ; 8EBA 00                       .
        brk                                     ; 8EBB 00                       .
        brk                                     ; 8EBC 00                       .
        brk                                     ; 8EBD 00                       .
        brk                                     ; 8EBE 00                       .
        brk                                     ; 8EBF 00                       .
        brk                                     ; 8EC0 00                       .
        brk                                     ; 8EC1 00                       .
        brk                                     ; 8EC2 00                       .
        brk                                     ; 8EC3 00                       .
        brk                                     ; 8EC4 00                       .
        brk                                     ; 8EC5 00                       .
        brk                                     ; 8EC6 00                       .
        brk                                     ; 8EC7 00                       .
        brk                                     ; 8EC8 00                       .
        brk                                     ; 8EC9 00                       .
        brk                                     ; 8ECA 00                       .
        brk                                     ; 8ECB 00                       .
        brk                                     ; 8ECC 00                       .
        brk                                     ; 8ECD 00                       .
        brk                                     ; 8ECE 00                       .
        brk                                     ; 8ECF 00                       .
        brk                                     ; 8ED0 00                       .
        brk                                     ; 8ED1 00                       .
        brk                                     ; 8ED2 00                       .
        brk                                     ; 8ED3 00                       .
        brk                                     ; 8ED4 00                       .
        brk                                     ; 8ED5 00                       .
        brk                                     ; 8ED6 00                       .
        brk                                     ; 8ED7 00                       .
        brk                                     ; 8ED8 00                       .
        brk                                     ; 8ED9 00                       .
        brk                                     ; 8EDA 00                       .
        brk                                     ; 8EDB 00                       .
        brk                                     ; 8EDC 00                       .
        brk                                     ; 8EDD 00                       .
        brk                                     ; 8EDE 00                       .
        brk                                     ; 8EDF 00                       .
        brk                                     ; 8EE0 00                       .
        brk                                     ; 8EE1 00                       .
        brk                                     ; 8EE2 00                       .
        brk                                     ; 8EE3 00                       .
        brk                                     ; 8EE4 00                       .
        brk                                     ; 8EE5 00                       .
        brk                                     ; 8EE6 00                       .
        brk                                     ; 8EE7 00                       .
        brk                                     ; 8EE8 00                       .
        brk                                     ; 8EE9 00                       .
        brk                                     ; 8EEA 00                       .
        brk                                     ; 8EEB 00                       .
        brk                                     ; 8EEC 00                       .
        brk                                     ; 8EED 00                       .
        brk                                     ; 8EEE 00                       .
        brk                                     ; 8EEF 00                       .
        brk                                     ; 8EF0 00                       .
        brk                                     ; 8EF1 00                       .
        brk                                     ; 8EF2 00                       .
        brk                                     ; 8EF3 00                       .
        brk                                     ; 8EF4 00                       .
        brk                                     ; 8EF5 00                       .
        brk                                     ; 8EF6 00                       .
        brk                                     ; 8EF7 00                       .
        brk                                     ; 8EF8 00                       .
        brk                                     ; 8EF9 00                       .
        brk                                     ; 8EFA 00                       .
        brk                                     ; 8EFB 00                       .
        brk                                     ; 8EFC 00                       .
        brk                                     ; 8EFD 00                       .
        brk                                     ; 8EFE 00                       .
        brk                                     ; 8EFF 00                       .
        brk                                     ; 8F00 00                       .
        ora     ($13),y                         ; 8F01 11 13                    ..
        ora     $14,x                           ; 8F03 15 14                    ..
        bmi     L8F57                           ; 8F05 30 50                    0P
        bvs     L8F3B                           ; 8F07 70 32                    p2
L8F09:  tax                                     ; 8F09 AA                       .
        bit     $54                             ; 8F0A 24 54                    $T
        lsr     $5A,x                           ; 8F0C 56 5A                    VZ
        .byte   $3C                             ; 8F0E 3C                       <
        .byte   $57                             ; 8F0F 57                       W
        .byte   $52                             ; 8F10 52                       R
        .byte   $43                             ; 8F11 43                       C
        bit     $53                             ; 8F12 24 53                    $S
        ora     $783A                           ; 8F14 0D 3A 78                 .:x
        sec                                     ; 8F17 38                       8
        .byte   $72                             ; 8F18 72                       r
        .byte   $54                             ; 8F19 54                       T
        .byte   $44                             ; 8F1A 44                       D
        rol     $0D,x                           ; 8F1B 36 0D                    6.
        .byte   $3B                             ; 8F1D 3B                       ;
        cli                                     ; 8F1E 58                       X
        sec                                     ; 8F1F 38                       8
        .byte   $17                             ; 8F20 17                       .
        ora     $D41B,y                         ; 8F21 19 1B D4                 ...
        ror     $7A,x                           ; 8F24 76 7A                    vz
        and     $D677,x                         ; 8F26 3D 77 D6                 =w.
        brk                                     ; 8F29 00                       .
        iny                                     ; 8F2A C8                       .
        sty     $B8,x                           ; 8F2B 94 B8                    ..
        clv                                     ; 8F2D B8                       .
        clv                                     ; 8F2E B8                       .
        .byte   $B9                             ; 8F2F B9                       .
        .byte   $B9                             ; 8F30 B9                       .
L8F31:  stx     $98,y                           ; 8F31 96 98                    ..
        sta     $AD9B,y                         ; 8F33 99 9B AD                 ...
        sta     a:$D0,x                         ; 8F36 9D D0 00                 ...
        sbc     ($F3),y                         ; 8F39 F1 F3                    ..
L8F3B:  sbc     $F7,x                           ; 8F3B F5 F7                    ..
        sbc     $D0D2,y                         ; 8F3D F9 D2 D0                 ...
        .byte   $D2                             ; 8F40 D2                       .
        brk                                     ; 8F41 00                       .
        dec     $7776                           ; 8F42 CE 76 77                 .vw
        lsr     $5B,x                           ; 8F45 56 5B                    V[
        ora     $D179                           ; 8F47 0D 79 D1                 .y.
        sty     $BA,x                           ; 8F4A 94 BA                    ..
        bne     L8F09                           ; 8F4C D0 BB                    ..
        cmp     #$10                            ; 8F4E C9 10                    ..
L8F50:  brk                                     ; 8F50 00                       .
        brk                                     ; 8F51 00                       .
        eor     $1F10,x                         ; 8F52 5D 10 1F                 ]..
        bpl     L8F31                           ; 8F55 10 DA                    ..
L8F57:  brk                                     ; 8F57 00                       .
        .byte   $5C                             ; 8F58 5C                       \
        bpl     L8F6B                           ; 8F59 10 10                    ..
        bpl     L8F6D                           ; 8F5B 10 10                    ..
        asl     $DE10,x                         ; 8F5D 1E 10 DE                 ...
        jmp     L1010                           ; 8F60 4C 10 10                 L..

; ----------------------------------------------------------------------------
        bpl     L8F75                           ; 8F63 10 10                    ..
        bpl     L8F95                           ; 8F65 10 2E                    ..
        .byte   $0F                             ; 8F67 0F                       .
        brk                                     ; 8F68 00                       .
        .byte   $5E                             ; 8F69 5E                       ^
        .byte   $8E                             ; 8F6A 8E                       .
L8F6B:  brk                                     ; 8F6B 00                       .
        brk                                     ; 8F6C 00                       .
L8F6D:  stx     a:$10                           ; 8F6D 8E 10 00                 ...
        brk                                     ; 8F70 00                       .
        brk                                     ; 8F71 00                       .
        lsr     L8E10,x                         ; 8F72 5E 10 8E                 ^..
L8F75:  brk                                     ; 8F75 00                       .
        brk                                     ; 8F76 00                       .
        bpl     L8F79                           ; 8F77 10 00                    ..
L8F79:  .byte   $17                             ; 8F79 17                       .
        brk                                     ; 8F7A 00                       .
        brk                                     ; 8F7B 00                       .
        brk                                     ; 8F7C 00                       .
        .byte   $FC                             ; 8F7D FC                       .
        inc     $FA1B,x                         ; 8F7E FE 1B FA                 ...
        .byte   $DC                             ; 8F81 DC                       .
        brk                                     ; 8F82 00                       .
        brk                                     ; 8F83 00                       .
        brk                                     ; 8F84 00                       .
        brk                                     ; 8F85 00                       .
        brk                                     ; 8F86 00                       .
        brk                                     ; 8F87 00                       .
        dec     $5756                           ; 8F88 CE 56 57                 .VW
        ora     $7638                           ; 8F8B 0D 38 76                 .8v
        .byte   $77                             ; 8F8E 77                       w
        ora     $1038                           ; 8F8F 0D 38 10                 .8.
        ldy     L9000,x                         ; 8F92 BC 00 90                 ...
L8F95:  .byte   $92                             ; 8F95 92                       .
        brk                                     ; 8F96 00                       .
        brk                                     ; 8F97 00                       .
        .byte   $B7                             ; 8F98 B7                       .
        bpl     L8F9B                           ; 8F99 10 00                    ..
L8F9B:  brk                                     ; 8F9B 00                       .
        bcs     L8F50                           ; 8F9C B0 B2                    ..
        brk                                     ; 8F9E 00                       .
        brk                                     ; 8F9F 00                       .
        brk                                     ; 8FA0 00                       .
        brk                                     ; 8FA1 00                       .
        brk                                     ; 8FA2 00                       .
        brk                                     ; 8FA3 00                       .
        brk                                     ; 8FA4 00                       .
        brk                                     ; 8FA5 00                       .
        brk                                     ; 8FA6 00                       .
        brk                                     ; 8FA7 00                       .
        brk                                     ; 8FA8 00                       .
        brk                                     ; 8FA9 00                       .
        brk                                     ; 8FAA 00                       .
        brk                                     ; 8FAB 00                       .
        brk                                     ; 8FAC 00                       .
        brk                                     ; 8FAD 00                       .
        brk                                     ; 8FAE 00                       .
        brk                                     ; 8FAF 00                       .
        brk                                     ; 8FB0 00                       .
        brk                                     ; 8FB1 00                       .
        brk                                     ; 8FB2 00                       .
        brk                                     ; 8FB3 00                       .
        brk                                     ; 8FB4 00                       .
        brk                                     ; 8FB5 00                       .
        brk                                     ; 8FB6 00                       .
        brk                                     ; 8FB7 00                       .
        brk                                     ; 8FB8 00                       .
        brk                                     ; 8FB9 00                       .
        brk                                     ; 8FBA 00                       .
        brk                                     ; 8FBB 00                       .
        brk                                     ; 8FBC 00                       .
        brk                                     ; 8FBD 00                       .
        brk                                     ; 8FBE 00                       .
        brk                                     ; 8FBF 00                       .
        brk                                     ; 8FC0 00                       .
        brk                                     ; 8FC1 00                       .
        brk                                     ; 8FC2 00                       .
        brk                                     ; 8FC3 00                       .
        brk                                     ; 8FC4 00                       .
        brk                                     ; 8FC5 00                       .
        brk                                     ; 8FC6 00                       .
        brk                                     ; 8FC7 00                       .
        brk                                     ; 8FC8 00                       .
        brk                                     ; 8FC9 00                       .
        brk                                     ; 8FCA 00                       .
        brk                                     ; 8FCB 00                       .
        brk                                     ; 8FCC 00                       .
        brk                                     ; 8FCD 00                       .
        brk                                     ; 8FCE 00                       .
        brk                                     ; 8FCF 00                       .
        brk                                     ; 8FD0 00                       .
        brk                                     ; 8FD1 00                       .
        brk                                     ; 8FD2 00                       .
        brk                                     ; 8FD3 00                       .
        brk                                     ; 8FD4 00                       .
        brk                                     ; 8FD5 00                       .
        brk                                     ; 8FD6 00                       .
        brk                                     ; 8FD7 00                       .
        brk                                     ; 8FD8 00                       .
        brk                                     ; 8FD9 00                       .
        brk                                     ; 8FDA 00                       .
        brk                                     ; 8FDB 00                       .
        brk                                     ; 8FDC 00                       .
        brk                                     ; 8FDD 00                       .
        brk                                     ; 8FDE 00                       .
        brk                                     ; 8FDF 00                       .
        brk                                     ; 8FE0 00                       .
        brk                                     ; 8FE1 00                       .
        brk                                     ; 8FE2 00                       .
        brk                                     ; 8FE3 00                       .
        brk                                     ; 8FE4 00                       .
        brk                                     ; 8FE5 00                       .
        brk                                     ; 8FE6 00                       .
        brk                                     ; 8FE7 00                       .
        brk                                     ; 8FE8 00                       .
        brk                                     ; 8FE9 00                       .
        brk                                     ; 8FEA 00                       .
        brk                                     ; 8FEB 00                       .
        brk                                     ; 8FEC 00                       .
        brk                                     ; 8FED 00                       .
        brk                                     ; 8FEE 00                       .
        brk                                     ; 8FEF 00                       .
        brk                                     ; 8FF0 00                       .
        brk                                     ; 8FF1 00                       .
        brk                                     ; 8FF2 00                       .
        brk                                     ; 8FF3 00                       .
        brk                                     ; 8FF4 00                       .
        brk                                     ; 8FF5 00                       .
        brk                                     ; 8FF6 00                       .
        brk                                     ; 8FF7 00                       .
        brk                                     ; 8FF8 00                       .
        brk                                     ; 8FF9 00                       .
        brk                                     ; 8FFA 00                       .
        brk                                     ; 8FFB 00                       .
        brk                                     ; 8FFC 00                       .
        brk                                     ; 8FFD 00                       .
        brk                                     ; 8FFE 00                       .
        brk                                     ; 8FFF 00                       .
L9000:  brk                                     ; 9000 00                       .
        .byte   $12                             ; 9001 12                       .
        .byte   $14                             ; 9002 14                       .
        brk                                     ; 9003 00                       .
L9004:  ora     $31,x                           ; 9004 15 31                    .1
        eor     ($71),y                         ; 9006 51 71                    Qq
        .byte   $33                             ; 9008 33                       3
        .byte   $AB                             ; 9009 AB                       .
        and     $16                             ; 900A 25 16                    %.
        .byte   $57                             ; 900C 57                       W
        .byte   $5B                             ; 900D 5B                       [
        .byte   $5B                             ; 900E 5B                       [
        lsr     $43,x                           ; 900F 56 43                    VC
        ldy     $7325                           ; 9011 AC 25 73                 .%s
        and     #$D8                            ; 9014 29 D8                    ).
        adc     $731D,y                         ; 9016 79 1D 73                 y.s
        eor     $45,x                           ; 9019 55 45                    UE
        .byte   $37                             ; 901B 37                       7
        and     #$3B                            ; 901C 29 3B                    );
        eor     $181D,y                         ; 901E 59 1D 18                 Y..
        .byte   $1A                             ; 9021 1A                       .
        .byte   $1C                             ; 9022 1C                       .
        cmp     $77,x                           ; 9023 D5 77                    .w
        .byte   $7B                             ; 9025 7B                       {
        .byte   $7B                             ; 9026 7B                       {
        ror     $D7,x                           ; 9027 76 D7                    v.
        brk                                     ; 9029 00                       .
        iny                                     ; 902A C8                       .
        .byte   $95                             ; 902B 95                       .
L902C:  sta     $B5,x                           ; 902C 95 B5                    ..
        clv                                     ; 902E B8                       .
        clv                                     ; 902F B8                       .
        ldy     $97,x                           ; 9030 B4 97                    ..
        lda     L9C9A                           ; 9032 AD 9A 9C                 ...
        lda     $D1B6                           ; 9035 AD B6 D1                 ...
        beq     L902C                           ; 9038 F0 F2                    ..
        .byte   $F4                             ; 903A F4                       .
        inc     $F8,x                           ; 903B F6 F8                    ..
        brk                                     ; 903D 00                       .
        .byte   $D3                             ; 903E D3                       .
L903F:  cmp     ($D3),y                         ; 903F D1 D3                    ..
        brk                                     ; 9041 00                       .
        .byte   $CF                             ; 9042 CF                       .
        .byte   $77                             ; 9043 77                       w
        ror     $5A,x                           ; 9044 76 5A                    vZ
        lsr     $78,x                           ; 9046 56 78                    Vx
        ora     $B4D2,x                         ; 9048 1D D2 B4                 ...
        .byte   $BB                             ; 904B BB                       .
        tsx                                     ; 904C BA                       .
        .byte   $D3                             ; 904D D3                       .
        .byte   $79                             ; 904E 79                       y
        .byte   $10                             ; 904F 10                       .
L9050:  brk                                     ; 9050 00                       .
        .byte   $5C                             ; 9051 5C                       \
        bpl     L9072                           ; 9052 10 1E                    ..
        brk                                     ; 9054 00                       .
        bpl     L90B2                           ; 9055 10 5B                    .[
        brk                                     ; 9057 00                       .
        eor     L1010,x                         ; 9058 5D 10 10                 ]..
        bpl     L906D                           ; 905B 10 10                    ..
        .byte   $1F                             ; 905D 1F                       .
        bpl     L903F                           ; 905E 10 DF                    ..
        eor     L1010,x                         ; 9060 5D 10 10                 ]..
        bpl     L90D2                           ; 9063 10 6D                    .m
        bpl     L9096                           ; 9065 10 2F                    ./
        brk                                     ; 9067 00                       .
        brk                                     ; 9068 00                       .
        .byte   $5F                             ; 9069 5F                       _
        .byte   $8F                             ; 906A 8F                       .
        brk                                     ; 906B 00                       .
        brk                                     ; 906C 00                       .
L906D:  .byte   $8F                             ; 906D 8F                       .
        .byte   $8F                             ; 906E 8F                       .
        brk                                     ; 906F 00                       .
        brk                                     ; 9070 00                       .
        brk                                     ; 9071 00                       .
L9072:  .byte   $5F                             ; 9072 5F                       _
        bpl     L9004                           ; 9073 10 8F                    ..
        brk                                     ; 9075 00                       .
        brk                                     ; 9076 00                       .
        asl     $187D,x                         ; 9077 1E 7D 18                 .}.
        brk                                     ; 907A 00                       .
        brk                                     ; 907B 00                       .
        brk                                     ; 907C 00                       .
        sbc     $1CFF,x                         ; 907D FD FF 1C                 ...
        .byte   $FB                             ; 9080 FB                       .
        cmp     a:L0000,x                       ; 9081 DD 00 00                 ...
        brk                                     ; 9084 00                       .
        brk                                     ; 9085 00                       .
        brk                                     ; 9086 00                       .
        brk                                     ; 9087 00                       .
        .byte   $CF                             ; 9088 CF                       .
        .byte   $57                             ; 9089 57                       W
        lsr     $29,x                           ; 908A 56 29                    V)
        ora     $7677,x                         ; 908C 1D 77 76                 .wv
        and     #$1D                            ; 908F 29 1D                    ).
        bpl     L9050                           ; 9091 10 BD                    ..
        brk                                     ; 9093 00                       .
        sta     ($93),y                         ; 9094 91 93                    ..
L9096:  brk                                     ; 9096 00                       .
        brk                                     ; 9097 00                       .
        bpl     L90AA                           ; 9098 10 10                    ..
        brk                                     ; 909A 00                       .
        brk                                     ; 909B 00                       .
        lda     ($B3),y                         ; 909C B1 B3                    ..
        brk                                     ; 909E 00                       .
        brk                                     ; 909F 00                       .
        brk                                     ; 90A0 00                       .
        brk                                     ; 90A1 00                       .
        brk                                     ; 90A2 00                       .
        brk                                     ; 90A3 00                       .
        brk                                     ; 90A4 00                       .
        brk                                     ; 90A5 00                       .
        brk                                     ; 90A6 00                       .
        brk                                     ; 90A7 00                       .
        brk                                     ; 90A8 00                       .
        brk                                     ; 90A9 00                       .
L90AA:  brk                                     ; 90AA 00                       .
        brk                                     ; 90AB 00                       .
        brk                                     ; 90AC 00                       .
        brk                                     ; 90AD 00                       .
        brk                                     ; 90AE 00                       .
        brk                                     ; 90AF 00                       .
        brk                                     ; 90B0 00                       .
        brk                                     ; 90B1 00                       .
L90B2:  brk                                     ; 90B2 00                       .
        brk                                     ; 90B3 00                       .
        brk                                     ; 90B4 00                       .
        brk                                     ; 90B5 00                       .
        brk                                     ; 90B6 00                       .
        brk                                     ; 90B7 00                       .
        brk                                     ; 90B8 00                       .
        brk                                     ; 90B9 00                       .
        brk                                     ; 90BA 00                       .
        brk                                     ; 90BB 00                       .
        brk                                     ; 90BC 00                       .
        brk                                     ; 90BD 00                       .
        brk                                     ; 90BE 00                       .
        brk                                     ; 90BF 00                       .
        brk                                     ; 90C0 00                       .
        brk                                     ; 90C1 00                       .
        brk                                     ; 90C2 00                       .
        brk                                     ; 90C3 00                       .
        brk                                     ; 90C4 00                       .
        brk                                     ; 90C5 00                       .
        brk                                     ; 90C6 00                       .
        brk                                     ; 90C7 00                       .
        brk                                     ; 90C8 00                       .
        brk                                     ; 90C9 00                       .
        brk                                     ; 90CA 00                       .
        brk                                     ; 90CB 00                       .
        brk                                     ; 90CC 00                       .
        brk                                     ; 90CD 00                       .
        brk                                     ; 90CE 00                       .
        brk                                     ; 90CF 00                       .
        brk                                     ; 90D0 00                       .
        brk                                     ; 90D1 00                       .
L90D2:  brk                                     ; 90D2 00                       .
        brk                                     ; 90D3 00                       .
        brk                                     ; 90D4 00                       .
        brk                                     ; 90D5 00                       .
        brk                                     ; 90D6 00                       .
        brk                                     ; 90D7 00                       .
        brk                                     ; 90D8 00                       .
        brk                                     ; 90D9 00                       .
        brk                                     ; 90DA 00                       .
        brk                                     ; 90DB 00                       .
        brk                                     ; 90DC 00                       .
        brk                                     ; 90DD 00                       .
        brk                                     ; 90DE 00                       .
        brk                                     ; 90DF 00                       .
        brk                                     ; 90E0 00                       .
        brk                                     ; 90E1 00                       .
        brk                                     ; 90E2 00                       .
        brk                                     ; 90E3 00                       .
        brk                                     ; 90E4 00                       .
        brk                                     ; 90E5 00                       .
        brk                                     ; 90E6 00                       .
        brk                                     ; 90E7 00                       .
        brk                                     ; 90E8 00                       .
        brk                                     ; 90E9 00                       .
        brk                                     ; 90EA 00                       .
        brk                                     ; 90EB 00                       .
        brk                                     ; 90EC 00                       .
        brk                                     ; 90ED 00                       .
        brk                                     ; 90EE 00                       .
        brk                                     ; 90EF 00                       .
        brk                                     ; 90F0 00                       .
        brk                                     ; 90F1 00                       .
        brk                                     ; 90F2 00                       .
        brk                                     ; 90F3 00                       .
        brk                                     ; 90F4 00                       .
        brk                                     ; 90F5 00                       .
        brk                                     ; 90F6 00                       .
        brk                                     ; 90F7 00                       .
        brk                                     ; 90F8 00                       .
        brk                                     ; 90F9 00                       .
        brk                                     ; 90FA 00                       .
        brk                                     ; 90FB 00                       .
        brk                                     ; 90FC 00                       .
        brk                                     ; 90FD 00                       .
        brk                                     ; 90FE 00                       .
        brk                                     ; 90FF 00                       .
        brk                                     ; 9100 00                       .
        brk                                     ; 9101 00                       .
        brk                                     ; 9102 00                       .
        brk                                     ; 9103 00                       .
        brk                                     ; 9104 00                       .
        .byte   $12                             ; 9105 12                       .
        .byte   $12                             ; 9106 12                       .
        .byte   $12                             ; 9107 12                       .
        .byte   $12                             ; 9108 12                       .
        .byte   $12                             ; 9109 12                       .
        .byte   $12                             ; 910A 12                       .
        .byte   $12                             ; 910B 12                       .
        .byte   $12                             ; 910C 12                       .
        ora     ($10),y                         ; 910D 11 10                    ..
        .byte   $12                             ; 910F 12                       .
        .byte   $12                             ; 9110 12                       .
        .byte   $12                             ; 9111 12                       .
        .byte   $12                             ; 9112 12                       .
        .byte   $12                             ; 9113 12                       .
        .byte   $12                             ; 9114 12                       .
        bpl     L9128                           ; 9115 10 11                    ..
        .byte   $12                             ; 9117 12                       .
        .byte   $12                             ; 9118 12                       .
        .byte   $12                             ; 9119 12                       .
        .byte   $12                             ; 911A 12                       .
        and     ($12),y                         ; 911B 31 12                    1.
        bpl     L9130                           ; 911D 10 11                    ..
        .byte   $12                             ; 911F 12                       .
        ora     ($11),y                         ; 9120 11 11                    ..
        ora     ($11),y                         ; 9122 11 11                    ..
        .byte   $12                             ; 9124 12                       .
        ora     ($10),y                         ; 9125 11 10                    ..
        .byte   $12                             ; 9127 12                       .
L9128:  beq     L912A                           ; 9128 F0 00                    ..
L912A:  brk                                     ; 912A 00                       .
        ora     ($11),y                         ; 912B 11 11                    ..
        ora     ($11),y                         ; 912D 11 11                    ..
        .byte   $11                             ; 912F 11                       .
L9130:  ora     ($01),y                         ; 9130 11 01                    ..
        ora     ($10),y                         ; 9132 11 10                    ..
        bpl     L9146                           ; 9134 10 10                    ..
        ora     ($10,x)                         ; 9136 01 10                    ..
        ora     ($11,x)                         ; 9138 01 11                    ..
        ora     ($11),y                         ; 913A 11 11                    ..
        ora     ($01),y                         ; 913C 11 01                    ..
        bpl     L9150                           ; 913E 10 10                    ..
        bpl     L9143                           ; 9140 10 01                    ..
        .byte   $20                             ; 9142 20                        
L9143:  .byte   $12                             ; 9143 12                       .
        .byte   $12                             ; 9144 12                       .
        .byte   $10                             ; 9145 10                       .
L9146:  bpl     L9158                           ; 9146 10 10                    ..
        bpl     L915A                           ; 9148 10 10                    ..
        ora     ($10),y                         ; 914A 11 10                    ..
        bpl     L915E                           ; 914C 10 10                    ..
        bpl     L91B3                           ; 914E 10 63                    .c
L9150:  ora     ($63,x)                         ; 9150 01 63                    .c
        .byte   $63                             ; 9152 63                       c
        .byte   $63                             ; 9153 63                       c
        .byte   $63                             ; 9154 63                       c
        bpl     L9167                           ; 9155 10 10                    ..
        brk                                     ; 9157 00                       .
L9158:  .byte   $63                             ; 9158 63                       c
        .byte   $63                             ; 9159 63                       c
L915A:  .byte   $63                             ; 915A 63                       c
        .byte   $63                             ; 915B 63                       c
        .byte   $63                             ; 915C 63                       c
        .byte   $63                             ; 915D 63                       c
L915E:  .byte   $63                             ; 915E 63                       c
        brk                                     ; 915F 00                       .
        .byte   $63                             ; 9160 63                       c
        .byte   $63                             ; 9161 63                       c
        .byte   $63                             ; 9162 63                       c
        .byte   $63                             ; 9163 63                       c
        .byte   $63                             ; 9164 63                       c
        .byte   $63                             ; 9165 63                       c
        .byte   $63                             ; 9166 63                       c
L9167:  .byte   $63                             ; 9167 63                       c
        .byte   $63                             ; 9168 63                       c
        .byte   $63                             ; 9169 63                       c
        .byte   $63                             ; 916A 63                       c
        .byte   $63                             ; 916B 63                       c
        .byte   $63                             ; 916C 63                       c
        .byte   $63                             ; 916D 63                       c
        .byte   $63                             ; 916E 63                       c
        .byte   $63                             ; 916F 63                       c
        .byte   $63                             ; 9170 63                       c
        .byte   $63                             ; 9171 63                       c
        .byte   $63                             ; 9172 63                       c
        .byte   $63                             ; 9173 63                       c
        .byte   $63                             ; 9174 63                       c
        .byte   $63                             ; 9175 63                       c
        .byte   $63                             ; 9176 63                       c
        .byte   $63                             ; 9177 63                       c
        .byte   $63                             ; 9178 63                       c
        .byte   $12                             ; 9179 12                       .
        .byte   $63                             ; 917A 63                       c
        .byte   $63                             ; 917B 63                       c
        .byte   $63                             ; 917C 63                       c
        .byte   $12                             ; 917D 12                       .
        .byte   $12                             ; 917E 12                       .
        .byte   $12                             ; 917F 12                       .
        .byte   $12                             ; 9180 12                       .
        .byte   $12                             ; 9181 12                       .
        brk                                     ; 9182 00                       .
        brk                                     ; 9183 00                       .
        brk                                     ; 9184 00                       .
        brk                                     ; 9185 00                       .
        brk                                     ; 9186 00                       .
        brk                                     ; 9187 00                       .
        rti                                     ; 9188 40                       @

; ----------------------------------------------------------------------------
        bpl     L919B                           ; 9189 10 10                    ..
        bpl     L919D                           ; 918B 10 10                    ..
        bpl     L919F                           ; 918D 10 10                    ..
        bpl     L91A1                           ; 918F 10 10                    ..
        bpl     L91A3                           ; 9191 10 10                    ..
        brk                                     ; 9193 00                       .
        bpl     L91A6                           ; 9194 10 10                    ..
        bpl     L91A8                           ; 9196 10 10                    ..
        .byte   $12                             ; 9198 12                       .
        bpl     L919B                           ; 9199 10 00                    ..
L919B:  brk                                     ; 919B 00                       .
        .byte   $10                             ; 919C 10                       .
L919D:  bpl     L919F                           ; 919D 10 00                    ..
L919F:  brk                                     ; 919F 00                       .
        brk                                     ; 91A0 00                       .
L91A1:  brk                                     ; 91A1 00                       .
        brk                                     ; 91A2 00                       .
L91A3:  brk                                     ; 91A3 00                       .
        brk                                     ; 91A4 00                       .
        brk                                     ; 91A5 00                       .
L91A6:  brk                                     ; 91A6 00                       .
        brk                                     ; 91A7 00                       .
L91A8:  brk                                     ; 91A8 00                       .
        brk                                     ; 91A9 00                       .
        brk                                     ; 91AA 00                       .
        brk                                     ; 91AB 00                       .
        brk                                     ; 91AC 00                       .
        brk                                     ; 91AD 00                       .
        brk                                     ; 91AE 00                       .
        brk                                     ; 91AF 00                       .
        brk                                     ; 91B0 00                       .
        brk                                     ; 91B1 00                       .
        brk                                     ; 91B2 00                       .
L91B3:  brk                                     ; 91B3 00                       .
        brk                                     ; 91B4 00                       .
        brk                                     ; 91B5 00                       .
        brk                                     ; 91B6 00                       .
        brk                                     ; 91B7 00                       .
        brk                                     ; 91B8 00                       .
        brk                                     ; 91B9 00                       .
        brk                                     ; 91BA 00                       .
        brk                                     ; 91BB 00                       .
        brk                                     ; 91BC 00                       .
        brk                                     ; 91BD 00                       .
        brk                                     ; 91BE 00                       .
        brk                                     ; 91BF 00                       .
        brk                                     ; 91C0 00                       .
        brk                                     ; 91C1 00                       .
        brk                                     ; 91C2 00                       .
        brk                                     ; 91C3 00                       .
        brk                                     ; 91C4 00                       .
        brk                                     ; 91C5 00                       .
        brk                                     ; 91C6 00                       .
        brk                                     ; 91C7 00                       .
        brk                                     ; 91C8 00                       .
        brk                                     ; 91C9 00                       .
        brk                                     ; 91CA 00                       .
        brk                                     ; 91CB 00                       .
        brk                                     ; 91CC 00                       .
        brk                                     ; 91CD 00                       .
        brk                                     ; 91CE 00                       .
        brk                                     ; 91CF 00                       .
        brk                                     ; 91D0 00                       .
        brk                                     ; 91D1 00                       .
        brk                                     ; 91D2 00                       .
        brk                                     ; 91D3 00                       .
        brk                                     ; 91D4 00                       .
        brk                                     ; 91D5 00                       .
        brk                                     ; 91D6 00                       .
        brk                                     ; 91D7 00                       .
        brk                                     ; 91D8 00                       .
        brk                                     ; 91D9 00                       .
        brk                                     ; 91DA 00                       .
        brk                                     ; 91DB 00                       .
        brk                                     ; 91DC 00                       .
        brk                                     ; 91DD 00                       .
        brk                                     ; 91DE 00                       .
        brk                                     ; 91DF 00                       .
        brk                                     ; 91E0 00                       .
        brk                                     ; 91E1 00                       .
        brk                                     ; 91E2 00                       .
        brk                                     ; 91E3 00                       .
        brk                                     ; 91E4 00                       .
        brk                                     ; 91E5 00                       .
        brk                                     ; 91E6 00                       .
        brk                                     ; 91E7 00                       .
        brk                                     ; 91E8 00                       .
        brk                                     ; 91E9 00                       .
        brk                                     ; 91EA 00                       .
        brk                                     ; 91EB 00                       .
        brk                                     ; 91EC 00                       .
        brk                                     ; 91ED 00                       .
        brk                                     ; 91EE 00                       .
        brk                                     ; 91EF 00                       .
        brk                                     ; 91F0 00                       .
        brk                                     ; 91F1 00                       .
        brk                                     ; 91F2 00                       .
        brk                                     ; 91F3 00                       .
        brk                                     ; 91F4 00                       .
        brk                                     ; 91F5 00                       .
        brk                                     ; 91F6 00                       .
        brk                                     ; 91F7 00                       .
        brk                                     ; 91F8 00                       .
        brk                                     ; 91F9 00                       .
        brk                                     ; 91FA 00                       .
        brk                                     ; 91FB 00                       .
        brk                                     ; 91FC 00                       .
        brk                                     ; 91FD 00                       .
        brk                                     ; 91FE 00                       .
        brk                                     ; 91FF 00                       .
        .byte   $4F                             ; 9200 4F                       O
        .byte   $4F                             ; 9201 4F                       O
        .byte   $4F                             ; 9202 4F                       O
        .byte   $4F                             ; 9203 4F                       O
        .byte   $4F                             ; 9204 4F                       O
        .byte   $4F                             ; 9205 4F                       O
        .byte   $4F                             ; 9206 4F                       O
        ror     $6F6E                           ; 9207 6E 6E 6F                 nno
        .byte   $6F                             ; 920A 6F                       o
        brk                                     ; 920B 00                       .
        .byte   $4F                             ; 920C 4F                       O
        .byte   $4F                             ; 920D 4F                       O
        .byte   $74                             ; 920E 74                       t
        adc     $4F,x                           ; 920F 75 4F                    uO
        .byte   $4F                             ; 9211 4F                       O
        .byte   $72                             ; 9212 72                       r
        .byte   $4F                             ; 9213 4F                       O
        .byte   $4F                             ; 9214 4F                       O
        .byte   $4F                             ; 9215 4F                       O
        .byte   $4F                             ; 9216 4F                       O
        lsr     $6A4F,x                         ; 9217 5E 4F 6A                 ^Oj
        .byte   $74                             ; 921A 74                       t
        .byte   $7C                             ; 921B 7C                       |
        .byte   $6B                             ; 921C 6B                       k
        ror     L0000,x                         ; 921D 76 00                    v.
        brk                                     ; 921F 00                       .
        brk                                     ; 9220 00                       .
        brk                                     ; 9221 00                       .
        brk                                     ; 9222 00                       .
        brk                                     ; 9223 00                       .
        .byte   $7C                             ; 9224 7C                       |
        brk                                     ; 9225 00                       .
        brk                                     ; 9226 00                       .
        brk                                     ; 9227 00                       .
        bvs     L929B                           ; 9228 70 71                    pq
        brk                                     ; 922A 00                       .
        brk                                     ; 922B 00                       .
        .byte   $72                             ; 922C 72                       r
        .byte   $4F                             ; 922D 4F                       O
        pla                                     ; 922E 68                       h
        .byte   $72                             ; 922F 72                       r
        .byte   $4F                             ; 9230 4F                       O
        .byte   $4F                             ; 9231 4F                       O
        .byte   $73                             ; 9232 73                       s
        .byte   $74                             ; 9233 74                       t
        .byte   $4F                             ; 9234 4F                       O
        ror     $7675                           ; 9235 6E 75 76                 nuv
        ror     L0000,x                         ; 9238 76 00                    v.
        brk                                     ; 923A 00                       .
        brk                                     ; 923B 00                       .
        brk                                     ; 923C 00                       .
        .byte   $7A                             ; 923D 7A                       z
        brk                                     ; 923E 00                       .
        brk                                     ; 923F 00                       .
        .byte   $7B                             ; 9240 7B                       {
        .byte   $7C                             ; 9241 7C                       |
        brk                                     ; 9242 00                       .
        brk                                     ; 9243 00                       .
        ora     ($02,x)                         ; 9244 01 02                    ..
        brk                                     ; 9246 00                       .
        brk                                     ; 9247 00                       .
        .byte   $03                             ; 9248 03                       .
        brk                                     ; 9249 00                       .
        brk                                     ; 924A 00                       .
        brk                                     ; 924B 00                       .
        brk                                     ; 924C 00                       .
        brk                                     ; 924D 00                       .
        ora     ($04,x)                         ; 924E 01 04                    ..
        .byte   $52                             ; 9250 52                       R
        .byte   $53                             ; 9251 53                       S
        .byte   $5A                             ; 9252 5A                       Z
        .byte   $5B                             ; 9253 5B                       [
        .byte   $54                             ; 9254 54                       T
        brk                                     ; 9255 00                       .
L9256:  .byte   $5C                             ; 9256 5C                       \
        eor     $0401,x                         ; 9257 5D 01 04                 ]..
        brk                                     ; 925A 00                       .
        brk                                     ; 925B 00                       .
        sta     L9999,y                         ; 925C 99 99 99                 ...
        sta     $0D56,y                         ; 925F 99 56 0D                 .V.
        eor     $15,x                           ; 9262 55 15                    U.
        asl     L940D                           ; 9264 0E 0D 94                 ...
        sta     L000E,x                         ; 9267 95 0E                    ..
        asl     $1515                           ; 9269 0E 15 15                 ...
        ora     $150D                           ; 926C 0D 0D 15                 ...
        ora     $0D,x                           ; 926F 15 0D                    ..
        .byte   $0F                             ; 9271 0F                       .
        ora     $17,x                           ; 9272 15 17                    ..
        .byte   $4F                             ; 9274 4F                       O
        eor     $4F,x                           ; 9275 55 4F                    UO
        .byte   $4F                             ; 9277 4F                       O
        .byte   $9C                             ; 9278 9C                       .
        sta     $1E16,x                         ; 9279 9D 16 1E                 ...
        ora     $261D,x                         ; 927C 1D 1D 26                 ..&
        rol     $1D                             ; 927F 26 1D                    &.
        ora     $2526,x                         ; 9281 1D 26 25                 .&%
        ora     $261F,x                         ; 9284 1D 1F 26                 ..&
        .byte   $27                             ; 9287 27                       '
        rol     a                               ; 9288 2A                       *
        brk                                     ; 9289 00                       .
        rol     a                               ; 928A 2A                       *
        brk                                     ; 928B 00                       .
        brk                                     ; 928C 00                       .
        rol     a                               ; 928D 2A                       *
        brk                                     ; 928E 00                       .
        rol     a                               ; 928F 2A                       *
        ora     $08                             ; 9290 05 08                    ..
        asl     $10                             ; 9292 06 10                    ..
        ora     #$0A                            ; 9294 09 0A                    ..
        ora     ($12),y                         ; 9296 11 12                    ..
        php                                     ; 9298 08                       .
        ora     #$10                            ; 9299 09 10                    ..
L929B:  ora     ($0A),y                         ; 929B 11 0A                    ..
        php                                     ; 929D 08                       .
        .byte   $12                             ; 929E 12                       .
        bpl     L92AA                           ; 929F 10 09                    ..
        ora     $11                             ; 92A1 05 11                    ..
        asl     $07                             ; 92A3 06 07                    ..
        clc                                     ; 92A5 18                       .
        brk                                     ; 92A6 00                       .
        brk                                     ; 92A7 00                       .
        .byte   $19                             ; 92A8 19                       .
        .byte   $1A                             ; 92A9 1A                       .
L92AA:  brk                                     ; 92AA 00                       .
        brk                                     ; 92AB 00                       .
        .byte   $13                             ; 92AC 13                       .
        ora     L0000,y                         ; 92AD 19 00 00                 ...
        .byte   $1A                             ; 92B0 1A                       .
        .byte   $13                             ; 92B1 13                       .
        brk                                     ; 92B2 00                       .
        brk                                     ; 92B3 00                       .
        .byte   $0B                             ; 92B4 0B                       .
        .byte   $07                             ; 92B5 07                       .
        brk                                     ; 92B6 00                       .
        brk                                     ; 92B7 00                       .
        brk                                     ; 92B8 00                       .
        brk                                     ; 92B9 00                       .
        brk                                     ; 92BA 00                       .
        ora     (L0000,x)                       ; 92BB 01 00                    ..
        brk                                     ; 92BD 00                       .
        .byte   $02                             ; 92BE 02                       .
        .byte   $03                             ; 92BF 03                       .
        brk                                     ; 92C0 00                       .
        brk                                     ; 92C1 00                       .
        .byte   $2B                             ; 92C2 2B                       +
        bit     a:L0000                         ; 92C3 2C 00 00                 ,..
        and     a:$2E                           ; 92C6 2D 2E 00                 -..
        brk                                     ; 92C9 00                       .
        .byte   $2F                             ; 92CA 2F                       /
        bmi     L9256                           ; 92CB 30 89                    0.
        ora     $158B                           ; 92CD 0D 8B 15                 ...
        asl     $150D                           ; 92D0 0E 0D 15                 ...
        ora     $0D,x                           ; 92D3 15 0D                    ..
        txa                                     ; 92D5 8A                       .
        ora     $8C,x                           ; 92D6 15 8C                    ..
        and     ($32),y                         ; 92D8 31 32                    12
        sec                                     ; 92DA 38                       8
        and     $3433,y                         ; 92DB 39 33 34                 934
        .byte   $3A                             ; 92DE 3A                       :
        .byte   $3B                             ; 92DF 3B                       ;
        and     $36,x                           ; 92E0 35 36                    56
        .byte   $3C                             ; 92E2 3C                       <
        and     $1D8F,x                         ; 92E3 3D 8F 1D                 =..
        sta     $1D25                           ; 92E6 8D 25 1D                 .%.
        bcc     L9311                           ; 92E9 90 26                    .&
        stx     $3E37                           ; 92EB 8E 37 3E                 .7>
        .byte   $3F                             ; 92EE 3F                       ?
        rti                                     ; 92EF 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 92F0 00                       .
        bvs     L92F3                           ; 92F1 70 00                    p.
L92F3:  brk                                     ; 92F3 00                       .
        adc     ($72),y                         ; 92F4 71 72                    qr
        brk                                     ; 92F6 00                       .
        .byte   $7A                             ; 92F7 7A                       z
        .byte   $4F                             ; 92F8 4F                       O
        .byte   $4F                             ; 92F9 4F                       O
        .byte   $72                             ; 92FA 72                       r
        .byte   $73                             ; 92FB 73                       s
        .byte   $7A                             ; 92FC 7A                       z
        .byte   $7B                             ; 92FD 7B                       {
        brk                                     ; 92FE 00                       .
        brk                                     ; 92FF 00                       .
        brk                                     ; 9300 00                       .
        and     (L0000),y                       ; 9301 31 00                    1.
        sec                                     ; 9303 38                       8
        .byte   $32                             ; 9304 32                       2
        .byte   $33                             ; 9305 33                       3
        and     $343A,y                         ; 9306 39 3A 34                 9:4
        and     $3B,x                           ; 9309 35 3B                    5;
        .byte   $3C                             ; 930B 3C                       <
        rol     L0000,x                         ; 930C 36 00                    6.
        and     a:L0000,x                       ; 930E 3D 00 00                 =..
L9311:  .byte   $37                             ; 9311 37                       7
        brk                                     ; 9312 00                       .
        .byte   $3F                             ; 9313 3F                       ?
        rol     $4000,x                         ; 9314 3E 00 40                 >.@
        brk                                     ; 9317 00                       .
        brk                                     ; 9318 00                       .
        brk                                     ; 9319 00                       .
        eor     ($52),y                         ; 931A 51 52                    QR
        brk                                     ; 931C 00                       .
        brk                                     ; 931D 00                       .
        .byte   $53                             ; 931E 53                       S
        .byte   $54                             ; 931F 54                       T
        brk                                     ; 9320 00                       .
        rts                                     ; 9321 60                       `

; ----------------------------------------------------------------------------
        cli                                     ; 9322 58                       X
        .byte   $5A                             ; 9323 5A                       Z
        .byte   $53                             ; 9324 53                       S
        .byte   $3F                             ; 9325 3F                       ?
        .byte   $4F                             ; 9326 4F                       O
        .byte   $5C                             ; 9327 5C                       \
        rti                                     ; 9328 40                       @

; ----------------------------------------------------------------------------
        cli                                     ; 9329 58                       X
        rti                                     ; 932A 40                       @

; ----------------------------------------------------------------------------
        .byte   $4F                             ; 932B 4F                       O
        eor     $4F5A,y                         ; 932C 59 5A 4F                 YZO
        .byte   $4F                             ; 932F 4F                       O
        .byte   $5B                             ; 9330 5B                       [
        .byte   $5C                             ; 9331 5C                       \
        .byte   $4F                             ; 9332 4F                       O
        .byte   $4F                             ; 9333 4F                       O
        eor     $6500,x                         ; 9334 5D 00 65                 ].e
        ror     L0000                           ; 9337 66 00                    f.
        cli                                     ; 9339 58                       X
        rts                                     ; 933A 60                       `

; ----------------------------------------------------------------------------
        adc     (L0000,x)                       ; 933B 61 00                    a.
        .byte   $42                             ; 933D 42                       B
        brk                                     ; 933E 00                       .
        .byte   $42                             ; 933F 42                       B
        .byte   $2B                             ; 9340 2B                       +
        bit     $3100                           ; 9341 2C 00 31                 ,.1
        and     $322E                           ; 9344 2D 2E 32                 -.2
        .byte   $33                             ; 9347 33                       3
        brk                                     ; 9348 00                       .
        sec                                     ; 9349 38                       8
        brk                                     ; 934A 00                       .
        brk                                     ; 934B 00                       .
        and     $3A,y                           ; 934C 39 3A 00                 9:.
        .byte   $37                             ; 934F 37                       7
        eor     ($52),y                         ; 9350 51 52                    QR
        eor     $5A5A,y                         ; 9352 59 5A 5A                 YZZ
        .byte   $5A                             ; 9355 5A                       Z
        .byte   $4F                             ; 9356 4F                       O
        .byte   $4F                             ; 9357 4F                       O
        .byte   $42                             ; 9358 42                       B
        brk                                     ; 9359 00                       .
        .byte   $42                             ; 935A 42                       B
        brk                                     ; 935B 00                       .
        brk                                     ; 935C 00                       .
        cli                                     ; 935D 58                       X
        sei                                     ; 935E 78                       x
        adc     ($61,x)                         ; 935F 61 61                    aa
        .byte   $4F                             ; 9361 4F                       O
        .byte   $4F                             ; 9362 4F                       O
        .byte   $4F                             ; 9363 4F                       O
        brk                                     ; 9364 00                       .
        dey                                     ; 9365 88                       .
        brk                                     ; 9366 00                       .
        .byte   $42                             ; 9367 42                       B
        jsr     L0021                           ; 9368 20 21 00                  !.
        brk                                     ; 936B 00                       .
        .byte   $22                             ; 936C 22                       "
        brk                                     ; 936D 00                       .
        brk                                     ; 936E 00                       .
        brk                                     ; 936F 00                       .
        pla                                     ; 9370 68                       h
        adc     #$00                            ; 9371 69 00                    i.
        pla                                     ; 9373 68                       h
        .byte   $4F                             ; 9374 4F                       O
        .byte   $4F                             ; 9375 4F                       O
        adc     #$4F                            ; 9376 69 4F                    iO
        ora     ($03,x)                         ; 9378 01 03                    ..
        brk                                     ; 937A 00                       .
        brk                                     ; 937B 00                       .
        and     ($22,x)                         ; 937C 21 22                    !"
        brk                                     ; 937E 00                       .
        brk                                     ; 937F 00                       .
        brk                                     ; 9380 00                       .
        jsr     L0000                           ; 9381 20 00 00                  ..
        and     (L0021,x)                       ; 9384 21 21                    !!
        brk                                     ; 9386 00                       .
        brk                                     ; 9387 00                       .
        brk                                     ; 9388 00                       .
        brk                                     ; 9389 00                       .
        ror     $67                             ; 938A 66 67                    fg
        brk                                     ; 938C 00                       .
        adc     L0000,y                         ; 938D 79 00 00                 y..
        adc     L807E,x                         ; 9390 7D 7E 80                 }~.
        sta     ($7F,x)                         ; 9393 81 7F                    ..
        brk                                     ; 9395 00                       .
        brk                                     ; 9396 00                       .
        brk                                     ; 9397 00                       .
        brk                                     ; 9398 00                       .
        brk                                     ; 9399 00                       .
        jsr     L0021                           ; 939A 20 21 00                  !.
        brk                                     ; 939D 00                       .
        .byte   $22                             ; 939E 22                       "
        dey                                     ; 939F 88                       .
        .byte   $4F                             ; 93A0 4F                       O
        .byte   $77                             ; 93A1 77                       w
        .byte   $4F                             ; 93A2 4F                       O
        .byte   $5B                             ; 93A3 5B                       [
        .byte   $4F                             ; 93A4 4F                       O
        adc     $766B                           ; 93A5 6D 6B 76                 mkv
        .byte   $67                             ; 93A8 67                       g
        brk                                     ; 93A9 00                       .
        .byte   $77                             ; 93AA 77                       w
        .byte   $54                             ; 93AB 54                       T
        eor     $6D00,x                         ; 93AC 5D 00 6D                 ].m
        brk                                     ; 93AF 00                       .
        ror     a                               ; 93B0 6A                       j
        .byte   $6B                             ; 93B1 6B                       k
        .byte   $7C                             ; 93B2 7C                       |
        brk                                     ; 93B3 00                       .
        brk                                     ; 93B4 00                       .
        brk                                     ; 93B5 00                       .
        dey                                     ; 93B6 88                       .
        jsr     L0000                           ; 93B7 20 00 00                  ..
        and     (L0021,x)                       ; 93BA 21 21                    !!
        jsr     L2122                           ; 93BC 20 22 21                  "!
        .byte   $22                             ; 93BF 22                       "
        .byte   $6F                             ; 93C0 6F                       o
        brk                                     ; 93C1 00                       .
        brk                                     ; 93C2 00                       .
        brk                                     ; 93C3 00                       .
        pla                                     ; 93C4 68                       h
        adc     #$00                            ; 93C5 69 00                    i.
        .byte   $7A                             ; 93C7 7A                       z
        .byte   $4F                             ; 93C8 4F                       O
        .byte   $74                             ; 93C9 74                       t
        .byte   $7B                             ; 93CA 7B                       {
        .byte   $7C                             ; 93CB 7C                       |
        brk                                     ; 93CC 00                       .
        .byte   $7A                             ; 93CD 7A                       z
        jsr     L7B21                           ; 93CE 20 21 7B                  !{
        .byte   $7C                             ; 93D1 7C                       |
        and     ($22,x)                         ; 93D2 21 22                    !"
        .byte   $0C                             ; 93D4 0C                       .
        ora     $1514                           ; 93D5 0D 14 15                 ...
        .byte   $1C                             ; 93D8 1C                       .
        ora     $151C,x                         ; 93D9 1D 1C 15                 ...
        ora     $151D,x                         ; 93DC 1D 1D 15                 ...
        ora     $1D,x                           ; 93DF 15 1D                    ..
        .byte   $27                             ; 93E1 27                       '
        ora     $15,x                           ; 93E2 15 15                    ..
        .byte   $1C                             ; 93E4 1C                       .
        ora     $2524,x                         ; 93E5 1D 24 25                 .$%
        ora     $251D,x                         ; 93E8 1D 1D 25                 ..%
        rol     $4F                             ; 93EB 26 4F                    &O
        .byte   $4F                             ; 93ED 4F                       O
        .byte   $4F                             ; 93EE 4F                       O
        .byte   $74                             ; 93EF 74                       t
        ror     $7C6F                           ; 93F0 6E 6F 7C                 no|
        brk                                     ; 93F3 00                       .
        .byte   $4F                             ; 93F4 4F                       O
        .byte   $4F                             ; 93F5 4F                       O
        adc     ($72),y                         ; 93F6 71 72                    qr
        .byte   $4F                             ; 93F8 4F                       O
        .byte   $4F                             ; 93F9 4F                       O
        .byte   $73                             ; 93FA 73                       s
        .byte   $4F                             ; 93FB 4F                       O
        adc     $76,x                           ; 93FC 75 76                    uv
        brk                                     ; 93FE 00                       .
        brk                                     ; 93FF 00                       .
        brk                                     ; 9400 00                       .
        pla                                     ; 9401 68                       h
        brk                                     ; 9402 00                       .
        brk                                     ; 9403 00                       .
        adc     #$4F                            ; 9404 69 4F                    iO
        .byte   $7A                             ; 9406 7A                       z
        .byte   $7B                             ; 9407 7B                       {
        .byte   $74                             ; 9408 74                       t
        adc     $7C,x                           ; 9409 75 7C                    u|
        brk                                     ; 940B 00                       .
        .byte   $0C                             ; 940C 0C                       .
L940D:  .byte   $0F                             ; 940D 0F                       .
        bit     $27                             ; 940E 24 27                    $'
        .byte   $0C                             ; 9410 0C                       .
        ora     $1E24                           ; 9411 0D 24 1E                 .$.
        asl     $160D                           ; 9414 0E 0D 16                 ...
        asl     a:$0F,x                         ; 9417 1E 0F 00                 ...
        .byte   $27                             ; 941A 27                       '
        brk                                     ; 941B 00                       .
        .byte   $0C                             ; 941C 0C                       .
        .byte   $0F                             ; 941D 0F                       .
        bit     $17                             ; 941E 24 17                    $.
        ora     $150E                           ; 9420 0D 0E 15                 ...
        ora     $0D,x                           ; 9423 15 0D                    ..
        .byte   $1F                             ; 9425 1F                       .
        ora     $1F,x                           ; 9426 15 1F                    ..
        brk                                     ; 9428 00                       .
        eor     ($58),y                         ; 9429 51 58                    QX
        eor     $1F1D,y                         ; 942B 59 1D 1F                 Y..
        and     $27                             ; 942E 25 27                    %'
        .byte   $5A                             ; 9430 5A                       Z
        .byte   $4F                             ; 9431 4F                       O
        .byte   $4F                             ; 9432 4F                       O
        .byte   $4F                             ; 9433 4F                       O
        .byte   $42                             ; 9434 42                       B
        brk                                     ; 9435 00                       .
        jsr     L0021                           ; 9436 20 21 00                  !.
        .byte   $42                             ; 9439 42                       B
        brk                                     ; 943A 00                       .
        jsr     L0000                           ; 943B 20 00 00                  ..
        and     ($22,x)                         ; 943E 21 22                    !"
        .byte   $4F                             ; 9440 4F                       O
        adc     $4F                             ; 9441 65 4F                    eO
        .byte   $4F                             ; 9443 4F                       O
        .byte   $53                             ; 9444 53                       S
        .byte   $54                             ; 9445 54                       T
        .byte   $5B                             ; 9446 5B                       [
        .byte   $5C                             ; 9447 5C                       \
        dey                                     ; 9448 88                       .
        brk                                     ; 9449 00                       .
        .byte   $42                             ; 944A 42                       B
        brk                                     ; 944B 00                       .
        .byte   $4F                             ; 944C 4F                       O
        .byte   $4F                             ; 944D 4F                       O
        .byte   $4F                             ; 944E 4F                       O
        .byte   $73                             ; 944F 73                       s
        brk                                     ; 9450 00                       .
        brk                                     ; 9451 00                       .
        .byte   $0C                             ; 9452 0C                       .
        ora     a:L0000                         ; 9453 0D 00 00                 ...
        asl     $140D                           ; 9456 0E 0D 14                 ...
        ora     $24,x                           ; 9459 15 24                    .$
        ora     $0C88,x                         ; 945B 1D 88 0C                 ...
        .byte   $42                             ; 945E 42                       B
        .byte   $14                             ; 945F 14                       .
        ora     $160E                           ; 9460 0D 0E 16                 ...
        asl     $1514,x                         ; 9463 1E 14 15                 ...
        .byte   $1C                             ; 9466 1C                       .
        ora     L9594,x                         ; 9467 1D 94 95                 ...
        .byte   $9C                             ; 946A 9C                       .
        sta     $1515,x                         ; 946B 9D 15 15                 ...
        ora     $421D,x                         ; 946E 1D 1D 42                 ..B
        bit     $42                             ; 9471 24 42                    $B
        brk                                     ; 9473 00                       .
        and     $26                             ; 9474 25 26                    %&
        brk                                     ; 9476 00                       .
        brk                                     ; 9477 00                       .
        bit     $25                             ; 9478 24 25                    $%
        brk                                     ; 947A 00                       .
        brk                                     ; 947B 00                       .
        rol     $25                             ; 947C 26 25                    &%
        brk                                     ; 947E 00                       .
        brk                                     ; 947F 00                       .
        rol     $26                             ; 9480 26 26                    &&
        brk                                     ; 9482 00                       .
        brk                                     ; 9483 00                       .
        brk                                     ; 9484 00                       .
        brk                                     ; 9485 00                       .
        .byte   $43                             ; 9486 43                       C
        asl     $1E43,x                         ; 9487 1E 43 1E                 .C.
        brk                                     ; 948A 00                       .
        brk                                     ; 948B 00                       .
        .byte   $44                             ; 948C 44                       D
        brk                                     ; 948D 00                       .
        brk                                     ; 948E 00                       .
        brk                                     ; 948F 00                       .
        brk                                     ; 9490 00                       .
        brk                                     ; 9491 00                       .
        .byte   $22                             ; 9492 22                       "
        asl     a:L0000,x                       ; 9493 1E 00 00                 ...
        asl     $1E,x                           ; 9496 16 1E                    ..
        brk                                     ; 9498 00                       .
        brk                                     ; 9499 00                       .
        asl     $150F                           ; 949A 0E 0F 15                 ...
        .byte   $17                             ; 949D 17                       .
        ora     a:$27,x                         ; 949E 1D 27 00                 .'.
        brk                                     ; 94A1 00                       .
        asl     a:L000E                         ; 94A2 0E 0E 00                 ...
        brk                                     ; 94A5 00                       .
        ora     $250E                           ; 94A6 0D 0E 25                 ..%
        and     L0000                           ; 94A9 25 00                    %.
        brk                                     ; 94AB 00                       .
        brk                                     ; 94AC 00                       .
        brk                                     ; 94AD 00                       .
        asl     $44,x                           ; 94AE 16 44                    .D
        .byte   $42                             ; 94B0 42                       B
        brk                                     ; 94B1 00                       .
        asl     $150F                           ; 94B2 0E 0F 15                 ...
        .byte   $17                             ; 94B5 17                       .
        ora     $251F,x                         ; 94B6 1D 1F 25                 ..%
        .byte   $27                             ; 94B9 27                       '
        brk                                     ; 94BA 00                       .
        brk                                     ; 94BB 00                       .
        .byte   $03                             ; 94BC 03                       .
        .byte   $42                             ; 94BD 42                       B
        brk                                     ; 94BE 00                       .
        .byte   $42                             ; 94BF 42                       B
        brk                                     ; 94C0 00                       .
        .byte   $42                             ; 94C1 42                       B
        brk                                     ; 94C2 00                       .
        brk                                     ; 94C3 00                       .
        ora     $1627,x                         ; 94C4 1D 27 16                 .'.
        asl     $0F0D,x                         ; 94C7 1E 0D 0F                 ...
        asl     $17,x                           ; 94CA 16 17                    ..
        rol     $27                             ; 94CC 26 27                    &'
        brk                                     ; 94CE 00                       .
        brk                                     ; 94CF 00                       .
        .byte   $0C                             ; 94D0 0C                       .
        ora     $1E14                           ; 94D1 0D 14 1E                 ...
        .byte   $1B                             ; 94D4 1B                       .
        .byte   $1B                             ; 94D5 1B                       .
        brk                                     ; 94D6 00                       .
        brk                                     ; 94D7 00                       .
        brk                                     ; 94D8 00                       .
        brk                                     ; 94D9 00                       .
        brk                                     ; 94DA 00                       .
        cli                                     ; 94DB 58                       X
        brk                                     ; 94DC 00                       .
        brk                                     ; 94DD 00                       .
        eor     a:L0000,x                       ; 94DE 5D 00 00                 ]..
        lsr     a                               ; 94E1 4A                       J
        brk                                     ; 94E2 00                       .
        .byte   $92                             ; 94E3 92                       .
        brk                                     ; 94E4 00                       .
        .byte   $4B                             ; 94E5 4B                       K
        brk                                     ; 94E6 00                       .
        .byte   $92                             ; 94E7 92                       .
        brk                                     ; 94E8 00                       .
        .byte   $1B                             ; 94E9 1B                       .
        brk                                     ; 94EA 00                       .
        brk                                     ; 94EB 00                       .
        brk                                     ; 94EC 00                       .
        brk                                     ; 94ED 00                       .
        jsr     L0023                           ; 94EE 20 23 00                  #.
        brk                                     ; 94F1 00                       .
        .byte   $23                             ; 94F2 23                       #
        .byte   $23                             ; 94F3 23                       #
        brk                                     ; 94F4 00                       .
        rol     a                               ; 94F5 2A                       *
        .byte   $22                             ; 94F6 22                       "
        rol     a                               ; 94F7 2A                       *
        brk                                     ; 94F8 00                       .
        plp                                     ; 94F9 28                       (
        brk                                     ; 94FA 00                       .
        and     #$28                            ; 94FB 29 28                    )(
        plp                                     ; 94FD 28                       (
        and     #$29                            ; 94FE 29 29                    ))
        plp                                     ; 9500 28                       (
        rol     a                               ; 9501 2A                       *
        and     #$2A                            ; 9502 29 2A                    )*
        rol     a                               ; 9504 2A                       *
        jsr     L282A                           ; 9505 20 2A 28                  *(
        .byte   $23                             ; 9508 23                       #
        .byte   $23                             ; 9509 23                       #
        plp                                     ; 950A 28                       (
        plp                                     ; 950B 28                       (
        rol     a                               ; 950C 2A                       *
        and     #$2A                            ; 950D 29 2A                    )*
        brk                                     ; 950F 00                       .
        and     #$29                            ; 9510 29 29                    ))
        brk                                     ; 9512 00                       .
        brk                                     ; 9513 00                       .
        brk                                     ; 9514 00                       .
        and     #$00                            ; 9515 29 00                    ).
        brk                                     ; 9517 00                       .
        and     #$2A                            ; 9518 29 2A                    )*
        brk                                     ; 951A 00                       .
        rol     a                               ; 951B 2A                       *
        .byte   $22                             ; 951C 22                       "
        rol     a                               ; 951D 2A                       *
        plp                                     ; 951E 28                       (
        rol     a                               ; 951F 2A                       *
        brk                                     ; 9520 00                       .
        brk                                     ; 9521 00                       .
        brk                                     ; 9522 00                       .
        jsr     L0000                           ; 9523 20 00 00                  ..
        .byte   $23                             ; 9526 23                       #
        .byte   $22                             ; 9527 22                       "
        plp                                     ; 9528 28                       (
        brk                                     ; 9529 00                       .
        and     #$00                            ; 952A 29 00                    ).
        brk                                     ; 952C 00                       .
        brk                                     ; 952D 00                       .
        brk                                     ; 952E 00                       .
        .byte   $43                             ; 952F 43                       C
        brk                                     ; 9530 00                       .
        .byte   $43                             ; 9531 43                       C
        asl     $1E,x                           ; 9532 16 1E                    ..
        .byte   $0F                             ; 9534 0F                       .
        rol     a                               ; 9535 2A                       *
        .byte   $27                             ; 9536 27                       '
        rol     a                               ; 9537 2A                       *
        .byte   $23                             ; 9538 23                       #
        and     ($28,x)                         ; 9539 21 28                    !(
        jsr     L2121                           ; 953B 20 21 21                  !!
        .byte   $23                             ; 953E 23                       #
        .byte   $23                             ; 953F 23                       #
        .byte   $22                             ; 9540 22                       "
        rol     a                               ; 9541 2A                       *
        .byte   $22                             ; 9542 22                       "
        rol     a                               ; 9543 2A                       *
        and     #$28                            ; 9544 29 28                    )(
        brk                                     ; 9546 00                       .
        and     #$4A                            ; 9547 29 4A                    )J
        brk                                     ; 9549 00                       .
        .byte   $92                             ; 954A 92                       .
        brk                                     ; 954B 00                       .
        .byte   $43                             ; 954C 43                       C
        ora     $1514                           ; 954D 0D 14 15                 ...
        .byte   $4B                             ; 9550 4B                       K
        brk                                     ; 9551 00                       .
        .byte   $92                             ; 9552 92                       .
        brk                                     ; 9553 00                       .
        brk                                     ; 9554 00                       .
        brk                                     ; 9555 00                       .
        .byte   $43                             ; 9556 43                       C
        asl     L0000,x                         ; 9557 16 00                    ..
        brk                                     ; 9559 00                       .
        asl     $4316,x                         ; 955A 1E 16 43                 ..C
        ora     $161E                           ; 955D 0D 1E 16                 ...
        brk                                     ; 9560 00                       .
        .byte   $0C                             ; 9561 0C                       .
        brk                                     ; 9562 00                       .
        .byte   $14                             ; 9563 14                       .
        brk                                     ; 9564 00                       .
        bit     L0000                           ; 9565 24 00                    $.
        brk                                     ; 9567 00                       .
        .byte   $0C                             ; 9568 0C                       .
        ora     $1614                           ; 9569 0D 14 16                 ...
        ora     $1E0F                           ; 956C 0D 0F 1E                 ...
        .byte   $17                             ; 956F 17                       .
        asl     $1E0D                           ; 9570 0E 0D 1E                 ...
        asl     L000E,x                         ; 9573 16 0E                    ..
        .byte   $1F                             ; 9575 1F                       .
        asl     $0D27,x                         ; 9576 1E 27 0D                 .'.
        asl     $161E                           ; 9579 0E 1E 16                 ...
        .byte   $9C                             ; 957C 9C                       .
        sta     $2625,x                         ; 957D 9D 25 26                 .%&
        asl     $1E,x                           ; 9580 16 1E                    ..
        rol     $25                             ; 9582 26 25                    &%
        asl     $1E,x                           ; 9584 16 1E                    ..
        and     $26                             ; 9586 25 26                    %&
        asl     $1E,x                           ; 9588 16 1E                    ..
        and     $25                             ; 958A 25 25                    %%
        asl     $1F,x                           ; 958C 16 1F                    ..
        rol     $27                             ; 958E 26 27                    &'
        .byte   $1C                             ; 9590 1C                       .
        ora     $1C,x                           ; 9591 15 1C                    ..
        .byte   $1D                             ; 9593 1D                       .
L9594:  ora     $160D                           ; 9594 0D 0D 16                 ...
        asl     $0F0E,x                         ; 9597 1E 0E 0F                 ...
        asl     $27,x                           ; 959A 16 27                    .'
        .byte   $1C                             ; 959C 1C                       .
        asl     $24,x                           ; 959D 16 24                    .$
        and     $1E                             ; 959F 25 1E                    %.
        asl     $26,x                           ; 95A1 16 26                    .&
        and     $15                             ; 95A3 25 15                    %.
        .byte   $0F                             ; 95A5 0F                       .
        ora     $0C27,x                         ; 95A6 1D 27 0C                 .'.
        ora     $24,x                           ; 95A9 15 24                    .$
        ora     $0E0C,x                         ; 95AB 1D 0C 0E                 ...
        .byte   $1C                             ; 95AE 1C                       .
        ora     $1D,x                           ; 95AF 15 1D                    ..
        .byte   $1F                             ; 95B1 1F                       .
        asl     $1F,x                           ; 95B2 16 1F                    ..
        bit     $1D                             ; 95B4 24 1D                    $.
        brk                                     ; 95B6 00                       .
        brk                                     ; 95B7 00                       .
        ora     a:$1D,x                         ; 95B8 1D 1D 00                 ...
        brk                                     ; 95BB 00                       .
        ora     a:$1D,x                         ; 95BC 1D 1D 00                 ...
        .byte   $5F                             ; 95BF 5F                       _
        ora     $1F,x                           ; 95C0 15 1F                    ..
        ora     a:$27,x                         ; 95C2 1D 27 00                 .'.
        .byte   $5F                             ; 95C5 5F                       _
        brk                                     ; 95C6 00                       .
        .byte   $5F                             ; 95C7 5F                       _
        ora     $161D,x                         ; 95C8 1D 1D 16                 ...
        asl     a:$0F,x                         ; 95CB 1E 0F 00                 ...
        .byte   $17                             ; 95CE 17                       .
        brk                                     ; 95CF 00                       .
        .byte   $1C                             ; 95D0 1C                       .
        ora     $24,x                           ; 95D1 15 24                    .$
        ora     a:$1F,x                         ; 95D3 1D 1F 00                 ...
        .byte   $27                             ; 95D6 27                       '
        .byte   $52                             ; 95D7 52                       R
        .byte   $1F                             ; 95D8 1F                       .
        sta     L991F,y                         ; 95D9 99 1F 99                 ...
        .byte   $1F                             ; 95DC 1F                       .
        .byte   $4F                             ; 95DD 4F                       O
        .byte   $1F                             ; 95DE 1F                       .
        .byte   $4F                             ; 95DF 4F                       O
        .byte   $4F                             ; 95E0 4F                       O
        sta     L994F,y                         ; 95E1 99 4F 99                 .O.
        .byte   $1F                             ; 95E4 1F                       .
        .byte   $4F                             ; 95E5 4F                       O
        .byte   $1F                             ; 95E6 1F                       .
        .byte   $72                             ; 95E7 72                       r
        .byte   $1F                             ; 95E8 1F                       .
        .byte   $7A                             ; 95E9 7A                       z
        .byte   $1F                             ; 95EA 1F                       .
        brk                                     ; 95EB 00                       .
        .byte   $4F                             ; 95EC 4F                       O
        sta     L9875,y                         ; 95ED 99 75 98                 .u.
        .byte   $27                             ; 95F0 27                       '
        brk                                     ; 95F1 00                       .
        brk                                     ; 95F2 00                       .
        brk                                     ; 95F3 00                       .
        brk                                     ; 95F4 00                       .
        .byte   $1C                             ; 95F5 1C                       .
        brk                                     ; 95F6 00                       .
        .byte   $1C                             ; 95F7 1C                       .
        brk                                     ; 95F8 00                       .
        .byte   $1C                             ; 95F9 1C                       .
        brk                                     ; 95FA 00                       .
        bit     $1D                             ; 95FB 24 1D                    $.
        ora     $1E16,x                         ; 95FD 1D 16 1E                 ...
        brk                                     ; 9600 00                       .
        brk                                     ; 9601 00                       .
        brk                                     ; 9602 00                       .
        brk                                     ; 9603 00                       .
        brk                                     ; 9604 00                       .
        brk                                     ; 9605 00                       .
        ora     ($02,x)                         ; 9606 01 02                    ..
        .byte   $03                             ; 9608 03                       .
        .byte   $04                             ; 9609 04                       .
        brk                                     ; 960A 00                       .
        ora     L0000                           ; 960B 05 00                    ..
        asl     $07                             ; 960D 06 07                    ..
        php                                     ; 960F 08                       .
        ora     #$0A                            ; 9610 09 0A                    ..
        .byte   $0B                             ; 9612 0B                       .
        .byte   $0C                             ; 9613 0C                       .
        ora     $080E                           ; 9614 0D 0E 08                 ...
        php                                     ; 9617 08                       .
        php                                     ; 9618 08                       .
        php                                     ; 9619 08                       .
        .byte   $0F                             ; 961A 0F                       .
        bpl     L9625                           ; 961B 10 08                    ..
        php                                     ; 961D 08                       .
        ora     ($12),y                         ; 961E 11 12                    ..
        php                                     ; 9620 08                       .
        php                                     ; 9621 08                       .
        php                                     ; 9622 08                       .
        .byte   $13                             ; 9623 13                       .
        php                                     ; 9624 08                       .
L9625:  php                                     ; 9625 08                       .
        php                                     ; 9626 08                       .
        php                                     ; 9627 08                       .
        .byte   $14                             ; 9628 14                       .
        ora     $08,x                           ; 9629 15 08                    ..
        php                                     ; 962B 08                       .
        php                                     ; 962C 08                       .
        asl     $08,x                           ; 962D 16 08                    ..
        php                                     ; 962F 08                       .
        .byte   $17                             ; 9630 17                       .
        .byte   $17                             ; 9631 17                       .
        clc                                     ; 9632 18                       .
        ora     $1B1A,y                         ; 9633 19 1A 1B                 ...
        ora     $171C,y                         ; 9636 19 1C 17                 ...
        .byte   $17                             ; 9639 17                       .
        ora     $1F1E,x                         ; 963A 1D 1E 1F                 ...
        jsr     L211E                           ; 963D 20 1E 21                  .!
        .byte   $22                             ; 9640 22                       "
        php                                     ; 9641 08                       .
        php                                     ; 9642 08                       .
        php                                     ; 9643 08                       .
        php                                     ; 9644 08                       .
        php                                     ; 9645 08                       .
        asl     L0023,x                         ; 9646 16 23                    .#
        .byte   $22                             ; 9648 22                       "
        ora     ($12),y                         ; 9649 11 12                    ..
        php                                     ; 964B 08                       .
        php                                     ; 964C 08                       .
        php                                     ; 964D 08                       .
        php                                     ; 964E 08                       .
        .byte   $23                             ; 964F 23                       #
        .byte   $22                             ; 9650 22                       "
        php                                     ; 9651 08                       .
        php                                     ; 9652 08                       .
        asl     $08,x                           ; 9653 16 08                    ..
        php                                     ; 9655 08                       .
        php                                     ; 9656 08                       .
        .byte   $23                             ; 9657 23                       #
        .byte   $22                             ; 9658 22                       "
        php                                     ; 9659 08                       .
        php                                     ; 965A 08                       .
        php                                     ; 965B 08                       .
        php                                     ; 965C 08                       .
        php                                     ; 965D 08                       .
        php                                     ; 965E 08                       .
        .byte   $23                             ; 965F 23                       #
        .byte   $22                             ; 9660 22                       "
        php                                     ; 9661 08                       .
        ora     ($12),y                         ; 9662 11 12                    ..
        php                                     ; 9664 08                       .
        .byte   $13                             ; 9665 13                       .
        php                                     ; 9666 08                       .
        .byte   $23                             ; 9667 23                       #
        .byte   $22                             ; 9668 22                       "
        php                                     ; 9669 08                       .
        php                                     ; 966A 08                       .
        php                                     ; 966B 08                       .
        php                                     ; 966C 08                       .
        php                                     ; 966D 08                       .
        php                                     ; 966E 08                       .
        .byte   $23                             ; 966F 23                       #
        bit     $25                             ; 9670 24 25                    $%
        rol     $27                             ; 9672 26 27                    &'
        and     $26                             ; 9674 25 26                    %&
        .byte   $27                             ; 9676 27                       '
        plp                                     ; 9677 28                       (
        and     #$2A                            ; 9678 29 2A                    )*
        .byte   $2B                             ; 967A 2B                       +
        bit     $2B2A                           ; 967B 2C 2A 2B                 ,*+
        bit     $082D                           ; 967E 2C 2D 08                 ,-.
        php                                     ; 9681 08                       .
        php                                     ; 9682 08                       .
        php                                     ; 9683 08                       .
        php                                     ; 9684 08                       .
        php                                     ; 9685 08                       .
        php                                     ; 9686 08                       .
        php                                     ; 9687 08                       .
        php                                     ; 9688 08                       .
        php                                     ; 9689 08                       .
        php                                     ; 968A 08                       .
        php                                     ; 968B 08                       .
        php                                     ; 968C 08                       .
        ora     ($12),y                         ; 968D 11 12                    ..
        php                                     ; 968F 08                       .
        php                                     ; 9690 08                       .
        php                                     ; 9691 08                       .
        php                                     ; 9692 08                       .
        .byte   $13                             ; 9693 13                       .
        php                                     ; 9694 08                       .
        php                                     ; 9695 08                       .
        php                                     ; 9696 08                       .
        php                                     ; 9697 08                       .
        .byte   $13                             ; 9698 13                       .
        php                                     ; 9699 08                       .
        php                                     ; 969A 08                       .
        php                                     ; 969B 08                       .
        php                                     ; 969C 08                       .
        php                                     ; 969D 08                       .
        rol     $082F                           ; 969E 2E 2F 08                 ./.
        rol     $082F                           ; 96A1 2E 2F 08                 ./.
        php                                     ; 96A4 08                       .
        php                                     ; 96A5 08                       .
        php                                     ; 96A6 08                       .
        php                                     ; 96A7 08                       .
        php                                     ; 96A8 08                       .
        php                                     ; 96A9 08                       .
        php                                     ; 96AA 08                       .
        php                                     ; 96AB 08                       .
        bmi     L96DF                           ; 96AC 30 31                    01
        .byte   $32                             ; 96AE 32                       2
        php                                     ; 96AF 08                       .
        .byte   $33                             ; 96B0 33                       3
        .byte   $34                             ; 96B1 34                       4
        and     $08,x                           ; 96B2 35 08                    5.
        rol     $37,x                           ; 96B4 36 37                    67
        sec                                     ; 96B6 38                       8
        asl     $39,x                           ; 96B7 16 39                    .9
L96B9:  jsr     L163A                           ; 96B9 20 3A 16                  :.
        php                                     ; 96BC 08                       .
        .byte   $3B                             ; 96BD 3B                       ;
        php                                     ; 96BE 08                       .
        php                                     ; 96BF 08                       .
        .byte   $3C                             ; 96C0 3C                       <
        and     $033E,x                         ; 96C1 3D 3E 03                 =>.
        .byte   $04                             ; 96C4 04                       .
        brk                                     ; 96C5 00                       .
        ora     L0000                           ; 96C6 05 00                    ..
        php                                     ; 96C8 08                       .
        php                                     ; 96C9 08                       .
        .byte   $3F                             ; 96CA 3F                       ?
        ora     #$0A                            ; 96CB 09 0A                    ..
        .byte   $0B                             ; 96CD 0B                       .
        .byte   $0C                             ; 96CE 0C                       .
        ora     $0808                           ; 96CF 0D 08 08                 ...
        php                                     ; 96D2 08                       .
        php                                     ; 96D3 08                       .
        php                                     ; 96D4 08                       .
        .byte   $0F                             ; 96D5 0F                       .
        bpl     L96E0                           ; 96D6 10 08                    ..
        php                                     ; 96D8 08                       .
        ora     ($12),y                         ; 96D9 11 12                    ..
        php                                     ; 96DB 08                       .
        php                                     ; 96DC 08                       .
        php                                     ; 96DD 08                       .
        php                                     ; 96DE 08                       .
L96DF:  php                                     ; 96DF 08                       .
L96E0:  bmi     L9713                           ; 96E0 30 31                    01
        and     ($32),y                         ; 96E2 31 32                    12
        php                                     ; 96E4 08                       .
        php                                     ; 96E5 08                       .
        ora     ($12),y                         ; 96E6 11 12                    ..
        rti                                     ; 96E8 40                       @

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; 96E9 41 42                    AB
        .byte   $43                             ; 96EB 43                       C
        php                                     ; 96EC 08                       .
        bmi     L9720                           ; 96ED 30 31                    01
        .byte   $32                             ; 96EF 32                       2
        php                                     ; 96F0 08                       .
        .byte   $44                             ; 96F1 44                       D
        eor     $46                             ; 96F2 45 46                    EF
        .byte   $47                             ; 96F4 47                       G
        rol     $37,x                           ; 96F5 36 37                    67
        sec                                     ; 96F7 38                       8
        pha                                     ; 96F8 48                       H
        eor     #$4A                            ; 96F9 49 4A                    IJ
        .byte   $4B                             ; 96FB 4B                       K
        jmp     L3B4D                           ; 96FC 4C 4D 3B                 LM;

; ----------------------------------------------------------------------------
        lsr     $0706                           ; 96FF 4E 06 07                 N..
        php                                     ; 9702 08                       .
        php                                     ; 9703 08                       .
        rol     $4F2F                           ; 9704 2E 2F 4F                 ./O
        php                                     ; 9707 08                       .
        asl     $2E08                           ; 9708 0E 08 2E                 ...
        .byte   $2F                             ; 970B 2F                       /
        php                                     ; 970C 08                       .
        php                                     ; 970D 08                       .
        .byte   $4F                             ; 970E 4F                       O
        php                                     ; 970F 08                       .
        php                                     ; 9710 08                       .
        php                                     ; 9711 08                       .
        php                                     ; 9712 08                       .
L9713:  php                                     ; 9713 08                       .
        php                                     ; 9714 08                       .
        php                                     ; 9715 08                       .
        .byte   $4F                             ; 9716 4F                       O
        php                                     ; 9717 08                       .
        .byte   $13                             ; 9718 13                       .
        php                                     ; 9719 08                       .
        php                                     ; 971A 08                       .
        php                                     ; 971B 08                       .
        php                                     ; 971C 08                       .
        php                                     ; 971D 08                       .
        bvc     L9771                           ; 971E 50 51                    PQ
L9720:  php                                     ; 9720 08                       .
        bmi     L9754                           ; 9721 30 31                    01
        and     ($32),y                         ; 9723 31 32                    12
        php                                     ; 9725 08                       .
        .byte   $52                             ; 9726 52                       R
        .byte   $53                             ; 9727 53                       S
        php                                     ; 9728 08                       .
        rti                                     ; 9729 40                       @

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; 972A 41 42                    AB
        .byte   $43                             ; 972C 43                       C
        lsr     $54                             ; 972D 46 54                    FT
        eor     #$46                            ; 972F 49 46                    IF
        .byte   $47                             ; 9731 47                       G
        .byte   $44                             ; 9732 44                       D
        eor     $48                             ; 9733 45 48                    EH
        .byte   $4B                             ; 9735 4B                       K
        brk                                     ; 9736 00                       .
        brk                                     ; 9737 00                       .
        .byte   $4B                             ; 9738 4B                       K
        jmp     L4A49                           ; 9739 4C 49 4A                 LIJ

; ----------------------------------------------------------------------------
        eor     L0000,x                         ; 973C 55 00                    U.
        brk                                     ; 973E 00                       .
        brk                                     ; 973F 00                       .
        rol     $562F                           ; 9740 2E 2F 56                 ./V
        php                                     ; 9743 08                       .
        php                                     ; 9744 08                       .
        php                                     ; 9745 08                       .
        php                                     ; 9746 08                       .
        lsr     $0808                           ; 9747 4E 08 08                 N..
        lsr     $08,x                           ; 974A 56 08                    V.
        php                                     ; 974C 08                       .
        php                                     ; 974D 08                       .
        .byte   $57                             ; 974E 57                       W
        cli                                     ; 974F 58                       X
        eor     $5B5A,y                         ; 9750 59 5A 5B                 YZ[
        php                                     ; 9753 08                       .
L9754:  php                                     ; 9754 08                       .
        php                                     ; 9755 08                       .
        .byte   $5C                             ; 9756 5C                       \
        eor     $084F,x                         ; 9757 5D 4F 08                 ]O.
        lsr     $5A08,x                         ; 975A 5E 08 5A                 ^.Z
        .byte   $5F                             ; 975D 5F                       _
        php                                     ; 975E 08                       .
        asl     a                               ; 975F 0A                       .
        rts                                     ; 9760 60                       `

; ----------------------------------------------------------------------------
        adc     ($5B,x)                         ; 9761 61 5B                    a[
        php                                     ; 9763 08                       .
        php                                     ; 9764 08                       .
        ora     ($12),y                         ; 9765 11 12                    ..
        php                                     ; 9767 08                       .
        .byte   $62                             ; 9768 62                       b
        php                                     ; 9769 08                       .
        .byte   $63                             ; 976A 63                       c
        .byte   $64                             ; 976B 64                       d
        adc     $66                             ; 976C 65 66                    ef
        .byte   $67                             ; 976E 67                       g
        php                                     ; 976F 08                       .
        pla                                     ; 9770 68                       h
L9771:  ora     $08,x                           ; 9771 15 08                    ..
        php                                     ; 9773 08                       .
        php                                     ; 9774 08                       .
        php                                     ; 9775 08                       .
        .byte   $4F                             ; 9776 4F                       O
        php                                     ; 9777 08                       .
        brk                                     ; 9778 00                       .
        adc     #$08                            ; 9779 69 08                    i.
        php                                     ; 977B 08                       .
        php                                     ; 977C 08                       .
        php                                     ; 977D 08                       .
        .byte   $4F                             ; 977E 4F                       O
        lsr     a:L0000,x                       ; 977F 5E 00 00                 ^..
        brk                                     ; 9782 00                       .
        brk                                     ; 9783 00                       .
        brk                                     ; 9784 00                       .
        ora     ($02,x)                         ; 9785 01 02                    ..
        .byte   $3C                             ; 9787 3C                       <
        .byte   $04                             ; 9788 04                       .
        brk                                     ; 9789 00                       .
        ora     L0000                           ; 978A 05 00                    ..
        asl     $07                             ; 978C 06 07                    ..
        php                                     ; 978E 08                       .
        php                                     ; 978F 08                       .
        asl     a                               ; 9790 0A                       .
        .byte   $0B                             ; 9791 0B                       .
        .byte   $0C                             ; 9792 0C                       .
        ora     $080E                           ; 9793 0D 0E 08                 ...
        php                                     ; 9796 08                       .
        php                                     ; 9797 08                       .
        ror     a                               ; 9798 6A                       j
        .byte   $3C                             ; 9799 3C                       <
        bpl     L97A4                           ; 979A 10 08                    ..
        php                                     ; 979C 08                       .
        php                                     ; 979D 08                       .
        ora     ($12),y                         ; 979E 11 12                    ..
        jmp     L086B                           ; 97A0 4C 6B 08                 Lk.

; ----------------------------------------------------------------------------
        php                                     ; 97A3 08                       .
L97A4:  php                                     ; 97A4 08                       .
        php                                     ; 97A5 08                       .
        php                                     ; 97A6 08                       .
        php                                     ; 97A7 08                       .
        jmp     (L6D0E)                         ; 97A8 6C 0E 6D                 l.m

; ----------------------------------------------------------------------------
        ror     $636F                           ; 97AB 6E 6F 63                 noc
        .byte   $64                             ; 97AE 64                       d
        adc     $08                             ; 97AF 65 08                    e.
        php                                     ; 97B1 08                       .
        lsr     $08,x                           ; 97B2 56 08                    V.
        php                                     ; 97B4 08                       .
        rol     $082F                           ; 97B5 2E 2F 08                 ./.
        php                                     ; 97B8 08                       .
        php                                     ; 97B9 08                       .
        lsr     $08,x                           ; 97BA 56 08                    V.
        php                                     ; 97BC 08                       .
        php                                     ; 97BD 08                       .
        php                                     ; 97BE 08                       .
        php                                     ; 97BF 08                       .
        and     a:$04,x                         ; 97C0 3D 04 00                 =..
        ora     L0000                           ; 97C3 05 00                    ..
        .byte   $03                             ; 97C5 03                       .
        .byte   $04                             ; 97C6 04                       .
        brk                                     ; 97C7 00                       .
        php                                     ; 97C8 08                       .
        asl     a                               ; 97C9 0A                       .
        .byte   $0B                             ; 97CA 0B                       .
        .byte   $0C                             ; 97CB 0C                       .
        ora     $7170                           ; 97CC 0D 70 71                 .pq
        .byte   $72                             ; 97CF 72                       r
        lsr     $7308,x                         ; 97D0 5E 08 73                 ^.s
        .byte   $74                             ; 97D3 74                       t
        php                                     ; 97D4 08                       .
        php                                     ; 97D5 08                       .
        php                                     ; 97D6 08                       .
        php                                     ; 97D7 08                       .
        php                                     ; 97D8 08                       .
        php                                     ; 97D9 08                       .
        php                                     ; 97DA 08                       .
        php                                     ; 97DB 08                       .
        php                                     ; 97DC 08                       .
        ora     ($12),y                         ; 97DD 11 12                    ..
        php                                     ; 97DF 08                       .
        php                                     ; 97E0 08                       .
        php                                     ; 97E1 08                       .
        lsr     $5A08,x                         ; 97E2 5E 08 5A                 ^.Z
        .byte   $5F                             ; 97E5 5F                       _
        php                                     ; 97E6 08                       .
        ora     ($08),y                         ; 97E7 11 08                    ..
        adc     $34,x                           ; 97E9 75 34                    u4
        .byte   $1A                             ; 97EB 1A                       .
        .byte   $1C                             ; 97EC 1C                       .
        php                                     ; 97ED 08                       .
        php                                     ; 97EE 08                       .
        .byte   $5A                             ; 97EF 5A                       Z
        php                                     ; 97F0 08                       .
        ror     $77,x                           ; 97F1 76 77                    vw
        .byte   $77                             ; 97F3 77                       w
        sei                                     ; 97F4 78                       x
        .byte   $34                             ; 97F5 34                       4
        .byte   $1A                             ; 97F6 1A                       .
        .byte   $1B                             ; 97F7 1B                       .
        php                                     ; 97F8 08                       .
        adc     L201F,y                         ; 97F9 79 1F 20                 y. 
        .byte   $7A                             ; 97FC 7A                       z
        .byte   $1F                             ; 97FD 1F                       .
        jsr     L7B1F                           ; 97FE 20 1F 7B                  .{
        .byte   $7C                             ; 9801 7C                       |
        php                                     ; 9802 08                       .
        .byte   $3C                             ; 9803 3C                       <
        and     $7E7D,x                         ; 9804 3D 7D 7E                 =}~
        brk                                     ; 9807 00                       .
        .byte   $7F                             ; 9808 7F                       .
        php                                     ; 9809 08                       .
        php                                     ; 980A 08                       .
        php                                     ; 980B 08                       .
        php                                     ; 980C 08                       .
        .byte   $80                             ; 980D 80                       .
        sta     ($82,x)                         ; 980E 81 82                    ..
        php                                     ; 9810 08                       .
        php                                     ; 9811 08                       .
        php                                     ; 9812 08                       .
        ora     ($12),y                         ; 9813 11 12                    ..
        php                                     ; 9815 08                       .
        php                                     ; 9816 08                       .
        php                                     ; 9817 08                       .
        php                                     ; 9818 08                       .
        .byte   $83                             ; 9819 83                       .
        php                                     ; 981A 08                       .
        php                                     ; 981B 08                       .
        php                                     ; 981C 08                       .
        php                                     ; 981D 08                       .
        ora     ($12),y                         ; 981E 11 12                    ..
        sty     $85                             ; 9820 84 85                    ..
        stx     $08                             ; 9822 86 08                    ..
        php                                     ; 9824 08                       .
        php                                     ; 9825 08                       .
        php                                     ; 9826 08                       .
        php                                     ; 9827 08                       .
        .byte   $5F                             ; 9828 5F                       _
        php                                     ; 9829 08                       .
        .byte   $87                             ; 982A 87                       .
        php                                     ; 982B 08                       .
        php                                     ; 982C 08                       .
        php                                     ; 982D 08                       .
        php                                     ; 982E 08                       .
        php                                     ; 982F 08                       .
        dey                                     ; 9830 88                       .
        .byte   $1B                             ; 9831 1B                       .
        .byte   $89                             ; 9832 89                       .
        .byte   $63                             ; 9833 63                       c
        .byte   $64                             ; 9834 64                       d
        adc     $8A                             ; 9835 65 8A                    e.
        .byte   $14                             ; 9837 14                       .
        jsr     L8B7A                           ; 9838 20 7A 8B                  z.
        php                                     ; 983B 08                       .
        php                                     ; 983C 08                       .
        lsr     L8C58                           ; 983D 4E 58 8C                 NX.
        asl     $07                             ; 9840 06 07                    ..
        php                                     ; 9842 08                       .
        php                                     ; 9843 08                       .
        php                                     ; 9844 08                       .
        lsr     $11,x                           ; 9845 56 11                    V.
        .byte   $12                             ; 9847 12                       .
        asl     $2E08                           ; 9848 0E 08 2E                 ...
        .byte   $2F                             ; 984B 2F                       /
        php                                     ; 984C 08                       .
        sta     $0867                           ; 984D 8D 67 08                 .g.
        php                                     ; 9850 08                       .
        php                                     ; 9851 08                       .
        php                                     ; 9852 08                       .
        php                                     ; 9853 08                       .
        php                                     ; 9854 08                       .
        php                                     ; 9855 08                       .
        .byte   $4F                             ; 9856 4F                       O
        php                                     ; 9857 08                       .
        php                                     ; 9858 08                       .
        php                                     ; 9859 08                       .
        php                                     ; 985A 08                       .
        php                                     ; 985B 08                       .
        ora     ($12),y                         ; 985C 11 12                    ..
        .byte   $4F                             ; 985E 4F                       O
        php                                     ; 985F 08                       .
        php                                     ; 9860 08                       .
        rol     $082F                           ; 9861 2E 2F 08                 ./.
        php                                     ; 9864 08                       .
        php                                     ; 9865 08                       .
        stx     $088F                           ; 9866 8E 8F 08                 ...
        php                                     ; 9869 08                       .
        php                                     ; 986A 08                       .
        php                                     ; 986B 08                       .
        php                                     ; 986C 08                       .
        php                                     ; 986D 08                       .
        php                                     ; 986E 08                       .
        php                                     ; 986F 08                       .
        ora     $08,x                           ; 9870 15 08                    ..
        php                                     ; 9872 08                       .
        lsr     $47                             ; 9873 46 47                    FG
L9875:  .byte   $63                             ; 9875 63                       c
        .byte   $64                             ; 9876 64                       d
        adc     $90                             ; 9877 65 90                    e.
        sta     ($4E),y                         ; 9879 91 4E                    .N
        .byte   $4B                             ; 987B 4B                       K
        jmp     L084D                           ; 987C 4C 4D 08                 LM.

; ----------------------------------------------------------------------------
        php                                     ; 987F 08                       .
        php                                     ; 9880 08                       .
        lsr     $08,x                           ; 9881 56 08                    V.
        php                                     ; 9883 08                       .
        php                                     ; 9884 08                       .
L9885:  php                                     ; 9885 08                       .
        php                                     ; 9886 08                       .
        lsr     $5608                           ; 9887 4E 08 56                 N.V
        php                                     ; 988A 08                       .
        php                                     ; 988B 08                       .
        asl     $08,x                           ; 988C 16 08                    ..
        .byte   $57                             ; 988E 57                       W
        cli                                     ; 988F 58                       X
        php                                     ; 9890 08                       .
        lsr     $11,x                           ; 9891 56 11                    V.
        .byte   $12                             ; 9893 12                       .
        php                                     ; 9894 08                       .
        php                                     ; 9895 08                       .
        .byte   $5C                             ; 9896 5C                       \
        eor     $5A15,x                         ; 9897 5D 15 5A                 ].Z
        .byte   $5F                             ; 989A 5F                       _
        php                                     ; 989B 08                       .
        php                                     ; 989C 08                       .
        php                                     ; 989D 08                       .
        php                                     ; 989E 08                       .
        asl     a                               ; 989F 0A                       .
        adc     #$08                            ; 98A0 69 08                    i.
        php                                     ; 98A2 08                       .
        .byte   $5A                             ; 98A3 5A                       Z
        .byte   $5F                             ; 98A4 5F                       _
        .byte   $92                             ; 98A5 92                       .
        php                                     ; 98A6 08                       .
        .byte   $57                             ; 98A7 57                       W
        .byte   $62                             ; 98A8 62                       b
        php                                     ; 98A9 08                       .
        php                                     ; 98AA 08                       .
        ora     ($12),y                         ; 98AB 11 12                    ..
        lsr     $08,x                           ; 98AD 56 08                    V.
        .byte   $5C                             ; 98AF 5C                       \
        pla                                     ; 98B0 68                       h
L98B1:  ora     $08,x                           ; 98B1 15 08                    ..
        php                                     ; 98B3 08                       .
        php                                     ; 98B4 08                       .
        lsr     $08,x                           ; 98B5 56 08                    V.
        php                                     ; 98B7 08                       .
        brk                                     ; 98B8 00                       .
        adc     #$08                            ; 98B9 69 08                    i.
        php                                     ; 98BB 08                       .
        php                                     ; 98BC 08                       .
        lsr     $08,x                           ; 98BD 56 08                    V.
        php                                     ; 98BF 08                       .
        brk                                     ; 98C0 00                       .
        brk                                     ; 98C1 00                       .
        brk                                     ; 98C2 00                       .
        brk                                     ; 98C3 00                       .
        brk                                     ; 98C4 00                       .
        brk                                     ; 98C5 00                       .
        brk                                     ; 98C6 00                       .
        brk                                     ; 98C7 00                       .
        brk                                     ; 98C8 00                       .
        brk                                     ; 98C9 00                       .
        brk                                     ; 98CA 00                       .
        brk                                     ; 98CB 00                       .
        brk                                     ; 98CC 00                       .
        ora     L0000                           ; 98CD 05 00                    ..
        .byte   $93                             ; 98CF 93                       .
        brk                                     ; 98D0 00                       .
        ora     L0000                           ; 98D1 05 00                    ..
        .byte   $03                             ; 98D3 03                       .
        .byte   $04                             ; 98D4 04                       .
        brk                                     ; 98D5 00                       .
        .byte   $7B                             ; 98D6 7B                       {
        ora     $0C0B                           ; 98D7 0D 0B 0C                 ...
        ora     $7170                           ; 98DA 0D 70 71                 .pq
        .byte   $72                             ; 98DD 72                       r
        .byte   $7F                             ; 98DE 7F                       .
        php                                     ; 98DF 08                       .
        .byte   $3C                             ; 98E0 3C                       <
        bpl     L98EB                           ; 98E1 10 08                    ..
        php                                     ; 98E3 08                       .
        php                                     ; 98E4 08                       .
        php                                     ; 98E5 08                       .
        php                                     ; 98E6 08                       .
        sty     $08,x                           ; 98E7 94 08                    ..
        php                                     ; 98E9 08                       .
        php                                     ; 98EA 08                       .
L98EB:  asl     $08,x                           ; 98EB 16 08                    ..
        sty     $95,x                           ; 98ED 94 95                    ..
        stx     $08,y                           ; 98EF 96 08                    ..
        .byte   $97                             ; 98F1 97                       .
        sta     $98                             ; 98F2 85 98                    ..
        sta     $99                             ; 98F4 85 99                    ..
        txs                                     ; 98F6 9A                       .
        .byte   $9B                             ; 98F7 9B                       .
        php                                     ; 98F8 08                       .
        .byte   $9C                             ; 98F9 9C                       .
        sta     L9D9D,x                         ; 98FA 9D 9D 9D                 ...
        .byte   $9E                             ; 98FD 9E                       .
        .byte   $9F                             ; 98FE 9F                       .
        ldy     #$00                            ; 98FF A0 00                    ..
        .byte   $7B                             ; 9901 7B                       {
        ora     $080E                           ; 9902 0D 0E 08                 ...
        php                                     ; 9905 08                       .
        adc     ($72),y                         ; 9906 71 72                    qr
        asl     $7F                             ; 9908 06 7F                    ..
        php                                     ; 990A 08                       .
        php                                     ; 990B 08                       .
        lsr     $A108,x                         ; 990C 5E 08 A1                 ^..
        ror     L000E                           ; 990F 66 0E                    f.
        rol     $082F                           ; 9911 2E 2F 08                 ./.
        php                                     ; 9914 08                       .
        ldx     #$A3                            ; 9915 A2 A3                    ..
        php                                     ; 9917 08                       .
        php                                     ; 9918 08                       .
        php                                     ; 9919 08                       .
        php                                     ; 991A 08                       .
        php                                     ; 991B 08                       .
        lda     ($66,x)                         ; 991C A1 66                    .f
        .byte   $A4                             ; 991E A4                       .
L991F:  lda     $95                             ; 991F A5 95                    ..
        ldx     $08                             ; 9921 A6 08                    ..
        ldx     #$A3                            ; 9923 A2 A3                    ..
        php                                     ; 9925 08                       .
        ora     ($12),y                         ; 9926 11 12                    ..
        txs                                     ; 9928 9A                       .
        .byte   $A7                             ; 9929 A7                       .
        sta     $A8,x                           ; 992A 95 A8                    ..
        lda     #$95                            ; 992C A9 95                    ..
        tay                                     ; 992E A8                       .
        lda     #$9B                            ; 992F A9 9B                    ..
        .byte   $9B                             ; 9931 9B                       .
        txs                                     ; 9932 9A                       .
        .byte   $9B                             ; 9933 9B                       .
        .byte   $9B                             ; 9934 9B                       .
        txs                                     ; 9935 9A                       .
        .byte   $9B                             ; 9936 9B                       .
        .byte   $9B                             ; 9937 9B                       .
        tax                                     ; 9938 AA                       .
        .byte   $9F                             ; 9939 9F                       .
        ldy     #$AA                            ; 993A A0 AA                    ..
        .byte   $9F                             ; 993C 9F                       .
        ldy     #$9F                            ; 993D A0 9F                    ..
        ldy     #$7F                            ; 993F A0 7F                    ..
        php                                     ; 9941 08                       .
        ora     ($12),y                         ; 9942 11 12                    ..
        php                                     ; 9944 08                       .
        .byte   $13                             ; 9945 13                       .
        php                                     ; 9946 08                       .
        lsr     $A4,x                           ; 9947 56 A4                    V.
        ror     $A4                             ; 9949 66 A4                    f.
        ror     $A4                             ; 994B 66 A4                    f.
        .byte   $AB                             ; 994D AB                       .
        php                                     ; 994E 08                       .
L994F:  lsr     $08,x                           ; 994F 56 08                    V.
        ora     ($12),y                         ; 9951 11 12                    ..
        php                                     ; 9953 08                       .
        php                                     ; 9954 08                       .
        .byte   $83                             ; 9955 83                       .
        php                                     ; 9956 08                       .
        lsr     $66,x                           ; 9957 56 66                    Vf
        ldy     $A5                             ; 9959 A4 A5                    ..
        ror     $A4                             ; 995B 66 A4                    f.
        .byte   $AB                             ; 995D AB                       .
        lsr     $0856,x                         ; 995E 5E 56 08                 ^V.
        php                                     ; 9961 08                       .
        .byte   $13                             ; 9962 13                       .
        php                                     ; 9963 08                       .
        php                                     ; 9964 08                       .
        asl     $08,x                           ; 9965 16 08                    ..
        lsr     $95,x                           ; 9967 56 95                    V.
        tay                                     ; 9969 A8                       .
        lda     #$95                            ; 996A A9 95                    ..
        tay                                     ; 996C A8                       .
        sta     $A8,x                           ; 996D 95 A8                    ..
        ldy     L9B9A                           ; 996F AC 9A 9B                 ...
        .byte   $9B                             ; 9972 9B                       .
        txs                                     ; 9973 9A                       .
        .byte   $9B                             ; 9974 9B                       .
        .byte   $9B                             ; 9975 9B                       .
        txs                                     ; 9976 9A                       .
        lda     L9FAA                           ; 9977 AD AA 9F                 ...
        .byte   $9F                             ; 997A 9F                       .
        ldy     #$9F                            ; 997B A0 9F                    ..
        ldy     #$9F                            ; 997D A0 9F                    ..
        ldx     $4F08                           ; 997F AE 08 4F                 ..O
        php                                     ; 9982 08                       .
        php                                     ; 9983 08                       .
        php                                     ; 9984 08                       .
        php                                     ; 9985 08                       .
        php                                     ; 9986 08                       .
        lsr     $AF11                           ; 9987 4E 11 AF                 N..
        php                                     ; 998A 08                       .
        php                                     ; 998B 08                       .
        php                                     ; 998C 08                       .
        php                                     ; 998D 08                       .
        .byte   $57                             ; 998E 57                       W
        cli                                     ; 998F 58                       X
        php                                     ; 9990 08                       .
        .byte   $4F                             ; 9991 4F                       O
        php                                     ; 9992 08                       .
        php                                     ; 9993 08                       .
        ora     ($12),y                         ; 9994 11 12                    ..
        .byte   $5C                             ; 9996 5C                       \
        .byte   $5D                             ; 9997 5D                       ]
        php                                     ; 9998 08                       .
L9999:  .byte   $4F                             ; 9999 4F                       O
        php                                     ; 999A 08                       .
        php                                     ; 999B 08                       .
        php                                     ; 999C 08                       .
        php                                     ; 999D 08                       .
        php                                     ; 999E 08                       .
        asl     a                               ; 999F 0A                       .
        .byte   $2F                             ; 99A0 2F                       /
        bcs     L99B9                           ; 99A1 B0 16                    ..
        php                                     ; 99A3 08                       .
        php                                     ; 99A4 08                       .
        .byte   $13                             ; 99A5 13                       .
        php                                     ; 99A6 08                       .
        .byte   $57                             ; 99A7 57                       W
        ora     $081C,y                         ; 99A8 19 1C 08                 ...
        php                                     ; 99AB 08                       .
        php                                     ; 99AC 08                       .
        php                                     ; 99AD 08                       .
        php                                     ; 99AE 08                       .
        .byte   $5C                             ; 99AF 5C                       \
        asl     L98B1,x                         ; 99B0 1E B1 98                 ...
        sta     $85                             ; 99B3 85 85                    ..
        tya                                     ; 99B5 98                       .
        .byte   $B2                             ; 99B6 B2                       .
        .byte   $92                             ; 99B7 92                       .
        .byte   $A0                             ; 99B8 A0                       .
L99B9:  ldy     #$9F                            ; 99B9 A0 9F                    ..
        ldy     #$A0                            ; 99BB A0 A0                    ..
        .byte   $9F                             ; 99BD 9F                       .
        .byte   $B3                             ; 99BE B3                       .
        lsr     L0000,x                         ; 99BF 56 00                    V.
        brk                                     ; 99C1 00                       .
        brk                                     ; 99C2 00                       .
        brk                                     ; 99C3 00                       .
        brk                                     ; 99C4 00                       .
        brk                                     ; 99C5 00                       .
        brk                                     ; 99C6 00                       .
        brk                                     ; 99C7 00                       .
        brk                                     ; 99C8 00                       .
        brk                                     ; 99C9 00                       .
        brk                                     ; 99CA 00                       .
        brk                                     ; 99CB 00                       .
        brk                                     ; 99CC 00                       .
        brk                                     ; 99CD 00                       .
        brk                                     ; 99CE 00                       .
        brk                                     ; 99CF 00                       .
        brk                                     ; 99D0 00                       .
        brk                                     ; 99D1 00                       .
        brk                                     ; 99D2 00                       .
        brk                                     ; 99D3 00                       .
        brk                                     ; 99D4 00                       .
        ora     L0000                           ; 99D5 05 00                    ..
        .byte   $93                             ; 99D7 93                       .
        brk                                     ; 99D8 00                       .
        ora     L0000                           ; 99D9 05 00                    ..
        .byte   $03                             ; 99DB 03                       .
        .byte   $04                             ; 99DC 04                       .
        brk                                     ; 99DD 00                       .
        .byte   $7B                             ; 99DE 7B                       {
        ora     $0C0B                           ; 99DF 0D 0B 0C                 ...
        ora     $7170                           ; 99E2 0D 70 71                 .pq
        .byte   $72                             ; 99E5 72                       r
        .byte   $7F                             ; 99E6 7F                       .
        php                                     ; 99E7 08                       .
        .byte   $3C                             ; 99E8 3C                       <
        bpl     L99F3                           ; 99E9 10 08                    ..
        php                                     ; 99EB 08                       .
        php                                     ; 99EC 08                       .
        php                                     ; 99ED 08                       .
        php                                     ; 99EE 08                       .
        php                                     ; 99EF 08                       .
        php                                     ; 99F0 08                       .
        .byte   $59                             ; 99F1 59                       Y
        .byte   $B4                             ; 99F2 B4                       .
L99F3:  sta     $98                             ; 99F3 85 98                    ..
        tya                                     ; 99F5 98                       .
        sta     $85                             ; 99F6 85 85                    ..
        php                                     ; 99F8 08                       .
        .byte   $4F                             ; 99F9 4F                       O
        .byte   $9E                             ; 99FA 9E                       .
        ldy     #$9F                            ; 99FB A0 9F                    ..
        .byte   $9F                             ; 99FD 9F                       .
        ldy     #$AA                            ; 99FE A0 AA                    ..
        brk                                     ; 9A00 00                       .
        brk                                     ; 9A01 00                       .
        brk                                     ; 9A02 00                       .
        brk                                     ; 9A03 00                       .
        brk                                     ; 9A04 00                       .
        brk                                     ; 9A05 00                       .
        brk                                     ; 9A06 00                       .
        brk                                     ; 9A07 00                       .
        brk                                     ; 9A08 00                       .
        brk                                     ; 9A09 00                       .
        brk                                     ; 9A0A 00                       .
        brk                                     ; 9A0B 00                       .
        brk                                     ; 9A0C 00                       .
        brk                                     ; 9A0D 00                       .
        brk                                     ; 9A0E 00                       .
        brk                                     ; 9A0F 00                       .
        .byte   $03                             ; 9A10 03                       .
        .byte   $04                             ; 9A11 04                       .
        brk                                     ; 9A12 00                       .
        brk                                     ; 9A13 00                       .
        brk                                     ; 9A14 00                       .
        brk                                     ; 9A15 00                       .
        brk                                     ; 9A16 00                       .
        ora     (L0070,x)                       ; 9A17 01 70                    .p
        adc     ($04),y                         ; 9A19 71 04                    q.
        brk                                     ; 9A1B 00                       .
        ora     L0000                           ; 9A1C 05 00                    ..
        asl     $07                             ; 9A1E 06 07                    ..
        php                                     ; 9A20 08                       .
        php                                     ; 9A21 08                       .
        asl     a                               ; 9A22 0A                       .
        .byte   $0B                             ; 9A23 0B                       .
        .byte   $0C                             ; 9A24 0C                       .
        ora     $080E                           ; 9A25 0D 0E 08                 ...
        lsr     $0808,x                         ; 9A28 5E 08 08                 ^..
        .byte   $3C                             ; 9A2B 3C                       <
        bpl     L9A36                           ; 9A2C 10 08                    ..
        php                                     ; 9A2E 08                       .
        php                                     ; 9A2F 08                       .
        tya                                     ; 9A30 98                       .
        .byte   $B2                             ; 9A31 B2                       .
        php                                     ; 9A32 08                       .
        lda     $B5,x                           ; 9A33 B5 B5                    ..
        .byte   $B5                             ; 9A35 B5                       .
L9A36:  lda     $B5,x                           ; 9A36 B5 B5                    ..
        ldy     #$B3                            ; 9A38 A0 B3                    ..
        php                                     ; 9A3A 08                       .
        php                                     ; 9A3B 08                       .
        php                                     ; 9A3C 08                       .
        ora     ($12),y                         ; 9A3D 11 12                    ..
        php                                     ; 9A3F 08                       .
        brk                                     ; 9A40 00                       .
        brk                                     ; 9A41 00                       .
        brk                                     ; 9A42 00                       .
        brk                                     ; 9A43 00                       .
        brk                                     ; 9A44 00                       .
        brk                                     ; 9A45 00                       .
        brk                                     ; 9A46 00                       .
        ora     (L0000,x)                       ; 9A47 01 00                    ..
        .byte   $03                             ; 9A49 03                       .
        .byte   $04                             ; 9A4A 04                       .
        brk                                     ; 9A4B 00                       .
        brk                                     ; 9A4C 00                       .
        brk                                     ; 9A4D 00                       .
        asl     $07                             ; 9A4E 06 07                    ..
        ora     $0A70                           ; 9A50 0D 70 0A                 .p.
        .byte   $0B                             ; 9A53 0B                       .
        .byte   $0C                             ; 9A54 0C                       .
        ora     $080E                           ; 9A55 0D 0E 08                 ...
        php                                     ; 9A58 08                       .
        php                                     ; 9A59 08                       .
        php                                     ; 9A5A 08                       .
        .byte   $3C                             ; 9A5B 3C                       <
        bpl     L9A66                           ; 9A5C 10 08                    ..
        php                                     ; 9A5E 08                       .
        php                                     ; 9A5F 08                       .
        php                                     ; 9A60 08                       .
        php                                     ; 9A61 08                       .
        php                                     ; 9A62 08                       .
        php                                     ; 9A63 08                       .
        .byte   $2E                             ; 9A64 2E                       .
        .byte   $2F                             ; 9A65 2F                       /
L9A66:  php                                     ; 9A66 08                       .
        php                                     ; 9A67 08                       .
        php                                     ; 9A68 08                       .
        lsr     $0808,x                         ; 9A69 5E 08 08                 ^..
        php                                     ; 9A6C 08                       .
        php                                     ; 9A6D 08                       .
        php                                     ; 9A6E 08                       .
        php                                     ; 9A6F 08                       .
        lda     $B5,x                           ; 9A70 B5 B5                    ..
        lda     $B5,x                           ; 9A72 B5 B5                    ..
        php                                     ; 9A74 08                       .
        lda     $B5,x                           ; 9A75 B5 B5                    ..
        lda     $08,x                           ; 9A77 B5 08                    ..
        php                                     ; 9A79 08                       .
        php                                     ; 9A7A 08                       .
        ldx     $54,y                           ; 9A7B B6 54                    .T
        sta     ($B7),y                         ; 9A7D 91 B7                    ..
        php                                     ; 9A7F 08                       .
        ora     $0A70                           ; 9A80 0D 70 0A                 .p.
        .byte   $0B                             ; 9A83 0B                       .
        .byte   $0C                             ; 9A84 0C                       .
        ora     $B80E                           ; 9A85 0D 0E B8                 ...
        php                                     ; 9A88 08                       .
        php                                     ; 9A89 08                       .
        php                                     ; 9A8A 08                       .
        .byte   $3C                             ; 9A8B 3C                       <
        bpl     L9A96                           ; 9A8C 10 08                    ..
        php                                     ; 9A8E 08                       .
        lda     $1108,y                         ; 9A8F B9 08 11                 ...
        .byte   $12                             ; 9A92 12                       .
        php                                     ; 9A93 08                       .
        php                                     ; 9A94 08                       .
        php                                     ; 9A95 08                       .
L9A96:  php                                     ; 9A96 08                       .
        clv                                     ; 9A97 B8                       .
        php                                     ; 9A98 08                       .
        php                                     ; 9A99 08                       .
        php                                     ; 9A9A 08                       .
        php                                     ; 9A9B 08                       .
        php                                     ; 9A9C 08                       .
        php                                     ; 9A9D 08                       .
        php                                     ; 9A9E 08                       .
        lda     $0808,y                         ; 9A9F B9 08 08                 ...
        php                                     ; 9AA2 08                       .
        php                                     ; 9AA3 08                       .
        php                                     ; 9AA4 08                       .
        php                                     ; 9AA5 08                       .
        ora     ($12),y                         ; 9AA6 11 12                    ..
        php                                     ; 9AA8 08                       .
        php                                     ; 9AA9 08                       .
        php                                     ; 9AAA 08                       .
        php                                     ; 9AAB 08                       .
        php                                     ; 9AAC 08                       .
        php                                     ; 9AAD 08                       .
        php                                     ; 9AAE 08                       .
        php                                     ; 9AAF 08                       .
        lda     $B5,x                           ; 9AB0 B5 B5                    ..
        .byte   $13                             ; 9AB2 13                       .
        tsx                                     ; 9AB3 BA                       .
        lda     $B5,x                           ; 9AB4 B5 B5                    ..
        php                                     ; 9AB6 08                       .
        .byte   $83                             ; 9AB7 83                       .
        php                                     ; 9AB8 08                       .
        php                                     ; 9AB9 08                       .
        php                                     ; 9ABA 08                       .
        ldx     $54,y                           ; 9ABB B6 54                    .T
        sta     ($B7),y                         ; 9ABD 91 B7                    ..
        .byte   $83                             ; 9ABF 83                       .
        .byte   $22                             ; 9AC0 22                       "
        php                                     ; 9AC1 08                       .
        php                                     ; 9AC2 08                       .
        php                                     ; 9AC3 08                       .
        .byte   $BB                             ; 9AC4 BB                       .
        ldy     $BDBC,x                         ; 9AC5 BC BC BD                 ...
        .byte   $22                             ; 9AC8 22                       "
        ora     ($12),y                         ; 9AC9 11 12                    ..
        php                                     ; 9ACB 08                       .
        ldx     $BFBF,y                         ; 9ACC BE BF BF                 ...
        cpy     #$22                            ; 9ACF C0 22                    ."
        php                                     ; 9AD1 08                       .
        php                                     ; 9AD2 08                       .
        php                                     ; 9AD3 08                       .
        ora     ($12),y                         ; 9AD4 11 12                    ..
        php                                     ; 9AD6 08                       .
        .byte   $23                             ; 9AD7 23                       #
        cmp     ($C2,x)                         ; 9AD8 C1 C2                    ..
        .byte   $C2                             ; 9ADA C2                       .
        .byte   $C2                             ; 9ADB C2                       .
        .byte   $C2                             ; 9ADC C2                       .
        .byte   $5B                             ; 9ADD 5B                       [
        .byte   $13                             ; 9ADE 13                       .
        .byte   $23                             ; 9ADF 23                       #
        .byte   $C3                             ; 9AE0 C3                       .
        cpy     $C4                             ; 9AE1 C4 C4                    ..
        cpy     $C4                             ; 9AE3 C4 C4                    ..
        php                                     ; 9AE5 08                       .
        php                                     ; 9AE6 08                       .
        .byte   $23                             ; 9AE7 23                       #
        .byte   $22                             ; 9AE8 22                       "
        php                                     ; 9AE9 08                       .
        php                                     ; 9AEA 08                       .
        asl     $08,x                           ; 9AEB 16 08                    ..
        php                                     ; 9AED 08                       .
        php                                     ; 9AEE 08                       .
        .byte   $23                             ; 9AEF 23                       #
        bit     $25                             ; 9AF0 24 25                    $%
        rol     $27                             ; 9AF2 26 27                    &'
        and     $26                             ; 9AF4 25 26                    %&
        .byte   $27                             ; 9AF6 27                       '
        plp                                     ; 9AF7 28                       (
        and     #$2A                            ; 9AF8 29 2A                    )*
        .byte   $2B                             ; 9AFA 2B                       +
        bit     $2B2A                           ; 9AFB 2C 2A 2B                 ,*+
        bit     $222D                           ; 9AFE 2C 2D 22                 ,-"
        php                                     ; 9B01 08                       .
        php                                     ; 9B02 08                       .
        cmp     $C4                             ; 9B03 C5 C4                    ..
        cpy     $C4                             ; 9B05 C4 C4                    ..
        dec     $C1                             ; 9B07 C6 C1                    ..
        .byte   $C2                             ; 9B09 C2                       .
        .byte   $C2                             ; 9B0A C2                       .
        .byte   $5B                             ; 9B0B 5B                       [
        rts                                     ; 9B0C 60                       `

; ----------------------------------------------------------------------------
        .byte   $C2                             ; 9B0D C2                       .
        .byte   $C2                             ; 9B0E C2                       .
        .byte   $C7                             ; 9B0F C7                       .
        .byte   $C3                             ; 9B10 C3                       .
        cpy     $C4                             ; 9B11 C4 C4                    ..
        ora     ($12),y                         ; 9B13 11 12                    ..
        cpy     $C4                             ; 9B15 C4 C4                    ..
        dec     $22                             ; 9B17 C6 22                    ."
        rts                                     ; 9B19 60                       `

; ----------------------------------------------------------------------------
        .byte   $C2                             ; 9B1A C2                       .
        .byte   $C2                             ; 9B1B C2                       .
        .byte   $C2                             ; 9B1C C2                       .
        .byte   $C2                             ; 9B1D C2                       .
        .byte   $5B                             ; 9B1E 5B                       [
        .byte   $23                             ; 9B1F 23                       #
        .byte   $22                             ; 9B20 22                       "
        asl     $C4,x                           ; 9B21 16 C4                    ..
        cpy     $C4                             ; 9B23 C4 C4                    ..
        cpy     $08                             ; 9B25 C4 08                    ..
        .byte   $23                             ; 9B27 23                       #
        .byte   $22                             ; 9B28 22                       "
        iny                                     ; 9B29 C8                       .
        ldy     $08C9,x                         ; 9B2A BC C9 08                 ...
        iny                                     ; 9B2D C8                       .
        ldy     $22BD,x                         ; 9B2E BC BD 22                 .."
        php                                     ; 9B31 08                       .
        .byte   $BF                             ; 9B32 BF                       .
        dex                                     ; 9B33 CA                       .
        ora     ($12),y                         ; 9B34 11 12                    ..
        .byte   $BF                             ; 9B36 BF                       .
        cpy     #$22                            ; 9B37 C0 22                    ."
        php                                     ; 9B39 08                       .
        php                                     ; 9B3A 08                       .
        php                                     ; 9B3B 08                       .
        php                                     ; 9B3C 08                       .
        php                                     ; 9B3D 08                       .
        php                                     ; 9B3E 08                       .
        .byte   $23                             ; 9B3F 23                       #
        brk                                     ; 9B40 00                       .
        .byte   $03                             ; 9B41 03                       .
        .byte   $04                             ; 9B42 04                       .
        brk                                     ; 9B43 00                       .
        .byte   $7B                             ; 9B44 7B                       {
        ora     $230E                           ; 9B45 0D 0E 23                 ..#
        ora     $7170                           ; 9B48 0D 70 71                 .pq
        .byte   $72                             ; 9B4B 72                       r
        .byte   $7F                             ; 9B4C 7F                       .
        php                                     ; 9B4D 08                       .
        php                                     ; 9B4E 08                       .
        .byte   $23                             ; 9B4F 23                       #
        .byte   $22                             ; 9B50 22                       "
        php                                     ; 9B51 08                       .
        php                                     ; 9B52 08                       .
        php                                     ; 9B53 08                       .
        php                                     ; 9B54 08                       .
        php                                     ; 9B55 08                       .
        php                                     ; 9B56 08                       .
        .byte   $23                             ; 9B57 23                       #
        .byte   $22                             ; 9B58 22                       "
        php                                     ; 9B59 08                       .
        php                                     ; 9B5A 08                       .
        php                                     ; 9B5B 08                       .
        php                                     ; 9B5C 08                       .
        ora     ($12),y                         ; 9B5D 11 12                    ..
        .byte   $23                             ; 9B5F 23                       #
        .byte   $22                             ; 9B60 22                       "
        asl     $08,x                           ; 9B61 16 08                    ..
        php                                     ; 9B63 08                       .
        php                                     ; 9B64 08                       .
        php                                     ; 9B65 08                       .
        php                                     ; 9B66 08                       .
        .byte   $23                             ; 9B67 23                       #
        .byte   $22                             ; 9B68 22                       "
        php                                     ; 9B69 08                       .
        php                                     ; 9B6A 08                       .
        .byte   $CB                             ; 9B6B CB                       .
        cpy     L9885                           ; 9B6C CC 85 98                 ...
        cmp     $6022                           ; 9B6F CD 22 60                 ."`
        .byte   $C2                             ; 9B72 C2                       .
        dec     $CFCF                           ; 9B73 CE CF CF                 ...
        .byte   $CF                             ; 9B76 CF                       .
        bne     L9B9B                           ; 9B77 D0 22                    ."
        php                                     ; 9B79 08                       .
        cpy     $D1                             ; 9B7A C4 D1                    ..
        .byte   $BF                             ; 9B7C BF                       .
        .byte   $BF                             ; 9B7D BF                       .
        .byte   $BF                             ; 9B7E BF                       .
        cpy     #$3C                            ; 9B7F C0 3C                    .<
        and     a:$04,x                         ; 9B81 3D 04 00                 =..
        ora     L0000                           ; 9B84 05 00                    ..
        .byte   $03                             ; 9B86 03                       .
        .byte   $04                             ; 9B87 04                       .
        php                                     ; 9B88 08                       .
        php                                     ; 9B89 08                       .
        asl     a                               ; 9B8A 0A                       .
        .byte   $0B                             ; 9B8B 0B                       .
        .byte   $0C                             ; 9B8C 0C                       .
        ora     $7170                           ; 9B8D 0D 70 71                 .pq
        php                                     ; 9B90 08                       .
        php                                     ; 9B91 08                       .
        php                                     ; 9B92 08                       .
        .byte   $0F                             ; 9B93 0F                       .
        bpl     L9B9E                           ; 9B94 10 08                    ..
        php                                     ; 9B96 08                       .
        php                                     ; 9B97 08                       .
        php                                     ; 9B98 08                       .
        .byte   $11                             ; 9B99 11                       .
L9B9A:  .byte   $12                             ; 9B9A 12                       .
L9B9B:  clv                                     ; 9B9B B8                       .
        php                                     ; 9B9C 08                       .
        php                                     ; 9B9D 08                       .
L9B9E:  php                                     ; 9B9E 08                       .
        php                                     ; 9B9F 08                       .
        php                                     ; 9BA0 08                       .
        php                                     ; 9BA1 08                       .
        .byte   $D2                             ; 9BA2 D2                       .
        lda     $6308,y                         ; 9BA3 B9 08 63                 ..c
        .byte   $64                             ; 9BA6 64                       d
        adc     $D3                             ; 9BA7 65 D3                    e.
        .byte   $1C                             ; 9BA9 1C                       .
        .byte   $D4                             ; 9BAA D4                       .
        lda     $0813,y                         ; 9BAB B9 13 08                 ...
        php                                     ; 9BAE 08                       .
        php                                     ; 9BAF 08                       .
        adc     $D421,y                         ; 9BB0 79 21 D4                 y!.
        lda     $4608,y                         ; 9BB3 B9 08 46                 ..F
        .byte   $47                             ; 9BB6 47                       G
        php                                     ; 9BB7 08                       .
        php                                     ; 9BB8 08                       .
        php                                     ; 9BB9 08                       .
        .byte   $D4                             ; 9BBA D4                       .
        lda     $4B4E,y                         ; 9BBB B9 4E 4B                 .NK
        jmp     L004D                           ; 9BBE 4C 4D 00                 LM.

; ----------------------------------------------------------------------------
        .byte   $7B                             ; 9BC1 7B                       {
        .byte   $7C                             ; 9BC2 7C                       |
        adc     ($72),y                         ; 9BC3 71 72                    qr
        .byte   $7F                             ; 9BC5 7F                       .
        .byte   $3C                             ; 9BC6 3C                       <
        and     $7F72,x                         ; 9BC7 3D 72 7F                 =r.
        php                                     ; 9BCA 08                       .
        php                                     ; 9BCB 08                       .
        php                                     ; 9BCC 08                       .
        php                                     ; 9BCD 08                       .
        php                                     ; 9BCE 08                       .
        php                                     ; 9BCF 08                       .
        php                                     ; 9BD0 08                       .
        php                                     ; 9BD1 08                       .
        php                                     ; 9BD2 08                       .
        lsr     $0808,x                         ; 9BD3 5E 08 08                 ^..
        php                                     ; 9BD6 08                       .
        php                                     ; 9BD7 08                       .
        asl     $08,x                           ; 9BD8 16 08                    ..
        php                                     ; 9BDA 08                       .
        php                                     ; 9BDB 08                       .
        php                                     ; 9BDC 08                       .
        .byte   $13                             ; 9BDD 13                       .
        php                                     ; 9BDE 08                       .
        php                                     ; 9BDF 08                       .
        php                                     ; 9BE0 08                       .
        .byte   $D2                             ; 9BE1 D2                       .
        php                                     ; 9BE2 08                       .
        php                                     ; 9BE3 08                       .
        php                                     ; 9BE4 08                       .
        php                                     ; 9BE5 08                       .
        php                                     ; 9BE6 08                       .
        php                                     ; 9BE7 08                       .
        php                                     ; 9BE8 08                       .
        .byte   $D4                             ; 9BE9 D4                       .
        php                                     ; 9BEA 08                       .
        ora     ($12),y                         ; 9BEB 11 12                    ..
        cmp     $D6,x                           ; 9BED D5 D6                    ..
        .byte   $D7                             ; 9BEF D7                       .
        php                                     ; 9BF0 08                       .
        .byte   $D4                             ; 9BF1 D4                       .
        cld                                     ; 9BF2 D8                       .
        .byte   $34                             ; 9BF3 34                       4
        .byte   $1A                             ; 9BF4 1A                       .
        .byte   $1B                             ; 9BF5 1B                       .
        dey                                     ; 9BF6 88                       .
        .byte   $34                             ; 9BF7 34                       4
        php                                     ; 9BF8 08                       .
        .byte   $D4                             ; 9BF9 D4                       .
        cmp     $1F20,y                         ; 9BFA D9 20 1F                 . .
        jsr     L201F                           ; 9BFD 20 1F 20                  . 
        rol     $0403,x                         ; 9C00 3E 03 04                 >..
        brk                                     ; 9C03 00                       .
        ora     L0000                           ; 9C04 05 00                    ..
        asl     $07                             ; 9C06 06 07                    ..
        .byte   $3F                             ; 9C08 3F                       ?
        ora     #$0A                            ; 9C09 09 0A                    ..
        .byte   $0B                             ; 9C0B 0B                       .
        .byte   $0C                             ; 9C0C 0C                       .
        ora     $080E                           ; 9C0D 0D 0E 08                 ...
        php                                     ; 9C10 08                       .
        php                                     ; 9C11 08                       .
        php                                     ; 9C12 08                       .
        .byte   $0F                             ; 9C13 0F                       .
        bpl     L9C1E                           ; 9C14 10 08                    ..
        php                                     ; 9C16 08                       .
        .byte   $13                             ; 9C17 13                       .
        lsr     $0808,x                         ; 9C18 5E 08 08                 ^..
        php                                     ; 9C1B 08                       .
        .byte   $DA                             ; 9C1C DA                       .
        .byte   $DB                             ; 9C1D DB                       .
L9C1E:  php                                     ; 9C1E 08                       .
        php                                     ; 9C1F 08                       .
        php                                     ; 9C20 08                       .
        php                                     ; 9C21 08                       .
        .byte   $DA                             ; 9C22 DA                       .
        .byte   $DC                             ; 9C23 DC                       .
        .byte   $DC                             ; 9C24 DC                       .
        cmp     $0808,x                         ; 9C25 DD 08 08                 ...
        .byte   $DC                             ; 9C28 DC                       .
        .byte   $DC                             ; 9C29 DC                       .
        dec     $DBDC,x                         ; 9C2A DE DC DB                 ...
        php                                     ; 9C2D 08                       .
        php                                     ; 9C2E 08                       .
        php                                     ; 9C2F 08                       .
        ora     $341B,y                         ; 9C30 19 1B 34                 ..4
        ora     $0889,y                         ; 9C33 19 89 08                 ...
        adc     $19,x                           ; 9C36 75 19                    u.
        .byte   $DF                             ; 9C38 DF                       .
        .byte   $1F                             ; 9C39 1F                       .
        jsr     L8BDF                           ; 9C3A 20 DF 8B                  ..
        php                                     ; 9C3D 08                       .
        adc     $E0DF,y                         ; 9C3E 79 DF E0                 y..
        sbc     ($E1,x)                         ; 9C41 E1 E1                    ..
        .byte   $E2                             ; 9C43 E2                       .
        .byte   $E3                             ; 9C44 E3                       .
        php                                     ; 9C45 08                       .
        cpx     $9B                             ; 9C46 E4 9B                    ..
        sta     $E5                             ; 9C48 85 E5                    ..
        sta     $E6                             ; 9C4A 85 E6                    ..
        php                                     ; 9C4C 08                       .
        php                                     ; 9C4D 08                       .
        .byte   $E7                             ; 9C4E E7                       .
        inx                                     ; 9C4F E8                       .
        .byte   $9B                             ; 9C50 9B                       .
        .byte   $9B                             ; 9C51 9B                       .
        sbc     #$08                            ; 9C52 E9 08                    ..
        php                                     ; 9C54 08                       .
        nop                                     ; 9C55 EA                       .
        .byte   $9B                             ; 9C56 9B                       .
        txs                                     ; 9C57 9A                       .
        ora     $081C,y                         ; 9C58 19 1C 08                 ...
        php                                     ; 9C5B 08                       .
        .byte   $EB                             ; 9C5C EB                       .
        .byte   $34                             ; 9C5D 34                       4
        .byte   $1A                             ; 9C5E 1A                       .
        .byte   $1B                             ; 9C5F 1B                       .
        asl     $08EC,x                         ; 9C60 1E EC 08                 ...
        php                                     ; 9C63 08                       .
        sbc     $EEEE                           ; 9C64 ED EE EE                 ...
        .byte   $EF                             ; 9C67 EF                       .
        .byte   $9B                             ; 9C68 9B                       .
        beq     L9C73                           ; 9C69 F0 08                    ..
        php                                     ; 9C6B 08                       .
        php                                     ; 9C6C 08                       .
        php                                     ; 9C6D 08                       .
        php                                     ; 9C6E 08                       .
        sbc     ($19),y                         ; 9C6F F1 19                    ..
        .byte   $1A                             ; 9C71 1A                       .
        .byte   $1B                             ; 9C72 1B                       .
L9C73:  ora     $1A34,y                         ; 9C73 19 34 1A                 .4.
        ora     $1E34,y                         ; 9C76 19 34 1E                 .4.
        .byte   $F2                             ; 9C79 F2                       .
        .byte   $F2                             ; 9C7A F2                       .
        asl     $F2F2,x                         ; 9C7B 1E F2 F2                 ...
        .byte   $1E                             ; 9C7E 1E                       .
        .byte   $F2                             ; 9C7F F2                       .
L9C80:  .byte   $F3                             ; 9C80 F3                       .
        php                                     ; 9C81 08                       .
        php                                     ; 9C82 08                       .
        .byte   $F4                             ; 9C83 F4                       .
        txs                                     ; 9C84 9A                       .
        .byte   $9B                             ; 9C85 9B                       .
        txs                                     ; 9C86 9A                       .
        .byte   $9B                             ; 9C87 9B                       .
        sbc     $47,x                           ; 9C88 F5 47                    .G
        txa                                     ; 9C8A 8A                       .
        .byte   $14                             ; 9C8B 14                       .
        ora     $46,x                           ; 9C8C 15 46                    .F
        .byte   $47                             ; 9C8E 47                       G
        php                                     ; 9C8F 08                       .
        sbc     #$4C                            ; 9C90 E9 4C                    .L
        cli                                     ; 9C92 58                       X
        brk                                     ; 9C93 00                       .
        bcc     L9C80                           ; 9C94 90 EA                    ..
        txs                                     ; 9C96 9A                       .
        .byte   $9B                             ; 9C97 9B                       .
        .byte   $34                             ; 9C98 34                       4
        .byte   $1A                             ; 9C99 1A                       .
L9C9A:  .byte   $1B                             ; 9C9A 1B                       .
        .byte   $34                             ; 9C9B 34                       4
        .byte   $34                             ; 9C9C 34                       4
        .byte   $1A                             ; 9C9D 1A                       .
        .byte   $1B                             ; 9C9E 1B                       .
        .byte   $34                             ; 9C9F 34                       4
        inc     $EEEE                           ; 9CA0 EE EE EE                 ...
        inc     $EEEE                           ; 9CA3 EE EE EE                 ...
        inc     $08EF                           ; 9CA6 EE EF 08                 ...
        php                                     ; 9CA9 08                       .
        php                                     ; 9CAA 08                       .
        php                                     ; 9CAB 08                       .
        php                                     ; 9CAC 08                       .
        php                                     ; 9CAD 08                       .
        php                                     ; 9CAE 08                       .
        sbc     ($34),y                         ; 9CAF F1 34                    .4
        ora     $341B,y                         ; 9CB1 19 1B 34                 ..4
        .byte   $34                             ; 9CB4 34                       4
        .byte   $1A                             ; 9CB5 1A                       .
        .byte   $1B                             ; 9CB6 1B                       .
        .byte   $34                             ; 9CB7 34                       4
        .byte   $F2                             ; 9CB8 F2                       .
        asl     $F2F2,x                         ; 9CB9 1E F2 F2                 ...
        .byte   $F2                             ; 9CBC F2                       .
        .byte   $F2                             ; 9CBD F2                       .
        .byte   $F2                             ; 9CBE F2                       .
        .byte   $F2                             ; 9CBF F2                       .
        inc     $17,x                           ; 9CC0 F6 17                    ..
        .byte   $17                             ; 9CC2 17                       .
        .byte   $17                             ; 9CC3 17                       .
        .byte   $17                             ; 9CC4 17                       .
        .byte   $17                             ; 9CC5 17                       .
        .byte   $17                             ; 9CC6 17                       .
        .byte   $17                             ; 9CC7 17                       .
        .byte   $F7                             ; 9CC8 F7                       .
        brk                                     ; 9CC9 00                       .
        brk                                     ; 9CCA 00                       .
        brk                                     ; 9CCB 00                       .
        brk                                     ; 9CCC 00                       .
        brk                                     ; 9CCD 00                       .
        brk                                     ; 9CCE 00                       .
        sed                                     ; 9CCF F8                       .
        sbc     $727B,y                         ; 9CD0 F9 7B 72                 .{r
        .byte   $0B                             ; 9CD3 0B                       .
        brk                                     ; 9CD4 00                       .
        brk                                     ; 9CD5 00                       .
        brk                                     ; 9CD6 00                       .
        sed                                     ; 9CD7 F8                       .
        .byte   $FA                             ; 9CD8 FA                       .
        .byte   $7F                             ; 9CD9 7F                       .
        php                                     ; 9CDA 08                       .
        .byte   $0F                             ; 9CDB 0F                       .
        and     $033E,x                         ; 9CDC 3D 3E 03                 =>.
        .byte   $FB                             ; 9CDF FB                       .
        .byte   $FC                             ; 9CE0 FC                       .
        php                                     ; 9CE1 08                       .
        php                                     ; 9CE2 08                       .
        php                                     ; 9CE3 08                       .
        php                                     ; 9CE4 08                       .
        .byte   $3F                             ; 9CE5 3F                       ?
        ora     #$FD                            ; 9CE6 09 FD                    ..
        php                                     ; 9CE8 08                       .
        php                                     ; 9CE9 08                       .
        php                                     ; 9CEA 08                       .
        php                                     ; 9CEB 08                       .
        php                                     ; 9CEC 08                       .
        php                                     ; 9CED 08                       .
        php                                     ; 9CEE 08                       .
        inc     $1934,x                         ; 9CEF FE 34 19                 .4.
        .byte   $1B                             ; 9CF2 1B                       .
        .byte   $34                             ; 9CF3 34                       4
        .byte   $34                             ; 9CF4 34                       4
        .byte   $1A                             ; 9CF5 1A                       .
        ora     $F234,y                         ; 9CF6 19 34 F2                 .4.
        asl     $F2F2,x                         ; 9CF9 1E F2 F2                 ...
        .byte   $F2                             ; 9CFC F2                       .
        .byte   $F2                             ; 9CFD F2                       .
        asl     $22F2,x                         ; 9CFE 1E F2 22                 .."
        php                                     ; 9D01 08                       .
        php                                     ; 9D02 08                       .
        php                                     ; 9D03 08                       .
        php                                     ; 9D04 08                       .
        php                                     ; 9D05 08                       .
        asl     L0023,x                         ; 9D06 16 23                    .#
        .byte   $22                             ; 9D08 22                       "
        ora     ($12),y                         ; 9D09 11 12                    ..
        php                                     ; 9D0B 08                       .
        php                                     ; 9D0C 08                       .
        php                                     ; 9D0D 08                       .
        php                                     ; 9D0E 08                       .
        .byte   $23                             ; 9D0F 23                       #
        .byte   $22                             ; 9D10 22                       "
        php                                     ; 9D11 08                       .
        php                                     ; 9D12 08                       .
        asl     $08,x                           ; 9D13 16 08                    ..
        php                                     ; 9D15 08                       .
        php                                     ; 9D16 08                       .
        .byte   $23                             ; 9D17 23                       #
        .byte   $22                             ; 9D18 22                       "
        php                                     ; 9D19 08                       .
        php                                     ; 9D1A 08                       .
        php                                     ; 9D1B 08                       .
        php                                     ; 9D1C 08                       .
        php                                     ; 9D1D 08                       .
        php                                     ; 9D1E 08                       .
        .byte   $23                             ; 9D1F 23                       #
        .byte   $22                             ; 9D20 22                       "
        php                                     ; 9D21 08                       .
        ora     ($12),y                         ; 9D22 11 12                    ..
        php                                     ; 9D24 08                       .
        .byte   $13                             ; 9D25 13                       .
        php                                     ; 9D26 08                       .
        .byte   $23                             ; 9D27 23                       #
        .byte   $22                             ; 9D28 22                       "
        php                                     ; 9D29 08                       .
        php                                     ; 9D2A 08                       .
        php                                     ; 9D2B 08                       .
        php                                     ; 9D2C 08                       .
        php                                     ; 9D2D 08                       .
        php                                     ; 9D2E 08                       .
        .byte   $23                             ; 9D2F 23                       #
        .byte   $22                             ; 9D30 22                       "
        php                                     ; 9D31 08                       .
        php                                     ; 9D32 08                       .
        php                                     ; 9D33 08                       .
        php                                     ; 9D34 08                       .
        php                                     ; 9D35 08                       .
        php                                     ; 9D36 08                       .
        .byte   $23                             ; 9D37 23                       #
        .byte   $22                             ; 9D38 22                       "
        php                                     ; 9D39 08                       .
        php                                     ; 9D3A 08                       .
        php                                     ; 9D3B 08                       .
        php                                     ; 9D3C 08                       .
        php                                     ; 9D3D 08                       .
        php                                     ; 9D3E 08                       .
        .byte   $23                             ; 9D3F 23                       #
        brk                                     ; 9D40 00                       .
        .byte   $03                             ; 9D41 03                       .
        .byte   $04                             ; 9D42 04                       .
        brk                                     ; 9D43 00                       .
        .byte   $7B                             ; 9D44 7B                       {
        ora     $230E                           ; 9D45 0D 0E 23                 ..#
        ora     $7170                           ; 9D48 0D 70 71                 .pq
        .byte   $72                             ; 9D4B 72                       r
        .byte   $7F                             ; 9D4C 7F                       .
        php                                     ; 9D4D 08                       .
        php                                     ; 9D4E 08                       .
        .byte   $23                             ; 9D4F 23                       #
        .byte   $22                             ; 9D50 22                       "
        php                                     ; 9D51 08                       .
        asl     $08,x                           ; 9D52 16 08                    ..
        php                                     ; 9D54 08                       .
        php                                     ; 9D55 08                       .
        php                                     ; 9D56 08                       .
        .byte   $23                             ; 9D57 23                       #
        .byte   $22                             ; 9D58 22                       "
        php                                     ; 9D59 08                       .
        php                                     ; 9D5A 08                       .
        php                                     ; 9D5B 08                       .
        php                                     ; 9D5C 08                       .
        ora     ($12),y                         ; 9D5D 11 12                    ..
        .byte   $23                             ; 9D5F 23                       #
        .byte   $22                             ; 9D60 22                       "
        asl     $08,x                           ; 9D61 16 08                    ..
        php                                     ; 9D63 08                       .
        php                                     ; 9D64 08                       .
        php                                     ; 9D65 08                       .
        php                                     ; 9D66 08                       .
        .byte   $23                             ; 9D67 23                       #
        .byte   $22                             ; 9D68 22                       "
        php                                     ; 9D69 08                       .
        php                                     ; 9D6A 08                       .
        .byte   $CB                             ; 9D6B CB                       .
        cpy     L9885                           ; 9D6C CC 85 98                 ...
        cmp     $2524                           ; 9D6F CD 24 25                 .$%
        rol     $27                             ; 9D72 26 27                    &'
        and     $26                             ; 9D74 25 26                    %&
        .byte   $27                             ; 9D76 27                       '
        plp                                     ; 9D77 28                       (
        and     #$2A                            ; 9D78 29 2A                    )*
        .byte   $2B                             ; 9D7A 2B                       +
        bit     $2B2A                           ; 9D7B 2C 2A 2B                 ,*+
        bit     $082D                           ; 9D7E 2C 2D 08                 ,-.
        php                                     ; 9D81 08                       .
        php                                     ; 9D82 08                       .
        php                                     ; 9D83 08                       .
        php                                     ; 9D84 08                       .
        php                                     ; 9D85 08                       .
        php                                     ; 9D86 08                       .
        php                                     ; 9D87 08                       .
        php                                     ; 9D88 08                       .
        php                                     ; 9D89 08                       .
        php                                     ; 9D8A 08                       .
        php                                     ; 9D8B 08                       .
        php                                     ; 9D8C 08                       .
        php                                     ; 9D8D 08                       .
        php                                     ; 9D8E 08                       .
        php                                     ; 9D8F 08                       .
        php                                     ; 9D90 08                       .
        php                                     ; 9D91 08                       .
        php                                     ; 9D92 08                       .
        php                                     ; 9D93 08                       .
        php                                     ; 9D94 08                       .
        php                                     ; 9D95 08                       .
        php                                     ; 9D96 08                       .
        php                                     ; 9D97 08                       .
        php                                     ; 9D98 08                       .
        php                                     ; 9D99 08                       .
        php                                     ; 9D9A 08                       .
        php                                     ; 9D9B 08                       .
        php                                     ; 9D9C 08                       .
L9D9D:  php                                     ; 9D9D 08                       .
        php                                     ; 9D9E 08                       .
        php                                     ; 9D9F 08                       .
        php                                     ; 9DA0 08                       .
        php                                     ; 9DA1 08                       .
        php                                     ; 9DA2 08                       .
        php                                     ; 9DA3 08                       .
        php                                     ; 9DA4 08                       .
        php                                     ; 9DA5 08                       .
        php                                     ; 9DA6 08                       .
        php                                     ; 9DA7 08                       .
        php                                     ; 9DA8 08                       .
        php                                     ; 9DA9 08                       .
        php                                     ; 9DAA 08                       .
        php                                     ; 9DAB 08                       .
        php                                     ; 9DAC 08                       .
        php                                     ; 9DAD 08                       .
        php                                     ; 9DAE 08                       .
        php                                     ; 9DAF 08                       .
        php                                     ; 9DB0 08                       .
        php                                     ; 9DB1 08                       .
        php                                     ; 9DB2 08                       .
        php                                     ; 9DB3 08                       .
        php                                     ; 9DB4 08                       .
        php                                     ; 9DB5 08                       .
        php                                     ; 9DB6 08                       .
        php                                     ; 9DB7 08                       .
        php                                     ; 9DB8 08                       .
        php                                     ; 9DB9 08                       .
        php                                     ; 9DBA 08                       .
        php                                     ; 9DBB 08                       .
        php                                     ; 9DBC 08                       .
        php                                     ; 9DBD 08                       .
        php                                     ; 9DBE 08                       .
        php                                     ; 9DBF 08                       .
        php                                     ; 9DC0 08                       .
        php                                     ; 9DC1 08                       .
        php                                     ; 9DC2 08                       .
        php                                     ; 9DC3 08                       .
        php                                     ; 9DC4 08                       .
        php                                     ; 9DC5 08                       .
        php                                     ; 9DC6 08                       .
        php                                     ; 9DC7 08                       .
        php                                     ; 9DC8 08                       .
        php                                     ; 9DC9 08                       .
        php                                     ; 9DCA 08                       .
        php                                     ; 9DCB 08                       .
        php                                     ; 9DCC 08                       .
        php                                     ; 9DCD 08                       .
        php                                     ; 9DCE 08                       .
        php                                     ; 9DCF 08                       .
        php                                     ; 9DD0 08                       .
        php                                     ; 9DD1 08                       .
        php                                     ; 9DD2 08                       .
        php                                     ; 9DD3 08                       .
        php                                     ; 9DD4 08                       .
        php                                     ; 9DD5 08                       .
        php                                     ; 9DD6 08                       .
        php                                     ; 9DD7 08                       .
        php                                     ; 9DD8 08                       .
        php                                     ; 9DD9 08                       .
        php                                     ; 9DDA 08                       .
        php                                     ; 9DDB 08                       .
        php                                     ; 9DDC 08                       .
        php                                     ; 9DDD 08                       .
        php                                     ; 9DDE 08                       .
        php                                     ; 9DDF 08                       .
        php                                     ; 9DE0 08                       .
        php                                     ; 9DE1 08                       .
        php                                     ; 9DE2 08                       .
        php                                     ; 9DE3 08                       .
        php                                     ; 9DE4 08                       .
        php                                     ; 9DE5 08                       .
        php                                     ; 9DE6 08                       .
        php                                     ; 9DE7 08                       .
        php                                     ; 9DE8 08                       .
        php                                     ; 9DE9 08                       .
        php                                     ; 9DEA 08                       .
        php                                     ; 9DEB 08                       .
        php                                     ; 9DEC 08                       .
        php                                     ; 9DED 08                       .
        php                                     ; 9DEE 08                       .
        php                                     ; 9DEF 08                       .
        php                                     ; 9DF0 08                       .
        php                                     ; 9DF1 08                       .
        php                                     ; 9DF2 08                       .
        php                                     ; 9DF3 08                       .
        php                                     ; 9DF4 08                       .
        php                                     ; 9DF5 08                       .
        php                                     ; 9DF6 08                       .
        php                                     ; 9DF7 08                       .
        php                                     ; 9DF8 08                       .
        php                                     ; 9DF9 08                       .
        php                                     ; 9DFA 08                       .
        php                                     ; 9DFB 08                       .
        php                                     ; 9DFC 08                       .
        php                                     ; 9DFD 08                       .
        php                                     ; 9DFE 08                       .
        php                                     ; 9DFF 08                       .
        php                                     ; 9E00 08                       .
        php                                     ; 9E01 08                       .
        php                                     ; 9E02 08                       .
        php                                     ; 9E03 08                       .
        php                                     ; 9E04 08                       .
        php                                     ; 9E05 08                       .
        php                                     ; 9E06 08                       .
        php                                     ; 9E07 08                       .
        php                                     ; 9E08 08                       .
        php                                     ; 9E09 08                       .
        php                                     ; 9E0A 08                       .
        php                                     ; 9E0B 08                       .
        php                                     ; 9E0C 08                       .
        php                                     ; 9E0D 08                       .
        php                                     ; 9E0E 08                       .
        php                                     ; 9E0F 08                       .
        php                                     ; 9E10 08                       .
        php                                     ; 9E11 08                       .
        php                                     ; 9E12 08                       .
        php                                     ; 9E13 08                       .
        php                                     ; 9E14 08                       .
        php                                     ; 9E15 08                       .
        php                                     ; 9E16 08                       .
        php                                     ; 9E17 08                       .
        php                                     ; 9E18 08                       .
        php                                     ; 9E19 08                       .
        php                                     ; 9E1A 08                       .
        php                                     ; 9E1B 08                       .
        php                                     ; 9E1C 08                       .
        php                                     ; 9E1D 08                       .
        php                                     ; 9E1E 08                       .
        php                                     ; 9E1F 08                       .
        php                                     ; 9E20 08                       .
        php                                     ; 9E21 08                       .
        php                                     ; 9E22 08                       .
        php                                     ; 9E23 08                       .
        php                                     ; 9E24 08                       .
        php                                     ; 9E25 08                       .
        php                                     ; 9E26 08                       .
        php                                     ; 9E27 08                       .
        php                                     ; 9E28 08                       .
        php                                     ; 9E29 08                       .
        php                                     ; 9E2A 08                       .
        php                                     ; 9E2B 08                       .
        php                                     ; 9E2C 08                       .
        php                                     ; 9E2D 08                       .
        php                                     ; 9E2E 08                       .
        php                                     ; 9E2F 08                       .
        php                                     ; 9E30 08                       .
        php                                     ; 9E31 08                       .
        php                                     ; 9E32 08                       .
        php                                     ; 9E33 08                       .
        php                                     ; 9E34 08                       .
        php                                     ; 9E35 08                       .
        php                                     ; 9E36 08                       .
        php                                     ; 9E37 08                       .
        php                                     ; 9E38 08                       .
        php                                     ; 9E39 08                       .
        php                                     ; 9E3A 08                       .
        php                                     ; 9E3B 08                       .
        php                                     ; 9E3C 08                       .
        php                                     ; 9E3D 08                       .
        php                                     ; 9E3E 08                       .
        php                                     ; 9E3F 08                       .
        php                                     ; 9E40 08                       .
        php                                     ; 9E41 08                       .
        php                                     ; 9E42 08                       .
        php                                     ; 9E43 08                       .
        php                                     ; 9E44 08                       .
        php                                     ; 9E45 08                       .
        php                                     ; 9E46 08                       .
        php                                     ; 9E47 08                       .
        php                                     ; 9E48 08                       .
        php                                     ; 9E49 08                       .
        php                                     ; 9E4A 08                       .
        php                                     ; 9E4B 08                       .
        php                                     ; 9E4C 08                       .
        php                                     ; 9E4D 08                       .
        php                                     ; 9E4E 08                       .
        php                                     ; 9E4F 08                       .
        php                                     ; 9E50 08                       .
        php                                     ; 9E51 08                       .
        php                                     ; 9E52 08                       .
        php                                     ; 9E53 08                       .
        php                                     ; 9E54 08                       .
        php                                     ; 9E55 08                       .
        php                                     ; 9E56 08                       .
        php                                     ; 9E57 08                       .
        php                                     ; 9E58 08                       .
        php                                     ; 9E59 08                       .
        php                                     ; 9E5A 08                       .
        php                                     ; 9E5B 08                       .
        php                                     ; 9E5C 08                       .
        php                                     ; 9E5D 08                       .
        php                                     ; 9E5E 08                       .
        php                                     ; 9E5F 08                       .
        php                                     ; 9E60 08                       .
        php                                     ; 9E61 08                       .
        php                                     ; 9E62 08                       .
        php                                     ; 9E63 08                       .
        php                                     ; 9E64 08                       .
        php                                     ; 9E65 08                       .
        php                                     ; 9E66 08                       .
        php                                     ; 9E67 08                       .
        php                                     ; 9E68 08                       .
        php                                     ; 9E69 08                       .
        php                                     ; 9E6A 08                       .
        php                                     ; 9E6B 08                       .
        php                                     ; 9E6C 08                       .
        php                                     ; 9E6D 08                       .
        php                                     ; 9E6E 08                       .
        php                                     ; 9E6F 08                       .
        php                                     ; 9E70 08                       .
        php                                     ; 9E71 08                       .
        php                                     ; 9E72 08                       .
        php                                     ; 9E73 08                       .
        php                                     ; 9E74 08                       .
        php                                     ; 9E75 08                       .
        php                                     ; 9E76 08                       .
        php                                     ; 9E77 08                       .
        php                                     ; 9E78 08                       .
        php                                     ; 9E79 08                       .
        php                                     ; 9E7A 08                       .
        php                                     ; 9E7B 08                       .
        php                                     ; 9E7C 08                       .
        php                                     ; 9E7D 08                       .
        php                                     ; 9E7E 08                       .
        php                                     ; 9E7F 08                       .
        php                                     ; 9E80 08                       .
        php                                     ; 9E81 08                       .
        php                                     ; 9E82 08                       .
        php                                     ; 9E83 08                       .
        php                                     ; 9E84 08                       .
        php                                     ; 9E85 08                       .
        php                                     ; 9E86 08                       .
        php                                     ; 9E87 08                       .
        php                                     ; 9E88 08                       .
        php                                     ; 9E89 08                       .
        php                                     ; 9E8A 08                       .
        php                                     ; 9E8B 08                       .
        php                                     ; 9E8C 08                       .
        php                                     ; 9E8D 08                       .
        php                                     ; 9E8E 08                       .
        php                                     ; 9E8F 08                       .
        php                                     ; 9E90 08                       .
        php                                     ; 9E91 08                       .
        php                                     ; 9E92 08                       .
        php                                     ; 9E93 08                       .
        php                                     ; 9E94 08                       .
        php                                     ; 9E95 08                       .
        php                                     ; 9E96 08                       .
        php                                     ; 9E97 08                       .
        php                                     ; 9E98 08                       .
        php                                     ; 9E99 08                       .
        php                                     ; 9E9A 08                       .
        php                                     ; 9E9B 08                       .
        php                                     ; 9E9C 08                       .
        php                                     ; 9E9D 08                       .
        php                                     ; 9E9E 08                       .
        php                                     ; 9E9F 08                       .
        php                                     ; 9EA0 08                       .
        php                                     ; 9EA1 08                       .
        php                                     ; 9EA2 08                       .
        php                                     ; 9EA3 08                       .
        php                                     ; 9EA4 08                       .
        php                                     ; 9EA5 08                       .
        php                                     ; 9EA6 08                       .
        php                                     ; 9EA7 08                       .
        php                                     ; 9EA8 08                       .
        php                                     ; 9EA9 08                       .
        php                                     ; 9EAA 08                       .
        php                                     ; 9EAB 08                       .
        php                                     ; 9EAC 08                       .
        php                                     ; 9EAD 08                       .
        php                                     ; 9EAE 08                       .
        php                                     ; 9EAF 08                       .
        php                                     ; 9EB0 08                       .
        php                                     ; 9EB1 08                       .
        php                                     ; 9EB2 08                       .
        php                                     ; 9EB3 08                       .
        php                                     ; 9EB4 08                       .
        php                                     ; 9EB5 08                       .
        php                                     ; 9EB6 08                       .
        php                                     ; 9EB7 08                       .
        php                                     ; 9EB8 08                       .
        php                                     ; 9EB9 08                       .
        php                                     ; 9EBA 08                       .
        php                                     ; 9EBB 08                       .
        php                                     ; 9EBC 08                       .
        php                                     ; 9EBD 08                       .
        php                                     ; 9EBE 08                       .
        php                                     ; 9EBF 08                       .
        php                                     ; 9EC0 08                       .
        php                                     ; 9EC1 08                       .
        php                                     ; 9EC2 08                       .
        php                                     ; 9EC3 08                       .
        php                                     ; 9EC4 08                       .
        php                                     ; 9EC5 08                       .
        php                                     ; 9EC6 08                       .
        php                                     ; 9EC7 08                       .
        php                                     ; 9EC8 08                       .
        php                                     ; 9EC9 08                       .
        php                                     ; 9ECA 08                       .
        php                                     ; 9ECB 08                       .
        php                                     ; 9ECC 08                       .
        php                                     ; 9ECD 08                       .
        php                                     ; 9ECE 08                       .
        php                                     ; 9ECF 08                       .
        php                                     ; 9ED0 08                       .
        php                                     ; 9ED1 08                       .
        php                                     ; 9ED2 08                       .
        php                                     ; 9ED3 08                       .
        php                                     ; 9ED4 08                       .
        php                                     ; 9ED5 08                       .
        php                                     ; 9ED6 08                       .
        php                                     ; 9ED7 08                       .
        php                                     ; 9ED8 08                       .
        php                                     ; 9ED9 08                       .
        php                                     ; 9EDA 08                       .
        php                                     ; 9EDB 08                       .
        php                                     ; 9EDC 08                       .
        php                                     ; 9EDD 08                       .
        php                                     ; 9EDE 08                       .
        php                                     ; 9EDF 08                       .
        php                                     ; 9EE0 08                       .
        php                                     ; 9EE1 08                       .
        php                                     ; 9EE2 08                       .
        php                                     ; 9EE3 08                       .
        php                                     ; 9EE4 08                       .
        php                                     ; 9EE5 08                       .
        php                                     ; 9EE6 08                       .
        php                                     ; 9EE7 08                       .
        php                                     ; 9EE8 08                       .
        php                                     ; 9EE9 08                       .
        php                                     ; 9EEA 08                       .
        php                                     ; 9EEB 08                       .
        php                                     ; 9EEC 08                       .
        php                                     ; 9EED 08                       .
        php                                     ; 9EEE 08                       .
        php                                     ; 9EEF 08                       .
        php                                     ; 9EF0 08                       .
        php                                     ; 9EF1 08                       .
        php                                     ; 9EF2 08                       .
        php                                     ; 9EF3 08                       .
        php                                     ; 9EF4 08                       .
        php                                     ; 9EF5 08                       .
        php                                     ; 9EF6 08                       .
        php                                     ; 9EF7 08                       .
        php                                     ; 9EF8 08                       .
        php                                     ; 9EF9 08                       .
        php                                     ; 9EFA 08                       .
        php                                     ; 9EFB 08                       .
        php                                     ; 9EFC 08                       .
        php                                     ; 9EFD 08                       .
        php                                     ; 9EFE 08                       .
        php                                     ; 9EFF 08                       .
        php                                     ; 9F00 08                       .
        php                                     ; 9F01 08                       .
        php                                     ; 9F02 08                       .
        php                                     ; 9F03 08                       .
        php                                     ; 9F04 08                       .
        php                                     ; 9F05 08                       .
        php                                     ; 9F06 08                       .
        php                                     ; 9F07 08                       .
        php                                     ; 9F08 08                       .
        php                                     ; 9F09 08                       .
        php                                     ; 9F0A 08                       .
        php                                     ; 9F0B 08                       .
        php                                     ; 9F0C 08                       .
        php                                     ; 9F0D 08                       .
        php                                     ; 9F0E 08                       .
        php                                     ; 9F0F 08                       .
        php                                     ; 9F10 08                       .
        php                                     ; 9F11 08                       .
        php                                     ; 9F12 08                       .
        php                                     ; 9F13 08                       .
        php                                     ; 9F14 08                       .
        php                                     ; 9F15 08                       .
        php                                     ; 9F16 08                       .
        php                                     ; 9F17 08                       .
        php                                     ; 9F18 08                       .
        php                                     ; 9F19 08                       .
        php                                     ; 9F1A 08                       .
        php                                     ; 9F1B 08                       .
        php                                     ; 9F1C 08                       .
        php                                     ; 9F1D 08                       .
        php                                     ; 9F1E 08                       .
        php                                     ; 9F1F 08                       .
        php                                     ; 9F20 08                       .
        php                                     ; 9F21 08                       .
        php                                     ; 9F22 08                       .
        php                                     ; 9F23 08                       .
        php                                     ; 9F24 08                       .
        php                                     ; 9F25 08                       .
        php                                     ; 9F26 08                       .
        php                                     ; 9F27 08                       .
        php                                     ; 9F28 08                       .
        php                                     ; 9F29 08                       .
        php                                     ; 9F2A 08                       .
        php                                     ; 9F2B 08                       .
        php                                     ; 9F2C 08                       .
        php                                     ; 9F2D 08                       .
        php                                     ; 9F2E 08                       .
        php                                     ; 9F2F 08                       .
        php                                     ; 9F30 08                       .
        php                                     ; 9F31 08                       .
        php                                     ; 9F32 08                       .
        php                                     ; 9F33 08                       .
        php                                     ; 9F34 08                       .
        php                                     ; 9F35 08                       .
        php                                     ; 9F36 08                       .
        php                                     ; 9F37 08                       .
        php                                     ; 9F38 08                       .
        php                                     ; 9F39 08                       .
        php                                     ; 9F3A 08                       .
        php                                     ; 9F3B 08                       .
        php                                     ; 9F3C 08                       .
        php                                     ; 9F3D 08                       .
        php                                     ; 9F3E 08                       .
        php                                     ; 9F3F 08                       .
        php                                     ; 9F40 08                       .
        php                                     ; 9F41 08                       .
        php                                     ; 9F42 08                       .
        php                                     ; 9F43 08                       .
        php                                     ; 9F44 08                       .
        php                                     ; 9F45 08                       .
        php                                     ; 9F46 08                       .
        php                                     ; 9F47 08                       .
        php                                     ; 9F48 08                       .
        php                                     ; 9F49 08                       .
        php                                     ; 9F4A 08                       .
        php                                     ; 9F4B 08                       .
        php                                     ; 9F4C 08                       .
        php                                     ; 9F4D 08                       .
        php                                     ; 9F4E 08                       .
        php                                     ; 9F4F 08                       .
        php                                     ; 9F50 08                       .
        php                                     ; 9F51 08                       .
        php                                     ; 9F52 08                       .
        php                                     ; 9F53 08                       .
        php                                     ; 9F54 08                       .
        php                                     ; 9F55 08                       .
        php                                     ; 9F56 08                       .
        php                                     ; 9F57 08                       .
        php                                     ; 9F58 08                       .
        php                                     ; 9F59 08                       .
        php                                     ; 9F5A 08                       .
        php                                     ; 9F5B 08                       .
        php                                     ; 9F5C 08                       .
        php                                     ; 9F5D 08                       .
        php                                     ; 9F5E 08                       .
        php                                     ; 9F5F 08                       .
        php                                     ; 9F60 08                       .
        php                                     ; 9F61 08                       .
        php                                     ; 9F62 08                       .
        php                                     ; 9F63 08                       .
        php                                     ; 9F64 08                       .
        php                                     ; 9F65 08                       .
        php                                     ; 9F66 08                       .
        php                                     ; 9F67 08                       .
        php                                     ; 9F68 08                       .
        php                                     ; 9F69 08                       .
        php                                     ; 9F6A 08                       .
        php                                     ; 9F6B 08                       .
        php                                     ; 9F6C 08                       .
        php                                     ; 9F6D 08                       .
        php                                     ; 9F6E 08                       .
        php                                     ; 9F6F 08                       .
        php                                     ; 9F70 08                       .
        php                                     ; 9F71 08                       .
        php                                     ; 9F72 08                       .
        php                                     ; 9F73 08                       .
        php                                     ; 9F74 08                       .
        php                                     ; 9F75 08                       .
        php                                     ; 9F76 08                       .
        php                                     ; 9F77 08                       .
        php                                     ; 9F78 08                       .
        php                                     ; 9F79 08                       .
        php                                     ; 9F7A 08                       .
        php                                     ; 9F7B 08                       .
        php                                     ; 9F7C 08                       .
        php                                     ; 9F7D 08                       .
        php                                     ; 9F7E 08                       .
        php                                     ; 9F7F 08                       .
        php                                     ; 9F80 08                       .
        php                                     ; 9F81 08                       .
        php                                     ; 9F82 08                       .
        php                                     ; 9F83 08                       .
        php                                     ; 9F84 08                       .
        php                                     ; 9F85 08                       .
        php                                     ; 9F86 08                       .
        php                                     ; 9F87 08                       .
        php                                     ; 9F88 08                       .
        php                                     ; 9F89 08                       .
        php                                     ; 9F8A 08                       .
        php                                     ; 9F8B 08                       .
        php                                     ; 9F8C 08                       .
        php                                     ; 9F8D 08                       .
        php                                     ; 9F8E 08                       .
        php                                     ; 9F8F 08                       .
        php                                     ; 9F90 08                       .
        php                                     ; 9F91 08                       .
        php                                     ; 9F92 08                       .
        php                                     ; 9F93 08                       .
        php                                     ; 9F94 08                       .
        php                                     ; 9F95 08                       .
        php                                     ; 9F96 08                       .
        php                                     ; 9F97 08                       .
        php                                     ; 9F98 08                       .
        php                                     ; 9F99 08                       .
        php                                     ; 9F9A 08                       .
        php                                     ; 9F9B 08                       .
        php                                     ; 9F9C 08                       .
        php                                     ; 9F9D 08                       .
        php                                     ; 9F9E 08                       .
        php                                     ; 9F9F 08                       .
        php                                     ; 9FA0 08                       .
        php                                     ; 9FA1 08                       .
        php                                     ; 9FA2 08                       .
        php                                     ; 9FA3 08                       .
        php                                     ; 9FA4 08                       .
        php                                     ; 9FA5 08                       .
        php                                     ; 9FA6 08                       .
        php                                     ; 9FA7 08                       .
        php                                     ; 9FA8 08                       .
        php                                     ; 9FA9 08                       .
L9FAA:  php                                     ; 9FAA 08                       .
        php                                     ; 9FAB 08                       .
        php                                     ; 9FAC 08                       .
        php                                     ; 9FAD 08                       .
        php                                     ; 9FAE 08                       .
        php                                     ; 9FAF 08                       .
        php                                     ; 9FB0 08                       .
        php                                     ; 9FB1 08                       .
        php                                     ; 9FB2 08                       .
        php                                     ; 9FB3 08                       .
        php                                     ; 9FB4 08                       .
        php                                     ; 9FB5 08                       .
        php                                     ; 9FB6 08                       .
        php                                     ; 9FB7 08                       .
        php                                     ; 9FB8 08                       .
        php                                     ; 9FB9 08                       .
        php                                     ; 9FBA 08                       .
        php                                     ; 9FBB 08                       .
        php                                     ; 9FBC 08                       .
        php                                     ; 9FBD 08                       .
        php                                     ; 9FBE 08                       .
L9FBF:  php                                     ; 9FBF 08                       .
        php                                     ; 9FC0 08                       .
        php                                     ; 9FC1 08                       .
        php                                     ; 9FC2 08                       .
        php                                     ; 9FC3 08                       .
        php                                     ; 9FC4 08                       .
        php                                     ; 9FC5 08                       .
        php                                     ; 9FC6 08                       .
        php                                     ; 9FC7 08                       .
        php                                     ; 9FC8 08                       .
        php                                     ; 9FC9 08                       .
        php                                     ; 9FCA 08                       .
        php                                     ; 9FCB 08                       .
        php                                     ; 9FCC 08                       .
        php                                     ; 9FCD 08                       .
        php                                     ; 9FCE 08                       .
        php                                     ; 9FCF 08                       .
        php                                     ; 9FD0 08                       .
        php                                     ; 9FD1 08                       .
        php                                     ; 9FD2 08                       .
        php                                     ; 9FD3 08                       .
        php                                     ; 9FD4 08                       .
        php                                     ; 9FD5 08                       .
        php                                     ; 9FD6 08                       .
        php                                     ; 9FD7 08                       .
        php                                     ; 9FD8 08                       .
        php                                     ; 9FD9 08                       .
        php                                     ; 9FDA 08                       .
        php                                     ; 9FDB 08                       .
        php                                     ; 9FDC 08                       .
        php                                     ; 9FDD 08                       .
        php                                     ; 9FDE 08                       .
        php                                     ; 9FDF 08                       .
        php                                     ; 9FE0 08                       .
        php                                     ; 9FE1 08                       .
        php                                     ; 9FE2 08                       .
        php                                     ; 9FE3 08                       .
        php                                     ; 9FE4 08                       .
        php                                     ; 9FE5 08                       .
        php                                     ; 9FE6 08                       .
        php                                     ; 9FE7 08                       .
        php                                     ; 9FE8 08                       .
        php                                     ; 9FE9 08                       .
        php                                     ; 9FEA 08                       .
        php                                     ; 9FEB 08                       .
        php                                     ; 9FEC 08                       .
        php                                     ; 9FED 08                       .
        php                                     ; 9FEE 08                       .
        php                                     ; 9FEF 08                       .
        php                                     ; 9FF0 08                       .
        php                                     ; 9FF1 08                       .
        php                                     ; 9FF2 08                       .
        php                                     ; 9FF3 08                       .
        php                                     ; 9FF4 08                       .
        php                                     ; 9FF5 08                       .
        php                                     ; 9FF6 08                       .
        php                                     ; 9FF7 08                       .
        php                                     ; 9FF8 08                       .
        php                                     ; 9FF9 08                       .
        php                                     ; 9FFA 08                       .
        php                                     ; 9FFB 08                       .
        php                                     ; 9FFC 08                       .
        php                                     ; 9FFD 08                       .
        php                                     ; 9FFE 08                       .
        php                                     ; 9FFF 08                       .
