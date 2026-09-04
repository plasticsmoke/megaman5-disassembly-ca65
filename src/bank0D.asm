.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK0D"

; =============================================================================
; BANK $0D (mapped at $A000) — ENDGAME WILY SCENE AI + WILY 2 STAGE DATA
; =============================================================================
L0000           := $0000
L0008           := $0008
L0022           := $0022
L004E           := $004E
L0080           := $0080
L0832           := $0832
L0F00           := $0F00
L1121           := $1121
L12F1           := $12F1
L1B19           := $1B19
L2000           := $2000
L2004           := $2004
L2020           := $2020
L2022           := $2022
L204D           := $204D
L20D8           := $20D8
L2120           := $2120
L2221           := $2221
L2320           := $2320
L2425           := $2425
L2831           := $2831
L2884           := $2884
L288A           := $288A
L288C           := $288C
L2C21           := $2C21
L3020           := $3020
L390F           := $390F
L4243           := $4243
L454F           := $454F
L4747           := $4747
L474D           := $474D
L4A4F           := $4A4F
L4A6A           := $4A6A
L4C4A           := $4C4A
L4C4D           := $4C4D
L4C4F           := $4C4F
L508A           := $508A
L5A4F           := $5A4F
L6362           := $6362
L644A           := $644A
L715D           := $715D
L7C45           := $7C45
L8043           := $8043
L8845           := $8845
L9031           := $9031
L9046           := $9046
LD103           := $D103
LDA20           := $DA20
LDB98           := $DB98
LE8DE           := $E8DE
; =============================================================================
; BEHAVIOR type $B9 — endgame Wily, capsule-room scene (spawn code
; $72, stage $0F scr $0A; slot advertised in $0510). Driven by the
; ending player states: at $1F he paces left/right (subs $66/$67,
; freezing at attention when the player poses as sub $C4); at $22 he
; drops in and scurries right to X=$D4 with gravity ($A07F).
; =============================================================================
; ----------------------------------------------------------------------------
        txa                                     ; A000 8A                       .
        sta     $0510                           ; A001 8D 10 05                 ...
        lda     $30                             ; A004 A5 30                    .0
        cmp     #$1F                            ; A006 C9 1F                    ..
        bne     LA039                           ; A008 D0 2F                    ./
        lda     #$78                            ; A00A A9 78                    .x
        sta     $0468,x                         ; A00C 9D 68 04                 .h.
        lda     #$19                            ; A00F A9 19                    ..
        sta     $0588,x                         ; A011 9D 88 05                 ...
        lda     #$A0                            ; A014 A9 A0                    ..
        sta     $05A0,x                         ; A016 9D A0 05                 ...
        dec     $0468,x                         ; A019 DE 68 04                 .h.
        bne     LA039                           ; A01C D0 1B                    ..
        lda     #$80                            ; A01E A9 80                    ..
        sta     $03A8,x                         ; A020 9D A8 03                 ...
        lda     #$00                            ; A023 A9 00                    ..
        sta     $03C0,x                         ; A025 9D C0 03                 ...
        lda     #$02                            ; A028 A9 02                    ..
        sta     $0420,x                         ; A02A 9D 20 04                 . .
        lda     #$3A                            ; A02D A9 3A                    .:
        sta     $0588,x                         ; A02F 9D 88 05                 ...
        lda     #$A0                            ; A032 A9 A0                    ..
        sta     $05A0,x                         ; A034 9D A0 05                 ...
        bne     LA079                           ; A037 D0 40                    .@
LA039:  rts                                     ; A039 60                       `

; ----------------------------------------------------------------------------
        lda     $30                             ; A03A A5 30                    .0
        cmp     #$22                            ; A03C C9 22                    ."
        beq     LA07F                           ; A03E F0 3F                    .?
        cmp     #$20                            ; A040 C9 20                    . 
        bne     LA05F                           ; A042 D0 1B                    ..
        lda     $0558                           ; A044 AD 58 05                 .X.
        cmp     #$C4                            ; A047 C9 C4                    ..
        beq     LA05F                           ; A049 F0 14                    ..
        lda     #$66                            ; A04B A9 66                    .f
        cmp     $0558,x                         ; A04D DD 58 05                 .X.
LA050:  beq     LA039                           ; A050 F0 E7                    ..
        jsr     entity_set_subtype                           ; A052 20 98 EA                  ..
        lda     $0528,x                         ; A055 BD 28 05                 .(.
        ora     #$20                            ; A058 09 20                    . 
        sta     $0528,x                         ; A05A 9D 28 05                 .(.
        bne     LA039                           ; A05D D0 DA                    ..
LA05F:  lda     #$67                            ; A05F A9 67                    .g
        cmp     $0558,x                         ; A061 DD 58 05                 .X.
        beq     LA069                           ; A064 F0 03                    ..
        jsr     entity_set_subtype                           ; A066 20 98 EA                  ..
LA069:  jsr     entity_facing_dispatch                           ; A069 20 65 EA                  e.
        dec     $0468,x                         ; A06C DE 68 04                 .h.
        bne     LA039                           ; A06F D0 C8                    ..
        lda     $0420,x                         ; A071 BD 20 04                 . .
        eor     #$03                            ; A074 49 03                    I.
        sta     $0420,x                         ; A076 9D 20 04                 . .
LA079:  lda     #$20                            ; A079 A9 20                    . 
        sta     $0468,x                         ; A07B 9D 68 04                 .h.
        rts                                     ; A07E 60                       `

; ----------------------------------------------------------------------------
LA07F:  lda     #$93                            ; A07F A9 93                    ..
        sta     $0588,x                         ; A081 9D 88 05                 ...
        lda     #$A0                            ; A084 A9 A0                    ..
        sta     $05A0,x                         ; A086 9D A0 05                 ...
        lda     #$4C                            ; A089 A9 4C                    .L
        sta     $03A8,x                         ; A08B 9D A8 03                 ...
        lda     #$01                            ; A08E A9 01                    ..
        sta     $03C0,x                         ; A090 9D C0 03                 ...
        ldy     #$00                            ; A093 A0 00                    ..
        jsr     entity_gravity_collide                           ; A095 20 B7 E7                  ..
        jsr     LE8DE                           ; A098 20 DE E8                  ..
        rts                                     ; A09B 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $BA — Wily bailed out of the Machine (flung here by
; type $C0, $0A:A215): lands and scrambles right (clamped to X=$D4,
; sub $6E); then at state $1D once the camera passes X=$80 he kneels
; and begs (sub $6D, $A0D9), rides the handoff across to scr $0A,
; drops to the floor, and at state $1F/$20 paces and finally bolts
; ($A191): when the player poses (sub $C4) he runs right to X=$CC,
; slips behind the background into the inner chamber (sub $6D, scr
; $0B), pauses, sound $30, and vanishes ($A231).
; =============================================================================
        ldy     #$00                            ; A09C A0 00                    ..
        jsr     entity_gravity_collide                           ; A09E 20 B7 E7                  ..
        php                                     ; A0A1 08                       .
        jsr     entity_move_right_collide                           ; A0A2 20 E6 E8                  ..
        lda     #$D4                            ; A0A5 A9 D4                    ..
        cmp     $0330,x                         ; A0A7 DD 30 03                 .0.
        bcs     LA0AF                           ; A0AA B0 03                    ..
        sta     $0330,x                         ; A0AC 9D 30 03                 .0.
