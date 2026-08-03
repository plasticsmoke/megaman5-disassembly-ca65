.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK0D"

; =============================================================================
; BANK $0D (mapped at $A000) — raw da65 disassembly, annotation in progress
; SKELETON — raw ROM bytes, not yet classified as code or data.
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
; $A26F-$A7FF: data, TBD (unreferenced in-bank)
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
        brk                                     ; A810 00                       .
        brk                                     ; A811 00                       .
        brk                                     ; A812 00                       .
        brk                                     ; A813 00                       .
        brk                                     ; A814 00                       .
        brk                                     ; A815 00                       .
        brk                                     ; A816 00                       .
        brk                                     ; A817 00                       .
        brk                                     ; A818 00                       .
        brk                                     ; A819 00                       .
        brk                                     ; A81A 00                       .
        brk                                     ; A81B 00                       .
        brk                                     ; A81C 00                       .
        brk                                     ; A81D 00                       .
        brk                                     ; A81E 00                       .
        brk                                     ; A81F 00                       .
        brk                                     ; A820 00                       .
        brk                                     ; A821 00                       .
        brk                                     ; A822 00                       .
        brk                                     ; A823 00                       .
        brk                                     ; A824 00                       .
        brk                                     ; A825 00                       .
        brk                                     ; A826 00                       .
        brk                                     ; A827 00                       .
        brk                                     ; A828 00                       .
        brk                                     ; A829 00                       .
        brk                                     ; A82A 00                       .
        brk                                     ; A82B 00                       .
        brk                                     ; A82C 00                       .
        brk                                     ; A82D 00                       .
        brk                                     ; A82E 00                       .
        brk                                     ; A82F 00                       .
        brk                                     ; A830 00                       .
        brk                                     ; A831 00                       .
        brk                                     ; A832 00                       .
        brk                                     ; A833 00                       .
        brk                                     ; A834 00                       .
        brk                                     ; A835 00                       .
        brk                                     ; A836 00                       .
        brk                                     ; A837 00                       .
        brk                                     ; A838 00                       .
        brk                                     ; A839 00                       .
        brk                                     ; A83A 00                       .
        brk                                     ; A83B 00                       .
        brk                                     ; A83C 00                       .
        brk                                     ; A83D 00                       .
        brk                                     ; A83E 00                       .
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
        brk                                     ; A84F 00                       .
        brk                                     ; A850 00                       .
        brk                                     ; A851 00                       .
        brk                                     ; A852 00                       .
        brk                                     ; A853 00                       .
        brk                                     ; A854 00                       .
        brk                                     ; A855 00                       .
        brk                                     ; A856 00                       .
        brk                                     ; A857 00                       .
        brk                                     ; A858 00                       .
        brk                                     ; A859 00                       .
        brk                                     ; A85A 00                       .
        brk                                     ; A85B 00                       .
        brk                                     ; A85C 00                       .
        brk                                     ; A85D 00                       .
        brk                                     ; A85E 00                       .
        brk                                     ; A85F 00                       .
        brk                                     ; A860 00                       .
        brk                                     ; A861 00                       .
        brk                                     ; A862 00                       .
        brk                                     ; A863 00                       .
        brk                                     ; A864 00                       .
        brk                                     ; A865 00                       .
        brk                                     ; A866 00                       .
        brk                                     ; A867 00                       .
LA868:  brk                                     ; A868 00                       .
        brk                                     ; A869 00                       .
        brk                                     ; A86A 00                       .
LA86B:  brk                                     ; A86B 00                       .
        brk                                     ; A86C 00                       .
        brk                                     ; A86D 00                       .
        brk                                     ; A86E 00                       .
        brk                                     ; A86F 00                       .
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
        brk                                     ; A87B 00                       .
        brk                                     ; A87C 00                       .
        brk                                     ; A87D 00                       .
        brk                                     ; A87E 00                       .
        brk                                     ; A87F 00                       .
        brk                                     ; A880 00                       .
        brk                                     ; A881 00                       .
        brk                                     ; A882 00                       .
        brk                                     ; A883 00                       .
        brk                                     ; A884 00                       .
        brk                                     ; A885 00                       .
        brk                                     ; A886 00                       .
        brk                                     ; A887 00                       .
        brk                                     ; A888 00                       .
        brk                                     ; A889 00                       .
        brk                                     ; A88A 00                       .
        brk                                     ; A88B 00                       .
        brk                                     ; A88C 00                       .
        brk                                     ; A88D 00                       .
        brk                                     ; A88E 00                       .
        brk                                     ; A88F 00                       .
        brk                                     ; A890 00                       .
        brk                                     ; A891 00                       .
        brk                                     ; A892 00                       .
        brk                                     ; A893 00                       .
        brk                                     ; A894 00                       .
        brk                                     ; A895 00                       .
        brk                                     ; A896 00                       .
        brk                                     ; A897 00                       .
        brk                                     ; A898 00                       .
        brk                                     ; A899 00                       .
        brk                                     ; A89A 00                       .
        brk                                     ; A89B 00                       .
        brk                                     ; A89C 00                       .
        brk                                     ; A89D 00                       .
        brk                                     ; A89E 00                       .
        brk                                     ; A89F 00                       .
        brk                                     ; A8A0 00                       .
        brk                                     ; A8A1 00                       .
        brk                                     ; A8A2 00                       .
        brk                                     ; A8A3 00                       .
        brk                                     ; A8A4 00                       .
        brk                                     ; A8A5 00                       .
        brk                                     ; A8A6 00                       .
        brk                                     ; A8A7 00                       .
        brk                                     ; A8A8 00                       .
        brk                                     ; A8A9 00                       .
        brk                                     ; A8AA 00                       .
        brk                                     ; A8AB 00                       .
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
        brk                                     ; A8BD 00                       .
        brk                                     ; A8BE 00                       .
        brk                                     ; A8BF 00                       .
        brk                                     ; A8C0 00                       .
        brk                                     ; A8C1 00                       .
        brk                                     ; A8C2 00                       .
        brk                                     ; A8C3 00                       .
        brk                                     ; A8C4 00                       .
        brk                                     ; A8C5 00                       .
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
        ora     $06                             ; A905 05 06                    ..
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
        ora     $16,x                           ; A915 15 16                    ..
        .byte   $17                             ; A917 17                       .
        clc                                     ; A918 18                       .
        ora     L0000,y                         ; A919 19 00 00                 ...
        brk                                     ; A91C 00                       .
        brk                                     ; A91D 00                       .
        brk                                     ; A91E 00                       .
        brk                                     ; A91F 00                       .
        brk                                     ; A920 00                       .
        brk                                     ; A921 00                       .
        brk                                     ; A922 00                       .
LA923:  jsr     L0008                           ; A923 20 08 00                  ..
        ldy     #$24                            ; A926 A0 24                    .$
        brk                                     ; A928 00                       .
        .byte   $1A                             ; A929 1A                       .
        brk                                     ; A92A 00                       .
        sty     L0000                           ; A92B 84 00                    ..
        brk                                     ; A92D 00                       .
        .byte   $02                             ; A92E 02                       .
        brk                                     ; A92F 00                       .
        brk                                     ; A930 00                       .
        brk                                     ; A931 00                       .
        brk                                     ; A932 00                       .
        brk                                     ; A933 00                       .
        brk                                     ; A934 00                       .
        brk                                     ; A935 00                       .
        brk                                     ; A936 00                       .
        brk                                     ; A937 00                       .
        brk                                     ; A938 00                       .
        brk                                     ; A939 00                       .
        brk                                     ; A93A 00                       .
        brk                                     ; A93B 00                       .
        brk                                     ; A93C 00                       .
        brk                                     ; A93D 00                       .
        brk                                     ; A93E 00                       .
        brk                                     ; A93F 00                       .
        .byte   $80                             ; A940 80                       .
        php                                     ; A941 08                       .
        brk                                     ; A942 00                       .
        brk                                     ; A943 00                       .
        brk                                     ; A944 00                       .
        bpl     LA947                           ; A945 10 00                    ..
LA947:  ora     (L0000,x)                       ; A947 01 00                    ..
        ora     (L0000,x)                       ; A949 01 00                    ..
        brk                                     ; A94B 00                       .
        brk                                     ; A94C 00                       .
        brk                                     ; A94D 00                       .
        brk                                     ; A94E 00                       .
        brk                                     ; A94F 00                       .
        .byte   $22                             ; A950 22                       "
        rti                                     ; A951 40                       @

; ----------------------------------------------------------------------------
        .byte   $67                             ; A952 67                       g
        .byte   $80                             ; A953 80                       .
        ldx     #$62                            ; A954 A2 62                    .b
        adc     (L0080,x)                       ; A956 61 80                    a.
        ldy     #$20                            ; A958 A0 20                    . 
        jsr     L0000                           ; A95A 20 00 00                  ..
        brk                                     ; A95D 00                       .
        brk                                     ; A95E 00                       .
        brk                                     ; A95F 00                       .
        brk                                     ; A960 00                       .
        brk                                     ; A961 00                       .
        clc                                     ; A962 18                       .
        brk                                     ; A963 00                       .
        brk                                     ; A964 00                       .
        cpy     #$00                            ; A965 C0 00                    ..
        rti                                     ; A967 40                       @

; ----------------------------------------------------------------------------
        ora     #$00                            ; A968 09 00                    ..
        .byte   $07                             ; A96A 07                       .
        .byte   $07                             ; A96B 07                       .
        .byte   $07                             ; A96C 07                       .
        .byte   $1C                             ; A96D 1C                       .
        ora     $3131,y                         ; A96E 19 31 31                 .11
        .byte   $80                             ; A971 80                       .
        .byte   $80                             ; A972 80                       .
        brk                                     ; A973 00                       .
        brk                                     ; A974 00                       .
        .byte   $04                             ; A975 04                       .
        brk                                     ; A976 00                       .
        brk                                     ; A977 00                       .
        brk                                     ; A978 00                       .
        brk                                     ; A979 00                       .
        brk                                     ; A97A 00                       .
        brk                                     ; A97B 00                       .
        brk                                     ; A97C 00                       .
        brk                                     ; A97D 00                       .
        brk                                     ; A97E 00                       .
        brk                                     ; A97F 00                       .
        ldy     $B6,x                           ; A980 B4 B6                    ..
        php                                     ; A982 08                       .
        brk                                     ; A983 00                       .
        .byte   $02                             ; A984 02                       .
        brk                                     ; A985 00                       .
        jsr     L0F00                           ; A986 20 00 0F                  ..
        bmi     LA99B                           ; A989 30 10                    0.
        .byte   $1C                             ; A98B 1C                       .
        .byte   $0F                             ; A98C 0F                       .
        and     ($21),y                         ; A98D 31 21                    1!
        ora     ($0F),y                         ; A98F 11 0F                    ..
        .byte   $1C                             ; A991 1C                       .
        ora     ($01),y                         ; A992 11 01                    ..
        .byte   $0F                             ; A994 0F                       .
        .byte   $17                             ; A995 17                       .
        .byte   $14                             ; A996 14                       .
        .byte   $04                             ; A997 04                       .
        brk                                     ; A998 00                       .
        brk                                     ; A999 00                       .
        brk                                     ; A99A 00                       .
LA99B:  brk                                     ; A99B 00                       .
        brk                                     ; A99C 00                       .
        brk                                     ; A99D 00                       .
        brk                                     ; A99E 00                       .
        brk                                     ; A99F 00                       .
        brk                                     ; A9A0 00                       .
        brk                                     ; A9A1 00                       .
        php                                     ; A9A2 08                       .
        brk                                     ; A9A3 00                       .
        brk                                     ; A9A4 00                       .
        rti                                     ; A9A5 40                       @

; ----------------------------------------------------------------------------
        dey                                     ; A9A6 88                       .
        rti                                     ; A9A7 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; A9A8 00                       .
        .byte   $02                             ; A9A9 02                       .
        brk                                     ; A9AA 00                       .
        .byte   $80                             ; A9AB 80                       .
        brk                                     ; A9AC 00                       .
        php                                     ; A9AD 08                       .
        .byte   $02                             ; A9AE 02                       .
        brk                                     ; A9AF 00                       .
        brk                                     ; A9B0 00                       .
        .byte   $02                             ; A9B1 02                       .
        brk                                     ; A9B2 00                       .
        brk                                     ; A9B3 00                       .
        brk                                     ; A9B4 00                       .
        brk                                     ; A9B5 00                       .
        brk                                     ; A9B6 00                       .
        brk                                     ; A9B7 00                       .
        brk                                     ; A9B8 00                       .
        brk                                     ; A9B9 00                       .
        brk                                     ; A9BA 00                       .
        brk                                     ; A9BB 00                       .
        brk                                     ; A9BC 00                       .
        brk                                     ; A9BD 00                       .
        brk                                     ; A9BE 00                       .
        brk                                     ; A9BF 00                       .
        jsr     L0000                           ; A9C0 20 00 00                  ..
        brk                                     ; A9C3 00                       .
        brk                                     ; A9C4 00                       .
        ora     ($02,x)                         ; A9C5 01 02                    ..
        brk                                     ; A9C7 00                       .
        brk                                     ; A9C8 00                       .
        bpl     LA9CB                           ; A9C9 10 00                    ..
LA9CB:  ora     ($20,x)                         ; A9CB 01 20                    . 
        ora     (L0000,x)                       ; A9CD 01 00                    ..
        brk                                     ; A9CF 00                       .
        brk                                     ; A9D0 00                       .
        brk                                     ; A9D1 00                       .
        brk                                     ; A9D2 00                       .
        brk                                     ; A9D3 00                       .
        brk                                     ; A9D4 00                       .
        brk                                     ; A9D5 00                       .
        brk                                     ; A9D6 00                       .
        brk                                     ; A9D7 00                       .
        brk                                     ; A9D8 00                       .
        brk                                     ; A9D9 00                       .
        brk                                     ; A9DA 00                       .
        brk                                     ; A9DB 00                       .
        brk                                     ; A9DC 00                       .
        brk                                     ; A9DD 00                       .
        brk                                     ; A9DE 00                       .
        brk                                     ; A9DF 00                       .
        .byte   $FF                             ; A9E0 FF                       .
        ora     (L0000,x)                       ; A9E1 01 00                    ..
        brk                                     ; A9E3 00                       .
        .byte   $80                             ; A9E4 80                       .
        brk                                     ; A9E5 00                       .
        .byte   $02                             ; A9E6 02                       .
        .byte   $0C                             ; A9E7 0C                       .
        brk                                     ; A9E8 00                       .
        brk                                     ; A9E9 00                       .
        brk                                     ; A9EA 00                       .
        brk                                     ; A9EB 00                       .
        .byte   $80                             ; A9EC 80                       .
        .byte   $23                             ; A9ED 23                       #
        brk                                     ; A9EE 00                       .
        rti                                     ; A9EF 40                       @

; ----------------------------------------------------------------------------
        jsr     L8043                           ; A9F0 20 43 80                  C.
        .byte   $42                             ; A9F3 42                       B
        .byte   $80                             ; A9F4 80                       .
        and     ($12,x)                         ; A9F5 21 12                    !.
        brk                                     ; A9F7 00                       .
        brk                                     ; A9F8 00                       .
        .byte   $02                             ; A9F9 02                       .
        brk                                     ; A9FA 00                       .
        brk                                     ; A9FB 00                       .
        brk                                     ; A9FC 00                       .
        .byte   $02                             ; A9FD 02                       .
        brk                                     ; A9FE 00                       .
        brk                                     ; A9FF 00                       .
LAA00:  ora     ($01,x)                         ; AA00 01 01                    ..
        ora     ($02,x)                         ; AA02 01 02                    ..
        .byte   $02                             ; AA04 02                       .
        .byte   $02                             ; AA05 02                       .
        .byte   $04                             ; AA06 04                       .
        .byte   $04                             ; AA07 04                       .
        .byte   $04                             ; AA08 04                       .
        .byte   $04                             ; AA09 04                       .
        ora     $05                             ; AA0A 05 05                    ..
        ora     $05                             ; AA0C 05 05                    ..
        asl     $07                             ; AA0E 06 07                    ..
        .byte   $07                             ; AA10 07                       .
        php                                     ; AA11 08                       .
        php                                     ; AA12 08                       .
        php                                     ; AA13 08                       .
        php                                     ; AA14 08                       .
        ora     #$09                            ; AA15 09 09                    ..
        .byte   $09                             ; AA17 09                       .
LAA18:  .byte   $09                             ; AA18 09                       .
LAA19:  asl     a                               ; AA19 0A                       .
        .byte   $0B                             ; AA1A 0B                       .
        .byte   $0B                             ; AA1B 0B                       .
        .byte   $0B                             ; AA1C 0B                       .
        .byte   $0B                             ; AA1D 0B                       .
        .byte   $0C                             ; AA1E 0C                       .
        .byte   $0C                             ; AA1F 0C                       .
        .byte   $0C                             ; AA20 0C                       .
        asl     $0F0E                           ; AA21 0E 0E 0F                 ...
        .byte   $0F                             ; AA24 0F                       .
        bpl     LAA37                           ; AA25 10 10                    ..
        bpl     LAA39                           ; AA27 10 10                    ..
        ora     ($11),y                         ; AA29 11 11                    ..
        .byte   $12                             ; AA2B 12                       .
        .byte   $12                             ; AA2C 12                       .
        .byte   $12                             ; AA2D 12                       .
        .byte   $12                             ; AA2E 12                       .
        .byte   $13                             ; AA2F 13                       .
        .byte   $14                             ; AA30 14                       .
        .byte   $14                             ; AA31 14                       .
        ora     $16,x                           ; AA32 15 16                    ..
        clc                                     ; AA34 18                       .
        .byte   $FF                             ; AA35 FF                       .
        brk                                     ; AA36 00                       .
LAA37:  brk                                     ; AA37 00                       .
        brk                                     ; AA38 00                       .
LAA39:  brk                                     ; AA39 00                       .
        brk                                     ; AA3A 00                       .
        brk                                     ; AA3B 00                       .
        brk                                     ; AA3C 00                       .
        brk                                     ; AA3D 00                       .
        brk                                     ; AA3E 00                       .
LAA3F:  brk                                     ; AA3F 00                       .
        brk                                     ; AA40 00                       .
        .byte   $02                             ; AA41 02                       .
        brk                                     ; AA42 00                       .
        .byte   $80                             ; AA43 80                       .
        php                                     ; AA44 08                       .
        brk                                     ; AA45 00                       .
        brk                                     ; AA46 00                       .
        php                                     ; AA47 08                       .
        .byte   $02                             ; AA48 02                       .
        brk                                     ; AA49 00                       .
        brk                                     ; AA4A 00                       .
        brk                                     ; AA4B 00                       .
        brk                                     ; AA4C 00                       .
LAA4D:  brk                                     ; AA4D 00                       .
        brk                                     ; AA4E 00                       .
        brk                                     ; AA4F 00                       .
        brk                                     ; AA50 00                       .
        brk                                     ; AA51 00                       .
        brk                                     ; AA52 00                       .
        brk                                     ; AA53 00                       .
        brk                                     ; AA54 00                       .
        brk                                     ; AA55 00                       .
        brk                                     ; AA56 00                       .
        brk                                     ; AA57 00                       .
        brk                                     ; AA58 00                       .
        brk                                     ; AA59 00                       .
        brk                                     ; AA5A 00                       .
        brk                                     ; AA5B 00                       .
        brk                                     ; AA5C 00                       .
        brk                                     ; AA5D 00                       .
        brk                                     ; AA5E 00                       .
        brk                                     ; AA5F 00                       .
        brk                                     ; AA60 00                       .
        brk                                     ; AA61 00                       .
        .byte   $82                             ; AA62 82                       .
        jsr     L508A                           ; AA63 20 8A 50                  .P
        .byte   $80                             ; AA66 80                       .
        brk                                     ; AA67 00                       .
        brk                                     ; AA68 00                       .
        .byte   $04                             ; AA69 04                       .
        brk                                     ; AA6A 00                       .
        brk                                     ; AA6B 00                       .
        brk                                     ; AA6C 00                       .
        brk                                     ; AA6D 00                       .
        brk                                     ; AA6E 00                       .
        bit     L0000                           ; AA6F 24 00                    $.
        brk                                     ; AA71 00                       .
        brk                                     ; AA72 00                       .
        asl     L0000                           ; AA73 06 00                    ..
        brk                                     ; AA75 00                       .
        brk                                     ; AA76 00                       .
        brk                                     ; AA77 00                       .
        brk                                     ; AA78 00                       .
        brk                                     ; AA79 00                       .
        brk                                     ; AA7A 00                       .
        brk                                     ; AA7B 00                       .
        brk                                     ; AA7C 00                       .
        brk                                     ; AA7D 00                       .
        brk                                     ; AA7E 00                       .
        brk                                     ; AA7F 00                       .
        clc                                     ; AA80 18                       .
        sei                                     ; AA81 78                       x
        beq     LAAC4                           ; AA82 F0 40                    .@
        sei                                     ; AA84 78                       x
        inx                                     ; AA85 E8                       .
        brk                                     ; AA86 00                       .
        bvc     LAA19                           ; AA87 50 90                    P.
        ldy     #$60                            ; AA89 A0 60                    .`
        tya                                     ; AA8B 98                       .
        ldy     #$C8                            ; AA8C A0 C8                    ..
        bvs     LAA18                           ; AA8E 70 88                    p.
        iny                                     ; AA90 C8                       .
        sec                                     ; AA91 38                       8
        pla                                     ; AA92 68                       h
