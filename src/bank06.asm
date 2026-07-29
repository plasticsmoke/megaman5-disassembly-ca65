.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK06"

; =============================================================================
; BANK $06 (mapped at $8000) — raw da65 disassembly, annotation in progress
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
LA0FB           := $A0FB
LA110           := $A110
LA21C           := $A21C
LA2D3           := $A2D3
LA493           := $A493
LA4CF           := $A4CF
LA58A           := $A58A
LA595           := $A595
LD1D0           := $D1D0
LE780           := $E780
LE7B7           := $E7B7
LE92A           := $E92A
LE94A           := $E94A
LE968           := $E968
LEA1E           := $EA1E
LEA34           := $EA34
LEA3F           := $EA3F
LEA65           := $EA65
LEA86           := $EA86
LEA98           := $EA98
LEAA4           := $EAA4
LEAF5           := $EAF5
LEC16           := $EC16
LEC30           := $EC30
LEC4A           := $EC4A
LEC5D           := $EC5D
LEC94           := $EC94
LF16F           := $F16F
LF207           := $F207
LF2C4           := $F2C4
LF470           := $F470
; ----------------------------------------------------------------------------
        .byte   $20                             ; 8000 20                        
L8001:  asl     $EC,x                           ; 8001 16 EC                    ..
        jsr     LEC30                           ; 8003 20 30 EC                  0.
        lda     $0468,x                         ; 8006 BD 68 04                 .h.
        beq     L8010                           ; 8009 F0 05                    ..
        dec     $0468,x                         ; 800B DE 68 04                 .h.
        bne     L805D                           ; 800E D0 4D                    .M
L8010:  lda     $E7                             ; 8010 A5 E7                    ..
        adc     $E6                             ; 8012 65 E6                    e.
        adc     $9D                             ; 8014 65 9D                    e.
        sta     $E4                             ; 8016 85 E4                    ..
        jsr     LEC94                           ; 8018 20 94 EC                  ..
        cmp     #$71                            ; 801B C9 71                    .q
        bcs     L803B                           ; 801D B0 1C                    ..
        .byte   $C9                             ; 801F C9                       .
L8020:  .byte   $50,$B0                    ; 8020 50 B0   (branch out of range for ca65: target has no local label)
        asl     a                               ; 8022 0A                       .
        lda     $E4                             ; 8023 A5 E4                    ..
        and     #$07                            ; 8025 29 07                    ).
        cmp     #$04                            ; 8027 C9 04                    ..
        bcc     L805E                           ; 8029 90 33                    .3
        bcs     L8067                           ; 802B B0 3A                    .:
L802D:  lda     $E4                             ; 802D A5 E4                    ..
        and     #$01                            ; 802F 29 01                    ).
        beq     L8067                           ; 8031 F0 34                    .4
        lda     $E6                             ; 8033 A5 E6                    ..
        and     #$01                            ; 8035 29 01                    ).
        beq     L8041                           ; 8037 F0 08                    ..
        bne     L805E                           ; 8039 D0 23                    .#
L803B:  lda     $E4                             ; 803B A5 E4                    ..
        and     #$03                            ; 803D 29 03                    ).
        beq     L8067                           ; 803F F0 26                    .&
L8041:  lda     #$10                            ; 8041 A9 10                    ..
        sta     $0588,x                         ; 8043 9D 88 05                 ...
        lda     #$A1                            ; 8046 A9 A1                    ..
        sta     $05A0,x                         ; 8048 9D A0 05                 ...
        lda     #$09                            ; 804B A9 09                    ..
        jsr     LEA98                           ; 804D 20 98 EA                  ..
L8050:  lda     #$1E                            ; 8050 A9 1E                    ..
        sta     $0480,x                         ; 8052 9D 80 04                 ...
        lda     #$89                            ; 8055 A9 89                    ..
        sta     $0408,x                         ; 8057 9D 08 04                 ...
        jsr     LA110                           ; 805A 20 10 A1                  ..
L805D:  rts                                     ; 805D 60                       `

; ----------------------------------------------------------------------------
L805E:  jsr     LEC94                           ; 805E 20 94 EC                  ..
        sta     $01                             ; 8061 85 01                    ..
        ldy     #$01                            ; 8063 A0 01                    ..
        bne     L806F                           ; 8065 D0 08                    ..
L8067:  jsr     LEC94                           ; 8067 20 94 EC                  ..
        lsr     a                               ; 806A 4A                       J
        sta     $01                             ; 806B 85 01                    ..
        ldy     #$00                            ; 806D A0 00                    ..
L806F:  tya                                     ; 806F 98                       .
        sta     $0498,x                         ; 8070 9D 98 04                 ...
        jsr     L8592                           ; 8073 20 92 85                  ..
        lda     #$85                            ; 8076 A9 85                    ..
        sta     $0588,x                         ; 8078 9D 88 05                 ...
        lda     #$A0                            ; 807B A9 A0                    ..
L807D:  sta     $05A0,x                         ; 807D 9D A0 05                 ...
        lda     #$0C                            ; 8080 A9 0C                    ..
        jsr     LEA98                           ; 8082 20 98 EA                  ..
        lda     #$00                            ; 8085 A9 00                    ..
        sta     $0570,x                         ; 8087 9D 70 05                 .p.
        ldy     #$19                            ; 808A A0 19                    ..
        jsr     LE7B7                           ; 808C 20 B7 E7                  ..
        bcs     L809B                           ; 808F B0 0A                    ..
        ldy     #$1E                            ; 8091 A0 1E                    ..
        jsr     LEA3F                           ; 8093 20 3F EA                  ?.
        bcc     L805D                           ; 8096 90 C5                    ..
        jmp     LEC4A                           ; 8098 4C 4A EC                 LJ.

; ----------------------------------------------------------------------------
L809B:  lda     $0498,x                         ; 809B BD 98 04                 ...
        bne     L80B9                           ; 809E D0 19                    ..
        lda     #$AF                            ; 80A0 A9 AF                    ..
        sta     $0588,x                         ; 80A2 9D 88 05                 ...
        lda     #$A0                            ; 80A5 A9 A0                    ..
        sta     $05A0,x                         ; 80A7 9D A0 05                 ...
        lda     #$01                            ; 80AA A9 01                    ..
        sta     $0540,x                         ; 80AC 9D 40 05                 .@.
        lda     $0570,x                         ; 80AF BD 70 05                 .p.
        cmp     #$04                            ; 80B2 C9 04                    ..
        bne     L805D                           ; 80B4 D0 A7                    ..
        jmp     LA0FB                           ; 80B6 4C FB A0                 L..

; ----------------------------------------------------------------------------
L80B9:  lda     #$D0                            ; 80B9 A9 D0                    ..
        sta     $0588,x                         ; 80BB 9D 88 05                 ...
        lda     #$A0                            ; 80BE A9 A0                    ..
        sta     $05A0,x                         ; 80C0 9D A0 05                 ...
        lda     #$0E                            ; 80C3 A9 0E                    ..
        jsr     LEA98                           ; 80C5 20 98 EA                  ..
        lda     #$00                            ; 80C8 A9 00                    ..
        sta     $0408,x                         ; 80CA 9D 08 04                 ...
        jsr     LEA1E                           ; 80CD 20 1E EA                  ..
        lda     $0570,x                         ; 80D0 BD 70 05                 .p.
        and     #$02                            ; 80D3 29 02                    ).
        sta     $FA                             ; 80D5 85 FA                    ..
        lda     $0540,x                         ; 80D7 BD 40 05                 .@.
        cmp     #$0A                            ; 80DA C9 0A                    ..
        bne     L810F                           ; 80DC D0 31                    .1
        lda     #$0F                            ; 80DE A9 0F                    ..
        jsr     LEA98                           ; 80E0 20 98 EA                  ..
        lda     #$ED                            ; 80E3 A9 ED                    ..
        sta     $0588,x                         ; 80E5 9D 88 05                 ...
        lda     #$A0                            ; 80E8 A9 A0                    ..
        sta     $05A0,x                         ; 80EA 9D A0 05                 ...
        lda     $0540,x                         ; 80ED BD 40 05                 .@.
        cmp     #$04                            ; 80F0 C9 04                    ..
        bne     L810F                           ; 80F2 D0 1B                    ..
        lda     $0570,x                         ; 80F4 BD 70 05                 .p.
        cmp     #$02                            ; 80F7 C9 02                    ..
        bne     L810F                           ; 80F9 D0 14                    ..
        lda     #$C9                            ; 80FB A9 C9                    ..
        sta     $0408,x                         ; 80FD 9D 08 04                 ...
        lda     #$00                            ; 8100 A9 00                    ..
        sta     $0588,x                         ; 8102 9D 88 05                 ...
        lda     #$A0                            ; 8105 A9 A0                    ..
        sta     $05A0,x                         ; 8107 9D A0 05                 ...
        lda     #$08                            ; 810A A9 08                    ..
        jsr     LEA98                           ; 810C 20 98 EA                  ..
L810F:  rts                                     ; 810F 60                       `

; ----------------------------------------------------------------------------
        dec     $0480,x                         ; 8110 DE 80 04                 ...
        bne     L810F                           ; 8113 D0 FA                    ..
        lda     #$0A                            ; 8115 A9 0A                    ..
        jsr     LEA98                           ; 8117 20 98 EA                  ..
        lda     $0378,x                         ; 811A BD 78 03                 .x.
        sec                                     ; 811D 38                       8
        sbc     #$08                            ; 811E E9 08                    ..
        sta     $0378,x                         ; 8120 9D 78 03                 .x.
        lda     #$99                            ; 8123 A9 99                    ..
        sta     $0408,x                         ; 8125 9D 08 04                 ...
        lda     #$32                            ; 8128 A9 32                    .2
        sta     $0588,x                         ; 812A 9D 88 05                 ...
        lda     #$A1                            ; 812D A9 A1                    ..
        sta     $05A0,x                         ; 812F 9D A0 05                 ...
        jsr     LEC16                           ; 8132 20 16 EC                  ..
        jsr     LEC30                           ; 8135 20 30 EC                  0.
        lda     $0570,x                         ; 8138 BD 70 05                 .p.
        cmp     #$05                            ; 813B C9 05                    ..
        beq     L8166                           ; 813D F0 27                    .'
        cmp     #$0A                            ; 813F C9 0A                    ..
        bne     L810F                           ; 8141 D0 CC                    ..
        lda     $0378,x                         ; 8143 BD 78 03                 .x.
        clc                                     ; 8146 18                       .
        adc     #$08                            ; 8147 69 08                    i.
        sta     $0378,x                         ; 8149 9D 78 03                 .x.
        lda     #$3C                            ; 814C A9 3C                    .<
        sta     $0468,x                         ; 814E 9D 68 04                 .h.
        lda     #$C9                            ; 8151 A9 C9                    ..
        sta     $0408,x                         ; 8153 9D 08 04                 ...
        lda     #$5E                            ; 8156 A9 5E                    .^
        sta     $0588,x                         ; 8158 9D 88 05                 ...
        lda     #$A0                            ; 815B A9 A0                    ..
        .byte   $9D                             ; 815D 9D                       .
L815E:  ldy     #$05                            ; 815E A0 05                    ..
        jsr     LEC16                           ; 8160 20 16 EC                  ..
        jmp     LEC30                           ; 8163 4C 30 EC                 L0.

; ----------------------------------------------------------------------------
L8166:  lda     #$01                            ; 8166 A9 01                    ..
        sta     $0E                             ; 8168 85 0E                    ..
L816A:  jsr     LF16F                           ; 816A 20 6F F1                  o.
        bcs     L8191                           ; 816D B0 22                    ."
        lda     #$81                            ; 816F A9 81                    ..
        sta     $0408,y                         ; 8171 99 08 04                 ...
L8174:  lda     #$6A                            ; 8174 A9 6A                    .j
        sta     $0300,y                         ; 8176 99 00 03                 ...
        lda     $0E                             ; 8179 A5 0E                    ..
        pha                                     ; 817B 48                       H
        clc                                     ; 817C 18                       .
        adc     #$38                            ; 817D 69 38                    i8
        sta     $10                             ; 817F 85 10                    ..
        lda     #$11                            ; 8181 A9 11                    ..
        jsr     LEAF5                           ; 8183 20 F5 EA                  ..
        pla                                     ; 8186 68                       h
        asl     a                               ; 8187 0A                       .
        asl     a                               ; 8188 0A                       .
        asl     a                               ; 8189 0A                       .
        sta     $0468,y                         ; 818A 99 68 04                 .h.
        dec     $0E                             ; 818D C6 0E                    ..
        bpl     L816A                           ; 818F 10 D9                    ..
L8191:  rts                                     ; 8191 60                       `

; ----------------------------------------------------------------------------
        lda     $0540,x                         ; 8192 BD 40 05                 .@.
        tay                                     ; 8195 A8                       .
        lda     $A1F2,y                         ; 8196 B9 F2 A1                 ...
        sta     $0408,x                         ; 8199 9D 08 04                 ...
        cpy     #$05                            ; 819C C0 05                    ..
        bcc     L81F1                           ; 819E 90 51                    .Q
        lda     #$B7                            ; 81A0 A9 B7                    ..
        sta     $0588,x                         ; 81A2 9D 88 05                 ...
        lda     #$A1                            ; 81A5 A9 A1                    ..
        sta     $05A0,x                         ; 81A7 9D A0 05                 ...
        lda     #$03                            ; 81AA A9 03                    ..
        sta     $0498,x                         ; 81AC 9D 98 04                 ...
        ldy     $0468,x                         ; 81AF BC 68 04                 .h.
        lda     #$10                            ; 81B2 A9 10                    ..
        jsr     LF470                           ; 81B4 20 70 F4                  p.
        lda     #$00                            ; 81B7 A9 00                    ..
        sta     $0570,x                         ; 81B9 9D 70 05                 .p.
        lda     #$05                            ; 81BC A9 05                    ..
        cmp     $0540,x                         ; 81BE DD 40 05                 .@.
        beq     L81C6                           ; 81C1 F0 03                    ..
        sta     $0540,x                         ; 81C3 9D 40 05                 .@.
L81C6:  jsr     L84FC                           ; 81C6 20 FC 84                  ..
        inc     $0480,x                         ; 81C9 FE 80 04                 ...
        lda     $0480,x                         ; 81CC BD 80 04                 ...
        cmp     $0498,x                         ; 81CF DD 98 04                 ...
        bne     L81F1                           ; 81D2 D0 1D                    ..
        .byte   $A9                             ; 81D4 A9                       .
L81D5:  brk                                     ; 81D5 00                       .
        sta     $0480,x                         ; 81D6 9D 80 04                 ...
        inc     $0468,x                         ; 81D9 FE 68 04                 .h.
        lda     $0468,x                         ; 81DC BD 68 04                 .h.
        and     #$0F                            ; 81DF 29 0F                    ).
        sta     $0468,x                         ; 81E1 9D 68 04                 .h.
        tay                                     ; 81E4 A8                       .
        and     #$07                            ; 81E5 29 07                    ).
        bne     L81EC                           ; 81E7 D0 03                    ..
        inc     $0498,x                         ; 81E9 FE 98 04                 ...
L81EC:  lda     #$10                            ; 81EC A9 10                    ..
        jsr     LF470                           ; 81EE 20 70 F4                  p.
L81F1:  rts                                     ; 81F1 60                       `

; ----------------------------------------------------------------------------
        .byte   $87                             ; 81F2 87                       .
        stx     $85                             ; 81F3 86 85                    ..
        sta     ($81,x)                         ; 81F5 81 81                    ..
        sta     (L0020,x)                       ; 81F7 81 20                    . 
        asl     $EC,x                           ; 81F9 16 EC                    ..
        jsr     LEC30                           ; 81FB 20 30 EC                  0.
        .byte   $20                             ; 81FE 20                        
        .byte   $94                             ; 81FF 94                       .
L8200:  cpx     $3DC9                           ; 8200 EC C9 3D                 ..=
        bcs     L8208                           ; 8203 B0 03                    ..
        jmp     LA2D3                           ; 8205 4C D3 A2                 L..

; ----------------------------------------------------------------------------
L8208:  lda     $0468,x                         ; 8208 BD 68 04                 .h.
        bne     L8217                           ; 820B D0 0A                    ..
        lda     #$19                            ; 820D A9 19                    ..
        jsr     LEA98                           ; 820F 20 98 EA                  ..
        lda     #$1E                            ; 8212 A9 1E                    ..
        sta     $0468,x                         ; 8214 9D 68 04                 .h.
L8217:  dec     $0468,x                         ; 8217 DE 68 04                 .h.
        bne     L81F1                           ; 821A D0 D5                    ..
        lda     #$2B                            ; 821C A9 2B                    .+
        sta     $0588,x                         ; 821E 9D 88 05                 ...
        lda     #$A2                            ; 8221 A9 A2                    ..
        sta     $05A0,x                         ; 8223 9D A0 05                 ...
        lda     #$1B                            ; 8226 A9 1B                    ..
        jsr     LEA98                           ; 8228 20 98 EA                  ..
        lda     $0558,x                         ; 822B BD 58 05                 .X.
        cmp     #$1B                            ; 822E C9 1B                    ..
        bne     L8272                           ; 8230 D0 40                    .@
        lda     $0570,x                         ; 8232 BD 70 05                 .p.
        cmp     #$06                            ; 8235 C9 06                    ..
        bne     L81F1                           ; 8237 D0 B8                    ..
        lda     #$1C                            ; 8239 A9 1C                    ..
        jsr     LEA98                           ; 823B 20 98 EA                  ..
        jsr     LEC16                           ; 823E 20 16 EC                  ..
        jsr     LEC30                           ; 8241 20 30 EC                  0.
        lda     $0378,x                         ; 8244 BD 78 03                 .x.
        clc                                     ; 8247 18                       .
        adc     #$04                            ; 8248 69 04                    i.
        sta     $0378,x                         ; 824A 9D 78 03                 .x.
        lda     #$00                            ; 824D A9 00                    ..
        sta     $03A8,x                         ; 824F 9D A8 03                 ...
        lda     #$03                            ; 8252 A9 03                    ..
        sta     $03C0,x                         ; 8254 9D C0 03                 ...
        lda     #$80                            ; 8257 A9 80                    ..
        sta     $0408,x                         ; 8259 9D 08 04                 ...
        jsr     LEC94                           ; 825C 20 94 EC                  ..
        sta     L0000                           ; 825F 85 00                    ..
        lda     #$03                            ; 8261 A9 03                    ..
        sta     $01                             ; 8263 85 01                    ..
        jsr     LF207                           ; 8265 20 07 F2                  ..
        lda     $02                             ; 8268 A5 02                    ..
        sta     $0480,x                         ; 826A 9D 80 04                 ...
        bne     L8272                           ; 826D D0 03                    ..
        inc     $0480,x                         ; 826F FE 80 04                 ...
L8272:  ldy     #$1E                            ; 8272 A0 1E                    ..
        jsr     LEA3F                           ; 8274 20 3F EA                  ?.
        bcc     L827C                           ; 8277 90 03                    ..
        jsr     LEC4A                           ; 8279 20 4A EC                  J.
L827C:  dec     $0480,x                         ; 827C DE 80 04                 ...
        beq     L82AB                           ; 827F F0 2A                    .*
        lda     $0540,x                         ; 8281 BD 40 05                 .@.
        ora     $0570,x                         ; 8284 1D 70 05                 .p.
        bne     L82AA                           ; 8287 D0 21                    .!
        jsr     LF16F                           ; 8289 20 6F F1                  o.
        bcs     L82AA                           ; 828C B0 1C                    ..
        lda     #$00                            ; 828E A9 00                    ..
        sta     $0408,y                         ; 8290 99 08 04                 ...
        sta     $0450,y                         ; 8293 99 50 04                 .P.
        lda     #$6D                            ; 8296 A9 6D                    .m
        sta     $0300,y                         ; 8298 99 00 03                 ...
        lda     $0420,x                         ; 829B BD 20 04                 . .
        and     #$01                            ; 829E 29 01                    ).
        clc                                     ; 82A0 18                       .
        adc     #$3A                            ; 82A1 69 3A                    i:
        sta     $10                             ; 82A3 85 10                    ..
        lda     #$21                            ; 82A5 A9 21                    .!
        jsr     LEAF5                           ; 82A7 20 F5 EA                  ..
L82AA:  rts                                     ; 82AA 60                       `

; ----------------------------------------------------------------------------
L82AB:  lda     $0378,x                         ; 82AB BD 78 03                 .x.
        sec                                     ; 82AE 38                       8
        sbc     #$04                            ; 82AF E9 04                    ..
        sta     $0378,x                         ; 82B1 9D 78 03                 .x.
        lda     #$19                            ; 82B4 A9 19                    ..
        jsr     LEA98                           ; 82B6 20 98 EA                  ..
        lda     #$1C                            ; 82B9 A9 1C                    ..
        sta     $0480,x                         ; 82BB 9D 80 04                 ...
        lda     #$D3                            ; 82BE A9 D3                    ..
        sta     $0588,x                         ; 82C0 9D 88 05                 ...
        lda     #$A2                            ; 82C3 A9 A2                    ..
        sta     $05A0,x                         ; 82C5 9D A0 05                 ...
        lda     #$C0                            ; 82C8 A9 C0                    ..
        sta     $0408,x                         ; 82CA 9D 08 04                 ...
        jsr     LEC16                           ; 82CD 20 16 EC                  ..
        jsr     LEC30                           ; 82D0 20 30 EC                  0.
        lda     $0480,x                         ; 82D3 BD 80 04                 ...
        beq     L82DD                           ; 82D6 F0 05                    ..
        dec     $0480,x                         ; 82D8 DE 80 04                 ...
        bne     L82AA                           ; 82DB D0 CD                    ..
L82DD:  lda     #$33                            ; 82DD A9 33                    .3
        sta     $03A8,x                         ; 82DF 9D A8 03                 ...
        lda     #$01                            ; 82E2 A9 01                    ..
        sta     $03C0,x                         ; 82E4 9D C0 03                 ...
        lda     #$78                            ; 82E7 A9 78                    .x
        sta     $0498,x                         ; 82E9 9D 98 04                 ...
        lda     #$2D                            ; 82EC A9 2D                    .-
        sta     $04B0,x                         ; 82EE 9D B0 04                 ...
        lda     #$1A                            ; 82F1 A9 1A                    ..
        jsr     LEA98                           ; 82F3 20 98 EA                  ..
        lda     #$00                            ; 82F6 A9 00                    ..
        sta     $0588,x                         ; 82F8 9D 88 05                 ...
        lda     #$A3                            ; 82FB A9 A3                    ..
        sta     $05A0,x                         ; 82FD 9D A0 05                 ...
        dec     $0498,x                         ; 8300 DE 98 04                 ...
        beq     L831F                           ; 8303 F0 1A                    ..
        dec     $04B0,x                         ; 8305 DE B0 04                 ...
        bne     L8315                           ; 8308 D0 0B                    ..
        lda     #$2D                            ; 830A A9 2D                    .-
        sta     $04B0,x                         ; 830C 9D B0 04                 ...
        jsr     LEC16                           ; 830F 20 16 EC                  ..
        jsr     LEC30                           ; 8312 20 30 EC                  0.
L8315:  ldy     #$1E                            ; 8315 A0 1E                    ..
        jsr     LEA3F                           ; 8317 20 3F EA                  ?.
        bcc     L833E                           ; 831A 90 22                    ."
        jmp     LEC4A                           ; 831C 4C 4A EC                 LJ.

; ----------------------------------------------------------------------------
L831F:  lda     $E6                             ; 831F A5 E6                    ..
        sbc     $E4                             ; 8321 E5 E4                    ..
        and     #$03                            ; 8323 29 03                    ).
        bne     L832A                           ; 8325 D0 03                    ..
        jmp     LA21C                           ; 8327 4C 1C A2                 L..

; ----------------------------------------------------------------------------
L832A:  lda     #$3F                            ; 832A A9 3F                    .?
        sta     $0588,x                         ; 832C 9D 88 05                 ...
        lda     #$A3                            ; 832F A9 A3                    ..
        sta     $05A0,x                         ; 8331 9D A0 05                 ...
        lda     #$1D                            ; 8334 A9 1D                    ..
        jsr     LEA98                           ; 8336 20 98 EA                  ..
        lda     #$80                            ; 8339 A9 80                    ..
        sta     $0408,x                         ; 833B 9D 08 04                 ...
L833E:  rts                                     ; 833E 60                       `

; ----------------------------------------------------------------------------
        jsr     LEC16                           ; 833F 20 16 EC                  ..
        jsr     LEC30                           ; 8342 20 30 EC                  0.
        lda     $0540,x                         ; 8345 BD 40 05                 .@.
        cmp     #$0A                            ; 8348 C9 0A                    ..
        bne     L833E                           ; 834A D0 F2                    ..
        lda     #$83                            ; 834C A9 83                    ..
        sta     $0588,x                         ; 834E 9D 88 05                 ...
        lda     #$A3                            ; 8351 A9 A3                    ..
        sta     $05A0,x                         ; 8353 9D A0 05                 ...
        lda     #$42                            ; 8356 A9 42                    .B
        jsr     LEC5D                           ; 8358 20 5D EC                  ].
        jsr     LF16F                           ; 835B 20 6F F1                  o.
        bcs     L833E                           ; 835E B0 DE                    ..
        lda     #$87                            ; 8360 A9 87                    ..
        sta     $0408,y                         ; 8362 99 08 04                 ...
        lda     #$6C                            ; 8365 A9 6C                    .l
        sta     $0300,y                         ; 8367 99 00 03                 ...
        lda     $0420,x                         ; 836A BD 20 04                 . .
        and     #$01                            ; 836D 29 01                    ).
        clc                                     ; 836F 18                       .
        adc     #$3A                            ; 8370 69 3A                    i:
        sta     $10                             ; 8372 85 10                    ..
        lda     #$1E                            ; 8374 A9 1E                    ..
        jsr     LEAF5                           ; 8376 20 F5 EA                  ..
        lda     #$00                            ; 8379 A9 00                    ..
        sta     $03D8,y                         ; 837B 99 D8 03                 ...
        lda     #$08                            ; 837E A9 08                    ..
        sta     $03F0,y                         ; 8380 99 F0 03                 ...
        lda     $0540,x                         ; 8383 BD 40 05                 .@.
        cmp     #$0B                            ; 8386 C9 0B                    ..
        bcs     L83A2                           ; 8388 B0 18                    ..
        lda     #$00                            ; 838A A9 00                    ..
        sta     $0570,x                         ; 838C 9D 70 05                 .p.
        ldy     #$17                            ; 838F A0 17                    ..
L8391:  lda     $0300,y                         ; 8391 B9 00 03                 ...
        cmp     #$6C                            ; 8394 C9 6C                    .l
        beq     L83C4                           ; 8396 F0 2C                    .,
        dey                                     ; 8398 88                       .
        cpy     #$07                            ; 8399 C0 07                    ..
        bcs     L8391                           ; 839B B0 F4                    ..
        lda     #$0B                            ; 839D A9 0B                    ..
        sta     $0540,x                         ; 839F 9D 40 05                 .@.
L83A2:  lda     $0540,x                         ; 83A2 BD 40 05                 .@.
        cmp     #$0E                            ; 83A5 C9 0E                    ..
        bne     L83C4                           ; 83A7 D0 1B                    ..
        lda     $0570,x                         ; 83A9 BD 70 05                 .p.
        cmp     #$02                            ; 83AC C9 02                    ..
        bne     L83C4                           ; 83AE D0 14                    ..
        lda     #$F8                            ; 83B0 A9 F8                    ..
        sta     $0588,x                         ; 83B2 9D 88 05                 ...
        lda     #$A1                            ; 83B5 A9 A1                    ..
        sta     $05A0,x                         ; 83B7 9D A0 05                 ...
        lda     #$19                            ; 83BA A9 19                    ..
        jsr     LEA98                           ; 83BC 20 98 EA                  ..
        lda     #$C0                            ; 83BF A9 C0                    ..
        sta     $0408,x                         ; 83C1 9D 08 04                 ...
L83C4:  rts                                     ; 83C4 60                       `

; ----------------------------------------------------------------------------
        lda     $0468,x                         ; 83C5 BD 68 04                 .h.
        bne     L83E1                           ; 83C8 D0 17                    ..
        jsr     LE94A                           ; 83CA 20 4A E9                  J.
        lda     $0378,x                         ; 83CD BD 78 03                 .x.
        cmp     #$08                            ; 83D0 C9 08                    ..
        bcs     L83C4                           ; 83D2 B0 F0                    ..
        lda     $0528,x                         ; 83D4 BD 28 05                 .(.
        ora     #$04                            ; 83D7 09 04                    ..
        sta     $0528,x                         ; 83D9 9D 28 05                 .(.
        lda     #$1C                            ; 83DC A9 1C                    ..
        sta     $0468,x                         ; 83DE 9D 68 04                 .h.
L83E1:  dec     $0468,x                         ; 83E1 DE 68 04                 .h.
        bne     L83C4                           ; 83E4 D0 DE                    ..
        lda     $E7                             ; 83E6 A5 E7                    ..
        sbc     $E4                             ; 83E8 E5 E4                    ..
        sta     $E4                             ; 83EA 85 E4                    ..
        and     #$07                            ; 83EC 29 07                    ).
        sta     $0E                             ; 83EE 85 0E                    ..
        asl     a                               ; 83F0 0A                       .
        clc                                     ; 83F1 18                       .
        adc     $0E                             ; 83F2 65 0E                    e.
        sta     $0E                             ; 83F4 85 0E                    ..
        stx     $0F                             ; 83F6 86 0F                    ..
        lda     #$02                            ; 83F8 A9 02                    ..
        sta     $0D                             ; 83FA 85 0D                    ..
L83FC:  jsr     LF16F                           ; 83FC 20 6F F1                  o.
        bcs     L83C4                           ; 83FF B0 C3                    ..
        lda     #$80                            ; 8401 A9 80                    ..
        sta     $0408,y                         ; 8403 99 08 04                 ...
        lda     #$00                            ; 8406 A9 00                    ..
        sta     $0450,y                         ; 8408 99 50 04                 .P.
        lda     #$6C                            ; 840B A9 6C                    .l
        sta     $0300,y                         ; 840D 99 00 03                 ...
        lda     #$22                            ; 8410 A9 22                    ."
        jsr     LEAA4                           ; 8412 20 A4 EA                  ..
        jsr     LEA34                           ; 8415 20 34 EA                  4.
        ldx     $0E                             ; 8418 A6 0E                    ..
        lda     #$08                            ; 841A A9 08                    ..
        sta     $0378,y                         ; 841C 99 78 03                 .x.
        lda     $A43D,x                         ; 841F BD 3D A4                 .=.
        sta     $0330,y                         ; 8422 99 30 03                 .0.
        .byte   $A9                             ; 8425 A9                       .
L8426:  .byte   $3A                             ; 8426 3A                       :
        sta     $0588,y                         ; 8427 99 88 05                 ...
        lda     #$A4                            ; 842A A9 A4                    ..
        sta     $05A0,y                         ; 842C 99 A0 05                 ...
        ldx     $0F                             ; 842F A6 0F                    ..
        inc     $0E                             ; 8431 E6 0E                    ..
        dec     $0D                             ; 8433 C6 0D                    ..
        bpl     L83FC                           ; 8435 10 C5                    ..
        jmp     LF2C4                           ; 8437 4C C4 F2                 L..

; ----------------------------------------------------------------------------
        jmp     LE968                           ; 843A 4C 68 E9                 Lh.

; ----------------------------------------------------------------------------
        rti                                     ; 843D 40                       @

; ----------------------------------------------------------------------------
        sei                                     ; 843E 78                       x
        bcs     L8469                           ; 843F B0 28                    .(
        rti                                     ; 8441 40                       @

; ----------------------------------------------------------------------------
        pla                                     ; 8442 68                       h
        cli                                     ; 8443 58                       X
        bcs     L8426                           ; 8444 B0 E0                    ..
        rts                                     ; 8446 60                       `

