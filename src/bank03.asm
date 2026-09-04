.setcpu "6502"
.include "include/hardware.inc"
.include "include/zeropage.inc"
.include "include/constants.inc"
.include "include/fixed_bank.inc"

.segment "BANK03"

; =============================================================================
; BANK $03 (mapped at $A000) — DARK MAN 4 SCENE, BOSS-RUSH PODS + GYRO
; MAN STAGE DATA
; Data half (file +$0900 on): stage $03 (Gyro Man) stage data —
; screen table at $A900 with this bank at $A000; format in
; DATA_REFERENCE.md section 11.
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
L809D           := $809D
L8B7A           := $8B7A
L8BDF           := $8BDF
LEA34           := $EA34
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR types $A2/$B5 — DARK MAN 4 "fake Proto Man" scene director
; (Proto castle 4, spawn code $5E at scr $03). If the scene already ran
; ($69==4) it immediately becomes a boss-room director (type $B3, sub
; $47 = Dark Man 4). Otherwise it plays the ambush: freeze the player
; into state $11 walk-to-mark (saving HP $B0 into $0468, $A047), pose
; through sub $A0/$A1, pace left, fire the paralyzer shot (type $A3 sub
; $A6, $A0BA) that pins Mega Man at 1 HP, whistle (sound $30, $A126),
; summon the real Proto Man (type $A4 sub $A2 from the left edge,
; $A15C), retreat right firing again, then flicker-transform through
; LA260/LA264 (types $B5<->$A2 alternate into this same entry) and
; finish as type $98 — Dark Man 4 ($09:A405), shape cleared ($A252).
; =============================================================================
        lda     $69                             ; A000 A5 69                    .i
        cmp     #$04                            ; A002 C9 04                    ..
        bne     LA01C                           ; A004 D0 16                    ..
        lda     $0438,x                         ; A006 BD 38 04                 .8.
        pha                                     ; A009 48                       H
        jsr     entity_wipe_x                           ; A00A 20 C4 F2                  ..
        pla                                     ; A00D 68                       h
        sta     $0438,x                         ; A00E 9D 38 04                 .8.
        lda     #$47                            ; A011 A9 47                    .G
        jsr     entity_set_subtype                           ; A013 20 98 EA                  ..
        lda     #$B3                            ; A016 A9 B3                    ..
        sta     $0300,x                         ; A018 9D 00 03                 ...
        rts                                     ; A01B 60                       `

; ----------------------------------------------------------------------------
LA01C:  lda     $0528,x                         ; A01C BD 28 05                 .(.
        and     #$FB                            ; A01F 29 FB                    ).
        sta     $0528,x                         ; A021 9D 28 05                 .(.
        ldy     L0030                           ; A024 A4 30                    .0
        bne     LA075                           ; A026 D0 4D                    .M
        sty     $33                             ; A028 84 33                    .3
        sty     $34                             ; A02A 84 34                    .4
        lda     #$04                            ; A02C A9 04                    ..
        sta     $69                             ; A02E 85 69                    .i
        lda     #$01                            ; A030 A9 01                    ..
        jsr     entity_init_subtype_y                           ; A032 20 E9 EA                  ..
        lda     $0528                           ; A035 AD 28 05                 .(.
        ora     #$20                            ; A038 09 20                    . 
        sta     $0528                           ; A03A 8D 28 05                 .(.
        lda     L00B0                           ; A03D A5 B0                    ..
        sta     $0468                           ; A03F 8D 68 04                 .h.
        lda     #$FF                            ; A042 A9 FF                    ..
        sta     $0480                           ; A044 8D 80 04                 ...
        lda     #$11                            ; A047 A9 11                    ..
        sta     L0030                           ; A049 85 30                    .0
        lda     #$5A                            ; A04B A9 5A                    .Z
        sta     $0588,x                         ; A04D 9D 88 05                 ...
        lda     #$A0                            ; A050 A9 A0                    ..
        sta     $05A0,x                         ; A052 9D A0 05                 ...
        lda     #$2F                            ; A055 A9 2F                    ./
        jmp     queue_sound                           ; A057 4C 5D EC                 L].

; ----------------------------------------------------------------------------
        lda     $0330                           ; A05A AD 30 03                 .0.
        cmp     #$84                            ; A05D C9 84                    ..
        bne     LA075                           ; A05F D0 14                    ..
        lda     #$3C                            ; A061 A9 3C                    .<
        sta     $0468,x                         ; A063 9D 68 04                 .h.
        lda     #$76                            ; A066 A9 76                    .v
        sta     $0588,x                         ; A068 9D 88 05                 ...
        lda     #$A0                            ; A06B A9 A0                    ..
        sta     $05A0,x                         ; A06D 9D A0 05                 ...
        lda     #$A0                            ; A070 A9 A0                    ..
        jsr     entity_set_subtype                           ; A072 20 98 EA                  ..
LA075:  rts                                     ; A075 60                       `

; ----------------------------------------------------------------------------
        lda     $0468,x                         ; A076 BD 68 04                 .h.
        beq     LA08C                           ; A079 F0 11                    ..
        dec     $0468,x                         ; A07B DE 68 04                 .h.
        bne     LA0EF                           ; A07E D0 6F                    .o
LA080:  lda     #$A1                            ; A080 A9 A1                    ..
        jsr     entity_set_subtype                           ; A082 20 98 EA                  ..
        ldy     #$00                            ; A085 A0 00                    ..
        lda     #$0D                            ; A087 A9 0D                    ..
        jsr     entity_init_subtype_y                           ; A089 20 E9 EA                  ..
LA08C:  lda     $0540,x                         ; A08C BD 40 05                 .@.
        bne     LA0EF                           ; A08F D0 5E                    .^
        jsr     entity_move_left_collide                           ; A091 20 0C E9                  ..
        lda     #$AC                            ; A094 A9 AC                    ..
        cmp     $0330,x                         ; A096 DD 30 03                 .0.
        bcc     LA0EF                           ; A099 90 54                    .T
        sta     $0330,x                         ; A09B 9D 30 03                 .0.
        lda     #$A0                            ; A09E A9 A0                    ..
        jsr     entity_set_subtype                           ; A0A0 20 98 EA                  ..
        lda     #$B2                            ; A0A3 A9 B2                    ..
        sta     $0588,x                         ; A0A5 9D 88 05                 ...
        lda     #$A0                            ; A0A8 A9 A0                    ..
        sta     $05A0,x                         ; A0AA 9D A0 05                 ...
        lda     #$1C                            ; A0AD A9 1C                    ..
        sta     $0468,x                         ; A0AF 9D 68 04                 .h.
        lda     $0468,x                         ; A0B2 BD 68 04                 .h.
        bne     LA0EC                           ; A0B5 D0 35                    .5
        sta     $0570,x                         ; A0B7 9D 70 05                 .p.
        jsr     find_free_slot_y                           ; A0BA 20 6F F1                  o.
        bcs     LA0EC                           ; A0BD B0 2D                    .-
        lda     #$A6                            ; A0BF A9 A6                    ..
        jsr     entity_init_pos                           ; A0C1 20 A4 EA                  ..
        lda     #$A3                            ; A0C4 A9 A3                    ..
        sta     $0300,y                         ; A0C6 99 00 03                 ...
        lda     #$A4                            ; A0C9 A9 A4                    ..
        sta     $0330,y                         ; A0CB 99 30 03                 .0.
        lda     #$00                            ; A0CE A9 00                    ..
        sta     $03A8,y                         ; A0D0 99 A8 03                 ...
        lda     #$04                            ; A0D3 A9 04                    ..
        sta     $03C0,y                         ; A0D5 99 C0 03                 ...
        lda     #$02                            ; A0D8 A9 02                    ..
        sta     $0420,y                         ; A0DA 99 20 04                 . .
        lda     #$28                            ; A0DD A9 28                    .(
        sta     $0468,x                         ; A0DF 9D 68 04                 .h.
        lda     #$F0                            ; A0E2 A9 F0                    ..
        sta     $0588,x                         ; A0E4 9D 88 05                 ...
        lda     #$A0                            ; A0E7 A9 A0                    ..
        sta     $05A0,x                         ; A0E9 9D A0 05                 ...
LA0EC:  dec     $0468,x                         ; A0EC DE 68 04                 .h.
LA0EF:  rts                                     ; A0EF 60                       `

; ----------------------------------------------------------------------------
        lda     $0468,x                         ; A0F0 BD 68 04                 .h.
        bne     LA0EC                           ; A0F3 D0 F7                    ..
        lda     #$A1                            ; A0F5 A9 A1                    ..
        cmp     $0558,x                         ; A0F7 DD 58 05                 .X.
        beq     LA0FF                           ; A0FA F0 03                    ..
        jsr     entity_set_subtype                           ; A0FC 20 98 EA                  ..
LA0FF:  lda     $0540,x                         ; A0FF BD 40 05                 .@.
        bne     LA0EF                           ; A102 D0 EB                    ..
        jsr     entity_move_left_collide                           ; A104 20 0C E9                  ..
        lda     #$A4                            ; A107 A9 A4
        cmp     $0330,x                         ; A109 DD 30 03
        bcc     LA0EF                           ; A10C 90 E1                    ..
        sta     $0330,x                         ; A10E 9D 30 03                 .0.
        lda     #$A0                            ; A111 A9 A0                    ..
        jsr     entity_set_subtype                           ; A113 20 98 EA                  ..
        lda     #$26                            ; A116 A9 26                    .&
        sta     $0588,x                         ; A118 9D 88 05                 ...
        lda     #$A1                            ; A11B A9 A1                    ..
        sta     $05A0,x                         ; A11D 9D A0 05                 ...
LA120:  lda     #$3C                            ; A120 A9 3C                    .<
        sta     $0468,x                         ; A122 9D 68 04                 .h.
        rts                                     ; A125 60                       `