LAA93:  .byte   $80                             ; AA93 80                       .
        cpy     #$50                            ; AA94 C0 50                    .P
        sei                                     ; AA96 78                       x
        .byte   $80                             ; AA97 80                       .
        cld                                     ; AA98 D8                       .
        tya                                     ; AA99 98                       .
        brk                                     ; AA9A 00                       .
        clc                                     ; AA9B 18                       .
        cli                                     ; AA9C 58                       X
        iny                                     ; AA9D C8                       .
        brk                                     ; AA9E 00                       .
        eor     #$A0                            ; AA9F 49 A0                    I.
        bpl     LAA93                           ; AAA1 10 F0                    ..
        bvc     LAA4D                           ; AAA3 50 A8                    P.
        brk                                     ; AAA5 00                       .
        jsr     LA050                           ; AAA6 20 50 A0                  P.
        plp                                     ; AAA9 28                       (
        cpy     #$10                            ; AAAA C0 10                    ..
        rti                                     ; AAAC 40                       @

; ----------------------------------------------------------------------------
        bvs     LAA3F                           ; AAAD 70 90                    p.
        bcc     LAAF1                           ; AAAF 90 40                    .@
        cpy     #$50                            ; AAB1 C0 50                    .P
        ldy     #$80                            ; AAB3 A0 80                    ..
        .byte   $FF                             ; AAB5 FF                       .
        brk                                     ; AAB6 00                       .
        brk                                     ; AAB7 00                       .
        brk                                     ; AAB8 00                       .
        brk                                     ; AAB9 00                       .
        brk                                     ; AABA 00                       .
        brk                                     ; AABB 00                       .
        brk                                     ; AABC 00                       .
        brk                                     ; AABD 00                       .
        brk                                     ; AABE 00                       .
        brk                                     ; AABF 00                       .
        jsr     L0080                           ; AAC0 20 80 00                  ..
        brk                                     ; AAC3 00                       .
LAAC4:  brk                                     ; AAC4 00                       .
        rti                                     ; AAC5 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AAC6 00                       .
        ora     $02                             ; AAC7 05 02                    ..
        brk                                     ; AAC9 00                       .
        brk                                     ; AACA 00                       .
        .byte   $80                             ; AACB 80                       .
        brk                                     ; AACC 00                       .
        brk                                     ; AACD 00                       .
        brk                                     ; AACE 00                       .
        brk                                     ; AACF 00                       .
        brk                                     ; AAD0 00                       .
        rti                                     ; AAD1 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; AAD2 00                       .
        brk                                     ; AAD3 00                       .
        brk                                     ; AAD4 00                       .
        brk                                     ; AAD5 00                       .
        brk                                     ; AAD6 00                       .
        brk                                     ; AAD7 00                       .
        brk                                     ; AAD8 00                       .
        brk                                     ; AAD9 00                       .
        brk                                     ; AADA 00                       .
        brk                                     ; AADB 00                       .
        brk                                     ; AADC 00                       .
        brk                                     ; AADD 00                       .
        brk                                     ; AADE 00                       .
        brk                                     ; AADF 00                       .
        brk                                     ; AAE0 00                       .
        bpl     LAAE3                           ; AAE1 10 00                    ..
LAAE3:  brk                                     ; AAE3 00                       .
        php                                     ; AAE4 08                       .
        ora     L0022                           ; AAE5 05 22                    ."
        php                                     ; AAE7 08                       .
        jsr     L8845                           ; AAE8 20 45 88                  E.
        dey                                     ; AAEB 88                       .
        jsr     L0832                           ; AAEC 20 32 08                  2.
        iny                                     ; AAEF C8                       .
        brk                                     ; AAF0 00                       .
LAAF1:  cpy     #$80                            ; AAF1 C0 80                    ..
        ora     (L0000,x)                       ; AAF3 01 00                    ..
        brk                                     ; AAF5 00                       .
        brk                                     ; AAF6 00                       .
        brk                                     ; AAF7 00                       .
        brk                                     ; AAF8 00                       .
        cpy     #$00                            ; AAF9 C0 00                    ..
        brk                                     ; AAFB 00                       .
        brk                                     ; AAFC 00                       .
        brk                                     ; AAFD 00                       .
        brk                                     ; AAFE 00                       .
        ora     ($13,x)                         ; AAFF 01 13                    ..
        .byte   $13                             ; AB01 13                       .
        .byte   $A3                             ; AB02 A3                       .
        .byte   $83                             ; AB03 83                       .
        .byte   $83                             ; AB04 83                       .
        .byte   $83                             ; AB05 83                       .
        brk                                     ; AB06 00                       .
        cli                                     ; AB07 58                       X
        cli                                     ; AB08 58                       X
        brk                                     ; AB09 00                       .
        clv                                     ; AB0A B8                       .
        ldx     L0000                           ; AB0B A6 00                    ..
        ldx     $98                             ; AB0D A6 98                    ..
        dec     $C6                             ; AB0F C6 C6                    ..
        dec     $B6                             ; AB11 C6 B6                    ..
        brk                                     ; AB13 00                       .
        dey                                     ; AB14 88                       .
        cli                                     ; AB15 58                       X
        tya                                     ; AB16 98                       .
        brk                                     ; AB17 00                       .
        clv                                     ; AB18 B8                       .
        clv                                     ; AB19 B8                       .
        brk                                     ; AB1A 00                       .
        clv                                     ; AB1B B8                       .
        tya                                     ; AB1C 98                       .
        dey                                     ; AB1D 88                       .
        brk                                     ; AB1E 00                       .
        tya                                     ; AB1F 98                       .
        clv                                     ; AB20 B8                       .
        tay                                     ; AB21 A8                       .
        txa                                     ; AB22 8A                       .
        tax                                     ; AB23 AA                       .
        tsx                                     ; AB24 BA                       .
        brk                                     ; AB25 00                       .
        eor     #$39                            ; AB26 49 39                    I9
        and     #$AC                            ; AB28 29 AC                    ).
        and     #$29                            ; AB2A 29 29                    ))
        ldy     $CCBC,x                         ; AB2C BC BC CC                 ...
        clv                                     ; AB2F B8                       .
        ldy     LBA40                           ; AB30 AC 40 BA                 .@.
        sty     $58                             ; AB33 84 58                    .X
        .byte   $FF                             ; AB35 FF                       .
        brk                                     ; AB36 00                       .
        brk                                     ; AB37 00                       .
        brk                                     ; AB38 00                       .
        brk                                     ; AB39 00                       .
        brk                                     ; AB3A 00                       .
        brk                                     ; AB3B 00                       .
        brk                                     ; AB3C 00                       .
        brk                                     ; AB3D 00                       .
        brk                                     ; AB3E 00                       .
        brk                                     ; AB3F 00                       .
        brk                                     ; AB40 00                       .
        brk                                     ; AB41 00                       .
        jsr     L2004                           ; AB42 20 04 20                  . 
        .byte   $04                             ; AB45 04                       .
        jsr     L2000                           ; AB46 20 00 20                  . 
        brk                                     ; AB49 00                       .
        brk                                     ; AB4A 00                       .
        brk                                     ; AB4B 00                       .
        brk                                     ; AB4C 00                       .
        brk                                     ; AB4D 00                       .
        brk                                     ; AB4E 00                       .
        brk                                     ; AB4F 00                       .
        brk                                     ; AB50 00                       .
        brk                                     ; AB51 00                       .
        brk                                     ; AB52 00                       .
        brk                                     ; AB53 00                       .
        brk                                     ; AB54 00                       .
        brk                                     ; AB55 00                       .
        brk                                     ; AB56 00                       .
        brk                                     ; AB57 00                       .
        brk                                     ; AB58 00                       .
        brk                                     ; AB59 00                       .
        brk                                     ; AB5A 00                       .
        brk                                     ; AB5B 00                       .
        brk                                     ; AB5C 00                       .
        brk                                     ; AB5D 00                       .
        brk                                     ; AB5E 00                       .
        brk                                     ; AB5F 00                       .
        brk                                     ; AB60 00                       .
        brk                                     ; AB61 00                       .
        .byte   $80                             ; AB62 80                       .
        jsr     L0080                           ; AB63 20 80 00                  ..
        brk                                     ; AB66 00                       .
        php                                     ; AB67 08                       .
        brk                                     ; AB68 00                       .
        brk                                     ; AB69 00                       .
        .byte   $02                             ; AB6A 02                       .
        .byte   $04                             ; AB6B 04                       .
        brk                                     ; AB6C 00                       .
        .byte   $04                             ; AB6D 04                       .
        brk                                     ; AB6E 00                       .
        brk                                     ; AB6F 00                       .
        brk                                     ; AB70 00                       .
        brk                                     ; AB71 00                       .
        brk                                     ; AB72 00                       .
        brk                                     ; AB73 00                       .
        brk                                     ; AB74 00                       .
        brk                                     ; AB75 00                       .
        jsr     L0000                           ; AB76 20 00 00                  ..
        brk                                     ; AB79 00                       .
        brk                                     ; AB7A 00                       .
        brk                                     ; AB7B 00                       .
        brk                                     ; AB7C 00                       .
        brk                                     ; AB7D 00                       .
        brk                                     ; AB7E 00                       .
        brk                                     ; AB7F 00                       .
        .byte   $1C                             ; AB80 1C                       .
        .byte   $1C                             ; AB81 1C                       .
        .byte   $1C                             ; AB82 1C                       .
        .byte   $1C                             ; AB83 1C                       .
        .byte   $1C                             ; AB84 1C                       .
        .byte   $1C                             ; AB85 1C                       .
        cpy     $81                             ; AB86 C4 81                    ..
        .byte   $82                             ; AB88 82                       .
        cmp     $2D29                           ; AB89 CD 29 2D                 .)-
        cpy     $2930                           ; AB8C CC 30 29                 .0)
        and     $3030                           ; AB8F 2D 30 30                 -00
        and     $29CC                           ; AB92 2D CC 29                 -.)
        sty     $29                             ; AB95 84 29                    .)
        cmp     $2929                           ; AB97 CD 29 29                 .))
        dex                                     ; AB9A CA                       .
        and     #$29                            ; AB9B 29 29                    ))
        and     #$CB                            ; AB9D 29 CB                    ).
        and     #$29                            ; AB9F 29 29                    ))
        and     #$31                            ; ABA1 29 31                    )1
        and     ($31),y                         ; ABA3 31 31                    11
        cmp     $34                             ; ABA5 C5 34                    .4
        .byte   $34                             ; ABA7 34                       4
        .byte   $34                             ; ABA8 34                       4
        ora     $34                             ; ABA9 05 34                    .4
        .byte   $34                             ; ABAB 34                       4
        ora     $05                             ; ABAC 05 05                    ..
LABAE:  ora     $84                             ; ABAE 05 84                    ..
        ora     $39                             ; ABB0 05 39                    .9
        .byte   $0C                             ; ABB2 0C                       .
        .byte   $0C                             ; ABB3 0C                       .
        .byte   $5C                             ; ABB4 5C                       \
        .byte   $FF                             ; ABB5 FF                       .
        brk                                     ; ABB6 00                       .
        brk                                     ; ABB7 00                       .
        brk                                     ; ABB8 00                       .
        brk                                     ; ABB9 00                       .
        brk                                     ; ABBA 00                       .
        brk                                     ; ABBB 00                       .
        brk                                     ; ABBC 00                       .
        brk                                     ; ABBD 00                       .
        brk                                     ; ABBE 00                       .
LABBF:  brk                                     ; ABBF 00                       .
        jsr     L0080                           ; ABC0 20 80 00                  ..
        php                                     ; ABC3 08                       .
        brk                                     ; ABC4 00                       .
        brk                                     ; ABC5 00                       .
        brk                                     ; ABC6 00                       .
        brk                                     ; ABC7 00                       .
        brk                                     ; ABC8 00                       .
        brk                                     ; ABC9 00                       .
        .byte   $80                             ; ABCA 80                       .
        brk                                     ; ABCB 00                       .
        brk                                     ; ABCC 00                       .
        brk                                     ; ABCD 00                       .
        brk                                     ; ABCE 00                       .
        brk                                     ; ABCF 00                       .
        brk                                     ; ABD0 00                       .
        brk                                     ; ABD1 00                       .
        brk                                     ; ABD2 00                       .
        brk                                     ; ABD3 00                       .
        brk                                     ; ABD4 00                       .
        brk                                     ; ABD5 00                       .
        brk                                     ; ABD6 00                       .
        brk                                     ; ABD7 00                       .
        brk                                     ; ABD8 00                       .
        brk                                     ; ABD9 00                       .
        brk                                     ; ABDA 00                       .
        brk                                     ; ABDB 00                       .
        brk                                     ; ABDC 00                       .
        brk                                     ; ABDD 00                       .
        brk                                     ; ABDE 00                       .
        brk                                     ; ABDF 00                       .
        php                                     ; ABE0 08                       .
        .byte   $0C                             ; ABE1 0C                       .
        .byte   $80                             ; ABE2 80                       .
        bit     L0000                           ; ABE3 24 00                    $.
        brk                                     ; ABE5 00                       .
        .byte   $80                             ; ABE6 80                       .
        cmp     (L0000,x)                       ; ABE7 C1 00                    ..
        dey                                     ; ABE9 88                       .
        .byte   $02                             ; ABEA 02                       .
        cpy     #$20                            ; ABEB C0 20                    . 
        ora     #$0A                            ; ABED 09 0A                    ..
        .byte   $02                             ; ABEF 02                       .
        brk                                     ; ABF0 00                       .
        brk                                     ; ABF1 00                       .
        .byte   $02                             ; ABF2 02                       .
        rts                                     ; ABF3 60                       `

; ----------------------------------------------------------------------------
        brk                                     ; ABF4 00                       .
        ora     (L0000,x)                       ; ABF5 01 00                    ..
        brk                                     ; ABF7 00                       .
        brk                                     ; ABF8 00                       .
        brk                                     ; ABF9 00                       .
        brk                                     ; ABFA 00                       .
        brk                                     ; ABFB 00                       .
        brk                                     ; ABFC 00                       .
        brk                                     ; ABFD 00                       .
        brk                                     ; ABFE 00                       .
LABFF:  brk                                     ; ABFF 00                       .
        brk                                     ; AC00 00                       .
        brk                                     ; AC01 00                       .
        .byte   $03                             ; AC02 03                       .
        asl     $06                             ; AC03 06 06                    ..
        asl     a                               ; AC05 0A                       .
        asl     $110F                           ; AC06 0E 0F 11                 ...
        ora     $19,x                           ; AC09 15 19                    ..
        .byte   $1A                             ; AC0B 1A                       .
        asl     $2121,x                         ; AC0C 1E 21 21                 .!!
        .byte   $23                             ; AC0F 23                       #
        and     $29                             ; AC10 25 29                    %)
        .byte   $2B                             ; AC12 2B                       +
        .byte   $2F                             ; AC13 2F                       /
        bmi     LAC48                           ; AC14 30 32                    02
        .byte   $33                             ; AC16 33                       3
        .byte   $34                             ; AC17 34                       4
        .byte   $34                             ; AC18 34                       4
        brk                                     ; AC19 00                       .
        brk                                     ; AC1A 00                       .
        brk                                     ; AC1B 00                       .
        brk                                     ; AC1C 00                       .
        brk                                     ; AC1D 00                       .
        brk                                     ; AC1E 00                       .
        brk                                     ; AC1F 00                       .
        bpl     LAC22                           ; AC20 10 00                    ..
LAC22:  brk                                     ; AC22 00                       .
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
        brk                                     ; AC2E 00                       .
        brk                                     ; AC2F 00                       .
        brk                                     ; AC30 00                       .
        brk                                     ; AC31 00                       .
        brk                                     ; AC32 00                       .
        brk                                     ; AC33 00                       .
        brk                                     ; AC34 00                       .
        brk                                     ; AC35 00                       .
        brk                                     ; AC36 00                       .
        brk                                     ; AC37 00                       .
        brk                                     ; AC38 00                       .
        brk                                     ; AC39 00                       .
        brk                                     ; AC3A 00                       .
        brk                                     ; AC3B 00                       .
        brk                                     ; AC3C 00                       .
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
LAC48:  brk                                     ; AC48 00                       .
        brk                                     ; AC49 00                       .
        brk                                     ; AC4A 00                       .
        brk                                     ; AC4B 00                       .
        brk                                     ; AC4C 00                       .
        brk                                     ; AC4D 00                       .
        brk                                     ; AC4E 00                       .
        brk                                     ; AC4F 00                       .
        brk                                     ; AC50 00                       .
        brk                                     ; AC51 00                       .
        brk                                     ; AC52 00                       .
        brk                                     ; AC53 00                       .
        brk                                     ; AC54 00                       .
        brk                                     ; AC55 00                       .
        brk                                     ; AC56 00                       .
        brk                                     ; AC57 00                       .
        brk                                     ; AC58 00                       .
        brk                                     ; AC59 00                       .
        brk                                     ; AC5A 00                       .
        brk                                     ; AC5B 00                       .
        brk                                     ; AC5C 00                       .
        brk                                     ; AC5D 00                       .
        brk                                     ; AC5E 00                       .
        brk                                     ; AC5F 00                       .
        brk                                     ; AC60 00                       .
        brk                                     ; AC61 00                       .
        brk                                     ; AC62 00                       .
        brk                                     ; AC63 00                       .
        brk                                     ; AC64 00                       .
        rti                                     ; AC65 40                       @

; ----------------------------------------------------------------------------
        .byte   $80                             ; AC66 80                       .
        brk                                     ; AC67 00                       .
        brk                                     ; AC68 00                       .
        brk                                     ; AC69 00                       .
        brk                                     ; AC6A 00                       .
        brk                                     ; AC6B 00                       .
        brk                                     ; AC6C 00                       .
        brk                                     ; AC6D 00                       .
        brk                                     ; AC6E 00                       .
        brk                                     ; AC6F 00                       .
        brk                                     ; AC70 00                       .
        brk                                     ; AC71 00                       .
        brk                                     ; AC72 00                       .
        brk                                     ; AC73 00                       .
        brk                                     ; AC74 00                       .
        brk                                     ; AC75 00                       .
        brk                                     ; AC76 00                       .
        brk                                     ; AC77 00                       .
        brk                                     ; AC78 00                       .
        brk                                     ; AC79 00                       .
        brk                                     ; AC7A 00                       .
        brk                                     ; AC7B 00                       .
        brk                                     ; AC7C 00                       .
        brk                                     ; AC7D 00                       .
        brk                                     ; AC7E 00                       .
        brk                                     ; AC7F 00                       .
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
        brk                                     ; AC8F 00                       .
        brk                                     ; AC90 00                       .
        brk                                     ; AC91 00                       .
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
        brk                                     ; AC9C 00                       .
        brk                                     ; AC9D 00                       .
        brk                                     ; AC9E 00                       .
        brk                                     ; AC9F 00                       .
        brk                                     ; ACA0 00                       .
        .byte   $04                             ; ACA1 04                       .
        .byte   $04                             ; ACA2 04                       .
        brk                                     ; ACA3 00                       .
        brk                                     ; ACA4 00                       .
        brk                                     ; ACA5 00                       .
        brk                                     ; ACA6 00                       .
        brk                                     ; ACA7 00                       .
        brk                                     ; ACA8 00                       .
        brk                                     ; ACA9 00                       .
        brk                                     ; ACAA 00                       .
LACAB:  ora     (L0000,x)                       ; ACAB 01 00                    ..
        brk                                     ; ACAD 00                       .
        brk                                     ; ACAE 00                       .
        brk                                     ; ACAF 00                       .
        brk                                     ; ACB0 00                       .
        brk                                     ; ACB1 00                       .
        brk                                     ; ACB2 00                       .
        brk                                     ; ACB3 00                       .
        brk                                     ; ACB4 00                       .
        brk                                     ; ACB5 00                       .
        brk                                     ; ACB6 00                       .
        brk                                     ; ACB7 00                       .
        brk                                     ; ACB8 00                       .
        brk                                     ; ACB9 00                       .
        brk                                     ; ACBA 00                       .
        brk                                     ; ACBB 00                       .
        brk                                     ; ACBC 00                       .
        brk                                     ; ACBD 00                       .
        brk                                     ; ACBE 00                       .
        brk                                     ; ACBF 00                       .
        brk                                     ; ACC0 00                       .
        brk                                     ; ACC1 00                       .
        brk                                     ; ACC2 00                       .
        brk                                     ; ACC3 00                       .
        brk                                     ; ACC4 00                       .
        brk                                     ; ACC5 00                       .
        brk                                     ; ACC6 00                       .
        brk                                     ; ACC7 00                       .
        brk                                     ; ACC8 00                       .
        brk                                     ; ACC9 00                       .
        brk                                     ; ACCA 00                       .
        brk                                     ; ACCB 00                       .
        brk                                     ; ACCC 00                       .
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
        brk                                     ; ACD8 00                       .
        brk                                     ; ACD9 00                       .
        brk                                     ; ACDA 00                       .
        brk                                     ; ACDB 00                       .
        brk                                     ; ACDC 00                       .
        brk                                     ; ACDD 00                       .
        brk                                     ; ACDE 00                       .
        brk                                     ; ACDF 00                       .
        brk                                     ; ACE0 00                       .
        ora     (L0000,x)                       ; ACE1 01 00                    ..
        brk                                     ; ACE3 00                       .
        brk                                     ; ACE4 00                       .
        brk                                     ; ACE5 00                       .
        ora     (L0000,x)                       ; ACE6 01 00                    ..
        brk                                     ; ACE8 00                       .
        brk                                     ; ACE9 00                       .
        brk                                     ; ACEA 00                       .
        brk                                     ; ACEB 00                       .
        brk                                     ; ACEC 00                       .
        brk                                     ; ACED 00                       .
        brk                                     ; ACEE 00                       .
        brk                                     ; ACEF 00                       .
        brk                                     ; ACF0 00                       .
        brk                                     ; ACF1 00                       .
        brk                                     ; ACF2 00                       .
        brk                                     ; ACF3 00                       .
        php                                     ; ACF4 08                       .
        brk                                     ; ACF5 00                       .
        brk                                     ; ACF6 00                       .
        brk                                     ; ACF7 00                       .
        brk                                     ; ACF8 00                       .
        brk                                     ; ACF9 00                       .
        brk                                     ; ACFA 00                       .
        brk                                     ; ACFB 00                       .
        brk                                     ; ACFC 00                       .
        ora     (L0000,x)                       ; ACFD 01 00                    ..
        brk                                     ; ACFF 00                       .
        brk                                     ; AD00 00                       .
        .byte   $0C                             ; AD01 0C                       .
        .byte   $0C                             ; AD02 0C                       .
LAD03:  sty     $0604                           ; AD03 8C 04 06                 ...
        php                                     ; AD06 08                       .
        stx     $8800                           ; AD07 8E 00 88                 ...
        .byte   $1C                             ; AD0A 1C                       .
        brk                                     ; AD0B 00                       .
        bit     $26                             ; AD0C 24 26                    $&
        bit     $832E                           ; AD0E 2C 2E 83                 ,..
        tya                                     ; AD11 98                       .
        brk                                     ; AD12 00                       .
        brk                                     ; AD13 00                       .
        brk                                     ; AD14 00                       .
        brk                                     ; AD15 00                       .
        .byte   $64                             ; AD16 64                       d
        ror     $8A                             ; AD17 66 8A                    f.
        tay                                     ; AD19 A8                       .
        pla                                     ; AD1A 68                       h
        ror     a:L0000                         ; AD1B 6E 00 00                 n..
        php                                     ; AD1E 08                       .
        php                                     ; AD1F 08                       .
        cpy     #$C2                            ; AD20 C0 C2                    ..
        cpy     $C6                             ; AD22 C4 C6                    ..
        iny                                     ; AD24 C8                       .
        dex                                     ; AD25 CA                       .
        cpy     $EE                             ; AD26 C4 EE                    ..
        cpx     #$E2                            ; AD28 E0 E2                    ..
        cpx     $E6                             ; AD2A E4 E6                    ..
        inx                                     ; AD2C E8                       .
        nop                                     ; AD2D EA                       .
        .byte   $FC                             ; AD2E FC                       .
        inc     $8000,x                         ; AD2F FE 00 80                 ...
        sta     ($81,x)                         ; AD32 81 81                    ..
        sta     ($78,x)                         ; AD34 81 78                    .x
        bpl     LAD48                           ; AD36 10 10                    ..
        brk                                     ; AD38 00                       .
        ldy     #$A2                            ; AD39 A0 A2                    ..
        ldy     $A6                             ; AD3B A4 A6                    ..
        cli                                     ; AD3D 58                       X
        lsr     a                               ; AD3E 4A                       J
        bpl     LAD03                           ; AD3F 10 C2                    ..
        cpy     #$C9                            ; AD41 C0 C9                    ..
        .byte   $80                             ; AD43 80                       .
        cpy     #$87                            ; AD44 C0 87                    ..
        .byte   $80                             ; AD46 80                       .
        .byte   $81                             ; AD47 81                       .
LAD48:  .byte   $E2                             ; AD48 E2                       .
        cpx     #$E9                            ; AD49 E0 E9                    ..
        ldy     #$E0                            ; AD4B A0 E0                    ..
        .byte   $A7                             ; AD4D A7                       .
        cli                                     ; AD4E 58                       X
        .byte   $6B                             ; AD4F 6B                       k
        cpy     #$C2                            ; AD50 C0 C2                    ..
        cpy     $C6                             ; AD52 C4 C6                    ..
        iny                                     ; AD54 C8                       .
        dex                                     ; AD55 CA                       .
        sta     ($0E,x)                         ; AD56 81 0E                    ..
        cpx     #$E2                            ; AD58 E0 E2                    ..
        cpx     $E6                             ; AD5A E4 E6                    ..
        inx                                     ; AD5C E8                       .
        nop                                     ; AD5D EA                       .
        bpl     LAD63                           ; AD5E 10 03                    ..
        dec     $8180                           ; AD60 CE 80 81                 ...
LAD63:  sta     ($81,x)                         ; AD63 81 81                    ..
        cpy     $EE                             ; AD65 C4 EE                    ..
        brk                                     ; AD67 00                       .
        brk                                     ; AD68 00                       .
        ldy     #$A2                            ; AD69 A0 A2                    ..
        ldy     $A6                             ; AD6B A4 A6                    ..
        .byte   $FC                             ; AD6D FC                       .
        inc     LAA00,x                         ; AD6E FE 00 AA                 ...
        ldy     LAEAC                           ; AD71 AC AC AE                 ...
        .byte   $E2                             ; AD74 E2                       .
        cpx     $E6                             ; AD75 E4 E6                    ..
        inx                                     ; AD77 E8                       .
        tax                                     ; AD78 AA                       .
        ldy     LAEAC                           ; AD79 AC AC AE                 ...
        jsr     L0022                           ; AD7C 20 22 00                  ".
        brk                                     ; AD7F 00                       .
        rti                                     ; AD80 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; AD81 42                       B
        .byte   $44                             ; AD82 44                       D
        lsr     $4C                             ; AD83 46 4C                    FL
        lsr     $4E4C                           ; AD85 4E 4C 4E                 NLN
        rts                                     ; AD88 60                       `

