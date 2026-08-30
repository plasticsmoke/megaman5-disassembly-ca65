.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK00"

; =============================================================================
; BANK $00 (mapped at $8000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
; Data half (file +$0900 on): stage $00 (Gravity Man) stage data —
; screen table at $A900 with this bank at $A000; format in
; DATA_REFERENCE.md section 11.
; =============================================================================
L0000           := $0000
L0001           := $0001
L0010           := $0010
L0011           := $0011
L0015           := $0015
L0016           := $0016
L001A           := $001A
L0020           := $0020
L0021           := $0021
L0022           := $0022
L0023           := $0023
L0025           := $0025
L0026           := $0026
L0027           := $0027
L0028           := $0028
L0029           := $0029
L002A           := $002A
L002B           := $002B
L002C           := $002C
L0101           := $0101
L0111           := $0111
L01D3           := $01D3
L0E6C           := $0E6C
L0EBA           := $0EBA
L1000           := $1000
L1110           := $1110
L111C           := $111C
L1210           := $1210
L1221           := $1221
L1323           := $1323
L1626           := $1626
L1727           := $1727
L1827           := $1827
L1919           := $1919
L1A10           := $1A10
L1C2C           := $1C2C
L1E0D           := $1E0D
L1F21           := $1F21
L2000           := $2000
L2021           := $2021
L2065           := $2065
L2322           := $2322
L271F           := $271F
L2800           := $2800
L2810           := $2810
L4C4C           := $4C4C
L5021           := $5021
L682A           := $682A
L6F01           := $6F01
L7776           := $7776
LBD98           := $BD98
LE36D           := $E36D
LE421           := $E421
LE4E5           := $E4E5
LFA27           := $FA27
LFFDC           := $FFDC
; ----------------------------------------------------------------------------
        lda     L0026                           ; 8000 A5 26                    .&
        cmp     #$0E                            ; 8002 C9 0E                    ..
        bne     L800F                           ; 8004 D0 09                    ..
        lda     $F9                             ; 8006 A5 F9                    ..
        cmp     #$08                            ; 8008 C9 08                    ..
        bcc     L800F                           ; 800A 90 03                    ..
        jmp     L8296                           ; 800C 4C 96 82                 L..

; ----------------------------------------------------------------------------
L800F:  lda     L0029                           ; 800F A5 29                    .)
        and     #$1F                            ; 8011 29 1F                    ).
        tay                                     ; 8013 A8                       .
        lda     $A968,y                         ; 8014 B9 68 A9                 .h.
        and     #$3F                            ; 8017 29 3F                    )?
        beq     L808F                           ; 8019 F0 74                    .t
L801B:  sta     L0000                           ; 801B 85 00                    ..
        dec     L0000                           ; 801D C6 00                    ..
        lda     #$00                            ; 801F A9 00                    ..
        sta     L0001                           ; 8021 85 01                    ..
        asl     L0000                           ; 8023 06 00                    ..
        rol     L0001                           ; 8025 26 01                    &.
        asl     L0000                           ; 8027 06 00                    ..
        .byte   $26                             ; 8029 26                       &
L802A:  ora     ($06,x)                         ; 802A 01 06                    ..
        brk                                     ; 802C 00                       .
        rol     L0001                           ; 802D 26 01                    &.
        lda     L0000                           ; 802F A5 00                    ..
        clc                                     ; 8031 18                       .
        adc     #$9E                            ; 8032 69 9E                    i.
        sta     L0000                           ; 8034 85 00                    ..
        lda     L0001                           ; 8036 A5 01                    ..
        adc     #$80                            ; 8038 69 80                    i.
        sta     L0001                           ; 803A 85 01                    ..
        ldy     #$00                            ; 803C A0 00                    ..
        lda     (L0000),y                       ; 803E B1 00                    ..
        sta     $02                             ; 8040 85 02                    ..
        ldy     #$04                            ; 8042 A0 04                    ..
        lda     (L0000),y                       ; 8044 B1 00                    ..
        beq     L804A                           ; 8046 F0 02                    ..
        sta     $EB                             ; 8048 85 EB                    ..
L804A:  ldy     #$01                            ; 804A A0 01                    ..
L804C:  cpy     #$04                            ; 804C C0 04                    ..
        beq     L8058                           ; 804E F0 08                    ..
        lda     (L0000),y                       ; 8050 B1 00                    ..
        sta     $0618,y                         ; 8052 99 18 06                 ...
        sta     $0638,y                         ; 8055 99 38 06                 .8.
L8058:  iny                                     ; 8058 C8                       .
        cpy     #$08                            ; 8059 C0 08                    ..
        bne     L804C                           ; 805B D0 EF                    ..
        lda     $02                             ; 805D A5 02                    ..
        bpl     L808F                           ; 805F 10 2E                    ..
        and     #$0F                            ; 8061 29 0F                    ).
        asl     a                               ; 8063 0A                       .
        asl     a                               ; 8064 0A                       .
        sta     L0000                           ; 8065 85 00                    ..
        asl     a                               ; 8067 0A                       .
        asl     a                               ; 8068 0A                       .
        adc     L0000                           ; 8069 65 00                    e.
        tay                                     ; 806B A8                       .
        ldx     #$00                            ; 806C A2 00                    ..
L806E:  lda     $A988,y                         ; 806E B9 88 A9                 ...
        sta     $0600,x                         ; 8071 9D 00 06                 ...
        sta     $0620,x                         ; 8074 9D 20 06                 . .
        cpx     #$04                            ; 8077 E0 04                    ..
        bcs     L8089                           ; 8079 B0 0E                    ..
        lda     $A998,y                         ; 807B B9 98 A9                 ...
        sta     $05F0,x                         ; 807E 9D F0 05                 ...
        lda     #$00                            ; 8081 A9 00                    ..
        sta     $05F8,x                         ; 8083 9D F8 05                 ...
        sta     $05F4,x                         ; 8086 9D F4 05                 ...
L8089:  iny                                     ; 8089 C8                       .
        inx                                     ; 808A E8                       .
        cpx     #$10                            ; 808B E0 10                    ..
        .byte   $D0                             ; 808D D0                       .
L808E:  .byte   $DF                             ; 808E DF                       .
L808F:  lda     $0620                           ; 808F AD 20 06                 . .
        sta     $0610                           ; 8092 8D 10 06                 ...
        lda     $F0                             ; 8095 A5 F0                    ..
        bne     L809D                           ; 8097 D0 04                    ..
        lda     #$FF                            ; 8099 A9 FF                    ..
        sta     $18                             ; 809B 85 18                    ..
L809D:  rts                                     ; 809D 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; 809E 00                       .
        .byte   $0F                             ; 809F 0F                       .
        jsr     L0016                           ; 80A0 20 16 00                  ..
        bmi     L80E0                           ; 80A3 30 3B                    0;
        .byte   $2B                             ; 80A5 2B                       +
        brk                                     ; 80A6 00                       .
        .byte   $0F                             ; 80A7 0F                       .
        jsr     L002A                           ; 80A8 20 2A 00                  *.
        .byte   $0F                             ; 80AB 0F                       .
        and     L0015                           ; 80AC 25 15                    %.
        brk                                     ; 80AE 00                       .
        .byte   $0F                             ; 80AF 0F                       .
        jsr     L0027                           ; 80B0 20 27 00                  '.
        .byte   $0F                             ; 80B3 0F                       .
        jsr     L0010                           ; 80B4 20 10 00                  ..
        bmi     L80F4                           ; 80B7 30 3B                    0;
        .byte   $2B                             ; 80B9 2B                       +
        brk                                     ; 80BA 00                       .
        .byte   $0F                             ; 80BB 0F                       .
        jsr     L0029                           ; 80BC 20 29 00                  ).
        .byte   $0F                             ; 80BF 0F                       .
        jsr     L0026                           ; 80C0 20 26 00                  &.
        .byte   $0F                             ; 80C3 0F                       .
        jsr     L0029                           ; 80C4 20 29 00                  ).
        .byte   $0F                             ; 80C7 0F                       .
        jsr     L0027                           ; 80C8 20 27 00                  '.
        .byte   $0F                             ; 80CB 0F                       .
        jsr     L0025                           ; 80CC 20 25 00                  %.
        .byte   $0F                             ; 80CF 0F                       .
        jsr     L0027                           ; 80D0 20 27 00                  '.
        .byte   $0F                             ; 80D3 0F                       .
        jsr     L002B                           ; 80D4 20 2B 00                  +.
        .byte   $0F                             ; 80D7 0F                       .
        .byte   $37                             ; 80D8 37                       7
        .byte   $27                             ; 80D9 27                       '
        brk                                     ; 80DA 00                       .
        .byte   $0F                             ; 80DB 0F                       .
        jsr     L002A                           ; 80DC 20 2A 00                  *.
        .byte   $0F                             ; 80DF 0F                       .
L80E0:  jsr     L0027                           ; 80E0 20 27 00                  '.
        .byte   $0F                             ; 80E3 0F                       .
        jsr     L0016                           ; 80E4 20 16 00                  ..
        .byte   $0F                             ; 80E7 0F                       .
        jsr     L002A                           ; 80E8 20 2A 00                  *.
        .byte   $0F                             ; 80EB 0F                       .
        jsr     L0027                           ; 80EC 20 27 00                  '.
        .byte   $0F                             ; 80EF 0F                       .
        jsr     LFA27                           ; 80F0 20 27 FA                  '.
        .byte   $0F                             ; 80F3 0F                       .
L80F4:  jsr     L802A                           ; 80F4 20 2A 80                  *.
        .byte   $0F                             ; 80F7 0F                       .
        jsr     L0027                           ; 80F8 20 27 00                  '.
        .byte   $0F                             ; 80FB 0F                       .
        jsr     L8116                           ; 80FC 20 16 81                  ..
        .byte   $0F                             ; 80FF 0F                       .
        jsr     L0027                           ; 8100 20 27 00                  '.
        .byte   $0F                             ; 8103 0F                       .
        jsr     L8221                           ; 8104 20 21 82                  !.
        .byte   $0F                             ; 8107 0F                       .
        jsr     L0027                           ; 8108 20 27 00                  '.
        .byte   $0F                             ; 810B 0F                       .
        jsr     L8121                           ; 810C 20 21 81                  !.
        .byte   $0F                             ; 810F 0F                       .
        brk                                     ; 8110 00                       .
        brk                                     ; 8111 00                       .
        tsx                                     ; 8112 BA                       .
        .byte   $0F                             ; 8113 0F                       .
        brk                                     ; 8114 00                       .
        brk                                     ; 8115 00                       .
L8116:  sta     ($0F,x)                         ; 8116 81 0F                    ..
        jsr     L0016                           ; 8118 20 16 00                  ..
        bmi     L8158                           ; 811B 30 3B                    0;
        .byte   $2B                             ; 811D 2B                       +
        .byte   $82                             ; 811E 82                       .
        .byte   $0F                             ; 811F 0F                       .
        .byte   $20                             ; 8120 20                        
L8121:  .byte   $2B                             ; 8121 2B                       +
        brk                                     ; 8122 00                       .
        bmi     L8160                           ; 8123 30 3B                    0;
        .byte   $2B                             ; 8125 2B                       +
        .byte   $80                             ; 8126 80                       .
        .byte   $0F                             ; 8127 0F                       .
        jsr     L0027                           ; 8128 20 27 00                  '.
        .byte   $0F                             ; 812B 0F                       .
        jsr     L8316                           ; 812C 20 16 83                  ..
        .byte   $0F                             ; 812F 0F                       .
        jsr     L682A                           ; 8130 20 2A 68                  *h
        .byte   $0F                             ; 8133 0F                       .
        brk                                     ; 8134 00                       .
        brk                                     ; 8135 00                       .
        sta     ($0F,x)                         ; 8136 81 0F                    ..
        brk                                     ; 8138 00                       .
        brk                                     ; 8139 00                       .
        brk                                     ; 813A 00                       .
        .byte   $0F                             ; 813B 0F                       .
        brk                                     ; 813C 00                       .
        brk                                     ; 813D 00                       .
        sta     ($0F,x)                         ; 813E 81 0F                    ..
        jsr     L0023                           ; 8140 20 23 00                  #.
        .byte   $0F                             ; 8143 0F                       .
        jsr     L8226                           ; 8144 20 26 82                  &.
        .byte   $0F                             ; 8147 0F                       .
        jsr     L0016                           ; 8148 20 16 00                  ..
        .byte   $0F                             ; 814B 0F                       .
        jsr     L8121                           ; 814C 20 21 81                  !.
        bmi     L818C                           ; 814F 30 3B                    0;
        .byte   $2B                             ; 8151 2B                       +
        .byte   $7A                             ; 8152 7A                       z
        .byte   $0F                             ; 8153 0F                       .
        jsr     L0029                           ; 8154 20 29 00                  ).
        .byte   $0F                             ; 8157 0F                       .
L8158:  jsr     L0023                           ; 8158 20 23 00                  #.
        .byte   $0F                             ; 815B 0F                       .
        jsr     L0026                           ; 815C 20 26 00                  &.
        .byte   $0F                             ; 815F 0F                       .
L8160:  jsr     L0016                           ; 8160 20 16 00                  ..
        .byte   $0F                             ; 8163 0F                       .
        jsr     L0027                           ; 8164 20 27 00                  '.
        .byte   $0F                             ; 8167 0F                       .
        jsr     L0016                           ; 8168 20 16 00                  ..
        .byte   $0F                             ; 816B 0F                       .
        jsr     L0023                           ; 816C 20 23 00                  #.
        .byte   $0F                             ; 816F 0F                       .
        jsr     L0026                           ; 8170 20 26 00                  &.
        .byte   $0F                             ; 8173 0F                       .
        jsr     L002B                           ; 8174 20 2B 00                  +.
        .byte   $0F                             ; 8177 0F                       .
        jsr     L0027                           ; 8178 20 27 00                  '.
        .byte   $0F                             ; 817B 0F                       .
        jsr     L002A                           ; 817C 20 2A 00                  *.
        .byte   $0F                             ; 817F 0F                       .
L8180:  .byte   $37                             ; 8180 37                       7
        .byte   $27                             ; 8181 27                       '
        brk                                     ; 8182 00                       .
        .byte   $0F                             ; 8183 0F                       .
        jsr     L0026                           ; 8184 20 26 00                  &.
        .byte   $0F                             ; 8187 0F                       .
        jsr     L0016                           ; 8188 20 16 00                  ..
        .byte   $0F                             ; 818B 0F                       .
