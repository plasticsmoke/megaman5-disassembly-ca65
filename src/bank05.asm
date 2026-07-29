.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK05"

; =============================================================================
; BANK $05 (mapped at $A000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
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
LE780           := $E780
LE968           := $E968
LEA65           := $EA65
LEA86           := $EA86
LEA98           := $EA98
LEAA4           := $EAA4
LEAE9           := $EAE9
LEC5D           := $EC5D
LEF87           := $EF87
LF05A           := $F05A
LF16F           := $F16F
LF2C4           := $F2C4
LF2FE           := $F2FE
LFD10           := $FD10
LFF10           := $FF10
LFFB7           := $FFB7
; ----------------------------------------------------------------------------
        jsr     LEF87                           ; A000 20 87 EF                  ..
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
        jsr     LEF87                           ; A035 20 87 EF                  ..
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
LA068:  jsr     LEC5D                           ; A068 20 5D EC                  ].
LA06B:  rts                                     ; A06B 60                       `

; ----------------------------------------------------------------------------
        rti                                     ; A06C 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; A06D 00                       .
        ora     (L0000,x)                       ; A06E 01 00                    ..
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
LA0BB:  jsr     LEA86                           ; A0BB 20 86 EA                  ..
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
        lda     #$FF                            ; A0E3 A9 FF                    ..
        sta     $74                             ; A0E5 85 74                    .t
        sta     $46                             ; A0E7 85 46                    .F
        lda     #$00                            ; A0E9 A9 00                    ..
        sta     $75                             ; A0EB 85 75                    .u
        sta     $76                             ; A0ED 85 76                    .v
        jsr     LEF87                           ; A0EF 20 87 EF                  ..
        bcs     LA140                           ; A0F2 B0 4C                    .L
        lda     #$00                            ; A0F4 A9 00                    ..
        sta     $FB                             ; A0F6 85 FB                    ..
        sta     $0360,x                         ; A0F8 9D 60 03                 .`.
        jsr     LFFB7                           ; A0FB 20 B7 FF                  ..
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
        jsr     LFFB7                           ; A182 20 B7 FF                  ..
        lda     #$8F                            ; A185 A9 8F                    ..
        sta     $0588,x                         ; A187 9D 88 05                 ...
        lda     #$A1                            ; A18A A9 A1                    ..
        sta     $05A0,x                         ; A18C 9D A0 05                 ...
LA18F:  rts                                     ; A18F 60                       `

; ----------------------------------------------------------------------------
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
        jsr     LEA98                           ; A1AF 20 98 EA                  ..
LA1B2:  lda     $0528,x                         ; A1B2 BD 28 05                 .(.
        and     #$04                            ; A1B5 29 04                    ).
        bne     LA1D1                           ; A1B7 D0 18                    ..
        jsr     LE968                           ; A1B9 20 68 E9                  h.
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
        .byte   $90                             ; A1EA 90                       .
LA1EB:  and     #$BD                            ; A1EB 29 BD                    ).
        .byte   $80                             ; A1ED 80                       .
        .byte   $04                             ; A1EE 04                       .
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
        jsr     LF2C4                           ; A212 20 C4 F2                  ..
LA215:  rts                                     ; A215 60                       `

; ----------------------------------------------------------------------------
        lda     $0540,x                         ; A216 BD 40 05                 .@.
        cmp     #$04                            ; A219 C9 04                    ..
        bne     LA275                           ; A21B D0 58                    .X
        lda     #$64                            ; A21D A9 64                    .d
        jsr     LEA98                           ; A21F 20 98 EA                  ..
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
        jsr     LE780                           ; A244 20 80 E7                  ..
        bcs     LA276                           ; A247 B0 2D                    .-
        lda     #$64                            ; A249 A9 64                    .d
        sta     L0010                           ; A24B 85 10                    ..
        dec     $0378,x                         ; A24D DE 78 03                 .x.
        jsr     LEF87                           ; A250 20 87 EF                  ..
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
        jsr     LEA98                           ; A272 20 98 EA                  ..
LA275:  rts                                     ; A275 60                       `

; ----------------------------------------------------------------------------
LA276:  lda     #$84                            ; A276 A9 84                    ..
        jsr     LEA98                           ; A278 20 98 EA                  ..
        jsr     LF2C4                           ; A27B 20 C4 F2                  ..
        lda     #$01                            ; A27E A9 01                    ..
        sta     $0300,x                         ; A280 9D 00 03                 ...
        rts                                     ; A283 60                       `

; ----------------------------------------------------------------------------
        lda     $0540,x                         ; A284 BD 40 05                 .@.
        bne     LA275                           ; A287 D0 EC                    ..
        lda     #$66                            ; A289 A9 66                    .f
        jsr     LEA98                           ; A28B 20 98 EA                  ..
        lda     $0378,x                         ; A28E BD 78 03                 .x.
        sec                                     ; A291 38                       8
        sbc     #$04                            ; A292 E9 04                    ..
        sta     $0378,x                         ; A294 9D 78 03                 .x.
        lda     #$00                            ; A297 A9 00                    ..
        sta     $03D8,x                         ; A299 9D D8 03                 ...
        lda     #$01                            ; A29C A9 01                    ..
        sta     $03F0,x                         ; A29E 9D F0 03                 ...
        .byte   $FE                             ; A2A1 FE                       .