; ----------------------------------------------------------------------------
        .byte   $62                             ; AD89 62                       b
        .byte   $64                             ; AD8A 64                       d
        ror     $6C                             ; AD8B 66 6C                    fl
        ror     $6E6C                           ; AD8D 6E 6C 6E                 nln
        rti                                     ; AD90 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; AD91 42                       B
        and     ($21,x)                         ; AD92 21 21                    !!
        .byte   $22                             ; AD94 22                       "
        brk                                     ; AD95 00                       .
        bit     a:$2E                           ; AD96 2C 2E 00                 ,..
        brk                                     ; AD99 00                       .
        brk                                     ; AD9A 00                       .
        brk                                     ; AD9B 00                       .
        .byte   $22                             ; AD9C 22                       "
        .byte   $22                             ; AD9D 22                       "
        brk                                     ; AD9E 00                       .
        brk                                     ; AD9F 00                       .
        pha                                     ; ADA0 48                       H
        brk                                     ; ADA1 00                       .
        cpy     $CFCD                           ; ADA2 CC CD CF                 ...
        clv                                     ; ADA5 B8                       .
        brk                                     ; ADA6 00                       .
        brk                                     ; ADA7 00                       .
        .byte   $57                             ; ADA8 57                       W
        .byte   $4B                             ; ADA9 4B                       K
        cmp     LB900                           ; ADAA CD 00 B9                 ...
        ldx     $B9,y                           ; ADAD B6 B9                    ..
        brk                                     ; ADAF 00                       .
        brk                                     ; ADB0 00                       .
        brk                                     ; ADB1 00                       .
        brk                                     ; ADB2 00                       .
        brk                                     ; ADB3 00                       .
        brk                                     ; ADB4 00                       .
        brk                                     ; ADB5 00                       .
        brk                                     ; ADB6 00                       .
        brk                                     ; ADB7 00                       .
        brk                                     ; ADB8 00                       .
        brk                                     ; ADB9 00                       .
        brk                                     ; ADBA 00                       .
        brk                                     ; ADBB 00                       .
        brk                                     ; ADBC 00                       .
        brk                                     ; ADBD 00                       .
        brk                                     ; ADBE 00                       .
        brk                                     ; ADBF 00                       .
        brk                                     ; ADC0 00                       .
        brk                                     ; ADC1 00                       .
        brk                                     ; ADC2 00                       .
        brk                                     ; ADC3 00                       .
        brk                                     ; ADC4 00                       .
        brk                                     ; ADC5 00                       .
        brk                                     ; ADC6 00                       .
        brk                                     ; ADC7 00                       .
        brk                                     ; ADC8 00                       .
        brk                                     ; ADC9 00                       .
        php                                     ; ADCA 08                       .
        asl     a                               ; ADCB 0A                       .
        .byte   $0C                             ; ADCC 0C                       .
        asl     a:L0000                         ; ADCD 0E 00 00                 ...
        brk                                     ; ADD0 00                       .
        cli                                     ; ADD1 58                       X
        .byte   $7C                             ; ADD2 7C                       |
        .byte   $02                             ; ADD3 02                       .
        .byte   $04                             ; ADD4 04                       .
        asl     $5A                             ; ADD5 06 5A                    .Z
        brk                                     ; ADD7 00                       .
        brk                                     ; ADD8 00                       .
        sei                                     ; ADD9 78                       x
        jsr     L2425                           ; ADDA 20 25 24                  %$
        rol     $7A                             ; ADDD 26 7A                    &z
        brk                                     ; ADDF 00                       .
        brk                                     ; ADE0 00                       .
        brk                                     ; ADE1 00                       .
        brk                                     ; ADE2 00                       .
        .byte   $42                             ; ADE3 42                       B
        .byte   $44                             ; ADE4 44                       D
        lsr     L0000                           ; ADE5 46 00                    F.
        brk                                     ; ADE7 00                       .
        brk                                     ; ADE8 00                       .
        brk                                     ; ADE9 00                       .
        rts                                     ; ADEA 60                       `

; ----------------------------------------------------------------------------
        .byte   $62                             ; ADEB 62                       b
        .byte   $64                             ; ADEC 64                       d
        ror     L0000                           ; ADED 66 00                    f.
        brk                                     ; ADEF 00                       .
        brk                                     ; ADF0 00                       .
        brk                                     ; ADF1 00                       .
        plp                                     ; ADF2 28                       (
        rol     a                               ; ADF3 2A                       *
        bit     $6E2E                           ; ADF4 2C 2E 6E                 ,.n
        brk                                     ; ADF7 00                       .
        brk                                     ; ADF8 00                       .
        brk                                     ; ADF9 00                       .
        pha                                     ; ADFA 48                       H
        lsr     a                               ; ADFB 4A                       J
        jmp     L004E                           ; ADFC 4C 4E 00                 LN.

; ----------------------------------------------------------------------------
        brk                                     ; ADFF 00                       .
        brk                                     ; AE00 00                       .
        ora     $8D0D                           ; AE01 0D 0D 8D                 ...
        ora     $07                             ; AE04 05 07                    ..
        ora     #$8F                            ; AE06 09 8F                    ..
        brk                                     ; AE08 00                       .
        .byte   $89                             ; AE09 89                       .
        ora     $2500,x                         ; AE0A 1D 00 25                 ..%
        .byte   $27                             ; AE0D 27                       '
        and     a:$2F                           ; AE0E 2D 2F 00                 -/.
        sta     L0000,y                         ; AE11 99 00 00                 ...
        brk                                     ; AE14 00                       .
        brk                                     ; AE15 00                       .
        adc     $67                             ; AE16 65 67                    eg
        .byte   $8B                             ; AE18 8B                       .
        lda     #$69                            ; AE19 A9 69                    .i
        .byte   $6F                             ; AE1B 6F                       o
        brk                                     ; AE1C 00                       .
        brk                                     ; AE1D 00                       .
        ora     #$09                            ; AE1E 09 09                    ..
        cmp     ($C3,x)                         ; AE20 C1 C3                    ..
        cmp     $C7                             ; AE22 C5 C7                    ..
        cmp     #$CB                            ; AE24 C9 CB                    ..
        sbc     $E1EF                           ; AE26 ED EF E1                 ...
        .byte   $E3                             ; AE29 E3                       .
        sbc     $E7                             ; AE2A E5 E7                    ..
        sbc     #$EB                            ; AE2C E9 EB                    ..
        sbc     a:$FF,x                         ; AE2E FD FF 00                 ...
        sta     ($81,x)                         ; AE31 81 81                    ..
        sta     ($87,x)                         ; AE33 81 87                    ..
        bpl     LAE47                           ; AE35 10 10                    ..
        .byte   $79,$00,$A1                     ; AE37 79 00 A1                 y..
        .byte   $A3                             ; AE3A A3                       .
        lda     $A7                             ; AE3B A5 A7                    ..
        bpl     LAE8A                           ; AE3D 10 4B                    .K
        eor     $C2C9,y                         ; AE3F 59 C9 C2                 Y..
        .byte   $CB                             ; AE42 CB                       .
        .byte   $87                             ; AE43 87                       .
        .byte   $80                             ; AE44 80                       .
        .byte   $CB                             ; AE45 CB                       .
        .byte   $81                             ; AE46 81                       .
LAE47:  .byte   $87                             ; AE47 87                       .
        sbc     #$E2                            ; AE48 E9 E2                    ..
        .byte   $EB                             ; AE4A EB                       .
        .byte   $A7                             ; AE4B A7                       .
        ldy     #$EB                            ; AE4C A0 EB                    ..
        ror     a                               ; AE4E 6A                       j
        eor     $C3C1,y                         ; AE4F 59 C1 C3                 Y..
        cmp     $C7                             ; AE52 C5 C7                    ..
        cmp     #$CB                            ; AE54 C9 CB                    ..
        sta     ($0F,x)                         ; AE56 81 0F                    ..
        sbc     ($E3,x)                         ; AE58 E1 E3                    ..
        sbc     $E7                             ; AE5A E5 E7                    ..
        sbc     #$EB                            ; AE5C E9 EB                    ..
        bpl     LAE63                           ; AE5E 10 03                    ..
        .byte   $CF                             ; AE60 CF                       .
        sta     ($81,x)                         ; AE61 81 81                    ..
LAE63:  sta     ($87,x)                         ; AE63 81 87                    ..
        sbc     a:$EF                           ; AE65 ED EF 00                 ...
        brk                                     ; AE68 00                       .
        lda     ($A3,x)                         ; AE69 A1 A3                    ..
        lda     $A7                             ; AE6B A5 A7                    ..
        sbc     a:$FF,x                         ; AE6D FD FF 00                 ...
        .byte   $AB                             ; AE70 AB                       .
        lda     LAFAD                           ; AE71 AD AD AF                 ...
        .byte   $E3                             ; AE74 E3                       .
        sbc     $E7                             ; AE75 E5 E7                    ..
        sbc     #$AB                            ; AE77 E9 AB                    ..
        lda     LAFAD                           ; AE79 AD AD AF                 ...
        and     ($23,x)                         ; AE7C 21 23                    !#
        brk                                     ; AE7E 00                       .
        brk                                     ; AE7F 00                       .
        eor     ($43,x)                         ; AE80 41 43                    AC
        eor     $47                             ; AE82 45 47                    EG
        eor     $4D4F                           ; AE84 4D 4F 4D                 MOM
        .byte   $4F                             ; AE87 4F                       O
        adc     ($63,x)                         ; AE88 61 63                    ac
LAE8A:  adc     $67                             ; AE8A 65 67                    eg
        adc     $6D6F                           ; AE8C 6D 6F 6D                 mom
        .byte   $6F                             ; AE8F 6F                       o
        eor     ($43,x)                         ; AE90 41 43                    AC
        and     ($21,x)                         ; AE92 21 21                    !!
        .byte   $22                             ; AE94 22                       "
        brk                                     ; AE95 00                       .
        and     a:$2F                           ; AE96 2D 2F 00                 -/.
        brk                                     ; AE99 00                       .
        brk                                     ; AE9A 00                       .
        brk                                     ; AE9B 00                       .
        .byte   $22                             ; AE9C 22                       "
        .byte   $22                             ; AE9D 22                       "
        brk                                     ; AE9E 00                       .
        brk                                     ; AE9F 00                       .
        brk                                     ; AEA0 00                       .
        brk                                     ; AEA1 00                       .
        cmp     a:$CE                           ; AEA2 CD CE 00                 ...
        .byte   $DC                             ; AEA5 DC                       .
        brk                                     ; AEA6 00                       .
        brk                                     ; AEA7 00                       .
        brk                                     ; AEA8 00                       .
        brk                                     ; AEA9 00                       .
        .byte   $CD                             ; AEAA CD                       .
        brk                                     ; AEAB 00                       .
LAEAC:  lda     LB9B9,y                         ; AEAC B9 B9 B9                 ...
        brk                                     ; AEAF 00                       .
        brk                                     ; AEB0 00                       .
        brk                                     ; AEB1 00                       .
        brk                                     ; AEB2 00                       .
        brk                                     ; AEB3 00                       .
        brk                                     ; AEB4 00                       .
        brk                                     ; AEB5 00                       .
        brk                                     ; AEB6 00                       .
        brk                                     ; AEB7 00                       .
        brk                                     ; AEB8 00                       .
        brk                                     ; AEB9 00                       .
        brk                                     ; AEBA 00                       .
        brk                                     ; AEBB 00                       .
        brk                                     ; AEBC 00                       .
        brk                                     ; AEBD 00                       .
        brk                                     ; AEBE 00                       .
        brk                                     ; AEBF 00                       .
        brk                                     ; AEC0 00                       .
        brk                                     ; AEC1 00                       .
        brk                                     ; AEC2 00                       .
        brk                                     ; AEC3 00                       .
        brk                                     ; AEC4 00                       .
        brk                                     ; AEC5 00                       .
        brk                                     ; AEC6 00                       .
        brk                                     ; AEC7 00                       .
        brk                                     ; AEC8 00                       .
        brk                                     ; AEC9 00                       .
        ora     #$0B                            ; AECA 09 0B                    ..
        ora     a:$0F                           ; AECC 0D 0F 00                 ...
        brk                                     ; AECF 00                       .
        brk                                     ; AED0 00                       .
        eor     $0301,y                         ; AED1 59 01 03                 Y..
        ora     $07                             ; AED4 05 07                    ..
        .byte   $5B                             ; AED6 5B                       [
        brk                                     ; AED7 00                       .
        brk                                     ; AED8 00                       .
        adc     $2321,y                         ; AED9 79 21 23                 y!#
        and     $27                             ; AEDC 25 27                    %'
        .byte   $7B                             ; AEDE 7B                       {
        brk                                     ; AEDF 00                       .
        brk                                     ; AEE0 00                       .
        brk                                     ; AEE1 00                       .
        eor     ($43,x)                         ; AEE2 41 43                    AC
        eor     L0000                           ; AEE4 45 00                    E.
        brk                                     ; AEE6 00                       .
        brk                                     ; AEE7 00                       .
        brk                                     ; AEE8 00                       .
        brk                                     ; AEE9 00                       .
        adc     ($63,x)                         ; AEEA 61 63                    ac
LAEEC:  adc     $67                             ; AEEC 65 67                    eg
        brk                                     ; AEEE 00                       .
        brk                                     ; AEEF 00                       .
        brk                                     ; AEF0 00                       .
        adc     $2B29                           ; AEF1 6D 29 2B                 m)+
LAEF4:  and     a:$2F                           ; AEF4 2D 2F 00                 -/.
        brk                                     ; AEF7 00                       .
        brk                                     ; AEF8 00                       .
        brk                                     ; AEF9 00                       .
        eor     #$4B                            ; AEFA 49 4B                    IK
        eor     a:$4F                           ; AEFC 4D 4F 00                 MO.
LAEFF:  brk                                     ; AEFF 00                       .
        brk                                     ; AF00 00                       .
LAF01:  .byte   $0C                             ; AF01 0C                       .
        .byte   $0C                             ; AF02 0C                       .
        .byte   $9C                             ; AF03 9C                       .
        .byte   $14                             ; AF04 14                       .
        asl     L0000,x                         ; AF05 16 00                    ..
        .byte   $9E                             ; AF07 9E                       .
        brk                                     ; AF08 00                       .
        tya                                     ; AF09 98                       .
        .byte   $1C                             ; AF0A 1C                       .
        plp                                     ; AF0B 28                       (
        .byte   $34                             ; AF0C 34                       4
        rol     $3C,x                           ; AF0D 36 3C                    6<
        rol     $9800,x                         ; AF0F 3E 00 98                 >..
        sec                                     ; AF12 38                       8
LAF13:  .byte   $3A                             ; AF13 3A                       :
        plp                                     ; AF14 28                       (
LAF15:  rol     a                               ; AF15 2A                       *
        .byte   $64                             ; AF16 64                       d
        ror     $9A                             ; AF17 66 9A                    f.
        tya                                     ; AF19 98                       .
        sei                                     ; AF1A 78                       x
        .byte   $7E                             ; AF1B 7E                       ~
LAF1C:  rti                                     ; AF1C 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; AF1D 42                       B
        sec                                     ; AF1E 38                       8
        .byte   $3A                             ; AF1F 3A                       :
        bne     LAEF4                           ; AF20 D0 D2                    ..
        .byte   $D4                             ; AF22 D4                       .
        .byte   $D6                             ; AF23 D6                       .
LAF24:  cld                                     ; AF24 D8                       .
        .byte   $DA                             ; AF25 DA                       .
        cpx     $F0EE                           ; AF26 EC EE F0                 ...
        .byte   $F2                             ; AF29 F2                       .
        .byte   $F4                             ; AF2A F4                       .
        inc     $F8,x                           ; AF2B F6 F8                    ..
        .byte   $FA                             ; AF2D FA                       .
        .byte   $F4                             ; AF2E F4                       .
        inc     $902A,x                         ; AF2F FE 2A 90                 .*.
        .byte   $92                             ; AF32 92                       .
        sty     $96,x                           ; AF33 94 96                    ..
        pha                                     ; AF35 48                       H
        bpl     LAF48                           ; AF36 10 10                    ..
        brk                                     ; AF38 00                       .
        bcs     LAEEC                           ; AF39 B0 B1                    ..
        lda     ($B1),y                         ; AF3B B1 B1                    ..
LAF3D:  pla                                     ; AF3D 68                       h
        .byte   $5A                             ; AF3E 5A                       Z
        bpl     LAF13                           ; AF3F 10 D2                    ..
        bne     LAF1C                           ; AF41 D0 D9                    ..
        .byte   $90                             ; AF43 90                       .
LAF44:  .byte   $D0,$97                    ; AF44 D0 97   (branch out of range for ca65: target has no local label)
        pha                                     ; AF46 48                       H
        .byte   $10                             ; AF47 10                       .
LAF48:  .byte   $F2                             ; AF48 F2                       .
        beq     LAF44                           ; AF49 F0 F9                    ..
        .byte   $B0                             ; AF4B B0                       .
LAF4C:  .byte   $F0,$B7                    ; AF4C F0 B7   (branch out of range for ca65: target has no local label)
        bcs     LAF01                           ; AF4E B0 B1                    ..
        bne     LAF24                           ; AF50 D0 D2                    ..
        .byte   $D4                             ; AF52 D4                       .
        dec     $D8,x                           ; AF53 D6 D8                    ..
        .byte   $DA                             ; AF55 DA                       .
        bpl     LAF76                           ; AF56 10 1E                    ..
        beq     LAF4C                           ; AF58 F0 F2                    ..
        .byte   $F4                             ; AF5A F4                       .
        inc     $F8,x                           ; AF5B F6 F8                    ..
        .byte   $FA                             ; AF5D FA                       .
        lda     ($13),y                         ; AF5E B1 13                    ..
        dec     $9290,x                         ; AF60 DE 90 92                 ...
        sty     $96,x                           ; AF63 94 96                    ..
        cpx     a:$EE                           ; AF65 EC EE 00                 ...
        brk                                     ; AF68 00                       .
        bcs     LAF1C                           ; AF69 B0 B1                    ..
        lda     ($B1),y                         ; AF6B B1 B1                    ..
        .byte   $F4                             ; AF6D F4                       .
        inc     LBA00,x                         ; AF6E FE 00 BA                 ...
        ldy     LBEBC,x                         ; AF71 BC BC BE                 ...
        sta     L0000                           ; AF74 85 00                    ..
LAF76:  ldy     $B2,x                           ; AF76 B4 B2                    ..
        tsx                                     ; AF78 BA                       .
        ldy     LBEBC,x                         ; AF79 BC BC BE                 ...
        .byte   $FA                             ; AF7C FA                       .
        beq     LAF7F                           ; AF7D F0 00                    ..
LAF7F:  brk                                     ; AF7F 00                       .
        bvc     LAFD4                           ; AF80 50 52                    PR
        .byte   $54                             ; AF82 54                       T
        lsr     $5C,x                           ; AF83 56 5C                    V\
        lsr     $5E5C,x                         ; AF85 5E 5C 5E                 ^\^
        bvs     LAFFC                           ; AF88 70 72                    pr
        .byte   $64                             ; AF8A 64                       d
        ror     $7C                             ; AF8B 66 7C                    f|
        ror     $7E7C,x                         ; AF8D 7E 7C 7E                 ~|~
        rti                                     ; AF90 40                       @

; ----------------------------------------------------------------------------
        .byte   $42                             ; AF91 42                       B
        and     ($21,x)                         ; AF92 21 21                    !!
        .byte   $22                             ; AF94 22                       "
        brk                                     ; AF95 00                       .
        .byte   $3C                             ; AF96 3C                       <
        rol     a:L0000,x                       ; AF97 3E 00 00                 >..
        brk                                     ; AF9A 00                       .
        brk                                     ; AF9B 00                       .
        .byte   $22                             ; AF9C 22                       "
        .byte   $22                             ; AF9D 22                       "
        brk                                     ; AF9E 00                       .
        brk                                     ; AF9F 00                       .
        cli                                     ; AFA0 58                       X
        brk                                     ; AFA1 00                       .
        .byte   $DC                             ; AFA2 DC                       .
        cmp     LB8DF,x                         ; AFA3 DD DF B8                 ...
        cmp     $5600,x                         ; AFA6 DD 00 56                 ..V
        lsr     a                               ; AFA9 4A                       J
        cmp     a:$B8,x                         ; AFAA DD B8 00                 ...
LAFAD:  clv                                     ; AFAD B8                       .
        cmp     a:L0000                         ; AFAE CD 00 00                 ...
        brk                                     ; AFB1 00                       .
        brk                                     ; AFB2 00                       .
        brk                                     ; AFB3 00                       .
        brk                                     ; AFB4 00                       .
        brk                                     ; AFB5 00                       .
        cmp     a:L0000                         ; AFB6 CD 00 00                 ...
        brk                                     ; AFB9 00                       .
        brk                                     ; AFBA 00                       .
        brk                                     ; AFBB 00                       .
        brk                                     ; AFBC 00                       .
        brk                                     ; AFBD 00                       .
        brk                                     ; AFBE 00                       .
        brk                                     ; AFBF 00                       .
        brk                                     ; AFC0 00                       .
        brk                                     ; AFC1 00                       .
        brk                                     ; AFC2 00                       .
        brk                                     ; AFC3 00                       .
        .byte   $47                             ; AFC4 47                       G
        brk                                     ; AFC5 00                       .
        brk                                     ; AFC6 00                       .
        brk                                     ; AFC7 00                       .
        brk                                     ; AFC8 00                       .
        brk                                     ; AFC9 00                       .
        clc                                     ; AFCA 18                       .
        .byte   $1A                             ; AFCB 1A                       .
        .byte   $1C                             ; AFCC 1C                       .
        asl     a:$6F,x                         ; AFCD 1E 6F 00                 .o.
        brk                                     ; AFD0 00                       .
        pla                                     ; AFD1 68                       h
        bpl     LAFE6                           ; AFD2 10 12                    ..
LAFD4:  .byte   $14                             ; AFD4 14                       .
        asl     $6A,x                           ; AFD5 16 6A                    .j
        brk                                     ; AFD7 00                       .
        brk                                     ; AFD8 00                       .
        .byte   $7F                             ; AFD9 7F                       .
        bmi     LB00E                           ; AFDA 30 32                    02
        .byte   $34                             ; AFDC 34                       4
        rol     L0000,x                         ; AFDD 36 00                    6.
        brk                                     ; AFDF 00                       .
        brk                                     ; AFE0 00                       .
        brk                                     ; AFE1 00                       .
        bvc     LB036                           ; AFE2 50 52                    PR
        .byte   $54                             ; AFE4 54                       T
        .byte   $56                             ; AFE5 56                       V
LAFE6:  brk                                     ; AFE6 00                       .
        brk                                     ; AFE7 00                       .
        brk                                     ; AFE8 00                       .
        .byte   $5C                             ; AFE9 5C                       \
        bvs     LB05E                           ; AFEA 70 72                    pr
        .byte   $74                             ; AFEC 74                       t
        ror     $5E,x                           ; AFED 76 5E                    v^
        brk                                     ; AFEF 00                       .
        brk                                     ; AFF0 00                       .
        brk                                     ; AFF1 00                       .
        sec                                     ; AFF2 38                       8
        .byte   $3A                             ; AFF3 3A                       :
        .byte   $3C                             ; AFF4 3C                       <
        rol     a:$7E,x                         ; AFF5 3E 7E 00                 >~.
        brk                                     ; AFF8 00                       .
        brk                                     ; AFF9 00                       .
        brk                                     ; AFFA 00                       .
        brk                                     ; AFFB 00                       .
LAFFC:  .byte   $22                             ; AFFC 22                       "
        brk                                     ; AFFD 00                       .
        brk                                     ; AFFE 00                       .
LAFFF:  brk                                     ; AFFF 00                       .
        brk                                     ; B000 00                       .
        ora     $9D0D                           ; B001 0D 0D 9D                 ...
        ora     $17,x                           ; B004 15 17                    ..
        brk                                     ; B006 00                       .
        .byte   $9F                             ; B007 9F                       .
        .byte   $82                             ; B008 82                       .
        sta     $291D,y                         ; B009 99 1D 29                 ..)
        and     $37,x                           ; B00C 35 37                    57
LB00E:  and     $843F,x                         ; B00E 3D 3F 84                 =?.
        sta     $3B39,y                         ; B011 99 39 3B                 .9;
        and     #$2B                            ; B014 29 2B                    )+
        adc     $67                             ; B016 65 67                    eg
        .byte   $9B                             ; B018 9B                       .
        sta     $7F79,y                         ; B019 99 79 7F                 .y.
        eor     ($43,x)                         ; B01C 41 43                    AC
        and     $D13B,y                         ; B01E 39 3B D1                 9;.
LB021:  .byte   $D3                             ; B021 D3                       .
        cmp     $D7,x                           ; B022 D5 D7                    ..
        cmp     $EDDB,y                         ; B024 D9 DB ED                 ...
        .byte   $EF                             ; B027 EF                       .
        sbc     ($F3),y                         ; B028 F1 F3                    ..
        sbc     $F7,x                           ; B02A F5 F7                    ..
        sbc     $FDFB,y                         ; B02C F9 FB FD                 ...
        .byte   $FF                             ; B02F FF                       .
        .byte   $2B                             ; B030 2B                       +
        sta     ($93),y                         ; B031 91 93                    ..
        sta     $97,x                           ; B033 95 97                    ..
        .byte   $10                             ; B035 10                       .
LB036:  bpl     LB081                           ; B036 10 49                    .I
        brk                                     ; B038 00                       .
        lda     ($B1),y                         ; B039 B1 B1                    ..
        lda     ($B7),y                         ; B03B B1 B7                    ..
        bpl     LB09A                           ; B03D 10 5B                    .[
        adc     #$D9                            ; B03F 69 D9                    i.
        .byte   $D2                             ; B041 D2                       .
        .byte   $DB                             ; B042 DB                       .
        .byte   $97                             ; B043 97                       .
        bcc     LB021                           ; B044 90 DB                    ..
        bpl     LB091                           ; B046 10 49                    .I
        .byte   $F9                             ; B048 F9                       .
LB049:  .byte   $F2                             ; B049 F2                       .
        .byte   $FB                             ; B04A FB                       .
        .byte   $B7                             ; B04B B7                       .
        bcs     LB049                           ; B04C B0 FB                    ..
        lda     ($B7),y                         ; B04E B1 B7                    ..
        cmp     ($D3),y                         ; B050 D1 D3                    ..
        cmp     $D7,x                           ; B052 D5 D7                    ..
        cmp     $10DB,y                         ; B054 D9 DB 10                 ...
        .byte   $1F                             ; B057 1F                       .
        sbc     ($F3),y                         ; B058 F1 F3                    ..
        sbc     $F7,x                           ; B05A F5 F7                    ..
        .byte   $F9                             ; B05C F9                       .
        .byte   $FB                             ; B05D FB                       .
LB05E:  lda     ($13),y                         ; B05E B1 13                    ..
        .byte   $DF                             ; B060 DF                       .
        sta     ($93),y                         ; B061 91 93                    ..
        sta     $97,x                           ; B063 95 97                    ..
        sbc     a:$EF                           ; B065 ED EF 00                 ...
        brk                                     ; B068 00                       .
        lda     ($B1),y                         ; B069 B1 B1                    ..
        lda     ($B7),y                         ; B06B B1 B7                    ..
        sbc     a:$FF,x                         ; B06D FD FF 00                 ...
        .byte   $BB                             ; B070 BB                       .
        lda     LBFBD,x                         ; B071 BD BD BF                 ...
        .byte   $B2                             ; B074 B2                       .
        .byte   $B3                             ; B075 B3                       .
        lda     $86,x                           ; B076 B5 86                    ..
        .byte   $BB                             ; B078 BB                       .
        lda     LBFBD,x                         ; B079 BD BD BF                 ...
        .byte   $FB                             ; B07C FB                       .
        sbc     (L0000),y                       ; B07D F1 00                    ..
        brk                                     ; B07F 00                       .
        .byte   $51                             ; B080 51                       Q
LB081:  .byte   $53                             ; B081 53                       S
        eor     $57,x                           ; B082 55 57                    UW
        eor     $5D5F,x                         ; B084 5D 5F 5D                 ]_]
        .byte   $5F                             ; B087 5F                       _
        adc     ($73),y                         ; B088 71 73                    qs
        adc     $67                             ; B08A 65 67                    eg
        adc     $7D7F,x                         ; B08C 7D 7F 7D                 }.}
        .byte   $7F                             ; B08F 7F                       .
        .byte   $41                             ; B090 41                       A
LB091:  .byte   $43                             ; B091 43                       C
        and     ($21,x)                         ; B092 21 21                    !!
        .byte   $22                             ; B094 22                       "
        brk                                     ; B095 00                       .
        .byte   $3D                             ; B096 3D                       =
        .byte   $3F                             ; B097 3F                       ?
LB098:  brk                                     ; B098 00                       .
        brk                                     ; B099 00                       .
LB09A:  brk                                     ; B09A 00                       .
        brk                                     ; B09B 00                       .
        .byte   $22                             ; B09C 22                       "
        .byte   $22                             ; B09D 22                       "
        brk                                     ; B09E 00                       .
        brk                                     ; B09F 00                       .
        brk                                     ; B0A0 00                       .
        brk                                     ; B0A1 00                       .
        cmp     a:$DE,x                         ; B0A2 DD DE 00                 ...
        cpy     a:$DE                           ; B0A5 CC DE 00                 ...
        brk                                     ; B0A8 00                       .
        brk                                     ; B0A9 00                       .
        cmp     a:$DC,x                         ; B0AA DD DC 00                 ...
        cpy     a:L0000                         ; B0AD CC 00 00                 ...
        brk                                     ; B0B0 00                       .
        brk                                     ; B0B1 00                       .
        brk                                     ; B0B2 00                       .
        brk                                     ; B0B3 00                       .
        brk                                     ; B0B4 00                       .
        brk                                     ; B0B5 00                       .
        brk                                     ; B0B6 00                       .
        brk                                     ; B0B7 00                       .
        brk                                     ; B0B8 00                       .
        brk                                     ; B0B9 00                       .
        brk                                     ; B0BA 00                       .
        brk                                     ; B0BB 00                       .
        brk                                     ; B0BC 00                       .
        brk                                     ; B0BD 00                       .
        brk                                     ; B0BE 00                       .
        brk                                     ; B0BF 00                       .
        brk                                     ; B0C0 00                       .
        brk                                     ; B0C1 00                       .
        brk                                     ; B0C2 00                       .
        rti                                     ; B0C3 40                       @

; ----------------------------------------------------------------------------
        brk                                     ; B0C4 00                       .
        brk                                     ; B0C5 00                       .
        brk                                     ; B0C6 00                       .
        brk                                     ; B0C7 00                       .
        brk                                     ; B0C8 00                       .
        jmp     (L1B19)                         ; B0C9 6C 19 1B                 l..

; ----------------------------------------------------------------------------
        ora     a:$1F,x                         ; B0CC 1D 1F 00                 ...
        brk                                     ; B0CF 00                       .
        brk                                     ; B0D0 00                       .
        adc     #$11                            ; B0D1 69 11                    i.
        .byte   $14                             ; B0D3 14                       .
        ora     $17,x                           ; B0D4 15 17                    ..
        .byte   $6B                             ; B0D6 6B                       k
        brk                                     ; B0D7 00                       .
        brk                                     ; B0D8 00                       .
        brk                                     ; B0D9 00                       .
        and     ($33),y                         ; B0DA 31 33                    13
        and     $37,x                           ; B0DC 35 37                    57
        .byte   $7F                             ; B0DE 7F                       .
        brk                                     ; B0DF 00                       .
        brk                                     ; B0E0 00                       .
        brk                                     ; B0E1 00                       .
        eor     ($53),y                         ; B0E2 51 53                    QS
        eor     $57,x                           ; B0E4 55 57                    UW
        brk                                     ; B0E6 00                       .
        brk                                     ; B0E7 00                       .
        brk                                     ; B0E8 00                       .
        eor     $7371,x                         ; B0E9 5D 71 73                 ]qs
        adc     $77,x                           ; B0EC 75 77                    uw
        .byte   $5F                             ; B0EE 5F                       _
        brk                                     ; B0EF 00                       .
        brk                                     ; B0F0 00                       .
        adc     $3B39,x                         ; B0F1 7D 39 3B                 }9;
        and     a:$3F,x                         ; B0F4 3D 3F 00                 =?.
        brk                                     ; B0F7 00                       .
        brk                                     ; B0F8 00                       .
        brk                                     ; B0F9 00                       .
        brk                                     ; B0FA 00                       .
        .byte   $13                             ; B0FB 13                       .
        brk                                     ; B0FC 00                       .
        brk                                     ; B0FD 00                       .
        brk                                     ; B0FE 00                       .
        brk                                     ; B0FF 00                       .
        brk                                     ; B100 00                       .
        rti                                     ; B101 40                       @

; ----------------------------------------------------------------------------
        jsr     L12F1                           ; B102 20 F1 12                  ..
        .byte   $12                             ; B105 12                       .
        sta     ($13,x)                         ; B106 81 13                    ..
        .byte   $80                             ; B108 80                       .
        .byte   $82                             ; B109 82                       .
        .byte   $02                             ; B10A 02                       .
        .byte   $82                             ; B10B 82                       .
        .byte   $12                             ; B10C 12                       .
        .byte   $12                             ; B10D 12                       .
        bpl     LB120                           ; B10E 10 10                    ..
        .byte   $80                             ; B110 80                       .
        .byte   $82                             ; B111 82                       .
        .byte   $03                             ; B112 03                       .
        .byte   $03                             ; B113 03                       .
        .byte   $03                             ; B114 03                       .
        .byte   $03                             ; B115 03                       .
        .byte   $82                             ; B116 82                       .
        .byte   $82                             ; B117 82                       .
        .byte   $82                             ; B118 82                       .
        .byte   $82                             ; B119 82                       .
        .byte   $73                             ; B11A 73                       s
        .byte   $53                             ; B11B 53                       S
        .byte   $03                             ; B11C 03                       .
        .byte   $03                             ; B11D 03                       .
        .byte   $82                             ; B11E 82                       .
        .byte   $82                             ; B11F 82                       .
LB120:  bpl     LB132                           ; B120 10 10                    ..
        bpl     LB134                           ; B122 10 10                    ..
        bpl     LB136                           ; B124 10 10                    ..
        .byte   $12                             ; B126 12                       .
        .byte   $12                             ; B127 12                       .
        bpl     LB13A                           ; B128 10 10                    ..
        bpl     LB13C                           ; B12A 10 10                    ..
        bpl     LB13E                           ; B12C 10 10                    ..
        .byte   $12                             ; B12E 12                       .
        .byte   $12                             ; B12F 12                       .
        .byte   $82                             ; B130 82                       .
        .byte   $10                             ; B131 10                       .
LB132:  bpl     LB144                           ; B132 10 10                    ..
LB134:  bpl     LB146                           ; B134 10 10                    ..
LB136:  bpl     LB148                           ; B136 10 10                    ..
        brk                                     ; B138 00                       .
        .byte   $10                             ; B139 10                       .
LB13A:  bpl     LB14C                           ; B13A 10 10                    ..
LB13C:  bpl     LB14E                           ; B13C 10 10                    ..
LB13E:  bpl     LB150                           ; B13E 10 10                    ..
        bpl     LB152                           ; B140 10 10                    ..
        bpl     LB154                           ; B142 10 10                    ..
LB144:  bpl     LB156                           ; B144 10 10                    ..
LB146:  bpl     LB158                           ; B146 10 10                    ..
LB148:  bpl     LB15A                           ; B148 10 10                    ..
        bpl     LB15C                           ; B14A 10 10                    ..
LB14C:  bpl     LB15E                           ; B14C 10 10                    ..
LB14E:  bpl     LB160                           ; B14E 10 10                    ..
LB150:  ora     ($11),y                         ; B150 11 11                    ..
LB152:  ora     ($11),y                         ; B152 11 11                    ..
LB154:  ora     ($11),y                         ; B154 11 11                    ..
LB156:  bpl     LB168                           ; B156 10 10                    ..
LB158:  ora     ($11),y                         ; B158 11 11                    ..
LB15A:  ora     ($11),y                         ; B15A 11 11                    ..
LB15C:  ora     ($11),y                         ; B15C 11 11                    ..
LB15E:  bpl     LB150                           ; B15E 10 F0                    ..
LB160:  brk                                     ; B160 00                       .
        ora     ($11),y                         ; B161 11 11                    ..
        ora     ($11),y                         ; B163 11 11                    ..
        ora     ($11),y                         ; B165 11 11                    ..
        brk                                     ; B167 00                       .
LB168:  brk                                     ; B168 00                       .
        ora     ($11),y                         ; B169 11 11                    ..
        ora     ($11),y                         ; B16B 11 11                    ..
        ora     ($11),y                         ; B16D 11 11                    ..
        brk                                     ; B16F 00                       .
        ora     ($11),y                         ; B170 11 11                    ..
        ora     ($11),y                         ; B172 11 11                    ..
        ora     ($11),y                         ; B174 11 11                    ..
        ora     ($11),y                         ; B176 11 11                    ..
        bpl     LB18A                           ; B178 10 10                    ..
        bpl     LB18C                           ; B17A 10 10                    ..
        ora     ($11),y                         ; B17C 11 11                    ..
        brk                                     ; B17E 00                       .
        brk                                     ; B17F 00                       .
        .byte   $03                             ; B180 03                       .
        .byte   $03                             ; B181 03                       .
        .byte   $03                             ; B182 03                       .
        .byte   $03                             ; B183 03                       .
        .byte   $03                             ; B184 03                       .
        .byte   $03                             ; B185 03                       .
        .byte   $82                             ; B186 82                       .
        .byte   $82                             ; B187 82                       .
        .byte   $03                             ; B188 03                       .
        .byte   $03                             ; B189 03                       .
LB18A:  .byte   $03                             ; B18A 03                       .
        .byte   $03                             ; B18B 03                       .
LB18C:  .byte   $03                             ; B18C 03                       .
        .byte   $03                             ; B18D 03                       .
        .byte   $82                             ; B18E 82                       .
        .byte   $82                             ; B18F 82                       .
        .byte   $03                             ; B190 03                       .
        .byte   $03                             ; B191 03                       .
        brk                                     ; B192 00                       .
        brk                                     ; B193 00                       .
        .byte   $02                             ; B194 02                       .
        brk                                     ; B195 00                       .
        .byte   $82                             ; B196 82                       .
        .byte   $82                             ; B197 82                       .
        brk                                     ; B198 00                       .
        brk                                     ; B199 00                       .
        brk                                     ; B19A 00                       .
        brk                                     ; B19B 00                       .
        .byte   $02                             ; B19C 02                       .
        .byte   $02                             ; B19D 02                       .
        brk                                     ; B19E 00                       .
        brk                                     ; B19F 00                       .
        .byte   $80                             ; B1A0 80                       .
        .byte   $80                             ; B1A1 80                       .
        .byte   $82                             ; B1A2 82                       .
        .byte   $82                             ; B1A3 82                       .
        .byte   $83                             ; B1A4 83                       .
        .byte   $82                             ; B1A5 82                       .
        .byte   $82                             ; B1A6 82                       .
        brk                                     ; B1A7 00                       .
        .byte   $80                             ; B1A8 80                       .
        .byte   $80                             ; B1A9 80                       .
        .byte   $82                             ; B1AA 82                       .
        .byte   $82                             ; B1AB 82                       .
        .byte   $82                             ; B1AC 82                       .
        .byte   $82                             ; B1AD 82                       .
        .byte   $82                             ; B1AE 82                       .
        brk                                     ; B1AF 00                       .
        brk                                     ; B1B0 00                       .
        brk                                     ; B1B1 00                       .
        brk                                     ; B1B2 00                       .
        brk                                     ; B1B3 00                       .
        brk                                     ; B1B4 00                       .
        brk                                     ; B1B5 00                       .
        .byte   $82                             ; B1B6 82                       .
        brk                                     ; B1B7 00                       .
        brk                                     ; B1B8 00                       .
        brk                                     ; B1B9 00                       .
        brk                                     ; B1BA 00                       .
        brk                                     ; B1BB 00                       .
        brk                                     ; B1BC 00                       .
        brk                                     ; B1BD 00                       .
        brk                                     ; B1BE 00                       .
        brk                                     ; B1BF 00                       .
        brk                                     ; B1C0 00                       .
        brk                                     ; B1C1 00                       .
        brk                                     ; B1C2 00                       .
        .byte   $03                             ; B1C3 03                       .
        .byte   $03                             ; B1C4 03                       .
        brk                                     ; B1C5 00                       .
        brk                                     ; B1C6 00                       .
        brk                                     ; B1C7 00                       .
        brk                                     ; B1C8 00                       .
        ora     ($01,x)                         ; B1C9 01 01                    ..
        ora     ($01,x)                         ; B1CB 01 01                    ..
        ora     ($01,x)                         ; B1CD 01 01                    ..
        brk                                     ; B1CF 00                       .
        brk                                     ; B1D0 00                       .
        ora     ($03,x)                         ; B1D1 01 03                    ..
        .byte   $03                             ; B1D3 03                       .
        .byte   $03                             ; B1D4 03                       .
        .byte   $03                             ; B1D5 03                       .
        ora     (L0000,x)                       ; B1D6 01 00                    ..
        brk                                     ; B1D8 00                       .
        ora     ($02,x)                         ; B1D9 01 02                    ..
        .byte   $02                             ; B1DB 02                       .
        .byte   $02                             ; B1DC 02                       .
        .byte   $02                             ; B1DD 02                       .
        ora     (L0000,x)                       ; B1DE 01 00                    ..
        brk                                     ; B1E0 00                       .
        brk                                     ; B1E1 00                       .
        .byte   $03                             ; B1E2 03                       .
        .byte   $03                             ; B1E3 03                       .
        .byte   $03                             ; B1E4 03                       .
        .byte   $03                             ; B1E5 03                       .
        brk                                     ; B1E6 00                       .
        brk                                     ; B1E7 00                       .
        brk                                     ; B1E8 00                       .
        ora     ($02,x)                         ; B1E9 01 02                    ..
        .byte   $02                             ; B1EB 02                       .
        .byte   $02                             ; B1EC 02                       .
        .byte   $02                             ; B1ED 02                       .
        ora     (L0000,x)                       ; B1EE 01 00                    ..
        brk                                     ; B1F0 00                       .
        ora     ($01,x)                         ; B1F1 01 01                    ..
        ora     ($01,x)                         ; B1F3 01 01                    ..
        ora     ($01,x)                         ; B1F5 01 01                    ..
        brk                                     ; B1F7 00                       .
        brk                                     ; B1F8 00                       .
        ora     ($01,x)                         ; B1F9 01 01                    ..
        ora     ($01,x)                         ; B1FB 01 01                    ..
        ora     (L0000,x)                       ; B1FD 01 00                    ..
        brk                                     ; B1FF 00                       .
        and     $4F                             ; B200 25 4F                    %O
        and     $5E00                           ; B202 2D 00 5E                 -.^
        .byte   $4F                             ; B205 4F                       O
        brk                                     ; B206 00                       .
        brk                                     ; B207 00                       .
        and     $85                             ; B208 25 85                    %.
        and     $848D                           ; B20A 2D 8D 84                 -..
        sta     $8C                             ; B20D 85 8C                    ..
        sta     $8584                           ; B20F 8D 84 85                 ...
        sty     $8478                           ; B212 8C 78 84                 .x.
        sta     $79                             ; B215 85 79                    .y
        .byte   $7B                             ; B217 7B                       {
        jsr     L2831                           ; B218 20 31 28                  1(
        and     #$32                            ; B21B 29 32                    )2
        .byte   $33                             ; B21D 33                       3
        rol     a                               ; B21E 2A                       *
        .byte   $2B                             ; B21F 2B                       +
        .byte   $34                             ; B220 34                       4
        and     $2C                             ; B221 25 2C                    %,
        and     L2120                           ; B223 2D 20 21                 - !
        plp                                     ; B226 28                       (
        and     #$22                            ; B227 29 22                    )"
        .byte   $23                             ; B229 23                       #
        rol     a                               ; B22A 2A                       *
        .byte   $2B                             ; B22B 2B                       +
        bit     $25                             ; B22C 24 25                    $%
        bit     $262D                           ; B22E 2C 2D 26                 ,-&
        .byte   $27                             ; B231 27                       '
        rol     $842F                           ; B232 2E 2F 84                 ./.
        sta     $8C                             ; B235 85 8C                    ..
        .byte   $57                             ; B237 57                       W
        .byte   $44                             ; B238 44                       D
        eor     $49                             ; B239 45 49                    EI
        lsr     a                               ; B23B 4A                       J
        adc     $66                             ; B23C 65 66                    ef
        adc     $416E                           ; B23E 6D 6E 41                 mnA
        .byte   $42                             ; B241 42                       B
        jmp     L204D                           ; B242 4C 4D 20                 LM 

; ----------------------------------------------------------------------------
        and     ($28),y                         ; B245 31 28                    1(
        and     $2534,y                         ; B247 39 34 25                 94%
        .byte   $3C                             ; B24A 3C                       <
        and     L2120                           ; B24B 2D 20 21                 - !
        plp                                     ; B24E 28                       (
        and     $2322,y                         ; B24F 39 22 23                 9"#
        .byte   $3A                             ; B252 3A                       :
        .byte   $3B                             ; B253 3B                       ;
        sta     $20                             ; B254 85 20                    . 
        .byte   $57                             ; B256 57                       W
        plp                                     ; B257 28                       (
        and     ($32),y                         ; B258 31 32                    12
        and     $323A,y                         ; B25A 39 3A 32                 9:2
        .byte   $33                             ; B25D 33                       3
        .byte   $3A                             ; B25E 3A                       :
        .byte   $3B                             ; B25F 3B                       ;
        brk                                     ; B260 00                       .
        brk                                     ; B261 00                       .
        sty     $248D                           ; B262 8C 8D 24                 ..$
        and     $3C                             ; B265 25 3C                    %<
        and     L2000                           ; B267 2D 00 20                 -. 
        sty     $8428                           ; B26A 8C 28 84                 .(.
        jsr     L288C                           ; B26D 20 8C 28                  .(
        sty     $85                             ; B270 84 85                    ..
        .byte   $5F                             ; B272 5F                       _
        .byte   $5F                             ; B273 5F                       _
        .byte   $32                             ; B274 32                       2
        .byte   $34                             ; B275 34                       4
        rol     a                               ; B276 2A                       *
        bit     $8525                           ; B277 2C 25 85                 ,%.
        and     $845F                           ; B27A 2D 5F 84                 -_.
        sta     $5F                             ; B27D 85 5F                    ._
        sta     $2B2A                           ; B27F 8D 2A 2B                 .*+
        .byte   $22                             ; B282 22                       "
        .byte   $23                             ; B283 23                       #
        bit     $242D                           ; B284 2C 2D 24                 ,-$
        and     $28                             ; B287 25 28                    %(
        and     #$20                            ; B289 29 20                    ) 
        and     ($2A,x)                         ; B28B 21 2A                    !*
        bit     $2422                           ; B28D 2C 22 24                 ,"$
        and     $258D                           ; B290 2D 8D 25                 -.%
        sta     $8C                             ; B293 85 8C                    ..
        plp                                     ; B295 28                       (
        sty     $20                             ; B296 84 20                    . 
        .byte   $3A                             ; B298 3A                       :
        .byte   $3B                             ; B299 3B                       ;
        .byte   $32                             ; B29A 32                       2
        .byte   $33                             ; B29B 33                       3
        .byte   $3C                             ; B29C 3C                       <
        and     $3332                           ; B29D 2D 32 33                 -23
        plp                                     ; B2A0 28                       (
        and     $2534,y                         ; B2A1 39 34 25                 94%
        .byte   $3A                             ; B2A4 3A                       :
        .byte   $3B                             ; B2A5 3B                       ;
        brk                                     ; B2A6 00                       .
        brk                                     ; B2A7 00                       .
        .byte   $3A                             ; B2A8 3A                       :
        .byte   $3C                             ; B2A9 3C                       <
        brk                                     ; B2AA 00                       .
        brk                                     ; B2AB 00                       .
        and     a:$8D                           ; B2AC 2D 8D 00                 -..
        sta     $8C                             ; B2AF 85 8C                    ..
        sta     $8584                           ; B2B1 8D 84 85                 ...
        sty     $208D                           ; B2B4 8C 8D 20                 .. 
        and     ($8C),y                         ; B2B7 31 8C                    1.
        sta     $3332                           ; B2B9 8D 32 33                 .23
        sty     $3228                           ; B2BC 8C 28 32                 .(2
        .byte   $33                             ; B2BF 33                       3
        .byte   $5A                             ; B2C0 5A                       Z
        .byte   $5B                             ; B2C1 5B                       [
        .byte   $52                             ; B2C2 52                       R
        .byte   $53                             ; B2C3 53                       S
        .byte   $5C                             ; B2C4 5C                       \
        .byte   $7C                             ; B2C5 7C                       |
        .byte   $54                             ; B2C6 54                       T
        eor     $06,x                           ; B2C7 55 06                    U.
        asl     $96                             ; B2C9 06 96                    ..
        .byte   $97                             ; B2CB 97                       .
        adc     $5059,x                         ; B2CC 7D 59 50                 }YP
        eor     ($5A),y                         ; B2CF 51 5A                    QZ
        .byte   $5B                             ; B2D1 5B                       [
        adc     $66                             ; B2D2 65 66                    ef
        .byte   $5C                             ; B2D4 5C                       \
        eor     $5554,x                         ; B2D5 5D 54 55                 ]TU
        stx     $868F                           ; B2D8 8E 8F 86                 ...
        .byte   $87                             ; B2DB 87                       .
        cli                                     ; B2DC 58                       X
        eor     $5150,y                         ; B2DD 59 50 51                 YPQ
        adc     $526E                           ; B2E0 6D 6E 52                 mnR
        .byte   $53                             ; B2E3 53                       S
        .byte   $52                             ; B2E4 52                       R
        .byte   $53                             ; B2E5 53                       S
        .byte   $5A                             ; B2E6 5A                       Z
        .byte   $5B                             ; B2E7 5B                       [
        .byte   $54                             ; B2E8 54                       T
        eor     $5C,x                           ; B2E9 55 5C                    U\
        eor     $8786,x                         ; B2EB 5D 86 87                 ]..
        stx     $508F                           ; B2EE 8E 8F 50                 ..P
        eor     ($58),y                         ; B2F1 51 58                    QX
        eor     $5352,y                         ; B2F3 59 52 53                 YRS
        ror     a                               ; B2F6 6A                       j
        .byte   $6B                             ; B2F7 6B                       k
        .byte   $54                             ; B2F8 54                       T
        eor     $6C,x                           ; B2F9 55 6C                    Ul
        eor     $5150,x                         ; B2FB 5D 50 51                 ]PQ
        cli                                     ; B2FE 58                       X
        adc     #$A1                            ; B2FF 69 A1                    i.
        lda     ($8E,x)                         ; B301 A1 8E                    ..
        .byte   $8F                             ; B303 8F                       .
        .byte   $62                             ; B304 62                       b
        .byte   $63                             ; B305 63                       c
        .byte   $5A                             ; B306 5A                       Z
        .byte   $5B                             ; B307 5B                       [
        .byte   $64                             ; B308 64                       d
        eor     $5C,x                           ; B309 55 5C                    U\
        eor     $6150,x                         ; B30B 5D 50 61                 ]Pa
        cli                                     ; B30E 58                       X
        eor     $30A1,y                         ; B30F 59 A1 30                 Y.0
        .byte   $8E,$17,$A1                     ; B312 8E 17 A1                 ...
        lda     ($A1,x)                         ; B315 A1 A1                    ..
        lda     ($A1,x)                         ; B317 A1 A1                    ..
        lda     ($A5,x)                         ; B319 A1 A5                    ..
        lda     ($A1,x)                         ; B31B A1 A1                    ..
        ora     #$A1                            ; B31D 09 A1                    ..
        ora     ($A1),y                         ; B31F 11 A1                    ..
        ora     #$AC                            ; B321 09 AC                    ..
        ora     ($AB),y                         ; B323 11 AB                    ..
        lda     ($AD,x)                         ; B325 A1 AD                    ..
        ldx     $18A1                           ; B327 AE A1 18                 ...
        lda     ($11,x)                         ; B32A A1 11                    ..
        ldy     $19                             ; B32C A4 19                    ..
        lda     ($11,x)                         ; B32E A1 11                    ..
        lda     $A1                             ; B330 A5 A1                    ..
        lda     $A1                             ; B332 A5 A1                    ..
        lda     ($11,x)                         ; B334 A1 11                    ..
        lda     ($11,x)                         ; B336 A1 11                    ..
        lda     ($A1,x)                         ; B338 A1 A1                    ..
        lda     ($A5,x)                         ; B33A A1 A5                    ..
        lda     ($19,x)                         ; B33C A1 19                    ..
        lda     ($11,x)                         ; B33E A1 11                    ..
        lda     ($A5,x)                         ; B340 A1 A5                    ..
        lda     #$A5                            ; B342 A9 A5                    ..
        lda     ($18,x)                         ; B344 A1 18                    ..
        .byte   $AC,$11,$A1                     ; B346 AC 11 A1                 ...
        ora     ($AC),y                         ; B349 11 AC                    ..
        ora     ($A5),y                         ; B34B 11 A5                    ..
        lda     ($AD,x)                         ; B34D A1 AD                    ..
        .byte   $AE,$A0,$A5                     ; B34F AE A0 A5                 ...
        tay                                     ; B352 A8                       .
        lda     $11A1                           ; B353 AD A1 11                 ...
        .byte   $AC,$1B,$A1                     ; B356 AC 1B A1                 ...
        .byte   $07                             ; B359 07                       .
        lda     ($09,x)                         ; B35A A1 09                    ..
        .byte   $07                             ; B35C 07                       .
        lda     $A1                             ; B35D A5 A1                    ..
        lda     $62                             ; B35F A5 62                    .b
        .byte   $64                             ; B361 64                       d
        .byte   $5A                             ; B362 5A                       Z
        .byte   $5C                             ; B363 5C                       \
        eor     $A1,x                           ; B364 55 A1                    U.
        eor     LA1A1,x                         ; B366 5D A1 A1                 ]..
        lda     $A1                             ; B369 A5 A1                    ..
        lda     $52                             ; B36B A5 52                    .R
        .byte   $54                             ; B36D 54                       T
        .byte   $5A                             ; B36E 5A                       Z
        .byte   $5C                             ; B36F 5C                       \
        ldy     #$09                            ; B370 A0 09                    ..
        tay                                     ; B372 A8                       .
        ora     ($50),y                         ; B373 11 50                    .P
        eor     $58,x                           ; B375 55 58                    UX
        eor     $7170,x                         ; B377 5D 70 71                 ]pq
        .byte   $03                             ; B37A 03                       .
        .byte   $03                             ; B37B 03                       .
        adc     ($73),y                         ; B37C 71 73                    qs
        .byte   $03                             ; B37E 03                       .
        .byte   $03                             ; B37F 03                       .
        lda     ($A1,x)                         ; B380 A1 A1                    ..
        ldy     $70AC                           ; B382 AC AC 70                 ..p
        adc     ($A1),y                         ; B385 71 A1                    q.
        ora     #$71                            ; B387 09 71                    .q
        .byte   $73                             ; B389 73                       s
        lda     ($A1,x)                         ; B38A A1 A1                    ..
        adc     ($71),y                         ; B38C 71 71                    qq
        lda     ($A1,x)                         ; B38E A1 A1                    ..
        ldy     $A1                             ; B390 A4 A1                    ..
        lda     ($A1,x)                         ; B392 A1 A1                    ..
        adc     ($73),y                         ; B394 71 73                    qs
        .byte   $03                             ; B396 03                       .
        .byte   $09                             ; B397 09                       .
LB398:  ldy     $11                             ; B398 A4 11                    ..
        ldy     $7311                           ; B39A AC 11 73                 ..s
        lda     ($A1,x)                         ; B39D A1 A1                    ..
        lda     ($A1,x)                         ; B39F A1 A1                    ..
        .byte   $1B                             ; B3A1 1B                       .
        lda     ($09,x)                         ; B3A2 A1 09                    ..
        .byte   $1B                             ; B3A4 1B                       .
        lda     ($A1,x)                         ; B3A5 A1 A1                    ..
        lda     ($A1,x)                         ; B3A7 A1 A1                    ..
        ora     $11A9,y                         ; B3A9 19 A9 11                 ...
        .byte   $1A                             ; B3AC 1A                       .
        ora     ($A1),y                         ; B3AD 11 A1                    ..
        ora     ($A0),y                         ; B3AF 11 A0                    ..
        ora     ($A8),y                         ; B3B1 11 A8                    ..
        ora     ($6A),y                         ; B3B3 11 6A                    .j
LB3B5:  .byte   $6B                             ; B3B5 6B                       k
        lda     ($09,x)                         ; B3B6 A1 09                    ..
        adc     ($71),y                         ; B3B8 71 71                    qq
        bvs     LB42D                           ; B3BA 70 71                    pq
        adc     ($73),y                         ; B3BC 71 73                    qs
        .byte   $73                             ; B3BE 73                       s
        .byte   $03                             ; B3BF 03                       .
        ldy     $70                             ; B3C0 A4 70                    .p
        lda     ($09,x)                         ; B3C2 A1 09                    ..
        adc     ($73),y                         ; B3C4 71 73                    qs
        lda     ($09,x)                         ; B3C6 A1 09                    ..
        lda     ($19,x)                         ; B3C8 A1 19                    ..
        bvs     LB43F                           ; B3CA 70 73                    ps
        lda     ($11,x)                         ; B3CC A1 11                    ..
        lda     ($18,x)                         ; B3CE A1 18                    ..
        lda     ($A1,x)                         ; B3D0 A1 A1                    ..
        .byte   $1B                             ; B3D2 1B                       .
        lda     ($A1,x)                         ; B3D3 A1 A1                    ..
        .byte   $1A                             ; B3D5 1A                       .
        lda     ($09,x)                         ; B3D6 A1 09                    ..
        ror     a                               ; B3D8 6A                       j
        .byte   $6B                             ; B3D9 6B                       k
        lda     ($A1,x)                         ; B3DA A1 A1                    ..
        jmp     (LA15D)                         ; B3DC 6C 5D A1                 l].

; ----------------------------------------------------------------------------
        lda     ($58,x)                         ; B3DF A1 58                    .X
        adc     #$A1                            ; B3E1 69 A1                    i.
        lda     ($6A,x)                         ; B3E3 A1 6A                    .j
        .byte   $6B                             ; B3E5 6B                       k
        .byte   $0B                             ; B3E6 0B                       .
        lda     ($70,x)                         ; B3E7 A1 70                    .p
        adc     ($A1),y                         ; B3E9 71 A1                    q.
        lda     ($70,x)                         ; B3EB A1 70                    .p
        .byte   $73                             ; B3ED 73                       s
        lda     ($A1,x)                         ; B3EE A1 A1                    ..
        asl     $87,x                           ; B3F0 16 87                    ..
        asl     $8F,x                           ; B3F2 16 8F                    ..
        adc     ($73),y                         ; B3F4 71 73                    qs
        lda     $A1                             ; B3F6 A5 A1                    ..
        bvc     LB45B                           ; B3F8 50 61                    Pa
        cli                                     ; B3FA 58                       X
        adc     #$64                            ; B3FB 69 64                    id
        eor     $6C,x                           ; B3FD 55 6C                    Ul
        eor     $5802,x                         ; B3FF 5D 02 58                 ].X
        .byte   $02                             ; B402 02                       .
        bvc     LB46F                           ; B403 50 6A                    Pj
        .byte   $6B                             ; B405 6B                       k
        lda     ($70,x)                         ; B406 A1 70                    .p
        jmp     (L715D)                         ; B408 6C 5D 71                 l]q

; ----------------------------------------------------------------------------
        .byte   $73                             ; B40B 73                       s
        stx     $70                             ; B40C 86 70                    .p
        stx     $86A1                           ; B40E 8E A1 86                 ...
        .byte   $87                             ; B411 87                       .
        stx     $8670                           ; B412 8E 70 86                 .p.
        .byte   $87                             ; B415 87                       .
        .byte   $73                             ; B416 73                       s
        bvs     LB41B                           ; B417 70 02                    p.
        cli                                     ; B419 58                       X
        .byte   $73                             ; B41A 73                       s
LB41B:  bvs     LB470                           ; B41B 70 53                    pS
        .byte   $54                             ; B41D 54                       T
        .byte   $5B                             ; B41E 5B                       [
        .byte   $5C                             ; B41F 5C                       \
        eor     $02,x                           ; B420 55 02                    U.
        eor     $7102,x                         ; B422 5D 02 71                 ].q
        adc     ($A1),y                         ; B425 71 A1                    q.
        bvs     LB48F                           ; B427 70 66                    pf
        .byte   $54                             ; B429 54                       T
        ror     $8E5C                           ; B42A 6E 5C 8E                 n\.
LB42D:  bvc     LB3B5                           ; B42D 50 86                    P.
        cli                                     ; B42F 58                       X
        .byte   $53                             ; B430 53                       S
        .byte   $54                             ; B431 54                       T
        .byte   $6B                             ; B432 6B                       k
        jmp     (L6362)                         ; B433 6C 62 63                 lbc

; ----------------------------------------------------------------------------
        ror     a                               ; B436 6A                       j
        .byte   $6B                             ; B437 6B                       k
        ora     ($50,x)                         ; B438 01 50                    .P
        .byte   $02                             ; B43A 02                       .
        cli                                     ; B43B 58                       X
        bvs     LB4AF                           ; B43C 70 71                    pq
        .byte   $14                             ; B43E 14                       .
LB43F:  ora     $71,x                           ; B43F 15 71                    .q
        .byte   $73                             ; B441 73                       s
        .byte   $14                             ; B442 14                       .
        ora     $02,x                           ; B443 15 02                    ..
        bvc     LB449                           ; B445 50 02                    P.
        cli                                     ; B447 58                       X
        .byte   $3A                             ; B448 3A                       :
LB449:  .byte   $3B                             ; B449 3B                       ;
        and     $15                             ; B44A 25 15                    %.
        .byte   $3A                             ; B44C 3A                       :
        .byte   $3B                             ; B44D 3B                       ;
        .byte   $14                             ; B44E 14                       .
        ora     $3C,x                           ; B44F 15 3C                    .<
        and     $1514                           ; B451 2D 14 15                 -..
        .byte   $14                             ; B454 14                       .
        ora     $8A,x                           ; B455 15 8A                    ..
        .byte   $8B                             ; B457 8B                       .
        and     $258B                           ; B458 2D 8B 25                 -.%
LB45B:  .byte   $8B                             ; B45B 8B                       .
        txa                                     ; B45C 8A                       .
        .byte   $8B                             ; B45D 8B                       .
        .byte   $82                             ; B45E 82                       .
        .byte   $83                             ; B45F 83                       .
        txa                                     ; B460 8A                       .
        .byte   $8B                             ; B461 8B                       .
        txa                                     ; B462 8A                       .
        .byte   $8B                             ; B463 8B                       .
        eor     $551F,x                         ; B464 5D 1F 55                 ].U
LB467:  .byte   $17                             ; B467 17                       .
        asl     $161F,x                         ; B468 1E 1F 16                 ...
        .byte   $17                             ; B46B 17                       .
        eor     $6317,x                         ; B46C 5D 17 63                 ].c
LB46F:  .byte   $64                             ; B46F 64                       d
LB470:  asl     $17,x                           ; B470 16 17                    ..
        eor     $01,x                           ; B472 55 01                    U.
        asl     $17,x                           ; B474 16 17                    ..
        bvc     LB4D9                           ; B476 50 61                    Pa
        asl     $17,x                           ; B478 16 17                    ..
        .byte   $62                             ; B47A 62                       b
        .byte   $63                             ; B47B 63                       c
        .byte   $5B                             ; B47C 5B                       [
        .byte   $5C                             ; B47D 5C                       \
        ror     $54                             ; B47E 66 54                    fT
        eor     $5502,x                         ; B480 5D 02 55                 ].U
        .byte   $02                             ; B483 02                       .
        ror     $535C                           ; B484 6E 5C 53                 n\S
        .byte   $54                             ; B487 54                       T
        plp                                     ; B488 28                       (
        and     $1D1C,y                         ; B489 39 1C 1D                 9..
        .byte   $1C                             ; B48C 1C                       .
        .byte   $1D                             ; B48D 1D                       .
        .byte   $90                             ; B48E 90                       .
LB48F:  sta     ($90),y                         ; B48F 91 90                    ..
        sta     ($90),y                         ; B491 91 90                    ..
        sta     (L0080),y                       ; B493 91 80                    ..
        sta     ($88,x)                         ; B495 81 88                    ..
        .byte   $89                             ; B497 89                       .
        txa                                     ; B498 8A                       .
        .byte   $8B                             ; B499 8B                       .
        jsr     L9046                           ; B49A 20 46 90                  F.
        sta     ($56),y                         ; B49D 91 56                    .V
        lsr     $16,x                           ; B49F 56 16                    V.
        .byte   $17                             ; B4A1 17                       .
        .byte   $64                             ; B4A2 64                       d
        eor     $28,x                           ; B4A3 55 28                    U(
        lsr     $3520                           ; B4A5 4E 20 35                 N 5
        lsr     $365E,x                         ; B4A8 5E 5E 36                 ^^6
        rol     $20,x                           ; B4AB 36 20                    6 
        lsr     $28                             ; B4AD 46 28                    F(
LB4AF:  lsr     $2547                           ; B4AF 4E 47 25                 NG%
        .byte   $4F                             ; B4B2 4F                       O
        and     $3B3A                           ; B4B3 2D 3A 3B                 -:;
        .byte   $1C                             ; B4B6 1C                       .
        ora     $2D3C,x                         ; B4B7 1D 3C 2D                 .<-
        .byte   $1C                             ; B4BA 1C                       .
        ora     $2014,x                         ; B4BB 1D 14 20                 .. 
        txa                                     ; B4BE 8A                       .
        plp                                     ; B4BF 28                       (
        txa                                     ; B4C0 8A                       .
        jsr     L288A                           ; B4C1 20 8A 28                  .(
        txa                                     ; B4C4 8A                       .
        .byte   $8B                             ; B4C5 8B                       .
        .byte   $47                             ; B4C6 47                       G
        and     $4F                             ; B4C7 25 4F                    %O
        and     $2537                           ; B4C9 2D 37 25                 -7%
        txa                                     ; B4CC 8A                       .
        .byte   $8B                             ; B4CD 8B                       .
        jsr     L9031                           ; B4CE 20 31 90                  1.
        sta     ($32),y                         ; B4D1 91 32                    .2
        .byte   $33                             ; B4D3 33                       3
        bcc     LB467                           ; B4D4 90 91                    ..
        .byte   $34                             ; B4D6 34                       4
        and     $2A                             ; B4D7 25 2A                    %*
LB4D9:  .byte   $2B                             ; B4D9 2B                       +
        adc     $66                             ; B4DA 65 66                    ef
        adc     $226E                           ; B4DC 6D 6E 22                 mn"
        .byte   $23                             ; B4DF 23                       #
        sei                                     ; B4E0 78                       x
        adc     $1514,y                         ; B4E1 79 14 15                 y..
        adc     $147B,y                         ; B4E4 79 7B 14                 y{.
        ora     $25,x                           ; B4E7 15 25                    .%
        ora     $2D,x                           ; B4E9 15 2D                    .-
        .byte   $8B                             ; B4EB 8B                       .
        and     $8B                             ; B4EC 25 8B                    %.
        and     $828B                           ; B4EE 2D 8B 82                 -..
        .byte   $83                             ; B4F1 83                       .
        txa                                     ; B4F2 8A                       .
        .byte   $8B                             ; B4F3 8B                       .
        txa                                     ; B4F4 8A                       .
        .byte   $8B                             ; B4F5 8B                       .
        txa                                     ; B4F6 8A                       .
        .byte   $57                             ; B4F7 57                       W
        txa                                     ; B4F8 8A                       .
        .byte   $8B                             ; B4F9 8B                       .
        .byte   $57                             ; B4FA 57                       W
        .byte   $57                             ; B4FB 57                       W
        txa                                     ; B4FC 8A                       .
        .byte   $8B                             ; B4FD 8B                       .
        .byte   $5F                             ; B4FE 5F                       _
        .byte   $5F                             ; B4FF 5F                       _
        lsr     $56,x                           ; B500 56 56                    VV
        lsr     $785E,x                         ; B502 5E 5E 78                 ^^x
        .byte   $7B                             ; B505 7B                       {
        .byte   $57                             ; B506 57                       W
        .byte   $57                             ; B507 57                       W
        sei                                     ; B508 78                       x
        .byte   $7B                             ; B509 7B                       {
        .byte   $14                             ; B50A 14                       .
        ora     $8A,x                           ; B50B 15 8A                    ..
        ora     $8A,x                           ; B50D 15 8A                    ..
        .byte   $8B                             ; B50F 8B                       .
        txa                                     ; B510 8A                       .
        .byte   $8B                             ; B511 8B                       .
        .byte   $32                             ; B512 32                       2
        .byte   $33                             ; B513 33                       3
        and     $208B                           ; B514 2D 8B 20                 -. 
        and     ($8A),y                         ; B517 31 8A                    1.
        .byte   $8B                             ; B519 8B                       .
        .byte   $34                             ; B51A 34                       4
        and     $43                             ; B51B 25 43                    %C
        and     $4B                             ; B51D 25 4B                    %K
        and     a:L0000                         ; B51F 2D 00 00                 -..
        sty     $85                             ; B522 84 85                    ..
        brk                                     ; B524 00                       .
        jsr     L2884                           ; B525 20 84 28                  .(
        lsr     $56                             ; B528 46 56                    FV
        lsr     $8C5E                           ; B52A 4E 5E 8C                 N^.
        jsr     L2884                           ; B52D 20 84 28                  .(
        sty     $788D                           ; B530 8C 8D 78                 ..x
        .byte   $7B                             ; B533 7B                       {
        plp                                     ; B534 28                       (
        lsr     a:L0000                         ; B535 4E 00 00                 N..
        and     a:$02                           ; B538 2D 02 00                 -..
        .byte   $02                             ; B53B 02                       .
        sty     $8D                             ; B53C 84 8D                    ..
        sty     $848D                           ; B53E 8C 8D 84                 ...
        .byte   $02                             ; B541 02                       .
        sty     $8402                           ; B542 8C 02 84                 ...
        sta     $20                             ; B545 85 20                    . 
        and     ($78),y                         ; B547 31 78                    1x
        adc     $2534,y                         ; B549 79 34 25                 y4%
        adc     $2279,y                         ; B54C 79 79 22                 yy"
        .byte   $23                             ; B54F 23                       #
        plp                                     ; B550 28                       (
        and     $3332,y                         ; B551 39 32 33                 923
        .byte   $3C                             ; B554 3C                       <
        and     $2534                           ; B555 2D 34 25                 -4%
        sty     $85                             ; B558 84 85                    ..
        .byte   $32                             ; B55A 32                       2
        .byte   $33                             ; B55B 33                       3
        rol     a                               ; B55C 2A                       *
        .byte   $2B                             ; B55D 2B                       +
        .byte   $32                             ; B55E 32                       2
        .byte   $33                             ; B55F 33                       3
        rol     a                               ; B560 2A                       *
        .byte   $2B                             ; B561 2B                       +
        rol     $27                             ; B562 26 27                    &'
        brk                                     ; B564 00                       .
        brk                                     ; B565 00                       .
        brk                                     ; B566 00                       .
        brk                                     ; B567 00                       .
        rol     $222F                           ; B568 2E 2F 22                 ./"
        .byte   $23                             ; B56B 23                       #
        .byte   $02                             ; B56C 02                       .
        ora     $02,x                           ; B56D 15 02                    ..
        .byte   $8B                             ; B56F 8B                       .
        .byte   $02                             ; B570 02                       .
        .byte   $8B                             ; B571 8B                       .
        .byte   $02                             ; B572 02                       .
        .byte   $8B                             ; B573 8B                       .
        .byte   $02                             ; B574 02                       .
        .byte   $8B                             ; B575 8B                       .
        .byte   $57                             ; B576 57                       W
        .byte   $8B                             ; B577 8B                       .
        lsr     $47,x                           ; B578 56 47                    VG
        lsr     $254F,x                         ; B57A 5E 4F 25                 ^O%
        .byte   $8B                             ; B57D 8B                       .
        and     $205F                           ; B57E 2D 5F 20                 -_ 
        .byte   $43                             ; B581 43                       C
        plp                                     ; B582 28                       (
        .byte   $4B                             ; B583 4B                       K
        and     $01                             ; B584 25 01                    %.
        and     $2502                           ; B586 2D 02 25                 -.%
        .byte   $02                             ; B589 02                       .
        and     $7802                           ; B58A 2D 02 78                 -.x
        .byte   $7B                             ; B58D 7B                       {
        sei                                     ; B58E 78                       x
        .byte   $7B                             ; B58F 7B                       {
        .byte   $04                             ; B590 04                       .
        ora     $0C                             ; B591 05 0C                    ..
        ora     $7978                           ; B593 0D 78 79                 .xy
        .byte   $1C                             ; B596 1C                       .
        ora     $7B79,x                         ; B597 1D 79 7B                 .y{
        sei                                     ; B59A 78                       x
        .byte   $7B                             ; B59B 7B                       {
        sei                                     ; B59C 78                       x
        .byte   $7B                             ; B59D 7B                       {
        .byte   $1C                             ; B59E 1C                       .
        asl     a                               ; B59F 0A                       .
        bcc     LB5AC                           ; B5A0 90 0A                    ..
        bcc     LB5AE                           ; B5A2 90 0A                    ..
        ora     ($20,x)                         ; B5A4 01 20                    . 
        .byte   $02                             ; B5A6 02                       .
        plp                                     ; B5A7 28                       (
        .byte   $02                             ; B5A8 02                       .
        sei                                     ; B5A9 78                       x
        .byte   $02                             ; B5AA 02                       .
        .byte   $15                             ; B5AB 15                       .
LB5AC:  .byte   $79                             ; B5AC 79                       y
        .byte   $7B                             ; B5AD 7B                       {
LB5AE:  .byte   $14                             ; B5AE 14                       .
        asl     a                               ; B5AF 0A                       .
        txa                                     ; B5B0 8A                       .
        asl     a                               ; B5B1 0A                       .
        txa                                     ; B5B2 8A                       .
        asl     a                               ; B5B3 0A                       .
        brk                                     ; B5B4 00                       .
        brk                                     ; B5B5 00                       .
        brk                                     ; B5B6 00                       .
        .byte   $C3                             ; B5B7 C3                       .
        brk                                     ; B5B8 00                       .
        brk                                     ; B5B9 00                       .
        cpy     L0000                           ; B5BA C4 00                    ..
        brk                                     ; B5BC 00                       .
        cmp     #$00                            ; B5BD C9 00                    ..
        cmp     ($CA),y                         ; B5BF D1 CA                    ..
        .byte   $CB                             ; B5C1 CB                       .
        .byte   $D2                             ; B5C2 D2                       .
        .byte   $D3                             ; B5C3 D3                       .
        cpy     $D4CD                           ; B5C4 CC CD D4                 ...
        cmp     $CE,x                           ; B5C7 D5 CE                    ..
        brk                                     ; B5C9 00                       .
        dec     L0000,x                         ; B5CA D6 00                    ..
        brk                                     ; B5CC 00                       .
        cmp     L0000,y                         ; B5CD D9 00 00                 ...
        .byte   $DA                             ; B5D0 DA                       .
        .byte   $DB                             ; B5D1 DB                       .
        .byte   $E2                             ; B5D2 E2                       .
        .byte   $E3                             ; B5D3 E3                       .
        .byte   $DC                             ; B5D4 DC                       .
        cmp     $E5E4,x                         ; B5D5 DD E4 E5                 ...
        dec     a:L0000,x                       ; B5D8 DE 00 00                 ...
        brk                                     ; B5DB 00                       .
        brk                                     ; B5DC 00                       .
        sbc     #$00                            ; B5DD E9 00                    ..
        sbc     ($EA),y                         ; B5DF F1 EA                    ..
        .byte   $EB                             ; B5E1 EB                       .
        .byte   $F2                             ; B5E2 F2                       .
        .byte   $F3                             ; B5E3 F3                       .
        cpx     $F4ED                           ; B5E4 EC ED F4                 ...
        sbc     $EE,x                           ; B5E7 F5 EE                    ..
        brk                                     ; B5E9 00                       .
        inc     L0000,x                         ; B5EA F6 00                    ..
        .byte   $FA                             ; B5EC FA                       .
        .byte   $FB                             ; B5ED FB                       .
        brk                                     ; B5EE 00                       .
        brk                                     ; B5EF 00                       .
        .byte   $FC                             ; B5F0 FC                       .
        sbc     a:L0000,x                       ; B5F1 FD 00 00                 ...
        brk                                     ; B5F4 00                       .
        brk                                     ; B5F5 00                       .
        brk                                     ; B5F6 00                       .
        brk                                     ; B5F7 00                       .
        brk                                     ; B5F8 00                       .
        brk                                     ; B5F9 00                       .
        brk                                     ; B5FA 00                       .
        brk                                     ; B5FB 00                       .
        brk                                     ; B5FC 00                       .
        brk                                     ; B5FD 00                       .
        brk                                     ; B5FE 00                       .
LB5FF:  brk                                     ; B5FF 00                       .
        brk                                     ; B600 00                       .
        ora     ($01,x)                         ; B601 01 01                    ..
        ora     ($01,x)                         ; B603 01 01                    ..
        ora     ($01,x)                         ; B605 01 01                    ..
        ora     ($02,x)                         ; B607 01 02                    ..
        .byte   $03                             ; B609 03                       .
        .byte   $03                             ; B60A 03                       .
        .byte   $03                             ; B60B 03                       .
        .byte   $03                             ; B60C 03                       .
        .byte   $03                             ; B60D 03                       .
        .byte   $03                             ; B60E 03                       .
        .byte   $03                             ; B60F 03                       .
        .byte   $02                             ; B610 02                       .
        .byte   $03                             ; B611 03                       .
        .byte   $03                             ; B612 03                       .
        .byte   $03                             ; B613 03                       .
        .byte   $03                             ; B614 03                       .
        .byte   $03                             ; B615 03                       .
        .byte   $03                             ; B616 03                       .
        .byte   $03                             ; B617 03                       .
        .byte   $02                             ; B618 02                       .
        .byte   $03                             ; B619 03                       .
        .byte   $03                             ; B61A 03                       .
        .byte   $03                             ; B61B 03                       .
        .byte   $03                             ; B61C 03                       .
        .byte   $03                             ; B61D 03                       .
        .byte   $03                             ; B61E 03                       .
        .byte   $03                             ; B61F 03                       .
        .byte   $02                             ; B620 02                       .
        .byte   $03                             ; B621 03                       .
        .byte   $03                             ; B622 03                       .
        .byte   $03                             ; B623 03                       .
        .byte   $03                             ; B624 03                       .
        .byte   $03                             ; B625 03                       .
        .byte   $03                             ; B626 03                       .
        .byte   $03                             ; B627 03                       .
        .byte   $02                             ; B628 02                       .
        .byte   $03                             ; B629 03                       .
        .byte   $03                             ; B62A 03                       .
        .byte   $03                             ; B62B 03                       .
        .byte   $03                             ; B62C 03                       .
        .byte   $03                             ; B62D 03                       .
        .byte   $04                             ; B62E 04                       .
        ora     $06                             ; B62F 05 06                    ..
        .byte   $07                             ; B631 07                       .
        .byte   $07                             ; B632 07                       .
        .byte   $07                             ; B633 07                       .
        .byte   $07                             ; B634 07                       .
        php                                     ; B635 08                       .
        asl     $07                             ; B636 06 07                    ..
        ora     #$0A                            ; B638 09 0A                    ..
        asl     a                               ; B63A 0A                       .
        asl     a                               ; B63B 0A                       .
        asl     a                               ; B63C 0A                       .
        .byte   $0B                             ; B63D 0B                       .
        ora     #$0A                            ; B63E 09 0A                    ..
        ora     ($01,x)                         ; B640 01 01                    ..
        ora     ($01,x)                         ; B642 01 01                    ..
        ora     ($01,x)                         ; B644 01 01                    ..
        ora     #$0C                            ; B646 09 0C                    ..
        .byte   $03                             ; B648 03                       .
        .byte   $03                             ; B649 03                       .
        .byte   $03                             ; B64A 03                       .
        .byte   $03                             ; B64B 03                       .
        .byte   $03                             ; B64C 03                       .
        .byte   $03                             ; B64D 03                       .
        ora     #$0A                            ; B64E 09 0A                    ..
        .byte   $03                             ; B650 03                       .
        .byte   $03                             ; B651 03                       .
        .byte   $03                             ; B652 03                       .
        ora     $030E                           ; B653 0D 0E 03                 ...
        ora     #$0F                            ; B656 09 0F                    ..
        .byte   $03                             ; B658 03                       .
        .byte   $03                             ; B659 03                       .
        ora     $100E                           ; B65A 0D 0E 10                 ...
        .byte   $03                             ; B65D 03                       .
        ora     #$0A                            ; B65E 09 0A                    ..
        .byte   $04                             ; B660 04                       .
        ora     $11                             ; B661 05 11                    ..
        .byte   $12                             ; B663 12                       .
        asl     $1303                           ; B664 0E 03 13                 ...
        .byte   $14                             ; B667 14                       .
        ora     $16,x                           ; B668 15 16                    ..
        .byte   $17                             ; B66A 17                       .
        .byte   $12                             ; B66B 12                       .
        bpl     LB671                           ; B66C 10 03                    ..
        clc                                     ; B66E 18                       .
        clc                                     ; B66F 18                       .
        .byte   $07                             ; B670 07                       .
LB671:  .byte   $07                             ; B671 07                       .
        .byte   $07                             ; B672 07                       .
        php                                     ; B673 08                       .
        asl     $07                             ; B674 06 07                    ..
        .byte   $07                             ; B676 07                       .
        .byte   $07                             ; B677 07                       .
        asl     a                               ; B678 0A                       .
        asl     a                               ; B679 0A                       .
        asl     a                               ; B67A 0A                       .
        .byte   $0B                             ; B67B 0B                       .
        ora     #$0A                            ; B67C 09 0A                    ..
        asl     a                               ; B67E 0A                       .
        asl     a                               ; B67F 0A                       .
        .byte   $0B                             ; B680 0B                       .
        ora     #$0F                            ; B681 09 0F                    ..
        asl     a                               ; B683 0A                       .
        asl     a                               ; B684 0A                       .
        .byte   $0F                             ; B685 0F                       .
        asl     a                               ; B686 0A                       .
        .byte   $0F                             ; B687 0F                       .
        .byte   $0B                             ; B688 0B                       .
        ora     #$0A                            ; B689 09 0A                    ..
        .byte   $0F                             ; B68B 0F                       .
        asl     a                               ; B68C 0A                       .
        .byte   $0F                             ; B68D 0F                       .
        asl     a                               ; B68E 0A                       .
        asl     a                               ; B68F 0A                       .
        .byte   $0B                             ; B690 0B                       .
        ora     #$0A                            ; B691 09 0A                    ..
        asl     a                               ; B693 0A                       .
        asl     a                               ; B694 0A                       .
        asl     a                               ; B695 0A                       .
        asl     a                               ; B696 0A                       .
        asl     a                               ; B697 0A                       .
        .byte   $0B                             ; B698 0B                       .
        ora     ($17),y                         ; B699 11 17                    ..
        .byte   $12                             ; B69B 12                       .
        bpl     LB6AF                           ; B69C 10 11                    ..
        .byte   $17                             ; B69E 17                       .
        .byte   $12                             ; B69F 12                       .
        ora     $1818,y                         ; B6A0 19 18 18                 ...
        clc                                     ; B6A3 18                       .
        clc                                     ; B6A4 18                       .
        clc                                     ; B6A5 18                       .
        clc                                     ; B6A6 18                       .
        .byte   $1A                             ; B6A7 1A                       .
        clc                                     ; B6A8 18                       .
        .byte   $03                             ; B6A9 03                       .
        .byte   $03                             ; B6AA 03                       .
        .byte   $03                             ; B6AB 03                       .
        .byte   $03                             ; B6AC 03                       .
        .byte   $03                             ; B6AD 03                       .
        .byte   $03                             ; B6AE 03                       .
LB6AF:  .byte   $1B                             ; B6AF 1B                       .
        .byte   $07                             ; B6B0 07                       .
        php                                     ; B6B1 08                       .
        .byte   $1C                             ; B6B2 1C                       .
        asl     $1D                             ; B6B3 06 1D                    ..
        asl     $1B1F,x                         ; B6B5 1E 1F 1B                 ...
        asl     a                               ; B6B8 0A                       .
        .byte   $0B                             ; B6B9 0B                       .
        asl     $07                             ; B6BA 06 07                    ..
        .byte   $07                             ; B6BC 07                       .
        ora     $1B02,x                         ; B6BD 1D 02 1B                 ...
        jsr     L2221                           ; B6C0 20 21 22                  !"
        jsr     L2320                           ; B6C3 20 20 23                   #
        bit     $25                             ; B6C6 24 25                    $%
        rol     $27                             ; B6C8 26 27                    &'
        plp                                     ; B6CA 28                       (
        and     #$29                            ; B6CB 29 29                    ))
        rol     a                               ; B6CD 2A                       *
        .byte   $2B                             ; B6CE 2B                       +
        and     $20                             ; B6CF 25 20                    % 
        jsr     L2C21                           ; B6D1 20 21 2C                  !,
        and     $2E2E                           ; B6D4 2D 2E 2E                 -..
        .byte   $2F                             ; B6D7 2F                       /
        jsr     L2120                           ; B6D8 20 20 21                   !
        bit     L2022                           ; B6DB 2C 22 20                 ," 
        jsr     L3020                           ; B6DE 20 20 30                   0
        bmi     LB714                           ; B6E1 30 31                    01
        .byte   $32                             ; B6E3 32                       2
        .byte   $33                             ; B6E4 33                       3
        bmi     LB717                           ; B6E5 30 30                    00
        bmi     LB71D                           ; B6E7 30 34                    04
        bmi     LB720                           ; B6E9 30 35                    05
        rol     $37,x                           ; B6EB 36 37                    67
        .byte   $34                             ; B6ED 34                       4
        bmi     LB720                           ; B6EE 30 30                    00
        sec                                     ; B6F0 38                       8
        .byte   $34                             ; B6F1 34                       4
        and     $36,x                           ; B6F2 35 36                    56
        .byte   $37                             ; B6F4 37                       7
        sec                                     ; B6F5 38                       8
        bmi     LB72C                           ; B6F6 30 34                    04
        bmi     LB732                           ; B6F8 30 38                    08
        and     $36,x                           ; B6FA 35 36                    56
        .byte   $37                             ; B6FC 37                       7
        bmi     LB72F                           ; B6FD 30 30                    00
        sec                                     ; B6FF 38                       8
        and     $3A39,y                         ; B700 39 39 3A                 99:
        .byte   $3B                             ; B703 3B                       ;
        .byte   $3C                             ; B704 3C                       <
        and     $0F39,y                         ; B705 39 39 0F                 99.
        and     $3E3D,x                         ; B708 3D 3D 3E                 ==>
        .byte   $3B                             ; B70B 3B                       ;
        .byte   $3F                             ; B70C 3F                       ?
        and     $3D3D,x                         ; B70D 3D 3D 3D                 ===
        and     $403A,y                         ; B710 39 3A 40                 9:@
        .byte   $3B                             ; B713 3B                       ;
LB714:  rti                                     ; B714 40                       @

; ----------------------------------------------------------------------------
        .byte   $3C                             ; B715 3C                       <
        .byte   $39                             ; B716 39                       9
LB717:  .byte   $0F                             ; B717 0F                       .
        eor     ($41,x)                         ; B718 41 41                    AA
        .byte   $42                             ; B71A 42                       B
        .byte   $3B                             ; B71B 3B                       ;
        .byte   $43                             ; B71C 43                       C
LB71D:  eor     ($41,x)                         ; B71D 41 41                    AA
        .byte   $41                             ; B71F 41                       A
LB720:  and     $3A0F,y                         ; B720 39 0F 3A                 9.:
        .byte   $3B                             ; B723 3B                       ;
        .byte   $3F                             ; B724 3F                       ?
        and     $3D3D,x                         ; B725 3D 3D 3D                 ===
        .byte   $0F                             ; B728 0F                       .
        and     $3B3A,y                         ; B729 39 3A 3B                 9:;
LB72C:  .byte   $44                             ; B72C 44                       D
        eor     $46                             ; B72D 45 46                    EF
LB72F:  .byte   $47                             ; B72F 47                       G
        .byte   $0F                             ; B730 0F                       .
        .byte   $39                             ; B731 39                       9
LB732:  .byte   $3A                             ; B732 3A                       :
        .byte   $43                             ; B733 43                       C
        eor     ($41,x)                         ; B734 41 41                    AA
        eor     ($41,x)                         ; B736 41 41                    AA
        and     $3A39,y                         ; B738 39 39 3A                 99:
        .byte   $3C                             ; B73B 3C                       <
        .byte   $0F                             ; B73C 0F                       .
        .byte   $0F                             ; B73D 0F                       .
        .byte   $0F                             ; B73E 0F                       .
        .byte   $0F                             ; B73F 0F                       .
        .byte   $3A                             ; B740 3A                       :
        .byte   $3F                             ; B741 3F                       ?
        and     $3E3D,x                         ; B742 3D 3D 3E                 ==>
        .byte   $3C                             ; B745 3C                       <
        and     $3E0F,y                         ; B746 39 0F 3E                 9.>
        pha                                     ; B749 48                       H
        pha                                     ; B74A 48                       H
        eor     #$48                            ; B74B 49 48                    IH
        .byte   $3F                             ; B74D 3F                       ?
        and     $3A3D,x                         ; B74E 3D 3D 3A                 ==:
        lsr     a                               ; B751 4A                       J
        .byte   $4B                             ; B752 4B                       K
        jmp     L474D                           ; B753 4C 4D 47                 LMG

; ----------------------------------------------------------------------------
        lsr     $4247                           ; B756 4E 47 42                 NGB
        .byte   $4F                             ; B759 4F                       O
        eor     $4F4C                           ; B75A 4D 4C 4F                 MLO
        eor     $4A50                           ; B75D 4D 50 4A                 MPJ
        rol     $5251,x                         ; B760 3E 51 52                 >QR
        .byte   $53                             ; B763 53                       S
        .byte   $52                             ; B764 52                       R
        eor     ($54),y                         ; B765 51 54                    QT
        eor     $46,x                           ; B767 55 46                    UF
        eor     L4C4A                           ; B769 4D 4A 4C                 MJL
        lsr     $4A,x                           ; B76C 56 4A                    VJ
        .byte   $57                             ; B76E 57                       W
        .byte   $47                             ; B76F 47                       G
        eor     ($41,x)                         ; B770 41 41                    AA
        cli                                     ; B772 58                       X
        eor     L4A4F,y                         ; B773 59 4F 4A                 YOJ
        .byte   $5A                             ; B776 5A                       Z
        .byte   $4F                             ; B777 4F                       O
        .byte   $0F                             ; B778 0F                       .
        .byte   $0F                             ; B779 0F                       .
        .byte   $5B                             ; B77A 5B                       [
        eor     $4F4F,y                         ; B77B 59 4F 4F                 YOO
        .byte   $5A                             ; B77E 5A                       Z
        .byte   $4F                             ; B77F 4F                       O
        and     $3A0F,y                         ; B780 39 0F 3A                 9.:
        .byte   $3C                             ; B783 3C                       <
        and     $0F0F,y                         ; B784 39 0F 0F                 9..
        and     $3D3D,y                         ; B787 39 3D 3D                 9==
        rol     $3D3F,x                         ; B78A 3E 3F 3D                 >?=
        and     $3D3D,x                         ; B78D 3D 3D 3D                 ===
        .byte   $5C                             ; B790 5C                       \
        lsr     $4745                           ; B791 4E 45 47                 NEG
        .byte   $3F                             ; B794 3F                       ?
        and     $3D3D,x                         ; B795 3D 3D 3D                 ===
        .byte   $4B                             ; B798 4B                       K
        bvc     LB7E0                           ; B799 50 45                    PE
        eor     $5E5D                           ; B79B 4D 5D 5E                 M]^
        .byte   $5F                             ; B79E 5F                       _
        lsr     $5451,x                         ; B79F 5E 51 54                 ^QT
        rts                                     ; B7A2 60                       `

