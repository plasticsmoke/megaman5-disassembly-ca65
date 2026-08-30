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
        eor     L0000,x                         ; 87FF 55 00                    U.
        brk                                     ; 8801 00                       .
        brk                                     ; 8802 00                       .
        brk                                     ; 8803 00                       .
        brk                                     ; 8804 00                       .
        brk                                     ; 8805 00                       .
        brk                                     ; 8806 00                       .
L8807:  brk                                     ; 8807 00                       .
        brk                                     ; 8808 00                       .
        brk                                     ; 8809 00                       .
        brk                                     ; 880A 00                       .
        brk                                     ; 880B 00                       .
        brk                                     ; 880C 00                       .
        brk                                     ; 880D 00                       .
        brk                                     ; 880E 00                       .
        brk                                     ; 880F 00                       .
        ora     (L0001,x)                       ; 8810 01 01                    ..
        ora     (L0001,x)                       ; 8812 01 01                    ..
        ora     (L0001,x)                       ; 8814 01 01                    ..
        ora     (L0001,x)                       ; 8816 01 01                    ..
        ora     (L0001,x)                       ; 8818 01 01                    ..
        ora     (L0001,x)                       ; 881A 01 01                    ..
        ora     (L0001,x)                       ; 881C 01 01                    ..
        brk                                     ; 881E 00                       .
        ora     (L0001,x)                       ; 881F 01 01                    ..
        ora     (L0000,x)                       ; 8821 01 00                    ..
        brk                                     ; 8823 00                       .
        brk                                     ; 8824 00                       .
        ora     (L0000,x)                       ; 8825 01 00                    ..
        brk                                     ; 8827 00                       .
        ora     (L0001,x)                       ; 8828 01 01                    ..
        ora     (L0001,x)                       ; 882A 01 01                    ..
        brk                                     ; 882C 00                       .
        ora     (L0000,x)                       ; 882D 01 00                    ..
        brk                                     ; 882F 00                       .
        brk                                     ; 8830 00                       .
        ora     (L0001,x)                       ; 8831 01 01                    ..
        ora     (L0001,x)                       ; 8833 01 01                    ..
        ora     (L0001,x)                       ; 8835 01 01                    ..
L8837:  brk                                     ; 8837 00                       .
        ora     (L0001,x)                       ; 8838 01 01                    ..
        ora     (L0001,x)                       ; 883A 01 01                    ..
        brk                                     ; 883C 00                       .
        brk                                     ; 883D 00                       .
        ora     (L0000,x)                       ; 883E 01 00                    ..
        ora     (L0000,x)                       ; 8840 01 00                    ..
        brk                                     ; 8842 00                       .
        brk                                     ; 8843 00                       .
        ora     (L0000,x)                       ; 8844 01 00                    ..
        brk                                     ; 8846 00                       .
        brk                                     ; 8847 00                       .
        brk                                     ; 8848 00                       .
        brk                                     ; 8849 00                       .
        brk                                     ; 884A 00                       .
        brk                                     ; 884B 00                       .
        brk                                     ; 884C 00                       .
        brk                                     ; 884D 00                       .
        brk                                     ; 884E 00                       .
        ora     (L0001,x)                       ; 884F 01 01                    ..
        brk                                     ; 8851 00                       .
        ora     (L0001,x)                       ; 8852 01 01                    ..
        ora     (L0000,x)                       ; 8854 01 00                    ..
        ora     (L0000,x)                       ; 8856 01 00                    ..
        brk                                     ; 8858 00                       .
        ora     (L0001,x)                       ; 8859 01 01                    ..
        brk                                     ; 885B 00                       .
        ora     (L0001,x)                       ; 885C 01 01                    ..
        brk                                     ; 885E 00                       .
        ora     (L0001,x)                       ; 885F 01 01                    ..
        brk                                     ; 8861 00                       .
        ora     (L0001,x)                       ; 8862 01 01                    ..
        ora     (L0001,x)                       ; 8864 01 01                    ..
        ora     (L0001,x)                       ; 8866 01 01                    ..
        ora     (L0001,x)                       ; 8868 01 01                    ..
        brk                                     ; 886A 00                       .
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
        ora     (L0001,x)                       ; 887B 01 01                    ..
        brk                                     ; 887D 00                       .
        brk                                     ; 887E 00                       .
        brk                                     ; 887F 00                       .
        brk                                     ; 8880 00                       .
        ora     (L0000,x)                       ; 8881 01 00                    ..
        ora     (L0000,x)                       ; 8883 01 00                    ..
        brk                                     ; 8885 00                       .
        .byte   $01                             ; 8886 01                       .
L8887:  brk                                     ; 8887 00                       .
        ora     (L0001,x)                       ; 8888 01 01                    ..
        brk                                     ; 888A 00                       .
        brk                                     ; 888B 00                       .
        brk                                     ; 888C 00                       .
        ora     (L0000,x)                       ; 888D 01 00                    ..
        brk                                     ; 888F 00                       .
        brk                                     ; 8890 00                       .
        ora     (L0001,x)                       ; 8891 01 01                    ..
        ora     (L0000,x)                       ; 8893 01 00                    ..
        brk                                     ; 8895 00                       .
        ora     (L0000,x)                       ; 8896 01 00                    ..
        ora     (L0001,x)                       ; 8898 01 01                    ..
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
        ora     (L0001,x)                       ; 88BD 01 01                    ..
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
        ora     L0000,x                         ; 8915 15 00                    ..
        brk                                     ; 8917 00                       .
        brk                                     ; 8918 00                       .
        brk                                     ; 8919 00                       .
        brk                                     ; 891A 00                       .
        brk                                     ; 891B 00                       .
        brk                                     ; 891C 00                       .
        brk                                     ; 891D 00                       .
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
        bpl     L8972                           ; 894F 10 21                    .!
        adc     ($A1,x)                         ; 8951 61 A1                    a.
        lda     ($40,x)                         ; 8953 A1 40                    .@
        adc     ($62,x)                         ; 8955 61 62                    ab
        .byte   $23                             ; 8957 23                       #
        .byte   $80                             ; 8958 80                       .
        ldy     #$20                            ; 8959 A0 20                    . 
        jsr     L0000                           ; 895B 20 00 00                  ..
        brk                                     ; 895E 00                       .
        brk                                     ; 895F 00                       .
        brk                                     ; 8960 00                       .
        brk                                     ; 8961 00                       .
        brk                                     ; 8962 00                       .
        brk                                     ; 8963 00                       .
        brk                                     ; 8964 00                       .
        .byte   $80                             ; 8965 80                       .
        brk                                     ; 8966 00                       .
        brk                                     ; 8967 00                       .
        rol     a                               ; 8968 2A                       *
        rol     a                               ; 8969 2A                       *
        .byte   $23                             ; 896A 23                       #
        rol     a                               ; 896B 2A                       *
        rol     a                               ; 896C 2A                       *
        .byte   $02                             ; 896D 02                       .
        .byte   $02                             ; 896E 02                       .
        rol     a                               ; 896F 2A                       *
        rol     a                               ; 8970 2A                       *
        .byte   $02                             ; 8971 02                       .
L8972:  .byte   $80                             ; 8972 80                       .
        .byte   $B3                             ; 8973 B3                       .
        brk                                     ; 8974 00                       .
        brk                                     ; 8975 00                       .
        brk                                     ; 8976 00                       .
        brk                                     ; 8977 00                       .
        brk                                     ; 8978 00                       .
        brk                                     ; 8979 00                       .
        brk                                     ; 897A 00                       .
        brk                                     ; 897B 00                       .
        brk                                     ; 897C 00                       .
        brk                                     ; 897D 00                       .
        brk                                     ; 897E 00                       .
        brk                                     ; 897F 00                       .
        .byte   $80                             ; 8980 80                       .
        .byte   $82                             ; 8981 82                       .
        jsr     L0000                           ; 8982 20 00 00                  ..
        brk                                     ; 8985 00                       .
        brk                                     ; 8986 00                       .
        brk                                     ; 8987 00                       .
L8988:  .byte   $0F                             ; 8988 0F                       .
        asl     L0020,x                         ; 8989 16 20                    . 
        brk                                     ; 898B 00                       .
        .byte   $0F                             ; 898C 0F                       .
        bit     $0C1C                           ; 898D 2C 1C 0C                 ,..
        .byte   $0F                             ; 8990 0F                       .
        jsr     L1727                           ; 8991 20 27 17                  '.
        .byte   $0F                             ; 8994 0F                       .
        asl     $1B                             ; 8995 06 1B                    ..
        .byte   $0B                             ; 8997 0B                       .
        brk                                     ; 8998 00                       .
        brk                                     ; 8999 00                       .
        brk                                     ; 899A 00                       .
        .byte   $80                             ; 899B 80                       .
        brk                                     ; 899C 00                       .
        rti                                     ; 899D 40                       @

; ----------------------------------------------------------------------------
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
        bpl     L89B9                           ; 89B7 10 00                    ..
L89B9:  brk                                     ; 89B9 00                       .
        brk                                     ; 89BA 00                       .
        jsr     L1000                           ; 89BB 20 00 10                  ..
        brk                                     ; 89BE 00                       .
        brk                                     ; 89BF 00                       .
        brk                                     ; 89C0 00                       .
        brk                                     ; 89C1 00                       .
        brk                                     ; 89C2 00                       .
        rti                                     ; 89C3 40                       @

; ----------------------------------------------------------------------------
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
        jsr     L0020                           ; 89D8 20 20 00                   .
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
        ora     (L0000,x)                       ; 89EF 01 00                    ..
        brk                                     ; 89F1 00                       .
        brk                                     ; 89F2 00                       .
        brk                                     ; 89F3 00                       .
        brk                                     ; 89F4 00                       .
        brk                                     ; 89F5 00                       .
        brk                                     ; 89F6 00                       .
        jsr     L0000                           ; 89F7 20 00 00                  ..
        brk                                     ; 89FA 00                       .
        brk                                     ; 89FB 00                       .
        brk                                     ; 89FC 00                       .
        php                                     ; 89FD 08                       .
        brk                                     ; 89FE 00                       .
        brk                                     ; 89FF 00                       .
        ora     (L0001,x)                       ; 8A00 01 01                    ..
        ora     ($02,x)                         ; 8A02 01 02                    ..
        .byte   $02                             ; 8A04 02                       .
        .byte   $02                             ; 8A05 02                       .
        .byte   $02                             ; 8A06 02                       .
        .byte   $02                             ; 8A07 02                       .
        .byte   $02                             ; 8A08 02                       .
        .byte   $03                             ; 8A09 03                       .
        .byte   $03                             ; 8A0A 03                       .
        .byte   $03                             ; 8A0B 03                       .
        .byte   $03                             ; 8A0C 03                       .
        .byte   $04                             ; 8A0D 04                       .
        ora     $06                             ; 8A0E 05 06                    ..
        asl     $07                             ; 8A10 06 07                    ..
        .byte   $07                             ; 8A12 07                       .
        .byte   $07                             ; 8A13 07                       .
L8A14:  .byte   $07                             ; 8A14 07                       .
        ora     #$0A                            ; 8A15 09 0A                    ..
        asl     a                               ; 8A17 0A                       .
        asl     a                               ; 8A18 0A                       .
        asl     a                               ; 8A19 0A                       .
        .byte   $0B                             ; 8A1A 0B                       .
        .byte   $0B                             ; 8A1B 0B                       .
        .byte   $0C                             ; 8A1C 0C                       .
        .byte   $0C                             ; 8A1D 0C                       .
        ora     $0D0D                           ; 8A1E 0D 0D 0D                 ...
        asl     $0E0E                           ; 8A21 0E 0E 0E                 ...
        .byte   $0F                             ; 8A24 0F                       .
        .byte   $0F                             ; 8A25 0F                       .
L8A26:  .byte   $0F                             ; 8A26 0F                       .
L8A27:  .byte   $0F                             ; 8A27 0F                       .
        .byte   $0F                             ; 8A28 0F                       .
L8A29:  bpl     L8A3B                           ; 8A29 10 10                    ..
        bpl     L8A3D                           ; 8A2B 10 10                    ..
        bpl     L8A40                           ; 8A2D 10 11                    ..
        ora     (L0011),y                       ; 8A2F 11 11                    ..
        ora     (L0011),y                       ; 8A31 11 11                    ..
        .byte   $12                             ; 8A33 12                       .
        .byte   $12                             ; 8A34 12                       .
        .byte   $13                             ; 8A35 13                       .
        .byte   $13                             ; 8A36 13                       .
        .byte   $14                             ; 8A37 14                       .
        ora     $FF,x                           ; 8A38 15 FF                    ..
        brk                                     ; 8A3A 00                       .
L8A3B:  brk                                     ; 8A3B 00                       .
        brk                                     ; 8A3C 00                       .
L8A3D:  brk                                     ; 8A3D 00                       .
        brk                                     ; 8A3E 00                       .
        brk                                     ; 8A3F 00                       .
L8A40:  brk                                     ; 8A40 00                       .
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
L8A6D:  brk                                     ; 8A6D 00                       .
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
        ora     (L0020,x)                       ; 8A7F 01 20                    . 
        ldy     #$D0                            ; 8A81 A0 D0                    ..
        bmi     L8AC5                           ; 8A83 30 40                    0@
        cli                                     ; 8A85 58                       X
        ldy     #$C0                            ; 8A86 A0 C0                    ..
        beq     L8AAA                           ; 8A88 F0 20                    . 
        rts                                     ; 8A8A 60                       `

; ----------------------------------------------------------------------------
        clv                                     ; 8A8B B8                       .
        .byte   $E7                             ; 8A8C E7                       .
        bcs     L8A27                           ; 8A8D B0 98                    ..
        rti                                     ; 8A8F 40                       @

; ----------------------------------------------------------------------------
        cpy     #$20                            ; 8A90 C0 20                    . 
        bvs     L8A14                           ; 8A92 70 80                    p.
L8A94:  iny                                     ; 8A94 C8                       .
        bne     L8AA7                           ; 8A95 D0 10                    ..
        bvc     L8A29                           ; 8A97 50 90                    P.
L8A99:  cpx     #$30                            ; 8A99 E0 30                    .0
        bcc     L8AAD                           ; 8A9B 90 10                    ..
        bcc     L8ABF                           ; 8A9D 90 20                    . 
        tya                                     ; 8A9F 98                       .
        cpx     #$A0                            ; 8AA0 E0 A0                    ..
        bne     L8A94                           ; 8AA2 D0 F0                    ..
        bvc     L8A26                           ; 8AA4 50 80                    P.
        .byte   $A0                             ; 8AA6 A0                       .
L8AA7:  bcs     L8A99                           ; 8AA7 B0 F0                    ..
        plp                                     ; 8AA9 28                       (
L8AAA:  rts                                     ; 8AAA 60                       `

; ----------------------------------------------------------------------------
        bcc     L8A6D                           ; 8AAB 90 C0                    ..
L8AAD:  cpx     #$08                            ; 8AAD E0 08                    ..
        bvc     L8B11                           ; 8AAF 50 60                    P`
        ldy     #$B8                            ; 8AB1 A0 B8                    ..
        sec                                     ; 8AB3 38                       8
        cli                                     ; 8AB4 58                       X
        bcc     L8A67                           ; 8AB5 90 B0                    ..
        ldy     #$D8                            ; 8AB7 A0 D8                    ..
        .byte   $FF                             ; 8AB9 FF                       .
        jsr     L0000                           ; 8ABA 20 00 00                  ..
        brk                                     ; 8ABD 00                       .
        brk                                     ; 8ABE 00                       .
L8ABF:  brk                                     ; 8ABF 00                       .
        brk                                     ; 8AC0 00                       .
        brk                                     ; 8AC1 00                       .
        brk                                     ; 8AC2 00                       .
        brk                                     ; 8AC3 00                       .
        brk                                     ; 8AC4 00                       .
L8AC5:  brk                                     ; 8AC5 00                       .
        brk                                     ; 8AC6 00                       .
        brk                                     ; 8AC7 00                       .
        brk                                     ; 8AC8 00                       .
        brk                                     ; 8AC9 00                       .
        brk                                     ; 8ACA 00                       .
        brk                                     ; 8ACB 00                       .
        brk                                     ; 8ACC 00                       .
        brk                                     ; 8ACD 00                       .
        brk                                     ; 8ACE 00                       .
        brk                                     ; 8ACF 00                       .
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
        jsr     L0000                           ; 8AFD 20 00 00                  ..
        ldy     $94,x                           ; 8B00 B4 94                    ..
        rts                                     ; 8B02 60                       `

; ----------------------------------------------------------------------------
        .byte   $D4                             ; 8B03 D4                       .
        rti                                     ; 8B04 40                       @

; ----------------------------------------------------------------------------
        .byte   $54                             ; 8B05 54                       T
        rti                                     ; 8B06 40                       @

; ----------------------------------------------------------------------------
        ldy     $B4,x                           ; 8B07 B4 B4                    ..
        bvs     L8B6F                           ; 8B09 70 64                    pd
        iny                                     ; 8B0B C8                       .
        cpy     $6C                             ; 8B0C C4 6C                    .l
        .byte   $83                             ; 8B0E 83                       .
        ldy     $44,x                           ; 8B0F B4 44                    .D