L818C:  jsr     L0021                           ; 818C 20 21 00                  !.
        .byte   $0F                             ; 818F 0F                       .
        .byte   $37                             ; 8190 37                       7
        rol     L0000                           ; 8191 26 00                    &.
        .byte   $0F                             ; 8193 0F                       .
        jsr     L0021                           ; 8194 20 21 00                  !.
        .byte   $0F                             ; 8197 0F                       .
        jsr     L0015                           ; 8198 20 15 00                  ..
        .byte   $0F                             ; 819B 0F                       .
        jsr     L0023                           ; 819C 20 23 00                  #.
        .byte   $0F                             ; 819F 0F                       .
        jsr     L0016                           ; 81A0 20 16 00                  ..
        .byte   $0F                             ; 81A3 0F                       .
        jsr     L0025                           ; 81A4 20 25 00                  %.
        .byte   $0F                             ; 81A7 0F                       .
        jsr     L0027                           ; 81A8 20 27 00                  '.
        .byte   $0F                             ; 81AB 0F                       .
        jsr     L0026                           ; 81AC 20 26 00                  &.
        .byte   $0F                             ; 81AF 0F                       .
        jsr     L0027                           ; 81B0 20 27 00                  '.
        .byte   $0F                             ; 81B3 0F                       .
        jsr     L0021                           ; 81B4 20 21 00                  !.
        .byte   $0F                             ; 81B7 0F                       .
        jsr     L0016                           ; 81B8 20 16 00                  ..
        .byte   $0F                             ; 81BB 0F                       .
        jsr     L0010                           ; 81BC 20 10 00                  ..
        .byte   $0F                             ; 81BF 0F                       .
        jsr     L0026                           ; 81C0 20 26 00                  &.
        .byte   $0F                             ; 81C3 0F                       .
        and     L0015                           ; 81C4 25 15                    %.
        brk                                     ; 81C6 00                       .
        .byte   $0F                             ; 81C7 0F                       .
        jsr     L0025                           ; 81C8 20 25 00                  %.
        .byte   $0F                             ; 81CB 0F                       .
        jsr     L0022                           ; 81CC 20 22 00                  ".
        .byte   $0F                             ; 81CF 0F                       .
        .byte   $37                             ; 81D0 37                       7
        .byte   $27                             ; 81D1 27                       '
        brk                                     ; 81D2 00                       .
        .byte   $0F                             ; 81D3 0F                       .
        jsr     L0023                           ; 81D4 20 23 00                  #.
        .byte   $0F                             ; 81D7 0F                       .
        jsr     L0015                           ; 81D8 20 15 00                  ..
        .byte   $0F                             ; 81DB 0F                       .
        jsr     L002B                           ; 81DC 20 2B 00                  +.
        .byte   $0F                             ; 81DF 0F                       .
        jsr     L0022                           ; 81E0 20 22 00                  ".
        .byte   $0F                             ; 81E3 0F                       .
        brk                                     ; 81E4 00                       .
        brk                                     ; 81E5 00                       .
        brk                                     ; 81E6 00                       .
        .byte   $0F                             ; 81E7 0F                       .
        jsr     L002B                           ; 81E8 20 2B 00                  +.
        .byte   $0F                             ; 81EB 0F                       .
        jsr     L0016                           ; 81EC 20 16 00                  ..
        .byte   $0F                             ; 81EF 0F                       .
        jsr     L0016                           ; 81F0 20 16 00                  ..
        .byte   $0F                             ; 81F3 0F                       .
        jsr     L002A                           ; 81F4 20 2A 00                  *.
        .byte   $0F                             ; 81F7 0F                       .
        jsr     L002B                           ; 81F8 20 2B 00                  +.
        bmi     L8238                           ; 81FB 30 3B                    0;
        .byte   $2B                             ; 81FD 2B                       +
        brk                                     ; 81FE 00                       .
        .byte   $0F                             ; 81FF 0F                       .
        jsr     L0029                           ; 8200 20 29 00                  ).
        .byte   $0F                             ; 8203 0F                       .
        jsr     L0016                           ; 8204 20 16 00                  ..
        .byte   $0F                             ; 8207 0F                       .
        jsr     L0016                           ; 8208 20 16 00                  ..
        .byte   $0F                             ; 820B 0F                       .
        jsr     L002C                           ; 820C 20 2C 00                  ,.
L820F:  .byte   $0F                             ; 820F 0F                       .
        bmi     L823D                           ; 8210 30 2B                    0+
        brk                                     ; 8212 00                       .
        .byte   $0F                             ; 8213 0F                       .
        jsr     L0027                           ; 8214 20 27 00                  '.
        .byte   $0F                             ; 8217 0F                       .
        bpl     L8230                           ; 8218 10 16                    ..
        brk                                     ; 821A 00                       .
        .byte   $0F                             ; 821B 0F                       .
        jsr     L0027                           ; 821C 20 27 00                  '.
        .byte   $0F                             ; 821F 0F                       .
        .byte   $20                             ; 8220 20                        
L8221:  asl     L0000,x                         ; 8221 16 00                    ..
        .byte   $0F                             ; 8223 0F                       .
        .byte   $3A                             ; 8224 3A                       :
        .byte   $1A                             ; 8225 1A                       .
L8226:  brk                                     ; 8226 00                       .
        .byte   $0F                             ; 8227 0F                       .
        .byte   $37                             ; 8228 37                       7
        rol     L0000                           ; 8229 26 00                    &.
        .byte   $0F                             ; 822B 0F                       .
        jsr     L0029                           ; 822C 20 29 00                  ).
        .byte   $0F                             ; 822F 0F                       .
L8230:  jsr     L0011                           ; 8230 20 11 00                  ..
        .byte   $0F                             ; 8233 0F                       .
        jsr     L0015                           ; 8234 20 15 00                  ..
        .byte   $0F                             ; 8237 0F                       .
L8238:  jsr     L002C                           ; 8238 20 2C 00                  ,.
        .byte   $0F                             ; 823B 0F                       .
        .byte   $27                             ; 823C 27                       '