; ----------------------------------------------------------------------------
        eor     ($49),y                         ; B7A3 51 49                    QI
        .byte   $5C                             ; B7A5 5C                       \
        rts                                     ; B7A6 60                       `

; ----------------------------------------------------------------------------
        eor     #$4A                            ; B7A7 49 4A                    IJ
        .byte   $57                             ; B7A9 57                       W
        eor     $61                             ; B7AA 45 61                    Ea
        .byte   $62                             ; B7AC 62                       b
        adc     ($63,x)                         ; B7AD 61 63                    ac
        .byte   $62                             ; B7AF 62                       b
        .byte   $4F                             ; B7B0 4F                       O
        .byte   $5A                             ; B7B1 5A                       Z
        eor     $4F                             ; B7B2 45 4F                    EO
        jmp     L644A                           ; B7B4 4C 4A 64                 LJd

; ----------------------------------------------------------------------------
        jmp     L5A4F                           ; B7B7 4C 4F 5A                 LOZ

; ----------------------------------------------------------------------------
        eor     $4F                             ; B7BA 45 4F                    EO
        jmp     L454F                           ; B7BC 4C 4F 45                 LOE

; ----------------------------------------------------------------------------
        jmp     L390F                           ; B7BF 4C 0F 39                 L.9

; ----------------------------------------------------------------------------
        and     L390F,y                         ; B7C2 39 0F 39                 9.9
        and     $3939,y                         ; B7C5 39 39 39                 999
        and     $3D3D,x                         ; B7C8 3D 3D 3D                 ===
        and     $3D3D,x                         ; B7CB 3D 3D 3D                 ===
        and     $3E3D,x                         ; B7CE 3D 3D 3E                 ==>
        lsr     $3F5F,x                         ; B7D1 5E 5F 3F                 ^_?
        and     $3E3D,x                         ; B7D4 3D 3D 3E                 ==>
        lsr     $4665,x                         ; B7D7 5E 65 46                 ^eF
        .byte   $47                             ; B7DA 47                       G
        .byte   $5C                             ; B7DB 5C                       \
        lsr     $47                             ; B7DC 46 47                    FG
        .byte   $47                             ; B7DE 47                       G
        .byte   $46                             ; B7DF 46                       F
LB7E0:  eor     ($53),y                         ; B7E0 51 53                    QS
        eor     ($66),y                         ; B7E2 51 66                    Qf
        .byte   $53                             ; B7E4 53                       S
        .byte   $52                             ; B7E5 52                       R
        .byte   $52                             ; B7E6 52                       R
        .byte   $53                             ; B7E7 53                       S
        adc     ($67,x)                         ; B7E8 61 67                    ag
        pla                                     ; B7EA 68                       h
        .byte   $4F                             ; B7EB 4F                       O
        jmp     L4A4F                           ; B7EC 4C 4F 4A                 LOJ

; ----------------------------------------------------------------------------
        adc     #$4F                            ; B7EF 69 4F                    iO
        jmp     L4A6A                           ; B7F1 4C 6A 4A                 LjJ

; ----------------------------------------------------------------------------
        adc     #$4A                            ; B7F4 69 4A                    iJ
        .byte   $6B                             ; B7F6 6B                       k
        jmp     L4C4F                           ; B7F7 4C 4F 4C                 LOL

; ----------------------------------------------------------------------------
        jmp     (L4C4D)                         ; B7FA 6C 4D 4C                 lML

; ----------------------------------------------------------------------------
        eor     L4C4F                           ; B7FD 4D 4F 4C                 MOL
        .byte   $0F                             ; B800 0F                       .
        and     $3C3A,y                         ; B801 39 3A 3C                 9:<
        .byte   $3A                             ; B804 3A                       :
        bmi     LB837                           ; B805 30 30                    00
        bmi     LB846                           ; B807 30 3D                    0=
        and     $3F3E,x                         ; B809 3D 3E 3F                 =>?
        rol     $6D6D,x                         ; B80C 3E 6D 6D                 >mm
        adc     $6F6E                           ; B80F 6D 6E 6F                 mno
        lsr     $6763,x                         ; B812 5E 63 67                 ^cg
        lsr     a                               ; B815 4A                       J
        .byte   $4B                             ; B816 4B                       K
        .byte   $4F                             ; B817 4F                       O
        .byte   $47                             ; B818 47                       G
        .byte   $47                             ; B819 47                       G
        .byte   $5C                             ; B81A 5C                       \
        eor     $4C                             ; B81B 45 4C                    EL
        lsr     a                               ; B81D 4A                       J
        bvs     LB891                           ; B81E 70 71                    pq
        .byte   $52                             ; B820 52                       R
        eor     ($66),y                         ; B821 51 66                    Qf
        rts                                     ; B823 60                       `