L8B11:  .byte   $44                             ; 8B11 44                       D
        .byte   $44                             ; 8B12 44                       D
        rts                                     ; 8B13 60                       `

; ----------------------------------------------------------------------------
        .byte   $64                             ; 8B14 64                       d
        lda     $7DBD,x                         ; 8B15 BD BD 7D                 ..}
        eor     $7878,x                         ; 8B18 5D 78 78                 ]xx
        sta     L9DAD,x                         ; 8B1B 9D AD 9D                 ...
        lda     $AD94                           ; 8B1E AD 94 AD                 ...
        sei                                     ; 8B21 78                       x
        .byte   $80                             ; 8B22 80                       .
        ldy     $8D                             ; 8B23 A4 8D                    ..
        .byte   $80                             ; 8B25 80                       .
        sei                                     ; 8B26 78                       x
        .byte   $3F                             ; 8B27 3F                       ?
        .byte   $3A                             ; 8B28 3A                       :
        lda     $B478                           ; 8B29 AD 78 B4                 .x.
        sei                                     ; 8B2C 78                       x
        rol     a                               ; 8B2D 2A                       *
        cli                                     ; 8B2E 58                       X
        lda     $BD78                           ; 8B2F AD 78 BD                 .x.
        dey                                     ; 8B32 88                       .
        jsr     LBD98                           ; 8B33 20 98 BD                  ..
        sei                                     ; 8B36 78                       x
        tay                                     ; 8B37 A8                       .
        brk                                     ; 8B38 00                       .
        .byte   $FF                             ; 8B39 FF                       .
        brk                                     ; 8B3A 00                       .
        brk                                     ; 8B3B 00                       .
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
L8B6F:  brk                                     ; 8B6F 00                       .
        brk                                     ; 8B70 00                       .
        brk                                     ; 8B71 00                       .
        brk                                     ; 8B72 00                       .
        brk                                     ; 8B73 00                       .
        brk                                     ; 8B74 00                       .
        brk                                     ; 8B75 00                       .
        brk                                     ; 8B76 00                       .
        .byte   $04                             ; 8B77 04                       .
        brk                                     ; 8B78 00                       .
        brk                                     ; 8B79 00                       .
        brk                                     ; 8B7A 00                       .
        brk                                     ; 8B7B 00                       .
        brk                                     ; 8B7C 00                       .
        brk                                     ; 8B7D 00                       .
        brk                                     ; 8B7E 00                       .
        brk                                     ; 8B7F 00                       .
        ora     $1219,y                         ; 8B80 19 19 12                 ...
        ora     $2A42,y                         ; 8B83 19 42 2A                 .B*
        .byte   $43                             ; 8B86 43                       C
        rol     a                               ; 8B87 2A                       *
        ora     $1944,y                         ; 8B88 19 44 19                 .D.
        .byte   $83                             ; 8B8B 83                       .
        rol     a                               ; 8B8C 2A                       *
        .byte   $0F                             ; 8B8D 0F                       .
        asl     $2A2A                           ; 8B8E 0E 2A 2A                 .**
        ora     $462A,y                         ; 8B91 19 2A 46                 .*F
        rol     a                               ; 8B94 2A                       *
        .byte   $3B                             ; 8B95 3B                       ;
        .byte   $3B                             ; 8B96 3B                       ;
        .byte   $3B                             ; 8B97 3B                       ;
        .byte   $3B                             ; 8B98 3B                       ;
        stx     $84                             ; 8B99 86 84                    ..
        .byte   $3B                             ; 8B9B 3B                       ;
        .byte   $3B                             ; 8B9C 3B                       ;
        .byte   $3B                             ; 8B9D 3B                       ;
        .byte   $3B                             ; 8B9E 3B                       ;
        .byte   $0C                             ; 8B9F 0C                       .
        .byte   $3B                             ; 8BA0 3B                       ;
        .byte   $44                             ; 8BA1 44                       D
        .byte   $12                             ; 8BA2 12                       .
        ora     $123B,y                         ; 8BA3 19 3B 12                 .;.
        eor     $88                             ; 8BA6 45 88                    E.
        .byte   $1A                             ; 8BA8 1A                       .
        .byte   $3B                             ; 8BA9 3B                       ;
        .byte   $44                             ; 8BAA 44                       D
        ora     $1A45,y                         ; 8BAB 19 45 1A                 .E.
        .byte   $12                             ; 8BAE 12                       .
        .byte   $3B                             ; 8BAF 3B                       ;
        .byte   $44                             ; 8BB0 44                       D
        .byte   $3B                             ; 8BB1 3B                       ;
        .byte   $12                             ; 8BB2 12                       .
        .byte   $3F                             ; 8BB3 3F                       ?
        .byte   $3F                             ; 8BB4 3F                       ?
        .byte   $3B                             ; 8BB5 3B                       ;
        eor     $42                             ; 8BB6 45 42                    EB
        adc     $FF                             ; 8BB8 65 FF                    e.
        brk                                     ; 8BBA 00                       .
        brk                                     ; 8BBB 00                       .
        brk                                     ; 8BBC 00                       .
        brk                                     ; 8BBD 00                       .
        brk                                     ; 8BBE 00                       .
        brk                                     ; 8BBF 00                       .
        brk                                     ; 8BC0 00                       .
        brk                                     ; 8BC1 00                       .
        brk                                     ; 8BC2 00                       .
        bpl     L8BC5                           ; 8BC3 10 00                    ..
L8BC5:  brk                                     ; 8BC5 00                       .
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
        ora     (L0000,x)                       ; 8BE1 01 00                    ..
        brk                                     ; 8BE3 00                       .
        brk                                     ; 8BE4 00                       .
        jsr     L0000                           ; 8BE5 20 00 00                  ..
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
        brk                                     ; 8C01 00                       .
        .byte   $03                             ; 8C02 03                       .
        ora     #$0D                            ; 8C03 09 0D                    ..
        asl     $110F                           ; 8C05 0E 0F 11                 ...
        ora     L0015,x                         ; 8C08 15 15                    ..
        asl     L001A,x                         ; 8C0A 16 1A                    ..
        .byte   $1C                             ; 8C0C 1C                       .
        asl     $2421,x                         ; 8C0D 1E 21 24                 .!$
        and     #$2E                            ; 8C10 29 2E                    ).
        .byte   $33                             ; 8C12 33                       3
        and     $37,x                           ; 8C13 35 37                    57
        sec                                     ; 8C15 38                       8
        brk                                     ; 8C16 00                       .
        brk                                     ; 8C17 00                       .
        brk                                     ; 8C18 00                       .
        brk                                     ; 8C19 00                       .
        brk                                     ; 8C1A 00                       .
        brk                                     ; 8C1B 00                       .
        brk                                     ; 8C1C 00                       .
        brk                                     ; 8C1D 00                       .
        brk                                     ; 8C1E 00                       .
        brk                                     ; 8C1F 00                       .
        jsr     L0000                           ; 8C20 20 00 00                  ..
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
        .byte   $80                             ; 8C40 80                       .
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
        ora     (L0000,x)                       ; 8CA1 01 00                    ..
        brk                                     ; 8CA3 00                       .
        brk                                     ; 8CA4 00                       .
        brk                                     ; 8CA5 00                       .
        bpl     L8CA8                           ; 8CA6 10 00                    ..
L8CA8:  brk                                     ; 8CA8 00                       .
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
L8CC5:  brk                                     ; 8CC5 00                       .
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
        .byte   $83                             ; 8D01 83                       .
        sty     $83                             ; 8D02 84 83                    ..
        .byte   $83                             ; 8D04 83                       .
        stx     $3D                             ; 8D05 86 3D                    .=
        and     L82D2,x                         ; 8D07 3D D2 82                 =..
        ldy     $90                             ; 8D0A A4 90                    ..
        sta     ($A6),y                         ; 8D0C 91 A6                    ..
        .byte   $97                             ; 8D0E 97                       .
L8D0F:  .byte   $1C                             ; 8D0F 1C                       .
        txs                                     ; 8D10 9A                       .
        .byte   $E7                             ; 8D11 E7                       .
        adc     $38                             ; 8D12 65 38                    e8
        adc     ($38,x)                         ; 8D14 61 38                    a8
        and     L8807                           ; 8D16 2D 07 88                 -..
        txa                                     ; 8D19 8A                       .
        txa                                     ; 8D1A 8A                       .
        .byte   $8B                             ; 8D1B 8B                       .
        lda     $0503,y                         ; 8D1C B9 03 05                 ...
        .byte   $07                             ; 8D1F 07                       .
        tya                                     ; 8D20 98                       .
        txs                                     ; 8D21 9A                       .
        .byte   $82                             ; 8D22 82                       .
        .byte   $9B                             ; 8D23 9B                       .
        adc     (L0023,x)                       ; 8D24 61 23                    a#
        asl     a                               ; 8D26 0A                       .
        .byte   $27                             ; 8D27 27                       '
        tya                                     ; 8D28 98                       .
        txs                                     ; 8D29 9A                       .
        .byte   $82                             ; 8D2A 82                       .
        .byte   $9B                             ; 8D2B 9B                       .
        adc     ($43,x)                         ; 8D2C 61 43                    aC
        brk                                     ; 8D2E 00                       .
        .byte   $47                             ; 8D2F 47                       G
        cpy     $A1                             ; 8D30 C4 A1                    ..
        bcc     L8CC5                           ; 8D32 90 91                    ..
        adc     ($63,x)                         ; 8D34 61 63                    ac
        .byte   $64                             ; 8D36 64                       d
        .byte   $77                             ; 8D37 77                       w
        .byte   $82                             ; 8D38 82                       .
        cpy     $90                             ; 8D39 C4 90                    ..
        sta     ($82),y                         ; 8D3B 91 82                    ..
        .byte   $D2                             ; 8D3D D2                       .
        ora     $B6EF,x                         ; 8D3E 1D EF B6                 ...
        .byte   $B7                             ; 8D41 B7                       .
        dec     $D7,x                           ; 8D42 D6 D7                    ..
        dey                                     ; 8D44 88                       .
        txa                                     ; 8D45 8A                       .
        txa                                     ; 8D46 8A                       .
        .byte   $8B                             ; 8D47 8B                       .
        dec     $82                             ; 8D48 C6 82                    ..
        .byte   $D4                             ; 8D4A D4                       .
        .byte   $D4                             ; 8D4B D4                       .
        .byte   $80                             ; 8D4C 80                       .
        .byte   $DF                             ; 8D4D DF                       .
        bvs     L8DA0                           ; 8D4E 70 50                    pP
        stx     $6969                           ; 8D50 8E 69 69                 .ii
        adc     #$EF                            ; 8D53 69 EF                    i.
        .byte   $D4                             ; 8D55 D4                       .
        .byte   $D4                             ; 8D56 D4                       .
        .byte   $CB                             ; 8D57 CB                       .
        .byte   $9E                             ; 8D58 9E                       .
        clv                                     ; 8D59 B8                       .
        clv                                     ; 8D5A B8                       .
        sta     $49D4                           ; 8D5B 8D D4 49                 ..I
        .byte   $CB                             ; 8D5E CB                       .
        .byte   $CB                             ; 8D5F CB                       .
        .byte   $A3                             ; 8D60 A3                       .
        tsx                                     ; 8D61 BA                       .
        cpx     $A3                             ; 8D62 E4 A3                    ..
        ldy     $BABA,x                         ; 8D64 BC BA BA                 ...
        .byte   $82                             ; 8D67 82                       .
        .byte   $FC                             ; 8D68 FC                       .
        .byte   $FC                             ; 8D69 FC                       .
        sbc     $A3C3,y                         ; 8D6A F9 C3 A3                 ...
        eor     L0000                           ; 8D6D 45 00                    E.
        stx     $0F8F                           ; 8D6F 8E 8F 0F                 ...
        ora     L820F                           ; 8D72 0D 0F 82                 ...
        brk                                     ; 8D75 00                       .
        .byte   $2B                             ; 8D76 2B                       +
        ora     $2F8F                           ; 8D77 0D 8F 2F                 ../
        ora     L8E2B                           ; 8D7A 0D 2B 8E                 .+.
        .byte   $0B                             ; 8D7D 0B                       .
        ora     L8F0B                           ; 8D7E 0D 0B 8F                 ...
        .byte   $4F                             ; 8D81 4F                       O
        ora     L8E4B                           ; 8D82 0D 4B 8E                 .K.
        .byte   $0B                             ; 8D85 0B                       .
        ora     L8F0B                           ; 8D86 0D 0B 8F                 ...
        .byte   $6F                             ; 8D89 6F                       o
        ora     $366B                           ; 8D8A 0D 6B 36                 .k6
        dex                                     ; 8D8D CA                       .
        ora     ($BA,x)                         ; 8D8E 01 BA                    ..
        .byte   $8F                             ; 8D90 8F                       .
        .byte   $0F                             ; 8D91 0F                       .
        ora     $0E0F                           ; 8D92 0D 0F 0E                 ...
        bit     $0F8F                           ; 8D95 2C 8F 0F                 ,..
        .byte   $8F                             ; 8D98 8F                       .
        .byte   $2B                             ; 8D99 2B                       +
        ora     $2E2F                           ; 8D9A 0D 2F 2E                 ./.
        asl     $094F                           ; 8D9D 0E 4F 09                 .O.
L8DA0:  .byte   $8F                             ; 8DA0 8F                       .
        .byte   $4B                             ; 8DA1 4B                       K
        ora     $4E4F                           ; 8DA2 0D 4F 4E                 .ON
        .byte   $8F                             ; 8DA5 8F                       .
        .byte   $9E                             ; 8DA6 9E                       .
        and     #$8F                            ; 8DA7 29 8F                    ).
        .byte   $6B                             ; 8DA9 6B                       k
        ora     $6E6F                           ; 8DAA 0D 6F 6E                 .on
        inc     $C282                           ; 8DAD EE 82 C2                 ...
        .byte   $63                             ; 8DB0 63                       c
        .byte   $64                             ; 8DB1 64                       d
        .byte   $64                             ; 8DB2 64                       d
        .byte   $64                             ; 8DB3 64                       d
        .byte   $64                             ; 8DB4 64                       d
        .byte   $64                             ; 8DB5 64                       d
        .byte   $83                             ; 8DB6 83                       .
        ldx     #$E0                            ; 8DB7 A2 E0                    ..
        brk                                     ; 8DB9 00                       .
        eor     ($34,x)                         ; 8DBA 41 34                    A4
        eor     ($D8,x)                         ; 8DBC 41 D8                    A.
        .byte   $C3                             ; 8DBE C3                       .
        brk                                     ; 8DBF 00                       .
        cpy     #$00                            ; 8DC0 C0 00                    ..
        .byte   $F4                             ; 8DC2 F4                       .
        sbc     $F8,x                           ; 8DC3 F5 F8                    ..
        .byte   $82                             ; 8DC5 82                       .
        asl     $084A                           ; 8DC6 0E 4A 08                 .J.
        plp                                     ; 8DC9 28                       (
        ldx     $5D5C                           ; 8DCA AE 5C 5D                 .\]
        .byte   $0F                             ; 8DCD 0F                       .
        rol     a                               ; 8DCE 2A                       *
        ror     a                               ; 8DCF 6A                       j
        .byte   $A3                             ; 8DD0 A3                       .
        .byte   $82                             ; 8DD1 82                       .
        .byte   $82                             ; 8DD2 82                       .
        jmp     (L8F6C)                         ; 8DD3 6C 6C 8F                 ll.

; ----------------------------------------------------------------------------
        .byte   $0F                             ; 8DD6 0F                       .
        ora     L8387                           ; 8DD7 0D 87 83                 ...
        sbc     $A382,y                         ; 8DDA F9 82 A3                 ...
        .byte   $82                             ; 8DDD 82                       .
        .byte   $83                             ; 8DDE 83                       .
        .byte   $82                             ; 8DDF 82                       .
        inc     $BA36                           ; 8DE0 EE 36 BA                 .6.
        ldy     $DABC,x                         ; 8DE3 BC BC DA                 ...
        sta     $83                             ; 8DE6 85 83                    ..
        .byte   $87                             ; 8DE8 87                       .
        cmp     $B8BA                           ; 8DE9 CD BA B8                 ...
        tsx                                     ; 8DEC BA                       .
        .byte   $E2                             ; 8DED E2                       .
        .byte   $A3                             ; 8DEE A3                       .
        .byte   $82                             ; 8DEF 82                       .
        .byte   $82                             ; 8DF0 82                       .
        cpx     L8385                           ; 8DF1 EC 85 83                 ...
        .byte   $83                             ; 8DF4 83                       .
        sta     $85                             ; 8DF5 85 85                    ..
        .byte   $83                             ; 8DF7 83                       .
        sta     $83                             ; 8DF8 85 83                    ..
        .byte   $83                             ; 8DFA 83                       .
        .byte   $8F                             ; 8DFB 8F                       .
        .byte   $93                             ; 8DFC 93                       .
        clv                                     ; 8DFD B8                       .
        .byte   $A3                             ; 8DFE A3                       .
        .byte   $82                             ; 8DFF 82                       .
        brk                                     ; 8E00 00                       .
        .byte   $83                             ; 8E01 83                       .
        sta     $83                             ; 8E02 85 83                    ..
        .byte   $83                             ; 8E04 83                       .
        .byte   $87                             ; 8E05 87                       .
        and     $D33D,x                         ; 8E06 3D 3D D3                 ==.
        sty     $A5,x                           ; 8E09 94 A5                    ..
        sta     ($A0),y                         ; 8E0B 91 A0                    ..
        .byte   $A7                             ; 8E0D A7                       .
        .byte   $82                             ; 8E0E 82                       .
        ora     L9AE6,x                         ; 8E0F 1D E6 9A                 ...
        and     $0239,y                         ; 8E12 39 39 02                 99.
        and     $682D,y                         ; 8E15 39 2D 68                 9-h
        .byte   $89                             ; 8E18 89                       .
        txa                                     ; 8E19 8A                       .
        txa                                     ; 8E1A 8A                       .
        sty     $0402                           ; 8E1B 8C 02 04                 ...
        asl     $CF                             ; 8E1E 06 CF                    ..
        sta     L9A82,y                         ; 8E20 99 82 9A                 ...
        .byte   $9C                             ; 8E23 9C                       .
        .byte   $22                             ; 8E24 22                       "
        brk                                     ; 8E25 00                       .
        .byte   $0B                             ; 8E26 0B                       .
        pla                                     ; 8E27 68                       h
        sta     L9A82,y                         ; 8E28 99 82 9A                 ...
L8E2B:  .byte   $9C                             ; 8E2B 9C                       .
        .byte   $42                             ; 8E2C 42                       B
        brk                                     ; 8E2D 00                       .
        lsr     $68                             ; 8E2E 46 68                    Fh
        ldy     $B5,x                           ; 8E30 B4 B5                    ..
        sta     ($A0),y                         ; 8E32 91 A0                    ..
        .byte   $72                             ; 8E34 72                       r
        .byte   $64                             ; 8E35 64                       d
        ror     $68                             ; 8E36 66 68                    fh
        .byte   $82                             ; 8E38 82                       .
        cmp     $91                             ; 8E39 C5 91                    ..
        ldy     #$82                            ; 8E3B A0 82                    ..
        .byte   $D3                             ; 8E3D D3                       .
        .byte   $82                             ; 8E3E 82                       .
        .byte   $D4                             ; 8E3F D4                       .
        lda     ($C7,x)                         ; 8E40 A1 C7                    ..
        dec     $D7,x                           ; 8E42 D6 D7                    ..
        .byte   $89                             ; 8E44 89                       .
        txa                                     ; 8E45 8A                       .
        txa                                     ; 8E46 8A                       .
        sty     L82C7                           ; 8E47 8C C7 82                 ...
        .byte   $D4                             ; 8E4A D4                       .
L8E4B:  .byte   $D4                             ; 8E4B D4                       .
        .byte   $80                             ; 8E4C 80                       .
        dec     $70,x                           ; 8E4D D6 70                    .p
        bvc     L8EAA                           ; 8E4F 50 59                    PY
        adc     #$49                            ; 8E51 69 49                    iI
        adc     #$D4                            ; 8E53 69 D4                    i.
        .byte   $D4                             ; 8E55 D4                       .
        .byte   $D4                             ; 8E56 D4                       .
L8E57:  .byte   $7A                             ; 8E57 7A                       z
        dex                                     ; 8E58 CA                       .
        clv                                     ; 8E59 B8                       .
        .byte   $CB                             ; 8E5A CB                       .
        dex                                     ; 8E5B CA                       .
        .byte   $D4                             ; 8E5C D4                       .
        adc     L9F7B,y                         ; 8E5D 79 7B 9F                 y{.
        dex                                     ; 8E60 CA                       .
        tsx                                     ; 8E61 BA                       .
        sbc     $CA                             ; 8E62 E5 CA                    ..
        ldy     $BABA,x                         ; 8E64 BC BA BA                 ...
        .byte   $82                             ; 8E67 82                       .
        .byte   $FC                             ; 8E68 FC                       .
        .byte   $FC                             ; 8E69 FC                       .
        .byte   $FA                             ; 8E6A FA                       .
        .byte   $C3                             ; 8E6B C3                       .
        .byte   $44                             ; 8E6C 44                       D
        ldx     #$00                            ; 8E6D A2 00                    ..
        adc     #$0E                            ; 8E6F 69 0E                    i.
        .byte   $0C                             ; 8E71 0C                       .
        asl     L827D                           ; 8E72 0E 7D 82                 .}.
        brk                                     ; 8E75 00                       .
        adc     $2E69,y                         ; 8E76 79 69 2E                 yi.
        .byte   $0C                             ; 8E79 0C                       .
        rol     a                               ; 8E7A 2A                       *
        adc     $0C0A,x                         ; 8E7B 7D 0A 0C                 }..
        asl     a                               ; 8E7E 0A                       .
        adc     $0C4E,y                         ; 8E7F 79 4E 0C                 yN.
        lsr     a                               ; 8E82 4A                       J
        adc     $0C0A,x                         ; 8E83 7D 0A 0C                 }..
        asl     a                               ; 8E86 0A                       .
        adc     $0C6E,y                         ; 8E87 79 6E 0C                 yn.
        ror     a                               ; 8E8A 6A                       j
        adc     $CBEE,x                         ; 8E8B 7D EE CB                 }..
L8E8E:  jsr     L0EBA                           ; 8E8E 20 BA 0E                  ..
        .byte   $0C                             ; 8E91 0C                       .
        asl     $0F7D                           ; 8E92 0E 7D 0F                 .}.
        bit     $0C0E                           ; 8E95 2C 0E 0C                 ,..
        rol     a                               ; 8E98 2A                       *
        .byte   $0C                             ; 8E99 0C                       .
        rol     $2F7D                           ; 8E9A 2E 7D 2F                 .}/
        .byte   $0B                             ; 8E9D 0B                       .
L8E9E:  adc     $4A09,y                         ; 8E9E 79 09 4A                 y.J
        .byte   $0C                             ; 8EA1 0C                       .
        lsr     $4F7D                           ; 8EA2 4E 7D 4F                 N}O
        .byte   $C3                             ; 8EA5 C3                       .
        .byte   $82                             ; 8EA6 82                       .
        and     #$6A                            ; 8EA7 29 6A                    )j
        .byte   $0C                             ; 8EA9 0C                       .
L8EAA:  ror     $6F7D                           ; 8EAA 6E 7D 6F                 n}o
        rol     $ED,x                           ; 8EAD 36 ED                    6.
        ldx     #$64                            ; 8EAF A2 64                    .d
        .byte   $64                             ; 8EB1 64                       d
        .byte   $64                             ; 8EB2 64                       d
        .byte   $64                             ; 8EB3 64                       d
        .byte   $64                             ; 8EB4 64                       d
        ror     L0010                           ; 8EB5 66 10                    f.
        sbc     a:$E1                           ; 8EB7 ED E1 00                 ...
        and     ($35),y                         ; 8EBA 31 35                    15
        brk                                     ; 8EBC 00                       .
        cmp     $0C,y                           ; 8EBD D9 0C 00                 ...
        cmp     ($F3,x)                         ; 8EC0 C1 F3                    ..
        sbc     $F7,x                           ; 8EC2 F5 F7                    ..
        brk                                     ; 8EC4 00                       .
        bpl     L8ED6                           ; 8EC5 10 0F                    ..
        .byte   $4B                             ; 8EC7 4B                       K
        php                                     ; 8EC8 08                       .
        plp                                     ; 8EC9 28                       (
        .byte   $AF                             ; 8ECA AF                       .
        eor     $7D4C,x                         ; 8ECB 5D 4C 7D                 ]L}
        .byte   $2B                             ; 8ECE 2B                       +
        .byte   $6B                             ; 8ECF 6B                       k
        .byte   $82                             ; 8ED0 82                       .
        ldx     #$82                            ; 8ED1 A2 82                    ..
        jmp     (L0E6C)                         ; 8ED3 6C 6C 0E                 ll.

; ----------------------------------------------------------------------------
L8ED6:  .byte   $0C                             ; 8ED6 0C                       .
        asl     $DB83                           ; 8ED7 0E 83 DB                 ...
        .byte   $FA                             ; 8EDA FA                       .
        ldx     #$82                            ; 8EDB A2 82                    ..
        .byte   $EB                             ; 8EDD EB                       .
        .byte   $83                             ; 8EDE 83                       .
        .byte   $82                             ; 8EDF 82                       .
        rol     $EE,x                           ; 8EE0 36 EE                    6.
        tsx                                     ; 8EE2 BA                       .
        .byte   $BC                             ; 8EE3 BC                       .
        .byte   $DA                             ; 8EE4 DA                       .
L8EE5:  ldy     $8483,x                         ; 8EE5 BC 83 84                 ...
        cpy     $BACE                           ; 8EE8 CC CE BA                 ...
        clv                                     ; 8EEB B8                       .
L8EEC:  .byte   $E2                             ; 8EEC E2                       .
        tsx                                     ; 8EED BA                       .
        .byte   $82                             ; 8EEE 82                       .
        ldx     #$EC                            ; 8EEF A2 EC                    ..
        sbc     L8383                           ; 8EF1 ED 83 83                 ...
        sty     $84                             ; 8EF4 84 84                    ..
        .byte   $83                             ; 8EF6 83                       .
        .byte   $DB                             ; 8EF7 DB                       .
        .byte   $83                             ; 8EF8 83                       .
        .byte   $83                             ; 8EF9 83                       .
        sty     $82                             ; 8EFA 84 82                    ..
        clv                                     ; 8EFC B8                       .
        .byte   $AB                             ; 8EFD AB                       .
        .byte   $82                             ; 8EFE 82                       .
        .byte   $EB                             ; 8EFF EB                       .
        brk                                     ; 8F00 00                       .
        .byte   $82                             ; 8F01 82                       .
        sty     $90,x                           ; 8F02 94 90                    ..
        sta     ($96),y                         ; 8F04 91 96                    ..
        and     $D23D,x                         ; 8F06 3D 3D D2                 ==.
        sty     $C3,x                           ; 8F09 94 C3                    ..
L8F0B:  bcc     L8E9E                           ; 8F0B 90 91                    ..
        ldx     $A7                             ; 8F0D A6 A7                    ..
        ldy     $459A                           ; 8F0F AC 9A 45                 ..E
        brk                                     ; 8F12 00                       .
        eor     $3961                           ; 8F13 4D 61 39                 Ma9
        and     L9807                           ; 8F16 2D 07 98                 -..
        txs                                     ; 8F19 9A                       .
        .byte   $82                             ; 8F1A 82                       .
        .byte   $9B                             ; 8F1B 9B                       .
        lda     $13,y                           ; 8F1C B9 13 00                 ...
        .byte   $17                             ; 8F1F 17                       .
        tya                                     ; 8F20 98                       .
        txs                                     ; 8F21 9A                       .
        .byte   $82                             ; 8F22 82                       .
        .byte   $9B                             ; 8F23 9B                       .
        adc     ($33,x)                         ; 8F24 61 33                    a3
        asl     L8837,x                         ; 8F26 1E 37 88                 .7.
        txa                                     ; 8F29 8A                       .
        txa                                     ; 8F2A 8A                       .
        .byte   $8B                             ; 8F2B 8B                       .
        eor     ($53),y                         ; 8F2C 51 53                    QS
        eor     $57,x                           ; 8F2E 55 57                    UW
        .byte   $82                             ; 8F30 82                       .
        ldy     $90,x                           ; 8F31 B4 90                    ..
        sta     ($71),y                         ; 8F33 91 71                    .q
        .byte   $73                             ; 8F35 73                       s
        .byte   $74                             ; 8F36 74                       t
        .byte   $77                             ; 8F37 77                       w
        tax                                     ; 8F38 AA                       .
        bcs     L8EE5                           ; 8F39 B0 AA                    ..
        tax                                     ; 8F3B AA                       .
L8F3C:  .byte   $82                             ; 8F3C 82                       .
        .byte   $D2                             ; 8F3D D2                       .
        lda     $B6FD                           ; 8F3E AD FD B6                 ...
        .byte   $C7                             ; 8F41 C7                       .
        .byte   $D4                             ; 8F42 D4                       .
        .byte   $D4                             ; 8F43 D4                       .
        dey                                     ; 8F44 88                       .
        txa                                     ; 8F45 8A                       .
        txa                                     ; 8F46 8A                       .
        .byte   $8B                             ; 8F47 8B                       .
        .byte   $B2                             ; 8F48 B2                       .
        tax                                     ; 8F49 AA                       .
        cmp     $D4,x                           ; 8F4A D5 D4                    ..
        .byte   $80                             ; 8F4C 80                       .
        .byte   $EF                             ; 8F4D EF                       .
        brk                                     ; 8F4E 00                       .
        rti                                     ; 8F4F 40                       @

; ----------------------------------------------------------------------------
        .byte   $9E                             ; 8F50 9E                       .
        ldx     $C3BE,y                         ; 8F51 BE BE C3                 ...
        .byte   $EF                             ; 8F54 EF                       .
        sbc     $BFFF,x                         ; 8F55 FD FF BF                 ...
        .byte   $9E                             ; 8F58 9E                       .
        ldx     $A3BE,y                         ; 8F59 BE BE A3                 ...
        .byte   $D4                             ; 8F5C D4                       .
        .byte   $BF                             ; 8F5D BF                       .
        .byte   $BF                             ; 8F5E BF                       .
        .byte   $BF                             ; 8F5F BF                       .
        .byte   $A3                             ; 8F60 A3                       .
        tsx                                     ; 8F61 BA                       .
        cmp     ($9D),y                         ; 8F62 D1 9D                    ..
        tsx                                     ; 8F64 BA                       .
        sbc     $1FF0,y                         ; 8F65 F9 F0 1F                 ...
        .byte   $FC                             ; 8F68 FC                       .
        .byte   $FC                             ; 8F69 FC                       .
        tsx                                     ; 8F6A BA                       .
        .byte   $C3                             ; 8F6B C3                       .
L8F6C:  .byte   $A3                             ; 8F6C A3                       .
        .byte   $E7                             ; 8F6D E7                       .
        rts                                     ; 8F6E 60                       `