L823D:  ora     (L0000),y                       ; 823D 11 00                    ..
        .byte   $0F                             ; 823F 0F                       .
        jsr     L0016                           ; 8240 20 16 00                  ..
        .byte   $0F                             ; 8243 0F                       .
        sec                                     ; 8244 38                       8
        .byte   $27                             ; 8245 27                       '
        brk                                     ; 8246 00                       .
        .byte   $0F                             ; 8247 0F                       .
        jsr     L0026                           ; 8248 20 26 00                  &.
        .byte   $0F                             ; 824B 0F                       .
        jsr     L0029                           ; 824C 20 29 00                  ).
        .byte   $0F                             ; 824F 0F                       .
        jsr     L0028                           ; 8250 20 28 00                  (.
        .byte   $0F                             ; 8253 0F                       .
        .byte   $27                             ; 8254 27                       '
        .byte   $17                             ; 8255 17                       .
        brk                                     ; 8256 00                       .
        .byte   $0F                             ; 8257 0F                       .
        jsr     L0016                           ; 8258 20 16 00                  ..
        .byte   $0F                             ; 825B 0F                       .
        jsr     L0026                           ; 825C 20 26 00                  &.
        .byte   $0F                             ; 825F 0F                       .
        jsr     L0015                           ; 8260 20 15 00                  ..
        .byte   $0F                             ; 8263 0F                       .
        .byte   $27                             ; 8264 27                       '
        .byte   $12                             ; 8265 12                       .
        brk                                     ; 8266 00                       .
        .byte   $0F                             ; 8267 0F                       .
        jsr     L002C                           ; 8268 20 2C 00                  ,.
        .byte   $0F                             ; 826B 0F                       .
        jsr     L001A                           ; 826C 20 1A 00                  ..
        .byte   $0F                             ; 826F 0F                       .
        bmi     L8272                           ; 8270 30 00                    0.
L8272:  brk                                     ; 8272 00                       .
        .byte   $0F                             ; 8273 0F                       .
        jsr     L0027                           ; 8274 20 27 00                  '.
        .byte   $0F                             ; 8277 0F                       .
        jsr     L0027                           ; 8278 20 27 00                  '.
        .byte   $0F                             ; 827B 0F                       .
        .byte   $33                             ; 827C 33                       3
L827D:  .byte   $13                             ; 827D 13                       .
        brk                                     ; 827E 00                       .
        .byte   $0F                             ; 827F 0F                       .
        jsr     L0027                           ; 8280 20 27 00                  '.
        .byte   $0F                             ; 8283 0F                       .
        bmi     L829F                           ; 8284 30 19                    0.
        brk                                     ; 8286 00                       .
        .byte   $0F                             ; 8287 0F                       .
        jsr     L0021                           ; 8288 20 21 00                  !.
        .byte   $0F                             ; 828B 0F                       .
        jsr     L002A                           ; 828C 20 2A 00                  *.
        .byte   $0F                             ; 828F 0F                       .
        jsr     L002A                           ; 8290 20 2A 00                  *.
        .byte   $0F                             ; 8293 0F                       .
        .byte   $20                             ; 8294 20                        
        .byte   $15                             ; 8295 15                       .
L8296:  lda     $F9                             ; 8296 A5 F9                    ..
        and     #$07                            ; 8298 29 07                    ).
        asl     a                               ; 829A 0A                       .
        asl     a                               ; 829B 0A                       .
        asl     a                               ; 829C 0A                       .
        sta     L0000                           ; 829D 85 00                    ..
L829F:  asl     a                               ; 829F 0A                       .
        adc     L0000                           ; 82A0 65 00                    e.
        tay                                     ; 82A2 A8                       .
        lda     L82E1,y                         ; 82A3 B9 E1 82                 ...
        sta     $EA                             ; 82A6 85 EA                    ..
        lda     L82E2,y                         ; 82A8 B9 E2 82                 ...
        sta     $EB                             ; 82AB 85 EB                    ..
        lda     L82E3,y                         ; 82AD B9 E3 82                 ...
        sta     $05D0                           ; 82B0 8D D0 05                 ...
        ldx     #$00                            ; 82B3 A2 00                    ..
        stx     $05D2                           ; 82B5 8E D2 05                 ...
        stx     $05D1                           ; 82B8 8E D1 05                 ...
        lda     L82E4,y                         ; 82BB B9 E4 82                 ...
        pha                                     ; 82BE 48                       H
L82BF:  lda     L82E5,y                         ; 82BF B9 E5 82                 ...
        sta     $0620,x                         ; 82C2 9D 20 06                 . .
        cpx     #$04                            ; 82C5 E0 04                    ..
L82C7:  bcs     L82D7                           ; 82C7 B0 0E                    ..
        lda     L82F5,y                         ; 82C9 B9 F5 82                 ...
        sta     $05F0,x                         ; 82CC 9D F0 05                 ...
        lda     #$00                            ; 82CF A9 00                    ..
        .byte   $9D                             ; 82D1 9D                       .
L82D2:  sed                                     ; 82D2 F8                       .
        ora     $9D                             ; 82D3 05 9D                    ..
        .byte   $F4                             ; 82D5 F4                       .
        .byte   $05                             ; 82D6 05                       .
L82D7:  iny                                     ; 82D7 C8                       .
        inx                                     ; 82D8 E8                       .
        cpx     #$10                            ; 82D9 E0 10                    ..
        bne     L82BF                           ; 82DB D0 E2                    ..
        pla                                     ; 82DD 68                       h
        jmp     L801B                           ; 82DE 4C 1B 80                 L..

; ----------------------------------------------------------------------------
L82E1:  .byte   $80                             ; 82E1 80                       .
L82E2:  .byte   $82                             ; 82E2 82                       .
L82E3:  .byte   $87                             ; 82E3 87                       .
L82E4:  .byte   $33                             ; 82E4 33                       3
L82E5:  .byte   $0F                             ; 82E5 0F                       .
        asl     L0020,x                         ; 82E6 16 20                    . 
        brk                                     ; 82E8 00                       .
        .byte   $0F                             ; 82E9 0F                       .
        bit     $0C1C                           ; 82EA 2C 1C 0C                 ,..
        .byte   $0F                             ; 82ED 0F                       .
        jsr     L1727                           ; 82EE 20 27 17                  '.
        .byte   $0F                             ; 82F1 0F                       .
        asl     $1B                             ; 82F2 06 1B                    ..
        .byte   $0B                             ; 82F4 0B                       .
L82F5:  brk                                     ; 82F5 00                       .
        brk                                     ; 82F6 00                       .
        brk                                     ; 82F7 00                       .
        .byte   $80                             ; 82F8 80                       .
L82F9:  .byte   $84                             ; 82F9 84                       .
L82FA:  stx     L0000                           ; 82FA 86 00                    ..
        .byte   $34                             ; 82FC 34                       4
        .byte   $0F                             ; 82FD 0F                       .
        jsr     L1110                           ; 82FE 20 10 11                  ..
        .byte   $0F                             ; 8301 0F                       .
        jsr     L1827                           ; 8302 20 27 18                  '.
        .byte   $0F                             ; 8305 0F                       .
        jsr     L1C2C                           ; 8306 20 2C 1C                  ,.
        .byte   $0F                             ; 8309 0F                       .
        bpl     L830C                           ; 830A 10 00                    ..
L830C:  php                                     ; 830C 08                       .
        brk                                     ; 830D 00                       .
        brk                                     ; 830E 00                       .
        .byte   $89                             ; 830F 89                       .
        brk                                     ; 8310 00                       .
        dey                                     ; 8311 88                       .
        .byte   $FA                             ; 8312 FA                       .
        brk                                     ; 8313 00                       .
        and     $0F,x                           ; 8314 35 0F                    5.
L8316:  and     L1727,y                         ; 8316 39 27 17                 9'.
        .byte   $0F                             ; 8319 0F                       .
        .byte   $1C                             ; 831A 1C                       .
        .byte   $0C                             ; 831B 0C                       .
        ora     $0F                             ; 831C 05 0F                    ..
        jsr     L1626                           ; 831E 20 26 16                  &.
        .byte   $0F                             ; 8321 0F                       .
        jsr     L1221                           ; 8322 20 21 12                  !.
        brk                                     ; 8325 00                       .
        brk                                     ; 8326 00                       .
        brk                                     ; 8327 00                       .
        brk                                     ; 8328 00                       .
        sty     L808E                           ; 8329 8C 8E 80                 ...
        rol     L0021,x                         ; 832C 36 21                    6!
        bmi     L8358                           ; 832E 30 28                    0(
        .byte   $0F                             ; 8330 0F                       .
        and     ($30,x)                         ; 8331 21 30                    !0
        .byte   $2B                             ; 8333 2B                       +
        .byte   $0F                             ; 8334 0F                       .
        and     ($30,x)                         ; 8335 21 30                    !0
        .byte   $27                             ; 8337 27                       '
        .byte   $0F                             ; 8338 0F                       .
        and     ($30,x)                         ; 8339 21 30                    !0
        .byte   $3C                             ; 833B 3C                       <
        bit     a:L0000                         ; 833C 2C 00 00                 ,..
        brk                                     ; 833F 00                       .
        sta     ($90,x)                         ; 8340 81 90                    ..
        sed                                     ; 8342 F8                       .
        brk                                     ; 8343 00                       .
        .byte   $37                             ; 8344 37                       7
        .byte   $0F                             ; 8345 0F                       .
        jsr     L1323                           ; 8346 20 23 13                  #.
        .byte   $0F                             ; 8349 0F                       .
        bit     $011C                           ; 834A 2C 1C 01                 ,..
        .byte   $0F                             ; 834D 0F                       .
        jsr     L1A10                           ; 834E 20 10 1A                  ..
        .byte   $0F                             ; 8351 0F                       .
        sec                                     ; 8352 38                       8
        plp                                     ; 8353 28                       (
        ora     L0000,x                         ; 8354 15 00                    ..
        brk                                     ; 8356 00                       .
        brk                                     ; 8357 00                       .
L8358:  brk                                     ; 8358 00                       .
        sty     $F0,x                           ; 8359 94 F0                    ..
        brk                                     ; 835B 00                       .
        sec                                     ; 835C 38                       8
        .byte   $0F                             ; 835D 0F                       .
        jsr     L0111                           ; 835E 20 11 01                  ..
        .byte   $0F                             ; 8361 0F                       .
        jsr     L0010                           ; 8362 20 10 00                  ..
        .byte   $0F                             ; 8365 0F                       .
        and     ($19,x)                         ; 8366 21 19                    !.
        ora     #$0F                            ; 8368 09 0F                    ..
        jsr     L1727                           ; 836A 20 27 17                  '.
        brk                                     ; 836D 00                       .
        brk                                     ; 836E 00                       .
        brk                                     ; 836F 00                       .
        brk                                     ; 8370 00                       .
        tya                                     ; 8371 98                       .
        txs                                     ; 8372 9A                       .
        brk                                     ; 8373 00                       .
        and     $380F,y                         ; 8374 39 0F 38                 9.8
        .byte   $27                             ; 8377 27                       '
        clc                                     ; 8378 18                       .
        .byte   $0F                             ; 8379 0F                       .
        and     $04                             ; 837A 25 04                    %.
        .byte   $0F                             ; 837C 0F                       .
        .byte   $0F                             ; 837D 0F                       .
        php                                     ; 837E 08                       .
        php                                     ; 837F 08                       .
        ora     #$0F                            ; 8380 09 0F                    ..
        .byte   $3C                             ; 8382 3C                       <
L8383:  .byte   $2C                             ; 8383 2C                       ,
        .byte   $1C                             ; 8384 1C                       .
L8385:  brk                                     ; 8385 00                       .
        .byte   $9D                             ; 8386 9D                       .
L8387:  brk                                     ; 8387 00                       .
        brk                                     ; 8388 00                       .
        .byte   $9C                             ; 8389 9C                       .
        pla                                     ; 838A 68                       h
        brk                                     ; 838B 00                       .
        .byte   $3A                             ; 838C 3A                       :
        .byte   $0F                             ; 838D 0F                       .
        jsr     L0101                           ; 838E 20 01 01                  ..
        .byte   $0F                             ; 8391 0F                       .
        jsr     L111C                           ; 8392 20 1C 11                  ..
        .byte   $0F                             ; 8395 0F                       .
        .byte   $23                             ; 8396 23                       #
        .byte   $12                             ; 8397 12                       .
        .byte   $03                             ; 8398 03                       .
        .byte   $0F                             ; 8399 0F                       .
        jsr     L1210                           ; 839A 20 10 12                  ..
        .byte   $82                             ; 839D 82                       .
        sty     L0000                           ; 839E 84 00                    ..
        brk                                     ; 83A0 00                       .
        .byte   $FF                             ; 83A1 FF                       .
        .byte   $EF                             ; 83A2 EF                       .
        .byte   $FF                             ; 83A3 FF                       .
        .byte   $EF                             ; 83A4 EF                       .
        .byte   $FF                             ; 83A5 FF                       .
        .byte   $FF                             ; 83A6 FF                       .
        .byte   $FF                             ; 83A7 FF                       .
        inc     $FFFF,x                         ; 83A8 FE FF FF                 ...
        .byte   $FF                             ; 83AB FF                       .
        inc     $FEFF,x                         ; 83AC FE FF FE                 ...
        .byte   $FF                             ; 83AF FF                       .
        .byte   $FB                             ; 83B0 FB                       .
        .byte   $FF                             ; 83B1 FF                       .
        .byte   $BF                             ; 83B2 BF                       .
        .byte   $FF                             ; 83B3 FF                       .
        .byte   $FF                             ; 83B4 FF                       .
        .byte   $FF                             ; 83B5 FF                       .
        .byte   $FB                             ; 83B6 FB                       .
        .byte   $FF                             ; 83B7 FF                       .
        inc     $FEFF,x                         ; 83B8 FE FF FE                 ...
        .byte   $FF                             ; 83BB FF                       .
        inc     $FFFF,x                         ; 83BC FE FF FF                 ...
        .byte   $FF                             ; 83BF FF                       .
        .byte   $AF                             ; 83C0 AF                       .
        .byte   $FF                             ; 83C1 FF                       .
        tsx                                     ; 83C2 BA                       .
        .byte   $FF                             ; 83C3 FF                       .
        .byte   $FF                             ; 83C4 FF                       .
        .byte   $FF                             ; 83C5 FF                       .
        .byte   $FF                             ; 83C6 FF                       .
        .byte   $FF                             ; 83C7 FF                       .
        .byte   $FF                             ; 83C8 FF                       .
        .byte   $FF                             ; 83C9 FF                       .
        inc     $BFFF,x                         ; 83CA FE FF BF                 ...
        .byte   $FF                             ; 83CD FF                       .
        .byte   $FF                             ; 83CE FF                       .
        .byte   $F7                             ; 83CF F7                       .
        .byte   $FF                             ; 83D0 FF                       .
        .byte   $FF                             ; 83D1 FF                       .
        .byte   $FF                             ; 83D2 FF                       .
        .byte   $FF                             ; 83D3 FF                       .
        .byte   $FF                             ; 83D4 FF                       .
        .byte   $FF                             ; 83D5 FF                       .
        inc     $FBFF,x                         ; 83D6 FE FF FB                 ...
        .byte   $FF                             ; 83D9 FF                       .
        .byte   $FF                             ; 83DA FF                       .
        .byte   $FF                             ; 83DB FF                       .
        .byte   $FF                             ; 83DC FF                       .
        .byte   $FF                             ; 83DD FF                       .
        .byte   $EB                             ; 83DE EB                       .
        .byte   $FF                             ; 83DF FF                       .
        inc     $FAFF                           ; 83E0 EE FF FA                 ...
        .byte   $FF                             ; 83E3 FF                       .
        .byte   $AB                             ; 83E4 AB                       .
        .byte   $FF                             ; 83E5 FF                       .
        .byte   $FA                             ; 83E6 FA                       .
        sbc     $FFFE,x                         ; 83E7 FD FE FF                 ...
        tsx                                     ; 83EA BA                       .
        .byte   $FF                             ; 83EB FF                       .
        .byte   $FF                             ; 83EC FF                       .
        .byte   $FF                             ; 83ED FF                       .
        inc     $FFFF,x                         ; 83EE FE FF FF                 ...
        .byte   $FF                             ; 83F1 FF                       .
        .byte   $AF                             ; 83F2 AF                       .
        .byte   $FF                             ; 83F3 FF                       .
        inc     $ABFF,x                         ; 83F4 FE FF AB                 ...
        .byte   $FF                             ; 83F7 FF                       .
        .byte   $FF                             ; 83F8 FF                       .
        .byte   $FF                             ; 83F9 FF                       .
        .byte   $FF                             ; 83FA FF                       .
        .byte   $FF                             ; 83FB FF                       .
        .byte   $FF                             ; 83FC FF                       .
        .byte   $FF                             ; 83FD FF                       .
        inc     $FFFF,x                         ; 83FE FE FF FF                 ...
        eor     $57BF,x                         ; 8401 5D BF 57                 ].W
        .byte   $FF                             ; 8404 FF                       .
        .byte   $5F                             ; 8405 5F                       _
        .byte   $FF                             ; 8406 FF                       .
        eor     $D7FF,y                         ; 8407 59 FF D7                 Y..
        .byte   $FF                             ; 840A FF                       .
        eor     $5FFF,y                         ; 840B 59 FF 5F                 Y._
        .byte   $FF                             ; 840E FF                       .
        cmp     $75FE,x                         ; 840F DD FE 75                 ..u
        .byte   $FF                             ; 8412 FF                       .
        .byte   $77                             ; 8413 77                       w
        .byte   $FF                             ; 8414 FF                       .
        .byte   $D7                             ; 8415 D7                       .
        .byte   $FF                             ; 8416 FF                       .
        adc     $FB                             ; 8417 65 FB                    e.
        sbc     $DFFF,x                         ; 8419 FD FF DF                 ...
        .byte   $FF                             ; 841C FF                       .
        eor     $FF,x                           ; 841D 55 FF                    U.
        adc     $F7FF,x                         ; 841F 7D FF F7                 }..
        .byte   $FF                             ; 8422 FF                       .
        sbc     $D7FF,x                         ; 8423 FD FF D7                 ...
        inc     $FF55,x                         ; 8426 FE 55 FF                 .U.
        .byte   $F7                             ; 8429 F7                       .
        .byte   $FF                             ; 842A FF                       .
        and     $FF,x                           ; 842B 35 FF                    5.
        .byte   $57                             ; 842D 57                       W
        .byte   $FF                             ; 842E FF                       .
        sbc     $DD7F,x                         ; 842F FD 7F DD                 ...
        .byte   $FF                             ; 8432 FF                       .
        .byte   $7F                             ; 8433 7F                       .
        .byte   $FF                             ; 8434 FF                       .
        cmp     $FF,x                           ; 8435 D5 FF                    ..
        eor     $DDFF,x                         ; 8437 5D FF DD                 ]..
        .byte   $FF                             ; 843A FF                       .
        .byte   $D7                             ; 843B D7                       .
        inc     $FF55,x                         ; 843C FE 55 FF                 .U.
        sbc     $FE,x                           ; 843F F5 FE                    ..
        .byte   $47                             ; 8441 47                       G
        .byte   $FF                             ; 8442 FF                       .
        lsr     $BC,x                           ; 8443 56 BC                    V.
        eor     $FF,x                           ; 8445 55 FF                    U.
        .byte   $D7                             ; 8447 D7                       .
        .byte   $FF                             ; 8448 FF                       .
        .byte   $77                             ; 8449 77                       w
        .byte   $FF                             ; 844A FF                       .
        .byte   $5F                             ; 844B 5F                       _
        .byte   $FF                             ; 844C FF                       .
        .byte   $D7                             ; 844D D7                       .
        .byte   $BF                             ; 844E BF                       .
        cmp     $FF,x                           ; 844F D5 FF                    ..
        .byte   $F7                             ; 8451 F7                       .
        .byte   $FF                             ; 8452 FF                       .
        .byte   $57                             ; 8453 57                       W
        .byte   $FF                             ; 8454 FF                       .
        sbc     $FF,x                           ; 8455 F5 FF                    ..
        eor     $FF,x                           ; 8457 55 FF                    U.
        .byte   $DF                             ; 8459 DF                       .
        .byte   $FF                             ; 845A FF                       .
        .byte   $DF                             ; 845B DF                       .
        .byte   $FF                             ; 845C FF                       .
        adc     $FF,x                           ; 845D 75 FF                    u.
        cmp     $55FF,x                         ; 845F DD FF 55                 ..U
        .byte   $FF                             ; 8462 FF                       .
        .byte   $57                             ; 8463 57                       W
        .byte   $FF                             ; 8464 FF                       .
        .byte   $D7                             ; 8465 D7                       .
        .byte   $FF                             ; 8466 FF                       .
        eor     $57FF,x                         ; 8467 5D FF 57                 ].W
        .byte   $FF                             ; 846A FF                       .
        .byte   $77                             ; 846B 77                       w
        .byte   $FF                             ; 846C FF                       .
        ora     $FF,x                           ; 846D 15 FF                    ..
        .byte   $57                             ; 846F 57                       W
        .byte   $FF                             ; 8470 FF                       .
        sbc     $FF,x                           ; 8471 F5 FF                    ..
        sbc     $5DFF,x                         ; 8473 FD FF 5D                 ..]
        .byte   $FF                             ; 8476 FF                       .
        .byte   $7F                             ; 8477 7F                       .
        .byte   $FF                             ; 8478 FF                       .
        .byte   $BF                             ; 8479 BF                       .
        .byte   $EF                             ; 847A EF                       .
        ror     $FDFF,x                         ; 847B 7E FF FD                 ~..
        .byte   $FF                             ; 847E FF                       .
        cmp     $7CFF,x                         ; 847F DD FF 7C                 ..|
        .byte   $FF                             ; 8482 FF                       .
        cmp     $FF,x                           ; 8483 D5 FF                    ..
        sbc     $FF,x                           ; 8485 F5 FF                    ..
        cmp     $57BF,x                         ; 8487 DD BF 57                 ..W
        .byte   $DF                             ; 848A DF                       .
        adc     $FF,x                           ; 848B 75 FF                    u.
        .byte   $F4                             ; 848D F4                       .
        .byte   $FF                             ; 848E FF                       .
        sbc     $FF,x                           ; 848F F5 FF                    ..
        adc     $EF,x                           ; 8491 75 EF                    u.
        cmp     $75FF,x                         ; 8493 DD FF 75                 ..u
        .byte   $DF                             ; 8496 DF                       .
        .byte   $77                             ; 8497 77                       w
        .byte   $BF                             ; 8498 BF                       .
        eor     $FF,x                           ; 8499 55 FF                    U.
        eor     $FF,x                           ; 849B 55 FF                    U.
        cmp     $F7FF,x                         ; 849D DD FF F7                 ...
        .byte   $FF                             ; 84A0 FF                       .
        .byte   $D7                             ; 84A1 D7                       .
        .byte   $FF                             ; 84A2 FF                       .
        sbc     $DFFF,x                         ; 84A3 FD FF DF                 ...
        .byte   $FF                             ; 84A6 FF                       .
        .byte   $DF                             ; 84A7 DF                       .
        .byte   $EF                             ; 84A8 EF                       .
        .byte   $77                             ; 84A9 77                       w
        .byte   $FF                             ; 84AA FF                       .
        sbc     $F6FF,x                         ; 84AB FD FF F6                 ...
        .byte   $FF                             ; 84AE FF                       .
        .byte   $DF                             ; 84AF DF                       .
        .byte   $FF                             ; 84B0 FF                       .
        .byte   $57                             ; 84B1 57                       W
        .byte   $FF                             ; 84B2 FF                       .
        sbc     $DF,x                           ; 84B3 F5 DF                    ..
        cmp     $75FF,x                         ; 84B5 DD FF 75                 ..u
        .byte   $FB                             ; 84B8 FB                       .
        .byte   $DF                             ; 84B9 DF                       .
        .byte   $BF                             ; 84BA BF                       .
        .byte   $5F                             ; 84BB 5F                       _
        .byte   $FF                             ; 84BC FF                       .
        .byte   $6F                             ; 84BD 6F                       o
        .byte   $FF                             ; 84BE FF                       .
        .byte   $5F                             ; 84BF 5F                       _
        .byte   $EF                             ; 84C0 EF                       .
        .byte   $DF                             ; 84C1 DF                       .
        .byte   $FF                             ; 84C2 FF                       .
        adc     $FF,x                           ; 84C3 75 FF                    u.
        .byte   $57                             ; 84C5 57                       W
        .byte   $FF                             ; 84C6 FF                       .
        .byte   $7F                             ; 84C7 7F                       .
        .byte   $FF                             ; 84C8 FF                       .
        .byte   $54                             ; 84C9 54                       T
        .byte   $FF                             ; 84CA FF                       .
        .byte   $5B                             ; 84CB 5B                       [
        .byte   $FF                             ; 84CC FF                       .
        .byte   $7F                             ; 84CD 7F                       .
        .byte   $FF                             ; 84CE FF                       .
        .byte   $DF                             ; 84CF DF                       .
        .byte   $FF                             ; 84D0 FF                       .
        .byte   $5F                             ; 84D1 5F                       _
        .byte   $FF                             ; 84D2 FF                       .
        .byte   $D7                             ; 84D3 D7                       .
        .byte   $FF                             ; 84D4 FF                       .
        eor     $FF,x                           ; 84D5 55 FF                    U.
        cmp     $DF,x                           ; 84D7 D5 DF                    ..
        .byte   $7F                             ; 84D9 7F                       .
        .byte   $FF                             ; 84DA FF                       .
        sbc     $57FF,x                         ; 84DB FD FF 57                 ..W
        .byte   $FF                             ; 84DE FF                       .
        .byte   $67                             ; 84DF 67                       g
        .byte   $FF                             ; 84E0 FF                       .
        eor     $FF,x                           ; 84E1 55 FF                    U.
        cmp     $77FF,x                         ; 84E3 DD FF 77                 ..w
        .byte   $DF                             ; 84E6 DF                       .
        .byte   $D7                             ; 84E7 D7                       .
        .byte   $7F                             ; 84E8 7F                       .
        .byte   $57                             ; 84E9 57                       W
        .byte   $FF                             ; 84EA FF                       .
        cmp     $FF,x                           ; 84EB D5 FF                    ..
        .byte   $D7                             ; 84ED D7                       .
        .byte   $F7                             ; 84EE F7                       .
        .byte   $7F                             ; 84EF 7F                       .
        .byte   $FF                             ; 84F0 FF                       .
        .byte   $5F                             ; 84F1 5F                       _
        .byte   $FF                             ; 84F2 FF                       .
        sbc     $FF,x                           ; 84F3 F5 FF                    ..
        eor     $57DF,x                         ; 84F5 5D DF 57                 ].W
        .byte   $FF                             ; 84F8 FF                       .
        eor     $FF,x                           ; 84F9 55 FF                    U.
        eor     $FD,x                           ; 84FB 55 FD                    U.
        adc     $FF,x                           ; 84FD 75 FF                    u.
        adc     $7DFF,x                         ; 84FF 7D FF 7D                 }.}
        .byte   $FF                             ; 8502 FF                       .
        eor     $FF,x                           ; 8503 55 FF                    U.
        .byte   $F7                             ; 8505 F7                       .
        .byte   $7F                             ; 8506 7F                       .
        sbc     $FF,x                           ; 8507 F5 FF                    ..
        .byte   $5F                             ; 8509 5F                       _
        .byte   $EF                             ; 850A EF                       .
        adc     $FD,x                           ; 850B 75 FD                    u.
        eor     $AF,x                           ; 850D 55 AF                    U.
        ora     $F7,x                           ; 850F 15 F7                    ..
        .byte   $D7                             ; 8511 D7                       .
        .byte   $FF                             ; 8512 FF                       .
        sbc     $CD7F,x                         ; 8513 FD 7F CD                 ...
        sbc     $FFDF,x                         ; 8516 FD DF FF                 ...
        .byte   $7F                             ; 8519 7F                       .
        .byte   $FF                             ; 851A FF                       .
        cmp     $D5FF,x                         ; 851B DD FF D5                 ...
        .byte   $DF                             ; 851E DF                       .
        .byte   $57                             ; 851F 57                       W
        .byte   $FF                             ; 8520 FF                       .
        .byte   $77                             ; 8521 77                       w
        .byte   $FF                             ; 8522 FF                       .
        eor     $FF,x                           ; 8523 55 FF                    U.
        eor     $EF,x                           ; 8525 55 EF                    U.
        adc     $FF,x                           ; 8527 75 FF                    u.
        adc     $FF,x                           ; 8529 75 FF                    u.
        adc     $55FF,x                         ; 852B 7D FF 55                 }.U
        .byte   $6F                             ; 852E 6F                       o
        eor     $FF,x                           ; 852F 55 FF                    U.
        sbc     $FF,x                           ; 8531 F5 FF                    ..
        eor     $77FF,x                         ; 8533 5D FF 77                 ].w
        .byte   $FF                             ; 8536 FF                       .
        .byte   $7F                             ; 8537 7F                       .
        .byte   $FF                             ; 8538 FF                       .
        cmp     $FF,x                           ; 8539 D5 FF                    ..
        eor     $D7FF,x                         ; 853B 5D FF D7                 ]..
        .byte   $FF                             ; 853E FF                       .
        .byte   $FF                             ; 853F FF                       .
        sbc     $FD53,x                         ; 8540 FD 53 FD                 .S.
        .byte   $5F                             ; 8543 5F                       _
        .byte   $FF                             ; 8544 FF                       .
        .byte   $FF                             ; 8545 FF                       .
        .byte   $FF                             ; 8546 FF                       .
        adc     $FF,x                           ; 8547 75 FF                    u.
        adc     $FF,x                           ; 8549 75 FF                    u.
        sbc     $FF,x                           ; 854B F5 FF                    ..
        sbc     $FF,x                           ; 854D F5 FF                    ..
        eor     $FF,x                           ; 854F 55 FF                    U.
        eor     $FF,x                           ; 8551 55 FF                    U.
        adc     $D7EF,x                         ; 8553 7D EF D7                 }..
        .byte   $FF                             ; 8556 FF                       .
        .byte   $D7                             ; 8557 D7                       .
        .byte   $FF                             ; 8558 FF                       .
        .byte   $D7                             ; 8559 D7                       .
        sbc     $FBD7,x                         ; 855A FD D7 FB                 ...
        cmp     $75FF,x                         ; 855D DD FF 75                 ..u
        .byte   $FF                             ; 8560 FF                       .
        adc     $7FFF,x                         ; 8561 7D FF 7F                 }..
        .byte   $FF                             ; 8564 FF                       .
        adc     $FF,x                           ; 8565 75 FF                    u.
        eor     $FF,x                           ; 8567 55 FF                    U.
        .byte   $D7                             ; 8569 D7                       .
        .byte   $FF                             ; 856A FF                       .
        .byte   $EF                             ; 856B EF                       .
        .byte   $FF                             ; 856C FF                       .
        eor     $FF,x                           ; 856D 55 FF                    U.
        .byte   $F7                             ; 856F F7                       .
        .byte   $FF                             ; 8570 FF                       .
        adc     $F7FD,x                         ; 8571 7D FD F7                 }..
        .byte   $FF                             ; 8574 FF                       .
        .byte   $F7                             ; 8575 F7                       .
        .byte   $FF                             ; 8576 FF                       .
        adc     $FF,x                           ; 8577 75 FF                    u.
        sbc     $FF,x                           ; 8579 F5 FF                    ..
        .byte   $FF                             ; 857B FF                       .
        .byte   $FF                             ; 857C FF                       .
        .byte   $D7                             ; 857D D7                       .
        .byte   $FF                             ; 857E FF                       .
        lsr     $DF,x                           ; 857F 56 DF                    V.
        .byte   $57                             ; 8581 57                       W
        .byte   $FF                             ; 8582 FF                       .
        eor     $5DFE,x                         ; 8583 5D FE 5D                 ].]
        inc     $FFD5,x                         ; 8586 FE D5 FF                 ...
        .byte   $57                             ; 8589 57                       W
        .byte   $FF                             ; 858A FF                       .
        adc     $5DBF,x                         ; 858B 7D BF 5D                 }.]
        .byte   $7F                             ; 858E 7F                       .
        .byte   $77                             ; 858F 77                       w
        .byte   $FF                             ; 8590 FF                       .
        .byte   $77                             ; 8591 77                       w
        .byte   $FF                             ; 8592 FF                       .
        .byte   $F7                             ; 8593 F7                       .
        .byte   $FF                             ; 8594 FF                       .
        .byte   $F7                             ; 8595 F7                       .
        .byte   $FB                             ; 8596 FB                       .
        .byte   $D7                             ; 8597 D7                       .
        .byte   $FF                             ; 8598 FF                       .
        adc     $FF,x                           ; 8599 75 FF                    u.
        .byte   $37                             ; 859B 37                       7
        .byte   $FB                             ; 859C FB                       .
        ora     $FF,x                           ; 859D 15 FF                    ..
        .byte   $F7                             ; 859F F7                       .
        .byte   $FF                             ; 85A0 FF                       .
        .byte   $DF                             ; 85A1 DF                       .
        ldx     $FF5D                           ; 85A2 AE 5D FF                 .].
        .byte   $D7                             ; 85A5 D7                       .
        .byte   $FF                             ; 85A6 FF                       .
        cmp     $55FF,y                         ; 85A7 D9 FF 55                 ..U
        .byte   $FF                             ; 85AA FF                       .
        .byte   $57                             ; 85AB 57                       W
        .byte   $FF                             ; 85AC FF                       .
        .byte   $57                             ; 85AD 57                       W
        .byte   $FF                             ; 85AE FF                       .
        cmp     $77FF,x                         ; 85AF DD FF 77                 ..w
        .byte   $FF                             ; 85B2 FF                       .
        .byte   $D7                             ; 85B3 D7                       .
        .byte   $FB                             ; 85B4 FB                       .
        sbc     $57FF,x                         ; 85B5 FD FF 57                 ..W
        ldx     $FFD5,y                         ; 85B8 BE D5 FF                 ...
        adc     $F5FF,x                         ; 85BB 7D FF F5                 }..
        .byte   $FF                             ; 85BE FF                       .
        .byte   $F7                             ; 85BF F7                       .
        .byte   $FF                             ; 85C0 FF                       .
        .byte   $7C                             ; 85C1 7C                       |
        .byte   $FF                             ; 85C2 FF                       .
        .byte   $7B                             ; 85C3 7B                       {
        .byte   $FF                             ; 85C4 FF                       .
        .byte   $F7                             ; 85C5 F7                       .
        .byte   $FF                             ; 85C6 FF                       .
        cmp     ($FB),y                         ; 85C7 D1 FB                    ..
        .byte   $57                             ; 85C9 57                       W
        .byte   $FF                             ; 85CA FF                       .
        .byte   $FF                             ; 85CB FF                       .
        .byte   $FB                             ; 85CC FB                       .
        .byte   $DF                             ; 85CD DF                       .
        .byte   $FF                             ; 85CE FF                       .
        .byte   $FF                             ; 85CF FF                       .
        .byte   $FF                             ; 85D0 FF                       .
        .byte   $F7                             ; 85D1 F7                       .
        .byte   $7F                             ; 85D2 7F                       .
        .byte   $D7                             ; 85D3 D7                       .
        .byte   $FF                             ; 85D4 FF                       .
        .byte   $D7                             ; 85D5 D7                       .
        .byte   $FF                             ; 85D6 FF                       .
        eor     $FF,x                           ; 85D7 55 FF                    U.
        .byte   $5F                             ; 85D9 5F                       _
        .byte   $FF                             ; 85DA FF                       .
        .byte   $FF                             ; 85DB FF                       .
        .byte   $FF                             ; 85DC FF                       .
        .byte   $F7                             ; 85DD F7                       .
        .byte   $FF                             ; 85DE FF                       .
        .byte   $F7                             ; 85DF F7                       .
        .byte   $FF                             ; 85E0 FF                       .
        .byte   $FF                             ; 85E1 FF                       .
        sbc     $FF75,x                         ; 85E2 FD 75 FF                 .u.
        cmp     $D7EF,x                         ; 85E5 DD EF D7                 ...
        .byte   $FF                             ; 85E8 FF                       .
        .byte   $67                             ; 85E9 67                       g
        .byte   $EF                             ; 85EA EF                       .
        .byte   $F7                             ; 85EB F7                       .
        .byte   $FF                             ; 85EC FF                       .
        cmp     $DDFB,y                         ; 85ED D9 FB DD                 ...
        .byte   $FF                             ; 85F0 FF                       .
        .byte   $F7                             ; 85F1 F7                       .
        .byte   $DB                             ; 85F2 DB                       .
        .byte   $1F                             ; 85F3 1F                       .
        .byte   $FF                             ; 85F4 FF                       .
        .byte   $D7                             ; 85F5 D7                       .
        .byte   $FF                             ; 85F6 FF                       .
        sbc     $FF,x                           ; 85F7 F5 FF                    ..
        .byte   $D7                             ; 85F9 D7                       .
        .byte   $BF                             ; 85FA BF                       .
        eor     $FF,x                           ; 85FB 55 FF                    U.
        eor     $FF,x                           ; 85FD 55 FF                    U.
        sbc     $FF,x                           ; 85FF F5 FF                    ..
        cmp     $55FF,x                         ; 8601 DD FF 55                 ..U
        .byte   $FF                             ; 8604 FF                       .
        cmp     $F9,x                           ; 8605 D5 F9                    ..
        eor     $FD,x                           ; 8607 55 FD                    U.
        cmp     $FF,x                           ; 8609 D5 FF                    ..
        .byte   $D7                             ; 860B D7                       .
        .byte   $EF                             ; 860C EF                       .
        .byte   $FF                             ; 860D FF                       .
        .byte   $FB                             ; 860E FB                       .
        sbc     $FF,x                           ; 860F F5 FF                    ..
        adc     $77FF,x                         ; 8611 7D FF 77                 }.w
        .byte   $FF                             ; 8614 FF                       .
        .byte   $7F                             ; 8615 7F                       .
        .byte   $FF                             ; 8616 FF                       .
        .byte   $DF                             ; 8617 DF                       .
        .byte   $FF                             ; 8618 FF                       .
        eor     $FF,x                           ; 8619 55 FF                    U.
        adc     $FF,x                           ; 861B 75 FF                    u.
        .byte   $F7                             ; 861D F7                       .
        .byte   $FF                             ; 861E FF                       .
        sbc     $D5FF,x                         ; 861F FD FF D5                 ...
        .byte   $FF                             ; 8622 FF                       .
        sbc     $FF,x                           ; 8623 F5 FF                    ..
        sbc     $FF,x                           ; 8625 F5 FF                    ..
        adc     $55FF,x                         ; 8627 7D FF 55                 }.U
        .byte   $FF                             ; 862A FF                       .
        .byte   $D7                             ; 862B D7                       .
        .byte   $FF                             ; 862C FF                       .
        .byte   $D4                             ; 862D D4                       .
        .byte   $FF                             ; 862E FF                       .
        adc     $55FF,x                         ; 862F 7D FF 55                 }.U
        .byte   $FF                             ; 8632 FF                       .
        .byte   $DF                             ; 8633 DF                       .
        .byte   $BF                             ; 8634 BF                       .
        and     $55FF,x                         ; 8635 3D FF 55                 =.U
        .byte   $FF                             ; 8638 FF                       .
        adc     $FF,x                           ; 8639 75 FF                    u.
        .byte   $DF                             ; 863B DF                       .
        .byte   $FF                             ; 863C FF                       .
        eor     $55FF,x                         ; 863D 5D FF 55                 ].U
        .byte   $FF                             ; 8640 FF                       .
        eor     $E5BF,x                         ; 8641 5D BF E5                 ]..
        .byte   $FB                             ; 8644 FB                       .
        cmp     $FF,x                           ; 8645 D5 FF                    ..
        adc     $FF,x                           ; 8647 75 FF                    u.
        eor     $FF,x                           ; 8649 55 FF                    U.
        cmp     $77FF,x                         ; 864B DD FF 77                 ..w
        .byte   $FF                             ; 864E FF                       .
        .byte   $D7                             ; 864F D7                       .
        .byte   $FF                             ; 8650 FF                       .
        .byte   $D7                             ; 8651 D7                       .
        .byte   $FF                             ; 8652 FF                       .
        .byte   $57                             ; 8653 57                       W
        .byte   $FF                             ; 8654 FF                       .
        adc     $FF,x                           ; 8655 75 FF                    u.
        .byte   $77                             ; 8657 77                       w
        .byte   $FF                             ; 8658 FF                       .
        .byte   $DF                             ; 8659 DF                       .
        .byte   $EF                             ; 865A EF                       .
        sbc     $FF,x                           ; 865B F5 FF                    ..
        .byte   $F7                             ; 865D F7                       .
        .byte   $FF                             ; 865E FF                       .
        .byte   $77                             ; 865F 77                       w
        .byte   $FF                             ; 8660 FF                       .
        inc     $5FFF,x                         ; 8661 FE FF 5F                 .._
        .byte   $FF                             ; 8664 FF                       .
        .byte   $5F                             ; 8665 5F                       _
        .byte   $FF                             ; 8666 FF                       .
        adc     $FB,x                           ; 8667 75 FB                    u.
        sbc     $D7BF,x                         ; 8669 FD BF D7                 ...
        .byte   $FF                             ; 866C FF                       .
        cmp     $FF,x                           ; 866D D5 FF                    ..
        sbc     $FF,x                           ; 866F F5 FF                    ..
        cmp     $DDFF,x                         ; 8671 DD FF DD                 ...
        .byte   $FF                             ; 8674 FF                       .
        adc     $FF,x                           ; 8675 75 FF                    u.
        .byte   $77                             ; 8677 77                       w
        sbc     $FB5B,x                         ; 8678 FD 5B FB                 .[.
        sbc     $FF,x                           ; 867B F5 FF                    ..
        .byte   $D7                             ; 867D D7                       .
        .byte   $FF                             ; 867E FF                       .
        sbc     $FB,x                           ; 867F F5 FB                    ..
        adc     $FF,x                           ; 8681 75 FF                    u.
        .byte   $F7                             ; 8683 F7                       .
        .byte   $FF                             ; 8684 FF                       .
        sbc     $FF,x                           ; 8685 F5 FF                    ..
        .byte   $5F                             ; 8687 5F                       _
        .byte   $FF                             ; 8688 FF                       .
        eor     $7FFF,x                         ; 8689 5D FF 7F                 ]..