; ----------------------------------------------------------------------------
        .byte   $53                             ; B824 53                       S
        .byte   $72                             ; B825 72                       r
        .byte   $72                             ; B826 72                       r
        .byte   $72                             ; B827 72                       r
        pla                                     ; B828 68                       h
        eor     $7473                           ; B829 4D 73 74                 Mst
        jmp     L4747                           ; B82C 4C 47 47                 LGG

; ----------------------------------------------------------------------------
        adc     ($6A,x)                         ; B82F 61 6A                    aj
        adc     $4D,x                           ; B831 75 4D                    uM
        eor     $4C                             ; B833 45 4C                    EL
        .byte   $4D                             ; B835 4D                       M
        .byte   $4D                             ; B836 4D                       M
LB837:  eor     $4F6C                           ; B837 4D 6C 4F                 MlO
        .byte   $4F                             ; B83A 4F                       O
        eor     $4C                             ; B83B 45 4C                    EL
        .byte   $4F                             ; B83D 4F                       O
        eor     $304F                           ; B83E 4D 4F 30                 MO0
        bmi     LB873                           ; B841 30 30                    00
        bmi     LB87A                           ; B843 30 35                    05
        .byte   $37                             ; B845 37                       7
LB846:  bmi     LB87C                           ; B846 30 34                    04
        ror     $6D,x                           ; B848 76 6D                    vm
        ror     $6D,x                           ; B84A 76 6D                    vm
        .byte   $77                             ; B84C 77                       w
        .byte   $37                             ; B84D 37                       7
        bmi     LB888                           ; B84E 30 38                    08
        jmp     L4C4D                           ; B850 4C 4D 4C                 LML

