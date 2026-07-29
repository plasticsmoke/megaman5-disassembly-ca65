.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK09"

; =============================================================================
; BANK $09 (mapped at $8000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
; =============================================================================
L0000           := $0000
L0564           := $0564
L193D           := $193D
L1F20           := $1F20
L201F           := $201F
L2821           := $2821
L2895           := $2895
L3D1F           := $3D1F
L4C4C           := $4C4C
L5864           := $5864
L6040           := $6040
L606C           := $606C
LA000           := $A000
LA238           := $A238
LA255           := $A255
LA2C3           := $A2C3
LA380           := $A380
LA60A           := $A60A
LA662           := $A662
LC030           := $C030
LE7B7           := $E7B7
LEA3F           := $EA3F
LEA65           := $EA65
LEA86           := $EA86
LEA98           := $EA98
LEAA4           := $EAA4
LEAF5           := $EAF5
LEC16           := $EC16
LEC30           := $EC30
LEC4A           := $EC4A
LEC94           := $EC94
LECC2           := $ECC2
LEF87           := $EF87
LF16F           := $F16F
LF2C4           := $F2C4
LF470           := $F470
; ----------------------------------------------------------------------------
        lda     #$01                            ; 8000 A9 01                    ..
        sta     $0E                             ; 8002 85 0E                    ..
L8004:  jsr     LF16F                           ; 8004 20 6F F1                  o.
        lda     #$A0                            ; 8007 A9 A0                    ..
        sta     $0408,y                         ; 8009 99 08 04                 ...
        lda     $0300,x                         ; 800C BD 00 03                 ...
        clc                                     ; 800F 18                       .
        adc     #$01                            ; 8010 69 01                    i.
        sta     $0300,y                         ; 8012 99 00 03                 ...
        lda     $0E                             ; 8015 A5 0E                    ..
        clc                                     ; 8017 18                       .
        adc     #$01                            ; 8018 69 01                    i.
        sta     $0420,y                         ; 801A 99 20 04                 . .
        adc     $0D                             ; 801D 65 0D                    e.
        sta     $10                             ; 801F 85 10                    ..
        lda     #$46                            ; 8021 A9 46                    .F
        jsr     LEAF5                           ; 8023 20 F5 EA                  ..
        lda     $0528,y                         ; 8026 B9 28 05                 .(.
        ora     #$08                            ; 8029 09 08                    ..
        sta     $0528,y                         ; 802B 99 28 05                 .(.
        lda     $0378,x                         ; 802E BD 78 03                 .x.
        sta     $0378,y                         ; 8031 99 78 03                 .x.
        lda     #$40                            ; 8034 A9 40                    .@
        sta     $0468,y                         ; 8036 99 68 04                 .h.
        txa                                     ; 8039 8A                       .
        sta     $0480,y                         ; 803A 99 80 04                 ...
        lda     $0300,x                         ; 803D BD 00 03                 ...
        cmp     #$91                            ; 8040 C9 91                    ..
        bne     L804D                           ; 8042 D0 09                    ..
        lda     #$80                            ; 8044 A9 80                    ..
        sta     $03A8,y                         ; 8046 99 A8 03                 ...
        lda     #$00                            ; 8049 A9 00                    ..
        beq     L8054                           ; 804B F0 07                    ..
L804D:  lda     #$00                            ; 804D A9 00                    ..
        sta     $03A8,y                         ; 804F 99 A8 03                 ...
        lda     #$01                            ; 8052 A9 01                    ..
L8054:  sta     $03C0,y                         ; 8054 99 C0 03                 ...
        dec     $0E                             ; 8057 C6 0E                    ..
        bpl     L8004                           ; 8059 10 A9                    ..
        rts                                     ; 805B 60                       `

; ----------------------------------------------------------------------------
        lda     #$57                            ; 805C A9 57                    .W
        sta     $0D                             ; 805E 85 0D                    ..
        jsr     LA000                           ; 8060 20 00 A0                  ..
        lda     #$6D                            ; 8063 A9 6D                    .m
        sta     $0588,x                         ; 8065 9D 88 05                 ...
        lda     #$A0                            ; 8068 A9 A0                    ..
        sta     $05A0,x                         ; 806A 9D A0 05                 ...
        lda     $0330,x                         ; 806D BD 30 03                 .0.
        sta     $0480,x                         ; 8070 9D 80 04                 ...
        lda     $0468,x                         ; 8073 BD 68 04                 .h.
        beq     L8089                           ; 8076 F0 11                    ..
        dec     $0468,x                         ; 8078 DE 68 04                 .h.
        bne     L80E0                           ; 807B D0 63                    .c
        lda     $04B0,x                         ; 807D BD B0 04                 ...
L8080:  jsr     LEA98                           ; 8080 20 98 EA                  ..
        jsr     LEC16                           ; 8083 20 16 EC                  ..
        jsr     LEC30                           ; 8086 20 30 EC                  0.
L8089:  ldy     $0498,x                         ; 8089 BC 98 04                 ...
        lda     $A0E1,y                         ; 808C B9 E1 A0                 ...
        beq     L80C0                           ; 808F F0 2F                    ./
        cmp     $0450,x                         ; 8091 DD 50 04                 .P.
        bcc     L80C0                           ; 8094 90 2A                    .*
        lda     $A0E7,y                         ; 8096 B9 E7 A0                 ...
        sta     $0558,x                         ; 8099 9D 58 05                 .X.
        inc     $0540,x                         ; 809C FE 40 05                 .@.
        lda     $0540,x                         ; 809F BD 40 05                 .@.
        and     #$03                            ; 80A2 29 03                    ).
        sta     $0540,x                         ; 80A4 9D 40 05                 .@.
        lda     #$00                            ; 80A7 A9 00                    ..
        sta     $0570,x                         ; 80A9 9D 70 05                 .p.
        lda     $03A8,x                         ; 80AC BD A8 03                 ...
        clc                                     ; 80AF 18                       .
        adc     #$40                            ; 80B0 69 40                    i@
        sta     $03A8,x                         ; 80B2 9D A8 03                 ...
        lda     $03C0,x                         ; 80B5 BD C0 03                 ...
        adc     #$00                            ; 80B8 69 00                    i.
        sta     $03C0,x                         ; 80BA 9D C0 03                 ...
        inc     $0498,x                         ; 80BD FE 98 04                 ...
L80C0:  jsr     LEA65                           ; 80C0 20 65 EA                  e.
        lda     $0420,x                         ; 80C3 BD 20 04                 . .
        pha                                     ; 80C6 48                       H
        jsr     LEC16                           ; 80C7 20 16 EC                  ..
        pla                                     ; 80CA 68                       h
        cmp     $0420,x                         ; 80CB DD 20 04                 . .
        beq     L80E0                           ; 80CE F0 10                    ..
        lda     $0558,x                         ; 80D0 BD 58 05                 .X.
        sta     $04B0,x                         ; 80D3 9D B0 04                 ...
        lda     #$78                            ; 80D6 A9 78                    .x
        sta     $0468,x                         ; 80D8 9D 68 04                 .h.
        lda     #$41                            ; 80DB A9 41                    .A
        jsr     LEA98                           ; 80DD 20 98 EA                  ..
L80E0:  rts                                     ; 80E0 60                       `

; ----------------------------------------------------------------------------
        .byte   $1A                             ; 80E1 1A                       .
        .byte   $17                             ; 80E2 17                       .
        .byte   $14                             ; 80E3 14                       .
        ora     ($0E),y                         ; 80E4 11 0E                    ..
        brk                                     ; 80E6 00                       .
        .byte   $43                             ; 80E7 43                       C
        .byte   $43                             ; 80E8 43                       C
        .byte   $44                             ; 80E9 44                       D
        .byte   $44                             ; 80EA 44                       D
        eor     L0000                           ; 80EB 45 00                    E.
        jsr     L8541                           ; 80ED 20 41 85                  A.
        dec     $0468,x                         ; 80F0 DE 68 04                 .h.
        bne     L80FD                           ; 80F3 D0 08                    ..
        lda     #$40                            ; 80F5 A9 40                    .@
        sta     $0468,x                         ; 80F7 9D 68 04                 .h.
        jsr     L852F                           ; 80FA 20 2F 85                  /.
L80FD:  lda     #$00                            ; 80FD A9 00                    ..
        sta     $01                             ; 80FF 85 01                    ..
        ldy     $0480,x                         ; 8101 BC 80 04                 ...
        lda     $0300,y                         ; 8104 B9 00 03                 ...
        cmp     #$91                            ; 8107 C9 91                    ..
        beq     L810E                           ; 8109 F0 03                    ..
        jmp     LF2C4                           ; 810B 4C C4 F2                 L..

; ----------------------------------------------------------------------------
L810E:  lda     $0330,y                         ; 810E B9 30 03                 .0.
        sec                                     ; 8111 38                       8
        sbc     $0480,y                         ; 8112 F9 80 04                 ...
        sta     L0000                           ; 8115 85 00                    ..
        beq     L812E                           ; 8117 F0 15                    ..
        bpl     L811D                           ; 8119 10 02                    ..
        dec     $01                             ; 811B C6 01                    ..
L811D:  lda     $0330,x                         ; 811D BD 30 03                 .0.
        clc                                     ; 8120 18                       .
        adc     L0000                           ; 8121 65 00                    e.
        sta     $0330,x                         ; 8123 9D 30 03                 .0.
        lda     $0348,x                         ; 8126 BD 48 03                 .H.
        adc     $01                             ; 8129 65 01                    e.
        sta     $0348,x                         ; 812B 9D 48 03                 .H.
L812E:  rts                                     ; 812E 60                       `

; ----------------------------------------------------------------------------
        lda     $0498,x                         ; 812F BD 98 04                 ...
        beq     L8138                           ; 8132 F0 04                    ..
        dec     $0498,x                         ; 8134 DE 98 04                 ...
        rts                                     ; 8137 60                       `

; ----------------------------------------------------------------------------
L8138:  lda     $54                             ; 8138 A5 54                    .T
        bne     L8184                           ; 813A D0 48                    .H
        jsr     LEC16                           ; 813C 20 16 EC                  ..
        jsr     LEC30                           ; 813F 20 30 EC                  0.
        jsr     LEC94                           ; 8142 20 94 EC                  ..
        cmp     #$40                            ; 8145 C9 40                    .@
        bcs     L815B                           ; 8147 B0 12                    ..
        lda     #$4E                            ; 8149 A9 4E                    .N
        jsr     LEA98                           ; 814B 20 98 EA                  ..
        lda     #$55                            ; 814E A9 55                    .U
        sta     $0588,x                         ; 8150 9D 88 05                 ...
        lda     #$A2                            ; 8153 A9 A2                    ..
        sta     $05A0,x                         ; 8155 9D A0 05                 ...
        jmp     LA255                           ; 8158 4C 55 A2                 LU.

; ----------------------------------------------------------------------------
L815B:  adc     $E7                             ; 815B 65 E7                    e.
        sta     $E6                             ; 815D 85 E6                    ..
        and     #$03                            ; 815F 29 03                    ).
        beq     L8184                           ; 8161 F0 21                    .!
        lda     #$00                            ; 8163 A9 00                    ..
        sta     $03A8,x                         ; 8165 9D A8 03                 ...
        lda     #$01                            ; 8168 A9 01                    ..
        sta     $03C0,x                         ; 816A 9D C0 03                 ...
        lda     #$4D                            ; 816D A9 4D                    .M
        jsr     LEA98                           ; 816F 20 98 EA                  ..
        lda     #$0F                            ; 8172 A9 0F                    ..
        sta     $0468,x                         ; 8174 9D 68 04                 .h.
        lda     #$38                            ; 8177 A9 38                    .8
L8179:  sta     $0588,x                         ; 8179 9D 88 05                 ...
        lda     #$A2                            ; 817C A9 A2                    ..
        sta     $05A0,x                         ; 817E 9D A0 05                 ...
        jmp     LA238                           ; 8181 4C 38 A2                 L8.

; ----------------------------------------------------------------------------
L8184:  jsr     LEC94                           ; 8184 20 94 EC                  ..
        lsr     a                               ; 8187 4A                       J
        ldy     #$01                            ; 8188 A0 01                    ..
        jsr     L8550                           ; 818A 20 50 85                  P.
        lda     #$4C                            ; 818D A9 4C                    .L
        .byte   $20                             ; 818F 20                        
L8190:  tya                                     ; 8190 98                       .
        nop                                     ; 8191 EA                       .
        lda     #$9C                            ; 8192 A9 9C                    ..
        sta     $0588,x                         ; 8194 9D 88 05                 ...
        lda     #$A1                            ; 8197 A9 A1                    ..
        .byte   $9D                             ; 8199 9D                       .
        .byte   $A0                             ; 819A A0                       .
L819B:  ora     $BD                             ; 819B 05 BD                    ..
        cli                                     ; 819D 58                       X
        ora     $C9                             ; 819E 05 C9                    ..
        .byte   $4F                             ; 81A0 4F                       O
        beq     L81B2                           ; 81A1 F0 0F                    ..
        lda     $0540,x                         ; 81A3 BD 40 05                 .@.
        beq     L81FE                           ; 81A6 F0 56                    .V
        lda     $03F0,x                         ; 81A8 BD F0 03                 ...
        bpl     L8211                           ; 81AB 10 64                    .d
        lda     #$4F                            ; 81AD A9 4F                    .O
        jsr     LEA98                           ; 81AF 20 98 EA                  ..
L81B2:  jsr     L850B                           ; 81B2 20 0B 85                  ..
        lda     $0570,x                         ; 81B5 BD 70 05                 .p.
        cmp     #$04                            ; 81B8 C9 04                    ..
        bne     L81FE                           ; 81BA D0 42                    .B
        lda     $0540,x                         ; 81BC BD 40 05                 .@.
        cmp     #$09                            ; 81BF C9 09                    ..
        beq     L81FF                           ; 81C1 F0 3C                    .<
        and     #$01                            ; 81C3 29 01                    ).
        bne     L81FE                           ; 81C5 D0 37                    .7
        jsr     LECC2                           ; 81C7 20 C2 EC                  ..
        sta     $0E                             ; 81CA 85 0E                    ..
        stx     $0F                             ; 81CC 86 0F                    ..
        jsr     LF16F                           ; 81CE 20 6F F1                  o.
        bcs     L81FE                           ; 81D1 B0 2B                    .+
        lda     #$86                            ; 81D3 A9 86                    ..
        sta     $0408,y                         ; 81D5 99 08 04                 ...
        lda     #$94                            ; 81D8 A9 94                    ..
        sta     $0300,y                         ; 81DA 99 00 03                 ...
        lda     #$13                            ; 81DD A9 13                    ..
        sta     L0000                           ; 81DF 85 00                    ..
        lda     $0528,x                         ; 81E1 BD 28 05                 .(.
        and     #$20                            ; 81E4 29 20                    ) 
        beq     L81EA                           ; 81E6 F0 02                    ..
        inc     L0000                           ; 81E8 E6 00                    ..
L81EA:  lda     L0000                           ; 81EA A5 00                    ..
        sta     $10                             ; 81EC 85 10                    ..
        lda     #$51                            ; 81EE A9 51                    .Q
        jsr     LEAF5                           ; 81F0 20 F5 EA                  ..
        tya                                     ; 81F3 98                       .
        tax                                     ; 81F4 AA                       .
        ldy     $0E                             ; 81F5 A4 0E                    ..
        lda     #$10                            ; 81F7 A9 10                    ..
        jsr     LF470                           ; 81F9 20 70 F4                  p.
        ldx     $0F                             ; 81FC A6 0F                    ..
L81FE:  rts                                     ; 81FE 60                       `

; ----------------------------------------------------------------------------
L81FF:  lda     #$4C                            ; 81FF A9 4C                    .L
        jsr     LEA98                           ; 8201 20 98 EA                  ..
        inc     $0540,x                         ; 8204 FE 40 05                 .@.
        lda     #$11                            ; 8207 A9 11                    ..
        sta     $0588,x                         ; 8209 9D 88 05                 ...
        lda     #$A2                            ; 820C A9 A2                    ..
        sta     $05A0,x                         ; 820E 9D A0 05                 ...
L8211:  lda     $0540,x                         ; 8211 BD 40 05                 .@.
L8214:  cmp     #$02                            ; 8214 C9 02                    ..
        beq     L822E                           ; 8216 F0 16                    ..
        lda     #$00                            ; 8218 A9 00                    ..
        sta     $0570,x                         ; 821A 9D 70 05                 .p.
        ldy     #$1C                            ; 821D A0 1C                    ..
        jsr     LE7B7                           ; 821F 20 B7 E7                  ..
        bcs     L8229                           ; 8222 B0 05                    ..
        ldy     #$1E                            ; 8224 A0 1E                    ..
        jmp     LEA3F                           ; 8226 4C 3F EA                 L?.

; ----------------------------------------------------------------------------
L8229:  lda     #$02                            ; 8229 A9 02                    ..
        sta     $0540,x                         ; 822B 9D 40 05                 .@.
L822E:  lda     $0570,x                         ; 822E BD 70 05                 .p.
        cmp     #$08                            ; 8231 C9 08                    ..
        bne     L8254                           ; 8233 D0 1F                    ..
        jmp     LA2C3                           ; 8235 4C C3 A2                 L..

; ----------------------------------------------------------------------------
        ldy     #$1E                            ; 8238 A0 1E                    ..
        jsr     LEA3F                           ; 823A 20 3F EA                  ?.
        bcc     L8242                           ; 823D 90 03                    ..
        jsr     LEC4A                           ; 823F 20 4A EC                  J.
L8242:  dec     $0468,x                         ; 8242 DE 68 04                 .h.
        bne     L8254                           ; 8245 D0 0D                    ..
        lda     #$10                            ; 8247 A9 10                    ..
        sta     $0498,x                         ; 8249 9D 98 04                 ...
        lda     #$4B                            ; 824C A9 4B                    .K
        jsr     LEA98                           ; 824E 20 98 EA                  ..
        jmp     LA2C3                           ; 8251 4C C3 A2                 L..

; ----------------------------------------------------------------------------
L8254:  rts                                     ; 8254 60                       `

; ----------------------------------------------------------------------------
        jsr     LEC16                           ; 8255 20 16 EC                  ..
        jsr     LEC30                           ; 8258 20 30 EC                  0.
        lda     $0570,x                         ; 825B BD 70 05                 .p.
        cmp     #$04                            ; 825E C9 04                    ..
        bne     L8254                           ; 8260 D0 F2                    ..
        lda     $0540,x                         ; 8262 BD 40 05                 .@.
        cmp     #$09                            ; 8265 C9 09                    ..
        beq     L82A6                           ; 8267 F0 3D                    .=
        cmp     #$08                            ; 8269 C9 08                    ..
        bne     L8254                           ; 826B D0 E7                    ..
        stx     $0F                             ; 826D 86 0F                    ..
        jsr     LECC2                           ; 826F 20 C2 EC                  ..
        sec                                     ; 8272 38                       8
        sbc     #$01                            ; 8273 E9 01                    ..
        sta     $0E                             ; 8275 85 0E                    ..
        lda     #$02                            ; 8277 A9 02                    ..
        sta     $0D                             ; 8279 85 0D                    ..
L827B:  jsr     LF16F                           ; 827B 20 6F F1                  o.
        bcs     L8254                           ; 827E B0 D4                    ..
L8280:  lda     #$06                            ; 8280 A9 06                    ..
        sta     $0408,y                         ; 8282 99 08 04                 ...
        lda     #$95                            ; 8285 A9 95                    ..
        sta     $0300,y                         ; 8287 99 00 03                 ...
        lda     #$50                            ; 828A A9 50                    .P
        jsr     LEAA4                           ; 828C 20 A4 EA                  ..
        tya                                     ; 828F 98                       .
        tax                                     ; 8290 AA                       .
        lda     $0E                             ; 8291 A5 0E                    ..
        and     #$0F                            ; 8293 29 0F                    ).
        sta     $0E                             ; 8295 85 0E                    ..
        tay                                     ; 8297 A8                       .
        lda     #$08                            ; 8298 A9 08                    ..
        jsr     LF470                           ; 829A 20 70 F4                  p.
        ldx     $0F                             ; 829D A6 0F                    ..
        inc     $0E                             ; 829F E6 0E                    ..
        dec     $0D                             ; 82A1 C6 0D                    ..
        bpl     L827B                           ; 82A3 10 D6                    ..
        rts                                     ; 82A5 60                       `

; ----------------------------------------------------------------------------
L82A6:  lda     #$4B                            ; 82A6 A9 4B                    .K
        jsr     LEA98                           ; 82A8 20 98 EA                  ..
        lda     #$B5                            ; 82AB A9 B5                    ..
        sta     $0588,x                         ; 82AD 9D 88 05                 ...
        lda     #$A2                            ; 82B0 A9 A2                    ..
        sta     $05A0,x                         ; 82B2 9D A0 05                 ...
        ldy     #$17                            ; 82B5 A0 17                    ..
L82B7:  lda     $0300,y                         ; 82B7 B9 00 03                 ...
        cmp     #$95                            ; 82BA C9 95                    ..
        beq     L82CD                           ; 82BC F0 0F                    ..
        dey                                     ; 82BE 88                       .
        cpy     #$07                            ; 82BF C0 07                    ..
        bcs     L82B7                           ; 82C1 B0 F4                    ..
        lda     #$2F                            ; 82C3 A9 2F                    ./
        sta     $0588,x                         ; 82C5 9D 88 05                 ...
        lda     #$A1                            ; 82C8 A9 A1                    ..
        sta     $05A0,x                         ; 82CA 9D A0 05                 ...
L82CD:  rts                                     ; 82CD 60                       `

; ----------------------------------------------------------------------------
        jsr     LEA65                           ; 82CE 20 65 EA                  e.
        jmp     LEA86                           ; 82D1 4C 86 EA                 L..

; ----------------------------------------------------------------------------
        jsr     LEA65                           ; 82D4 20 65 EA                  e.
        jsr     LEA86                           ; 82D7 20 86 EA                  ..
        jsr     LEF87                           ; 82DA 20 87 EF                  ..
        bcs     L82CD                           ; 82DD B0 EE                    ..
        lda     $30                             ; 82DF A5 30                    .0
        cmp     #$06                            ; 82E1 C9 06                    ..
        bcs     L82CD                           ; 82E3 B0 E8                    ..
        jsr     LA662                           ; 82E5 20 62 A6                  b.
        sty     $54                             ; 82E8 84 54                    .T
        rts                                     ; 82EA 60                       `

; ----------------------------------------------------------------------------
        lda     #$1C                            ; 82EB A9 1C                    ..
        .byte   $9D                             ; 82ED 9D                       .
L82EE:  .byte   $B0,$04                    ; 82EE B0 04   (branch out of range for ca65: target has no local label)
        lda     #$3C                            ; 82F0 A9 3C                    .<
        sta     $0480,x                         ; 82F2 9D 80 04                 ...
        lda     #$FF                            ; 82F5 A9 FF                    ..
        sta     $0588,x                         ; 82F7 9D 88 05                 ...
        lda     #$A2                            ; 82FA A9 A2                    ..
        sta     $05A0,x                         ; 82FC 9D A0 05                 ...
        lda     $0468,x                         ; 82FF BD 68 04                 .h.
        beq     L8314                           ; 8302 F0 10                    ..
        dec     $0468,x                         ; 8304 DE 68 04                 .h.
        bne     L835D                           ; 8307 D0 54                    .T
        jsr     LEC16                           ; 8309 20 16 EC                  ..
        jsr     LEC30                           ; 830C 20 30 EC                  0.
        lda     #$53                            ; 830F A9 53                    .S
        jsr     LEA98                           ; 8311 20 98 EA                  ..
L8314:  dec     $0480,x                         ; 8314 DE 80 04                 ...
        bne     L8320                           ; 8317 D0 07                    ..
        lda     #$00                            ; 8319 A9 00                    ..
        sta     $0498,x                         ; 831B 9D 98 04                 ...
        beq     L8364                           ; 831E F0 44                    .D
L8320:  lda     $0450,x                         ; 8320 BD 50 04                 .P.
        cmp     $04B0,x                         ; 8323 DD B0 04                 ...
        beq     L8343                           ; 8326 F0 1B                    ..
        cmp     #$12                            ; 8328 C9 12                    ..
        bcs     L833C                           ; 832A B0 10                    ..
        cmp     #$08                            ; 832C C9 08                    ..
        bcs     L8337                           ; 832E B0 07                    ..
        lda     #$00                            ; 8330 A9 00                    ..
        sta     $03C0,x                         ; 8332 9D C0 03                 ...
        bne     L833C                           ; 8335 D0 05                    ..
L8337:  lda     #$01                            ; 8337 A9 01                    ..
        sta     $03C0,x                         ; 8339 9D C0 03                 ...
L833C:  lda     #$FF                            ; 833C A9 FF                    ..
        sta     $0498,x                         ; 833E 9D 98 04                 ...
        bne     L8364                           ; 8341 D0 21                    .!
L8343:  jsr     LEA65                           ; 8343 20 65 EA                  e.
        lda     $0420,x                         ; 8346 BD 20 04                 . .
        pha                                     ; 8349 48                       H
        jsr     LEC16                           ; 834A 20 16 EC                  ..
        pla                                     ; 834D 68                       h
        cmp     $0420,x                         ; 834E DD 20 04                 . .
        beq     L835D                           ; 8351 F0 0A                    ..
        lda     #$1E                            ; 8353 A9 1E                    ..
        sta     $0468,x                         ; 8355 9D 68 04                 .h.
        lda     #$52                            ; 8358 A9 52                    .R
        jsr     LEA98                           ; 835A 20 98 EA                  ..
L835D:  lda     $0450,x                         ; 835D BD 50 04                 .P.
        sta     $04B0,x                         ; 8360 9D B0 04                 ...
L8363:  rts                                     ; 8363 60                       `

; ----------------------------------------------------------------------------
L8364:  jsr     LEC16                           ; 8364 20 16 EC                  ..
        jsr     LEC30                           ; 8367 20 30 EC                  0.
        lda     #$54                            ; 836A A9 54                    .T
        cmp     $0558,x                         ; 836C DD 58 05                 .X.
        beq     L837E                           ; 836F F0 0D                    ..
        jsr     LEA98                           ; 8371 20 98 EA                  ..
        .byte   $A9                             ; 8374 A9                       .
L8375:  .byte   $64                             ; 8375 64                       d
        sta     $0588,x                         ; 8376 9D 88 05                 ...
        lda     #$A3                            ; 8379 A9 A3                    ..
        sta     $05A0,x                         ; 837B 9D A0 05                 ...
L837E:  lda     $0570,x                         ; 837E BD 70 05                 .p.
        cmp     #$04                            ; 8381 C9 04                    ..
        bne     L8363                           ; 8383 D0 DE                    ..
        stx     $0F                             ; 8385 86 0F                    ..
        jsr     LECC2                           ; 8387 20 C2 EC                  ..
        sta     $0E                             ; 838A 85 0E                    ..
        jsr     LF16F                           ; 838C 20 6F F1                  o.
        bcs     L8363                           ; 838F B0 D2                    ..
        lda     #$87                            ; 8391 A9 87                    ..
        sta     $0408,y                         ; 8393 99 08 04                 ...
        lda     #$97                            ; 8396 A9 97                    ..
        sta     $0300,y                         ; 8398 99 00 03                 ...
        lda     $0420,x                         ; 839B BD 20 04                 . .
        sta     $0420,y                         ; 839E 99 20 04                 . .
        and     #$01                            ; 83A1 29 01                    ).
        clc                                     ; 83A3 18                       .
        adc     #$40                            ; 83A4 69 40                    i@
        sta     $10                             ; 83A6 85 10                    ..
        lda     #$51                            ; 83A8 A9 51                    .Q
        jsr     LEAF5                           ; 83AA 20 F5 EA                  ..
        lda     #$00                            ; 83AD A9 00                    ..
        sta     $03A8,y                         ; 83AF 99 A8 03                 ...
        lda     #$03                            ; 83B2 A9 03                    ..
        sta     $03C0,y                         ; 83B4 99 C0 03                 ...
        lda     $0498,x                         ; 83B7 BD 98 04                 ...
        beq     L83C7                           ; 83BA F0 0B                    ..
        tya                                     ; 83BC 98                       .
        tax                                     ; 83BD AA                       .
        ldy     $0E                             ; 83BE A4 0E                    ..
        lda     #$10                            ; 83C0 A9 10                    ..
        jsr     LF470                           ; 83C2 20 70 F4                  p.
        ldx     $0F                             ; 83C5 A6 0F                    ..
L83C7:  lda     #$D1                            ; 83C7 A9 D1                    ..
        sta     $0588,x                         ; 83C9 9D 88 05                 ...
        lda     #$A3                            ; 83CC A9 A3                    ..
        sta     $05A0,x                         ; 83CE 9D A0 05                 ...
        lda     #$00                            ; 83D1 A9 00                    ..
        sta     $0570,x                         ; 83D3 9D 70 05                 .p.
        ldy     #$17                            ; 83D6 A0 17                    ..
L83D8:  lda     $0300,y                         ; 83D8 B9 00 03                 ...
        cmp     #$97                            ; 83DB C9 97                    ..
        beq     L8404                           ; 83DD F0 25                    .%
        dey                                     ; 83DF 88                       .
        cpy     #$07                            ; 83E0 C0 07                    ..
        bcs     L83D8                           ; 83E2 B0 F4                    ..
        jsr     LEC16                           ; 83E4 20 16 EC                  ..
        jsr     LEC30                           ; 83E7 20 30 EC                  0.
        lda     #$3C                            ; 83EA A9 3C                    .<
        sta     $0480,x                         ; 83EC 9D 80 04                 ...
        lda     #$FF                            ; 83EF A9 FF                    ..
        sta     $0588,x                         ; 83F1 9D 88 05                 ...
        lda     #$A2                            ; 83F4 A9 A2                    ..
        sta     $05A0,x                         ; 83F6 9D A0 05                 ...
        lda     #$53                            ; 83F9 A9 53                    .S
        jsr     LEA98                           ; 83FB 20 98 EA                  ..
        lda     $0450,x                         ; 83FE BD 50 04                 .P.
        .byte   $9D                             ; 8401 9D                       .
        .byte   $B0                             ; 8402 B0                       .
L8403:  .byte   $04                             ; 8403 04                       .
L8404:  rts                                     ; 8404 60                       `

; ----------------------------------------------------------------------------
        lda     $0450,x                         ; 8405 BD 50 04                 .P.
        cmp     #$1C                            ; 8408 C9 1C                    ..
        beq     L842E                           ; 840A F0 22                    ."
        lda     $30                             ; 840C A5 30                    .0
        bne     L846D                           ; 840E D0 5D                    .]
        lda     $0378                           ; 8410 AD 78 03                 .x.
        cmp     #$B4                            ; 8413 C9 B4                    ..
        bcc     L846D                           ; 8415 90 56                    .V
        jsr     L84A6                           ; 8417 20 A6 84                  ..
        lda     #$24                            ; 841A A9 24                    .$
        sta     $0588,x                         ; 841C 9D 88 05                 ...
        lda     #$A4                            ; 841F A9 A4                    ..
        sta     $05A0,x                         ; 8421 9D A0 05                 ...
        jsr     L8477                           ; 8424 20 77 84                  w.
        bcs     L846D                           ; 8427 B0 44                    .D
        lda     #$CC                            ; 8429 A9 CC                    ..
        sta     $0408,x                         ; 842B 9D 08 04                 ...
L842E:  lda     #$3B                            ; 842E A9 3B                    .;
        sta     $0D                             ; 8430 85 0D                    ..
        jsr     LA000                           ; 8432 20 00 A0                  ..
        lda     #$44                            ; 8435 A9 44                    .D
        sta     $0588,x                         ; 8437 9D 88 05                 ...
        lda     #$A4                            ; 843A A9 A4                    ..
        sta     $05A0,x                         ; 843C 9D A0 05                 ...
        lda     #$20                            ; 843F A9 20                    . 
        sta     $0468,x                         ; 8441 9D 68 04                 .h.
        jsr     LEC16                           ; 8444 20 16 EC                  ..
        jsr     LEC30                           ; 8447 20 30 EC                  0.
        dec     $0468,x                         ; 844A DE 68 04                 .h.
        bne     L846D                           ; 844D D0 1E                    ..
        lda     $E5                             ; 844F A5 E5                    ..
        adc     $E6                             ; 8451 65 E6                    e.
        sta     $E5                             ; 8453 85 E5                    ..
        and     #$01                            ; 8455 29 01                    ).
        beq     L846E                           ; 8457 F0 15                    ..
        lda     #$03                            ; 8459 A9 03                    ..
        sta     $0480,x                         ; 845B 9D 80 04                 ...
        lda     #$49                            ; 845E A9 49                    .I
        jsr     LEA98                           ; 8460 20 98 EA                  ..
        lda     #$ED                            ; 8463 A9 ED                    ..
        sta     $0588,x                         ; 8465 9D 88 05                 ...
        lda     #$A4                            ; 8468 A9 A4                    ..
        sta     $05A0,x                         ; 846A 9D A0 05                 ...
L846D:  rts                                     ; 846D 60                       `

; ----------------------------------------------------------------------------
L846E:  inc     $0480,x                         ; 846E FE 80 04                 ...
        lda     #$80                            ; 8471 A9 80                    ..
        sta     $0588,x                         ; 8473 9D 88 05                 ...
        .byte   $A9                             ; 8476 A9                       .
L8477:  ldy     $9D                             ; 8477 A4 9D                    ..
        ldy     #$05                            ; 8479 A0 05                    ..
        lda     #$14                            ; 847B A9 14                    ..
        sta     $04C8,x                         ; 847D 9D C8 04                 ...
        dec     $04C8,x                         ; 8480 DE C8 04                 ...
        bne     L846D                           ; 8483 D0 E8                    ..
        jsr     LEC16                           ; 8485 20 16 EC                  ..
        jsr     LEC30                           ; 8488 20 30 EC                  0.
        ldy     #$01                            ; 848B A0 01                    ..
        jsr     L854D                           ; 848D 20 4D 85                  M.
        lda     #$9F                            ; 8490 A9 9F                    ..
        sta     $0588,x                         ; 8492 9D 88 05                 ...
        lda     #$A4                            ; 8495 A9 A4                    ..
        sta     $05A0,x                         ; 8497 9D A0 05                 ...
        lda     #$48                            ; 849A A9 48                    .H
        jsr     LEA98                           ; 849C 20 98 EA                  ..
        lda     $0540,x                         ; 849F BD 40 05                 .@.
        beq     L84EC                           ; 84A2 F0 48                    .H
        cmp     #$02                            ; 84A4 C9 02                    ..
L84A6:  beq     L84BE                           ; 84A6 F0 16                    ..
        lda     #$00                            ; 84A8 A9 00                    ..
        sta     $0570,x                         ; 84AA 9D 70 05                 .p.
        ldy     #$1C                            ; 84AD A0 1C                    ..
        jsr     LE7B7                           ; 84AF 20 B7 E7                  ..
        bcs     L84B9                           ; 84B2 B0 05                    ..
        ldy     #$1E                            ; 84B4 A0 1E                    ..
        jmp     LEA3F                           ; 84B6 4C 3F EA                 L?.

; ----------------------------------------------------------------------------
L84B9:  lda     #$02                            ; 84B9 A9 02                    ..
        sta     $0540,x                         ; 84BB 9D 40 05                 .@.
L84BE:  lda     $0570,x                         ; 84BE BD 70 05                 .p.
        cmp     #$08                            ; 84C1 C9 08                    ..
        bne     L84EC                           ; 84C3 D0 27                    .'
        lda     #$47                            ; 84C5 A9 47                    .G
        jsr     LEA98                           ; 84C7 20 98 EA                  ..
        lda     #$D7                            ; 84CA A9 D7                    ..
        sta     $0588,x                         ; 84CC 9D 88 05                 ...
        lda     #$A4                            ; 84CF A9 A4                    ..
        sta     $05A0,x                         ; 84D1 9D A0 05                 ...
        inc     $0480,x                         ; 84D4 FE 80 04                 ...
        ldy     #$17                            ; 84D7 A0 17                    ..
L84D9:  lda     $0300,y                         ; 84D9 B9 00 03                 ...
        cmp     #$99                            ; 84DC C9 99                    ..
        bne     L84E5                           ; 84DE D0 05                    ..
        lda     $0498,y                         ; 84E0 B9 98 04                 ...
        beq     L84EC                           ; 84E3 F0 07                    ..
L84E5:  dey                                     ; 84E5 88                       .
        cpy     #$07                            ; 84E6 C0 07                    ..
        bcs     L84D9                           ; 84E8 B0 EF                    ..
        bcc     L852B                           ; 84EA 90 3F                    .?
L84EC:  rts                                     ; 84EC 60                       `

; ----------------------------------------------------------------------------
        lda     $0540,x                         ; 84ED BD 40 05                 .@.
        cmp     #$07                            ; 84F0 C9 07                    ..
        beq     L852B                           ; 84F2 F0 37                    .7
        and     #$01                            ; 84F4 29 01                    ).
        beq     L84EC                           ; 84F6 F0 F4                    ..
        lda     $0570,x                         ; 84F8 BD 70 05                 .p.
        cmp     #$08                            ; 84FB C9 08                    ..
        bne     L84EC                           ; 84FD D0 ED                    ..
        jsr     LF16F                           ; 84FF 20 6F F1                  o.
        bcs     L84EC                           ; 8502 B0 E8                    ..
        lda     #$87                            ; 8504 A9 87                    ..
        sta     $0408,y                         ; 8506 99 08 04                 ...
        lda     #$9A                            ; 8509 A9 9A                    ..
L850B:  sta     $0300,y                         ; 850B 99 00 03                 ...
        lda     $0420,x                         ; 850E BD 20 04                 . .
        sta     $0420,y                         ; 8511 99 20 04                 . .
        and     #$01                            ; 8514 29 01                    ).
        clc                                     ; 8516 18                       .
        adc     #$51                            ; 8517 69 51                    iQ
        sta     $10                             ; 8519 85 10                    ..
        lda     #$4A                            ; 851B A9 4A                    .J
        jsr     LEAF5                           ; 851D 20 F5 EA                  ..
        lda     #$00                            ; 8520 A9 00                    ..
        sta     $03A8,y                         ; 8522 99 A8 03                 ...
        lda     #$04                            ; 8525 A9 04                    ..
        sta     $03C0,y                         ; 8527 99 C0 03                 ...
        rts                                     ; 852A 60                       `

; ----------------------------------------------------------------------------
L852B:  lda     #$00                            ; 852B A9 00                    ..
        .byte   $9D                             ; 852D 9D                       .
        .byte   $80                             ; 852E 80                       .
L852F:  .byte   $04                             ; 852F 04                       .
        lda     #$44                            ; 8530 A9 44                    .D
        sta     $0588,x                         ; 8532 9D 88 05                 ...
        lda     #$A4                            ; 8535 A9 A4                    ..
        sta     $05A0,x                         ; 8537 9D A0 05                 ...
        lda     #$20                            ; 853A A9 20                    . 
        sta     $0468,x                         ; 853C 9D 68 04                 .h.
        lda     #$47                            ; 853F A9 47                    .G
L8541:  jsr     LEA98                           ; 8541 20 98 EA                  ..
        rts                                     ; 8544 60                       `

; ----------------------------------------------------------------------------
        jsr     L8541                           ; 8545 20 41 85                  A.
        ldy     $0480,x                         ; 8548 BC 80 04                 ...
        .byte   $B9                             ; 854B B9                       .
        brk                                     ; 854C 00                       .
L854D:  .byte   $03                             ; 854D 03                       .
        cmp     #$98                            ; 854E C9 98                    ..
L8550:  beq     L8555                           ; 8550 F0 03                    ..
        jmp     LF2C4                           ; 8552 4C C4 F2                 L..

; ----------------------------------------------------------------------------
L8555:  lda     $0480,y                         ; 8555 B9 80 04                 ...
        beq     L8573                           ; 8558 F0 19                    ..
        cmp     #$01                            ; 855A C9 01                    ..
        beq     L8574                           ; 855C F0 16                    ..
        inc     $03C0,x                         ; 855E FE C0 03                 ...
        lda     #$0A                            ; 8561 A9 0A                    ..
        sta     $0588,x                         ; 8563 9D 88 05                 ...
        lda     #$A6                            ; 8566 A9 A6                    ..
        sta     $05A0,x                         ; 8568 9D A0 05                 ...
        lda     #$10                            ; 856B A9 10                    ..
        sta     $0468,x                         ; 856D 9D 68 04                 .h.
        jsr     LA60A                           ; 8570 20 0A A6                  ..
L8573:  rts                                     ; 8573 60                       `

; ----------------------------------------------------------------------------
L8574:  lda     #$04                            ; 8574 A9 04                    ..
        sta     $03C0,x                         ; 8576 9D C0 03                 ...
        lda     #$83                            ; 8579 A9 83                    ..
        sta     $0588,x                         ; 857B 9D 88 05                 ...
        lda     #$A5                            ; 857E A9 A5                    ..
        sta     $05A0,x                         ; 8580 9D A0 05                 ...
        jsr     LEA65                           ; 8583 20 65 EA                  e.
        lda     $0348,x                         ; 8586 BD 48 03                 .H.
        cmp     $0348                           ; 8589 CD 48 03                 .H.
        beq     L8573                           ; 858C F0 E5                    ..
        lda     $0420,x                         ; 858E BD 20 04                 . .
        and     #$01                            ; 8591 29 01                    ).
        beq     L859E                           ; 8593 F0 09                    ..
        lda     #$10                            ; 8595 A9 10                    ..
        cmp     $0330,x                         ; 8597 DD 30 03                 .0.
        bcs     L8609                           ; 859A B0 6D                    .m
        bcc     L85A5                           ; 859C 90 07                    ..
L859E:  lda     #$F0                            ; 859E A9 F0                    ..
        cmp     $0330,x                         ; 85A0 DD 30 03                 .0.
        bcc     L8609                           ; 85A3 90 64                    .d
L85A5:  sta     $0330,x                         ; 85A5 9D 30 03                 .0.
        jsr     L852F                           ; 85A8 20 2F 85                  /.
        lda     #$00                            ; 85AB A9 00                    ..
        sta     $03A8,x                         ; 85AD 9D A8 03                 ...
        lda     #$04                            ; 85B0 A9 04                    ..
        sta     $03C0,x                         ; 85B2 9D C0 03                 ...
        lda     #$BF                            ; 85B5 A9 BF                    ..
        sta     $0588,x                         ; 85B7 9D 88 05                 ...
        lda     #$A5                            ; 85BA A9 A5                    ..
        sta     $05A0,x                         ; 85BC 9D A0 05                 ...
        ldy     $0480,x                         ; 85BF BC 80 04                 ...
        lda     $0300,y                         ; 85C2 B9 00 03                 ...
        cmp     #$98                            ; 85C5 C9 98                    ..
        beq     L85CC                           ; 85C7 F0 03                    ..
        jmp     LF2C4                           ; 85C9 4C C4 F2                 L..

; ----------------------------------------------------------------------------
L85CC:  lda     $0480,y                         ; 85CC B9 80 04                 ...
        beq     L862C                           ; 85CF F0 5B                    .[
        cmp     #$02                            ; 85D1 C9 02                    ..
        bne     L8609                           ; 85D3 D0 34                    .4
        lda     $0498,x                         ; 85D5 BD 98 04                 ...
        bne     L8609                           ; 85D8 D0 2F                    ./
        jsr     LEA65                           ; 85DA 20 65 EA                  e.
        ldy     $0480,x                         ; 85DD BC 80 04                 ...
        lda     $0300,y                         ; 85E0 B9 00 03                 ...
        cmp     #$98                            ; 85E3 C9 98                    ..
        beq     L85EA                           ; 85E5 F0 03                    ..
        jmp     LF2C4                           ; 85E7 4C C4 F2                 L..

; ----------------------------------------------------------------------------
L85EA:  lda     $0330,y                         ; 85EA B9 30 03                 .0.
        sec                                     ; 85ED 38                       8
        sbc     $0330,x                         ; 85EE FD 30 03                 .0.
        pha                                     ; 85F1 48                       H
        lda     $0348,y                         ; 85F2 B9 48 03                 .H.
        sbc     $0348,x                         ; 85F5 FD 48 03                 .H.
        pla                                     ; 85F8 68                       h
        bcs     L8600                           ; 85F9 B0 05                    ..
        eor     #$FF                            ; 85FB 49 FF                    I.
        clc                                     ; 85FD 18                       .
        adc     #$01                            ; 85FE 69 01                    i.
L8600:  cmp     #$20                            ; 8600 C9 20                    . 
L8602:  bcs     L8609                           ; 8602 B0 05                    ..
        lda     #$FF                            ; 8604 A9 FF                    ..
        sta     $0498,x                         ; 8606 9D 98 04                 ...
L8609:  rts                                     ; 8609 60                       `

; ----------------------------------------------------------------------------
        ldy     $0480,x                         ; 860A BC 80 04                 ...
        lda     $0300,y                         ; 860D B9 00 03                 ...
        cmp     #$98                            ; 8610 C9 98                    ..
        beq     L8617                           ; 8612 F0 03                    ..
        jmp     LF2C4                           ; 8614 4C C4 F2                 L..

; ----------------------------------------------------------------------------
L8617:  lda     $0480,y                         ; 8617 B9 80 04                 ...
        beq     L862C                           ; 861A F0 10                    ..
        jsr     L8541                           ; 861C 20 41 85                  A.
        dec     $0468,x                         ; 861F DE 68 04                 .h.
        bne     L8609                           ; 8622 D0 E5                    ..
        lda     #$20                            ; 8624 A9 20                    . 
        sta     $0468,x                         ; 8626 9D 68 04                 .h.
        jmp     L852F                           ; 8629 4C 2F 85                 L/.

; ----------------------------------------------------------------------------
L862C:  lda     #$01                            ; 862C A9 01                    ..
        sta     $03C0,x                         ; 862E 9D C0 03                 ...
        lda     #$45                            ; 8631 A9 45                    .E
        sta     $0588,x                         ; 8633 9D 88 05                 ...
        lda     #$A5                            ; 8636 A9 A5                    ..
        sta     $05A0,x                         ; 8638 9D A0 05                 ...
        lda     #$00                            ; 863B A9 00                    ..
        sta     $0498,x                         ; 863D 9D 98 04                 ...
        ldy     $0480,x                         ; 8640 BC 80 04                 ...
        lda     $0300,y                         ; 8643 B9 00 03                 ...
        cmp     #$98                            ; 8646 C9 98                    ..
        beq     L864D                           ; 8648 F0 03                    ..
        jmp     LF2C4                           ; 864A 4C C4 F2                 L..

; ----------------------------------------------------------------------------
L864D:  lda     $0330                           ; 864D AD 30 03                 .0.
        pha                                     ; 8650 48                       H
        lda     $0330,y                         ; 8651 B9 30 03                 .0.
        sta     $0330                           ; 8654 8D 30 03                 .0.
        jsr     LEC16                           ; 8657 20 16 EC                  ..
        pla                                     ; 865A 68                       h
        sta     $0330                           ; 865B 8D 30 03                 .0.
        rts                                     ; 865E 60                       `

; ----------------------------------------------------------------------------
        jmp     LEA65                           ; 865F 4C 65 EA                 Le.

; ----------------------------------------------------------------------------
        lda     #$20                            ; 8662 A9 20                    . 
        ldy     #$01                            ; 8664 A0 01                    ..
L8666:  sta     $0612,y                         ; 8666 99 12 06                 ...
        sta     $0616,y                         ; 8669 99 16 06                 ...
        dey                                     ; 866C 88                       .
        bpl     L8666                           ; 866D 10 F7                    ..
        sty     $18                             ; 866F 84 18                    ..
        rts                                     ; 8671 60                       `

; ----------------------------------------------------------------------------
        .byte   $FF                             ; 8672 FF                       .
        .byte   $FF                             ; 8673 FF                       .
        .byte   $FF                             ; 8674 FF                       .
        .byte   $FF                             ; 8675 FF                       .
        .byte   $FF                             ; 8676 FF                       .
        .byte   $FF                             ; 8677 FF                       .
        .byte   $FF                             ; 8678 FF                       .
L8679:  .byte   $FF                             ; 8679 FF                       .
        .byte   $FF                             ; 867A FF                       .
        .byte   $FF                             ; 867B FF                       .
        .byte   $FF                             ; 867C FF                       .
        .byte   $FF                             ; 867D FF                       .
        .byte   $FF                             ; 867E FF                       .
        .byte   $FF                             ; 867F FF                       .
        .byte   $FF                             ; 8680 FF                       .
        .byte   $FF                             ; 8681 FF                       .
        .byte   $FF                             ; 8682 FF                       .
        .byte   $FF                             ; 8683 FF                       .
        .byte   $FF                             ; 8684 FF                       .
        .byte   $FF                             ; 8685 FF                       .
        .byte   $FF                             ; 8686 FF                       .
        .byte   $FF                             ; 8687 FF                       .
        .byte   $FF                             ; 8688 FF                       .
        adc     $FFFF,x                         ; 8689 7D FF FF                 }..
        .byte   $FF                             ; 868C FF                       .
        .byte   $F7                             ; 868D F7                       .
        .byte   $FF                             ; 868E FF                       .
        .byte   $DF                             ; 868F DF                       .
        .byte   $FF                             ; 8690 FF                       .
        .byte   $FF                             ; 8691 FF                       .
        .byte   $FF                             ; 8692 FF                       .
        .byte   $FF                             ; 8693 FF                       .
        .byte   $FF                             ; 8694 FF                       .
        .byte   $FF                             ; 8695 FF                       .
        .byte   $FF                             ; 8696 FF                       .
        .byte   $FF                             ; 8697 FF                       .
        .byte   $FF                             ; 8698 FF                       .
        .byte   $FF                             ; 8699 FF                       .
        .byte   $FF                             ; 869A FF                       .
        sbc     $FFFF,x                         ; 869B FD FF FF                 ...
        .byte   $FF                             ; 869E FF                       .
        .byte   $FF                             ; 869F FF                       .
        .byte   $FF                             ; 86A0 FF                       .
        .byte   $FF                             ; 86A1 FF                       .
        .byte   $FF                             ; 86A2 FF                       .
        .byte   $FF                             ; 86A3 FF                       .
        .byte   $FF                             ; 86A4 FF                       .
        .byte   $DF                             ; 86A5 DF                       .
        .byte   $FF                             ; 86A6 FF                       .
        sbc     $FFFF,x                         ; 86A7 FD FF FF                 ...
        .byte   $FF                             ; 86AA FF                       .
        .byte   $FF                             ; 86AB FF                       .
        .byte   $FF                             ; 86AC FF                       .
        .byte   $FF                             ; 86AD FF                       .
        .byte   $FF                             ; 86AE FF                       .
        .byte   $FF                             ; 86AF FF                       .
        .byte   $FF                             ; 86B0 FF                       .
        .byte   $FF                             ; 86B1 FF                       .
        .byte   $FF                             ; 86B2 FF                       .
        .byte   $FF                             ; 86B3 FF                       .
        .byte   $FF                             ; 86B4 FF                       .
        .byte   $FF                             ; 86B5 FF                       .
        .byte   $FF                             ; 86B6 FF                       .
        .byte   $FF                             ; 86B7 FF                       .
        .byte   $FF                             ; 86B8 FF                       .
        .byte   $FF                             ; 86B9 FF                       .
        .byte   $FF                             ; 86BA FF                       .
        .byte   $FF                             ; 86BB FF                       .
        .byte   $FF                             ; 86BC FF                       .
        .byte   $F7                             ; 86BD F7                       .
        .byte   $FF                             ; 86BE FF                       .
        .byte   $FF                             ; 86BF FF                       .
        .byte   $FF                             ; 86C0 FF                       .
        .byte   $DF                             ; 86C1 DF                       .
        .byte   $FF                             ; 86C2 FF                       .
        sbc     $FFFF,x                         ; 86C3 FD FF FF                 ...
        .byte   $FF                             ; 86C6 FF                       .
        .byte   $7F                             ; 86C7 7F                       .
        .byte   $FF                             ; 86C8 FF                       .
        .byte   $FF                             ; 86C9 FF                       .
        .byte   $FF                             ; 86CA FF                       .
        .byte   $FF                             ; 86CB FF                       .
        .byte   $FF                             ; 86CC FF                       .
        sbc     $FFFF,x                         ; 86CD FD FF FF                 ...
        .byte   $FF                             ; 86D0 FF                       .
        .byte   $FF                             ; 86D1 FF                       .
        .byte   $FF                             ; 86D2 FF                       .
        .byte   $FF                             ; 86D3 FF                       .
        .byte   $FF                             ; 86D4 FF                       .
        .byte   $7F                             ; 86D5 7F                       .
        .byte   $FF                             ; 86D6 FF                       .
        .byte   $FF                             ; 86D7 FF                       .
        .byte   $FF                             ; 86D8 FF                       .
        .byte   $FF                             ; 86D9 FF                       .
        .byte   $FF                             ; 86DA FF                       .
        .byte   $7F                             ; 86DB 7F                       .
        .byte   $FF                             ; 86DC FF                       .
        .byte   $FF                             ; 86DD FF                       .
        .byte   $FF                             ; 86DE FF                       .
        .byte   $FF                             ; 86DF FF                       .
        .byte   $FF                             ; 86E0 FF                       .
        .byte   $FF                             ; 86E1 FF                       .
        .byte   $FF                             ; 86E2 FF                       .
        .byte   $FF                             ; 86E3 FF                       .
        .byte   $FF                             ; 86E4 FF                       .
        .byte   $FF                             ; 86E5 FF                       .
        .byte   $FF                             ; 86E6 FF                       .
        .byte   $FF                             ; 86E7 FF                       .
        .byte   $FF                             ; 86E8 FF                       .
        .byte   $FF                             ; 86E9 FF                       .
        .byte   $FF                             ; 86EA FF                       .
        sbc     $FFFF,x                         ; 86EB FD FF FF                 ...
        .byte   $FF                             ; 86EE FF                       .
        .byte   $FF                             ; 86EF FF                       .
        .byte   $FF                             ; 86F0 FF                       .
        .byte   $FF                             ; 86F1 FF                       .
        .byte   $FF                             ; 86F2 FF                       .
        .byte   $FF                             ; 86F3 FF                       .
        .byte   $FF                             ; 86F4 FF                       .
        .byte   $FF                             ; 86F5 FF                       .
        .byte   $FF                             ; 86F6 FF                       .
        .byte   $FF                             ; 86F7 FF                       .
        .byte   $FF                             ; 86F8 FF                       .
        .byte   $FF                             ; 86F9 FF                       .
        .byte   $FF                             ; 86FA FF                       .
        .byte   $FF                             ; 86FB FF                       .
        .byte   $FF                             ; 86FC FF                       .
        .byte   $FF                             ; 86FD FF                       .
        .byte   $FF                             ; 86FE FF                       .
        .byte   $FF                             ; 86FF FF                       .
        .byte   $FF                             ; 8700 FF                       .
        .byte   $BF                             ; 8701 BF                       .
        .byte   $FF                             ; 8702 FF                       .
        .byte   $FF                             ; 8703 FF                       .
        .byte   $FF                             ; 8704 FF                       .
        .byte   $DF                             ; 8705 DF                       .
        .byte   $FF                             ; 8706 FF                       .
        .byte   $FF                             ; 8707 FF                       .
        .byte   $FF                             ; 8708 FF                       .
        .byte   $FF                             ; 8709 FF                       .
        .byte   $FF                             ; 870A FF                       .
        .byte   $FF                             ; 870B FF                       .
        .byte   $FF                             ; 870C FF                       .
        .byte   $FF                             ; 870D FF                       .
        .byte   $FF                             ; 870E FF                       .
        sbc     $FFFF,x                         ; 870F FD FF FF                 ...
        .byte   $FF                             ; 8712 FF                       .
        cmp     $FFFF,x                         ; 8713 DD FF FF                 ...
        .byte   $FF                             ; 8716 FF                       .
        .byte   $FF                             ; 8717 FF                       .
        .byte   $FF                             ; 8718 FF                       .
        sbc     $FFFF,x                         ; 8719 FD FF FF                 ...
        .byte   $FF                             ; 871C FF                       .
        .byte   $FF                             ; 871D FF                       .
        .byte   $FF                             ; 871E FF                       .
        .byte   $FF                             ; 871F FF                       .
        .byte   $FF                             ; 8720 FF                       .
        .byte   $FF                             ; 8721 FF                       .
        .byte   $FF                             ; 8722 FF                       .
        .byte   $FF                             ; 8723 FF                       .
        .byte   $FF                             ; 8724 FF                       .
        .byte   $FF                             ; 8725 FF                       .
        .byte   $FF                             ; 8726 FF                       .
        sbc     $FFFF,x                         ; 8727 FD FF FF                 ...
        .byte   $FF                             ; 872A FF                       .
        .byte   $FF                             ; 872B FF                       .
        .byte   $FF                             ; 872C FF                       .
        .byte   $FF                             ; 872D FF                       .
        .byte   $FF                             ; 872E FF                       .
        .byte   $DF                             ; 872F DF                       .
        .byte   $FF                             ; 8730 FF                       .
        .byte   $FF                             ; 8731 FF                       .
        .byte   $FF                             ; 8732 FF                       .
        sbc     $DFFF,x                         ; 8733 FD FF DF                 ...
        .byte   $FF                             ; 8736 FF                       .
        .byte   $FF                             ; 8737 FF                       .
        .byte   $FF                             ; 8738 FF                       .
        .byte   $FF                             ; 8739 FF                       .
        .byte   $FF                             ; 873A FF                       .
        .byte   $FF                             ; 873B FF                       .
        .byte   $FF                             ; 873C FF                       .
        .byte   $DF                             ; 873D DF                       .
        .byte   $FF                             ; 873E FF                       .
        .byte   $FF                             ; 873F FF                       .
        .byte   $FF                             ; 8740 FF                       .
        .byte   $FF                             ; 8741 FF                       .
        .byte   $FF                             ; 8742 FF                       .
        .byte   $FF                             ; 8743 FF                       .
        .byte   $FF                             ; 8744 FF                       .
        .byte   $FF                             ; 8745 FF                       .
        .byte   $FF                             ; 8746 FF                       .
        .byte   $FF                             ; 8747 FF                       .
        .byte   $FF                             ; 8748 FF                       .
        .byte   $FF                             ; 8749 FF                       .
        .byte   $FF                             ; 874A FF                       .
        .byte   $DF                             ; 874B DF                       .
        .byte   $FF                             ; 874C FF                       .
        .byte   $DF                             ; 874D DF                       .
        .byte   $FF                             ; 874E FF                       .
        .byte   $FF                             ; 874F FF                       .
        .byte   $FF                             ; 8750 FF                       .
        sbc     $FF,x                           ; 8751 F5 FF                    ..
        .byte   $FF                             ; 8753 FF                       .
        .byte   $FF                             ; 8754 FF                       .
        .byte   $7F                             ; 8755 7F                       .
        .byte   $FF                             ; 8756 FF                       .
        .byte   $FF                             ; 8757 FF                       .
        .byte   $FF                             ; 8758 FF                       .
        .byte   $DF                             ; 8759 DF                       .
        .byte   $FF                             ; 875A FF                       .
        sbc     $FFFF,x                         ; 875B FD FF FF                 ...
        .byte   $FF                             ; 875E FF                       .
        .byte   $FF                             ; 875F FF                       .
        .byte   $FF                             ; 8760 FF                       .
        .byte   $FF                             ; 8761 FF                       .
        .byte   $FF                             ; 8762 FF                       .
        .byte   $FF                             ; 8763 FF                       .
        .byte   $FF                             ; 8764 FF                       .
        .byte   $FF                             ; 8765 FF                       .
        .byte   $DF                             ; 8766 DF                       .
        .byte   $FF                             ; 8767 FF                       .
        .byte   $FF                             ; 8768 FF                       .
        .byte   $FF                             ; 8769 FF                       .
        .byte   $FF                             ; 876A FF                       .
        .byte   $FF                             ; 876B FF                       .
        .byte   $FF                             ; 876C FF                       .
        .byte   $FF                             ; 876D FF                       .
        .byte   $FF                             ; 876E FF                       .
        .byte   $FF                             ; 876F FF                       .
        .byte   $FF                             ; 8770 FF                       .
        .byte   $FF                             ; 8771 FF                       .
        .byte   $FF                             ; 8772 FF                       .
        .byte   $FF                             ; 8773 FF                       .
        .byte   $FF                             ; 8774 FF                       .
        .byte   $FF                             ; 8775 FF                       .
        .byte   $FF                             ; 8776 FF                       .
        .byte   $FF                             ; 8777 FF                       .
        .byte   $FF                             ; 8778 FF                       .
        .byte   $FF                             ; 8779 FF                       .
        .byte   $FF                             ; 877A FF                       .
        .byte   $7F                             ; 877B 7F                       .
        .byte   $FF                             ; 877C FF                       .
        .byte   $FF                             ; 877D FF                       .
        .byte   $FF                             ; 877E FF                       .
        .byte   $FF                             ; 877F FF                       .
        .byte   $FF                             ; 8780 FF                       .
        .byte   $FF                             ; 8781 FF                       .
        sbc     $FFFF,x                         ; 8782 FD FF FF                 ...
        .byte   $F7                             ; 8785 F7                       .
        .byte   $FF                             ; 8786 FF                       .
        .byte   $FF                             ; 8787 FF                       .
        .byte   $FF                             ; 8788 FF                       .
        .byte   $7F                             ; 8789 7F                       .
        .byte   $FF                             ; 878A FF                       .
        .byte   $FF                             ; 878B FF                       .
        .byte   $FF                             ; 878C FF                       .
        .byte   $FF                             ; 878D FF                       .
        .byte   $FF                             ; 878E FF                       .
        .byte   $FF                             ; 878F FF                       .
        .byte   $FF                             ; 8790 FF                       .
        .byte   $FF                             ; 8791 FF                       .
        .byte   $FF                             ; 8792 FF                       .
        .byte   $FF                             ; 8793 FF                       .
        .byte   $FF                             ; 8794 FF                       .
        .byte   $FF                             ; 8795 FF                       .
        .byte   $FF                             ; 8796 FF                       .
        .byte   $FF                             ; 8797 FF                       .
        .byte   $FF                             ; 8798 FF                       .
        .byte   $FF                             ; 8799 FF                       .
        .byte   $FF                             ; 879A FF                       .
        .byte   $F7                             ; 879B F7                       .
        .byte   $FF                             ; 879C FF                       .
        .byte   $FF                             ; 879D FF                       .
        .byte   $FF                             ; 879E FF                       .
        .byte   $FF                             ; 879F FF                       .
        .byte   $FF                             ; 87A0 FF                       .
        .byte   $DF                             ; 87A1 DF                       .
        .byte   $FF                             ; 87A2 FF                       .
        .byte   $FF                             ; 87A3 FF                       .
        .byte   $F7                             ; 87A4 F7                       .
        .byte   $FF                             ; 87A5 FF                       .
        .byte   $FF                             ; 87A6 FF                       .
        .byte   $FF                             ; 87A7 FF                       .
        .byte   $FF                             ; 87A8 FF                       .
        ror     $FFFF,x                         ; 87A9 7E FF FF                 ~..
        .byte   $FF                             ; 87AC FF                       .
        .byte   $FF                             ; 87AD FF                       .
        .byte   $FF                             ; 87AE FF                       .
        .byte   $DF                             ; 87AF DF                       .
        .byte   $FF                             ; 87B0 FF                       .
        .byte   $FF                             ; 87B1 FF                       .
        .byte   $FF                             ; 87B2 FF                       .
        .byte   $FF                             ; 87B3 FF                       .
        .byte   $FF                             ; 87B4 FF                       .
        .byte   $FF                             ; 87B5 FF                       .
        .byte   $FF                             ; 87B6 FF                       .
        .byte   $DF                             ; 87B7 DF                       .
        .byte   $FF                             ; 87B8 FF                       .
        .byte   $FF                             ; 87B9 FF                       .
        .byte   $FF                             ; 87BA FF                       .
        .byte   $FF                             ; 87BB FF                       .
        .byte   $FF                             ; 87BC FF                       .
        .byte   $FF                             ; 87BD FF                       .
        .byte   $FF                             ; 87BE FF                       .
        sbc     $FFFF,x                         ; 87BF FD FF FF                 ...
        .byte   $FF                             ; 87C2 FF                       .
        .byte   $FF                             ; 87C3 FF                       .
        .byte   $FF                             ; 87C4 FF                       .
        .byte   $FF                             ; 87C5 FF                       .
        .byte   $FF                             ; 87C6 FF                       .
        .byte   $FF                             ; 87C7 FF                       .
        .byte   $FF                             ; 87C8 FF                       .
        .byte   $FF                             ; 87C9 FF                       .
        .byte   $FF                             ; 87CA FF                       .
        .byte   $FF                             ; 87CB FF                       .
        .byte   $FF                             ; 87CC FF                       .
        sbc     $FFFF,x                         ; 87CD FD FF FF                 ...
        .byte   $FF                             ; 87D0 FF                       .
        .byte   $F7                             ; 87D1 F7                       .
        .byte   $FF                             ; 87D2 FF                       .
        .byte   $FF                             ; 87D3 FF                       .
        .byte   $FF                             ; 87D4 FF                       .
        .byte   $7F                             ; 87D5 7F                       .
        .byte   $FF                             ; 87D6 FF                       .
        .byte   $DF                             ; 87D7 DF                       .
        .byte   $FF                             ; 87D8 FF                       .
        .byte   $FF                             ; 87D9 FF                       .
        .byte   $FF                             ; 87DA FF                       .
        .byte   $FF                             ; 87DB FF                       .
        .byte   $FF                             ; 87DC FF                       .
        .byte   $FF                             ; 87DD FF                       .
        .byte   $FF                             ; 87DE FF                       .
        .byte   $FF                             ; 87DF FF                       .
        .byte   $FF                             ; 87E0 FF                       .
        .byte   $FF                             ; 87E1 FF                       .
        .byte   $FF                             ; 87E2 FF                       .
        .byte   $F7                             ; 87E3 F7                       .
        .byte   $FF                             ; 87E4 FF                       .
        .byte   $FF                             ; 87E5 FF                       .
        .byte   $FF                             ; 87E6 FF                       .
        sbc     $FF,x                           ; 87E7 F5 FF                    ..
        .byte   $FF                             ; 87E9 FF                       .
        .byte   $FF                             ; 87EA FF                       .
        .byte   $FB                             ; 87EB FB                       .
        .byte   $FF                             ; 87EC FF                       .
        .byte   $FF                             ; 87ED FF                       .
        .byte   $FF                             ; 87EE FF                       .
        sbc     $FFFF,x                         ; 87EF FD FF FF                 ...
        .byte   $FF                             ; 87F2 FF                       .
        .byte   $FF                             ; 87F3 FF                       .
        .byte   $FF                             ; 87F4 FF                       .
        .byte   $FF                             ; 87F5 FF                       .
        .byte   $FF                             ; 87F6 FF                       .
        .byte   $FF                             ; 87F7 FF                       .
        .byte   $FF                             ; 87F8 FF                       .
        .byte   $7F                             ; 87F9 7F                       .
        .byte   $FF                             ; 87FA FF                       .
        .byte   $FF                             ; 87FB FF                       .
        .byte   $FF                             ; 87FC FF                       .
        .byte   $FF                             ; 87FD FF                       .
        .byte   $FF                             ; 87FE FF                       .
        .byte   $FF                             ; 87FF FF                       .
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
        ora     ($01,x)                         ; 8818 01 01                    ..
        brk                                     ; 881A 00                       .
        ora     ($01,x)                         ; 881B 01 01                    ..
        ora     (L0000,x)                       ; 881D 01 00                    ..
        brk                                     ; 881F 00                       .
        .byte   $03                             ; 8820 03                       .
        ora     (L0000,x)                       ; 8821 01 00                    ..
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
        ora     ($01,x)                         ; 8839 01 01                    ..
        ora     ($80,x)                         ; 883B 01 80                    ..
        brk                                     ; 883D 00                       .
        .byte   $02                             ; 883E 02                       .
        .byte   $80                             ; 883F 80                       .
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
        ora     ($01,x)                         ; 884F 01 01                    ..
        .byte   $80                             ; 8851 80                       .
        ora     ($01,x)                         ; 8852 01 01                    ..
        ora     ($80,x)                         ; 8854 01 80                    ..
        ora     (L0000,x)                       ; 8856 01 00                    ..
        .byte   $80                             ; 8858 80                       .
        ora     ($01,x)                         ; 8859 01 01                    ..
        brk                                     ; 885B 00                       .
        ora     ($02,x)                         ; 885C 01 02                    ..
        brk                                     ; 885E 00                       .
        brk                                     ; 885F 00                       .
        ora     ($80,x)                         ; 8860 01 80                    ..
        ora     ($01,x)                         ; 8862 01 01                    ..
        ora     ($01,x)                         ; 8864 01 01                    ..
        .byte   $02                             ; 8866 02                       .
        ora     ($01,x)                         ; 8867 01 01                    ..
        ora     ($80,x)                         ; 8869 01 80                    ..
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
        ora     ($01,x)                         ; 887B 01 01                    ..
        brk                                     ; 887D 00                       .
        .byte   $80                             ; 887E 80                       .
        .byte   $80                             ; 887F 80                       .
        .byte   $80                             ; 8880 80                       .
        .byte   $04                             ; 8881 04                       .
        .byte   $80                             ; 8882 80                       .
        ora     ($80,x)                         ; 8883 01 80                    ..
        .byte   $80                             ; 8885 80                       .
        ora     ($80,x)                         ; 8886 01 80                    ..
        brk                                     ; 8888 00                       .
        ora     ($80,x)                         ; 8889 01 80                    ..
        .byte   $80                             ; 888B 80                       .
        brk                                     ; 888C 00                       .
        ora     (L0000,x)                       ; 888D 01 00                    ..
        .byte   $80                             ; 888F 80                       .
        .byte   $80                             ; 8890 80                       .
        ora     (L0000,x)                       ; 8891 01 00                    ..
        ora     ($80,x)                         ; 8893 01 80                    ..
        .byte   $80                             ; 8895 80                       .
        ora     ($80,x)                         ; 8896 01 80                    ..
        .byte   $02                             ; 8898 02                       .
        brk                                     ; 8899 00                       .
        .byte   $80                             ; 889A 80                       .
        .byte   $80                             ; 889B 80                       .
        .byte   $02                             ; 889C 02                       .
        .byte   $80                             ; 889D 80                       .
        ora     ($80,x)                         ; 889E 01 80                    ..
        .byte   $04                             ; 88A0 04                       .
        brk                                     ; 88A1 00                       .
        brk                                     ; 88A2 00                       .
        brk                                     ; 88A3 00                       .
        brk                                     ; 88A4 00                       .
        ora     (L0000,x)                       ; 88A5 01 00                    ..
        .byte   $80                             ; 88A7 80                       .
        .byte   $80                             ; 88A8 80                       .
        brk                                     ; 88A9 00                       .
        ora     ($80,x)                         ; 88AA 01 80                    ..
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
        brk                                     ; 8918 00                       .
        brk                                     ; 8919 00                       .
        brk                                     ; 891A 00                       .
        brk                                     ; 891B 00                       .
        brk                                     ; 891C 00                       .
        .byte   $80                             ; 891D 80                       .
        brk                                     ; 891E 00                       .
        brk                                     ; 891F 00                       .
        brk                                     ; 8920 00                       .
        brk                                     ; 8921 00                       .
        brk                                     ; 8922 00                       .
L8923:  brk                                     ; 8923 00                       .
        brk                                     ; 8924 00                       .
        brk                                     ; 8925 00                       .
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
        jsr     LA380                           ; 8950 20 80 A3                  ..
        rti                                     ; 8953 40                       @

; ----------------------------------------------------------------------------
        .byte   $62                             ; 8954 62                       b
        .byte   $80                             ; 8955 80                       .
        ldx     #$40                            ; 8956 A2 40                    .@
        .byte   $62                             ; 8958 62                       b
        .byte   $80                             ; 8959 80                       .
        ldx     #$20                            ; 895A A2 20                    . 
        jsr     L0000                           ; 895C 20 00 00                  ..
        brk                                     ; 895F 00                       .
        brk                                     ; 8960 00                       .
        brk                                     ; 8961 00                       .
        .byte   $02                             ; 8962 02                       .
        brk                                     ; 8963 00                       .
        brk                                     ; 8964 00                       .
        brk                                     ; 8965 00                       .
        brk                                     ; 8966 00                       .
        brk                                     ; 8967 00                       .
        .byte   $1C                             ; 8968 1C                       .
        .byte   $02                             ; 8969 02                       .
        .byte   $23                             ; 896A 23                       #
        ora     $2A03,y                         ; 896B 19 03 2A                 ..*
        .byte   $1C                             ; 896E 1C                       .
        brk                                     ; 896F 00                       .
        .byte   $2B                             ; 8970 2B                       +
        .byte   $1C                             ; 8971 1C                       .
        bit     $80                             ; 8972 24 80                    $.
        .byte   $BB                             ; 8974 BB                       .
        brk                                     ; 8975 00                       .
        brk                                     ; 8976 00                       .
        .byte   $02                             ; 8977 02                       .
        brk                                     ; 8978 00                       .
        brk                                     ; 8979 00                       .
        brk                                     ; 897A 00                       .
        brk                                     ; 897B 00                       .
        brk                                     ; 897C 00                       .
        brk                                     ; 897D 00                       .
        brk                                     ; 897E 00                       .
        brk                                     ; 897F 00                       .
        ldy     $A6                             ; 8980 A4 A6                    ..
        brk                                     ; 8982 00                       .
        brk                                     ; 8983 00                       .
        brk                                     ; 8984 00                       .
        brk                                     ; 8985 00                       .
        brk                                     ; 8986 00                       .
        brk                                     ; 8987 00                       .
        .byte   $0F                             ; 8988 0F                       .
        bmi     L899B                           ; 8989 30 10                    0.
        clc                                     ; 898B 18                       .
        .byte   $0F                             ; 898C 0F                       .
        bmi     L89B2                           ; 898D 30 23                    0#
        .byte   $0C                             ; 898F 0C                       .
        .byte   $0F                             ; 8990 0F                       .
        .byte   $37                             ; 8991 37                       7
        clc                                     ; 8992 18                       .
        php                                     ; 8993 08                       .
        .byte   $0F                             ; 8994 0F                       .
        bmi     L8997                           ; 8995 30 00                    0.
L8997:  .byte   $0B                             ; 8997 0B                       .
        brk                                     ; 8998 00                       .
        brk                                     ; 8999 00                       .
        .byte   $93                             ; 899A 93                       .
L899B:  brk                                     ; 899B 00                       .
        brk                                     ; 899C 00                       .
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
L89B2:  brk                                     ; 89B2 00                       .
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
        bpl     L89C7                           ; 89C5 10 00                    ..
L89C7:  brk                                     ; 89C7 00                       .
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
        bpl     L89E7                           ; 89E5 10 00                    ..
L89E7:  brk                                     ; 89E7 00                       .
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
        brk                                     ; 89F9 00                       .
        brk                                     ; 89FA 00                       .
        brk                                     ; 89FB 00                       .
        brk                                     ; 89FC 00                       .
        brk                                     ; 89FD 00                       .
        brk                                     ; 89FE 00                       .
        brk                                     ; 89FF 00                       .
        brk                                     ; 8A00 00                       .
        brk                                     ; 8A01 00                       .
        ora     ($01,x)                         ; 8A02 01 01                    ..
        ora     ($02,x)                         ; 8A04 01 02                    ..
        .byte   $02                             ; 8A06 02                       .
        .byte   $03                             ; 8A07 03                       .
        .byte   $03                             ; 8A08 03                       .
        .byte   $03                             ; 8A09 03                       .
        .byte   $04                             ; 8A0A 04                       .
        .byte   $04                             ; 8A0B 04                       .
        .byte   $04                             ; 8A0C 04                       .
L8A0D:  .byte   $04                             ; 8A0D 04                       .
        .byte   $04                             ; 8A0E 04                       .
        ora     $05                             ; 8A0F 05 05                    ..
        ora     $06                             ; 8A11 05 06                    ..
        asl     $06                             ; 8A13 06 06                    ..
        php                                     ; 8A15 08                       .
        php                                     ; 8A16 08                       .
        php                                     ; 8A17 08                       .
        ora     #$09                            ; 8A18 09 09                    ..
        ora     #$0A                            ; 8A1A 09 0A                    ..
        asl     a                               ; 8A1C 0A                       .
        asl     a                               ; 8A1D 0A                       .
        asl     a                               ; 8A1E 0A                       .
        .byte   $0B                             ; 8A1F 0B                       .
        .byte   $0B                             ; 8A20 0B                       .
        .byte   $0B                             ; 8A21 0B                       .
        .byte   $0B                             ; 8A22 0B                       .
        .byte   $0C                             ; 8A23 0C                       .
        .byte   $0C                             ; 8A24 0C                       .
L8A25:  .byte   $0C                             ; 8A25 0C                       .
        ora     $0D0D                           ; 8A26 0D 0D 0D                 ...
        asl     $1010                           ; 8A29 0E 10 10                 ...
        ora     ($11),y                         ; 8A2C 11 11                    ..
        .byte   $12                             ; 8A2E 12                       .
        .byte   $12                             ; 8A2F 12                       .
        .byte   $12                             ; 8A30 12                       .
        .byte   $13                             ; 8A31 13                       .
        .byte   $13                             ; 8A32 13                       .
        .byte   $13                             ; 8A33 13                       .
        .byte   $14                             ; 8A34 14                       .
        .byte   $14                             ; 8A35 14                       .
        .byte   $14                             ; 8A36 14                       .
L8A37:  .byte   $14                             ; 8A37 14                       .
        ora     $15,x                           ; 8A38 15 15                    ..
        .byte   $15                             ; 8A3A 15                       .
L8A3B:  ora     $17,x                           ; 8A3B 15 17                    ..
        .byte   $FF                             ; 8A3D FF                       .
        brk                                     ; 8A3E 00                       .
        brk                                     ; 8A3F 00                       .
        brk                                     ; 8A40 00                       .
        brk                                     ; 8A41 00                       .
        brk                                     ; 8A42 00                       .
L8A43:  brk                                     ; 8A43 00                       .
        brk                                     ; 8A44 00                       .
        brk                                     ; 8A45 00                       .
        brk                                     ; 8A46 00                       .
        brk                                     ; 8A47 00                       .
        brk                                     ; 8A48 00                       .
        brk                                     ; 8A49 00                       .
        brk                                     ; 8A4A 00                       .
        brk                                     ; 8A4B 00                       .
        brk                                     ; 8A4C 00                       .
        brk                                     ; 8A4D 00                       .
        brk                                     ; 8A4E 00                       .
        brk                                     ; 8A4F 00                       .
        brk                                     ; 8A50 00                       .
        brk                                     ; 8A51 00                       .
        brk                                     ; 8A52 00                       .
        brk                                     ; 8A53 00                       .
        brk                                     ; 8A54 00                       .
        brk                                     ; 8A55 00                       .
        brk                                     ; 8A56 00                       .
        brk                                     ; 8A57 00                       .
        .byte   $20                             ; 8A58 20                        
        brk                                     ; 8A59 00                       .
L8A5A:  brk                                     ; 8A5A 00                       .
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
        brk                                     ; 8A67 00                       .
        brk                                     ; 8A68 00                       .
        brk                                     ; 8A69 00                       .
        brk                                     ; 8A6A 00                       .
        brk                                     ; 8A6B 00                       .
        brk                                     ; 8A6C 00                       .
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
        brk                                     ; 8A7C 00                       .
        brk                                     ; 8A7D 00                       .
        brk                                     ; 8A7E 00                       .
        brk                                     ; 8A7F 00                       .
        pla                                     ; 8A80 68                       h
        tya                                     ; 8A81 98                       .
        pha                                     ; 8A82 48                       H
        tya                                     ; 8A83 98                       .
        clv                                     ; 8A84 B8                       .
        cpx     #$E8                            ; 8A85 E0 E8                    ..
        bmi     L8AE9                           ; 8A87 30 60                    0`
        bcs     L8AAB                           ; 8A89 B0 20                    . 
        bvc     L8A0D                           ; 8A8B 50 80                    P.
        inx                                     ; 8A8D E8                       .
        beq     L8AF0                           ; 8A8E F0 60                    .`
        bcs     L8A43                           ; 8A90 B0 B1                    ..
        brk                                     ; 8A92 00                       .
        bvc     L8A25                           ; 8A93 50 90                    P.
        plp                                     ; 8A95 28                       (
        dey                                     ; 8A96 88                       .
        bcc     L8AE1                           ; 8A97 90 48                    .H
        tay                                     ; 8A99 A8                       .
        cld                                     ; 8A9A D8                       .
        brk                                     ; 8A9B 00                       .
        jsr     LC030                           ; 8A9C 20 30 C0                  0.
        brk                                     ; 8A9F 00                       .
        bcc     L8A5A                           ; 8AA0 90 B8                    ..
        bne     L8AC4                           ; 8AA2 D0 20                    . 
        pha                                     ; 8AA4 48                       H
        bcs     L8B1E                           ; 8AA5 B0 77                    .w
        sei                                     ; 8AA7 78                       x
        .byte   $80                             ; 8AA8 80                       .
        bmi     L8A3B                           ; 8AA9 30 90                    0.
L8AAB:  .byte   $D0                             ; 8AAB D0                       .
L8AAC:  .byte   $10,$50                    ; 8AAC 10 50   (branch out of range for ca65: target has no local label)
        .byte   $70                             ; 8AAE 70                       p
L8AAF:  dey                                     ; 8AAF 88                       .
        bcs     L8AF2                           ; 8AB0 B0 40                    .@
        dey                                     ; 8AB2 88                       .
        bne     L8AC5                           ; 8AB3 D0 10                    ..
        bmi     L8A37                           ; 8AB5 30 80                    0.
        cpy     #$20                            ; 8AB7 C0 20                    . 
        rti                                     ; 8AB9 40                       @

; ----------------------------------------------------------------------------
        ldy     #$D0                            ; 8ABA A0 D0                    ..
        cld                                     ; 8ABC D8                       .
L8ABD:  .byte   $FF                             ; 8ABD FF                       .
        brk                                     ; 8ABE 00                       .
        brk                                     ; 8ABF 00                       .
        brk                                     ; 8AC0 00                       .
        brk                                     ; 8AC1 00                       .
        brk                                     ; 8AC2 00                       .
        brk                                     ; 8AC3 00                       .
L8AC4:  brk                                     ; 8AC4 00                       .
L8AC5:  brk                                     ; 8AC5 00                       .
        brk                                     ; 8AC6 00                       .
        brk                                     ; 8AC7 00                       .
        brk                                     ; 8AC8 00                       .
        brk                                     ; 8AC9 00                       .
        brk                                     ; 8ACA 00                       .
        brk                                     ; 8ACB 00                       .
        brk                                     ; 8ACC 00                       .
        .byte   $04                             ; 8ACD 04                       .
        brk                                     ; 8ACE 00                       .
L8ACF:  brk                                     ; 8ACF 00                       .
        brk                                     ; 8AD0 00                       .
        brk                                     ; 8AD1 00                       .
        brk                                     ; 8AD2 00                       .
        brk                                     ; 8AD3 00                       .
        brk                                     ; 8AD4 00                       .
        brk                                     ; 8AD5 00                       .
        brk                                     ; 8AD6 00                       .
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
L8AE1:  brk                                     ; 8AE1 00                       .
        brk                                     ; 8AE2 00                       .
        brk                                     ; 8AE3 00                       .
        .byte   $02                             ; 8AE4 02                       .
        brk                                     ; 8AE5 00                       .
        brk                                     ; 8AE6 00                       .
        brk                                     ; 8AE7 00                       .
        brk                                     ; 8AE8 00                       .
L8AE9:  brk                                     ; 8AE9 00                       .
        .byte   $80                             ; 8AEA 80                       .
        brk                                     ; 8AEB 00                       .
        brk                                     ; 8AEC 00                       .
        brk                                     ; 8AED 00                       .
        brk                                     ; 8AEE 00                       .
L8AEF:  brk                                     ; 8AEF 00                       .
L8AF0:  brk                                     ; 8AF0 00                       .
        brk                                     ; 8AF1 00                       .
L8AF2:  brk                                     ; 8AF2 00                       .
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
        brk                                     ; 8AFD 00                       .
        brk                                     ; 8AFE 00                       .
        brk                                     ; 8AFF 00                       .
        lsr     $56,x                           ; 8B00 56 56                    VV
        bcs     L8B6C                           ; 8B02 B0 68                    .h
        bcs     L8B46                           ; 8B04 B0 40                    .@
        bcs     L8B58                           ; 8B06 B0 50                    .P
        bcc     L8B6A                           ; 8B08 90 60                    .`
        bvs     L8AAC                           ; 8B0A 70 A0                    p.
        .byte   $80                             ; 8B0C 80                       .
        bvs     L8AAF                           ; 8B0D 70 A0                    p.
        ldy     #$80                            ; 8B0F A0 80                    ..
        bcs     L8B13                           ; 8B11 B0 00                    ..
L8B13:  stx     $66,y                           ; 8B13 96 66                    .f
        rts                                     ; 8B15 60                       `

; ----------------------------------------------------------------------------
L8B16:  bvs     L8B50                           ; 8B16 70 38                    p8
        jsr     L6040                           ; 8B18 20 40 60                  @`
        brk                                     ; 8B1B 00                       .
        bmi     L8ACF                           ; 8B1C 30 B1                    0.
L8B1E:  .byte   $71                             ; 8B1E 71                       q
L8B1F:  brk                                     ; 8B1F 00                       .
        pla                                     ; 8B20 68                       h
        sec                                     ; 8B21 38                       8
        sty     $70,x                           ; 8B22 94 70                    .p
        sta     $45                             ; 8B24 85 45                    .E
        sei                                     ; 8B26 78                       x
        tya                                     ; 8B27 98                       .
        bmi     L8BA2                           ; 8B28 30 78                    0x
        bmi     L8B5C                           ; 8B2A 30 30                    00
        bmi     L8B5E                           ; 8B2C 30 30                    00
        .byte   $80                             ; 8B2E 80                       .
        cpy     #$68                            ; 8B2F C0 68                    .h
        sec                                     ; 8B31 38                       8
        pha                                     ; 8B32 48                       H
        .byte   $74                             ; 8B33 74                       t
        bmi     L8B16                           ; 8B34 30 E0                    0.
        .byte   $54                             ; 8B36 54                       T
        rti                                     ; 8B37 40                       @

; ----------------------------------------------------------------------------
        .byte   $44                             ; 8B38 44                       D
        bcs     L8AEF                           ; 8B39 B0 B4                    ..
        rti                                     ; 8B3B 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8B3C 00                       .
        .byte   $FF                             ; 8B3D FF                       .
        brk                                     ; 8B3E 00                       .
        brk                                     ; 8B3F 00                       .
        brk                                     ; 8B40 00                       .
        brk                                     ; 8B41 00                       .
        brk                                     ; 8B42 00                       .
        brk                                     ; 8B43 00                       .
        brk                                     ; 8B44 00                       .
        brk                                     ; 8B45 00                       .
L8B46:  brk                                     ; 8B46 00                       .
        brk                                     ; 8B47 00                       .
        brk                                     ; 8B48 00                       .
        brk                                     ; 8B49 00                       .
        brk                                     ; 8B4A 00                       .
        brk                                     ; 8B4B 00                       .
        brk                                     ; 8B4C 00                       .
        brk                                     ; 8B4D 00                       .
        brk                                     ; 8B4E 00                       .
        brk                                     ; 8B4F 00                       .
L8B50:  brk                                     ; 8B50 00                       .
        brk                                     ; 8B51 00                       .
        brk                                     ; 8B52 00                       .
        brk                                     ; 8B53 00                       .
        brk                                     ; 8B54 00                       .
        brk                                     ; 8B55 00                       .
        brk                                     ; 8B56 00                       .
        brk                                     ; 8B57 00                       .
L8B58:  brk                                     ; 8B58 00                       .
        brk                                     ; 8B59 00                       .
        brk                                     ; 8B5A 00                       .
        brk                                     ; 8B5B 00                       .
L8B5C:  brk                                     ; 8B5C 00                       .
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
L8B6A:  brk                                     ; 8B6A 00                       .
        brk                                     ; 8B6B 00                       .
L8B6C:  brk                                     ; 8B6C 00                       .
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
L8B79:  brk                                     ; 8B79 00                       .
        brk                                     ; 8B7A 00                       .
        brk                                     ; 8B7B 00                       .
        brk                                     ; 8B7C 00                       .
        brk                                     ; 8B7D 00                       .
        brk                                     ; 8B7E 00                       .
        brk                                     ; 8B7F 00                       .
        .byte   $2F                             ; 8B80 2F                       /
        rol     L8214                           ; 8B81 2E 14 82                 ...
        .byte   $14                             ; 8B84 14                       .
        rol     $36,x                           ; 8B85 36 36                    66
        rol     $09,x                           ; 8B87 36 09                    6.
        rol     $36,x                           ; 8B89 36 36                    66
        ora     #$36                            ; 8B8B 09 36                    .6
        rol     $09,x                           ; 8B8D 36 09                    6.
        rol     $36,x                           ; 8B8F 36 36                    66
        ora     #$C0                            ; 8B91 09 C0                    ..
        rol     $022F                           ; 8B93 2E 2F 02                 ./.
        .byte   $02                             ; 8B96 02                       .
        .byte   $02                             ; 8B97 02                       .
        .byte   $02                             ; 8B98 02                       .
        .byte   $02                             ; 8B99 02                       .
        .byte   $02                             ; 8B9A 02                       .
        cpy     #$18                            ; 8B9B C0 18                    ..
        clc                                     ; 8B9D 18                       .
        clc                                     ; 8B9E 18                       .
        .byte   $C2                             ; 8B9F C2                       .
        .byte   $12                             ; 8BA0 12                       .
        .byte   $86                             ; 8BA1 86                       .
L8BA2:  .byte   $33                             ; 8BA2 33                       3
        .byte   $12                             ; 8BA3 12                       .
        .byte   $33                             ; 8BA4 33                       3
        .byte   $33                             ; 8BA5 33                       3
        sty     $81                             ; 8BA6 84 81                    ..
        .byte   $33                             ; 8BA8 33                       3
        .byte   $83                             ; 8BA9 83                       .
        .byte   $2B                             ; 8BAA 2B                       +
        .byte   $2B                             ; 8BAB 2B                       +
        .byte   $2B                             ; 8BAC 2B                       +
        .byte   $2B                             ; 8BAD 2B                       +
        php                                     ; 8BAE 08                       .
        php                                     ; 8BAF 08                       .
        sty     $3F                             ; 8BB0 84 3F                    .?
        .byte   $3F                             ; 8BB2 3F                       ?
        .byte   $04                             ; 8BB3 04                       .
        .byte   $3F                             ; 8BB4 3F                       ?
        .byte   $3F                             ; 8BB5 3F                       ?
        .byte   $04                             ; 8BB6 04                       .
        .byte   $3F                             ; 8BB7 3F                       ?
        .byte   $04                             ; 8BB8 04                       .
        .byte   $3F                             ; 8BB9 3F                       ?
        .byte   $04                             ; 8BBA 04                       .
        .byte   $3F                             ; 8BBB 3F                       ?
        ror     a                               ; 8BBC 6A                       j
        .byte   $FF                             ; 8BBD FF                       .
        brk                                     ; 8BBE 00                       .
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
        brk                                     ; 8BCA 00                       .
        brk                                     ; 8BCB 00                       .
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
        .byte   $02                             ; 8C01 02                       .
        ora     $07                             ; 8C02 05 07                    ..
        asl     a                               ; 8C04 0A                       .
        .byte   $0F                             ; 8C05 0F                       .
        .byte   $12                             ; 8C06 12                       .
        ora     $15,x                           ; 8C07 15 15                    ..
        clc                                     ; 8C09 18                       .
        .byte   $1B                             ; 8C0A 1B                       .
        .byte   $1F                             ; 8C0B 1F                       .
        .byte   $23                             ; 8C0C 23                       #
        rol     $29                             ; 8C0D 26 29                    &)
        rol     a                               ; 8C0F 2A                       *
        rol     a                               ; 8C10 2A                       *
        bit     $312E                           ; 8C11 2C 2E 31                 ,.1
        .byte   $34                             ; 8C14 34                       4
        sec                                     ; 8C15 38                       8
        .byte   $3C                             ; 8C16 3C                       <
        .byte   $3C                             ; 8C17 3C                       <
        brk                                     ; 8C18 00                       .
        brk                                     ; 8C19 00                       .
        brk                                     ; 8C1A 00                       .
        brk                                     ; 8C1B 00                       .
        brk                                     ; 8C1C 00                       .
        brk                                     ; 8C1D 00                       .
        brk                                     ; 8C1E 00                       .
        bpl     L8C21                           ; 8C1F 10 00                    ..
L8C21:  rti                                     ; 8C21 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8C22 00                       .
        brk                                     ; 8C23 00                       .
        brk                                     ; 8C24 00                       .
        bpl     L8C27                           ; 8C25 10 00                    ..
L8C27:  brk                                     ; 8C27 00                       .
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
        bpl     L8C34                           ; 8C32 10 00                    ..
L8C34:  brk                                     ; 8C34 00                       .
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
        asl     L0000                           ; 8C48 06 00                    ..
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
        .byte   $02                             ; 8C94 02                       .
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
        rts                                     ; 8CA4 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; 8CA5 00                       .
        jsr     L0000                           ; 8CA6 20 00 00                  ..
        brk                                     ; 8CA9 00                       .
        brk                                     ; 8CAA 00                       .
        .byte   $04                             ; 8CAB 04                       .
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
        rti                                     ; 8CBA 40                       @

; ----------------------------------------------------------------------------
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
L8CC6:  brk                                     ; 8CC6 00                       .
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
        .byte   $04                             ; 8CF0 04                       .
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
        rti                                     ; 8CFC 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8CFD 00                       .
        brk                                     ; 8CFE 00                       .
        .byte   $04                             ; 8CFF 04                       .
        brk                                     ; 8D00 00                       .
        ora     ($02,x)                         ; 8D01 01 02                    ..
        .byte   $04                             ; 8D03 04                       .
        asl     $08                             ; 8D04 06 08                    ..
        asl     a                               ; 8D06 0A                       .
        brk                                     ; 8D07 00                       .
        .byte   $02                             ; 8D08 02                       .
        .byte   $12                             ; 8D09 12                       .
        brk                                     ; 8D0A 00                       .
        .byte   $04                             ; 8D0B 04                       .
        brk                                     ; 8D0C 00                       .
        .byte   $0C                             ; 8D0D 0C                       .
        asl     a:L0000                         ; 8D0E 0E 00 00                 ...
        brk                                     ; 8D11 00                       .
        .byte   $82                             ; 8D12 82                       .
        brk                                     ; 8D13 00                       .
        brk                                     ; 8D14 00                       .
        brk                                     ; 8D15 00                       .
        bne     L8CC6                           ; 8D16 D0 AE                    ..
        .byte   $CB                             ; 8D18 CB                       .
        cmp     $A6A3                           ; 8D19 CD A3 A6                 ...
        .byte   $80                             ; 8D1C 80                       .
        .byte   $82                             ; 8D1D 82                       .
        .byte   $83                             ; 8D1E 83                       .
        stx     $80                             ; 8D1F 86 80                    ..
        .byte   $82                             ; 8D21 82                       .
        .byte   $82                             ; 8D22 82                       .
        ora     ($80),y                         ; 8D23 11 80                    ..
        .byte   $82                             ; 8D25 82                       .
        .byte   $82                             ; 8D26 82                       .
        .byte   $02                             ; 8D27 02                       .
        ldy     #$11                            ; 8D28 A0 11                    ..
        ora     ($82),y                         ; 8D2A 11 82                    ..
        ldy     #$80                            ; 8D2C A0 80                    ..
        .byte   $82                             ; 8D2E 82                       .
        .byte   $80                             ; 8D2F 80                       .
        cpy     #$C2                            ; 8D30 C0 C2                    ..
        dec     $85                             ; 8D32 C6 85                    ..
        cpy     #$C2                            ; 8D34 C0 C2                    ..
        dec     $A5                             ; 8D36 C6 A5                    ..
        .byte   $D7                             ; 8D38 D7                       .
        .byte   $E2                             ; 8D39 E2                       .
        inc     $A5                             ; 8D3A E6 A5                    ..
        iny                                     ; 8D3C C8                       .
        dex                                     ; 8D3D CA                       .
        brk                                     ; 8D3E 00                       .
        cpy     #$20                            ; 8D3F C0 20                    . 
        brk                                     ; 8D41 00                       .
        .byte   $22                             ; 8D42 22                       "
        bit     $34                             ; 8D43 24 34                    $4
        lsr     a                               ; 8D45 4A                       J
        and     #$2B                            ; 8D46 29 2B                    )+
        rti                                     ; 8D48 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; 8D49 00                       .
        .byte   $42                             ; 8D4A 42                       B
        eor     #$00                            ; 8D4B 49 00                    I.
        brk                                     ; 8D4D 00                       .
        brk                                     ; 8D4E 00                       .
        pha                                     ; 8D4F 48                       H
        .byte   $42                             ; 8D50 42                       B
        .byte   $42                             ; 8D51 42                       B
        .byte   $42                             ; 8D52 42                       B
        brk                                     ; 8D53 00                       .
        brk                                     ; 8D54 00                       .
        brk                                     ; 8D55 00                       .
        brk                                     ; 8D56 00                       .
        pla                                     ; 8D57 68                       h
        .byte   $42                             ; 8D58 42                       B
        brk                                     ; 8D59 00                       .
        rol     $42,x                           ; 8D5A 36 42                    6B
        .byte   $27                             ; 8D5C 27                       '
        .byte   $47                             ; 8D5D 47                       G
        brk                                     ; 8D5E 00                       .
        .byte   $5A                             ; 8D5F 5A                       Z
        brk                                     ; 8D60 00                       .
        brk                                     ; 8D61 00                       .
        brk                                     ; 8D62 00                       .
        brk                                     ; 8D63 00                       .
        brk                                     ; 8D64 00                       .
        ror     $01,x                           ; 8D65 76 01                    v.
        brk                                     ; 8D67 00                       .
        .byte   $54                             ; 8D68 54                       T
        eor     L0000,x                         ; 8D69 55 00                    U.
        brk                                     ; 8D6B 00                       .
        brk                                     ; 8D6C 00                       .
        ror     $C4,x                           ; 8D6D 76 C4                    v.
        brk                                     ; 8D6F 00                       .
        .byte   $74                             ; 8D70 74                       t
        adc     L0000,x                         ; 8D71 75 00                    u.
        brk                                     ; 8D73 00                       .
        brk                                     ; 8D74 00                       .
        brk                                     ; 8D75 00                       .
        .byte   $63                             ; 8D76 63                       c
        brk                                     ; 8D77 00                       .
        brk                                     ; 8D78 00                       .
        brk                                     ; 8D79 00                       .
        brk                                     ; 8D7A 00                       .
        brk                                     ; 8D7B 00                       .
        brk                                     ; 8D7C 00                       .
        brk                                     ; 8D7D 00                       .
        .byte   $63                             ; 8D7E 63                       c
        brk                                     ; 8D7F 00                       .
        inx                                     ; 8D80 E8                       .
        nop                                     ; 8D81 EA                       .
        .byte   $EB                             ; 8D82 EB                       .
        sbc     L82EE                           ; 8D83 ED EE 82                 ...
        dey                                     ; 8D86 88                       .
        txa                                     ; 8D87 8A                       .
        sbc     #$EA                            ; 8D88 E9 EA                    ..
        cpy     #$00                            ; 8D8A C0 00                    ..
        brk                                     ; 8D8C 00                       .
        tsx                                     ; 8D8D BA                       .
L8D8E:  tya                                     ; 8D8E 98                       .
        ldy     L8280                           ; 8D8F AC 80 82                 ...
        dex                                     ; 8D92 CA                       .
        brk                                     ; 8D93 00                       .
        brk                                     ; 8D94 00                       .
        .byte   $82                             ; 8D95 82                       .
        tya                                     ; 8D96 98                       .
        txs                                     ; 8D97 9A                       .
        brk                                     ; 8D98 00                       .
        brk                                     ; 8D99 00                       .
        cpy     #$00                            ; 8D9A C0 00                    ..
        brk                                     ; 8D9C 00                       .
        ldx     $6C6A,y                         ; 8D9D BE 6A 6C                 .jl
        lsr     $3D4E                           ; 8DA0 4E 4E 3D                 NN=
        brk                                     ; 8DA3 00                       .
        brk                                     ; 8DA4 00                       .
        brk                                     ; 8DA5 00                       .
        brk                                     ; 8DA6 00                       .
        brk                                     ; 8DA7 00                       .
        bit     $3E5E                           ; 8DA8 2C 5E 3E                 ,^>
        rol     a:L0000,x                       ; 8DAB 3E 00 00                 >..
        brk                                     ; 8DAE 00                       .
        brk                                     ; 8DAF 00                       .
        .byte   $5C                             ; 8DB0 5C                       \
        lsr     a:L0000,x                       ; 8DB1 5E 00 00                 ^..
        lsr     L8E8E,x                         ; 8DB4 5E 8E 8E                 ^..
        brk                                     ; 8DB7 00                       .
        .byte   $CF                             ; 8DB8 CF                       .
        lsr     $A200,x                         ; 8DB9 5E 00 A2                 ^..
        lsr     $0101,x                         ; 8DBC 5E 01 01                 ^..
        brk                                     ; 8DBF 00                       .
        .byte   $5C                             ; 8DC0 5C                       \
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
        ora     ($03,x)                         ; 8E01 01 03                    ..
        ora     $07                             ; 8E03 05 07                    ..
        ora     #$0B                            ; 8E05 09 0B                    ..
        brk                                     ; 8E07 00                       .
        .byte   $03                             ; 8E08 03                       .
        .byte   $13                             ; 8E09 13                       .
        brk                                     ; 8E0A 00                       .
        ora     L0000                           ; 8E0B 05 00                    ..
        ora     a:$0F                           ; 8E0D 0D 0F 00                 ...
        brk                                     ; 8E10 00                       .
        brk                                     ; 8E11 00                       .
        sty     L0000                           ; 8E12 84 00                    ..
        brk                                     ; 8E14 00                       .
        brk                                     ; 8E15 00                       .
        lda     $CCAF                           ; 8E16 AD AF CC                 ...
        .byte   $CB                             ; 8E19 CB                       .
        ldy     $A7                             ; 8E1A A4 A7                    ..
        sta     ($87,x)                         ; 8E1C 81 87                    ..
        stx     $83                             ; 8E1E 86 83                    ..
        sta     ($81,x)                         ; 8E20 81 81                    ..
        .byte   $87                             ; 8E22 87                       .
        sta     $81                             ; 8E23 85 81                    ..
        sta     ($87,x)                         ; 8E25 81 87                    ..
        .byte   $03                             ; 8E27 03                       .
        ora     ($11),y                         ; 8E28 11 11                    ..
        .byte   $97                             ; 8E2A 97                       .
        lda     $85                             ; 8E2B A5 85                    ..
        lda     $87,x                           ; 8E2D B5 87                    ..
        .byte   $87                             ; 8E2F 87                       .
        cmp     ($C2,x)                         ; 8E30 C1 C2                    ..
        .byte   $C7                             ; 8E32 C7                       .
        sta     $C1                             ; 8E33 85 C1                    ..
        .byte   $C2                             ; 8E35 C2                       .
        .byte   $C7                             ; 8E36 C7                       .
        lda     $E1                             ; 8E37 A5 E1                    ..
        .byte   $E3                             ; 8E39 E3                       .
        .byte   $E7                             ; 8E3A E7                       .
        lda     $C9                             ; 8E3B A5 C9                    ..
        dex                                     ; 8E3D CA                       .
        brk                                     ; 8E3E 00                       .
        .byte   $C7                             ; 8E3F C7                       .
        and     (L0000,x)                       ; 8E40 21 00                    !.
        .byte   $23                             ; 8E42 23                       #
        bit     $34                             ; 8E43 24 34                    $4
        plp                                     ; 8E45 28                       (
        rol     a                               ; 8E46 2A                       *
        .byte   $4B                             ; 8E47 4B                       K
        eor     (L0000,x)                       ; 8E48 41 00                    A.
        .byte   $43                             ; 8E4A 43                       C
        eor     #$00                            ; 8E4B 49 00                    I.
        brk                                     ; 8E4D 00                       .
        brk                                     ; 8E4E 00                       .
        and     ($43,x)                         ; 8E4F 21 43                    !C
        .byte   $43                             ; 8E51 43                       C
        .byte   $43                             ; 8E52 43                       C
        brk                                     ; 8E53 00                       .
        brk                                     ; 8E54 00                       .
        brk                                     ; 8E55 00                       .
        brk                                     ; 8E56 00                       .
        eor     ($36,x)                         ; 8E57 41 36                    A6
        brk                                     ; 8E59 00                       .
        .byte   $43                             ; 8E5A 43                       C
        lsr     $27                             ; 8E5B 46 27                    F'
        .byte   $43                             ; 8E5D 43                       C
        brk                                     ; 8E5E 00                       .
        .byte   $5B                             ; 8E5F 5B                       [
        brk                                     ; 8E60 00                       .
        brk                                     ; 8E61 00                       .
        and     $61                             ; 8E62 25 61                    %a
        adc     ($01,x)                         ; 8E64 61 01                    a.
        .byte   $77                             ; 8E66 77                       w
        brk                                     ; 8E67 00                       .
        eor     $55,x                           ; 8E68 55 55                    UU
        and     $61,x                           ; 8E6A 35 61                    5a
        adc     ($C3,x)                         ; 8E6C 61 C3                    a.
        .byte   $77                             ; 8E6E 77                       w
        brk                                     ; 8E6F 00                       .
        adc     $75,x                           ; 8E70 75 75                    uu
        brk                                     ; 8E72 00                       .
        adc     (L0000,x)                       ; 8E73 61 00                    a.
        .byte   $62                             ; 8E75 62                       b
        brk                                     ; 8E76 00                       .
        brk                                     ; 8E77 00                       .
        brk                                     ; 8E78 00                       .
        brk                                     ; 8E79 00                       .
        brk                                     ; 8E7A 00                       .
        brk                                     ; 8E7B 00                       .
        brk                                     ; 8E7C 00                       .
        .byte   $62                             ; 8E7D 62                       b
        brk                                     ; 8E7E 00                       .
        brk                                     ; 8E7F 00                       .
        sbc     #$EA                            ; 8E80 E9 EA                    ..
        cpx     $E8EA                           ; 8E82 EC EA E8                 ...
        sta     ($89,x)                         ; 8E85 81 89                    ..
        .byte   $8B                             ; 8E87 8B                       .
        nop                                     ; 8E88 EA                       .
        inc     a:$C5                           ; 8E89 EE C5 00                 ...
        brk                                     ; 8E8C 00                       .
        .byte   $BB                             ; 8E8D BB                       .
L8E8E:  .byte   $99                             ; 8E8E 99                       .
L8E8F:  .byte   $9B                             ; 8E8F 9B                       .
        sta     ($87,x)                         ; 8E90 81 87                    ..
        sta     L0000,x                         ; 8E92 95 00                    ..
        brk                                     ; 8E94 00                       .
        sta     ($99,x)                         ; 8E95 81 99                    ..
        .byte   $9B                             ; 8E97 9B                       .
        brk                                     ; 8E98 00                       .
        brk                                     ; 8E99 00                       .
        lda     L0000,x                         ; 8E9A B5 00                    ..
        brk                                     ; 8E9C 00                       .
        .byte   $BF                             ; 8E9D BF                       .
        .byte   $6B                             ; 8E9E 6B                       k
        adc     $3C4F                           ; 8E9F 6D 4F 3C                 mO<
        .byte   $3C                             ; 8EA2 3C                       <
        brk                                     ; 8EA3 00                       .
        brk                                     ; 8EA4 00                       .
        brk                                     ; 8EA5 00                       .
        brk                                     ; 8EA6 00                       .
        brk                                     ; 8EA7 00                       .
        and     $3E3E                           ; 8EA8 2D 3E 3E                 ->>
        rol     a:L0000,x                       ; 8EAB 3E 00 00                 >..
        brk                                     ; 8EAE 00                       .
        brk                                     ; 8EAF 00                       .
        eor     a:L0000,x                       ; 8EB0 5D 00 00                 ]..
        brk                                     ; 8EB3 00                       .
        sta     L8F8E                           ; 8EB4 8D 8E 8F                 ...
        brk                                     ; 8EB7 00                       .
        .byte   $EF                             ; 8EB8 EF                       .
        .byte   $EF                             ; 8EB9 EF                       .
        brk                                     ; 8EBA 00                       .
        sty     $9D                             ; 8EBB 84 9D                    ..
        ora     ($9F,x)                         ; 8EBD 01 9F                    ..
        brk                                     ; 8EBF 00                       .
        brk                                     ; 8EC0 00                       .
        eor     a:L0000,x                       ; 8EC1 5D 00 00                 ]..
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
L8ED9:  brk                                     ; 8ED9 00                       .
        brk                                     ; 8EDA 00                       .
        brk                                     ; 8EDB 00                       .
        brk                                     ; 8EDC 00                       .
        brk                                     ; 8EDD 00                       .
        brk                                     ; 8EDE 00                       .
        brk                                     ; 8EDF 00                       .
        brk                                     ; 8EE0 00                       .
        brk                                     ; 8EE1 00                       .
L8EE2:  brk                                     ; 8EE2 00                       .
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
        ora     ($02,x)                         ; 8F01 01 02                    ..
        asl     $16,x                           ; 8F03 16 16                    ..
        clc                                     ; 8F05 18                       .
        .byte   $1A                             ; 8F06 1A                       .
        brk                                     ; 8F07 00                       .
L8F08:  .byte   $02                             ; 8F08 02                       .
        .byte   $12                             ; 8F09 12                       .
        brk                                     ; 8F0A 00                       .
        .byte   $14                             ; 8F0B 14                       .
        brk                                     ; 8F0C 00                       .
        .byte   $1C                             ; 8F0D 1C                       .
        asl     a:L0000,x                       ; 8F0E 1E 00 00                 ...
        brk                                     ; 8F11 00                       .
        .byte   $93                             ; 8F12 93                       .
        brk                                     ; 8F13 00                       .
        brk                                     ; 8F14 00                       .
        brk                                     ; 8F15 00                       .
        cpx     #$F4                            ; 8F16 E0 F4                    ..
        .byte   $DB                             ; 8F18 DB                       .
        cmp     $B6B3,x                         ; 8F19 DD B3 B6                 ...
        lda     ($A3),y                         ; 8F1C B1 A3                    ..
        ora     ($01,x)                         ; 8F1E 01 01                    ..
        bcc     L8F33                           ; 8F20 90 11                    ..
        ora     ($B3),y                         ; 8F22 11 B3                    ..
        bcs     L8ED9                           ; 8F24 B0 B3                    ..
        .byte   $B3                             ; 8F26 B3                       .
        bcs     L8ED9                           ; 8F27 B0 B0                    ..
        .byte   $B2                             ; 8F29 B2                       .
        .byte   $B3                             ; 8F2A B3                       .
        .byte   $11                             ; 8F2B 11                       .
L8F2C:  .byte   $B0,$B0                    ; 8F2C B0 B0   (branch out of range for ca65: target has no local label)
        .byte   $B3                             ; 8F2E B3                       .
        bcs     L8F08                           ; 8F2F B0 D7                    ..
        .byte   $D2                             ; 8F31 D2                       .
        .byte   $D6                             ; 8F32 D6                       .
L8F33:  sta     $F0,x                           ; 8F33 95 F0                    ..
        .byte   $F2                             ; 8F35 F2                       .
        inc     $95,x                           ; 8F36 F6 95                    ..
        beq     L8F2C                           ; 8F38 F0 F2                    ..
        inc     $B5,x                           ; 8F3A F6 B5                    ..
        cld                                     ; 8F3C D8                       .
        .byte   $DA                             ; 8F3D DA                       .
        brk                                     ; 8F3E 00                       .
        beq     L8F71                           ; 8F3F F0 30                    .0
        brk                                     ; 8F41 00                       .
        .byte   $32                             ; 8F42 32                       2
        ora     ($34,x)                         ; 8F43 01 34                    .4
L8F45:  brk                                     ; 8F45 00                       .
        and     $403B,y                         ; 8F46 39 3B 40                 9;@
        brk                                     ; 8F49 00                       .
        .byte   $32                             ; 8F4A 32                       2
        .byte   $32                             ; 8F4B 32                       2
        brk                                     ; 8F4C 00                       .
        brk                                     ; 8F4D 00                       .
        brk                                     ; 8F4E 00                       .
        cli                                     ; 8F4F 58                       X
        .byte   $32                             ; 8F50 32                       2
        .byte   $27                             ; 8F51 27                       '
        .byte   $37                             ; 8F52 37                       7
        .byte   $32                             ; 8F53 32                       2
        brk                                     ; 8F54 00                       .
        rol     L0000,x                         ; 8F55 36 00                    6.
        pla                                     ; 8F57 68                       h
        .byte   $32                             ; 8F58 32                       2
        brk                                     ; 8F59 00                       .
        rol     $32,x                           ; 8F5A 36 32                    62
        .byte   $32                             ; 8F5C 32                       2
        .byte   $32                             ; 8F5D 32                       2
        .byte   $32                             ; 8F5E 32                       2
        rti                                     ; 8F5F 40                       @

; ----------------------------------------------------------------------------
        .byte   $44                             ; 8F60 44                       D
        eor     L0000                           ; 8F61 45 00                    E.
        bvc     L8FD5                           ; 8F63 50 70                    Pp
        ror     $01                             ; 8F65 66 01                    f.
        brk                                     ; 8F67 00                       .
        .byte   $64                             ; 8F68 64                       d
        adc     L0000                           ; 8F69 65 00                    e.
        brk                                     ; 8F6B 00                       .
        brk                                     ; 8F6C 00                       .
        brk                                     ; 8F6D 00                       .
        .byte   $63                             ; 8F6E 63                       c
        brk                                     ; 8F6F 00                       .
        brk                                     ; 8F70 00                       .
L8F71:  brk                                     ; 8F71 00                       .
        brk                                     ; 8F72 00                       .
        brk                                     ; 8F73 00                       .
        bvs     L8F76                           ; 8F74 70 00                    p.
L8F76:  .byte   $73                             ; 8F76 73                       s
        brk                                     ; 8F77 00                       .
        eor     $52,y                           ; 8F78 59 52 00                 YR.
        .byte   $63                             ; 8F7B 63                       c
        bvc     L8F7E                           ; 8F7C 50 00                    P.
L8F7E:  .byte   $63                             ; 8F7E 63                       c
        brk                                     ; 8F7F 00                       .
        sed                                     ; 8F80 F8                       .
        .byte   $FA                             ; 8F81 FA                       .
        .byte   $FB                             ; 8F82 FB                       .
        sbc     $B8FE,x                         ; 8F83 FD FE B8                 ...
        tya                                     ; 8F86 98                       .
        ldy     $FAF9                           ; 8F87 AC F9 FA                 ...
        beq     L8F8C                           ; 8F8A F0 00                    ..
L8F8C:  brk                                     ; 8F8C 00                       .
        .byte   $B3                             ; 8F8D B3                       .
L8F8E:  tya                                     ; 8F8E 98                       .
        txs                                     ; 8F8F 9A                       .
        bcs     L8F45                           ; 8F90 B0 B3                    ..
        .byte   $DA                             ; 8F92 DA                       .
        brk                                     ; 8F93 00                       .
        brk                                     ; 8F94 00                       .
        ldy     $AAA8,x                         ; 8F95 BC A8 AA                 ...
        brk                                     ; 8F98 00                       .
        brk                                     ; 8F99 00                       .
        beq     L8F9C                           ; 8F9A F0 00                    ..
L8F9C:  brk                                     ; 8F9C 00                       .
        .byte   $B2                             ; 8F9D B2                       .
        .byte   $7A                             ; 8F9E 7A                       z
        .byte   $7C                             ; 8F9F 7C                       |
        lsr     $4D5E,x                         ; 8FA0 5E 5E 4D                 ^^M
        lsr     $2F4D,x                         ; 8FA3 5E 4D 2F                 ^M/
        lsr     $2C5E,x                         ; 8FA6 5E 5E 2C                 ^^,
        lsr     $3F2F,x                         ; 8FA9 5E 2F 3F                 ^/?
        brk                                     ; 8FAC 00                       .
        brk                                     ; 8FAD 00                       .
        brk                                     ; 8FAE 00                       .
        brk                                     ; 8FAF 00                       .
        .byte   $5C                             ; 8FB0 5C                       \
        lsr     a:L0000,x                       ; 8FB1 5E 00 00                 ^..
        lsr     $0101,x                         ; 8FB4 5E 01 01                 ^..
        brk                                     ; 8FB7 00                       .
        .byte   $DF                             ; 8FB8 DF                       .
        lsr     L9300,x                         ; 8FB9 5E 00 93                 ^..
        lsr     $0101,x                         ; 8FBC 5E 01 01                 ^..
        brk                                     ; 8FBF 00                       .
        clv                                     ; 8FC0 B8                       .
        tsx                                     ; 8FC1 BA                       .
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
L8FD5:  brk                                     ; 8FD5 00                       .
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
        brk                                     ; 9000 00                       .
        ora     ($03,x)                         ; 9001 01 03                    ..
        .byte   $17                             ; 9003 17                       .
        .byte   $17                             ; 9004 17                       .
        ora     $1B,y                           ; 9005 19 1B 00                 ...
        .byte   $03                             ; 9008 03                       .
        .byte   $13                             ; 9009 13                       .
        brk                                     ; 900A 00                       .
        ora     L0000,x                         ; 900B 15 00                    ..
        ora     a:$1F,x                         ; 900D 1D 1F 00                 ...
        brk                                     ; 9010 00                       .
        brk                                     ; 9011 00                       .
        sty     L0000,x                         ; 9012 94 00                    ..
        brk                                     ; 9014 00                       .
        brk                                     ; 9015 00                       .
        .byte   $F3                             ; 9016 F3                       .
        sbc     $DC,x                           ; 9017 F5 DC                    ..
        .byte   $DB                             ; 9019 DB                       .
        .byte   $B3                             ; 901A B3                       .
        .byte   $B7                             ; 901B B7                       .
        .byte   $B3                             ; 901C B3                       .
        ldy     $01,x                           ; 901D B4 01                    ..
        ora     ($11,x)                         ; 901F 01 11                    ..
        ora     ($97),y                         ; 9021 11 97                    ..
        sta     $B3,x                           ; 9023 95 B3                    ..
        .byte   $B3                             ; 9025 B3                       .
        ldy     $B4,x                           ; 9026 B4 B4                    ..
        .byte   $B3                             ; 9028 B3                       .
        .byte   $B3                             ; 9029 B3                       .
        ldy     $B5,x                           ; 902A B4 B5                    ..
        sta     $B3,x                           ; 902C 95 B3                    ..
        sta     $B4                             ; 902E 85 B4                    ..
        cmp     ($D3),y                         ; 9030 D1 D3                    ..
        .byte   $E7                             ; 9032 E7                       .
        sta     $F1,x                           ; 9033 95 F1                    ..
        .byte   $F2                             ; 9035 F2                       .
        .byte   $F7                             ; 9036 F7                       .
        sta     $F1,x                           ; 9037 95 F1                    ..
        .byte   $F2                             ; 9039 F2                       .
        .byte   $F7                             ; 903A F7                       .
        lda     $D9,x                           ; 903B B5 D9                    ..
        .byte   $DA                             ; 903D DA                       .
        brk                                     ; 903E 00                       .
        .byte   $F7                             ; 903F F7                       .
        and     (L0000),y                       ; 9040 31 00                    1.
        .byte   $33                             ; 9042 33                       3
        ora     ($34,x)                         ; 9043 01 34                    .4
        sec                                     ; 9045 38                       8
        .byte   $3A                             ; 9046 3A                       :
        brk                                     ; 9047 00                       .
        eor     (L0000,x)                       ; 9048 41 00                    A.
        .byte   $33                             ; 904A 33                       3
        .byte   $33                             ; 904B 33                       3
        brk                                     ; 904C 00                       .
        brk                                     ; 904D 00                       .
        brk                                     ; 904E 00                       .
        and     ($26),y                         ; 904F 31 26                    1&
        .byte   $27                             ; 9051 27                       '
        .byte   $33                             ; 9052 33                       3
        rol     L0000,x                         ; 9053 36 00                    6.
        .byte   $33                             ; 9055 33                       3
        brk                                     ; 9056 00                       .
        eor     ($36,x)                         ; 9057 41 36                    A6
        brk                                     ; 9059 00                       .
        .byte   $33                             ; 905A 33                       3
        .byte   $33                             ; 905B 33                       3
        .byte   $33                             ; 905C 33                       3
        .byte   $33                             ; 905D 33                       3
        .byte   $33                             ; 905E 33                       3
        eor     ($45,x)                         ; 905F 41 45                    AE
        eor     $35                             ; 9061 45 35                    E5
        eor     ($71),y                         ; 9063 51 71                    Qq
        ora     ($67,x)                         ; 9065 01 67                    .g
        brk                                     ; 9067 00                       .
        adc     $65                             ; 9068 65 65                    ee
        and     $61,x                           ; 906A 35 61                    5a
        adc     ($62),y                         ; 906C 71 62                    qb
        brk                                     ; 906E 00                       .
        brk                                     ; 906F 00                       .
        brk                                     ; 9070 00                       .
        brk                                     ; 9071 00                       .
        adc     ($60,x)                         ; 9072 61 60                    a`
        adc     ($72),y                         ; 9074 71 72                    qr
        brk                                     ; 9076 00                       .
        brk                                     ; 9077 00                       .
        eor     $6257,y                         ; 9078 59 57 62                 YWb
        brk                                     ; 907B 00                       .
        eor     ($62),y                         ; 907C 51 62                    Qb
        brk                                     ; 907E 00                       .
        brk                                     ; 907F 00                       .
        sbc     $FCFA,y                         ; 9080 F9 FA FC                 ...
        .byte   $FA                             ; 9083 FA                       .
        sed                                     ; 9084 F8                       .
        lda     L9B99,y                         ; 9085 B9 99 9B                 ...
        .byte   $FA                             ; 9088 FA                       .
        inc     a:$85,x                         ; 9089 FE 85 00                 ...
        brk                                     ; 908C 00                       .
        .byte   $B3                             ; 908D B3                       .
        sty     $B39B                           ; 908E 8C 9B B3                 ...
        ldy     $A5,x                           ; 9091 B4 A5                    ..
        brk                                     ; 9093 00                       .
        brk                                     ; 9094 00                       .
        lda     $ABA9,x                         ; 9095 BD A9 AB                 ...
        brk                                     ; 9098 00                       .
        brk                                     ; 9099 00                       .
        cmp     L0000,x                         ; 909A D5 00                    ..
        brk                                     ; 909C 00                       .
        .byte   $B3                             ; 909D B3                       .
        .byte   $7B                             ; 909E 7B                       {
        adc     $4C5F,x                         ; 909F 7D 5F 4C                 }_L
        jmp     L4C4C                           ; 90A2 4C 4C 4C                 LLL

; ----------------------------------------------------------------------------
        .byte   $2F                             ; 90A5 2F                       /
        .byte   $5F                             ; 90A6 5F                       _
        brk                                     ; 90A7 00                       .
        and     $2F2F                           ; 90A8 2D 2F 2F                 -//
        .byte   $3F                             ; 90AB 3F                       ?
        brk                                     ; 90AC 00                       .
        brk                                     ; 90AD 00                       .
        brk                                     ; 90AE 00                       .
        brk                                     ; 90AF 00                       .
        eor     a:L0000,x                       ; 90B0 5D 00 00                 ]..
        brk                                     ; 90B3 00                       .
        sta     L9F01,x                         ; 90B4 9D 01 9F                 ...
        brk                                     ; 90B7 00                       .
        .byte   $FF                             ; 90B8 FF                       .
        .byte   $FF                             ; 90B9 FF                       .
        brk                                     ; 90BA 00                       .
        sty     $9D,x                           ; 90BB 94 9D                    ..
        ora     ($9F,x)                         ; 90BD 01 9F                    ..
        brk                                     ; 90BF 00                       .
        lda     $BB,y                           ; 90C0 B9 BB 00                 ...
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
        bpl     L9124                           ; 9101 10 21                    .!
        sbc     ($F1),y                         ; 9103 F1 F1                    ..
        bvs     L9177                           ; 9105 70 70                    pp
        bpl     L914A                           ; 9107 10 41                    .A
        ora     (L0000,x)                       ; 9109 01 00                    ..
        sbc     (L0000),y                       ; 910B F1 00                    ..
        bvc     L915F                           ; 910D 50 50                    PP
        brk                                     ; 910F 00                       .
        brk                                     ; 9110 00                       .
        brk                                     ; 9111 00                       .
        bpl     L9114                           ; 9112 10 00                    ..
L9114:  brk                                     ; 9114 00                       .
        brk                                     ; 9115 00                       .
        brk                                     ; 9116 00                       .
        brk                                     ; 9117 00                       .
        bpl     L912A                           ; 9118 10 10                    ..
        bpl     L912C                           ; 911A 10 10                    ..
        bpl     L912E                           ; 911C 10 10                    ..
        bpl     L9130                           ; 911E 10 10                    ..
        bpl     L9132                           ; 9120 10 10                    ..
        bpl     L9124                           ; 9122 10 00                    ..
L9124:  bpl     L9136                           ; 9124 10 10                    ..
        bpl     L9128                           ; 9126 10 00                    ..
L9128:  bpl     L913A                           ; 9128 10 10                    ..
L912A:  bpl     L912C                           ; 912A 10 00                    ..
L912C:  brk                                     ; 912C 00                       .
        brk                                     ; 912D 00                       .
L912E:  brk                                     ; 912E 00                       .
        .byte   $10                             ; 912F 10                       .
L9130:  ora     ($11),y                         ; 9130 11 11                    ..
L9132:  ora     ($11),y                         ; 9132 11 11                    ..
        ora     ($11),y                         ; 9134 11 11                    ..
L9136:  ora     ($11),y                         ; 9136 11 11                    ..
        ora     ($11),y                         ; 9138 11 11                    ..
L913A:  ora     ($11),y                         ; 913A 11 11                    ..
        ora     ($11),y                         ; 913C 11 11                    ..
        bpl     L9151                           ; 913E 10 11                    ..
        .byte   $02                             ; 9140 02                       .
        brk                                     ; 9141 00                       .
        .byte   $02                             ; 9142 02                       .
        .byte   $02                             ; 9143 02                       .
        .byte   $02                             ; 9144 02                       .
        brk                                     ; 9145 00                       .
        brk                                     ; 9146 00                       .
        brk                                     ; 9147 00                       .
        .byte   $02                             ; 9148 02                       .
        brk                                     ; 9149 00                       .
L914A:  .byte   $02                             ; 914A 02                       .
        .byte   $02                             ; 914B 02                       .
        brk                                     ; 914C 00                       .
        brk                                     ; 914D 00                       .
        brk                                     ; 914E 00                       .
        brk                                     ; 914F 00                       .
        .byte   $02                             ; 9150 02                       .
L9151:  .byte   $02                             ; 9151 02                       .
        .byte   $02                             ; 9152 02                       .
        .byte   $02                             ; 9153 02                       .
        brk                                     ; 9154 00                       .
        .byte   $02                             ; 9155 02                       .
        brk                                     ; 9156 00                       .
        brk                                     ; 9157 00                       .
        .byte   $02                             ; 9158 02                       .
        brk                                     ; 9159 00                       .
        .byte   $02                             ; 915A 02                       .
        .byte   $02                             ; 915B 02                       .
        .byte   $02                             ; 915C 02                       .
        .byte   $02                             ; 915D 02                       .
        .byte   $02                             ; 915E 02                       .
L915F:  .byte   $02                             ; 915F 02                       .
        .byte   $03                             ; 9160 03                       .
        .byte   $03                             ; 9161 03                       .
        .byte   $02                             ; 9162 02                       .
        .byte   $03                             ; 9163 03                       .
        .byte   $03                             ; 9164 03                       .
        .byte   $03                             ; 9165 03                       .
        .byte   $03                             ; 9166 03                       .
        brk                                     ; 9167 00                       .
        .byte   $03                             ; 9168 03                       .
        .byte   $03                             ; 9169 03                       .
        .byte   $02                             ; 916A 02                       .
        .byte   $03                             ; 916B 03                       .
        .byte   $03                             ; 916C 03                       .
        .byte   $03                             ; 916D 03                       .
        .byte   $03                             ; 916E 03                       .
        brk                                     ; 916F 00                       .
        .byte   $03                             ; 9170 03                       .
        .byte   $03                             ; 9171 03                       .
        .byte   $03                             ; 9172 03                       .
        .byte   $03                             ; 9173 03                       .
        .byte   $03                             ; 9174 03                       .
        .byte   $03                             ; 9175 03                       .
        .byte   $03                             ; 9176 03                       .
L9177:  brk                                     ; 9177 00                       .
        .byte   $02                             ; 9178 02                       .
        ora     ($03,x)                         ; 9179 01 03                    ..
        .byte   $03                             ; 917B 03                       .
        .byte   $03                             ; 917C 03                       .
        .byte   $03                             ; 917D 03                       .
        .byte   $03                             ; 917E 03                       .
        brk                                     ; 917F 00                       .
        ora     ($11),y                         ; 9180 11 11                    ..
        ora     ($11),y                         ; 9182 11 11                    ..
        ora     ($10),y                         ; 9184 11 10                    ..
        ora     ($11),y                         ; 9186 11 11                    ..
        ora     ($11),y                         ; 9188 11 11                    ..
        ora     (L0000),y                       ; 918A 11 00                    ..
        brk                                     ; 918C 00                       .
        bpl     L91A0                           ; 918D 10 11                    ..
        ora     ($60),y                         ; 918F 11 60                    .`
        rts                                     ; 9191 60                       `

; ----------------------------------------------------------------------------
        ora     (L0000),y                       ; 9192 11 00                    ..
        brk                                     ; 9194 00                       .
        bpl     L91A8                           ; 9195 10 11                    ..
        ora     (L0000),y                       ; 9197 11 00                    ..
        brk                                     ; 9199 00                       .
        ora     (L0000),y                       ; 919A 11 00                    ..
        brk                                     ; 919C 00                       .
        bpl     L91B0                           ; 919D 10 11                    ..
        .byte   $11                             ; 919F 11                       .
L91A0:  .byte   $03                             ; 91A0 03                       .
        .byte   $03                             ; 91A1 03                       .
        .byte   $03                             ; 91A2 03                       .
        .byte   $03                             ; 91A3 03                       .
        .byte   $03                             ; 91A4 03                       .
        .byte   $03                             ; 91A5 03                       .
        .byte   $03                             ; 91A6 03                       .
        .byte   $03                             ; 91A7 03                       .
L91A8:  .byte   $03                             ; 91A8 03                       .
        .byte   $03                             ; 91A9 03                       .
        .byte   $03                             ; 91AA 03                       .
        .byte   $03                             ; 91AB 03                       .
        brk                                     ; 91AC 00                       .
        brk                                     ; 91AD 00                       .
        brk                                     ; 91AE 00                       .
        brk                                     ; 91AF 00                       .
L91B0:  .byte   $03                             ; 91B0 03                       .
        .byte   $03                             ; 91B1 03                       .
        brk                                     ; 91B2 00                       .
        brk                                     ; 91B3 00                       .
        .byte   $03                             ; 91B4 03                       .
        .byte   $03                             ; 91B5 03                       .
        .byte   $03                             ; 91B6 03                       .
        brk                                     ; 91B7 00                       .
        .byte   $03                             ; 91B8 03                       .
        .byte   $03                             ; 91B9 03                       .
        brk                                     ; 91BA 00                       .
        .byte   $02                             ; 91BB 02                       .
        .byte   $03                             ; 91BC 03                       .
        .byte   $03                             ; 91BD 03                       .
        .byte   $03                             ; 91BE 03                       .
        brk                                     ; 91BF 00                       .
        .byte   $03                             ; 91C0 03                       .
        .byte   $03                             ; 91C1 03                       .
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
        rol     $24                             ; 9200 26 24                    &$
        bit     $26                             ; 9202 24 26                    $&
        rol     $24                             ; 9204 26 24                    &$
        asl     $17,x                           ; 9206 16 17                    ..
        rol     $2F                             ; 9208 26 2F                    &/
        bit     $26                             ; 920A 24 26                    $&
        .byte   $02                             ; 920C 02                       .
        bit     $02                             ; 920D 24 02                    $.
        .byte   $2F                             ; 920F 2F                       /
        rol     $02                             ; 9210 26 02                    &.
        .byte   $2F                             ; 9212 2F                       /
        .byte   $02                             ; 9213 02                       .
        .byte   $2F                             ; 9214 2F                       /
        bit     $24                             ; 9215 24 24                    $$
        rol     $86                             ; 9217 26 86                    &.
        .byte   $87                             ; 9219 87                       .
        stx     $97,y                           ; 921A 96 97                    ..
        rol     $24                             ; 921C 26 24                    &$
        lsr     $265F,x                         ; 921E 5E 5F 26                 ^_&
        bit     $5E                             ; 9221 24 5E                    $^
        lsr     $2402,x                         ; 9223 5E 02 24                 ^.$
        .byte   $02                             ; 9226 02                       .
        .byte   $5F                             ; 9227 5F                       _
        rol     $02                             ; 9228 26 02                    &.
        lsr     L8602,x                         ; 922A 5E 02 86                 ^..
        .byte   $87                             ; 922D 87                       .
        stx     $428F                           ; 922E 8E 8F 42                 ..B
        rti                                     ; 9231 40                       @

; ----------------------------------------------------------------------------
        bit     $26                             ; 9232 24 26                    $&
        .byte   $42                             ; 9234 42                       B
        .byte   $42                             ; 9235 42                       B
        php                                     ; 9236 08                       .
        bit     $02                             ; 9237 24 02                    $.
        rti                                     ; 9239 40                       @

; ----------------------------------------------------------------------------
        and     $25                             ; 923A 25 25                    %%
        .byte   $42                             ; 923C 42                       B
        .byte   $02                             ; 923D 02                       .
        and     $25                             ; 923E 25 25                    %%
        .byte   $42                             ; 9240 42                       B
        rti                                     ; 9241 40                       @

; ----------------------------------------------------------------------------
        rol     $08                             ; 9242 26 08                    &.
        .byte   $42                             ; 9244 42                       B
        .byte   $42                             ; 9245 42                       B
        bit     $26                             ; 9246 24 26                    $&
        stx     L8E8F                           ; 9248 8E 8F 8E                 ...
        .byte   $8F                             ; 924B 8F                       .
        lsr     $425F,x                         ; 924C 5E 5F 42                 ^_B
        rti                                     ; 924F 40                       @

; ----------------------------------------------------------------------------
        .byte   $02                             ; 9250 02                       .
L9251:  lsr     $4202,x                         ; 9251 5E 02 42                 ^.B
        lsr     $4224,x                         ; 9254 5E 24 42                 ^$B
        .byte   $2F                             ; 9257 2F                       /
        rol     $5E                             ; 9258 26 5E                    &^
        .byte   $2F                             ; 925A 2F                       /
        .byte   $42                             ; 925B 42                       B
        lsr     $4202,x                         ; 925C 5E 02 42                 ^.B
        .byte   $02                             ; 925F 02                       .
        lsr     $425E,x                         ; 9260 5E 5E 42                 ^^B
        .byte   $42                             ; 9263 42                       B
        stx     L968F                           ; 9264 8E 8F 96                 ...
        .byte   $97                             ; 9267 97                       .
        .byte   $42                             ; 9268 42                       B
        .byte   $42                             ; 9269 42                       B
        lsr     a                               ; 926A 4A                       J
        lsr     a                               ; 926B 4A                       J
        bit     $25                             ; 926C 24 25                    $%
        lsr     $255F,x                         ; 926E 5E 5F 25                 ^_%
        rol     $5E                             ; 9271 26 5E                    &^
        lsr     $4042,x                         ; 9273 5E 42 40                 ^B@
        lsr     a                               ; 9276 4A                       J
        pha                                     ; 9277 48                       H
        stx     $87                             ; 9278 86 87                    ..
        .byte   $9E                             ; 927A 9E                       .
        .byte   $9F                             ; 927B 9F                       .
        .byte   $42                             ; 927C 42                       B
        .byte   $42                             ; 927D 42                       B
        .byte   $42                             ; 927E 42                       B
        .byte   $42                             ; 927F 42                       B
        .byte   $42                             ; 9280 42                       B
        rti                                     ; 9281 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; 9282 42                       B
        rti                                     ; 9283 40                       @

; ----------------------------------------------------------------------------
        jsr     L2821                           ; 9284 20 21 28                  !(
        and     #$21                            ; 9287 29 21                    )!
        .byte   $22                             ; 9289 22                       "
        and     #$2A                            ; 928A 29 2A                    )*
        rol     $2F                             ; 928C 26 2F                    &/
        asl     $17,x                           ; 928E 16 17                    ..
        and     ($22,x)                         ; 9290 21 22                    !"
        and     #$1B                            ; 9292 29 1B                    ).
        .byte   $2F                             ; 9294 2F                       /
        .byte   $2F                             ; 9295 2F                       /
        bit     $26                             ; 9296 24 26                    $&
        .byte   $02                             ; 9298 02                       .
        .byte   $5F                             ; 9299 5F                       _
        .byte   $02                             ; 929A 02                       .
        rti                                     ; 929B 40                       @

; ----------------------------------------------------------------------------
        lsr     $4A53,x                         ; 929C 5E 53 4A                 ^SJ
        cli                                     ; 929F 58                       X
        brk                                     ; 92A0 00                       .
        bit     L0000                           ; 92A1 24 00                    $.
        .byte   $2F                             ; 92A3 2F                       /
        rol     L0000                           ; 92A4 26 00                    &.
        .byte   $2F                             ; 92A6 2F                       /
        brk                                     ; 92A7 00                       .
        brk                                     ; 92A8 00                       .
        brk                                     ; 92A9 00                       .
        brk                                     ; 92AA 00                       .
        brk                                     ; 92AB 00                       .
        .byte   $02                             ; 92AC 02                       .
        rti                                     ; 92AD 40                       @

; ----------------------------------------------------------------------------
        .byte   $02                             ; 92AE 02                       .
        .byte   $2F                             ; 92AF 2F                       /
        lsr     a                               ; 92B0 4A                       J
        cli                                     ; 92B1 58                       X
        bit     $26                             ; 92B2 24 26                    $&
        brk                                     ; 92B4 00                       .
        bit     $24                             ; 92B5 24 24                    $$
        rol     $26                             ; 92B7 26 26                    &&
        brk                                     ; 92B9 00                       .
        bit     $26                             ; 92BA 24 26                    $&
        brk                                     ; 92BC 00                       .
        brk                                     ; 92BD 00                       .
        bcc     L9251                           ; 92BE 90 91                    ..
        ora     $241C,x                         ; 92C0 1D 1C 24                 ..$
        rol     $26                             ; 92C3 26 26                    &&
        bit     $5E                             ; 92C5 24 5E                    $^
        .byte   $53                             ; 92C7 53                       S
        rol     $24                             ; 92C8 26 24                    &$
        brk                                     ; 92CA 00                       .
        .byte   $2F                             ; 92CB 2F                       /
        rol     $1C                             ; 92CC 26 1C                    &.
        .byte   $2F                             ; 92CE 2F                       /
        brk                                     ; 92CF 00                       .
        sta     ($90),y                         ; 92D0 91 90                    ..
        brk                                     ; 92D2 00                       .
        brk                                     ; 92D3 00                       .
        .byte   $02                             ; 92D4 02                       .
        rti                                     ; 92D5 40                       @

; ----------------------------------------------------------------------------
        .byte   $02                             ; 92D6 02                       .
        pha                                     ; 92D7 48                       H
        lsr     a                               ; 92D8 4A                       J
        cli                                     ; 92D9 58                       X
        lsr     a                               ; 92DA 4A                       J
        cli                                     ; 92DB 58                       X
        adc     ($24,x)                         ; 92DC 61 24                    a$
        adc     #$2F                            ; 92DE 69 2F                    i/
        rol     $60                             ; 92E0 26 60                    &`
        .byte   $2F                             ; 92E2 2F                       /
        pla                                     ; 92E3 68                       h
        adc     ($60,x)                         ; 92E4 61 60                    a`
        adc     #$68                            ; 92E6 69 68                    ih
        php                                     ; 92E8 08                       .
        bit     $02                             ; 92E9 24 02                    $.
        .byte   $2F                             ; 92EB 2F                       /
        rol     $08                             ; 92EC 26 08                    &.
        .byte   $2F                             ; 92EE 2F                       /
        .byte   $02                             ; 92EF 02                       .
        rol     $24                             ; 92F0 26 24                    &$
        lsr     $422F,x                         ; 92F2 5E 2F 42                 ^/B
        lsr     $4242,x                         ; 92F5 5E 42 42                 ^BB
        lsr     a                               ; 92F8 4A                       J
        pha                                     ; 92F9 48                       H
        lsr     a                               ; 92FA 4A                       J
        pha                                     ; 92FB 48                       H
        lsr     a                               ; 92FC 4A                       J
        lsr     a                               ; 92FD 4A                       J
        lsr     a                               ; 92FE 4A                       J
        lsr     a                               ; 92FF 4A                       J
L9300:  lsr     a                               ; 9300 4A                       J
        bvc     L934D                           ; 9301 50 4A                    PJ
        cli                                     ; 9303 58                       X
        bmi     L9338                           ; 9304 30 32                    02
        sec                                     ; 9306 38                       8
        .byte   $3A                             ; 9307 3A                       :
        rol     $48                             ; 9308 26 48                    &H
        .byte   $2F                             ; 930A 2F                       /
        pha                                     ; 930B 48                       H
        .byte   $42                             ; 930C 42                       B
        rti                                     ; 930D 40                       @

; ----------------------------------------------------------------------------
        php                                     ; 930E 08                       .
        .byte   $2F                             ; 930F 2F                       /
        eor     ($51),y                         ; 9310 51 51                    QQ
        brk                                     ; 9312 00                       .
        ror     a                               ; 9313 6A                       j
        eor     ($51),y                         ; 9314 51 51                    QQ
        brk                                     ; 9316 00                       .
        brk                                     ; 9317 00                       .
        .byte   $52                             ; 9318 52                       R
        pha                                     ; 9319 48                       H
        .byte   $5A                             ; 931A 5A                       Z
        pha                                     ; 931B 48                       H
        brk                                     ; 931C 00                       .
        .byte   $62                             ; 931D 62                       b
        brk                                     ; 931E 00                       .
        .byte   $62                             ; 931F 62                       b
        .byte   $5A                             ; 9320 5A                       Z
        pha                                     ; 9321 48                       H
        .byte   $5A                             ; 9322 5A                       Z
        pha                                     ; 9323 48                       H
        .byte   $2F                             ; 9324 2F                       /
        rti                                     ; 9325 40                       @

; ----------------------------------------------------------------------------
        bit     $26                             ; 9326 24 26                    $&
        .byte   $42                             ; 9328 42                       B
        .byte   $2F                             ; 9329 2F                       /
        bit     $26                             ; 932A 24 26                    $&
        .byte   $33                             ; 932C 33                       3
        .byte   $33                             ; 932D 33                       3
        .byte   $3B                             ; 932E 3B                       ;
        .byte   $3B                             ; 932F 3B                       ;
        .byte   $33                             ; 9330 33                       3
        bit     $3B                             ; 9331 24 3B                    $;
        .byte   $2F                             ; 9333 2F                       /
        rol     $24                             ; 9334 26 24                    &$
        .byte   $3C                             ; 9336 3C                       <
        .byte   $3D                             ; 9337 3D                       =
L9338:  brk                                     ; 9338 00                       .
        bit     L0000                           ; 9339 24 00                    $.
        brk                                     ; 933B 00                       .
        rol     $24                             ; 933C 26 24                    &$
        brk                                     ; 933E 00                       .
        brk                                     ; 933F 00                       .
        brk                                     ; 9340 00                       .
        brk                                     ; 9341 00                       .
        brk                                     ; 9342 00                       .
        eor     $5355,y                         ; 9343 59 55 53                 YUS
        .byte   $5A                             ; 9346 5A                       Z
        cli                                     ; 9347 58                       X
        brk                                     ; 9348 00                       .
        brk                                     ; 9349 00                       .
        brk                                     ; 934A 00                       .
        ror     a                               ; 934B 6A                       j
        brk                                     ; 934C 00                       .
L934D:  eor     $5900,y                         ; 934D 59 00 59                 Y.Y
        .byte   $5A                             ; 9350 5A                       Z
        cli                                     ; 9351 58                       X
        .byte   $5A                             ; 9352 5A                       Z
        cli                                     ; 9353 58                       X
        adc     ($60,x)                         ; 9354 61 60                    a`
        bit     $26                             ; 9356 24 26                    $&
        .byte   $42                             ; 9358 42                       B
        .byte   $42                             ; 9359 42                       B
        eor     ($51),y                         ; 935A 51 51                    QQ
        .byte   $42                             ; 935C 42                       B
        rti                                     ; 935D 40                       @

; ----------------------------------------------------------------------------
        .byte   $52                             ; 935E 52                       R
        pha                                     ; 935F 48                       H
        .byte   $42                             ; 9360 42                       B
        .byte   $42                             ; 9361 42                       B
        bvc     L93B5                           ; 9362 50 51                    PQ
        cli                                     ; 9364 58                       X
        brk                                     ; 9365 00                       .
        cli                                     ; 9366 58                       X
        brk                                     ; 9367 00                       .
        cli                                     ; 9368 58                       X
        adc     ($58,x)                         ; 9369 61 58                    aX
        adc     #$2F                            ; 936B 69 2F                    i/
        bit     $1C                             ; 936D 24 1C                    $.
        ora     $7071,x                         ; 936F 1D 71 70                 .qp
        .byte   $5C                             ; 9372 5C                       \
        .byte   $5C                             ; 9373 5C                       \
        eor     ($51),y                         ; 9374 51 51                    QQ
        .byte   $63                             ; 9376 63                       c
        .byte   $63                             ; 9377 63                       c
        rol     $24                             ; 9378 26 24                    &$
        eor     $5F,x                           ; 937A 55 5F                    U_
        rol     $2F                             ; 937C 26 2F                    &/
        .byte   $53                             ; 937E 53                       S
        brk                                     ; 937F 00                       .
        .byte   $5A                             ; 9380 5A                       Z
        pha                                     ; 9381 48                       H
        eor     $5848,x                         ; 9382 5D 48 58                 ]HX
        adc     ($5B),y                         ; 9385 71 5B                    q[
        .byte   $5C                             ; 9387 5C                       \
        adc     ($70),y                         ; 9388 71 70                    qp
        .byte   $34                             ; 938A 34                       4
        rol     $0D,x                           ; 938B 36 0D                    6.
        asl     $5F5E                           ; 938D 0E 5E 5F                 .^_
        .byte   $42                             ; 9390 42                       B
        .byte   $42                             ; 9391 42                       B
        ora     $5E0E                           ; 9392 0D 0E 5E                 ..^
        lsr     $5151,x                         ; 9395 5E 51 51                 ^QQ
        and     ($32),y                         ; 9398 31 32                    12
        and     $613A,y                         ; 939A 39 3A 61                 9:a
        rts                                     ; 939D 60                       `

; ----------------------------------------------------------------------------
        php                                     ; 939E 08                       .
        pla                                     ; 939F 68                       h
        .byte   $02                             ; 93A0 02                       .
        bvs     L93A5                           ; 93A1 70 02                    p.
        brk                                     ; 93A3 00                       .
        .byte   $71                             ; 93A4 71                       q
L93A5:  bvs     L93A7                           ; 93A5 70 00                    p.
L93A7:  brk                                     ; 93A7 00                       .
        cli                                     ; 93A8 58                       X
        adc     ($58),y                         ; 93A9 71 58                    qX
        brk                                     ; 93AB 00                       .
        .byte   $02                             ; 93AC 02                       .
        brk                                     ; 93AD 00                       .
        .byte   $02                             ; 93AE 02                       .
        .byte   $5C                             ; 93AF 5C                       \
        brk                                     ; 93B0 00                       .
        brk                                     ; 93B1 00                       .
        .byte   $5C                             ; 93B2 5C                       \
        .byte   $5C                             ; 93B3 5C                       \
        .byte   $5B                             ; 93B4 5B                       [
L93B5:  .byte   $5C                             ; 93B5 5C                       \
        lsr     a                               ; 93B6 4A                       J
        lsr     a                               ; 93B7 4A                       J
        .byte   $5C                             ; 93B8 5C                       \
        .byte   $5C                             ; 93B9 5C                       \
        lsr     a                               ; 93BA 4A                       J
        lsr     a                               ; 93BB 4A                       J
        .byte   $02                             ; 93BC 02                       .
        .byte   $42                             ; 93BD 42                       B
        .byte   $02                             ; 93BE 02                       .
        .byte   $42                             ; 93BF 42                       B
        .byte   $42                             ; 93C0 42                       B
        .byte   $03                             ; 93C1 03                       .
        .byte   $42                             ; 93C2 42                       B
        .byte   $4B                             ; 93C3 4B                       K
        .byte   $42                             ; 93C4 42                       B
        .byte   $03                             ; 93C5 03                       .
        .byte   $03                             ; 93C6 03                       .
        .byte   $4B                             ; 93C7 4B                       K
        .byte   $42                             ; 93C8 42                       B
        .byte   $03                             ; 93C9 03                       .
        .byte   $03                             ; 93CA 03                       .
        .byte   $5F                             ; 93CB 5F                       _
        .byte   $4B                             ; 93CC 4B                       K
        .byte   $42                             ; 93CD 42                       B
        .byte   $42                             ; 93CE 42                       B
        .byte   $42                             ; 93CF 42                       B
        .byte   $4B                             ; 93D0 4B                       K
        rti                                     ; 93D1 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; 93D2 42                       B
        rti                                     ; 93D3 40                       @

; ----------------------------------------------------------------------------
        .byte   $04                             ; 93D4 04                       .
        .byte   $04                             ; 93D5 04                       .
        .byte   $4B                             ; 93D6 4B                       K
        .byte   $4B                             ; 93D7 4B                       K
        and     $26                             ; 93D8 25 26                    %&
        .byte   $63                             ; 93DA 63                       c
        .byte   $63                             ; 93DB 63                       c
        eor     ($51),y                         ; 93DC 51 51                    QQ
        adc     $66                             ; 93DE 65 66                    ef
        bvc     L9433                           ; 93E0 50 51                    PQ
        cli                                     ; 93E2 58                       X
        .byte   $63                             ; 93E3 63                       c
        .byte   $6B                             ; 93E4 6B                       k
        .byte   $6B                             ; 93E5 6B                       k
        .byte   $64                             ; 93E6 64                       d
        .byte   $64                             ; 93E7 64                       d
        adc     $756E                           ; 93E8 6D 6E 75                 mnu
        ora     $6B                             ; 93EB 05 6B                    .k
        .byte   $6B                             ; 93ED 6B                       k
        asl     $64                             ; 93EE 06 64                    .d
        cli                                     ; 93F0 58                       X
        .byte   $6B                             ; 93F1 6B                       k
        cli                                     ; 93F2 58                       X
        .byte   $64                             ; 93F3 64                       d
        adc     $757B,x                         ; 93F4 7D 7B 75                 }{u
        ror     $72,x                           ; 93F7 76 72                    vr
        .byte   $6B                             ; 93F9 6B                       k
        jmp     (L5864)                         ; 93FA 6C 64 58                 ldX

; ----------------------------------------------------------------------------
        .byte   $6B                             ; 93FD 6B                       k
        ora     $06                             ; 93FE 05 06                    ..
        .byte   $6B                             ; 9400 6B                       k
        .byte   $6B                             ; 9401 6B                       k
        .byte   $73                             ; 9402 73                       s
        .byte   $73                             ; 9403 73                       s
        .byte   $7D                             ; 9404 7D                       }
        .byte   $7E                             ; 9405 7E                       ~
L9406:  adc     $76,x                           ; 9406 75 76                    uv
        .byte   $53                             ; 9408 53                       S
        .byte   $72                             ; 9409 72                       r
        cli                                     ; 940A 58                       X
        .byte   $73                             ; 940B 73                       s
        .byte   $04                             ; 940C 04                       .
        .byte   $04                             ; 940D 04                       .
        .byte   $4B                             ; 940E 4B                       K
        .byte   $5F                             ; 940F 5F                       _
        .byte   $6B                             ; 9410 6B                       k
        .byte   $6B                             ; 9411 6B                       k
        .byte   $6B                             ; 9412 6B                       k
        .byte   $6B                             ; 9413 6B                       k
        .byte   $6B                             ; 9414 6B                       k
        .byte   $6B                             ; 9415 6B                       k
        ora     $06                             ; 9416 05 06                    ..
        .byte   $72                             ; 9418 72                       r
        .byte   $72                             ; 9419 72                       r
        .byte   $64                             ; 941A 64                       d
        .byte   $64                             ; 941B 64                       d
        .byte   $5A                             ; 941C 5A                       Z
        pha                                     ; 941D 48                       H
L941E:  .byte   $5A                             ; 941E 5A                       Z
        ora     $6B58                           ; 941F 0D 58 6B                 .Xk
        asl     $5A64                           ; 9422 0E 64 5A                 .dZ
        .byte   $5F                             ; 9425 5F                       _
        .byte   $5A                             ; 9426 5A                       Z
        pha                                     ; 9427 48                       H
        .byte   $53                             ; 9428 53                       S
        .byte   $6B                             ; 9429 6B                       k
        cli                                     ; 942A 58                       X
        .byte   $64                             ; 942B 64                       d
        .byte   $72                             ; 942C 72                       r
        .byte   $72                             ; 942D 72                       r
        .byte   $73                             ; 942E 73                       s
        .byte   $73                             ; 942F 73                       s
        cli                                     ; 9430 58                       X
        .byte   $6B                             ; 9431 6B                       k
        cli                                     ; 9432 58                       X
L9433:  .byte   $73                             ; 9433 73                       s
        sei                                     ; 9434 78                       x
        sei                                     ; 9435 78                       x
        .byte   $63                             ; 9436 63                       c
        .byte   $63                             ; 9437 63                       c
        sei                                     ; 9438 78                       x
        sei                                     ; 9439 78                       x
        adc     $66                             ; 943A 65 66                    ef
        adc     $756E                           ; 943C 6D 6E 75                 mnu
        ror     $0D,x                           ; 943F 76 0D                    v.
        asl     $7272                           ; 9441 0E 72 72                 .rr
        .byte   $6B                             ; 9444 6B                       k
        .byte   $6B                             ; 9445 6B                       k
        jmp     (L0564)                         ; 9446 6C 64 05                 ld.

; ----------------------------------------------------------------------------
        asl     $72                             ; 9449 06 72                    .r
        .byte   $72                             ; 944B 72                       r
        .byte   $32                             ; 944C 32                       2
        tax                                     ; 944D AA                       .
        .byte   $3A                             ; 944E 3A                       :
        tax                                     ; 944F AA                       .
        tax                                     ; 9450 AA                       .
        tax                                     ; 9451 AA                       .
        tax                                     ; 9452 AA                       .
        tax                                     ; 9453 AA                       .
        .byte   $02                             ; 9454 02                       .
        brk                                     ; 9455 00                       .
        .byte   $02                             ; 9456 02                       .
        tax                                     ; 9457 AA                       .
        brk                                     ; 9458 00                       .
        brk                                     ; 9459 00                       .
        tax                                     ; 945A AA                       .
        tax                                     ; 945B AA                       .
        brk                                     ; 945C 00                       .
        brk                                     ; 945D 00                       .
        cpy     #$C1                            ; 945E C0 C1                    ..
        brk                                     ; 9460 00                       .
        bit     $AA                             ; 9461 24 AA                    $.
        .byte   $2F                             ; 9463 2F                       /
        .byte   $02                             ; 9464 02                       .
        tax                                     ; 9465 AA                       .
        .byte   $02                             ; 9466 02                       .
        tax                                     ; 9467 AA                       .
        cpy     #$C1                            ; 9468 C0 C1                    ..
        cpy     #$C1                            ; 946A C0 C1                    ..
        tax                                     ; 946C AA                       .
        bit     $AA                             ; 946D 24 AA                    $.
        .byte   $2F                             ; 946F 2F                       /
        and     ($31),y                         ; 9470 31 31                    11
        and     $3039,y                         ; 9472 39 39 30                 990
        and     ($38),y                         ; 9475 31 38                    18
        and     $33,y                           ; 9477 39 33 00                 93.
        .byte   $3B                             ; 947A 3B                       ;
        tax                                     ; 947B AA                       .
        ldx     $A7                             ; 947C A6 A7                    ..
        ldy     #$A1                            ; 947E A0 A1                    ..
        brk                                     ; 9480 00                       .
        brk                                     ; 9481 00                       .
        ldx     #$A2                            ; 9482 A2 A2                    ..
        ldy     #$A1                            ; 9484 A0 A1                    ..
        ldy     #$A1                            ; 9486 A0 A1                    ..
        .byte   $34                             ; 9488 34                       4
        and     L0000,x                         ; 9489 35 00                    5.
        brk                                     ; 948B 00                       .
        rol     $A2,x                           ; 948C 36 A2                    6.
        brk                                     ; 948E 00                       .
        ldx     #$A2                            ; 948F A2 A2                    ..
        ldx     #$A2                            ; 9491 A2 A2                    ..
        .byte   $A2                             ; 9493 A2                       .
L9494:  rol     $AA,x                           ; 9494 36 AA                    6.
        brk                                     ; 9496 00                       .
        tax                                     ; 9497 AA                       .
        rol     $AA,x                           ; 9498 36 AA                    6.
        and     $36,x                           ; 949A 35 36                    56
        tax                                     ; 949C AA                       .
        tax                                     ; 949D AA                       .
        .byte   $34                             ; 949E 34                       4
        rol     $AA,x                           ; 949F 36 AA                    6.
        tax                                     ; 94A1 AA                       .
        php                                     ; 94A2 08                       .
        tax                                     ; 94A3 AA                       .
        dey                                     ; 94A4 88                       .
        .byte   $82                             ; 94A5 82                       .
        dey                                     ; 94A6 88                       .
        .byte   $82                             ; 94A7 82                       .
        .byte   $83                             ; 94A8 83                       .
        sty     $83                             ; 94A9 84 83                    ..
        sty     $37                             ; 94AB 84 37                    .7
        .byte   $37                             ; 94AD 37                       7
        .byte   $3B                             ; 94AE 3B                       ;
        .byte   $3B                             ; 94AF 3B                       ;
        ldx     $A7                             ; 94B0 A6 A7                    ..
        ldy     #$A9                            ; 94B2 A0 A9                    ..
        ldy     #$A9                            ; 94B4 A0 A9                    ..
        ldy     #$A9                            ; 94B6 A0 A9                    ..
        ldy     #$34                            ; 94B8 A0 34                    .4
        ldy     #$A3                            ; 94BA A0 A3                    ..
        and     $35,x                           ; 94BC 35 35                    55
        ldy     $A4                             ; 94BE A4 A4                    ..
        and     $35,x                           ; 94C0 35 35                    55
        ldx     $A3                             ; 94C2 A6 A3                    ..
        and     $36,x                           ; 94C4 35 36                    56
        ldy     $A4                             ; 94C6 A4 A4                    ..
        .byte   $34                             ; 94C8 34                       4
        and     $A5,x                           ; 94C9 35 A5                    5.
        lda     $AA                             ; 94CB A5 AA                    ..
        tax                                     ; 94CD AA                       .
        .byte   $AB                             ; 94CE AB                       .
        .byte   $AB                             ; 94CF AB                       .
        .byte   $37                             ; 94D0 37                       7
        and     $2F37,x                         ; 94D1 3D 37 2F                 =7/
        .byte   $3C                             ; 94D4 3C                       <
        and     $2624,x                         ; 94D5 3D 24 26                 =$&
        .byte   $37                             ; 94D8 37                       7
        and     $2637,x                         ; 94D9 3D 37 26                 =7&
        .byte   $37                             ; 94DC 37                       7
        bit     $3B                             ; 94DD 24 3B                    $;
        .byte   $2F                             ; 94DF 2F                       /
        .byte   $34                             ; 94E0 34                       4
        and     $A4,x                           ; 94E1 35 A4                    5.
        ldy     $03                             ; 94E3 A4 03                    ..
        .byte   $03                             ; 94E5 03                       .
        ldy     $A4                             ; 94E6 A4 A4                    ..
        .byte   $83                             ; 94E8 83                       .
        .byte   $89                             ; 94E9 89                       .
        .byte   $83                             ; 94EA 83                       .
        .byte   $89                             ; 94EB 89                       .
        .byte   $33                             ; 94EC 33                       3
        .byte   $33                             ; 94ED 33                       3
        .byte   $37                             ; 94EE 37                       7
        .byte   $37                             ; 94EF 37                       7
        .byte   $83                             ; 94F0 83                       .
        .byte   $82                             ; 94F1 82                       .
        .byte   $83                             ; 94F2 83                       .
        .byte   $82                             ; 94F3 82                       .
        .byte   $03                             ; 94F4 03                       .
        .byte   $03                             ; 94F5 03                       .
        .byte   $34                             ; 94F6 34                       4
        rol     $37,x                           ; 94F7 36 37                    67
        bit     $37                             ; 94F9 24 37                    $7
        .byte   $2F                             ; 94FB 2F                       /
        rol     $2F                             ; 94FC 26 2F                    &/
        txa                                     ; 94FE 8A                       .
        rol     $92,x                           ; 94FF 36 92                    6.
        .byte   $3C                             ; 9501 3C                       <
L9502:  txs                                     ; 9502 9A                       .
        rol     $2F,x                           ; 9503 36 2F                    6/
        bit     $8A                             ; 9505 24 8A                    $.
        rol     $3D,x                           ; 9507 36 3D                    6=
        .byte   $2F                             ; 9509 2F                       /
        bit     $26                             ; 950A 24 26                    $&
        rol     $24                             ; 950C 26 24                    &$
        txa                                     ; 950E 8A                       .
        rol     $2F,x                           ; 950F 36 2F                    6/
        .byte   $3C                             ; 9511 3C                       <
        bit     $26                             ; 9512 24 26                    $&
        .byte   $37                             ; 9514 37                       7
        bmi     L954E                           ; 9515 30 37                    07
        sec                                     ; 9517 38                       8
        jsr     L2895                           ; 9518 20 95 28                  .(
        sta     $2437,x                         ; 951B 9D 37 24                 .7$
        txa                                     ; 951E 8A                       .
        rol     $95,x                           ; 951F 36 95                    6.
        .byte   $22                             ; 9521 22                       "
        sta     $2F2A,x                         ; 9522 9D 2A 2F                 .*/
        .byte   $2F                             ; 9525 2F                       /
        ldx     $A7                             ; 9526 A6 A7                    ..
        and     $2424,x                         ; 9528 3D 24 24                 =$$
        rol     $26                             ; 952B 26 26                    &&
        brk                                     ; 952D 00                       .
        .byte   $2F                             ; 952E 2F                       /
        ldx     #$26                            ; 952F A2 26                    .&
        ldx     #$2F                            ; 9531 A2 2F                    ./
        ldx     #$00                            ; 9533 A2 00                    ..
        ldx     #$A2                            ; 9535 A2 A2                    ..
        ldx     #$A6                            ; 9537 A2 A6                    ..
        .byte   $A7                             ; 9539 A7                       .
        ldy     #$B1                            ; 953A A0 B1                    ..
        brk                                     ; 953C 00                       .
        .byte   $02                             ; 953D 02                       .
        brk                                     ; 953E 00                       .
        .byte   $02                             ; 953F 02                       .
        ldy     #$B1                            ; 9540 A0 B1                    ..
        ldy     #$B1                            ; 9542 A0 B1                    ..
        ldy     #$B1                            ; 9544 A0 B1                    ..
        bit     $26                             ; 9546 24 26                    $&
        brk                                     ; 9548 00                       .
        brk                                     ; 9549 00                       .
        .byte   $2F                             ; 954A 2F                       /
        brk                                     ; 954B 00                       .
        tax                                     ; 954C AA                       .
        brk                                     ; 954D 00                       .
L954E:  tax                                     ; 954E AA                       .
        tax                                     ; 954F AA                       .
        brk                                     ; 9550 00                       .
        brk                                     ; 9551 00                       .
        bit     $26                             ; 9552 24 26                    $&
        ldy     #$B1                            ; 9554 A0 B1                    ..
        .byte   $34                             ; 9556 34                       4
        rol     $2F,x                           ; 9557 36 2F                    6/
        bit     $34                             ; 9559 24 34                    $4
        rol     $26,x                           ; 955B 36 26                    6&
        .byte   $2F                             ; 955D 2F                       /
        .byte   $34                             ; 955E 34                       4
        and     $3C,x                           ; 955F 35 3C                    5<
        and     $3635,x                         ; 9561 3D 35 36                 =56
        .byte   $02                             ; 9564 02                       .
        tax                                     ; 9565 AA                       .
        bit     $26                             ; 9566 24 26                    $&
        .byte   $2F                             ; 9568 2F                       /
        bit     $16                             ; 9569 24 16                    $.
        .byte   $17                             ; 956B 17                       .
        rol     $AA                             ; 956C 26 AA                    &.
        bit     $26                             ; 956E 24 26                    $&
        brk                                     ; 9570 00                       .
        brk                                     ; 9571 00                       .
        .byte   $2F                             ; 9572 2F                       /
        php                                     ; 9573 08                       .
        and     ($21,x)                         ; 9574 21 21                    !!
        clc                                     ; 9576 18                       .
        ora     $B8B8,y                         ; 9577 19 B8 B8                 ...
        brk                                     ; 957A 00                       .
        brk                                     ; 957B 00                       .
        ldy     #$B9                            ; 957C A0 B9                    ..
        ldy     #$B1                            ; 957E A0 B1                    ..
        .byte   $BB                             ; 9580 BB                       .
        .byte   $BB                             ; 9581 BB                       .
        .byte   $BB                             ; 9582 BB                       .
        .byte   $BB                             ; 9583 BB                       .
        ldy     #$B9                            ; 9584 A0 B9                    ..
        ldy     #$B4                            ; 9586 A0 B4                    ..
        clv                                     ; 9588 B8                       .
        clv                                     ; 9589 B8                       .
        lda     $B6,x                           ; 958A B5 B6                    ..
        ldy     #$BC                            ; 958C A0 BC                    ..
        ldy     #$BC                            ; 958E A0 BC                    ..
        lda     $24BE,x                         ; 9590 BD BE 24                 ..$
        rol     $BD                             ; 9593 26 BD                    &.
        ldx     $BEBD,y                         ; 9595 BE BD BE                 ...
        .byte   $33                             ; 9598 33                       3
        bit     $37                             ; 9599 24 37                    $7
        .byte   $2F                             ; 959B 2F                       /
        .byte   $BB                             ; 959C BB                       .
        .byte   $BB                             ; 959D BB                       .
        php                                     ; 959E 08                       .
        .byte   $2F                             ; 959F 2F                       /
        php                                     ; 95A0 08                       .
        .byte   $34                             ; 95A1 34                       4
        .byte   $02                             ; 95A2 02                       .
        brk                                     ; 95A3 00                       .
        rol     $B9,x                           ; 95A4 36 B9                    6.
        ldx     $B1                             ; 95A6 A6 B1                    ..
        .byte   $02                             ; 95A8 02                       .
        .byte   $BB                             ; 95A9 BB                       .
        .byte   $02                             ; 95AA 02                       .
        .byte   $BB                             ; 95AB BB                       .
        .byte   $02                             ; 95AC 02                       .
        clv                                     ; 95AD B8                       .
        .byte   $02                             ; 95AE 02                       .
        brk                                     ; 95AF 00                       .
        dey                                     ; 95B0 88                       .
        .byte   $82                             ; 95B1 82                       .
        bit     $26                             ; 95B2 24 26                    $&
        .byte   $83                             ; 95B4 83                       .
        .byte   $89                             ; 95B5 89                       .
        bit     $26                             ; 95B6 24 26                    $&
        .byte   $33                             ; 95B8 33                       3
        bmi     L95F2                           ; 95B9 30 37                    07
        sec                                     ; 95BB 38                       8
        .byte   $2F                             ; 95BC 2F                       /
        bit     L0000                           ; 95BD 24 00                    $.
        brk                                     ; 95BF 00                       .
        rol     $24                             ; 95C0 26 24                    &$
        ldx     $A7                             ; 95C2 A6 A7                    ..
        rol     $24                             ; 95C4 26 24                    &$
        dey                                     ; 95C6 88                       .
        sta     ($26,x)                         ; 95C7 81 26                    .&
        clv                                     ; 95C9 B8                       .
        .byte   $89                             ; 95CA 89                       .
        brk                                     ; 95CB 00                       .
        .byte   $2F                             ; 95CC 2F                       /
        bit     L0000                           ; 95CD 24 00                    $.
        ora     #$33                            ; 95CF 09 33                    .3
        bit     $37                             ; 95D1 24 37                    $7
        dey                                     ; 95D3 88                       .
        tax                                     ; 95D4 AA                       .
        ora     #$AA                            ; 95D5 09 AA                    ..
        ora     #$BB                            ; 95D7 09 BB                    ..
        .byte   $BB                             ; 95D9 BB                       .
        bit     $26                             ; 95DA 24 26                    $&
        rol     $24                             ; 95DC 26 24                    &$
        .byte   $34                             ; 95DE 34                       4
        rol     $26,x                           ; 95DF 36 26                    6&
        bit     L0000                           ; 95E1 24 00                    $.
        ora     #$20                            ; 95E3 09 20                    . 
        and     ($18,x)                         ; 95E5 21 18                    !.
        ora     $26,y                           ; 95E7 19 26 00                 .&.
        .byte   $2F                             ; 95EA 2F                       /
        tax                                     ; 95EB AA                       .
        rol     $AA                             ; 95EC 26 AA                    &.
        .byte   $2F                             ; 95EE 2F                       /
        tax                                     ; 95EF AA                       .
        rol     $AA                             ; 95F0 26 AA                    &.
L95F2:  brk                                     ; 95F2 00                       .
        tax                                     ; 95F3 AA                       .
        asl     a:$1F,x                         ; 95F4 1E 1F 00                 ...
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
        ora     L0000                           ; 9605 05 00                    ..
        brk                                     ; 9607 00                       .
        asl     $07                             ; 9608 06 07                    ..
        php                                     ; 960A 08                       .
        ora     #$0A                            ; 960B 09 0A                    ..
        .byte   $07                             ; 960D 07                       .
        php                                     ; 960E 08                       .
        asl     $0B                             ; 960F 06 0B                    ..
        .byte   $0C                             ; 9611 0C                       .
        ora     $0F0E                           ; 9612 0D 0E 0F                 ...
        bpl     L9628                           ; 9615 10 11                    ..
        .byte   $0B                             ; 9617 0B                       .
        .byte   $12                             ; 9618 12                       .
L9619:  .byte   $13                             ; 9619 13                       .
        .byte   $14                             ; 961A 14                       .
        ora     $16,x                           ; 961B 15 16                    ..
        .byte   $17                             ; 961D 17                       .
        clc                                     ; 961E 18                       .
        .byte   $12                             ; 961F 12                       .
        ora     $1A0C,y                         ; 9620 19 0C 1A                 ...
        .byte   $1B                             ; 9623 1B                       .
        .byte   $1C                             ; 9624 1C                       .
        ora     $1911,x                         ; 9625 1D 11 19                 ...
L9628:  asl     $1F13,x                         ; 9628 1E 13 1F                 ...
        jsr     L201F                           ; 962B 20 1F 20                  . 
        clc                                     ; 962E 18                       .
        asl     $2221,x                         ; 962F 1E 21 22                 .!"
        ora     $23                             ; 9632 05 23                    .#
        and     ($22,x)                         ; 9634 21 22                    !"
        ora     $23                             ; 9636 05 23                    .#
        .byte   $02                             ; 9638 02                       .
        and     ($22,x)                         ; 9639 21 22                    !"
        ora     L0000                           ; 963B 05 00                    ..
        brk                                     ; 963D 00                       .
        brk                                     ; 963E 00                       .
        brk                                     ; 963F 00                       .
        .byte   $22                             ; 9640 22                       "
        .byte   $03                             ; 9641 03                       .
        ora     ($02,x)                         ; 9642 01 02                    ..
        and     ($24,x)                         ; 9644 21 24                    !$
        and     ($22,x)                         ; 9646 21 22                    !"
        .byte   $02                             ; 9648 02                       .
        .byte   $03                             ; 9649 03                       .
        brk                                     ; 964A 00                       .
        brk                                     ; 964B 00                       .
        .byte   $02                             ; 964C 02                       .
        and     ($22,x)                         ; 964D 21 22                    !"
        and     $02                             ; 964F 25 02                    %.
        rol     $27                             ; 9651 26 27                    &'
        plp                                     ; 9653 28                       (
        and     #$2A                            ; 9654 29 2A                    )*
        plp                                     ; 9656 28                       (
        brk                                     ; 9657 00                       .
        .byte   $22                             ; 9658 22                       "
        .byte   $2B                             ; 9659 2B                       +
        bit     $2E2D                           ; 965A 2C 2D 2E                 ,-.
        .byte   $2F                             ; 965D 2F                       /
        and     $0230                           ; 965E 2D 30 02                 -0.
        ora     #$31                            ; 9661 09 31                    .1
        .byte   $32                             ; 9663 32                       2
        .byte   $33                             ; 9664 33                       3
        .byte   $34                             ; 9665 34                       4
L9666:  .byte   $32                             ; 9666 32                       2
        ora     ($24,x)                         ; 9667 01 24                    .$
        and     $36,x                           ; 9669 35 36                    56
        .byte   $37                             ; 966B 37                       7
        sec                                     ; 966C 38                       8
        and     $37,y                           ; 966D 39 37 00                 97.
        and     ($22,x)                         ; 9670 21 22                    !"
        and     $3A                             ; 9672 25 3A                    %:
        .byte   $3B                             ; 9674 3B                       ;
        and     $21                             ; 9675 25 21                    %!
        .byte   $22                             ; 9677 22                       "
        brk                                     ; 9678 00                       .
        brk                                     ; 9679 00                       .
        .byte   $02                             ; 967A 02                       .
        .byte   $03                             ; 967B 03                       .
        .byte   $04                             ; 967C 04                       .
        ora     L0000                           ; 967D 05 00                    ..
        brk                                     ; 967F 00                       .
        asl     $05                             ; 9680 06 05                    ..
        brk                                     ; 9682 00                       .
        bmi     L9685                           ; 9683 30 00                    0.
L9685:  ora     ($02,x)                         ; 9685 01 02                    ..
        and     ($06,x)                         ; 9687 21 06                    !.
        .byte   $13                             ; 9689 13                       .
        clc                                     ; 968A 18                       .
        ora     $30,x                           ; 968B 15 30                    .0
        php                                     ; 968D 08                       .
        .byte   $07                             ; 968E 07                       .
L968F:  .byte   $3C                             ; 968F 3C                       <
        .byte   $0B                             ; 9690 0B                       .
        jsr     L3D1F                           ; 9691 20 1F 3D                  .=
L9694:  clc                                     ; 9694 18                       .
        .byte   $1F                             ; 9695 1F                       .
        jsr     L193D                           ; 9696 20 3D 19                  =.
        rol     $3F3F,x                         ; 9699 3E 3F 3F                 >??
        .byte   $3F                             ; 969C 3F                       ?
        .byte   $3F                             ; 969D 3F                       ?
        rol     $0640,x                         ; 969E 3E 40 06                 >@.
        rol     $3F3F,x                         ; 96A1 3E 3F 3F                 >??
        eor     ($05,x)                         ; 96A4 41 05                    A.
        .byte   $42                             ; 96A6 42                       B
        rol     $1E,x                           ; 96A7 36 1E                    6.
        ora     $1A1A,x                         ; 96A9 1D 1A 1A                 ...
        .byte   $21                             ; 96AC 21                       !
L96AD:  .byte   $22                             ; 96AD 22                       "
        .byte   $42                             ; 96AE 42                       B
        rol     $22,x                           ; 96AF 36 22                    6"
        .byte   $43                             ; 96B1 43                       C
        ora     ($11),y                         ; 96B2 11 11                    ..
        and     $21                             ; 96B4 25 21                    %!
        .byte   $22                             ; 96B6 22                       "
        ora     $02                             ; 96B7 05 02                    ..
        .byte   $03                             ; 96B9 03                       .
        brk                                     ; 96BA 00                       .
        brk                                     ; 96BB 00                       .
        brk                                     ; 96BC 00                       .
        brk                                     ; 96BD 00                       .
        brk                                     ; 96BE 00                       .
        brk                                     ; 96BF 00                       .
        .byte   $22                             ; 96C0 22                       "
        and     ($24,x)                         ; 96C1 21 24                    !$
        and     ($22,x)                         ; 96C3 21 22                    !"
        ora     L0000                           ; 96C5 05 00                    ..
        brk                                     ; 96C7 00                       .
        brk                                     ; 96C8 00                       .
        .byte   $02                             ; 96C9 02                       .
        clc                                     ; 96CA 18                       .
        .byte   $13                             ; 96CB 13                       .
        .byte   $13                             ; 96CC 13                       .
        clc                                     ; 96CD 18                       .
        ora     L0000                           ; 96CE 05 00                    ..
        clc                                     ; 96D0 18                       .
        clc                                     ; 96D1 18                       .
        .byte   $1F                             ; 96D2 1F                       .
        jsr     L1F20                           ; 96D3 20 20 1F                   .
        clc                                     ; 96D6 18                       .
        .byte   $13                             ; 96D7 13                       .
        .byte   $44                             ; 96D8 44                       D
        .byte   $44                             ; 96D9 44                       D
        eor     $46                             ; 96DA 45 46                    EF
        rol     $3F3F,x                         ; 96DC 3E 3F 3F                 >??
        rol     $4747,x                         ; 96DF 3E 47 47                 >GG
        rol     a                               ; 96E2 2A                       *
        pha                                     ; 96E3 48                       H
        rol     $3F3F,x                         ; 96E4 3E 3F 3F                 >??
        rol     $3939,x                         ; 96E7 3E 39 39                 >99
        ora     $42                             ; 96EA 05 42                    .B
        rol     $3F3F,x                         ; 96EC 3E 3F 3F                 >??
        rol     $2123,x                         ; 96EF 3E 23 21                 >#!
        .byte   $22                             ; 96F2 22                       "
        eor     #$0C                            ; 96F3 49 0C                    I.
        ora     ($11),y                         ; 96F5 11 11                    ..
        lsr     a                               ; 96F7 4A                       J
        brk                                     ; 96F8 00                       .
        brk                                     ; 96F9 00                       .
        brk                                     ; 96FA 00                       .
        brk                                     ; 96FB 00                       .
        brk                                     ; 96FC 00                       .
        brk                                     ; 96FD 00                       .
        brk                                     ; 96FE 00                       .
        brk                                     ; 96FF 00                       .
        brk                                     ; 9700 00                       .
        ora     (L0000,x)                       ; 9701 01 00                    ..
        .byte   $02                             ; 9703 02                       .
        .byte   $4B                             ; 9704 4B                       K
        and     $4C                             ; 9705 25 4C                    %L
        ora     (L0000,x)                       ; 9707 01 00                    ..
        brk                                     ; 9709 00                       .
        ora     (L0000,x)                       ; 970A 01 00                    ..
        eor     $2102                           ; 970C 4D 02 21                 M.!
        bit     $27                             ; 970F 24 27                    $'
        lsr     $324F                           ; 9711 4E 4F 32                 NO2
        .byte   $02                             ; 9714 02                       .
        and     ($24,x)                         ; 9715 21 24                    !$
        and     ($36,x)                         ; 9717 21 36                    !6
        rol     a                               ; 9719 2A                       *
        rol     a                               ; 971A 2A                       *
        bvc     L976E                           ; 971B 50 51                    PQ
        .byte   $52                             ; 971D 52                       R
        .byte   $52                             ; 971E 52                       R
        bvc     L9757                           ; 971F 50 36                    P6
        rol     a                               ; 9721 2A                       *
        rol     a                               ; 9722 2A                       *
        .byte   $53                             ; 9723 53                       S
        .byte   $54                             ; 9724 54                       T
        .byte   $47                             ; 9725 47                       G
        .byte   $47                             ; 9726 47                       G
        .byte   $53                             ; 9727 53                       S
        rol     $39,x                           ; 9728 36 39                    69
        eor     $39,x                           ; 972A 55 39                    U9
        .byte   $54                             ; 972C 54                       T
        and     $5539,y                         ; 972D 39 39 55                 99U
        and     ($22,x)                         ; 9730 21 22                    !"
        and     ($24,x)                         ; 9732 21 24                    !$
        and     $21                             ; 9734 25 21                    %!
        .byte   $22                             ; 9736 22                       "
        ora     L0000                           ; 9737 05 00                    ..
        brk                                     ; 9739 00                       .
        brk                                     ; 973A 00                       .
        brk                                     ; 973B 00                       .
        brk                                     ; 973C 00                       .
        brk                                     ; 973D 00                       .
        brk                                     ; 973E 00                       .
        brk                                     ; 973F 00                       .
        brk                                     ; 9740 00                       .
        brk                                     ; 9741 00                       .
        bmi     L9744                           ; 9742 30 00                    0.
L9744:  brk                                     ; 9744 00                       .
        brk                                     ; 9745 00                       .
        brk                                     ; 9746 00                       .
        bmi     L976E                           ; 9747 30 25                    0%
        clc                                     ; 9749 18                       .
        clc                                     ; 974A 18                       .
        clc                                     ; 974B 18                       .
        .byte   $13                             ; 974C 13                       .
        clc                                     ; 974D 18                       .
        clc                                     ; 974E 18                       .
        ora     $24                             ; 974F 05 24                    .$
        lsr     $56,x                           ; 9751 56 56                    VV
        lsr     $57,x                           ; 9753 56 57                    VW
        cli                                     ; 9755 58                       X
        .byte   $56                             ; 9756 56                       V
L9757:  and     ($51,x)                         ; 9757 21 51                    !Q
        .byte   $52                             ; 9759 52                       R
        .byte   $52                             ; 975A 52                       R
        rol     a                               ; 975B 2A                       *
        pha                                     ; 975C 48                       H
        eor     $052A,y                         ; 975D 59 2A 05                 Y*.
        .byte   $54                             ; 9760 54                       T
        .byte   $47                             ; 9761 47                       G
        .byte   $47                             ; 9762 47                       G
        rol     a                               ; 9763 2A                       *
        pha                                     ; 9764 48                       H
        eor     $212A,y                         ; 9765 59 2A 21                 Y*!
        .byte   $54                             ; 9768 54                       T
        and     $3939,y                         ; 9769 39 39 39                 999
        pha                                     ; 976C 48                       H
        .byte   $5A                             ; 976D 5A                       Z
L976E:  and     $025B,y                         ; 976E 39 5B 02                 9[.
        and     ($24,x)                         ; 9771 21 24                    !$
        and     ($24,x)                         ; 9773 21 24                    !$
        and     $5C                             ; 9775 25 5C                    %\
        and     (L0000,x)                       ; 9777 21 00                    !.
        brk                                     ; 9779 00                       .
        brk                                     ; 977A 00                       .
        bmi     L977D                           ; 977B 30 00                    0.
L977D:  .byte   $02                             ; 977D 02                       .
        eor     $2105,x                         ; 977E 5D 05 21                 ].!
        bit     $33                             ; 9781 24 33                    $3
        .byte   $4F                             ; 9783 4F                       O
        lsr     $2A5F,x                         ; 9784 5E 5F 2A                 ^_*
        and     ($22,x)                         ; 9787 21 22                    !"
        and     $3939,y                         ; 9789 39 39 39                 999
        pha                                     ; 978C 48                       H
        .byte   $5A                             ; 978D 5A                       Z
        and     $0221,y                         ; 978E 39 21 02                 9!.
        .byte   $5C                             ; 9791 5C                       \
        .byte   $5C                             ; 9792 5C                       \
        .byte   $5C                             ; 9793 5C                       \
        rts                                     ; 9794 60                       `

; ----------------------------------------------------------------------------
        adc     ($62,x)                         ; 9795 61 62                    ab
        ora     $24                             ; 9797 05 24                    .$
        .byte   $3F                             ; 9799 3F                       ?
        .byte   $3F                             ; 979A 3F                       ?
        .byte   $3F                             ; 979B 3F                       ?
        .byte   $63                             ; 979C 63                       c
        .byte   $1F                             ; 979D 1F                       .
        clc                                     ; 979E 18                       .
        and     ($02,x)                         ; 979F 21 02                    !.
        .byte   $1A                             ; 97A1 1A                       .
        .byte   $64                             ; 97A2 64                       d
        .byte   $1A                             ; 97A3 1A                       .
        ora     $5658,x                         ; 97A4 1D 58 56                 .XV
        and     ($24,x)                         ; 97A7 21 24                    !$
        lsr     $65,x                           ; 97A9 56 65                    Ve
        lsr     $57,x                           ; 97AB 56 57                    VW
        eor     $5B2A,y                         ; 97AD 59 2A 5B                 Y*[
        ror     $67                             ; 97B0 66 67                    fg
        and     $4839,y                         ; 97B2 39 39 48                 99H
        .byte   $5A                             ; 97B5 5A                       Z
        and     $0221,y                         ; 97B6 39 21 02                 9!.
        pla                                     ; 97B9 68                       h
        adc     #$69                            ; 97BA 69 69                    ii
        pha                                     ; 97BC 48                       H
        ror     a                               ; 97BD 6A                       j
        adc     #$5B                            ; 97BE 69 5B                    i[
        bit     $6B                             ; 97C0 24 6B                    $k
        jmp     (L606C)                         ; 97C2 6C 6C 60                 ll`

; ----------------------------------------------------------------------------
        adc     $216E                           ; 97C5 6D 6E 21                 mn!
        bit     $6F                             ; 97C8 24 6F                    $o
        bvs     L983D                           ; 97CA 70 71                    pq
        .byte   $72                             ; 97CC 72                       r
        adc     ($71),y                         ; 97CD 71 71                    qq
        .byte   $5B                             ; 97CF 5B                       [
        .byte   $02                             ; 97D0 02                       .
        .byte   $1F                             ; 97D1 1F                       .
        .byte   $1F                             ; 97D2 1F                       .
        .byte   $73                             ; 97D3 73                       s
        .byte   $74                             ; 97D4 74                       t
        .byte   $73                             ; 97D5 73                       s
        .byte   $73                             ; 97D6 73                       s
        adc     $5B,x                           ; 97D7 75 5B                    u[
        ror     $77,x                           ; 97D9 76 77                    vw
        eor     $7846,x                         ; 97DB 5D 46 78                 ]Fx
        .byte   $77                             ; 97DE 77                       w
        eor     $7924,x                         ; 97DF 5D 24 79                 ]$y
        .byte   $7A                             ; 97E2 7A                       z
        .byte   $7B                             ; 97E3 7B                       {
        pha                                     ; 97E4 48                       H
        .byte   $7C                             ; 97E5 7C                       |
L97E6:  .byte   $7A                             ; 97E6 7A                       z
        .byte   $7B                             ; 97E7 7B                       {
        bit     $79                             ; 97E8 24 79                    $y
        adc     $487E,x                         ; 97EA 7D 7E 48                 }~H
        .byte   $7F                             ; 97ED 7F                       .
        adc     $027E,x                         ; 97EE 7D 7E 02                 }~.
        .byte   $80                             ; 97F1 80                       .
        sta     ($80,x)                         ; 97F2 81 80                    ..
        pha                                     ; 97F4 48                       H
        .byte   $82                             ; 97F5 82                       .
        sta     ($80,x)                         ; 97F6 81 80                    ..
        bit     $2A                             ; 97F8 24 2A                    $*
        sta     ($2A,x)                         ; 97FA 81 2A                    .*
        pha                                     ; 97FC 48                       H
        eor     $2A81,y                         ; 97FD 59 81 2A                 Y.*
        bit     $5B                             ; 9800 24 5B                    $[
        php                                     ; 9802 08                       .
        php                                     ; 9803 08                       .
        php                                     ; 9804 08                       .
        php                                     ; 9805 08                       .
        php                                     ; 9806 08                       .
        php                                     ; 9807 08                       .
        bmi     L980C                           ; 9808 30 02                    0.
        sei                                     ; 980A 78                       x
        .byte   $5D                             ; 980B 5D                       ]
L980C:  eor     $5D5D,x                         ; 980C 5D 5D 5D                 ]]]
        eor     L8375,x                         ; 980F 5D 75 83                 ]u.
        .byte   $7C                             ; 9812 7C                       |
        sty     $84                             ; 9813 84 84                    ..
        sta     $84                             ; 9815 85 84                    ..
        sty     $5D                             ; 9817 84 5D                    .]
        lsr     $7C                             ; 9819 46 7C                    F|
        sta     $79                             ; 981B 85 79                    .y
        stx     $79                             ; 981D 86 79                    .y
        sta     $79                             ; 981F 85 79                    .y
        .byte   $87                             ; 9821 87                       .
        dey                                     ; 9822 88                       .
        stx     $79                             ; 9823 86 79                    .y
        adc     L8679,y                         ; 9825 79 79 86                 yy.
        sta     $89                             ; 9828 85 89                    ..
        txa                                     ; 982A 8A                       .
        adc     $7979,y                         ; 982B 79 79 79                 yyy
        adc     L8B79,y                         ; 982E 79 79 8B                 yy.
        pha                                     ; 9831 48                       H
        sty     L8080                           ; 9832 8C 80 80                 ...
        .byte   $80                             ; 9835 80                       .
        .byte   $80                             ; 9836 80                       .
        .byte   $80                             ; 9837 80                       .
        rol     a                               ; 9838 2A                       *
        pha                                     ; 9839 48                       H
        eor     $2A2A,y                         ; 983A 59 2A 2A                 Y**
L983D:  rol     a                               ; 983D 2A                       *
        rol     a                               ; 983E 2A                       *
        rol     a                               ; 983F 2A                       *
        php                                     ; 9840 08                       .
        php                                     ; 9841 08                       .
        php                                     ; 9842 08                       .
        bmi     L9847                           ; 9843 30 02                    0.
        and     ($24,x)                         ; 9845 21 24                    !$
L9847:  .byte   $03                             ; 9847 03                       .
        eor     $775D,x                         ; 9848 5D 5D 77                 ]]w
        sta     L8D8E                           ; 984B 8D 8E 8D                 ...
        stx     L8403                           ; 984E 8E 03 84                 ...
        sty     $8F                             ; 9851 84 8F                    ..
        sty     $8F                             ; 9853 84 8F                    ..
        sty     $8F                             ; 9855 84 8F                    ..
        .byte   $03                             ; 9857 03                       .
        adc     L8190,y                         ; 9858 79 90 81                 y..
        sta     ($81),y                         ; 985B 91 81                    ..
        sta     ($81),y                         ; 985D 91 81                    ..
        .byte   $03                             ; 985F 03                       .
        adc     L8179,y                         ; 9860 79 79 81                 yy.
        bcc     L97E6                           ; 9863 90 81                    ..
        sta     ($81),y                         ; 9865 91 81                    ..
        plp                                     ; 9867 28                       (
        adc     L8179,y                         ; 9868 79 79 81                 yy.
        sta     ($81),y                         ; 986B 91 81                    ..
        .byte   $92                             ; 986D 92                       .
        sta     ($28,x)                         ; 986E 81 28                    .(
        .byte   $80                             ; 9870 80                       .
        .byte   $80                             ; 9871 80                       .
        sta     ($80,x)                         ; 9872 81 80                    ..
        sta     ($80,x)                         ; 9874 81 80                    ..
        sta     ($28,x)                         ; 9876 81 28                    .(
        rol     a                               ; 9878 2A                       *
        rol     a                               ; 9879 2A                       *
        sta     ($2A,x)                         ; 987A 81 2A                    .*
        sta     ($2A,x)                         ; 987C 81 2A                    .*
        sta     ($28,x)                         ; 987E 81 28                    .(
        .byte   $93                             ; 9880 93                       .
        sty     $95,x                           ; 9881 94 95                    ..
        stx     $97,y                           ; 9883 96 97                    ..
        stx     $97,y                           ; 9885 96 97                    ..
        tya                                     ; 9887 98                       .
        .byte   $93                             ; 9888 93                       .
        sty     $99,x                           ; 9889 94 99                    ..
        sty     $9A,x                           ; 988B 94 9A                    ..
        sty     $9A,x                           ; 988D 94 9A                    ..
        .byte   $9B                             ; 988F 9B                       .
        .byte   $9C                             ; 9890 9C                       .
        .byte   $9C                             ; 9891 9C                       .
        .byte   $9C                             ; 9892 9C                       .
        ror     $9D                             ; 9893 66 9D                    f.
        .byte   $9C                             ; 9895 9C                       .
        ror     $3A                             ; 9896 66 3A                    f:
        .byte   $9E                             ; 9898 9E                       .
        stx     $96,y                           ; 9899 96 96                    ..
        stx     $97,y                           ; 989B 96 97                    ..
        stx     $97,y                           ; 989D 96 97                    ..
        .byte   $03                             ; 989F 03                       .
        .byte   $3B                             ; 98A0 3B                       ;
        sta     $669C,x                         ; 98A1 9D 9C 66                 ..f
        sta     L9C9C,x                         ; 98A4 9D 9C 9C                 ...
        .byte   $9C                             ; 98A7 9C                       .
        .byte   $04                             ; 98A8 04                       .
        stx     $96,y                           ; 98A9 96 96                    ..
        stx     $97,y                           ; 98AB 96 97                    ..
        stx     $97,y                           ; 98AD 96 97                    ..
        tya                                     ; 98AF 98                       .
        .byte   $22                             ; 98B0 22                       "
        and     ($22,x)                         ; 98B1 21 22                    !"
        and     ($24,x)                         ; 98B3 21 24                    !$
        and     ($24,x)                         ; 98B5 21 24                    !$
        .byte   $3A                             ; 98B7 3A                       :
        brk                                     ; 98B8 00                       .
        brk                                     ; 98B9 00                       .
        brk                                     ; 98BA 00                       .
        brk                                     ; 98BB 00                       .
        brk                                     ; 98BC 00                       .
        brk                                     ; 98BD 00                       .
        .byte   $02                             ; 98BE 02                       .
        .byte   $03                             ; 98BF 03                       .
        sta     $2166,x                         ; 98C0 9D 66 21                 .f!
        bit     $05                             ; 98C3 24 05                    $.
        brk                                     ; 98C5 00                       .
        brk                                     ; 98C6 00                       .
        brk                                     ; 98C7 00                       .
        .byte   $9E                             ; 98C8 9E                       .
        stx     $96,y                           ; 98C9 96 96                    ..
        stx     $9F,y                           ; 98CB 96 9F                    ..
        ldy     #$A0                            ; 98CD A0 A0                    ..
        ldy     #$93                            ; 98CF A0 93                    ..
        sty     $94,x                           ; 98D1 94 94                    ..
        sty     $A1,x                           ; 98D3 94 A1                    ..
        ldx     #$A3                            ; 98D5 A2 A3                    ..
L98D7:  ldy     $93                             ; 98D7 A4 93                    ..
        sty     $A2,x                           ; 98D9 94 A2                    ..
        lda     $A1                             ; 98DB A5 A1                    ..
        ldy     $A4                             ; 98DD A4 A4                    ..
        ldy     $A6                             ; 98DF A4 A6                    ..
        .byte   $A7                             ; 98E1 A7                       .
        tay                                     ; 98E2 A8                       .
        sty     $A1,x                           ; 98E3 94 A1                    ..
        ldy     $A4                             ; 98E5 A4 A4                    ..
        ldy     $9E                             ; 98E7 A4 9E                    ..
        stx     $99,y                           ; 98E9 96 99                    ..
        sty     $A1,x                           ; 98EB 94 A1                    ..
        ldy     $A4                             ; 98ED A4 A4                    ..
        ldy     $93                             ; 98EF A4 93                    ..
        sty     $03,x                           ; 98F1 94 03                    ..
        .byte   $02                             ; 98F3 02                       .
        and     ($24,x)                         ; 98F4 21 24                    !$
        lda     #$AA                            ; 98F6 A9 AA                    ..
        ldx     $94                             ; 98F8 A6 94                    ..
        .byte   $03                             ; 98FA 03                       .
        brk                                     ; 98FB 00                       .
        bmi     L98FE                           ; 98FC 30 00                    0.
L98FE:  bmi     L9900                           ; 98FE 30 00                    0.
L9900:  .byte   $02                             ; 9900 02                       .
        .byte   $AB                             ; 9901 AB                       .
        sta     L9D66,x                         ; 9902 9D 66 9D                 .f.
        ror     $9D                             ; 9905 66 9D                    f.
        ror     $AC                             ; 9907 66 AC                    f.
        stx     $96,y                           ; 9909 96 96                    ..
        stx     $96,y                           ; 990B 96 96                    ..
        .byte   $9F                             ; 990D 9F                       .
        .byte   $9F                             ; 990E 9F                       .
        ldy     #$AD                            ; 990F A0 AD                    ..
        sty     $94,x                           ; 9911 94 94                    ..
        sty     $94,x                           ; 9913 94 94                    ..
        lda     ($AE,x)                         ; 9915 A1 AE                    ..
        .byte   $AF                             ; 9917 AF                       .
        lda     L9494                           ; 9918 AD 94 94                 ...
        sty     $94,x                           ; 991B 94 94                    ..
        ldx     $B1B0                           ; 991D AE B0 B1                 ...
        lda     L9494                           ; 9920 AD 94 94                 ...
        sty     $B2,x                           ; 9923 94 B2                    ..
        bcs     L98D7                           ; 9925 B0 B0                    ..
        .byte   $AF                             ; 9927 AF                       .
        lda     L9494                           ; 9928 AD 94 94                 ...
        lda     #$AA                            ; 992B A9 AA                    ..
        sta     $A966,x                         ; 992D 9D 66 A9                 .f.
        sta     $B366,x                         ; 9930 9D 66 B3                 .f.
        and     $B4                             ; 9933 25 B4                    %.
        lda     $B6,x                           ; 9935 B5 B6                    ..
        and     $02                             ; 9937 25 02                    %.
        ldy     $2A,x                           ; 9939 B4 2A                    .*
        .byte   $02                             ; 993B 02                       .
        .byte   $B7                             ; 993C B7                       .
        .byte   $02                             ; 993D 02                       .
        .byte   $B7                             ; 993E B7                       .
        .byte   $02                             ; 993F 02                       .
        sta     L9C9C,x                         ; 9940 9D 9C 9C                 ...
        ror     $9D                             ; 9943 66 9D                    f.
        .byte   $9C                             ; 9945 9C                       .
        .byte   $9C                             ; 9946 9C                       .
        ror     $A0                             ; 9947 66 A0                    f.
        ldy     #$A0                            ; 9949 A0 A0                    ..
        ldy     #$A0                            ; 994B A0 A0                    ..
        ldy     #$A0                            ; 994D A0 A0                    ..
        sta     $B8B1,x                         ; 994F 9D B1 B8                 ...
        lda     ($B8),y                         ; 9952 B1 B8                    ..
        lda     ($A4),y                         ; 9954 B1 A4                    ..
        ldy     $9D                             ; 9956 A4 9D                    ..
        clv                                     ; 9958 B8                       .
        lda     ($B8),y                         ; 9959 B1 B8                    ..
        .byte   $AF                             ; 995B AF                       .
        lda     ($A4),y                         ; 995C B1 A4                    ..
        ldy     $9D                             ; 995E A4 9D                    ..
        lda     ($B8),y                         ; 9960 B1 B8                    ..
        .byte   $AF                             ; 9962 AF                       .
        lda     ($B9),y                         ; 9963 B1 B9                    ..
        ldy     $A4                             ; 9965 A4 A4                    ..
        sta     $BBBA,x                         ; 9967 9D BA BB                 ...
        lda     #$BC                            ; 996A A9 BC                    ..
        tsx                                     ; 996C BA                       .
        ldy     $BD                             ; 996D A4 BD                    ..
        eor     ($B4,x)                         ; 996F 41 B4                    A.
        .byte   $AB                             ; 9971 AB                       .
        lda     $B4,x                           ; 9972 B5 B4                    ..
        and     $A4                             ; 9974 25 A4                    %.
        sta     $BE66,x                         ; 9976 9D 66 BE                 .f.
        brk                                     ; 9979 00                       .
        brk                                     ; 997A 00                       .
        ldx     $A402,y                         ; 997B BE 02 A4                 ...
        ora     L0000                           ; 997E 05 00                    ..
        ldx     a:$01,y                         ; 9980 BE 01 00                 ...
        .byte   $B7                             ; 9983 B7                       .
        .byte   $02                             ; 9984 02                       .
        ldy     $05                             ; 9985 A4 05                    ..
        brk                                     ; 9987 00                       .
        .byte   $B7                             ; 9988 B7                       .
        sta     L9666,x                         ; 9989 9D 66 96                 .f.
        .byte   $9F                             ; 998C 9F                       .
        ldy     $9D                             ; 998D A4 9D                    ..
        ror     $21                             ; 998F 66 21                    f!
        bit     $25                             ; 9991 24 25                    $%
        sty     $A1,x                           ; 9993 94 A1                    ..
        ldy     $21                             ; 9995 A4 21                    .!
        .byte   $22                             ; 9997 22                       "
        .byte   $BF                             ; 9998 BF                       .
        stx     $96,y                           ; 9999 96 96                    ..
        sty     $A1,x                           ; 999B 94 A1                    ..
        ldy     $9D                             ; 999D A4 9D                    ..
        ror     $C0                             ; 999F 66 C0                    f.
        cmp     ($02,x)                         ; 99A1 C1 02                    ..
        sty     $A1,x                           ; 99A3 94 A1                    ..
        ldy     $21                             ; 99A5 A4 21                    .!
        bit     $BF                             ; 99A7 24 BF                    $.
        cpy     #$C2                            ; 99A9 C0 C2                    ..
        sty     $A1,x                           ; 99AB 94 A1                    ..
        ora     L0000                           ; 99AD 05 00                    ..
        .byte   $C3                             ; 99AF C3                       .
        cpy     #$05                            ; 99B0 C0 05                    ..
        .byte   $02                             ; 99B2 02                       .
        sty     $A1,x                           ; 99B3 94 A1                    ..
        ldy     #$C4                            ; 99B5 A0 C4                    ..
        cpy     #$00                            ; 99B7 C0 00                    ..
        brk                                     ; 99B9 00                       .
        .byte   $02                             ; 99BA 02                       .
        sty     $A1,x                           ; 99BB 94 A1                    ..
        ldy     $05                             ; 99BD A4 05                    ..
        brk                                     ; 99BF 00                       .
        .byte   $02                             ; 99C0 02                       .
        and     ($24,x)                         ; 99C1 21 24                    !$
        sty     $A1,x                           ; 99C3 94 A1                    ..
        ldy     $05                             ; 99C5 A4 05                    ..
        .byte   $C3                             ; 99C7 C3                       .
        brk                                     ; 99C8 00                       .
        .byte   $C3                             ; 99C9 C3                       .
        .byte   $02                             ; 99CA 02                       .
        sty     $A1,x                           ; 99CB 94 A1                    ..
        ldy     $C4                             ; 99CD A4 C4                    ..
        cpy     #$C4                            ; 99CF C0 C4                    ..
        cpy     #$C2                            ; 99D1 C0 C2                    ..
        sty     $A1,x                           ; 99D3 94 A1                    ..
        ldy     $05                             ; 99D5 A4 05                    ..
        cmp     $AC                             ; 99D7 C5 AC                    ..
        ora     $02                             ; 99D9 05 02                    ..
        sty     $25,x                           ; 99DB 94 25                    .%
        dec     $24                             ; 99DD C6 24                    .$
        .byte   $C7                             ; 99DF C7                       .
        lda     $669D                           ; 99E0 AD 9D 66                 ..f
        sty     $C6,x                           ; 99E3 94 C6                    ..
        iny                                     ; 99E5 C8                       .
        cpy     $C0                             ; 99E6 C4 C0                    ..
        lda     $669D                           ; 99E8 AD 9D 66                 ..f
        sty     $C9,x                           ; 99EB 94 C9                    ..
        ldy     #$A0                            ; 99ED A0 A0                    ..
        ldy     #$AD                            ; 99EF A0 AD                    ..
        ora     $02                             ; 99F1 05 02                    ..
        sty     $A1,x                           ; 99F3 94 A1                    ..
        ldy     $C6                             ; 99F5 A4 C6                    ..
        bit     $A1                             ; 99F7 24 A1                    $.
        ora     L0000                           ; 99F9 05 00                    ..
        brk                                     ; 99FB 00                       .
        brk                                     ; 99FC 00                       .
        brk                                     ; 99FD 00                       .
        brk                                     ; 99FE 00                       .
        brk                                     ; 99FF 00                       .
        brk                                     ; 9A00 00                       .
        brk                                     ; 9A01 00                       .
        brk                                     ; 9A02 00                       .
        .byte   $12                             ; 9A03 12                       .
        brk                                     ; 9A04 00                       .
        .byte   $12                             ; 9A05 12                       .
        brk                                     ; 9A06 00                       .
        .byte   $12                             ; 9A07 12                       .
        dex                                     ; 9A08 CA                       .
        .byte   $CB                             ; 9A09 CB                       .
        ldy     L9619                           ; 9A0A AC 19 96                 ...
        ora     $1996,y                         ; 9A0D 19 96 19                 ...
        ror     $CC                             ; 9A10 66 CC                    f.
        lda     L9406                           ; 9A12 AD 06 94                 ...
        asl     $94                             ; 9A15 06 94                    ..
        asl     L0000                           ; 9A17 06 00                    ..
        cpy     $06AD                           ; 9A19 CC AD 06                 ...
        sty     $06,x                           ; 9A1C 94 06                    ..
        sty     $06,x                           ; 9A1E 94 06                    ..
        dex                                     ; 9A20 CA                       .
        cpy     L96AD                           ; 9A21 CC AD 96                 ...
        sty     $96,x                           ; 9A24 94 96                    ..
        sty     $96,x                           ; 9A26 94 96                    ..
        ldy     #$CD                            ; 9A28 A0 CD                    ..
        lda     L941E                           ; 9A2A AD 1E 94                 ...
        asl     $1E94,x                         ; 9A2D 1E 94 1E                 ...
        ora     L0000                           ; 9A30 05 00                    ..
        ora     (L0000,x)                       ; 9A32 01 00                    ..
        brk                                     ; 9A34 00                       .
        brk                                     ; 9A35 00                       .
        brk                                     ; 9A36 00                       .
        brk                                     ; 9A37 00                       .
        brk                                     ; 9A38 00                       .
        brk                                     ; 9A39 00                       .
        brk                                     ; 9A3A 00                       .
        brk                                     ; 9A3B 00                       .
        brk                                     ; 9A3C 00                       .
        brk                                     ; 9A3D 00                       .
        brk                                     ; 9A3E 00                       .
        brk                                     ; 9A3F 00                       .
        brk                                     ; 9A40 00                       .
        .byte   $12                             ; 9A41 12                       .
        dec     $24                             ; 9A42 C6 24                    .$
        ora     L0000                           ; 9A44 05 00                    ..
        .byte   $04                             ; 9A46 04                       .
        and     ($96,x)                         ; 9A47 21 96                    !.
        ora     $0596,y                         ; 9A49 19 96 05                 ...
        brk                                     ; 9A4C 00                       .
        ora     ($04,x)                         ; 9A4D 01 04                    ..
        ora     $94                             ; 9A4F 05 94                    ..
        asl     $94                             ; 9A51 06 94                    ..
        and     $C6                             ; 9A53 25 C6                    %.
        bit     $04                             ; 9A55 24 04                    $.
        .byte   $5B                             ; 9A57 5B                       [
        sty     $06,x                           ; 9A58 94 06                    ..
        sty     $21,x                           ; 9A5A 94 21                    .!
        bit     $05                             ; 9A5C 24 05                    $.
        .byte   $04                             ; 9A5E 04                       .
        and     ($94,x)                         ; 9A5F 21 94                    !.
        stx     $94,y                           ; 9A61 96 94                    ..
        stx     $CE,y                           ; 9A63 96 CE                    ..
        rol     a                               ; 9A65 2A                       *
        .byte   $CF                             ; 9A66 CF                       .
        and     ($94,x)                         ; 9A67 21 94                    !.
        asl     $1E94,x                         ; 9A69 1E 94 1E                 ...
        bne     L9A98                           ; 9A6C D0 2A                    .*
        .byte   $CF                             ; 9A6E CF                       .
        and     (L0000,x)                       ; 9A6F 21 00                    !.
        brk                                     ; 9A71 00                       .
L9A72:  ora     ($02,x)                         ; 9A72 01 02                    ..
        cmp     ($D2),y                         ; 9A74 D1 D2                    ..
        rol     a                               ; 9A76 2A                       *
        and     (L0000,x)                       ; 9A77 21 00                    !.
        brk                                     ; 9A79 00                       .
        brk                                     ; 9A7A 00                       .
        brk                                     ; 9A7B 00                       .
        brk                                     ; 9A7C 00                       .
        and     #$2A                            ; 9A7D 29 2A                    )*
        and     ($41,x)                         ; 9A7F 21 41                    !A
        .byte   $03                             ; 9A81 03                       .
        .byte   $02                             ; 9A82 02                       .
        dec     $C8                             ; 9A83 C6 C8                    ..
        ora     $BE                             ; 9A85 05 BE                    ..
        ldx     L9502,y                         ; 9A87 BE 02 95                 ...
        stx     $98,y                           ; 9A8A 96 98                    ..
        brk                                     ; 9A8C 00                       .
        brk                                     ; 9A8D 00                       .
        ldx     $669D,y                         ; 9A8E BE 9D 66                 ..f
        sta     $D394,y                         ; 9A91 99 94 D3                 ...
        dec     L9D2A                           ; 9A94 CE 2A 9D                 .*.
        .byte   $66                             ; 9A97 66                       f
L9A98:  ror     $99                             ; 9A98 66 99                    f.
        sty     $94,x                           ; 9A9A 94 94                    ..
        bne     L9A72                           ; 9A9C D0 D4                    ..
        sta     $0266,x                         ; 9A9E 9D 66 02                 .f.
        sta     $A794,y                         ; 9AA1 99 94 A7                 ...
        cmp     $D6,x                           ; 9AA4 D5 D6                    ..
        .byte   $D7                             ; 9AA6 D7                       .
        cld                                     ; 9AA7 D8                       .
        .byte   $22                             ; 9AA8 22                       "
        cmp     L9694,y                         ; 9AA9 D9 94 96                 ...
        dec     $2A2A                           ; 9AAC CE 2A 2A                 .**
        sta     $2421,x                         ; 9AAF 9D 21 24                 .!$
        .byte   $DA                             ; 9AB2 DA                       .
        .byte   $DB                             ; 9AB3 DB                       .
        cmp     ($D4),y                         ; 9AB4 D1 D4                    ..
L9AB6:  .byte   $DC                             ; 9AB6 DC                       .
        .byte   $05                             ; 9AB7 05                       .
L9AB8:  brk                                     ; 9AB8 00                       .
        .byte   $0B                             ; 9AB9 0B                       .
        brk                                     ; 9ABA 00                       .
        brk                                     ; 9ABB 00                       .
        brk                                     ; 9ABC 00                       .
        brk                                     ; 9ABD 00                       .
        .byte   $04                             ; 9ABE 04                       .
        ora     $21                             ; 9ABF 05 21                    .!
        .byte   $22                             ; 9AC1 22                       "
        dec     $C8                             ; 9AC2 C6 C8                    ..
        and     ($24,x)                         ; 9AC4 21 24                    !$
        cmp     $22DD,x                         ; 9AC6 DD DD 22                 .."
        rol     a                               ; 9AC9 2A                       *
        dec     $CE2A                           ; 9ACA CE 2A CE                 .*.
        rol     a                               ; 9ACD 2A                       *
        dec     $022A                           ; 9ACE CE 2A 02                 .*.
        dec     $DEDF,x                         ; 9AD1 DE DF DE                 ...
        bne     L9AB6                           ; 9AD4 D0 E0                    ..
        bne     L9AB8                           ; 9AD6 D0 E0                    ..
        .byte   $02                             ; 9AD8 02                       .
        cpx     #$D0                            ; 9AD9 E0 D0                    ..
        cpx     #$E1                            ; 9ADB E0 E1                    ..
        .byte   $E2                             ; 9ADD E2                       .
        sbc     ($E2,x)                         ; 9ADE E1 E2                    ..
        ror     $E2                             ; 9AE0 66 E2                    f.
        sbc     ($E2,x)                         ; 9AE2 E1 E2                    ..
        .byte   $E3                             ; 9AE4 E3                       .
        cpx     $21                             ; 9AE5 E4 21                    .!
        bit     $02                             ; 9AE7 24 02                    $.
        sbc     $E3                             ; 9AE9 E5 E3                    ..
        cpx     $21                             ; 9AEB E4 21                    .!
        .byte   $22                             ; 9AED 22                       "
        ora     L0000                           ; 9AEE 05 00                    ..
        eor     ($3A,x)                         ; 9AF0 41 3A                    A:
        brk                                     ; 9AF2 00                       .
        brk                                     ; 9AF3 00                       .
        ora     (L0000,x)                       ; 9AF4 01 00                    ..
        inc     $9D                             ; 9AF6 E6 9D                    ..
        .byte   $02                             ; 9AF8 02                       .
        .byte   $03                             ; 9AF9 03                       .
        brk                                     ; 9AFA 00                       .
        brk                                     ; 9AFB 00                       .
        brk                                     ; 9AFC 00                       .
        brk                                     ; 9AFD 00                       .
        ldx     $DD00,y                         ; 9AFE BE 00 DD                 ...
        cmp     $DDDD,x                         ; 9B01 DD DD DD                 ...
        .byte   $DD                             ; 9B04 DD                       .
        .byte   $DD                             ; 9B05 DD                       .
L9B06:  .byte   $DD                             ; 9B06 DD                       .
L9B07:  cmp     $2ACE,x                         ; 9B07 DD CE 2A                 ..*
        dec     $CE2A                           ; 9B0A CE 2A CE                 .*.
        rol     a                               ; 9B0D 2A                       *
        dec     $D02A                           ; 9B0E CE 2A D0                 .*.
        cpx     #$D0                            ; 9B11 E0 D0                    ..
        cpx     #$D0                            ; 9B13 E0 D0                    ..
        .byte   $E0                             ; 9B15 E0                       .
L9B16:  .byte   $D0,$E7                    ; 9B16 D0 E7   (branch out of range for ca65: target has no local label)
        .byte   $DF                             ; 9B18 DF                       .
        dec     $E8DF,x                         ; 9B19 DE DF E8                 ...
        sbc     #$DE                            ; 9B1C E9 DE                    ..
        .byte   $DF                             ; 9B1E DF                       .
        .byte   $03                             ; 9B1F 03                       .
        .byte   $02                             ; 9B20 02                       .
        cpx     #$D0                            ; 9B21 E0 D0                    ..
        nop                                     ; 9B23 EA                       .
        bne     L9B06                           ; 9B24 D0 E0                    ..
        bne     L9B2B                           ; 9B26 D0 03                    ..
        .byte   $02                             ; 9B28 02                       .
        .byte   $DE                             ; 9B29 DE                       .
        .byte   $DF                             ; 9B2A DF                       .
L9B2B:  .byte   $EB                             ; 9B2B EB                       .
        .byte   $DF                             ; 9B2C DF                       .
        dec     $EDEC,x                         ; 9B2D DE EC ED                 ...
        ror     $E0                             ; 9B30 66 E0                    f.
        ora     $29                             ; 9B32 05 29                    .)
L9B34:  bne     L9B16                           ; 9B34 D0 E0                    ..
L9B36:  ora     $02                             ; 9B36 05 02                    ..
        .byte   $02                             ; 9B38 02                       .
        rol     a                               ; 9B39 2A                       *
        ora     $29                             ; 9B3A 05 29                    .)
        bne     L9B68                           ; 9B3C D0 2A                    .*
        ora     $E6                             ; 9B3E 05 E6                    ..
        cmp     $DDDD,x                         ; 9B40 DD DD DD                 ...
        dec     $C8                             ; 9B43 C6 C8                    ..
        dec     $C8                             ; 9B45 C6 C8                    ..
        inc     $2ACE                           ; 9B47 EE CE 2A                 ..*
        dec     $F0EF                           ; 9B4A CE EF F0                 ...
        .byte   $4F                             ; 9B4D 4F                       O
        beq     L9B07                           ; 9B4E F0 B7                    ..
        cmp     ($D2),y                         ; 9B50 D1 D2                    ..
        bne     L9B34                           ; 9B52 D0 E0                    ..
        bne     L9B36                           ; 9B54 D0 E0                    ..
        lda     $F1D6                           ; 9B56 AD D6 F1                 ...
        .byte   $F2                             ; 9B59 F2                       .
        .byte   $DF                             ; 9B5A DF                       .
        dec     $DEDF,x                         ; 9B5B DE DF DE                 ...
        lda     a:$D6                           ; 9B5E AD D6 00                 ...
        and     #$D0                            ; 9B61 29 D0                    ).
        cpx     #$D0                            ; 9B63 E0 D0                    ..
        cpx     #$AD                            ; 9B65 E0 AD                    ..
        .byte   $F3                             ; 9B67 F3                       .
L9B68:  .byte   $F4                             ; 9B68 F4                       .
        .byte   $F2                             ; 9B69 F2                       .
        .byte   $DF                             ; 9B6A DF                       .
        dec     $DEDF,x                         ; 9B6B DE DF DE                 ...
        lda     $BEF5                           ; 9B6E AD F5 BE                 ...
        rol     $F6D1                           ; 9B71 2E D1 F6                 ...
        sta     $C666,x                         ; 9B74 9D 66 C6                 .f.
        iny                                     ; 9B77 C8                       .
        ldx     $0200,y                         ; 9B78 BE 00 02                 ...
        sta     L9D66,x                         ; 9B7B 9D 66 9D                 .f.
        ror     $05                             ; 9B7E 66 05                    f.
        ror     $EE                             ; 9B80 66 EE                    f.
        ror     $C5                             ; 9B82 66 C5                    f.
        ror     $C6                             ; 9B84 66 C6                    f.
        iny                                     ; 9B86 C8                       .
        .byte   $AB                             ; 9B87 AB                       .
        ldx     a:$B7,y                         ; 9B88 BE B7 00                 ...
        ldx     $0100,y                         ; 9B8B BE 00 01                 ...
        brk                                     ; 9B8E 00                       .
        inc     $BE                             ; 9B8F E6 BE                    ..
        brk                                     ; 9B91 00                       .
        .byte   $F7                             ; 9B92 F7                       .
        .byte   $B7                             ; 9B93 B7                       .
        ora     ($02,x)                         ; 9B94 01 02                    ..
        dec     $B7,x                           ; 9B96 D6 B7                    ..
        .byte   $B7                             ; 9B98 B7                       .
L9B99:  brk                                     ; 9B99 00                       .
        brk                                     ; 9B9A 00                       .
        brk                                     ; 9B9B 00                       .
        brk                                     ; 9B9C 00                       .
        brk                                     ; 9B9D 00                       .
        brk                                     ; 9B9E 00                       .
        brk                                     ; 9B9F 00                       .
        .byte   $4F                             ; 9BA0 4F                       O
        .byte   $4F                             ; 9BA1 4F                       O
        .byte   $4F                             ; 9BA2 4F                       O
        .byte   $4F                             ; 9BA3 4F                       O
        .byte   $4F                             ; 9BA4 4F                       O
        .byte   $4F                             ; 9BA5 4F                       O
        .byte   $4F                             ; 9BA6 4F                       O
        sed                                     ; 9BA7 F8                       .
        sty     $94,x                           ; 9BA8 94 94                    ..
        txs                                     ; 9BAA 9A                       .
        sty     $94,x                           ; 9BAB 94 94                    ..
        sty     $9A,x                           ; 9BAD 94 9A                    ..
        sbc     $21,x                           ; 9BAF F5 21                    .!
        .byte   $22                             ; 9BB1 22                       "
        and     ($22,x)                         ; 9BB2 21 22                    !"
        and     ($22,x)                         ; 9BB4 21 22                    !"
        sbc     $DD,y                           ; 9BB6 F9 DD 00                 ...
        brk                                     ; 9BB9 00                       .
        brk                                     ; 9BBA 00                       .
        brk                                     ; 9BBB 00                       .
        brk                                     ; 9BBC 00                       .
        brk                                     ; 9BBD 00                       .
        brk                                     ; 9BBE 00                       .
        .byte   $02                             ; 9BBF 02                       .
        sbc     $DDDD,y                         ; 9BC0 F9 DD DD                 ...
        cmp     $DDDD,x                         ; 9BC3 DD DD DD                 ...
        cmp     $FADD,x                         ; 9BC6 DD DD FA                 ...
        stx     $97,y                           ; 9BC9 96 97                    ..
        stx     $96,y                           ; 9BCB 96 96                    ..
        .byte   $97                             ; 9BCD 97                       .
        stx     $98,y                           ; 9BCE 96 98                    ..
        .byte   $FB                             ; 9BD0 FB                       .
        sty     $9A,x                           ; 9BD1 94 9A                    ..
        sty     $94,x                           ; 9BD3 94 94                    ..
        txs                                     ; 9BD5 9A                       .
        sty     $9B,x                           ; 9BD6 94 9B                    ..
        .byte   $FB                             ; 9BD8 FB                       .
        sty     $9A,x                           ; 9BD9 94 9A                    ..
        sty     $94,x                           ; 9BDB 94 94                    ..
        txs                                     ; 9BDD 9A                       .
        sty     $9B,x                           ; 9BDE 94 9B                    ..
        .byte   $FC                             ; 9BE0 FC                       .
        sty     $9A,x                           ; 9BE1 94 9A                    ..
        sty     $94,x                           ; 9BE3 94 94                    ..
        txs                                     ; 9BE5 9A                       .
        sty     $9B,x                           ; 9BE6 94 9B                    ..
        sty     $94,x                           ; 9BE8 94 94                    ..
        txs                                     ; 9BEA 9A                       .
        sty     $94,x                           ; 9BEB 94 94                    ..
        txs                                     ; 9BED 9A                       .
        sty     $9B,x                           ; 9BEE 94 9B                    ..
        cmp     $DDDD,x                         ; 9BF0 DD DD DD                 ...
        cmp     $DDDD,x                         ; 9BF3 DD DD DD                 ...
        cmp     $FDDD,x                         ; 9BF6 DD DD FD                 ...
        sbc     $FDFD,x                         ; 9BF9 FD FD FD                 ...
        sbc     $FDFD,x                         ; 9BFC FD FD FD                 ...
        sbc     $2A2A,x                         ; 9BFF FD 2A 2A                 .**
        rol     a                               ; 9C02 2A                       *
        rol     a                               ; 9C03 2A                       *
        rol     a                               ; 9C04 2A                       *
        rol     a                               ; 9C05 2A                       *
        rol     a                               ; 9C06 2A                       *
        rol     a                               ; 9C07 2A                       *
        rol     a                               ; 9C08 2A                       *
        rol     a                               ; 9C09 2A                       *
        rol     a                               ; 9C0A 2A                       *
        rol     a                               ; 9C0B 2A                       *
        rol     a                               ; 9C0C 2A                       *
        rol     a                               ; 9C0D 2A                       *
        rol     a                               ; 9C0E 2A                       *
        rol     a                               ; 9C0F 2A                       *
        rol     a                               ; 9C10 2A                       *
        rol     a                               ; 9C11 2A                       *
        rol     a                               ; 9C12 2A                       *
        rol     a                               ; 9C13 2A                       *
        rol     a                               ; 9C14 2A                       *
        rol     a                               ; 9C15 2A                       *
        rol     a                               ; 9C16 2A                       *
        rol     a                               ; 9C17 2A                       *
        rol     a                               ; 9C18 2A                       *
        rol     a                               ; 9C19 2A                       *
        rol     a                               ; 9C1A 2A                       *
        rol     a                               ; 9C1B 2A                       *
        rol     a                               ; 9C1C 2A                       *
        rol     a                               ; 9C1D 2A                       *
        rol     a                               ; 9C1E 2A                       *
        rol     a                               ; 9C1F 2A                       *
        rol     a                               ; 9C20 2A                       *
        rol     a                               ; 9C21 2A                       *
        rol     a                               ; 9C22 2A                       *
        rol     a                               ; 9C23 2A                       *
        rol     a                               ; 9C24 2A                       *
        rol     a                               ; 9C25 2A                       *
        rol     a                               ; 9C26 2A                       *
        rol     a                               ; 9C27 2A                       *
        rol     a                               ; 9C28 2A                       *
        rol     a                               ; 9C29 2A                       *
        rol     a                               ; 9C2A 2A                       *
        rol     a                               ; 9C2B 2A                       *
        rol     a                               ; 9C2C 2A                       *
        rol     a                               ; 9C2D 2A                       *
        rol     a                               ; 9C2E 2A                       *
        rol     a                               ; 9C2F 2A                       *
        rol     a                               ; 9C30 2A                       *
        rol     a                               ; 9C31 2A                       *
        rol     a                               ; 9C32 2A                       *
        rol     a                               ; 9C33 2A                       *
        rol     a                               ; 9C34 2A                       *
        rol     a                               ; 9C35 2A                       *
        rol     a                               ; 9C36 2A                       *
        rol     a                               ; 9C37 2A                       *
        rol     a                               ; 9C38 2A                       *
        rol     a                               ; 9C39 2A                       *
        rol     a                               ; 9C3A 2A                       *
        rol     a                               ; 9C3B 2A                       *
        rol     a                               ; 9C3C 2A                       *
        rol     a                               ; 9C3D 2A                       *
        rol     a                               ; 9C3E 2A                       *
        rol     a                               ; 9C3F 2A                       *
        rol     a                               ; 9C40 2A                       *
        rol     a                               ; 9C41 2A                       *
        rol     a                               ; 9C42 2A                       *
        rol     a                               ; 9C43 2A                       *
        rol     a                               ; 9C44 2A                       *
        rol     a                               ; 9C45 2A                       *
        rol     a                               ; 9C46 2A                       *
        rol     a                               ; 9C47 2A                       *
        rol     a                               ; 9C48 2A                       *
        rol     a                               ; 9C49 2A                       *
        rol     a                               ; 9C4A 2A                       *
        rol     a                               ; 9C4B 2A                       *
        rol     a                               ; 9C4C 2A                       *
        rol     a                               ; 9C4D 2A                       *
        rol     a                               ; 9C4E 2A                       *
        rol     a                               ; 9C4F 2A                       *
        rol     a                               ; 9C50 2A                       *
        rol     a                               ; 9C51 2A                       *
        rol     a                               ; 9C52 2A                       *
        rol     a                               ; 9C53 2A                       *
        rol     a                               ; 9C54 2A                       *
        rol     a                               ; 9C55 2A                       *
        rol     a                               ; 9C56 2A                       *
        rol     a                               ; 9C57 2A                       *
        rol     a                               ; 9C58 2A                       *
        rol     a                               ; 9C59 2A                       *
        rol     a                               ; 9C5A 2A                       *
        rol     a                               ; 9C5B 2A                       *
        rol     a                               ; 9C5C 2A                       *
        rol     a                               ; 9C5D 2A                       *
        rol     a                               ; 9C5E 2A                       *
        rol     a                               ; 9C5F 2A                       *
        rol     a                               ; 9C60 2A                       *
        rol     a                               ; 9C61 2A                       *
        rol     a                               ; 9C62 2A                       *
        rol     a                               ; 9C63 2A                       *
        rol     a                               ; 9C64 2A                       *
        rol     a                               ; 9C65 2A                       *
        rol     a                               ; 9C66 2A                       *
        rol     a                               ; 9C67 2A                       *
        rol     a                               ; 9C68 2A                       *
        rol     a                               ; 9C69 2A                       *
        rol     a                               ; 9C6A 2A                       *
        rol     a                               ; 9C6B 2A                       *
        rol     a                               ; 9C6C 2A                       *
        rol     a                               ; 9C6D 2A                       *
        rol     a                               ; 9C6E 2A                       *
        rol     a                               ; 9C6F 2A                       *
        rol     a                               ; 9C70 2A                       *
        rol     a                               ; 9C71 2A                       *
        rol     a                               ; 9C72 2A                       *
        rol     a                               ; 9C73 2A                       *
        rol     a                               ; 9C74 2A                       *
        rol     a                               ; 9C75 2A                       *
        rol     a                               ; 9C76 2A                       *
        rol     a                               ; 9C77 2A                       *
        rol     a                               ; 9C78 2A                       *
        rol     a                               ; 9C79 2A                       *
        rol     a                               ; 9C7A 2A                       *
        rol     a                               ; 9C7B 2A                       *
        rol     a                               ; 9C7C 2A                       *
        rol     a                               ; 9C7D 2A                       *
        rol     a                               ; 9C7E 2A                       *
        rol     a                               ; 9C7F 2A                       *
        rol     a                               ; 9C80 2A                       *
        rol     a                               ; 9C81 2A                       *
        rol     a                               ; 9C82 2A                       *
        rol     a                               ; 9C83 2A                       *
        rol     a                               ; 9C84 2A                       *
        rol     a                               ; 9C85 2A                       *
        rol     a                               ; 9C86 2A                       *
        rol     a                               ; 9C87 2A                       *
        rol     a                               ; 9C88 2A                       *
        rol     a                               ; 9C89 2A                       *
        rol     a                               ; 9C8A 2A                       *
        rol     a                               ; 9C8B 2A                       *
        rol     a                               ; 9C8C 2A                       *
        rol     a                               ; 9C8D 2A                       *
        rol     a                               ; 9C8E 2A                       *
        rol     a                               ; 9C8F 2A                       *
        rol     a                               ; 9C90 2A                       *
        rol     a                               ; 9C91 2A                       *
        rol     a                               ; 9C92 2A                       *
        rol     a                               ; 9C93 2A                       *
        rol     a                               ; 9C94 2A                       *
        rol     a                               ; 9C95 2A                       *
        rol     a                               ; 9C96 2A                       *
        rol     a                               ; 9C97 2A                       *
        rol     a                               ; 9C98 2A                       *
        rol     a                               ; 9C99 2A                       *
        rol     a                               ; 9C9A 2A                       *
        rol     a                               ; 9C9B 2A                       *
L9C9C:  rol     a                               ; 9C9C 2A                       *
        rol     a                               ; 9C9D 2A                       *
        rol     a                               ; 9C9E 2A                       *
        rol     a                               ; 9C9F 2A                       *
        rol     a                               ; 9CA0 2A                       *
        rol     a                               ; 9CA1 2A                       *
        rol     a                               ; 9CA2 2A                       *
        rol     a                               ; 9CA3 2A                       *
        rol     a                               ; 9CA4 2A                       *
        rol     a                               ; 9CA5 2A                       *
        rol     a                               ; 9CA6 2A                       *
        rol     a                               ; 9CA7 2A                       *
        rol     a                               ; 9CA8 2A                       *
        rol     a                               ; 9CA9 2A                       *
        rol     a                               ; 9CAA 2A                       *
        rol     a                               ; 9CAB 2A                       *
        rol     a                               ; 9CAC 2A                       *
        rol     a                               ; 9CAD 2A                       *
        rol     a                               ; 9CAE 2A                       *
        rol     a                               ; 9CAF 2A                       *
        rol     a                               ; 9CB0 2A                       *
        rol     a                               ; 9CB1 2A                       *
        rol     a                               ; 9CB2 2A                       *
        rol     a                               ; 9CB3 2A                       *
        rol     a                               ; 9CB4 2A                       *
        rol     a                               ; 9CB5 2A                       *
        rol     a                               ; 9CB6 2A                       *
        rol     a                               ; 9CB7 2A                       *
        rol     a                               ; 9CB8 2A                       *
        rol     a                               ; 9CB9 2A                       *
        rol     a                               ; 9CBA 2A                       *
        rol     a                               ; 9CBB 2A                       *
        rol     a                               ; 9CBC 2A                       *
        rol     a                               ; 9CBD 2A                       *
        rol     a                               ; 9CBE 2A                       *
        rol     a                               ; 9CBF 2A                       *
        rol     a                               ; 9CC0 2A                       *
        rol     a                               ; 9CC1 2A                       *
        rol     a                               ; 9CC2 2A                       *
        rol     a                               ; 9CC3 2A                       *
        rol     a                               ; 9CC4 2A                       *
        rol     a                               ; 9CC5 2A                       *
        rol     a                               ; 9CC6 2A                       *
        rol     a                               ; 9CC7 2A                       *
        rol     a                               ; 9CC8 2A                       *
        rol     a                               ; 9CC9 2A                       *
        rol     a                               ; 9CCA 2A                       *
        rol     a                               ; 9CCB 2A                       *
        rol     a                               ; 9CCC 2A                       *
        rol     a                               ; 9CCD 2A                       *
        rol     a                               ; 9CCE 2A                       *
        rol     a                               ; 9CCF 2A                       *
        rol     a                               ; 9CD0 2A                       *
        rol     a                               ; 9CD1 2A                       *
        rol     a                               ; 9CD2 2A                       *
        rol     a                               ; 9CD3 2A                       *
        rol     a                               ; 9CD4 2A                       *
        rol     a                               ; 9CD5 2A                       *
        rol     a                               ; 9CD6 2A                       *
        rol     a                               ; 9CD7 2A                       *
        rol     a                               ; 9CD8 2A                       *
        rol     a                               ; 9CD9 2A                       *
        rol     a                               ; 9CDA 2A                       *
        rol     a                               ; 9CDB 2A                       *
        rol     a                               ; 9CDC 2A                       *
        rol     a                               ; 9CDD 2A                       *
        rol     a                               ; 9CDE 2A                       *
        rol     a                               ; 9CDF 2A                       *
        rol     a                               ; 9CE0 2A                       *
        rol     a                               ; 9CE1 2A                       *
        rol     a                               ; 9CE2 2A                       *
        rol     a                               ; 9CE3 2A                       *
        rol     a                               ; 9CE4 2A                       *
        rol     a                               ; 9CE5 2A                       *
        rol     a                               ; 9CE6 2A                       *
        rol     a                               ; 9CE7 2A                       *
        rol     a                               ; 9CE8 2A                       *
        rol     a                               ; 9CE9 2A                       *
        rol     a                               ; 9CEA 2A                       *
        rol     a                               ; 9CEB 2A                       *
        rol     a                               ; 9CEC 2A                       *
        rol     a                               ; 9CED 2A                       *
        rol     a                               ; 9CEE 2A                       *
        rol     a                               ; 9CEF 2A                       *
        rol     a                               ; 9CF0 2A                       *
        rol     a                               ; 9CF1 2A                       *
        rol     a                               ; 9CF2 2A                       *
        rol     a                               ; 9CF3 2A                       *
        rol     a                               ; 9CF4 2A                       *
        rol     a                               ; 9CF5 2A                       *
        rol     a                               ; 9CF6 2A                       *
        rol     a                               ; 9CF7 2A                       *
        rol     a                               ; 9CF8 2A                       *
        rol     a                               ; 9CF9 2A                       *
        rol     a                               ; 9CFA 2A                       *
        rol     a                               ; 9CFB 2A                       *
        rol     a                               ; 9CFC 2A                       *
        rol     a                               ; 9CFD 2A                       *
        rol     a                               ; 9CFE 2A                       *
        rol     a                               ; 9CFF 2A                       *
        rol     a                               ; 9D00 2A                       *
        rol     a                               ; 9D01 2A                       *
        rol     a                               ; 9D02 2A                       *
        rol     a                               ; 9D03 2A                       *
        rol     a                               ; 9D04 2A                       *
        rol     a                               ; 9D05 2A                       *
        rol     a                               ; 9D06 2A                       *
        rol     a                               ; 9D07 2A                       *
        rol     a                               ; 9D08 2A                       *
        rol     a                               ; 9D09 2A                       *
        rol     a                               ; 9D0A 2A                       *
        rol     a                               ; 9D0B 2A                       *
        rol     a                               ; 9D0C 2A                       *
        rol     a                               ; 9D0D 2A                       *
        rol     a                               ; 9D0E 2A                       *
        rol     a                               ; 9D0F 2A                       *
        rol     a                               ; 9D10 2A                       *
        rol     a                               ; 9D11 2A                       *
        rol     a                               ; 9D12 2A                       *
        rol     a                               ; 9D13 2A                       *
        rol     a                               ; 9D14 2A                       *
        rol     a                               ; 9D15 2A                       *
        rol     a                               ; 9D16 2A                       *
        rol     a                               ; 9D17 2A                       *
        rol     a                               ; 9D18 2A                       *
        rol     a                               ; 9D19 2A                       *
        rol     a                               ; 9D1A 2A                       *
        rol     a                               ; 9D1B 2A                       *
        rol     a                               ; 9D1C 2A                       *
        rol     a                               ; 9D1D 2A                       *
        rol     a                               ; 9D1E 2A                       *
        rol     a                               ; 9D1F 2A                       *
        rol     a                               ; 9D20 2A                       *
        rol     a                               ; 9D21 2A                       *
        rol     a                               ; 9D22 2A                       *
        rol     a                               ; 9D23 2A                       *
        rol     a                               ; 9D24 2A                       *
        rol     a                               ; 9D25 2A                       *
        rol     a                               ; 9D26 2A                       *
        rol     a                               ; 9D27 2A                       *
        rol     a                               ; 9D28 2A                       *
        rol     a                               ; 9D29 2A                       *
L9D2A:  rol     a                               ; 9D2A 2A                       *
        rol     a                               ; 9D2B 2A                       *
        rol     a                               ; 9D2C 2A                       *
        rol     a                               ; 9D2D 2A                       *
        rol     a                               ; 9D2E 2A                       *
        rol     a                               ; 9D2F 2A                       *
        rol     a                               ; 9D30 2A                       *
        rol     a                               ; 9D31 2A                       *
        rol     a                               ; 9D32 2A                       *
        rol     a                               ; 9D33 2A                       *
        rol     a                               ; 9D34 2A                       *
        rol     a                               ; 9D35 2A                       *
        rol     a                               ; 9D36 2A                       *
        rol     a                               ; 9D37 2A                       *
        rol     a                               ; 9D38 2A                       *
        rol     a                               ; 9D39 2A                       *
        rol     a                               ; 9D3A 2A                       *
        rol     a                               ; 9D3B 2A                       *
        rol     a                               ; 9D3C 2A                       *
        rol     a                               ; 9D3D 2A                       *
        rol     a                               ; 9D3E 2A                       *
        rol     a                               ; 9D3F 2A                       *
        rol     a                               ; 9D40 2A                       *
        rol     a                               ; 9D41 2A                       *
        rol     a                               ; 9D42 2A                       *
        rol     a                               ; 9D43 2A                       *
        rol     a                               ; 9D44 2A                       *
        rol     a                               ; 9D45 2A                       *
        rol     a                               ; 9D46 2A                       *
        rol     a                               ; 9D47 2A                       *
        rol     a                               ; 9D48 2A                       *
        rol     a                               ; 9D49 2A                       *
        rol     a                               ; 9D4A 2A                       *
        rol     a                               ; 9D4B 2A                       *
        rol     a                               ; 9D4C 2A                       *
        rol     a                               ; 9D4D 2A                       *
        rol     a                               ; 9D4E 2A                       *
        rol     a                               ; 9D4F 2A                       *
        rol     a                               ; 9D50 2A                       *
        rol     a                               ; 9D51 2A                       *
        rol     a                               ; 9D52 2A                       *
        rol     a                               ; 9D53 2A                       *
        rol     a                               ; 9D54 2A                       *
        rol     a                               ; 9D55 2A                       *
        rol     a                               ; 9D56 2A                       *
        rol     a                               ; 9D57 2A                       *
        rol     a                               ; 9D58 2A                       *
        rol     a                               ; 9D59 2A                       *
        rol     a                               ; 9D5A 2A                       *
        rol     a                               ; 9D5B 2A                       *
        rol     a                               ; 9D5C 2A                       *
        rol     a                               ; 9D5D 2A                       *
        rol     a                               ; 9D5E 2A                       *
        rol     a                               ; 9D5F 2A                       *
        rol     a                               ; 9D60 2A                       *
        rol     a                               ; 9D61 2A                       *
        rol     a                               ; 9D62 2A                       *
        rol     a                               ; 9D63 2A                       *
        rol     a                               ; 9D64 2A                       *
        rol     a                               ; 9D65 2A                       *
L9D66:  rol     a                               ; 9D66 2A                       *
        rol     a                               ; 9D67 2A                       *
        rol     a                               ; 9D68 2A                       *
        rol     a                               ; 9D69 2A                       *
        rol     a                               ; 9D6A 2A                       *
        rol     a                               ; 9D6B 2A                       *
        rol     a                               ; 9D6C 2A                       *
        rol     a                               ; 9D6D 2A                       *
        rol     a                               ; 9D6E 2A                       *
        rol     a                               ; 9D6F 2A                       *
        rol     a                               ; 9D70 2A                       *
        rol     a                               ; 9D71 2A                       *
        rol     a                               ; 9D72 2A                       *
        rol     a                               ; 9D73 2A                       *
        rol     a                               ; 9D74 2A                       *
        rol     a                               ; 9D75 2A                       *
        rol     a                               ; 9D76 2A                       *
        rol     a                               ; 9D77 2A                       *
        rol     a                               ; 9D78 2A                       *
        rol     a                               ; 9D79 2A                       *
        rol     a                               ; 9D7A 2A                       *
        rol     a                               ; 9D7B 2A                       *
        rol     a                               ; 9D7C 2A                       *
        rol     a                               ; 9D7D 2A                       *
        rol     a                               ; 9D7E 2A                       *
        rol     a                               ; 9D7F 2A                       *
        rol     a                               ; 9D80 2A                       *
        rol     a                               ; 9D81 2A                       *
        rol     a                               ; 9D82 2A                       *
        rol     a                               ; 9D83 2A                       *
        rol     a                               ; 9D84 2A                       *
        rol     a                               ; 9D85 2A                       *
        rol     a                               ; 9D86 2A                       *
        rol     a                               ; 9D87 2A                       *
        rol     a                               ; 9D88 2A                       *
        rol     a                               ; 9D89 2A                       *
        rol     a                               ; 9D8A 2A                       *
        rol     a                               ; 9D8B 2A                       *
        rol     a                               ; 9D8C 2A                       *
        rol     a                               ; 9D8D 2A                       *
        rol     a                               ; 9D8E 2A                       *
        rol     a                               ; 9D8F 2A                       *
        rol     a                               ; 9D90 2A                       *
        rol     a                               ; 9D91 2A                       *
        rol     a                               ; 9D92 2A                       *
        rol     a                               ; 9D93 2A                       *
        rol     a                               ; 9D94 2A                       *
        rol     a                               ; 9D95 2A                       *
        rol     a                               ; 9D96 2A                       *
        rol     a                               ; 9D97 2A                       *
        rol     a                               ; 9D98 2A                       *
        rol     a                               ; 9D99 2A                       *
        rol     a                               ; 9D9A 2A                       *
        rol     a                               ; 9D9B 2A                       *
        rol     a                               ; 9D9C 2A                       *
        rol     a                               ; 9D9D 2A                       *
        rol     a                               ; 9D9E 2A                       *
        rol     a                               ; 9D9F 2A                       *
        rol     a                               ; 9DA0 2A                       *
        rol     a                               ; 9DA1 2A                       *
        rol     a                               ; 9DA2 2A                       *
        rol     a                               ; 9DA3 2A                       *
        rol     a                               ; 9DA4 2A                       *
        rol     a                               ; 9DA5 2A                       *
        rol     a                               ; 9DA6 2A                       *
        rol     a                               ; 9DA7 2A                       *
        rol     a                               ; 9DA8 2A                       *
        rol     a                               ; 9DA9 2A                       *
        rol     a                               ; 9DAA 2A                       *
        rol     a                               ; 9DAB 2A                       *
        rol     a                               ; 9DAC 2A                       *
        rol     a                               ; 9DAD 2A                       *
        rol     a                               ; 9DAE 2A                       *
        rol     a                               ; 9DAF 2A                       *
        rol     a                               ; 9DB0 2A                       *
        rol     a                               ; 9DB1 2A                       *
        rol     a                               ; 9DB2 2A                       *
        rol     a                               ; 9DB3 2A                       *
        rol     a                               ; 9DB4 2A                       *
        rol     a                               ; 9DB5 2A                       *
        rol     a                               ; 9DB6 2A                       *
        rol     a                               ; 9DB7 2A                       *
        rol     a                               ; 9DB8 2A                       *
        rol     a                               ; 9DB9 2A                       *
        rol     a                               ; 9DBA 2A                       *
        rol     a                               ; 9DBB 2A                       *
        rol     a                               ; 9DBC 2A                       *
        rol     a                               ; 9DBD 2A                       *
        rol     a                               ; 9DBE 2A                       *
        rol     a                               ; 9DBF 2A                       *
        rol     a                               ; 9DC0 2A                       *
        rol     a                               ; 9DC1 2A                       *
        rol     a                               ; 9DC2 2A                       *
        rol     a                               ; 9DC3 2A                       *
        rol     a                               ; 9DC4 2A                       *
        rol     a                               ; 9DC5 2A                       *
        rol     a                               ; 9DC6 2A                       *
        rol     a                               ; 9DC7 2A                       *
        rol     a                               ; 9DC8 2A                       *
        rol     a                               ; 9DC9 2A                       *
        rol     a                               ; 9DCA 2A                       *
        rol     a                               ; 9DCB 2A                       *
        rol     a                               ; 9DCC 2A                       *
        rol     a                               ; 9DCD 2A                       *
        rol     a                               ; 9DCE 2A                       *
        rol     a                               ; 9DCF 2A                       *
        rol     a                               ; 9DD0 2A                       *
        rol     a                               ; 9DD1 2A                       *
        rol     a                               ; 9DD2 2A                       *
        rol     a                               ; 9DD3 2A                       *
        rol     a                               ; 9DD4 2A                       *
        rol     a                               ; 9DD5 2A                       *
        rol     a                               ; 9DD6 2A                       *
        rol     a                               ; 9DD7 2A                       *
        rol     a                               ; 9DD8 2A                       *
        rol     a                               ; 9DD9 2A                       *
        rol     a                               ; 9DDA 2A                       *
        rol     a                               ; 9DDB 2A                       *
        rol     a                               ; 9DDC 2A                       *
        rol     a                               ; 9DDD 2A                       *
        rol     a                               ; 9DDE 2A                       *
        rol     a                               ; 9DDF 2A                       *
        rol     a                               ; 9DE0 2A                       *
        rol     a                               ; 9DE1 2A                       *
        rol     a                               ; 9DE2 2A                       *
        rol     a                               ; 9DE3 2A                       *
        rol     a                               ; 9DE4 2A                       *
        rol     a                               ; 9DE5 2A                       *
        rol     a                               ; 9DE6 2A                       *
        rol     a                               ; 9DE7 2A                       *
        rol     a                               ; 9DE8 2A                       *
        rol     a                               ; 9DE9 2A                       *
        rol     a                               ; 9DEA 2A                       *
        rol     a                               ; 9DEB 2A                       *
        rol     a                               ; 9DEC 2A                       *
        rol     a                               ; 9DED 2A                       *
        rol     a                               ; 9DEE 2A                       *
        rol     a                               ; 9DEF 2A                       *
        rol     a                               ; 9DF0 2A                       *
        rol     a                               ; 9DF1 2A                       *
        rol     a                               ; 9DF2 2A                       *
        rol     a                               ; 9DF3 2A                       *
        rol     a                               ; 9DF4 2A                       *
        rol     a                               ; 9DF5 2A                       *
        rol     a                               ; 9DF6 2A                       *
        rol     a                               ; 9DF7 2A                       *
        rol     a                               ; 9DF8 2A                       *
        rol     a                               ; 9DF9 2A                       *
        rol     a                               ; 9DFA 2A                       *
        rol     a                               ; 9DFB 2A                       *
        rol     a                               ; 9DFC 2A                       *
        rol     a                               ; 9DFD 2A                       *
        rol     a                               ; 9DFE 2A                       *
        rol     a                               ; 9DFF 2A                       *
        rol     a                               ; 9E00 2A                       *
        rol     a                               ; 9E01 2A                       *
        rol     a                               ; 9E02 2A                       *
        rol     a                               ; 9E03 2A                       *
        rol     a                               ; 9E04 2A                       *
        rol     a                               ; 9E05 2A                       *
        rol     a                               ; 9E06 2A                       *
        rol     a                               ; 9E07 2A                       *
        rol     a                               ; 9E08 2A                       *
        rol     a                               ; 9E09 2A                       *
        rol     a                               ; 9E0A 2A                       *
        rol     a                               ; 9E0B 2A                       *
        rol     a                               ; 9E0C 2A                       *
        rol     a                               ; 9E0D 2A                       *
        rol     a                               ; 9E0E 2A                       *
        rol     a                               ; 9E0F 2A                       *
        rol     a                               ; 9E10 2A                       *
        rol     a                               ; 9E11 2A                       *
        rol     a                               ; 9E12 2A                       *
        rol     a                               ; 9E13 2A                       *
        rol     a                               ; 9E14 2A                       *
        rol     a                               ; 9E15 2A                       *
        rol     a                               ; 9E16 2A                       *
        rol     a                               ; 9E17 2A                       *
        rol     a                               ; 9E18 2A                       *
        rol     a                               ; 9E19 2A                       *
        rol     a                               ; 9E1A 2A                       *
        rol     a                               ; 9E1B 2A                       *
        rol     a                               ; 9E1C 2A                       *
        rol     a                               ; 9E1D 2A                       *
        rol     a                               ; 9E1E 2A                       *
        rol     a                               ; 9E1F 2A                       *
        rol     a                               ; 9E20 2A                       *
        rol     a                               ; 9E21 2A                       *
        rol     a                               ; 9E22 2A                       *
        rol     a                               ; 9E23 2A                       *
        rol     a                               ; 9E24 2A                       *
        rol     a                               ; 9E25 2A                       *
        rol     a                               ; 9E26 2A                       *
        rol     a                               ; 9E27 2A                       *
        rol     a                               ; 9E28 2A                       *
        rol     a                               ; 9E29 2A                       *
        rol     a                               ; 9E2A 2A                       *
        rol     a                               ; 9E2B 2A                       *
        rol     a                               ; 9E2C 2A                       *
        rol     a                               ; 9E2D 2A                       *
        rol     a                               ; 9E2E 2A                       *
        rol     a                               ; 9E2F 2A                       *
        rol     a                               ; 9E30 2A                       *
        rol     a                               ; 9E31 2A                       *
        rol     a                               ; 9E32 2A                       *
        rol     a                               ; 9E33 2A                       *
        rol     a                               ; 9E34 2A                       *
        rol     a                               ; 9E35 2A                       *
        rol     a                               ; 9E36 2A                       *
        rol     a                               ; 9E37 2A                       *
        rol     a                               ; 9E38 2A                       *
        rol     a                               ; 9E39 2A                       *
        rol     a                               ; 9E3A 2A                       *
        rol     a                               ; 9E3B 2A                       *
        rol     a                               ; 9E3C 2A                       *
        rol     a                               ; 9E3D 2A                       *
        rol     a                               ; 9E3E 2A                       *
        rol     a                               ; 9E3F 2A                       *
        rol     a                               ; 9E40 2A                       *
        rol     a                               ; 9E41 2A                       *
        rol     a                               ; 9E42 2A                       *
        rol     a                               ; 9E43 2A                       *
        rol     a                               ; 9E44 2A                       *
        rol     a                               ; 9E45 2A                       *
        rol     a                               ; 9E46 2A                       *
        rol     a                               ; 9E47 2A                       *
        rol     a                               ; 9E48 2A                       *
        rol     a                               ; 9E49 2A                       *
        rol     a                               ; 9E4A 2A                       *
        rol     a                               ; 9E4B 2A                       *
        rol     a                               ; 9E4C 2A                       *
        rol     a                               ; 9E4D 2A                       *
        rol     a                               ; 9E4E 2A                       *
        rol     a                               ; 9E4F 2A                       *
        rol     a                               ; 9E50 2A                       *
        rol     a                               ; 9E51 2A                       *
        rol     a                               ; 9E52 2A                       *
        rol     a                               ; 9E53 2A                       *
        rol     a                               ; 9E54 2A                       *
        rol     a                               ; 9E55 2A                       *
        rol     a                               ; 9E56 2A                       *
        rol     a                               ; 9E57 2A                       *
        rol     a                               ; 9E58 2A                       *
        rol     a                               ; 9E59 2A                       *
        rol     a                               ; 9E5A 2A                       *
        rol     a                               ; 9E5B 2A                       *
        rol     a                               ; 9E5C 2A                       *
        rol     a                               ; 9E5D 2A                       *
        rol     a                               ; 9E5E 2A                       *
        rol     a                               ; 9E5F 2A                       *
        rol     a                               ; 9E60 2A                       *
        rol     a                               ; 9E61 2A                       *
        rol     a                               ; 9E62 2A                       *
        rol     a                               ; 9E63 2A                       *
        rol     a                               ; 9E64 2A                       *
        rol     a                               ; 9E65 2A                       *
        rol     a                               ; 9E66 2A                       *
        rol     a                               ; 9E67 2A                       *
        rol     a                               ; 9E68 2A                       *
        rol     a                               ; 9E69 2A                       *
        rol     a                               ; 9E6A 2A                       *
        rol     a                               ; 9E6B 2A                       *
        rol     a                               ; 9E6C 2A                       *
        rol     a                               ; 9E6D 2A                       *
        rol     a                               ; 9E6E 2A                       *
        rol     a                               ; 9E6F 2A                       *
        rol     a                               ; 9E70 2A                       *
        rol     a                               ; 9E71 2A                       *
        rol     a                               ; 9E72 2A                       *
        rol     a                               ; 9E73 2A                       *
        rol     a                               ; 9E74 2A                       *
        rol     a                               ; 9E75 2A                       *
        rol     a                               ; 9E76 2A                       *
        rol     a                               ; 9E77 2A                       *
        rol     a                               ; 9E78 2A                       *
        rol     a                               ; 9E79 2A                       *
        rol     a                               ; 9E7A 2A                       *
        rol     a                               ; 9E7B 2A                       *
        rol     a                               ; 9E7C 2A                       *
        rol     a                               ; 9E7D 2A                       *
        rol     a                               ; 9E7E 2A                       *
        rol     a                               ; 9E7F 2A                       *
        rol     a                               ; 9E80 2A                       *
        rol     a                               ; 9E81 2A                       *
        rol     a                               ; 9E82 2A                       *
        rol     a                               ; 9E83 2A                       *
        rol     a                               ; 9E84 2A                       *
        rol     a                               ; 9E85 2A                       *
        rol     a                               ; 9E86 2A                       *
        rol     a                               ; 9E87 2A                       *
        rol     a                               ; 9E88 2A                       *
        rol     a                               ; 9E89 2A                       *
        rol     a                               ; 9E8A 2A                       *
        rol     a                               ; 9E8B 2A                       *
        rol     a                               ; 9E8C 2A                       *
        rol     a                               ; 9E8D 2A                       *
        rol     a                               ; 9E8E 2A                       *
        rol     a                               ; 9E8F 2A                       *
        rol     a                               ; 9E90 2A                       *
        rol     a                               ; 9E91 2A                       *
        rol     a                               ; 9E92 2A                       *
        rol     a                               ; 9E93 2A                       *
        rol     a                               ; 9E94 2A                       *
        rol     a                               ; 9E95 2A                       *
        rol     a                               ; 9E96 2A                       *
        rol     a                               ; 9E97 2A                       *
        rol     a                               ; 9E98 2A                       *
        rol     a                               ; 9E99 2A                       *
        rol     a                               ; 9E9A 2A                       *
        rol     a                               ; 9E9B 2A                       *
        rol     a                               ; 9E9C 2A                       *
        rol     a                               ; 9E9D 2A                       *
        rol     a                               ; 9E9E 2A                       *
        rol     a                               ; 9E9F 2A                       *
        rol     a                               ; 9EA0 2A                       *
        rol     a                               ; 9EA1 2A                       *
        rol     a                               ; 9EA2 2A                       *
        rol     a                               ; 9EA3 2A                       *
        rol     a                               ; 9EA4 2A                       *
        rol     a                               ; 9EA5 2A                       *
        rol     a                               ; 9EA6 2A                       *
        rol     a                               ; 9EA7 2A                       *
        rol     a                               ; 9EA8 2A                       *
        rol     a                               ; 9EA9 2A                       *
        rol     a                               ; 9EAA 2A                       *
        rol     a                               ; 9EAB 2A                       *
        rol     a                               ; 9EAC 2A                       *
        rol     a                               ; 9EAD 2A                       *
        rol     a                               ; 9EAE 2A                       *
        rol     a                               ; 9EAF 2A                       *
        rol     a                               ; 9EB0 2A                       *
        rol     a                               ; 9EB1 2A                       *
        rol     a                               ; 9EB2 2A                       *
        rol     a                               ; 9EB3 2A                       *
        rol     a                               ; 9EB4 2A                       *
        rol     a                               ; 9EB5 2A                       *
        rol     a                               ; 9EB6 2A                       *
        rol     a                               ; 9EB7 2A                       *
        rol     a                               ; 9EB8 2A                       *
        rol     a                               ; 9EB9 2A                       *
        rol     a                               ; 9EBA 2A                       *
        rol     a                               ; 9EBB 2A                       *
        rol     a                               ; 9EBC 2A                       *
        rol     a                               ; 9EBD 2A                       *
        rol     a                               ; 9EBE 2A                       *
        rol     a                               ; 9EBF 2A                       *
        rol     a                               ; 9EC0 2A                       *
        rol     a                               ; 9EC1 2A                       *
        rol     a                               ; 9EC2 2A                       *
        rol     a                               ; 9EC3 2A                       *
        rol     a                               ; 9EC4 2A                       *
        rol     a                               ; 9EC5 2A                       *
        rol     a                               ; 9EC6 2A                       *
        rol     a                               ; 9EC7 2A                       *
        rol     a                               ; 9EC8 2A                       *
        rol     a                               ; 9EC9 2A                       *
        rol     a                               ; 9ECA 2A                       *
        rol     a                               ; 9ECB 2A                       *
        rol     a                               ; 9ECC 2A                       *
        rol     a                               ; 9ECD 2A                       *
        rol     a                               ; 9ECE 2A                       *
        rol     a                               ; 9ECF 2A                       *
        rol     a                               ; 9ED0 2A                       *
        rol     a                               ; 9ED1 2A                       *
        rol     a                               ; 9ED2 2A                       *
        rol     a                               ; 9ED3 2A                       *
        rol     a                               ; 9ED4 2A                       *
        rol     a                               ; 9ED5 2A                       *
        rol     a                               ; 9ED6 2A                       *
        rol     a                               ; 9ED7 2A                       *
        rol     a                               ; 9ED8 2A                       *
        rol     a                               ; 9ED9 2A                       *
        rol     a                               ; 9EDA 2A                       *
        rol     a                               ; 9EDB 2A                       *
        rol     a                               ; 9EDC 2A                       *
        rol     a                               ; 9EDD 2A                       *
        rol     a                               ; 9EDE 2A                       *
        rol     a                               ; 9EDF 2A                       *
        rol     a                               ; 9EE0 2A                       *
        rol     a                               ; 9EE1 2A                       *
        rol     a                               ; 9EE2 2A                       *
        rol     a                               ; 9EE3 2A                       *
        rol     a                               ; 9EE4 2A                       *
        rol     a                               ; 9EE5 2A                       *
        rol     a                               ; 9EE6 2A                       *
        rol     a                               ; 9EE7 2A                       *
        rol     a                               ; 9EE8 2A                       *
        rol     a                               ; 9EE9 2A                       *
        rol     a                               ; 9EEA 2A                       *
        rol     a                               ; 9EEB 2A                       *
        rol     a                               ; 9EEC 2A                       *
        rol     a                               ; 9EED 2A                       *
        rol     a                               ; 9EEE 2A                       *
        rol     a                               ; 9EEF 2A                       *
        rol     a                               ; 9EF0 2A                       *
        rol     a                               ; 9EF1 2A                       *
        rol     a                               ; 9EF2 2A                       *
        rol     a                               ; 9EF3 2A                       *
        rol     a                               ; 9EF4 2A                       *
        rol     a                               ; 9EF5 2A                       *
        rol     a                               ; 9EF6 2A                       *
        rol     a                               ; 9EF7 2A                       *
        rol     a                               ; 9EF8 2A                       *
        rol     a                               ; 9EF9 2A                       *
        rol     a                               ; 9EFA 2A                       *
        rol     a                               ; 9EFB 2A                       *
        rol     a                               ; 9EFC 2A                       *
        rol     a                               ; 9EFD 2A                       *
        rol     a                               ; 9EFE 2A                       *
        rol     a                               ; 9EFF 2A                       *
        rol     a                               ; 9F00 2A                       *
L9F01:  rol     a                               ; 9F01 2A                       *
        rol     a                               ; 9F02 2A                       *
        rol     a                               ; 9F03 2A                       *
        rol     a                               ; 9F04 2A                       *
        rol     a                               ; 9F05 2A                       *
        rol     a                               ; 9F06 2A                       *
        rol     a                               ; 9F07 2A                       *
        rol     a                               ; 9F08 2A                       *
        rol     a                               ; 9F09 2A                       *
        rol     a                               ; 9F0A 2A                       *
        rol     a                               ; 9F0B 2A                       *
        rol     a                               ; 9F0C 2A                       *
        rol     a                               ; 9F0D 2A                       *
        rol     a                               ; 9F0E 2A                       *
        rol     a                               ; 9F0F 2A                       *
        rol     a                               ; 9F10 2A                       *
        rol     a                               ; 9F11 2A                       *
        rol     a                               ; 9F12 2A                       *
        rol     a                               ; 9F13 2A                       *
        rol     a                               ; 9F14 2A                       *
        rol     a                               ; 9F15 2A                       *
        rol     a                               ; 9F16 2A                       *
        rol     a                               ; 9F17 2A                       *
        rol     a                               ; 9F18 2A                       *
        rol     a                               ; 9F19 2A                       *
        rol     a                               ; 9F1A 2A                       *
        rol     a                               ; 9F1B 2A                       *
        rol     a                               ; 9F1C 2A                       *
        rol     a                               ; 9F1D 2A                       *
        rol     a                               ; 9F1E 2A                       *
        rol     a                               ; 9F1F 2A                       *
        rol     a                               ; 9F20 2A                       *
        rol     a                               ; 9F21 2A                       *
        rol     a                               ; 9F22 2A                       *
        rol     a                               ; 9F23 2A                       *
        rol     a                               ; 9F24 2A                       *
        rol     a                               ; 9F25 2A                       *
        rol     a                               ; 9F26 2A                       *
        rol     a                               ; 9F27 2A                       *
        rol     a                               ; 9F28 2A                       *
        rol     a                               ; 9F29 2A                       *
        rol     a                               ; 9F2A 2A                       *
        rol     a                               ; 9F2B 2A                       *
        rol     a                               ; 9F2C 2A                       *
        rol     a                               ; 9F2D 2A                       *
        rol     a                               ; 9F2E 2A                       *
        rol     a                               ; 9F2F 2A                       *
        rol     a                               ; 9F30 2A                       *
        rol     a                               ; 9F31 2A                       *
        rol     a                               ; 9F32 2A                       *
        rol     a                               ; 9F33 2A                       *
        rol     a                               ; 9F34 2A                       *
        rol     a                               ; 9F35 2A                       *
        rol     a                               ; 9F36 2A                       *
        rol     a                               ; 9F37 2A                       *
        rol     a                               ; 9F38 2A                       *
        rol     a                               ; 9F39 2A                       *
        rol     a                               ; 9F3A 2A                       *
        rol     a                               ; 9F3B 2A                       *
        rol     a                               ; 9F3C 2A                       *
        rol     a                               ; 9F3D 2A                       *
        rol     a                               ; 9F3E 2A                       *
        rol     a                               ; 9F3F 2A                       *
        rol     a                               ; 9F40 2A                       *
        rol     a                               ; 9F41 2A                       *
        rol     a                               ; 9F42 2A                       *
        rol     a                               ; 9F43 2A                       *
        rol     a                               ; 9F44 2A                       *
        rol     a                               ; 9F45 2A                       *
        rol     a                               ; 9F46 2A                       *
        rol     a                               ; 9F47 2A                       *
        rol     a                               ; 9F48 2A                       *
        rol     a                               ; 9F49 2A                       *
        rol     a                               ; 9F4A 2A                       *
        rol     a                               ; 9F4B 2A                       *
        rol     a                               ; 9F4C 2A                       *
        rol     a                               ; 9F4D 2A                       *
        rol     a                               ; 9F4E 2A                       *
        rol     a                               ; 9F4F 2A                       *
        rol     a                               ; 9F50 2A                       *
        rol     a                               ; 9F51 2A                       *
        rol     a                               ; 9F52 2A                       *
        rol     a                               ; 9F53 2A                       *
        rol     a                               ; 9F54 2A                       *
        rol     a                               ; 9F55 2A                       *
        rol     a                               ; 9F56 2A                       *
        rol     a                               ; 9F57 2A                       *
        rol     a                               ; 9F58 2A                       *
        rol     a                               ; 9F59 2A                       *
        rol     a                               ; 9F5A 2A                       *
        rol     a                               ; 9F5B 2A                       *
        rol     a                               ; 9F5C 2A                       *
        rol     a                               ; 9F5D 2A                       *
        rol     a                               ; 9F5E 2A                       *
        rol     a                               ; 9F5F 2A                       *
        rol     a                               ; 9F60 2A                       *
        rol     a                               ; 9F61 2A                       *
        rol     a                               ; 9F62 2A                       *
        rol     a                               ; 9F63 2A                       *
        rol     a                               ; 9F64 2A                       *
        rol     a                               ; 9F65 2A                       *
        rol     a                               ; 9F66 2A                       *
        rol     a                               ; 9F67 2A                       *
        rol     a                               ; 9F68 2A                       *
        rol     a                               ; 9F69 2A                       *
        rol     a                               ; 9F6A 2A                       *
        rol     a                               ; 9F6B 2A                       *
        rol     a                               ; 9F6C 2A                       *
        rol     a                               ; 9F6D 2A                       *
        rol     a                               ; 9F6E 2A                       *
        rol     a                               ; 9F6F 2A                       *
        rol     a                               ; 9F70 2A                       *
        rol     a                               ; 9F71 2A                       *
        rol     a                               ; 9F72 2A                       *
        rol     a                               ; 9F73 2A                       *
        rol     a                               ; 9F74 2A                       *
        rol     a                               ; 9F75 2A                       *
        rol     a                               ; 9F76 2A                       *
        rol     a                               ; 9F77 2A                       *
        rol     a                               ; 9F78 2A                       *
        rol     a                               ; 9F79 2A                       *
        rol     a                               ; 9F7A 2A                       *
        rol     a                               ; 9F7B 2A                       *
        rol     a                               ; 9F7C 2A                       *
        rol     a                               ; 9F7D 2A                       *
        rol     a                               ; 9F7E 2A                       *
        rol     a                               ; 9F7F 2A                       *
        rol     a                               ; 9F80 2A                       *
        rol     a                               ; 9F81 2A                       *
        rol     a                               ; 9F82 2A                       *
        rol     a                               ; 9F83 2A                       *
        rol     a                               ; 9F84 2A                       *
        rol     a                               ; 9F85 2A                       *
        rol     a                               ; 9F86 2A                       *
        rol     a                               ; 9F87 2A                       *
        rol     a                               ; 9F88 2A                       *
        rol     a                               ; 9F89 2A                       *
        rol     a                               ; 9F8A 2A                       *
        rol     a                               ; 9F8B 2A                       *
        rol     a                               ; 9F8C 2A                       *
        rol     a                               ; 9F8D 2A                       *
        rol     a                               ; 9F8E 2A                       *
        rol     a                               ; 9F8F 2A                       *
        rol     a                               ; 9F90 2A                       *
        rol     a                               ; 9F91 2A                       *
        rol     a                               ; 9F92 2A                       *
        rol     a                               ; 9F93 2A                       *
        rol     a                               ; 9F94 2A                       *
        rol     a                               ; 9F95 2A                       *
        rol     a                               ; 9F96 2A                       *
        rol     a                               ; 9F97 2A                       *
        rol     a                               ; 9F98 2A                       *
        rol     a                               ; 9F99 2A                       *
        rol     a                               ; 9F9A 2A                       *
        rol     a                               ; 9F9B 2A                       *
        rol     a                               ; 9F9C 2A                       *
        rol     a                               ; 9F9D 2A                       *
        rol     a                               ; 9F9E 2A                       *
        rol     a                               ; 9F9F 2A                       *
        rol     a                               ; 9FA0 2A                       *
        rol     a                               ; 9FA1 2A                       *
        rol     a                               ; 9FA2 2A                       *
        rol     a                               ; 9FA3 2A                       *
        rol     a                               ; 9FA4 2A                       *
        rol     a                               ; 9FA5 2A                       *
        rol     a                               ; 9FA6 2A                       *
        rol     a                               ; 9FA7 2A                       *
        rol     a                               ; 9FA8 2A                       *
        rol     a                               ; 9FA9 2A                       *
        rol     a                               ; 9FAA 2A                       *
        rol     a                               ; 9FAB 2A                       *
        rol     a                               ; 9FAC 2A                       *
        rol     a                               ; 9FAD 2A                       *
        rol     a                               ; 9FAE 2A                       *
        rol     a                               ; 9FAF 2A                       *
        rol     a                               ; 9FB0 2A                       *
        rol     a                               ; 9FB1 2A                       *
        rol     a                               ; 9FB2 2A                       *
        rol     a                               ; 9FB3 2A                       *
        rol     a                               ; 9FB4 2A                       *
        rol     a                               ; 9FB5 2A                       *
        rol     a                               ; 9FB6 2A                       *
        rol     a                               ; 9FB7 2A                       *
        rol     a                               ; 9FB8 2A                       *
        rol     a                               ; 9FB9 2A                       *
        rol     a                               ; 9FBA 2A                       *
        rol     a                               ; 9FBB 2A                       *
        rol     a                               ; 9FBC 2A                       *
        rol     a                               ; 9FBD 2A                       *
        rol     a                               ; 9FBE 2A                       *
        rol     a                               ; 9FBF 2A                       *
        rol     a                               ; 9FC0 2A                       *
        rol     a                               ; 9FC1 2A                       *
        rol     a                               ; 9FC2 2A                       *
        rol     a                               ; 9FC3 2A                       *
        rol     a                               ; 9FC4 2A                       *
        rol     a                               ; 9FC5 2A                       *
        rol     a                               ; 9FC6 2A                       *
        rol     a                               ; 9FC7 2A                       *
        rol     a                               ; 9FC8 2A                       *
        rol     a                               ; 9FC9 2A                       *
        rol     a                               ; 9FCA 2A                       *
        rol     a                               ; 9FCB 2A                       *
        rol     a                               ; 9FCC 2A                       *
        rol     a                               ; 9FCD 2A                       *
        rol     a                               ; 9FCE 2A                       *
        rol     a                               ; 9FCF 2A                       *
        rol     a                               ; 9FD0 2A                       *
        rol     a                               ; 9FD1 2A                       *
        rol     a                               ; 9FD2 2A                       *
        rol     a                               ; 9FD3 2A                       *
        rol     a                               ; 9FD4 2A                       *
        rol     a                               ; 9FD5 2A                       *
        rol     a                               ; 9FD6 2A                       *
        rol     a                               ; 9FD7 2A                       *
        rol     a                               ; 9FD8 2A                       *
        rol     a                               ; 9FD9 2A                       *
        rol     a                               ; 9FDA 2A                       *
        rol     a                               ; 9FDB 2A                       *
        rol     a                               ; 9FDC 2A                       *
        rol     a                               ; 9FDD 2A                       *
        rol     a                               ; 9FDE 2A                       *
        rol     a                               ; 9FDF 2A                       *
        rol     a                               ; 9FE0 2A                       *
        rol     a                               ; 9FE1 2A                       *
        rol     a                               ; 9FE2 2A                       *
        rol     a                               ; 9FE3 2A                       *
        rol     a                               ; 9FE4 2A                       *
        rol     a                               ; 9FE5 2A                       *
        rol     a                               ; 9FE6 2A                       *
        rol     a                               ; 9FE7 2A                       *
        rol     a                               ; 9FE8 2A                       *
        rol     a                               ; 9FE9 2A                       *
        rol     a                               ; 9FEA 2A                       *
        rol     a                               ; 9FEB 2A                       *
        rol     a                               ; 9FEC 2A                       *
        rol     a                               ; 9FED 2A                       *
        rol     a                               ; 9FEE 2A                       *
        rol     a                               ; 9FEF 2A                       *
        rol     a                               ; 9FF0 2A                       *
        rol     a                               ; 9FF1 2A                       *
        rol     a                               ; 9FF2 2A                       *
        rol     a                               ; 9FF3 2A                       *
        rol     a                               ; 9FF4 2A                       *
        rol     a                               ; 9FF5 2A                       *
        rol     a                               ; 9FF6 2A                       *
        rol     a                               ; 9FF7 2A                       *
        rol     a                               ; 9FF8 2A                       *
        rol     a                               ; 9FF9 2A                       *
        rol     a                               ; 9FFA 2A                       *
        rol     a                               ; 9FFB 2A                       *
        rol     a                               ; 9FFC 2A                       *
        rol     a                               ; 9FFD 2A                       *
        rol     a                               ; 9FFE 2A                       *
        rol     a                               ; 9FFF 2A                       *