; ----------------------------------------------------------------------------
        lda     #$30                            ; A126 A9 30                    .0
        jsr     queue_sound                           ; A128 20 5D EC                  ].
        lda     #$37                            ; A12B A9 37                    .7
        sta     $0588,x                         ; A12D 9D 88 05                 ...
        lda     #$A1                            ; A130 A9 A1                    ..
        sta     $05A0,x                         ; A132 9D A0 05                 ...
        bne     LA120                           ; A135 D0 E9                    ..
        lda     $0468,x                         ; A137 BD 68 04                 .h.
        bne     LA0EC                           ; A13A D0 B0                    ..
        lda     #$9F                            ; A13C A9 9F                    ..
        jsr     entity_set_subtype                           ; A13E 20 98 EA                  ..
        ldy     #$00                            ; A141 A0 00                    ..
        lda     #$1F                            ; A143 A9 1F                    ..
        jsr     entity_init_subtype_y                           ; A145 20 E9 EA                  ..
        lda     #$57                            ; A148 A9 57                    .W
        sta     $0588,x                         ; A14A 9D 88 05                 ...
        lda     #$A1                            ; A14D A9 A1                    ..
        sta     $05A0,x                         ; A14F 9D A0 05                 ...
        lda     #$E1                            ; A152 A9 E1                    ..
        sta     $0468,x                         ; A154 9D 68 04                 .h.
        lda     $0468,x                         ; A157 BD 68 04                 .h.
        bne     LA0EC                           ; A15A D0 90                    ..
        jsr     find_free_slot_y                           ; A15C 20 6F F1                  o.
        bcs     LA0EF                           ; A15F B0 8E                    ..
        lda     #$A2                            ; A161 A9 A2                    ..
        jsr     entity_init_pos                           ; A163 20 A4 EA                  ..
        lda     $0528,y                         ; A166 B9 28 05                 .(.
        ora     #$20                            ; A169 09 20                    . 
        sta     $0528,y                         ; A16B 99 28 05                 .(.
        lda     #$A4                            ; A16E A9 A4                    ..
        sta     $0300,y                         ; A170 99 00 03                 ...
        lda     #$00                            ; A173 A9 00                    ..
        sta     $0378,y                         ; A175 99 78 03                 .x.
        lda     #$24                            ; A178 A9 24                    .$
        sta     $0330,y                         ; A17A 99 30 03                 .0.
        txa                                     ; A17D 8A                       .
        sta     $0468,y                         ; A17E 99 68 04                 .h.
        jsr     LEA34                           ; A181 20 34 EA                  4.
        tya                                     ; A184 98                       .
        sta     $0480,x                         ; A185 9D 80 04                 ...
        lda     #$92                            ; A188 A9 92                    ..
        sta     $0588,x                         ; A18A 9D 88 05                 ...
        lda     #$A1                            ; A18D A9 A1                    ..
        sta     $05A0,x                         ; A18F 9D A0 05                 ...
        ldy     $0480,x                         ; A192 BC 80 04                 ...
        lda     $0558,y                         ; A195 B9 58 05                 .X.
        cmp     #$A4                            ; A198 C9 A4                    ..
        bne     LA215                           ; A19A D0 79                    .y
        lda     #$A1                            ; A19C A9 A1                    ..
        jsr     entity_set_subtype                           ; A19E 20 98 EA                  ..
        lda     #$AB                            ; A1A1 A9 AB                    ..
        sta     $0588,x                         ; A1A3 9D 88 05                 ...
        lda     #$A1                            ; A1A6 A9 A1                    ..
        sta     $05A0,x                         ; A1A8 9D A0 05                 ...
        lda     $0540,x                         ; A1AB BD 40 05                 .@.
        bne     LA215                           ; A1AE D0 65                    .e
        jsr     entity_move_right_collide                           ; A1B0 20 E6 E8                  ..
        lda     $0528,x                         ; A1B3 BD 28 05                 .(.
        and     #$DF                            ; A1B6 29 DF                    ).
        sta     $0528,x                         ; A1B8 9D 28 05                 .(.
        lda     #$D4                            ; A1BB A9 D4                    ..
        cmp     $0330,x                         ; A1BD DD 30 03                 .0.
        bcs     LA215                           ; A1C0 B0 53                    .S
        sta     $0330,x                         ; A1C2 9D 30 03                 .0.
        lda     #$A0                            ; A1C5 A9 A0                    ..
        jsr     entity_set_subtype                           ; A1C7 20 98 EA                  ..
        lda     #$D9                            ; A1CA A9 D9                    ..
        sta     $0588,x                         ; A1CC 9D 88 05                 ...
        lda     #$A1                            ; A1CF A9 A1                    ..
        sta     $05A0,x                         ; A1D1 9D A0 05                 ...
        lda     #$1E                            ; A1D4 A9 1E                    ..
        sta     $0468,x                         ; A1D6 9D 68 04                 .h.
        jsr     find_free_slot_y                           ; A1D9 20 6F F1                  o.
        bcs     LA215                           ; A1DC B0 37                    .7
        dec     $0468,x                         ; A1DE DE 68 04                 .h.
        bne     LA215                           ; A1E1 D0 32                    .2
        lda     #$A6                            ; A1E3 A9 A6                    ..
        jsr     entity_init_pos                           ; A1E5 20 A4 EA                  ..
        lda     #$A3                            ; A1E8 A9 A3                    ..
        sta     $0300,y                         ; A1EA 99 00 03                 ...
        lda     #$C4                            ; A1ED A9 C4                    ..
        sta     $0330,y                         ; A1EF 99 30 03                 .0.
        lda     #$00                            ; A1F2 A9 00                    ..
        sta     $03A8,y                         ; A1F4 99 A8 03                 ...
        lda     #$04                            ; A1F7 A9 04                    ..
        sta     $03C0,y                         ; A1F9 99 C0 03                 ...
        lda     #$86                            ; A1FC A9 86                    ..
        sta     $03D8,y                         ; A1FE 99 D8 03                 ...
        lda     #$01                            ; A201 A9 01                    ..
        sta     $03F0,y                         ; A203 99 F0 03                 ...
        lda     #$0A                            ; A206 A9 0A                    ..
        sta     $0420,y                         ; A208 99 20 04                 . .
        lda     #$16                            ; A20B A9 16                    ..
        sta     $0588,x                         ; A20D 9D 88 05                 ...
        lda     #$A2                            ; A210 A9 A2                    ..
        sta     $05A0,x                         ; A212 9D A0 05                 ...
LA215:  rts                                     ; A215 60                       `

; ----------------------------------------------------------------------------
        lda     $0570,x                         ; A216 BD 70 05                 .p.
        ora     $0540,x                         ; A219 1D 40 05                 .@.
        bne     LA25F                           ; A21C D0 41                    .A
LA21E:  lda     #$9E                            ; A21E A9 9E                    ..
LA220:  jsr     entity_set_subtype                           ; A220 20 98 EA                  ..
        lda     #$15                            ; A223 A9 15                    ..
        sta     $0588,x                         ; A225 9D 88 05                 ...
        lda     #$A2                            ; A228 A9 A2                    ..
        sta     $05A0,x                         ; A22A 9D A0 05                 ...
        rts                                     ; A22D 60                       `

; ----------------------------------------------------------------------------
        dec     $0468,x                         ; A22E DE 68 04                 .h.
        bne     LA215                           ; A231 D0 E2                    ..
        ldy     $0480,x                         ; A233 BC 80 04                 ...
        lda     LA260,y                         ; A236 B9 60 A2                 .`.
        jsr     entity_set_subtype                           ; A239 20 98 EA                  ..
        lda     LA264,y                         ; A23C B9 64 A2                 .d.
        sta     $0300,x                         ; A23F 9D 00 03                 ...
        lda     LA268,y                         ; A242 B9 68 A2                 .h.
        sta     $0378,x                         ; A245 9D 78 03                 .x.
        lda     #$08                            ; A248 A9 08                    ..
        sta     $0468,x                         ; A24A 9D 68 04                 .h.
        dec     $0480,x                         ; A24D DE 80 04                 ...
        bpl     LA25F                           ; A250 10 0D                    ..
        jsr     entity_wipe_x                           ; A252 20 C4 F2                  ..
        lda     #$98                            ; A255 A9 98                    ..
        sta     $0300,x                         ; A257 9D 00 03                 ...
        lda     #$00                            ; A25A A9 00                    ..
        sta     $0408,x                         ; A25C 9D 08 04                 ...
LA25F:  rts                                     ; A25F 60                       `

; ----------------------------------------------------------------------------
LA260:  .byte   $47,$9E,$47,$9E                 ; A260  transform flicker sub_type
LA264:  .byte   $B5,$A2,$B5,$A2                 ; A264  transform flicker type
LA268:  .byte   $B0,$B4,$B0,$B4                 ; A268  transform flicker Y
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $A3 — scene projectile. Sub $A6: Dark Man's paralyzer —
; on player contact, wipes itself and pins the player (pose via
; entity_init_subtype_y, HP $B0 := $81, $A294). Sub $A5: Proto Man's
; counter-shot — at X >= $D0 it bursts (spawns type $2F sub $42) and
; releases the player ($A297).
; =============================================================================
        jsr     entity_facing_dispatch                           ; A26C 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A26F 20 86 EA                  ..
        lda     $0558,x                         ; A272 BD 58 05                 .X.
        cmp     #$A5                            ; A275 C9 A5                    ..
        beq     LA297                           ; A277 F0 1E                    ..
        jsr     entity_player_collide                           ; A279 20 87 EF                  ..
        bcs     LA2DE                           ; A27C B0 60                    .`
        jsr     entity_wipe_x                           ; A27E 20 C4 F2                  ..
        lda     #$1C                            ; A281 A9 1C                    ..
        jsr     queue_sound                           ; A283 20 5D EC                  ].
        lda     #$11                            ; A286 A9 11                    ..
        cmp     $0558                           ; A288 CD 58 05                 .X.
        beq     LA296                           ; A28B F0 09                    ..
        ldy     #$00                            ; A28D A0 00                    ..
        jsr     entity_init_subtype_y                           ; A28F 20 E9 EA                  ..
        lda     #$81                            ; A292 A9 81                    ..
        sta     L00B0                           ; A294 85 B0                    ..
LA296:  rts                                     ; A296 60                       `

; ----------------------------------------------------------------------------
LA297:  lda     $0330,x                         ; A297 BD 30 03                 .0.
        cmp     #$D0                            ; A29A C9 D0                    ..
        bcc     LA2DE                           ; A29C 90 40                    .@
        jsr     find_free_slot_y                           ; A29E 20 6F F1                  o.
        bcs     LA2DE                           ; A2A1 B0 3B                    .;
        lda     #$42                            ; A2A3 A9 42                    .B
        jsr     entity_init_pos                           ; A2A5 20 A4 EA                  ..
        lda     #$2F                            ; A2A8 A9 2F                    ./
        sta     $0300,y                         ; A2AA 99 00 03                 ...
        lda     #$00                            ; A2AD A9 00                    ..
        sta     $0408,y                         ; A2AF 99 08 04                 ...
        ldy     $0468,x                         ; A2B2 BC 68 04                 .h.
        jsr     entity_init_subtype_y                           ; A2B5 20 E9 EA                  ..
        lda     #$2E                            ; A2B8 A9 2E                    ..
        sta     $0588,y                         ; A2BA 99 88 05                 ...
        lda     #$A2                            ; A2BD A9 A2                    ..
        sta     $05A0,y                         ; A2BF 99 A0 05                 ...
        lda     #$14                            ; A2C2 A9 14                    ..
        sta     $0468,y                         ; A2C4 99 68 04                 .h.
        lda     #$03                            ; A2C7 A9 03                    ..
        sta     $0480,y                         ; A2C9 99 80 04                 ...
        jsr     entity_wipe_x                           ; A2CC 20 C4 F2                  ..
        ldy     #$00                            ; A2CF A0 00                    ..
        lda     #$01                            ; A2D1 A9 01                    ..
        jsr     entity_init_subtype_y                           ; A2D3 20 E9 EA                  ..
        lda     $0528                           ; A2D6 AD 28 05                 .(.
        and     #$DF                            ; A2D9 29 DF                    ).
        sta     $0528                           ; A2DB 8D 28 05                 .(.
LA2DE:  rts                                     ; A2DE 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $A4 — real Proto Man (scene actor). Drops in to Y=$84,
; waits for the impostor to back off to X=$D4, fires the counter-shot
; (type $A3 sub $A5) while hopping ($A314), lands again; once the
; impostor has become type $98 (Dark Man 4, $A390) he runs right with
; a landing-dust effect (type $6D), pauses, then leaps away ($A3EA) —
; and on exit restores the player: pose 7, yvel $04.7E up, state $13
; drop-in/restore ($A418).
; =============================================================================
        jsr     entity_process_y_vel                           ; A2DF 20 68 E9                  h.
        lda     #$84                            ; A2E2 A9 84                    ..
        cmp     $0378,x                         ; A2E4 DD 78 03                 .x.
        bcs     LA2DE                           ; A2E7 B0 F5                    ..
        sta     $0378,x                         ; A2E9 9D 78 03                 .x.
        lda     #$A4                            ; A2EC A9 A4                    ..
        jsr     entity_set_subtype                           ; A2EE 20 98 EA                  ..
        lda     #$00                            ; A2F1 A9 00                    ..
        sta     $0588,x                         ; A2F3 9D 88 05                 ...
        lda     #$A3                            ; A2F6 A9 A3                    ..
        sta     $05A0,x                         ; A2F8 9D A0 05                 ...
        lda     #$3C                            ; A2FB A9 3C                    .<
        sta     $0480,x                         ; A2FD 9D 80 04                 ...
        ldy     $0468,x                         ; A300 BC 68 04                 .h.
        lda     $0330,y                         ; A303 B9 30 03                 .0.
        cmp     #$D4                            ; A306 C9 D4                    ..
        bne     LA2DE                           ; A308 D0 D4                    ..
        dec     $0480,x                         ; A30A DE 80 04                 ...
        bne     LA2DE                           ; A30D D0 CF                    ..
        lda     #$A3                            ; A30F A9 A3                    ..
        jsr     entity_set_subtype                           ; A311 20 98 EA                  ..
        jsr     find_free_slot_y                           ; A314 20 6F F1                  o.
        bcs     LA2DE                           ; A317 B0 C5                    ..
        lda     #$A5                            ; A319 A9 A5                    ..
        jsr     entity_init_pos                           ; A31B 20 A4 EA                  ..
        lda     $0468,x                         ; A31E BD 68 04                 .h.
        sta     $0468,y                         ; A321 99 68 04                 .h.
        txa                                     ; A324 8A                       .
        sta     $0480,y                         ; A325 99 80 04                 ...
        lda     #$A3                            ; A328 A9 A3                    ..
        sta     $0300,y                         ; A32A 99 00 03                 ...
        lda     #$2C                            ; A32D A9 2C                    .,
        sta     $0330,y                         ; A32F 99 30 03                 .0.
        lda     #$00                            ; A332 A9 00                    ..
        sta     $03A8,y                         ; A334 99 A8 03                 ...
        lda     #$04                            ; A337 A9 04                    ..
        sta     $03C0,y                         ; A339 99 C0 03                 ...
        lda     #$50                            ; A33C A9 50                    .P
        sta     $03D8,y                         ; A33E 99 D8 03                 ...
        lda     #$01                            ; A341 A9 01                    ..
        sta     $03F0,y                         ; A343 99 F0 03                 ...
        lda     #$05                            ; A346 A9 05                    ..
        sta     $0420,y                         ; A348 99 20 04                 . .
        lda     #$2F                            ; A34B A9 2F                    ./
        sta     $03D8,x                         ; A34D 9D D8 03                 ...
        lda     #$05                            ; A350 A9 05                    ..
        sta     $03F0,x                         ; A352 9D F0 03                 ...
        lda     #$5F                            ; A355 A9 5F                    ._
        sta     $0588,x                         ; A357 9D 88 05                 ...
        lda     #$A3                            ; A35A A9 A3                    ..
        sta     $05A0,x                         ; A35C 9D A0 05                 ...
        jsr     entity_process_y_vel                           ; A35F 20 68 E9                  h.
        lda     #$84                            ; A362 A9 84                    ..
        cmp     $0378,x                         ; A364 DD 78 03                 .x.
        bcs     LA38F                           ; A367 B0 26                    .&
        sta     $0378,x                         ; A369 9D 78 03                 .x.
        lda     #$90                            ; A36C A9 90                    ..
        sta     $0588,x                         ; A36E 9D 88 05                 ...
        lda     #$A3                            ; A371 A9 A3                    ..
        sta     $05A0,x                         ; A373 9D A0 05                 ...
        lda     #$A4                            ; A376 A9 A4                    ..
        jsr     entity_set_subtype                           ; A378 20 98 EA                  ..
        lda     #$20                            ; A37B A9 20                    . 
        sta     $03A8,x                         ; A37D 9D A8 03                 ...
        lda     #$01                            ; A380 A9 01                    ..
        sta     $03C0,x                         ; A382 9D C0 03                 ...
        lda     #$D4                            ; A385 A9 D4                    ..
        sta     $03D8,x                         ; A387 9D D8 03                 ...
        lda     #$02                            ; A38A A9 02                    ..
        sta     $03F0,x                         ; A38C 9D F0 03                 ...
LA38F:  rts                                     ; A38F 60                       `

; ----------------------------------------------------------------------------
        ldy     $0468,x                         ; A390 BC 68 04                 .h.
        lda     $0300,y                         ; A393 B9 00 03                 ...
        cmp     #$98                            ; A396 C9 98                    ..
        bne     LA38F                           ; A398 D0 F5                    ..
        jsr     entity_process_y_vel                           ; A39A 20 68 E9                  h.
        jsr     entity_move_right_collide                           ; A39D 20 E6 E8                  ..
        lda     #$94                            ; A3A0 A9 94                    ..
        cmp     $0378,x                         ; A3A2 DD 78 03                 .x.
        bcs     LA41C                           ; A3A5 B0 75                    .u
        sta     $0378,x                         ; A3A7 9D 78 03                 .x.
        jsr     find_free_slot_y                           ; A3AA 20 6F F1                  o.
        bcs     LA41C                           ; A3AD B0 6D                    .m
        lda     #$A4                            ; A3AF A9 A4                    ..
        jsr     entity_set_subtype                           ; A3B1 20 98 EA                  ..
        lda     #$63                            ; A3B4 A9 63                    .c
        jsr     entity_init_pos                           ; A3B6 20 A4 EA                  ..
        lda     $0528,y                         ; A3B9 B9 28 05                 .(.
        and     #$DF                            ; A3BC 29 DF                    ).
        sta     $0528,y                         ; A3BE 99 28 05                 .(.
        lda     #$6D                            ; A3C1 A9 6D                    .m
        sta     $0300,y                         ; A3C3 99 00 03                 ...
        lda     #$98                            ; A3C6 A9 98                    ..
        sta     $0378,y                         ; A3C8 99 78 03                 .x.
        tya                                     ; A3CB 98                       .
        sta     $0480                           ; A3CC 8D 80 04                 ...
        lda     #$00                            ; A3CF A9 00                    ..
        sta     $0408,y                         ; A3D1 99 08 04                 ...
        sta     $03D8,x                         ; A3D4 9D D8 03                 ...
        sta     $03F0,x                         ; A3D7 9D F0 03                 ...
        lda     #$EA                            ; A3DA A9 EA                    ..
        sta     $0588,x                         ; A3DC 9D 88 05                 ...
        lda     #$A3                            ; A3DF A9 A3                    ..
        sta     $05A0,x                         ; A3E1 9D A0 05                 ...
        lda     #$1E                            ; A3E4 A9 1E                    ..
        sta     $0480,x                         ; A3E6 9D 80 04                 ...
        rts                                     ; A3E9 60                       `

; ----------------------------------------------------------------------------
        lda     $0480,x                         ; A3EA BD 80 04                 ...
        beq     LA3F9                           ; A3ED F0 0A                    ..
        dec     $0480,x                         ; A3EF DE 80 04                 ...
        bne     LA41C                           ; A3F2 D0 28                    .(
        lda     #$A2                            ; A3F4 A9 A2                    ..
        jsr     entity_set_subtype                           ; A3F6 20 98 EA                  ..
LA3F9:  jsr     entity_apply_gravity                           ; A3F9 20 E1 E9                  ..
        jsr     entity_move_up_nofacing                           ; A3FC 20 4A E9                  J.
        lda     $0390,x                         ; A3FF BD 90 03                 ...
        beq     LA41C                           ; A402 F0 18                    ..
        jsr     entity_wipe_x                           ; A404 20 C4 F2                  ..
        ldy     #$00                            ; A407 A0 00                    ..
        lda     #$07                            ; A409 A9 07                    ..
        jsr     entity_init_subtype_y                           ; A40B 20 E9 EA                  ..
        lda     #$7E                            ; A40E A9 7E                    .~
        sta     $03D8                           ; A410 8D D8 03                 ...
        lda     #$04                            ; A413 A9 04                    ..
        sta     $03F0                           ; A415 8D F0 03                 ...
        lda     #$13                            ; A418 A9 13                    ..
        sta     L0030                           ; A41A 85 30                    .0
LA41C:  rts                                     ; A41C 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $AF — boss-rush teleporter pod (10 in bank $0E scr
; $02-$03). On player touch in play state: freeze inputs, snap the
; player onto the pod in beam pose (sub $13), state $15 teleport-out,
; sound $F1; then find this pod in the position table LA47B
; (screen/X/Y stride 4) and hand its index*4 to $6A as the destination
; pad before self-wiping.
; =============================================================================
        lda     L0030                           ; A41D A5 30                    .0
        bne     LA47A                           ; A41F D0 59                    .Y
        jsr     entity_player_collide                           ; A421 20 87 EF                  ..
        bcs     LA47A                           ; A424 B0 54                    .T
        ldy     #$00                            ; A426 A0 00                    ..
        sty     $34                             ; A428 84 34                    .4
        sty     $33                             ; A42A 84 33                    .3
        lda     #$13                            ; A42C A9 13                    ..
        jsr     entity_init_subtype_y                           ; A42E 20 E9 EA                  ..
        lda     $0528                           ; A431 AD 28 05                 .(.
        ora     #$20                            ; A434 09 20                    . 
        sta     $0528                           ; A436 8D 28 05                 .(.
        lda     #$04                            ; A439 A9 04                    ..
        sta     $0540                           ; A43B 8D 40 05                 .@.
        lda     $0330,x                         ; A43E BD 30 03                 .0.
        sta     $0330                           ; A441 8D 30 03                 .0.
        lda     $0378,x                         ; A444 BD 78 03                 .x.
        ora     #$04                            ; A447 09 04                    ..
        sta     $0378                           ; A449 8D 78 03                 .x.
        lda     #$15                            ; A44C A9 15                    ..
        sta     L0030                           ; A44E 85 30                    .0
        lda     #$F1                            ; A450 A9 F1                    ..
        jsr     queue_sound                           ; A452 20 5D EC                  ].
        ldy     #$24                            ; A455 A0 24                    .$
LA457:  lda     $0348,x                         ; A457 BD 48 03                 .H.
        cmp     LA47B,y                         ; A45A D9 7B A4                 .{.
        bne     LA474                           ; A45D D0 15                    ..
        lda     $0330,x                         ; A45F BD 30 03                 .0.
        cmp     LA47C,y                         ; A462 D9 7C A4                 .|.
        bne     LA474                           ; A465 D0 0D                    ..
        lda     $0378,x                         ; A467 BD 78 03                 .x.
        cmp     LA47D,y                         ; A46A D9 7D A4                 .}.
        bne     LA474                           ; A46D D0 05                    ..
        sty     $6A                             ; A46F 84 6A                    .j
        jmp     entity_wipe_x                           ; A471 4C C4 F2                 L..

; ----------------------------------------------------------------------------
LA474:  dey                                     ; A474 88                       .
        dey                                     ; A475 88                       .
        dey                                     ; A476 88                       .
        dey                                     ; A477 88                       .
        bpl     LA457                           ; A478 10 DD                    ..
LA47A:  rts                                     ; A47A 60                       `

; ----------------------------------------------------------------------------
LA47B:  .byte   $02                             ; A47B  pod table: screen
LA47C:  .byte   $D0                             ; A47C  X
LA47D:  .byte   $B0,$00                         ; A47D  Y, pad
        .byte   $03,$20,$30,$00                 ; A47F
        .byte   $03,$20,$70,$00                 ; A483
        .byte   $03,$20,$B0,$00                 ; A487
        .byte   $03,$80,$70,$00                 ; A48B
        .byte   $03,$80,$B0,$00                 ; A48F
        .byte   $03,$E0,$30,$00                 ; A493
        .byte   $03,$E0,$70,$00                 ; A497
        .byte   $03,$E0,$B0,$00                 ; A49B
        .byte   $03,$80,$30,$00                 ; A49F
; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $B0 — rematch-won return orb. Falls to the floor; when
; the player touches it, marks this rematch room beaten (screen & 7 ->
; $6B bitmap), player param $0A, state $17 rematch-won, and wipes.
; =============================================================================
LA4A3:  ldy     #$23                            ; A4A3 A0 23                    .#
        jsr     entity_gravity_collide                           ; A4A5 20 B7 E7                  ..
        bcc     LA4CE                           ; A4A8 90 24                    .$
        lda     L0030                           ; A4AA A5 30                    .0
        cmp     #$03                            ; A4AC C9 03                    ..
        bcs     LA4CE                           ; A4AE B0 1E                    ..
        jsr     entity_player_collide                           ; A4B0 20 87 EF                  ..
        bcs     LA4CE                           ; A4B3 B0 19                    ..
        lda     $0348,x                         ; A4B5 BD 48 03                 .H.
        and     #$07                            ; A4B8 29 07                    ).
        tay                                     ; A4BA A8                       .
        lda     $F2B2,y                         ; A4BB B9 B2 F2                 ...
        ora     $6B                             ; A4BE 05 6B                    .k
        sta     $6B                             ; A4C0 85 6B                    .k
        lda     #$0A                            ; A4C2 A9 0A                    ..
        sta     $0468                           ; A4C4 8D 68 04                 .h.
        lda     #$17                            ; A4C7 A9 17                    ..
        sta     L0030                           ; A4C9 85 30                    .0
        jsr     entity_wipe_x                           ; A4CB 20 C4 F2                  ..
LA4CE:  rts                                     ; A4CE 60                       `

; ----------------------------------------------------------------------------
; =============================================================================
; BEHAVIOR type $44 — Wave Man stage water giant (spawn: bank $01 scr
; $24). IRQ-split background enemy (mode $44): waits for the palette
; cyclers $05F0-$05F2 to idle, does the $1E handshake, sets up the
; split ($7A/$7B/$9B/$99/$FD), CHR R0/R1 := $7C/$7E, fades in via
; LA64A ($10-step, 3 rows). Then drifts diagonally (xvel $00.40, yvel
; $01.00), reversing vertically every $50 frames and horizontally each
; $140-frame lap, firing an aimed type $4E shot from high positions
; (LA60E, Y < $59); camera tracks it ($FA=$A0-Y, $78=$C0-X), and a
; shifted probe (X-$20, Y-$08, shape 0) feeds weapon hits into the
; damage engine with flag $40 ($A5D8).
; =============================================================================
        lda     $05F0                           ; A4CF AD F0 05                 ...
LA4D2:  ora     $05F1                           ; A4D2 0D F1 05                 ...
        ora     $05F2                           ; A4D5 0D F2 05                 ...
        bne     LA4CE                           ; A4D8 D0 F4                    ..
        lda     #$80                            ; A4DA A9 80                    ..
        sta     $1E                             ; A4DC 85 1E                    ..
        sta     $55                             ; A4DE 85 55                    .U
        lda     #$44                            ; A4E0 A9 44                    .D
        sta     L0023                           ; A4E2 85 23                    .#
        lda     #$EE                            ; A4E4 A9 EE                    ..
        sta     $0588,x                         ; A4E6 9D 88 05                 ...
        lda     #$A4                            ; A4E9 A9 A4                    ..
        sta     $05A0,x                         ; A4EB 9D A0 05                 ...
        lda     $1E                             ; A4EE A5 1E                    ..
        bne     LA4CE                           ; A4F0 D0 DC                    ..
        sta     $78                             ; A4F2 85 78                    .x
        lda     #$22                            ; A4F4 A9 22                    ."
        sta     $7A                             ; A4F6 85 7A                    .z
        lda     #$40                            ; A4F8 A9 40                    .@
        sta     $7B                             ; A4FA 85 7B                    .{
        lda     #$8F                            ; A4FC A9 8F                    ..
        sta     $9B                             ; A4FE 85 9B                    ..
        lda     #$05                            ; A500 A9 05                    ..
        sta     $99                             ; A502 85 99                    ..
        lda     #$02                            ; A504 A9 02                    ..
        sta     $FD                             ; A506 85 FD                    ..
        lda     #$7C                            ; A508 A9 7C                    .|
        sta     $EA                             ; A50A 85 EA                    ..
        lda     #$7E                            ; A50C A9 7E                    .~
        sta     $EB                             ; A50E 85 EB                    ..
        lda     #$30                            ; A510 A9 30                    .0
        sta     $0480,x                         ; A512 9D 80 04                 ...
        lda     #$1F                            ; A515 A9 1F                    ..
        sta     $0588,x                         ; A517 9D 88 05                 ...
        lda     #$A5                            ; A51A A9 A5                    ..
        sta     $05A0,x                         ; A51C 9D A0 05                 ...
        lda     $0468,x                         ; A51F BD 68 04                 .h.
        bne     LA54C                           ; A522 D0 28                    .(
        ldy     #$0B                            ; A524 A0 0B                    ..
LA526:  lda     LA64A,y                         ; A526 B9 4A A6                 .J.
        sec                                     ; A529 38                       8
        sbc     $0480,x                         ; A52A FD 80 04                 ...
        bcs     LA531                           ; A52D B0 02                    ..
        lda     #$0F                            ; A52F A9 0F                    ..
LA531:  sta     $0600,y                         ; A531 99 00 06                 ...
        sta     $0620,y                         ; A534 99 20 06                 . .
        dey                                     ; A537 88                       .
        bpl     LA526                           ; A538 10 EC                    ..
        sty     $18                             ; A53A 84 18                    ..
        lda     #$08                            ; A53C A9 08                    ..
        sta     $0468,x                         ; A53E 9D 68 04                 .h.
        lda     $0480,x                         ; A541 BD 80 04                 ...
        sec                                     ; A544 38                       8
        sbc     #$10                            ; A545 E9 10                    ..
        sta     $0480,x                         ; A547 9D 80 04                 ...
        bcc     LA550                           ; A54A 90 04                    ..
LA54C:  dec     $0468,x                         ; A54C DE 68 04                 .h.
        rts                                     ; A54F 60                       `

; ----------------------------------------------------------------------------
LA550:  lda     #$00                            ; A550 A9 00                    ..
        sta     $03D8,x                         ; A552 9D D8 03                 ...
        lda     #$01                            ; A555 A9 01                    ..
        sta     $03F0,x                         ; A557 9D F0 03                 ...
        lda     #$40                            ; A55A A9 40                    .@
        sta     $03A8,x                         ; A55C 9D A8 03                 ...
        lda     #$00                            ; A55F A9 00                    ..
        sta     $03C0,x                         ; A561 9D C0 03                 ...
        lda     #$0A                            ; A564 A9 0A                    ..
        sta     $0420,x                         ; A566 9D 20 04                 . .
        lda     #$50                            ; A569 A9 50                    .P
        sta     $0468,x                         ; A56B 9D 68 04                 .h.
        lda     #$40                            ; A56E A9 40                    .@
        sta     $0480,x                         ; A570 9D 80 04                 ...
        lda     #$01                            ; A573 A9 01                    ..
        sta     $0498,x                         ; A575 9D 98 04                 ...
        lda     #$82                            ; A578 A9 82                    ..
        sta     $0588,x                         ; A57A 9D 88 05                 ...
        lda     #$A5                            ; A57D A9 A5                    ..
        sta     $05A0,x                         ; A57F 9D A0 05                 ...
        jsr     entity_facing_dispatch                           ; A582 20 65 EA                  e.
        jsr     entity_vert_dispatch_raw                           ; A585 20 86 EA                  ..
        dec     $0468,x                         ; A588 DE 68 04                 .h.
        bne     LA59D                           ; A58B D0 10                    ..
        jsr     LA60E                           ; A58D 20 0E A6                  ..
        lda     #$50                            ; A590 A9 50                    .P
        sta     $0468,x                         ; A592 9D 68 04                 .h.
        lda     $0420,x                         ; A595 BD 20 04                 . .
        eor     #$0C                            ; A598 49 0C                    I.
        sta     $0420,x                         ; A59A 9D 20 04                 . .
LA59D:  lda     $0480,x                         ; A59D BD 80 04                 ...
        sec                                     ; A5A0 38                       8
        sbc     #$01                            ; A5A1 E9 01                    ..
        sta     $0480,x                         ; A5A3 9D 80 04                 ...
        lda     $0498,x                         ; A5A6 BD 98 04                 ...
        sbc     #$00                            ; A5A9 E9 00                    ..
        sta     $0498,x                         ; A5AB 9D 98 04                 ...
        ora     $0480,x                         ; A5AE 1D 80 04                 ...
        bne     LA5C8                           ; A5B1 D0 15                    ..
        jsr     LA60E                           ; A5B3 20 0E A6                  ..
        lda     #$40                            ; A5B6 A9 40                    .@
        sta     $0480,x                         ; A5B8 9D 80 04                 ...
        lda     #$01                            ; A5BB A9 01                    ..
        sta     $0498,x                         ; A5BD 9D 98 04                 ...
        lda     $0420,x                         ; A5C0 BD 20 04                 . .
        eor     #$03                            ; A5C3 49 03                    I.
        sta     $0420,x                         ; A5C5 9D 20 04                 . .
LA5C8:  lda     #$A0                            ; A5C8 A9 A0                    ..
        sec                                     ; A5CA 38                       8
        sbc     $0378,x                         ; A5CB FD 78 03                 .x.
        sta     $FA                             ; A5CE 85 FA                    ..
        lda     #$C0                            ; A5D0 A9 C0                    ..
        sec                                     ; A5D2 38                       8
        sbc     $0330,x                         ; A5D3 FD 30 03                 .0.
        sta     $78                             ; A5D6 85 78                    .x
        lda     $0408,x                         ; A5D8 BD 08 04                 ...
        pha                                     ; A5DB 48                       H
        lda     $0330,x                         ; A5DC BD 30 03                 .0.
        pha                                     ; A5DF 48                       H
        sec                                     ; A5E0 38                       8
        sbc     #$20                            ; A5E1 E9 20                    . 
        sta     $0330,x                         ; A5E3 9D 30 03                 .0.
        lda     $0378,x                         ; A5E6 BD 78 03                 .x.
        pha                                     ; A5E9 48                       H
        sec                                     ; A5EA 38                       8
        sbc     #$08                            ; A5EB E9 08                    ..
        sta     $0378,x                         ; A5ED 9D 78 03                 .x.
        lda     #$00                            ; A5F0 A9 00                    ..
        sta     $0408,x                         ; A5F2 9D 08 04                 ...
        jsr     entity_hitbox_check                           ; A5F5 20 F8 EF                  ..
        pla                                     ; A5F8 68                       h
        sta     $0378,x                         ; A5F9 9D 78 03                 .x.
        pla                                     ; A5FC 68                       h
        sta     $0330,x                         ; A5FD 9D 30 03                 .0.
LA600:  pla                                     ; A600 68                       h
        sta     $0408,x                         ; A601 9D 08 04                 ...
        bcs     LA60D                           ; A604 B0 07                    ..
        lda     #$40                            ; A606 A9 40                    .@
        sta     L0000                           ; A608 85 00                    ..
        jmp     L809D                           ; A60A 4C 9D 80                 L..

; ----------------------------------------------------------------------------
LA60D:  rts                                     ; A60D 60                       `

; --- LA60E: water giant's aimed shot — type $4E, sub $B5, from (X-$38,
; Y+$28), 16-dir at the player, speed $28; only fired while high (Y < $59)
LA60E:  lda     $0378,x                         ; A60E BD 78 03                 .x.
        cmp     #$59                            ; A611 C9 59                    .Y
        bcs     LA648                           ; A613 B0 33                    .3
        jsr     find_free_slot_y                           ; A615 20 6F F1                  o.
        bcs     LA648                           ; A618 B0 2E                    ..
        lda     #$B5                            ; A61A A9 B5                    ..
        jsr     entity_init_pos                           ; A61C 20 A4 EA                  ..
        lda     $0378,x                         ; A61F BD 78 03                 .x.
        clc                                     ; A622 18                       .
        adc     #$28                            ; A623 69 28                    i(
        sta     $0378,y                         ; A625 99 78 03                 .x.
        lda     $0330,y                         ; A628 B9 30 03                 .0.
        sec                                     ; A62B 38                       8
        sbc     #$38                            ; A62C E9 38                    .8
        sta     $0330,y                         ; A62E 99 30 03                 .0.
        lda     #$4E                            ; A631 A9 4E                    .N
        sta     $0300,y                         ; A633 99 00 03                 ...
        lda     #$80                            ; A636 A9 80                    ..
        sta     $0408,y                         ; A638 99 08 04                 ...
        tya                                     ; A63B 98                       .
        tax                                     ; A63C AA                       .
        jsr     entity_distance_calc                           ; A63D 20 C2 EC                  ..
        tay                                     ; A640 A8                       .
        lda     #$28                            ; A641 A9 28                    .(
        jsr     entity_set_dir_velocity                           ; A643 20 70 F4                  p.
        ldx     $A6                             ; A646 A6 A6                    ..
LA648:  rts                                     ; A648 60                       `

; ----------------------------------------------------------------------------
; BEHAVIOR type $43 — inert (rts; unspawned companion slot of $44).
        rts                                     ; A649 60                       `

; ----------------------------------------------------------------------------
LA64A:  .byte   $0F,$20,$16,$06                 ; A64A  water giant palette
        .byte   $0F,$20,$23,$13                 ; A64E
        .byte   $0F,$20,$2B,$1B                 ; A652
; $A656-$A7FF: data, unreferenced in-bank (no reader found; likely BG strip data
; for the type $44 water giant's split screen)
        .byte   $FF,$15,$DF,$D7,$FF,$FD,$FF,$D5 ; A656
        .byte   $FF,$5D,$FF,$D5,$FF,$7F,$FF,$D7 ; A65E
        .byte   $FF,$F7,$FF,$D5,$FF,$7D,$FD,$57 ; A666
        .byte   $FF,$FD,$FF,$55,$FF,$6D,$FF,$7D ; A66E
        .byte   $FF,$75,$F7,$55,$FF,$F5,$EF,$F7 ; A676
        .byte   $FF,$7D,$FF,$75,$FF,$DD,$BF,$5D ; A67E
        .byte   $FE,$7D,$F6,$D7,$FF,$5F,$FF,$F5 ; A686
        .byte   $FF,$57,$FF,$55,$EB,$D7,$FF,$7F ; A68E
        .byte   $BF,$55,$FF,$FD,$FF,$5D,$FF,$D5 ; A696
        .byte   $FF,$FD,$FF,$5F,$FF,$D4,$FF,$FD ; A69E
        .byte   $FF,$77,$DF,$7D,$FF,$FD,$FF,$D5 ; A6A6
        .byte   $FF,$5D,$FF,$DF,$FF,$5D,$FF,$77 ; A6AE
        .byte   $FF,$F5,$FF,$55,$6F,$FD,$FF,$F5 ; A6B6
        .byte   $FF,$DF,$FF,$5F,$F7,$DD,$FF,$55 ; A6BE
        .byte   $FF,$F5,$FF,$5D,$FF,$75,$FF,$5D ; A6C6
        .byte   $FB,$F7,$FF,$D5,$EF,$5D,$FE,$FD ; A6CE
        .byte   $FF,$DD,$FF,$7D,$7F,$5F,$FF,$D5 ; A6D6
        .byte   $FF,$FD,$FD,$DD,$FF,$1F,$FF,$77 ; A6DE
        .byte   $FF,$75,$FB,$65,$FF,$F5,$FF,$26 ; A6E6
        .byte   $FF,$55,$FF,$75,$FF,$5F,$FF,$74 ; A6EE
        .byte   $FF,$D7,$FF,$DD,$FF,$5D,$FB,$D5 ; A6F6
        .byte   $FF,$F5,$FC,$5D,$FF,$55,$DF,$DD ; A6FE
        .byte   $FB,$F5,$FF,$55,$FF,$BF,$F7,$CD ; A706
        .byte   $FC,$FF,$FF,$75,$BF,$DD,$FF,$FD ; A70E
        .byte   $DF,$7D,$FF,$55,$FF,$5D,$FD,$D5 ; A716
        .byte   $FF,$D5,$FB,$EF,$FB,$5F,$DF,$75 ; A71E
        .byte   $FF,$F5,$FF,$D7,$FB,$55,$FD,$DF ; A726
        .byte   $FF,$74,$FF,$75,$FF,$DF,$FF,$D7 ; A72E
        .byte   $FF,$D5,$FF,$7D,$FF,$F7,$DF,$75 ; A736
        .byte   $FF,$D7,$FF,$D5,$FF,$55,$FF,$DF ; A73E
        .byte   $FF,$7D,$FF,$FD,$FF,$7D,$FF,$DF ; A746
        .byte   $FF,$77,$FF,$FD,$FE,$FF,$7F,$75 ; A74E
        .byte   $7F,$F7,$FF,$5D,$EF,$55,$FF,$D7 ; A756
        .byte   $FF,$F1,$FF,$7F,$FF,$7D,$FF,$7D ; A75E
        .byte   $FF,$7D,$FF,$75,$FF,$F5,$FF,$75 ; A766
        .byte   $FF,$7F,$FF,$DD,$DF,$57,$FB,$55 ; A76E
        .byte   $FE,$77,$FF,$D5,$FF,$B7,$F7,$55 ; A776
        .byte   $FF,$77,$FF,$75,$FB,$55,$FF,$D7 ; A77E
        .byte   $FB,$5D,$FF,$FF,$FF,$DF,$FF,$DF ; A786
        .byte   $FF,$D5,$FF,$F7,$9F,$DD,$FF,$FF ; A78E
        .byte   $FF,$DD,$FE,$DF,$FF,$DF,$FF,$FF ; A796
        .byte   $F7,$7D,$FF,$75,$FE,$75,$FF,$5F ; A79E
        .byte   $FF,$95,$FF,$DD,$7F,$57,$FF,$55 ; A7A6
        .byte   $FF,$5F,$EF,$55,$FF,$DD,$FF,$FF ; A7AE
        .byte   $FB,$7D,$FF,$FF,$FF,$D7,$FF,$DD ; A7B6
        .byte   $FF,$D7,$FF,$F5,$FF,$FD,$FF,$D7 ; A7BE
        .byte   $FF,$45,$FF,$DD,$FF,$D7,$FF,$D5 ; A7C6
        .byte   $FF,$F5,$EF,$7D,$FF,$D7,$FF,$D5 ; A7CE
        .byte   $FF,$DD,$FF,$5D,$FF,$DF,$DD,$57 ; A7D6
        .byte   $FF,$FF,$FF,$F7,$FF,$FD,$FF,$57 ; A7DE
        .byte   $FF,$57,$FF,$D5,$FF,$77,$FF,$5D ; A7E6
        .byte   $FF,$DD,$FF,$67,$FF,$75,$FF,$7D ; A7EE
        .byte   $FF,$DF,$BF,$7D,$FF,$F5,$EF,$75 ; A7F6
        .byte   $FF,$75 ; A7FE
; --- $A800: DAMAGE TABLE, weapon $3 (Crystal Eye) ---
; $A800[ent_type] via damage_engine $1C:809D; low 7 bits = damage,
; bit 7 = special handling; $00 = ricochet. Types $00-$CF.
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A800  types $00-$0F
        .byte   $02,$02,$01,$01,$01,$01,$01,$02,$02,$01,$01,$02,$01,$01,$00,$00 ; A810  types $10-$1F
        .byte   $02,$02,$00,$00,$00,$01,$00,$00,$02,$01,$02,$01,$00,$00,$00,$00 ; A820  types $20-$2F
        .byte   $00,$02,$01,$02,$01,$00,$02,$00,$00,$01,$02,$01,$00,$00,$02,$00 ; A830  types $30-$3F
        .byte   $03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04 ; A840  types $40-$4F
        .byte   $01,$00,$01,$01,$01,$00,$01,$00,$00,$02,$01,$00,$02,$02,$00,$00 ; A850  types $50-$5F
        .byte   $01,$00,$01,$01,$01,$01,$02,$01,$01,$01,$00,$01,$00,$00,$01,$00 ; A860  types $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01,$01,$00,$00,$00 ; A870  types $70-$7F
        .byte   $00,$01,$00,$01,$00,$00,$01,$00,$00,$03,$00,$00,$00,$01,$00,$00 ; A880  types $80-$8F
        .byte   $00,$02,$00,$01,$00,$00,$01,$00,$01,$00,$00,$00,$01,$00,$01,$00 ; A890  types $90-$9F
        .byte   $01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00 ; A8A0  types $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$02,$02,$00 ; A8B0  types $B0-$BF
        .byte   $00,$00,$00,$00,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8C0  types $C0-$CF
; --- $A8D0: remainder (beyond type $CF) ---
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8D0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8E0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A8F0

; =============================================================================
; GYRO MAN STAGE DATA — format: DATA_REFERENCE.md section 11
; =============================================================================
; --- $A900: screen -> layout index ---
        .byte   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0B,$0C,$0D,$0E,$0F ; A900  screens $00-$0F
        .byte   $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$16,$00 ; A910  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$14,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A920  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A930  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A940  screens $40-$4F
; --- $A950: section list: start screen (bits 0-4) | flags (bits 5-7) ---
        .byte   $20,$20,$22,$80,$A3,$80,$A2,$80,$A3,$20,$80,$A0,$22,$60,$20,$20 ; A950
        .byte   $00,$00,$00,$00,$00,$00,$00,$00 ; A960
; --- $A968: per-section attributes (bit 7 = vertical-scroll room) ---
        .byte   $18,$18,$1A,$20,$19,$1A,$38,$25,$1B,$00,$00,$00,$1C,$09,$80,$B6 ; A968
        .byte   $00,$00,$00,$02,$00,$00,$00,$0A ; A978
; --- $A980: BG CHR banks (MMC3 R0/R1 <- $A980/$A981; rest unreferenced) ---
        .byte   $8C,$8E,$00,$00,$00,$00,$00,$00 ; A980
; --- $A988: palette sets, 20 bytes each [16 BG palette + 4 palette-cycle
; seeds]: set n at +20n; set 0 is loaded by stage_load, later sets are
; switched per section by the bank $00 environment service
; ($A968 attr bits 0-5 -> $00:809E records, ctl bit 7) ---
        .byte   $21,$30,$28,$0F,$21,$30,$2B,$0F,$21,$30,$27,$0F,$21,$30,$3C,$2C ; A988
        .byte   $00,$00,$00,$81,$00,$00,$00,$00 ; A998
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9A0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9B0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9C0
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9D0
; --- $A9E0: screen links [screen, Y band, dest screen, dest section], bit 7 ends ---
        .byte   $FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; A9E0  terminator / filler
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$40,$00,$10,$00 ; A9F0  
        .byte   $00                             ; A9FF  -1 base for the spawn arrays
; --- $AA00: spawn screens (ascending) ---
        .byte   $00,$01,$01,$02,$03,$03,$03,$03,$04,$04,$04,$04,$05,$05,$05,$06 ; AA00  entries $00-$0F
        .byte   $06,$07,$07,$08,$08,$08,$09,$09,$09,$09,$0A,$0A,$0A,$0A,$0A,$0B ; AA10  entries $10-$1F
        .byte   $0D,$0D,$0D,$0D,$0D,$0D,$0E,$10,$10,$10,$11,$11,$11,$12,$12,$13 ; AA20  entries $20-$2F
        .byte   $16,$16,$17,$17,$18,$18,$18,$19,$1B,$FF,$00,$00,$00,$00,$00,$00 ; AA30  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$10,$00,$00 ; AA40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$20,$00,$00 ; AA60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AA70  entries $70-$7F
; --- $AA80: spawn X px ---
        .byte   $00,$80,$80,$D0,$4F,$70,$E0,$F0,$30,$A0,$B0,$F0,$31,$70,$A0,$E8 ; AA80  entries $00-$0F
        .byte   $F0,$60,$A0,$31,$D0,$F0,$08,$10,$40,$E0,$00,$20,$40,$41,$F0,$00 ; AA90  entries $10-$1F
        .byte   $20,$40,$70,$80,$D0,$E0,$20,$18,$28,$38,$60,$D0,$D8,$48,$58,$80 ; AAA0  entries $20-$2F
        .byte   $78,$D0,$28,$B0,$50,$90,$D8,$D0,$D8,$FF,$00,$00,$00,$00,$00,$00 ; AAB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AAD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$20,$00 ; AAE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$00,$00,$00,$80,$00 ; AAF0  entries $70-$7F
; --- $AB00: spawn Y px ---
        .byte   $00,$80,$80,$A0,$38,$80,$38,$A0,$80,$50,$30,$50,$86,$A6,$58,$48 ; AB00  entries $00-$0F
        .byte   $18,$48,$70,$B8,$C8,$18,$18,$B8,$78,$20,$00,$B0,$66,$20,$50,$00 ; AB10  entries $10-$1F
        .byte   $64,$20,$B0,$24,$A4,$60,$84,$58,$68,$78,$18,$28,$D7,$28,$38,$80 ; AB20  entries $20-$2F
        .byte   $50,$58,$50,$80,$60,$40,$90,$B4,$00,$FF,$00,$00,$00,$00,$00,$00 ; AB30  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB40  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB50  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB60  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AB70  entries $70-$7F
; --- $AB80: spawn codes (< $C0 enemy id, >= $C0 palette/CHR command) ---
        .byte   $D0,$48,$D1,$14,$36,$14,$36,$14,$14,$36,$36,$14,$2F,$2E,$86,$61 ; AB80  entries $00-$0F
        .byte   $61,$84,$39,$83,$20,$61,$61,$20,$23,$61,$D1,$36,$2D,$36,$36,$D0 ; AB90  entries $10-$1F
        .byte   $1D,$61,$61,$1D,$1D,$61,$0C,$01,$01,$01,$01,$01,$8B,$01,$01,$49 ; ABA0  entries $20-$2F
        .byte   $33,$33,$33,$33,$33,$33,$33,$1D,$64,$FF,$00,$00,$00,$00,$00,$00 ; ABB0  entries $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$00,$00,$00 ; ABC0  entries $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABD0  entries $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABE0  entries $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ABF0  entries $70-$7F
; --- $AC00: per-screen spawn-list start index ---
        .byte   $00,$01,$03,$04,$08,$0C,$0F,$11,$13,$16,$1A,$1F,$20,$20,$26,$27 ; AC00  screens $00-$0F
        .byte   $27,$2A,$2D,$2F,$30,$30,$30,$32,$34,$37,$38,$38,$00,$00,$00,$10 ; AC10  screens $10-$1F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC20  screens $20-$2F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC30  screens $30-$3F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC40  screens $40-$4F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC50  screens $50-$5F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC60  screens $60-$6F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC70  screens $70-$7F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC80  screens $80-$8F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AC90  screens $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACA0  screens $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACB0  screens $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACC0  screens $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ACD0  screens $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$40,$00,$00,$00,$00,$00 ; ACE0  screens $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$08,$00 ; ACF0  screens $F0-$FF
; --- $AD00: metatile top-left tile ids ---
        .byte   $00,$01,$03,$05,$04,$20,$40,$60,$22,$22,$22,$63,$46,$4A,$2C,$47 ; AD00  metatiles $00-$0F
        .byte   $42,$43,$24,$64,$28,$2A,$68,$38,$62,$74,$34,$26,$0D,$2B,$48,$38 ; AD10  metatiles $10-$1F
        .byte   $07,$09,$0B,$C4,$66,$6A,$2D,$67,$C6,$A7,$C8,$84,$A8,$A8,$A8,$A9 ; AD20  metatiles $20-$2F
        .byte   $A9,$86,$88,$89,$8B,$00,$8D,$C0,$00,$E1,$E3,$E5,$E7,$E9,$C2,$D0 ; AD30  metatiles $30-$3F
        .byte   $D2,$00,$CE,$46,$47,$46,$4B,$28,$69,$D1,$84,$BC,$D0,$D2,$68,$10 ; AD40  metatiles $40-$4F
        .byte   $00,$00,$4C,$0E,$00,$10,$4A,$00,$00,$6C,$7C,$10,$2E,$0F,$10,$DE ; AD50  metatiles $50-$5F
        .byte   $00,$5D,$10,$6D,$10,$10,$1F,$00,$00,$4E,$10,$AF,$9E,$10,$10,$AF ; AD60  metatiles $60-$6F
        .byte   $00,$6F,$4E,$10,$10,$AF,$9E,$1E,$00,$07,$00,$6F,$9E,$EC,$EE,$0B ; AD70  metatiles $70-$7F
        .byte   $EA,$CC,$00,$00,$00,$00,$00,$00,$CE,$46,$47,$28,$38,$66,$67,$0D ; AD80  metatiles $80-$8F
        .byte   $38,$10,$BC,$00,$80,$82,$00,$00,$10,$10,$00,$00,$A0,$A2,$00,$00 ; AD90  metatiles $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADA0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADB0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADC0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADD0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; ADF0  metatiles $F0-$FF
; --- $AE00: metatile bottom-left tile ids ---
        .byte   $00,$02,$04,$00,$05,$21,$41,$61,$23,$23,$23,$06,$47,$4B,$4B,$46 ; AE00  metatiles $00-$0F
        .byte   $43,$AC,$25,$65,$29,$2A,$69,$39,$63,$75,$35,$27,$29,$D9,$49,$1D ; AE10  metatiles $10-$1F
        .byte   $08,$0A,$0C,$C5,$67,$6B,$6B,$66,$C7,$00,$C8,$85,$85,$A5,$A8,$A8 ; AE20  metatiles $20-$2F
        .byte   $A4,$87,$00,$8A,$8C,$00,$A6,$C1,$E0,$E2,$E4,$E6,$E8,$00,$C3,$D1 ; AE30  metatiles $30-$3F
        .byte   $D3,$00,$CF,$47,$46,$4A,$46,$68,$39,$D2,$A4,$BD,$D1,$D3,$69,$10 ; AE40  metatiles $40-$4F
        .byte   $00,$00,$4D,$0F,$00,$C9,$4B,$00,$4C,$6D,$10,$10,$2F,$00,$4F,$DF ; AE50  metatiles $50-$5F
        .byte   $4C,$7C,$10,$7C,$10,$1E,$00,$00,$6E,$4F,$AE,$BF,$9F,$3F,$AE,$9F ; AE60  metatiles $60-$6F
        .byte   $6E,$7E,$4F,$10,$AE,$BF,$9F,$1F,$4C,$08,$6E,$7E,$9F,$ED,$EF,$0C ; AE70  metatiles $70-$7F
        .byte   $EB,$CD,$00,$00,$00,$00,$00,$00,$CF,$47,$46,$29,$39,$67,$66,$29 ; AE80  metatiles $80-$8F
        .byte   $1D,$C9,$BD,$00,$81,$83,$00,$00,$10,$10,$00,$00,$A1,$A3,$00,$00 ; AE90  metatiles $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEA0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEB0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEC0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AED0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AEF0  metatiles $F0-$FF
; --- $AF00: metatile top-right tile ids ---
        .byte   $00,$11,$13,$15,$14,$30,$50,$70,$32,$AA,$24,$54,$56,$5A,$3C,$57 ; AF00  metatiles $00-$0F
        .byte   $52,$43,$24,$53,$0D,$3A,$78,$38,$72,$54,$44,$36,$0D,$3B,$58,$38 ; AF10  metatiles $10-$1F
        .byte   $17,$19,$1B,$D4,$76,$7A,$3D,$77,$D6,$00,$C8,$94,$B8,$B8,$B8,$B9 ; AF20  metatiles $20-$2F
        .byte   $B9,$96,$98,$99,$9B,$AD,$9D,$D0,$00,$F1,$F3,$F5,$F7,$F9,$D2,$D0 ; AF30  metatiles $30-$3F
        .byte   $D2,$00,$CE,$76,$77,$56,$5B,$0D,$79,$D1,$94,$BA,$D0,$BB,$C9,$10 ; AF40  metatiles $40-$4F
        .byte   $00,$00,$5D,$10,$1F,$10,$DA,$00,$5C,$10,$10,$10,$10,$1E,$10,$DE ; AF50  metatiles $50-$5F
        .byte   $4C,$10,$10,$10,$10,$10,$2E,$0F,$00,$5E,$8E,$00,$00,$8E,$10,$00 ; AF60  metatiles $60-$6F
        .byte   $00,$00,$5E,$10,$8E,$00,$00,$10,$00,$17,$00,$00,$00,$FC,$FE,$1B ; AF70  metatiles $70-$7F
        .byte   $FA,$DC,$00,$00,$00,$00,$00,$00,$CE,$56,$57,$0D,$38,$76,$77,$0D ; AF80  metatiles $80-$8F
        .byte   $38,$10,$BC,$00,$90,$92,$00,$00,$B7,$10,$00,$00,$B0,$B2,$00,$00 ; AF90  metatiles $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFA0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFB0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFC0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFD0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFE0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; AFF0  metatiles $F0-$FF
; --- $B000: metatile bottom-right tile ids ---
        .byte   $00,$12,$14,$00,$15,$31,$51,$71,$33,$AB,$25,$16,$57,$5B,$5B,$56 ; B000  metatiles $00-$0F
        .byte   $43,$AC,$25,$73,$29,$D8,$79,$1D,$73,$55,$45,$37,$29,$3B,$59,$1D ; B010  metatiles $10-$1F
        .byte   $18,$1A,$1C,$D5,$77,$7B,$7B,$76,$D7,$00,$C8,$95,$95,$B5,$B8,$B8 ; B020  metatiles $20-$2F
        .byte   $B4,$97,$AD,$9A,$9C,$AD,$B6,$D1,$F0,$F2,$F4,$F6,$F8,$00,$D3,$D1 ; B030  metatiles $30-$3F
        .byte   $D3,$00,$CF,$77,$76,$5A,$56,$78,$1D,$D2,$B4,$BB,$BA,$D3,$79,$10 ; B040  metatiles $40-$4F
        .byte   $00,$5C,$10,$1E,$00,$10,$5B,$00,$5D,$10,$10,$10,$10,$1F,$10,$DF ; B050  metatiles $50-$5F
        .byte   $5D,$10,$10,$10,$6D,$10,$2F,$00,$00,$5F,$8F,$00,$00,$8F,$8F,$00 ; B060  metatiles $60-$6F
        .byte   $00,$00,$5F,$10,$8F,$00,$00,$1E,$7D,$18,$00,$00,$00,$FD,$FF,$1C ; B070  metatiles $70-$7F
        .byte   $FB,$DD,$00,$00,$00,$00,$00,$00,$CF,$57,$56,$29,$1D,$77,$76,$29 ; B080  metatiles $80-$8F
        .byte   $1D,$10,$BD,$00,$91,$93,$00,$00,$10,$10,$00,$00,$B1,$B3,$00,$00 ; B090  metatiles $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0A0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0B0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0C0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0D0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0E0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B0F0  metatiles $F0-$FF
; --- $B100: metatile attributes: palette (bits 0-1) | collision (high nibble: ---
; $20 solid, $40 ladder, >= $D0 spikes; see DATA_REFERENCE section 11)
        .byte   $00,$00,$00,$00,$00,$12,$12,$12,$12,$12,$12,$12,$12,$11,$10,$12 ; B100  metatiles $00-$0F
        .byte   $12,$12,$12,$12,$12,$10,$11,$12,$12,$12,$12,$31,$12,$10,$11,$12 ; B110  metatiles $10-$1F
        .byte   $11,$11,$11,$11,$12,$11,$10,$12,$F0,$00,$00,$11,$11,$11,$11,$11 ; B120  metatiles $20-$2F
        .byte   $11,$01,$11,$10,$10,$10,$01,$10,$01,$11,$11,$11,$11,$01,$10,$10 ; B130  metatiles $30-$3F
        .byte   $10,$01,$20,$12,$12,$10,$10,$10,$10,$10,$11,$10,$10,$10,$10,$63 ; B140  metatiles $40-$4F
        .byte   $01,$63,$63,$63,$63,$10,$10,$00,$63,$63,$63,$63,$63,$63,$63,$00 ; B150  metatiles $50-$5F
        .byte   $63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63 ; B160  metatiles $60-$6F
        .byte   $63,$63,$63,$63,$63,$63,$63,$63,$63,$12,$63,$63,$63,$12,$12,$12 ; B170  metatiles $70-$7F
        .byte   $12,$12,$00,$00,$00,$00,$00,$00,$40,$10,$10,$10,$10,$10,$10,$10 ; B180  metatiles $80-$8F
        .byte   $10,$10,$10,$00,$10,$10,$10,$10,$12,$10,$00,$00,$10,$10,$00,$00 ; B190  metatiles $90-$9F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1A0  metatiles $A0-$AF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1B0  metatiles $B0-$BF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1C0  metatiles $C0-$CF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1D0  metatiles $D0-$DF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1E0  metatiles $E0-$EF
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B1F0  metatiles $F0-$FF
; --- $B200: 32px block defs: 4 metatile ids [TL,BL,TR,BR] per block ---
        .byte   $4F,$4F,$4F,$4F,$4F,$4F,$4F,$6E,$6E,$6F,$6F,$00,$4F,$4F,$74,$75 ; B200  blocks $00-$03
        .byte   $4F,$4F,$72,$4F,$4F,$4F,$4F,$5E,$4F,$6A,$74,$7C,$6B,$76,$00,$00 ; B210  blocks $04-$07
        .byte   $00,$00,$00,$00,$7C,$00,$00,$00,$70,$71,$00,$00,$72,$4F,$68,$72 ; B220  blocks $08-$0B
        .byte   $4F,$4F,$73,$74,$4F,$6E,$75,$76,$76,$00,$00,$00,$00,$7A,$00,$00 ; B230  blocks $0C-$0F
        .byte   $7B,$7C,$00,$00,$01,$02,$00,$00,$03,$00,$00,$00,$00,$00,$01,$04 ; B240  blocks $10-$13
        .byte   $52,$53,$5A,$5B,$54,$00,$5C,$5D,$01,$04,$00,$00,$99,$99,$99,$99 ; B250  blocks $14-$17
        .byte   $56,$0D,$55,$15,$0E,$0D,$94,$95,$0E,$0E,$15,$15,$0D,$0D,$15,$15 ; B260  blocks $18-$1B
        .byte   $0D,$0F,$15,$17,$4F,$55,$4F,$4F,$9C,$9D,$16,$1E,$1D,$1D,$26,$26 ; B270  blocks $1C-$1F
        .byte   $1D,$1D,$26,$25,$1D,$1F,$26,$27,$2A,$00,$2A,$00,$00,$2A,$00,$2A ; B280  blocks $20-$23
        .byte   $05,$08,$06,$10,$09,$0A,$11,$12,$08,$09,$10,$11,$0A,$08,$12,$10 ; B290  blocks $24-$27
        .byte   $09,$05,$11,$06,$07,$18,$00,$00,$19,$1A,$00,$00,$13,$19,$00,$00 ; B2A0  blocks $28-$2B
        .byte   $1A,$13,$00,$00,$0B,$07,$00,$00,$00,$00,$00,$01,$00,$00,$02,$03 ; B2B0  blocks $2C-$2F
        .byte   $00,$00,$2B,$2C,$00,$00,$2D,$2E,$00,$00,$2F,$30,$89,$0D,$8B,$15 ; B2C0  blocks $30-$33
        .byte   $0E,$0D,$15,$15,$0D,$8A,$15,$8C,$31,$32,$38,$39,$33,$34,$3A,$3B ; B2D0  blocks $34-$37
        .byte   $35,$36,$3C,$3D,$8F,$1D,$8D,$25,$1D,$90,$26,$8E,$37,$3E,$3F,$40 ; B2E0  blocks $38-$3B
        .byte   $00,$70,$00,$00,$71,$72,$00,$7A,$4F,$4F,$72,$73,$7A,$7B,$00,$00 ; B2F0  blocks $3C-$3F
        .byte   $00,$31,$00,$38,$32,$33,$39,$3A,$34,$35,$3B,$3C,$36,$00,$3D,$00 ; B300  blocks $40-$43
        .byte   $00,$37,$00,$3F,$3E,$00,$40,$00,$00,$00,$51,$52,$00,$00,$53,$54 ; B310  blocks $44-$47
        .byte   $00,$60,$58,$5A,$53,$3F,$4F,$5C,$40,$58,$40,$4F,$59,$5A,$4F,$4F ; B320  blocks $48-$4B
        .byte   $5B,$5C,$4F,$4F,$5D,$00,$65,$66,$00,$58,$60,$61,$00,$42,$00,$42 ; B330  blocks $4C-$4F
        .byte   $2B,$2C,$00,$31,$2D,$2E,$32,$33,$00,$38,$00,$00,$39,$3A,$00,$37 ; B340  blocks $50-$53
        .byte   $51,$52,$59,$5A,$5A,$5A,$4F,$4F,$42,$00,$42,$00,$00,$58,$78,$61 ; B350  blocks $54-$57
        .byte   $61,$4F,$4F,$4F,$00,$88,$00,$42,$20,$21,$00,$00,$22,$00,$00,$00 ; B360  blocks $58-$5B
        .byte   $68,$69,$00,$68,$4F,$4F,$69,$4F,$01,$03,$00,$00,$21,$22,$00,$00 ; B370  blocks $5C-$5F
        .byte   $00,$20,$00,$00,$21,$21,$00,$00,$00,$00,$66,$67,$00,$79,$00,$00 ; B380  blocks $60-$63
        .byte   $7D,$7E,$80,$81,$7F,$00,$00,$00,$00,$00,$20,$21,$00,$00,$22,$88 ; B390  blocks $64-$67
        .byte   $4F,$77,$4F,$5B,$4F,$6D,$6B,$76,$67,$00,$77,$54,$5D,$00,$6D,$00 ; B3A0  blocks $68-$6B
        .byte   $6A,$6B,$7C,$00,$00,$00,$88,$20,$00,$00,$21,$21,$20,$22,$21,$22 ; B3B0  blocks $6C-$6F
        .byte   $6F,$00,$00,$00,$68,$69,$00,$7A,$4F,$74,$7B,$7C,$00,$7A,$20,$21 ; B3C0  blocks $70-$73
        .byte   $7B,$7C,$21,$22,$0C,$0D,$14,$15,$1C,$1D,$1C,$15,$1D,$1D,$15,$15 ; B3D0  blocks $74-$77
        .byte   $1D,$27,$15,$15,$1C,$1D,$24,$25,$1D,$1D,$25,$26,$4F,$4F,$4F,$74 ; B3E0  blocks $78-$7B
        .byte   $6E,$6F,$7C,$00,$4F,$4F,$71,$72,$4F,$4F,$73,$4F,$75,$76,$00,$00 ; B3F0  blocks $7C-$7F
        .byte   $00,$68,$00,$00,$69,$4F,$7A,$7B,$74,$75,$7C,$00,$0C,$0F,$24,$27 ; B400  blocks $80-$83
        .byte   $0C,$0D,$24,$1E,$0E,$0D,$16,$1E,$0F,$00,$27,$00,$0C,$0F,$24,$17 ; B410  blocks $84-$87
        .byte   $0D,$0E,$15,$15,$0D,$1F,$15,$1F,$00,$51,$58,$59,$1D,$1F,$25,$27 ; B420  blocks $88-$8B
        .byte   $5A,$4F,$4F,$4F,$42,$00,$20,$21,$00,$42,$00,$20,$00,$00,$21,$22 ; B430  blocks $8C-$8F
        .byte   $4F,$65,$4F,$4F,$53,$54,$5B,$5C,$88,$00,$42,$00,$4F,$4F,$4F,$73 ; B440  blocks $90-$93
        .byte   $00,$00,$0C,$0D,$00,$00,$0E,$0D,$14,$15,$24,$1D,$88,$0C,$42,$14 ; B450  blocks $94-$97
        .byte   $0D,$0E,$16,$1E,$14,$15,$1C,$1D,$94,$95,$9C,$9D,$15,$15,$1D,$1D ; B460  blocks $98-$9B
        .byte   $42,$24,$42,$00,$25,$26,$00,$00,$24,$25,$00,$00,$26,$25,$00,$00 ; B470  blocks $9C-$9F
        .byte   $26,$26,$00,$00,$00,$00,$43,$1E,$43,$1E,$00,$00,$44,$00,$00,$00 ; B480  blocks $A0-$A3
        .byte   $00,$00,$22,$1E,$00,$00,$16,$1E,$00,$00,$0E,$0F,$15,$17,$1D,$27 ; B490  blocks $A4-$A7
        .byte   $00,$00,$0E,$0E,$00,$00,$0D,$0E,$25,$25,$00,$00,$00,$00,$16,$44 ; B4A0  blocks $A8-$AB
        .byte   $42,$00,$0E,$0F,$15,$17,$1D,$1F,$25,$27,$00,$00,$03,$42,$00,$42 ; B4B0  blocks $AC-$AF
        .byte   $00,$42,$00,$00,$1D,$27,$16,$1E,$0D,$0F,$16,$17,$26,$27,$00,$00 ; B4C0  blocks $B0-$B3
        .byte   $0C,$0D,$14,$1E,$1B,$1B,$00,$00,$00,$00,$00,$58,$00,$00,$5D,$00 ; B4D0  blocks $B4-$B7
        .byte   $00,$4A,$00,$92,$00,$4B,$00,$92,$00,$1B,$00,$00,$00,$00,$20,$23 ; B4E0  blocks $B8-$BB
        .byte   $00,$00,$23,$23,$00,$2A,$22,$2A,$00,$28,$00,$29,$28,$28,$29,$29 ; B4F0  blocks $BC-$BF
        .byte   $28,$2A,$29,$2A,$2A,$20,$2A,$28,$23,$23,$28,$28,$2A,$29,$2A,$00 ; B500  blocks $C0-$C3
        .byte   $29,$29,$00,$00,$00,$29,$00,$00,$29,$2A,$00,$2A,$22,$2A,$28,$2A ; B510  blocks $C4-$C7
        .byte   $00,$00,$00,$20,$00,$00,$23,$22,$28,$00,$29,$00,$00,$00,$00,$43 ; B520  blocks $C8-$CB
        .byte   $00,$43,$16,$1E,$0F,$2A,$27,$2A,$23,$21,$28,$20,$21,$21,$23,$23 ; B530  blocks $CC-$CF
        .byte   $22,$2A,$22,$2A,$29,$28,$00,$29,$4A,$00,$92,$00,$43,$0D,$14,$15 ; B540  blocks $D0-$D3
        .byte   $4B,$00,$92,$00,$00,$00,$43,$16,$00,$00,$1E,$16,$43,$0D,$1E,$16 ; B550  blocks $D4-$D7
        .byte   $00,$0C,$00,$14,$00,$24,$00,$00,$0C,$0D,$14,$16,$0D,$0F,$1E,$17 ; B560  blocks $D8-$DB
        .byte   $0E,$0D,$1E,$16,$0E,$1F,$1E,$27,$0D,$0E,$1E,$16,$9C,$9D,$25,$26 ; B570  blocks $DC-$DF
        .byte   $16,$1E,$26,$25,$16,$1E,$25,$26,$16,$1E,$25,$25,$16,$1F,$26,$27 ; B580  blocks $E0-$E3
        .byte   $1C,$15,$1C,$1D,$0D,$0D,$16,$1E,$0E,$0F,$16,$27,$1C,$16,$24,$25 ; B590  blocks $E4-$E7
        .byte   $1E,$16,$26,$25,$15,$0F,$1D,$27,$0C,$15,$24,$1D,$0C,$0E,$1C,$15 ; B5A0  blocks $E8-$EB
        .byte   $1D,$1F,$16,$1F,$24,$1D,$00,$00,$1D,$1D,$00,$00,$1D,$1D,$00,$5F ; B5B0  blocks $EC-$EF
        .byte   $15,$1F,$1D,$27,$00,$5F,$00,$5F,$1D,$1D,$16,$1E,$0F,$00,$17,$00 ; B5C0  blocks $F0-$F3
        .byte   $1C,$15,$24,$1D,$1F,$00,$27,$52,$1F,$99,$1F,$99,$1F,$4F,$1F,$4F ; B5D0  blocks $F4-$F7
        .byte   $4F,$99,$4F,$99,$1F,$4F,$1F,$72,$1F,$7A,$1F,$00,$4F,$99,$75,$98 ; B5E0  blocks $F8-$FB
        .byte   $27,$00,$00,$00,$00,$1C,$00,$1C,$00,$1C,$00,$24,$1D,$1D,$16,$1E ; B5F0  blocks $FC-$FF
; --- $B600: screen layouts: 64 block ids (8x8) each; ptr = $B600 + layout*64 ---
; layout $00
        .byte   $00,$00,$00,$00,$00,$00,$01,$02,$03,$04,$00,$05,$00,$06,$07,$08 ; B600
        .byte   $09,$0A,$0B,$0C,$0D,$0E,$08,$08,$08,$08,$0F,$10,$08,$08,$11,$12 ; B610
        .byte   $08,$08,$08,$13,$08,$08,$08,$08,$14,$15,$08,$08,$08,$16,$08,$08 ; B620
        .byte   $17,$17,$18,$19,$1A,$1B,$19,$1C,$17,$17,$1D,$1E,$1F,$20,$1E,$21 ; B630
; layout $01
        .byte   $22,$08,$08,$08,$08,$08,$16,$23,$22,$11,$12,$08,$08,$08,$08,$23 ; B640
        .byte   $22,$08,$08,$16,$08,$08,$08,$23,$22,$08,$08,$08,$08,$08,$08,$23 ; B650
        .byte   $22,$08,$11,$12,$08,$13,$08,$23,$22,$08,$08,$08,$08,$08,$08,$23 ; B660
        .byte   $24,$25,$26,$27,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2A,$2B,$2C,$2D ; B670
; layout $02
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$11,$12,$08 ; B680
        .byte   $08,$08,$08,$13,$08,$08,$08,$08,$13,$08,$08,$08,$08,$08,$2E,$2F ; B690
        .byte   $08,$2E,$2F,$08,$08,$08,$08,$08,$08,$08,$08,$08,$30,$31,$32,$08 ; B6A0
        .byte   $33,$34,$35,$08,$36,$37,$38,$16,$39,$20,$3A,$16,$08,$3B,$08,$08 ; B6B0
; layout $03
        .byte   $3C,$3D,$3E,$03,$04,$00,$05,$00,$08,$08,$3F,$09,$0A,$0B,$0C,$0D ; B6C0
        .byte   $08,$08,$08,$08,$08,$0F,$10,$08,$08,$11,$12,$08,$08,$08,$08,$08 ; B6D0
        .byte   $30,$31,$31,$32,$08,$08,$11,$12,$40,$41,$42,$43,$08,$30,$31,$32 ; B6E0
        .byte   $08,$44,$45,$46,$47,$36,$37,$38,$48,$49,$4A,$4B,$4C,$4D,$3B,$4E ; B6F0
; layout $04
        .byte   $06,$07,$08,$08,$2E,$2F,$4F,$08,$0E,$08,$2E,$2F,$08,$08,$4F,$08 ; B700
        .byte   $08,$08,$08,$08,$08,$08,$4F,$08,$13,$08,$08,$08,$08,$08,$50,$51 ; B710
        .byte   $08,$30,$31,$31,$32,$08,$52,$53,$08,$40,$41,$42,$43,$46,$54,$49 ; B720
        .byte   $46,$47,$44,$45,$48,$4B,$00,$00,$4B,$4C,$49,$4A,$55,$00,$00,$00 ; B730
; layout $05
        .byte   $2E,$2F,$56,$08,$08,$08,$08,$4E,$08,$08,$56,$08,$08,$08,$57,$58 ; B740
        .byte   $59,$5A,$5B,$08,$08,$08,$5C,$5D,$4F,$08,$5E,$08,$5A,$5F,$08,$0A ; B750
        .byte   $60,$61,$5B,$08,$08,$11,$12,$08,$62,$08,$63,$64,$65,$66,$67,$08 ; B760
        .byte   $68,$15,$08,$08,$08,$08,$4F,$08,$00,$69,$08,$08,$08,$08,$4F,$5E ; B770
; layout $06
        .byte   $00,$00,$00,$00,$00,$01,$02,$3C,$04,$00,$05,$00,$06,$07,$08,$08 ; B780
        .byte   $0A,$0B,$0C,$0D,$0E,$08,$08,$08,$6A,$3C,$10,$08,$08,$08,$11,$12 ; B790
        .byte   $4C,$6B,$08,$08,$08,$08,$08,$08,$6C,$0E,$6D,$6E,$6F,$63,$64,$65 ; B7A0
        .byte   $08,$08,$56,$08,$08,$2E,$2F,$08,$08,$08,$56,$08,$08,$08,$08,$08 ; B7B0
; layout $07
        .byte   $3D,$04,$00,$05,$00,$03,$04,$00,$08,$0A,$0B,$0C,$0D,$70,$71,$72 ; B7C0
        .byte   $5E,$08,$73,$74,$08,$08,$08,$08,$08,$08,$08,$08,$08,$11,$12,$08 ; B7D0
        .byte   $08,$08,$5E,$08,$5A,$5F,$08,$11,$08,$75,$34,$1A,$1C,$08,$08,$5A ; B7E0
        .byte   $08,$76,$77,$77,$78,$34,$1A,$1B,$08,$79,$1F,$20,$7A,$1F,$20,$1F ; B7F0
; layout $08
        .byte   $7B,$7C,$08,$3C,$3D,$7D,$7E,$00,$7F,$08,$08,$08,$08,$80,$81,$82 ; B800
        .byte   $08,$08,$08,$11,$12,$08,$08,$08,$08,$83,$08,$08,$08,$08,$11,$12 ; B810
        .byte   $84,$85,$86,$08,$08,$08,$08,$08,$5F,$08,$87,$08,$08,$08,$08,$08 ; B820
        .byte   $88,$1B,$89,$63,$64,$65,$8A,$14,$20,$7A,$8B,$08,$08,$4E,$58,$8C ; B830
; layout $09
        .byte   $06,$07,$08,$08,$08,$56,$11,$12,$0E,$08,$2E,$2F,$08,$8D,$67,$08 ; B840
        .byte   $08,$08,$08,$08,$08,$08,$4F,$08,$08,$08,$08,$08,$11,$12,$4F,$08 ; B850
        .byte   $08,$2E,$2F,$08,$08,$08,$8E,$8F,$08,$08,$08,$08,$08,$08,$08,$08 ; B860
        .byte   $15,$08,$08,$46,$47,$63,$64,$65,$90,$91,$4E,$4B,$4C,$4D,$08,$08 ; B870
; layout $0A
        .byte   $08,$56,$08,$08,$08,$08,$08,$4E,$08,$56,$08,$08,$16,$08,$57,$58 ; B880
        .byte   $08,$56,$11,$12,$08,$08,$5C,$5D,$15,$5A,$5F,$08,$08,$08,$08,$0A ; B890
        .byte   $69,$08,$08,$5A,$5F,$92,$08,$57,$62,$08,$08,$11,$12,$56,$08,$5C ; B8A0
        .byte   $68,$15,$08,$08,$08,$56,$08,$08,$00,$69,$08,$08,$08,$56,$08,$08 ; B8B0
; layout $0B
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$05,$00,$93 ; B8C0
        .byte   $00,$05,$00,$03,$04,$00,$7B,$0D,$0B,$0C,$0D,$70,$71,$72,$7F,$08 ; B8D0
        .byte   $3C,$10,$08,$08,$08,$08,$08,$94,$08,$08,$08,$16,$08,$94,$95,$96 ; B8E0
        .byte   $08,$97,$85,$98,$85,$99,$9A,$9B,$08,$9C,$9D,$9D,$9D,$9E,$9F,$A0 ; B8F0
; layout $0C
        .byte   $00,$7B,$0D,$0E,$08,$08,$71,$72,$06,$7F,$08,$08,$5E,$08,$A1,$66 ; B900
        .byte   $0E,$2E,$2F,$08,$08,$A2,$A3,$08,$08,$08,$08,$08,$A1,$66,$A4,$A5 ; B910
        .byte   $95,$A6,$08,$A2,$A3,$08,$11,$12,$9A,$A7,$95,$A8,$A9,$95,$A8,$A9 ; B920
        .byte   $9B,$9B,$9A,$9B,$9B,$9A,$9B,$9B,$AA,$9F,$A0,$AA,$9F,$A0,$9F,$A0 ; B930
; layout $0D
        .byte   $7F,$08,$11,$12,$08,$13,$08,$56,$A4,$66,$A4,$66,$A4,$AB,$08,$56 ; B940
        .byte   $08,$11,$12,$08,$08,$83,$08,$56,$66,$A4,$A5,$66,$A4,$AB,$5E,$56 ; B950
        .byte   $08,$08,$13,$08,$08,$16,$08,$56,$95,$A8,$A9,$95,$A8,$95,$A8,$AC ; B960
        .byte   $9A,$9B,$9B,$9A,$9B,$9B,$9A,$AD,$AA,$9F,$9F,$A0,$9F,$A0,$9F,$AE ; B970
; layout $0E
        .byte   $08,$4F,$08,$08,$08,$08,$08,$4E,$11,$AF,$08,$08,$08,$08,$57,$58 ; B980
        .byte   $08,$4F,$08,$08,$11,$12,$5C,$5D,$08,$4F,$08,$08,$08,$08,$08,$0A ; B990
        .byte   $2F,$B0,$16,$08,$08,$13,$08,$57,$19,$1C,$08,$08,$08,$08,$08,$5C ; B9A0
        .byte   $1E,$B1,$98,$85,$85,$98,$B2,$92,$A0,$A0,$9F,$A0,$A0,$9F,$B3,$56 ; B9B0
; layout $0F
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; B9C0
        .byte   $00,$00,$00,$00,$00,$05,$00,$93,$00,$05,$00,$03,$04,$00,$7B,$0D ; B9D0
        .byte   $0B,$0C,$0D,$70,$71,$72,$7F,$08,$3C,$10,$08,$08,$08,$08,$08,$08 ; B9E0
        .byte   $08,$59,$B4,$85,$98,$98,$85,$85,$08,$4F,$9E,$A0,$9F,$9F,$A0,$AA ; B9F0
; layout $10
        .byte   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00 ; BA00
        .byte   $03,$04,$00,$00,$00,$00,$00,$01,$70,$71,$04,$00,$05,$00,$06,$07 ; BA10
        .byte   $08,$08,$0A,$0B,$0C,$0D,$0E,$08,$5E,$08,$08,$3C,$10,$08,$08,$08 ; BA20
        .byte   $98,$B2,$08,$B5,$B5,$B5,$B5,$B5,$A0,$B3,$08,$08,$08,$11,$12,$08 ; BA30
; layout $11
        .byte   $00,$00,$00,$00,$00,$00,$00,$01,$00,$03,$04,$00,$00,$00,$06,$07 ; BA40
        .byte   $0D,$70,$0A,$0B,$0C,$0D,$0E,$08,$08,$08,$08,$3C,$10,$08,$08,$08 ; BA50
        .byte   $08,$08,$08,$08,$2E,$2F,$08,$08,$08,$5E,$08,$08,$08,$08,$08,$08 ; BA60
        .byte   $B5,$B5,$B5,$B5,$08,$B5,$B5,$B5,$08,$08,$08,$B6,$54,$91,$B7,$08 ; BA70
; layout $12
        .byte   $0D,$70,$0A,$0B,$0C,$0D,$0E,$B8,$08,$08,$08,$3C,$10,$08,$08,$B9 ; BA80
        .byte   $08,$11,$12,$08,$08,$08,$08,$B8,$08,$08,$08,$08,$08,$08,$08,$B9 ; BA90
        .byte   $08,$08,$08,$08,$08,$08,$11,$12,$08,$08,$08,$08,$08,$08,$08,$08 ; BAA0
        .byte   $B5,$B5,$13,$BA,$B5,$B5,$08,$83,$08,$08,$08,$B6,$54,$91,$B7,$83 ; BAB0
; layout $13
        .byte   $22,$08,$08,$08,$BB,$BC,$BC,$BD,$22,$11,$12,$08,$BE,$BF,$BF,$C0 ; BAC0
        .byte   $22,$08,$08,$08,$11,$12,$08,$23,$C1,$C2,$C2,$C2,$C2,$5B,$13,$23 ; BAD0
        .byte   $C3,$C4,$C4,$C4,$C4,$08,$08,$23,$22,$08,$08,$16,$08,$08,$08,$23 ; BAE0
        .byte   $24,$25,$26,$27,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2A,$2B,$2C,$2D ; BAF0
; layout $14
        .byte   $22,$08,$08,$C5,$C4,$C4,$C4,$C6,$C1,$C2,$C2,$5B,$60,$C2,$C2,$C7 ; BB00
        .byte   $C3,$C4,$C4,$11,$12,$C4,$C4,$C6,$22,$60,$C2,$C2,$C2,$C2,$5B,$23 ; BB10
        .byte   $22,$16,$C4,$C4,$C4,$C4,$08,$23,$22,$C8,$BC,$C9,$08,$C8,$BC,$BD ; BB20
        .byte   $22,$08,$BF,$CA,$11,$12,$BF,$C0,$22,$08,$08,$08,$08,$08,$08,$23 ; BB30
; layout $15
        .byte   $00,$03,$04,$00,$7B,$0D,$0E,$23,$0D,$70,$71,$72,$7F,$08,$08,$23 ; BB40
        .byte   $22,$08,$08,$08,$08,$08,$08,$23,$22,$08,$08,$08,$08,$11,$12,$23 ; BB50
        .byte   $22,$16,$08,$08,$08,$08,$08,$23,$22,$08,$08,$CB,$CC,$85,$98,$CD ; BB60
        .byte   $22,$60,$C2,$CE,$CF,$CF,$CF,$D0,$22,$08,$C4,$D1,$BF,$BF,$BF,$C0 ; BB70
; layout $16
        .byte   $3C,$3D,$04,$00,$05,$00,$03,$04,$08,$08,$0A,$0B,$0C,$0D,$70,$71 ; BB80
        .byte   $08,$08,$08,$0F,$10,$08,$08,$08,$08,$11,$12,$B8,$08,$08,$08,$08 ; BB90
        .byte   $08,$08,$D2,$B9,$08,$63,$64,$65,$D3,$1C,$D4,$B9,$13,$08,$08,$08 ; BBA0
        .byte   $79,$21,$D4,$B9,$08,$46,$47,$08,$08,$08,$D4,$B9,$4E,$4B,$4C,$4D ; BBB0
; layout $17
        .byte   $00,$7B,$7C,$71,$72,$7F,$3C,$3D,$72,$7F,$08,$08,$08,$08,$08,$08 ; BBC0
        .byte   $08,$08,$08,$5E,$08,$08,$08,$08,$16,$08,$08,$08,$08,$13,$08,$08 ; BBD0
        .byte   $08,$D2,$08,$08,$08,$08,$08,$08,$08,$D4,$08,$11,$12,$D5,$D6,$D7 ; BBE0
        .byte   $08,$D4,$D8,$34,$1A,$1B,$88,$34,$08,$D4,$D9,$20,$1F,$20,$1F,$20 ; BBF0
; layout $18
        .byte   $3E,$03,$04,$00,$05,$00,$06,$07,$3F,$09,$0A,$0B,$0C,$0D,$0E,$08 ; BC00
        .byte   $08,$08,$08,$0F,$10,$08,$08,$13,$5E,$08,$08,$08,$DA,$DB,$08,$08 ; BC10
        .byte   $08,$08,$DA,$DC,$DC,$DD,$08,$08,$DC,$DC,$DE,$DC,$DB,$08,$08,$08 ; BC20
        .byte   $19,$1B,$34,$19,$89,$08,$75,$19,$DF,$1F,$20,$DF,$8B,$08,$79,$DF ; BC30
; layout $19
        .byte   $E0,$E1,$E1,$E2,$E3,$08,$E4,$9B,$85,$E5,$85,$E6,$08,$08,$E7,$E8 ; BC40
        .byte   $9B,$9B,$E9,$08,$08,$EA,$9B,$9A,$19,$1C,$08,$08,$EB,$34,$1A,$1B ; BC50
        .byte   $1E,$EC,$08,$08,$ED,$EE,$EE,$EF,$9B,$F0,$08,$08,$08,$08,$08,$F1 ; BC60
        .byte   $19,$1A,$1B,$19,$34,$1A,$19,$34,$1E,$F2,$F2,$1E,$F2,$F2,$1E,$F2 ; BC70
; layout $1A
        .byte   $F3,$08,$08,$F4,$9A,$9B,$9A,$9B,$F5,$47,$8A,$14,$15,$46,$47,$08 ; BC80
        .byte   $E9,$4C,$58,$00,$90,$EA,$9A,$9B,$34,$1A,$1B,$34,$34,$1A,$1B,$34 ; BC90
        .byte   $EE,$EE,$EE,$EE,$EE,$EE,$EE,$EF,$08,$08,$08,$08,$08,$08,$08,$F1 ; BCA0
        .byte   $34,$19,$1B,$34,$34,$1A,$1B,$34,$F2,$1E,$F2,$F2,$F2,$F2,$F2,$F2 ; BCB0
; layout $1B
        .byte   $F6,$17,$17,$17,$17,$17,$17,$17,$F7,$00,$00,$00,$00,$00,$00,$F8 ; BCC0
        .byte   $F9,$7B,$72,$0B,$00,$00,$00,$F8,$FA,$7F,$08,$0F,$3D,$3E,$03,$FB ; BCD0
        .byte   $FC,$08,$08,$08,$08,$3F,$09,$FD,$08,$08,$08,$08,$08,$08,$08,$FE ; BCE0
        .byte   $34,$19,$1B,$34,$34,$1A,$19,$34,$F2,$1E,$F2,$F2,$F2,$F2,$1E,$F2 ; BCF0
; layout $1C
        .byte   $22,$08,$08,$08,$08,$08,$16,$23,$22,$11,$12,$08,$08,$08,$08,$23 ; BD00
        .byte   $22,$08,$08,$16,$08,$08,$08,$23,$22,$08,$08,$08,$08,$08,$08,$23 ; BD10
        .byte   $22,$08,$11,$12,$08,$13,$08,$23,$22,$08,$08,$08,$08,$08,$08,$23 ; BD20
        .byte   $22,$08,$08,$08,$08,$08,$08,$23,$22,$08,$08,$08,$08,$08,$08,$23 ; BD30
; layout $1D
        .byte   $00,$03,$04,$00,$7B,$0D,$0E,$23,$0D,$70,$71,$72,$7F,$08,$08,$23 ; BD40
        .byte   $22,$08,$16,$08,$08,$08,$08,$23,$22,$08,$08,$08,$08,$11,$12,$23 ; BD50
        .byte   $22,$16,$08,$08,$08,$08,$08,$23,$22,$08,$08,$CB,$CC,$85,$98,$CD ; BD60
        .byte   $24,$25,$26,$27,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2A,$2B,$2C,$2D ; BD70
; layout $1E
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BD80
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BD90
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BDA0
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BDB0
; layout $1F
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BDC0
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BDD0
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BDE0
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BDF0
; layout $20
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BE00
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BE10
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BE20
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BE30
; layout $21
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BE40
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BE50
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BE60
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BE70
; layout $22
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BE80
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BE90
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BEA0
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BEB0
; layout $23
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BEC0
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BED0
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BEE0
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BEF0
; layout $24
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BF00
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BF10
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BF20
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BF30
; layout $25
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BF40
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BF50
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BF60
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BF70
; layout $26
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BF80
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BF90
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BFA0
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BFB0
; layout $27
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BFC0
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BFD0
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BFE0
        .byte   $08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08,$08 ; BFF0