; ----------------------------------------------------------------------------
        .byte   $8F                             ; 8F6F 8F                       .
        .byte   $8F                             ; 8F70 8F                       .
        .byte   $1F                             ; 8F71 1F                       .
        .byte   $0C                             ; 8F72 0C                       .
        .byte   $1B                             ; 8F73 1B                       .
        .byte   $82                             ; 8F74 82                       .
        cmp     ($3B),y                         ; 8F75 D1 3B                    .;
        .byte   $0C                             ; 8F77 0C                       .
        .byte   $8F                             ; 8F78 8F                       .
        .byte   $3F                             ; 8F79 3F                       ?
        .byte   $0C                             ; 8F7A 0C                       .
        .byte   $3B                             ; 8F7B 3B                       ;
        .byte   $8F                             ; 8F7C 8F                       .
        .byte   $1F                             ; 8F7D 1F                       .
        .byte   $0C                             ; 8F7E 0C                       .
        .byte   $1B                             ; 8F7F 1B                       .
        .byte   $8F                             ; 8F80 8F                       .
        .byte   $5F                             ; 8F81 5F                       _
        .byte   $0C                             ; 8F82 0C                       .
        .byte   $5B                             ; 8F83 5B                       [
        .byte   $8F                             ; 8F84 8F                       .
        .byte   $1B                             ; 8F85 1B                       .
        .byte   $0C                             ; 8F86 0C                       .
        .byte   $1F                             ; 8F87 1F                       .
        .byte   $8F                             ; 8F88 8F                       .
        .byte   $7F                             ; 8F89 7F                       .
        .byte   $0C                             ; 8F8A 0C                       .
        .byte   $7F                             ; 8F8B 7F                       .
        rol     $A3                             ; 8F8C 26 A3                    &.
        ora     ($F0),y                         ; 8F8E 11 F0                    ..
        .byte   $8F                             ; 8F90 8F                       .
        .byte   $1B                             ; 8F91 1B                       .
        .byte   $0C                             ; 8F92 0C                       .
        .byte   $1F                             ; 8F93 1F                       .
        asl     L8F3C,x                         ; 8F94 1E 3C 8F                 .<.
        .byte   $1F                             ; 8F97 1F                       .
        .byte   $8F                             ; 8F98 8F                       .
        .byte   $3B                             ; 8F99 3B                       ;
        .byte   $0C                             ; 8F9A 0C                       .
        .byte   $3F                             ; 8F9B 3F                       ?
        rol     $5F1E,x                         ; 8F9C 3E 1E 5F                 >._
        ora     $5B8F,y                         ; 8F9F 19 8F 5B                 ..[
        .byte   $0C                             ; 8FA2 0C                       .
        .byte   $5F                             ; 8FA3 5F                       _
        lsr     L9E67,x                         ; 8FA4 5E 67 9E                 ^g.
        pha                                     ; 8FA7 48                       H
        .byte   $8F                             ; 8FA8 8F                       .
        .byte   $7F                             ; 8FA9 7F                       .
        .byte   $0C                             ; 8FAA 0C                       .
        .byte   $7F                             ; 8FAB 7F                       .
        ror     $AAFE,x                         ; 8FAC 7E FE AA                 ~..
        .byte   $82                             ; 8FAF 82                       .
        bne     L8FFF                           ; 8FB0 D0 4D                    .M
        and     $3924,y                         ; 8FB2 39 24 39                 9$9
        brk                                     ; 8FB5 00                       .
        .byte   $82                             ; 8FB6 82                       .
        ldx     #$00                            ; 8FB7 A2 00                    ..
        .byte   $F2                             ; 8FB9 F2                       .
        brk                                     ; 8FBA 00                       .
        brk                                     ; 8FBB 00                       .
        inx                                     ; 8FBC E8                       .
        nop                                     ; 8FBD EA                       .
        .byte   $FA                             ; 8FBE FA                       .
        .byte   $64                             ; 8FBF 64                       d
        adc     L0000,x                         ; 8FC0 75 00                    u.
        brk                                     ; 8FC2 00                       .
        brk                                     ; 8FC3 00                       .
        brk                                     ; 8FC4 00                       .
        .byte   $82                             ; 8FC5 82                       .
        .byte   $1A                             ; 8FC6 1A                       .
        .byte   $5A                             ; 8FC7 5A                       Z
        clc                                     ; 8FC8 18                       .
        ora     #$AE                            ; 8FC9 09 AE                    ..
        adc     $1F6D                           ; 8FCB 6D 6D 1F                 mm.
        .byte   $3A                             ; 8FCE 3A                       :
        ror     $AAB1,x                         ; 8FCF 7E B1 AA                 ~..
        tax                                     ; 8FD2 AA                       .
        .byte   $5C                             ; 8FD3 5C                       \
        eor     $1B8F,x                         ; 8FD4 5D 8F 1B                 ]..
        .byte   $0C                             ; 8FD7 0C                       .
        .byte   $B3                             ; 8FD8 B3                       .
        tax                                     ; 8FD9 AA                       .
        tsx                                     ; 8FDA BA                       .
        .byte   $82                             ; 8FDB 82                       .
        .byte   $A3                             ; 8FDC A3                       .
        .byte   $82                             ; 8FDD 82                       .
        .byte   $82                             ; 8FDE 82                       .
        ldx     $39EE,y                         ; 8FDF BE EE 39                 ..9
        tsx                                     ; 8FE2 BA                       .
        tsx                                     ; 8FE3 BA                       .
        tsx                                     ; 8FE4 BA                       .
        .byte   $E2                             ; 8FE5 E2                       .
        .byte   $A3                             ; 8FE6 A3                       .
        .byte   $82                             ; 8FE7 82                       .
        .byte   $82                             ; 8FE8 82                       .
        .byte   $DD                             ; 8FE9 DD                       .
L8FEA:  sbc     $BA82,y                         ; 8FEA F9 82 BA                 ...
        .byte   $E2                             ; 8FED E2                       .
        lda     #$BE                            ; 8FEE A9 BE                    ..
        sbc     $A9EC                           ; 8FF0 ED EC A9                 ...
        ldx     $A3BE,y                         ; 8FF3 BE BE A3                 ...
        .byte   $A3                             ; 8FF6 A3                       .
        .byte   $82                             ; 8FF7 82                       .
        lda     ($AA),y                         ; 8FF8 B1 AA                    ..
        tax                                     ; 8FFA AA                       .
        .byte   $8F                             ; 8FFB 8F                       .
        .byte   $A3                             ; 8FFC A3                       .
        .byte   $82                             ; 8FFD 82                       .
        .byte   $B1                             ; 8FFE B1                       .
L8FFF:  tax                                     ; 8FFF AA                       .
        brk                                     ; 9000 00                       .
        .byte   $82                             ; 9001 82                       .
        sta     $91,x                           ; 9002 95 91                    ..
        ldy     #$97                            ; 9004 A0 97                    ..
        and     $D300,x                         ; 9006 3D 00 D3                 =..
        ldy     $A5                             ; 9009 A4 A5                    ..
        sta     ($A0),y                         ; 900B 91 A0                    ..
        .byte   $C3                             ; 900D C3                       .
        .byte   $97                             ; 900E 97                       .
        lda     L9A44                           ; 900F AD 44 9A                 .D.
        adc     $4D                             ; 9012 65 4D                    eM
        .byte   $02                             ; 9014 02                       .
        sec                                     ; 9015 38                       8
        and     L9968                           ; 9016 2D 68 99                 -h.
        .byte   $82                             ; 9019 82                       .
        txs                                     ; 901A 9A                       .
        .byte   $9C                             ; 901B 9C                       .
        .byte   $12                             ; 901C 12                       .
        brk                                     ; 901D 00                       .
L901E:  asl     $CF,x                           ; 901E 16 CF                    ..
        sta     L9A82,y                         ; 9020 99 82 9A                 ...
        .byte   $9C                             ; 9023 9C                       .
        .byte   $32                             ; 9024 32                       2
        brk                                     ; 9025 00                       .
        .byte   $1F                             ; 9026 1F                       .
        pla                                     ; 9027 68                       h
        .byte   $89                             ; 9028 89                       .
        txa                                     ; 9029 8A                       .
        txa                                     ; 902A 8A                       .
        sty     $5452                           ; 902B 8C 52 54                 .RT
        lsr     $58,x                           ; 902E 56 58                    VX
        cpy     $B5                             ; 9030 C4 B5                    ..
        sta     ($A0),y                         ; 9032 91 A0                    ..
        .byte   $72                             ; 9034 72                       r
        .byte   $74                             ; 9035 74                       t
        ror     $78,x                           ; 9036 76 78                    vx
        tax                                     ; 9038 AA                       .
        lda     ($AA),y                         ; 9039 B1 AA                    ..
        tax                                     ; 903B AA                       .
        .byte   $82                             ; 903C 82                       .
        .byte   $D3                             ; 903D D3                       .
        lda     $B7FD                           ; 903E AD FD B7                 ...
        .byte   $82                             ; 9041 82                       .
        .byte   $D4                             ; 9042 D4                       .
        .byte   $D4                             ; 9043 D4                       .
        .byte   $89                             ; 9044 89                       .
        txa                                     ; 9045 8A                       .
        txa                                     ; 9046 8A                       .
        sty     $AAB3                           ; 9047 8C B3 AA                 ...
        cmp     $D4,x                           ; 904A D5 D4                    ..
        .byte   $80                             ; 904C 80                       .
        .byte   $D4                             ; 904D D4                       .
        brk                                     ; 904E 00                       .
        rti                                     ; 904F 40                       @

; ----------------------------------------------------------------------------
        lda     $BFBE,x                         ; 9050 BD BE BF                 ...
        .byte   $C3                             ; 9053 C3                       .
        .byte   $D4                             ; 9054 D4                       .
        sbc     L9FFF,x                         ; 9055 FD FF 9F                 ...
        lda     $BFBE,x                         ; 9058 BD BE BF                 ...
        lda     $7BD4,x                         ; 905B BD D4 7B                 ..{
        .byte   $7B                             ; 905E 7B                       {
        .byte   $7C                             ; 905F 7C                       |
        lda     $F6BA,x                         ; 9060 BD BA F6                 ...
        lda     $FABA,x                         ; 9063 BD BA FA                 ...
        beq     L8FEA                           ; 9066 F0 82                    ..
        .byte   $FC                             ; 9068 FC                       .
        brk                                     ; 9069 00                       .
        tsx                                     ; 906A BA                       .
        .byte   $C3                             ; 906B C3                       .
        inc     $A2                             ; 906C E6 A2                    ..
        rts                                     ; 906E 60                       `

; ----------------------------------------------------------------------------
        .byte   $82                             ; 906F 82                       .
        asl     $1A0D,x                         ; 9070 1E 0D 1A                 ...
        adc     $F682,x                         ; 9073 7D 82 F6                 }..
        adc     $3E82,x                         ; 9076 7D 82 3E                 }.>
        ora     $7D3A                           ; 9079 0D 3A 7D                 .:}
        .byte   $1E                             ; 907C 1E                       .
L907D:  .byte   $0D                             ; 907D 0D                       .
L907E:  .byte   $1A                             ; 907E 1A                       .
        adc     $0D5E,x                         ; 907F 7D 5E 0D                 }^.
        .byte   $5A                             ; 9082 5A                       Z
        adc     $0D1A,x                         ; 9083 7D 1A 0D                 }..
        asl     $7E7D,x                         ; 9086 1E 7D 7E                 .}~
        ora     $7D7E                           ; 9089 0D 7E 7D                 .~}
        inc     $30A2,x                         ; 908C FE A2 30                 ..0
        beq     L90AB                           ; 908F F0 1A                    ..
        ora     $7D1E                           ; 9091 0D 1E 7D                 ..}
        .byte   $1F                             ; 9094 1F                       .
        .byte   $3C                             ; 9095 3C                       <
        asl     $3A0D,x                         ; 9096 1E 0D 3A                 ..:
        ora     $7D3E                           ; 9099 0D 3E 7D                 .>}
        .byte   $3F                             ; 909C 3F                       ?
        .byte   $1F                             ; 909D 1F                       .
        adc     $5A19,x                         ; 909E 7D 19 5A                 }.Z
L90A1:  ora     $7D5E                           ; 90A1 0D 5E 7D                 .^}
        .byte   $5F                             ; 90A4 5F                       _
        .byte   $FA                             ; 90A5 FA                       .
        .byte   $82                             ; 90A6 82                       .
        pha                                     ; 90A7 48                       H
        ror     $7E0D,x                         ; 90A8 7E 0D 7E                 ~.~
L90AB:  adc     $267F,x                         ; 90AB 7D 7F 26                 }.&
        .byte   $62                             ; 90AE 62                       b
        ldx     #$00                            ; 90AF A2 00                    ..
        and     $2521                           ; 90B1 2D 21 25                 -!%
        and     $10C9                           ; 90B4 2D C9 10                 -..
        sbc     $E3F1                           ; 90B7 ED F1 E3                 ...
        eor     (L0000,x)                       ; 90BA 41 00                    A.
        sbc     #$00                            ; 90BC E9 00                    ..
        .byte   $FA                             ; 90BE FA                       .
        .byte   $64                             ; 90BF 64                       d
        iny                                     ; 90C0 C8                       .
        brk                                     ; 90C1 00                       .
        brk                                     ; 90C2 00                       .
        brk                                     ; 90C3 00                       .
        brk                                     ; 90C4 00                       .
        bpl     L90E2                           ; 90C5 10 1B                    ..
        .byte   $5B                             ; 90C7 5B                       [
        clc                                     ; 90C8 18                       .
        ora     #$AF                            ; 90C9 09 AF                    ..
        adc     $7D6D                           ; 90CB 6D 6D 7D                 mm}
        .byte   $3B                             ; 90CE 3B                       ;
        .byte   $7F                             ; 90CF 7F                       .
        tax                                     ; 90D0 AA                       .
        bcs     L907D                           ; 90D1 B0 AA                    ..
        eor     $1A4C,x                         ; 90D3 5D 4C 1A                 ]L.
        ora     $AA1E                           ; 90D6 0D 1E AA                 ...
        .byte   $FB                             ; 90D9 FB                       .
        tsx                                     ; 90DA BA                       .
        ldx     #$82                            ; 90DB A2 82                    ..
        .byte   $EB                             ; 90DD EB                       .
        .byte   $82                             ; 90DE 82                       .
        ldx     $EE38,y                         ; 90DF BE 38 EE                 .8.
L90E2:  tsx                                     ; 90E2 BA                       .
        tsx                                     ; 90E3 BA                       .
        .byte   $E2                             ; 90E4 E2                       .
        tsx                                     ; 90E5 BA                       .
        .byte   $82                             ; 90E6 82                       .
        ldx     #$DC                            ; 90E7 A2 DC                    ..
        dec     L82FA,x                         ; 90E9 DE FA 82                 ...
        .byte   $E2                             ; 90EC E2                       .
        tsx                                     ; 90ED BA                       .
        ldx     $ECA8,y                         ; 90EE BE A8 EC                 ...
        sbc     $BEBE                           ; 90F1 ED BE BE                 ...
        tay                                     ; 90F4 A8                       .
        ldx     #$82                            ; 90F5 A2 82                    ..
        .byte   $EB                             ; 90F7 EB                       .
        tax                                     ; 90F8 AA                       .
        tax                                     ; 90F9 AA                       .
        bcs     L907E                           ; 90FA B0 82                    ..
        .byte   $82                             ; 90FC 82                       .
        ldx     #$AA                            ; 90FD A2 AA                    ..
        .byte   $FB                             ; 90FF FB                       .
        brk                                     ; 9100 00                       .
        .byte   $12                             ; 9101 12                       .
        .byte   $12                             ; 9102 12                       .
        .byte   $12                             ; 9103 12                       .
        .byte   $12                             ; 9104 12                       .
        .byte   $12                             ; 9105 12                       .
        brk                                     ; 9106 00                       .
        brk                                     ; 9107 00                       .
        rti                                     ; 9108 40                       @

; ----------------------------------------------------------------------------
        .byte   $12                             ; 9109 12                       .
        .byte   $12                             ; 910A 12                       .
        .byte   $12                             ; 910B 12                       .
        .byte   $12                             ; 910C 12                       .
        .byte   $12                             ; 910D 12                       .
        .byte   $12                             ; 910E 12                       .
        ora     ($12,x)                         ; 910F 01 12                    ..
        .byte   $12                             ; 9111 12                       .
        brk                                     ; 9112 00                       .
        brk                                     ; 9113 00                       .
        bpl     L9116                           ; 9114 10 00                    ..
L9116:  brk                                     ; 9116 00                       .
        bpl     L912B                           ; 9117 10 12                    ..
        .byte   $12                             ; 9119 12                       .
        .byte   $12                             ; 911A 12                       .
        .byte   $12                             ; 911B 12                       .
        .byte   $12                             ; 911C 12                       .
        .byte   $12                             ; 911D 12                       .
        .byte   $12                             ; 911E 12                       .
        .byte   $12                             ; 911F 12                       .
        .byte   $12                             ; 9120 12                       .
        .byte   $12                             ; 9121 12                       .
        .byte   $12                             ; 9122 12                       .
        .byte   $12                             ; 9123 12                       .
        bpl     L9136                           ; 9124 10 10                    ..
        .byte   $03                             ; 9126 03                       .
        bpl     L913B                           ; 9127 10 12                    ..
        .byte   $12                             ; 9129 12                       .
        .byte   $12                             ; 912A 12                       .
L912B:  .byte   $12                             ; 912B 12                       .
        bpl     L913E                           ; 912C 10 10                    ..
        bpl     L9140                           ; 912E 10 10                    ..
        .byte   $12                             ; 9130 12                       .
        .byte   $12                             ; 9131 12                       .
        .byte   $12                             ; 9132 12                       .
        .byte   $12                             ; 9133 12                       .
        bpl     L9146                           ; 9134 10 10                    ..
L9136:  bpl     L9148                           ; 9136 10 10                    ..
        .byte   $12                             ; 9138 12                       .
        .byte   $12                             ; 9139 12                       .
        .byte   $12                             ; 913A 12                       .
L913B:  .byte   $12                             ; 913B 12                       .
        .byte   $12                             ; 913C 12                       .
        .byte   $20                             ; 913D 20                        
L913E:  ora     (L0001,x)                       ; 913E 01 01                    ..
L9140:  .byte   $12                             ; 9140 12                       .
        .byte   $12                             ; 9141 12                       .
        ora     (L0001,x)                       ; 9142 01 01                    ..
        .byte   $12                             ; 9144 12                       .
        .byte   $12                             ; 9145 12                       .
L9146:  .byte   $12                             ; 9146 12                       .
        .byte   $12                             ; 9147 12                       .
L9148:  .byte   $12                             ; 9148 12                       .
        .byte   $12                             ; 9149 12                       .
        ora     (L0001,x)                       ; 914A 01 01                    ..
        ora     (L0001,x)                       ; 914C 01 01                    ..
        ora     (L0001,x)                       ; 914E 01 01                    ..
        ora     (L0001,x)                       ; 9150 01 01                    ..
        ora     ($03,x)                         ; 9152 01 03                    ..
        ora     (L0001,x)                       ; 9154 01 01                    ..
        ora     (L0001,x)                       ; 9156 01 01                    ..
        ora     (L0001,x)                       ; 9158 01 01                    ..
        ora     (L0001,x)                       ; 915A 01 01                    ..
        .byte   $03                             ; 915C 03                       .
        ora     (L0001,x)                       ; 915D 01 01                    ..
        ora     (L0001,x)                       ; 915F 01 01                    ..
        .byte   $03                             ; 9161 03                       .
        .byte   $03                             ; 9162 03                       .
        ora     ($03,x)                         ; 9163 01 03                    ..
        .byte   $03                             ; 9165 03                       .
        .byte   $03                             ; 9166 03                       .
        .byte   $03                             ; 9167 03                       .
        .byte   $03                             ; 9168 03                       .
        .byte   $03                             ; 9169 03                       .
        .byte   $03                             ; 916A 03                       .
        .byte   $03                             ; 916B 03                       .
        .byte   $12                             ; 916C 12                       .
        .byte   $12                             ; 916D 12                       .
        ora     ($03,x)                         ; 916E 01 03                    ..
        .byte   $03                             ; 9170 03                       .
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
        .byte   $03                             ; 9186 03                       .
        .byte   $03                             ; 9187 03                       .
        .byte   $03                             ; 9188 03                       .
        .byte   $03                             ; 9189 03                       .
        .byte   $03                             ; 918A 03                       .
        .byte   $03                             ; 918B 03                       .
        bpl     L91A0                           ; 918C 10 12                    ..
        .byte   $12                             ; 918E 12                       .
        ora     ($03,x)                         ; 918F 01 03                    ..
        .byte   $03                             ; 9191 03                       .
        .byte   $03                             ; 9192 03                       .
        .byte   $03                             ; 9193 03                       .
        .byte   $03                             ; 9194 03                       .
        .byte   $03                             ; 9195 03                       .
        .byte   $03                             ; 9196 03                       .
        .byte   $03                             ; 9197 03                       .
        .byte   $03                             ; 9198 03                       .
        .byte   $03                             ; 9199 03                       .
        .byte   $03                             ; 919A 03                       .
        .byte   $03                             ; 919B 03                       .
        .byte   $03                             ; 919C 03                       .
        .byte   $03                             ; 919D 03                       .
        .byte   $03                             ; 919E 03                       .
        .byte   $12                             ; 919F 12                       .
L91A0:  .byte   $03                             ; 91A0 03                       .
        .byte   $03                             ; 91A1 03                       .
        .byte   $03                             ; 91A2 03                       .
        .byte   $03                             ; 91A3 03                       .
        .byte   $03                             ; 91A4 03                       .
        .byte   $03                             ; 91A5 03                       .
        ora     ($F2,x)                         ; 91A6 01 F2                    ..
        .byte   $03                             ; 91A8 03                       .
        .byte   $03                             ; 91A9 03                       .
        .byte   $03                             ; 91AA 03                       .
        .byte   $03                             ; 91AB 03                       .
        .byte   $03                             ; 91AC 03                       .
        bpl     L91C1                           ; 91AD 10 12                    ..
        .byte   $12                             ; 91AF 12                       .
        .byte   $03                             ; 91B0 03                       .
        .byte   $03                             ; 91B1 03                       .
        .byte   $03                             ; 91B2 03                       .
        .byte   $03                             ; 91B3 03                       .
        .byte   $03                             ; 91B4 03                       .
        .byte   $03                             ; 91B5 03                       .
        .byte   $12                             ; 91B6 12                       .
        .byte   $12                             ; 91B7 12                       .
        .byte   $03                             ; 91B8 03                       .
        .byte   $03                             ; 91B9 03                       .
        .byte   $03                             ; 91BA 03                       .
        brk                                     ; 91BB 00                       .
        .byte   $03                             ; 91BC 03                       .
        .byte   $03                             ; 91BD 03                       .
        .byte   $03                             ; 91BE 03                       .
        .byte   $03                             ; 91BF 03                       .
        .byte   $03                             ; 91C0 03                       .
L91C1:  .byte   $03                             ; 91C1 03                       .
        .byte   $03                             ; 91C2 03                       .
        .byte   $03                             ; 91C3 03                       .
        .byte   $03                             ; 91C4 03                       .
        .byte   $12                             ; 91C5 12                       .
        .byte   $03                             ; 91C6 03                       .
        .byte   $03                             ; 91C7 03                       .
        .byte   $F2                             ; 91C8 F2                       .
        .byte   $12                             ; 91C9 12                       .
        brk                                     ; 91CA 00                       .
        brk                                     ; 91CB 00                       .
        brk                                     ; 91CC 00                       .
        .byte   $03                             ; 91CD 03                       .
        .byte   $03                             ; 91CE 03                       .
        .byte   $03                             ; 91CF 03                       .
        .byte   $12                             ; 91D0 12                       .
        .byte   $12                             ; 91D1 12                       .
        .byte   $12                             ; 91D2 12                       .
        brk                                     ; 91D3 00                       .
        brk                                     ; 91D4 00                       .
        .byte   $03                             ; 91D5 03                       .
        .byte   $03                             ; 91D6 03                       .
        .byte   $03                             ; 91D7 03                       .
        .byte   $12                             ; 91D8 12                       .
        .byte   $12                             ; 91D9 12                       .
        ora     ($12,x)                         ; 91DA 01 12                    ..
        .byte   $12                             ; 91DC 12                       .
        .byte   $12                             ; 91DD 12                       .
        .byte   $12                             ; 91DE 12                       .
        .byte   $12                             ; 91DF 12                       .
        bpl     L91F2                           ; 91E0 10 10                    ..
        ora     (L0001,x)                       ; 91E2 01 01                    ..
        ora     (L0001,x)                       ; 91E4 01 01                    ..
        .byte   $12                             ; 91E6 12                       .
        .byte   $12                             ; 91E7 12                       .
        .byte   $12                             ; 91E8 12                       .
        .byte   $12                             ; 91E9 12                       .
        ora     ($12,x)                         ; 91EA 01 12                    ..
        ora     (L0001,x)                       ; 91EC 01 01                    ..
        .byte   $12                             ; 91EE 12                       .
        .byte   $12                             ; 91EF 12                       .
        .byte   $12                             ; 91F0 12                       .
        .byte   $12                             ; 91F1 12                       .
L91F2:  .byte   $12                             ; 91F2 12                       .
        .byte   $12                             ; 91F3 12                       .
        .byte   $12                             ; 91F4 12                       .
        .byte   $12                             ; 91F5 12                       .
        .byte   $12                             ; 91F6 12                       .
        .byte   $12                             ; 91F7 12                       .
        .byte   $12                             ; 91F8 12                       .
        .byte   $12                             ; 91F9 12                       .
        .byte   $12                             ; 91FA 12                       .
        .byte   $03                             ; 91FB 03                       .
        .byte   $12                             ; 91FC 12                       .
        .byte   $12                             ; 91FD 12                       .
        .byte   $12                             ; 91FE 12                       .
        .byte   $12                             ; 91FF 12                       .
        .byte   $22                             ; 9200 22                       "
        .byte   $23                             ; 9201 23                       #
        .byte   $22                             ; 9202 22                       "
        .byte   $23                             ; 9203 23                       #
        jsr     L2021                           ; 9204 20 21 20                  ! 
        and     ($30,x)                         ; 9207 21 30                    !0
        and     ($38),y                         ; 9209 31 38                    18
        and     $3332,y                         ; 920B 39 32 33                 923
        .byte   $3A                             ; 920E 3A                       :
        .byte   $3B                             ; 920F 3B                       ;
        rti                                     ; 9210 40                       @

; ----------------------------------------------------------------------------
        eor     ($48,x)                         ; 9211 41 48                    AH
        eor     #$22                            ; 9213 49 22                    I"
        .byte   $23                             ; 9215 23                       #
        rol     a                               ; 9216 2A                       *
        .byte   $2B                             ; 9217 2B                       +
        jsr     L2810                           ; 9218 20 10 28                  .(
        and     #$11                            ; 921B 29 11                    ).
        .byte   $23                             ; 921D 23                       #
        rol     a                               ; 921E 2A                       *
        .byte   $2B                             ; 921F 2B                       +
        .byte   $B2                             ; 9220 B2                       .
        .byte   $B3                             ; 9221 B3                       .
        tsx                                     ; 9222 BA                       .
        .byte   $BB                             ; 9223 BB                       .
        ldy     $B5,x                           ; 9224 B4 B5                    ..
        ldy     $50BD,x                         ; 9226 BC BD 50                 ..P
        eor     ($58),y                         ; 9229 51 58                    QX
        eor     $5D51,y                         ; 922B 59 51 5D                 YQ]
        eor     $645E,y                         ; 922E 59 5E 64                 Y^d
        .byte   $64                             ; 9231 64                       d
        adc     ($61,x)                         ; 9232 61 61                    aa
        lsr     $47                             ; 9234 46 47                    FG
        asl     $131F,x                         ; 9236 1E 1F 13                 ...
        ora     L0000,x                         ; 9239 15 00                    ..
        brk                                     ; 923B 00                       .
        ora     L0016,x                         ; 923C 15 16                    ..
        brk                                     ; 923E 00                       .
        brk                                     ; 923F 00                       .
        .byte   $C2                             ; 9240 C2                       .
        .byte   $C3                             ; 9241 C3                       .
        brk                                     ; 9242 00                       .
        brk                                     ; 9243 00                       .
        cpy     L0000                           ; 9244 C4 00                    ..
        brk                                     ; 9246 00                       .
        brk                                     ; 9247 00                       .
        cli                                     ; 9248 58                       X
        eor     $5958,y                         ; 9249 59 58 59                 YXY
        eor     $595E,y                         ; 924C 59 5E 59                 Y^Y
        lsr     L9494,x                         ; 924F 5E 94 94                 ^..
        .byte   $9C                             ; 9252 9C                       .
        .byte   $9C                             ; 9253 9C                       .
        brk                                     ; 9254 00                       .
        .byte   $27                             ; 9255 27                       '
        rol     $122F                           ; 9256 2E 2F 12                 ./.
        ora     L0000,x                         ; 9259 15 00                    ..
        brk                                     ; 925B 00                       .
        asl     $06                             ; 925C 06 06                    ..
        brk                                     ; 925E 00                       .
L925F:  brk                                     ; 925F 00                       .
        .byte   $5B                             ; 9260 5B                       [
        eor     $5963,y                         ; 9261 59 63 59                 YcY
        eor     $5957,y                         ; 9264 59 57 59                 YWY
        .byte   $5F                             ; 9267 5F                       _
        ldy     $A4                             ; 9268 A4 A4                    ..
        ldy     $36AC                           ; 926A AC AC 36                 ..6
        .byte   $37                             ; 926D 37                       7
        lsr     $47                             ; 926E 46 47                    FG
        asl     L0015,x                         ; 9270 16 15                    ..
        brk                                     ; 9272 00                       .
        brk                                     ; 9273 00                       .
        adc     ($61,x)                         ; 9274 61 61                    aa
        adc     ($61,x)                         ; 9276 61 61                    aa
        brk                                     ; 9278 00                       .
        brk                                     ; 9279 00                       .
        brk                                     ; 927A 00                       .
        brk                                     ; 927B 00                       .
        ora     ($02,x)                         ; 927C 01 02                    ..
        ora     #$0A                            ; 927E 09 0A                    ..
        .byte   $03                             ; 9280 03                       .
        .byte   $04                             ; 9281 04                       .
        .byte   $0B                             ; 9282 0B                       .
        .byte   $0C                             ; 9283 0C                       .
        ora     L0001                           ; 9284 05 01                    ..
        ora     $FC0E                           ; 9286 0D 0E FC                 ...
        sbc     $EFEE,x                         ; 9289 FD EE EF                 ...
        .byte   $3C                             ; 928C 3C                       <
        .byte   $3C                             ; 928D 3C                       <
        .byte   $3C                             ; 928E 3C                       <
        .byte   $3C                             ; 928F 3C                       <
        inc     $F7,x                           ; 9290 F6 F7                    ..
        inc     $22FF,x                         ; 9292 FE FF 22                 .."
        .byte   $22                             ; 9295 22                       "
        .byte   $22                             ; 9296 22                       "
        .byte   $22                             ; 9297 22                       "
        .byte   $23                             ; 9298 23                       #
        .byte   $3C                             ; 9299 3C                       <
        .byte   $23                             ; 929A 23                       #
        sec                                     ; 929B 38                       8
        inx                                     ; 929C E8                       .
        sbc     #$38                            ; 929D E9 38                    .8
        ldx     $2120                           ; 929F AE 20 21                 . !
        plp                                     ; 92A2 28                       (
        and     #$22                            ; 92A3 29 22                    )"
        .byte   $22                             ; 92A5 22                       "
        rol     a                               ; 92A6 2A                       *
        rol     a                               ; 92A7 2A                       *
        .byte   $23                             ; 92A8 23                       #
        brk                                     ; 92A9 00                       .
        .byte   $2B                             ; 92AA 2B                       +
        brk                                     ; 92AB 00                       .
        bcs     L925F                           ; 92AC B0 B1                    ..
        clv                                     ; 92AE B8                       .
        lda     $C100,y                         ; 92AF B9 00 C1                 ...
        brk                                     ; 92B2 00                       .
        brk                                     ; 92B3 00                       .
        eor     L8E57,y                         ; 92B4 59 57 8E                 YW.
        stx     a:L0000                         ; 92B7 8E 00 00                 ...
        stx     $448E                           ; 92BA 8E 8E 44                 ..D
        eor     $1C                             ; 92BD 45 1C                    E.
        ora     $2524,x                         ; 92BF 1D 24 25                 .$%
        bit     $3C2D                           ; 92C2 2C 2D 3C                 ,-<
        cmp     $F0                             ; 92C5 C5 F0                    ..
        sbc     ($34),y                         ; 92C7 F1 34                    .4
        and     $44,x                           ; 92C9 35 44                    5D
        eor     $3C                             ; 92CB 45 3C                    E<
        .byte   $3C                             ; 92CD 3C                       <
        sec                                     ; 92CE 38                       8
        sec                                     ; 92CF 38                       8
        clc                                     ; 92D0 18                       .
        ora     $2928,y                         ; 92D1 19 28 29                 .()
        .byte   $1A                             ; 92D4 1A                       .
        .byte   $1B                             ; 92D5 1B                       .
        rol     a                               ; 92D6 2A                       *
        .byte   $2B                             ; 92D7 2B                       +
        .byte   $DA                             ; 92D8 DA                       .
        .byte   $DA                             ; 92D9 DA                       .
        nop                                     ; 92DA EA                       .
        nop                                     ; 92DB EA                       .
        lsr     $47                             ; 92DC 46 47                    FG
        .byte   $47                             ; 92DE 47                       G
        brk                                     ; 92DF 00                       .
        .byte   $7C                             ; 92E0 7C                       |
        adc     $7978,x                         ; 92E1 7D 78 79                 }xy
        ror     $7A7F,x                         ; 92E4 7E 7F 7A                 ~.z
        .byte   $7B                             ; 92E7 7B                       {
        sty     $85                             ; 92E8 84 85                    ..
        tya                                     ; 92EA 98                       .
        sta     L8786,y                         ; 92EB 99 86 87                 ...
        txs                                     ; 92EE 9A                       .
        .byte   $9B                             ; 92EF 9B                       .
        .byte   $E2                             ; 92F0 E2                       .
        .byte   $E2                             ; 92F1 E2                       .
L92F2:  .byte   $E2                             ; 92F2 E2                       .
        .byte   $E2                             ; 92F3 E2                       .
        inc     $F7,x                           ; 92F4 F6 F7                    ..
        .byte   $DC                             ; 92F6 DC                       .
        cmp     a:L0023,x                       ; 92F7 DD 23 00                 .#.
        .byte   $23                             ; 92FA 23                       #
        brk                                     ; 92FB 00                       .
        .byte   $80                             ; 92FC 80                       .
        sta     ($88,x)                         ; 92FD 81 88                    ..
        .byte   $89                             ; 92FF 89                       .
        .byte   $82                             ; 9300 82                       .
        .byte   $83                             ; 9301 83                       .
        txa                                     ; 9302 8A                       .
        .byte   $8B                             ; 9303 8B                       .
        adc     ($61,x)                         ; 9304 61 61                    aa
        .byte   $66                             ; 9306 66                       f
L9307:  ror     $A0                             ; 9307 66 A0                    f.
        lda     ($A8,x)                         ; 9309 A1 A8                    ..
        lda     #$A2                            ; 930B A9 A2                    ..
        .byte   $A3                             ; 930D A3                       .
        tax                                     ; 930E AA                       .
        .byte   $AB                             ; 930F AB                       .
        .byte   $DA                             ; 9310 DA                       .
        .byte   $DA                             ; 9311 DA                       .
        .byte   $8F                             ; 9312 8F                       .
        .byte   $8F                             ; 9313 8F                       .
        .byte   $DC                             ; 9314 DC                       .
        cmp     $DDDC,x                         ; 9315 DD DC DD                 ...
        lda     $BE                             ; 9318 A5 BE                    ..
        brk                                     ; 931A 00                       .
        brk                                     ; 931B 00                       .
        inc     $DE                             ; 931C E6 DE                    ..
        bne     L92F2                           ; 931E D0 D2                    ..
        sbc     #$C8                            ; 9320 E9 C8                    ..
        ldx     $C8C9                           ; 9322 AE C9 C8                 ...
        inc     $C9                             ; 9325 E6 C9                    ..
        bne     L9307                           ; 9327 D0 DE                    ..
        dec     $D2D2,x                         ; 9329 DE D2 D2                 ...
        .byte   $E7                             ; 932C E7                       .
        cmp     $FFD1,x                         ; 932D DD D1 FF                 ...
        lsr     $47                             ; 9330 46 47                    FG
        .byte   $22                             ; 9332 22                       "
        .byte   $23                             ; 9333 23                       #
        .byte   $44                             ; 9334 44                       D
        eor     L0020                           ; 9335 45 20                    E 
        and     (L0000,x)                       ; 9337 21 00                    !.
        brk                                     ; 9339 00                       .
        iny                                     ; 933A C8                       .
        iny                                     ; 933B C8                       .
        cmp     #$C9                            ; 933C C9 C9                    ..
        inc     $E7                             ; 933E E6 E7                    ..
        ora     (L0001,x)                       ; 9340 01 01                    ..
        sec                                     ; 9342 38                       8
        sec                                     ; 9343 38                       8
        .byte   $F7                             ; 9344 F7                       .
        ror     a                               ; 9345 6A                       j
        .byte   $FF                             ; 9346 FF                       .
        adc     ($6A,x)                         ; 9347 61 6A                    aj
        ror     a                               ; 9349 6A                       j
        adc     ($61,x)                         ; 934A 61 61                    aa
        .byte   $64                             ; 934C 64                       d
        ror     a                               ; 934D 6A                       j
        adc     ($61,x)                         ; 934E 61 61                    aa
        ror     a                               ; 9350 6A                       j
        ror     a                               ; 9351 6A                       j
        adc     ($3D,x)                         ; 9352 61 3D                    a=
        stx     $97,y                           ; 9354 96 97                    ..
        sei                                     ; 9356 78                       x
        adc     $7372,y                         ; 9357 79 72 73                 yrs
        .byte   $7A                             ; 935A 7A                       z
        .byte   $7B                             ; 935B 7B                       {
        ror     a                               ; 935C 6A                       j
        ror     a                               ; 935D 6A                       j
        inc     $DE,x                           ; 935E F6 DE                    ..
        ror     a                               ; 9360 6A                       j
        ror     a                               ; 9361 6A                       j
        dec     $6AE9,x                         ; 9362 DE E9 6A                 ..j
        and     $3D61,x                         ; 9365 3D 61 3D                 =a=
        inc     $64D2,x                         ; 9368 FE D2 64                 ..d
        .byte   $64                             ; 936B 64                       d
        .byte   $D2                             ; 936C D2                       .
        ldx     $6464                           ; 936D AE 64 64                 .dd
        ror     a                               ; 9370 6A                       j
        and     $0861,x                         ; 9371 3D 61 08                 =a.
        adc     ($61,x)                         ; 9374 61 61                    aa
        stx     $E08E                           ; 9376 8E 8E E0                 ...
        sbc     ($AD,x)                         ; 9379 E1 AD                    ..
        sty     $D8D8                           ; 937B 8C D8 D8                 ...
        ror     $D96E                           ; 937E 6E 6E D9                 nn.
        ror     $4F75                           ; 9381 6E 75 4F                 nuO
        ror     $4F6E                           ; 9384 6E 6E 4F                 nnO
        .byte   $4F                             ; 9387 4F                       O
        adc     $6E,x                           ; 9388 75 6E                    un
        .byte   $62                             ; 938A 62                       b
        .byte   $4F                             ; 938B 4F                       O
        .byte   $4F                             ; 938C 4F                       O
        .byte   $4F                             ; 938D 4F                       O
        .byte   $4F                             ; 938E 4F                       O
        .byte   $4F                             ; 938F 4F                       O
        .byte   $62                             ; 9390 62                       b
        .byte   $4F                             ; 9391 4F                       O
        .byte   $62                             ; 9392 62                       b
        .byte   $4F                             ; 9393 4F                       O
L9394:  .byte   $4F                             ; 9394 4F                       O
        .byte   $4F                             ; 9395 4F                       O
        stx     $628E                           ; 9396 8E 8E 62                 ..b
        .byte   $4F                             ; 9399 4F                       O
L939A:  stx     $DE8E                           ; 939A 8E 8E DE                 ...
        sbc     #$D2                            ; 939D E9 D2                    ..
        ldx     $4FF7                           ; 939F AE F7 4F                 ..O
        cmp     $3C4F,x                         ; 93A2 DD 4F 3C                 .O<
        cmp     $3C                             ; 93A5 C5 3C                    .<
        cmp     $DD                             ; 93A7 C5 DD                    ..
        ror     a                               ; 93A9 6A                       j
        cmp     $6E61,x                         ; 93AA DD 61 6E                 .an
        inc     $4F,x                           ; 93AD F6 4F                    .O
        inc     $B601,x                         ; 93AF FE 01 B6                 ...
        .byte   $3C                             ; 93B2 3C                       <
        cmp     $4F                             ; 93B3 C5 4F                    .O
        ror     $4F4F                           ; 93B5 6E 4F 4F                 nOO
        adc     $65                             ; 93B8 65 65                    ee
        brk                                     ; 93BA 00                       .
        brk                                     ; 93BB 00                       .
        inc     $DE,x                           ; 93BC F6 DE                    ..
        inc     $4FD2,x                         ; 93BE FE D2 4F                 ..O
        .byte   $4F                             ; 93C1 4F                       O
        lsr     $F64E                           ; 93C2 4E 4E F6                 NN.
        ora     ($DC,x)                         ; 93C5 01 DC                    ..
        .byte   $3C                             ; 93C7 3C                       <
        inc     $E7                             ; 93C8 E6 E7                    ..
        .byte   $DC                             ; 93CA DC                       .
        .byte   $DB                             ; 93CB DB                       .
        .byte   $FC                             ; 93CC FC                       .
        sbc     $D1D0,x                         ; 93CD FD D0 D1                 ...
        .byte   $4F                             ; 93D0 4F                       O
        .byte   $4F                             ; 93D1 4F                       O
        inc     $E7                             ; 93D2 E6 E7                    ..
        .byte   $DC                             ; 93D4 DC                       .
        .byte   $DB                             ; 93D5 DB                       .
        inc     $18EF                           ; 93D6 EE EF 18                 ...
        ora     $2120,y                         ; 93D9 19 20 21                 . !
        .byte   $1A                             ; 93DC 1A                       .
        .byte   $1B                             ; 93DD 1B                       .
        .byte   $22                             ; 93DE 22                       "
        .byte   $23                             ; 93DF 23                       #
        adc     $64,x                           ; 93E0 75 64                    ud
        .byte   $62                             ; 93E2 62                       b
        adc     ($64,x)                         ; 93E3 61 64                    ad
        inc     $61,x                           ; 93E5 F6 61                    .a
        inc     L9462,x                         ; 93E7 FE 62 94                 .b.
        .byte   $F7                             ; 93EA F7                       .
        .byte   $9C                             ; 93EB 9C                       .
        sty     $9D,x                           ; 93EC 94 9D                    ..
        .byte   $9C                             ; 93EE 9C                       .
        .byte   $9C                             ; 93EF 9C                       .
        rol     L0026                           ; 93F0 26 26                    &&
        .byte   $9C                             ; 93F2 9C                       .
        .byte   $9C                             ; 93F3 9C                       .
        .byte   $DC                             ; 93F4 DC                       .
        .byte   $DB                             ; 93F5 DB                       .
        .byte   $DC                             ; 93F6 DC                       .
        .byte   $AF                             ; 93F7 AF                       .
        cmp     $DD95,x                         ; 93F8 DD 95 DD                 ...
        ldy     $95                             ; 93FB A4 95                    ..
L93FD:  sta     $A4,x                           ; 93FD 95 A4                    ..
        clc                                     ; 93FF 18                       .
        sta     $95,x                           ; 9400 95 95                    ..
        ora     $201A,y                         ; 9402 19 1A 20                 .. 
        and     (L001A,x)                       ; 9405 21 1A                    !.
        .byte   $1A                             ; 9407 1A                       .
        .byte   $3C                             ; 9408 3C                       <
        .byte   $FC                             ; 9409 FC                       .
        .byte   $3C                             ; 940A 3C                       <
        inc     $3CFD                           ; 940B EE FD 3C                 ..<
        .byte   $EF                             ; 940E EF                       .
        .byte   $3C                             ; 940F 3C                       <
        cmp     $DDAC,x                         ; 9410 DD AC DD                 ...
        adc     $AC                             ; 9413 65 AC                    e.
        jsr     L2065                           ; 9415 20 65 20                  e 
        and     (L0022,x)                       ; 9418 21 22                    !"
        and     (L0022,x)                       ; 941A 21 22                    !"
        cmp     $DD00,x                         ; 941C DD 00 DD                 ...
        brk                                     ; 941F 00                       .
        brk                                     ; 9420 00                       .
        jsr     L2800                           ; 9421 20 00 28                  .(
        and     (L0022,x)                       ; 9424 21 22                    !"
        and     #$2A                            ; 9426 29 2A                    )*
        .byte   $DC                             ; 9428 DC                       .
        .byte   $DB                             ; 9429 DB                       .
        bne     L93FD                           ; 942A D0 D1                    ..
        cmp     $FF00,x                         ; 942C DD 00 FF                 ...
        brk                                     ; 942F 00                       .
        brk                                     ; 9430 00                       .
        jsr     L2000                           ; 9431 20 00 20                  . 
        asl     L0020,x                         ; 9434 16 20                    . 
        brk                                     ; 9436 00                       .
        jsr     LE4E5                           ; 9437 20 E5 E4                  ..
        sbc     $53EC                           ; 943A ED EC 53                 ..S
        .byte   $53                             ; 943D 53                       S
        .byte   $6B                             ; 943E 6B                       k
        .byte   $6B                             ; 943F 6B                       k
        sbc     $EDEC                           ; 9440 ED EC ED                 ...
        cpx     $6B6B                           ; 9443 EC 6B 6B                 .kk
        .byte   $6B                             ; 9446 6B                       k
        .byte   $6B                             ; 9447 6B                       k
        .byte   $8F                             ; 9448 8F                       .
        .byte   $8F                             ; 9449 8F                       .
        iny                                     ; 944A C8                       .
        iny                                     ; 944B C8                       .
        .byte   $DC                             ; 944C DC                       .
        .byte   $DB                             ; 944D DB                       .
        .byte   $DC                             ; 944E DC                       .
        .byte   $DB                             ; 944F DB                       .
        .byte   $DC                             ; 9450 DC                       .
        .byte   $DB                             ; 9451 DB                       .
        jmp     (LE36D)                         ; 9452 6C 6D E3                 lm.

; ----------------------------------------------------------------------------
        .byte   $E3                             ; 9455 E3                       .
        .byte   $E2                             ; 9456 E2                       .
        .byte   $E2                             ; 9457 E2                       .
        .byte   $0F                             ; 9458 0F                       .
        rol     $E2E2,x                         ; 9459 3E E2 E2                 >..
        .byte   $E3                             ; 945C E3                       .
        .byte   $FC                             ; 945D FC                       .
        .byte   $E2                             ; 945E E2                       .
        inc     $1A19                           ; 945F EE 19 1A                 ...
L9462:  and     (L0022,x)                       ; 9462 21 22                    !"
        .byte   $1B                             ; 9464 1B                       .
        .byte   $E2                             ; 9465 E2                       .
        .byte   $23                             ; 9466 23                       #
L9467:  .byte   $E2                             ; 9467 E2                       .
        .byte   $E2                             ; 9468 E2                       .
        .byte   $FC                             ; 9469 FC                       .
        .byte   $E2                             ; 946A E2                       .
        inc     $18E2                           ; 946B EE E2 18                 ...
        .byte   $E2                             ; 946E E2                       .
        jsr     L1919                           ; 946F 20 19 19                  ..
        and     (L0021,x)                       ; 9472 21 21                    !!
        .byte   $23                             ; 9474 23                       #
        .byte   $E2                             ; 9475 E2                       .
        .byte   $2B                             ; 9476 2B                       +
        .byte   $E2                             ; 9477 E2                       .
        .byte   $E3                             ; 9478 E3                       .
        .byte   $E2                             ; 9479 E2                       .
        .byte   $E2                             ; 947A E2                       .
        .byte   $E2                             ; 947B E2                       .
        .byte   $E2                             ; 947C E2                       .
        sed                                     ; 947D F8                       .
        .byte   $E2                             ; 947E E2                       .
        .byte   $E3                             ; 947F E3                       .
        cld                                     ; 9480 D8                       .
        cld                                     ; 9481 D8                       .
        sbc     $E4                             ; 9482 E5 E4                    ..
        cld                                     ; 9484 D8                       .
        cld                                     ; 9485 D8                       .
        brk                                     ; 9486 00                       .
        brk                                     ; 9487 00                       .
        cld                                     ; 9488 D8                       .
        cld                                     ; 9489 D8                       .
        adc     L0000,x                         ; 948A 75 00                    u.
        cpy     $D400                           ; 948C CC 00 D4                 ...
        brk                                     ; 948F 00                       .
        .byte   $62                             ; 9490 62                       b
        brk                                     ; 9491 00                       .
        .byte   $62                             ; 9492 62                       b
        brk                                     ; 9493 00                       .
L9494:  .byte   $CB                             ; 9494 CB                       .
        cpy     $D4D3                           ; 9495 CC D3 D4                 ...
        .byte   $CB                             ; 9498 CB                       .
        cpy     $D9F8                           ; 9499 CC F8 D9                 ...
        .byte   $62                             ; 949C 62                       b
        brk                                     ; 949D 00                       .
        stx     $218E                           ; 949E 8E 8E 21                 ..!
        and     (L0021,x)                       ; 94A1 21 21                    !!
        and     ($5C,x)                         ; 94A3 21 5C                    !\
        .byte   $5C                             ; 94A5 5C                       \
        .byte   $5C                             ; 94A6 5C                       \
        .byte   $5C                             ; 94A7 5C                       \
        .byte   $62                             ; 94A8 62                       b
        .byte   $5C                             ; 94A9 5C                       \
        .byte   $62                             ; 94AA 62                       b
        .byte   $5C                             ; 94AB 5C                       \
        cld                                     ; 94AC D8                       .
        cld                                     ; 94AD D8                       .
        .byte   $3C                             ; 94AE 3C                       <
L94AF:  .byte   $3C                             ; 94AF 3C                       <
        cpy     #$00                            ; 94B0 C0 00                    ..
        pla                                     ; 94B2 68                       h
        brk                                     ; 94B3 00                       .
        pla                                     ; 94B4 68                       h
        brk                                     ; 94B5 00                       .
        adc     #$00                            ; 94B6 69 00                    i.
        stx     $F88E                           ; 94B8 8E 8E F8                 ...
        cmp     $E2E2,y                         ; 94BB D9 E2 E2                 ...
        nop                                     ; 94BE EA                       .
        nop                                     ; 94BF EA                       .
        sbc     L8EEC                           ; 94C0 ED EC 8E                 ...
        stx     $FDFC                           ; 94C3 8E FC FD                 ...
        inc     $70D1,x                         ; 94C6 FE D1 70                 ..p
        adc     ($78),y                         ; 94C9 71 78                    qx
        adc     $ECED,y                         ; 94CB 79 ED EC                 y..
        inc     $F7,x                           ; 94CE F6 F7                    ..
        .byte   $FC                             ; 94D0 FC                       .
        .byte   $FD                             ; 94D1 FD                       .
        .byte   $DC                             ; 94D2 DC                       .
L94D3:  .byte   $DB                             ; 94D3 DB                       .
        stx     $DC                             ; 94D4 86 DC                    ..
        txs                                     ; 94D6 9A                       .
        inc     L9EA2,x                         ; 94D7 FE A2 9E                 ...
        tax                                     ; 94DA AA                       .
        .byte   $AB                             ; 94DB AB                       .
        bne     L94AF                           ; 94DC D0 D1                    ..
        sbc     $E4                             ; 94DE E5 E4                    ..
        sed                                     ; 94E0 F8                       .
        cld                                     ; 94E1 D8                       .
        brk                                     ; 94E2 00                       .
        brk                                     ; 94E3 00                       .
        inc     $E5D1,x                         ; 94E4 FE D1 E5                 ...
        cpx     $D5                             ; 94E7 E4 D5                    ..
        dec     $98,x                           ; 94E9 D6 98                    ..
        sta     $CDD7,y                         ; 94EB 99 D7 CD                 ...
        txs                                     ; 94EE 9A                       .
        .byte   $9B                             ; 94EF 9B                       .
        ldx     #$A3                            ; 94F0 A2 A3                    ..
        tax                                     ; 94F2 AA                       .
        sed                                     ; 94F3 F8                       .
        .byte   $D7                             ; 94F4 D7                       .
        .byte   $87                             ; 94F5 87                       .
        txs                                     ; 94F6 9A                       .
        .byte   $9B                             ; 94F7 9B                       .
        sed                                     ; 94F8 F8                       .
        dec     $D06F,x                         ; 94F9 DE 6F D0                 .o.
        .byte   $77                             ; 94FC 77                       w
        bne     L9571                           ; 94FD D0 72                    .r
        .byte   $7F                             ; 94FF 7F                       .
        bne     L94D3                           ; 9500 D0 D1                    ..
        sty     $85                             ; 9502 84 85                    ..
        .byte   $7A                             ; 9504 7A                       z
        .byte   $7B                             ; 9505 7B                       {
        .byte   $82                             ; 9506 82                       .
        .byte   $83                             ; 9507 83                       .
        tya                                     ; 9508 98                       .
        sta     $A1A0,y                         ; 9509 99 A0 A1                 ...
        txa                                     ; 950C 8A                       .
        .byte   $8B                             ; 950D 8B                       .
        .byte   $72                             ; 950E 72                       r
L950F:  .byte   $73                             ; 950F 73                       s
        tay                                     ; 9510 A8                       .
        lda     #$D5                            ; 9511 A9 D5                    ..
        dec     $DD,x                           ; 9513 D6 DD                    ..
        and     $3DDD,x                         ; 9515 3D DD 3D                 =.=
        cmp     $FF3D,x                         ; 9518 DD 3D FF                 .=.
        php                                     ; 951B 08                       .
        .byte   $82                             ; 951C 82                       .
        .byte   $83                             ; 951D 83                       .
        stx     L8E8E                           ; 951E 8E 8E 8E                 ...
        stx     a:L0000                         ; 9521 8E 00 00                 ...
        .byte   $80                             ; 9524 80                       .
        sta     ($8E,x)                         ; 9525 81 8E                    ..
        stx     $7372                           ; 9527 8E 72 73                 .rs
        stx     $CB8E                           ; 952A 8E 8E CB                 ...
        stx     L8E8E                           ; 952D 8E 8E 8E                 ...
        brk                                     ; 9530 00                       .
        .byte   $FC                             ; 9531 FC                       .
        brk                                     ; 9532 00                       .
        inc     L9F9F                           ; 9533 EE 9F 9F                 ...
        .byte   $A7                             ; 9536 A7                       .
        .byte   $A7                             ; 9537 A7                       .
        brk                                     ; 9538 00                       .
        bne     L953B                           ; 9539 D0 00                    ..
L953B:  brk                                     ; 953B 00                       .
        bne     L950F                           ; 953C D0 D1                    ..
        brk                                     ; 953E 00                       .
        brk                                     ; 953F 00                       .
        inc     a:$EF                           ; 9540 EE EF 00                 ...
        brk                                     ; 9543 00                       .
        eor     $45                             ; 9544 45 45                    EE
        .byte   $1C                             ; 9546 1C                       .
        .byte   $1D                             ; 9547 1D                       .
        brk                                     ; 9548 00                       .
L9549:  and     $3D00,x                         ; 9549 3D 00 3D                 =.=
        .byte   $F7                             ; 954C F7                       .
        and     $3DDD,x                         ; 954D 3D DD 3D                 =.=
        .byte   $3C                             ; 9550 3C                       <
        .byte   $3C                             ; 9551 3C                       <
        .byte   $9F                             ; 9552 9F                       .
        .byte   $9F                             ; 9553 9F                       .
        .byte   $3C                             ; 9554 3C                       <
        .byte   $DC                             ; 9555 DC                       .
        .byte   $9F                             ; 9556 9F                       .
        .byte   $DC                             ; 9557 DC                       .
        inx                                     ; 9558 E8                       .
        sbc     #$F0                            ; 9559 E9 F0                    ..
        sbc     ($A7),y                         ; 955B F1 A7                    ..
        .byte   $A7                             ; 955D A7                       .
        brk                                     ; 955E 00                       .
L955F:  brk                                     ; 955F 00                       .
        .byte   $A7                             ; 9560 A7                       .
        .byte   $FC                             ; 9561 FC                       .
        brk                                     ; 9562 00                       .
        bne     L9549                           ; 9563 D0 E4                    ..
        .byte   $FC                             ; 9565 FC                       .
        .byte   $EC                             ; 9566 EC                       .
L9567:  .byte   $D0,$EC                    ; 9567 D0 EC   (branch out of range for ca65: target has no local label)
        sty     $EC                             ; 9569 84 EC                    ..
L956B:  tya                                     ; 956B 98                       .
        sta     $86                             ; 956C 85 86                    ..
        sta     $EC9A,y                         ; 956E 99 9A EC                 ...
L9571:  bcc     L955F                           ; 9571 90 EC                    ..
        tya                                     ; 9573 98                       .
        sta     ($92),y                         ; 9574 91 92                    ..
        sta     L939A,y                         ; 9576 99 9A 93                 ...
        sbc     $9B                             ; 9579 E5 9B                    ..
        sbc     $D1D0                           ; 957B ED D0 D1                 ...
        .byte   $E3                             ; 957E E3                       .
        dex                                     ; 957F CA                       .
        .byte   $DA                             ; 9580 DA                       .
        ldy     #$EA                            ; 9581 A0 EA                    ..
        tay                                     ; 9583 A8                       .
        lda     ($A2,x)                         ; 9584 A1 A2                    ..
        lda     #$AA                            ; 9586 A9 AA                    ..
        .byte   $A3                             ; 9588 A3                       .
        sbc     $EDAB                           ; 9589 ED AB ED                 ...
        .byte   $E2                             ; 958C E2                       .
        dex                                     ; 958D CA                       .
L958E:  .byte   $E2                             ; 958E E2                       .
        dex                                     ; 958F CA                       .
        .byte   $EB                             ; 9590 EB                       .
        .byte   $EB                             ; 9591 EB                       .
        .byte   $3C                             ; 9592 3C                       <
        .byte   $3C                             ; 9593 3C                       <
        bne     L9567                           ; 9594 D0 D1                    ..
        .byte   $E3                             ; 9596 E3                       .
        .byte   $E3                             ; 9597 E3                       .
        bne     L956B                           ; 9598 D0 D1                    ..
        .byte   $7C                             ; 959A 7C                       |
        adc     $D1D0,x                         ; 959B 7D D0 D1                 }..
        ror     $787F,x                         ; 959E 7E 7F 78                 ~.x
        adc     L8180,y                         ; 95A1 79 80 81                 y..
        .byte   $F7                             ; 95A4 F7                       .
        .byte   $43                             ; 95A5 43                       C
        cmp     $4356,x                         ; 95A6 DD 56 43                 .VC
        .byte   $43                             ; 95A9 43                       C
        lsr     $56,x                           ; 95AA 56 56                    VV
        .byte   $43                             ; 95AC 43                       C
        .byte   $43                             ; 95AD 43                       C
        eor     $4B,x                           ; 95AE 55 4B                    UK
        .byte   $43                             ; 95B0 43                       C
        .byte   $43                             ; 95B1 43                       C
        .byte   $4B                             ; 95B2 4B                       K
        .byte   $4B                             ; 95B3 4B                       K
        .byte   $43                             ; 95B4 43                       C
        .byte   $FC                             ; 95B5 FC                       .
        .byte   $4B                             ; 95B6 4B                       K
        .byte   $DC                             ; 95B7 DC                       .
        cmp     $DD4B,x                         ; 95B8 DD 4B DD                 .K.
        lsr     a                               ; 95BB 4A                       J
        .byte   $0F                             ; 95BC 0F                       .
        rol     $4A4A,x                         ; 95BD 3E 4A 4A                 >JJ
        .byte   $4B                             ; 95C0 4B                       K
        .byte   $4B                             ; 95C1 4B                       K
        lsr     a                               ; 95C2 4A                       J
        lsr     a                               ; 95C3 4A                       J
        .byte   $4B                             ; 95C4 4B                       K
        .byte   $DC                             ; 95C5 DC                       .
        lsr     a                               ; 95C6 4A                       J
        .byte   $DC                             ; 95C7 DC                       .
        cmp     $DD4C,x                         ; 95C8 DD 4C DD                 .L.
        jmp     L4C4C                           ; 95CB 4C 4C 4C                 LLL

; ----------------------------------------------------------------------------
        jmp     L4C4C                           ; 95CE 4C 4C 4C                 LLL

; ----------------------------------------------------------------------------
        .byte   $DC                             ; 95D1 DC                       .
        jmp     LFFDC                           ; 95D2 4C DC FF                 L..

; ----------------------------------------------------------------------------
        .byte   $42                             ; 95D5 42                       B
        cpx     $4B                             ; 95D6 E4 4B                    .K
        .byte   $42                             ; 95D8 42                       B
        .byte   $42                             ; 95D9 42                       B
        .byte   $4B                             ; 95DA 4B                       K
        .byte   $4B                             ; 95DB 4B                       K
        eor     $3F42                           ; 95DC 4D 42 3F                 MB?
        lsr     $42,x                           ; 95DF 56 42                    VB
        .byte   $42                             ; 95E1 42                       B
        lsr     $56,x                           ; 95E2 56 56                    VV
        .byte   $42                             ; 95E4 42                       B
        .byte   $DC                             ; 95E5 DC                       .
        lsr     $DC,x                           ; 95E6 56 DC                    V.
        cpx     $EC4B                           ; 95E8 EC 4B EC                 .K.
        lsr     $4B,x                           ; 95EB 56 4B                    VK
        .byte   $4B                             ; 95ED 4B                       K
        lsr     $56,x                           ; 95EE 56 56                    VV
        .byte   $54                             ; 95F0 54                       T
        .byte   $4B                             ; 95F1 4B                       K
        .byte   $3F                             ; 95F2 3F                       ?
        lsr     $4B,x                           ; 95F3 56 4B                    VK
        .byte   $DC                             ; 95F5 DC                       .
        lsr     $EE,x                           ; 95F6 56 EE                    V.
        brk                                     ; 95F8 00                       .
        brk                                     ; 95F9 00                       .
        brk                                     ; 95FA 00                       .
        brk                                     ; 95FB 00                       .
        brk                                     ; 95FC 00                       .
        brk                                     ; 95FD 00                       .
        brk                                     ; 95FE 00                       .
        brk                                     ; 95FF 00                       .
        brk                                     ; 9600 00                       .
        ora     (L0000,x)                       ; 9601 01 00                    ..
        .byte   $02                             ; 9603 02                       .
        .byte   $03                             ; 9604 03                       .
        .byte   $04                             ; 9605 04                       .
        .byte   $02                             ; 9606 02                       .
        .byte   $03                             ; 9607 03                       .
        ora     $06                             ; 9608 05 06                    ..
        .byte   $07                             ; 960A 07                       .
        php                                     ; 960B 08                       .
        ora     #$0A                            ; 960C 09 0A                    ..
        .byte   $0B                             ; 960E 0B                       .
        .byte   $0C                             ; 960F 0C                       .
        ora     $0F0E                           ; 9610 0D 0E 0F                 ...
        bpl     L9626                           ; 9613 10 11                    ..
        .byte   $12                             ; 9615 12                       .
        .byte   $13                             ; 9616 13                       .
        .byte   $14                             ; 9617 14                       .
        ora     L0016,x                         ; 9618 15 16                    ..
        asl     $170F                           ; 961A 0E 0F 17                 ...
        clc                                     ; 961D 18                       .
        ora     $1B1A,y                         ; 961E 19 1A 1B                 ...
        asl     $0F,x                           ; 9621 16 0F                    ..
        .byte   $17                             ; 9623 17                       .
        .byte   $1C                             ; 9624 1C                       .
        .byte   $12                             ; 9625 12                       .
L9626:  .byte   $13                             ; 9626 13                       .
        ora     $1E05,x                         ; 9627 1D 05 1E                 ...
        asl     $1E1E,x                         ; 962A 1E 1E 1E                 ...
        clc                                     ; 962D 18                       .
        ora     $1F1D,y                         ; 962E 19 1D 1F                 ...
        jsr     L1F21                           ; 9631 20 21 1F                  !.
        jsr     L1F21                           ; 9634 20 21 1F                  !.
        jsr     L2322                           ; 9637 20 22 23                  "#
        bit     $24                             ; 963A 24 24                    $$
        .byte   $23                             ; 963C 23                       #
        bit     $24                             ; 963D 24 24                    $$
        .byte   $23                             ; 963F 23                       #
        .byte   $04                             ; 9640 04                       .
        ora     (L0025,x)                       ; 9641 01 25                    .%
        rol     $02                             ; 9643 26 02                    &.
        .byte   $03                             ; 9645 03                       .
        .byte   $27                             ; 9646 27                       '
        ora     ($0C,x)                         ; 9647 01 0C                    ..
        plp                                     ; 9649 28                       (
        and     #$2A                            ; 964A 29 2A                    )*
        .byte   $2B                             ; 964C 2B                       +
        php                                     ; 964D 08                       .
        ora     #$01                            ; 964E 09 01                    ..
        .byte   $14                             ; 9650 14                       .
        asl     a                               ; 9651 0A                       .
        .byte   $0B                             ; 9652 0B                       .
        asl     $102C,x                         ; 9653 1E 2C 10                 .,.
        ora     (L0001),y                       ; 9656 11 01                    ..
        .byte   $1A                             ; 9658 1A                       .
        clc                                     ; 9659 18                       .
        ora     $0E0E,y                         ; 965A 19 0E 0E                 ...
        .byte   $0F                             ; 965D 0F                       .
        .byte   $17                             ; 965E 17                       .
        ora     ($1D,x)                         ; 965F 01 1D                    ..
        .byte   $12                             ; 9661 12                       .
        .byte   $13                             ; 9662 13                       .
        asl     $170F                           ; 9663 0E 0F 17                 ...
        .byte   $1C                             ; 9666 1C                       .
        asl     $1D                             ; 9667 06 1D                    ..
        clc                                     ; 9669 18                       .
        and     $2F2E                           ; 966A 2D 2E 2F                 -./
        ora     $011E                           ; 966D 0D 1E 01                 ...
        and     (L0020,x)                       ; 9670 21 20                    ! 
        .byte   $1F                             ; 9672 1F                       .
        .byte   $27                             ; 9673 27                       '
        bmi     L968B                           ; 9674 30 15                    0.
        asl     $2401,x                         ; 9676 1E 01 24                 ..$
        .byte   $23                             ; 9679 23                       #
        bit     $31                             ; 967A 24 31                    $1
        .byte   $32                             ; 967C 32                       2
        .byte   $1B                             ; 967D 1B                       .
        asl     $0401,x                         ; 967E 1E 01 04                 ...
        .byte   $33                             ; 9681 33                       3
        .byte   $02                             ; 9682 02                       .
        .byte   $27                             ; 9683 27                       '
        .byte   $34                             ; 9684 34                       4
        and     $36,x                           ; 9685 35 36                    56
        asl     $37                             ; 9687 06 37                    .7
        sec                                     ; 9689 38                       8
        .byte   $39                             ; 968A 39                       9
L968B:  .byte   $0C                             ; 968B 0C                       .
        .byte   $3A                             ; 968C 3A                       :
        .byte   $3B                             ; 968D 3B                       ;
        .byte   $3C                             ; 968E 3C                       <
        and     $3F3E,x                         ; 968F 3D 3E 3F                 =>?
        rti                                     ; 9692 40                       @

; ----------------------------------------------------------------------------
        eor     ($42,x)                         ; 9693 41 42                    AB
        .byte   $43                             ; 9695 43                       C
        .byte   $44                             ; 9696 44                       D
        eor     $3E                             ; 9697 45 3E                    E>
        lsr     $47                             ; 9699 46 47                    FG
        pha                                     ; 969B 48                       H
        eor     #$4A                            ; 969C 49 4A                    IJ
        lsr     a                               ; 969E 4A                       J
        .byte   $4B                             ; 969F 4B                       K
        rol     $1E1E,x                         ; 96A0 3E 1E 1E                 >..
        asl     $2B1E,x                         ; 96A3 1E 1E 2B                 ..+
        php                                     ; 96A6 08                       .
        ora     #$4C                            ; 96A7 09 4C                    .L
        asl     $1E1E,x                         ; 96A9 1E 1E 1E                 ...
        asl     $102C,x                         ; 96AC 1E 2C 10                 .,.
        ora     (L0000),y                       ; 96AF 11 00                    ..
        asl     $4C4D,x                         ; 96B1 1E 4D 4C                 .ML
        lsr     $0D2F                           ; 96B4 4E 2F 0D                 N/.
        .byte   $2F                             ; 96B7 2F                       /
        brk                                     ; 96B8 00                       .
        .byte   $27                             ; 96B9 27                       '
        asl     $07                             ; 96BA 06 07                    ..
        .byte   $4F                             ; 96BC 4F                       O
        bmi     L96D4                           ; 96BD 30 15                    0.
        bmi     L96C8                           ; 96BF 30 07                    0.
        .byte   $02                             ; 96C1 02                       .
        .byte   $03                             ; 96C2 03                       .
        .byte   $04                             ; 96C3 04                       .
        bvc     L9716                           ; 96C4 50 50                    PP
        eor     ($52),y                         ; 96C6 51 52                    QR
L96C8:  sec                                     ; 96C8 38                       8
        and     $0C0C,y                         ; 96C9 39 0C 0C                 9..
        .byte   $0C                             ; 96CC 0C                       .
        .byte   $0C                             ; 96CD 0C                       .
        .byte   $53                             ; 96CE 53                       S
        .byte   $52                             ; 96CF 52                       R
        .byte   $3F                             ; 96D0 3F                       ?
        rti                                     ; 96D1 40                       @

; ----------------------------------------------------------------------------
        .byte   $52                             ; 96D2 52                       R
        .byte   $52                             ; 96D3 52                       R
L96D4:  .byte   $52                             ; 96D4 52                       R
        .byte   $52                             ; 96D5 52                       R
        .byte   $54                             ; 96D6 54                       T
        .byte   $52                             ; 96D7 52                       R
        eor     $56,x                           ; 96D8 55 56                    UV
        .byte   $57                             ; 96DA 57                       W
        cli                                     ; 96DB 58                       X
        .byte   $52                             ; 96DC 52                       R
        .byte   $52                             ; 96DD 52                       R
        eor     $3F52,y                         ; 96DE 59 52 3F                 YR?
        rti                                     ; 96E1 40                       @

; ----------------------------------------------------------------------------
        .byte   $5A                             ; 96E2 5A                       Z
        .byte   $5B                             ; 96E3 5B                       [
        .byte   $52                             ; 96E4 52                       R
        .byte   $52                             ; 96E5 52                       R
        .byte   $5C                             ; 96E6 5C                       \
        .byte   $52                             ; 96E7 52                       R
        eor     $56,x                           ; 96E8 55 56                    UV
        .byte   $52                             ; 96EA 52                       R
        .byte   $52                             ; 96EB 52                       R
        .byte   $52                             ; 96EC 52                       R
        .byte   $52                             ; 96ED 52                       R
        .byte   $52                             ; 96EE 52                       R
        .byte   $52                             ; 96EF 52                       R
        ora     $0D2F                           ; 96F0 0D 2F 0D                 ./.
        eor     ($41,x)                         ; 96F3 41 41                    AA
        eor     $5D5D,x                         ; 96F5 5D 5D 5D                 ]]]
        ora     $30,x                           ; 96F8 15 30                    .0
        ora     $1E,x                           ; 96FA 15 1E                    ..
        asl     $4545,x                         ; 96FC 1E 45 45                 .EE
        eor     L0000                           ; 96FF 45 00                    E.
        and     ($5E),y                         ; 9701 31 5E                    1^
        lsr     $0204,x                         ; 9703 5E 04 02                 ^..
        lsr     a:$5E,x                         ; 9706 5E 5E 00                 ^^.
        .byte   $5F                             ; 9709 5F                       _
        .byte   $5F                             ; 970A 5F                       _
        rts                                     ; 970B 60                       `

; ----------------------------------------------------------------------------
        adc     ($62,x)                         ; 970C 61 62                    ab
        adc     ($62,x)                         ; 970E 61 62                    ab
        brk                                     ; 9710 00                       .
        .byte   $63                             ; 9711 63                       c
        .byte   $63                             ; 9712 63                       c
        .byte   $64                             ; 9713 64                       d
        .byte   $63                             ; 9714 63                       c
        .byte   $64                             ; 9715 64                       d
L9716:  .byte   $63                             ; 9716 63                       c
        .byte   $64                             ; 9717 64                       d
        brk                                     ; 9718 00                       .
        adc     $63                             ; 9719 65 63                    ec
        .byte   $64                             ; 971B 64                       d
        adc     $66                             ; 971C 65 66                    ef
        adc     $66                             ; 971E 65 66                    ef
        .byte   $07                             ; 9720 07                       .
        .byte   $67                             ; 9721 67                       g
        .byte   $63                             ; 9722 63                       c
        .byte   $64                             ; 9723 64                       d
        adc     ($62,x)                         ; 9724 61 62                    ab
        adc     ($62,x)                         ; 9726 61 62                    ab
        brk                                     ; 9728 00                       .
        eor     $63                             ; 9729 45 63                    Ec
        .byte   $64                             ; 972B 64                       d
        .byte   $63                             ; 972C 63                       c
        .byte   $64                             ; 972D 64                       d
        .byte   $63                             ; 972E 63                       c
        .byte   $64                             ; 972F 64                       d
        brk                                     ; 9730 00                       .
        .byte   $1F                             ; 9731 1F                       .
        jsr     L5021                           ; 9732 20 21 50                  !P
        .byte   $27                             ; 9735 27                       '
        pla                                     ; 9736 68                       h
        .byte   $64                             ; 9737 64                       d
        brk                                     ; 9738 00                       .
        .byte   $23                             ; 9739 23                       #
        .byte   $23                             ; 973A 23                       #
        .byte   $23                             ; 973B 23                       #
        adc     #$69                            ; 973C 69 69                    ii
        ror     a                               ; 973E 6A                       j
        .byte   $52                             ; 973F 52                       R
        .byte   $67                             ; 9740 67                       g
        bit     $5E                             ; 9741 24 5E                    $^
        lsr     a:L0001,x                       ; 9743 5E 01 00                 ^..
        ora     $6101,x                         ; 9746 1D 01 61                 ..a
        .byte   $6B                             ; 9749 6B                       k
        .byte   $22                             ; 974A 22                       "
        jmp     (L0001)                         ; 974B 6C 01 00                 l..

; ----------------------------------------------------------------------------
        ora     $6301,x                         ; 974E 1D 01 63                 ..c
        adc     $226B                           ; 9751 6D 6B 22                 mk"
        ora     (L0000,x)                       ; 9754 01 00                    ..
        ora     $6528,x                         ; 9756 1D 28 65                 .(e
        .byte   $63                             ; 9759 63                       c
        adc     $286B                           ; 975A 6D 6B 28                 mk(
        ora     $6E                             ; 975D 05 6E                    .n
        plp                                     ; 975F 28                       (
        eor     $63                             ; 9760 45 63                    Ec
        .byte   $63                             ; 9762 63                       c
        adc     $6161                           ; 9763 6D 61 61                 maa
        adc     (L0001,x)                       ; 9766 61 01                    a.
        .byte   $6F                             ; 9768 6F                       o
        .byte   $67                             ; 9769 67                       g
        bvs     L97DC                           ; 976A 70 70                    pp
        bvs     L97DE                           ; 976C 70 70                    pp
        bvs     L9771                           ; 976E 70 01                    p.
        .byte   $5E                             ; 9770 5E                       ^
L9771:  lsr     $1E1E,x                         ; 9771 5E 1E 1E                 ^..
        adc     ($72),y                         ; 9774 71 72                    qr
        jmp     (L6F01)                         ; 9776 6C 01 6F                 l.o

; ----------------------------------------------------------------------------
        .byte   $67                             ; 9779 67                       g
        asl     $6F1E,x                         ; 977A 1E 1E 6F                 ..o
        .byte   $67                             ; 977D 67                       g
        and     (L0001),y                       ; 977E 31 01                    1.
        ora     $31                             ; 9780 05 31                    .1
        lsr     $045E,x                         ; 9782 5E 5E 04                 ^^.
        .byte   $02                             ; 9785 02                       .
        lsr     $055E,x                         ; 9786 5E 5E 05                 ^^.
        .byte   $73                             ; 9789 73                       s
        .byte   $62                             ; 978A 62                       b
        adc     ($61,x)                         ; 978B 61 61                    aa
        .byte   $62                             ; 978D 62                       b
        adc     ($61,x)                         ; 978E 61 61                    aa
        brk                                     ; 9790 00                       .
        adc     ($64,x)                         ; 9791 61 64                    ad
        .byte   $63                             ; 9793 63                       c
        .byte   $74                             ; 9794 74                       t
        ror     $74                             ; 9795 66 74                    ft
        .byte   $74                             ; 9797 74                       t
        brk                                     ; 9798 00                       .
        .byte   $63                             ; 9799 63                       c
        ror     $65                             ; 979A 66 65                    fe
        adc     $75,x                           ; 979C 75 75                    uu
        adc     $75,x                           ; 979E 75 75                    uu
        ora     $63                             ; 97A0 05 63                    .c
        .byte   $62                             ; 97A2 62                       b
        .byte   $73                             ; 97A3 73                       s
        adc     $04,x                           ; 97A4 75 04                    u.
        .byte   $02                             ; 97A6 02                       .
        .byte   $23                             ; 97A7 23                       #
        ora     $63                             ; 97A8 05 63                    .c
        .byte   $64                             ; 97AA 64                       d
        adc     ($61,x)                         ; 97AB 61 61                    aa
        .byte   $62                             ; 97AD 62                       b
        adc     ($76,x)                         ; 97AE 61 76                    av
        jsr     L1F21                           ; 97B0 20 21 1F                  !.
        jsr     L7776                           ; 97B3 20 76 77                  vw
        bvs     L97B9                           ; 97B6 70 01                    p.
        .byte   $23                             ; 97B8 23                       #
L97B9:  .byte   $22                             ; 97B9 22                       "
        .byte   $22                             ; 97BA 22                       "
        adc     #$01                            ; 97BB 69 01                    i.
        brk                                     ; 97BD 00                       .
        .byte   $52                             ; 97BE 52                       R
        ora     ($04,x)                         ; 97BF 01 04                    ..
        .byte   $02                             ; 97C1 02                       .
        lsr     $5E5E,x                         ; 97C2 5E 5E 5E                 ^^^
        adc     $31,x                           ; 97C5 75 31                    u1
        ora     ($62,x)                         ; 97C7 01 62                    .b
        adc     ($61,x)                         ; 97C9 61 61                    aa
        adc     ($78,x)                         ; 97CB 61 78                    ax
        adc     $764A,y                         ; 97CD 79 4A 76                 yJv
        ror     $74                             ; 97D0 66 74                    ft
        .byte   $74                             ; 97D2 74                       t
        adc     $7A                             ; 97D3 65 7A                    ez
        .byte   $7B                             ; 97D5 7B                       {
        .byte   $7C                             ; 97D6 7C                       |
        ror     L0027,x                         ; 97D7 76 27                    v'
        adc     $75,x                           ; 97D9 75 75                    uu
        .byte   $7D                             ; 97DB 7D                       }
L97DC:  .byte   $7E                             ; 97DC 7E                       ~
        .byte   $7F                             ; 97DD 7F                       .
L97DE:  .byte   $80                             ; 97DE 80                       .
        sta     ($31,x)                         ; 97DF 81 31                    .1
        .byte   $82                             ; 97E1 82                       .
        .byte   $83                             ; 97E2 83                       .
        .byte   $22                             ; 97E3 22                       "
        sty     $85                             ; 97E4 84 85                    ..
        stx     L0025                           ; 97E6 86 25                    .%
        .byte   $77                             ; 97E8 77                       w
        .byte   $23                             ; 97E9 23                       #
        .byte   $23                             ; 97EA 23                       #
        adc     L8887,x                         ; 97EB 7D 87 88                 }..
        .byte   $89                             ; 97EE 89                       .
        and     #$00                            ; 97EF 29 00                    ).
        .byte   $82                             ; 97F1 82                       .
        .byte   $83                             ; 97F2 83                       .
        .byte   $22                             ; 97F3 22                       "
        .byte   $87                             ; 97F4 87                       .
        dey                                     ; 97F5 88                       .
        .byte   $89                             ; 97F6 89                       .
        and     #$00                            ; 97F7 29 00                    ).
L97F9:  .byte   $23                             ; 97F9 23                       #
        .byte   $23                             ; 97FA 23                       #
        adc     L8887,x                         ; 97FB 7D 87 88                 }..
        .byte   $89                             ; 97FE 89                       .
        and     #$00                            ; 97FF 29 00                    ).
L9801:  .byte   $03                             ; 9801 03                       .
        .byte   $03                             ; 9802 03                       .
        txa                                     ; 9803 8A                       .
        .byte   $8B                             ; 9804 8B                       .
        .byte   $8C                             ; 9805 8C                       .
        .byte   $86                             ; 9806 86                       .
L9807:  and     L0000                           ; 9807 25 00                    %.
        asl     $1E1E,x                         ; 9809 1E 1E 1E                 ...
        asl     L868C,x                         ; 980C 1E 8C 86                 ...
        and     $05                             ; 980F 25 05                    %.
        asl     $0E,x                           ; 9811 16 0E                    ..
        .byte   $0F                             ; 9813 0F                       .
        .byte   $17                             ; 9814 17                       .
        sta     $2586                           ; 9815 8D 86 25                 ..%
        ora     L0016                           ; 9818 05 16                    ..
        .byte   $0F                             ; 981A 0F                       .
        asl     L8D0F                           ; 981B 0E 0F 8D                 ...
        stx     L0025                           ; 981E 86 25                    .%
        brk                                     ; 9820 00                       .
        asl     $1E1E,x                         ; 9821 1E 1E 1E                 ...
        asl     L8988,x                         ; 9824 1E 88 89                 ...
        .byte   $29                             ; 9827 29                       )
L9828:  brk                                     ; 9828 00                       .
        asl     $0E,x                           ; 9829 16 0E                    ..
        .byte   $0F                             ; 982B 0F                       .
        .byte   $17                             ; 982C 17                       .
        sta     $2586                           ; 982D 8D 86 25                 ..%
        brk                                     ; 9830 00                       .
        asl     $0F,x                           ; 9831 16 0F                    ..
        asl     L8D0F                           ; 9833 0E 0F 8D                 ...
        stx     L0025                           ; 9836 86 25                    .%
        brk                                     ; 9838 00                       .
        asl     $1E1E,x                         ; 9839 1E 1E 1E                 ...
        asl     L868C,x                         ; 983C 1E 8C 86                 ...
        and     $05                             ; 983F 25 05                    %.
        asl     $1E1E,x                         ; 9841 1E 1E 1E                 ...
        asl     L8988,x                         ; 9844 1E 88 89                 ...
        and     #$00                            ; 9847 29 00                    ).
        rol     $36,x                           ; 9849 36 36                    66
        rol     $36,x                           ; 984B 36 36                    66
        rol     $8E,x                           ; 984D 36 8E                    6.
        .byte   $8F                             ; 984F 8F                       .
        brk                                     ; 9850 00                       .
        .byte   $3C                             ; 9851 3C                       <
        .byte   $3C                             ; 9852 3C                       <
        .byte   $3C                             ; 9853 3C                       <
        .byte   $3C                             ; 9854 3C                       <
        .byte   $3C                             ; 9855 3C                       <
        bcc     L986C                           ; 9856 90 14                    ..
        brk                                     ; 9858 00                       .
        .byte   $3C                             ; 9859 3C                       <
        .byte   $3C                             ; 985A 3C                       <
        .byte   $3C                             ; 985B 3C                       <
        .byte   $3C                             ; 985C 3C                       <
        .byte   $3C                             ; 985D 3C                       <
        bcc     L987A                           ; 985E 90 1A                    ..
        brk                                     ; 9860 00                       .
        .byte   $3C                             ; 9861 3C                       <
        .byte   $3C                             ; 9862 3C                       <
        .byte   $3C                             ; 9863 3C                       <
        .byte   $3C                             ; 9864 3C                       <
        .byte   $3C                             ; 9865 3C                       <
        bcc     L97F9                           ; 9866 90 91                    ..
        ora     $3C                             ; 9868 05 3C                    .<
        .byte   $3C                             ; 986A 3C                       <
        .byte   $3C                             ; 986B 3C                       <
L986C:  .byte   $3C                             ; 986C 3C                       <
        .byte   $3C                             ; 986D 3C                       <
        bcc     L9801                           ; 986E 90 91                    ..
        ora     $92                             ; 9870 05 92                    ..
        .byte   $92                             ; 9872 92                       .
        .byte   $72                             ; 9873 72                       r
        .byte   $2F                             ; 9874 2F                       /
        .byte   $0D                             ; 9875 0D                       .
L9876:  .byte   $2F                             ; 9876 2F                       /
        ora     $4F05                           ; 9877 0D 05 4F                 ..O
L987A:  .byte   $4F                             ; 987A 4F                       O
        .byte   $93                             ; 987B 93                       .
        bmi     L9893                           ; 987C 30 15                    0.
        bmi     L9895                           ; 987E 30 15                    0.
        ora     $5E                             ; 9880 05 5E                    .^
        lsr     L9394,x                         ; 9882 5E 94 93                 ^..
        sty     $93,x                           ; 9885 94 93                    ..
        sty     $8E,x                           ; 9887 94 8E                    ..
        sta     $95,x                           ; 9889 95 95                    ..
L988B:  txa                                     ; 988B 8A                       .
        txa                                     ; 988C 8A                       .
        txa                                     ; 988D 8A                       .
        txa                                     ; 988E 8A                       .
        txa                                     ; 988F 8A                       .
        bcc     L9828                           ; 9890 90 96                    ..
        .byte   $3C                             ; 9892 3C                       <
L9893:  sta     $95,x                           ; 9893 95 95                    ..
L9895:  sta     $95,x                           ; 9895 95 95                    ..
        .byte   $97                             ; 9897 97                       .
        bcc     L98D6                           ; 9898 90 3C                    .<
        .byte   $3C                             ; 989A 3C                       <
        ror     $98,x                           ; 989B 76 98                    v.
        sta     L9A3C,y                         ; 989D 99 3C 9A                 .<.
        bcc     L98DE                           ; 98A0 90 3C                    .<
        and     L9876,x                         ; 98A2 3D 76 98                 =v.
        sta     L9C9B,y                         ; 98A5 99 9B 9C                 ...
        bcc     L98E7                           ; 98A8 90 3D                    .=
        .byte   $93                             ; 98AA 93                       .
        ror     $98,x                           ; 98AB 76 98                    v.
        sta     L9C9B,y                         ; 98AD 99 9B 9C                 ...
        jsr     L271F                           ; 98B0 20 1F 27                  .'
        ror     $98,x                           ; 98B3 76 98                    v.
        sta     L9C9B,y                         ; 98B5 99 9B 9C                 ...
        .byte   $23                             ; 98B8 23                       #
        bit     $31                             ; 98B9 24 31                    $1
        ror     $98,x                           ; 98BB 76 98                    v.
        sta     L9C9B,y                         ; 98BD 99 9B 9C                 ...
        .byte   $33                             ; 98C0 33                       3
        .byte   $02                             ; 98C1 02                       .
        .byte   $27                             ; 98C2 27                       '
        plp                                     ; 98C3 28                       (
        .byte   $89                             ; 98C4 89                       .
        sta     L9C9B,x                         ; 98C5 9D 9B 9C                 ...
        .byte   $77                             ; 98C8 77                       w
        sta     $95,x                           ; 98C9 95 95                    ..
        sta     $95,x                           ; 98CB 95 95                    ..
        .byte   $9E                             ; 98CD 9E                       .
        .byte   $9B                             ; 98CE 9B                       .
        .byte   $9C                             ; 98CF 9C                       .
        .byte   $77                             ; 98D0 77                       w
        .byte   $3C                             ; 98D1 3C                       <
        .byte   $3C                             ; 98D2 3C                       <
        .byte   $9F                             ; 98D3 9F                       .
        ldy     #$A1                            ; 98D4 A0 A1                    ..
L98D6:  ldx     #$A1                            ; 98D6 A2 A1                    ..
        brk                                     ; 98D8 00                       .
        .byte   $3C                             ; 98D9 3C                       <
        .byte   $3C                             ; 98DA 3C                       <
        stx     $90,y                           ; 98DB 96 90                    ..
        .byte   $A3                             ; 98DD A3                       .
L98DE:  ldy     $A3                             ; 98DE A4 A3                    ..
        ror     $77,x                           ; 98E0 76 77                    vw
        .byte   $3C                             ; 98E2 3C                       <
        .byte   $3C                             ; 98E3 3C                       <
        bcc     L988B                           ; 98E4 90 A5                    ..
        .byte   $A4                             ; 98E6 A4                       .
L98E7:  lda     $06                             ; 98E7 A5 06                    ..
        .byte   $07                             ; 98E9 07                       .
        .byte   $3C                             ; 98EA 3C                       <
        .byte   $3C                             ; 98EB 3C                       <
        bit     $A6                             ; 98EC 24 A6                    $.
        .byte   $A7                             ; 98EE A7                       .
        ldx     $A8                             ; 98EF A6 A8                    ..
        brk                                     ; 98F1 00                       .
        .byte   $92                             ; 98F2 92                       .
        ror     $77,x                           ; 98F3 76 77                    vw
        and     (L0020,x)                       ; 98F5 21 20                    ! 
        .byte   $1F                             ; 98F7 1F                       .
        tay                                     ; 98F8 A8                       .
        brk                                     ; 98F9 00                       .
        .byte   $4F                             ; 98FA 4F                       O
        ora     (L0000,x)                       ; 98FB 01 00                    ..
        .byte   $24                             ; 98FD 24                       $
L98FE:  .byte   $23                             ; 98FE 23                       #
        bit     $94                             ; 98FF 24 94                    $.
        lda     #$AA                            ; 9901 A9 AA                    ..
        lda     #$94                            ; 9903 A9 94                    ..
L9905:  lda     #$AA                            ; 9905 A9 AA                    ..
L9907:  lda     #$7D                            ; 9907 A9 7D                    .}
        .byte   $AB                             ; 9909 AB                       .
        .byte   $AB                             ; 990A AB                       .
        .byte   $AB                             ; 990B AB                       .
        adc     $ABAB,x                         ; 990C 7D AB AB                 }..
        .byte   $AB                             ; 990F AB                       .
L9910:  lda     ($A1,x)                         ; 9910 A1 A1                    ..
        ldx     #$A1                            ; 9912 A2 A1                    ..
L9914:  lda     ($A1,x)                         ; 9914 A1 A1                    ..
        ldx     #$A1                            ; 9916 A2 A1                    ..
        asl     $A4AC,x                         ; 9918 1E AC A4                 ...
        asl     $AC1E,x                         ; 991B 1E 1E AC                 ...
        ldy     $1E                             ; 991E A4 1E                    ..
        lda     $AD                             ; 9920 A5 AD                    ..
L9922:  ldy     $1E                             ; 9922 A4 1E                    ..
        asl     $A4AD,x                         ; 9924 1E AD A4                 ...
        lda     $A6                             ; 9927 A5 A6                    ..
        .byte   $A6                             ; 9929 A6                       .
L992A:  .byte   $A7                             ; 992A A7                       .
        ldx     $AEAE                           ; 992B AE AE AE                 ...
        .byte   $A7                             ; 992E A7                       .
        .byte   $A6                             ; 992F A6                       .
L9930:  .byte   $27                             ; 9930 27                       '
        .byte   $21                             ; 9931 21                       !
L9932:  jsr     L271F                           ; 9932 20 1F 27                  .'
        and     (L0020,x)                       ; 9935 21 20                    ! 
        and     ($69,x)                         ; 9937 21 69                    !i
        bit     L0023                           ; 9939 24 23                    $#
        bit     $69                             ; 993B 24 69                    $i
        bit     L0023                           ; 993D 24 23                    $#
        bit     $94                             ; 993F 24 94                    $.
        lsr     $045E,x                         ; 9941 5E 5E 04                 ^^.
        .byte   $02                             ; 9944 02                       .
        lsr     $045E,x                         ; 9945 5E 5E 04                 ^^.
        adc     L958E,x                         ; 9948 7D 8E 95                 }..
        sta     $8E,x                           ; 994B 95 8E                    ..
        sta     $95,x                           ; 994D 95 95                    ..
        stx     L90A1                           ; 994F 8E A1 90                 ...
        .byte   $AF                             ; 9952 AF                       .
        .byte   $AF                             ; 9953 AF                       .
        bcc     L9905                           ; 9954 90 AF                    ..
        .byte   $AF                             ; 9956 AF                       .
L9957:  bcc     L98FE                           ; 9957 90 A5                    ..
L9959:  bcc     L9907                           ; 9959 90 AC                    ..
        ldy     $AC90                           ; 995B AC 90 AC                 ...
        asl     $A590,x                         ; 995E 1E 90 A5                 ...
        bcc     L9910                           ; 9961 90 AD                    ..
L9963:  lda     $90                             ; 9963 A5 90                    ..
        .byte   $A3                             ; 9965 A3                       .
        lda     $90                             ; 9966 A5 90                    ..
L9968:  ldx     $B0                             ; 9968 A6 B0                    ..
        ldx     $A6                             ; 996A A6 A6                    ..
L996C:  bcs     L9914                           ; 996C B0 A6                    ..
        ldx     $B0                             ; 996E A6 B0                    ..
        .byte   $20                             ; 9970 20                        
        .byte   $1F                             ; 9971 1F                       .
L9972:  .byte   $27                             ; 9972 27                       '
        and     (L0020,x)                       ; 9973 21 20                    ! 
        .byte   $1F                             ; 9975 1F                       .
        .byte   $27                             ; 9976 27                       '
        and     (L0023,x)                       ; 9977 21 23                    !#
        bit     $69                             ; 9979 24 69                    $i
        bit     L0023                           ; 997B 24 23                    $#
        bit     $69                             ; 997D 24 69                    $i
        bit     $02                             ; 997F 24 02                    $.
        lsr     $045E,x                         ; 9981 5E 5E 04                 ^^.
        .byte   $02                             ; 9984 02                       .
        sty     $5E,x                           ; 9985 94 5E                    .^
        lsr     L8E8E,x                         ; 9987 5E 8E 8E                 ^..
        sta     $8E,x                           ; 998A 95 8E                    ..
        sec                                     ; 998C 38                       8
L998D:  txa                                     ; 998D 8A                       .
        .byte   $B1                             ; 998E B1                       .
L998F:  .byte   $6F                             ; 998F 6F                       o
        bcc     L9922                           ; 9990 90 90                    ..
        stx     $90,y                           ; 9992 96 90                    ..
        .byte   $B2                             ; 9994 B2                       .
        and     L8E8E,y                         ; 9995 39 8E 8E                 9..
        bcc     L992A                           ; 9998 90 90                    ..
L999A:  .byte   $3C                             ; 999A 3C                       <
        bcc     L99DC                           ; 999B 90 3F                    .?
        rti                                     ; 999D 40                       @

; ----------------------------------------------------------------------------
        .byte   $90                             ; 999E 90                       .
L999F:  .byte   $90,$90                    ; 999F 90 90   (branch out of range for ca65: target has no local label)
        .byte   $90,$3C                    ; 99A1 90 3C   (branch out of range for ca65: target has no local label)
        bcc     L9957                           ; 99A3 90 B2                    ..
        lsr     $90,x                           ; 99A5 56 90                    V.
        bcc     L9959                           ; 99A7 90 B0                    ..
        bcs     L99CF                           ; 99A9 B0 24                    .$
        bcc     L99EC                           ; 99AB 90 3F                    .?
        rti                                     ; 99AD 40                       @

; ----------------------------------------------------------------------------
        bcc     L9963                           ; 99AE 90 B3                    ..
        jsr     L271F                           ; 99B0 20 1F 27                  .'
        .byte   $72                             ; 99B3 72                       r
        .byte   $B2                             ; 99B4 B2                       .
        lsr     $44,x                           ; 99B5 56 44                    VD
        eor     L0023                           ; 99B7 45 23                    E#
        bit     $69                             ; 99B9 24 69                    $i
        .byte   $93                             ; 99BB 93                       .
        .byte   $3F                             ; 99BC 3F                       ?
        rti                                     ; 99BD 40                       @

; ----------------------------------------------------------------------------
        asl     $5E45,x                         ; 99BE 1E 45 5E                 .E^
        .byte   $22                             ; 99C1 22                       "
        ldy     $67,x                           ; 99C2 B4 67                    .g
        .byte   $3A                             ; 99C4 3A                       :
        lda     $94,x                           ; 99C5 B5 94                    ..
        lsr     L9467,x                         ; 99C7 5E 67 94                 ^g.
        .byte   $93                             ; 99CA 93                       .
        stx     $B642                           ; 99CB 8E 42 B6                 .B.
        .byte   $B7                             ; 99CE B7                       .
L99CF:  clv                                     ; 99CF B8                       .
        stx     $B98A                           ; 99D0 8E 8A B9                 ...
        bcc     L998F                           ; 99D3 90 BA                    ..
L99D5:  .byte   $BB                             ; 99D5 BB                       .
        bcc     L99F6                           ; 99D6 90 1E                    ..
        bcc     L9968                           ; 99D8 90 8E                    ..
        bcc     L996C                           ; 99DA 90 90                    ..
L99DC:  .byte   $42                             ; 99DC 42                       B
        .byte   $43                             ; 99DD 43                       C
        bcc     L99FE                           ; 99DE 90 1E                    ..
        bcc     L9972                           ; 99E0 90 90                    ..
        .byte   $B3                             ; 99E2 B3                       .
        bcc     L999F                           ; 99E3 90 BA                    ..
        .byte   $BB                             ; 99E5 BB                       .
        bcc     L998D                           ; 99E6 90 A5                    ..
        bcs     L999A                           ; 99E8 B0 B0                    ..
L99EA:  eor     $90                             ; 99EA 45 90                    E.
L99EC:  .byte   $42                             ; 99EC 42                       B
        ldy     $A6B3,x                         ; 99ED BC B3 A6                 ...
        .byte   $2F                             ; 99F0 2F                       /
        ora     $4445                           ; 99F1 0D 45 44                 .ED
        tsx                                     ; 99F4 BA                       .
        .byte   $BD                             ; 99F5 BD                       .
L99F6:  eor     $2F                             ; 99F6 45 2F                    E/
        bmi     L9A0F                           ; 99F8 30 15                    0.
        eor     $1E                             ; 99FA 45 1E                    E.
        .byte   $42                             ; 99FC 42                       B
        .byte   $43                             ; 99FD 43                       C
L99FE:  eor     $30                             ; 99FE 45 30                    E0
        lsr     $235E,x                         ; 9A00 5E 5E 23                 ^^#
        and     ($6F),y                         ; 9A03 31 6F                    1o
        .byte   $67                             ; 9A05 67                       g
        .byte   $73                             ; 9A06 73                       s
        lsr     $A0A1,x                         ; 9A07 5E A1 A0                 ^..
        ldx     L9467,y                         ; 9A0A BE 67 94                 .g.
        .byte   $7D                             ; 9A0D 7D                       }
        .byte   $3B                             ; 9A0E 3B                       ;
L9A0F:  stx     L901E                           ; 9A0F 8E 1E 90                 ...
        .byte   $B2                             ; 9A12 B2                       .
        .byte   $BF                             ; 9A13 BF                       .
        .byte   $B7                             ; 9A14 B7                       .
L9A15:  cpy     #$43                            ; 9A15 C0 43                    .C
        bcc     L9A37                           ; 9A17 90 1E                    ..
        bcc     L9A5A                           ; 9A19 90 3F                    .?
        cmp     ($90,x)                         ; 9A1B C1 90                    ..
        .byte   $C2                             ; 9A1D C2                       .
        .byte   $BB                             ; 9A1E BB                       .
        bcc     L9A3F                           ; 9A1F 90 1E                    ..
        bcc     L99D5                           ; 9A21 90 B2                    ..
        .byte   $C3                             ; 9A23 C3                       .
        bcc     L99EA                           ; 9A24 90 C4                    ..
        .byte   $43                             ; 9A26 43                       C
        bcc     L99CF                           ; 9A27 90 A6                    ..
        .byte   $B3                             ; 9A29 B3                       .
        .byte   $3F                             ; 9A2A 3F                       ?
        cmp     ($90,x)                         ; 9A2B C1 90                    ..
        .byte   $72                             ; 9A2D 72                       r
        ror     $77,x                           ; 9A2E 76 77                    vw
        ora     $2F45                           ; 9A30 0D 45 2F                 .E/
        .byte   $0D                             ; 9A33 0D                       .
L9A34:  .byte   $6F                             ; 9A34 6F                       o
        .byte   $67                             ; 9A35 67                       g
        .byte   $06                             ; 9A36 06                       .
L9A37:  .byte   $07                             ; 9A37 07                       .
        ora     $45,x                           ; 9A38 15 45                    .E
        bmi     L9A51                           ; 9A3A 30 15                    0.
L9A3C:  .byte   $23                             ; 9A3C 23                       #
        adc     #$01                            ; 9A3D 69 01                    i.
L9A3F:  brk                                     ; 9A3F 00                       .
        lsr     $5E5E,x                         ; 9A40 5E 5E 5E                 ^^^
        .byte   $5E                             ; 9A43 5E                       ^
L9A44:  sty     $69,x                           ; 9A44 94 69                    .i
        cmp     L0001                           ; 9A46 C5 01                    ..
        asl     $6F8E,x                         ; 9A48 1E 8E 6F                 ..o
        .byte   $67                             ; 9A4B 67                       g
        txa                                     ; 9A4C 8A                       .
        .byte   $22                             ; 9A4D 22                       "
        dec     L0001                           ; 9A4E C6 01                    ..
        .byte   $1E                             ; 9A50 1E                       .
L9A51:  bcc     L9A8B                           ; 9A51 90 38                    .8
        and     $2B1E,y                         ; 9A53 39 1E 2B                 9.+
        php                                     ; 9A56 08                       .
        ora     ($A3,x)                         ; 9A57 01 A3                    ..
        .byte   $90                             ; 9A59 90                       .
L9A5A:  .byte   $3F                             ; 9A5A 3F                       ?
        .byte   $C7                             ; 9A5B C7                       .
        rol     $102C                           ; 9A5C 2E 2C 10                 .,.
        ora     ($A5,x)                         ; 9A5F 01 A5                    ..
        bcc     L9A15                           ; 9A61 90 B2                    ..
        and     $1EC8,y                         ; 9A63 39 C8 1E                 9..
        asl     $7201,x                         ; 9A66 1E 01 72                 ..r
        bcs     L9A34                           ; 9A69 B0 C9                    ..
        rti                                     ; 9A6B 40                       @

; ----------------------------------------------------------------------------
        lda     $1E                             ; 9A6C A5 1E                    ..
        rol     L6F01                           ; 9A6E 2E 01 6F                 ..o
        lsr     a                               ; 9A71 4A                       J
        .byte   $67                             ; 9A72 67                       g
        dex                                     ; 9A73 CA                       .
        .byte   $CB                             ; 9A74 CB                       .
        .byte   $22                             ; 9A75 22                       "
        adc     #$01                            ; 9A76 69 01                    i.
        .byte   $23                             ; 9A78 23                       #
        .byte   $23                             ; 9A79 23                       #
        adc     #$6F                            ; 9A7A 69 6F                    io
        .byte   $67                             ; 9A7C 67                       g
        .byte   $23                             ; 9A7D 23                       #
        adc     #$01                            ; 9A7E 69 01                    i.
        ora     $1E,x                           ; 9A80 15 1E                    ..
L9A82:  cpy     $CD94                           ; 9A82 CC 94 CD                 ...
        sty     $93,x                           ; 9A85 94 93                    ..
        ror     $1B,x                           ; 9A87 76 1B                    v.
        .byte   $1E                             ; 9A89 1E                       .
        .byte   $CE                             ; 9A8A CE                       .
L9A8B:  .byte   $CF                             ; 9A8B CF                       .
        asl     $D0CF,x                         ; 9A8C 1E CF D0                 ...
        ora     ($0D,x)                         ; 9A8F 01 0D                    ..
        asl     $0E,x                           ; 9A91 16 0E                    ..
        asl     $170F                           ; 9A93 0E 0F 17                 ...
        .byte   $1C                             ; 9A96 1C                       .
        ora     (L0015,x)                       ; 9A97 01 15                    ..
        asl     $0E16,x                         ; 9A99 1E 16 0E                 ...
        asl     $170F                           ; 9A9C 0E 0F 17                 ...
        ora     ($1B,x)                         ; 9A9F 01 1B                    ..
        asl     $1E1E,x                         ; 9AA1 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9AA4 1E 1E 1E                 ...
        ora     ($D1,x)                         ; 9AA7 01 D1                    ..
        ora     $0D2F                           ; 9AA9 0D 2F 0D                 ./.
        .byte   $72                             ; 9AAC 72                       r
        asl     $01D2,x                         ; 9AAD 1E D2 01                 ...
        bmi     L9AC7                           ; 9AB0 30 15                    0.
        bmi     L9AC9                           ; 9AB2 30 15                    0.
        .byte   $27                             ; 9AB4 27                       '
        jmp     (L01D3)                         ; 9AB5 6C D3 01                 l..

; ----------------------------------------------------------------------------
        .byte   $32                             ; 9AB8 32                       2
        .byte   $1B                             ; 9AB9 1B                       .
        .byte   $32                             ; 9ABA 32                       2
        .byte   $1B                             ; 9ABB 1B                       .
        .byte   $93                             ; 9ABC 93                       .
        adc     #$C5                            ; 9ABD 69 C5                    i.
        ora     (L0000,x)                       ; 9ABF 01 00                    ..
        .byte   $D4                             ; 9AC1 D4                       .
        cmp     $94,x                           ; 9AC2 D5 94                    ..
        dec     $69,x                           ; 9AC4 D6 69                    .i
        .byte   $23                             ; 9AC6 23                       #
L9AC7:  adc     #$00                            ; 9AC7 69 00                    i.
L9AC9:  .byte   $D7                             ; 9AC9 D7                       .
        cld                                     ; 9ACA D8                       .
        txa                                     ; 9ACB 8A                       .
        .byte   $6F                             ; 9ACC 6F                       o
        .byte   $67                             ; 9ACD 67                       g
        .byte   $23                             ; 9ACE 23                       #
        adc     #$00                            ; 9ACF 69 00                    i.
        sta     $95,x                           ; 9AD1 95 95                    ..
        sta     $D9,x                           ; 9AD3 95 D9                    ..
        adc     $6F,x                           ; 9AD5 75 6F                    uo
        .byte   $67                             ; 9AD7 67                       g
        brk                                     ; 9AD8 00                       .
        .byte   $3C                             ; 9AD9 3C                       <
        .byte   $3C                             ; 9ADA 3C                       <
        stx     $DA,y                           ; 9ADB 96 DA                    ..
        .byte   $DB                             ; 9ADD DB                       .
        txa                                     ; 9ADE 8A                       .
        sty     L0000,x                         ; 9ADF 94 00                    ..
        .byte   $3C                             ; 9AE1 3C                       <
        .byte   $3C                             ; 9AE2 3C                       <
        .byte   $3C                             ; 9AE3 3C                       <
        .byte   $DC                             ; 9AE4 DC                       .
        .byte   $DD                             ; 9AE5 DD                       .
L9AE6:  dec     a:$DF,x                         ; 9AE6 DE DF 00                 ...
        rol     $36,x                           ; 9AE9 36 36                    66
        rol     $E0,x                           ; 9AEB 36 E0                    6.
        sbc     ($E2,x)                         ; 9AED E1 E2                    ..
        .byte   $E3                             ; 9AEF E3                       .
        brk                                     ; 9AF0 00                       .
        asl     $1FCC,x                         ; 9AF1 1E CC 1F                 ...
        jsr     L1F21                           ; 9AF4 20 21 1F                  !.
        jsr     L1E0D                           ; 9AF7 20 0D 1E                  ..
        cpy     $676F                           ; 9AFA CC 6F 67                 .og
        .byte   $22                             ; 9AFD 22                       "
        .byte   $22                             ; 9AFE 22                       "
        cpx     L0023                           ; 9AFF E4 23                    .#
        adc     #$23                            ; 9B01 69 23                    i#
        adc     #$23                            ; 9B03 69 23                    i#
        adc     #$23                            ; 9B05 69 23                    i#
        adc     #$23                            ; 9B07 69 23                    i#
        adc     #$23                            ; 9B09 69 23                    i#
        adc     #$23                            ; 9B0B 69 23                    i#
        adc     #$23                            ; 9B0D 69 23                    i#
        adc     #$93                            ; 9B0F 69 93                    i.
        .byte   $67                             ; 9B11 67                       g
        .byte   $93                             ; 9B12 93                       .
        .byte   $67                             ; 9B13 67                       g
        .byte   $93                             ; 9B14 93                       .
L9B15:  .byte   $67                             ; 9B15 67                       g
        .byte   $93                             ; 9B16 93                       .
        .byte   $67                             ; 9B17 67                       g
        adc     $7D94,x                         ; 9B18 7D 94 7D                 }.}
        sty     $7D,x                           ; 9B1B 94 7D                    .}
        sty     $7D,x                           ; 9B1D 94 7D                    .}
        sty     $E5,x                           ; 9B1F 94 E5                    ..
        sbc     $E5                             ; 9B21 E5 E5                    ..
        .byte   $B7                             ; 9B23 B7                       .
        inc     $E7                             ; 9B24 E6 E7                    ..
        .byte   $B7                             ; 9B26 B7                       .
        .byte   $DF                             ; 9B27 DF                       .
        .byte   $3C                             ; 9B28 3C                       <
        .byte   $3C                             ; 9B29 3C                       <
        .byte   $3C                             ; 9B2A 3C                       <
        bcc     L9B15                           ; 9B2B 90 E8                    ..
        cmp     ($90,x)                         ; 9B2D C1 90                    ..
        .byte   $E3                             ; 9B2F E3                       .
        and     ($1F,x)                         ; 9B30 21 1F                    !.
        jsr     L1F21                           ; 9B32 20 21 1F                  !.
        jsr     L1F21                           ; 9B35 20 21 1F                  !.
        cpx     $E4                             ; 9B38 E4 E4                    ..
        cpx     $E4                             ; 9B3A E4 E4                    ..
        cpx     $E4                             ; 9B3C E4 E4                    ..
        cpx     $E4                             ; 9B3E E4 E4                    ..
        .byte   $6F                             ; 9B40 6F                       o
        .byte   $67                             ; 9B41 67                       g
        .byte   $6F                             ; 9B42 6F                       o
        .byte   $67                             ; 9B43 67                       g