LA0AF:  plp                                     ; A0AF 28                       (
        bcc     LA0D8                           ; A0B0 90 26                    .&
        lda     #$6E                            ; A0B2 A9 6E                    .n
        jsr     entity_set_subtype                           ; A0B4 20 98 EA                  ..
        lda     $0528,x                         ; A0B7 BD 28 05                 .(.
        and     #$DF                            ; A0BA 29 DF                    ).
        sta     $0528,x                         ; A0BC 9D 28 05                 .(.
        lda     #$D4                            ; A0BF A9 D4                    ..
        sta     $0330,x                         ; A0C1 9D 30 03                 .0.
        lda     #$D9                            ; A0C4 A9 D9                    ..
        sta     $0588,x                         ; A0C6 9D 88 05                 ...
        lda     #$A0                            ; A0C9 A9 A0                    ..
        sta     $05A0,x                         ; A0CB 9D A0 05                 ...
        lda     #$4C                            ; A0CE A9 4C                    .L
        sta     $03A8,x                         ; A0D0 9D A8 03                 ...
        lda     #$01                            ; A0D3 A9 01                    ..
        sta     $03C0,x                         ; A0D5 9D C0 03                 ...
LA0D8:  rts                                     ; A0D8 60                       `

; ----------------------------------------------------------------------------
        lda     $30                             ; A0D9 A5 30                    .0
        cmp     #$1D                            ; A0DB C9 1D                    ..
        bne     LA0D8                           ; A0DD D0 F9                    ..
        lda     $0330                           ; A0DF AD 30 03                 .0.
        cmp     #$80                            ; A0E2 C9 80                    ..
        bcc     LA0D8                           ; A0E4 90 F2                    ..
        lda     #$6D                            ; A0E6 A9 6D                    .m
        jsr     entity_set_subtype                           ; A0E8 20 98 EA                  ..
        lda     #$F5                            ; A0EB A9 F5                    ..
        sta     $0588,x                         ; A0ED 9D 88 05                 ...
        lda     #$A0                            ; A0F0 A9 A0                    ..
        sta     $05A0,x                         ; A0F2 9D A0 05                 ...
        jsr     LE8DE                           ; A0F5 20 DE E8                  ..
        lda     $0348,x                         ; A0F8 BD 48 03                 .H.
        cmp     #$0A                            ; A0FB C9 0A                    ..
        bne     LA0D8                           ; A0FD D0 D9                    ..
        lda     #$80                            ; A0FF A9 80
        cmp     $0330,x                         ; A101 DD 30 03                 .0.
        bcs     LA0D8                           ; A104 B0 D2                    ..
        sta     $0330,x                         ; A106 9D 30 03                 .0.
        lda     #$00                            ; A109 A9 00                    ..
        sta     $03D8,x                         ; A10B 9D D8 03                 ...
        lda     #$04                            ; A10E A9 04                    ..
        sta     $03F0,x                         ; A110 9D F0 03 drop: yvel 4 down
        lda     #$1D                            ; A113 A9 1D
        sta     $0588,x                         ; A115 9D 88 05
        lda     #$A1                            ; A118 A9 A1
        sta     $05A0,x                         ; A11A 9D A0 05 behavior PC := $A11D
        ldy     #$00                            ; A11D A0 00                    ..
        jsr     entity_gravity_collide                           ; A11F 20 B7 E7                  ..
        php                                     ; A122 08                       .
        jsr     LE8DE                           ; A123 20 DE E8                  ..
        plp                                     ; A126 28                       (
        bcc     LA0D8                           ; A127 90 AF                    ..
        lda     #$6E                            ; A129 A9 6E                    .n
        jsr     entity_set_subtype                           ; A12B 20 98 EA                  ..
        lda     $0528,x                         ; A12E BD 28 05                 .(.
        and     #$DF                            ; A131 29 DF                    ).
        sta     $0528,x                         ; A133 9D 28 05                 .(.
        lda     #$40                            ; A136 A9 40                    .@
        sta     $0588,x                         ; A138 9D 88 05                 ...
        lda     #$A1                            ; A13B A9 A1                    ..
        sta     $05A0,x                         ; A13D 9D A0 05                 ...
        lda     $0330                           ; A140 AD 30 03                 .0.
        cmp     #$80                            ; A143 C9 80                    ..
        bcc     LA0D8                           ; A145 90 91                    ..
        lda     #$70                            ; A147 A9 70                    .p
        jsr     entity_set_subtype                           ; A149 20 98 EA                  ..
        lda     #$57                            ; A14C A9 57                    .W
        sta     $0588,x                         ; A14E 9D 88 05                 ...
        lda     #$A1                            ; A151 A9 A1                    ..
        sta     $05A0,x                         ; A153 9D A0 05                 ...
LA156:  rts                                     ; A156 60                       `

; ----------------------------------------------------------------------------
        lda     $30                             ; A157 A5 30                    .0
        cmp     #$1F                            ; A159 C9 1F                    ..
        bne     LA156                           ; A15B D0 F9                    ..
LA15D:  lda     #$78                            ; A15D A9 78                    .x
        sta     $0468,x                         ; A15F 9D 68 04                 .h.
        lda     #$6C                            ; A162 A9 6C                    .l
        sta     $0588,x                         ; A164 9D 88 05                 ...
        lda     #$A1                            ; A167 A9 A1                    ..
        sta     $05A0,x                         ; A169 9D A0 05                 ...
        dec     $0468,x                         ; A16C DE 68 04                 .h.
        bne     LA156                           ; A16F D0 E5                    ..
        lda     #$6E                            ; A171 A9 6E                    .n
        jsr     entity_set_subtype                           ; A173 20 98 EA                  ..
        lda     #$00                            ; A176 A9 00                    ..
        sta     $03A8,x                         ; A178 9D A8 03                 ...
        lda     #$01                            ; A17B A9 01                    ..
        sta     $03C0,x                         ; A17D 9D C0 03                 ...
        lda     #$01                            ; A180 A9 01                    ..
        sta     $0420,x                         ; A182 9D 20 04                 . .
        lda     #$91                            ; A185 A9 91                    ..
        sta     $0588,x                         ; A187 9D 88 05                 ...
        lda     #$A1                            ; A18A A9 A1                    ..
        sta     $05A0,x                         ; A18C 9D A0 05                 ...
        bne     LA1DD                           ; A18F D0 4C                    .L
        lda     $30                             ; A191 A5 30                    .0
        cmp     #$20                            ; A193 C9 20                    . 
        bne     LA1CD                           ; A195 D0 36                    .6
        lda     $0468,x                         ; A197 BD 68 04                 .h.
        cmp     #$30                            ; A19A C9 30                    .0
        bne     LA1CD                           ; A19C D0 2F                    ./
        lda     $0420,x                         ; A19E BD 20 04                 . .
LA1A1:  and     #$01                            ; A1A1 29 01                    ).
        beq     LA1CD                           ; A1A3 F0 28                    .(
        lda     #$6E                            ; A1A5 A9 6E                    .n
        jsr     entity_set_subtype                           ; A1A7 20 98 EA                  ..
        lda     $0528,x                         ; A1AA BD 28 05                 .(.
        and     #$DF                            ; A1AD 29 DF                    ).
        sta     $0528,x                         ; A1AF 9D 28 05                 .(.
        lda     #$3C                            ; A1B2 A9 3C                    .<
        sta     $0468,x                         ; A1B4 9D 68 04                 .h.
        lda     #$80                            ; A1B7 A9 80                    ..
        sta     $03A8,x                         ; A1B9 9D A8 03                 ...
        lda     #$00                            ; A1BC A9 00                    ..
        sta     $03C0,x                         ; A1BE 9D C0 03                 ...
        lda     #$E3                            ; A1C1 A9 E3                    ..
        sta     $0588,x                         ; A1C3 9D 88 05                 ...
        lda     #$A1                            ; A1C6 A9 A1                    ..
        sta     $05A0,x                         ; A1C8 9D A0 05                 ...
        bne     LA1E3                           ; A1CB D0 16                    ..
LA1CD:  jsr     entity_facing_dispatch                           ; A1CD 20 65 EA                  e.
        dec     $0468,x                         ; A1D0 DE 68 04                 .h.
        bne     LA1E2                           ; A1D3 D0 0D                    ..
        lda     $0420,x                         ; A1D5 BD 20 04                 . .
        eor     #$03                            ; A1D8 49 03                    I.
        sta     $0420,x                         ; A1DA 9D 20 04                 . .
LA1DD:  lda     #$30                            ; A1DD A9 30                    .0
        sta     $0468,x                         ; A1DF 9D 68 04                 .h.
LA1E2:  rts                                     ; A1E2 60                       `

; ----------------------------------------------------------------------------
LA1E3:  lda     $0558                           ; A1E3 AD 58 05                 .X.
        cmp     #$C4                            ; A1E6 C9 C4                    ..
        bne     LA1E2                           ; A1E8 D0 F8                    ..
        dec     $0468,x                         ; A1EA DE 68 04                 .h.
        bne     LA1E2                           ; A1ED D0 F3                    ..
        lda     #$6F                            ; A1EF A9 6F                    .o
        jsr     entity_set_subtype                           ; A1F1 20 98 EA                  ..
        lda     #$FE                            ; A1F4 A9 FE                    ..
        sta     $0588,x                         ; A1F6 9D 88 05                 ...
        lda     #$A1                            ; A1F9 A9 A1                    ..
        sta     $05A0,x                         ; A1FB 9D A0 05                 ...
        lda     $0540,x                         ; A1FE BD 40 05                 .@.
        bne     LA1E2                           ; A201 D0 DF                    ..
        jsr     entity_move_right_collide                           ; A203 20 E6 E8                  ..
        lda     $0330,x                         ; A206 BD 30 03                 .0.
        cmp     #$CC                            ; A209 C9 CC                    ..
        bcc     LA1E2                           ; A20B 90 D5                    ..
        inc     $03C0,x                         ; A20D FE C0 03                 ...
        lda     #$27                            ; A210 A9 27                    .'
        sta     $0588,x                         ; A212 9D 88 05                 ...
        lda     #$A2                            ; A215 A9 A2                    ..
        sta     $05A0,x                         ; A217 9D A0 05                 ...
        lda     #$6D                            ; A21A A9 6D                    .m
        jsr     entity_set_subtype                           ; A21C 20 98 EA                  ..
        lda     $0528,x                         ; A21F BD 28 05                 .(.
        ora     #$08                            ; A222 09 08                    ..
        sta     $0528,x                         ; A224 9D 28 05                 .(.
        jsr     LE8DE                           ; A227 20 DE E8                  ..
        lda     $0348,x                         ; A22A BD 48 03                 .H.
        cmp     #$0B                            ; A22D C9 0B                    ..
        bne     LA25C                           ; A22F D0 2B                    .+
        lda     #$78                            ; A231 A9 78                    .x
        sta     $0468,x                         ; A233 9D 68 04                 .h.
        lda     #$40                            ; A236 A9 40                    .@
        sta     $0588,x                         ; A238 9D 88 05                 ...
        lda     #$A2                            ; A23B A9 A2                    ..
        sta     $05A0,x                         ; A23D 9D A0 05                 ...
        dec     $0468,x                         ; A240 DE 68 04                 .h.
        bne     LA25C                           ; A243 D0 17                    ..
        lda     #$30                            ; A245 A9 30                    .0
        jsr     queue_sound                           ; A247 20 5D EC                  ].
        lda     #$54                            ; A24A A9 54                    .T
        sta     $0588,x                         ; A24C 9D 88 05                 ...
        lda     #$A2                            ; A24F A9 A2                    ..
        sta     $05A0,x                         ; A251 9D A0 05                 ...
        dec     $0468,x                         ; A254 DE 68 04                 .h.
        bne     LA25C                           ; A257 D0 03                    ..
        jsr     entity_wipe_x                           ; A259 20 C4 F2                  ..
LA25C:  rts                                     ; A25C 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $C1 — scene burst: becomes a type $01 effect (sub
; $42) pinned at Y=$B2.
; =============================================================================
        jsr     entity_wipe_x                           ; A25D 20 C4 F2                  ..
        lda     #$B2                            ; A260 A9 B2                    ..
        sta     $0378,x                         ; A262 9D 78 03                 .x.
        lda     #$01                            ; A265 A9 01                    ..
        sta     $0300,x                         ; A267 9D 00 03                 ...
        lda     #$42                            ; A26A A9 42                    .B
        jmp     entity_set_subtype                           ; A26C 4C 98 EA                 L..

; ----------------------------------------------------------------------------
; $A26F-$A7FF: data, unreferenced in-bank (no reader found)
        .byte   $FF,$BF,$FF,$FB,$FF,$AE,$FF,$AF ; A26F
        .byte   $FF,$BE,$FF,$BF,$FF,$FB,$FF,$FF ; A277
        .byte   $FF,$AF,$FF,$BA,$BF,$AA,$FE,$FA ; A27F
        .byte   $FF,$EF,$FF,$FA,$FF,$EF,$FF,$FF ; A287
        .byte   $FF,$FF,$FF,$FE,$FF,$FF,$FF,$FB ; A28F
        .byte   $FF,$BF,$FF,$FF,$FF,$BA,$FF,$FE ; A297
        .byte   $FF,$AE,$FF,$EA,$FF,$EA,$FF,$EA ; A29F
        .byte   $FB,$EF,$FE,$AA,$FF,$AF,$7B,$FF ; A2A7
        .byte   $FF,$FB,$FF,$FB,$FF,$BB,$FF,$FA ; A2AF
        .byte   $FF,$EE,$FF,$FE,$FF,$FF,$FF,$BF ; A2B7
        .byte   $FF,$FF,$FF,$FA,$EF,$FA,$FD,$3A ; A2BF
        .byte   $FF,$FF,$FF,$FF,$FF,$EB,$FE,$AA ; A2C7
        .byte   $FF,$7B,$FF,$EE,$FF,$FE,$7F,$FB ; A2CF
        .byte   $FF,$EE,$FF,$AF,$FF,$FF,$FF,$FE ; A2D7
        .byte   $FF,$EA,$FF,$FA,$FF,$EE,$EF,$FA ; A2DF
        .byte   $FF,$EA,$FF,$BE,$FF,$EF,$EF,$BB ; A2E7
        .byte   $FF,$AF,$FF,$EA,$FF,$EA,$FF,$BF ; A2EF
        .byte   $F7,$AB,$FF,$EE,$FF,$FE,$FF,$EE ; A2F7
        .byte   $FF,$FA,$FF,$FB,$FF,$FF,$EF,$FE ; A2FF
        .byte   $FF,$EA,$7F,$9E,$FF,$FF,$FF,$FF ; A307
        .byte   $FF,$BF,$FF,$FF,$FF,$FF,$FF,$FF ; A30F
        .byte   $FF,$FE,$FF,$FF,$FF,$FB,$FF,$BB ; A317
        .byte   $FF,$BE,$F7,$FB,$FF,$EF,$FF,$EE ; A31F
        .byte   $FF,$FE,$FF,$EF,$FF,$EE,$FF,$EF ; A327
        .byte   $FF,$FE,$FF,$FE,$FF,$FF,$EF,$FE ; A32F
        .byte   $FF,$FE,$FF,$FA,$FF,$BF,$FF,$AA ; A337
        .byte   $FF,$BA,$FF,$EA,$FF,$EE,$FF,$FE ; A33F
        .byte   $FF,$BF,$FF,$EB,$FF,$FE,$FF,$AB ; A347
        .byte   $FF,$BB,$FF,$EE,$FF,$EF,$FF,$BF ; A34F
        .byte   $FF,$AF,$FF,$FF,$FF,$FF,$FF,$EB ; A357
        .byte   $FF,$E1,$FF,$FB,$FF,$FF,$FF,$FB ; A35F
        .byte   $FF,$FB,$FF,$FA,$FF,$FE,$FF,$EE ; A367
        .byte   $FF,$AF,$FF,$AA,$FF,$BF,$EF,$EE ; A36F
        .byte   $FF,$BF,$FF,$FF,$FF,$AE,$FF,$FF ; A377
        .byte   $FF,$BF,$FF,$BE,$FF,$BF,$FF,$FA ; A37F
        .byte   $FF,$BF,$FF,$BF,$FF,$BF,$FF,$BF ; A387
        .byte   $FF,$FF,$FF,$EF,$FF,$FF,$FF,$EF ; A38F
        .byte   $FF,$FF,$FF,$BF,$FF,$FF,$FF,$FF ; A397
        .byte   $FF,$AA,$FF,$FA,$7F,$BB,$FF,$EC ; A39F
        .byte   $BF,$EF,$FF,$BF,$FF,$EF,$7F,$AB ; A3A7
        .byte   $FB,$EA,$FD,$AF,$EF,$BE,$FF,$EF ; A3AF
        .byte   $FF,$AF,$FF,$FF,$FF,$FF,$FB,$BF ; A3B7
        .byte   $FF,$FB,$FF,$AB,$FF,$BF,$FF,$3E ; A3BF
        .byte   $FF,$FE,$FF,$AB,$FF,$BE,$FF,$FE ; A3C7
        .byte   $FF,$FB,$FF,$FF,$FF,$FE,$FF,$FF ; A3CF
        .byte   $FF,$FF,$FF,$EE,$FF,$FF,$FF,$FE ; A3D7
        .byte   $FF,$FB,$FF,$EE,$FF,$BF,$FF,$BE ; A3DF
        .byte   $FF,$6F,$FF,$EA,$FF,$AA,$FE,$2E ; A3E7
        .byte   $FB,$FB,$FF,$EB,$FD,$BF,$FF,$EE ; A3EF
        .byte   $FF,$EB,$FF,$AB,$FF,$BA,$FF,$BA ; A3F7
        .byte   $FF,$FF,$15,$DF,$5D,$FF,$45,$FE ; A3FF
        .byte   $5C,$FF,$FD,$FF,$DF,$FF,$DF,$FF ; A407
        .byte   $5D,$FF,$FF,$FF,$F7,$FF,$FF,$FF ; A40F
        .byte   $FD,$FF,$F7,$FF,$FF,$FF,$FB,$FF ; A417
        .byte   $FD,$F7,$11,$F6,$54,$E7,$5F,$57 ; A41F
        .byte   $55,$FD,$5D,$FF,$B5,$7F,$1D,$FF ; A427
        .byte   $5D,$FF,$55,$FF,$77,$FF,$7F,$FF ; A42F
        .byte   $FF,$FF,$DF,$FF,$FD,$FE,$DF,$FF ; A437
        .byte   $FF,$FB,$55,$FF,$15,$FF,$95,$F7 ; A43F
        .byte   $16,$FE,$75,$FF,$75,$FB,$F7,$FF ; A447
        .byte   $DD,$FB,$D5,$FF,$77,$FF,$F7,$FF ; A44F
        .byte   $FD,$FF,$F7,$FF,$7F,$FF,$FF,$FF ; A457
        .byte   $FF,$FD,$43,$FF,$D5,$EF,$65,$BF ; A45F
        .byte   $15,$BF,$17,$3F,$55,$DF,$55,$BE ; A467
        .byte   $54,$F3,$55,$FE,$47,$F2,$E5,$FF ; A46F
        .byte   $DF,$FF,$DF,$FF,$DF,$DF,$7F,$FF ; A477
        .byte   $DF,$DF,$45,$FF,$5D,$FD,$57,$DF ; A47F
        .byte   $5F,$E7,$F5,$FF,$57,$FF,$F5,$F7 ; A487
        .byte   $D5,$FF,$DD,$FF,$FD,$F7,$FF,$FF ; A48F
        .byte   $FF,$FF,$FF,$FF,$DF,$FF,$7F,$FF ; A497
        .byte   $FD,$FF,$54,$FF,$55,$FB,$54,$FF ; A49F
        .byte   $41,$FF,$D7,$FE,$DD,$7F,$55,$BF ; A4A7
        .byte   $55,$FF,$D7,$FF,$D5,$FF,$75,$FF ; A4AF
        .byte   $F5,$FF,$FF,$FF,$D7,$FF,$DF,$FF ; A4B7
        .byte   $F7,$FF,$45,$7F,$5D,$FF,$55,$FE ; A4BF
        .byte   $50,$FE,$55,$B9,$55,$A7,$7D,$FF ; A4C7
        .byte   $F5,$F7,$DD,$FF,$7D,$FF,$DF,$FF ; A4CF
        .byte   $F7,$FF,$DF,$FF,$7F,$FF,$FF,$FF ; A4D7
        .byte   $7F,$9E,$55,$EF,$55,$DA,$55,$9B ; A4DF
        .byte   $45,$FF,$51,$FF,$37,$FA,$D4,$39 ; A4E7
        .byte   $51,$7D,$75,$DF,$11,$E7,$54,$EF ; A4EF
        .byte   $5D,$FE,$79,$FD,$5D,$FF,$7F,$FF ; A4F7
        .byte   $F7,$FE,$5D,$FD,$3D,$FF,$D4,$FF ; A4FF
        .byte   $CF,$FF,$5D,$FF,$D5,$FE,$FF,$FF ; A507
        .byte   $5F,$FF,$FD,$FF,$FE,$FF,$FF,$FF ; A50F
        .byte   $FD,$FF,$DF,$FF,$FD,$FF,$FF,$FF ; A517
        .byte   $DD,$FE,$55,$BF,$DC,$F5,$57,$B5 ; A51F
        .byte   $51,$9F,$55,$DA,$F5,$FF,$D5,$7F ; A527
        .byte   $55,$FF,$F5,$FF,$5B,$FF,$55,$FF ; A52F
        .byte   $F5,$FF,$5F,$FF,$DD,$FF,$FF,$FF ; A537
        .byte   $D7,$75,$57,$EF,$54,$CF,$41,$FF ; A53F
        .byte   $55,$BF,$D1,$7F,$55,$FF,$55,$FF ; A547
        .byte   $DD,$FF,$5F,$FF,$7F,$FF,$5D,$FF ; A54F
        .byte   $FF,$FF,$7F,$FF,$DF,$FF,$FF,$FF ; A557
        .byte   $FD,$FE,$41,$B3,$5D,$BF,$55,$7F ; A55F
        .byte   $55,$FF,$DD,$FB,$15,$FF,$55,$FD ; A567
        .byte   $59,$EF,$51,$FE,$75,$FF,$45,$FF ; A56F
        .byte   $7D,$FF,$FD,$EF,$DF,$FF,$FD,$EF ; A577
        .byte   $F5,$FB,$5D,$FD,$D9,$FB,$54,$F9 ; A57F
        .byte   $D7,$FF,$D7,$FF,$51,$FF,$57,$FF ; A587
        .byte   $75,$FF,$FF,$FF,$FF,$FF,$FD,$FF ; A58F
        .byte   $77,$FF,$DF,$FF,$7F,$FF,$FD,$FF ; A597
        .byte   $FF,$F3,$55,$EB,$54,$7F,$05,$EF ; A59F
        .byte   $55,$7F,$45,$BF,$75,$FF,$5C,$FE ; A5A7
        .byte   $76,$FF,$77,$7F,$D7,$F7,$7D,$FF ; A5AF
        .byte   $DD,$FF,$77,$FF,$7D,$FF,$FF,$FD ; A5B7
        .byte   $FF,$FF,$01,$AF,$05,$9F,$57,$FF ; A5BF
        .byte   $D5,$FD,$D5,$BF,$5F,$FF,$F7,$FF ; A5C7
        .byte   $57,$FF,$F5,$FF,$F5,$FF,$7D,$FF ; A5CF
        .byte   $FF,$FF,$FF,$FF,$5F,$FF,$FF,$FF ; A5D7
        .byte   $FF,$F7,$45,$F7,$55,$B3,$56,$67 ; A5DF
        .byte   $54,$FB,$C1,$D7,$10,$FF,$55,$BF ; A5E7
        .byte   $5C,$FF,$45,$7D,$47,$DE,$70,$FA ; A5EF
        .byte   $04,$7F,$59,$FF,$5D,$FF,$DD,$FF ; A5F7
        .byte   $F5,$FE,$55,$7B,$55,$FF,$57,$FD ; A5FF
        .byte   $55,$F7,$B5,$FF,$7F,$FF,$F7,$FF ; A607
        .byte   $F7,$FF,$FF,$FF,$FF,$FF,$5F,$FF ; A60F
        .byte   $FF,$FF,$FF,$FF,$7F,$FF,$FD,$FF ; A617
        .byte   $DF,$F7,$0C,$DF,$55,$BB,$D1,$FF ; A61F
        .byte   $34,$7F,$55,$7F,$55,$FF,$55,$DF ; A627
        .byte   $5F,$FF,$5F,$FF,$77,$FE,$7D,$FF ; A62F
        .byte   $7D,$FF,$D7,$FF,$FF,$FF,$FF,$FF ; A637
        .byte   $DD,$FD,$57,$FF,$3F,$FF,$55,$FF ; A63F
        .byte   $35,$FF,$77,$FB,$DD,$FF,$D6,$FF ; A647
        .byte   $D7,$6F,$77,$FF,$FF,$FF,$FF,$FF ; A64F
        .byte   $F7,$BF,$FF,$BF,$FF,$FF,$DF,$FF ; A657
        .byte   $FF,$F7,$1D,$FD,$55,$FD,$55,$A3 ; A65F
        .byte   $55,$DF,$55,$BD,$77,$D6,$57,$FF ; A667
        .byte   $55,$FF,$55,$FE,$54,$FF,$55,$FF ; A66F
        .byte   $D1,$FF,$5D,$FF,$DF,$FE,$F7,$F7 ; A677
        .byte   $FB,$FE,$55,$FD,$55,$FF,$55,$FE ; A67F
        .byte   $F1,$F7,$57,$FF,$D7,$FF,$BF,$FF ; A687
        .byte   $7F,$FF,$7F,$FF,$F7,$FF,$DD,$FF ; A68F
        .byte   $FF,$FF,$7F,$FF,$FF,$FF,$FF,$FF ; A697
        .byte   $FF,$5D,$15,$DF,$56,$D8,$55,$FD ; A69F
        .byte   $45,$FB,$59,$76,$D1,$D7,$7F,$FD ; A6A7
        .byte   $D4,$FF,$D5,$FF,$D5,$FF,$74,$7F ; A6AF
        .byte   $FE,$FF,$7D,$FF,$DF,$FF,$FD,$FF ; A6B7
        .byte   $FF,$D7,$5C,$BE,$5D,$7F,$17,$A7 ; A6BF
        .byte   $59,$FE,$54,$3F,$54,$FF,$74,$FD ; A6C7
        .byte   $77,$FF,$5D,$DF,$F7,$FF,$D5,$FF ; A6CF
        .byte   $7D,$FF,$FD,$FF,$FF,$FF,$FF,$EF ; A6D7
        .byte   $FF,$FF,$45,$FD,$55,$7E,$51,$D7 ; A6DF
        .byte   $57,$7F,$53,$FB,$55,$BF,$55,$FD ; A6E7
        .byte   $75,$EB,$45,$EF,$55,$FF,$D5,$FB ; A6EF
        .byte   $55,$77,$D5,$EF,$55,$FD,$D9,$FF ; A6F7
        .byte   $FF,$7F,$57,$FD,$5D,$FF,$59,$F7 ; A6FF
        .byte   $57,$FF,$D1,$FF,$5D,$7F,$77,$FF ; A707
        .byte   $75,$FF,$FD,$FF,$7F,$FF,$7F,$FF ; A70F
        .byte   $5F,$FF,$FF,$FF,$FF,$FF,$FF,$FF ; A717
        .byte   $F5,$FF,$55,$FF,$44,$CB,$47,$FB ; A71F
        .byte   $55,$B7,$55,$3F,$55,$EF,$D5,$F7 ; A727
        .byte   $F6,$EF,$5D,$FF,$DF,$FF,$75,$FF ; A72F
        .byte   $DD,$FF,$F5,$FF,$DF,$FF,$F7,$FF ; A737
        .byte   $FD,$AB,$4D,$FF,$55,$BD,$55,$FB ; A73F
        .byte   $15,$7F,$53,$FF,$D7,$DF,$D7,$FF ; A747
        .byte   $F5,$FD,$FD,$FF,$DF,$FF,$FF,$FF ; A74F
        .byte   $FD,$FF,$FF,$FF,$D7,$FF,$FF,$FF ; A757
        .byte   $FF,$DF,$41,$D6,$75,$6F,$33,$FF ; A75F
        .byte   $51,$BF,$15,$FF,$E5,$BF,$05,$F5 ; A767
        .byte   $11,$5B,$43,$F5,$E5,$FB,$18,$BF ; A76F
        .byte   $51,$FF,$D7,$FD,$F7,$FF,$57,$7F ; A777
        .byte   $DD,$7C,$D7,$EF,$54,$FF,$5D,$FF ; A77F
        .byte   $51,$FF,$D5,$FD,$77,$FF,$7D,$FF ; A787
        .byte   $65,$FF,$FD,$FF,$F7,$FF,$FF,$FF ; A78F
        .byte   $FF,$FF,$F5,$FF,$FF,$FF,$FF,$FF ; A797
        .byte   $F7,$C7,$55,$FC,$55,$DF,$56,$BF ; A79F
        .byte   $D5,$FF,$51,$DF,$44,$FF,$F5,$BF ; A7A7
        .byte   $45,$FF,$5D,$7F,$CD,$7F,$57,$FF ; A7AF
        .byte   $F5,$FF,$FD,$FF,$FD,$FF,$DF,$FF ; A7B7
        .byte   $FF,$BF,$15,$FF,$51,$FD,$55,$DF ; A7BF
        .byte   $75,$FF,$B5,$FF,$55,$FF,$D8,$EF ; A7C7
        .byte   $77,$FF,$7F,$FF,$77,$FF,$F7,$FF ; A7CF
        .byte   $FF,$FF,$FF,$FF,$FD,$FF,$FF,$FF ; A7D7
        .byte   $FD,$FB,$51,$CF,$55,$3B,$54,$EB ; A7DF
        .byte   $45,$97,$F0,$EF,$50,$7E,$05,$9C ; A7E7
        .byte   $50,$77,$FD,$F2,$D4,$FF,$55,$7F ; A7EF
        .byte   $75,$FF,$55,$FE,$D5,$FF,$67,$FF ; A7F7
        .byte   $75 ; A7FF
        .byte   $00                             ; A800
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A801
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A811
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A821
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A831
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A841
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A851
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A861
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A871
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A881
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A891
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8A1
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8B1
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8C1
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8D1
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8E1
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8F1

; =============================================================================
; WILY 2 STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $A900: screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; A900  screens $00-$0F
        .byte   $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$00,$00,$00,$00,$00,$00 ; A910  screens $10-$1F
        .byte   $00,$00,$00,$20,$08,$00,$A0,$24,$00,$1A,$00,$84,$00,$00,$02,$00 ; A920  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A930  screens $30-$3F
        .byte   $80,$08,$00,$00,$00,$10,$00,$01,$00,$01,$00,$00,$00,$00,$00,$00 ; A940  screens $40-$4F
; --- $A950: section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $22,$40,$67,$80,$A2,$62,$61,$80,$A0,$20,$20,$00,$00,$00,$00,$00 ; A950
        .byte   $00,$00,$18,$00,$00,$C0,$00,$40 ; A960
; --- $A968: per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $09,$00,$07,$07,$07,$1C,$19,$31,$31,$80,$80,$00,$00,$04,$00,$00 ; A968
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A978
; --- $A980: BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $B4,$B6,$08,$00,$02,$00,$20,$00 ; A980
; --- $A988: palette sets, 20 bytes each [16 BG palette + 4 palette-cycle
; seeds]: set n at +20n; set 0 is loaded by stage_load, later sets are
; switched per section by the bank $00 environment service
; ($A968 attr bits 0-5 -> $00:809E records, ctl bit 7) ---
        .byte   $0F,$30,$10,$1C,$0F,$31,$21,$11,$0F,$1C,$11,$01,$0F,$17,$14,$04 ; A988
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A998
        .byte   $00,$00,$08,$00,$00,$40,$88,$40,$00,$02,$00,$80,$00,$08,$02,$00 ; A9A0
        .byte   $00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9B0
        .byte   $20,$00,$00,$00,$00,$01,$02,$00,$00,$10,$00,$01,$20,$01,$00,$00 ; A9C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9D0
; --- $A9E0: screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$01,$00,$00,$80,$00,$02,$0C,$00,$00,$00,$00,$80,$23,$00,$40 ; A9E0  terminator / filler
        .byte   $20,$43,$80,$42,$80,$21,$12,$00,$00,$02,$00,$00,$00,$02,$00 ; A9F0  
        .byte   $00                             ; A9FF  -1 base for the spawn arrays
; --- $AA00: spawn screens (ascending) ---
        .byte   $01,$01,$01,$02,$02,$02,$04,$04,$04,$04,$05,$05,$05,$05,$06,$07 ; AA00  entries $00-$0F
        .byte   $07,$08,$08,$08,$08,$09,$09,$09,$09,$0A,$0B,$0B,$0B,$0B,$0C,$0C ; AA10  entries $10-$1F
        .byte   $0C,$0E,$0E,$0F,$0F,$10,$10,$10,$10,$11,$11,$12,$12,$12,$12,$13 ; AA20  entries $20-$2F
        .byte   $14,$14,$15,$16,$18,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA30  entries $30-$3F
        .byte   $00,$02,$00,$80,$08,$00,$00,$08,$02,$00,$00,$00,$00,$00,$00,$00 ; AA40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA50  entries $50-$5F
        .byte   $00,$00,$82,$20,$8A,$50,$80,$00,$00,$04,$00,$00,$00,$00,$00,$24 ; AA60  entries $60-$6F
        .byte   $00,$00,$00,$06,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA70  entries $70-$7F
; --- $AA80: spawn X px ---
        .byte   $18,$78,$F0,$40,$78,$E8,$00,$50,$90,$A0,$60,$98,$A0,$C8,$70,$88 ; AA80  entries $00-$0F
        .byte   $C8,$38,$68,$80,$C0,$50,$78,$80,$D8,$98,$00,$18,$58,$C8,$00,$49 ; AA90  entries $10-$1F
        .byte   $A0,$10,$F0,$50,$A8,$00,$20,$50,$A0,$28,$C0,$10,$40,$70,$90,$90 ; AAA0  entries $20-$2F
        .byte   $40,$C0,$50,$A0,$80,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAB0  entries $30-$3F
        .byte   $20,$80,$00,$00,$00,$40,$00,$05,$02,$00,$00,$80,$00,$00,$00,$00 ; AAC0  entries $40-$4F
        .byte   $00,$40,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAD0  entries $50-$5F
        .byte   $00,$10,$00,$00,$08,$05,$22,$08,$20,$45,$88,$88,$20,$32,$08,$C8 ; AAE0  entries $60-$6F
        .byte   $00,$C0,$80,$01,$00,$00,$00,$00,$00,$C0,$00,$00,$00,$00,$00,$01 ; AAF0  entries $70-$7F
; --- $AB00: spawn Y px ---
        .byte   $13,$13,$A3,$83,$83,$83,$00,$58,$58,$00,$B8,$A6,$00,$A6,$98,$C6 ; AB00  entries $00-$0F
        .byte   $C6,$C6,$B6,$00,$88,$58,$98,$00,$B8,$B8,$00,$B8,$98,$88,$00,$98 ; AB10  entries $10-$1F
        .byte   $B8,$A8,$8A,$AA,$BA,$00,$49,$39,$29,$AC,$29,$29,$BC,$BC,$CC,$B8 ; AB20  entries $20-$2F
        .byte   $AC,$40,$BA,$84,$58,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB30  entries $30-$3F
        .byte   $00,$00,$20,$04,$20,$04,$20,$00,$20,$00,$00,$00,$00,$00,$00,$00 ; AB40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB50  entries $50-$5F
        .byte   $00,$00,$80,$20,$80,$00,$00,$08,$00,$00,$02,$04,$00,$04,$00,$00 ; AB60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB70  entries $70-$7F
; --- $AB80: spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $1C,$1C,$1C,$1C,$1C,$1C,$C4,$81,$82,$CD,$29,$2D,$CC,$30,$29,$2D ; AB80  entries $00-$0F
        .byte   $30,$30,$2D,$CC,$29,$84,$29,$CD,$29,$29,$CA,$29,$29,$29,$CB,$29 ; AB90  entries $10-$1F
        .byte   $29,$29,$31,$31,$31,$C5,$34,$34,$34,$05,$34,$34,$05,$05,$05,$84 ; ABA0  entries $20-$2F
        .byte   $05,$39,$0C,$0C,$5C,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABB0  entries $30-$3F
        .byte   $20,$80,$00,$08,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$00,$00 ; ABC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABD0  entries $50-$5F
        .byte   $08,$0C,$80,$24,$00,$00,$80,$C1,$00,$88,$02,$C0,$20,$09,$0A,$02 ; ABE0  entries $60-$6F
        .byte   $00,$00,$02,$60,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABF0  entries $70-$7F
; --- $AC00: per-screen spawn-list start index ---
        .byte   $00,$00,$03,$06,$06,$0A,$0E,$0F,$11,$15,$19,$1A,$1E,$21,$21,$23 ; AC00  screens $00-$0F
        .byte   $25,$29,$2B,$2F,$30,$32,$33,$34,$34,$00,$00,$00,$00,$00,$00,$00 ; AC10  screens $10-$1F
        .byte   $10,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC20  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC30  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC40  screens $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC50  screens $50-$5F
        .byte   $00,$00,$00,$00,$00,$40,$80,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC60  screens $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC90  screens $90-$9F
        .byte   $00,$04,$04,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00 ; ACA0  screens $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACB0  screens $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACD0  screens $D0-$DF
        .byte   $00,$01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACE0  screens $E0-$EF
        .byte   $00,$00,$00,$00,$08,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00 ; ACF0  screens $F0-$FF
; --- $AD00: metatile top-left tile ids ---
        .byte   $00,$0C,$0C,$8C,$04,$06,$08,$8E,$00,$88,$1C,$00,$24,$26,$2C,$2E ; AD00  metatiles $00-$0F
        .byte   $83,$98,$00,$00,$00,$00,$64,$66,$8A,$A8,$68,$6E,$00,$00,$08,$08 ; AD10  metatiles $10-$1F
        .byte   $C0,$C2,$C4,$C6,$C8,$CA,$C4,$EE,$E0,$E2,$E4,$E6,$E8,$EA,$FC,$FE ; AD20  metatiles $20-$2F
        .byte   $00,$80,$81,$81,$81,$78,$10,$10,$00,$A0,$A2,$A4,$A6,$58,$4A,$10 ; AD30  metatiles $30-$3F
        .byte   $C2,$C0,$C9,$80,$C0,$87,$80,$81,$E2,$E0,$E9,$A0,$E0,$A7,$58,$6B ; AD40  metatiles $40-$4F
        .byte   $C0,$C2,$C4,$C6,$C8,$CA,$81,$0E,$E0,$E2,$E4,$E6,$E8,$EA,$10,$03 ; AD50  metatiles $50-$5F
        .byte   $CE,$80,$81,$81,$81,$C4,$EE,$00,$00,$A0,$A2,$A4,$A6,$FC,$FE,$00 ; AD60  metatiles $60-$6F
        .byte   $AA,$AC,$AC,$AE,$E2,$E4,$E6,$E8,$AA,$AC,$AC,$AE,$20,$22,$00,$00 ; AD70  metatiles $70-$7F
        .byte   $40,$42,$44,$46,$4C,$4E,$4C,$4E,$60,$62,$64,$66,$6C,$6E,$6C,$6E ; AD80  metatiles $80-$8F
        .byte   $40,$42,$21,$21,$22,$00,$2C,$2E,$00,$00,$00,$00,$22,$22,$00,$00 ; AD90  metatiles $90-$9F
        .byte   $48,$00,$CC,$CD,$CF,$B8,$00,$00,$57,$4B,$CD,$00,$B9,$B6,$B9,$00 ; ADA0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADB0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$0A,$0C,$0E,$00,$00 ; ADC0  metatiles $C0-$CF
        .byte   $00,$58,$7C,$02,$04,$06,$5A,$00,$00,$78,$20,$25,$24,$26,$7A,$00 ; ADD0  metatiles $D0-$DF
        .byte   $00,$00,$00,$42,$44,$46,$00,$00,$00,$00,$60,$62,$64,$66,$00,$00 ; ADE0  metatiles $E0-$EF
        .byte   $00,$00,$28,$2A,$2C,$2E,$6E,$00,$00,$00,$48,$4A,$4C,$4E,$00,$00 ; ADF0  metatiles $F0-$FF
; --- $AE00: metatile bottom-left tile ids ---
        .byte   $00,$0D,$0D,$8D,$05,$07,$09,$8F,$00,$89,$1D,$00,$25,$27,$2D,$2F ; AE00  metatiles $00-$0F
        .byte   $00,$99,$00,$00,$00,$00,$65,$67,$8B,$A9,$69,$6F,$00,$00,$09,$09 ; AE10  metatiles $10-$1F
        .byte   $C1,$C3,$C5,$C7,$C9,$CB,$ED,$EF,$E1,$E3,$E5,$E7,$E9,$EB,$FD,$FF ; AE20  metatiles $20-$2F
        .byte   $00,$81,$81,$81,$87,$10,$10,$79,$00,$A1,$A3,$A5,$A7,$10,$4B,$59 ; AE30  metatiles $30-$3F
        .byte   $C9,$C2,$CB,$87,$80,$CB,$81,$87,$E9,$E2,$EB,$A7,$A0,$EB,$6A,$59 ; AE40  metatiles $40-$4F
        .byte   $C1,$C3,$C5,$C7,$C9,$CB,$81,$0F,$E1,$E3,$E5,$E7,$E9,$EB,$10,$03 ; AE50  metatiles $50-$5F
        .byte   $CF,$81,$81,$81,$87,$ED,$EF,$00,$00,$A1,$A3,$A5,$A7,$FD,$FF,$00 ; AE60  metatiles $60-$6F
        .byte   $AB,$AD,$AD,$AF,$E3,$E5,$E7,$E9,$AB,$AD,$AD,$AF,$21,$23,$00,$00 ; AE70  metatiles $70-$7F
        .byte   $41,$43,$45,$47,$4D,$4F,$4D,$4F,$61,$63,$65,$67,$6D,$6F,$6D,$6F ; AE80  metatiles $80-$8F
        .byte   $41,$43,$21,$21,$22,$00,$2D,$2F,$00,$00,$00,$00,$22,$22,$00,$00 ; AE90  metatiles $90-$9F
        .byte   $00,$00,$CD,$CE,$00,$DC,$00,$00,$00,$00,$CD,$00,$B9,$B9,$B9,$00 ; AEA0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEB0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$09,$0B,$0D,$0F,$00,$00 ; AEC0  metatiles $C0-$CF
        .byte   $00,$59,$01,$03,$05,$07,$5B,$00,$00,$79,$21,$23,$25,$27,$7B,$00 ; AED0  metatiles $D0-$DF
        .byte   $00,$00,$41,$43,$45,$00,$00,$00,$00,$00,$61,$63,$65,$67,$00,$00 ; AEE0  metatiles $E0-$EF
        .byte   $00,$6D,$29,$2B,$2D,$2F,$00,$00,$00,$00,$49,$4B,$4D,$4F,$00,$00 ; AEF0  metatiles $F0-$FF
; --- $AF00: metatile top-right tile ids ---
        .byte   $00,$0C,$0C,$9C,$14,$16,$00,$9E,$00,$98,$1C,$28,$34,$36,$3C,$3E ; AF00  metatiles $00-$0F
        .byte   $00,$98,$38,$3A,$28,$2A,$64,$66,$9A,$98,$78,$7E,$40,$42,$38,$3A ; AF10  metatiles $10-$1F
        .byte   $D0,$D2,$D4,$D6,$D8,$DA,$EC,$EE,$F0,$F2,$F4,$F6,$F8,$FA,$F4,$FE ; AF20  metatiles $20-$2F
        .byte   $2A,$90,$92,$94,$96,$48,$10,$10,$00,$B0,$B1,$B1,$B1,$68,$5A,$10 ; AF30  metatiles $30-$3F
        .byte   $D2,$D0,$D9,$90,$D0,$97,$48,$10,$F2,$F0,$F9,$B0,$F0,$B7,$B0,$B1 ; AF40  metatiles $40-$4F
        .byte   $D0,$D2,$D4,$D6,$D8,$DA,$10,$1E,$F0,$F2,$F4,$F6,$F8,$FA,$B1,$13 ; AF50  metatiles $50-$5F
        .byte   $DE,$90,$92,$94,$96,$EC,$EE,$00,$00,$B0,$B1,$B1,$B1,$F4,$FE,$00 ; AF60  metatiles $60-$6F
        .byte   $BA,$BC,$BC,$BE,$85,$00,$B4,$B2,$BA,$BC,$BC,$BE,$FA,$F0,$00,$00 ; AF70  metatiles $70-$7F
        .byte   $50,$52,$54,$56,$5C,$5E,$5C,$5E,$70,$72,$64,$66,$7C,$7E,$7C,$7E ; AF80  metatiles $80-$8F
        .byte   $40,$42,$21,$21,$22,$00,$3C,$3E,$00,$00,$00,$00,$22,$22,$00,$00 ; AF90  metatiles $90-$9F
        .byte   $58,$00,$DC,$DD,$DF,$B8,$DD,$00,$56,$4A,$DD,$B8,$00,$B8,$CD,$00 ; AFA0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$CD,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFB0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$47,$00,$00,$00,$00,$00,$18,$1A,$1C,$1E,$6F,$00 ; AFC0  metatiles $C0-$CF
        .byte   $00,$68,$10,$12,$14,$16,$6A,$00,$00,$7F,$30,$32,$34,$36,$00,$00 ; AFD0  metatiles $D0-$DF
        .byte   $00,$00,$50,$52,$54,$56,$00,$00,$00,$5C,$70,$72,$74,$76,$5E,$00 ; AFE0  metatiles $E0-$EF
        .byte   $00,$00,$38,$3A,$3C,$3E,$7E,$00,$00,$00,$00,$00,$22,$00,$00,$00 ; AFF0  metatiles $F0-$FF
; --- $B000: metatile bottom-right tile ids ---
        .byte   $00,$0D,$0D,$9D,$15,$17,$00,$9F,$82,$99,$1D,$29,$35,$37,$3D,$3F ; B000  metatiles $00-$0F
        .byte   $84,$99,$39,$3B,$29,$2B,$65,$67,$9B,$99,$79,$7F,$41,$43,$39,$3B ; B010  metatiles $10-$1F
        .byte   $D1,$D3,$D5,$D7,$D9,$DB,$ED,$EF,$F1,$F3,$F5,$F7,$F9,$FB,$FD,$FF ; B020  metatiles $20-$2F
        .byte   $2B,$91,$93,$95,$97,$10,$10,$49,$00,$B1,$B1,$B1,$B7,$10,$5B,$69 ; B030  metatiles $30-$3F
        .byte   $D9,$D2,$DB,$97,$90,$DB,$10,$49,$F9,$F2,$FB,$B7,$B0,$FB,$B1,$B7 ; B040  metatiles $40-$4F
        .byte   $D1,$D3,$D5,$D7,$D9,$DB,$10,$1F,$F1,$F3,$F5,$F7,$F9,$FB,$B1,$13 ; B050  metatiles $50-$5F
        .byte   $DF,$91,$93,$95,$97,$ED,$EF,$00,$00,$B1,$B1,$B1,$B7,$FD,$FF,$00 ; B060  metatiles $60-$6F
        .byte   $BB,$BD,$BD,$BF,$B2,$B3,$B5,$86,$BB,$BD,$BD,$BF,$FB,$F1,$00,$00 ; B070  metatiles $70-$7F
        .byte   $51,$53,$55,$57,$5D,$5F,$5D,$5F,$71,$73,$65,$67,$7D,$7F,$7D,$7F ; B080  metatiles $80-$8F
        .byte   $41,$43,$21,$21,$22,$00,$3D,$3F,$00,$00,$00,$00,$22,$22,$00,$00 ; B090  metatiles $90-$9F
        .byte   $00,$00,$DD,$DE,$00,$CC,$DE,$00,$00,$00,$DD,$DC,$00,$CC,$00,$00 ; B0A0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0B0  metatiles $B0-$BF
        .byte   $00,$00,$00,$40,$00,$00,$00,$00,$00,$6C,$19,$1B,$1D,$1F,$00,$00 ; B0C0  metatiles $C0-$CF
        .byte   $00,$69,$11,$14,$15,$17,$6B,$00,$00,$00,$31,$33,$35,$37,$7F,$00 ; B0D0  metatiles $D0-$DF
        .byte   $00,$00,$51,$53,$55,$57,$00,$00,$00,$5D,$71,$73,$75,$77,$5F,$00 ; B0E0  metatiles $E0-$EF
        .byte   $00,$7D,$39,$3B,$3D,$3F,$00,$00,$00,$00,$00,$13,$00,$00,$00,$00 ; B0F0  metatiles $F0-$FF
; --- $B100: metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$40,$20,$F1,$12,$12,$81,$13,$80,$82,$02,$82,$12,$12,$10,$10 ; B100  metatiles $00-$0F
        .byte   $80,$82,$03,$03,$03,$03,$82,$82,$82,$82,$73,$53,$03,$03,$82,$82 ; B110  metatiles $10-$1F
        .byte   $10,$10,$10,$10,$10,$10,$12,$12,$10,$10,$10,$10,$10,$10,$12,$12 ; B120  metatiles $20-$2F
        .byte   $82,$10,$10,$10,$10,$10,$10,$10,$00,$10,$10,$10,$10,$10,$10,$10 ; B130  metatiles $30-$3F
        .byte   $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10 ; B140  metatiles $40-$4F
        .byte   $11,$11,$11,$11,$11,$11,$10,$10,$11,$11,$11,$11,$11,$11,$10,$F0 ; B150  metatiles $50-$5F
        .byte   $00,$11,$11,$11,$11,$11,$11,$00,$00,$11,$11,$11,$11,$11,$11,$00 ; B160  metatiles $60-$6F
        .byte   $11,$11,$11,$11,$11,$11,$11,$11,$10,$10,$10,$10,$11,$11,$00,$00 ; B170  metatiles $70-$7F
        .byte   $03,$03,$03,$03,$03,$03,$82,$82,$03,$03,$03,$03,$03,$03,$82,$82 ; B180  metatiles $80-$8F
        .byte   $03,$03,$00,$00,$02,$00,$82,$82,$00,$00,$00,$00,$02,$02,$00,$00 ; B190  metatiles $90-$9F
        .byte   $80,$80,$82,$82,$83,$82,$82,$00,$80,$80,$82,$82,$82,$82,$82,$00 ; B1A0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$82,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1B0  metatiles $B0-$BF
        .byte   $00,$00,$00,$03,$03,$00,$00,$00,$00,$01,$01,$01,$01,$01,$01,$00 ; B1C0  metatiles $C0-$CF
        .byte   $00,$01,$03,$03,$03,$03,$01,$00,$00,$01,$02,$02,$02,$02,$01,$00 ; B1D0  metatiles $D0-$DF
        .byte   $00,$00,$03,$03,$03,$03,$00,$00,$00,$01,$02,$02,$02,$02,$01,$00 ; B1E0  metatiles $E0-$EF
        .byte   $00,$01,$01,$01,$01,$01,$01,$00,$00,$01,$01,$01,$01,$01,$00,$00 ; B1F0  metatiles $F0-$FF
; --- $B200: 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $25,$4F,$2D,$00,$5E,$4F,$00,$00,$25,$85,$2D,$8D,$84,$85,$8C,$8D ; B200  blocks $00-$03
        .byte   $84,$85,$8C,$78,$84,$85,$79,$7B,$20,$31,$28,$29,$32,$33,$2A,$2B ; B210  blocks $04-$07
        .byte   $34,$25,$2C,$2D,$20,$21,$28,$29,$22,$23,$2A,$2B,$24,$25,$2C,$2D ; B220  blocks $08-$0B
        .byte   $26,$27,$2E,$2F,$84,$85,$8C,$57,$44,$45,$49,$4A,$65,$66,$6D,$6E ; B230  blocks $0C-$0F
        .byte   $41,$42,$4C,$4D,$20,$31,$28,$39,$34,$25,$3C,$2D,$20,$21,$28,$39 ; B240  blocks $10-$13
        .byte   $22,$23,$3A,$3B,$85,$20,$57,$28,$31,$32,$39,$3A,$32,$33,$3A,$3B ; B250  blocks $14-$17
        .byte   $00,$00,$8C,$8D,$24,$25,$3C,$2D,$00,$20,$8C,$28,$84,$20,$8C,$28 ; B260  blocks $18-$1B
        .byte   $84,$85,$5F,$5F,$32,$34,$2A,$2C,$25,$85,$2D,$5F,$84,$85,$5F,$8D ; B270  blocks $1C-$1F
        .byte   $2A,$2B,$22,$23,$2C,$2D,$24,$25,$28,$29,$20,$21,$2A,$2C,$22,$24 ; B280  blocks $20-$23
        .byte   $2D,$8D,$25,$85,$8C,$28,$84,$20,$3A,$3B,$32,$33,$3C,$2D,$32,$33 ; B290  blocks $24-$27
        .byte   $28,$39,$34,$25,$3A,$3B,$00,$00,$3A,$3C,$00,$00,$2D,$8D,$00,$85 ; B2A0  blocks $28-$2B
        .byte   $8C,$8D,$84,$85,$8C,$8D,$20,$31,$8C,$8D,$32,$33,$8C,$28,$32,$33 ; B2B0  blocks $2C-$2F
        .byte   $5A,$5B,$52,$53,$5C,$7C,$54,$55,$06,$06,$96,$97,$7D,$59,$50,$51 ; B2C0  blocks $30-$33
        .byte   $5A,$5B,$65,$66,$5C,$5D,$54,$55,$8E,$8F,$86,$87,$58,$59,$50,$51 ; B2D0  blocks $34-$37
        .byte   $6D,$6E,$52,$53,$52,$53,$5A,$5B,$54,$55,$5C,$5D,$86,$87,$8E,$8F ; B2E0  blocks $38-$3B
        .byte   $50,$51,$58,$59,$52,$53,$6A,$6B,$54,$55,$6C,$5D,$50,$51,$58,$69 ; B2F0  blocks $3C-$3F
        .byte   $A1,$A1,$8E,$8F,$62,$63,$5A,$5B,$64,$55,$5C,$5D,$50,$61,$58,$59 ; B300  blocks $40-$43
        .byte   $A1,$30,$8E,$17,$A1,$A1,$A1,$A1,$A1,$A1,$A5,$A1,$A1,$09,$A1,$11 ; B310  blocks $44-$47
        .byte   $A1,$09,$AC,$11,$AB,$A1,$AD,$AE,$A1,$18,$A1,$11,$A4,$19,$A1,$11 ; B320  blocks $48-$4B
        .byte   $A5,$A1,$A5,$A1,$A1,$11,$A1,$11,$A1,$A1,$A1,$A5,$A1,$19,$A1,$11 ; B330  blocks $4C-$4F
        .byte   $A1,$A5,$A9,$A5,$A1,$18,$AC,$11,$A1,$11,$AC,$11,$A5,$A1,$AD,$AE ; B340  blocks $50-$53
        .byte   $A0,$A5,$A8,$AD,$A1,$11,$AC,$1B,$A1,$07,$A1,$09,$07,$A5,$A1,$A5 ; B350  blocks $54-$57
        .byte   $62,$64,$5A,$5C,$55,$A1,$5D,$A1,$A1,$A5,$A1,$A5,$52,$54,$5A,$5C ; B360  blocks $58-$5B
        .byte   $A0,$09,$A8,$11,$50,$55,$58,$5D,$70,$71,$03,$03,$71,$73,$03,$03 ; B370  blocks $5C-$5F
        .byte   $A1,$A1,$AC,$AC,$70,$71,$A1,$09,$71,$73,$A1,$A1,$71,$71,$A1,$A1 ; B380  blocks $60-$63
        .byte   $A4,$A1,$A1,$A1,$71,$73,$03,$09,$A4,$11,$AC,$11,$73,$A1,$A1,$A1 ; B390  blocks $64-$67
        .byte   $A1,$1B,$A1,$09,$1B,$A1,$A1,$A1,$A1,$19,$A9,$11,$1A,$11,$A1,$11 ; B3A0  blocks $68-$6B
        .byte   $A0,$11,$A8,$11,$6A,$6B,$A1,$09,$71,$71,$70,$71,$71,$73,$73,$03 ; B3B0  blocks $6C-$6F
        .byte   $A4,$70,$A1,$09,$71,$73,$A1,$09,$A1,$19,$70,$73,$A1,$11,$A1,$18 ; B3C0  blocks $70-$73
        .byte   $A1,$A1,$1B,$A1,$A1,$1A,$A1,$09,$6A,$6B,$A1,$A1,$6C,$5D,$A1,$A1 ; B3D0  blocks $74-$77
        .byte   $58,$69,$A1,$A1,$6A,$6B,$0B,$A1,$70,$71,$A1,$A1,$70,$73,$A1,$A1 ; B3E0  blocks $78-$7B
        .byte   $16,$87,$16,$8F,$71,$73,$A5,$A1,$50,$61,$58,$69,$64,$55,$6C,$5D ; B3F0  blocks $7C-$7F
        .byte   $02,$58,$02,$50,$6A,$6B,$A1,$70,$6C,$5D,$71,$73,$86,$70,$8E,$A1 ; B400  blocks $80-$83
        .byte   $86,$87,$8E,$70,$86,$87,$73,$70,$02,$58,$73,$70,$53,$54,$5B,$5C ; B410  blocks $84-$87
        .byte   $55,$02,$5D,$02,$71,$71,$A1,$70,$66,$54,$6E,$5C,$8E,$50,$86,$58 ; B420  blocks $88-$8B
        .byte   $53,$54,$6B,$6C,$62,$63,$6A,$6B,$01,$50,$02,$58,$70,$71,$14,$15 ; B430  blocks $8C-$8F
        .byte   $71,$73,$14,$15,$02,$50,$02,$58,$3A,$3B,$25,$15,$3A,$3B,$14,$15 ; B440  blocks $90-$93
        .byte   $3C,$2D,$14,$15,$14,$15,$8A,$8B,$2D,$8B,$25,$8B,$8A,$8B,$82,$83 ; B450  blocks $94-$97
        .byte   $8A,$8B,$8A,$8B,$5D,$1F,$55,$17,$1E,$1F,$16,$17,$5D,$17,$63,$64 ; B460  blocks $98-$9B
        .byte   $16,$17,$55,$01,$16,$17,$50,$61,$16,$17,$62,$63,$5B,$5C,$66,$54 ; B470  blocks $9C-$9F
        .byte   $5D,$02,$55,$02,$6E,$5C,$53,$54,$28,$39,$1C,$1D,$1C,$1D,$90,$91 ; B480  blocks $A0-$A3
        .byte   $90,$91,$90,$91,$80,$81,$88,$89,$8A,$8B,$20,$46,$90,$91,$56,$56 ; B490  blocks $A4-$A7
        .byte   $16,$17,$64,$55,$28,$4E,$20,$35,$5E,$5E,$36,$36,$20,$46,$28,$4E ; B4A0  blocks $A8-$AB
        .byte   $47,$25,$4F,$2D,$3A,$3B,$1C,$1D,$3C,$2D,$1C,$1D,$14,$20,$8A,$28 ; B4B0  blocks $AC-$AF
        .byte   $8A,$20,$8A,$28,$8A,$8B,$47,$25,$4F,$2D,$37,$25,$8A,$8B,$20,$31 ; B4C0  blocks $B0-$B3
        .byte   $90,$91,$32,$33,$90,$91,$34,$25,$2A,$2B,$65,$66,$6D,$6E,$22,$23 ; B4D0  blocks $B4-$B7
        .byte   $78,$79,$14,$15,$79,$7B,$14,$15,$25,$15,$2D,$8B,$25,$8B,$2D,$8B ; B4E0  blocks $B8-$BB
        .byte   $82,$83,$8A,$8B,$8A,$8B,$8A,$57,$8A,$8B,$57,$57,$8A,$8B,$5F,$5F ; B4F0  blocks $BC-$BF
        .byte   $56,$56,$5E,$5E,$78,$7B,$57,$57,$78,$7B,$14,$15,$8A,$15,$8A,$8B ; B500  blocks $C0-$C3
        .byte   $8A,$8B,$32,$33,$2D,$8B,$20,$31,$8A,$8B,$34,$25,$43,$25,$4B,$2D ; B510  blocks $C4-$C7
        .byte   $00,$00,$84,$85,$00,$20,$84,$28,$46,$56,$4E,$5E,$8C,$20,$84,$28 ; B520  blocks $C8-$CB
        .byte   $8C,$8D,$78,$7B,$28,$4E,$00,$00,$2D,$02,$00,$02,$84,$8D,$8C,$8D ; B530  blocks $CC-$CF
        .byte   $84,$02,$8C,$02,$84,$85,$20,$31,$78,$79,$34,$25,$79,$79,$22,$23 ; B540  blocks $D0-$D3
        .byte   $28,$39,$32,$33,$3C,$2D,$34,$25,$84,$85,$32,$33,$2A,$2B,$32,$33 ; B550  blocks $D4-$D7
        .byte   $2A,$2B,$26,$27,$00,$00,$00,$00,$2E,$2F,$22,$23,$02,$15,$02,$8B ; B560  blocks $D8-$DB
        .byte   $02,$8B,$02,$8B,$02,$8B,$57,$8B,$56,$47,$5E,$4F,$25,$8B,$2D,$5F ; B570  blocks $DC-$DF
        .byte   $20,$43,$28,$4B,$25,$01,$2D,$02,$25,$02,$2D,$02,$78,$7B,$78,$7B ; B580  blocks $E0-$E3
        .byte   $04,$05,$0C,$0D,$78,$79,$1C,$1D,$79,$7B,$78,$7B,$78,$7B,$1C,$0A ; B590  blocks $E4-$E7
        .byte   $90,$0A,$90,$0A,$01,$20,$02,$28,$02,$78,$02,$15,$79,$7B,$14,$0A ; B5A0  blocks $E8-$EB
        .byte   $8A,$0A,$8A,$0A,$00,$00,$00,$C3,$00,$00,$C4,$00,$00,$C9,$00,$D1 ; B5B0  blocks $EC-$EF
        .byte   $CA,$CB,$D2,$D3,$CC,$CD,$D4,$D5,$CE,$00,$D6,$00,$00,$D9,$00,$00 ; B5C0  blocks $F0-$F3
        .byte   $DA,$DB,$E2,$E3,$DC,$DD,$E4,$E5,$DE,$00,$00,$00,$00,$E9,$00,$F1 ; B5D0  blocks $F4-$F7
        .byte   $EA,$EB,$F2,$F3,$EC,$ED,$F4,$F5,$EE,$00,$F6,$00,$FA,$FB,$00,$00 ; B5E0  blocks $F8-$FB
        .byte   $FC,$FD,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B5F0  blocks $FC-$FF
; --- $B600: screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$01,$01,$01,$01,$01,$01,$01,$02,$03,$03,$03,$03,$03,$03,$03 ; B600
        .byte   $02,$03,$03,$03,$03,$03,$03,$03,$02,$03,$03,$03,$03,$03,$03,$03 ; B610
        .byte   $02,$03,$03,$03,$03,$03,$03,$03,$02,$03,$03,$03,$03,$03,$04,$05 ; B620
        .byte   $06,$07,$07,$07,$07,$08,$06,$07,$09,$0A,$0A,$0A,$0A,$0B,$09,$0A ; B630
; layout $01
        .byte   $01,$01,$01,$01,$01,$01,$09,$0C,$03,$03,$03,$03,$03,$03,$09,$0A ; B640
        .byte   $03,$03,$03,$0D,$0E,$03,$09,$0F,$03,$03,$0D,$0E,$10,$03,$09,$0A ; B650
        .byte   $04,$05,$11,$12,$0E,$03,$13,$14,$15,$16,$17,$12,$10,$03,$18,$18 ; B660
        .byte   $07,$07,$07,$08,$06,$07,$07,$07,$0A,$0A,$0A,$0B,$09,$0A,$0A,$0A ; B670
; layout $02
        .byte   $0B,$09,$0F,$0A,$0A,$0F,$0A,$0F,$0B,$09,$0A,$0F,$0A,$0F,$0A,$0A ; B680
        .byte   $0B,$09,$0A,$0A,$0A,$0A,$0A,$0A,$0B,$11,$17,$12,$10,$11,$17,$12 ; B690
        .byte   $19,$18,$18,$18,$18,$18,$18,$1A,$18,$03,$03,$03,$03,$03,$03,$1B ; B6A0
        .byte   $07,$08,$1C,$06,$1D,$1E,$1F,$1B,$0A,$0B,$06,$07,$07,$1D,$02,$1B ; B6B0
; layout $03
        .byte   $20,$21,$22,$20,$20,$23,$24,$25,$26,$27,$28,$29,$29,$2A,$2B,$25 ; B6C0
        .byte   $20,$20,$21,$2C,$2D,$2E,$2E,$2F,$20,$20,$21,$2C,$22,$20,$20,$20 ; B6D0
        .byte   $30,$30,$31,$32,$33,$30,$30,$30,$34,$30,$35,$36,$37,$34,$30,$30 ; B6E0
        .byte   $38,$34,$35,$36,$37,$38,$30,$34,$30,$38,$35,$36,$37,$30,$30,$38 ; B6F0
; layout $04
        .byte   $39,$39,$3A,$3B,$3C,$39,$39,$0F,$3D,$3D,$3E,$3B,$3F,$3D,$3D,$3D ; B700
        .byte   $39,$3A,$40,$3B,$40,$3C,$39,$0F,$41,$41,$42,$3B,$43,$41,$41,$41 ; B710
        .byte   $39,$0F,$3A,$3B,$3F,$3D,$3D,$3D,$0F,$39,$3A,$3B,$44,$45,$46,$47 ; B720
        .byte   $0F,$39,$3A,$43,$41,$41,$41,$41,$39,$39,$3A,$3C,$0F,$0F,$0F,$0F ; B730
; layout $05
        .byte   $3A,$3F,$3D,$3D,$3E,$3C,$39,$0F,$3E,$48,$48,$49,$48,$3F,$3D,$3D ; B740
        .byte   $3A,$4A,$4B,$4C,$4D,$47,$4E,$47,$42,$4F,$4D,$4C,$4F,$4D,$50,$4A ; B750
        .byte   $3E,$51,$52,$53,$52,$51,$54,$55,$46,$4D,$4A,$4C,$56,$4A,$57,$47 ; B760
        .byte   $41,$41,$58,$59,$4F,$4A,$5A,$4F,$0F,$0F,$5B,$59,$4F,$4F,$5A,$4F ; B770
; layout $06
        .byte   $39,$0F,$3A,$3C,$39,$0F,$0F,$39,$3D,$3D,$3E,$3F,$3D,$3D,$3D,$3D ; B780
        .byte   $5C,$4E,$45,$47,$3F,$3D,$3D,$3D,$4B,$50,$45,$4D,$5D,$5E,$5F,$5E ; B790
        .byte   $51,$54,$60,$51,$49,$5C,$60,$49,$4A,$57,$45,$61,$62,$61,$63,$62 ; B7A0
        .byte   $4F,$5A,$45,$4F,$4C,$4A,$64,$4C,$4F,$5A,$45,$4F,$4C,$4F,$45,$4C ; B7B0
; layout $07
        .byte   $0F,$39,$39,$0F,$39,$39,$39,$39,$3D,$3D,$3D,$3D,$3D,$3D,$3D,$3D ; B7C0
        .byte   $3E,$5E,$5F,$3F,$3D,$3D,$3E,$5E,$65,$46,$47,$5C,$46,$47,$47,$46 ; B7D0
        .byte   $51,$53,$51,$66,$53,$52,$52,$53,$61,$67,$68,$4F,$4C,$4F,$4A,$69 ; B7E0
        .byte   $4F,$4C,$6A,$4A,$69,$4A,$6B,$4C,$4F,$4C,$6C,$4D,$4C,$4D,$4F,$4C ; B7F0
; layout $08
        .byte   $0F,$39,$3A,$3C,$3A,$30,$30,$30,$3D,$3D,$3E,$3F,$3E,$6D,$6D,$6D ; B800
        .byte   $6E,$6F,$5E,$63,$67,$4A,$4B,$4F,$47,$47,$5C,$45,$4C,$4A,$70,$71 ; B810
        .byte   $52,$51,$66,$60,$53,$72,$72,$72,$68,$4D,$73,$74,$4C,$47,$47,$61 ; B820
        .byte   $6A,$75,$4D,$45,$4C,$4D,$4D,$4D,$6C,$4F,$4F,$45,$4C,$4F,$4D,$4F ; B830
; layout $09
        .byte   $30,$30,$30,$30,$35,$37,$30,$34,$76,$6D,$76,$6D,$77,$37,$30,$38 ; B840
        .byte   $4C,$4D,$4C,$4D,$45,$78,$76,$79,$7A,$71,$7B,$4F,$45,$4C,$45,$7C ; B850
        .byte   $53,$51,$53,$51,$60,$53,$60,$7C,$7D,$61,$62,$61,$67,$4C,$45,$7C ; B860
        .byte   $4C,$4A,$4C,$4A,$64,$4C,$43,$42,$4C,$4D,$4C,$4F,$45,$4C,$3C,$3A ; B870
; layout $0A
        .byte   $30,$34,$30,$35,$3F,$3D,$3D,$3E,$30,$38,$30,$35,$40,$40,$40,$40 ; B880
        .byte   $76,$76,$76,$77,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B ; B890
        .byte   $3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$3B ; B8A0
        .byte   $3B,$3B,$43,$42,$43,$41,$41,$41,$3B,$3B,$3C,$3A,$3C,$39,$39,$39 ; B8B0
; layout $0B
        .byte   $7E,$7F,$37,$30,$30,$30,$35,$80,$40,$40,$78,$76,$76,$81,$82,$80 ; B8C0
        .byte   $3B,$3B,$3B,$3B,$3B,$83,$62,$80,$3B,$3B,$3B,$3B,$3B,$3B,$3B,$80 ; B8D0
        .byte   $3B,$3B,$3B,$3B,$3B,$84,$85,$86,$3B,$3B,$43,$41,$41,$41,$41,$41 ; B8E0
        .byte   $41,$42,$3C,$0F,$39,$39,$0F,$39,$39,$3A,$3C,$39,$39,$39,$39,$39 ; B8F0
; layout $0C
        .byte   $87,$88,$3F,$3D,$3D,$3D,$3D,$3D,$87,$88,$7A,$62,$7A,$62,$7A,$89 ; B900
        .byte   $8A,$88,$36,$36,$36,$36,$36,$8B,$8A,$88,$36,$36,$36,$36,$36,$8B ; B910
        .byte   $8C,$88,$36,$36,$36,$36,$36,$8B,$8D,$8D,$7F,$36,$36,$36,$36,$8B ; B920
        .byte   $39,$39,$43,$41,$41,$41,$42,$8E,$8F,$90,$3C,$0F,$39,$0F,$3A,$91 ; B930
; layout $0D
        .byte   $20,$20,$20,$21,$13,$14,$14,$14,$92,$93,$93,$94,$95,$95,$95,$95 ; B940
        .byte   $96,$97,$97,$97,$98,$97,$98,$98,$96,$98,$98,$98,$97,$98,$98,$97 ; B950
        .byte   $99,$9A,$9A,$9A,$9A,$9A,$9A,$9A,$9B,$9C,$9D,$9E,$9E,$9E,$9E,$9E ; B960
        .byte   $9F,$A0,$37,$30,$34,$30,$30,$34,$A1,$A0,$37,$30,$38,$30,$30,$38 ; B970
; layout $0E
        .byte   $14,$14,$19,$09,$0A,$0A,$0B,$22,$95,$95,$95,$13,$14,$14,$19,$A2 ; B980
        .byte   $98,$98,$97,$95,$A3,$95,$95,$A4,$98,$98,$98,$98,$A5,$98,$98,$A5 ; B990
        .byte   $9A,$9A,$06,$07,$07,$08,$A6,$A7,$9E,$A8,$09,$0A,$0A,$0B,$A9,$AA ; B9A0
        .byte   $30,$35,$09,$0A,$0A,$0B,$A9,$AA,$30,$35,$09,$0A,$0A,$0B,$A9,$AA ; B9B0
; layout $0F
        .byte   $20,$20,$20,$21,$AB,$AC,$09,$0F,$93,$93,$AD,$AE,$AB,$AC,$13,$14 ; B9C0
        .byte   $98,$98,$A4,$A5,$A3,$95,$95,$AF,$98,$98,$A5,$A4,$A5,$98,$98,$B0 ; B9D0
        .byte   $B1,$98,$A5,$A5,$A4,$98,$98,$B0,$B2,$B3,$B4,$B5,$A4,$98,$98,$B0 ; B9E0
        .byte   $B2,$22,$B6,$21,$AB,$AC,$98,$B0,$B2,$22,$B7,$21,$B8,$B9,$98,$B0 ; B9F0
; layout $10
        .byte   $AC,$13,$14,$19,$AB,$AC,$98,$B0,$AC,$10,$B8,$B9,$95,$95,$98,$B0 ; BA00
        .byte   $BA,$95,$98,$98,$98,$98,$98,$B0,$BB,$BC,$BD,$BE,$0E,$BF,$AB,$C0 ; BA10
        .byte   $BB,$BD,$C1,$C1,$B8,$B9,$C2,$B8,$BB,$C3,$95,$95,$BC,$98,$B3,$C4 ; BA20
        .byte   $C5,$C4,$C4,$C4,$C4,$C6,$22,$20,$22,$20,$20,$20,$20,$21,$22,$20 ; BA30
; layout $11
        .byte   $16,$12,$11,$17,$12,$AB,$C0,$AC,$16,$12,$95,$95,$95,$95,$95,$95 ; BA40
        .byte   $C7,$C2,$BC,$BC,$98,$98,$98,$98,$AC,$BC,$BC,$BC,$98,$98,$98,$98 ; BA50
        .byte   $B9,$BC,$BC,$BC,$98,$98,$98,$98,$C4,$C6,$BC,$BC,$98,$98,$98,$98 ; BA60
        .byte   $20,$21,$BF,$AB,$C0,$AC,$11,$17,$20,$21,$11,$12,$11,$12,$C2,$B8 ; BA70
; layout $12
        .byte   $11,$17,$12,$09,$0C,$0B,$11,$17,$A3,$95,$A3,$13,$14,$19,$11,$17 ; BA80
        .byte   $A5,$98,$A4,$A3,$C8,$C8,$C9,$CA,$A5,$98,$A5,$A4,$2C,$2C,$CB,$CA ; BA90
        .byte   $A4,$98,$A5,$A5,$2C,$2C,$2C,$11,$A4,$98,$A4,$A5,$2C,$2C,$2C,$11 ; BAA0
        .byte   $12,$11,$17,$12,$CC,$2C,$CC,$11,$B9,$B8,$B9,$B8,$B9,$2C,$B8,$B9 ; BAB0
; layout $13
        .byte   $07,$07,$07,$07,$08,$03,$11,$17,$0C,$0A,$0A,$0C,$0B,$03,$18,$18 ; BAC0
        .byte   $14,$14,$14,$14,$19,$03,$03,$03,$07,$07,$07,$08,$18,$03,$03,$03 ; BAD0
        .byte   $0C,$0A,$0C,$0B,$03,$03,$03,$03,$0A,$0C,$0A,$0B,$03,$03,$03,$03 ; BAE0
        .byte   $0A,$0C,$0A,$0B,$06,$07,$07,$08,$0A,$0A,$0A,$0B,$09,$0C,$0C,$0B ; BAF0
; layout $14
        .byte   $17,$17,$17,$12,$CD,$01,$CE,$09,$18,$18,$18,$18,$CF,$03,$D0,$09 ; BB00
        .byte   $03,$03,$03,$03,$03,$D1,$D2,$D3,$03,$03,$03,$03,$D1,$D4,$D5,$20 ; BB10
        .byte   $03,$03,$03,$D1,$D4,$26,$D5,$20,$03,$D1,$D6,$D4,$26,$26,$27,$D7 ; BB20
        .byte   $03,$22,$20,$D8,$20,$20,$D8,$20,$D9,$22,$20,$DA,$20,$20,$DA,$20 ; BB30
; layout $15
        .byte   $98,$DB,$95,$95,$95,$A3,$A3,$09,$98,$DC,$BC,$98,$98,$A5,$A5,$09 ; BB40
        .byte   $BE,$DD,$98,$98,$98,$A5,$A5,$09,$DE,$BB,$BC,$98,$98,$A4,$A4,$09 ; BB50
        .byte   $DE,$BB,$BC,$98,$98,$A5,$A5,$09,$DE,$BB,$BC,$98,$98,$A5,$A5,$09 ; BB60
        .byte   $DE,$DF,$BF,$BF,$BF,$E0,$E1,$09,$B8,$B9,$B8,$B9,$AB,$DE,$E2,$B8 ; BB70
; layout $16
        .byte   $98,$AB,$AC,$13,$14,$19,$AB,$AC,$BC,$95,$95,$95,$95,$A3,$AB,$AC ; BB80
        .byte   $BC,$98,$BC,$98,$98,$A5,$E3,$E4,$98,$98,$98,$98,$98,$A5,$E5,$E6 ; BB90
        .byte   $BC,$98,$BC,$98,$98,$A4,$A4,$E7,$BC,$98,$BC,$98,$06,$08,$A4,$E8 ; BBA0
        .byte   $98,$E9,$CA,$AC,$AB,$AC,$06,$08,$98,$EA,$B9,$B8,$B9,$B8,$B9,$C2 ; BBB0
; layout $17
        .byte   $09,$0B,$09,$0A,$0C,$0B,$09,$0B,$09,$0B,$09,$0C,$0A,$0B,$09,$0B ; BBC0
        .byte   $09,$0B,$09,$0C,$0A,$0B,$09,$0B,$AB,$AC,$13,$14,$14,$19,$AB,$AC ; BBD0
        .byte   $B8,$B9,$B8,$B9,$B8,$B9,$B8,$EB,$98,$BC,$98,$BC,$98,$98,$98,$EC ; BBE0
        .byte   $06,$08,$06,$07,$07,$08,$AB,$AC,$09,$0B,$09,$0C,$0A,$0B,$AB,$AC ; BBF0
; layout $18
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BC00
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BC10
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BC20
        .byte   $06,$07,$07,$08,$06,$07,$07,$08,$09,$0A,$0A,$0B,$09,$0A,$0A,$0B ; BC30
; layout $19
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BC40
        .byte   $D9,$D9,$D9,$ED,$EE,$D9,$D9,$D9,$D9,$D9,$EF,$F0,$F1,$F2,$D9,$D9 ; BC50
        .byte   $D9,$D9,$F3,$F4,$F5,$F6,$D9,$D9,$D9,$D9,$F7,$F8,$F9,$FA,$D9,$D9 ; BC60
        .byte   $D9,$D9,$D9,$FB,$FC,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BC70
; layout $1A
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BC80
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BC90
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BCA0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BCB0
; layout $1B
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BCC0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BCD0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BCE0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BCF0
; layout $1C
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BD00
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BD10
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BD20
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BD30
; layout $1D
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BD40
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BD50
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BD60
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BD70
; layout $1E
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BD80
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BD90
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BDA0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BDB0
; layout $1F
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BDC0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BDD0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BDE0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BDF0
; layout $20
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BE00
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BE10
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BE20
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BE30
; layout $21
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BE40
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BE50
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BE60
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BE70
; layout $22
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BE80
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BE90
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BEA0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BEB0
; layout $23
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BEC0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BED0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BEE0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BEF0
; layout $24
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BF00
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BF10
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BF20
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BF30
; layout $25
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BF40
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BF50
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BF60
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BF70
; layout $26
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BF80
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BF90
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BFA0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BFB0
; layout $27
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BFC0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BFD0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BFE0
        .byte   $D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9,$D9 ; BFF0