; ----------------------------------------------------------------------------
        dey                                     ; 8447 88                       .
        bcs     L846A                           ; 8448 B0 20                    . 
        .byte   $80                             ; 844A 80                       .
        cpx     #$40                            ; 844B E0 40                    .@
        sei                                     ; 844D 78                       x
        bcs     L8478                           ; 844E B0 28                    .(
        rti                                     ; 8450 40                       @

; ----------------------------------------------------------------------------
        pla                                     ; 8451 68                       h
        rts                                     ; 8452 60                       `

; ----------------------------------------------------------------------------
        dey                                     ; 8453 88                       .
        bcs     L8476                           ; 8454 B0 20                    . 
        asl     $EC,x                           ; 8456 16 EC                    ..
        jsr     LEC30                           ; 8458 20 30 EC                  0.
        lda     $0468,x                         ; 845B BD 68 04                 .h.
        beq     L8464                           ; 845E F0 04                    ..
        dec     $0468,x                         ; 8460 DE 68 04                 .h.
        rts                                     ; 8463 60                       `

; ----------------------------------------------------------------------------
L8464:  lda     $E7                             ; 8464 A5 E7                    ..
        sbc     $E4                             ; 8466 E5 E4                    ..
        .byte   $85                             ; 8468 85                       .
L8469:  .byte   $E4                             ; 8469 E4                       .
L846A:  and     #$01                            ; 846A 29 01                    ).
        bne     L8480                           ; 846C D0 12                    ..
        lda     #$93                            ; 846E A9 93                    ..
        sta     $0588,x                         ; 8470 9D 88 05                 ...
        lda     #$A4                            ; 8473 A9 A4                    ..
        .byte   $9D                             ; 8475 9D                       .
L8476:  ldy     #$05                            ; 8476 A0 05                    ..
L8478:  lda     #$13                            ; 8478 A9 13                    ..
        jsr     LEA98                           ; 847A 20 98 EA                  ..
        jmp     LA493                           ; 847D 4C 93 A4                 L..

; ----------------------------------------------------------------------------
L8480:  lda     #$CF                            ; 8480 A9 CF                    ..
        sta     $0588,x                         ; 8482 9D 88 05                 ...
        lda     #$A4                            ; 8485 A9 A4                    ..
        sta     $05A0,x                         ; 8487 9D A0 05                 ...
        lda     #$14                            ; 848A A9 14                    ..
        jsr     LEA98                           ; 848C 20 98 EA                  ..
        jsr     LA4CF                           ; 848F 20 CF A4                  ..
L8492:  rts                                     ; 8492 60                       `

; ----------------------------------------------------------------------------
        jsr     LEC16                           ; 8493 20 16 EC                  ..
        jsr     LEC30                           ; 8496 20 30 EC                  0.
        lda     $0558,x                         ; 8499 BD 58 05                 .X.
        cmp     #$12                            ; 849C C9 12                    ..
        beq     L84C2                           ; 849E F0 22                    ."
        lda     $0570,x                         ; 84A0 BD 70 05                 .p.
        cmp     #$04                            ; 84A3 C9 04                    ..
        bne     L8492                           ; 84A5 D0 EB                    ..
        lda     $0540,x                         ; 84A7 BD 40 05                 .@.
        cmp     #$01                            ; 84AA C9 01                    ..
        beq     L84B7                           ; 84AC F0 09                    ..
        cmp     #$06                            ; 84AE C9 06                    ..
        bne     L8492                           ; 84B0 D0 E0                    ..
        lda     #$12                            ; 84B2 A9 12                    ..
        jmp     LEA98                           ; 84B4 4C 98 EA                 L..

; ----------------------------------------------------------------------------
L84B7:  lda     #$03                            ; 84B7 A9 03                    ..
        sta     $0F                             ; 84B9 85 0F                    ..
        lda     #$6F                            ; 84BB A9 6F                    .o
        sta     $0E                             ; 84BD 85 0E                    ..
        jmp     LA595                           ; 84BF 4C 95 A5                 L..

; ----------------------------------------------------------------------------
L84C2:  ldy     $0480,x                         ; 84C2 BC 80 04                 ...
        lda     $0300,y                         ; 84C5 B9 00 03                 ...
        cmp     #$6F                            ; 84C8 C9 6F                    .o
        beq     L8492                           ; 84CA F0 C6                    ..
        jmp     LA58A                           ; 84CC 4C 8A A5                 L..

; ----------------------------------------------------------------------------
        lda     $0558,x                         ; 84CF BD 58 05                 .X.
        cmp     #$15                            ; 84D2 C9 15                    ..
        beq     L84E7                           ; 84D4 F0 11                    ..
        lda     $0570,x                         ; 84D6 BD 70 05                 .p.
        cmp     #$0A                            ; 84D9 C9 0A                    ..
        bne     L8492                           ; 84DB D0 B5                    ..
        lda     #$15                            ; 84DD A9 15                    ..
        jsr     LEA98                           ; 84DF 20 98 EA                  ..
        lda     #$14                            ; 84E2 A9 14                    ..
        sta     $0468,x                         ; 84E4 9D 68 04                 .h.
L84E7:  dec     $0468,x                         ; 84E7 DE 68 04                 .h.
        bne     L8492                           ; 84EA D0 A6                    ..
        lda     #$16                            ; 84EC A9 16                    ..
        jsr     LEA98                           ; 84EE 20 98 EA                  ..
        lda     #$08                            ; 84F1 A9 08                    ..
        sta     $0468,x                         ; 84F3 9D 68 04                 .h.
        lda     #$0A                            ; 84F6 A9 0A                    ..
        sta     $0588,x                         ; 84F8 9D 88 05                 ...
        .byte   $A9                             ; 84FB A9                       .
L84FC:  lda     $9D                             ; 84FC A5 9D                    ..
        ldy     #$05                            ; 84FE A0 05                    ..
        lda     #$00                            ; 8500 A9 00                    ..
        sta     $03D8,x                         ; 8502 9D D8 03                 ...
        lda     #$03                            ; 8505 A9 03                    ..
        sta     $03F0,x                         ; 8507 9D F0 03                 ...
        jsr     LEC16                           ; 850A 20 16 EC                  ..
        jsr     LEC30                           ; 850D 20 30 EC                  0.
        lda     $0468,x                         ; 8510 BD 68 04                 .h.
        beq     L8531                           ; 8513 F0 1C                    ..
        dec     $0468,x                         ; 8515 DE 68 04                 .h.
        bne     L8531                           ; 8518 D0 17                    ..
        jsr     LF16F                           ; 851A 20 6F F1                  o.
        bcs     L8594                           ; 851D B0 75                    .u
        lda     #$00                            ; 851F A9 00                    ..
        sta     $0408,y                         ; 8521 99 08 04                 ...
        sta     $0450,y                         ; 8524 99 50 04                 .P.
        lda     #$6D                            ; 8527 A9 6D                    .m
        sta     $0300,y                         ; 8529 99 00 03                 ...
        lda     #$17                            ; 852C A9 17                    ..
        jsr     LEAA4                           ; 852E 20 A4 EA                  ..
L8531:  ldy     #$1D                            ; 8531 A0 1D                    ..
        jsr     LE780                           ; 8533 20 80 E7                  ..
        bcc     L8594                           ; 8536 90 5C                    .\
        lda     #$4D                            ; 8538 A9 4D                    .M
        sta     $0588,x                         ; 853A 9D 88 05                 ...
        lda     #$A5                            ; 853D A9 A5                    ..
        sta     $05A0,x                         ; 853F 9D A0 05                 ...
        lda     #$04                            ; 8542 A9 04                    ..
        sta     $0F                             ; 8544 85 0F                    ..
        lda     #$80                            ; 8546 A9 80                    ..
        sta     $0E                             ; 8548 85 0E                    ..
        jmp     LA595                           ; 854A 4C 95 A5                 L..

; ----------------------------------------------------------------------------
        ldy     $0480,x                         ; 854D BC 80 04                 ...
        lda     $0300,y                         ; 8550 B9 00 03                 ...
        cmp     #$80                            ; 8553 C9 80                    ..
        beq     L8594                           ; 8555 F0 3D                    .=
        ldy     $0330                           ; 8557 AC 30 03                 .0.
        cpy     #$20                            ; 855A C0 20                    . 
        bcs     L8562                           ; 855C B0 04                    ..
        ldy     #$20                            ; 855E A0 20                    . 
        bne     L8568                           ; 8560 D0 06                    ..
L8562:  cpy     #$E0                            ; 8562 C0 E0                    ..
        bcc     L8568                           ; 8564 90 02                    ..
        ldy     #$E0                            ; 8566 A0 E0                    ..
L8568:  tya                                     ; 8568 98                       .
        sta     $0330,x                         ; 8569 9D 30 03                 .0.
        lda     #$79                            ; 856C A9 79                    .y
        sta     $0588,x                         ; 856E 9D 88 05                 ...
        lda     #$A5                            ; 8571 A9 A5                    ..
        sta     $05A0,x                         ; 8573 9D A0 05                 ...
        jsr     LEA1E                           ; 8576 20 1E EA                  ..
        ldy     #$1C                            ; 8579 A0 1C                    ..
        jsr     LE7B7                           ; 857B 20 B7 E7                  ..
        bcc     L8594                           ; 857E 90 14                    ..
        lda     #$12                            ; 8580 A9 12                    ..
        jsr     LEA98                           ; 8582 20 98 EA                  ..
        lda     #$1E                            ; 8585 A9 1E                    ..
        sta     $0468,x                         ; 8587 9D 68 04                 .h.
        lda     #$55                            ; 858A A9 55                    .U
        sta     $0588,x                         ; 858C 9D 88 05                 ...
        lda     #$A4                            ; 858F A9 A4                    ..
        .byte   $9D                             ; 8591 9D                       .
L8592:  ldy     #$05                            ; 8592 A0 05                    ..
L8594:  rts                                     ; 8594 60                       `

; ----------------------------------------------------------------------------
        jsr     LF16F                           ; 8595 20 6F F1                  o.
        bcs     L8594                           ; 8598 B0 FA                    ..
        lda     #$91                            ; 859A A9 91                    ..
        sta     $0408,y                         ; 859C 99 08 04                 ...
        lda     $0E                             ; 859F A5 0E                    ..
        sta     $0300,y                         ; 85A1 99 00 03                 ...
        lda     $0420,x                         ; 85A4 BD 20 04                 . .
        sta     $0420,y                         ; 85A7 99 20 04                 . .
        and     #$01                            ; 85AA 29 01                    ).
        clc                                     ; 85AC 18                       .
        adc     #$51                            ; 85AD 69 51                    iQ
        sta     $10                             ; 85AF 85 10                    ..
        lda     #$18                            ; 85B1 A9 18                    ..
        jsr     LEAF5                           ; 85B3 20 F5 EA                  ..
        lda     $0528,y                         ; 85B6 B9 28 05                 .(.
        ora     #$10                            ; 85B9 09 10                    ..
        sta     $0528,y                         ; 85BB 99 28 05                 .(.
        lda     $0F                             ; 85BE A5 0F                    ..
        sta     $03F0,y                         ; 85C0 99 F0 03                 ...
        sta     $03C0,y                         ; 85C3 99 C0 03                 ...
        lda     #$00                            ; 85C6 A9 00                    ..
        sta     $03D8,y                         ; 85C8 99 D8 03                 ...
        sta     $03A8,y                         ; 85CB 99 A8 03                 ...
        tya                                     ; 85CE 98                       .
        sta     $0480,x                         ; 85CF 9D 80 04                 ...
        rts                                     ; 85D2 60                       `

; ----------------------------------------------------------------------------
        jsr     LEA65                           ; 85D3 20 65 EA                  e.
        ldy     $0330,x                         ; 85D6 BC 30 03                 .0.
        lda     $0420,x                         ; 85D9 BD 20 04                 . .
        and     #$01                            ; 85DC 29 01                    ).
        beq     L85E7                           ; 85DE F0 07                    ..
        cpy     $0330                           ; 85E0 CC 30 03                 .0.
        bcc     L861F                           ; 85E3 90 3A                    .:
        bcs     L85EC                           ; 85E5 B0 05                    ..
L85E7:  cpy     $0330                           ; 85E7 CC 30 03                 .0.
        bcs     L861F                           ; 85EA B0 33                    .3
L85EC:  ldy     #$08                            ; 85EC A0 08                    ..
        lda     $0378,x                         ; 85EE BD 78 03                 .x.
        cmp     $0378                           ; 85F1 CD 78 03                 .x.
        bcs     L8600                           ; 85F4 B0 0A                    ..
        lda     $0528,x                         ; 85F6 BD 28 05                 .(.
        and     #$EF                            ; 85F9 29 EF                    ).
        sta     $0528,x                         ; 85FB 9D 28 05                 .(.
        ldy     #$04                            ; 85FE A0 04                    ..
L8600:  tya                                     ; 8600 98                       .
        sta     $0420,x                         ; 8601 9D 20 04                 . .
        lda     #$13                            ; 8604 A9 13                    ..
        sta     $0588,x                         ; 8606 9D 88 05                 ...
        lda     #$A6                            ; 8609 A9 A6                    ..
        sta     $05A0,x                         ; 860B 9D A0 05                 ...
        lda     #$14                            ; 860E A9 14                    ..
        sta     $0468,x                         ; 8610 9D 68 04                 .h.
        lda     $0468,x                         ; 8613 BD 68 04                 .h.
        beq     L861C                           ; 8616 F0 04                    ..
        dec     $0468,x                         ; 8618 DE 68 04                 .h.
        rts                                     ; 861B 60                       `

; ----------------------------------------------------------------------------
L861C:  jsr     LEA86                           ; 861C 20 86 EA                  ..
L861F:  rts                                     ; 861F 60                       `

; ----------------------------------------------------------------------------
        jsr     LE92A                           ; 8620 20 2A E9                  *.
        lda     $0378,x                         ; 8623 BD 78 03                 .x.
        cmp     $0378                           ; 8626 CD 78 03                 .x.
        bcc     L861F                           ; 8629 90 F4                    ..
        lda     #$14                            ; 862B A9 14                    ..
        sta     $0468,x                         ; 862D 9D 68 04                 .h.
        lda     #$3A                            ; 8630 A9 3A                    .:
        sta     $0588,x                         ; 8632 9D 88 05                 ...
        lda     #$A6                            ; 8635 A9 A6                    ..
        sta     $05A0,x                         ; 8637 9D A0 05                 ...
        lda     $0468,x                         ; 863A BD 68 04                 .h.
        beq     L8647                           ; 863D F0 08                    ..
        dec     $0468,x                         ; 863F DE 68 04                 .h.
        bne     L861F                           ; 8642 D0 DB                    ..
        jsr     LEC16                           ; 8644 20 16 EC                  ..
L8647:  jmp     LEA65                           ; 8647 4C 65 EA                 Le.

; ----------------------------------------------------------------------------
        .byte   $FA                             ; 864A FA                       .
        .byte   $D4                             ; 864B D4                       .
        .byte   $FF                             ; 864C FF                       .
        ora     $6DFD,x                         ; 864D 1D FD 6D                 ..m
        sbc     $FA75,y                         ; 8650 F9 75 FA                 .u.
        .byte   $7F                             ; 8653 7F                       .
        sbc     $DFFC,y                         ; 8654 F9 FC DF                 ...
        eor     $7D9B,x                         ; 8657 5D 9B 7D                 ].}
        .byte   $E7                             ; 865A E7                       .
        adc     $F7                             ; 865B 65 F7                    e.
        .byte   $BB                             ; 865D BB                       .
        cmp     $FF9F                           ; 865E CD 9F FF                 ...
        .byte   $D4                             ; 8661 D4                       .
        lda     L8D5E                           ; 8662 AD 5E 8D                 .^.
        .byte   $F7                             ; 8665 F7                       .
        .byte   $FF                             ; 8666 FF                       .
        eor     $B4DF,x                         ; 8667 5D DF B4                 ]..
        .byte   $BB                             ; 866A BB                       .
        eor     $FD                             ; 866B 45 FD                    E.
        .byte   $47                             ; 866D 47                       G
        dec     $AD55                           ; 866E CE 55 AD                 .U.
        eor     ($DD),y                         ; 8671 51 DD                    Q.
        .byte   $D4                             ; 8673 D4                       .
        .byte   $F3                             ; 8674 F3                       .
        adc     $9F                             ; 8675 65 9F                    e.
        ror     $4F,x                           ; 8677 76 4F                    vO
        ora     $7E,x                           ; 8679 15 7E                    .~
        .byte   $53                             ; 867B 53                       S
        .byte   $FF                             ; 867C FF                       .
        .byte   $67                             ; 867D 67                       g
        .byte   $BF                             ; 867E BF                       .
        eor     $DA,x                           ; 867F 55 DA                    U.
        adc     $FF,x                           ; 8681 75 FF                    u.
        cmp     $FF,x                           ; 8683 D5 FF                    ..
        eor     $9F,x                           ; 8685 55 9F                    U.
        .byte   $F4                             ; 8687 F4                       .
        .byte   $BF                             ; 8688 BF                       .
        sbc     $77A7,x                         ; 8689 FD A7 77                 ..w
        ora     $2E53,x                         ; 868C 1D 53 2E                 .S.
        sta     ($FF),y                         ; 868F 91 FF                    ..
        eor     $FC                             ; 8691 45 FC                    E.
        cmp     $AF,x                           ; 8693 D5 AF                    ..
        cmp     $FF                             ; 8695 C5 FF                    ..
        .byte   $7C                             ; 8697 7C                       |
        .byte   $FF                             ; 8698 FF                       .
        .byte   $7C                             ; 8699 7C                       |
        ldx     $FA97,y                         ; 869A BE 97 FA                 ...
        ror     $DF,x                           ; 869D 76 DF                    v.
        eor     $FB,x                           ; 869F 55 FB                    U.
        .byte   $77                             ; 86A1 77                       w
        .byte   $FF                             ; 86A2 FF                       .
        .byte   $5F                             ; 86A3 5F                       _
        .byte   $9F                             ; 86A4 9F                       .
        .byte   $DC                             ; 86A5 DC                       .
        inc     $FE7D,x                         ; 86A6 FE 7D FE                 .}.
        eor     $FF,x                           ; 86A9 55 FF                    U.
        adc     $7F,x                           ; 86AB 75 7F                    u.
        sta     $FD,x                           ; 86AD 95 FD                    ..
        eor     $FD,x                           ; 86AF 55 FD                    U.
        .byte   $74                             ; 86B1 74                       t
        and     $3B55,x                         ; 86B2 3D 55 3B                 =U;
        sbc     L97BF,x                         ; 86B5 FD BF 97                 ...
        .byte   $FF                             ; 86B8 FF                       .
        .byte   $5F                             ; 86B9 5F                       _
        .byte   $F7                             ; 86BA F7                       .
        .byte   $77                             ; 86BB 77                       w
        .byte   $7F                             ; 86BC 7F                       .
        .byte   $B7                             ; 86BD B7                       .
        sbc     $7D5F,x                         ; 86BE FD 5F 7D                 ._}
        .byte   $DF                             ; 86C1 DF                       .
        eor     $E257,x                         ; 86C2 5D 57 E2                 ]W.
        sta     $5F,x                           ; 86C5 95 5F                    ._
        eor     $EB,x                           ; 86C7 55 EB                    U.
        adc     $8F,x                           ; 86C9 75 8F                    u.
        .byte   $DB                             ; 86CB DB                       .
        .byte   $BF                             ; 86CC BF                       .
        .byte   $F7                             ; 86CD F7                       .
        .byte   $DF                             ; 86CE DF                       .
        eor     $556B                           ; 86CF 4D 6B 55                 MkU
        ldx     $BE4F,y                         ; 86D2 BE 4F BE                 .O.
        .byte   $57                             ; 86D5 57                       W
        sbc     $EFE4,y                         ; 86D6 F9 E4 EF                 ...
        cmp     $157F,x                         ; 86D9 DD 7F 15                 ...
        sbc     ($C5,x)                         ; 86DC E1 C5                    ..
        .byte   $FF                             ; 86DE FF                       .
        .byte   $37                             ; 86DF 37                       7
        ror     $FFCF,x                         ; 86E0 7E CF FF                 ~..
        .byte   $57                             ; 86E3 57                       W
        .byte   $EF                             ; 86E4 EF                       .
        .byte   $77                             ; 86E5 77                       w
        .byte   $BF                             ; 86E6 BF                       .
        eor     $55FC,x                         ; 86E7 5D FC 55                 ].U
        .byte   $FB                             ; 86EA FB                       .
L86EB:  .byte   $77                             ; 86EB 77                       w
        .byte   $FF                             ; 86EC FF                       .
        cmp     $FF,x                           ; 86ED D5 FF                    ..
        sta     $7D7F,x                         ; 86EF 9D 7F 7D                 ..}
        .byte   $FB                             ; 86F2 FB                       .
        eor     $F7,x                           ; 86F3 55 F7                    U.
        and     $35F9,x                         ; 86F5 3D F9 35                 =.5
        .byte   $F7                             ; 86F8 F7                       .
        .byte   $17                             ; 86F9 17                       .
        sbc     $FE53,x                         ; 86FA FD 53 FE                 .S.
        .byte   $74                             ; 86FD 74                       t
        cmp     $5ED5,y                         ; 86FE D9 D5 5E                 ..^
        eor     $56CB,x                         ; 8701 5D CB 56                 ].V
        .byte   $EB                             ; 8704 EB                       .
        eor     $577F,x                         ; 8705 5D 7F 57                 ].W
        inc     $59,x                           ; 8708 F6 59                    .Y
        .byte   $CF                             ; 870A CF                       .
        cmp     $E9,x                           ; 870B D5 E9                    ..
        .byte   $53                             ; 870D 53                       S
        .byte   $BB                             ; 870E BB                       .
        eor     $BFEE,y                         ; 870F 59 EE BF                 Y..
        sbc     $FE66,x                         ; 8712 FD 66 FE                 .f.
        .byte   $5B                             ; 8715 5B                       [
        dec     $11,x                           ; 8716 D6 11                    ..
        .byte   $F2                             ; 8718 F2                       .
        sbc     $DE,x                           ; 8719 F5 DE                    ..
        sbc     $7CFB,y                         ; 871B F9 FB 7C                 ..|
        .byte   $3B                             ; 871E 3B                       ;
        .byte   $E2                             ; 871F E2                       .
        inc     $FF75,x                         ; 8720 FE 75 FF                 .u.
        .byte   $57                             ; 8723 57                       W
L8724:  .byte   $7B                             ; 8724 7B                       {
        .byte   $D4                             ; 8725 D4                       .
        .byte   $FF                             ; 8726 FF                       .
        adc     $55CD,x                         ; 8727 7D CD 55                 }.U
        .byte   $FF                             ; 872A FF                       .
        cpx     $FB                             ; 872B E4 FB                    ..
        .byte   $D7                             ; 872D D7                       .
        .byte   $F7                             ; 872E F7                       .
        .byte   $7F                             ; 872F 7F                       .
        .byte   $6F                             ; 8730 6F                       o
        .byte   $7F                             ; 8731 7F                       .
        .byte   $FB                             ; 8732 FB                       .
        eor     $5BB7,x                         ; 8733 5D B7 5B                 ].[
        .byte   $FF                             ; 8736 FF                       .
        eor     $7D,x                           ; 8737 55 7D                    U}
        .byte   $3F                             ; 8739 3F                       ?
        .byte   $AF                             ; 873A AF                       .
        adc     $79BD,x                         ; 873B 7D BD 79                 }.y
        .byte   $9F                             ; 873E 9F                       .
        .byte   $77                             ; 873F 77                       w
        .byte   $7F                             ; 8740 7F                       .
        .byte   $54                             ; 8741 54                       T
        inc     $EE5C,x                         ; 8742 FE 5C EE                 .\.
        eor     $FE,x                           ; 8745 55 FE                    U.
        .byte   $57                             ; 8747 57                       W
        .byte   $FF                             ; 8748 FF                       .
        .byte   $77                             ; 8749 77                       w
        .byte   $BF                             ; 874A BF                       .
        sei                                     ; 874B 78                       x
        .byte   $D7                             ; 874C D7                       .
        .byte   $57                             ; 874D 57                       W
        .byte   $FF                             ; 874E FF                       .
        adc     $7F,x                           ; 874F 75 7F                    u.
        sty     $BB,x                           ; 8751 94 BB                    ..
        sbc     ($F9),y                         ; 8753 F1 F9                    ..
        .byte   $5F                             ; 8755 5F                       _
        .byte   $CF                             ; 8756 CF                       .
        .byte   $D4                             ; 8757 D4                       .
        .byte   $F3                             ; 8758 F3                       .
        cmp     $3D,x                           ; 8759 D5 3D                    .=
        ora     ($BE,x)                         ; 875B 01 BE                    ..
        .byte   $77                             ; 875D 77                       w
        .byte   $F2                             ; 875E F2                       .
        .byte   $AF                             ; 875F AF                       .
        .byte   $BF                             ; 8760 BF                       .
        adc     $77,x                           ; 8761 75 77                    uw
        eor     $98,x                           ; 8763 55 98                    U.
        eor     ($F6),y                         ; 8765 51 F6                    Q.
        eor     $EF,x                           ; 8767 55 EF                    U.
        adc     $FF,x                           ; 8769 75 FF                    u.
        .byte   $77                             ; 876B 77                       w
        .byte   $FF                             ; 876C FF                       .
        .byte   $5F                             ; 876D 5F                       _
        .byte   $F7                             ; 876E F7                       .
        .byte   $07                             ; 876F 07                       .
        sbc     $DFDD,x                         ; 8770 FD DD DF                 ...
        .byte   $4F                             ; 8773 4F                       O
        .byte   $AF                             ; 8774 AF                       .
        ldx     $1FFF,y                         ; 8775 BE FF 1F                 ...
        lsr     $EF34,x                         ; 8778 5E 34 EF                 ^4.
        sbc     $FF,x                           ; 877B F5 FF                    ..
        .byte   $77                             ; 877D 77                       w
        inc     $FF55,x                         ; 877E FE 55 FF                 .U.
        eor     $B9,x                           ; 8781 55 B9                    U.
        eor     $D5BB                           ; 8783 4D BB D5                 M..
        .byte   $F7                             ; 8786 F7                       .
        adc     $D6,x                           ; 8787 75 D6                    u.
        .byte   $FF                             ; 8789 FF                       .
        .byte   $E7                             ; 878A E7                       .
        eor     $3C,x                           ; 878B 55 3C                    U<
        ora     $D5FD,x                         ; 878D 1D FD D5                 ...
        ror     $AB55,x                         ; 8790 7E 55 AB                 ~U.
        adc     $54CB                           ; 8793 6D CB 54                 m.T
        .byte   $6F                             ; 8796 6F                       o
        adc     $51DF,x                         ; 8797 7D DF 51                 }.Q
        inc     $FBFF,x                         ; 879A FE FF FB                 ...
        eor     ($DF),y                         ; 879D 51 DF                    Q.
        cmp     $55FF,y                         ; 879F D9 FF 55                 ..U
        .byte   $FF                             ; 87A2 FF                       .
        eor     $FF                             ; 87A3 45 FF                    E.
        adc     ($FB),y                         ; 87A5 71 FB                    q.
        adc     $4D67,y                         ; 87A7 79 67 4D                 ygM
        inc     $FF17,x                         ; 87AA FE 17 FF                 ...
        .byte   $DB                             ; 87AD DB                       .
        .byte   $7F                             ; 87AE 7F                       .
        eor     $FB,x                           ; 87AF 55 FB                    U.
        eor     $9E,x                           ; 87B1 55 9E                    U.
        cmp     $41FF,x                         ; 87B3 DD FF 41                 ..A
        clv                                     ; 87B6 B8                       .
        .byte   $7C                             ; 87B7 7C                       |
        .byte   $7F                             ; 87B8 7F                       .
        eor     $7E,x                           ; 87B9 55 7E                    U~
        adc     $37EC,x                         ; 87BB 7D EC 37                 }.7
        adc     $BFD9,y                         ; 87BE 79 D9 BF                 y..
        cmp     $9E,x                           ; 87C1 D5 9E                    ..
        .byte   $77                             ; 87C3 77                       w
        inc     $E257,x                         ; 87C4 FE 57 E2                 .W.
        eor     $FA                             ; 87C7 45 FA                    E.
        .byte   $C7                             ; 87C9 C7                       .
        inc     $FED3,x                         ; 87CA FE D3 FE                 ...
        cmp     $DB,x                           ; 87CD D5 DB                    ..
        .byte   $D7                             ; 87CF D7                       .
        .byte   $EF                             ; 87D0 EF                       .
        eor     $EE,x                           ; 87D1 55 EE                    U.
        .byte   $DF                             ; 87D3 DF                       .
        cmp     $BF14,x                         ; 87D4 DD 14 BF                 ...
        eor     $BD7E                           ; 87D7 4D 7E BD                 M~.
        inc     $FF,x                           ; 87DA F6 FF                    ..
        .byte   $7F                             ; 87DC 7F                       .
        eor     $1D,x                           ; 87DD 55 1D                    U.
        cmp     $5DFF,x                         ; 87DF DD FF 5D                 ..]
        .byte   $DF                             ; 87E2 DF                       .
        cmp     $DFFF,x                         ; 87E3 DD FF DF                 ...
        .byte   $DF                             ; 87E6 DF                       .
        .byte   $17                             ; 87E7 17                       .
        sbc     $FFD3,y                         ; 87E8 F9 D3 FF                 ...
        lda     $FF,x                           ; 87EB B5 FF                    ..
        .byte   $E7                             ; 87ED E7                       .
        .byte   $B7                             ; 87EE B7                       .
        cmp     $FD,x                           ; 87EF D5 FD                    ..
        cld                                     ; 87F1 D8                       .
        .byte   $FF                             ; 87F2 FF                       .
        .byte   $57                             ; 87F3 57                       W
        .byte   $EF                             ; 87F4 EF                       .
        cmp     $DEFF,y                         ; 87F5 D9 FF DE                 ...
        .byte   $FB                             ; 87F8 FB                       .
        and     $5E                             ; 87F9 25 5E                    %^
        stx     $FE                             ; 87FB 86 FE                    ..
        cmp     $EB,x                           ; 87FD D5 EB                    ..
        adc     a:L0000,x                       ; 87FF 7D 00 00                 }..
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
L880D:  brk                                     ; 880D 00                       .
        brk                                     ; 880E 00                       .
        brk                                     ; 880F 00                       .
        ora     ($01,x)                         ; 8810 01 01                    ..
        ora     ($01,x)                         ; 8812 01 01                    ..
        ora     ($01,x)                         ; 8814 01 01                    ..
        ora     ($01,x)                         ; 8816 01 01                    ..
        ora     ($01,x)                         ; 8818 01 01                    ..
        ora     ($01,x)                         ; 881A 01 01                    ..
        ora     ($01,x)                         ; 881C 01 01                    ..
        brk                                     ; 881E 00                       .
        brk                                     ; 881F 00                       .
        ora     ($01,x)                         ; 8820 01 01                    ..
        brk                                     ; 8822 00                       .
        brk                                     ; 8823 00                       .
        brk                                     ; 8824 00                       .
        ora     (L0000,x)                       ; 8825 01 00                    ..
        brk                                     ; 8827 00                       .
        ora     ($01,x)                         ; 8828 01 01                    ..
        ora     ($01,x)                         ; 882A 01 01                    ..
        brk                                     ; 882C 00                       .
        ora     (L0000,x)                       ; 882D 01 00                    ..
        brk                                     ; 882F 00                       .
        brk                                     ; 8830 00                       .
        ora     ($01,x)                         ; 8831 01 01                    ..
        ora     ($01,x)                         ; 8833 01 01                    ..
        brk                                     ; 8835 00                       .
        ora     (L0000,x)                       ; 8836 01 00                    ..
        brk                                     ; 8838 00                       .
        ora     ($01,x)                         ; 8839 01 01                    ..
        ora     (L0000,x)                       ; 883B 01 00                    ..
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
        ora     ($01,x)                         ; 8851 01 01                    ..
        ora     ($01,x)                         ; 8853 01 01                    ..
        ora     ($01,x)                         ; 8855 01 01                    ..
        brk                                     ; 8857 00                       .
        brk                                     ; 8858 00                       .
        .byte   $02                             ; 8859 02                       .
        ora     (L0000,x)                       ; 885A 01 00                    ..
        ora     ($02,x)                         ; 885C 01 02                    ..
        brk                                     ; 885E 00                       .
        brk                                     ; 885F 00                       .
        ora     (L0000,x)                       ; 8860 01 00                    ..
        ora     ($01,x)                         ; 8862 01 01                    ..
        ora     ($01,x)                         ; 8864 01 01                    ..
        ora     ($01,x)                         ; 8866 01 01                    ..
        ora     ($01,x)                         ; 8868 01 01                    ..
        brk                                     ; 886A 00                       .
        .byte   $04                             ; 886B 04                       .
        brk                                     ; 886C 00                       .
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
        ora     (L0000,x)                       ; 8889 01 00                    ..
        brk                                     ; 888B 00                       .
        brk                                     ; 888C 00                       .
        ora     (L0000,x)                       ; 888D 01 00                    ..
        brk                                     ; 888F 00                       .
        brk                                     ; 8890 00                       .
        ora     (L0000,x)                       ; 8891 01 00                    ..
        ora     (L0000,x)                       ; 8893 01 00                    ..
        brk                                     ; 8895 00                       .
        ora     ($01,x)                         ; 8896 01 01                    ..
        .byte   $02                             ; 8898 02                       .
        brk                                     ; 8899 00                       .
        brk                                     ; 889A 00                       .
        brk                                     ; 889B 00                       .
        ora     (L0000,x)                       ; 889C 01 00                    ..
        ora     ($01,x)                         ; 889E 01 01                    ..
        brk                                     ; 88A0 00                       .
        brk                                     ; 88A1 00                       .
        brk                                     ; 88A2 00                       .
        brk                                     ; 88A3 00                       .
        brk                                     ; 88A4 00                       .
        ora     (L0000,x)                       ; 88A5 01 00                    ..
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
        bpl     L8923                           ; 8910 10 11                    ..
        .byte   $12                             ; 8912 12                       .
        .byte   $13                             ; 8913 13                       .
        .byte   $14                             ; 8914 14                       .
        ora     $16,x                           ; 8915 15 16                    ..
        .byte   $17                             ; 8917 17                       .
        clc                                     ; 8918 18                       .
        ora     $1B1A,y                         ; 8919 19 1A 1B                 ...
        .byte   $1C                             ; 891C 1C                       .
        ora     $0C00,x                         ; 891D 1D 00 0C                 ...
        ldy     #$00                            ; 8920 A0 00                    ..
        brk                                     ; 8922 00                       .
L8923:  .byte   $80                             ; 8923 80                       .
        brk                                     ; 8924 00                       .
        brk                                     ; 8925 00                       .
        php                                     ; 8926 08                       .
        sta     ($08,x)                         ; 8927 81 08                    ..
        bpl     L892B                           ; 8929 10 00                    ..
L892B:  brk                                     ; 892B 00                       .
        .byte   $02                             ; 892C 02                       .
        brk                                     ; 892D 00                       .
        .byte   $02                             ; 892E 02                       .
        .byte   $54                             ; 892F 54                       T
        brk                                     ; 8930 00                       .
        brk                                     ; 8931 00                       .
        brk                                     ; 8932 00                       .
        .byte   $04                             ; 8933 04                       .
        .byte   $80                             ; 8934 80                       .
        bmi     L8957                           ; 8935 30 20                    0 
        .byte   $80                             ; 8937 80                       .
        brk                                     ; 8938 00                       .
        ora     (L0020,x)                       ; 8939 01 20                    . 
        php                                     ; 893B 08                       .
        php                                     ; 893C 08                       .
        .byte   $22                             ; 893D 22                       "
        php                                     ; 893E 08                       .
        sty     $08                             ; 893F 84 08                    ..
        brk                                     ; 8941 00                       .
        php                                     ; 8942 08                       .
        brk                                     ; 8943 00                       .
        brk                                     ; 8944 00                       .
        .byte   $02                             ; 8945 02                       .
        brk                                     ; 8946 00                       .
        ldy     #$00                            ; 8947 A0 00                    ..
        brk                                     ; 8949 00                       .
        brk                                     ; 894A 00                       .
        .byte   $62                             ; 894B 62                       b
        brk                                     ; 894C 00                       .
        rti                                     ; 894D 40                       @

; ----------------------------------------------------------------------------
        php                                     ; 894E 08                       .
        .byte   $80                             ; 894F 80                       .
        .byte   $23                             ; 8950 23                       #
L8951:  rti                                     ; 8951 40                       @

; ----------------------------------------------------------------------------
        rts                                     ; 8952 60                       `

; ----------------------------------------------------------------------------
        .byte   $22                             ; 8953 22                       "
        jsr     L23A0                           ; 8954 20 A0 23                  .#
L8957:  .byte   $80                             ; 8957 80                       .
        ldx     #$40                            ; 8958 A2 40                    .@
        .byte   $62                             ; 895A 62                       b
        rti                                     ; 895B 40                       @

; ----------------------------------------------------------------------------
        .byte   $62                             ; 895C 62                       b
        jsr     L0020                           ; 895D 20 20 00                   .
        brk                                     ; 8960 00                       .
        jsr     L0400                           ; 8961 20 00 04                  ..
        php                                     ; 8964 08                       .
        ora     (L0000,x)                       ; 8965 01 00                    ..
        bvc     L898B                           ; 8967 50 22                    P"
        .byte   $22                             ; 8969 22                       "
        .byte   $1C                             ; 896A 1C                       .
        bit     L0000                           ; 896B 24 00                    $.
        brk                                     ; 896D 00                       .
        ora     $16,x                           ; 896E 15 16                    ..
        .byte   $2B                             ; 8970 2B                       +
        .byte   $1C                             ; 8971 1C                       .
        and     L0000                           ; 8972 25 00                    %.
        bit     L0080                           ; 8974 24 80                    $.
        lda     L8200,y                         ; 8976 B9 00 82                 ...
        .byte   $42                             ; 8979 42                       B
        brk                                     ; 897A 00                       .
        sbc     (L0000,x)                       ; 897B E1 00                    ..
        .byte   $03                             ; 897D 03                       .
        brk                                     ; 897E 00                       .
        php                                     ; 897F 08                       .
        tya                                     ; 8980 98                       .
        txs                                     ; 8981 9A                       .
        jsr     L2800                           ; 8982 20 00 28                  .(
        brk                                     ; 8985 00                       .
        brk                                     ; 8986 00                       .
        .byte   $20                             ; 8987 20                        
L8988:  .byte   $0F                             ; 8988 0F                       .
        and     #$19                            ; 8989 29 19                    ).
L898B:  .byte   $0B                             ; 898B 0B                       .
        .byte   $0F                             ; 898C 0F                       .
        .byte   $27                             ; 898D 27                       '
        .byte   $17                             ; 898E 17                       .
        .byte   $0B                             ; 898F 0B                       .
        .byte   $0F                             ; 8990 0F                       .
        and     $1827,y                         ; 8991 39 27 18                 9'.
        .byte   $0F                             ; 8994 0F                       .
        bit     $14                             ; 8995 24 14                    $.
        .byte   $03                             ; 8997 03                       .
        brk                                     ; 8998 00                       .
        brk                                     ; 8999 00                       .
        brk                                     ; 899A 00                       .
        brk                                     ; 899B 00                       .
        .byte   $0F                             ; 899C 0F                       .
        .byte   $3C                             ; 899D 3C                       <
        bit     $0F20                           ; 899E 2C 20 0F                 , .
        .byte   $1C                             ; 89A1 1C                       .
        bpl     L89D0                           ; 89A2 10 2C                    .,
        .byte   $0F                             ; 89A4 0F                       .
        and     $1827,y                         ; 89A5 39 27 18                 9'.
        .byte   $0F                             ; 89A8 0F                       .
        bit     $14                             ; 89A9 24 14                    $.
        .byte   $03                             ; 89AB 03                       .
        .byte   $9B                             ; 89AC 9B                       .
        .byte   $9C                             ; 89AD 9C                       .
        brk                                     ; 89AE 00                       .
        brk                                     ; 89AF 00                       .
        .byte   $0F                             ; 89B0 0F                       .
        sec                                     ; 89B1 38                       8
        .byte   $27                             ; 89B2 27                       '
        clc                                     ; 89B3 18                       .
        .byte   $0F                             ; 89B4 0F                       .
        .byte   $27                             ; 89B5 27                       '
        ora     $0F0B,y                         ; 89B6 19 0B 0F                 ...
        and     $1827,y                         ; 89B9 39 27 18                 9'.
        .byte   $0F                             ; 89BC 0F                       .
        bit     $14                             ; 89BD 24 14                    $.
        .byte   $03                             ; 89BF 03                       .
        brk                                     ; 89C0 00                       .
        brk                                     ; 89C1 00                       .
        brk                                     ; 89C2 00                       .
        brk                                     ; 89C3 00                       .
        brk                                     ; 89C4 00                       .
        brk                                     ; 89C5 00                       .
        brk                                     ; 89C6 00                       .
        bpl     L8951                           ; 89C7 10 88                    ..
        dey                                     ; 89C9 88                       .
        brk                                     ; 89CA 00                       .
        bit     $02                             ; 89CB 24 02                    $.
        ora     (L0080,x)                       ; 89CD 01 80                    ..
        brk                                     ; 89CF 00                       .
L89D0:  brk                                     ; 89D0 00                       .
        .byte   $44                             ; 89D1 44                       D
        ldx     #$01                            ; 89D2 A2 01                    ..
        brk                                     ; 89D4 00                       .
        plp                                     ; 89D5 28                       (
        brk                                     ; 89D6 00                       .
        rts                                     ; 89D7 60                       `

; ----------------------------------------------------------------------------
        .byte   $03                             ; 89D8 03                       .
        brk                                     ; 89D9 00                       .
        .byte   $22                             ; 89DA 22                       "
        bpl     L89FD                           ; 89DB 10 20                    . 
        cpy     L0000                           ; 89DD C4 00                    ..
L89DF:  tya                                     ; 89DF 98                       .
        .byte   $FF                             ; 89E0 FF                       .
        pha                                     ; 89E1 48                       H
        jsr     L2019                           ; 89E2 20 19 20                  . 
        sta     L0400,y                         ; 89E5 99 00 04                 ...
        .byte   $80                             ; 89E8 80                       .
        brk                                     ; 89E9 00                       .
        brk                                     ; 89EA 00                       .
        txa                                     ; 89EB 8A                       .
        php                                     ; 89EC 08                       .
        brk                                     ; 89ED 00                       .
        brk                                     ; 89EE 00                       .
        brk                                     ; 89EF 00                       .
        php                                     ; 89F0 08                       .
        clc                                     ; 89F1 18                       .
        php                                     ; 89F2 08                       .
        brk                                     ; 89F3 00                       .
        php                                     ; 89F4 08                       .
        pha                                     ; 89F5 48                       H
        brk                                     ; 89F6 00                       .
        .byte   $04                             ; 89F7 04                       .
        brk                                     ; 89F8 00                       .
        asl     $2A,x                           ; 89F9 16 2A                    .*
        .byte   $03                             ; 89FB 03                       .
        brk                                     ; 89FC 00                       .
L89FD:  eor     (L0000,x)                       ; 89FD 41 00                    A.
        cpy     #$00                            ; 89FF C0 00                    ..
        ora     ($01,x)                         ; 8A01 01 01                    ..
        .byte   $02                             ; 8A03 02                       .
        .byte   $03                             ; 8A04 03                       .
        .byte   $03                             ; 8A05 03                       .
        .byte   $04                             ; 8A06 04                       .
        .byte   $04                             ; 8A07 04                       .
        ora     $05                             ; 8A08 05 05                    ..
        ora     $05                             ; 8A0A 05 05                    ..
        asl     $09                             ; 8A0C 06 09                    ..
        asl     a                               ; 8A0E 0A                       .
        .byte   $0B                             ; 8A0F 0B                       .
        .byte   $0B                             ; 8A10 0B                       .
        .byte   $0C                             ; 8A11 0C                       .
        .byte   $0C                             ; 8A12 0C                       .
        .byte   $0C                             ; 8A13 0C                       .
        .byte   $0C                             ; 8A14 0C                       .
        ora     L0D0D                           ; 8A15 0D 0D 0D                 ...
        asl     $0E0E                           ; 8A18 0E 0E 0E                 ...
        asl     $0F0E                           ; 8A1B 0E 0E 0F                 ...
        bpl     L8A31                           ; 8A1E 10 11                    ..
        ora     ($11),y                         ; 8A20 11 11                    ..
        .byte   $12                             ; 8A22 12                       .
        .byte   $12                             ; 8A23 12                       .
        .byte   $12                             ; 8A24 12                       .
        .byte   $13                             ; 8A25 13                       .
        .byte   $13                             ; 8A26 13                       .
        .byte   $13                             ; 8A27 13                       .
        .byte   $14                             ; 8A28 14                       .
        ora     $15,x                           ; 8A29 15 15                    ..
        ora     $15,x                           ; 8A2B 15 15                    ..
        asl     $16,x                           ; 8A2D 16 16                    ..
        .byte   $16                             ; 8A2F 16                       .
L8A30:  .byte   $16                             ; 8A30 16                       .
L8A31:  asl     $18,x                           ; 8A31 16 18                    ..
        clc                                     ; 8A33 18                       .
        clc                                     ; 8A34 18                       .
        .byte   $19                             ; 8A35 19                       .
        .byte   $1A                             ; 8A36 1A                       .
L8A37:  .byte   $1A                             ; 8A37 1A                       .
        .byte   $1A                             ; 8A38 1A                       .
        .byte   $1C                             ; 8A39 1C                       .
        .byte   $FF                             ; 8A3A FF                       .
L8A3B:  bpl     L8A3D                           ; 8A3B 10 00                    ..
L8A3D:  .byte   $EB                             ; 8A3D EB                       .
        .byte   $02                             ; 8A3E 02                       .
        bcc     L8A41                           ; 8A3F 90 00                    ..
L8A41:  brk                                     ; 8A41 00                       .
        php                                     ; 8A42 08                       .
        brk                                     ; 8A43 00                       .
        brk                                     ; 8A44 00                       .
        brk                                     ; 8A45 00                       .
        brk                                     ; 8A46 00                       .
        brk                                     ; 8A47 00                       .
        brk                                     ; 8A48 00                       .
        sty     L0080                           ; 8A49 84 80                    ..
        bpl     L8A4D                           ; 8A4B 10 00                    ..
L8A4D:  eor     (L0000),y                       ; 8A4D 51 00                    Q.
        eor     (L0000,x)                       ; 8A4F 41 00                    A.
        brk                                     ; 8A51 00                       .
        brk                                     ; 8A52 00                       .
        brk                                     ; 8A53 00                       .
        brk                                     ; 8A54 00                       .
        bvc     L89DF                           ; 8A55 50 88                    P.
        brk                                     ; 8A57 00                       .
L8A58:  php                                     ; 8A58 08                       .
        php                                     ; 8A59 08                       .
        php                                     ; 8A5A 08                       .
        php                                     ; 8A5B 08                       .
        .byte   $80                             ; 8A5C 80                       .
        sec                                     ; 8A5D 38                       8
        php                                     ; 8A5E 08                       .
        bcc     L8A61                           ; 8A5F 90 00                    ..
L8A61:  jsr     L0080                           ; 8A61 20 80 00                  ..
        brk                                     ; 8A64 00                       .
        brk                                     ; 8A65 00                       .
        brk                                     ; 8A66 00                       .
        jsr     L1708                           ; 8A67 20 08 17                  ..
        ldy     #$57                            ; 8A6A A0 57                    .W
        .byte   $80                             ; 8A6C 80                       .
        brk                                     ; 8A6D 00                       .
        php                                     ; 8A6E 08                       .
        rti                                     ; 8A6F 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8A70 00                       .
L8A71:  .byte   $03                             ; 8A71 03                       .
        php                                     ; 8A72 08                       .
        stx     L0000                           ; 8A73 86 00                    ..
        brk                                     ; 8A75 00                       .
        php                                     ; 8A76 08                       .
        ora     $08                             ; 8A77 05 08                    ..
        .byte   $02                             ; 8A79 02                       .
        brk                                     ; 8A7A 00                       .
        brk                                     ; 8A7B 00                       .
        .byte   $80                             ; 8A7C 80                       .
        .byte   $82                             ; 8A7D 82                       .
        ldy     #$04                            ; 8A7E A0 04                    ..
        brk                                     ; 8A80 00                       .
        jsr     L70E0                           ; 8A81 20 E0 70                  .p
        ora     ($A8,x)                         ; 8A84 01 A8                    ..
        cli                                     ; 8A86 58                       X
        cmp     ($70,x)                         ; 8A87 C1 70                    .p
        bcc     L8A3B                           ; 8A89 90 B0                    ..
        bne     L8A71                           ; 8A8B D0 E4                    ..
L8A8D:  brk                                     ; 8A8D 00                       .
        bmi     L8A30                           ; 8A8E 30 A0                    0.
        .byte   $FF                             ; 8A90 FF                       .
        rti                                     ; 8A91 40                       @

; ----------------------------------------------------------------------------
L8A92:  rts                                     ; 8A92 60                       `

; ----------------------------------------------------------------------------
        ldy     #$F0                            ; 8A93 A0 F0                    ..
L8A95:  bvc     L8A37                           ; 8A95 50 A0                    P.
        .byte   $AF                             ; 8A97 AF                       .
        bpl     L8ACA                           ; 8A98 10 30                    .0
        cli                                     ; 8A9A 58                       X
        .byte   $80                             ; 8A9B 80                       .
        cpy     #$60                            ; 8A9C C0 60                    .`
        brk                                     ; 8A9E 00                       .
        brk                                     ; 8A9F 00                       .
        brk                                     ; 8AA0 00                       .
        jsr     L5400                           ; 8AA1 20 00 54                  .T
        clv                                     ; 8AA4 B8                       .
        bcs     L8A58                           ; 8AA5 B0 B1                    ..
        bne     L8AA9                           ; 8AA7 D0 00                    ..
L8AA9:  bpl     L8B1B                           ; 8AA9 10 70                    .p
        bne     L8A8D                           ; 8AAB D0 E0                    ..
        jsr     LD1D0                           ; 8AAD 20 D0 D1                  ..
        .byte   $D2                             ; 8AB0 D2                       .
        beq     L8B03                           ; 8AB1 F0 50                    .P
        bcs     L8A95                           ; 8AB3 B0 E0                    ..
L8AB5:  bmi     L8AC7                           ; 8AB5 30 10                    0.
        rti                                     ; 8AB7 40                       @

; ----------------------------------------------------------------------------
        bvs     L8A92                           ; 8AB8 70 D8                    p.
        .byte   $FF                             ; 8ABA FF                       .
        brk                                     ; 8ABB 00                       .
        brk                                     ; 8ABC 00                       .
        brk                                     ; 8ABD 00                       .
        brk                                     ; 8ABE 00                       .
        rti                                     ; 8ABF 40                       @

; ----------------------------------------------------------------------------
        php                                     ; 8AC0 08                       .
        bpl     L8AC3                           ; 8AC1 10 00                    ..
L8AC3:  ora     (L0000,x)                       ; 8AC3 01 00                    ..
        ora     ($02,x)                         ; 8AC5 01 02                    ..
L8AC7:  ora     (L0000,x)                       ; 8AC7 01 00                    ..
        .byte   $B4                             ; 8AC9 B4                       .
L8ACA:  brk                                     ; 8ACA 00                       .
        jsr     L1400                           ; 8ACB 20 00 14                  ..
        brk                                     ; 8ACE 00                       .
        .byte   $1C                             ; 8ACF 1C                       .
        brk                                     ; 8AD0 00                       .
L8AD1:  pha                                     ; 8AD1 48                       H
        .byte   $82                             ; 8AD2 82                       .
L8AD3:  brk                                     ; 8AD3 00                       .
        .byte   $80                             ; 8AD4 80                       .
        rti                                     ; 8AD5 40                       @

; ----------------------------------------------------------------------------
        jsr     L0000                           ; 8AD6 20 00 00                  ..
        brk                                     ; 8AD9 00                       .
        jsr     L8010                           ; 8ADA 20 10 80                  ..
        jsr     L5A00                           ; 8ADD 20 00 5A                  .Z
        brk                                     ; 8AE0 00                       .
        bpl     L8AE3                           ; 8AE1 10 00                    ..
L8AE3:  .byte   $80                             ; 8AE3 80                       .
        .byte   $02                             ; 8AE4 02                       .
        .byte   $14                             ; 8AE5 14                       .
        brk                                     ; 8AE6 00                       .
        .byte   $03                             ; 8AE7 03                       .
        brk                                     ; 8AE8 00                       .
        rti                                     ; 8AE9 40                       @

; ----------------------------------------------------------------------------
        jsr     L0040                           ; 8AEA 20 40 00                  @.
        rts                                     ; 8AED 60                       `

; ----------------------------------------------------------------------------
        jsr     L8020                           ; 8AEE 20 20 80                   .
        plp                                     ; 8AF1 28                       (
        brk                                     ; 8AF2 00                       .
        .byte   $97                             ; 8AF3 97                       .
        ldy     #$40                            ; 8AF4 A0 40                    .@
        php                                     ; 8AF6 08                       .
        brk                                     ; 8AF7 00                       .
        asl     a                               ; 8AF8 0A                       .
        php                                     ; 8AF9 08                       .
        jsr     L0042                           ; 8AFA 20 42 00                  B.
        .byte   $02                             ; 8AFD 02                       .
        php                                     ; 8AFE 08                       .
        .byte   $80                             ; 8AFF 80                       .
        brk                                     ; 8B00 00                       .
        ldy     $94                             ; 8B01 A4 94                    ..
L8B03:  ldy     $94,x                           ; 8B03 B4 94                    ..
        .byte   $64                             ; 8B05 64                       d
        sty     $98,x                           ; 8B06 94 98                    ..
        .byte   $80                             ; 8B08 80                       .
        pha                                     ; 8B09 48                       H
        pla                                     ; 8B0A 68                       h
        bcs     L8AB5                           ; 8B0B B0 A8                    ..
        brk                                     ; 8B0D 00                       .
        tya                                     ; 8B0E 98                       .
        tya                                     ; 8B0F 98                       .
        sei                                     ; 8B10 78                       x
        clv                                     ; 8B11 B8                       .
        clc                                     ; 8B12 18                       .
L8B13:  tay                                     ; 8B13 A8                       .
        tay                                     ; 8B14 A8                       .
        plp                                     ; 8B15 28                       (
        sec                                     ; 8B16 38                       8
L8B17:  tya                                     ; 8B17 98                       .
        pha                                     ; 8B18 48                       H
        pha                                     ; 8B19 48                       H
        sei                                     ; 8B1A 78                       x
L8B1B:  sei                                     ; 8B1B 78                       x
        rti                                     ; 8B1C 40                       @

; ----------------------------------------------------------------------------
        sei                                     ; 8B1D 78                       x
        brk                                     ; 8B1E 00                       .
        brk                                     ; 8B1F 00                       .
        brk                                     ; 8B20 00                       .
        bcs     L8B23                           ; 8B21 B0 00                    ..
L8B23:  .byte   $80                             ; 8B23 80                       .
        clv                                     ; 8B24 B8                       .
        bcs     L8B87                           ; 8B25 B0 60                    .`
        clv                                     ; 8B27 B8                       .
        brk                                     ; 8B28 00                       .
        bcs     L8AD3                           ; 8B29 B0 A8                    ..
        tya                                     ; 8B2B 98                       .
        tay                                     ; 8B2C A8                       .
        ldy     L0080,x                         ; 8B2D B4 80                    ..
        bcc     L8AD1                           ; 8B2F 90 A0                    ..
        bcs     L8B13                           ; 8B31 B0 E0                    ..
        cpx     #$B0                            ; 8B33 E0 B0                    ..
        bcc     L8B17                           ; 8B35 90 E0                    ..
        cpx     #$E0                            ; 8B37 E0 E0                    ..
        brk                                     ; 8B39 00                       .
        .byte   $FF                             ; 8B3A FF                       .
        php                                     ; 8B3B 08                       .
        .byte   $02                             ; 8B3C 02                       .
        brk                                     ; 8B3D 00                       .
        .byte   $80                             ; 8B3E 80                       .
        brk                                     ; 8B3F 00                       .
        brk                                     ; 8B40 00                       .
        php                                     ; 8B41 08                       .
        brk                                     ; 8B42 00                       .
        pha                                     ; 8B43 48                       H
        brk                                     ; 8B44 00                       .
        rti                                     ; 8B45 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; 8B46 80                       .
        ldy     #$00                            ; 8B47 A0 00                    ..
        jsr     L0E00                           ; 8B49 20 00 0E                  ..
        brk                                     ; 8B4C 00                       .
        brk                                     ; 8B4D 00                       .
        .byte   $02                             ; 8B4E 02                       .
        and     (L0080,x)                       ; 8B4F 21 80                    !.
        .byte   $80                             ; 8B51 80                       .
        brk                                     ; 8B52 00                       .
        .byte   $02                             ; 8B53 02                       .
        .byte   $02                             ; 8B54 02                       .
        ora     (L0000,x)                       ; 8B55 01 00                    ..
        rti                                     ; 8B57 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8B58 00                       .
        bmi     L8B5B                           ; 8B59 30 00                    0.
L8B5B:  sta     ($02,x)                         ; 8B5B 81 02                    ..
        bcc     L8B5F                           ; 8B5D 90 00                    ..
L8B5F:  .byte   $20                             ; 8B5F 20                        
        brk                                     ; 8B60 00                       .
L8B61:  ora     (L0000),y                       ; 8B61 11 00                    ..
        .byte   $12                             ; 8B63 12                       .
        .byte   $02                             ; 8B64 02                       .
        .byte   $04                             ; 8B65 04                       .
        brk                                     ; 8B66 00                       .
        bpl     L8BA9                           ; 8B67 10 40                    .@
        .byte   $80                             ; 8B69 80                       .
        brk                                     ; 8B6A 00                       .
        bmi     L8B6D                           ; 8B6B 30 00                    0.
L8B6D:  php                                     ; 8B6D 08                       .
        .byte   $02                             ; 8B6E 02                       .
        brk                                     ; 8B6F 00                       .
        brk                                     ; 8B70 00                       .
        .byte   $80                             ; 8B71 80                       .
        brk                                     ; 8B72 00                       .
        brk                                     ; 8B73 00                       .
        plp                                     ; 8B74 28                       (
        jsr     L01A0                           ; 8B75 20 A0 01                  ..
        php                                     ; 8B78 08                       .
        brk                                     ; 8B79 00                       .
        brk                                     ; 8B7A 00                       .
        plp                                     ; 8B7B 28                       (
        brk                                     ; 8B7C 00                       .
        bpl     L8B7F                           ; 8B7D 10 00                    ..
L8B7F:  sty     $D3,x                           ; 8B7F 94 D3                    ..
        .byte   $04                             ; 8B81 04                       .
        .byte   $04                             ; 8B82 04                       .
        .byte   $04                             ; 8B83 04                       .
        .byte   $04                             ; 8B84 04                       .
        .byte   $04                             ; 8B85 04                       .
        .byte   $04                             ; 8B86 04                       .
L8B87:  sty     $08                             ; 8B87 84 08                    ..
        .byte   $34                             ; 8B89 34                       4
        .byte   $34                             ; 8B8A 34                       4
L8B8B:  php                                     ; 8B8B 08                       .
        .byte   $4C                             ; 8B8C 4C                       L
        .byte   $D5                             ; 8B8D D5                       .
L8B8E:  sta     ($32,x)                         ; 8B8E 81 32                    .2
        .byte   $32                             ; 8B90 32                       2
        .byte   $32                             ; 8B91 32                       2
        ora     $3232                           ; 8B92 0D 32 32                 .22
        .byte   $32                             ; 8B95 32                       2
        .byte   $32                             ; 8B96 32                       2
        .byte   $32                             ; 8B97 32                       2
        .byte   $32                             ; 8B98 32                       2
        .byte   $32                             ; 8B99 32                       2
        .byte   $32                             ; 8B9A 32                       2
        .byte   $32                             ; 8B9B 32                       2
        ora     $DF80                           ; 8B9C 0D 80 DF                 ...
        .byte   $D2                             ; 8B9F D2                       .
        sbc     ($1B,x)                         ; 8BA0 E1 1B                    ..
        cpx     #$1B                            ; 8BA2 E0 1B                    ..
        stx     $0808                           ; 8BA4 8E 08 08                 ...
        .byte   $83                             ; 8BA7 83                       .
        .byte   $E2                             ; 8BA8 E2                       .
L8BA9:  .byte   $37                             ; 8BA9 37                       7
        .byte   $37                             ; 8BAA 37                       7
        .byte   $37                             ; 8BAB 37                       7
        .byte   $37                             ; 8BAC 37                       7
        .byte   $0C                             ; 8BAD 0C                       .
        .byte   $37                             ; 8BAE 37                       7
        .byte   $37                             ; 8BAF 37                       7
        .byte   $37                             ; 8BB0 37                       7
        .byte   $37                             ; 8BB1 37                       7
        bpl     L8BC4                           ; 8BB2 10 10                    ..
        asl     $16,x                           ; 8BB4 16 16                    ..
        bpl     L8BC8                           ; 8BB6 10 10                    ..
        bpl     L8C22                           ; 8BB8 10 68                    .h
        .byte   $FF                             ; 8BBA FF                       .
        .byte   $80                             ; 8BBB 80                       .
        plp                                     ; 8BBC 28                       (
        brk                                     ; 8BBD 00                       .
        php                                     ; 8BBE 08                       .
        tya                                     ; 8BBF 98                       .
        jsr     L0000                           ; 8BC0 20 00 00                  ..
        .byte   $80                             ; 8BC3 80                       .
L8BC4:  jsr     L8001                           ; 8BC4 20 01 80                  ..
        .byte   $04                             ; 8BC7 04                       .
L8BC8:  .byte   $80                             ; 8BC8 80                       .
        brk                                     ; 8BC9 00                       .
        brk                                     ; 8BCA 00                       .
        rti                                     ; 8BCB 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8BCC 00                       .
        php                                     ; 8BCD 08                       .
        .byte   $80                             ; 8BCE 80                       .
        brk                                     ; 8BCF 00                       .
        php                                     ; 8BD0 08                       .
        .byte   $12                             ; 8BD1 12                       .
        brk                                     ; 8BD2 00                       .
        brk                                     ; 8BD3 00                       .
        brk                                     ; 8BD4 00                       .
        .byte   $02                             ; 8BD5 02                       .
        brk                                     ; 8BD6 00                       .
        ora     (L0080,x)                       ; 8BD7 01 80                    ..
        brk                                     ; 8BD9 00                       .
        php                                     ; 8BDA 08                       .
        .byte   $04                             ; 8BDB 04                       .
        brk                                     ; 8BDC 00                       .
        php                                     ; 8BDD 08                       .
        dey                                     ; 8BDE 88                       .
        bcc     L8B61                           ; 8BDF 90 80                    ..
        bpl     L8B8B                           ; 8BE1 10 A8                    ..
        brk                                     ; 8BE3 00                       .
        brk                                     ; 8BE4 00                       .
        jsr     L0000                           ; 8BE5 20 00 00                  ..
        brk                                     ; 8BE8 00                       .
        ora     (L0000),y                       ; 8BE9 11 00                    ..
        brk                                     ; 8BEB 00                       .
        brk                                     ; 8BEC 00                       .
        brk                                     ; 8BED 00                       .
        brk                                     ; 8BEE 00                       .
        rti                                     ; 8BEF 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; 8BF0 80                       .
        brk                                     ; 8BF1 00                       .
        .byte   $82                             ; 8BF2 82                       .
        jsr     L3000                           ; 8BF3 20 00 30                  .0
        jsr     L20A1                           ; 8BF6 20 A1 20                  . 
        pla                                     ; 8BF9 68                       h
        brk                                     ; 8BFA 00                       .
        .byte   $02                             ; 8BFB 02                       .
        .byte   $02                             ; 8BFC 02                       .
        ora     ($82,x)                         ; 8BFD 01 82                    ..
        .byte   $44                             ; 8BFF 44                       D
        brk                                     ; 8C00 00                       .
        ora     ($03,x)                         ; 8C01 01 03                    ..
        .byte   $04                             ; 8C03 04                       .
        asl     $08                             ; 8C04 06 08                    ..
        .byte   $0C                             ; 8C06 0C                       .
        ora     L0D0D                           ; 8C07 0D 0D 0D                 ...
        asl     $110F                           ; 8C0A 0E 0F 11                 ...
        ora     $18,x                           ; 8C0D 15 18                    ..
        ora     $1F1E,x                         ; 8C0F 1D 1E 1F                 ...
L8C12:  .byte   $22                             ; 8C12 22                       "
        and     $28                             ; 8C13 25 28                    %(
        and     #$2D                            ; 8C15 29 2D                    )-
        .byte   $32                             ; 8C17 32                       2
        .byte   $32                             ; 8C18 32                       2
        and     $36,x                           ; 8C19 35 36                    56
        and     $0439,y                         ; 8C1B 39 39 04                 99.
        brk                                     ; 8C1E 00                       .
        brk                                     ; 8C1F 00                       .
        brk                                     ; 8C20 00                       .
        brk                                     ; 8C21 00                       .
L8C22:  brk                                     ; 8C22 00                       .
        brk                                     ; 8C23 00                       .
        brk                                     ; 8C24 00                       .
        brk                                     ; 8C25 00                       .
        brk                                     ; 8C26 00                       .
        brk                                     ; 8C27 00                       .
        brk                                     ; 8C28 00                       .
        brk                                     ; 8C29 00                       .
        bpl     L8C2C                           ; 8C2A 10 00                    ..
L8C2C:  brk                                     ; 8C2C 00                       .
        brk                                     ; 8C2D 00                       .
        brk                                     ; 8C2E 00                       .
        brk                                     ; 8C2F 00                       .
        jsr     L0000                           ; 8C30 20 00 00                  ..
        brk                                     ; 8C33 00                       .
        ora     (L0000,x)                       ; 8C34 01 00                    ..
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
        rti                                     ; 8C50 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8C51 00                       .
        brk                                     ; 8C52 00                       .
        brk                                     ; 8C53 00                       .
        brk                                     ; 8C54 00                       .
        brk                                     ; 8C55 00                       .
        .byte   $04                             ; 8C56 04                       .
        brk                                     ; 8C57 00                       .
        brk                                     ; 8C58 00                       .
        brk                                     ; 8C59 00                       .
        brk                                     ; 8C5A 00                       .
        brk                                     ; 8C5B 00                       .
        brk                                     ; 8C5C 00                       .
        brk                                     ; 8C5D 00                       .
        .byte   $80                             ; 8C5E 80                       .
        brk                                     ; 8C5F 00                       .
        brk                                     ; 8C60 00                       .
        brk                                     ; 8C61 00                       .
        brk                                     ; 8C62 00                       .
        brk                                     ; 8C63 00                       .
        rti                                     ; 8C64 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8C65 00                       .
        brk                                     ; 8C66 00                       .
        brk                                     ; 8C67 00                       .
        .byte   $80                             ; 8C68 80                       .
        brk                                     ; 8C69 00                       .
        brk                                     ; 8C6A 00                       .
        brk                                     ; 8C6B 00                       .
        brk                                     ; 8C6C 00                       .
        cpy     #$00                            ; 8C6D C0 00                    ..
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
        ora     (L0000,x)                       ; 8C7D 01 00                    ..
        ora     (L0000,x)                       ; 8C7F 01 00                    ..
        .byte   $04                             ; 8C81 04                       .
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
L8C91:  brk                                     ; 8C91 00                       .
        brk                                     ; 8C92 00                       .
        brk                                     ; 8C93 00                       .
        rti                                     ; 8C94 40                       @

; ----------------------------------------------------------------------------
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
        .byte   $02                             ; 8CB8 02                       .
        .byte   $04                             ; 8CB9 04                       .
        brk                                     ; 8CBA 00                       .
        brk                                     ; 8CBB 00                       .
        brk                                     ; 8CBC 00                       .
        brk                                     ; 8CBD 00                       .
        rti                                     ; 8CBE 40                       @

; ----------------------------------------------------------------------------
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
        bvc     L8CE7                           ; 8CE5 50 00                    P.
L8CE7:  brk                                     ; 8CE7 00                       .
        brk                                     ; 8CE8 00                       .
        brk                                     ; 8CE9 00                       .
        brk                                     ; 8CEA 00                       .
        brk                                     ; 8CEB 00                       .
        brk                                     ; 8CEC 00                       .
        brk                                     ; 8CED 00                       .
        php                                     ; 8CEE 08                       .
        ora     ($02,x)                         ; 8CEF 01 02                    ..
        brk                                     ; 8CF1 00                       .
        rti                                     ; 8CF2 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8CF3 00                       .
        brk                                     ; 8CF4 00                       .
        rti                                     ; 8CF5 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8CF6 00                       .
        rti                                     ; 8CF7 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8CF8 00                       .
        brk                                     ; 8CF9 00                       .
        brk                                     ; 8CFA 00                       .
        brk                                     ; 8CFB 00                       .
        brk                                     ; 8CFC 00                       .
        brk                                     ; 8CFD 00                       .
        ora     (L0040,x)                       ; 8CFE 01 40                    .@
        brk                                     ; 8D00 00                       .
        .byte   $03                             ; 8D01 03                       .
        .byte   $82                             ; 8D02 82                       .
        .byte   $82                             ; 8D03 82                       .
        stx     $70                             ; 8D04 86 70                    .p
        .byte   $73                             ; 8D06 73                       s
        .byte   $03                             ; 8D07 03                       .
        .byte   $03                             ; 8D08 03                       .
        sta     ($93),y                         ; 8D09 91 93                    ..
        sta     $97,x                           ; 8D0B 95 97                    ..
        rts                                     ; 8D0D 60                       `

; ----------------------------------------------------------------------------
        .byte   $63                             ; 8D0E 63                       c
        adc     $03                             ; 8D0F 65 03                    e.
        lda     ($B3),y                         ; 8D11 B1 B3                    ..
        lda     $03,x                           ; 8D13 B5 03                    ..
        cpy     $01CE                           ; 8D15 CC CE 01                 ...
        .byte   $03                             ; 8D18 03                       .
        cmp     ($D3),y                         ; 8D19 D1 D3                    ..
        cmp     $AC,x                           ; 8D1B D5 AC                    ..
        ldx     a:L0000                         ; 8D1D AE 00 00                 ...
        ora     ($F1,x)                         ; 8D20 01 F1                    ..
        .byte   $F3                             ; 8D22 F3                       .
        .byte   $03                             ; 8D23 03                       .
        ldy     $20BE,x                         ; 8D24 BC BE 20                 .. 
        .byte   $22                             ; 8D27 22                       "
        .byte   $12                             ; 8D28 12                       .
        .byte   $12                             ; 8D29 12                       .
        .byte   $EB                             ; 8D2A EB                       .
        ora     ($EF,x)                         ; 8D2B 01 EF                    ..
        sbc     $4240                           ; 8D2D ED 40 42                 .@B
        bpl     L8D42                           ; 8D30 10 10                    ..
        asl     a                               ; 8D32 0A                       .
        asl     a                               ; 8D33 0A                       .
        brk                                     ; 8D34 00                       .
        .byte   $54                             ; 8D35 54                       T
        brk                                     ; 8D36 00                       .
        asl     $1212                           ; 8D37 0E 12 12                 ...
        bpl     L8D3C                           ; 8D3A 10 00                    ..
L8D3C:  .byte   $BB                             ; 8D3C BB                       .
        lsr     $C9,x                           ; 8D3D 56 C9                    V.
        sbc     #$00                            ; 8D3F E9 00                    ..
        .byte   $10                             ; 8D41 10                       .
L8D42:  jsr     L0022                           ; 8D42 20 22 00                  ".
        brk                                     ; 8D45 00                       .
        .byte   $12                             ; 8D46 12                       .
        .byte   $12                             ; 8D47 12                       .
        .byte   $12                             ; 8D48 12                       .
        .byte   $12                             ; 8D49 12                       .
        rti                                     ; 8D4A 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; 8D4B 42                       B
        jsr     L4222                           ; 8D4C 20 22 42                  "B
        brk                                     ; 8D4F 00                       .
        .byte   $04                             ; 8D50 04                       .
        brk                                     ; 8D51 00                       .
        bit     $2A2E                           ; 8D52 2C 2E 2A                 ,.*
        .byte   $0C                             ; 8D55 0C                       .
        lsr     a                               ; 8D56 4A                       J
        brk                                     ; 8D57 00                       .
        .byte   $14                             ; 8D58 14                       .
        ora     $4C,x                           ; 8D59 15 4C                    .L
        lsr     L86EB                           ; 8D5B 4E EB 86                 N..
L8D5E:  plp                                     ; 8D5E 28                       (
        ror     $70                             ; 8D5F 66 70                    fp
        .byte   $72                             ; 8D61 72                       r
        cli                                     ; 8D62 58                       X
        .byte   $5A                             ; 8D63 5A                       Z
        .byte   $5A                             ; 8D64 5A                       Z
        sei                                     ; 8D65 78                       x
        .byte   $7B                             ; 8D66 7B                       {
        jmp     (L986E)                         ; 8D67 6C 6E 98                 ln.

; ----------------------------------------------------------------------------
        txs                                     ; 8D6A 9A                       .
        sei                                     ; 8D6B 78                       x
        sei                                     ; 8D6C 78                       x
        pha                                     ; 8D6D 48                       H
        eor     #$00                            ; 8D6E 49 00                    I.
        brk                                     ; 8D70 00                       .
        brk                                     ; 8D71 00                       .
        brk                                     ; 8D72 00                       .
        nop                                     ; 8D73 EA                       .
        asl     $36                             ; 8D74 06 36                    .6
        stx     $0467                           ; 8D76 8E 67 04                 .g.
        ora     $1A,x                           ; 8D79 15 1A                    ..
        brk                                     ; 8D7B 00                       .
        .byte   $27                             ; 8D7C 27                       '
        .byte   $02                             ; 8D7D 02                       .
        brk                                     ; 8D7E 00                       .
        sbc     $4A09,y                         ; 8D7F F9 09 4A                 ..J
        bit     $25                             ; 8D82 24 25                    $%
        and     L0000                           ; 8D84 25 00                    %.
        sta     $CBBB,x                         ; 8D86 9D BB CB                 ...
        brk                                     ; 8D89 00                       .
        .byte   $CF                             ; 8D8A CF                       .
        brk                                     ; 8D8B 00                       .
        .byte   $EE                             ; 8D8C EE                       .
L8D8D:  brk                                     ; 8D8D 00                       .
L8D8E:  ora     ($03,x)                         ; 8D8E 01 03                    ..
        cpy     $585A                           ; 8D90 CC 5A 58                 .ZX
        .byte   $5A                             ; 8D93 5A                       Z
        .byte   $5A                             ; 8D94 5A                       Z
        sbc     #$F8                            ; 8D95 E9 F8                    ..
        brk                                     ; 8D97 00                       .
        asl     $2220                           ; 8D98 0E 20 22                 . "
        rti                                     ; 8D9B 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; 8D9C 42                       B
        lda     (L0000,x)                       ; 8D9D A1 00                    ..
        .byte   $DB                             ; 8D9F DB                       .
        brk                                     ; 8DA0 00                       .
        brk                                     ; 8DA1 00                       .
        brk                                     ; 8DA2 00                       .
        .byte   $F7                             ; 8DA3 F7                       .
        brk                                     ; 8DA4 00                       .
        .byte   $F7                             ; 8DA5 F7                       .
        brk                                     ; 8DA6 00                       .
        brk                                     ; 8DA7 00                       .
        brk                                     ; 8DA8 00                       .
        iny                                     ; 8DA9 C8                       .
        cmp     #$00                            ; 8DAA C9 00                    ..
        brk                                     ; 8DAC 00                       .
        brk                                     ; 8DAD 00                       .
        brk                                     ; 8DAE 00                       .
        brk                                     ; 8DAF 00                       .
        brk                                     ; 8DB0 00                       .
        nop                                     ; 8DB1 EA                       .
        nop                                     ; 8DB2 EA                       .
        brk                                     ; 8DB3 00                       .
        brk                                     ; 8DB4 00                       .
        brk                                     ; 8DB5 00                       .
        brk                                     ; 8DB6 00                       .
        brk                                     ; 8DB7 00                       .
        nop                                     ; 8DB8 EA                       .
        adc     a:$7F,x                         ; 8DB9 7D 7F 00                 }..
        nop                                     ; 8DBC EA                       .
        brk                                     ; 8DBD 00                       .
        brk                                     ; 8DBE 00                       .
        brk                                     ; 8DBF 00                       .
        nop                                     ; 8DC0 EA                       .
        nop                                     ; 8DC1 EA                       .
        brk                                     ; 8DC2 00                       .
        nop                                     ; 8DC3 EA                       .
L8DC4:  rts                                     ; 8DC4 60                       `

; ----------------------------------------------------------------------------
        nop                                     ; 8DC5 EA                       .
        dex                                     ; 8DC6 CA                       .
        nop                                     ; 8DC7 EA                       .
        nop                                     ; 8DC8 EA                       .
        pla                                     ; 8DC9 68                       h
        brk                                     ; 8DCA 00                       .
        nop                                     ; 8DCB EA                       .
        brk                                     ; 8DCC 00                       .
        nop                                     ; 8DCD EA                       .
        nop                                     ; 8DCE EA                       .
        brk                                     ; 8DCF 00                       .
        brk                                     ; 8DD0 00                       .
        brk                                     ; 8DD1 00                       .
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
        nop                                     ; 8DE0 EA                       .
        nop                                     ; 8DE1 EA                       .
        brk                                     ; 8DE2 00                       .
        nop                                     ; 8DE3 EA                       .
        rts                                     ; 8DE4 60                       `

; ----------------------------------------------------------------------------
        nop                                     ; 8DE5 EA                       .
        dex                                     ; 8DE6 CA                       .
        nop                                     ; 8DE7 EA                       .
        nop                                     ; 8DE8 EA                       .
        pla                                     ; 8DE9 68                       h
        brk                                     ; 8DEA 00                       .
        nop                                     ; 8DEB EA                       .
L8DEC:  brk                                     ; 8DEC 00                       .
        nop                                     ; 8DED EA                       .
        nop                                     ; 8DEE EA                       .
        brk                                     ; 8DEF 00                       .
        brk                                     ; 8DF0 00                       .
        brk                                     ; 8DF1 00                       .
        brk                                     ; 8DF2 00                       .
        brk                                     ; 8DF3 00                       .
        brk                                     ; 8DF4 00                       .
        brk                                     ; 8DF5 00                       .
        brk                                     ; 8DF6 00                       .
        brk                                     ; 8DF7 00                       .
        nop                                     ; 8DF8 EA                       .
        cli                                     ; 8DF9 58                       X
        brk                                     ; 8DFA 00                       .
        nop                                     ; 8DFB EA                       .
        nop                                     ; 8DFC EA                       .
        nop                                     ; 8DFD EA                       .
        nop                                     ; 8DFE EA                       .
        nop                                     ; 8DFF EA                       .
        brk                                     ; 8E00 00                       .
        .byte   $03                             ; 8E01 03                       .
        .byte   $83                             ; 8E02 83                       .
        .byte   $83                             ; 8E03 83                       .
        .byte   $87                             ; 8E04 87                       .
        adc     ($74),y                         ; 8E05 71 74                    qt
        .byte   $03                             ; 8E07 03                       .
        .byte   $03                             ; 8E08 03                       .
        .byte   $92                             ; 8E09 92                       .
        .byte   $03                             ; 8E0A 03                       .
        stx     $03,y                           ; 8E0B 96 03                    ..
        .byte   $74                             ; 8E0D 74                       t
        .byte   $74                             ; 8E0E 74                       t
        brk                                     ; 8E0F 00                       .
        bcs     L8DC4                           ; 8E10 B0 B2                    ..
        ldy     $B6,x                           ; 8E12 B4 B6                    ..
        .byte   $03                             ; 8E14 03                       .
        cmp     $EFCF                           ; 8E15 CD CF EF                 ...
        bne     L8DEC                           ; 8E18 D0 D2                    ..
        .byte   $D4                             ; 8E1A D4                       .
        dec     $AD,x                           ; 8E1B D6 AD                    ..
        .byte   $AF                             ; 8E1D AF                       .
        brk                                     ; 8E1E 00                       .
        brk                                     ; 8E1F 00                       .
        ora     ($F2,x)                         ; 8E20 01 F2                    ..
        .byte   $F4                             ; 8E22 F4                       .
        inc     $BD,x                           ; 8E23 F6 BD                    ..
        .byte   $BF                             ; 8E25 BF                       .
        and     ($23,x)                         ; 8E26 21 23                    !#
        ora     ($11),y                         ; 8E28 11 11                    ..
        ora     ($01,x)                         ; 8E2A 01 01                    ..
        .byte   $03                             ; 8E2C 03                       .
        inc     $4341                           ; 8E2D EE 41 43                 .AC
        ora     ($11),y                         ; 8E30 11 11                    ..
        .byte   $0B                             ; 8E32 0B                       .
        .byte   $0B                             ; 8E33 0B                       .
        .byte   $E7                             ; 8E34 E7                       .
        eor     L0000,x                         ; 8E35 55 00                    U.
        .byte   $0F                             ; 8E37 0F                       .
        ora     ($11),y                         ; 8E38 11 11                    ..
        ora     (L0000),y                       ; 8E3A 11 00                    ..
        brk                                     ; 8E3C 00                       .
        .byte   $57                             ; 8E3D 57                       W
        dex                                     ; 8E3E CA                       .
        brk                                     ; 8E3F 00                       .
        brk                                     ; 8E40 00                       .
        ora     ($21),y                         ; 8E41 11 21                    .!
        .byte   $23                             ; 8E43 23                       #
        brk                                     ; 8E44 00                       .
        brk                                     ; 8E45 00                       .
        .byte   $13                             ; 8E46 13                       .
        .byte   $13                             ; 8E47 13                       .
        .byte   $13                             ; 8E48 13                       .
        .byte   $13                             ; 8E49 13                       .
        eor     ($43,x)                         ; 8E4A 41 43                    AC
        and     ($23,x)                         ; 8E4C 21 23                    !#
        nop                                     ; 8E4E EA                       .
        brk                                     ; 8E4F 00                       .
        ora     L0000                           ; 8E50 05 00                    ..
        and     $2B2F                           ; 8E52 2D 2F 2B                 -/+
        ora     a:$4B                           ; 8E55 0D 4B 00                 .K.
        .byte   $14                             ; 8E58 14                       .
        brk                                     ; 8E59 00                       .
        eor     $014F                           ; 8E5A 4D 4F 01                 MO.
        .byte   $B7                             ; 8E5D B7                       .
        and     #$AF                            ; 8E5E 29 AF                    ).
        adc     ($74),y                         ; 8E60 71 74                    qt
        eor     $5B59,y                         ; 8E62 59 59 5B                 YY[
        adc     $6D7B,y                         ; 8E65 79 7B 6D                 y{m
        .byte   $6F                             ; 8E68 6F                       o
        sta     $799B,y                         ; 8E69 99 9B 79                 ..y
        adc     $4903,y                         ; 8E6C 79 03 49                 y.I
        brk                                     ; 8E6F 00                       .
        ora     L0000,x                         ; 8E70 15 00                    ..
        brk                                     ; 8E72 00                       .
        brk                                     ; 8E73 00                       .
        rol     $36,x                           ; 8E74 36 36                    66
        .byte   $8F                             ; 8E76 8F                       .
        .byte   $67                             ; 8E77 67                       g
        ora     $05                             ; 8E78 05 05                    ..
        .byte   $1B                             ; 8E7A 1B                       .
        brk                                     ; 8E7B 00                       .
        .byte   $02                             ; 8E7C 02                       .
        .byte   $9C                             ; 8E7D 9C                       .
        brk                                     ; 8E7E 00                       .
        sbc     $4B29,y                         ; 8E7F F9 29 4B                 .)K
        .byte   $25                             ; 8E82 25                       %
L8E83:  and     $16                             ; 8E83 25 16                    %.
        brk                                     ; 8E85 00                       .
        .byte   $9E                             ; 8E86 9E                       .
        .byte   $CB                             ; 8E87 CB                       .
        brk                                     ; 8E88 00                       .
        dec     $EDCE                           ; 8E89 CE CE ED                 ...
        sbc     $6464                           ; 8E8C ED 64 64                 .dd
        .byte   $03                             ; 8E8F 03                       .
        cmp     $5959                           ; 8E90 CD 59 59                 .YY
        eor     $F75B,y                         ; 8E93 59 5B F7                 Y[.
        sbc     #$00                            ; 8E96 E9 00                    ..
        .byte   $0F                             ; 8E98 0F                       .
        and     ($23,x)                         ; 8E99 21 23                    !#
        eor     ($43,x)                         ; 8E9B 41 43                    AC
        .byte   $D7                             ; 8E9D D7                       .
        .byte   $DB                             ; 8E9E DB                       .
        brk                                     ; 8E9F 00                       .
        sed                                     ; 8EA0 F8                       .
        brk                                     ; 8EA1 00                       .
        brk                                     ; 8EA2 00                       .
        brk                                     ; 8EA3 00                       .
        .byte   $E7                             ; 8EA4 E7                       .
        .byte   $E7                             ; 8EA5 E7                       .
        brk                                     ; 8EA6 00                       .
        brk                                     ; 8EA7 00                       .
        cmp     $E8D8,y                         ; 8EA8 D9 D8 E8                 ...
        brk                                     ; 8EAB 00                       .
        brk                                     ; 8EAC 00                       .
        brk                                     ; 8EAD 00                       .
        brk                                     ; 8EAE 00                       .
        brk                                     ; 8EAF 00                       .
        nop                                     ; 8EB0 EA                       .
        nop                                     ; 8EB1 EA                       .
        brk                                     ; 8EB2 00                       .
        brk                                     ; 8EB3 00                       .
        brk                                     ; 8EB4 00                       .
        brk                                     ; 8EB5 00                       .
        brk                                     ; 8EB6 00                       .
        brk                                     ; 8EB7 00                       .
        nop                                     ; 8EB8 EA                       .
        nop                                     ; 8EB9 EA                       .
        nop                                     ; 8EBA EA                       .
        nop                                     ; 8EBB EA                       .
        nop                                     ; 8EBC EA                       .
        brk                                     ; 8EBD 00                       .
        brk                                     ; 8EBE 00                       .
        brk                                     ; 8EBF 00                       .
        lda     ($EA,x)                         ; 8EC0 A1 EA                    ..
        nop                                     ; 8EC2 EA                       .
        nop                                     ; 8EC3 EA                       .
        nop                                     ; 8EC4 EA                       .
        nop                                     ; 8EC5 EA                       .
        nop                                     ; 8EC6 EA                       .
        nop                                     ; 8EC7 EA                       .
        cmp     ($EA,x)                         ; 8EC8 C1 EA                    ..
        nop                                     ; 8ECA EA                       .
        brk                                     ; 8ECB 00                       .
        nop                                     ; 8ECC EA                       .
        nop                                     ; 8ECD EA                       .
        nop                                     ; 8ECE EA                       .
        nop                                     ; 8ECF EA                       .
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
        lda     ($EA,x)                         ; 8EE0 A1 EA                    ..
        nop                                     ; 8EE2 EA                       .
        nop                                     ; 8EE3 EA                       .
        nop                                     ; 8EE4 EA                       .
        nop                                     ; 8EE5 EA                       .
        nop                                     ; 8EE6 EA                       .
        nop                                     ; 8EE7 EA                       .
        cmp     ($EA,x)                         ; 8EE8 C1 EA                    ..
        nop                                     ; 8EEA EA                       .
        brk                                     ; 8EEB 00                       .
        nop                                     ; 8EEC EA                       .
        nop                                     ; 8EED EA                       .
        nop                                     ; 8EEE EA                       .
        nop                                     ; 8EEF EA                       .
        brk                                     ; 8EF0 00                       .
        brk                                     ; 8EF1 00                       .
        brk                                     ; 8EF2 00                       .
        brk                                     ; 8EF3 00                       .
        brk                                     ; 8EF4 00                       .
        brk                                     ; 8EF5 00                       .
        brk                                     ; 8EF6 00                       .
        brk                                     ; 8EF7 00                       .
        nop                                     ; 8EF8 EA                       .
        nop                                     ; 8EF9 EA                       .
        nop                                     ; 8EFA EA                       .
        nop                                     ; 8EFB EA                       .
        nop                                     ; 8EFC EA                       .
        nop                                     ; 8EFD EA                       .
        nop                                     ; 8EFE EA                       .
        nop                                     ; 8EFF EA                       .
        brk                                     ; 8F00 00                       .
        bcc     L8E83                           ; 8F01 90 80                    ..
        sty     $86                             ; 8F03 84 86                    ..
        .byte   $73                             ; 8F05 73                       s
        brk                                     ; 8F06 00                       .
        bvs     L8F0C                           ; 8F07 70 03                    p.
        .byte   $03                             ; 8F09 03                       .
        .byte   $A3                             ; 8F0A A3                       .
        .byte   $A5                             ; 8F0B A5                       .
L8F0C:  .byte   $A7                             ; 8F0C A7                       .
        adc     ($65,x)                         ; 8F0D 61 65                    ae
        adc     $03                             ; 8F0F 65 03                    e.
        cmp     ($C3,x)                         ; 8F11 C1 C3                    ..
        cmp     $C7                             ; 8F13 C5 C7                    ..
        .byte   $DC                             ; 8F15 DC                       .
        dec     $0301,x                         ; 8F16 DE 01 03                 ...
        sbc     ($E3,x)                         ; 8F19 E1 E3                    ..
        sbc     $BC                             ; 8F1B E5 BC                    ..
L8F1D:  ldx     $AEAC,y                         ; 8F1D BE AC AE                 ...
        ora     ($A0,x)                         ; 8F20 01 A0                    ..
        .byte   $80                             ; 8F22 80                       .
        .byte   $03                             ; 8F23 03                       .
        .byte   $03                             ; 8F24 03                       .
        .byte   $03                             ; 8F25 03                       .
        .byte   $30                             ; 8F26 30                       0
L8F27:  .byte   $32                             ; 8F27 32                       2
        bvc     L8F7C                           ; 8F28 50 52                    PR
        .byte   $FB                             ; 8F2A FB                       .
        sbc     $03FF,x                         ; 8F2B FD FF 03                 ...
        bvc     L8F82                           ; 8F2E 50 52                    PR
        bvc     L8F84                           ; 8F30 50 52                    PR
        asl     a                               ; 8F32 0A                       .
        asl     a                               ; 8F33 0A                       .
        brk                                     ; 8F34 00                       .
        lsr     $B9                             ; 8F35 46 B9                    F.
        asl     $3230,x                         ; 8F37 1E 30 32                 .02
        bmi     L8F3C                           ; 8F3A 30 00                    0.
L8F3C:  .byte   $CB                             ; 8F3C CB                       .
        pha                                     ; 8F3D 48                       H
        cmp     L0000,y                         ; 8F3E D9 00 00                 ...
        .byte   $32                             ; 8F41 32                       2
        .byte   $44                             ; 8F42 44                       D
        .byte   $44                             ; 8F43 44                       D
        brk                                     ; 8F44 00                       .
        brk                                     ; 8F45 00                       .
        .byte   $32                             ; 8F46 32                       2
        bvc     L8F79                           ; 8F47 50 30                    P0
        .byte   $52                             ; 8F49 52                       R
        .byte   $44                             ; 8F4A 44                       D
        .byte   $44                             ; 8F4B 44                       D
        .byte   $44                             ; 8F4C 44                       D
        .byte   $44                             ; 8F4D 44                       D
        .byte   $52                             ; 8F4E 52                       R
        brk                                     ; 8F4F 00                       .
        .byte   $04                             ; 8F50 04                       .
        .byte   $04                             ; 8F51 04                       .
        .byte   $3C                             ; 8F52 3C                       <
        rol     $1C3A,x                         ; 8F53 3E 3A 1C                 >:.
        clc                                     ; 8F56 18                       .
        brk                                     ; 8F57 00                       .
        .byte   $04                             ; 8F58 04                       .
        .byte   $15                             ; 8F59 15                       .
L8F5A:  .byte   $5C                             ; 8F5A 5C                       \
        lsr     $7603,x                         ; 8F5B 5E 03 76                 ^.v
        ora     #$BD                            ; 8F5E 09 BD                    ..
        .byte   $72                             ; 8F60 72                       r
        brk                                     ; 8F61 00                       .
        pla                                     ; 8F62 68                       h
        ror     a                               ; 8F63 6A                       j
        ror     a                               ; 8F64 6A                       j
        dey                                     ; 8F65 88                       .
        .byte   $8B                             ; 8F66 8B                       .
        .byte   $7C                             ; 8F67 7C                       |
        ror     $AAA8,x                         ; 8F68 7E A8 AA                 ~..
        dey                                     ; 8F6B 88                       .
        ror     $4949,x                         ; 8F6C 7E 49 49                 ~II
        .byte   $04                             ; 8F6F 04                       .
        brk                                     ; 8F70 00                       .
        ora     L0000,x                         ; 8F71 15 00                    ..
        brk                                     ; 8F73 00                       .
        .byte   $17                             ; 8F74 17                       .
        .byte   $02                             ; 8F75 02                       .
        sta     $14F0,x                         ; 8F76 9D F0 14                 ...
L8F79:  ora     $1A,x                           ; 8F79 15 1A                    ..
        brk                                     ; 8F7B 00                       .
L8F7C:  .byte   $37                             ; 8F7C 37                       7
        sec                                     ; 8F7D 38                       8
        brk                                     ; 8F7E 00                       .
        .byte   $FA                             ; 8F7F FA                       .
        ora     #$4A                            ; 8F80 09 4A                    .J
L8F82:  .byte   $34                             ; 8F82 34                       4
        .byte   $35                             ; 8F83 35                       5
L8F84:  and     L0000,x                         ; 8F84 35 00                    5.
        php                                     ; 8F86 08                       .
        stx     a:$8F                           ; 8F87 8E 8F 00                 ...
        .byte   $DF                             ; 8F8A DF                       .
        brk                                     ; 8F8B 00                       .
        txa                                     ; 8F8C 8A                       .
        brk                                     ; 8F8D 00                       .
        .byte   $01                             ; 8F8E 01                       .
L8F8F:  cpx     $6ADC                           ; 8F8F EC DC 6A                 ..j
        pla                                     ; 8F92 68                       h
        ror     a                               ; 8F93 6A                       j
        ror     a                               ; 8F94 6A                       j
        sbc     #$F7                            ; 8F95 E9 F7                    ..
        brk                                     ; 8F97 00                       .
        asl     $3230,x                         ; 8F98 1E 30 32                 .02
        bvc     L8FEF                           ; 8F9B 50 52                    PR
        lda     (L0000,x)                       ; 8F9D A1 00                    ..
        .byte   $DB                             ; 8F9F DB                       .
        brk                                     ; 8FA0 00                       .
        clv                                     ; 8FA1 B8                       .
        sed                                     ; 8FA2 F8                       .
        lda     ($E7,x)                         ; 8FA3 A1 E7                    ..
        lda     (L0000,x)                       ; 8FA5 A1 00                    ..
        brk                                     ; 8FA7 00                       .
        brk                                     ; 8FA8 00                       .
        brk                                     ; 8FA9 00                       .
        cmp     L0000,y                         ; 8FAA D9 00 00                 ...
        brk                                     ; 8FAD 00                       .
        brk                                     ; 8FAE 00                       .
        brk                                     ; 8FAF 00                       .
        brk                                     ; 8FB0 00                       .
        nop                                     ; 8FB1 EA                       .
        nop                                     ; 8FB2 EA                       .
        brk                                     ; 8FB3 00                       .
        brk                                     ; 8FB4 00                       .
        brk                                     ; 8FB5 00                       .
        brk                                     ; 8FB6 00                       .
        brk                                     ; 8FB7 00                       .
        .byte   $8B                             ; 8FB8 8B                       .
        nop                                     ; 8FB9 EA                       .
        nop                                     ; 8FBA EA                       .
        nop                                     ; 8FBB EA                       .
        nop                                     ; 8FBC EA                       .
        brk                                     ; 8FBD 00                       .
        brk                                     ; 8FBE 00                       .
        brk                                     ; 8FBF 00                       .
        nop                                     ; 8FC0 EA                       .
        cli                                     ; 8FC1 58                       X
        brk                                     ; 8FC2 00                       .
        nop                                     ; 8FC3 EA                       .
        nop                                     ; 8FC4 EA                       .
        nop                                     ; 8FC5 EA                       .
        nop                                     ; 8FC6 EA                       .
        nop                                     ; 8FC7 EA                       .
        nop                                     ; 8FC8 EA                       .
        sei                                     ; 8FC9 78                       x
        nop                                     ; 8FCA EA                       .
        brk                                     ; 8FCB 00                       .
        brk                                     ; 8FCC 00                       .
        nop                                     ; 8FCD EA                       .
        nop                                     ; 8FCE EA                       .
        nop                                     ; 8FCF EA                       .
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
        nop                                     ; 8FE0 EA                       .
        cli                                     ; 8FE1 58                       X
        brk                                     ; 8FE2 00                       .
        nop                                     ; 8FE3 EA                       .
        nop                                     ; 8FE4 EA                       .
        nop                                     ; 8FE5 EA                       .
        nop                                     ; 8FE6 EA                       .
        nop                                     ; 8FE7 EA                       .
        nop                                     ; 8FE8 EA                       .
        sei                                     ; 8FE9 78                       x
        nop                                     ; 8FEA EA                       .
        brk                                     ; 8FEB 00                       .
        brk                                     ; 8FEC 00                       .
        nop                                     ; 8FED EA                       .
        nop                                     ; 8FEE EA                       .
L8FEF:  nop                                     ; 8FEF EA                       .
        nop                                     ; 8FF0 EA                       .
        nop                                     ; 8FF1 EA                       .
        brk                                     ; 8FF2 00                       .
        nop                                     ; 8FF3 EA                       .
        rts                                     ; 8FF4 60                       `

; ----------------------------------------------------------------------------
        nop                                     ; 8FF5 EA                       .
        dex                                     ; 8FF6 CA                       .
        nop                                     ; 8FF7 EA                       .
        nop                                     ; 8FF8 EA                       .
        pla                                     ; 8FF9 68                       h
        brk                                     ; 8FFA 00                       .
        nop                                     ; 8FFB EA                       .
        brk                                     ; 8FFC 00                       .
        nop                                     ; 8FFD EA                       .
        nop                                     ; 8FFE EA                       .
        brk                                     ; 8FFF 00                       .
        brk                                     ; 9000 00                       .
        sty     $81,x                           ; 9001 94 81                    ..
        sta     $B7                             ; 9003 85 B7                    ..
        .byte   $74                             ; 9005 74                       t
        brk                                     ; 9006 00                       .
        adc     ($03),y                         ; 9007 71 03                    q.
        ldx     #$A4                            ; 9009 A2 A4                    ..
        ldx     $03                             ; 900B A6 03                    ..
        .byte   $62                             ; 900D 62                       b
        brk                                     ; 900E 00                       .
        brk                                     ; 900F 00                       .
        cpy     #$C2                            ; 9010 C0 C2                    ..
        cpy     $C6                             ; 9012 C4 C6                    ..
        .byte   $03                             ; 9014 03                       .
        cmp     $EFDF,x                         ; 9015 DD DF EF                 ...
        cpx     #$E2                            ; 9018 E0 E2                    ..
        cpx     $E6                             ; 901A E4 E6                    ..
        lda     $ADBF,x                         ; 901C BD BF AD                 ...
        .byte   $AF                             ; 901F AF                       .
        ora     ($03,x)                         ; 9020 01 03                    ..
        sta     ($03,x)                         ; 9022 81 03                    ..
        .byte   $03                             ; 9024 03                       .
        .byte   $03                             ; 9025 03                       .
        and     ($33),y                         ; 9026 31 33                    13
        eor     ($53),y                         ; 9028 51 53                    QS
        .byte   $FC                             ; 902A FC                       .
        inc     $0303,x                         ; 902B FE 03 03                 ...
        eor     ($53),y                         ; 902E 51 53                    QS
        eor     ($53),y                         ; 9030 51 53                    QS
        .byte   $0B                             ; 9032 0B                       .
        .byte   $0B                             ; 9033 0B                       .
        .byte   $F7                             ; 9034 F7                       .
        .byte   $47                             ; 9035 47                       G
        tsx                                     ; 9036 BA                       .
        .byte   $1F                             ; 9037 1F                       .
        and     ($33),y                         ; 9038 31 33                    13
        and     (L0000),y                       ; 903A 31 00                    1.
        brk                                     ; 903C 00                       .
        eor     #$DA                            ; 903D 49 DA                    I.
        brk                                     ; 903F 00                       .
        brk                                     ; 9040 00                       .
        .byte   $33                             ; 9041 33                       3
        eor     $45                             ; 9042 45 45                    EE
        brk                                     ; 9044 00                       .
        brk                                     ; 9045 00                       .
        .byte   $33                             ; 9046 33                       3
        eor     ($31),y                         ; 9047 51 31                    Q1
        .byte   $53                             ; 9049 53                       S
        eor     $45                             ; 904A 45 45                    EE
        eor     $45                             ; 904C 45 45                    EE
        nop                                     ; 904E EA                       .
        brk                                     ; 904F 00                       .
        ora     $05                             ; 9050 05 05                    ..
        and     $3B3F,x                         ; 9052 3D 3F 3B                 =?;
        ora     a:$19,x                         ; 9055 1D 19 00                 ...
        ora     L0000                           ; 9058 05 00                    ..
        eor     $EB5F,x                         ; 905A 5D 5F EB                 ]_.
        .byte   $77                             ; 905D 77                       w
        and     #$BF                            ; 905E 29 BF                    ).
        .byte   $74                             ; 9060 74                       t
        brk                                     ; 9061 00                       .
        adc     #$69                            ; 9062 69 69                    ii
        .byte   $6B                             ; 9064 6B                       k
        .byte   $89                             ; 9065 89                       .
        .byte   $8B                             ; 9066 8B                       .
        adc     $A97F,x                         ; 9067 7D 7F A9                 }..
        .byte   $AB                             ; 906A AB                       .
        .byte   $89                             ; 906B 89                       .
        .byte   $7F                             ; 906C 7F                       .
        pha                                     ; 906D 48                       H
        eor     #$04                            ; 906E 49 04                    I.
        ora     L0000,x                         ; 9070 15 00                    ..
        ora     L0000,x                         ; 9072 15 00                    ..
        .byte   $02                             ; 9074 02                       .
        sty     $F59E                           ; 9075 8C 9E F5                 ...
        .byte   $14                             ; 9078 14                       .
        ora     $1B                             ; 9079 05 1B                    ..
        brk                                     ; 907B 00                       .
        sec                                     ; 907C 38                       8
        sta     $FA00                           ; 907D 8D 00 FA                 ...
        and     #$4B                            ; 9080 29 4B                    )K
        and     $35,x                           ; 9082 35 35                    55
        rol     $07                             ; 9084 26 07                    &.
        adc     $8E,x                           ; 9086 75 8E                    u.
        brk                                     ; 9088 00                       .
        dec     $7ADE,x                         ; 9089 DE DE 7A                 ..z
        .byte   $7A                             ; 908C 7A                       z
        .byte   $64                             ; 908D 64                       d
        .byte   $64                             ; 908E 64                       d
        cpx     $69DD                           ; 908F EC DD 69                 ..i
        adc     #$69                            ; 9092 69 69                    ii
        .byte   $6B                             ; 9094 6B                       k
        sed                                     ; 9095 F8                       .
        sbc     #$00                            ; 9096 E9 00                    ..
        .byte   $1F                             ; 9098 1F                       .
        and     ($33),y                         ; 9099 31 33                    13
        eor     ($53),y                         ; 909B 51 53                    QS
        .byte   $D7                             ; 909D D7                       .
        .byte   $DB                             ; 909E DB                       .
        brk                                     ; 909F 00                       .
        cmp     #$00                            ; 90A0 C9 00                    ..
        cld                                     ; 90A2 D8                       .
        .byte   $F7                             ; 90A3 F7                       .
        .byte   $D7                             ; 90A4 D7                       .
        .byte   $D7                             ; 90A5 D7                       .
        brk                                     ; 90A6 00                       .
        brk                                     ; 90A7 00                       .
        brk                                     ; 90A8 00                       .
        inx                                     ; 90A9 E8                       .
        brk                                     ; 90AA 00                       .
        brk                                     ; 90AB 00                       .
        brk                                     ; 90AC 00                       .
        brk                                     ; 90AD 00                       .
        brk                                     ; 90AE 00                       .
        brk                                     ; 90AF 00                       .
        nop                                     ; 90B0 EA                       .
        nop                                     ; 90B1 EA                       .
        nop                                     ; 90B2 EA                       .
        brk                                     ; 90B3 00                       .
        brk                                     ; 90B4 00                       .
        brk                                     ; 90B5 00                       .
        brk                                     ; 90B6 00                       .
        brk                                     ; 90B7 00                       .
        sty     $EAEA                           ; 90B8 8C EA EA                 ...
        nop                                     ; 90BB EA                       .
        brk                                     ; 90BC 00                       .
        brk                                     ; 90BD 00                       .
        brk                                     ; 90BE 00                       .
        brk                                     ; 90BF 00                       .
        nop                                     ; 90C0 EA                       .
        nop                                     ; 90C1 EA                       .
        nop                                     ; 90C2 EA                       .
        nop                                     ; 90C3 EA                       .
        nop                                     ; 90C4 EA                       .
        nop                                     ; 90C5 EA                       .
        nop                                     ; 90C6 EA                       .
        nop                                     ; 90C7 EA                       .
        nop                                     ; 90C8 EA                       .
        adc     L0000,y                         ; 90C9 79 00 00                 y..
        nop                                     ; 90CC EA                       .
        nop                                     ; 90CD EA                       .
        nop                                     ; 90CE EA                       .
        nop                                     ; 90CF EA                       .
        brk                                     ; 90D0 00                       .
        brk                                     ; 90D1 00                       .
        brk                                     ; 90D2 00                       .
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
        nop                                     ; 90E0 EA                       .
        nop                                     ; 90E1 EA                       .
        nop                                     ; 90E2 EA                       .
        nop                                     ; 90E3 EA                       .
        nop                                     ; 90E4 EA                       .
        nop                                     ; 90E5 EA                       .
        nop                                     ; 90E6 EA                       .
        nop                                     ; 90E7 EA                       .
        nop                                     ; 90E8 EA                       .
        adc     L0000,y                         ; 90E9 79 00 00                 y..
        nop                                     ; 90EC EA                       .
        nop                                     ; 90ED EA                       .
        nop                                     ; 90EE EA                       .
        nop                                     ; 90EF EA                       .
        lda     ($EA,x)                         ; 90F0 A1 EA                    ..
        nop                                     ; 90F2 EA                       .
        nop                                     ; 90F3 EA                       .
        nop                                     ; 90F4 EA                       .
        nop                                     ; 90F5 EA                       .
        nop                                     ; 90F6 EA                       .
        nop                                     ; 90F7 EA                       .
        cmp     ($EA,x)                         ; 90F8 C1 EA                    ..
        nop                                     ; 90FA EA                       .
        brk                                     ; 90FB 00                       .
        nop                                     ; 90FC EA                       .
        nop                                     ; 90FD EA                       .
        nop                                     ; 90FE EA                       .
        nop                                     ; 90FF EA                       .
        brk                                     ; 9100 00                       .
        brk                                     ; 9101 00                       .
        ora     ($01,x)                         ; 9102 01 01                    ..
        ora     ($01,x)                         ; 9104 01 01                    ..
        ora     ($01,x)                         ; 9106 01 01                    ..
        ora     (L0000,x)                       ; 9108 01 00                    ..
        brk                                     ; 910A 00                       .
        brk                                     ; 910B 00                       .
        brk                                     ; 910C 00                       .
        ora     ($01,x)                         ; 910D 01 01                    ..
        ora     (L0000,x)                       ; 910F 01 00                    ..
        brk                                     ; 9111 00                       .
        brk                                     ; 9112 00                       .
        brk                                     ; 9113 00                       .
        brk                                     ; 9114 00                       .
        brk                                     ; 9115 00                       .
L9116:  brk                                     ; 9116 00                       .
        ora     (L0000,x)                       ; 9117 01 00                    ..
        brk                                     ; 9119 00                       .
        brk                                     ; 911A 00                       .
        brk                                     ; 911B 00                       .
        ora     ($01,x)                         ; 911C 01 01                    ..
        ora     ($01,x)                         ; 911E 01 01                    ..
        ora     (L0000,x)                       ; 9120 01 00                    ..
        ora     (L0000,x)                       ; 9122 01 00                    ..
        ora     ($01,x)                         ; 9124 01 01                    ..
        .byte   $12                             ; 9126 12                       .
        .byte   $12                             ; 9127 12                       .
        .byte   $12                             ; 9128 12                       .
        .byte   $12                             ; 9129 12                       .
        ora     ($01,x)                         ; 912A 01 01                    ..
        ora     ($01,x)                         ; 912C 01 01                    ..
        .byte   $12                             ; 912E 12                       .
        .byte   $12                             ; 912F 12                       .
        .byte   $12                             ; 9130 12                       .
        .byte   $12                             ; 9131 12                       .
        .byte   $22                             ; 9132 22                       "
        .byte   $42                             ; 9133 42                       B
        .byte   $03                             ; 9134 03                       .
        .byte   $03                             ; 9135 03                       .
        .byte   $03                             ; 9136 03                       .
        .byte   $F3                             ; 9137 F3                       .
        .byte   $12                             ; 9138 12                       .
        .byte   $12                             ; 9139 12                       .
        .byte   $12                             ; 913A 12                       .
        .byte   $02                             ; 913B 02                       .
        .byte   $04                             ; 913C 04                       .
        .byte   $03                             ; 913D 03                       .
        .byte   $03                             ; 913E 03                       .
        .byte   $03                             ; 913F 03                       .
        .byte   $02                             ; 9140 02                       .
        .byte   $12                             ; 9141 12                       .
        .byte   $12                             ; 9142 12                       .
        .byte   $12                             ; 9143 12                       .
        .byte   $02                             ; 9144 02                       .
        .byte   $03                             ; 9145 03                       .
        .byte   $12                             ; 9146 12                       .
        .byte   $12                             ; 9147 12                       .
        .byte   $12                             ; 9148 12                       .
L9149:  .byte   $12                             ; 9149 12                       .
        .byte   $12                             ; 914A 12                       .
        .byte   $12                             ; 914B 12                       .
        .byte   $12                             ; 914C 12                       .
        .byte   $12                             ; 914D 12                       .
        .byte   $12                             ; 914E 12                       .
        brk                                     ; 914F 00                       .
        .byte   $02                             ; 9150 02                       .
        .byte   $02                             ; 9151 02                       .
        bpl     L9164                           ; 9152 10 10                    ..
        bpl     L9149                           ; 9154 10 F3                    ..
        bpl     L9158                           ; 9156 10 00                    ..
L9158:  .byte   $02                             ; 9158 02                       .
        .byte   $02                             ; 9159 02                       .
        bpl     L916F                           ; 915A 10 13                    ..
        ora     ($01,x)                         ; 915C 01 01                    ..
        bpl     L9161                           ; 915E 10 01                    ..
        .byte   $01                             ; 9160 01                       .
L9161:  ora     ($72,x)                         ; 9161 01 72                    .r
        .byte   $72                             ; 9163 72                       r
L9164:  .byte   $52                             ; 9164 52                       R
        brk                                     ; 9165 00                       .
        brk                                     ; 9166 00                       .
        brk                                     ; 9167 00                       .
        brk                                     ; 9168 00                       .
        brk                                     ; 9169 00                       .
        brk                                     ; 916A 00                       .
        ora     (L0000,x)                       ; 916B 01 00                    ..
        brk                                     ; 916D 00                       .
        brk                                     ; 916E 00                       .
L916F:  .byte   $02                             ; 916F 02                       .
        .byte   $02                             ; 9170 02                       .
        .byte   $02                             ; 9171 02                       .
        .byte   $02                             ; 9172 02                       .
        ora     ($13,x)                         ; 9173 01 13                    ..
        .byte   $13                             ; 9175 13                       .
        .byte   $02                             ; 9176 02                       .
        bpl     L917B                           ; 9177 10 02                    ..
        .byte   $02                             ; 9179 02                       .
        .byte   $03                             ; 917A 03                       .
L917B:  brk                                     ; 917B 00                       .
        .byte   $13                             ; 917C 13                       .
        .byte   $13                             ; 917D 13                       .
        .byte   $03                             ; 917E 03                       .
        bpl     L9191                           ; 917F 10 10                    ..
        bpl     L9185                           ; 9181 10 02                    ..
        .byte   $02                             ; 9183 02                       .
        .byte   $02                             ; 9184 02                       .
L9185:  .byte   $02                             ; 9185 02                       .
        .byte   $02                             ; 9186 02                       .
        .byte   $02                             ; 9187 02                       .
        .byte   $02                             ; 9188 02                       .
        .byte   $03                             ; 9189 03                       .
        .byte   $03                             ; 918A 03                       .
        .byte   $03                             ; 918B 03                       .
        .byte   $03                             ; 918C 03                       .
        .byte   $03                             ; 918D 03                       .
        .byte   $03                             ; 918E 03                       .
        brk                                     ; 918F 00                       .
        .byte   $01                             ; 9190 01                       .
L9191:  .byte   $52                             ; 9191 52                       R
        .byte   $12                             ; 9192 12                       .
        .byte   $12                             ; 9193 12                       .
        .byte   $12                             ; 9194 12                       .
        .byte   $03                             ; 9195 03                       .
        .byte   $03                             ; 9196 03                       .
        .byte   $03                             ; 9197 03                       .
        .byte   $F2                             ; 9198 F2                       .
        .byte   $62                             ; 9199 62                       b
        .byte   $62                             ; 919A 62                       b
        .byte   $62                             ; 919B 62                       b
        .byte   $62                             ; 919C 62                       b
        .byte   $03                             ; 919D 03                       .
        .byte   $03                             ; 919E 03                       .
        .byte   $03                             ; 919F 03                       .
        .byte   $03                             ; 91A0 03                       .
        .byte   $03                             ; 91A1 03                       .
        .byte   $03                             ; 91A2 03                       .
        .byte   $03                             ; 91A3 03                       .
        .byte   $03                             ; 91A4 03                       .
        .byte   $03                             ; 91A5 03                       .
        .byte   $03                             ; 91A6 03                       .
        .byte   $03                             ; 91A7 03                       .
        .byte   $03                             ; 91A8 03                       .
        .byte   $03                             ; 91A9 03                       .
        .byte   $03                             ; 91AA 03                       .
        .byte   $03                             ; 91AB 03                       .
        .byte   $03                             ; 91AC 03                       .
        .byte   $03                             ; 91AD 03                       .
        .byte   $03                             ; 91AE 03                       .
        .byte   $03                             ; 91AF 03                       .
        brk                                     ; 91B0 00                       .
        brk                                     ; 91B1 00                       .
        brk                                     ; 91B2 00                       .
        brk                                     ; 91B3 00                       .
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
        bvc     L9217                           ; 91C5 50 50                    PP
        brk                                     ; 91C7 00                       .
        brk                                     ; 91C8 00                       .
        brk                                     ; 91C9 00                       .
        brk                                     ; 91CA 00                       .
        brk                                     ; 91CB 00                       .
        brk                                     ; 91CC 00                       .
        bvc     L921F                           ; 91CD 50 50                    PP
        brk                                     ; 91CF 00                       .
        brk                                     ; 91D0 00                       .
        brk                                     ; 91D1 00                       .
        brk                                     ; 91D2 00                       .
        brk                                     ; 91D3 00                       .
        brk                                     ; 91D4 00                       .
        bvc     L9227                           ; 91D5 50 50                    PP
        brk                                     ; 91D7 00                       .
        brk                                     ; 91D8 00                       .
        brk                                     ; 91D9 00                       .
        brk                                     ; 91DA 00                       .
        brk                                     ; 91DB 00                       .
        brk                                     ; 91DC 00                       .
        bvc     L922F                           ; 91DD 50 50                    PP
        brk                                     ; 91DF 00                       .
        brk                                     ; 91E0 00                       .
        brk                                     ; 91E1 00                       .
        brk                                     ; 91E2 00                       .
        brk                                     ; 91E3 00                       .
        brk                                     ; 91E4 00                       .
        bvc     L9237                           ; 91E5 50 50                    PP
        brk                                     ; 91E7 00                       .
        brk                                     ; 91E8 00                       .
        brk                                     ; 91E9 00                       .
        brk                                     ; 91EA 00                       .
        brk                                     ; 91EB 00                       .
        brk                                     ; 91EC 00                       .
        bvc     L923F                           ; 91ED 50 50                    PP
        brk                                     ; 91EF 00                       .
        brk                                     ; 91F0 00                       .
        brk                                     ; 91F1 00                       .
        brk                                     ; 91F2 00                       .
        brk                                     ; 91F3 00                       .
        brk                                     ; 91F4 00                       .
        bvc     L9247                           ; 91F5 50 50                    PP
        brk                                     ; 91F7 00                       .
        brk                                     ; 91F8 00                       .
        brk                                     ; 91F9 00                       .
        brk                                     ; 91FA 00                       .
        brk                                     ; 91FB 00                       .
        brk                                     ; 91FC 00                       .
        bvc     L924F                           ; 91FD 50 50                    PP
        brk                                     ; 91FF 00                       .
        php                                     ; 9200 08                       .
        ora     #$10                            ; 9201 09 10                    ..
        ora     ($0A),y                         ; 9203 11 0A                    ..
        .byte   $0B                             ; 9205 0B                       .
        .byte   $12                             ; 9206 12                       .
        .byte   $13                             ; 9207 13                       .
        .byte   $0C                             ; 9208 0C                       .
        php                                     ; 9209 08                       .
        .byte   $14                             ; 920A 14                       .
        php                                     ; 920B 08                       .
        .byte   $5C                             ; 920C 5C                       \
        jsr     L2A08                           ; 920D 20 08 2A                  .*
        jsr     L2B17                           ; 9210 20 17 2B                  .+
        bit     $0108                           ; 9213 2C 08 01                 ,..
        php                                     ; 9216 08                       .
L9217:  ora     #$08                            ; 9217 09 08                    ..
        php                                     ; 9219 08                       .
        asl     a                               ; 921A 0A                       .
        .byte   $0B                             ; 921B 0B                       .
        php                                     ; 921C 08                       .
        php                                     ; 921D 08                       .
        .byte   $0C                             ; 921E 0C                       .
L921F:  php                                     ; 921F 08                       .
        clc                                     ; 9220 18                       .
        ora     $2108,y                         ; 9221 19 08 21                 ..!
        .byte   $1A                             ; 9224 1A                       .
        .byte   $1B                             ; 9225 1B                       .
        .byte   $22                             ; 9226 22                       "
L9227:  .byte   $23                             ; 9227 23                       #
        bpl     L923B                           ; 9228 10 11                    ..
        clc                                     ; 922A 18                       .
        ora     $1312,y                         ; 922B 19 12 13                 ...
        .byte   $1A                             ; 922E 1A                       .
L922F:  .byte   $1B                             ; 922F 1B                       .
        .byte   $14                             ; 9230 14                       .
        php                                     ; 9231 08                       .
        php                                     ; 9232 08                       .
        ora     ($08,x)                         ; 9233 01 08                    ..
        php                                     ; 9235 08                       .
        php                                     ; 9236 08                       .
L9237:  php                                     ; 9237 08                       .
        .byte   $02                             ; 9238 02                       .
        php                                     ; 9239 08                       .
        .byte   $02                             ; 923A 02                       .
L923B:  php                                     ; 923B 08                       .
        .byte   $14                             ; 923C 14                       .
        php                                     ; 923D 08                       .
        php                                     ; 923E 08                       .
L923F:  php                                     ; 923F 08                       .
        php                                     ; 9240 08                       .
        and     ($08,x)                         ; 9241 21 08                    !.
        php                                     ; 9243 08                       .
        .byte   $22                             ; 9244 22                       "
        .byte   $23                             ; 9245 23                       #
        .byte   $02                             ; 9246 02                       .
L9247:  php                                     ; 9247 08                       .
        php                                     ; 9248 08                       .
        .byte   $07                             ; 9249 07                       .
        rts                                     ; 924A 60                       `

; ----------------------------------------------------------------------------
        adc     ($03,x)                         ; 924B 61 03                    a.
        .byte   $07                             ; 924D 07                       .
        .byte   $04                             ; 924E 04                       .
L924F:  asl     $2107                           ; 924F 0E 07 21                 ..!
        ora     $2205                           ; 9252 0D 05 22                 .."
        .byte   $23                             ; 9255 23                       #
        .byte   $03                             ; 9256 03                       .
        .byte   $07                             ; 9257 07                       .
        php                                     ; 9258 08                       .
        php                                     ; 9259 08                       .
        .byte   $07                             ; 925A 07                       .
        rts                                     ; 925B 60                       `

; ----------------------------------------------------------------------------
        php                                     ; 925C 08                       .
        php                                     ; 925D 08                       .
        ora     $07                             ; 925E 05 07                    ..
        .byte   $02                             ; 9260 02                       .
        php                                     ; 9261 08                       .
        .byte   $03                             ; 9262 03                       .
        .byte   $07                             ; 9263 07                       .
        brk                                     ; 9264 00                       .
        brk                                     ; 9265 00                       .
        .byte   $1C                             ; 9266 1C                       .
        ora     $0F04,x                         ; 9267 1D 04 0F                 ...
        eor     $045F,x                         ; 926A 5D 5F 04                 ]_.
        asl     $5F5D                           ; 926D 0E 5D 5F                 .]_
        asl     L0000                           ; 9270 06 00                    ..
        ora     a:$1D,x                         ; 9272 1D 1D 00                 ...
        ora     $1D1E                           ; 9275 0D 1E 1D                 ...
        ora     $05                             ; 9278 05 05                    ..
        ora     $081D,x                         ; 927A 1D 1D 08                 ...
        php                                     ; 927D 08                       .
        ora     $15,x                           ; 927E 15 15                    ..
        .byte   $02                             ; 9280 02                       .
        php                                     ; 9281 08                       .
        .byte   $02                             ; 9282 02                       .
        ora     $24,x                           ; 9283 15 24                    .$
        php                                     ; 9285 08                       .
        php                                     ; 9286 08                       .
        php                                     ; 9287 08                       .
        .byte   $02                             ; 9288 02                       .
        php                                     ; 9289 08                       .
        .byte   $3A                             ; 928A 3A                       :
        and     $0808,y                         ; 928B 39 08 08                 9..
        sec                                     ; 928E 38                       8
        and     $2928,y                         ; 928F 39 28 29                 9()
        rol     $27                             ; 9292 26 27                    &'
        rol     $262F                           ; 9294 2E 2F 26                 ./&
        .byte   $27                             ; 9297 27                       '
        php                                     ; 9298 08                       .
        php                                     ; 9299 08                       .
        php                                     ; 929A 08                       .
        .byte   $07                             ; 929B 07                       .
        .byte   $03                             ; 929C 03                       .
        adc     ($5D,x)                         ; 929D 61 5D                    a]
        ora     $6105,x                         ; 929F 1D 05 61                 ..a
        ora     $021D,x                         ; 92A2 1D 1D 02                 ...
        php                                     ; 92A5 08                       .
        sec                                     ; 92A6 38                       8
        and     $0802,y                         ; 92A7 39 02 08                 9..
        sec                                     ; 92AA 38                       8
        lsr     $24                             ; 92AB 46 24                    F$
        and     ($08),y                         ; 92AD 31 08                    1.
        .byte   $27                             ; 92AF 27                       '
        plp                                     ; 92B0 28                       (
        .byte   $2F                             ; 92B1 2F                       /
        rol     $27                             ; 92B2 26 27                    &'
        eor     #$08                            ; 92B4 49 08                    I.
        .byte   $9B                             ; 92B6 9B                       .
        php                                     ; 92B7 08                       .
        rol     $2629                           ; 92B8 2E 29 26                 .)&
        .byte   $27                             ; 92BB 27                       '
        plp                                     ; 92BC 28                       (
        eor     #$26                            ; 92BD 49 26                    I&
        .byte   $27                             ; 92BF 27                       '
        .byte   $8F                             ; 92C0 8F                       .
        .byte   $8F                             ; 92C1 8F                       .
        tya                                     ; 92C2 98                       .
        tya                                     ; 92C3 98                       .
        .byte   $3A                             ; 92C4 3A                       :
        eor     #$26                            ; 92C5 49 26                    I&
        .byte   $27                             ; 92C7 27                       '
        .byte   $8F                             ; 92C8 8F                       .
        and     ($98),y                         ; 92C9 31 98                    1.
        .byte   $27                             ; 92CB 27                       '
        php                                     ; 92CC 08                       .
        php                                     ; 92CD 08                       .
        php                                     ; 92CE 08                       .
        eor     ($05,x)                         ; 92CF 41 05                    A.
        adc     ($1E,x)                         ; 92D1 61 1E                    a.
        ora     $3103,x                         ; 92D3 1D 03 31                 ..1
        eor     L8F27,x                         ; 92D6 5D 27 8F                 ]'.
        .byte   $8F                             ; 92D9 8F                       .
        brk                                     ; 92DA 00                       .
        brk                                     ; 92DB 00                       .
        brk                                     ; 92DC 00                       .
        brk                                     ; 92DD 00                       .
        brk                                     ; 92DE 00                       .
        brk                                     ; 92DF 00                       .
        rol     $27                             ; 92E0 26 27                    &'
        rol     $262F                           ; 92E2 2E 2F 26                 ./&
        .byte   $27                             ; 92E5 27                       '
        lsr     a                               ; 92E6 4A                       J
        .byte   $4B                             ; 92E7 4B                       K
        lda     ($A2,x)                         ; 92E8 A1 A2                    ..
        lda     #$AA                            ; 92EA A9 AA                    ..
        brk                                     ; 92EC 00                       .
        ldy     #$00                            ; 92ED A0 00                    ..
        tay                                     ; 92EF A8                       .
        and     a:$35,x                         ; 92F0 3D 35 00                 =5.
        and     $3D36,x                         ; 92F3 3D 36 3D                 =6=
        rol     $3500,x                         ; 92F6 3E 00 35                 >.5
        and     $363D,x                         ; 92F9 3D 3D 36                 ==6
        .byte   $3F                             ; 92FC 3F                       ?
        brk                                     ; 92FD 00                       .
        brk                                     ; 92FE 00                       .
        brk                                     ; 92FF 00                       .
        brk                                     ; 9300 00                       .
        rol     $3F00,x                         ; 9301 3E 00 3F                 >.?
        brk                                     ; 9304 00                       .
        brk                                     ; 9305 00                       .
        brk                                     ; 9306 00                       .
        and     (L0000),y                       ; 9307 31 00                    1.
        brk                                     ; 9309 00                       .
        plp                                     ; 930A 28                       (
        and     #$00                            ; 930B 29 00                    ).
        eor     $3D00                           ; 930D 4D 00 3D                 M.=
        .byte   $42                             ; 9310 42                       B
        .byte   $27                             ; 9311 27                       '
        brk                                     ; 9312 00                       .
        .byte   $2F                             ; 9313 2F                       /
        brk                                     ; 9314 00                       .
        .byte   $27                             ; 9315 27                       '
        brk                                     ; 9316 00                       .
        .byte   $2F                             ; 9317 2F                       /
        .byte   $3A                             ; 9318 3A                       :
        and     $2F2E,y                         ; 9319 39 2E 2F                 9./
        pha                                     ; 931C 48                       H
        brk                                     ; 931D 00                       .
        rol     a:$31                           ; 931E 2E 31 00                 .1.
        eor     ($28,x)                         ; 9321 41 28                    A(
        .byte   $2F                             ; 9323 2F                       /
        sec                                     ; 9324 38                       8
        .byte   $27                             ; 9325 27                       '
        rol     $2E2F                           ; 9326 2E 2F 2E                 ./.
        .byte   $2F                             ; 9329 2F                       /
        jmp     L004D                           ; 932A 4C 4D 00                 LM.

; ----------------------------------------------------------------------------
        brk                                     ; 932D 00                       .
        lda     $A3                             ; 932E A5 A3                    ..
        sta     $289D,x                         ; 9330 9D 9D 28                 ..(
        and     #$A5                            ; 9333 29 A5                    ).
        .byte   $A3                             ; 9335 A3                       .
        plp                                     ; 9336 28                       (
        and     #$00                            ; 9337 29 00                    ).
        brk                                     ; 9339 00                       .
        sec                                     ; 933A 38                       8
        lsr     L0000                           ; 933B 46 00                    F.
        brk                                     ; 933D 00                       .
        sec                                     ; 933E 38                       8
        and     L0000,y                         ; 933F 39 00 00                 9..
        pha                                     ; 9342 48                       H
        brk                                     ; 9343 00                       .
        lsr     a                               ; 9344 4A                       J
        .byte   $4B                             ; 9345 4B                       K
        brk                                     ; 9346 00                       .
        brk                                     ; 9347 00                       .
        brk                                     ; 9348 00                       .
        brk                                     ; 9349 00                       .
        .byte   $89                             ; 934A 89                       .
        txa                                     ; 934B 8A                       .
        sta     L8B8E                           ; 934C 8D 8E 8B                 ...
        sty     $4B4A                           ; 934F 8C 4A 4B                 .JK
        .byte   $89                             ; 9352 89                       .
        txa                                     ; 9353 8A                       .
        rol     $2632                           ; 9354 2E 32 26                 .2&
        .byte   $32                             ; 9357 32                       2
        lsr     a                               ; 9358 4A                       J
        .byte   $32                             ; 9359 32                       2
        brk                                     ; 935A 00                       .
        .byte   $32                             ; 935B 32                       2
        brk                                     ; 935C 00                       .
        brk                                     ; 935D 00                       .
        brk                                     ; 935E 00                       .
        eor     (L0000,x)                       ; 935F 41 00                    A.
        .byte   $32                             ; 9361 32                       2
        sec                                     ; 9362 38                       8
        and     $26,y                           ; 9363 39 26 00                 9&.
        rol     $2600                           ; 9366 2E 00 26                 ..&
        brk                                     ; 9369 00                       .
        lsr     a                               ; 936A 4A                       J
        brk                                     ; 936B 00                       .
        and     $A8A2,x                         ; 936C 3D A2 A8                 =..
        tax                                     ; 936F AA                       .
        sta     L9B9A,y                         ; 9370 99 9A 9B                 ...
        .byte   $9C                             ; 9373 9C                       .
        rol     L004D                           ; 9374 26 4D                    &M
        rol     L9900                           ; 9376 2E 00 99                 ...
        brk                                     ; 9379 00                       .
        .byte   $9B                             ; 937A 9B                       .
        brk                                     ; 937B 00                       .
        brk                                     ; 937C 00                       .
        brk                                     ; 937D 00                       .
        ldy     $A5                             ; 937E A4 A5                    ..
        rol     $A4                             ; 9380 26 A4                    &.
        rol     L9D9D                           ; 9382 2E 9D 9D                 ...
        sta     L9D9D,x                         ; 9385 9D 9D 9D                 ...
        rol     $33                             ; 9388 26 33                    &3
        rol     $2632                           ; 938A 2E 32 26                 .2&
        .byte   $32                             ; 938D 32                       2
        rol     a:$32                           ; 938E 2E 32 00                 .2.
        .byte   $6B                             ; 9391 6B                       k
        brk                                     ; 9392 00                       .
        .byte   $6B                             ; 9393 6B                       k
        brk                                     ; 9394 00                       .
        adc     L0000                           ; 9395 65 00                    e.
        adc     $65                             ; 9397 65 65                    ee
        brk                                     ; 9399 00                       .
        adc     L0000                           ; 939A 65 00                    e.
        brk                                     ; 939C 00                       .
        brk                                     ; 939D 00                       .
        brk                                     ; 939E 00                       .
        .byte   $67                             ; 939F 67                       g
        brk                                     ; 93A0 00                       .
        adc     $68                             ; 93A1 65 68                    eh
        ror     $65                             ; 93A3 66 65                    fe
        brk                                     ; 93A5 00                       .
        ror     $69                             ; 93A6 66 69                    fi
        brk                                     ; 93A8 00                       .
        adc     $6A                             ; 93A9 65 6A                    ej
        adc     $62                             ; 93AB 65 62                    eb
        .byte   $63                             ; 93AD 63                       c
        tax                                     ; 93AE AA                       .
        and     $6BA3,x                         ; 93AF 3D A3 6B                 =.k
        sta     $A36B,x                         ; 93B2 9D 6B A3                 .k.
        adc     $9D                             ; 93B5 65 9D                    e.
        adc     $91                             ; 93B7 65 91                    e.
        .byte   $64                             ; 93B9 64                       d
        tax                                     ; 93BA AA                       .
        and     $6565,x                         ; 93BB 3D 65 65                 =ee
        adc     $65                             ; 93BE 65 65                    ee
        sec                                     ; 93C0 38                       8
        and     $2F2E,y                         ; 93C1 39 2E 2F                 9./
        sec                                     ; 93C4 38                       8
        lsr     $2E                             ; 93C5 46 2E                    F.
        .byte   $2F                             ; 93C7 2F                       /
        sta     L9D65,x                         ; 93C8 9D 65 9D                 .e.
        adc     $A4                             ; 93CB 65 A4                    e.
L93CD:  .byte   $A3                             ; 93CD A3                       .
        sta     a:$9D,x                         ; 93CE 9D 9D 00                 ...
        brk                                     ; 93D1 00                       .
        .byte   $A3                             ; 93D2 A3                       .
        brk                                     ; 93D3 00                       .
        sta     L9DA3,x                         ; 93D4 9D A3 9D                 ...
        sta     $6565,x                         ; 93D7 9D 65 65                 .ee
        jmp     (L0066)                         ; 93DA 6C 66 00                 lf.

; ----------------------------------------------------------------------------
        brk                                     ; 93DD 00                       .
        ror     a                               ; 93DE 6A                       j
        brk                                     ; 93DF 00                       .
        brk                                     ; 93E0 00                       .
        .byte   $6B                             ; 93E1 6B                       k
        bmi     L940D                           ; 93E2 30 29                    0)
        brk                                     ; 93E4 00                       .
        brk                                     ; 93E5 00                       .
        brk                                     ; 93E6 00                       .
        .byte   $33                             ; 93E7 33                       3
        brk                                     ; 93E8 00                       .
        brk                                     ; 93E9 00                       .
        .byte   $92                             ; 93EA 92                       .
        .byte   $93                             ; 93EB 93                       .
        brk                                     ; 93EC 00                       .
        brk                                     ; 93ED 00                       .
        .byte   $93                             ; 93EE 93                       .
        sty     L0000,x                         ; 93EF 94 00                    ..
        .byte   $32                             ; 93F1 32                       2
        brk                                     ; 93F2 00                       .
        .byte   $32                             ; 93F3 32                       2
        brk                                     ; 93F4 00                       .
        .byte   $92                             ; 93F5 92                       .
        brk                                     ; 93F6 00                       .
        brk                                     ; 93F7 00                       .
        .byte   $93                             ; 93F8 93                       .
        .byte   $93                             ; 93F9 93                       .
        lda     #$00                            ; 93FA A9 00                    ..
        sty     $A2,x                           ; 93FC 94 A2                    ..
        tay                                     ; 93FE A8                       .
        tax                                     ; 93FF AA                       .
        brk                                     ; 9400 00                       .
        .byte   $32                             ; 9401 32                       2
        plp                                     ; 9402 28                       (
        eor     #$00                            ; 9403 49 00                    I.
        brk                                     ; 9405 00                       .
        .byte   $A3                             ; 9406 A3                       .
        ldy     L0000                           ; 9407 A4 00                    ..
        eor     (L0000,x)                       ; 9409 41 00                    A.
        .byte   $2F                             ; 940B 2F                       /
        .byte   $9D                             ; 940C 9D                       .
L940D:  .byte   $9F                             ; 940D 9F                       .
        sta     $A49F,x                         ; 940E 9D 9F A4                 ...
        lda     $9D                             ; 9411 A5 9D                    ..
        sta     $3200,x                         ; 9413 9D 00 32                 ..2
        .byte   $A3                             ; 9416 A3                       .
        .byte   $32                             ; 9417 32                       2
        .byte   $47                             ; 9418 47                       G
        brk                                     ; 9419 00                       .
        rol     L0000                           ; 941A 26 00                    &.
        .byte   $47                             ; 941C 47                       G
        .byte   $33                             ; 941D 33                       3
        rol     $32                             ; 941E 26 32                    &2
        php                                     ; 9420 08                       .
        .byte   $5C                             ; 9421 5C                       \
        php                                     ; 9422 08                       .
        php                                     ; 9423 08                       .
        jsr     L2A20                           ; 9424 20 20 2A                   *
        .byte   $2B                             ; 9427 2B                       +
        .byte   $17                             ; 9428 17                       .
        php                                     ; 9429 08                       .
        bit     $0508                           ; 942A 2C 08 05                 ,..
        .byte   $07                             ; 942D 07                       .
        brk                                     ; 942E 00                       .
        ora     $0760                           ; 942F 0D 60 07                 .`.
        brk                                     ; 9432 00                       .
        ora     a:L0000                         ; 9433 0D 00 00                 ...
        asl     a:$1E,x                         ; 9436 1E 1E 00                 ...
        brk                                     ; 9439 00                       .
        ora     $241D,x                         ; 943A 1D 1D 24                 ..$
        bit     $90                             ; 943D 24 90                    $.
        bcc     L9479                           ; 943F 90 38                    .8
        .byte   $33                             ; 9441 33                       3
        rol     $0832                           ; 9442 2E 32 08                 .2.
        .byte   $07                             ; 9445 07                       .
        ora     $61                             ; 9446 05 61                    .a
        bit     $54                             ; 9448 24 54                    $T
        bcc     L93CD                           ; 944A 90 81                    ..
        brk                                     ; 944C 00                       .
        brk                                     ; 944D 00                       .
        .byte   $37                             ; 944E 37                       7
        .byte   $37                             ; 944F 37                       7
        .byte   $54                             ; 9450 54                       T
        brk                                     ; 9451 00                       .
        sta     ($37,x)                         ; 9452 81 37                    .7
        brk                                     ; 9454 00                       .
        .byte   $54                             ; 9455 54                       T
        .byte   $37                             ; 9456 37                       7
        sta     ($52,x)                         ; 9457 81 52                    .R
        .byte   $53                             ; 9459 53                       S
        .byte   $5A                             ; 945A 5A                       Z
        .byte   $5B                             ; 945B 5B                       [
        .byte   $74                             ; 945C 74                       t
        adc     $7C,x                           ; 945D 75 7C                    u|
        adc     $0808,x                         ; 945F 7D 08 08                 }..
        ora     $05                             ; 9462 05 05                    ..
        .byte   $07                             ; 9464 07                       .
        .byte   $07                             ; 9465 07                       .
        asl     $0D                             ; 9466 06 0D                    ..
        rts                                     ; 9468 60                       `

; ----------------------------------------------------------------------------
        adc     (L0000,x)                       ; 9469 61 00                    a.
        brk                                     ; 946B 00                       .
        brk                                     ; 946C 00                       .
        ora     a:L0000                         ; 946D 0D 00 00                 ...
        brk                                     ; 9470 00                       .
        brk                                     ; 9471 00                       .
        .byte   $54                             ; 9472 54                       T
        .byte   $54                             ; 9473 54                       T
        brk                                     ; 9474 00                       .
        brk                                     ; 9475 00                       .
        .byte   $77                             ; 9476 77                       w
        .byte   $77                             ; 9477 77                       w
        .byte   $81                             ; 9478 81                       .
L9479:  sta     ($81,x)                         ; 9479 81 81                    ..
        sta     ($51,x)                         ; 947B 81 51                    .Q
        lsr     L8050,x                         ; 947D 5E 50 80                 ^P.
        eor     ($51),y                         ; 9480 51 51                    QQ
        bvc     L94D4                           ; 9482 50 50                    PP
        cli                                     ; 9484 58                       X
        cli                                     ; 9485 58                       X
        bvc     L94D8                           ; 9486 50 50                    PP
        .byte   $74                             ; 9488 74                       t
        .byte   $54                             ; 9489 54                       T
        .byte   $7C                             ; 948A 7C                       |
        lsr     $50,x                           ; 948B 56 50                    VP
        bvc     L94DF                           ; 948D 50 50                    PP
        bvc     L9506                           ; 948F 50 75                    Pu
        .byte   $74                             ; 9491 74                       t
        adc     $757C,x                         ; 9492 7D 7C 75                 }|u
        lsr     L807D,x                         ; 9495 5E 7D 80                 ^}.
        .byte   $7F                             ; 9498 7F                       .
        .byte   $77                             ; 9499 77                       w
        eor     ($51),y                         ; 949A 51 51                    QQ
        adc     $74,x                           ; 949C 75 74                    ut
        adc     $7554,x                         ; 949E 7D 54 75                 }Tu
        .byte   $74                             ; 94A1 74                       t
        .byte   $7F                             ; 94A2 7F                       .
        .byte   $7F                             ; 94A3 7F                       .
        adc     $5E,x                           ; 94A4 75 5E                    u^
        .byte   $7F                             ; 94A6 7F                       .
        .byte   $77                             ; 94A7 77                       w
        .byte   $74                             ; 94A8 74                       t
        adc     $7C,x                           ; 94A9 75 7C                    u|
        .byte   $54                             ; 94AB 54                       T
        .byte   $74                             ; 94AC 74                       t
        lsr     $7F,x                           ; 94AD 56 7F                    V.
        .byte   $77                             ; 94AF 77                       w
        adc     (L0000),y                       ; 94B0 71 00                    q.
        .byte   $59                             ; 94B2 59                       Y
L94B3:  brk                                     ; 94B3 00                       .
        brk                                     ; 94B4 00                       .
L94B5:  .byte   $72                             ; 94B5 72                       r
        brk                                     ; 94B6 00                       .
L94B7:  bvs     L9509                           ; 94B7 70 50                    pP
        bvc     L950D                           ; 94B9 50 52                    PR
        .byte   $53                             ; 94BB 53                       S
        adc     $56,x                           ; 94BC 75 56                    uV
        adc     $595E,x                         ; 94BE 7D 5E 59                 }^Y
        brk                                     ; 94C1 00                       .
        eor     L0000,y                         ; 94C2 59 00 00                 Y..
        bvs     L94C7                           ; 94C5 70 00                    p.
L94C7:  bvs     L9523                           ; 94C7 70 5A                    pZ
L94C9:  .byte   $5B                             ; 94C9 5B                       [
        eor     ($51),y                         ; 94CA 51 51                    QQ
        .byte   $5A                             ; 94CC 5A                       Z
        .byte   $5B                             ; 94CD 5B                       [
        .byte   $77                             ; 94CE 77                       w
        .byte   $7F                             ; 94CF 7F                       .
        .byte   $74                             ; 94D0 74                       t
        .byte   $54                             ; 94D1 54                       T
        .byte   $7C                             ; 94D2 7C                       |
        .byte   $81                             ; 94D3 81                       .
L94D4:  .byte   $54                             ; 94D4 54                       T
        adc     $56,x                           ; 94D5 75 56                    uV
        .byte   $7D                             ; 94D7 7D                       }
L94D8:  adc     $81,x                           ; 94D8 75 81                    u.
        adc     $5E81,x                         ; 94DA 7D 81 5E                 }.^
        .byte   $74                             ; 94DD 74                       t
        .byte   $77                             ; 94DE 77                       w
L94DF:  .byte   $7F                             ; 94DF 7F                       .
        .byte   $7F                             ; 94E0 7F                       .
        lsr     $7C,x                           ; 94E1 56 7C                    V|
        lsr     $7F5E,x                         ; 94E3 5E 5E 7F                 ^^.
        lsr     $7F7D,x                         ; 94E6 5E 7D 7F                 ^}.
        .byte   $7F                             ; 94E9 7F                       .
L94EA:  .byte   $7C                             ; 94EA 7C                       |
        adc     $5E74,x                         ; 94EB 7D 74 5E                 }t^
        .byte   $7C                             ; 94EE 7C                       |
        lsr     $5050,x                         ; 94EF 5E 50 50                 ^PP
        sei                                     ; 94F2 78                       x
        sei                                     ; 94F3 78                       x
        .byte   $54                             ; 94F4 54                       T
        .byte   $74                             ; 94F5 74                       t
        sta     ($7C,x)                         ; 94F6 81 7C                    .|
        adc     $5E,x                           ; 94F8 75 5E                    u^
        adc     L815E,x                         ; 94FA 7D 5E 81                 }^.
        adc     $56,x                           ; 94FD 75 56                    uV
        .byte   $7D                             ; 94FF 7D                       }