L9B44:  .byte   $6F                             ; 9B44 6F                       o
        .byte   $67                             ; 9B45 67                       g
L9B46:  .byte   $6F                             ; 9B46 6F                       o
        .byte   $67                             ; 9B47 67                       g
        .byte   $E9                             ; 9B48 E9                       .
L9B49:  nop                                     ; 9B49 EA                       .
        .byte   $EB                             ; 9B4A EB                       .
        cpx     $ECEC                           ; 9B4B EC EC EC                 ...
        cpx     $EEED                           ; 9B4E EC ED EE                 ...
        .byte   $EF                             ; 9B51 EF                       .
        beq     L9B44                           ; 9B52 F0 F0                    ..
        beq     L9B46                           ; 9B54 F0 F0                    ..
        beq     L9B49                           ; 9B56 F0 F1                    ..
        .byte   $F2                             ; 9B58 F2                       .
        .byte   $F3                             ; 9B59 F3                       .
        .byte   $F3                             ; 9B5A F3                       .
        .byte   $F3                             ; 9B5B F3                       .
        .byte   $F3                             ; 9B5C F3                       .
        .byte   $F3                             ; 9B5D F3                       .
        .byte   $F3                             ; 9B5E F3                       .
        .byte   $F4                             ; 9B5F F4                       .
        sbc     $F6,x                           ; 9B60 F5 F6                    ..
        inc     $F6,x                           ; 9B62 F6 F6                    ..
        .byte   $F7                             ; 9B64 F7                       .
        sed                                     ; 9B65 F8                       .
        .byte   $F7                             ; 9B66 F7                       .
        sbc     $FBFA,y                         ; 9B67 F9 FA FB                 ...
        .byte   $FB                             ; 9B6A FB                       .
        .byte   $FB                             ; 9B6B FB                       .
        .byte   $FC                             ; 9B6C FC                       .
        .byte   $FB                             ; 9B6D FB                       .
        .byte   $FC                             ; 9B6E FC                       .
        sbc     $2120,x                         ; 9B6F FD 20 21                 . !
        .byte   $1F                             ; 9B72 1F                       .
        jsr     L1F21                           ; 9B73 20 21 1F                  !.
        jsr     LE421                           ; 9B76 20 21 E4                  !.
        cpx     $E4                             ; 9B79 E4 E4                    ..
        cpx     $E4                             ; 9B7B E4 E4                    ..
        cpx     $E4                             ; 9B7D E4 E4                    ..
        cpx     $1E                             ; 9B7F E4 1E                    ..
        asl     $1E1E,x                         ; 9B81 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9B84 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9B87 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9B8A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9B8D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9B90 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9B93 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9B96 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9B99 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9B9C 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9B9F 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BA2 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BA5 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BA8 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BAB 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BAE 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BB1 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BB4 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BB7 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BBA 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BBD 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BC0 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BC3 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BC6 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BC9 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BCC 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BCF 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BD2 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BD5 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BD8 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BDB 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BDE 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BE1 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BE4 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BE7 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BEA 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BED 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BF0 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BF3 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BF6 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BF9 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BFC 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9BFF 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C02 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C05 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C08 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C0B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C0E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C11 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C14 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C17 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C1A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C1D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C20 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C23 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C26 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C29 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C2C 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C2F 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C32 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C35 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C38 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C3B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C3E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C41 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C44 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C47 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C4A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C4D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C50 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C53 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C56 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C59 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C5C 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C5F 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C62 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C65 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C68 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C6B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C6E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C71 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C74 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C77 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C7A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C7D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C80 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C83 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C86 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C89 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C8C 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C8F 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C92 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C95 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C98 1E 1E 1E                 ...