L868C:  .byte   $FF                             ; 868C FF                       .
        adc     $FF,x                           ; 868D 75 FF                    u.
        .byte   $17                             ; 868F 17                       .
        .byte   $FF                             ; 8690 FF                       .
        sbc     $FF,x                           ; 8691 F5 FF                    ..
        .byte   $DF                             ; 8693 DF                       .
        .byte   $F7                             ; 8694 F7                       .
        .byte   $FF                             ; 8695 FF                       .
        .byte   $FF                             ; 8696 FF                       .
        cmp     $FF,x                           ; 8697 D5 FF                    ..
        sbc     $D5EF,x                         ; 8699 FD EF D5                 ...
        .byte   $FF                             ; 869C FF                       .
        sbc     $EF,x                           ; 869D F5 EF                    ..
        .byte   $5F                             ; 869F 5F                       _
        inc     $FFFF,x                         ; 86A0 FE FF FF                 ...
        .byte   $57                             ; 86A3 57                       W
        .byte   $FF                             ; 86A4 FF                       .
        eor     $FF,x                           ; 86A5 55 FF                    U.
        eor     $FF,x                           ; 86A7 55 FF                    U.
        adc     $5FFF,x                         ; 86A9 7D FF 5F                 }._
        .byte   $FF                             ; 86AC FF                       .
        sbc     $77FF,x                         ; 86AD FD FF 77                 ..w
        .byte   $FF                             ; 86B0 FF                       .
        adc     $D7E7,x                         ; 86B1 7D E7 D7                 }..
        .byte   $FF                             ; 86B4 FF                       .
        eor     $FF,x                           ; 86B5 55 FF                    U.
        adc     $FF,x                           ; 86B7 75 FF                    u.
        inc     $57FE,x                         ; 86B9 FE FE 57                 ..W
        .byte   $FF                             ; 86BC FF                       .
        sbc     $EF,x                           ; 86BD F5 EF                    ..
        .byte   $DF                             ; 86BF DF                       .
        .byte   $FF                             ; 86C0 FF                       .
        adc     $5FFF,x                         ; 86C1 7D FF 5F                 }._
        .byte   $FF                             ; 86C4 FF                       .
        .byte   $DF                             ; 86C5 DF                       .
        .byte   $FF                             ; 86C6 FF                       .
        eor     $57FF,x                         ; 86C7 5D FF 57                 ].W
        .byte   $FF                             ; 86CA FF                       .
        cmp     $D7FF,x                         ; 86CB DD FF D7                 ...
        .byte   $FF                             ; 86CE FF                       .
        .byte   $5F                             ; 86CF 5F                       _
        .byte   $FF                             ; 86D0 FF                       .
        adc     $DF,x                           ; 86D1 75 DF                    u.
        .byte   $5F                             ; 86D3 5F                       _
        .byte   $FF                             ; 86D4 FF                       .
        .byte   $D7                             ; 86D5 D7                       .
        .byte   $FF                             ; 86D6 FF                       .
        .byte   $57                             ; 86D7 57                       W
        .byte   $FF                             ; 86D8 FF                       .
        .byte   $DF                             ; 86D9 DF                       .
        .byte   $EF                             ; 86DA EF                       .
        .byte   $F7                             ; 86DB F7                       .
        inc     $FFF5,x                         ; 86DC FE F5 FF                 ...
        cmp     $FF,x                           ; 86DF D5 FF                    ..
        adc     $55FF,x                         ; 86E1 7D FF 55                 }.U
        .byte   $FF                             ; 86E4 FF                       .
        eor     $FF,x                           ; 86E5 55 FF                    U.
        .byte   $57                             ; 86E7 57                       W
        .byte   $BF                             ; 86E8 BF                       .
        .byte   $FC                             ; 86E9 FC                       .
        .byte   $FF                             ; 86EA FF                       .
        .byte   $D7                             ; 86EB D7                       .
        .byte   $FF                             ; 86EC FF                       .
        .byte   $5F                             ; 86ED 5F                       _
        .byte   $FF                             ; 86EE FF                       .
        eor     $1DFE,x                         ; 86EF 5D FE 1D                 ]..
        .byte   $FF                             ; 86F2 FF                       .
        .byte   $57                             ; 86F3 57                       W
        .byte   $FF                             ; 86F4 FF                       .
        .byte   $97                             ; 86F5 97                       .
        .byte   $FF                             ; 86F6 FF                       .
        eor     $FF,x                           ; 86F7 55 FF                    U.
        eor     $FD,x                           ; 86F9 55 FD                    U.
        .byte   $77                             ; 86FB 77                       w
        .byte   $FF                             ; 86FC FF                       .
        sbc     $FF,x                           ; 86FD F5 FF                    ..
        .byte   $D7                             ; 86FF D7                       .
        .byte   $FF                             ; 8700 FF                       .
        eor     $FF,x                           ; 8701 55 FF                    U.
        .byte   $F7                             ; 8703 F7                       .
        .byte   $FF                             ; 8704 FF                       .
        eor     $FF,x                           ; 8705 55 FF                    U.
        eor     $FF,x                           ; 8707 55 FF                    U.
        cmp     $55FF,x                         ; 8709 DD FF 55                 ..U
        .byte   $FF                             ; 870C FF                       .
        cmp     $FF,x                           ; 870D D5 FF                    ..
        .byte   $7C                             ; 870F 7C                       |
        .byte   $FF                             ; 8710 FF                       .
        adc     $F7DF,x                         ; 8711 7D DF F7                 }..
        .byte   $FF                             ; 8714 FF                       .
        cmp     $FF,x                           ; 8715 D5 FF                    ..
        eor     $57FD,x                         ; 8717 5D FD 57                 ].W
        .byte   $FF                             ; 871A FF                       .
        .byte   $57                             ; 871B 57                       W
        .byte   $FF                             ; 871C FF                       .
        .byte   $57                             ; 871D 57                       W
        inc     $FFD5,x                         ; 871E FE D5 FF                 ...
        .byte   $FF                             ; 8721 FF                       .
        .byte   $FF                             ; 8722 FF                       .
        .byte   $5F                             ; 8723 5F                       _
        .byte   $FF                             ; 8724 FF                       .
        .byte   $DF                             ; 8725 DF                       .
        .byte   $FF                             ; 8726 FF                       .
        adc     $DDFF,x                         ; 8727 7D FF DD                 }..
        .byte   $EF                             ; 872A EF                       .
        sbc     $FF,x                           ; 872B F5 FF                    ..
        sbc     $FF,x                           ; 872D F5 FF                    ..
        .byte   $FF                             ; 872F FF                       .
        .byte   $7F                             ; 8730 7F                       .
        .byte   $77                             ; 8731 77                       w
        .byte   $FF                             ; 8732 FF                       .
        .byte   $DF                             ; 8733 DF                       .
        .byte   $FF                             ; 8734 FF                       .
        ror     $FF,x                           ; 8735 76 FF                    v.
        eor     $5FFF,x                         ; 8737 5D FF 5F                 ]._
        .byte   $FF                             ; 873A FF                       .
        cmp     $D5FF,x                         ; 873B DD FF D5                 ...
        .byte   $FF                             ; 873E FF                       .
        cmp     $D5FF,x                         ; 873F DD FF D5                 ...
        .byte   $FF                             ; 8742 FF                       .
        eor     $FF,x                           ; 8743 55 FF                    U.
        .byte   $97                             ; 8745 97                       .
        .byte   $F7                             ; 8746 F7                       .
        .byte   $5F                             ; 8747 5F                       _
        .byte   $FB                             ; 8748 FB                       .
        adc     $75F7,x                         ; 8749 7D F7 75                 }.u
        .byte   $FF                             ; 874C FF                       .
        adc     ($FF),y                         ; 874D 71 FF                    q.
        adc     $75FF,x                         ; 874F 7D FF 75                 }.u
        .byte   $FF                             ; 8752 FF                       .
        .byte   $FF                             ; 8753 FF                       .
        .byte   $FF                             ; 8754 FF                       .
        sbc     $EF,x                           ; 8755 F5 EF                    ..
        .byte   $73                             ; 8757 73                       s
        .byte   $FF                             ; 8758 FF                       .
        .byte   $DF                             ; 8759 DF                       .
        .byte   $FF                             ; 875A FF                       .
        .byte   $FF                             ; 875B FF                       .
        .byte   $FF                             ; 875C FF                       .
        .byte   $77                             ; 875D 77                       w
        .byte   $FF                             ; 875E FF                       .
        .byte   $7F                             ; 875F 7F                       .
        .byte   $FF                             ; 8760 FF                       .
        sbc     $FF,x                           ; 8761 F5 FF                    ..
        .byte   $77                             ; 8763 77                       w
        .byte   $FF                             ; 8764 FF                       .
        .byte   $57                             ; 8765 57                       W
        .byte   $FB                             ; 8766 FB                       .
        .byte   $F7                             ; 8767 F7                       .
        inc     $EFDD,x                         ; 8768 FE DD EF                 ...
        eor     $7FFF                           ; 876B 4D FF 7F                 M..
        .byte   $FF                             ; 876E FF                       .
        .byte   $FC                             ; 876F FC                       .
        .byte   $FF                             ; 8770 FF                       .
        sta     $FF,x                           ; 8771 95 FF                    ..
        .byte   $5F                             ; 8773 5F                       _
        .byte   $FB                             ; 8774 FB                       .
        .byte   $D7                             ; 8775 D7                       .
        inc     $FE75,x                         ; 8776 FE 75 FE                 .u.
        cmp     $7DBF,x                         ; 8779 DD BF 7D                 ..}
        .byte   $DF                             ; 877C DF                       .
        .byte   $F7                             ; 877D F7                       .
        .byte   $FF                             ; 877E FF                       .
        .byte   $DF                             ; 877F DF                       .
        inc     $FFD5,x                         ; 8780 FE D5 FF                 ...
        .byte   $5F                             ; 8783 5F                       _
        .byte   $FF                             ; 8784 FF                       .
        .byte   $57                             ; 8785 57                       W