; ----------------------------------------------------------------------------
        eor     $7845                           ; B853 4D 45 78                 MEx
        ror     $79,x                           ; B856 76 79                    vy
        .byte   $7A                             ; B858 7A                       z
        adc     ($7B),y                         ; B859 71 7B                    q{
        .byte   $4F                             ; B85B 4F                       O
        eor     $4C                             ; B85C 45 4C                    EL
        eor     $7C                             ; B85E 45 7C                    E|
        .byte   $53                             ; B860 53                       S
        eor     ($53),y                         ; B861 51 53                    QS
        eor     ($60),y                         ; B863 51 60                    Q`
        .byte   $53                             ; B865 53                       S
        rts                                     ; B866 60                       `

; ----------------------------------------------------------------------------
        .byte   $7C                             ; B867 7C                       |
        adc     $6261,x                         ; B868 7D 61 62                 }ab
        adc     ($67,x)                         ; B86B 61 67                    ag
        jmp     L7C45                           ; B86D 4C 45 7C                 LE|

; ----------------------------------------------------------------------------
        jmp     L4C4A                           ; B870 4C 4A 4C                 LJL

; ----------------------------------------------------------------------------
LB873:  lsr     a                               ; B873 4A                       J
        .byte   $64                             ; B874 64                       d
        jmp     L4243                           ; B875 4C 43 42                 LCB