L9500:  lsr     $5E74,x                         ; 9500 5E 74 5E                 ^t^
        .byte   $7C                             ; 9503 7C                       |
        adc     $81,x                           ; 9504 75 81                    u.
L9506:  adc     $5E56,x                         ; 9506 7D 56 5E                 }V^
L9509:  adc     $5E,x                           ; 9509 75 5E                    u^
        .byte   $7D                             ; 950B 7D                       }
        .byte   $74                             ; 950C 74                       t
L950D:  adc     $7F,x                           ; 950D 75 7F                    u.
        .byte   $7F                             ; 950F 7F                       .
        .byte   $74                             ; 9510 74                       t
        .byte   $54                             ; 9511 54                       T
        .byte   $7F                             ; 9512 7F                       .
        .byte   $77                             ; 9513 77                       w
        .byte   $7F                             ; 9514 7F                       .
        .byte   $7F                             ; 9515 7F                       .
        eor     ($51),y                         ; 9516 51 51                    QQ
        adc     $54,x                           ; 9518 75 54                    uT
        adc     $7481,x                         ; 951A 7D 81 74                 }.t
        sta     ($7C,x)                         ; 951D 81 7C                    .|
        lsr     L0000,x                         ; 951F 56 00                    V.
        brk                                     ; 9521 00                       .
        .byte   $73                             ; 9522 73                       s