L8786:  .byte   $FF                             ; 8786 FF                       .
        .byte   $DF                             ; 8787 DF                       .
        .byte   $EF                             ; 8788 EF                       .
        adc     $FF,x                           ; 8789 75 FF                    u.
        eor     $FFF7,x                         ; 878B 5D F7 FF                 ]..
        .byte   $FF                             ; 878E FF                       .
        .byte   $7F                             ; 878F 7F                       .
        .byte   $7F                             ; 8790 7F                       .
        .byte   $D7                             ; 8791 D7                       .
        .byte   $FF                             ; 8792 FF                       .
        .byte   $77                             ; 8793 77                       w
        .byte   $7F                             ; 8794 7F                       .
        .byte   $F7                             ; 8795 F7                       .
        .byte   $FF                             ; 8796 FF                       .
        .byte   $7F                             ; 8797 7F                       .
        .byte   $FF                             ; 8798 FF                       .
        .byte   $7F                             ; 8799 7F                       .
        .byte   $FF                             ; 879A FF                       .
        .byte   $FF                             ; 879B FF                       .
        .byte   $FF                             ; 879C FF                       .
        .byte   $D7                             ; 879D D7                       .
        .byte   $EF                             ; 879E EF                       .
        eor     $FF,x                           ; 879F 55 FF                    U.
        .byte   $DF                             ; 87A1 DF                       .
        inc     $FF5F,x                         ; 87A2 FE 5F FF                 ._.
        eor     $FF,x                           ; 87A5 55 FF                    U.
        eor     $FF,x                           ; 87A7 55 FF                    U.
        eor     $FF,x                           ; 87A9 55 FF                    U.
        .byte   $EF                             ; 87AB EF                       .
        .byte   $FB                             ; 87AC FB                       .
        cmp     $7DFF,x                         ; 87AD DD FF 7D                 ..}
        .byte   $FF                             ; 87B0 FF                       .
        sbc     $5FFF,y                         ; 87B1 F9 FF 5F                 .._
        .byte   $BF                             ; 87B4 BF                       .
        .byte   $5F                             ; 87B5 5F                       _
        .byte   $7F                             ; 87B6 7F                       .
        .byte   $5F                             ; 87B7 5F                       _
        .byte   $FF                             ; 87B8 FF                       .
        .byte   $FF                             ; 87B9 FF                       .
        .byte   $FF                             ; 87BA FF                       .
        .byte   $DF                             ; 87BB DF                       .
        .byte   $FF                             ; 87BC FF                       .
        .byte   $17                             ; 87BD 17                       .
        .byte   $FF                             ; 87BE FF                       .
        .byte   $77                             ; 87BF 77                       w
        .byte   $FF                             ; 87C0 FF                       .
        sbc     $FF                             ; 87C1 E5 FF                    ..
        eor     $7F,x                           ; 87C3 55 7F                    U.
        eor     $75FF,x                         ; 87C5 5D FF 75                 ].u
        .byte   $FF                             ; 87C8 FF                       .
        .byte   $DF                             ; 87C9 DF                       .
        .byte   $FF                             ; 87CA FF                       .
        .byte   $F7                             ; 87CB F7                       .
        .byte   $FB                             ; 87CC FB                       .
        and     $D5BF,x                         ; 87CD 3D BF D5                 =..
        .byte   $FB                             ; 87D0 FB                       .
        cmp     $FF,x                           ; 87D1 D5 FF                    ..
        sbc     $D5FF,x                         ; 87D3 FD FF D5                 ...
        .byte   $FF                             ; 87D6 FF                       .
        ror     $FB,x                           ; 87D7 76 FB                    v.
        .byte   $5F                             ; 87D9 5F                       _
        .byte   $FF                             ; 87DA FF                       .
        sbc     $DFDF,x                         ; 87DB FD DF DF                 ...
        .byte   $FF                             ; 87DE FF                       .
        sbc     $FF,x                           ; 87DF F5 FF                    ..
        adc     $55FF,x                         ; 87E1 7D FF 55                 }.U
        .byte   $FF                             ; 87E4 FF                       .
        sbc     $FF,x                           ; 87E5 F5 FF                    ..
        cmp     $FF,x                           ; 87E7 D5 FF                    ..
        adc     $FF,x                           ; 87E9 75 FF                    u.
        .byte   $F7                             ; 87EB F7                       .
        .byte   $FF                             ; 87EC FF                       .
        eor     $DF                             ; 87ED 45 DF                    E.
        cmp     $FF,x                           ; 87EF D5 FF                    ..
        adc     $FF,x                           ; 87F1 75 FF                    u.
        cmp     $DDFF,x                         ; 87F3 DD FF DD                 ...
        .byte   $FF                             ; 87F6 FF                       .
        eor     $F5FF,x                         ; 87F7 5D FF F5                 ]..
        .byte   $FF                             ; 87FA FF                       .
        adc     $75DF,x                         ; 87FB 7D DF 75                 }.u
        .byte   $FF                             ; 87FE FF                       .
        .byte   $55                             ; 87FF 55                       U
; --- $8800 (rt $A800): DAMAGE TABLE, weapon $0 (Power Buster) ---
; $A800[ent_type] via damage_engine $1C:809D; low 7 bits = damage,
; bit 7 = special handling; $00 = ricochet. Types $00-$CF.
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8800  types $00-$0F
        .byte   $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$00,$01 ; 8810  types $10-$1F
        .byte   $01,$01,$00,$00,$00,$01,$00,$00,$01,$01,$01,$01,$00,$01,$00,$00 ; 8820  types $20-$2F
        .byte   $00,$01,$01,$01,$01,$01,$01,$00,$01,$01,$01,$01,$00,$00,$01,$00 ; 8830  types $30-$3F
        .byte   $01,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 ; 8840  types $40-$4F
        .byte   $01,$00,$01,$01,$01,$00,$01,$00,$00,$01,$01,$00,$01,$01,$00,$01 ; 8850  types $50-$5F
        .byte   $01,$00,$01,$01,$01,$01,$01,$01,$01,$01,$00,$01,$00,$00,$01,$00 ; 8860  types $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$00,$00,$00 ; 8870  types $70-$7F
        .byte   $00,$01,$00,$01,$00,$00,$01,$00,$01,$01,$00,$00,$00,$01,$00,$00 ; 8880  types $80-$8F
        .byte   $00,$01,$01,$01,$00,$00,$01,$00,$01,$01,$00,$00,$01,$00,$01,$00 ; 8890  types $90-$9F
        .byte   $01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00 ; 88A0  types $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$00 ; 88B0  types $B0-$BF
        .byte   $00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 88C0  types $C0-$CF
; --- $88D0 (rt $A8D0): remainder (beyond type $CF) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 88D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 88E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 88F0

; =============================================================================
; GRAVITY MAN STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $8900 (rt $A900): screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; 8900  screens $00-$0F
        .byte   $10,$11,$12,$13,$14,$15,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8910  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8920  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8930  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10 ; 8940  screens $40-$4F
; --- $8950 (rt $A950): section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $21,$61,$A1,$A1,$40,$61,$62,$23,$80,$A0,$20,$20,$00,$00,$00,$00 ; 8950
        .byte   $00,$00,$00,$00,$00,$80,$00,$00 ; 8960
; --- $8968 (rt $A968): per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $2A,$2A,$23,$2A,$2A,$02,$02,$2A,$2A,$02,$80,$B3,$00,$00,$00,$00 ; 8968
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; 8978
; --- $8980 (rt $A980): BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $80,$82,$20,$00,$00,$00,$00,$00 ; 8980
; --- $8988 (rt $A988): BG palette (16 bytes) ---
        .byte   $0F,$16,$20,$00,$0F,$2C,$1C,$0C,$0F,$20,$27,$17,$0F,$06,$1B,$0B ; 8988