; ----------------------------------------------------------------------------
        .byte   $4C                             ; B878 4C                       L
        .byte   $4D                             ; B879 4D                       M
LB87A:  .byte   $4C                             ; B87A 4C                       L
        .byte   $4F                             ; B87B 4F                       O
LB87C:  eor     $4C                             ; B87C 45 4C                    EL
        .byte   $3C                             ; B87E 3C                       <
        .byte   $3A                             ; B87F 3A                       :
        bmi     LB8B6                           ; B880 30 34                    04
        bmi     LB8B9                           ; B882 30 35                    05
        .byte   $3F                             ; B884 3F                       ?
        and     $3E3D,x                         ; B885 3D 3D 3E                 ==>
LB888:  bmi     LB8C2                           ; B888 30 38                    08
        bmi     LB8C1                           ; B88A 30 35                    05
        rti                                     ; B88C 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B88D 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B88E 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B88F 40                       @

; ----------------------------------------------------------------------------
        .byte   $76                             ; B890 76                       v
LB891:  ror     $76,x                           ; B891 76 76                    vv
        .byte   $77                             ; B893 77                       w
        .byte   $3B                             ; B894 3B                       ;
        .byte   $3B                             ; B895 3B                       ;
        .byte   $3B                             ; B896 3B                       ;
        .byte   $3B                             ; B897 3B                       ;
        .byte   $3B                             ; B898 3B                       ;
        .byte   $3B                             ; B899 3B                       ;
        .byte   $3B                             ; B89A 3B                       ;
        .byte   $3B                             ; B89B 3B                       ;
        .byte   $3B                             ; B89C 3B                       ;
        .byte   $3B                             ; B89D 3B                       ;
        .byte   $3B                             ; B89E 3B                       ;
        .byte   $3B                             ; B89F 3B                       ;
        .byte   $3B                             ; B8A0 3B                       ;
        .byte   $3B                             ; B8A1 3B                       ;
        .byte   $3B                             ; B8A2 3B                       ;
        .byte   $3B                             ; B8A3 3B                       ;
        .byte   $3B                             ; B8A4 3B                       ;
        .byte   $3B                             ; B8A5 3B                       ;
        .byte   $3B                             ; B8A6 3B                       ;
        .byte   $3B                             ; B8A7 3B                       ;
        .byte   $3B                             ; B8A8 3B                       ;
        .byte   $3B                             ; B8A9 3B                       ;
        .byte   $3B                             ; B8AA 3B                       ;
        .byte   $3B                             ; B8AB 3B                       ;
        .byte   $3B                             ; B8AC 3B                       ;
        .byte   $3B                             ; B8AD 3B                       ;
        .byte   $3B                             ; B8AE 3B                       ;
        .byte   $3B                             ; B8AF 3B                       ;
        .byte   $3B                             ; B8B0 3B                       ;
        .byte   $3B                             ; B8B1 3B                       ;
        .byte   $43                             ; B8B2 43                       C
        .byte   $42                             ; B8B3 42                       B
        .byte   $43                             ; B8B4 43                       C
        .byte   $41                             ; B8B5 41                       A
LB8B6:  eor     ($41,x)                         ; B8B6 41 41                    AA
        .byte   $3B                             ; B8B8 3B                       ;
LB8B9:  .byte   $3B                             ; B8B9 3B                       ;
        .byte   $3C                             ; B8BA 3C                       <
        .byte   $3A                             ; B8BB 3A                       :
        .byte   $3C                             ; B8BC 3C                       <
        and     $3939,y                         ; B8BD 39 39 39                 999
        .byte   $7E                             ; B8C0 7E                       ~
LB8C1:  .byte   $7F                             ; B8C1 7F                       .
LB8C2:  .byte   $37                             ; B8C2 37                       7
        bmi     LB8F5                           ; B8C3 30 30                    00
        bmi     LB8FC                           ; B8C5 30 35                    05
        .byte   $80                             ; B8C7 80                       .
        rti                                     ; B8C8 40                       @

; ----------------------------------------------------------------------------
        rti                                     ; B8C9 40                       @

; ----------------------------------------------------------------------------
        sei                                     ; B8CA 78                       x
        ror     $76,x                           ; B8CB 76 76                    vv
        sta     ($82,x)                         ; B8CD 81 82                    ..
        .byte   $80                             ; B8CF 80                       .
        .byte   $3B                             ; B8D0 3B                       ;
        .byte   $3B                             ; B8D1 3B                       ;
        .byte   $3B                             ; B8D2 3B                       ;
        .byte   $3B                             ; B8D3 3B                       ;
        .byte   $3B                             ; B8D4 3B                       ;
        .byte   $83                             ; B8D5 83                       .
        .byte   $62                             ; B8D6 62                       b
        .byte   $80                             ; B8D7 80                       .
        .byte   $3B                             ; B8D8 3B                       ;
        .byte   $3B                             ; B8D9 3B                       ;
        .byte   $3B                             ; B8DA 3B                       ;
        .byte   $3B                             ; B8DB 3B                       ;
        .byte   $3B                             ; B8DC 3B                       ;
        .byte   $3B                             ; B8DD 3B                       ;
        .byte   $3B                             ; B8DE 3B                       ;
LB8DF:  .byte   $80                             ; B8DF 80                       .
        .byte   $3B                             ; B8E0 3B                       ;
        .byte   $3B                             ; B8E1 3B                       ;
LB8E2:  .byte   $3B                             ; B8E2 3B                       ;
        .byte   $3B                             ; B8E3 3B                       ;
        .byte   $3B                             ; B8E4 3B                       ;
        sty     $85                             ; B8E5 84 85                    ..
        stx     $3B                             ; B8E7 86 3B                    .;
        .byte   $3B                             ; B8E9 3B                       ;
        .byte   $43                             ; B8EA 43                       C
        eor     ($41,x)                         ; B8EB 41 41                    AA
        eor     ($41,x)                         ; B8ED 41 41                    AA
        eor     ($41,x)                         ; B8EF 41 41                    AA
        .byte   $42                             ; B8F1 42                       B
        .byte   $3C                             ; B8F2 3C                       <
        .byte   $0F                             ; B8F3 0F                       .
        .byte   $39                             ; B8F4 39                       9
LB8F5:  and     L390F,y                         ; B8F5 39 0F 39                 9.9
        and     $3C3A,y                         ; B8F8 39 3A 3C                 9:<
        .byte   $39                             ; B8FB 39                       9
LB8FC:  and     $3939,y                         ; B8FC 39 39 39                 999
        .byte   $39                             ; B8FF 39                       9
LB900:  .byte   $87                             ; B900 87                       .
        dey                                     ; B901 88                       .
        .byte   $3F                             ; B902 3F                       ?
        and     $3D3D,x                         ; B903 3D 3D 3D                 ===
        and     $873D,x                         ; B906 3D 3D 87                 ==.
        dey                                     ; B909 88                       .
        .byte   $7A                             ; B90A 7A                       z
        .byte   $62                             ; B90B 62                       b
        .byte   $7A                             ; B90C 7A                       z
        .byte   $62                             ; B90D 62                       b
        .byte   $7A                             ; B90E 7A                       z
        .byte   $89                             ; B90F 89                       .
        txa                                     ; B910 8A                       .
        dey                                     ; B911 88                       .
        rol     $36,x                           ; B912 36 36                    66
        rol     $36,x                           ; B914 36 36                    66
        rol     $8B,x                           ; B916 36 8B                    6.
        txa                                     ; B918 8A                       .
        dey                                     ; B919 88                       .
        rol     $36,x                           ; B91A 36 36                    66
        rol     $36,x                           ; B91C 36 36                    66
        rol     $8B,x                           ; B91E 36 8B                    6.
        sty     $3688                           ; B920 8C 88 36                 ..6
        rol     $36,x                           ; B923 36 36                    66
        rol     $36,x                           ; B925 36 36                    66
        .byte   $8B                             ; B927 8B                       .
        sta     $7F8D                           ; B928 8D 8D 7F                 ...
        rol     $36,x                           ; B92B 36 36                    66
        rol     $36,x                           ; B92D 36 36                    66
        .byte   $8B                             ; B92F 8B                       .
        and     $4339,y                         ; B930 39 39 43                 99C
        eor     ($41,x)                         ; B933 41 41                    AA
        eor     ($42,x)                         ; B935 41 42                    AB
        stx     $908F                           ; B937 8E 8F 90                 ...
        .byte   $3C                             ; B93A 3C                       <
        .byte   $0F                             ; B93B 0F                       .
        and     $3A0F,y                         ; B93C 39 0F 3A                 9.:
        sta     ($20),y                         ; B93F 91 20                    . 
        jsr     L2120                           ; B941 20 20 21                   !
        .byte   $13                             ; B944 13                       .
        .byte   $14                             ; B945 14                       .
        .byte   $14                             ; B946 14                       .
        .byte   $14                             ; B947 14                       .
        .byte   $92                             ; B948 92                       .
        .byte   $93                             ; B949 93                       .
        .byte   $93                             ; B94A 93                       .
        sty     $95,x                           ; B94B 94 95                    ..
        sta     $95,x                           ; B94D 95 95                    ..
        sta     $96,x                           ; B94F 95 96                    ..
        .byte   $97                             ; B951 97                       .
        .byte   $97                             ; B952 97                       .
        .byte   $97                             ; B953 97                       .
        tya                                     ; B954 98                       .
        .byte   $97                             ; B955 97                       .
        tya                                     ; B956 98                       .
        tya                                     ; B957 98                       .
        stx     $98,y                           ; B958 96 98                    ..
        tya                                     ; B95A 98                       .
        tya                                     ; B95B 98                       .
        .byte   $97                             ; B95C 97                       .
        tya                                     ; B95D 98                       .
        tya                                     ; B95E 98                       .
        .byte   $97                             ; B95F 97                       .
        sta     $9A9A,y                         ; B960 99 9A 9A                 ...
        txs                                     ; B963 9A                       .
        txs                                     ; B964 9A                       .
        txs                                     ; B965 9A                       .
        txs                                     ; B966 9A                       .
        txs                                     ; B967 9A                       .
        .byte   $9B                             ; B968 9B                       .
        .byte   $9C                             ; B969 9C                       .
        sta     $9E9E,x                         ; B96A 9D 9E 9E                 ...
        .byte   $9E                             ; B96D 9E                       .
        .byte   $9E                             ; B96E 9E                       .
        .byte   $9E                             ; B96F 9E                       .
        .byte   $9F                             ; B970 9F                       .
        ldy     #$37                            ; B971 A0 37                    .7
        bmi     LB9A9                           ; B973 30 34                    04
        bmi     LB9A7                           ; B975 30 30                    00
        .byte   $34                             ; B977 34                       4
        lda     ($A0,x)                         ; B978 A1 A0                    ..
        .byte   $37                             ; B97A 37                       7
        bmi     LB9B5                           ; B97B 30 38                    08
        bmi     LB9AF                           ; B97D 30 30                    00
        sec                                     ; B97F 38                       8
        .byte   $14                             ; B980 14                       .
        .byte   $14                             ; B981 14                       .
        ora     $0A09,y                         ; B982 19 09 0A                 ...
        asl     a                               ; B985 0A                       .
        .byte   $0B                             ; B986 0B                       .
        .byte   $22                             ; B987 22                       "
        sta     $95,x                           ; B988 95 95                    ..
        sta     $13,x                           ; B98A 95 13                    ..
        .byte   $14                             ; B98C 14                       .
        .byte   $14                             ; B98D 14                       .
        ora     $98A2,y                         ; B98E 19 A2 98                 ...
        tya                                     ; B991 98                       .
LB992:  .byte   $97                             ; B992 97                       .
        sta     $A3,x                           ; B993 95 A3                    ..
        sta     $95,x                           ; B995 95 95                    ..
        ldy     $98                             ; B997 A4 98                    ..
        tya                                     ; B999 98                       .
        tya                                     ; B99A 98                       .
LB99B:  tya                                     ; B99B 98                       .
        lda     $98                             ; B99C A5 98                    ..
        tya                                     ; B99E 98                       .
        lda     $9A                             ; B99F A5 9A                    ..
        txs                                     ; B9A1 9A                       .
        .byte   $06                             ; B9A2 06                       .
LB9A3:  .byte   $07                             ; B9A3 07                       .
        .byte   $07                             ; B9A4 07                       .
        php                                     ; B9A5 08                       .
        .byte   $A6                             ; B9A6 A6                       .
LB9A7:  .byte   $A7                             ; B9A7 A7                       .
        .byte   $9E                             ; B9A8 9E                       .
LB9A9:  tay                                     ; B9A9 A8                       .
        ora     #$0A                            ; B9AA 09 0A                    ..
        asl     a                               ; B9AC 0A                       .
        .byte   $0B                             ; B9AD 0B                       .
        .byte   $A9                             ; B9AE A9                       .
LB9AF:  tax                                     ; B9AF AA                       .
        bmi     LB9E7                           ; B9B0 30 35                    05
        ora     #$0A                            ; B9B2 09 0A                    ..
        asl     a                               ; B9B4 0A                       .
LB9B5:  .byte   $0B                             ; B9B5 0B                       .
        lda     #$AA                            ; B9B6 A9 AA                    ..
LB9B8:  .byte   $30                             ; B9B8 30                       0
LB9B9:  and     $09,x                           ; B9B9 35 09                    5.
        asl     a                               ; B9BB 0A                       .
        asl     a                               ; B9BC 0A                       .
        .byte   $0B                             ; B9BD 0B                       .
        lda     #$AA                            ; B9BE A9 AA                    ..
        jsr     L2020                           ; B9C0 20 20 20                    
LB9C3:  and     ($AB,x)                         ; B9C3 21 AB                    !.
        ldy     $0F09                           ; B9C5 AC 09 0F                 ...
        .byte   $93                             ; B9C8 93                       .
        .byte   $93                             ; B9C9 93                       .
        .byte   $AD                             ; B9CA AD                       .
LB9CB:  ldx     LACAB                           ; B9CB AE AB AC                 ...
        .byte   $13                             ; B9CE 13                       .
        .byte   $14                             ; B9CF 14                       .
        tya                                     ; B9D0 98                       .
        tya                                     ; B9D1 98                       .
        ldy     $A5                             ; B9D2 A4 A5                    ..
LB9D4:  .byte   $A3                             ; B9D4 A3                       .
        sta     $95,x                           ; B9D5 95 95                    ..
        .byte   $AF                             ; B9D7 AF                       .
        tya                                     ; B9D8 98                       .
        tya                                     ; B9D9 98                       .
        lda     $A4                             ; B9DA A5 A4                    ..
        lda     $98                             ; B9DC A5 98                    ..
        tya                                     ; B9DE 98                       .
        bcs     LB992                           ; B9DF B0 B1                    ..
        tya                                     ; B9E1 98                       .
        lda     $A5                             ; B9E2 A5 A5                    ..
        ldy     $98                             ; B9E4 A4 98                    ..
        tya                                     ; B9E6 98                       .
LB9E7:  bcs     LB99B                           ; B9E7 B0 B2                    ..
        .byte   $B3                             ; B9E9 B3                       .
        ldy     $B5,x                           ; B9EA B4 B5                    ..
        ldy     $98                             ; B9EC A4 98                    ..
        tya                                     ; B9EE 98                       .
        bcs     LB9A3                           ; B9EF B0 B2                    ..
        .byte   $22                             ; B9F1 22                       "
        ldx     $21,y                           ; B9F2 B6 21                    .!
        .byte   $AB                             ; B9F4 AB                       .
        ldy     LB098                           ; B9F5 AC 98 B0                 ...
        .byte   $B2                             ; B9F8 B2                       .
        .byte   $22                             ; B9F9 22                       "
        .byte   $B7                             ; B9FA B7                       .
        and     ($B8,x)                         ; B9FB 21 B8                    !.
        lda     LB098,y                         ; B9FD B9 98 B0                 ...