L9523:  brk                                     ; 9523 00                       .
        bvc     L9576                           ; 9524 50 50                    PP
        bvc     L959F                           ; 9526 50 77                    Pw
        sta     $86                             ; 9528 85 86                    ..
        .byte   $82                             ; 952A 82                       .
        .byte   $83                             ; 952B 83                       .
        .byte   $7F                             ; 952C 7F                       .
        .byte   $7F                             ; 952D 7F                       .
        eor     ($54),y                         ; 952E 51 54                    QT
        bvc     L94B3                           ; 9530 50 81                    P.
        bvc     L94B5                           ; 9532 50 81                    P.
        bvc     L94B7                           ; 9534 50 81                    P.
        sei                                     ; 9536 78                       x
        lsr     $50,x                           ; 9537 56 50                    VP
        lsr     $5E50,x                         ; 9539 5E 50 5E                 ^P^
        .byte   $87                             ; 953C 87                       .
        dey                                     ; 953D 88                       .
        .byte   $83                             ; 953E 83                       .
        sty     $50                             ; 953F 84 50                    .P
        bvc     L9597                           ; 9541 50 54                    PT
        bvc     L9595                           ; 9543 50 50                    PP
        .byte   $54                             ; 9545 54                       T
        bvc     L94C9                           ; 9546 50 81                    P.
        sta     ($50,x)                         ; 9548 81 50                    .P
        sta     ($50,x)                         ; 954A 81 50                    .P
        adc     $74,x                           ; 954C 75 74                    ut
        .byte   $54                             ; 954E 54                       T
        .byte   $7F                             ; 954F 7F                       .
        sta     ($50,x)                         ; 9550 81 50                    .P
        .byte   $77                             ; 9552 77                       w
        bvc     L95A5                           ; 9553 50 50                    PP
        sta     ($50,x)                         ; 9555 81 50                    .P
        .byte   $56                             ; 9557 56                       V