; --- $8998 (rt $A998): sprite palette-cycle seeds -> $05F0 slots ($A998-$A99B read) ---
        .byte   $00,$00,$00,$80,$00,$40,$00,$00 ; 8998
; --- $89A0 (rt $A9A0): unreferenced ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 89A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$10,$00,$00,$00,$20,$00,$10,$00,$00 ; 89B0
        .byte   $00,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 89C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$20,$20,$00,$00,$00,$00,$00,$00 ; 89D0
; --- $89E0 (rt $A9E0): screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 ; 89E0  terminator / filler
        .byte   $00,$00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$08,$00 ; 89F0  
        .byte   $00                             ; 89FF  -1 base for the spawn arrays
; --- $8A00 (rt $AA00): spawn screens (ascending) ---
        .byte   $01,$01,$01,$02,$02,$02,$02,$02,$02,$03,$03,$03,$03,$04,$05,$06 ; 8A00  entries $00-$0F
        .byte   $06,$07,$07,$07,$07,$09,$0A,$0A,$0A,$0A,$0B,$0B,$0C,$0C,$0D,$0D ; 8A10  entries $10-$1F
        .byte   $0D,$0E,$0E,$0E,$0F,$0F,$0F,$0F,$0F,$10,$10,$10,$10,$10,$11,$11 ; 8A20  entries $20-$2F
        .byte   $11,$11,$11,$12,$12,$13,$13,$14,$15,$FF,$00,$00,$00,$00,$00,$00 ; 8A30  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8A60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01 ; 8A70  entries $70-$7F
; --- $8A80 (rt $AA80): spawn X px ---
        .byte   $20,$A0,$D0,$30,$40,$58,$A0,$C0,$F0,$20,$60,$B8,$E7,$B0,$98,$40 ; 8A80  entries $00-$0F
        .byte   $C0,$20,$70,$80,$C8,$D0,$10,$50,$90,$E0,$30,$90,$10,$90,$20,$98 ; 8A90  entries $10-$1F
        .byte   $E0,$A0,$D0,$F0,$50,$80,$A0,$B0,$F0,$28,$60,$90,$C0,$E0,$08,$50 ; 8AA0  entries $20-$2F
        .byte   $60,$A0,$B8,$38,$58,$90,$B0,$A0,$D8,$FF,$20,$00,$00,$00,$00,$00 ; 8AB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8AC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8AD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8AE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00 ; 8AF0  entries $70-$7F
; --- $8B00 (rt $AB00): spawn Y px ---
        .byte   $B4,$94,$60,$D4,$40,$54,$40,$B4,$B4,$70,$64,$C8,$C4,$6C,$83,$B4 ; 8B00  entries $00-$0F
        .byte   $44,$44,$44,$60,$64,$BD,$BD,$7D,$5D,$78,$78,$9D,$AD,$9D,$AD,$94 ; 8B10  entries $10-$1F
        .byte   $AD,$78,$80,$A4,$8D,$80,$78,$3F,$3A,$AD,$78,$B4,$78,$2A,$58,$AD ; 8B20  entries $20-$2F
        .byte   $78,$BD,$88,$20,$98,$BD,$78,$A8,$00,$FF,$00,$00,$00,$00,$00,$00 ; 8B30  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00,$00,$00,$00,$00 ; 8B70  entries $70-$7F
; --- $8B80 (rt $AB80): spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $19,$19,$12,$19,$42,$2A,$43,$2A,$19,$44,$19,$83,$2A,$0F,$0E,$2A ; 8B80  entries $00-$0F
        .byte   $2A,$19,$2A,$46,$2A,$3B,$3B,$3B,$3B,$86,$84,$3B,$3B,$3B,$3B,$0C ; 8B90  entries $10-$1F
        .byte   $3B,$44,$12,$19,$3B,$12,$45,$88,$1A,$3B,$44,$19,$45,$1A,$12,$3B ; 8BA0  entries $20-$2F
        .byte   $44,$3B,$12,$3F,$3F,$3B,$45,$42,$65,$FF,$00,$00,$00,$00,$00,$00 ; 8BB0  entries $30-$3F
        .byte   $00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8BC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8BD0  entries $50-$5F
        .byte   $00,$01,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8BE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8BF0  entries $70-$7F
; --- $8C00 (rt $AC00): per-screen spawn-list start index ---
        .byte   $00,$00,$03,$09,$0D,$0E,$0F,$11,$15,$15,$16,$1A,$1C,$1E,$21,$24 ; 8C00  screens $00-$0F
        .byte   $29,$2E,$33,$35,$37,$38,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C10  screens $10-$1F
        .byte   $20,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C20  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C30  screens $30-$3F
        .byte   $80,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C40  screens $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C50  screens $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C60  screens $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8C90  screens $90-$9F
        .byte   $00,$01,$00,$00,$00,$00,$10,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CA0  screens $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CB0  screens $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CD0  screens $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CE0  screens $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; 8CF0  screens $F0-$FF
; --- $8D00 (rt $AD00): metatile top-left tile ids ---
        .byte   $00,$83,$84,$83,$83,$86,$3D,$3D,$D2,$82,$A4,$90,$91,$A6,$97,$1C ; 8D00  metatiles $00-$0F
        .byte   $9A,$E7,$65,$38,$61,$38,$2D,$07,$88,$8A,$8A,$8B,$B9,$03,$05,$07 ; 8D10  metatiles $10-$1F
        .byte   $98,$9A,$82,$9B,$61,$23,$0A,$27,$98,$9A,$82,$9B,$61,$43,$00,$47 ; 8D20  metatiles $20-$2F
        .byte   $C4,$A1,$90,$91,$61,$63,$64,$77,$82,$C4,$90,$91,$82,$D2,$1D,$EF ; 8D30  metatiles $30-$3F
        .byte   $B6,$B7,$D6,$D7,$88,$8A,$8A,$8B,$C6,$82,$D4,$D4,$80,$DF,$70,$50 ; 8D40  metatiles $40-$4F
        .byte   $8E,$69,$69,$69,$EF,$D4,$D4,$CB,$9E,$B8,$B8,$8D,$D4,$49,$CB,$CB ; 8D50  metatiles $50-$5F
        .byte   $A3,$BA,$E4,$A3,$BC,$BA,$BA,$82,$FC,$FC,$F9,$C3,$A3,$45,$00,$8E ; 8D60  metatiles $60-$6F
        .byte   $8F,$0F,$0D,$0F,$82,$00,$2B,$0D,$8F,$2F,$0D,$2B,$8E,$0B,$0D,$0B ; 8D70  metatiles $70-$7F
        .byte   $8F,$4F,$0D,$4B,$8E,$0B,$0D,$0B,$8F,$6F,$0D,$6B,$36,$CA,$01,$BA ; 8D80  metatiles $80-$8F
        .byte   $8F,$0F,$0D,$0F,$0E,$2C,$8F,$0F,$8F,$2B,$0D,$2F,$2E,$0E,$4F,$09 ; 8D90  metatiles $90-$9F
        .byte   $8F,$4B,$0D,$4F,$4E,$8F,$9E,$29,$8F,$6B,$0D,$6F,$6E,$EE,$82,$C2 ; 8DA0  metatiles $A0-$AF
        .byte   $63,$64,$64,$64,$64,$64,$83,$A2,$E0,$00,$41,$34,$41,$D8,$C3,$00 ; 8DB0  metatiles $B0-$BF
        .byte   $C0,$00,$F4,$F5,$F8,$82,$0E,$4A,$08,$28,$AE,$5C,$5D,$0F,$2A,$6A ; 8DC0  metatiles $C0-$CF
        .byte   $A3,$82,$82,$6C,$6C,$8F,$0F,$0D,$87,$83,$F9,$82,$A3,$82,$83,$82 ; 8DD0  metatiles $D0-$DF
        .byte   $EE,$36,$BA,$BC,$BC,$DA,$85,$83,$87,$CD,$BA,$B8,$BA,$E2,$A3,$82 ; 8DE0  metatiles $E0-$EF
        .byte   $82,$EC,$85,$83,$83,$85,$85,$83,$85,$83,$83,$8F,$93,$B8,$A3,$82 ; 8DF0  metatiles $F0-$FF
; --- $8E00 (rt $AE00): metatile bottom-left tile ids ---
        .byte   $00,$83,$85,$83,$83,$87,$3D,$3D,$D3,$94,$A5,$91,$A0,$A7,$82,$1D ; 8E00  metatiles $00-$0F
        .byte   $E6,$9A,$39,$39,$02,$39,$2D,$68,$89,$8A,$8A,$8C,$02,$04,$06,$CF ; 8E10  metatiles $10-$1F
        .byte   $99,$82,$9A,$9C,$22,$00,$0B,$68,$99,$82,$9A,$9C,$42,$00,$46,$68 ; 8E20  metatiles $20-$2F
        .byte   $B4,$B5,$91,$A0,$72,$64,$66,$68,$82,$C5,$91,$A0,$82,$D3,$82,$D4 ; 8E30  metatiles $30-$3F
        .byte   $A1,$C7,$D6,$D7,$89,$8A,$8A,$8C,$C7,$82,$D4,$D4,$80,$D6,$70,$50 ; 8E40  metatiles $40-$4F
        .byte   $59,$69,$49,$69,$D4,$D4,$D4,$7A,$CA,$B8,$CB,$CA,$D4,$79,$7B,$9F ; 8E50  metatiles $50-$5F
        .byte   $CA,$BA,$E5,$CA,$BC,$BA,$BA,$82,$FC,$FC,$FA,$C3,$44,$A2,$00,$69 ; 8E60  metatiles $60-$6F
        .byte   $0E,$0C,$0E,$7D,$82,$00,$79,$69,$2E,$0C,$2A,$7D,$0A,$0C,$0A,$79 ; 8E70  metatiles $70-$7F
        .byte   $4E,$0C,$4A,$7D,$0A,$0C,$0A,$79,$6E,$0C,$6A,$7D,$EE,$CB,$20,$BA ; 8E80  metatiles $80-$8F
        .byte   $0E,$0C,$0E,$7D,$0F,$2C,$0E,$0C,$2A,$0C,$2E,$7D,$2F,$0B,$79,$09 ; 8E90  metatiles $90-$9F
        .byte   $4A,$0C,$4E,$7D,$4F,$C3,$82,$29,$6A,$0C,$6E,$7D,$6F,$36,$ED,$A2 ; 8EA0  metatiles $A0-$AF
        .byte   $64,$64,$64,$64,$64,$66,$10,$ED,$E1,$00,$31,$35,$00,$D9,$0C,$00 ; 8EB0  metatiles $B0-$BF
        .byte   $C1,$F3,$F5,$F7,$00,$10,$0F,$4B,$08,$28,$AF,$5D,$4C,$7D,$2B,$6B ; 8EC0  metatiles $C0-$CF
        .byte   $82,$A2,$82,$6C,$6C,$0E,$0C,$0E,$83,$DB,$FA,$A2,$82,$EB,$83,$82 ; 8ED0  metatiles $D0-$DF
        .byte   $36,$EE,$BA,$BC,$DA,$BC,$83,$84,$CC,$CE,$BA,$B8,$E2,$BA,$82,$A2 ; 8EE0  metatiles $E0-$EF
        .byte   $EC,$ED,$83,$83,$84,$84,$83,$DB,$83,$83,$84,$82,$B8,$AB,$82,$EB ; 8EF0  metatiles $F0-$FF
; --- $8F00 (rt $AF00): metatile top-right tile ids ---
        .byte   $00,$82,$94,$90,$91,$96,$3D,$3D,$D2,$94,$C3,$90,$91,$A6,$A7,$AC ; 8F00  metatiles $00-$0F
        .byte   $9A,$45,$00,$4D,$61,$39,$2D,$07,$98,$9A,$82,$9B,$B9,$13,$00,$17 ; 8F10  metatiles $10-$1F
        .byte   $98,$9A,$82,$9B,$61,$33,$1E,$37,$88,$8A,$8A,$8B,$51,$53,$55,$57 ; 8F20  metatiles $20-$2F
        .byte   $82,$B4,$90,$91,$71,$73,$74,$77,$AA,$B0,$AA,$AA,$82,$D2,$AD,$FD ; 8F30  metatiles $30-$3F
        .byte   $B6,$C7,$D4,$D4,$88,$8A,$8A,$8B,$B2,$AA,$D5,$D4,$80,$EF,$00,$40 ; 8F40  metatiles $40-$4F
        .byte   $9E,$BE,$BE,$C3,$EF,$FD,$FF,$BF,$9E,$BE,$BE,$A3,$D4,$BF,$BF,$BF ; 8F50  metatiles $50-$5F
        .byte   $A3,$BA,$D1,$9D,$BA,$F9,$F0,$1F,$FC,$FC,$BA,$C3,$A3,$E7,$60,$8F ; 8F60  metatiles $60-$6F
        .byte   $8F,$1F,$0C,$1B,$82,$D1,$3B,$0C,$8F,$3F,$0C,$3B,$8F,$1F,$0C,$1B ; 8F70  metatiles $70-$7F
        .byte   $8F,$5F,$0C,$5B,$8F,$1B,$0C,$1F,$8F,$7F,$0C,$7F,$26,$A3,$11,$F0 ; 8F80  metatiles $80-$8F
        .byte   $8F,$1B,$0C,$1F,$1E,$3C,$8F,$1F,$8F,$3B,$0C,$3F,$3E,$1E,$5F,$19 ; 8F90  metatiles $90-$9F
        .byte   $8F,$5B,$0C,$5F,$5E,$67,$9E,$48,$8F,$7F,$0C,$7F,$7E,$FE,$AA,$82 ; 8FA0  metatiles $A0-$AF
        .byte   $D0,$4D,$39,$24,$39,$00,$82,$A2,$00,$F2,$00,$00,$E8,$EA,$FA,$64 ; 8FB0  metatiles $B0-$BF
        .byte   $75,$00,$00,$00,$00,$82,$1A,$5A,$18,$09,$AE,$6D,$6D,$1F,$3A,$7E ; 8FC0  metatiles $C0-$CF
        .byte   $B1,$AA,$AA,$5C,$5D,$8F,$1B,$0C,$B3,$AA,$BA,$82,$A3,$82,$82,$BE ; 8FD0  metatiles $D0-$DF
        .byte   $EE,$39,$BA,$BA,$BA,$E2,$A3,$82,$82,$DD,$F9,$82,$BA,$E2,$A9,$BE ; 8FE0  metatiles $E0-$EF
        .byte   $ED,$EC,$A9,$BE,$BE,$A3,$A3,$82,$B1,$AA,$AA,$8F,$A3,$82,$B1,$AA ; 8FF0  metatiles $F0-$FF