LBA00:  ldy     $1413                           ; BA00 AC 13 14                 ...
        ora     LACAB,y                         ; BA03 19 AB AC                 ...
        tya                                     ; BA06 98                       .
        bcs     LB9B5                           ; BA07 B0 AC                    ..
        bpl     LB9C3                           ; BA09 10 B8                    ..
        lda     $9595,y                         ; BA0B B9 95 95                 ...
        tya                                     ; BA0E 98                       .
        bcs     LB9CB                           ; BA0F B0 BA                    ..
        sta     $98,x                           ; BA11 95 98                    ..
        tya                                     ; BA13 98                       .
        tya                                     ; BA14 98                       .
        tya                                     ; BA15 98                       .
        tya                                     ; BA16 98                       .
        bcs     LB9D4                           ; BA17 B0 BB                    ..
        ldy     LBEBD,x                         ; BA19 BC BD BE                 ...
        asl     LABBF                           ; BA1C 0E BF AB                 ...
        cpy     #$BB                            ; BA1F C0 BB                    ..
        lda     $C1C1,x                         ; BA21 BD C1 C1                 ...
        clv                                     ; BA24 B8                       .
        lda     LB8C2,y                         ; BA25 B9 C2 B8                 ...
        .byte   $BB                             ; BA28 BB                       .
        .byte   $C3                             ; BA29 C3                       .
        sta     $95,x                           ; BA2A 95 95                    ..
        ldy     LB398,x                         ; BA2C BC 98 B3                 ...
        cpy     $C5                             ; BA2F C4 C5                    ..
        cpy     $C4                             ; BA31 C4 C4                    ..
        cpy     $C4                             ; BA33 C4 C4                    ..
        dec     L0022                           ; BA35 C6 22                    ."
        jsr     L2022                           ; BA37 20 22 20                  " 
        jsr     L2020                           ; BA3A 20 20 20                    
        and     (L0022,x)                       ; BA3D 21 22                    !"
        .byte   $20                             ; BA3F 20                        
LBA40:  asl     $12,x                           ; BA40 16 12                    ..
        ora     ($17),y                         ; BA42 11 17                    ..
        .byte   $12                             ; BA44 12                       .
        .byte   $AB                             ; BA45 AB                       .
        cpy     #$AC                            ; BA46 C0 AC                    ..
        asl     $12,x                           ; BA48 16 12                    ..
        sta     $95,x                           ; BA4A 95 95                    ..
        sta     $95,x                           ; BA4C 95 95                    ..
        sta     $95,x                           ; BA4E 95 95                    ..
        .byte   $C7                             ; BA50 C7                       .
        .byte   $C2                             ; BA51 C2                       .
        ldy     $98BC,x                         ; BA52 BC BC 98                 ...
        tya                                     ; BA55 98                       .
        tya                                     ; BA56 98                       .
        tya                                     ; BA57 98                       .
        ldy     LBCBC                           ; BA58 AC BC BC                 ...
        ldy     $9898,x                         ; BA5B BC 98 98                 ...
        tya                                     ; BA5E 98                       .
        tya                                     ; BA5F 98                       .
        lda     LBCBC,y                         ; BA60 B9 BC BC                 ...
        ldy     $9898,x                         ; BA63 BC 98 98                 ...
        tya                                     ; BA66 98                       .
        tya                                     ; BA67 98                       .
        cpy     $C6                             ; BA68 C4 C6                    ..
        ldy     $98BC,x                         ; BA6A BC BC 98                 ...
        tya                                     ; BA6D 98                       .
        tya                                     ; BA6E 98                       .
        tya                                     ; BA6F 98                       .
        jsr     LBF21                           ; BA70 20 21 BF                  !.
        .byte   $AB                             ; BA73 AB                       .
        cpy     #$AC                            ; BA74 C0 AC                    ..
        ora     ($17),y                         ; BA76 11 17                    ..
        jsr     L1121                           ; BA78 20 21 11                  !.
        .byte   $12                             ; BA7B 12                       .
        ora     ($12),y                         ; BA7C 11 12                    ..
        .byte   $C2                             ; BA7E C2                       .
        clv                                     ; BA7F B8                       .
        ora     ($17),y                         ; BA80 11 17                    ..
        .byte   $12                             ; BA82 12                       .
        ora     #$0C                            ; BA83 09 0C                    ..
        .byte   $0B                             ; BA85 0B                       .
        ora     ($17),y                         ; BA86 11 17                    ..
        .byte   $A3                             ; BA88 A3                       .
        sta     $A3,x                           ; BA89 95 A3                    ..
        .byte   $13                             ; BA8B 13                       .
        .byte   $14                             ; BA8C 14                       .
        ora     $1711,y                         ; BA8D 19 11 17                 ...
        lda     $98                             ; BA90 A5 98                    ..
        ldy     $A3                             ; BA92 A4 A3                    ..
        iny                                     ; BA94 C8                       .
        iny                                     ; BA95 C8                       .
        cmp     #$CA                            ; BA96 C9 CA                    ..
        lda     $98                             ; BA98 A5 98                    ..
        lda     $A4                             ; BA9A A5 A4                    ..
        bit     $CB2C                           ; BA9C 2C 2C CB                 ,,.
        dex                                     ; BA9F CA                       .
        ldy     $98                             ; BAA0 A4 98                    ..
        lda     $A5                             ; BAA2 A5 A5                    ..
        bit     $2C2C                           ; BAA4 2C 2C 2C                 ,,,
        ora     ($A4),y                         ; BAA7 11 A4                    ..
        tya                                     ; BAA9 98                       .
        ldy     $A5                             ; BAAA A4 A5                    ..
        bit     $2C2C                           ; BAAC 2C 2C 2C                 ,,,
        ora     ($12),y                         ; BAAF 11 12                    ..
        ora     ($17),y                         ; BAB1 11 17                    ..
        .byte   $12                             ; BAB3 12                       .
        cpy     $CC2C                           ; BAB4 CC 2C CC                 .,.
        ora     ($B9),y                         ; BAB7 11 B9                    ..
        clv                                     ; BAB9 B8                       .
        lda     LB9B8,y                         ; BABA B9 B8 B9                 ...
        bit     LB9B8                           ; BABD 2C B8 B9                 ,..
        .byte   $07                             ; BAC0 07                       .
        .byte   $07                             ; BAC1 07                       .
        .byte   $07                             ; BAC2 07                       .
        .byte   $07                             ; BAC3 07                       .
        php                                     ; BAC4 08                       .
        .byte   $03                             ; BAC5 03                       .
        ora     ($17),y                         ; BAC6 11 17                    ..
        .byte   $0C                             ; BAC8 0C                       .
        asl     a                               ; BAC9 0A                       .
        asl     a                               ; BACA 0A                       .
        .byte   $0C                             ; BACB 0C                       .
        .byte   $0B                             ; BACC 0B                       .
        .byte   $03                             ; BACD 03                       .
        clc                                     ; BACE 18                       .
        clc                                     ; BACF 18                       .
        .byte   $14                             ; BAD0 14                       .
        .byte   $14                             ; BAD1 14                       .
        .byte   $14                             ; BAD2 14                       .
        .byte   $14                             ; BAD3 14                       .
        ora     $0303,y                         ; BAD4 19 03 03                 ...
        .byte   $03                             ; BAD7 03                       .
        .byte   $07                             ; BAD8 07                       .
        .byte   $07                             ; BAD9 07                       .
        .byte   $07                             ; BADA 07                       .
        php                                     ; BADB 08                       .
        clc                                     ; BADC 18                       .
        .byte   $03                             ; BADD 03                       .
        .byte   $03                             ; BADE 03                       .
        .byte   $03                             ; BADF 03                       .
        .byte   $0C                             ; BAE0 0C                       .
        asl     a                               ; BAE1 0A                       .
        .byte   $0C                             ; BAE2 0C                       .
        .byte   $0B                             ; BAE3 0B                       .
        .byte   $03                             ; BAE4 03                       .
        .byte   $03                             ; BAE5 03                       .
        .byte   $03                             ; BAE6 03                       .
        .byte   $03                             ; BAE7 03                       .
        asl     a                               ; BAE8 0A                       .
        .byte   $0C                             ; BAE9 0C                       .
        asl     a                               ; BAEA 0A                       .
        .byte   $0B                             ; BAEB 0B                       .
        .byte   $03                             ; BAEC 03                       .
        .byte   $03                             ; BAED 03                       .
        .byte   $03                             ; BAEE 03                       .
        .byte   $03                             ; BAEF 03                       .
        asl     a                               ; BAF0 0A                       .
        .byte   $0C                             ; BAF1 0C                       .
        asl     a                               ; BAF2 0A                       .
        .byte   $0B                             ; BAF3 0B                       .
        asl     $07                             ; BAF4 06 07                    ..
        .byte   $07                             ; BAF6 07                       .
        php                                     ; BAF7 08                       .
        asl     a                               ; BAF8 0A                       .
        asl     a                               ; BAF9 0A                       .
        asl     a                               ; BAFA 0A                       .
        .byte   $0B                             ; BAFB 0B                       .
        ora     #$0C                            ; BAFC 09 0C                    ..
        .byte   $0C                             ; BAFE 0C                       .
        .byte   $0B                             ; BAFF 0B                       .
        .byte   $17                             ; BB00 17                       .
        .byte   $17                             ; BB01 17                       .
        .byte   $17                             ; BB02 17                       .
        .byte   $12                             ; BB03 12                       .
        cmp     $CE01                           ; BB04 CD 01 CE                 ...
        ora     #$18                            ; BB07 09 18                    ..
        clc                                     ; BB09 18                       .
        clc                                     ; BB0A 18                       .
        clc                                     ; BB0B 18                       .
        .byte   $CF                             ; BB0C CF                       .
        .byte   $03                             ; BB0D 03                       .
        bne     LBB19                           ; BB0E D0 09                    ..
        .byte   $03                             ; BB10 03                       .
        .byte   $03                             ; BB11 03                       .
        .byte   $03                             ; BB12 03                       .
        .byte   $03                             ; BB13 03                       .
        .byte   $03                             ; BB14 03                       .
        cmp     ($D2),y                         ; BB15 D1 D2                    ..
        .byte   $D3                             ; BB17 D3                       .
        .byte   $03                             ; BB18 03                       .
LBB19:  .byte   $03                             ; BB19 03                       .
        .byte   $03                             ; BB1A 03                       .
        .byte   $03                             ; BB1B 03                       .
        cmp     ($D4),y                         ; BB1C D1 D4                    ..
        cmp     $20,x                           ; BB1E D5 20                    . 
        .byte   $03                             ; BB20 03                       .
        .byte   $03                             ; BB21 03                       .
        .byte   $03                             ; BB22 03                       .
        cmp     ($D4),y                         ; BB23 D1 D4                    ..
        rol     $D5                             ; BB25 26 D5                    &.
        jsr     LD103                           ; BB27 20 03 D1                  ..
        dec     $D4,x                           ; BB2A D6 D4                    ..
        rol     $26                             ; BB2C 26 26                    &&
        .byte   $27                             ; BB2E 27                       '
        .byte   $D7                             ; BB2F D7                       .
        .byte   $03                             ; BB30 03                       .
        .byte   $22                             ; BB31 22                       "
        jsr     L20D8                           ; BB32 20 D8 20                  . 
        jsr     L20D8                           ; BB35 20 D8 20                  . 
        cmp     L2022,y                         ; BB38 D9 22 20                 ." 
        .byte   $DA                             ; BB3B DA                       .
        jsr     LDA20                           ; BB3C 20 20 DA                   .
        jsr     LDB98                           ; BB3F 20 98 DB                  ..
        sta     $95,x                           ; BB42 95 95                    ..
        sta     $A3,x                           ; BB44 95 A3                    ..
        .byte   $A3                             ; BB46 A3                       .
        ora     #$98                            ; BB47 09 98                    ..
        .byte   $DC                             ; BB49 DC                       .
        ldy     $9898,x                         ; BB4A BC 98 98                 ...
        lda     $A5                             ; BB4D A5 A5                    ..
        ora     #$BE                            ; BB4F 09 BE                    ..
        cmp     $9898,x                         ; BB51 DD 98 98                 ...
        tya                                     ; BB54 98                       .
        lda     $A5                             ; BB55 A5 A5                    ..
        ora     #$DE                            ; BB57 09 DE                    ..
        .byte   $BB                             ; BB59 BB                       .
        ldy     $9898,x                         ; BB5A BC 98 98                 ...
        ldy     $A4                             ; BB5D A4 A4                    ..
        ora     #$DE                            ; BB5F 09 DE                    ..
        .byte   $BB                             ; BB61 BB                       .
        ldy     $9898,x                         ; BB62 BC 98 98                 ...
        lda     $A5                             ; BB65 A5 A5                    ..
        ora     #$DE                            ; BB67 09 DE                    ..
        .byte   $BB                             ; BB69 BB                       .
        ldy     $9898,x                         ; BB6A BC 98 98                 ...
        lda     $A5                             ; BB6D A5 A5                    ..
        ora     #$DE                            ; BB6F 09 DE                    ..
        .byte   $DF                             ; BB71 DF                       .
        .byte   $BF                             ; BB72 BF                       .
        .byte   $BF                             ; BB73 BF                       .
        .byte   $BF                             ; BB74 BF                       .
        cpx     #$E1                            ; BB75 E0 E1                    ..
        ora     #$B8                            ; BB77 09 B8                    ..
        lda     LB9B8,y                         ; BB79 B9 B8 B9                 ...
        .byte   $AB                             ; BB7C AB                       .
        dec     LB8E2,x                         ; BB7D DE E2 B8                 ...
        tya                                     ; BB80 98                       .
        .byte   $AB                             ; BB81 AB                       .
        ldy     $1413                           ; BB82 AC 13 14                 ...
        ora     LACAB,y                         ; BB85 19 AB AC                 ...
        ldy     $9595,x                         ; BB88 BC 95 95                 ...
        sta     $95,x                           ; BB8B 95 95                    ..
        .byte   $A3                             ; BB8D A3                       .
        .byte   $AB                             ; BB8E AB                       .
        ldy     $98BC                           ; BB8F AC BC 98                 ...
        ldy     $9898,x                         ; BB92 BC 98 98                 ...
        lda     $E3                             ; BB95 A5 E3                    ..
        cpx     $98                             ; BB97 E4 98                    ..
        tya                                     ; BB99 98                       .
        tya                                     ; BB9A 98                       .
        tya                                     ; BB9B 98                       .
        tya                                     ; BB9C 98                       .
        lda     $E5                             ; BB9D A5 E5                    ..
        inc     $BC                             ; BB9F E6 BC                    ..
        tya                                     ; BBA1 98                       .
        ldy     $9898,x                         ; BBA2 BC 98 98                 ...
        ldy     $A4                             ; BBA5 A4 A4                    ..
        .byte   $E7                             ; BBA7 E7                       .
        ldy     LBC98,x                         ; BBA8 BC 98 BC                 ...
        tya                                     ; BBAB 98                       .
        asl     L0008                           ; BBAC 06 08                    ..
        ldy     $E8                             ; BBAE A4 E8                    ..
        tya                                     ; BBB0 98                       .
        sbc     #$CA                            ; BBB1 E9 CA                    ..
        ldy     LACAB                           ; BBB3 AC AB AC                 ...
        asl     L0008                           ; BBB6 06 08                    ..
        tya                                     ; BBB8 98                       .
        nop                                     ; BBB9 EA                       .
        lda     LB9B8,y                         ; BBBA B9 B8 B9                 ...
        clv                                     ; BBBD B8                       .
        lda     $09C2,y                         ; BBBE B9 C2 09                 ...
        .byte   $0B                             ; BBC1 0B                       .
        ora     #$0A                            ; BBC2 09 0A                    ..
        .byte   $0C                             ; BBC4 0C                       .
        .byte   $0B                             ; BBC5 0B                       .
        ora     #$0B                            ; BBC6 09 0B                    ..
        ora     #$0B                            ; BBC8 09 0B                    ..
        ora     #$0C                            ; BBCA 09 0C                    ..
        asl     a                               ; BBCC 0A                       .
        .byte   $0B                             ; BBCD 0B                       .
        ora     #$0B                            ; BBCE 09 0B                    ..
        ora     #$0B                            ; BBD0 09 0B                    ..
        ora     #$0C                            ; BBD2 09 0C                    ..
        asl     a                               ; BBD4 0A                       .
        .byte   $0B                             ; BBD5 0B                       .
        ora     #$0B                            ; BBD6 09 0B                    ..
        .byte   $AB                             ; BBD8 AB                       .
        ldy     $1413                           ; BBD9 AC 13 14                 ...
        .byte   $14                             ; BBDC 14                       .
        ora     LACAB,y                         ; BBDD 19 AB AC                 ...
        clv                                     ; BBE0 B8                       .
        lda     LB9B8,y                         ; BBE1 B9 B8 B9                 ...
        clv                                     ; BBE4 B8                       .
        lda     $EBB8,y                         ; BBE5 B9 B8 EB                 ...
        tya                                     ; BBE8 98                       .
        ldy     LBC98,x                         ; BBE9 BC 98 BC                 ...
        tya                                     ; BBEC 98                       .
        tya                                     ; BBED 98                       .
        tya                                     ; BBEE 98                       .
        cpx     $0806                           ; BBEF EC 06 08                 ...
        asl     $07                             ; BBF2 06 07                    ..
        .byte   $07                             ; BBF4 07                       .
        php                                     ; BBF5 08                       .
        .byte   $AB                             ; BBF6 AB                       .
        ldy     $0B09                           ; BBF7 AC 09 0B                 ...
        ora     #$0C                            ; BBFA 09 0C                    ..
        asl     a                               ; BBFC 0A                       .
        .byte   $0B                             ; BBFD 0B                       .
        .byte   $AB                             ; BBFE AB                       .
        ldy     $D9D9                           ; BBFF AC D9 D9                 ...
        cmp     $D9D9,y                         ; BC02 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC05 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC08 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC0B D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC0E D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC11 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC14 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC17 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC1A D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC1D D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC20 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC23 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC26 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC29 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC2C D9 D9 D9                 ...
        cmp     $0706,y                         ; BC2F D9 06 07                 ...
        .byte   $07                             ; BC32 07                       .
        php                                     ; BC33 08                       .
        asl     $07                             ; BC34 06 07                    ..
        .byte   $07                             ; BC36 07                       .
        php                                     ; BC37 08                       .
        ora     #$0A                            ; BC38 09 0A                    ..
        asl     a                               ; BC3A 0A                       .
        .byte   $0B                             ; BC3B 0B                       .
        ora     #$0A                            ; BC3C 09 0A                    ..
        asl     a                               ; BC3E 0A                       .
        .byte   $0B                             ; BC3F 0B                       .
        cmp     $D9D9,y                         ; BC40 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC43 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC46 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC49 D9 D9 D9                 ...
        .byte   $D9                             ; BC4C D9                       .
        .byte   $D9                             ; BC4D D9                       .
LBC4E:  cmp     $D9D9,y                         ; BC4E D9 D9 D9                 ...
        cmp     $EDD9,y                         ; BC51 D9 D9 ED                 ...
        inc     $D9D9                           ; BC54 EE D9 D9                 ...
        cmp     $D9D9,y                         ; BC57 D9 D9 D9                 ...
        .byte   $EF                             ; BC5A EF                       .
        beq     LBC4E                           ; BC5B F0 F1                    ..
        .byte   $F2                             ; BC5D F2                       .
        cmp     $D9D9,y                         ; BC5E D9 D9 D9                 ...
        cmp     $F4F3,y                         ; BC61 D9 F3 F4                 ...
        sbc     $F6,x                           ; BC64 F5 F6                    ..
        cmp     $D9D9,y                         ; BC66 D9 D9 D9                 ...
        cmp     $F8F7,y                         ; BC69 D9 F7 F8                 ...
        sbc     $D9FA,y                         ; BC6C F9 FA D9                 ...
        cmp     $D9D9,y                         ; BC6F D9 D9 D9                 ...
        cmp     $FCFB,y                         ; BC72 D9 FB FC                 ...
        cmp     $D9D9,y                         ; BC75 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC78 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC7B D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC7E D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC81 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC84 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC87 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC8A D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC8D D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC90 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC93 D9 D9 D9                 ...
        .byte   $D9                             ; BC96 D9                       .
        .byte   $D9                             ; BC97 D9                       .
LBC98:  cmp     $D9D9,y                         ; BC98 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC9B D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BC9E D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCA1 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCA4 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCA7 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCAA D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCAD D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCB0 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCB3 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCB6 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCB9 D9 D9 D9                 ...
LBCBC:  cmp     $D9D9,y                         ; BCBC D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCBF D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCC2 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCC5 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCC8 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCCB D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCCE D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCD1 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCD4 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCD7 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCDA D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCDD D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCE0 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCE3 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCE6 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCE9 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCEC D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCEF D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCF2 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCF5 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCF8 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCFB D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BCFE D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD01 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD04 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD07 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD0A D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD0D D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD10 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD13 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD16 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD19 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD1C D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD1F D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD22 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD25 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD28 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD2B D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD2E D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD31 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD34 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD37 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD3A D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD3D D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD40 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD43 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD46 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD49 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD4C D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD4F D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD52 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD55 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD58 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD5B D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD5E D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD61 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD64 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD67 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD6A D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD6D D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD70 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD73 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD76 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD79 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD7C D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD7F D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD82 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD85 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD88 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD8B D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD8E D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD91 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD94 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD97 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD9A D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BD9D D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDA0 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDA3 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDA6 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDA9 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDAC D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDAF D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDB2 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDB5 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDB8 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDBB D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDBE D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDC1 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDC4 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDC7 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDCA D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDCD D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDD0 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDD3 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDD6 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDD9 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDDC D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDDF D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDE2 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDE5 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDE8 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDEB D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDEE D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDF1 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDF4 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDF7 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDFA D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BDFD D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE00 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE03 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE06 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE09 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE0C D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE0F D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE12 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE15 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE18 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE1B D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE1E D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE21 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE24 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE27 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE2A D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE2D D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE30 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE33 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE36 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE39 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE3C D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE3F D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE42 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE45 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE48 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE4B D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE4E D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE51 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE54 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE57 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE5A D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE5D D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE60 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE63 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE66 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE69 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE6C D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE6F D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE72 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE75 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE78 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE7B D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE7E D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE81 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE84 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE87 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE8A D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE8D D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE90 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE93 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE96 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE99 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE9C D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BE9F D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEA2 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEA5 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEA8 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEAB D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEAE D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEB1 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEB4 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEB7 D9 D9 D9                 ...
        .byte   $D9                             ; BEBA D9                       .
        .byte   $D9                             ; BEBB D9                       .
LBEBC:  .byte   $D9                             ; BEBC D9                       .
LBEBD:  cmp     $D9D9,y                         ; BEBD D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEC0 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEC3 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEC6 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEC9 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BECC D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BECF D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BED2 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BED5 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BED8 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEDB D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEDE D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEE1 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEE4 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEE7 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEEA D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEED D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEF0 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEF3 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEF6 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEF9 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEFC D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BEFF D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF02 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF05 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF08 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF0B D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF0E D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF11 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF14 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF17 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF1A D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF1D D9 D9 D9                 ...
        .byte   $D9                             ; BF20 D9                       .
LBF21:  cmp     $D9D9,y                         ; BF21 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF24 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF27 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF2A D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF2D D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF30 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF33 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF36 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF39 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF3C D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF3F D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF42 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF45 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF48 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF4B D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF4E D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF51 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF54 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF57 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF5A D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF5D D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF60 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF63 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF66 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF69 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF6C D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF6F D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF72 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF75 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF78 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF7B D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF7E D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF81 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF84 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF87 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF8A D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF8D D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF90 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF93 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF96 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF99 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF9C D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BF9F D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFA2 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFA5 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFA8 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFAB D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFAE D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFB1 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFB4 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFB7 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFBA D9 D9 D9                 ...
LBFBD:  cmp     $D9D9,y                         ; BFBD D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFC0 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFC3 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFC6 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFC9 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFCC D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFCF D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFD2 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFD5 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFD8 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFDB D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFDE D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFE1 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFE4 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFE7 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFEA D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFED D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFF0 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFF3 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFF6 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFF9 D9 D9 D9                 ...
        cmp     $D9D9,y                         ; BFFC D9 D9 D9                 ...
LBFFF:  .byte   $D9                             ; BFFF D9                       .