L9558:  lsr     $51,x                           ; 9558 56 51                    VQ
L955A:  .byte   $77                             ; 955A 77                       w
        .byte   $50                             ; 955B 50                       P
L955C:  eor     ($50),y                         ; 955C 51 50                    QP
        .byte   $50,$50                    ; 955E 50 50   (branch out of range for ca65: target has no local label)
        eor     $55,x                           ; 9560 55 55                    UU
        eor     ($51),y                         ; 9562 51 51                    QQ
        eor     $50,x                           ; 9564 55 50                    UP
        eor     ($50),y                         ; 9566 51 50                    QP
        sta     ($51,x)                         ; 9568 81 51                    .Q
        sta     ($50,x)                         ; 956A 81 50                    .P
        .byte   $54                             ; 956C 54                       T
        adc     $81,x                           ; 956D 75 81                    u.
        adc     $5081,x                         ; 956F 7D 81 50                 }.P
        lsr     $50,x                           ; 9572 56 50                    VP
        .byte   $81                             ; 9574 81                       .
L9575:  .byte   $74                             ; 9575 74                       t
L9576:  lsr     $7C,x                           ; 9576 56 7C                    V|
        lsr     $5E50,x                         ; 9578 5E 50 5E                 ^P^
        bvc     L95D1                           ; 957B 50 54                    PT
        bvc     L9500                           ; 957D 50 81                    P.
        bvc     L95D1                           ; 957F 50 50                    PP
        .byte   $77                             ; 9581 77                       w
        bvc     L95D5                           ; 9582 50 51                    PQ
        adc     $7950,y                         ; 9584 79 50 79                 yPy
        bvc     L95FD                           ; 9587 50 74                    Pt
        adc     $54,x                           ; 9589 75 54                    uT
        .byte   $7C                             ; 958B 7C                       |
        sta     ($74,x)                         ; 958C 81 74                    .t
        .byte   $77                             ; 958E 77                       w
        .byte   $7F                             ; 958F 7F                       .
        adc     $74,x                           ; 9590 75 74                    ut
        .byte   $54                             ; 9592 54                       T
        .byte   $7C                             ; 9593 7C                       |
        .byte   $51                             ; 9594 51                       Q