LA2A2:  plp                                     ; A2A2 28                       (
        ora     $A9                             ; A2A3 05 A9                    ..
        ldx     $889D                           ; A2A5 AE 9D 88                 ...
        ora     $A9                             ; A2A8 05 A9                    ..
        ldx     #$9D                            ; A2AA A2 9D                    ..
        ldy     #$05                            ; A2AC A0 05                    ..
        ldy     #$14                            ; A2AE A0 14                    ..
        jsr     LE780                           ; A2B0 20 80 E7                  ..
        lda     L0010                           ; A2B3 A5 10                    ..
        and     #$10                            ; A2B5 29 10                    ).
        bne     LA2DC                           ; A2B7 D0 23                    .#
        lda     $0468,x                         ; A2B9 BD 68 04                 .h.
        bne     LA2D7                           ; A2BC D0 19                    ..
        jsr     LEF87                           ; A2BE 20 87 EF                  ..
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
LA2DC:  jsr     LF2C4                           ; A2DC 20 C4 F2                  ..
        lda     #$5D                            ; A2DF A9 5D                    .]
        jsr     LEA98                           ; A2E1 20 98 EA                  ..
        lda     #$01                            ; A2E4 A9 01                    ..
        sta     $0300,x                         ; A2E6 9D 00 03                 ...
LA2E9:  rts                                     ; A2E9 60                       `

; ----------------------------------------------------------------------------
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
        jsr     LF16F                           ; A306 20 6F F1                  o.
        bcs     LA357                           ; A309 B0 4C                    .L
        sty     $0F                             ; A30B 84 0F                    ..
        ldy     $0480,x                         ; A30D BC 80 04                 ...
        sty     $0E                             ; A310 84 0E                    ..
        lda     LA360,y                         ; A312 B9 60 A3                 .`.
        ldy     $0F                             ; A315 A4 0F                    ..
        jsr     LEAA4                           ; A317 20 A4 EA                  ..
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
LA360:  adc     $63                             ; A360 65 63                    ec
        adc     $65                             ; A362 65 65                    ee
        .byte   $63                             ; A364 63                       c
LA365:  inx                                     ; A365 E8                       .
        clv                                     ; A366 B8                       .
        dey                                     ; A367 88                       .
        cli                                     ; A368 58                       X
        plp                                     ; A369 28                       (
LA36A:  ora     L0000                           ; A36A 05 00                    ..
        ora     $05                             ; A36C 05 05                    ..
        brk                                     ; A36E 00                       .
LA36F:  sty     $16                             ; A36F 84 16                    ..
LA371:  sty     $84                             ; A371 84 84                    ..
        .byte   $16                             ; A373 16                       .
LA374:  ldx     #$A2                            ; A374 A2 A2                    ..
        ldx     #$A2                            ; A376 A2 A2                    ..
        ldx     #$00                            ; A378 A2 00                    ..
        .byte   $02                             ; A37A 02                       .
        .byte   $02                             ; A37B 02                       .
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
        jsr     LEA86                           ; A3D8 20 86 EA                  ..
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
        lda     $30                             ; A4AC A5 30                    .0
        bne     LA51A                           ; A4AE D0 6A                    .j
        lda     #$F1                            ; A4B0 A9 F1                    ..
        jsr     LEC5D                           ; A4B2 20 5D EC                  ].
        lda     #$0D                            ; A4B5 A9 0D                    ..
        sta     $30                             ; A4B7 85 30                    .0
        ldy     #$04                            ; A4B9 A0 04                    ..
LA4BB:  jsr     LF2FE                           ; A4BB 20 FE F2                  ..
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
        jsr     LEF87                           ; A4F3 20 87 EF                  ..
        bcs     LA51A                           ; A4F6 B0 22                    ."
        ldy     #$00                            ; A4F8 A0 00                    ..
        lda     #$1D                            ; A4FA A9 1D                    ..
        jsr     LEAE9                           ; A4FC 20 E9 EA                  ..
        lda     $0330,x                         ; A4FF BD 30 03                 .0.
        sta     $0330                           ; A502 8D 30 03                 .0.
        lda     $0348,x                         ; A505 BD 48 03                 .H.
        sta     $0348                           ; A508 8D 48 03                 .H.
        lda     $0378,x                         ; A50B BD 78 03                 .x.
        sta     $0378                           ; A50E 8D 78 03                 .x.
        lda     $0390,x                         ; A511 BD 90 03                 ...
        sta     $0390                           ; A514 8D 90 03                 ...
        jsr     LF2C4                           ; A517 20 C4 F2                  ..
LA51A:  rts                                     ; A51A 60                       `

; ----------------------------------------------------------------------------
LA51B:  .byte   $0F                             ; A51B 0F                       .
        .byte   $0F                             ; A51C 0F                       .
        bit     LBD11                           ; A51D 2C 11 BD                 ,..
        sei                                     ; A520 78                       x
        .byte   $03                             ; A521 03                       .
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
        jsr     LEA65                           ; A5B3 20 65 EA                  e.
        jsr     LEA86                           ; A5B6 20 86 EA                  ..
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
        jsr     LEA98                           ; A5D7 20 98 EA                  ..
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
        jsr     LEA65                           ; A64E 20 65 EA                  e.
        jsr     LEA86                           ; A651 20 86 EA                  ..
        lda     #$B8                            ; A654 A9 B8                    ..
        jsr     LEA98                           ; A656 20 98 EA                  ..
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
        jsr     LEA98                           ; A684 20 98 EA                  ..
        lda     #$BB                            ; A687 A9 BB                    ..
        sta     $0588,x                         ; A689 9D 88 05                 ...
        lda     #$A6                            ; A68C A9 A6                    ..
        sta     $05A0,x                         ; A68E 9D A0 05                 ...
        bne     LA6BB                           ; A691 D0 28                    .(
LA693:  lda     $0540,x                         ; A693 BD 40 05                 .@.
        cmp     #$02                            ; A696 C9 02                    ..
        bne     LA69F                           ; A698 D0 05                    ..
        lda     #$00                            ; A69A A9 00                    ..
        jsr     LEA98                           ; A69C 20 98 EA                  ..
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
LA77D:  .byte   $02                             ; A77D 02                       .
LA77E:  php                                     ; A77E 08                       .
        ora     #$01                            ; A77F 09 01                    ..
        .byte   $02                             ; A781 02                       .
        php                                     ; A782 08                       .
        asl     $01                             ; A783 06 01                    ..
        ora     ($08,x)                         ; A785 01 08                    ..
        ora     $01                             ; A787 05 01                    ..
        .byte   $03                             ; A789 03                       .
        php                                     ; A78A 08                       .
        .byte   $02                             ; A78B 02                       .
        ora     ($02,x)                         ; A78C 01 02                    ..
        .byte   $04                             ; A78E 04                       .
        ora     $0401                           ; A78F 0D 01 04                 ...
        .byte   $04                             ; A792 04                       .
        .byte   $07                             ; A793 07                       .
LA794:  ora     ($04,x)                         ; A794 01 04                    ..
        php                                     ; A796 08                       .
        .byte   $02                             ; A797 02                       .
        ora     ($04,x)                         ; A798 01 04                    ..
        .byte   $04                             ; A79A 04                       .
        .byte   $07                             ; A79B 07                       .
        ora     ($04,x)                         ; A79C 01 04                    ..
        php                                     ; A79E 08                       .
        asl     a                               ; A79F 0A                       .
        ora     (L0000,x)                       ; A7A0 01 00                    ..
        brk                                     ; A7A2 00                       .
        .byte   $02                             ; A7A3 02                       .
        php                                     ; A7A4 08                       .
        ora     $01                             ; A7A5 05 01                    ..
        .byte   $02                             ; A7A7 02                       .
        php                                     ; A7A8 08                       .
        php                                     ; A7A9 08                       .
        ora     ($02,x)                         ; A7AA 01 02                    ..
        .byte   $04                             ; A7AC 04                       .
        .byte   $03                             ; A7AD 03                       .
        ora     ($01,x)                         ; A7AE 01 01                    ..
        php                                     ; A7B0 08                       .
        .byte   $02                             ; A7B1 02                       .
        ora     ($03,x)                         ; A7B2 01 03                    ..
        php                                     ; A7B4 08                       .
        .byte   $03                             ; A7B5 03                       .
        ora     ($02,x)                         ; A7B6 01 02                    ..
        .byte   $04                             ; A7B8 04                       .
        .byte   $04                             ; A7B9 04                       .
        ora     ($02,x)                         ; A7BA 01 02                    ..
        php                                     ; A7BC 08                       .
        .byte   $02                             ; A7BD 02                       .
        ora     ($01,x)                         ; A7BE 01 01                    ..
        .byte   $04                             ; A7C0 04                       .
        .byte   $01                             ; A7C1 01                       .
LA7C2:  ora     ($03,x)                         ; A7C2 01 03                    ..
        php                                     ; A7C4 08                       .
        .byte   $03                             ; A7C5 03                       .
        ora     ($02,x)                         ; A7C6 01 02                    ..
        .byte   $04                             ; A7C8 04                       .
        ora     ($01,x)                         ; A7C9 01 01                    ..
        .byte   $07                             ; A7CB 07                       .
        .byte   $04                             ; A7CC 04                       .
        brk                                     ; A7CD 00                       .
        brk                                     ; A7CE 00                       .
LA7CF:  brk                                     ; A7CF 00                       .
        ora     ($02,x)                         ; A7D0 01 02                    ..
        .byte   $03                             ; A7D2 03                       .
        ora     L0006                           ; A7D3 05 06                    ..
        .byte   $07                             ; A7D5 07                       .
        php                                     ; A7D6 08                       .
        .byte   $0E                             ; A7D7 0E                       .
LA7D8:  brk                                     ; A7D8 00                       .
        ora     ($02,x)                         ; A7D9 01 02                    ..
        .byte   $04                             ; A7DB 04                       .
        ora     L0006                           ; A7DC 05 06                    ..
        .byte   $07                             ; A7DE 07                       .
        ora     #$0A                            ; A7DF 09 0A                    ..
        .byte   $0B                             ; A7E1 0B                       .
        .byte   $0C                             ; A7E2 0C                       .
        ora     $F70E                           ; A7E3 0D 0E F7                 ...
        .byte   $FF                             ; A7E6 FF                       .
        cmp     $3F,x                           ; A7E7 D5 3F                    .?
        .byte   $F7                             ; A7E9 F7                       .
        .byte   $BB                             ; A7EA BB                       .
        eor     $15EF,y                         ; A7EB 59 EF 15                 Y..
        .byte   $F7                             ; A7EE F7                       .
        adc     $35AF,x                         ; A7EF 7D AF 35                 }.5
        .byte   $4F                             ; A7F2 4F                       O
        adc     $7E,x                           ; A7F3 75 7E                    u~
        .byte   $D7                             ; A7F5 D7                       .
        .byte   $F7                             ; A7F6 F7                       .
        dec     $BD                             ; A7F7 C6 BD                    ..
        .byte   $E7                             ; A7F9 E7                       .
        .byte   $FF                             ; A7FA FF                       .
        .byte   $72                             ; A7FB 72                       r
        .byte   $FB                             ; A7FC FB                       .
        bit     $FB                             ; A7FD 24 FB                    $.
        .byte   $34                             ; A7FF 34                       4
        brk                                     ; A800 00                       .
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
        .byte   $02                             ; A810 02                       .
        .byte   $03                             ; A811 03                       .
        ora     ($01,x)                         ; A812 01 01                    ..
        ora     ($01,x)                         ; A814 01 01                    ..
        ora     ($02,x)                         ; A816 01 02                    ..
        .byte   $02                             ; A818 02                       .
        brk                                     ; A819 00                       .
        ora     ($03,x)                         ; A81A 01 03                    ..
        ora     ($01,x)                         ; A81C 01 01                    ..
        brk                                     ; A81E 00                       .
        brk                                     ; A81F 00                       .
        .byte   $03                             ; A820 03                       .
        .byte   $02                             ; A821 02                       .
        brk                                     ; A822 00                       .
        brk                                     ; A823 00                       .
        brk                                     ; A824 00                       .
        .byte   $03                             ; A825 03                       .
        brk                                     ; A826 00                       .
        brk                                     ; A827 00                       .
        .byte   $03                             ; A828 03                       .
        .byte   $03                             ; A829 03                       .
        ora     ($03,x)                         ; A82A 01 03                    ..
        brk                                     ; A82C 00                       .
        brk                                     ; A82D 00                       .
        brk                                     ; A82E 00                       .
        brk                                     ; A82F 00                       .
        brk                                     ; A830 00                       .
        .byte   $03                             ; A831 03                       .
        ora     ($02,x)                         ; A832 01 02                    ..
        ora     (L0000,x)                       ; A834 01 00                    ..
        .byte   $02                             ; A836 02                       .
        brk                                     ; A837 00                       .
        brk                                     ; A838 00                       .
        ora     ($03,x)                         ; A839 01 03                    ..
        .byte   $03                             ; A83B 03                       .
        brk                                     ; A83C 00                       .
        brk                                     ; A83D 00                       .
        .byte   $03                             ; A83E 03                       .
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
        ora     ($01,x)                         ; A84F 01 01                    ..
        brk                                     ; A851 00                       .
        ora     ($01,x)                         ; A852 01 01                    ..
        ora     (L0000,x)                       ; A854 01 00                    ..
        ora     (L0000,x)                       ; A856 01 00                    ..
        brk                                     ; A858 00                       .
        .byte   $03                             ; A859 03                       .
        ora     (L0000,x)                       ; A85A 01 00                    ..
        ora     ($02,x)                         ; A85C 01 02                    ..
        brk                                     ; A85E 00                       .
        brk                                     ; A85F 00                       .
        ora     (L0000,x)                       ; A860 01 00                    ..
        ora     ($01,x)                         ; A862 01 01                    ..
        ora     ($01,x)                         ; A864 01 01                    ..
        .byte   $02                             ; A866 02                       .
        ora     ($01,x)                         ; A867 01 01                    ..
        ora     (L0000,x)                       ; A869 01 00                    ..
        ora     (L0000,x)                       ; A86B 01 00                    ..
        brk                                     ; A86D 00                       .
        ora     (L0000,x)                       ; A86E 01 00                    ..
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
        ora     ($01,x)                         ; A87B 01 01                    ..
        brk                                     ; A87D 00                       .
        brk                                     ; A87E 00                       .
        brk                                     ; A87F 00                       .
        brk                                     ; A880 00                       .
        ora     (L0000,x)                       ; A881 01 00                    ..
        ora     (L0000,x)                       ; A883 01 00                    ..
        brk                                     ; A885 00                       .
        ora     (L0000,x)                       ; A886 01 00                    ..
        brk                                     ; A888 00                       .
        ora     (L0000,x)                       ; A889 01 00                    ..
        brk                                     ; A88B 00                       .
        brk                                     ; A88C 00                       .
        ora     (L0000,x)                       ; A88D 01 00                    ..
        brk                                     ; A88F 00                       .
        brk                                     ; A890 00                       .
        .byte   $02                             ; A891 02                       .
        brk                                     ; A892 00                       .
        .byte   $02                             ; A893 02                       .
        brk                                     ; A894 00                       .
        brk                                     ; A895 00                       .
        ora     (L0000,x)                       ; A896 01 00                    ..
        ora     (L0000,x)                       ; A898 01 00                    ..
        brk                                     ; A89A 00                       .
        brk                                     ; A89B 00                       .
        ora     (L0000,x)                       ; A89C 01 00                    ..
        ora     (L0000,x)                       ; A89E 01 00                    ..
        ora     (L0000,x)                       ; A8A0 01 00                    ..
        brk                                     ; A8A2 00                       .
        brk                                     ; A8A3 00                       .
        brk                                     ; A8A4 00                       .
        .byte   $04                             ; A8A5 04                       .
        brk                                     ; A8A6 00                       .
        brk                                     ; A8A7 00                       .
        brk                                     ; A8A8 00                       .
        brk                                     ; A8A9 00                       .
        ora     (L0000,x)                       ; A8AA 01 00                    ..
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
        .byte   $03                             ; A8BD 03                       .
        .byte   $02                             ; A8BE 02                       .
        brk                                     ; A8BF 00                       .
        brk                                     ; A8C0 00                       .
        brk                                     ; A8C1 00                       .
        brk                                     ; A8C2 00                       .
        brk                                     ; A8C3 00                       .
        ora     (L0000,x)                       ; A8C4 01 00                    ..
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
        brk                                     ; A900 00                       .
        ora     ($02,x)                         ; A901 01 02                    ..
        .byte   $03                             ; A903 03                       .
        .byte   $04                             ; A904 04                       .
        ora     L0006                           ; A905 05 06                    ..
        .byte   $07                             ; A907 07                       .
        php                                     ; A908 08                       .
        ora     #$0A                            ; A909 09 0A                    ..
        .byte   $0B                             ; A90B 0B                       .
        .byte   $0C                             ; A90C 0C                       .
        ora     $0F0E                           ; A90D 0D 0E 0F                 ...
        bpl     LA923                           ; A910 10 11                    ..
        .byte   $12                             ; A912 12                       .
        .byte   $13                             ; A913 13                       .
        .byte   $14                             ; A914 14                       .
LA915:  ora     $16,x                           ; A915 15 16                    ..
        .byte   $17                             ; A917 17                       .
        clc                                     ; A918 18                       .
        ora     $1B1A,y                         ; A919 19 1A 1B                 ...
        .byte   $1C                             ; A91C 1C                       .
        brk                                     ; A91D 00                       .
        ldy     #$45                            ; A91E A0 45                    .E
        brk                                     ; A920 00                       .
        brk                                     ; A921 00                       .
        .byte   $80                             ; A922 80                       .
LA923:  brk                                     ; A923 00                       .
        jsr     L8004                           ; A924 20 04 80                  ..
        bpl     LA92B                           ; A927 10 02                    ..
        ldy     #$80                            ; A929 A0 80                    ..
LA92B:  .byte   $44                             ; A92B 44                       D
        plp                                     ; A92C 28                       (
        .byte   $64                             ; A92D 64                       d
        asl     a                               ; A92E 0A                       .
        brk                                     ; A92F 00                       .
        brk                                     ; A930 00                       .
        brk                                     ; A931 00                       .
        jsr     L2080                           ; A932 20 80 20                  . 
        .byte   $42                             ; A935 42                       B
        brk                                     ; A936 00                       .
        cpy     L0000                           ; A937 C4 00                    ..
        brk                                     ; A939 00                       .
        brk                                     ; A93A 00                       .
        brk                                     ; A93B 00                       .
        .byte   $80                             ; A93C 80                       .
        .byte   $34                             ; A93D 34                       4
        jsr     L0080                           ; A93E 20 80 00                  ..
        asl     a                               ; A941 0A                       .
        brk                                     ; A942 00                       .
        clc                                     ; A943 18                       .
        php                                     ; A944 08                       .
        brk                                     ; A945 00                       .
        brk                                     ; A946 00                       .
        .byte   $02                             ; A947 02                       .
        brk                                     ; A948 00                       .
        brk                                     ; A949 00                       .
        brk                                     ; A94A 00                       .
        ora     (L0000,x)                       ; A94B 01 00                    ..
        brk                                     ; A94D 00                       .
        brk                                     ; A94E 00                       .
        rti                                     ; A94F 40                       @

; ----------------------------------------------------------------------------
        .byte   $23                             ; A950 23                       #
        ldy     #$25                            ; A951 A0 25                    .%
        .byte   $67                             ; A953 67                       g
        ldy     #$25                            ; A954 A0 25                    .%
        rts                                     ; A956 60                       `

; ----------------------------------------------------------------------------
        jsr     L0020                           ; A957 20 20 00                   .
        rol     a                               ; A95A 2A                       *
        jsr     L8000                           ; A95B 20 00 80                  ..
        brk                                     ; A95E 00                       .
        .byte   $02                             ; A95F 02                       .
        jsr     L0000                           ; A960 20 00 00                  ..
        .byte   $04                             ; A963 04                       .
        jsr     L800A                           ; A964 20 0A 80                  ..
        rti                                     ; A967 40                       @

; ----------------------------------------------------------------------------
        sec                                     ; A968 38                       8
        ora     $210D,y                         ; A969 19 0D 21                 ..!
        and     $1A0E                           ; A96C 2D 0E 1A                 -..
        .byte   $80                             ; A96F 80                       .
        clv                                     ; A970 B8                       .
        brk                                     ; A971 00                       .
        brk                                     ; A972 00                       .
        .byte   $72                             ; A973 72                       r
        .byte   $22                             ; A974 22                       "
        ora     L0000,y                         ; A975 19 00 00                 ...
        jsr     L0098                           ; A978 20 98 00                  ..
        .byte   $22                             ; A97B 22                       "
        brk                                     ; A97C 00                       .
        bpl     LA981                           ; A97D 10 02                    ..
        bpl     LA915                           ; A97F 10 94                    ..
LA981:  stx     L0000,y                         ; A981 96 00                    ..
        brk                                     ; A983 00                       .
        brk                                     ; A984 00                       .
        ora     (L0000,x)                       ; A985 01 00                    ..
        bvc     LA998                           ; A987 50 0F                    P.
        jsr     L0111                           ; A989 20 11 01                  ..
        .byte   $0F                             ; A98C 0F                       .
        jsr     L0010                           ; A98D 20 10 00                  ..
        .byte   $0F                             ; A990 0F                       .
        .byte   $23                             ; A991 23                       #
        .byte   $13                             ; A992 13                       .
        .byte   $03                             ; A993 03                       .
        .byte   $0F                             ; A994 0F                       .
        .byte   $2B                             ; A995 2B                       +
        .byte   $1B                             ; A996 1B                       .
        .byte   $0B                             ; A997 0B                       .
LA998:  brk                                     ; A998 00                       .
        brk                                     ; A999 00                       .
        brk                                     ; A99A 00                       .
        brk                                     ; A99B 00                       .
        .byte   $0F                             ; A99C 0F                       .
        jsr     L0111                           ; A99D 20 11 01                  ..
        .byte   $0F                             ; A9A0 0F                       .
        jsr     L0010                           ; A9A1 20 10 00                  ..
        .byte   $0F                             ; A9A4 0F                       .
        rol     a                               ; A9A5 2A                       *
        .byte   $1A                             ; A9A6 1A                       .
        asl     a                               ; A9A7 0A                       .
        .byte   $0F                             ; A9A8 0F                       .
        jsr     L1727                           ; A9A9 20 27 17                  '.
        brk                                     ; A9AC 00                       .
        brk                                     ; A9AD 00                       .
        brk                                     ; A9AE 00                       .
        brk                                     ; A9AF 00                       .
        .byte   $0F                             ; A9B0 0F                       .
        jsr     L0111                           ; A9B1 20 11 01                  ..
        .byte   $0F                             ; A9B4 0F                       .
        jsr     L0010                           ; A9B5 20 10 00                  ..
        .byte   $0F                             ; A9B8 0F                       .
        rol     $16                             ; A9B9 26 16                    &.
        asl     $0F                             ; A9BB 06 0F                    ..
        jsr     L1727                           ; A9BD 20 27 17                  '.
        brk                                     ; A9C0 00                       .
        brk                                     ; A9C1 00                       .
        brk                                     ; A9C2 00                       .
        brk                                     ; A9C3 00                       .
        brk                                     ; A9C4 00                       .
        brk                                     ; A9C5 00                       .
        brk                                     ; A9C6 00                       .
        brk                                     ; A9C7 00                       .
        brk                                     ; A9C8 00                       .
        .byte   $04                             ; A9C9 04                       .
        .byte   $02                             ; A9CA 02                       .
        brk                                     ; A9CB 00                       .
        brk                                     ; A9CC 00                       .
        .byte   $02                             ; A9CD 02                       .
        brk                                     ; A9CE 00                       .
        bpl     LA9D1                           ; A9CF 10 00                    ..
LA9D1:  pha                                     ; A9D1 48                       H
        .byte   $80                             ; A9D2 80                       .
        rti                                     ; A9D3 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; A9D4 00                       .
        brk                                     ; A9D5 00                       .
        brk                                     ; A9D6 00                       .
        brk                                     ; A9D7 00                       .
        dey                                     ; A9D8 88                       .
        .byte   $04                             ; A9D9 04                       .
        .byte   $80                             ; A9DA 80                       .
        bpl     LA9FD                           ; A9DB 10 20                    . 
        .byte   $80                             ; A9DD 80                       .
        jsr     LFF10                           ; A9DE 20 10 FF                  ..
        brk                                     ; A9E1 00                       .
        php                                     ; A9E2 08                       .
        brk                                     ; A9E3 00                       .
        .byte   $02                             ; A9E4 02                       .
        .byte   $44                             ; A9E5 44                       D
        brk                                     ; A9E6 00                       .
        .byte   $44                             ; A9E7 44                       D
        brk                                     ; A9E8 00                       .
        brk                                     ; A9E9 00                       .
        brk                                     ; A9EA 00                       .
        php                                     ; A9EB 08                       .
        brk                                     ; A9EC 00                       .
        .byte   $02                             ; A9ED 02                       .
        .byte   $80                             ; A9EE 80                       .
        php                                     ; A9EF 08                       .
        brk                                     ; A9F0 00                       .
        .byte   $62                             ; A9F1 62                       b
        .byte   $02                             ; A9F2 02                       .
        php                                     ; A9F3 08                       .
        brk                                     ; A9F4 00                       .
        sty     L0020                           ; A9F5 84 20                    . 
        brk                                     ; A9F7 00                       .
        .byte   $80                             ; A9F8 80                       .
        ldy     #$88                            ; A9F9 A0 88                    ..
        brk                                     ; A9FB 00                       .
        brk                                     ; A9FC 00                       .
LA9FD:  brk                                     ; A9FD 00                       .
        .byte   $02                             ; A9FE 02                       .
        brk                                     ; A9FF 00                       .
        ora     ($02,x)                         ; AA00 01 02                    ..
        .byte   $02                             ; AA02 02                       .
        .byte   $03                             ; AA03 03                       .
        .byte   $03                             ; AA04 03                       .
        .byte   $03                             ; AA05 03                       .
        .byte   $03                             ; AA06 03                       .
        .byte   $03                             ; AA07 03                       .
        ora     $05                             ; AA08 05 05                    ..
        asl     $07                             ; AA0A 06 07                    ..
        .byte   $07                             ; AA0C 07                       .
        .byte   $07                             ; AA0D 07                       .
        .byte   $07                             ; AA0E 07                       .
        php                                     ; AA0F 08                       .
        php                                     ; AA10 08                       .
        ora     #$0A                            ; AA11 09 0A                    ..
        asl     a                               ; AA13 0A                       .
        asl     a                               ; AA14 0A                       .
        .byte   $0C                             ; AA15 0C                       .
        .byte   $0C                             ; AA16 0C                       .
LAA17:  ora     $0E0D                           ; AA17 0D 0D 0E                 ...
        asl     $0F0F                           ; AA1A 0E 0F 0F                 ...
        bpl     LAA2F                           ; AA1D 10 10                    ..
        ora     ($11),y                         ; AA1F 11 11                    ..
        ora     ($11),y                         ; AA21 11 11                    ..
        .byte   $12                             ; AA23 12                       .
        .byte   $12                             ; AA24 12                       .
        .byte   $12                             ; AA25 12                       .
        .byte   $12                             ; AA26 12                       .
        .byte   $14                             ; AA27 14                       .
        .byte   $14                             ; AA28 14                       .
        ora     $16,x                           ; AA29 15 16                    ..
        asl     $16,x                           ; AA2B 16 16                    ..
        .byte   $17                             ; AA2D 17                       .
        .byte   $17                             ; AA2E 17                       .
LAA2F:  clc                                     ; AA2F 18                       .
        ora     $1919,y                         ; AA30 19 19 19                 ...
        ora     $1C1A,y                         ; AA33 19 1A 1C                 ...
        .byte   $FF                             ; AA36 FF                       .
        rti                                     ; AA37 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AA38 00                       .
        brk                                     ; AA39 00                       .
LAA3A:  .byte   $02                             ; AA3A 02                       .
        .byte   $90                             ; AA3B 90                       .
LAA3C:  brk                                     ; AA3C 00                       .
LAA3D:  .byte   $44                             ; AA3D 44                       D
        brk                                     ; AA3E 00                       .
        sta     L0020                           ; AA3F 85 20                    . 
        bpl     LAA43                           ; AA41 10 00                    ..
LAA43:  ora     (L0000,x)                       ; AA43 01 00                    ..
        bpl     LAA47                           ; AA45 10 00                    ..
LAA47:  brk                                     ; AA47 00                       .
        brk                                     ; AA48 00                       .
        .byte   $44                             ; AA49 44                       D
        brk                                     ; AA4A 00                       .
        rti                                     ; AA4B 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AA4C 00                       .
        bpl     LAA4F                           ; AA4D 10 00                    ..
LAA4F:  .byte   $80                             ; AA4F 80                       .
        brk                                     ; AA50 00                       .
        eor     (L0000,x)                       ; AA51 41 00                    A.
        .byte   $14                             ; AA53 14                       .
        brk                                     ; AA54 00                       .
        rti                                     ; AA55 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AA56 00                       .
        bpl     LAA59                           ; AA57 10 00                    ..
LAA59:  ora     L0000                           ; AA59 05 00                    ..
        brk                                     ; AA5B 00                       .
        plp                                     ; AA5C 28                       (
        rti                                     ; AA5D 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AA5E 00                       .
        .byte   $04                             ; AA5F 04                       .
        brk                                     ; AA60 00                       .
        .byte   $44                             ; AA61 44                       D
LAA62:  brk                                     ; AA62 00                       .
        brk                                     ; AA63 00                       .
        brk                                     ; AA64 00                       .
        sta     (L0020,x)                       ; AA65 81 20                    . 
        ora     #$00                            ; AA67 09 00                    ..
        .byte   $02                             ; AA69 02                       .
        brk                                     ; AA6A 00                       .
        .byte   $80                             ; AA6B 80                       .
        brk                                     ; AA6C 00                       .
        bpl     LAA6F                           ; AA6D 10 00                    ..
LAA6F:  rti                                     ; AA6F 40                       @

; ----------------------------------------------------------------------------
        .byte   $02                             ; AA70 02                       .
        brk                                     ; AA71 00                       .
        brk                                     ; AA72 00                       .
        dey                                     ; AA73 88                       .
        plp                                     ; AA74 28                       (
        bit     L0020                           ; AA75 24 20                    $ 
        .byte   $04                             ; AA77 04                       .
        brk                                     ; AA78 00                       .
        brk                                     ; AA79 00                       .
        jsr     L0020                           ; AA7A 20 20 00                   .
        .byte   $4F                             ; AA7D 4F                       O
        plp                                     ; AA7E 28                       (
        rol     $50,x                           ; AA7F 36 50                    6P
        .byte   $12                             ; AA81 12                       .
        .byte   $92                             ; AA82 92                       .
        .byte   $37                             ; AA83 37                       7
        sec                                     ; AA84 38                       8
LAA85:  adc     $F1F0,y                         ; AA85 79 F0 F1                 y..
        .byte   $80                             ; AA88 80                       .
        cpy     #$68                            ; AA89 C0 68                    .h
        bpl     LAA9E                           ; AA8B 10 11                    ..
        cpy     #$C1                            ; AA8D C0 C1                    ..
        .byte   $70                             ; AA8F 70                       p
LAA90:  .byte   $FF                             ; AA90 FF                       .
        beq     LAAE3                           ; AA91 F0 50                    .P
        bne     LAA85                           ; AA93 D0 F0                    ..
        bmi     LAA17                           ; AA95 30 80                    0.
        ora     ($70,x)                         ; AA97 01 70                    .p
        rti                                     ; AA99 40                       @

; ----------------------------------------------------------------------------
        cpx     #$7C                            ; AA9A E0 7C                    .|
        cpy     #$20                            ; AA9C C0 20                    . 
LAA9E:  .byte   $80                             ; AA9E 80                       .
        pha                                     ; AA9F 48                       H
        .byte   $49                             ; AAA0 49                       I
LAAA1:  iny                                     ; AAA1 C8                       .
        beq     LAAD4                           ; AAA2 F0 30                    .0
LAAA4:  rti                                     ; AAA4 40                       @

; ----------------------------------------------------------------------------
        ldy     #$B8                            ; AAA5 A0 B8                    ..
        .byte   $80                             ; AAA7 80                       .
        beq     LAA3A                           ; AAA8 F0 90                    ..
        bpl     LAA3C                           ; AAAA 10 90                    ..
        cpy     #$80                            ; AAAC C0 80                    ..
        cpy     #$40                            ; AAAE C0 40                    .@
        bmi     LAA62                           ; AAB0 30 B0                    0.
        bne     LAAA4                           ; AAB2 D0 F0                    ..
        cpy     #$D8                            ; AAB4 C0 D8                    ..
        .byte   $FF                             ; AAB6 FF                       .
        php                                     ; AAB7 08                       .
        jsr     L0010                           ; AAB8 20 10 00                  ..
        asl     a:L0000                         ; AABB 0E 00 00                 ...
        php                                     ; AABE 08                       .
        jsr     L8100                           ; AABF 20 00 81                  ..
        brk                                     ; AAC2 00                       .
        and     $02                             ; AAC3 25 02                    %.
        .byte   $80                             ; AAC5 80                       .
        brk                                     ; AAC6 00                       .
        rti                                     ; AAC7 40                       @

; ----------------------------------------------------------------------------
        php                                     ; AAC8 08                       .
        asl     L0000,x                         ; AAC9 16 00                    ..
        .byte   $04                             ; AACB 04                       .
        php                                     ; AACC 08                       .
        .byte   $80                             ; AACD 80                       .
        .byte   $02                             ; AACE 02                       .
        brk                                     ; AACF 00                       .
        brk                                     ; AAD0 00                       .
        .byte   $64                             ; AAD1 64                       d
        php                                     ; AAD2 08                       .
        .byte   $80                             ; AAD3 80                       .
LAAD4:  .byte   $02                             ; AAD4 02                       .
        php                                     ; AAD5 08                       .
        .byte   $02                             ; AAD6 02                       .
        brk                                     ; AAD7 00                       .
        brk                                     ; AAD8 00                       .
        .byte   $02                             ; AAD9 02                       .
        .byte   $80                             ; AADA 80                       .
        sec                                     ; AADB 38                       8
        dey                                     ; AADC 88                       .
        .byte   $0B                             ; AADD 0B                       .
        .byte   $02                             ; AADE 02                       .
        .byte   $02                             ; AADF 02                       .
        brk                                     ; AAE0 00                       .
        bpl     LAB03                           ; AAE1 10 20                    . 
LAAE3:  .byte   $12                             ; AAE3 12                       .
        brk                                     ; AAE4 00                       .
        brk                                     ; AAE5 00                       .
        jsr     L0000                           ; AAE6 20 00 00                  ..
        .byte   $14                             ; AAE9 14                       .
        jsr     L0006                           ; AAEA 20 06 00                  ..
        .byte   $02                             ; AAED 02                       .
        brk                                     ; AAEE 00                       .
        brk                                     ; AAEF 00                       .
        brk                                     ; AAF0 00                       .
        clc                                     ; AAF1 18                       .
        jsr     L8860                           ; AAF2 20 60 88                  `.
        ror     L0080                           ; AAF5 66 80                    f.
        .byte   $80                             ; AAF7 80                       .
        dey                                     ; AAF8 88                       .
        rti                                     ; AAF9 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AAFA 00                       .
        bpl     LAB07                           ; AAFB 10 0A                    ..
        php                                     ; AAFD 08                       .
        php                                     ; AAFE 08                       .
        eor     ($70,x)                         ; AAFF 41 70                    Ap
        sei                                     ; AB01 78                       x
        .byte   $A0                             ; AB02 A0                       .
LAB03:  dey                                     ; AB03 88                       .
        tay                                     ; AB04 A8                       .
        tay                                     ; AB05 A8                       .
        pla                                     ; AB06 68                       h
LAB07:  tay                                     ; AB07 A8                       .
        .byte   $80                             ; AB08 80                       .
        ldy     #$80                            ; AB09 A0 80                    ..
        jsr     L3840                           ; AB0B 20 40 38                  @8
        cld                                     ; AB0E D8                       .
        bcs     LAAA1                           ; AB0F B0 90                    ..
        ldy     #$A0                            ; AB11 A0 A0                    ..
        ldy     #$C0                            ; AB13 A0 C0                    ..
        bcc     LAB73                           ; AB15 90 5C                    .\
        .byte   $7C                             ; AB17 7C                       |
        .byte   $80                             ; AB18 80                       .
        ldy     $7C80,x                         ; AB19 BC 80 7C                 ..|
        .byte   $9C                             ; AB1C 9C                       .
        .byte   $9C                             ; AB1D 9C                       .
        bvs     LAB4A                           ; AB1E 70 2A                    p*
        ldy     $2A9C,x                         ; AB20 BC 9C 2A                 ..*
        lsr     $9CBC                           ; AB23 4E BC 9C                 N..
        rol     a                               ; AB26 2A                       *
        .byte   $80                             ; AB27 80                       .
        .byte   $80                             ; AB28 80                       .
        bvs     LAB9B                           ; AB29 70 70                    pp
        bvs     LAB8D                           ; AB2B 70 60                    p`
        ldy     #$90                            ; AB2D A0 90                    ..
        ldy     #$70                            ; AB2F A0 70                    .p
        bvs     LAB93                           ; AB31 70 60                    p`
        cpy     #$B0                            ; AB33 C0 B0                    ..
        brk                                     ; AB35 00                       .
        .byte   $FF                             ; AB36 FF                       .
        .byte   $12                             ; AB37 12                       .
        brk                                     ; AB38 00                       .
        jsr     L0208                           ; AB39 20 08 02                  ..
        jsr     L0802                           ; AB3C 20 02 08                  ..
        brk                                     ; AB3F 00                       .
        brk                                     ; AB40 00                       .
        .byte   $02                             ; AB41 02                       .
        brk                                     ; AB42 00                       .
        brk                                     ; AB43 00                       .
        jsr     L0080                           ; AB44 20 80 00                  ..
        brk                                     ; AB47 00                       .
        .byte   $20                             ; AB48 20                        
        brk                                     ; AB49 00                       .
LAB4A:  brk                                     ; AB4A 00                       .
        brk                                     ; AB4B 00                       .
        brk                                     ; AB4C 00                       .
        rti                                     ; AB4D 40                       @

; ----------------------------------------------------------------------------
        jsr     L0000                           ; AB4E 20 00 00                  ..
        brk                                     ; AB51 00                       .
        brk                                     ; AB52 00                       .
        brk                                     ; AB53 00                       .
        brk                                     ; AB54 00                       .
        cmp     (L0000,x)                       ; AB55 C1 00                    ..
        and     (L0000),y                       ; AB57 31 00                    1.
        bit     L0000                           ; AB59 24 00                    $.
        bit     L0020                           ; AB5B 24 20                    $ 
        .byte   $04                             ; AB5D 04                       .
        brk                                     ; AB5E 00                       .
        ora     (L0000,x)                       ; AB5F 01 00                    ..
        bpl     LAB65                           ; AB61 10 02                    ..
        .byte   $42                             ; AB63 42                       B
        brk                                     ; AB64 00                       .
LAB65:  ldy     #$00                            ; AB65 A0 00                    ..
        brk                                     ; AB67 00                       .
        brk                                     ; AB68 00                       .
        rti                                     ; AB69 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AB6A 00                       .
        .byte   $44                             ; AB6B 44                       D
        brk                                     ; AB6C 00                       .
        .byte   $04                             ; AB6D 04                       .
        .byte   $80                             ; AB6E 80                       .
        ora     L0000                           ; AB6F 05 00                    ..
        bpl     LAB73                           ; AB71 10 00                    ..
LAB73:  .byte   $44                             ; AB73 44                       D
        brk                                     ; AB74 00                       .
        brk                                     ; AB75 00                       .
        brk                                     ; AB76 00                       .
        brk                                     ; AB77 00                       .
        brk                                     ; AB78 00                       .
        .byte   $02                             ; AB79 02                       .
        .byte   $02                             ; AB7A 02                       .
        bpl     LAB7D                           ; AB7B 10 00                    ..
LAB7D:  .byte   $02                             ; AB7D 02                       .
        php                                     ; AB7E 08                       .
LAB7F:  cld                                     ; AB7F D8                       .
        .byte   $07                             ; AB80 07                       .
        .byte   $07                             ; AB81 07                       .
        .byte   $07                             ; AB82 07                       .
        .byte   $07                             ; AB83 07                       .
        .byte   $07                             ; AB84 07                       .
        .byte   $07                             ; AB85 07                       .
        .byte   $07                             ; AB86 07                       .
        .byte   $07                             ; AB87 07                       .
        eor     $0909                           ; AB88 4D 09 09                 M..
        adc     ($61,x)                         ; AB8B 61 61                    aa
LAB8D:  adc     ($61,x)                         ; AB8D 61 61                    aa
        ora     #$09                            ; AB8F 09 09                    ..
        ora     #$09                            ; AB91 09 09                    ..
LAB93:  ora     #$40                            ; AB93 09 40                    .@
        and     $0505,y                         ; AB95 39 05 05                 9..
        and     $3905,y                         ; AB98 39 05 39                 9.9
LAB9B:  ora     $05                             ; AB9B 05 05                    ..
        ora     $39                             ; AB9D 05 39                    .9
        .byte   $34                             ; AB9F 34                       4
        ora     $05                             ; ABA0 05 05                    ..
        .byte   $34                             ; ABA2 34                       4
        sta     $0505                           ; ABA3 8D 05 05                 ...
        .byte   $34                             ; ABA6 34                       4
        eor     $0909                           ; ABA7 4D 09 09                 M..
LABAA:  ora     #$16                            ; ABAA 09 16                    ..
        asl     $09,x                           ; ABAC 16 09                    ..
        ora     #$09                            ; ABAE 09 09                    ..
        asl     $16,x                           ; ABB0 16 16                    ..
        .byte   $16                             ; ABB2 16                       .
LABB3:  rti                                     ; ABB3 40                       @

; ----------------------------------------------------------------------------
        .byte   $1B                             ; ABB4 1B                       .
        .byte   $63                             ; ABB5 63                       c
        .byte   $FF                             ; ABB6 FF                       .
        .byte   $42                             ; ABB7 42                       B
        php                                     ; ABB8 08                       .
        ora     ($02,x)                         ; ABB9 01 02                    ..
        php                                     ; ABBB 08                       .
        brk                                     ; ABBC 00                       .
        brk                                     ; ABBD 00                       .
        php                                     ; ABBE 08                       .
        cli                                     ; ABBF 58                       X
        brk                                     ; ABC0 00                       .
        pha                                     ; ABC1 48                       H
        tay                                     ; ABC2 A8                       .
        .byte   $04                             ; ABC3 04                       .
        .byte   $02                             ; ABC4 02                       .
        brk                                     ; ABC5 00                       .
        php                                     ; ABC6 08                       .
        .byte   $12                             ; ABC7 12                       .
        .byte   $80                             ; ABC8 80                       .
        .byte   $02                             ; ABC9 02                       .
        brk                                     ; ABCA 00                       .
        .byte   $02                             ; ABCB 02                       .
        asl     a                               ; ABCC 0A                       .
        rti                                     ; ABCD 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; ABCE 80                       .
        rti                                     ; ABCF 40                       @

; ----------------------------------------------------------------------------
        php                                     ; ABD0 08                       .
        php                                     ; ABD1 08                       .
        asl     a                               ; ABD2 0A                       .
        brk                                     ; ABD3 00                       .
        brk                                     ; ABD4 00                       .
        brk                                     ; ABD5 00                       .
        jsr     L0818                           ; ABD6 20 18 08                  ..
        .byte   $80                             ; ABD9 80                       .
        .byte   $80                             ; ABDA 80                       .
        brk                                     ; ABDB 00                       .
        brk                                     ; ABDC 00                       .
        ora     #$02                            ; ABDD 09 02                    ..
        .byte   $82                             ; ABDF 82                       .
        ldx     #$40                            ; ABE0 A2 40                    .@
        jsr     L0020                           ; ABE2 20 20 00                   .
        brk                                     ; ABE5 00                       .
        brk                                     ; ABE6 00                       .
        brk                                     ; ABE7 00                       .
        jsr     L804C                           ; ABE8 20 4C 80                  L.
        rti                                     ; ABEB 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ABEC 00                       .
        brk                                     ; ABED 00                       .
        brk                                     ; ABEE 00                       .
        bcc     LABF1                           ; ABEF 90 00                    ..
LABF1:  php                                     ; ABF1 08                       .
        php                                     ; ABF2 08                       .
        brk                                     ; ABF3 00                       .
        brk                                     ; ABF4 00                       .
        bmi     LAB7F                           ; ABF5 30 88                    0.
        sty     L0000                           ; ABF7 84 00                    ..
        eor     #$88                            ; ABF9 49 88                    I.
        eor     (L0020,x)                       ; ABFB 41 20                    A 
        .byte   $14                             ; ABFD 14                       .
        .byte   $80                             ; ABFE 80                       .
        tya                                     ; ABFF 98                       .
        brk                                     ; AC00 00                       .
        brk                                     ; AC01 00                       .
        ora     ($03,x)                         ; AC02 01 03                    ..
        php                                     ; AC04 08                       .
        php                                     ; AC05 08                       .
        asl     a                               ; AC06 0A                       .
        .byte   $0B                             ; AC07 0B                       .
        .byte   $0F                             ; AC08 0F                       .
        ora     ($12),y                         ; AC09 11 12                    ..
        ora     $15,x                           ; AC0B 15 15                    ..
        .byte   $17                             ; AC0D 17                       .
        ora     $1D1B,y                         ; AC0E 19 1B 1D                 ...
        .byte   $1F                             ; AC11 1F                       .
        .byte   $23                             ; AC12 23                       #
        .byte   $27                             ; AC13 27                       '
        .byte   $27                             ; AC14 27                       '
        and     #$2A                            ; AC15 29 2A                    )*
        and     $302F                           ; AC17 2D 2F 30                 -/0
        .byte   $34                             ; AC1A 34                       4
        and     $35,x                           ; AC1B 35 35                    55
        brk                                     ; AC1D 00                       .
        brk                                     ; AC1E 00                       .
        brk                                     ; AC1F 00                       .
        brk                                     ; AC20 00                       .
        brk                                     ; AC21 00                       .
        brk                                     ; AC22 00                       .
        brk                                     ; AC23 00                       .
        brk                                     ; AC24 00                       .
        brk                                     ; AC25 00                       .
        brk                                     ; AC26 00                       .
        brk                                     ; AC27 00                       .
        brk                                     ; AC28 00                       .
        brk                                     ; AC29 00                       .
        brk                                     ; AC2A 00                       .
        brk                                     ; AC2B 00                       .
        brk                                     ; AC2C 00                       .
        brk                                     ; AC2D 00                       .
        bpl     LAC30                           ; AC2E 10 00                    ..
LAC30:  brk                                     ; AC30 00                       .
        bpl     LABB3                           ; AC31 10 80                    ..
        brk                                     ; AC33 00                       .
        brk                                     ; AC34 00                       .
        jsr     L0000                           ; AC35 20 00 00                  ..
        brk                                     ; AC38 00                       .
        brk                                     ; AC39 00                       .
        brk                                     ; AC3A 00                       .
        brk                                     ; AC3B 00                       .
        php                                     ; AC3C 08                       .
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
        ora     (L0000,x)                       ; AC49 01 00                    ..
        brk                                     ; AC4B 00                       .
        .byte   $80                             ; AC4C 80                       .
        brk                                     ; AC4D 00                       .
        brk                                     ; AC4E 00                       .
        brk                                     ; AC4F 00                       .
        brk                                     ; AC50 00                       .
        brk                                     ; AC51 00                       .
        brk                                     ; AC52 00                       .
        brk                                     ; AC53 00                       .
        brk                                     ; AC54 00                       .
        brk                                     ; AC55 00                       .
        jsr     L0000                           ; AC56 20 00 00                  ..
        brk                                     ; AC59 00                       .
        bpl     LAC5C                           ; AC5A 10 00                    ..
LAC5C:  brk                                     ; AC5C 00                       .
        brk                                     ; AC5D 00                       .
        brk                                     ; AC5E 00                       .
        brk                                     ; AC5F 00                       .
        brk                                     ; AC60 00                       .
        brk                                     ; AC61 00                       .
        brk                                     ; AC62 00                       .
        brk                                     ; AC63 00                       .
        bpl     LAC66                           ; AC64 10 00                    ..
LAC66:  brk                                     ; AC66 00                       .
        brk                                     ; AC67 00                       .
        brk                                     ; AC68 00                       .
        ora     (L0000,x)                       ; AC69 01 00                    ..
        brk                                     ; AC6B 00                       .
        php                                     ; AC6C 08                       .
        brk                                     ; AC6D 00                       .
        brk                                     ; AC6E 00                       .
        brk                                     ; AC6F 00                       .
        brk                                     ; AC70 00                       .
        brk                                     ; AC71 00                       .
        brk                                     ; AC72 00                       .
        brk                                     ; AC73 00                       .
        .byte   $04                             ; AC74 04                       .
        brk                                     ; AC75 00                       .
        brk                                     ; AC76 00                       .
        jsr     L0010                           ; AC77 20 10 00                  ..
        brk                                     ; AC7A 00                       .
        brk                                     ; AC7B 00                       .
        brk                                     ; AC7C 00                       .
        brk                                     ; AC7D 00                       .
        lda     (L0000,x)                       ; AC7E A1 00                    ..
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
        bpl     LAC91                           ; AC8F 10 00                    ..
LAC91:  brk                                     ; AC91 00                       .
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
        jsr     L0000                           ; AC9C 20 00 00                  ..
        brk                                     ; AC9F 00                       .
        brk                                     ; ACA0 00                       .
        brk                                     ; ACA1 00                       .
        brk                                     ; ACA2 00                       .
        brk                                     ; ACA3 00                       .
        brk                                     ; ACA4 00                       .
        brk                                     ; ACA5 00                       .
        brk                                     ; ACA6 00                       .
        brk                                     ; ACA7 00                       .
        brk                                     ; ACA8 00                       .
        brk                                     ; ACA9 00                       .
        brk                                     ; ACAA 00                       .
        brk                                     ; ACAB 00                       .
        brk                                     ; ACAC 00                       .
        brk                                     ; ACAD 00                       .
        brk                                     ; ACAE 00                       .
LACAF:  brk                                     ; ACAF 00                       .
        brk                                     ; ACB0 00                       .
        brk                                     ; ACB1 00                       .
        brk                                     ; ACB2 00                       .
        ora     (L0000,x)                       ; ACB3 01 00                    ..
        brk                                     ; ACB5 00                       .
        brk                                     ; ACB6 00                       .
        brk                                     ; ACB7 00                       .
        brk                                     ; ACB8 00                       .
        ora     (L0010,x)                       ; ACB9 01 10                    ..
        brk                                     ; ACBB 00                       .
        brk                                     ; ACBC 00                       .
        brk                                     ; ACBD 00                       .
        bpl     LACC0                           ; ACBE 10 00                    ..
LACC0:  brk                                     ; ACC0 00                       .
        brk                                     ; ACC1 00                       .
        rti                                     ; ACC2 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACC3 00                       .
        brk                                     ; ACC4 00                       .
        brk                                     ; ACC5 00                       .
        brk                                     ; ACC6 00                       .
        brk                                     ; ACC7 00                       .
        brk                                     ; ACC8 00                       .
        brk                                     ; ACC9 00                       .
        brk                                     ; ACCA 00                       .
        brk                                     ; ACCB 00                       .
        php                                     ; ACCC 08                       .
        brk                                     ; ACCD 00                       .
        brk                                     ; ACCE 00                       .
        brk                                     ; ACCF 00                       .
        brk                                     ; ACD0 00                       .
        brk                                     ; ACD1 00                       .
        brk                                     ; ACD2 00                       .
        brk                                     ; ACD3 00                       .
        brk                                     ; ACD4 00                       .
        brk                                     ; ACD5 00                       .
        brk                                     ; ACD6 00                       .
        brk                                     ; ACD7 00                       .
        rti                                     ; ACD8 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACD9 00                       .
        brk                                     ; ACDA 00                       .
        .byte   $04                             ; ACDB 04                       .
        brk                                     ; ACDC 00                       .
        .byte   $04                             ; ACDD 04                       .
        jsr     L0000                           ; ACDE 20 00 00                  ..
        brk                                     ; ACE1 00                       .
        brk                                     ; ACE2 00                       .
        brk                                     ; ACE3 00                       .
        brk                                     ; ACE4 00                       .
        brk                                     ; ACE5 00                       .
        .byte   $04                             ; ACE6 04                       .
        brk                                     ; ACE7 00                       .
        brk                                     ; ACE8 00                       .
        brk                                     ; ACE9 00                       .
        brk                                     ; ACEA 00                       .
        brk                                     ; ACEB 00                       .
        brk                                     ; ACEC 00                       .
        brk                                     ; ACED 00                       .
        plp                                     ; ACEE 28                       (
        brk                                     ; ACEF 00                       .
        rti                                     ; ACF0 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; ACF1 00                       .
        ora     ($04,x)                         ; ACF2 01 04                    ..
        brk                                     ; ACF4 00                       .
        .byte   $44                             ; ACF5 44                       D
        brk                                     ; ACF6 00                       .
        brk                                     ; ACF7 00                       .
LACF8:  brk                                     ; ACF8 00                       .
        brk                                     ; ACF9 00                       .
        brk                                     ; ACFA 00                       .
        brk                                     ; ACFB 00                       .
        bpl     LACFE                           ; ACFC 10 00                    ..
LACFE:  brk                                     ; ACFE 00                       .
        rti                                     ; ACFF 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AD00 00                       .
        bpl     LAD04                           ; AD01 10 01                    ..
        .byte   $10                             ; AD03 10                       .
LAD04:  bpl     LAD27                           ; AD04 10 21                    .!
        .byte   $FA                             ; AD06 FA                       .
        .byte   $9F                             ; AD07 9F                       .
        bpl     LAD1C                           ; AD08 10 12                    ..
        rts                                     ; AD0A 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; AD0B 00                       .
        sty     $86                             ; AD0C 84 86                    ..
        .byte   $87                             ; AD0E 87                       .
        sta     $F0F0,y                         ; AD0F 99 F0 F0                 ...
        brk                                     ; AD12 00                       .
        ldx     #$A4                            ; AD13 A2 A4                    ..
        and     a:$E2                           ; AD15 2D E2 00                 -..
        rts                                     ; AD18 60                       `

; ----------------------------------------------------------------------------
        .byte   $F2                             ; AD19 F2                       .
        cpy     #$C5                            ; AD1A C0 C5                    ..
LAD1C:  cpy     $B5                             ; AD1C C4 B5                    ..
        .byte   $43                             ; AD1E 43                       C
        cmp     L0006,x                         ; AD1F D5 06                    ..
        brk                                     ; AD21 00                       .
        .byte   $8B                             ; AD22 8B                       .
        .byte   $E7                             ; AD23 E7                       .
        .byte   $AB                             ; AD24 AB                       .
        cpx     #$E6                            ; AD25 E0 E6                    ..
LAD27:  sbc     L0006                           ; AD27 E5 06                    ..
        brk                                     ; AD29 00                       .
        .byte   $43                             ; AD2A 43                       C
        cmp     $EBFA                           ; AD2B CD FA EB                 ...
        ror     a:$E2                           ; AD2E 6E E2 00                 n..
        bne     LACF8                           ; AD31 D0 C5                    ..
        cmp     $C5                             ; AD33 C5 C5                    ..
        cmp     $F2                             ; AD35 C5 F2                    ..
        .byte   $F2                             ; AD37 F2                       .
        brk                                     ; AD38 00                       .
        sta     $968F,x                         ; AD39 9D 8F 96                 ...
        tya                                     ; AD3C 98                       .
        brk                                     ; AD3D 00                       .
        .byte   $E3                             ; AD3E E3                       .
        cpx     $8C                             ; AD3F E4 8C                    ..
LAD41:  stx     LB726                           ; AD41 8E 26 B7                 .&.
        .byte   $B7                             ; AD44 B7                       .
        .byte   $63                             ; AD45 63                       c
        bit     $892A                           ; AD46 2C 2A 89                 ,*.
        .byte   $AF                             ; AD49 AF                       .
        .byte   $AF                             ; AD4A AF                       .
        .byte   $AF                             ; AD4B AF                       .
        sta     ($EF),y                         ; AD4C 91 EF                    ..
        .byte   $63                             ; AD4E 63                       c
        .byte   $63                             ; AD4F 63                       c
        brk                                     ; AD50 00                       .
        .byte   $AF                             ; AD51 AF                       .
        dec     $C8                             ; AD52 C6 C8                    ..
        clv                                     ; AD54 B8                       .
        lda     $FDFD,y                         ; AD55 B9 FD FD                 ...
        .byte   $0F                             ; AD58 0F                       .
        .byte   $0C                             ; AD59 0C                       .
        asl     $E809,x                         ; AD5A 1E 09 E8                 ...
        brk                                     ; AD5D 00                       .
        .byte   $30                             ; AD5E 30                       0
LAD5F:  bmi     LAD90                           ; AD5F 30 2F                    0/
        bvc     LAD41                           ; AD61 50 DE                    P.
        ora     #$F8                            ; AD63 09 F8                    ..
        brk                                     ; AD65 00                       .
        rol     a                               ; AD66 2A                       *
        .byte   $2B                             ; AD67 2B                       +
        .byte   $43                             ; AD68 43                       C
        .byte   $43                             ; AD69 43                       C
        eor     ($44,x)                         ; AD6A 41 44                    AD
        brk                                     ; AD6C 00                       .
        and     #$2A                            ; AD6D 29 2A                    )*
        rol     a                               ; AD6F 2A                       *
        .byte   $43                             ; AD70 43                       C
        bvc     LADA5                           ; AD71 50 32                    P2
        .byte   $32                             ; AD73 32                       2
        .byte   $43                             ; AD74 43                       C
        brk                                     ; AD75 00                       .
        .byte   $37                             ; AD76 37                       7
        and     a:$2A                           ; AD77 2D 2A 00                 -*.
        inc     $4432                           ; AD7A EE 32 44                 .2D
        cmp     $48                             ; AD7D C5 48                    .H
        .byte   $80                             ; AD7F 80                       .
        pla                                     ; AD80 68                       h
        pla                                     ; AD81 68                       h
        asl     $40,x                           ; AD82 16 40                    .@
        bit     $7B                             ; AD84 24 7B                    ${
        ror     $73,x                           ; AD86 76 73                    vs
        .byte   $43                             ; AD88 43                       C
        ror     a                               ; AD89 6A                       j
        .byte   $7B                             ; AD8A 7B                       {
        adc     ($49),y                         ; AD8B 71 49                    qI
        lsr     a                               ; AD8D 4A                       J
        .byte   $79                             ; AD8E 79                       y
        sei                                     ; AD8F 78                       x
LAD90:  asl     a                               ; AD90 0A                       .
        ora     $04                             ; AD91 05 04                    ..
        ora     $3C                             ; AD93 05 3C                    .<
        .byte   $3C                             ; AD95 3C                       <
        and     LB23A,y                         ; AD96 39 3A B2                 9:.
        brk                                     ; AD99 00                       .
        brk                                     ; AD9A 00                       .
        .byte   $E3                             ; AD9B E3                       .
        .byte   $9F                             ; AD9C 9F                       .
        rol     a                               ; AD9D 2A                       *
LAD9E:  .byte   $43                             ; AD9E 43                       C
        tax                                     ; AD9F AA                       .
        .byte   $B3                             ; ADA0 B3                       .
        brk                                     ; ADA1 00                       .
        adc     $66                             ; ADA2 65 66                    ef
        .byte   $43                             ; ADA4 43                       C
LADA5:  lsr     a                               ; ADA5 4A                       J
        lsr     a                               ; ADA6 4A                       J
        dey                                     ; ADA7 88                       .
        rts                                     ; ADA8 60                       `

; ----------------------------------------------------------------------------
        .byte   $83                             ; ADA9 83                       .
        ldx     L0000,y                         ; ADAA B6 00                    ..
        .byte   $4C                             ; ADAC 4C                       L
LADAD:  .byte   $4E                             ; ADAD 4E                       N
LADAE:  .byte   $DA                             ; ADAE DA                       .
        ldx     LB060                           ; ADAF AE 60 B0                 .`.
        brk                                     ; ADB2 00                       .
        jmp     L994E                           ; ADB3 4C 4E 99                 LN.

; ----------------------------------------------------------------------------
        ldy     $39E5                           ; ADB6 AC E5 39                 ..9
        .byte   $43                             ; ADB9 43                       C
        lda     $3A39,x                         ; ADBA BD 39 3A                 .9:
        .byte   $3A                             ; ADBD 3A                       :
        .byte   $E3                             ; ADBE E3                       .
        sbc     $63                             ; ADBF E5 63                    .c
        .byte   $63                             ; ADC1 63                       c
        .byte   $83                             ; ADC2 83                       .
        .byte   $83                             ; ADC3 83                       .
        .byte   $63                             ; ADC4 63                       c
        .byte   $64                             ; ADC5 64                       d
        .byte   $64                             ; ADC6 64                       d
        ldy     #$64                            ; ADC7 A0 64                    .d
        .byte   $64                             ; ADC9 64                       d
        sta     ($93),y                         ; ADCA 91 93                    ..
        sta     L0000,x                         ; ADCC 95 00                    ..
        .byte   $97                             ; ADCE 97                       .
        .byte   $2F                             ; ADCF 2F                       /
        txa                                     ; ADD0 8A                       .
        sty     $EEA1                           ; ADD1 8C A1 EE                 ...
        ldx     $B8                             ; ADD4 A6 B8                    ..
        stx     LB6ED                           ; ADD6 8E ED B6                 ...
        dec     $C0                             ; ADD9 C6 C0                    ..
        .byte   $C0                             ; ADDB C0                       .
LADDC:  cpy     #$B8                            ; ADDC C0 B8                    ..
        clv                                     ; ADDE B8                       .
        cpx     LBBBA                           ; ADDF EC BA BB                 ...
        sed                                     ; ADE2 F8                       .
        .byte   $D2                             ; ADE3 D2                       .
        bne     LAD9E                           ; ADE4 D0 B8                    ..
        inx                                     ; ADE6 E8                       .
        cld                                     ; ADE7 D8                       .
        sbc     ($E0,x)                         ; ADE8 E1 E0                    ..
        .byte   $B3                             ; ADEA B3                       .
        lda     ($A1,x)                         ; ADEB A1 A1                    ..
        inc     $F632,x                         ; ADED FE 32 F6                 .2.
        sbc     ($E0,x)                         ; ADF0 E1 E0                    ..
        tay                                     ; ADF2 A8                       .
        tay                                     ; ADF3 A8                       .
        .byte   $F7                             ; ADF4 F7                       .
        eor     $6C                             ; ADF5 45 6C                    El
        pla                                     ; ADF7 68                       h
        dec     $3636,x                         ; ADF8 DE 36 36                 .66
        pla                                     ; ADFB 68                       h
        ldx     $7C57,y                         ; ADFC BE 57 7C                 .W|
        .byte   $7F                             ; ADFF 7F                       .
        brk                                     ; AE00 00                       .
        bpl     LAE13                           ; AE01 10 10                    ..
        .byte   $02                             ; AE03 02                       .
        jsr     LFD10                           ; AE04 20 10 FD                  ..
        .byte   $9F                             ; AE07 9F                       .
        ora     (L0010),y                       ; AE08 11 10                    ..
        rts                                     ; AE0A 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; AE0B 00                       .
        sta     $87                             ; AE0C 85 87                    ..
        .byte   $87                             ; AE0E 87                       .
        sta     $F1F0,y                         ; AE0F 99 F0 F1                 ...
        .byte   $A1                             ; AE12 A1                       .
LAE13:  .byte   $A3                             ; AE13 A3                       .
        lda     $CB                             ; AE14 A5 CB                    ..
        brk                                     ; AE16 00                       .
        brk                                     ; AE17 00                       .
        rts                                     ; AE18 60                       `

; ----------------------------------------------------------------------------
        beq     LADDC                           ; AE19 F0 C1                    ..
        .byte   $C3                             ; AE1B C3                       .
        cmp     L0043                           ; AE1C C5 43                    .C
        .byte   $43                             ; AE1E 43                       C
        cmp     L0006,x                         ; AE1F D5 06                    ..
        txa                                     ; AE21 8A                       .
        cpx     #$43                            ; AE22 E0 43                    .C
        .byte   $AB                             ; AE24 AB                       .
        sbc     ($E7,x)                         ; AE25 E1 E7                    ..
        sbc     L0006                           ; AE27 E5 06                    ..
        tax                                     ; AE29 AA                       .
        .byte   $EB                             ; AE2A EB                       .
        .byte   $43                             ; AE2B 43                       C
        .byte   $FA                             ; AE2C FA                       .
        inc     $CD,x                           ; AE2D F6 CD                    ..
        .byte   $E2                             ; AE2F E2                       .
        brk                                     ; AE30 00                       .
        cmp     ($C5),y                         ; AE31 D1 C5                    ..
        cmp     $C5                             ; AE33 C5 C5                    ..
        cmp     $F3                             ; AE35 C5 F3                    ..
        .byte   $F3                             ; AE37 F3                       .
        .byte   $9C                             ; AE38 9C                       .
        .byte   $9E                             ; AE39 9E                       .
        stx     $97,y                           ; AE3A 96 97                    ..
        .byte   $43                             ; AE3C 43                       C
        brk                                     ; AE3D 00                       .
        .byte   $E3                             ; AE3E E3                       .
        brk                                     ; AE3F 00                       .
        sta     $268F                           ; AE40 8D 8F 26                 ..&
        dec     L0000                           ; AE43 C6 00                    ..
        .byte   $63                             ; AE45 63                       c
        rol     a                               ; AE46 2A                       *
        .byte   $1C                             ; AE47 1C                       .
        .byte   $AF                             ; AE48 AF                       .
        .byte   $AF                             ; AE49 AF                       .
        .byte   $AF                             ; AE4A AF                       .
        .byte   $AF                             ; AE4B AF                       .
        .byte   $EF                             ; AE4C EF                       .
        .byte   $C2                             ; AE4D C2                       .
        .byte   $63                             ; AE4E 63                       c
        .byte   $63                             ; AE4F 63                       c
        .byte   $D3                             ; AE50 D3                       .
        lda     $C6C7,x                         ; AE51 BD C7 C6                 ...
        lda     $FDB8,y                         ; AE54 B9 B8 FD                 ...
        inc     $0D0F,x                         ; AE57 FE 0F 0D                 ...
        .byte   $0C                             ; AE5A 0C                       .
        ora     #$E9                            ; AE5B 09 E9                    ..
LAE5D:  brk                                     ; AE5D 00                       .
        and     ($31),y                         ; AE5E 31 31                    11
        .byte   $2F                             ; AE60 2F                       /
        .byte   $32                             ; AE61 32                       2
        .byte   $DF                             ; AE62 DF                       .
        ora     #$F9                            ; AE63 09 F9                    ..
        brk                                     ; AE65 00                       .
        rol     a                               ; AE66 2A                       *
        rol     a                               ; AE67 2A                       *
        .byte   $43                             ; AE68 43                       C
        rti                                     ; AE69 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; AE6A 42                       B
        .byte   $43                             ; AE6B 43                       C
        cpy     $37                             ; AE6C C4 37                    .7
        rol     a                               ; AE6E 2A                       *
        .byte   $2B                             ; AE6F 2B                       +
        .byte   $43                             ; AE70 43                       C
        .byte   $62                             ; AE71 62                       b
        .byte   $32                             ; AE72 32                       2
        .byte   $44                             ; AE73 44                       D
        .byte   $43                             ; AE74 43                       C
        sta     ($47,x)                         ; AE75 81 47                    .G
        and     $EA2A                           ; AE77 2D 2A EA                 -*.
        .byte   $EF                             ; AE7A EF                       .
        .byte   $32                             ; AE7B 32                       2
        .byte   $43                             ; AE7C 43                       C
        brk                                     ; AE7D 00                       .
        pha                                     ; AE7E 48                       H
        ror     $68,x                           ; AE7F 76 68                    vh
        pla                                     ; AE81 68                       h
        pla                                     ; AE82 68                       h
        eor     ($25,x)                         ; AE83 41 25                    A%
        ror     $72,x                           ; AE85 76 72                    vr
        .byte   $74                             ; AE87 74                       t
        .byte   $43                             ; AE88 43                       C
        .byte   $43                             ; AE89 43                       C
        ror     L0043,x                         ; AE8A 76 43                    vC
        lsr     a                               ; AE8C 4A                       J
        .byte   $4B                             ; AE8D 4B                       K
        adc     $0B78,y                         ; AE8E 79 78 0B                 yx.
        .byte   $0B                             ; AE91 0B                       .
        .byte   $0B                             ; AE92 0B                       .
        .byte   $03                             ; AE93 03                       .
        .byte   $3C                             ; AE94 3C                       <
        and     $393A,x                         ; AE95 3D 3A 39                 =:9
        .byte   $FB                             ; AE98 FB                       .
        .byte   $FA                             ; AE99 FA                       .
        .byte   $A9                             ; AE9A A9                       .
LAE9B:  cpx     $9F                             ; AE9B E4 9F                    ..
        .byte   $07                             ; AE9D 07                       .
        php                                     ; AE9E 08                       .
        .byte   $AB                             ; AE9F AB                       .
        lda     ($EC,x)                         ; AEA0 A1 EC                    ..
        ror     $67                             ; AEA2 66 67                    fg
        .byte   $43                             ; AEA4 43                       C
        lsr     a                               ; AEA5 4A                       J
        jmp     L82BA                           ; AEA6 4C BA 82                 L..

; ----------------------------------------------------------------------------
        rts                                     ; AEA9 60                       `

; ----------------------------------------------------------------------------
LAEAA:  ldx     L0000,y                         ; AEAA B6 00                    ..
LAEAC:  .byte   $4D                             ; AEAC 4D                       M
LAEAD:  .byte   $4F                             ; AEAD 4F                       O
        .byte   $DB                             ; AEAE DB                       .
        brk                                     ; AEAF 00                       .
        ldy     #$60                            ; AEB0 A0 60                    .`
        brk                                     ; AEB2 00                       .
        eor     LB24F                           ; AEB3 4D 4F B2                 MO.
        lda     $43E4                           ; AEB6 AD E4 43                 ..C
        and     $3ACD,y                         ; AEB9 39 CD 3A                 9.:
        .byte   $3A                             ; AEBC 3A                       :
        .byte   $39                             ; AEBD 39                       9
        .byte   $E4                             ; AEBE E4                       .
LAEBF:  cpx     $63                             ; AEBF E4 63                    .c
        .byte   $63                             ; AEC1 63                       c
        .byte   $83                             ; AEC2 83                       .
        .byte   $83                             ; AEC3 83                       .
        .byte   $63                             ; AEC4 63                       c
        .byte   $64                             ; AEC5 64                       d
        .byte   $64                             ; AEC6 64                       d
        ldy     #$64                            ; AEC7 A0 64                    .d
        bcc     LAE5D                           ; AEC9 90 92                    ..
        sty     $64,x                           ; AECB 94 64                    .d
        stx     L0000,y                         ; AECD 96 00                    ..
        .byte   $2F                             ; AECF 2F                       /
        .byte   $8B                             ; AED0 8B                       .
        sta     $EFA1                           ; AED1 8D A1 EF                 ...
        .byte   $A7                             ; AED4 A7                       .
        lda     $EC8F,y                         ; AED5 B9 8F EC                 ...
        .byte   $B7                             ; AED8 B7                       .
        cmp     $B1,x                           ; AED9 D5 B1                    ..
        cpy     #$C0                            ; AEDB C0 C0                    ..
        lda     $FCB9,y                         ; AEDD B9 B9 FC                 ...
        .byte   $BB                             ; AEE0 BB                       .
        ldy     $D3F9,x                         ; AEE1 BC F9 D3                 ...
        bne     LAEBF                           ; AEE4 D0 D9                    ..
        sbc     #$B9                            ; AEE6 E9 B9                    ..
        cpx     #$E1                            ; AEE8 E0 E1                    ..
        lda     ($C3,x)                         ; AEEA A1 C3                    ..
        lda     ($32,x)                         ; AEEC A1 32                    .2
        .byte   $C7                             ; AEEE C7                       .
        inc     $E0,x                           ; AEEF F6 E0                    ..
        sbc     ($A8,x)                         ; AEF1 E1 A8                    ..
        lda     #$F6                            ; AEF3 A9 F6                    ..
        eor     $68                             ; AEF5 45 68                    Eh
        jmp     (L19DF)                         ; AEF7 6C DF 19                 l..

; ----------------------------------------------------------------------------
        ora     LBF68,y                         ; AEFA 19 68 BF                 .h.
        .byte   $57                             ; AEFD 57                       W
        adc     a:$7C,x                         ; AEFE 7D 7C 00                 }|.
        bpl     LAF14                           ; AF01 10 11                    ..
        .byte   $02                             ; AF03 02                       .
        .byte   $02                             ; AF04 02                       .
        ora     ($82),y                         ; AF05 11 82                    ..
        bcc     LAF19                           ; AF07 90 10                    ..
        bpl     LAE9B                           ; AF09 10 90                    ..
        .byte   $92                             ; AF0B 92                       .
        sty     $F1,x                           ; AF0C 94 F1                    ..
        dey                                     ; AF0E 88                       .
        brk                                     ; AF0F 00                       .
        bpl     LAF14                           ; AF10 10 02                    ..
        brk                                     ; AF12 00                       .
        .byte   $B2                             ; AF13 B2                       .
LAF14:  ldy     L0043,x                         ; AF14 B4 43                    .C
        .byte   $F4                             ; AF16 F4                       .
        bcc     LAF19                           ; AF17 90 00                    ..
LAF19:  ora     ($D0),y                         ; AF19 11 D0                    ..
        .byte   $B3                             ; AF1B B3                       .
        .byte   $C5                             ; AF1C C5                       .
LAF1D:  cmp     $C5                             ; AF1D C5 C5                    ..
        sbc     L0006                           ; AF1F E5 06                    ..
        brk                                     ; AF21 00                       .
        .byte   $9B                             ; AF22 9B                       .
        .byte   $F7                             ; AF23 F7                       .
        .byte   $43                             ; AF24 43                       C
        beq     LAF1D                           ; AF25 F0 F6                    ..
        sbc     $BA                             ; AF27 E5 BA                    ..
        txa                                     ; AF29 8A                       .
        .byte   $43                             ; AF2A 43                       C
        cmp     $FB82,x                         ; AF2B DD 82 FB                 ...
        .byte   $FC                             ; AF2E FC                       .
        .byte   $F4                             ; AF2F F4                       .
        brk                                     ; AF30 00                       .
        sta     $968F                           ; AF31 8D 8F 96                 ...
        .byte   $97                             ; AF34 97                       .
        .byte   $3F                             ; AF35 3F                       ?
        .byte   $D2                             ; AF36 D2                       .
        .byte   $F2                             ; AF37 F2                       .
        .byte   $BB                             ; AF38 BB                       .
        lda     $9796,x                         ; AF39 BD 96 97                 ...
        .byte   $43                             ; AF3C 43                       C
        .byte   $D4                             ; AF3D D4                       .
        .byte   $F2                             ; AF3E F2                       .
        brk                                     ; AF3F 00                       .
        .byte   $9C                             ; AF40 9C                       .
        .byte   $9E                             ; AF41 9E                       .
        .byte   $89                             ; AF42 89                       .
        .byte   $F2                             ; AF43 F2                       .
        brk                                     ; AF44 00                       .
        .byte   $64                             ; AF45 64                       d
        .byte   $3B                             ; AF46 3B                       ;
        .byte   $3A                             ; AF47 3A                       :
        brk                                     ; AF48 00                       .
        brk                                     ; AF49 00                       .
        brk                                     ; AF4A 00                       .
        .byte   $B7                             ; AF4B B7                       .
        cpy     $6BFF                           ; AF4C CC FF 6B                 ..k
        .byte   $6B                             ; AF4F 6B                       k
        brk                                     ; AF50 00                       .
        .byte   $AF                             ; AF51 AF                       .
        dec     $D8,x                           ; AF52 D6 D8                    ..
        cmp     #$CA                            ; AF54 C9 CA                    ..
        sbc     $1FFD,x                         ; AF56 FD FD 1F                 ...
        brk                                     ; AF59 00                       .
        rol     $F809,x                         ; AF5A 3E 09 F8                 >..
        .byte   $27                             ; AF5D 27                       '
        bmi     LAF90                           ; AF5E 30 30                    00
        .byte   $2F                             ; AF60 2F                       /
        eor     ($DE),y                         ; AF61 51 DE                    Q.
        asl     $26E8                           ; AF63 0E E8 26                 ..&
        .byte   $3A                             ; AF66 3A                       :
        .byte   $3B                             ; AF67 3B                       ;
        .byte   $43                             ; AF68 43                       C
        .byte   $43                             ; AF69 43                       C
        .byte   $32                             ; AF6A 32                       2
        .byte   $32                             ; AF6B 32                       2
        brk                                     ; AF6C 00                       .
        pha                                     ; AF6D 48                       H
        ora     $403A,x                         ; AF6E 1D 3A 40                 .:@
        eor     ($32),y                         ; AF71 51 32                    Q2
        .byte   $32                             ; AF73 32                       2
        eor     L0000,x                         ; AF74 55 00                    U.
        pha                                     ; AF76 48                       H
        .byte   $43                             ; AF77 43                       C
        .byte   $3A                             ; AF78 3A                       :
        sbc     $32FE                           ; AF79 ED FE 32                 ..2
        .byte   $32                             ; AF7C 32                       2
        brk                                     ; AF7D 00                       .
        .byte   $6F                             ; AF7E 6F                       o
        brk                                     ; AF7F 00                       .
        .byte   $43                             ; AF80 43                       C
        adc     #$71                            ; AF81 69 71                    iq
        .byte   $33                             ; AF83 33                       3
        .byte   $34                             ; AF84 34                       4
        clc                                     ; AF85 18                       .
        bvs     LAFFD                           ; AF86 70 75                    pu
        .byte   $43                             ; AF88 43                       C
        ror     a                               ; AF89 6A                       j
        clc                                     ; AF8A 18                       .
        adc     ($59),y                         ; AF8B 71 59                    qY
        .byte   $43                             ; AF8D 43                       C
        .byte   $7A                             ; AF8E 7A                       z
        sei                                     ; AF8F 78                       x
LAF90:  .byte   $1A                             ; AF90 1A                       .
        ora     $14,x                           ; AF91 15 14                    ..
        ora     $58,x                           ; AF93 15 58                    .X
        cli                                     ; AF95 58                       X
        and     LBD3A,y                         ; AF96 39 3A BD                 9:.
LAF99:  brk                                     ; AF99 00                       .
        brk                                     ; AF9A 00                       .
LAF9B:  .byte   $22                             ; AF9B 22                       "
        brk                                     ; AF9C 00                       .
        .byte   $3A                             ; AF9D 3A                       :
        .byte   $43                             ; AF9E 43                       C
        tax                                     ; AF9F AA                       .
        .byte   $B3                             ; AFA0 B3                       .
        brk                                     ; AFA1 00                       .
        adc     $66                             ; AFA2 65 66                    ef
        .byte   $43                             ; AFA4 43                       C
        lsr     a                               ; AFA5 4A                       J
        lsr     a                               ; AFA6 4A                       J
        .byte   $43                             ; AFA7 43                       C
        brk                                     ; AFA8 00                       .
        brk                                     ; AFA9 00                       .
        cli                                     ; AFAA 58                       X
        brk                                     ; AFAB 00                       .
        .byte   $5C                             ; AFAC 5C                       \
        lsr     LAEAC,x                         ; AFAD 5E AC AE                 ^..
        brk                                     ; AFB0 00                       .
        brk                                     ; AFB1 00                       .
        brk                                     ; AFB2 00                       .
        .byte   $5C                             ; AFB3 5C                       \
        lsr     LACAF,x                         ; AFB4 5E AF AC                 ^..
        .byte   $E2                             ; AFB7 E2                       .
        adc     $65                             ; AFB8 65 65                    ee
        lda     $3A39,x                         ; AFBA BD 39 3A                 .9:
        .byte   $3A                             ; AFBD 3A                       :
        inc     $E7                             ; AFBE E6 E7                    ..
        tya                                     ; AFC0 98                       .
        tya                                     ; AFC1 98                       .
        sta     ($82,x)                         ; AFC2 81 82                    ..
        sta     $86                             ; AFC4 85 86                    ..
        dey                                     ; AFC6 88                       .
        bcs     LAFC9                           ; AFC7 B0 00                    ..
LAFC9:  brk                                     ; AFC9 00                       .
        brk                                     ; AFCA 00                       .
        brk                                     ; AFCB 00                       .
        brk                                     ; AFCC 00                       .
        brk                                     ; AFCD 00                       .
        .byte   $97                             ; AFCE 97                       .
        ror     $9C9A,x                         ; AFCF 7E 9A 9C                 ~..
        lda     ($FE,x)                         ; AFD2 A1 FE                    ..
        .byte   $32                             ; AFD4 32                       2
        iny                                     ; AFD5 C8                       .
        .byte   $9E                             ; AFD6 9E                       .
        brk                                     ; AFD7 00                       .
        txs                                     ; AFD8 9A                       .
        .byte   $F4                             ; AFD9 F4                       .
        cpy     #$C2                            ; AFDA C0 C2                    ..
        cpy     #$B8                            ; AFDC C0 B8                    ..
        .byte   $DC                             ; AFDE DC                       .
        brk                                     ; AFDF 00                       .
        dex                                     ; AFE0 CA                       .
        dex                                     ; AFE1 CA                       .
        lda     ($78,x)                         ; AFE2 A1 78                    .x
        sei                                     ; AFE4 78                       x
        .byte   $DC                             ; AFE5 DC                       .
        nop                                     ; AFE6 EA                       .
        nop                                     ; AFE7 EA                       .
        .byte   $82                             ; AFE8 82                       .
        .byte   $82                             ; AFE9 82                       .
        .byte   $B3                             ; AFEA B3                       .
        lda     ($A1,x)                         ; AFEB A1 A1                    ..
        .byte   $D4                             ; AFED D4                       .
        dec     $E6,x                           ; AFEE D6 E6                    ..
        stx     $88                             ; AFF0 86 88                    ..
        cli                                     ; AFF2 58                       X
        cli                                     ; AFF3 58                       X
        .byte   $E7                             ; AFF4 E7                       .
        lsr     $7C,x                           ; AFF5 56 7C                    V|
        .byte   $7F                             ; AFF7 7F                       .
        dec     $3636,x                         ; AFF8 DE 36 36                 .66
        rol     $CE,x                           ; AFFB 36 CE                    6.
LAFFD:  cli                                     ; AFFD 58                       X
        .byte   $7C                             ; AFFE 7C                       |
        .byte   $7F                             ; AFFF 7F                       .
        brk                                     ; B000 00                       .
        bpl     LB004                           ; B001 10 01                    ..
        .byte   $12                             ; B003 12                       .
LB004:  .byte   $12                             ; B004 12                       .
        ora     ($FD,x)                         ; B005 01 FD                    ..
        bcc     LB019                           ; B007 90 10                    ..
        bpl     LAF9B                           ; B009 10 90                    ..
        .byte   $93                             ; B00B 93                       .
        sta     $3F,x                           ; B00C 95 3F                    .?
        .byte   $3F                             ; B00E 3F                       ?
        brk                                     ; B00F 00                       .
        bpl     LB024                           ; B010 10 12                    ..
        lda     ($B3),y                         ; B012 B1 B3                    ..
        lda     $08,x                           ; B014 B5 08                    ..
        brk                                     ; B016 00                       .
        bcc     LB019                           ; B017 90 00                    ..
LB019:  ora     ($D1,x)                         ; B019 01 D1                    ..
        ldy     $C5,x                           ; B01B B4 C5                    ..
        cmp     $C5                             ; B01D C5 C5                    ..
        sbc     L0006                           ; B01F E5 06                    ..
        txs                                     ; B021 9A                       .
        beq     LB067                           ; B022 F0 43                    .C
LB024:  .byte   $43                             ; B024 43                       C
        cpx     $E5F7                           ; B025 EC F7 E5                 ...
        tsx                                     ; B028 BA                       .
        .byte   $8B                             ; B029 8B                       .
        .byte   $FB                             ; B02A FB                       .
        .byte   $43                             ; B02B 43                       C
        .byte   $82                             ; B02C 82                       .
        .byte   $FC                             ; B02D FC                       .
        cmp     $8CF5,x                         ; B02E DD F5 8C                 ...
        stx     $9696                           ; B031 8E 96 96                 ...
        dey                                     ; B034 88                       .
        dey                                     ; B035 88                       .
        .byte   $D2                             ; B036 D2                       .
        .byte   $F3                             ; B037 F3                       .
        ldy     $968F,x                         ; B038 BC 8F 96                 ...
        tya                                     ; B03B 98                       .
        .byte   $43                             ; B03C 43                       C
        brk                                     ; B03D 00                       .
        .byte   $F3                             ; B03E F3                       .
        brk                                     ; B03F 00                       .
        sta     $898F,x                         ; B040 9D 8F 89                 ...
        .byte   $F3                             ; B043 F3                       .
        brk                                     ; B044 00                       .
        .byte   $64                             ; B045 64                       d
        .byte   $3A                             ; B046 3A                       :
        .byte   $3B                             ; B047 3B                       ;
        brk                                     ; B048 00                       .
        brk                                     ; B049 00                       .
        .byte   $B7                             ; B04A B7                       .
        brk                                     ; B04B 00                       .
        .byte   $FF                             ; B04C FF                       .
        .byte   $DC                             ; B04D DC                       .
        .byte   $6B                             ; B04E 6B                       k
        adc     ($D3,x)                         ; B04F 61 D3                    a.
        lda     $D9D7,x                         ; B051 BD D7 D9                 ...
        cmp     #$CA                            ; B054 C9 CA                    ..
        sbc     $1FFE,x                         ; B056 FD FE 1F                 ...
        rol     $0900                           ; B059 2E 00 09                 ...
        sbc     $3128,y                         ; B05C F9 28 31                 .(1
        .byte   $31                             ; B05F 31                       1
LB060:  .byte   $2F                             ; B060 2F                       /
        .byte   $32                             ; B061 32                       2
        .byte   $DF                             ; B062 DF                       .
        asl     $27E9                           ; B063 0E E9 27                 ..'
        .byte   $3A                             ; B066 3A                       :
LB067:  .byte   $3A                             ; B067 3A                       :
        .byte   $43                             ; B068 43                       C
        .byte   $52                             ; B069 52                       R
        .byte   $32                             ; B06A 32                       2
        .byte   $53                             ; B06B 53                       S
        brk                                     ; B06C 00                       .
        pha                                     ; B06D 48                       H
        ora     $413B,x                         ; B06E 1D 3B 41                 .;A
        .byte   $32                             ; B071 32                       2
        .byte   $32                             ; B072 32                       2
        .byte   $54                             ; B073 54                       T
        .byte   $43                             ; B074 43                       C
        sta     ($48,x)                         ; B075 81 48                    .H
        .byte   $43                             ; B077 43                       C
        .byte   $3A                             ; B078 3A                       :
        inc     $32FF                           ; B079 EE FF 32                 ..2
        .byte   $53                             ; B07C 53                       S
        brk                                     ; B07D 00                       .
        lsr     $81                             ; B07E 46 81                    F.
        .byte   $43                             ; B080 43                       C
        .byte   $43                             ; B081 43                       C
        .byte   $43                             ; B082 43                       C
        .byte   $34                             ; B083 34                       4
        and     $70,x                           ; B084 35 70                    5p
        .byte   $7A                             ; B086 7A                       z
        .byte   $7A                             ; B087 7A                       z
        .byte   $43                             ; B088 43                       C
        .byte   $43                             ; B089 43                       C
        .byte   $7A                             ; B08A 7A                       z
        .byte   $43                             ; B08B 43                       C
        .byte   $5A                             ; B08C 5A                       Z
        .byte   $5B                             ; B08D 5B                       [
        .byte   $7A                             ; B08E 7A                       z
        sei                                     ; B08F 78                       x
        .byte   $1B                             ; B090 1B                       .
        .byte   $1B                             ; B091 1B                       .
        .byte   $1B                             ; B092 1B                       .
        .byte   $13                             ; B093 13                       .
        cli                                     ; B094 58                       X
        cli                                     ; B095 58                       X
        .byte   $3A                             ; B096 3A                       :
        and     $82CD,y                         ; B097 39 CD 82                 9..
        brk                                     ; B09A 00                       .
        .byte   $22                             ; B09B 22                       "
        brk                                     ; B09C 00                       .
        .byte   $17                             ; B09D 17                       .
        php                                     ; B09E 08                       .
        .byte   $AB                             ; B09F AB                       .
        lda     (L0000,x)                       ; B0A0 A1 00                    ..
LB0A2:  ror     $67                             ; B0A2 66 67                    fg
        .byte   $43                             ; B0A4 43                       C
        lsr     a                               ; B0A5 4A                       J
        jmp     L0043                           ; B0A6 4C 43 00                 LC.

; ----------------------------------------------------------------------------
        brk                                     ; B0A9 00                       .
        cli                                     ; B0AA 58                       X
        brk                                     ; B0AB 00                       .
        eor     LAD5F,x                         ; B0AC 5D 5F AD                 ]_.
        brk                                     ; B0AF 00                       .
        brk                                     ; B0B0 00                       .
        brk                                     ; B0B1 00                       .
        brk                                     ; B0B2 00                       .
        eor     LBD5F,x                         ; B0B3 5D 5F BD                 ]_.
        lda     $65E6                           ; B0B6 AD E6 65                 ..e
        adc     $CD                             ; B0B9 65 CD                    e.
        .byte   $3A                             ; B0BB 3A                       :
        .byte   $3A                             ; B0BC 3A                       :
        and     $E6E6,y                         ; B0BD 39 E6 E6                 9..
        tya                                     ; B0C0 98                       .
        .byte   $80                             ; B0C1 80                       .
        .byte   $82                             ; B0C2 82                       .
        sty     L0098                           ; B0C3 84 98                    ..
        .byte   $87                             ; B0C5 87                       .
        .byte   $89                             ; B0C6 89                       .
        bcs     LB0C9                           ; B0C7 B0 00                    ..
LB0C9:  brk                                     ; B0C9 00                       .
        brk                                     ; B0CA 00                       .
        brk                                     ; B0CB 00                       .
        brk                                     ; B0CC 00                       .
        stx     L0000,y                         ; B0CD 96 00                    ..
        ror     $9D9B,x                         ; B0CF 7E 9B 9D                 ~..
        lda     ($32,x)                         ; B0D2 A1 32                    .2
        .byte   $C7                             ; B0D4 C7                       .
        cmp     #$9F                            ; B0D5 C9 9F                    ..
        brk                                     ; B0D7 00                       .
        .byte   $F3                             ; B0D8 F3                       .
        sbc     $C1,x                           ; B0D9 F5 C1                    ..
        cpy     #$C0                            ; B0DB C0 C0                    ..
        lda     $FDDD,y                         ; B0DD B9 DD FD                 ...
        dex                                     ; B0E0 CA                       .
        cpy     $D1A1                           ; B0E1 CC A1 D1                 ...
        sei                                     ; B0E4 78                       x
        nop                                     ; B0E5 EA                       .
        .byte   $EB                             ; B0E6 EB                       .
        cmp     $8282,x                         ; B0E7 DD 82 82                 ...
        lda     ($C3,x)                         ; B0EA A1 C3                    ..
        lda     ($D6,x)                         ; B0EC A1 D6                    ..
        .byte   $D7                             ; B0EE D7                       .
        inc     $87                             ; B0EF E6 87                    ..
        .byte   $89                             ; B0F1 89                       .
        cli                                     ; B0F2 58                       X
        cli                                     ; B0F3 58                       X
        inc     $56                             ; B0F4 E6 56                    .V
        adc     $DF7C,x                         ; B0F6 7D 7C DF                 }|.
        ora     $1919,y                         ; B0F9 19 19 19                 ...
        .byte   $CF                             ; B0FC CF                       .
        cli                                     ; B0FD 58                       X
        adc     $037C,x                         ; B0FE 7D 7C 03                 }|.
        brk                                     ; B101 00                       .
        brk                                     ; B102 00                       .
        brk                                     ; B103 00                       .
        brk                                     ; B104 00                       .
        brk                                     ; B105 00                       .
        brk                                     ; B106 00                       .
        brk                                     ; B107 00                       .
        brk                                     ; B108 00                       .
        brk                                     ; B109 00                       .
        brk                                     ; B10A 00                       .
        .byte   $02                             ; B10B 02                       .
        .byte   $02                             ; B10C 02                       .
        .byte   $02                             ; B10D 02                       .
        .byte   $02                             ; B10E 02                       .
        brk                                     ; B10F 00                       .
        brk                                     ; B110 00                       .
        brk                                     ; B111 00                       .
        .byte   $02                             ; B112 02                       .
        .byte   $02                             ; B113 02                       .
        .byte   $02                             ; B114 02                       .
        ora     (L0000),y                       ; B115 11 00                    ..
        brk                                     ; B117 00                       .
        brk                                     ; B118 00                       .
        brk                                     ; B119 00                       .
        .byte   $02                             ; B11A 02                       .
        .byte   $02                             ; B11B 02                       .
        .byte   $02                             ; B11C 02                       .
        .byte   $02                             ; B11D 02                       .
        .byte   $02                             ; B11E 02                       .
        brk                                     ; B11F 00                       .
        brk                                     ; B120 00                       .
        .byte   $02                             ; B121 02                       .
        .byte   $02                             ; B122 02                       .
        .byte   $02                             ; B123 02                       .
        .byte   $02                             ; B124 02                       .
        .byte   $02                             ; B125 02                       .
        .byte   $02                             ; B126 02                       .
        brk                                     ; B127 00                       .
        brk                                     ; B128 00                       .
        .byte   $02                             ; B129 02                       .
        .byte   $02                             ; B12A 02                       .
        .byte   $02                             ; B12B 02                       .
        brk                                     ; B12C 00                       .
        .byte   $02                             ; B12D 02                       .
        .byte   $02                             ; B12E 02                       .
        brk                                     ; B12F 00                       .
        .byte   $02                             ; B130 02                       .
        .byte   $02                             ; B131 02                       .
        .byte   $02                             ; B132 02                       .
        .byte   $02                             ; B133 02                       .
        .byte   $02                             ; B134 02                       .
        .byte   $02                             ; B135 02                       .
        brk                                     ; B136 00                       .
        brk                                     ; B137 00                       .
        .byte   $02                             ; B138 02                       .
        .byte   $02                             ; B139 02                       .
        .byte   $02                             ; B13A 02                       .
        .byte   $02                             ; B13B 02                       .
        .byte   $02                             ; B13C 02                       .
        brk                                     ; B13D 00                       .
        brk                                     ; B13E 00                       .
        brk                                     ; B13F 00                       .
        .byte   $02                             ; B140 02                       .
        .byte   $02                             ; B141 02                       .
        brk                                     ; B142 00                       .
        brk                                     ; B143 00                       .
        brk                                     ; B144 00                       .
        ora     ($11),y                         ; B145 11 11                    ..
        ora     ($02),y                         ; B147 11 02                    ..
        .byte   $02                             ; B149 02                       .
        .byte   $02                             ; B14A 02                       .
        .byte   $02                             ; B14B 02                       .
        ora     ($11),y                         ; B14C 11 11                    ..
        ora     ($11),y                         ; B14E 11 11                    ..
        brk                                     ; B150 00                       .
        .byte   $02                             ; B151 02                       .
        .byte   $02                             ; B152 02                       .
        .byte   $02                             ; B153 02                       .
        .byte   $02                             ; B154 02                       .
        .byte   $02                             ; B155 02                       .
        ora     ($11),y                         ; B156 11 11                    ..
        ora     ($11),y                         ; B158 11 11                    ..
        ora     ($03),y                         ; B15A 11 03                    ..
        .byte   $03                             ; B15C 03                       .
        ora     ($41,x)                         ; B15D 01 41                    .A
        and     ($11,x)                         ; B15F 21 11                    !.
        brk                                     ; B161 00                       .
        .byte   $03                             ; B162 03                       .
        .byte   $03                             ; B163 03                       .
        .byte   $03                             ; B164 03                       .
        ora     ($11,x)                         ; B165 01 11                    ..
        ora     (L0000),y                       ; B167 11 00                    ..
        brk                                     ; B169 00                       .
        brk                                     ; B16A 00                       .
        brk                                     ; B16B 00                       .
        ora     ($11),y                         ; B16C 11 11                    ..
        ora     ($11),y                         ; B16E 11 11                    ..
        brk                                     ; B170 00                       .
        brk                                     ; B171 00                       .
        brk                                     ; B172 00                       .
        brk                                     ; B173 00                       .
        brk                                     ; B174 00                       .
        ora     ($11,x)                         ; B175 01 11                    ..
        ora     ($11,x)                         ; B177 01 11                    ..
        brk                                     ; B179 00                       .
        brk                                     ; B17A 00                       .
        brk                                     ; B17B 00                       .
        brk                                     ; B17C 00                       .
        ora     ($11),y                         ; B17D 11 11                    ..
        ora     ($02,x)                         ; B17F 01 02                    ..
        .byte   $02                             ; B181 02                       .
        .byte   $02                             ; B182 02                       .
        brk                                     ; B183 00                       .
        brk                                     ; B184 00                       .
        ora     ($01,x)                         ; B185 01 01                    ..
        ora     ($02,x)                         ; B187 01 02                    ..
        .byte   $02                             ; B189 02                       .
        ora     ($02,x)                         ; B18A 01 02                    ..
        .byte   $13                             ; B18C 13                       .
        .byte   $13                             ; B18D 13                       .
        ora     ($01,x)                         ; B18E 01 01                    ..
        .byte   $13                             ; B190 13                       .
        .byte   $13                             ; B191 13                       .
        .byte   $13                             ; B192 13                       .
        .byte   $13                             ; B193 13                       .
        .byte   $13                             ; B194 13                       .
        .byte   $13                             ; B195 13                       .
        ora     ($11),y                         ; B196 11 11                    ..
        .byte   $02                             ; B198 02                       .
        brk                                     ; B199 00                       .
        ora     ($13,x)                         ; B19A 01 13                    ..
        brk                                     ; B19C 00                       .
        ora     ($11),y                         ; B19D 11 11                    ..
        .byte   $02                             ; B19F 02                       .
        .byte   $02                             ; B1A0 02                       .
        brk                                     ; B1A1 00                       .
        .byte   $12                             ; B1A2 12                       .
        .byte   $12                             ; B1A3 12                       .
        ora     ($13,x)                         ; B1A4 01 13                    ..
        .byte   $13                             ; B1A6 13                       .
        .byte   $02                             ; B1A7 02                       .
        brk                                     ; B1A8 00                       .
        brk                                     ; B1A9 00                       .
        .byte   $03                             ; B1AA 03                       .
        brk                                     ; B1AB 00                       .
        .byte   $02                             ; B1AC 02                       .
        .byte   $02                             ; B1AD 02                       .
        brk                                     ; B1AE 00                       .
        brk                                     ; B1AF 00                       .
        brk                                     ; B1B0 00                       .
        brk                                     ; B1B1 00                       .
        brk                                     ; B1B2 00                       .
        .byte   $03                             ; B1B3 03                       .
        .byte   $03                             ; B1B4 03                       .
        .byte   $02                             ; B1B5 02                       .
        brk                                     ; B1B6 00                       .
        .byte   $13                             ; B1B7 13                       .
        .byte   $03                             ; B1B8 03                       .
        .byte   $03                             ; B1B9 03                       .
        .byte   $02                             ; B1BA 02                       .
        .byte   $03                             ; B1BB 03                       .
        .byte   $03                             ; B1BC 03                       .
        .byte   $03                             ; B1BD 03                       .
        .byte   $13                             ; B1BE 13                       .
        .byte   $13                             ; B1BF 13                       .
        ora     ($11),y                         ; B1C0 11 11                    ..
        ora     ($11),y                         ; B1C2 11 11                    ..
        ora     ($11),y                         ; B1C4 11 11                    ..
        ora     (L0000),y                       ; B1C6 11 00                    ..
        ora     ($11),y                         ; B1C8 11 11                    ..
        ora     ($11),y                         ; B1CA 11 11                    ..
        ora     ($11),y                         ; B1CC 11 11                    ..
        ora     ($11),y                         ; B1CE 11 11                    ..
        .byte   $13                             ; B1D0 13                       .
        .byte   $13                             ; B1D1 13                       .
        .byte   $02                             ; B1D2 02                       .
        .byte   $02                             ; B1D3 02                       .
        .byte   $02                             ; B1D4 02                       .
        ora     ($F1),y                         ; B1D5 11 F1                    ..
        brk                                     ; B1D7 00                       .
        .byte   $13                             ; B1D8 13                       .
        .byte   $13                             ; B1D9 13                       .
        .byte   $02                             ; B1DA 02                       .
        .byte   $02                             ; B1DB 02                       .
        .byte   $02                             ; B1DC 02                       .
        ora     ($11),y                         ; B1DD 11 11                    ..
        brk                                     ; B1DF 00                       .
        .byte   $13                             ; B1E0 13                       .
        .byte   $13                             ; B1E1 13                       .
        .byte   $02                             ; B1E2 02                       .
        .byte   $02                             ; B1E3 02                       .
        .byte   $02                             ; B1E4 02                       .
        ora     ($11),y                         ; B1E5 11 11                    ..
        ora     ($11),y                         ; B1E7 11 11                    ..
        ora     ($02),y                         ; B1E9 11 02                    ..
        .byte   $02                             ; B1EB 02                       .
        .byte   $02                             ; B1EC 02                       .
        .byte   $02                             ; B1ED 02                       .
        .byte   $02                             ; B1EE 02                       .
        .byte   $13                             ; B1EF 13                       .
        ora     ($11),y                         ; B1F0 11 11                    ..
        .byte   $13                             ; B1F2 13                       .
        .byte   $13                             ; B1F3 13                       .
        .byte   $13                             ; B1F4 13                       .
        .byte   $13                             ; B1F5 13                       .
        .byte   $12                             ; B1F6 12                       .
        .byte   $12                             ; B1F7 12                       .
        ora     ($02,x)                         ; B1F8 01 02                    ..
        ora     ($12),y                         ; B1FA 11 12                    ..
        ora     ($13),y                         ; B1FC 11 13                    ..
        .byte   $12                             ; B1FE 12                       .
        .byte   $12                             ; B1FF 12                       .
        .byte   $02                             ; B200 02                       .
        ora     ($08,x)                         ; B201 01 08                    ..
        .byte   $02                             ; B203 02                       .
        jsr     L2837                           ; B204 20 37 28                  7(
        rol     L0000,x                         ; B207 36 00                    6.
        bvc     LB248                           ; B209 50 3D                    P=
        adc     $5050,y                         ; B20B 79 50 50                 yPP
        bvc     LB260                           ; B20E 50 50                    PP
        brk                                     ; B210 00                       .
        brk                                     ; B211 00                       .
        brk                                     ; B212 00                       .
        brk                                     ; B213 00                       .
        brk                                     ; B214 00                       .
        brk                                     ; B215 00                       .
        .byte   $0B                             ; B216 0B                       .
        .byte   $0C                             ; B217 0C                       .
        brk                                     ; B218 00                       .
        brk                                     ; B219 00                       .
        ora     a:$0E                           ; B21A 0D 0E 00                 ...
        brk                                     ; B21D 00                       .
        asl     $010E                           ; B21E 0E 0E 01                 ...
        .byte   $03                             ; B221 03                       .
        .byte   $03                             ; B222 03                       .
        ora     #$20                            ; B223 09 20                    . 
        rol     $1F28,x                         ; B225 3E 28 1F                 >(.
        .byte   $3F                             ; B228 3F                       ?
        brk                                     ; B229 00                       .
        .byte   $1F                             ; B22A 1F                       .
        brk                                     ; B22B 00                       .
        bvc     LB22E                           ; B22C 50 00                    P.
LB22E:  adc     L0000,y                         ; B22E 79 00 00                 y..
        .byte   $12                             ; B231 12                       .
        brk                                     ; B232 00                       .
        .byte   $1A                             ; B233 1A                       .
        .byte   $13                             ; B234 13                       .
        .byte   $14                             ; B235 14                       .
        .byte   $1B                             ; B236 1B                       .
        .byte   $1C                             ; B237 1C                       .
        dey                                     ; B238 88                       .
        dey                                     ; B239 88                       .
LB23A:  ora     $881E,x                         ; B23A 1D 1E 88                 ...
        dey                                     ; B23D 88                       .
        asl     $091E,x                         ; B23E 1E 1E 09                 ...
        ora     ($01,x)                         ; B241 01 01                    ..
        ora     (L0020,x)                       ; B243 01 20                    . 
        .byte   $27                             ; B245 27                       '
        plp                                     ; B246 28                       (
        .byte   $2F                             ; B247 2F                       /
LB248:  .byte   $27                             ; B248 27                       '
        brk                                     ; B249 00                       .
        .byte   $2F                             ; B24A 2F                       /
        asl     $21,x                           ; B24B 16 21                    .!
        .byte   $22                             ; B24D 22                       "
        .byte   $29                             ; B24E 29                       )
LB24F:  rol     a                               ; B24F 2A                       *
        .byte   $23                             ; B250 23                       #
        dey                                     ; B251 88                       .
        .byte   $2B                             ; B252 2B                       +
        dey                                     ; B253 88                       .
        and     $26                             ; B254 25 26                    %&
        and     $F92E                           ; B256 2D 2E F9                 -..
        dey                                     ; B259 88                       .
        sbc     $0188,y                         ; B25A F9 88 01                 ...
        ora     ($01,x)                         ; B25D 01 01                    ..
        .byte   $01                             ; B25F 01                       .
LB260:  jsr     L2843                           ; B260 20 43 28                  C(
        .byte   $37                             ; B263 37                       7
        .byte   $44                             ; B264 44                       D
        brk                                     ; B265 00                       .
        brk                                     ; B266 00                       .
        brk                                     ; B267 00                       .
        brk                                     ; B268 00                       .
        bmi     LB26B                           ; B269 30 00                    0.
LB26B:  sec                                     ; B26B 38                       8
        and     ($32),y                         ; B26C 31 32                    12
        and     $333A,y                         ; B26E 39 3A 33                 9:3
        .byte   $34                             ; B271 34                       4
        .byte   $3B                             ; B272 3B                       ;
        .byte   $3C                             ; B273 3C                       <
        and     $35,x                           ; B274 35 35                    55
        dey                                     ; B276 88                       .
        dey                                     ; B277 88                       .
        jsr     L2037                           ; B278 20 37 20                  7 
        .byte   $37                             ; B27B 37                       7
        ldx     LB6AE                           ; B27C AE AE B6                 ...
        ldx     $AF,y                           ; B27F B6 AF                    ..
        rti                                     ; B281 40                       @

; ----------------------------------------------------------------------------
        .byte   $AF                             ; B282 AF                       .
        pha                                     ; B283 48                       H
        eor     ($3B,x)                         ; B284 41 3B                    A;
        eor     #$49                            ; B286 49 49                    II
        .byte   $3C                             ; B288 3C                       <
        dey                                     ; B289 88                       .
        lsr     a                               ; B28A 4A                       J
        .byte   $4B                             ; B28B 4B                       K
        dey                                     ; B28C 88                       .
        dey                                     ; B28D 88                       .
        eor     #$49                            ; B28E 49 49                    II
        dey                                     ; B290 88                       .
        dey                                     ; B291 88                       .
        lsr     a                               ; B292 4A                       J
        .byte   $4B                             ; B293 4B                       K
        asl     a                               ; B294 0A                       .
        asl     a                               ; B295 0A                       .
        .byte   $0F                             ; B296 0F                       .
        .byte   $0F                             ; B297 0F                       .
        .byte   $07                             ; B298 07                       .
        .byte   $17                             ; B299 17                       .
        .byte   $0F                             ; B29A 0F                       .
        .byte   $0F                             ; B29B 0F                       .
        .byte   $17                             ; B29C 17                       .
        .byte   $17                             ; B29D 17                       .
        .byte   $0F                             ; B29E 0F                       .
        .byte   $0F                             ; B29F 0F                       .
        .byte   $17                             ; B2A0 17                       .
        brk                                     ; B2A1 00                       .
        .byte   $0F                             ; B2A2 0F                       .
        .byte   $0F                             ; B2A3 0F                       .
        .byte   $52                             ; B2A4 52                       R
        .byte   $53                             ; B2A5 53                       S
        .byte   $0F                             ; B2A6 0F                       .
        .byte   $0F                             ; B2A7 0F                       .
        .byte   $54                             ; B2A8 54                       T
        eor     $0F,x                           ; B2A9 55 0F                    U.
        .byte   $0F                             ; B2AB 0F                       .
        lsr     $4C4F                           ; B2AC 4E 4F 4C                 NOL
        eor     $4F4E                           ; B2AF 4D 4E 4F                 MNO
        lsr     $57,x                           ; B2B2 56 57                    VW
        eor     $45                             ; B2B4 45 45                    EE
        stx     $97,y                           ; B2B6 96 97                    ..
        eor     $45                             ; B2B8 45 45                    EE
        .byte   $77                             ; B2BA 77                       w
        ora     $56,x                           ; B2BB 15 56                    .V
        .byte   $57                             ; B2BD 57                       W
        lsr     $57,x                           ; B2BE 56 57                    VW
        stx     $97,y                           ; B2C0 96 97                    ..
        stx     $97,y                           ; B2C2 96 97                    ..
        .byte   $FA                             ; B2C4 FA                       .
        .byte   $FC                             ; B2C5 FC                       .
        .byte   $FA                             ; B2C6 FA                       .
        .byte   $9E                             ; B2C7 9E                       .
        .byte   $5C                             ; B2C8 5C                       \
        .byte   $5B                             ; B2C9 5B                       [
        .byte   $64                             ; B2CA 64                       d
        .byte   $5B                             ; B2CB 5B                       [
        .byte   $5B                             ; B2CC 5B                       [
        .byte   $5B                             ; B2CD 5B                       [
        .byte   $5B                             ; B2CE 5B                       [
        .byte   $5B                             ; B2CF 5B                       [
        .byte   $5B                             ; B2D0 5B                       [
        .byte   $5C                             ; B2D1 5C                       \
        .byte   $5B                             ; B2D2 5B                       [
        .byte   $64                             ; B2D3 64                       d
        .byte   $B3                             ; B2D4 B3                       .
        ldy     $5B,x                           ; B2D5 B4 5B                    .[
        .byte   $5B                             ; B2D7 5B                       [
        .byte   $62                             ; B2D8 62                       b
        .byte   $5B                             ; B2D9 5B                       [
        .byte   $62                             ; B2DA 62                       b
        .byte   $5B                             ; B2DB 5B                       [
        .byte   $5B                             ; B2DC 5B                       [
        .byte   $62                             ; B2DD 62                       b
        .byte   $5B                             ; B2DE 5B                       [
        .byte   $62                             ; B2DF 62                       b
        .byte   $5C                             ; B2E0 5C                       \
        tax                                     ; B2E1 AA                       .
        .byte   $64                             ; B2E2 64                       d
        bit     $AA                             ; B2E3 24 AA                    $.
        tax                                     ; B2E5 AA                       .
        bit     $24                             ; B2E6 24 24                    $$
        tax                                     ; B2E8 AA                       .
        .byte   $5C                             ; B2E9 5C                       \
        bit     $64                             ; B2EA 24 64                    $d
        .byte   $62                             ; B2EC 62                       b
        dey                                     ; B2ED 88                       .
        .byte   $62                             ; B2EE 62                       b
        eor     #$88                            ; B2EF 49 88                    I.
        .byte   $62                             ; B2F1 62                       b
        eor     #$62                            ; B2F2 49 62                    Ib
        brk                                     ; B2F4 00                       .
        brk                                     ; B2F5 00                       .
        .byte   $0F                             ; B2F6 0F                       .
        .byte   $0F                             ; B2F7 0F                       .
        .byte   $62                             ; B2F8 62                       b
        eor     $62,x                           ; B2F9 55 62                    Ub
        .byte   $0F                             ; B2FB 0F                       .
        brk                                     ; B2FC 00                       .
        .byte   $62                             ; B2FD 62                       b
        .byte   $0F                             ; B2FE 0F                       .
        .byte   $62                             ; B2FF 62                       b
        .byte   $62                             ; B300 62                       b
        .byte   $5B                             ; B301 5B                       [
        .byte   $62                             ; B302 62                       b
        tax                                     ; B303 AA                       .
        .byte   $5B                             ; B304 5B                       [
        .byte   $5B                             ; B305 5B                       [
        tax                                     ; B306 AA                       .
        tax                                     ; B307 AA                       .
        .byte   $5B                             ; B308 5B                       [
        .byte   $62                             ; B309 62                       b
        tax                                     ; B30A AA                       .
        .byte   $62                             ; B30B 62                       b
        brk                                     ; B30C 00                       .
        .byte   $5F                             ; B30D 5F                       _
        asl     $605F                           ; B30E 0E 5F 60                 ._`
        rts                                     ; B311 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B312 60                       `

; ----------------------------------------------------------------------------
        rts                                     ; B313 60                       `

; ----------------------------------------------------------------------------
        dey                                     ; B314 88                       .
        .byte   $5F                             ; B315 5F                       _
        asl     $885F,x                         ; B316 1E 5F 88                 ._.
        .byte   $5F                             ; B319 5F                       _
        dey                                     ; B31A 88                       .
        .byte   $5F                             ; B31B 5F                       _
        and     $5F,x                           ; B31C 35 5F                    5_
        dey                                     ; B31E 88                       .
        .byte   $5F                             ; B31F 5F                       _
        dey                                     ; B320 88                       .
        .byte   $5F                             ; B321 5F                       _
        lsr     a                               ; B322 4A                       J
        .byte   $5F                             ; B323 5F                       _
        .byte   $52                             ; B324 52                       R
        .byte   $5F                             ; B325 5F                       _
        .byte   $0F                             ; B326 0F                       .
        .byte   $5F                             ; B327 5F                       _
        ora     ($08,x)                         ; B328 01 08                    ..
        ora     ($01,x)                         ; B32A 01 01                    ..
        plp                                     ; B32C 28                       (
        pla                                     ; B32D 68                       h
        jsr     L6868                           ; B32E 20 68 68                  hh
        pla                                     ; B331 68                       h
        pla                                     ; B332 68                       h
        pla                                     ; B333 68                       h
        ora     ($04,x)                         ; B334 01 04                    ..
        .byte   $03                             ; B336 03                       .
        ora     #$05                            ; B337 09 05                    ..
        ora     ($08,x)                         ; B339 01 08                    ..
        .byte   $02                             ; B33B 02                       .
        plp                                     ; B33C 28                       (
        .byte   $7F                             ; B33D 7F                       .
        jsr     L8675                           ; B33E 20 75 86                  u.
        .byte   $87                             ; B341 87                       .
        .byte   $8F                             ; B342 8F                       .
        .byte   $8F                             ; B343 8F                       .
        sta     $86                             ; B344 85 86                    ..
        .byte   $8F                             ; B346 8F                       .
        .byte   $8F                             ; B347 8F                       .
        ora     ($03,x)                         ; B348 01 03                    ..
        .byte   $03                             ; B34A 03                       .
        ora     ($28,x)                         ; B34B 01 28                    .(
        adc     L0020,x                         ; B34D 75 20                    u 
        adc     $8F,x                           ; B34F 75 8F                    u.
        .byte   $8F                             ; B351 8F                       .
        .byte   $8F                             ; B352 8F                       .
        .byte   $8F                             ; B353 8F                       .
        plp                                     ; B354 28                       (
        adc     L0020,x                         ; B355 75 20                    u 
        brk                                     ; B357 00                       .
        .byte   $8F                             ; B358 8F                       .
        .byte   $8F                             ; B359 8F                       .
        stx     $288E                           ; B35A 8E 8E 28                 ..(
        brk                                     ; B35D 00                       .
        jsr     L0200                           ; B35E 20 00 02                  ..
        .byte   $03                             ; B361 03                       .
        .byte   $04                             ; B362 04                       .
        .byte   $02                             ; B363 02                       .
        brk                                     ; B364 00                       .
        brk                                     ; B365 00                       .
        brk                                     ; B366 00                       .
        lsr     a:L0000,x                       ; B367 5E 00 00                 ^..
        cli                                     ; B36A 58                       X
        cli                                     ; B36B 58                       X
        lda     ($A8),y                         ; B36C B1 A8                    ..
        brk                                     ; B36E 00                       .
        brk                                     ; B36F 00                       .
        lda     #$B0                            ; B370 A9 B0                    ..
        brk                                     ; B372 00                       .
        brk                                     ; B373 00                       .
        lda     ($18),y                         ; B374 B1 18                    ..
        brk                                     ; B376 00                       .
        brk                                     ; B377 00                       .
        clc                                     ; B378 18                       .
        tay                                     ; B379 A8                       .
        brk                                     ; B37A 00                       .
        brk                                     ; B37B 00                       .
        .byte   $9C                             ; B37C 9C                       .
        brk                                     ; B37D 00                       .
LB37E:  brk                                     ; B37E 00                       .
        brk                                     ; B37F 00                       .
        brk                                     ; B380 00                       .
        .byte   $5F                             ; B381 5F                       _
        brk                                     ; B382 00                       .
        .byte   $5F                             ; B383 5F                       _
        .byte   $83                             ; B384 83                       .
LB385:  sty     $68                             ; B385 84 68                    .h
        pla                                     ; B387 68                       h
        pla                                     ; B388 68                       h
        pla                                     ; B389 68                       h
        adc     #$6A                            ; B38A 69 6A                    ij
        pla                                     ; B38C 68                       h
        pla                                     ; B38D 68                       h
        .byte   $6B                             ; B38E 6B                       k
        pla                                     ; B38F 68                       h
        pla                                     ; B390 68                       h
        pla                                     ; B391 68                       h
        .byte   $83                             ; B392 83                       .
        sty     $68                             ; B393 84 68                    .h
        bvs     LB407                           ; B395 70 70                    pp
        adc     ($71,x)                         ; B397 61 71                    aq
        .byte   $72                             ; B399 72                       r
        .byte   $7B                             ; B39A 7B                       {
        .byte   $7B                             ; B39B 7B                       {
        .byte   $73                             ; B39C 73                       s
        .byte   $74                             ; B39D 74                       t
        .byte   $7B                             ; B39E 7B                       {
        .byte   $7C                             ; B39F 7C                       |
        txa                                     ; B3A0 8A                       .
        txa                                     ; B3A1 8A                       .
        .byte   $8F                             ; B3A2 8F                       .
        .byte   $8F                             ; B3A3 8F                       .
        .byte   $87                             ; B3A4 87                       .
        sta     $8F                             ; B3A5 85 8F                    ..
        .byte   $8F                             ; B3A7 8F                       .
        brk                                     ; B3A8 00                       .
        brk                                     ; B3A9 00                       .
        lsr     $6F                             ; B3AA 46 6F                    Fo
        brk                                     ; B3AC 00                       .
        brk                                     ; B3AD 00                       .
        ror     a:$6E                           ; B3AE 6E 6E 00                 nn.
        brk                                     ; B3B1 00                       .
        .byte   $67                             ; B3B2 67                       g
        .byte   $6F                             ; B3B3 6F                       o
        brk                                     ; B3B4 00                       .
        brk                                     ; B3B5 00                       .
        .byte   $67                             ; B3B6 67                       g
        .byte   $47                             ; B3B7 47                       G
        brk                                     ; B3B8 00                       .
        sty     $9400                           ; B3B9 8C 00 94                 ...
        stx     $97,y                           ; B3BC 96 97                    ..
        inc     $F7,x                           ; B3BE F6 F7                    ..
        .byte   $77                             ; B3C0 77                       w
        .byte   $77                             ; B3C1 77                       w
        .byte   $80                             ; B3C2 80                       .
        .byte   $80                             ; B3C3 80                       .
        stx     $97,y                           ; B3C4 96 97                    ..
        .byte   $80                             ; B3C6 80                       .
        .byte   $80                             ; B3C7 80                       .
        ror     $827E,x                         ; B3C8 7E 7E 82                 ~~.
        sta     ($7E,x)                         ; B3CB 81 7E                    .~
        ror     $8181,x                         ; B3CD 7E 81 81                 ~..
        inc     $FEFF,x                         ; B3D0 FE FF FE                 ...
        .byte   $FF                             ; B3D3 FF                       .
        ldy     $88AD                           ; B3D4 AC AD 88                 ...
        dey                                     ; B3D7 88                       .
        dey                                     ; B3D8 88                       .
        dey                                     ; B3D9 88                       .
        dey                                     ; B3DA 88                       .
        dey                                     ; B3DB 88                       .
        ldx     #$A3                            ; B3DC A2 A3                    ..
        ldx     #$A3                            ; B3DE A2 A3                    ..
        .byte   $8B                             ; B3E0 8B                       .
        .byte   $89                             ; B3E1 89                       .
        .byte   $8B                             ; B3E2 8B                       .
        .byte   $89                             ; B3E3 89                       .
        .byte   $89                             ; B3E4 89                       .
        .byte   $89                             ; B3E5 89                       .
        .byte   $89                             ; B3E6 89                       .
        .byte   $89                             ; B3E7 89                       .
        .byte   $8F                             ; B3E8 8F                       .
        .byte   $8F                             ; B3E9 8F                       .
        bcc     LB37E                           ; B3EA 90 92                    ..
        .byte   $8F                             ; B3EC 8F                       .
        .byte   $8F                             ; B3ED 8F                       .
        .byte   $92                             ; B3EE 92                       .
        .byte   $93                             ; B3EF 93                       .
        .byte   $8F                             ; B3F0 8F                       .
        .byte   $8F                             ; B3F1 8F                       .
        bcc     LB385                           ; B3F2 90 91                    ..
        .byte   $8F                             ; B3F4 8F                       .
        .byte   $8F                             ; B3F5 8F                       .
        .byte   $92                             ; B3F6 92                       .
        sta     ($90),y                         ; B3F7 91 90                    ..
        .byte   $92                             ; B3F9 92                       .
        .byte   $92                             ; B3FA 92                       .
        .byte   $92                             ; B3FB 92                       .
        .byte   $92                             ; B3FC 92                       .
        sta     ($92),y                         ; B3FD 91 92                    ..
        sta     ($92),y                         ; B3FF 91 92                    ..
        .byte   $93                             ; B401 93                       .
        .byte   $92                             ; B402 92                       .
        .byte   $93                             ; B403 93                       .
        sta     $958C                           ; B404 8D 8C 95                 ...
LB407:  sty     $8D,x                           ; B407 94 8D                    ..
        sbc     $95,x                           ; B409 F5 95                    ..
        sbc     $F5F5,x                         ; B40B FD F5 F5                 ...
        sbc     $4CFD,x                         ; B40E FD FD 4C                 ..L
        eor     $8181                           ; B411 4D 81 81                 M..
        ror     $817E,x                         ; B414 7E 7E 81                 ~~.
        .byte   $82                             ; B417 82                       .
        ror     $807E,x                         ; B418 7E 7E 80                 ~~.
        .byte   $80                             ; B41B 80                       .
        .byte   $89                             ; B41C 89                       .
        .byte   $8B                             ; B41D 8B                       .
        .byte   $89                             ; B41E 89                       .
        .byte   $8B                             ; B41F 8B                       .
        sty     $948D                           ; B420 8C 8D 94                 ...
        sta     L0000,x                         ; B423 95 00                    ..
        brk                                     ; B425 00                       .
        adc     $5D                             ; B426 65 5D                    e]
        .byte   $67                             ; B428 67                       g
        .byte   $6F                             ; B429 6F                       o
        .byte   $80                             ; B42A 80                       .
        .byte   $80                             ; B42B 80                       .
        adc     $8076                           ; B42C 6D 76 80                 mv.
        .byte   $80                             ; B42F 80                       .
        .byte   $67                             ; B430 67                       g
        .byte   $47                             ; B431 47                       G
        stx     $97,y                           ; B432 96 97                    ..
        lsr     $6F                             ; B434 46 6F                    Fo
        stx     $97,y                           ; B436 96 97                    ..
        ror     $776E                           ; B438 6E 6E 77                 nnw
        .byte   $77                             ; B43B 77                       w
        .byte   $67                             ; B43C 67                       g
        .byte   $6F                             ; B43D 6F                       o
        stx     $97,y                           ; B43E 96 97                    ..
        ldy     $A4                             ; B440 A4 A4                    ..
        .byte   $80                             ; B442 80                       .
        .byte   $80                             ; B443 80                       .
        ror     $9D                             ; B444 66 9D                    f.
        .byte   $FA                             ; B446 FA                       .
        .byte   $FC                             ; B447 FC                       .
        brk                                     ; B448 00                       .
        brk                                     ; B449 00                       .
        ror     $9D                             ; B44A 66 9D                    f.
        .byte   $FA                             ; B44C FA                       .
        .byte   $9E                             ; B44D 9E                       .
        .byte   $FB                             ; B44E FB                       .
        .byte   $80                             ; B44F 80                       .
        eor     $D5                             ; B450 45 D5                    E.
        eor     $D5                             ; B452 45 D5                    E.
        cmp     $45,x                           ; B454 D5 45                    .E
        cmp     $C2,x                           ; B456 D5 C2                    ..
        eor     $45                             ; B458 45 45                    EE
        .byte   $C2                             ; B45A C2                       .
        .byte   $C2                             ; B45B C2                       .
        eor     $45                             ; B45C 45 45                    EE
        inx                                     ; B45E E8                       .
        sbc     #$D5                            ; B45F E9 D5                    ..
        .byte   $DA                             ; B461 DA                       .
        cmp     $E4,x                           ; B462 D5 E4                    ..
        .byte   $DB                             ; B464 DB                       .
        .byte   $DA                             ; B465 DA                       .
        .byte   $E3                             ; B466 E3                       .
        cpx     $DB                             ; B467 E4 DB                    ..
        .byte   $DA                             ; B469 DA                       .
        cpx     $E4                             ; B46A E4 E4                    ..
        .byte   $DA                             ; B46C DA                       .
        .byte   $DA                             ; B46D DA                       .
        .byte   $E3                             ; B46E E3                       .
        cpx     $D5                             ; B46F E4 D5                    ..
        ldy     #$D5                            ; B471 A0 D5                    ..
        ldy     #$B5                            ; B473 A0 B5                    ..
        tya                                     ; B475 98                       .
        eor     ($BA),y                         ; B476 51 BA                    Q.
        .byte   $D3                             ; B478 D3                       .
        .byte   $D4                             ; B479 D4                       .
        sbc     $EBEE                           ; B47A ED EE EB                 ...
        cpx     $ECEB                           ; B47D EC EB EC                 ...
        .byte   $D2                             ; B480 D2                       .
        .byte   $D2                             ; B481 D2                       .
        .byte   $14                             ; B482 14                       .
        .byte   $D2                             ; B483 D2                       .
        cmp     $A0,x                           ; B484 D5 A0                    ..
        dec     $51A0,x                         ; B486 DE A0 51                 ..Q
        tsx                                     ; B489 BA                       .
        eor     ($BA),y                         ; B48A 51 BA                    Q.
        .byte   $E2                             ; B48C E2                       .
        .byte   $E2                             ; B48D E2                       .
        .byte   $9F                             ; B48E 9F                       .
        .byte   $9F                             ; B48F 9F                       .
        bit     $D72C                           ; B490 2C 2C D7                 ,,.
        .byte   $DF                             ; B493 DF                       .
        bit     a:$A0                           ; B494 2C A0 00                 ,..
LB497:  ldy     #$9F                            ; B497 A0 9F                    ..
        .byte   $9F                             ; B499 9F                       .
        .byte   $9F                             ; B49A 9F                       .
        .byte   $9F                             ; B49B 9F                       .
        .byte   $F1                             ; B49C F1                       .
LB49D:  eor     $6C00,y                         ; B49D 59 00 6C                 Y.l
        .byte   $5A                             ; B4A0 5A                       Z
        .byte   $F0,$7D                    ; B4A1 F0 7D   (branch out of range for ca65: target has no local label)
        brk                                     ; B4A3 00                       .
        sbc     ($C4),y                         ; B4A4 F1 C4                    ..
        brk                                     ; B4A6 00                       .
        cpy     $C2C1                           ; B4A7 CC C1 C2                 ...
        cmp     #$CA                            ; B4AA C9 CA                    ..
        .byte   $C2                             ; B4AC C2                       .
LB4AD:  cpy     $CB                             ; B4AD C4 CB                    ..
        cpy     $C0C0                           ; B4AF CC C0 C0                 ...
        .byte   $C5                             ; B4B2 C5                       .
LB4B3:  dec     $C7                             ; B4B3 C6 C7                    ..
LB4B5:  .byte   $C7                             ; B4B5 C7                       .
        brk                                     ; B4B6 00                       .
        brk                                     ; B4B7 00                       .
        cmp     $CDCE                           ; B4B8 CD CE CD                 ...
LB4BB:  dec     $DADA                           ; B4BB CE DA DA                 ...
        cpx     $E4                             ; B4BE E4 E4                    ..
        .byte   $D2                             ; B4C0 D2                       .
        .byte   $D2                             ; B4C1 D2                       .
        .byte   $D2                             ; B4C2 D2                       .
        .byte   $D2                             ; B4C3 D2                       .
        bne     LB497                           ; B4C4 D0 D1                    ..
        cld                                     ; B4C6 D8                       .
        cmp     $ECEB,y                         ; B4C7 D9 EB EC                 ...
        bne     LB49D                           ; B4CA D0 D1                    ..
        sty     $E08D                           ; B4CC 8C 8D E0                 ...
        sbc     ($D8,x)                         ; B4CF E1 D8                    ..
        cmp     $D1D0,y                         ; B4D1 D9 D0 D1                 ...
        .byte   $9B                             ; B4D4 9B                       .
        .byte   $B7                             ; B4D5 B7                       .
        .byte   $EF                             ; B4D6 EF                       .
        .byte   $F4                             ; B4D7 F4                       .
        cpx     #$E1                            ; B4D8 E0 E1                    ..
        sty     $94,x                           ; B4DA 94 94                    ..
        cld                                     ; B4DC D8                       .
        cmp     $F2F2,y                         ; B4DD D9 F2 F2                 ...
        .byte   $BF                             ; B4E0 BF                       .
        .byte   $BF                             ; B4E1 BF                       .
        .byte   $F4                             ; B4E2 F4                       .
        .byte   $F4                             ; B4E3 F4                       .
        eor     $D5                             ; B4E4 45 D5                    E.
        .byte   $C2                             ; B4E6 C2                       .
        cmp     $DA,x                           ; B4E7 D5 DA                    ..
        cmp     $E4,x                           ; B4E9 D5 E4                    ..
        cmp     $EB,x                           ; B4EB D5 EB                    ..
        cmp     $EB,x                           ; B4ED D5 EB                    ..
        cmp     $EB,x                           ; B4EF D5 EB                    ..
        cmp     $EB,x                           ; B4F1 D5 EB                    ..
        sbc     $CF                             ; B4F3 E5 CF                    ..
        .byte   $CF                             ; B4F5 CF                       .
        inc     $E6                             ; B4F6 E6 E6                    ..
        cpx     #$E1                            ; B4F8 E0 E1                    ..
        sty     $95,x                           ; B4FA 94 95                    ..
        cld                                     ; B4FC D8                       .
        cmp     $F3F2,y                         ; B4FD D9 F2 F3                 ...
        .byte   $EB                             ; B500 EB                       .
        sta     LA1EB,y                         ; B501 99 EB A1                 ...
        bit     $DF2C                           ; B504 2C 2C DF                 ,,.
        .byte   $D7                             ; B507 D7                       .
        cmp     ($F0,x)                         ; B508 C1 F0                    ..
        cmp     #$00                            ; B50A C9 00                    ..
        .byte   $EB                             ; B50C EB                       .
        lda     $EB,x                           ; B50D B5 EB                    ..
        eor     ($EB),y                         ; B50F 51 EB                    Q.
        eor     ($EB),y                         ; B511 51 EB                    Q.
        eor     ($D5),y                         ; B513 51 D5                    Q.
        ldy     #$E7                            ; B515 A0 E7                    ..
        ldy     #$E2                            ; B517 A0 E2                    ..
        .byte   $E2                             ; B519 E2                       .
        bcc     LB4AD                           ; B51A 90 91                    ..
        .byte   $EB                             ; B51C EB                       .
        lda     $92,x                           ; B51D B5 92                    ..
        .byte   $92                             ; B51F 92                       .
        eor     ($BA),y                         ; B520 51 BA                    Q.
        bcc     LB4B5                           ; B522 90 91                    ..
        eor     ($BA),y                         ; B524 51 BA                    Q.
        sta     ($91),y                         ; B526 91 91                    ..
        bcc     LB4BB                           ; B528 90 91                    ..
        sta     ($91),y                         ; B52A 91 91                    ..
        .byte   $92                             ; B52C 92                       .
        .byte   $92                             ; B52D 92                       .
        .byte   $92                             ; B52E 92                       .
        .byte   $92                             ; B52F 92                       .
        tya                                     ; B530 98                       .
        cpx     $ECBA                           ; B531 EC BA EC                 ...
        tsx                                     ; B534 BA                       .
        cpx     $ECBA                           ; B535 EC BA EC                 ...
        tya                                     ; B538 98                       .
        cpx     $9191                           ; B539 EC 91 91                 ...
        .byte   $D2                             ; B53C D2                       .
        .byte   $D2                             ; B53D D2                       .
        .byte   $92                             ; B53E 92                       .
        sta     ($91),y                         ; B53F 91 91                    ..
        sta     ($91),y                         ; B541 91 91                    ..
        sta     (L0006),y                       ; B543 91 06                    ..
        bit     $D7DF                           ; B545 2C DF D7                 ,..
        cpy     #$C0                            ; B548 C0 C0                    ..
        iny                                     ; B54A C8                       .
        iny                                     ; B54B C8                       .
        eor     ($8C),y                         ; B54C 51 8C                    Q.
        eor     ($94),y                         ; B54E 51 94                    Q.
        .byte   $8D                             ; B550 8D                       .
LB551:  sta     $9595                           ; B551 8D 95 95                 ...
        eor     $5F                             ; B554 45 5F                    E_
        .byte   $C2                             ; B556 C2                       .
        .byte   $5F                             ; B557 5F                       _
        .byte   $DB                             ; B558 DB                       .
        .byte   $DB                             ; B559 DB                       .
        .byte   $E3                             ; B55A E3                       .
        .byte   $E3                             ; B55B E3                       .
        .byte   $DA                             ; B55C DA                       .
        .byte   $5F                             ; B55D 5F                       _
        cpx     $5F                             ; B55E E4 5F                    ._
        .byte   $EB                             ; B560 EB                       .
        .byte   $5F                             ; B561 5F                       _
        .byte   $EB                             ; B562 EB                       .
        .byte   $5F                             ; B563 5F                       _
        dec     $D6,x                           ; B564 D6 D6                    ..
        eor     $45                             ; B566 45 45                    EE
        dec     $D6,x                           ; B568 D6 D6                    ..
        .byte   $67                             ; B56A 67                       g
        .byte   $6F                             ; B56B 6F                       o
        dec     L0000,x                         ; B56C D6 00                    ..
        .byte   $6F                             ; B56E 6F                       o
        brk                                     ; B56F 00                       .
        .byte   $77                             ; B570 77                       w
        ora     $FA,x                           ; B571 15 FA                    ..
        .byte   $FC                             ; B573 FC                       .
        .byte   $97                             ; B574 97                       .
        brk                                     ; B575 00                       .
        .byte   $97                             ; B576 97                       .
        brk                                     ; B577 00                       .
        .byte   $FA                             ; B578 FA                       .
        .byte   $9E                             ; B579 9E                       .
        .byte   $FA                             ; B57A FA                       .
        .byte   $9E                             ; B57B 9E                       .
        .byte   $97                             ; B57C 97                       .
        lsr     $5F97,x                         ; B57D 5E 97 5F                 ^._
        .byte   $8F                             ; B580 8F                       .
        .byte   $8F                             ; B581 8F                       .
        lsr     $6F                             ; B582 46 6F                    Fo
        .byte   $8F                             ; B584 8F                       .
        .byte   $8F                             ; B585 8F                       .
        ror     $8F6E                           ; B586 6E 6E 8F                 nn.
        .byte   $8F                             ; B589 8F                       .
        .byte   $67                             ; B58A 67                       g
        .byte   $6F                             ; B58B 6F                       o
        adc     $5D                             ; B58C 65 5D                    e]
        adc     $8F76                           ; B58E 6D 76 8F                 mv.
        .byte   $8F                             ; B591 8F                       .
        sty     $E08D                           ; B592 8C 8D E0                 ...
        sbc     ($E0,x)                         ; B595 E1 E0                    ..
        sbc     ($90,x)                         ; B597 E1 90                    ..
        sta     ($90),y                         ; B599 91 90                    ..
        sta     ($D5),y                         ; B59B 91 D5                    ..
        brk                                     ; B59D 00                       .
        cmp     L0000,x                         ; B59E D5 00                    ..
        cmp     $DA,x                           ; B5A0 D5 DA                    ..
        dec     a:$E4,x                         ; B5A2 DE E4 00                 ...
        ldy     #$00                            ; B5A5 A0 00                    ..
        ldy     #$EC                            ; B5A7 A0 EC                    ..
        cpx     $ECEC                           ; B5A9 EC EC EC                 ...
        cmp     $F5,x                           ; B5AC D5 F5                    ..
        cmp     $FD,x                           ; B5AE D5 FD                    ..
        sta     LA12C,y                         ; B5B0 99 2C A1                 .,.
        .byte   $DF                             ; B5B3 DF                       .
        sbc     $E6                             ; B5B4 E5 E6                    ..
        .byte   $EB                             ; B5B6 EB                       .
        sed                                     ; B5B7 F8                       .
        .byte   $EB                             ; B5B8 EB                       .
        sed                                     ; B5B9 F8                       .
        .byte   $EB                             ; B5BA EB                       .
        sed                                     ; B5BB F8                       .
        brk                                     ; B5BC 00                       .
        brk                                     ; B5BD 00                       .
        bcc     LB551                           ; B5BE 90 91                    ..
        brk                                     ; B5C0 00                       .
        brk                                     ; B5C1 00                       .
        .byte   $92                             ; B5C2 92                       .
        sta     (L0000),y                       ; B5C3 91 00                    ..
        brk                                     ; B5C5 00                       .
        .byte   $92                             ; B5C6 92                       .
        .byte   $93                             ; B5C7 93                       .
LB5C8:  inc     $E6                             ; B5C8 E6 E6                    ..
        bpl     LB5DC                           ; B5CA 10 10                    ..
        inc     $E6                             ; B5CC E6 E6                    ..
        bpl     LB5C8                           ; B5CE 10 F8                    ..
        ora     ($F8,x)                         ; B5D0 01 F8                    ..
        ora     ($F8,x)                         ; B5D2 01 F8                    ..
        cmp     L0010,x                         ; B5D4 D5 10                    ..
        cmp     $01,x                           ; B5D6 D5 01                    ..
        ora     $0810,y                         ; B5D8 19 10 08                 ...
        .byte   $02                             ; B5DB 02                       .
LB5DC:  bpl     LB5EE                           ; B5DC 10 10                    ..
        ora     ($01,x)                         ; B5DE 01 01                    ..
        bpl     LB5F3                           ; B5E0 10 11                    ..
        .byte   $03                             ; B5E2 03                       .
        ora     #$10                            ; B5E3 09 10                    ..
        cmp     $01,x                           ; B5E5 D5 01                    ..
        cmp     $D5,x                           ; B5E7 D5 D5                    ..
        ora     ($D5,x)                         ; B5E9 01 D5                    ..
        ora     ($01,x)                         ; B5EB 01 01                    ..
        .byte   $D5                             ; B5ED D5                       .
LB5EE:  .byte   $03                             ; B5EE 03                       .
        cmp     $05,x                           ; B5EF D5 05                    ..
        cmp     $08,x                           ; B5F1 D5 08                    ..
LB5F3:  cmp     $E7,x                           ; B5F3 D5 E7                    ..
        ora     (L0010,x)                       ; B5F5 01 10                    ..
        .byte   $02                             ; B5F7 02                       .
        ora     ($D5,x)                         ; B5F8 01 D5                    ..
        ora     ($D5,x)                         ; B5FA 01 D5                    ..
        brk                                     ; B5FC 00                       .
        brk                                     ; B5FD 00                       .
        brk                                     ; B5FE 00                       .
        brk                                     ; B5FF 00                       .
        brk                                     ; B600 00                       .
        ora     ($02,x)                         ; B601 01 02                    ..
        .byte   $03                             ; B603 03                       .
        .byte   $04                             ; B604 04                       .
        ora     L0006                           ; B605 05 06                    ..
        .byte   $07                             ; B607 07                       .
        php                                     ; B608 08                       .
        ora     #$0A                            ; B609 09 0A                    ..
        .byte   $0B                             ; B60B 0B                       .
        .byte   $0C                             ; B60C 0C                       .
        ora     $0F0E                           ; B60D 0D 0E 0F                 ...
        bpl     LB623                           ; B610 10 11                    ..
        .byte   $12                             ; B612 12                       .
        .byte   $04                             ; B613 04                       .
        .byte   $13                             ; B614 13                       .
        .byte   $14                             ; B615 14                       .
        ora     $16,x                           ; B616 15 16                    ..
        .byte   $17                             ; B618 17                       .
        clc                                     ; B619 18                       .
        ora     $1B1A,y                         ; B61A 19 1A 1B                 ...
        .byte   $1C                             ; B61D 1C                       .
        ora     a:$1D,x                         ; B61E 1D 1D 00                 ...
        .byte   $1E                             ; B621 1E                       .
        .byte   $1F                             ; B622 1F                       .
LB623:  jsr     L2221                           ; B623 20 21 22                  !"
        .byte   $23                             ; B626 23                       #
        bit     $25                             ; B627 24 25                    $%
        rol     $27                             ; B629 26 27                    &'
        .byte   $27                             ; B62B 27                       '
        plp                                     ; B62C 28                       (
        and     #$2A                            ; B62D 29 2A                    )*
        and     #$2B                            ; B62F 29 2B                    )+
        bit     $2E2D                           ; B631 2C 2D 2E                 ,-.
        and     $2D2E                           ; B634 2D 2E 2D                 -.-
        rol     $2F2F                           ; B637 2E 2F 2F                 .//
        bmi     LB66D                           ; B63A 30 31                    01
        bmi     LB66F                           ; B63C 30 31                    01
        bmi     LB671                           ; B63E 30 31                    01
        .byte   $07                             ; B640 07                       .
        .byte   $32                             ; B641 32                       2
        .byte   $33                             ; B642 33                       3
        .byte   $33                             ; B643 33                       3
        .byte   $33                             ; B644 33                       3
        .byte   $34                             ; B645 34                       4
        .byte   $32                             ; B646 32                       2
        .byte   $33                             ; B647 33                       3
        .byte   $0F                             ; B648 0F                       .
        .byte   $32                             ; B649 32                       2
        .byte   $33                             ; B64A 33                       3
        and     $33,x                           ; B64B 35 33                    53
        .byte   $34                             ; B64D 34                       4
        .byte   $32                             ; B64E 32                       2
        .byte   $33                             ; B64F 33                       3
        ora     $36,x                           ; B650 15 36                    .6
        .byte   $33                             ; B652 33                       3
        .byte   $33                             ; B653 33                       3
        .byte   $33                             ; B654 33                       3
        .byte   $37                             ; B655 37                       7
        rol     $33,x                           ; B656 36 33                    63
        ora     $3938,x                         ; B658 1D 38 39                 .89
        and     $3A39,y                         ; B65B 39 39 3A                 99:
        .byte   $32                             ; B65E 32                       2
        .byte   $33                             ; B65F 33                       3
        .byte   $23                             ; B660 23                       #
        .byte   $3B                             ; B661 3B                       ;
        bit     $23                             ; B662 24 23                    $#
        bit     $3C                             ; B664 24 3C                    $<
        rol     $33,x                           ; B666 36 33                    63
        and     $293E,x                         ; B668 3D 3E 29                 =>)
        rol     a                               ; B66B 2A                       *
        .byte   $29                             ; B66C 29                       )
LB66D:  .byte   $3F                             ; B66D 3F                       ?
        rti                                     ; B66E 40                       @

; ----------------------------------------------------------------------------
LB66F:  eor     ($2D,x)                         ; B66F 41 2D                    A-
LB671:  bit     $2C2B                           ; B671 2C 2B 2C                 ,+,
        and     $2D2E                           ; B674 2D 2E 2D                 -.-
        rol     $2F30                           ; B677 2E 30 2F                 .0/
        .byte   $2F                             ; B67A 2F                       /
        .byte   $2F                             ; B67B 2F                       /
        bmi     LB6AF                           ; B67C 30 31                    01
        bmi     LB6B1                           ; B67E 30 31                    01
        .byte   $33                             ; B680 33                       3
        .byte   $33                             ; B681 33                       3
        .byte   $34                             ; B682 34                       4
        .byte   $32                             ; B683 32                       2
        .byte   $33                             ; B684 33                       3
        .byte   $33                             ; B685 33                       3
        .byte   $33                             ; B686 33                       3
        .byte   $34                             ; B687 34                       4
        .byte   $33                             ; B688 33                       3
        .byte   $33                             ; B689 33                       3
        .byte   $34                             ; B68A 34                       4
        .byte   $32                             ; B68B 32                       2
        .byte   $33                             ; B68C 33                       3
        .byte   $33                             ; B68D 33                       3
        .byte   $33                             ; B68E 33                       3
        .byte   $34                             ; B68F 34                       4
        .byte   $33                             ; B690 33                       3
        .byte   $33                             ; B691 33                       3
        .byte   $37                             ; B692 37                       7
        rol     $33,x                           ; B693 36 33                    63
        .byte   $33                             ; B695 33                       3
        .byte   $33                             ; B696 33                       3
        .byte   $37                             ; B697 37                       7
        .byte   $33                             ; B698 33                       3
        .byte   $33                             ; B699 33                       3
        .byte   $34                             ; B69A 34                       4
        .byte   $32                             ; B69B 32                       2
        .byte   $33                             ; B69C 33                       3
        .byte   $33                             ; B69D 33                       3
        .byte   $33                             ; B69E 33                       3
        .byte   $34                             ; B69F 34                       4
        and     $33,x                           ; B6A0 35 33                    53
        .byte   $37                             ; B6A2 37                       7
        rol     $33,x                           ; B6A3 36 33                    63
        and     $33,x                           ; B6A5 35 33                    53
        .byte   $37                             ; B6A7 37                       7
        eor     ($41,x)                         ; B6A8 41 41                    AA
        .byte   $42                             ; B6AA 42                       B
        rti                                     ; B6AB 40                       @

; ----------------------------------------------------------------------------
        eor     ($41,x)                         ; B6AC 41 41                    AA
LB6AE:  .byte   $41                             ; B6AE 41                       A
LB6AF:  .byte   $42                             ; B6AF 42                       B
        .byte   $2D                             ; B6B0 2D                       -
LB6B1:  rol     $2C2D                           ; B6B1 2E 2D 2C                 .-,
        .byte   $2B                             ; B6B4 2B                       +
LB6B5:  bit     $2B2C                           ; B6B5 2C 2C 2B                 ,,+
        bmi     LB6EB                           ; B6B8 30 31                    01
        bmi     LB6EB                           ; B6BA 30 2F                    0/
        .byte   $2F                             ; B6BC 2F                       /
        .byte   $2F                             ; B6BD 2F                       /
        .byte   $2F                             ; B6BE 2F                       /
        .byte   $2F                             ; B6BF 2F                       /
        .byte   $32                             ; B6C0 32                       2
        .byte   $33                             ; B6C1 33                       3
        .byte   $33                             ; B6C2 33                       3
        .byte   $33                             ; B6C3 33                       3
        .byte   $34                             ; B6C4 34                       4
        .byte   $07                             ; B6C5 07                       .
        .byte   $43                             ; B6C6 43                       C
        .byte   $44                             ; B6C7 44                       D
        .byte   $32                             ; B6C8 32                       2
        .byte   $33                             ; B6C9 33                       3
        and     $33,x                           ; B6CA 35 33                    53
        .byte   $34                             ; B6CC 34                       4
        .byte   $0F                             ; B6CD 0F                       .
        eor     $44                             ; B6CE 45 44                    ED
        rol     $33,x                           ; B6D0 36 33                    63
        .byte   $33                             ; B6D2 33                       3
        .byte   $33                             ; B6D3 33                       3
        .byte   $37                             ; B6D4 37                       7
        ora     $46,x                           ; B6D5 15 46                    .F
        .byte   $44                             ; B6D7 44                       D
        sec                                     ; B6D8 38                       8
        and     $3939,y                         ; B6D9 39 39 39                 999
        .byte   $3A                             ; B6DC 3A                       :
        ora     $4447,x                         ; B6DD 1D 47 44                 .GD
        .byte   $3B                             ; B6E0 3B                       ;
        bit     $23                             ; B6E1 24 23                    $#
        bit     $3C                             ; B6E3 24 3C                    $<
        bit     $48                             ; B6E5 24 48                    $H
        .byte   $44                             ; B6E7 44                       D
        rol     $2A29,x                         ; B6E8 3E 29 2A                 >)*
LB6EB:  and     #$3F                            ; B6EB 29 3F                    )?
LB6ED:  and     #$49                            ; B6ED 29 49                    )I
        .byte   $44                             ; B6EF 44                       D
        bit     $2D2C                           ; B6F0 2C 2C 2D                 ,,-
        rol     $2E2D                           ; B6F3 2E 2D 2E                 .-.
        and     $2F2E                           ; B6F6 2D 2E 2F                 -./
        .byte   $2F                             ; B6F9 2F                       /
        bmi     LB72D                           ; B6FA 30 31                    01
        bmi     LB72F                           ; B6FC 30 31                    01
        bmi     LB731                           ; B6FE 30 31                    01
        bpl     LB74C                           ; B700 10 4A                    .J
        brk                                     ; B702 00                       .
        php                                     ; B703 08                       .
        bpl     LB751                           ; B704 10 4B                    .K
        jmp     L174C                           ; B706 4C 4C 17                 LL.

; ----------------------------------------------------------------------------
        .byte   $17                             ; B709 17                       .
        eor     $174E                           ; B70A 4D 4E 17                 MN.
        .byte   $4B                             ; B70D 4B                       K
        jmp     L004C                           ; B70E 4C 4C 00                 LL.

; ----------------------------------------------------------------------------
        php                                     ; B711 08                       .
        bpl     LB75E                           ; B712 10 4A                    .J
        brk                                     ; B714 00                       .
        .byte   $4F                             ; B715 4F                       O
        bvc     LB769                           ; B716 50 51                    PQ
        .byte   $52                             ; B718 52                       R
        brk                                     ; B719 00                       .
        .byte   $17                             ; B71A 17                       .
        .byte   $17                             ; B71B 17                       .
        .byte   $52                             ; B71C 52                       R
        .byte   $53                             ; B71D 53                       S
        .byte   $54                             ; B71E 54                       T
        .byte   $54                             ; B71F 54                       T
        bpl     LB76C                           ; B720 10 4A                    .J
        brk                                     ; B722 00                       .
        php                                     ; B723 08                       .
        bpl     LB77B                           ; B724 10 55                    .U
LB726:  lsr     $56,x                           ; B726 56 56                    VV
        brk                                     ; B728 00                       .
        .byte   $17                             ; B729 17                       .
        eor     $174E                           ; B72A 4D 4E 17                 MN.
LB72D:  .byte   $57                             ; B72D 57                       W
        .byte   $04                             ; B72E 04                       .
LB72F:  .byte   $04                             ; B72F 04                       .
        lsr     a                               ; B730 4A                       J
LB731:  cli                                     ; B731 58                       X
        bpl     LB77E                           ; B732 10 4A                    .J
        cli                                     ; B734 58                       X
        .byte   $57                             ; B735 57                       W
        eor     $5B5A,y                         ; B736 59 5A 5B                 YZ[
        .byte   $5C                             ; B739 5C                       \
        eor     $5C5E,x                         ; B73A 5D 5E 5C                 ]^\
        .byte   $5F                             ; B73D 5F                       _
        rts                                     ; B73E 60                       `

; ----------------------------------------------------------------------------
        .byte   $44                             ; B73F 44                       D
        adc     ($62,x)                         ; B740 61 62                    ab
        .byte   $63                             ; B742 63                       c
        jmp     L4C64                           ; B743 4C 64 4C                 LdL

; ----------------------------------------------------------------------------
        jmp     L654C                           ; B746 4C 4C 65                 LLe

; ----------------------------------------------------------------------------
        ror     $67                             ; B749 66 67                    fg
        .byte   $4C                             ; B74B 4C                       L
LB74C:  .byte   $62                             ; B74C 62                       b
        .byte   $63                             ; B74D 63                       c
        adc     (L004C,x)                       ; B74E 61 4C                    aL
        .byte   $50                             ; B750 50                       P
LB751:  bvc     LB7A4                           ; B751 50 51                    PQ
        pla                                     ; B753 68                       h
        eor     ($68),y                         ; B754 51 68                    Qh
        eor     ($69),y                         ; B756 51 69                    Qi
        .byte   $54                             ; B758 54                       T
        .byte   $54                             ; B759 54                       T
        .byte   $54                             ; B75A 54                       T
        .byte   $54                             ; B75B 54                       T
        .byte   $54                             ; B75C 54                       T
        .byte   $54                             ; B75D 54                       T
LB75E:  .byte   $54                             ; B75E 54                       T
        .byte   $54                             ; B75F 54                       T
        lsr     $56,x                           ; B760 56 56                    VV
        lsr     $56,x                           ; B762 56 56                    VV
        lsr     $56,x                           ; B764 56 56                    VV
        lsr     $56,x                           ; B766 56 56                    VV
        .byte   $04                             ; B768 04                       .
LB769:  ror     a                               ; B769 6A                       j
        .byte   $6B                             ; B76A 6B                       k
        .byte   $6C                             ; B76B 6C                       l
LB76C:  .byte   $6B                             ; B76C 6B                       k
        adc     $6E04                           ; B76D 6D 04 6E                 m.n
        .byte   $5A                             ; B770 5A                       Z
        .byte   $6F                             ; B771 6F                       o
        bvs     LB7E5                           ; B772 70 71                    pq
        bvs     LB7E7                           ; B774 70 71                    pq
        .byte   $72                             ; B776 72                       r
        .byte   $73                             ; B777 73                       s
        .byte   $44                             ; B778 44                       D
        .byte   $74                             ; B779 74                       t
        .byte   $75                             ; B77A 75                       u
LB77B:  ror     $77,x                           ; B77B 76 77                    vw
        .byte   $77                             ; B77D 77                       w
LB77E:  sei                                     ; B77E 78                       x
        adc     $6261,y                         ; B77F 79 61 62                 yab
        .byte   $63                             ; B782 63                       c
        jmp     L4C64                           ; B783 4C 64 4C                 LdL

; ----------------------------------------------------------------------------
        jmp     L654C                           ; B786 4C 4C 65                 LLe

; ----------------------------------------------------------------------------
        ror     $67                             ; B789 66 67                    fg
        jmp     L6362                           ; B78B 4C 62 63                 Lbc

; ----------------------------------------------------------------------------
        adc     (L004C,x)                       ; B78E 61 4C                    aL
        eor     ($50),y                         ; B790 51 50                    QP
        eor     ($68),y                         ; B792 51 68                    Qh
        eor     ($68),y                         ; B794 51 68                    Qh
        eor     ($69),y                         ; B796 51 69                    Qi
        .byte   $54                             ; B798 54                       T
        .byte   $54                             ; B799 54                       T
        .byte   $54                             ; B79A 54                       T
        .byte   $54                             ; B79B 54                       T
        .byte   $7A                             ; B79C 7A                       z
        .byte   $7B                             ; B79D 7B                       {
        .byte   $54                             ; B79E 54                       T
        .byte   $54                             ; B79F 54                       T
        lsr     $56,x                           ; B7A0 56 56                    VV
        .byte   $7C                             ; B7A2 7C                       |
        .byte   $7D                             ; B7A3 7D                       }
LB7A4:  ror     $7F7F,x                         ; B7A4 7E 7F 7F                 ~..
        .byte   $80                             ; B7A7 80                       .
        sta     ($82,x)                         ; B7A8 81 82                    ..
        .byte   $83                             ; B7AA 83                       .
        .byte   $83                             ; B7AB 83                       .
        .byte   $83                             ; B7AC 83                       .
        .byte   $83                             ; B7AD 83                       .
        .byte   $83                             ; B7AE 83                       .
        .byte   $83                             ; B7AF 83                       .
        sty     $73                             ; B7B0 84 73                    .s
        .byte   $73                             ; B7B2 73                       s
        sta     $86                             ; B7B3 85 86                    ..
        stx     $72                             ; B7B5 86 72                    .r
        sty     $79                             ; B7B7 84 79                    .y
        adc     $8779,y                         ; B7B9 79 79 87                 yy.
        asl     $75,x                           ; B7BC 16 75                    .u
        sei                                     ; B7BE 78                       x
        adc     $6261,y                         ; B7BF 79 61 62                 yab
        .byte   $63                             ; B7C2 63                       c
        jmp     L4C64                           ; B7C3 4C 64 4C                 LdL

; ----------------------------------------------------------------------------
        jmp     L654C                           ; B7C6 4C 4C 65                 LLe

; ----------------------------------------------------------------------------
        ror     $67                             ; B7C9 66 67                    fg
        jmp     L6362                           ; B7CB 4C 62 63                 Lbc

; ----------------------------------------------------------------------------
        adc     (L004C,x)                       ; B7CE 61 4C                    aL
        eor     ($50),y                         ; B7D0 51 50                    QP
        eor     ($68),y                         ; B7D2 51 68                    Qh
        eor     ($68),y                         ; B7D4 51 68                    Qh
        eor     ($69),y                         ; B7D6 51 69                    Qi
        .byte   $54                             ; B7D8 54                       T
        .byte   $54                             ; B7D9 54                       T
        .byte   $54                             ; B7DA 54                       T
        .byte   $54                             ; B7DB 54                       T
        .byte   $54                             ; B7DC 54                       T
        .byte   $54                             ; B7DD 54                       T
        .byte   $54                             ; B7DE 54                       T
        .byte   $54                             ; B7DF 54                       T
        lsr     $56,x                           ; B7E0 56 56                    VV
        lsr     $56,x                           ; B7E2 56 56                    VV
        .byte   $56                             ; B7E4 56                       V
LB7E5:  lsr     $56,x                           ; B7E5 56 56                    VV
LB7E7:  lsr     $88,x                           ; B7E7 56 88                    V.
        dey                                     ; B7E9 88                       .
        dey                                     ; B7EA 88                       .
        .byte   $04                             ; B7EB 04                       .
        .byte   $89                             ; B7EC 89                       .
        .byte   $89                             ; B7ED 89                       .
        .byte   $04                             ; B7EE 04                       .
        .byte   $04                             ; B7EF 04                       .
        .byte   $73                             ; B7F0 73                       s
        .byte   $73                             ; B7F1 73                       s
        sta     $8A                             ; B7F2 85 8A                    ..
        .byte   $8B                             ; B7F4 8B                       .
        .byte   $8B                             ; B7F5 8B                       .
        sty     $795A                           ; B7F6 8C 5A 79                 .Zy
        adc     $7787,y                         ; B7F9 79 87 77                 y.w
        adc     $77,x                           ; B7FC 75 77                    uw
        bmi     LB844                           ; B7FE 30 44                    0D
        adc     ($62,x)                         ; B800 61 62                    ab
        .byte   $63                             ; B802 63                       c
        jmp     L4C64                           ; B803 4C 64 4C                 LdL

; ----------------------------------------------------------------------------
        jmp     L654C                           ; B806 4C 4C 65                 LLe

; ----------------------------------------------------------------------------
        ror     $67                             ; B809 66 67                    fg
        jmp     L6362                           ; B80B 4C 62 63                 Lbc

; ----------------------------------------------------------------------------
        adc     (L004C,x)                       ; B80E 61 4C                    aL
        eor     ($50),y                         ; B810 51 50                    QP
        eor     ($68),y                         ; B812 51 68                    Qh
        eor     ($68),y                         ; B814 51 68                    Qh
        eor     ($69),y                         ; B816 51 69                    Qi
        .byte   $54                             ; B818 54                       T
        .byte   $54                             ; B819 54                       T
        .byte   $54                             ; B81A 54                       T
        .byte   $54                             ; B81B 54                       T
        .byte   $54                             ; B81C 54                       T
        .byte   $54                             ; B81D 54                       T
        .byte   $54                             ; B81E 54                       T
        .byte   $54                             ; B81F 54                       T
        lsr     $56,x                           ; B820 56 56                    VV
        lsr     $56,x                           ; B822 56 56                    VV
        lsr     $56,x                           ; B824 56 56                    VV
        lsr     $56,x                           ; B826 56 56                    VV
        .byte   $04                             ; B828 04                       .
        .byte   $04                             ; B829 04                       .
        .byte   $89                             ; B82A 89                       .
        .byte   $89                             ; B82B 89                       .
        .byte   $89                             ; B82C 89                       .
        sta     $8F8E                           ; B82D 8D 8E 8F                 ...
        .byte   $5A                             ; B830 5A                       Z
        sta     $8B8B                           ; B831 8D 8B 8B                 ...
        .byte   $8B                             ; B834 8B                       .
        .byte   $6F                             ; B835 6F                       o
        bcc     LB8A7                           ; B836 90 6F                    .o
        .byte   $44                             ; B838 44                       D
        bmi     LB8B1                           ; B839 30 76                    0v
        adc     $76,x                           ; B83B 75 76                    uv
        .byte   $74                             ; B83D 74                       t
        .byte   $77                             ; B83E 77                       w
        .byte   $74                             ; B83F 74                       t
        adc     ($62,x)                         ; B840 61 62                    ab
        .byte   $63                             ; B842 63                       c
        .byte   $4C                             ; B843 4C                       L
LB844:  .byte   $64                             ; B844 64                       d
        jmp     L4C4C                           ; B845 4C 4C 4C                 LLL

; ----------------------------------------------------------------------------
        adc     $66                             ; B848 65 66                    ef
        .byte   $67                             ; B84A 67                       g
        jmp     L6362                           ; B84B 4C 62 63                 Lbc

; ----------------------------------------------------------------------------
        adc     (L004C,x)                       ; B84E 61 4C                    aL
        eor     ($50),y                         ; B850 51 50                    QP
        eor     ($68),y                         ; B852 51 68                    Qh
        eor     ($68),y                         ; B854 51 68                    Qh
        eor     ($69),y                         ; B856 51 69                    Qi
        .byte   $54                             ; B858 54                       T
        .byte   $54                             ; B859 54                       T
        .byte   $54                             ; B85A 54                       T
        .byte   $54                             ; B85B 54                       T
        .byte   $54                             ; B85C 54                       T
        .byte   $54                             ; B85D 54                       T
        .byte   $54                             ; B85E 54                       T
        .byte   $54                             ; B85F 54                       T
        lsr     $56,x                           ; B860 56 56                    VV
        lsr     $56,x                           ; B862 56 56                    VV
        lsr     $56,x                           ; B864 56 56                    VV
        lsr     $56,x                           ; B866 56 56                    VV
        sta     ($91),y                         ; B868 91 91                    ..
        sty     $8989                           ; B86A 8C 89 89                 ...
        ror     a                               ; B86D 6A                       j
        .byte   $92                             ; B86E 92                       .
        .byte   $6B                             ; B86F 6B                       k
        .byte   $93                             ; B870 93                       .
        .byte   $93                             ; B871 93                       .
        adc     ($8B),y                         ; B872 71 8B                    q.
        .byte   $8B                             ; B874 8B                       .
        .byte   $6F                             ; B875 6F                       o
        .byte   $93                             ; B876 93                       .
        bvs     LB88F                           ; B877 70 16                    p.
        asl     $77,x                           ; B879 16 77                    .w
        .byte   $77                             ; B87B 77                       w
        ror     $74,x                           ; B87C 76 74                    vt
        asl     $76,x                           ; B87E 16 76                    .v
        adc     ($62,x)                         ; B880 61 62                    ab
        .byte   $63                             ; B882 63                       c
        jmp     L4C64                           ; B883 4C 64 4C                 LdL

; ----------------------------------------------------------------------------
        jmp     L654C                           ; B886 4C 4C 65                 LLe

; ----------------------------------------------------------------------------
        ror     $67                             ; B889 66 67                    fg
        jmp     L6362                           ; B88B 4C 62 63                 Lbc

; ----------------------------------------------------------------------------
        .byte   $61                             ; B88E 61                       a
LB88F:  jmp     L5051                           ; B88F 4C 51 50                 LQP

; ----------------------------------------------------------------------------
        eor     ($68),y                         ; B892 51 68                    Qh
        eor     ($68),y                         ; B894 51 68                    Qh
        eor     ($69),y                         ; B896 51 69                    Qi
        .byte   $54                             ; B898 54                       T
        .byte   $54                             ; B899 54                       T
        .byte   $54                             ; B89A 54                       T
        .byte   $54                             ; B89B 54                       T
        .byte   $54                             ; B89C 54                       T
        .byte   $54                             ; B89D 54                       T
        .byte   $54                             ; B89E 54                       T
        .byte   $54                             ; B89F 54                       T
        lsr     $56,x                           ; B8A0 56 56                    VV
        lsr     $56,x                           ; B8A2 56 56                    VV
        lsr     $56,x                           ; B8A4 56 56                    VV
        .byte   $56                             ; B8A6 56                       V
LB8A7:  lsr     $6C,x                           ; B8A7 56 6C                    Vl
        .byte   $92                             ; B8A9 92                       .
        adc     $8989                           ; B8AA 6D 89 89                 m..
        .byte   $89                             ; B8AD 89                       .
        jmp     (L6F04)                         ; B8AE 6C 04 6F                 l.o

; ----------------------------------------------------------------------------
LB8B1:  .byte   $93                             ; B8B1 93                       .
        adc     ($8B),y                         ; B8B2 71 8B                    q.
        .byte   $8B                             ; B8B4 8B                       .
        .byte   $8B                             ; B8B5 8B                       .
        bmi     LB8BC                           ; B8B6 30 04                    0.
        .byte   $74                             ; B8B8 74                       t
        asl     $77,x                           ; B8B9 16 77                    .w
        .byte   $77                             ; B8BB 77                       w
LB8BC:  .byte   $75                             ; B8BC 75                       u
LB8BD:  ror     $30,x                           ; B8BD 76 30                    v0
        .byte   $04                             ; B8BF 04                       .
        sty     $04,x                           ; B8C0 94 04                    ..
        sta     $96,x                           ; B8C2 95 96                    ..
LB8C4:  .byte   $97                             ; B8C4 97                       .
        .byte   $97                             ; B8C5 97                       .
        .byte   $97                             ; B8C6 97                       .
        .byte   $97                             ; B8C7 97                       .
        sty     $04,x                           ; B8C8 94 04                    ..
        tya                                     ; B8CA 98                       .
        sta     $9B9A,y                         ; B8CB 99 9A 9B                 ...
        .byte   $9B                             ; B8CE 9B                       .
        txs                                     ; B8CF 9A                       .
        sty     $04,x                           ; B8D0 94 04                    ..
        .byte   $9C                             ; B8D2 9C                       .
        sta     $9F9E,x                         ; B8D3 9D 9E 9F                 ...
        .byte   $9F                             ; B8D6 9F                       .
        .byte   $9E                             ; B8D7 9E                       .
        sty     $04,x                           ; B8D8 94 04                    ..
        .byte   $9C                             ; B8DA 9C                       .
        sta     $9FA0,x                         ; B8DB 9D A0 9F                 ...
        .byte   $9F                             ; B8DE 9F                       .
        ldy     #$94                            ; B8DF A0 94                    ..
        .byte   $04                             ; B8E1 04                       .
        lda     ($A2,x)                         ; B8E2 A1 A2                    ..
        .byte   $A3                             ; B8E4 A3                       .
        .byte   $9F                             ; B8E5 9F                       .
        .byte   $9F                             ; B8E6 9F                       .
        .byte   $A3                             ; B8E7 A3                       .
        sty     $A4,x                           ; B8E8 94 A4                    ..
        lda     $9D                             ; B8EA A5 9D                    ..
        ldx     $9F                             ; B8EC A6 9F                    ..
        .byte   $9F                             ; B8EE 9F                       .
        ldx     $94                             ; B8EF A6 94                    ..
        .byte   $A7                             ; B8F1 A7                       .
        tay                                     ; B8F2 A8                       .
        lda     #$AA                            ; B8F3 A9 AA                    ..
        .byte   $AB                             ; B8F5 AB                       .
        ldy     $94AA                           ; B8F6 AC AA 94                 ...
LB8F9:  lda     LADAD                           ; B8F9 AD AD AD                 ...
        lda     LAEAD                           ; B8FC AD AD AE                 ...
        lda     $9696                           ; B8FF AD 96 96                 ...
        .byte   $97                             ; B902 97                       .
        .byte   $97                             ; B903 97                       .
        .byte   $97                             ; B904 97                       .
        .byte   $97                             ; B905 97                       .
        stx     $96,y                           ; B906 96 96                    ..
        .byte   $AF                             ; B908 AF                       .
        .byte   $AF                             ; B909 AF                       .
        txs                                     ; B90A 9A                       .
        .byte   $9B                             ; B90B 9B                       .
        .byte   $9B                             ; B90C 9B                       .
        .byte   $AF                             ; B90D AF                       .
        .byte   $AF                             ; B90E AF                       .
        .byte   $AF                             ; B90F AF                       .
        sta     $9E9D,x                         ; B910 9D 9D 9E                 ...
        .byte   $9F                             ; B913 9F                       .
        .byte   $9F                             ; B914 9F                       .
        .byte   $9E                             ; B915 9E                       .
        sta     $9D9D,x                         ; B916 9D 9D 9D                 ...
        ldx     #$B0                            ; B919 A2 B0                    ..
        lda     ($B1),y                         ; B91B B1 B1                    ..
        .byte   $B2                             ; B91D B2                       .
        sta     LA2A2,x                         ; B91E 9D A2 A2                 ...
        sta     LB4B3,x                         ; B921 9D B3 B4                 ...
        ldy     $B4,x                           ; B924 B4 B4                    ..
        ldx     #$B5                            ; B926 A2 B5                    ..
        sta     LB6B5,x                         ; B928 9D B5 B6                 ...
        .byte   $B7                             ; B92B B7                       .
        .byte   $B7                             ; B92C B7                       .
        .byte   $B7                             ; B92D B7                       .
        lda     $B8,x                           ; B92E B5 B8                    ..
        .byte   $AB                             ; B930 AB                       .
        ldy     LABAA                           ; B931 AC AA AB                 ...
        ldy     LABAA                           ; B934 AC AA AB                 ...
        ldy     LAEAD                           ; B937 AC AD AE                 ...
        lda     LAEAD                           ; B93A AD AD AE                 ...
        lda     LAEAD                           ; B93D AD AD AE                 ...
        stx     $97,y                           ; B940 96 97                    ..
        .byte   $97                             ; B942 97                       .
        .byte   $97                             ; B943 97                       .
        .byte   $97                             ; B944 97                       .
        stx     $B9,y                           ; B945 96 B9                    ..
        .byte   $44                             ; B947 44                       D
        .byte   $AF                             ; B948 AF                       .
        sta     $9B9B,y                         ; B949 99 9B 9B                 ...
        sta     LBAAF,y                         ; B94C 99 AF BA                 ...
        .byte   $44                             ; B94F 44                       D
        .byte   $9E                             ; B950 9E                       .
        .byte   $9F                             ; B951 9F                       .
        .byte   $9F                             ; B952 9F                       .
        .byte   $9E                             ; B953 9E                       .
        .byte   $9F                             ; B954 9F                       .
        sta     $44BB,x                         ; B955 9D BB 44                 ..D
        bcs     LB8F9                           ; B958 B0 9F                    ..
        .byte   $9F                             ; B95A 9F                       .
        .byte   $9F                             ; B95B 9F                       .
        .byte   $9F                             ; B95C 9F                       .
        sta     $44BB,x                         ; B95D 9D BB 44                 ..D
        .byte   $B3                             ; B960 B3                       .
        .byte   $B2                             ; B961 B2                       .
        .byte   $B2                             ; B962 B2                       .
        .byte   $B2                             ; B963 B2                       .
        .byte   $9F                             ; B964 9F                       .
        ldx     #$BC                            ; B965 A2 BC                    ..
        lda     LBFBE,x                         ; B967 BD BE BF                 ...
        .byte   $BF                             ; B96A BF                       .
        .byte   $BF                             ; B96B BF                       .
        .byte   $9F                             ; B96C 9F                       .
        sta     $C1C0,x                         ; B96D 9D C0 C1                 ...
        tax                                     ; B970 AA                       .
        .byte   $AB                             ; B971 AB                       .
        ldy     LABAA                           ; B972 AC AA AB                 ...
        ldy     LA7C2                           ; B975 AC C2 A7                 ...
        lda     LAEAD                           ; B978 AD AD AE                 ...
        lda     LAEAD                           ; B97B AD AD AE                 ...
        lda     $44AD                           ; B97E AD AD 44                 ..D
        sta     $96,x                           ; B981 95 96                    ..
        .byte   $97                             ; B983 97                       .
        .byte   $97                             ; B984 97                       .
        .byte   $97                             ; B985 97                       .
        .byte   $97                             ; B986 97                       .
        stx     $44,y                           ; B987 96 44                    .D
        tya                                     ; B989 98                       .
        sta     LAF99,y                         ; B98A 99 99 AF                 ...
        .byte   $AF                             ; B98D AF                       .
        sta     $4499,y                         ; B98E 99 99 44                 ..D
        .byte   $9C                             ; B991 9C                       .
        .byte   $9F                             ; B992 9F                       .
        .byte   $9E                             ; B993 9E                       .
        sta     $9E9D,x                         ; B994 9D 9D 9E                 ...
        .byte   $C3                             ; B997 C3                       .
        .byte   $44                             ; B998 44                       D
        .byte   $9C                             ; B999 9C                       .
        .byte   $9F                             ; B99A 9F                       .
        ldy     #$9D                            ; B99B A0 9D                    ..
        ldx     #$B0                            ; B99D A2 B0                    ..
        cpy     $BD                             ; B99F C4 BD                    ..
        cmp     $9F                             ; B9A1 C5 9F                    ..
        .byte   $A3                             ; B9A3 A3                       .
        ldx     #$9D                            ; B9A4 A2 9D                    ..
        dec     $C7                             ; B9A6 C6 C7                    ..
        ldy     $A5                             ; B9A8 A4 A5                    ..
        .byte   $9F                             ; B9AA 9F                       .
        ldx     $C8                             ; B9AB A6 C8                    ..
        cmp     #$CA                            ; B9AD C9 CA                    ..
        .byte   $CB                             ; B9AF CB                       .
        tay                                     ; B9B0 A8                       .
        lda     #$AC                            ; B9B1 A9 AC                    ..
        tax                                     ; B9B3 AA                       .
        .byte   $AB                             ; B9B4 AB                       .
        ldy     LABAA                           ; B9B5 AC AA AB                 ...
        lda     LAEAD                           ; B9B8 AD AD AE                 ...
        lda     LAEAD                           ; B9BB AD AD AE                 ...
        lda     $96AD                           ; B9BE AD AD 96                 ...
        .byte   $97                             ; B9C1 97                       .
        .byte   $97                             ; B9C2 97                       .
        .byte   $97                             ; B9C3 97                       .
        .byte   $97                             ; B9C4 97                       .
        stx     $96,y                           ; B9C5 96 96                    ..
        .byte   $97                             ; B9C7 97                       .
        sta     LAF99,y                         ; B9C8 99 99 AF                 ...
        .byte   $AF                             ; B9CB AF                       .
        txs                                     ; B9CC 9A                       .
        sta     $9999,y                         ; B9CD 99 99 99                 ...
        cpy     $9D9E                           ; B9D0 CC 9E 9D                 ...
        .byte   $9D                             ; B9D3 9D                       .
        .byte   $9E                             ; B9D4 9E                       .
LB9D5:  .byte   $9F                             ; B9D5 9F                       .
        .byte   $9F                             ; B9D6 9F                       .
        .byte   $9E                             ; B9D7 9E                       .
        cmp     $9DA0                           ; B9D8 CD A0 9D                 ...
        ldx     #$B0                            ; B9DB A2 B0                    ..
        .byte   $9F                             ; B9DD 9F                       .
        .byte   $9F                             ; B9DE 9F                       .
        ldy     #$CE                            ; B9DF A0 CE                    ..
        .byte   $CF                             ; B9E1 CF                       .
        ror     LA680,x                         ; B9E2 7E 80 A6                 ~..
        .byte   $9F                             ; B9E5 9F                       .
        .byte   $9F                             ; B9E6 9F                       .
        .byte   $A3                             ; B9E7 A3                       .
        bne     LBA69                           ; B9E8 D0 7F                    ..
        .byte   $CB                             ; B9EA CB                       .
        .byte   $7F                             ; B9EB 7F                       .
        .byte   $7F                             ; B9EC 7F                       .
        .byte   $80                             ; B9ED 80                       .
        lda     $B8,x                           ; B9EE B5 B8                    ..
        ldy     LABAA                           ; B9F0 AC AA AB                 ...
        ldy     LABAA                           ; B9F3 AC AA AB                 ...
        ldy     LAEAA                           ; B9F6 AC AA AE                 ...
        lda     LAEAD                           ; B9F9 AD AD AE                 ...
        lda     LAEAD                           ; B9FC AD AD AE                 ...
        lda     $9797                           ; B9FF AD 97 97                 ...
        .byte   $97                             ; BA02 97                       .
        stx     $96,y                           ; BA03 96 96                    ..
        stx     $B9,y                           ; BA05 96 B9                    ..
        .byte   $44                             ; BA07 44                       D
        .byte   $AF                             ; BA08 AF                       .
        .byte   $AF                             ; BA09 AF                       .
        txs                                     ; BA0A 9A                       .
        sta     LAF99,y                         ; BA0B 99 99 AF                 ...
        tsx                                     ; BA0E BA                       .
        .byte   $44                             ; BA0F 44                       D
        sta     $9E9D,x                         ; BA10 9D 9D 9E                 ...
        .byte   $9F                             ; BA13 9F                       .
        .byte   $9F                             ; BA14 9F                       .
        sta     $44BB,x                         ; BA15 9D BB 44                 ..D
        sta     LB0A2,x                         ; BA18 9D A2 B0                 ...
        .byte   $9F                             ; BA1B 9F                       .
        .byte   $9F                             ; BA1C 9F                       .
        sta     $44BB,x                         ; BA1D 9D BB 44                 ..D
        ldx     #$9D                            ; BA20 A2 9D                    ..
        bcs     LB9D5                           ; BA22 B0 B1                    ..
        lda     ($A2),y                         ; BA24 B1 A2                    ..
        ldy     LB8BD,x                         ; BA26 BC BD B8                 ...
        clv                                     ; BA29 B8                       .
        clv                                     ; BA2A B8                       .
        .byte   $BF                             ; BA2B BF                       .
        .byte   $BF                             ; BA2C BF                       .
        ldx     #$C0                            ; BA2D A2 C0                    ..
        cmp     ($AB),y                         ; BA2F D1 AB                    ..
        ldy     LABAA                           ; BA31 AC AA AB                 ...
        ldy     $C2D2                           ; BA34 AC D2 C2                 ...
        .byte   $A7                             ; BA37 A7                       .
        lda     LADAE                           ; BA38 AD AE AD                 ...
        lda     LADAE                           ; BA3B AD AE AD                 ...
        lda     $44AD                           ; BA3E AD AD 44                 ..D
        sta     $96,x                           ; BA41 95 96                    ..
        .byte   $97                             ; BA43 97                       .
        .byte   $97                             ; BA44 97                       .
        .byte   $97                             ; BA45 97                       .
        .byte   $97                             ; BA46 97                       .
        stx     $44,y                           ; BA47 96 44                    .D
        tya                                     ; BA49 98                       .
        sta     LAF99,y                         ; BA4A 99 99 AF                 ...
        .byte   $AF                             ; BA4D AF                       .
        .byte   $AF                             ; BA4E AF                       .
        .byte   $AF                             ; BA4F AF                       .
        .byte   $44                             ; BA50 44                       D
        .byte   $9C                             ; BA51 9C                       .
        sta     $9D9E,x                         ; BA52 9D 9E 9D                 ...
        sta     $9D9E,x                         ; BA55 9D 9E 9D                 ...
        .byte   $44                             ; BA58 44                       D
        .byte   $9C                             ; BA59 9C                       .
        sta     $9DB0,x                         ; BA5A 9D B0 9D                 ...
        ldx     #$A2                            ; BA5D A2 A2                    ..
        sta     $C5BD,x                         ; BA5F 9D BD C5                 ...
        ldx     #$A3                            ; BA62 A2 A3                    ..
        ldx     #$9D                            ; BA64 A2 9D                    ..
        sta     LA4A2,x                         ; BA66 9D A2 A4                 ...
LBA69:  lda     $9D                             ; BA69 A5 9D                    ..
        ldx     $D3                             ; BA6B A6 D3                    ..
        .byte   $D4                             ; BA6D D4                       .
        dey                                     ; BA6E 88                       .
        dey                                     ; BA6F 88                       .
        tay                                     ; BA70 A8                       .
        lda     #$AC                            ; BA71 A9 AC                    ..
        tax                                     ; BA73 AA                       .
        .byte   $AB                             ; BA74 AB                       .
        ldy     LABAA                           ; BA75 AC AA AB                 ...
        lda     LAEAD                           ; BA78 AD AD AE                 ...
        lda     LAEAD                           ; BA7B AD AD AE                 ...
        lda     $96AD                           ; BA7E AD AD 96                 ...
        .byte   $97                             ; BA81 97                       .
        .byte   $97                             ; BA82 97                       .
        .byte   $97                             ; BA83 97                       .
        .byte   $97                             ; BA84 97                       .
        stx     $D5,y                           ; BA85 96 D5                    ..
        .byte   $44                             ; BA87 44                       D
        .byte   $AF                             ; BA88 AF                       .
        sta     LAF99,y                         ; BA89 99 99 AF                 ...
        sta     $D7D6,y                         ; BA8C 99 D6 D7                 ...
        .byte   $44                             ; BA8F 44                       D
        .byte   $9F                             ; BA90 9F                       .
        .byte   $9E                             ; BA91 9E                       .
        .byte   $9F                             ; BA92 9F                       .
        .byte   $9E                             ; BA93 9E                       .
        .byte   $9F                             ; BA94 9F                       .
        sta     $44D8,x                         ; BA95 9D D8 44                 ..D
        .byte   $9F                             ; BA98 9F                       .
        .byte   $9F                             ; BA99 9F                       .
        .byte   $9F                             ; BA9A 9F                       .
        ldy     #$9F                            ; BA9B A0 9F                    ..
        ldx     #$D8                            ; BA9D A2 D8                    ..
        .byte   $44                             ; BA9F 44                       D
        .byte   $9F                             ; BAA0 9F                       .
        .byte   $9F                             ; BAA1 9F                       .
        .byte   $9F                             ; BAA2 9F                       .
        .byte   $A3                             ; BAA3 A3                       .
        .byte   $9F                             ; BAA4 9F                       .
        sta     $44D8,x                         ; BAA5 9D D8 44                 ..D
        .byte   $9F                             ; BAA8 9F                       .
        .byte   $9F                             ; BAA9 9F                       .
        .byte   $9F                             ; BAAA 9F                       .
        ldx     $88                             ; BAAB A6 88                    ..
        dey                                     ; BAAD 88                       .
        dey                                     ; BAAE 88                       .
LBAAF:  .byte   $44                             ; BAAF 44                       D
        ldy     LABAA                           ; BAB0 AC AA AB                 ...
        ldy     LABAA                           ; BAB3 AC AA AB                 ...
        .byte   $C2                             ; BAB6 C2                       .
        .byte   $A7                             ; BAB7 A7                       .
        ldx     LADAD                           ; BAB8 AE AD AD                 ...
        ldx     LADAD                           ; BABB AE AD AD                 ...
        lda     $61AD                           ; BABE AD AD 61                 ..a
        .byte   $62                             ; BAC1 62                       b
        .byte   $63                             ; BAC2 63                       c
        jmp     L4C64                           ; BAC3 4C 64 4C                 LdL

; ----------------------------------------------------------------------------
        jmp     L654C                           ; BAC6 4C 4C 65                 LLe

; ----------------------------------------------------------------------------
        ror     $67                             ; BAC9 66 67                    fg
        jmp     L6362                           ; BACB 4C 62 63                 Lbc

; ----------------------------------------------------------------------------
        .byte   $61                             ; BACE 61                       a
LBACF:  .byte   $4C                             ; BACF 4C                       L
        .byte   $51                             ; BAD0 51                       Q
LBAD1:  .byte   $50,$51                    ; BAD1 50 51   (branch out of range for ca65: target has no local label)
        pla                                     ; BAD3 68                       h
LBAD4:  eor     ($68),y                         ; BAD4 51 68                    Qh
        eor     ($69),y                         ; BAD6 51 69                    Qi
        .byte   $54                             ; BAD8 54                       T
        .byte   $54                             ; BAD9 54                       T
        .byte   $54                             ; BADA 54                       T
LBADB:  .byte   $54                             ; BADB 54                       T
        .byte   $54                             ; BADC 54                       T
        .byte   $54                             ; BADD 54                       T
LBADE:  .byte   $54                             ; BADE 54                       T
        .byte   $54                             ; BADF 54                       T
        lsr     $56,x                           ; BAE0 56 56                    VV
        lsr     $56,x                           ; BAE2 56 56                    VV
        lsr     $56,x                           ; BAE4 56 56                    VV
        lsr     $56,x                           ; BAE6 56 56                    VV
        cmp     $D9D9,y                         ; BAE8 D9 D9 D9                 ...
        cmp     $DAD9,y                         ; BAEB D9 D9 DA                 ...
        .byte   $DB                             ; BAEE DB                       .
        .byte   $04                             ; BAEF 04                       .
        .byte   $DC                             ; BAF0 DC                       .
        bmi     LBACF                           ; BAF1 30 DC                    0.
        bmi     LBAD1                           ; BAF3 30 DC                    0.
        bmi     LBAD4                           ; BAF5 30 DD                    0.
        .byte   $5A                             ; BAF7 5A                       Z
        dec     $DE30,x                         ; BAF8 DE 30 DE                 .0.
        bmi     LBADB                           ; BAFB 30 DE                    0.
        bmi     LBADE                           ; BAFD 30 DF                    0.
        .byte   $44                             ; BAFF 44                       D
        adc     ($62,x)                         ; BB00 61 62                    ab
        .byte   $63                             ; BB02 63                       c
        jmp     L4C64                           ; BB03 4C 64 4C                 LdL

; ----------------------------------------------------------------------------
        jmp     L654C                           ; BB06 4C 4C 65                 LLe

; ----------------------------------------------------------------------------
LBB09:  ror     $67                             ; BB09 66 67                    fg
LBB0B:  jmp     L6362                           ; BB0B 4C 62 63                 Lbc

; ----------------------------------------------------------------------------
        adc     (L004C,x)                       ; BB0E 61 4C                    aL
        eor     ($50),y                         ; BB10 51 50                    QP
        eor     ($68),y                         ; BB12 51 68                    Qh
        eor     ($68),y                         ; BB14 51 68                    Qh
        eor     ($69),y                         ; BB16 51 69                    Qi
        .byte   $54                             ; BB18 54                       T
        .byte   $54                             ; BB19 54                       T
        .byte   $54                             ; BB1A 54                       T
        .byte   $54                             ; BB1B 54                       T
        .byte   $54                             ; BB1C 54                       T
        .byte   $54                             ; BB1D 54                       T
        .byte   $54                             ; BB1E 54                       T
        .byte   $54                             ; BB1F 54                       T
        lsr     $56,x                           ; BB20 56 56                    VV
        lsr     $E0,x                           ; BB22 56 E0                    V.
        sbc     ($E2,x)                         ; BB24 E1 E2                    ..
        sbc     ($E2,x)                         ; BB26 E1 E2                    ..
        .byte   $04                             ; BB28 04                       .
        ror     a                               ; BB29 6A                       j
        .byte   $E3                             ; BB2A E3                       .
        bmi     LBB09                           ; BB2B 30 DC                    0.
        .byte   $30                             ; BB2D 30                       0
LBB2E:  .byte   $DC                             ; BB2E DC                       .
        bmi     LBB8B                           ; BB2F 30 5A                    0Z
        .byte   $6F                             ; BB31 6F                       o
        bcc     LBBA5                           ; BB32 90 71                    .q
        .byte   $93                             ; BB34 93                       .
        adc     ($93),y                         ; BB35 71 93                    q.
        adc     ($44),y                         ; BB37 71 44                    qD
        .byte   $74                             ; BB39 74                       t
        adc     $76,x                           ; BB3A 75 76                    uv
        asl     $76,x                           ; BB3C 16 76                    .v
        asl     $76,x                           ; BB3E 16 76                    .v
        adc     ($62,x)                         ; BB40 61 62                    ab
        .byte   $63                             ; BB42 63                       c
        jmp     L4C64                           ; BB43 4C 64 4C                 LdL

; ----------------------------------------------------------------------------
        jmp     L654C                           ; BB46 4C 4C 65                 LLe

; ----------------------------------------------------------------------------
        ror     $67                             ; BB49 66 67                    fg
        jmp     L6362                           ; BB4B 4C 62 63                 Lbc

; ----------------------------------------------------------------------------
        adc     (L004C,x)                       ; BB4E 61 4C                    aL
        eor     ($50),y                         ; BB50 51 50                    QP
        eor     ($68),y                         ; BB52 51 68                    Qh
        eor     ($68),y                         ; BB54 51 68                    Qh
        eor     ($69),y                         ; BB56 51 69                    Qi
        .byte   $54                             ; BB58 54                       T
        .byte   $54                             ; BB59 54                       T
        .byte   $54                             ; BB5A 54                       T
        .byte   $54                             ; BB5B 54                       T
        .byte   $54                             ; BB5C 54                       T
        .byte   $54                             ; BB5D 54                       T
        .byte   $54                             ; BB5E 54                       T
        .byte   $54                             ; BB5F 54                       T
        sbc     ($E2,x)                         ; BB60 E1 E2                    ..
        .byte   $E2                             ; BB62 E2                       .
        cpx     $B3                             ; BB63 E4 B3                    ..
        cpx     $E2                             ; BB65 E4 E2                    ..
        cpx     $DC                             ; BB67 E4 DC                    ..
        bmi     LBB9B                           ; BB69 30 30                    00
        ldx     LBEBE,y                         ; BB6B BE BE BE                 ...
        bmi     LBB2E                           ; BB6E 30 BE                    0.
        .byte   $93                             ; BB70 93                       .
        adc     ($71),y                         ; BB71 71 71                    qq
        .byte   $72                             ; BB73 72                       r
        .byte   $73                             ; BB74 73                       s
        .byte   $73                             ; BB75 73                       s
        .byte   $6F                             ; BB76 6F                       o
        .byte   $73                             ; BB77 73                       s
        asl     $76,x                           ; BB78 16 76                    .v
        adc     $78,x                           ; BB7A 75 78                    ux
        adc     $7479,y                         ; BB7C 79 79 74                 yyt
        adc     $6261,y                         ; BB7F 79 61 62                 yab
        .byte   $63                             ; BB82 63                       c
        .byte   $4C                             ; BB83 4C                       L
LBB84:  .byte   $64                             ; BB84 64                       d
        jmp     L4C4C                           ; BB85 4C 4C 4C                 LLL

; ----------------------------------------------------------------------------
        adc     $66                             ; BB88 65 66                    ef
        .byte   $67                             ; BB8A 67                       g
LBB8B:  jmp     L6362                           ; BB8B 4C 62 63                 Lbc

; ----------------------------------------------------------------------------
        adc     (L004C,x)                       ; BB8E 61 4C                    aL
        eor     ($50),y                         ; BB90 51 50                    QP
        eor     ($68),y                         ; BB92 51 68                    Qh
        eor     ($68),y                         ; BB94 51 68                    Qh
        eor     ($69),y                         ; BB96 51 69                    Qi
        .byte   $54                             ; BB98 54                       T
        .byte   $54                             ; BB99 54                       T
        .byte   $54                             ; BB9A 54                       T
LBB9B:  .byte   $54                             ; BB9B 54                       T
        .byte   $54                             ; BB9C 54                       T
        cpx     $E2                             ; BB9D E4 E2                    ..
        .byte   $54                             ; BB9F 54                       T
        .byte   $B3                             ; BBA0 B3                       .
        cpx     $E2                             ; BBA1 E4 E2                    ..
        lda     ($B1),y                         ; BBA3 B1 B1                    ..
LBBA5:  sbc     $30                             ; BBA5 E5 30                    .0
        lsr     $BE,x                           ; BBA7 56 BE                    V.
        ldx     LBF30,y                         ; BBA9 BE 30 BF                 .0.
        .byte   $BF                             ; BBAC BF                       .
        ldx     $0430,y                         ; BBAD BE 30 04                 .0.
        .byte   $73                             ; BBB0 73                       s
        .byte   $73                             ; BBB1 73                       s
        .byte   $6F                             ; BBB2 6F                       o
        .byte   $73                             ; BBB3 73                       s
        sta     $86                             ; BBB4 85 86                    ..
        .byte   $6F                             ; BBB6 6F                       o
        .byte   $5A                             ; BBB7 5A                       Z
        .byte   $79                             ; BBB8 79                       y
        .byte   $79                             ; BBB9 79                       y
LBBBA:  .byte   $74                             ; BBBA 74                       t
        adc     $7587,y                         ; BBBB 79 87 75                 y.u
        .byte   $74                             ; BBBE 74                       t
        .byte   $44                             ; BBBF 44                       D
        adc     ($62,x)                         ; BBC0 61 62                    ab
        .byte   $63                             ; BBC2 63                       c
        jmp     L4C64                           ; BBC3 4C 64 4C                 LdL

; ----------------------------------------------------------------------------
        jmp     L654C                           ; BBC6 4C 4C 65                 LLe

; ----------------------------------------------------------------------------
        ror     $67                             ; BBC9 66 67                    fg
        jmp     L6362                           ; BBCB 4C 62 63                 Lbc

; ----------------------------------------------------------------------------
        adc     (L004C,x)                       ; BBCE 61 4C                    aL
        eor     ($50),y                         ; BBD0 51 50                    QP
        eor     ($68),y                         ; BBD2 51 68                    Qh
        eor     ($68),y                         ; BBD4 51 68                    Qh
        eor     ($69),y                         ; BBD6 51 69                    Qi
        .byte   $54                             ; BBD8 54                       T
        .byte   $54                             ; BBD9 54                       T
        .byte   $54                             ; BBDA 54                       T
        .byte   $54                             ; BBDB 54                       T
        .byte   $54                             ; BBDC 54                       T
        .byte   $54                             ; BBDD 54                       T
        .byte   $54                             ; BBDE 54                       T
        .byte   $54                             ; BBDF 54                       T
        lsr     $56,x                           ; BBE0 56 56                    VV
        lsr     $56,x                           ; BBE2 56 56                    VV
        lsr     $56,x                           ; BBE4 56 56                    VV
        lsr     $56,x                           ; BBE6 56 56                    VV
        .byte   $04                             ; BBE8 04                       .
        ror     a                               ; BBE9 6A                       j
        .byte   $E3                             ; BBEA E3                       .
        .byte   $E3                             ; BBEB E3                       .
        adc     $8888                           ; BBEC 6D 88 88                 m..
        .byte   $04                             ; BBEF 04                       .
        .byte   $5A                             ; BBF0 5A                       Z
        .byte   $6F                             ; BBF1 6F                       o
        bcc     LBB84                           ; BBF2 90 90                    ..
        .byte   $6F                             ; BBF4 6F                       o
        .byte   $72                             ; BBF5 72                       r
        .byte   $73                             ; BBF6 73                       s
        .byte   $73                             ; BBF7 73                       s
        .byte   $44                             ; BBF8 44                       D
        .byte   $74                             ; BBF9 74                       t
        adc     $76,x                           ; BBFA 75 76                    uv
        .byte   $74                             ; BBFC 74                       t
        sei                                     ; BBFD 78                       x
        adc     $6179,y                         ; BBFE 79 79 61                 yya
        .byte   $62                             ; BC01 62                       b
        .byte   $63                             ; BC02 63                       c
        jmp     L4C64                           ; BC03 4C 64 4C                 LdL

; ----------------------------------------------------------------------------
        jmp     L654C                           ; BC06 4C 4C 65                 LLe

; ----------------------------------------------------------------------------
        ror     $67                             ; BC09 66 67                    fg
        jmp     L6362                           ; BC0B 4C 62 63                 Lbc

; ----------------------------------------------------------------------------
        adc     (L004C,x)                       ; BC0E 61 4C                    aL
        eor     ($50),y                         ; BC10 51 50                    QP
        eor     ($68),y                         ; BC12 51 68                    Qh
        eor     ($68),y                         ; BC14 51 68                    Qh
        eor     ($69),y                         ; BC16 51 69                    Qi
        .byte   $54                             ; BC18 54                       T
        .byte   $54                             ; BC19 54                       T
        .byte   $54                             ; BC1A 54                       T
        .byte   $54                             ; BC1B 54                       T
        .byte   $54                             ; BC1C 54                       T
        .byte   $54                             ; BC1D 54                       T
        .byte   $54                             ; BC1E 54                       T
        .byte   $54                             ; BC1F 54                       T
        lsr     $56,x                           ; BC20 56 56                    VV
        lsr     $56,x                           ; BC22 56 56                    VV
        lsr     $56,x                           ; BC24 56 56                    VV
        inc     $7F                             ; BC26 E6 7F                    ..
        .byte   $04                             ; BC28 04                       .
        jmp     (L886C)                         ; BC29 6C 6C 88                 ll.

; ----------------------------------------------------------------------------
        dey                                     ; BC2C 88                       .
        .byte   $04                             ; BC2D 04                       .
        .byte   $83                             ; BC2E 83                       .
        .byte   $83                             ; BC2F 83                       .
        sta     $71                             ; BC30 85 71                    .q
        adc     ($72),y                         ; BC32 71 72                    qr
        .byte   $73                             ; BC34 73                       s
        .byte   $73                             ; BC35 73                       s
        sta     $73                             ; BC36 85 73                    .s
        .byte   $87                             ; BC38 87                       .
        .byte   $77                             ; BC39 77                       w
        .byte   $77                             ; BC3A 77                       w
        sei                                     ; BC3B 78                       x
        adc     $8779,y                         ; BC3C 79 79 87                 yy.
        adc     $6261,y                         ; BC3F 79 61 62                 yab
        .byte   $63                             ; BC42 63                       c
        jmp     L4C64                           ; BC43 4C 64 4C                 LdL

; ----------------------------------------------------------------------------
        jmp     L654C                           ; BC46 4C 4C 65                 LLe

; ----------------------------------------------------------------------------
        ror     $67                             ; BC49 66 67                    fg
        jmp     L6362                           ; BC4B 4C 62 63                 Lbc

; ----------------------------------------------------------------------------
        adc     (L004C,x)                       ; BC4E 61 4C                    aL
        eor     ($50),y                         ; BC50 51 50                    QP
        eor     ($68),y                         ; BC52 51 68                    Qh
        eor     ($68),y                         ; BC54 51 68                    Qh
        eor     ($69),y                         ; BC56 51 69                    Qi
        .byte   $54                             ; BC58 54                       T
        .byte   $54                             ; BC59 54                       T
        .byte   $54                             ; BC5A 54                       T
        .byte   $54                             ; BC5B 54                       T
        .byte   $54                             ; BC5C 54                       T
        .byte   $54                             ; BC5D 54                       T
        .byte   $E2                             ; BC5E E2                       .
        .byte   $54                             ; BC5F 54                       T
        .byte   $7F                             ; BC60 7F                       .
        .byte   $80                             ; BC61 80                       .
        lsr     $56,x                           ; BC62 56 56                    VV
        sta     $3091                           ; BC64 8D 91 30                 ..0
        lsr     $83,x                           ; BC67 56 83                    V.
        .byte   $83                             ; BC69 83                       .
        .byte   $83                             ; BC6A 83                       .
        .byte   $83                             ; BC6B 83                       .
        bmi     LBC9F                           ; BC6C 30 31                    01
        bmi     LBC74                           ; BC6E 30 04                    0.
        .byte   $73                             ; BC70 73                       s
        .byte   $73                             ; BC71 73                       s
        sta     $86                             ; BC72 85 86                    ..
LBC74:  adc     ($93),y                         ; BC74 71 93                    q.
        bmi     LBC7C                           ; BC76 30 04                    0.
        adc     $8779,y                         ; BC78 79 79 87                 yy.
        .byte   $75                             ; BC7B 75                       u
LBC7C:  ror     $16,x                           ; BC7C 76 16                    v.
        bmi     LBC84                           ; BC7E 30 04                    0.
        sty     $04,x                           ; BC80 94 04                    ..
        sta     $96,x                           ; BC82 95 96                    ..
LBC84:  .byte   $97                             ; BC84 97                       .
        .byte   $97                             ; BC85 97                       .
        stx     $E7,y                           ; BC86 96 E7                    ..
        sty     $04,x                           ; BC88 94 04                    ..
        inx                                     ; BC8A E8                       .
        sta     $9999,y                         ; BC8B 99 99 99                 ...
        sta     $94E7,y                         ; BC8E 99 E7 94                 ...
        .byte   $04                             ; BC91 04                       .
        sbc     #$9D                            ; BC92 E9 9D                    ..
        .byte   $9F                             ; BC94 9F                       .
        nop                                     ; BC95 EA                       .
        .byte   $9F                             ; BC96 9F                       .
        .byte   $E7                             ; BC97 E7                       .
        sty     $04,x                           ; BC98 94 04                    ..
        sbc     #$9D                            ; BC9A E9 9D                    ..
        .byte   $9F                             ; BC9C 9F                       .
        ldy     #$9F                            ; BC9D A0 9F                    ..
LBC9F:  .byte   $EB                             ; BC9F EB                       .
        sty     $EC,x                           ; BCA0 94 EC                    ..
        lda     $A2                             ; BCA2 A5 A2                    ..
LBCA4:  .byte   $9F                             ; BCA4 9F                       .
        .byte   $A3                             ; BCA5 A3                       .
        .byte   $9F                             ; BCA6 9F                       .
        sbc     $EC94                           ; BCA7 ED 94 EC                 ...
        lda     $9D                             ; BCAA A5 9D                    ..
        .byte   $9F                             ; BCAC 9F                       .
        ldx     $9F                             ; BCAD A6 9F                    ..
        inc     LA794                           ; BCAF EE 94 A7                 ...
        tay                                     ; BCB2 A8                       .
        lda     #$AA                            ; BCB3 A9 AA                    ..
        .byte   $AB                             ; BCB5 AB                       .
        ldy     $94AA                           ; BCB6 AC AA 94                 ...
        lda     LADAD                           ; BCB9 AD AD AD                 ...
        lda     LAEAD                           ; BCBC AD AD AE                 ...
        lda     $0404                           ; BCBF AD 04 04                 ...
        .byte   $04                             ; BCC2 04                       .
        .byte   $04                             ; BCC3 04                       .
        .byte   $04                             ; BCC4 04                       .
        .byte   $04                             ; BCC5 04                       .
        .byte   $04                             ; BCC6 04                       .
        .byte   $04                             ; BCC7 04                       .
        .byte   $04                             ; BCC8 04                       .
        .byte   $04                             ; BCC9 04                       .
        .byte   $04                             ; BCCA 04                       .
        .byte   $EF                             ; BCCB EF                       .
        ror     $F080,x                         ; BCCC 7E 80 F0                 ~..
        sbc     ($EF),y                         ; BCCF F1 EF                    ..
        dex                                     ; BCD1 CA                       .
        bne     LBCA4                           ; BCD2 D0 D0                    ..
        .byte   $7F                             ; BCD4 7F                       .
        .byte   $7F                             ; BCD5 7F                       .
        .byte   $7F                             ; BCD6 7F                       .
        .byte   $7F                             ; BCD7 7F                       .
        .byte   $83                             ; BCD8 83                       .
        .byte   $83                             ; BCD9 83                       .
        .byte   $83                             ; BCDA 83                       .
        .byte   $83                             ; BCDB 83                       .
        .byte   $83                             ; BCDC 83                       .
        .byte   $83                             ; BCDD 83                       .
        .byte   $83                             ; BCDE 83                       .
        .byte   $83                             ; BCDF 83                       .
        .byte   $F2                             ; BCE0 F2                       .
        .byte   $F2                             ; BCE1 F2                       .
        .byte   $F2                             ; BCE2 F2                       .
        .byte   $F2                             ; BCE3 F2                       .
        .byte   $F2                             ; BCE4 F2                       .
        .byte   $F2                             ; BCE5 F2                       .
        .byte   $F2                             ; BCE6 F2                       .
        .byte   $F3                             ; BCE7 F3                       .
        .byte   $17                             ; BCE8 17                       .
        .byte   $17                             ; BCE9 17                       .
        .byte   $17                             ; BCEA 17                       .
        .byte   $17                             ; BCEB 17                       .
        .byte   $17                             ; BCEC 17                       .
        .byte   $17                             ; BCED 17                       .
        .byte   $17                             ; BCEE 17                       .
        .byte   $F4                             ; BCEF F4                       .
        .byte   $AB                             ; BCF0 AB                       .
        ldy     LABAA                           ; BCF1 AC AA AB                 ...
        ldy     LABAA                           ; BCF4 AC AA AB                 ...
        ldy     LAEAD                           ; BCF7 AC AD AE                 ...
        lda     LAEAD                           ; BCFA AD AD AE                 ...
        lda     LAEAD                           ; BCFD AD AD AE                 ...
        sta     $96,x                           ; BD00 95 96                    ..
        .byte   $97                             ; BD02 97                       .
        .byte   $97                             ; BD03 97                       .
        .byte   $97                             ; BD04 97                       .
        stx     $97,y                           ; BD05 96 97                    ..
        lda     $F6F5,y                         ; BD07 B9 F5 F6                 ...
        .byte   $F7                             ; BD0A F7                       .
        .byte   $F7                             ; BD0B F7                       .
        sed                                     ; BD0C F8                       .
        inc     $F7,x                           ; BD0D F6 F7                    ..
        .byte   $F9                             ; BD0F F9                       .
        .byte   $FA                             ; BD10 FA                       .
LBD11:  lsr     a                               ; BD11 4A                       J
        brk                                     ; BD12 00                       .
        php                                     ; BD13 08                       .
        bpl     LBD60                           ; BD14 10 4A                    .J
        brk                                     ; BD16 00                       .
        .byte   $FB                             ; BD17 FB                       .
        .byte   $FA                             ; BD18 FA                       .
        .byte   $17                             ; BD19 17                       .
        eor     $174E                           ; BD1A 4D 4E 17                 MN.
        .byte   $17                             ; BD1D 17                       .
        eor     $FDFC                           ; BD1E 4D FC FD                 M..
        php                                     ; BD21 08                       .
        bpl     LBD6E                           ; BD22 10 4A                    .J
        brk                                     ; BD24 00                       .
        php                                     ; BD25 08                       .
LBD26:  bpl     LBD26                           ; BD26 10 FE                    ..
        eor     $174E                           ; BD28 4D 4E 17                 MN.
        .byte   $17                             ; BD2B 17                       .
        eor     $174E                           ; BD2C 4D 4E 17                 MN.
        inc     LABAA,x                         ; BD2F FE AA AB                 ...
        ldy     LABAA                           ; BD32 AC AA AB                 ...
        ldy     LABAA                           ; BD35 AC AA AB                 ...
        .byte   $AD                             ; BD38 AD                       .
        .byte   $AD                             ; BD39 AD                       .
LBD3A:  ldx     LADAD                           ; BD3A AE AD AD                 ...
        ldx     LADAD                           ; BD3D AE AD AD                 ...
        .byte   $04                             ; BD40 04                       .
        .byte   $04                             ; BD41 04                       .
        .byte   $04                             ; BD42 04                       .
        .byte   $04                             ; BD43 04                       .
        .byte   $04                             ; BD44 04                       .
        .byte   $04                             ; BD45 04                       .
        .byte   $04                             ; BD46 04                       .
        .byte   $04                             ; BD47 04                       .
        .byte   $04                             ; BD48 04                       .
        .byte   $04                             ; BD49 04                       .
        .byte   $04                             ; BD4A 04                       .
        .byte   $04                             ; BD4B 04                       .
        .byte   $04                             ; BD4C 04                       .
        .byte   $04                             ; BD4D 04                       .
        .byte   $04                             ; BD4E 04                       .
        .byte   $04                             ; BD4F 04                       .
        .byte   $04                             ; BD50 04                       .
        .byte   $04                             ; BD51 04                       .
        .byte   $04                             ; BD52 04                       .
        .byte   $04                             ; BD53 04                       .
        .byte   $04                             ; BD54 04                       .
        .byte   $04                             ; BD55 04                       .
        .byte   $04                             ; BD56 04                       .
        .byte   $04                             ; BD57 04                       .
        .byte   $04                             ; BD58 04                       .
        .byte   $04                             ; BD59 04                       .
        .byte   $04                             ; BD5A 04                       .
        .byte   $04                             ; BD5B 04                       .
        .byte   $04                             ; BD5C 04                       .
        .byte   $04                             ; BD5D 04                       .
        .byte   $04                             ; BD5E 04                       .
LBD5F:  .byte   $04                             ; BD5F 04                       .
LBD60:  .byte   $04                             ; BD60 04                       .
        .byte   $04                             ; BD61 04                       .
        .byte   $04                             ; BD62 04                       .
        .byte   $04                             ; BD63 04                       .
        .byte   $04                             ; BD64 04                       .
        .byte   $04                             ; BD65 04                       .
        .byte   $04                             ; BD66 04                       .
        .byte   $04                             ; BD67 04                       .
        .byte   $04                             ; BD68 04                       .
        .byte   $04                             ; BD69 04                       .
        .byte   $04                             ; BD6A 04                       .
        .byte   $04                             ; BD6B 04                       .
        .byte   $04                             ; BD6C 04                       .
        .byte   $04                             ; BD6D 04                       .
LBD6E:  .byte   $04                             ; BD6E 04                       .
        .byte   $04                             ; BD6F 04                       .
        .byte   $04                             ; BD70 04                       .
        .byte   $04                             ; BD71 04                       .
        .byte   $04                             ; BD72 04                       .
        .byte   $04                             ; BD73 04                       .
        .byte   $04                             ; BD74 04                       .
        .byte   $04                             ; BD75 04                       .
        .byte   $04                             ; BD76 04                       .
        .byte   $04                             ; BD77 04                       .
        .byte   $04                             ; BD78 04                       .
        .byte   $04                             ; BD79 04                       .
        .byte   $04                             ; BD7A 04                       .
        .byte   $04                             ; BD7B 04                       .
        .byte   $04                             ; BD7C 04                       .
        .byte   $04                             ; BD7D 04                       .
        .byte   $04                             ; BD7E 04                       .
        .byte   $04                             ; BD7F 04                       .
        .byte   $04                             ; BD80 04                       .
        .byte   $04                             ; BD81 04                       .
        .byte   $04                             ; BD82 04                       .
        .byte   $04                             ; BD83 04                       .
        .byte   $04                             ; BD84 04                       .
        .byte   $04                             ; BD85 04                       .
        .byte   $04                             ; BD86 04                       .
        .byte   $04                             ; BD87 04                       .
        .byte   $04                             ; BD88 04                       .
        .byte   $04                             ; BD89 04                       .
        .byte   $04                             ; BD8A 04                       .
        .byte   $04                             ; BD8B 04                       .
        .byte   $04                             ; BD8C 04                       .
        .byte   $04                             ; BD8D 04                       .
        .byte   $04                             ; BD8E 04                       .
        .byte   $04                             ; BD8F 04                       .
        .byte   $04                             ; BD90 04                       .
        .byte   $04                             ; BD91 04                       .
        .byte   $04                             ; BD92 04                       .
        .byte   $04                             ; BD93 04                       .
        .byte   $04                             ; BD94 04                       .
        .byte   $04                             ; BD95 04                       .
        .byte   $04                             ; BD96 04                       .
        .byte   $04                             ; BD97 04                       .
        .byte   $04                             ; BD98 04                       .
        .byte   $04                             ; BD99 04                       .
        .byte   $04                             ; BD9A 04                       .
        .byte   $04                             ; BD9B 04                       .
        .byte   $04                             ; BD9C 04                       .
        .byte   $04                             ; BD9D 04                       .
        .byte   $04                             ; BD9E 04                       .
        .byte   $04                             ; BD9F 04                       .
        .byte   $04                             ; BDA0 04                       .
        .byte   $04                             ; BDA1 04                       .
        .byte   $04                             ; BDA2 04                       .
        .byte   $04                             ; BDA3 04                       .
        .byte   $04                             ; BDA4 04                       .
        .byte   $04                             ; BDA5 04                       .
        .byte   $04                             ; BDA6 04                       .
        .byte   $04                             ; BDA7 04                       .
        .byte   $04                             ; BDA8 04                       .
        .byte   $04                             ; BDA9 04                       .
        .byte   $04                             ; BDAA 04                       .
        .byte   $04                             ; BDAB 04                       .
        .byte   $04                             ; BDAC 04                       .
        .byte   $04                             ; BDAD 04                       .
        .byte   $04                             ; BDAE 04                       .
        .byte   $04                             ; BDAF 04                       .
        .byte   $04                             ; BDB0 04                       .
        .byte   $04                             ; BDB1 04                       .
        .byte   $04                             ; BDB2 04                       .
        .byte   $04                             ; BDB3 04                       .
        .byte   $04                             ; BDB4 04                       .
        .byte   $04                             ; BDB5 04                       .
        .byte   $04                             ; BDB6 04                       .
        .byte   $04                             ; BDB7 04                       .
        .byte   $04                             ; BDB8 04                       .
        .byte   $04                             ; BDB9 04                       .
        .byte   $04                             ; BDBA 04                       .
        .byte   $04                             ; BDBB 04                       .
        .byte   $04                             ; BDBC 04                       .
        .byte   $04                             ; BDBD 04                       .
        .byte   $04                             ; BDBE 04                       .
        .byte   $04                             ; BDBF 04                       .
        .byte   $04                             ; BDC0 04                       .
        .byte   $04                             ; BDC1 04                       .
        .byte   $04                             ; BDC2 04                       .
        .byte   $04                             ; BDC3 04                       .
        .byte   $04                             ; BDC4 04                       .
        .byte   $04                             ; BDC5 04                       .
        .byte   $04                             ; BDC6 04                       .
        .byte   $04                             ; BDC7 04                       .
        .byte   $04                             ; BDC8 04                       .
        .byte   $04                             ; BDC9 04                       .
        .byte   $04                             ; BDCA 04                       .
        .byte   $04                             ; BDCB 04                       .
        .byte   $04                             ; BDCC 04                       .
        .byte   $04                             ; BDCD 04                       .
        .byte   $04                             ; BDCE 04                       .
        .byte   $04                             ; BDCF 04                       .
        .byte   $04                             ; BDD0 04                       .
        .byte   $04                             ; BDD1 04                       .
        .byte   $04                             ; BDD2 04                       .
        .byte   $04                             ; BDD3 04                       .
        .byte   $04                             ; BDD4 04                       .
        .byte   $04                             ; BDD5 04                       .
        .byte   $04                             ; BDD6 04                       .
        .byte   $04                             ; BDD7 04                       .
        .byte   $04                             ; BDD8 04                       .
        .byte   $04                             ; BDD9 04                       .
        .byte   $04                             ; BDDA 04                       .
        .byte   $04                             ; BDDB 04                       .
        .byte   $04                             ; BDDC 04                       .
        .byte   $04                             ; BDDD 04                       .
        .byte   $04                             ; BDDE 04                       .
        .byte   $04                             ; BDDF 04                       .
        .byte   $04                             ; BDE0 04                       .
        .byte   $04                             ; BDE1 04                       .
        .byte   $04                             ; BDE2 04                       .
        .byte   $04                             ; BDE3 04                       .
        .byte   $04                             ; BDE4 04                       .
        .byte   $04                             ; BDE5 04                       .
        .byte   $04                             ; BDE6 04                       .
        .byte   $04                             ; BDE7 04                       .
        .byte   $04                             ; BDE8 04                       .
        .byte   $04                             ; BDE9 04                       .
        .byte   $04                             ; BDEA 04                       .
        .byte   $04                             ; BDEB 04                       .
        .byte   $04                             ; BDEC 04                       .
        .byte   $04                             ; BDED 04                       .
        .byte   $04                             ; BDEE 04                       .
        .byte   $04                             ; BDEF 04                       .
        .byte   $04                             ; BDF0 04                       .
        .byte   $04                             ; BDF1 04                       .
        .byte   $04                             ; BDF2 04                       .
        .byte   $04                             ; BDF3 04                       .
        .byte   $04                             ; BDF4 04                       .
        .byte   $04                             ; BDF5 04                       .
        .byte   $04                             ; BDF6 04                       .
        .byte   $04                             ; BDF7 04                       .
        .byte   $04                             ; BDF8 04                       .
        .byte   $04                             ; BDF9 04                       .
        .byte   $04                             ; BDFA 04                       .
        .byte   $04                             ; BDFB 04                       .
        .byte   $04                             ; BDFC 04                       .
        .byte   $04                             ; BDFD 04                       .
        .byte   $04                             ; BDFE 04                       .
        .byte   $04                             ; BDFF 04                       .
        .byte   $04                             ; BE00 04                       .
        .byte   $04                             ; BE01 04                       .
        .byte   $04                             ; BE02 04                       .
        .byte   $04                             ; BE03 04                       .
        .byte   $04                             ; BE04 04                       .
        .byte   $04                             ; BE05 04                       .
        .byte   $04                             ; BE06 04                       .
        .byte   $04                             ; BE07 04                       .
        .byte   $04                             ; BE08 04                       .
        .byte   $04                             ; BE09 04                       .
        .byte   $04                             ; BE0A 04                       .
        .byte   $04                             ; BE0B 04                       .
        .byte   $04                             ; BE0C 04                       .
        .byte   $04                             ; BE0D 04                       .
        .byte   $04                             ; BE0E 04                       .
        .byte   $04                             ; BE0F 04                       .
        .byte   $04                             ; BE10 04                       .
        .byte   $04                             ; BE11 04                       .
        .byte   $04                             ; BE12 04                       .
        .byte   $04                             ; BE13 04                       .
        .byte   $04                             ; BE14 04                       .
        .byte   $04                             ; BE15 04                       .
        .byte   $04                             ; BE16 04                       .
        .byte   $04                             ; BE17 04                       .
        .byte   $04                             ; BE18 04                       .
        .byte   $04                             ; BE19 04                       .
        .byte   $04                             ; BE1A 04                       .
        .byte   $04                             ; BE1B 04                       .
        .byte   $04                             ; BE1C 04                       .
        .byte   $04                             ; BE1D 04                       .
        .byte   $04                             ; BE1E 04                       .
        .byte   $04                             ; BE1F 04                       .
        .byte   $04                             ; BE20 04                       .
        .byte   $04                             ; BE21 04                       .
        .byte   $04                             ; BE22 04                       .
        .byte   $04                             ; BE23 04                       .
        .byte   $04                             ; BE24 04                       .
        .byte   $04                             ; BE25 04                       .
        .byte   $04                             ; BE26 04                       .
        .byte   $04                             ; BE27 04                       .
        .byte   $04                             ; BE28 04                       .
        .byte   $04                             ; BE29 04                       .
        .byte   $04                             ; BE2A 04                       .
        .byte   $04                             ; BE2B 04                       .
        .byte   $04                             ; BE2C 04                       .
        .byte   $04                             ; BE2D 04                       .
        .byte   $04                             ; BE2E 04                       .
        .byte   $04                             ; BE2F 04                       .
        .byte   $04                             ; BE30 04                       .
        .byte   $04                             ; BE31 04                       .
        .byte   $04                             ; BE32 04                       .
        .byte   $04                             ; BE33 04                       .
        .byte   $04                             ; BE34 04                       .
        .byte   $04                             ; BE35 04                       .
        .byte   $04                             ; BE36 04                       .
        .byte   $04                             ; BE37 04                       .
        .byte   $04                             ; BE38 04                       .
        .byte   $04                             ; BE39 04                       .
        .byte   $04                             ; BE3A 04                       .
        .byte   $04                             ; BE3B 04                       .
        .byte   $04                             ; BE3C 04                       .
        .byte   $04                             ; BE3D 04                       .
        .byte   $04                             ; BE3E 04                       .
        .byte   $04                             ; BE3F 04                       .
        .byte   $04                             ; BE40 04                       .
        .byte   $04                             ; BE41 04                       .
        .byte   $04                             ; BE42 04                       .
        .byte   $04                             ; BE43 04                       .
        .byte   $04                             ; BE44 04                       .
        .byte   $04                             ; BE45 04                       .
        .byte   $04                             ; BE46 04                       .
        .byte   $04                             ; BE47 04                       .
        .byte   $04                             ; BE48 04                       .
        .byte   $04                             ; BE49 04                       .
        .byte   $04                             ; BE4A 04                       .
        .byte   $04                             ; BE4B 04                       .
        .byte   $04                             ; BE4C 04                       .
        .byte   $04                             ; BE4D 04                       .
        .byte   $04                             ; BE4E 04                       .
        .byte   $04                             ; BE4F 04                       .
        .byte   $04                             ; BE50 04                       .
        .byte   $04                             ; BE51 04                       .
        .byte   $04                             ; BE52 04                       .
        .byte   $04                             ; BE53 04                       .
        .byte   $04                             ; BE54 04                       .
        .byte   $04                             ; BE55 04                       .
        .byte   $04                             ; BE56 04                       .
        .byte   $04                             ; BE57 04                       .
        .byte   $04                             ; BE58 04                       .
        .byte   $04                             ; BE59 04                       .
        .byte   $04                             ; BE5A 04                       .
        .byte   $04                             ; BE5B 04                       .
        .byte   $04                             ; BE5C 04                       .
        .byte   $04                             ; BE5D 04                       .
        .byte   $04                             ; BE5E 04                       .
        .byte   $04                             ; BE5F 04                       .
        .byte   $04                             ; BE60 04                       .
        .byte   $04                             ; BE61 04                       .
        .byte   $04                             ; BE62 04                       .
        .byte   $04                             ; BE63 04                       .
        .byte   $04                             ; BE64 04                       .
        .byte   $04                             ; BE65 04                       .
        .byte   $04                             ; BE66 04                       .
        .byte   $04                             ; BE67 04                       .
        .byte   $04                             ; BE68 04                       .
        .byte   $04                             ; BE69 04                       .
        .byte   $04                             ; BE6A 04                       .
        .byte   $04                             ; BE6B 04                       .
        .byte   $04                             ; BE6C 04                       .
        .byte   $04                             ; BE6D 04                       .
        .byte   $04                             ; BE6E 04                       .
        .byte   $04                             ; BE6F 04                       .
        .byte   $04                             ; BE70 04                       .
        .byte   $04                             ; BE71 04                       .
        .byte   $04                             ; BE72 04                       .
        .byte   $04                             ; BE73 04                       .
        .byte   $04                             ; BE74 04                       .
        .byte   $04                             ; BE75 04                       .
        .byte   $04                             ; BE76 04                       .
        .byte   $04                             ; BE77 04                       .
        .byte   $04                             ; BE78 04                       .
        .byte   $04                             ; BE79 04                       .
        .byte   $04                             ; BE7A 04                       .
        .byte   $04                             ; BE7B 04                       .
        .byte   $04                             ; BE7C 04                       .
        .byte   $04                             ; BE7D 04                       .
        .byte   $04                             ; BE7E 04                       .
        .byte   $04                             ; BE7F 04                       .
        .byte   $04                             ; BE80 04                       .
        .byte   $04                             ; BE81 04                       .
        .byte   $04                             ; BE82 04                       .
        .byte   $04                             ; BE83 04                       .
        .byte   $04                             ; BE84 04                       .
        .byte   $04                             ; BE85 04                       .
        .byte   $04                             ; BE86 04                       .
        .byte   $04                             ; BE87 04                       .
        .byte   $04                             ; BE88 04                       .
        .byte   $04                             ; BE89 04                       .
        .byte   $04                             ; BE8A 04                       .
        .byte   $04                             ; BE8B 04                       .
        .byte   $04                             ; BE8C 04                       .
        .byte   $04                             ; BE8D 04                       .
        .byte   $04                             ; BE8E 04                       .
        .byte   $04                             ; BE8F 04                       .
        .byte   $04                             ; BE90 04                       .
        .byte   $04                             ; BE91 04                       .
        .byte   $04                             ; BE92 04                       .
        .byte   $04                             ; BE93 04                       .
        .byte   $04                             ; BE94 04                       .
        .byte   $04                             ; BE95 04                       .
        .byte   $04                             ; BE96 04                       .
        .byte   $04                             ; BE97 04                       .
        .byte   $04                             ; BE98 04                       .
        .byte   $04                             ; BE99 04                       .
        .byte   $04                             ; BE9A 04                       .
        .byte   $04                             ; BE9B 04                       .
        .byte   $04                             ; BE9C 04                       .
        .byte   $04                             ; BE9D 04                       .
        .byte   $04                             ; BE9E 04                       .
        .byte   $04                             ; BE9F 04                       .
        .byte   $04                             ; BEA0 04                       .
        .byte   $04                             ; BEA1 04                       .
        .byte   $04                             ; BEA2 04                       .
        .byte   $04                             ; BEA3 04                       .
        .byte   $04                             ; BEA4 04                       .
        .byte   $04                             ; BEA5 04                       .
        .byte   $04                             ; BEA6 04                       .
        .byte   $04                             ; BEA7 04                       .
        .byte   $04                             ; BEA8 04                       .
        .byte   $04                             ; BEA9 04                       .
        .byte   $04                             ; BEAA 04                       .
        .byte   $04                             ; BEAB 04                       .
        .byte   $04                             ; BEAC 04                       .
        .byte   $04                             ; BEAD 04                       .
        .byte   $04                             ; BEAE 04                       .
        .byte   $04                             ; BEAF 04                       .
        .byte   $04                             ; BEB0 04                       .
        .byte   $04                             ; BEB1 04                       .
        .byte   $04                             ; BEB2 04                       .
        .byte   $04                             ; BEB3 04                       .
        .byte   $04                             ; BEB4 04                       .
        .byte   $04                             ; BEB5 04                       .
        .byte   $04                             ; BEB6 04                       .
        .byte   $04                             ; BEB7 04                       .
        .byte   $04                             ; BEB8 04                       .
        .byte   $04                             ; BEB9 04                       .
        .byte   $04                             ; BEBA 04                       .
        .byte   $04                             ; BEBB 04                       .
        .byte   $04                             ; BEBC 04                       .
        .byte   $04                             ; BEBD 04                       .
LBEBE:  .byte   $04                             ; BEBE 04                       .
        .byte   $04                             ; BEBF 04                       .
        .byte   $04                             ; BEC0 04                       .
        .byte   $04                             ; BEC1 04                       .
        .byte   $04                             ; BEC2 04                       .
        .byte   $04                             ; BEC3 04                       .
        .byte   $04                             ; BEC4 04                       .
        .byte   $04                             ; BEC5 04                       .
        .byte   $04                             ; BEC6 04                       .
        .byte   $04                             ; BEC7 04                       .
        .byte   $04                             ; BEC8 04                       .
        .byte   $04                             ; BEC9 04                       .
        .byte   $04                             ; BECA 04                       .
        .byte   $04                             ; BECB 04                       .
        .byte   $04                             ; BECC 04                       .
        .byte   $04                             ; BECD 04                       .
        .byte   $04                             ; BECE 04                       .
        .byte   $04                             ; BECF 04                       .
        .byte   $04                             ; BED0 04                       .
        .byte   $04                             ; BED1 04                       .
        .byte   $04                             ; BED2 04                       .
        .byte   $04                             ; BED3 04                       .
        .byte   $04                             ; BED4 04                       .
        .byte   $04                             ; BED5 04                       .
        .byte   $04                             ; BED6 04                       .
        .byte   $04                             ; BED7 04                       .
        .byte   $04                             ; BED8 04                       .
        .byte   $04                             ; BED9 04                       .
        .byte   $04                             ; BEDA 04                       .
        .byte   $04                             ; BEDB 04                       .
        .byte   $04                             ; BEDC 04                       .
        .byte   $04                             ; BEDD 04                       .
        .byte   $04                             ; BEDE 04                       .
        .byte   $04                             ; BEDF 04                       .
        .byte   $04                             ; BEE0 04                       .
        .byte   $04                             ; BEE1 04                       .
        .byte   $04                             ; BEE2 04                       .
        .byte   $04                             ; BEE3 04                       .
        .byte   $04                             ; BEE4 04                       .
        .byte   $04                             ; BEE5 04                       .
        .byte   $04                             ; BEE6 04                       .
        .byte   $04                             ; BEE7 04                       .
        .byte   $04                             ; BEE8 04                       .
        .byte   $04                             ; BEE9 04                       .
        .byte   $04                             ; BEEA 04                       .
        .byte   $04                             ; BEEB 04                       .
        .byte   $04                             ; BEEC 04                       .
        .byte   $04                             ; BEED 04                       .
        .byte   $04                             ; BEEE 04                       .
        .byte   $04                             ; BEEF 04                       .
        .byte   $04                             ; BEF0 04                       .
        .byte   $04                             ; BEF1 04                       .
        .byte   $04                             ; BEF2 04                       .
        .byte   $04                             ; BEF3 04                       .
        .byte   $04                             ; BEF4 04                       .
        .byte   $04                             ; BEF5 04                       .
        .byte   $04                             ; BEF6 04                       .
        .byte   $04                             ; BEF7 04                       .
        .byte   $04                             ; BEF8 04                       .
        .byte   $04                             ; BEF9 04                       .
        .byte   $04                             ; BEFA 04                       .
        .byte   $04                             ; BEFB 04                       .
        .byte   $04                             ; BEFC 04                       .
        .byte   $04                             ; BEFD 04                       .
        .byte   $04                             ; BEFE 04                       .
        .byte   $04                             ; BEFF 04                       .
        .byte   $04                             ; BF00 04                       .
        .byte   $04                             ; BF01 04                       .
        .byte   $04                             ; BF02 04                       .
        .byte   $04                             ; BF03 04                       .
        .byte   $04                             ; BF04 04                       .
        .byte   $04                             ; BF05 04                       .
        .byte   $04                             ; BF06 04                       .
        .byte   $04                             ; BF07 04                       .
        .byte   $04                             ; BF08 04                       .
        .byte   $04                             ; BF09 04                       .
        .byte   $04                             ; BF0A 04                       .
        .byte   $04                             ; BF0B 04                       .
        .byte   $04                             ; BF0C 04                       .
        .byte   $04                             ; BF0D 04                       .
        .byte   $04                             ; BF0E 04                       .
        .byte   $04                             ; BF0F 04                       .
        .byte   $04                             ; BF10 04                       .
        .byte   $04                             ; BF11 04                       .
        .byte   $04                             ; BF12 04                       .
        .byte   $04                             ; BF13 04                       .
        .byte   $04                             ; BF14 04                       .
        .byte   $04                             ; BF15 04                       .
        .byte   $04                             ; BF16 04                       .
        .byte   $04                             ; BF17 04                       .
        .byte   $04                             ; BF18 04                       .
        .byte   $04                             ; BF19 04                       .
        .byte   $04                             ; BF1A 04                       .
        .byte   $04                             ; BF1B 04                       .
        .byte   $04                             ; BF1C 04                       .
        .byte   $04                             ; BF1D 04                       .
        .byte   $04                             ; BF1E 04                       .
        .byte   $04                             ; BF1F 04                       .
        .byte   $04                             ; BF20 04                       .
        .byte   $04                             ; BF21 04                       .
        .byte   $04                             ; BF22 04                       .
        .byte   $04                             ; BF23 04                       .
        .byte   $04                             ; BF24 04                       .
        .byte   $04                             ; BF25 04                       .
        .byte   $04                             ; BF26 04                       .
        .byte   $04                             ; BF27 04                       .
        .byte   $04                             ; BF28 04                       .
        .byte   $04                             ; BF29 04                       .
        .byte   $04                             ; BF2A 04                       .
        .byte   $04                             ; BF2B 04                       .
        .byte   $04                             ; BF2C 04                       .
        .byte   $04                             ; BF2D 04                       .
        .byte   $04                             ; BF2E 04                       .
        .byte   $04                             ; BF2F 04                       .
LBF30:  .byte   $04                             ; BF30 04                       .
        .byte   $04                             ; BF31 04                       .
        .byte   $04                             ; BF32 04                       .
        .byte   $04                             ; BF33 04                       .
        .byte   $04                             ; BF34 04                       .
        .byte   $04                             ; BF35 04                       .
        .byte   $04                             ; BF36 04                       .
        .byte   $04                             ; BF37 04                       .
        .byte   $04                             ; BF38 04                       .
        .byte   $04                             ; BF39 04                       .
        .byte   $04                             ; BF3A 04                       .
        .byte   $04                             ; BF3B 04                       .
        .byte   $04                             ; BF3C 04                       .
        .byte   $04                             ; BF3D 04                       .
        .byte   $04                             ; BF3E 04                       .
        .byte   $04                             ; BF3F 04                       .
        .byte   $04                             ; BF40 04                       .
        .byte   $04                             ; BF41 04                       .
        .byte   $04                             ; BF42 04                       .
        .byte   $04                             ; BF43 04                       .
        .byte   $04                             ; BF44 04                       .
        .byte   $04                             ; BF45 04                       .
        .byte   $04                             ; BF46 04                       .
        .byte   $04                             ; BF47 04                       .
        .byte   $04                             ; BF48 04                       .
        .byte   $04                             ; BF49 04                       .
        .byte   $04                             ; BF4A 04                       .
        .byte   $04                             ; BF4B 04                       .
        .byte   $04                             ; BF4C 04                       .
        .byte   $04                             ; BF4D 04                       .
        .byte   $04                             ; BF4E 04                       .
        .byte   $04                             ; BF4F 04                       .
        .byte   $04                             ; BF50 04                       .
        .byte   $04                             ; BF51 04                       .
        .byte   $04                             ; BF52 04                       .
        .byte   $04                             ; BF53 04                       .
        .byte   $04                             ; BF54 04                       .
        .byte   $04                             ; BF55 04                       .
        .byte   $04                             ; BF56 04                       .
        .byte   $04                             ; BF57 04                       .
        .byte   $04                             ; BF58 04                       .
        .byte   $04                             ; BF59 04                       .
        .byte   $04                             ; BF5A 04                       .
        .byte   $04                             ; BF5B 04                       .
        .byte   $04                             ; BF5C 04                       .
        .byte   $04                             ; BF5D 04                       .
        .byte   $04                             ; BF5E 04                       .
        .byte   $04                             ; BF5F 04                       .
        .byte   $04                             ; BF60 04                       .
        .byte   $04                             ; BF61 04                       .
        .byte   $04                             ; BF62 04                       .
        .byte   $04                             ; BF63 04                       .
        .byte   $04                             ; BF64 04                       .
        .byte   $04                             ; BF65 04                       .
        .byte   $04                             ; BF66 04                       .
        .byte   $04                             ; BF67 04                       .
LBF68:  .byte   $04                             ; BF68 04                       .
        .byte   $04                             ; BF69 04                       .
        .byte   $04                             ; BF6A 04                       .
        .byte   $04                             ; BF6B 04                       .
        .byte   $04                             ; BF6C 04                       .
        .byte   $04                             ; BF6D 04                       .
        .byte   $04                             ; BF6E 04                       .
        .byte   $04                             ; BF6F 04                       .
        .byte   $04                             ; BF70 04                       .
        .byte   $04                             ; BF71 04                       .
        .byte   $04                             ; BF72 04                       .
        .byte   $04                             ; BF73 04                       .
        .byte   $04                             ; BF74 04                       .
        .byte   $04                             ; BF75 04                       .
        .byte   $04                             ; BF76 04                       .
        .byte   $04                             ; BF77 04                       .
        .byte   $04                             ; BF78 04                       .
        .byte   $04                             ; BF79 04                       .
        .byte   $04                             ; BF7A 04                       .
        .byte   $04                             ; BF7B 04                       .
        .byte   $04                             ; BF7C 04                       .
        .byte   $04                             ; BF7D 04                       .
        .byte   $04                             ; BF7E 04                       .
        .byte   $04                             ; BF7F 04                       .
        .byte   $04                             ; BF80 04                       .
        .byte   $04                             ; BF81 04                       .
        .byte   $04                             ; BF82 04                       .
        .byte   $04                             ; BF83 04                       .
        .byte   $04                             ; BF84 04                       .
        .byte   $04                             ; BF85 04                       .
        .byte   $04                             ; BF86 04                       .
        .byte   $04                             ; BF87 04                       .
        .byte   $04                             ; BF88 04                       .
        .byte   $04                             ; BF89 04                       .
        .byte   $04                             ; BF8A 04                       .
        .byte   $04                             ; BF8B 04                       .
        .byte   $04                             ; BF8C 04                       .
        .byte   $04                             ; BF8D 04                       .
        .byte   $04                             ; BF8E 04                       .
        .byte   $04                             ; BF8F 04                       .
        .byte   $04                             ; BF90 04                       .
        .byte   $04                             ; BF91 04                       .
        .byte   $04                             ; BF92 04                       .
        .byte   $04                             ; BF93 04                       .
        .byte   $04                             ; BF94 04                       .
        .byte   $04                             ; BF95 04                       .
        .byte   $04                             ; BF96 04                       .
        .byte   $04                             ; BF97 04                       .
        .byte   $04                             ; BF98 04                       .
        .byte   $04                             ; BF99 04                       .
        .byte   $04                             ; BF9A 04                       .
        .byte   $04                             ; BF9B 04                       .
        .byte   $04                             ; BF9C 04                       .
        .byte   $04                             ; BF9D 04                       .
        .byte   $04                             ; BF9E 04                       .
        .byte   $04                             ; BF9F 04                       .
        .byte   $04                             ; BFA0 04                       .
        .byte   $04                             ; BFA1 04                       .
        .byte   $04                             ; BFA2 04                       .
        .byte   $04                             ; BFA3 04                       .
        .byte   $04                             ; BFA4 04                       .
        .byte   $04                             ; BFA5 04                       .
        .byte   $04                             ; BFA6 04                       .
        .byte   $04                             ; BFA7 04                       .
        .byte   $04                             ; BFA8 04                       .
        .byte   $04                             ; BFA9 04                       .
        .byte   $04                             ; BFAA 04                       .
        .byte   $04                             ; BFAB 04                       .
        .byte   $04                             ; BFAC 04                       .
        .byte   $04                             ; BFAD 04                       .
        .byte   $04                             ; BFAE 04                       .
        .byte   $04                             ; BFAF 04                       .
        .byte   $04                             ; BFB0 04                       .
        .byte   $04                             ; BFB1 04                       .
        .byte   $04                             ; BFB2 04                       .
        .byte   $04                             ; BFB3 04                       .
        .byte   $04                             ; BFB4 04                       .
        .byte   $04                             ; BFB5 04                       .
        .byte   $04                             ; BFB6 04                       .
        .byte   $04                             ; BFB7 04                       .
        .byte   $04                             ; BFB8 04                       .
        .byte   $04                             ; BFB9 04                       .
        .byte   $04                             ; BFBA 04                       .
        .byte   $04                             ; BFBB 04                       .
        .byte   $04                             ; BFBC 04                       .
        .byte   $04                             ; BFBD 04                       .
LBFBE:  .byte   $04                             ; BFBE 04                       .
        .byte   $04                             ; BFBF 04                       .
        .byte   $04                             ; BFC0 04                       .
        .byte   $04                             ; BFC1 04                       .
        .byte   $04                             ; BFC2 04                       .
        .byte   $04                             ; BFC3 04                       .
        .byte   $04                             ; BFC4 04                       .
        .byte   $04                             ; BFC5 04                       .
        .byte   $04                             ; BFC6 04                       .
        .byte   $04                             ; BFC7 04                       .
        .byte   $04                             ; BFC8 04                       .
        .byte   $04                             ; BFC9 04                       .
        .byte   $04                             ; BFCA 04                       .
        .byte   $04                             ; BFCB 04                       .
        .byte   $04                             ; BFCC 04                       .
        .byte   $04                             ; BFCD 04                       .
        .byte   $04                             ; BFCE 04                       .
        .byte   $04                             ; BFCF 04                       .
        .byte   $04                             ; BFD0 04                       .
        .byte   $04                             ; BFD1 04                       .
        .byte   $04                             ; BFD2 04                       .
        .byte   $04                             ; BFD3 04                       .
        .byte   $04                             ; BFD4 04                       .
        .byte   $04                             ; BFD5 04                       .
        .byte   $04                             ; BFD6 04                       .
        .byte   $04                             ; BFD7 04                       .
        .byte   $04                             ; BFD8 04                       .
        .byte   $04                             ; BFD9 04                       .
        .byte   $04                             ; BFDA 04                       .
        .byte   $04                             ; BFDB 04                       .
        .byte   $04                             ; BFDC 04                       .
        .byte   $04                             ; BFDD 04                       .
        .byte   $04                             ; BFDE 04                       .
        .byte   $04                             ; BFDF 04                       .
        .byte   $04                             ; BFE0 04                       .
        .byte   $04                             ; BFE1 04                       .
        .byte   $04                             ; BFE2 04                       .
        .byte   $04                             ; BFE3 04                       .
        .byte   $04                             ; BFE4 04                       .
        .byte   $04                             ; BFE5 04                       .
        .byte   $04                             ; BFE6 04                       .
        .byte   $04                             ; BFE7 04                       .
        .byte   $04                             ; BFE8 04                       .
        .byte   $04                             ; BFE9 04                       .
        .byte   $04                             ; BFEA 04                       .
        .byte   $04                             ; BFEB 04                       .
        .byte   $04                             ; BFEC 04                       .
        .byte   $04                             ; BFED 04                       .
        .byte   $04                             ; BFEE 04                       .
        .byte   $04                             ; BFEF 04                       .
        .byte   $04                             ; BFF0 04                       .
        .byte   $04                             ; BFF1 04                       .
        .byte   $04                             ; BFF2 04                       .
        .byte   $04                             ; BFF3 04                       .
        .byte   $04                             ; BFF4 04                       .
        .byte   $04                             ; BFF5 04                       .
        .byte   $04                             ; BFF6 04                       .
        .byte   $04                             ; BFF7 04                       .
        .byte   $04                             ; BFF8 04                       .
        .byte   $04                             ; BFF9 04                       .
        .byte   $04                             ; BFFA 04                       .
        .byte   $04                             ; BFFB 04                       .
        .byte   $04                             ; BFFC 04                       .
        .byte   $04                             ; BFFD 04                       .
        .byte   $04                             ; BFFE 04                       .
        .byte   $04                             ; BFFF 04                       .