; --- $9000 (rt $B000): metatile bottom-right tile ids ---
        .byte   $00,$82,$95,$91,$A0,$97,$3D,$00,$D3,$A4,$A5,$91,$A0,$C3,$97,$AD ; 9000  metatiles $00-$0F
        .byte   $44,$9A,$65,$4D,$02,$38,$2D,$68,$99,$82,$9A,$9C,$12,$00,$16,$CF ; 9010  metatiles $10-$1F
        .byte   $99,$82,$9A,$9C,$32,$00,$1F,$68,$89,$8A,$8A,$8C,$52,$54,$56,$58 ; 9020  metatiles $20-$2F
        .byte   $C4,$B5,$91,$A0,$72,$74,$76,$78,$AA,$B1,$AA,$AA,$82,$D3,$AD,$FD ; 9030  metatiles $30-$3F
        .byte   $B7,$82,$D4,$D4,$89,$8A,$8A,$8C,$B3,$AA,$D5,$D4,$80,$D4,$00,$40 ; 9040  metatiles $40-$4F
        .byte   $BD,$BE,$BF,$C3,$D4,$FD,$FF,$9F,$BD,$BE,$BF,$BD,$D4,$7B,$7B,$7C ; 9050  metatiles $50-$5F
        .byte   $BD,$BA,$F6,$BD,$BA,$FA,$F0,$82,$FC,$00,$BA,$C3,$E6,$A2,$60,$82 ; 9060  metatiles $60-$6F
        .byte   $1E,$0D,$1A,$7D,$82,$F6,$7D,$82,$3E,$0D,$3A,$7D,$1E,$0D,$1A,$7D ; 9070  metatiles $70-$7F
        .byte   $5E,$0D,$5A,$7D,$1A,$0D,$1E,$7D,$7E,$0D,$7E,$7D,$FE,$A2,$30,$F0 ; 9080  metatiles $80-$8F
        .byte   $1A,$0D,$1E,$7D,$1F,$3C,$1E,$0D,$3A,$0D,$3E,$7D,$3F,$1F,$7D,$19 ; 9090  metatiles $90-$9F
        .byte   $5A,$0D,$5E,$7D,$5F,$FA,$82,$48,$7E,$0D,$7E,$7D,$7F,$26,$62,$A2 ; 90A0  metatiles $A0-$AF
        .byte   $00,$2D,$21,$25,$2D,$C9,$10,$ED,$F1,$E3,$41,$00,$E9,$00,$FA,$64 ; 90B0  metatiles $B0-$BF
        .byte   $C8,$00,$00,$00,$00,$10,$1B,$5B,$18,$09,$AF,$6D,$6D,$7D,$3B,$7F ; 90C0  metatiles $C0-$CF
        .byte   $AA,$B0,$AA,$5D,$4C,$1A,$0D,$1E,$AA,$FB,$BA,$A2,$82,$EB,$82,$BE ; 90D0  metatiles $D0-$DF
        .byte   $38,$EE,$BA,$BA,$E2,$BA,$82,$A2,$DC,$DE,$FA,$82,$E2,$BA,$BE,$A8 ; 90E0  metatiles $E0-$EF
        .byte   $EC,$ED,$BE,$BE,$A8,$A2,$82,$EB,$AA,$AA,$B0,$82,$82,$A2,$AA,$FB ; 90F0  metatiles $F0-$FF
; --- $9100 (rt $B100): metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$12,$12,$12,$12,$12,$00,$00,$40,$12,$12,$12,$12,$12,$12,$01 ; 9100  metatiles $00-$0F
        .byte   $12,$12,$00,$00,$10,$00,$00,$10,$12,$12,$12,$12,$12,$12,$12,$12 ; 9110  metatiles $10-$1F
        .byte   $12,$12,$12,$12,$10,$10,$03,$10,$12,$12,$12,$12,$10,$10,$10,$10 ; 9120  metatiles $20-$2F
        .byte   $12,$12,$12,$12,$10,$10,$10,$10,$12,$12,$12,$12,$12,$20,$01,$01 ; 9130  metatiles $30-$3F
        .byte   $12,$12,$01,$01,$12,$12,$12,$12,$12,$12,$01,$01,$01,$01,$01,$01 ; 9140  metatiles $40-$4F
        .byte   $01,$01,$01,$03,$01,$01,$01,$01,$01,$01,$01,$01,$03,$01,$01,$01 ; 9150  metatiles $50-$5F
        .byte   $01,$03,$03,$01,$03,$03,$03,$03,$03,$03,$03,$03,$12,$12,$01,$03 ; 9160  metatiles $60-$6F
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03 ; 9170  metatiles $70-$7F
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$10,$12,$12,$01 ; 9180  metatiles $80-$8F
        .byte   $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$12 ; 9190  metatiles $90-$9F
        .byte   $03,$03,$03,$03,$03,$03,$01,$F2,$03,$03,$03,$03,$03,$10,$12,$12 ; 91A0  metatiles $A0-$AF
        .byte   $03,$03,$03,$03,$03,$03,$12,$12,$03,$03,$03,$00,$03,$03,$03,$03 ; 91B0  metatiles $B0-$BF
        .byte   $03,$03,$03,$03,$03,$12,$03,$03,$F2,$12,$00,$00,$00,$03,$03,$03 ; 91C0  metatiles $C0-$CF
        .byte   $12,$12,$12,$00,$00,$03,$03,$03,$12,$12,$01,$12,$12,$12,$12,$12 ; 91D0  metatiles $D0-$DF
        .byte   $10,$10,$01,$01,$01,$01,$12,$12,$12,$12,$01,$12,$01,$01,$12,$12 ; 91E0  metatiles $E0-$EF
        .byte   $12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$12,$03,$12,$12,$12,$12 ; 91F0  metatiles $F0-$FF
; --- $9200 (rt $B200): 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $22,$23,$22,$23,$20,$21,$20,$21,$30,$31,$38,$39,$32,$33,$3A,$3B ; 9200  blocks $00-$03
        .byte   $40,$41,$48,$49,$22,$23,$2A,$2B,$20,$10,$28,$29,$11,$23,$2A,$2B ; 9210  blocks $04-$07
        .byte   $B2,$B3,$BA,$BB,$B4,$B5,$BC,$BD,$50,$51,$58,$59,$51,$5D,$59,$5E ; 9220  blocks $08-$0B
        .byte   $64,$64,$61,$61,$46,$47,$1E,$1F,$13,$15,$00,$00,$15,$16,$00,$00 ; 9230  blocks $0C-$0F
        .byte   $C2,$C3,$00,$00,$C4,$00,$00,$00,$58,$59,$58,$59,$59,$5E,$59,$5E ; 9240  blocks $10-$13
        .byte   $94,$94,$9C,$9C,$00,$27,$2E,$2F,$12,$15,$00,$00,$06,$06,$00,$00 ; 9250  blocks $14-$17
        .byte   $5B,$59,$63,$59,$59,$57,$59,$5F,$A4,$A4,$AC,$AC,$36,$37,$46,$47 ; 9260  blocks $18-$1B
        .byte   $16,$15,$00,$00,$61,$61,$61,$61,$00,$00,$00,$00,$01,$02,$09,$0A ; 9270  blocks $1C-$1F
        .byte   $03,$04,$0B,$0C,$05,$01,$0D,$0E,$FC,$FD,$EE,$EF,$3C,$3C,$3C,$3C ; 9280  blocks $20-$23
        .byte   $F6,$F7,$FE,$FF,$22,$22,$22,$22,$23,$3C,$23,$38,$E8,$E9,$38,$AE ; 9290  blocks $24-$27
        .byte   $20,$21,$28,$29,$22,$22,$2A,$2A,$23,$00,$2B,$00,$B0,$B1,$B8,$B9 ; 92A0  blocks $28-$2B
        .byte   $00,$C1,$00,$00,$59,$57,$8E,$8E,$00,$00,$8E,$8E,$44,$45,$1C,$1D ; 92B0  blocks $2C-$2F
        .byte   $24,$25,$2C,$2D,$3C,$C5,$F0,$F1,$34,$35,$44,$45,$3C,$3C,$38,$38 ; 92C0  blocks $30-$33
        .byte   $18,$19,$28,$29,$1A,$1B,$2A,$2B,$DA,$DA,$EA,$EA,$46,$47,$47,$00 ; 92D0  blocks $34-$37
        .byte   $7C,$7D,$78,$79,$7E,$7F,$7A,$7B,$84,$85,$98,$99,$86,$87,$9A,$9B ; 92E0  blocks $38-$3B
        .byte   $E2,$E2,$E2,$E2,$F6,$F7,$DC,$DD,$23,$00,$23,$00,$80,$81,$88,$89 ; 92F0  blocks $3C-$3F
        .byte   $82,$83,$8A,$8B,$61,$61,$66,$66,$A0,$A1,$A8,$A9,$A2,$A3,$AA,$AB ; 9300  blocks $40-$43
        .byte   $DA,$DA,$8F,$8F,$DC,$DD,$DC,$DD,$A5,$BE,$00,$00,$E6,$DE,$D0,$D2 ; 9310  blocks $44-$47
        .byte   $E9,$C8,$AE,$C9,$C8,$E6,$C9,$D0,$DE,$DE,$D2,$D2,$E7,$DD,$D1,$FF ; 9320  blocks $48-$4B
        .byte   $46,$47,$22,$23,$44,$45,$20,$21,$00,$00,$C8,$C8,$C9,$C9,$E6,$E7 ; 9330  blocks $4C-$4F
        .byte   $01,$01,$38,$38,$F7,$6A,$FF,$61,$6A,$6A,$61,$61,$64,$6A,$61,$61 ; 9340  blocks $50-$53
        .byte   $6A,$6A,$61,$3D,$96,$97,$78,$79,$72,$73,$7A,$7B,$6A,$6A,$F6,$DE ; 9350  blocks $54-$57
        .byte   $6A,$6A,$DE,$E9,$6A,$3D,$61,$3D,$FE,$D2,$64,$64,$D2,$AE,$64,$64 ; 9360  blocks $58-$5B
        .byte   $6A,$3D,$61,$08,$61,$61,$8E,$8E,$E0,$E1,$AD,$8C,$D8,$D8,$6E,$6E ; 9370  blocks $5C-$5F
        .byte   $D9,$6E,$75,$4F,$6E,$6E,$4F,$4F,$75,$6E,$62,$4F,$4F,$4F,$4F,$4F ; 9380  blocks $60-$63
        .byte   $62,$4F,$62,$4F,$4F,$4F,$8E,$8E,$62,$4F,$8E,$8E,$DE,$E9,$D2,$AE ; 9390  blocks $64-$67
        .byte   $F7,$4F,$DD,$4F,$3C,$C5,$3C,$C5,$DD,$6A,$DD,$61,$6E,$F6,$4F,$FE ; 93A0  blocks $68-$6B
        .byte   $01,$B6,$3C,$C5,$4F,$6E,$4F,$4F,$65,$65,$00,$00,$F6,$DE,$FE,$D2 ; 93B0  blocks $6C-$6F
        .byte   $4F,$4F,$4E,$4E,$F6,$01,$DC,$3C,$E6,$E7,$DC,$DB,$FC,$FD,$D0,$D1 ; 93C0  blocks $70-$73
        .byte   $4F,$4F,$E6,$E7,$DC,$DB,$EE,$EF,$18,$19,$20,$21,$1A,$1B,$22,$23 ; 93D0  blocks $74-$77
        .byte   $75,$64,$62,$61,$64,$F6,$61,$FE,$62,$94,$F7,$9C,$94,$9D,$9C,$9C ; 93E0  blocks $78-$7B
        .byte   $26,$26,$9C,$9C,$DC,$DB,$DC,$AF,$DD,$95,$DD,$A4,$95,$95,$A4,$18 ; 93F0  blocks $7C-$7F
        .byte   $95,$95,$19,$1A,$20,$21,$1A,$1A,$3C,$FC,$3C,$EE,$FD,$3C,$EF,$3C ; 9400  blocks $80-$83
        .byte   $DD,$AC,$DD,$65,$AC,$20,$65,$20,$21,$22,$21,$22,$DD,$00,$DD,$00 ; 9410  blocks $84-$87
        .byte   $00,$20,$00,$28,$21,$22,$29,$2A,$DC,$DB,$D0,$D1,$DD,$00,$FF,$00 ; 9420  blocks $88-$8B
        .byte   $00,$20,$00,$20,$16,$20,$00,$20,$E5,$E4,$ED,$EC,$53,$53,$6B,$6B ; 9430  blocks $8C-$8F
        .byte   $ED,$EC,$ED,$EC,$6B,$6B,$6B,$6B,$8F,$8F,$C8,$C8,$DC,$DB,$DC,$DB ; 9440  blocks $90-$93
        .byte   $DC,$DB,$6C,$6D,$E3,$E3,$E2,$E2,$0F,$3E,$E2,$E2,$E3,$FC,$E2,$EE ; 9450  blocks $94-$97
        .byte   $19,$1A,$21,$22,$1B,$E2,$23,$E2,$E2,$FC,$E2,$EE,$E2,$18,$E2,$20 ; 9460  blocks $98-$9B
        .byte   $19,$19,$21,$21,$23,$E2,$2B,$E2,$E3,$E2,$E2,$E2,$E2,$F8,$E2,$E3 ; 9470  blocks $9C-$9F
        .byte   $D8,$D8,$E5,$E4,$D8,$D8,$00,$00,$D8,$D8,$75,$00,$CC,$00,$D4,$00 ; 9480  blocks $A0-$A3
        .byte   $62,$00,$62,$00,$CB,$CC,$D3,$D4,$CB,$CC,$F8,$D9,$62,$00,$8E,$8E ; 9490  blocks $A4-$A7
        .byte   $21,$21,$21,$21,$5C,$5C,$5C,$5C,$62,$5C,$62,$5C,$D8,$D8,$3C,$3C ; 94A0  blocks $A8-$AB
        .byte   $C0,$00,$68,$00,$68,$00,$69,$00,$8E,$8E,$F8,$D9,$E2,$E2,$EA,$EA ; 94B0  blocks $AC-$AF
        .byte   $ED,$EC,$8E,$8E,$FC,$FD,$FE,$D1,$70,$71,$78,$79,$ED,$EC,$F6,$F7 ; 94C0  blocks $B0-$B3
        .byte   $FC,$FD,$DC,$DB,$86,$DC,$9A,$FE,$A2,$9E,$AA,$AB,$D0,$D1,$E5,$E4 ; 94D0  blocks $B4-$B7
        .byte   $F8,$D8,$00,$00,$FE,$D1,$E5,$E4,$D5,$D6,$98,$99,$D7,$CD,$9A,$9B ; 94E0  blocks $B8-$BB
        .byte   $A2,$A3,$AA,$F8,$D7,$87,$9A,$9B,$F8,$DE,$6F,$D0,$77,$D0,$72,$7F ; 94F0  blocks $BC-$BF
        .byte   $D0,$D1,$84,$85,$7A,$7B,$82,$83,$98,$99,$A0,$A1,$8A,$8B,$72,$73 ; 9500  blocks $C0-$C3
        .byte   $A8,$A9,$D5,$D6,$DD,$3D,$DD,$3D,$DD,$3D,$FF,$08,$82,$83,$8E,$8E ; 9510  blocks $C4-$C7
        .byte   $8E,$8E,$00,$00,$80,$81,$8E,$8E,$72,$73,$8E,$8E,$CB,$8E,$8E,$8E ; 9520  blocks $C8-$CB
        .byte   $00,$FC,$00,$EE,$9F,$9F,$A7,$A7,$00,$D0,$00,$00,$D0,$D1,$00,$00 ; 9530  blocks $CC-$CF
        .byte   $EE,$EF,$00,$00,$45,$45,$1C,$1D,$00,$3D,$00,$3D,$F7,$3D,$DD,$3D ; 9540  blocks $D0-$D3
        .byte   $3C,$3C,$9F,$9F,$3C,$DC,$9F,$DC,$E8,$E9,$F0,$F1,$A7,$A7,$00,$00 ; 9550  blocks $D4-$D7
        .byte   $A7,$FC,$00,$D0,$E4,$FC,$EC,$D0,$EC,$84,$EC,$98,$85,$86,$99,$9A ; 9560  blocks $D8-$DB
        .byte   $EC,$90,$EC,$98,$91,$92,$99,$9A,$93,$E5,$9B,$ED,$D0,$D1,$E3,$CA ; 9570  blocks $DC-$DF
        .byte   $DA,$A0,$EA,$A8,$A1,$A2,$A9,$AA,$A3,$ED,$AB,$ED,$E2,$CA,$E2,$CA ; 9580  blocks $E0-$E3
        .byte   $EB,$EB,$3C,$3C,$D0,$D1,$E3,$E3,$D0,$D1,$7C,$7D,$D0,$D1,$7E,$7F ; 9590  blocks $E4-$E7
        .byte   $78,$79,$80,$81,$F7,$43,$DD,$56,$43,$43,$56,$56,$43,$43,$55,$4B ; 95A0  blocks $E8-$EB
        .byte   $43,$43,$4B,$4B,$43,$FC,$4B,$DC,$DD,$4B,$DD,$4A,$0F,$3E,$4A,$4A ; 95B0  blocks $EC-$EF
        .byte   $4B,$4B,$4A,$4A,$4B,$DC,$4A,$DC,$DD,$4C,$DD,$4C,$4C,$4C,$4C,$4C ; 95C0  blocks $F0-$F3
        .byte   $4C,$DC,$4C,$DC,$FF,$42,$E4,$4B,$42,$42,$4B,$4B,$4D,$42,$3F,$56 ; 95D0  blocks $F4-$F7
        .byte   $42,$42,$56,$56,$42,$DC,$56,$DC,$EC,$4B,$EC,$56,$4B,$4B,$56,$56 ; 95E0  blocks $F8-$FB
        .byte   $54,$4B,$3F,$56,$4B,$DC,$56,$EE,$00,$00,$00,$00,$00,$00,$00,$00 ; 95F0  blocks $FC-$FF