L9595:  eor     ($78),y                         ; 9595 51 78                    Qx
L9597:  sei                                     ; 9597 78                       x
        sta     ($75,x)                         ; 9598 81 75                    .u
        .byte   $77                             ; 959A 77                       w
        .byte   $7F                             ; 959B 7F                       .
        .byte   $54                             ; 959C 54                       T
        .byte   $7F                             ; 959D 7F                       .
        .byte   $81                             ; 959E 81                       .
L959F:  adc     $547F,x                         ; 959F 7D 7F 54                 }.T
        .byte   $7C                             ; 95A2 7C                       |
        sta     ($54,x)                         ; 95A3 81 54                    .T
L95A5:  .byte   $7F                             ; 95A5 7F                       .
        sta     ($7C,x)                         ; 95A6 81 7C                    .|
        .byte   $77                             ; 95A8 77                       w
        .byte   $74                             ; 95A9 74                       t
        adc     $757C,x                         ; 95AA 7D 7C 75                 }|u
        .byte   $77                             ; 95AD 77                       w
L95AE:  .byte   $7D                             ; 95AE 7D                       }
L95AF:  .byte   $7C                             ; 95AF 7C                       |
        .byte   $7F                             ; 95B0 7F                       .
        .byte   $54                             ; 95B1 54                       T
        adc     $7781,x                         ; 95B2 7D 81 77                 }.w
        .byte   $75                             ; 95B5 75                       u
L95B6:  .byte   $7C                             ; 95B6 7C                       |
        .byte   $7D                             ; 95B7 7D                       }
L95B8:  .byte   $74                             ; 95B8 74                       t
        .byte   $77                             ; 95B9 77                       w
        .byte   $7C                             ; 95BA 7C                       |
        adc     L8174,x                         ; 95BB 7D 74 81                 }t.
        .byte   $7C                             ; 95BE 7C                       |
        sta     ($74,x)                         ; 95BF 81 74                    .t
L95C1:  adc     $54,x                           ; 95C1 75 54                    uT
        adc     $7F77,x                         ; 95C3 7D 77 7F                 }w.
        eor     ($51),y                         ; 95C6 51 51                    QQ
        .byte   $7F                             ; 95C8 7F                       .
        .byte   $7F                             ; 95C9 7F                       .
        eor     ($7A),y                         ; 95CA 51 7A                    Qz
        bvc     L9622                           ; 95CC 50 54                    PT
        bvc     L9626                           ; 95CE 50 56                    PV
        .byte   $50                             ; 95D0 50                       P
L95D1:  .byte   $7A                             ; 95D1 7A                       z
        bvc     L964E                           ; 95D2 50 7A                    Pz
        .byte   $54                             ; 95D4 54                       T
L95D5:  bvs     L9558                           ; 95D5 70 81                    p.
        bvs     L955A                           ; 95D7 70 81                    p.
        bvs     L955C                           ; 95D9 70 81                    p.
        bvs     L965C                           ; 95DB 70 7F                    p.
        .byte   $7F                             ; 95DD 7F                       .
        adc     (L0000),y                       ; 95DE 71 00                    q.
        .byte   $7F                             ; 95E0 7F                       .
        .byte   $7F                             ; 95E1 7F                       .
        brk                                     ; 95E2 00                       .
        brk                                     ; 95E3 00                       .
        .byte   $7F                             ; 95E4 7F                       .
        .byte   $7F                             ; 95E5 7F                       .
        brk                                     ; 95E6 00                       .
        .byte   $72                             ; 95E7 72                       r
        .byte   $74                             ; 95E8 74                       t
        adc     $54,x                           ; 95E9 75 54                    uT
        .byte   $7F                             ; 95EB 7F                       .
        .byte   $74                             ; 95EC 74                       t
        adc     $7F,x                           ; 95ED 75 7F                    u.
        .byte   $54                             ; 95EF 54                       T
        eor     ($81),y                         ; 95F0 51 81                    Q.
        bvc     L9575                           ; 95F2 50 81                    P.
        .byte   $77                             ; 95F4 77                       w
        bvc     L9648                           ; 95F5 50 51                    PQ
        bvc     L966D                           ; 95F7 50 74                    Pt
        adc     $7C,x                           ; 95F9 75 7C                    u|
        .byte   $7D                             ; 95FB 7D                       }
        brk                                     ; 95FC 00                       .
L95FD:  brk                                     ; 95FD 00                       .
        brk                                     ; 95FE 00                       .
        brk                                     ; 95FF 00                       .
        brk                                     ; 9600 00                       .
        ora     ($02,x)                         ; 9601 01 02                    ..
        .byte   $03                             ; 9603 03                       .
        .byte   $04                             ; 9604 04                       .
        ora     $06                             ; 9605 05 06                    ..
        .byte   $07                             ; 9607 07                       .
        php                                     ; 9608 08                       .
        ora     #$05                            ; 9609 09 05                    ..
        asl     $07                             ; 960B 06 07                    ..
        asl     a                               ; 960D 0A                       .
        .byte   $0B                             ; 960E 0B                       .
        .byte   $0C                             ; 960F 0C                       .
        ora     $0A0E                           ; 9610 0D 0E 0A                 ...
        .byte   $0B                             ; 9613 0B                       .
        .byte   $0F                             ; 9614 0F                       .
        bpl     L9628                           ; 9615 10 11                    ..
        brk                                     ; 9617 00                       .
        .byte   $12                             ; 9618 12                       .
        .byte   $13                             ; 9619 13                       .
        .byte   $14                             ; 961A 14                       .
        ora     $16,x                           ; 961B 15 16                    ..
        .byte   $17                             ; 961D 17                       .
        clc                                     ; 961E 18                       .
        php                                     ; 961F 08                       .
        .byte   $19                             ; 9620 19                       .
        .byte   $1A                             ; 9621 1A                       .
L9622:  ora     $1C1B,y                         ; 9622 19 1B 1C                 ...
        .byte   $1D                             ; 9625 1D                       .
L9626:  .byte   $1B                             ; 9626 1B                       .
        .byte   $1E                             ; 9627 1E                       .
L9628:  .byte   $1F                             ; 9628 1F                       .
        jsr     L201F                           ; 9629 20 1F 20                  . 
        .byte   $1F                             ; 962C 1F                       .
        and     (L0022,x)                       ; 962D 21 22                    !"
        .byte   $23                             ; 962F 23                       #
        bit     $24                             ; 9630 24 24                    $$
        bit     $24                             ; 9632 24 24                    $$
        bit     $24                             ; 9634 24 24                    $$
        and     $25                             ; 9636 25 25                    %%
        and     $25                             ; 9638 25 25                    %%
        and     $25                             ; 963A 25 25                    %%
        and     $25                             ; 963C 25 25                    %%
        and     $25                             ; 963E 25 25                    %%
        ora     $0100                           ; 9640 0D 00 01                 ...
        .byte   $02                             ; 9643 02                       .
        .byte   $03                             ; 9644 03                       .
        .byte   $04                             ; 9645 04                       .
        ora     $06                             ; 9646 05 06                    ..
L9648:  ora     $0908                           ; 9648 0D 08 09                 ...
        ora     $06                             ; 964B 05 06                    ..
        .byte   $07                             ; 964D 07                       .
L964E:  asl     a                               ; 964E 0A                       .
        .byte   $0B                             ; 964F 0B                       .
        ora     ($02,x)                         ; 9650 01 02                    ..
        asl     $0B0A                           ; 9652 0E 0A 0B                 ...
        .byte   $0F                             ; 9655 0F                       .
        bpl     L9669                           ; 9656 10 11                    ..
        ora     #$12                            ; 9658 09 12                    ..
        .byte   $13                             ; 965A 13                       .
        .byte   $14                             ; 965B 14                       .
L965C:  ora     $26,x                           ; 965C 15 26                    .&
        .byte   $17                             ; 965E 17                       .
        clc                                     ; 965F 18                       .
        .byte   $27                             ; 9660 27                       '
        ora     $191A,y                         ; 9661 19 1A 19                 ...
        .byte   $1B                             ; 9664 1B                       .
        plp                                     ; 9665 28                       (
        ora     $291B,x                         ; 9666 1D 1B 29                 ..)
L9669:  .byte   $23                             ; 9669 23                       #
        rol     a                               ; 966A 2A                       *
        .byte   $1F                             ; 966B 1F                       .
        .byte   $20                             ; 966C 20                        
L966D:  .byte   $1F                             ; 966D 1F                       .
        .byte   $2B                             ; 966E 2B                       +
        bit     $25                             ; 966F 24 25                    $%
        and     $25                             ; 9671 25 25                    %%
        bit     $24                             ; 9673 24 24                    $$
        bit     $2C                             ; 9675 24 2C                    $,
        and     $25                             ; 9677 25 25                    %%
        and     $25                             ; 9679 25 25                    %%
        and     $25                             ; 967B 25 25                    %%
        and     $25                             ; 967D 25 25                    %%
        and     $07                             ; 967F 25 07                    %.
        ora     $0100                           ; 9681 0D 00 01                 ...
        .byte   $02                             ; 9684 02                       .
        .byte   $03                             ; 9685 03                       .
        .byte   $04                             ; 9686 04                       .
        ora     $0D0C                           ; 9687 0D 0C 0D                 ...
        php                                     ; 968A 08                       .
        ora     #$0D                            ; 968B 09 0D                    ..
        ora     $06                             ; 968D 05 06                    ..
        .byte   $07                             ; 968F 07                       .
        brk                                     ; 9690 00                       .
        ora     ($02,x)                         ; 9691 01 02                    ..
        asl     $0A0D                           ; 9693 0E 0D 0A                 ...
        .byte   $0B                             ; 9696 0B                       .
        .byte   $0F                             ; 9697 0F                       .
        php                                     ; 9698 08                       .
        ora     #$26                            ; 9699 09 26                    .&
        clc                                     ; 969B 18                       .
        asl     $14,x                           ; 969C 16 14                    ..
        ora     $17,x                           ; 969E 15 17                    ..
        asl     $2827,x                         ; 96A0 1E 27 28                 .'(
        .byte   $1B                             ; 96A3 1B                       .
        .byte   $1C                             ; 96A4 1C                       .
        ora     $1D1B,y                         ; 96A5 19 1B 1D                 ...
        and     $0D20                           ; 96A8 2D 20 0D                 - .
        jsr     L0D0D                           ; 96AB 20 0D 0D                  ..
        jsr     L2E2B                           ; 96AE 20 2B 2E                  +.
        .byte   $2F                             ; 96B1 2F                       /
        bmi     L96E5                           ; 96B2 30 31                    01
        bmi     L96E8                           ; 96B4 30 32                    02
        bit     $2C                             ; 96B6 24 2C                    $,
        and     $25                             ; 96B8 25 25                    %%
        bit     $25                             ; 96BA 24 25                    $%
        bit     $2C                             ; 96BC 24 2C                    $,
        and     $25                             ; 96BE 25 25                    %%
        ora     $06                             ; 96C0 05 06                    ..
        .byte   $07                             ; 96C2 07                       .
        ora     $0100                           ; 96C3 0D 00 01                 ...
        .byte   $02                             ; 96C6 02                       .
        .byte   $03                             ; 96C7 03                       .
        asl     a                               ; 96C8 0A                       .
        .byte   $0B                             ; 96C9 0B                       .
        .byte   $0C                             ; 96CA 0C                       .
        ora     $0908                           ; 96CB 0D 08 09                 ...
        ora     $100D                           ; 96CE 0D 0D 10                 ...