L9C9B:  asl     $1E1E,x                         ; 9C9B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9C9E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CA1 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CA4 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CA7 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CAA 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CAD 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CB0 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CB3 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CB6 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CB9 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CBC 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CBF 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CC2 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CC5 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CC8 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CCB 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CCE 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CD1 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CD4 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CD7 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CDA 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CDD 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CE0 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CE3 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CE6 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CE9 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CEC 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CEF 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CF2 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CF5 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CF8 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CFB 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9CFE 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D01 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D04 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D07 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D0A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D0D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D10 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D13 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D16 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D19 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D1C 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D1F 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D22 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D25 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D28 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D2B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D2E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D31 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D34 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D37 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D3A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D3D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D40 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D43 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D46 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D49 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D4C 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D4F 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D52 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D55 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D58 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D5B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D5E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D61 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D64 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D67 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D6A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D6D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D70 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D73 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D76 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D79 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D7C 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D7F 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D82 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D85 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D88 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D8B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D8E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D91 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D94 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D97 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D9A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9D9D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DA0 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DA3 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DA6 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DA9 1E 1E 1E                 ...
        .byte   $1E                             ; 9DAC 1E                       .
L9DAD:  asl     $1E1E,x                         ; 9DAD 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DB0 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DB3 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DB6 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DB9 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DBC 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DBF 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DC2 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DC5 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DC8 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DCB 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DCE 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DD1 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DD4 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DD7 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DDA 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DDD 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DE0 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DE3 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DE6 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DE9 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DEC 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DEF 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DF2 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DF5 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DF8 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DFB 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9DFE 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E01 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E04 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E07 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E0A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E0D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E10 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E13 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E16 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E19 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E1C 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E1F 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E22 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E25 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E28 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E2B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E2E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E31 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E34 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E37 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E3A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E3D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E40 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E43 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E46 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E49 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E4C 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E4F 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E52 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E55 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E58 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E5B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E5E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E61 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E64 1E 1E 1E                 ...
L9E67:  asl     $1E1E,x                         ; 9E67 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E6A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E6D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E70 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E73 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E76 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E79 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E7C 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E7F 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E82 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E85 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E88 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E8B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E8E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E91 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E94 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E97 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E9A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9E9D 1E 1E 1E                 ...
        .byte   $1E                             ; 9EA0 1E                       .
        .byte   $1E                             ; 9EA1 1E                       .