; --- $9600 (rt $B600): screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$01,$00,$02,$03,$04,$02,$03,$05,$06,$07,$08,$09,$0A,$0B,$0C ; 9600
        .byte   $0D,$0E,$0F,$10,$11,$12,$13,$14,$15,$16,$0E,$0F,$17,$18,$19,$1A ; 9610
        .byte   $1B,$16,$0F,$17,$1C,$12,$13,$1D,$05,$1E,$1E,$1E,$1E,$18,$19,$1D ; 9620
        .byte   $1F,$20,$21,$1F,$20,$21,$1F,$20,$22,$23,$24,$24,$23,$24,$24,$23 ; 9630
; layout $01
        .byte   $04,$01,$25,$26,$02,$03,$27,$01,$0C,$28,$29,$2A,$2B,$08,$09,$01 ; 9640
        .byte   $14,$0A,$0B,$1E,$2C,$10,$11,$01,$1A,$18,$19,$0E,$0E,$0F,$17,$01 ; 9650
        .byte   $1D,$12,$13,$0E,$0F,$17,$1C,$06,$1D,$18,$2D,$2E,$2F,$0D,$1E,$01 ; 9660
        .byte   $21,$20,$1F,$27,$30,$15,$1E,$01,$24,$23,$24,$31,$32,$1B,$1E,$01 ; 9670
; layout $02
        .byte   $04,$33,$02,$27,$34,$35,$36,$06,$37,$38,$39,$0C,$3A,$3B,$3C,$3D ; 9680
        .byte   $3E,$3F,$40,$41,$42,$43,$44,$45,$3E,$46,$47,$48,$49,$4A,$4A,$4B ; 9690
        .byte   $3E,$1E,$1E,$1E,$1E,$2B,$08,$09,$4C,$1E,$1E,$1E,$1E,$2C,$10,$11 ; 96A0
        .byte   $00,$1E,$4D,$4C,$4E,$2F,$0D,$2F,$00,$27,$06,$07,$4F,$30,$15,$30 ; 96B0
; layout $03
        .byte   $07,$02,$03,$04,$50,$50,$51,$52,$38,$39,$0C,$0C,$0C,$0C,$53,$52 ; 96C0
        .byte   $3F,$40,$52,$52,$52,$52,$54,$52,$55,$56,$57,$58,$52,$52,$59,$52 ; 96D0
        .byte   $3F,$40,$5A,$5B,$52,$52,$5C,$52,$55,$56,$52,$52,$52,$52,$52,$52 ; 96E0
        .byte   $0D,$2F,$0D,$41,$41,$5D,$5D,$5D,$15,$30,$15,$1E,$1E,$45,$45,$45 ; 96F0
; layout $04
        .byte   $00,$31,$5E,$5E,$04,$02,$5E,$5E,$00,$5F,$5F,$60,$61,$62,$61,$62 ; 9700
        .byte   $00,$63,$63,$64,$63,$64,$63,$64,$00,$65,$63,$64,$65,$66,$65,$66 ; 9710
        .byte   $07,$67,$63,$64,$61,$62,$61,$62,$00,$45,$63,$64,$63,$64,$63,$64 ; 9720
        .byte   $00,$1F,$20,$21,$50,$27,$68,$64,$00,$23,$23,$23,$69,$69,$6A,$52 ; 9730
; layout $05
        .byte   $67,$24,$5E,$5E,$01,$00,$1D,$01,$61,$6B,$22,$6C,$01,$00,$1D,$01 ; 9740
        .byte   $63,$6D,$6B,$22,$01,$00,$1D,$28,$65,$63,$6D,$6B,$28,$05,$6E,$28 ; 9750
        .byte   $45,$63,$63,$6D,$61,$61,$61,$01,$6F,$67,$70,$70,$70,$70,$70,$01 ; 9760
        .byte   $5E,$5E,$1E,$1E,$71,$72,$6C,$01,$6F,$67,$1E,$1E,$6F,$67,$31,$01 ; 9770
; layout $06
        .byte   $05,$31,$5E,$5E,$04,$02,$5E,$5E,$05,$73,$62,$61,$61,$62,$61,$61 ; 9780
        .byte   $00,$61,$64,$63,$74,$66,$74,$74,$00,$63,$66,$65,$75,$75,$75,$75 ; 9790
        .byte   $05,$63,$62,$73,$75,$04,$02,$23,$05,$63,$64,$61,$61,$62,$61,$76 ; 97A0
        .byte   $20,$21,$1F,$20,$76,$77,$70,$01,$23,$22,$22,$69,$01,$00,$52,$01 ; 97B0
; layout $07
        .byte   $04,$02,$5E,$5E,$5E,$75,$31,$01,$62,$61,$61,$61,$78,$79,$4A,$76 ; 97C0
        .byte   $66,$74,$74,$65,$7A,$7B,$7C,$76,$27,$75,$75,$7D,$7E,$7F,$80,$81 ; 97D0
        .byte   $31,$82,$83,$22,$84,$85,$86,$25,$77,$23,$23,$7D,$87,$88,$89,$29 ; 97E0
        .byte   $00,$82,$83,$22,$87,$88,$89,$29,$00,$23,$23,$7D,$87,$88,$89,$29 ; 97F0
; layout $08
        .byte   $00,$03,$03,$8A,$8B,$8C,$86,$25,$00,$1E,$1E,$1E,$1E,$8C,$86,$25 ; 9800
        .byte   $05,$16,$0E,$0F,$17,$8D,$86,$25,$05,$16,$0F,$0E,$0F,$8D,$86,$25 ; 9810
        .byte   $00,$1E,$1E,$1E,$1E,$88,$89,$29,$00,$16,$0E,$0F,$17,$8D,$86,$25 ; 9820
        .byte   $00,$16,$0F,$0E,$0F,$8D,$86,$25,$00,$1E,$1E,$1E,$1E,$8C,$86,$25 ; 9830
; layout $09
        .byte   $05,$1E,$1E,$1E,$1E,$88,$89,$29,$00,$36,$36,$36,$36,$36,$8E,$8F ; 9840
        .byte   $00,$3C,$3C,$3C,$3C,$3C,$90,$14,$00,$3C,$3C,$3C,$3C,$3C,$90,$1A ; 9850
        .byte   $00,$3C,$3C,$3C,$3C,$3C,$90,$91,$05,$3C,$3C,$3C,$3C,$3C,$90,$91 ; 9860
        .byte   $05,$92,$92,$72,$2F,$0D,$2F,$0D,$05,$4F,$4F,$93,$30,$15,$30,$15 ; 9870
; layout $0A
        .byte   $05,$5E,$5E,$94,$93,$94,$93,$94,$8E,$95,$95,$8A,$8A,$8A,$8A,$8A ; 9880
        .byte   $90,$96,$3C,$95,$95,$95,$95,$97,$90,$3C,$3C,$76,$98,$99,$3C,$9A ; 9890
        .byte   $90,$3C,$3D,$76,$98,$99,$9B,$9C,$90,$3D,$93,$76,$98,$99,$9B,$9C ; 98A0
        .byte   $20,$1F,$27,$76,$98,$99,$9B,$9C,$23,$24,$31,$76,$98,$99,$9B,$9C ; 98B0
; layout $0B
        .byte   $33,$02,$27,$28,$89,$9D,$9B,$9C,$77,$95,$95,$95,$95,$9E,$9B,$9C ; 98C0
        .byte   $77,$3C,$3C,$9F,$A0,$A1,$A2,$A1,$00,$3C,$3C,$96,$90,$A3,$A4,$A3 ; 98D0
        .byte   $76,$77,$3C,$3C,$90,$A5,$A4,$A5,$06,$07,$3C,$3C,$24,$A6,$A7,$A6 ; 98E0
        .byte   $A8,$00,$92,$76,$77,$21,$20,$1F,$A8,$00,$4F,$01,$00,$24,$23,$24 ; 98F0
; layout $0C
        .byte   $94,$A9,$AA,$A9,$94,$A9,$AA,$A9,$7D,$AB,$AB,$AB,$7D,$AB,$AB,$AB ; 9900
        .byte   $A1,$A1,$A2,$A1,$A1,$A1,$A2,$A1,$1E,$AC,$A4,$1E,$1E,$AC,$A4,$1E ; 9910
        .byte   $A5,$AD,$A4,$1E,$1E,$AD,$A4,$A5,$A6,$A6,$A7,$AE,$AE,$AE,$A7,$A6 ; 9920
        .byte   $27,$21,$20,$1F,$27,$21,$20,$21,$69,$24,$23,$24,$69,$24,$23,$24 ; 9930
; layout $0D
        .byte   $94,$5E,$5E,$04,$02,$5E,$5E,$04,$7D,$8E,$95,$95,$8E,$95,$95,$8E ; 9940
        .byte   $A1,$90,$AF,$AF,$90,$AF,$AF,$90,$A5,$90,$AC,$AC,$90,$AC,$1E,$90 ; 9950
        .byte   $A5,$90,$AD,$A5,$90,$A3,$A5,$90,$A6,$B0,$A6,$A6,$B0,$A6,$A6,$B0 ; 9960
        .byte   $20,$1F,$27,$21,$20,$1F,$27,$21,$23,$24,$69,$24,$23,$24,$69,$24 ; 9970
; layout $0E
        .byte   $02,$5E,$5E,$04,$02,$94,$5E,$5E,$8E,$8E,$95,$8E,$38,$8A,$B1,$6F ; 9980
        .byte   $90,$90,$96,$90,$B2,$39,$8E,$8E,$90,$90,$3C,$90,$3F,$40,$90,$90 ; 9990
        .byte   $90,$90,$3C,$90,$B2,$56,$90,$90,$B0,$B0,$24,$90,$3F,$40,$90,$B3 ; 99A0
        .byte   $20,$1F,$27,$72,$B2,$56,$44,$45,$23,$24,$69,$93,$3F,$40,$1E,$45 ; 99B0
; layout $0F
        .byte   $5E,$22,$B4,$67,$3A,$B5,$94,$5E,$67,$94,$93,$8E,$42,$B6,$B7,$B8 ; 99C0
        .byte   $8E,$8A,$B9,$90,$BA,$BB,$90,$1E,$90,$8E,$90,$90,$42,$43,$90,$1E ; 99D0
        .byte   $90,$90,$B3,$90,$BA,$BB,$90,$A5,$B0,$B0,$45,$90,$42,$BC,$B3,$A6 ; 99E0
        .byte   $2F,$0D,$45,$44,$BA,$BD,$45,$2F,$30,$15,$45,$1E,$42,$43,$45,$30 ; 99F0
; layout $10
        .byte   $5E,$5E,$23,$31,$6F,$67,$73,$5E,$A1,$A0,$BE,$67,$94,$7D,$3B,$8E ; 9A00
        .byte   $1E,$90,$B2,$BF,$B7,$C0,$43,$90,$1E,$90,$3F,$C1,$90,$C2,$BB,$90 ; 9A10
        .byte   $1E,$90,$B2,$C3,$90,$C4,$43,$90,$A6,$B3,$3F,$C1,$90,$72,$76,$77 ; 9A20
        .byte   $0D,$45,$2F,$0D,$6F,$67,$06,$07,$15,$45,$30,$15,$23,$69,$01,$00 ; 9A30
; layout $11
        .byte   $5E,$5E,$5E,$5E,$94,$69,$C5,$01,$1E,$8E,$6F,$67,$8A,$22,$C6,$01 ; 9A40
        .byte   $1E,$90,$38,$39,$1E,$2B,$08,$01,$A3,$90,$3F,$C7,$2E,$2C,$10,$01 ; 9A50
        .byte   $A5,$90,$B2,$39,$C8,$1E,$1E,$01,$72,$B0,$C9,$40,$A5,$1E,$2E,$01 ; 9A60
        .byte   $6F,$4A,$67,$CA,$CB,$22,$69,$01,$23,$23,$69,$6F,$67,$23,$69,$01 ; 9A70
; layout $12
        .byte   $15,$1E,$CC,$94,$CD,$94,$93,$76,$1B,$1E,$CE,$CF,$1E,$CF,$D0,$01 ; 9A80
        .byte   $0D,$16,$0E,$0E,$0F,$17,$1C,$01,$15,$1E,$16,$0E,$0E,$0F,$17,$01 ; 9A90
        .byte   $1B,$1E,$1E,$1E,$1E,$1E,$1E,$01,$D1,$0D,$2F,$0D,$72,$1E,$D2,$01 ; 9AA0
        .byte   $30,$15,$30,$15,$27,$6C,$D3,$01,$32,$1B,$32,$1B,$93,$69,$C5,$01 ; 9AB0
; layout $13
        .byte   $00,$D4,$D5,$94,$D6,$69,$23,$69,$00,$D7,$D8,$8A,$6F,$67,$23,$69 ; 9AC0
        .byte   $00,$95,$95,$95,$D9,$75,$6F,$67,$00,$3C,$3C,$96,$DA,$DB,$8A,$94 ; 9AD0
        .byte   $00,$3C,$3C,$3C,$DC,$DD,$DE,$DF,$00,$36,$36,$36,$E0,$E1,$E2,$E3 ; 9AE0
        .byte   $00,$1E,$CC,$1F,$20,$21,$1F,$20,$0D,$1E,$CC,$6F,$67,$22,$22,$E4 ; 9AF0
; layout $14
        .byte   $23,$69,$23,$69,$23,$69,$23,$69,$23,$69,$23,$69,$23,$69,$23,$69 ; 9B00
        .byte   $93,$67,$93,$67,$93,$67,$93,$67,$7D,$94,$7D,$94,$7D,$94,$7D,$94 ; 9B10
        .byte   $E5,$E5,$E5,$B7,$E6,$E7,$B7,$DF,$3C,$3C,$3C,$90,$E8,$C1,$90,$E3 ; 9B20
        .byte   $21,$1F,$20,$21,$1F,$20,$21,$1F,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4 ; 9B30
; layout $15
        .byte   $6F,$67,$6F,$67,$6F,$67,$6F,$67,$E9,$EA,$EB,$EC,$EC,$EC,$EC,$ED ; 9B40
        .byte   $EE,$EF,$F0,$F0,$F0,$F0,$F0,$F1,$F2,$F3,$F3,$F3,$F3,$F3,$F3,$F4 ; 9B50
        .byte   $F5,$F6,$F6,$F6,$F7,$F8,$F7,$F9,$FA,$FB,$FB,$FB,$FC,$FB,$FC,$FD ; 9B60
        .byte   $20,$21,$1F,$20,$21,$1F,$20,$21,$E4,$E4,$E4,$E4,$E4,$E4,$E4,$E4 ; 9B70
; layout $16
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9B80
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9B90
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9BA0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9BB0
; layout $17
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9BC0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9BD0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9BE0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9BF0
; layout $18
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9C00
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9C10
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9C20
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9C30
; layout $19
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9C40
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9C50
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9C60
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9C70
; layout $1A
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9C80
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9C90
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9CA0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9CB0
; layout $1B
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9CC0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9CD0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9CE0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9CF0
; layout $1C
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9D00
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9D10
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9D20
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9D30
; layout $1D
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9D40
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9D50
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9D60
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9D70
; layout $1E
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9D80
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9D90
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9DA0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9DB0
; layout $1F
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9DC0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9DD0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9DE0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9DF0
; layout $20
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9E00
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9E10
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9E20
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9E30
; layout $21
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9E40
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9E50
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9E60
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9E70
; layout $22
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9E80
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9E90
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9EA0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9EB0
; layout $23
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9EC0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9ED0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9EE0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9EF0
; layout $24
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9F00
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9F10
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9F20
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9F30
; layout $25
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9F40
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9F50
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9F60
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9F70
; layout $26
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9F80
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9F90
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9FA0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9FB0
; layout $27
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9FC0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9FD0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9FE0
        .byte   $1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E,$1E ; 9FF0