L96D1:  ora     (L0000),y                       ; 96D1 11 00                    ..
        ora     ($02,x)                         ; 96D3 01 02                    ..
        asl     L0D0D                           ; 96D5 0E 0D 0D                 ...
        rol     $18                             ; 96D8 26 18                    &.
        php                                     ; 96DA 08                       .
        ora     #$33                            ; 96DB 09 33                    .3
        rol     a                               ; 96DD 2A                       *
        .byte   $17                             ; 96DE 17                       .
        .byte   $12                             ; 96DF 12                       .
        plp                                     ; 96E0 28                       (
        .byte   $1B                             ; 96E1 1B                       .
        .byte   $34                             ; 96E2 34                       4
        and     $2C,x                           ; 96E3 35 2C                    5,
L96E5:  and     $1D                             ; 96E5 25 1D                    %.
        .byte   $19                             ; 96E7 19                       .
L96E8:  .byte   $2F                             ; 96E8 2F                       /
        jsr     L2C2B                           ; 96E9 20 2B 2C                  +,
        and     $25                             ; 96EC 25 25                    %%
        and     ($0D,x)                         ; 96EE 21 0D                    !.
        and     $24                             ; 96F0 25 24                    %$
        bit     $2525                           ; 96F2 2C 25 25                 ,%%
        and     $36                             ; 96F5 25 36                    %6
        rol     $25,x                           ; 96F7 36 25                    6%
        and     $25                             ; 96F9 25 25                    %%
        and     $25                             ; 96FB 25 25                    %%
        and     $37                             ; 96FD 25 37                    %7
        .byte   $37                             ; 96FF 37                       7
        sec                                     ; 9700 38                       8
        and     $3939,y                         ; 9701 39 39 39                 999
        and     $3A39,y                         ; 9704 39 39 3A                 99:
        .byte   $3B                             ; 9707 3B                       ;
        sec                                     ; 9708 38                       8
        .byte   $3C                             ; 9709 3C                       <
        .byte   $3C                             ; 970A 3C                       <
        and     $3C3E,x                         ; 970B 3D 3E 3C                 =><
        .byte   $37                             ; 970E 37                       7
        .byte   $37                             ; 970F 37                       7
        sec                                     ; 9710 38                       8
        .byte   $3B                             ; 9711 3B                       ;
        .byte   $3A                             ; 9712 3A                       :
        .byte   $3F                             ; 9713 3F                       ?
        rti                                     ; 9714 40                       @

; ----------------------------------------------------------------------------
        eor     (L0042,x)                       ; 9715 41 42                    AB
        .byte   $42                             ; 9717 42                       B
        sec                                     ; 9718 38                       8
        .byte   $37                             ; 9719 37                       7
        .byte   $37                             ; 971A 37                       7
        .byte   $3B                             ; 971B 3B                       ;
        .byte   $3A                             ; 971C 3A                       :
        .byte   $43                             ; 971D 43                       C
        .byte   $44                             ; 971E 44                       D
        sec                                     ; 971F 38                       8
        sec                                     ; 9720 38                       8
        .byte   $3A                             ; 9721 3A                       :
        .byte   $37                             ; 9722 37                       7
        .byte   $37                             ; 9723 37                       7
        .byte   $37                             ; 9724 37                       7
        .byte   $37                             ; 9725 37                       7
        eor     $38                             ; 9726 45 38                    E8
        sec                                     ; 9728 38                       8
        .byte   $37                             ; 9729 37                       7
        lsr     $47                             ; 972A 46 47                    FG
        .byte   $42                             ; 972C 42                       B
        pha                                     ; 972D 48                       H
        eor     #$38                            ; 972E 49 38                    I8
        sec                                     ; 9730 38                       8
        .byte   $37                             ; 9731 37                       7
        sec                                     ; 9732 38                       8
        sec                                     ; 9733 38                       8
        sec                                     ; 9734 38                       8
        sec                                     ; 9735 38                       8
        sec                                     ; 9736 38                       8
        sec                                     ; 9737 38                       8
        sec                                     ; 9738 38                       8
        .byte   $37                             ; 9739 37                       7
        sec                                     ; 973A 38                       8
        sec                                     ; 973B 38                       8
        sec                                     ; 973C 38                       8
        sec                                     ; 973D 38                       8
        sec                                     ; 973E 38                       8
        sec                                     ; 973F 38                       8
        and     $3A                             ; 9740 25 3A                    %:
        lsr     a                               ; 9742 4A                       J
        lsr     a                               ; 9743 4A                       J
        and     $25                             ; 9744 25 25                    %%
        and     $25                             ; 9746 25 25                    %%
        and     $37                             ; 9748 25 37                    %7
        rol     $4A3C,x                         ; 974A 3E 3C 4A                 ><J
        and     $25                             ; 974D 25 25                    %%
        and     $25                             ; 974F 25 25                    %%
        .byte   $37                             ; 9751 37                       7
        rti                                     ; 9752 40                       @

; ----------------------------------------------------------------------------
        .byte   $3A                             ; 9753 3A                       :
        and     $254A,x                         ; 9754 3D 4A 25                 =J%
        and     $25                             ; 9757 25 25                    %%
        .byte   $4B                             ; 9759 4B                       K
        .byte   $37                             ; 975A 37                       7
        .byte   $37                             ; 975B 37                       7
        .byte   $3F                             ; 975C 3F                       ?
        rol     $254A,x                         ; 975D 3E 4A 25                 >J%
        and     $4C                             ; 9760 25 4C                    %L
        eor     $374E                           ; 9762 4D 4E 37                 MN7
        rti                                     ; 9765 40                       @

; ----------------------------------------------------------------------------
        .byte   $3C                             ; 9766 3C                       <
        lsr     a                               ; 9767 4A                       J
        and     $25                             ; 9768 25 25                    %%
        and     $25                             ; 976A 25 25                    %%
        .byte   $4F                             ; 976C 4F                       O
        bvc     L97A6                           ; 976D 50 37                    P7
        .byte   $37                             ; 976F 37                       7
        and     $25                             ; 9770 25 25                    %%
        and     $25                             ; 9772 25 25                    %%
        and     $2E                             ; 9774 25 2E                    %.
        bit     $24                             ; 9776 24 24                    $$
        and     $25                             ; 9778 25 25                    %%
        and     $25                             ; 977A 25 25                    %%
        and     $25                             ; 977C 25 25                    %%
        and     $25                             ; 977E 25 25                    %%
        and     $25                             ; 9780 25 25                    %%
        and     $25                             ; 9782 25 25                    %%
        and     $25                             ; 9784 25 25                    %%
        and     $25                             ; 9786 25 25                    %%
        and     $25                             ; 9788 25 25                    %%
        and     $25                             ; 978A 25 25                    %%
        and     $25                             ; 978C 25 25                    %%
        and     $25                             ; 978E 25 25                    %%
        and     $25                             ; 9790 25 25                    %%
        lsr     a                               ; 9792 4A                       J
        lsr     a                               ; 9793 4A                       J
        and     $25                             ; 9794 25 25                    %%
        .byte   $25                             ; 9796 25                       %
L9797:  and     $4A                             ; 9797 25 4A                    %J
        lsr     a                               ; 9799 4A                       J
        .byte   $37                             ; 979A 37                       7
        .byte   $37                             ; 979B 37                       7
        and     $25                             ; 979C 25 25                    %%
        lsr     a                               ; 979E 4A                       J
        lsr     a                               ; 979F 4A                       J
        .byte   $37                             ; 97A0 37                       7
        .byte   $37                             ; 97A1 37                       7
        .byte   $37                             ; 97A2 37                       7
        .byte   $37                             ; 97A3 37                       7
        eor     ($51),y                         ; 97A4 51 51                    QQ
L97A6:  .byte   $37                             ; 97A6 37                       7
        .byte   $52                             ; 97A7 52                       R
        .byte   $37                             ; 97A8 37                       7
        .byte   $37                             ; 97A9 37                       7
        .byte   $37                             ; 97AA 37                       7
        .byte   $37                             ; 97AB 37                       7
        .byte   $37                             ; 97AC 37                       7
        .byte   $37                             ; 97AD 37                       7
L97AE:  .byte   $37                             ; 97AE 37                       7
        .byte   $53                             ; 97AF 53                       S
        bit     $24                             ; 97B0 24 24                    $$
        bit     $24                             ; 97B2 24 24                    $$
        bit     $24                             ; 97B4 24 24                    $$
        bit     $24                             ; 97B6 24 24                    $$
        and     $25                             ; 97B8 25 25                    %%
        and     $25                             ; 97BA 25 25                    %%
        and     $25                             ; 97BC 25 25                    %%
        .byte   $25                             ; 97BE 25                       %
L97BF:  and     $25                             ; 97BF 25 25                    %%
        and     $25                             ; 97C1 25 25                    %%
        and     $25                             ; 97C3 25 25                    %%
        and     $25                             ; 97C5 25 25                    %%
        and     $25                             ; 97C7 25 25                    %%
        and     $25                             ; 97C9 25 25                    %%
        and     $25                             ; 97CB 25 25                    %%
        and     $25                             ; 97CD 25 25                    %%
        and     $4A                             ; 97CF 25 4A                    %J
        lsr     a                               ; 97D1 4A                       J
        and     $25                             ; 97D2 25 25                    %%
        and     $25                             ; 97D4 25 25                    %%
        and     $25                             ; 97D6 25 25                    %%
        .byte   $37                             ; 97D8 37                       7
        .byte   $37                             ; 97D9 37                       7
        and     $25                             ; 97DA 25 25                    %%
        and     $25                             ; 97DC 25 25                    %%
        and     $25                             ; 97DE 25 25                    %%
        .byte   $37                             ; 97E0 37                       7
        .byte   $37                             ; 97E1 37                       7
        eor     ($51),y                         ; 97E2 51 51                    QQ
        eor     ($51),y                         ; 97E4 51 51                    QQ
        eor     ($54),y                         ; 97E6 51 54                    QT
        .byte   $37                             ; 97E8 37                       7
        .byte   $37                             ; 97E9 37                       7
        .byte   $37                             ; 97EA 37                       7
        .byte   $37                             ; 97EB 37                       7
        .byte   $37                             ; 97EC 37                       7
        .byte   $37                             ; 97ED 37                       7
        .byte   $37                             ; 97EE 37                       7
        .byte   $53                             ; 97EF 53                       S
        bit     $24                             ; 97F0 24 24                    $$
        bit     $24                             ; 97F2 24 24                    $$
        bit     $24                             ; 97F4 24 24                    $$
        bit     $24                             ; 97F6 24 24                    $$
        and     $25                             ; 97F8 25 25                    %%
        and     $25                             ; 97FA 25 25                    %%
        and     $25                             ; 97FC 25 25                    %%
        and     $25                             ; 97FE 25 25                    %%
        and     $25                             ; 9800 25 25                    %%
        and     $25                             ; 9802 25 25                    %%
        and     $25                             ; 9804 25 25                    %%
        and     $25                             ; 9806 25 25                    %%
        and     $25                             ; 9808 25 25                    %%
        and     $25                             ; 980A 25 25                    %%
        and     $25                             ; 980C 25 25                    %%
        and     $25                             ; 980E 25 25                    %%
        and     $25                             ; 9810 25 25                    %%
        and     $25                             ; 9812 25 25                    %%
        and     $25                             ; 9814 25 25                    %%
        and     $25                             ; 9816 25 25                    %%
        and     $25                             ; 9818 25 25                    %%
        and     $25                             ; 981A 25 25                    %%
        and     $25                             ; 981C 25 25                    %%
        and     $25                             ; 981E 25 25                    %%
        eor     ($51),y                         ; 9820 51 51                    QQ
        eor     ($51),y                         ; 9822 51 51                    QQ
        eor     ($51),y                         ; 9824 51 51                    QQ
        eor     ($54),y                         ; 9826 51 54                    QT
        .byte   $37                             ; 9828 37                       7
        .byte   $37                             ; 9829 37                       7
        .byte   $37                             ; 982A 37                       7
        .byte   $37                             ; 982B 37                       7
        .byte   $37                             ; 982C 37                       7
        .byte   $37                             ; 982D 37                       7
        .byte   $37                             ; 982E 37                       7
        .byte   $53                             ; 982F 53                       S
        bit     $24                             ; 9830 24 24                    $$
        bit     $24                             ; 9832 24 24                    $$
        bit     $24                             ; 9834 24 24                    $$
        bit     $24                             ; 9836 24 24                    $$
        and     $25                             ; 9838 25 25                    %%
        and     $25                             ; 983A 25 25                    %%
        and     $25                             ; 983C 25 25                    %%
        and     $25                             ; 983E 25 25                    %%
        and     $25                             ; 9840 25 25                    %%
        and     $25                             ; 9842 25 25                    %%
        and     $25                             ; 9844 25 25                    %%
        eor     $25,x                           ; 9846 55 25                    U%
        and     $25                             ; 9848 25 25                    %%
        and     $25                             ; 984A 25 25                    %%
        and     $25                             ; 984C 25 25                    %%
        eor     $25,x                           ; 984E 55 25                    U%
        and     $25                             ; 9850 25 25                    %%
        and     $25                             ; 9852 25 25                    %%
        and     $25                             ; 9854 25 25                    %%
        eor     $25,x                           ; 9856 55 25                    U%
        and     $25                             ; 9858 25 25                    %%
        and     $25                             ; 985A 25 25                    %%
        and     $25                             ; 985C 25 25                    %%
        eor     $25,x                           ; 985E 55 25                    U%
        eor     ($51),y                         ; 9860 51 51                    QQ
        eor     ($51),y                         ; 9862 51 51                    QQ
        eor     ($51),y                         ; 9864 51 51                    QQ
        lsr     $25,x                           ; 9866 56 25                    V%
        .byte   $37                             ; 9868 37                       7
        .byte   $37                             ; 9869 37                       7
        .byte   $37                             ; 986A 37                       7
        .byte   $57                             ; 986B 57                       W
        .byte   $4F                             ; 986C 4F                       O
        .byte   $4F                             ; 986D 4F                       O
L986E:  cli                                     ; 986E 58                       X
        and     $24                             ; 986F 25 24                    %$
        bit     $24                             ; 9871 24 24                    $$
        bit     $2525                           ; 9873 2C 25 25                 ,%%
        and     $25                             ; 9876 25 25                    %%
        and     $25                             ; 9878 25 25                    %%
        and     $25                             ; 987A 25 25                    %%
        and     $25                             ; 987C 25 25                    %%
        and     $25                             ; 987E 25 25                    %%
        sec                                     ; 9880 38                       8
        sec                                     ; 9881 38                       8
        sec                                     ; 9882 38                       8
        sec                                     ; 9883 38                       8
        sec                                     ; 9884 38                       8
        sec                                     ; 9885 38                       8
        sec                                     ; 9886 38                       8
        eor     $3838,y                         ; 9887 59 38 38                 Y88
        sec                                     ; 988A 38                       8
        sec                                     ; 988B 38                       8
        sec                                     ; 988C 38                       8
        sec                                     ; 988D 38                       8
        sec                                     ; 988E 38                       8
        .byte   $5A                             ; 988F 5A                       Z
        sec                                     ; 9890 38                       8
        sec                                     ; 9891 38                       8
        sec                                     ; 9892 38                       8
        sec                                     ; 9893 38                       8
        sec                                     ; 9894 38                       8
        sec                                     ; 9895 38                       8
        sec                                     ; 9896 38                       8
        .byte   $5B                             ; 9897 5B                       [
        sec                                     ; 9898 38                       8
        sec                                     ; 9899 38                       8
        sec                                     ; 989A 38                       8
        .byte   $5C                             ; 989B 5C                       \
        .byte   $5C                             ; 989C 5C                       \
        .byte   $5C                             ; 989D 5C                       \
        eor     $3837,x                         ; 989E 5D 37 38                 ]78
        .byte   $37                             ; 98A1 37                       7
        .byte   $5C                             ; 98A2 5C                       \
        .byte   $5C                             ; 98A3 5C                       \
        sec                                     ; 98A4 38                       8
        .byte   $5C                             ; 98A5 5C                       \
        lsr     $385F,x                         ; 98A6 5E 5F 38                 ^_8
        sec                                     ; 98A9 38                       8
        sec                                     ; 98AA 38                       8
        sec                                     ; 98AB 38                       8
        sec                                     ; 98AC 38                       8
        sec                                     ; 98AD 38                       8
        rts                                     ; 98AE 60                       `

; ----------------------------------------------------------------------------
        adc     ($38,x)                         ; 98AF 61 38                    a8
        sec                                     ; 98B1 38                       8
        sec                                     ; 98B2 38                       8
        sec                                     ; 98B3 38                       8
        sec                                     ; 98B4 38                       8
        sec                                     ; 98B5 38                       8
        .byte   $62                             ; 98B6 62                       b
        lsr     $38                             ; 98B7 46 38                    F8
        sec                                     ; 98B9 38                       8
        sec                                     ; 98BA 38                       8
        sec                                     ; 98BB 38                       8
        sec                                     ; 98BC 38                       8
        sec                                     ; 98BD 38                       8
        .byte   $63                             ; 98BE 63                       c
        sec                                     ; 98BF 38                       8
        rol     $3D64,x                         ; 98C0 3E 64 3D                 >d=
        rol     $6665,x                         ; 98C3 3E 65 66                 >ef
        rol     $4065,x                         ; 98C6 3E 65 40                 >e@
        .byte   $64                             ; 98C9 64                       d
        .byte   $3F                             ; 98CA 3F                       ?
        rti                                     ; 98CB 40                       @

; ----------------------------------------------------------------------------
        adc     L0066                           ; 98CC 65 66                    ef
        rti                                     ; 98CE 40                       @

; ----------------------------------------------------------------------------
        adc     $3A                             ; 98CF 65 3A                    e:
        .byte   $64                             ; 98D1 64                       d
        .byte   $3B                             ; 98D2 3B                       ;
        .byte   $3A                             ; 98D3 3A                       :
        adc     L0066                           ; 98D4 65 66                    ef
        .byte   $3A                             ; 98D6 3A                       :
        adc     $37                             ; 98D7 65 37                    e7
        .byte   $64                             ; 98D9 64                       d
        .byte   $37                             ; 98DA 37                       7
        .byte   $37                             ; 98DB 37                       7
        adc     L0066                           ; 98DC 65 66                    ef
        .byte   $67                             ; 98DE 67                       g
        pla                                     ; 98DF 68                       h
        .byte   $4B                             ; 98E0 4B                       K
        .byte   $64                             ; 98E1 64                       d
        .byte   $4B                             ; 98E2 4B                       K
        .byte   $67                             ; 98E3 67                       g
        pla                                     ; 98E4 68                       h
        adc     #$6A                            ; 98E5 69 6A                    ij
        .byte   $6B                             ; 98E7 6B                       k
        adc     ($6C,x)                         ; 98E8 61 6C                    al
        adc     ($6D,x)                         ; 98EA 61 6D                    am
        .byte   $6B                             ; 98EC 6B                       k
        ror     $4B6F                           ; 98ED 6E 6F 4B                 noK
        bvs     L9962                           ; 98F0 70 70                    pp
        adc     ($72),y                         ; 98F2 71 72                    qr
        .byte   $73                             ; 98F4 73                       s
        .byte   $74                             ; 98F5 74                       t
        .byte   $6F                             ; 98F6 6F                       o
        adc     ($38,x)                         ; 98F7 61 38                    a8
        sec                                     ; 98F9 38                       8
        sec                                     ; 98FA 38                       8
        .byte   $72                             ; 98FB 72                       r
        adc     ($75,x)                         ; 98FC 61 75                    au
        .byte   $6F                             ; 98FE 6F                       o
        .byte   $61                             ; 98FF 61                       a
L9900:  ror     $65                             ; 9900 66 65                    fe
        ror     $3C                             ; 9902 66 3C                    f<
        .byte   $64                             ; 9904 64                       d
        .byte   $5B                             ; 9905 5B                       [
        rol     $6637,x                         ; 9906 3E 37 66                 >7f
        adc     L0066                           ; 9909 65 66                    ef
        .byte   $37                             ; 990B 37                       7
        .byte   $64                             ; 990C 64                       d
        .byte   $37                             ; 990D 37                       7
        rti                                     ; 990E 40                       @

; ----------------------------------------------------------------------------
        .byte   $3A                             ; 990F 3A                       :
        ror     $65                             ; 9910 66 65                    fe
        ror     $3A                             ; 9912 66 3A                    f:
        .byte   $64                             ; 9914 64                       d
        .byte   $37                             ; 9915 37                       7
        .byte   $37                             ; 9916 37                       7
        .byte   $37                             ; 9917 37                       7
        adc     #$6A                            ; 9918 69 6A                    ij
        ror     $37                             ; 991A 66 37                    f7
        .byte   $64                             ; 991C 64                       d
        .byte   $3A                             ; 991D 3A                       :
        .byte   $3A                             ; 991E 3A                       :
        .byte   $37                             ; 991F 37                       7
        ror     $666F                           ; 9920 6E 6F 66                 nof
        .byte   $37                             ; 9923 37                       7
        .byte   $64                             ; 9924 64                       d
        .byte   $5F                             ; 9925 5F                       _
        .byte   $4B                             ; 9926 4B                       K
        .byte   $37                             ; 9927 37                       7
        .byte   $67                             ; 9928 67                       g
        ror     $69,x                           ; 9929 76 69                    vi
        .byte   $77                             ; 992B 77                       w
        sei                                     ; 992C 78                       x
        jmp     L4D4C                           ; 992D 4C 4C 4D                 LLM

; ----------------------------------------------------------------------------
        adc     $6E6B                           ; 9930 6D 6B 6E                 mkn
        ror     $38                             ; 9933 66 38                    f8
        sec                                     ; 9935 38                       8
        sec                                     ; 9936 38                       8
        sec                                     ; 9937 38                       8
        .byte   $72                             ; 9938 72                       r
        .byte   $37                             ; 9939 37                       7
        .byte   $37                             ; 993A 37                       7
        ror     $38                             ; 993B 66 38                    f8
        sec                                     ; 993D 38                       8
        sec                                     ; 993E 38                       8
        sec                                     ; 993F 38                       8
        .byte   $3C                             ; 9940 3C                       <
        .byte   $37                             ; 9941 37                       7
        .byte   $3A                             ; 9942 3A                       :
        .byte   $64                             ; 9943 64                       d
        .byte   $3C                             ; 9944 3C                       <
        .byte   $37                             ; 9945 37                       7
        .byte   $5B                             ; 9946 5B                       [
        .byte   $64                             ; 9947 64                       d
        adc     $7B7A,y                         ; 9948 79 7A 7B                 yz{
        .byte   $64                             ; 994B 64                       d
        .byte   $37                             ; 994C 37                       7
        .byte   $37                             ; 994D 37                       7
        .byte   $37                             ; 994E 37                       7
        .byte   $64                             ; 994F 64                       d
        .byte   $7C                             ; 9950 7C                       |
        rol     $643C,x                         ; 9951 3E 3C 64                 ><d
        adc     $7F7E,x                         ; 9954 7D 7E 7F                 }~.
        .byte   $64                             ; 9957 64                       d
        .byte   $7C                             ; 9958 7C                       |
        rti                                     ; 9959 40                       @

; ----------------------------------------------------------------------------
        .byte   $37                             ; 995A 37                       7
        .byte   $64                             ; 995B 64                       d
        .byte   $5F                             ; 995C 5F                       _
        .byte   $74                             ; 995D 74                       t
        .byte   $37                             ; 995E 37                       7
        .byte   $64                             ; 995F 64                       d
        .byte   $7C                             ; 9960 7C                       |
        .byte   $37                             ; 9961 37                       7
L9962:  .byte   $3A                             ; 9962 3A                       :
        .byte   $64                             ; 9963 64                       d
        adc     ($75,x)                         ; 9964 61 75                    au
        .byte   $74                             ; 9966 74                       t
        .byte   $64                             ; 9967 64                       d
        .byte   $80                             ; 9968 80                       .
        sta     ($74,x)                         ; 9969 81 74                    .t
        .byte   $82                             ; 996B 82                       .
        bvs     L99DE                           ; 996C 70 70                    pp
        bvs     L99E0                           ; 996E 70 70                    pp
        sec                                     ; 9970 38                       8
        adc     ($83,x)                         ; 9971 61 83                    a.
        eor     $38                             ; 9973 45 38                    E8
        sec                                     ; 9975 38                       8
        sec                                     ; 9976 38                       8
        sec                                     ; 9977 38                       8
        sec                                     ; 9978 38                       8
        adc     ($83,x)                         ; 9979 61 83                    a.
        eor     $38                             ; 997B 45 38                    E8
        sec                                     ; 997D 38                       8
        sec                                     ; 997E 38                       8
        sec                                     ; 997F 38                       8
        rol     $373C,x                         ; 9980 3E 3C 37                 ><7
        .byte   $3C                             ; 9983 3C                       <
        .byte   $5B                             ; 9984 5B                       [
        rol     $387C,x                         ; 9985 3E 7C 38                 >|8
        rti                                     ; 9988 40                       @

; ----------------------------------------------------------------------------
        .byte   $37                             ; 9989 37                       7
        .byte   $3A                             ; 998A 3A                       :
        .byte   $3A                             ; 998B 3A                       :
        .byte   $37                             ; 998C 37                       7
        rti                                     ; 998D 40                       @

; ----------------------------------------------------------------------------
        .byte   $7C                             ; 998E 7C                       |
        sec                                     ; 998F 38                       8
        .byte   $7A                             ; 9990 7A                       z
        .byte   $7B                             ; 9991 7B                       {
        .byte   $37                             ; 9992 37                       7
        .byte   $37                             ; 9993 37                       7
        .byte   $37                             ; 9994 37                       7
        .byte   $37                             ; 9995 37                       7
        .byte   $7C                             ; 9996 7C                       |
        sec                                     ; 9997 38                       8
        .byte   $37                             ; 9998 37                       7
        .byte   $37                             ; 9999 37                       7
        .byte   $5F                             ; 999A 5F                       _
        sty     $73                             ; 999B 84 73                    .s
        .byte   $74                             ; 999D 74                       t
        .byte   $7C                             ; 999E 7C                       |
        sec                                     ; 999F 38                       8
        sty     $46                             ; 99A0 84 46                    .F
        bvs     L9A14                           ; 99A2 70 70                    pp
        adc     ($75),y                         ; 99A4 71 75                    qu
        sta     $38                             ; 99A6 85 38                    .8
        bvs     L99E2                           ; 99A8 70 38                    p8
        sec                                     ; 99AA 38                       8
        sec                                     ; 99AB 38                       8
        sec                                     ; 99AC 38                       8
        bvs     L9A1F                           ; 99AD 70 70                    pp
        sec                                     ; 99AF 38                       8
        sec                                     ; 99B0 38                       8
        sec                                     ; 99B1 38                       8
        sec                                     ; 99B2 38                       8
        sec                                     ; 99B3 38                       8
        sec                                     ; 99B4 38                       8
        sec                                     ; 99B5 38                       8
        sec                                     ; 99B6 38                       8
        sec                                     ; 99B7 38                       8
        sec                                     ; 99B8 38                       8
        sec                                     ; 99B9 38                       8
        sec                                     ; 99BA 38                       8
        sec                                     ; 99BB 38                       8
        sec                                     ; 99BC 38                       8
        sec                                     ; 99BD 38                       8
        sec                                     ; 99BE 38                       8
        sec                                     ; 99BF 38                       8
        and     $55                             ; 99C0 25 55                    %U
        lsr     a                               ; 99C2 4A                       J
        lsr     a                               ; 99C3 4A                       J
        lsr     a                               ; 99C4 4A                       J
        and     $25                             ; 99C5 25 25                    %%
        and     $25                             ; 99C7 25 25                    %%
        eor     $3C,x                           ; 99C9 55 3C                    U<
        .byte   $5B                             ; 99CB 5B                       [
        rol     $2525,x                         ; 99CC 3E 25 25                 >%%
        and     $25                             ; 99CF 25 25                    %%
        eor     $3A,x                           ; 99D1 55 3A                    U:
        .byte   $37                             ; 99D3 37                       7
        rti                                     ; 99D4 40                       @

; ----------------------------------------------------------------------------
        eor     ($25),y                         ; 99D5 51 25                    Q%
        and     $25                             ; 99D7 25 25                    %%
        rol     $3786                           ; 99D9 2E 86 37                 ..7
        .byte   $3A                             ; 99DC 3A                       :
        .byte   $3A                             ; 99DD 3A                       :
L99DE:  and     $25                             ; 99DE 25 25                    %%
L99E0:  and     $25                             ; 99E0 25 25                    %%
L99E2:  rol     $3786                           ; 99E2 2E 86 37                 ..7
        .byte   $37                             ; 99E5 37                       7
        lsr     a                               ; 99E6 4A                       J
        and     $25                             ; 99E7 25 25                    %%
        and     $25                             ; 99E9 25 25                    %%
        rol     $5F86                           ; 99EB 2E 86 5F                 .._
        sty     $25                             ; 99EE 84 25                    .%
        and     $25                             ; 99F0 25 25                    %%
        and     $25                             ; 99F2 25 25                    %%
        rol     L8724                           ; 99F4 2E 24 87                 .$.
        and     $51                             ; 99F7 25 51                    %Q
        eor     ($51),y                         ; 99F9 51 51                    QQ
        eor     ($51),y                         ; 99FB 51 51                    QQ
        eor     ($56),y                         ; 99FD 51 56                    QV
        and     $88                             ; 99FF 25 88                    %.
        .byte   $89                             ; 9A01 89                       .
        txa                                     ; 9A02 8A                       .
        ora     L0D0D                           ; 9A03 0D 0D 0D                 ...
        dey                                     ; 9A06 88                       .
        .byte   $89                             ; 9A07 89                       .
        ora     L0D0D                           ; 9A08 0D 0D 0D                 ...
        ora     L0D0D                           ; 9A0B 0D 0D 0D                 ...
        ora     L0D0D                           ; 9A0E 0D 0D 0D                 ...
        ora     L0D0D                           ; 9A11 0D 0D 0D                 ...
L9A14:  ora     L0D0D                           ; 9A14 0D 0D 0D                 ...
        ora     $178B                           ; 9A17 0D 8B 17                 ...
        asl     $12,x                           ; 9A1A 16 12                    ..
        sty     L8C12                           ; 9A1C 8C 12 8C                 ...
L9A1F:  .byte   $17                             ; 9A1F 17                       .
        sta     $1C1D                           ; 9A20 8D 1D 1C                 ...
        sta     L8D8E                           ; 9A23 8D 8E 8D                 ...
        sta     L8F1D                           ; 9A26 8D 1D 8F                 ...
        and     ($0D,x)                         ; 9A29 21 0D                    !.
        .byte   $8F                             ; 9A2B 8F                       .
        ora     L8F8F                           ; 9A2C 0D 8F 8F                 ...
        and     ($70,x)                         ; 9A2F 21 70                    !p
        bcc     L9A79                           ; 9A31 90 46                    .F
        bvs     L9AA5                           ; 9A33 70 70                    pp
        bvs     L9AA7                           ; 9A35 70 70                    pp
        adc     ($38),y                         ; 9A37 71 38                    q8
        .byte   $63                             ; 9A39 63                       c
        sec                                     ; 9A3A 38                       8
        sec                                     ; 9A3B 38                       8
        sec                                     ; 9A3C 38                       8
        sec                                     ; 9A3D 38                       8
        sec                                     ; 9A3E 38                       8
        sec                                     ; 9A3F 38                       8
        txa                                     ; 9A40 8A                       .
        ora     L0D0D                           ; 9A41 0D 0D 0D                 ...
        ora     L8988                           ; 9A44 0D 88 89                 ...
        txa                                     ; 9A47 8A                       .
        ora     L0D0D                           ; 9A48 0D 0D 0D                 ...
        ora     L0D0D                           ; 9A4B 0D 0D 0D                 ...
        ora     L0D0D                           ; 9A4E 0D 0D 0D                 ...
        ora     L0D0D                           ; 9A51 0D 0D 0D                 ...
        ora     L0D0D                           ; 9A54 0D 0D 0D                 ...
        ora     L9116                           ; 9A57 0D 16 91                 ...
        sty     L8C91                           ; 9A5A 8C 91 8C                 ...
        sta     ($8C),y                         ; 9A5D 91 8C                    ..
        sta     ($1C),y                         ; 9A5F 91 1C                    ..
        sta     L8D8D                           ; 9A61 8D 8D 8D                 ...
        .byte   $37                             ; 9A64 37                       7
        .byte   $37                             ; 9A65 37                       7
        .byte   $37                             ; 9A66 37                       7
        .byte   $37                             ; 9A67 37                       7
        ora     L8F8F                           ; 9A68 0D 8F 8F                 ...
        .byte   $92                             ; 9A6B 92                       .
        .byte   $93                             ; 9A6C 93                       .
        sty     $95,x                           ; 9A6D 94 95                    ..
        .byte   $93                             ; 9A6F 93                       .
        stx     $96,y                           ; 9A70 96 96                    ..
        stx     $96,y                           ; 9A72 96 96                    ..
        stx     $96,y                           ; 9A74 96 96                    ..
        stx     $96,y                           ; 9A76 96 96                    ..
        .byte   $97                             ; 9A78 97                       .
L9A79:  .byte   $97                             ; 9A79 97                       .
        .byte   $97                             ; 9A7A 97                       .
        .byte   $97                             ; 9A7B 97                       .
        .byte   $97                             ; 9A7C 97                       .
        .byte   $97                             ; 9A7D 97                       .
        .byte   $97                             ; 9A7E 97                       .
        .byte   $97                             ; 9A7F 97                       .
        ora     L880D                           ; 9A80 0D 0D 88                 ...
        .byte   $89                             ; 9A83 89                       .
        txa                                     ; 9A84 8A                       .
        ora     L0D0D                           ; 9A85 0D 0D 0D                 ...
        ora     L0D0D                           ; 9A88 0D 0D 0D                 ...
        ora     L0D0D                           ; 9A8B 0D 0D 0D                 ...
        ora     $260D                           ; 9A8E 0D 0D 26                 ..&
        tya                                     ; 9A91 98                       .
        sta     ($91),y                         ; 9A92 91 91                    ..
        sta     $1798,y                         ; 9A94 99 98 17                 ...
        sta     ($9A),y                         ; 9A97 91 9A                    ..
        .byte   $37                             ; 9A99 37                       7
        .byte   $37                             ; 9A9A 37                       7
        .byte   $37                             ; 9A9B 37                       7
        .byte   $37                             ; 9A9C 37                       7
        .byte   $37                             ; 9A9D 37                       7
        .byte   $9B                             ; 9A9E 9B                       .
        .byte   $37                             ; 9A9F 37                       7
        .byte   $37                             ; 9AA0 37                       7
        .byte   $37                             ; 9AA1 37                       7
        .byte   $9C                             ; 9AA2 9C                       .
        .byte   $9D                             ; 9AA3 9D                       .
        .byte   $9D                             ; 9AA4 9D                       .
L9AA5:  .byte   $9D                             ; 9AA5 9D                       .
        .byte   $9D                             ; 9AA6 9D                       .
L9AA7:  .byte   $37                             ; 9AA7 37                       7
        sty     $93,x                           ; 9AA8 94 93                    ..
        .byte   $9E                             ; 9AAA 9E                       .
        .byte   $9F                             ; 9AAB 9F                       .
        .byte   $9F                             ; 9AAC 9F                       .
        ldy     #$A0                            ; 9AAD A0 A0                    ..
        .byte   $37                             ; 9AAF 37                       7
        stx     $96,y                           ; 9AB0 96 96                    ..
        stx     $96,y                           ; 9AB2 96 96                    ..
        stx     $96,y                           ; 9AB4 96 96                    ..
        stx     $A1,y                           ; 9AB6 96 A1                    ..
        .byte   $97                             ; 9AB8 97                       .
        .byte   $97                             ; 9AB9 97                       .
        .byte   $97                             ; 9ABA 97                       .
        .byte   $97                             ; 9ABB 97                       .
        .byte   $97                             ; 9ABC 97                       .
        .byte   $97                             ; 9ABD 97                       .
        ldx     #$A3                            ; 9ABE A2 A3                    ..
        ldy     $A4                             ; 9AC0 A4 A4                    ..
        ldy     $A4                             ; 9AC2 A4 A4                    ..
        lda     $A6                             ; 9AC4 A5 A6                    ..
        ldx     $A3                             ; 9AC6 A6 A3                    ..
        .byte   $97                             ; 9AC8 97                       .
        .byte   $97                             ; 9AC9 97                       .
        .byte   $97                             ; 9ACA 97                       .
        ldx     #$A6                            ; 9ACB A2 A6                    ..
        .byte   $A3                             ; 9ACD A3                       .
        .byte   $A3                             ; 9ACE A3                       .
        .byte   $A3                             ; 9ACF A3                       .
        ldy     $A7                             ; 9AD0 A4 A7                    ..
        tay                                     ; 9AD2 A8                       .
        lda     #$A3                            ; 9AD3 A9 A3                    ..
        .byte   $A3                             ; 9AD5 A3                       .
        .byte   $A3                             ; 9AD6 A3                       .
        .byte   $A3                             ; 9AD7 A3                       .
        tax                                     ; 9AD8 AA                       .
        .byte   $AB                             ; 9AD9 AB                       .
        ldy     $A3AD                           ; 9ADA AC AD A3                 ...
        ldx     $AEAE                           ; 9ADD AE AE AE                 ...
        .byte   $AF                             ; 9AE0 AF                       .
        ldy     #$B0                            ; 9AE1 A0 B0                    ..
        lda     ($A3),y                         ; 9AE3 B1 A3                    ..
        .byte   $B2                             ; 9AE5 B2                       .
        .byte   $B2                             ; 9AE6 B2                       .
        .byte   $B3                             ; 9AE7 B3                       .
        ldy     $A3,x                           ; 9AE8 B4 A3                    ..
        stx     $96,y                           ; 9AEA 96 96                    ..
        .byte   $A3                             ; 9AEC A3                       .
        .byte   $A3                             ; 9AED A3                       .
        .byte   $A3                             ; 9AEE A3                       .
        lda     $B6,x                           ; 9AEF B5 B6                    ..
        .byte   $A3                             ; 9AF1 A3                       .
        lda     $97,x                           ; 9AF2 B5 97                    ..
        stx     $96,y                           ; 9AF4 96 96                    ..
        stx     $B7,y                           ; 9AF6 96 B7                    ..
        clv                                     ; 9AF8 B8                       .
        .byte   $A3                             ; 9AF9 A3                       .
        lda     $BABA,y                         ; 9AFA B9 BA BA                 ...
        tsx                                     ; 9AFD BA                       .
        tsx                                     ; 9AFE BA                       .
        tsx                                     ; 9AFF BA                       .
        .byte   $BB                             ; 9B00 BB                       .
        ldy     $A4BD,x                         ; 9B01 BC BD A4                 ...
        ldy     $A4                             ; 9B04 A4 A4                    ..
        ldy     $A4                             ; 9B06 A4 A4                    ..
        ldx     $BF37,y                         ; 9B08 BE 37 BF                 .7.
        .byte   $97                             ; 9B0B 97                       .
        .byte   $97                             ; 9B0C 97                       .
        .byte   $97                             ; 9B0D 97                       .
        .byte   $97                             ; 9B0E 97                       .
        .byte   $97                             ; 9B0F 97                       .
        ldy     $37,x                           ; 9B10 B4 37                    .7
        cpy     #$A4                            ; 9B12 C0 A4                    ..
        ldy     $A4                             ; 9B14 A4 A4                    ..
        ldy     $A4                             ; 9B16 A4 A4                    ..
        cmp     ($A1,x)                         ; 9B18 C1 A1                    ..
        .byte   $C2                             ; 9B1A C2                       .
        .byte   $97                             ; 9B1B 97                       .
        .byte   $97                             ; 9B1C 97                       .
        .byte   $97                             ; 9B1D 97                       .
        .byte   $97                             ; 9B1E 97                       .
        .byte   $97                             ; 9B1F 97                       .
        .byte   $BB                             ; 9B20 BB                       .
        .byte   $A3                             ; 9B21 A3                       .
        .byte   $B7                             ; 9B22 B7                       .
        tay                                     ; 9B23 A8                       .
        tay                                     ; 9B24 A8                       .
        tay                                     ; 9B25 A8                       .
        tay                                     ; 9B26 A8                       .
        tay                                     ; 9B27 A8                       .
L9B28:  ldx     $A0A3,y                         ; 9B28 BE A3 A0                 ...
        ldy     $AD37                           ; 9B2B AC 37 AD                 .7.
        ldy     #$A0                            ; 9B2E A0 A0                    ..
        stx     $96,y                           ; 9B30 96 96                    ..
        stx     $96,y                           ; 9B32 96 96                    ..
        stx     $96,y                           ; 9B34 96 96                    ..
        stx     $96,y                           ; 9B36 96 96                    ..
        .byte   $97                             ; 9B38 97                       .
        .byte   $97                             ; 9B39 97                       .
        .byte   $97                             ; 9B3A 97                       .
        .byte   $97                             ; 9B3B 97                       .
        .byte   $97                             ; 9B3C 97                       .
        .byte   $97                             ; 9B3D 97                       .
        .byte   $97                             ; 9B3E 97                       .
        .byte   $97                             ; 9B3F 97                       .
        ldy     $A4                             ; 9B40 A4 A4                    ..
        ldy     $A4                             ; 9B42 A4 A4                    ..
        ldy     $A4                             ; 9B44 A4 A4                    ..
        ldy     $A4                             ; 9B46 A4 A4                    ..
        .byte   $97                             ; 9B48 97                       .
        .byte   $97                             ; 9B49 97                       .
        .byte   $97                             ; 9B4A 97                       .
        tax                                     ; 9B4B AA                       .
        .byte   $C3                             ; 9B4C C3                       .
        cpy     $C5                             ; 9B4D C4 C5                    ..
        cmp     $A4                             ; 9B4F C5 A4                    ..
        dec     $C5                             ; 9B51 C6 C5                    ..
        ldx     $A0                             ; 9B53 A6 A0                    ..
        ldy     #$BC                            ; 9B55 A0 BC                    ..
        ldy     $C797,x                         ; 9B57 BC 97 C7                 ...
        .byte   $A3                             ; 9B5A A3                       .
        .byte   $A3                             ; 9B5B A3                       .
        .byte   $A3                             ; 9B5C A3                       .
        .byte   $A3                             ; 9B5D A3                       .
        bcs     L9B28                           ; 9B5E B0 C8                    ..
        tay                                     ; 9B60 A8                       .
        lda     #$BC                            ; 9B61 A9 BC                    ..
        ldy     $BCBC,x                         ; 9B63 BC BC BC                 ...
        bcs     L9B9F                           ; 9B66 B0 37                    .7
        ldy     #$A0                            ; 9B68 A0 A0                    ..
        .byte   $A3                             ; 9B6A A3                       .
        cmp     #$AE                            ; 9B6B C9 AE                    ..
        ldx     $CAB0                           ; 9B6D AE B0 CA                 ...
        stx     $96,y                           ; 9B70 96 96                    ..
        stx     $96,y                           ; 9B72 96 96                    ..
        .byte   $B3                             ; 9B74 B3                       .
        .byte   $B3                             ; 9B75 B3                       .
        ldx     L97AE                           ; 9B76 AE AE 97                 ...
        .byte   $97                             ; 9B79 97                       .
        .byte   $97                             ; 9B7A 97                       .
        .byte   $97                             ; 9B7B 97                       .
        .byte   $97                             ; 9B7C 97                       .
        .byte   $97                             ; 9B7D 97                       .
        tsx                                     ; 9B7E BA                       .
        tsx                                     ; 9B7F BA                       .
        ldy     $A4                             ; 9B80 A4 A4                    ..
        ldy     $A4                             ; 9B82 A4 A4                    ..
        ldy     $A4                             ; 9B84 A4 A4                    ..
        ldy     $A4                             ; 9B86 A4 A4                    ..
        cmp     $C5                             ; 9B88 C5 C5                    ..
        cmp     $C5                             ; 9B8A C5 C5                    ..
        cmp     $C5                             ; 9B8C C5 C5                    ..
        cmp     $CB                             ; 9B8E C5 CB                    ..
        ldy     $BCBC,x                         ; 9B90 BC BC BC                 ...
        ldy     $BCBC,x                         ; 9B93 BC BC BC                 ...
        .byte   $A3                             ; 9B96 A3                       .
        cpy     $C8C8                           ; 9B97 CC C8 C8                 ...
L9B9A:  iny                                     ; 9B9A C8                       .
        iny                                     ; 9B9B C8                       .
        iny                                     ; 9B9C C8                       .
        lda     ($BC),y                         ; 9B9D B1 BC                    ..
L9B9F:  cmp     $3737                           ; 9B9F CD 37 37                 .77
        .byte   $37                             ; 9BA2 37                       7
        .byte   $37                             ; 9BA3 37                       7
        .byte   $37                             ; 9BA4 37                       7
        lda     ($A3),y                         ; 9BA5 B1 A3                    ..
        dec     $CACF                           ; 9BA7 CE CF CA                 ...
        .byte   $CF                             ; 9BAA CF                       .
        dex                                     ; 9BAB CA                       .
        .byte   $CF                             ; 9BAC CF                       .
        lda     ($A3),y                         ; 9BAD B1 A3                    ..
        dec     $AEAE                           ; 9BAF CE AE AE                 ...
        stx     $94,y                           ; 9BB2 96 94                    ..
        .byte   $93                             ; 9BB4 93                       .
        stx     $D0,y                           ; 9BB5 96 D0                    ..
        cmp     ($BA),y                         ; 9BB7 D1 BA                    ..
        tsx                                     ; 9BB9 BA                       .
        tsx                                     ; 9BBA BA                       .
        tsx                                     ; 9BBB BA                       .
        tsx                                     ; 9BBC BA                       .
        tsx                                     ; 9BBD BA                       .
        .byte   $D2                             ; 9BBE D2                       .
        cpy     $A4A4                           ; 9BBF CC A4 A4                 ...
        ldy     $D3                             ; 9BC2 A4 D3                    ..
        tay                                     ; 9BC4 A8                       .
        tay                                     ; 9BC5 A8                       .
        .byte   $D4                             ; 9BC6 D4                       .
        cmp     $97,x                           ; 9BC7 D5 97                    ..
        tax                                     ; 9BC9 AA                       .
        .byte   $C3                             ; 9BCA C3                       .
        dec     $A0,x                           ; 9BCB D6 A0                    ..
        ldy     #$D7                            ; 9BCD A0 D7                    ..
        dec     $C1A4                           ; 9BCF CE A4 C1                 ...
        cld                                     ; 9BD2 D8                       .
        cmp     L96D1,y                         ; 9BD3 D9 D1 96                 ...
L9BD6:  stx     $96,y                           ; 9BD6 96 96                    ..
        .byte   $97                             ; 9BD8 97                       .
        .byte   $BB                             ; 9BD9 BB                       .
        .byte   $A3                             ; 9BDA A3                       .
        .byte   $A3                             ; 9BDB A3                       .
        cmp     $97,x                           ; 9BDC D5 97                    ..
        .byte   $97                             ; 9BDE 97                       .
        .byte   $97                             ; 9BDF 97                       .
        .byte   $D3                             ; 9BE0 D3                       .
        lda     #$BC                            ; 9BE1 A9 BC                    ..
        stx     $96,y                           ; 9BE3 96 96                    ..
        ldy     $A4                             ; 9BE5 A4 A4                    ..
L9BE7:  ldy     $DA                             ; 9BE7 A4 DA                    ..
        ldy     #$A3                            ; 9BE9 A0 A3                    ..
        .byte   $DB                             ; 9BEB DB                       .
        .byte   $97                             ; 9BEC 97                       .
        .byte   $97                             ; 9BED 97                       .
        .byte   $97                             ; 9BEE 97                       .
        .byte   $97                             ; 9BEF 97                       .
        .byte   $DC                             ; 9BF0 DC                       .
        cmp     ($93),y                         ; 9BF1 D1 93                    ..
        cmp     $A4A4,x                         ; 9BF3 DD A4 A4                 ...
        ldy     $A4                             ; 9BF6 A4 A4                    ..
        .byte   $DE                             ; 9BF8 DE                       .
L9BF9:  cpy     $BABA                           ; 9BF9 CC BA BA                 ...
        tsx                                     ; 9BFC BA                       .
        tsx                                     ; 9BFD BA                       .
        tsx                                     ; 9BFE BA                       .
        tsx                                     ; 9BFF BA                       .
        dec     $AACC,x                         ; 9C00 DE CC AA                 ...
        .byte   $C3                             ; 9C03 C3                       .
        .byte   $C3                             ; 9C04 C3                       .
        .byte   $C3                             ; 9C05 C3                       .
        .byte   $C3                             ; 9C06 C3                       .
        .byte   $C3                             ; 9C07 C3                       .
        .byte   $DF                             ; 9C08 DF                       .
        cpx     #$A6                            ; 9C09 E0 A6                    ..
        ldy     #$A0                            ; 9C0B A0 A0                    ..
        ldy     #$A0                            ; 9C0D A0 A0                    ..
        ldy     #$D2                            ; 9C0F A0 D2                    ..
        ldy     $BCBC,x                         ; 9C11 BC BC BC                 ...
        ldy     $BCBC,x                         ; 9C14 BC BC BC                 ...
        ldy     $E1DC,x                         ; 9C17 BC DC E1                 ...
        .byte   $A3                             ; 9C1A A3                       .
        .byte   $A3                             ; 9C1B A3                       .
        .byte   $A3                             ; 9C1C A3                       .
        bcs     L9BE7                           ; 9C1D B0 C8                    ..
        iny                                     ; 9C1F C8                       .
        dec     $BCE1,x                         ; 9C20 DE E1 BC                 ...
        ldy     $B0BC,x                         ; 9C23 BC BC B0                 ...
        .byte   $37                             ; 9C26 37                       7
        .byte   $37                             ; 9C27 37                       7
        dec     $E1E1,x                         ; 9C28 DE E1 E1                 ...
        .byte   $A3                             ; 9C2B A3                       .
        .byte   $A3                             ; 9C2C A3                       .
        bcs     L9BF9                           ; 9C2D B0 CA                    ..
L9C2F:  .byte   $CF                             ; 9C2F CF                       .
        stx     $96,y                           ; 9C30 96 96                    ..
        sbc     ($96,x)                         ; 9C32 E1 96                    ..
        stx     $B0,y                           ; 9C34 96 B0                    ..
        stx     $96,y                           ; 9C36 96 96                    ..
        .byte   $97                             ; 9C38 97                       .
        .byte   $97                             ; 9C39 97                       .
        sbc     ($97,x)                         ; 9C3A E1 97                    ..
        .byte   $97                             ; 9C3C 97                       .
        bcs     L9BD6                           ; 9C3D B0 97                    ..
        .byte   $97                             ; 9C3F 97                       .
        .byte   $C3                             ; 9C40 C3                       .
        .byte   $C3                             ; 9C41 C3                       .
        .byte   $C3                             ; 9C42 C3                       .
        .byte   $C3                             ; 9C43 C3                       .
        .byte   $C3                             ; 9C44 C3                       .
        .byte   $C3                             ; 9C45 C3                       .
        .byte   $E2                             ; 9C46 E2                       .
        .byte   $97                             ; 9C47 97                       .
        ldy     #$A0                            ; 9C48 A0 A0                    ..
        ldy     #$A0                            ; 9C4A A0 A0                    ..
        ldy     #$A0                            ; 9C4C A0 A0                    ..
        .byte   $E3                             ; 9C4E E3                       .
        cpx     $BC                             ; 9C4F E4 BC                    ..
L9C51:  ldy     $BCBC,x                         ; 9C51 BC BC BC                 ...
        ldy     $E5BC,x                         ; 9C54 BC BC E5                 ...
        inc     $C8                             ; 9C57 E6 C8                    ..
        lda     ($A3),y                         ; 9C59 B1 A3                    ..
        .byte   $E7                             ; 9C5B E7                       .
        tsx                                     ; 9C5C BA                       .
        inx                                     ; 9C5D E8                       .
        .byte   $A3                             ; 9C5E A3                       .
        ldy     $B137                           ; 9C5F AC 37 B1                 .7.
        sbc     #$EA                            ; 9C62 E9 EA                    ..
        ldy     $EB                             ; 9C64 A4 EB                    ..
        cpx     $CAB0                           ; 9C66 EC B0 CA                 ...
        .byte   $E7                             ; 9C69 E7                       .
        sbc     L9797                           ; 9C6A ED 97 97                 ...
        .byte   $97                             ; 9C6D 97                       .
        inc     L96E8                           ; 9C6E EE E8 96                 ...
        nop                                     ; 9C71 EA                       .
        ldy     $A4                             ; 9C72 A4 A4                    ..
        ldy     $A4                             ; 9C74 A4 A4                    ..
        ldy     $B6                             ; 9C76 A4 B6                    ..
        .byte   $97                             ; 9C78 97                       .
        .byte   $97                             ; 9C79 97                       .
        .byte   $97                             ; 9C7A 97                       .
        .byte   $97                             ; 9C7B 97                       .
        .byte   $97                             ; 9C7C 97                       .
        .byte   $97                             ; 9C7D 97                       .
        .byte   $97                             ; 9C7E 97                       .
        .byte   $EF                             ; 9C7F EF                       .
        .byte   $97                             ; 9C80 97                       .
        .byte   $97                             ; 9C81 97                       .
        .byte   $97                             ; 9C82 97                       .
        .byte   $97                             ; 9C83 97                       .
        .byte   $97                             ; 9C84 97                       .
        .byte   $97                             ; 9C85 97                       .
        .byte   $97                             ; 9C86 97                       .
        .byte   $97                             ; 9C87 97                       .
        ldy     $A4                             ; 9C88 A4 A4                    ..
        ldy     $A4                             ; 9C8A A4 A4                    ..
        ldy     $A4                             ; 9C8C A4 A4                    ..
        ldy     $A4                             ; 9C8E A4 A4                    ..
        .byte   $C3                             ; 9C90 C3                       .
        .byte   $C3                             ; 9C91 C3                       .
        .byte   $C3                             ; 9C92 C3                       .
        .byte   $C3                             ; 9C93 C3                       .
        .byte   $C3                             ; 9C94 C3                       .
        .byte   $C3                             ; 9C95 C3                       .
        beq     L9C2F                           ; 9C96 F0 97                    ..
        iny                                     ; 9C98 C8                       .
        lda     $A0A0                           ; 9C99 AD A0 A0                 ...
        ldy     #$A0                            ; 9C9C A0 A0                    ..
        cmp     $37A4,x                         ; 9C9E DD A4 37                 ..7
        lda     ($A3),y                         ; 9CA1 B1 A3                    ..
        .byte   $A3                             ; 9CA3 A3                       .
        .byte   $A3                             ; 9CA4 A3                       .
        .byte   $A3                             ; 9CA5 A3                       .
        sbc     ($F2),y                         ; 9CA6 F1 F2                    ..
        .byte   $37                             ; 9CA8 37                       7
        lda     ($F3),y                         ; 9CA9 B1 F3                    ..
        .byte   $A3                             ; 9CAB A3                       .
        bne     L9C51                           ; 9CAC D0 A3                    ..
        .byte   $A3                             ; 9CAE A3                       .
        .byte   $F4                             ; 9CAF F4                       .
        .byte   $37                             ; 9CB0 37                       7
        sbc     $CE,x                           ; 9CB1 F5 CE                    ..
        .byte   $A3                             ; 9CB3 A3                       .
        .byte   $D2                             ; 9CB4 D2                       .
L9CB5:  .byte   $F3                             ; 9CB5 F3                       .
        stx     $96,y                           ; 9CB6 96 96                    ..
        .byte   $37                             ; 9CB8 37                       7
        inc     $CE,x                           ; 9CB9 F6 CE                    ..
        .byte   $A3                             ; 9CBB A3                       .
        .byte   $D2                             ; 9CBC D2                       .
        dec     L9797                           ; 9CBD CE 97 97                 ...
        .byte   $97                             ; 9CC0 97                       .
        .byte   $97                             ; 9CC1 97                       .
        .byte   $97                             ; 9CC2 97                       .
        .byte   $97                             ; 9CC3 97                       .
        .byte   $97                             ; 9CC4 97                       .
        .byte   $97                             ; 9CC5 97                       .
        .byte   $97                             ; 9CC6 97                       .
        .byte   $97                             ; 9CC7 97                       .
        ldy     $A4                             ; 9CC8 A4 A4                    ..
        ldy     $A4                             ; 9CCA A4 A4                    ..
        ldy     $A4                             ; 9CCC A4 A4                    ..
L9CCE:  ldy     $A4                             ; 9CCE A4 A4                    ..
        .byte   $97                             ; 9CD0 97                       .
        .byte   $97                             ; 9CD1 97                       .
        .byte   $97                             ; 9CD2 97                       .
        .byte   $97                             ; 9CD3 97                       .
        .byte   $97                             ; 9CD4 97                       .
        .byte   $97                             ; 9CD5 97                       .
L9CD6:  .byte   $97                             ; 9CD6 97                       .
        .byte   $97                             ; 9CD7 97                       .
        ldy     $A4                             ; 9CD8 A4 A4                    ..
        ldy     $A4                             ; 9CDA A4 A4                    ..
        ldy     $A4                             ; 9CDC A4 A4                    ..
        ldy     $A4                             ; 9CDE A4 A4                    ..
        cmp     $F7                             ; 9CE0 C5 F7                    ..
        sed                                     ; 9CE2 F8                       .
        sed                                     ; 9CE3 F8                       .
        sbc     $C5C5,y                         ; 9CE4 F9 C5 C5                 ...
        .byte   $F2                             ; 9CE7 F2                       .
        .byte   $A3                             ; 9CE8 A3                       .
        bcs     L9CB5                           ; 9CE9 B0 CA                    ..
        .byte   $CF                             ; 9CEB CF                       .
        lda     ($A3),y                         ; 9CEC B1 A3                    ..
        .byte   $A3                             ; 9CEE A3                       .
        .byte   $F4                             ; 9CEF F4                       .
        stx     $96,y                           ; 9CF0 96 96                    ..
        stx     $96,y                           ; 9CF2 96 96                    ..
        .byte   $96                             ; 9CF4 96                       .
L9CF5:  stx     $96,y                           ; 9CF5 96 96                    ..
        stx     $97,y                           ; 9CF7 96 97                    ..
        .byte   $97                             ; 9CF9 97                       .
        .byte   $97                             ; 9CFA 97                       .
        .byte   $97                             ; 9CFB 97                       .
        .byte   $97                             ; 9CFC 97                       .
        .byte   $97                             ; 9CFD 97                       .
        .byte   $97                             ; 9CFE 97                       .
        .byte   $97                             ; 9CFF 97                       .
        .byte   $FA                             ; 9D00 FA                       .
        .byte   $C3                             ; 9D01 C3                       .
        .byte   $C3                             ; 9D02 C3                       .
        .byte   $C3                             ; 9D03 C3                       .
        .byte   $C3                             ; 9D04 C3                       .
        .byte   $C3                             ; 9D05 C3                       .
        .byte   $C3                             ; 9D06 C3                       .
        .byte   $FB                             ; 9D07 FB                       .
        .byte   $DA                             ; 9D08 DA                       .
        ldy     #$A0                            ; 9D09 A0 A0                    ..
        ldy     #$A0                            ; 9D0B A0 A0                    ..
        ldy     #$A0                            ; 9D0D A0 A0                    ..
        .byte   $FC                             ; 9D0F FC                       .
        .byte   $DC                             ; 9D10 DC                       .
        ldy     $BCBC,x                         ; 9D11 BC BC BC                 ...
        ldy     $BCBC,x                         ; 9D14 BC BC BC                 ...
        cmp     $DE,x                           ; 9D17 D5 DE                    ..
        bcs     L9D52                           ; 9D19 B0 37                    .7
        bcs     L9CCE                           ; 9D1B B0 B1                    ..
        .byte   $37                             ; 9D1D 37                       7
        lda     ($CE),y                         ; 9D1E B1 CE                    ..
        sbc     $37B0,x                         ; 9D20 FD B0 37                 ..7
        bcs     L9CD6                           ; 9D23 B0 B1                    ..
        .byte   $37                             ; 9D25 37                       7
        lda     ($CE),y                         ; 9D26 B1 CE                    ..
        .byte   $A3                             ; 9D28 A3                       .
        bcs     L9CF5                           ; 9D29 B0 CA                    ..
        .byte   $CF                             ; 9D2B CF                       .
        dex                                     ; 9D2C CA                       .
        .byte   $CF                             ; 9D2D CF                       .
        lda     ($CE),y                         ; 9D2E B1 CE                    ..
        stx     $96,y                           ; 9D30 96 96                    ..
        stx     $96,y                           ; 9D32 96 96                    ..
        stx     $96,y                           ; 9D34 96 96                    ..
        stx     $96,y                           ; 9D36 96 96                    ..
        .byte   $97                             ; 9D38 97                       .
        .byte   $97                             ; 9D39 97                       .
        .byte   $97                             ; 9D3A 97                       .
        .byte   $97                             ; 9D3B 97                       .
        .byte   $97                             ; 9D3C 97                       .
        .byte   $97                             ; 9D3D 97                       .
        .byte   $97                             ; 9D3E 97                       .
        .byte   $97                             ; 9D3F 97                       .
        .byte   $37                             ; 9D40 37                       7
        .byte   $37                             ; 9D41 37                       7
        .byte   $37                             ; 9D42 37                       7
        .byte   $37                             ; 9D43 37                       7
        .byte   $37                             ; 9D44 37                       7
        .byte   $37                             ; 9D45 37                       7
        .byte   $37                             ; 9D46 37                       7
        .byte   $37                             ; 9D47 37                       7
        .byte   $37                             ; 9D48 37                       7
        .byte   $37                             ; 9D49 37                       7
        .byte   $37                             ; 9D4A 37                       7
        .byte   $37                             ; 9D4B 37                       7
        .byte   $37                             ; 9D4C 37                       7
        .byte   $37                             ; 9D4D 37                       7
        .byte   $37                             ; 9D4E 37                       7
        .byte   $37                             ; 9D4F 37                       7
        .byte   $37                             ; 9D50 37                       7
        .byte   $37                             ; 9D51 37                       7
L9D52:  .byte   $37                             ; 9D52 37                       7
        .byte   $37                             ; 9D53 37                       7
        .byte   $37                             ; 9D54 37                       7
        .byte   $37                             ; 9D55 37                       7
        .byte   $37                             ; 9D56 37                       7
        .byte   $37                             ; 9D57 37                       7
        .byte   $37                             ; 9D58 37                       7
        .byte   $37                             ; 9D59 37                       7
        .byte   $37                             ; 9D5A 37                       7
        .byte   $37                             ; 9D5B 37                       7
        .byte   $37                             ; 9D5C 37                       7
        .byte   $37                             ; 9D5D 37                       7
        .byte   $37                             ; 9D5E 37                       7
        .byte   $37                             ; 9D5F 37                       7
        .byte   $37                             ; 9D60 37                       7
        .byte   $37                             ; 9D61 37                       7
        .byte   $37                             ; 9D62 37                       7
        .byte   $37                             ; 9D63 37                       7
        .byte   $37                             ; 9D64 37                       7
L9D65:  .byte   $37                             ; 9D65 37                       7
        .byte   $37                             ; 9D66 37                       7
        .byte   $37                             ; 9D67 37                       7
        .byte   $37                             ; 9D68 37                       7
        .byte   $37                             ; 9D69 37                       7
        .byte   $37                             ; 9D6A 37                       7
        .byte   $37                             ; 9D6B 37                       7
        .byte   $37                             ; 9D6C 37                       7
        .byte   $37                             ; 9D6D 37                       7
        .byte   $37                             ; 9D6E 37                       7
        .byte   $37                             ; 9D6F 37                       7
        .byte   $37                             ; 9D70 37                       7
        .byte   $37                             ; 9D71 37                       7
        .byte   $37                             ; 9D72 37                       7
        .byte   $37                             ; 9D73 37                       7
        .byte   $37                             ; 9D74 37                       7
        .byte   $37                             ; 9D75 37                       7
        .byte   $37                             ; 9D76 37                       7
        .byte   $37                             ; 9D77 37                       7
        .byte   $37                             ; 9D78 37                       7
        .byte   $37                             ; 9D79 37                       7
        .byte   $37                             ; 9D7A 37                       7
        .byte   $37                             ; 9D7B 37                       7
        .byte   $37                             ; 9D7C 37                       7
        .byte   $37                             ; 9D7D 37                       7
        .byte   $37                             ; 9D7E 37                       7
        .byte   $37                             ; 9D7F 37                       7
        .byte   $37                             ; 9D80 37                       7
        .byte   $37                             ; 9D81 37                       7
        .byte   $37                             ; 9D82 37                       7
        .byte   $37                             ; 9D83 37                       7
        .byte   $37                             ; 9D84 37                       7
        .byte   $37                             ; 9D85 37                       7
        .byte   $37                             ; 9D86 37                       7
        .byte   $37                             ; 9D87 37                       7
        .byte   $37                             ; 9D88 37                       7
        .byte   $37                             ; 9D89 37                       7
        .byte   $37                             ; 9D8A 37                       7
        .byte   $37                             ; 9D8B 37                       7
        .byte   $37                             ; 9D8C 37                       7
        .byte   $37                             ; 9D8D 37                       7
        .byte   $37                             ; 9D8E 37                       7
        .byte   $37                             ; 9D8F 37                       7
        .byte   $37                             ; 9D90 37                       7
        .byte   $37                             ; 9D91 37                       7
        .byte   $37                             ; 9D92 37                       7
        .byte   $37                             ; 9D93 37                       7
        .byte   $37                             ; 9D94 37                       7
        .byte   $37                             ; 9D95 37                       7
        .byte   $37                             ; 9D96 37                       7
        .byte   $37                             ; 9D97 37                       7
        .byte   $37                             ; 9D98 37                       7
        .byte   $37                             ; 9D99 37                       7
        .byte   $37                             ; 9D9A 37                       7
        .byte   $37                             ; 9D9B 37                       7
        .byte   $37                             ; 9D9C 37                       7
L9D9D:  .byte   $37                             ; 9D9D 37                       7
        .byte   $37                             ; 9D9E 37                       7
        .byte   $37                             ; 9D9F 37                       7
        .byte   $37                             ; 9DA0 37                       7
        .byte   $37                             ; 9DA1 37                       7
        .byte   $37                             ; 9DA2 37                       7
L9DA3:  .byte   $37                             ; 9DA3 37                       7
        .byte   $37                             ; 9DA4 37                       7
        .byte   $37                             ; 9DA5 37                       7
        .byte   $37                             ; 9DA6 37                       7
        .byte   $37                             ; 9DA7 37                       7
        .byte   $37                             ; 9DA8 37                       7
        .byte   $37                             ; 9DA9 37                       7
        .byte   $37                             ; 9DAA 37                       7
        .byte   $37                             ; 9DAB 37                       7
        .byte   $37                             ; 9DAC 37                       7
        .byte   $37                             ; 9DAD 37                       7
        .byte   $37                             ; 9DAE 37                       7
        .byte   $37                             ; 9DAF 37                       7
        .byte   $37                             ; 9DB0 37                       7
        .byte   $37                             ; 9DB1 37                       7
        .byte   $37                             ; 9DB2 37                       7
        .byte   $37                             ; 9DB3 37                       7
        .byte   $37                             ; 9DB4 37                       7
        .byte   $37                             ; 9DB5 37                       7
        .byte   $37                             ; 9DB6 37                       7
        .byte   $37                             ; 9DB7 37                       7
        .byte   $37                             ; 9DB8 37                       7
        .byte   $37                             ; 9DB9 37                       7
        .byte   $37                             ; 9DBA 37                       7
        .byte   $37                             ; 9DBB 37                       7
        .byte   $37                             ; 9DBC 37                       7
        .byte   $37                             ; 9DBD 37                       7
        .byte   $37                             ; 9DBE 37                       7
        .byte   $37                             ; 9DBF 37                       7
        .byte   $37                             ; 9DC0 37                       7
        .byte   $37                             ; 9DC1 37                       7
        .byte   $37                             ; 9DC2 37                       7
        .byte   $37                             ; 9DC3 37                       7
        .byte   $37                             ; 9DC4 37                       7
        .byte   $37                             ; 9DC5 37                       7
        .byte   $37                             ; 9DC6 37                       7
        .byte   $37                             ; 9DC7 37                       7
        .byte   $37                             ; 9DC8 37                       7
        .byte   $37                             ; 9DC9 37                       7
        .byte   $37                             ; 9DCA 37                       7
        .byte   $37                             ; 9DCB 37                       7
        .byte   $37                             ; 9DCC 37                       7
        .byte   $37                             ; 9DCD 37                       7
        .byte   $37                             ; 9DCE 37                       7
        .byte   $37                             ; 9DCF 37                       7
        .byte   $37                             ; 9DD0 37                       7
        .byte   $37                             ; 9DD1 37                       7
        .byte   $37                             ; 9DD2 37                       7
        .byte   $37                             ; 9DD3 37                       7
        .byte   $37                             ; 9DD4 37                       7
        .byte   $37                             ; 9DD5 37                       7
        .byte   $37                             ; 9DD6 37                       7
        .byte   $37                             ; 9DD7 37                       7
        .byte   $37                             ; 9DD8 37                       7
        .byte   $37                             ; 9DD9 37                       7
        .byte   $37                             ; 9DDA 37                       7
        .byte   $37                             ; 9DDB 37                       7
        .byte   $37                             ; 9DDC 37                       7
        .byte   $37                             ; 9DDD 37                       7
        .byte   $37                             ; 9DDE 37                       7
        .byte   $37                             ; 9DDF 37                       7
        .byte   $37                             ; 9DE0 37                       7
        .byte   $37                             ; 9DE1 37                       7
        .byte   $37                             ; 9DE2 37                       7
        .byte   $37                             ; 9DE3 37                       7
        .byte   $37                             ; 9DE4 37                       7
        .byte   $37                             ; 9DE5 37                       7
        .byte   $37                             ; 9DE6 37                       7
        .byte   $37                             ; 9DE7 37                       7
        .byte   $37                             ; 9DE8 37                       7
        .byte   $37                             ; 9DE9 37                       7
        .byte   $37                             ; 9DEA 37                       7
        .byte   $37                             ; 9DEB 37                       7
        .byte   $37                             ; 9DEC 37                       7
        .byte   $37                             ; 9DED 37                       7
        .byte   $37                             ; 9DEE 37                       7
        .byte   $37                             ; 9DEF 37                       7
        .byte   $37                             ; 9DF0 37                       7
        .byte   $37                             ; 9DF1 37                       7
        .byte   $37                             ; 9DF2 37                       7
        .byte   $37                             ; 9DF3 37                       7
        .byte   $37                             ; 9DF4 37                       7
        .byte   $37                             ; 9DF5 37                       7
        .byte   $37                             ; 9DF6 37                       7
        .byte   $37                             ; 9DF7 37                       7
        .byte   $37                             ; 9DF8 37                       7
        .byte   $37                             ; 9DF9 37                       7
        .byte   $37                             ; 9DFA 37                       7
        .byte   $37                             ; 9DFB 37                       7
        .byte   $37                             ; 9DFC 37                       7
        .byte   $37                             ; 9DFD 37                       7
        .byte   $37                             ; 9DFE 37                       7
        .byte   $37                             ; 9DFF 37                       7
        .byte   $37                             ; 9E00 37                       7
        .byte   $37                             ; 9E01 37                       7
        .byte   $37                             ; 9E02 37                       7
        .byte   $37                             ; 9E03 37                       7
        .byte   $37                             ; 9E04 37                       7
        .byte   $37                             ; 9E05 37                       7
        .byte   $37                             ; 9E06 37                       7
        .byte   $37                             ; 9E07 37                       7
        .byte   $37                             ; 9E08 37                       7
        .byte   $37                             ; 9E09 37                       7
        .byte   $37                             ; 9E0A 37                       7
        .byte   $37                             ; 9E0B 37                       7
        .byte   $37                             ; 9E0C 37                       7
        .byte   $37                             ; 9E0D 37                       7
        .byte   $37                             ; 9E0E 37                       7
        .byte   $37                             ; 9E0F 37                       7
        .byte   $37                             ; 9E10 37                       7
        .byte   $37                             ; 9E11 37                       7
        .byte   $37                             ; 9E12 37                       7
        .byte   $37                             ; 9E13 37                       7
        .byte   $37                             ; 9E14 37                       7
        .byte   $37                             ; 9E15 37                       7
        .byte   $37                             ; 9E16 37                       7
        .byte   $37                             ; 9E17 37                       7
        .byte   $37                             ; 9E18 37                       7
        .byte   $37                             ; 9E19 37                       7
        .byte   $37                             ; 9E1A 37                       7
        .byte   $37                             ; 9E1B 37                       7
        .byte   $37                             ; 9E1C 37                       7
        .byte   $37                             ; 9E1D 37                       7
        .byte   $37                             ; 9E1E 37                       7
        .byte   $37                             ; 9E1F 37                       7
        .byte   $37                             ; 9E20 37                       7
        .byte   $37                             ; 9E21 37                       7
        .byte   $37                             ; 9E22 37                       7
        .byte   $37                             ; 9E23 37                       7
        .byte   $37                             ; 9E24 37                       7
        .byte   $37                             ; 9E25 37                       7
        .byte   $37                             ; 9E26 37                       7
        .byte   $37                             ; 9E27 37                       7
        .byte   $37                             ; 9E28 37                       7
        .byte   $37                             ; 9E29 37                       7
        .byte   $37                             ; 9E2A 37                       7
        .byte   $37                             ; 9E2B 37                       7
        .byte   $37                             ; 9E2C 37                       7
        .byte   $37                             ; 9E2D 37                       7
        .byte   $37                             ; 9E2E 37                       7
        .byte   $37                             ; 9E2F 37                       7
        .byte   $37                             ; 9E30 37                       7
        .byte   $37                             ; 9E31 37                       7
        .byte   $37                             ; 9E32 37                       7
        .byte   $37                             ; 9E33 37                       7
        .byte   $37                             ; 9E34 37                       7
        .byte   $37                             ; 9E35 37                       7
        .byte   $37                             ; 9E36 37                       7
        .byte   $37                             ; 9E37 37                       7
        .byte   $37                             ; 9E38 37                       7
        .byte   $37                             ; 9E39 37                       7
        .byte   $37                             ; 9E3A 37                       7
        .byte   $37                             ; 9E3B 37                       7
        .byte   $37                             ; 9E3C 37                       7
        .byte   $37                             ; 9E3D 37                       7
        .byte   $37                             ; 9E3E 37                       7
        .byte   $37                             ; 9E3F 37                       7
        .byte   $37                             ; 9E40 37                       7
        .byte   $37                             ; 9E41 37                       7
        .byte   $37                             ; 9E42 37                       7
        .byte   $37                             ; 9E43 37                       7
        .byte   $37                             ; 9E44 37                       7
        .byte   $37                             ; 9E45 37                       7
        .byte   $37                             ; 9E46 37                       7
        .byte   $37                             ; 9E47 37                       7
        .byte   $37                             ; 9E48 37                       7
        .byte   $37                             ; 9E49 37                       7
        .byte   $37                             ; 9E4A 37                       7
        .byte   $37                             ; 9E4B 37                       7
        .byte   $37                             ; 9E4C 37                       7
        .byte   $37                             ; 9E4D 37                       7
        .byte   $37                             ; 9E4E 37                       7
        .byte   $37                             ; 9E4F 37                       7
        .byte   $37                             ; 9E50 37                       7
        .byte   $37                             ; 9E51 37                       7
        .byte   $37                             ; 9E52 37                       7
        .byte   $37                             ; 9E53 37                       7
        .byte   $37                             ; 9E54 37                       7
        .byte   $37                             ; 9E55 37                       7
        .byte   $37                             ; 9E56 37                       7
        .byte   $37                             ; 9E57 37                       7
        .byte   $37                             ; 9E58 37                       7
        .byte   $37                             ; 9E59 37                       7
        .byte   $37                             ; 9E5A 37                       7
        .byte   $37                             ; 9E5B 37                       7
        .byte   $37                             ; 9E5C 37                       7
        .byte   $37                             ; 9E5D 37                       7
        .byte   $37                             ; 9E5E 37                       7
        .byte   $37                             ; 9E5F 37                       7
        .byte   $37                             ; 9E60 37                       7
        .byte   $37                             ; 9E61 37                       7
        .byte   $37                             ; 9E62 37                       7
        .byte   $37                             ; 9E63 37                       7
        .byte   $37                             ; 9E64 37                       7
        .byte   $37                             ; 9E65 37                       7
        .byte   $37                             ; 9E66 37                       7
        .byte   $37                             ; 9E67 37                       7
        .byte   $37                             ; 9E68 37                       7
        .byte   $37                             ; 9E69 37                       7
        .byte   $37                             ; 9E6A 37                       7
        .byte   $37                             ; 9E6B 37                       7
        .byte   $37                             ; 9E6C 37                       7
        .byte   $37                             ; 9E6D 37                       7
        .byte   $37                             ; 9E6E 37                       7
        .byte   $37                             ; 9E6F 37                       7
        .byte   $37                             ; 9E70 37                       7
        .byte   $37                             ; 9E71 37                       7
        .byte   $37                             ; 9E72 37                       7
        .byte   $37                             ; 9E73 37                       7
        .byte   $37                             ; 9E74 37                       7
        .byte   $37                             ; 9E75 37                       7
        .byte   $37                             ; 9E76 37                       7
        .byte   $37                             ; 9E77 37                       7
        .byte   $37                             ; 9E78 37                       7
        .byte   $37                             ; 9E79 37                       7
        .byte   $37                             ; 9E7A 37                       7
        .byte   $37                             ; 9E7B 37                       7
        .byte   $37                             ; 9E7C 37                       7
        .byte   $37                             ; 9E7D 37                       7
        .byte   $37                             ; 9E7E 37                       7
        .byte   $37                             ; 9E7F 37                       7
        .byte   $37                             ; 9E80 37                       7
        .byte   $37                             ; 9E81 37                       7
        .byte   $37                             ; 9E82 37                       7
        .byte   $37                             ; 9E83 37                       7
        .byte   $37                             ; 9E84 37                       7
        .byte   $37                             ; 9E85 37                       7
        .byte   $37                             ; 9E86 37                       7
        .byte   $37                             ; 9E87 37                       7
        .byte   $37                             ; 9E88 37                       7
        .byte   $37                             ; 9E89 37                       7
        .byte   $37                             ; 9E8A 37                       7
        .byte   $37                             ; 9E8B 37                       7
        .byte   $37                             ; 9E8C 37                       7
        .byte   $37                             ; 9E8D 37                       7
        .byte   $37                             ; 9E8E 37                       7
        .byte   $37                             ; 9E8F 37                       7
        .byte   $37                             ; 9E90 37                       7
        .byte   $37                             ; 9E91 37                       7
        .byte   $37                             ; 9E92 37                       7
        .byte   $37                             ; 9E93 37                       7
        .byte   $37                             ; 9E94 37                       7
        .byte   $37                             ; 9E95 37                       7
        .byte   $37                             ; 9E96 37                       7
        .byte   $37                             ; 9E97 37                       7
        .byte   $37                             ; 9E98 37                       7
        .byte   $37                             ; 9E99 37                       7
        .byte   $37                             ; 9E9A 37                       7
        .byte   $37                             ; 9E9B 37                       7
        .byte   $37                             ; 9E9C 37                       7
        .byte   $37                             ; 9E9D 37                       7
        .byte   $37                             ; 9E9E 37                       7
        .byte   $37                             ; 9E9F 37                       7
        .byte   $37                             ; 9EA0 37                       7
        .byte   $37                             ; 9EA1 37                       7
        .byte   $37                             ; 9EA2 37                       7
        .byte   $37                             ; 9EA3 37                       7
        .byte   $37                             ; 9EA4 37                       7
        .byte   $37                             ; 9EA5 37                       7
        .byte   $37                             ; 9EA6 37                       7
        .byte   $37                             ; 9EA7 37                       7
        .byte   $37                             ; 9EA8 37                       7
        .byte   $37                             ; 9EA9 37                       7
        .byte   $37                             ; 9EAA 37                       7
        .byte   $37                             ; 9EAB 37                       7
        .byte   $37                             ; 9EAC 37                       7
        .byte   $37                             ; 9EAD 37                       7
        .byte   $37                             ; 9EAE 37                       7
        .byte   $37                             ; 9EAF 37                       7
        .byte   $37                             ; 9EB0 37                       7
        .byte   $37                             ; 9EB1 37                       7
        .byte   $37                             ; 9EB2 37                       7
        .byte   $37                             ; 9EB3 37                       7
        .byte   $37                             ; 9EB4 37                       7
        .byte   $37                             ; 9EB5 37                       7
        .byte   $37                             ; 9EB6 37                       7
        .byte   $37                             ; 9EB7 37                       7
        .byte   $37                             ; 9EB8 37                       7
        .byte   $37                             ; 9EB9 37                       7
        .byte   $37                             ; 9EBA 37                       7
        .byte   $37                             ; 9EBB 37                       7
        .byte   $37                             ; 9EBC 37                       7
        .byte   $37                             ; 9EBD 37                       7
        .byte   $37                             ; 9EBE 37                       7
        .byte   $37                             ; 9EBF 37                       7
        .byte   $37                             ; 9EC0 37                       7
        .byte   $37                             ; 9EC1 37                       7
        .byte   $37                             ; 9EC2 37                       7
        .byte   $37                             ; 9EC3 37                       7
        .byte   $37                             ; 9EC4 37                       7
        .byte   $37                             ; 9EC5 37                       7
        .byte   $37                             ; 9EC6 37                       7
        .byte   $37                             ; 9EC7 37                       7
        .byte   $37                             ; 9EC8 37                       7
        .byte   $37                             ; 9EC9 37                       7
        .byte   $37                             ; 9ECA 37                       7
        .byte   $37                             ; 9ECB 37                       7
        .byte   $37                             ; 9ECC 37                       7
        .byte   $37                             ; 9ECD 37                       7
        .byte   $37                             ; 9ECE 37                       7
        .byte   $37                             ; 9ECF 37                       7
        .byte   $37                             ; 9ED0 37                       7
        .byte   $37                             ; 9ED1 37                       7
        .byte   $37                             ; 9ED2 37                       7
        .byte   $37                             ; 9ED3 37                       7
        .byte   $37                             ; 9ED4 37                       7
        .byte   $37                             ; 9ED5 37                       7
        .byte   $37                             ; 9ED6 37                       7
        .byte   $37                             ; 9ED7 37                       7
        .byte   $37                             ; 9ED8 37                       7
        .byte   $37                             ; 9ED9 37                       7
        .byte   $37                             ; 9EDA 37                       7
        .byte   $37                             ; 9EDB 37                       7
        .byte   $37                             ; 9EDC 37                       7
        .byte   $37                             ; 9EDD 37                       7
        .byte   $37                             ; 9EDE 37                       7
        .byte   $37                             ; 9EDF 37                       7
        .byte   $37                             ; 9EE0 37                       7
        .byte   $37                             ; 9EE1 37                       7
        .byte   $37                             ; 9EE2 37                       7
        .byte   $37                             ; 9EE3 37                       7
        .byte   $37                             ; 9EE4 37                       7
        .byte   $37                             ; 9EE5 37                       7
        .byte   $37                             ; 9EE6 37                       7
        .byte   $37                             ; 9EE7 37                       7
        .byte   $37                             ; 9EE8 37                       7
        .byte   $37                             ; 9EE9 37                       7
        .byte   $37                             ; 9EEA 37                       7
        .byte   $37                             ; 9EEB 37                       7
        .byte   $37                             ; 9EEC 37                       7
        .byte   $37                             ; 9EED 37                       7
        .byte   $37                             ; 9EEE 37                       7
        .byte   $37                             ; 9EEF 37                       7
        .byte   $37                             ; 9EF0 37                       7
        .byte   $37                             ; 9EF1 37                       7
        .byte   $37                             ; 9EF2 37                       7
        .byte   $37                             ; 9EF3 37                       7
        .byte   $37                             ; 9EF4 37                       7
        .byte   $37                             ; 9EF5 37                       7
        .byte   $37                             ; 9EF6 37                       7
        .byte   $37                             ; 9EF7 37                       7
        .byte   $37                             ; 9EF8 37                       7
        .byte   $37                             ; 9EF9 37                       7
        .byte   $37                             ; 9EFA 37                       7
        .byte   $37                             ; 9EFB 37                       7
        .byte   $37                             ; 9EFC 37                       7
        .byte   $37                             ; 9EFD 37                       7
        .byte   $37                             ; 9EFE 37                       7
        .byte   $37                             ; 9EFF 37                       7
        .byte   $37                             ; 9F00 37                       7
        .byte   $37                             ; 9F01 37                       7
        .byte   $37                             ; 9F02 37                       7
        .byte   $37                             ; 9F03 37                       7
        .byte   $37                             ; 9F04 37                       7
        .byte   $37                             ; 9F05 37                       7
        .byte   $37                             ; 9F06 37                       7
        .byte   $37                             ; 9F07 37                       7
        .byte   $37                             ; 9F08 37                       7
        .byte   $37                             ; 9F09 37                       7
        .byte   $37                             ; 9F0A 37                       7
        .byte   $37                             ; 9F0B 37                       7
        .byte   $37                             ; 9F0C 37                       7
        .byte   $37                             ; 9F0D 37                       7
        .byte   $37                             ; 9F0E 37                       7
        .byte   $37                             ; 9F0F 37                       7
        .byte   $37                             ; 9F10 37                       7
        .byte   $37                             ; 9F11 37                       7
        .byte   $37                             ; 9F12 37                       7
        .byte   $37                             ; 9F13 37                       7
        .byte   $37                             ; 9F14 37                       7
        .byte   $37                             ; 9F15 37                       7
        .byte   $37                             ; 9F16 37                       7
        .byte   $37                             ; 9F17 37                       7
        .byte   $37                             ; 9F18 37                       7
        .byte   $37                             ; 9F19 37                       7
        .byte   $37                             ; 9F1A 37                       7
        .byte   $37                             ; 9F1B 37                       7
        .byte   $37                             ; 9F1C 37                       7
        .byte   $37                             ; 9F1D 37                       7
        .byte   $37                             ; 9F1E 37                       7
        .byte   $37                             ; 9F1F 37                       7
        .byte   $37                             ; 9F20 37                       7
        .byte   $37                             ; 9F21 37                       7
        .byte   $37                             ; 9F22 37                       7
        .byte   $37                             ; 9F23 37                       7
        .byte   $37                             ; 9F24 37                       7
        .byte   $37                             ; 9F25 37                       7
        .byte   $37                             ; 9F26 37                       7
        .byte   $37                             ; 9F27 37                       7
        .byte   $37                             ; 9F28 37                       7
        .byte   $37                             ; 9F29 37                       7
        .byte   $37                             ; 9F2A 37                       7
        .byte   $37                             ; 9F2B 37                       7
        .byte   $37                             ; 9F2C 37                       7
        .byte   $37                             ; 9F2D 37                       7
        .byte   $37                             ; 9F2E 37                       7
        .byte   $37                             ; 9F2F 37                       7
        .byte   $37                             ; 9F30 37                       7
        .byte   $37                             ; 9F31 37                       7
        .byte   $37                             ; 9F32 37                       7
        .byte   $37                             ; 9F33 37                       7
        .byte   $37                             ; 9F34 37                       7
        .byte   $37                             ; 9F35 37                       7
        .byte   $37                             ; 9F36 37                       7
        .byte   $37                             ; 9F37 37                       7
        .byte   $37                             ; 9F38 37                       7
        .byte   $37                             ; 9F39 37                       7
        .byte   $37                             ; 9F3A 37                       7
        .byte   $37                             ; 9F3B 37                       7
        .byte   $37                             ; 9F3C 37                       7
        .byte   $37                             ; 9F3D 37                       7
        .byte   $37                             ; 9F3E 37                       7
        .byte   $37                             ; 9F3F 37                       7
        .byte   $37                             ; 9F40 37                       7
        .byte   $37                             ; 9F41 37                       7
        .byte   $37                             ; 9F42 37                       7
        .byte   $37                             ; 9F43 37                       7
        .byte   $37                             ; 9F44 37                       7
        .byte   $37                             ; 9F45 37                       7
        .byte   $37                             ; 9F46 37                       7
        .byte   $37                             ; 9F47 37                       7
        .byte   $37                             ; 9F48 37                       7
        .byte   $37                             ; 9F49 37                       7
        .byte   $37                             ; 9F4A 37                       7
        .byte   $37                             ; 9F4B 37                       7
        .byte   $37                             ; 9F4C 37                       7
        .byte   $37                             ; 9F4D 37                       7
        .byte   $37                             ; 9F4E 37                       7
        .byte   $37                             ; 9F4F 37                       7
        .byte   $37                             ; 9F50 37                       7
        .byte   $37                             ; 9F51 37                       7
        .byte   $37                             ; 9F52 37                       7
        .byte   $37                             ; 9F53 37                       7
        .byte   $37                             ; 9F54 37                       7
        .byte   $37                             ; 9F55 37                       7
        .byte   $37                             ; 9F56 37                       7
        .byte   $37                             ; 9F57 37                       7
        .byte   $37                             ; 9F58 37                       7
        .byte   $37                             ; 9F59 37                       7
        .byte   $37                             ; 9F5A 37                       7
        .byte   $37                             ; 9F5B 37                       7
        .byte   $37                             ; 9F5C 37                       7
        .byte   $37                             ; 9F5D 37                       7
        .byte   $37                             ; 9F5E 37                       7
        .byte   $37                             ; 9F5F 37                       7
        .byte   $37                             ; 9F60 37                       7
        .byte   $37                             ; 9F61 37                       7
        .byte   $37                             ; 9F62 37                       7
        .byte   $37                             ; 9F63 37                       7
        .byte   $37                             ; 9F64 37                       7
        .byte   $37                             ; 9F65 37                       7
        .byte   $37                             ; 9F66 37                       7
        .byte   $37                             ; 9F67 37                       7
        .byte   $37                             ; 9F68 37                       7
        .byte   $37                             ; 9F69 37                       7
        .byte   $37                             ; 9F6A 37                       7
        .byte   $37                             ; 9F6B 37                       7
        .byte   $37                             ; 9F6C 37                       7
        .byte   $37                             ; 9F6D 37                       7
        .byte   $37                             ; 9F6E 37                       7
        .byte   $37                             ; 9F6F 37                       7
        .byte   $37                             ; 9F70 37                       7
        .byte   $37                             ; 9F71 37                       7
        .byte   $37                             ; 9F72 37                       7
        .byte   $37                             ; 9F73 37                       7
        .byte   $37                             ; 9F74 37                       7
        .byte   $37                             ; 9F75 37                       7
        .byte   $37                             ; 9F76 37                       7
        .byte   $37                             ; 9F77 37                       7
        .byte   $37                             ; 9F78 37                       7
        .byte   $37                             ; 9F79 37                       7
        .byte   $37                             ; 9F7A 37                       7
        .byte   $37                             ; 9F7B 37                       7
        .byte   $37                             ; 9F7C 37                       7
        .byte   $37                             ; 9F7D 37                       7
        .byte   $37                             ; 9F7E 37                       7
        .byte   $37                             ; 9F7F 37                       7
        .byte   $37                             ; 9F80 37                       7
        .byte   $37                             ; 9F81 37                       7
        .byte   $37                             ; 9F82 37                       7
        .byte   $37                             ; 9F83 37                       7
        .byte   $37                             ; 9F84 37                       7
        .byte   $37                             ; 9F85 37                       7
        .byte   $37                             ; 9F86 37                       7
        .byte   $37                             ; 9F87 37                       7
        .byte   $37                             ; 9F88 37                       7
        .byte   $37                             ; 9F89 37                       7
        .byte   $37                             ; 9F8A 37                       7
        .byte   $37                             ; 9F8B 37                       7
        .byte   $37                             ; 9F8C 37                       7
        .byte   $37                             ; 9F8D 37                       7
        .byte   $37                             ; 9F8E 37                       7
        .byte   $37                             ; 9F8F 37                       7
        .byte   $37                             ; 9F90 37                       7
        .byte   $37                             ; 9F91 37                       7
        .byte   $37                             ; 9F92 37                       7
        .byte   $37                             ; 9F93 37                       7
        .byte   $37                             ; 9F94 37                       7
        .byte   $37                             ; 9F95 37                       7
        .byte   $37                             ; 9F96 37                       7
        .byte   $37                             ; 9F97 37                       7
        .byte   $37                             ; 9F98 37                       7
        .byte   $37                             ; 9F99 37                       7
        .byte   $37                             ; 9F9A 37                       7
        .byte   $37                             ; 9F9B 37                       7
        .byte   $37                             ; 9F9C 37                       7
        .byte   $37                             ; 9F9D 37                       7
        .byte   $37                             ; 9F9E 37                       7
        .byte   $37                             ; 9F9F 37                       7
        .byte   $37                             ; 9FA0 37                       7
        .byte   $37                             ; 9FA1 37                       7
        .byte   $37                             ; 9FA2 37                       7
        .byte   $37                             ; 9FA3 37                       7
        .byte   $37                             ; 9FA4 37                       7
        .byte   $37                             ; 9FA5 37                       7
        .byte   $37                             ; 9FA6 37                       7
        .byte   $37                             ; 9FA7 37                       7
        .byte   $37                             ; 9FA8 37                       7
        .byte   $37                             ; 9FA9 37                       7
        .byte   $37                             ; 9FAA 37                       7
        .byte   $37                             ; 9FAB 37                       7
        .byte   $37                             ; 9FAC 37                       7
        .byte   $37                             ; 9FAD 37                       7
        .byte   $37                             ; 9FAE 37                       7
        .byte   $37                             ; 9FAF 37                       7
        .byte   $37                             ; 9FB0 37                       7
        .byte   $37                             ; 9FB1 37                       7
        .byte   $37                             ; 9FB2 37                       7
        .byte   $37                             ; 9FB3 37                       7
        .byte   $37                             ; 9FB4 37                       7
        .byte   $37                             ; 9FB5 37                       7
        .byte   $37                             ; 9FB6 37                       7
        .byte   $37                             ; 9FB7 37                       7
        .byte   $37                             ; 9FB8 37                       7
        .byte   $37                             ; 9FB9 37                       7
        .byte   $37                             ; 9FBA 37                       7
        .byte   $37                             ; 9FBB 37                       7
        .byte   $37                             ; 9FBC 37                       7
        .byte   $37                             ; 9FBD 37                       7
        .byte   $37                             ; 9FBE 37                       7
        .byte   $37                             ; 9FBF 37                       7
        .byte   $37                             ; 9FC0 37                       7
        .byte   $37                             ; 9FC1 37                       7
        .byte   $37                             ; 9FC2 37                       7
        .byte   $37                             ; 9FC3 37                       7
        .byte   $37                             ; 9FC4 37                       7
        .byte   $37                             ; 9FC5 37                       7
        .byte   $37                             ; 9FC6 37                       7
        .byte   $37                             ; 9FC7 37                       7
        .byte   $37                             ; 9FC8 37                       7
        .byte   $37                             ; 9FC9 37                       7
        .byte   $37                             ; 9FCA 37                       7
        .byte   $37                             ; 9FCB 37                       7
        .byte   $37                             ; 9FCC 37                       7
        .byte   $37                             ; 9FCD 37                       7
        .byte   $37                             ; 9FCE 37                       7
        .byte   $37                             ; 9FCF 37                       7
        .byte   $37                             ; 9FD0 37                       7
        .byte   $37                             ; 9FD1 37                       7
        .byte   $37                             ; 9FD2 37                       7
        .byte   $37                             ; 9FD3 37                       7
        .byte   $37                             ; 9FD4 37                       7
        .byte   $37                             ; 9FD5 37                       7
        .byte   $37                             ; 9FD6 37                       7
        .byte   $37                             ; 9FD7 37                       7
        .byte   $37                             ; 9FD8 37                       7
        .byte   $37                             ; 9FD9 37                       7
        .byte   $37                             ; 9FDA 37                       7
        .byte   $37                             ; 9FDB 37                       7
        .byte   $37                             ; 9FDC 37                       7
        .byte   $37                             ; 9FDD 37                       7
        .byte   $37                             ; 9FDE 37                       7
        .byte   $37                             ; 9FDF 37                       7
        .byte   $37                             ; 9FE0 37                       7
        .byte   $37                             ; 9FE1 37                       7
        .byte   $37                             ; 9FE2 37                       7
        .byte   $37                             ; 9FE3 37                       7
        .byte   $37                             ; 9FE4 37                       7
        .byte   $37                             ; 9FE5 37                       7
        .byte   $37                             ; 9FE6 37                       7
        .byte   $37                             ; 9FE7 37                       7
        .byte   $37                             ; 9FE8 37                       7
        .byte   $37                             ; 9FE9 37                       7
        .byte   $37                             ; 9FEA 37                       7
        .byte   $37                             ; 9FEB 37                       7
        .byte   $37                             ; 9FEC 37                       7
        .byte   $37                             ; 9FED 37                       7
        .byte   $37                             ; 9FEE 37                       7
        .byte   $37                             ; 9FEF 37                       7
        .byte   $37                             ; 9FF0 37                       7
        .byte   $37                             ; 9FF1 37                       7
        .byte   $37                             ; 9FF2 37                       7
        .byte   $37                             ; 9FF3 37                       7
        .byte   $37                             ; 9FF4 37                       7
        .byte   $37                             ; 9FF5 37                       7
        .byte   $37                             ; 9FF6 37                       7
        .byte   $37                             ; 9FF7 37                       7
        .byte   $37                             ; 9FF8 37                       7
        .byte   $37                             ; 9FF9 37                       7
        .byte   $37                             ; 9FFA 37                       7
        .byte   $37                             ; 9FFB 37                       7
        .byte   $37                             ; 9FFC 37                       7
        .byte   $37                             ; 9FFD 37                       7
        .byte   $37                             ; 9FFE 37                       7
        .byte   $37                             ; 9FFF 37                       7