L9EA2:  asl     $1E1E,x                         ; 9EA2 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EA5 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EA8 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EAB 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EAE 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EB1 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EB4 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EB7 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EBA 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EBD 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EC0 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EC3 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EC6 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EC9 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9ECC 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9ECF 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9ED2 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9ED5 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9ED8 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EDB 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EDE 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EE1 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EE4 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EE7 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EEA 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EED 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EF0 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EF3 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EF6 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EF9 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EFC 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9EFF 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F02 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F05 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F08 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F0B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F0E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F11 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F14 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F17 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F1A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F1D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F20 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F23 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F26 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F29 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F2C 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F2F 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F32 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F35 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F38 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F3B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F3E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F41 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F44 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F47 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F4A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F4D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F50 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F53 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F56 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F59 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F5C 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F5F 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F62 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F65 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F68 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F6B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F6E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F71 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F74 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F77 1E 1E 1E                 ...
        .byte   $1E                             ; 9F7A 1E                       .
L9F7B:  asl     $1E1E,x                         ; 9F7B 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F7E 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F81 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F84 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F87 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F8A 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F8D 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F90 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F93 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F96 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F99 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9F9C 1E 1E 1E                 ...
L9F9F:  asl     $1E1E,x                         ; 9F9F 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FA2 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FA5 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FA8 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FAB 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FAE 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FB1 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FB4 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FB7 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FBA 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FBD 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FC0 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FC3 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FC6 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FC9 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FCC 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FCF 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FD2 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FD5 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FD8 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FDB 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FDE 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FE1 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FE4 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FE7 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FEA 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FED 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FF0 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FF3 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FF6 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FF9 1E 1E 1E                 ...
        asl     $1E1E,x                         ; 9FFC 1E 1E 1E                 ...
L9FFF:  .byte   $1E                             ; 9FFF 1E                       .
